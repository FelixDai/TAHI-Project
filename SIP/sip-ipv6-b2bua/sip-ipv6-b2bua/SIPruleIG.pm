#!/usr/local/bin/perl
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


#use strict;

# 
# 10/1/ 4  S.EXPIRES_DECIMAL
#          S.VIA-URI_HOSTNAME
#          S.RFC3261-12-21_Contact,S.REQUIRE-TAG_OPTION,S.P-REQUIRE-TAG_OPTION

#=================================
# 
#=================================
$CNT_IG_MSG_MAX = 1300;
$CNT_IG_BODY_MAX = 1000;
$CNT_IG_REQUEST_MAX = 256;
$CNT_IG_HEADER_MAX = 256;
$CNT_IG_URI_MAX = 128;

# IG
@ImplementGuidelineRules =
(
 #=================================
 # 
 #=================================
 #=================================
 # 
 #=================================
 #=================================
 # 
 #=================================

### IG

 # %% R-URI:03 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_TO-URI', 'SP:' => 'IG', 'CA:' => 'Request',
   'OK:' => \\'The initial Request-URI(%s) of the message MUST be the same value as the addr-spec(%s) in the To header field.', 
   'NG:' => \\'The initial Request-URI(%s) of the message MUST be the same value as the addr-spec(%s) in the To header field.', 
#   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',\\\'HD.To.val.ad.ad.txt',@_)}}, 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','strict-without-port',FV('RQ.Request-Line.uri',@_),FV('HD.To.val.ad',@_),@_)} },

 # %% BODY:01 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BODY_EXIST', 'SP:' => 'IG', 'CA:' => 'Body',
   'OK:' => "A body part MUST be present in this message.", 
   'NG:' => "A body part MUST be present in this message.", 
   'EX:' =>\\'BD.txt'},


 # %% CNTLENGTH:01 %%	Content-Length
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CNTLENGTH_EXISTandBODY', 'SP:' => 'IG', 'CA:' => 'Content-Length',
   'OK:' => \\'The Content-Length header MUST be present, and the value(%s) MUST equal the size(%s) of the message-body, in decimal number of octets.', 
   'NG:' => \\'The Content-Length header MUST be present, and the value(%s) MUST equal the size(%s) of the message-body, in decimal number of octets.', 
   'EX:'=>\q{FFop('eq',\\\'HD.Content-Length.val',length(FV('BD.txt',@_)),@_)}},

 # %% BODY:02 %%	
 # [IG: A body part MUST NOT be present in BYE/CANCEL/REGISTER/ACK message]
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BODY_NOEXIST', 'SP:' => 'IG', 'CA:' => 'Body',
   'OK:' => "A body part MUST NOT be present in this message.", 
   'NG:' => "A body part MUST NOT be present in this message.", 
   'EX:' => \q{!FV('BD.txt',@_)} }, 

