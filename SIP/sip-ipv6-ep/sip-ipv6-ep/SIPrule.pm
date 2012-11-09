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
# 10/1/ 4  S.BODY_EXIST

#=================================
# 
#=================================
#use strict;

#=================================
# 
#=================================

# 
@SIPCommonRules =
(
 #=================================
 # 
 #=================================

 #=================================
 # 
 #=================================

##REQUEST LINE
 # %% R-URI:02 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_NOQUOTE', 'CA:' => 'Request',
   'OK:' => \\'Request-URI(%s) MUST NOT be enclosed in \"<\" and \">\".', 
   'NG:' => \\'Request-URI(%s) MUST NOT be enclosed in \"<\" and \">\".', 
   'EX:' => \\'RQ.Request-Line.uri.txt' }, 

 # %% R-URI:03 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_TO-URI', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) of the message SHOULD be the same value as the addr-spec(%s) in the To header field.', 
   'NG:' => \\'The Request-URI(%s) of the message SHOULD be the same value as the addr-spec(%s) in the To header field.', 
   'RT:' => "warning", 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','strict-without-port',FV('RQ.Request-Line.uri',@_),FV('HD.To.val.ad',@_),@_)} },


 # %% R-URI:04 %%	SIP-version
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-LINE_VERSION', 'CA:' => 'Request',
   'OK:' => "A SIP messages MUST include a SIP-Version of \"SIP/2.0\".", 
   'NG:' => \\'A SIP messages(%s) MUST include a SIP-Version of \"SIP/2.0\".', 
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.version',"SIP/2.0",@_)}},

 # %% R-URI:05 %%	userinfo
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_NOUSERINFO', 'CA:' => 'Request',
   'OK:' => "A \"userinfo\" and \"\@\" component MUST NOT exist in Request-URI of REGISTER.", 
   'NG:' => "A \"userinfo\" and \"\@\" component MUST NOT exist in Request-URI of REGISTER.", 
   'EX:' => \q{!FV('RQ.Request-Line.uri.ad.userinfo',@_)}}, 

 # %% R-URI:07 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REQ-R-URI', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST equal that(%s) of corresponding request.', 
   'NG:' => \\'The Request-URI(%s) MUST equal that(%s) of corresponding request.', 
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',FV('RQ.Request-Line.uri.txt',@_[0],'INVITE'),@_)}}, 

 # %% R-URI:15 %%	method parameter of Request-URI is not exist. for O6-8,O7-1.
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI-METHOD_NOT-EXIST', 'CA:' => 'Request',
   'OK:' => "The method parameter of Request-URI MUST NOT exist.",
   'NG:' => "The method parameter of Request-URI MUST NOT exist.",
   'EX:' => \q{!FV('RQ.Request-Line.uri.ad.param.method-param',@_)}},

 # %% R-URI:17 %%	Subject parameter of Request-URI is not exist. for O7-1.(a@b.c?Subject=xxx)
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI-SUBJECT_NOT-EXIST', 'CA:' => 'Request',
   'OK:' => 'The Subject parameter (header parameter) of Request-URI MUST NOT exist.',
   'NG:' => \\'The Subject(%s) parameter (header parameter) of Request-URI MUST NOT exist.',
   'EX:' => \q{!FFIsMatchStr('Subject\s*=',\\\'RQ.Request-Line.uri.ad.header','','T',@_)}}, 

### HEADER ###

 # %% TAG:01 %%		Via
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TAG-PRIORITY', 'CA:' => 'Header',
   'OK:' => "Via, Route, Record-Route, Proxy-Require, Max-Forwards, and Proxy-Authorization headers are RECOMMENDED to appear towards the top of the message to facilitate rapid parsing.",
   'NG:' => "Via, Route, Record-Route, Proxy-Require, Max-Forwards, and Proxy-Authorization headers are RECOMMENDED to appear towards the top of the message to facilitate rapid parsing.", 
   'RT:' => "warning", 
   'EX:' =>\q{!IsCorrectPrioriyTagGroup(['Via','Route','Record-Route','Proxy-Require','Max-Forwards','Proxy-Authorization'],@_)}},

 # %% TAG:02 %%		
 # 			(Request-URI
 #			Call-Info
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TAG_REQ-SIGNAL-RECYCLE', 'CA:' => 'Header',
   'OK:' => "SHOULD reuse the header field and body message of the original message.", 
   'NG:' => "SHOULD reuse the header field and body message of the original message.", 
   'RT:' => "warning",
   'EX:' =>\q{FFParseValid('Via',@_)}},

### Judgment rule for headers
### (Basis for a determination : RFC3261-8-80)
###    modified by Horisawa (2006.2.7)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.MUSTNOT-HEADER_ACK',
 'CA:'=>'Header',
 'PR:'=>\q{FFop('eq',\\\'RQ.Request-Line.method','ACK',@_) && 
 			FFop('ne',FVib('send','','','RQ.Status-Line.code','RQ.Request-Line.txt',''),'200',@_)},
 'OK:'=>"An ACK request for a non-2xx response MUST NOT include these header fields: Accept ,Accept-Encoding, Accept-Language, Alert-Info, Allow, Call-Info, Expires, In-Reply-To, Organization, Priority, Proxy-Require, Reply-To, Require, Server, Subject, Supported.", 
 'NG:'=>"An ACK request for a non-2xx response MUST NOT include these header fields: Accept ,Accept-Encoding, Accept-Language, Alert-Info, Allow, Call-Info, Expires, In-Reply-To, Organization, Priority, Proxy-Require, Reply-To, Require, Server, Subject, Supported.", 
 'EX:'=>\q{!FFIsExistHeader(['Accept','Accept-Encoding','Accept-Language', 'Alert-Info',
                             'Allow','Call-Info','Expires', 'In-Reply-To','Organization',
                             'Priority', 'Proxy-Require','Reply-To','Require','Server',
                             'Subject','Supported'],@_)
        }       
}, 

### Judgment rule for Require
### (Basis for a determination : RFC3261-8-82)
###    written by Horisawa (2006.2.7)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3261-8-82_Require',
 'CA:'=>'Require',
 'PR:'=>\q{FFop('eq',\\\'RQ.Request-Line.method','ACK',@_)
            && FFop('eq',FVib('send','','','RQ.Status-Line.code','RQ.Request-Line.txt',''),'200',@_)
            && FFIsExistHeader('Require',@_)},
 'OK:'=>\\'An ACK request for a 2xx response MUST contain only those Require and Proxy-Require values that were present in the initial request.',
 'NG:'=>\\'An ACK request for a 2xx response MUST contain only those Require and Proxy-Require values that were present in the initial request.',
 'EX:'=>\q{FFop('eq',\\\'HD.Require.val',FVif('recv','','','HD.Proxy-Require.val','HD.CSeq.val.csno',FV('HD.CSeq.val.csno',@_)),@_)},
},

### Judgment rule for Proxy-Require
### (Basis for a determination : RFC3261-8-82)
###    written by Horisawa (2006.2.7)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3261-8-82_Proxy-Require',
 'CA:'=>'Proxy-Require',
 'PR:'=>\q{FFop('eq',\\\'RQ.Request-Line.method','ACK',@_)
            && FFop('eq',FVib('send','','','RQ.Status-Line.code','RQ.Request-Line.txt',''),'200',@_)
            && FFIsExistHeader('Proxy-Require',@_)},
 'OK:'=>\\'An ACK request for a 2xx response MUST contain only those Require and Proxy-Require values that were present in the initial request.',
 'NG:'=>\\'An ACK request for a 2xx response MUST contain only those Require and Proxy-Require values that were present in the initial request.',
 'EX:'=>\q{FFop('eq',\\\'HD.Proxy-Require.val',FVif('recv','','','HD.Proxy-Require.val','HD.CSeq.val.csno',FV('HD.CSeq.val.csno',@_)),@_)},
},


 # %% MUSTNOT:02 %%	BYE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MUSTNOT-HEADER_BYE', 'CA:' => 'Header',
   'OK:' => "A BYE request MUST NOT include these header fields: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.", 
   'NG:' => "A BYE request MUST NOT include these header fields: Alert-Info, Call-Info, Contact, Expires, In-Reply-To, Organization, Priority, Reply-To, Subject.", 
   'EX:' => \q{!FFIsExistHeader(['Alert-Info','Call-Info','Contact','Expires','In-Reply-To','Organization','Priorit','Reply-To','Subject'],@_)}}, 

 # %% MUSTNOT:03 %%	CANCEL
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MUSTNOT-HEADER_CANCEL', 'CA:' => 'Header',
   'OK:' => "A CANCEL request MUST NOT include these header fields: Accept, Accept-Encoding, Accept-Language, Alert-Info, Allow, Call-Info, Contact, Content-Disposition, Content-Encoding, Content-Language, Expires, In-Reply-To, MIME-Version, Organization, Priority, Proxy-Authorization, Proxy-Require, Reply-To, Require, Subject.", 
   'NG:' => "A CANCEL request MUST NOT include these header fields: Accept, Accept-Encoding, Accept-Language, Alert-Info, Allow, Call-Info, Contact, Content-Disposition, Content-Encoding, Content-Language, Expires, In-Reply-To, MIME-Version, Organization, Priority, Proxy-Authorization, Proxy-Require, Reply-To, Require, Subject.", 
   'EX:' => \q{!FFIsExistHeader(['Accept','Accept-Encoding','Accept-Language','Alert-Info','Allow','Call-Info','Contact','Content-Disposition','Content-Encoding','Content-Language','Expires','In-Reply-To','MIME-Version','Organization','Priority','Proxy-Authorization','Proxy-Require','Reply-To','Require','Subject'],@_)}}, 

 # %% MUSTNOT:04 %%	OPTIONS
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MUSTNOT-HEADER_OPTIONS', 'CA:' => 'Header',
   'OK:' => "A OPTIONS request MUST NOT include these header fields: Alert-Info, Expires, In-Reply-To, Priority, Reply-To, Subject.", 
   'NG:' => "A OPTIONS request MUST NOT include these header fields: Alert-Info, Expires, In-Reply-To, Priority, Reply-To, Subject.", 
   'EX:' => \q{!FFIsExistHeader(['Alert-Info','Expires','In-Reply-To','Priority','Reply-To','Subject'],@_)}}, 

 # %% MUSTNOT:05 %%	REGISTER
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MUSTNOT-HEADER_REGISTER', 'CA:' => 'Header',
   'OK:' => "A REGISTER request MUST NOT include these header fields: Record-Route, Alert-Info, In-Reply-To, Priority, Reply-To, Subject.", 
   'NG:' => "A REGISTER request MUST NOT include these header fields: Record-Route, Alert-Info, In-Reply-To, Priority, Reply-To, Subject.", 
   'EX:' => \q{!FFIsExistHeader(['Record-Route','Alert-Info','In-Reply-To','Priority','Reply-To','Subject'],@_)}}, 



 # %% Accept:01 %%	Accept
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT_EXIST_INCLUDE', 'CA:' => 'Accept',
   'OK:' => "An Accept header MUST exist and value include.", 
   'NG:' => "An Accept header MUST exist and value include.", 
   'EX:' =>\q{FFIsExistHeader("Accept",@_) && FV('HD.Accept.val',@_) !~ /^\s*$/}},

 # %% Accept:02 %%	Accept
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT_EXIST_SHOULD', 'CA:' => 'Accept',
   'OK:' => "An Accept header field SHOULD exist.", 
   'NG:' => "An Accept header field SHOULD exist.", 
   'RT:' => "warning", 
   'EX:' =>\'FFIsExistHeader("Accept",@_)'},

 # %% Accept-Encoding:01 %%	Accept-Encoding
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT-ENCODING_EXIST', 'CA:' => 'Accept-Encoding',
   'OK:' => "An Accept-Encoding header field SHOULD exist.", 
   'NG:' => "An Accept-Encoding header field SHOULD exist.", 
   'RT:' => "warning", 
   'EX:' =>\'FFIsExistHeader("Accept-Encoding",@_)'},

 # %% Accept-Language:01 %%	Accept-Language
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT-LANGUAGE_EXIST', 'CA:' => 'Accept-Language',
   'OK:' => "An Accept-Language header field SHOULD exist.", 
   'NG:' => "An Accept-Language header field SHOULD exist.", 
   'RT:' => "warning", 
   'EX:' => \'FFIsExistHeader("Accept-Language",@_)'},

 # %% ALLOW:01 %%	Allow
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ALLOW_EXIST', 'CA:' => 'Allow',
   'OK:' => "An Allow header field SHOULD exist.", 
   'NG:' => "An Allow header field SHOULD exist.", 
   'RT:' => "warning", 
   'EX:' =>\'FFIsExistHeader("Allow",@_)'},

 # %% AUTHORIZATION:01 %%	Authorization
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ_EXIST.TM', 'CA:' => 'Authorization',
   'OK:' => "An Authorization header field MUST exist.", 
   'NG:' => "An Authorization header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("Authorization",@_)'},

 # %% Authorization:02 %%	Authorization
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ.HEADER_MUSTNOT-CONCAT', 'CA:' => 'Authorization',
   'OK:' => "The Authorization header field MUST NOT be combined into a single header field row.", 
   'NG:' => "The Authorization header field MUST NOT be combined into a single header field row.", 
   'PR:' => \'FFIsExistHeader("Authorization",@_)',
   'EX:' => sub{ my(%seen); return !(grep{$seen{($_->{id}eq'AuthParam'?$_->{name}:$_->{id})}++} @{FVs('HD.Authorization.val.digest',@_)});}},

 # %% Authorization:03 %%	Digest
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ.DIGEST', 'CA:' => 'Authorization',
   'OK:' => "The Authorization header field MUST use the \"Digest\" authentication mechanism.", 
   'NG:' => "The Authorization header field MUST use the \"Digest\" authentication mechanism.", 
   'EX:' =>\\'HD.Authorization.val.digest'},

 # %% Authorization:04 %%	nc
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-NC.EXIST', 'CA:' => 'Authorization',
   'OK:' => "The Authorization header field MUST include the nc parameter(without the quotation marks).", 
   'NG:' => "The Authorization header field MUST include the nc parameter(without the quotation marks).", 
   'EX:' =>\\'HD.Authorization.val.digest.nc'},

 # %% Authorization:05 %%	nonce
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-NONCE.EXIST', 'CA:' => 'Authorization',
   'OK:' => "The Authorization header field MUST include the nonce parameter.", 
   'NG:' => "The Authorization header field MUST include the nonce parameter.", 
   'EX:' =>\\'HD.Authorization.val.digest.nonce'},

 # %% Authorization:07 %%	realm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-REALM.EXIST', 'CA:' => 'Authorization',
   'OK:' => "The Authorization header field MUST include the realm parameter.", 
   'NG:' => "The Authorization header field MUST include the realm parameter.", 
   'EX:' =>\\'HD.Authorization.val.digest.realm'},

 # %% Authorization:09 %%	response
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-RESPONSE.EXIST', 'CA:' => 'Authorization',
   'OK:' => "The Authorization header field MUST include the response parameter.", 
   'NG:' => "The Authorization header field MUST include the response parameter.", 
   'EX:' =>\\'HD.Authorization.val.digest.response'},

 # %% Authorization:10 %%	response
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-RESPONSE.CALCULATE', 'CA:' => 'Authorization',
   'OK:' => \\'The response parameter(%s) in an Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/qop=quth)', 
   'NG:' => \\'The response parameter(%s) in an Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/qop=auth)', 
   'EX:' =>\q{FFop('EQ',\\\'HD.Authorization.val.digest.response',
                 OpCalcAuthorizationResponse('Authorization',FV('RQ.Request-Line.method',@_) eq 'ACK'?'INVITE':FV('RQ.Request-Line.method',@_),'auth',@_),@_)}},

 # %% Authorization:10b %%	response
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-RESPONSE-NOQOP.CALCULATE', 'CA:' => 'Authorization',
   'OK:' => \\'The response parameter(%s) in an Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/no qop)', 
   'NG:' => \\'The response parameter(%s) in an Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/no qop)', 
   'EX:' =>\q{FFop('EQ',\\\'HD.Authorization.val.digest.response',
                 OpCalcAuthorizationResponse('Authorization',FV('RQ.Request-Line.method',@_) eq 'ACK'?'INVITE':FV('RQ.Request-Line.method',@_),'noauth',@_),@_)}},

 # %% Authorization:11 %%	uri
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-URI.EXIST', 'CA:' => 'Authorization',
   'OK:' => "The Authorization header field MUST include the uri parameter.", 
   'NG:' => "The Authorization header field MUST include the uri parameter.", 
   'EX:' =>\\'HD.Authorization.val.digest.uri'},

 # %% Authorization:12 %%	uri
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-URI.DQUOT', 'CA:' => 'Authorization',
   'OK:' => \\'The uri(%s) MUST be enclosed in double quotation marks.', 
   'NG:' => \\'The uri(%s) MUST be enclosed in double quotation marks.', 
   'EX:' => \q{FFIsMatchStr('^".*"$',FV('HD.Authorization.val.digest.uri',@_),'','',@_)}},

 # %% Authorization:13 %%	uri
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-URI_R-URI', 'CA:' => 'Authorization',
   'OK:' => \\'The uri(%s) MUST eqaul the Request-URI(%s).', 
   'NG:' => \\'The uri(%s) MUST equal the Request-URI(%s).', 
