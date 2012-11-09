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


# 
# 10/1/ 4  S.P-AUTH.HEADER_MUSTNOT-CONCAT

### modified by Horisawa (2006.1.11)

$CVA_LOCAL_RSEQ_NUM = 11;   ## it seems to be not so good. 
$CVA_REMOTE_RSEQ_NUM = '';

@SIPUAExtend100relRules=
(
 {'TY:'=>'DECODE', 'ID:' => 'D.CSEQ_LOCAL_NUM_SYNC',
  'VA:'=>[('HD.CSeq.val.csno', CVA_LOCAL_CSEQ_NUM)]},

 {'TY:'=>'DECODE', 'ID:' => 'D.RSEQ_LOCAL_NUM_SYNC',
  'VA:'=>[('HD.RSeq.val.responsenum', CVA_LOCAL_RSEQ_NUM)]},

 {'TY:'=>'RULESET', 'ID:' => 'D.LOCAL_NUM_SYNC',
  'RR:'=>['D.CSEQ_LOCAL_NUM_SYNC', 'D.RSEQ_LOCAL_NUM_SYNC']},

 {'TY:'=>'DECODE', 'ID:' => 'D.REMOTE_RSEQ',
  'VA:'=>[('HD.RSeq.val.responsenum', CVA_REMOTE_RSEQ_NUM)]},

#-----------SYNTAX RULE START----------

### Judgment rule for "Supported" header
### (Basis for a determination : )
###   modified by Horisawa (2006.1.18)
# %%SUPPORTED: 02 %% If the Supported header support 100rel.
{'TY:'=>'SYNTAX',
 'ID:'=>'S.SUPPORTED_100REL',
 'CA:'=>'Supported',
 'OK:'=>"The Supported Header(%s) MUST include the \"100rel\" if the UAC indicate the supporting of provisional response. OK",
 'NG:'=>\\'The Supported Header(%s) MUST include the \"100rel\" if the UAC indicate the supporting of provisional response. NG',
 'EX:'=>\q{FFIsMatchStr('100rel',\\\'HD.Supported.txt','','',@_)}
},

### Auth rule for PRACK 
### (Basis for a determination : RFC3262-9-1)
###   written by Horisawa (2006.1.11)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.PRACK.P-AUTH-RESPONSE.CALCULATE',
 'CA:'=>'Proxy-Authorization',
 'OK:'=>\\'The response parameter(%s) in the Proxy-Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/qop=auth)',
 'NG:'=>\\'The response parameter(%s) in the Proxy-Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/qop=auth)',
 'EX:'=>\q{FFop('EQ',FVm('HD.Proxy-Authorization.val.digest.response','HD.Proxy-Authorization.val.digest.realm',$CNT_AUTH_REALM,@_),
				OpCalcAuthorizationResponse2('Proxy-Authorization',FV('RQ.Request-Line.method',@_) eq 'PRACK'?'INVITE':FV('RQ.Request-Line.method',@_),'HD.Proxy-Authorization.val.digest.realm',$CNT_AUTH_REALM,'auth',@_),@_)}
},

# %%SUPPORTED: 03 %% If the Supported header support 100rel. _ SHOULD
###   modified by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.SUPPORTED_100REL_SHOULD',
 'CA:'=>'Supported',
 'OK:'=>"The Supprted Header(%s) SHOULD include the \"100rel\" if the UAC indicate the supporting of provisional response. OK", 
 'NG:'=>\\'The Supprted Header(%s) SHOULD include the \"100rel\" if the UAC indicate the supporting of provisional response. NG', 
 'RT:'=>"warning",
 'EX:'=>\q{FFIsMatchStr('100rel',\\\'HD.Supported.txt','','',@_)}
},

# %% REQUIRE: 05 %%    No 100rel in Require header (if there is the Require header)
###   modified by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.REQUIRE_NO100REL',
 'CA:'=>'Require',
 'OK:'=>"The 100rel MUST NOT be present in any requests excepting INVITE if the Require header is exist. ", 
 'NG:'=>\\'The 100rel MUST NOT be present in any requests excepting INVITE if the Require header is exist.', 
 'PR:'=>\q{FFIsExistHeader("Require",@_)},
 'EX:'=>\q{FFIsMatchStr('100rel',\\\'HD.Require.txt','','',@_)}
},


