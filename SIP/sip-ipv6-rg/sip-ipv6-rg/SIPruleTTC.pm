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
@SIPPXRulesTTC =
(

  # %% 
  # %% JJ-90.25 No.3 
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.R-URIwithPARAMETER.TM', 'MD:'=>'SEQ', 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URIwithPARAMETER', # TTC
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
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


  # %% 
  # %% JJ-90.25 No.3 
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.ONEPX.R-URI-PARAMETER.TM','SP:'=>'TTC',
    'RR:' => [
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
	      'S.R-URI-METHOD_NOT-EXIST',  # TTC
	      'S.R-URI-SUBJECT_NOT-EXIST', # TTC
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              'S.FROM-URI_REMOTE-URI',
              'S.TO-URI_LOCAL-URI',
              'S.CONTACT-URI_REMOTE-CONTACT-URI',
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CSEQ-METHOD_INVITE',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              'S.BODY_EXIST',
              'SSet.SDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'SS.FORWARD_REQUEST_COMPARE',
              'S.VIA_INSERT-NEWVIA-LINE',
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',
             'S.R-URI_REMOTE-CONTACT-URI',
             'S.RECORD-ROUTE_ADD-PROXY-URI',
             'S.PORT-SIGNAL_DEFAULTS',
	      'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },

  # %% 
  # %% JJ-90.25 No.3 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI-METHOD_NOT-EXIST', 'CA:' => 'Request','SP:'=>'TTC',
   'OK:' => "The method parameter of Request-URI MUST NOT exist.",
   'NG:' => "The method parameter of Request-URI MUST NOT exist.",
   'EX:' => \q{!FV('RQ.Request-Line.uri.ad.param.method-param',@_)}},

  # %% 
  # %% JJ-90.25 No.3 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI-SUBJECT_NOT-EXIST', 'CA:' => 'Request','SP:'=>'TTC',
   'OK:' => 'The Subject parameter (header parameter) of Request-URI MUST NOT exist.',
   'NG:' => \\'The Subject(%s) parameter (header parameter) of Request-URI MUST NOT exist.',
   'EX:' => \q{!FFIsMatchStr('Subject\s*=',\\\'RQ.Request-Line.uri.ad.header','','T',@_)}}, 

# SIPruleIG.pm
# JJ-90.25 No.6 - No.8
#$CNT_IG_MSG_MAX = 1300;
#$CNT_IG_BODY_MAX = 1000;
#$CNT_IG_REQUEST_MAX = 256;
#$CNT_IG_HEADER_MAX = 256;
#$CNT_IG_URI_MAX = 128;




### from SIPruleIGTTC.pm ###



 # %% INVITE %%	INVITE
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.INVITE', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ReqMesg',
              'SSet.URICompMsg',
              'S.R-URI_TO-URI',
              'S.RE-ROUTE_NOEXIST',   ##ADD for TTC(watanabe)
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CSEQ-METHOD_INVITE',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
              'S.REQUIRE_NOEXIST-200',  ##ADD for TTC(watanabe)
              'S.ALLOW_EXIST_MUST',
              'S.BODY_EXIST',  ##ADD for IG
              'SSet.SDP',
              'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 }, 

 # %% CANCEL %%	CACNCEL
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.CANCEL', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_CANCEL',
              'S.R-URI_REQ-R-URI',
              'S.VIA_REQ-SINGULAR',
              'S.VIA_REQ-1STVIA',
              'S.VIA-BRANCH_REQ-VIA-BRANCH',
              'S.ROUTE_NOEXIST',   ##ADD for TTC(watanabe)
              'S.RE-ROUTE_NOEXIST',   ##ADD for TTC(watanabe)
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-METHOD_CANCEL',
              'S.CSEQ-SEQNO_REQ-SEQNO',
              'S.REQUIRE_NOEXIST',
              'S.P-REQUIRE_NOEXIST',
              'S.BODY_NOEXIST',  ##ADD for IG
              'SS.CANCEL.NOEXIST_TTC',
           ]
 }, 

 # %% Basic3-8-1 01 %%	Proxy receives CANCEL.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.200-CANCEL.PX', 'SP:'=>'TTC',
   'RR:' => [
              'SSet.CANCEL',
#              'S.ROUTE_EXIST',
#              'S.ROUTE_VALID',  # DEL for TTC
            ]
 }, 

 # %% BYE %%	BYE
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.BYE', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_BYE',
              'S.R-URI_REQ-CONTACT-URI',
              'S.RE-ROUTE_NOEXIST',  ##ADD for TTC(watanabe)
              'S.CSEQ-METHOD_BYE',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
              'S.CNTTYPE_NOEXIST',  ##ADD for TTC(watanabe)
              'S.BODY_NOEXIST',  ##ADD for IG
              'SS.BYE.NOEXIST_TTC',
            ]
 }, 

#  CNTTYPE_NOEXIST(ADD by watanabe)
 {'TY:'=>'SYNTAX', 'ID:'=>'S.CNTTYPE_NOEXIST', 'CA:'=>'Content-Type','SP:'=>'TTC',
  'OK:'=>"A Content-Type header MUST NOT exist.",
  'NG:'=>"A Content-Type header MUST NOT exist.",
  'EX:'=>\'!FFIsExistHeader("Content-Type",@_)'},

#  ALLOW_EXIST(MOD by watanabe)
 {'TY:'=>'SYNTAX', 'ID:'=>'S.ALLOW_EXIST_MUST', 'CA:'=>'Allow','SP:'=>'TTC',
  'OK:'=>"An Allow header MUST exist.",
  'NG:'=>"An Allow header MUST exist.",
  'EX:'=>\'FFIsExistHeader("Allow",@_)'},


 # %% CNTTYPE:01 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CNTTYPE_VALID-NULL', 'CA:' => 'Content-Type','SP:'=>'TTC',
   'OK:' => "A Content-Type header field MUST NOT exist if the body is empty.", 
   'NG:' => "A Content-Type header field MUST NOT exist if the body is empty.", 
   'PR:'=>\q{0 == length(FV('BD.txt',@_))},
   'EX:' =>\q{!(FFIsExistHeader("Content-Type",@_))}},

 # %% Require:09 %% Check just the Existance of Require header. (CHO)
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE_NOEXIST-200', 'CA:' => 'REQUIRE','SP:'=>'TTC',
   'OK:' => " The Require header MUST NOT exist.",
   'NG:' => " The Require header MUST NOT exist.", 
   'EX:' => \q{!FFIsExistHeader("Require",@_ ) }},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RSEQ_NOEXIST', 'CA:' => 'RSEQ','SP:'=>'TTC',
   'OK:' => " The RSeq header MUST NOT exist.",
   'NG:' => " The RSeq header MUST NOT exist.", 
   'EX:' => \q{!FFIsExistHeader("RSeq",@_ ) }},


#  SSet.REQUEST_INVITE.PX(MOD by watanabe)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.INVITE.PX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.INVITE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_NOEXIST',
              'S.ROUTE_NOEXIST',  ##ADD for TTC(watanabe)
              'D.COMMON.FIELD.REQUEST'
            ]
 }, 

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.INVwithP-AUTH.PX','SP:' => 'TTC', 
   'RR:' => [
              'SSet.INVITE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST', 
              'S.TO-TAG_NOEXIST',
              'S.CALLID_VALID_SHOULD',
              'S.P-AUTH_EXIST.PX',
              'SSet.DigestAuth.PX',
              'S.P-AUTH-URI_R-URI',
              'S.ROUTE_NOEXIST',  ##ADD for TTC(watanabe)
              'D.COMMON.FIELD.REQUEST',
            ]
 }, 

 # %% ACK %%	ACK
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK', 'SP:'=>'TTC',
   'RR:' => [
              'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_ACK',
	      'S.RFC3261-8-82_Require',
	      'S.RFC3261-8-82_Proxy-Require',
              'S.FROM-URI_REMOTE-URI', 
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-METHOD_ACK',
	      'S.CSEQ-SEQNO_REQ-SEQNO',
              'SS.ACK.NOEXIST_TTC',
           ]
 }, 


#  SSet.REQUEST.non2xx-ACK(MOD by watanabe)
  { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.non2xx-ACK', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ACK',
              'SSet.ACK-Non2xx',
              'S.VIA-BRANCH_REQ-VIA-BRANCH',
              'S.TO-TAG_LOCAL-TAG',
              'S.ROUTE_NOEXIST',   ##ADD for TTC(watanabe)
            ]
 }, 

 # %% Basic3-2-2 02 %%	Proxy receives 200 OK. #Mod By CHO
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE.PX', 'SP:' => 'TTC', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
              'S.CONTACT_EXIST',
              'S.CONTACT_QUOTE',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST_MUST',
              'S.BODY_EXIST',
              'SSet.SDP-ANS',
              'S.CSEQ-METHOD_INVITE',
              'S.RE-ROUTE_EXIST',
              'S.RE-ROUTE_ROUTESET_REVERSE.TWOPX',
	      'S.CNTTYPE_VALID-NULL',
              'S.REQUIRE_NOEXIST-200',      ## FOR TTC.(CHO)
              'D.COMMON.FIELD.STATUS'
            ]
 }, 

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE.NOPX', 'SP:' => 'TTC', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
              'S.CONTACT_EXIST',
              'S.CONTACT_QUOTE',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST_MUST',     ## Mizusawa
              'S.RE-ROUTE_NOEXIST',
              'S.BODY_EXIST',
              'SSet.SDP-ANS',
              'S.CSEQ-METHOD_INVITE',
	      'S.CNTTYPE_VALID-NULL',     ## Mizusawa
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Basic - -  0? %%	Proxy receives 200 OK. ## MOD by Cho
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.BYE-200.PX', 'SP:' => 'TTC',
   'RR:' => [
             'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
              'S.CSEQ-METHOD_BYE',
              'S.CNTTYPE_NOEXIST',   ## FOR TTC. (CHO)
              'S.RE-ROUTE_NOEXIST',  ## FOR TTC. (CHO)
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
              'S.MESSAGEBODY_NOEXIST_TTC',
              'SS.BYE-RES.NOEXIST_TTC',
            ]
 }, 

# UA1 receives 100 Trying.(no proxy)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-100.NOPX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
	      'S.CNTTYPE_VALID-NULL', ## Mizusawa
              'S.RSEQ_NOEXIST',
            ]
 }, 

## Proxy receives 100 Trying.(two proxies)     ## MOD by Cho
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-100.PX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.CSEQ-METHOD_INVITE',
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
	      'S.CNTTYPE_VALID-NULL', ## Mizusawa
              'S.RSEQ_NOEXIST',
            ]
 }, 

# Proxy receives 100 Trying.(one proxy)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-100.ONEPX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
	      'S.CNTTYPE_VALID-NULL', ## Mizusawa
              'S.RSEQ_NOEXIST',
            ]
 }, 

 # %% Basic3-1-2 01 %%	UA1 receives 180 Ringing.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-180.NOPX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
            ]
 }, 

 # %% Basic3-2-2 01 %%	Proxy receives 180 Ringing.     ## MOD by Cho
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-180.PX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.RE-ROUTE_EXIST',             # Mizusawa
              'S.RE-ROUTE_ROUTESET_REVERSE.TWOPX',    # Mizusawa
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
	      'S.CNTTYPE_VALID-NULL', ## Mizusawa
              'S.RSEQ_NOEXIST',
            ]
 }, 

 # %% Basic3-12-2 01 %%	Proxy receives 180 Ringing.(one proxy)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-180.ONEPX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.RE-ROUTE_EXIST',             # Mizusawa
              'S.RE-ROUTE_ROUTESET.ONEPX',    # Mizusawa
              'S.CSEQ-METHOD_INVITE',
              'S.TO-TAG_EXIST',
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
	      'S.CNTTYPE_VALID-NULL', ## Mizusawa
              'S.RSEQ_NOEXIST',
            ]
 }, 

 # %% Proxy receives 4XX Status.     ## MOD by Cho
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-4XX.PX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX', 
              'S.VIA-RECEIVED_EXIST_PX', 
              'S.VIA_TWOPX_SEND_EQUALS.VI',
##DELSIPit              'S.RE-ROUTE_NOEXIST',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
              'S.CNTTYPE_NOEXIST',		## FOR TTC(CHO)
              'S.REQUIRE_NOEXIST-200',		## FOR TTC(CHO)
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Pattern3-26-2 03 %%	UA2 receives 4xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-4XX.NOPX', 'SP:'=>'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.RE-ROUTE_NOEXIST',
              'S.CSEQ-METHOD_INVITE',
              'S.TO-TAG_EXIST',
              'S.CNTTYPE_NOEXIST',		## FOR TTC(CHO)
              'S.REQUIRE_NOEXIST-200',		## FOR TTC(CHO)
              'D.COMMON.FIELD.STATUS',
            ]
 }, 


 # %% Basic - -  0? %%	UA2 receives 200 OK.     ## MOD by Cho
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.RE-INVITE-200.PX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
 	      'S.CSEQ-METHOD_INVITE',
              'S.CONTACT_EXIST',
              'S.CONTACT_QUOTE',
              'S.BODY_EXIST',
              'S.REQUIRE_NOEXIST-200',		## FOR TTC(CHO)
              'S.RE-ROUTE_NOEXIST',		## FOR TTC(CHO)
              'SSet.SDP-ANS',
              'S.ALLOW_EXIST_MUST',   ## FOR TTC.(CHO)
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Basic3-8-2 01 %%	Proxy receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.CANCEL-200.PX', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX-CANCEL',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS-CANCEL.VI',
              'S.TO-TAG_RECENT1xx-TO-TAG',
              'S.CSEQ-METHOD_CANCEL',
              'S.RE-ROUTE_NOEXIST',          ## FOR TTC(CHO)
              'S.PRIVACY_NOEXIST_TTC',
            ]
 }, 


### end  SIPruleIGTTC.pm ###


### from SIPrulePX.pm(SIPuni) ###

 #=================================
 # 
 #=================================
 {'TY:'=>'DECODE', 'ID:'=>'D.WWW-Authenticate.NONCE', 'SP:'=>'TTC',
  'VA:'=>[('HD.WWW-Authenticate.val.digest.nonce', CNT_AUTH_NONCE)]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Proxy-Authenticate.NONCE','SP:'=>'TTC',
  'VA:'=>[('HD.Proxy-Authenticate.val.digest.nonce', CNT_AUTH_NONCE)]},

### 20050118 
 {'TY:'=>'DECODE', 'ID:'=>'D.Proxy-Authenticate.REALM', 'SP:'=>'TTC',
  'VA:'=>[('HD.Proxy-Authenticate.val.digest.realm', CNT_AUTH_REALM)]},

 {'TY:'=>'DECODE', 'ID:'=>'D.WWW-Authenticate.OPAQUE', 'SP:'=>'TTC',
  'VA:'=>[('HD.WWW-Authenticate.val.digest.opaque', CNT_AUTH_OPAQUE)]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Proxy-Authenticate.OPAQUE','SP:'=>'TTC',
  'VA:'=>[('HD.Proxy-Authenticate.val.digest.opaque', CNT_AUTH_OPAQUE)]},

 {'TY:'=>'DECODE', 'ID:'=>'D.FROM-TAG_STATUS','SP:'=>'TTC',
  'VA:'=>[(\q{FV('HD.From.val.param.tag',@_)}, CVA_LOCAL_TAG)]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Record-Route.TWOPX-0', 'MD:'=>'set','SP:'=>'TTC',
  'VA:'=>[(\q{FV('HD.Record-Route.val.route.ad.ad.txt',@_)}, '@CNT_PUA_TWOPX_ROUTESET[0]')]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Record-Route.TWOPX-1', 'MD:'=>'set','SP:'=>'TTC',
  'VA:'=>[(\q{FV('HD.Record-Route.val.route.ad.ad.txt',@_)}, '@CNT_PUA_TWOPX_ROUTESET[1]')]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Record-Route.TWOPX', 'MD:'=>'array','SP:'=>'TTC',
  'VA:'=>[(\q{[@{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)}]}, CNT_PUA_TWOPX_ROUTESET)]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Record-Route.TWOPX-Reverse', 'MD:'=>'array','SP:'=>'TTC',
  'VA:'=>[(\q{[reverse(@{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)})]}, CNT_PUA_TWOPX_ROUTESET)]},

 #=================================
 # 
 #=================================
 
# Dialog Setup Case 1 TM/PX receives 200 
 { 'TY:' => 'RULESET', 'ID:' => 'D.200.SET_DIALOG', 'MD:'=>SEQ,'SP:'=>'TTC',
   'RR:' => ['D.TO-URI_STATUS','D.TO-TAG','D.FROM-URI_STATUS','D.FROM-TAG_STATUS','D.Record-Route.TWOPX-Reverse']
 }, 
	
# Dialog Setup Case 2 TM receives Initial Invite
 { 'TY:' => 'RULESET', 'ID:' => 'D.INVITE.SET_DIALOG.TM', 'MD:'=>SEQ,'SP:'=>'TTC',
   'RR:' => ['D.FROM-URI','D.FROM-TAG','D.TO-URI','D.Record-Route.TWOPX']
 }, 

# Dialog Setup Case 3 PX received Initial Invite
 { 'TY:' => 'RULESET', 'ID:' => 'D.INVITE.SET_DIALOG.PX', 'MD:'=>SEQ,'SP:'=>'TTC',
   'RR:' => ['D.FROM-URI','D.FROM-TAG','D.TO-URI','D.Record-Route.TWOPX-1']
 }, 


#=================================
 # 
 #=================================

####### 
####### 20050209 tadokoro
 # %% TO:01 %%
 ##	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_START186', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) of the To header MUST start \"sip(s):186\".', 
   'NG:' => \\'The URI(%s) of the To header MUST start \"sip(s):186\".', 
   'EX:' => \q{FFIsMatchStr('^sips?:186\d+@', \\\'HD.To.val.ad.ad.txt','','',@_)}},

 # %% TO:02 %%
 ##	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_START184', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) of the To header MUST start \"sip(s):184\".', 
   'NG:' => \\'The URI(%s) of the To header MUST start \"sip(s):184\".', 
   'EX:' => \q{FFIsMatchStr('^sips?:184\d+@', \\\'HD.To.val.ad.ad.txt','','',@_)}},
   
 # %% TO:03 %%
 ##	To
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-DISPLAYNAME_ANONYMOUS', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The Display name(%s) in the To field MUST equal \"Anonymous\".', 
   'NG:' => \\'The Display name(%s) in the To field MUST equal \"Anonymous\".', 
   'EX:' => \q{FFop('EQ',FV('HD.To.val.ad.disp',@_),'anonymous',@_),}}, 
   
 # %% TO:04 %%
 ##	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_ANONYMOUS', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) in the To field MUST be the anonymous URI(that is, equal to \"sip:anonymous\@anonymous.invalid\").', 
   'NG:' => \\'The URI(%s) in the To field MUST be the anonymous URI(that is, equal to \"sip:anonymous\@anonymous.invalid\").', 
   'EX:' => \q{FFop('eq',FV('HD.To.val.ad.ad.txt',@_),'sip:anonymous@anonymous.invalid',@_),}}, 

 # %% FROM:nn %%
 ##	From
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-DISPLAYNAME_ANONYMOUS', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The Display name(%s) in the From field MUST equal \"Anonymous\".', 
   'NG:' => \\'The Display name(%s) in the From field MUST equal \"Anonymous\".', 
