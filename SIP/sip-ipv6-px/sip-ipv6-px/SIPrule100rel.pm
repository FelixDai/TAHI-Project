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
#    for Server test (100rel, RFC3262)
#======================================

@SIPPXRules100rel = 
(

#####################
### Ruleset (ENCODE)
#####################

### 183 response for 1 proxy with 100rel, with SDP (as Answer)
###   written by Horisawa (2005.12.20)
{'TY:'=>'RULESET', 
 'ID:'=>'ES.STATUS.183.ONEPX.100REL.TM', 
 'MD:'=>'SEQ',
 'RR:'=>[
	'E.STATUS-183',
    'E.VIA_RETURN_RECEIVED',
    'E.RECORDROUTE_TWOHOPS',
    'EESet.BASIC-FTCC-RETURN-TOTAG',
    'E.CONTACT_URI',
	'E.REQUIRE_100REL',
	'E.RSEQ_NUM',
	'E.CONTENTTYPE_VALID',
    'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION',
    ],
 'EX:'=>\&MargeSipMsg
},

### PRACK request
###   written by Horisawa (2005.12.21)
{'TY:'=>'RULESET', 
 'ID:'=>'ES.REQUEST.PRACK.TM', 
 'MD:'=>'SEQ',
 'RR:'=>[
	'E.PRACK_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.ROUTE_TWOURIS',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_PRACK',
	'E.RACK_NUM_PRACK',
	'E.CONTENT-LENGTH_CAL',
	],
 'EX:'=>\&MargeSipMsg
},

### PRACK request with Authentication
###   written by Horisawa (2005.12.21)
{'TY:'=>'RULESET', 
 'ID:'=>'ES.REQUEST.PRACK-AUTH.TM', 
 'MD:'=>'SEQ',
 'RR:'=>[
	'E.PRACK_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.ROUTE_TWOURIS',
	'E.MAXFORWARDS_NOHOP',
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_PRACK',
	'E.RACK_NUM_PRACK',
	'E.CONTENT-LENGTH_CAL',
	],
 'EX:'=>\&MargeSipMsg
},

### 200 response for PRACK
###   written by Horisawa (2005.12.26)
{'TY:'=>'RULESET', 
 'ID:'=>'ES.STATUS.200-PRACK-RETURN.ONEPX.TM', 
 'MD:'=>'SEQ',
 'RR:'=>[
 	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED.LAST_PRACK',
	'E.RECORDROUTE_ASIS',
	'E.FROM_RETURN.LAST_PRACK',
	'E.TO_RETURN_LOCAL-TAG.LAST_PRACK',
	'E.CALL-ID_RETURN.LAST_PRACK',
	'E.CSEQ_RETURN.LAST_PRACK',
	'E.CONTENT-LENGTH_0',
 	],
 'EX:'=>\&MargeSipMsg
},

### 200 response for INVITE
###   written by Horisawa (2005.12.26)
{'TY:'=>'RULESET', 
 'ID:'=>'ES.STATUS.200-INVITE-RETURN.ONEPX.TM', 
 'MD:'=>'SEQ',
 'RR:'=>[
 	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED.LAST_INVITE',
	'E.RECORDROUTE_ASIS',
	'E.FROM_RETURN.LAST_INVITE',
	'E.TO_RETURN_LOCAL-TAG.LAST_INVITE',
	'E.CALL-ID_RETURN.LAST_INVITE',
	'E.CSEQ_RETURN.LAST_INVITE',
	'E.CONTENT-LENGTH_0',
 	],
 'EX:'=>\&MargeSipMsg
},


#####################
### Ruleset (SYNTAX)
#####################

### Judgement rule for PRACK request
###   written by Horisawa (2005.12.22)
{'TY:'=>'RULESET', 
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

# TODO (if needed), Horisawa, 2005.12.27
#  - Judgment for the case that the PRACK message had body as offer
#    
	]
},

### Judgment rule for 200 response (for PRACK request)
###   written by Horisawa (2005.12.26)
{'TY:' => 'RULESET',
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
{'TY:' => 'RULESET', 
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
	]
},

### Judgment rule for 407 response (for PRACK request)
###   written by Horisawa (2005.12.27)
{'TY:' => 'RULESET',
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
	]
},


###################
### Rule (ENCODE) 
###################

### "Supported" header with "100rel" option tag
###   written by Horisawa (2005.12.20)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.SUPPORTED_100REL',
 'PT:'=>'HD',
 'NX:'=>'Contact',
 'FM:'=>'Supported: 100rel',
},

### "Require" header with "100rel" option tag
###   written by Horisawa (2005.12.20)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.REQUIRE_100REL',
 'PT:'=>'HD',
 'NX:'=>'Contact',
 'FM:'=>'Require: 100rel',
},