##-------------RSEQ----------------
 # %% RSEQ:1 %%   RSEQ must exist
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RSEQ_EXIST', 'CA:' => 'RSeq',
   'OK:' => "A RSeq header field MUST exist.", 
   'NG:' => "A RSeq header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("RSeq",@_)'},

 # %% RSEQ:2 %%   RSEQ expression check and value must be under 2**31
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RSEQ-SEQNO_32BIT', 'CA:' => 'RSeq',
   'OK:' => \\'The RSeq value(%s) MUST be expressible as a 32-bit unsigned integer and MUST be less than 2**31.', 
   'NG:' => \\'The RSeq value(%s) MUST be expressible as a 32-bit unsigned integer and MUST be less than 2**31.', 
   'PR:' =>\'FFIsExistHeader("RSeq",@_)',
   'EX:' =>\q{FFop('<',\\\'HD.RSeq.val.responsenum',2**31,@_)}},

 # %% RSEQ:3 %%	 HD.RSeq.val.responsenum MUST increased by one 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RSEQ-SEQNO-REQ-RSEQ-SEQNO_INCREMENT', 'CA:' => 'RSeq',
   'OK:' => \\'RSeq (%s) MUST be the value incremented by one(%s) from that of the previous RSeq, if any.', 
   'NG:' => \\'RSeq (%s) MUST be the value incremented by one(%s) from that of the previous RSeq, if any.', 
   'PR:' => \q{ ( FFIsExistHeader("RSeq",@_) ) && ( $CVA_REMOTE_RSEQ_NUM ne '') },
   'EX:' => \q{FFop('eq',\\\'HD.RSeq.val.responsenum',$CVA_REMOTE_RSEQ_NUM+1, @_) }
 }, 

 # %% RSEQ:4 %%   RSEQ must not exist
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RSEQ_NOTEXIST', 'CA:' => 'RSeq',
   'OK:' => "A RSeq header field MUST NOT exist.", 
   'NG:' => "A RSeq header field MUST NOT exist.", 
   'EX:' => \q{!FFIsExistHeader('RSeq',@_)}
 },

##-------------RAck----------------
 # %% RAck:1 %%   RAck must exist
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RACK_EXIST', 'CA:' => 'RAck',
   'OK:' => "A RAck header field MUST exist.", 
   'NG:' => "A RAck header field MUST exist.", 
   'EX:' =>\q{FFIsExistHeader("RAck",@_)}
 },

 # %% RAck:2 %%   RAck responsenum Must equal to the response's RSeq number.
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RACK_EQUAL_RESPONSENUM', 'CA:' => 'RAck',
   'OK:' => \\'A responsenum(%s) of RAck header MUST equal the provisional response\'s RSeq number(%s).',
   'NG:' => \\'A responsenum(%s) of RAck header MUST equal the provisional response\'s RSeq number(%s)',
   'PR:' => \q{$CVA_LOCAL_RSEQ_NUM ne ''},
   'EX:' => \q{FFop('eq', \\\'HD.RAck.val.responsenum', $CVA_LOCAL_RSEQ_NUM, ,@_,@_) }
###   'EX:' => \q{FFop('eq', \\\'HD.RAck.val.responsenum', FV('HD.RSeq.val.responsenum','', PKT('LAST','send')), @_) }
###   'EX:' => \q{FFop('eq', \\\'HD.RAck.val.responsenum', $CVA_REMOTE_RSEQ_NUM, @_) }
 },

 # %% RAck:3 %%   RAck's CSeq must equal to the response's HD.CSeq.txt
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RACK_EQUAL_CSEQTXT', 'CA:' => 'RAck',
   'OK:' => \\'A CSeq(%s) of RAck header MUST equal the Cseq\'s value(%s) of provisional response.',
   'NG:' => \\'A CSeq(%s) of RAck header MUST equal the Cseq\'s value(%s) of provisional response.',
   'PR:' => \q{$CVA_LOCAL_RSEQ_NUM ne ''},
   'EX:' => \q{
		FFop('eq', \\\'HD.RAck.val.cseqnum', FV('HD.CSeq.val.csno','', PKT('LAST','send')), @_) &&
		FFop('eq', \\\'HD.RAck.val.method', FV('HD.CSeq.val.method','', PKT('LAST','send')), @_) 
		}
 },



# %% REQUIRE:05 %%	Must send non-100 provional response if the 1st request has [Require:100rel].
###   modified by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.PRACK_NOTSEND_INVALID-STATUS100',
 'CA:'=>'Request',
 'OK:'=>"The UAS MUST NOT attempt to send a 100(Trying) response reliably.", 
 'NG:'=>"The UAS MUST NOT attempt to send a 100(Trying) response reliably.", 
 'EX:'=>\q{ FFop('ne',\\\'RQ.Status-Line.code','100',@_)}
},

