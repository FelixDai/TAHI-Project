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

# 
sub SD_Registra_STATUS {
    my($code,$request,$rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromREG,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Registra_STATUS result[$result]\n");
    return $result;
}
sub SD_Registra_MSG {
    my($header,$body,$addrule,$pktinfo,$conn,$link)=@_;
    my($rule,$result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}

    # \n
    if($header =~ /\n/ && $header !~ /\r/){
	$header =~ s/\n/\r\n/g;
    }
    $header =~ s/[\r\n]*$//;
    if($body){
	if($body =~ /\n/ && $body !~ /\r/){
	    $body =~ s/\n/\r\n/g;
	}
	$body =~ s/[\r\n]*$//;
    }

    # 
    if($body){
	$rule =
	{'TY:'=>'RULESET', 'ID:'=>'E.TORTURE.tmp', 'MD:'=>SEQ, 
	 'RR:'=>[{'TY:'=>'ENCODE','ID:'=>'E.TORTURE.hd','PT:'=>HD, 'FM:'=>$header},
		 {'TY:'=>'ENCODE','ID:'=>'E.TORTURE.bd','PT:'=>BD, 'FM:'=>$body}],
	 'AD:'=>$addrule, 'EX:'=>\&MargeSipMsg};
    }
    else{
	$rule =
	{'TY:'=>'RULESET', 'ID:'=>'E.TORTURE.tmp', 'MD:'=>SEQ, 
	 'RR:'=>[{'TY:'=>'ENCODE','ID:'=>'E.TORTURE.hd','PT:'=>HD, 'FM:'=>$header},],
	 'AD:'=>$addrule, 'EX:'=>\&MargeSipMsg};
    }
    RegistRuleSet($rule);
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromREG,'','',$conn,$link);
    MsgPrint('INF',"SD_Registra_MSG result[$result]\n");
    return $result;
}

#=================================
# 
#=================================
sub RV_Registra_REGISTER {
    my($rule,$addrule,$conn,$timeout,$link)=@_;
    my($result);
    if($rule eq ''){ $rule='D.REGISTER.AutoResponse'; }

    # REGISTER
    $result = RecvAndEvalDecodeRule($rule,$CNT_RG_FRAME,REGISTER,'',$addrule,$conn,$timeout,$link,'',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Registra_REGISTER result[$result]\n");
    return $result;
}

sub RV_Registra_REGISTERwithAuthorization {
    my($rule,$addrule,$conn,$timeout,$link,$noauth)=@_;
    if($rule eq ''){ $rule='D.REGISTER.AutoResponse'; }
    if( $timeout eq ''){ $timeout=$SIP_TimeOut; }

    my(@frames,$result);
    @frames=();

    # 
    $frames[0]{'Recv'}=$CNT_RG_FRAME;
    $frames[0]{'RecvMode'}='stop';
    $frames[0]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.method',@_) eq 'REGISTER') && FFIsExistHeader('Authorization',@_)},@_)};
    $frames[0]{'Connection'}= $conn;

    # 
    $frames[1]{'Recv'}=$CNT_RG_FRAME;
    $frames[1]{'RecvMode'}='';
    $frames[1]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.method',@_) eq 'REGISTER') && !FFIsExistHeader('Authorization',@_)},@_)};
    if($noauth eq 'noauth'){
	$frames[1]{'RecvAction'}=\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-401-RETURN-NOQOP.RG','SIP4fromREG',@_)};
    }else{
	$frames[1]{'RecvAction'}=\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-401-RETURN.RG','SIP4fromREG',@_)};
    }
    $frames[1]{'Connection'}= $conn;

    # REGISTER
    $result=RecvAndEvalDecodeRuleExt($rule,\@frames,$addrule,$timeout,$link,'',$SIP_DNS_ANSWER_MODE);

    MsgPrint('INF',"RV_Registra_REGISTERwithAuthorization result[$result]\n");
    return $result;
}

sub RV_Registra_REGISTERwithExpire0 {
    my($rule,$addrule,$conn,$timeout,$link)=@_;
    my($result);
    if($rule eq ''){ $rule='D.REGISTER.AutoResponse'; }

    # Expire
    $result = RecvAndEvalDecodeRule($rule,$CNT_RG_FRAME,
	 \q{(FV('RQ.Request-Line.method',@_) eq 'REGISTER') && (FV('HD.Expires.val.seconds',@_) eq 0)},
	 '',$addrule,$conn,$timeout,$link,'',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Registra_REGISTERwithExpire0 result[$result]\n");
    return $result;
}

sub SQ_Registra_SIP {
    my($recvFrame,$count,$conn,$timeout,$link)=@_;
    my(@param,$result);
    @param=({'SeqMode'=>'recv', 'RecvFrame'=>$CNT_RG_FRAME, 'RecvMatching'=>$recvFrame,'Connection'=>$conn});
    $result=RecvAndSendMultiUnit(\@param,$count,$timeout,'',$link,'',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"SQ_Registra_SIP result[$result]\n");
    return $result;
}

# REGISTER
sub SQ_Registra_Complete {
    my($conn,$timeout,$link,$autoDNS)=@_;
    if( $link eq '')        { $link=$SIP_Link; }
    if( $timeout eq '')     { $timeout=$SIP_TimeOut; }
    
    my($startIndex,$matchframe,$ret,@frames,@unknown,$size);

    $matchframe=['RQ.Request-Line.method','REGISTER'];
    @frames=();
    
    # 
    $startIndex=$#SIPPktInfo+1;

    $size=0;
    # REGISTER
    $frames[$size]{'RecvMode'}='stop';
    $frames[$size]{'Recv'}= $CNT_RG_FRAME;
    $frames[$size]{'RecvMatch'}= \'MatchSIPRequest(REGISTER,@_)'; # SIPtoREG
    $frames[$size]{'RecvAction'}= \q{RecActEvalRuleAndResponse('D.REGISTER.AutoResponse','E.STATUS-200-RETURN.RG',SIP4fromREG,@_)};
    $frames[$size]{'Connection'}=$conn;
    # DNA
    if($autoDNS){
	$size++;
        $frames[$size]{'Recv'}='SIP4toDNS';
        $frames[$size]{'RecvMode'}='';
        $frames[$size]{'RecvMatch'}='';
        $frames[$size]{'RecvAction'}=\sprintf('RecActDNSAnswer(%s,@_)',$autoDNS);
    }
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,\@SIP_AutoResponse,$link);

    # Wait
    if($#SIPPktInfo<$startIndex){return '';}
    $ret=FVibc('recv','',$startIndex,@$matchframe);

    return $ret;
}

#=================================
# 
#=================================
sub SQ_DNS {
    my($autoDNS,$link)=@_;
    if( $autoDNS eq ''){ $autoDNS='AAAA1'; }
    if( $link eq ''){ $link=$SIP_Link; }
    my(@frames,$result);
    
    # 
    $frames[0]{'Recv'}='SIP4toDNS';
    $frames[0]{'RecvMode'}='';
    $frames[0]{'RecvMatch'}='';
    $frames[0]{'RecvAction'}=\sprintf('RecActDNSAnswer(%s,@_)',$autoDNS);

    $result=RecvAndEvalDecodeRuleExt('',\@frames,'',10,$link,'autoRegist');
    MsgPrint('INF',"SQ_DNS result[$result]\n");
    return $result;
}

#=================================
# 
#=================================
sub SD_Proxy_INVITE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.INVITE-TWOPX.PX1'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Proxy_INVITE result[$result]\n");
    return $result;
}

sub SD_Proxy_INVITE_HOLD {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.INVITE-TWOPX.PX1.HOLD'; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Proxy_INVITE_HOLD result[$result]\n");
    return $result;
}

sub SD_Proxy_ACK {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.ACK-TWOPX.PX1'; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Proxy_ACK result[$result]\n");
    return $result;
}

sub SD_Proxy_ACK_NO200 {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.ACK-TWOPX-no2xx.PX1'; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Proxy_ACK result[$result]\n");
    return $result;
}

sub SD_Proxy_BYE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.BYE-TWOPX.PX1'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Proxy_BYE result[$result]\n");
    return $result;
}

sub SD_Proxy_CANCEL {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.CANCEL-TWOPX.PX1'; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Proxy_CANCEL result[$result]\n");
    return $result;
}

sub SD_Proxy_OPTIONS {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.OPTIONS-TWOPX.PX1'; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Proxy_OPTIONS result[$result]\n");
    return $result;
}

