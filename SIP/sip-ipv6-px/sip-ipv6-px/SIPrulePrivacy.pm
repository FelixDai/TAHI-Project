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
      
@SIPPXRulesPrivacy=
(

#####################
### Ruleset (ENCODE)
#####################


#####################
### Ruleset (SYNTAX)
#####################

# Ruleset for PV-1-1-2
{'TY:'=>'RULESET',
 'ID:'=>'SS.STATUS.INVITE-500.TM',
 'RR:'=>[
 	'SSet.ResMesg',
	'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
	'S.VIA-RECEIVED_EXIST',
	'S.VIA_NOPX_SEND_EQUAL',
	'S.RE-ROUTE_NOEXIST',
	'S.CSEQ-METHOD_INVITE',
	'S.TO-TAG_EXIST',
	'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
	'S.PORT-SIGNAL_DEFAULTS',
	'D.COMMON.FIELD.STATUS',
 	]
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy : common rule)
###   written by Horisawa (2006.2.7)
{'TY:'=>'RULESET',
 'ID:'=>'SS.Privacy.Network-Provided.COMMON',
 'RR:'=>[
    'S.RFC3323-5-9_Privacy',
    'S.RFC3323-5-10_Proxy-Require',
    ],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (priv-value : none)
###   written by Horisawa (2006.2.8)
{'TY:'=>'RULESET',
 'ID:'=>'SS.Privacy.Network-Provided.none',
 'RR:'=>[
    'SS.Privacy.Network-Provided.COMMON',
	'S.RFC3323-4-12_Privacy_none',
    ],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (priv-value : header)
###   written by Horisawa (2006.2.7)
{'TY:'=>'RULESET',
 'ID:'=>'SS.Privacy.Network-Provided.header',
 'RR:'=>[
    'SS.Privacy.Network-Provided.COMMON',
	'S.RFC3323-5-8_Privacy_header',
	'S.RFC3323-5-11_headers',
	'S.RFC3323-5-12_Via',
	'S.RFC3323-5-14_Contact',
	'S.RFC3323-5-16_Record-Route',

	### CAUTION !!!
	# When you use this ruleset,
	# you must delete the following rules:
	#   S.VIA_INSERT-NEWVIA-LINE			(when receiving request)
	#   S.CONTACT-URI_REMOTE-CONTACT-URI	(               request)
	#   S.RFC3261-8-82_Proxy-Require		(               ACK)
	#   S.VIA_REMOVE-TOPMOST				(when receiving response)

    ],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (priv-value : session)
###   written by Horisawa (2006.2.7)
{'TY:'=>'RULESET',
 'ID:'=>'SS.Privacy.Network-Provided.session',
 'RR:'=>[
    'SS.Privacy.Network-Provided.COMMON',
	'S.RFC3323-5-8_Privacy_session',
	'S.RFC3323-5-20_traffic',

	### CAUTION !!!
	# When you use this ruleset,
	# you must delete the following rules:
	#   S.BODY_ORIGINAL-BODY			(when receiving message with body) 
	#   S.CNTLENGTH_ORIGINAL-CNTLENGTH	(when receiving message with body) 
	#   S.RFC3261-8-82_Proxy-Require	(               ACK)

    ],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (priv-value : user)
###   written by Horisawa (2006.2.7)
{'TY:'=>'RULESET',
 'ID:'=>'SS.Privacy.Network-Provided.user',
 'RR:'=>[
    'SS.Privacy.Network-Provided.COMMON',
	'S.RFC3323-5-8_Privacy_user',
	'S.RFC3323-5-21_headers',
    'S.RFC3323-4-4_Call-ID',
    'S.RFC3323-4-5_From',
    'S.RFC3323-4-5_Reply-To',
    'S.RFC3323-4-6_From',
    'S.RFC3323-4-6_Reply-To',

	### CAUTION !!!
	# When you use this ruleset,
	# you must delete the following rules:
	#   S.FROM-URI_ORIGINAL-FROM-URI	(               message)
    #   S.FROM-URI_REMOTE-URI			(when receiving request)
	#   S.RFC3261-8-82_Proxy-Require	(               ACK)

    ],
},

### Judgment ruleset for Privacy Mechanism
###  (Network-Provided Privacy (priv-value : id)
###   written by Horisawa (2006.2.7)
{'TY:'=>'RULESET',
 'ID:'=>'SS.Privacy.Network-Provided.id',
 'RR:'=>[
    'SS.Privacy.Network-Provided.COMMON',
    ],
},

### Judgment ruleset for "P-Asserted-Identity" header
###   written by Horisawa (2006.2.10)
{'TY:'=>'RULESET',
 'ID:'=>'SS.Privacy.P-XXX-Identity.COMMON',
 'RR:'=>[
	'S.RFC3325-6-1_P-Preferred-Identity',
    'S.RFC3325-9-1_P-Asserted-Identity',
    'S.RFC3325-9-2_P-Asserted-Identity',
    'S.RFC3325-9-3_P-Asserted-Identity',
	'S.RFC3325-12-1_TLS',
    ],
},


##################
### Rule (ENCODE)
##################

### "Privacy" header (priv-value : none) 
###   written by Horisawa (2006.1.30)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3323_Privacy_none',
 'PT:'=>'HD',
 'NX:'=>'CSeq',
 'FM:'=>'Privacy: none',
},

### "Proxy-Require" header
###   written by Horisawa (2006.2.1)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3323-4-23_Proxy-Require',
 'PT:'=>'HD',
 'NX:'=>'Via',
 'FM:'=>'Proxy-Require: privacy',
},

### "Privacy" header (all priv-value except "none") 
###   written by Horisawa (2006.1.31)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3323-5-5_Privacy_priv-value',
 'PT:'=>'HD',
 'NX:'=>'CSeq',
 'FM:'=>'Privacy: header; session; user; critical; id',
},

### "Privacy" header (priv-value : header) 
###   written by Horisawa (2006.1.30)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3323_Privacy_header',
 'PT:'=>'HD',
 'NX:'=>'CSeq',
 'FM:'=>'Privacy: header',
},

### "Privacy" header (priv-value : session) 
###   written by Horisawa (2006.2.8)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3323_Privacy_session',
 'PT:'=>'HD',
 'NX:'=>'CSeq',
 'FM:'=>'Privacy: session',
},

