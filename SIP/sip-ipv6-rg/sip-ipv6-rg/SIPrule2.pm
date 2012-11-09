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

# 
@SIPCommonRules2 =
(
 #=================================
 # 
 #=================================

 # 
 {'TY:'=>'DECODE', 'ID:'=>'D.REQUEST',
  'VA:'=>[('RQ.Request-Line.method', FVRequestMethod),('RQ.Request-Line.uri.txt', FVRequestUri),
	  ('RQ.Request-Line.version', FVRequestVersion)]},
 # 
 {'TY:'=>'DECODE', 'ID:'=>'D.STATUS',
  'VA:'=>[('RQ.Status-Line.reason', FVStatusReason),('RQ.Status-Line.code', FVStatusCode),
	  ('RQ.Status-Line.version', FVStatusVersion)]},
 # Call-ID
 {'TY:'=>'DECODE', 'ID:'=>'D.CALL-ID',
  'VA:'=>[('HD.Call-ID.val.call-id', 'ND::DLOG.CallID')]},
 # From URI
 {'TY:'=>'DECODE', 'ID:'=>'D.FROM-URI',
  'VA:'=>[('HD.From.val.ad.ad.txt', 'ND::RemoteAoRURI')]},
 # From URI
 {'TY:'=>'DECODE', 'ID:'=>'D.FROM-URI_STATUS',
  'VA:'=>[('HD.From.val.ad.ad.txt', 'ND::LocalAoRURI')]},
 # To URI
 {'TY:'=>'DECODE', 'ID:'=>'D.TO-URI',
  'VA:'=>[('HD.To.val.ad.ad.txt', 'ND::LocalAoRURI')]},
 # To URI
 {'TY:'=>'DECODE', 'ID:'=>'D.TO-URI_STATUS',
  'VA:'=>[('HD.To.val.ad.ad.txt', 'ND::RemoteAoRURI')]},
 # From tag
 {'TY:'=>'DECODE', 'ID:'=>'D.FROM-TAG',
  'VA:'=>[('HD.From.val.param.tag', 'ND::DLOG.RemoteTag')]},
 # To tag
 {'TY:'=>'DECODE', 'ID:'=>'D.TO-TAG',
  'VA:'=>[('HD.To.val.param.tag', 'ND::DLOG.RemoteTag')]},
 # Cseq
 {'TY:'=>'DECODE', 'ID:'=>'D.CSEQ',
  'VA:'=>[('HD.CSeq.val.csno', 'ND::DLOG.RemoteCSeqNum')]},
 # Via
 {'TY:'=>'DECODE', 'ID:'=>'D.VIA.BRANCH', 'MD:'=>'first',
  'VA:'=>[('HD.Via.val.via.param.branch=', CVA_TUA_CURRENT_BRANCH)]},
 # Via
 {'TY:'=>'DECODE', 'ID:'=>'D.VIA.BRANCH.append','MD:'=>'append',
  'VA:'=>[('HD.Via.val.via.param.branch=', CVA_TUA_BRANCH_HISTORY)]},
 # Contact
 {'TY:'=>'DECODE', 'ID:'=>'D.CONTACT.URI',
  'VA:'=>[('HD.Contact.val.contact.ad.ad.txt', 'ND:LocalPeer:RemoteContactURI')]},
 # SDP o= version
 {'TY:'=>'DECODE', 'ID:'=>'D.O-VERSION',
  'VA:'=>[(\q{FFGetIndexValSeparateDelimiter(\\\'BD.o=.txt',2,' ',@_)}, CVA_TUA_O_VERSION)]},
 # SDP m= Media Desctiption
 #
 {'TY:'=>'DECODE', 'ID:'=>'D.M-MEDIA-DESCRIPTION',
  'VA:'=>[(\q{{'a='=>FVs('BD.m=.val.attr.txt',@_),'m='=>FVs('BD.m=.val',@_)}}, CVA_TUA_M_MEDIA_DESCRIPTION)]},


 #=================================
 # 
 #=================================
 # REGISTER 

 {'TY:'=>'RULESET', 'ID:'=>'D.REGISTER.AutoResponse', 'MD:'=>SEQ, 
  'RR:'=>['D.VIA.BRANCH','D.VIA.BRANCH.append']},

 # JUDGEMENT
 {'TY:'=>'RULESET', 'ID:'=>'D.COMMON.FIELD.REQUEST', 'MD:'=>SEQ, 'OD:'=>LAST,
  'RR:'=>['D.FROM-URI','D.TO-URI','D.CALL-ID','D.FROM-TAG','D.CSEQ','D.VIA.BRANCH','D.VIA.BRANCH.append','D.O-VERSION']},

 # JUDGEMENT
 {'TY:'=>'RULESET', 'ID:'=>'D.COMMON.FIELD.REQUEST.RG', 'MD:'=>SEQ, 'OD:'=>LAST,
  'RR:'=>['D.CALL-ID','D.FROM-TAG','D.CSEQ','D.VIA.BRANCH','D.VIA.BRANCH.append']},

 # JUDGEMENT
 {'TY:'=>'RULESET', 'ID:'=>'D.COMMON.FIELD.STATUS', 'MD:'=>SEQ, 'OD:'=>LAST,
   'RR:'=>['D.FROM-URI_STATUS','D.TO-URI_STATUS','D.CALL-ID','D.TO-TAG','D.VIA.BRANCH','D.VIA.BRANCH.append','D.O-VERSION']},

 # %% STATUS %%	
 { 'TY:' => 'RULESET', 'ID:' => 'D.STATUS.PX', 
   'RR:' => ['D.STATUS']
 }, 

 # %% STATUS %%	
 { 'TY:' => 'RULESET', 'ID:' => 'D.STATUS.TM', 
   'RR:' => ['D.STATUS']
 }, 



 #=================================
 # 
 #=================================

##REQUEST LINE

 # %% R-URI:01 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REMOTE-URI', 'CA:' => 'Request',
   'OK:' => \\'Request-URI(%s) MUST equal remote target URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'Request-URI(%s) MUST equal remote target URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('RQ.Request-Line.uri',@_),NINF('LocalAoRURI','LocalPeer'),@_)} },

 # %% R-URI:06 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REQ-CONTACT-URI', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST equal that(%s) of Contact of corresponding dialog.', 
   'NG:' => \\'The Request-URI(%s) MUST equal that(%s) of Contact of corresponding dialog.', 
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',NINF('LocalContactURI','LocalPeer'),@_)}}, 

 # %% R-URI:08 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_RG-URI.RG', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST equal SIP or SIPS URI(%s) of registrar(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The Request-URI(%s) MUST equal SIP or SIPS URI(%s) of registrar(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('HostPort','name-strict',FV('RQ.Request-Line.uri.ad.hostport',@_),$CNT_RG_URI,@_)} },

 # %% R-URI:09 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REDIRECT-URI', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) SHOULD equal the URI(%s) of Contact header field(about 3xx response).',
   'NG:' => \\'The Request-URI(%s) SHOULD equal the URI(%s) of Contact header field(about 3xx response).', 
   'RT:' => "warning", 
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',$CVA_PUA_URI_REDIRECT,@_)}}, 

 # %% R-URI:09 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REDIRECT-URI2', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) SHOULD equal the URI(%s) of Contact header field(about 3xx response).',
   'NG:' => \\'The Request-URI(%s) SHOULD equal the URI(%s) of Contact header field(about 3xx response).',
   'RT:' => "warning", 
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',$CVA_PUA_URI_REDIRECT2,@_)}}, 

 # %% R-URI:10 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_FIRST-ROUTESET-URI.TWOPX', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST be the URI of first URI(%s) of the route set, because that does not contain the lr parameter.', 
   'NG:' => \\'The Request-URI(%s) MUST be the URI of first URI(%s) of the route set, because that does not contain the lr parameter.', 
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',NINF('DLOG.RouteSet#1'),@_)}}, 

 # %% R-URI:11 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REDIRECT-CONTACT-URI', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST equal that(%s) of Contact of corresponding dialog.', 
   'NG:' => \\'The Request-URI(%s) MUST equal that(%s) of Contact of corresponding dialog.', 
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',
		    "sip:$CNT_CONF{'PUA-USER'}\@$CNT_PUA_HOSTNAME_CONTACT_REDIRECT",@_)}}, 

 # %% R-URI:12 %%	transport parameter of Request-URI is default parameter($CVA_PUA_R_URI_TRAN)for O6-8
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI-TRANSPORT_VALID', 'CA:' => 'Request',
   'OK:' => \\'The transport parameter(%s) of Request-URI MUST equal the default parameter(%s).',
   'NG:' => \\'The transport parameter(%s) of Request-URI MUST equal the default parameter(%s).',
   'EX:' => \q{FFop('EQ',\\\'RQ.Request-Line.uri.ad.param.transport-param',$CVA_PUA_R_URI_TRAN,@_)}}, 

 # %% R-URI:13 %%	maddr parameter of Request-URI is default parameter($CVA_PUA_R_URI_MADDR)for O6-8
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI-MADDR_VALID', 'CA:' => 'Request',
   'OK:' => \\'The maddr parameter(%s) of Request-URI MUST equal the default parameter(%s).',
   'NG:' => \\'The maddr parameter(%s) of Request-URI MUST equal the default parameter(%s).',
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.ad.param.maddr-param',$CVA_PUA_R_URI_MADDR,@_)}}, 

 # %% R-URI:14 %%	user parameter of Request-URI is default parameter($CVA_PUA_R_URI_USER)for O6-8
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI-USER_VALID', 'CA:' => 'Request',
   'OK:' => \\'The user parameter(%s) of Request-URI MUST equal the default parameter(%s).',
   'NG:' => \\'The user parameter(%s) of Request-URI MUST equal the default parameter(%s).',
   'EX:' => \q{FFop('EQ',\\\'RQ.Request-Line.uri.ad.param.user-param',$CVA_PUA_R_URI_USER,@_)}}, 

 # %% R-URI:16 %%	unknown parameter of Request-URI is default parameter($CVA_PUA_R_URI_UNKNOWN)for O6-8
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI-UNKNOWN_VALID', 'CA:' => 'Request',
   'OK:' => \\'The unknwon parameter of Request-URI MUST equal the default parameter(%s).',
   'NG:' => \\'The unknown parameter of Request-URI MUST equal the default parameter(%s).',
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.ad.param.other-param',$CVA_PUA_R_URI_UNKNOWN,@_)}}, 

 # %% R-URI:18 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REMOTE-URI_NOCASH-RD', 'CA:' => 'Request',
   'OK:' => \\'Request-URI(%s) MUST equal default remote-uri(%s) (for example, redirect URI is NG).', 
   'NG:' => \\'Request-URI(%s) MUST equal default remote-uri(%s) (for example, redirect URI is NG).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','very-strict',FV('RQ.Request-Line.uri',@_),$CVA_PUA_URI,@_)} },

### HEADER ###


 # %% Authorization:06 %%	nonce
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-NONCE.REQ-NONCE', 'CA:' => 'Authorization',
   'OK:' => \\'The nonce parameter(%s) in an Authorization header field MUST equal that of WWW-Authenticate header field(%s), which Tester has sent.', 
   'NG:' => \\'The nonce parameter(%s) in an Authorization header field MUST equal that of WWW-Authenticate header field(%s), which Tester has sent.', 
   'EX:' =>\q{FFop('eq',\\\'HD.Authorization.val.digest.nonce',$CNT_AUTH_NONCE,@_)}},

  # %% Authorization:08 %%	realm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-REALM.REQ-REALM', 'CA:' => 'Authorization',
   'OK:' => \\'The realm parameter(%s) in an Authorization header field MUST equal that(%s) of WWW-Authenticate header field, which Tester has sent.', 
   'NG:' => \\'The realm parameter(%s) in an Authorization header field MUST equal that(%s) of WWW-Authenticate header field, which Tester has sent.', 
   'EX:' =>\q{FFop('eq',\\\'HD.Authorization.val.digest.realm',$CNT_AUTH_REALM_RG,@_)}},

 # %% Authorization:15 %%	username
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTHORIZ-USERNAME_CONFIG', 'CA:' => 'Authorization',
   'OK:' => \\'The username(%s) parameter MUST be the same as the set-up username(%s) parameter.', 
   'NG:' => \\'The username(%s) parameter MUST be the same as the set-up username(%s) parameter.', 
   'EX:' => \q{FFop('eq',FV('HD.Authorization.val.digest.username',@_),NINF('AuthUserName'),@_)}},

 # %% CALLID:02 %%	Call-ID
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CALLID_VALID', 'CA:' => 'Call-ID',
   'OK:' => \\'The Call-ID(%s) header field of the response MUST equal the Call-ID(%s) header field of the request(case-sensitive and are simply compared byte-by-byte).', 
   'NG:' => \\'The Call-ID(%s) header field of the response MUST equal the Call-ID(%s) header field of the request(case-sensitive and are simply compared byte-by-byte).', 
   'EX:' => \q{FFop('eq',\\\'HD.Call-ID.val.call-id',NINF('DLOG.CallID'),@_)} },


 # %% CALLID:04 %%	Call-ID
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CALLID_VALID_SHOULD', 'CA:' => 'Call-ID',
   'OK:' => \\'The Call-ID(%s) header SHOULD equal the Call-ID(%s) header of the first Request.', 
   'NG:' => \\'The Call-ID(%s) header SHOULD equal the Call-ID(%s) header of the first Request.', 
   'RT:' => "warning", 
   'EX:' => \q{FFop('eq',\\\'HD.Call-ID.val.call-id',NINF('DLOG.CallID'),@_)} },

 # %% CALLID:05 %%	Call-ID
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CALLID_NOTEQUAUL_BEFORE', 'CA:' => 'Call-ID',
   'OK:' => \\'The Call-ID(%s) header field MUST NOT equal the Call-ID(%s) header field of before SIP message.', 
   'NG:' => \\'The Call-ID(%s) header field MUST NOT equal the Call-ID(%s) header field of before SIP message.', 
   'EX:' => \q{FFop('ne',\\\'HD.Call-ID.val.call-id',NINF('DLOG.CallID'),@_)} },

 # %% CONTACT:02 %%	
 # DisplayName
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT_QUOTE', 'CA:' => 'Contact',
   'OK:' => "The URI MUST be enclosed in angle brackets (< and >) if a comma, question mark or semicolon is contained.", 
   'NG:' => "The URI MUST be enclosed in angle brackets (< and >) if a comma, question mark or semicolon is contained.", 
   'PR:' =>\'FFIsExistHeader("Contact",@_)',  ## 2006.7.31 sawada add ##
   'EX:' =>\q{FFIsMatchStr('^[^;?,]+$',\\\'HD.Contact.val.contact.ad.txt','','',@_) || 
		 FFIsMatchStr(FV('HD.Contact.val.contact.ad.disp',@_)?$PtDisplayName . '<.+>$':'^<.+>$',\\\'HD.Contact.val.contact.ad.txt','','',@_)}},


 # %% CONTACT:06 %%	
 #     
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-URI_REMOTE-CONTACT-URI', 'CA:' => 'Contact',
   'OK:' => \\'The Contact Value(%s) MUST be equivalent to that(%s) of default remote Contact, as the SIP-URI or SIPS-URI.', 
   'NG:' => \\'The Contact Value(%s) MUST be equivalent to that(%s) of default remote Contact, as the SIP-URI or SIPS-URI(different port from set-up is not acceptable, and omission of userinfo part is not also acceptable).', 
   'PR:' =>\'FFIsExistHeader("Contact",@_)',  ## 2006.7.31 sawada add ##
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','ignore-userinfo',FV('HD.Contact.val.contact.ad',@_),NINF('LocalContactURI','RemotePeer'),@_)} },

 # %% CONTACT:07 %%	header component at the end of Contact URI equals the default value($CVA_TUA_CONTACT_HEADER) for Tp19-2-1(header component escape)
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-HEADER_VALID', 'CA:' => 'Contact',
   'OK:' => \\'The header component(%s) at the end of Contact MUST equal the default value(%s).',
   'NG:' => \\'The header component(%s) at the end of Contact MUST equal the default value(%s).',
   'PR:' =>\'FFIsExistHeader("Contact",@_)',  ## 2006.7.31 sawada add ##
   'EX:' => \q{FFop('EQ',\\\'HD.Contact.val.contact.ad.ad.header','?' . $CVA_TUA_CONTACT_HEADER,@_)}},


 # %% CSEQ:11 %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT', 'CA:' => 'CSeq',
   'OK:' => \\'CSeq sequence number(%s) MUST be the value incremented by one(%s) from that of the previous request sent by NUT, if any.', 
   'NG:' => \\'CSeq sequence number(%s) MUST be the value incremented by one(%s) from that of the previous request sent by NUT, if any.', 
   'PR:'=>\q{NINF('DLOG.RemoteCSeqNum') ne ''},
   'EX:' => \q{FFop('eq',\\\'HD.CSeq.val.csno',NINF('DLOG.RemoteCSeqNum')+1,@_)}}, 

 # %% CSEQ:12 %%	
