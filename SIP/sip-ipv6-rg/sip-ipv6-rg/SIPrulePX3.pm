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

#use strict;

#=================================
# 
#=================================
@SIPPXRules3 =
(
###############################################################
###
### 	6-3-2. 503
###	ES.STATUS-503-RETURN
###     Used by TM and Proxy
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-503-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-503',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.RETRY-AFTER_3600', 
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

 {'TY:'=>'ENCODE', 'ID:'=>'E.RETRY-AFTER_3600','PT:'=>HD,
  'FM:'=>'Retry-After: 3600'},


 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-503-RETURN.NO-RAFTER.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-503',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-500-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-500',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


#Content-Type
#  CONTENTTYPE VALID(application/sdp)
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTENTTYPE_UNKNOWN','PT:'=>HD,
  'FM:'=>'Content-Type: unknown'},

#Body
#  BODY_LOCAL
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_UNKNOWN','PT:'=>BD,
  'FM:'=>
    \q{"unknownunknownunknownunknownunknownunknownunknown\r\n" . 
       "unknownunknownunknownunknownunknownunknownunknown\r\n" . 
       "unknownunknownunknownunknownunknownunknownunknown\r\n" . 
       "unknownunknownunknownunknownunknownunknownunknown\r\n" . 
	   "unknownunknownunknownunknownunknownunknownunknown"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')}]
},


# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.UNKNOWN_TYPE.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_UNKNOWN',
	'E.CONTENT-LENGTH_CAL',
#	'E.BODY_VALID'],
	'E.BODY_UNKNOWN'],
  'EX:' =>\&MargeSipMsg},

## modify 05/08/01 kenzo
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.UNKNOWN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_UNKNOWN',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_UNKNOWN'],  ## ADD
  'EX:' =>\&MargeSipMsg},

###############################################################
###
### 	6-1-2. 415
###	ES.STATUS-415-RETURN
###     Used by TM
### 20050310 tadokoro modify
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-415-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-415',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-416-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-416',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


  # %% PX-1-16-63  %%  UA1 receives INVITE(forwarded)[re-vesion]
  # 20050801 kenzo
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.ONEPX.NOROUTE.TM',
    'RR:' => [
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              'S.FROM-URI_REMOTE-URI',            # from SSet.URICompMsg
              'S.TO-URI_LOCAL-URI',               # from SSet.URICompMsg
              'S.CONTACT-URI_REMOTE-CONTACT-URI', # from SSet.URICompMsg
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CSEQ-METHOD_INVITE',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              'S.BODY_EXIST',
	      'S.ROUTE_NOEXIST',
              'SSet.SDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'SS.FORWARD_REQUEST_COMPARE',
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
	      'S.R-URI_REMOTE-CONTACT-URI', # 200500226 tadokoro remove if upper rule created
	      'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 tadokoro
	      'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro             
            ]
 },


  # %% PX-1-16-101 03 %%  UA1 receives INVITE(forwarded)[re-vesion] with tel URL
  # 20050309 kenzo
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.ONEPX.telURL.TM',
    'RR:' => [
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              #'SSet.URICompMsg',                 # 20050225 disable tadokoro
              # 'S.R-URI_REMOTE-URI',             # disable from SSet.URICompMsg
              'S.FROM-URI_REMOTE-URI',            # from SSet.URICompMsg
              'S.TO-URI_LOCAL-URI',               # from SSet.URICompMsg
              'S.CONTACT-URI_REMOTE-CONTACT-URI', # from SSet.URICompMsg
              #'S.R-URI_TO-URI',                  # 20050225 disable tadokoro
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CSEQ-METHOD_INVITE',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              'S.BODY_EXIST',
              'SSet.SDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
             #'S.TO-TAG_NOEXIST',[DELETE BY WATANABE 2005/01/20]
              'SS.FORWARD_REQUEST_COMPARE',
             #'S.R-URI_ORIGINAL-R-URI', # 20050225 disable tadokoro
              #'SS.FORWARD_HEADERS_FROM_PX', # 20050309 disable tadokoro
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              # 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX',# remove
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
             #'S.R-URI_REMOTE-AOR_OR_CONTACT-URI', # not yet
#             'S.R-URI_REMOTE-CONTACT-URI', # 200500226 tadokoro remove if upper rule created
             'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 tadokoro
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro             
            ]
 },

 # To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_REMOTE-URI.telURL', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad',NINF('LocalAoRURI','RemotePeer'),@_)}}, 


 # %% ResMesg %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ResMesg.telURL', 'SP:' => 'IG',
   'RR:' => [
             'SSet.ALLMesg',
             'S.FROM-URI_LOCAL-URI',
             'S.FROM-TAG_LOCAL-TAG',
#             'S.TO-URI_REMOTE-URI',
             'S.TO-URI_REMOTE-URI.telURL',
             'S.CALLID_VALID',
             'S.CSEQ-SEQNO_SEND-SEQNO',
            ]
 }, 


 # %% Pattern3-26-2 03 %%	UA2 receives 4xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-4XX.NOPX.telURL', 
   'RR:' => [
              'SSet.ResMesg.telURL',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.RE-ROUTE_NOEXIST',
              'S.CSEQ-METHOD_INVITE',
              'S.TO-TAG_EXIST',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% PX-1-1-2 01 %%	UA receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-407.telURL.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX.telURL',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.DIGEST-AUTH_CHALLENGE.PX',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 

# UA1 receives 100 Trying.(no proxy)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-100.telURL.NOPX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg.telURL',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
            ]
 }, 

 # %% PX-1-16-101 03 %%	UA1 receives receives 100 Trying
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-100.telURL.TM', 
   'RR:' => [
              ### SSet.STATUS.INVITE-100.NOPX 
              'SSet.STATUS.INVITE-100.telURL.NOPX', 
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # %% Basic3-1-2 01 %%	UA1 receives 180 Ringing.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-180.telURL.NOPX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg.telURL',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
            ]
 }, 


 # %% PX-1-1-2 04 %%	UA1 receives 180 Ringing.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-180.telURL.TM', 
   'RR:' => [
              ### SSet.STATUS.INVITE-180.NOPX 
              'SSet.STATUS.INVITE-180.telURL.NOPX', 
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.FORWARD_RESPONSE_COMPARE',
              'S.VIA_REMOVE-TOPMOST',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro              
            ]
 }, 


 # %% PX-1-16-101 05 %%
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-200.telURL.TM', 
   'RR:' => [
              ### SSet.STATUS.INVITE.NOPX 
              'SSet.ResMesg.telURL',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
#              'S.TO-TAG_REMOTE-TAG',
              'S.CONTACT_EXIST',
              'S.CONTACT_QUOTE',
              'S.CSEQ-METHOD_INVITE',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              #'S.RE-ROUTE_ROUTESET_REVERSE.TWOPX',(delete by watanabe 2005/01/26)
              'S.BODY_EXIST',
              'SSet.SDP-ANS',
              'D.COMMON.FIELD.STATUS',
              'SS.FORWARD_RESPONSE_COMPARE',
              'S.VIA_REMOVE-TOPMOST',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro     
            ]
 }, 

## 2006.2.8 sawada ##
# REGISTER Request-URI = SIP-URI of Registrar RG-2-1-7-1
 {'TY:'=>'ENCODE', 'ID:'=>'E.REGISTER_RG-URI.FORWARDING','PT:'=>RQ,
  'FM:'=>'REGISTER %s:%s SIP/2.0','AR:'=>[\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},\q{$CNT_CONF{'PX1-HOSTNAME'}}]},

# REGISTER Request-URI = SIP-URI of Registrar RG-2-1-7-1
# {'TY:'=>'ENCODE', 'ID:'=>'E.REGISTER_RG-URI.FORWARDING','PT:'=>RQ,
#  'FM:'=>'REGISTER sip:%s SIP/2.0','AR:'=>[\q{$CNT_CONF{'PX1-HOSTNAME'}}]},

# RG-2-1-7-1
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOHOP.FORWARDING','PT:'=>'HD', 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++;  ## 2006.2.9 sawada ##
#  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
               @CNT_NOPX_SEND_VIAS_FORWARDING = ("$CNT_PUA_HOSTNAME:$CNT_PUA_PORT;branch=$CVA_PUA_BRANCH_HISTORY");
               return @CNT_NOPX_SEND_VIAS_FORWARDING[0];} ]},

# 2006.2.8 sawada RG-2-1-7-1 ##
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG.FORWARDING','PT:'=>'HD', 
  'FM:'=>'From: %s<%s:%s@%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
                                       \q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},
				       \q{NINF('DisplayName','LocalPeer')},\q{"$CNT_PX2_HOSTNAME"},\q{NINF('DLOG.LocalTag')}]},

# 20050803 kenzo RG-2-1-7-1
# {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG.FORWARDING','PT:'=>'HD', 
#  'FM:'=>'From: %s<sip:%s@%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
#				       \q{NINF('DisplayName','LocalPeer')},\q{"$CNT_PX2_HOSTNAME"},\q{NINF('DLOG.LocalTag')}]},

## 2006.2.8 sawada ##
#  To header for Register RG-2-1-7-1
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_RG-URI_NO-TAG.FORWARDING','PT:'=>'HD', 
  'FM:'=>'To: %s<%s:%s@%s>','AR:'=>[\q{NINF('DisplayName')?NINF('DisplayName') . ' ':''},
                                       \q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},
                                       \q{NINF('DisplayName','LocalPeer')},\q{"$CNT_PX2_HOSTNAME"}]},

#  To header for Register RG-2-1-7-1
# {'TY:'=>'ENCODE', 'ID:'=>'E.TO_RG-URI_NO-TAG.FORWARDING','PT:'=>'HD', 
#  'FM:'=>'To: %s<sip:%s@%s>','AR:'=>[\q{NINF('DisplayName')?NINF('DisplayName') . ' ':''}, \q{NINF('DisplayName','LocalPeer')},\q{"$CNT_PX2_HOSTNAME"}]},

# Contact URI RG-2-1-7-1, RG-3-1-2
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI.FORWARDING','PT:'=>'HD', 
  'FM:'=>'Contact: <sip:%s@%s>','AR:'=>[\q{NINF('DisplayName','LocalPeer')},\q{"$CNT_PUA_HOSTNAME"}]},

## 2006.2.8 sawada ## 
# Contact URI RG-2-1-7-1
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI.REGISTER.FORWARDING','PT:'=>'HD', 
  'FM:'=>'Contact: <%s:%s@%s>;expires=%s','AR:'=>[\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},\q{NINF('DisplayName','RemotePeer')},\q{CutHostname($CNT_PUA_CONTACT_URI)},\q{FV('HD.Expires.val.seconds',@_)}]},

# Contact URI RG-2-1-7-1
# {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI.REGISTER.FORWARDING','PT:'=>'HD', 
#  'FM:'=>'Contact: <sip:%s@%s>;expires=%s','AR:'=>[\q{NINF('DisplayName','RemotePeer')},\q{CutHostname($CNT_PUA_CONTACT_URI)},\q{FV('HD.Expires.val.seconds',@_)}]},


