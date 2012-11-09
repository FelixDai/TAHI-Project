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


#========================================
# Rule definition
#    for UA test (Privacy, RFC3323/3325)
#========================================

@SIPUAExtendPrivacyRules=
(
#####################
### Ruleset (ENCODE)
#####################



#####################
### Ruleset (SYNTAX)
#####################

### Judgment ruleset for Privacy Mechanism 
###  (User-Provided Privacy)
###   written by Horisawa (2006.1.27)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.Privacy.User-Provided.PX',
 'RR:'=>[
 	'S.RFC3323-4-1_headers',
	'S.RFC3323-4-4_Call-ID',
 	'S.RFC3323-4-5_From',
 	'S.RFC3323-4-5_Reply-To',
 	'S.RFC3323-4-6_From',
 	'S.RFC3323-4-6_Reply-To',

	### CAUTION !!!
	# When you use this ruleset, 
	# you must delete the following rules:
	#   S.FROM-URI_REMOTE-URI

 	],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy : common rule)
###   written by Horisawa (2006.1.31)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.Privacy.Network-Provided.COMMON.PX',
 'RR:'=>[
 	'S.RFC3323-4-10_Privacy',
	'S.RFC3323-4-14_Privacy_user',
	'S.RFC3323-4-16_Privacy_none',
	'S.RFC3323-4-17_Privacy_priv-value',
	'S.RFC3323-4-18_Privacy_priv-value',
	'S.RFC3323-4-20_TLS',
	'S.RFC3323-4-21_connection',
	'S.RFC3323-4-23_Proxy-Require',
	'S.RFC3323-5-9_Privacy',
	'S.RFC3323-5-10_Proxy-Require',
 	],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (Header Privacy)
###   written by Horisawa (2006.1.27)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.Privacy.Network-Provided.header.PX',
 'RR:'=>[
 	'SSet.Privacy.Network-Provided.COMMON.PX',
 	],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (Session Privacy)
###   written by Horisawa (2006.1.27)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.Privacy.Network-Provided.session.PX',
 'RR:'=>[
 	'SSet.Privacy.Network-Provided.COMMON.PX',
	'S.RFC3323-4-13_Privacy_session',
 	],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (User Privacy)
###   written by Horisawa (2006.1.27)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.Privacy.Network-Provided.user.PX',
 'RR:'=>[
 	'SSet.Privacy.Network-Provided.COMMON.PX',
 	],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (priv-value : none)
###   written by Horisawa (2006.1.27)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.Privacy.Network-Provided.none.PX',
 'RR:'=>[
 	'SSet.Privacy.Network-Provided.COMMON.PX',
 	],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (priv-value : id)
###   written by Horisawa (2006.2.9)
{'TY:'=>'RULESET',
 'ID:'=>'SSet.Privacy.Network-Provided.id.PX',
 'RR:'=>[
 	'SSet.Privacy.Network-Provided.COMMON.PX',
 	'S.RFC3325_P-Preferred-Identity_Not-Applicable-method',
	'S.RFC3325-6-2_P-Preferred-Identity',
	'S.RFC3325-9-5_P-Preferred-Identity',
	'S.RFC3325-9-6_P-Preferred-Identity',
	'S.RFC3325-9-7_P-Preferred-Identity',
 	],
},


##################
### Rule (ENCODE)
##################



##################
### Rule (SYNTAX)
##################

#================= RFC3323 ===================

### Judgment rule for headers which should not be included
### (Basis for a determination : RFC3323-4-1)
###   written by Horisawa (2006.1.27)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-1_headers',
 'CA:'=>'Header',
 'OK:'=>\\'Any optional headers that might divulge personal information SHOULD NOT be included.',
 'NG:'=>\\'Any optional headers that might divulge personal information SHOULD NOT be included.',
 'RT:'=>'warning',
 'EX:'=>\q{!FFIsExistHeader(['Reply-To','Call-Info','User-Agent','Organization',
 							 'Server','Subject','In-Reply-To','Warning'],@_)}
},

