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

#=================================
# 
#=================================
sub SD_Proxy_INVITE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame=NDINF('SFRAME'); }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.INVITE.PX'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Proxy_INVITE result[$result]\n");
    return $result;
}
sub SD_Proxy_ACK {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame=NDINF('SFRAME'); }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.ACK-2XX.PX'; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Proxy_ACK result[$result]\n");
    return $result;
}
sub SD_Proxy_ACK_NO200 {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame=NDINF('SFRAME'); }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.ACK-TWOPX-no2xx.PX1'; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Proxy_ACK_NO200 result[$result]\n");
    return $result;
}
sub SD_Proxy_BYE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame=NDINF('SFRAME'); }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.BYE.PX'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Proxy_BYE result[$result]\n");
    return $result;
}
sub SD_Proxy_CANCEL {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame=NDINF('SFRAME'); }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.CANCEL.PX'; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Proxy_CANCEL result[$result]\n");
    return $result;
}
sub SD_Proxy_STATUS {
    my($code,$request,$rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame=NDINF('SFRAME'); }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}

    # 
    if(!$rule){
	if($code eq 100){
            #20050114 ES.STATUS.100.PX
	    $rule='ES.STATUS.100.PX';
	}
	if($code eq 180){
            # 20050114 ES.STATUS.180.PX
	    $rule='ES.STATUS.180.PX';
	}
	if($code eq 200){
	    if($request eq 'INVITE'){
            # 20050114 ES.STATUS.200-SDP-ANS.PX
		$rule='ES.STATUS.200-SDP-ANS.PX';
	    }
	    elsif($request eq 'CANCEL'){
		$rule='ES.STATUS.200-CANCEL-RETURN.PX';
#		$rule='E.STATUS-200-RETURN-TWOPX.PX1.CANCEL';
	    }
	    elsif($request eq 'BYE'){
		$rule='ES.STATUS.200.PX';
	    }
	    elsif($request eq 'REGISTER'){
		$rule='ES.STATUS.REGISTER-200.PX';
	    }
	    elsif($request eq 'OPTIONS'){
		$rule='ES.STATUS.OPTIONS-200.PX';
	    }
	}
	if($code eq 401){             # 20050118 401
	    $rule='E.STATUS-401-RETURN-AUTH-2VIA.PX1';
	}
	if($code eq 407){             # 20050118 407
	    $rule='E.STATUS-407-RETURN-AUTH-2VIA.PX1';
	}
	if($code eq 480){
 	    $rule='ES.STATUS-480-RETURN.PX';
 	}
	if($code eq 486){
 	    $rule='ES.STATUS-486-RETURN.PX';
 	}
	if($code eq 487){
 	    $rule='ES.STATUS-487-RETURN.PX';
 	}
    }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Proxy_STATUS result[$result]\n");
    return $result;
}

#=================================
# 
#=================================
sub SD_Term_INVITE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.INVITE.TM'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Term_INVITE result[$result]\n");
    return $result;
}

sub SD_Term_INVITEwithAuth {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.INVITE-AUTH.TM'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Term_INVITE result[$result]\n");
    return $result;
}
sub SD_Term_ACK {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.ACK-2XX.TM'; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Term_ACK result[$result]\n");
    return $result;
}
sub SD_Term_ACK_NO200 {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.ACK-NO2XX.TM'; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Term_ACK_NO200 result[$result]\n");
    return $result;
}

sub SD_Term_BYE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.BYE.TM'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Term_BYE result[$result]\n");
    return $result;
}
sub SD_Term_CANCEL {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.CANCEL.TM'; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Term_CANCEL result[$result]\n");
    return $result;
}
sub SD_Term_OPTIONS {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.OPTIONS.TM'; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Term_OPTIONS result[$result]\n");
    return $result;
}
sub SD_Term_STATUS {
    my($code,$request,$rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}

    # 
    if(!$rule){
	if($code eq 100){
	    $rule='ES.STATUS.100.TM';
	}elsif($code eq 180){
		# 20050310 tadokoro mod
	    $rule='ES.STATUS.180.TWOPX.TM';
	}elsif($code eq 200){
	    if($request eq 'INVITE'){
		# 20050310 tadokoro mod
		$rule='ES.STATUS.200-SDP-ANS.TWOPX.TM';
	    }
	    elsif($request eq 'CANCEL'){
		$rule='ES.STATUS.200.ONEPX.TM';
	    }
	    elsif($request eq 'BYE'){
		# 20050310 tadokoro mod
		$rule='ES.STATUS.200.TWOPX.TM';
	    }
 	}elsif($code eq 480){
 	    $rule='ES.STATUS-480-RETURN.TM';
 	}elsif($code eq 486){
 	    $rule='ES.STATUS-486-RETURN.TM';
 	}elsif($code eq 487){
 	    $rule='ES.STATUS-487-RETURN.TM';
 	}elsif($code eq 503){
 	    $rule='ES.STATUS-503-RETURN.TM';
 	}
    }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_Term_STATUS result[$result]\n");
    return $result;
}