# REGISTER request RG-2-1-7-1
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.FORWARDING.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI.FORWARDING',
	'E.VIA_NOHOP.FORWARDING',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG.FORWARDING',
	'E.TO_RG-URI_NO-TAG.FORWARDING',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI.FORWARDING',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.AUTH_RESPONSE_QOP.REGISTER.FORWARDED','PT:'=>'HD',
  'PR:'=>\q{FVib('recv','','','HD.WWW-Authenticate.val.digest.qop','RQ.Status-Line.code','401') eq '"auth"'},
  'FM:'=>"Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s:%s:%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{FVib('recv','','','HD.WWW-Authenticate.val.digest.realm','RQ.Status-Line.code','401')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},  ## 2006.2.8 sawada add ##
	   \q{$CNT_CONF{'REG-HOSTNAME'}},
	   \q{NINF('SIPPort','PX1')},
           \q{OpCalcAuthorizationResponse3('WWW-Authenticate','REGISTER',NINF('AuthUserName'),
 					   (($SIP_PL_TRNS eq "TLS")?"sips":"sip").":$CNT_CONF{'PROXY_UAS_HOSTNAME'}:".NINF('SIPPort','PX1'),
#					   "sip:$CNT_CONF{'PROXY_UAS_HOSTNAME'}:".NINF('SIPPort','PX1'),
					   $CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_[0],
					   PKT('LAST','recv','RQ.Status-Line.code','401'),@_[2])},
         ] },

# Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.AUTH_RESPONSE_QOP.REGISTER.FORWARDED.ONEPX','PT:'=>'HD',
  'PR:'=>\q{FVib('recv','','','HD.WWW-Authenticate.val.digest.qop','RQ.Status-Line.code','401') eq '"auth"'},
  'FM:'=>"Authorization: Digest username=\"%s\", realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s:%s:%s\", response=%s",
  'AR:'=>[ \q{NDCFG('authorization_user','UA11')}, # username
           \q{FVib('recv','','','HD.WWW-Authenticate.val.digest.realm','RQ.Status-Line.code','401')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},  ## 2006.2.8 sawada add ##
	   \q{$CNT_CONF{'REG-HOSTNAME'}},
	   \q{NINF('SIPPort','PX1')},
           \q{OpCalcAuthorizationResponse3('WWW-Authenticate','REGISTER',NINF('AuthUserName'),
 					   (($SIP_PL_TRNS eq "TLS")?"sips":"sip").":$CNT_CONF{'PROXY_UAS_HOSTNAME'}:".NINF('SIPPort','PX1'),
#					   "sip:$CNT_CONF{'PROXY_UAS_HOSTNAME'}:".NINF('SIPPort','PX1'),
					   $CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_[0],
					   PKT('LAST','recv','RQ.Status-Line.code','401'),@_[2])},
         ] },


# FORWARDED REGISTER-200 RG-2-1-7-1
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.REGISTER-200.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI.REGISTER.FORWARDED',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


# REGISTER request RG-2-1-7-1
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.FORWARDING.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI.FORWARDING',
	'E.VIA_NOHOP.FORWARDING',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP.REGISTER.FORWARDED',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG.FORWARDING',
	'E.TO_RG-URI_NO-TAG.FORWARDING',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI.FORWARDING',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request RG-2-1-7-1
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.FORWARDING-407AUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI.FORWARDING',
	'E.VIA_NOHOP.FORWARDING',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG.FORWARDING',
	'E.TO_RG-URI_NO-TAG.FORWARDING',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI.FORWARDING',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

#  RG-2-1-7-1 PROXY-AUTHENTICATE VALID
 {'TY:'=>'ENCODE', 'ID:'=>'E.PX-AUTHENTICATE_VALID2.FORWARDED','PT:'=>HD, 
  'FM:'=>"Proxy-Authenticate: Digest realm=%s, qop=\"auth\", nonce=%s, opaque=\"\", stale=FALSE, algorithm=MD5",
'AR:'=>[\q{NINF('AuthRealm','UA21')},\'$CNT_AUTH_NONCE2']},


# RG-2-1-7-1 ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-401-RETURN-AUTH-2VIA.PX1', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-401',
	'E.VIA_RETURN_RECEIVED',
#	'E.PX-AUTHENTICATE_VALID2.FORWARDED', 
	'E.WWW_AUTH-VALID',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 # %% RG-2-1-7-1 R-URI %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_RG-URI.RG.FORWARDED', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST equal SIP or SIPS URI(%s) of registrar(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The Request-URI(%s) MUST equal SIP or SIPS URI(%s) of registrar(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('HostPort','name-strict',FV('RQ.Request-Line.uri.ad.hostport',@_),$CNT_PX1_HOSTNAME,@_)} },

 # RG-2-1-7-1 %% FROM %%	From-URI
## 2006.2.8 sawada ##
 #0128tuika     
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_REMOTE-URI.FORWARDED', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),NINF('DisplayName','RemotePeer').' <'.(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':'.NINF('DisplayName','RemotePeer'). '@'. CutHostname(NINF('LocalAoRURI','LocalPeer')).'>',@_)} },

 #0128tuika     
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_REMOTE-URI.FORWARDED', 'CA:' => 'From',
#  'OK:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
#   'NG:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
#   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),NINF('DisplayName','RemotePeer').' <sip:'.NINF('DisplayName','RemotePeer'). '@'. CutHostname(NINF('LocalAoRURI','LocalPeer')).'>',@_)} },


## 2006.2.8 sawada ## 
# RG-2-1-7-1	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_REMOTE-URI.FORWARDED', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt',(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':'.NINF('DisplayName','RemotePeer').'@'.CutHostname(NINF('LocalAoRURI','LocalPeer')),@_)}}, 

 # RG-2-1-7-1	To-URI
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_REMOTE-URI.FORWARDED', 'CA:' => 'To',
#   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
#   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
#   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt','sip:'.NINF('DisplayName','RemotePeer').'@'.CutHostname(NINF('LocalAoRURI','LocalPeer')),@_)}}, 

## 2006.2.8 sawada ## 
# RG-2-1-7-1	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LOCAL-URI.REGISTER.FORWARDED', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt',(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':'.NINF('DisplayName','LocalPeer').'@'.CutHostname(NINF('LocalAoRURI','RemotePeer')),@_)}}, 

 # RG-2-1-7-1	To-URI
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LOCAL-URI.REGISTER.FORWARDED', 'CA:' => 'To',
#   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
#   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
#   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt','sip:'.NINF('DisplayName','LocalPeer').'@'.CutHostname(NINF('LocalAoRURI','RemotePeer')),@_)}}, 


 # RG-2-1-7-1 %% URICompMsg %%	URI
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.URICompMsgFWDRG', 
   'RR:' => [
              'S.R-URI_RG-URI.RG.FORWARDED',
              'S.FROM-URI_REMOTE-URI.FORWARDED',
              'S.TO-URI_REMOTE-URI.FORWARDED',
            ]
 }, 

## 2006.2.8 sawada ## 
# %% FROM:08 %%	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_LOCAL-URI.REGISTER.FORWARDED', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),NINF('DisplayName','LocalPeer').' <'.(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':'.NINF('DisplayName','LocalPeer'). '@'. CutHostname(NINF('LocalAoRURI','RemotePeer')).'>',@_)} },

 # %% FROM:08 %%	From-URI
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_LOCAL-URI.REGISTER.FORWARDED', 'CA:' => 'From',
#   'OK:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
#   'NG:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
#   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),NINF('DisplayName','LocalPeer').' <sip:'.NINF('DisplayName','LocalPeer'). '@'. CutHostname(NINF('LocalAoRURI','RemotePeer')).'>',@_)} },


 # %% RG-2-1-7-1 ResMesg %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ResMesg.REGISTER.FORWARDED', 'SP:' => 'IG',
   'RR:' => [
             'SSet.ALLMesg',
             'S.FROM-URI_LOCAL-URI.REGISTER.FORWARDED',
             'S.FROM-TAG_LOCAL-TAG',
             'S.TO-URI_LOCAL-URI.REGISTER.FORWARDED',
             'S.CALLID_VALID',
             'S.CSEQ-SEQNO_SEND-SEQNO',
            ]
 }, 


# UA1 receives 100 Trying.(no proxy)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.REGISTER-100.NOPX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg.REGISTER.FORWARDED',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_REGISTER',
            ]
 }, 

 # %% RG-2-1-7-1 %%	UA11 receives receives 100 Trying
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-100.FORWARDED.TM', 
   'RR:' => [
              ### SSet.STATUS.INVITE-100.NOPX 
              'SSet.STATUS.REGISTER-100.NOPX', 
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # %% RG-2-1-7-1 %%   Proxy receives INVITE(forwarded)[re-version]
   { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.REGISTER_FORWARDED.PX',
     'RR:' => [
               'SSet.ALLMesg',
               'S.VIA-URI_HOSTNAME',
               'S.VIA-TRANSPORT_UDP',
               'S.R-URI_NOQUOTE',
               'S.R-LINE_VERSION',
               'S.MAX-FORWARDS_EXIST',
               'S.MAX-FORWARDS_DECREMENT',
               'S.FROM-TAG_EXIST',
               'S.CSEQ-METHOD_REQLINE-METHOD',
               'SSet.URICompMsgFWDRG',
               'S.CONTACT_EXIST',
               'S.CONTACT_NOT-*',
               'S.CONTACT_QUOTE',
               'S.CSEQ-METHOD_REGISTER',
               'SSet.SDP',
               'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
               'S.TO-TAG_NOEXIST',
               'S.P-AUTH_NOTEXIST',
               'SS.FORWARD_REQUEST_COMPARE',
               'S.R-URI_ORIGINAL-R-URI',
               'SS.FORWARD_HEADERS',
               'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 },


 # %% RG-2-1-7-1 01 %%	UA1 receives 401 Unauthorized from Registrar
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.FORWARDING.REGISTER-401.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'S.TAG-PRIORITY',
              'S.VIA_EXIST',
              'S.VIA-BRANCH_z9hG4bK',
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.FROM_EXIST',
              'S.FROM_QUOTE',
              'S.TO_EXIST',
              'S.TO_QUOTE',
              'S.CALLID_EXIST',
              'S.CSEQ_EXIST',
              'S.CSEQ-SEQNO_32BIT',
              'S.CNTLENGTH_NOBODY_0',
              'S.FROM-URI_LOCAL-URI.REGISTER.FORWARDED',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_LOCAL-URI.REGISTER.FORWARDED',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_REGISTER',
              'S.TO-TAG_EXIST',
              'S.WWW-AUTH_EXIST.PX',
              'S.WWW-AUTH_DIGEST',
              'S.WWW-AUTH_NONCE.EXIST',
              'S.WWW-AUTH_REALM.EXIST',
              'S.WWW-AUTH_QOP.AUTH',
              'S.WWW-AUTH-ALGORITHM.MD5',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]

 }, 


 # %% RG-1-1-1 03 %%	UA1 receives 200 BASIC
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.FORWARDED.REGISTER-BASIC', 
   'RR:' => [
              'S.TAG-PRIORITY',
              'S.VIA_EXIST',
              'S.VIA-BRANCH_z9hG4bK',
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.FROM_EXIST',
              'S.FROM_QUOTE',
              'S.TO_EXIST',
              'S.TO_QUOTE',
              'S.CALLID_EXIST',
              'S.CSEQ_EXIST',
              'S.CSEQ-SEQNO_32BIT',
	      'S.CNTLENGTH_EXISTandBODY',
              'S.CNTLENGTH_NOBODY_0',
              'S.PORT-SIGNAL_DEFAULTS',
              'S.FROM-URI_LOCAL-URI.REGISTER.FORWARDED',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_LOCAL-URI.REGISTER.FORWARDED',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST',
#              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_REGISTER',
              'S.TO-TAG_EXIST',
              'S.DATE_EXIST'
	     ]
},