### modified by Horisawa (2006.1.16)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.CSEQ-SEQNO_SEND-SEQNO',
 'CA:'=>'CSeq',
 'OK:'=>\\'The CSeq header field(%s) of the response MUST equal the CSeq field(%s) of the request.', 
 'NG:'=>\\'The CSeq header field(%s) of the response MUST equal the CSeq field(%s) of the request.', 
# 'EX:' =>\q{FFop('eq',\\\'HD.CSeq.val.csno',NINF('DLOG.LocalCSeqNum'),@_)}},
 'EX:'=>\q{FFop('eq',\\\'HD.CSeq.val.csno',
		FVib('send','','','HD.CSeq.val.csno','RQ.Request-Line.method',FV('HD.CSeq.val.method','','LAST')),@_)}
},

 # %% FROM:02 %%	From-URI
 #0128tuika     
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_REMOTE-URI', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the remote URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),NINF('LocalAoRURI','RemotePeer'),@_)} },


 # %% FROM:05 %%	From-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_REMOTE-TAG', 'CA:' => 'From',
   'OK:' => \\'The From-tag(%s) in the message MUST equal the remote tag(%s).', 
   'NG:' => \\'The From-tag(%s) in the message MUST equal the remote tag(%s).', 
   'EX:' =>\q{FFop('EQ',FV('HD.From.val.param.tag',@_),NINF('DLOG.RemoteTag'),@_)}},

 # %% FROM:08 %%	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_LOCAL-URI', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),NINF('LocalAoRURI','LocalPeer'),@_)} },

 # %% FROM:09 %%	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_REDIRECT-URI', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST equal the redirect URI(%s).', 
   'NG:' => \\'The URI(%s) in the From field MUST equal the redirect URI(%s).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.From.val.ad',@_),$CVA_PUA_URI_REDIRECT,@_)} },

 # %% FROM:10 %%	From-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_LOCAL-TAG', 'CA:' => 'From',
   'OK:' => \\'The From-tag(%s) MUST equal the local tag(%s).', 
   'NG:' => \\'The From-tag(%s) MUST equal the local tag(%s).', 
   'EX:' =>\q{FFop('EQ',FV('HD.From.val.param.tag',@_),FVib('send','','','HD.From.val.param.tag'),@_)}},

# %% FROM: %%	From-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_LOCAL-TAG-RG1-1-6', 'CA:' => 'From',
   'OK:' => \\'The From-tag(%s) MUST equal the local tag(%s).', 
   'NG:' => \\'The From-tag(%s) MUST equal the local tag(%s).', 
   'EX:' =>\q{FFop('EQ',FV('HD.From.val.param.tag',@_),FVibx(1,'send','','','HD.From.val.param.tag'),@_)}},

 # %% PROXY-AUTH:02 %%	Proxy-Authorization
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH.HEADER_MUSTNOT-CONCAT', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The Proxy-Authorization header field MUST NOT be combined into a single header field row.", 
   'NG:' => "The Proxy-Authorization header field MUST NOT be combined into a single header field row.", 
   'PR:' => \'FFIsExistHeader("Proxy-Authorization",@_)',
   'EX:' => sub{ my(%seen); return !(grep{$seen{($_->{id}eq'AuthParam'?$_->{name}:$_->{id})}++} 
                 @{FVm('HD.Proxy-Authorization.val.digest','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_)});}},

 # %% PROXY-AUTH:03 %%	Digest
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH.DIGEST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The Proxy-Authorization header field MUST use the \"Digest\" authentication mechanism.", 
   'NG:' => "The Proxy-Authorization header field MUST use the \"Digest\" authentication mechanism.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_)}},

 # %% PROXY-AUTH:04 %%	nc
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-NC.EXIST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The Proxy-Authorization header field MUST include the nc parameter(without the quotation marks).", 
   'NG:' => "The Proxy-Authorization header field MUST include the nc parameter(without the quotation marks).", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.nc','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_)}},

 # %% PROXY-AUTH:05 %%	nonce
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-NONCE.EXIST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The Proxy-Authorization header field MUST include the nonce parameter.", 
   'NG:' => "The Proxy-Authorization header field MUST include the nonce parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.nonce','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_)}},

 # %% PROXY-AUTH:06 %%	nonce
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-NONCE.REQ-NONCE', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The nonce parameter(%s) in the Proxy-Authorization header field MUST equal that(%s) of Proxy-Authenticate header field, which Tester has sent.', 
   'NG:' => \\'The nonce parameter(%s) in the Proxy-Authorization header field MUST equal that(%s) of Proxy-Authenticate header field, which Tester has sent.', 
   'EX:' =>\q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.nonce','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_),
		  $CNT_AUTH_NONCE,@_)}},

 # %% PROXY-AUTH:07 %%	realm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-REALM.EXIST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The Proxy-Authorization header field MUST include the realm parameter.", 
   'NG:' => "The Proxy-Authorization header field MUST include the realm parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.realm','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_)}},
 
 # %% PROXY-AUTH:08 %%	realm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-REALM.REQ-REALM', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The realm parameter(%s) in a Proxy-Authorization header field MUST equal that(%s) of Proxy-Authenticate header field, which Tester has sent.', 
   'NG:' => \\'The realm parameter(%s) in a Proxy-Authorization header field MUST equal that(%s) of Proxy-Authenticate header field, which Tester has sent.', 
   'EX:' =>\q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.realm','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_),
		  NINF('AuthRealm'),@_)}},

 # %% PROXY-AUTH:09 %%	response
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-RESPONSE.EXIST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The Proxy-Authorization header field MUST include the response parameter.", 
   'NG:' => "The Proxy-Authorization header field MUST include the response parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.response','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_)}},

 # %% PROXY-AUTH:10 %%	response
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-RESPONSE.CALCULATE', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The response parameter(%s) in the Proxy-Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/qop=auth)', 
   'NG:' => \\'The response parameter(%s) in the Proxy-Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/qop=auth)', 
   'EX:' =>\q{FFop('EQ',FVm('HD.Proxy-Authorization.val.digest.response','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_),
                      OpCalcAuthorizationResponse2('Proxy-Authorization',FV('RQ.Request-Line.method',@_) eq 'ACK'?'INVITE':FV('RQ.Request-Line.method',@_),'HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),'auth',@_),@_)}},

 # %% PROXY-AUTH:10b %%	response
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-RESPONSE-NOQOP.CALCULATE', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The response parameter(%s) in the Proxy-Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/no qop)', 
   'NG:' => \\'The response parameter(%s) in the Proxy-Authorization header field MUST be equivalent to the value(%s) calculated.(MD5/no qop)', 
   'EX:' =>\q{FFop('EQ',FVm('HD.Proxy-Authorization.val.digest.response','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_),
                      OpCalcAuthorizationResponse2('Proxy-Authorization',FV('RQ.Request-Line.method',@_) eq 'ACK'?'INVITE':FV('RQ.Request-Line.method',@_),'HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),'noauth',@_),@_)}},

 # %% PROXY-AUTH:11 %%	uri
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-URI.EXIST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The Proxy-Authorization header field MUST include the uri parameter.", 
   'NG:' => "The Proxy-Authorization header field MUST include the uri parameter.", 
   'EX:' => \q{FFIsMatchStr('uri\s*=',FVm('HD.Proxy-Authorization.val.txt','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_),'','',@_)}},

 # %% PROXY-AUTH:12 %%	uri
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-URI.DQUOT', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The uri(%s) MUST be enclosed in double quotation marks.', 
   'NG:' => \\'The uri(%s) MUST be enclosed in double quotation marks.', 
   'EX:' => \q{FFIsMatchStr('uri\s*=\s*(\".*?\")',FVm('HD.Proxy-Authorization.val.txt','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_),'','',@_)}},

 # %% PROXY-AUTH:13 %%	uri
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-URI_R-URI', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The uri(%s) MUST equal the Request-URI(%s).', 
   'NG:' => \\'The uri(%s) MUST equal the Request-URI(%s).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','strict-without-port',
		FFStripDQuot(FVm('HD.Proxy-Authorization.val.digest.uri','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_)),
		FV('RQ.Request-Line.uri',@_),@_)} },

 # %% PROXY-AUTH:14 %%	username
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-USERNAME.EXIST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The Proxy-Authorization header field MUST include the username parameter.", 
   'NG:' => "The Proxy-Authorization header field MUST include the username parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.username','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_)}},

 # %% PROXY-AUTH:15 %%	username
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-USERNAME_CONFIG', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The username(%s) parameter MUST be the same as the set-up username(%s) parameter.', 
   'NG:' => \\'The username(%s) parameter MUST be the same as the set-up username(%s) parameter.', 
   'EX:' => \q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.username','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_),
                         NINF('AuthUserName'),@_)}},

 # %% PROXY-AUTH:17 %%	username
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-USERNAME_CONFIG-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The username(%s) parameter of the 2nd Proxy-Authorization MUST be the same as the set-up username(%s) parameter.', 
   'NG:' => \\'The username(%s) parameter of the 2nd Proxy-Authorization MUST be the same as the set-up username(%s) parameter.', 
   'EX:' => \q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.username','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_), NINF('AuthUserName'),@_)}},

 # %% PROXY-AUTH:19 %%	cnonce
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-CNONCE.EXIST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The Proxy-Authorization header field MUST include the cnonce parameter.", 
   'NG:' => "The Proxy-Authorization header field MUST include the cnonce parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.cnonce','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_)}},


 # %% PROXY-AUTH:a1 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH.DIGEST-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The 2nd Proxy-Authorization header field MUST use the \"Digest\" authentication mechanism.", 
   'NG:' => "The 2nd Proxy-Authorization header field MUST use the \"Digest\" authentication mechanism.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_)}},

 # %% PROXY-AUTH:a2 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-NC.EXIST-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The 2nd Proxy-Authorization header field MUST include the nc parameter(without the quotation marks).", 
   'NG:' => "The 2nd Proxy-Authorization header field MUST include the nc parameter(without the quotation marks).", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.nc','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_)}},
 # %% PROXY-AUTH:a3 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-NONCE.EXIST-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The 2nd Proxy-Authorization header field MUST include the nonce parameter.", 
   'NG:' => "The 2nd Proxy-Authorization header field MUST include the nonce parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.nonce','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_)}},

 # %% PROXY-AUTH:a4 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-NONCE.REQ-NONCE-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The nonce parameter(%s) in the 2nd Proxy-Authorization header field MUST equal that(%s) of Proxy-Authenticate header field, which Tester has sent.', 
   'NG:' => \\'The nonce parameter(%s) in the 2nd Proxy-Authorization header field MUST equal that(%s) of Proxy-Authenticate header field, which Tester has sent.', 
   'EX:' =>\q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.nonce','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_),
                  $CNT_AUTH_NONCE2,@_)}},

 # %% PROXY-AUTH:a5 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-REALM.EXIST-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The 2nd Proxy-Authorization header field includes the realm parameter.", 
   'NG:' => "The 2nd Proxy-Authorization header field must include the realm parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.realm','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_)}},

 
 # %% PROXY-AUTH:a6 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-REALM.REQ-REALM-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The realm parameter(%s) in the 2nd Proxy-Authorization header field equals that(%s) of Proxy-Authenticate header field, which Tester has sent.', 
   'NG:' => \\'The realm parameter(%s) in the 2nd Proxy-Authorization header field must equal that(%s) of Proxy-Authenticate header field, which Tester has sent.', 
   'EX:' =>\q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.realm','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_), NINF('AuthRealm','PX2'),@_)}},


 # %% PROXY-AUTH:a7 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-RESPONSE.EXIST-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The 2nd Proxy-Authorization header field MUST include the response parameter.", 
   'NG:' => "The 2nd Proxy-Authorization header field MUST include the response parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.response','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_)}},


 # %% PROXY-AUTH:a8 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-RESPONSE.CALCULATE-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The response parameter(%s) in the 2nd Proxy-Authorization header field MUST be equivalent to the value(%s) calculated from nonce and realm.', 
   'NG:' => \\'The response parameter(%s) in the 2nd Proxy-Authorization header field MUST be equivalent to the value(%s) calculated from nonce and realm.', 
   'EX:' =>\q{FFop('EQ',FVm('HD.Proxy-Authorization.val.digest.response','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_),
                      OpCalcAuthorizationResponse2('Proxy-Authorization',FV('RQ.Request-Line.method',@_) eq 'ACK'?'INVITE':FV('RQ.Request-Line.method',@_),'HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),'auth',@_),@_)}},

 # %% PROXY-AUTH:a9 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-URI.EXIST-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The 2nd Proxy-Authorization header field MUST include the uri parameter.", 
   'NG:' => "The 2nd Proxy-Authorization header field MUST include the uri parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.uri','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_)}},

 # %% PROXY-AUTH:a10 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-URI.DQUOT-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The uri(%s) in the 2nd Proxy-Authorization header field MUST be enclosed in double quotation marks.', 
   'NG:' => \\'The uri(%s) in the 2nd Proxy-Authorization header field MUST be enclosed in double quotation marks.', 
   'EX:' => \q{FFIsMatchStr('^".*"$',FVm('HD.Proxy-Authorization.val.digest.uri','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_),'','',@_)}},

 # %% PROXY-AUTH:a11%%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-URI_R-URI-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The uri(%s) in the 2nd Proxy-Authorization header field MUST equal Request-URI(%s).', 
   'OK:' => \\'The uri(%s) in the 2nd Proxy-Authorization header field MUST equal Request-URI(%s).', 
#   'EX:' => \q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.uri','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_),
#		    ('"' . FV('RQ.Request-Line.uri.txt',@_) . '"'),@_)}},
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','strict-without-port',
		FFStripDQuot(FVm('HD.Proxy-Authorization.val.digest.uri','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_)),
		FV('RQ.Request-Line.uri',@_),@_)} },

 # %% PROXY-AUTH:a12 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-USERNAME.EXIST-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The 2nd Proxy-Authorization header field MUST include the usrname parameter.", 
   'NG:' => "The 2nd Proxy-Authorization header field MUST include the usrname parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.username','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_)}},

 # %% PROXY-AUTH:a13 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-qop.Auth-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The qop(%s) parameter of the 2nd Proxy-Authorization must be auth(without the quotation marks) when received qop parameter is \"auth\".', 
   'NG:' => \\'The qop(%s) parameter of the 2nd Proxy-Authorization must be auth(without the quotation marks) when received qop parameter is \"auth\".', 
   'EX:' =>\q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.qop','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_),
		  'auth',@_)}},

 # %% PROXY-AUTH:a14 %%	PX2:cnonce
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-CNONCE.EXIST-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => "The 2nd Proxy-Authorization header field MUST include the cnonce parameter.", 
   'NG:' => "The 2nd Proxy-Authorization header field MUST include the cnonce parameter.", 
   'EX:' =>\q{FVm('HD.Proxy-Authorization.val.digest.cnonce','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm','PX2'),@_)}},


 ## For o1-1
 # %% PROXY-AUTH:a15 %%	Proxy2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH.NOEXIST-PX2', 'CA:' => 'Proxy-Authorization',
   'OK:' => "MUST NOT include the credential for 2nd Proxy", 
   'NG:' => "MUST NOT include the credential for 2nd Proxy", 
   'EX:' =>\q{!grep {$_ eq NINF('AuthRealm','PX2')} @{FVs('HD.Proxy-Authorization.val.digest.realm',@_)}} },


 # %% AUTHENTICATION-INFO:01 %%	nonce 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.AUTH-NONCE==AUTH-INFO-NEXTNONCE', 'CA:' => 'Authorization',
   'OK:' => \\'The nonce(%s) in the Authorization header field MUST equal nextnonce(%s) of Authentication-Info header field.', 
   'NG:' => \\'The nonce(%s) in the Authorization header field MUST equal nextnonce(%s) of Authentication-Info header field.', 
   'EX:' =>\q{FFop('eq',\\\'HD.Authorization.val.digest.nonce',$CNT_AUTH_NONCE,@_)}},

 # %% AUTHENTICATION-INFO:02 %%	nonce 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-NONCE==AUTH-INFO-NEXTNONCE', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The nonce(%s) in the Proxy-Authorization header field MUST equal nextnonce(%s) of Authentication-Info header field.', 
   'NG:' => \\'The nonce(%s) in the Proxy-Authorization header field MUST equal nextnonce(%s) of Authentication-Info header field.', 
   'EX:' =>\q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.nonce','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_),
		  $CNT_AUTH_NONCE,@_)}},

 # %% AUTHENTICATION-INFO:04 %%	nc 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH-NC==00000001', 'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The nc(%s) in a Proxy-Authorization header field MUST equal 00000001(without the quotation marks).', 
   'NG:' => \\'The nc(%s) in a Proxy-Authorization header field MUST equal 00000001(without the quotation marks).', 
   'EX:' =>\q{FFop('eq',FVm('HD.Proxy-Authorization.val.digest.nc','HD.Proxy-Authorization.val.digest.realm',NINF('AuthRealm'),@_),
		  "00000001",@_)}},

 # %% RECORD-ROUTE:01 %%	Record-Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RE-ROUTE_ROUTESET.ONEPX', 'CA:' => 'Record-Route',
   'OK:' => \\'The Record-Route header field(%s) MUST equal the route set(%s) of the Tester.', 
   'NG:' => \\'The Record-Route header field(%s) MUST equal the route set(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',FVs('HD.Record-Route.val.route.ad.ad.txt',@_),\@CNT_PUA_ONEPX_ROUTESET,@_)}},

 # %% RECORD-ROUTE:02 %%	Record-Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RE-ROUTE_ROUTESET_REVERSE.TWOPX', 'CA:' => 'Record-Route',
   'OK:' => \\'The Record-Route header field(%s) MUST be listed in a reverse sequential order to the route set(%s) of the Tester, and the value of them MUST equal.', 
   'NG:' => \\'The Record-Route header field(%s) MUST be listed in a reverse sequential order to the route set(%s) of the Tester, and the value of them MUST equal.', 
   'EX:' => \q{FFop('eq',FVs('HD.Record-Route.val.route.ad.ad.txt',@_),[reverse(@{NINF('DLOG.RouteSet#A')})],@_)}},

 # %% RECORD-ROUTE:03 %%	Record-Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RE-ROUTE_ROUTESET_REVERSE-REDIRECT.TWOPX', 'CA:' => 'Record-Route',
   'OK:' => \\'The Record-Route header field(%s) MUST be listed in a reverse sequential order to the route set(%s) of the Tester, and the value of them MUST equal.', 
   'NG:' => \\'The Record-Route header field(%s) MUST be listed in a reverse sequential order to the route set(%s) of the Tester, and the value of them MUST equal.', 
   'EX:' => \q{FFop('eq',FVs('HD.Record-Route.val.route.ad.ad.txt',@_),[reverse(@CNT_PUA_TWOPX_ROUTESET_REDIRECT)],@_)}},

 # %% REQUIRE:04 %%	Require
 # Tp8-5:Require include $CVA_EXTENSION.
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.REQUIRE_CVA_EXTENSION', 'CA:' => 'Require',
   'OK:' => \\'Require(%s) include extension(%s) of Target.', 
   'NG:' => \\'Require(%s) MUST include extension(%s) of Target.', 
   'EX:' => \q{FFop('eq',\\\'HD.Require.val',$CVA_EXTENSION,@_)}},

 # %% ROUTE:04 %%	Route[0]=@CNT_PUA_TWOPX_ROUTESET[0],ROUTE[1]=NINF('LocalContactURI') 
 # Route: XXXX, YYYY 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_ROUTESET2_CONTACT.TWOPX', 'CA:' => 'Route',
   'OK:' => "If first routeset parameter does not contain the lr parameter,the UAC add a Route header field containing the remainder of the route set values in order,including all parameters(expect of first URI),and then place the remote target URI into the Route header field as the last value.", 
   'NG:' => "If first routeset parameter does not contain the lr parameter,the UAC MUST add a Route header field containing the remainder of the route set values in order,including all parameters(expect of first URI),and then Must place the remote target URI into the Route header field as the last value.", 
   'EX:' =>\q{($tempVals=FVs('HD.Route.val.route.ad.ad.txt',@_)) && ($$tempVals[0] eq NINF('DLOG.RouteSet#0')) && ($$tempVals[1] eq NINF('LocalContactURI'))}},

 # %% ROUTE:05 %%	Route
 ##
 ##
 ##
{ 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_PX-URI', 'CA:' => 'Route',
   'OK:' => \\'The value(%s) of Route header field SHOULD equal the SIP-URI(%s) of the proxy server.', 
   'NG:' => \\'The value(%s) of Route header field SHOULD equal the SIP-URI(%s) of the proxy server.', 
   'PR:' => \q{FFIsExistHeader("Route",@_)},
   'RT:' => "warning", 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','loose',FV('HD.Route.val.route.ad.ad.txt',@_),
				"sip:$CNT_CONF{'PX1-HOSTNAME'}:$CNT_PX1_PORT;lr",@_)}},

 # %% ROUTE:06 %%	Route
 ##
 ##
 ##
{ 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_PX2-URI', 'CA:' => 'Route',
   'OK:' => \\'The value(%s) of Route header field MUST equal the SIP-URI(%s) of the proxy server.', 
   'NG:' => \\'The value(%s) of Route header field MUST equal the SIP-URI(%s) of the proxy server.', 
   'PR:' => \q{FFIsExistHeader("Route",@_)},
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','loose',FV('HD.Route.val.route.ad.ad.txt',@_),
               "sip:$CNT_CONF{'PX2-HOSTNAME'}:$CNT_PX2_PORT;lr",@_)}},

 # %% ROUTE:07 %%	Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_ROUTESET.ONEPX', 'CA:' => 'Route',
   'OK:' => \\'The Route header field(%s) MUST equal the route set(%s) of the Tester.', 
   'NG:' => \\'The Route header field(%s) MUST equal the route set(%s) of the Tester.', 
   'EX:' => \q{FFop('eq',FVs('HD.Route.val.route.ad.ad.txt',@_),\@CNT_PUA_ONEPX_ROUTESET,@_)}},

 # %% ROUTE:08 %%	Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_ROUTESET_REVERSE.TWOPX', 'CA:' => 'Route',
   'OK:' => \\'The Route header field(%s) MUST be listed in a reverse sequential order to the route set(%s) of the Tester, and the value of them MUST equal.', 
   'NG:' => \\'The Route header field(%s) MUST be listed in a reverse sequential order to the route set(%s) of the Tester, and the value of them MUST equal.', 
   'EX:' => \q{FFop('eq',FVs('HD.Route.val.route.ad.ad.txt',@_),[reverse(@{NINF('DLOG.RouteSet#A')})],@_)}},

 # %% ROUTE:08 %%	Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE-RR-PARAM_VALID.TWOPX', 'CA:' => 'Route',
   'OK:' => \\'The rr-param(%s) in Route header field MUST equal the rr-param(%s) that the Tester sent before.', 
   'NG:' => \\'The rr-param(%s) in Route header field MUST equal the rr-param(%s) that the Tester sent before.', 
   'EX:' => \q{FFop('eq',FVs('HD.Route.val.route.param',@_),[reverse(@CNT_PUA_TWOPX_RR_PARAM)],@_)}},

 # %% ROUTE:08 %%	Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_ROUTESET_REVERSE_REDIRECT.TWOPX', 'CA:' => 'Route',
   'OK:' => \\'The Route header field(%s) MUST be listed in a reverse sequential order to the route set(%s) of the Tester, and the value of them MUST equal.', 
   'NG:' => \\'The Route header field(%s) MUST be listed in a reverse sequential order to the route set(%s) of the Tester, and the value of them MUST equal.', 
   'EX:' => \q{FFop('eq',FVs('HD.Route.val.route.ad.ad.txt',@_),[reverse(@CNT_PUA_TWOPX_ROUTESET_REDIRECT)],@_)}},

 # %% TIMESTAMP:01 %%	TIMESTAMP
 # TIMESTAMP
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TIMESTAMP_SEND-TIMESTAMP', 'CA:' => 'Timestamp',
   'OK:' => \\'The Timestamp header field MUST exist, and the value($v2) of the response MUST equal or more than that of the request($v1).', 
   'NG:' => \\'The Timestamp header field MUST exist, and the value($v2) of the response MUST equal or more than that of the request($v1).', 
   'EX:' =>\q{FFop('==',$CVA_TIME_STAMP,FV('HD.Timestamp.val.timestamp',@_),@_) }},

 # %% TO:02 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LOCAL-URI', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.To.val.ad.ad.txt',@_),NINF('LocalAoRURI','LocalPeer'),@_)} },

 # %% TO:03 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_REDIRECT-URI', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field equals the redirect URI(%s).', 
   'NG:' => \\'The URI(%s) in the To field must equal the redirect URI(%s).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.To.val.ad',@_),$CVA_PUA_URI_REDIRECT,@_)} },

 # %% TO:05 %%	To-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_LOCAL-TAG', 'CA:' => 'To',
   'OK:' => \\'The To-tag(%s) MUST equal the local tag(%s).', 
   'NG:' => \\'The To-tag(%s) MUST equal the local tag(%s).', 