### IG

 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQMSG_LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'SIP',
   'OK:' => \\'The length(%s) of whole SIP request message (on UDP) MUST be less than or equal to 1300 bytes.', 
   'NG:' => \\'The length(%s) of whole SIP request message (on UDP) MUST be less than or equal to 1300 bytes.', 
   'PR:' => \q($SIP_PL_TRNS eq "UDP"), ## 2006.1.27 sawada add ##
   'EX:' => \q{FFop('<=',length(FV('frame_txt',@_)),1300,@_)}},

 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BODY_LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'Body',
   'OK:' => \\'The length(%s) of SDP body message MUST be less than or equal to 1000 bytes.', 
   'NG:' => \\'The length(%s) of SDP body message MUST be less than or equal to 1000 bytes.', 
   'EX:' => \q{FFop('<=',length(FV('body_txt',@_)),1000,@_)}},

 # Request line
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-LINE_LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'Request',
   'OK:' => \\'The length(%s) of request line MUST be less than or equal to %s bytes.', 
   'NG:' => \\'The length(%s) of request line MUST be less than or equal to %s bytes.', 
   'EX:' => \q{FFop('<=',length(FV('RQ.Request-Line.txt',@_)),$CNT_IG_REQUEST_MAX,@_)}},

 # Request Line: URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'Request',
   'OK:' => \\'The length(%s) of Request URI MUST be less than or equal to %s bytes.', 
   'NG:' => \\'The length(%s) of Request URI MUST be less than or equal to %s bytes.', 
   'EX:' => \q{FFop('<=',length(FV('RQ.Request-Line.uri.txt',@_)),$CNT_IG_URI_MAX,@_)}},

 # Request Line: userinfo
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-LINE_USERINFO-LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'Request',
   'OK:' => \\'The length(%s) of request line \"userinfo\" MUST be less than or equal to 32 bytes.', 
   'NG:' => \\'The length(%s) of request line \"userinfo\" MUST be less than or equal to 32 bytes.', 
   'EX:' => \q{FFop('<=',length(FV('RQ.Request-Line.uri.ad.userinfo',@_)),32,@_)}},

 # Status line
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.STATLINE_LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'Status',
   'OK:' => \\'The length(%s) of status line MUST be less than or equal to %s bytes.', 
   'NG:' => \\'The length(%s) of status line MUST be less than or equal to %s bytes.', 
   'EX:' => \q{FFop('<=',length(FV('RQ.Status-Line.txt',@_)),$CNT_IG_REQUEST_MAX,@_)}},

 # 
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.HEADERS_LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'Header',
   'OK:' => "The length of each header line MUST be less than or equal to $CNT_IG_HEADER_MAX bytes.", 
   'NG:' => "The length of each header line MUST be less than or equal to $CNT_IG_HEADER_MAX bytes. There are one or more header lines exceeding this limit.",
   'EX:' => \q{!grep{$CNT_IG_HEADER_MAX<length($_)} split(/\r\n/,FV('header_txt',@_))} },

 # From URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'From',
   'OK:' => \\'The length(%s) of From URI MUST be less than or equal to %s bytes.', 
   'NG:' => \\'The length(%s) of From URI MUST be less than or equal to %s bytes.', 
   'EX:' => \q{FFop('<=',length(FV('HD.From.val.ad.ad.txt',@_)),$CNT_IG_URI_MAX,@_)}},

 # To URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'To',
   'OK:' => \\'The length(%s) of To URI MUST be less than or equal to %s bytes.', 
   'OK:' => \\'The length(%s) of To URI MUST be less than or equal to %s bytes.', 
   'EX:' => \q{FFop('<=',length(FV('HD.To.val.ad.ad.txt',@_)),$CNT_IG_URI_MAX,@_)}},

 # Contact URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-URI_LEN-MAXIMUM', 'SP:' => 'IG', 'CA:' => 'Contact',
   'OK:' => "The length of Contact URI MUST be less than or equal to $CNT_IG_URI_MAX bytes.", 
   'NG:' => "The length of Contact URI MUST be less than or equal to $CNT_IG_URI_MAX bytes.", 
   'EX:' => \q{!grep{$CNT_IG_URI_MAX<length($_)} @{FVs('HD.Contact.val.contact.ad.ad.txt',@_)}}},




 #=================================
 # 
 #=================================

 # %% ALLMesg %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ALLMesg', 'SP:' => 'IG',
   'RR:' => [
              'S.HEADERS_LEN-MAXIMUM',  ##ADD for IG
              'S.TAG-PRIORITY',
              'S.VIA_EXIST', 
              'S.VIA-BRANCH_z9hG4bK', 
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.FROM_EXIST', 
              'S.FROM_QUOTE', 
              'S.FROM-URI_LEN-MAXIMUM',  ##ADD for IG
              'S.TO_EXIST', 
              'S.TO_QUOTE', 
              'S.TO-URI_LEN-MAXIMUM',  ##ADD for IG
              'S.CALLID_EXIST', 
              'S.CSEQ_EXIST', 
              'S.CSEQ-SEQNO_32BIT', 
              'S.CNTLENGTH_EXISTandBODY', 
              'S.CNTLENGTH_NOBODY_0',
              'S.CNTTYPE_VALID', 
              'S.CNTTYPE_APP-SDP',
              'S.BODY_LEN-MAXIMUM',  ##ADD for IG
#              'S.PORT-SIGNAL_DEFAULTS'
            ]
 }, 

 # %% ReqMesg %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ReqMesg', 'SP:' => 'IG',
   'RR:' => [
              'S.REQMSG_LEN-MAXIMUM',  ##ADD for IG
              'SSet.ALLMesg',
##            'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-URI_LEN-MAXIMUM',  ##ADD for IG
              'S.R-LINE_VERSION',
              'S.R-LINE_LEN-MAXIMUM',  ##ADD for IG
              'S.R-LINE_USERINFO-LEN-MAXIMUM',  ##ADD for IG
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
##            'S.RFC3261-12-21_Contact',		# TLS dependent
##            'S.REQUIRE-TAG_OPTION',
##            'S.P-REQUIRE-TAG_OPTION',
            ]
 },  

 # %% ResMesg %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ResMesg', 'SP:' => 'IG',
   'RR:' => [
             'SSet.ALLMesg',
             'S.STATLINE_LEN-MAXIMUM',  ##ADD for IG 
             'S.FROM-URI_LOCAL-URI',
             'S.FROM-TAG_LOCAL-TAG',
             'S.TO-URI_REMOTE-URI',
             'S.CALLID_VALID',
             'S.CSEQ-SEQNO_SEND-SEQNO',
			 'S.RFC3261-12-6_Contact',
            ]
 }, 


 # %% INVITE %%	INVITE
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.INVITE', 'SP:' => 'IG',
   'RR:' => [
              'SSet.ReqMesg',
              'SSet.URICompMsg',
              'S.R-URI_TO-URI',
              'S.RE-ROUTE_NOEXIST',   ##ADD for IG
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CONTACT-URI_LEN-MAXIMUM',  ##ADD for IG
              'S.CSEQ-METHOD_INVITE',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
              'S.BODY_EXIST',  ##ADD for IG
              'SSet.SDP',
            ]
 }, 


 # %% ACK %%	ACK
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK', 'SP:' => 'IG',
   'RR:' => [
              'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_ACK',
			  'S.RFC3261-8-82_Require',
			  'S.RFC3261-8-82_Proxy-Require',
              'S.RE-ROUTE_NOEXIST',   ##ADD for IG and TTC(watanabe)
              'S.FROM-URI_REMOTE-URI', 
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-METHOD_ACK',
	      'S.CSEQ-SEQNO_REQ-SEQNO',
              'S.BODY_NOEXIST',  ##ADD for IG
           ]
 }, 

 # %% CANCEL %%	CACNCEL
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.CANCEL', 'SP:' => 'IG',
   'RR:' => [
              'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_CANCEL',
              'S.R-URI_REQ-R-URI',
              'S.VIA_REQ-SINGULAR',
              'S.VIA_REQ-1STVIA',
              'S.VIA-BRANCH_REQ-VIA-BRANCH',
              'S.RE-ROUTE_NOEXIST',   ##ADD for IG and TTC(watanabe)
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-METHOD_CANCEL',
              'S.CSEQ-SEQNO_REQ-SEQNO',
              'S.REQUIRE_NOEXIST',
              'S.P-REQUIRE_NOEXIST',
              'S.BODY_NOEXIST',  ##ADD for IG
           ]
 }, 

 # %% BYE %%	BYE
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.BYE', 'SP:' => 'IG',
   'RR:' => [
              'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_BYE',
              'S.R-URI_REQ-CONTACT-URI',
              'S.RE-ROUTE_NOEXIST',  ##ADD for IG and TTC(watanabe)
              'S.CSEQ-METHOD_BYE',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
              'S.BODY_NOEXIST',  ##ADD for IG
            ]
 }, 

 # %% REGISTER %%	REGISTER
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REGISTER', 'SP:' => 'IG',
   'RR:' => [
              'SSet.ReqMesg',
              'SSet.URICompMsgRG',
              'S.MUSTNOT-HEADER_REGISTER',
              'S.R-URI_NOUSERINFO',
              'S.TO-TAG_NOEXIST',
##            'S.EXPIRES_DECIMAL',
              'S.CSEQ-METHOD_REGISTER',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
              'S.CONTACT-ACTION_NOEXIST',
              'S.BODY_NOEXIST',  ##ADD for IG
            ]
 }, 

 # %% ACK-Non2xx %%	ACK(2xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK-Non2xx', 'SP:' => 'IG',
   'RR:' => [
              'S.R-URI_TO-URI',
              'S.R-URI_REQ-R-URI',
##DEL              'S.BODY_NOEXIST',  ## supported by SSet.ACK(IG)
              'S.REQUIRE_NOEXIST',
              'S.P-REQUIRE_NOEXIST',
            ]
 }, 

 # %% Basic2-1 01 %%	Registrar receives Register.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.REGISTER.RG', 'SP:' => 'IG', 
   'RR:' => [
              'SSet.REGISTER',
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CONTACT-URI_REMOTE-CONTACT-URI',
              'S.CONTACT-URI_LEN-MAXIMUM',  ##ADD for IG
              'S.EXPIRES_NOT=0',
              'D.COMMON.FIELD.REQUEST.RG',
            ]
 }, 