### Judgment rule for URI which are included the message
### (Basis for a determination : RFC3323-4-2)
###
### This condition is a pointer to the description of Section 4.1.1, 
###  so not implemented.
###
###   written by Horisawa (2006.1.27)

### Judgment rule for "From" header (anonymous From header field)
### (Basis for a determination : RFC3323-4-3)
###
### This condition is an applicaton example of RFC3323-4-2, 
###  so not implemented
###
###   written by Horisawa (2006.1.27)

### Judgment rule for "Call-ID" header (Not include address/hostname)
### (Basis for a determination : RFC3323-4-4)
###   written by Horisawa (2006.1.27)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-4_Call-ID',
 'CA:'=>'Call-ID',
 'OK:'=>\\'The Call-ID value(%s) SHOULD use a suitably long random value instead of IP address or hostname.',
 'NG:'=>\\'The Call-ID value(%s) SHOULD use a suitably long random value instead of IP address or hostname.',
 'RT:'=>'warning',
 'EX:'=>sub {
 			my($rule,$pktinfo,$context)=@_;
			my($id);
 			$id = FV('HD.Call-ID.val.call-id','',$pktinfo);
			$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'via','ARG1:'=>$id};

			if ((!FFIsMatchStr($CNT_CONF{'UA-HOSTNAME'},$id,'','',@_)) &&
				(!FFIsMatchStr($CNT_CONF{'UA-CONTACT-HOSTNAME'},$id,'','',@_)) &&
				(!FFIsMatchStr($CVA_TUA_IPADDRESS,$id,'','',@_))) {
				return 'OK';		# OK
			} else {
				return '';			# NG
			}
		}
},

### Judgment rule for display-name (in From/Reply-To header)
### (Basis for a determination : RFC3323-4-5)
###   written by Horisawa (2006.1.27)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-5_From',
 'CA:'=>'From',
 'OK:'=>\\'It is RECOMMENDED to use a display-name of \"Anonymous\".',
 'NG:'=>\\'It is RECOMMENDED to use a display-name of \"Anonymous\".',
 'RT:'=>'warning',
 'EX:'=>\q{FFIsExistHeader('From',@_) &&
            (FFop('eq',FV('HD.From.val.ad.disp',@_),"Anonymous",@_)
             || FFop('eq',FV('HD.From.val.ad.disp',@_),"\"Anonymous\"",@_))
        }
},

### Judgment rule for display-name (in From/Reply-To header)
### (Basis for a determination : RFC3323-4-5)
###   written by Horisawa (2006.1.27)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-5_Reply-To',
 'CA:'=>'Reply-To',
 'OK:'=>\\'It is RECOMMENDED to use a display-name of \"Anonymous\".',
 'NG:'=>\\'It is RECOMMENDED to use a display-name of \"Anonymous\".',
 'RT:'=>'warning',
 'PR:'=>\q{FFIsExistHeader('Reply-To',@_)},
 'EX:'=>\q{FFIsExistHeader('From',@_) &&
            (FFop('eq',FV('HD.From.val.ad.disp',@_),"Anonymous",@_)
             || FFop('eq',FV('HD.From.val.ad.disp',@_),"\"Anonymous\"",@_))
        }
},

### Judgment rule for hostname (in From/Reply-To header)
### (Basis for a determination : RFC3323-4-6)
###   written by Horisawa (2006.1.27)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-6_From',
 'CA:'=>'From',
 'OK:'=>\\'The hostname value \"anonymous.invalid\" SHOULD be used for anonymous URIs.',
 'NG:'=>\\'The hostname value \"anonymous.invalid\" SHOULD be used for anonymous URIs.',
 'RT:'=>'warning',
 'EX:'=>\q{FFIsExistHeader('From',@_) && FFop('eq',\\\'HD.From.val.ad.ad.hostport.host','anonymous.invalid',@_)}
},