#   'EX:' =>\q{FFop('eq',FFGetMatchStr('tag=(.+)',\\\'HD.To.val.param',@_),NINF('DLOG.LocalTag'),@_)}},
   'EX:' =>\q{FFop('EQ',FV('HD.To.val.param.tag',@_),NINF('DLOG.LocalTag'),@_)}},

 # %% TO:08 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_REMOTE-URI', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.', 
#   'EX:' => \q{FFop('eq',\\\'HD.To.val.ad.ad.txt',NINF('LocalAoRURI','RemotePeer'),@_)}},   ## 2006.7.27 sawada del ##
   'EX:' => sub {  ## 2006.7.27 sawada add ##
       my($Param,$ToURI,$RemoteURI);
       $Param=FVSeparete('HD.To.val.txt','>|;','',@_[1]);
       $ToURI=FFGetMatchStr('(sip.*)',$Param,'','');
#       PrintVal($ToURI);
       $RemoteURI=NINF('LocalAoRURI','RemotePeer');
#       PrintVal($RemoteURI);
       FFop('eq',$ToURI,$RemoteURI,@_);
   }},   ####

 # %% TO:09 %%	To-tag
#
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_REMOTE-TAG', 'CA:' => 'To',
   'OK:' => \\'The To-tag(%s) MUST equal the remote tag(%s).', 
   'NG:' => \\'The To-tag(%s) MUST equal the remote tag(%s).', 
   'PR:' => \q{NINF('DLOG.RemoteTag') ne ''},
   'EX:' =>\q{FFop('EQ',FV('HD.To.val.param.tag',@_),NINF('DLOG.RemoteTag'),@_)}},


 # %% TO:13 %%	To-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_UA1-TAG', 'CA:' => 'To',
   'OK:' => \\'The To-tag(%s) MUST equal the To-tag(%s) from UA1.', 
   'NG:' => \\'The To-tag(%s) MUST equal the To-tag(%s) from UA1.', 
   'EX:' =>\q{FFop('EQ',FV('HD.To.val.param.tag',@_),$MY_UA1_TOTAG,@_)}},

 # %% TO:14 %%	To-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_UA11-TAG', 'CA:' => 'To',
   'OK:' => \\'The To-tag(%s) MUST equal the To-tag(%s) from UA11.', 
   'NG:' => \\'The To-tag(%s) MUST equal the To-tag(%s) from UA11.', 
   'EX:' =>\q{FFop('EQ',FV('HD.To.val.param.tag',@_),$MY_UA11_TOTAG,@_)}},

 # %% UNSUPPORTED:01 %%	
 # 
 # 
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.UNSUPPORTED-SEND_REQUIRE-NG', 'CA:' => 'Unsupported',
   'OK:' => "An Unsupported header field MUST exist, and default option-tag MUST be present ,which does not understand amongst those in the Require/Proxy-Require header field of the request.", 
   'NG:' => "An Unsupported header field MUST exist, and default option-tag MUST be present ,which does not understand amongst those in the Require/Proxy-Require header field of the request.", 
   'EX:' =>\q{FFIsMember([@CVA_UNSUPPORTED_LIST_P_REQUIRE],FVSeparete('HD.Unsupported.val','\s*,\s*',@_),'',@_)}},


 # %% UNSUPPORTED:02 %%	
 # 
 # 
 # UA-10-2-10
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.UNSUPPORTED-SEND_REQUIRE-NG2', 'CA:' => 'Unsupported',
   'OK:' => "An Unsupported header field MUST exist, and default option-tag MUST be present ,which does not understand amongst those in the Require header field of the request.", 
   'NG:' => "An Unsupported header field MUST exist, and default option-tag MUST be present ,which does not understand amongst those in the Require header field of the request.", 
   'EX:' =>\q{FFIsMember([@CVA_UNSUPPORTED_LIST_REQUIRE],FVSeparete('HD.Unsupported.val','\s*,\s*',@_),'',@_)}},


 # %% VIA:08 %%	
 # branch = $CVA_PUA_BRANCH_HISTORY
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
   'NG:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.', 
   'EX:' =>\q{FFop('EQ',FVs('HD.Via.val.via.param.branch=',@_),[$CVA_PUA_BRANCH_HISTORY],@_)}},

 # %% VIA:09 %%	
 # $CVA_PUA_BRANCH_HISTORY, $CVA_PX1_BRANCH_HISTORY
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
   'NG:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.', 
   'EX:' =>\q{FFop('EQ',FVs('HD.Via.val.via.param.branch=',@_),[$CVA_PX1_BRANCH_HISTORY,$CVA_PUA_BRANCH_HISTORY],@_)}},

 # %% VIA:10 %%	
 # $CVA_PUA_BRANCH_HISTORY, $CVA_PX1_BRANCH_HISTORY, $CVA_PX1_BRANCH_HISTORY
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
   'NG:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.', 
   'EX:' =>\q{FFop('EQ',FVs('HD.Via.val.via.param.branch=',@_),
                            [$CVA_PX1_BRANCH_HISTORY,$CVA_PX2_BRANCH_HISTORY,$CVA_PUA_BRANCH_HISTORY],@_)}},
    

 # %% VIA:11 %%	
 # $CVA_PX1_BRANCH_HISTORY
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX-CANCEL', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
   'NG:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.', 
   'EX:' =>\q{FFop('EQ',FVs('HD.Via.val.via.param.branch=',@_),[$CVA_PX1_BRANCH_HISTORY],@_)}},

 # %% VIA:12 %%	
 #     @CVA_PUA_BRANCH_ALL
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ALL', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) equals the Via branch(%s) which Tester has sent last time.',
   'NG:' => \\'The Via branch value(%s) must equal the Via branch(%s) which Tester has sent last time.', 
   'EX:' =>\q{FFop('EQ',FVs('HD.Via.val.via.param.branch=',@_),\@CVA_PUA_BRANCH_ALL,@_)}},

 # %% VIA:14 %%	Via
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-RECEIVED_EXIST', 'CA:' => 'Via',
   'PR:' => \q{!IsIPAddress(FV('HD.Via.val.via.sendby.host',@_))},
   'OK:' => \\'The First Via header includes received parameter, and that value(%s) equals IP address(%s) of the Tester.', 
   'NG:' => \\'The First Via header must include received parameter, and that value(%s) must equal IP address(%s) of the Tester.', 
   'EX:' => \q{FFCompareFullADDRESS(FVn('HD.Via.val.via.param.received=',0,@_),NINF('IPaddr'),@_)} }, 


 # %% VIA:15 %%	Via
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-RECEIVED_EXIST_PX', 'CA:' => 'Via',
   'PR:' => \q{!IsIPAddress(FV('HD.Via.val.via.sendby.host',@_))},
   'OK:' => \\'The First Via header MUST include received parameter(%s), and that value MUST equal IP address(%s) of the Proxy.', 
   'NG:' => \\'The First Via header MUST include received parameter(%s), and that value MUST equal IP address(%s) of the Proxy.', 
   'EX:' => \q{FFCompareFullADDRESS(FVn('HD.Via.val.via.param.received=',0,@_),NINF('IPaddr'),@_)} }, 

 # %% VIA:15b %%	Via
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-RECEIVED_EXIST_PX2', 'CA:' => 'Via',
   'PR:' => \q{!IsIPAddress(FV('HD.Via.val.via.sendby.host',@_))},
   'OK:' => \\'The First Via header MUST include received parameter(%s), and that value MUST equal IP address(%s) of the Proxy.', 
   'NG:' => \\'The First Via header MUST include received parameter(%s), and that value MUST equal IP address(%s) of the Proxy.', 
   'EX:' => \q{FFCompareFullADDRESS(FVn('HD.Via.val.via.param.received=',0,@_),NINF('IPaddr'),@_)} }, 

 # %% VIA:16 %%	Via
# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_NOPX_SEND_EQUAL', 'CA:' => 'Via',
   'OK:' => \\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).', 
   'NG:' => \\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).', 
   'EX:' => \q{OpViaMachLines(\@CNT_NOPX_SEND_VIAS,1,@_)} }, 

 # %% VIA:17 %%	Via
 # 1
# 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_ONEPX_SEND_EQUAL', 'CA:' => 'Via',
   'OK:' => \\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).', 
   'NG:' => \\'The Via header(%s) MUST equal that(%s) in the request(except received parameter of 1st Via).', 
   'EX:' => \q{OpViaMachLines(\@CNT_ONEPX_SEND_VIAS,2,@_)} }, 

 # %% VIA:18 %%	Via
