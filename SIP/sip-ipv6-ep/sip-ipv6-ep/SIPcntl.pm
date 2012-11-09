#!/usr/bin/perl
#
# Copyright(C) IPv6 Promotion Council (2004,2005). All Rights Reserved.
# 
# This documentation is produced by SIP SWG members of Certification WG in 
# IPv6 Promotion Council.
# The SWG members currently include NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT), 
# Yokogawa Electric Corporation and NTT Advanced Technology Corporation (NTT-AT).
# 
# 
# Redistribution and use of this software in source and binary forms, with 
# or without modification, are permitted provided that the following 
# conditions and disclaimer are agreed and accepted by the user:
# 
# 1. Redistributions of source code must retain the above copyright 
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright 
# notice, this list of conditions and the following disclaimer in the 
# documentation and/or other materials provided with the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project which 
# is related to this software (hereinafter referred to as "project") nor 
# the names of the contributors may be used to endorse or promote products 
# derived from this software without specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written 
# notification to the copyrighters. However, using this software for the 
# purpose of testing or evaluating any products including merchantable 
# products may be permitted without any notification to the copyrighters.
# 
# 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING 
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE 
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT,STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
# THE POSSIBILITY OF SUCH DAMAGE.


# use strict;

# 
# 08/6/17 
#   vRecv2SIP:

#============================================
#    
#============================================

# 

# 
@SIP_AutoResponse=(
   {'Send' => 'Na_RouterGToTermL',    'Recv' => 'Ns_TermLtoRouterG'},
   {'Send' => 'Na_RouterLToTermL',    'Recv' => 'Ns_TermLtoRouterL'},
   {'Send' => 'Na_RouterLToTermG',    'Recv' => 'Ns_TermGtoRouterMultiL'},
   {'Send' => 'Na_RouterLToTermL',    'Recv' => 'Ns_TermLtoRouterMultiM'},
   {'Send' => 'Na_RouterLToTermG_TL', 'Recv' => 'Ns_TermGtoRouterMultiL_TL'},
 );

# 
$SIP_MSG_FILE    = "SIP-message";

# 
$SIP_TimeOut = 20;

# 
$SIP_Link = 'Link0';

# 
$SIP_CheckStatusMode = 'MD_TEST';

# 
$SIP_SendFrame='';
$SIP_RecvFrame='';
$SIP_UnKnownFrame='';

# 
$SIP_BASE_CPP='';


#============================================
#  
#============================================
%SIPNodeTbl;   # 
@SIPNodeTbl;   # 

# 
$SEQCurrentActNode;


#============================================
# 
#============================================

# 
#   SIP
sub SetNodeAddress {
    my ($cpp,$i);
    if($SIP_PL_IP eq 6){
	my ($server,$registra,$term,$dns,$routerPrefix,$other) = @_;
	if( $other  ){
	    for($i=0;$i<=$#$other;$i++){
		$cpp .= sprintf(" -DPSEUDO_SIP_OTHER%d=v6\\\(\\\"%s\\\"\\\)",$i+1,$other->[$i]->{'IPV6'}); 
		AddAAAA($other->[$i]->{'FQDN'},$other->[$i]->{'IPV6'});
	    }
	}
	elsif($SIP_OTHER_AAAA){
	    $cpp .= sprintf(" -DPSEUDO_SIP_OTHER1=v6\\\(\\\"%s\\\"\\\)",$SIP_OTHER_AAAA); 
	    SetNodeTemplateAddress('UA2',$SIP_OTHER_AAAA);
	}
	if( $routerPrefix  ){ $cpp .= " -DROUTER_PREFIX=\\\"$routerPrefix\\\""; }
	if( $dns     ){ $cpp .= " -DPSEUDO_DNS=v6\\\(\\\"$dns\\\"\\\)";SetNodeTemplateAddress('DNS',$dns); }
	if( $term    ){ $cpp .= " -DPSEUDO_SIP_TERM=v6\\\(\\\"$term\\\"\\\)"; SetNodeTemplateAddress('UA1',$term);}
	if( $registra){ $cpp .= " -DPSEUDO_REGISTRA=v6\\\(\\\"$registra\\\"\\\)"; SetNodeTemplateAddress('REG',$registra);}
	if( $server  ){ $cpp .= " -DPSEUDO_SIP_PROXY=v6\\\(\\\"$server\\\"\\\)"; SetNodeTemplateAddress('PX1',$server);}
	if( $CNT_CONF{'UA-PORT'} ne (($SIP_PL_TRNS eq "TLS")?"5061":"5060")){$cpp .= " -DSIP_UDP_DST_PORT=$CNT_CONF{'UA-PORT'}"; }
	if( $CVA_TUA_IPADDRESS){$cpp .= " -DSIP_TERM_GLOBAL=v6\\\(\\\"$CVA_TUA_IPADDRESS\\\"\\\)"; }

	MsgPrint('ACT',"SIP Proxy Server address [%s]\n",$server);
	MsgPrint('ACT',"SIP Registra Server address [%s]\n",$registra);
	MsgPrint('ACT',"SIP Terminal address [%s]\n",$term);
	MsgPrint('ACT',"DNS Server address [%s]\n",$dns);
	MsgPrint('ACT',"Router Prefix address [%s]\n",$routerPrefix);
	if($other){
	    for($i=0;$i<=$#$other;$i++){
		MsgPrint('ACT',"Other%d FQDN[%s] address[%s]\n",$i+1,$other->[$i]->{'FQDN'},$other->[$i]->{'IPV6'});
	    }
	}
    }
    if($SIP_PL_IP eq 4){
	my ($server,$registra,$term,$dns,$routerPrefix,$other) = @_;
	if( $other  ){
	    for($i=0;$i<=$#$other;$i++){
		$cpp .= sprintf(" -DPSEUDO_SIP4_OTHER%d=v4\\\(\\\"%s\\\"\\\)",$i+1,$other->[$i]->{'IPV4'}); 
		AddAAAA($other->[$i]->{'FQDN'},$other->[$i]->{'IPV4'});
	    }
	}
	elsif($SIP_OTHER_AAAA){
	    $cpp .= sprintf(" -DPSEUDO_SIP4_OTHER1=v4\\\(\\\"%s\\\"\\\)",$SIP_OTHER_AAAA); 
	    SetNodeTemplateAddress('UA2',$SIP_OTHER_AAAA);
	}
	if( $dns     ){ $cpp .= " -DPSEUDO_DNS4=v4\\\(\\\"$dns\\\"\\\)";SetNodeTemplateAddress('DNS',$dns); }
	if( $term    ){ $cpp .= " -DPSEUDO_SIP4_TERM=v4\\\(\\\"$term\\\"\\\)"; SetNodeTemplateAddress('UA1',$term);}
	if( $registra){ $cpp .= " -DPSEUDO_REGISTRA4=v4\\\(\\\"$registra\\\"\\\)"; SetNodeTemplateAddress('REG',$registra);}
	if( $server  ){ $cpp .= " -DPSEUDO_SIP4_PROXY=v4\\\(\\\"$server\\\"\\\)"; SetNodeTemplateAddress('PX1',$server);}
	if( $CNT_CONF{'UA-PORT'} ne (($SIP_PL_TRNS eq "TLS")?"5061":"5060")){$cpp .= " -DSIP_UDP_DST_PORT=$CNT_CONF{'UA-PORT'}"; }
	if( $CVA_TUA_IPADDRESS){$cpp .= " -DNUT_V4_ADDR=v4\\\(\\\"$CVA_TUA_IPADDRESS\\\"\\\)"; }

	MsgPrint('ACT',"SIP Proxy Server address [%s]\n",$server);
	MsgPrint('ACT',"SIP Registra Server address [%s]\n",$registra);
	MsgPrint('ACT',"SIP Terminal address [%s]\n",$term);
	MsgPrint('ACT',"DNS Server address [%s]\n",$dns);
	MsgPrint('ACT',"Router Prefix address [%s]\n",$routerPrefix);
	if($other){
	    for($i=0;$i<=$#$other;$i++){
		MsgPrint('ACT',"Other%d FQDN[%s] address[%s]\n",$i+1,$other->[$i]->{'FQDN'},$other->[$i]->{'IPV4'});
	    }
	}
    }
    MsgPrint('INF',"vCPP for initial [%s]\n",$cpp);
    vCPP($cpp);
    $SIP_BASE_CPP=$cpp;
}

#============================================
#    
#============================================
# 
sub NDDefStart {
    my($name,$tmpName,$callName,$other,$backGround)=@_;
    my($temp);
    # 
    $temp=$SIPNodeTempl{$name}||$SIPNodeTempl{$tmpName};
    if(!$temp){
	MsgPrint('ERR',"Can't find template node[$name]\n");
	return;
    }

    # 
    $SIPNodeTbl{$name}={'ID'=>$name,'RUN'=>'WAIT','TLNO'=>0,
			'CALL'=>SIPCreateNodeCallTbl($callName?$callName:($tmpName?$tmpName:$name)),
			'OTHER'=>$other,'BACK'=>$backGround, %$temp};
    # 
    push(@SIPNodeTbl,$SIPNodeTbl{$name});
    return $SIPNodeTbl{$name};
}
# 
sub NDDefEnd {
    my($node,$state)=@_;
    delete($node->{'LT'});
    # 
    if($state){$node->{'ST'}=$state;}
}

sub NDAddEvent {
    my($node,$reason)=@_;
    push(@SIPNodeEvent,{'ND'=>$node,'reason'=>$reason});
}

# 
#    
#       PKT:
#       COMMAND:
#       STATUS:*|STATUS
#       EX:
sub NDAddActionEx {
    my($node,$id,$func,$rule,$mode,$timeout,@matchList)=@_;
    my($stateTbls,$stateTbl,$matchList);
    
    # 
    if(!ref($node)){$node=$SIPNodeTbl{$node};}
    if(ref($node) ne 'HASH'){MsgPrint('ERR',"Node object illegal\n");return;}
    if(!$func || ($mode ne 'recv' && $mode ne 'send')){MsgPrint('ERR',"Action parameter illegal. Mode[%s]\n",$mode);return;}

    if(!$id){$id = 'ST:' . $node->{'TLNO'};}

    # 
    $matchList=MkRecvMatchList($node,@matchList);
    
    # 
    $stateTbl={'ID'=>$id,'FN'=>$func,'RR'=>$rule,'MD'=>$mode,'MatchList'=>$matchList,'Timeout'=>$timeout};

    # 
    $node->{'TL'}->{$id}=$stateTbl;

    # 
    if($node->{'LT'}){$node->{'LT'}->{'NX'}=$id;}
    $node->{'LT'}=$stateTbl;
    $node->{'TLNO'}++;

    # 
    if(!$node->{'ST'}){$node->{'ST'}=$id;}

    # 
}