### "RSeq" header for 1XX response
###   written by Horisawa (2005.12.20)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.RSEQ_NUM',
 'PT:'=>'HD',
 'NX:'=>'CSeq',
 'FM:'=>'RSeq: %s',
 'AR:'=>[\q{NINFW('DLOG.LocalRSeqNum','+1')}],
},

### Request-URI for PRACK request
###   written by Horisawa (2005.12.21)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.PRACK_CONTACT-URI',
 'PT:'=>'RQ',
 'FM:'=>'PRACK %s SIP/2.0',
 'AR:'=>[\q{NINF('RemoteContactURI','LocalPeer')}]
},

### "CSeq" header for PRACK request
###   written by Horisawa (2005.12.21)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.CSEQ_NUM_PRACK',
 'PT:'=>'HD',
 'NX:'=>'Call-ID',
 'FM:'=>'CSeq: %s PRACK',
 'AR:'=>[\q{NINFW('DLOG.LocalCSeqNum','+1')}]
},

### "CSeq" header for ACK request, using the last sent INVITE request
###   written by Horisawa (2005.12.21)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.CSEQ_NUM_ACK.LAST_INVITE',
 'PT:'=>'HD',
 'NX:'=>'Call-ID',
 'FM:'=>'CSeq: %s ACK',
 'AR:'=>[\q{FV('HD.CSeq.val.csno',@_[0],'INVITE')}]
},

### "RAck" header for PRACK request
###  ("RSeq" and "CSeq" values
###       which the last received 1XX had are used.)
###   written by Horisawa (2005.12.22)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.RACK_NUM_PRACK',
 'PT:'=>'HD',
 'NX:'=>'CSeq',
 'FM:'=>'RAck: %s %s',
 'AR:'=>[\q{FV('HD.RSeq.txt','',NDPKT('^18','','LAST'))},
		 \q{FV('HD.CSeq.txt','',NDPKT('^18','','LAST'))}]
},

### "Supported" header for response, using last received INVITE's value
###   written by Horisawa (2005.12.22)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.RES.SUPPORTED_VALID.LAST_INVITE',
 'PT:'=>'HD',
 'NX:'=>'Contact',
 'FM:'=>'Supported: %s',
 'AR:'=>[\q{FV('HD.Supported.txt','',NDPKT('INVITE','MY','LAST','recv'))}],
},

### "Via" header for response, using the last received PRACK request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.VIA_RETURN_RECEIVED.LAST_PRACK',
 'PT:'=>'HD',
 'FM:'=>'%s',
 'AR:'=>[
 	sub{my($vias,$hed,$via,$host);
		$vias=FVs('HD.Via.txt','',NDPKT('PRACK','MY','LAST','recv'));
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

### "Via" header for response, using the last received INVITE request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.VIA_RETURN_RECEIVED.LAST_INVITE',
 'PT:'=>'HD',
 'FM:'=>'%s',
 'AR:'=>[
 	sub{my($vias,$hed,$via,$host);
		$vias=FVs('HD.Via.txt','',NDPKT('INVITE','MY','LAST','recv'));
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

### "From" header for response, using the last received PRACK request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.FROM_RETURN.LAST_PRACK',
 'PT:'=>'HD',
 'FM:'=>'From: %s',
 'AR:'=>[\q{FV('HD.From.txt','',NDPKT('PRACK','MY','LAST','recv'))}],
},

### "From" header for response, using the last received INVITE request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.FROM_RETURN.LAST_INVITE',
 'PT:'=>'HD',
 'FM:'=>'From: %s',
 'AR:'=>[\q{FV('HD.From.txt','',NDPKT('INVITE','MY','LAST','recv'))}],
},

### "To" header for response, using the last received PRACK request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.TO_RETURN_LOCAL-TAG.LAST_PRACK',
 'PT:'=>'HD',
 'FM:'=>'To: %s',
 'AR:'=>[
 	sub{my($msg, $val);
		$val = FV('HD.To.val.param.tag','',NDPKT('PRACK','MY','LAST','recv'));
		if ($val) {
			$msg = FV('HD.To.txt','',NDPKT('PRACK','MY','LAST','recv'));
		} else {
			$msg = FV('HD.To.val.ad.txt','',NDPKT('PRACK','MY','LAST','recv')).";tag=".NINF('DLOG.LocalTag');
		}
		return $msg;
	}
	]
},

### "To" header for response, using the last received INVITE request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.TO_RETURN_LOCAL-TAG.LAST_INVITE',
 'PT:'=>'HD',
 'FM:'=>'To: %s',
 'AR:'=>[
 	sub{my($msg, $val);
		$val = FV('HD.To.val.param.tag','',NDPKT('INVITE','MY','LAST','recv'));
		if ($val) {
			$msg = FV('HD.To.txt','',NDPKT('INVITE','MY','LAST','recv'));
		} else {
			$msg = FV('HD.To.val.ad.txt','',NDPKT('INVITE','MY','LAST','recv')).";tag=".NINF('DLOG.LocalTag');
		}
		return $msg;
	}
	]
},