# 
 # 1
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_TWOPX_SEND_EQUALS.VI', 'CA:' => 'Via',
   'OK:' => \\'The Via headers(%s) MUST equal those(%s) in the request(except received parameter of 1st Via).', 
   'NG:' => \\'The Via headers(%s) MUST equal those(%s) in the request(except received parameter of 1st Via).', 
   'EX:' => \q{OpViaMachLines(\@CNT_TWOPX_SEND_VIAS,3,@_)} }, 

 # %% VIA:19 %%	REDIRECT:Via
 # 
  { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_TWOPX_SEND_EQUALS-REDIRECT.VI', 'CA:' => 'Via',
   'OK:' => \\'The Via headers(%s) MUST equal those(%s) in the request(except received parameter of 1st Via).', 
   'NG:' => \\'The Via headers(%s) MUST equal those(%s) in the request(except received parameter of 1st Via).', 
   'EX:' => \q{OpViaMachLines(\@CNT_TWOPX_SEND_VIAS_REDIRECT,3,@_)} }, 

 # %% VIA:20 %%	Via
 # 1
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_TWOPX_SEND_EQUALS-CANCEL.VI', 'CA:' => 'Via',
   'OK:' => \\'The first Via header(%s) in CALNCEL MUST equal that(%s) in the request being cancelled(except received parameter).', 
   'NG:' => \\'The first Via header(%s) in CALNCEL MUST equal that(%s) in the request being cancelled(except received parameter).', 
   'EX:' => \q{OpViaMachLines(\@CNT_TWOPX_SEND_VIAS,1,@_)} }, 

 # %% VIA:22 %%	Via
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-URI_HOSTNAME', 'CA:' => 'Via',
   'OK:' => \\'The value of First Via sent-by(%s) MUST be equivalent to the HOSTNAME(%s).',
   'NG:' => \\'The value of First Via sent-by(%s) MUST be equivalent to the HOSTNAME(%s)(the form of IP address is acceptable, but different port from set-up is not acceptable).', 
   'EX:' => \q{FFCompareAddress('HostPort','loose',FV('HD.Via.val.via.sendby.txt',@_),NINF('HostPort','Target'),@_)} },


##BODY

 # %% SDP:04 %%	<addr>
 #*0107* 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.O-ADDR_TAG-ADDR', 'CA:' => 'o=',
   'OK:' => "The addr of line o in SDP body message MUST equal the address of Target UA.", 
   'NG:' => "The addr of line o in SDP body message MUST equal the address of Target UA.", 
   'EX:' =>\q{($v1=FFGetIndexValSeparateDelimiter(\\\'BD.o=.txt',5,' ',@_)) && 
               (FFCompareFullADDRESS($v1,NINF('IPaddr','UA11')) || $v1 eq $CNT_TUA_HOSTNAME)}}, 

 # %% SDP:10 %%	<connection-address>
 #*0107* 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.C-CONNECTADDR_TARGET', 'CA:' => 'c=',
   'OK:' => "The connection-address of c line in SDP body message MUST equal the address of Target UA(FQDN or IP address).", 
   'NG:' => "The connection-address of c line in SDP body message MUST equal the address of Target UA(FQDN or IP address).", 
   'EX:' =>\q{($v1=FFGetIndexValSeparateDelimiter(\\\'BD.c=.txt',2,' ',@_)) && 
               (FFCompareFullADDRESS($v1,NINF('IPaddr','UA11')) || $v1 eq $CNT_TUA_HOSTNAME)}},

 # %% SDP:16 %%	    - a=sendonly
 #  $CNT_CONF{'HOLD-MEDIA'}
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.A-SENDONLY', 'CA:' => 'a=',
   'OK:' => "The a line, which is \"a=sendonly\"(for HOLD), MUST be exist.", 
   'NG:' => "The a line, which is \"a=sendonly\"(for HOLD), MUST be exist.", 
   'EX:' => sub{ my(@mdec,$val);
                 $val=FVs('BD.m=.val.attr.txt',@_);push(@mdec,$val?JoinKeyValue("a=%s\r\n",$val,'txt'):'');
                 $val=FVs('BD.m=.val',@_);push(@mdec,$val?map($_->{txt},@{$val}):'');
                 return $mdec[$CNT_CONF{'HOLD-MEDIA'}]=~/sendonly/img;}},

 # %% SDP:17 %%	    - o= line <version> increment
 ## MUST DECODE SDP version
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.O-VERSION-INCREMENT', 'CA:' => 'o=',
   'OK:' => "The version of line o MUST be increasing.", 
   'NG:' => "The version of line o MUST be increasing.", 
   'PR:' => \q{$CVA_TUA_O_VERSION ne ''},
   'EX:' =>\q{grep {int($_) == $CVA_TUA_O_VERSION+1} @{FFGetIndexValsSeparateDelimiter(\\\'BD.o=.txt',2,' ',@_)}} }, 

 # %% SDP:19 %%	    - m= line
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.M-LINE_MEDIA-DESCRIPTION-CONTAIN', 'CA:' => 'm=',

   'OK:' => \\'The m line MUST include the same m lines(%s) as previous SDP(%s).', 
   'NG:' => \\'The m line MUST include the same m lines(%s) as previous SDP(%s).', 
   'EX:' => \q{FFop('>=',FVcount(FVs('BD.m=.val',@_)),FVcount($CVA_TUA_M_MEDIA_DESCRIPTION->{'m='}),@_)}},

 # %% SDP:20 %%	    - o= line <version> increment for O4-5-1
 # 
 ## MUST DECODE SDP version
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SDP.O-VERSION-INCREMENT_NOTSAME-FORMER', 'CA:' => 'o=',
   'OK:' => "The version of line o MUST be increasing if it is not the same as former SDP.", 
   'NG:' => "The version of line o MUST be increasing if it is not the same as former SDP.", 
   'PR:' => sub{my($body);
		$body=FVib('recv','','','BD.txt','RQ.Request-Line.method','INVITE') ||
		      FVib('recv','','','BD.txt','RQ.Status-Line.code',200,'HD.CSeq.val.method','INVITE');
		return(!$body || $body ne FV('BD.txt',@_));},
   'EX:' => \q{grep {int($_) == $CVA_TUA_O_VERSION+1} @{FFGetIndexValsSeparateDelimiter(\\\'BD.o=.txt',2,' ',@_)}} }, 


#Equal $PORT_DEFAULT_SIGNAL(config)
# %% PORT:01  SIP
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.PORT-SIGNAL_DEFAULTS', 'CA:' => 'UDP',

## 2006.1.25 sawada change Category name ##
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PORT-SIGNAL_DEFAULTS', 'CA:' => $SIP_PL_TRNS,
   'OK:' => \\'The SIP message(%s) MUST be sent to the default port(%s).', 
   'NG:' => \\'The SIP message(%s) MUST be sent to the default port(%s).', 
   'PR:' => \q($SIP_PL_TRNS eq "UDP"), ## 2006.2.6 sawada add ##
   'EX:' => \q{FFop('eq',FV('UDP.DestinationPort',@_),NINF('SIPPort'),@_)} }, 

# %% PORT:02 SIP
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PORT-SIGNAL_CHANGE', 'CA:' => 'UDP',
   'OK:' => \\'The destination port of the SIP message(%s) MUST equal the change port(%s).', 
   'NG:' => \\'The destination port of the SIP message(%s) MUST equal the change port(%s).', 
   'EX:' => \q{FFop('eq',FV('UDP.DestinationPort',@_),$CNT_PX1_PORT,@_)} }, 

# %% PORT:03 RTP
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PORT-RTP_DEFAULTS', 'CA:' => 'RTP',
   'OK:' => \\'The RTP(%s) send default port(%s).', 
   'NG:' => \\'The RTP(%s) MUST send default port(%s).', 
   'EX:' => \q{FFop('eq',FV('RTP.UDP.DestinationPort',@_),NINF('RTPPort'),@_)} }, 

# %% PORT:04 RTP
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PORT-RTP_CHANGE', 'CA:' => 'RTP',
   'OK:' => \\'The RTP(%s) send change port(%s).', 
   'NG:' => \\'The RTP(%s) MUST send change port(%s).', 
   'EX:' => \q{FFop('eq',FV('RTP.UDP.DestinationPort',@_),NINF('RTPPort'),@_)} }, 

 # specially O6-3
 # %% RTP:01 %% 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RTP-PORT', 'CA:' => 'RTP',
   'OK:' => \\'That Destination port(%s) MUST be set up by SDP(%s).', 
   'NG:' => \\'That Destination port(%s) MUST be set up by SDP(%s).', 
   'EX:' => \q{FFop('eq',RTPFVib('recv','','','Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.DestinationPort'),NINF('RTPPort'),@_)}},



 #=================================
 # 
 #=================================

 # 

 # %% ReqMesg %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ReqMesg', 
   'RR:' => [
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
            ]
 },  

 # %% ResMesg %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ResMesg', 
   'RR:' => [
             'SSet.ALLMesg',
             'S.FROM-URI_LOCAL-URI',
             'S.FROM-TAG_LOCAL-TAG',
             'S.TO-URI_REMOTE-URI',
             'S.CALLID_VALID',
             'S.CSEQ-SEQNO_SEND-SEQNO',
            ]
 }, 


 # %% SDP-ANS %%	SDP(Answer)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.SDP-ANS', 
   'RR:' => [
              'SSet.SDP',
              'S.SDP.M-LINE_SEND-CONTAIN',
            ]
 }, 

 # %% URICompMsg %%	URI
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.URICompMsg', 
   'RR:' => [
              'S.R-URI_REMOTE-URI',
              'S.FROM-URI_REMOTE-URI',
              'S.TO-URI_LOCAL-URI',
              'S.CONTACT-URI_REMOTE-CONTACT-URI',
            ]
 }, 

 # %% URICompMsg %%	URI
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.URICompMsgRG', 
   'RR:' => [
              'S.R-URI_RG-URI.RG',
              'S.FROM-URI_REMOTE-URI',
              'S.TO-URI_REMOTE-URI',
            ]
 }, 


 # %% INVITE %%	INVITE
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.INVITE', 
   'RR:' => [
              'SSet.ReqMesg',
              'SSet.URICompMsg',
              'S.R-URI_TO-URI',
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CSEQ-METHOD_INVITE',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              'SSet.SDP'
            ]
 }, 

 # %% ACK %%	ACK
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK', 
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
	      'S.CSEQ-SEQNO_REQ-SEQNO'
           ]
 }, 

 # %% ACK-2xx %%	ACK(2xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK-2xx', 
   'RR:' => [
              'S.R-URI_REQ-CONTACT-URI',
           ]
 }, 

 # %% ACK-Non2xx %%	ACK(2xx

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK-Non2xx', 
   'RR:' => [
              'S.R-URI_TO-URI',
              'S.R-URI_REQ-R-URI',
              'S.BODY_NOEXIST',
              'S.REQUIRE_NOEXIST',
              'S.P-REQUIRE_NOEXIST',
           ]
 }, 

 # %% DigestAuth.NOPX %%	Digest
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.DigestAuth.NOPX', 
   'RR:' => [
              'S.AUTHORIZ.DIGEST',
              'S.AUTHORIZ-NC.EXIST',
              'S.AUTHORIZ-NONCE.EXIST',
              'S.AUTHORIZ-NONCE.REQ-NONCE',
              'S.AUTHORIZ-REALM.EXIST',
              'S.AUTHORIZ-REALM.REQ-REALM',
              'S.AUTHORIZ-RESPONSE.EXIST',
              'S.AUTHORIZ-RESPONSE.CALCULATE',
              'S.AUTHORIZ-URI.EXIST',
              'S.AUTHORIZ-URI.DQUOT',
              'S.AUTHORIZ-CNONCE.EXIST',
              'S.AUTHORIZ-USERNAME.EXIST',
              'S.AUTHORIZ-USERNAME_CONFIG',
              'S.AUTHORIZ-qop.Auth',
              'S.AUTHORIZ.HEADER_MUSTNOT-CONCAT',
           ]
 }, 

 # %% DigestAuth.NOPX NOQOP %%	Digest
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.DigestNoQop.NOPX', 
   'RR:' => [
              'S.AUTHORIZ.DIGEST',
              'S.AUTHORIZ-NONCE.EXIST',
              'S.AUTHORIZ-NONCE.REQ-NONCE',
              'S.AUTHORIZ-REALM.EXIST',
              'S.AUTHORIZ-REALM.REQ-REALM',
              'S.AUTHORIZ-RESPONSE.EXIST',
               'S.AUTHORIZ-URI.EXIST',
              'S.AUTHORIZ-URI.DQUOT',
              'S.AUTHORIZ-USERNAME.EXIST',
              'S.AUTHORIZ-USERNAME_CONFIG',
              'S.AUTHORIZ.HEADER_MUSTNOT-CONCAT',
#              'S.AUTHORIZ-NC.EXIST',
#              'S.AUTHORIZ-CNONCE.EXIST',
#             'S.AUTHORIZ-qop.Auth',
#             'S.AUTHORIZ-RESPONSE.CALCULATE',
             'S.AUTHORIZ-RESPONSE-NOQOP.CALCULATE',

           ]
 }, 

 # %% DigestAuth.PX %%	Digest
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.DigestAuth.PX', 
   'RR:' => [
              'S.P-AUTH.DIGEST',
              'S.P-AUTH-NC.EXIST',
              'S.P-AUTH-NONCE.EXIST',
              'S.P-AUTH-NONCE.REQ-NONCE',
              'S.P-AUTH-REALM.EXIST',
              'S.P-AUTH-REALM.REQ-REALM',
              'S.P-AUTH-RESPONSE.EXIST',
              'S.P-AUTH-RESPONSE.CALCULATE',
              'S.P-AUTH-URI.EXIST',
              'S.P-AUTH-URI.DQUOT',
              'S.P-AUTH-CNONCE.EXIST',
              'S.P-AUTH-USERNAME.EXIST',
              'S.P-AUTH-USERNAME_CONFIG',
              'S.P-AUTH-qop.Auth',
              'S.P-AUTH.HEADER_MUSTNOT-CONCAT',
           ]
 }, 

 # %% DigestAuth.PX NoQop%%	Digest
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.DigestNoQop.PX', 
   'RR:' => [
              'S.P-AUTH.DIGEST',
              'S.P-AUTH-NONCE.EXIST',
              'S.P-AUTH-NONCE.REQ-NONCE',
              'S.P-AUTH-REALM.EXIST',
              'S.P-AUTH-REALM.REQ-REALM',
              'S.P-AUTH-RESPONSE.EXIST',
              'S.P-AUTH-URI.EXIST',
              'S.P-AUTH-URI.DQUOT',
              'S.P-AUTH-USERNAME.EXIST',
              'S.P-AUTH-USERNAME_CONFIG',
              'S.P-AUTH.HEADER_MUSTNOT-CONCAT',
#              'S.P-AUTH-NC.EXIST',
#              'S.P-AUTH-CNONCE.EXIST',
#              'S.P-AUTH-qop.Auth',
#              'S.P-AUTH-RESPONSE.CALCULATE',
              'S.P-AUTH-RESPONSE-NOQOP.CALCULATE',
           ]
 }, 

 # %% DigestAuth.PX %%	Digest
 { 'TY:' => 'RULESET', 'ID:' =>'SSet.DigestAuth_NO-INI-INVITE.PX',
   'RR:' => [
              'SSet.DigestAuth.PX', 
           ]
 }, 

 # %% DigestAuth-PX2.PX %%	Digest
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.DigestAuth-PX2.PX', 
   'RR:' => [
              'S.P-AUTH.DIGEST-PX2',
              'S.P-AUTH-NC.EXIST-PX2',
              'S.P-AUTH-NONCE.EXIST-PX2',
              'S.P-AUTH-NONCE.REQ-NONCE-PX2',
              'S.P-AUTH-REALM.EXIST-PX2',
              'S.P-AUTH-REALM.REQ-REALM-PX2',
              'S.P-AUTH-RESPONSE.EXIST-PX2',
              'S.P-AUTH-RESPONSE.CALCULATE-PX2',
              'S.P-AUTH-URI.EXIST-PX2',
              'S.P-AUTH-URI.DQUOT-PX2',
              'S.P-AUTH-CNONCE.EXIST-PX2',
              'S.P-AUTH-USERNAME.EXIST-PX2',
              'S.P-AUTH-USERNAME_CONFIG-PX2',
              'S.P-AUTH-qop.Auth-PX2',
           ]
 }, 

 # %% ACK-2xx.AUTH.NOPX %%	ACK(2xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK-2xx.AUTH.NOPX', 
   'RR:' => [
              'S.AUTHORIZ_EXIST.TM',
              'SSet.DigestAuth.NOPX',
           ]
 }, 


 # %% ACK-2xx.AUTH.PX %%	ACK(2xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK-2xx.AUTH.PX', 
   'RR:' => [
              'S.P-AUTH_EXIST.PX',
              'SSet.DigestAuth.PX',
           ]
 }, 

 # %% ACK-2xx.AUTH-PX2.PX %%	ACK(2xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.ACK-2xx.AUTH-PX2.PX', 
   'RR:' => [
              'S.P-AUTH_DOUBLE-EXIST',
              'SSet.DigestAuth.PX',
              'SSet.DigestAuth-PX2.PX',
           ]
 }, 


 # %% CANCEL %%	CACNCEL
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.CANCEL', 
   'RR:' => [
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
           ]
 }, 