# 
sub NDReqAction {
    my($node,$func,$command,$rule,$id,$timeout,$frame)=@_;
    
    # 
    if(!ref($node)){$node=$SIPNodeTbl{$node};}
    if(ref($node) ne 'HASH'){return;}

    # 
    if(!$id){$id = 'ST:' . $node->{'TLNO'};}
    # 
    if(!$timeout){$timeout=$SIP_TimeOut;}

    # 
    if($command eq 'START'){
	NDAddActionEx($node,$id,$func,$rule,'send',$timeout);
    }
    else{
	# 
	if(!$frame){$frame=$node->{'RFRAME'};}
	NDAddActionEx($node,$id,$func,$rule,'recv',$timeout,{'PKT'=>$frame,'COMMAND'=>$command});
    }
}
sub NDStatusAction {
    my($node,$func,$status,$rule,$id,$timeout,$frame)=@_;
    
    # 
    if(!ref($node)){$node=$SIPNodeTbl{$node};}
    if(ref($node) ne 'HASH'){return;}
    # 
    if(!$frame){$frame=$node->{'RFRAME'};}
    # 
    if(!$id){$id = 'ST:' . $node->{'TLNO'};}
    # 
    if(!$timeout){$timeout=$SIP_TimeOut;}

    NDAddActionEx($node,$id,$func,$rule,'recv',$timeout,{'PKT'=>$frame,'STATUS'=>$status});
}
sub NDGenericAction {
    my($node,$func,$start,$id,$timeout,$frame)=@_;
    
    # 
    if(!ref($node)){$node=$SIPNodeTbl{$node};}
    if(ref($node) ne 'HASH'){return;}

    # 
    if(!$id){$id = 'ST:' . $node->{'TLNO'};}
    # 
    if($timeout eq ''){$timeout=$SIP_TimeOut;}

    # 
    if($start eq 'START'){
	NDAddActionEx($node,$id,$func,'','send',$timeout);
    }
    else{
	# 
	if(!$frame){$frame=$node->{'RFRAME'};}
	NDAddActionEx($node,$id,$func,'','recv',$timeout,{'PKT'=>$frame});
    }
}

# 
sub NDActive {
    my($node)=@_;

    if(!ref($node)){$node=$SIPNodeTbl{$node};}
    if(ref($node) ne 'HASH'){return;}

    if($SEQCurrentActNode && $SEQCurrentActNode ne $node){
	SIPStoreNodeCallTbl($SEQCurrentActNode->{'CALL'});
    }
    # 
    $SEQCurrentActNode=$node;
    # 
    SIPLoadNodeCallTbl($node->{'CALL'});
}

# 
sub ND {
    return $SEQCurrentActNode->{'ID'};
}

# 
sub SIPCreateNodeCallTbl {
    my($node)=@_;
    my(%callTbl,$key,$tbl,$val);

    # 
    while(($key,$tbl)=each(%SIPCallVarTbl)){
	if( defined($CNT_CONF{$node . '_' . $key}) ){
	    $callTbl{$key}=$CNT_CONF{$node . '_' . $key};
	}
	else{
	    $val=$tbl->{'IV'}->{$NDTopology}->{$node};
	    if(ref($val) eq 'SCALAR'){
		$callTbl{$key}=eval $$val;
	    }
	    else{
		$callTbl{$key}=$val;
	    }
	}
    }
    return \%callTbl;
}

# 
sub SIPLoadNodeCallTbl {
    my($callTbl)=@_;
    my($key,$val,$varName);

    while(($key,$val)=each(%$callTbl)){
	$varName=$SIPCallVarTbl{$key}->{'VA'};
	if($SIPCallVarTbl{$key}->{'TY'} eq 'ARRAY'){
	    @{$varName}=@{$val};
	}
	else{
	    ${$varName}=$val;
        }
    }
}

# 
sub SIPStoreNodeCallTbl {
    my($callTbl)=@_;
    my($key,$val,$varName,@tmp,$tmp2,@msg,$i,$size,$mode);

    # 
    if(IsLogLevel('CALL')||IsLogLevel('CALLFULL')){
	$mode=IsLogLevel('CALLFULL');
	while(($key,$val)=each(%$callTbl)){
	    $varName=$SIPCallVarTbl{$key}->{'VA'};
	    if($SIPCallVarTbl{$key}->{'TY'} eq 'ARRAY'){
		@tmp=@{$varName};
		$tmp2=$callTbl->{$key};
		$size=$#tmp<$#$tmp2?$#$tmp2:$#tmp;
		for $i (0..$size){
		    if($tmp[$i] ne $tmp2->[$i]){
			push(@msg,sprintf(" %s%-23.23s[%s] (%s) => [%s]\n",'$',$varName,$i,$tmp2->[$i],$tmp[$i]));
		    }
                    elsif($mode){
			push(@msg,sprintf(" %s%-23.23s[%s] (%s)\n",'$',$varName,$i,$tmp2->[$i]));
                    }
		}
	    }
	    else{
		if( $callTbl->{$key} ne ${$varName} ){
		     push(@msg,sprintf(" %s%-23.23s    (%s) => [%s]\n",'$',$varName,$callTbl->{$key},${$varName}));
	        }
                elsif($mode){
		     push(@msg,sprintf(" %s%-23.23s    (%s)\n",'$',$varName,$callTbl->{$key}));
                }
            }
        }
	if(-1<$#msg){
	    printf("======== CALL[%s|%s] ========\n",$SEQCurrentActNode->{'ID'},$SEQCurrentActNode->{'ST'});
	    map{print $_} @msg;
	    printf("==================================\n");
	    LogHTML("</TD></TR><TR><TD>CALL[$SEQCurrentActNode->{'ID'}]</TD><TD><pre>");
	    map{LogHTML($_)} @msg;
	    LogHTML("</pre>");
	}
    }

    while(($key,$val)=each(%$callTbl)){
	$varName=$SIPCallVarTbl{$key}->{'VA'};
	if($SIPCallVarTbl{$key}->{'TY'} eq 'ARRAY'){
	    @tmp=@{$varName};
	    $callTbl->{$key}=[@tmp];
            @{$varName}=();
	}
	else{
	    $callTbl->{$key}=${$varName};
            ${$varName}='';
	}
    }
}

# 
sub NDGetOtherNode {
    my($node)=@_;
    my($i);
    if(!$node){$node=$SEQCurrentActNode;}
    if(!$node || !$node->{'OTHER'}){return '';}
    return $SIPNodeTbl{$node->{'OTHER'}};
}
sub NDStorePktInfo {
    my($pktinfo,$node)=@_;
    my($frame);
    if($pktinfo->{'pkt-type'} ne 'SIP'){return;}
    if(!$node){
	$frame=$pktinfo->{'dir'} eq 'recv' ? $pktinfo->{'pkt'}->{'recvFrame'}:$pktinfo->{'pkt'}->{'sendFrame'};
	$node=$SIPNodeTbl{GetNodeNameFromFrame($frame,$pktinfo->{'dir'})};
    }
    if($node){
	# 
	$pktinfo->{'Node'}=$node->{'ID'};
	# 
	push(@{$node->{'PKTS'}},$pktinfo);
	if($pktinfo->{'dir'} eq 'recv'){
	    $node->{'LastRecvPkt'}=$pktinfo;
	}
	else{
	    $node->{'LastSendPkt'}=$pktinfo;
	}
    }
}
# 
sub NDBackupPktInfo {
    my($node);
    foreach $node (@SIPNodeTbl){
	$node->{'PKTS.BAK'}=$node->{'PKTS'};
    }
}

# 
sub SetNodeTemplateAddress {
    my($nodeName,$addr,$recvFrame,$sendFrame)=@_;
    if($addr)     {$SIPNodeTempl{$nodeName}->{'AD'}=$addr;}
    if($recvFrame){$SIPNodeTempl{$nodeName}->{'RFRAME'}=$recvFrame;}
    if($sendFrame){$SIPNodeTempl{$nodeName}->{'SFRAME'}=$sendFrame;}
}
sub GetNodeNameFromFrame {
    my($franeName,$dir)=@_;
    my($key,$val,$name);
    while(($key,$val)=each(%SIPNodeTempl)){
	if($dir eq 'recv' && $franeName eq $val->{'RFRAME'}){$name=$key;}
	if($dir eq 'send' && $franeName eq $val->{'SFRAME'}){$name=$key;}
    }
    return $name;
}
sub GetNodeFrameFromName {
    my($nodeName)=@_;
    return $SIPNodeTempl{$nodeName}->{'SFRAME'},$SIPNodeTempl{$nodeName}->{'RFRAME'};
}

# 
sub SEQ_Start {
    my($node,$reason)=@_;

    # 
    if(!ref($node)){$node=$SIPNodeTbl{$node};}
    if(ref($node) ne 'HASH'){
	MsgPrint('ERR',"Node undefined,can't continue\n");
	exit;
    }
    # 
    $node->{'RUN'}='START';
    $node->{'TL'}->{$node->{'ST'}}->{'StartTime'}=time();

    if($reason){NDAddEvent($node,$reason);}
}

# 
sub SEQ_Wait {
    my(@nodes)=@_;
    my($node);

    foreach $node (@nodes){
	# 
	if(!ref($node)){$node=$SIPNodeTbl{$node};}
	if(ref($node) ne 'HASH'){next;}
	# 
	$node->{'RUN'}='WAIT';
    }
}