#   'EX:' => \q{FFop('EQ',FV('HD.From.val.ad.disp',@_),'anonymous',@_),}},  ## 2006.7.27 sawada del ##
   'EX:' => sub {  ## 2006.7.27 sawada add ##
           my($Disp,$Disp2);
           $Disp=FV('HD.From.val.ad.disp',@_);
           $Disp=~s/\"//g;
           FFIsMatchStr('anonymous',$Disp,'','CaseSensitivityOff',@_); 
   }}, ####
   
 # %% FROM:nn %%
 ##	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_ANONYMOUS', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) in the From field MUST be the anonymous URI(that is, equal to \"sip:anonymous\@anonymous.invalid\").', 
   'NG:' => \\'The URI(%s) in the From field MUST be the anonymous URI(that is, equal to \"sip:anonymous\@anonymous.invalid\").', 
   'EX:' => \q{FFop('eq',FV('HD.From.val.ad.ad.txt',@_),'sip:anonymous@anonymous.invalid',@_)}}, 

 # %% FROM:nn %%
 ## From
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-DISPLAYNAME_EXIST', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The Display name(%s) in the From header MUST exist.', 
   'NG:' => \\'The Display name(%s) in the From header MUST exist.', 
   'EX:' => \q{FFop('ne',FV('HD.From.val.ad.disp',@_),'',@_),}}, 


 # %% FROM:nn %%
 ## From
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-USERINFO_EXIST', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) of the From header MUST have userinfo.', 
   'NG:' => \\'The URI(%s) of the From header MUST have userinfo.', 
   'EX:' => \q{FFIsMatchStr('^sips?:.+@.+', \\\'HD.From.val.ad.ad.txt','','',@_)}},
		
 # %% R-URI:nn %%
 ##	userinfo
 ## userinfo
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_USERINFO_0ABJ_E164', 'CA:' => 'Request','SP:'=>'TTC',
   'OK:' => 'A "userinfo" component in Request-URI MUST be transfered from "0AB-J" to "+81AB-J".', 
   'NG:' => 'A "userinfo" component in Request-URI MUST be transfered from "0AB-J" to "+81AB-J".', 
   'EX:' => \q{FFIsMatchStr('^\+81[1-9]',\\\'RQ.Request-Line.uri.ad.userinfo','','',@_)}},
		
		
 # %% R-URI:nn %%
 ##	userinfo
 ## 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_USERINFO_1860ABJ_E164', 'CA:' => 'Request','SP:'=>'TTC',
   'OK:' => 'A "userinfo" component in Request-URI MUST be transfered from "1860AB-J" to "+81AB-J".', 
   'NG:' => 'A "userinfo" component in Request-URI MUST be transfered from "1860AB-J" to "+81AB-J".', 
   'EX:' => \q{FFIsMatchStr('^\+81[1-9]',\\\'RQ.Request-Line.uri.ad.userinfo','','',@_)}},   
   
   
 # %% R-URI:nn %%
 ##	userinfo
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_USERINFO_1840ABJ_E164', 'CA:' => 'Request','SP:'=>'TTC',
   'OK:' => 'A "userinfo" component in Request-URI MUST be transfered from "1840AB-J" to "+81AB-J".', 
   'NG:' => 'A "userinfo" component in Request-URI MUST be transfered from "1840AB-J" to "+81AB-J".', 
   'EX:' => \q{FFIsMatchStr('^\+81[1-9]',\\\'RQ.Request-Line.uri.ad.userinfo','','',@_)}},
   
 # %% Privacy:01 %%
 ##	Privacy
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PRIVACY_EXIST', 'CA:' => 'Privacy','SP:' => 'TTC',
   'OK:' => 'A Privacy header field MUST exist in this message.', 
   'NG:' => 'A Privacy header field MUST exist in this message.', 
   'EX:' => \q{FFIsExistHeader('Privacy',@_)} },


 # %% Privacy:02 %%
 ##	Privacy
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PRIVACY_VALUE_NONE', 'CA:' => 'Privacy','SP:' => 'TTC',
   'OK:' => \\'A Privacy header field(%s) MUST have the value \"none\"', 
   'NG:' => \\'A Privacy header field(%s) MUST have the value \"none\"', 
   'EX:' => \q{FFop('eq' , FV('HD.Privacy.txt',@_ ), 'none',@_)} },
   
   
 # %% Privacy:03 %%
 ##	Privacy
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PRIVACY_VALUE_ID', 'CA:' => 'Privacy','SP:' => 'TTC',
   'OK:' => \\'A Privacy header field(%s) MUST have the value \"id\"', 
   'NG:' => \\'A Privacy header field(%s) MUST have the value \"id\"', 
   'EX:' => \q{FFop('eq' , FV('HD.Privacy.txt',@_ ), 'id',@_)} },

   
 # %% P-Preffered-Identity:01 %%
 ##	P-Preferred-Identity
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-PREF-ID_NOEXIST', 'CA:' => 'P-Preferred-Identity','SP:' => 'TTC',
   'OK:' => 'A P-Preferred-Identity header field MUST NOT exist in this message.', 
   'NG:' => 'A P-Preferred-Identity header field MUST NOT exist in this message.', 
   'EX:' => \q{!FFIsExistHeader("P-Preferred-Identity",@_)} },


 # %% P-Preferred-Identity:02 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-PREF-ID_REMOVED', 'CA:' => 'P-Preferred-Identity','SP:' => 'TTC',
   'OK:' => \\'P-Preferred-Identity header MUST be removed by the proxy server.', 
   'NG:' => \\'P-Preferred-Identity header MUST be removed by the proxy server.', 
   'PR:' => \q{FFIsExistHeader("P-Preferred-Identity",'',NDPKT(@_[1]))},
   'EX:' => \q{!FFIsExistHeader("P-Preferred-Identity",@_)}}, 


 # %% P-Preferred-Identity:03 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-PREF-ID_NOGENERATE', 'CA:' => 'P-Preferred-Identity','SP:' => 'TTC',
   'OK:' => \\'P-Preferred-Identity header MUST NOT be generated by the proxy server.', 
   'NG:' => \\'P-Preferred-Identity header MUST NOT be generated by the proxy server.', 
   'PR:' => \q{!FFIsExistHeader("P-Preferred-Identity",'',NDPKT(@_[1]))},
   'EX:' => \q{!FFIsExistHeader("P-Preferred-Identity",@_)}}, 

		
 # %% P-Asserted-Identity:01 %%
 ##	P-Asserted-Identity
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ID_EXIST', 'CA:' => 'P-Asserted-Identity','SP:' => 'TTC',
   'OK:' => 'A P-Asserted-Identity header field MUST exist in this message.', 
   'NG:' => 'A P-Asserted-Identity header field MUST exist in this message.', 
   'EX:' => \q{FFIsExistHeader("P-Asserted-Identity",@_)} },

   
 # %% P-Asserted-Identity:02 %%
 ##	P-Asserted-Identity
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ID_NOEXIST', 'CA:' => 'P-Asserted-Identity','SP:' => 'TTC',
   'OK:' => 'A P-Asserted-Identity header field MUST NOT exist in this message.', 
   'NG:' => 'A P-Asserted-Identity header field MUST NOT exist in this message.', 
   'EX:' => \q{!FFIsExistHeader("P-Asserted-Identity",@_)} },

   
 # %% P-Asserted-Identity:03 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ORIGINAL_PREF', 'CA:' => 'P-Asserted-Identity','SP:' => 'TTC',
   'OK:' => \\'A P-Asserted-Identity header field(%s) MUST equal P-Preferred-Identity header field(%s) in the original message.', 
   'NG:' => \\'A P-Asserted-Identity header field(%s) MUST equal P-Preferred-Identity header field(%s) in the original message.', 
   'PR:' => \q{FFIsExistHeader("P-Preferred-Identity",'',NDPKT(@_[1]))}, 
   'EX:' => \q{FFop('eq', 
	   		join(',', sort { $a cmp $b } @{FVs('HD.P-Asserted-Identity.val.txt',@_)} ),
	   		join(',', sort { $a cmp $b } @{FVs('HD.P-Preferred-Identity.val.txt','',NDPKT(@_[1]))} ),
	   		@_)}
   },
   		
 # %% P-Asserted-Identity:04 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ORIGINAL_ASSERT', 'CA:' => 'P-Asserted-Identity','SP:' => 'TTC',
   'OK:' => \\'A P-Asserted-Identity header field(%s) MUST equal P-Asserted-Identity header field(%s) in the original message.', 
   'NG:' => \\'A P-Asserted-Identity header field(%s) MUST equal P-Asserted-Identity header field(%s) in the original message.', 
   'PR:' => \q{FFIsExistHeader("P-Asserted-Identity",'',NDPKT(@_[1]))}, 
   'EX:' => \q{FFop('eq', 
	   		join(',', sort { $a cmp $b } @{FVs('HD.P-Asserted-Identity.val.txt',@_)} ),
	   		join(',', sort { $a cmp $b } @{FVs('HD.P-Asserted-Identity.val.txt','',NDPKT(@_[1]))} ),
	   		@_)}
   },
   		
 # %% P-Asserted-Identity:05 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ID_REMOVED', 'CA:' => 'P-Asserted-Identity','SP:' => 'TTC',
   'OK:' => \\'P-Asserted-Identity header MUST be removed by the proxy server.', 
   'NG:' => \\'P-Asserted-Identity header MUST be removed by the proxy server.',
   'PR:' => \q{FFIsExistHeader("P-Asserted-Identity",'',NDPKT(@_[1]))},
   'EX:' => \q{!FFIsExistHeader("P-Asserted-Identity",@_)}}, 
  
		
 # %% P-Asserted-Identity:06 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ID_GENERATE', 'CA:' => 'P-Asserted-Identity','SP:' => 'TTC',
   'OK:' => \\'P-Asserted-Identity header fields(%s) MUST generate by proxy server.', 
   'NG:' => \\'P-Asserted-Identity header fields(%s) MUST generate by proxy server.', 
   'PR:' => \q{!FFIsExistHeader("P-Asserted-Identity",'',NDPKT(@_[1]))},
   'EX:' => sub {
				my($rule,$pktinfo,$context)=@_;
				my $asserted = join(', ', sort { $a cmp $b } @{FVs('HD.P-Asserted-Identity.val.txt',@_)});
				FV('HD.Contact.val.contact.ad.ad.txt',@_) =~ m/^(sips?:)(\d+)@/;
				my @string = ($2, $1.$2, $2, $2);
				my $hostname = ($CNT_PX2_HOSTNAME)?($CNT_PX2_HOSTNAME):($CNT_PX1_HOSTNAME);  
				$string[0] = 'Anonymous' if (FV('HD.From.val.ad.ad.txt',@_) =~ m/^sips?:anonymous@/);
				$string[0] = 'Anonymous' if (FV('HD.To.val.ad.ad.txt',@_) =~ m/^sips?:184\d+@/);	
				$string[1] = $string[1] . '@' . $hostname;  
				$string[3] =~ s/^0/tel:+81/;
				my $value = join(', ', sort { $a cmp $b } ("$string[0] <$string[1]>","$string[2] <$string[3]>"));
			   		
		   		$context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<=>',
		   			'ARG1:'=>$value};
		   		return ($value eq  $asserted)?1:0;
			}
  },

#Equal $PORT_DEFAULT_SIGNAL(config)
# %% PORT:01  SIP
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PORT-SIGNAL_TUA_DEFAULTS', 'CA:' => 'UDP','SP:'=>'TTC',
   'OK:' => \\'The SIP message(%s) MUST be sent to the default port(%s).', 
   'NG:' => \\'The SIP message(%s) MUST be sent to the default port(%s).', 
   'EX:' => \q{FFop('eq',FV('UDP.DestinationPort',@_),$CNT_TUA_PORT,@_)} }, 
   
#Equal $PORT_DEFAULT_SIGNAL(config)
# %% PORT:01  SIP
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PORT-SIGNAL_PUA_DEFAULTS', 'CA:' => 'UDP','SP:'=>'TTC',
   'OK:' => \\'The SIP message(%s) MUST be sent to the default port(%s).', 
   'NG:' => \\'The SIP message(%s) MUST be sent to the default port(%s).', 
   'EX:' => \q{FFop('eq',FV('UDP.DestinationPort',@_),$CNT_PUA_PORT,@_)} }, 


# %% RECORD-ROUTE:nn %%	Record-Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RECORD-ROUTE_ADD-PROXY-URI', 'CA:' => 'Record-Route','SP:'=>'TTC',
   'OK:' => \\'The Record-Route header fields(%s) MUST add SIP URI of the proxy (\"%s\" in the original message).', 
   'NG:' => \\'The Record-Route header fields(%s) MUST add SIP URI of the proxy (\"%s\" in the original message).', 
   'EX:' => sub {
				my ($rule,$pktinfo,$context)=@_;
				my ($before,$after);
				$before = join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt','',NDPKT(@_[1]))});
				$after = join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)});
				$before = 'none' if ($before eq '');
				$after = 'none' if ($after eq '');
				$context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<=>',
		   			'ARG1:'=>$after,
		   			'ARG2:'=>$before,};
				return ($after ne $before)?1:0;
			}},		

   
 # %% R-URI:01 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REMOTE-CONTACT-URI', 'CA:' => 'Request','SP:'=>'TTC',
   'OK:' => \\'Request-URI(%s) MUST equal remote target CONTACT URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'Request-URI(%s) MUST equal remote target CONTACT URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('RQ.Request-Line.uri',@_),$CNT_PUA_CONTACT_URI,@_)} },

####### 20050209 tadokoro 

 ########
 # %% FROM:nn %% From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_ORIGINAL-FROM-URI', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) of the From header MUST equal the URI(%s) of From header in the original message.', 
   'NG:' => \\'The URI(%s) of the From header MUST equal the URI(%s) of From header in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.From.val.ad.ad.txt',@_),FV('HD.From.val.ad.ad.txt','',NDPKT(@_[1])),@_)}}, 

 # %% FROM:nn %%	From-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_ORIGINAL-FROM-TAG', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The From tag(%s) MUST equal the From tag(%s) in the original message.', 
   'NG:' => \\'The From tag(%s) MUST equal the From tag(%s) in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.From.val.param.tag',@_),FV('HD.From.val.param.tag','',NDPKT(@_[1])),@_)}}, 

 # %% TO:nn %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_ORIGINAL-TO-URI', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) of the To header MUST equal the URI(%s) of To header in the original message.', 
   'NG:' => \\'The URI(%s) of the To header MUST equal the URI(%s) of To header in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.To.val.ad.ad.txt',@_),FV('HD.To.val.ad.ad.txt','',NDPKT(@_[1])),@_)}}, 

 # %% TO:nn %%	To-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_ORIGINAL-TO-TAG', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The To tag(%s) MUST equal the To tag(%s) in the original message.', 
   'NG:' => \\'The To tag(%s) MUST equal the To tag(%s) in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.To.val.param.tag',@_),FV('HD.To.val.param.tag','',NDPKT(@_[1])),@_)}}, 
 ########

 # %% CSEQ:nn %%	
 ##	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-SEQNO_ORIGINAL-SEQNO', 'CA:' => 'CSeq','SP:'=>'TTC',
   'OK:' => \\'The CSeq number(%s) MUST equal the CSeq number(%s) in the original message.', 
   'NG:' => \\'The CSeq number(%s) MUST equal the CSeq number(%s) in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.CSeq.val.csno', @_ ) , FV('HD.CSeq.val.csno','', NDPKT(@_[1]) ) , @_ )} }, 

 # %% MAXFORWARDS:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MAX-FORWARDS_DECREMENT', 'CA:' => 'Max-Forwards','SP:'=>'TTC',
   'OK:' => \\'The Max-Forwards value(%s) MUST be decremented by one from the original message(%s).', 
   'NG:' => \\'The Max-Forwards value(%s) MUST be decremented by one from the original message(%s).', 
   'EX:' => \q{ FFop( 'eq' , FV('HD.Max-Forwards.val', @_ ) , FV('HD.Max-Forwards.val','', NDPKT(@_[1]) ) - 1 , @_ ) }},

 # %% CNTLENGTH:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CNTLENGTH_ORIGINAL-CNTLENGTH', 'CA:' => 'Content-Length','SP:'=>'TTC',
   'OK:' => \\'The Content-Length value(%s) MUST equal the Content-Length value(%s) in the original message.', 
   'NG:' => \\'The Content-Length value(%s) MUST equal the Content-Length value(%s) in the original message.', 
   'EX:' => \q{ FFop( 'eq',FV('HD.Content-Length.val', @_ ) , FV('HD.Content-Length.val','', NDPKT(@_[1]) ) , @_ ) }},

 # %% BODY:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BODY_ORIGINAL-BODY', 'CA:' => 'Body','SP:'=>'TTC',
   'OK:' => "The body part MUST equal that in the original message.", 
   'NG:' => "The body part MUST equal that in the original message.", 
   'EX:' => \q{ FFop( 'eq',FV('BD.txt', @_ ) , FV('BD.txt','', NDPKT(@_[1]) ) , @_ ) }},

 # %% ROUTE:nn %%	Route
 ##	
{ 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_ROUTESET_NOEXIST', 'CA:' => 'Route','SP:'=>'TTC',
   'OK:' => \\'The value(%s) of Route header field MUST NOT include the SIP-URI(%s) of the proxy server.', 
   'NG:' => \\'The value(%s) of Route header field MUST NOT include the SIP-URI(%s) of the proxy server.', 
   'EX:' => \q{ !FFop( 'eq',FV('HD.Route.val.route.ad.ad.txt',@_ ) , FV('HD.Route.val.route.ad.ad.txt','', NDPKT(@_[1])) , @_ ) }},

 ########
 # %% VIA:nn %%	Via
 ## Via
 ## 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_INSERT-NEWVIA-LINE', 'CA:' => 'Via','SP:'=>'TTC',
   'OK:' => "A new Via header MUST be inserted before the existing Via header field values.",
   'NG:' => "A new Via header MUST be inserted before the existing Via header field values.",
   'EX:' => sub {
       my($pkt);
       $pkt=NDPKT(@_[1]);
       return ($#{FVs('HD.Via.txt',@_)} > $#{FVs('HD.Via.txt','',$pkt)}) && 
	   FFop('eq',FVn('HD.Via.val.via.sendby.txt',1,@_),FV('HD.Via.val.via.sendby.txt','',$pkt),@_) && 
	   FFop('eq',FVn('HD.Via.val.via.param.branch=',1,@_),FV('HD.Via.val.via.param.branch=','',$pkt),@_);}},

 # %% VIA:nn %%	Via
 # UA->NUT forward
 # 
 # SIPruleRFC.pm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-RECEIVED_EXIST_2ND_REMOTE', 'CA:' => 'Via','SP:'=>'TTC',
   'OK:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the emulating UA.', 
   'NG:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the emulating UA.', 
   'PR:' => \q{FFIsMatchStr(qr/^(?:$PtHostname(?:$PtCOLON$PtPort)?)$/s,FVn('HD.Via.val.via.sendby.txt',1,@_),'ALL','',@_)},
   'EX:' => \q{FFCompareFullADDRESS(FV('HD.Via.val.via.param.received=',@_),NINF('IPaddr','RemotePeer'),@_)}},
   
 # %% VIA:nn %%	Via
 # PX->NUT forward
 # 
 # SIPruleRFC.pm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX', 'CA:' => 'Via','SP:'=>'TTC',
   'OK:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the emulating proxy.', 
   'NG:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the emulating proxy.', 
   'PR:' => \q{FFIsMatchStr(qr/^(?:$PtHostname(?:$PtCOLON$PtPort)?)$/s,FVn('HD.Via.val.via.sendby.txt',1,@_),'ALL','',@_)},
  # 'EX:' => \q{FFIsMatchStr($CVA_TUA_IPADDRESS,FVn('HD.Via.val.via.param.received=',1,@_),'',@_)}}, 
   'EX:' => \q{FFCompareFullADDRESS(FV('HD.Via.val.via.param.received=',@_),$CVA_PX2_IPADDRESS,@_)}},
 ########

 # %% R-URI:nn %% Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_ORIGINAL-R-URI', 'CA:' => 'Request','SP:'=>'TTC',
   'OK:' => \\'The Request-URI(%s) MUST equal the Request-URI(%s) in the original message.', 
   'NG:' => \\'The Request-URI(%s) MUST equal the Request-URI(%s) in the original message.', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('RQ.Request-Line.uri',@_),,FV('RQ.Request-Line.uri','',NDPKT(@_[1])),@_)}}, 


### Add 05/01/14 cats ###

 # %% VIA:nn %%	Via
 # Target
 # 
 # SIPruleRFC.pm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-RECEIVED_EXIST_2ND_LOCAL', 'CA:' => 'Via','SP:'=>'TTC',
   'OK:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the node of tester(Proxy or UA).', 
   'NG:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the node of tester(Proxy or UA).', 
   'PR:' => \q{FFIsMatchStr(qr/^(?:$PtHostname(?:$PtCOLON$PtPort)?)$/s,FVn('HD.Via.val.via.sendby.txt',1,@_),'ALL','',@_)},
   'EX:' => \q{FFIsMatchStr($CVA_PUA_IPADDRESS,FVn('HD.Via.val.via.param.received=',1,@_),'',@_)}}, 

 # %% VIA:nn %%	Via
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_REMOVE-TOPMOST', 'CA:' => 'Via','SP:'=>'TTC',
   'OK:' => "The topmost Via header field MUST be removed from the response.",
   'NG:' => "The topmost Via header field MUST be removed from the response.",
   'EX:' => sub {
     my($addr1,$addr2);
     $addr1=FVs('HD.Via.val.via.sendby.txt',@_);
     $addr2=FVs('HD.Via.val.via.sendby.txt','',NDPKT(@_[1]));
     shift @$addr2;
     return IsArrayEqual($addr1,$addr2);}},

 # %% SDP
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.EQUAL.INOUT', 'CA:' => 'Body','SP:'=>'TTC',
   'OK:' => "The SDP message MUST be not rewrite during transferring.",
   'NG:' => "The SDP message MUST be not rewrite during transferring.",
   'EX:' => \q{FFop('eq',FV('BD.txt',@_),FV('BD.txt','',NDPKT(@_[1])),@_)}},

 # %% Proxy-Authorization
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH_NOTEXIST', 'CA:' => 'Proxy-Authorization','SP:'=>'TTC',
   'OK:' => "A Proxy-Authorization header field MUST NOT exist in this message.", 
   'NG:' => "A Proxy-Authorization header field MUST NOT exist in this message.", 
   'EX:' => \q{!FFIsExistHeader('Proxy-Authorization',@_)}}, 