#   'EX:' => \q{FFop('eq',\\\'HD.Authorization.val.digest.uri',('"' . FV('RQ.Request-Line.uri.txt',@_) . '"'),@_)}},
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','strict-without-port',
				FFStripDQuot(FV('HD.Authorization.val.digest.uri',@_)),FV('RQ.Request-Line.uri',@_),@_)} },

 # %% Authorization:14 %%	username
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-USERNAME.EXIST', 'CA:' => 'Authorization',
   'OK:' => "The Authorization header field MUST include the username parameter.", 
   'NG:' => "The Authorization header field MUST include the username parameter.", 
   'EX:' =>\\'HD.Authorization.val.digest.username'},

 # %% Authorization:16 %%	qop
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-qop.Auth', 'CA:' => 'Authorization',
   'OK:' => \\'The qop(%s) parameter must be auth(without the quotation marks) when received qop parameter is \"auth\".', 
   'NG:' => \\'The qop(%s) parameter must be auth(without the quotation marks) when received qop parameter is \"auth\".', 
   'EX:' =>\q{FFop('eq',\\\'HD.Authorization.val.digest.qop','auth',@_)}},
#   'EX:' =>\q{FFIsMatchStr('(auth|\"auth\")',\\\'HD.Authorization.val.digest.qop','','',@_)}},

# %% Authorization:17 %%	cnonce
  { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-CNONCE.EXIST', 'CA:' => 'Authorization',
   'OK:' => "The Authorization header field MUST include the cnonce parameter.", 
   'NG:' => "The Authorization header field MUST include the cnonce parameter.", 
   'EX:' =>\\'HD.Authorization.val.digest.cnonce'},

 # %% CALLID:01 %%	Call-ID
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CALLID_EXIST', 'CA:' => 'Call-ID',
   'OK:' => "A Call-ID header field MUST exist.",
   'NG:' => "A Call-ID header field MUST exist.",
   'EX:' =>\'FFIsExistHeader("Call-ID",@_)'},

 # %% CALLID:03 %%	Call-ID
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CALLID_VALID_RECOMMEND', 'CA:' => 'Call-ID',
   'OK:' => \\'It is RECOMMENDED that the Call-ID(%s) header equals the Call-ID(%s) header of the first INVITE.', 
   'NG:' => \\'It is RECOMMENDED that the Call-ID(%s) header equals the Call-ID(%s) header of the first INVITE.', 
   'RT:' => "warning", 
   'EX:' => \q{FFop('eq',\\\'HD.Call-ID.val.call-id',FV('HD.Call-ID.val.call-id',@_[0],'INVITE'),@_)}}, 

 # %% CNTTYPE:01 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CNTTYPE_VALID', 'CA:' => 'Content-Type',
   'OK:' => "A Content-Type header field MUST exist if the body is not empty.", 
   'NG:' => "A Content-Type header field MUST exist if the body is not empty.", 
   'PR:'=>\q{0 != length(FV('BD.txt',@_))},
   'EX:' =>\'FFIsExistHeader("Content-Type",@_)'},

 # %% CNTTYPE:02 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CNTTYPE_APP-SDP', 'CA:' => 'Content-Type',
   'OK:' => \\'The Content-Type header field MUST be \"application/sdp\".', 
   'NG:' => \\'The Content-Type header field(%s) MUST be \"application/sdp\".', 
   'PR:'=>\q{0 != length(FV('BD.txt',@_))},
   'EX:' =>\q{FFop('EQ',\\\'HD.Content-Type.val.txt','application/sdp',@_)}},

 # %% CONTACT:01 %%	Contact
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT_EXIST', 'CA:' => 'Contact',
   'OK:' => "A Contact header field MUST exist.", 
   'NG:' => "A Contact header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("Contact",@_)'},

 # %% CONTACT:03 %%	action
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-ACTION_NOEXIST', 'CA:' => 'Contact',
   'OK:' => "The \"action\" parameter from RFC 2543 has been deprecated. UACs SHOULD NOT use this parameter.", 
   'NG:' => \\'The \"action\" parameter(%s) from RFC 2543 has been deprecated. UACs SHOULD NOT use this parameter.', 
   'RT:' => "warning", 
   'EX:' =>\q{!FFIsMatchStr("^action=",\\\'HD.Contact.val.contact.param.txt','','',@_)}},

 # %% CONTACT:04 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT_NOT-*', 'CA:' => 'Contact',
   'OK:' => \\'The Contact header field value(%s) MUST not be \"*\".', 
   'NG:' => \\'The Contact header field value(%s) MUST not be \"*\".', 
   'EX:' =>\q{!FFop('eq',\\\'HD.Contact.txt','*',@_)}},

 # %% CONTACT:05 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT_REQ-CONTACT', 'CA:' => 'Contact',
   'OK:' => \\'The Contact Value(%s) equals that(%s) of 180 Ringing respond.', 
   'NG:' => \\'The Contact Value(%s) must equal that(%s) of 180 Ringing respond.', 
   'EX:' => \q{FFop('eq',\\\'HD.Contact.txt',FV('HD.Contact.txt',@_[0],PKT('LAST','recv','RQ.Status-Line.code',180,'RQ.Status-Line.reason',Ringing)),@_)}},

 # %% CSEQ:01 %%	CSeq
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ_EXIST', 'CA:' => 'CSeq',
   'OK:' => "A CSeq header field MUST exist.", 
   'NG:' => "A CSeq header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("CSeq",@_)'},

 # %% CSEQ:02 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-SEQNO_32BIT', 'CA:' => 'CSeq',
   'OK:' => \\'The first sequence number value(%s) MUST be expressible as a 32-bit unsigned integer and MUST be less than 2**31.', 
   'NG:' => \\'The first sequence number value(%s) MUST be expressible as a 32-bit unsigned integer and MUST be less than 2**31.', 
### 20060208 maeda add start ###
   'PR:' => \q{ FFIsExistHeader("CSeq", @_) &&
                FV('RQ.Request-Line.txt', @_) ne '' &&
                FVib('recv', -1, '', '',
                     'RQ.Status-Line.txt', '',
                     'HD.From.val.param.tag', FV('HD.From.val.param.tag', @_),
                     'HD.To.val.ad.ad.txt', FV('HD.To.val.ad.ad.txt', @_),
                     'HD.Call-ID.val.txt', FV('HD.Call-ID.val.txt', @_)) eq '' },
### 20060208 maeda add end ###
   'EX:' =>\q{FFop('<',\\\'HD.CSeq.val.csno',2**31,@_)}},

 # %% CSEQ:03 %%	Method
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-METHOD_REQLINE-METHOD', 'CA:' => 'CSeq',
   'OK:' => \\'The method(%s) of CSeq MUST match the method of Request-Line in the request(%s).', 
   'NG:' => \\'The method(%s) of CSeq MUST match the method of Request-Line in the request(%s).', 
   'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.method',\\\'RQ.Request-Line.method',@_)}},

 # %% CSEQ:04 %%	Method
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-METHOD_INVITE', 'CA:' => 'CSeq',
   'OK:' => "The method of CSeq header MUST be \"INVITE\".", 
   'NG:' => \\'The method(%s) of CSeq header MUST be \"INVITE\".', 
   'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.method','INVITE',@_)}},

 # %% CSEQ:05 %%	Method
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-METHOD_ACK', 'CA:' => 'CSeq',
   'OK:' => "The method of CSeq header MUST be \"ACK\".", 
   'NG:' => \\'The method(%s) of CSeq header MUST be \"ACK\".', 
   'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.method','ACK',@_)}},

 # %% CSEQ:06 %%	Method
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-METHOD_BYE', 'CA:' => 'CSeq',
   'OK:' => "The method of CSeq header MUST be \"BYE\".", 
   'NG:' => \\'The method(%s) of CSeq header MUST be \"BYE\".', 
   'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.method','BYE',@_)}},

 # %% CSEQ:07 %%	Method
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-METHOD_CANCEL', 'CA:' => 'CSeq',
   'OK:' => "The method of CSeq header MUST be \"CANCEL\".", 
   'NG:' => \\'The method(%s) of CSeq header MUST be \"CANCEL\".', 
   'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.method','CANCEL',@_)}},

 # %% CSEQ:08 %%	Method
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-METHOD_OPTIONS', 'CA:' => 'CSeq',
   'OK:' => "The method of CSeq header MUST be \"OPTIONS\".", 
   'NG:' => \\'The method(%s) of CSeq header MUST be \"OPTIONS\".', 
   'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.method','OPTIONS',@_)}},

 # %% CSEQ:09 %%	Method
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-METHOD_REGISTER', 'CA:' => 'CSeq',
   'OK:' => "The method of CSeq header MUST be \"REGISTER\".", 
   'NG:' => \\'The method(%s) of CSeq header MUST be \"REGISTER\".', 
   'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.method','REGISTER',@_)}},

 # %% CSEQ:10 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-SEQNO_REQ-SEQNO', 'CA:' => 'CSeq',
   'OK:' => \\'The CSeq header field(%s) of the request equals the CSeq field(%s) of the corresponding request.', 
   'NG:' => \\'The CSeq header field(%s) of the request MUST equal the CSeq field(%s) of the corresponding request.', 
   'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.csno',FV('HD.CSeq.val.csno',@_[0],'INVITE'),@_)}},


 # %% CNTLENGTH:01 %%	Content-Length
 #
 # THIS RULE IS MOVED TO SIPruleTransport.pm .
 #

 # %% CNTLENGTH:02 %%	Body exist,Content-Length
 # %% introduction : Body is exist.%%
 # check : Content-Length must be exist.
 # 
 # Content-Length
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CNTLENGTH_NOBODY_0', 'CA:' => 'Content-Length',
   'OK:' => "If body doesn't exist, Content-Length header value MUST be \"0\".", 
   'NG:' => "If body doesn't exist, Content-Length header value MUST be \"0\".", 
   'PR:' =>\q{0 == length(FV('BD.txt',@_))},
   'EX:' =>\q{FFop('eq',\\\'HD.Content-Length.val',0,@_)}},