# 
sub SEQ_NodeRelation {
    my($nodeA,$nodeB)=@_;
    if($nodeA){
	$SIPNodeTbl{$nodeA}->{'OTHER'}=$nodeB;
	$SIPNodeTbl{$nodeB}->{'OTHER'}=$nodeA;
	$SEQNodeRelation='AlreadySetup';
    }
    elsif(!$SEQNodeRelation){
	if($NDTopology eq 'UA-PX'){SEQ_NodeRelation('UA1','PX1');}
	elsif($NDTopology eq 'UA-UA'){SEQ_NodeRelation('UA1','UA2');}
	elsif($NDTopology eq 'PX-PX'){SEQ_NodeRelation('PX1','PX2');}
    }
}

# 
sub SEQ_Run {
    my($link);
    my($node,@frames,$stateTbl,$ret,$next,$idx,$matchTbl,$pktinfo,$st,$acton,$i,
       @unknown,$totalFinishTime,$doing,$event);

    SEQ_NodeRelation();

    if(!$link){$link=$SIP_Link;}
    
    $totalFinishTime=time()+150;
    while(time()<$totalFinishTime){
	# START
      RESTART:
	foreach $node (@SIPNodeTbl){
	    if($node->{'RUN'} ne 'START'){next;}
	    $stateTbl=$node->{'TL'}->{$node->{'ST'}};
	    if($stateTbl->{'MD'} eq 'send'){
		# 
		($next,$ret)=SEQDoAction($node,$stateTbl,'send');
		if($ret eq 'ERROR'){goto EXIT;}
		# 
		SEQProceedState($node,$stateTbl,$next);
		next RESTART;
	    }
	}

	# START
	$idx=0;@frames=();$doing='';
	foreach $node (@SIPNodeTbl){
	    if($node->{'RUN'} ne 'START'){next;}
	    $stateTbl=$node->{'TL'}->{$node->{'ST'}};
	    if($stateTbl->{'MD'} eq 'recv'){
		if(!$node->{'BACK'}){$doing='T';}
		foreach $st (@{$stateTbl->{'MatchList'}}){
		    $frames[$idx]->{'RecvMode'}='stop';
		    $frames[$idx]->{'Recv'}=$st->{'PKT'};
		    $frames[$idx]->{'RecvMatch'}=$st->{'MATCH'};
		    $frames[$idx]->{'Node'}=$node;
		    $idx++;
		}
	    }
	}
	# 
	if(!$doing){last;}

	# 
	$acton='T';
	while($acton){

	    # 
	    $ret = CNT_SendAndRecv(\@frames,\@unknown,1,\@SIP_AutoResponse,$link);
	    if($ret eq 'OK'){
		# CNT_SendAndRecv
		$node='';
		for($i=0;$i<=$idx;$i++){
		    if($pktinfo=$frames[$i]->{'RecvStruct'}){
			$node=$frames[$i]->{'Node'};
			$stateTbl=$node->{'TL'}->{$node->{'ST'}};
			last;
		    }
		}
		if(!$node){
		    for($i=0;$i<=$idx;$i++){
			if($pktinfo=$frames[$i]->{'RecvFrame'}){
			    $node=$frames[$i]->{'Node'};
			    $stateTbl=$node->{'TL'}->{$node->{'ST'}};
			    last;
			}
		    }
		    if(!$node){MsgPrint('ERR',"Received message, but Node can't find\n");goto EXIT;}
		}

		# 
		($next,$ret)=SEQDoAction($node,$stateTbl,'recv',$pktinfo);
		if($ret eq 'ERROR'){goto EXIT;}
		# 
		SEQProceedState($node,$stateTbl,$next);
		$acton='';
	    }

	    # START
	    foreach $node (@SIPNodeTbl){
		if($node->{'RUN'} ne 'START'){next;}
		$stateTbl=$node->{'TL'}->{$node->{'ST'}};
		if(0<$stateTbl->{'Timeout'} && $stateTbl->{'StartTime'}+$stateTbl->{'Timeout'}<time()){
		    # 
		    ($next,$ret)=SEQDoAction($node,$stateTbl,'timeout');
		    if($ret eq 'ERROR'){goto EXIT;}
		    # 
		    SEQProceedState($node,$stateTbl,$next);
		    $acton='';
		}
	    }
	    # 
	    while($event=pop(@SIPNodeEvent)){
		# 
		$node=$event->{'ND'};
		$stateTbl=$node->{'TL'}->{$node->{'ST'}};
		($next,$ret)=SEQDoAction($node,$stateTbl,$event->{'reason'});
		if($ret eq 'ERROR'){goto EXIT;}
		# 
		SEQProceedState($node,$stateTbl,$next);
		$acton='';
	    }
	}
    }
 EXIT:
#    NDNodeDump();
    
    return;
}

# 
#   <
#     PKT:
#     COMMAND:
#     STATUS:*|STATUS
#     EX:
#   <
#     PKT:TAHI
#     MATCH:
sub MkRecvMatchList {
    my($node,@matchList)=@_;
    my($match,@innerMatchList,$i,$exp);
    $i=0;
    foreach $match (@matchList){
	$exp='';
	if($match->{'COMMAND'}){
	    if(ref($match->{'COMMAND'}) eq 'ARRAY'){
		$exp=\('MatchSIPRequest([' . join(',',@{$match->{'COMMAND'}}) . '],@_)' );
	    }
	    else{
		$exp=\(q{MatchSIPRequest('} . $match->{'COMMAND'} . q{',@_)});
            }
        }
        elsif($match->{'STATUS'}){
	    $exp=\(q{MatchSIPStatus('} . $match->{'STATUS'} . "','" . $match->{'REASON'} . q{',@_)});
        }
        elsif($match->{'EX'}){
            $exp=$match->{'EX'};
        }
        if($match->{'PKT'}){
            $innerMatchList[$i]->{'PKT'}=$match->{'PKT'};
            $innerMatchList[$i]->{'MATCH'}=$exp;
        }
        if(!$innerMatchList[$i]->{'PKT'} && !$innerMatchList[$i]->{'MATCH'}){
            MsgPrint('ERR',"Recv message match pattern illegal\n");
        }
        $i++;
    }
    return \@innerMatchList;
}

# 
sub SEQDoAction {
    my($node,$stateTbl,$event,$pktinfo)=@_;
    my(@next);

    if($stateTbl->{'FN'}){
	# 
	$SEQCurrentActNode=$node;
	# 
	SIPLoadNodeCallTbl($node->{'CALL'});
	# 
	if($stateTbl->{'RR'} && ($event eq 'OK' || $event eq 'recv')){
	    MsgPrint('ACT',"DoAction rule eval, before call action[%s]\n",$stateTbl->{'RR'});
	    EvalRule($stateTbl->{'RR'},$pktinfo);
	}
	# 
	MsgPrint('ACT',"<<=Action Node[%s] ST[%s] Event[%s]\n",$node->{'ID'},$stateTbl->{'ID'},$event);
	@next=$stateTbl->{'FN'}->($event,$pktinfo,$pktinfo?{%{$pktinfo->{'pkt'}->{'Connection'}}}:'');
	# 
	SIPStoreNodeCallTbl($node->{'CALL'});
	return @next;
    }
    else{
	MsgPrint('ERR',"Can't do action. Node[%s] ST[%s] state table not found action\n",$node->{'ID'},$stateTbl->{'ID'});
    }
    return '';
}

# 
sub SEQProceedState {
    my($node,$stateTbl,$next)=@_;
    my($oldstate);

    $oldstate=$node->{'ST'};

    if($next eq 'NEXT'){
	$node->{'ST'}=$stateTbl->{'NX'};
	if($node->{'ST'} && $node->{'TL'}->{$node->{'ST'}}){$node->{'TL'}->{$node->{'ST'}}->{'StartTime'}=time();}
    }
    elsif($next eq 'CONTINUE'){
    }
    elsif($next eq 'END'){
	$node->{'RUN'}='STOP';
	$node->{'ST'}='';
	MsgPrint('ACT',"Node[%s] finished\n",$node->{'ID'});
    }
    elsif($next eq 'WAIT'){
	$node->{'RUN'}='WAIT';
	$node->{'ST'}=$stateTbl->{'NX'};
    }
    elsif(!ref($next)){
	$node->{'ST'}=$next;
	if($node->{'ST'} && $node->{'TL'}->{$node->{'ST'}}){$node->{'TL'}->{$node->{'ST'}}->{'StartTime'}=time();}
    }
    elsif(ref($next) eq 'HASH'){
	$node->{'ST'}=$next->{'ID'};
	if($node->{'ST'} && $node->{'TL'}->{$node->{'ST'}}){$node->{'TL'}->{$node->{'ST'}}->{'StartTime'}=time();}
    }
    else{
	MsgPrint('ERR',"Proceed state illegal event\n");
    }
    if($node->{'RUN'} ne 'STOP' && (!$node->{'ST'} || !$node->{'TL'}->{$node->{'ST'}})){
	MsgPrint('ERR',"Node[%s] Event[%s] State[%s] illegal state\n",$node->{'ID'},$next,$node->{'ST'});
    }
    MsgPrint('ACT',"=>>Action Node[%s] Event[%s] State[%s]=>[%s] restTime[%s]\n",
	     $node->{'ID'},$next,$oldstate,$node->{'ST'},
	     $node->{'TL'}->{$node->{'ST'}}->{'StartTime'}+$node->{'TL'}->{$node->{'ST'}}->{'Timeout'}-time());
}

# 
sub NDNodeDump {
    my($node)=@_;
    my($state);
    printf("*** Current Time [%s] ***\n",time());
    if($node){
	$node=ref($node) eq 'HASH'?$node:$SIPNodeTbl{$node};
	$state=$node->{'TL'}->{$node->{'ST'}};
	printf("*** Node[%s] AD[%s] RUN[%s] ST[%s] StartTime[%s] Timeout[%s]\n",
	       $node->{'ID'},$node->{'AD'},$node->{'RUN'},$node->{'ST'},
	       $state->{'StartTime'},$state->{'Timeout'});
	PrintVal($node->{'CALL'});
    }
    else{
	foreach $node (@SIPNodeTbl) {
	    $state=$node->{'TL'}->{$node->{'ST'}};
	    printf("*** Node[%s] AD[%s] RUN[%s] ST[%s] StartTime[%s] Timeout[%s]\n",
		   $node->{'ID'},$node->{'AD'},$node->{'RUN'},$node->{'ST'},
		   $state->{'StartTime'},$state->{'Timeout'});
	    NDVarDump($node);
	}
    }
}