### Add 05/01/17 cats ###
 ########update by watanabe
 # %% PROXY-AUTHENTICATE:01 %%	Proxy-Authenticate
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE_EXIST.PX', 'CA:' => 'Proxy-Authenticate','SP:'=>'TTC',
   'OK:' => "A Proxy-Authenticate header field MUST exist.", 
   'NG:' => "A Proxy-Authenticate header field MUST exist.", 
   'EX:' => \'FFIsExistHeader("Proxy-Authenticate",@_) eq 1'},

 # %% PROXY-AUTHENTICATE:02 %%	Digest
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE.DIGEST', 'CA:' => 'Proxy-Authenticate','SP:'=>'TTC',
   'OK:' => "The Proxy-Authenticate header field MUST use the \"Digest\" authentication mechanism.", 
   'NG:' => "The Proxy-Authenticate header field MUST use the \"Digest\" authentication mechanism.", 
   'EX:' => \\'HD.Proxy-Authenticate.val.digest'},

 # %% PROXY-AUTHENTICATE:03 %%	nonce
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE-NONCE.EXIST', 'CA:' => 'Proxy-Authenticate','SP:'=>'TTC',
   'OK:' => "The Proxy-Authenticate header field MUST include the nonce parameter.", 
   'NG:' => "The Proxy-Authenticate header field MUST include the nonce parameter.", 
   'EX:' => \\'HD.Proxy-Authenticate.val.digest.nonce'},

 # %% PROXY-AUTHENTICATE:04 %%	realm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE-REALM.EXIST', 'CA:' => 'Proxy-Authenticate','SP:'=>'TTC',
   'OK:' => "The Proxy-Authenticate header field MUST include the realm parameter.", 
   'NG:' => "The Proxy-Authenticate header field MUST include the realm parameter.", 
   'EX:' => \\'HD.Proxy-Authenticate.val.digest.realm'},
 
 # %% PROXY-AUTHENTICATE:05 %%	qop
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE-QOP.AUTH', 'CA:' => 'Proxy-Authenticate','SP:'=>'TTC',
   'OK:' => \\'The qop(%s) parameter must be \"auth\"(with quotation marks).', 
   'NG:' => \\'The qop(%s) parameter must be \"auth\"(with quotation marks).', 
   'EX:' => \q{FFop('eq',\\\'HD.Proxy-Authenticate.val.digest.qop','"auth"',@_)}},

 # %% PROXY-AUTHENTICATE:06 %%	algorithm
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE-ALGORITHM.MD5', 'CA:' => 'Proxy-Authenticate','SP:'=>'TTC',
   'OK:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.', 
   'NG:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.', 
   'PR:' => \\'HD.Proxy-Authenticate.val.digest.algorithm',
   'EX:' => \q{FFop('eq',\\\'HD.Proxy-Authenticate.val.digest.algorithm','MD5',@_)}},

 # %% AUTHENTICATE:01 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_EXIST.PX', 'CA:' => 'WWW-AUthenticate','SP:'=>'TTC',
   'OK:' => "A WWW-Authenticate header field MUST exist.",
   'NG:' => "A WWW-Authenticate header field MUST exist.",
   'EX:' => \'FFIsExistHeader("WWW-Authenticate",@_) eq 1'},

 # %% AUTHENTICATE:02 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_DIGEST', 'CA:' => 'WWW-Authenticate','SP:'=>'TTC',
   'OK:' => "The WWW-Authenticate header field MUST use the \"Digest\" authentication mechanism.",
   'NG:' => "The WWW-Authenticate header field MUST use the \"Digest\" authentication mechanism.",
   'EX:' => \\'HD.WWW-Authenticate.val.digest'},

 # %% AUTHENTICATE:03 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_NONCE.EXIST', 'CA:' => 'WWW-Authenticate','SP:'=>'TTC',
   'OK:' => "The WWW-Authenticate header field MUST include the nonce parameter.",
   'NG:' => "The WWW-Authenticate header filed MUST include the nonce parameter.",
   'EX:' => \\'HD.WWW-Authenticate.val.digest.nonce'},

 # %% AUTHENTICATE:04 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_REALM.EXIST', 'CA:' => 'WWW-Authenticate','SP:'=>'TTC',
   'OK:' => "The WWW-Authenticate header field MUST include realm parameter.",
   'NG:' => "The WWW-Authenticate header field MUST include realm parameter.",
   'EX:' => \\'HD.WWW-Authenticate.val.digest.realm'},

 # %% AUTHENTICATE:05 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_QOP.AUTH', 'CA:' => 'WWW-Authenticate','SP:'=>'TTC',
   'OK:' => \\'The qop(%s) parameter must be \"auth\"(with quotation marks).',
   'NG:' => \\'The qop(%s) parameter must be \"auth\"(with quotation marks).',
   'EX:' => \q{FFop('eq',\\\'HD.WWW-Authenticate.val.digest.qop','"auth"',@_)}},

 # %% AUTHENTICATE:06 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH-ALGORITHM.MD5', 'CA:' => 'WWW-Authenticate','SP:'=>'TTC',
   'OK:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.',
   'NG:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.',
   'PR:' => \\'HD.WWW-Authenticate.val.digest.algorithm',
   'EX:' => \q{FFop('eq',\\\'HD.WWW-Authenticate.val.digest.algorithm','MD5',@_)}},

 # %% DATE:01 %%	Date
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.DATE_EXIST', 'CA:' => 'Date','SP:'=>'TTC',
   'OK:' => "A Date header field SHOULD exist.", 
   'NG:' => "A Date header field SHOULD exist.", 
   'RT:' => "warning", 
   'EX:' => \'FFIsExistHeader("Date",@_)'},

 # %% DATE:02 %%        
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.DATE_TIMEZONE_GMT', 'CA:' => 'Date','SP:'=>'TTC',
   'OK:' => "The time zone in the Date header field must be \"GMT\".", 
   'NG:' => "The time zone in the Date header field must be \"GMT\".", 
   'PR:' => \q{FFIsExistHeader("Date",@_)},
   'EX:' => \q{FFIsMatchStr('GMT',FV('HD.Date.val.zone',@_))}},

 # %% Record-Route:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RE-ROUTE_ORIGINAL-RE-ROUTE', 'CA:' => 'Record-Route','SP:'=>'TTC',
   'OK:' => \\'The Record-Route header field(%s) MUST equal the Record-Route(%s) in the original message.', 
   'NG:' => \\'The Record-Route header field(%s) MUST equal the Record-Route(%s) in the original message.', 
   'EX:' => \q{FFop('eq',
   		join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)}),
   		join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt','',NDPKT(@_[1]))}),
		@_),
   	}},
   	
 # %% ROUTE:nn %%	Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_PSEUDO_PROXY_URI', 'CA:' => 'Route','SP:'=>'TTC',
   'OK:' => \\'The Route header field(%s) MUST equal the SIP-URI(%s) of the proxy(tester emuating).', 
   'NG:' => \\'The Route header field(%s) MUST equal the SIP-URI(%s) of the proxy(tester emuating).', 
   'EX:' => \q{FFop('eq',FV('HD.Route.val.route.ad.ad.txt',@_),@CNT_PUA_TWOPX_ROUTESET[0],@_)}},

 # %% Contact-Expires:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-EXPIRES_VALUE-NOTCOLLECTLY', 'CA:' => 'Contact-Expires','SP:'=>'TTC',
   'OK:' => \\q{Both The Expires parameter just before value and Last value's difference(%s) and the last received message and just before message time-stump's difference(%s) MUST be within the realm of waittime's differences[(%s) <= X <= (%s)].},
   'NG:' => \\q{Both the Expires parameter just before value and Last value's difference(%s) and the last received message and just before message time-stump's difference(%s) MUST be within the realm of waittime's differences[(%s) <= X <= (%s)].},
   'EX:' => sub {
     my($rule,$pktinfo,$context)=@_;
     my($ts1st,$ts2nd,$ex1,$ex2,$exdiff,$tsdiff,$waitdistmin,$waitdistmax);
     $ts1st=FVib('recv',-1,'','TS','RQ.Status-Line.code',200);
     $ts2nd=FV('TS',@_);
     $ex1=FVib('recv',-1,'','HD.Contact.val.contact.param.expires=','RQ.Status-Line.code',200);
     $ex2=FV('HD.Contact.val.contact.param.expires=',@_);
     $tsdiff=$ts2nd-$ts1st;
     $exdiff=$ex1-$ex2;
     $waitdistmin=$WaitRegistTime-$WaitMargin;
     $waitdistmax=$WaitRegistTime+$WaitMargin;
     $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<=>',
				   'ARG1:'=>$exdiff,
				   'ARG2:'=>$tsdiff,
				   'ARG3:'=>$waitdistmin,
				   'ARG4:'=>$waitdistmax};
     return 
	  ($exdiff <= $waitdistmax &&
	  $waitdistmin <= $exdiff) &&
          ($tsdiff <= $waitdistmax &&
          $waitdistmin <= $tsdiff);}},

 # %% Contact:nn %% 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT_NOEXIST', 'CA:' => 'Contact','SP:'=>'TTC',
   'OK:' => "The Contact header field MUST not exist.",
   'NG:' => "The Contact header field MUST not exist.",
   'EX:' => \q{!FFIsExistHeader("Contact",@_)}}, 

 # %% Contact:nn %%
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-URI_REGISTER-CONTACT-URI', 'CA:' => 'Contact','SP:'=>'TTC',
#   'OK:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
#   'NG:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
#   'EX:' => \q{FFop('eq',FV('HD.Contact.val.contact.ad.ad.txt',@_),$CNT_PUA_CONTACT_URI,@_)}},

 # %% Contact:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES', 'CA:' => 'Contact-Expires','SP:'=>'TTC',
   'OK:' => \\'The expires parameter(%s) MUST equal the register-expires header field value(%s).',
   'NG:' => \\'The expires parameter(%s) MUST equal the register-expires header field value(%s).',
   'EX:' => \q{FFop('eq',FV('HD.Contact.val.contact.param.expires=',@_),FVib('send','','','HD.Expires.val.seconds'),@_)}},

 # %% Record-Route:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RECORD-ROUTE_ORIGINAL-RECORD-ROUTE', 'CA:' => 'Record-Route','SP:'=>'TTC',
   'OK:' => \\'The record-route(%s) MUST equal the record-route(%s) in the original massage.',
   'NG:' => \\'The record-route(%s) MUST equal the record-route(%s) in the original message.',
   'EX:' => \q{FFop('eq',
   		join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)}),
   		join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt','',NDPKT(@_[1]))}),
		@_),
   	}},



 # %% Proxy-Authorization:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PROXY-AUTH_REMOVE-TOPMOST', 'CA:' => 'Proxy-Authorization','SP:'=>'TTC',
   'OK:' => "The topmost Proxy-Authorization header field MUST be removed from the request.",
   'NG:' => "The topmost Proxy-Authorization header field MUST be removed from the request.",
   'EX:' => \q{(FFop('eq',FV('HD.Proxy-Authorization.val.digest.realm',@_),FVn('HD.Proxy-Authorization.val.digest.realm',1,'',NDPKT(@_[1])),@_)) 
   	&& (FFop('eq',FV('HD.Proxy-Authorization.val.digest.nc',@_),FVn('HD.Proxy-Authorization.val.digest.nc',1,'',NDPKT(@_[1])),@_)) 
   	&& (FFop('eq',FV('HD.Proxy-Authorization.val.digest.username',@_),FVn('HD.Proxy-Authorization.val.digest.username',1,'',NDPKT(@_[1])),@_)) 
   	&& (FFop('eq',FV('HD.Proxy-Authorization.val.digest.nonce',@_),FVn('HD.Proxy-Authorization.val.digest.nonce',1,'',NDPKT(@_[1])),@_)) 
   	&& (FFop('eq',FV('HD.Proxy-Authorization.val.digest.response',@_),FVn('HD.Proxy-Authorization.val.digest.response',1,'',NDPKT(@_[1])),@_)) 
   	&& (FFop('eq',FV('HD.Proxy-Authorization.val.digest.uri',@_),FVn('HD.Proxy-Authorization.val.digest.uri',1,'',NDPKT(@_[1])),@_)) 
   	&& (FFop('eq',FV('HD.Proxy-Authorization.val.digest.qop',@_),FVn('HD.Proxy-Authorization.val.digest.qop',1,'',NDPKT(@_[1])),@_)) 
   	&& (FFop('eq',FV('HD.Proxy-Authorization.val.digest.opaque',@_),FVn('HD.Proxy-Authorization.val.digest.opaque',1,'',NDPKT(@_[1])),@_)) 
   	&& (FFop('eq',FV('HD.Proxy-Authorization.val.digest.cnonce',@_),FVn('HD.Proxy-Authorization.val.digest.cnonce',1,'',NDPKT(@_[1])),@_))
}},

###### 


 #=================================
 # 
 #=================================
 # 
 # 

### Add 05/01/19 cats
 # %% Forward request %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SS.FORWARD_REQUEST_COMPARE', 'SP:'=>'TTC',
   'RR:' => [
              'S.TO-URI_ORIGINAL-TO-URI',
              'S.TO-TAG_ORIGINAL-TO-TAG', 
              'S.FROM-URI_ORIGINAL-FROM-URI', 
              'S.FROM-TAG_ORIGINAL-FROM-TAG', 
              'S.CSEQ-SEQNO_ORIGINAL-SEQNO', 
              'S.CNTLENGTH_ORIGINAL-CNTLENGTH', 
              'S.BODY_ORIGINAL-BODY', 
            ]
 }, 

 # %% Forward response %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SS.FORWARD_RESPONSE_COMPARE', 'SP:'=>'TTC',
   'RR:' => [
              'S.TO-URI_ORIGINAL-TO-URI',
              'S.TO-TAG_ORIGINAL-TO-TAG', 
              'S.FROM-URI_ORIGINAL-FROM-URI', 
              'S.FROM-TAG_ORIGINAL-FROM-TAG', 
              'S.CSEQ-SEQNO_ORIGINAL-SEQNO', 
              'S.CNTLENGTH_ORIGINAL-CNTLENGTH', 
              'S.BODY_ORIGINAL-BODY', 
              'S.RECORD-ROUTE_ORIGINAL-RECORD-ROUTE',
            ]
 }, 


 # %% Forward from UA %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SS.FORWARD_HEADERS', 'SP:'=>'TTC',
   'RR:' => [
              'S.VIA_INSERT-NEWVIA-LINE', 
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE', 
              ## 'S.VIA_TWOPX_SEND_EQUALS.VI', 
            ]
 }, 

 # %% Forward from PX %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SS.FORWARD_HEADERS_FROM_PX', 'SP:'=>'TTC',
   'RR:' => [
              'S.VIA_INSERT-NEWVIA-LINE', 
              'S.VIA-RECEIVED_EXIST_2ND_FROM_PX', 
              ## 'S.VIA_TWOPX_SEND_EQUALS.VI', 
            ]
 }, 
 # %% Proxy-Authenticate %%	Proxy-Authenticate
 { 'TY:' => 'RULESET', 'ID:' => 'SS.DIGEST-AUTH_CHALLENGE.PX', 'SP:'=>'TTC',
   'RR:' => [
              'S.P-AUTHENTICATE_EXIST.PX', 
              'S.P-AUTHENTICATE.DIGEST', 
              'S.P-AUTHENTICATE-NONCE.EXIST', 
              'S.P-AUTHENTICATE-REALM.EXIST', 
              'S.P-AUTHENTICATE-QOP.AUTH', 
              'S.P-AUTHENTICATE-ALGORITHM.MD5', 
            ]
 }, 

 # %% WWW-Authenticate %%	WWW-Authenticate
 { 'TY:' => 'RULESET', 'ID:' => 'SS.DIGEST-AUTH_CHALLENGE.RG', 'SP:'=>'TTC',
   'RR:' => [
              'S.WWW-AUTH_EXIST.PX', 
              'S.WWW-AUTH_DIGEST', 
              'S.WWW-AUTH_NONCE.EXIST', 
              'S.WWW-AUTH_REALM.EXIST', 
              'S.WWW-AUTH_QOP.AUTH', 
              'S.WWW-AUTH-ALGORITHM.MD5', 
            ]
 }, 

 # %% PX-1-1-1 01 %%	UA1 receives ACK for 200 OK(forwarded)
 # 20050309 tadokoro
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.200-ACK_FORWARDED.ONEPX.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.REQUEST.200-ACK.TM 
              #'SSet.REQUEST.200-ACK.TM',
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              'S.MUSTNOT-HEADER_ACK',
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-METHOD_ACK',
              'S.CSEQ-SEQNO_REQ-SEQNO',
              'S.BODY_NOEXIST',
              'SSet.ACK-2xx',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.ROUTE_NOEXIST',
              'SS.FORWARD_REQUEST_COMPARE',
              #'S.R-URI_ORIGINAL-R-URI', # 20050228 remove tadokoro
              #'SS.FORWARD_HEADERS_FROM_PX', # 20050309 disable tadokoro
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              # 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX',
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
              #'S.RECORD-ROUTE_ADD-PROXY-URI',
            ]
 }, 
 
  # %% PX-1-1-1 02 %%	UA1 receives BYE(forwarded).
  # 20050309 tadokoro
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.BYE_FORWARDED.ONEPX.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.BYE.NOPX 
              #'SSet.BYE.NOPX',
              'SSet.ALLMesg',
              'S.R-URI_NOQUOTE',
              'S.R-URI_REQ-CONTACT-URI',
              'S.R-LINE_VERSION',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.ROUTE_NOEXIST',
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
              #'SS.FORWARD_HEADERS_FROM_PX', # 20050309 disable tadokoro
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              # 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX',
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
              'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
            ]
 }, 
 
  # %% PX-1-1-1 03 %%  UA1 receives INVITE(forwarded)[re-vesion]
  # 20050309 tadokoro 
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.ONEPX.TM','SP:'=>'TTC',
    'RR:' => [
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
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
              'SSet.SDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'SS.FORWARD_REQUEST_COMPARE',
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
             'S.R-URI_REMOTE-CONTACT-URI', # 200500226 tadokoro remove if upper rule created
             'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 tadokoro
             'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro             
            ]
 },
 
 # %% PX-1-1-2 01 %%	UA receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-407.TM', 'SP:'=>'TTC',
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.DIGEST-AUTH_CHALLENGE.PX',
              'S.PORT-SIGNAL_PUA_DEFAULTS',
              ### TODO: Insert Some Syntax about Proxy-Authenticate header here... ###
            ]
 }, 

 # %% PX-1-1-2 02' %%   Proxy receives INVITE(forwarded)[re-version]
   { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.PX','SP:'=>'TTC',
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
               'SSet.URICompMsg',
               'S.R-URI_TO-URI',
               'S.CONTACT_EXIST',
               'S.CONTACT_NOT-*',
               'S.CONTACT_QUOTE',
               'S.CSEQ-METHOD_INVITE',
               'S.SUPPORTED_EXIST',
               'S.ALLOW_EXIST',
               'S.BODY_EXIST',
               'SSet.SDP',
               'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
               'S.TO-TAG_NOEXIST',
               'S.P-AUTH_NOTEXIST',
               'SS.FORWARD_REQUEST_COMPARE',
               'S.R-URI_ORIGINAL-R-URI',
               'SS.FORWARD_HEADERS',
               'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
               'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
	      ]
 },

 # %% PX-1-1-2 02' %%   Proxy receives INVITE(forwarded)[re-version]
   { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.RE-INVITE_FORWARDED.PX','SP:'=>'TTC',
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
               'SSet.URICompMsg',
               'S.R-URI_REQ-CONTACT-URI',
               'S.CONTACT_EXIST',
               'S.CONTACT_NOT-*',
               'S.CONTACT_QUOTE',
               'S.CSEQ-METHOD_INVITE',
               'S.SUPPORTED_EXIST',
               'S.ALLOW_EXIST',
               'S.BODY_EXIST',
               'SSet.SDP',
               'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
               'S.TO-TAG_NOEXIST',
               'S.P-AUTH_NOTEXIST',
               'SS.FORWARD_REQUEST_COMPARE',
               'S.R-URI_ORIGINAL-R-URI',
               'SS.FORWARD_HEADERS',
               'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
               'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	       'SS.RE-INVITE.NOEXIST_TTC',
            ]
 },


 # %% PX-1-1-2 02' %%   Proxy receives INVITE(forwarded)[re-version]
   { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.PX.NOSUPPORTED','SP:'=>'TTC',
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
               'SSet.URICompMsg',
               'S.R-URI_TO-URI',
               'S.CONTACT_EXIST',
               'S.CONTACT_NOT-*',
               'S.CONTACT_QUOTE',
               'S.CSEQ-METHOD_INVITE',
               'S.SUPPORTED_NOTEXIST',
               'S.ALLOW_EXIST',
               'S.BODY_EXIST',
               'SSet.SDP',
               'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
               'S.TO-TAG_NOEXIST',
               'S.P-AUTH_NOTEXIST',
               'SS.FORWARD_REQUEST_COMPARE',
               'S.R-URI_ORIGINAL-R-URI',
               'SS.FORWARD_HEADERS',
               'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
               'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },

 # %% PX-1-1-2 03 %%	UA1 receives receives 100 Trying
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-100.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.STATUS.INVITE-100.NOPX 
              'SSet.STATUS.INVITE-100.NOPX', 
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 


 # %% PX-1-1-2 04 %%	UA1 receives 180 Ringing.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-180.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.STATUS.INVITE-180.NOPX 
              'SSet.STATUS.INVITE-180.NOPX', 
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.FORWARD_RESPONSE_COMPARE',
              'S.VIA_REMOVE-TOPMOST',
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro              
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-1-2 05 %%	UA1 receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-200.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.STATUS.INVITE.NOPX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
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
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro     
	      'S.AUTHENTICATION-INFO_NOEXIST_TTC',
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-1-2 06 %%	Proxy receives ACK for 200 OK(forwarded).

 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.200-ACK_FORWARDED.PX', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.REQUEST.200-ACK.PX 
              #'SSet.ACK',
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
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-METHOD_ACK',
              'S.CSEQ-SEQNO_REQ-SEQNO',
              'S.BODY_NOEXIST',
              'SSet.ACK-2xx',
              'S.P-AUTH_NOTEXIST',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.ROUTE_EXIST',
              'S.ROUTE_PSEUDO_PROXY_URI',
              'S.BODY_ACK-ANSWER_EXIST',
              'SS.FORWARD_REQUEST_COMPARE',
              'SS.FORWARD_HEADERS',
              'S.R-URI_ORIGINAL-R-URI',
              #'S.RECORD-ROUTE_ADD-PROXY-URI' #20050309 disable tadokoro
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
              'SS.ACK.NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-1-2 07 %%	UA1 receives BYE(forwarded).
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.BYE_FORWARDED.TWOPX.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.BYE.NOPX 
              #'SSet.BYE.NOPX',
              'SSet.ALLMesg',
              'S.R-URI_NOQUOTE',
              'S.R-URI_REQ-CONTACT-URI',
              'S.R-LINE_VERSION',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.ROUTE_NOEXIST',
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
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
              'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
            ]
 }, 

 # %% PX-1-1-2 08 %%	Proxy receives 200 OK(forwarded).
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.BYE-200_FORWARDED.PX', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.REQUEST.BYE-200.PX 
             'SSet.ResMesg',
	     'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
	     'S.VIA-RECEIVED_EXIST_PX',
	     'S.VIA_ONEPX_SEND_EQUAL',
	     'S.TO-TAG_EXIST',
	     'S.TO-TAG_REMOTE-TAG',
	     'S.CSEQ-METHOD_BYE',
             'SS.FORWARD_RESPONSE_COMPARE',
             'S.VIA_REMOVE-TOPMOST',
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	     'S.AUTHENTICATION-INFO_NOEXIST_TTC',
	     'S.MESSAGEBODY_NOEXIST_TTC',
	     'SS.BYE-RES.NOEXIST_TTC',
            ]
 }, 


 # %% PX-1-1-3 01' %%  UA1 receives INVITE(forwarded)[re-vesion]
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.TWOPX.TM','SP:'=>'TTC',
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
              #'S.R-URI_TO-URI', # 20050225 disable tadokoro
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
              'SS.FORWARD_HEADERS_FROM_PX',
             #'S.R-URI_REMOTE-AOR_OR_CONTACT-URI', # not yet
             'S.R-URI_REMOTE-CONTACT-URI', # 200500226 tadokoro remove if upper rule created
             'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 tadokoro
             'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
	      'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },

 # %% PX-1-1-3 02 %%	Proxy receives receives 100 Trying
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-100.PX', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.STATUS.INVITE-100.PX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
#              'SSet.STATUS.INVITE-100.PX', 
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-1-3 03 %%	Proxy receives 180 Ringing(forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-180_FORWARDED.PX', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.STATUS.INVITE-180.PX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
#              'SSet.STATUS.INVITE-180.PX', 
              'SS.FORWARD_RESPONSE_COMPARE',
              'S.VIA_REMOVE-TOPMOST',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-1-3 04 %%	Proxy receives 200 OK(forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-200_FORWARDED.PX', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.STATUS.INVITE.PX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
              'S.CONTACT_EXIST',
              'S.CONTACT_QUOTE',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              'S.BODY_EXIST',
              'SSet.SDP-ANS',
              'S.CSEQ-METHOD_INVITE',
              'S.RE-ROUTE_EXIST',
              'S.RE-ROUTE_ORIGINAL-RE-ROUTE',
              'D.COMMON.FIELD.STATUS',
              'SS.FORWARD_RESPONSE_COMPARE',
              'S.VIA_REMOVE-TOPMOST',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	      'S.AUTHENTICATION-INFO_NOEXIST_TTC',
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-1-3 05 %%	UA1 receives ACK for 200 OK(forwarded)

 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.200-ACK_FORWARDED.TWOPX.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.REQUEST.200-ACK.TM 
              #'SSet.REQUEST.200-ACK.TM',
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              'S.MUSTNOT-HEADER_ACK',
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID.OTHER-REQUEST',
              'S.CSEQ-METHOD_ACK',
              'S.CSEQ-SEQNO_REQ-SEQNO',
              'S.BODY_NOEXIST',
              'SSet.ACK-2xx',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.ROUTE_NOEXIST',
              'SS.FORWARD_REQUEST_COMPARE',
              #'S.R-URI_ORIGINAL-R-URI', # 20050228 remove tadokoro
              'SS.FORWARD_HEADERS_FROM_PX',
              #'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
              'S.PORT-SIGNAL_PUA_DEFAULTS',
              'SS.ACK.NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-1-3 06 %%	Proxy receives BYE(forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.BYE_FORWARDED.PX', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.BYE.PX 
              #'SSet.BYE',
              'SSet.ALLMesg',
              'S.R-URI_NOQUOTE',
              'S.R-URI_REQ-CONTACT-URI',
              'S.R-LINE_VERSION',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.ROUTE_EXIST',
              'S.ROUTE_PSEUDO_PROXY_URI',
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_EXIST',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.CALLID_VALID.OTHER-REQUEST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              'S.CSEQ-METHOD_BYE',
              'S.CSEQ-SEQNO_ORIGINAL-SEQNO',
              'S.MUSTNOT-HEADER_BYE',
              'SS.FORWARD_REQUEST_COMPARE',
              'SS.FORWARD_HEADERS',
              'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # %% PX-1-1-3 07 %%	UA1 receives 200 OK(forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.BYE-200_FORWARDED.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.REQUEST.BYE-200.NOPX 
              'SSet.REQUEST.BYE-200.NOPX', 
              'SS.FORWARD_RESPONSE_COMPARE',
              #'S.VIA_INSERT-NEWVIA-LINE',
              'S.VIA_REMOVE-TOPMOST',
              'S.PORT-SIGNAL_PUA_DEFAULTS',
	     'S.AUTHENTICATION-INFO_NOEXIST_TTC',
	     'S.MESSAGEBODY_NOEXIST_TTC',
	     'SS.BYE-RES.NOEXIST_TTC',
            ]
 }, 


 # %% RG-1-1-1 01 %%	UA1 receives 401 Unauthorized from Registrar
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-401.TM', 'SP:'=>'TTC',
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
              'S.PORT-SIGNAL_DEFAULTS',
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
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
            ]

 }, 

 # %% RG-1-1-1 02 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # %% RG-1-1-3 nn %%	UA1 receives 200 Advanst1
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-CURRENT', 'SP:'=>'TTC',
   'RR:' => [
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT-EXPIRES_VALUE-NOTCOLLECTLY',
	    ]
},

 # %% RG-1-1-1 03 %%	UA1 receives 200 BASIC
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-BASIC', 'SP:'=>'TTC',
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
              'S.DATE_EXIST'
	     ]
},

 # %% RG-1-1-4 01 %%	UA1 receives 200 OK for delete REGISTER
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200_DELETE.TM', 'SP:'=>'TTC',
   'RR:' => [
              ### 
              'SS.STATUS.REGISTER-BASIC', 
              'S.CONTACT_NOEXIST',
            ]
 }, 


 # %% SDP %%	SDP
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.SDP', 'SP:'=>'TTC',
   'RR:' => [
              'S.SDP.EQUAL.INOUT',
            ]
 }, 