# 
 # %% EXPIRES:01 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.EXPIRES_DECIMAL', 'CA:' => 'Expires',
   'OK:' => \\'The Expires header field(%s) MUST have decimal value something.', 
   'NG:' => "The Expires header field MUST have decimal value something.", 
   'PR:' => \'FFIsExistHeader("Expires",@_)',
   'EX:' => \q{FFop('ne',\\\'HD.Expires.val.seconds','',@_)}},

 # %% EXPIRES:02 %%	Expires
 #  Expires and Contact expires MUST watch.
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.EXPIRES_NOT=0', 'CA:' => 'Expires',
   'OK:' => "The Expires header field and expires parameter in Contact header MUST NOT have the zero value.", 
   'NG:' => "The Expires header field and expires parameter in Contact header MUST NOT have the zero value.", 
   'EX:' =>\q{FFop('ne',\\\'HD.Expires.val.seconds',0,@_) && !grep{int($_) eq 0} @{FVs('HD.Contact.val.contact.param.expires=',@_)}}},

 # %% EXPIRES:03 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.EXPIRES_=0', 'CA:' => 'Expires',
   'OK:' => "The Expires header field MUST have the zero value.", 
   'NG:' => \\'The Expires header field(%s) MUST have the zero value.', 
   'EX:' =>\q{FFop('eq',\\\'HD.Expires.val.seconds',0,@_)}},

 # %% FROM:01 %%	From
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM_EXIST', 'CA:' => 'From',
   'OK:' => "A From header field MUST exist.", 
   'NG:' => "A From header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("From",@_)'},

 # %% FROM:03 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM_QUOTE', 'CA:' => 'From',
   'OK:' => "The URI MUST be enclosed in angle brackets (< and >) if a comma, question mark or semicolon is contained.", 
   'NG:' => "The URI MUST be enclosed in angle brackets (< and >) if a comma, question mark or semicolon is contained.", 
   'EX:' => sub{my($ad,$from,$rest);
                  $ad=FV('HD.From.val.ad.txt',@_);
                  $from=FV('HD.From.val.txt',@_);
		  if($ad =~ /<.+>/){return 'OK';}
		  if($ad =~ /[;?\,]/){return '';}
		  if($from =~ /$ad(.+)$/){$rest=$1;return ($rest =~ /^[;\s]+tag=/);}
		  return OK;
	      }},

 # %% FROM:04 %%	From-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_EXIST', 'CA:' => 'From',
   'OK:' => \\'The From field MUST contain a \"tag\" parameter.', 
   'NG:' => \\'The From field MUST contain a \"tag\" parameter.', 
#   'EX:' =>\q{FFIsMatchStr("^tag=",\\\'HD.From.val.param','','',@_)}},
   'EX:' =>\q{FV('HD.From.val.param.tag',@_)}},

 # %% FROM:04 %%	From-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_NOEXIST', 'CA:' => 'From',
   'OK:' => "The From header field MUST NOT contain a \"tag\" parameter.", 
   'NG:' => "The From header field MUST NOT contain a \"tag\" parameter.", 
   'EX:' =>\q{FV('HD.From.val.param.tag',@_) eq ''}},

 # %% FROM:06 %%	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_RECENT-FROM-URI', 'CA:' => 'From',
   'OK:' => \\'The From URI(%s) equals that(%s) of the last message(INVITE-ACK).', 
   'NG:' => \\'The From URI(%s) must equal that(%s) of the last message(INVITE-ACK).', 
   'EX:' =>\q{FFop('eq',\\\'HD.From.val.ad.ad.txt',FV('HD.From.val.ad.ad.txt',@_[0],'LAST'),@_)}},

 # %% FROM:07 %%	From-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_RECENT-FROM-TAG', 'CA:' => 'From',
   'OK:' => "The From-tag equals that of the last message(INVITE-ACK).", 
   'NG:' => "The From-tag must equal that of the last message(INVITE-ACK).", 
   'EX:' =>\q{FFop('EQ',FV('HD.From.val.param.tag',@_),FV('HD.From.val.param.tag',@_[0],'LAST'),@_)}},

 # %% FROM:11 %%	From-Line
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-LINE_REQ-FROM-LINE_RECOMMEND', 'CA:' => 'From',
   'OK:' => \\'It is RECOMMENDED that the From line(%s) equals the From line(%s) of the first INVITE.', 
   'NG:' => \\'It is RECOMMENDED that the From line(%s) equals the From line(%s) of the first INVITE.', 
   'RT:' => "warning", 
   'EX:' =>\q{FFop('eq',\\\'HD.From.txt',FVif('recv','','','HD.From.txt','RQ.Request-Line.method','INVITE'),@_)}},

 # %% PROXY-AUTH:01 %%	Proxy-Authorization
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH_EXIST.PX', 'CA:' => 'Proxy-Authorization',
   'OK:' => "A Proxy-Authorization header field MUST exist.", 
   'NG:' => "A Proxy-Authorization header field MUST exist.", 
   'PR:' =>\q{$CNT_CONF{'AUTH-SUPPORT'} eq 'T'},
   'EX:' =>\q{FFIsExistHeader('Proxy-Authorization',@_) eq 1}},

 # %% PROXY-AUTH:16 %%	Proxy-Authorization
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH_DOUBLE-EXIST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "Two Proxy-Authorization header fields MUST be present in this message.", 
   'NG:' => "Two Proxy-Authorization header fields MUST be present in this message.", 
   'PR:' =>\q{FFIsExistHeader('Proxy-Authorization',@_) eq 1},  ## 2006.31 sawada add ##
   'EX:' =>\q{FFIsExistHeader('Proxy-Authorization',@_) eq 2}},

 # %% PROXY-AUTH:18 %%	Proxy
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-qop.Auth', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The qop(%s) parameter must be auth(without the quotation marks) when received qop parameter is \"auth\".', 
   'NG:' => \\'The qop(%s) parameter must be auth(without the quotation marks) when received qop parameter is \"auth\".', 
   'PR:' =>\q{FFIsExistHeader('Proxy-Authorization',@_) eq 1},  ## 2006.7.31 sawada add ##
   'EX:' =>\q{FFop('eq',FV('HD.Proxy-Authorization.val.digest.qop',@_),'auth',@_)}},

 # %% AUTHENTICATION-INFO:03 %%	nc 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTH-NC==00000001', 'CA:' => 'Authorization',
   'OK:' => \\'The nc(%s) in the Authorization header field MUST equal 00000001(without the quotation marks).', 
   'NG:' => \\'The nc(%s) in the Authorization header field MUST equal 00000001(without the quotation marks).', 
   'EX:' =>\q{FFop('eq',\\\'HD.Authorization.val.digest.nc',"00000001",@_)}},

 # %% P-REQUIRE:01 %%	Proxy-Require
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-REQUIRE_NOEXIST', 'CA:' => 'Proxy-Require',
   'OK:' => "The Proxy-Require header MUST NOT be used in a SIP CANCEL request, or in an ACK request sent for a non-2xx response.", 
   'NG:' => "The Proxy-Require header MUST NOT be used in a SIP CANCEL request, or in an ACK request sent for a non-2xx response.", 
   'EX:' => \q{!FFIsExistHeader("Proxy-Require",@_)}}, 

 # %% P-REQUIRE:02 %%	standards-track RFC
 # copied from S.REQUIRE-TAG_OPTION by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.P-REQUIRE-TAG_OPTION',
 'CA:'=>'Proxy-Require',
 'OK:'=>"The option tags in the Require and Proxy-Require header fields only refer to extensions defined in standards-track RFCs.", 
 'NG:'=>"The option tags in the Require and Proxy-Require header fields MUST only refer to extensions defined in standards-track RFCs.", 
 'PR:'=>\\'HD.Proxy-Require.val',
 'EX:'=>\q{FFIsMember(FVSeparete('HD.Proxy-Require.val','\s*,\s*',@_),['100rel','path','precondition','privacy','sec-agree'],'',@_)}},

 # %% RECORD-ROUTE:04 %%	Record-Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RE-ROUTE_NOEXIST', 'CA:' => 'Record-Route',
   'OK:' => "A Record-Route header field MUST NOT exist in the message.", 
   'NG:' => "A Record-Route header field MUST NOT exist in the message.", 
   'EX:' =>\'!FFIsExistHeader("Record-Route",@_)'},

 # %% RECORD-ROUTE:05 %%	Record-Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RE-ROUTE_EXIST', 'CA:' => 'Record-Route',
   'OK:' => "A Record-Route header field MUST exist in the message.", 
   'NG:' => "A Record-Route header field MUST exist in the message.", 
   'EX:' =>\'FFIsExistHeader("Record-Route",@_)'},

 # %% REPLYTO:01 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REPLYTO_NAMEADDR', 'CA:' => 'Reply-To',
   'OK:' => "Even if the \"display-name\" is empty, the \"name-addr\" form is used if the \"addr-spec\" contains a comma, question mark, or semicolon.", 
   'NG:' => "Even if the \"display-name\" is empty, the \"name-addr\" form MUST be used if the \"addr-spec\" contains a comma, question mark, or semicolon.", 
   'EX:' => \q{FFop('eq',FV('HD.Reply-To.val.ad.id',@_),'NameAddr',@_)}}, 

 # %% REQUIRE:01 %%	standards-track RFC
 # 			(2003/11/11
 #			 http://www.iana.org/assignments/sip-parameters 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE-TAG_OPTION', 'CA:' => 'Require',
   'OK:' => "The option tags in the Require and Proxy-Require header fields only refer to extensions defined in standards-track RFCs.", 
   'NG:' => "The option tags in the Require and Proxy-Require header fields MUST only refer to extensions defined in standards-track RFCs.", 
   'PR:'=>\\'HD.Require.val',
   'EX:' =>\q{FFIsMember(FVSeparete('HD.Require.val','\s*,\s*',@_),['100rel','path','precondition','privacy','sec-agree'],'',@_)}},

 # %% REQUIRE:02 %%	Require
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE_NOEXIST', 'CA:' => 'Require',
   'OK:' => "The Require header MUST NOT be used in a SIP CANCEL request, or in an ACK request sent for a non-2xx response.", 
   'NG:' => "The Require header MUST NOT be used in a SIP CANCEL request, or in an ACK request sent for a non-2xx response.", 
   'EX:' => \q{!FFIsExistHeader("Require",@_)}}, 

 # %% REQUIRE:03 %%	Require is exist
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE_EXIST', 'CA:' => 'Require',
   'OK:' => "A Require header MUST exist.", 
   'NG:' => "A Require header MUST exist.", 
   'EX:' => \q{FFIsExistHeader("Require",@_)}}, 


# %% RETRY-AFTER:01 %%	Retry-After header include and must be between 0 and 10.(ex:Retry-After: 10 .....)
###   modified by Horisawa (2006.1.17)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RETRYAFTER_0-10',
 'CA:'=>'Retry-After',
 'OK:'=>\\'The Retry-After header MUST exist, and the value(%s) MUST be between 0 and 10.', 
 'NG:'=>\\'The Retry-After header MUST exist, and the value(%s) MUST be between 0 and 10.', 
 'EX:'=>\q{FFIsExistHeader("Retry-After",@_)
		&& FFop('<=>',FV('HD.Retry-After.val.delta',@_),[0,10],@_)}},

 # %% ROUTE:01 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_VALID', 'CA:' => 'Route',
   'OK:' => "The CANCEL request MUST include Route header field's value of the request being cancelled.", 
   'NG:' => "The CANCEL request MUST include Route header field's value of the request being cancelled.", 
   'PR:' =>\q{FFIsExistHeader("Route",@_[0],'INVITE')},
   'EX:' =>\q{FFop('eq',FVs('HD.Route.val.route.ad.ad.txt',@_),FVs('HD.Route.val.route.ad.ad.txt',@_[0],'INVITE'))}},

 # %% ROUTE:02 %%	Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_NOEXIST', 'CA:' => 'Route',
   'OK:' => "A Route header field MUST NOT be present in this message.", 
   'NG:' => "A Route header field MUST NOT be present in this message.", 
   'EX:' =>\'!FFIsExistHeader("Route",@_)'},

 # %% ROUTE:03 %%	Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_EXIST', 'CA:' => 'Route',
   'OK:' => "A Route header field MUST exist.", 
   'NG:' => "A Route header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("Route",@_)'},


 # %% ROUTE:04 %%       INVITE
 #                      INVITE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_NOEXIST_BY_INVITE', 'CA:' => 'Route',
   'OK:' => "Must not set Route header field based on Record-Route header field in non-2xx response.",
   'NG:' => "Must not set Route header field based on Record-Route header field in non-2xx response.",
   'EX:' =>\q{FFIsExistHeader("Route",@_[0],'INVITE') ? FFop('eq',FVs('HD.Route.val.route.ad.ad.txt',@_),FVs('HD.Route.val.route.ad.ad.txt',@_[0],'INVITE')):!FFIsExistHeader("Route",@_)}},


 # %% SUPPORTED:01 %%	Supported
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SUPPORTED_EXIST', 'CA:' => 'Supported',
   'OK:' => "A Supported header field SHOULD exist.", 
   'NG:' => "A Supported header field SHOULD exist.", 
   'RT:' => "warning", 
   'EX:' =>\'FFIsExistHeader("Supported",@_)'},

 # %% TO:01 %%	To
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO_EXIST', 'CA:' => 'To',
   'OK:' => "A To header field MUST exist.", 
   'NG:' => "A To header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("To",@_)'},

 # %% TO:04 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO_QUOTE', 'CA:' => 'To',
   'OK:' => "The URI MUST be enclosed in angle brackets (< and >) if a comma, question mark or semicolon is contained.", 
   'NG:' => "The URI MUST be enclosed in angle brackets (< and >) if a comma, question mark or semicolon is contained.", 
   'EX:' =>\q{FFIsMatchStr('^[^;?,]+$',\\\'HD.To.val.ad.txt','','',@_) || 
		 FFIsMatchStr('.*?<.+>$',\\\'HD.To.val.ad.txt','','',@_)}},

 # %% TO:06 %%	To-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_NOEXIST', 'CA:' => 'To',
   'OK:' => "The To header field MUST NOT contain a \"tag\" parameter.", 
   'NG:' => "The To header field MUST NOT contain a \"tag\" parameter.", 
   'EX:' =>\q{FV('HD.To.val.param.tag',@_) eq ''}},

 # %% TO:07 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_RECENT-TO-URI', 'CA:' => 'To',
   'OK:' => \\'The To URI(%s) equals that(%s) of the last message.', 
   'NG:' => \\'The To URI(%s) must equal that(%s) of the last message.', 
   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt',FV('HD.To.val.ad.ad.txt',@_[0],'REQUEST'),@_)}}, 

 # %% TO:10 %%	To-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_EXIST', 'CA:' => 'To',
   'OK:' => "The To header field MUST contain a \"tag\" parameter.", 
   'NG:' => "The To header field MUST contain a \"tag\" parameter.", 
   'EX:' =>\q{FV('HD.To.val.param.tag',@_)}},


 # %% TO:11 %%	To-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_RECENT1xx-TO-TAG', 'CA:' => 'To',
   'OK:' => \\'The To tag(%s) SHOULD be the same as the To tag(%s) in the response to the original request.', 
   'NG:' => \\'The To tag(%s) SHOULD be the same as the To tag(%s) in the response to the original request.', 
   'RT:' => "warning", 
   'EX:' =>\q{PKT('LAST','recv','RQ.Status-Line.code',\\q{$val=~/^1/}) &&
              FFop('EQ',FV('HD.To.val.param.tag',@_),
                        FV('HD.To.val.param.tag',@_[0],PKT('LAST','recv','RQ.Status-Line.code',\\q{$val=~/^1/})),@_)}}, 

