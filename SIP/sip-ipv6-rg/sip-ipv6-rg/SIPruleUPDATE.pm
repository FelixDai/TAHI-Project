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
#    for Server test (UPDATE, RFC3311)
#======================================

require SIPrule100rel;
       
@SIPPXRulesUPDATE =
(

#####################
### Ruleset (ENCODE)
#####################

### UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'RULESET',
 'ID:'=>'ES.REQUEST.UPDATE.TM',
 'MD:'=>'SEQ',
 'RR:'=>[
 	'E.UPDATE_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.ROUTE_TWOURIS',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_UPDATE',
	'E.CONTACT_URI',		# if you don't need this, DEL locally.
	'E.CONTENTTYPE_VALID',	# if you don't need this, DEL locally.
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID.CODEC_CHANGED',	# if you don't need this, DEL locally.
 	],
 'EX:'=>\&MargeSipMsg
},

### UPDATE request with Authentication
###   written by Horisawa (2006.1.5)
{'TY:'=>'RULESET',
 'ID:'=>'ES.REQUEST.UPDATE-AUTH.TM',
 'MD:'=>'SEQ',
 'RR:'=>[
 	'E.UPDATE_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.ROUTE_TWOURIS',
	'E.MAXFORWARDS_NOHOP',
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_UPDATE',
	'E.CONTACT_URI',		# if you don't need this, DEL locally.
	'E.CONTENTTYPE_VALID',	# if you don't need this, DEL locally.
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID.CODEC_CHANGED',	# if you don't need this, DEL locally.
 	],
 'EX:'=>\&MargeSipMsg
},

### 200 response for UPDATE (with Contact and body)
###   written by Horisawa (2006.1.5)
{'TY:'=>'RULESET',
 'ID:'=>'ES.STATUS.200-UPDATE-RETURN.ONEPX.TM',
 'MD:'=>'SEQ',
 'RR:'=>[
 	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED.LAST_UPDATE',
	'E.RECORDROUTE_ASIS',
	'E.FROM_RETURN.LAST_UPDATE',
	'E.TO_RETURN_LOCAL-TAG.LAST_UPDATE',
	'E.CALL-ID_RETURN.LAST_UPDATE',
	'E.CSEQ_RETURN.LAST_UPDATE',
	'E.CONTACT_URI',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION',	# if you don't need this, DEL locally.
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
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION',
 	],
 'EX:'=>\&MargeSipMsg
},


#####################
### Ruleset (SYNTAX)
#####################

### Judgment rule for UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'RULESET',
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
 	]
},

### Judgment rule for 200 response (for UPDATE request)
###   written by Horisawa (2006.1.5)
{'TY:'=>'RULESET',
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
 	]
},


###################
### Rule (ENCODE)
###################

### "Allow" header with RFC 3261 methods plus PRACK & UPDATE
### (Basis for a determination : RFC3261-13-2, RFC3311-4-1)
###   written by Horisawa (2006.1.5)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3311-4-1_Allow',
 'PT:'=>'HD',
 'FM:'=>'Allow: INVITE,ACK,CANCEL,OPTIONS,BYE,PRACK,UPDATE',
},

### "Allow" header with RFC 3261 methods plus PRACK & UPDATE
### (Basis for a determination : RFC3261-13-2, RFC3311-4-3)
###   written by Horisawa (2006.1.16)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3311-4-3_Allow',
 'PT:'=>'HD',
 'FM:'=>'Allow: INVITE,ACK,CANCEL,OPTIONS,BYE,PRACK,UPDATE',
},

### Request-URI for UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'ENCODE',
 'ID:'=>'E.UPDATE_CONTACT-URI',
 'PT:'=>'RQ',
 'FM:'=>'UPDATE %s SIP/2.0',
 'AR:'=>[\q{NINF('RemoteContactURI','LocalPeer')}]
},

### "CSeq" header for UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'ENCODE',
 'ID:'=>'E.CSEQ_NUM_UPDATE',
 'PT:'=>'HD',
 'NX:'=>'Call-ID',
 'FM:'=>'CSeq: %s UPDATE',
 'AR:'=>[\q{NINFW('DLOG.LocalCSeqNum','+1')}]
},

### "Via" header for response, using the last received UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.VIA_RETURN_RECEIVED.LAST_UPDATE',
 'PT:'=>'HD',
 'FM:'=>'%s',
 'AR:'=>[
 	sub{my($vias,$hed,$via,$host);
		$vias=FVs('HD.Via.txt','',NDPKT('UPDATE','MY','LAST','recv'));
		$hed=shift(@$vias);
		$host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
		my $str = $host->[0];
		if ($str =~ /^\[(\S+)$\]/) {$str=$1;}
		if(!IsIPAddress($str)){$hed='Via:'.$hed.';received='.NINF('IPaddr','PX1');}
		else{$hed='Via:'.$hed;}
		map{$hed.="\r\n".'Via:'.$_} @$vias;
		return $hed;
    }
    ],
},