### Add 05/01/17 cats ###

 # %% PX-1-1-4 02 %%	UA receives 407 Proxy Authentication Required(about PX2)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-407_2NDPX.TM', 'SP:'=>'TTC',
   'RR:' => [
              ## 
              ## Proxy-Authenticate
              'SS.STATUS.INVITE-407.TM',
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 


 # %% PX-1-1-4 03 %%	Proxy receives INVITE with Proxy-Authorization(about 2nd Proxy)(forwarded) 
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE-AUTH_FORWARDED.PX', 'SP:'=>'TTC',
   'RR:' => [
              ## 
              ## 2
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              'SSet.URICompMsg',
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CSEQ-METHOD_INVITE',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              'S.BODY_EXIST',
              'SSet.SDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_NOEXIST',
              'S.PROXY-AUTH_REMOVE-TOPMOST',
              'SS.FORWARD_REQUEST_COMPARE',
              'S.R-URI_ORIGINAL-R-URI',
              'SS.FORWARD_HEADERS',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	     'SS.INITIAL-INVITE.NOEXIST_TTC',
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 


 # %% PX-1-1-5 01 %%	PX1 receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-407.PX', 'SP:'=>'TTC',
   'RR:' => [
              ## SS.STATUS.INVITE-NO2XX.PX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.RE-ROUTE_NOEXIST',
              'S.CSEQ-METHOD_INVITE',
              'S.TO-TAG_EXIST',
              'D.COMMON.FIELD.STATUS',
              'SS.DIGEST-AUTH_CHALLENGE.PX',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 

 # %% PX-1-1-6 01 %%	UA receives re-INVITE(forwarded).
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.RE-INVITE-HOLD_FORWARDED.TM', 'SP:'=>'TTC',
   'RR:' => [
              ## SSet.REQUEST.RE-INVITE-HOLD 
              #'SSet.ReqMesg',
              'SSet.ALLMesg',
              'S.R-URI_NOQUOTE',
              'S.R-URI_REQ-CONTACT-URI', 
              'S.R-LINE_VERSION',

              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.ROUTE_NOEXIST',
              'S.RECORD-ROUTE_ADD-PROXY-URI', # 2005023 add by tadokoro              
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_EXIST',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.CONTACT-URI_REMOTE-CONTACT-URI',
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CALLID_VALID', 
              'S.CSEQ-METHOD_REQLINE-METHOD',
              'S.CSEQ-METHOD_INVITE',
              'S.CSEQ-SEQNO_ORIGINAL-SEQNO',
              'SSet.SDP',
              'D.COMMON.FIELD.REQUEST',
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
              'S.VIA-RECEIVED_EXIST_2ND_FROM_PX', # 20050310 add tadokoro
	     'SS.RE-INVITE.NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-1-7 01 %%	Proxy receives re-INVITE(forwarded). 
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.RE-INVITE-HOLD_FORWARDED.PX', 'SP:'=>'TTC',
   'RR:' => [
              ## SSet.REQUEST.RE-INVITE-HOLD 
              'SSet.ALLMesg',
              'S.R-URI_NOQUOTE',
              'S.R-URI_REQ-CONTACT-URI', 
              'S.R-LINE_VERSION',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.ROUTE_EXIST',
              'S.ROUTE_PSEUDO_PROXY_URI',
              'S.RECORD-ROUTE_ADD-PROXY-URI', # 2005023 add tadokoro
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_EXIST',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.CONTACT-URI_REMOTE-CONTACT-URI',
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CALLID_VALID', 
              'S.CSEQ-METHOD_REQLINE-METHOD',
              'S.CSEQ-METHOD_INVITE',
              'S.CSEQ-SEQNO_ORIGINAL-SEQNO',
              'SSet.SDP',
              'D.COMMON.FIELD.REQUEST',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE', # 20050316 add tadokoro
	     'SS.RE-INVITE.NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-1-8 01 %%	UA receives 200 for CANCEL
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.CANCEL-200.TM', 'SP:'=>'TTC',
   'RR:' => [
              ## SSet.STATUS.CANCEL-200.TM 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_RECENT1xx-TO-TAG',
              'S.CSEQ-METHOD_CANCEL',
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
	      'S.PRIVACY_NOEXIST_TTC',
            ]
 }, 


 # %% PX-1-1-8 02 %%	Proxy receives CANCEL.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.CANCEL.PX', 'SP:'=>'TTC',
   'RR:' => [
              ## SSet.REQUEST.200-CANCEL-200.PX 
              ## 
              # 'SSet.REQUEST.200-CANCEL.PX', 
              'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_CANCEL',
              'S.R-URI_REQ-R-URI',
              'S.VIA_REQ-SINGULAR',
              'S.VIA_REQ-1STVIA',
              'S.VIA-BRANCH_REQ-VIA-BRANCH',
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-METHOD_CANCEL',
              'S.CSEQ-SEQNO_REQ-SEQNO',
              'S.REQUIRE_NOEXIST',
              'S.P-REQUIRE_NOEXIST',
              'S.ROUTE_VALID',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-1-9 01 %%	PX1 receives 200 for CANCEL
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.CANCEL-200.PX', 'SP:'=>'TTC',
   'RR:' => [
              ## SSet.STATUS.CANCEL-200.PX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX-CANCEL',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS-CANCEL.VI',
              'S.TO-TAG_RECENT1xx-TO-TAG',
              'S.CSEQ-METHOD_CANCEL',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	      'S.PRIVACY_NOEXIST_TTC',
            ]
 }, 


 # %% PX-1-1-9 02 %%	UA receives CANCEL.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.CANCEL.TM', 'SP:'=>'TTC',
   'RR:' => [
              ## SSet.REQUEST.200-CANCEL.PX 
              ## Route
              ##   (SIPv6/Backup/Sequence/P3-26-1.seq
              ## 
             'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_CANCEL',
              'S.R-URI_REQ-R-URI',
              'S.VIA_REQ-SINGULAR',
              'S.VIA_REQ-1STVIA',
              'S.VIA-BRANCH_REQ-VIA-BRANCH',
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.CALLID_VALID',
              'S.CSEQ-METHOD_CANCEL',
              'S.CSEQ-SEQNO_REQ-SEQNO',
              'S.REQUIRE_NOEXIST',
              'S.P-REQUIRE_NOEXIST',
              'S.ROUTE_VALID',
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-2-1 01 %%	PX receives ACK for 486 response
 # %% PX-1-2-3 01 %%	PX receives ACK for 480 response
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.ACK-NO2XX.PX','SP:'=>'TTC',
   'RR:' => [
              ## 'SSet.REQUEST.non2xx-ACK' 
              'SSet.ACK',
              'SSet.ACK-Non2xx',
              'S.VIA-BRANCH_REQ-VIA-BRANCH',
              'S.TO-TAG_LOCAL-TAG',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-2-2 01 %%	UA receives ACK for 486 response
 # %% PX-1-2-4 01 %%	UA receives ACK for 480 response
 # %% PX-1-2-5 01 %%	UA receives ACK for 480 response
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.ACK-NO2XX.TM','SP:'=>'TTC',
   'RR:' => [
              ## 'SSet.REQUEST.non2xx-ACK' 
              'SSet.ACK',
              #'SSet.ACK-Non2xx',    # 20050225 disable by tadokoro
              #'S.R-URI_TO-URI',     # disable from SSet.Ack-Non2xx
              'S.R-URI_REQ-R-URI',   # from SSet.Ack-Non2xx
              'S.BODY_NOEXIST',      # from SSet.Ack-Non2xx
              'S.REQUIRE_NOEXIST',   # from SSet.Ack-Non2xx
              'S.P-REQUIRE_NOEXIST', # from SSet.Ack-Non2xx
              'S.VIA-BRANCH_REQ-VIA-BRANCH',
              'S.TO-TAG_LOCAL-TAG',
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-2-1 02 %%	UA receives 486 response
 # %% PX-1-2-3 02 %%	UA receives 480 response
 # 20050310 add tadokoro
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-NO2XX.ONEPX.TM','SP:'=>'TTC',
   'RR:' => [
              ## 'SSet.STATUS.INVITE-4XX.PX' 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
              'D.COMMON.FIELD.STATUS',
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 
 
 # %% PX-1-2-1 02 %%	UA receives 486 response
 # %% PX-1-1-8 02 %%	UA receives 480 response
 # %% PX-1-2-3 02 %%	UA receives 486 response
 # 20050310 add tadokoro
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-NO2XX.TWOPX.TM','SP:'=>'TTC',
   'RR:' => [
              ## 'SSet.STATUS.INVITE-4XX.PX' 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
              'D.COMMON.FIELD.STATUS',
              'S.PORT-SIGNAL_PUA_DEFAULTS', # 20050309 add tadokoro
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 

 # %% PX-1-2-2 02 %%	PX receives ACK for 486 response
 # %% PX-1-2-4 02 %%	PX receives ACK for 480 response
 # %% PX-1-2-5 02 %%	PX receives ACK for 480 response
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-NO2XX.PX','SP:'=>'TTC',
   'RR:' => [
              ## 'SSet.STATUS.INVITE-4XX.NOPX' 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.RE-ROUTE_NOEXIST',
              'S.CSEQ-METHOD_INVITE',
              'S.TO-TAG_EXIST',
              'D.COMMON.FIELD.STATUS',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 


###### 


 # %% Via %%	(
 { 'TY:' => 'RULESET', 'ID:' => 'SS.VIA-FORWARD', 'SP:'=>'TTC',
   'RR:' => [
              'S.VIA_EXIST', 
              'S.VIA-BRANCH_z9hG4bK', 
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.VIA_INSERT-NEWVIA-LINE',  ##[SERVER]
            ]
 }, 

 
####### add 20050209 tadokoro
####### 
 # %% 
 #  PX2 receives INVITE(forwarded)
 ## SS.REQUEST.INVITE_FORWARDED.PX
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-1.PX','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.PX',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_0ABJ_E164',
              'S.FROM-DISPLAYNAME_EXIST',
              'S.FROM-USERINFO_EXIST',
              'S.PRIVACY_EXIST', 
              'S.PRIVACY_VALUE_NONE',
              'S.P-PREF-ID_REMOVED',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ORIGINAL_PREF',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
			],
  },


 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-2.PX','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.PX',
               ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_1860ABJ_E164',
              'S.FROM-DISPLAYNAME_EXIST',
              'S.FROM-USERINFO_EXIST',
              #'S.TO-URI_START186', 
              'S.PRIVACY_EXIST', 
              'S.PRIVACY_VALUE_NONE',
              'S.P-PREF-ID_REMOVED',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ORIGINAL_PREF',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
			],
  },
  
 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-3.PX','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.PX',
               ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_1860ABJ_E164',
              'S.FROM-DISPLAYNAME_EXIST',
              'S.FROM-USERINFO_EXIST',
              #'S.TO-URI_START186', 
              'S.PRIVACY_EXIST', 
              'S.PRIVACY_VALUE_NONE',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ID_GENERATE',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
			],
  },
  

  
 # %% 
 #  UA Calee receives INVITE(forwarded)
 ## SS.REQUEST.INVITE_FORWARDE.TM
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-1.TM','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.ONEPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_0ABJ_E164',
              'S.FROM-DISPLAYNAME_EXIST',
              'S.FROM-USERINFO_EXIST',
              'S.PRIVACY_EXIST', 
              'S.PRIVACY_VALUE_NONE',
              'S.P-PREF-ID_REMOVED',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ORIGINAL_PREF',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
			],
  },  
  
 # %% 
 #  UA Calee receives INVITE(forwarded)
 ## SS.REQUEST.INVITE_FORWARDE.TM
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-2.TM','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.ONEPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_1860ABJ_E164',
              'S.FROM-DISPLAYNAME_EXIST',
              'S.FROM-USERINFO_EXIST',
              'S.PRIVACY_EXIST', 
              'S.PRIVACY_VALUE_NONE',
              'S.P-PREF-ID_REMOVED',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ORIGINAL_PREF',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
			],
  },  
  
 # %% 
 #  UA Calee receives INVITE(forwarded)
 ## SS.REQUEST.INVITE_FORWARDE.TM
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-3.TM','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.ONEPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_1860ABJ_E164',
              'S.FROM-DISPLAYNAME_EXIST',
              'S.FROM-USERINFO_EXIST',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ID_GENERATE',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
			],
  }, 
  
 # %% 
 #  PX2 receives INVITE(forwarded)
 ## SS.REQUEST.INVITE_FORWARDE.TM
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-4.TM','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.TWOPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.FROM-DISPLAYNAME_EXIST',
              'S.FROM-USERINFO_EXIST',
              'S.PRIVACY_EXIST', 
              'S.PRIVACY_VALUE_NONE',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ORIGINAL_ASSERT',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
			],
  },   
  
 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-1.PX','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.PX',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_0ABJ_E164',
              'S.FROM-DISPLAYNAME_ANONYMOUS',
              'S.FROM-URI_ANONYMOUS',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_REMOVED',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ORIGINAL_PREF',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },

 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-2.PX','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.PX',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_1840ABJ_E164',
              'S.FROM-DISPLAYNAME_ANONYMOUS',
              'S.FROM-URI_ANONYMOUS',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_REMOVED',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ORIGINAL_PREF',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },

 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-3.PX','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.PX',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_1840ABJ_E164',
              'S.FROM-DISPLAYNAME_ANONYMOUS',
              'S.FROM-URI_ANONYMOUS',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ID_GENERATE',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },
 

 
 # %% 
 #  UA2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-1.TM','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.ONEPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_0ABJ_E164',
              'S.FROM-DISPLAYNAME_ANONYMOUS',
              'S.FROM-URI_ANONYMOUS',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_REMOVED',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_NOEXIST',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },
 
 # %% 
 #  UA2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-2.TM','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.ONEPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_1840ABJ_E164',
              'S.FROM-DISPLAYNAME_ANONYMOUS',
              'S.FROM-URI_ANONYMOUS',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_REMOVED',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_NOEXIST',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },

 # %% 
 #  UA2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-3.TM','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.ONEPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_1840ABJ_E164',
              'S.FROM-DISPLAYNAME_ANONYMOUS',
              'S.FROM-URI_ANONYMOUS',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_NOEXIST',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },
 
 # %% 
 #  UA2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-4.TM','SP:'=>'TTC',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.TWOPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.FROM-DISPLAYNAME_ANONYMOUS',
              'S.FROM-URI_ANONYMOUS',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_NOEXIST',
	       'SS.INITIAL-INVITE.NOEXIST_TTC',
            ]
 },
 
 # %% ALLMesg %%	
 # SIPruleRFC.pm 
 # 20050309 tadokoro
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ALLMesg', 'SP:'=>'TTC',
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
              'S.CNTTYPE_VALID',
              'S.CNTTYPE_APP-SDP',
	      'S.HEADER.LENGTH',
	      'S.HEADER.TIMES',
	      'S.BODY.LENGTH',
            ]
 }, 
  
### tadokoro


 #=================================
 # 
 #=================================

###############################################################
###
### 	1. Via
###	Via
###
###	E.VIA_ONEHOP
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_ONEHOP','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Via: SIP/2.0/UDP %s',
  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
	       return join("\r\nVia: SIP/2.0/UDP ",@CNT_ONEPX_SEND_VIAS);} ]},


###############################################################
###
### 	2. Via
###	Via
###
###	E.VIA_NOHOP
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOHOP','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Via: SIP/2.0/UDP %s',
  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
               return @CNT_NOPX_SEND_VIAS[0];} ]},

###############################################################
###
### 	3. Max-Forwards
###	Max-forwards: 69
###
###	E.MAXFORWARDS_ONEHOP
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.MAXFORWARDS_ONEHOP','PT:'=>HD,'SP:'=>'TTC',
   'FM:'=>'Max-Forwards: %d','AR:'=>[\q{$CNT_CONF{'MAX-FORWARDS'}-1}]},


###############################################################
###
### 	4. Max-Forwards
###	Max-forwards: 70
###
###	E.MAXFORWARDS_NOHOP
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.MAXFORWARDS_NOHOP','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'Max-Forwards: %d','AR:'=>[\q{$CNT_CONF{'MAX-FORWARDS'}}]},


###############################################################
###
### 	6. Contact
###	
###
###	E.CONTACT_URI
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Contact: <%s>','AR:'=>[\'$CNT_PUA_CONTACT_URI']},

### 	6-2. Contact for REGISTER to delete Registration
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI_ASTERISK','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Contact: *' },

###############################################################
###
### 	7. From
###	
###
###	E.FROM_LOCAL-URI_LOCAL-TAG
###
###############################################################	
# 20040203 tadokoro
# From with Display Name if defined($CVA_PUA_DISPNAME)
# {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG','PT:'=>HD, 
#  'FM:'=>'From: %s <%s>;tag=%s','AR:'=>[\q{NDCFG('aor.user','UA11')},\q{NDCFG('aor-uri','UA11')},\q{NINF('DLOG.LocalTag')}]},

# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG.BYE','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'From: %s','AR:'=>[\q{FV('HD.To.txt',@_)}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_PUA-URI_LOCAL-TAG.ACK','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'From: %s<%s>;tag=%s','AR:'=>[\q{$CVA_PUA_DISPNAME?$CVA_PUA_DISPNAME . ' ':''}, \'$CVA_PUA_URI',\q{FV('HD.From.val.param.tag','','LAST')}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_PUA-URI_LOCAL-TAG.ACK.DISP','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'From: %s<%s>;tag=%s','AR:'=>[\q{FV('HD.From.val.ad.disp','','NDFIRST')}, \'$CVA_PUA_URI',\q{FV('HD.From.val.param.tag','','LAST')}]},



# 20040204 tadokoro
# From Anonymous with Display Name 
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_ANONYMOUS-URI_LOCAL-TAG','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'From: Anonymous <sip:anonymous@anonymous.invalid>;tag=%s','AR:'=>[\'$CVA_LOCAL_TAG']},


###############################################################
###
### 	8. To
###	
###
###	E.TO_REMOTE-URI_NO-TAG
###
###############################################################	
# {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_NO-TAG','PT:'=>HD, 'SP:'=>'TTC',
#  'FM:'=>'To: %s <%s>','AR:'=>[\q{$CVA_TUA_DISPNAME?$CVA_TUA_DISPNAME . ' ':''}, \'$CVA_TUA_URI']},

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_NO-TAG','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'To: %s <%s>','AR:'=>[\q{NINF('DisplayName','RemotePeer')?NINF('DisplayName','RemotePeer') . ' ':''}, \q{NINF('LocalAoRURI','RemotePeer')}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_NO-TAG.186','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'To: %s <%s>','AR:'=>[\q{"186".NDCFG('aor.user','UA12')},\q{CutSip(NDCFG('aor-uri','UA12')).":186".CutUsername(NDCFG('aor-uri','UA12'))."@".CutHostname(NDCFG('aor-uri','UA12'))}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_NO-TAG.184','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'To: %s <%s>','AR:'=>[\q{"184".NDCFG('aor.user','UA12')},\q{CutSip(NDCFG('aor-uri','UA12')).":184".CutUsername(NDCFG('aor-uri','UA12'))."@".CutHostname(NDCFG('aor-uri','UA12'))}]},


 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_NO-TAG.186.PX','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'To: %s <%s>','AR:'=>[\q{"186".NDCFG('aor.user','UA21')},\q{CutSip(NDCFG('aor-uri','UA21')).":186".CutUsername(NDCFG('aor-uri','UA21'))."@".CutHostname(NDCFG('aor-uri','UA21'))}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_NO-TAG.184.PX','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'To: %s <%s>','AR:'=>[\q{"184".NDCFG('aor.user','UA21')},\q{CutSip(NDCFG('aor-uri','UA21')).":184".CutUsername(NDCFG('aor-uri','UA21'))."@".CutHostname(NDCFG('aor-uri','UA21'))}]},


# 20040204 tadokoro
# To with Display Name if defined($CVA_TUA_DISPNAME)
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_ANONYMOUS_REMOTE-TAG','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'To: Anonymous <sip:anonymous@anonymous.invalid>;tag=%s','AR:'=>[\q{FV('HD.From.val.param.txt','',NDLAST)}]},