## 2006.2.8 sawada ##
 # %% Contact:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-URI_FORWARDED-REGISTER-CONTACT-URI', 'CA:' => 'Contact',
   'OK:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
   'NG:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
   'EX:' => \q{FFop('eq',FV('HD.Contact.val.contact.ad.ad.txt',@_),(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':'.NINF('DisplayName'). '@'. CutHostname(NINF('REMOTE_CONTACT_URI')),@_)}},

 # %% Contact:nn %%
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-URI_FORWARDED-REGISTER-CONTACT-URI', 'CA:' => 'Contact',
#   'OK:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
#   'NG:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
#   'EX:' => \q{FFop('eq',FV('HD.Contact.val.contact.ad.ad.txt',@_),'sip:'.NINF('DisplayName'). '@'. CutHostname(NINF('REMOTE_CONTACT_URI')),@_)}},


 # %% Contact:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-EXPIRES_FORWARDED-REGISTER-CONTACT-EXPIRES', 'CA:' => 'Contact-Expires',
   'OK:' => \\'The expires parameter(%s) MUST equal the register-expires header field value(%s).',
   'NG:' => \\'The expires parameter(%s) MUST equal the register-expires header field value(%s).',
   'EX:' => \q{FFop('eq',FV('HD.Contact.val.contact.param.expires=',@_),FVib('send','','','HD.Expires.val.seconds','RQ.Request-Line.method','REGISTER'),@_)}},


 # %% RG-1-1-1 02 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.FORWARDED.REGISTER-200.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.FORWARDED.REGISTER-BASIC',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_FORWARDED-REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CONTACT-EXPIRES_FORWARDED-REGISTER-CONTACT-EXPIRES',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_ONEHOP.REGISTER.FORWARDED','PT:'=>'HD', 
  'FM:'=>'Via: SIP/2.0/%s %s',
   'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++; ## 2006.2.9 sawada ##
#   'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
	       return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_ONEPX_SEND_VIAS[0]);} ]},


 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOHOP_REGISTER_FORWARDED','PT:'=>'HD', 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++; ## 2006.2.9 sawada ##
#  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
	       return CutHostname(NDCFG('contact-uri','UA11')). @CNT_NOPX_SEND_VIAS_BRANCH[0]. ";received=". NDCFG('address','UA11');
	   }
	  ]},

# RG-2-1-7-2 20040808 kenzo
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG.REGISTER.FORWARDED','PT:'=>'HD', 
  'FM:'=>'From: %s<%s>;tag=%s','AR:'=>[\q{CutUsername(NDCFG('aor-uri','UA11'))." "},
				       \q{NDCFG('aor-uri','UA11')},\q{NINF('DLOG.LocalTag')}]},

# RG-2-1-7-2 20040808 kenzo
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_RG-URI_NO-TAG.REGISTER.FORWARDED','PT:'=>'HD', 
  'FM:'=>'To: %s<%s>','AR:'=>[\q{CutUsername(NDCFG('aor-uri','UA11')). " "},
				       \q{NDCFG('aor-uri','UA11')}]},

# RG-2-1-7-2 20040808 kenzo
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI.REGISTER.FORWARDED','PT:'=>'HD', 
  'FM:'=>'Contact: %s<%s>','AR:'=>[\q{CutUsername(NDCFG('contact-uri','UA11')). " "},
				       \q{NDCFG('contact-uri','UA11')}]},


# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.FORWARDED.ONEPX.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_ONEHOP.REGISTER.FORWARDED',
	'E.VIA_NOHOP_REGISTER_FORWARDED',
	'E.MAXFORWARDS_ONEHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG.REGISTER.FORWARDED',
	'E.TO_RG-URI_NO-TAG.REGISTER.FORWARDED',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI.REGISTER.FORWARDED',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.FORWARDED.ONEPX-AUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_ONEHOP.REGISTER.FORWARDED',
	'E.VIA_NOHOP_REGISTER_FORWARDED',
	'E.MAXFORWARDS_ONEHOP',
	'E.AUTH_RESPONSE_QOP.REGISTER.FORWARDED.ONEPX',
#	'E.AUTH_RESPONSE_QOP.REGISTER.FORWARDED',
#	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG.REGISTER.FORWARDED',
	'E.TO_RG-URI_NO-TAG.REGISTER.FORWARDED',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI.REGISTER.FORWARDED',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.FORWARDED.ONEPX.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_ONEHOP.REGISTER.FORWARDED',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

 # %% FROM:08 %%	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_LOCAL-URI.REGISTER.FORWARDED.ONEPX', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),NDCFG('aor-uri','UA11'),@_)} },

 # %% RG-2-1-7-2 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LOCAL-URI.REGISTER.FORWARDED.ONEPX', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.To.val.ad',@_),NDCFG('aor-uri','UA11'),@_)} },

 # %% VIA:08 %%	
 # branch = $CVA_PUA_BRANCH_HISTORY
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_CURRENT-PUA-BRANCH.REGISTER.FORWARDED.ONEPX', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
   'NG:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.', 
   'EX:' =>\q{FFop('EQ',FVs('HD.Via.val.via.param.branch=',@_),FVib('send','','','HD.Via.val.via.param.branch=','RQ.Request-Line.method','REGISTER'),@_)}},

 # %% VIA:16 %%	Via
# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_REGISTER.FORWARDED.ONEPX_SEND_EQUAL', 'CA:' => 'Via',
   'OK:' => \\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).', 
   'NG:' => \\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).', 
   'EX:' =>\q{FFop('EQ',FVs('HD.Via.val.via.sendby.txt',@_),FVib('send','','','HD.Via.val.via.sendby.txt','RQ.Request-Line.method','REGISTER'),@_)}}, 


 # %% RG-2-1-7-2 %%	UA11 receives Forwarded 401 Unauthorized from Registrar
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.FORWARDED.REGISTER-401.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'S.TAG-PRIORITY',
              'S.VIA_EXIST',
              'S.VIA-BRANCH_z9hG4bK',
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.FROM_EXIST',
              'S.FROM_QUOTE',
              'S.TO_EXIST',
              'S.TO_QUOTE',
              'S.CALLID_EXIST',
              'S.CSEQ_EXIST',
              'S.CSEQ-SEQNO_32BIT',
              'S.CNTLENGTH_NOBODY_0',
              'S.FROM-URI_LOCAL-URI.REGISTER.FORWARDED.ONEPX',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_LOCAL-URI.REGISTER.FORWARDED.ONEPX',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH.REGISTER.FORWARDED.ONEPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_REGISTER.FORWARDED.ONEPX_SEND_EQUAL',
              'S.CSEQ-METHOD_REGISTER',
              'S.TO-TAG_EXIST',
              'S.WWW-AUTH_EXIST.PX',
              'S.WWW-AUTH_DIGEST',
              'S.WWW-AUTH_NONCE.EXIST',
              'S.WWW-AUTH_REALM.EXIST',
              'S.WWW-AUTH_QOP.AUTH',
              'S.WWW-AUTH-ALGORITHM.MD5',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]

 }, 

 # %% RG-1-1-1 03 %%	UA1 receives 200 BASIC
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-BASIC.FORWARDED.ONEPX', 
   'RR:' => [
              'S.TAG-PRIORITY',
              'S.VIA_EXIST',
              'S.VIA-BRANCH_z9hG4bK',
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.FROM_EXIST',
              'S.FROM_QUOTE',
              'S.TO_EXIST',
              'S.TO_QUOTE',
              'S.CALLID_EXIST',
              'S.CSEQ_EXIST',
              'S.CSEQ-SEQNO_32BIT',
	      'S.CNTLENGTH_EXISTandBODY',
              'S.CNTLENGTH_NOBODY_0',
              'S.PORT-SIGNAL_DEFAULTS',
              'S.FROM-URI_LOCAL-URI.REGISTER.FORWARDED.ONEPX',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_LOCAL-URI.REGISTER.FORWARDED.ONEPX',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH.REGISTER.FORWARDED.ONEPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_REGISTER.FORWARDED.ONEPX_SEND_EQUAL',
              'S.CSEQ-METHOD_REGISTER',
              'S.TO-TAG_EXIST',
              'S.DATE_EXIST'
	     ]
},


 # %% Contact:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-URI_FORWARDED.ONEPX.REGISTER-CONTACT-URI', 'CA:' => 'Contact',
   'OK:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
   'NG:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
