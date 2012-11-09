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
@SIPPXRules2 =
(


###############################################################
###  Encode rule
###############################################################

# ACK
# ACK Request-URI = SIP-URI of Proxy Server  (ex. ACK sip:ss2.biloxi.example.com SIP/2.0)
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACK_PROXY-URI-STRICT','PT:'=>RQ,
  'FM:'=>'ACK %s SIP/2.0',
  'AR:'=>[\q{NINF('DLOG.RouteSet#1')}]},


#  OPTIONS Request-URI=AoR(Address-of-record)
 {'TY:'=>'ENCODE', 'ID:'=>'E.OPTIONS_AOR-URI','PT:'=>RQ,
  'FM:'=>'OPTIONS %s SIP/2.0','AR:'=>[\q{NINF('LocalAoRURI','RemotePeer')}]},

# OPTIONS
# OPTIONS Request-URI = SIP-URI of Proxy Server
 {'TY:'=>'ENCODE', 'ID:'=>'E.OPTIONS_PROXY-URI','PT:'=>RQ,
  'FM:'=>'OPTIONS %s:%s:%s SIP/2.0','AR:'=>[\q{($SIP_PL_TRNS eq "TLS")?"sips":"sip"},\q{$CNT_CONF{'REG-HOSTNAME'}}, \q{NINF('SIPPort','PX1')}]},
# From header without tag
 {'TY:'=>'ENCODE', 'ID:'=>'E.FROM_LOCAL-URI_NO-TAG','PT:'=>'HD', 
  'FM:'=>'From: %s<%s>','AR:'=>[\q{NINF('DisplayName','LocalPeer')?NINF('DisplayName','LocalPeer') . ' ':''},
				       \q{NINF('LocalAoRURI','LocalPeer')},]},

#  To header for Proxy Server (OPTIONS, no display name)
 {'TY:'=>'ENCODE', 'ID:'=>'E.TO_PROXY-URI_NO-TAG','PT:'=>'HD', 
  'FM:'=>'To: <%s>','AR:'=>[\q{NINFW('RemoteAoRURI',(($SIP_PL_TRNS eq "TLS")?"sips":"sip"). ':' . NDCFG('uri.hostname', 'PX1') )}]},


#Content-Disposition
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTENTDISPOSITION_VALID', 'PT:'=>HD,
  'FM:'=>'Content-Disposition: session;handling=required'},

#Content-Encoding (invalid)
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTENTENCODING_UNKNOWN', 'PT:'=>HD,
  'FM:'=>'Content-Encoding: unknownEncoding'},

#Content-Language (invalid)
 {'TY:'=>'ENCODE', 'ID:'=>'E.CONTENTLANGUAGE_UNKNOWN', 'PT:'=>HD,
  'FM:'=>'Content-Language: unknownLunguage'},

# Route header value equals Contact address of the callee
 {'TY:'=>'ENCODE', 'ID:'=>'E.ROUTE_CALLER_STRICT','PT:'=>'HD', 
  'FM:'=>'Route: <%s>',
  'AR:'=>[\q{NINF('RemoteContactURI', 'LocalPeer')}]},


# Timestamp header (for PX-UA-7-1-1)
 {'TY:'=>'ENCODE', 'ID:'=>'E.TIMESTAMP_VALID','PT:'=>'HD', 
  'FM:'=>'Timestamp: %s',
  'AR:'=>[\'$CVA_TIME_STAMP']}, 

# Accept-Encoding header
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACCEPT-ENCODING_VALID','PT:'=>'HD', 
  'FM:'=>'Accept-Encoding: gzip',},

# Accept-Language header
 {'TY:'=>'ENCODE', 'ID:'=>'E.ACCEPT-LANGUAGE_VALID','PT:'=>'HD', 
  'FM:'=>'Accept-Language: en',},