# 20050209 overwrite from SIPrule.pm by tadokoro add $DISPNAME
#  TO URI=TUA TAG=REMOTE
# {'TY:'=>'ENCODE', 'ID:'=>'E.TO_TUA-URI_REMOTE-TAG','PT:'=>HD,'SP:'=>'TTC',
#  'FM:'=>'To: %s<%s>;tag=%s','AR:'=>[\q{$CVA_TUA_DISPNAME?$CVA_TUA_DISPNAME . ' ':''},\'$CVA_TUA_URI',\'$CVA_REMOTE_TAG']},


###############################################################
###
### 	10. Route
###	
###
###	E.ROUTE_ONEURI
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_ONEURI','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Route: <%s>',
  'AR:'=>[\'@CNT_PUA_TWOPX_ROUTESET[1]']},


###############################################################
###
### 	11. Route
###	
###
###	E.ROUTE_TWOURIS
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_TWOURIS','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Route: <%s>',
  'AR:'=>[\q{join(">,<",@{NINF('DLOG.RouteSet#A')})}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_TWOURIS.IP','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Route: %s',
  'AR:'=>[\q{FV('HD.Record-Route.txt','','LAST')}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_TWOURIS.ACK','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Route: %s',
  'AR:'=>[\q{FV('HD.Record-Route.txt','','LAST')}]},


 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_TWOURIS.IP.BYE','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Route: %s',
  'AR:'=>[\q{FV('HD.Record-Route.txt','',NDPKT('','MY','LAST','send'))}]},


###############################################################
###
### 	12. Via
###	
###
###	E.VIA_RETURN_RECEIVED
###
###############################################################	
# 
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_RETURN_RECEIVED','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
	       $vias=FVs('HD.Via.txt',@_);
               $hed=shift(@$vias);
               $host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
               # if(!IsIPAddress($host->[0])){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX2_IPADDRESS;}	# 20050427 usako delete
### 20050427 usako add start ###
				my $str = $host->[0];
				if ($str =~ /^\[(\S+)$\]/) { $str = $1; }
                if(!IsIPAddress($str)){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX2_IPADDRESS;}
### 20050427 usako add end ###
               else{ $hed = 'Via:' . $hed;}
	       map{$hed .= "\r\n" . 'Via:' . $_ } @$vias;
               return $hed;}]},


###############################################################
###
### 	12. Via
###	
###
###	E.VIA_RETURN_RECEIVED_TWOPX.TM
### 20050303 tadokoro
###############################################################	
# 
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_RETURN_RECEIVED_TWOPX.TM','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
	       $vias=FVs('HD.Via.txt',@_);
               $hed=shift(@$vias);
               $host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
               # if(!IsIPAddress($host->[0])){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX1_IPADDRESS;}	# 20050427 usako delete
### 20050427 usako add start ###
				my $str = $host->[0];
				if ($str =~ /^\[(\S+)$\]/) { $str = $1; }
                if(!IsIPAddress($str)){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX1_IPADDRESS;}
### 20050427 usako add end ###
               else{ $hed = 'Via:' . $hed;}
	       map{$hed .= "\r\n" . 'Via:' . $_ } @$vias;
               return $hed;}]},
               
               
###############################################################
###
### 	12-2. Via
###	E.VIA_INVITE-RETURN_RECEIVED
###
###############################################################	
# 
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_INVITE-RETURN_RECEIVED','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
	       $vias=FVib('recv','','','HD.Via.txt','RQ.Request-Line.method','INVITE');
               $hed=shift(@$vias);
               $host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
               # if(!IsIPAddress($host->[0])){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX2_IPADDRESS;}	# 20050427 usako delete
### 20050427 usako add start ###
				my $str = $host->[0];
				if ($str =~ /^\[(\S+)$\]/) { $str = $1; }
                if(!IsIPAddress($str)){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX2_IPADDRESS;}
### 20050427 usako add end ###
               else{ $hed = 'Via:' . $hed;}
	       map{$hed .= "\r\n" . 'Via:' . $_ } @$vias;
               return $hed;}]},

###############################################################
###
### 	12-2. Via
###	E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM
###
###############################################################	
# 
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
	       $vias=FVib('recv','','','HD.Via.txt','RQ.Request-Line.method','INVITE');
               $hed=shift(@$vias);
               $host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
               # if(!IsIPAddress($host->[0])){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX1_IPADDRESS;}	# 20050427 usako delete
### 20050427 usako add start ###
				my $str = $host->[0];
				if ($str =~ /^\[(\S+)$\]/) { $str = $1; }
                if(!IsIPAddress($str)){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX1_IPADDRESS;}
### 20050427 usako add end ###

               else{ $hed = 'Via:' . $hed;}
	       map{$hed .= "\r\n" . 'Via:' . $_ } @$vias;
               return $hed;}]},

###############################################################
###
### 	19. Record-Route
###	Record-Route
###
###	E.RECORDROUTE_TWOHOPS	
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOHOPS','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\q{join(">,<",@{NINF('DLOG.RouteSet#A')})}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOHOPS.IP','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Record-Route: %s, <sip:%s;lr>',
  'AR:'=>[\q{FV('HD.Record-Route.val.txt','','LAST')},\q{NDCFG('address','PX2')}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOHOPS.RETURN','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Record-Route: %s, <%s;lr>',
  'AR:'=>[\q{FV('HD.Record-Route.val.txt','','LAST')},\q{NDCFG('uri','PX2')}]},


###############################################################
###
### 	19-2. Record-Route
###	Record-Route
###
###	E.RECORDROUTE_ONEHOP    2005/01/11 by Mizusawa
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_ONEHOP','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Record-Route: <%s>',
  'AR:'=> [\q{@CNT_PUA_TWOPX_ROUTESET[0]}]},


###############################################################
###
### 	19-3. Record-Route
###	Record-Route
###
###	E.RECORDROUTE_ASIS    2005/01/11 by Mizusawa
###	                      2005/02/25 by tadokoro
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_ASIS','PT:'=>HD, 'SP:'=>'TTC',
  'PR:'=>\'FFIsExistHeader("Record-Route",@_)',
  'FM:'=>'Record-Route: <%s>',
  'AR:'=> [\q{join('>,<', @{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)})}]},


# 20050224 tadokoro 
# Record-Route 
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORD-ROUTE_ADD-PROXY-URI','PT:'=>HD, 'SP:'=>'TTC',
  'PR:'=>\'FFIsExistHeader("Record-Route",@_)',
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[sub {
		my @string = ($CNT_PUA_TWOPX_ROUTESET[0] , @{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)});
		return ($string[1] eq '')?($string[0]):(join('>,<',@string));
		}]},
		

###############################################################
###
### 	20. Route
###	Route
###
###	E.ROUTE_TWOURIS_REVERSE	
###
###############################################################	
# Route
 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_TWOURIS_REVERSE','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Route: <%s>',
  'AR:'=>[\q{join(">,<",reverse(@CNT_PUA_TWOPX_ROUTESET))}]},


## add 05/01/05 cats
# Body (SDP o line version not increment)
#   for INVITE with Proxy-Authorization
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID_SAME_VERSION','PT:'=>BD,'SP:'=>'TTC',
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".$CNT_PUA_SDP_O_SESSION." %s IN IP6 ".$CVA_PUA_IPADDRESS."\r\n".
       "s=-\r\n".
       "c=IN IP6 ".$CVA_PUA_IPADDRESS."\r\n".
       "t=0 0\r\n".
       "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n".
       "a=rtpmap:0 PCMU/8000"},
  'AR:'=>[\'$CNT_PUA_SDP_O_VERSION']
},


# REGISTER
# 
# 	-->	E.REGISTER_RG-URI

# REGISTER Request-URI = SIP-URI of Registrar
 {'TY:'=>'ENCODE', 'ID:'=>'E.REGISTER_RG-URI','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'REGISTER sip:%s:%s SIP/2.0','AR:'=>[\q{$CNT_CONF{'REG-HOSTNAME'}}, \'$CNT_PX1_PORT']},

# Expires
# 
#	-->	E.EXPIRES_VALID

# Expires header
 {'TY:'=>'ENCODE', 'ID:'=>'E.EXPIRES_VALID','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'Expires: %s', 'AR:'=>[\q{$CNT_CONF{'EXPIRES'}}] },

# Expires header
 {'TY:'=>'ENCODE', 'ID:'=>'E.EXPIRES_ZERO','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'Expires: 0' },

# Authorization
# 
# $CNT_AUTH_URI_RG 
# 	-->	E.AUTH_RESPONSE_VALID

# Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.AUTH_RESPONSE_QOP','PT:'=>HD,'SP:'=>'TTC',
  'PR:'=>\q{FVib('recv','','','HD.WWW-Authenticate.val.digest.qop','RQ.Status-Line.code','401') eq '"auth"'},
  'FM:'=>"Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"sip:%s:%s\", response=%s",
  'AR:'=>[ \'$CNT_AUTH_USRNAME',     # username
           \'$CNT_AUTH_REALM_RG',    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
	   \q{$CNT_CONF{'REG-HOSTNAME'}},
	   \'$CNT_PX1_PORT',
           \q{OpCalcAuthorizationResponse3('WWW-Authenticate','REGISTER',$CNT_AUTH_USRNAME,
					   "sip:$CNT_CONF{'REG-HOSTNAME'}:$CNT_PX1_PORT",
					   $CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_[0],
					   PKT('LAST','recv','RQ.Status-Line.code','401'),@_[2])},
         ] },
 {'TY:'=>'ENCODE', 'ID:'=>'E.AUTH_RESPONSE_NOQOP','PT:'=>HD,'SP:'=>'TTC',
  'PR:'=>\q{FVib('recv','','','HD.WWW-Authenticate.val.digest.qop','RQ.Status-Line.code','401') ne '"auth"'},
  'FM:'=>"Authorization: Digest username=%s, realm=%s, nonce=%s, opaque=%s, uri=\"sip:%s:%s\", response=%s",
  'AR:'=>[ \'$CNT_AUTH_USRNAME',     # username
           \'$CNT_AUTH_REALM_RG',    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
	   \q{$CNT_CONF{'REG-HOSTNAME'}},
	   \'$CNT_PX1_PORT',
           \q{OpCalcAuthorizationResponse3('WWW-Authenticate','REGISTER',$CNT_AUTH_USRNAME,
                                           "sip:$CNT_CONF{'REG-HOSTNAME'}:$CNT_PX1_PORT",
                                           $CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'noauth',@_[0],
                                           PKT('LAST','recv','RQ.Status-Line.code','401'),@_[2])},
         ] },

# Proxy-Authorization
# Proxy-Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_QOP','PT:'=>HD,'SP:'=>'TTC',
  'PR:'=>\q{FVib('recv','','','HD.Proxy-Authenticate.val.digest.qop','RQ.Status-Line.code','407') eq '"auth"'},
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \'$CNT_AUTH_USRNAME',     # username
           \'$CNT_AUTH_REALM',       # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \'$CVA_TUA_URI',          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',$CNT_AUTH_USRNAME,$CVA_TUA_URI,$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_[0],PKT('LAST','recv','RQ.Status-Line.code','407'),@_[2])},
         ] },
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_NOQOP','PT:'=>HD,'SP:'=>'TTC',
  'PR:'=>\q{FVib('recv','','','HD.Proxy-Authenticate.val.digest.qop','RQ.Status-Line.code','407') ne '"auth"'},
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, nonce=%s, opaque=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \'$CNT_AUTH_USRNAME',     # username
           \'$CNT_AUTH_REALM',       # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CVA_TUA_URI',          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',$CNT_AUTH_USRNAME,$CVA_TUA_URI,$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'noauth',@_[0],PKT('LAST','recv','RQ.Status-Line.code','407'),@_[2])},
         ] },


#20050118 
# Proxy-Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_VALID','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \'$CNT_AUTH_USRNAME',     # username
           \'$CNT_AUTH_REALM',       # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \'$CVA_TUA_URI',          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',$CNT_AUTH_USRNAME,$CVA_TUA_URI,$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_)},
         ] },

#add 20050114 2
# 2nd Proxy-Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_VALID_2ND','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \'$CNT_AUTH_USRNAME',     # username
           \'$CNT_AUTH_REALM2',      # realm  20050114 2
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \'$CVA_TUA_URI',          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',$CNT_AUTH_USRNAME,$CVA_TUA_URI,$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_)},
         ] },

#20050118  2
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_VALID_READ','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'Proxy-Authorization: %s', 'AR:'=>[\q{FVib('send','','','HD.Proxy-Authorization.val.txt','RQ.Request-Line.method','INVITE')}] },



## 20050119 
## UA
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_VALID_ACK','PT:'=>HD, 'SP:'=>'TTC',
  'FM:'=>'Proxy-Authorization: %s',
  'AR:'=>[\q{join("\r\nProxy-Authorization:", @{FVib('send','','',"HD.Proxy-Authorization.val.txt",'RQ.Request-Line.method','INVITE')})}]},



# INVITE
# 
#	-->	E.INVITE_AOR-URI

# INVITE Request-URI=AoR(Address-of-record)
# {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URI','PT:'=>RQ,'SP:'=>'TTC',
#  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[\q{NDCFG('aor-uri','UA12')}]},
# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URI.186','PT:'=>RQ,
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[\q{CutSip(NDCFG('aor-uri','UA12')).":186".CutUsername(NDCFG('aor-uri','UA12'))."@".CutHostname(NDCFG('aor-uri','UA12'))}]},
# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URI.184','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[\q{CutSip(NDCFG('aor-uri','UA12')).":184".CutUsername(NDCFG('aor-uri','UA12'))."@".CutHostname(NDCFG('aor-uri','UA12'))}]},
# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URI.PX','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[\q{NDCFG('aor-uri','UA21')}]},
# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URI.186.PX','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[\q{CutSip(NDCFG('aor-uri','UA21')).":186".CutUsername(NDCFG('aor-uri','UA21'))."@".CutHostname(NDCFG('aor-uri','UA21'))}]},
# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URI.184.PX','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[\q{CutSip(NDCFG('aor-uri','UA21')).":184".CutUsername(NDCFG('aor-uri','UA21'))."@".CutHostname(NDCFG('aor-uri','UA21'))}]},

# ACK Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_AOR-URI','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[\'$CVA_TUA_URI']},

# ACK Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_AOR-URI.184.UA11toUA12','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[\q{CutSip(NDCFG('aor-uri','UA12')).":184".CutUsername(NDCFG('aor-uri','UA12'))."@".CutHostname(NDCFG('aor-uri','UA12'))}]},

# ACK Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_AOR-URI.186.UA11toUA12','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[\q{CutSip(NDCFG('aor-uri','UA12')).":186".CutUsername(NDCFG('aor-uri','UA12'))."@".CutHostname(NDCFG('aor-uri','UA12'))}]},

# ACK Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_AOR-URI.184.UA11toUA21','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[\q{CutSip(NDCFG('aor-uri','UA21')).":184".CutUsername(NDCFG('aor-uri','UA21'))."@".CutHostname(NDCFG('aor-uri','UA21'))}]},

# ACK Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_AOR-URI.186.UA11toUA21','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[\q{CutSip(NDCFG('aor-uri','UA21')).":186".CutUsername(NDCFG('aor-uri','UA21'))."@".CutHostname(NDCFG('aor-uri','UA21'))}]},


# REGISTER
# 
#	-->	E.CSEQ_NUM_REGISTER

#  CSEQ NUM=LOCAL-NUM Method=INVITE
 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ_NUM_REGISTER','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'CSeq: %s REGISTER','AR:'=>[\q{++$CVA_LOCAL_CSEQ_NUM}]},



# 20050208 tadokoro
# INVITE Request-URI=E.164 (AoR=0ABJ to E.164)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_E164-URI','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[sub {my $string = $CVA_TUA_URI; $string =~ s/sip:0/sip:+81/; return $string;}]},

# 20050208 tadokoro
# INVITE Request-URI=E.164 (AoR=0ABJ to E.164)
#  ACK Request-URI=CONTACT (After dialog)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_E164-URI','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[sub {my $string = $CVA_TUA_URI; $string =~ s/sip:0/sip:+81/; return $string;}]},

  
# 20050203 tadokoro
# PRIVACY 
 {'TY:'=>'ENCODE', 'ID:'=>'E.PRIVACY_NONE','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'Privacy: none',},

# 20050203 tadokoro
# PRIVACY 
 {'TY:'=>'ENCODE', 'ID:'=>'E.PRIVACY_ID','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'Privacy: id',},

# 20050203 tadokoro
# P-Preferred-Identity 
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-PREFERRED-IDENTITY','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'P-Preferred-Identity: %s','AR:'=>[ sub {
		my $tempString = $CVA_PUA_URI;
		$tempString =~ s/sip:0/tel:+81/;
		$tempString =~ s/@.*$//;
		return "$CVA_PUA_DISPNAME <$CVA_PUA_URI>\r\nP-Preferred-Identity: $CVA_PUA_DISPNAME <$tempString>";}]},

# 20050203 tadokoro
# P-Preferred-Identity 
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-PREFERRED-IDENTITY_ANONYMOUS','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'P-Preferred-Identity: %s','AR:'=>[ sub {
		my $tempString = $CVA_PUA_URI;
		$tempString =~ s/sip:0/tel:+81/;
		$tempString =~ s/@.*$//;
		return "Anonymous <$CVA_PUA_URI>\r\nP-Preferred-Identity: $CVA_PUA_DISPNAME <$tempString>";}]},


# 20050203 tadokoro
# P-Asserted-Identity 
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-ASSERTED-IDENTITY','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'P-Asserted-Identity: %s','AR:'=>[sub {
		my $tempString = $CVA_PUA_URI;
		$tempString =~ s/sip:0/tel:+81/;
		$tempString =~ s/@.*$//;
		return "$CVA_PUA_DISPNAME <$CVA_PUA_URI>\r\nP-Asserted-Identity: $CVA_PUA_DISPNAME <$tempString>";}]},


# 20050203 tadokoro
# P-Asserted-Identity 
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-ASSERTED-IDENTITY_ANONYMOUS','PT:'=>HD,'SP:'=>'TTC',
  'FM:'=>'P-Asserted-Identity: %s','AR:'=>[sub {
		my $tempString = $CVA_PUA_URI;
		$tempString =~ s/sip:0/tel:+81/;
		$tempString =~ s/@.*$//;
		return "Anonymous <$CVA_PUA_URI>\r\nP-Asserted-Identity: $CVA_PUA_DISPNAME <$tempString>";}]},

# 20050309 tadokoro
# a=sendonly 
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID_SENDONLY','PT:'=>BD,'SP:'=>'TTC',
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".$CNT_PUA_SDP_O_SESSION." %s IN IP6 ".$CVA_PUA_IPADDRESS."\r\n".
       "s=-\r\n".
       "c=IN IP6 ".$CVA_PUA_IPADDRESS."\r\n".
       "t=0 0\r\n".
       "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=sendonly"},
  'AR:'=>[sub{$CNT_PUA_SDP_O_VERSION++;
          return $CNT_PUA_SDP_O_VERSION;
         }]
},

### 20050406 usako add start ###
 # for invite-request (override)
 {'TY:'=>'ENCODE', 'ID:'=>'E.SUPPORTED_VALID', 'PT:'=>HD,'SP:'=>'TTC',
  'FM:'=> 'Supported: %s',
  'AR:'=> [ \q{ $CNT_CONF{'PX-SUPPORTED'} } ],
 },

 # for response
 {'TY:'=>'ENCODE', 'ID:'=>'E.RES.SUPPORTED_VALID', 'PT:'=>HD,'SP:'=>'TTC',
  'FM:'=> 'Supported: %s',
  'AR:'=> [ \q{ FV('HD.Supported.txt', @_) } ],
 },
