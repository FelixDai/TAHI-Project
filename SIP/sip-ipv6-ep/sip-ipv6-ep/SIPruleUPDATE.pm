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


#======================================
# Rule definition
#    for UA test (UPDATE, RFC3311)
#======================================

@SIPUAExtendUpdateRules =
(

#####################
### Ruleset (ENCODE)
#####################

### UPDATE request
###   written by Horisawa (2006.1.11)
{'TY:'=>'RULESET',
 'ID:'=>'ES.UPDATE.PX1',
 'MD:'=>'SEQ',
 'RR:'=>[
 	'E.UPDATE_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_UPDATE',
	'E.CONTACT_PUA',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID.CODEC_CHANGED',
 	],
 'EX:'=>\&MargeSipMsg,
},

### Encode ruleset for 200 response for UPDATE (with Contact and body)
###   written by Horisawa (2006.1.10)
{'TY:'=>'RULESET',
 'ID:'=>'ES.STATUS-200-UPDATE-RETURN-TWOPX-SDP-ANS.PX1',
 'MD:'=>'SEQ',
 'RR:'=>[
 	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.FROM-RETURN',
	'E.TO-RETURN-LOCAL_TAG',
	'E.CALL-ID-RETURN',
	'E.CSEQ_RETURN.LAST_UPDATE',
	'E.CONTACT_PUA',
	'E.CONTENTTYPE_VALID',			# if you don't need this, DEL locally.
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID.CODEC_CHANGED',	# if you don't need this, DEL locally.
	],
 'EX:'=>\&MargeSipMsg
},

### Encode ruleset for reliable 183 response with body
### (Basis for a determination : RFC3311-4-2)
###   written by Horisawa (2006.1.13)
{'TY:'=>'RULESET',
 'ID:'=>'ES.RFC3311-4-2_headers',
 'MD:'=>'SEQ',
 'RR:'=>[
	'E.REQUIRE_100REL',
	'E.RSEQ_NUM',
	'E.RFC3311-4-1_Allow',
	],
 'EX:'=>\&MargeSipMsg
},


#####################
### Ruleset (SYNTAX)
#####################

### Judgment rule for UPDATE request
###   written by Horisawa (2006.1.10)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.UPDATE.PX',
 'RR:'=>[
 	'SSet.ReqMesg',
	'S.R-URI_REQ-CONTACT-URI',
	'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
	'S.FROM-URI_REMOTE-URI',
	'S.FROM-TAG_REMOTE-TAG',
	'S.TO-URI_LOCAL-URI',
	'S.TO-TAG_LOCAL-TAG',
	'S.CALLID_VALID',
	'S.CSEQ-METHOD_UPDATE',
	'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
	'S.ROUTE_EXIST',
	'S.ROUTE_ROUTESET_REVERSE.TWOPX',
	'D.COMMON.FIELD.REQUEST',
 	'S.RFC3311-table1_UPDATE_Not-Applicable-headers',
 	],
},

### Judgment ruleset for 200 response (for UPDATE request)
###   written by Horisawa (2006.1.11)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.STATUS.UPDATE.200.PX',
 'RR:'=>[
 	'SSet.ResMesg',
	'S.RFC3311-5-9_2XX',
	'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
	'S.VIA-RECEIVED_EXIST_PX',
	'S.VIA_TWOPX_SEND_EQUALS.VI',
	'S.TO-TAG_EXIST',
	'S.TO-TAG_REMOTE-TAG',
	'S.CSEQ-METHOD_UPDATE',
	'D.COMMON.FIELD.STATUS',
 	'S.RFC3311-table1_response-for-UPDATE_Not-Applicable-headers',
 	]
},