#   'EX:' => \q{PV(\@_)||FFop('eq',FV('HD.Contact.val.contact.ad.ad.txt',@_),FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER'),@_)}},
#   'EX:' => \q{FFop('eq',FV('HD.Contact.val.contact.ad.ad.txt',@_),FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER'),@_)}},
   'EX:' => sub {
       my($Contact,$ContactParam,$ContactURI);
       $Contact=FV('HD.Contact.txt',@_);
#       PrintVal($Contact);
       $ContactParam=FVSeparete('HD.Contact.val.contact.ad.ad.txt',';','',@_[1]);
#       PrintVal($ContactParam);
       $ContactURI=FFGetMatchStr('(sip.*)',$ContactParam,'','');
#       PrintVal($ContactURI);
       FFop('eq',$ContactURI,FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER'),@_);
   }},

 # %% RG-2-1-7-2 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.FORWARDED.ONEPX.REGISTER-200.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.REGISTER-BASIC.FORWARDED.ONEPX',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_FORWARDED.ONEPX.REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',  ## 2006.7.28 sawada del ##
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # %% RG-2-1-12 FROM %%	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_LOCAL-URI.WITH-ESCAPED-CHAR', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),FVib('send','','','HD.From.val.ad','RQ.Request-Line.method','REGISTER'),@_)} },

 # %% RG-2-1-12 TO %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_R-URI.WITH-ESCAPED-CHAR', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.To.val.ad',@_),FVib('send','','','HD.To.val.ad','RQ.Request-Line.method','REGISTER'),@_)} },


 # %% RG-1-1-1 01 %%	UA1 receives 401 Unauthorized from Registrar
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-401.WITH-ESCAPED-CHAR.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'S.TAG-PRIORITY',
              'S.VIA_EXIST',
              'S.VIA-BRANCH_z9hG4bK',
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.FROM_EXIST',
              'S.FROM_QUOTE',
              'S.TO_EXIST',
              'S.TO_QUOTE',
              'S.CALLID_EXIST',
              'S.CSEQ_EXIST',
              'S.CSEQ-SEQNO_32BIT',
              'S.CNTLENGTH_NOBODY_0',
              'S.FROM-URI_LOCAL-URI.WITH-ESCAPED-CHAR',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_LOCAL-URI.REGISTER.WITH-ESCAPED-CHAR',
              'S.TO-URI_R-URI.WITH-ESCAPED-CHAR',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_REGISTER',
              'S.TO-TAG_EXIST',
              'S.WWW-AUTH_EXIST.PX',
              'S.WWW-AUTH_DIGEST',
              'S.WWW-AUTH_NONCE.EXIST',
              'S.WWW-AUTH_REALM.EXIST',
              'S.WWW-AUTH_QOP.AUTH',
              'S.WWW-AUTH-ALGORITHM.MD5',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]

 }, 

 # %% RG-2-1-12 03 %%	UA1 receives 200 BASIC
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-BASIC.WITH-ESCAPED-CHAR', 
   'RR:' => [
              'S.TAG-PRIORITY',
              'S.VIA_EXIST',
              'S.VIA-BRANCH_z9hG4bK',
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.FROM_EXIST',
              'S.FROM_QUOTE',
              'S.TO_EXIST',
              'S.TO_QUOTE',
              'S.CALLID_EXIST',
              'S.CSEQ_EXIST',
              'S.CSEQ-SEQNO_32BIT',
	      'S.CNTLENGTH_EXISTandBODY',
              'S.CNTLENGTH_NOBODY_0',
              'S.PORT-SIGNAL_DEFAULTS',
              'S.FROM-URI_LOCAL-URI.WITH-ESCAPED-CHAR',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_LOCAL-URI.REGISTER.WITH-ESCAPED-CHAR',
              'S.TO-URI_R-URI.WITH-ESCAPED-CHAR',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_REGISTER',
              'S.TO-TAG_EXIST',
              'S.DATE_EXIST'
	     ]
},


 # %% Contact:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-URI_REGISTER-CONTACT-URI.WITH-ESCAPED-CHAR', 'CA:' => 'Contact',
   'OK:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
   'NG:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
   'EX:' => \q{FFop('eq',FV('HD.Contact.val.contact.ad.ad.txt',@_),FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER'),@_)}},


 # %% RG-2-1-12 02 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.TO-PARAM.WITH-ESCAPED-CHAR.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.REGISTER-BASIC.WITH-ESCAPED-CHAR',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_REGISTER-CONTACT-URI.WITH-ESCAPED-CHAR',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',  ## 2006.7.28 sawada del ##
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	      'S.TO-PARAM_EXIST_REGISTER',
            ]
 }, 

## 2006.2.8 sawada ##
## 2007.7.18 inoue ##
# PX-1-16-31 INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URI.WITH-ESCAPED-CHAR','PT:'=>RQ, 'NX:'=>'From',
  'FM:'=>'INVITE %s SIP/2.0',
#  'FM:'=>'INVITE %s:U%%6512@under.test.com SIP/2.0',
#  'AR:'=> [\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"}]},
  'AR:'=> [\q{encconv("RemoteAoRURI", "LocalPeer")}]},

## 2006.2.8 sawada ##
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_NO-TAG.WITH-ESCAPED-CHAR','PT:'=>'HD', 'NX:'=>'From', 
#3 2007.7.18 inoue ##
  'FM:'=>'To: %s<%s>','AR:'=>[\q{NINF('DisplayName','RemotePeer')?NINF('DisplayName','RemotePeer') . ' ':''},\q{encconv("RemoteAoRURI", "LocalPeer")}]},

# 20040808 kenzo
# {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_NO-TAG.WITH-ESCAPED-CHAR','PT:'=>'HD', 'NX:'=>'From', 
#  'FM:'=>'To: %s<sip:U%%6512@under.test.com>','AR:'=>[\q{NINF('DisplayName','RemotePeer')?NINF('DisplayName','RemotePeer') . ' ':''}]},

## 2006.2.8 sawada ##
## 2007.7.18 inoue ##
# ACK Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_AOR-URI.WITH-ESCAPED-CHAR','PT:'=>RQ, 'NX:'=>'From',
  'FM:'=>'ACK %s SIP/2.0',
  'AR:'=> [\q{encconv("RemoteAoRURI", "LocalPeer")}]},
#  'FM:'=>'ACK %s:U%%6512@under.test.com SIP/2.0',
#  'AR:'=> [\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"}]},

## 2006.2. 8 sawada ##
## 2997.7.18 inoue ##
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_REMOTE-TAG.WITH-ESCAPED-CHAR','PT:'=>'HD', 'NX:'=>'From',
  'FM:'=>'To: %s<%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','RemotePeer')?NINF('DisplayName','RemotePeer') . ' ':''},\q{encconv("RemoteAoRURI", "LocalPeer")},\q{NINF('DLOG.RemoteTag')}]},
#  'FM:'=>'To: %s<%s:U%%6512@under.test.com>;tag=%s','AR:'=>[\q{NINF('DisplayName','RemotePeer')?NINF('DisplayName','RemotePeer') . ' ':''},\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},\q{NINF('DLOG.RemoteTag')}]},


## 2006.2.8 sawada ##
## 2997.7.18 inoue ##
 {'TY:'=>'ENCODE', 'ID:'=>'E.BYE.FROM_LOCAL-URI_LOCAL-TAG.WITH-ESCAPED-CHAR','PT:'=>'HD', 'NX:'=>'Route',
  'FM:'=>'From: %s<%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},\q{encconv("LocalAoRURI", "LocalPeer")},\q{NINF('DLOG.LocalTag')}]},
#  'FM:'=>'From: %s<%s:U%%6512@under.test.com>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},\q{NINF('DLOG.LocalTag')}]},

# {'TY:'=>'ENCODE', 'ID:'=>'E.BYE.FROM_LOCAL-URI_LOCAL-TAG.WITH-ESCAPED-CHAR','PT:'=>'HD', 'NX:'=>'Route',
#  'FM:'=>'From: %s<sip:U%%6512@under.test.com>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},\q{NINF('DLOG.LocalTag')}]},


# PX-1-16-31 INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.WITH-ESCAPED-CHAR.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI.WITH-ESCAPED-CHAR',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.WITH-ESCAPED-CHAR',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

 # %% TO:08 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_REMOTE-URI.WITH-ESCAPED-CHAR', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt',encconv("RemoteAoRURI", "LocalPeer"), @_)}},   ## 2006.2.8 sawada ##
#   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt',(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':U%6512@under.test.com',@_)}},   ## 2006.2.8 sawada ##
#   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt','sip:U%6512@under.test.com',@_)}}, 

 # %% TO:08 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LOCAL-URI.WITH-ESCAPED-CHAR', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt', encconv("LocalAoRURI", "LocalPeer"), @_)}},   ## 2006.2.8 sawada ##
#   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt',(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':U%6512@under.test.com',@_)}},   ## 2006.2.8 sawada ##
#   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt','sip:U%6512@under.test.com',@_)}}, 

 # %% TO:08 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LOCAL-URI.REGISTER.WITH-ESCAPED-CHAR', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt',encconv("LocalAoRURI","LocalPeer"), @_)}},
   ## 2006.2.8 sawada ##
#   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt',(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':U%6511@under.test.com',@_)}},   ## 2006.2.8 sawada ##
#   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt','sip:U%6511@under.test.com',@_)}}, 


 # %% R-URI:01 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REMOTE-CONTACT-URI.WITH-ESCAPED-CHAR', 'CA:' => 'Request',
   'OK:' => \\'Request-URI(%s) MUST equal remote target CONTACT URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'Request-URI(%s) MUST equal remote target CONTACT URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('RQ.Request-Line.uri',@_), encconv("RemoteAoRURI", "LocalPeer"), @_)} },  ## 2007.7.18 inoue ##
#   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('RQ.Request-Line.uri',@_),(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':U%6512@under.test.com',@_)} },  ## 2006.2.8 sawada ##
#   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('RQ.Request-Line.uri',@_),'sip:U%6512@under.test.com',@_)} },


 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_REMOTE-URI.WITH-ESCAPED-CHAR', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad.ad.txt',@_), encconv("RemoteAoRURI", "LocalPeer"), @_)} },  ## 2007.7.18 inoue ##
#   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad.ad.txt',@_),(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':U%6512@under.test.com',@_)} },  ## 2006.2.8 sawada ##
#   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad.ad.txt',@_),'sip:U%6512@under.test.com',@_)} },

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BYE-200.FROM-URI_LOCAL-URI.WITH-ESCAPED-CHAR', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad.ad.txt',@_), encconv("LocalAoRURI", "LocalPeer"), @_)} },
#   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad.ad.txt',@_),(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':U%6512@under.test.com',@_)} },
#   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad.ad.txt',@_),'sip:U%6512@under.test.com',@_)} },


 # %% PX-1-16-31 01 %%	UA receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-407.WITH-ESCAPED-CHAR.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
#              'SSet.STATUS.INVITE-4XX.WITH-ESCAPED-CHAR.NOPX',
#              'SSet.ResMesg',
              'SSet.ALLMesg',
              'S.FROM-URI_LOCAL-URI',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_REMOTE-URI.WITH-ESCAPED-CHAR',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.DIGEST-AUTH_CHALLENGE.PX',
              'S.PORT-SIGNAL_DEFAULTS',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.RE-ROUTE_NOEXIST',
              'S.CSEQ-METHOD_INVITE',
              'S.TO-TAG_EXIST',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.WITH-ESCAPED-CHAR.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI.WITH-ESCAPED-CHAR',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.WITH-ESCAPED-CHAR',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},


 # %% PX-1-1-2 03 %%	UA1 receives receives 100 Trying
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-100.WITH-ESCAPED-CHAR.TM', 
   'RR:' => [
              ### SSet.STATUS.INVITE-100.NOPX 
#              'SSet.STATUS.INVITE-100.NOPX', 
#              'SSet.ResMesg',
             'SSet.ALLMesg',
             'S.FROM-URI_LOCAL-URI',
             'S.FROM-TAG_LOCAL-TAG',
             'S.TO-URI_REMOTE-URI.WITH-ESCAPED-CHAR',
             'S.CALLID_VALID',
             'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

# PX-2-16-70_71_72
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOHOPS.CALEE_STRICT','PT:'=>'HD', 
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\q{Cutlr()}]},

# PX-2-16-70_71_72
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.180.PX.CALEE_STRICT', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_TWOHOPS.CALEE_STRICT',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.PX.CALEE_STRICT', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
        'E.RECORDROUTE_TWOHOPS.CALEE_STRICT',	
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',       
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

#  CSEQ NUM=LOCAL-NUM Method=REGISTER
 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ_NUM_REGISTER.DECREMENT','PT:'=>'HD',
  'FM:'=>'CSeq: %s REGISTER','AR:'=>[\q{NINFW('DLOG.LocalCSeqNum','1')}]},