# %% Basic2-1 02 %%	Registrar receives Register.
  { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.REGwithAuth.RG', 'SP:' => 'IG',
   'RR:' => [
              'SSet.REGISTER',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.CALLID_VALID',  ##MODIFY for IG[SHOULD->MUST]
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CONTACT-URI_REMOTE-CONTACT-URI',
              'S.CONTACT-URI_LEN-MAXIMUM',  ##ADD for IG
              'S.EXPIRES_NOT=0',
              'S.AUTHORIZ_EXIST.TM',
              'SSet.DigestAuth.NOPX',
              'S.AUTHORIZ-URI_R-URI',
              'D.COMMON.FIELD.REQUEST.RG',
            ]
 }, 

 # %% Basic3-1-2 02 %%	UA1 receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE.NOPX', 'SP:' => 'IG', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
              'S.CONTACT_EXIST',
              'S.CONTACT_QUOTE',
              'S.CONTACT-URI_LEN-MAXIMUM',  ##ADD for IG
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              'S.RE-ROUTE_NOEXIST',
              'S.BODY_EXIST',
              'SSet.SDP-ANS',
              'S.CSEQ-METHOD_INVITE',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Basic3-2-2 02 %%	Proxy receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE.PX', 'SP:' => 'IG', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
              'S.CONTACT_EXIST',
              'S.CONTACT_QUOTE',
              'S.CONTACT-URI_LEN-MAXIMUM',  ##ADD for IG
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              'S.BODY_EXIST',
              'SSet.SDP-ANS',
              'S.CSEQ-METHOD_INVITE',
              'S.RE-ROUTE_EXIST',
              'S.RE-ROUTE_ROUTESET_REVERSE.TWOPX',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Basic3-2-2 01 %%	Proxy receives 180 Ringing.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-180.PX',  'SP:' => 'IG', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
              'S.RE-ROUTE_EXIST',             # Added for IG
              'S.RE-ROUTE_ROUTESET_REVERSE.TWOPX',    # Added for IG
            ]
 }, 

 # %% Basic3-12-2 01 %%	Proxy receives 180 Ringing.(one proxy)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-180.ONEPX',  'SP:' => 'IG', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
              'S.TO-TAG_EXIST',
              'S.RE-ROUTE_EXIST',             # Added for IG
              'S.RE-ROUTE_ROUTESET.ONEPX',    # Added for IG
            ]
 }, 


 #=================================
 # 
 #=================================
 # 
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY.MAX-SIZE-SEND','PT:'=>BD,
  'EX:'=>sub{my($rule,$pktinfo,$context)=@_;
	     my($msg,$tmp,$i,$len,$mdec);
             $mdec=JoinKeyValue("%s",FVs('BD.m=.val',@_),'txt');
             $mdec=~s/sendonly/recvonly/mg;
             $CNT_PUA_SDP_O_VERSION++;
	     $msg=sprintf("v=0\r\no=UA%s ".$CNT_PUA_SDP_O_SESSION." ".$CNT_PUA_SDP_O_VERSION." IN IP6 %s\r\ns=-\r\nc=IN IP6 %s\r\nt=0 0\r\nm=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\na=rtpmap:0 PCMU/8000",
			  $tmp,$CVA_PUA_IPADDRESS,$CVA_PUA_IPADDRESS);
             $len=$CNT_IG_MSG_MAX-($context->{'ENCODE-SIZE:'}+length('Content-Length: XXXX\n\r')+length($msg)+2); # 
             $len=$len<($CNT_IG_BODY_MAX-length($msg))?$len:($CNT_IG_BODY_MAX-length($msg));
             if($len+length($msg)<1000){$len++;} # 3
	     for($i=0;$i<$len;$i++){
		 $tmp = $tmp . pack('c',$i%10+0x30);
	     }
	     $msg=sprintf("v=0\r\no=UA%s ".$CNT_PUA_SDP_O_SESSION." ".$CNT_PUA_SDP_O_VERSION." IN IP6 %s\r\ns=-\r\nc=IN IP6 %s\r\nt=0 0\r\nm=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\na=rtpmap:0 PCMU/8000",
			  $tmp,$CVA_PUA_IPADDRESS,$CVA_PUA_IPADDRESS);
	     return $msg;
	 }},


 # 
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY.MAX-SIZE','PT:'=>BD,
  'EX:'=>sub{my($rule,$pktinfo,$context)=@_;
	     my($msg,$tmp,$i,$len,$mdec);
             $mdec=JoinKeyValue("%s",FVs('BD.m=.val',@_),'txt');
             $mdec=~s/sendonly/recvonly/mg;
             $CNT_PUA_SDP_O_VERSION++;
	     $msg=sprintf("v=0\r\no=UA%s ".$CNT_PUA_SDP_O_SESSION." ".$CNT_PUA_SDP_O_VERSION." IN IP6 %s\r\ns=-\r\nc=IN IP6 %s\r\nt=0 0\r\n%s",
			  $tmp,$CVA_PUA_IPADDRESS,$CVA_PUA_IPADDRESS,$mdec);
             $len=$CNT_IG_MSG_MAX-($context->{'ENCODE-SIZE:'}+length('Content-Length: XXXX\n\r')+length($msg)+2); # 
             $len=$len<($CNT_IG_BODY_MAX-length($msg))?$len:($CNT_IG_BODY_MAX-length($msg));
             if($len+length($msg)<1000){$len++;} # 3
	     for($i=0;$i<$len;$i++){
		 $tmp = $tmp . pack('c',$i%10+0x30);
	     }
	     $msg=sprintf("v=0\r\no=UA%s ".$CNT_PUA_SDP_O_SESSION." ".$CNT_PUA_SDP_O_VERSION." IN IP6 %s\r\ns=-\r\nc=IN IP6 %s\r\nt=0 0\r\n%s",
			  $tmp,$CVA_PUA_IPADDRESS,$CVA_PUA_IPADDRESS,$mdec);
	     return $msg;
	 }},

 #  VIA TWOPX-VIA
