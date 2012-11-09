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
@SIPPXRules =
(
 #=================================
 # 
 #=================================
 {'TY:'=>'DECODE', 'ID:'=>'D.WWW-Authenticate.NONCE',
  'VA:'=>[('HD.WWW-Authenticate.val.digest.nonce', CNT_AUTH_NONCE)]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Proxy-Authenticate.NONCE',
  'VA:'=>[('HD.Proxy-Authenticate.val.digest.nonce', CNT_AUTH_NONCE)]},

### 20050118 
 {'TY:'=>'DECODE', 'ID:'=>'D.Proxy-Authenticate.REALM',
  'VA:'=>[('HD.Proxy-Authenticate.val.digest.realm', 'ND::AuthPasswd')]},

 {'TY:'=>'DECODE', 'ID:'=>'D.WWW-Authenticate.OPAQUE',
  'VA:'=>[('HD.WWW-Authenticate.val.digest.opaque', CNT_AUTH_OPAQUE)]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Proxy-Authenticate.OPAQUE',
  'VA:'=>[('HD.Proxy-Authenticate.val.digest.opaque', CNT_AUTH_OPAQUE)]},

 {'TY:'=>'DECODE', 'ID:'=>'D.FROM-TAG_STATUS',
  'VA:'=>[(\q{FV('HD.From.val.param.tag',@_)}, 'ND::DLOG.LocalTag')]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Record-Route.TWOPX-0',
  'VA:'=>[(\q{FV('HD.Record-Route.val.route.ad.ad.txt',@_)}, 'ND::DLOG.RouteSet#0')]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Record-Route.TWOPX-1',
  'VA:'=>[(\q{FV('HD.Record-Route.val.route.ad.ad.txt',@_)}, 'ND::DLOG.RouteSet#1')]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Record-Route.TWOPX', 'MD:'=>'array',
  'VA:'=>[(\q{[@{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)}]}, 'ND::DLOG.RouteSet#A')]},
 {'TY:'=>'DECODE', 'ID:'=>'D.Record-Route.TWOPX-Reverse', 'MD:'=>'array',
  'VA:'=>[(\q{[reverse(@{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)})]}, 'ND::DLOG.RouteSet#A')]},
 {'TY:'=>'DECODE', 'ID:'=>'D.RECORD-ROUTE.CALLEE', 'MD:'=>'array',
  'VA:'=>[(sub{my($rr);
	       $rr=FVs('HD.Record-Route.val.route.ad.ad.txt',@_);
	       if(IsNDPX()){$rr=[NINF('Uri').';lr',@$rr];} return $rr;}, 'ND::DLOG.RouteSet#A')]},
 {'TY:'=>'DECODE', 'ID:'=>'D.RECORD-ROUTE.CALLER', 'MD:'=>'array',
  'VA:'=>[(\q{[reverse(@{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)})]}, 'ND::DLOG.RouteSet#A')]},

 #=================================
 # 
 #=================================
 
# Dialog Setup Case 1 TM/PX receives 200 
 { 'TY:' => 'RULESET', 'ID:' => 'D.200.SET_DIALOG', 'MD:'=>'SEQ',
   'RR:' => ['D.TO-URI_STATUS','D.TO-TAG','D.FROM-URI_STATUS','D.FROM-TAG_STATUS','D.Record-Route.TWOPX-Reverse']
 }, 
	
# Dialog Setup Case 2 TM receives Initial Invite
 { 'TY:' => 'RULESET', 'ID:' => 'D.INVITE.SET_DIALOG.TM', 'MD:'=>'SEQ',
   'RR:' => ['D.FROM-URI','D.FROM-TAG','D.TO-URI','D.Record-Route.TWOPX']
 }, 

# Dialog Setup Case 3 PX received Initial Invite
 { 'TY:' => 'RULESET', 'ID:' => 'D.INVITE.SET_DIALOG.PX', 'MD:'=>'SEQ',
   'RR:' => ['D.FROM-URI','D.FROM-TAG','D.TO-URI','D.Record-Route.TWOPX-1']
 }, 


# Dialog Setup for Caller
 { 'TY:' => 'RULESET', 'ID:' => 'D.DIALOG-SETUP.CALLEE', 'MD:'=>'SEQ', 'PR:'=>\q{!NINF('DLOG.State')},
   'RR:' => ['D.CONTACT.URI','D.CSEQ','D.CALL-ID','D.FROM-TAG','D.RECORD-ROUTE.CALLEE'],
   'EX:' => \q{NINFW('DLOG.State','confirmed')}
 }, 
# Dialog Setup for Callee
 { 'TY:' => 'RULESET', 'ID:' => 'D.DIALOG-SETUP.CALLER', 'MD:'=>'SEQ',
   'RR:' => ['D.DIALOG-SETUP.CALLER.1XX','D.DIALOG-SETUP.CALLER.200','D.DIALOG-SETUP.CALLER.200.EARLY'],
 }, 
 { 'TY:' => 'RULESET', 'ID:' => 'D.DIALOG-SETUP.CALLER.1XX', 'MD:'=>'SEQ',
   'PR:'=>\q{(FV('RQ.Status-Line.code',@_) ne 100) && (FV('RQ.Status-Line.code',@_) =~ /$1/) && !NINF('DLOG.State')},
   'RR:' => ['D.CONTACT.URI','D.CSEQ','D.FROM-TAG','D.RECORD-ROUTE.CALLER'],
   'EX:' => \q{NINFW('DLOG.State','early')}
 }, 
 { 'TY:' => 'RULESET', 'ID:' => 'D.DIALOG-SETUP.CALLER.200', 'MD:'=>'SEQ',
   'PR:'=>\q{(FV('RQ.Status-Line.code',@_) eq 200) && !NINF('DLOG.State')},
   'RR:' => ['D.CONTACT.URI','D.CSEQ','D.FROM-TAG','D.RECORD-ROUTE.CALLER'],
   'EX:' => \q{NINFW('DLOG.State','confirmed')}
 }, 
 { 'TY:' => 'RULESET', 'ID:' => 'D.DIALOG-SETUP.CALLER.200.EARLY', 'MD:'=>'SEQ',
   'PR:'=>\q{(FV('RQ.Status-Line.code',@_) eq 200) && (NINF('DLOG.State') eq 'early')},
   'RR:' => ['D.RECORD-ROUTE.CALLER'],
   'EX:' => \q{NINFW('DLOG.State','confirmed')}
 }, 
 { 'TY:' => 'RULESET', 'ID:' => 'D.DIALOG-SETUP.CALLER.4XX', 'MD:'=>'SEQ',
   'PR:'=>\q{(FV('RQ.Status-Line.code',@_) =~ /^4/)},
   'RR:' => ['D.CONTACT.URI','D.CSEQ','D.FROM-TAG','D.RECORD-ROUTE.CALLER'],
 }, 


#=================================
 # 
 #=================================

####### 
####### 20050209 tadokoro
 # %% TO:01 %%
 ##	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_START186', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) of the To header MUST start \"sip(s):186\".', 
   'NG:' => \\'The URI(%s) of the To header MUST start \"sip(s):186\".', 
   'EX:' => \q{FFIsMatchStr('^sips?:186\d+@', \\\'HD.To.val.ad.ad.txt','','',@_)}},

 # %% TO:02 %%
 ##	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_START184', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) of the To header MUST start \"sip(s):184\".', 
   'NG:' => \\'The URI(%s) of the To header MUST start \"sip(s):184\".', 
   'EX:' => \q{FFIsMatchStr('^sips?:184\d+@', \\\'HD.To.val.ad.ad.txt','','',@_)}},
   
 # %% TO:03 %%
 ##	To
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-DISPLAYNAME_ANONYMOUS', 'CA:' => 'To',
   'OK:' => \\'The Display name(%s) in the To field MUST equal \"Anonymous\".', 
   'NG:' => \\'The Display name(%s) in the To field MUST equal \"Anonymous\".', 
   'EX:' => \q{FFop('EQ',FV('HD.To.val.ad.disp',@_),'anonymous',@_),}}, 
   
 # %% TO:04 %%
## 2006.2.8 sawada ##
##	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_ANONYMOUS', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST be the anonymous URI(that is, equal to \"%s:anonymous\@anonymous.invalid\").', 
   'NG:' => \\'The URI(%s) in the To field MUST be the anonymous URI(that is, equal to \"%s:anonymous\@anonymous.invalid\").', 
   'EX:' => {\q{FFop('eq',FV('HD.To.val.ad.ad.txt',@_),(($SIP_PL_TRMS eq "TLS")?"sips":"sip").':anonymous@anonymous.invalid',@_),},\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"}}}, 

##	To-URI
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_ANONYMOUS', 'CA:' => 'To',
#   'OK:' => \\'The URI(%s) in the To field MUST be the anonymous URI(that is, equal to \"sip:anonymous\@anonymous.invalid\").', 
#   'NG:' => \\'The URI(%s) in the To field MUST be the anonymous URI(that is, equal to \"sip:anonymous\@anonymous.invalid\").', 
#   'EX:' => \q{FFop('eq',FV('HD.To.val.ad.ad.txt',@_),'sip:anonymous@anonymous.invalid',@_),}}, 

 # %% FROM:nn %%
 ##	From
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-DISPLAYNAME_ANONYMOUS', 'CA:' => 'From',
   'OK:' => \\'The Display name(%s) in the From field MUST equal \"Anonymous\".', 
   'NG:' => \\'The Display name(%s) in the From field MUST equal \"Anonymous\".', 
   'EX:' => \q{FFop('EQ',FV('HD.From.val.ad.disp',@_),'anonymous',@_),}}, 
   
 # %% FROM:nn %%
## 2006.2.8 sawada ##
 ##	From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_ANONYMOUS', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) in the From field MUST be the anonymous URI(that is, equal to \"%s:anonymous\@anonymous.invalid\").', 
   'NG:' => \\'The URI(%s) in the From field MUST be the anonymous URI(that is, equal to \"%s:anonymous\@anonymous.invalid\").', 
   'EX:' => {\q{FFop('eq',FV('HD.From.val.ad.ad.txt',@_),(($SIP_PL_TRMS eq "TLS")?"sips":"sip").':anonymous@anonymous.invalid',@_)},\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"}}}, 

##	From-URI
# { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_ANONYMOUS', 'CA:' => 'From',
#   'OK:' => \\'The URI(%s) in the From field MUST be the anonymous URI(that is, equal to \"sip:anonymous\@anonymous.invalid\").', 
#   'NG:' => \\'The URI(%s) in the From field MUST be the anonymous URI(that is, equal to \"sip:anonymous\@anonymous.invalid\").', 
#   'EX:' => \q{FFop('eq',FV('HD.From.val.ad.ad.txt',@_),'sip:anonymous@anonymous.invalid',@_)}}, 

 # %% FROM:nn %%
 ## From
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-DISPLAYNAME_EXIST', 'CA:' => 'From',
   'OK:' => \\'The Display name(%s) in the From header MUST exist.', 
   'NG:' => \\'The Display name(%s) in the From header MUST exist.', 
   'EX:' => \q{FFop('ne',FV('HD.From.val.ad.disp',@_),'',@_),}}, 


 # %% FROM:nn %%
 ## From
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-USERINFO_EXIST', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) of the From header MUST have userinfo.', 
   'NG:' => \\'The URI(%s) of the From header MUST have userinfo.', 
   'EX:' => \q{FFIsMatchStr('^sips?:.+@.+', \\\'HD.From.val.ad.ad.txt','','',@_)}},
		
 # %% R-URI:nn %%
 ##	userinfo
 ## userinfo
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_USERINFO_0ABJ_E164', 'CA:' => 'Request',
   'OK:' => 'A "userinfo" component in Request-URI MUST be transfered from "0AB-J" to "+81AB-J".', 
   'NG:' => 'A "userinfo" component in Request-URI MUST be transfered from "0AB-J" to "+81AB-J".', 
   'EX:' => \q{FFIsMatchStr('^\+81[1-9]',\\\'RQ.Request-Line.uri.ad.userinfo','','',@_)}},
		
		
 # %% R-URI:nn %%
 ##	userinfo
 ## 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_USERINFO_1860ABJ_E164', 'CA:' => 'Request',
   'OK:' => 'A "userinfo" component in Request-URI MUST be transfered from "1860AB-J" to "+81AB-J".', 
   'NG:' => 'A "userinfo" component in Request-URI MUST be transfered from "1860AB-J" to "+81AB-J".', 
   'EX:' => \q{FFIsMatchStr('^\+81[1-9]',\\\'RQ.Request-Line.uri.ad.userinfo','','',@_)}},   
   
   
 # %% R-URI:nn %%
 ##	userinfo
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_USERINFO_1840ABJ_E164', 'CA:' => 'Request',
   'OK:' => 'A "userinfo" component in Request-URI MUST be transfered from "1840AB-J" to "+81AB-J".', 
   'NG:' => 'A "userinfo" component in Request-URI MUST be transfered from "1840AB-J" to "+81AB-J".', 
   'EX:' => \q{FFIsMatchStr('^\+81[1-9]',\\\'RQ.Request-Line.uri.ad.userinfo','','',@_)}},
   
 # %% Privacy:01 %%
 ##	Privacy
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PRIVACY_EXIST', 'CA:' => 'Privacy',
   'OK:' => 'A Privacy header field MUST exist in this message.', 
   'NG:' => 'A Privacy header field MUST exist in this message.', 
   'EX:' => \q{FFIsExistHeader('Privacy',@_)} },


 # %% Privacy:02 %%
 ##	Privacy
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PRIVACY_VALUE_NONE', 'CA:' => 'Privacy',
   'OK:' => \\'A Privacy header field(%s) MUST have the value \"none\"', 
   'NG:' => \\'A Privacy header field(%s) MUST have the value \"none\"', 
   'EX:' => \q{FFop('eq' , FV('HD.Privacy.txt',@_ ), 'none',@_)} },
   
   
 # %% Privacy:03 %%
 ##	Privacy
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PRIVACY_VALUE_ID', 'CA:' => 'Privacy',
   'OK:' => \\'A Privacy header field(%s) MUST have the value \"id\"', 
   'NG:' => \\'A Privacy header field(%s) MUST have the value \"id\"', 
   'EX:' => \q{FFop('eq' , FV('HD.Privacy.txt',@_ ), 'id',@_)} },

   
 # %% P-Preffered-Identity:01 %%
 ##	P-Preferred-Identity
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-PREF-ID_NOEXIST', 'CA:' => 'P-Preferred-Identity',
   'OK:' => 'A P-Preferred-Identity header field MUST NOT exist in this message.', 
   'NG:' => 'A P-Preferred-Identity header field MUST NOT exist in this message.', 
   'EX:' => \q{!FFIsExistHeader("P-Preferred-Identity",@_)} },


 # %% P-Preferred-Identity:02 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-PREF-ID_REMOVED', 'CA:' => 'P-Preferred-Identity',
   'OK:' => \\'P-Preferred-Identity header MUST be removed by the proxy server.', 
   'NG:' => \\'P-Preferred-Identity header MUST be removed by the proxy server.', 
   'PR:' => \q{FFIsExistHeader("P-Preferred-Identity",'',NDPKT(@_[1]))},
   'EX:' => \q{!FFIsExistHeader("P-Preferred-Identity",@_)}}, 


 # %% P-Preferred-Identity:03 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-PREF-ID_NOGENERATE', 'CA:' => 'P-Preferred-Identity',
   'OK:' => \\'P-Preferred-Identity header MUST NOT be generated by the proxy server.', 
   'NG:' => \\'P-Preferred-Identity header MUST NOT be generated by the proxy server.', 
   'PR:' => \q{!FFIsExistHeader("P-Preferred-Identity",'',NDPKT(@_[1]))},
   'EX:' => \q{!FFIsExistHeader("P-Preferred-Identity",@_)}}, 

		
 # %% P-Asserted-Identity:01 %%
 ##	P-Asserted-Identity
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ID_EXIST', 'CA:' => 'P-Asserted-Identity',
   'OK:' => 'A P-Asserted-Identity header field MUST exist in this message.', 
   'NG:' => 'A P-Asserted-Identity header field MUST exist in this message.', 
   'EX:' => \q{FFIsExistHeader("P-Asserted-Identity",@_)} },

   
 # %% P-Asserted-Identity:02 %%
 ##	P-Asserted-Identity
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ID_NOEXIST', 'CA:' => 'P-Asserted-Identity',
   'OK:' => 'A P-Asserted-Identity header field MUST NOT exist in this message.', 
   'NG:' => 'A P-Asserted-Identity header field MUST NOT exist in this message.', 
   'EX:' => \q{!FFIsExistHeader("P-Asserted-Identity",@_)} },

   
 # %% P-Asserted-Identity:03 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ORIGINAL_PREF', 'CA:' => 'P-Asserted-Identity',
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
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ORIGINAL_ASSERT', 'CA:' => 'P-Asserted-Identity',
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
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ID_REMOVED', 'CA:' => 'P-Asserted-Identity',
   'OK:' => \\'P-Asserted-Identity header MUST be removed by the proxy server.', 
   'NG:' => \\'P-Asserted-Identity header MUST be removed by the proxy server.',
   'PR:' => \q{FFIsExistHeader("P-Asserted-Identity",'',NDPKT(@_[1]))},
   'EX:' => \q{!FFIsExistHeader("P-Asserted-Identity",@_)}}, 
  
		
 # %% P-Asserted-Identity:06 %%
 ## 
 ## NUT
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-ASSERT-ID_GENERATE', 'CA:' => 'P-Asserted-Identity',
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