### "Privacy" header (priv-value : user) 
###   written by Horisawa (2006.2.8)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3323_Privacy_user',
 'PT:'=>'HD',
 'NX:'=>'CSeq',
 'FM:'=>'Privacy: user',
},

### "Privacy" header (priv-value : id) 
###   written by Horisawa (2006.2.8)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3325_Privacy_id',
 'PT:'=>'HD',
 'NX:'=>'CSeq',
 'FM:'=>'Privacy: id',
},

### body (SRTP)
###   written by Horisawa (2006.2.8)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3323_BODY_SECURE',
 'PT:'=>'BD',
 'FM:'=>\q{"v=0\r\n" . 
       "o=- ".NINF('SDP_o_Session','LocalPeer')." %s IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP ".NINF('IPaddr','LocalPeer')."\r\n".
       "t=0 0\r\n". 
       "m=audio ".NINF('RTPPort','LocalPeer')." SRTP/AVP 0\r\n". 
       "a=rtpmap:0 PCMU/8000"},
 'AR:'=>[\q{NINFW('SDP_o_Version','+1','LocalPeer')}]
},

### "To" header for PV-1-1-5
###   written by Horisawa (2006.2.10)
{'TY:'=>'ENCODE',
 'ID:'=>'E.TO_REMOTE-URI_REMOTE-TAG_PV-1-1-5',
 'PT:'=>'HD',
 'NX:'=>'From',
 'FM:'=>'To: %s<%s>;tag=%s',
 'AR:'=>[\q{NINF('DisplayName','RemotePeer')?NINF('DisplayName','RemotePeer').' ':''},
 		 \q{NINF('RemoteAoRURI','LocalPeer')},\q{NINF('DLOG.RemoteTag')}]
},