### 20050406 usako add end ###


 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZATION_NOEXIST_TTC', 'CA:' => 'Authorization','SP:' => 'TTC',
   'OK:' => 'A Authorization header field MUST NOT exist in this message.',
   'NG:' => 'A Authorization header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Authorization",@_)},
   'EX:' => \q{!FFIsExistHeader("Authorization",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTENT-DISPOSITION_NOEXIST_TTC', 'CA:' => 'Content-Disposition','SP:' => 'TTC',
   'OK:' => 'A Content-Disposition header field MUST NOT exist in this message.',
   'NG:' => 'A Content-Disposition header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Content-Disposition",@_)},
   'EX:' => \q{!FFIsExistHeader("Content-Disposition",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTENT-ENCODING_NOEXIST_TTC', 'CA:' => 'Content-Encoding','SP:' => 'TTC',
   'OK:' => 'A Content-Encoding header field MUST NOT exist in this message.',
   'NG:' => 'A Content-Encoding header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Content-Encoding",@_)},
   'EX:' => \q{!FFIsExistHeader("Content-Encoding",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTENT-LANGUAGE_NOEXIST_TTC', 'CA:' => 'Content-Language','SP:' => 'TTC',
   'OK:' => 'A Content-Language header field MUST NOT exist in this message.',
   'NG:' => 'A Content-Language header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Content-Language",@_)},
   'EX:' => \q{!FFIsExistHeader("Content-Language",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTENT-TYPE_NOEXIST_TTC', 'CA:' => 'Content-Type','SP:' => 'TTC',
   'OK:' => 'A Content-Type header field MUST NOT exist in this message.',
   'NG:' => 'A Content-Type header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Content-Type",@_)},
   'EX:' => \q{!FFIsExistHeader("Content-Type",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MIME-VERSION_NOEXIST_TTC', 'CA:' => 'MIME-Version','SP:' => 'TTC',
   'OK:' => 'A MIME-Version header field MUST NOT exist in this message.',
   'NG:' => 'A MIME-Version header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("MIME-Version",@_)},
   'EX:' => \q{!FFIsExistHeader("MIME-Version",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PRIVACY_NOEXIST_TTC', 'CA:' => 'Privacy','SP:' => 'TTC',
   'OK:' => 'A Privacy header field MUST NOT exist in this message.',
   'NG:' => 'A Privacy header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Privacy",@_)},
   'EX:' => \q{!FFIsExistHeader("Privacy",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PROXY-AUTHORICATION_NOEXIST_TTC', 'CA:' => 'Proxy-Authorication','SP:' => 'TTC',
   'OK:' => 'A Proxy-Authorication header field MUST NOT exist in this message.',
   'NG:' => 'A Proxy-Authorication header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Proxy-Authorication",@_)},
   'EX:' => \q{!FFIsExistHeader("Proxy-Authorication",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MESSAGEBODY_NOEXIST_TTC', 'CA:' => 'Body','SP:' => 'TTC',
   'OK:' => 'The body field MUST NOT exist in this message.',
   'NG:' => 'The body field MUST NOT exist in this message.',
   'PR:' => \q{length(FV('BD.txt', @_)) > 0},
   'EX:' => \q{length(FV('BD.txt', @_)) == 0}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERTED-IDENTITY_NOEXIST_TTC', 'CA:' => 'P-Asserted-Identity','SP:' => 'TTC',
   'OK:' => 'A P-Asserted-Identity header field MUST NOT exist in this message.',
   'NG:' => 'A P-Asserted-Identity header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("P-Asserted-Identity",@_)},
   'EX:' => \q{!FFIsExistHeader("P-Asserted-Identity",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-PREFERRED-IDENTITY_NOEXIST_TTC', 'CA:' => 'P-Preferred-Identity','SP:' => 'TTC',
   'OK:' => 'A P-Preferred-Identity header field MUST NOT exist in this message.',
   'NG:' => 'A P-Preferred-Identity header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("P-Preferred-Identity",@_)},
   'EX:' => \q{!FFIsExistHeader("P-Preferred-Identity",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT_NOEXIST_TTC', 'CA:' => 'Accept','SP:' => 'TTC',
   'OK:' => 'A Accept header field MUST NOT exist in this message.',
   'NG:' => 'A Accept header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Accept",@_)},
   'EX:' => \q{!FFIsExistHeader("Accept",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT-ENCODING_NOEXIST_TTC', 'CA:' => 'Accept-Encoding','SP:' => 'TTC',
   'OK:' => 'A Accept-Encoding header field MUST NOT exist in this message.',
   'NG:' => 'A Accept-Encoding header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Accept-Encoding",@_)},
   'EX:' => \q{!FFIsExistHeader("Accept-Encoding",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT-LANGUAGE_NOEXIST_TTC', 'CA:' => 'Accept-Language','SP:' => 'TTC',
   'OK:' => 'A Accept-Language header field MUST NOT exist in this message.',
   'NG:' => 'A Accept-Language header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Accept-Language",@_)},
   'EX:' => \q{!FFIsExistHeader("Accept-Language",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ALLOW_NOEXIST_TTC', 'CA:' => 'Allow','SP:' => 'TTC',
   'OK:' => 'A Allow header field MUST NOT exist in this message.',
   'NG:' => 'A Allow header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Allow",@_)},
   'EX:' => \q{!FFIsExistHeader("Allow",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHENTICATION-INFO_NOEXIST_TTC', 'CA:' => 'Authentication-Info','SP:' => 'TTC',
   'OK:' => 'A Authentication-Info header field MUST NOT exist in this message.',
   'NG:' => 'A Authentication-Info header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Authentication-Info",@_)},
   'EX:' => \q{!FFIsExistHeader("Authentication-Info",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PROXY-AUTHENTICATE_NOEXIST_TTC', 'CA:' => 'Proxy-Authenticate','SP:' => 'TTC',
   'OK:' => 'A Proxy-Authenticate header field MUST NOT exist in this message.',
   'NG:' => 'A Proxy-Authenticate header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Proxy-Authenticate",@_)},
   'EX:' => \q{!FFIsExistHeader("Proxy-Authenticate",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.UNSUPPORTED_NOEXIST_TTC', 'CA:' => 'Unsupported','SP:' => 'TTC',
   'OK:' => 'A Unsupported header field MUST NOT exist in this message.',
   'NG:' => 'A Unsupported header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Unsupported",@_)},
   'EX:' => \q{!FFIsExistHeader("Unsupported",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTHENTICATE_NOEXIST_TTC', 'CA:' => 'WWW-Authenticate','SP:' => 'TTC',
   'OK:' => 'A WWW-Authenticate header field MUST NOT exist in this message.',
   'NG:' => 'A WWW-Authenticate header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("WWW-Authenticate",@_)},
   'EX:' => \q{!FFIsExistHeader("WWW-Authenticate",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_NOEXIST_TTC', 'CA:' => 'Route','SP:' => 'TTC',
   'OK:' => 'A Route header field MUST NOT exist in this message.',
   'NG:' => 'A Route header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Route",@_)},
   'EX:' => \q{!FFIsExistHeader("Route",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RECORD-ROUTE_NOEXIST_TTC', 'CA:' => 'Record-Route','SP:' => 'TTC',
   'OK:' => 'A Record-Route header field MUST NOT exist in this message.',
   'NG:' => 'A Record-Route header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Record-Route",@_)},
   'EX:' => \q{!FFIsExistHeader("Record-Route",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SUBJECT_NOEXIST_TTC', 'CA:' => 'Subject','SP:' => 'TTC',
   'OK:' => 'A Subject header field MUST NOT exist in this message.',
   'NG:' => 'A Subject header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Subject",@_)},
   'EX:' => \q{!FFIsExistHeader("Subject",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PROXY-REQUIRE_NOEXIST_TTC', 'CA:' => 'Subject','SP:' => 'TTC',
   'OK:' => 'A Proxy-Require header field MUST NOT exist in this message.',
   'NG:' => 'A Proxy-Require header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Proxy-Require",@_)},
   'EX:' => \q{!FFIsExistHeader("Proxy-Require",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PROXY-AUTHORIZATION_NOEXIST_TTC', 'CA:' => 'Subject','SP:' => 'TTC',
   'OK:' => 'A Proxy-Authorization header field MUST NOT exist in this message.',
   'NG:' => 'A Proxy-Authorization header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Proxy-Authorization",@_)},
   'EX:' => \q{!FFIsExistHeader("Proxy-Authorization",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE_NOEXIST_TTC', 'CA:' => 'Subject','SP:' => 'TTC',
   'OK:' => 'A Require header field MUST NOT exist in this message.',
   'NG:' => 'A Require header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("Require",@_)},
   'EX:' => \q{!FFIsExistHeader("Require",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTHENTICATION-INFO_NOEXIST_TTC', 'CA:' => 'Subject','SP:' => 'TTC',
   'OK:' => 'A WWW-Authentication-Info header field MUST NOT exist in this message.',
   'NG:' => 'A WWW-Authentication-Info header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("WWW-Authentication-Info",@_)},
   'EX:' => \q{!FFIsExistHeader("WWW-Authentication-Info",@_)}},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-PREFERRED_NOEXIST_TTC', 'CA:' => 'Subject','SP:' => 'TTC',
   'OK:' => 'A P-Preferred-Identity header field MUST NOT exist in this message.',
   'NG:' => 'A P-Preferred-Identity header field MUST NOT exist in this message.',
   'PR:' => \q{FFIsExistHeader("P-Preferred-Identity",@_)},
   'EX:' => \q{!FFIsExistHeader("P-Preferred-Identity",@_)}},


 #=================================
 # 
 #=================================

###	


###############################################################
###
### 	1. INVITE
###	ES.REQUEST.INVITE.PX
###
###############################################################	


# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
	'E.RECORDROUTE_ONEHOP', # Miz
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



###############################################################
###
### 	2. 180
###	ES.STATUS.180.TM
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.180.ONEPX.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_TWOHOPS',#
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

###############################################################
###
### 	2-1. 180
###	ES.STATUS.180.TWOPX.TM
### 20050303 tadokoro
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.180.TWOPX.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA_RETURN_RECEIVED_TWOPX.TM',
	'E.RECORDROUTE_ASIS',#
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},
  

###############################################################
###
### 	3. 200
###	ES.STATUS.200-SDP-ANS.TM
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.ONEPX.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
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

###############################################################
###
### 	3. 200
###	ES.STATUS.200-SDP-ANS.TWOPX.TM
### 20050303 tadokoro
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.TWOPX.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED_TWOPX.TM',
	'E.RECORDROUTE_ASIS',	#
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',	#
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},
  
###############################################################
###
### 	4. 2xx
###	ES.REQUEST.ACK-2XX.PX
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_ONEHOP',	#
	'E.MAXFORWARDS_ONEHOP',	#
        'E.ROUTE_ONEURI',
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


###############################################################
###
### 	5. BYE
###	ES.REQUEST.BYE.TM
###
###############################################################	
# BYE TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.NUMBER-NOTIFICATION.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.BYE_CONTACT-URI.NUMBER-NOTIFICATION',
	'E.VIA_NOHOP',# 
	'E.MAXFORWARDS_NOHOP',# 
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG.BYE',# 
	'E.TO_TUA-URI_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},



###############################################################
###
### 	6. 200
###	ES.STATUS.200.PX
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
        'E.RECORDROUTE_ASIS',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

###############################################################
###
### 	6-1-1. 480
###	ES.STATUS-480-RETURN
###     Used by Proxy
### 
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-480-RETURN.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-480',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

###############################################################
###
### 	6-1-2. 480
###	ES.STATUS-480-RETURN
###     Used by TM
### 20050310 tadokoro modify
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-480-RETURN.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-480',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

###############################################################
###
### 	6-2-1. 486
###	ES.STATUS-486-RETURN
###     Used by Proxy
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-486-RETURN.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-486',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},
  
###############################################################
###
### 	6-2-2. 486
###	ES.STATUS-486-RETURN
###     Used by TM
### 20050310 tadokoro modify
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-486-RETURN.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-486',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

###############################################################
###
### 	6-3-1. 487
###	ES.STATUS-487-RETURN
###     Used by Proxy
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-487-RETURN.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-487',
	'E.VIA_INVITE-RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

###############################################################
###
### 	6-3-2. 487
###	ES.STATUS-487-RETURN
###     Used by TM and Proxy
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-487-RETURN.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-487',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},
  
###############################################################
###
### 	6. 200
###	ES.STATUS.200.PX
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-CANCEL-RETURN.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

###############################################################
###
### 	6. 200
###	E.STATUS-200-RETURN-TWOPX.PX2
### 20050303 tadokoro
###############################################################	
# 200  ALL-RETURN-TWOPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-BYE-RETURN.TWOPX.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORD-ROUTE_ADD-PROXY-URI',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


###############################################################
###
### 	7. 100
###	ES.STATUS.100.TM
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.100.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-100',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},




###############################################################
###
### 	8. 200
###	ES.STATUS.200.TM
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200.ONEPX.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_ASIS',  ###add 20050113 
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

###############################################################
###
### 	8. 200
###	ES.STATUS.200.TWOPX.TM
### 20050306 tadokoro
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200.TWOPX.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED_TWOPX.TM',
	'E.RECORDROUTE_ASIS',  ###add 20050113 
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

# TTC-2-1-3 BYE-200
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200.TWOPX.TM.RR-IP', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED_TWOPX.TM',
	'E.RECORDROUTE_TWOHOPS.IP',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


###############################################################
###
### 	9. 2xx
###	ES.REQUEST.ACK-2XX.TM
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS', # 20050111
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.TM.FROM-ANONYMOUS', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS', # 20050111
        'E.FROM_ANONYMOUS-URI_LOCAL-TAG', 
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.TM.TTC', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS.ACK', # 20050111
	'E.FROM_PUA-URI_LOCAL-TAG.ACK.DISP',#
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.TM.TTC.ROUTE-IP', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS.IP', # 20050111
	'E.FROM_PUA-URI_LOCAL-TAG.ACK.DISP',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},



#add 2004_12_28 
###############################################################
###
### 	10. 
###	ES.REQUEST.ACK-NO2XX.TM
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_AOR-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.TM.TTC', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_AOR-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_PUA-URI_LOCAL-TAG.ACK.DISP',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.TM.FROM-ANONYMOUS', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_AOR-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
        'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.186.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_AOR-URI.186.UA11toUA12',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.184.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_AOR-URI.184.UA11toUA12',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.184.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_AOR-URI.184.UA11toUA21',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_PUA-URI_LOCAL-TAG.ACK',#
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.186.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_AOR-URI.186.UA11toUA21',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},



#add 2004_12_28 
###############################################################
###
### 	11. BYE
###	ES.REQUEST.BYE.PX
###
###############################################################	
# BYE TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
        'E.ROUTE_ONEURI',
#        'E.RECORDROUTE_ONEHOP', # 20050304 add tadokoro	# 20050420 usako delete
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_REMOTE-URI_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.PX.TTC', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
#	'E.ROUTE_TWOURIS.BYE',
        'E.ROUTE_ONEURI',
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_REMOTE-URI_REMOTE-TAG.BYE',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.PX.TTC.RR-IP', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
	'E.ROUTE_TWOURIS.IP.BYE',
#        'E.ROUTE_ONEURI',
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_REMOTE-URI_REMOTE-TAG.BYE',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.PX.UA21', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
        'E.ROUTE_ONEURI',
#        'E.RECORDROUTE_ONEHOP', # 20050304 add tadokoro	# 20050420 usako delete
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_REMOTE-URI_REMOTE-TAG.BYE',# 

	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.PX.UA21.FROM186', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
        'E.ROUTE_ONEURI',
#        'E.RECORDROUTE_ONEHOP', # 20050304 add tadokoro	# 20050420 usako delete
	'E.FROM_LOCAL-URI_LOCAL-TAG.BYE',# 
	'E.TO_REMOTE-URI_REMOTE-TAG.BYE',# 

	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# BYE TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.TM.TTC.METHOD2', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_NOHOP',# 
	'E.MAXFORWARDS_NOHOP',# 
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG.BYE',# 
	'E.TO_TUA-URI_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


###############################################################
###     20050114 
### 	12. 100
###	ES.STATUS.100.PX
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.100.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-100',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},



###############################################################
###     20050114 
### 	13. 180
###	ES.STATUS.180.PX
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.180.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_TWOHOPS',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.180.PX.RETURN', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_TWOHOPS.RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


###############################################################
###     20050114 
### 	14. 200
###	ES.STATUS.200-SDP-ANS.PX
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
        'E.RECORDROUTE_TWOHOPS',	
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',       
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.PX.RETURN', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
        'E.RECORDROUTE_TWOHOPS.RETURN',	
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',       
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},


# TTC-2-1-3 Record-Route is IP addr
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.PX.RR-IP', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
        'E.RECORDROUTE_TWOHOPS.IP',	
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',       
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},


###############################################################
###
### 	15. REGISTER
###
###############################################################	

# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	#'E.CONTACT_URI',
	'E.CONTACT_URI_REGISTER', ## 2006.2.1 sawada add transport parameter header field ## 
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


###############################################################
###     20050119 
### 	16. 2xx
###	ES.REQUEST.ACK-2XX-AUTH.TM
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX-AUTH.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
        'E.P-AUTH_RESPONSE_VALID_ACK',
        'E.ROUTE_TWOURIS', 
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},



# REGISTER request with Authorization
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
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
	#'E.CONTACT_URI',
	'E.CONTACT_URI_REGISTER', ## 2006.2.1 sawada add transport parameter header field ## 
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request without Contact
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.GETCONTACT.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# REGISTER request without Contact with Authorization
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.GETCONTACT.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
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
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request with Expires: 0
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.DELREG.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_ASTERISK',
	'E.EXPIRES_ZERO',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request with Expires: 0 with Authorization
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.DELREG.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
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
	'E.EXPIRES_ZERO',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
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
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},


## modify 05/01/05 cats
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
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
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},

# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.RE-INVITE-AUTH.WITH-ROUTE.TM', 'MD:'=>SEQ,'SP:'=>'TTC', 
  'RR:'=>[
	'E.INVITE_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.ROUTE_TWOURIS',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SAME_VERSION',
	  'SS.RE-INVITE.NOEXIST_TTC',
	  ],  ## ADD
  'EX:' =>\&MargeSipMsg},


## 20050316 tadokoro
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_ONEHOP',
        'E.RECORDROUTE_ONEHOP',	
	'E.MAXFORWARDS_ONEHOP',
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
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},


#############################################################################################################
##
##                                     
##
## 2
## PX-1-1-1-4
#############################################################################################################          
##  2005/01/18 ichikawa ( 1
# INVITE request with double Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH-DOUBLE.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.P-AUTH_RESPONSE_VALID_READ',     ###20050118  1
#################################################################
        'E.P-AUTH_RESPONSE_VALID',  ###Proxy2
#################################################################

	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SAME_VERSION'],  
  'EX:' =>\&MargeSipMsg},

###20050118   407
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-407-RETURN-AUTH-2VIA.PX1', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-407',
	'E.VIA_RETURN_RECEIVED',
	'E.PX-AUTHENTICATE_VALID2', 
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# INVITE request for HOLD sent by TM
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM.HOLD', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SENDONLY', # 20050317 add tadokoro
	],
  'EX:' =>\&MargeSipMsg},
  
# INVITE request with AUTH for HOLD sent by TM
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM.HOLD.AUTH', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.ROUTE_TWOURIS',
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SENDONLY', # 20050317 add tadokoro
	],
  'EX:' =>\&MargeSipMsg},
  
# INVITE request for HOLD Release sent by TM
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM.HOLD-RELEASE', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
#	'E.BODY_VALID_HOLD2'], # Not Yet for Body by Miz
  'EX:' =>\&MargeSipMsg},
  
# INVITE request for HOLD Release sent by TM
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM.HOLD-RELEASE.AUTH', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.ROUTE_TWOURIS',
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},
  
# INVITE request for HOLD sent by PX
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.PX.HOLD', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
	'E.ROUTE_ONEURI',
	'E.RECORDROUTE_ONEHOP', # tadokoro
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SENDONLY',], # 20050309 tadokoro
  'EX:' =>\&MargeSipMsg},

# INVITE request for HOLD Release sent by PX
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.PX.HOLD-RELEASE', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
        'E.ROUTE_ONEURI',
	'E.RECORDROUTE_ONEHOP', # tadokoro
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# 200 response for Re-INVITE (HOLD) sent by TM
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS-HOLD.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED_TWOPX.TM', # 20050309 tadokoro
        'E.RECORDROUTE_ASIS',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'], # Not Yet for Body by Miz
  'EX:'=>\q{MargeSipMsg(@_)}},

# 200 response for Re-INVITE (HOLDREL) sent by TM
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS-HOLDREL.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED_TWOPX.TM', # 20050309 tadokoro
        'E.RECORDROUTE_ASIS',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'], # Not Yet for Body by Miz
  'EX:'=>\q{MargeSipMsg(@_)}},

# 200 response for Re-INVITE (HOLD) sent by PX
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS-HOLD.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORD-ROUTE_ADD-PROXY-URI', # 20050224 add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'], # Not Yet for Body by Miz
  'EX:'=>\q{MargeSipMsg(@_)}},

# 200 response for Re-INVITE (HOLDREL) sent by PX
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS-HOLDREL.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORD-ROUTE_ADD-PROXY-URI', # 20050224 add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'], # Not Yet for Body by Miz
  'EX:'=>\q{MargeSipMsg(@_)}},


# CANCEL send by TM
 {'TY:'=>'RULESET', 'ID:'=>'ES.CANCEL.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
        'E.CANCEL_TUA-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_CANCEL',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# CANCEL send by PX
 {'TY:'=>'RULESET', 'ID:'=>'ES.CANCEL.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.CANCEL_TUA-URI',
        'E.VIA_TWOPX-CANCEL',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_CANCEL',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 20050208 tadokoro
# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE_E164.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_E164-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
	'E.RECORDROUTE_ONEHOP', 
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
        'E.PRIVACY_NONE',
        'E.P-ASSERTED-IDENTITY',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# 20050208 tadokoro
# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE_E164-FROM_ANONYMOUS.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_E164-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
	'E.RECORDROUTE_ONEHOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
        'E.PRIVACY_ID',
        'E.P-ASSERTED-IDENTITY_ANONYMOUS',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},
  
  
## tadokoro ##########################################
# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE.METHOD1.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
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
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_NONE',
	'E.P-PREFERRED-IDENTITY',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE.METHOD1.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_NONE',
	'E.P-PREFERRED-IDENTITY',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},


# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE.METHOD2.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.186',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.186',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_NONE',
	'E.P-PREFERRED-IDENTITY',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE.METHOD2.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.186.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.186.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_NONE',
	'E.P-PREFERRED-IDENTITY',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},


# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE.METHOD3.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.186',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.186',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE.METHOD3.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.186.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.186.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_ID.METHOD3.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_ID-AUTH.METHOD3.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_ID.METHOD4.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_ID-AUTH.METHOD4.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},



# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE-AUTH.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.186.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.186.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},


## tadokoro ##########################################
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE-AUTH.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
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
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_NONE',
	'E.P-PREFERRED-IDENTITY',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},

# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE-AUTH.METHOD1.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.PX',
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
	'E.PRIVACY_NONE',
	'E.P-PREFERRED-IDENTITY',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},


# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE-AUTH.METHOD2.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.186',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.186',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_NONE',
	'E.P-PREFERRED-IDENTITY',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE-AUTH.METHOD2.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.186.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.186.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_NONE',
	'E.P-PREFERRED-IDENTITY',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PRIVACY_NONE-AUTH.METHOD3.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.186.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.186.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},


## tadokoro ##########################################
# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID.METHOD1.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_ID',
	'E.P-PREFERRED-IDENTITY_ANONYMOUS',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

## tadokoro ##########################################
# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID.METHOD2.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_ID',
	'E.P-PREFERRED-IDENTITY_ANONYMOUS',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID.METHOD2.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_ID',
	'E.P-PREFERRED-IDENTITY_ANONYMOUS',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID-AUTH.METHOD2.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184.PX',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_ID',
	'E.P-PREFERRED-IDENTITY_ANONYMOUS',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},


## tadokoro ##########################################
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID-AUTH.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_ID',
	'E.P-PREFERRED-IDENTITY_ANONYMOUS',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},


# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID-AUTH.METHOD2.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_ID',
	'E.P-PREFERRED-IDENTITY_ANONYMOUS',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},



## tadokoro ##########################################
# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS.METHOD3.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS.METHOD4.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},


## tadokoro ##########################################
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-AUTH.METHOD3.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.184',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG.184',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},
  

## tadokoro ##########################################
### 	9. 2xx

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX-FROM_ANONYMOUS.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
###20050112off        'D.TO-TAG',
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS', # 20050111
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

## tadokoro ##########################################
### 	9. 2xx

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX-FROM_ANONYMOUS.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_ONEHOP',	#
	'E.MAXFORWARDS_ONEHOP',	#
	'E.ROUTE_ONEURI',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',        
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},
  
## tadokoro ##########################################
### 	9. 2xx

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX_E164-FROM_ANONYMOUS.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
###20050112off        'D.TO-TAG',
	'E.ACK_E164-URI',
	'E.VIA_ONEHOP',	#
	'E.MAXFORWARDS_ONEHOP',	#
	'E.ROUTE_ONEURI',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',        
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

## tadokoro ##########################################  
### 	9. 2xx

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX_E164.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_E164-URI',
	'E.VIA_ONEHOP',	#
	'E.MAXFORWARDS_ONEHOP',	#
	'E.ROUTE_ONEURI',
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},
  
## tadokoro ##########################################
### 	BYE
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE-TO_ANONYMOUS.PX', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.BYE_CONTACT-URI-BASIC',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',# 
	'E.ROUTE_ONEURI',
        'E.RECORDROUTE_ONEHOP', # 20050304 add tadokoro	
	'E.FROM_LOCAL-URI_LOCAL-TAG.BYE',# 
	'E.TO_ANONYMOUS_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

  
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE-TO_ANONYMOUS.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.BYE_CONTACT-URI.NUMBER-NOTIFICATION',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',# 
	'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG.BYE',# 
	'E.TO_ANONYMOUS_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

#  BYE Request-URI=CONTACT(BASIC)
 {'TY:'=>'ENCODE', 'ID:'=>'E.BYE_ANONYMOUS','PT:'=>RQ,
  'FM:'=>'BYE sip:anonymous@anonymous.invalid SIP/2.0','AR:'=>[]},


## tadokoro ##########################################
### 	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX-FROM_ANONYMOUS.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_AOR-URI.184.UA11toUA12',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',    
	'E.TO_REMOTE-URI_REMOTE-TAG.ACK', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

### 	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX-FROM_ANONYMOUS.METHOD1.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
  'RR:'=>[
	'E.ACK_AOR-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',    
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


### end  SIPrulePX.pm(SIPuni) ###


 # %% TO:08 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_REMOTE-URI', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The URI(%s), except 184 or 186, in the To field MUST equal the remote URI(%s) of the Tester.', 
   'NG:' => \\'The URI(%s), except 184 or 186, in the To field MUST equal the remote URI(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',Cut184(FV('HD.To.val.ad.ad.txt',@_)),NINF('LocalAoRURI','RemotePeer'),@_)}}, 

 # %% TO:08 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_REMOTE-URI.METHOD1', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',FV('HD.To.val.ad.ad.txt',@_),NINF('LocalAoRURI','RemotePeer'),@_)}}, 


 # %% TO:02 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LOCAL-URI', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The URI(%s), except 184 or 186, in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s), except 184 or 186, in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',Cut184(FV('HD.To.val.ad.ad.txt',@_)),NINF('LocalAoRURI','LocalPeer'),@_)} },


 # %% TO:02 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LOCAL-URI.METHOD1', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.To.val.ad.ad.txt',@_),NINF('LocalAoRURI','LocalPeer'),@_)} },

 # %% TO:09 %%	To-tag
#
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_REMOTE-TAG', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The To-tag(%s) MUST equal the remote tag(%s).', 
   'NG:' => \\'The To-tag(%s) MUST equal the remote tag(%s).', 
   'PR:' => \q{NINF('DLOG.RemoteTag') ne ''},
   'EX:' =>\q{FFop('EQ',FV('HD.To.val.param.tag',@_),FV('HD.To.val.param.tag','',NDPKT(@_[1])),@_)}},


 # %% FROM:05 %%	From-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_REMOTE-TAG', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The From-tag(%s) in the message MUST equal the remote tag(%s).', 
   'NG:' => \\'The From-tag(%s) in the message MUST equal the remote tag(%s).', 
   'EX:' =>\q{FFop('EQ',FV('HD.From.val.param.tag',@_),FV('HD.From.val.param.tag','',@_[1]),@_)}},

 # %% TO:05 %%	To-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_LOCAL-TAG', 'CA:' => 'To','SP:'=>'TTC',
   'OK:' => \\'The To-tag(%s) MUST equal the local tag(%s).', 
   'NG:' => \\'The To-tag(%s) MUST equal the local tag(%s).', 
#   'EX:' =>\q{FFop('eq',FFGetMatchStr('tag=(.+)',\\\'HD.To.val.param',@_),NINF('DLOG.LocalTag'),@_)}},
   'EX:' =>\q{FFop('EQ',FV('HD.To.val.param.tag',@_),FV('HD.To.val.param.tag','',@_[1]),@_)}},

# 
# {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_REMOTE-TAG','PT:'=>'HD','SP:'=>'TTC',
#  'FM:'=>'To: %s','AR:'=>[\q{FV('HD.From.val.txt',@_)}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_REMOTE-TAG.ACK','PT:'=>'HD','SP:'=>'TTC',
  'FM:'=>'To: %s','AR:'=>[\q{FV('HD.To.txt',@_)}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_REMOTE-TAG.BYE','PT:'=>'HD','SP:'=>'TTC',
  'FM:'=>'To: %s','AR:'=>[\q{FV('HD.From.txt',@_)}]},


 # %% FROM:02 %%	From-URI
 #0128tuika     
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_REMOTE-URI', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',Cut184(FV('HD.From.val.ad.ad.txt',@_)),NINF('LocalAoRURI','RemotePeer'),@_)} },

 #0128tuika     
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_REMOTE-URI.METHOD1', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),NINF('LocalAoRURI','RemotePeer'),@_)} },

 # %% FROM:08 %%	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_LOCAL-URI', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',Cut184(FV('HD.From.val.ad.ad.txt',@_)),NINF('LocalAoRURI','LocalPeer'),@_)} },

 # %% FROM:08 %%	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_LOCAL-URI.METHOD1', 'CA:' => 'From','SP:'=>'TTC',
   'OK:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),NINF('LocalAoRURI','LocalPeer'),@_)} },


# clip clir method1 proxy x 2
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID.METHOD1.PX', 'MD:'=>'SEQ', 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_ID',
	'E.P-PREFERRED-IDENTITY_ANONYMOUS',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# clip clir method1 proxy x 2 with auth
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID-AUTH.METHOD1.PX', 'MD:'=>'SEQ', 'SP:'=>'TTC',
  'RR:'=>[
	'E.INVITE_AOR-URI.PX',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.PRIVACY_ID',
	'E.P-PREFERRED-IDENTITY_ANONYMOUS',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

#  BYE Request-URI=CONTACT(BASIC)
 {'TY:'=>'ENCODE', 'ID:'=>'E.BYE_CONTACT-URI.NUMBER-NOTIFICATION','PT:'=>RQ,'SP:'=>'TTC',
  'FM:'=>'BYE %s SIP/2.0','AR:'=>[\q{FV('HD.Contact.val.contact.ad.ad.txt','',NDFIRST)}]},


 # %% CALLID:02 %%	Call-ID
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CALLID_VALID.OTHER-REQUEST', 'CA:' => 'Call-ID',
   'OK:' => \\'The Call-ID(%s) header field of the response MUST equal the Call-ID(%s) header field of the request(case-sensitive and are simply compared byte-by-byte).', 
   'NG:' => \\'The Call-ID(%s) header field of the response MUST equal the Call-ID(%s) header field of the request(case-sensitive and are simply compared byte-by-byte).', 
   'EX:' => \q{FFop('eq',\\\'HD.Call-ID.val.call-id',FV('HD.Call-ID.txt','',NDLAST),@_)} },

 # for invite-request (override)
 {'TY:'=>'ENCODE', 'ID:'=>'E.SUPPORTED_999rel', 'PT:'=>'HD', 'NX:'=>'Via', 'SP:'=>'TTC',
  'FM:'=> 'Supported: 999rel%s',
  'AR:'=> [ sub{
#                    PrintVal(NDCFG('supported_extension'));
#                    PrintVal($CNT_CONF{'PX-SUPPORTED'});
#                    exit;
                    if(NDCFG('supported_extension') ne 'none' && NDCFG('supported_extension') ne ''){
			return ', '.NDCFG('supported_extension');
		    }
		    else{
			return '';
		    }
		}
          ],
 },


 # %% SUPPORTED:01 %%	Supported
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SUPPORTED_NOTEXIST', 'CA:' => 'Supported','SP:'=>'TTC',
   'OK:' => "A Supported header, configured unknown extension, field SHOULD not exist.", 
   'NG:' => "A Supported header, configured unknown extension, field SHOULD not exist.", 
   'RT:' => "warning", 
   'EX:' =>\'!FFIsExistHeader("Supported",@_)'},


 # %% TTC-2-1-2 01 %%	UA receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-415-400.TM', 'SP:'=>'TTC',
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS',
	      'S.REQUIRE_NOEXIST_TTC',
	      'S.WWW-AUTHENTICATE_NOEXIST_TTC',
            ]
 }, 

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.LARGE-SDP.TM', 'MD:'=>SEQ, 'SP:'=>'TTC',
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
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_LARGE'],
  'EX:' =>\&MargeSipMsg},