# %% TO:12 %%	To-Line
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-LINE_REQ-TO-LINE_RECOMMEND', 'CA:' => 'To',
   'OK:' => \\'It is RECOMMENDED that the To line(%s) equals the To line(%s) of the first INVITE.', 
   'NG:' => \\'It is RECOMMENDED that the To line(%s) equals the To line(%s) of the first INVITE.', 
   'RT:' => "warning", 
   'EX:' =>\q{FFop('eq',\\\'HD.To.txt',FVif('recv','','','HD.To.txt','RQ.Request-Line.method','INVITE'),@_)}},

 # %% MAXFORWARDS:01 %%	Max-Forwards
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MAX-FORWARDS_EXIST', 'CA:' => 'Max-Forwards',
   'OK:' => "A Max-Forwards header field MUST exist.", 
   'NG:' => "A Max-Forwards header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("Max-Forwards",@_)'},

 # %% MAXFORWARDS:02 %%	Max-Forwards: 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MAX-FORWARDS', 'CA:' => 'Max-Forwards',
   'OK:' => \\'Max-Forwards header value(%s) SHOULD be %s.', 
   'NG:' => \\'Max-Forwards header value(%s) SHOULD be %s.', 
   'RT:' => "warning", 
   'PR:' =>\'FFIsExistHeader("Max-Forwards",@_)',  ## 2006.7.31 sawada add ##
   'EX:' =>\q{FFop('eq',\\\'HD.Max-Forwards.val',$CNT_CONF{'MAX-FORWARDS'},@_)}},

 # %% VIA:01 %%	Via
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_EXIST', 'CA:' => 'Via',
   'OK:' => "A Via header field MUST exist.", 
   'NG:' => "A Via header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("Via",@_)'},

## %% VIA:02 %%	Via: 
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-TRANSPORT_UDP', 'CA:' => 'Via',
#   'OK:' => "The transport of Via header field MUST equal \"UDP\".", 
#   'NG:' => "The transport of Via header field MUST equal \"UDP\".", 
#   'EX:' =>\q{FFIsExistStr("UDP",\\\'HD.Via.val.via.proto.trans','',@_)}},

## 2006.1.27 sawada ##
 # %% VIA:02 %%	Via: 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-TRANSPORT_UDP', 'CA:' => 'Via',
   'OK:' => "The transport of Via header field MUST equal \"$SIP_PL_TRNS\".", 
   'NG:' => "The transport of Via header field MUST equal \"$SIP_PL_TRNS\".", 
   'EX:' =>\q{FFIsExistStr($SIP_PL_TRNS,\\\'HD.Via.val.via.proto.trans','',@_)}},

 # %% VIA:03 %%	Via: branch ID
 # 
 # branch
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_z9hG4bK', 'CA:' => 'Via',
   'OK:' => "The branch ID MUST always begin with the characters \"z9hG4bK\".", 
   'NG:' => \\'The branch ID(%s) MUST always begin with the characters \"z9hG4bK\".', 
   'PR:' => \q{FVs('HD.Via.val.via.param.branch=',@_)},
   'EX:' =>\q{FFIsMatchStr("^z9hG4bK",\\\'HD.Via.val.via.param.branch=','ALL','',@_)}},

 # %% VIA:04 %%	Via: Contact addr-spec 
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_NOTIPADDRESS', 'CA:' => 'Via',
   'PR:' => \q{!IsIPAddress($CNT_CONF{'PUA-CONTACT-HOSTNAME'})},
   'OK:' => \\'The sent-by of Via field(%s) is RECOMMENDED to be specified by the hostname of NUT, instead of IP address form.', 
   'NG:' => \\'The sent-by of Via field(%s) is RECOMMENDED to be specified by the hostname of NUT, instead of IP address form.', 
   'RT:' => "warning", 
   'EX:' => \q{FFIsMatchStr(qr/^(?:$PtHostname(?:$PtCOLON$PtPort)?)$/s,
                    FVs('HD.Via.val.via.sendby.txt',@_),'ALL','',@_)}}, 

  # %% VIA:05 %%	Via
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_REQ-SINGULAR', 'CA:' => 'Via',
   'OK:' => "A CANCEL request MUST have only a single Via header field value.", 
   'NG:' => "A CANCEL request MUST have only a single Via header field value.", 
   'EX:' =>\q{FFop('eq',FFIsExistHeader('Via',@_),1,@_)}},

 # %% VIA:06 %%	Via
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_REQ-1STVIA', 'CA:' => 'Via',
   'OK:' => \\'A CANCEL request MUST have a Via header field value(%s) matching the top Via value(%s) in the request being cancelled.', 
   'NG:' => \\'A CANCEL request MUST have a Via header field value(%s) matching the top Via value(%s) in the request being cancelled.', 
   'EX:' =>\q{FFop('eq',\\\'HD.Via.val.via.by',FV('HD.Via.val.via.by',@_[0],'INVITE'),@_)}},


 # %% VIA:07 %%	branch
 # branch
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_REQ-VIA-BRANCH', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) of ACK for non-2xx and CANCEL MUST equal that(%s) of INVITE.', 
   'NG:' => \\'The Via branch value(%s) of ACK for non-2xx and CANCEL MUST equal that(%s) of INVITE.', 
   'PR:' => \q{FVs('HD.Via.val.via.param.branch=',@_)},
   'EX:' =>\q{FFop('EQ',\\\'HD.Via.val.via.param.branch=',FV('HD.Via.val.via.param.branch=',@_[0],'INVITE'),@_)}},

 # %% VIA:13 %%	branch
 # branch
 # branch
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value MUST be differenet from any of branch which UA has sent.(Excepting ACK for non-2xx and CANCEL).', 
   'NG:' => \\'The Via branch value MUST be differenet from any of branch which UA has sent.(Excepting ACK for non-2xx and CANCEL)', 
   'PR:' => \q{FVs('HD.Via.val.via.param.branch=',@_)},
   'EX:' => \q{!FFIsMember(\\\'HD.Via.val.via.param.branch=',FVsib('recv',-1,'','HD.Via.val.via.param.branch=','','',@_),'EQ',@_)}}, 

 # %% VIA:21 %%	Via: branch parameter exist
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_EXIST', 'CA:' => 'Via',
   'OK:' => "A branch parameter MUST exist in each Via header.", 
   'NG:' => "A branch parameter MUST exist in each Via header.", 
   'EX:' =>\q{FFIsMatchStr('branch=',\\\'HD.Via.val.txt','T','',@_)}},

 # specially T3-1-1-10
 # %% VIA:23 %%	Via: transport
 # 5
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-TRANSPORT_USTUT', 'CA:' => 'Via',
   'OK:' => \\'The Via transport(%s) is same that Sended Via transport(%s).', 
   'NG:' => \\'The Via transport(%s) MUST same that Sended Via transport(%s).', 
   'EX:' => \q{FFop('eq',FVs('HD.Via.val.via.proto.trans',@_),[UDP,SCTP,TLS,UNKNOWN,TCP],@_)}},


 # %% Warning:01 %%	Warning
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WARNING_EXIST', 'CA:' => 'Warning',
   'OK:' => "A Warning header field MUST exist.", 
   'NG:' => "A Warning header field MUST exist.", 
   'EX:' =>\'FFIsExistHeader("Warning",@_)'},

 # %% Warning:02 %%	Warning code 399.
 # Warning: 399 isi.rdu "Miscellaneous warning"
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WARNING-CODE_399', 'CA:' => 'Warning',
   'OK:' => "Warning code is 399.", 
   'NG:' => \\'Warning code(%s) must be 399.', 
   'EX:' =>\q{FFop('eq',(FV('HD.Warning.val',@_) =~ /^\s*([0-9]+)/?$1:''),399,@_)}},

 # %% Warning:03 %%	Warning
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WARNING_EXIST_SHOULD', 'CA:' => 'Warning',
   'OK:' => "A Warning header field SHOULD exist.", 
   'NG:' => "A Warning header field SHOULD exist.", 
   'RT:' => "warning", 
   'EX:'=>\'FFIsExistHeader("Warning",@_)'},

##BODY

 # %% BODY:02 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BODY_NOEXIST', 'CA:' => 'Body',
   'OK:' => "It is RECOMMENDED that a body part is not present in this message.", 
   'NG:' => "It is RECOMMENDED that a body part is not present in this message.", 
   'RT:' => "warning", 
   'EX:' => \q{!FV('BD.txt',@_)} }, 

 # %% BODY:03 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BODY_EXIST_SHOULD', 'CA:' => 'Body',
   'OK:' => "A body part SHOULD be present in this message.", 
   'NG:' => "A body part SHOULD be present in this message.", 
   'RT:' => "warning", 
   'EX:' =>\\'BD.txt'},