### Judgment ruleset for non-200 response (for UPDATE request)
###   written by Horisawa (2006.1.18)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.STATUS.UPDATE.NON2XX.PX',
 'RR:'=>[
 	'SSet.ResMesg',
	'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
	'S.VIA-RECEIVED_EXIST_PX',
	'S.VIA_TWOPX_SEND_EQUALS.VI',
	'S.TO-TAG_EXIST',
	'S.TO-TAG_REMOTE-TAG',
	'S.CSEQ-METHOD_UPDATE',
	'D.COMMON.FIELD.STATUS',
 	'S.RFC3311-table1_response-for-UPDATE_Not-Applicable-headers',
 	]
},


###################
### Rule (ENCODE)
###################

### "Allow" header with RFC 3261 methods plus PRACK & UPDATE
### (Basis for a determination : RFC3261-13-2, RFC3311-4-1)
###   written by Horisawa (2006.1.11)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3311-4-1_Allow',
 'PT:'=>'HD',
 'NX:'=>'Supported',
 'FM:'=>'Allow: INVITE,ACK,CANCEL,OPTIONS,BYE,PRACK,UPDATE',
},

### "Allow" header with RFC 3261 methods plus PRACK & UPDATE
### (Basis for a determination : RFC3261-13-2, RFC3311-4-3)
###   written by Horisawa (2006.1.16)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3311-4-3_Allow',
 'PT:'=>'HD',
 'NX:'=>'Supported',
 'FM:'=>'Allow: INVITE,ACK,CANCEL,OPTIONS,BYE,PRACK,UPDATE',
},

### "CSeq" header for response, using the last received UPDATE request
###   written by Horisawa (2006.1.10)
{'TY:'=>'ENCODE',
 'ID:'=>'E.CSEQ_RETURN.LAST_UPDATE',
 'PT:'=>'HD',
 'FM:'=>'CSeq: %s',
 'AR:'=>[\q{FVib('recv','','','HD.CSeq.txt','RQ.Request-Line.method','UPDATE')}]
},

### body which session parameter was modified, for UPDATE request
###   written by Horisawa (2006.1.10)
{'TY:'=>'ENCODE',
 'ID:'=>'E.BODY_VALID.CODEC_CHANGED',
 'PT:'=>'BD',
 'FM:'=>\q{"v=0\r\n".
           "o=- ".$CNT_PUA_SDP_O_SESSION." %s IN IP$SIP_PL_IP".$CVA_PUA_IPADDRESS."\r\n".
           "s=-\r\n".
           "c=IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS."\r\n".
           "t=0 0\r\n".
           "m=audio %s RTP/AVP 0\r\n".
           "a=rtpmap:8 PCMA/8000"},
 'AR:'=>[sub{$CNT_PUA_SDP_O_VERSION++;return $CNT_PUA_SDP_O_VERSION;},
 		 sub{$CNT_PORT_CHANGE_RTP=$CNT_PORT_CHANGE_RTP+2;return $CNT_PORT_CHANGE_RTP;},
		],
},

### body which include unaccepable session parameter, for UPDATE request
###   written by Horisawa (2006.1.20)
{'TY:'=>'ENCODE',
 'ID:'=>'E.BODY_VALID.UNACCEPTABLE_CODEC',
 'PT:'=>'BD',
 'FM:'=>\q{"v=0\r\n".
           "o=- ".$CNT_PUA_SDP_O_SESSION." %s IN IP$SIP_PL_IP".$CVA_PUA_IPADDRESS."\r\n".
           "s=-\r\n".
           "c=IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS."\r\n".
           "t=0 0\r\n".
           "m=audio %s RTP/AVP 0\r\n".
           "a=rtpmap:90 DUMMY/8000"},
 'AR:'=>[sub{$CNT_PUA_SDP_O_VERSION++;return $CNT_PUA_SDP_O_VERSION;},
 		 sub{$CNT_PORT_CHANGE_RTP=$CNT_PORT_CHANGE_RTP+2;return $CNT_PORT_CHANGE_RTP;},
		],
},