# %% REQUIRE:05 %%	Must send non-100 provional response if the 1st request has [Require:100rel].
###   modified by Horisawa (2006.1.20)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.REQUESTLINE_SEND1XX',
 'CA:'=>'Request',
 'OK:'=>"The UAS MUST send any non-100 provisional response reliably if the initial request contained a Require header field with \"100rel\".", 
 'NG:'=>"The UAS MUST send any non-100 provisional response reliably if the initial request contained a Require header field with \"100rel\".", 
 'PR:'=>\q{ FFop('eq', '100rel', FVib('send','HD.Require.val','','RQ.Request-Line.method','INVITE')) },
 'EX:'=>sub{
            my($rule,$pktinfo,$context)=@_;
            $scode = FV('RQ.Status-Line.code','',$pktinfo);
            $context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'via','ARG1:'=>$scode};
            if ($scode =~ /^[1]/) {
                return 'MATCH';
            } else {
                return '';
            } 
 		}
},

 # %% REQUIRE:06 %%	Require MUST have 100rel
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE_100rel', 'CA:' => 'Require',
   'OK:' => "A Require header MUST contain the \"100rel\".", 
   'NG:' => "A Require header MUST contain the \"100rel\".", 
   'PR:' =>\q{FFIsExistHeader("Require",@_)},
   'EX:' => \q{FFIsMatchStr('100rel',\\\'HD.Require.val','','',@_ ) }
 },


 # %% CSEQ:06 %%	Cseq's method is [PRACK]
 { 'TY:' => 'SYNTAX',
   'ID:' => 'S.CSEQ-METHOD_PRACK', 
   'CA:' => 'CSeq',
   'OK:' => "The method of CSeq header MUST be \"PRACK\".", 
   'NG:' => \\'The method(%s) of CSeq header MUST be \"PRACK\".', 
   'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.method','PRACK',@_)}},

 # %% MUSTNOT:02 %%	[MUST-NOT-INCLUDE] List
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MUSTNOT-HEADER_PRACK', 'CA:' => 'Header',
   'OK:' => "A PRACK request MUST NOT include these header fields: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.", 
   'NG:' => "A PRACK request MUST NOT include these header fields: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.", 
   'EX:' => \q{!FFIsExistHeader(['Alert-Info','Call-Info','Contact','Expires','In-Reply-To','Organization','Priorit','Reply-To','Subject'],@_)}}, 

 # %% CSEQ:13 %%	Is match with PRACK's CSEQ's no
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ_NUM_PRACK', 'CA:' => 'CSeq',
   'OK:' => \\'The CSeq header field(%s) of the provisional response MUST equal the CSeq field(%s) of the PRACK.', 
   'NG:' => \\'The CSeq header field(%s) of the provisional response MUST equal the CSeq field(%s) of the PRACK.', 
   'EX:' => \q{FFop('eq',\\\'HD.CSeq.val.csno', FVib('send','','','HD.CSeq.val.csno','RQ.Request-Line.method','PRACK') ,@_) }
 },

 # %% CSEQ:14 %%	Is match with PRACK's CSEQ's no
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ_NUM_INVITE', 'CA:' => 'CSeq',
   'OK:' => \\'The CSeq header field(%s) of the provisional response MUST equal the CSeq field(%s) of the INVITE.', 
   'NG:' => \\'The CSeq header field(%s) of the provisional response MUST equal the CSeq field(%s) of the INVITE.', 
   'EX:' => \q{FFop('eq',\\\'HD.CSeq.val.csno', FVib('send','','','HD.CSeq.val.csno','RQ.Request-Line.method','INVITE') , @_ ) }
 },

 # The Via header's value must same as that of INVITE
 # based on [S.VIA_TWOPX_SEND_EQUALS.VI]
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_TWOPX_SEND_EQUALS_INVITE.VI', 'CA:' => 'Via',
   'OK:' => \\'The Via headers(%s) MUST equal those(%s) in the INVITE(except received parameter of 1st Via).', 
   'NG:' => \\'The Via headers(%s) MUST equal those(%s) in the INVITE(except received parameter of 1st Via).', 
   'EX:' => \q{OpViaMachLines( FVs('HD.Via.val.via.by','',PKT('LAST','send','RQ.Request-Line.method','INVITE') ) ,3 ,@_)}
 }, 

 # The Via header's branch must same as that of INVITE
 # based on [S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX]
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX_INVITE', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
   'NG:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.', 
   'EX:' =>\q{FFop('EQ',FVs('HD.Via.val.via.param.branch=',@_),
			FVs('HD.Via.val.via.param.branch=','', PKT('LAST','send','RQ.Request-Line.method','INVITE')),@_)}
 },

# Is the Status-code 5XX?
###   modified by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.STATUS_CODE_IS5XX',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be 5XX (Server Error).',
 'NG:'=>\\'Status-Code(%s) MUST be 5XX (Server Error).',
 'EX:'=>\q{ (FV('RQ.Status-Line.code',@_) =~ /^5/) }
},

# Is the Status-code 481?
###   modified by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.STATUS_CODE_IS481',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be 481 (Call/Transaction Does not exist).',
 'NG:'=>\\'Status-Code(%s) MUST be 481 (Call/Transaction Does not exist).',
 'EX:'=>\q{ FFop('eq',\\\'RQ.Status-Line.code','481',@_) }
},