# %% BODY:03 %%	
### this rule is same as S.BODY_EXIST_SHOULD.
### When SPECIFICATION is IG or TTC, 
###  this rule is overwritten by IG's S.BODY_EXIST.
### When SPECIFICATION is RFC,
###  this rule is used.
###   written by Horisawa (2006.1.26)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.BODY_EXIST',
 'CA:'=>'Body',
 'OK:'=>"A body part MUST be present in this message.", 
 'NG:'=>"A body part MUST be present in this message.", 
 'EX:'=>\\'BD.txt'},


 # %% BODY:04 %%
 # 
 # BODY
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BODY_ACK-ANSWER_EXIST', 'CA:' => 'Body',
   'OK:' => "A body part MUST be present in this message.", 
   'NG:' => "A body part MUST be present in this message.", 
   'PR:' =>\q{!FV('BD.txt',@_[0],'INVITE') && FV('HD.txt',@_[0],'INVITE')},
   'EX:' =>\\'BD.txt'},


 # %% SDP:01 %%	v=0 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.V_EQUAL-ZERO', 'CA:' => 'v=',
   'OK:' => "The v line in SDP body message MUST equal zero.", 
   'NG:' => \\'The v line(%s) in SDP body message MUST equal zero.', 
   'EX:' =>\q{FFop('eq',\\\'BD.v=.txt','0',@_)}},

 # %% SDP:02 %%	<nettype>
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.O-IN_VALID', 'CA:' => 'o=',
   'OK:' => "The newtype paramter in o line in SDP body message MUST be \"IN\".", 
   'NG:' => \\'The newtype paramter in o line(%s) in SDP body message MUST be \"IN\".', 
   'EX:' =>\q{FFop('eq',FFGetIndexValSeparateDelimiter(\\\'BD.o=.txt',3,' ',@_),'IN',@_)}},

 # %% SDP:03 %%	<addrtype>
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.O-IP_VALID', 'CA:' => 'o=',
   'OK:' => "The addrtype of o line in SDP body message MUST be \"IP$SIP_PL_IP\".", 
   'NG:' => \\'The addrtype of o line(%s) in SDP body message MUST be \"IP$SIP_PL_IP\".', 
   'EX:' =>\q{FFop('eq',FFGetIndexValSeparateDelimiter(\\\'BD.o=.txt',4,' ',@_),"IP$SIP_PL_IP",@_)}},

 # %% SDP:05 %%	<session id> 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.O-SESSIONID_64BIT', 'CA:' => 'o=',
   'OK:' => "The session id of o line in SDP body message MUST be represented by signed 64bit decimal value.", 
   'NG:' => "The session id of o line in SDP body message MUST be represented by signed 64bit decimal value.", 
   'EX:' => sub{my($val);
		$val=FFGetIndexValSeparateDelimiter(\\'BD.o=.txt',1,' ',@_);
                return($val =~ /^$PtSignedInteger$/ && -(2**63) <= $val && $val <= 2**63);}},


 # %% SDP:06 %%	<version> 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.O-VERSION_64BIT', 'CA:' => 'o=',
   'OK:' => "The version of o line in SDP body message MUST be represented by signed 64bit decimal value.", 
   'NG:' => "The version of o line in SDP body message MUST be represented by signed 64bit decimal value.", 
   'EX:' => sub{my($val);
		$val=FFGetIndexValSeparateDelimiter(\\'BD.o=.txt',2,' ',@_);
                return($val =~ /^$PtSignedInteger$/ && -(2**63) <= $val && $val <= 2**63);}},


 # %% SDP:07 %%	s=
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.S_VALID', 'CA:' => 's=',
   'OK:' => "It is RECOMMENDED that the s line in SDP body message is either LWS(0x20) or dash(-).", 
   'NG:' => "It is RECOMMENDED that the s line in SDP body message is either LWS(0x20) or dash(-).", 
   'RT:' => "warning", 
   'EX:' =>\q{FFIsMember(\\\'BD.s=.txt',[' ','-'],'',@_)}},

 # %% SDP:08 %%	<network type>
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.C-IN_VALID', 'CA:' => 'c=',
   'OK:' => "The network type of c line in SDP body message MUST be \"IN\".", 
   'NG:' => \\'The network type of c line(%s) in SDP body message MUST be \"IN\".', 
   'EX:' =>\q{FFop('eq',FFGetIndexValSeparateDelimiter(\\\'BD.c=.txt',0,' ',@_),'IN',@_)}},

 # %% SDP:09 %%	<addrtype>
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.C-IP_VALID', 'CA:' => 'c=',
   'OK:' => "The addrtype of c line in SDP body message MUST be \"IP$SIP_PL_IP\".", 
   'NG:' => \\'The addrtype of c line(%s) in SDP body message MUST be \"IP$SIP_PL_IP\".', 
   'EX:' =>\q{FFop('eq',FFGetIndexValSeparateDelimiter(\\\'BD.c=.txt',1,' ',@_),"IP$SIP_PL_IP",@_)}},

 # %% SDP:11 %%	t=0 0 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.T_VALID', 'CA:' => 't=',
   'OK:' => "The t line in SDP body message SHOULD be \"0 0\".", 
   'NG:' => \\'The t line(%s) in SDP body message SHOULD be \"0 0\".', 
   'RT:' => "warning",
   'EX:' =>\q{FFop('eq',\\\'BD.t=.txt','0 0',@_)}},

 # %% SDP:12 %%	m=
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.M_EXIST', 'CA:' => 'm=',
   'OK:' => "A m line MUST be present in SDP body of this message.", 
   'NG:' => "A m line MUST be present in SDP body of this message.", 
   'EX:' =>\'FFIsExistHeader("m=",@_)'},

 # %% SDP:13 %%	
 #              (v,o,s,(i),(u),(e),(p),(c),(b),t,(r),(z),(k),(a),m,(i),(c),(b),(k),a)
 #              Mutliple Time descriptions(t= and r=) is not supported yet
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.TAG_PRIORITY', 'CA:' => 'Body',
   'OK:' => "The SDP message MUST be written by the following order: v,o,s,(i),(u),(e),(p),(c),(b),t,(r),(z),(k),(a),m,(i),(c),(b),(k),a",
   'NG:' => "The SDP message MUST be written by the following order: v,o,s,(i),(u),(e),(p),(c),(b),t,(r),(z),(k),(a),m,(i),(c),(b),(k),a",
   'PR:' => \\'BD.txt',
   'EX:' => \q{IsCorrectTagOrder(['v=','o=','s=',\'i=',\'u=',\'e=',\'p=','c=',\'b=',
                                  't=',\'r=',\'z=',\'k=',\'a=',
                                  'm=',\'i=',\'c=',\'b=',\'k=','a='],'BD',@_) || 
               IsCorrectTagOrder(['v=','o=','s=',\'i=',\'u=',\'e=',\'p=',\'b=',
                                  't=',\'r=',\'z=',\'k=',\'a=',
                                  'm=',\'i=','c=',\'b',\'k=','a='],'BD',@_) }},

 # %% SDP:14 %%	a=ptime
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.A-PTIME_VALID', 'CA:' => 'a=',
   'OK:' => \\'If the a line in SDP body message is ptime(%s), it MUST be larger than zero.', 
   'NG:' => \\'If the a line in SDP body message is ptime(%s), it MUST be larger than zero.', 
   'PR:' => sub{ my($val,$i);@FVaEQPtime=();
		 $val=FVs('BD.m=.val.txt',@_);
		 for($i=0;$i<=$#$val;$i++){while($val->[$i] =~ /a=ptime:([0-9]+)\s*(?:\r\n|\Z)/mg){push(@FVaEQPtime,$1);}}
                 return -1<$#FVaEQPtime;},
   'EX:' => sub{ my($rule,$pktinfo,$context)=@_;my($val);
                 $val=grep{int($_)<1} @FVaEQPtime;
	         $context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'0<','ARG1:'=>ArrayToStr(\@FVaEQPtime)};
                 return !$val;}},

 # %% SDP:15 %%	v
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.TAG-ONE_LINE-EXIST', 'CA:' => 'Body',
   'OK:' => "Only one SDP body MUST exist.", 
   'NG:' => "Only one SDP body MUST exist.", 
   'EX:' => \q{$#{FVs('BD.v=',@_)} == 0 && $#{FVs('BD.o=',@_)} == 0 && $#{FVs('BD.s=',@_)} == 0 } }, 

 # %% SDP:18 %%	    - m= line
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.M-LINE_SEND-CONTAIN', 'CA:' => 'm=',
   'OK:' => \\'The m lines(%s) MUST contain at least m lines(%s) of offer.', 
   'NG:' => \\'The m lines(%s) MUST contain at least m lines(%s) of offer.', 
   'PR:' =>\q{length(FV('BD.txt',@_)) > 0},  ## 2006.7.31 sawada add ##  
   'EX:' => \q{FFop('>=',FVcount(FVs('BD.m=.val',@_)),FVcount(FVib('send','','','BD.m=.val')),@_)} }, 

 # %% SIP:01 %% 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SIP-ALLSAME-INVITE', 'CA:' => 'SIP',
   'OK:' => "The message SHOULD be the same(retransmitted) INVITE.", 
   'NG:' => "The message SHOULD be the same(retransmitted) INVITE.", 
   'RT:' => "warning",
   'EX:' =>\q{FV('SIP',@_) eq FVib('recv',-1,'','SIP','RQ.Request-Line.method','INVITE')}},

 # %% SIP:02 %% 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SIP-SIZELESS-INVITE', 'CA:' => 'SIP',
   'OK:' => "The length of body message MUST be less than that of previous INVITE.", 
   'NG:' => "The length of body message MUST be less than that of previous INVITE.", 
   'EX:' =>\q{length(FV('SIP',@_)) < length(FVib('recv',-1,'','SIP','RQ.Request-Line.method','INVITE'))}},

 # %% SIP:02 %% 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SIP-ALLSAME-STATUS200', 'CA:' => 'SIP',
   'OK:' => "The message SHOULD be the same(retransmitted) 200 response.", 
   'NG:' => "The message SHOULD be the same(retransmitted) 200 response.",
   'RT:' => "warning",
   'EX:' =>\q{FV('SIP',@_) eq FVib('recv',-1,'','SIP','RQ.Status-Line.code',200)}},

 # %% SIP:02 %% 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACK-NOTSEND-INVALID-STATUS200', 'CA:' => 'SIP',
   'OK:' => "Client does not send ACK for invalid Status 200.", 
   'NG:' => "Client does not send ACK for invalid Status 200.",
   'EX:' =>\q{FVifc('recv',FVifx(0,'send','','','','RQ.Status-Line.code','200','HD.CSeq.val.method','INVITE'),'','RQ.Request-Line.method','ACK') eq 0}},

 # %% SDP:   %%	    RE-INVITE 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REINVITE-RETRANS.A-SENDONLY', 'CA:' => 'SIP',
   'OK:' => "Client retransmit RE-INVITE.", 
   'NG:' => "Client does not retransmit RE-INVITE.", 
   'EX:' => \q{1<FVibc('recv','','','BD.txt',\'$val =~ /a=\s*sendonly/')}},

 # %% INVITE:01 %%INVITE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-INVITE-No3,4-INTERVAL', 'CA:' => 'SIP',
   'OK:' => \\'Client INVITE retransmit No3 and No4 interval(%s) is valid(%s)',
   'NG:' => \\'Client INVITE retransmit No3 and No4 interval(%s) is invalid(%s)',
   'EX:' => sub{ my($rule,$pktinfo,$context)=@_;my($ts3,$ts4,$ts34,$inerval);
                 $ts3=FVifx(2,'recv','','','TS','RQ.Request-Line.method','INVITE');
                 $ts4=FVifx(3,'recv','','','TS','RQ.Request-Line.method','INVITE');
		 $ts34=$ts4-$ts3;
		 $inerval=$CNT_CONF{'TIMER-T1'}*2*2;
                 $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'==','ARG1:'=>$ts34,'ARG2:'=>$inerval};
                 return ($ts3 && $ts4 &&
			 $inerval-$CNT_CONF{'TIMER-MAGIN'}<=$ts34 && $ts34<=$inerval+$CNT_CONF{'TIMER-MAGIN'});}},

 # %% ICMP:01 %%ICMP TimeExceed
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-INVITE-ICMP', 'CA:' => 'SIP',
   'OK:' => "Client INVITE retransmit, after ICMP TimeExceed",
   'NG:' => "Client INVITE does not retransmit, after ICMP TimeExceed",
   'EX:' => sub{ my($ts,$viaa,$viab,$expr);
                 $ts=ICMPFVib('send','','','timestamp','Frame_Ether.Packet_IPv6.ICMPv6_TimeExceeded.Type',3);
                 $expr='$val<' ."$ts";
                 $viaa=FVib('recv','','','HD.Via.val.via.param.branch=','RQ.Request-Line.method','INVITE','TS',\$expr);
                 $expr='$val>' ."$ts";
                 $viab=FVif('recv','','','HD.Via.val.via.param.branch=','RQ.Request-Line.method','INVITE','TS',\$expr);
                 return ($viab && FFop('eq',$viaa,$viab,@_));}},

 # %% ICMP:02 %% ICMP Unreachable
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.NOT-RETRANS-INVITE-ICMP', 'CA:' => 'SIP',
   'OK:' => "Client MUST NOT retransmit INVITE after client received ICMP unreachable.",
   'NG:' => "Client MUST NOT retransmit INVITE after client received ICMP unreachable.",
   'EX:' => sub{ my($ts,$viaa,$viab,$expr);
                 $ts=ICMPFVif('send','','','timestamp','Frame_Ether.Packet_IPv6.ICMPv6_DestinationUnreachable.Type',1);
                 $expr='$val<' ."$ts";
                 $viaa=FVib('recv','','','HD.Via.val.via.param.branch=','RQ.Request-Line.method','INVITE','TS',\$expr);
                 $expr='$val>' ."$ts";
                 $viab=FVif('recv','','','HD.Via.val.via.param.branch=','RQ.Request-Line.method','INVITE','TS',\$expr);
                 return (!$viab || !FFop('eq',$viaa,$viab,@_));}},

 # %% ICMP:03 %%ICMP TimeExceed
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-STATUS200-ICMP', 'CA:' => 'SIP',
   'OK:' => "Client STATUS 200 SHOULD retransmit, after ICMP TimeExceed",
   'NG:' => "Client STATUS 200 SHOULD retransmit, after ICMP TimeExceed",
   'RT:' => "warning", 
   'EX:' => sub{ my($ts,$expr,$before,$after);
                 $ts=ICMPFVib('send','','','timestamp','Frame_Ether.Packet_IPv6.ICMPv6_TimeExceeded.Type',3);
                 $expr='$val<' ."$ts";
                 $before=FVifc('recv','','','RQ.Status-Line.code',200,'HD.CSeq.val.method','INVITE','TS',\$expr);
                 $expr='$val>' ."$ts";
                 $after =FVifc('recv','','','RQ.Status-Line.code',200,'HD.CSeq.val.method','INVITE','TS',\$expr);
                 return ($before && $after);}},

 # %% ICMP:04 %% ICMP Unreachable
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.NOT-RETRANS-STATUS200-ICMP', 'CA:' => 'SIP',
   'OK:' => "Client SHOULD NOT retransmit 200 response after client received ICMP unreachable.",
   'NG:' => "Client SHOULD NOT retransmit 200 response after client received ICMP unreachable.",
   'RT:' => "warning", 
   'EX:' => sub{ my($ts,$expr);
                 $ts=ICMPFVif('send','','','timestamp','Frame_Ether.Packet_IPv6.ICMPv6_DestinationUnreachable.Type',1);
                 $expr='$val>' ."$ts";
                 return !FVifc('recv','','','RQ.Status-Line.code',200,'HD.CSeq.val.method','INVITE',
			       'TS',\$expr,'FRAME','SIPtoPROXY');}},

 # Proxy 1
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-INVITE-TO-PX1', 'CA:' => 'SIP',
   'OK:' => "Client sends INVITE to Proxy 1, after ICMP unreachable",
   'NG:' => "Client does not send INVITE to Proxy 1, after ICMP unreachable",
   'EX:' => sub{ my($ts,$expr);
                 $ts=ICMPFVif('send','','','timestamp','Frame_Ether.Packet_IPv6.ICMPv6_DestinationUnreachable.Type',1);
                 $expr='$val>' ."$ts";
                 return FVifc('recv','','','FRAME','SIPtoPROXY','RQ.Request-Line.method','INVITE','TS',\$expr);}},

 # Retry-After(503)
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRY-AFTER.NOT-INVITE-RETRANS', 'CA:' => 'SIP',
   'OK:' => "Client SHOULD NOT send INVITE to Proxy 1, after 503 response received.",
   'NG:' => "Client SHOULD NOT send INVITE to Proxy 1, after 503 response received.",
   'RT:' => "warning",
   'EX:' => sub{ my($index);
                 $index=FVif('send','','','','RQ.Status-Line.code',503);
                 return FVifc('recv',$index,'','FRAME','SIPtoPROXY','RQ.Request-Line.method','INVITE') <= 0;}},

 # Retry-After(503)
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRY-AFTER.INVITE-INTERVAL', 'CA:' => 'SIP',
   'OK:' => \\'Client SHOULD send INVITE(%ssec) after Retry-After(%ssec) passed',
   'NG:' => \\'Client SHOULD send INVITE(%ssec) after Retry-After(%ssec) passed',
   'RT:' => "warning",
   'EX:' => sub{ my($rule,$pktinfo,$context)=@_;my($index,$ts1,$ts2,$delta1,$delta2);
                 $delta2=FVif('send','','','HD.Retry-After.val.delta','RQ.Status-Line.code',503);
                 $index=FVif('send','','','','RQ.Status-Line.code',503);
                 $ts1=FVif('send','','','TS','RQ.Status-Line.code',503);
                 $ts2=FVif('recv',$index,'','TS','RQ.Request-Line.method',INVITE);
                 $delta1=$ts2?int(($ts2-$ts1)*1000)/1000:'NON';
                 $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<','ARG1:'=>$delta1,'ARG2:'=>$delta2};
                 return (!$ts2 || $delta2< $ts2-$ts1);}},

 # Retry-After(503)
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRY-AFTER.ACK-EXIST', 'CA:' => 'SIP',
   'OK:' => \\'Client SHOULD NOT send ACK within Retry-After(%ssec)',
   'NG:' => \\'Client SHOULD NOT send ACK(%ssec) within Retry-After(%ssec)',
   'RT:' => "warning",
   'EX:' => sub{ my($rule,$pktinfo,$context)=@_;my($index,$ts1,$ts2,$delta1,$delta2);
                 $delta2=FVif('send','','','HD.Retry-After.val.delta','RQ.Status-Line.code',503);
                 $index=FVif('send','','','','RQ.Status-Line.code',503);
                 $ts1=FVif('send','','','TS','RQ.Status-Line.code',503);
                 $ts2=FVif('recv',$index,'','TS','RQ.Request-Line.method',ACK);
                 if(!$ts2 || $delta2< $ts2-$ts1){
                    $context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'<','ARG1:'=>$delta2};return 'T';}
                 else{
                    $delta1=int(($ts2-$ts1)*1000)/1000;
                    $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<','ARG1:'=>$delta1,'ARG2:'=>$delta2};return '';}}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-NOBYE-AFTER3.BYE', 'CA:' => 'SIP',
   'OK:' => 'Client BYE MUST NOT retransmit after illegal 200.',
   'NG:' => 'Client BYE MUST NOT retransmit after illegal 200.',
   'EX:' => sub{ my($ts,$expr);
                 $ts=FVib('send','','','TS','RQ.Status-Line.code',200)+3;
		 $expr='$val>' ."$ts";
                 return !FVifc('recv','','','RQ.Request-Line.method','BYE','TS',\$expr);}},


 #=================================
 # 
 #=================================

