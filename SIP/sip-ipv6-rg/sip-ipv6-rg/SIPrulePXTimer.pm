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

require SIPruleUPDATE;

#=================================
# 
#=================================
@SIPPXRulesTimer =
(
 {'TY:'=>'RULESET',
  'ID:'=>'SS.GENERIC.MAKE.RESPONSE.except-422',
  'MD:'=>'SEQ', 
  'RR:'=>[
          'S.Min-SE.NOTEXIST',
         ],
  'EX:' =>\&MargeSipMsg
 },


 # %% Min-SE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.Min-SE.NOTEXIST', 'CA:' => 'Min-SE',
   'OK:' => "Min-SE header field MUST NOT exist in this message.", 
   'NG:' => "Min-SE header field MUST NOT exist in this message.", 
   'EX:' => \q{!FFIsExistHeader('Min-SE',@_)}}, 

 # %% Min-SE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.Min-SE.EXIST', 'CA:' => 'Min-SE',
   'OK:' => "Min-SE header field MUST exist in this message.", 
   'NG:' => "Min-SE header field MUST exist in this message.", 
   'EX:' => \q{FFIsExistHeader('Min-SE',@_)}}, 

 # %% Min-SE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.Min-SE.SHOULD-EXIST', 'CA:' => 'Min-SE',
   'OK:' => "Min-SE header field SHOULD exist in this message.", 
   'NG:' => "Min-SE header field SHOULD exist in this message.", 
   'RT:' => "warning", 
   'EX:' => \q{FFIsExistHeader('Min-SE',@_)}}, 

 # %% Session-Expires
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SESSION-EXPIRES.MUSTNOTEXIST', 'CA:' => 'Session-Expires',
   'OK:' => "Session-Expires header field MUST NOT exist in this message.", 
   'NG:' => "Session-Expires header field MUST NOT exist in this message.", 
   'EX:' => \q{!FFIsExistHeader('Session-Expires',@_)}}, 

 # %% Require
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE.MUSTNOTEXIST', 'CA:' => 'Require',
   'OK:' => "Require header field MUST NOT exist in this message.", 
   'NG:' => "Require header field MUST NOT exist in this message.", 
   'EX:' => \q{!FFIsExistHeader('Require',@_)}}, 

 # %% Require
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE.MUSTEXIST', 'CA:' => 'Require',
   'OK:' => "Require header field MUST exist in this message.", 
   'NG:' => "Require header field MUST exist in this message.", 
   'EX:' => \q{FFIsExistHeader('Require',@_)}}, 


 {'TY:'=>'RULESET',
  'ID:'=>'SS.GENERIC.MAKE.RESPONSE.422',
  'MD:'=>'SEQ', 
  'RR:'=>[
          'S.Min-SE.EXIST',
          'S.MIN-SE.GRATER-90',
         ],
  'EX:' =>\&MargeSipMsg
 },

# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MIN-SE.GRATER-90', 'CA:' => 'Min-SE',
   'PR:' => \q{FFIsExistHeader("Min-SE",@_)},
   'OK:' => \\'A Min-SE parameter(%s) MUST grater or equal 90.', 
   'NG:' => \\'A Min-SE parameter(%s) MUST grater or equal 90.', 
   'EX:' => \q{ FFop('>=',FV('HD.Min-SE.val.seconds',@_),90,@_)
             }
 },


# INVITE request(with SDP and Session Timer)
 {'TY:'=>'RULESET',
  'ID:'=>'ES.REQUEST.Initial-INVITE.SESSION-TIMER.TM',
  'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.SUPPORTED_TIMER',
        'E.SESSION-EXPIRES_90',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
        'E.ALLOW_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg
 },