### "CSeq" header for UPDATE request
###   written by Horisawa (2006.1.11)
{'TY:'=>'ENCODE',
 'ID:'=>'E.CSEQ_NUM_UPDATE',
 'PT:'=>'HD',
 'NX:'=>'Call-ID',
 'FM:'=>'CSeq: %s UPDATE',
 'AR:'=>[\q{++$CVA_LOCAL_CSEQ_NUM}]
},

### Request-URI for UPDATE request
###   written by Horisawa (2006.1.11)
{'TY:'=>'ENCODE',
 'ID:'=>'E.UPDATE_CONTACT-URI',
 'PT:'=>'RQ',
 'FM:'=>'UPDATE %s SIP/2.0',
 'AR:'=>[\'$CNT_TUA_CONTACT_URI'],
},

###################
### Rule (SYNTAX)
###################

### Judgment rule for "Allow" header (the presense of UPDATE) 
### (Basis for a determination : RFC3311-4-1)
###   written by Horisawa (2006.1.13)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3311-4-1_Allow',
 'CA:'=>'Allow',
 'OK:'=>\\'The Allow header SHOULD exist and include \"UPDATE\" to indicate support for the UPDATE method.',
 'NG:'=>\\'The Allow header SHOULD exist and include \"UPDATE\" to indicate support for the UPDATE method.',
 'RT:'=>'warning',
 'EX:'=>\q{FFIsExistHeader("Allow",@_) 
 		&& FFIsMember('UPDATE',FVSeparete('HD.Allow.val.txt','\s*,\s*',@_),'',@_)}
},

### Judgment rule for "Allow" header (the presense of UPDATE) 
### (Basis for a determination : RFC3311-4-2)
###   written by Horisawa (2006.1.13)
{'TY:'=>'SYNTAX',
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
		&& FFop('ne',\\\'RQ.Status-Line.code','100',@_)
		}
},

### Jugdment rule for "Allow" header (the presence of UPDATE)
### (Basis for a determination : RFC3311-4-3)
###   written by Horisawa (2006.1.16)
{'TY:'=>'SYNTAX',
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
{'TY:'=>'SYNTAX',
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
###   written by Horisawa (2006.1.17)
{'TY:'=>'SYNTAX',
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
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3311-5-3_500',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'NG:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'EX:'=>\q{FFop('eq',\\\'RQ.Status-Line.code','500',@_)},
},

### Judgment rule for "Retry-After" header
### (Basis for a determination : RFC3311-5-4)
###   written by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
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
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3311-5-5_491',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be \"491\" Request Pending.',
 'NG:'=>\\'Status-Code(%s) MUST be \"491\" Request Pending.',
 'EX:'=>\q{FFop('eq',\\\'RQ.Status-Line.code','491',@_)},
},

### (Basis for a determination : RFC3311-5-6)
###   written by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3311-5-6_500',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'NG:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'EX:'=>\q{FFop('eq',\\\'RQ.Status-Line.code','500',@_)},
},