#Status-LINE

#  100 Trying
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-100','PT:'=>RQ,
  'FM:'=>'SIP/2.0 100 Trying',},

#  180 Ringing
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-180','PT:'=>RQ,
  'FM:'=>'SIP/2.0 180 Ringing',},

#  183 Session Progress
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-183','PT:'=>RQ,
  'FM:'=>'SIP/2.0 183 Session Progress',},

#  199 
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-199','PT:'=>RQ,
  'FM:'=>'SIP/2.0 199 Temporary Provisional response',},

#  200 OK
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-200','PT:'=>RQ,
  'FM:'=>'SIP/2.0 200 OK',},

#  299 OK
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-299','PT:'=>RQ,
  'FM:'=>'SIP/2.0 299 OK',},

#  301 Moved Permanently
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-301','PT:'=>RQ,
  'FM:'=>'SIP/2.0 302 Moved Permanently',},

#  302 Moved Temporarily
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-302','PT:'=>RQ,
  'FM:'=>'SIP/2.0 302 Moved Temporarily',},

#  305 Use Proxy
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-305','PT:'=>RQ,
  'FM:'=>'SIP/2.0 305 Use Proxy',},

#  401 Unauthorized
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-401','PT:'=>RQ,
  'FM:'=>'SIP/2.0 401 Unauthorized',},

#  403 Forbidden
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-403','PT:'=>RQ,
  'FM:'=>'SIP/2.0 403 Forbidden',},

#  404 Not Found
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-404','PT:'=>RQ,
  'FM:'=>'SIP/2.0 404 Not Found',},

#  407 Proxy Authorization Required
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-407','PT:'=>RQ,
  'FM:'=>'SIP/2.0 407 Proxy Authorization Required',},

#  408 Request Timeout
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-408','PT:'=>RQ,
  'FM:'=>'SIP/2.0 408 Request Timeout',},

#  413 Request Entity too Large
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-413','PT:'=>RQ,
  'FM:'=>'SIP/2.0 413 Request Entity too Large',},

#  480 Proxy Authorization
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-480','PT:'=>RQ,
  'FM:'=>'SIP/2.0 480 Temporarily Unavailable',},

#  481 Call/Transaction Does Not Exist
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-481','PT:'=>RQ,
  'FM:'=>'SIP/2.0 481 Call/Transaction Does Not Exist',},

#  486 Busy Here
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-486','PT:'=>RQ,
  'FM:'=>'SIP/2.0 486 Busy Here',},

#  487 Proxy Authorization
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-487','PT:'=>RQ,
  'FM:'=>'SIP/2.0 487 Request Terminated',},

#  488 Not Acceptable Here
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-488','PT:'=>RQ,
  'FM:'=>'SIP/2.0 488 Not Acceptable Here',},

#  491 Request Pending
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-491','PT:'=>RQ,
  'FM:'=>'SIP/2.0 491 Request Pending',},

#  499 Error
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-499','PT:'=>RQ,
  'FM:'=>'SIP/2.0 499 Error',},

#  500 Server Internal Error
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-500','PT:'=>RQ,
  'FM:'=>'SIP/2.0 500 Server Internal Error',},

#  503 Service Unavailable
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-503','PT:'=>RQ,
  'FM:'=>'SIP/2.0 503 Service Unavailable',},

#  599 Error
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-599','PT:'=>RQ,
  'FM:'=>'SIP/2.0 599 Error',},

#  699 Error
 {'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-699','PT:'=>RQ,
  'FM:'=>'SIP/2.0 699 Error',},

#Header

#  ACCEPT application/sdp
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACCEPT_SDP','PT:'=>HD,
  'FM:'=>'Accept: application/sdp'},

#  ALLOW VALID(INVITE,ACK,CANCEL,OPTIONS,BYE)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ALLOW_VALID','PT:'=>HD, 
  'FM:'=>'Allow: INVITE,ACK,CANCEL,OPTIONS,BYE'},

#  CONTENTTYPE VALID(application/sdp)
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTENTTYPE_VALID','PT:'=>HD,
  'FM:'=>'Content-Type: application/sdp'},


#  CONTENT-LENGTH value=CALUCULATION
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTENT-LENGTH_CAL','OD:'=>LAST, 'PT:'=>HD,
  'FM:'=>'Content-Length: %s',
  'AR:'=>[\&FFCalcConteLength]},

#  CONTENT-LENGTH value=0
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTENT-LENGTH_0','PT:'=>HD,
  'FM:'=>'Content-Length: 0'},

#  CONTENT-LENGTH value=0
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTENT-LENGTH_350','PT:'=>HD,
  'FM:'=>'Content-Length: 350'},

# DATE VALID
 {'TY:'=>'ENCODE', 'ID:'=>'E.DATE_VALID','PT:'=>HD, 
  'FM:'=>'','AR:'=>'',
  'EX:' => sub{my $gtime=gmtime();
              my($wday,$mon,$day,$ttime,$year)=split(' ',$gtime);
              return sprintf("Date: $wday, $day $mon $year $ttime GMT");
             }
},

#  MAXFORWARDS NOPX=70
 {'TY:'=>'ENCODE', 'ID:'=>'E.MAXFORWARDS_NOPX','PT:'=>HD,
  'FM:'=>'Max-Forwards: %d','AR:'=>[\q{$CNT_CONF{'MAX-FORWARDS'}}]},

#  MAXFORWARDS ONEPX=69
 {'TY:'=>'ENCODE', 'ID:'=>'E.MAXFORWARDS_ONEPX','PT:'=>HD,
  'FM:'=>'Max-Forwards: %d','AR:'=>[\q{$CNT_CONF{'MAX-FORWARDS'}-1}]},

#  MAXFORWARDS TWOPX=68
 {'TY:'=>'ENCODE', 'ID:'=>'E.MAXFORWARDS_TWOPX','PT:'=>HD,
  'FM:'=>'Max-Forwards: %d','AR:'=>[\q{$CNT_CONF{'MAX-FORWARDS'}-2}]},

#  REQUIRE for SF510
 {'TY:'=>'ENCODE', 'ID:'=>'E.REQUIRE_FOO','PT:'=>HD, 
  'FM:'=>'Require: foo'},

#  RETRY-AFTER TWOPX for O8-4
 {'TY:'=>'ENCODE', 'ID:'=>'E.RETRYAFTER_10','PT:'=>HD, 
  'FM:'=>'Retry-After: 10'},

#  RETRY-AFTER TWOPX for 500
 {'TY:'=>'ENCODE', 'ID:'=>'E.RETRYAFTER_40','PT:'=>HD, 
  'FM:'=>'Retry-After: 40'},

#  RETRY-AFTER TWOPX for 500
 {'TY:'=>'ENCODE', 'ID:'=>'E.RETRYAFTER_120','PT:'=>HD, 
  'FM:'=>'Retry-After: 120'},

### 20050418 usako delete start
# #  SUPPORTED VALID(null)
#  # for invite-request
#  {'TY:'=>'ENCODE', 'ID:'=>'E.SUPPORTED_VALID','PT:'=>HD,
# #   'FM:'=>'Supported: '},							# 20050406 usako delete
#    'FM:'=> \q{ "Supported: %s" },					# 20050407 usako add
#    'AR:'=> [ \q{ $CNT_CONF{'UA-SUPPORTED'} } ],		# 20050407 usako add
#  },													# 20050407 usako add

# ### 20050407 usako add start ###
#  # for response
#  {'TY:'=>'ENCODE', 'ID:'=>'E.RES.SUPPORTED_VALID','PT:'=>HD,
#    'FM:'=> \q{ "Supported: %s" },
#    'AR:'=> [ \q{ FV('HD.Supported.txt', @_) } ],
#  },
# ### 20050407 usako add end ###
### 20050418 usako delete start

#  EXPIRES 2
 {'TY:'=>'ENCODE', 'ID:'=>'E.EXPIRES_2','PT:'=>HD,
  'FM:'=>'Expires: 2'},

#  EXPIRES MAX Expores > 2**32-1 = 4,294,967,296 - 1
 {'TY:'=>'ENCODE', 'ID:'=>'E.EXPIRES_MAX','PT:'=>HD,
  'FM:'=>'Expires: 4294967296'},

#### 
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA-RETURN','PT:'=>HD,
  'FM:'=>'Via: %s;received=%s',
  'AR:'=>[\\'HD.Via.txt',\q{$CVA_TUA_IPADDRESS}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM-RETURN','PT:'=>HD,
  'FM:'=>'From: %s',
  'AR:'=>[\\'HD.From.txt']},

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO-RETURN','PT:'=>HD, 
  'FM:'=>'To: %s',
  'AR:'=>[\\'HD.To.txt']},

 {'TY:'=>'ENCODE', 'ID:'=>'E.CALL-ID-RETURN','PT:'=>HD, 
  'FM:'=>'Call-ID: %s',
  'AR:'=>[\\'HD.Call-ID.txt']},

 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ-RETURN','PT:'=>HD, 
  'FM:'=>'CSeq: %s',
  'AR:'=>[\\'HD.CSeq.txt']},

 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ-LAST-INVITE','PT:'=>HD, 
  'FM:'=>'CSeq: %s INVITE',
  'AR:'=>[\q{FV('HD.CSeq.val.csno',@_[0],'INVITE')}]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT-RETURN-EX','PT:'=>HD, 
  'FM:'=>'Contact: %s',
  'AR:'=>[sub {my($msg);$msg="<".FV('HD.Contact.val.contact.ad.ad.txt',@_).">";
               $msg = $msg . ";expires=$CNT_CONF{'EXPIRES'}"; return $msg;}] },

 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT-RETURN-EX-5','PT:'=>HD, 
  'FM:'=>'Contact: %s',
  'AR:'=>[sub {my($msg);$msg="<".FV('HD.Contact.val.contact.ad.ad.txt',@_).">";
               $msg = $msg . ";expires=5"; return $msg;}] },

 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT-RETURN-EX-30','PT:'=>HD, 
  'FM:'=>'Contact: %s',
  'AR:'=>[sub {my($msg);$msg="<".FV('HD.Contact.val.contact.ad.ad.txt',@_).">";
               $msg = $msg . ";expires=30"; return $msg;}] },


 #=================================
 # 
 #=================================
# INVITE 
# 
# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-1.INVITE', 'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => \q{sprintf('INVITE MUST be retransmitted(No.%s) after Timer A fired. Timer A:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'NG:' => \q{sprintf('INVITE MUST be retransmitted(No.%s) after Timer A fired. Timer A:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'INVITE') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{2<=$T1_COUNT && $T1_COUNT<=9 && 
		  ($T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF)}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-32.INVITE',  'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => \q{sprintf('When Timer B fired, client INVITE retransmit No.%s has valid interval. Timer B:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'NG:' => \q{sprintf('When Timer B fired, client INVITE retransmit No.%s is timer missing. Timer B:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'INVITE') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{10<=$T1_COUNT && 
		  ($T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF)}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-STOP-AFTER-BTIMER.INVITE','CA:' => 'Timer',
   'OK:' => 'Client INVITE retransmit stopped after Timer B fired.',
   'NG:' => 'Client INVITE retransmit does not stopped after Timer B fired.',
   'OD:' => 'LAST',
   'EX:' => sub{ my($ts,$expr);
                 $ts=FVif('recv','','','TS','RQ.Request-Line.method',INVITE)+$CNT_CONF{'TIMER-T1'}*64;
		 $expr='$val>' ."$ts";
                 return !FVifc('recv','','','RQ.Request-Line.method','INVITE','TS',\$expr);}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-NOACK-AFTER-BTIMER.INVITE', 'CA:' => 'Timer',
   'OK:' => 'Client MUST NOT send ACK after Timer B fired.',
   'NG:' => 'Client MUST NOT send ACK after Timer B fired.',
   'OD:' => 'LAST',
   'EX:' => sub{ my($ts,$expr);
                 $ts=FVif('recv','','','TS','RQ.Request-Line.method',INVITE)+$CNT_CONF{'TIMER-T1'}*64;
		 $expr='$val>' ."$ts";
                 return !FVifc('recv','','','RQ.Request-Line.method','ACK','TS',\$expr);}},

# 180 Ringing
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-STOP-AFTER180.INVITE','CA:' => 'Timer',
   'OK:' => 'Client SHOULD NOT retransmit INVITE after received 180 response.',
   'NG:' => 'Client SHOULD NOT retransmit INVITE after received 180 response.',
   'RT:' => "warning", 
   'OD:' => 'LAST',
   'EX:' => \q{!FVif('recv',FVib('send','','','','RQ.Status-Line.code',180),'','','RQ.Request-Line.method',INVITE)}},


# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-MUST-486.INVITE', 'CA:' => 'Timer',
   'OK:' => '4xx-6xx response(for example, 486) MUST be retransmitted within Timer H.',
   'NG:' => '4xx-6xx response(for example, 486) MUST be retransmitted within Timer H.',
   'OD:' => 'LAST',
   'EX:' => \q{FFmustExitFrameBetweenFrames(FVif('send','','','','RQ.Request-Line.method','INVITE'),'',
                           ['send','RQ.Request-Line.method','INVITE'],['send','RQ.Request-Line.method','INVITE'],
	                   [['recv','RQ.Status-Line.code',\q{300<=int($val)},'HD.CSeq.val.method','INVITE']],$CNT_CONF{'TIMER-T1'}*64)}},