### "P-Preferred-Identity" header
###   written by Horisawa (2006.2.10)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3325_P-Preferred-Identity',
 'PT:'=>'HD',
 'NX:'=>'Contact',
 'FM:'=>'P-Preferred-Identity: %s<%s>',
 'AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer').' ':''},
 		 \q{NINF('LocalAoRURI','LocalPeer')}]
},

### "P-Asserted-Identity" header
###   written by Horisawa (2006.2.10)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3325_P-Asserted-Identity_sip',
 'PT:'=>'HD',
 'NX:'=>'Contact',
 'FM:'=>'P-Asserted-Identity: %s<%s>',
 'AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer').' ':''},
 		 \q{NINF('LocalAoRURI','LocalPeer')}]
},

### "P-Asserted-Identity" header
###   written by Horisawa (2006.2.10)
{'TY:'=>'ENCODE',
 'ID:'=>'E.RFC3325_P-Asserted-Identity_tel',
 'PT:'=>'HD',
 'NX:'=>'Contact',
 'FM:'=>'P-Asserted-Identity: tel:+05011223344',
},



##################
### Rule (SYNTAX)
##################

#================= RFC3323 ===================

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
            $context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'via','ARG1:'=>$id
};

            if ((!FFIsMatchStr($CNT_CONF{'UA-HOSTNAME'},$id,'','',@_)) &&
                (!FFIsMatchStr($CNT_CONF{'UA-CONTACT-HOSTNAME'},$id,'','',@_)) &&
                (!FFIsMatchStr($CNT_CONF{'UA-ADDRESS'},$id,'','',@_))) {
                return 'OK';        # OK
            } else {
                return '';          # NG
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
 'EX:'=>\q{FFop('eq',\\\'HD.From.val.ad.disp','Anonymous',@_)}
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


### Judgment rule for "Privacy" header 
### (Basis for a determination : RFC3323-4-11)
###
### This term says about the intermediary's policy and the arrangement between the operater and a user.
### So, this rule is not implemented.
###
###   written by Horisasa (2006.1.30)

### Judgment rule for "Privacy" header (priv-value : none) 
### (Basis for a determination : RFC3323-4-12, RFC3323-4-15, RFC3323-5-3)
###   written by Horisasa (2006.1.3)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-4-12_Privacy_none',
 'CA:'=>'Privacy',
 'OK:'=>\\'An intermediary MUST NOT remove or modify the Privacy header if the \'none\' priv-value is specified.',
 'NG:'=>\\'An intermediary MUST NOT remove or modify the Privacy header if the \'none\' priv-value is specified.',
 'EX:'=>\q{FFop('eq',FV('HD.Privacy.txt',@_),FVib('send','','','HD.Privacy.txt'),@_)},
},

### Judgment rule for Privacy Service
### (Basis for a determination : RFC3323-4-19)
###
### Since there is no way to evaluate objectively 
###  whether a local outbound proxy has the privacy service function or not,
###  this rule is not implemented.
###
###   written by Horisasa (2006.1.31)



### Judgment rule for Privacy Service
### (Basis for a determination : RFC3323-5-1)
###
### Since there is no way to evaluate objectively 
###  whether the privacy service evaluates the level ov privacy from Privacy header or not,
###  this rule is not implemented.
###
###   written by Horisasa (2006.1.31)

### Judgment rule for Privacy Service
### (Basis for a determination : RFC3323-5-2)
###
### When Privacy Service doesn't perform any privacy function,
###  it isn't specified what is not performed concretely in RFC.
### So, this rule is not implemeted here.
###
###   written by Horisasa (2006.1.31)

### Judgment rule for Privacy Service
### (Basis for a determination : RFC3323-5-4)
###
### Since there is no way to know whether the privacy service supports 
###  "none/critical" or not objectively,
###  this rule is not implemented.
###
###   written by Horisasa (2006.1.31)