# Is the Status-code 420.?
###   modified by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.STATUS_CODE_IS420',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be 420 (Bad Extention).',
 'NG:'=>\\'Status-Code(%s) MUST be 420 (Bad Extention).',
 'EX:'=>\q{ FFop('eq',\\\'RQ.Status-Line.code','420',@_) }
},

# The Unsupported Header must EXIST
###   modified by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.UNSUPPORTED_EXIST',
 'CA:'=>'Unsupported',
 'OK:'=>\\'The Unsupported Header MUST Exist. ',
 'NG:'=>\\'The Unsupported Header MUST Exist. ',
 'EX:'=>\q{FFIsExistHeader("Unsupported", @_) } 
},

# The Unsupported Header must include 100rel
###   modified by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.UNSUPPORTED_100REL',
 'CA:'=>'Unsupported',
 'OK:'=>\\'The Unsupported Header(%s) MUST have the 100rel. ',
 'NG:'=>\\'The Unsupported Header MUST have the 100rel. ',
 'PR:'=>\q{FFIsExistHeader("Require",@_)},
 'EX:'=>\q{FFIsMatchStr('100rel',\\\'HD.Unsupported.txt','','',@_)}
},

 # The Re-Invite's Request-URI must same as provisional response's contact 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_CONTACT-URI', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) of the message MUST be the URI of Contact in the first transmitted response(%s). ', 
   'NG:' => \\'The Request-URI(%s) of the message MUST be the URI of Contact in the first transmitted response(%s). ', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','strict-without-port',
	FV('RQ.Request-Line.uri',@_),
	FVib('send', '','','HD.Contact.val.contact.ad.txt','RQ.Status-Line.code','183'),		@_)}
 },

### Auth Rule for PRACK 
### (Basis for a determination : RFC3262-9-1)
###   written by Horisawa (2006.1.11)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.PRACK.P-AUTH.EXIST',
 'CA:'=>'Proxy-Authorization',
 'OK:'=>\\'The Proxy-Authorization header SHOULD be included in PRACK request.',
 'NG:'=>\\'The Proxy-Authorization header SHOULD be included in PRACK request.',
 'RT:' => "warning",
 'PR:'=>\q{$CNT_CONF{'AUTH-SUPPORT'} eq 'T'},
 'EX:'=>\q{FFIsExistHeader("Proxy-Authorization",@_)},
},


#----------------------RULE SET---------------------------

# Ruleset for 4xx response for PRACK 
#   written by Horisawa (2006.2.21)
{  
   'TY:' => 'RULESET',
   'ID:' => 'SSet.STATUS.PRACK-4XX.PX',
   'RR:' => [
            'SSet.ResMesg',
            'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
            'S.VIA-RECEIVED_EXIST_PX',
            'S.VIA_TWOPX_SEND_EQUALS.VI',
            'S.TO-TAG_EXIST',
            'S.CSEQ-METHOD_PRACK',
            'D.COMMON.FIELD.STATUS',
            ]       
},


 # %% RSeq check rule set. %% 
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.RSEQ', 
   'RR:' => [
		'S.RSEQ_EXIST',
		'S.RSEQ-SEQNO_32BIT',
		'S.RSEQ-SEQNO-REQ-RSEQ-SEQNO_INCREMENT',
            ]
 }, 

 # %% RAck check rule set. %% 
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.RACK', 
   'RR:' => [
		'S.RACK_EXIST',
		'S.RACK_EQUAL_RESPONSENUM',
		'S.RACK_EQUAL_CSEQTXT'
            ]
 }, 

 # %% PRACK module set. %%	BYE $B6&DL$N%k!<%k%;%C%H (B
 ###   modified by Horisawa (2006.1.13)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.PRACK', 
   'RR:' => [
              'SSet.ReqMesg',
              'S.R-URI_REQ-CONTACT-URI',
              'S.MUSTNOT-HEADER_PRACK',  ## changed from 'S.MUSTNOT-HEADER_BYE',
			  'S.PRACK.P-AUTH.EXIST',
              'S.CSEQ-METHOD_PRACK',    ##changed from 'S.CSEQ-METHOD_BYE',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
            ]
 }, 

 # Based on [SSet.ResMesg]
 # %% ResMesg for PRACK-200 %%   Fix the cseq problem between 200(for PRACK) and 200(for INVITE)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ResMesgSmall', 
   'RR:' => [
             'SSet.ALLMesg',
             'S.FROM-URI_LOCAL-URI',
             'S.FROM-TAG_LOCAL-TAG',
             'S.TO-URI_REMOTE-URI',
             'S.CALLID_VALID'
###             'S.CSEQ-SEQNO_SEND-SEQNO',
            ]
 }, 