# %% RECORD-ROUTE:nn %%	Record-Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RECORD-ROUTE_ADD-PROXY-URI', 'CA:' => 'Record-Route',
   'OK:' => \\'SIP URI of the proxy (\"%s\" in the original message) MUST be added to the Record-Route header fields(%s).', 
   'NG:' => \\'SIP URI of the proxy (\"%s\" in the original message) MUST be added to the Record-Route header fields(%s).', 
   'PR:' => \q{FFIsExistHeader('Record-Route',@_)},
   'EX:' => sub {
       my ($rule,$pktinfo,$context)=@_;
       my ($before,$after);
       $before = FVs('HD.Record-Route.val.route.ad.ad.txt','',NDPKT(@_[1]));
       $after = FVs('HD.Record-Route.val.route.ad.ad.txt',@_);
       $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'<=>','ARG1:'=>join(', ',@{$before}),'ARG2:'=>join(', ',@{$after})};
       if($#$after <= $#$before){return '';}
       return join(' ',@$after) eq join(' ',$after->[0],@$before);} # 
 },		

   
 # %% R-URI:01 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REMOTE-CONTACT-URI', 'CA:' => 'Request',
   'OK:' => \\'Request-URI(%s) MUST equal remote target CONTACT URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'NG:' => \\'Request-URI(%s) MUST equal remote target CONTACT URI(%s) of the Tester(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('RQ.Request-Line.uri',@_),NINF('LocalContactURI'),@_)} },

####### 20050209 tadokoro 

 ########
 # %% FROM:nn %% From-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-URI_ORIGINAL-FROM-URI', 'CA:' => 'From',
   'OK:' => \\'The URI(%s) of the From header MUST equal the URI(%s) of From header in the original message.', 
   'NG:' => \\'The URI(%s) of the From header MUST equal the URI(%s) of From header in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.From.val.ad.ad.txt',@_),FV('HD.From.val.ad.ad.txt','',NDPKT(@_[1])),@_)}}, 


 # %% FROM:nn %%	From-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.FROM-TAG_ORIGINAL-FROM-TAG', 'CA:' => 'From',
   'OK:' => \\'The From tag(%s) MUST equal the From tag(%s) in the original message.', 
   'NG:' => \\'The From tag(%s) MUST equal the From tag(%s) in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.From.val.param.tag',@_),FV('HD.From.val.param.tag','',NDPKT(@_[1])),@_)}}, 

 # %% TO:nn %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_ORIGINAL-TO-URI', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) of the To header MUST equal the URI(%s) of To header in the original message.', 
   'NG:' => \\'The URI(%s) of the To header MUST equal the URI(%s) of To header in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.To.val.ad.ad.txt',@_),FV('HD.To.val.ad.ad.txt','',NDPKT(@_[1])),@_)}}, 

 # %% TO:nn %%	To-tag
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_ORIGINAL-TO-TAG', 'CA:' => 'To',
   'OK:' => \\'The To tag(%s) MUST equal the To tag(%s) in the original message.', 
   'NG:' => \\'The To tag(%s) MUST equal the To tag(%s) in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.To.val.param.tag',@_),FV('HD.To.val.param.tag','',NDPKT(@_[1])),@_)}}, 
 ########


#Inoue_add_060920_for_fork--------------------

 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-TAG_ORIGINAL-TO-TAG-F', 'CA:' => 'To',
   'OK:' => \\'The To tag(%s) MUST equal the To tag(%s) in the original message.
',
   'NG:' => \\'The To tag(%s) MUST equal the To tag(%s) in the original message.
',
   'EX:' => \q{FFop('eq',FV('HD.To.val.param.tag',@_),FV('HD.To.val.param.tag','
',NDPKT('','UA11','','recv')),@_)}},

 # %% TO:nn %%  To-URI^[$B$,^[(BLOCAL URI^[$B$HF10l$G$"$k$3$H!#^[(B
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_LOCAL-URI-F', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).',
   'NG:' => \\'The URI(%s) in the To field MUST equal the local URI(%s) of the Tester(form of IP address, port number is not acceptable).',
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.To.val.ad.ad.txt',@_),NINF('RemoteAoRURI','RemotePeer'),@_)} },


 # %% R-URI:nn %%       Request-URI^[$B$,!"BP1~$9$k%j%/%(%9%H$N$b$N$HF10l$G$"$k$3$H!#^[(B
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_REQ-R-URI-F', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST equal that(%s) of corresponding request.',
   'NG:' => \\'The Request-URI(%s) MUST equal that(%s) of corresponding request.',
   'EX:' => \q{FFop('eq',\\\'RQ.Request-Line.uri.txt',FV('RQ.Request-Line.uri.txt','',NDPKT('','MY','FIRST','recv','RQ.Request-Line.method','INVITE')),@_)}},


 # %% VIA:nn %% branchESC$B$,ESC(BCANCELESC$B$5$l$k%j%/%(%9%HESC(B(ACKESC$B$KBP$9$kESC(BINVITEESC$B!"ESC(BCANCELESC$B$KBP$9$kESC(BINVITE)ESC$B$N$b$N$HF10l$G$"$k$3$H!#ESC(B
 # branchESC$B$,B8:_$7$?>l9g$N$_$3$N%A%'%C%/$r9T$&ESC(B
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-BRANCH_REQ-VIA-BRANCH-F', 'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) of ACK for non-2xx and CANCEL MUST equal that(%s) of INVITE.',
   'NG:' => \\'The Via branch value(%s) of ACK for non-2xx and CANCEL MUST equal that(%s) of INVITE.',
   'PR:' => \q{FVs('HD.Via.val.via.param.branch=',@_)},
   'EX:' =>\q{FFop('EQ',\\\'HD.Via.val.via.param.branch=',FV('HD.Via.val.via.param.branch=','',NDPKT('','MY','FIRST','recv','RQ.Request-Line.method','INVITE')),@_)}},


 # %% VIA:06 %% ViaESC$B%X%C%@$NFbMF$,!"ESC(BCANCELESC$B$5$l$k%j%/%(%9%H$N:G=i$NESC(BViaESC$B$HF10l$G$"$k$3$H!#ESC(B
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_REQ-1STVIA-F', 'CA:' => 'Via',
   'OK:' => \\'A CANCEL request MUST have a Via header field value(%s) matching the top Via value(%s) in the request being cancelled.',
   'NG:' => \\'A CANCEL request MUST have a Via header field value(%s) matching the top Via value(%s) in the request being cancelled.',
   'EX:' =>\q{FFop('eq',FV('HD.Via.val.via.by',@_),FV('HD.Via.val.via.by','',NDPKT('','MY','FIRST','recv','RQ.Request-Line.method','INVITE')),@_)}},


#------------------------------------------- 


 # %% CSEQ:nn %%	
 ##	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CSEQ-SEQNO_ORIGINAL-SEQNO', 'CA:' => 'CSeq',
   'OK:' => \\'The CSeq number(%s) MUST equal the CSeq number(%s) in the original message.', 
   'NG:' => \\'The CSeq number(%s) MUST equal the CSeq number(%s) in the original message.', 
   'EX:' => \q{FFop('eq',FV('HD.CSeq.val.csno', @_ ) , FV('HD.CSeq.val.csno','', NDPKT(@_[1]) ) , @_ )} }, 

 # %% MAXFORWARDS:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.MAX-FORWARDS_DECREMENT', 'CA:' => 'Max-Forwards',
   'OK:' => \\'The Max-Forwards value(%s) MUST be decremented by one from the original message(%s).', 
   'NG:' => \\'The Max-Forwards value(%s) MUST be decremented by one from the original message(%s).', 
   'PR:' =>\'FFIsExistHeader("Max-Forwards",@_)',  ## 2006.7.31 sawada add ##
   'EX:' => \q{ FFop( 'eq' , FV('HD.Max-Forwards.val', @_ ) , FV('HD.Max-Forwards.val','', NDPKT(@_[1]) ) - 1 , @_ ) }},

 # %% CNTLENGTH:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CNTLENGTH_ORIGINAL-CNTLENGTH', 'CA:' => 'Content-Length',
   'OK:' => \\'The Content-Length value(%s) MUST equal the Content-Length value(%s) in the original message.', 
   'NG:' => \\'The Content-Length value(%s) MUST equal the Content-Length value(%s) in the original message.', 
   'EX:' => \q{ FFop( 'eq',FV('HD.Content-Length.val', @_ ) , FV('HD.Content-Length.val','', NDPKT(@_[1]) ) , @_ ) }},

 # %% BODY:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.BODY_ORIGINAL-BODY', 'CA:' => 'Body',
   'OK:' => "The body part MUST equal that in the original message.", 
   'NG:' => "The body part MUST equal that in the original message.", 
   'PR:' =>\q{FFIsExistHeader('v=',@_)},  ## 2006.7.31 sawada add ##
   'EX:' => \q{ FFop( 'eq',FV('BD.txt', @_ ) , FV('BD.txt','', NDPKT(@_[1]) ) , @_ ) }},

 # %% ROUTE:nn %%	Route
 ##	
{ 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_ROUTESET_NOEXIST', 'CA:' => 'Route',
   'OK:' => \\'The value(%s) of Route header field MUST NOT include the SIP-URI(%s) of the proxy server.', 
   'NG:' => \\'The value(%s) of Route header field MUST NOT include the SIP-URI(%s) of the proxy server.', 
   'EX:' => \q{ !FFop( 'eq',FV('HD.Route.val.route.ad.ad.txt',@_ ) , FV('HD.Route.val.route.ad.ad.txt','', NDPKT(@_[1])) , @_ ) }},

 ########
 # %% VIA:nn %%	Via
 ## Via
 ## 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_INSERT-NEWVIA-LINE', 'CA:' => 'Via',
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
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-RECEIVED_EXIST_2ND_REMOTE', 'CA:' => 'Via',
   'OK:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the emulating UA.', 
   'NG:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the emulating UA.', 
   'PR:' => \q{FFIsMatchStr(qr/^(?:$PtHostname(?:$PtCOLON$PtPort)?)$/s,FVn('HD.Via.val.via.sendby.txt',1,@_),'ALL','',@_)},
   'EX:' => \q{FFCompareFullADDRESS(FV('HD.Via.val.via.param.received=',@_),NINF('IPaddr','Forward'),@_)}},
   
 # %% VIA:nn %%	Via
 # PX->NUT forward
 # 
 # SIPruleRFC.pm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX', 'CA:' => 'Via',
   'OK:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the emulating proxy.', 
   'NG:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the emulating proxy.', 
   'PR:' => \q{FFIsMatchStr(qr/^(?:$PtHostname(?:$PtCOLON$PtPort)?)$/s,FVn('HD.Via.val.via.sendby.txt',1,@_),'ALL','',@_)},
   'EX:' => \q{FFCompareFullADDRESS(FV('HD.Via.val.via.param.received=',@_),NINF('IPaddr','Forward'),@_)}},
 ########

 # %% R-URI:nn %% Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_ORIGINAL-R-URI', 'CA:' => 'Request',
   'OK:' => \\'The Request-URI(%s) MUST equal the Request-URI(%s) in the original message.', 
   'NG:' => \\'The Request-URI(%s) MUST equal the Request-URI(%s) in the original message.', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('RQ.Request-Line.uri',@_),,FV('RQ.Request-Line.uri','',NDPKT(@_[1])),@_)}}, 