### Judgment rule for "500" Response
### (Basis for a determination : RFC3323-5-5)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-5_500',
 'CA:'=>'Status',
 'OK:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'NG:'=>\\'Status-Code(%s) MUST be \"500\" Server Internal Error.',
 'PR:'=>sub{
	 	my($rule,$pktinfo,$context)=@_;
 		my(@a,$i,$scode);
		
		$scode = FV('RQ.Status-Line.code','',$pktinfo);
		$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'via','ARG1:'=>$scode};
		@a = split(/\;\ /, FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)));
		
		for($i=0;$i<=$#a;$i++) {
			if (@a[$i] eq "critical") {
				return 'MATCH';
			}
		}
		return '';	# UNMATCH
	},
 'EX:'=>\q{FFop('eq',\\\'RQ.Status-Line.code','500',@_)},
},

### Judgment rule for reason phrase
### (Basis for a determination : RFC3323-5-6)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-6_reason-phrase',
 'CA:'=>'Status',
 'OK:'=>\\'The reason phrase of 500 response SHOULD contain unsupported priv-values and appropriate text indicating a privacy failure.',
 'NG:'=>\\'The reason phrase of 500 response SHOULD contain unsupported priv-values and appropriate text indicating a privacy failure.',
 'RT:'=>'warning',
 'PR:'=>\q{FFop('eq',\\\'RQ.Status-Line.code','500',@_)},
 'EX:'=>\q{FFIsMatchStr('header',FV('RQ.Status-Line.reason',@_))
		   || FFIsMatchStr('session',FV('RQ.Status-Line.reason',@_))
		   || FFIsMatchStr('user',FV('RQ.Status-Line.reason',@_))
		   || FFIsMatchStr('none',FV('RQ.Status-Line.reason',@_))
		   || FFIsMatchStr('id',FV('RQ.Status-Line.reason',@_))
 		},
},

### Judgment rule for Accept-Language
### (Basis for a determination : RFC3323-5-7)
###
### This tester only supports English (ASCII).
### So, this rule is not implemented here.
###
###   written by Horisawa (2006.1.31)

### Judgment rule for removing priv-values (priv-value : header)
### (Basis for a determination : RFC3323-5-8)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-8_Privacy_header',
 'CA:'=>'Privacy',
 'OK:'=>\\'A Privacy Service SHOULD remove the corresponding priv-value from Privacy header when one of the functions listed in Privacy header is performed.',
 'NG:'=>\\'A Privacy Service SHOULD remove the corresponding priv-value from Privacy header when one of the functions listed in Privacy header is performed.',
 'PR:'=>\q{FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'header',@_)},	# not general-porpose (assumed that 'header' only...)
 'EX:'=>\q{!FFIsMember(['header'],FVSeparete('HD.Privacy.txt','\s*\;\s*',@_),'',@_)},
},

### Judgment rule for removing priv-values (priv-value : session)
### (Basis for a determination : RFC3323-5-8)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-8_Privacy_session',
 'CA:'=>'Privacy',
 'OK:'=>\\'A Privacy Service SHOULD remove the corresponding priv-value from Privacy header when one of the functions listed in Privacy header is performed.',
 'NG:'=>\\'A Privacy Service SHOULD remove the corresponding priv-value from Privacy header when one of the functions listed in Privacy header is performed.',
 'PR:'=>\q{FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'session',@_)},	# not general-porpose (assumed that 'session' only...)
 'EX:'=>\q{!FFIsMember(['session'],FVSeparete('HD.Privacy.txt','\s*\;\s*',@_),'',@_)},
},

### Judgment rule for removing priv-values (priv-value : user)
### (Basis for a determination : RFC3323-5-8)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-8_Privacy_user',
 'CA:'=>'Privacy',
 'OK:'=>\\'A Privacy Service SHOULD remove the corresponding priv-value from Privacy header when one of the functions listed in Privacy header is performed.',
 'NG:'=>\\'A Privacy Service SHOULD remove the corresponding priv-value from Privacy header when one of the functions listed in Privacy header is performed.',
 'PR:'=>\q{FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'user',@_)},	# not general-porpose (assumed that 'user' only...)
 'EX:'=>\q{!FFIsMember(['user'],FVSeparete('HD.Privacy.txt','\s*\;\s*',@_),'',@_)},
},