### modified by Horisawa (2006.1.27)
 # Via
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_TWOPX-MANY','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'NX:'=>'Max-Forwards',
  'AR:'=>[$SIP_PL_TRNS, sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
               return sprintf("%s\r\n" .
                       "Via: SIP/2.0/$SIP_PL_TRNS dummy1.atlanta.example.com:".(($SIP_PL_TRNS eq "TLS")?"5061":"5060").";branch=@CVA_PUA_BRANCH_ALL[3]\r\n" .
                       " ;received=3ffe:501:ffff:20::1\r\n" .
                       "Via: SIP/2.0/$SIP_PL_TRNS dummy2.atlanta.example.com:".(($SIP_PL_TRNS eq "TLS")?"5061":"5060").";branch=@CVA_PUA_BRANCH_ALL[4]\r\n" .
                       " ;received=3ffe:501:ffff:20::2\r\n" .
                       "Via: SIP/2.0/$SIP_PL_TRNS dummy3.atlanta.example.com:".(($SIP_PL_TRNS eq "TLS")?"5061":"5060").";branch=@CVA_PUA_BRANCH_ALL[5]\r\n" .
                       " ;received=3ffe:501:ffff:20::3\r\n" .
                       "Via: SIP/2.0/$SIP_PL_TRNS dummy4.atlanta.example.com:".(($SIP_PL_TRNS eq "TLS")?"5061":"5060").";branch=@CVA_PUA_BRANCH_ALL[6]\r\n" .
                       " ;received=3ffe:501:ffff:20::4",
                       "Via: SIP/2.0/$SIP_PL_TRNS dummy5.atlanta.example.com:".(($SIP_PL_TRNS eq "TLS")?"5061":"5060").";branch=@CVA_PUA_BRANCH_ALL[6]\r\n" .
                       " ;received=3ffe:501:ffff:20::5",
                       join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_TWOPX_SEND_VIAS));} ]},