# Based on [SSet.BYE.PX]
# %% PRACK entire set. %% 
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.PRACK.PX', 
   'RR:' => [
              'SSet.PRACK',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
			  'SSet.PRACK.AUTH.PX',
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.TO-TAG_LOCAL-TAG',
              'S.CALLID_VALID',
              'S.ROUTE_EXIST',
              'S.ROUTE_ROUTESET_REVERSE.TWOPX', 
              'SSet.RACK',
	      'D.COMMON.FIELD.REQUEST'
            ]
 }, 

# Proxy receives 100 Trying.(two proxies)
# Based on [SSet.STATUS.INVITE-100.PX]
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-100.NOPROVISIONALRESPONSE.PX', 
   'RR:' => [
              'SSet.STATUS.INVITE-100.PX',
              'S.RSEQ_NOTEXIST',	### added
              'S.REQUIRE_NO100REL'	### added
            ]
 }, 

 # %% INVITE-180  %% 180 provisional response for INVITE (OUTSIDE of DIALOG)
 # based on [SSet.STATUS.INVITE-180.PX]
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-1XX.OUTSIDE.PX', 
   'RR:' => [
		'SSet.ResMesgSmall',
		'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX_INVITE',	
		'S.VIA-RECEIVED_EXIST_PX',
		'S.VIA_TWOPX_SEND_EQUALS_INVITE.VI',
		'S.TO-TAG_EXIST',
		'S.CSEQ-METHOD_INVITE',
		'S.CSEQ_NUM_INVITE',
		'S.REQUESTLINE_SEND1XX',
		'S.PRACK_NOTSEND_INVALID-STATUS100',
		'S.RE-ROUTE_EXIST',
		'S.RE-ROUTE_ROUTESET_REVERSE.TWOPX',
		'S.BODY_EXIST',		# IG (when RFC, same as S.BODY_EXIST_SHOULD)
		'SSet.SDP-ANS',	
		'SSet.RSEQ',
		'S.REQUIRE_EXIST',
		'S.REQUIRE_100rel',
		'D.COMMON.FIELD.STATUS', # the D.XX is not in the original rule set.
		'D.REMOTE_RSEQ'
            ]
 }, 

 # %% INVITE-180  %% 180 provisional response for INVITE (INSIDE of DIALOG)
 # based on [SSet.STATUS.INVITE-1XX.OUTSIDE.PX]
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-1XX.INSIDE.PX', 
   'RR:' => [
		##'SSet.ResMesg',
		'SSet.ResMesgSmall',		### added
		##'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
		'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX_INVITE',		### added
		'S.VIA-RECEIVED_EXIST_PX',
		##'S.VIA_TWOPX_SEND_EQUALS.VI',
		'S.VIA_TWOPX_SEND_EQUALS_INVITE.VI',	### added
		'S.TO-TAG_EXIST',
		'S.CSEQ-METHOD_INVITE',
		'S.CSEQ_NUM_INVITE',    ### added
		'S.REQUESTLINE_SEND1XX',	### added
		'S.PRACK_NOTSEND_INVALID-STATUS100',	### added
		'SSet.RSEQ',		  ### added
		'S.REQUIRE_EXIST',	### added
		'S.REQUIRE_100rel',	### added
##		'D.COMMON.FIELD.STATUS', ### added( the D.XX is not in the original rule set.)  
##		'D.REMOTE_RSEQ'           ### added
            ]
 }, 

 # %% PRACK-200 %%	[200 OK] response for PRACK .
 ## based on [SSet.REQUEST.BYE-200.PX]
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.PRACK.200.PX', 
   'RR:' => [
###		'SSet.ResMesg',
		'SSet.ResMesgSmall',		### added
		'S.CSEQ_NUM_PRACK',    ### add
		'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
		'S.VIA-RECEIVED_EXIST_PX',
		'S.VIA_TWOPX_SEND_EQUALS.VI',
		'S.TO-TAG_EXIST',
		'S.TO-TAG_REMOTE-TAG',
##		'S.CSEQ-METHOD_PRACK',		### added
##		'D.COMMON.FIELD.STATUS' ### added( the D.XX is not in the original rule set.)
            ]
 }, 

 # %% INVITE-200 %%	INVITE and receives 200 in INSIDE of DIALOG Mode.
 ## Based on [SSet.STATUS.INVITE.PX] 
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE.200.INSIDE.PX', 
   'RR:' => [
		'SSet.ResMesgSmall',
		'S.CSEQ_NUM_INVITE', 
		'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX_INVITE',	
		'S.VIA-RECEIVED_EXIST_PX',
		'S.VIA_TWOPX_SEND_EQUALS_INVITE.VI',
		'S.TO-TAG_EXIST',
		'S.TO-TAG_REMOTE-TAG',
		'S.CONTACT_EXIST',
		'S.CONTACT_QUOTE',
		'S.CSEQ-METHOD_INVITE',
            ]
 }, 

 # Proxy receives re-INVITE.
 # Based on [SSet.REQUEST.RE-INVITE-HOLD]
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.RE-INVITE', 
   'RR:' => [
		'SSet.INVITE',
		'S.R-URI_REQ-CONTACT-URI', 
		'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
		'S.TO-TAG_LOCAL-TAG',
		'S.ROUTE_EXIST',		### add
		'S.ROUTE_ROUTESET_REVERSE.TWOPX',  ### add
		'S.CALLID_VALID', 
		'S.SDP.O-VERSION-INCREMENT',
		'S.SDP.A-SENDONLY',
		'S.SDP.M-LINE_MEDIA-DESCRIPTION-CONTAIN',
		'D.COMMON.FIELD.REQUEST'
            ]
 }, 