sub SD_Proxy_STATUS {
    my($code,$request,$rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}

    # 
    if(!$rule){
	if($code eq 100){
	    $rule='E.STATUS-100-RETURN.PX1';
	}
	if($code eq 180){
	    if($request eq 'NO-RECORD-ROUTE-INVITE'){
		$rule='E.STATUS-180-RETURN-TWOPX.PX1.NO-RECORD-ROUTE';
	    }
	    elsif($request eq 'ONE-RECORD-ROUTE-INVITE'){
		$rule='E.STATUS-180-RETURN-ONEPX.PX1';
	    }
	    elsif($request eq 'INVITE-REDIRECT'){
		$rule='E.STATUS-180-RETURN-TWOPX-REDIRECT.PX1';
	    }
	    else{
		$rule='E.STATUS-180-RETURN-TWOPX.PX1';
	    }
	}
	if($code eq 183){
	    if($request eq 'INVITE'){
            #If SDP is exist,send answer.Else send offer.
		if(FV('BD.txt','','INVITE') eq ""){
		    $rule='E.STATUS-183-RETURN-TWOPX-SDP.PX1';
		}else{
		    $rule='E.STATUS-183-RETURN-TWOPX-SDP-ANS.PX1';
		}
	    }elsif($request eq 'INVITE-INDIALOG'){    ###add by cho
		    $rule='E.STATUS-183-RETURN-TWOPX.PX1';
	    }
	}
	if($code eq 200){
	    if($request eq 'BYE'){
		$rule='E.STATUS-200-RETURN-TWOPX.PX1';
	    }
	    elsif($request eq 'ONE-RECORD-ROUTE-INVITE'){
            #If SDP is exist,send answer.Else send offer.
		if(FV('BD.txt','','INVITE') eq ""){
		    $rule='E.STATUS-200-RETURN-ONEPX-SDP.PX1';
		}else{
		    $rule='E.STATUS-200-RETURN-ONEPX-SDP-ANS.PX1';
		}
	    }
	    elsif($request eq 'INVITE'){
            #If SDP is exist,send answer.Else send offer.
		if(FV('BD.txt','','INVITE') eq ""){
		    $rule='E.STATUS-200-RETURN-TWOPX-SDP.PX1';
		}else{
		    $rule='E.STATUS-200-RETURN-TWOPX-SDP-ANS.PX1';
		}
	    }
	    elsif($request eq 'INVITE-REDIRECT'){
            #If SDP is exist,send answer.Else send offer.
		if(FV('BD.txt','','INVITE') eq ""){
		    $rule='E.STATUS-200-RETURN-TWOPX-SDP-REDIRECT.PX1';
		}else{
		    $rule='E.STATUS-200-RETURN-TWOPX-SDP-ANS-REDIRECT.PX1';
		}
	    }
	    elsif($request eq 'CANCEL'){
		$rule='E.STATUS-200-RETURN-TWOPX.PX1.CANCEL';
	    }
	    elsif($request eq 'NO-RECORD-ROUTE-INVITE'){
		if(FV('BD.txt','','INVITE') eq ""){
		    $rule='E.STATUS-200-RETURN-TWOPX-SDP.PX1-NO-RECORD-ROUTE';
		}else{
		    $rule='E.STATUS-200-RETURN-TWOPX-SDP-ANS.PX1-NO-RECORD-ROUTE';
		}
	    }
	    elsif($request eq 'PRACK'){		### add by cho
		$rule='E.STATUS-200-PRACK-RETURN-TWOPX.PX1';
	    }
	    elsif($request eq 'PRACK-INVITE'){   ### add by cho
		$rule='E.INVITE-RETURN-PRACK-TWOPX.PX1';
	    }
	}
 	if($code eq 301){
 	    $rule='E.STATUS-301-RETURN.PX1';
 	}
	if($code eq 302){
	    $rule='E.STATUS-302-RETURN.PX1';
	}
 	if($code eq 404){
 	    $rule='E.STATUS-404-RETURN.PX1';
 	}
	if($code eq 407){
	    if($request eq 'INVITE-AUTH'){
		$rule='E.STATUS-407-RETURN-AUTH.PX1';
	    }
	    else{
		$rule='E.STATUS-407-RETURN.PX1';
	    }
	}
	if($code eq 480){
	    $rule='E.STATUS-480-RETURN.PX1';
	}
	if($code eq 481){
	    $rule='E.STATUS-481-RETURN.PX1';
	}
	if($code eq 486){
	    $rule='E.STATUS-486-RETURN.PX1';
	}
	if($code eq 487){
 	    $rule='E.STATUS-487-RETURN.PX1';
 	}
 	if($code eq 488){
 	    $rule='E.STATUS-488-RETURN.PX1';
	}
 	if($code eq 491){
 	    $rule='E.STATUS-491-RETURN.PX1';
	}
 	if($code eq 500){
 	    $rule='E.STATUS-500-RETURN.PX1';
	}
 	if($code eq 503){
 	    $rule='E.STATUS-503-RETURN.PX1';
	}
    }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Proxy_STATUS result[$result]\n");
    return $result;
}

sub SD_Proxy_ReTRANSMIT {
    my($msg,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $link eq ''){ $link=$SIP_Link; }

    # 
    if(!$msg && !($msg=FVib('send','','','SIP','FRAME',$frame))){
	MsgPrint('ERR',"Can't find re-transmit message.\n");
	return 'ERR';
    }
    # 
    $result = SD_SIP($msg,$frame,'',$conn,$link);
    MsgPrint('INF',"SD_Proxy_ReTRANSMIT result[$result]\n");
    return $result;
}

# sub SD_Proxy_EchoRequest {
#     my($rule,$pktinfo,$addrule,$delrule,$link)=@_;
#     if( $#_ < 1 ){ $pktinfo=$SIPPktInfoLast; }
#     if( $#_ < 0 ){ $rule='E.INVITE.PX'; }
#     return $ret;
# }
sub SD_Proxy_MSG {
    my($header,$body,$addrule,$pktinfo,$conn,$link,$frame)=@_;
    my($rule,$result);
    if( $frame eq '' ){ $frame='SIP4fromPROXY'; }
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){if($pktinfo){$conn=$pktinfo->{'pkt'}->{'Connection'};}}

    # \n
    if($header =~ /\n/ && $header !~ /\r/){
	$header =~ s/\n/\r\n/g;
    }
    $header =~ s/[\r\n]*$//;
    if($body){
	if($body =~ /\n/ && $body !~ /\r/){
	    $body =~ s/\n/\r\n/g;
	}
	$body =~ s/[\r\n]*$//;
    }

    # 
    if($body){
	$rule =
	{'TY:'=>'RULESET', 'ID:'=>'E.TORTURE.tmp', 'MD:'=>SEQ, 
	 'RR:'=>[{'TY:'=>'ENCODE','ID:'=>'E.TORTURE.hd','PT:'=>HD, 'FM:'=>$header},
		 {'TY:'=>'ENCODE','ID:'=>'E.TORTURE.bd','PT:'=>BD, 'FM:'=>$body}],
	 'AD:'=>$addrule, 'EX:'=>\&MargeSipMsg};
    }
    else{
	$rule =
	{'TY:'=>'RULESET', 'ID:'=>'E.TORTURE.tmp', 'MD:'=>SEQ, 
	 'RR:'=>[{'TY:'=>'ENCODE','ID:'=>'E.TORTURE.hd','PT:'=>HD, 'FM:'=>$header},],
	 'AD:'=>$addrule, 'EX:'=>\&MargeSipMsg};
    }
    RegistRuleSet($rule);
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,$frame,'','',$conn,$link);
    MsgPrint('INF',"SD_Proxy_MSG result[$result]\n");
    return $result;
}

sub SD_Proxy_UnReachable {
    my($pktinfo,$link)=@_;
    my($msg);
    if($pktinfo eq ''){$pktinfo=$SIPPktInfoLast;}

    if(!$pktinfo || !($msg=$pktinfo->{'frame_txt'})){
	MsgPrint('ERR',"ICMP UnReachable playload dose not exist.");
	return '';
    }
    return SD_SIP_ICMP_ERROR($msg,$pktinfo,1,'ICMP4ErrorFromPROXY',$link);
}

sub SD_Proxy_TimeExceed {
    my($pktinfo,$link)=@_;
    my($msg);
    if($pktinfo eq ''){$pktinfo=$SIPPktInfoLast;}

    if(!$pktinfo || !($msg=$pktinfo->{'frame_txt'})){
	MsgPrint('ERR',"ICMP TimeExceed playload dose not exist.");
	return '';
    }
    return SD_SIP_ICMP_ERROR($msg,$pktinfo,3,'ICMP4ErrorFromPROXY',$link);
}


#=================================
# 
#=================================
sub RV_Proxy_REGISTER {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }
    if( $rule eq '' ){ $rule='D.REGISTER.AutoResponse'; }
    $result = RecvAndEvalDecodeRule($rule,$frame,REGISTER,'',$addrule,$conn,$timeout,$link,'',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_REGISTER result[$result]\n");
    return $result;
}