# REGISTER request for RG-1-2-4
###070717 inoue
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.DELREG.NO-INCREMENT-CSEQ.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
#	'E.CSEQ_NUM_REGISTER.NO-INCREMENT',
#	'E.CSEQ_NUM_REGISTER.DECREMENT',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_ASTERISK',
#	'E.EXPIRES_ZERO',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

## 2006.2.3 sawada add  #####
# REGISTER request with Contact: *, Expires: 3600 
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.DELREG.NO-INCREMENT-CSEQ.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
#	'E.CSEQ_NUM_REGISTER.NO-INCREMENT',
#	'E.CSEQ_NUM_REGISTER.DECREMENT',
        'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_ASTERISK',
#	'E.EXPIRES_ZERO',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER Request for RG-1-2-4 with Auth (Contact:*, Contact:<sip:UA111@node.under.test.com>, Expires: 0)

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.DELREG.ERR-2CONTACT.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_ASTERISK',
	'E.CONTACT_URI_RG124',
	'E.EXPIRES_ZERO',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER Request for RG-1-2-4 without Auth (Contact:*, Contact:<sip:UA111@node.under.test.com>, Expires: 0)

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.DELREG.ERR-2CONTACT.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_ASTERISK',
	'E.CONTACT_URI_RG124',
	'E.EXPIRES_ZERO',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},




 # %% RG-1-1-1 01 %%	UA1 receives 401 Unauthorized from Registrar
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-420.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'S.TAG-PRIORITY',
              'S.VIA_EXIST',
              'S.VIA-BRANCH_z9hG4bK',
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.FROM_EXIST',
              'S.FROM_QUOTE',
              'S.TO_EXIST',
              'S.TO_QUOTE',
              'S.CALLID_EXIST',
              'S.CSEQ_EXIST',
              'S.CSEQ-SEQNO_32BIT',
              'S.CNTLENGTH_NOBODY_0',
              'S.FROM-URI_LOCAL-URI',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_REGISTER',
              'S.TO-TAG_EXIST',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
              'S.UNSUPPORTED_EXIST',
              'S.UNSUPPORTED_999REL', 
            ]

 }, 

 # %% Unsupported %% Unsupported
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.UNSUPPORTED_999REL', 'CA:' => 'Unsupported',
   'OK:' => \\'The Unsupported header field must be \"999rel\".', 
   'NG:' => \\'The Unsupported header field must be \"999rel\", but this packet contains \"%s\".', 
   'PR:' => \q{FFIsExistHeader("Unsupported",@_)},
   'EX:' => \q{FFop('EQ',FV('HD.Unsupported.txt',@_),'999rel',@_)}},


 # %% CALLID:01 %%	Unsupported
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.UNSUPPORTED_EXIST', 'CA:' => 'Unsupported',
   'OK:' => "A Unsupported header field MUST exist.",
   'NG:' => "A Unsupported header field MUST exist.",
   'EX:' =>\'FFIsExistHeader("Unsupported",@_)'},


#  603 Decline
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-603','PT:'=>RQ,
  'FM:'=>'SIP/2.0 603 Decline',},


 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-603-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-603',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

 # %% PX-1-16-105_106_108_109.seq 01 %%	UA receives 5XX Response
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-6XX.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 

 # %% PX-3-1-5 01 %%	UA receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-480.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 

#  ACK Request-URI=CONTACT (After dialog)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_CONTACT-URI-BASIC','PT:'=>RQ,
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[\'$CNT_TUA_CONTACT_URI']},


# using PX-UA-4-1-5
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-200.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.ACK_CONTACT-URI-BASIC',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS', # 20050111
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

#  BYE Request-URI=CONTACT(BASIC) PX-UA-4-1-5
 {'TY:'=>'ENCODE', 'ID:'=>'E.BYE_CONTACT-URI-BASIC','PT:'=>RQ,
  'FM:'=>'BYE %s SIP/2.0','AR:'=>[\'$CNT_TUA_CONTACT_URI']},


# BYE TWOPX PX-UA-4-1-5
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.BASIC.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI-BASIC',
	'E.VIA_NOHOP',# 
	'E.MAXFORWARDS_NOHOP',# 
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_TUA-URI_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.408-RETURN.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-408',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

# %% RECORD-ROUTE:nn %%	Record-Route with lr parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RECORD-ROUTE.EXIST-lr-PARAM', 'CA:' => 'Record-Route',
   'OK:' => \\'The Record-Route header fields MUST include lr parameter.', 
   'NG:' => \\'The Record-Route header fields MUST include lr parameter.', 
   'PR:' => \q{FFIsExistHeader("Record-Route",@_)},
   'EX:' => sub {
       my ($rule,$pktinfo,$context)=@_;
       my ($lrParam);
       $lrParam = FV('HD.Record-Route.val.route.ad.ad.param.lr-param',@_);
#       printf("lrParam=%s",$lrParam);
       return ($lrParam);
   }
},		

# %% RECORD-ROUTE:nn %%	Route with lr parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE.EXIST-lr-PARAM', 'CA:' => 'Route',
   'OK:' => \\'The Route header fields MUST include lr parameter.', 
   'NG:' => \\'The Route header fields MUST include lr parameter.', 
   'EX:' => sub {
       my ($rule,$pktinfo,$context)=@_;
       my ($lrParam);
       $lrParam = PV(FV('HD.Route.val.route.ad.ad.param.lr-param',@_));
#       printf("lrParam=%s",$lrParam);
       return ($lrParam);
   }
},		

# %% RECORD-ROUTE:nn %%	Record-Route with transport parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RECORD-ROUTE.EXIST-transport-PARAM', 'CA:' => 'Record-Route',
   'OK:' => \\'The Record-Route header fields MUST not include transport parameter.', 
   'NG:' => \\'The Record-Route header fields MUST not include transport parameter.', 
   'PR:' => \q{FFIsExistHeader('Record-Route',@_)},
   'EX:' => sub {
       my ($rule,$pktinfo,$context)=@_;
       my ($transportParam);
       $transportParam = FV('HD.Record-Route.val.route.ad.ad.param.transport-param',@_);
#       printf("transportParam=%s",$transportParam);
       return ($transportParam eq '');
   }
},		

# Header Order PX-1-1-1, PX-2-1-[12] 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.HEADER-ORDER.CHECK','CA:' => 'Header',
   'OK:' => 'Valid header alignment sequence.',
   'NG:' => 'SHOULD keep the header alignment sequence.',
   'RT:' => "warning", 
   'EX:' => \q{HeaderOrder(@_[1], NDPKT(@_[1]), ["Record-Route","Route","Proxy-Authorization","Max-Forwards","Privacy","P-Asserted-Identity","P-Preferred-Identity"])},
 },

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO-RETURN-LOCAL_TAG.UA22','PT:'=>HD, 'NX:'=>'From',
  'FM:'=>'To: %s',
  'AR:'=>[sub {
            my($msg, $val);
	    $msg = FV('HD.To.val.ad.txt',@_) . ";tag=" . "r98765";
            return $msg;
          }] },

## 2006.2.8 sawada ##
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI.UA22','PT:'=>'HD', 'NX:'=>'CSeq',
  'FM:'=>'Contact: <%s:UA22@client2.biloxi.example.com>',
  'AR:'=> [\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"}]},

# {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI.UA22','PT:'=>'HD', 'NX:'=>'CSeq',
#  'FM:'=>'Contact: <sip:UA22@client2.biloxi.example.com>'},

 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ-RETURN.UA22','PT:'=>HD, 'NX:'=>'Call-ID', 
  'FM:'=>'CSeq: %s',
  'AR:'=>[\q{FV('HD.CSeq.txt','','NDFIRST')}]},

## 2006.2.8 sawada ##
#  ACK Request-URI=CONTACT (After dialog)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_CONTACT-URI.UA22','PT:'=>RQ,
  'FM:'=>'ACK %s:UA22@client2.biloxi.example.com SIP/2.0',
  'AR:'=> [\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"}]},

#  ACK Request-URI=CONTACT (After dialog)
# {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_CONTACT-URI.UA22','PT:'=>RQ,
#  'FM:'=>'ACK sip:UA22@client2.biloxi.example.com SIP/2.0'},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.TM.UA22', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.ACK_CONTACT-URI.UA22',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS', # 20050111
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.PX.UA22', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEHOP.UA22',
	'E.MAXFORWARDS_ONEHOP',
        'E.ROUTE_ONEURI',
        'E.RECORDROUTE_ONEHOP', # 20050304 add tadokoro	# 20050420 usako delete
#	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.FROM_LOCAL-URI_LOCAL-TAG.UA22',# 
	'E.TO_REMOTE-URI_REMOTE-TAG',# 

	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_ONEHOP.UA22','PT:'=>'HD', 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ my($via,$tag,@vias);$CVA_COUNT_BRANCH++; ## 2006.2.9 sawada ##
#  'AR:'=>[sub{ my($via,$tag,@vias);$CVA_COUNT_BRANCH++;

               SetupViaParam($CVA_COUNT_BRANCH);

	       @vias= (NDCFG('uri.hostname','PX2') . ':' . NDCFG('port','PX2') . ";branch=$CVA_PX1_BRANCH_HISTORY",
#		       $CNT_ONEPX_SEND_VIAS[0], 
		       'client2.biloxi.example.com' . 
		       ':' . NDCFG('port','UA21') . 
		       ";branch=$CVA_PUA_BRANCH_HISTORY" . 
		       (!IsIPAddress(NDCFG('contact.hostname','UA21')) ? ';received=' . NDCFG('address','UA21'): '')) ;

#	       PrintVal(\@vias);
	       return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@vias);} ]},

# 20040929 kenzo
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG.UA22','PT:'=>'HD', 
  'FM:'=>'From: %s<%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
				       \q{NINF('LocalAoRURI','LocalPeer')},'r98765']},


 # %% PX-UA-11-1-4 06 %%	Proxy receives ACK for 200 OK(forwarded).
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.200-ACK_FORWARDED.PX.UA22', 
    'RR:' => [
               'SSet.ALLMesg',
               'S.VIA-URI_HOSTNAME',
               'S.VIA-TRANSPORT_UDP',
               'S.R-URI_NOQUOTE',
               'S.R-LINE_VERSION',
               'S.MAX-FORWARDS_EXIST',
               'S.MAX-FORWARDS_DECREMENT',
               'S.FROM-TAG_EXIST',
               'S.CSEQ-METHOD_REQLINE-METHOD',
               'S.MUSTNOT-HEADER_ACK',
			   'S.RFC3261-8-82_Require',
			   'S.RFC3261-8-82_Proxy-Require',
               'S.FROM-URI_REMOTE-URI',
               'S.FROM-TAG_REMOTE-TAG',
               'S.TO-URI_LOCAL-URI',
               'S.CALLID_VALID',
               'S.CSEQ-METHOD_ACK',
               'S.CSEQ-SEQNO_REQ-SEQNO',
               'S.BODY_NOEXIST',
               'SSet.ACK-2xx.UA22',
               'S.P-AUTH_NOTEXIST',
               'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
               'S.TO-TAG_EXIST',
               'S.TO-TAG_LOCAL-TAG.UA22',
               'S.ROUTE_EXIST',
               'S.ROUTE_PSEUDO_PROXY_URI',
               'S.BODY_ACK-ANSWER_EXIST',
               'SS.FORWARD_REQUEST_COMPARE',
               'SS.FORWARD_HEADERS',
               'S.R-URI_ORIGINAL-R-URI',
	       'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
	       'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
            ]
 }, 