### "Call-ID" header for response, using the last received PRACK request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.CALL-ID_RETURN.LAST_PRACK',
 'PT:'=>'HD',
 'FM:'=>'Call-ID: %s',
 'AR:'=>[\q{FV('HD.Call-ID.txt','',NDPKT('PRACK','MY','LAST','recv'))}],
},

### "Call-ID" header for response, using the last received INVITE request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.CALL-ID_RETURN.LAST_INVITE',
 'PT:'=>'HD',
 'FM:'=>'Call-ID: %s',
 'AR:'=>[\q{FV('HD.Call-ID.txt','',NDPKT('INVITE','MY','LAST','recv'))}],
},

### "CSeq" header for response, using the last received PRACK request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.CSEQ_RETURN.LAST_PRACK',
 'PT:'=>'HD',
 'NX:'=>'Call-ID',
 'FM:'=>'CSeq: %s',
 'AR:'=>[\q{FV('HD.CSeq.txt','',NDPKT('PRACK','MY','LAST','recv'))}],
},

### "CSeq" header for response, using the last received INVITE request
###   written by Horisawa (2005.12.26)
###   modified by Horisawa (2005.12.28)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.CSEQ_RETURN.LAST_INVITE',
 'PT:'=>'HD',
 'NX:'=>'Call-ID',
 'FM:'=>'CSeq: %s',
 'AR:'=>[\q{FV('HD.CSeq.txt','',NDPKT('INVITE','MY','LAST','recv'))}],
},

### "Allow" header with RFC3261 methods plus PRACK
### (RFC3261-13-2)
###   written by Horisawa (2005.12.27)
{'TY:'=>'ENCODE', 
 'ID:'=>'E.ALLOW_VALID.PLUS_PRACK',
 'PT:'=>'HD',
 'NX:'=>'Supported',
 'FM:'=>'Allow: INVITE,ACK,CANCEL,OPTIONS,BYE,PRACK',
},



###################
### Rule (SYNTAX) 
###################

### Judgment rule for 100 response (the headers which must not be included)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.MUSTNOT-HEADER_100',
 'CA:'=>'Header',
 'OK:'=>\\'100 response MUST NOT include the following header field: RSeq',
 'NG:'=>\\'100 response MUST NOT include the following header field: RSeq',
 'EX:'=>\q{!FFIsExistHeader(['RSeq'],@_)}
},

### Judgment rule for "Require" header
###       (100rel option tag must not be included)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.REQUIRE-100REL_NOTEXIST',
 'CA:'=>'Require',
# 'PR:'=>\q{FFIsExistHeader("Require",@_)},
 'OK:'=>\\'The Require header in this message MUST NOT include 100rel option tag.',
 'NG:'=>\\'The Require header in this message MUST NOT include 100rel option tag.',
 'EX:'=>\q{!FFIsMember(['100rel'],FVSeparete('HD.Require.val','\s*,\s*',@_),'',@_)}
},

### Judgment rule for "RSeq" header (the presence of RSeq header)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.RSEQ_EXIST',
 'CA:'=>'RSeq',
 'OK:'=>\\'The RSeq header MUST exist.',
 'NG:'=>\\'The RSeq header MUST exist.',
 'EX:'=>\q{FFIsExistHeader("RSeq",@_)}
},

### Judgment rule for "RAck" header (the presence of RAck header)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.RACK_EXIST',
 'CA:'=>'RAck',
 'OK:'=>\\'The RAck header MUST exist.',
 'NG:'=>\\'The RAck header MUST exist.',
 'EX:'=>\q{FFIsExistHeader("RAck",@_)}
},

### Judgment rule for "Require" header (the consistency of forwarded message)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.REQUIRE_ORIGINAL-REQUIRE',
 'CA:'=>'Require',
 'OK:'=>\\'The Require header value(%s) MUST equal the Require header value(%s) in the original message.',
 'NG:'=>\\'The Require header value(%s) MUST equal the Require header value(%s) in the original message.',
 'EX:'=>\q{FFop('eq',FV('HD.Require.val',@_),FV('HD.Require.val','', NDPKT(@_[1])),@_)}
},

### Judgment rule for "RSeq" header (the consistency of forwarded message)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.RSEQ_ORIGINAL-RSEQ',
 'CA:'=>'RSeq',
 'OK:'=>\\'The RSeq header value(%s) MUST equal the RSeq header value(%s) in the original message.',
 'NG:'=>\\'The RSeq header value(%s) MUST equal the RSeq header value(%s) in the original message.',
 'EX:'=>\q{FFop('eq',FV('HD.RSeq.txt',@_),FV('HD.RSeq.txt','', NDPKT(@_[1])),@_)}
},