# SIP REGSITER 
sub SD_Term_REGISTER {
    my($rule,$pktinfo,$addrule,$delrule,$frame,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='ES.REQUEST.REGISTER.TM'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame||NDINF('SFRAME'),$addrule,$delrule,$conn,$link);
    MsgPrint('SEQ',"SD_UA1_REGISTER result[$result]\n");
    return $result;
}

sub RegisterTimingSS {
 my($waitTime,$margin)=@_;
 $WaitRegistTime=$waitTime;
 $WaitMargin=$margin;
 sleep($waitTime);
}

# Type:3 Code:0 
sub SD_Term_UnReachable {
    my($pktinfo,$link)=@_;
    my($msg);
    if($pktinfo eq ''){$pktinfo=$SIPPktInfoLast;}

    if(!$pktinfo || !($msg=$pktinfo->{'frame_txt'})){
	MsgPrint('ERR',"ICMP UnReachable playload dose not exist.");
	return '';
    }
#    return SD_SIP_ICMP_ERROR($msg,$pktinfo,3,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'ICMPERR'},$link);
    return SD_SIP_ICMP_ERROR($msg,$pktinfo,1,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'ICMPERR'},$link);
}
# Type:11 Code:0 
sub SD_Term_TimeExceeded {
    my($pktinfo,$link)=@_;
    my($msg);
    if($pktinfo eq ''){$pktinfo=$SIPPktInfoLast;}

    if(!$pktinfo || !($msg=$pktinfo->{'frame_txt'})){
	MsgPrint('ERR',"ICMP UnReachable playload dose not exist.");
	return '';
    }
#    return SD_SIP_ICMP_ERROR($msg,$pktinfo,11,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'ICMPERR'},$link);
    return SD_SIP_ICMP_ERROR($msg,$pktinfo,3,$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'ICMPERR'},$link);
}

#=================================
# 
#=================================
sub RegistDNS {
    if($CNT_CONF{'DNS-RESOLV'} eq 'YES'){
	SEQ_DNS6();
	SEQ_Start('DNS');
    }
}
# DNS
sub SEQ_DNS6 {
    my($node,$func);
    
    $node=NDDefStart("DNS",'','','','background');
    
    # DNS
    $func=sub {
	my($result,$frame)=@_;
	RecActDNSAnswer($SIP_DNS_ANSWER_MODE,'',$frame);
	return 'CONTINUE';
    };
    NDGenericAction($node,$func,'','',0);
    NDDefEnd($node);
}

#=================================
# 
#=================================
# SIP_Send
sub SD_RTP {
    my ($sendFrame,$sendModf,$link) = @_;
    if( $link eq '' )     { $link=$SIP_Link; }
    if( $sendFrame eq '' ){ $sendFrame='RTP'; }

    my ($ret,@frames,@unknown);
    @frames=();

    # RTP
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'SendMode'}= 'first';
    
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$SIP_TimeOut,'',$link);
    CheckStatus($ret);

    return($ret);
}