### Add 05/01/14 cats ###

 # %% VIA:nn %%	Via
 # Target
 # 
 # SIPruleRFC.pm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA-RECEIVED_EXIST_2ND_LOCAL', 'CA:' => 'Via',
   'OK:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the node of tester(Proxy or UA).', 
   'NG:' => \\'The second Via header MUST include received parameter, and that value(%s) MUST equal IP address(%s) of the node of tester(Proxy or UA).', 
   'PR:' => \q{FFIsMatchStr(qr/^(?:$PtHostname(?:$PtCOLON$PtPort)?)$/s,FVn('HD.Via.val.via.sendby.txt',1,@_),'ALL','',@_)},
   'EX:' => \q{FFIsMatchStr(NINF('IPaddr'),FVn('HD.Via.val.via.param.received=',1,@_),'',@_)}}, 

 # %% VIA:nn %%	Via
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.VIA_REMOVE-TOPMOST', 'CA:' => 'Via',
   'OK:' => "The topmost Via header field MUST be removed from the response.",
   'NG:' => "The topmost Via header field MUST be removed from the response.",
   'EX:' => sub {
     my($addr1,$addr2);
     $addr1=FVs('HD.Via.val.via.sendby.txt',@_);
     $addr2=FVs('HD.Via.val.via.sendby.txt','',NDPKT(@_[1]));
     shift @$addr2;
     return IsArrayEqual($addr1,$addr2);}},

 # %% Proxy-Authorization
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTH_NOTEXIST', 'CA:' => 'Proxy-Authorization',
   'OK:' => "A Proxy-Authorization header field MUST NOT exist in this message.", 
   'NG:' => "A Proxy-Authorization header field MUST NOT exist in this message.", 
   'EX:' => \q{!FFIsExistHeader('Proxy-Authorization',@_)}}, 

### Add 05/01/17 cats ###
 ########update by watanabe
 # %% PROXY-AUTHENTICATE:01 %%	Proxy-Authenticate
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE_EXIST.PX', 'CA:' => 'Proxy-Authenticate',
   'OK:' => "A Proxy-Authenticate header field MUST exist.", 
   'NG:' => "A Proxy-Authenticate header field MUST exist.", 
   'EX:' => \'FFIsExistHeader("Proxy-Authenticate",@_) eq 1'},

 # %% PROXY-AUTHENTICATE:02 %%	Digest
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE.DIGEST', 'CA:' => 'Proxy-Authenticate',
   'OK:' => "The Proxy-Authenticate header field MUST use the \"Digest\" authentication mechanism.", 
   'NG:' => "The Proxy-Authenticate header field MUST use the \"Digest\" authentication mechanism.", 
   'PR:' => \'FFIsExistHeader("Proxy-Authenticate",@_) eq 1',  ## 2006.7.31 sawada add ##
   'EX:' => \\'HD.Proxy-Authenticate.val.digest'},

 # %% PROXY-AUTHENTICATE:03 %%	nonce
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE-NONCE.EXIST', 'CA:' => 'Proxy-Authenticate',
   'OK:' => "The Proxy-Authenticate header field MUST include the nonce parameter.", 
   'NG:' => "The Proxy-Authenticate header field MUST include the nonce parameter.", 
   'PR:' => \'FFIsExistHeader("Proxy-Authenticate",@_) eq 1',  ## 2006.7.31 sawada add ##
   'EX:' => \\'HD.Proxy-Authenticate.val.digest.nonce'},

 # %% PROXY-AUTHENTICATE:04 %%	realm
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE-REALM.EXIST', 'CA:' => 'Proxy-Authenticate',
   'OK:' => "The Proxy-Authenticate header field MUST include the realm parameter.", 
   'NG:' => "The Proxy-Authenticate header field MUST include the realm parameter.", 
   'PR:' => \'FFIsExistHeader("Proxy-Authenticate",@_) eq 1',  ## 2006.7.31 sawada add ##
   'EX:' => \\'HD.Proxy-Authenticate.val.digest.realm'},
 
 # %% PROXY-AUTHENTICATE:05 %%	qop
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE-QOP.AUTH', 'CA:' => 'Proxy-Authenticate',
   'OK:' => \\'The qop(%s) parameter must include \"auth\"(with quotation marks).', 
   'NG:' => \\'The qop(%s) parameter must include \"auth\"(with quotation marks).', 
   'PR:' => \'FFIsExistHeader("Proxy-Authenticate",@_) eq 1',  ## 2006.7.31 sawada add ##
   'EX:' => \q{FFIsMatchStr('["\,]auth["$\,\s]',\\\'HD.Proxy-Authenticate.val.digest.qop','','',@_)}},


 # %% PROXY-AUTHENTICATE:06 %%	algorithm
 # 
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.P-AUTHENTICATE-ALGORITHM.MD5', 'CA:' => 'Proxy-Authenticate',
   'OK:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.', 
   'NG:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.', 
   'PR:' => \\'HD.Proxy-Authenticate.val.digest.algorithm',
   'EX:' => \q{FFop('eq',\\\'HD.Proxy-Authenticate.val.digest.algorithm','MD5',@_)}},

 # %% AUTHENTICATE:01 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_EXIST.PX', 'CA:' => 'WWW-Authenticate',
   'OK:' => "A WWW-Authenticate header field MUST exist.",
   'NG:' => "A WWW-Authenticate header field MUST exist.",
   'EX:' => \'FFIsExistHeader("WWW-Authenticate",@_) eq 1'},

 # %% AUTHENTICATE:02 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_DIGEST', 'CA:' => 'WWW-Authenticate',
   'OK:' => "The WWW-Authenticate header field MUST use the \"Digest\" authentication mechanism.",
   'NG:' => "The WWW-Authenticate header field MUST use the \"Digest\" authentication mechanism.",
   'PR:' => \'FFIsExistHeader("WWW-Authenticate",@_) eq 1',  ## 2006.7.31 sawada add ##
   'EX:' => \\'HD.WWW-Authenticate.val.digest'},

 # %% AUTHENTICATE:03 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_NONCE.EXIST', 'CA:' => 'WWW-Authenticate',
   'OK:' => "The WWW-Authenticate header field MUST include the nonce parameter.",
   'NG:' => "The WWW-Authenticate header filed MUST include the nonce parameter.",
   'PR:' => \'FFIsExistHeader("WWW-Authenticate",@_) eq 1',  ## 2006.7.31 sawada add ##
   'EX:' => \\'HD.WWW-Authenticate.val.digest.nonce'},

 # %% AUTHENTICATE:04 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_REALM.EXIST', 'CA:' => 'WWW-Authenticate',
   'OK:' => "The WWW-Authenticate header field MUST include realm parameter.",
   'NG:' => "The WWW-Authenticate header field MUST include realm parameter.",
   'PR:' => \'FFIsExistHeader("WWW-Authenticate",@_) eq 1',  ## 2006.7.31 sawada add ##
   'EX:' => \\'HD.WWW-Authenticate.val.digest.realm'},

 # %% AUTHENTICATE:05 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH_QOP.AUTH', 'CA:' => 'WWW-Authenticate',
   'OK:' => \\'The qop(%s) parameter must be \"auth\"(with quotation marks).',
   'NG:' => \\'The qop(%s) parameter must be \"auth\"(with quotation marks).',
   'PR:' => \'FFIsExistHeader("WWW-Authenticate",@_) eq 1',  ## 2006.7.31 sawada add ##
   'EX:' => \q{FFIsMatchStr('["\,]auth["$\,\s]',\\\'HD.WWW-Authenticate.val.digest.qop','','',@_)}},

 # %% AUTHENTICATE:06 %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.WWW-AUTH-ALGORITHM.MD5', 'CA:' => 'WWW-Authenticate',
   'OK:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.',
   'NG:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.',
   'PR:' => \\'HD.WWW-Authenticate.val.digest.algorithm',
   'EX:' => \q{FFop('eq',\\\'HD.WWW-Authenticate.val.digest.algorithm','MD5',@_)}},

 # %% DATE:01 %%	Date
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.DATE_EXIST', 'CA:' => 'Date',
   'OK:' => "A Date header field SHOULD exist.", 
   'NG:' => "A Date header field SHOULD exist.", 
   'RT:' => "warning", 
   'EX:' => \'FFIsExistHeader("Date",@_)'},

 # %% DATE:02 %%        
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.DATE_TIMEZONE_GMT', 'CA:' => 'Date',
   'OK:' => "The time zone in the Date header field must be \"GMT\".", 
   'NG:' => "The time zone in the Date header field must be \"GMT\".", 
   'PR:' => \q{FFIsExistHeader("Date",@_)},
   'EX:' => \q{FFIsMatchStr('GMT',FV('HD.Date.val.zone',@_))}},

 # %% Record-Route:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RE-ROUTE_ORIGINAL-RE-ROUTE', 'CA:' => 'Record-Route',
   'OK:' => \\'The Record-Route header field(%s) MUST equal the Record-Route(%s) in the original message.', 
   'NG:' => \\'The Record-Route header field(%s) MUST equal the Record-Route(%s) in the original message.', 
   'EX:' => \q{FFop('eq',
   		join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)}),
   		join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt','',NDPKT(@_[1]))}),
		@_),
   	}},
   	
 # %% ROUTE:nn %%	Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_PSEUDO_PROXY_URI', 'CA:' => 'Route',
   'OK:' => \\'The Route header field(%s) MUST equal the SIP-URI(%s) of the proxy(tester emuating).', 
   'NG:' => \\'The Route header field(%s) MUST equal the SIP-URI(%s) of the proxy(tester emuating).', 
   'EX:' => \q{FFop('eq',FV('HD.Route.val.route.ad.ad.txt',@_),NINF('DLOG.RouteSet#0'),@_)}},

 # %% Contact-Expires:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-EXPIRES_VALUE-NOTCOLLECTLY', 'CA:' => 'Contact-Expires',
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
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT_NOEXIST', 'CA:' => 'Contact',
   'OK:' => "The Contact header field MUST not exist.",
   'NG:' => "The Contact header field MUST not exist.",
   'EX:' => \q{!FFIsExistHeader("Contact",@_)}}, 

 # %% Contact:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-URI_REGISTER-CONTACT-URI', 'CA:' => 'Contact',
   'OK:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
   'NG:' => \\'The URI(%s) in the Contact field MUST equal the local URI(%s) of the Tester.',
   'PR:' =>\'FFIsExistHeader("Contact",@_)',  ## 2006.7.31 sawada add ##
   'EX:' => \q{FFop('eq',Cutexpires(Cuttransport(FV('HD.Contact.val.contact.ad.ad.txt',@_))),NINF('LocalContactURI','LocalPeer'),@_)}},

 # %% Contact:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES', 'CA:' => 'Contact-Expires',
   'OK:' => \\'The expires parameter(%s) MUST equal the register-expires header field value(%s).',
   'NG:' => \\'The expires parameter(%s) MUST equal the register-expires header field value(%s).',
   'PR:' =>\'FFIsExistHeader("Contact",@_)',  ## 2006.7.31 sawada add ##
   'EX:' => \q{if(FV('HD.Contact.val.contact.param.expires=',@_) ne ''){FFop('eq',FV('HD.Contact.val.contact.param.expires=',@_),FVib('send','','','HD.Expires.val.seconds'),@_)}else{FFop('eq',Cutexpires_param(FV('HD.Contact.val.contact.ad.ad.param.other-param',@_)),FVib('send','','','HD.Expires.val.seconds'),@_)}}},

 # %% Contact:nn %% Contact-expires check is exist only
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES-EXIST', 'CA:' => 'Contact-Expires',
   'OK:' => \\'The expires parameter MUST exist. The value is (%s).',
   'NG:' => \\'The expires parameter MUST exist.',
   'PR:' =>\'FFIsExistHeader("Contact",@_)',  ## 2006.7.31 sawada add ##
