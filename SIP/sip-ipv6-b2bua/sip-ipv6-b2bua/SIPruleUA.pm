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


#=================================
# 
#=================================
#use strict;

#=================================
# 
#=================================

# UA
@SIPUARules =
(
 #=================================
 # 
 #=================================

 # %% ALLMesg %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ALLMesg', 
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
#              'S.PORT-SIGNAL_DEFAULTS'
            ]
 }, 

 # %% SDP %%	SDP
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.SDP',
   'PR:' =>\q{length(FV('BD.txt',@_)) > 0},  ## 2006.7.31 sawada add ##  
   'RR:' => [
              'S.SDP.TAG_PRIORITY',
              'S.SDP.TAG-ONE_LINE-EXIST', 
              'S.SDP.V_EQUAL-ZERO',
              'S.SDP.O-IN_VALID',
              'S.SDP.O-IP_VALID',
              'S.SDP.O-ADDR_TAG-ADDR',
              'S.SDP.O-SESSIONID_64BIT',
              'S.SDP.O-VERSION_64BIT',
              'S.SDP.S_VALID',
              'S.SDP.C-IN_VALID',
              'S.SDP.C-IP_VALID',
              'S.SDP.C-CONNECTADDR_TARGET',
              'S.SDP.T_VALID',
              'S.SDP.M_EXIST',
              'S.SDP.A-PTIME_VALID',
            ]
 }, 

 # %% BYE %%	BYE
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.BYE', 
   'RR:' => [
              'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_BYE',
              'S.R-URI_REQ-CONTACT-URI',
              'S.CSEQ-METHOD_BYE',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
            ]
 }, 

 #=================================
 # 
 #=================================

#  FROM URI=PUA TAG=LOCAL
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_PUA-URI_LOCAL-TAG','PT:'=>HD, 
  'FM:'=>'From: <%s>;tag=%s','AR:'=>[\'$CVA_PUA_URI',\'$CVA_LOCAL_TAG']},

#  TO URI=TUA TAG=REMOTE
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_TUA-URI_REMOTE-TAG','PT:'=>HD,
  'FM:'=>'To: <%s>;tag=%s','AR:'=>[\'$CVA_TUA_URI',\'$CVA_REMOTE_TAG']},

### 20050418 usako add start ###
 # for invite-request
 {'TY:'=>'ENCODE', 'ID:'=>'E.SUPPORTED_VALID','PT:'=>HD,
   'FM:'=> \q{ "Supported: %s" },
   'AR:'=> [ \q{ $CNT_CONF{'UA-SUPPORTED'} } ],
 },

 # for response
 {'TY:'=>'ENCODE', 'ID:'=>'E.RES.SUPPORTED_VALID','PT:'=>HD,
   'FM:'=> \q{ "Supported: %s" },
   'AR:'=> [ \q{ FV('HD.Supported.txt', @_) } ],
 },
### 20050418 usako add end ###

);


#=================================
# 
#=================================
# 
#  $frame:[SIPtoTERM|SIPtoPROXY|SIPtoREG]
sub GetDefaultStatusSyntaxRule {
    my($statusCode,$frame)=@_;
    my($rule);
    if($statusCode eq 100){
	if($SIP_ScenarioModel{'Trapezoid'} eq 'NO')    {$rule='SSet.STATUS.INVITE-100.NOPX';}
	elsif($SIP_ScenarioModel{'Trapezoid'} eq 'ONE'){$rule='SSet.STATUS.INVITE-100.ONEPX';}
	elsif($SIP_ScenarioModel{'Trapezoid'} eq 'TWO'){$rule='SSet.STATUS.INVITE-100.PX';}
	elsif($SIP_ScenarioModel{'Trapezoid'} eq 'MULTIPUL'){$rule='SSet.STATUS.INVITE-100.NOPX';}
    }
    elsif($statusCode eq 180|183){ ## 2006.7.21 sawada add 183 ##
	if($SIP_ScenarioModel{'Trapezoid'} eq 'NO')    {$rule='SSet.STATUS.INVITE-180.NOPX';}
	elsif($SIP_ScenarioModel{'Trapezoid'} eq 'ONE'){$rule='SSet.STATUS.INVITE-180.ONEPX';}
	elsif($SIP_ScenarioModel{'Trapezoid'} eq 'TWO'){$rule='SSet.STATUS.INVITE-180.PX';}
	elsif($SIP_ScenarioModel{'Trapezoid'} eq 'MULTIPUL'){$rule='SSet.STATUS.INVITE-180.NOPX';}
    } 
#    elsif($statusCode eq 183){ ## 2006.7.21 sawada add ##
#	if($SIP_ScenarioModel{'Trapezoid'} eq 'NO')    {$rule='SSet.STATUS.INVITE-180.NOPX';}
#	elsif($SIP_ScenarioModel{'Trapezoid'} eq 'ONE'){$rule='SSet.STATUS.INVITE-180.ONEPX';}
#	elsif($SIP_ScenarioModel{'Trapezoid'} eq 'TWO'){$rule='SSet.STATUS.INVITE-180.PX';}
#	elsif($SIP_ScenarioModel{'Trapezoid'} eq 'MULTIPUL'){$rule='SSet.STATUS.INVITE-180.NOPX';}
#    } ##
    return $rule;
}

# 
sub GetDefaultStatusEncodeRule {
    my($statusCode,$reason,$frame)=@_;
    return '';
}

# 
sub GetDefaultStatusDecodeRule {
    my($statusCode,$reason,$frame)=@_;
    if($statusCode eq 180){
	return ['D.TO-TAG','D.VIA.BRANCH','D.VIA.BRANCH.append'];
    }
    else {
	return ['D.VIA.BRANCH','D.VIA.BRANCH.append'];
    }
    return '';
}



#
1