# INVITE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-486-MULTIREPLY.INVITE','CA:' => 'Timer',
   'OK:' => '4xx-6xx response(for example, 486) MUST NOT be sent twice or more times.',
   'NG:' => '4xx-6xx response(for example, 486) MUST NOT be sent twice or more times.',
   'OD:' => 'LAST',
   'EX:' => \q{FFmustExitFrameBetweenFrames(FVif('recv','','','','RQ.Status-Line.code',\q{300<=int($val)},'HD.CSeq.val.method','INVITE'),'',
          ['recv','RQ.Status-Line.code',\q{300<=int($val)},'HD.CSeq.val.method','INVITE'],
          ['recv','RQ.Status-Line.code',\q{300<=int($val)},'HD.CSeq.val.method','INVITE'],
          [['send','RQ.Request-Line.method','INVITE']],$CNT_CONF{'TIMER-T1'}*64)}},

# INVITE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-481-OVER-HTIMER.INVITE','CA:' => 'Timer',
   'OK:' => 'After Timer H fired, 4xx-6xx response MUST NOT be retransmitted, otherwise response MUST have different To tag from previous response',
   'NG:' => 'After Timer H fired, 4xx-6xx response MUST NOT be retransmitted, otherwise response MUST have different To tag from previous response',
   'OD:' => 'LAST',
   'EX:' => \q{!FVibc('recv','','','RQ.tag','Status-Line','TS',\q{$CNT_CONF{'TIMER-T1'}*64<($val-$T1_START)})||
		   FVibx(0,'recv','','','HD.To.val.param.tag','TS',\q{$CNT_CONF{'TIMER-T1'}*64>($val-$T1_START)}) ne
		   FVifx(0,'recv','','','HD.To.val.param.tag','TS',\q{$CNT_CONF{'TIMER-T1'}*64<($val-$T1_START)}) }},

# INVITE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.NOACK-AFTER-T1*64.INVITE','CA:' => 'Timer',
   'OK:' => 'Client does not send ACK after T1*64.',
   'NG:' => 'Client sends ACK after T1*64.',
   'OD:' => 'LAST',
   'EX:' => \q{!FVifc('recv',FVib('send','','','','RQ.Status-Line.code','487'),'','RQ.Request-Line.method','ACK')}},

# INVITE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.NOACK-AFTER-T1*64-SHOULD.INVITE','CA:' => 'Timer',
   'OK:' => 'Client SHOULD NOT send ACK after T1*64.',
   'NG:' => 'Client SHOULD NOT send ACK after T1*64.',
   'OD:' => 'LAST',
   'RT:' => "warning", 
   'EX:' => \q{!FVifc('recv',FVib('send','','','','RQ.Status-Line.code','487'),'','RQ.Request-Line.method','ACK')}},

# Expires Tineout
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CANCEL-AFTER-EXPIRES-TIMEOUT.INVITE','CA:' => 'Timer',
   'OK:' => \q{sprintf('Client sends CANCEL, after Expires time(%d).',$CNT_ExpiresTime)},
   'NG:' => \q{sprintf('Client does not send CANCEL or send CANCEL before Expires time(%d).',$CNT_ExpiresTime)},
   'OD:' => 'LAST',
   'EX:' => \q{$CNT_ExpiresTime<=(FVif('recv','','','TS','RQ.Request-Line.method',CANCEL)-$T1_START)}},,

# INVITE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-200-T1.INVITE', 'LG:' => 'INVALID','CA:' => 'Timer',
   'NG:' => \q{sprintf(' Client 200 retransmit No.%s is timer missing. Expected time:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Status-Line.code') eq '200') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{2<=$T1_COUNT && 
		  ($T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF)}},

# INVITE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BYE-OVER-T1*64.INVITE','CA:' => 'Timer',
   'OK:' => 'Client SHOULD send BYE, after T1*64',
   'NG:' => \q{sprintf('Client SHOULD send BYE (%3.2f)sec after 1st 200, but within T1*64(%s)sec',
                (FVib('recv','','','TS','RQ.Request-Line.method',BYE)-$T1_START),$CNT_CONF{'TIMER-T1'}*64)},
   'OD:' => 'LAST',
   'RT:' => "warning", 
   'EX:' => \q{$CNT_CONF{'TIMER-T1'}*64<=(FVib('recv','','','TS','RQ.Request-Line.method',BYE)-$T1_START)}},


# CANCEL 
# 
# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-1.CANCEL', 'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => \q{sprintf('CANCEL request MUST be retransmitted(No.%s) after Timer E fired. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'NG:' => \q{sprintf('CANCEL request MUST be retransmitted(No.%s) after Timer E fired. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'CANCEL') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{2<=$T1_COUNT && 
		  ($T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF)}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-F-TIMER.CANCEL','CA:' => 'Timer',
   'OK:' => 'CANCEL request MUST NOT be retransmitted after Timer F fired.',
   'NG:' => 'CANCEL request MUST NOT be retransmitted after Timer F fired.',
   'OD:' => 'LAST',
   'EX:' => \q{($T1_LAST-$T1_START)<$CNT_CONF{'TIMER-T1'}*64}},

# 100
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-100BEFORE.CANCEL', 'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => \q{sprintf('Before Tester receives 100 response, CANCEL request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'NG:' => \q{sprintf('Before Tester receives 100 response, CANCEL request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'CANCEL') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv') &&
		   !FVib('send',$PKT_INDEX,'','','RQ.Status-Line.code',100,'HD.CSeq.val.method','CANCEL')},
   'EX:' => \q{$T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF}},
# # 100
#  { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-100AFTER.CANCEL', 'LG:' => 'NOT','CA:' => 'Timer',
#    'OK:' => \q{sprintf('After Tester received 100 response, CANCEL request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
#    'NG:' => \q{sprintf('After Tester received 100 response, CANCEL request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
#    'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'CANCEL') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv') &&
# 		   $TMP_VAL=FVib('send',$PKT_INDEX,'','','RQ.Status-Line.code',100,'HD.CSeq.val.method','CANCEL') &&
# 		   FVib('recv',$PKT_INDEX-1,$TMP_VAL,'','RQ.Request-Line.method',CANCEL)},
#    'EX:' => \q{$T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF}},
# 100
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-100AFTER.CANCEL', 'CA:' => 'Timer',
   'OK:' => \\'After Tester received 100 response, CANCEL request MUST be retransmitted with valid Timer E. Timer E:%s retransmit time:%s',
   'NG:' => \\'After Tester received 100 response, CANCEL request MUST be retransmitted with valid Timer E. Timer E:%s retransmit time:%s',
   'OD:' => 'LAST',
   'RT:' => "warning", 
   'EX:' => sub{ my($rule,$pktinfo,$context)=@_;my($index,$first,$second,$diff);
		 $index=FVib('send','','','','RQ.Status-Line.code',100,'HD.CSeq.val.method','CANCEL');
		 $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<','ARG1:'=>$CNT_CONF{'TIMER-T2'},'ARG2:'=>0};
		 if(!$index){return ''};
		 if(!($first=FVif('recv',$index,  '','','RQ.Request-Line.method',CANCEL))){return ''};
		 if(!($second=FVif('recv',$first+1,'','','RQ.Request-Line.method',CANCEL))){return ''};
		 $diff=FVi($second,'TS')-FVi($first,'TS');
		 $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<','ARG1:'=>$CNT_CONF{'TIMER-T2'},'ARG2:'=>sprintf("%.2f",$diff)};
		 return $CNT_CONF{'TIMER-T2'}-$CNT_CONF{'TIMER-MAGIN'}<$diff && $diff<$CNT_CONF{'TIMER-T2'}+$CNT_CONF{'TIMER-MAGIN'};}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-MUST-200.CANCEL', 'CA:' => 'Timer',
   'OK:' => '200 response MUST be retransmitted within Timer J.',
   'NG:' => '200 response MUST be retransmitted within Timer J.',
   'OD:' => 'LAST',
   'EX:' => \q{FFmustExitFrameBetweenFrames(FVif('send','','','','RQ.Request-Line.method','CANCEL'),'',
                           ['send','RQ.Request-Line.method','CANCEL'],['send','RQ.Request-Line.method','CANCEL'],
	                   [['recv','RQ.Status-Line.code',200,'HD.CSeq.val.method','CANCEL']],$CNT_CONF{'TIMER-T1'}*64)}},

# CANCEL
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-200-MULTIREPLY.CANCEL','CA:' => 'Timer',
   'OK:' => '200 response MUST NOT be sent twice or more times.',
   'NG:' => '200 response MUST NOT be sent twice or more times.',
   'OD:' => 'LAST',
   'EX:' => \q{FFmustExitFrameBetweenFrames(FVif('recv','','','','RQ.Status-Line.code',200,'HD.CSeq.val.method','CANCEL'),'',
          ['recv','RQ.Status-Line.code',200,'HD.CSeq.val.method','CANCEL'],['recv','RQ.Status-Line.code',200,'HD.CSeq.val.method','CANCEL'],
          [['send','RQ.Request-Line.method','CANCEL']],$CNT_CONF{'TIMER-T1'}*64)}},

# CANCEL
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-481-OVER-JTIMER.CANCEL','CA:' => 'Timer',
   'OK:' => '481 response MUST be sent after Timer J fired.',
   'NG:' => '481 response MUST be sent after Timer J fired.',
   'OD:' => 'LAST',
   'EX:' => \q{FVibc('recv','','','RQ.Status-Line.code','481','HD.CSeq.val.method','CANCEL','TS',\q{32<($val-$T1_START)})}},

# CANCEL
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-200-OVER-JTIMER.CANCEL','CA:' => 'Timer',
   'OK:' => '200 response MUST NOT be sent after Timer J fired.',
   'NG:' => '200 response MUST NOT be sent after Timer J fired.',
   'OD:' => 'LAST',
   'EX:' => \q{!FVibc('recv','','','RQ.Status-Line.code','200','HD.CSeq.val.method','CANCEL','TS',\q{32<($val-$T1_START)})}},


# BYE 
# 
# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-1.BYE', 'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => \q{sprintf('BYE request MUST be retransmitted(No.%s) after Timer E fired. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'NG:' => \q{sprintf('BYE request MUST be retransmitted(No.%s) after Timer E fired. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'BYE') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{2<=$T1_COUNT && 
		  ($T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF)}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-F-TIMER.BYE','CA:' => 'Timer',
   'OK:' => 'BYE request MUST NOT be retransmitted after Timer F fired.',
   'NG:' => 'BYE request MUST NOT be retransmitted after Timer F fired.',
   'OD:' => 'LAST',
   'EX:' => \q{($T1_LAST-$T1_START)<$CNT_CONF{'TIMER-T1'}*64}},

# 100
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-100BEFORE.BYE', 'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => \q{sprintf('Before Tester receives 100 response, BYE request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'NG:' => \q{sprintf('Before Tester receives 100 response, BYE request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'BYE') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv') &&
		   !FVib('send',$PKT_INDEX,'','','RQ.Status-Line.code',100,'HD.CSeq.val.method','BYE')},
   'EX:' => \q{$T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF}},
# # 100
#  { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-100AFTER.BYE', 'LG:' => 'NOT','CA:' => 'Timer',
#    'OK:' => \q{sprintf('After Tester received 100 response, BYE request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
#    'NG:' => \q{sprintf('After Tester received 100 response, BYE request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
#    'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'BYE') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv') &&
# 		   $TMP_VAL=FVib('send',$PKT_INDEX,'','','RQ.Status-Line.code',100,'HD.CSeq.val.method','BYE') &&
# 		   FVib('recv',$PKT_INDEX-1,$TMP_VAL,'','RQ.Request-Line.method',BYE)},
#    'EX:' => \q{$T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF}},
# 100
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-100AFTER.BYE', 'CA:' => 'Timer',
   'OK:' => \\'After Tester received 100 response, BYE request SHOULD be retransmitted with valid Timer E. Timer E:%s retransmit time:%s',
   'NG:' => \\'After Tester received 100 response, BYE request SHOULD be retransmitted with valid Timer E. Timer E:%s retransmit time:%s',
   'OD:' => 'LAST',
   'RT:' => "warning", 
   'EX:' => sub{ my($rule,$pktinfo,$context)=@_;my($index,$first,$second,$diff);
		 $index=FVib('send',$PKT_INDEX,'','','RQ.Status-Line.code',100,'HD.CSeq.val.method','BYE');
		 $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<','ARG1:'=>$CNT_CONF{'TIMER-T2'},'ARG2:'=>0};
		 if(!$index){return ''};
		 if(!($first=FVif('recv',$index,  '','','RQ.Request-Line.method',BYE))){return ''};
		 if(!($second=FVif('recv',$first+1,'','','RQ.Request-Line.method',BYE))){return ''};
		 $diff=FVi($second,'TS')-FVi($first,'TS');
		 $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<','ARG1:'=>$CNT_CONF{'TIMER-T2'},'ARG2:'=>sprintf("%.2f",$diff)};
		 return $CNT_CONF{'TIMER-T2'}-$CNT_CONF{'TIMER-MAGIN'}<$diff && $diff<$CNT_CONF{'TIMER-T2'}+$CNT_CONF{'TIMER-MAGIN'};}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-MUST-200.BYE', 'CA:' => 'Timer',
   'OK:' => '200 response MUST be retransmitted within Timer J.',
   'NG:' => '200 response MUST be retransmitted within Timer J.',
   'OD:' => 'LAST',
   'EX:' => \q{FFmustExitFrameBetweenFrames(FVif('send','','','','RQ.Request-Line.method','BYE'),'',
                           ['send','RQ.Request-Line.method','BYE'],['send','RQ.Request-Line.method','BYE'],
	                   [['recv','RQ.Status-Line.code',200,'HD.CSeq.val.method','BYE']],$CNT_CONF{'TIMER-T1'}*64)}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-200-MULTIREPLY.BYE','CA:' => 'Timer',
   'OK:' => '200 response MUST NOT be sent twice or more times.',
   'NG:' => '200 response MUST NOT be sent twice or more times.',
   'OD:' => 'LAST',
   'EX:' => \q{FFmustExitFrameBetweenFrames(FVif('recv','','','','RQ.Status-Line.code',200,'HD.CSeq.val.method','BYE'),'',
          ['recv','RQ.Status-Line.code',200,'HD.CSeq.val.method','BYE'],['recv','RQ.Status-Line.code',200,'HD.CSeq.val.method','BYE'],
          [['send','RQ.Request-Line.method','BYE']],$CNT_CONF{'TIMER-T1'}*64)}},