### Judgment rule for hostname (in From/Reply-To header)
### (Basis for a determination : RFC3323-4-6)
###   written by Horisawa (2006.1.27)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-6_Reply-To',
 'CA:'=>'Reply-To',
 'OK:'=>\\'The hostname value \"anonymous.invalid\" SHOULD be used for anonymous URIs.',
 'NG:'=>\\'The hostname value \"anonymous.invalid\" SHOULD be used for anonymous URIs.',
 'RT:'=>'warning',
 'PR:'=>\q{FFIsExistHeader('Reply-To',@_)},
 'EX:'=>\q{FFop('eq',\\\'HD.From.val.ad.ad.hostport.host','anonymous.invalid',@_)}
},

### Judgment rule for To-tag parameter
### (Basis for a determination : RFC3323-4-7)
###
### This condition has already implemented as S.FROM-TAG_EXIST (in SIPrule.pm).
###
###   written by Horisawa (2006.1.27)

### Judgment rule for headers for routing
### (Basis for a determination : RFC3323-4-8)
###
### It is difficult to judge whether the header's value is the value 
###  that will allow them to receive further requests.
### So, this judgment is not implemented.
###
###   written by Horisawa (2006.1.27)

### Judgment rule for headers for routing
### (Basis for a determination : RFC3323-4-9)
###
### From the message TESTER received, it is difficult to judge
###  whether the host portion of URIs are altered by the UA.
### So, this judgment is not implemented.
###
###   written by Horisawa (2006.1.27)


### Judgment rule for "Privacy" header (the presense of Privacy header)
### (Basis for a determination : RFC3323-4-10)
###   written by Horisawa (2006.1.30)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-10_Privacy',
 'CA:'=>'Privacy',
 'OK:'=>\\'A Privacy header SHOULD be included when network-provided privacy is required.',
 'NG:'=>\\'A Privacy header SHOULD be included when network-provided privacy is required.',
 'RT:'=>'warning',
 'EX:'=>\q{FFIsExistHeader('Privacy',@_)}
},

### Judgment rule for "Privacy" header ("session" priv-value)
### (Basis for a determination : RFC3323-4-13)
###   written by Horisawa (2006.1.30)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-13_Privacy_session',
 'CA:'=>'Privacy',
 'OK:'=>\\'SDP bodies MUST NOT be encrypted by UA when session privacy is requested.',
 'NG:'=>\\'SDP bodies MUST NOT be encrypted by UA when session privacy is requested.',
 'PR:'=>\q{FFIsExistHeader('Privacy',@_) && 
 		   FFIsMember(['session'],FVSeparete('HD.Privacy.txt','\s*\;\s*',@_),'',@_) &&
		   FV('BD.txt',@_)
		},
 'EX:'=>\q{!(FFIsMember(['multipart/signed'],FVSeparete('Content-Type','\s*;\s*',@_),'',@_) ||
 			FFIsMember(['application/pkcs7-mime'],FVSeparete('Content-Type','\s*;\s*',@_),'',@_))
		}
},

### Judgment rule for "Privacy" header ("user" priv-value)
### (Basis for a determination : RFC3323-4-14)
###   written by Horisawa (2006.1.30)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-14_Privacy_user',
 'CA:'=>'Privacy',
 'OK:'=>\\'UA SHOULD NOT set \'user\' level privacy for requests except REGISTER.',
 'NG:'=>\\'UA SHOULD NOT set \'user\' level privacy for requests except REGISTER.',
 'PR:'=>\q{FFIsExistHeader('Privacy',@_) && FFop('ne',\\\'RQ.Request-Line.method','REGISTER',@_)},
 'RT:'=>'warning',
 'EX:'=>\q{!FFIsMember(['user'],FVSeparete('HD.Privacy.txt','\s*\;\s*',@_),'',@_)}
},

### Judgment rule for "Privacy" header ("none" priv-value)
### (Basis for a determination : RFC3323-4-16)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-16_Privacy_none',
 'CA:'=>'Privacy',
 'OK:'=>\\'UA MUST NOT populate any other priv-values in a Privacy header that contains a value of \'none\'.',
 'NG:'=>\\'UA MUST NOT populate any other priv-values in a Privacy header that contains a value of \'none\'.',
 'PR:'=>\q{FFIsExistHeader("Privacy",@_) && FFIsMember(['none'],FVSeparete('HD.Privacy.txt','\s*;\s*',@_),'',@_)},
 'EX:'=>\q{FFGetIndexCountSeparateDelimiter(\\\'HD.Privacy.txt','\s*\;\s*',@_) eq 0},
},