#   'EX:' => \q{FFop('ne',FV('HD.Contact.val.contact.param.expires=',@_),'',@_)}},   ## 2006.7.25 sawada del ##
   'EX:' => sub {  ## 2006.7.25 sawada add ##
       my($param,$ExpiresVal);
#       printf("value=%s",FV('HD.Contact.val.contact.txt',@_));
#       printf "\n";
       $param=FVSeparete('HD.Contact.val.contact.txt',';','',@_[1]);
#       PrintVal ($param);
#       printf "\n";
       $ExpiresVal=FFGetMatchStr('expires=(.*)',$param,'','');
#       PrintVal($Expires);
#       printf("\n");
       FFop('ne',$ExpiresVal,'',@_);
   }},  ####

 # %% Record-Route:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.RECORD-ROUTE_ORIGINAL-RECORD-ROUTE', 'CA:' => 'Record-Route',
   'OK:' => \\'The record-route(%s) MUST equal the record-route(%s) in the original massage.',
   'NG:' => \\'The record-route(%s) MUST equal the record-route(%s) in the original message.',
   'EX:' => \q{FFop('eq',
   		join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)}),
   		join(', ', @{FVs('HD.Record-Route.val.route.ad.ad.txt','',NDPKT(@_[1]))}),
		@_),
   	}},



 # %% Proxy-Authorization:nn %%
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.PROXY-AUTH_REMOVE-TOPMOST', 'CA:' => 'Proxy-Authorization',
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
 { 'TY:' => 'RULESET', 'ID:' => 'SS.FORWARD_REQUEST_COMPARE', 
   'RR:' => [
              'S.TO-URI_ORIGINAL-TO-URI',
              'S.TO-TAG_ORIGINAL-TO-TAG', 
              'S.FROM-URI_ORIGINAL-FROM-URI', 
              'S.FROM-TAG_ORIGINAL-FROM-TAG', 
              'S.CSEQ-SEQNO_ORIGINAL-SEQNO', 
              'S.MAX-FORWARDS_DECREMENT', 
              'S.CNTLENGTH_ORIGINAL-CNTLENGTH', 
              'S.BODY_ORIGINAL-BODY', 
            ]
 }, 

 # %% Forward response %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SS.FORWARD_RESPONSE_COMPARE', 
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
 { 'TY:' => 'RULESET', 'ID:' => 'SS.FORWARD_HEADERS', 
   'RR:' => [
              'S.VIA_INSERT-NEWVIA-LINE', 
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE', 
              ## 'S.VIA_TWOPX_SEND_EQUALS.VI', 
            ]
 }, 

 # %% Forward from PX %%	
 { 'TY:' => 'RULESET', 'ID:' => 'SS.FORWARD_HEADERS_FROM_PX', 
   'RR:' => [
              'S.VIA_INSERT-NEWVIA-LINE', 
              'S.VIA-RECEIVED_EXIST_2ND_FROM_PX', 
              ## 'S.VIA_TWOPX_SEND_EQUALS.VI', 
            ]
 }, 
 # %% Proxy-Authenticate %%	Proxy-Authenticate
 { 'TY:' => 'RULESET', 'ID:' => 'SS.DIGEST-AUTH_CHALLENGE.PX', 
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
 { 'TY:' => 'RULESET', 'ID:' => 'SS.DIGEST-AUTH_CHALLENGE.RG', 
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
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.200-ACK_FORWARDED.ONEPX.TM', 
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
			  'S.RFC3261-8-82_Require',
			  'S.RFC3261-8-82_Proxy-Require',
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
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
              #'S.RECORD-ROUTE_ADD-PROXY-URI',
             'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
             'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
               'S.P-AUTH_NOTEXIST',
            ]
 }, 
 
  # %% PX-1-1-1 02 %%	UA1 receives BYE(forwarded).
  # 20050309 tadokoro
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.BYE_FORWARDED.ONEPX.TM', 
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
            #  'S.MAX-FORWARDS_DECREMENT',	
				# deleted by Horisawa (2005.12.26), 
				#  because this rule is included in SS.FORWARD_REQUEST_COMPARE
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
         #     'S.CSEQ-SEQNO_ORIGINAL-SEQNO',
				# deleted by Horisawa (2005.12.26), 
				#  because this rule is included in SS.FORWARD_REQUEST_COMPARE
              'S.MUSTNOT-HEADER_BYE',
              'SS.FORWARD_REQUEST_COMPARE',
              #'SS.FORWARD_HEADERS_FROM_PX', # 20050309 disable tadokoro
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              # 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX',
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
              'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
             'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
             'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo

            ]
 }, 
 
  # %% PX-1-1-1 03 %%  UA1 receives INVITE(forwarded)[re-vesion]
  # 20050309 tadokoro 
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.ONEPX.TM',
    'RR:' => [
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              #'SSet.URICompMsg',                 # 20050225 disable tadokoro
              # 'S.R-URI_REMOTE-URI',             # disable from SSet.URICompMsg
              'S.FROM-URI_REMOTE-URI',            # from SSet.URICompMsg
              'S.TO-URI_LOCAL-URI',               # from SSet.URICompMsg
              'S.CONTACT-URI_REMOTE-CONTACT-URI', # from SSet.URICompMsg
              #'S.R-URI_TO-URI',                  # 20050225 disable tadokoro
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
               'S.P-AUTH_NOTEXIST',
              'SS.FORWARD_REQUEST_COMPARE',
             #'S.R-URI_ORIGINAL-R-URI', # 20050225 disable tadokoro
              #'SS.FORWARD_HEADERS_FROM_PX', # 20050309 disable tadokoro
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              # 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX',# remove
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
             #'S.R-URI_REMOTE-AOR_OR_CONTACT-URI', # not yet
             'S.R-URI_REMOTE-CONTACT-URI', # 200500226 tadokoro remove if upper rule created
             'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 tadokoro
             'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
             'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro             
            ]
 },

  # %% PX-1-1-1 03 %%  UA1 receives INVITE(forwarded)[re-vesion]
  # 20050309 tadokoro 
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.ONEPX.ADD-MAXFORWARDS.TM',
    'RR:' => [
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              #'SSet.URICompMsg',                 # 20050225 disable tadokoro
              # 'S.R-URI_REMOTE-URI',             # disable from SSet.URICompMsg
              'S.FROM-URI_REMOTE-URI',            # from SSet.URICompMsg
              'S.TO-URI_LOCAL-URI',               # from SSet.URICompMsg
              'S.CONTACT-URI_REMOTE-CONTACT-URI', # from SSet.URICompMsg
              #'S.R-URI_TO-URI',                  # 20050225 disable tadokoro
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
#              'SS.FORWARD_REQUEST_COMPARE',
             #'S.R-URI_ORIGINAL-R-URI', # 20050225 disable tadokoro
              #'SS.FORWARD_HEADERS_FROM_PX', # 20050309 disable tadokoro
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              # 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX',# remove
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
             #'S.R-URI_REMOTE-AOR_OR_CONTACT-URI', # not yet
             'S.R-URI_REMOTE-CONTACT-URI', # 200500226 tadokoro remove if upper rule created
             'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 tadokoro
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro             
            ]
 },


  # %% PX-1-1-1 03 %%  UA1 receives INVITE(forwarded)[re-vesion]
  # 20050309 tadokoro 
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.ONEPX.R-URI-PARAMETER.TM',
    'RR:' => [
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
	      'S.R-URI-METHOD_NOT-EXIST',
	      'S.R-URI-SUBJECT_NOT-EXIST',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.FROM-TAG_EXIST',
              'S.CSEQ-METHOD_REQLINE-METHOD',
              #'SSet.URICompMsg',                 # 20050225 disable tadokoro
              # 'S.R-URI_REMOTE-URI',             # disable from SSet.URICompMsg
              'S.FROM-URI_REMOTE-URI',            # from SSet.URICompMsg
              'S.TO-URI_LOCAL-URI',               # from SSet.URICompMsg
              'S.CONTACT-URI_REMOTE-CONTACT-URI', # from SSet.URICompMsg
              #'S.R-URI_TO-URI',                  # 20050225 disable tadokoro
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
              #'SS.FORWARD_HEADERS_FROM_PX', # 20050309 disable tadokoro
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              # 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX',# remove
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
             #'S.R-URI_REMOTE-AOR_OR_CONTACT-URI', # not yet
             'S.R-URI_REMOTE-CONTACT-URI', # 200500226 tadokoro remove if upper rule created
             'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 tadokoro
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro             
            ]
 },


  # %% PX-1-1-1 03 %%  UA1 receives INVITE(forwarded)[re-vesion]
  # 20050309 tadokoro 
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.ONEPXwithNEWHEADER.TM',
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
              #'S.R-URI_TO-URI',                  # 20050225 disable tadokoro
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
              #'SS.FORWARD_HEADERS_FROM_PX', # 20050309 disable tadokoro
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              # 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX',# remove
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
             #'S.R-URI_REMOTE-AOR_OR_CONTACT-URI', # not yet
             'S.R-URI_REMOTE-CONTACT-URI', # 200500226 tadokoro remove if upper rule created
             'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 tadokoro
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro             
	     'S.NEWHEADER_EXIST', # 20050719 add kenzo
            ]
 },


 
  # %% PX-1-1-1 03 %%  UA1 receives INVITE(forwarded)[re-vesion]
  # 20050309 tadokoro 
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.NEWMETHOD_FORWARDED.ONEPX.TM',
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
              #'S.R-URI_TO-URI',                  # 20050225 disable tadokoro
              'S.CONTACT_EXIST',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CSEQ-METHOD_NEWMETHOD',
              'S.SUPPORTED_EXIST',
              'S.ALLOW_EXIST',
              'S.BODY_EXIST',
              'SSet.SDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
             #'S.TO-TAG_NOEXIST',[DELETE BY WATANABE 2005/01/20]
              'SS.FORWARD_REQUEST_COMPARE',
             #'S.R-URI_ORIGINAL-R-URI', # 20050225 disable tadokoro
              #'SS.FORWARD_HEADERS_FROM_PX', # 20050309 disable tadokoro
              'S.VIA_INSERT-NEWVIA-LINE',    # from SS.FORWARD_HEADERS_FROM_PX
              # 'S.VIA-RECEIVED_EXIST_2ND_FROM_PX',# remove
              'S.VIA-RECEIVED_EXIST_2ND_REMOTE',# 20050309 add tadokoro
             #'S.R-URI_REMOTE-AOR_OR_CONTACT-URI', # not yet
             'S.R-URI_REMOTE-CONTACT-URI', # 200500226 tadokoro remove if upper rule created
             'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 tadokoro
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro             
            ]
 },

 
 # %% PX-1-1-2 01 %%	UA receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-407.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.DIGEST-AUTH_CHALLENGE.PX',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 


 # %% PX-3-1-14_2 01 %%	UA receives 407 with NewHeader field
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITEwithNEWHEADER-407.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.DIGEST-AUTH_CHALLENGE.PX',
              'S.PORT-SIGNAL_DEFAULTS',
	      'S.NEWHEADER_EXIST',
            ]
 }, 


 
 # %% PX-3-1-5 01 %%	UA receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-4XX.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 

 # %% PX-3-1-14 01 %%	UA receives 5XX Response
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-5XX.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 


 # %% PX-1-1-2 02' %%   Proxy receives INVITE(forwarded)[re-version]
   { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.PX',
     'RR:' => [
               'SSet.ALLMesg',
               'S.VIA-URI_HOSTNAME',
               'S.VIA-TRANSPORT_UDP',
               'S.R-URI_NOQUOTE',
               'S.R-LINE_VERSION',
               'S.MAX-FORWARDS_EXIST',
#               'S.MAX-FORWARDS_DECREMENT',
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
	       'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
	       'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
               'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 },

 # %% PX-1-1-2 03 %%    UA1 receives receives 100 Trying
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-100.TM', 
   'RR:' => [
              ### SSet.STATUS.INVITE-100.NOPX 
              'SSet.STATUS.INVITE-100.NOPX', 
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]       
 }, 

 # %% PX-1-1-2 04 %%	UA1 receives 180 Ringing.
 # modified by Horisawa, 2005.12.22
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-180.TM', 
   'RR:' => [
              ### SSet.STATUS.INVITE-180.NOPX 
              'SSet.STATUS.INVITE-180.NOPX', 
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.FORWARD_RESPONSE_COMPARE',
              'S.VIA_REMOVE-TOPMOST',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
			  'D.COMMON.FIELD.STATUS',  # 20051222 add horisawa
            ]
 }, 

 # %% PX-1-1-2 05 %%	UA1 receives 200 OK.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-200.TM', 
   'RR:' => [
              ### SSet.STATUS.INVITE.NOPX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
#              'S.TO-TAG_REMOTE-TAG',
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
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro     
            ]
 }, 

 # %% PX-1-1-2 06 %%	Proxy receives ACK for 200 OK(forwarded).

 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.200-ACK_FORWARDED.PX', 
    'RR:' => [
               ### SSet.REQUEST.200-ACK.PX 
               #'SSet.ACK',
               'SSet.ALLMesg',
               'S.VIA-URI_HOSTNAME',
               'S.VIA-TRANSPORT_UDP',
               'S.R-URI_NOQUOTE',
               'S.R-LINE_VERSION',
               'S.MAX-FORWARDS_EXIST',
#               'S.MAX-FORWARDS_DECREMENT',
               'S.FROM-TAG_EXIST',
               'S.CSEQ-METHOD_REQLINE-METHOD',
               'S.MUSTNOT-HEADER_ACK',
			   'S.RFC3261-8-82_Require',
			   'S.RFC3261-8-82_Proxy-Require',
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
	       'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
	       'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
            ]
 }, 

 # %% PX-1-1-2 07 %%	UA1 receives BYE(forwarded).
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.BYE_FORWARDED.TWOPX.TM', 
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
#               'S.MAX-FORWARDS_DECREMENT',
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
               'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
               'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
	       'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
	       'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
            ]
 }, 

 # %% PX-1-1-2 08 %%	Proxy receives 200 OK(forwarded).
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.BYE-200_FORWARDED.PX', 
   'RR:' => [
              ### SSet.REQUEST.BYE-200.PX 
             'SSet.ResMesg',
	     'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
	     'S.VIA-RECEIVED_EXIST_PX',
	     'S.VIA_ONEPX_SEND_EQUAL',
	     'S.TO-TAG_EXIST',
#	     'S.TO-TAG_REMOTE-TAG',
	     'S.CSEQ-METHOD_BYE',
             'SS.FORWARD_RESPONSE_COMPARE',
             'S.VIA_REMOVE-TOPMOST',
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # %% PX-1-1-3 01' %%  UA1 receives INVITE(forwarded)[re-vesion]
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED.TWOPX.TM',
    'RR:' => [
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              #'S.MAX-FORWARDS_DECREMENT', ## 2006.7.24 sawada del ##
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
             'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
             'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
             'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 },

 # %% PX-1-1-3 02 %%	Proxy receives receives 100 Trying
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-100.PX', 
   'RR:' => [
              ### SSet.STATUS.INVITE-100.PX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.CSEQ-METHOD_INVITE',
#              'SSet.STATUS.INVITE-100.PX', 
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # %% PX-1-1-3 03 %%	Proxy receives 180 Ringing(forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-180_FORWARDED.PX', 
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
            ]
 }, 

 # %% PX-1-1-3 04 %%	Proxy receives 200 OK(forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-200_FORWARDED.PX', 
   'RR:' => [
              ### SSet.STATUS.INVITE.PX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-ONEPX',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_ONEPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
#              'S.TO-TAG_REMOTE-TAG',
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
            ]
 }, 

 # %% PX-1-1-3 05 %%	UA1 receives ACK for 200 OK(forwarded)

 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.200-ACK_FORWARDED.TWOPX.TM', 
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
			  'S.RFC3261-8-82_Require',
			  'S.RFC3261-8-82_Proxy-Require',
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
              'SS.FORWARD_HEADERS_FROM_PX',
             'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
             'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 

 # %% PX-1-1-3 06 %%	Proxy receives BYE(forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.BYE_FORWARDED.PX', 
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
#              'S.MAX-FORWARDS_DECREMENT',
              'S.ROUTE_EXIST',