sub NDVarDump {
    my($node,$comment)=@_;
    my($i,$vars,$key,$val,@msg,@msg2,$name);
    $vars=$node->{'CALL'};

    while(($key,$val)=each(%$vars)){
	$name=$SIPCallVarTbl{$key}->{'VA'};
	if(ref($val) eq 'ARRAY'){
	    push(@msg,sprintf("  %s%-23.23s (%-23.23s) = [%s]\n",'$',$name,$key,join(', ',@$val)));
        }
        else{
	    push(@msg,sprintf("  %s%-23.23s (%-23.23s) = [%s]\n",'$',$name,$key,$val));
        }
    }
    push(@msg2,sprintf("  %s%-23.23s (%-23.23s) = [%s]\n",'$','CNT_TUA_HOSTPORT','',$CNT_TUA_HOSTPORT));

    printf("------------ Node Vars (%s)------------\n",$comment);
    @msg=sort(@msg);map{printf($_);} @msg;
    @msg2=sort(@msg2);map{printf($_);} @msg2;
    printf("-----------------------------------\n");
}

#============================================
# VCPP
#============================================
sub SetupVCPPString {
    my($cpp,$setup)=@_;
    $cpp=$SIP_BASE_CPP . $cpp;
#    PrintItem($cpp);
    if($setup){
	MsgPrint('PKT',"vCPP changed [$cpp]\n");
	vCPP( $cpp );
    }
    else{
	# 
	$cpp =~ s/\\/\\\\/g;
	$cpp =~ s/\(/\\\(/g;
	$cpp =~ s/\)/\\\)/g;
	$cpp =~ s/"/\\"/g;
#	PrintItem($cpp);
#	PrintItem(eval "sprintf \"$cpp\"");
    }
    return $cpp;
}

#============================================
# 
#============================================
sub ChangeTNPortNo {
    my($portNo)=@_;
    if($SIP_BASE_CPP =~ /DSIP_UDP_SRC_PORT=[0-9]+/){
	$SIP_BASE_CPP =~ s/DSIP_UDP_SRC_PORT=[0-9]+/DSIP_UDP_SRC_PORT=$portNo/;
    }
    else{
	$SIP_BASE_CPP = $SIP_BASE_CPP . " -DSIP_UDP_SRC_PORT=$portNo";
    }
    SetupVCPPString("",'T');
}

# NUT
sub SetNutMacAddress {
    my ($mac) = @_;
    my (@hex,@oct);
    @hex=split(/:/,$mac);
    @oct=map(hex,@hex);
    $CVA_TUA_IPADDRESS=sprintf("%s%02x%02x:%02xff:fe%02x:%02x%02x",
			     $SIP_RouterPrefix,(shift @oct)|0x02,shift @oct,shift @oct,@oct);
}

#============================================
# CNT_SendAndRecv 
#============================================

# SendAnsRecv 
#  
#    
#
#  
# 1) SendMode
#    
#    
#      vCPP
#      vSend
# 2) 
#    
#      
#      cpp 
# 3) 
#    
#      
#      cpp 
# 4) cpp
# 5) 
# 6) 
#   6-1) vRecv
#   6-2) 
#   6-3) 
#      6-3-1) 
#      6-3-2) vSend
#      6-3-3) vCPP
#   6-4) 
#        
#        
#        
#   6-5) 
#   6-6) 
#        {RecvAction}
#        
#   6-7) 
#        
#        
#        6-7-1) 
#        6-7-2) 
#        6-7-3) 
#        6-7-4) 
#        6-7-5) 
#   6-8) 
#        {'RecvMode'}
#        {'RecvCount'}
sub CNT_SendAndRecv {
    my ($frames,$unknown,$timeout,$autoResponse,$link) = @_;
    my ($startTime,@recvFrames,@unknown,$cpp,$status,%ret,$dup,$tmp,$n,$i,$j,$count,$recvCpp,$sendCpp,
	$st,@recvCount,$pkt,$pktinfo,$partinfo,$displayCount);
    @recvFrames=();
    $status='OK';
    %ret=();
    
    # 
    $SIP_SendFrame='';
    $SIP_RecvFrame='';
    $SIP_UnKnownFrame='';

    # ========================================
    # 
    # ========================================
    for($i=0; $i<=$#$frames; $i++){
	if( ($$frames[$i]{'SendMode'} eq 'first') && ($$frames[$i]{'Send'} || $$frames[$i]{'SendAction'}) ){

	    if( $$frames[$i]{'SendAction'} ){
		# 
		$st = EvalExpression($$frames[$i]{'SendAction'},$$frames[$i],'',{'LINK:'=>$link,'CONNECTION'=>$$frames[$i]{'Connection'}});
	    }
	    else{
		# 
		if($$frames[$i]{'SendModf'}){
		    $cpp= eval "sprintf \"$$frames[$i]{'SendModf'}\"";
		    # print "send vCPP=" ,$cpp, "\n";
		    MsgPrint('PKT',"vCPP for send [%s]\n",$cpp);
		    vCPP( $cpp );
		}
		
		# 
		$dup = {};
		$count=$$frames[$i]{'SendCount'} ? $$frames[$i]{'SendCount'} : 1;
		for($n=0;$n<$count;$n++){
		    %$dup = vSEND($link, '', $$frames[$i]{'Send'} );
		    if( $dup->{status} != 0 ){
			LOG_Err("vSend status=$dup->{status}");
			ExitScenario('Fail');
		    }
		}
		
		# 
		if( $dup->{status} == 0 ){
		    $dup->{'sendFrame'}=$$frames[$i]{'Send'};
		    $$frames[$i]{'Status'}='Send';
		    $$frames[$i]{'SendFrame'}=$dup;
		    $SIP_SendFrame=$dup;
		}
	    }
	}
    }


    # ========================================
    # 
    # ========================================

    # 
    for($cpp='',$i=0; $i<=$#$frames; $i++){
	if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
	    $tmp = $$frames[$i]{'Recv'};
	    for($n=0;$n<=$#$tmp;$n++){
		push( @recvFrames,{'Frame'=>$$tmp[$n],'Connection'=>$$frames[$i]{'Connection'}} );
	    }
	}
	elsif( $$frames[$i]{'Recv'} ) {
	    push( @recvFrames,{'Frame'=>$$frames[$i]{'Recv'},'Connection'=>$$frames[$i]{'Connection'}} );
	}
	# 
	if($$frames[$i]{'RecvModf'} ne ''){
	    $cpp= $cpp . " " . $$frames[$i]{'RecvModf'};
	}
    }
    if(@recvFrames == 0){goto EXIT;}
    MsgPrint('PKT',"Waiting receive frames [%s]\n",@recvFrames);

    # 
    for($cpp='',$i=0; $i<=$#$autoResponse; $i++){
	if( ref($$autoResponse[$i]{'Recv'}) eq 'ARRAY'){
	    $tmp = $$autoResponse[$i]{'Recv'};
	    for($n=0;$n<=$#$tmp;$n++){
		push( @recvFrames,{'Frame'=>$$tmp[$n]});
	    }
	}
	else {
	    push( @recvFrames,{'Frame'=>$$autoResponse[$i]{'Recv'}});
	}
	# 
	if($$autoResponse[$i]{'RecvModf'} ne ''){
	    $cpp= $cpp . " " . $$autoResponse[$i]{'RecvModf'};
	}
    }
    # print "recvFrames => @recvFrames\n";

    # 
    if($cpp){
	$cpp= eval "sprintf \"$cpp\"";
	MsgPrint('PKT',"vCPP for receive [%s]\n",$cpp);
	vCPP( $cpp );
	$recvCpp=$cpp;
    }


    # 
    $startTime=time();

    # ========================================
    # 
    # ========================================
    while(time() < $startTime+$timeout){
	my $recv = '';
	my $send = '';

	# 
	$dup = {};

	# 
	%$dup = vRECV($link, 1, 0, 1, '', @recvFrames );

	# 
	if( $dup->{status}==2 ){
	    if( $SIP_PL_IP eq 6 && $dup->{'Frame_Ether.Packet_IPv6'} ){
		push( @$unknown,AddUnKnownInfo($dup,[map{$_->{'Frame'}}(@recvFrames)]) );
		MsgPrint('PKT',"vRecv2 unknown[%s]\n",$dup->{'Frame_Ether.Packet_IPv6'});
		goto NEXT;
	    }
	    if( $SIP_PL_IP eq 4 && $dup->{'Frame_Ether.Packet_IPv4'} ){
		push( @$unknown,AddUnKnownInfo($dup,[map{$_->{'Frame'}}(@recvFrames)]) );
		MsgPrint('PKT',"vRecv2 unknown[%s]\n",$dup->{'Frame_Ether.Packet_IPv4'});
		goto NEXT;
	    }
	}

	# 
	if( $dup->{status}!=0 ){
	    MsgPrint('PKT',"vRecv2 not receive[%s]\n",$dup->{status} eq 1?'TimeOut':($dup->{status} eq 2?'Unknown':$dup->{status}));
	    goto NEXT;
	}

	# 
	$pktinfo=StoreRecvSIPPktInfo($dup);

	# 
	if( ResponseAutoFrame($dup,$autoResponse,$recvCpp,$link) ){goto NEXT;}

	# 
	for($i=0; $i<=$#$frames; $i++){
	    if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
		# 
		$tmp = $$frames[$i]{'Recv'};
		for($n=0;$n<=$#$tmp;$n++){
		    if($dup->{'recvFrame'} eq $$tmp[$n]) {
			goto SENDRESPONSE2;
		    }
		}
	    }
	    else {
		# 
		if($dup->{'recvFrame'} eq $$frames[$i]{'Recv'}) {
		  SENDRESPONSE2:
		    # 
		    #if( $$frames[$i]{'RecvMatch'} && !($$frames[$i]{'RecvMatch'}->($dup)) ){
		    #	goto NEXT;
		    #}
		    if( $$frames[$i]{'RecvMatch'} &&
			!EvalExpression($$frames[$i]{'RecvMatch'},$$frames[$i],$pktinfo) ){
			next;
		    }
		    # 
		    $$frames[$i]{'RecvFrame'}=$dup;
		    $$frames[$i]{'Status'}='Recv';
		    $SIP_RecvFrame=$dup;
		    $recvCount[$i]++;
		    goto MATCH;
		}
	    }
	}
	goto NEXT;

      MATCH:

	# ========================================
	# 
	# ========================================
	if($$frames[$i]{'RecvCount'} && $$frames[$i]{'RecvMode'} ne 'lastsend' && 
	   $$frames[$i]{'RecvCount'} eq $recvCount[$i]){
	    goto EXIT;
	}

	# ========================================
	# 
	# ========================================
	if( $$frames[$i]{'RecvDisplay'} ){
	    $displayCount++;  # 
	    if(!ref($$frames[$i]{'RecvDisplay'})){
		MsgDisplay($$frames[$i]{'RecvDisplay'});
	    }
	    else{
		EvalExpression($$frames[$i]{'RecvDisplay'},$$frames[$i],$dup,{'DISPLAY-COUNT'=>$displayCount});
	    }
	}

	# ========================================
	# 
	# ========================================

	$sendCpp='';
	if( $$frames[$i]{'RecvAction'} ){
	    $st = EvalExpression($$frames[$i]{'RecvAction'},$$frames[$i],$dup,{'LINK:'=>$link,'CONNECTION'=>$$frames[$i]{'Connection'}});
	    # $st = $$frames[$i]{'RecvAction'}->($dup,\$sendCpp);
	    if($st && $$frames[$i]{'RecvMode'} eq 'actstop'){
		$status=$st;
		goto EXIT;
	    }
	}
	
	# ========================================
	# 
	# ========================================

	if(($$frames[$i]{'Send'} || $$frames[$i]{'SendAction'})&& $$frames[$i]{'SendMode'} eq 'response' ){

	    if( $$frames[$i]{'SendAction'} ){
		# 
		$st = EvalExpression($$frames[$i]{'SendAction'},$$frames[$i],'',{'LINK:'=>$link,'CONNECTION'=>$$frames[$i]{'Connection'}});
	    }
	    else{
		# 
		if($sendCpp || $$frames[$i]{'SendModf'}){
		    $sendCpp = $$frames[$i]{'SendModf'} . ' ' . $sendCpp;
		    $cpp= eval "sprintf \"$sendCpp\"";
		    # print "send vCPP=" ,$cpp, "\n";
		    MsgPrint('PKT',"vCPP for send [%s]\n",$cpp);
		    vCPP( $cpp );
		}
		
		# 
		$count=$$frames[$i]{'SendCount'} ? $$frames[$i]{'SendCount'} : 1;
		
		# 
		if( ref($$frames[$i]{'Send'}) eq 'ARRAY'){
		    $tmp = $$frames[$i]{'Send'};
		    for($n=0;$n<=$#$tmp;$n++){
			$dup = {};
			for($j=0;$j<$count;$j++){
			    %$dup = vSEND($link, '', $$tmp[$n] );
			    if( $dup->{status} != 0 ){
				LOG_Err("vSend status=$dup->{status}");
				ExitScenario('Fail');
			    }
			}
		    }
		}
		else{
		    $dup = {};
		    for($j=0;$j<$count;$j++){
			%$dup = vSEND($link, '', $$frames[$i]{'Send'} );
			if( $dup->{status} != 0 ){
			    LOG_Err("vSend status=$dup->{status}");
			    ExitScenario('Fail');
			}
		    }
		}
	    
		# 
		$dup->{'sendFrame'}=$$frames[$i]{'Send'};
		$$frames[$i]{'Status'}='Send';
		$$frames[$i]{'SendFrame'}=$dup;
		$SIP_SendFrame=$dup;
		
		# 
		if($sendCpp){
		    MsgPrint('PKT',"vCPP for send [%s]\n",$recvCpp ? $recvCpp : '');
		    vCPP( $recvCpp ? $recvCpp : '' );
		}
	    }
	}

	# ========================================
	# 
	# ========================================
	if($$frames[$i]{'RecvMode'} eq 'stop'){
	    goto EXIT;
	}
	if($$frames[$i]{'RecvCount'} &&  $$frames[$i]{'RecvCount'} eq $recvCount[$i]){
	    goto EXIT;
	}

      NEXT:
    }

    # ========================================
    # 
    # ========================================

    $status='TimeOut';

    # UnKnown
    if( $$unknown[0] ){
	$status='UnKnown';
	$SIP_UnKnownFrame=$unknown;
    }
    
  EXIT:
    MsgPrint('PKT',"SendAndRecv Status [%s]\n",$status);
    return($status);
}