#  200 OK
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-200-MAX-SIZE','PT:'=>RQ,
  'FM:'=>'SIP/2.0 200 OK but the reason phrase is sooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo',},


#  407 Proxy Authorization Required
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-407-MAX-SIZE','PT:'=>RQ,
  'FM:'=>'SIP/2.0 407 Proxy Authorization Required and the reason phrase is sooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo',},


#  UNKNOWN Method request
 {'TY:'=>'ENCODE', 'ID:'=>'E.UNKNOWN-MAX-SIZE','PT:'=>RQ,
  'FM:'=>'UNKNOWN-METHODxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx %s:NUT@node.under.test.com SIP/2.0',
  'AR:'=>[\q(($SIP_PL_TRNS eq "TLS")?"sip":"sips")]},

#  VIA TWOPX-VIA
# modified by Horisawa (2006.1.27)
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_TWOPX-MAX-SIZE','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'NX:'=>'Max-Forwards',
  'AR:'=>[$SIP_PL_TRNS, sub{ $CVA_COUNT_BRANCH++;
				SetupViaParam($CVA_COUNT_BRANCH);
				$CVA_PUA_BRANCH_HISTORY
					= MakeMaxSizeString(256,"Via: SIP/2.0/$SIP_PL_TRNS %s;branch=z9hG4bKPUA\%s;received=%s",
						[$CNT_PUA_HOSTPORT,$CVA_PUA_IPADDRESS],'z9hG4bKPUA%s');
				$CNT_TWOPX_SEND_VIAS[2]=sprintf("%s;branch=%s;received=%s",
						$CNT_PUA_HOSTPORT,$CVA_PUA_BRANCH_HISTORY,$CVA_PUA_IPADDRESS);
				return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_TWOPX_SEND_VIAS);} ]},

#  FROM URI=PUA TAG=LOCAL
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_PUA-URI_LOCAL-TAG-MAX-SIZE','PT:'=>HD, 
  'FM:'=>'From: UA%s <%s>;tag=%s',
  'NX:'=>'To',
  'AR:'=>[\q{MakeMaxSizeString(256,'From: UA <%s>;tag=%s',[$CVA_PUA_URI,$CVA_LOCAL_TAG])},
	   \'$CVA_PUA_URI',\'$CVA_LOCAL_TAG']},

#  CALLID $CVA_CALLID
 {'TY:'=>'ENCODE', 'ID:'=>'E.CALLID_CVA-MAX-SIZE','PT:'=>HD,
  'FM:'=>'Call-ID: %s',
  'NX:'=>'CSeq',
  'AR:'=>[sub{$CVA_CALLID=MakeMaxSizeString(256,'Call-ID: 123@www.example.com','','123%s@www.example.com');return $CVA_CALLID;}]},


 #=================================
 # 
 #=================================
);