###############################################################
### 	12. Via
###	E.VIA_RETURN_RECEIVED_MYNODE
###############################################################	
# 
# 
# 
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_RETURN_RECEIVED_MYNODE','PT:'=>'HD',
  'FM:'=>'%s',
  'AR:'=>[sub{ my($vias,$hed,$via,$host);
	       # $vias=FVs('HD.Via.txt', '', NDPKT('','MY','','recv'));
	       $vias=FVs('HD.Via.txt', '', 'NDLAST');  ## SIPsvc.pm 
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

# Via
# 
 {'TY:'=>'ENCODE', 'ID:'=>'E.VIA_NOHOP.PORTCHANGE','PT:'=>'HD', 
  'FM:'=>'Via: SIP/2.0/%s %s',
#  'AR:'=>[sub{ $CVA_COUNT_BRANCH++;
  'AR:'=>[$SIP_PL_TRNS,sub{ $CVA_COUNT_BRANCH++; ## 2006.2.9 sawada ##
               SetupViaParam($CVA_COUNT_BRANCH);
               @CNT_NOPX_SEND_VIAS = (NDCFG('contact.hostname','UA11') . ":" . "$CNT_PUA_PORT;branch=$CVA_PUA_BRANCH_HISTORY");
               return @CNT_NOPX_SEND_VIAS[0];} ]},





###############################################################
###  Encode rule set
###############################################################

## ACK request (with Proxy-Authorization header, strict routing)
## **** making 050906
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK.ACT-AS-STRICT-R.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.ACK_PROXY-URI-STRICT',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
        'E.ROUTE_CALLER_STRICT',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0',
	],
  'EX:' =>\&MargeSipMsg},


## BYE request (with Proxy-Authorization header)
###############################################################	

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE-AUTH.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_NOHOP',# 
	'E.MAXFORWARDS_NOHOP',# 
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},




# 
## INVITE request (with unknown Content-Encoding header, invalid body, originated from UA)
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.UNKNOWN_ENCODING.TM', 'MD:'=>'SEQ', 
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
	'E.CONTENTDISPOSITION_VALID',
        'E.CONTENTENCODING_UNKNOWN',
	'E.CONTENT-LENGTH_CAL',
#	'E.BODY_VALID'],
	'E.BODY_UNKNOWN'],
  'EX:' =>\&MargeSipMsg},


# 
## INVITE request (with unknown Content-Language header, invalid body, originated from UA)
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.UNKNOWN_LANGUAGE.TM', 'MD:'=>'SEQ', 
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
	'E.CONTENTDISPOSITION_VALID',
        'E.CONTENTLANGUAGE_UNKNOWN',
	'E.CONTENT-LENGTH_CAL',
#	'E.BODY_VALID'],
	'E.BODY_UNKNOWN'],
  'EX:' =>\&MargeSipMsg},


## INVITE request with Proxy-Authorization
## (with unknown Content-Encoding header, invalid body, originated from UA)
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.UNKNOWN_ENCODING.TM', 'MD:'=>'SEQ', 
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
	'E.CONTENTDISPOSITION_VALID',
        'E.CONTENTENCODING_UNKNOWN',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_UNKNOWN'],  ## ADD
  'EX:' =>\&MargeSipMsg},


## INVITE request with Proxy-Authorization
## (with unknown Content-Encoding header, invalid body, originated from UA)
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.UNKNOWN_LANGUAGE.TM', 'MD:'=>'SEQ', 
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
	'E.CONTENTDISPOSITION_VALID',
        'E.CONTENTLANGUAGE_UNKNOWN',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_UNKNOWN'],  ## ADD
  'EX:' =>\&MargeSipMsg},



## INVITE request(with SDP, originated from UA)
## invalid message because no From tag exist.
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE.NO-FROM-TAG.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_NO-TAG',
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




## INVITE request with Proxy-Authorization (with SDP, originated from UA)
## invalid message because no From tag exist.
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH.NO-FROM-TAG.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
        'E.P-AUTH_RESPONSE_QOP',
        'E.P-AUTH_RESPONSE_NOQOP',
	'E.FROM_LOCAL-URI_NO-TAG',
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



## INVITE request (port change) (with SDP, originated from UA)
## used for PX-UA-8-1-7
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-PORTCHANGE.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP.PORTCHANGE',
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


