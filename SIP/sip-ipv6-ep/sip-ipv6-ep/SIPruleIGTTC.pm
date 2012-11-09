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

# TTC
@IGandTTCRules =
(
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
              'S.CONTACT-URI_LEN-MAXIMUM',  ##ADD for IG
              'S.CSEQ-METHOD_INVITE',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
              'S.REQUIRE_NOEXIST-200',  ##ADD for TTC(watanabe)
              'S.ALLOW_EXIST_MUST',
              'S.BODY_EXIST',  ##ADD for IG
              'SSet.SDP',
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
           ]
 }, 

 # %% Basic3-8-1 01 %%	Proxy receives CANCEL.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.200-CANCEL.PX', 
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
            ]
 }, 

#  CNTTYPE_NOEXIST(ADD by watanabe)
 {'TY:'=>'SYNTAX', 'ID:'=>'S.CNTTYPE_NOEXIST', 'CA:'=>'Content-Type',
  'OK:'=>"A Content-Type header MUST NOT exist.",
  'NG:'=>"A Content-Type header MUST NOT exist.",
  'EX:'=>\'!FFIsExistHeader("Content-Type",@_)'},

#  ALLOW_EXIST(MOD by watanabe)
 {'TY:'=>'SYNTAX', 'ID:'=>'S.ALLOW_EXIST_MUST', 'CA:'=>'Allow',
  'OK:'=>"An Allow header MUST exist.",
  'NG:'=>"An Allow header MUST exist.",
  'EX:'=>\'FFIsExistHeader("Allow",@_)'},


 # %% CNTTYPE:01 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CNTTYPE_VALID-NULL', 'CA:' => 'Content-Type',
   'OK:' => "A Content-Type header field MUST NOT exist if the body is empty.", 
   'NG:' => "A Content-Type header field MUST NOT exist if the body is empty.", 
   'PR:'=>\q{0 == length(FV('BD.txt',@_))},
   'EX:' =>\q{!(FFIsExistHeader("Content-Type",@_))}},

 # %% Require:09 %% Check just the Existance of Require header. (CHO)
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE_NOEXIST-200', 'CA:' => 'REQUIRE',
   'OK:' => " The Require header MUST NOT exist.",
   'NG:' => " The Require header MUST NOT exist.", 
   'EX:' => \q{!FFIsExistHeader("Require",@_ ) }},

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RSEQ_NOEXIST', 'CA:' => 'RSEQ',
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

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.INVwithP-AUTH.PX', 
   'RR:' => [
              'SSet.INVITE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST', 'SP:' => 'TTC',
              'S.TO-TAG_NOEXIST',
              'S.CALLID_VALID_SHOULD',
              'S.P-AUTH_EXIST.PX',
              'SSet.DigestAuth.PX',
              'S.P-AUTH-URI_R-URI',
              'S.ROUTE_NOEXIST',  ##ADD for TTC(watanabe)
              'D.COMMON.FIELD.REQUEST',
            ]
 }, 

#  SSet.REQUEST.non2xx-ACK(MOD by watanabe)
  { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.non2xx-ACK', 'SP:' => 'TTC',
   'RR:' => [
              'SSet.ACK',
              'SSet.ACK-Non2xx',
              'S.VIA-BRANCH_REQ-VIA-BRANCH',
              'S.TO-TAG_LOCAL-TAG',
              'S.ROUTE_NOEXIST'   ##ADD for TTC(watanabe)
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
              'S.CONTACT-URI_LEN-MAXIMUM',  ##ADD for IG
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
              'S.CONTACT-URI_LEN-MAXIMUM',  ##ADD for IG
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
              'S.CONTACT_EXIST',       ## FOR TTC(CHO)
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
              'S.ALLOW_EXIST_MUST',   ## FOR TTC.(CHO)
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
              'S.CONTACT_EXIST',       ## FOR TTC(CHO)
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
              'S.ALLOW_EXIST_MUST',   ## FOR TTC.(CHO)
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
              'S.CONTACT_EXIST',       ## FOR TTC(CHO)
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
              'S.ALLOW_EXIST_MUST',   ## FOR TTC.(CHO)
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
              'S.CONTACT_EXIST',       ## FOR TTC(CHO)
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
              'S.ALLOW_EXIST_MUST',   ## FOR TTC.(CHO)
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
              'S.CONTACT_EXIST',       ## FOR TTC(CHO)
              'S.REQUIRE_NOEXIST-200',   ## FOR TTC.(CHO)
              'S.ALLOW_EXIST_MUST',   ## FOR TTC.(CHO)
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
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-4XX.NOPX', 
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
              'S.RE-ROUTE_NOEXIST'          ## FOR TTC(CHO)
            ]
 }, 

);