### Judgment rule for removing priv-values (priv-value : id)
### (Basis for a determination : RFC3323-5-8)
###   written by Horisawa (2006.1.31)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-8_Privacy_id',
 'CA:'=>'Privacy',
 'OK:'=>\\'A Privacy Service SHOULD remove the corresponding priv-value from Privacy header when one of the functions listed in Privacy header is performed.',
 'NG:'=>\\'A Privacy Service SHOULD remove the corresponding priv-value from Privacy header when one of the functions listed in Privacy header is performed.',
 'PR:'=>\q{FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'id',@_)},	# not general-porpose (assumed that 'id' only...)
 'EX:'=>\q{!FFIsMember(['id'],FVSeparete('HD.Privacy.txt','\s*\;\s*',@_),'',@_)},
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

### Judgment rule for headers reavealing personal information (Call-Info, Server, Organization)
### (Basis for a determination : RFC3323-5-11)
###   written by Horisawa (2006.2.1)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-11_headers',
 'CA:'=>'Header',
 'OK:'=>\\'A Privacy Service SHOULD NOT add any headers revealing personal information.',
 'NG:'=>\\'A Privacy Service SHOULD NOT add any headers revealing personal information.',
 'PR:'=>\q{FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'header',@_)},	# not general-porpose (assumed that 'header' only...)
 'EX:'=>\q{!FFIsExistHeader('Call-Info',@_) && !FFIsExistHeader('Server',@_) && !FFIsExistHeader('Organization',@_)},
},

### Judgment rule for "Via" header (Via stripping)
### (Basis for a determination : RFC3323-5-12, RFC3323-5-13)
###   written by Horisawa (2006.2.1)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-12_Via',
 'CA:'=>'Via',
 'OK:'=>\\'A Privacy Service SHOULD remove all Via headers added in previous hops, and SHOULD add a single Via header representing itself.',
 'NG:'=>\\'A Privacy Service SHOULD remove all Via headers added in previous hops, and SHOULD add a single Via header representing itself.',
 'PR:'=>\q{FFop('ne',\\\'RQ.Request-Line.method','',@_)		# for request
		   && FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'header',@_)},	# not general-porpose (assumed that 'header' only...)
 'RT:'=>'warning',
 'EX:'=>\q{(FVs('HD.Via.val.via.txt',@_)->[1] eq '') && 
 			(FFIsMatchStr(NDCFG('uri.hostname','PX1'),FVs('HD.Via.val.via.txt',@_)->[0],'','',@_)
			 || FFIsMatchStr(NDCFG('address','PX1'),FVs('HD.Via.val.via.txt',@_)->[0],'','',@_)
			 )
		},
},

### Judgment rule for "Contact" header (undereferenceable URI)
### (Basis for a determination : RFC3323-5-14, RFC3323-5-15, RFC3323-5-18)
###   written by Horisawa (2006.2.1)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-14_Contact',
 'CA:'=>'Contact',
 'OK:'=>\\'Privacy Servise MUST replace the value of Contact header with the URI which can derefer to privacy service instead of the originater of the message.',
 'NG:'=>\\'Privacy Servise MUST replace the value of Contact header with the URI which can derefer to privacy service instead of the originater of the message.',
 'PR:'=>\q{FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'header',@_)		# not general-porpose (assumed that 'header' only...)
		   && FFIsExistHeader("Contact",@_)},
 'EX:'=>\q{FFIsMatchStr(NDCFG('uri.hostname','PX1'),FVs('HD.Contact.txt',@_),'','',@_) && 
		   FFIsMatchStr(($SIP_PL_TRNS eq "TLS")?"sips":"sip",FV('HD.Contact.val.contact.ad.ad.txt',@_),'','',@_)
		},
},