# PX-UA-11-1-4
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_LOCAL-TAG.UA22', 'CA:' => 'To',
   'OK:' => \\'The To-tag(%s) MUST equal the local tag(%s).', 
   'NG:' => \\'The To-tag(%s) MUST equal the local tag(%s).', 
   'EX:' =>\q{FFop('EQ',FV('HD.To.val.param.tag',@_),'r98765',@_)}},


 # %% ACK-2xx %%	ACK(2xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK-2xx.UA22', 
   'RR:' => [
              'S.R-URI_REQ-CONTACT-URI.UA22',
           ]
 }, 

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REQ-CONTACT-URI.UA22', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST equal that(%s) of Contact of corresponding dialog.', 
   'NG:' => \\'The Request-URI(%s) MUST equal that(%s) of Contact of corresponding dialog.', 
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',(($SIP_PL_TRNS eq "TLS")?"sips":"sip").':UA22@client2.biloxi.example.com',@_)}},   ## 2006.2.8 sawada ##
#   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt','sip:UA22@client2.biloxi.example.com',@_)}}, 


 # %% PX-UA-11-1-4
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.BYE-200_FORWARDED.PX.UA22', 
   'RR:' => [
             'SSet.ResMesg',
	     'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
	     'S.VIA-RECEIVED_EXIST_PX',
	     'S.VIA_ONEPX_SEND_EQUAL.UA22',
	     'S.TO-TAG_EXIST',
	     'S.CSEQ-METHOD_BYE',
             'SS.FORWARD_RESPONSE_COMPARE',
             'S.VIA_REMOVE-TOPMOST',
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # PX-UA-11-1-4
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_LOCAL-TAG.UA22', 'CA:' => 'From',
   'OK:' => \\'The From-tag(%s) MUST equal the local tag(%s).', 
   'NG:' => \\'The From-tag(%s) MUST equal the local tag(%s).', 
   'EX:' =>\q{FFop('EQ',FV('HD.From.val.param.tag',@_),'r98765',@_)}},

# PX-UA-11-1-4
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_ONEPX_SEND_EQUAL.UA22', 'CA:' => 'Via',
   'OK:' => \\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).', 
   'NG:' => \\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).', 
   'EX:' => \q{OpViaMachLines(\@CNT_ONEPX_SEND_VIAS,2,@_)} }, 


# BYE TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.TM.ANOTHER-CALLID', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_NOHOP',# 
	'E.MAXFORWARDS_NOHOP',# 
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_TUA-URI_REMOTE-TAG',# 
	'E.CALLID_CVA.ANOTHER',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

#  CALLID $CVA_CALLID
 {'TY:'=>'ENCODE', 'ID:'=>'E.CALLID_CVA.ANOTHER','PT:'=>HD, 'NX:'=>'To',
  'FM:'=>'Call-ID: LMjiweinxonYxwbqp@under.test.com'},

 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-481-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-481',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

# RQ-3-1-2
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-481-RETURN_RQ-3-1-2.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-481',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


# BYE TWOPX
# RQ-3-1-2
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.TM.WITHOUT-FROM-tag', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_NOHOP',# 
	'E.MAXFORWARDS_NOHOP',# 
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_NO-TAG',# 
	'E.TO_TUA-URI_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# BYE TWOPX
# RQ-3-1-2
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.TM.WITHOUT-TO-tag', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_NOHOP',# 
	'E.MAXFORWARDS_NOHOP',# 
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_REMOTE-URI_NO-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# NOPORT Via header setup
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_ONEHOP_NOPORT','PT:'=>'HD', 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CNT_VIA_INIT_SEED=$CVA_COUNT_BRANCH;  ## 2006.2.9 ##
#  'AR:'=>[sub{ $CNT_VIA_INIT_SEED=$CVA_COUNT_BRANCH++;
	my(@tmp);
    	@tmp= (
	NDCFG('uri.hostname','UA12')	.
sprintf(";branch=z9hG4bKPUA%s%s", $$, $CNT_VIA_INIT_SEED));
#	NDCFG('contact.hostname','UA12') .
#sprintf(";branch=z9hG4bKPUA%s%s", $$, $CNT_VIA_INIT_SEED).  (!IsIPAddress(NDCFG('contact.hostname','UA12')) ? #';received=' . NDCFG('address','UA12'): '')) ;
#PrintVal(\@tmp);
#exit;
        SetupViaParam($CVA_COUNT_BRANCH);
	return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@tmp);} ]},



# NOPORT Via header setup
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOHOP_NOPORT','PT:'=>'HD', 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CNT_VIA_INIT_SEED=$CVA_COUNT_BRANCH;  ## 2006.2.9 sawada ##
#  'AR:'=>[sub{ $CNT_VIA_INIT_SEED=$CVA_COUNT_BRANCH++;
	my(@tmp);

    	@tmp= (
	NDCFG('contact.hostname','UA11') . sprintf(";branch=z9hG4bKPUA%s%s", $$, $CNT_VIA_INIT_SEED));
#PrintVal(\@tmp);
#exit;
        SetupViaParam($CVA_COUNT_BRANCH);
	return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@tmp);} ]},

# NOPORT Via header setup
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOHOP_NOPORT_ACK-NO200','PT:'=>'HD', 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CNT_VIA_INIT_SEED;  ## 2006.2.9 sawada ##
#  'AR:'=>[sub{ $CNT_VIA_INIT_SEED;
	my(@tmp);

    	@tmp= (
	NDCFG('contact.hostname','UA11') . sprintf(";branch=z9hG4bKPONE%s%s", $$, $CNT_VIA_INIT_SEED));
#PrintVal(\@tmp);
#exit;
	return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@tmp);} ]},


 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.ONEPX.INVALID-VIA.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED.INVALID',
        'E.RECORDROUTE_TWOHOPS',	#
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',	#
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_RETURN_RECEIVED.INVALID','PT:'=>'HD',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
	       $vias=FVs('HD.Via.txt',@_);
               $hed=shift(@$vias);
               $host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
               if ($str =~ /^\[(\S+)$\]/) { $str = $1; }
                if(!IsIPAddress($str)){ 
                    $hed = 'Via:' . substr($hed,0,index($hed,FV('HD.Via.val.via.sendby.host',@_))) . 'invalid.under.test.com' . substr($hed,index($hed,":")) . ';received=' . NINF('IPaddr','PX1');}
               else{ $hed = 'Via:' . $hed;}
	       map{$hed .= "\r\n" . 'Via:' . $_ } @$vias;
               return $hed;}]},

# INVITE request(with SDP, Max-Forwards 0, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.NOEXIST-ENTITY.AUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
#	'E.INVITE_AOR-URI',
	'E.INVITE_AOR-NOEXIST-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.NOEXIST-ENTITY.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
#	'E.ACK_AOR-URI',
	'E.ACK_AOR-NOEXIST-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_AOR-NOEXIST-URI','PT:'=>RQ,
  'FM:'=>'ACK %sNotExist%s SIP/2.0','AR:'=>[\q{substr(NINF('LocalAoRURI','RemotePeer'),0,4)},\q{substr(NINF('LocalAoRURI','RemotePeer'),8)}]},


# REGISTER request different between R-URI and From,To
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.FROM-TO-DIFFER.AUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_DIFFERENT-URI_LOCAL-TAG',
	'E.TO_RG-DIFFERENT-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.WITH-ASTERISK.AUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_ASTERISK',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.WITH-ASTERISK.WITH-CONTACT-URI.AUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_ASTERISK',
	'E.CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

 # UA receives 4xx for BYE
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.BYE-4XX-RETURN.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.RE-ROUTE_NOEXIST',
              'S.CSEQ-METHOD_BYE',
              'S.TO-TAG_EXIST',
              'D.COMMON.FIELD.STATUS',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 


# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REGISTER.VIA-IP.TEST', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP_IP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# NOPORT Via header setup
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOHOP_IP','PT:'=>'HD', 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CNT_VIA_INIT_SEED=$CVA_COUNT_BRANCH++;  ## 2006.2.9 sawada ##
#  'AR:'=>[sub{ $CNT_VIA_INIT_SEED=$CVA_COUNT_BRANCH++;
	my(@tmp);

    	@tmp= (
	NDCFG('contact.hostname','UA11') . sprintf(";branch=z9hG4bKPONE%s%s", $$, $CNT_VIA_INIT_SEED));
#PrintVal(\@tmp);
#exit;
	return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@tmp);} ]},


# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.withNEWHEADER.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.NEWHEADER', 
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request with Authorization
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.withNEWHEADER.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.NEWHEADER', 
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

 # %% RG-1-1-1 01 %%	UA1 receives 401 Unauthorized from Registrar
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-401.withNEWHEADER.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'S.TAG-PRIORITY',
              'S.VIA_EXIST',
              'S.VIA-BRANCH_z9hG4bK',
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.FROM_EXIST',
              'S.FROM_QUOTE',
              'S.TO_EXIST',
              'S.TO_QUOTE',
              'S.CALLID_EXIST',
              'S.CSEQ_EXIST',
              'S.CSEQ-SEQNO_32BIT',
              'S.CNTLENGTH_NOBODY_0',
              'S.FROM-URI_LOCAL-URI',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_REGISTER',
              'S.TO-TAG_EXIST',
              'S.WWW-AUTH_EXIST.PX',
              'S.WWW-AUTH_DIGEST',
              'S.WWW-AUTH_NONCE.EXIST',
              'S.WWW-AUTH_REALM.EXIST',
              'S.WWW-AUTH_QOP.AUTH',
              'S.WWW-AUTH-ALGORITHM.MD5',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	      'S.NEWHEADER_EXIST', 
            ]

 }, 

 # %% RG-1-1-1 02 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.withNEWHEADER.TM', 
   'RR:' => [
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',  ## 2006.7.28 sawada del ##
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	      'S.NEWHEADER_EXIST', 
            ]
 }, 



### 20051205 kenzo add start ###
 # for invite-request (override)
 {'TY:'=>'ENCODE', 'ID:'=>'E.REQUIRE_VALID', 'PT:'=>'HD',
  'FM:'=> 'Require: 999rel',
 },
### kenzo add end ###

### 20051206 kenzo add start ###
 {'TY:'=>'ENCODE', 'ID:'=>'E.PROXY-REQUIRE_100REL', 'PT:'=>'HD',
  'FM:'=> 'Proxy-Require: 100rel',
 },
### kenzo add end ###

# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.REQUIRE_VALID.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.REQUIRE_VALID', 
	'E.CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# REGISTER request with Authorization
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.REQUIRE_VALID.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.REQUIRE_VALID', 
	'E.CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# CANCEL send by TM
 {'TY:'=>'RULESET', 'ID:'=>'ES.CANCEL.PROXY-REQUIRE.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
        'E.CANCEL_TUA-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_CANCEL',
        'E.PROXY-REQUIRE_100REL',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# BYE TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.TWOPX.STRICT-ROUTING.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI.fromSTRICT-ROUTER',
	'E.VIA_ONEHOP',# 
	'E.MAXFORWARDS_ONEHOP',
        'E.ROUTE_STRICT',
	'E.RECORDROUTE_ONEHOP_STRICT-R', # Miz
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_TUA-URI_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

#  BYE Request-URI=Target(PX1)'s address
 {'TY:'=>'ENCODE', 'ID:'=>'E.BYE_CONTACT-URI.fromSTRICT-ROUTER','PT:'=>RQ,
  'FM:'=>'BYE %s SIP/2.0','AR:'=>[NDCFG('uri','PX1')]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_STRICT','PT:'=>'HD', 
  'PR:'=>\'FFIsExistHeader("Record-Route",@_,STATUS)',
  'FM:'=>'Route: <%s>',
  'AR:'=>[NDCFG('contact-uri','UA11')]},


 # %% R-URI:06 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_toSTRICT-ROUTER', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST equal that(%s) of Contact of corresponding dialog.', 
   'NG:' => \\'The Request-URI(%s) MUST equal that(%s) of Contact of corresponding dialog.', 
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',NDCFG('uri','PX2'),@_)}}, 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_toSTRICT-ROUTER', 'CA:' => 'Route',
   'OK:' => \\'Route header field(%s) MUST equal %s .', 
   'NG:' => \\'Route header field(%s) MUST equal %s .', 
   'PR:' =>\q{FFIsExistHeader("Route",@_,'INVITE')},
   'EX:' =>\q{FFop('eq',FV('HD.Route.val.route.ad.ad.txt',@_),NDCFG('contact-uri','UA21'),@_)}},


 # %% PX-1-1-2 07 %%	UA1 receives BYE(forwarded).
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.BYE_FORWARDED.STRICT-ROUTER.TM', 
    'RR:' => [
               ### SSet.BYE.NOPX 
               #'SSet.BYE.NOPX',
               'SSet.ALLMesg',
               'S.R-URI_NOQUOTE',
               'S.R-URI_toSTRICT-ROUTER',
               'S.R-LINE_VERSION',
               'S.VIA-URI_HOSTNAME',
               'S.VIA-TRANSPORT_UDP',
               'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
               'S.MAX-FORWARDS_EXIST',
               'S.MAX-FORWARDS_DECREMENT',
               'S.ROUTE_toSTRICT-ROUTER',
               'S.ROUTE_EXIST',
               'S.FROM-URI_REMOTE-URI',
               'S.FROM-TAG_EXIST',
               'S.FROM-TAG_REMOTE-TAG',
               'S.TO-URI_LOCAL-URI',
               'S.TO-TAG_EXIST',
               'S.TO-TAG_LOCAL-TAG',
               'S.CALLID_VALID',
               'S.CSEQ-METHOD_REQLINE-METHOD',
               'S.CSEQ-METHOD_BYE',
               'S.CSEQ-SEQNO_ORIGINAL-SEQNO',
               'S.MUSTNOT-HEADER_BYE',
               'SS.FORWARD_REQUEST_COMPARE',
               'SS.FORWARD_HEADERS_FROM_PX',
               'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
               'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
	       'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
	       'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
            ]
 }, 

 # REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.withTWOCONTACT.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI',
	'E.SECOND-CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

## 2006.2.8 sawada ##
 {'TY:'=>'ENCODE', 'ID:'=>'E.SECOND-CONTACT_URI','PT:'=>'HD', 
  'FM:'=>'Contact: <%s:11%s>;expires=1800','AR:'=>[\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},\q{substr(NINF('LocalContactURI','LocalPeer'),4)}]},

#{'TY:'=>'ENCODE', 'ID:'=>'E.SECOND-CONTACT_URI','PT:'=>'HD', 
#  'FM:'=>'Contact: <sip:11%s>;expires=1800','AR:'=>[\q{substr(NINF('LocalContactURI','LocalPeer'),4)}]},

 # REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.withTWOCONTACT.withAUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI',
	'E.SECOND-CONTACT_URI',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

 # %% RG-1-1-7 
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.withTWOCONTACT.compEXPIRES.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT_EXIST',
  	      'S.FIRST-CONTACT-URI_REGISTER-FIRST-CONTACT-URI',
  	      'S.SECOND-CONTACT-URI_REGISTER-SECOND-CONTACT-URI',
  	      'S.FIRST-CONTACT-PARAMETER_REGISTER-EXPIRES-HEADER',
  	      'S.SECOND-CONTACT-PARAMETER_REGISTER-SECOND-CONTACT-PARAMETER',
  	      'S.FIRST-CONTACT-URIPARAMETER_REGISTER-EXPIRES-HEADER',
  	      'S.SECOND-CONTACT-URIPARAMETER_REGISTER-SECOND-CONTACT-PARAMETER',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',
            ]
 }, 

 # %% Contact:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FIRST-CONTACT-URI_REGISTER-FIRST-CONTACT-URI', 'CA:' => 'Contact',
   'OK:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
   'NG:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
#   'EX:' => \q{FFop('eq',Cutexpires(FVs('HD.Contact.val.contact.ad.ad.txt',@_)->[0]),FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[0],@_)}},  ## 2006.7.27 sawada del ##
#   'EX:' => \q{FFop('eq',Cutexpires(FVs('HD.Contact.val.contact.ad.ad.txt',@_)->[0]),FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[0],@_)|FFop('eq',Cutexpires(FVs('HD.Contact.val.contact.ad.ad.txt',@_)->[0]),FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[1],@_) }},  ## 2006.7.27 sawada add ##
   'EX:' => sub {
		my($rule, $pktinfo, $context) = @_;
		my($RCPE1, $LCPE1, $LCPE2);
		$RCPE1 = Cutexpires(FVs('HD.Contact.val.contact.ad.ad.txt',@_)->[0]);
		$LCPE1 = FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[0];
		$LCPE2 = FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[1];

		if ($RCPE1 eq $LCPE1) {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE1};
			return $RCPE1 eq $LCPE1;
		}

		if ($RCPE1 eq $LCPE2) {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE2};
			return $RCPE1 eq $LCPE2;
		}
		else {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE1};
			return $RCPE1 eq $LCPE2;
		}	
	}
},

 # %% Contact:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SECOND-CONTACT-URI_REGISTER-SECOND-CONTACT-URI', 'CA:' => 'Contact',
   'OK:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
   'NG:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
#   'EX:' => \q{FFop('eq',Cutexpires(FVs('HD.Contact.val.contact.ad.ad.txt',@_)->[1]),FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[1],@_)}},  ## 2006.7.27 sawada del ##
#   'EX:' => \q{FFop('eq',Cutexpires(FVs('HD.Contact.val.contact.ad.ad.txt',@_)->[1]),FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[1],@_)|FFop('eq',Cutexpires(FVs('HD.Contact.val.contact.ad.ad.txt',@_)->[1]),FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[0],@_)}},  ## 2006.7.27 sawada add ##

   'EX:' => sub {
		my($rule, $pktinfo, $context) = @_;
		my($RCPE1, $LCPE1, $LCPE2);
		$RCPE1 = Cutexpires(FVs('HD.Contact.val.contact.ad.ad.txt',@_)->[1]);
		$LCPE1 = FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[0];
		$LCPE2 = FVib('send','','','HD.Contact.val.contact.ad.ad.txt','RQ.Request-Line.method','REGISTER')->[1];

		if ($RCPE1 eq $LCPE1) {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE1};
			return $RCPE1 eq $LCPE1;
		}

		if ($RCPE1 eq $LCPE2) {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE2};
			return $RCPE1 eq $LCPE2;
		}
		else {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE1};
			return $RCPE1 eq $LCPE2;
		}	
	}
},



 # %% Contact parameter %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FIRST-CONTACT-PARAMETER_REGISTER-EXPIRES-HEADER', 'CA:' => 'Contact',
   'OK:' => \\'The Contact expires parameter(%s) in the Contact field MUST equal sending REGISTER Expires header field value(%s) of the Tester.',
   'NG:' => \\'The Contact expires parameter(%s) in the Contact field MUST equal sending REGISTER Expires header field value(%s) of the Tester.',
   'PR:'=>\q{FVs('HD.Contact.val.contact.param.expires=',@_)->[0] ne ''},
#   'EX:' => \q{FFop('eq',FVs('HD.Contact.val.contact.param.expires=',@_)->[0],FVib('send','','','HD.Expires.val.seconds','RQ.Request-Line.method','REGISTER'),@_)}},  ## 2006.7.27 sawada del ##
#   'EX:' => \q{FFop('eq',FVs('HD.Contact.val.contact.param.expires=',@_)->[0],FVib('send','','','HD.Expires.val.seconds','RQ.Request-Line.method','REGISTER'),@_)|FFop('eq',FVs('HD.Contact.val.contact.param.expires=',@_)->[0],FVib('send','','','HD.Contact.val.contact.param.expires=','RQ.Request-Line.method','REGISTER'),@_)}},  ## 2007.7.27 sawada add ##

   'EX:' => sub {
		my($rule, $pktinfo, $context) = @_;
		my($RCPE1, $LCPE1, $LCPE2);
		$RCPE1 = Cutexpires(FVs('HD.Contact.val.contact.param.expires=',@_)->[0]);
		$LCPE1 = FVib('send','','','HD.Expires.val.seconds','RQ.Request-Line.method','REGISTER');
		$LCPE2 = FVib('send','','','HD.Contact.val.contact.param.expires=','RQ.Request-Line.method','REGISTER');

		if ($RCPE1 eq $LCPE1) {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE1};
			return $RCPE1 eq $LCPE1;
		}

		if ($RCPE1 eq $LCPE2) {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE2};
			return $RCPE1 eq $LCPE2;
		}
		else {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE1};
			return $RCPE1 eq $LCPE2;
		}	
	}
},



 # %% Contact parameter %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SECOND-CONTACT-PARAMETER_REGISTER-SECOND-CONTACT-PARAMETER', 'CA:' => 'Contact',
   'OK:' => \\'The Contact expires parameter(%s) in the Contact field MUST equal sending REGISTER-expires parameter in the Contact header field(%s) of the Tester.',
   'NG:' => \\'The Contact expires parameter(%s) in the Contact field MUST equal sending REGISTER-expires parameter in the Contact header field(%s) of the Tester.',
   'PR:'=>\q{FVs('HD.Contact.val.contact.param.expires=',@_)->[1] ne ''},