### Judgment rule for "RAck" header (the consistency of forwarded message)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.RACK_ORIGINAL-RACK',
 'CA:'=>'RAck',
 'OK:'=>\\'The RAck header value(%s) MUST equal the RAck header value(%s) in the original message.',
 'NG:'=>\\'The RAck header value(%s) MUST equal the RAck header value(%s) in the original message.',
 'EX:'=>\q{FFop('eq',FV('HD.RAck.txt',@_),FV('HD.RAck.txt','', NDPKT(@_[1])),@_)}
},

### Judgment rule for "CSeq" header (whether the method is PRACK or not)
###   written by Horisawa (2005.12.22)
{'TY:'=>'SYNTAX', 
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
{'TY:'=>'SYNTAX', 
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
{'TY:'=>'SYNTAX', 
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
{'TY:'=>'SYNTAX', 
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
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.VIA_NOPX_SEND_EQUAL.LAST_INVITE',
 'CA:'=>'Via',
 'OK:'=>\\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).',
 'NG:'=>\\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).',
 'EX:'=>\q{OpViaMachLinesWithRequest('INVITE',1,@_)},
},

### Judgment rule for "Require" header
### Term : RFC3262-3-9
###   written by Horisawa (2006.1.6)
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.REQUIRE_EXIST_INCLUDE-100REL',
 'CA:'=>'Require',
 'OK:'=>\\'A Require header MUST exist and include 100rel.',
 'NG:'=>\\'A Require header MUST exist and include 100rel.',
 'EX:'=>\q{FFIsExistHeader("Require",@_) && FFIsMember(['100rel'],FVSeparete('HD.Require.val','\s*,\s*',@_),'',@_)},
},

### Judgment rule for "RSeq" header
### Term : RFC3262-3-11
###   written by Horisawa (2006.1.6)
{'TY:'=>'SYNTAX', 
 'ID:'=>'S.RSEQ-SEQNO_32BIT',
 'CA:'=>'RSeq',
 'OK:'=>\\'The RSeq value(%s) MUST be expressible as a 32-bit unsigned integer and MUST be less than 2**31..',
 'NG:'=>\\'The RSeq value(%s) MUST be expressible as a 32-bit unsigned integer and MUST be less than 2**31..',
 'EX:'=>\q{FFop('<',\\\'HD.RSeq.val.responsenum',2**31,@_)},
},

### Judgment rule for PRACK request
### (Basis for a determination : RFC3262 Table1, Table2)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX',
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
 'CA:'=>'Header',
 'OK:'=>"A response for PRACK request MUST NOT include the following headers: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.",
 'NG:'=>"A response for PRACK request MUST NOT include the following headers: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.",
 'EX:'=>\q{!FFIsExistHeader(['Alert-Info','Call-Info','Contact','Expires','In-Reply-To','Organization','Priorit','Reply-To','Subject'],@_)}
},




);	# @SIPPXRules100rel



##############
### Function
##############

### The sending function for PRACK request
###   written by Horisawa (2005.12.22)
sub SD_Term_PRACK {
	my($rule,$pktinfo,$addrule,$delrule,$conn,$link)=@_;
	my($result);
	if($pktinfo eq ''){
		$pktinfo=$SIPPktInfoLast;
	}
	if($rule eq ''){
		$rule='ES.REQUEST.PRACK.TM';
	}
	$result = EvalEncodeRuleAndSend($rule,$pktinfo,
				$SIPNodeTempl{$SEQCurrentActNode->{'ID'}}->{'SFRAME'},
				$addrule,$delrule,$conn,$link);
	MsgPrint('SEQ', "SD_Term_PRACK result[$result]\n");
	return $result;
}

sub OpViaMachLinesWithRequest{
	my($method,$lines,$rule,$pktinfo,$context)=@_;
	my($val1,$via1Lines,$val2,$via2Lines,$i);
	
	$val1=FVs('HD.Via.val.via','',$pktinfo);
	$via1Lines=FVs('HD.Via.val.via.by','',$pktinfo);
	$val2=FVs('HD.Via.val.via','',NDPKT($method,'MY','LAST','send'));
	$via2Lines=FVs('HD.Via.val.via.by','',NDPKT($method,'MY','LAST','send'));
#PrintVal($val1);
#PrintVal($val2);

	$context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'via','ARG1:'=>$via1Lines,'ARG2:'=>$via2Lines};

	if($#$val1+1<$lines){return '';}
	if($#$val2+1<$lines){return '';}
	for($i=0;$i<$lines;$i++){
		if(!OpViaMachLine($val1->[$i],$val2->[$i],$i)){return '';}
	}
	return 'MATCH';

}


return 1;