#=================================
# ICMP
#=================================
# Echo request
#   
sub SQ_Proxy_Echo {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$nonAutoRegist,$autoResponse,$link) = @_;
    if( !$link ){ $link=$SIP_Link; }
    if( !$autoResponse ){ $autoResponse=\@SIP_AutoResponse; }
    if( !$timeout ){ $timeout=6; }
    if( !$recvFrame ){ $recvFrame='EchoReplyToServ'; }
    if( !$sendFrame ){ $sendFrame='EchoRequestFromServ'; }
    
    my ($ret,@frames,@unknown,%pkt1,%pkt2);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'SendMode'}= 'first';
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';
    
    $frames[1]{'Send'}='';
    $frames[1]{'SendMode'}='';
    $frames[1]{'SendModf'}='';
    $frames[1]{'Recv'}='SIPtoDNS';
    $frames[1]{'RecvMode'}='';
    $frames[1]{'RecvModf'}='';
    $frames[1]{'RecvMatch'}='';
    $frames[1]{'RecvAction'}=\'RecActDNSAnswer($SIP_DNS_ANSWER_MODE,@_)';
    $frames[1]{'SendAction'}='';

    if(!$nonAutoRegist){
       $frames[2]{'Recv'}= $CNT_RG_FRAME;
       $frames[2]{'RecvMatch'}= \'MatchSIPRequest(REGISTER,@_)'; # SIPtoREG
       $frames[2]{'RecvAction'}= \q{RecActEvalRuleAndResponse('D.REGISTER.AutoResponse','E.STATUS-200-RETURN.RG',SIPfromREG,@_)};
    }
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);

    if($frames[0]{'SendFrame'}){
        $pkt1{pkt}=$frames[0]{'SendFrame'};
        $pkt1{timestamp}=$pkt1{pkt}->{sentTime1};
        $pkt1{dir}='send';
        StoreICMPPktInfo(\%pkt1);
    }
    if($frames[0]{'RecvFrame'}){
        $pkt2{pkt}=$frames[0]{'RecvFrame'};
        $pkt2{timestamp}=$pkt2{pkt}->{recvTime1};
        $pkt2{dir}='recv';
        StoreICMPPktInfo(\%pkt2);
    }

    CheckStatus($ret);
    MsgPrint('SEQ',"SQ_Proxy_Echo [$ret]\n");
    return($ret);
}