### Auth Ruleset for PRACK 
### (Basis for a determination : RFC3262-9-1)
###   written by Horisawa (2006.1.11)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.PRACK.AUTH.PX',
 'PR:'=>\q{$CNT_CONF{'AUTH-SUPPORT'} eq 'T' && FFIsExistHeader("Proxy-Authorization",@_)},
 'RR:'=>['S.P-AUTH.DIGEST',
		 'S.P-AUTH-NC.EXIST',
	 	 'S.P-AUTH-NONCE.EXIST',
		 'S.P-AUTH-NONCE.REQ-NONCE',
		 'S.P-AUTH-REALM.EXIST',
		 'S.P-AUTH-REALM.REQ-REALM',
		 'S.P-AUTH-RESPONSE.EXIST',
 		 'S.PRACK.P-AUTH-RESPONSE.CALCULATE',
		 'S.P-AUTH-URI.EXIST',
		 'S.P-AUTH-URI.DQUOT',
		 'S.P-AUTH-CNONCE.EXIST',
		 'S.P-AUTH-USERNAME.EXIST',
		 'S.P-AUTH-USERNAME_CONFIG',
		 'S.P-AUTH-qop.Auth',
##		 'S.P-AUTH.HEADER_MUSTNOT-CONCAT',
 	],
},


#-----------SYNTAX RULE END----------
#-----------ENCODE RULE--------------

### "Allow" header with RFC 3261 method plus PRACK
### (Basis for a determination : RFC3261-13-2)
###   written by Horisawa (2006.1.11)
{'TY:'=>'ENCODE',
 'ID:'=>'E.ALLOW_VALID.PLUS_PRACK',
 'PT:'=>'HD',
 'NX:'=>'Supported',
 'FM:'=>'Allow: INVITE,ACK,CANCEL,OPTIONS,BYE,PRACK',
},

### "CSeq" header for ACK request 
###   written by Horisawa (2006.1.16)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.CSEQ_NUM_ACK.LAST_INVITE',
 'PT:'=>'HD',
 'NX:'=>'Call-ID',
 'FM:'=>'CSeq: %s ACK',
 'AR:'=>[\q{FVib('send','','','HD.CSeq.val.csno','RQ.Request-Line.method','INVITE')}]
},

### "CSeq" header for ACK request, using the last sent PRACK request
###   written by Horisawa (2006.1.16)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.CSEQ_NUM_ACK.LAST_PRACK',
 'PT:'=>'HD',
 'NX:'=>'Call-ID',
 'FM:'=>'CSeq: %s ACK',
 'AR:'=>[\q{FVib('send','','','HD.CSeq.val.csno','RQ.Request-Line.method','PRACK')}]
},

### "CSeq" header for PRACK request on Proxy
### (in this case, local value on Proxy is used as CSeq value.)
###   written by Horisawa (2006.1.16)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.CSEQ_NUM_PRACK_ON-PROXY',
 'PT:'=>'HD',
 'NX:'=>'Call-ID',
 'FM:'=>'CSeq: 100 PRACK',
},


#  Return the Cseq value 
 {'TY:'=>'ENCODE', 'ID:' => 'E.CSEQ-INVITE-RETURN','PT:'=>HD, 
  'FM:'=>'CSeq: %s',
  'AR:'=>[\q{FVib('recv','','','HD.CSeq.txt','RQ.Request-Line.method','INVITE')}]
 },

 {'TY:'=>'ENCODE', 'ID:' => 'E.VIA-INVITE-RETURN','PT:'=>HD,
  'FM:'=>'Via: %s;received=%s',
  'AR:'=>[\q{FVib('recv','','','HD.Via.txt','RQ.Request-Line.method','INVITE')},\q{$CVA_TUA_IPADDRESS}]
 },