### Judgment rule for "Retry-After" header
### (Basis for a determination : RFC3311-5-7)
###   written by Horisawa (2006.1.18)
{'TY:'=>'SYNTAX',
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
{'TY:'=>'SYNTAX',
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
{'TY:'=>'SYNTAX',
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
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3311-5-12_488',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) SHOULD be \"488\" Not Acceptable Here and be included Warning header.',
 'NG:'=>\\'Status-Code(%s) SHOULD be \"488\" Not Acceptable Here and be included Warning header.',
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


### Judgment rule for "BYE" request resulting from 491 receiving
### (Basis for a determination : RFC3261-12-57)
###   written by Horisawa (2006.1.20)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3261-12-57_BYE',
 'CA:'=>'Request',
 'OK:'=>\\'UAC SHOULD terminate a dialog when the response for a request in the dialog is a 408/481 response.',
 'NG:'=>\\'UAC SHOULD terminate a dialog when the response for a request in the dialog is a 408/481 response.',
 'RT:'=>'warning',
 'EX:'=>\q{FFop('eq',\\\'RQ.Request-Line.method','BYE',@_)},
},

### Judgment rule for "CANCEL" request resulting from 491 receiving
### (Basis for a determination : RFC3261-12-57)
###   written by Horisawa (2006.1.20)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3261-12-57_CANCEL',
 'CA:'=>'Request',
 'OK:'=>\\'UAC SHOULD terminate a dialog when the response for a request in the dialog is a 408/481 response.',
 'NG:'=>\\'UAC SHOULD terminate a dialog when the response for a request in the dialog is a 408/481 response.',
 'RT:'=>'warning',
 'EX:'=>\q{FFop('eq',\\\'RQ.Request-Line.method','CANCEL',@_)},
},


### Judgment rule for "CSeq" header (whether the method is UPDATE or not)
###   written by Horisawa (2006.1.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.CSEQ-METHOD_UPDATE',
 'CA:'=>'CSeq',
 'OK:'=>"The method of CSeq header MUST be \"UPDATE\".",
 'NG:'=>\\'The method(%s) of CSeq header MUST be \"UPDATE\".',
 'EX:'=>\q{FFop('eq',\\\'HD.CSeq.val.method','UPDATE',@_)},
},

### Judgment rule for "CSeq" header (Only for UA-19-2-1)
### modified by Horisawa (2006.1.19)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.CSEQ-SEQNO_SEND-SEQNO_UA-19-2-1',
 'CA:'=>'CSeq',
 'OK:'=>\\'The CSeq header field(%s) of the response MUST equal the CSeq field(%s) of the request.',   
 'NG:'=>\\'The CSeq header field(%s) of the response MUST equal the CSeq field(%s) of the request.', 
 'EX:'=>\q{FFop('eq',\\\'HD.CSeq.val.csno',
            FVib('send',-3,'','HD.CSeq.val.csno','RQ.Request-Line.method',FV('HD.CSeq.val.method','','LAST')),@_)}
}, 

### Judgment rule for Via header (Only for UA-19-2-1)
### modified by Horisawa (2006.1.19)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX_UA-19-2-1',
 'CA:'=>'Via',
 'OK:'=>\\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent.',
 'NG:'=>\\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent.', 
 'EX:'=>\q{FFop('eq',FVs('HD.Via.val.via.param.branch=',@_),
			[$FIRST_UPDATE_PX1_BRANCH,
			 $FIRST_UPDATE_PX2_BRANCH,
			 $FIRST_UPDATE_PUA_BRANCH
			],@_)}
},

### Judgment rule for Via header (Only for UA-19-2-1)
### modified by Horisawa (2006.1.19)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.VIA_TWOPX_SEND_EQUALS.VI_UA-19-2-1',
 'CA:'=>'Via',
 'OK:'=>\\'The Via headers(%s) MUST equal those(%s) in the request(except received parameter of 1st Via).', 
 'NG:'=>\\'The Via headers(%s) MUST equal those(%s) in the request(except received parameter of 1st Via).', 
 'EX:'=>\q{OpViaMachLines(\@FIRST_UPDATE_VIA,3,@_)}
},

### Judgment rule for UPDATE request
### (Basis for a determination : RFC3311 Table1, Table2) 
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3311-table1_UPDATE_Not-Applicable-headers',
 'CA:'=>'Header',
 'OK:'=>'An UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'NG:'=>'An UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'EX:'=>\q{!FFIsExistHeader(['Alert-Info','Allow-Events','Event','Expires','In-Reply-To','Min-Expires','Priority','RAck','RSeq','Subject','Subscription-State'],@_)},
},