### Judgment rule for "Privacy" header
### (Basis for a determination : RFC3323-4-17)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-17_Privacy_priv-value',
 'CA:'=>'Privacy',
 'OK:'=>\\'A Privacy header MUST consist of either the value \'none\', or one or more of the values \'user\', \'header\', \'session\', \'id\'.',
 'NG:'=>\\'A Privacy header MUST consist of either the value \'none\', or one or more of the values \'user\', \'header\', \'session\', \'id\'.',
 'PR:'=>\q{FFIsExistHeader("Privacy",@_)},
 'EX:'=>\q{FFIsMember(FVSeparete('HD.Privacy.txt','\s*\;\s*',@_),['header','session','user','none','id'],'',@_);}
},

### Judgment rule for "Privacy" header
### (Basis for a determination : RFC3323-4-18)
###   written by Horisawa (2006.2.6)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-18_Privacy_priv-value',
 'CA:'=>'Privacy',
 'OK:'=>\\'A Privacy header MUST include the same priv-value at most once.',
 'NG:'=>\\'A Privacy header MUST include the same priv-value at most once.',
 'PR:'=>\q{FFIsExistHeader("Privacy",@_)},
 'EX:'=>\q{!FFHaveDuplicateElement(FVSeparete('HD.Privacy.txt','\s*\;\s*',@_));}
},

### Judgment rule for secure transport
### (Basis for a determination : RFC3323-4-20)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-20_TLS',
 'CA:'=>'TLS',
 'OK:'=>'It is highly RECOMMENDED that UA use network or transport layer security when contacting a privacy service.',
 'NG:'=>'It is highly RECOMMENDED that UA use network or transport layer security when contacting a privacy service.',
 'PR:'=>\q{FFIsExistHeader("Privacy",@_)},
 'RT:'=>'warning',
 'EX:'=>\q{$SIP_PL_TRNS eq "TLS"}
},

### Judgment rule for a direct connection
### (Basis for a determination : RFC3323-4-21, RFC3323-4-22)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-21_connection',
 'CA:'=>'TLS',
 'OK:'=>'The UA SHOULD establish a direct connection to a privacy service.',
 'NG:'=>'The UA SHOULD establish a direct connection to a privacy service. (If it\'s impossible, UA SHOULD use lower-layer security.)',
 'PR:'=>\q{FFIsExistHeader("Privacy",@_) && FFop('ne',\\\'RQ.Request-Line.method','',@_)},
 'RT:'=>'warning',
 'EX:'=>\q{(FVs('HD.Via.val.via.txt',@_)->[1] eq '') || ($SIP_PL_TRNS eq "TLS")},
},

### Judgment rule for "Proxy-Require" header with "privacy" tag
### (Basis for a determination : RFC3323-4-23)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-23_Proxy-Require',
 'CA:'=>'Proxy-Require',
 'OK:'=>'The UA SHOULD use \'Proxy-Require\' header containing \'privacy\' option-tag when sending a request directly to privacy service.',
 'NG:'=>'The UA SHOULD use \'Proxy-Require\' header containing \'privacy\' option-tag when sending a request directly to privacy service.',
 'PR:'=>\q{FFIsExistHeader("Privacy",@_) 
 			&& FFop('ne',\\\'RQ.Request-Line.method','',@_) 		# for Request except ACK/CANCEL
 			&& FFop('ne',\\\'RQ.Request-Line.method','ACK',@_) 
 			&& FFop('ne',\\\'RQ.Request-Line.method','CANCEL',@_)
			&& (FVs('HD.Via.val.via.txt',@_)->[1] eq '')},
 'RT:'=>'warning',
 'EX:'=>\q{FFIsExistHeader("Proxy-Require",@_) && FFIsMember(['privacy'],FVSeparete('HD.Proxy-Require.val','\s*,\s*',@_),'',@_)},
},