#              'S.ROUTE_NOEXIST',
              'S.ROUTE_PSEUDO_PROXY_URI',
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
              'SS.FORWARD_HEADERS',
              'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
             'S.RECORD-ROUTE.EXIST-lr-PARAM', # 20050906 kenzo
             'S.RECORD-ROUTE.EXIST-transport-PARAM', # 20050906 kenzo
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-1-3 06 %%	Proxy receives BYE(forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.BYE_FORWARDED_TO-STRICT-R.PX', 
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
#              'S.MAX-FORWARDS_DECREMENT',
              'S.ROUTE_NOEXIST',
              'S.ROUTE_PSEUDO_PROXY_URI',
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
              'SS.FORWARD_HEADERS',
              'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-1-3 07 %%	UA1 receives 200 OK(forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.BYE-200_FORWARDED.TM', 
   'RR:' => [
              ### SSet.REQUEST.BYE-200.NOPX 
              'SSet.REQUEST.BYE-200.NOPX', 
              'SS.FORWARD_RESPONSE_COMPARE',
              #'S.VIA_INSERT-NEWVIA-LINE',
              'S.VIA_REMOVE-TOPMOST',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 


 # %% RG-1-1-1 01 %%	UA1 receives 401 Unauthorized from Registrar
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-401.TM', 
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
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]

 }, 


 # %% RG-1-1-1 01 %%	UA1 receives 423 from Registrar
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-423.TM', 
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
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]

 }, 

 # %% RG-1-1-1 01 %% Ue no UA1 receives 423 from Registrar to onaji
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-4xx.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
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
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]

 }, 



 # %% RG-2-1-1 01 %%	UA1 receives 401 Unauthorized from Registrar without RR
 # ads by kenzo
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-401.WITHOUT-RR.TM', 
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
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
	      'S.RE-ROUTE_NOEXIST' , # ads by kenzo
            ]

 }, 


 # %% RG-1-1-1 02 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',  ## 2006.7.28 sawada del ##
            ]
 }, 

 # %% RG-2-1-11 02 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.TO-PARAM.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',  ## 2006.7.28 sawada del ##
	      'S.TO-PARAM_EXIST_REGISTER',
            ]
 }, 

 # %% RG-2-1-11 02 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.WITH-ESCAPED-CHAR.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',  ## 2006.7.28 sawada del ##
	      'S.TO-PARAM_EXIST_REGISTER',
            ]
 }, 



 # %% RG-2-1-1 01 %%	UA1 receives 200 OK without Record-Route header
 # ads by kenzo
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.WITHOUT-RR.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',  ## 2006.7.28 sawada del ##
	      'S.RE-ROUTE_NOEXIST' ,
            ]
 }, 

 # %% RG-2-1-2 01 %%	UA1 receives 200 OK expires parameter check is only exist.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200.EXPIRES-EXIST.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES-EXIST',
            ]
 }, 



 # %% RG-1-1-3 nn %%	UA1 receives 200 Advanst1
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-CURRENT', 
   'RR:' => [
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT-EXPIRES_VALUE-NOTCOLLECTLY',
	    ]
},

 # %% RG-1-1-1 03 %%	UA1 receives 200 BASIC
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-BASIC', 
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
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-200_DELETE.TM', 
   'RR:' => [
              ### 
              'SS.STATUS.REGISTER-BASIC', 
              'S.CONTACT_NOEXIST',
            ]
 }, 

 # %% RG-1-1-1 02 %%	UA1 receives 200 OK
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.REGISTER-500.TM', 
   'RR:' => [
              ### SSet.REQUEST.OPTIONS-200.PX 
              #'SSet.ResMesg',
              'SS.STATUS.REGISTER-BASIC',
              'S.CONTACT_EXIST',
              'S.CONTACT-URI_REGISTER-CONTACT-URI',
              'S.CONTACT_NOT-*',
              'S.CONTACT_QUOTE',
#              'S.CONTACT-EXPIRES_REGISTER-CONTACT-EXPIRES',  ## 2006.7.28 sawada del ##
            ]
 }, 



 # %% SDP %%	SDP
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.SDP', 
   'RR:' => [
            ]
 }, 

 # %% BYE %%	BYE
 { 'TY:' => 'RULESET', 'ID:' => 'SSet.BYE', 
   'RR:' => [
              'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_BYE',
              'S.R-URI_REQ-CONTACT-URI',
              'S.CSEQ-METHOD_BYE',
              'S.CSEQ-SEQNO_ORIGINAL-SEQNO',
            ]
 }, 


### Add 05/01/17 cats ###

 # %% PX-1-1-4 02 %%	UA receives 407 Proxy Authentication Required(about PX2)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-407_2NDPX.TM', 
   'RR:' => [
              ## 
              ## Proxy-Authenticate
              'SS.STATUS.INVITE-407.TM',
            ]
 }, 


 # %% PX-1-1-4 03 %%	Proxy receives INVITE with Proxy-Authorization(about 2nd Proxy)(forwarded) 
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE-AUTH_FORWARDED.PX', 
   'RR:' => [
              ## 
              ## 2
              'SSet.ALLMesg',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
#              'S.MAX-FORWARDS_DECREMENT',
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
            ]
 }, 


 # %% PX-1-1-5 01 %%	PX1 receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-407.PX', 
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
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.RE-INVITE-HOLD_FORWARDED.TM', 
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
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
              'S.VIA-RECEIVED_EXIST_2ND_FROM_PX', # 20050310 add tadokoro
            ]
 }, 

 # %% PX-1-1-7 01 %%	Proxy receives re-INVITE(forwarded). 
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.RE-INVITE-HOLD_FORWARDED.PX', 
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
            ]
 }, 

 # %% PX-1-1-8 01 %%	UA receives 200 for CANCEL
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.CANCEL-200.TM', 
   'RR:' => [
              ## SSet.STATUS.CANCEL-200.TM 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_RECENT1xx-TO-TAG',
              'S.CSEQ-METHOD_CANCEL',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-1-8 02 %%	Proxy receives CANCEL.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.CANCEL.PX', 
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
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.CANCEL-200.PX', 
   'RR:' => [
              ## SSet.STATUS.CANCEL-200.PX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-TWOPX-CANCEL',
              'S.VIA-RECEIVED_EXIST_PX',
              'S.VIA_TWOPX_SEND_EQUALS-CANCEL.VI',
              'S.TO-TAG_RECENT1xx-TO-TAG',
              'S.CSEQ-METHOD_CANCEL',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-1-9 02 %%	UA receives CANCEL.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.CANCEL.TM', 
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
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-1-9 02 %%	UA receives CANCEL.
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.CANCEL.FORK.TM', 
   'RR:' => [
              ## SSet.REQUEST.200-CANCEL.PX 
              ## Route
              ##   (SIPv6/Backup/Sequence/P3-26-1.seq
              ## 
             'SSet.ReqMesg',
              'S.MUSTNOT-HEADER_CANCEL',
              'S.R-URI_REQ-R-URI.FORK',
              'S.VIA_REQ-SINGULAR',
              'S.VIA_REQ-1STVIA-F',
              'S.VIA-BRANCH_REQ-VIA-BRANCH.FORK',
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


 # %% PX-1-2-1 01 %%	PX receives ACK for 486 response
 # %% PX-1-2-3 01 %%	PX receives ACK for 480 response
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.ACK-NO2XX.PX',
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
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.ACK-NO2XX.TM',
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
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # %% PX-1-2-2 01 %%	UA receives ACK for 486 response
 # %% PX-1-2-4 01 %%	UA receives ACK for 480 response
 # %% PX-1-2-5 01 %%	UA receives ACK for 480 response
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.ACK-NO2XX.FORK.TM',
   'RR:' => [
              ## 'SSet.REQUEST.non2xx-ACK' 
              'SSet.ACK',
              #'SSet.ACK-Non2xx',    # 20050225 disable by tadokoro
              #'S.R-URI_TO-URI',     # disable from SSet.Ack-Non2xx
              'S.R-URI_REQ-R-URI.FORK',   # from SSet.Ack-Non2xx
              'S.BODY_NOEXIST',      # from SSet.Ack-Non2xx
              'S.REQUIRE_NOEXIST',   # from SSet.Ack-Non2xx
              'S.P-REQUIRE_NOEXIST', # from SSet.Ack-Non2xx
              'S.VIA-BRANCH_REQ-VIA-BRANCH.FORK',
              'S.TO-TAG_LOCAL-TAG',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 


 # %% PX-1-2-1 02 %%	UA receives 486 response
 # %% PX-1-2-3 02 %%	UA receives 480 response
 # 20050310 add tadokoro
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-NO2XX.ONEPX.TM',
   'RR:' => [
              ## 'SSet.STATUS.INVITE-4XX.PX' 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
              'D.COMMON.FIELD.STATUS',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 
 
 # %% PX-1-2-1 02 %%	UA receives 486 response
 # %% PX-1-1-8 02 %%	UA receives 480 response
 # %% PX-1-2-3 02 %%	UA receives 486 response
 # 20050310 add tadokoro
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-NO2XX.TWOPX.TM',
   'RR:' => [
              ## 'SSet.STATUS.INVITE-4XX.PX' 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.TO-TAG_EXIST',
              'S.CSEQ-METHOD_INVITE',
              'D.COMMON.FIELD.STATUS',
              'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 }, 

 # %% PX-1-2-2 02 %%	PX receives ACK for 486 response
 # %% PX-1-2-4 02 %%	PX receives ACK for 480 response
 # %% PX-1-2-5 02 %%	PX receives ACK for 480 response
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.INVITE-NO2XX.PX',
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
            ]
 }, 


###### 


 # %% Via %%	(
 { 'TY:' => 'RULESET', 'ID:' => 'SS.VIA-FORWARD', 
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
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-1.PX',
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
			],
  },


 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-2.PX',
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
			],
  },
  
 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-3.PX',
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
			],
  },
  

  
 # %% 
 #  UA Calee receives INVITE(forwarded)
 ## SS.REQUEST.INVITE_FORWARDE.TM
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-1.TM',
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
			],
  },  
  
 # %% 
 #  UA Calee receives INVITE(forwarded)
 ## SS.REQUEST.INVITE_FORWARDE.TM
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-2.TM',
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
			],
  },  
  
 # %% 
 #  UA Calee receives INVITE(forwarded)
 ## SS.REQUEST.INVITE_FORWARDE.TM
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-3.TM',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.ONEPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.R-URI_USERINFO_1860ABJ_E164',
              'S.FROM-DISPLAYNAME_EXIST',
              'S.FROM-USERINFO_EXIST',
              'S.PRIVACY_EXIST', 
              'S.PRIVACY_VALUE_NONE',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_EXIST',
              'S.P-ASSERT-ID_GENERATE',
			],
  }, 
  
 # %% 
 #  PX2 receives INVITE(forwarded)
 ## SS.REQUEST.INVITE_FORWARDE.TM
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-NOTIFY-4.TM',
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
			],
  },   
  
 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-1.PX',
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
            ]
 },

 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-2.PX',
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
            ]
 },

 # %% 
 #  PX2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-3.PX',
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
            ]
 },
 

 
 # %% 
 #  UA2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-1.TM',
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
            ]
 },
 
 # %% 
 #  UA2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-2.TM',
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
            ]
 },

 # %% 
 #  UA2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-3.TM',
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
            ]
 },
 
 # %% 
 #  UA2 receives INVITE(forwarded)
  { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.INVITE_FORWARDED_N-BROCK-4.TM',
    'RR:' => [
              'SS.REQUEST.INVITE_FORWARDED.TWOPX.TM',
              ## Add 05/02/15 for Number Notify
              'S.FROM-DISPLAYNAME_ANONYMOUS',
              'S.FROM-URI_ANONYMOUS',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_NOGENERATE',
              'S.P-ASSERT-ID_REMOVED',
            ]
 },
 
 # %% ALLMesg %%	
 # SIPruleRFC.pm 
 # 20050309 tadokoro
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
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_ONEHOP','PT:'=>'HD', 
#  'FM:'=>'Via: SIP/2.0/UDP %s',
#  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
#               SetupViaParam($CVA_COUNT_BRANCH);
#	       return join("\r\nVia: SIP/2.0/UDP ",@CNT_ONEPX_SEND_VIAS);} ]},

## 2006.1.25 sawada  via header parameter ##
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++;
               SetupViaParam($CVA_COUNT_BRANCH);
	       return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ",@CNT_ONEPX_SEND_VIAS);} ]},

###############################################################
###
### 	2. Via
###	Via
###
###	E.VIA_NOHOP
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOHOP','PT:'=>'HD', 
#  'FM:'=>'Via: SIP/2.0/UDP %s',
#  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
#               SetupViaParam($CVA_COUNT_BRANCH);
#               return @CNT_NOPX_SEND_VIAS[0];} ]},

## 2006.1.25 sawada  via header parameter ##
  'FM:'=>'Via: SIP/2.0/%s %s',
  'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++;
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
 {'TY:'=>'ENCODE', 'ID:'=>'E.MAXFORWARDS_ONEHOP','PT:'=>'HD',
   'FM:'=>'Max-Forwards: %d','AR:'=>[\q{$CNT_CONF{'MAX-FORWARDS'}-1}]},


###############################################################
###
### 	4. Max-Forwards
###	Max-forwards: 70
###
###	E.MAXFORWARDS_NOHOP
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.MAXFORWARDS_NOHOP','PT:'=>'HD',
  'FM:'=>'Max-Forwards: %d','AR:'=>[\q{$CNT_CONF{'MAX-FORWARDS'}}]},


###############################################################
###
###	E.MAXFORWARDS_ZERO
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.MAXFORWARDS_ZERO','PT:'=>'HD',
  'FM:'=>'Max-Forwards: 0'},