# 
#  
sub RV_Term_STATUS {
    my($recvCode,$correspondMsg,$rule,$addrule,$conn,$timeout,$link)=@_;
    my($exp,$result);
    if( $rule eq '' ){ $rule='D.STATUS.TM'; }
    if( $SIP_PL_TRNS ne 'UDP' && !$conn){ $conn=CNN();}

    # 
    if(ref($recvCode) eq 'ARRAY'){
	$exp=\sprintf(q{RecActGeneralStatus(['%s'],'%s',@_)},join(q{','},@$recvCode),$correspondMsg);
    }
    else{
	$exp=\sprintf(q{RecActGeneralStatus('%s','%s',@_)},$recvCode,$correspondMsg);
    }
    $result = RecvAndEvalDecodeRule($rule,NDINF('RFRAME'),'STATUS',$exp,$addrule,$conn,
				    $timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('SEQ',"RV_Term_STATUS result[$result]\n");
    return $result;
}

#========================================================================================
# 
#========================================================================================

# SIP
sub RecActGeneral {
    my($breakCode,$request,$recvFrame,$context)=@_;
    my($pktinfo,$code,$rule);

    # SIP
    if( !($pktinfo=$request->{'RecvStruct'}) ){
	MsgPrint('ERR', "SIP Structured data is not exist,skip send response\n");
	return '';
    }
    SipParsePart($pktinfo,'COMMAND');

    # 
    if( $pktinfo->{command}->{tag} eq 'Request-Line' ){
	goto EXIT;
    }

    # 
    $code=$pktinfo->{command}->{'Status-Line'}->{code};

    # 100
    if($code =~ /^1/){
        LOG_OK("Received $code");
	# 
	if( $rule = GetDefaultStatusDecodeRule($code) ){
	    EvalRule($rule,$pktinfo);
	}
	# 
	if( $rule = GetDefaultStatusSyntaxRule($code,$request->{'Recv'}) ){
	    # 
	    SIP_Judgment($rule,'',$pktinfo);
	}
    }

EXIT:
    if($breakCode){
	if(ref($breakCode) eq 'SCALAR'){
	    if( eval($$breakCode) ){return 'OK';}
	}
	elsif($breakCode eq $code){return 'OK';}
    }
    return '';
}

# 
#   
#   
#   
sub RecvAndEvalDecodeRule {
    my($decodeRule,$frame,$recvMag,$actexp,$addrule,$conn,$timeout,$link,$autoRegist,$autoDNS)=@_;
    if( $link eq '')        { $link=$SIP_Link; }
    if( $timeout eq '')     { $timeout=$SIP_TimeOut; }

    my($exp,$result,$pktinfo,$ret,@frames);
    @frames=();

    # 
    $frames[0]{'Recv'}= $frame;
    $frames[0]{'RecvMode'}= $actexp?'actstop':'stop';
    $frames[0]{'Connection'}= $conn;
    # SIP
    if($recvMag eq 'REQUEST'){
	$exp=\q{MatchSIPRequest('',@_)};  
    }
    elsif($recvMag eq 'STATUS'){
	$exp=\q{MatchSIPStatus('','',@_)};
    }
    elsif(ref($recvMag) eq 'SCALAR'){
	$exp=\sprintf(q{MatchSIPRequest(\q{%s},@_)},$$recvMag);
    }
    else{
	$exp=\sprintf(q{MatchSIPRequest(%s,@_)},$recvMag);
    }
    $frames[0]{'RecvMatch'}= $exp;
    # 
    if($actexp){$frames[0]{'RecvAction'}= $actexp;}

    return RecvAndEvalDecodeRuleExt($decodeRule,\@frames,$addrule,$timeout,$link,$autoRegist,$autoDNS);
}

sub RecvAndEvalDecodeRuleExt {
    my($decodeRule,$frames,$addrule,$timeout,$link,$autoRegist,$autoDNS)=@_;
    if( $link eq '')        { $link=$SIP_Link; }
    my($result,$pktinfo,$ret,$size,@unknown,@stack,$i);

    $size=$#$frames;
    # REGISTER
    if($autoRegist){
	$size++;
	$$frames[$size]{'Recv'}= $CNT_RG_FRAME;
	$$frames[$size]{'RecvMatch'}= \'MatchSIPRequest(REGISTER,@_)'; # SIPtoREG
        $$frames[$size]{'RecvAction'}= \q{RecActEvalRuleAndResponse('D.REGISTER.AutoResponse','E.STATUS-200-RETURN.RG',SIPfromREG,@_)};
    }

    # DNS
    if($autoDNS){
	$size++;
        $$frames[$size]{'Recv'}='SIPtoDNS';
        $$frames[$size]{'RecvMode'}='';
        $$frames[$size]{'RecvMatch'}='';
        $$frames[$size]{'RecvAction'}=\sprintf('RecActDNSAnswer(%s,@_)',$autoDNS);
        $$frames[$size]{'SendMode'}='';
        $$frames[$size]{'SendAction'}='';
    }

    # 
    $ret = CNT_SendAndRecv($frames,\@unknown,$timeout,\@SIP_AutoResponse,$link);
    if($ret ne 'OK'){
	@stack=caller(1);
	MsgPrint('ERR', "SIP message dose not receive[%s] callby[%s]\n",$ret,$stack[3]);
	return $ret;
    }
    for($i=0;$i<=$size;$i++){
       if($$frames[$i]{'RecvStruct'}){
          $pktinfo=$$frames[$i]{'RecvStruct'};
          last;
       }
    }

    if($decodeRule && $pktinfo){
       # 
       $decodeRule = RuleModify($decodeRule,$addrule);

       # 
       $result=EvalRule($decodeRule,$pktinfo);

       if(!$result){
	   MsgPrint('ERR', "SIP message decode error\n");
	   $ret='ActionError';
       }
    }

    @stack=caller(1);MsgPrint('SEQ', "%s result[%s]\n",$stack[3],$ret);
    return $ret;
}


# SIP
sub RecActUnreachable {
    my($frame,$request,$recvFrame,$context)=@_;
    my($pktinfo,$msg,$link);

    $link=$context->{'LINK:'};
    # SIP
    if( !($pktinfo=$request->{'RecvStruct'}) || !($msg=$pktinfo->{'frame_txt'}) ){
	MsgPrint('ERR', "SIP Structured data is not exist,skip send ICMP Unreachable\n");
	return '';
    }
    return SD_SIP_ICMP_ERROR($msg,$pktinfo,1,$frame,$link);
}

# 
#   
#   
#   
sub RecActGeneralStatus {
    my($recvCode,$correspondMsg,$request,$recvFrame,$context)=@_;
    my($result,$pktinfo,$msg,$code,$i,$method,$count,$rule);

    # SIP
    if( !($pktinfo=$request->{'RecvStruct'}) ){
	MsgPrint('ERR', "SIP Structured data is not exist,skip send response\n");
	return 'ActionError';
    }
    SipParsePart($pktinfo,'COMMAND');
    $code=$pktinfo->{command}->{'Status-Line'}->{code};

    # 
    if($correspondMsg){
	($method,$count)=GetSIPField('HD.CSeq.val.method',$pktinfo);
	if($$method[0] ne $correspondMsg){return '';}
    }

    # 
    if(ref($recvCode) eq 'ARRAY'){
	for($i=0;$i<=$#$recvCode;$i++){
	    if( $code eq $recvCode->[$i] || $code =~ /$recvCode->[$i]/){
		MsgPrint('SEQ',"State code(%s) recived\n",$code);
		return 'OK';
	    }
	}
    }
    elsif($code eq $recvCode || $code =~ /$recvCode/){
	MsgPrint('SEQ',"State code(%s) recived\n",$code);
	return 'OK';
    }

    # 100
    if($code =~ /^1/){
        LOG_OK("Received $code");
	# 
	if( $rule = GetDefaultStatusDecodeRule($code) ){
	    EvalRule($rule,$pktinfo);
	}
	# 
	if( $rule = GetDefaultStatusSyntaxRule($code,$request->{'Recv'}) ){
	    # 
	    SIP_Judgment($rule,'',$pktinfo);
	    return '';
	}
	return '';
    }

    # 
    MsgPrint('ERR',"Unexpected status code(%s) received\n",$code);

#    if($CNT_CONF{'FAILCONTINUE'} ne 'ON'){
#       ExitScenario('Fail');
#    }
    return 'TimeOut';
}

#============================================
# SIP ICMP error
#============================================
# SIP_Send
#   TYPE:1(unreachable) Code:0  /  TYPE:3(time exceed) Code:0
sub SD_SIP_ICMP_ERROR {
    my ($sipmsg,$pktinfo,$errType,$sendFrame,$link) = @_;
    if( $link eq '' )     { $link=$SIP_Link; }
    if( $sendFrame eq '' ){ $sendFrame='ICMPErrorFromUA11'; }

    my ($ret,@frames,@unknown,$cpp,%pkt1);
    @frames=();

    # 
    $cpp=sprintf(" -DSIP_RECVED_TRAFFICCLASS=%s -DSIP_RECVED_FLOWLABEL=%s -DSIP_RECVED_PAYLOADLENGTH=%s " .
		 "-DSIP_RECVED_NEXTHEADER=%s -DSIP_RECVED_HOPLIMIT=%s " .
		 "-DSIP_RECVED_SRC_ADDR=v6\\\(\\\"%s\\\"\\\) -DSIP_RECVED_DST_ADDR=v6\\\(\\\"%s\\\"\\\) " .
		 "-DSIP_RECVED_SRC_PORT=%s -DSIP_RECVED_DST_PORT=%s " .
		 "-DICMP_ERROR_TYPE=%s -DICMP_ERROR_CODE=%s ",
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.TrafficClass'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.FlowLabel'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.PayloadLength'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.NextHeader'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.HopLimit'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.SourcePort'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.DestinationPort'},
		 $errType,$errType eq 1?0:0 );

    # 
    $cpp=SetupVCPPString($cpp);

    # 
    CNT_WriteSipMsg($sipmsg);

    # ICMP
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'SendModf'}= $cpp;
    $frames[0]{'SendMode'}= 'first';
    
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$SIP_TimeOut,'',$link);

    if($frames[0]{'SendFrame'}){
        $pkt1{pkt}=$frames[0]{'SendFrame'};
        $pkt1{timestamp}=$pkt1{pkt}->{sentTime1};
        $pkt1{dir}='send';
        StoreICMPPktInfo(\%pkt1);
    }
    CheckStatus($ret);
    return($ret);
}