# INVITE request with Proxy-Authorization (with SDP, originated from UA)
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.INVITE-AUTH-PORTCHANGE.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.INVITE_AOR-URI',
	'E.VIA_NOHOP.PORTCHANGE',
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


## ACK request for non 2xx response
## invalid message because no From tag exist.
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-NO2XX.NO-FROM-TAG.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.ACK_AOR-URI',
	'E.VIA_NOPX-NOCOUNT',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_NO-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},



## ACK request for 2xx response
## invalid message because no From tag exist.
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.NO-FROM-TAG.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_NO-TAG',
	'E.TO_REMOTE-URI_REMOTE-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

## ACK request for 2xx response
## invalid message because no To tag exist.
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.ACK-2XX.NO-TO-TAG.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.ACK_CONTACT-URI',
	'E.VIA_NOHOP',	
	'E.MAXFORWARDS_NOHOP',
	'E.P-AUTH_RESPONSE_QOP',
	'E.P-AUTH_RESPONSE_NOQOP',
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_ACK',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},



## BYE request from UA
## invalid message because no To tag exist.
###############################################################	

 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.NO-TO-TAG.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_NOHOP',# 
	'E.MAXFORWARDS_NOHOP',# 
        'E.ROUTE_TWOURIS',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


## BYE request from proxy
## invalid message because no To tag exist.
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.BYE.NO-TO-TAG.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.BYE_CONTACT-URI',
	'E.VIA_ONEHOP',
	'E.MAXFORWARDS_ONEHOP',
        'E.ROUTE_ONEURI',
        'E.RECORDROUTE_ONEHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',# 
	# 'E.TO_REMOTE-URI_REMOTE-TAG'
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_BYE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


###  OPTIONS request from UA to another UA
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.OPTIONS.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.OPTIONS_AOR-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	'E.TO_REMOTE-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_OPTIONS',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0',
	'E.ACCEPT_SDP',
	],
  'EX:' =>\&MargeSipMsg},

###  OPTIONS request from UA to Proxy
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.REQUEST.OPTIONS.FOR-PROXY.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
        'E.OPTIONS_PROXY-URI',
	'E.VIA_NOHOP',
	'E.MAXFORWARDS_NOHOP',
	'E.FROM_LOCAL-URI_LOCAL-TAG',
	# 'E.TO_RG-URI_NO-TAG',
	'E.TO_PROXY-URI_NO-TAG',
	'E.CALLID_CVA',
	'E.CSEQ_NUM_OPTIONS',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0',
	'E.ACCEPT_SDP',
	],
  'EX:' =>\&MargeSipMsg},



###  180 response without To tag
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.180.NO-TO-TAG.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-180',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_TWOHOPS',
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},



###  183 response for 1 proxy
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.183.ONEPX.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-183',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_TWOHOPS',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

###  183 response for 2 proxy
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.183.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-183',
	'E.VIA_RETURN_RECEIVED_MYNODE',
	'E.RECORDROUTE_TWOHOPS',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},

###  199 response
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.199.ONEPX.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-199',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORDROUTE_TWOHOPS',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\&MargeSipMsg},


### 200 response with SDP (mainly for 200 for INVITE)
###  no To tag parameter
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200-SDP-ANS.NO-TO-TAG.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
        'E.RECORDROUTE_TWOHOPS',	
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTACT_URI',       
	'E.ALLOW_VALID',
###	'E.SUPPORTED_VALID',		# 20050406 usako delete
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY.MEDIA-DESCRIPTION'],
  'EX:'=>\&MargeSipMsg},


###  200 without body from UA (mainly 200 for BYE)
###  no To tag parameter
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200.TWOPX.NO-TO-TAG.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED_TWOPX.TM',
	'E.RECORDROUTE_ASIS',  ###add 20050113 
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


###  200 without body from Proxy (mainly 200 for BYE)
###  no To tag parameter
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.200.NO-TO-TAG.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
        'E.RECORDROUTE_ASIS',
	'EESet.BASIC-FTCC-RETURN-NOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


###  299 response
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.299-SDP-ANS.ONEPX.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-299',
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




### 	415 response Used by Proxy
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-415-RETURN.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-415',
	'E.VIA_RETURN_RECEIVED',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
        'E.ACCEPT_SDP',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