#Body
#  BODY_LOCAL
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_LARGE','PT:'=>BD,'SP:'=>'TTC',
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "t=0 0\r\n".
       "m=audio ".NINF('RTPPort','LocalPeer')." RTP/AVP 0 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 GSM/8000\r\n".
       "a=rtpmap:0 G723/8000\r\n".
       "a=rtpmap:0 DVI4/8000\r\n".
       "a=rtpmap:0 DVI4/16000\r\n".
       "a=rtpmap:0 LPC/8000\r\n".
       "a=rtpmap:0 PCMA/8000\r\n".
       "a=rtpmap:0 G722/8000\r\n".
       "a=rtpmap:0 L16/441000\r\n".
       "a=rtpmap:0 QCELP/8000\r\n".
       "a=rtpmap:0 CN/8000\r\n".
       "a=rtpmap:0 MPA/90000\r\n".
       "a=rtpmap:0 G728/8000\r\n".
       "a=rtpmap:0 DVI4/11025\r\n".
       "a=rtpmap:0 DVI4/22050\r\n".
       "a=rtpmap:0 AMR/8000\r\n".
       "a=rtpmap:0 clearmode/8000\r\n".
       "a=rtpmap:0 EVRC/8000\r\n".
       "a=rtpmap:0 EVRC0/8000\r\n".
       "a=rtpmap:0 G726-16/8000\r\n".
       "a=rtpmap:0 G726-24/8000\r\n".
       "a=rtpmap:0 G726-32/8000\r\n".
       "a=rtpmap:0 G726-40/8000\r\n".
       "a=rtpmap:0 G729D/8000\r\n".
       "a=rtpmap:0 G729E/8000\r\n".
       "a=rtpmap:0 GSM-EFR/8000\r\n".
       "a=rtpmap:0 iLBC/8000\r\n".
       "a=rtpmap:0 SMV/8000\r\n".
       "a=rtpmap:0 SMV0/8000\r\n".
       "a=rtpmap:0 AMR-WR/16000\r\n".
       "a=rtpmap:0 G722.1/16000\r\n".
       "a=rtpmap:0 mpa-robust/90000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 PCMU/8000"
   },
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')}]
},

#Body
#  BODY_LOCAL
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_LARGE.tmp','PT:'=>BD,'SP:'=>'TTC',
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "t=0 0\r\n".
       "m=audio ".NINF('RTPPort','LocalPeer')." RTP/AVP 0 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=rtpmap:0 GSM/8000\r\n".
       "a=rtpmap:0 G723/8000\r\n".
       "a=rtpmap:0 DVI4/8000\r\n".
       "a=rtpmap:0 DVI4/16000\r\n".
       "a=rtpmap:0 LPC/8000\r\n".
       "a=rtpmap:0 PCMA/8000"
   },
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')}]
},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RR.IPADDRESS', 'CA:' => 'Record-Route','SP:'=>'TTC',
   'OK:' => \\'Record-Route header field in the re-INVITE MUST be IP address', 
   'NG:' => \\'Record-Route header field in the re-INVITE MUST be IP address', 
   'EX:' => \q{IsIPAddress(CutSipRRIP(FV('HD.Record-Route.val.route.txt',@_)))} }, 


#########from SIPrule100rel.pm ################
#####################
### Ruleset (SYNTAX)
#####################

### Judgement rule for PRACK request
###   written by Horisawa (2005.12.22)
{'TY:'=>'RULESET', 'SP:'=>'TTC',
 'ID:'=>'SS.REQUEST.PRACK_FORWARDED.ONEPX.TM', 
 'RR:'=>[
	'SSet.ALLMesg',
	'SS.FORWARD_REQUEST_COMPARE',
	'S.PORT-SIGNAL_DEFAULTS',
	'S.R-URI_NOQUOTE',
	'S.R-URI_REQ-CONTACT-URI',
	'S.R-LINE_VERSION',
	'S.VIA-URI_HOSTNAME',
	'S.VIA-TRANSPORT_UDP',
	'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
	'S.VIA_INSERT-NEWVIA-LINE',
	'S.VIA-RECEIVED_EXIST_2ND_REMOTE',
	'S.MAX-FORWARDS_EXIST',
	'S.P-AUTH_NOTEXIST',
	'S.FROM-TAG_EXIST',
	'S.FROM-URI_REMOTE-URI',
	'S.FROM-TAG_REMOTE-TAG',
	'S.TO-TAG_EXIST',
	'S.TO-URI_LOCAL-URI',
	'S.TO-TAG_LOCAL-TAG',
	'S.CALLID_VALID',
	'S.CSEQ-METHOD_REQLINE-METHOD',
	'S.CSEQ-METHOD_PRACK',
	'S.RECORD-ROUTE_ADD-PROXY-URI',
	'S.RECORD-ROUTE.EXIST-lr-PARAM',
	'S.RECORD-ROUTE.EXIST-transport-PARAM',
	'S.RFC3262-table1_PRACK_Not-Applicable-headers',
	 'SS.PRACK.NOEXIST_TTC',
# TODO (if needed), Horisawa, 2005.12.27
#  - Judgment for the case that the PRACK message had body as offer
#    
	]
},

### Judgment rule for 200 response (for PRACK request)
###   written by Horisawa (2005.12.26)
{'TY:' => 'RULESET','SP:'=>'TTC',
 'ID:' => 'SS.STATUS.PRACK-200.TM',
 'RR:' => [
	'SSet.ResMesg',
	'SS.FORWARD_RESPONSE_COMPARE',
	'S.PORT-SIGNAL_DEFAULTS',
	'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX.LAST_PRACK',
	'S.VIA-RECEIVED_EXIST',
	'S.VIA_NOPX_SEND_EQUAL',
	'S.VIA_REMOVE-TOPMOST',
	'S.TO-TAG_EXIST',
	'S.CSEQ-METHOD_PRACK',
	'D.COMMON.FIELD.STATUS',
	'S.RFC3262-table1_response-for-PRACK_Not-Applicable-headers',
	]
},

### Judgment rule for 183 response (for INVITE request)
###   written by Horisawa (2005.12.21)
{'TY:' => 'RULESET', 'SP:'=>'TTC',
 'ID:' => 'SS.STATUS.INVITE-183.TM',
 'RR:' => [
	'SSet.ResMesg',
	'SS.FORWARD_RESPONSE_COMPARE',
	'S.PORT-SIGNAL_DEFAULTS',
	'S.VIA_REMOVE-TOPMOST',
	'S.VIA-RECEIVED_EXIST',
	'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
	'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
	'S.VIA_NOPX_SEND_EQUAL',
	'S.TO-TAG_EXIST',
	'S.CSEQ-METHOD_INVITE',
	'D.COMMON.FIELD.STATUS',
	'S.WWW-AUTHENTICATE_NOEXIST_TTC',
	]
},

### Judgment rule for 407 response (for PRACK request)
###   written by Horisawa (2005.12.27)
{'TY:' => 'RULESET','SP:'=>'TTC',
 'ID:' => 'SS.STATUS.PRACK-407.TM',
 'RR:' => [
	'SSet.ResMesg',
	'S.PORT-SIGNAL_DEFAULTS',
	'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
	'S.VIA-RECEIVED_EXIST',
	'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
	'S.VIA_NOPX_SEND_EQUAL',
	'S.TO-TAG_EXIST',
	'S.CSEQ-METHOD_PRACK',
	'S.RE-ROUTE_NOEXIST',
	'D.COMMON.FIELD.STATUS',
	'S.RFC3262-table1_response-for-PRACK_Not-Applicable-headers',
	'S.PROXY-AUTHENTICATE_NOEXIST_TTC',
	]
},

### Judgment rule for 100 response (the headers which must not be included)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.MUSTNOT-HEADER_100',
 'CA:'=>'Header',
 'OK:'=>\\'100 response MUST NOT include the following header field: RSeq',
 'NG:'=>\\'100 response MUST NOT include the following header field: RSeq',
 'EX:'=>\q{!FFIsExistHeader(['RSeq'],@_)}
},

### Judgment rule for "Require" header
###       (100rel option tag must not be included)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.REQUIRE-100REL_NOTEXIST',
 'CA:'=>'Require',
# 'PR:'=>\q{FFIsExistHeader("Require",@_)},
 'OK:'=>\\'The Require header in this message MUST NOT include 100rel option tag.',
 'NG:'=>\\'The Require header in this message MUST NOT include 100rel option tag.',
 'EX:'=>\q{!FFIsMember(['100rel'],FVSeparete('HD.Require.val','\s*,\s*',@_),'',@_)}
},

### Judgment rule for "RSeq" header (the presence of RSeq header)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.RSEQ_EXIST',
 'CA:'=>'RSeq',
 'OK:'=>\\'The RSeq header MUST exist.',
 'NG:'=>\\'The RSeq header MUST exist.',
 'EX:'=>\q{FFIsExistHeader("RSeq",@_)}
},

### Judgment rule for "RAck" header (the presence of RAck header)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.RACK_EXIST',
 'CA:'=>'RAck',
 'OK:'=>\\'The RAck header MUST exist.',
 'NG:'=>\\'The RAck header MUST exist.',
 'EX:'=>\q{FFIsExistHeader("RAck",@_)}
},

### Judgment rule for "Require" header (the consistency of forwarded message)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.REQUIRE_ORIGINAL-REQUIRE',
 'CA:'=>'Require',
 'OK:'=>\\'The Require header value(%s) MUST equal the Require header value(%s) in the original message.',
 'NG:'=>\\'The Require header value(%s) MUST equal the Require header value(%s) in the original message.',
 'EX:'=>\q{FFop('eq',FV('HD.Require.val',@_),FV('HD.Require.val','', NDPKT(@_[1])),@_)}
},

### Judgment rule for "RSeq" header (the consistency of forwarded message)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.RSEQ_ORIGINAL-RSEQ',
 'CA:'=>'RSeq',
 'OK:'=>\\'The RSeq header value(%s) MUST equal the RSeq header value(%s) in the original message.',
 'NG:'=>\\'The RSeq header value(%s) MUST equal the RSeq header value(%s) in the original message.',
 'EX:'=>\q{FFop('eq',FV('HD.RSeq.txt',@_),FV('HD.RSeq.txt','', NDPKT(@_[1])),@_)}
},

### Judgment rule for "RAck" header (the consistency of forwarded message)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.RACK_ORIGINAL-RACK',
 'CA:'=>'RAck',
 'OK:'=>\\'The RAck header value(%s) MUST equal the RAck header value(%s) in the original message.',
 'NG:'=>\\'The RAck header value(%s) MUST equal the RAck header value(%s) in the original message.',
 'EX:'=>\q{FFop('eq',FV('HD.RAck.txt',@_),FV('HD.RAck.txt','', NDPKT(@_[1])),@_)}
},

### Judgment rule for "CSeq" header (whether the method is PRACK or not)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.CSEQ-METHOD_PRACK',
 'CA:'=>'CSeq',
 'OK:'=>\\'The method of CSeq MUST be \"PRACK\".',
 'NG:'=>\\'The method(%s) of CSeq MUST be \"PRACK\".',
 'EX:'=>\q{FFop('eq',\\\'HD.CSeq.val.method','PRACK',@_)}
},

### Judgment rule for "branch" parameter of "Via" header,
###  in the case where the UA which sent PRACK receives a response
### (matching branch parameters between request and response)
###   written by Horisawa (2005.12.27)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX.LAST_PRACK',
 'CA:'=>'Via',
 'OK:'=>\\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
 'NG:'=>\\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
 'EX:'=>\q{FFop('EQ',
		FVs('HD.Via.val.via.param.branch=',@_),
		FVs('HD.Via.val.via.param.branch=','',
				NDPKT('PRACK','MY','LAST','send'))
		,@_)},
},

### Judgment rule for "branch" parameter of "Via" header,
###  in the case where the UA which sent INVITE receives a response
### (matching branch parameters between request and response)
###   written by Horisawa (2005.12.27)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX.LAST_INVITE',
 'CA:'=>'Via',
 'OK:'=>\\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
 'NG:'=>\\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
 'EX:'=>\q{FFop('EQ',
		FVs('HD.Via.val.via.param.branch=',@_),
		FVs('HD.Via.val.via.param.branch=','',
				NDPKT('INVITE','MY','LAST','send'))
		,@_)},
},

### Judgment rule for "Via" header,
###  in the case where the UA which sent PRACK receives a response
### (matching Via header between request and response, except received parameter)
###   written by Horisawa (2005.12.27)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.VIA_NOPX_SEND_EQUAL.LAST_PRACK',
 'CA:'=>'Via',
 'OK:'=>\\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).',
 'NG:'=>\\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).',
 'EX:'=>\q{OpViaMachLinesWithRequest('PRACK',1,@_)},
},

### Judgment rule for "Via" header,
###  in the case where the UA which sent INVITE receives a response
### (matching Via header between request and response, except received parameter)
###   written by Horisawa (2005.12.27)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.VIA_NOPX_SEND_EQUAL.LAST_INVITE',
 'CA:'=>'Via',
 'OK:'=>\\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).',
 'NG:'=>\\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).',
 'EX:'=>\q{OpViaMachLinesWithRequest('INVITE',1,@_)},
},

### Judgment rule for "Require" header
### Term : RFC3262-3-9
###   written by Horisawa (2006.1.6)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.REQUIRE_EXIST_INCLUDE-100REL',
 'CA:'=>'Require',
 'OK:'=>\\'A Require header MUST exist and include 100rel.',
 'NG:'=>\\'A Require header MUST exist and include 100rel.',
 'EX:'=>\q{FFIsExistHeader("Require",@_) && FFIsMember(['100rel'],FVSeparete('HD.Require.val','\s*,\s*',@_),'',@_)},
},