# %% OPTIONS %%	OPTIONS
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.OPTIONS', 
   'RR:' => [
              'SSet.ReqMesg',
              'S.R-URI_TO-URI',
              'S.CSEQ-METHOD_OPTIONS',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
              ## some other rule may be appended(pending 12/2)
            ]
 }, 

 # %% REGISTER %%	REGISTER
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REGISTER', 
   'RR:' => [
              'SSet.ReqMesg',
              'SSet.URICompMsgRG',
              'S.MUSTNOT-HEADER_REGISTER',
              'S.R-URI_NOUSERINFO',
              'S.TO-TAG_NOEXIST',
              'S.EXPIRES_DECIMAL',
              'S.CONTACT-ACTION_NOEXIST',
              'S.CSEQ-METHOD_REGISTER',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
            ]
 }, 


 # %% Basic2-1 01 %%	Registrar receives Register.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.REGISTER.RG', 
   'RR:' => [
              'SSet.REGISTER',
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CONTACT-URI_REMOTE-CONTACT-URI',
              'S.EXPIRES_NOT=0',
              'D.COMMON.FIELD.REQUEST.RG',
            ]
 }, 

# %% Basic2-1 02 %%	Registrar receives Register.
  { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.REGwithAuth.RG', 
   'RR:' => [
              'SSet.REGISTER',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.CALLID_VALID_SHOULD',
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CONTACT-URI_REMOTE-CONTACT-URI',
              'S.EXPIRES_NOT=0',
              'S.AUTHORIZ_EXIST.TM',
              'SSet.DigestAuth.NOPX',
              'S.AUTHORIZ-URI_R-URI',
              'D.COMMON.FIELD.REQUEST.RG',
            ]
 }, 


 # %% Basic3-1-1 01 %%	UA2 receives INVITE.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.INVITE.NOPX', 
   'RR:' => [
              'SSet.INVITE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_NOEXIST',
              'D.COMMON.FIELD.REQUEST',
            ]
 }, 

 # %% Basic3-1-1 02 %%	UA2 receives ACK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.INVITE-ACK.NOPX', 
   'RR:' => [
              'SSet.ACK',
              'SSet.ACK-2xx',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.BODY_ACK-ANSWER_EXIST',
            ]
 }, 

 # %% Basic3-1-1 03 %%	UA2 receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.BYE-200.NOPX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
            ]
 }, 

 # %% Basic3-1-2 01 %%	UA1 receives 180 Ringing.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-180.NOPX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
            ]
 }, 

 # %% Basic3-1-2 02 %%	UA1 receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE.NOPX', 
   'RR:' => [
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
              'S.RE-ROUTE_NOEXIST',
              'S.BODY_EXIST',
              'SSet.SDP-ANS',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Basic3-1-2 03 %%	UA1 receives BYE.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.BYE.NOPX', 
   'RR:' => [
              'SSet.BYE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.TO-TAG_LOCAL-TAG',
              'S.CALLID_VALID',
              'S.ROUTE_NOEXIST',
            ]
 }, 


 # %% Basic3-2-1 01 %%	Proxy receives INVITE.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.INVITE.PX', 
   'RR:' => [
              'SSet.INVITE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_NOEXIST',
##DELreview              'S.ROUTE_EXIST',
##DELreview              'S.ROUTE_PX-URI',
              'D.COMMON.FIELD.REQUEST',
            ]
 }, 

  { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.non2xx-ACK', 
   'RR:' => [
              'SSet.ACK',
              'SSet.ACK-Non2xx',
              'S.VIA-BRANCH_REQ-VIA-BRANCH',
              'S.TO-TAG_LOCAL-TAG',
            ]
 }, 

 # %% Basic3-2-1 02 %%	Proxy receives ACK for 407 Proxy Authorization Required.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.407-ACK.PX', 
   'RR:' => [
	     'SSet.REQUEST.non2xx-ACK', 
            ]
 }, 

 # %% Basic3-2-1 03 %%	Proxy receives INVITE with Proxy-Authorization
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.INVwithP-AUTH.PX', 
   'RR:' => [
              'SSet.INVITE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_NOEXIST',
              'S.CALLID_VALID_SHOULD',
              'S.P-AUTH_EXIST.PX',
              'SSet.DigestAuth.PX',
              'S.P-AUTH-URI_R-URI',
##DELreview              'S.ROUTE_EXIST',
##DELreview              'S.ROUTE_PX-URI',
              'D.COMMON.FIELD.REQUEST',
            ]
 }, 

 # %% Basic3-2-1 04 %%	Proxy receives ACK for 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.200-ACK.PX', 
   'RR:' => [
              'SSet.ACK',
              'SSet.ACK-2xx',
              'SSet.ACK-2xx.AUTH.PX',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.ROUTE_EXIST',
              'S.ROUTE_ROUTESET_REVERSE.TWOPX', 
              'S.BODY_ACK-ANSWER_EXIST',
            ]
 }, 

 # %% Basic3-2-1 05 %%	Proxy receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.BYE-200.PX', 
   'RR:' => [
             'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
              'S.CSEQ-METHOD_BYE',
            ]
 }, 

 # %% Basic3-6-1 05 %%	Proxy receives 200 OK.
 # 'S.FROM-URI_LOCAL-URI'
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.BYE-200-REDIRECT.PX', 
   'RR:' => [
             'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS-REDIRECT.VI',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
              'S.FROM-URI_REDIRECT-URI',
              'S.CSEQ-METHOD_INVITE',
            ]
 }, 


 # %% Basic3-2-2 01 %%	Proxy receives 180 Ringing.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-180.PX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
            ]
 }, 

 # %% Basic3-2-2 02 %%	Proxy receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE.PX', 
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
              'S.ALLOW_EXIST',
              'S.BODY_EXIST',
              'SSet.SDP-ANS',
              'S.CSEQ-METHOD_INVITE',
              'S.RE-ROUTE_EXIST',
              'S.RE-ROUTE_ROUTESET_REVERSE.TWOPX',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Basic3-2-2 03 %%	Proxy receives BYE.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.BYE.PX', 
   'RR:' => [
              'SSet.BYE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.FROM-URI_REMOTE-URI',
              'S.FROM-TAG_REMOTE-TAG',
              'S.TO-URI_LOCAL-URI',
              'S.TO-TAG_LOCAL-TAG',
              'S.CALLID_VALID',
              'S.ROUTE_EXIST',
              'S.ROUTE_ROUTESET_REVERSE.TWOPX', 
            ]
 }, 

 # %% Basic3-3-1 01 %%	Proxy receives ACK with Proxy-Authorization for 2nd 407 Proxy Authorization Required.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.407-ACK_withP-AUTH.PX', 
   'RR:' => [
	     'SSet.REQUEST.non2xx-ACK', 
            ]
 }, 

 # %% Basic3-3-1 02 %%	Proxy receives INVITE with double Proxy-Authorization
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.INVwithP-AUTH-DOUBLE.PX', 
   'RR:' => [
              'SSet.INVITE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.P-AUTH_DOUBLE-EXIST',
              'SSet.DigestAuth.PX',
              'S.P-AUTH-URI_R-URI',
              'SSet.DigestAuth-PX2.PX',
              'S.P-AUTH-URI_R-URI-PX2',
##DELreview              'S.ROUTE_EXIST',
##DELreview              'S.ROUTE_PX-URI',
              'S.TO-TAG_NOEXIST',
              'D.COMMON.FIELD.REQUEST',
            ]
 }, 

 # %% Basic3-3-1 03 %%	Proxy receives ACK with double Proxy-Authorization for 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.200-ACK-DOUBLE.PX', 
   'RR:' => [
              'SSet.ACK',
              'SSet.ACK-2xx',
              'SSet.ACK-2xx.AUTH-PX2.PX',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.ROUTE_ROUTESET_REVERSE.TWOPX', 
            ]
 }, 


 # %% Basic3-6-1 01 %%	Proxy receives ACK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.302-ACK.PX', 
   'RR:' => [
	     'SSet.REQUEST.non2xx-ACK', 
            ]
 }, 

 # %% Basic3-6-1 02 %%	Proxy receives INVITE.
  # MUST DELRULE on sequence S.R-URI_TO-URI
#    - "Request-URI
#    3-6-1.seq 
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.INVITE.REDIRECT.PX2', 
   'RR:' => [
              'SSet.INVITE',
              'S.TAG_REQ-SIGNAL-RECYCLE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_NOEXIST',
              'D.COMMON.FIELD.REQUEST',
##DELreview              'S.ROUTE_EXIST',
##DELreview              'S.ROUTE_PX-URI',
              'S.R-URI_REDIRECT-URI', 
              'S.TO-LINE_REQ-TO-LINE_RECOMMEND', 
              'S.FROM-LINE_REQ-FROM-LINE_RECOMMEND', 
              'S.CALLID_VALID_RECOMMEND', 
            ]
 }, 


 # %% Basic3-6-1 03 %%	Proxy receives ACK for 200 OK and REDIRECT.
 # MUST DELRULE on sequence S.R-URI_REQ-CONTACT-URI
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.200-ACK-REDIRECT.PX', 
   'RR:' => [
              'SSet.ACK',
              'SSet.ACK-2xx',
              'S.R-URI_REDIRECT-CONTACT-URI', 
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.ROUTE_EXIST',
              'S.ROUTE_ROUTESET_REVERSE_REDIRECT.TWOPX', 
              'S.BODY_ACK-ANSWER_EXIST',
            ]
 }, 

 # %% Basic3-7-1 01 %%	UA2 receives ACK.

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.200-ACK.TM', 
   'RR:' => [
              'SSet.ACK',
              'SSet.ACK-2xx',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_LOCAL-TAG',
              'S.ROUTE_NOEXIST', 
              'S.BODY_ACK-ANSWER_EXIST',
            ]
 }, 

 # %% Basic3-7-1 02 %%	UA2 receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.RE-INVITE-200.PX', 
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
              'SSet.SDP-ANS',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Basic3-7-1 03 %%	UA2 receives BYE.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.BYE.P2P', 
   'RR:' => [
              'SSet.BYE.NOPX',
            ]
 }, 

 # %% Basic3-7-2 04 %%	Proxy receives re-INVITE.
 #  MUST deleterule  'S.R-URI_REMOTE-URI','S.R-URI_TO-URI','S.SUPPORTED_EXIST','S.ALLOW_EXIST',
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.RE-INVITE-HOLD', 
   'RR:' => [
              'SSet.INVITE',
              'S.R-URI_REQ-CONTACT-URI', 
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.ROUTE_EXIST',   ##ADD for TTC(watanabe) -> Move to IG(Mizusawa) -> Moved to RFC(Mizusawa)
              'S.ROUTE_ROUTESET_REVERSE.TWOPX', ## ADDed by Mizusawa
              'S.TO-TAG_LOCAL-TAG',
              'S.CALLID_VALID', 
              'S.SDP.O-VERSION-INCREMENT',
              'S.SDP.A-SENDONLY',
              'S.SDP.M-LINE_MEDIA-DESCRIPTION-CONTAIN',
              'D.COMMON.FIELD.REQUEST',
            ]
 }, 

 # %% Basic3-8-1 01 %%	Proxy receives CANCEL.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.200-CANCEL.PX', 
   'RR:' => [
              'SSet.CANCEL',
#              'S.ROUTE_EXIST',
              'S.ROUTE_VALID',
            ]
 }, 

 # %% Basic3-8-1 02 %%	Proxy receives ACK.
 # %% Basic3-9-1 01 %%	Proxy receives ACK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.4xxERR-ACK.PX', 
   'RR:' => [
	     'SSet.REQUEST.non2xx-ACK', 
            ]
 }, 


 # %% Basic3-8-2 01 %%	Proxy receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.CANCEL-200.PX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX-CANCEL',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS-CANCEL.VI',
              'S.TO-TAG_RECENT1xx-TO-TAG',
              'S.CSEQ-METHOD_CANCEL',
            ]
 }, 


 # %% Pattern3-8-2 01 %% Proxy receives 487 Request Terminated.
 # %% Pattern3-9-2 01 %% Proxy receives 486 Busy Here.
 # %% Pattern3-11-2 01 %% Proxy receives 480 Temporarily Unavailable.
 # %% Proxy receives 4XX Status.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-4XX.PX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX', 
              'S.VIA-RECEIVED_EXIST_PX', 
              'S.VIA_TWOPX_SEND_EQUALS.VI',
##DELSIPit              'S.RE-ROUTE_NOEXIST',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 


# UA1 receives 100 Trying.(no proxy)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-100.NOPX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
            ]
 }, 

# Proxy receives 100 Trying.(two proxies)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-100.PX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.CSEQ-METHOD_INVITE',
            ]
 }, 

# Proxy receives 100 Trying.(one proxy)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-100.ONEPX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
            ]
 }, 

 # %% Basic3-12-2 01 %%	Proxy receives 180 Ringing.(one proxy)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.INVITE-180.ONEPX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
              'S.TO-TAG_EXIST',
            ]
 }, 


 # %% Pattern3-26-1 03 %%	UA2 receives ACK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.4xxERR-ACK.NOPX', 
   'RR:' => [
	     'SSet.REQUEST.non2xx-ACK', 
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
              'D.COMMON.FIELD.STATUS',
            ]
 }, 

 # %% Pattern3-26-2 03 %%	UA2 receives 4xx
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.NEWMETHOD-4XX.NOPX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.RE-ROUTE_NOEXIST',
              'S.CSEQ-METHOD_NEWMETHOD',
              'S.TO-TAG_EXIST',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 


 # %% Pattern P3-26-2 02 %%	Term receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.CANCEL-200.TM', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_TWOPX_SEND_EQUALS-CANCEL.VI',
              'S.TO-TAG_RECENT1xx-TO-TAG',
              'S.CSEQ-METHOD_CANCEL',
            ]
 }, 

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.CANCEL-4xx.PX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX-CANCEL',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS-CANCEL.VI',
              'S.CSEQ-METHOD_CANCEL',
            ]
 }, 

 # %% OPT11-2-1 01 %%	Proxy receives 200 OK.(inside dialog)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.OPTIONS-200-DIALOG.PX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.CSEQ-METHOD_OPTIONS',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
              'S.ALLOW_EXIST',
              'S.ACCEPT_EXIST_SHOULD',
              'S.ACCEPT-ENCODING_EXIST',
              'S.ACCEPT-LANGUAGE_EXIST',
              'S.SUPPORTED_EXIST',
              'S.BODY_EXIST_SHOULD',
            ]
 }, 

 # %% OPT11-2-2 01 %%	Proxy receives 200 OK.(outof dialog)
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.OPTIONS-200.PX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.CSEQ-METHOD_OPTIONS',
              'S.TO-TAG_EXIST',
              'S.ALLOW_EXIST',
              'S.ACCEPT_EXIST_SHOULD',
              'S.ACCEPT-ENCODING_EXIST',
              'S.ACCEPT-LANGUAGE_EXIST',
              'S.SUPPORTED_EXIST',
              'S.BODY_EXIST_SHOULD',
            ]
 }, 


 # %% OPT11-4 01 %%	Proxy receives 486 Busy Here.
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.STATUS.OPTIONS-4XX.PX', 
   'RR:' => [
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX', 
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_OPTIONS',
              'D.COMMON.FIELD.STATUS',
            ]
 }, 


 # %% OtherRES12-62-2 %%	UA2 receives 500
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.REQUEST.BYE-4XX.TWOPX', 
    'RR:' => [
             'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS.VI',
              'S.CSEQ-METHOD_BYE',
              'S.TO-TAG_EXIST',
              'S.TO-TAG_REMOTE-TAG',
            ]
 }, 

 # %% Other 6-6-1 %%
 # ICMP TimeExceed
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.RETRANS-INVITE-ICMP', 
    'RR:' => ['S.RETRANS-INVITE-ICMP','S.RETRANS-INVITE-No3,4-INTERVAL']
 }, 

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.RETRANS-INVITE-ALLSAME', 
    'RR:' => ['S.SIP-ALLSAME-INVITE']
 }, 

 # ICMP Unreachable
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.NOT-RETRANS-INVITE-ICMP', 
    'RR:' => ['S.NOT-RETRANS-INVITE-ICMP']
 }, 

 # ICMP TimeExceed
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.RETRANS-STATUS200-ICMP', 
    'RR:' => ['S.RETRANS-STATUS200-ICMP']
 }, 

 # ICMP Unreachable
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.NOT-RETRANS-STATUS200-ICMP', 
    'RR:' => ['S.NOT-RETRANS-STATUS200-ICMP']
 }, 

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.RETRANS-STATUS200-ALLSAME', 
    'RR:' => ['S.SIP-ALLSAME-STATUS200']
 }, 

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.RETRY-AFTER.INVITE', 
    'RR:' => ['S.RETRY-AFTER.INVITE-INTERVAL','S.RETRY-AFTER.ACK-EXIST']
 }, 

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.RETRY-AFTER.NOT-INVITE-RETRANS', 
    'RR:' => ['S.RETRY-AFTER.NOT-INVITE-RETRANS']
 }, 

 { 'TY:' => 'RULESET', 'ID:' => 'SSet.RETRANS-NOBYE-AFTER3.BYE', 
    'RR:' => ['S.RETRANS-NOBYE-AFTER3.BYE']
 }, 


 #=================================
 # 
 #=================================
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTENT-LENGTH','OD:'=>LAST, 'PT:'=>HD, 'FM:'=>'Content-Length: %s',
  'AR:'=>[\&FFCalcConteLength]},


 #=================================
 # 
 #=================================