### 	480 response
###	ES.STATUS-480-RETURN
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-480-RETURN_MYNODE.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-480',
	'E.VIA_RETURN_RECEIVED_MYNODE',
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


### 499 response
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-499-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-499',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},



### 	500 response for BYE request Used by Proxy
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-500-RETURN.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-500',
	'E.VIA_RETURN_RECEIVED',
	'E.RECORD-ROUTE_ADD-PROXY-URI',
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},



### 599 response
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-599-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-599',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},

### 699 response
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS-699-RETURN.TM', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-699',
	'E.VIA_INVITE-RETURN_RECEIVED_TWOPX.TM', # add tadokoro
	'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
	'E.CONTENT-LENGTH_0'],
  'EX:'=>\q{MargeSipMsg(@_)}},


### 200 repsonse for OPTIONS request
###############################################################	
 {'TY:'=>'RULESET', 'ID:'=>'ES.STATUS.OPTIONS-200.PX', 'MD:'=>'SEQ', 
  'RR:'=>[
	'E.STATUS-200',
	'E.VIA_RETURN_RECEIVED',
        'E.RECORDROUTE_TWOHOPS',	#
	'EESet.BASIC-FTCC-RETURN-TOTAG',
	'E.CONTACT_URI',       
	'E.ALLOW_VALID',
	'E.RES.SUPPORTED_VALID',	# 20050406 usako add
        'E.ACCEPT_SDP',
        'E.ACCEPT-ENCODING_VALID',
        'E.ACCEPT-LANGUAGE_VALID',
	'E.CONTENTTYPE_VALID',
	'E.CONTENT-LENGTH_CAL',
	'E.BODY_VALID'],
  'EX:'=>\&MargeSipMsg},