### Judgment rule for Privacy 
### (Basis for a determination : RFC3323-5-9)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-9_Privacy',
 'CA:'=>'Privacy',
 'OK:'=>\\'The entire Privacy header MUST be removed from a message when the last priv-value (not counting \'critical\') has been removed from the Privacy header.',
 'NG:'=>\\'The entire Privacy header MUST be removed from a message when the last priv-value (not counting \'critical\') has been removed from the Privacy header.',
 'PR:'=>\q{FFIsExistHeader("Privacy",@_)},
 'EX:'=>\q{FFop('ne',\\\'HD.Privacy.txt','critical',@_) && FFop('ne',\\\'HD.Privacy.txt','',@_)},
},

### Judgment rule for Privacy 
### (Basis for a determination : RFC3323-5-10)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-10_Proxy-Require',
 'CA:'=>'Proxy-Require',
 'OK:'=>\\'The \'privacy\' option-tag MUST be removed from Proxy-Require header if the privacy service removes the entire Privacy header.',
 'NG:'=>\\'The \'privacy\' option-tag MUST be removed from Proxy-Require header if the privacy service removes the entire Privacy header.',
 'PR:'=>\q{!FFIsExistHeader("Privacy",@_) && FFIsExistHeader("Proxy-Require",@_)},
 'EX:'=>\q{!FFIsMember(['privacy'],FVSeparete('HD.Proxy-Require.val','\s*,\s*',@_),'',@_)},
}, 


#================= RFC3325 ===================

### Judgment rule for "P-Preferred-Identity" header
### (Basis for a determination : RFC3325 Table in 9.2)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325_P-Preferred-Identity_Not-Applicable-method',
 'CA:'=>'P-Preferred-Identity',
 'OK:'=>'A P-Preferred-Identity header MUST NOT be included in the request of this method.',
 'NG:'=>'A P-Preferred-Identity header MUST NOT be included in the request of this method.',
 'PR:'=>\q{FFIsMember(FV('RQ.Request-Line.method',@_),['ACK','CANCEL','REGISTER','INFO','UPDATE','PRACK'],'',@_)},
 'EX:'=>\q{!FFIsExistHeader("P-Preferred-Identity",@_)},
},

### Judgment rule for "P-Preferred-Identity" header
### (Basis for a determination : RFC3325-6-2)
###   written by Horisawa (2006.2.9)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-6-2_P-Preferred-Identity',
 'CA:'=>'P-Preferred-Identity',
 'OK:'=>'A P-Preferred-Identity header MUST NOT be populated in a message that is not sent directly to a proxy that is trusted by the UA.',
 'NG:'=>'A P-Preferred-Identity header MUST NOT be populated in a message that is not sent directly to a proxy that is trusted by the UA.',
 'PR:'=>\q{FFIsExistHeader("P-Preferred-Identity",@_)},
 'EX:'=>\q{(FVs('HD.Via.val.via.txt',@_)->[1] eq '')},
},

### Judgment rule for "P-Preferred-Identity" header
### (Basis for a determination : RFC3325-9-5)
###   written by Horisawa (2006.2.9)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-9-5_P-Preferred-Identity',
 'CA:'=>'P-Preferred-Identity',
 'OK:'=>'A P-Preferred-Identity header field value MUST consist of exactly one name-addr or addr-spec.',
 'NG:'=>'A P-Preferred-Identity header field value MUST consist of exactly one name-addr or addr-spec.',
 'PR:'=>\q{FFIsExistHeader("P-Preferred-Identity",@_)},
 'EX:'=>sub{
 		my($rule,$pktinfo,$context)=@_;

		if ((!FFIsMatchStr(".*<(sip|sips)\:.*\@.*>",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[0],
						'','','',$pktinfo))
			&& (!FFIsMatchStr(".*<tel\:.*>",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[0],
						'','','',$pktinfo))
			&& (!FFIsMatchStr("(sip|sips)\:.*\@.*",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[0],
						'','','',$pktinfo)) 
			&& (!FFIsMatchStr("tel\:.*",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[0],
						'','','',$pktinfo))) {
			return '';	# unmatch (addr-spec)
		}

	if ((FVs('HD.P-Preferred-Identity.val.val.txt',@_)->[1] ne '')
	 		&& (FVs('HD.P-Preferred-Identity.val.val.txt',@_)->[2] eq '')) {

		if ((!FFIsMatchStr(".*<(sip|sips)\:.*\@.*>",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[1],
						'','','',$pktinfo))
			&& (!FFIsMatchStr(".*<tel\:.*>",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[1],
						'','','',$pktinfo))
			&& (!FFIsMatchStr("(sip|sips)\:.*\@.*",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[1],
						'','','',$pktinfo)) 
			&& (!FFIsMatchStr("tel\:.*",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[1],
						'','','',$pktinfo))) {
			return '';	# unmatch (addr-spec)
		}
	}

		return 'MATCH';	# match
 	},
},