# SIP
#  
#    
sub SIP_Send($$) {
    my ($frames,$link) = @_;
    my ($cpp, $status,$dup,$i,$j,$n,$count,$tmp);
    $status='OK';
    
    $SIP_SendFrame='';

    # 
    for($i=0; $i<=$#$frames; $i++){

	# ========================================
	# SIP
	# ========================================
	CNT_WriteSipMsg($$frames[$i]{'SipMsg'});
	
	# 
	if($$frames[$i]{'SendModf'}){
	    $cpp=eval "sprintf \"$$frames[$i]{'SendModf'}\"";
	    # print "send vCPP=" ,$cpp, "\n";
	    MsgPrint('PKT',"vCPP for send [%s]\n",$cpp);
	    vCPP( $cpp );
	}
	elsif($cpp) {
	    $cpp='';
	    MsgPrint('PKT',"vCPP for send [%s]\n",$cpp);
	    vCPP( $cpp );
	}
	
	# 
	$count=$$frames[$i]{'SendCount'} ? $$frames[$i]{'SendCount'} : 1;
	
	# ========================================
	# 
	# ========================================
	if( ref($$frames[$i]{'Send'}) eq 'ARRAY'){
	    $tmp = $$frames[$i]{'Send'};
	    for($n=0;$n<=$#$tmp;$n++){
		$dup = {};
		for($j=0;$j<$count;$j++){
		    %$dup = vSEND($link, $$frames[$i]{'Connection'}, $$tmp[$n] );
		    if( $dup->{status} != 0 ){
			LOG_Err("vSend status=$dup->{status}");
			ExitScenario('Fail');
		    }
		}
	    }
	}
	else{
	    $dup = {};
	    for($j=0;$j<$count;$j++){
		%$dup = vSEND($link, $$frames[$i]{'Connection'}, $$frames[$i]{'Send'} );
		if( $dup->{status} != 0 ){
		    LOG_Err("vSend status=$dup->{status}");
		    ExitScenario('Fail');
		}
	    }
	}

	# 
	$dup->{'sendFrame'}=$$frames[$i]{'Send'};
	$$frames[$i]{'Status'}='Send';
	$$frames[$i]{'SendFrame'}=$dup;
	$SIP_SendFrame=$dup;
    }

    # 
    for($i=0; $i<=$#$frames; $i++){
	if($$frames[$i]{'Status'} ne 'Send'){
	    $status='NG';
	}
    }

    return $status;
}


# SIP
#  
#    
sub SIP_Recv {
    my ($frames,$unknown,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 4 ){ $link=$SIP_Link; }
    if( $#_ < 3 ){ $autoResponse=\@SIP_AutoResponse; }
    my ($startTime,@recvFrames,$status,$dup,$tmp,$n,$i,$cpp,$recvCpp,$pktinfo,$partinfo);
    
    @recvFrames=();$status='OK';$cpp='';
    
    $SIP_RecvFrame='';
    $SIP_UnKnownFrame='';

    # 
    for($cpp='',$i=0; $i<=$#$frames; $i++){
	if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
	    $tmp = $$frames[$i]{'Recv'};
	    for($n=0;$n<=$#$tmp;$n++){
		push( @recvFrames,{'Frame'=>$$tmp[$n],'Connection'=>$$frames[$i]{'Connection'}});
	    }
	}
	else {
	    push( @recvFrames,{'Frame'=>$$frames[$i]{'Recv'},'Connection'=>$$frames[$i]{'Connection'}});
	}
	# 
	if($$frames[$i]{'RecvModf'} ne ''){
	    $cpp= $cpp . " " . $$frames[$i]{'RecvModf'};
	}
    }
    # 
    for($i=0; $i<=$#$autoResponse; $i++){
	if( ref($$autoResponse[$i]{'Recv'}) eq 'ARRAY'){
	    $tmp = $$autoResponse[$i]{'Recv'};
	    for($n=0;$n<=$#$tmp;$n++){
		push( @recvFrames,{'Frame'=>$$tmp[$n]});
	    }
	}
	else {
	    push( @recvFrames,{'Frame'=>$$autoResponse[$i]{'Recv'}});
	}
	# 
	if($$autoResponse[$i]{'RecvModf'} ne ''){
	    $cpp= $cpp . " " . $$autoResponse[$i]{'RecvModf'};
	}
    }
    # 
    if($cpp){
	$cpp= eval "sprintf \"$cpp\"";
	$recvCpp=$cpp;
	MsgPrint('PKT',"vCPP for recv [%s]\n",$cpp);
	vCPP( $cpp );
    }

    # 
    $startTime=time();

    # 
    while(time() < $startTime+$timeout){
	my $recv = '';
	my $send = '';

	# 
	$dup = {};

	# 
	%$dup = vRECV($link, 1, 0, 0, '', @recvFrames );

	# 
	if( $dup->{status}==2 ){
	    if( $SIP_PL_IP eq 6 && $dup->{'Frame_Ether.Packet_IPv6'} ){
		push( @$unknown,AddUnKnownInfo($dup,[map{$_->{'Frame'}}(@recvFrames)]) );
		goto NEXT;
	    }
	    if( $SIP_PL_IP eq 4 && $dup->{'Frame_Ether.Packet_IPv4'} ){
		push( @$unknown,AddUnKnownInfo($dup,[map{$_->{'Frame'}}(@recvFrames)]) );
		goto NEXT;
	    }
	}

	# 
	if( $dup->{status}!=0 ){
	    goto NEXT;
	}

	# 
	$pktinfo=StoreRecvSIPPktInfo($dup);

	# 
	if( ResponseAutoFrame($dup,$autoResponse,$recvCpp,$link) ){goto NEXT;}

	# 
	for($i=0; $i<=$#$frames; $i++){
	    if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
		$tmp = $$frames[$i]{'Recv'};
		for($n=0;$n<=$#$tmp;$n++){
		    if($dup->{'recvFrame'} eq $$tmp[$n]) {
			if($$frames[$i]{'RecvMsg'}){
			    # SIP
			    if($$frames[$i]{'RecvMsg'} eq $pktinfo->{command}->{tag} ||
			       $$frames[$i]{'RecvMsg'} eq $pktinfo->{command}->{$pktinfo->{command}->{tag}}->{method}){
				# 
				$$frames[$i]{'Status'}='Recv';
				$$frames[$i]{'RecvFrame'}=$dup;
				$$frames[$i]{'RecvStruct'}=$pktinfo; # 
				$SIP_RecvFrame=$dup;
			    }
			}
			else{
			    # 
			    $$frames[$i]{'Status'}='Recv';
			    $$frames[$i]{'RecvFrame'}=$dup;
			    $SIP_RecvFrame=$dup;
			}
		    }
		}
	    }
	    else {
		if($dup->{'recvFrame'} eq $$frames[$i]{'Recv'}) {
		    if($dup->{'recvFrame'} eq $$tmp[$n]) {
			# SIP
			if($$frames[$i]{'RecvMsg'} eq $pktinfo->{command}->{tag} ||
			   $$frames[$i]{'RecvMsg'} eq $pktinfo->{command}->{$pktinfo->{command}->{tag}}->{method}){
			    # 
			    $$frames[$i]{'Status'}='Recv';
			    $$frames[$i]{'RecvFrame'}=$dup;
			    $$frames[$i]{'RecvStruct'}=$pktinfo;  # 
			    $SIP_RecvFrame=$dup;
			}
		    }
		    else{
			# 
			$$frames[$i]{'Status'}='Recv';
			$$frames[$i]{'RecvFrame'}=$dup;
			$SIP_RecvFrame=$dup;
		    }
		}
	    }
	}
	
	# 
	for($i=0; $i<=$#$frames; $i++){
	    if($$frames[$i]{'Status'} ne 'Recv') {
		goto NEXT;
	    }
	}
	last;
      NEXT:
    }

    # 
    #   
    for($i=0; $i<=$#$frames; $i++){
	if($$frames[$i]{'Status'} ne 'Recv'){
	    if( $$unknown[0] ){
		$SIP_UnKnownFrame=$unknown;
		$status='UnKnown';
	    }
	    else {
		$status='TimeOut';
	    }
	    $$frames[$i]{'RecvStruct'}='';
	}
	else {
#	    SipInfoDump($$frames[$i]{'RecvStruct'});
	}
    }
  EXIT:
    return($status);
}