#  'PR:'=>\q{$CNT_CONF{'PX-SUPPORTED'} ne 'none'},

 # for invite-request (override)
 {'TY:'=>'ENCODE', 'ID:'=>'E.SUPPORTED_TIMER', 'PT:'=>'HD', 'NX:'=>'Via', 
  'FM:'=> 'Supported: timer%s',
  'AR:'=> [ sub{
#                    PrintVal(NDCFG('supported_extension'));
#                    PrintVal($CNT_CONF{'PX-SUPPORTED'});
#                    exit;
                    if(NDCFG('supported_extension') eq 'timer'){
			return '';
		    }
                    elsif(NDCFG('supported_extension') ne 'none' && NDCFG('supported_extension') ne ''){
			return ','.NDCFG('supported_extension');
		    }
		    else{
			return '';
		    }
		}
          ],
 },

#  Session-Expires 90
 {'TY:'=>'ENCODE', 'ID:'=>'E.SESSION-EXPIRES_90','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: 90'},

#  Session-Expires 89
 {'TY:'=>'ENCODE', 'ID:'=>'E.SESSION-EXPIRES_89','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: 89'},

#  Session-Expires 89;refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.SESSION-EXPIRES_89.REFRESHER-UAC','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: 89;refresher=uac'},

#  Session-Expires 89;refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.SESSION-EXPIRES_89.REFRESHER-UAS','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: 89;refresher=uas'},

#  Session-Expires 1800
 {'TY:'=>'ENCODE', 'ID:'=>'E.SESSION-EXPIRES_1800','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: 1800'},

#  Session-Expires Too Big
 {'TY:'=>'ENCODE', 'ID:'=>'E.SESSION-EXPIRES_TOO-BIG','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: 4294967295'},

#  Session-Expires Too Big
 {'TY:'=>'ENCODE', 'ID:'=>'E.SESSION-EXPIRES_TOO-BIG_with_REFRESHER-PARAMETER','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: 4294967295;refresher=uac'},

#  Min-SE 89
 {'TY:'=>'ENCODE', 'ID:'=>'E.MIN-SE_89','PT:'=>HD, 'NX:'=>'Session-Expires',
  'FM:'=>'Min-SE: 89'},

#  Min-SE 90
 {'TY:'=>'ENCODE', 'ID:'=>'E.MIN-SE_90','PT:'=>HD, 'NX:'=>'Session-Expires',
  'FM:'=>'Min-SE: 90'},

#  Min-SE 1800
 {'TY:'=>'ENCODE', 'ID:'=>'E.MIN-SE_1800','PT:'=>HD, 'NX:'=>'Session-Expires',
  'FM:'=>'Min-SE: 1800'},

#  Min-SE 1800
 {'TY:'=>'ENCODE', 'ID:'=>'E.MIN-SE_4000','PT:'=>HD, 'NX:'=>'Session-Expires',
  'FM:'=>'Min-SE: 4000'},

#  Session-Expires Too Big
 {'TY:'=>'ENCODE', 'ID:'=>'E.MIN-SE_TOO-BIG','PT:'=>HD, 'NX:'=>'Session-Expires',
  'FM:'=>'Min-SE: 4294967295'},

#  1 Proxy 200
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.ONEPX.SESSION-TIMER.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
        'E.RECORDROUTE_TWOHOPS',
        'E.REQUIRE_TIMER',
	'E.RES.SUPPORTED_VALID',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

 # for invite-request (override)
 {'TY:'=>'ENCODE', 'ID:'=>'E.REQUIRE_TIMER', 'PT:'=>'HD', 'NX:'=>'Via',
  'FM:'=> 'Require: timer',
 },

 # for response of session timer refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.RE-INVITE.SESSION-EXPIRES.CALLER', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', '', STATUS) } ],
 },

 # for response of session timer refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.RE-INVITE.SESSION-EXPIRES.CALLEE', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s;refresher=uac',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', '', NDFIRST) } ],
 },

 # for response of session timer refresher=uac expires 89s
 {'TY:'=>'ENCODE', 'ID:'=>'E.RE-INVITE.SESSION-EXPIRES_89.CALLEE', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: 89;refresher=uac',
 },

 # for response
 {'TY:'=>'ENCODE', 'ID:'=>'E.RES.SUPPORTED_VALID.TIMER', 'PT:'=>'HD', 'NX:'=>'Require', 
  'FM:'=> 'Supported: %s',
  'AR:'=> [ \q{ FV('HD.Supported.txt', @_) } ],
 },


 # for response of session timer refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.UPDATE.SESSION-EXPIRES.CALLER', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', '', STATUS) } ],
 },

 # for response of session timer refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.UPDATE.SESSION-EXPIRES.CALLEE', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s;refresher=uac',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', '', NDFIRST) } ],
 },


 # for response of session timer refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.RE-INVITE_200.SESSION-EXPIRES', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', '', REQUEST) } ],
 },


 # for response of session timer refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.Initial-200.SESSION-EXPIRES.REFRESHER-UAC', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s;refresher=uac',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', '', REQUEST) } ],
 },

 # for response of session timer refresher=uas
 {'TY:'=>'ENCODE', 'ID:'=>'E.Initial-200.SESSION-EXPIRES.REFRESHER-UAS', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s;refresher=uas',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', '', REQUEST) } ],
 },


 # for response of session timer refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.Initial-200.SESSION-EXPIRES.NO-REFRESHER-PARAMETER', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', '', REQUEST) } ],
 },