###############################################################
###
### 	6. Contact
###	
###
###	E.CONTACT_URI
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI','PT:'=>'HD', 
  'FM:'=>'Contact: <%s>','AR:'=>[\q{NINF('LocalContactURI','LocalPeer')}]},

## 2006.2.1 sawada  At REGISTER, tranport parameter header filed is added to Contact header ## 
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI_REGISTER','PT:'=>'HD',
  'FM:'=>'Contact: <%s;transport=%s>','AR:'=>[\q{NINF('LocalContactURI','LocalPeer')},"\L$SIP_PL_TRNS\E"]},

### 	6-2. Contact for REGISTER to delete Registration
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI_ASTERISK','PT:'=>'HD', 
  'FM:'=>'Contact: *' },

## for RG-1-2-4
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI_RG124','PT:'=>'HD', 
  'FM:'=>'Contact: <sip:UA111@node.under.test.com>' },


###############################################################
###
### 	7. From
###	
###
###	E.FROM_LOCAL-URI_LOCAL-TAG
###
###############################################################	
# 20040203 tadokoro
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG','PT:'=>'HD', 
  'FM:'=>'From: %s<%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
				       \q{NINF('LocalAoRURI','LocalPeer')},\q{NINF('DLOG.LocalTag')}]},

# 20040714 kenzo
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_DIFFERENT-URI_LOCAL-TAG','PT:'=>'HD', 
  'FM:'=>'From: %s<%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
				       \q{NINFW('LocalAoRURI','UA11@biloxi.example.com')},\q{NINF('DLOG.LocalTag')}]},

# 20050207 overwrite from SIPrule.pm by tadokoro add $DISPNAME   
#  overwrite 'E.FROM_PUA-URI_LOCAL-TAG' in SIPruleRFC.pm
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_PUA-URI_LOCAL-TAG','PT:'=>'HD',
  'FM:'=>'From: %s<%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''}, \q{NINF('LocalAoRURI','LocalPeer')},\q{NINF('DLOG.LocalTag')}]},

# 2006.2.8 sawada ##
# From Anonymous with Display Name 
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_ANONYMOUS-URI_LOCAL-TAG','PT:'=>'HD', 
  'NX:'=>'Max-Forwards',
  'FM:'=>'From: Anonymous <%s:anonymous@anonymous.invalid>;tag=%s','AR:'=>[\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},\q{NINF('DLOG.LocalTag')}]},

# 20040204 tadokoro
# From Anonymous with Display Name 
# {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_ANONYMOUS-URI_LOCAL-TAG','PT:'=>'HD', 
#  'FM:'=>'From: Anonymous <sip:anonymous@anonymous.invalid>;tag=%s','AR:'=>[\q{NINF('DLOG.LocalTag')}]},


###############################################################
###
### 	8. To
###	
###
###	E.TO_REMOTE-URI_NO-TAG
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_NO-TAG','PT:'=>'HD', 
# 20040203 tadokoro
# To with Display Name if defined($CVA_TUA_DISPNAME)
#  'FM:'=>'To: <%s>','AR:'=>[\'$CVA_TUA_URI']},
  'FM:'=>'To: %s<%s>','AR:'=>[\q{NINF('DisplayName','RemotePeer')?NINF('DisplayName','RemotePeer') . ' ':''}, \q{NINF('LocalAoRURI','RemotePeer')}]},

## 2006.2.7 sawada ##
# To with Display Name if defined($CVA_TUA_DISPNAME)
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_ANONYMOUS_REMOTE-TAG','PT:'=>'HD',
  'NX:'=>'From',
  'FM:'=>'To: Anonymous <%s:anonymous@anonymous.invalid>;tag=%s','AR:'=>[\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},\q{NINF('DLOG.RemoteTag')}]},

# 20040204 tadokoro
# To with Display Name if defined($CVA_TUA_DISPNAME)
# {'TY:'=>'ENCODE', 'ID:'=>'E.TO_ANONYMOUS_REMOTE-TAG','PT:'=>'HD',
#  'FM:'=>'To: Anonymous <sip:anonymous@anonymous.invalid>;tag=%s','AR:'=>[\q{NINF('DLOG.RemoteTag')}]},

# 20050209 overwrite from SIPrule.pm by tadokoro add $DISPNAME
#  TO URI=TUA TAG=REMOTE 
{'TY:'=>'ENCODE', 'ID:'=>'E.TO_TUA-URI_REMOTE-TAG','PT:'=>'HD',
  'NX:'=>'From',
 'FM:'=>'To: %s<%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','RemotePeer')?NINF('DisplayName','RemotePeer') . ' ':''},\q{NINF('LocalAoRURI','RemotePeer')},\q{NINF('DLOG.RemoteTag')}]},


###############################################################
###
### 	9. To
###	
###
###	E.TO_REMOTE-URI_REMOTE-TAG
###
###############################################################	
# $CVA_TUA_URI
# NINF('DLOG.RemoteTag')
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_REMOTE-URI_REMOTE-TAG','PT:'=>'HD',
  'FM:'=>'To: %s<%s>;tag=%s','AR:'=>[\q{NINF('DisplayName','RemotePeer')?NINF('DisplayName','RemotePeer') . ' ':''},\q{NINF('LocalAoRURI','RemotePeer')},\q{NINF('DLOG.RemoteTag')}]},


###############################################################
###
### 	10. Route
###	
###
###	E.ROUTE_ONEURI
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_ONEURI','PT:'=>'HD', 
#  'PR:'=>\'FFIsExistHeader("Record-Route",@_)',
  'FM:'=>'Route: <%s>',
  'AR:'=>[\q{NINF('DLOG.RouteSet#1')}]},


###############################################################
###
### 	11. Route
###	
###
###	E.ROUTE_TWOURIS
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_TWOURIS','PT:'=>'HD', 
#  'PR:'=>\'FFIsExistHeader("Record-Route",@_,STATUS)',
  'FM:'=>'Route: <%s>',
  'AR:'=>[\q{join(">,<",@{NINF('DLOG.RouteSet#A')})}]},


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
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_RETURN_RECEIVED','PT:'=>'HD',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
			$vias=FVs('HD.Via.txt',@_);
			$hed=shift(@$vias);
			$host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
			my $str = $host->[0];
			if ($str =~ /^\[(\S+)$\]/) { $str = $1; }
			if(!IsIPAddress($str)){ $hed = 'Via:' . $hed . ';received=' . NINF('IPaddr','PX1');}
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
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_RETURN_RECEIVED_TWOPX.TM','PT:'=>'HD',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
	       $vias=FVs('HD.Via.txt',@_);
               $hed=shift(@$vias);
               $host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
               # if(!IsIPAddress($host->[0])){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX1_IPADDRESS;}	# 20050427 usako delete
### 20050427 usako add start ###
				my $str = $host->[0];
				if ($str =~ /^\[(\S+)$\]/) { $str = $1; }
                if(!IsIPAddress($str)){ $hed = 'Via:' . $hed . ';received=' . NINF('IPaddr','PX1');}
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
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_INVITE-RETURN_RECEIVED','PT:'=>'HD',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
	       $vias=FVib('recv','','','HD.Via.txt','RQ.Request-Line.method','INVITE');
               $hed=shift(@$vias);
               $host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
               # if(!IsIPAddress($host->[0])){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX2_IPADDRESS;}	# 20050427 usako delete
### 20050427 usako add start ###
	       my $str = $host->[0];
	       if ($str =~ /^\[(\S+)$\]/) { $str = $1; }
                if(!IsIPAddress($str)){ $hed = 'Via:' . $hed . ';received=' . NINF('IPaddr','PX1');}
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
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM','PT:'=>'HD',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
	       $vias=FVib('recv','','','HD.Via.txt','RQ.Request-Line.method','INVITE');
               $hed=shift(@$vias);
               $host=GetSIPParseField('via.sendby.host',$hed,\%STVia);
               # if(!IsIPAddress($host->[0])){ $hed = 'Via:' . $hed . ';received=' . $CVA_PX1_IPADDRESS;}	# 20050427 usako delete
### 20050427 usako add start ###
				my $str = $host->[0];
				if ($str =~ /^\[(\S+)$\]/) { $str = $1; }
                if(!IsIPAddress($str)){ $hed = 'Via:' . $hed . ';received=' . NINF('IPaddr','PX1');}
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
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_TWOHOPS','PT:'=>'HD', 
  'PR:'=>\'FFIsExistHeader("Record-Route",@_)',
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[\q{join(">,<",@{NINF('DLOG.RouteSet#A')})}]},

###############################################################
###
### 	19-2. Record-Route
###	Record-Route
###
###	E.RECORDROUTE_ONEHOP    2005/01/11 by Mizusawa
###                             2006/01/13 
###                             
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_ONEHOP','PT:'=>'HD', 
#  'PR:'=>\'FFIsExistHeader("Record-Route",@_)',
  'FM:'=>'Record-Route: <%s;lr>',
  'AR:'=> [\q{NINF('Uri')}]},


###############################################################
###
### 	19-2. Record-Route
###	Record-Route
###
###	E.RECORDROUTE_ONEHOP_STRICT-R    2005/01/11 by Mizusawa
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_ONEHOP_STRICT-R','PT:'=>'HD', 
  'PR:'=>\'FFIsExistHeader("Record-Route",@_)',
  'FM:'=>'Record-Route: <%s>',
  'AR:'=> [\q{NINF('Uri')}]},



###############################################################
###
### 	19-2. Record-Route
###	Record-Route
###
###	E.RECORDROUTE_REGISTER    2005/07/13 by kenzo
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_REGISTER','PT:'=>'HD', 
  'FM:'=>'Record-Route: <example.under.test.com;lr>'},



###############################################################
###
### 	19-3. Record-Route
###	Record-Route
###
###	E.RECORDROUTE_ASIS    2005/01/11 by Mizusawa
###	                      2005/02/25 by tadokoro
###
###############################################################	
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORDROUTE_ASIS','PT:'=>'HD', 
  'PR:'=>\'FFIsExistHeader("Record-Route",@_)',
  'FM:'=>'Record-Route: <%s>',
  'AR:'=> [\q{join('>,<', @{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)})}]},


# 20050224 tadokoro 
# Record-Route 
 {'TY:'=>'ENCODE', 'ID:'=>'E.RECORD-ROUTE_ADD-PROXY-URI','PT:'=>'HD', 
  'PR:'=>\'FFIsExistHeader("Record-Route",@_)',
  'FM:'=>'Record-Route: <%s>',
  'AR:'=>[sub {
		my @string = (NINF('DLOG.RouteSet#0') , @{FVs('HD.Record-Route.val.route.ad.ad.txt',@_)});
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
 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_TWOURIS_REVERSE','PT:'=>'HD', 
  'PR:'=>\'FFIsExistHeader("Record-Route",@_)',
  'FM:'=>'Route: <%s>',
  'AR:'=>[\q{join(">,<",reverse(@{NINF('DLOG.RouteSet#A')}))}]},


## add 05/01/05 cats
# Body (SDP o line version not increment)
#   for INVITE with Proxy-Authorization
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID_SAME_VERSION','PT:'=>BD,   ####  @@@@@@@'E.BODY_VALID'
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "t=0 0\r\n".
       "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n".
       "a=rtpmap:0 PCMU/8000"},
  'AR:'=>[\q{NINF('SDP_o_Version','LocalPeer')}]
},


# REGISTER
# 
# 	-->	E.REGISTER_RG-URI

## 2006.2.7 sawada ##
# REGISTER Request-URI = SIP-URI of Registrar
 {'TY:'=>'ENCODE', 'ID:'=>'E.REGISTER_RG-URI','PT:'=>RQ,
  'FM:'=>'REGISTER %s:%s:%s SIP/2.0','AR:'=>[\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},\q{$CNT_CONF{'REG-HOSTNAME'}}, \q{NINF('SIPPort','PX1')}]},

# REGISTER Request-URI = SIP-URI of Registrar
# {'TY:'=>'ENCODE', 'ID:'=>'E.REGISTER_RG-URI','PT:'=>RQ,
#  'FM:'=>'REGISTER sip:%s:%s SIP/2.0','AR:'=>[\q{$CNT_CONF{'REG-HOSTNAME'}}, \q{NINF('SIPPort','PX1')}]},

# Expires
# 
#	-->	E.EXPIRES_VALID

# Expires header
 {'TY:'=>'ENCODE', 'ID:'=>'E.EXPIRES_VALID','PT:'=>'HD',
  'FM:'=>'Expires: %s', 'AR:'=>[\q{$CNT_CONF{'EXPIRES'}}] },

# Expires header
 {'TY:'=>'ENCODE', 'ID:'=>'E.EXPIRES_VALID_MIN','PT:'=>'HD',
  'FM:'=>'Expires: %s', 'AR:'=>['30']},

# Expires header
 {'TY:'=>'ENCODE', 'ID:'=>'E.EXPIRES_ZERO','PT:'=>'HD',
  'FM:'=>'Expires: 0' },

## Modify 05/01/06 cats
#  To header for Register
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_RG-URI_NO-TAG','PT:'=>'HD', 
  'FM:'=>'To: %s<%s>','AR:'=>[\q{NINF('DisplayName')?NINF('DisplayName') . ' ':''}, \q{NINF('LocalAoRURI')}]},

#  To header for Register. Modify from kenzo 05.07.14
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_RG-DIFFERENT-URI_NO-TAG','PT:'=>'HD', 
  'FM:'=>'To: %s<UA11@biloxi.example.com>','AR:'=>[\q{NINF('DisplayName')?NINF('DisplayName') . ' ':''}]},

#  To header for Register. Modify from kenzo 05.07.14
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_RG-URI_NO-TAG_WITH-PARAM','PT:'=>'HD', 
  'FM:'=>'To: %s<%s;user=phone>','AR:'=>[\q{NINF('DisplayName')?NINF('DisplayName') . ' ':''}, \q{NINF('LocalAoRURI')}]},

## 2006.2.7 sawada ##
#  To header for Register with escaped character. Modify from kenzo.
# {'TY:'=>'ENCODE', 'ID:'=>'E.TO_RG-URI_WITH-ESCAPED-CHAR_NO-TAG','PT:'=>'HD', 
#  'FM:'=>'To: %s<%s:U%%6511@under.test.com>','AR:'=>[\q{NINF('DisplayName')?NINF('DisplayName') . ' ':''},\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"}]},