# 
sub ResponseAutoFrame {
    my($dup,$autoResponse,$recvCpp,$link)=@_;
    my($i,$pkt,$cpp,$snd);

    for($i=0; $i<=$#$autoResponse; $i++){
	if( (ref($$autoResponse[$i]{'Recv'}) eq 'ARRAY' && grep{$_ eq $dup->{'recvFrame'}} @{$autoResponse->[$i]->{'Recv'}}) ||
	    $dup->{'recvFrame'} eq $$autoResponse[$i]{'Recv'} ) {
	    $pkt={'pkt'=>$dup,'timestamp'=>$dup->{recvTime1},'dir'=>'recv'};
	    StoreNDPktInfo($pkt);
	    # 
	    if($$autoResponse[$i]{'SendModf'}){
		$cpp= eval "sprintf \"$$autoResponse[$i]{'SendModf'}\"";
		MsgPrint('PKT',"vCPP for autoResponse [%s]\n",$cpp);
		vCPP( $cpp );
	    }
	    # 
	    $snd={};
	    %$snd = vSEND($link, '', $$autoResponse[$i]{'Send'} );
	    if( $snd->{status} != 0 ){
		LOG_Err("vSend status=$snd->{status}");
		ExitScenario('Fail');
	    }
	    # 
	    if($$autoResponse[$i]{'SendModf'}){
		MsgPrint('PKT',"vCPP for autoResponse [%s]\n",$recvCpp ? $recvCpp : '');
		vCPP( $recvCpp ? $recvCpp : '' );
	    }
	    $snd->{'sendFrame'}=$$autoResponse[$i]{'Send'};
	    $pkt={'sendFrame'=>$$autoResponse[$i]{'Send'},'pkt'=>$snd,'timestamp'=>$snd->{sentTime1},'dir'=>'send'};
	    StoreNDPktInfo($pkt);
	    return NEXT;
	}
    }
    return ;
}