# for response of session timer refresher=uac
 {'TY:'=>'ENCODE', 'ID:'=>'E.UPDATE.SESSION-EXPIRES.REFRESHER-UAC', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s;refresher=uac',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', '',REQUEST) } ],
 },

 # for response of session timer refresher=uas
 {'TY:'=>'ENCODE', 'ID:'=>'E.RES.SESSION-EXPIRES.REFRESHER-UAS', 'PT:'=>'HD', 'NX:'=>'Supported',
  'FM:'=> 'Session-Expires: %s;refresher=uas',
  'AR:'=> [ \q{ FV('HD.Session-Expires.val.txt', @_) } ],
 },


 {'TY:'=>'ENCODE', 'ID:'=>'E.SESSION-EXPIRES-RETURN','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: %s',
  'AR:'=>[\q{ FV('HD.Session-Expires.val.txt', '',STATUS)}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.UPDATE.SESSION-EXPIRES','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: %s',
  'AR:'=>[\q{ FV('HD.Session-Expires.val.txt', '',STATUS)}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.UPDATE-200.SESSION-EXPIRES','PT:'=>HD, 'NX:'=>'Supported',
  'FM:'=>'Session-Expires: %s',
  'AR:'=>[\q{ FV('HD.Session-Expires.val.txt',@_)}]},


# INVITE request(with SDP and Session Timer)
 {'TY:'=>'RULESET',
  'ID:'=>'ES.REQUEST.re-INVITE.SESSION-TIMER.TM',
  'MD:'=>'SEQ', 
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.SUPPORTED_TIMER',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg
 },

# Generic firward request with session timer
 {'TY:'=>'RULESET',
  'ID:'=>'SS.GENERIC.FORWARD-REQUEST.SESSION-TIMER',
  'MD:'=>'SEQ', 
  'RR:'=>[
          'S.RECORD-ROUTE_EXIST',
         ],
  'EX:' =>\&MargeSipMsg
 },


 # %% RECORD-ROUTE:03 %%	Record-Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RECORD-ROUTE_EXIST', 'CA:' => 'Record-Route',
   'OK:' => "A Record-Route header field SHOULD exist.", 
   'NG:' => "A Record-Route header field SHOULD exist.", 
   'RT:' => "warning", 
   'EX:' =>\'FFIsExistHeader("Record-Route",@_)'},

# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.LOCAL-SESSION-EXPIRES.REMOTE-SESSION-EXPIRES', 'CA:' => 'Session-Expires',
   'OK:' => \\'A Session-Expires parameter(%s) MUST equal other node send Session-Expires parameter(%s).', 
   'NG:' => \\'A Session-Expires parameter(%s) MUST equal other node send Session-Expires parameter(%s).', 
   'EX:' => \q{ FFop('eq',FV('HD.Session-Expires.val.seconds',@_),FV('HD.Session-Expires.val.seconds','',NDPKT(@_[1])),@_)
             }
 },

# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.LOCAL-SESSION-EXPIRES.FIRST-INVITE-REMOTE-SESSION-EXPIRES', 'CA:' => 'Session-Expires',
   'OK:' => \\'A Session-Expires parameter(%s) MUST equal other node receive Session-Expires parameter(%s).', 
   'NG:' => \\'A Session-Expires parameter(%s) MUST equal other node receive Session-Expires parameter(%s).', 
   'EX:' => \q{ FFop('eq',FV('HD.Session-Expires.val.seconds',@_),FV('HD.Session-Expires.val.seconds','',NDPKT('','','FIRST','recv','RQ.Request-Line.method','INVITE')),@_)
             }
 },


# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.LOCAL-SESSION-EXPIRES.LESS.REMOTE-SESSION-EXPIRES', 'CA:' => 'Session-Expires',
   'OK:' => \\'A Session-Expires parameter(%s) MUST less or equal other node send Session-Expires parameter(%s).', 
   'NG:' => \\'A Session-Expires parameter(%s) MUST less or equal other node send Session-Expires parameter(%s).', 
   'EX:' => \q{ FFop('>=',FV('HD.Session-Expires.val.seconds',@_),FV('HD.Session-Expires.val.seconds','',NDPKT(@_[1])),@_)
             }
 },

# Min-SE parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.LOCAL-SESSION-EXPIRES-PARAMETER.REMOTE-SESSION-EXPIRES-PARAMETER', 'CA:' => 'Session-Expires',
   'OK:' => \\'A Session-Expires parameter(%s) MUST equal Other node sends Session-Expires parameter(%s).', 
   'NG:' => \\'A Session-Expires parameter(%s) MUST equal Other node sends Session-Expires parameter(%s).', 
   'EX:' => \q{ FFop('eq',FV('HD.Session-Expires.val.param.txt',@_),FV('HD.Session-Expires.val.param.txt','',NDPKT(@_[1])),@_)
             }
 },



# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.LOCAL-SESSION-EXPIRES.GRATER.REMOTE-MIN-SE', 'CA:' => 'Session-Expires',
   'OK:' => \\'A Session-Expires parameter(%s) MUST grater or equal other node send Min-SE parameter(%s).', 
   'NG:' => \\'A Session-Expires parameter(%s) MUST grater or equal other node send Min-SE parameter(%s).', 
   'EX:' => \q{ FFop('>=',FV('HD.Session-Expires.val.seconds',@_),FV('HD.Min-SE.val.seconds','',NDPKT(@_[1])),@_)
             }
 },

# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.LOCAL-SESSION-EXPIRES.EQUAL.LOCAL-MIN-SE', 'CA:' => 'Session-Expires',
   'OK:' => \\'A Session-Expires parameter(%s) MUST equal Min-SE parameter(%s).', 
   'NG:' => \\'A Session-Expires parameter(%s) MUST equal Min-SE parameter(%s).', 
   'EX:' => \q{ FFop('eq',FV('HD.Session-Expires.val.seconds',@_),FV('HD.Min-SE.val.seconds',@_),@_)
             }
 },


# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SESSION-EXPIRES.RECOMMEND-1800', 'CA:' => 'Session-Expires',
   'PR:' => \q{FFIsExistHeader("Session-Expires",@_)},
   'OK:' => \\'A Session-Expires parameter(%s) RECOMMENDED equal 1800.', 
   'NG:' => \\'A Session-Expires parameter(%s) RECOMMENDED equal 1800.', 
   'RT:' => "warning", 
   'EX:' => \q{ FFop('eq',FV('HD.Session-Expires.val.seconds',@_),1800,@_)
             }
 },

# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SESSION-EXPIRES.GRATER-1800', 'CA:' => 'Session-Expires',
   'PR:' => \q{FFIsExistHeader("Session-Expires",@_)},
   'OK:' => \\'A Session-Expires parameter(%s) SHOULD grater or equal 1800.', 
   'NG:' => \\'A Session-Expires parameter(%s) SHOULD grater or equal 1800.', 
   'RT:' => "warning", 
   'EX:' => \q{ FFop('>=',FV('HD.Session-Expires.val.seconds',@_),1800,@_)
             }
 },

# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SESSION-EXPIRES.REFRESHER-NOTEXIST', 'CA:' => 'Session-Expires',
   'PR:' => \q{FFIsExistHeader("Session-Expires",@_)},
   'OK:' => \\'A Session-Expires parameter MUST NOT exist refresher parameter.', 
   'NG:' => \\'A Session-Expires parameter MUST NOT exist refresher parameter.', 
   'EX:' => \q{ !FFIsExistStr("refresher",FV('HD.Session-Expires.val.txt',@_),'',@_)
             }
 },

# Session-Expires parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SESSION-EXPIRES.REFRESHER_UAC-EXIST', 'CA:' => 'Session-Expires',
   'PR:' => \q{FFIsExistHeader("Session-Expires",@_)},
   'OK:' => \\'A Session-Expires parameter MUST exist refresher=uac.', 
   'NG:' => \\'A Session-Expires parameter MUST exist refresher=uac.', 
   'EX:' => \q{ FFIsExistStr("uac",FV('HD.Session-Expires.val.param.refresher=',@_),'',@_)
             }
 },




# Min-SE parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.LOCAL-MIN-SE.REMOTE-MIN-SE', 'CA:' => 'Min-SE',
   'OK:' => \\'A Min-SE parameter(%s) MUST equal other node send Min-SE parameter(%s).', 
   'NG:' => \\'A Min-SE parameter(%s) MUST equal other node send Min-SE parameter(%s).', 
   'EX:' => \q{ FFop('eq',FV('HD.Min-SE.val.seconds',@_),FV('HD.Min-SE.val.seconds','',NDPKT(@_[1])),@_)
             }
 },

# Min-SE parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.LOCAL-MIN-SE.FIRST-INVITE-REMOTE-MIN-SE', 'CA:' => 'Min-SE',
   'OK:' => \\'A Min-SE parameter(%s) MUST equal other node receive Min-SE parameter(%s).', 
   'NG:' => \\'A Min-SE parameter(%s) MUST equal other node receive Min-SE parameter(%s).', 
   'EX:' => \q{ FFop('eq',FV('HD.Min-SE.val.seconds',@_),FV('HD.Min-SE.val.seconds','',NDPKT('','','FIRST','recv','RQ.Request-Line.method','INVITE')),@_)
             }
 },

# Min-SE parameter
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.LOCAL-MIN-SE.FIRST-INVITE-GRATER-REMOTE-MIN-SE', 'CA:' => 'Min-SE',
   'OK:' => \\'A Min-SE parameter(%s) MUST grater or equal other node send Min-SE parameter(%s).', 
   'NG:' => \\'A Min-SE parameter(%s) MUST grater or equal other node send Min-SE parameter(%s).', 
   'EX:' => \q{ FFop('>=',FV('HD.Min-SE.val.seconds',@_),FV('HD.Min-SE.val.seconds','',NDPKT('','','FIRST','send','RQ.Request-Line.method','INVITE')),@_)
             }
 },



 # %% ST-1-2-3%%	UA receives 422
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.UPDATE-4XX.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.UPDATE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 

 # %% ST-1-2-3%%	UA12 receives 4xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.UPDATE-4XX.NOPX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.RE-ROUTE_NOEXIST',
              'S.CSEQ-METHOD_UPDATE',
              'S.TO-TAG_EXIST',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Require%%	Require
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE.NOTEXIST-TIMER', 'CA:' => 'Require',
   'OK:' => "RECOMMENDED a \"timer\" option-tag does not include in a Require header field.", 
   'NG:' => "RECOMMENDED a \"timer\" option-tag does not include in a Require header field.", 
   'RT:' => "warning", 
   'EX:' =>\q{!FFIsMatchStr("timer",FV('HD.Require.val.txt',@_),'',''.@_)}},


);


1



