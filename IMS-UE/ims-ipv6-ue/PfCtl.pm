#!/usr/bin/perl
# @@ -- Node.pm --
# Copyright (C) NTT Advanced Technology 2007
#
# Copyright(C) IPv6 Promotion Council (2004-2010). All Rights Reserved.
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
# 09/1/27  bytecode

## DEF.VAR
#============================================
#  
#============================================
@NDNodeTbl;   # 

# 
@NDNodeEvent;

# 
$TOTAL_RUNNING=600;
## DEF.END

#============================================
#  
#============================================
sub CtNDRegTempl {
    my($nodeTemp)=@_;
    CtTbCtiSet('SC,NDTMP',$nodeTemp,'T');
}
sub CtNDAddTempl {
    my($node,$nodeTemp)=@_;
    $DIRRoot{'SC'}->{'NDTMP'}->{$node}=$nodeTemp;
}

#============================================
#  
#============================================
# OTHER:
# 
sub CtNDDef {
    my($name,$tmpName,$link,$recvConn,$backGround,$extTbl,$nonIO,$addcap)=@_;
    my($temp,$tbl,@keys,$key,$node,$nodeTempl,$topology,$topologyTempl,
       $addr,$usrtbl,$addrtbl,$exp,$cnx);

    # 
    $nodeTempl=CtTbCti('SC,NDTMP');

    # 
    $topologyTempl=CtTbCti('SC,TPTMP');

    # 
    $temp=$nodeTempl->{$name}||$nodeTempl->{$tmpName};
    $topology=$topologyTempl->{$name}||$topologyTempl->{$tmpName};
    if(!$temp){
	@keys=keys(%$nodeTempl);
	foreach $key (@keys){if($name =~ /$key/){$temp=$nodeTempl->{$key};last;}}
	if(!$temp){
	    MsgPrint('ERR',"Can't find template node[$name]\n");
	    return;
	}
    }

    # 
    #  
    if(ref($link) eq 'ARRAY' && $#$link eq 0){$link=$link->[0];}
    $cnx={'name'=>$name,'tmpname'=>$tmpName,'link'=>$link,'conn'=>$recvConn,
	  'back'=>$backGround,'ext'=>$extTbl,'nonio'=>$nonIO};
    if(($tbl=$temp->{'TBLINIT'}) && !ref($tbl)){
	$usrtbl=&$tbl($name,$temp,$tmpName,$topology,$nonIO);
    }
    elsif($tbl){
	$usrtbl=CtNDEvalHashTbl($tbl,$cnx);
    }
    $usrtbl={%$usrtbl,%$extTbl};

    # 
    if(($addr=$temp->{'ADINIT'}) && !ref($addr)){
	$addrtbl=&$addr($name,$temp,$tmpName,$topology);
    }
    elsif($addr){
	$addrtbl=CtNDEvalHashTbl($addr,$cnx);
    }

    # 
    $node={'ID'=>$name,'RUN'=>'WAIT','TLNO'=>0,
	   'TBL'=>$usrtbl,'AD'=>$addrtbl,'ADDCAP'=>$addcap,
	   'BACK'=>$backGround, 'REL'=>{%$topology,'LINK'=>$link}, %$temp};
    if($recvConn){$node->{'RECVCN'}=$recvConn;}

    # 
    CtTbCtiSet("ND,$name",$node,'T');

    # 
    push(@NDNodeTbl,$node);

    # 
    if($recvConn && ($recvConn=CtCnGet($recvConn))){
	if( $recvConn->{'Node'} && $node ne $recvConn->{'Node'} ){MsgPrint('WAR',"Receive connection rebind to Node[%s]\n",$name);}
	$recvConn->{'Node'}=$node;
    }

    return $node;
}
# 
sub CtNDEvalHashTbl {
    my($tbl,$CNX)=@_;
    my(@keys,$key,%data,@data,$val);

    if(ref($tbl) eq 'HASH'){
	@keys=keys(%$tbl);
	foreach $key (@keys){
	    $val=$tbl->{$key};
	    if(ref($val) eq 'HASH'){
		$data{$key}=CtNDEvalHashTbl($val,$CNX);
	    }
	    elsif(ref($val) eq 'ARRAY'){
		$data{$key}=CtNDEvalHashTbl($val,$CNX);
	    }
	    elsif(ref($val) eq 'SCALAR'){
		$data{$key}=eval $$val;
	    }
	    else{
		$data{$key}=$val;
	    }
	}
	return \%data;
    }
    if(ref($tbl) eq 'ARRAY'){
	foreach $val (@$tbl){
	    if(ref($val) eq 'HASH'){
		push(@data,CtNDEvalHashTbl($val,$CNX));
	    }
	    elsif(ref($val) eq 'ARRAY'){
		push(@data,CtNDEvalHashTbl($val,$CNX));
	    }
	    elsif(ref($val) eq 'SCALAR'){
		push(@data,eval $$val);
	    }
	    else{
		push(@data,$val);
	    }
	}
	return \@data;
    }
    else{
	return $tbl;
    }
}

# 
sub CtNDDefEnd {
    my($node,$state)=@_;
    delete($node->{'LT'});
    # 
    if($state){$node->{'ST'}=$state;}
}
# 


# 
#    
#      PKT:TAHI
#      MATCH:
#      Mode: [recv|send|timer]
sub CtNDAddActEx {
    my($node,$id,$func,$rule,$mode,$timeout,$matchList,$errfunc,$connID)=@_;
    my($stateTbls,$stateTbl);
    
    # 
    if(!ref($node)){$node=CtNDFromName($node);}
    if(ref($node) ne 'HASH'){MsgPrint('ERR',"Node object illegal\n");return;}
    if(!$func || ($mode ne 'recv' && $mode ne 'send' && $mode ne 'timer')){
	MsgPrint('ERR',"Action parameter illegal. Mode[%s]\n",$mode);return;
    }

    if(!$id){$id = 'ST:' . $node->{'TLNO'};}

    # 
    $stateTbl={'ID'=>$id,'FN'=>{'Action'=>$func},
	       'RR'=>$rule,'MD'=>$mode,'MatchList'=>$matchList,'Timeout'=>$timeout,'EXCEPTION'=>$errfunc,'CONN'=>$connID};

    # 
    $node->{'TL'}->{$id}=$stateTbl;

    # 
    if($node->{'LT'}){$node->{'LT'}->{'NX'}=$id;}
    $node->{'LT'}=$stateTbl;
    $node->{'TLNO'}++;

    # 
    if(!$node->{'ST'}){$node->{'ST'}=$id;}

    # 
    return $id;
}

# 

# 
sub CtNDAddAct {
    my($node,$func,$matchfunc,$command,$matchpattern,$pktname,$conn,$id,$timeout)=@_;
    
    # 
    if(!ref($node)){$node=CtNDFromName($node);}
    if(ref($node) ne 'HASH'){CtLgPrint('ERR',"State table compose invalid\n");CtScExit('InitFail');}

    # 
    if($conn){$node->{'RECVCN'}=$conn;}

    # 
    if(!$id){$id = 'ST:' . $node->{'TLNO'};}

    # 
    if(!$timeout){$timeout=CtTbSc('PARAM,RecvTimeout');}

    # 
    if($command eq 'START'){
	CtNDAddActEx($node,$id,$func,'','send',$timeout);
    }
    elsif($command eq 'TIMER'){
	# 
	CtNDAddActEx($node,$id,$func,'','timer',$timeout);
    }
    else{
	# 
	CtNDAddActEx($node,$id,$func,'','recv',$timeout,{'PATTERN'=>$matchpattern,'MATCH'=>$matchfunc,'ATTR'=>$pktname});
    }
    return $id;
}

# 
sub CtNDAddActFunc {
    my($node,$id,$func,$event)=@_;
    
    # 
    if(!ref($node)){$node=CtNDFromName($node);}
    if(ref($node) ne 'HASH'){MsgPrint('ERR',"Node object illegal\n");return;}

    # 
    $node->{'TL'}->{$id}->{'FN'}->{$event}=$func;
}

# 
# ST:1: =
#    FN: =
#       CODE(0x8b07134)
#    ID: = ST:1(0)
#    MD: = timer(0)
#    MatchList: =
#       DPD: = DPD(0)
#       ExchangeType: = 5(5)
#       MATCH: =
#          CODE(0x8981af0)
#    RR: = Nil(0)
#    Timeout: = 10(a)


# 

#============================================
#  
#============================================
# 
#   
sub CtNDMakeRelation {
    my(%map,$graph,$node);

    # 
    foreach $node (@NDNodeTbl){
	if($node->{'REL'}->{'LINK'}){
	    $map{$node->{'ID'}}=$node->{'REL'}->{'LINK'};
	}
    }
    # 
    $graph=CtNDMakeTopology(\%map);
#    PrintVal($graph);

    # 
    foreach $node (@NDNodeTbl){
	if($graph->{$node->{'ID'}}){
	    $node->{'REL'}->{'ROUTE'}=$graph->{$node->{'ID'}};
	}
    }
}
# 
sub CtNDMakeTopology {
    my($map)=@_;
    my($topology,$node,@nodes,$sub,$route,$routes,%graph);

    # 
    @nodes=keys(%$map);
    foreach $node (@nodes){
	if(ref($map->{$node}) eq 'ARRAY'){
	    foreach $sub (@{$map->{$node}}){
		$topology->{$node}->{$sub}='';
		$topology->{$sub}->{$node}='';
	    }
	}
	else{
	    $topology->{$node}->{$map->{$node}}='';
	    $topology->{$map->{$node}}->{$node}='';
	}
    }
    @nodes=keys(%$topology);
    foreach $node (@nodes){
	$topology->{$node}=[keys(%{$topology->{$node}})];
    }

    # 
    foreach $node (@nodes){
	$routes=CtNDMakeGraph($node,$node,[],$topology);
	foreach $route (@$routes){
	    if($#$route<0){next;}
	    $graph{$node}->{$route->[$#$route]}=$route;
	}
    }
    return \%graph;
}

sub CtNDMakeGraph {
    my($node,$start,$route,$topology)=@_;
    my(@routes,$nodes,@routes,$next);

    if(-1<$#$route){push(@routes,$route);}
    $nodes=$topology->{$node};
    foreach $next (@$nodes){
	if($next eq $start){next;}
	if( grep{$next eq $_} @$route ){next;}
	push(@routes,@{CtNDMakeGraph($next,$start,[@$route,$next],$topology)});
    }
    return \@routes;
}

# 
sub CtNDTraceNode {
    my($start,$end,$expr)=@_;
    my($route,@info,$node,$val,$cur);
    return unless($start=CtNDFromName($start));
    return unless($route=$start->{'REL'}->{'ROUTE'}->{$end});
    foreach $cur ($start->{'ID'}, @$route) {
	$node=CtNDFromName($cur);
	if(!ref($expr)){
	    $val=CtTbl($expr,$node);
	}
	elsif(ref($expr) eq 'CODE'){
	    $val=$expr->($node);
	}
	push(@info,$val) if($val);
    }
    return \@info;
}

#============================================
#  
#============================================
# 
sub CtNDGet {
    my($cond)=@_;
    my($node,@keys,$key,@find);
    
    @keys=keys(%$cond);
    foreach $node (@NDNodeTbl){
	foreach $key (@keys){
	    if($node->{$key} ne $cond->{$key}){goto NEXT;}
	}
	push(@find,$node);
      NEXT:
    }
    return \@find;
}
# 
sub CtNDPkts {
    my(@pkts,$node);
    
    foreach $node (@NDNodeTbl){
	next unless($node->{'PKTS'});
	push(@pkts,@{$node->{'PKTS'}})
    }
    return \@pkts;
}

sub CtNDAllStop {
    my($node);
    foreach $node (@NDNodeTbl){
	$node->{'RUN'}='STOP';
	$node->{'ST-Signal'}='';
    }
}

#============================================
#  
#============================================
# 
sub CtScStart {
    my($node,$userParam,$reason)=@_;

    # 
    if(!ref($node)){$node=CtNDFromName($node);}
    if(ref($node) ne 'HASH'){
	MsgPrint('ERR',"Node undefined,can't continue\n");
	exit;
    }
    # 
    $node->{'RUN'}='START';
    MsgPrint('ACT',"Start Node[%s] ST[%s]\n",$node->{'ID'},$node->{'ST'}) if(CtLgLevel('ACT'));

    # 
    if(!$node->{'ST'}){
	if(!$node->{'TL'}){$node->{'ST'}='ALWAYS';}
	else{MsgPrint('ERR',"Node State tale invalid\n");}
    }
    $node->{'TL'}->{$node->{'ST'}}->{'StartTime'}=time();
    if($userParam ne ''){
	$node->{'TL'}->{$node->{'ST'}}->{'UserParam'}=$userParam;
    }

    if($reason){NDAddEvent($node,$reason,$userParam);}
}

# 

# 1

# 
# 

# 

# 
sub CtScRun {

    # 
    CtNDMakeRelation();
    
    # 
    if(CtUtIsFunc("ServiceInit2")){ServiceInit2();}

    # 
    CtScRunEx(time()+$TOTAL_RUNNING);
}

# 
sub CtScRunEx {
    my($totalFinishTime,$seqs,$mode,$context)=@_;

    my($node,@nodes,$nd,@frames,$stateTbl,$ret,$next,$idx,$hexSt,$acton,$i,$stop,$andmode,
       $doing,$event,$user,$userParam,$connlist,$conn,$signal,$capmsg,$msg);

    # 
    if($seqs){@nodes=keys(%$seqs);}

    while(time()<$totalFinishTime){

      RESTART:
	# START
	foreach $node (@NDNodeTbl){
	    if($node->{'RUN'} ne 'START'){next;}
	    $stateTbl=$node->{'TL'}->{$node->{'ST'}};
	    if($stateTbl->{'MD'} eq 'send'){
		# 
		$userParam=$stateTbl->{'UserParam'};$stateTbl->{'UserParam'}='';
		($next,$signal,$ret)=CtNDDoAct($node,$stateTbl,'send','',$userParam);
		if($ret eq 'ERROR'){goto EXIT;}
		# 
		CtNDNextState($node,$stateTbl,$next,$signal);
		goto RESTART;
	    }
	}

	# START
	$idx=0;@frames=();$doing='';
	$connlist={};
	foreach $node (@NDNodeTbl){
	    if($node->{'RUN'} ne 'START'){next;}
	    $stateTbl=$node->{'TL'}->{$node->{'ST'}};
	    if($stateTbl->{'MD'} eq 'recv' || $stateTbl->{'MD'} eq 'timer'){
		if(!$node->{'BACK'}){$doing='T';}
		@frames[$idx] = {'Recv' => $stateTbl->{'MatchList'}->{'PKT'},
				 'RecvMatch' => $stateTbl->{'MatchList'}->{'MATCH'},
				 'Node' => $node,
				 'Event' => $stateTbl->{'MD'},
				 'TimerTimeout' => $stateTbl->{'TimerTimeout'},
				 %{$stateTbl->{'MatchList'}} };
		$idx++;
		# 
		if($node->{'RECVCN'}){$connlist->{CtCnGet($node->{'RECVCN'})->{'ModuleName'}}=$node->{'RECVCN'};}
	    }
	}

	# 
	if(!$doing){last;}

	# 
	$acton='T';
	while($acton){

	    # 
	    ($event,$hexSt,$node,$conn,$user,$capmsg) = CtNDEvent(\@frames,[values(%$connlist)]);

	    # 
	    if($event && $event ne 'PASS'){

		# CtScStart
		$stateTbl=$node->{'TL'}->{$node->{'ST'}};
		if(!$user && $stateTbl->{'UserParam'}){
		    $user=$stateTbl->{'UserParam'};$stateTbl->{'UserParam'}='';
		}
		# 
		($next,$signal,$ret)=CtNDDoAct($node,$stateTbl,$event,$hexSt,$user,$conn);
		if($ret eq 'ERROR'){goto EXIT;}
		# 
		CtNDNextState($node,$stateTbl,$next,$signal);
		$acton='';
	    }

	    # 
	    while($event eq 'recv' || $event eq 'PASS' || $event eq 'RECVED'){
		$acton='';
		# 
		($event,$msg,$hexSt) = CtNDDoProtLyNX($conn);
		if($event eq 'PASS'){next;}
		if($event ne 'RECVED'){last;}

		# CtScStart
		$stateTbl=$node->{'TL'}->{$node->{'ST'}};
		if(!$user && $stateTbl->{'UserParam'}){
		    $user=$stateTbl->{'UserParam'};$stateTbl->{'UserParam'}='';
		}
		# 
		if($msg){
		    if(ref($user) eq 'HASH'){$user->{'RECORD'}=$msg;}
		    else{$user={'RECORD'=>$msg,'USER'=>$user};}
		}
		# 
		($next,$signal,$ret)=CtNDDoAct($node,$stateTbl,'recv',$hexSt,$user,$conn);
		if($ret eq 'ERROR'){goto EXIT;}
		# 
		CtNDNextState($node,$stateTbl,$next,$signal);
	    }


	    # START
	    foreach $node (@NDNodeTbl){
		if($node->{'RUN'} ne 'START'){next;}
		$stateTbl=$node->{'TL'}->{$node->{'ST'}};
		if(0<$stateTbl->{'Timeout'} && $stateTbl->{'StartTime'}+$stateTbl->{'Timeout'}<time()){
		    # 
		    ($next,$signal,$ret)=CtNDDoAct($node,$stateTbl,'timeout');
		    if($ret eq 'ERROR'){goto EXIT;}
		    $stateTbl->{'StartTime'}=time();
		    # 
		    CtNDNextState($node,$stateTbl,$next,$signal);
		    $acton='';
		}
	    }
	    # 
	    while($event=pop(@NDNodeEvent)){
		# 
		$node=$event->{'ND'};
		$stateTbl=$node->{'TL'}->{$node->{'ST'}};
		($next,$signal,$ret)=CtNDDoAct($node,$stateTbl,$event->{'reason'},'',$event->{'param'});
		if($ret eq 'ERROR'){goto EXIT;}
		# 
		CtNDNextState($node,$stateTbl,$next,$signal);
		$acton='';
	    }

	    # TCP 
	    # if(CtUtIsFunc("TCPRestDataAction")){TCPRestDataAction();}
	}

	# TCP
	if(CtUtIsFunc("TCPTimerAction")){TCPTimerAction();}

	# 
	if($seqs){
	    foreach $nd (@nodes){
		unless( $stop=$seqs->{$nd}->{'stop'} ){next;}
		if(ref($stop) eq 'SCALAR'){$stop = eval $$stop;}
		$node=CtNDFromName($nd);
		if($mode eq 'and'){
		    $andmode=$node->{'ST'} eq $stop || $node->{'ST-Signal'} eq $stop;
		    unless($andmode){last;}
		}
		else{
		    if($node->{'ST'} eq $stop || $node->{'ST-Signal'} eq $stop){return $node;}
		}
	    }
	    if($mode eq 'and' && $andmode){return 'ALL';}
	}
    }
    unless(time()<$totalFinishTime){CtLgWarn("Scenario running time expired");}

 EXIT:
#    NDNodeDump();
    return;
}

#============================================
#  
#============================================
sub DoProtocolLayer {
    my($msg,$connID,$ext,$node,$param,$capmsg)=@_;
    my($order,$status,$tbl,$user,$inet,$pkt,$connID2);

    # 
    unless( $order=CtCnGet($connID)->{'Layer'}->{'Order'} ){return 'UNMATCH',$msg,'',$node,$connID;}
    $connID2=$connID;

    # TCP->SSL-> ... 
    foreach $tbl (@$order){

	MsgPrint('LAY',"<<<< [%s] conn[%s]\n",$tbl->{'ProtocolLayer'},$connID2) if(CtLgLevel('LAY2'));
	($status,$pkt,$node,$connID2,$user,$capmsg)=$tbl->{'ProtocolLayer'}->($msg,$inet,$tbl,$connID2,$ext,$node,$param,$capmsg);
	MsgPrint('LAY',">>>> [%s] status[%s] conn[%s]\n",$tbl->{'ProtocolLayer'},$status,$connID2) if(CtLgLevel('LAY2'));

	# 
	if($connID2 && $connID2 ne $connID){
	    $connID=$connID2;
##	    NDBindRecvConn($node,$connID);
	}

	# 
	if($status ne 'RECVED'){last;}

	# 
	$inet=$pkt->[0];
	$msg =$pkt->[1];
    }

    if(ref($pkt) eq 'ARRAY'){
	return $status,$pkt->[1],$pkt->[0],$node,$connID,$user,$capmsg;
    }
    return $status,$msg,'',$node,$connID,$user,$capmsg;
}

#============================================
#  
#    1
#============================================
sub CtNDDoProtLyNX {
    my($connID)=@_;
    my($order,$status,$tbl,$msg,$inet);

    # 
    unless( $order=CtCnGet($connID)->{'Layer'}->{'Order'} ){return 'UNMATCH';}

    # TCP->SSL-> ... 
    foreach $tbl (@$order){
	if($tbl->{'ProtocolLayerEx'}){
	    MsgPrint('LAY',"<<<< [%s] conn[%s]\n",$tbl->{'ProtocolLayerEx'},$connID) if(CtLgLevel('LAY2'));
	    ($status,$msg,$inet)=$tbl->{'ProtocolLayerEx'}->($msg,$inet,$tbl,$connID);
	    MsgPrint('LAY',">>>> [%s] status[%s]\n",$tbl->{'ProtocolLayerEx'},$status) if(CtLgLevel('LAY2'));
	}
	else{
	    $status = 'NODATA';
	}
	if($status ne 'NODATA' && $status ne 'RECVED'){last;}
    }
    MsgPrint('ACT',"status [%s]\n",$status) if(CtLgLevel('ACT'));
    return $status,$msg,$inet;
}

#============================================
#  
#============================================

# 

# 


# 


# 
sub CtNDDefaultUnknownPkt {
    my($pkt,$conn,$ext)=@_;
    my($inetSt,$type,$proto,$service);

    if( ref($pkt) ){
	$inetSt=$pkt;
    }
    else{
	($inetSt)=CtPkDecode('INET',unpack('H*',$pkt));
    }
    ($type,$proto,$service)=CtPkFrameAttr($inetSt);

    MsgPrint('WAR',"Unknown packet recived. Type[%s] Proto[%s] Service[%s]\n",$type,$proto,$service);
    INETDump($pkt) if(CtLgLevel('PKT'));
    INETHexDump('Recv',$inetSt,$pkt) if(CtLgLevel('PKT'));
    CtScAddUnknownCapt({%$inetSt,%$ext},'in',$conn,$proto ? $proto : $type, $service);
    return;
}

# 
#  
#       Recv:
#  
sub CtNDEvent {
    my($matchlist,$connlist)=@_;
    my($status,$inetSt,$node,$match,$ext,$expr,$conn,$pkt,$len,$timestamp,$user,$diff,$waitTime,$dlg,$dlgSts,$matchconn,$capmsg);

    # 
    $waitTime=0.1;
    foreach $match (@$matchlist){
	if($match->{'Event'} eq 'timer'){
	    $diff=$match->{'TimerTimeout'}-CtUtGetTimeStamp();
	    if($diff<0){
		return 'timer','TimeOut',$match->{'Node'};
	    }
	    $waitTime=$diff if($diff < $waitTime );
	}
    }

    # 
    if(CtUtIsFunc('GUIGetDialogIdLst')){
	foreach $dlg (@{GUIGetDialogIdLst()}){
	    $dlgSts=GUIGetDialogSts($dlg->{'DialogID'});
	    # 
	    if($dlgSts && !$dlgSts->{'Result'}){
		return 'gui','DialogResult',ref($dlg->{'Node'})?$dlgSts->{'Node'}:CtCnGet($dlgSts->{'Node'}),'',$dlgSts;
	    }
	}
    }

    # IO
    ($status,$conn,$len,$pkt,$timestamp,$ext)=CtIoRecvs($connlist);

    if($status){
	# 
	CtNDCBTimer();
	Time::HiRes::sleep($waitTime);
	return;
    }
    if($ext){
	$ext->{'#TimeStamp#'}=$timestamp;
    }
    else{
	$ext={'#TimeStamp#'=>$timestamp};
    }

    # 
    
    # 
    foreach $match (@$matchlist){
	$expr=$match->{'RecvMatch'};
	if(ref($expr) eq 'CODE'){
	    my($nm,$trans);

	    # 
	    ($status,$inetSt,$node,$user,$matchconn,$capmsg)=$expr->($pkt,$conn,$ext,$match->{'Node'},$match);

	    # 
	    if($matchconn && $conn ne $matchconn){
		MsgPrint('PRMT',"Connection match(%s) change[%s]->[%s]\n",$status,$conn,$matchconn);
		$conn=$matchconn;
	    }
	    if($status){
		$DIRRoot{'LASTPKT'}=$inetSt;
		last;
	    }
	    # 
	    if(!ref($pkt) && ref($inetSt)){$pkt=$inetSt;}
	}
    }
    if($status eq 'OK'){
	INETHexDump('Recv',$inetSt) if(CtLgLevel('PKT'));
	return 'recv',$inetSt,$node,$conn,$user,$capmsg;
    }
    elsif($status){
	return $status,$inetSt,$node,$conn,$user;
    }
    else{
	if(CtUtIsFunc("UnknownPacket")){
	    UnknownPacket($pkt,$conn,$ext);
	}
	else{
	    CtNDDefaultUnknownPkt($pkt,$conn,$ext);
	}
	return;
    }
}

# 
#   
sub CtNDDoAct {
    my($node,$stateTbl,$event,$hexSt,$user,$conn)=@_;
    my(@next);

    if($stateTbl->{'FN'}){
	# 
	$DIRRoot{'ACTND'}=$node;

	# 
	if($stateTbl->{'RR'} && ($event eq 'OK' || $event eq 'recv')){
	    MsgPrint('ACT',"DoAction rule eval, before call action[%s]\n",$stateTbl->{'RR'}) if(CtLgLevel('ACT'));
	    CtRlEval($stateTbl->{'RR'},$hexSt);
	}

	# 
	MsgPrint('ACT',"<<=Action Node[%s] ST[%s] Event[%s] Conn[%s]\n",$node->{'ID'},$stateTbl->{'ID'},$event,$conn) if(CtLgLevel('ACT'));
	if($stateTbl->{'FN'}->{$event}){
	    @next=$stateTbl->{'FN'}->{$event}->($event,$hexSt,$conn,$user);
	}
	else{
	    @next=$stateTbl->{'FN'}->{'Action'}->($event,$hexSt,$conn,$user);
	}
	MsgPrint('ACT',"=>>Action Node[%s] ST[%s] Event[%s]\n",$node->{'ID'},$stateTbl->{'ID'},$event) if(CtLgLevel('ACT'));
	return @next;
    }
    else{
	MsgPrint('ERR',"Can't do action. Node[%s] ST[%s] state table not found action\n",$node->{'ID'},$stateTbl->{'ID'});
    }
    return '';
}


# 
sub CtNDNextState {
    my($node,$stateTbl,$next,$signal)=@_;
    my($oldstate);

    $oldstate=$node->{'ST'};

    # 
    if($signal){$node->{'ST-Signal'}=$signal;} 

    if($next eq 'NEXT'){
	$node->{'ST'}=$stateTbl->{'NX'};
	if($node->{'ST'} && $node->{'TL'}->{$node->{'ST'}}){$node->{'TL'}->{$node->{'ST'}}->{'StartTime'}=time();}
    }
    elsif($next eq 'CONTINUE'){
	# timeout 
	# 
    }
    elsif($next eq 'END'){
	$node->{'RUN'}='STOP';
	$node->{'ST'}='';
	MsgPrint('ACT',"Node[%s] finished\n",$node->{'ID'}) if(CtLgLevel('ACT'));
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
    MsgPrint('ACT',"=>>Action Node[%s] Event[%s] State[%s]=>[%s] receiveWait[%s] TimerEvent[%s] Signal[%s]\n",
	     $node->{'ID'},$next,$oldstate,$node->{'ST'},
	     $node->{'TL'}->{$node->{'ST'}}->{'StartTime'}+$node->{'TL'}->{$node->{'ST'}}->{'Timeout'}-time(),
	     $node->{'TL'}->{$node->{'ST'}}->{'TimerTimeout'}?$node->{'TL'}->{$node->{'ST'}}->{'TimerTimeout'}-time():'',
	     $node->{'ST-Signal'}) if(CtLgLevel('ACT'));
}

# 

## DEF.VAR
# 
%CBSetTimer;
$CBSetTimerID;
## DEF.END
# 
# 
# 
sub CtNDCBTimer {
    my($tm,$key,$val);
    $tm=CtUtGetTimeStamp();
    while(($key,$val)=each(%CBSetTimer)){
	if($val && $val->{'TimeOut'} < $tm){
	    $val->{'TimeOut'} = $tm + $val->{'Timer'};
	    $val->{'CB'}->($key,$val->{'User'});
	    last;
	}
    }
}

#============================================
#  
#============================================
# 



# @@ -- Rule.pm --
# Copyright (C) NTT Advanced Technology 2007

# use strict;

## DEF.VAR
# 
%RuleDB;
%StatisticsRule;

# 
%RuleCategoryDB;

# 
#  RuleSpectDB=>{'SIP'=>{'IG'=>{'color'=>XXX,'comment'=>YYY},'3261'=>{}},'IKE'=>{''}}
%RuleSpectDB;

# 
@JUDGEMENTLog;
## DEF.END

#============================================
# 
#============================================

# 
sub CtRlRegRuleSet {
    my($rules,$ruleName,$category,$ruleSpec)=@_;
    my($i);

#    MsgPrint('RULE', "CtRlRegRuleSet type:[%s]\n",ref($rules));
    if(ref($rules) eq 'ARRAY'){
	for($i=0;$i<=$#$rules;$i++){
	    if( ref($rules->[$i]) eq 'HASH' ){
		MsgPrint('RULE',"Regist RuleSet TY:[%s] ID:[%s]\n",$rules->[$i]->{'TY'},$rules->[$i]->{'ID'});
		if($RuleDB{$rules->[$i]->{'ID'}}){
		    MsgPrint('WAR',"Regist RuleSet TY:[%s] ID:[%s] SP:[%s] is overrided\n",
			     $rules->[$i]->{'TY'},$rules->[$i]->{'ID'},$rules->[$i]->{'SP'});
		}
		$rules->[$i]->{'GR'}=$ruleName;
		$RuleDB{$rules->[$i]->{'ID'}}=$rules->[$i];
	    }
	}
    }
    elsif(ref($rules) eq 'HASH' && $rules->{'TY'}){
#	MsgPrint('RULE',"Regist RuleSet TY:[%s] ID:[%s]\n",$rules->{'TY'},$rules->{'ID'});
	$rules->{'GR'}=$ruleName;
	$RuleDB{$rules->{'ID'}}=$rules;
    }
    else{
	MsgPrint('ERR',"Regist RuleSet invalid parameter\n");
    }
    # 
    if($category){
	$RuleCategoryDB{$ruleName}=$category;
    }
    # 
    if($ruleSpec){
	$RuleSpectDB{$ruleName}=$ruleSpec;
    }
}

# 
# 

# 
sub CtRlFindFromID ($){
    my $ruleid=shift;
    if(ref($ruleid) eq 'HASH'){
	return $ruleid->{'ID'},$ruleid;
    }
    else{
	return $ruleid,$RuleDB{$ruleid};
    }
}

# 
sub CtRlModify {
    my($rule,$addrule,$delrule)=@_;
    my(%newrule,$tmp);

    if(!$addrule && !$delrule){return $rule;}

    $addrule=[$addrule] if($addrule && !ref($addrule));
    $delrule=[$delrule] if($delrule && !ref($delrule));

    # 
    $rule=CtRlFindFromID($rule);
    if(!$rule || $rule->{'TY'} ne 'PROGN'){
	MsgPrint('ERR',"Modify Rule invalid base ruleset\n");
	return $rule;
    }

    # 
    %newrule=(%$rule,'AD'=>$addrule,'DL'=>$delrule);
    return \%newrule;
}

# 
sub CtRlFindCatList ($){
    my($ruleName)=@_;
    return $RuleCategoryDB{$ruleName};
}
sub CtRlFindCatListFromID ($){
    my($ruleID)=@_;
    my($ruleObj);
    ($ruleID,$ruleObj)=CtRlFindFromID($ruleID);
    return CtRlFindCatList($ruleObj->{'GR'});
}
sub CtRlCategory {
    my($ruleID)=@_;
    my($ruleObj);
    ($ruleID,$ruleObj)=CtRlFindFromID($ruleID);
    return $ruleObj->{'CA'};
}
# 
sub CtRlFindSpecList ($){
    my($ruleName)=@_;
    return $RuleSpectDB{$ruleName};
}
# 
sub CtRlSpecInfo {
    my($ruleID)=@_;
    my($ruleObj,$specs);
    ($ruleID,$ruleObj)=CtRlFindFromID($ruleID);
    $specs=CtRlFindSpecList($ruleObj->{'GR'});
    return $specs->{$ruleObj->{'SP'}};
}

# 

#============================================
# 
#============================================

# 
sub CtRlEval {
    my($ruleID,$hexSt,$context)=@_;
    my($ruleObj,$val,@stack,%tmpContext);

#    MsgPrint('RULE',"<==CtRlEval EVALResult[$context->{'EVAL-RESULT'}] ORDER[$context->{'ORDER'}]\n");
    # 
    unless($context){$context=\%tmpContext;$context->{'RULE-RESULT'}=[];$context->{'RULE-SKIP'}=[];}

    # 
    if(!ref($ruleID)){
	# 
	($ruleID,$ruleObj)=CtRlFindFromID($ruleID);
	if(!$ruleObj){
	    @stack=caller(1);
	    MsgPrint('ERR',"Rule ID:[%s] done not exist in Rule DB called[%s]\n",$ruleID,@stack[3]);
	    return 'Illegal rule';
	}
    }
    # 
    elsif( (ref($ruleID) eq 'HASH') && $ruleID->{'TY'} eq 'SW' ){
	$ruleObj = $ruleID;
	$ruleID = 'SW';
    }
    # 
    elsif( (ref($ruleID) eq 'HASH') && $ruleID->{'TY'} && $ruleID->{'ID'} ){
	$ruleObj = $ruleID;
	$ruleID = $ruleObj->{'ID'};
    }
    else{
	MsgPrint('ERR',"Rule illegal data type[%s] called[%s]\n",$ruleID,@stack[3]);
	PrintVal($ruleID);
	return 'Illegal rule';
    }

    # 
    if( $context->{'DEL-RULE'} && grep{$_ eq $ruleID} @{$context->{'DEL-RULE'}} ){
###	printf("==>CtRlEval rule(ID:$ruleID order:$ruleObj->{'OD'}) skiped\n");
	MsgPrint('RULE',"==>CtRlEval rule(ID:$ruleID order:$ruleObj->{'OD'}) skiped\n");
	return '';
    }

# 
    $CTEvaledRules{$ruleID}++;

    # 
    if($ruleObj->{'TY'} eq 'PROGN'){
	if( $context->{'ORDER'} && $ruleObj->{'OD'} && $context->{'ORDER'} ne $ruleObj->{'OD'} ){
	    MsgPrint('RULE',"==>CtRlEval rule(ID:$ruleID order:%s) skiped\n",$ruleObj->{'OD'});
	    return '';
	}
	$val=CtRlEvalProgn($ruleObj,$hexSt,$context);
    }
    elsif($ruleObj->{'TY'} eq 'SYNTAX'){
	if( $context->{'ORDER'} && $context->{'ORDER'} ne ($ruleObj->{'OD'}?$ruleObj->{'OD'}:'MAIN') ){
	    MsgPrint('RULE',"==>CtRlEval rule(ID:$ruleID order:%s) skiped\n",$context->{'ORDER'});
	    return '';
	}
	$val=CtRlEvalSyntax($ruleObj,$hexSt,$context);
    }
    elsif($ruleObj->{'TY'} eq 'ENCODE'){
	if( $context->{'ORDER'} && $context->{'ORDER'} ne ($ruleObj->{'OD'}?$ruleObj->{'OD'}:'MAIN') ){
	    MsgPrint('RULE',"==>CtRlEval rule(ID:$ruleID order:%s) skiped\n",$context->{'ORDER'});
	    return '';
	}
	$val=CtRlEvalEncode($ruleObj,$hexSt,$context);
    }
    elsif($ruleObj->{'TY'} eq 'SW'){
	$val=CtRlEvalSw($ruleObj,$hexSt,$context);
    }
    else{
	@stack=caller(1);
	MsgPrint('ERR', "Can't eval[%s], unknown rule type called[%s]\n",$ruleID,@stack[3]);
    }
#     if(CtLgLevel('RULE')){
# 	DumpRuleResult($context->{'RULE-RESULT'});
#     }
    return $val;
}

# PROGN
sub CtRlEvalProgn {
    my($rule,$hexSt,$context)=@_;
    my($result,@delrules,@rules,$expr,$od,$msg,$color,$diff,$bool,$msgType,$msgData,
       $order,$lastResult,%cntx,%tempcntx,$level,$type,$ruleObj,$output,$tmp,$tempcntx,$key,$val);

    # 
    $tempcntx={'RULEID'=>1,'DEL-RULE'=>1,'NEST-LEVEL'=>1,'ORDER'=>1,'RULE-BOOL'=>1,'EVAL-RESULT'=>1};

    # 
    $bool=$rule->{'MD'};
    $level=$context->{'NEST-LEVEL'};

    # 
    @delrules=@{$context->{'DEL-RULE'}};

    # 
    if($rule->{'DL'}){
	push(@delrules,@{$rule->{'DL'}});
    }

    # 
    if(CtLgLevel('RULE')){
	$color='FF8C00';
	$msg=sprintf("<B><font color=\"#%s\"> %${level}.${level}s-- %s %${level}.${level}s-- </font></B><br>",
		     $color,'<<<<<<<<<<<<<<<<<<<<',$rule->{'ID'},'<<<<<<<<<<<<<<<<<<<<');
	CtLgAdd('RULE',$msg);
    }

    # 
    %cntx=%$context;

    # 
    $cntx{'RULEID'}=$rule->{'ID'};
    $cntx{'DEL-RULE'}=(-1<$#delrules)?\@delrules:'';
    $cntx{'NEST-LEVEL'}=$level+1;

    # 
    if($rule->{'PR'} && ref($rule->{'PR'})){
	MsgPrint('RULE',"Pre condition\n");
	$cntx{'RULE-BOOL'}='';
	$result = CtRlEvalExpr($rule->{'PR'},$hexSt,\%cntx);
	if(!$result){
	    MsgPrint('RULE', "Eval SyntaxRule(%s) skiped for Precondition is FALSE\n",$rule->{'ID'});
            push(@{$context->{'RULE-SKIP'}},$rule->{'ID'});
	    $result='SKIP';
	    goto EXIT;
	}
	if($cntx{'EVAL-STATUS'}){
	    MsgPrint('RULE', "Eval SyntaxRule(%s) skiped for Precondition eval error(%s)\n",$rule->{'ID'},$context->{'EVAL-STATUS'});
	    $result='SKIP';
	    goto EXIT;
	}
    }

    # 
    $cntx{'RULE-BOOL'}=$bool;

    # 
    if($rule->{'EX'}){
	push(@rules,ref($rule->{'EX'}) eq 'ARRAY'?@{$rule->{'EX'}}:$rule->{'EX'});
    }
    if($rule->{'AD'}){
	push(@rules,ref($rule->{'AD'}) eq 'ARRAY'?@{$rule->{'AD'}}:$rule->{'AD'});
    }

    if($#rules eq -1){$result='OK';goto DONE;}
    elsif($#rules eq 0){$expr=@rules[0];}
    else{$expr=\@rules;}
    $type=ref($expr);

    # 
    if($order=$context->{'ORDER'}){
	if($rule->{'OD'} && $rule->{'OD'} eq $order){
	    $result='SKIP';
	    goto EXIT;
	}
	$order=[$order];
    }
    else{
	$order=CtRlCreatOrderList($rule->{'ID'});
    }

    MsgPrint('RULE',"<==Rule($rule->{'ID'}) order[$order] EVALResult[$context->{'EVAL-RESULT'}]\n");

    # 
    foreach $od (@$order) {
	unless($od){next;}
	$cntx{'ORDER'}=$od;
	$cntx{'EVAL-RESULT'}='SKIP';
	$result = CtRlEvalExpr($expr,$hexSt,\%cntx);
	if($cntx{'EVAL-RESULT'} ne 'SKIP'){
	    if(!$result && $bool eq 'AND'){$result='ERR';goto DONE;}
	}
    }
    $result='OK';
DONE:
    # 
    if($rule->{'AE'}){
	$output=CtRlEvalExpr($rule->{'AE'},$hexSt,\%cntx);
    }

EXIT:
    # 
    while(($key,$val)=each(%cntx)){
	unless($tempcntx{$key}){$context->{$key}=$val;}
    }

    # 
    push(@{$context->{'RULE-RESULT'}},{'ID'=>$rule->{'ID'},'MSG'=>$output,'MSG-TYPE'=>$result});

    if(CtLgLevel('RULE')){
	$msg=sprintf("<B><font color=\"#%s\"> --%${level}.${level}s %s --%${level}.${level}s </font></B><br>",
		     $color,'>>>>>>>>>>>>>>>>>>>>',$rule->{'ID'},'>>>>>>>>>>>>>>>>>>>>');
	CtLgAdd('RULE',$msg);
    }
    MsgPrint('RULE',"==>Rule($rule->{'ID'})  Status[$result] EVALResult[%s] ret[$lastResult]\n",$context->{'EVAL-RESULT'});
    return $result;
}

# 
sub CtRlEvalSyntax {
    my($rule,$hexSt,$context)=@_;
    my($result,$startTime,$diff,%result,$msg,$msgType,$msgData,$level);

    # 
    if($context->{'EVAL-TIME'} && $rule->{'ET'} ne $context->{'EVAL-TIME'}){return 1;}

    $startTime=[Time::HiRes::gettimeofday()];
    $level=$context->{'NEST-LEVEL'};

    MsgPrint('RULE',"<==Rule($rule->{'ID'}) EVALResult[$context->{'EVAL-RESULT'}]\n");

    # 
    if($rule->{'PR'} && ref($rule->{'PR'})){
	$result = CtRlEvalExpr($rule->{'PR'},$hexSt,$context);
	if(!$result){
	    MsgPrint('RULE', "Eval SyntaxRule-2(%s) skiped for Precondition is FALSE\n",$rule->{'ID'});
            push(@{$context->{'RULE-SKIP'}},$rule->{'ID'});
	    return 'SKIP';
	}
    }

    # 
    if($rule->{'EX'}){
	$result = CtRlEvalExpr($rule->{'EX'},$hexSt,$context);
    }

    # 
    ($msg,$msgType)=CtRlMkResultMessage($result,$rule,$hexSt,$context);
    
    # 
    $diff=Time::HiRes::tv_interval($startTime, [Time::HiRes::gettimeofday()]);
    
    # 
    CtRlAccSyntaxResult($rule,$result,$diff);
    
    # 
    $msgData={'ID'=>$rule->{'ID'},'MSG'=>$msg,'MSG-TYPE'=>$msgType,'RE'=>$context->{'EVAL-RESULT'}};
    push(@{$context->{'RULE-RESULT'}},$msgData);
    
    # HTML
    CtRlAddSyntaxLog($msgData,$hexSt,$context);
    if(CtLgLevel('RULE') && $msg){
	$msg=sprintf("%${level}.${level}s %s",'                      ',$msg);
	CtLgAdd('RULE',$msg);
    }

    MsgPrint('RULE',"==>Rule($rule->{'ID'})  Status[$msgType]\n");
    return $msgType;
}

sub CtRlEvalEncode {
    my($rule,$hexSt,$context)=@_;
    my($msg,@args,$ruleargs,$frm,$val,$count,$i,$result);

    MsgPrint('RULE',"<==Rule($rule->{'ID'}) order[$rule->{'OD'}] context-order[$context->{'ORDER'}]\n");

    # 
    if($rule->{'PR'} && ref($rule->{'PR'})){
	$result = CtRlEvalExpr($rule->{'PR'},$hexSt,$context);
	if(!$result){
	    MsgPrint('RULE', "Eval EncodeRule(%s) skiped for Precondition is FALSE\n",$rule->{'ID'});
	    return '';
	}
    }

    # 
    $ruleargs = $rule->{'AR'};
    for($i=0;$i<=$#$ruleargs;$i++){
	$val=CtRlEvalExpr($ruleargs->[$i],$hexSt,$context);
	push(@args,$val);
    }
    
    # 
    if( $frm=$rule->{'FM'} ){
	if(ref($frm) eq 'SCALAR'){
	    $frm = eval( $$frm );
	    if($@){MsgPrint('ERR',"Eval SCALER failed[%s]\n",$@);}
	}

	# 
	$msg=sprintf($frm,@args);

	# 
	push(@{$context->{'RULE-RESULT'}},{'ID'=>$rule->{'ID'},'MSG'=>$msg});

    }
    # 
    if($rule->{'EX'}){
	$context->{'ENCODE-MSG'}=$msg;
	$context->{'ENCODE-ARG'}=\@args;
	$msg = CtRlEvalExpr($rule->{'EX'},$hexSt,$context);
    }

    MsgPrint('RULE',"==>Rule($rule->{'ID'})  Status[$msg]\n");

    # 
    return $msg;
}

# 
#  '#ipsec:on and ( #sigcomp:off or #ipcan:on )'
sub CtRlSwExpand {
    my($expr)=@_;
    $expr =~ s/(#([^:\s]+):([^\s()]+))/q{(lc(}.CtTbSwFunc($2).q{) eq '}.lc($3).q{')}/ge;
    return $expr;
}

# 
#   
#   {'TY'=>'SW', 'E.XXX.YYY'=>'#ipsec:on and #sigcomp:on','E.XXX.ZZZ'=>\q{CtTbCti('SC,SW,ipsec') eq on}}
sub CtRlEvalSw {
    my($ruleObj,$hexSt,$context)=@_;
    my(@keys,$key,$val);
    
    @keys=keys(%$ruleObj);
    foreach $key (keys(%$ruleObj)){
	if($key eq 'TY'){next;}
	$val = $ruleObj->{$key};
#	printf("<==Rule(SW) $key\n");
	if(!ref($val)){
	    # 
	    $val=CtRlSwExpand($val);
#	    MsgPrint('RULE',"==>Rule(SW) expand Status[$val]\n");
	    if( eval $val ){
#		printf("==>Rule(SW) expand Status[$val] OK\n");
		return $key;
	    }
#	    printf("==>Rule(SW) expand Status[$val] [%s]NG\n",CtTbCti('SC,SW,IPsec'));
	}
	elsif(ref($val) eq 'SCALAR'){
	    if( eval $val ){
		return $key;
	    }
	}
    }
    return;
}

# 
sub CtRlCreatOrderList {
    my($ruleID,$orderlist)=@_;
    my($ruleObj,$id);
    ($ruleID,$ruleObj)=CtRlFindFromID($ruleID);
    unless($orderlist){$orderlist=['','MAIN'];}
    if($ruleObj->{'OD'} eq 'FIRST'){$orderlist->[0]='FIRST';}
    if($ruleObj->{'OD'} eq 'LAST'){$orderlist->[2]='LAST';}
    if( $ruleObj->{'TY'} eq 'PROGN' ){
	foreach $ruleID (@{$ruleObj->{'EX'}}){
            if(ref($ruleID) && $ruleID->{'TY'}){
                grep{$id = ($_ !~ /^TY/ ? $_ : '')}(keys(%$ruleID));
            }
            else{
                $id=$ruleID;
            }
	    $orderlist=CtRlCreatOrderList($id,$orderlist);
	}
    }
    return $orderlist;
}

# 
#   
#   
#      
#   
#      
#        
#      
#      
#   
sub CtRlEvalExpr {
    my($expr,$hexSt,$context)=@_;
    my($rule,$val,$ruleObj,@args,$expr2,$count);
    shift @_;

    # 
    $context->{'EVAL-STATUS'}='';

#    MsgPrint('RULE',"<==CtRlEvalExpr($expr) EVALResult[$context->{'EVAL-RESULT'}]\n");
    if(ref($expr) eq 'ARRAY'){
	$val=CtRlEvalArray($expr,@_);
    }
    elsif(ref($expr) eq 'SCALAR'){
	$val=eval $$expr;
	if($@){
	    MsgPrint('ERR'," Eval exp[%s] failed[%s]\n",$$expr,$@);
	    $context->{'EVAL-STATUS'}='Eval Error';
	    $val='';
	}
	else{
	    if($context->{'EVAL-RESULT'} eq 'SKIP'){$context->{'EVAL-RESULT'}=$val};
	}
    }
    elsif(ref($expr) eq 'CODE'){
#	MsgPrint('RULE'," EvalExpr CODE\n");
	$val=$expr->(@_);
	if($context->{'EVAL-RESULT'} eq 'SKIP'){$context->{'EVAL-RESULT'}=$val};
    }
    elsif(ref($expr) eq 'HASH'){
#	MsgPrint('RULE'," EvalExpr HASH\n");
	$val=CtRlEval($expr,@_);
    }
    elsif(!ref($expr)){
#	MsgPrint('RULE'," EvalExpr STR($expr)\n");
	# 
	($rule,$ruleObj)=CtRlFindFromID($expr);
	# 
	if($ruleObj){
	    $val = CtRlEval($rule,@_);
	}
	# 
	else{
	    MsgPrint('RULE'," funcall $rule(\@_)\n");
	    $val = eval '&$rule';  # perl 5.0
#	    $val = $rule->(@_);    # perl 5.8
	    if($@){
		MsgPrint("WAR","Function($rule) is internal error. expr($expr)\n");
		MsgPrint("ERR","$@");
		$context->{'EVAL-STATUS'}='Funcall Error';
		$val='';
	    }
	    else{
		if($context->{'EVAL-RESULT'} eq 'SKIP'){$context->{'EVAL-RESULT'}=$val};
	    }
	}
    }
    # 
    elsif(ref($expr) eq 'REF'){
	$val=CtFlGet($$$expr,$hexSt);
	$val=(ref($val) eq 'ARRAY')?$val->[0]:$val;
	if(!ref($val)){ $val =~ s/^\s*//; }
	$context->{'EVAL-RESULT'}={'TY'=>'FV','ARG1'=>$val};
	$val = $val ne '';
    }
    else{
	MsgPrint('ERR',"Eval exp[%s] illeagl type[%s]\n",$expr,ref($expr));
	$context->{'EVAL-STATUS'}='illegal type';
	$val='';
    }
#    MsgPrint('RULE',"==>CtRlEvalExpr EVALResult[$context->{'EVAL-RESULT'}]\n");
    return $val;
}

# 
#   

# CtRlEvalExpr
sub CtRlSetEvalResult {
    my($context,$optype,$op,$output,$arg1,$arg2,$arg3)=@_;
    $context->{'EVAL-RESULT'}={'OP-TYPE'=>$optype,'OP'=>$op,'OUTPUT'=>$output,'ARG1'=>$arg1,'ARG2'=>$arg2,'ARG3'=>$arg3,};
}

# 
sub CtRlGetEvalResult {
    my($ruleID,$context)=@_;
    my($results,$result);
    if(ref($ruleID)){$ruleID=$ruleID->{'ID'};}
    $results=$context->{'RULE-RESULT'};
    for $result (@$results){
	if($result->{'ID'} eq $ruleID){
	    return $result->{'MSG-TYPE'},$result->{'MSG'};
	}
    }
}

# 
#   
#   
#      
#      RULE-BOOL'
#   
sub CtRlEvalArray {
    my($expr,$hexSt,$context)=@_;
    my($i,$status,$bool,$lastResult,$evaled,$allng,$order,$ruleID,$ruleObj);
    shift @_;

    # 
    $lastResult=$context->{'EVAL-RESULT'};
    $bool=$context->{'RULE-BOOL'};
    $order=$context->{'ORDER'};

    # 
    for($i=0;$i<=$#$expr;$i++){
	$context->{'EVAL-RESULT'}='SKIP';

	# SW
	if(ref($expr->[$i]) eq 'HASH' and $expr->[$i]->{'TY'} eq 'SW'){
	    unless($ruleID=CtRlEvalSw($expr->[$i])){next;}
	    ($ruleID,$ruleObj)=CtRlFindFromID($ruleID);
	    if(($ruleObj->{'OD'} ? $ruleObj->{'OD'} : 'MAIN') ne $order){
		MsgPrint('RULE',"Rule[%s] SKIP ##### rule-order[%s] env-order[%s]\n",$ruleID,$ruleObj->{'OD'},$order);
		next;
	    }
	}
	# 
	elsif(!ref($expr->[$i])){
	    ($ruleID,$ruleObj)=CtRlFindFromID($expr->[$i]);
	    if(($ruleObj->{'OD'} ? $ruleObj->{'OD'} : 'MAIN') ne $order){
		MsgPrint('RULE',"Rule[%s] SKIP ##### rule-order[%s] env-order[%s]\n",$ruleID,$ruleObj->{'OD'},$order);
		next;
	    }
	}
	else{
	    $ruleID=$expr->[$i];
	}
	# 
	$status=CtRlEvalExpr($ruleID,@_);
	# 
	if($context->{'EVAL-RESULT'} eq 'SKIP'){next;}
	$evaled='T';

	# AND
	if($bool eq 'AND' && $context->{'EVAL-STATUS'}){last;}

	# OR
	elsif(!$allng && !$context->{'EVAL-STATUS'}){$allng='No';}
    }

    # OR
    if($evaled && $bool ne 'AND' && !$allng){$context->{'EVAL-STATUS'}='all exp. ng';}

    # 
    if(!$evaled){$context->{'EVAL-RESULT'}=$lastResult;}
    return $status;
}

# TAHI 
sub CtRlMkResultMessage {
    my ($result,$rule,$hexSt,$context)=@_;
    my($msg,$fmt,$msgType,$ruleID,$detail,$v1,$v2,$v3,$spec);
    shift @_;
    shift @_;

    # 
    if($result){
	$msg=$rule->{'OK'};
	$msgType='OK';
    }
    # 
    else{
	$msg=$rule->{'NG'};
	$msgType=($rule->{'ET'} eq 'error')?'ERR':'WAR';
    }

    # 
    if(ref($context->{'EVAL-RESULT'}) eq 'HASH'){
	$v1=CtLgCnvHTML($context->{'EVAL-RESULT'}->{'ARG1'});
	$v2=CtLgCnvHTML($context->{'EVAL-RESULT'}->{'ARG2'});
	$v3=CtLgCnvHTML($context->{'EVAL-RESULT'}->{'ARG3'});
    }
    if(ref($msg) eq 'SCALAR'){
	$msg=eval $$msg;
    }
    elsif(ref($msg) eq 'REF'){
	$fmt = sprintf("sprintf(\"$$$msg\")",
		       ref($v1)?'<font color=\"mediumpurple\">@$v1</font>':'<font color=\"mediumpurple\">$v1</font>',
		       ref($v2)?'<font color=\"mediumpurple\">@$v2</font>':'<font color=\"mediumpurple\">$v2</font>',
		       ref($v3)?'<font color=\"mediumpurple\">@$v3</font>':'<font color=\"mediumpurple\">$v3</font>');
#	PrintItem($fmt);
	$msg = eval $fmt;
#	MsgPrint('RULE',$msg . "\n");
#	$msg=eval "sprintf(\"$$$msg\",\"$v1\")";
    }

    # 
    if(CtLgLevel('RULE') && $context->{'EVAL-RESULT'} && ref($context->{'EVAL-RESULT'}) eq 'HASH'){
	if($context->{'EVAL-RESULT'}->{'OP-TYPE'} eq '2op'){
	    $detail=sprintf('<font color="%s"> (%s [%s] [%s])</font>', 'gray',$context->{'EVAL-RESULT'}->{'OP'},$v1,$v2);
	}
	else{
	    $detail=sprintf('<font color="%s"> (%s %s [%s] (%s))</font>','gray',
			    $context->{'EVAL-RESULT'}->{'OP-TYPE'},$context->{'EVAL-RESULT'}->{'OP'},$v1,$v2);
	}
    }

    # 
#    $ruleID=CtLgLevel('INF')?$rule->{'ID'}:sprintf("<A HREF=\"#PKT%s:%s\">%s</A>",$rule->{'CA'},$#SIPHexSt,$rule->{'CA'});
    $ruleID=CtLgLevel('INFORMAL')?('<font color="#0099CC">'.$rule->{'ID'}.' </font>'.$rule->{'CA'}):
	(CtLgLevel('RULE')?$rule->{'ID'}:$rule->{'CA'});

    # CtRlJudge
    if($msg || CtLgLevel('RULE')){
	$spec=CtRlSpecInfo($rule->{'ID'});
	$spec=$spec->{'color'} ? $spec->{'color'} : '#00CCFF';
	$msg = sprintf('<B><font color="%s">%s: </font></B><B><font color="%s">%s</font></B>%s<BR>',
		       $spec,$ruleID,
		       $msgType eq 'OK'?'black':($msgType eq 'WAR'?'green':'red'),$msg,$detail);
    }
    
    return $msg,$msgType;
}


#============================================
# 
#============================================
sub CtRlAddSyntaxLog {
    my($msg,$hexSt,$context)=@_;
    $msg->{'PKT'}=$hexSt;
    push(@JUDGEMENTLog,$msg);
}
sub CtRlClearSyntaxLog {
    undef(@JUDGEMENTLog);
}
sub CtRlDumpSyntaxLog {
    foreach $result (@JUDGEMENTLog){
	printf("Rule:%s  result:[%s]\n",$result->{ID},($result->{MSG}=~/"red"/)?'error':(($result->{MSG}=~/"green"/)?'warning':'ok') );
    }
}

#  $result OK:not Nil NG:Nil
sub CtRlAddJudgeLogNoEval {
    my($ruleID,$result,$hexSt,$arg1,$arg2,$arg3,$diff)=@_;
    my($msg,$msgType,$msgData,$rule,%cntx);

    if(!($rule=CtRlFindFromID($ruleID))){
	MsgPrint('WAR',"CtRlAddJudgeLogNoEval Rule[%s] is not registed\n",$ruleID);
	return;
    }
    if($arg1){
	$cntx{'EVAL-RESULT'}->{'ARG1'}=$arg1;
	$cntx{'EVAL-RESULT'}->{'ARG2'}=$arg2;
	$cntx{'EVAL-RESULT'}->{'ARG3'}=$arg3;
    }
    $hexSt = '' unless(ref($hexSt));
    ($msg,$msgType)=CtRlMkResultMessage($result,$rule,$hexSt,\%cntx);

    # 
    CtRlAccSyntaxResult($rule,$result,$diff);
    
    # 
    $msgData={'ID'=>$ruleID,'MSG'=>$msg,'MSG-TYPE'=>$msgType};
    
    # HTML
    CtRlAddSyntaxLog($msgData,$hexSt);
    if(CtLgLevel('RULE')){
	CtLgAdd('RULE',' ' . $msg);
    }
}
# 
sub CtRlAccSyntaxLog {
    my($judgelogs)=@_;
    my($judge,$error,$warning);
    foreach $judge (@$judgelogs){
	$error++ if($judge->{'MSG-TYPE'} eq 'ERR');
	$warning++ if($judge->{'MSG-TYPE'} eq 'WAR');
    }
    return $#$judgelogs+1,$error,$warning;
}
# 

#============================================
# 
#============================================
sub CtRlAccSyntaxResult {
    my($rule,$result,$time)=@_;
    my($ruleID);
    $ruleID=$rule->{'ID'};
    $StatisticsRule{'total'}++;
    $StatisticsRule{$ruleID}{'total'}++;
    $StatisticsRule{$ruleID}{'time'} += $time;
    if(!$result){
	if($rule->{'ET'} eq 'warning'){
	    $StatisticsRule{'warning'}++;
	    $StatisticsRule{$ruleID}{'warning'}++;
	}
	else{
	    $StatisticsRule{'error'}++;
	    $StatisticsRule{$ruleID}{'error'}++;
	}
    }
    else{
	$StatisticsRule{$ruleID}{'ok'}++;
    }
}

# 
# 
sub CtRlSyntaxResultStats {
    # 
    return ($StatisticsRule{total},$StatisticsRule{error},$StatisticsRule{warning});
}

sub CtRlAddExecuteJudgeMsg {
    my($ruleID)=@_;
    unless($DIRRoot{'SC'}->{'ExecJudgeMsg'}){$DIRRoot{'SC'}->{'ExecJudgeMsg'}=[]}
    push(@{$DIRRoot{'SC'}->{'ExecJudgeMsg'}},$ruleID);
}
sub CtRlAddExecuteRule {
    my($rule,$hexSt,$context)=@_;
    my(%stats);
    # 
    if(ref($rule)){
        $stats{'rule'}=$rule->{'ID'};
        $stats{'add'}=$rule->{'AD'};
        $stats{'del'}=$rule->{'DL'};
    }
    else{
        $stats{'rule'}=$rule;
    }
    $stats{'message'}=CtFlv('SL,method',$hexSt) || CtFlv('SL,code', $hexSt) ;
    foreach $rule (@{$context->{'RULE-RESULT'}}){
        if( CtRlFindFromID($rule->{'ID'})->{'TY'} ne 'PROGN' ){
            push(@{$stats{'rules'}},$rule->{'ID'});
        }
    }
    $DIRRoot{'SC'}->{'ExecJudgeMsg'} = [] unless($DIRRoot{'SC'}->{'ExecJudgeMsg'});
    push(@{$stats{'rules'}},@{$DIRRoot{'SC'}->{'ExecJudgeMsg'}});
    $DIRRoot{'SC'}->{'ExecJudgeMsg'} = [];
    foreach $rule (@{$context->{'RULE-SKIP'}}){
        if( CtRlFindFromID($rule)->{'TY'} ne 'PROGN' ){
            push(@{$stats{'skips'}},$rule);
        }
    }
    $stats{'no'} = $#{CtNDPkts()};
    unless($DIRRoot{'SC'}->{'ExecRule'}){$DIRRoot{'SC'}->{'ExecRule'}=[]}
    push(@{$DIRRoot{'SC'}->{'ExecRule'}},\%stats);
}
sub CtRlExecuteRuleStats {
    my ($rule,$msg,$tmp);
    foreach $rule (@{$DIRRoot{'SC'}->{'ExecRule'}}){
        $msg .= sprintf("%03d %s\n",$rule->{'no'}+1,$rule->{'message'});
        # 
        # if($rule->{'add'}){
        #     $msg .= "add\n";
        #     map{$msg .= sprintf(" %s\n",$_)}(sort(@{$rule->{'add'}}));
        # }
        # 
        # if($rule->{'del'}){
        #     $msg .= "del\n";
        #     map{$msg .= sprintf(" %s\n",$_)}(sort(@{$rule->{'del'}}));
        # }
        # 
        # $msg .= sprintf("rule %s\n",$rule->{'rule'});
        # 
        $tmp=[];
        @$tmp=map{$_.' (skip)'}(@{$rule->{'skips'}});
        map{$msg .= sprintf(" %s\n",$_)}(sort(@{$rule->{'rules'}},@$tmp));
        $msg .= "\n";
    }
    return $msg;
}

#============================================
# 
#============================================
sub CtUtTrue {
    my($result,$hexSt,$context)=@_;
    return CtUtCp1('',$result,'',$hexSt,$context);
}
# 
sub CtUtCp1 {
    my($op,$v1,$v2,$hexSt,$context)=@_;
    my($result,$i);

    # 
    if($op eq '<>'){
	$result = $v2->[0]<$v1 && $v1<$v2->[1];
	CtRlSetEvalResult($context,'1op',$op,$result,$v1,$v2->[0],$v2->[1]);
	return $result;
    }
    # 
    elsif($op eq '<=>'){
	$result = $v2->[0]<=$v1 && $v1<=$v2->[1];
	CtRlSetEvalResult($context,'1op',$op,$result,$v1,$v2->[0],$v2->[1]);
	return $result;
    }
    # 
    elsif($op eq '<<<'){
	$result='T';
	if(ref($v1) eq 'ARRAY'){
	    for($i=0;$i<$#$v1;$i++){
		if($v2 && $v1->[$i]+$v2 ne $v1->[$i+1]){
		    $result='';
		    last;
		}
		elsif(!$v2 && $v1->[$i] >= $v1->[$i+1]){
		    $result='';
		    last;
		}
	    }
	}
	CtRlSetEvalResult($context,'1op',$op,$result,$v1,$v1->[$i],$v1->[$i+1]);
	return $result;
    }
    # 
    elsif($op eq '==='){
	$result='T';
	if(ref($v1) eq 'ARRAY'){
	    for($i=0;$i<$#$v1;$i++){
		if($v1->[$i] ne $v1->[$i+1]){
		    $result='';
		    last;
		}
	    }
	}
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v1->[$i],$v1->[$i+1]);
	return $result;
    }
    elsif($op eq 'T'){
	$result=($v1 ne '');
	CtRlSetEvalResult($context,'1op',$op,$result,$v2->[0],$v2->[1],$v2->[2]);
	return $result;
    }
    else{
	$result=($v1 ne '');
	CtRlSetEvalResult($context,'1op',$op,$result,$v1);
	return $result;
    }
    return;
}
# 
sub CtUtCp2 {
    my($op,$v1,$v2,$hexSt,$context)=@_;
    my($result);
    if($op eq 'IP6'){
	$result = (CtUtV6StrToHex($v1) eq CtUtV6StrToHex($v2));
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq 'IP4'){
	$result = CtUtV4StrToHex($v1) eq CtUtV4StrToHex($v2);
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '<'){
	$result = $v1 < $v2;
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '<='){
	$result = $v1 <= $v2;
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '>'){
	$result = $v1 > $v2;
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '>='){
	$result = $v1 >= $v2;
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '!'){
	$result = $v1 ne $v2;
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq 'in'){ #arg2
	$v1=[$v1] unless(ref($v1));
	$result = grep{$_ eq $v2} @{$v1};
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq 'mem'){ #arg2
	$result = grep{$_ eq $v1} @{$v2};
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '==='){ #
	$result = !grep{$_ ne $v2} @{$v1};
	CtRlSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    return '';
}

# 
sub CtUtEq {
    my($v1,$v2,$hexSt,$context)=@_;
    my($result);
    shift;shift;
    if($v1 eq $v2){
	CtRlSetEvalResult($context,'2op','eq',$result,$v1,$v2);
	return 'T';
    }
    if(ref($v1) || ref($v2)){
	$result=CtUtIsCmpMember('eq',$v1,$v2);
    }
    CtRlSetEvalResult($context,'2op','eq',$result,$v1,$v2);
    return $result;
}
# 
sub CtUtEQ {
    my($v1,$v2,$hexSt,$context)=@_;
    my($result);
    shift;shift;
    if(!ref($v1) && !ref($v2) && lc($v1) eq lc($v2)){
	CtRlSetEvalResult($context,'2op','EQ',$result,$v1,$v2);
	return 'T';
    }
    if(ref($v1) || ref($v2)){
	$result=CtUtIsCmpMember('EQ',$v1,$v2);
    }
    CtRlSetEvalResult($context,'2op','EQ',$result,$v1,$v2);
    return $result;
}
# 
sub CtUtEg {
    my($v1,$v2,$hexSt,$context)=@_;
    shift;shift;
    $v1 = CtUtSumElement($v1);
    $v2 = CtUtSumElement($v2);
    return CtUtCp2('<',$v1,$v2,$hexSt,$context);
}
# 
sub CtUtEge {
    my($v1,$v2,$hexSt,$context)=@_;
    shift;shift;
    $v1 = CtUtSumElement($v1);
    $v2 = CtUtSumElement($v2);
    return CtUtCp2('<=',$v1,$v2,$hexSt,$context);
}
# 
sub CtUtEl {
    my($v1,$v2,$hexSt,$context)=@_;
    shift;shift;
    $v1 = CtUtSumElement($v1);
    $v2 = CtUtSumElement($v2);
    return CtUtCp2('>',$v1,$v2,$hexSt,$context);
}
# 
sub CtUtEle {
    my($v1,$v2,$hexSt,$context)=@_;
    shift;shift;
    $v1 = CtUtSumElement($v1);
    $v2 = CtUtSumElement($v2);
    return CtUtCp2('>=',$v1,$v2,$hexSt,$context);
}
# 
sub CtUtMch {
    my($v1,$v2,$hexSt,$context)=@_;
    my ($cur, $val, $result,$op);
    if (ref($v1) eq 'ARRAY') {
        $val = $v1;
    }
    else {
        $val = [$v1];
    }
    foreach $cur (@$val) {
        $result = $cur =~ /$v2/;
        if (!$result) {
            last;
        }
    }
    CtRlSetEvalResult($context,'1op',$op,$result,$v1);
    return $result;
}
# 
sub CtUtMCH {
    my($v1,$v2,$hexSt,$context)=@_;
    my ($cur, $val, $result,$op);
    if (ref($v1) eq 'ARRAY') {
        $val = $v1;
    }
    else {
        $val = [$v1];
    }
    foreach $cur (@$val) {
        $result = $cur =~ /$v2/i;
        if (!$result) {
            last;
        }
    }
    CtRlSetEvalResult($context,'1op',$op,$result,$v1);
    return $result;
}
# 
sub CtUtSumElement {
    my($dat)=@_;
    my($sum,@dat,$i);
    if(!ref($dat)){
	if( $dat =~ /^[0-9\-]+$/ ){
	}
	elsif( $dat =~ /^[0-9a-fA-F\-]+$/ ){
	    $dat=hex($dat);
	}
	return $dat;
    }
    elsif(ref($dat) eq 'ARRAY'){
	for $i (0..$#$dat){
	    $sum += CtUtSumElement($dat->[$i]);
	}
	return $sum;
    }
    elsif(ref($dat) eq 'HASH'){
	@dat = values(%$dat);
	return CtUtSumElement(\@dat);
    }
    return 0;
}
# 
sub CtUtTotalElement {
    my($dat)=@_;
    if($dat eq ''){return 0;}
    if(ref($dat) eq 'ARRAY'){return $#$dat+1;}
    return 1;
}
sub CtUtIsInclude {
    my($op,$v1,$v2,$hexSt,$context)=@_;
    my($result);
    shift;shift;shift;
    if($v1 eq $v2){
	CtRlSetEvalResult($context,'2op','include','T',$v1,$v2);
	return 'T';
    }
    $v2=[$v2] if(!ref($v2));
    if( grep{ CtUtIsCmpMember($op,$v1,$_) } @$v2 ){
	CtRlSetEvalResult($context,'2op','include','T',$v1,$v2);
	return 'T';
    }
    CtRlSetEvalResult($context,'2op','include',$result,$v1,$v2);
    return ;
}
# 
# 
sub CtUtIsCmpMember {
    my($op,$v1,$v2,$inc)=@_;
    my($i,$j,@v1key,@v2key);
    if(ref($v1) eq 'ARRAY' || ref($v2) eq 'ARRAY'){
	if(ref($v1) ne 'ARRAY'){$v1=[$v1];}
	if(ref($v2) ne 'ARRAY'){$v2=[$v2];}
	if($#$v1 ne $#$v2){return;}
	if($inc){
	    for($i=0;$i<=$#$v1;$i++){
		for($j=0;$j<=$#$v1;$j++){
		    if(CtUtIsCmpMember($op,$v1->[$i],$v2->[$j],$inc)){goto MATCH1;}
		}
		return;
	      MATCH1:
	    }
	    for($i=0;$i<=$#$v1;$i++){
		for($j=0;$j<=$#$v1;$j++){
		    if(CtUtIsCmpMember($op,$v1->[$j],$v2->[$i],$inc)){goto MATCH2;}
		}
		return;
	      MATCH2:
	    }
	    return 'T';
	}
	else{
	    # 
	    for($i=0;$i<=$#$v1;$i++){
		if(!CtUtIsCmpMember($op,$v1->[$i],$v2->[$i],$inc)){return;}
	    }
	}
	return 'T';
    }
    elsif(ref($v1) ne ref($v2)){return;}
    elsif(ref($v1) eq 'HASH'){
	@v1key=sort keys(%$v1);
	@v2key=sort keys(%$v2);
	if($#v1key ne $#v2key){return;}
	if(!CtUtIsCmpMember($op,\@v1key,\@v2key,$inc)){return;}
	for($i=0;$i<=$#v1key;$i++){
	    if(!CtUtIsCmpMember($op,$v1->{@v1key[$i]},$v2->{@v1key[$i]},$inc)){return;}
	}
	return 'T';
    }
    elsif(!ref($v1)){
	if($op eq 'eq'){return $v1 eq $v2;}
	if($op eq 'EQ'){return lc($v1) eq lc($v2);}
	return eval "($v1) $op ($v2)";
    }
    else{return $v1 eq $v2;}
}
# 
sub CtUtIsMember {
    my($v1,$v2,$hexSt,$context)=@_;
    my($result,$i,$v3);
    shift;shift;

    if(!$v1 || $v1 eq $v2){$result='T';}
    elsif(ref($v1) eq 'ARRAY'){
	for $i (0..$#$v1){
	    if(!ref($v2)){$result=$v1->[$i] eq $v2;}
	    elsif(ref($v2) eq 'ARRAY'){$result=grep{$_ eq $v1->[$i]} @$v2;}
	    else{$result='';}
	    if(!$result){$v3=$v1;$v1=$v1->[$i];last;}
	}
    }
    elsif(ref($v2) eq 'ARRAY'){
	$result=grep{$_ eq $v1} @$v2;
    }
    if($context){CtRlSetEvalResult($context,'2op','include',$result,$v1,$v2,$v3);}
    return $result;
}
sub CtUtIsNonMember {
    my($v1,$v2,$hexSt,$context)=@_;
    my($result,$i);
    shift;shift;
    if($v1 eq $v2){$result='';}
    elsif(ref($v1) eq 'ARRAY'){
	for $i (0..$#$v1){
	    if(!ref($v2)){$result=$v1->[$i] ne $v2;}
	    elsif(ref($v2) eq 'ARRAY'){$result=!grep{$_ eq $v1->[$i]} @$v2;}
	    else{$result='OK';}
	    if(!$result){last;}
	}
    }
    elsif(ref($v2) eq 'ARRAY'){
	$result=!grep{$_ eq $v1} @$v2;
    }
    else{
	$result=(ref($v1) eq ref($v2)) && ($v1 ne $v2);
    }
    CtRlSetEvalResult($context,'2op','include',$result,$v1,$v2);
    return $result;
}

# 
sub CtUtIsIncludeAssoc {
    my($v1,$v2)=@_;
    my(@v2key,$i);
    @v2key=keys(%$v2);
    for($i=0;$i<=$#v2key;$i++){
	if(!CtUtIsCmpMember('eq',$v1->{@v2key[$i]},$v2->{@v2key[$i]})){return;}
    }
    return 'T';
}

sub CtUtCompTree {
    my($base,$sub)=@_;
    my(@keys,$i,$j,$subbase,$expr);

    if(ref($base) ne ref($sub)){return;}

    # 
    if(ref($base) eq 'ARRAY'){
	for($i=0;$i<=$#$sub;$i++){
	    $expr=$sub->[$i];
	    for($j=0;$j<=$#$base;$j++){
		if( $base->[$j] eq $expr ){goto MATCH;}
		elsif(ref($expr) eq 'HASH')  {if( CtUtCompTree($base->[$j],$expr) ){goto MATCH;}}
		elsif(ref($expr) eq 'ARRAY') {if( CtUtCompTree($base->[$j],$expr) ){goto MATCH;}}
		elsif(ref($expr) eq 'CODE')  {if( $expr->($base->[$j]) ){goto MATCH;}}
		elsif(ref($expr) eq 'SCALAR'){if( $base->[$j] =~ $$expr ){goto MATCH;}}
		elsif(ref($expr) eq 'REF')   {if( eval $$$expr ){goto MATCH;}}
	    }
	    return;
	  MATCH:
	}
	return TRUE;
    }

    # 
    @keys=keys(%$sub);
    for($i=0;$i<=$#keys;$i++){
	$expr=$sub->{@keys[$i]};
	if(!ref($expr))              {if( $base->{@keys[$i]} ne $expr ){return;}}
	elsif(ref($expr) eq 'HASH')  {if( !CtUtCompTree($base->{@keys[$i]},$expr) ){return;}}
	elsif(ref($expr) eq 'ARRAY') {if( !CtUtCompTree($base->{@keys[$i]},$expr) ){return;}}
	elsif(ref($expr) eq 'CODE')  {if( !$expr->($base->{@keys[$i]}) ){return;}}
	elsif(ref($expr) eq 'SCALAR'){if( !($base->{@keys[$i]} =~ $$expr) ){return;}}
	elsif(ref($expr) eq 'REF')   {if( !(eval $$$expr) ){return;}}
	else{return ;}
    }
    return TRUE;
}

# 
sub CtUtIsUniqueElm {
    my($val,$except)=@_;
    my(%elem,$i);
#    PrintVal($val);
    if(ref($val) ne 'ARRAY'){return 'T';}
    for $i (0..$#$val){
	if(defined($except)){
	    if($val->[$i] eq $except){next;}
	    if(ref($except) eq 'ARRAY' && grep{$_ eq $val->[$i]}@$except){next;}
	}
	if($elem{$val->[$i]}){return;}
	$elem{$val->[$i]}='T';
    }
    return 'T';
}

# CtUtMap
sub CtUtMap {
    my($op,@vals)=@_;
    my($R,$V);

    foreach $V (@vals){
	if($op eq '+'){
	    if(ref($V) eq 'ARRAY'){
		$R += CtUtMap($op,@$V);
	    }
	    elsif(!ref($V)){
		$R += $V;
	    }
	}
	elsif($op eq '*'){
	    if(ref($V) eq 'ARRAY'){
		$R *= CtUtMap($op,@$V);
	    }
	    elsif(!ref($V)){
		$R *= $V;
	    }
	}
	elsif(ref($op) eq 'CODE'){
	    if(ref($V) eq 'ARRAY'){
		$R = CtUtMap($op,@$V);
	    }
	    else{
		$R = $op->($V,$R);
	    }
	}
	elsif(ref($op) eq 'SCALAR'){
	    if(ref($V) eq 'ARRAY'){
		$R = CtUtMap($op,@$V);
	    }
	    else{
		$R=eval $$op;
	    }
	}
    }
    return $R;
}


1;