# 
sub StoreRecvSIPPktInfo {
    my($pkt)=@_;
    my($pktinfo,$partinfo,$msg);
    # 
    if( ($msg=$pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_SIP.message'}) ||
	($msg=$pkt->{'Frame_Ether.Packet_IPv4.Upp_UDP.Udp_SIP.message'}) ){
	$msg =~ s/\n/\r\n/g;
    }

    if($msg){
	# SIP
	($pktinfo,$partinfo) = SipParsePart($msg,"COMMAND");
	$pktinfo->{pkt}=$pkt;
	$pktinfo->{timestamp}=$pkt->{recvTime1};
	$pktinfo->{dir}='recv';
	# SIP
	StoreSIPPktInfo($pktinfo);
    }
    return $pktinfo;
}

# 
#   
#    (({UnKnown}
#    (({UnKnown}
sub AddUnKnownInfo()
{
    my ($unknown,$recvFrames) = @_;
    my ($i,$n,%unMatchInfo,%info,$info,@infos,@fileds);

    for($i=0; $i<=$#$recvFrames; $i++){

#	print("UnKnownFrameInfo==$$recvFrames[$i] $V6evalTool::fCnt\n");

	for($n=1;$n<=$V6evalTool::fCnt;$n++){

	    if( $V6evalTool::pktrevers[$n] =~ /^=+$$recvFrames[$i]=+$/mg){
		@fileds=();
		%info={};
#		while( $V6evalTool::pktrevers[$n] =~ /^ng compare .*$$recvFrames[$i].(\w+) received.*$/mg){
		while( $V6evalTool::pktrevers[$n] =~ /^ng compare .*\.(\w+) received.*$/mg){
		    push( @fileds, $1 );
		}
		%info = (Frame => $$recvFrames[$i], UnMatch => \@fileds);
		push( @infos, \%info );
	    }
	}
    }

#     if(0){
# 	for($n=0; $n<=$#infos; $n++){
# 	    print "UnKnownFrameInfo Frame=>",$infos[$n]->{Frame};
# 	    $info = $infos[$n]->{UnMatch};
# 	    for($i=0; $i<=$#$info; $i++){
# 		print " " , $$info[$i];
# 	    }
# 	    print "\n";
# 	}
#     }

    %unMatchInfo = (UnKnown => $unknown, Info => \@infos);
    return(\%unMatchInfo);
}

# 
sub Dump_UnKnownInfo {
    my ($unknown) = @_;
    my ($i,$n,$m,$infos,$info);

    for($i=0; $i<=$#$unknown; $i++){
	print "UnKnown Pkt=>" , $$unknown[$n]->{UnKnown},"\n";
	$infos=$$unknown[0]->{Info};
	for($n=0; $n<=$#$infos; $n++){
	    print "Match Frame =",$$infos[$n]->{Frame};
	    $info = $$infos[$n]->{UnMatch};
	    for($m=0; $m<=$#$info; $m++){
		print " " . $$info[$m];
	    }
	    print "\n";
	}
    }
}

# 
sub GetUnKnownInfo {
    my ($frameName, $unknown) = @_;
    if( $#_ < 1 ){ $unknown=$SIP_UnKnownFrame; }
    my ($i,$n,$infos,$info);

    for($i=0; $i<=$#$unknown; $i++){
	$infos=$$unknown[$i]->{Info};
	for($n=0; $n<=$#$infos; $n++){
#	    print "fr=" ,$frameName, "  Un=" ,$$infos[$n]->{Frame},"\n";
	    if( $frameName eq $$infos[$n]->{Frame} ){
		$info = $$infos[$n]->{UnMatch};
#		print "UnMatch=@$info\n";
		return @$info;
	    }
	}
    }
}


# 
sub UnKnownMatchPacket {
    my ($frameName,$unknown) = @_;
    if( $#_ < 1 ){ $unknown=$SIP_UnKnownFrame; }
    my ($n,$frame);

#    print "UnKnown Pkt Count[$#$unknown]\n";
    for($n=0; $n<=$#$unknown; $n++){
#	print "UnKnown Pkt=>" , $$unknown[$n]->{UnKnown},"\n";
	$frame=IsMatchPacket($frameName,$$unknown[$n]->{UnKnown});
	return $frame if($frame);
    }
    return '';
}


# 
sub GetREV {
    my ($pktName,$fieldName,$frame) = @_;
    if( $#_ < 2 ){ $frame=$SIP_RecvFrame; }
    my ($val,$field);
    $val='';
    $field=GetFieldName($pktName,$fieldName);
    if($frame ne '' && $field ne ''){
	$val = $$frame{$field};

	# TAHI
	if($pktName =~ '^SIP' && ($fieldName eq '' || $fieldName eq 'message')){
	    $val =~ s/\n/\r\n/g;
	}
    }
    MsgPrint('ERR',"######### Packet Name(%s) Field Value(%s) is NULL\n",$pktName,$fieldName) if($val eq '');
    return($val);
}

# 
sub GetSND {
    my ($pktName,$fieldName,$frame) = @_;
    if( $#_ < 2 ){ $frame=$SIP_SendFrame; }
    my ($val,$field);
    $val='';
    $field=GetFieldName($pktName,$fieldName);
    if($frame ne '' && $field ne ''){
	$val = $$frame{$field};
    }
    MsgPrint('ERR',"######### Packet Name(%s) Field Value(%s) is NULL\n",$pktName,$fieldName) if($val eq '');
    return($val);
}

# 
sub GetREVST {
    my ($frame) = @_;
    if( $#_ < 0 ){ $frame=$SIP_RecvFrame; }

    if($frame eq ''){
	MsgPrint('PKT',"######### Receive Packe is NULL\n");
	return '';
    }
    MsgPrint('PKT',"######### Packet Parse Data is NULL\n") if($$frame{'RecvStruct'} eq '');
    return $$frame{'RecvStruct'};
}

# 
sub GetFieldName {
    my ($pktName,$fieldName) = @_;
    my $base='';
    
    if($pktName eq 'SIP'){
	$base = 'Frame_Ether.Packet_IPv' . $SIP_PL_IP . '.Upp_UDP.Udp_SIP';
	if($fieldName==''){ return "$base.message"; }
    }
    elsif($pktName eq 'IPv6'){
	$base = 'Frame_Ether.Packet_IPv' . $SIP_PL_IP . '.Hdr_IPv' . $SIP_PL_IP;
    }
    elsif($pktName eq 'EchoRequest'){
	$base = 'Frame_Ether.Packet_IPv' . $SIP_PL_IP . '.ICMPv' . $SIP_PL_IP . '_EchoRequest';
    }
    elsif($pktName eq 'EchoReply'){
	$base = 'Frame_Ether.Packet_IPv' . $SIP_PL_IP . '.ICMPv' . $SIP_PL_IP . '_EchoReply';
    }
    elsif($pktName eq 'UDP'){
	$base = 'Frame_Ether.Packet_IPv' . $SIP_PL_IP . '.Upp_UDP.Hdr_UDP';
    }

    if($base eq ''){
	MsgPrint('ERR',"GetFieldName Packet Name[%s] unknown\n",$pktName);
    }
    return("$base.$fieldName");
}

# 
sub IsExistOpt {
    my ($optName,$frame) = @_;
    if( $#_ < 1 ){ $frame=$SIP_RecvFrame; }
    if($optName eq 'RH'){
	return (GetREV('IPv6','NextHeader',$frame) eq 43 && GetREV('RH','RoutingType',$frame) eq 2);
    }
    return '';
}

# 
sub IsMatchPacket {
    my ($frameName,$frame) = @_;
    if( $#_ < 1 ){ $frame=$SIP_RecvFrame; }

    if($frameName eq 'EchoReply'){
	if ( (GetREV('IPv6','NextHeader',$frame) eq 58 && GetREV('EchoReply','Type',$frame) eq 129) ||
	     (GetREV('IPv6','NextHeader',$frame) eq 43 && GetREV('EchoReply','Type',$frame) eq 129) ){
	    return $frame;
	}
    }
    if($frameName eq 'SIP'){
	if ( GetREV('IPv6','NextHeader',$frame) eq 17 && GetREV('UDP','DestinationPort',$frame) eq (($SIP_PL_TRNS eq "TLS")?"5061":"5060")) { 
	    return $frame;
	}
    }
    return '';
}


# 
#  
#    
sub CNT_Initilize {
    my ($link) = @_;
    my $ret;
    if( $#_ < 0 ){ $link=$SIP_Link; }
    else {$SIP_Link=$link;}
    
    CNT_WriteSipMsg('init');

    if($CNT_CONF{'INITIALIZE'} eq 'BOOT'){
	if(vRemote('reboot.rmt', '')) {
	    vLogHTML('<FONT COLOR="#FF0000">reboot.rmt: Can\'t reboot</FONT><BR>');
	    ExitScenario('Fatal');
	}
    }
    elsif($CNT_CONF{'INITIALIZE'} eq 'SIP'){
	MsgDisplay("Reboot NUT, and press Enter Key." .
		   ($SIP_ScenarioModel{'Regist'}?"\n    After reboot, this Scenario wait REGISTER":''));
	if(<STDIN>){;}
    }

    $ret = vCAPTURE($link);
    if( $ret ne 0 ){
	LOG_Err("vCapture status=$ret");
	ExitScenario('Fatal');
    }
    CNT_Mode('TEST');
    $SIP_RESULT=0;
}

# 
sub CNT_Mode {
    my ($mode) = @_;
    my($msg);
    $msg=sprintf('<font color=red size="4"><b>Scenario Operation[%s] Spec[%s] </b></font><font color=blue size="2"><A HREF="#SequenceSummary">          Sequence Summary</A></font><br><font color=red><b>ID</b></font>[%s]<br>',
		 '<font color=green>' . $SIP_ScenarioModel{Role} . '</font>',
		 '<font color=green>' . $CNT_CONF{"SPECIFICATION"} . '</font>',
#		 '<font color=green>' . (($mode eq 'INIT')?'initialization':'test') . '</font>'
    # 
		 '<font color=green>'.GetSrcID().'</font>'
		 );
    $SIP_CheckStatusMode = ($mode eq 'INIT')?'MD_INIT':'MD_TEST';
    vLogHTML($msg);
}

# 
sub CheckStatus ($) {
    my ($status) = @_;
    if($status ne 'OK' && $SIP_CheckStatusMode eq 'MD_INIT' ){
	LOG_Err("NG $status");
    }
}

#============================================
# TAHI SIP
#============================================
sub CNT_WriteSipMsg {
    my($msg) = @_;
#    print "$SIP_MSG_FILE $msg\n";
    open(OUT, "> " . $SIP_MSG_FILE);
    print OUT "$msg";
    close(OUT);
}

sub CNT_ReadSipMsg {
    my($msg,$line);
    open(IN, $SIP_MSG_FILE);
    while ($line=<IN>) {
	$msg .= $line;
    }
    close(IN);
    return $msg;
}

#============================================
# 
#============================================
#   
sub SD_SIP {
    my ($sipMsg,$sendFrame,$sendModf,$conn,$link) = @_;
    if( $link eq ''     ){ $link=$SIP_Link; }
    if( $sendFrame eq ''){ $sendFrame='SIP'; }

    my ($ret,@frames,@unknown,$pktinfo,$partinfo);
    @frames=({'Send'=>$sendFrame,'SendModf'=>$sendModf,'SipMsg'=>$sipMsg,'Connection'=>$conn});

    # 
    $ret = SIP_Send(\@frames,$link);
    CheckStatus($ret);

    # SIP
    if($ret eq 'OK'){
#	($pktinfo,$partinfo) = SipParsePart($sipMsg,"COMMAND");
	($pktinfo,$partinfo) = SipParsePart($sipMsg,'COMMAND');
	$pktinfo->{frame_txt}=$sipMsg;
	$pktinfo->{pkt}=$frames[0]{'SendFrame'};
	$pktinfo->{timestamp}=$frames[0]{'SendFrame'}->{sentTime1};
	$pktinfo->{dir}='send';
	StoreSIPPktInfo($pktinfo);

	# SIP
	# OutputSIPFrame($pktinfo);
    }
    return($ret);
}

#============================================
# 
#============================================
sub RV_SIP {
    my ($recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 4 ){ $link=$SIP_Link; }
#    if( $#_ < 3 ){ $autoResponse=\@SIP_AutoResponse; }
    if( $#_ < 2 ){ $timeout=$SIP_TimeOut; }
    if( $#_ < 0 ){ $recvFrame='SIPtoAny'; }

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= '';
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= '';
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';
    $frames[0]{'RecvStruct'}= '';

    # Frame Transmission
    $ret = SIP_Recv(\@frames,\@unknown,$timeout,$autoResponse,$link);
    CheckStatus($ret);
    return($ret);
}


#============================================
# SIP
#============================================

# RA
#   
sub SQ_RA_Router {
    my ($sendFrame,$sendModf,$link) = @_;
    if( $#_ < 2 ){ $link=$SIP_Link; }
    if( $#_ < 0 ){ $sendFrame='Ra_RouterToAllNode'; }

    my ($ret,@frames,@unknown,%pkt1,%pkt2,%pkt3,$cnt);

    # RA
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'SendMode'}= 'first';
    
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$SIP_TimeOut,'',$link);
    if($frames[0]{'SendFrame'}){
        $pkt1{pkt}=$frames[0]{'SendFrame'};
        $pkt1{timestamp}=$pkt1{pkt}->{sentTime1};
        $pkt1{dir}='send';
        StoreNDPktInfo(\%pkt1);
    }
    CheckStatus($ret);

    # NUT
    if($CVA_TUA_IPADDRESS){$ret='OK';goto SKIP;}

    # DAD
    sleep(3);

    # 
    @frames=();
    $frames[0]{'Send'}= 'Ns_RouterToAllNode';
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'SendMode'}= 'first';
    $frames[0]{'Recv'}= ['Na_TermAtoRouterG','Na_TermAtoRouterGOpt'];
    $frames[0]{'RecvMode'}= 'stop';
    $frames[0]{'SendFrame'}='';
    $frames[0]{'RecvFrame'}='';

    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$SIP_TimeOut,\@SIP_AutoResponse,$link);
    if($frames[0]{'SendFrame'}){
        $pkt2{pkt}=$frames[0]{'SendFrame'};
        $pkt2{timestamp}=$pkt2{pkt}->{sentTime1};
        $pkt2{dir}='send';
        StoreNDPktInfo(\%pkt2);
    }
    if($frames[0]{'RecvFrame'}){
        $pkt3{pkt}=$frames[0]{'RecvFrame'};
        $pkt3{timestamp}=$pkt3{pkt}->{recvTime1};
        $pkt3{dir}='recv';
        StoreNDPktInfo(\%pkt3);
    }

    # NUT
    $CVA_TUA_IPADDRESS = $frames[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.ICMPv6_NA.TargetAddress'};
    
    # RA
    if($SIP_PL_IP eq 6 && $SIP_PL_TARGET eq 'PX'){
	@frames=();
	$frames[0]{'Send'}= $sendFrame;
	$frames[0]{'SendMode'}= 'first';
	for($cnt=0;$cnt<=2;$cnt++){
	    CNT_SendAndRecv(\@frames,\@unknown,$SIP_TimeOut,'',$link);
	    if($cnt != 2){sleep(3);}
	}
    }

SKIP:
    MsgPrint('SEQ',"NUT FQDN[%s] V6address[%s] fixed in NA\n",$CNT_TUA_HOSTNAME,$CVA_TUA_IPADDRESS);
    CheckStatus($ret);
    return($ret);
}
# AAAA
sub SetFQDNRecord {
    if($SIP_PL_TARGET eq 'UA'){
	AddAAAA($CNT_TUA_HOSTNAME,$CVA_TUA_IPADDRESS);
	AddAAAA($CNT_CONF{'UA-HOSTNAME'},$CVA_TUA_IPADDRESS);
    }
    if($SIP_PL_TARGET eq 'PX'){
	# AAAA
	AddAAAA($CNT_CONF{'PUA-HOSTNAME'},$CNT_CONF{'PX1-ADDRESS'});
	AddAAAA($CNT_CONF{'PX1-HOSTNAME'},$CNT_CONF{'PX1-ADDRESS'});
	AddAAAA($CNT_CONF{'UA-CONTACT-HOSTNAME'},$CNT_CONF{'PUA-ADDRESS'});
	AddAAAA($CNT_CONF{'UA-HOSTNAME'},$CNT_CONF{'PUA-ADDRESS'});
    }
}




#============================================
# 
#============================================
sub MatchSIPmsg {
    my($request,$pktinfo)=@_;
    
    if($pktinfo eq ''){return '';}

    # SIP
    $request->{'RecvStruct'}=$pktinfo;
    MsgPrint('PKT', "SIP receive\n");

    return 'MATCH';
}
# SIP
#   
sub MatchSIPRequest {
    my($method,$request,$pktinfo)=@_;

    my($name,$i);

    # 
    if( !$pktinfo || !($name = $pktinfo->{command}->{$pktinfo->{command}->{tag}}->{method}) ){return '';}

    # SIP
    if( $method ){
	if( ref($method) eq 'SCALAR'){
	    if( EvalExpression($method,'',$pktinfo,'') eq '' ){return '';}
	}
	elsif( ref($method) eq 'ARRAY' ){
	    for($i=0;$i<=$#$method;$i++){
		if($method->[$i] eq $name){goto MATCH;}
	    }
	    return '';
	}
	elsif( $method ne $name ){return '';}
    }
MATCH:
    # SIP
    $request->{'RecvStruct'}=$pktinfo;
    MsgPrint('PKT', "SIP receive request[%s] matched\n",(ref($method)eq'SCALAR')?$$method:$method);

    return 'MATCH';
}
# SIP
# ex) MatchSIPStatus('^[12]..$','',...);  
sub MatchSIPStatus {
    my($code,$reason,$request,$pktinfo)=@_;

    my($pktCode,$pktReason);

    # 
    if(!$pktinfo){return '';}
    $pktCode=$pktinfo->{command}->{$pktinfo->{command}->{tag}}->{code};
    $pktReason=$pktinfo->{command}->{$pktinfo->{command}->{tag}}->{reason};
    if(!$pktCode || !$pktReason){return '';}

    # SIP
    if( $code ){
	if( ref($code) eq 'SCALAR'){
	    if( EvalExpression($code,'',$pktinfo,'') eq '' ){return '';}
	}
	elsif( !($pktCode =~ /$code/) ){return '';}
    }
    if($reason){
	if( !($pktReason =~ /$reason/) ){return '';}
    }

    # SIP
    $request->{'RecvStruct'}=$pktinfo;
    MsgPrint('PKT', "SIP receive status[%s] reason[%s] matched\n",$pktCode,$pktReason);

    return 'MATCH';
}
# SIP
#   
sub MatchSIPRule {
    my($rule,$request,$pktinfo)=@_;
    my($result,$item);

    # 
    $result=EvalRule($rule,$pktinfo);

    # 
    foreach $item (@$result){
	if($item->{'RE:'} eq ''){return '';}
    }

    # SIP
    $request->{'RecvStruct'}=$pktinfo;

    MsgPrint('PKT', "SIP packet matched rules\n");
    return 'MATCH';
}

# 
sub EvalEncodeRuleAndSend {
    my($encodeRule,$pktinfo,$frame,$addrule,$delrule,$conn,$link)=@_;
    if( $link eq ''){ $link=$SIP_Link; }

    my($result,$msg,$ret);

    # 
    $encodeRule = RuleModify($encodeRule,$addrule,$delrule);

    # 
    if( !($result=EvalRule($encodeRule,$pktinfo)) ){
	return 'ActionError';
    }
    if( !($msg=GetKeyVal($result,'EX:')) ){
	MsgPrint('ERR', "Can't create SIP message\n");
	return 'ActionError';
    }
    # 
    $ret = SD_SIP($msg,$frame,'',$conn,$link);
    return $ret;
}

# 
sub RecActCapturing {
    my($request,$recvFrame,$context)=@_;

    my($pktinfo);

    # SIP
    if( !($pktinfo=$request->{'RecvStruct'}) ){
	MsgPrint('ERR', "SIP Structured data is not exist,skip send response\n");
	return 'ActionError';
    }
    return '';
}

# 
#   
#         CNT_SendAndRecv
sub RecActEvalRuleAndResponse {
    my($decodeRule,$encodeRule,$responseFrame,$request,$recvFrame,$context)=@_;

    my($result,$pktinfo,$msg,$ret,$link);
    $link=$context->{'LINK:'};

    # SIP
    if( !($pktinfo=$request->{'RecvStruct'}) ){
	MsgPrint('ERR', "SIP Structured data is not exist,skip send response(RecActEvalRuleAndResponse)\n");
	return 'ActionError';
    }

    # 
    if( $decodeRule ){
	if( !($result=EvalRule($decodeRule,$pktinfo)) ){
	    MsgPrint('ERR', "Eval decode rule error,skip send response\n");
	    return 'ActionError';
	}
    }

    # 
    if( $encodeRule ){
	if( !($result=EvalRule($encodeRule,$pktinfo)) ){
	    MsgPrint('ERR', "Eval encode rule error,skip send response\n");
	    return 'ActionError';
	}
	# 
	if( !($msg=GetKeyVal($result,'EX:')) ){
	    MsgPrint('ERR', "Can't create SIP message\n");
	    return 'ActionError';
	}
	# 
	$ret = SD_SIP($msg,$responseFrame,'',$recvFrame->{'Connection'},$link);
	MsgPrint('PKT', "AutoResponse done encoderule(%s)\n",$encodeRule);
    }

    return '';
}

package V6evalTool;

sub
vRecv2SIP($$$$@)
{
	my ($ifname, $timeout, $seektime, $count, @frames) = @_;

	my $cmd  = "$ToolDir/pktrecv $BaseArgs";
	   $cmd .= " -i $ifname"	if($ifname);
	   $cmd .= " -e $timeout"	if($timeout >= 0);
	   $cmd .= " -s $seektime"	if($seektime);
	   $cmd .= " -c $count"		if($count);
	   $cmd .= " @frames";

	my $timestr = getTimeStamp();

# 	if($vLogStat == $vLogStatOpenRow){
# 		prLog("</TD>\n");
# 		prLog("</TR>");
# 	}

# 	prLog("<TR VALIGN=\"top\"><TD>$timestr</TD>");
# 	prLog("<TD>vRecv($ifname,@frames)". 
# 	      " timeout:$timeout cntLimit:$count seektime:$seektime<BR>");

	my $fCnt = 0;

	my ($status, @lines) = execCmd($cmd);

	my %ret = getField2(@lines);
	$ret{'status'} = $status;

	undef(@pktrevers);

	foreach(@lines){
	        # 
		if($_ =~ /^\s*(\d+\.\d+)\s+(\S*)$/ ) {
			$fCnt ++;
			$ret{"recvTime${fCnt}"}	= $1;
			$ret{'recvFrame'}	= $2;
		} else {
			$pktrevers[$fCnt + 1] .= "$_\n";
		}
	}
#	main::PrintVal(\@pktrevers);
	undef($ret{'recvFrame'}) if($ret{'recvFrame'} eq '-');

	$ret{'recvCount'} = $fCnt;

	for(my $i = 1; $i <= $fCnt; $i ++){
		my $recvtime = getTimeString($ret{"recvTime${i}"});

# 		if(($i != $fCnt) || ($ret{'status'})){
# 			prLog("<A NAME=\"vRecv${vRecvPKT}\"></A>");

# 			if(@frames){
# 				prLog("<A HREF=\"#vRecvPKT${vRecvPKT}\">recv unexpect packet at $recvtime</A>");
# 			} else {
# 				prLog("<A HREF=\"#vRecvPKT${vRecvPKT}\">recv a packet at $recvtime</A>");
# 			}

# 			prLog("<BR>");
# 		}

		# 
		$pktrevlog .= "<A NAME=\"vRecvPKT${vRecvPKT}\"></A>";
#		$pktrevlog .= "<A HREF=\"#vRecv${vRecvPKT}\">Recv at $recvtime</A>\n";
#		$pktrevlog .= "<A HREF=\"#SequenceSummary\">Recv at $recvtime</A>\n";
		$pktrevlog .= sprintf("<A HREF=\"#SEQ-%04d\">Recv at $recvtime</A>\n",${vRecvPKT});
		$pktrevlog .= "<PRE STYLE=\"line-height:70%\">";

		my $Xpktrevers = $pktrevers[$i];

		$Xpktrevers =~ s/&/&amp;/g;
		$Xpktrevers =~ s/"/&quot;/g;
		$Xpktrevers =~ s/</&lt;/g;
		$Xpktrevers =~ s/>/&gt;/g;

		$pktrevlog .= $Xpktrevers;

		$pktrevlog .= "</PRE><HR>";

                # 
                $ret{'recvFrameIndex'}=$vRecvPKT;
		$vRecvPKT ++;
	}

	if($ret{'status'} >= 3){
		prErrExit("vRecv() return status=$ret{status}\n");
	}

# 	if($ret{'status'}){
# 		prLog("vRecv() return status=$ret{status}");
# 	} else {
# 		$_ = $ret{'recvFrame'};

# 		$vRecvPKT --;

# 		if($main::pktdesc{$_}){
# 			$msg = "$main::pktdesc{$_}";
# 		} else {
# 			$msg = "recv $_";
# 		}

# 		prOut(HTML2TXT($msg));
# 		prLog("<A NAME=\"vRecv${vRecvPKT}\"></A>");
# 		prLog("<A HREF=\"#vRecvPKT${vRecvPKT}\">$msg</A><BR>");

# 		$vRecvPKT ++;
# 	}

# 	prLog("\n");
# 	prLog("</TD>\n");
# 	prLog("</TR>\n");
#	$vLogStat = $vLogStatCloseRow;

	return(%ret);
}

########################################################
1