### Judgment rule for "Record-Route" header (Record-Route stripping)
### (Basis for a determination : RFC3323-5-16, RFC3323-5-18)
###   written by Horisawa (2006.2.1)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-16_Record-Route',
 'CA:'=>'Record-Route',
 'OK:'=>\\'A Privacy Service SHOULD remove all Record-Route headers added in previous hops (except the one representing itself).',
 'NG:'=>\\'A Privacy Service SHOULD remove all Record-Route headers added in previous hops (except the one representing itself).',
 'PR:'=>\q{FFop('ne',\\\'RQ.Request-Line.method','',@_)		# for request
		   && FFIsExistHeader('Record-Route','',PKT('LAST','send','HD.CSeq.txt',FV('HD.CSeq.txt',@_)))
		   && FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'header',@_)	# not general-porpose (assumed that 'header' only...)
 	},
 'RT:'=>'warning',
 'EX:'=>\q{!FFIsExistHeader('Record-Route',@_) || FFIsMatchStr(NDCFG('uri.hostname','PX1'),FVs('HD.Record-Route.val.route.txt',@_)->[0],'','',@_)},
},

### Judgment rule for stripped/modified headers
### (Basis for a determination : RFC3323-5-17, RFC3323-5-18)
###
### This rule is able to be replaced by communication between pseudo-UA ordinally, 
###  as if a Privacy Service doesn't exist.
###
###   written by Horisawa (2006.2.7)

### Judgment rule for "Privacy" header (priv-value : session)
### (Basis for a determination : RFC3323-5-19)
###
### It is difficult to determine whether the target is B2BUA or not.
### So, this rule is not implemented here.
###
###   written by Horisawa (2006.2.1)

### Judgment rule for applying security to session traffic
### (Basis for a determination : RFC3323-5-20)
###   written by Horisawa (2006.2.1)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-20_traffic',
 'CA:'=>'Body',
 'OK:'=>\\'It is RECOMMENDED that some sort of end-to-end security is applied to the session traffic.',
 'NG:'=>\\'It is RECOMMENDED that some sort of end-to-end security is applied to the session traffic.',
 'PR:'=>\q{FV('BD.txt',@_)
		   && FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'session',@_)	# not general-porpose (assumed that 'session' only...)
 	},
 'RT:'=>'warning',
 'EX:'=>\q{FFIsMember(['SRTP'], FVSeparete('BD.m=.val.media.proto','\s*\/\s*',@_),'',@_)},
},

### Judgment rule for headers which must not be included
### (Basis for a determination : RFC3323-5-21)
###   written by Horisawa (2006.2.1)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3323-5-21_headers',
 'CA:'=>'Header',
 'OK:'=>\\'Any non-essential information headers MUST be removed by the privacy service.',
 'NG:'=>\\'Any non-essential information headers MUST be removed by the privacy service.',
 'PR:'=>\q{FFop('eq',FVib('send','','','HD.Privacy.txt','RQ.Request-Line.method',FV('HD.CSeq.val.method',@_)),'user',@_)},		# not general-porpose (assumed that 'user' only...)
 'EX:'=>\q{!FFIsExistHeader(['Subject','Call-Info','Organization','User-Agent','Reply-To','In-Reply-To'],@_)},
},

### Judgment rule for "Privacy" header (priv-value : user)
### (Basis for a determination : RFC3323-5-22)
###
### The detail operation of B2BUA is not specified in any RFC (including RFC3261).
### So, this rule is not implemented here.
###
###   written by Horisawa (2006.2.1)

### Judgment rule for "Privacy" header (priv-value : user)
### (Basis for a determination : RFC3323-5-23)
###
### Since there is no way to evaluate objectively 
###  whether the privacy service persists the former values of 
###  the dialog-matching headers.
### So, this rule is not implemented here.
###
###   written by Horisawa (2006.2.1)

### Judgment rule for "Privacy" header (priv-value : user)
### (Basis for a determination : RFC3323-5-24)
###   written by Horisawa (2006.2.1)


#================= RFC3325 ===================

### Judgment rule for Spec(T)
### (Basis for a determination : RFC3325-1-1)
###
### This is a policy which each Trust Domain follows, 
###  and it isn't a property to judge from a received message.
### So, this rule is not implemented.
###
###   written by Horisawa (2006.2.6)