#  To header for Register with escaped character. Modify from kenzo.
# {'TY:'=>'ENCODE', 'ID:'=>'E.TO_RG-URI_WITH-ESCAPED-CHAR_NO-TAG','PT:'=>'HD', 
#  'FM:'=>'To: %s<sip:U%%6511@under.test.com>','AR:'=>[\q{NINF('DisplayName')?NINF('DisplayName') . ' ':''}]},



# Authorization
# 
# $CNT_AUTH_URI_RG 
# 	-->	E.AUTH_RESPONSE_VALID

# Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.AUTH_RESPONSE_QOP','PT:'=>'HD',
  'PR:'=>\q{NDCFG(use_authorization) eq 'yes' && FVib('recv','','','HD.WWW-Authenticate.val.digest.qop','RQ.Status-Line.code','401') eq '"auth"'},
  'FM:'=>"Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s:%s:%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{FVib('recv','','','HD.WWW-Authenticate.val.digest.realm','RQ.Status-Line.code','401')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"}, ## 2006.2.8 sawada add #
	   \q{$CNT_CONF{'REG-HOSTNAME'}},
	   \q{NINF('SIPPort','PX1')},
           \q{OpCalcAuthorizationResponse3('WWW-Authenticate','REGISTER',NINF('AuthUserName'),
					   (($SIP_PL_TRNS eq "TLS")?"sips":"sip").":$CNT_CONF{'REG-HOSTNAME'}:".NINF('SIPPort','PX1'),  ## 2006.2.8 sawada ##
					   $CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_[0],
					   PKT('LAST','recv','RQ.Status-Line.code','401'),@_[2])},
         ] },
 {'TY:'=>'ENCODE', 'ID:'=>'E.AUTH_RESPONSE_NOQOP','PT:'=>'HD','NX:'=>'Max-Forwards',
  'PR:'=>\q{NDCFG(use_authorization) eq 'yes' && !grep(/(auth|auth\-int|auth\,auth\-int)/,FVib('recv','','','HD.WWW-Authenticate.val.digest.qop','RQ.Status-Line.code','401'))} ,
  'FM:'=>"Authorization: Digest username=%s, realm=%s, nonce=%s, opaque=%s, uri=\"%s:%s:%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{FVib('recv','','','HD.WWW-Authenticate.val.digest.realm','RQ.Status-Line.code','401')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"}, ## 2006.2.8 sawada add #
	   \q{$CNT_CONF{'REG-HOSTNAME'}},
	   \q{NINF('SIPPort','PX1')},
           \q{OpCalcAuthorizationResponse3('WWW-Authenticate','REGISTER',NINF('AuthUserName'),
					   (($SIP_PL_TRNS eq "TLS")?"sips":"sip").":$CNT_CONF{'REG-HOSTNAME'}:".NINF('SIPPort','PX1'), ## 2006.2.8 sawada ##
                                           $CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'noauth',@_[0],
                                           PKT('LAST','recv','RQ.Status-Line.code','401'),@_[2])},
         ] },

# Proxy-Authorization
# Proxy-Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_QOP','PT:'=>'HD', 'NX:'=>'Max-Forwards',
  'PR:'=>\q{NDCFG(use_authorization) eq 'yes' && FVib('recv','','','HD.Proxy-Authenticate.val.digest.qop','RQ.Status-Line.code','407') eq '"auth"'},
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{NINF('AuthRealm')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \q{NINF('LocalAoRURI','RemotePeer')},          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',NINF('AuthUserName'),NINF('LocalAoRURI','RemotePeer'),$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_[0],PKT('LAST','recv','RQ.Status-Line.code','407'),@_[2])},
         ] },

# Proxy-Authorization header valid (qop=auth) for FW-1-2-5
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_QOP_NO_Max-Forwards','PT:'=>'HD',
  'PR:'=>\q{NDCFG(use_authorization) eq 'yes' && FVib('recv','','','HD.Proxy-Authenticate.val.digest.qop','RQ.Status-Line.code','407') eq '"auth"'},
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{NINF('AuthRealm')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \q{NINF('LocalAoRURI','RemotePeer')},          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',NINF('AuthUserName'),NINF('LocalAoRURI','RemotePeer'),$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_[0],PKT('LAST','recv','RQ.Status-Line.code','407'),@_[2])},
         ] },




# 20050531 make for No_Auth_ACk
# add by kenzo
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_QOP_MODE_DEP','PT:'=>HD,
  'PR:'=>\q{NDCFG(use_authorization) eq 'yes' && FVib('recv','','','HD.Proxy-Authenticate.val.digest.qop','RQ.Status-Line.code','407') eq '"auth"'},
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{NINF('AuthRealm')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \q{NINF('LocalAoRURI','RemotePeer')},          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',NINF('AuthUserName'),NINF('LocalAoRURI','RemotePeer'),$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_[0],PKT('LAST','recv','RQ.Status-Line.code','407'),@_[2])},
         ] },
# end kenzo


 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_NOQOP','PT:'=>'HD',
  'PR:'=>\q{NDCFG(use_authorization) eq 'yes' && FVib('recv','','','HD.Proxy-Authenticate.val.digest.qop','RQ.Status-Line.code','407') ne '"auth"'},
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, nonce=%s, opaque=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{NINF('AuthRealm')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \q{NINF('LocalAoRURI','RemotePeer')},          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',NINF('AuthUserName'),NINF('LocalAoRURI','RemotePeer'),$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'noauth',@_[0],PKT('LAST','recv','RQ.Status-Line.code','407'),@_[2])},
         ] },

# 20050531 For make No_Auth_ACK
# add by kenzo
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_NOQOP_MODE_DEP','PT:'=>HD,
  'PR:'=>\q{NDCFG(use_authorization) eq 'yes' && FVib('recv','','','HD.Proxy-Authenticate.val.digest.qop','RQ.Status-Line.code','407') ne '"auth"'},
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, nonce=%s, opaque=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{NINF('AuthRealm')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \q{NINF('LocalAoRURI','RemotePeer')},          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',NINF('AuthUserName'),NINF('LocalAoRURI','RemotePeer'),$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'noauth',@_[0],PKT('LAST','recv','RQ.Status-Line.code','407'),@_[2])},
         ] },
# end kenzo


#20050118 
# Proxy-Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_VALID','PT:'=>'HD',
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{NINF('AuthRealm')},    # realm
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \q{NINF('LocalAoRURI','RemotePeer')},          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',NINF('AuthUserName'),NINF('LocalAoRURI','RemotePeer'),$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_)},
         ] },

#add 20050114 2
# 2nd Proxy-Authorization header valid (qop=auth)
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_VALID_2ND','PT:'=>'HD',
  'FM:'=>"Proxy-Authorization: Digest username=%s, realm=%s, qop=auth, nonce=%s, opaque=%s, nc=%s, cnonce=%s, uri=\"%s\", response=%s",
  'AR:'=>[ \q{NINF('AuthUserName')}, # username
           \q{NINF('AuthRealm','PX2')},# realm  20050114 2
           \'$CNT_AUTH_NONCE',       # nonce
           \'$CNT_AUTH_OPAQUE?$CNT_AUTH_OPAQUE:"\"\""',      # opaque
           \'$CNT_AUTH_NONCECOUNT',  # nc
           \'$CNT_AUTH_CNONCE',      # cnonce
           \q{NINF('LocalAoRURI','RemotePeer')},          # uri
           \q{OpCalcAuthorizationResponse3('Proxy-Authenticate','INVITE',NINF('AuthUserName'),NINF('LocalAoRURI','RemotePeer'),$CNT_AUTH_NONCECOUNT,$CNT_AUTH_CNONCE,'auth',@_)},
         ] },

#20050118  2
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_VALID_READ','PT:'=>'HD',
  'FM:'=>'Proxy-Authorization: %s', 'AR:'=>[\q{FVib('send','','','HD.Proxy-Authorization.val.txt','RQ.Request-Line.method','INVITE')}] },



## 20050119 
## UA
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-AUTH_RESPONSE_VALID_ACK','PT:'=>'HD', 
  'FM:'=>'Proxy-Authorization: %s',
  'AR:'=>[\q{join("\r\nProxy-Authorization:", @{FVib('send','','',"HD.Proxy-Authorization.val.txt",'RQ.Request-Line.method','INVITE')})}]},



# INVITE
# 
#	-->	E.INVITE_AOR-URI

# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URI','PT:'=>RQ,
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[\q{NINF('LocalAoRURI','RemotePeer')}]},

# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-NOEXIST-URI','PT:'=>RQ,
  'FM:'=>'INVITE %sNotExist%s SIP/2.0','AR:'=>[\q{substr(NINF('LocalAoRURI','RemotePeer'),0,4)},\q{substr(NINF('LocalAoRURI','RemotePeer'),8)}]},

# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.NEWMETHOD_AOR-URI','PT:'=>RQ,
  'FM:'=>'NEWMETHOD %s SIP/2.0','AR:'=>[\q{NINF('LocalAoRURI','RemotePeer')}]},


# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URI.UNKNOWN-SCHEME','PT:'=>RQ,
  'FM:'=>'INVITE nobody:%s SIP/2.0','AR:'=>[\q{substr(NINF('LocalAoRURI','RemotePeer'),4)}]},

# INVITE Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_AOR-URIwithPARAMETER','PT:'=>RQ,
  'FM:'=>'INVITE %s;method=INVITE?Subject=test SIP/2.0','AR:'=>[\q{NINF('LocalAoRURI','RemotePeer')}]},

# ACK Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_AOR-URI','PT:'=>RQ,
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[\q{NINF('LocalAoRURI','RemotePeer')}]},


# REGISTER
# 
#	-->	E.CSEQ_NUM_REGISTER

#  CSEQ NUM=LOCAL-NUM Method=INVITE
# {'TY:'=>'ENCODE', 'ID:'=>'E.CSEQ_NUM_REGISTER','PT:'=>'HD',
#  'FM:'=>'CSeq: %s REGISTER','AR:'=>[\q{NINFW('DLOG.LocalCSeqNum','+1')}]},


## 2006.2.8 sawada ## 
# INVITE Request-URI=E.164 (AoR=0ABJ to E.164)
 {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_E164-URI','PT:'=>RQ,
  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[sub {my $string = NINF('LocalAoRURI','RemotePeer'); $string =~ (s/sip:0/sip:+81/ | s/sips:0/sips:+81/); return $string;}]},

# INVITE Request-URI=E.164 (AoR=0ABJ to E.164)
# {'TY:'=>'ENCODE', 'ID:'=>'E.INVITE_E164-URI','PT:'=>RQ,
#  'FM:'=>'INVITE %s SIP/2.0','AR:'=>[sub {my $string = NINF('LocalAoRURI','RemotePeer'); $string =~ s/sip:0/sip:+81/; return $string;}]},

## 2006.2.8 sawada ##
# INVITE Request-URI=E.164 (AoR=0ABJ to E.164)
#  ACK Request-URI=CONTACT (After dialog)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_E164-URI','PT:'=>RQ,
  'FM:'=>'ACK %s SIP/2.0','AR:'=>[sub {my $string = NINF('LocalAoRURI','RemotePeer'); $string =~ (s/sip:0/sip:+81/ | s/sips:0/sips:+81/); return $string;}]},

# INVITE Request-URI=E.164 (AoR=0ABJ to E.164)
#  ACK Request-URI=CONTACT (After dialog)
# {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_E164-URI','PT:'=>RQ,
#  'FM:'=>'ACK %s SIP/2.0','AR:'=>[sub {my $string = NINF('LocalAoRURI','RemotePeer'); $string =~ s/sip:0/sip:+81/; return $string;}]},

# PRIVACY 
 {'TY:'=>'ENCODE', 'ID:'=>'E.PRIVACY_NONE','PT:'=>'HD',
  'FM:'=>'Privacy: none',},

# PRIVACY 
 {'TY:'=>'ENCODE', 'ID:'=>'E.PRIVACY_ID','PT:'=>'HD',
  'FM:'=>'Privacy: id',},

# P-Preferred-Identity 
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-PREFERRED-IDENTITY_ANONYMOUS','PT:'=>'HD',
  'FM:'=>'P-Preferred-Identity: %s','AR:'=>[ sub {
		my $tempString = $CVA_PUA_URI;
#		$tempString =~ s/sip:0/tel:+81/;
		$tempString =~ (s/sip:0/tel:+81/ | s/sips:0/tel:+81/);  ## 2006.2.8 sawada ##
		$tempString =~ s/@.*$//;
		return "Anonymous <$CVA_PUA_URI>\r\nP-Preferred-Identity: ".NINF('DisplayName')." <$tempString>";}]},


# P-Asserted-Identity 
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-ASSERTED-IDENTITY','PT:'=>'HD',
  'FM:'=>'P-Asserted-Identity: %s','AR:'=>[sub {
		my $tempString = $CVA_PUA_URI;
#		$tempString =~ s/sip:0/tel:+81/;
		$tempString =~ (s/sip:0/tel:+81/ | s/sips:0/tel:+81/);  ## 2006.2.8 sawada ##
		$tempString =~ s/@.*$//;
		return NINF('DisplayName')." <$CVA_PUA_URI>\r\nP-Asserted-Identity: ".NINF('DisplayName')." <$tempString>";}]},


# P-Asserted-Identity 
 {'TY:'=>'ENCODE', 'ID:'=>'E.P-ASSERTED-IDENTITY_ANONYMOUS','PT:'=>'HD',
  'FM:'=>'P-Asserted-Identity: %s','AR:'=>[sub {
		my $tempString = $CVA_PUA_URI;
#		$tempString =~ s/sip:0/tel:+81/;
		$tempString =~ (s/sip:0/tel:+81/ | s/sips:0/tel:+81/);  ## 2006.2.8 sawada ##
		$tempString =~ s/@.*$//;
		return "Anonymous <$CVA_PUA_URI>\r\nP-Asserted-Identity: ".NINF('DisplayName')." <$tempString>";}]},