###############################################################
###  Syntax rule ##############################################
###############################################################

 # %% R-URI:01 %%	Request-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.R-URI_PROXY-URI', 'CA:' => 'Request',
   'OK:' => \\'Request-URI(%s) MUST equal the URI(%s) of the proxy that Tester emulates(form of IP address, port number is not acceptable).', 
   'NG:' => \\'Request-URI(%s) MUST equal the URI(%s) of the proxy that Tester emulates(form of IP address, port number is not acceptable).', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('RQ.Request-Line.uri',@_),NINF('DLOG.RouteSet#0'),@_)} },

 # %% ALLOW:02 %%	Allow
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ALLOW_NOT-EXIST', 'CA:' => 'Allow',
   'OK:' => "An Allow header field SHOULD NOT exist.", 
   'NG:' => "An Allow header field SHOULD NOT exist.", 
   'RT:' => "warning", 
   'EX:' => \q{!FFIsExistHeader(['Allow'],@_)}}, 

 # %% TO:01 %%	To-URI
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.TO-URI_PROXY-URI', 'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field MUST equal the SIP-URI(%s) of the Proxy.', 
   'NG:' => \\'The URI(%s) in the To field MUST equal the SIP-URI(%s) of the Proxy.', 
   'EX:' => \q{FFCompareAddress('UserInfoHostPort','name-strict',FV('HD.To.val.ad',@_), NINF('RemoteAoRURI'),@_)} },


 # %% ROUTE:nn %%	Route
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ROUTE_ORIGINAL-R-URI', 'CA:' => 'Route',
   'OK:' => \\'The Route header field(%s) MUST equal the Request-URI(%s) in original message.', 
   'NG:' => \\'The Route header field(%s) MUST equal the Contact-URI(%s) in original message.', 
   'EX:' => \q{FFop('eq',FV('HD.Route.val.route.ad.ad.txt',@_),NINF('LocalContactURI','LocalPeer'),@_)}},


 # %% Contact:nn %% Contact
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT_ORIGINAL-CONTACT', 'CA:' => 'From',
   'OK:' => \\'The Contact header(%s) SHOULD equal that in the original message(%s).', 
   'NG:' => \\'The Contact header(%s) SHOULD equal that in the original message(%s).', 
   'RT:' => "warning", 
   'EX:' => \q{FFop('eq',FV('HD.Contact.txt',@_),FV('HD.Contact.txt','',NDPKT(@_[1])),@_)}}, 

 # %% CONTACT:nn %%	Contact
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.CONTACT_EXIST_SHOULD', 'CA:' => 'Contact',
   'OK:' => "A Contact header field SHOULD exist.", 
   'NG:' => "A Contact header field SHOULD exist.", 
   'EX:' =>\'FFIsExistHeader("Contact",@_)'},


 # %% Allow:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ALLOW_ORIGINAL-ALLOW', 'CA:' => 'Allow',
   'OK:' => \\'The Allow header value(%s) MUST equal the Allow header value(%s) in the original message.', 
   'NG:' => \\'The Allow header value(%s) MUST equal the Allow header value(%s) in the original message.', 
   'EX:' => \q{ FFop( 'eq',FV('HD.Allow.txt', @_ ) , FV('HD.Allow.txt','', NDPKT(@_[1]) ) , @_ ) }},

 # %% Accept:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT_ORIGINAL-ACCEPT', 'CA:' => 'Accept',
   'OK:' => \\'The Accept header value(%s) MUST equal the Accept header value(%s) in the original message.', 
   'NG:' => \\'The Accept header value(%s) MUST equal the Accept header value(%s) in the original message.', 
   'EX:' => \q{ FFop( 'eq',FV('HD.Accept.val', @_ ) , FV('HD.Accept.val','', NDPKT(@_[1]) ) , @_ ) }},

 # %% Accept-Encoding:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT-ENCODING_ORIGINAL-ACCEPT-ENCODING', 'CA:' => 'Accept-Encoding',
   'OK:' => \\'The Accept-Encoding header value(%s) MUST equal the Accept-Encoding header value(%s) in the original message.', 
   'NG:' => \\'The Accept-Encoding header value(%s) MUST equal the Accept-Encoding header value(%s) in the original message.', 
   'EX:' => \q{ FFop( 'eq',FV('HD.Accept-Encoding.val', @_ ) , FV('HD.Accept-Encoding.val','', NDPKT(@_[1]) ) , @_ ) }},

 # %% Accept-Language:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.ACCEPT-LANGUAGE_ORIGINAL-ACCEPT-LANGUAGE', 'CA:' => 'Accept-Language',
   'OK:' => \\'The Accept-Language header value(%s) MUST equal the Accept-Language header value(%s) in the original message.', 
   'NG:' => \\'The Accept-Language header value(%s) MUST equal the Accept-Language header value(%s) in the original message.', 
   'EX:' => \q{ FFop( 'eq',FV('HD.Accept-Language.val', @_ ) , FV('HD.Accept-Language.val','', NDPKT(@_[1]) ) , @_ ) }},

 # %% Supported:nn %%	
 { 'TY:' => 'SYNTAX', 'ID:' => 'S.SUPPORTED_ORIGINAL-SUPPORTED', 'CA:' => 'Supported',
   'OK:' => \\'The Supported header value(%s) MUST equal the Supported header value(%s) in the original message.', 
   'NG:' => \\'The Supported header value(%s) MUST equal the Supported header value(%s) in the original message.', 
   'EX:' => \q{ FFop( 'eq',FV('HD.Supported.val', @_ ) , FV('HD.Supported.val','', NDPKT(@_[1]) ) , @_ ) }},