### Judgment rule for "P-Asserted-Identity" header
### (Basis for a determination : RFC3325-4-1, RFC3325-7-1, RFC3325-7-7)
###   written by Horisawa (2006.2.1)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-4-1_P-Asserted-Identity',
 'CA:'=>'P-Asserted-Identity',
 'OK:'=>\\'The P-Asserted-Identity header MUST be removed when the SIP message is forwarded to untrusted domain and the user requested that the information is kept private.',
 'NG:'=>\\'The P-Asserted-Identity header MUST be removed when the SIP message is forwarded to untrusted domain and the user requested that the information is kept private.',
 'PR:'=>\q{FFIsExistHeader('P-Asserted-Identity','',PKT('LAST','send','HD.CSeq.txt',FV('HD.CSeq.txt',@_)))
		   && FFop('eq',FVib('send','','','HD.Privacy.txt', 'HD.CSeq.txt',FV('HD.CSeq.txt',@_)),'id',@_)	# not general-porpose (assumed that 'id' only...)
		},	
 'EX:'=>\q{!FFIsExistHeader('P-Asserted-Identity',@_)},
},



### Judgment rule for Authentication 
### (Basis for a determination : RFC3325-5-1)
###   written by Horisasa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-5-1_Authentication',
 'CA:'=>'Status',
 'OK:'=>\\'A Proxy MUST authenticate the node that is not trusted by the proxy and wish to add P-Asserted-Identitiy header to the message. ',
 'NG:'=>\\'A Proxy MUST authenticate the node that is not trusted by the proxy and wish to add P-Asserted-Identitiy header to the message. ',
 'PR:'=>\q{FFop('eq',FVib('send','','','HD.Privacy.txt','HD.CSeq.txt',FV('HD.CSeq.txt',@_)),'id',@_)},	# not general-porpose (assumed that 'id' only...)
 'EX:'=>\q{FFop('eq',FV('RQ.Status-Line.code',@_),'407',@_)},
},

### Judgment rule for Authentication 
### (Basis for a determination : RFC3325-6-1)
###   written by Horisasa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-6-1_P-Preferred-Identity',
 'CA:'=>'P-Preferred-Identity',
 'OK:'=>\\'A P-Preferred-Identity header MUST be removed from any message that is forwarded by proxy.',
 'NG:'=>\\'A P-Preferred-Identity header MUST be removed from any message that is forwarded by proxy.',
 'PR:'=>\q{FFIsExistHeader('P-Preferred-Identity','',PKT('LAST','send','HD.CSeq.txt',FV('HD.CSeq.txt',@_)))},
 'EX:'=>\q{!FFIsExistHeader('P-Preferred-Identity',@_)},
},

### Judgment rule for "P-Asserted-Identity" header
### (Basis for a determination : RFC3325-9-1)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-9-1_P-Asserted-Identity',
 'CA:'=>'P-Asserted-Identity',
 'OK:'=>'A P-Asserted-Identity header field value MUST consist of exactly one name-addr or addr-spec.',
 'NG:'=>'A P-Asserted-Identity header field value MUST consist of exactly one name-addr or addr-spec.',
 'PR:'=>\q{FFIsExistHeader("P-Asserted-Identity",@_)},
 'EX:'=>sub{
        my($rule,$pktinfo,$context)=@_;

        if ((!FFIsMatchStr(".*<(sip|sips)\:.*\@.*>",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[0],
                        '','','',$pktinfo))
            && (!FFIsMatchStr(".*<tel\:.*>",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[0],
                        '','','',$pktinfo))
            && (!FFIsMatchStr("(sip|sips)\:.*\@.*",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[0],
                        '','','',$pktinfo))
            && (!FFIsMatchStr("tel\:.*",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[0],
                        '','','',$pktinfo))) {
            return '';  # unmatch (addr-spec)
        }

    if ((FVs('HD.P-Asserted-Identity.val.val.txt',@_)->[1] ne '')
            && (FVs('HD.P-Asserted-Identity.val.val.txt',@_)->[2] eq '')) {

        if ((!FFIsMatchStr(".*<(sip|sips)\:.*\@.*>",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[1],
                        '','','',$pktinfo))
            && (!FFIsMatchStr(".*<tel\:.*>",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[1],
                        '','','',$pktinfo))
            && (!FFIsMatchStr("(sip|sips)\:.*\@.*",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[1],
                        '','','',$pktinfo))
            && (!FFIsMatchStr("tel\:.*",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[1],
                        '','','',$pktinfo))) {
            return '';  # unmatch (addr-spec)
        }
    }

        return 'MATCH'; # match
    },
},