# a=sendonly 
 {'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID_SENDONLY','PT:'=>BD,      ####   @@@@@@@'E.BODY_VALID'
  'FM:'=>
    \q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "t=0 0\r\n".
       "m=audio ".NINF('RTPPort','LocalPeer')." RTP/AVP 0\r\n".
       "a=rtpmap:0 PCMU/8000\r\n".
       "a=sendonly"},
  'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')}]
},

### 20050406 usako add start ###
 # for invite-request (override)
 {'TY:'=>'ENCODE', 'ID:'=>'E.SUPPORTED_VALID', 'PT:'=>'HD',
  'FM:'=> 'Supported: %s',
  'AR:'=> [\q{(NDCFG('supported_extension') eq "none")?"":NDCFG('supported_extension')}],
 },

### 20050721 kenzo add start ###
 # for invite-request (override)
 {'TY:'=>'ENCODE', 'ID:'=>'E.PROXY-REQUIRE_VALID', 'PT:'=>'HD',
  'FM:'=> 'Proxy-Require: 999rel',
 },

 # for response
 {'TY:'=>'ENCODE', 'ID:'=>'E.RES.SUPPORTED_VALID', 'PT:'=>'HD',
  'FM:'=> 'Supported: %s',
  'AR:'=> [ \q{ FV('HD.Supported.txt', @_) } ],
 },
### 20050406 usako add end ###

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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.PX', 'MD:'=>'SEQ', 
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


# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.STRICT-R.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
#	'E.RECORDROUTE_ONEHOP', # Miz
	'E.RECORDROUTE_ONEHOP_STRICT-R', # Miz
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.180.ONEPX.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.180.TWOPX.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.ONEPX.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.TWOPX.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_ONEHOP',	#
	'E.MAXFORWARDS_ONEHOP',	#
        'E.ROUTE_ONEURI',
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_NOHOP',# 
	'E.MAXFORWARDS_NOHOP',# 
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-480-RETURN.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-480-RETURN.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-486-RETURN.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-486',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},
  
###############################################################
###
### 	6-2-2. 486
###	ES.STATUS-501-RETURN
###     Used by TM
### 20050719 kenzo modify
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-501-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-501',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-486-RETURN.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-487-RETURN.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-487-RETURN.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-CANCEL-RETURN.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-BYE-RETURN.TWOPX.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.100.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-100',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},




###############################################################
###
### 	8. 200 Response (No SDP)
###	         ES.STATUS.200.ONEPX.TM
###
### - This ruleset doesn't have "Contact" header.
###   So, if you want to add the header, 
###    you should use "AD" function as follows:
###  
###   SD_Term_STATUS('200','BYE',
###         'ES.STATUS.200.ONEPX.TM','', ['E.CONTACT_URI'],);
###                        (comment by Horisawa, 2005/12/21)
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200.ONEPX.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_ASIS',  ###add 20050113 
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

###############################################################
###
### 	8. 200
###	ES.STATUS.200.TWOPX.TM
### 20050306 tadokoro
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200.TWOPX.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED_TWOPX.TM',
	'E.RECORDROUTE_ASIS',  ###add 20050113 
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

###############################################################
###
### 	9. 2xx
###	ES.REQUEST.ACK-2XX.TM
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS', # 20050111
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# use re-INVITE-200-ACK. PX-2-1-6.
# add by kenzo
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX-NOAUTH.TM', 'MD:'=>SEQ, 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
        'E.ROUTE_TWOURIS', # 20050111
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},
# end kenzo


#add 2004_12_28 
###############################################################
###
### 	10. 
###	ES.REQUEST.ACK-NO2XX.TM
###
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.ACK_AOR-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',	#
	'E.FROM_PUA-URI_LOCAL-TAG',#
	'E.TO_REMOTE-URI_REMOTE-TAG', #
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
        'E.ROUTE_ONEURI',
        'E.RECORDROUTE_ONEHOP', # 20050304 add tadokoro	# 20050420 usako delete
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_REMOTE-URI_REMOTE-TAG',# 

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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.100.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.180.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_TWOHOPS',
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.PX', 'MD:'=>'SEQ', 
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

###############################################################
###
### 	15. REGISTER
###
###############################################################	

# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.TM', 'MD:'=>'SEQ', 
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


# REGISTER request with Record-Route header (RG-2-1-1) add by kenzo
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.WITH-RR.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.RECORDROUTE_REGISTER',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	#'E.CONTACT_URI',
	'E.CONTACT_URI_REGISTER',  ## 2006.2.1 sawada add transport parameter header field ##  
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request without Expires Header field
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.WITHOUT-EXPIRES.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	#'E.CONTACT_URI',
	'E.CONTACT_URI_REGISTER',  ## 2006.2.1 sawada add transport parameter header field ## 
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request different between R-URI and From,To
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.FROM-TO-DIFFER.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_DIFFERENT-URI_LOCAL-TAG',
	'E.TO_RG-DIFFERENT-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	#'E.CONTACT_URI',
	'E.CONTACT_URI_REGISTER',  ## 2006.2.1 sawada add transport parameter header field ##  
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.WITH-ASTERISK.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_ASTERISK',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.WITH-ASTERISK.WITH-CONTACT-URI.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI_ASTERISK',
	#'E.CONTACT_URI',
	'E.CONTACT_URI_REGISTER',  ## 2006.2.1 sawada add transport parameter header field ##  
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.WITH-TO-PARAM.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG_WITH-PARAM',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	#'E.CONTACT_URI',
	'E.CONTACT_URI_REGISTER',  ## 2006.2.1 sawada add transport parameter header field ##  
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},

## 2006.2.7 sawada ##
# {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG.WITH-ESCAPED-CHAR','PT:'=>'HD', 
#  'FM:'=>'From: %s<%s:U%%6511@under.test.com>;tag=%s',
#'AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
#                                      \q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},
#				       \q{NINF('DLOG.LocalTag')}]},

# 20040808 RG-2-1-12 kenzo
# {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG.WITH-ESCAPED-CHAR','PT:'=>'HD', 
#  'FM:'=>'From: %s<sip:U%%6511@under.test.com>;tag=%s','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
#				       \q{NINF('DLOG.LocalTag')}]},

## 2006.2.7 sawada ## 
# {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI.WITH-ESCAPED-CHAR','PT:'=>'HD', 
#  'FM:'=>'Contact: <%s:U%%6511@node.under.test.com>',
#  'AR:'=>[\q{($AIP_PL_TRNS eq "TLS")?"sips":"sip"}]},

####Inoue 2006.9.7####
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI.WITH-ESCAPED-CHAR','PT:'=>'HD', 
  'FM:'=>'Contact: <%s;transport=%s>',
  'AR:'=>[\q{encconv("LocalContactURI","LocalPeer")},"\L$SIP_PL_TRNS\E"]},
# 'AR:'=>[\q{encconv(NINF('LocalContactURI','LocalPeer'))},"\L$SIP_PL_TRNS\E"]},

 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_LOCAL-TAG.WITH-ESCAPED-CHAR','PT:'=>'HD',
  'FM:'=>'From: %s<%s>;tag=%s',
  'AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
                                      \q{encconv("LocalAoRURI","LocalPeer")},
                                      \q{NINF('DLOG.LocalTag')}]}, 

 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_RG-URI_WITH-ESCAPED-CHAR_NO-TAG','PT:'=>
'HD',
  'FM:'=>'To: %s<%s>',
  'AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
                                     \q{encconv("LocalAoRURI","LocalPeer")}]},


# {'TY:'=>'ENCODE', 'ID:'=>'E.CONTACT_URI.WITH-ESCAPED-CHAR','PT:'=>'HD', 
#  'FM:'=>'Contact: <sip:U%%6511@node.under.test.com>',},

# REGISTER request
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.WITH-ESCAPED-CHAR.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG.WITH-ESCAPED-CHAR',
	'E.TO_RG-URI_WITH-ESCAPED-CHAR_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI.WITH-ESCAPED-CHAR',
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX-AUTH.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.TM', 'MD:'=>'SEQ', 
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

# REGISTER request with Authorization with user-param in To header
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.WITH-TO-PARAM.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_RG-URI_NO-TAG_WITH-PARAM',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	#'E.CONTACT_URI',
	'E.CONTACT_URI_REGISTER', ## 2006.2.1 sawada add transport parameter header field ## 
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# REGISTER request with Authorization
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.WITH-RR.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.RECORDROUTE_REGISTER',
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


# REGISTER request with Authorization
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.WITHOUT-EXPIRES.TM', 'MD:'=>'SEQ', 
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
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},



# REGISTER request without Contact
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.GETCONTACT.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.GETCONTACT.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER.DELREG.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.DELREG.TM', 'MD:'=>'SEQ', 
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


# REGISTER request with Authorization
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.REGISTER-AUTH.WITH-ESCAPED-CHAR.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.REGISTER_RG-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.AUTH_RESPONSE_QOP',
	'E.AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG.WITH-ESCAPED-CHAR',
	'E.TO_RG-URI_WITH-ESCAPED-CHAR_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_REGISTER',
	'E.CONTACT_URI.WITH-ESCAPED-CHAR',
	'E.EXPIRES_VALID',
	'E.CONTENT-LENGTH_0'
	],
  'EX:' =>\&MargeSipMsg},


# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.TM', 'MD:'=>'SEQ', 
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

## 20050316 tadokoro
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.PX', 'MD:'=>'SEQ', 
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

# INVITE request(with SDP, with Unknown Scheme, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.WITH-UNKNOWN-SCHEME.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
#	'E.INVITE_AOR-URI',
	'E.INVITE_AOR-URI.UNKNOWN-SCHEME',
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

# INVITE request(with SDP, with Unknown Scheme, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.WITH-UNKNOWN-SCHEMEwithAuth.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
#	'E.INVITE_AOR-URI',
	'E.INVITE_AOR-URI.UNKNOWN-SCHEME',
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
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},





# INVITE request(with SDP, Max-Forwards 0, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.MAXFORWARDS-ZERO.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
#	'E.MAXFORWARDS_NOHOP',
	'E.MAXFORWARDS_ZERO',
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

# INVITE request(with SDP, Max-Forwards 0, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.BADEXTENSIONwithAuth.TM', 'MD:'=>'SEQ', 
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
	'E.PROXY-REQUIRE_VALID',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, Max-Forwards 0, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.BADEXTENSION.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_INVITE',
	'E.PROXY-REQUIRE_VALID',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

# INVITE request(with SDP, Max-Forwards 0, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.NOEXIST-ENTITY.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
#	'E.INVITE_AOR-URI',
	'E.INVITE_AOR-NOEXIST-URI',
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


# INVITE request(with SDP, with R-URI parameter, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.R-URIwithPARAMETER.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URIwithPARAMETER',
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.R-URIwithPARAMETER.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URIwithPARAMETER',
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



## modify 05/01/05 cats
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTHwithNEWHEADER.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.NEWHEADER',
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

# INVITE request(with SDP, originated from UA) without Max-Forwards header field
# ads by kenzo
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.WITHOUT-MAXFORWARDS.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.WITHOUT-MAXFORWARDS.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.P-AUTH_RESPONSE_QOP_NO_Max-Forwards',
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH-DOUBLE.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'E.STATUS-407-RETURN-AUTH-2VIA.PX1', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-407',
	'E.VIA_RETURN_RECEIVED',
	'E.PX-AUTHENTICATE_VALID2', 
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


# INVITE request for HOLD sent by TM
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM.HOLD', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM.HOLD.AUTH', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM.HOLD-RELEASE', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.TM.HOLD-RELEASE.AUTH', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.PX.HOLD', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.PX.HOLD-RELEASE', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS-HOLD.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS-HOLDREL.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS-HOLD.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS-HOLDREL.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.CANCEL.TM', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.CANCEL.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE_E164.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE_E164-FROM_ANONYMOUS.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID.TM', 'MD:'=>'SEQ', 
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
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-PRIVACY_ID-AUTH.TM', 'MD:'=>'SEQ', 
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

## tadokoro ##########################################
# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS.TM', 'MD:'=>'SEQ', 
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
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

## tadokoro ##########################################
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-FROM_ANONYMOUS-AUTH.TM', 'MD:'=>'SEQ', 
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
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},
  

## tadokoro ##########################################
### 	9. 2xx

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX-FROM_ANONYMOUS.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
###20050112off        'D.TO-TAG',
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',	#
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS', # 20050111
	'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG', #
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

## tadokoro ##########################################
### 	9. 2xx

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX-FROM_ANONYMOUS.PX', 'MD:'=>'SEQ', 
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

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX_E164-FROM_ANONYMOUS.PX', 'MD:'=>'SEQ', 
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

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX_E164.PX', 'MD:'=>'SEQ', 
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
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE-TO_ANONYMOUS.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',# 
	'E.ROUTE_ONEURI',
        'E.RECORDROUTE_ONEHOP', # 20050304 add tadokoro	
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_ANONYMOUS_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.NEWMETHOD.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.NEWMETHOD_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_NEWMETHOD',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:' =>\&MargeSipMsg},

## modify 05/07/15 kenzo
# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.NEWMETHOD-AUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.NEWMETHOD_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_NEWMETHOD',
	'E.CONTACT_URI',
	'E.ALLOW_VALID',
	'E.SUPPORTED_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID_SAME_VERSION'],  ## ADD
  'EX:' =>\&MargeSipMsg},


 # %% PX-1-1-2 01 %%	UA receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.NEWMETHOD-407.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.NEWMETHOD-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.DIGEST-AUTH_CHALLENGE.PX',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 


# INVITE request(with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITEwithNEWHEADER.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.NEWHEADER',
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

### 	PX-3-1-14_2, RG-4-1-1 NewHeader Field
 {'TY:'=>'ENCODE', 'ID:'=>'E.NEWHEADER','PT:'=>'HD', 
  'FM:'=>'NewHeader: new' },


  {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE-TO_ANONYMOUS.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',# 
	'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	'E.TO_ANONYMOUS_REMOTE-TAG',# 
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},
  
## tadokoro ##########################################
### 	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX-FROM_ANONYMOUS.TM', 'MD:'=>'SEQ', 
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



);