#   'EX:' => \q{FFop('eq',FVs('HD.Contact.val.contact.param.expires=',@_)->[1],FVib('send','','','HD.Contact.val.contact.param.expires=','RQ.Request-Line.method','REGISTER'),@_)}},  ## 2007.7.27 sawada del ##
#   'EX:' => \q{FFop('eq',FVs('HD.Contact.val.contact.param.expires=',@_)->[1],FVib('send','','','HD.Contact.val.contact.param.expires=','RQ.Request-Line.method','REGISTER'),@_)|FFop('eq',FVs('HD.Contact.val.contact.param.expires=',@_)->[1],FVib('send','','','HD.Expires.val.seconds','RQ.Request-Line.method','REGISTER'),@_)}},  ## 2007.7.27 sawada add ##

   'EX:' => sub {
		my($rule, $pktinfo, $context) = @_;
		my($RCPE1, $LCPE1, $LCPE2);
		$RCPE1 = Cutexpires(FVs('HD.Contact.val.contact.param.expires=',@_)->[1]);
		$LCPE1 = FVib('send','','','HD.Expires.val.seconds','RQ.Request-Line.method','REGISTER');
		$LCPE2 = FVib('send','','','HD.Contact.val.contact.param.expires=','RQ.Request-Line.method','REGISTER');

		if ($RCPE1 eq $LCPE1) {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE1};
			return $RCPE1 eq $LCPE1;
		}

		if ($RCPE1 eq $LCPE2) {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE2};
			return $RCPE1 eq $LCPE2;
		}
		else {
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<=>',
			'ARG1:'=>$RCPE1,
			'ARG2:'=>$LCPE1};
			return $RCPE1 eq $LCPE2;
		}	
	}
},


 # %% Contact parameter %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FIRST-CONTACT-URIPARAMETER_REGISTER-EXPIRES-HEADER', 'CA:' => 'Contact',
   'OK:' => \\'The Contact expires parameter(%s) in the Contact field MUST equal sending REGISTER Expires header field value of the Tester.',
   'NG:' => \\'The Contact expires parameter(%s) in the Contact field MUST equal sending REGISTER Expires header field value of the Tester.',
   'PR:'=>\q{FVs('HD.Contact.val.contact.ad.ad.param.other-param',@_)->[0] ne ''},
   'EX:' => \q{FFIsMatchStr(FVib('send','','','HD.Expires.val.seconds','RQ.Request-Line.method','REGISTER'),FVs('HD.Contact.val.contact.ad.ad.param.other-param',@_)->[0],'','',@_)}},

 # %% Contact parameter %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SECOND-CONTACT-URIPARAMETER_REGISTER-SECOND-CONTACT-PARAMETER', 'CA:' => 'Contact',
   'OK:' => \\'The Contact expires parameter(%s) in the Contact field MUST equal sending REGISTER-expires parameter in the Contact header field of the Tester.',
   'NG:' => \\'The Contact expires parameter(%s) in the Contact field MUST equal sending REGISTER-expires parameter in the Contact header field of the Tester.',
   'PR:'=>\q{FVs('HD.Contact.val.contact.ad.ad.param.other-param',@_)->[1] ne ''},
   'EX:' => \q{FFIsMatchStr(FVib('send','','','HD.Contact.val.contact.param.expires=','RQ.Request-Line.method','REGISTER'),FVs('HD.Contact.val.contact.ad.ad.param.other-param',@_)->[1],'','',@_)}},


# REGISTER request with different Contact header parameter last REGISTER
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.withDiffCONTACT.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.DiffCONTACT_URI_REGISTER', ## 2006.2.1 sawada add transport parameter header field ## 
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# REGISTER request with different Contact header parameter last REGISTER
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.withDiffCONTACT.withAUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.DiffCONTACT_URI_REGISTER',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# Different Contact header field value
 {'TY:'=>'ENCODE', 'ID:'=>'E.DiffCONTACT_URI_REGISTER','PT:'=>'HD',
  'FM:'=>'Contact: <%s:11%s@%s;transport=%s>','AR:'=>[\q{CutSip(NDCFG('contact-uri','UA11'))},\q{CutUsername(NDCFG('contact-uri','UA11'))},\q{CutHostname(NDCFG('contact-uri','UA11'))},"\L$SIP_PL_TRNS\E"]},

# REGISTER request with Authorization and two Contact header fields
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.THIRD-REGISTER.withTWOCONTACT.withAUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_REGISTER',
	'E.DiffCONTACT_URI_REGISTER',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# REGISTER request with two Contact header fields
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.THIRD-REGISTER.withTWOCONTACT.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_REGISTER',
	'E.DiffCONTACT_URI_REGISTER',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

 # %% RG-2-2-3
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.withTWOCONTACT.TM', 
   'RR:' => [
              'SS.STATUS.REGISTER-BASIC',
              'S.TWO-CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',
            ]
 }, 

 # %% Contact:nn %% Contact
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TWO-CONTACT_EXIST', 'CA:' => 'Contact',
   'OK:' => \\'MUST have two Contact header.',
   'NG:' => \\'MUST have two Contact header',
   'EX:' => sub{ my(@two_contact);
		 @two_contact = FVib('recv','','','HD.Contact.val.contact.ad.ad.txt','RQ.Status-Line.code','200');
#		 PrintVal(scalar(@two_contact));
#		 exit;
		 if(scalar(@two_contact) == 1){
		     return 1;
		 }else{
		     return 0;
		     }
	     }
},

 # %% RG-1-1-1 02 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-500.TWO-CONTACT.TM', 
   'RR:' => [
              'SS.STATUS.REGISTER-BASIC',
              'S.TWO-CONTACT_EXIST',
#              'S.CONTACT-URI_REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',
            ]
 }, 


);

sub CutSip {
    local($str) = @_;
    @cut1 = split(/@/,$str);
    @cut2 = split(/\:/,$cut1[0]);
    return $cut2[0];
}

sub CutSipRRIP {
    local($str) = @_;
    @cut2 = split(/(sip\:|\;lr)/,$str);
    return $cut2[2];
}

sub Cut184 {
    local($str) = @_;
#    $cut1 = CutSip($str);  ## 2006.7.28 sawada del ##
#    @cut2 = split(/\:/,$str);
##    print("1111%s\n",substr($cut2[1],0,3));
##    exit;
#    if (substr($cut2[1],0,3) == 184 || substr($cut2[1],0,3) == 186){
##	print("2222%s\n",$cut2[1]);
##	exit;
#	$cut3 = substr($cut2[1],3);
#    }
#    else{
#	$cut3 = $cut2[1];
#    }
#    return $cut1.":".$cut3; ####
    $str=~s/(sips?:)18[46]/$1/;  ## 2006.7.28 sawada add ##
    return $str;  ####
}


sub CutHostname {
    local($str) = @_;
    @cut = split(/@/,$str);
    return $cut[1];
}



sub CutUsername{
    local($str) = @_;
    @cut1 = split(/@/,$str);
    @cut2 = split(/\:/,$cut1[0]);
    return $cut2[1];
}

sub Cuttransport {
#    my($str)=@_;
#    my $data,@cut,@datas;
#    if ($str =~ /transport/){			## 2005.1.25 sawada delete transport header field ##
#	@cut = split(/\;transport=/,$str);	##
#	push(@datas,$cut[0]);			###
#	return \@datas;				##
#    }						##
#}

    my($str)=@_;
    my $data,@cut,@datas;
    if (ref($str) eq 'ARRAY'){
	foreach $data (@$str){
	    printf("data = $data\n");
	    if($data =~ /transport/){
		@cut = split(/\;transport/,$data);
		push(@datas,$cut[0]);
	    }
	    else{
		push(@datas,$data);
	    }
	}
	return \@datas;
    }
    else{
	if($str =~ /transport/){
	    @cut = split(/\;transport/,$str);
	    return $cut[0];
	}
	else {
	    $cut = $str;
	    return $cut;
	}
    }
}


sub Cutexpires {
    my($str)=@_;
    my $data,@cut,@datas;
    if (ref($str) eq 'ARRAY'){
	foreach $data (@$str){
	    printf("data = $data\n");
	    if($data =~ /expires/){
		@cut = split(/\;expires/,$data);
		push(@datas,$cut[0]);
	    }
	    else{
		push(@datas,$data);
	    }
	}
	return \@datas;
    }
    else{
	if($str =~ /expires/){
	    @cut = split(/\;expires/,$str);
	    return $cut[0];
	}
	else {
	    $cut = $str;
	    return $cut;
	}
    }
}


sub Cutexpires_param {
    my($str)=@_;
    my $data,@cut,@datas;
    @cut = split(/expires\=/,$str);
    return $cut[1];
}


sub Cutlr {
    my($routeset,@msg,$i);
    $routeset = NINF('DLOG.RouteSet#A');
    for $i(0..$#$routeset){
	if($i eq 0){
	    $routeset->[$i] =~ /^(.*?);lr$/ ;
	    push(@msg,$1);
	}else{
	    push(@msg,$routeset->[$i]);
	}
    }
    return join(">,<",@msg);
}

sub CheckNo100 { 
    my($method) = @_;
    my($index);

    $index=FVif('send','','','','RQ.Request-Line.method',$method);
    return FVifc('recv',$index,'','RQ.Status-Line.code','100') <= 0;
}

sub HeaderOrder {
    my($pkt1,$pkt2,$rmheader) = @_;
    my($item1,$item2,@header1,@header2,$beforeitem1,$beforeitem2,@align);
    my($count) = 1;
    my($i,$j,$k,$j_memory,$l);
    
    $pkt1=$pkt1->{'header'};
    $pkt2=$pkt2->{'header'};
    #
    foreach $item1 (@$pkt1){	
	if($item1->{'tag'} ne $beforeitem1){
	    if( !grep{$_ eq $item1->{'tag'}}(@$rmheader) ){
		push(@header1,$item1->{'tag'});
		$beforeitem1 = $item1->{'tag'};
	    }
	}
    }
    #
    foreach $item2 (@$pkt2){
	if($item2->{'tag'} ne $beforeitem2){
	    if( !grep{$_ eq $item2->{'tag'}}(@$rmheader) ){
		push(@header2,$item2->{'tag'});
		$beforeitem2 = $item2->{'tag'};
	    }
	}
    }
#    PrintVal(\@header1); #
#    PrintVal(\@header2); #

    $j_memory = 0; # 
    # 
    for $i (0..$#header2){
	if($j_memory != 0){
	    $k = $j_memory;
	}
	else{
	    $k = $i;
	}
	for $j ($k..$#header1){
	    # 
	    if($header2[$i] eq $header1[$j]){
		$j_memory = $j;
		push(@align,$j);
		last;
	    }
	    # 
	    if($j == $#header1){
		for $j (0..$k){
		    if($header2[$i] eq $header1[$j]){
			$j_memory = $j;
			push(@align,$j);
			last;
		    }
		    # 
		    if($j == $k){
#			printf("Nothing header\n");
#			exit;
			return 0;
		    }
		}
	    }
	}
    }
    # @align
    for $l (0..$#align){
	if ($l+1 <= $#align){
	    if($align[$l+1] <= $align[$l]){
#		printf("Invalid alignment\n");
#		exit;
		return 0;
	    }
	}
    }
    # 
 #   printf("return 1\n");
 #   exit;
    return 1;
}


1