### Judgment rule for "P-Asserted-Identity" header
### (Basis for a determination : RFC3325-9-2)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-9-2_P-Asserted-Identity',
 'CA:'=>'P-Asserted-Identity',
 'OK:'=>'A P-Asserted-Identity header field value MUST be a sip, sips, or tel URI if there is one P-Asserted-Identity value.',
 'NG:'=>'A P-Asserted-Identity header field value MUST be a sip, sips, or tel URI if there is one P-Asserted-Identity value.',
 'PR:'=>\q{FFIsExistHeader("P-Asserted-Identity",@_)
        && (FVs('HD.P-Asserted-Identity.val.val.txt',@_)->[1] eq '')
        },
 'EX:'=>sub{
        my($rule,$pktinfo,$context)=@_;

        if (FFIsMatchStr(".*(sip|sips)\:.*@.*",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[0],
                        '','','',$pktinfo)
            || FFIsMatchStr(".*tel\:.*",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[0],
                        '','','',$pktinfo)) {
            return 'MATCH';     # tel-URI or sip/sips-URI
        }

        return '';      # unmatch (not sip/sips/tel-URI)
    },
},

### Judgment rule for "P-Asserted-Identity" header
### (Basis for a determination : RFC3325-9-3, RFC3325-9-4)
###   written by Horisawa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-9-3_P-Asserted-Identity',
 'CA:'=>'P-Asserted-Identity',
 'OK:'=>'One of P-Asserted-Identity header field values MUST a sip or sips URI and the other MUST be a tel URI if there are two P-Asserted-Identity values.',
 'NG:'=>'One of P-Asserted-Identity header field values MUST a sip or sips URI and the other MUST be a tel URI if there are two P-Asserted-Identity values.',
 'PR:'=>\q{FFIsExistHeader("P-Asserted-Identity",@_)
        && (FVs('HD.P-Asserted-Identity.val.val.txt',@_)->[1] ne '')
        && (FVs('HD.P-Asserted-Identity.val.val.txt',@_)->[2] eq '')
        },
 'EX:'=>sub{
        my($rule,$pktinfo,$context)=@_;

        if (FFIsMatchStr(".*(sip|sips)\:.*@.*",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[0],
                        '','','',$pktinfo)) {
            if (FFIsMatchStr(".*tel\:.*",
                            FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[1],
                            '','','',$pktinfo)) {
                return 'MATCH';     # sip/sips-URI and tel-URI
            } else {
                return '';          # unmatch (both sip/sips ?)
            }
        } elsif (FFIsMatchStr(".*tel\:.*",
                        FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[0],
                        '','','',$pktinfo)) {
            if (FFIsMatchStr(".*(sip|sips)\:.*@.*",
                            FVs('HD.P-Asserted-Identity.val.val.ad.txt','',$pktinfo)->[1],
                            '','','',$pktinfo)) {
                return 'MATCH';     # tel-URI and sip/sips-URI
            } else {
                return '';          # unmatch (both tel ?)
            }
        }

        return '';
    },
},

### Judgment rule for Security
### (Basis for a determination : RFC3325-12-1)
###   written by Horisasa (2006.2.10)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3325-12-1_TLS',
 'CA:'=>'TLS',
 'OK:'=>\\'The trusted entity that send a message with P-Asserted-Identity header MUST take precautions to protect the identity information.',
 'NG:'=>\\'The trusted entity that send a message with P-Asserted-Identity header MUST take precautions to protect the identity information. (ex. TLS or IPsec)',
 'PR:'=>\q{FFIsExistHeader("P-Asserted-Identity",@_)},
 'EX:'=>\q{$SIP_PL_TRNS eq "TLS"},
},





); ### @SIPPXRulesPrivacy



return 1;