### Judgment rule for "RSeq" header
### Term : RFC3262-3-11
###   written by Horisawa (2006.1.6)
{'TY:'=>'SYNTAX', 'SP:'=>'TTC',
 'ID:'=>'S.RSEQ-SEQNO_32BIT',
 'CA:'=>'RSeq',
 'OK:'=>\\'The RSeq value(%s) MUST be expressible as a 32-bit unsigned integer and MUST be less than 2**31..',
 'NG:'=>\\'The RSeq value(%s) MUST be expressible as a 32-bit unsigned integer and MUST be less than 2**31..',
 'EX:'=>\q{FFop('<',\\\'HD.RSeq.val.responsenum',2**31,@_)},
},

### Judgment rule for PRACK request
### (Basis for a determination : RFC3262 Table1, Table2)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3262-table1_PRACK_Not-Applicable-headers',
 'CA:'=>'Header',
 'OK:'=>"A PRACK request MUST NOT include the following headers: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.",
 'NG:'=>"A PRACK request MUST NOT include the following headers: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.",
 'EX:'=>\q{!FFIsExistHeader(['Alert-Info','Call-Info','Contact','Expires','In-Reply-To','Organization','Priorit','Reply-To','Subject'],@_)}
},

### Judgment rule for a response for PRACK request
### (Basis for a determination : RFC3262 Table1, Table2)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3262-table1_response-for-PRACK_Not-Applicable-headers',
 'CA:'=>'Header','SP:'=>'TTC',
 'OK:'=>"A response for PRACK request MUST NOT include the following headers: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.",
 'NG:'=>"A response for PRACK request MUST NOT include the following headers: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.",
 'EX:'=>\q{!FFIsExistHeader(['Alert-Info','Call-Info','Contact','Expires','In-Reply-To','Organization','Priorit','Reply-To','Subject'],@_)}
},

#########end  SIPrule100rel.pm ###############





#########from  SIPruleUPDATE.pm ###############

### Judgment rule for UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'RULESET','SP:'=>'TTC',
 'ID:'=>'SS.REQUEST.UPDATE_FORWARDED.ONEPX.TM',
 'RR:'=>[
 	'SSet.ALLMesg',
	'SS.FORWARD_REQUEST_COMPARE',
	'S.PORT-SIGNAL_DEFAULTS',
	'S.R-URI_NOQUOTE',
	'S.R-URI_REQ-CONTACT-URI',
	'S.R-LINE_VERSION',
	'S.VIA-URI_HOSTNAME',
	'S.VIA-TRANSPORT_UDP',
	'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
	'S.VIA_INSERT-NEWVIA-LINE',
	'S.VIA-RECEIVED_EXIST_2ND_REMOTE',
	'S.MAX-FORWARDS_EXIST',
	'S.P-AUTH_NOTEXIST',
	'S.FROM-TAG_EXIST',
	'S.FROM-URI_REMOTE-URI',
	'S.FROM-TAG_REMOTE-TAG',
	'S.TO-TAG_EXIST',
	'S.TO-URI_LOCAL-URI',
	'S.TO-TAG_LOCAL-TAG',
	'S.CALLID_VALID',
	'S.CONTACT_EXIST',
	'S.CONTACT-URI_REMOTE-CONTACT-URI',
	'S.CONTACT_NOT-*',
	'S.CONTACT_QUOTE',
	'S.CSEQ-METHOD_REQLINE-METHOD',
	'S.CSEQ-METHOD_UPDATE',
	'S.RECORD-ROUTE_ADD-PROXY-URI',
	'S.RECORD-ROUTE.EXIST-lr-PARAM',
	'S.RECORD-ROUTE.EXIST-transport-PARAM',
	'SSet.SDP',
	'D.COMMON.FIELD.REQUEST',
	'S.RFC3311-table1_UPDATE_Not-Applicable-headers',
	 'SS.UPDATE.NOEXIST_TTC',
 	]
},

### Judgment rule for 200 response (for UPDATE request)
###   written by Horisawa (2006.1.5)
{'TY:'=>'RULESET','SP:'=>'TTC',
 'ID:'=>'SS.STATUS.UPDATE-200.TM',
 'RR:'=>[
 	'SSet.ResMesg',
	'SS.FORWARD_RESPONSE_COMPARE',
	'S.PORT-SIGNAL_DEFAULTS',
	'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX.LAST_UPDATE',
	'S.VIA-RECEIVED_EXIST',
	'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
	'S.VIA_NOPX_SEND_EQUAL',
	'S.TO-TAG_EXIST',
	'S.CSEQ-METHOD_UPDATE',
	'S.CONTACT_EXIST',
	'S.CONTACT-URI_REMOTE-CONTACT-URI',
	'S.CONTACT_NOT-*',
	'S.CONTACT_QUOTE',
	'SSet.SDP-ANS',				# if you don't need this, DEL locally.
	'D.COMMON.FIELD.STATUS',
	'S.RFC3311-table1_response-for-UPDATE_Not-Applicable-headers',
	'S.RECORD-ROUTE_NOEXIST_TTC',
	'S.WWW-AUTHENTICATE_NOEXIST_TTC',
	'S.WWW-AUTHENTICATION-INFO_NOEXIST_TTC',
 	]
},

### Judgment rule for "Allow" header (the presense of UPDATE)
### (Basis for a determination : RFC3311-4-1)
###   written by Horisawa (2006.1.5)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-4-1_Allow',
 'CA:'=>'Allow',
 'OK:'=>\\'The Allow header SHOULD exist and include \"UPDATE\" to indicate support for the UPDATE method.',
 'NG:'=>\\'The Allow header SHOULD exist and include \"UPDATE\" to indicate support for the UPDATE method.',
 'RT:'=>'warning',
 'EX:'=>\q{FFIsExistHeader("Allow",@_) 
 		&& FFIsMember('UPDATE',FVSeparete('HD.Allow.val.txt','\s*,\s*',@_),'',@_)}
},

### Judgment rule for "Allow" header (the presense of UPDATE)
### (Basis for a determine : RFC3311-4-1)
###   written by Horisawa (2006.1.13)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-4-2_Allow',
 'CA:'=>'Allow',
 'OK:'=>\\'The Allow header SHOULD exist and include \"UPDATE\" to indicate support for the UPDATE method.',
 'NG:'=>\\'The Allow header SHOULD exist and include \"UPDATE\" to indicate support for the UPDATE method.',
 'RT:'=>'warning',
 'EX:'=>\q{FFIsExistHeader("Allow",@_) 
		&& FFIsMember('UPDATE',FVSeparete('HD.Allow.val.txt','\s*,\s*',@_),'',@_)
		&& (FFIsExistHeader("Require",@_) && FFIsMember(['100rel'],FVSeparete('HD.Require.val','\s*,\s*',@_),'',@_))
		&& FFIsExistHeader("RSeq",@_)
		&& 'BD.txt'
        }
},

### Judgment rule for "Allow" header (the presense of UPDATE)
### (Basis for a determination : RFC3311-4-3)
###   written by Horisawa (2006.1.16)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-4-3_Allow',
 'CA:'=>'Allow',
 'OK:'=>\\'The Allow header SHOULD exist and include \"UPDATE\" to indicate support for the UPDATE method.',
 'NG:'=>\\'The Allow header SHOULD exist and include \"UPDATE\" to indicate support for the UPDATE method.',
 'RT:'=>'warning',
 'EX:'=>\q{FFIsExistHeader("Allow",@_) 
 		&& FFIsMember('UPDATE',FVSeparete('HD.Allow.val.txt','\s*,\s*',@_),'',@_)
		&& FFIsMatchStr('^[2]',\\\'RQ.Status-Line.code','','',@_)
		}
},

### Judgment rule for "UPDATE" request 
### (Basis for a determination : RFC3311-5-1)
###   written by Horisawa (2006.1.17)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-1_UPDATE',
 'CA:'=>'Request',
 'OK:'=>\\'It is RECOMMENDED that a \"re-INVITE\" is used instead of \"UPDATE\" in Confirmed dialog.',
 'NG:'=>\\'It is RECOMMENDED that a \"re-INVITE\" is used instead of \"UPDATE\" in Confirmed dialog.',
 'RT:'=>'warning',
 'EX:'=>\q{FFop('ne',\\\'RQ.Request-Line.method','UPDATE',@_)
		&& FFop('eq',\\\'RQ.Request-Line.method','INVITE',@_)
		}       
},

### Judgment rule for "Contact" header
### (Basis for a determination : RFC3311-5-2)
###   written by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-2_Contact',
 'CA:'=>'Request',
 'OK:'=>\\'Contact header field(%s) MUST be same with the UPDATE request or the response sent(%s).',
 'NG:'=>\\'Contact header field(%s) MUST be same with the UPDATE request or the response sent(%s).',
 'EX:'=>\q{
            FFop('eq',\\\'HD.Contact.txt',FVib('recv','','','HD.Contact.txt',
                        'RQ.Request-Line.method','UPDATE'),@_)
            || FFop('eq',\\\'HD.Contact.txt',FVib('recv','','','HD.Contact.txt',
                        'RQ.Status-Line.code',200,'HD.CSeq.val.method','UPDATE'),@_)
        }       
},

### Judgment rule for "500" response
### (Basis for a determination : RFC3311-5-3)
###   written by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-3_500',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'NG:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'EX:'=>\q{FFop('eq',\\\'RQ.Status-Line.code','500',@_)},
},  
    
### Judgment rule for "Retry-After" header
### (Basis for a determination : RFC3311-5-4)
###   written by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-4_Retry-After',
 'CA:'=>'Retry-After',
 'OK:'=>\\'The Retry-After header MUST exist, and the value(%s) MUST be between 0 and 10.', 
 'NG:'=>\\'The Retry-After header MUST exist, and the value(%s) MUST be between 0 and 10.',
 'EX:'=>\q{FFIsExistHeader("Retry-After",@_)
         && FFop('<=>',FV('HD.Retry-After.val.delta',@_),[0,10],@_)},
},

### Judgment rule for "491" response
### (Basis for a determination : RFC3311-5-5)
###   written by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-5_491',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be \"491\" Request Pending.',
 'NG:'=>\\'Status-Code(%s) MUST be \"491\" Request Pending.',
 'EX:'=>\q{FFop('eq',\\\'RQ.Status-Line.code','491',@_)},
},

### (Basis for a determination : RFC3311-5-6)
###   written by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-6_500',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'NG:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'EX:'=>\q{FFop('eq',\\\'RQ.Status-Line.code','500',@_)},
},  
    
### Judgment rule for "Retry-After" header
### (Basis for a determination : RFC3311-5-7)
###   written by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-7_Retry-After',
 'CA:'=>'Retry-After',
 'OK:'=>\\'The Retry-After header MUST exist, and the value(%s) MUST be between 0 and 10.', 
 'NG:'=>\\'The Retry-After header MUST exist, and the value(%s) MUST be between 0 and 10.',
 'EX:'=>\q{FFIsExistHeader("Retry-After",@_)
         && FFop('<=>',FV('HD.Retry-After.val.delta',@_),[0,10],@_)},
},

### Judgment rule for RFC3311-5-8 is not able to implement.
### (Because it is only described "MUST check",
###  and the description which how must be is RFC3311-5-9.)

### Judgment rule for "2XX" response
### (Basis for a determination : RFC3311-5-9)
###   written by Horisawa (2006.1.20)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-9_2XX',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be \"2xx\" OK and session parameters MUST be changed.',
 'NG:'=>\\'Status-Code(%s) MUST be \"2xx\" OK and session parameters MUST be changed.',
 'EX:'=>sub{
            my($rule,$pktinfo,$context)=@_;
            $scode = FV('RQ.Status-Line.code','',$pktinfo);
            $context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'via','ARG1:'=>$scode};
            if ($scode =~ /^[2]/) {
                return 'MATCH';
            } else {
                return '';
            }
        }
},

### Judgment rule for RFC3311-5-10 is not able to implement.
### (Because the definition of "promptly" is not clear.)

### Judgment rule for "504" response
### (Basis for a determination : RFC3311-5-11)
###
### But, It is difficult to apply this rule to Conformance Test.
### (Because SIP-CT can't conform whether NUT prompts the user or not.)
###
###   written by Horisawa (2006.1.20)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-11_504',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) SHOULD be \"504\" Server Timeout.',
 'NG:'=>\\'Status-Code(%s) SHOULD be \"504\" Server Timeout.',
 'RT:'=>'warning',
 'EX:'=>\q{FFop('eq',\\\'RQ.Status-Line.code','504',@_)},
},

### Judgment rule for "488" response
### (Basis for a determination : RFC3311-5-12)
###   written by Horisawa (2006.1.20)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-5-12_488',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) SHOULD be \"488\" Not Acceptable Here and be included Warning header.
',
 'NG:'=>\\'Status-Code(%s) SHOULD be \"488\" Not Acceptable Here and be included Warning header.
',
 'RT:'=>'warning',
 'EX:'=>sub{
            my($rule,$pktinfo,$context)=@_;
            my($scode);
            $scode = FV('RQ.Status-Line.code','',$pktinfo);
            $context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'via','ARG1:'=>$scode};
            if ($scode eq 488 && FFIsExistHeader('Warning','',$pktinfo)) {
                return 'MATCH';
            } else {
                return '';
            }
        }
},

### Judgment rule for RFC3311-5-13 is not able to implement.
### (Because SIP-CT can't detect changes of session parameters from media stream.)

### Judgment rule for
### (Basis for a determination : RFC3311-5-14)
###   written by Horisawa (2006.1.20)

### Judgment rule for
### (Basis for a determination : RFC3311-5-15)
###   written by Horisawa (2006.1.20)




### Judgment rule for "CSeq" header (whether the method is UPDATE or not)
### (Basis for a determination : RFC3261-)
###   written by Horisawa (2006.1.5)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.CSEQ-METHOD_UPDATE',
 'CA:'=>'CSeq',
 'OK:'=>\\'The method of CSeq MUST be \"UPDATE\".',
 'NG:'=>\\'The method(%s) of CSeq MUST be \"UPDATE\".',
 'EX:'=>\q{FFop('eq',\\\'HD.CSeq.val.method','UPDATE',@_)}
},

### Judgment rule for "branch" parameter of Via header,
###  in the case where the UA which sent UPDATE receives a response.
### (matching branch parameters between request and response)
###   written by Horisawa (2006.1.6)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX.LAST_UPDATE',
 'CA:'=>'Via',
 'OK:'=>\\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
 'NG:'=>\\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
 'EX:'=>\q{FFop('EQ',
 		FVs('HD.Via.val.via.param.branch=',@_),
 		FVs('HD.Via.val.via.param.branch=','',
					NDPKT('UPDATE','MY','LAST','send'))
		,@_)},
},

### Judgment rule for UPDATE request
### (Basis for a determination : RFC3311 Table 1)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-table1_UPDATE_Not-Applicable-headers',
 'CA:'=>'Header',
 'OK:'=>'An UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'NG:'=>'An UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'EX:'=>\q{!FFIsExistHeader(['Alert-Info','Allow-Events','Event','Expires','In-Reply-To','Min-Expires','Priority','RAck','RSeq','Subject','Subscription-State'],@_)},
},

### Judgment rule for a response for UPDATE request
### (Basis for a determination : RFC3311 Table 1)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX','SP:'=>'TTC',
 'ID:'=>'S.RFC3311-table1_response-for-UPDATE_Not-Applicable-headers',
 'CA:'=>'Header',
 'OK:'=>'A response for UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'NG:'=>'A response for UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'EX:'=>\q{!FFIsExistHeader(['Alert-Info','Allow-Events','Event','Expires','In-Reply-To','Min-Expires','Priority','RAck','RSeq','Subject','Subscription-State'],@_)},
},


#########end  SIPruleUPDATE.pm ###############




 { 'TY:' => 'SYNTAX', 'ID:' => 'S.HEADER.LENGTH', 'CA:' => 'Header','SP:' => 'TTC',
   'OK:' => \\'Header Length is all OK.', 
   'NG:' => \\'Header Length is too long.', 
   'EX:' => \q{HeaderLength(FV('header_txt',@_))} }, 

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.HEADER.TIMES', 'CA:' => 'Header','SP:' => 'TTC',
   'OK:' => \\'Same header appear less than 5 times', 
   'NG:' => \\'Same header MUST NOT appear more than 5 times', 
#   'EX:' => \q{HeaderTimes(FV('header_txt',@_))} }, 
   'EX:' => \q{HeaderTimes(@_[1])} }, 

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BODY.LENGTH', 'CA:' => 'Body','SP:' => 'TTC',
   'OK:' => \\'Message body size(%s) MUST be less than 1000 bytes', 
   'NG:' => \\'Message body size(%s) MUST be less than 1000 bytes', 
   'EX:' => \q{FFop('<',length(FV('BD.txt',@_)),'1000',@_)} }, 




  { 'TY:' => 'RULESET', 'ID:' => 'SS.ACK.NOEXIST_TTC','SP:'=>'TTC',
    'RR:' => [
             'S.AUTHORIZATION_NOEXIST_TTC',
             'S.CONTENT-DISPOSITION_NOEXIST_TTC',
             'S.CONTENT-ENCODING_NOEXIST_TTC',
             'S.CONTENT-LANGUAGE_NOEXIST_TTC',
             'S.CONTENT-TYPE_NOEXIST_TTC',
             'S.MIME-VERSION_NOEXIST_TTC',
             'S.PRIVACY_NOEXIST_TTC',
             'S.PROXY-AUTHORIZATION_NOEXIST_TTC',
             'S.MESSAGEBODY_NOEXIST_TTC',
            ]
 },

  { 'TY:' => 'RULESET', 'ID:' => 'SS.BYE.NOEXIST_TTC','SP:'=>'TTC',
    'RR:' => [
             'S.AUTHORIZATION_NOEXIST_TTC',
             'S.CONTENT-DISPOSITION_NOEXIST_TTC',
             'S.CONTENT-ENCODING_NOEXIST_TTC',
             'S.CONTENT-LANGUAGE_NOEXIST_TTC',
             'S.CONTENT-TYPE_NOEXIST_TTC',
             'S.MIME-VERSION_NOEXIST_TTC',
             'S.P-ASSERTED-IDENTITY_NOEXIST_TTC',
             'S.P-PREFERRED_NOEXIST_TTC',
             'S.PRIVACY_NOEXIST_TTC',
             'S.PROXY-AUTHORIZATION_NOEXIST_TTC',
             'S.MESSAGEBODY_NOEXIST_TTC',
            ]
 },

  { 'TY:' => 'RULESET', 'ID:' => 'SS.CANCEL.NOEXIST_TTC','SP:'=>'TTC',
    'RR:' => [
             'S.AUTHORIZATION_NOEXIST_TTC',
             'S.CONTENT-DISPOSITION_NOEXIST_TTC',
             'S.PRIVACY_NOEXIST_TTC',
             'S.ROUTE_NOEXIST_TTC',
            ]
 },

  { 'TY:' => 'RULESET', 'ID:' => 'SS.INITIAL-INVITE.NOEXIST_TTC','SP:'=>'TTC',
    'RR:' => [
             'S.AUTHORIZATION_NOEXIST_TTC',
             'S.ROUTE_NOEXIST_TTC',
            ]
 },

  { 'TY:' => 'RULESET', 'ID:' => 'SS.RE-INVITE.NOEXIST_TTC','SP:'=>'TTC',
    'RR:' => [
             'S.AUTHORIZATION_NOEXIST_TTC',
             'S.PROXY-AUTHORIZATION_NOEXIST_TTC',
             'S.SUBJECT_NOEXIST_TTC',
            ]
 },


  { 'TY:' => 'RULESET', 'ID:' => 'SS.PRACK.NOEXIST_TTC','SP:'=>'TTC',
    'RR:' => [
             'S.AUTHORIZATION_NOEXIST_TTC',
             'S.PROXY-AUTHORIZATION_NOEXIST_TTC',
             'S.PROXY-REQUIRE_NOEXIST_TTC',
            ]
 },

  { 'TY:' => 'RULESET', 'ID:' => 'SS.UPDATE.NOEXIST_TTC','SP:'=>'TTC',
    'RR:' => [
             'S.PROXY-AUTHORIZATION_NOEXIST_TTC',
            ]
 },


  { 'TY:' => 'RULESET', 'ID:' => 'SS.BYE-RES.NOEXIST_TTC','SP:'=>'TTC',
    'RR:' => [
             'S.CONTENT-DISPOSITION_NOEXIST_TTC',
             'S.CONTENT-ENCODING_NOEXIST_TTC',
             'S.CONTENT-LANGUAGE_NOEXIST_TTC',
             'S.CONTENT-TYPE_NOEXIST_TTC',
             'S.MIME-VERSION_NOEXIST_TTC',
             'S.P-ASSERTED-IDENTITY_NOEXIST_TTC',
             'S.P-PREFERRED_NOEXIST_TTC',
             'S.PRIVACY_NOEXIST_TTC',
             'S.REQUIRE_NOEXIST_TTC',
             'S.WWW-AUTHENTICATE_NOEXIST_TTC',
             'S.MESSAGEBODY_NOEXIST_TTC',
            ]
 },



);



sub HeaderLength {
    my($pkt1) = @_;
    my($item1,$item2,@header1,@header2,$beforeitem1,$beforeitem2,@align,$header_name);
    my($count) = 1;
    my($i,$j,$k,$j_memory,$l);
    
#    $pkt1=$pkt1->{'header_txt'};
    @header1 = split(/\r\n/,$pkt1);
    foreach $item1 (@header1){
#	printf("kkk ==  $item1\n\n\n");
	if(length($item1) > 255){
	    return 0;
	}
#	printf("%d OK\n",length($item1));
    }
    return 1;
}

sub HeaderTimes {
    my($pkt1) = @_;
    my($item1,$item2,@header1,@header2,$beforeitem1,$beforeitem2,@align);
    my($count) = 1;
    my($i,$j,$k,$header_memory,$l);
    
    $pkt1=$pkt1->{'header'};
    #
    foreach $item1 (@$pkt1){	
#	printf("ggg = %s\n",$item1->{'tag'});
	push(@header1,$item1->{'tag'});
    }
#    PrintVal(@header1); #
    $header_memory = 0; # 
    # 
    for $i (0..$#header1){
	$count = 0;
	$header_memory = @header1[$i];
	for $j ($i+1..$#header1){
	    if(@header1[$j] eq $header_memory){
		$count++;
	    }
	    if($count > 4){
		return 0;
	    }
	}
    }
    return 1;
}





1