#Request-LINE

#  INVITE Request-URI=TUA   
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_TUA-URI','PT:'=>RQ,
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[\'$CVA_TUA_URI']},

#  ACK Request-URI=CONTACT (After dialog)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_CONTACT-URI','PT:'=>RQ,
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[\q{NINF('RemoteContactURI','LocalPeer')}]},

#  ACK Request-URI=TUA (BASIC)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_TUA-URI','PT:'=>RQ,
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[\'$CVA_TUA_URI']},

#  ACK Request-URI=CONTACT (After dialog)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_CONTACT-URI','PT:'=>RQ,
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[\q{NINF('RemoteContactURI','LocalPeer')}]},

#  BYE Request-URI=CONTACT(BASIC)
 {'TY:'=>'ENCODE', 'ID:'=>'E.BYE_CONTACT-URI','PT:'=>RQ,
  'FM:'=>'BYE %s SIP/2.0','AR:'=>[\q{NINF('RemoteContactURI','LocalPeer')}]},

#  CANCEL Request-URI=TUA
 {'TY:'=>'ENCODE', 'ID:'=>'E.CANCEL_TUA-URI','PT:'=>RQ,
  'FM:'=>'CANCEL %s SIP/2.0','AR:'=>[\'$CVA_TUA_URI']},

#  CANCEL Request-URI=CONTACT (After dialog)
 {'TY:'=>'ENCODE', 'ID:'=>'E.CANCEL_CONTACT-URI','PT:'=>RQ,
  'FM:'=>'CANCEL %s SIP/2.0','AR:'=>[\q{NINF('RemoteContactURI')}]},

#  OPTIONS Request-URI=TUA
 {'TY:'=>'ENCODE', 'ID:'=>'E.OPTIONS_TUA-URI','PT:'=>RQ,
  'FM:'=>'OPTIONS %s SIP/2.0','AR:'=>[\'$CVA_TUA_URI']},

#  OPTIONS Request-URI=CONTACT(BASIC)
 {'TY:'=>'ENCODE', 'ID:'=>'E.OPTIONS_CONTACT-URI','PT:'=>RQ,
  'FM:'=>'OPTIONS %s SIP/2.0','AR:'=>[\q{NINF('RemoteContactURI')}]},



#Header

#  CALLID $CVA_CALLID
 {'TY:'=>'ENCODE', 'ID:'=>'E.CALLID_CVA','PT:'=>HD,
  'FM:'=>'Call-ID: %s','AR:'=>[\q{NINF('DLOG.CallID')}]},


#  CONTACT URI=PUA-CONTACT
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_PUA','PT:'=>HD, 
  'FM:'=>'Contact: <%s>','AR:'=>[\q{NINF('LocalContactURI')}]},

#  CONTACT URI=PUA-CONTACT for REDIRECT at 302
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_302','PT:'=>HD, 
  'FM:'=>'Contact: <%s>','AR:'=>[\'$CVA_PUA_URI_REDIRECT']}, 

#  CONTACT URI=PUA-CONTACT for REDIRECT at 302 q=0.7.q=1.0
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_302_Q2','PT:'=>HD, 
  'FM:'=>'Contact: <%s>;q=0.7,<%s>;q=0.1','AR:'=>[\'$CVA_PUA_URI_REDIRECT',\'$CVA_PUA_URI_REDIRECT2']}, 

#  CONTACT URI=PUA-CONTACT for REDIRECT at 302 q=0.7.q=1.0 method=REGISTER,Subject=test
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_302_Q2_MS','PT:'=>HD, 
  'FM:'=>'Contact: <%s;method=REGISTER>;q=0.7,<%s?Subject=test>;q=0.1','AR:'=>[\'$CVA_PUA_URI_REDIRECT',\'$CVA_PUA_URI_REDIRECT2']}, 

#  CONTACT URI=PUA-CONTACT for 305
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_305','PT:'=>HD, 
  'FM:'=>'Contact: <sip:%s:%s;lr>','AR:'=>[\q{$CNT_CONF{'PX2-HOSTNAME'}},\'$CNT_PX2_PORT']}, 

#  CONTACT URI=PUA-CONTACT for REDIRECT
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_REDIRECT','PT:'=>HD, 
  'FM:'=>'Contact: <sip:%s@%s>','AR:'=>[\q{$CNT_CONF{'PUA-USER'}},\'$CNT_PUA_HOSTNAME_CONTACT_REDIRECT']}, 

#  CSEQ NUM=LOCAL-NUM Method=REGISTER  2006.9 inoue
 {'TY:'=>'ENCODE',  'ID:'=>'E.CSEQ_NUM_REGISTER','PT:'=>HD,
  'FM:'=>'CSeq: %s REGISTER','AR:'=>[\q{NINFW('DLOG.LocalCSeqNum','+1')}]},

#  CSEQ NUM=LOCAL-NUM Method=INVITE
 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ_NUM_INVITE','PT:'=>HD,
  'FM:'=>'CSeq: %s INVITE','AR:'=>[\q{NINFW('DLOG.LocalCSeqNum','+1')}]},

#  CSEQ NUM=LOCAL-NUM Method=INVITE
 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ_NUM_NEWMETHOD','PT:'=>HD,
  'FM:'=>'CSeq: %s NEWMETHOD','AR:'=>[\q{NINFW('DLOG.LocalCSeqNum','+1')}]},


#  CSEQ NUM=LOCAL-NUM Method=INVITE
 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ_NUM_CANCEL','PT:'=>HD,
  'FM:'=>'CSeq: %s CANCEL','AR:'=>[\q{NINF('DLOG.LocalCSeqNum')}]},

#  CSEQ NUM=LOCAL-NUM Method=ACK
 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ_NUM_ACK','PT:'=>HD,
  'FM:'=>'CSeq: %s ACK','AR:'=>[\q{NINF('DLOG.LocalCSeqNum')}]},

#  CSEQ NUM=LOCAL-NUM Method=BYE
 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ_NUM_BYE','PT:'=>HD,
  'FM:'=>'CSeq: %s BYE','AR:'=>[\q{NINFW('DLOG.LocalCSeqNum','+1')}]},

#  CSEQ NUM=LOCAL-NUM Method=OPTIONS
 {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ_NUM_OPTIONS','PT:'=>HD,
  'FM:'=>'CSeq: %s OPTIONS','AR:'=>[\q{NINFW('DLOG.LocalCSeqNum','+1')}]},

#  FROM URI=REQ-TO-URI TAG=LOCAL
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_REQ-TO-URI_LOCAL-TAG','PT:'=>HD, 
  'FM:'=>'From: <%s>;tag=%s','AR:'=>[\q{FV('HD.To.val.ad.ad.txt',@_)},\q{NINF('DLOG.LocalTag')}]},

#  FROM REDIRECT URI=PUA TAG=LOCAL
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_REDIRECT_LOCAL-TAG','PT:'=>HD, 
  'FM:'=>'From: <%s>;tag=%s','AR:'=>[\'$CVA_PUA_URI_REDIRECT',\q{NINF('DLOG.LocalTag')}]},


#  RECORD-ROUTE ONEPX
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_ONEPX','PT:'=>HD, 
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\'@CNT_TUA_ONEPX_ROUTESET[0]']},

#  RECORD-ROUTE ONEPX
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_ONEPX_PX2','PT:'=>HD, 
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\'@CNT_TUA_ONEPX_ROUTESET_PX2[0]']},

#  RECORD-ROUTE TWOPX
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOPX','PT:'=>HD, 
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\q{join(">,<",@{NINF('DLOG.RouteSet#A')})}]},

#  RECORD-ROUTE TWOPX for REDIRECT
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOPX_REDIRECT','PT:'=>HD, 
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\q{join(">,<",@CNT_PUA_TWOPX_ROUTESET_REDIRECT)}]},

#  RECORD-ROUTE TWOPX for INVITE
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOPX.REQUEST','PT:'=>HD, 
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\q{join(">,<",reverse(@{NINF('DLOG.RouteSet#A')}))}]},

#  RECORD-ROUTE ONEPX for INVITE
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_ONEPX.REQUEST','PT:'=>HD, 
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\q{join(">,<",@CNT_PUA_ONEPX_ROUTESET)}]},

#  RECORD-ROUTE REDIRECT TWOPX for INVITE
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOPX-REDIRECT.REQUEST','PT:'=>HD, 
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\q{join(">,<",reverse(@CNT_PUA_TWOPX_ROUTESET_REDIRECT))}]},

#  PROXY-AUTHENTICATE VALID
 {'TY:'=>'ENCODE', 'ID:'=>'E.PX-AUTHENTICATE_VALID','PT:'=>HD, 
  'FM:'=>"Proxy-Authenticate: Digest realm=%s, qop=\"auth\", nonce=%s, opaque=\"\", stale=FALSE, algorithm=MD5",
'AR:'=>[\q{NINF('AuthRealm')},\'$CNT_AUTH_NONCE']},

#  PROXY-AUTHENTICATE VALID
 {'TY:'=>'ENCODE', 'ID:'=>'E.PX-AUTHENTICATE_NOQOP','PT:'=>HD, 
  'FM:'=>"Proxy-Authenticate: Digest realm=%s, nonce=%s, opaque=\"\", stale=FALSE, algorithm=MD5",
'AR:'=>[\q{NINF('AuthRealm')},\'$CNT_AUTH_NONCE']},

#  PROXY-AUTHENTICATE VALID
 {'TY:'=>'ENCODE', 'ID:'=>'E.PX-AUTHENTICATE_VALID2','PT:'=>HD, 
  'FM:'=>"Proxy-Authenticate: Digest realm=%s, qop=\"auth\", nonce=%s, opaque=\"\", stale=FALSE, algorithm=MD5",
'AR:'=>[\q{NINF('AuthRealm','PX2')},\'$CNT_AUTH_NONCE2']},


#  TO URI=TUA NOTAG
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_TUA-URI_NO-TAG','PT:'=>HD, 
  'FM:'=>'To: <%s>','AR:'=>[\'$CVA_TUA_URI']},

#  TO URI=TUA NOTAG
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REDIRECT-URI_NO-TAG','PT:'=>HD, 
  'FM:'=>'To: <%s>','AR:'=>[\'$CVA_PUA_URI_REDIRECT']},
  
  
#  TO URI=TUA TAG=REMOTE
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REQ-FROM-URI_REMOTE-TAG','PT:'=>HD,
  'FM:'=>'To: <%s>;tag=%s','AR:'=>[\q{FV('HD.From.val.ad.ad.txt',@_)},\q{NINF('DLOG.RemoteTag')}]},

#  TO REDIRECT URI=TUA TAG=REMOTE
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REDIRECT-URI_REMOTE-TAG','PT:'=>HD,
  'FM:'=>'To: <%s>;tag=%s','AR:'=>[\'$CVA_PUA_URI_REDIRECT',\q{NINF('DLOG.RemoteTag')}]},

#  TO URI=TUA TAG=REMOTE
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_TUA-URI_EXIST-TAG_INVALID','PT:'=>HD,
  'FM:'=>'To: <%s>;tag=%s',
  'AR:'=>[\'$CVA_TUA_URI',\q{NINFW('DLOG.RemoteTag',100)}]},


#  VIA NOPX-VIA
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOPX','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++; ## 2006.2.9 sawada ##
#  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
               return @CNT_NOPX_SEND_VIAS[0];} ]},

#  VIA ONEPX-VIA
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_ONEPX','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++;  ## 2006.2.9 sawada ##
#  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
	       return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_ONEPX_SEND_VIAS);} ]},

#  VIA TWOPX-VIA
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_TWOPX','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++;  ## 2006.2.9 sawada ##
#  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
	       return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_TWOPX_SEND_VIAS);} ]},

#  VIA NOPX-VIA not count branch
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOPX-NOCOUNT','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s','AR:'=>[$SIP_PL_TRNS,\'@CNT_NOPX_SEND_VIAS[0]']},

#  VIA ONEPX-VIA not count branch
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_ONEPX-NOCOUNT','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,\q{join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_ONEPX_SEND_VIAS)}]},

#  VIA TWOPX-VIA not count branch
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_TWOPX-NOCOUNT','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,\q{join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_TWOPX_SEND_VIAS)}]},

#  VIA TWOPX-VIA not count branch
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_TWOPX-NOCOUNT-2XXACK','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s','AR:'=>[$SIP_PL_TRNS,\'@CNT_TWOPX_SEND_VIAS[0]']},


#  VIA(CANCEL) TWOPX-VIA
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_TWOPX-CANCEL','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s','AR:'=>[$SIP_PL_TRNS,\'@CNT_TWOPX_SEND_VIAS[0]']},

#  VIA REDIRECT TWOPX-VIA
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_REDIRECT_TWOPX','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
               join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_TWOPX_SEND_VIAS_REDIRECT)}]},

#  VIA REDIRECT TWOPX-VIA
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_REDIRECT_TWOPX-NOCOUNT','PT:'=>HD, 
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,\q{join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_TWOPX_SEND_VIAS_REDIRECT)}]},


#  WWW-AUTHENICATE VALID
 {'TY:'=>'ENCODE', 'ID:'=>'E.WWW_AUTH-VALID','PT:'=>HD,
  'FM:'=>"WWW-Authenticate: Digest realm=%s, qop=\"auth\", nonce=%s, opaque=\"\", stale=FALSE, algorithm=MD5",
  'AR:'=>[\'$CNT_AUTH_REALM_RG',\'$CNT_AUTH_NONCE']},

#  WWW-AUTHENICATE NOQOP
 {'TY:'=>'ENCODE', 'ID:'=>'E.WWW_AUTH-NOQOP','PT:'=>HD,
  'FM:'=>"WWW-Authenticate: Digest realm=%s, nonce=%s, opaque=\"\", stale=FALSE, algorithm=MD5",
  'AR:'=>[\'$CNT_AUTH_REALM_RG',\'$CNT_AUTH_NONCE']},

#  WWW-AUTHENICATE Remake nonce and stale=TRUE
 {'TY:'=>'ENCODE', 'ID:'=>'E.WWW_AUTH-REMAKE_NONCE','PT:'=>HD,
  'FM:'=>"WWW-Authenticate: Digest realm=%s, qop=\"auth\", nonce=%s, opaque=\"\", stale=TRUE, algorithm=MD5",
  'AR:'=>[\'$CNT_AUTH_REALM_RG',sub{$CNT_AUTH_NONCE=$CNT_AUTH_NONCE2;return $CNT_AUTH_NONCE;}
]},

#  AUTHENTICATION-INFO VALID
#    nextnonce:  $CNT_AUTH_NEXTNONCE
#    qop:        auth
#    rspauth:    
#    cnonce:     
#    nc:         
 {'TY:'=>'ENCODE', 'ID:'=>'E.PROXY-AUTHENTICATION-INFO-VALID','PT:'=>HD,
  'FM:'=>"Authentication-Info: nextnonce=%s, qop=\"auth\", rspauth=%s, cnonce=%s, nc=%s",
  'AR:'=>[\'$CNT_AUTH_NEXTNONCE[$CNT_AUTH_NEXTNONCE_COUNTER]',
				       \q{CalcAuthorizationInfoDigest('Proxy-Authorization',
						FV('RQ.Request-Line.method',@_) eq 'ACK'?'INVITE':FV('RQ.Request-Line.method',@_),@_)},
				       \q{FV('HD.Proxy-Authorization.val.digest.cnonce',@_)},
				       \q{FV('HD.Proxy-Authorization.val.digest.nc',@_)} ]},

## REGISTER 
 {'TY:'=>'ENCODE', 'ID:'=>'E.AUTHENTICATION-INFO-VALID','PT:'=>HD,
  'FM:'=>"Authentication-Info: nextnonce=%s, qop=\"auth\", rspauth=%s, cnonce=%s, nc=%s",
  'AR:'=>[\'$CNT_AUTH_NEXTNONCE[$CNT_AUTH_NEXTNONCE_COUNTER]',
				       \q{CalcAuthorizationInfoDigest('Authorization',
						FV('RQ.Request-Line.method',@_) eq 'ACK'?'INVITE':FV('RQ.Request-Line.method',@_),@_)},
				       \q{FV('HD.Authorization.val.digest.cnonce',@_)},
				       \q{FV('HD.Authorization.val.digest.nc',@_)} ]},