### "From" header for response, using the last received UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'ENCODE',
 'ID:'=>'E.FROM_RETURN.LAST_UPDATE',
 'PT:'=>'HD',
 'FM:'=>'From: %s',
 'AR:'=>[\q{FV('HD.From.txt','',NDPKT('UPDATE','MY','LAST','recv'))}],
},

### "To" header for response, using the last received UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'ENCODE',
 'ID:'=>'E.TO_RETURN_LOCAL-TAG.LAST_UPDATE',
 'PT:'=>'HD',
 'FM:'=>'To: %s',
 'AR:'=>[
 	sub{my($msg, $val);
		$val = FV('HD.To.val.param.tag','',NDPKT('UPDATE','MY','LAST','recv'));
		if ($val) {
			$msg = FV('HD.To.txt','',NDPKT('UPDATE','MY','LAST','recv'));
        } else {
			$msg = FV('HD.To.val.ad.txt','',NDPKT('UPDATE','MY','LAST','recv')).";tag=".NINF('DLOG.LocalTag');
		}
		return $msg;
	}
	]
},

### "Call-ID" header for response, using the last received UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'ENCODE',
 'ID:'=>'E.CALL-ID_RETURN.LAST_UPDATE',
 'PT:'=>'HD',
 'FM:'=>'Call-ID: %s',
 'AR:'=>[\q{FV('HD.Call-ID.txt','',NDPKT('UPDATE','MY','LAST','recv'))}],
},

### "CSeq" header for response, using the last received UPDATE request
###   written by Horisawa (2006.1.5)
{'TY:'=>'ENCODE',
 'ID:'=>'E.CSEQ_RETURN.LAST_UPDATE',
 'PT:'=>'HD',
 'FM:'=>'CSeq: %s',
 'AR:'=>[\q{FV('HD.CSeq.txt','',NDPKT('UPDATE','MY','LAST','recv'))}],
},

### body which session parameter was modified, for UPDATE request
###   written by Horisawa (2006.1.6)
{'TY:'=>'ENCODE',
 'ID:'=>'E.BODY_VALID.CODEC_CHANGED',
 'PT:'=>'BD',
 'FM:'=>\q{"v=0\r\n".
 		   "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP".NINF('IPaddr','LocalPeer')."\r\n".
		   "s=-\r\n".
		   "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
		   "t=0 0\r\n".
		   "m=audio %s RTP/AVP 0\r\n".
		   "a=rtpmap:8 PCMA/8000"},
 'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')},
 		 \q{NINFW('RTPPort','49174','LocalPeer')}]
},


###################
### Rule (SYNTAX)
###################

### Judgment rule for "Allow" header (the presense of UPDATE)
### (Basis for a determination : RFC3311-4-1)
###   written by Horisawa (2006.1.5)
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
### (Basis for a determine : RFC3311-4-1)
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
        }
},

### Judgment rule for "Allow" header (the presense of UPDATE)
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
###   written by Horisawa (2006.1.18)
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
{'TY:'=>'SYNTAX',
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
{'TY:'=>'SYNTAX',
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
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3311-table1_UPDATE_Not-Applicable-headers',
 'CA:'=>'Header',
 'OK:'=>'An UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'NG:'=>'An UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'EX:'=>\q{!FFIsExistHeader(['Alert-Info','Allow-Events','Event','Expires','In-Reply-To','Min-Expires','Priority','RAck','RSeq','Subject','Subscription-State'],@_)},
},

### Judgment rule for a response for UPDATE request
### (Basis for a determination : RFC3311 Table 1)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3311-table1_response-for-UPDATE_Not-Applicable-headers',
 'CA:'=>'Header',
 'OK:'=>'A response for UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'NG:'=>'A response for UPDATE request MUST NOT include the following headers: Alert-Info, Allow-Events, Event, Expires, In-Reply-To, Min-Expires, Priority, RAck, RSeq, Subject, Subscription-State.',
 'EX:'=>\q{!FFIsExistHeader(['Alert-Info','Allow-Events','Event','Expires','In-Reply-To','Min-Expires','Priority','RAck','RSeq','Subject','Subscription-State'],@_)},
},


);	# @SIPPXRulesUPDATE

##############
### Function
##############

### The sending function for UPDATE request
###   written by Horisawa (2006.1.5)
sub SD_Term_UPDATE {
	my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
	my($result);
	if($pktinfo eq ''){
		$pktinfo=$SIPPktInfoLast;
	}
	if($rule eq ''){
		$rule='ES.REQUEST.UPDATE.TM';
	}
	$result = EvalEncodeRuleAndSend($rule,$pktinfo,
				$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},
				$addrule,$delrule,$conn,$link);
	MsgPrint('SEQ', "SD_Term_UPDATE result[$result]\n");
	return $result;
}



return 1;