# BYE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-481-OVER-JTIMER.BYE','CA:' => 'Timer',
   'OK:' => '481 response MUST be sent after Timer J fired.',
   'NG:' => '481 response MUST be sent after Timer J fired.',
   'OD:' => 'LAST',
   'EX:' => \q{FVibc('recv','','','RQ.Status-Line.code','481','HD.CSeq.val.method','BYE','TS',\q{32<($val-$T1_START)})}},

# BYE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-200-OVER-JTIMER.BYE','CA:' => 'Timer',
   'OK:' => '200 response MUST NOT be sent after Timer J fired.',
   'NG:' => '200 response MUST NOT be sent after Timer J fired.',
   'OD:' => 'LAST',
   'EX:' => \q{!FVibc('recv','','','RQ.Status-Line.code','200','HD.CSeq.val.method','BYE','TS',\q{32<($val-$T1_START)})}},

# REGISTER 
# 
# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-1.REGISTER', 'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => \q{sprintf('REGISTER request MUST be retransmitted(No.%s) after Timer E fired. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'NG:' => \q{sprintf('REGISTER request MUST be retransmitted(No.%s) after Timer E fired. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'REGISTER') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{2<=$T1_COUNT && 
		  ($T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF)}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-F-TIMER.REGISTER','CA:' => 'Timer',
   'OK:' => 'REGISTER request MUST NOT be retransmitted after Timer F fired.',
   'NG:' => 'REGISTER request MUST NOT be retransmitted after Timer F fired.',
   'OD:' => 'LAST',
   'EX:' => \q{($T1_LAST-$T1_START)<$CNT_CONF{'TIMER-T1'}*64}},

# 100
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-100BEFORE.REGISTER', 'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => \q{sprintf('Before Tester receives 100 response, REGISTER request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'NG:' => \q{sprintf('Before Tester receives 100 response, REGISTER request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'REGISTER') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv') &&
		   !FVib('send',$PKT_INDEX,'','','RQ.Status-Line.code',100,'HD.CSeq.val.method','REGISTER')},
   'EX:' => \q{$T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF}},
# # 100
#  { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-100AFTER.REGISTER', 'LG:' => 'NOT','CA:' => 'Timer',
#    'OK:' => \q{sprintf('After Tester received 100 response, REGISTER request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
#    'NG:' => \q{sprintf('After Tester received 100 response, REGISTER request MUST be retransmitted(No.%s) with valid Timer E. Timer E:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
#    'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'REGISTER') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv') &&
# 		   $TMP_VAL=FVib('send',$PKT_INDEX,'','','RQ.Status-Line.code',100,'HD.CSeq.val.method','REGISTER') &&
# 		   FVib('recv',$PKT_INDEX-1,$TMP_VAL,'','RQ.Request-Line.method',REGISTER)},
#    'EX:' => \q{$T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF}},
# 100
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-100AFTER.REGISTER', 'CA:' => 'Timer',
   'OK:' => \\'After Tester received 100 response, REGISTER request MUST be retransmitted with valid Timer E. Timer E:%s retransmit time:%s',
   'NG:' => \\'After Tester received 100 response, REGISTER request MUST be retransmitted with valid Timer E. Timer E:%s retransmit time:%s',
   'OD:' => 'LAST',
   'RT:' => "warning", 
   'EX:' => sub{ my($rule,$pktinfo,$context)=@_;my($index,$first,$second,$diff);
		 $index=FVib('send',$PKT_INDEX,'','','RQ.Status-Line.code',100,'HD.CSeq.val.method','REGISTER');
		 $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<','ARG1:'=>$CNT_CONF{'TIMER-T2'},'ARG2:'=>0};
		 if(!$index){return ''};
		 if(!($first=FVif('recv',$index,  '','','RQ.Request-Line.method','REGISTER'))){return ''};
		 if(!($second=FVif('recv',$first+1,'','','RQ.Request-Line.method','REGISTER'))){return ''};
		 $diff=FVi($second,'TS')-FVi($first,'TS');
		 $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<','ARG1:'=>$CNT_CONF{'TIMER-T2'},'ARG2:'=>sprintf("%.2f",$diff)};
		 return $CNT_CONF{'TIMER-T2'}-$CNT_CONF{'TIMER-MAGIN'}<$diff && $diff<$CNT_CONF{'TIMER-T2'}+$CNT_CONF{'TIMER-MAGIN'};}},

# 486 STATUS 
#   486 
#   32
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-NONSTOP.ACK', 'CA:' => 'Timer',
   'OK:' => 'ACK request MUST be retransmitted before Timer D fires.',
   'NG:' => 'ACK request MUST be retransmitted before Timer D fires.',
   'OD:' => 'LAST',
#   32
   'EX:' => \q{FVifc('recv',FVib('send','','','','RQ.Status-Line.code',\q{300<=int($val)},'TS',\q{($val-$T1_START)<32}),
		      '','RQ.Request-Line.method','ACK','TS',\q{($val-$T1_START)<32})}},

#   32
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-STOP.ACK','CA:' => 'Timer',
   'OK:' => 'ACK request MUST NOT be retransmitted after Timer D fired.',
   'NG:' => 'ACK request MUST NOT be retransmitted after Timer D fired.',
   'OD:' => 'LAST',
   'EX:' => \q{!FVibc('recv','','','RQ.Request-Line.method','ACK','TS',\q{32<($val-$T1_START)})}},

# 
# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-1.486', 'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => \q{sprintf('4xx-6xx response(for example, 486) MUST be retransmitted(No.%s) after Timer G fired. Timer G:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'NG:' => \q{sprintf('4xx-6xx response(for example, 486) MUST be retransmitted(No.%s) after Timer G fired. Timer G:%s retransmit time:%3.2f',$T1_COUNT,$T1_TIMER,$T1_DIFF)},
   'PR:' => \q{300<=int(FVi($PKT_INDEX,'RQ.Status-Line.code')) && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{2<=$T1_COUNT &&
		  ($T1_DIFF<$T1_TIMER-$CNT_CONF{'TIMER-MAGIN'} || $T1_TIMER+$CNT_CONF{'TIMER-MAGIN'}<$T1_DIFF)}},


# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-H-TIMER.486','CA:' => 'Timer',
   'OK:' => '4xx-6xx response(for example, 486) MUST NOT be retransmitted after Timer H fired.',
   'NG:' => '4xx-6xx response(for example, 486) MUST NOT be retransmitted after Timer H fired.',
   'OD:' => 'LAST',
   'EX:' => \q{($T1_LAST-$T1_START)<$CNT_CONF{'TIMER-T1'}*64}},

#   ACK
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-STOP.486','CA:' => 'Timer',
   'OK:' => '4xx-6xx response(for example, 486) MUST NOT be retransmitted after received ACK request.',
   'NG:' => '4xx-6xx response(for example, 486) MUST NOT be retransmitted after received ACK request.',
   'OD:' => 'LAST',
   'EX:' => \q{!FVifc('recv',FVib('send','','','','RQ.Request-Line.method','ACK'),'',
                 'RQ.Status-Line.code',\q{300<=int($val)},'HD.CSeq.val.method','INVITE')}},

# OPTIONS 
# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-MUST-200.OPTIONS', 'CA:' => 'Timer',
   'OK:' => '200 response MUST be retransmitted within Timer J.',
   'NG:' => '200 response MUST be retransmitted within Timer J.',
   'OD:' => 'LAST',
   'EX:' => \q{FFmustExitFrameBetweenFrames(FVif('send','','','','RQ.Request-Line.method','OPTIONS'),'',
                           ['send','RQ.Request-Line.method','OPTIONS'],['send','RQ.Request-Line.method','OPTIONS'],
	                   [['recv','RQ.Status-Line.code',200,'HD.CSeq.val.method','OPTIONS']],$CNT_CONF{'TIMER-T1'}*64)}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-200-MULTIREPLY.OPTIONS','CA:' => 'Timer',
   'OK:' => '200 response MUST NOT be sent twice or more times.',
   'NG:' => '200 response MUST NOT be sent twice or more times.',
   'OD:' => 'LAST',
   'EX:' => \q{FFmustExitFrameBetweenFrames(FVif('recv','','','','RQ.Status-Line.code',200,'HD.CSeq.val.method','OPTIONS'),'',
          ['recv','RQ.Status-Line.code',200,'HD.CSeq.val.method','OPTIONS'],['recv','RQ.Status-Line.code',200,'HD.CSeq.val.method','OPTIONS'],
          [['send','RQ.Request-Line.method','OPTIONS']],$CNT_CONF{'TIMER-T1'}*64)}},

# OPTIONS
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-481-OVER-JTIMER.OPTIONS','CA:' => 'Timer',
   'OK:' => '481 response MUST be sent after Timer J fired.',
   'NG:' => '481 response MUST be sent after Timer J fired.',
   'OD:' => 'LAST',
   'EX:' => \q{FVibc('recv','','','RQ.Status-Line.code','481','HD.CSeq.val.method','OPTIONS','TS',\q{32<($val-$T1_START)})}},

# OPTIONS
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-200-OVER-JTIMER.OPTIONS','CA:' => 'Timer',
   'OK:' => '200 response MUST NOT be sent after Timer J fired.',
   'NG:' => '200 response MUST NOT be sent after Timer J fired.',
   'OD:' => 'LAST',
   'EX:' => \q{!FVibc('recv','','','RQ.Status-Line.code','200','HD.CSeq.val.method','OPTIONS','TS',\q{32<($val-$T1_START)})}},

# INVITE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-EXIST.INVITE',  'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => 'Client sent INVITE',
   'NG:' => 'Client did not send INVITE',
   'OD:' => 'LAST',
   'EX:' => \q{FVif('recv','','','','RQ.Request-Line.method',INVITE) eq ''}},

# CANCEL
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-EXIST.CANCEL',  'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => 'Client sent CANCEL',
   'NG:' => 'Client did not send CANCEL',
   'OD:' => 'LAST',
   'EX:' => \q{FVif('recv','','','','RQ.Request-Line.method',CANCEL) eq ''}},

# BYE
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-EXIST.BYE',  'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => 'Client sent BYE',
   'NG:' => 'Client did not send BYE',
   'OD:' => 'LAST',
   'EX:' => \q{FVif('recv','','','','RQ.Request-Line.method',BYE) eq ''}},

# REGISTER
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-EXIST.REGISTER',  'LG:' => 'NOT','CA:' => 'Timer',
   'OK:' => 'Client sent REGISTER',
   'NG:' => 'Client did not send REGISTER',
   'OD:' => 'LAST',
   'EX:' => \q{FVif('recv','','','','RQ.Request-Line.method',REGISTER) eq ''}},

# STATUS 4xx-6xx
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-EXIST-1.486', 'CA:' => 'Timer',
   'OK:' => 'Client sent 4xx-6xx response',
   'NG:' => 'Client did not send 4xx-6xx response',
   'OD:' => 'LAST',
   'EX:' => \q{FVif('recv','','','','RQ.Status-Line.code',\q{300<=int($val)})}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-SAME-CONTACT.REGISTER', 'CA:' => 'Timer',
   'OK:' => 'Client sent REGISTER with same Contact',
   'NG:' => 'Client did not send REGISTER with same Contact',
   'OD:' => 'LAST',
   'EX:' => sub{my($contact);
		$contact=FVsib('recv','','','HD.Contact.txt',['RQ.Request-Line.method','REGISTER'],'T');
		return(!$contact || IsArraySameValue($contact,$contact->[0]));}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-REINVITE_2-4','CA:' => 'Timer',
   'OK:' => \\'If UAC receives 491 response to a re-INVITE(and UAC is the owner of the CALL-ID), UAC SHOULD send another re-INVITE(%ssec) between 2.1 and 4 sec.',
   'NG:' => \\'If UAC receives 491 response to a re-INVITE(and UAC is the owner of the CALL-ID), UAC SHOULD send another re-INVITE(%ssec) between 2.1 and 4 sec.',
   'RT:' => "warning", 
   'EX:' => \q{FFop('<=>',FV('TS',@_)-FVib('recv',-1,'','TS','RQ.Request-Line.method','INVITE'),[2.1,4],@_)}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-REINVITE_0-2','CA:' => 'Timer',
   'OK:' => \\'If UAC receives 491 response to a re-INVITE(and UAC is not the owner of the CALL-ID), UAC SHOULD send another re-INVITE(%ssec) between 0 and 2 sec.',
   'NG:' => \\'If UAC receives 491 response to a re-INVITE(and UAC is not the owner of the CALL-ID), UAC SHOULD send another re-INVITE(%ssec) between 0 and 2 sec.',
   'RT:' => "warning", 
   'EX:' => \q{FFop('<=>',FV('TS',@_)-FVib('recv',-1,'','TS','RQ.Request-Line.method','INVITE'),[0,2],@_)}},

# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RETRANS-REGISTER_0-30','CA:' => 'Timer',
   'OK:' => \\'UAC MUST send update REGISTER(%ssec) between 0 and 30 sec.',
   'NG:' => \\'UAC MUST send update REGISTER(%ssec) between 0 and 30 sec.',
#   'EX:' => \q{FFop('<=>',FV('TS',@_)-FVib('recv',-1,'','TS','RQ.Request-Line.method','REGISTER'),[0,30+$CNT_CONF{'TIMER-MAGIN'}],@_)}},
   'EX:' => \q{FFop('<=>',FV('TS',@_)-FVib('recv',-1,'','TS','RQ.Request-Line.method','REGISTER'),[0,30],@_)}},

# CANCEL send by PX
 {'TY:'=>'RULESET', 'ID:'=>'ES.CANCEL.PX.BETWEEN-INVITE', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.CANCEL_TUA-URI',
        'E.VIA_TWOPX-CANCEL.BETWEEN-INVITE',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_CANCEL',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},




);