#Body
#  BODY_LOCAL
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID','PT:'=>BD,
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "t=0 0\r\n".
       "m=audio ".NINF('RTPPort','LocalPeer')." RTP/AVP 0\r\n".
       "a=rtpmap:0 PCMU/8000"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')}]
},

## 
# atribute
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY.MEDIA-DESCRIPTION','PT:'=>BD,
  'FM:'=>
      \q{ "v=0\r\n" . 
          "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
          "s=-\r\n".
          "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
          "t=0 0\r\n%s"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')},
          sub{my($msg,$rtp);
              $rtp=NINF('RTPPort','LocalPeer');
              $msg =JoinKeyValue("a=%s\r\n",FVs('BD.m=.val.attr.txt',@_),'txt');
              $msg.=JoinKeyValue("%s",FVs('BD.m=.val',@_),'txt');
	      $msg=~ s/^c=.*(?:\r\n|\Z)//mg;
	      $msg=~ s/sendonly/recvonly/mg;
	      $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $rtp/img;
              $msg=~ s/\r\n$//;return $msg;}]
},

## 
# atribute
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY.MEDIA-DESCRIPTION_REDIRECT','PT:'=>BD,
  'FM:'=>
      \q{ "v=0\r\n" . 
          "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS_REDIRECT."\r\n".
          "s=-\r\n".
          "c=IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS_REDIRECT."\r\n".
          "t=0 0\r\n%s"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')},
          sub{my($msg,$rtp);
              $rtp=NINF('RTPPort','LocalPeer');
              $msg =JoinKeyValue("a=%s\r\n",FVs('BD.m=.val.attr.txt',@_),'txt');
              $msg.=JoinKeyValue("%s",FVs('BD.m=.val',@_),'txt');
	      $msg=~ s/^c=.*(?:\r\n|\Z)//mg;
	      $msg=~s/sendonly/recvonly/mg;
	      $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $rtp/img;
              $msg=~ s/\r\n$//;return $msg;}]
},
  
##$CVA_TUA_M_MEDIA_DESCRIPTION
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID_HOLD','PT:'=>BD,
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP 0::\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP 0::\r\n".
       "t=0 0\r\n%s"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')},
          sub{my($msg,$rtp);
              $rtp=NINF('RTPPort','LocalPeer');
              $msg = JoinKeyValue("a=%s\r\n",$CVA_TUA_M_MEDIA_DESCRIPTION->{'a='},'txt');
              $msg.= JoinKeyValue("%s",$CVA_TUA_M_MEDIA_DESCRIPTION->{'m='},'txt');
              $msg=~ s/sendonly/recvonly/mg;
	      $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $rtp/img;
	      $msg=~ s/\r\n$//;return $msg;}]
},
  
##1.$CVA_TUA_M_MEDIA_DESCRIPTION
##2.a=sendonly
##  2a.$CNT_CONF{'HOLD-MEDIA'}
##  2b.a=inactive,a=sendrecv,a=recvonly,a=sendonly
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID_HOLD2','PT:'=>BD,
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "t=0 0\r\n%s"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')},
          sub{my($msg,@mdec,$rtp);
              $rtp=NINF('RTPPort','LocalPeer');
              $msg = JoinKeyValue("a=%s\r\n",$CVA_TUA_M_MEDIA_DESCRIPTION->{'a='},'txt');
              push(@mdec,$msg);
              push(@mdec,map($_->{txt}, @{$CVA_TUA_M_MEDIA_DESCRIPTION->{'m='}}));
              @mdec=map{$_=~s/sendonly/recvonly/mg;$_;} @mdec;
              if($msg=$mdec[$CNT_CONF{'HOLD-MEDIA'}]){
                $msg=~s/(?:inactive|sendrecv|recvonly)/sendonly/mg;
                if(!($msg =~ /(?:sendonly)/mg)){ $msg = $msg . "a=sendonly\r\n"}
                $mdec[$CNT_CONF{'HOLD-MEDIA'}]=$msg;
              }
              $msg=JoinKeyValue("%s",\@mdec);
	      $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $rtp/img;
	      $msg=~ s/\r\n$//;return $msg;}]
},

##1.$CVA_TUA_M_MEDIA_DESCRIPTION
##2.a=sendrecv
##  2a.$CNT_CONF{'HOLD-MEDIA'}
##  2b.a=inactive,a=sendrecv,a=recvonly,a=sendonly
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID_HOLD_RELEASE','PT:'=>BD,
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "t=0 0\r\n%s"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')},
          sub{my($msg,@mdec,$rtp);
              $rtp=NINF('RTPPort','LocalPeer');
              $msg = JoinKeyValue("a=%s\r\n",$CVA_TUA_M_MEDIA_DESCRIPTION->{'a='},'txt');
              push(@mdec,$msg);
              push(@mdec,map($_->{txt}, @{$CVA_TUA_M_MEDIA_DESCRIPTION->{'m='}}));
              @mdec=map{$_=~s/sendonly/recvonly/mg;$_;} @mdec;
              if($msg=$mdec[$CNT_CONF{'HOLD-MEDIA'}]){
                $msg=~s/(?:inactive|recvonly|sendonly)/sendrecv/mg;
                if(!($msg =~ /(?:sendrecv)/mg)){ $msg = $msg . "a=sendrecv\r\n"}
                $mdec[$CNT_CONF{'HOLD-MEDIA'}]=$msg;
              }
              $msg=JoinKeyValue("%s",\@mdec);
	      $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $rtp/img;
	      $msg=~ s/\r\n$//;return $msg;}]
},

 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_CVA_DESCRIPTION_OTHER1','PT:'=>BD, ####   @@@@@@@'E.BODY_VALID'
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." ".NINF('SDP_o_Session','LocalPeer')." IN IP$SIP_PL_IP ".$CVA_OTHERUA_IPADDRESS."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".$CVA_OTHERUA_IPADDRESS."\r\n".
       "t=0 0\r\n%s"},
  'AR:'=>[sub{my($msg,@mdec,$rtp);
              $rtp=NINF('RTPPort','LocalPeer');
              $msg = JoinKeyValue("a=%s\r\n",$CVA_TUA_M_MEDIA_DESCRIPTION->{'a='},'txt');
              push(@mdec,$msg);
              push(@mdec,map($_->{txt}, @{$CVA_TUA_M_MEDIA_DESCRIPTION->{'m='}}));
              @mdec=map{$_=~s/sendonly/recvonly/mg;$_;} @mdec;
              $msg=JoinKeyValue("%s",\@mdec);
	      $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $rtp/img;
	      $msg=~ s/\r\n$//;return $msg;}]
},


 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID_REDIRECT','PT:'=>BD,    ####  @@@@@@@'E.BODY_VALID'
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS_REDIRECT."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS_REDIRECT."\r\n".
       "t=0 0\r\n".
       "m=audio ".NINF('RTPPort','LocalPeer')." RTP/AVP 0\r\n".
       "a=rtpmap:0 PCMU/8000"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')}]
},

  
#  BODY_LOCAL illegal
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_FMT_999999999','PT:'=>BD,  ### @@@@@@@'E.BODY_VALID'
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "t=0 0\r\n".
       "m=audio ".NINF('RTPPort','LocalPeer')." RTP/AVP 999999999\r\n".
       "a=rtpmap:999999999 PCMU/999999999"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')}]
},

#### 
#### 

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO-RETURN-LOCAL_TAG','PT:'=>HD, 
  'FM:'=>'To: %s',
  'AR:'=>[sub {
            my($msg, $val);
            $val = FV('HD.To.val.param.tag',@_);
	    if ($val) {
		$msg = FV('HD.To.txt',@_);
	    } else {
		$msg = FV('HD.To.val.ad.txt',@_) . ";tag=" . NINF('DLOG.LocalTag');
	    }
            return $msg;
          }] },


#  CONTACT URI=PUA-CONTACT
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_TUA-CONTACT','PT:'=>HD, 
  'FM:'=>'Contact: <%s>','AR:'=>[\q{NINF('RemoteContactURI')}]}, 

 #=================================
 # 
 #=================================

# RETURN FROM,TO,CALL-ID,CSEQ
 {'TY:'=>'RULESET', 'ID:'=>'EESet.BASIC-FTCC-RETURN-NOTAG', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.FROM-RETURN',
	'E.TO-RETURN',
	'E.CALL-ID-RETURN',
	'E.CSEQ-RETURN']
  },

# RETURN FROM,TO,CALL-ID,CSEQ with To-tag
 {'TY:'=>'RULESET', 'ID:'=>'EESet.BASIC-FTCC-RETURN-TOTAG', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.FROM-RETURN',
	'E.TO-RETURN-LOCAL_TAG',
	'E.CALL-ID-RETURN',
	'E.CSEQ-RETURN']
  },

# RETURN FROM,TO,CALL-ID,CSEQ with To-tag and CSEQ method si INVITE
 {'TY:'=>'RULESET', 'ID:'=>'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.FROM-RETURN',
	'E.TO-RETURN-LOCAL_TAG',
	'E.CALL-ID-RETURN',
	'E.CSEQ-LAST-INVITE']
  },



 #=================================
 # 
 #=================================

# INVITE NOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-NOPX.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.INVITE_TUA-URI',
	'E.VIA_NOPX',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE NOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-NOPX.TM.HOLD', 'MD:'=>SEQ, 
  'RR:'=>[

      'E.INVITE_CONTACT-URI',
	'E.VIA_NOPX',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
 	'E.ALLOW_VALID',
 	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_HOLD2'],
  'EX:'=>\&MargeSipMsg},

# INVITE HOLD-RELEASE NOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-NOPX.TM.HOLD-RELEASE', 'MD:'=>SEQ, 
  'RR:'=>[
      'E.INVITE_CONTACT-URI',
	'E.VIA_NOPX',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
 	'E.ALLOW_VALID',
 	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
        'E.BODY_VALID_HOLD_RELEASE'
],
  'EX:'=>\&MargeSipMsg},

# INVITE NOPX NOSDP
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-NOPX-NOSDP.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.INVITE_TUA-URI',
	'E.VIA_NOPX',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# INVITE TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.RECORDROUTE_TWOPX.REQUEST',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# INVITE REDIRECT TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-TWOPX-REDIRECT.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
        'E.VIA_REDIRECT_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.RECORDROUTE_TWOPX-REDIRECT.REQUEST',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_REDIRECT-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# INVITE HOLD TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-TWOPX.PX1.HOLD', 'MD:'=>SEQ, 
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.RECORDROUTE_TWOPX.REQUEST',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
 	'E.ALLOW_VALID',
 	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_HOLD2'],
  'EX:'=>\&MargeSipMsg},

# INVITE HOLD TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-TWOPX.PX1.HOLD-RELEASE', 'MD:'=>SEQ, 
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.RECORDROUTE_TWOPX.REQUEST',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
        'E.BODY_VALID_HOLD_RELEASE'
],
  'EX:'=>\&MargeSipMsg},