# include [Require: 100rel] 
### modified by Horisawa (2006.1.16)
{'TY:'=>'ENCODE',
 'ID:'=>'E.REQUIRE_100REL',
 'PT:'=>'HD',
 'NX:'=>'Contact',
 'FM:'=>'Require: 100rel'
},

# include [Supported: 100rel] (request)
### modified by Horisawa (2006.1.16)
{'TY:'=>'ENCODE',
 'ID:'=>'E.SUPPORTED_100REL',
 'PT:'=>'HD',
 'NX:'=>'Contact',
 'FM:'=>'Supported: 100rel'
},

# include [RSeq: x ] 
 { 'TY:'=> 'ENCODE', 'ID:' => 'E.RSEQ_NUM', 'PT:'=>HD,
   'NX:'=> 'Require',
   'FM:'=> 'RSeq: %s', 'AR:'=>[\q{ ++$CVA_LOCAL_RSEQ_NUM }]},

 # include [RSeq: x ] : make a situation of incorrect( The Rseq value is not increased).
 { 'TY:'=> 'ENCODE', 'ID:' => 'E.RSEQ_NUM_ADD0', 'PT:'=>HD,
   'FM:'=> 'RSeq: %s', 'AR:'=>[\q{ $CVA_LOCAL_RSEQ_NUM } ]},

 # include [RSeq: x - 1] : make a situation of incorrect( The RSeq value is decreased ).
 { 'TY:'=> 'ENCODE', 'ID:' => 'E.RSEQ_NUM_SUB1', 'PT:'=>HD,
   'FM:'=> 'RSeq: %s', 'AR:'=>[\q{ $CVA_LOCAL_RSEQ_NUM - 1 } ]},

 # include [RSeq: x + 2 ] : make a situation of incorrect( The Rseq value is increased by 2).
 { 'TY:'=> 'ENCODE', 'ID:' => 'E.RSEQ_NUM_ADD2', 'PT:'=>HD,
   'FM:'=> 'RSeq: %s', 'AR:'=>[\q{ $CVA_LOCAL_RSEQ_NUM + 2 } ]},

 # include [CSeq: x PRACK] increased by 1
 {'TY:'=>'ENCODE', 'ID:' => 'E.CSEQ_NUM_PRACK','PT:'=>HD,
  'FM:'=>'CSeq: %s PRACK','AR:'=>[\q{++$CVA_LOCAL_CSEQ_NUM}]},

 # include [CSeq: x PRACK] return the current CSEQ value.
 {'TY:'=>'ENCODE', 'ID:' => 'E.CSEQ_NUM0_PRACK','PT:'=>HD,
  'FM:'=>'CSeq: %s PRACK','AR:'=>[\\'HD.CSeq.val.csno']},

# include [RAck: x1 x2 Method ]
### modified by Horisawa (2006.1.16)
{'TY:'=>'ENCODE', 
 'ID:' => 'E.RACK_RSEQ_CSEQ_METHOD', 
 'PT:'=> HD,
 'FM:'=>'RAck: %s %s %s', 
 'AR:'=>[
#		\q{FVib('recv','','','HD.RSeq.val.responsenum','RQ.Status-Line.code','183')}, ## 2006.7.21 sawada del ##
#		\q{FVib('recv','','','HD.CSeq.val.csno','RQ.Status-Line.code','183')}, ## 2006.7.21 sawada del ##
#		\q{FVib('recv','','','HD.CSeq.val.method','RQ.Status-Line.code','183')}] ## 2006.7.21 sawada del ##
		\q{FVib('recv','','','HD.RSeq.val.responsenum',['RQ.Status-Line.code','180','183'])}, ## 2006.7.21 sawada add ##
		\q{FVib('recv','','','HD.CSeq.val.csno',['RQ.Status-Line.code','180','183'])}, ## 2006.7.21 sawada add ##
		\q{FVib('recv','','','HD.CSeq.val.method',['RQ.Status-Line.code','180','183'])}] ## 2006.7.21 sawada add ##
 },

 # include [RAck: x1 x2 Method ]
 {'TY:'=>'ENCODE', 'ID:' => 'E.RACK_RSEQ_CSEQ_METHOD_BAD', 'PT:'=> HD,
  'FM:'=>'RAck: %s %s %s', 
  'AR:'=>[\q{$CVA_LOCAL_RSEQ_NUM + 10}, \\'HD.CSeq.val.csno', \\'HD.CSeq.val.method'] 
 },

 # include [RAck: x1 x2 Method ]
 {'TY:'=>'ENCODE', 'ID:' => 'E.RACK_RSEQ_CSEQ_METHOD_BAD1', 'PT:'=> HD,
  'FM:'=>'RAck: %s %s %s', 
  'AR:'=>[\q{$CVA_LOCAL_RSEQ_NUM }, \q{$CVA_LOCAL_CSEQ_NUM + 10 }, \\'HD.CSeq.val.method'] 
 },

 # include [RAck: x1 x2 Method ]
 {'TY:'=>'ENCODE', 'ID:' => 'E.RACK_RSEQ_CSEQ_METHOD_BAD2', 'PT:'=> HD,
  'FM:'=>'RAck: %s %s %s', 
  'AR:'=>[\q{$CVA_LOCAL_RSEQ_NUM }, \q{$CVA_LOCAL_CSEQ_NUM - 10 }, \\'HD.CSeq.val.method'] 
 },