#=================================
# 
#=================================
sub RV_Proxy_INVITE {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }
    $result = RecvAndEvalDecodeRule($rule,$frame,INVITE,'',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_INVITE result[$result]\n");
    return $result;
}

sub RV_Proxy_INVITEwithAuthorization {
    my($rule,$addrule,$conn,$timeout,$link,$frame,$mode)=@_;
    my($result);
    if( $timeout eq ''){ $timeout=$SIP_TimeOut; }
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }

    my(@frames,$result);
    @frames=();

    # 
    $frames[0]{'Recv'}=$frame;
    $frames[0]{'RecvMode'}='stop';
    $frames[0]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.method',@_) eq 'INVITE') && FFIsExistHeader('Proxy-Authorization',@_)},@_)};
    $frames[0]{'Connection'}=$conn;

    # 
    $frames[1]{'Recv'}=$frame;
    $frames[1]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.method',@_) eq 'INVITE') && !FFIsExistHeader('Proxy-Authorization',@_)},@_)};
    if($mode eq 'noauth'){
	$frames[1]{'RecvAction'}=\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-407-RETURN-NOQOP.PX1','SIP4fromPROXY',@_)};
    }else{
	$frames[1]{'RecvAction'}=\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-407-RETURN.PX1','SIP4fromPROXY',@_)};
    }

    $result=RecvAndEvalDecodeRuleExt($rule,\@frames,$addrule,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_INVITEwithAuthorization result[$result]\n");
    return $result;
}

sub RV_Proxy_INVITEwithAuthorization2 {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }
    $result =RecvAndEvalDecodeRule($rule,$frame,
	 \q{(FV('RQ.Request-Line.method',@_) eq 'INVITE') && (FFIsExistHeader('Proxy-Authorization',@_) eq 2)},
	 '',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_INVITEwithAuthorization2 result[$result]\n");
    return $result;
}

# 
sub RV_Proxy_INVITEwithAuthorizationRedirectEtc {
    my($rule,$addrule,$timeout,$link,$frame,$mode)=@_;
    my($result);
    if( $timeout eq ''){ $timeout=$SIP_TimeOut; }
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }

    my(@frames,$result);
    @frames=();

    # 
    $frames[0]{'Recv'}=$frame;
    $frames[0]{'RecvMode'}='stop';
    $frames[0]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.method',@_) eq 'INVITE') && FFIsExistHeader('Proxy-Authorization',@_) && (FV('RQ.Request-Line.uri.txt',@_) eq $CVA_PUA_URI_REDIRECT)},@_) };
    $frames[0]{'RecvAction'}='';

    # 
    $frames[1]{'Recv'}=$frame;
    $frames[1]{'RecvMode'}='';
    $frames[1]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.method',@_) eq 'INVITE') && FFIsExistHeader('Proxy-Authorization',@_) && (FV('RQ.Request-Line.uri.txt',@_) ne $CVA_PUA_URI_REDIRECT)},@_) };
    $frames[1]{'RecvAction'}=\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-302-RETURN.PX1','SIP4fromPROXY',@_)};

    # 
    # 
    $frames[2]{'Recv'}=$frame;
    $frames[2]{'RecvMode'}=(($CVA_AUTH_SUPPORT_AFTER_DIALOG eq 'T')?'':'stop');
    $frames[2]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.method',@_) eq 'INVITE') && !FFIsExistHeader('Proxy-Authorization',@_) && (FV('RQ.Request-Line.uri.txt',@_) eq $CVA_PUA_URI_REDIRECT)},@_) };
    if($mode eq 'noauth'){
	$frames[2]{'RecvAction'}=(($CVA_AUTH_SUPPORT_AFTER_DIALOG eq 'T')?\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-407-RETURN-NOQOP.PX1','SIP4fromPROXY',@_)}:'');
    }else{
	$frames[2]{'RecvAction'}=(($CVA_AUTH_SUPPORT_AFTER_DIALOG eq 'T')?\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-407-RETURN.PX1','SIP4fromPROXY',@_)}:'');
    }

    $result=RecvAndEvalDecodeRuleExt($rule,\@frames,$addrule,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_INVITEwithAuthorizationRedirect result[$result]\n");
    return $result;
}

sub RV_Proxy_INVITEwithRedirect {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $timeout eq ''){ $timeout=$SIP_TimeOut; }
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }

    my(@frames,$result);
    @frames=();

    # 
    $frames[0]{'Recv'}=$frame;
    $frames[0]{'RecvMode'}='stop';
    $frames[0]{'RecvMatch'}=\q{MatchSIPRequest(\q{FV('RQ.Request-Line.uri.txt',@_) =~ /$CVA_PUA_URI_REDIRECT/},@_) };
    $frames[0]{'Connection'}=$conn;

    # 
    $frames[1]{'Recv'}=$frame;
    $frames[1]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.uri.txt',@_) !~ /$CVA_PUA_URI_REDIRECT/},@_) };
    $frames[1]{'RecvAction'}=\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-302-RETURN.PX1','SIP4fromPROXY',@_)};

    $result=RecvAndEvalDecodeRuleExt($rule,\@frames,$addrule,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_INVITEwithAuthorizationRedirect result[$result]\n");
    return $result;
}

sub RV_Proxy_INVITEwithRedirect2 {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $timeout eq ''){ $timeout=$SIP_TimeOut; }
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }

    my(@frames,$result);
    @frames=();

    # 
    $frames[0]{'Recv'}=$frame;
    $frames[0]{'RecvMode'}='stop';
    $frames[0]{'RecvMatch'}=\q{MatchSIPRequest(\q{FV('RQ.Request-Line.uri.txt',@_) =~ /$CVA_PUA_URI_REDIRECT2/},@_) };
    $frames[0]{'Connection'}=$conn;

    # 
    $frames[1]{'Recv'}=$frame;
    $frames[1]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.uri.txt',@_) !~ /$CVA_PUA_URI_REDIRECT2/},@_) };
    $frames[1]{'RecvAction'}=\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-302-RETURN.PX1','SIP4fromPROXY',@_)};

    $result=RecvAndEvalDecodeRuleExt($rule,\@frames,$addrule,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_INVITEwithAuthorizationRedirect2 result[$result]\n");
    return $result;
}

sub RV_Proxy_INVITE_OtherResponseUnreachable {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $timeout eq ''){ $timeout=$SIP_TimeOut; }
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }

    my(@frames,$result);
    @frames=();

    # Proxy
    $frames[0]{'Recv'}=$frame;
    $frames[0]{'RecvMode'}='stop';
    $frames[0]{'RecvMatch'}=\q{MatchSIPRequest('INVITE',@_)};
    $frames[0]{'Connection'}=$conn;

    # Other1
    $frames[1]{'Recv'}='SIP4toOTHER1';
    $frames[1]{'RecvMatch'}=\q{MatchSIPRequest(['INVITE','CANCEL'],@_)};
    $frames[1]{'RecvAction'}=\q{RecActUnreachable('ICMP4ErrorFromOTHER1',@_)};

    # Other1
    $frames[2]{'Recv'}='SIP4toOTHER1';
    $frames[2]{'RecvMatch'}=\q{MatchSIPRequest('REGISTER',@_)};
    $frames[2]{'RecvAction'}=\q{RecActEvalRuleAndResponse('D.REGISTER.AutoResponse','E.STATUS-200-RETURN.RG',SIP4fromREG,@_)};

    $result=RecvAndEvalDecodeRuleExt($rule,\@frames,$addrule,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_INVITE_OtherResponseUnreachable result[$result]\n");
    return $result;
}

sub RV_Proxy_ACK {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }
    $result = RecvAndEvalDecodeRule($rule,$frame,ACK,'',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_ACK result[$result]\n");
    return $result;
}