# INVITE TWOPX NO RECORD-ROUTE
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-TWOPX-NO-RECORDROUTE.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# INVITE TWOPX invalid
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-TWOPX-INVALID-TOTAG.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.RECORDROUTE_TWOPX.REQUEST',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_EXIST-TAG_INVALID',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# INVITE ONEPX
 {'TY:'=>'RULESET', 'ID:'=>'E.INVITE-ONEPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
        'E.INVITE_CONTACT-URI',
	'E.VIA_ONEPX',
	'E.MAXFORWARDS_ONEPX',
	'E.RECORDROUTE_ONEPX.REQUEST',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# ACK NOPX 
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-NOPX.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# ACK NOPX for non-2xx final response
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-NOPX-no2xx.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.ACK_TUA-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# ACK NOPX FOR INVITE For 200 (start dialog) with answer
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-NOPX-ANS.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOPX', #CHANGE0114
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENTTYPE_VALID', 
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# ACK TWOPX FOR INVITE For 200 (start dialog) with no answer
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# ACK TWOPX FOR INVITE For 200 (start dialog) with no answer
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-TWOPX-REDIRECT.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_REDIRECT_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_REDIRECT-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# ACK TWOPX for non-2xx final response
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-TWOPX-no2xx.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
      'E.ACK_CONTACT-URI',
	'E.VIA_TWOPX-NOCOUNT-2XXACK',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# ACK TWOPX FOR INVITE For 200 (start dialog) with no answer and No Record-Route
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-TWOPX-NO-RECORDROUTE.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
      'E.ACK_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# ACK ONEPX FOR INVITE For 200 (start dialog) with no answer
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-ONEPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_ONEPX',
	'E.MAXFORWARDS_ONEPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# ACK ONEPX FOR INVITE For non-2xx final response
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-ONEPX-no2xx.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_ONEPX-NOCOUNT',
	'E.MAXFORWARDS_ONEPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# ACK TWOPX FOR INVITE For 200 (start dialog) with answer
 {'TY:'=>'RULESET', 'ID:'=>'E.ACK-TWOPX-ANS.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# BYE NOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.BYE-NOPX.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_NOPX',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# BYE TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.BYE-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# BYE ONEPX
 {'TY:'=>'RULESET', 'ID:'=>'E.BYE-ONEPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEPX',
	'E.MAXFORWARDS_ONEPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# BYE RIDIRECT TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.BYE-REDIRECT-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_REDIRECT_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# CANCEL NOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.CANCEL-NOPX.TM', 'MD:'=>SEQ, 
  'RR:'=>[
#	'E.CANCEL_TUA-URI',
        'E.CANCEL_CONTACT-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_CANCEL',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# CANCEL TWOPX
 {'TY:'=>'RULESET', 'ID:'=>'E.CANCEL-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
#	'E.CANCEL_TUA-URI',
        'E.CANCEL_CONTACT-URI',
        'E.VIA_TWOPX-CANCEL',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_CANCEL',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# OPTIONS NOPX BASIC
 {'TY:'=>'RULESET', 'ID:'=>'E.OPTIONS-NOPX.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.OPTIONS_TUA-URI',
	'E.VIA_NOPX',
	'E.MAXFORWARDS_NOPX',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_OPTIONS',
        'E.ACCEPT_SDP',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# OPTIONS TWOPX(without dialog)
 {'TY:'=>'RULESET', 'ID:'=>'E.OPTIONS-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.OPTIONS_CONTACT-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.RECORDROUTE_TWOPX.REQUEST',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_OPTIONS',
	'E.CONTACT_PUA',
        'E.ACCEPT_SDP',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# OPTIONS TWOPX(inside dialog)
 {'TY:'=>'RULESET', 'ID:'=>'E.OPTIONS-TWOPX-DIALOG.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.OPTIONS_TUA-URI',
	'E.VIA_TWOPX',
	'E.MAXFORWARDS_TWOPX',
	'E.RECORDROUTE_TWOPX.REQUEST',
	'E.FROM_PUA-URI_LOCAL-TAG',
	'E.TO_TUA-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_OPTIONS',
	'E.CONTACT_PUA',
        'E.ACCEPT_SDP',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# 100  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-100-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-100',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 100  ALL-RETURN From UA
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-100-RETURN.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-100',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 180  ALL-RETURN-NOPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-180-RETURN-NOPX.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 180  ALL-RETURN-ONEOPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-180-RETURN-ONEPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA-RETURN',
	'E.RECORDROUTE_ONEPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 180  ALL-RETURN-TWOPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-180-RETURN-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 180  ALL-RETURN-TWOPX NO-RECORD-ROUTE
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-180-RETURN-TWOPX.PX1.NO-RECORD-ROUTE', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 180  ALL-RETURN-TWOPX For Redirect
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-180-RETURN-TWOPX-REDIRECT.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX_REDIRECT',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 183  ALL-RETURN-TWOPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-183-RETURN-TWOPX-SDP.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-183',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.CONTENT-LENGTH_CAL',
      'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# 183  ALL-RETURN-TWOPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-183-RETURN-TWOPX-SDP-ANS.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-183',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.CONTENT-LENGTH_CAL',
        'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

# 183  ALL-RETURN-TWOPX NO-RECORD-ROUTE
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-183-RETURN-TWOPX.PX1.NO-RECORD-ROUTE', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-183',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 199  ALL-RETURN-TWOPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-199-RETURN-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-199',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN-NOPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-NOPX.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN-ONEPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-ONEPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.RECORDROUTE_ONEPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN-TWOPX
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-TWOPX.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# 200  ALL-RETURN-NOPX For CANCEL
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-NOPX.TM.CANCEL', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# 200  ALL-RETURN-TWOPX For CANCEL
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-TWOPX.PX1.CANCEL', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# 200  ALL-RETURN-NOPX with SDP (dialog start)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-NOPX-SDP.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN-NOPX with SDP (dialog start)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-NOPX-SDP-ANS.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
        'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN-ONEPX with SDP (dialog start)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-ONEPX-SDP.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.RECORDROUTE_ONEPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN-ONEPX with SDP (dialog start)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-ONEPX-SDP-ANS.PX1', 'MD:'=>SEQ
,
   'RR:'=>[
      'E.STATUS-200',
      'E.VIA-RETURN',
      'E.RECORDROUTE_ONEPX',
      'EESet.BASIC-FTCC-RETURN-TOTAG',
      'E.CONTACT_PUA',
      'E.ALLOW_VALID',
#     'E.SUPPORTED_VALID',		# 20050407 usako delete
      'E.RES.SUPPORTED_VALID',	# 20050407 usako add
      'E.CONTENTTYPE_VALID',
      'E.CONTENT-LENGTH_CAL',
      'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN-TWOPX with SDP (dialog start)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-TWOPX-SDP.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},


# 200  ALL-RETURN-TWOPX with SDP (dialog start) NO Record-Route
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-TWOPX-SDP.PX1-NO-RECORD-ROUTE', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN-TWOPX with SDP (answer)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-TWOPX-SDP-ANS.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

 # 200  ALL-RETURN-TWOPX with SDP (dialog start) NO Record-Route
 # ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ)
  {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-TWOPX-SDP-ANS.PX1-NO-RECORD-ROUTE', 'MD:'=>SEQ, 
   'RR:'=>[
 	'E.STATUS-200',
 	'E.VIA-RETURN',
 	'EESet.BASIC-FTCC-RETURN-TOTAG',
 	'E.CONTACT_PUA',
 	'E.ALLOW_VALID',
# 	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
 	'E.CONTENTTYPE_VALID',
 	'E.CONTENT-LENGTH_CAL',
 	'E.BODY.MEDIA-DESCRIPTION'],
   'EX:'=>\&MargeSipMsg},
 

# 200  ALL-RETURN-TWOPX with SDP (dialog start)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-TWOPX-SDP-REDIRECT.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX_REDIRECT',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_REDIRECT',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_REDIRECT'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN-TWOPX with SDP (answer) for REDIRECT
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-TWOPX-SDP-ANS-REDIRECT.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX_REDIRECT',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_REDIRECT',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION_REDIRECT'],
  'EX:'=>\&MargeSipMsg},
#0106end

# 200  ALL-RETURN From REGISTRAR
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN.RG', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT-RETURN-EX',
      'E.DATE_VALID', 
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN From REGISTRAR for Update
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
# Contact expires=5;
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-EX5.RG', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT-RETURN-EX-5',
      'E.DATE_VALID',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 200  ALL-RETURN From REGISTRAR for Update
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
# Contact expires=30;
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-200-RETURN-EX30.RG', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT-RETURN-EX-30',
        'E.DATE_VALID',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 299  ALL-RETURN-TWOPX with SDP (dialog start)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-299-RETURN-TWOPX-SDP.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-299',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},

# 299  ALL-RETURN-TWOPX with SDP (answer)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-299-RETURN-TWOPX-SDP-ANS.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-299',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_PUA',
	'E.ALLOW_VALID',
#	'E.SUPPORTED_VALID',		# 20050407 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050407 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},

# 301  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-301-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
      'E.STATUS-301',
      'E.VIA-RETURN',
      'E.RECORDROUTE_ONEPX',
      'EESet.BASIC-FTCC-RETURN-TOTAG',
      'E.CONTACT_302',
      'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# 302  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-302-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-302',
	'E.VIA-RETURN',
	'E.RECORDROUTE_ONEPX',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_302',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 305  ALL-RETURN From Term
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-305-RETURN.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-305',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_305',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# 401  ALL-RETURN From REGISTRAR
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-401-RETURN.RG', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-401',
	'E.VIA-RETURN',
	'E.WWW_AUTH-VALID',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 401  ALL-RETURN From REGISTRAR
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-401-RETURN-NOQOP.RG', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-401',
	'E.VIA-RETURN',
	'E.WWW_AUTH-NOQOP',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 401  ALL-RETURN From REGISTRAR
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-401-RETURN-REMAKE-NONCE.RG', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-401',
	'E.VIA-RETURN',
	'E.WWW_AUTH-REMAKE_NONCE',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 403  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-403-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-403',
	'E.VIA-RETURN',
	'E.PX-AUTHENTICATE_VALID',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 404  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-404-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-404',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 407  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-407-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-407',
	'E.VIA-RETURN',
	'E.PX-AUTHENTICATE_VALID',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 407  ALL-RETURN From PX2
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-407-RETURN-AUTH.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-407',
	'E.VIA-RETURN',
	'E.PX-AUTHENTICATE_VALID2', 
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 407  ALL-RETURN From PX1(NO QOP)
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-407-RETURN-NOQOP.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-407',
	'E.VIA-RETURN',
	'E.PX-AUTHENTICATE_NOQOP',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# 413  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-413-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-413',
	'E.VIA-RETURN',
        'E.RETRYAFTER_10',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 480  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-480-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-480',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 481  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-481-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-481',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 486  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-486-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-486',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 486  ALL-RETURN From PX1(with Record-Route)
# ALL-RETURN(VIA,RECORD-ROUTE,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-486-RETURN-RECORDROUTE.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-486',
	'E.VIA-RETURN',
	'E.RECORDROUTE_TWOPX.REQUEST',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 486  ALL-RETURN From TM
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-486-RETURN.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-486',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 487  ALL-RETURN
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-487-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-487',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 488   ALL-RETURN
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-488-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-488',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 499  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-499-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-499',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 500  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-500-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-500',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 503  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-503-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-503',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 599  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-599-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-599',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# 699  ALL-RETURN From PX1
# ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-699-RETURN.PX1', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.STATUS-699',
	'E.VIA-RETURN',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},



# 

 #=================================
 # 
 #=================================
# Client INVITE T1
# 
# 
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1.INVITE', 
   'TM:' => 'T1',
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'INVITE') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{$T1_TIMER=($T1_COUNT eq 2 || $T1_COUNT eq 10)?$CNT_CONF{'TIMER-T1'}:$T1_TIMER*2}},

# Client CANCEL T1
# 
# 
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1.CANCEL', 
   'TM:' => 'T1',
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'CANCEL') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{$T1_TIMER=($T1_COUNT eq 2)?$CNT_CONF{'TIMER-T1'}:(($T1_TIMER*2<$CNT_CONF{'TIMER-T2'})?$T1_TIMER*2:$CNT_CONF{'TIMER-T2'})}},

# Client CANCEL 
# CANCEL
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1-100SEND.CANCEL', 
   'TM:' => 'T1', 'CT:' => 'NON-PROCEED',
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Status-Line.code') eq '100') && (FVi($PKT_INDEX,'DIRECTION') eq 'send') &&
		   (FVi($PKT_INDEX,'HD.CSeq.val.method') eq 'CANCEL')},
   'EX:' => \q{$T1_TIMER=$CNT_CONF{'TIMER-T2'}}},

# Client REGISTER T1
# 
# 
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1.REGISTER', 
   'TM:' => 'T1',
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'REGISTER') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{$T1_TIMER=($T1_COUNT eq 2)?$CNT_CONF{'TIMER-T1'}:(($T1_TIMER*2<$CNT_CONF{'TIMER-T2'})?$T1_TIMER*2:$CNT_CONF{'TIMER-T2'})}},

# REGISTER
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1-100SEND.REGISTER', 
   'TM:' => 'T1',  'CT:' => 'NON-PROCEED',
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Status-Line.code') eq '100') && (FVi($PKT_INDEX,'DIRECTION') eq 'send') &&
		   (FVi($PKT_INDEX,'HD.CSeq.val.method') eq 'REGISTER')},
   'EX:' => \q{$T1_TIMER=$CNT_CONF{'TIMER-T2'}}},

# Client BYE T1
# 
# 
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1.BYE', 
   'TM:' => 'T1',
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Request-Line.method') eq 'BYE') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{$T1_TIMER=($T1_COUNT eq 2)?$CNT_CONF{'TIMER-T1'}:(($T1_TIMER*2<$CNT_CONF{'TIMER-T2'})?$T1_TIMER*2:$CNT_CONF{'TIMER-T2'})}},

# BYE
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1-100SEND.BYE', 
   'TM:' => 'T1',  'CT:' => 'NON-PROCEED',
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Status-Line.code') eq '100') && (FVi($PKT_INDEX,'DIRECTION') eq 'send') &&
		   (FVi($PKT_INDEX,'HD.CSeq.val.method') eq 'BYE')},
   'EX:' => \q{$T1_TIMER=$CNT_CONF{'TIMER-T2'}}},

# BYE
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1-200RECV.BYE', 
   'TM:' => 'T1',
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Status-Line.code') eq '200') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv') &&
		   (FVi($PKT_INDEX,'HD.CSeq.val.method') eq 'BYE')}},

# 486 Ststus T1
# 
# 
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1.200', 
   'TM:' => 'T1',
   'PR:' => \q{200 eq FVi($PKT_INDEX,'RQ.Status-Line.code') && (FVi($PKT_INDEX,'DIRECTION') eq 'recv')},
   'EX:' => \q{$T1_TIMER=($T1_COUNT eq 2)?$CNT_CONF{'TIMER-T1'}:(($T1_TIMER*2<$CNT_CONF{'TIMER-T2'})?$T1_TIMER*2:$CNT_CONF{'TIMER-T2'})}},

# 486 Ststus T1
# 
# 
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1.486', 
   'TM:' => 'T1',
   'PR:' => sub {my $code=FVi($PKT_INDEX,'RQ.Status-Line.code');
		 return FVi($PKT_INDEX,'HD.CSeq.val.method') eq 'INVITE' && FVi($PKT_INDEX,'DIRECTION') eq 'recv' && 
		     300<=$code && 407 != $code},
   'EX:' => \q{$T1_TIMER=($T1_COUNT eq 2)?$CNT_CONF{'TIMER-T1'}:(($T1_TIMER*2<$CNT_CONF{'TIMER-T2'})?$T1_TIMER*2:$CNT_CONF{'TIMER-T2'})}},

# CANCEL
# 
 { 'TY:' => 'TIMER', 'ID:' => 'T.T1-CANCEL-200RECV.INVITE', 
   'TM:' => 'T1',
   'PR:' => \q{(FVi($PKT_INDEX,'RQ.Status-Line.code') eq 200) && (FVi($PKT_INDEX,'DIRECTION') eq 'recv') && 
		   (FVi($PKT_INDEX,'HD.CSeq.val.method') eq 'CANCEL')}},


 #=================================
 # 
 #=================================
# S1-1
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.INVITE'],
   'RR:' => ['S.RETRANS-EXIST.INVITE','S.RETRANS-1.INVITE','S.RETRANS-32.INVITE',
	     'S.RETRANS-STOP-AFTER-BTIMER.INVITE','S.RETRANS-NOACK-AFTER-BTIMER.INVITE']},

# S1-2
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-STOP.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'RR:' => ['S.RETRANS-EXIST.INVITE','S.RETRANS-STOP-AFTER180.INVITE']},

# S1-3
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-STOP.ACK', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.INVITE'],
   'RR:' => ['S.RETRANS-EXIST.INVITE','S.RETRANS-NONSTOP.ACK','S.RETRANS-STOP.ACK']},

# S2-1-1
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS.CANCEL', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.CANCEL'],
   'RR:' => ['S.RETRANS-EXIST.INVITE','S.RETRANS-EXIST.CANCEL','S.RETRANS-1.CANCEL','S.RETRANS-F-TIMER.CANCEL']},

# S2-1-2
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS.BYE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.BYE'],
#   'RR:' => ['S.RETRANS-EXIST.INVITE','S.RETRANS-EXIST.BYE','S.RETRANS-1.BYE','S.RETRANS-F-TIMER.BYE','S.RETRANS-F-TIMER-RECIVECOUNT.BYE']},
   'RR:' => ['S.RETRANS-EXIST.INVITE','S.RETRANS-EXIST.BYE','S.RETRANS-1.BYE','S.RETRANS-F-TIMER.BYE']},

# S2-1-3
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS.REGISTER', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.REGISTER'],
   'RR:' => ['S.RETRANS-EXIST.REGISTER','S.RETRANS-1.REGISTER','S.RETRANS-F-TIMER.REGISTER','S.RETRANS-SAME-CONTACT.REGISTER']},

# S2-2-1
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-PROCEEDING.CANCEL', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.CANCEL','T.T1-100SEND.CANCEL'],
   'RR:' => ['S.RETRANS-EXIST.INVITE','S.RETRANS-EXIST.CANCEL','S.RETRANS-100BEFORE.CANCEL','S.RETRANS-100AFTER.CANCEL']},

# S2-2-2
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-PROCEEDING.BYE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.BYE','T.T1-100SEND.BYE'],
   'RR:' => ['S.RETRANS-EXIST.INVITE','S.RETRANS-EXIST.BYE','S.RETRANS-100BEFORE.BYE','S.RETRANS-100AFTER.BYE']},

# S2-2-3
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-PROCEEDING.REGISTER', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.REGISTER','T.T1-100SEND.REGISTER'],
   'RR:' => ['S.RETRANS-EXIST.REGISTER','S.RETRANS-100BEFORE.REGISTER','S.RETRANS-100AFTER.REGISTER']},

# S3-1
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-486.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.486'],
   'RR:' => ['S.RETRANS-EXIST-1.486','S.RETRANS-1.486','S.RETRANS-H-TIMER.486']},

# S3-2
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-INVITE.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.486'],
   'RR:' => ['S.RETRANS-MUST-486.INVITE','S.RETRANS-486-MULTIREPLY.INVITE','S.RETRANS-481-OVER-HTIMER.INVITE',]},

# S3-3
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-486-STOP.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.486'],
   'RR:' => ['S.RETRANS-STOP.486']},

# S4-1-1
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-CANCEL.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1-CANCEL-200RECV.INVITE'],
   'RR:' => ['S.RETRANS-MUST-200.CANCEL','S.RETRANS-200-MULTIREPLY.CANCEL',
	     'S.RETRANS-481-OVER-JTIMER.CANCEL','S.RETRANS-200-OVER-JTIMER.CANCEL']},
# S4-1-2
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-200.BYE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1-200RECV.BYE'],
   'RR:' => ['S.RETRANS-MUST-200.BYE','S.RETRANS-200-MULTIREPLY.BYE',
	     'S.RETRANS-481-OVER-JTIMER.BYE','S.RETRANS-200-OVER-JTIMER.BYE']},

# S4-1-3
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-200.OPTIONS', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.200'],
   'RR:' => ['S.RETRANS-MUST-200.OPTIONS','S.RETRANS-200-MULTIREPLY.OPTIONS',
	     'S.RETRANS-481-OVER-JTIMER.OPTIONS','S.RETRANS-200-OVER-JTIMER.OPTIONS']},

# Sp9-1
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.AFTER-T1-TIMEOUT.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'RR:' => ['S.RETRANS-EXIST.INVITE','S.NOACK-AFTER-T1*64.INVITE']},

 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.AFTER-T1-TIMEOUT-SHOULD.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'RR:' => ['S.RETRANS-EXIST.INVITE','S.NOACK-AFTER-T1*64-SHOULD.INVITE']},

# Sp13-1
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.EXPIRES-TIMEOUT.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.INVITE'],
   'RR:' => ['S.RETRANS-STOP-AFTER180.INVITE','S.RETRANS-EXIST.CANCEL','S.CANCEL-AFTER-EXPIRES-TIMEOUT.INVITE']},

# Sp13-2
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.STATUS-487.INVITE', 'CA:' => 'Timer',
   'OK:' => 'For INVITE with Expires 2, Client sends 487 status',
   'NG:' => 'For INVITE with Expires 2, Client does not send 487 status',
   'EX:' => \q{FV('RQ.Status-Line.code',@_) eq 487}}, 
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.INVITE.EXPIRES-2', 
   'RR:' => ['S.STATUS-487.INVITE']},

# Sp13-3
 { 'TY:' => 'TIMINGSET', 'ID:' => 'ST.RETRANS-OVER-T1*64.INVITE', 
   'OK:' => 'OK',
   'NG:' => 'NG',
   'TM:' => ['T.T1.200'],
   'RR:' => ['S.RETRANS-200-T1.INVITE','S.BYE-OVER-T1*64.INVITE']},

#O10-6
 { 'TY:' => 'SYNTAX', 'ID:' => 'ST.RETRANS-1XX.INVITE', 'CA:' => 'Timer',
   'OK:' => \\'Client sends non-100 provisional response(%s) at every minute, to handle the possibility of lost provisional response.',
   'NG:' => \\'Client MUST send non-100 provisional response(%s) at every minute, to handle the possibility of lost provisional response.',
   'EX:' => \q{FFop('>',FVibc('recv','','','RQ.Status-Line.code',\\'100<$val&&$val<200'),1,@_)}}, 

);


#
1