#  PRACK Request-URI=CONTACT (After dialog)
 {'TY:'=>'ENCODE', 'ID:' => 'E.PRACK_CONTACT-URI','PT:'=>RQ,
  'FM:'=>'PRACK %s SIP/2.0','AR:'=>[\'$CNT_TUA_CONTACT_URI']},

# RETURN FROM,TO,CALL-ID,CSEQ,To-tag of the nearest INVITE
 {'TY:'=>'RULESET', 'ID:' => 'EESet.BASIC-FTCC-INVITE-RETURN-TOTAG', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.FROM-RETURN',
	'E.TO-RETURN-LOCAL_TAG',
	'E.CALL-ID-RETURN',
	'E.CSEQ-INVITE-RETURN' ]
  },

 # 183 ALL-RETURN with increased by 2. Proxy->NUT
 {'TY:'=>'RULESET', 'ID:' => 'E.STATUS-183-RETURN-TWOPX-SDP-RSEQADD2.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-183',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-INVITE-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.REQUIRE_100REL',	## New
	'E.RSEQ_NUM_ADD2',		## New
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

 # 183 NO-SDP-RETURN for INVITE. Proxy->NUT
 {'TY:'=>'RULESET', 'ID:' => 'E.STATUS-183-RETURN-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-183',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-INVITE-RETURN-TOTAG',
	'E.REQUIRE_100REL',	## New
	'E.RSEQ_NUM',	## New
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


 # 183 NO-SDP-decrease-RETURN. Proxy->NUT
 {'TY:'=>'RULESET', 'ID:' => 'E.STATUS-183-RETURN-TWOPX-RSEQSUB1.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-183',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-INVITE-RETURN-TOTAG',
	'E.REQUIRE_100REL',	## New
	'E.RSEQ_NUM_SUB1',		## New
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 # 183 NO-SDP-Increased by 2-RETURN. Proxy->NUT
 {'TY:'=>'RULESET', 'ID:' => 'E.STATUS-183-RETURN-TWOPX-RSEQADD2.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-183',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-INVITE-RETURN-TOTAG',
	'E.REQUIRE_100REL',	## New
	'E.RSEQ_NUM_ADD2',		## New
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

 # 200 return against PRACK  Proxy->NUT
 {'TY:'=>'RULESET', 'ID:' => 'E.STATUS-200-PRACK-RETURN-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.FROM-RETURN',
	'E.TO-RETURN-LOCAL_TAG',
	'E.CALL-ID-RETURN',
	'E.CSEQ_NUM0_PRACK',		## New
	'E.CONTENT-LENGTH_0',],
  'EX:'=>\&MargeSipMsg},

 # 200 return against INVITE in PRACK mode  Proxy->NUT
 {'TY:'=>'RULESET', 'ID:' => 'E.INVITE-RETURN-PRACK-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[        
	'E.STATUS-200',
	'E.VIA-INVITE-RETURN',
	'E.RECORDROUTE_TWOHOPS',	
	'E.FROM-RETURN',
	'E.TO-RETURN-LOCAL_TAG',
	'E.CALL-ID-RETURN',
	'E.CSEQ-INVITE-RETURN',		## New
	'E.CONTACT_PUA',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

###############################################################
###
### 	19. Record-Route
###	Record-Route
###
###	E.RECORDROUTE_TWOHOPS	
###     SIPrulePX.pm
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOHOPS','PT:'=>HD, 
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\q{join(">,<",@CNT_PUA_TWOPX_ROUTESET)}]},


# Make PRACK 
 {'TY:'=>'RULESET', 'ID:' => 'E.PRACK.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
        'E.PRACK_CONTACT-URI',  # new
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO-RETURN-LOCAL_TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_PRACK',     # new
	'E.RACK_RSEQ_CSEQ_METHOD',    # new
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# Make PRACK with offer
 {'TY:'=>'RULESET', 'ID:' => 'E.PRACK_INCORRECT-SDP.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
        'E.PRACK_CONTACT-URI',  # new
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO-RETURN-LOCAL_TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_PRACK',     # new
	'E.RACK_RSEQ_CSEQ_METHOD_BAD',    # new
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	#'E.BODY.MEDIA-DESCRIPTION',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg}
);