### Judgment rule for "P-Preferred-Identity" header
### (Basis for a determination : RFC3325-9-6)
###   written by Horisawa (2006.2.9)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-9-6_P-Preferred-Identity',
 'CA:'=>'P-Preferred-Identity',
 'OK:'=>'A P-Preferred-Identity header field value MUST be a sip, sips, or tel URI if there is one P-Preferred-Identity value.',
 'NG:'=>'A P-Preferred-Identity header field value MUST be a sip, sips, or tel URI if there is one P-Preferred-Identity value.',
 'PR:'=>\q{FFIsExistHeader("P-Preferred-Identity",@_) 
 		&& (FVs('HD.P-Preferred-Identity.val.val.txt',@_)->[1] eq '')
		},
 'EX:'=>sub{
 		my($rule,$pktinfo,$context)=@_;
		
		if (FFIsMatchStr(".*(sip|sips)\:.*@.*",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[0],
						'','','',$pktinfo)
			|| FFIsMatchStr(".*tel\:.*",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[0],
						'','','',$pktinfo)) {
			return 'MATCH';		# tel-URI or sip/sips-URI
		}

		return '';		# unmatch (not sip/sips/tel-URI)
	},
},

### Judgment rule for "P-Preferred-Identity" header
### (Basis for a determination : RFC3325-9-7, RFC3325-9-8)
###   written by Horisawa (2006.2.9)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-9-7_P-Preferred-Identity',
 'CA:'=>'P-Preferred-Identity',
 'OK:'=>'One of P-Preferred-Identity header field values MUST a sip or sips URI and the other MUST be a tel URI if there are two P-Preferred-Identity values.',
 'NG:'=>'One of P-Preferred-Identity header field values MUST a sip or sips URI and the other MUST be a tel URI if there are two P-Preferred-Identity values.',
 'PR:'=>\q{FFIsExistHeader("P-Preferred-Identity",@_)
 		&& (FVs('HD.P-Preferred-Identity.val.val.txt',@_)->[1] ne '')
 		&& (FVs('HD.P-Preferred-Identity.val.val.txt',@_)->[2] eq '')
		},
 'EX:'=>sub{
 		my($rule,$pktinfo,$context)=@_;

		if (FFIsMatchStr(".*(sip|sips)\:.*@.*",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[0],
						'','','',$pktinfo)) {
			if (FFIsMatchStr(".*tel\:.*",
							FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[1],
							'','','',$pktinfo)) {
				return 'MATCH';		# sip/sips-URI and tel-URI
			} else {
				return '';			# unmatch (both sip/sips ?)
			}
		} elsif (FFIsMatchStr(".*tel\:.*",
						FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[0],
						'','','',$pktinfo)) {
			if (FFIsMatchStr(".*(sip|sips)\:.*@.*",
							FVs('HD.P-Preferred-Identity.val.val.ad.txt','',$pktinfo)->[1],
							'','','',$pktinfo)) {
				return 'MATCH';		# tel-URI and sip/sips-URI
			} else {
				return '';			# unmatch (both tel ?)
			}
		}
		
		return '';
	},
},



), ### @SIPUAExtendPrivacyRules

return 1;