# Proxy-Authorization
sub RV_Proxy_BYEwithAuthorization {
    my($rule,$addrule,$conn,$timeout,$link,$frame,$mode)=@_;
    my($result);
    if( $timeout eq ''){ $timeout=$SIP_TimeOut; }
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }

    my(@frames,$result);
    @frames=();

    # 
    $frames[0]{'Recv'}=$frame;
    $frames[0]{'RecvMode'}='stop';
    $frames[0]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.method',@_) eq 'BYE') && FFIsExistHeader('Proxy-Authorization',@_)},@_)};
    $frames[0]{'Connection'}=$conn;

    # 
    # $AUTH_SUPPORT_AFTER_DIALOG
    $frames[1]{'Recv'}=$frame;
    # $frames[1]{'RecvMode'}=(($CNT_CONF{'AUTH-SUPPORT'} ne 'T')?'':'stop');
    $frames[1]{'RecvMode'}=(($CVA_AUTH_SUPPORT_AFTER_DIALOG eq 'T')?'':'stop');
    $frames[1]{'RecvMatch'}=\q{MatchSIPRequest(\q{(FV('RQ.Request-Line.method',@_) eq 'BYE') && !FFIsExistHeader('Proxy-Authorization',@_)},@_)};
    if($mode eq 'noauth'){
	$frames[1]{'RecvAction'}=(($CVA_AUTH_SUPPORT_AFTER_DIALOG eq 'T')?\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-407-RETURN-NOQOP.PX1','SIP4fromPROXY',@_)}:'');
    }else{
	# $frames[1]{'RecvAction'}=(($CNT_CONF{'AUTH-SUPPORT'} ne 'T')?\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-407-RETURN.PX1','SIP4fromPROXY',@_)}:'');
	$frames[1]{'RecvAction'}=(($CVA_AUTH_SUPPORT_AFTER_DIALOG eq 'T')?\q{RecActEvalRuleAndResponse('D.CSEQ','E.STATUS-407-RETURN.PX1','SIP4fromPROXY',@_)}:'');
    }

    $result=RecvAndEvalDecodeRuleExt($rule,\@frames,$addrule,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_BYE result[$result]\n");
    return $result;
}

# 
sub RV_Proxy_BYE {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }
    $result = RecvAndEvalDecodeRule($rule,$frame,BYE,'',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_BYE result[$result]\n");
    return $result;
}

sub RV_Proxy_CANCEL {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }
    $result = RecvAndEvalDecodeRule($rule,$frame,CANCEL,'',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_CANCEL result[$result]\n");
    return $result;
}

sub RV_Proxy_STATUS {
    my($recvCode,$correspondMsg,$rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($exp,$result);
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }
    if( $rule eq '' ){ $rule='D.STATUS.PX'; }
    if($SIP_PL_TRNS ne 'UDP' && !$conn){$conn=CNN();}
    if(ref($recvCode) eq 'ARRAY'){
	$exp=\sprintf(q{RecActGeneralStatus(['%s'],'%s',@_)},join(q{','},@$recvCode),$correspondMsg);
    }
    else{
	$exp=\sprintf(q{RecActGeneralStatus('%s','%s',@_)},$recvCode,$correspondMsg);
    }
    $result = RecvAndEvalDecodeRule($rule,$frame,STATUS,$exp,$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Proxy_STATUS result[$result]\n");
    return $result;
}

# sub RV_Proxy_EchoReply {
#     my($rule,$addrule,$timeout,$link)=@_;
#     if( $#_ < 0 ){ $rule='D.STATUS.PX'; }
#     my($msg,$result,$ret);
#     return $ret;
# }

# 
#   
sub SQ_Proxy_SIP {
    my($recvFrame,$count,$timeout,$status,$conn,$link,$frame)=@_;
    my(@param,$result,$i);

    if( $frame eq '' ){ $frame='SIP4toPROXY'; }
    if(ref($recvFrame) eq 'ARRAY'){
	for($i=0;$i<=$#$recvFrame;$i++){
	    $param[$i]{'SeqMode'}='recv';
	    $param[$i]{'RecvFrame'}=$frame;
	    $param[$i]{'RecvMatching'}=$recvFrame->[$i];
	    $param[$i]{'RecvMsgType'}=$status?'STATUS':'REQUEST';
	    $param[$i]{'Connection'}=$conn;
	}
    }
    else{
	@param=({'SeqMode'=>'recv', 'RecvFrame'=>$frame, 'RecvMatching'=>$recvFrame,
		 'RecvMsgType'=>$status?'STATUS':'REQUEST','Connection'=>$conn});
    }
    $result = RecvAndSendMultiUnit(\@param,$count,$timeout,'',$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"SQ_Proxy_SIP result[$result]\n");
    return $result;
}
# 
sub SQ_Proxy_WAIT {
    my($timeout,$matchFrame,$breakCode,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toPROXY'; }
    if($matchFrame eq ''){
	$matchFrame=['RQ.Status-Line.code',\q{$val =~ /^1/}];
    }
    if($breakCode eq ''){
	$breakCode=\q{$code =~ /^[2-6]/};
    }
    return RecvAndWait($matchFrame,$frame,$breakCode,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
}

#=================================
# 
#=================================
sub SD_Term_INVITE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.INVITE-NOPX.TM'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromTERM,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Term_INVITE result[$result]\n");
    return $result;
}

sub SD_Term_INVITE_HOLD {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.INVITE-NOPX.TM.HOLD'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromTERM,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Term_INVITE_HOLD result[$result]\n");
    return $result;
}

sub SD_Term_ACK {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.ACK-NOPX.TM'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromTERM,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Term_ACK result[$result]\n");
    return $result;
}

sub SD_Term_BYE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $#_ < 1 ){ $pktinfo=$SIPPktInfoLast; }
    if( $#_ < 0 ){ $rule='E.BYE.TM'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromTERM,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Term_BYE result[$result]\n");
    return $result;
}

sub SD_Term_CANCEL {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.CANCEL-NOPX.TM'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromTERM,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Term_CANCEL result[$result]\n");
    return $result;
}
sub SD_Term_OPTIONS {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }
    if( $rule eq '' ){ $rule='E.OPTIONS-NOPX.TM'; }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromTERM,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Term_OPTIONS result[$result]\n");
    return $result;
}

sub SD_Term_STATUS {
    my($code,$request,$rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
    my($result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }

    # 
    if(!$rule){
	if($code eq 180){
	    $rule='E.STATUS-180-RETURN-NOPX.TM';
	}elsif($code eq 200){
	    if($request eq 'INVITE'){
		if(FV('BD.txt','','INVITE') eq ""){
		    $rule='E.STATUS-200-RETURN-NOPX-SDP.TM';
		}else{
		    $rule='E.STATUS-200-RETURN-NOPX-SDP-ANS.TM';
		}
	    }elsif($request eq 'CANCEL'){
		$rule='E.STATUS-200-RETURN-TWOPX.PX1.CANCEL';
	    }
 	}
 	elsif($code eq 305){
 	    $rule='E.STATUS-305-RETURN.TM';
	}
	elsif($code eq 486){
	    $rule='E.STATUS-486-RETURN.TM';
	}
	elsif($code eq 487){
	    $rule='E.STATUS-487-RETURN';
	}
    }
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromTERM,$addrule,$delrule,$conn,$link);
    MsgPrint('INF',"SD_Term_STATUS result[$result]\n");
    return $result;
}
sub SD_Term_ReTRANSMIT {
    my($msg,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromTERM'; }
    if( $link eq ''){ $link=$SIP_Link; }

    # 
    if(!$msg && !($msg=FVib('send','','','SIP','FRAME',$frame))){
	MsgPrint('ERR',"Can't find re-transmit message.\n");
	return 'ERR';
    }
    # 
    $result = SD_SIP($msg,$frame,'',$conn,$link);
    MsgPrint('INF',"SD_Term_ReTRANSMIT result[$result]\n");
    return $result;
}
sub SD_Term_MSG {
    my($header,$body,$addrule,$pktinfo,$conn,$link)=@_;
    my($rule,$result);
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }

    # \n
    if($header =~ /\n/ && $header !~ /\r/){
	$header =~ s/\n/\r\n/g;
    }
    $header =~ s/[\r\n]*$//;
    if($body){
	if($body =~ /\n/ && $body !~ /\r/){
	    $body =~ s/\n/\r\n/g;
	}
	$body =~ s/[\r\n]*$//;
    }

    # 
    if($body){
	$rule =
	{'TY:'=>'RULESET', 'ID:'=>'E.TORTURE.tmp', 'MD:'=>SEQ, 
	 'RR:'=>[{'TY:'=>'ENCODE','ID:'=>'E.TORTURE.hd','PT:'=>HD, 'FM:'=>$header},
		 {'TY:'=>'ENCODE','ID:'=>'E.TORTURE.bd','PT:'=>BD, 'FM:'=>$body}],
	 'AD:'=>$addrule, 'EX:'=>\&MargeSipMsg};
    }
    else{
	$rule =
	{'TY:'=>'RULESET', 'ID:'=>'E.TORTURE.tmp', 'MD:'=>SEQ, 
	 'RR:'=>[{'TY:'=>'ENCODE','ID:'=>'E.TORTURE.hd','PT:'=>HD, 'FM:'=>$header},],
	 'AD:'=>$addrule, 'EX:'=>\&MargeSipMsg};
    }
    RegistRuleSet($rule);
    $result = EvalEncodeRuleAndSend($rule,$pktinfo,SIP4fromTERM,'','',$conn,$link);
    MsgPrint('INF',"SD_Term_MSG result[$result]\n");
    return $result;
}

#=================================
# 
#=================================
sub RV_Term_INVITE {
    my($rule,$addrule,$conn,$timeout,$link)=@_;
    my($result);
    $result = RecvAndEvalDecodeRule($rule,SIP4toTERM,INVITE,'',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Term_INVITE result[$result]\n");
    return $result;
}

sub RV_Term_INVITEwithAuthorization {
    my($rule,$addrule,$conn,$timeout,$link)=@_;
    my($result);
    $result = RecvAndEvalDecodeRule($rule,SIP4toTERM,
	 \q{(FV('RQ.Request-Line.method',@_) eq 'INVITE') && FFIsExistHeader('Proxy-Authorization',@_)},
	 '',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Term_INVITEwithAuthorization result[$result]\n");
    return $result;
}

sub RV_Term_ACK {
    my($rule,$addrule,$conn,$timeout,$link)=@_;
    my($result);
    $result = RecvAndEvalDecodeRule($rule,SIP4toTERM,ACK,'',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Term_ACK result[$result]\n");
    return $result;
}

sub RV_Term_BYE {
    my($rule,$addrule,$conn,$timeout,$link)=@_;
    my($result);
    $result = RecvAndEvalDecodeRule($rule,SIP4toTERM,BYE,'',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Term_BYE result[$result]\n");
    return $result;
}

sub RV_Term_CANCEL {
    my($rule,$addrule,$conn,$timeout,$link)=@_;
    my($result);
    if( $#_ < 0 ){ $rule='D.CANCEL.TM'; }
    $result = RecvAndEvalDecodeRule($rule,SIP4toTERM,CANCEL,'',$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Term_CANCEL result[$result]\n");
    return $result;
}
# 
#  
sub RV_Term_STATUS {
    my($recvCode,$correspondMsg,$rule,$addrule,$conn,$timeout,$link)=@_;
    my($exp,$result);
    if( $rule eq '' ){ $rule='D.STATUS.TM'; }

    # 
    if(ref($recvCode) eq 'ARRAY'){
	$exp=\sprintf(q{RecActGeneralStatus(['%s'],'%s',@_)},join(q{','},@$recvCode),$correspondMsg);
    }
    else{
	$exp=\sprintf(q{RecActGeneralStatus('%s','%s',@_)},$recvCode,$correspondMsg);
    }
    $result = RecvAndEvalDecodeRule($rule,SIP4toTERM,STATUS,$exp,$addrule,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Term_STATUS result[$result]\n");
    return $result;
}
# 
sub SQ_Term_SIP {
    my($recvFrame,$count,$conn,$timeout,$status,$link)=@_;
    my(@param,$result,$i);
    if(ref($recvFrame) eq 'ARRAY'){
	for($i=0;$i<=$#$recvFrame;$i++){
	    $param[$i]{'SeqMode'}='recv';
	    $param[$i]{'RecvFrame'}='SIP4toTERM';
	    $param[$i]{'RecvMatching'}=$recvFrame->[$i];
	    $param[$i]{'RecvMsgType'}=$status?'STATUS':'REQUEST';
	    $param[$i]{'Connection'}=$conn;
	}
    }
    else{
	@param=({'SeqMode'=>'recv', 'RecvFrame'=>'SIP4toTERM', 'RecvMatching'=>$recvFrame,
		 'RecvMsgType'=>$status?'STATUS':'REQUEST','Connection'=>$conn});
    }
    $result=RecvAndSendMultiUnit(\@param,$count,$timeout,'',$link, 'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"SQ_Term_SIP result[$result]\n");
    return $result;
}
# 
#   
#     @SQ_Param=({'SeqMode'=>'recv','RecvFrame'=>'SIP4toTERM','RecvMsgType'=>'STATUS','RecvMatching'=>200},
#                {'SeqMode'=>'recv','RecvFrame'=>'SIP4toTERM','RecvMsgType'=>'STATUS','RecvMatching'=>487,
#                 'SendFrame'=>SIP4fromTERM, 'EncodeRule'=>'E.ACK-NOPX.TM'});
#     SQ_Term_SIPext(\@SQ_Param,2,10);
sub SQ_Term_SIPext {
    my($param,$count,$timeout,$link)=@_;
    my($result);
    $result=RecvAndSendMultiUnit($param,$count,$timeout,'',$link, 'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"SQ_Term_SIP result[$result]\n");
    return $result;
}

# 
#   
sub SQ_Term_WAIT {
    my($conn,$timeout,$matchFrame,$breakCode,$link)=@_;
    if($matchFrame eq ''){
	$matchFrame=['RQ.Status-Line.code',\q{$val =~ /^1/}];
    }
    if($breakCode eq ''){
	$breakCode=\q{$code =~ /^[2-6]/};
    }
    elsif($breakCode eq 'no'){$breakCode='';}
    return RecvAndWait($matchFrame,SIP4toTERM,$breakCode,$conn,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
}

#=================================
# ICMP
#=================================
# Echo request
#   
sub SQ_Proxy_Echo {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$nonAutoRegist,$autoResponse,$link) = @_;
    if( !$link ){ $link=$SIP_Link; }
    if( !$timeout ){ $timeout=6; }
    if( !$recvFrame ){ $recvFrame='EchoReply4ToServ'; }
    if( !$sendFrame ){ $sendFrame='EchoRequest4FromServ'; }
    
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
    $frames[1]{'Recv'}='SIP4toDNS';
    $frames[1]{'RecvMode'}='';
    $frames[1]{'RecvModf'}='';
    $frames[1]{'RecvMatch'}='';
    $frames[1]{'RecvAction'}=\'RecActDNSAnswer($SIP_DNS_ANSWER_MODE,@_)';

    if(!$nonAutoRegist){
       $frames[2]{'Recv'}= $CNT_RG_FRAME;
       $frames[2]{'RecvMatch'}= \'MatchSIPRequest(REGISTER,@_)'; # SIPtoREG
       $frames[2]{'RecvAction'}= \q{RecActEvalRuleAndResponse('D.REGISTER.AutoResponse','E.STATUS-200-RETURN.RG',SIP4fromREG,@_)};
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
    MsgPrint('INF',"SQ_Proxy_Echo4 [$ret]\n");
    return($ret);
}

#============================================
# SIP ICMP error
#============================================
# SIP_Send
#   TYPE:1(unreachable) Code:0  /  TYPE:3(time exceed) Code:0
sub SD_SIP_ICMP_ERROR {
    my ($sipmsg,$pktinfo,$errType,$sendFrame,$link) = @_;
    if( $link eq '' )     { $link=$SIP_Link; }
    if( $sendFrame eq '' ){ $sendFrame='DestinationUnreachableFromPROXY'; }

    my ($ret,@frames,@unknown,$cpp,%pkt1,$checksum);
    @frames=();

    # 
    $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.HeaderChecksum'} =~ /([0-9]+)\scalc/;
    $checksum=$1;
    $cpp=sprintf(" -DSIP4_RECVED_IHL=%s -DSIP4_RECVED_TYPEOFSERVICE=%s " .
		 "-DSIP4_RECVED_IDENTIFIER=%s -DSIP4_RECVED_DF=%s -DSIP4_RECVED_MF=%s " .
		 "-DSIP4_RECVED_FRAGMENTOFFSET=%s -DSIP4_RECVED_TTL=%s " .
		 "-DSIP4_RECVED_PROTOCOL=%s -DSIP4_RECVED_HEADERCHECKSUM=%s " .
		 "-DSIP4_RECVED_SRC_ADDR=v4\\\(\\\"%s\\\"\\\) -DSIP4_RECVED_DST_ADDR=v4\\\(\\\"%s\\\"\\\) " .
		 "-DSIP4_RECVED_SRC_PORT=%s -DSIP4_RECVED_DST_PORT=%s " .
		 "-DICMP_ERROR_TYPE=%s -DICMP_ERROR_CODE=%s ",
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.IHL'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.TypeOfService'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.Identifier'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.DF'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.MF'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.FragmentOffset'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.TTL'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.Protocol'},
		 $checksum,
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.SourceAddress'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.DestinationAddress'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Upp_UDP.Hdr_UDP.SourcePort'},
		 $pktinfo->{pkt}->{'Frame_Ether.Packet_IPv4.Upp_UDP.Hdr_UDP.DestinationPort'},
		 $errType,$errType eq 1?0:0 );

    # 
    $cpp=SetupVCPPString($cpp);

    # 
    CNT_WriteSipMsg($sipmsg);

    # ICMP
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'SendModf'}= $cpp;
    $frames[0]{'SendMode'}= first;
    
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
    $frames[0]{'SendMode'}= first;
    
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$SIP_TimeOut,'',$link);
    CheckStatus($ret);

    return($ret);
}

sub RV_RTP {
    my ($recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 4 ){ $link=$SIP_Link; }
    if( $#_ < 3 ){ $autoResponse=\@SIP_AutoResponse; }
    if( $#_ < 2 ){ $timeout=$SIP_TimeOut; }
    if( $#_ < 0 ){ $recvFrame='RTPany'; }

#    $recvModf .= ' -DRTP4_RECV_DST_ADDR=v4\\\(\\\\\"$$CNT_TERM_ADDR_PTR\\\\\"\\\) -DRTP_RECV_SRC_PORT=$$CNT_RTP_TGT_PORT_PTR -DRTP_RECV_DST_PORT=$$CNT_RTP_TERM_PORT_PTR';

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

    $CNT_RTP_PAYLOAD_DATA=$frames[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Upp_UDP.Payload.data'};

    CheckStatus($ret);
    return($ret);
}

sub SQ_Term_RTP {
    my($count,$timeout,$sendfirst,$link)=@_;
    if( $link eq '')        { $link=$SIP_Link; }
    if( $timeout eq '')     { $timeout=$SIP_TimeOut; }
    if( $count eq '' )      { $count=1;}
    
    my($exp,$ret,@frames,@unknown);
    @frames=();
    
    # 
    $RTPrecvCount=0;

    # 
    $frames[0]{'Recv'}= 'RTP4any';
    $frames[0]{'RecvMode'}= 'actstop';
    $exp=\sprintf('RecActRTPLoopCount(%s,@_)',$count);  # RTP
    $frames[0]{'RecvAction'}= $exp;                           
    
    # RIP
#    $frames[0]{'Send'}= 'RTP4';
#    $frames[0]{'SendMode'}= 'response';

    # 
#    if($sendfirst){
#	$frames[1]{'Send'}= 'RTP4';
#	$frames[1]{'SendMode'}= 'first';
#    }
    
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,\@SIP_AutoResponse,$link);

    # 
    vCLEAR($link);

    if($ret ne 'OK'){
	MsgPrint('ERR', "SIP message dose not receive[%s]\n",$ret);
	return $ret;
    }
    return $ret;
}

sub SD_Term_RTP {
    my($link)=@_;
    return SD_RTP('','',$link);
}

sub RV_Term_RTP {
    my($timeout,$link)=@_;
    if( $link eq '')        { $link=$SIP_Link; }
    if( $timeout eq '')     { $timeout=$SIP_TimeOut; }
    
    my($ret,@frames,@unknown);
    @frames=();
    
    # 
    $frames[0]{'Recv'}= 'RTPany';
    $frames[0]{'RecvMode'}= 'stop';
    
    # REGISTER

    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,\@SIP_AutoResponse,$link);
    if($ret ne 'OK'){
	MsgPrint('ERR', "SIP message dose not receive[%s]\n",$ret);
	return $ret;
    }
    return $ret;
}

# Other1,Other2 
sub SD_Other1_INVITE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER1'; }
    return SD_Proxy_INVITE($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other1_ACK {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER1'; }
    return SD_Proxy_ACK($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other1_BYE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER1'; }
    return SD_Proxy_BYE($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other1_CANCEL {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER1'; }
    return SD_Proxy_CANCEL($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other1_STATUS {
    my($code,$request,$rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER1'; }
    return SD_Proxy_STATUS($code,$request,$rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other1_MSG {
    my($header,$body,$addrule,$pktinfo,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER1'; }
    return SD_Proxy_MSG($header,$body,$addrule,$pktinfo,$conn,$link,$frame);
}
sub RV_Other1_INVITE {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    return RV_Proxy_INVITE($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other1_INVITEwithAuthorization {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    return RV_Proxy_INVITEwithAuthorization($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other1_INVITEwithAuthorization2 {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    return RV_Proxy_INVITEwithAuthorization2($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other1_ACK {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    return RV_Proxy_ACK($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other1_BYE {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    return RV_Proxy_BYE($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other1_CANCEL {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    return RV_Proxy_CANCEL($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other1_STATUS {
    my($recvCode,$correspondMsg,$rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    return RV_Proxy_STATUS($recvCode,$correspondMsg,$rule,$addrule,$conn,$timeout,$link,$frame);
}
# Other1
sub RV_Other1_STATUS_OtherResponseUnreachable {
    my($recvCode,$correspondMsg,$rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    my($result);
    if( $timeout eq ''){ $timeout=$SIP_TimeOut; }
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    if( $rule eq '' ){ $rule='D.STATUS.PX'; }

    my(@frames,$result,$exp);
    @frames=();

    # 
    if(ref($recvCode) eq 'ARRAY'){
	$exp=\sprintf(q{RecActGeneralStatus(['%s'],'%s',@_)},join(q{','},@$recvCode),$correspondMsg);
    }
    else{
	$exp=\sprintf(q{RecActGeneralStatus('%s','%s',@_)},$recvCode,$correspondMsg);
    }

    # Other1
    $frames[0]{'Recv'}=$frame;
    $frames[0]{'RecvMode'}='actstop';
    $frames[0]{'RecvMatch'}=\q{MatchSIPStatus('','',@_)};
    $frames[0]{'RecvAction'}=$exp;
    $frames[0]{'Connection'}=$conn;

    # Proxy
    $frames[1]{'Recv'}='SIP4toPROXY';
    $frames[1]{'RecvMode'}='';
    $frames[1]{'RecvMatch'}=\q{MatchSIPStatus('','',@_)};
    $frames[1]{'RecvAction'}=\q{RecActUnreachable('ICMP4ErrorFromPROXY',@_)};

    $result=RecvAndEvalDecodeRuleExt($rule,\@frames,$addrule,$timeout,$link,'autoRegist',$SIP_DNS_ANSWER_MODE);
    MsgPrint('INF',"RV_Other1_STATUS_OtherResponseUnreachable result[$result]\n");
    return $result;
}

sub SQ_Other1_SIP {
    my($recvFrame,$count,$timeout,$status,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    return SQ_Proxy_SIP($recvFrame,$count,$timeout,$status,$conn,$link,$frame);
}
sub SQ_Other1_WAIT {
    my($timeout,$matchFrame,$breakCode,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER1'; }
    return SQ_Proxy_WAIT($timeout,$matchFrame,$breakCode,$conn,$link,$frame);
}
sub SD_Other1_UnReachable {
    my($pktinfo,$link)=@_;
    my($msg);
    if($pktinfo eq ''){$pktinfo=$SIPPktInfoLast;}

    if(!$pktinfo || !($msg=$pktinfo->{'frame_txt'})){
	MsgPrint('ERR',"ICMP UnReachable playload dose not exist.");
	return '';
    }
    return SD_SIP_ICMP_ERROR($msg,$pktinfo,1,'ICMP4ErrorFromOTHER1',$link);
}
# RTP
sub SQ_Other1_RTP {
    my($count,$timeout,$sendfirst,$link)=@_;
    if( $link eq '')        { $link=$SIP_Link; }
    if( $timeout eq '')     { $timeout=$SIP_TimeOut; }
    if( $count eq '' )      { $count=1;}
    
    my($exp,$ret,@frames,@unknown);
    @frames=();
    
    # 
    $RTPrecvCount=0;

    # 
    $frames[0]{'Recv'}= 'RTPtoOTHER1';
    $frames[0]{'RecvMode'}= 'actstop';
    $exp=\sprintf('RecActRTPLoopCount(%s,@_)',$count);  # RTP
    $frames[0]{'RecvAction'}= $exp;                           
    
    # RIP
    $frames[0]{'Send'}= 'RTPfromOTHER1';
    $frames[0]{'SendMode'}= 'response';

    # REGISTER

    # 
    if($sendfirst){
	$frames[1]{'Send'}= 'RTPfromOTHER1';
	$frames[1]{'SendMode'}= 'first';
    }
    
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,\@SIP_AutoResponse,$link);
    if($ret ne 'OK'){
	MsgPrint('ERR', "SIP message dose not receive[%s]\n",$ret);
	return $ret;
    }
    return $ret;
}

sub SD_Other2_INVITE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER2'; }
    return SD_Proxy_INVITE($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other2_ACK {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER2'; }
    return SD_Proxy_ACK($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other2_BYE {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER2'; }
    return SD_Proxy_BYE($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other2_CANCEL {
    my($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER2'; }
    return SD_Proxy_CANCEL($rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other2_STATUS {
    my($code,$request,$rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER2'; }
    return SD_Proxy_STATUS($code,$request,$rule,$pktinfo,$addrule,$delrule,$conn,$link,$frame);
}
sub SD_Other2_MSG {
    my($header,$body,$addrule,$pktinfo,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4fromOTHER2'; }
    return SD_Proxy_MSG($header,$body,$addrule,$pktinfo,$conn,$link,$frame);
}
sub RV_Other2_INVITE {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER2'; }
    return RV_Proxy_INVITE($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other2_INVITEwithAuthorization {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER2'; }
    return RV_Proxy_INVITEwithAuthorization($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other2_INVITEwithAuthorization2 {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER2'; }
    return RV_Proxy_INVITEwithAuthorization2($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other2_ACK {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER2'; }
    return RV_Proxy_ACK($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other2_BYE {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER2'; }
    return RV_Proxy_BYE($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other2_CANCEL {
    my($rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER2'; }
    return RV_Proxy_CANCEL($rule,$addrule,$conn,$timeout,$link,$frame);
}
sub RV_Other2_STATUS {
    my($recvCode,$correspondMsg,$rule,$addrule,$conn,$timeout,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER2'; }
    return RV_Proxy_STATUS($recvCode,$correspondMsg,$rule,$addrule,$conn,$timeout,$link,$frame);
}
sub SQ_Other2_SIP {
    my($recvFrame,$count,$conn,$timeout,$status,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER2'; }
    return SQ_Proxy_SIP($recvFrame,$count,$timeout,$status,$conn,$link,$frame);
}
sub SQ_Other2_WAIT {
    my($timeout,$matchFrame,$breakCode,$conn,$link,$frame)=@_;
    if( $frame eq '' ){ $frame='SIP4toOTHER2'; }
    return SQ_Proxy_WAIT($timeout,$matchFrame,$breakCode,$conn,$link,$frame);
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

    # REGISTER
    if($autoRegist){
	push(@$frames,{'Recv'=>$CNT_RG_FRAME,
		       'RecvMatch'=>\'MatchSIPRequest(REGISTER,@_)',# SIPtoREG
                       'RecvAction'=>\q{RecActEvalRuleAndResponse('D.REGISTER.AutoResponse','E.STATUS-200-RETURN.RG',SIP4fromREG,@_)}});
    }

    # DNS
    if($autoDNS){
	push(@$frames,{'Recv'=>'SIP4toDNS','RecvAction'=>\sprintf('RecActDNSAnswer(%s,@_)',$autoDNS)});
    }

    # 
    $ret = CNT_SendAndRecv($frames,\@unknown,$timeout,\@SIP_AutoResponse,$link);
    if($ret ne 'OK'){
	@stack=caller(1);
	MsgPrint('ERR', "SIP message dose not receive[%s] callby[%s]\n",$ret,$stack[3]);
	return $ret;
    }

    $size=$#$frames;
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

    @stack=caller(1);MsgPrint('INF', "%s result[%s]\n",$stack[3],$ret);
    return $ret;
}


# RTP
#   
sub RecActRTPLoopCount {
    my($recvCount,$request,$recvFrame,$context)=@_;
    my(%pkt);
    $RTPrecvCount++;
    MsgPrint('INF',"RTP receive count[%s]\n",$RTPrecvCount);

    $pkt{pkt}=$recvFrame;
    $pkt{timestamp}=$recvFrame->{recvTime1};
    $pkt{dir}='recv';
    # RTP
    StoreRTPPktInfo(\%pkt);
    return(($recvCount <= $RTPrecvCount)?'OK':'');
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
		MsgPrint('INF',"State code(%s) recived\n",$code);
		return 'OK';
	    }
	}
    }
    elsif($code eq $recvCode || $code =~ /$recvCode/){
	MsgPrint('INF',"State code(%s) recived\n",$code);
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

# 
sub RecvAndWait {
    my($matchframe,$recvFrame,$breakCode,$conn,$timeout,$link,$autoRegist,$autoDNS)=@_;
    if( $link eq '')        { $link=$SIP_Link; }
    if( $timeout eq '')     { $timeout=$SIP_TimeOut; }

    my($startIndex,$endIndex,$result,$ret,@frames,@unknown,$exp,$size);
    @frames=();

    # 
    $startIndex=$#SIPPktInfo+1;
    
    # 
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'RecvMode'}= 'actstop';
    # SIP
    $frames[0]{'RecvMatch'}= \'MatchSIPmsg(@_)';
    $frames[0]{'Connection'}= $conn;

    # 
    $frames[0]{'RecvAction'}= \q{RecActGeneral(@_)};
    if(ref($breakCode) eq 'SCALAR'){
        $exp=\sprintf(q{RecActGeneral(\q{%s},@_)},$$breakCode);
    }
    else{
        $exp=\sprintf(q{RecActGeneral('%s',@_)},$breakCode);
    }

    $frames[0]{'RecvAction'}= $exp;
    
    $size=0;
    # REGISTER
    if($autoRegist){
        $size++;
	$frames[$size]{'Recv'}= $CNT_RG_FRAME;
	$frames[$size]{'RecvMatch'}= \'MatchSIPRequest(REGISTER,@_)'; # SIPtoREG
        $frames[$size]{'RecvAction'}= \q{RecActEvalRuleAndResponse('D.REGISTER.AutoResponse','E.STATUS-200-RETURN.RG',SIP4fromREG,@_)};
    }
    # DNA
    if($autoDNS){
	$size++;
        $frames[$size]{'Recv'}='SIP4toDNS';
        $frames[$size]{'RecvMode'}='';
        $frames[$size]{'RecvMatch'}='';
        $frames[$size]{'RecvAction'}=\sprintf('RecActDNSAnswer(%s,@_)',$autoDNS);
    }
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,\@SIP_AutoResponse,$link);

    # Wait
    if($#SIPPktInfo<$startIndex){return '';}
    $ret=FVibc('recv','',$startIndex,@$matchframe);

    return $ret;
}

# 
#   
#   
#   
#   
#   
#             SeqMode=>[send|recv|recvstop]
#             RecvMatching=>
#             RecvMsgType=>REQUEST|STATUS
#          
#          
#          
#          
#          
sub RecvAndSendMultiUnit {
    my($multiSeq,$count,$timeout,$autoResponse,$link,$autoRegist,$autoDNS)=@_;
    if( $link eq '') { $link=$SIP_Link; }
    if( $count eq '' && $timeout eq '' ) {return 'NG';}

    my($exp,$result,$ret,@frames,@unknown,@stack,$no,$i,$seq,$encodeRule,$decodeRule,$pktCount,$recvMag);

    @frames=();
    $no=0;
    # 
    $pktCount=$#SIPPktInfo;

    for($i=0;$i<=$#$multiSeq;$i++,$no++){
	$seq=$multiSeq->[$i]->{SeqMode};
	$recvMag=$multiSeq->[$i]->{RecvMatching};
	$encodeRule=$multiSeq->[$i]->{EncodeRule};
	$decodeRule=$multiSeq->[$i]->{DecodeRule};
	# 
	$frames[$no]{'Recv'}= $multiSeq->[$i]->{RecvFrame};
	$frames[$no]{'RecvMode'}= ($seq eq 'recv' && 0 < $count)?'lastsend':($seq eq 'recvstop'?'stop':'');
	$frames[$no]{'RecvCount'}= (0 < $count)?$count:'';
	$frames[$no]{'RecvDisplay'}= $multiSeq->[$i]->{'RecvDisplay'};
	$frames[$no]{'Connection'}= $multiSeq->[$i]->{'Connection'};
	# SIP
	if($recvMag){
	    if($recvMag eq 'REQUEST'){
		$exp=\q{MatchSIPRequest('',@_)};  
	    }
	    elsif($recvMag eq 'STATUS'){
		$exp=\q{MatchSIPStatus('','',@_)};
	    }
	    elsif(ref($recvMag) eq 'SCALAR'){
		if($multiSeq->[$i]->{RecvMsgType} ne 'STATUS'){
		    $exp=\sprintf(q{MatchSIPRequest(\q{%s},@_)},$$recvMag);
		}
		else{
		    $exp=\sprintf(q{MatchSIPStatus(\q{%s},'',@_)},$$recvMag);
		}
	    }
	    else{
		if($multiSeq->[$i]->{RecvMsgType} ne 'STATUS'){
		    $exp=\sprintf(q{MatchSIPRequest(%s,@_)},$recvMag);
		}
		else{
		    $exp=\sprintf(q{MatchSIPStatus(%s,'',@_)},$recvMag);
		}
	    }
	    $frames[$no]{'RecvMatch'}= $exp;
	}
	
	# 
	if($encodeRule || $decodeRule){
	    if($encodeRule && $multiSeq->[$i]->{SendFrame} eq ''){
		MsgPrint('ERR',"SendFrame is empty");
	    }
	    else{
		$exp = \sprintf(q{RecActEvalRuleAndResponse('%s','%s',%s,@_)},$decodeRule,$encodeRule,$multiSeq->[$i]->{SendFrame});
		$frames[$no]{'RecvAction'}= $exp;
		if($seq eq 'send'){
		    $no++;
		    $exp = \sprintf(q{SndActEvalRuleAndRequest('%s',%s,@_)},$encodeRule,$multiSeq->[$i]->{SendFrame});
		    $frames[$no]{'SendAction'}= $exp;
		    $frames[$no]{'SendMode'}= 'first';
		}
	    }
	}
	else{
	    $frames[$no]{'RecvAction'}= \q{RecActCapturing(@_)};
	}
    }

    # 
    if($autoResponse){
	for($i=0;$i<=$#$autoResponse;$i++){
	    $frames[$no]{'Recv'}= $autoResponse->[$i]->{frame};
	    $frames[$no]{'RecvMatch'}= $autoResponse->[$i]->{match};
            $frames[$no]{'RecvAction'}= $autoResponse->[$i]->{action};
	    $no++;
	}
    }

    # REGISTER
    if($autoRegist){
	$frames[$no]{'Recv'}= $CNT_RG_FRAME;
	$frames[$no]{'RecvMatch'}= \'MatchSIPRequest(REGISTER,@_)'; # SIPtoREG
        $frames[$no]{'RecvAction'}= \q{RecActEvalRuleAndResponse('D.REGISTER.AutoResponse','E.STATUS-200-RETURN.RG',SIP4fromREG,@_)};
	$no++;
    }

    # DNS
    if($autoDNS){
        $frames[$no]{'Recv'}='SIP4toDNS';
        $frames[$no]{'RecvMode'}='';
        $frames[$no]{'RecvMatch'}='';
        $frames[$no]{'RecvAction'}=\sprintf('RecActDNSAnswer(%s,@_)',$autoDNS);
        $frames[$no]{'SendMode'}='';
	$no++;
    }

#    PrintVal(\@frames);
    # 
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,\@SIP_AutoResponse,$link);
    if( $#SIPPktInfo <= $pktCount ){
	@stack=caller(1);
	MsgPrint('WAR', "SIP message dose not receive callby[%s]\n",$ret,$stack[3]);
	return $ret;
    }

    @stack=caller(1);MsgPrint('INF', "%s result[%s]\n",$stack[3],$ret);
    return 'OK';
}


sub SndActEvalRuleAndRequest {
    my($encodeRule,$responseFrame,$request,$recvFrame,$context)=@_;

    my($result,$pktinfo,$msg,$ret,$link);
    $link=$context->{'LINK:'};

    # SIP
    $pktinfo=$request->{'RecvStruct'};

    # 
    if( $encodeRule ){
	if( !($result=EvalRule($encodeRule,$pktinfo)) ){
	    MsgPrint('ERR', "Eval rule error,skip send response\n");
	    return 'ActionError';
	}
	# 
	if( !($msg=GetKeyVal($result,'EX:')) ){
	    MsgPrint('ERR', "Can't create SIP message\n");
	    return 'ActionError';
	}
	# 
	$ret = SD_SIP($msg,$responseFrame,'',$pktinfo->{'pkt'}->{'Connection'},$link);
	MsgPrint('INF', "AutoResponse done encoderule(%s)\n",$encodeRule);
    }

    return '';
}

# DNS
#   
#                 SRV SRV,NS,AAAA
sub RecActDNSAnswer {
    my($mode,$request,$recvFrame,$context)=@_;
    my($srcPort,$transactID,$ra,@query,$querySize,$key,$i,$fqdn,$addr,$type,$class,$cpp,$count,%pkt,$proto,$ssl);

    # 
    $srcPort = $recvFrame->{'Frame_Ether.Packet_IPv4.Upp_UDP.Hdr_UDP.SourcePort'};

    # 
    $transactID = $recvFrame->{'Frame_Ether.Packet_IPv4.Upp_UDP.Udp_DNS.Identifier'};

    # Query or Response
    $ra = $recvFrame->{'Frame_Ether.Packet_IPv4.Upp_UDP.Udp_DNS.RA'};

    # Query
    $querySize=$recvFrame->{'Frame_Ether.Packet_IPv4.Upp_UDP.Udp_DNS.ANCount#'};
    
    if($srcPort eq '' || $transactID eq '' || $ra eq '' || $querySize <=0){
	MsgPrint('WAR',"DNS query enexpected form srcport[%s] tranID[%s] RA[%s] Questions[%s]\n",
		 $srcPort,$transactID,$ra,$querySize);
	return '';
    }

    # 
    for($i=0;$i<$querySize;$i++){

	# Questions
	$key=sprintf('Frame_Ether.Packet_IPv4.Upp_UDP.Udp_DNS.DNS_Question.DNS_QuestionEntry%s.Type',$i?$i+1:'');
	$type=int($recvFrame->{$key});

	# Questions
	$key=sprintf('Frame_Ether.Packet_IPv4.Upp_UDP.Udp_DNS.DNS_Question.DNS_QuestionEntry%s.Class',$i?$i+1:'');
	$class=int($recvFrame->{$key});

	# Questions
	$key=sprintf('Frame_Ether.Packet_IPv4.Upp_UDP.Udp_DNS.DNS_Question.DNS_QuestionEntry%s.Name',$i?$i+1:'');
	$fqdn=$recvFrame->{$key};

	$addr=FindAAAARecord($fqdn);

	if($fqdn){ # AAAA
	    $query[$i]{FQDN}=$fqdn;
	    $query[$i]{TYPE}=$type;
	    $query[$i]{CLASS}=$class;
	    $query[$i]{AAAA}=$addr->{'IPV4'};
	}

	if( $type eq 1 && $class eq 1 && $addr->{'IPV4'}){$count++;}
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
	    $cpp=sprintf("%s -DDNS_UDP_DST_PORT=%d -DDNS_TRANSACTION_ID=%d -DDND_TTL=%d -DA_FQDN1=\\\"%s\\\" -DA_TYPE1=%s -DA_CLASS1=%s -DDNS_TARGETNAME=\\\"%s\\\"  -DSRV4_PORT=%d ",
			 $SIP_BASE_CPP,$srcPort,$transactID,$SIP_DNS_TTL,
			 $query[0]{FQDN},$query[0]{TYPE},$query[0]{CLASS},$addr->{'FQDN'},$ssl =~ /sips/i ? 5061:5060);
	    vCPP($cpp);

	    # SRV
	    SD_RTP('SIP4fromDNS_SRV');
	    $pkt{answer}='SRV';
	    $pkt{'answer-mode'}=0;
	}
	else{
	    MsgPrint('SEQ',"Can't find SRV record[%s]\n",$query[0]{FQDN});
	}
    }
    # 
    elsif($count eq ''){
	$cpp=sprintf("%s -DDNS_UDP_DST_PORT=%d -DDNS_TRANSACTION_ID=%d -DA_FQDN1=\\\"%s\\\" -DA_TYPE1=%s -DA_CLASS1=%s ",
		     $SIP_BASE_CPP,$srcPort,$transactID,$fqdn,$type,$class);
        if ($type eq '' || $class eq '') {
	    MsgPrint('WAR',"DNS query any of parameter null, FQDN[%s] TYPE[%s] CLASS[%s]\n",
		     $fqdn,$type,$class);
	    return '';
        }
	vCPP($cpp);
	SD_RTP($fqdn ? 'SIP4fromDNS_NONE' : 'SIP4fromDNS_SOA');
	$pkt{answer}=$fqdn ? 'No Host' : 'SOA';
	$pkt{'answer-mode'}=0;
	$pkt{'query'}='ROOT';
    }
    # 
    else{
	$cpp=sprintf("%s -DDNS_UDP_DST_PORT=%d -DDNS_TRANSACTION_ID=%d -DDND_TTL=%d -DA_FQDN1=\\\"%s\\\" -DA_TYPE1=%s -DA_CLASS1=%s -DA_IP4ADDR1=\\\"%s\\\" -DA_IP4ADDR2=\\\"%s\\\" ",
		     $SIP_BASE_CPP,$srcPort,$transactID,$SIP_DNS_TTL,
		     $query[0]{FQDN},$query[0]{TYPE},$query[0]{CLASS},$query[0]{AAAA},$SIP_OTHER_AAAA);
	vCPP($cpp);

	# DNS
	SD_RTP(($mode eq 'AAAA2' && $addr->{'2RECORD'})?'SIP4fromDNS_A2':'SIP4fromDNS_A1');
	$pkt{answer}=$query[0]{AAAA};
	$pkt{'answer-mode'}=($mode eq 'AAAA2' && $addr->{'2RECORD'})?'2':'1';
    }
    # DNS
    StoreDNSPktInfo(\%pkt);
}

1