### Judgment rule for a response for UPDATE request
### (Basis for a determination : RFC3311 Table1, Table2) 
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3311-table1_response-for-UPDATE_Not-Applicable-headers',
 'CA:'=>'Header',
 'OK:'=>'A response for UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'NG:'=>'A response for UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'EX:'=>\q{!FFIsExistHeader(['Alert-Info','Allow-Events','Event','Expires','In-Reply-To','Min-Expires','Priority','RAck','RSeq','Subject','Subscription-State'],@_)},
},


### Timer 
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RETRANS-EXIST.UPDATE',
 'LG:'=>'NOT',
 'CA:'=>'Timer',
 'OK:'=>'Client sent UPDATE',
 'NG:'=>'Client did not send UPDATE',
 'OD:'=>'LAST', 
 'EX:'=>\q{FVif('recv','','','','RQ.Request-Line.method',UPDATE) eq ''}},

{'TY:'=>'SYNTAX',
 'ID:'=>'S.RETRANS-1.UPDATE',
 'LG:'=>'NOT',
 'CA:'=>'Timer',
 'OK:'=>\q{sprintf('UPDATE request MUST be retransmitted(No.%s) after Timer F fired. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
 'NG:'=>\q{sprintf('UPDATE request MUST be retransmitted(No.%s) after Timer F fired. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
 'PR:'=>\q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'UPDATE') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
 'EX:'=>\q{2<=$T1_COUNT &&
          ($T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF)}},

{'TY:'=>'SYNTAX',
 'ID:'=>'S.RETRANS-F-TIMER.UPDATE',
 'CA:'=>'Timer',
 'OK:'=>'UPDATE request MUST NOT be retransmitted after Timer F fired.',
 'NG:'=>'UPDATE request MUST NOT be retransmitted after Timer F fired.',
 'OD:'=>'LAST',
 'EX:'=>\q{($T1_LAST-$T1_START)<$CNT_CONF{'TIMER-T1'}*64}},



###################
### Rule (DECODE)
###################

### Decode rule for branch parameter of Via header (Only for UA-19-2-1)
### modified by Horisawa (2006.1.19)
{'TY:'=>'DECODE',
 'ID:'=>'D.FIRST-UPDATE_VIA-BRANCH_UA-19-2-1',
 'VA:'=>[sub {
			$FIRST_UPDATE_PX1_BRANCH = $CVA_PX1_BRANCH_HISTORY;
			$FIRST_UPDATE_PX2_BRANCH = $CVA_PX2_BRANCH_HISTORY;
			$FIRST_UPDATE_PUA_BRANCH = $CVA_PUA_BRANCH_HISTORY;
		  }
		]
},

### Decode rule for Via header (Only for UA-19-2-1)
### modified by Horisawa (2006.1.19)
{'TY:'=>'DECODE',
 'ID:'=>'D.FIRST-UPDATE_VIA_UA-19-2-1',
 'VA:'=>[sub {
			@FIRST_UPDATE_VIA = @CNT_TWOPX_SEND_VIAS;
		  }
		]
},


######################
### Rule (TIMINGSET)
######################
{'TY:'=>'TIMINGSET',
 'ID:'=>'ST.RETRANS.UPDATE',
 'OK:'=>'OK',
 'NG:'=>'NG',
 'TM:'=>['T.T1.UPDATE'],
 'RR:'=>['S.RETRANS-EXIST.UPDATE','S.RETRANS-1.UPDATE','S.RETRANS-F-TIMER.UPDATE']},

###################
### Rule (TIMER)
###################
{'TY:'=>'TIMER',
 'ID:'=>'T.T1.UPDATE', 
 'TM:'=>'T1',
 'PR:'=>\q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'UPDATE') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
 'EX:'=>\q{$T1_TIMER=($T1_COUNT eq 2)?$CNT_CONF{'TIMER-T1'}:(($T1_TIMER*2<$CNT_CONF{'TIMER-T2'})?$T1_TIMER*2:$CNT_CONF{'TIMER-T2'})}},



), ### @SIPUAExtendUpdateRules
			      
return 1;