###############################################################
###  Syntax rule sets #########################################
###############################################################


 # %% PX-UA-6-1-5 xx %%	UA receives 407 for BYE
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.BYE-407.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.ResMesg',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX',
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.RE-ROUTE_NOEXIST',
              'S.CSEQ-METHOD_BYE',
              'S.TO-TAG_EXIST',
              'D.COMMON.FIELD.STATUS',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.DIGEST-AUTH_CHALLENGE.PX',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 



 # %% PX-UA-6-1-6 xx %%	UA receives 407 Proxy Authentication Required
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.RE-INVITE-407.TM', 
   'RR:' => [
              ## SSet.STATUS.INVITE-4XX.NOPX 
              'SSet.STATUS.INVITE-4XX.NOPX',
              'S.VIA-RECEIVED_EXIST_2ND_LOCAL',
              'SS.DIGEST-AUTH_CHALLENGE.PX',
              'S.PORT-SIGNAL_DEFAULTS',
              ### below rules are added by cats 2005/08/22
              'S.TO-TAG_REMOTE-TAG',
            ]
 }, 


 # %% PX-UA-12-1-1 xx %%	PX receives OPTIONS request
   { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.OPTIONS_FORWARDED.PX',
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
               'SSet.URICompMsg',
               'S.R-URI_TO-URI',
               'S.CONTACT_EXIST',
               'S.CONTACT_NOT-*',
               'S.CONTACT_QUOTE',
               'S.SUPPORTED_EXIST',
               'S.ALLOW_EXIST',
               ## 'S.BODY_EXIST',
               ## 'SSet.SDP',
               'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
               'S.TO-TAG_NOEXIST',
               'S.P-AUTH_NOTEXIST',
               'SS.FORWARD_REQUEST_COMPARE',
               'S.R-URI_ORIGINAL-R-URI',
               'SS.FORWARD_HEADERS',
               'S.RECORD-ROUTE_ADD-PROXY-URI', # 20050228 add tadokoro
               'S.PORT-SIGNAL_DEFAULTS', # 20050309 add tadokoro
            ]
 },

 # %% PX-UA-12-1-1 xx %%	UA1 receives 200 for OPTIONS (forwarded)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.OPTIONS-200_FORWARDED.TM', 
   'RR:' => [
              #'SSet.REQUEST.OPTIONS-200.NOPX', 
              'S.ALLOW_ORIGINAL-ALLOW', 
              'S.ACCEPT_ORIGINAL-ACCEPT',
              'S.ACCEPT-ENCODING_ORIGINAL-ACCEPT-ENCODING',
              'S.ACCEPT-LANGUAGE_ORIGINAL-ACCEPT-LANGUAGE', 
              'S.SUPPORTED_ORIGINAL-SUPPORTED', 
              'S.CONTACT-URI_REMOTE-CONTACT-URI', # from SSet.URICompMsg

              'SS.FORWARD_RESPONSE_COMPARE',
              #'S.VIA_INSERT-NEWVIA-LINE',
              'S.VIA_REMOVE-TOPMOST',
              'S.PORT-SIGNAL_DEFAULTS',
            ]
 }, 

 # %% PX-UA-12-1-4 xx %%	UA1 receives 200 for OPTIONS (proxy reply)
 { 'TY:' => 'RULESET', 'ID:' => 'SS.STATUS.OPTIONS-200.PROXY-REPLY.TM', 
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
              'S.TO-URI_PROXY-URI',
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.VIA-BRANCH_CURRENT-PUA-BRANCH-NOPX', 
              'S.VIA-RECEIVED_EXIST',
              'S.VIA_NOPX_SEND_EQUAL',
              'S.CSEQ-METHOD_OPTIONS',
              'S.TO-TAG_EXIST',
              'S.ALLOW_NOT-EXIST',
              'S.ACCEPT-ENCODING_EXIST',  ## need
              'S.ACCEPT-LANGUAGE_EXIST',  ## need
              'S.SUPPORTED_EXIST',  ## need
	     ]

 }, 


 # %% PX-UA-8-1-1 xx %%	UA1 receives 200 for OPTIONS (proxy reply)
## BYE request from proxy to proxy that act as strict proxy)
## message should be reasonable to strict router
###############################################################	
 { 'TY:' => 'RULESET', 'ID:' => 'SS.REQUEST.BYE_FORWARDING_TO-STRICT-R.PX', 
   'RR:' => [
              'SSet.ALLMesg',
              'S.R-URI_NOQUOTE',
              # 'S.R-URI_REQ-CONTACT-URI',
              'S.R-URI_PROXY-URI',
              'S.R-LINE_VERSION',
              'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS_DECREMENT',
              'S.ROUTE_EXIST',
              # 'S.ROUTE_PSEUDO_PROXY_URI',
              'S.ROUTE_ORIGINAL-R-URI',
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



);

1