# DNS
#   
#                 SRV SRV,NS,AAAA
sub RecActDNSAnswer {
    my($mode,$request,$recvFrame,$context)=@_;
    my($srcPort,$transactID,$ra,@query,$querySize,$key,$i,$fqdn,$addr,$type,$class,$cpp,$count,%pkt,$proto,$ssl);

    # 
    $srcPort = $recvFrame->{'Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.SourcePort'};

    # 
    $transactID = $recvFrame->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DNS.Identifier'};

    # Query or Response
    $ra = $recvFrame->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DNS.RA'};

    # Query
    $querySize=$recvFrame->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DNS.ANCount#'};
    
    if($srcPort eq '' || $transactID eq '' || $ra eq '' || $querySize <=0){
	MsgPrint('WAR',"DNS query enexpected form srcport[%s] tranID[%s] RA[%s] Questions[%s]\n",
		 $srcPort,$transactID,$ra,$querySize);
	return '';
    }

    # 
    for($i=0;$i<$querySize;$i++){

	# Questions
	$key=sprintf('Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DNS.DNS_Question.DNS_QuestionEntry%s.Type',$i?$i+1:'');
	$type=int($recvFrame->{$key});

	# Questions
	$key=sprintf('Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DNS.DNS_Question.DNS_QuestionEntry%s.Class',$i?$i+1:'');
	$class=int($recvFrame->{$key});

	# Questions
	$key=sprintf('Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DNS.DNS_Question.DNS_QuestionEntry%s.Name',$i?$i+1:'');
	$fqdn=$recvFrame->{$key};

	$addr=FindAAAARecord($fqdn);

	if($fqdn){ # AAAA
	    $query[$i]{FQDN}=$fqdn;
	    $query[$i]{TYPE}=$type;
	    $query[$i]{CLASS}=$class;
	    $query[$i]{AAAA}=$addr->{'IPV6'};
	}

	if( $type eq 0x1c && $class eq 1 && $addr->{'IPV6'}){$count++;}
    }

    $pkt{pkt}=$recvFrame;
    $pkt{timestamp}=$recvFrame->{recvTime1};
    $pkt{dir}='recv';
    $pkt{query}="$query[0]{FQDN}(T:$query[0]{TYPE})";
    if($type eq 0x21){  # TYPE == SRV(
	if( $query[0]{FQDN} =~ /^_((?:sip|sips))\._((?:udp|tcp))\.(.+)/i ){
	    $ssl=$1;
	    $proto=$2;
	    $fqdn=$3;
	    $addr=FindSRVRecord($fqdn);
	}
	if($addr){
	    $cpp=sprintf("%s -DDNS_UDP_DST_PORT=%d -DDNS_TRANSACTION_ID=%d -DDND_TTL=%d -DAAAA_FQDN1=\\\"%s\\\" -DAAAA_TYPE1=%s -DAAAA_CLASS1=%s -DDNS_TARGETNAME=\\\"%s\\\"  -DSRV_PORT=%d ",
			 $SIP_BASE_CPP,$srcPort,$transactID,$SIP_DNS_TTL,
			 $query[0]{FQDN},$query[0]{TYPE},$query[0]{CLASS},$addr->{'FQDN'},$ssl =~ /sips/i ? 5061:5060);
	    vCPP($cpp);
	    
	    # SRV
	    SD_RTP('SIPfromDNS_SRV');
	    $pkt{answer}='SRV';
	    $pkt{'answer-mode'}=0;
	}
	else{
	    MsgPrint('SEQ',"Can't find SRV record[%s]\n",$query[0]{FQDN});
	}
    }
    # 
    elsif($count eq ''){
	$cpp=sprintf("%s -DDNS_UDP_DST_PORT=%d -DDNS_TRANSACTION_ID=%d -DAAAA_FQDN1=\\\"%s\\\" -DAAAA_TYPE1=%s -DAAAA_CLASS1=%s ",
		     $SIP_BASE_CPP,$srcPort,$transactID,$query[0]{FQDN},$query[0]{TYPE},$query[0]{CLASS});
        if ($query[0]{FQDN} eq '' || $query[0]{TYPE} eq '' || $query[0]{CLASS} eq '') {
	    if ($query[0]{FQDN} eq '') {
		MsgPrint('WAR',"DNS query name is null. \n");
		return '';
	    }
	    else {
		MsgPrint('WAR',"DNS query any of parameter null, FQDN[%s] TYPE[%s] CLASS[%s]\n",
		     $query[0]{FQDN},$query[0]{TYPE},$query[0]{CLASS});
		return '';
	    }
        }
	vCPP($cpp);
	SD_RTP('SIPfromDNS_NONE');
	$pkt{answer}='No Host';
	$pkt{'answer-mode'}=0;
    }
    # 
    else{
	$cpp=sprintf("%s -DDNS_UDP_DST_PORT=%d -DDNS_TRANSACTION_ID=%d -DDND_TTL=%d -DAAAA_FQDN1=\\\"%s\\\" -DAAAA_TYPE1=%s -DAAAA_CLASS1=%s -DAAAA_IP6ADDR1=\\\"%s\\\" -DAAAA_IP6ADDR2=\\\"%s\\\" ",
		     $SIP_BASE_CPP,$srcPort,$transactID,$SIP_DNS_TTL,
		     $query[0]{FQDN},$query[0]{TYPE},$query[0]{CLASS},$query[0]{AAAA},$SIP_OTHER_AAAA);
	vCPP($cpp);

	# DNS
	SD_RTP(($mode eq 'AAAA2' && $addr->{'2RECORD'})?'SIPfromDNS_AAAA2':'SIPfromDNS_AAAA1');
	$pkt{answer}=$query[0]{AAAA};
	$pkt{'answer-mode'}=($mode eq 'AAAA2' && $addr->{'2RECORD'})?'2':'1';
    }
    # DNS
    StoreDNSPktInfo(\%pkt);
}

1;

