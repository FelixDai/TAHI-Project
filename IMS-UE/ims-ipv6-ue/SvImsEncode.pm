#!/usr/bin/perl

# Copyright(C) IPv6 Promotion Council (2004-2010). All Rights Reserved.
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

# use strict;
# 
# 08/07/31 Rewrite
#----------------------------------------------------------------------------------
#
#
# 
# 090129 
#
# 
#
# 
#   $status_code:
#   $code:
# 
#   
# 
#   
#----------------------------------------------------------------------------------

  sub CtSvStatusCode {
     
     my($status_code) = @_;
     $code = {'100' => 'Trying',
              '180' => 'Ringing',
	      '181' => 'Call Is Being Forwarded',
	      '182' => 'Queued',
	      '183' => 'Session Progress',
	      '200' => 'OK',
	      '202' => 'Accepted',
	      '300' => 'Multiple Choices',
	      '301' => 'Moved Permanently',
	      '302' => 'Moved Temporarily',
	      '305' => 'Use Proxy',
	      '380' => 'Alternative Service',
	      '400' => 'Bad Request',
	      '401' => 'Unauthorized',
	      '402' => 'Payment Required',
	      '403' => 'Forbidden',
	      '404' => 'Not Found',
	      '405' => 'Method Not Allowed',
	      '406' => 'Not Acceptable',
	      '407' => 'Proxy Authentication Required',
	      '408' => 'Request Timeout',
	      '410' => 'Gone',
	      '412' => 'Conditional Request Failed',
	      '413' => 'Request Entity Too Large',
	      '414' => 'Request-URI Too Large',
	      '415' => 'Unsupported Media Type',
	      '416' => 'Unsupported URI Scheme',
	      '420' => 'Bad Extension',
	      '421' => 'Extension Required',
	      '422' => 'Session Interval Too Small',
	      '423' => 'Interval Too Brief',
	      '424' => 'Bad Location Information',
	      '429' => 'Provide Referrer Identity',
	      '430' => 'Flow Failed',
	      '433' => 'Anonymity Disallowed',
	      '480' => 'Temporarily Unavailable',
	      '481' => '****** Does Not Exist',
	      '482' => 'Loop Detected',
	      '483' => 'Too Many Hops',
	      '484' => 'Address Incomplete',
	      '485' => 'Ambiguous',
	      '486' => 'Busy Here',
	      '487' => 'Request Terminated',
	      '488' => 'Not Acceptable Here',
	      '489' => 'Bad Event',
	      '491' => 'Request Pending',
	      '493' => 'Undecipherable',
	      '494' => 'Security Agreement Required',
	      '500' => 'Server Internal Error',
	      '501' => 'Not Implemented',
	      '502' => 'Bad Gateway',
	      '503' => 'Service Unavailable',
	      '504' => 'Server Time-Out',
	      '505' => 'Version Not Supported',
	      '513' => 'Message Too Large',
	      '580' => 'Precondition Failure',
	      '600' => 'Busy Everywhere',
	      '603' => 'Decline',
	      '604' => 'Does Not Exist Anywhere',
	      '606' => 'Not Acceptable',

	  };

     $reason = $code -> {$status_code};
     return $reason;

     };      

## DEF.VAR
@IMS_EncodeRules = 
(

#######################################################
###                 Ruleset (ENCODE)                ###
#######################################################

#######################################################
# REQUEST
#   *** Ascending order ***

####################
# NOTIFY Request   #
####################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Request.NOTIFY',
'EX' => [
	 'E.P:U-RequestLine-2-ReqINtheDLG_BS',
	 'E.P:U-Via-2-ReqINtheDLG_BS',
	 'E.P:U-MaxForwards-1-Req_BS',
	 'E.P:U-From-2-ReqINtheDLG_BS',
	 'E.P:U-To-2-ReqINtheDLG_BS',
	 'E.P:U-CallID-2-ReqINthefDLG_BS',
	 'E.P:U-CSeq-2-ReqINtheDLG_BS',
	 'E.P:U-SubscriptionState-1-NOTIFY',
	 'E.P:U-Event-1-reg_BS-reg',
	 'E.P:U-Contact-2-ReqINtheDLG_BS',
	 'E.P:U-Content-Type-1-application_reginfo',
	 'E.P:U-Content-Length-1-BS',
	 'E.P:U-RegInfo-1-NOTIFY-Body',
	 ],
'AE' => \&CtRlMargeEncode
},

####################
# OPTIONS Request  #
####################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Request.OPTIONS',
'EX' => [
	 'E.P:U-RequestLine-4-OPTION',
	 'E.P:U-Via-1-ReqOutofDLG_BS',
	 'E.P:U-MaxForwards-1-Req_BS',
         'E.P:U-Accept-OPTIONS',
         'E.P:U-P-Called-Party-ID-1-Req_BS',    #20090606added
	 'E.P:U-From-1-ReqOutoDLG_BS',
	 'E.P:U-To-1-ReqOutofDLG_BS',
	 'E.P:U-CallID-1-ReqOutofDLG_BS',
	 'E.P:U-CSeq-1-ReqOutofDLG_BS',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

####################
# CANCEL Request   #
####################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Request.CANCEL',
'EX' => [
	'E.P:U-RequestLine-3-CANCEL',
	'E.P:U-Via-3-CANCEL',
	'E.P:U-MaxForwards-1-Req_BS',
	'E.P:U-From-3-CANCEL',
	'E.P:U-To-3-CANCEL',
	'E.P:U-CallID-3-CANCEL',
	'E.P:U-CSeq-3-CANCEL',
	'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

####################
# ACK Request
####################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Request.ACK',
'EX' => [
	 'E.P:U-RequestLine-2-ReqINtheDLG_BS',
	 'E.P:U-Via-2-ReqINtheDLG_BS',
	 'E.P:U-MaxForwards-1-Req_BS',
	 'E.P:U-From-2-ReqINtheDLG_BS',
	 'E.P:U-To-2-ReqINtheDLG_BS',
	 'E.P:U-CallID-2-ReqINthefDLG_BS',
	 'E.P:U-CSeq-4-ACK',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},


####################
# ACK(487)Request  #
####################
### (IMS)
### 20090122 orimo
### Name chaned from 'ES.Request.ACK-487', to 'ES.Request.ACK-non2XX',
###
{
'TY' => 'PROGN',
#'ID' => 'ES.Request.ACK-487',
'ID' => 'ES.Request.ACK-non2XX',
'EX' => [
	 'E.P:U-RequestLine-5-ACK-non2xx',
	 'E.P:U-Via-4-ACK-non2xx',
	 'E.P:U-MaxForwards-1-Req_BS',
	 'E.P:U-From-4-ACK-non2xx',
	 'E.P:U-To-4-ACK-non2xx',
	 'E.P:U-CallID-4-ACK-non2xx',
	 'E.P:U-CSeq-5-ACK-non2xx',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

####################
# BYE Request  #
####################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Request.BYE',
'EX' => [
	 'E.P:U-RequestLine-2-ReqINtheDLG_BS',
	 'E.P:U-Via-2-ReqINtheDLG_BS',
	 'E.P:U-MaxForwards-1-Req_BS',
	 'E.P:U-From-2-ReqINtheDLG_BS',
	 'E.P:U-To-2-ReqINtheDLG_BS',
	 'E.P:U-CallID-2-ReqINthefDLG_BS',
	 'E.P:U-CSeq-2-ReqINtheDLG_BS',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

####################
# Initial INVITE Request  #
####################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Request.Initial-INVITE',
'EX' => [
	 'E.P:U-RequestLine-1-ReqOutofDLG_BS',
	 'E.P:U-Via-1-ReqOutofDLG_BS',
	 'E.P:U-RecordRoute-2-Req_BS',
	 'E.P:U-MaxForwards-1-Req_BS',
	 'E.P:U-From-1-ReqOutoDLG_BS',
	 'E.P:U-To-1-ReqOutofDLG_BS',
	 'E.P:U-CallID-1-ReqOutofDLG_BS',
	 'E.P:U-CSeq-1-ReqOutofDLG_BS',
#	 'E.P:U-Contact-1-ReqOutofDLG_BS',
	 {'TY'=>'SW','E.P:U-Contact-1-ReqOutofDLG_BS'=>'#ipsec:on'},
	 {'TY'=>'SW','E.P:U-Contact-8-ReqOutofDLG_BS-sec_off'=>'#ipsec:off'},
	 'E.P:U-Content-Type-2-application_sdp',
	 'E.P:U-Content-Length-1-BS',
#	 'E.P:U-Supported-1-path', #20090115deleted
         'E.P:U-Supported-2-null', #20090115added
	 'E.P:U-Allow-1-BS',
	 'E.P:U-Allow-Events-1-reg',
	 'E.P:U-Accept-REGISTER',
#	 'E.P:U-P-Asserted-Identity-1-Req_BS', #20090115deleted
	 'E.P:U-P-Called-Party-ID-1-Req_BS',    #20090115added
	 'E.P:U-Body-SDP-1-v=.zero',
	 'E.P:U-Body-SDP-2-o=',
	 'E.P:U-Body-SDP-3-s=.hyphen',
	 'E.P:U-Body-SDP-4-c=',
	 'E.P:U-Body-SDP-5-t=.zero_zero',
	 'E.P:U-Body-SDP-6-m=',
	 'E.P:U-Body-SDP-7-a=',
	 'E.P:U-Body-SDP-8-b=',
	 ],
'AE' => \&CtRlMargeEncode
},


####################
# Initial INVITE Request (for 488 #
####################
### (IMS)
### Tester sends INVITE request included an wrong address type in SDP c-line.
### difference : 'E.P:U-Body-SDP-9-c=bad_address-type
###
{
'TY' => 'PROGN',
'ID' => 'ES.Request.Initial-INVITE-for488',
'EX' => [
	 'E.P:U-RequestLine-1-ReqOutofDLG_BS',
	 'E.P:U-Via-1-ReqOutofDLG_BS',
	 'E.P:U-RecordRoute-2-Req_BS',
	 'E.P:U-MaxForwards-1-Req_BS',
	 'E.P:U-From-1-ReqOutoDLG_BS',
	 'E.P:U-To-1-ReqOutofDLG_BS',
	 'E.P:U-CallID-1-ReqOutofDLG_BS',
	 'E.P:U-CSeq-1-ReqOutofDLG_BS',
#	 'E.P:U-Contact-1-ReqOutofDLG_BS',
	 {'TY'=>'SW','E.P:U-Contact-1-ReqOutofDLG_BS'=>'#ipsec:on'},
	 {'TY'=>'SW','E.P:U-Contact-8-ReqOutofDLG_BS-sec_off'=>'#ipsec:off'},
	 'E.P:U-Content-Type-2-application_sdp',
	 'E.P:U-Content-Length-1-BS',
#	 'E.P:U-Supported-1-path', #20090115deleted
         'E.P:U-Supported-2-null', #20090115added
	 'E.P:U-Allow-1-BS',
	 'E.P:U-Allow-Events-1-reg',
	 'E.P:U-Accept-REGISTER',
#	 'E.P:U-P-Asserted-Identity-1-Req_BS', #20090115deleted
	 'E.P:U-P-Called-Party-ID-1-Req_BS',    #20090115added
	 'E.P:U-Body-SDP-1-v=.zero',
	 'E.P:U-Body-SDP-2-o=',
	 'E.P:U-Body-SDP-3-s=.hyphen',
         'E.P:U-Body-SDP-9-c=bad_address-type', #20090122added
	 'E.P:U-Body-SDP-5-t=.zero_zero',
	 'E.P:U-Body-SDP-6-m=',
	 'E.P:U-Body-SDP-7-a=',
	 'E.P:U-Body-SDP-8-b=',
	 ],
'AE' => \&CtRlMargeEncode
},

####################
# REGISTER Request *
####################
{
'TY' => 'PROGN',
'ID' => 'ES.Request.REGISTER',
'EX' => [
         'E.P:U-RequestLine-10-for404',
         'E.P:U-Via-1-ReqOutofDLG_BS',
         'E.P:U-Path-1-200REGISTER',
         'E.P:U-MaxForwards-1-Req_BS',
         'E.P:U-From-1-ReqOutoDLG_BS',
         'E.P:U-To-11-REGISTER',
         'E.P:U-Contact-10-REGISTER',
         'E.P:U-CallID-1-ReqOutofDLG_BS',
         'E.P:U-Authorization-1-REGISTER',
         'E.P:U-Require-1-REGISTER',
         'E.P:U-CSeq-1-ReqOutofDLG_BS',
         'E.P:U-Supported-1-path',
         'E.P:U-Content-Length-1-BS',
        ],
'AE' => \&CtRlMargeEncode
},


#######################################################
# RESPONSE
#   *** Ascending order ***

##########################
# 200(REGISTER) Response #
##########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.200-REGISTER',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
	 'E.P:U-Via-5-Res_BS',
	 'E.P:U-Path-1-200REGISTER',
	 'E.P:U-Service-Route-1-200REGISTER',
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-5-Res_BS',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-Contact-4-200REGISTER',
	 'E.P:U-P-Associated-URI-1-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
	 'E.P:U-Date-1-200_REGISTER',
	 'E.P:U-Content-Length-1-BS',
         {'TY'=>'SW','E.P:U-Authentication-Info-1'=>'#auth-scheme:sipdigest'},
  	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(SUBSCRIBE) Response #
###########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.200-SUBSCRIBE',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
	 'E.P:U-Via-5-Res_BS',
	 'E.P:U-RecordRoute-1-Res_BS',
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-5-Res_BS',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
	 'E.P:U-Allow-Events-1-reg',
	 'E.P:U-Expires-1-200SUBSCRIBE',
	 'E.P:U-Contact-3-Res_BS',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(OPTIONS) Response   #
###########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.200-OPTIONS',
'EX' => [
#	 'E.P:U-StatusLine-1-200',
	 'E.P:U-StatusLine-1-Res_BS',
	 'E.P:U-Via-5-Res_BS',
#	 ##P-Asserted-Identity
#	 'E.P:U-P-Asserted-Identity-2-Res_BS', #20090115deleted
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-5-Res_BS',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
	 'E.P:U-Allow-1-BS',
	 'E.P:U-Accept-1-200OPTIONS',
	 'E.P:U-AcceptEncoding-200OPTION',
	 'E.P:U-AcceptLanguage-200OPTION',
	 'E.P:U-Allow-Events-1-reg',
	 'E.P:U-Supported-1-path', #20090302deleted
	 'E.P:U-Content-Type-2-application_sdp',
	 'E.P:U-Content-Length-1-BS',
	 'E.P:U-Body-SDP-1-v=.zero',
	 'E.P:U-Body-SDP-2-o=',
	 'E.P:U-Body-SDP-3-s=.hyphen',
	 'E.P:U-Body-SDP-4-c=',
	 'E.P:U-Body-SDP-5-t=.zero_zero',
	 'E.P:U-Body-SDP-6-m=',
	 'E.P:U-Body-SDP-7-a=',
	 'E.P:U-Body-SDP-8-b=',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(CANCEL) Response    #
###########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.200-CANCEL',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
#	 'E.P:U-StatusLine-1-200',
	 'E.P:U-Via-5-Res_BS',
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-9-200CANCEL',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

##########################
# 401(REGISTER) Response #
##########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.401-REGISTER',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
#	 'E.P:U-StatusLine-2-401',
	 'E.P:U-Via-5-Res_BS',
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-5-Res_BS',
	 'E.P:U-CallID-5-Res_BS',
	 {'TY'=>'SW','E.P:U-WWWAuthenticate-1-401'=>'#auth-scheme:aka'},
	 {'TY'=>'SW','E.P:U-WWWAuthenticate-1-401-sipdigest'=>'#auth-scheme:sipdigest'},
	 {'TY'=>'SW','E.P:U-SecurityServer-1-401'=>'#ipsec:on'},
	 'E.P:U-CSeq-6-Res_BS',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 487(INVITE) Response    #
###########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.487-INVITE',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
#	 'E.P:U-StatusLine-3-487',
	 'E.P:U-Via-5-Res_BS',
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-10-487INVITE',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 100(INVITE) Response #
###########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.100-INVITE',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
#	 'E.P:U-StatusLine-4-100',
	 'E.P:U-Via-5-Res_BS',
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-6-100',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 180(INVITE) Response #
###########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.180-INVITE',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
#	 'E.P:U-StatusLine-5-180',
	 'E.P:U-Via-5-Res_BS',
#	 'E.P:U-RecordRoute-1-Res_BS', #20090115 deleted
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-5-Res_BS',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
#	 'E.P:U-Contact-3-Res_BS', #20090115 deleted
#	 'E.P:U-P-Asserted-Identity-2-Res_BS', #20090115 deleted
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(INVITE) Response #
###########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.200-INVITE',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
#	 'E.P:U-StatusLine-1-200',
	 'E.P:U-Via-5-Res_BS',
	 'E.P:U-RecordRoute-1-Res_BS',
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-7-200INVITE',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
#	 'E.P:U-Supported-1-path', #20090115delete
         'E.P:U-Supported-2-null', #20090115added
	 'E.P:U-Contact-3-Res_BS',
	 'E.P:U-Allow-1-BS',
	 'E.P:U-Allow-Events-1-reg',
#	 'E.P:U-P-Asserted-Identity-2-Res_BS', #20090915deleted
	 'E.P:U-Content-Type-2-application_sdp',
	 'E.P:U-Content-Length-1-BS',
	 'E.P:U-Body-SDP-1-v=.zero',
	 'E.P:U-Body-SDP-2-o=',
	 'E.P:U-Body-SDP-3-s=.hyphen',
	 'E.P:U-Body-SDP-4-c=',
	 'E.P:U-Body-SDP-5-t=.zero_zero',
	 'E.P:U-Body-SDP-6-m=',
	 'E.P:U-Body-SDP-7-a=',
	 'E.P:U-Body-SDP-8-b=',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(BYE) Response #
###########################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.200-BYE',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
#	 'E.P:U-StatusLine-1-200',
	 'E.P:U-Via-5-Res_BS',
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-8-200BYE',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},

####################################
# 3XX-6XX Response(Error response) #
####################################
### (IMS)
{
'TY' => 'PROGN',
'ID' => 'ES.Response.3XX-6XX-ERROR',
'EX' => [
	 'E.P:U-StatusLine-1-Res_BS',
	 'E.P:U-Via-5-Res_BS',
	 'E.P:U-From-5-Res_BS',
	 'E.P:U-To-5-Res_BS',
	 'E.P:U-CallID-5-Res_BS',
	 'E.P:U-CSeq-6-Res_BS',
	 'E.P:U-Content-Length-1-BS',
	 ],
'AE' => \&CtRlMargeEncode
},


#######################################################
###                   Rule (ENCODE)                 ###
#######################################################

#######################################################
# Status-Line
#######################################################
#
# Status-Line
# Reference : RFC3261
# 090120 
# 
# 
# 
#
# [[[[
# 481
# 
# 'response_481' => 'Call'
# 'response_481' => 'Transaction',


{
'TY' => 'ENCODE',
'ID' => 'E.P:U-StatusLine-1-Res_BS',
'PT' => 'SL',
'FM' => 'SIP/2.0 %s %s',
'AR' => [\q{CtRlCxUsr(@_)->{'status_code'}},
      sub {
	  my($status_code, $response_481);
	  $status_code = CtRlCxUsr(@_)->{'status_code'};
          $response_481 =  CtRlCxUsr(@_)->{'response_481'};

          if ($status_code eq '481') {
	                          return "$response_481 Does Not Exist";
			      
			      }else{              
				
				  return(CtSvStatusCode($status_code)); 
			      }
      }
] 
},

### Status-Line (401 Unauthorized) 
###   Reference : RFC3261
###
#{
#'TY' => 'ENCODE',
#'ID' => 'E.P:U-StatusLine-2-401',
#'PT' => 'SL',
#'FM' => 'SIP/2.0 401 Unauthorized',
#},

### Status-Line (487 Request Terminated) 
###   Reference : RFC3261
###
#{
#'TY' => 'ENCODE',
#'ID' => 'E.P:U-StatusLine-3-487',
#'PT' => 'SL',
#'FM' => 'SIP/2.0 487 Request Terminated',
#},

### Status-Line (100 Trying) 
###   Reference : RFC3261
###
#{
#'TY' => 'ENCODE',
#'ID' => 'E.P:U-StatusLine-4-100',
#'PT' => 'SL',
#'FM' => 'SIP/2.0 100 Trying',
#},


### Status-Line (180 Ringing) 
###   Reference : RFC3261
###
#{
#'TY' => 'ENCODE',
#'ID' => 'E.P:U-StatusLine-5-180',
#'PT' => 'SL',
#'FM' => 'SIP/2.0 180 Ringing',
#},


#######################################################
# Request-URI
#######################################################

### Request-Line (INVITE)
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-1-ReqOutofDLG_BS',
'PT' => 'SL',
'FM' => '%s sip:%s:%s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
         \q{CtTbCfg(CtTbPrm('CI,target,TARGET'), 'contact-host')},
         \q{CtTbCfg(CtTbPrm('CI,target,TARGET'), CtSecurityScheme() eq 'aka' ? 'port-s' : 'sip-port')},
    ],
},

### Request-Line (BYE,INVITE), (NOTIFY)
###   Reference : RFC3261,     RFC3428
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-2-ReqINtheDLG_BS',
'PT' => 'SL',
'FM' => '%s %s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
         \q{CtSvDlg(CtRlCxDlg(@_),'RemoteTarget')}],
},

### Request-Line (CANCEL)
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-3-CANCEL',
'PT' => 'SL',
'FM' => '%s %s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
    sub {
	my $value;
	$value = CtFlv('SL,uri,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    }
  ]
},

### Request-Line (OPTIONS)
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-4-OPTION',
'PT' => 'SL',
'FM' => '%s %s:%s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
         \q{CtTbl('UC,UserProfile,PublicUserIdentity',CtTbPrm('CI,target,TARGET'))},
         \q{CtTbCfg(CtTbPrm('CI,target,TARGET'), CtSecurityScheme() eq 'aka' ? 'port-s' : 'sip-port')}],
},

### Request-Line (ACK-xxx)
###   Reference :
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-5-ACK-non2xx',
'PT' => 'SL',
'FM' => '%s %s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
    sub {
	my $value;
	$value = CtFlv('SL,uri,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    }
  ]
},

### Request-Line (INVITE for 404)
###   Reference :
###  090130 Inouey
### suyama modified(09/4/2)

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-6-for404',
'PT' => 'SL',
'FM' => '%s sip:%s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
    sub {
	return CtTbCfg(CtTbPrm('CI,target,TARGET'), 'contact-host') .
            '.foo.baa:' .
            CtTbCfg(CtTbPrm('CI,target,TARGET'), CtSecurityScheme() eq 'aka' ? 'port-s' : 'sip-port');
    }
  ]
},

### Request-Line (INVITE for 414)
###   Reference :
###  090130 Inouey
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-7-for414',
'PT' => 'SL',
'FM' => '%s %s;foo=%s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
    sub {
	return CtTbl('UC,UserProfile,PublicUserIdentity', CtTbPrm('CI,target,TARGET')) . ':' .
            CtTbCfg(CtTbPrm('CI,target,TARGET'), CtSecurityScheme() eq 'aka' ? 'port-s' : 'sip-port');
    },

   sub {
        my $chr;
        $chr = "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaafooooooooobaaaaaaaaa".
               "fooooooooobaaaaaaaaafooooooooo";

                return $chr;
       },
  ]
},


### Request-Line (INVITE for 416)
###   Reference :
###  090130 Inouey
### suyama modified.(09/4/2)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-8-for416',
'PT' => 'SL',
'FM' => '%s %s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
    sub {
	my $value;
        return 'foo:'.
            CtTbCfg(CtTbPrm('CI,target,TARGET'), 'contact-host') . ':' .
            CtTbCfg(CtTbPrm('CI,target,TARGET'), CtSecurityScheme() eq 'aka' ? 'port-s' : 'sip-port');
    }
  ]
},


### Request-Line (INVITE)
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-9-for505',
'PT' => 'SL',
'FM' => '%s sip:%s:%s SIP/9.8',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
         \q{CtTbCfg(CtTbPrm('CI,target,TARGET'), 'contact-host')},
         \q{CtTbCfg(CtTbPrm('CI,target,TARGET'), CtSecurityScheme() eq 'aka' ? 'port-s' : 'sip-port')} ],
},

### Request-Line (INVITE)
###   Reference : RFC3261
### written by suyama(09/4/2)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-10-for404',
'PT' => 'SL',
'FM' => '%s sip:%s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
         \q{CtTbCfg(CtTbPrm('CI,target,TARGET'), 'domain')}],
},

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RequestLine-11-ReqOutofDLG_BS',
'PT' => 'SL',
'FM' => '%s sip:%s SIP/2.0',
'AR' => [\q{CtRlCxUsr(@_)->{'msg_type'}},
         \q{CtTbCfg(CtTbPrm('CI,target,TARGET'), 'contact-host')},
    ],
},

#######################################################
# Via
#######################################################

### Via header (Request)
###   Reference : RFC3261
### (IMS)
### 
### CtIoSendMsg()
###   msg_path	
###   src_node
###   emu_node	
###   with_dlg	
###   protected	IPSec
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Via-1-ReqOutofDLG_BS',
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
    sub {
	my ($msgPath, $srcNode, $emuNode, $withDlg, $protected);
	my ($addRcvd) = 1; 	# XXX: 0
	$msgPath = CtRlCxUsr(@_)->{'msg_path'};
	$srcNode = CtRlCxUsr(@_)->{'term_node'};
	$emuNode = CtRlCxUsr(@_)->{'emu_node'};
	$withDlg = CtRlCxUsr(@_)->{'with_dlg'};
	$protected = CtRlCxUsr(@_)->{'protected'};
	return CtSvGenRequestVia($msgPath, $srcNode, $emuNode, $withDlg, $protected, $addRcvd);
    }
  ],
},

### Via header (Request)
###   Reference : RFC3261
### (IMS)
### 
### CtIoSendMsg()
###   msg_path	
###   src_node
###   emu_node	
###   with_dlg	
###   protected	IPSec
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Via-2-ReqINtheDLG_BS',
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
    sub {
	my ($msgPath, $srcNode, $emuNode, $withDlg, $protected);
	my ($addRcvd) = 1; 	# XXX: 0
	$msgPath = CtRlCxUsr(@_)->{'msg_path'};
	$srcNode = CtRlCxUsr(@_)->{'term_node'};
	$emuNode = CtRlCxUsr(@_)->{'emu_node'};
	$withDlg = CtRlCxUsr(@_)->{'with_dlg'};
	$protected = CtRlCxUsr(@_)->{'protected'};
	return CtSvGenRequestVia($msgPath, $srcNode, $emuNode, $withDlg, $protected, $addRcvd);
    }
  ],
},

### Via header (CANCEL Request)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Via-3-CANCEL',
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#Via,records,#ViaParm,#TXT#',CtRlCxPkt(@_));
	foreach my $v (@$value) {
		$value =~ s/\r?\n//;
		return $v;
	}
    }
  ]
},

### Via header (ACK(487) Request)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Via-4-ACK-non2xx',
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#Via,records,#ViaParm,#TXT#',CtRlCxPkt(@_));
	foreach my $v (@$value) {
		$value =~ s/\r?\n//;
		return $v;
	}
    }
  ]
},

### Via header (Response)
###   Reference : RFC3261
### (IMS)
### 
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Via-5-Res_BS',
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [\q{CtSvGenResponseVia(CtRlCxPkt(@_))}]
},


### Via header (Request)
### for 482 response 
### 090306 Inoue
### UE-SR-B-1
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Via-6-for482INVITE',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub {
	my ($msgPath, $srcNode, $emuNode, $withDlg, $protecte);
	my ($tmp_via, $via, $branch);
	my ($branch1, $branch2, $branch3);
	my ($addRcvd) = 1; 	# XXX: 0
	$msgPath = CtRlCxUsr(@_)->{'msg_path'};
	$srcNode = CtRlCxUsr(@_)->{'term_node'};
	$emuNode = CtRlCxUsr(@_)->{'emu_node'};
	$withDlg = CtRlCxUsr(@_)->{'with_dlg'};
	$protected = CtRlCxUsr(@_)->{'protected'};
	$branch1 = CtRlCxUsr(@_)->{'branch1'};
	$branch2 = CtRlCxUsr(@_)->{'branch2'};
	$branch3 = CtRlCxUsr(@_)->{'branch3'};


	$via = CtSvGenRequestVia($msgPath, $srcNode, $emuNode, $withDlg, $protected, $addRcvd);

	$via = "Via: $via";
#print "Via = $via\n";
	($tmp_via)=CtPkDecode('SIP:Via',$via);
	$branch = CtFlGet('records,#ViaParm,params,list,branch', $tmp_via);

	$via =~ s/$branch->[$#$branch]/$branch1/;
	$via =~ s/$branch->[$#$branch-1]/$branch2/;
	$via =~ s/$branch->[$#$branch-2]/$branch3/;

	return $via;

#	return CtSvGenRequestVia($msgPath, $srcNode, $emuNode, $withDlg, $protected, $addRcvd);
    }
  ],
},


### Via header (Request in the DLG)
### 090319 Inoue
### UE-SC-B-1

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Via-7-ReqInDLG_SigComp',
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
    sub {
	my ($msgPath, $srcNode, $emuNode, $withDlg, $protected,$via);
	my ($addRcvd) = 1;      # XXX: 0
	$msgPath = CtRlCxUsr(@_)->{'msg_path'};
	$srcNode = CtRlCxUsr(@_)->{'term_node'};
	$emuNode = CtRlCxUsr(@_)->{'emu_node'};
	$withDlg = CtRlCxUsr(@_)->{'with_dlg'};
	$protected = CtRlCxUsr(@_)->{'protected'};
	$via = CtSvGenRequestVia($msgPath, $srcNode, $emuNode, $withDlg, $protected, $addRcvd);
	$via =~ s/^(.+?),/$1;comp=sigcomp;sigcomp-id="urn:uuid:$SIGCOMPLocalUuid",/;
	return $via;
    },
  ],
},


### Via header (Request in the DLG)
### 090319 Inoue
### UE-SC-B-1

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Via-8-ReqOutDLG_SigComp',
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
    sub {
	my ($msgPath, $srcNode, $emuNode, $withDlg, $protected);
	my ($addRcvd) = 1;      # XXX: 0
	$msgPath = CtRlCxUsr(@_)->{'msg_path'};
	$srcNode = CtRlCxUsr(@_)->{'term_node'};
	$emuNode = CtRlCxUsr(@_)->{'emu_node'};
	$withDlg = CtRlCxUsr(@_)->{'with_dlg'};
	$protected = CtRlCxUsr(@_)->{'protected'};
	$via = CtSvGenRequestVia($msgPath, $srcNode, $emuNode, $withDlg, $protected, $addRcvd);
	$via =~ s/^(.+?),/$1;comp=sigcomp;sigcomp-id="urn:uuid:$SIGCOMPLocalUuid",/;
	return $via;
    }
  ],
},


#######################################################
# Path
#######################################################

### Path header
###   Reference : RFC3327
### (IMS)
### 200(REGISTER)
### 
### P-CSCF
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Path-1-200REGISTER',
'PT' => 'HD',
'FM' => 'Path: %s',
'AR' => [\q{CtTbl('UC,Path')}],
},

#######################################################
# RecordRoute
#######################################################

### Record-Route header (Response)
###   Reference : RFC3326
### (IMS)
### 
### CtIoSendMsg()
###   msg_path	
###   emu_node	
###   term_node	
###   protected	IPSec

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RecordRoute-1-Res_BS',
'PT' => 'HD',
'FM' => 'Record-Route: %s',
'AR' =>[
    sub {
	my ($msgPath, $emuNode, $termNode, $forReq, $protected);
	$msgPath = CtRlCxUsr(@_)->{'msg_path'};
	$emuNode = CtRlCxUsr(@_)->{'emu_node'};
	$termNode = CtRlCxUsr(@_)->{'term_node'};
	$forReq = 0;
	$protected = CtRlCxUsr(@_)->{'protected'};

	return CtSvGenRecRoute($msgPath, $termNode, $emuNode, $forReq, $protected);
    }
  ],
},

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RecordRoute-2-Req_BS',
'PT' => 'HD',
'FM' => 'Record-Route: %s',
'AR' =>[
    sub {
	my ($msgPath, $emuNode, $termNode, $forReq, $protected);
	$msgPath = CtRlCxUsr(@_)->{'msg_path'};
	$emuNode = CtRlCxUsr(@_)->{'emu_node'};
	$termNode = CtRlCxUsr(@_)->{'term_node'};
	$forReq = 1;
	$protected = CtRlCxUsr(@_)->{'protected'};

	return CtSvGenRecRoute($msgPath, $termNode, $emuNode, $forReq, $protected);
    }
  ],
},


### Record-Route header (Response)
### 090319 Inoue  
### (IMS)

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RecordRoute-4-Res_SigComp',
'PT' => 'HD',
'FM' => 'Record-Route: %s',
'AR' =>[
    sub {
	my ($msgPath, $emuNode, $termNode, $forReq, $protected, $recroot);
	$msgPath = CtRlCxUsr(@_)->{'msg_path'};
	$emuNode = CtRlCxUsr(@_)->{'emu_node'};
	$termNode = CtRlCxUsr(@_)->{'term_node'};
	$forReq = 0;
	$protected = CtRlCxUsr(@_)->{'protected'};

	$recroot = CtSvGenRecRoute($msgPath, $termNode, $emuNode, $forReq, $protected);
	$recroot =~ s/^<(.+)>(.*)$/<$1;comp=sigcomp;sigcomp-id=urn:uuid:$SIGCOMPLocalUuid>$2/;
	return $recroot;
    }
  ],
},


### Record-Route header (Response)
### 090319 Inoue  
### (IMS)

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RecordRoute-5-Req_SigComp',
'PT' => 'HD',
'FM' => 'Record-Route: %s',
'AR' =>[
    sub {
        my ($msgPath, $emuNode, $termNode, $forReq, $protected);
        $msgPath = CtRlCxUsr(@_)->{'msg_path'};
        $emuNode = CtRlCxUsr(@_)->{'emu_node'};
        $termNode = CtRlCxUsr(@_)->{'term_node'};
        $forReq = 1;
        $protected = CtRlCxUsr(@_)->{'protected'};

        $recroot = CtSvGenRecRoute($msgPath, $termNode, $emuNode, $forReq, $protected);
        $recroot =~ s/^<(.+?)>(.*)$/<$1;comp=sigcomp;sigcomp-id=urn:uuid:$SIGCOMPLocalUuid>$2/;
        return $recroot;
    }
  ],
},



#######################################################
# Service-Route
#######################################################
### Service-Route header
###   Reference : RFC3608
### (IMS)
### 200(REGISTER)
### Registra
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Service-Route-1-200REGISTER',
'PT' => 'HD',
'FM' => 'Service-Route: %s',
'AR' => [
    sub {
	my ($sr);
	$sr = CtTbl('UC,ServiceRoute', 'S-CSCFa1');
	if (ref($sr) eq 'ARRAY') {
		$sr = join(',', @$sr);
	}
	return $sr;
    }
  ],
},

### Service-Route header
### Reference : RFC3608
### (IMS)
### UE-RG-B-10 
### Registra
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Service-Route-2-200REGISTER',
'PT' => 'HD',
'FM' => 'Service-Route:  <sip:orig@s.a3.under.test.com;lr>',
},

#######################################################
# To
#######################################################
### To header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-1-ReqOutofDLG_BS',
'PT' => 'HD',
'FM' => 'To: %s<%s>',
# modified 20090302
#'AR' => [\q{CtTbl('UC,UserProfile,DisplayName','UEa1')},
#         \q{CtTbl('UC,UserProfile,PublicUserIdentity','UEa1')}]
'AR' => [\q{CtTbl('UC,UserProfile,DisplayName',CtTbPrm('CI,target,TARGET'))},
         \q{CtTbl('UC,UserProfile,PublicUserIdentity',CtTbPrm('CI,target,TARGET'))}]
},

### To header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-2-ReqINtheDLG_BS',
'PT' => 'HD',
'FM' => 'To: %s<%s>;tag=%s',
'AR' => [\q{CtSvDlg(CtRlCxDlg(@_),'RemoteURI,DisplayName')},
         \q{CtSvDlg(CtRlCxDlg(@_),'RemoteURI,AoR')},
         \q{CtSvDlg(CtRlCxDlg(@_),'RemoteTag')}]
},

### To header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-3-CANCEL',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#To,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    }
  ]
},

### To header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-4-ACK-non2xx',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub {
	my $value;
#	$value = CtFlv('HD,#To,#TXT#',$res);
#	$value = CtRlCxUsr(@_)->{'ACK_487_To'};    #20090123 deleted
	$value = CtRlCxUsr(@_)->{'ACK-non2XX_To'}; #20090123 added
	$value =~ s/\r?\n//;
	return $value;
    },
  ]
},

### To header
###   Reference : RFC3261
###090120 
###091226 
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-5-Res_BS',
'PT' => 'HD',
'FM' => '%s%s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#To,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
    sub {
	my($tag,$dialog_tag,$method);
	$tag = CtFlRandHexStr(10);
	$method = CtFlv('SL,method',CtRlCxPkt(@_));
	$dialog_tag = CtRlCxDlg(@_) ? CtSvDlg(CtRlCxDlg(@_),'LocalTag') : '';
	my $last_tag = CtFlv('HD,#To,params,list,#TagParam,tag-id',CtRlCxPkt(@_));
        if($method eq 'OPTIONS' || !CtRlCxDlg(@_)){
	    return ';tag='.$tag;
	}
        elsif($method eq 'REGISTER' || !$dialog_tag){
	    CtTbSet("DLG,".CtRlCxDlg(@_).",LocalTag", $tag);
	    return ';tag='.$tag;
	}
	elsif($last_tag ne ''){
	    return '';
        }else{
	    return ';tag='.$dialog_tag;
	}
    }
    ]
},

# To (without tag)
# for Response
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-6-100',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#To,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    }
  ]
},

### To header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-7-200INVITE',
'PT' => 'HD',
'FM' => '%s;tag=%s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#To,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
    sub {
	my $tag;
	$tag = CtFlv('HD,#To,params,list,#TagParam,tag-id',CtUtLastSndMsg(@_));
	return $tag;
    }
  ]
},

### To header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-8-200BYE',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#To,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    }
  ]
},

### To header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-9-200CANCEL',
'PT' => 'HD',
'FM' => '%s;tag=%s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#To,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
    sub {
	my $tag;
	$tag = CtFlRandHexStr(10);
	return $tag;
    }
  ]
},

### To header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-10-487INVITE',
'PT' => 'HD',
'FM' => '%s;tag=%s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#To,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
    sub {
	my $tag;
	$tag = CtSvDlg(CtRlCxDlg(@_),'LocalTag');
	return $tag;
    }
  ]
},


### To header
### For REGISTER
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-11-REGISTER',
'PT' => 'HD',
'FM' => 'To: %s<%s>',
'AR' => [\q{CtTbl('UC,UserProfile,DisplayName','UEa2')},
         \q{CtTbl('UC,UserProfile,PublicUserIdentity','UEa2')}]
},


### To header
###   Reference : RFC3261
###090213 orimo  addRules : this rule uses UE-RR-B-2. 
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-12-Res_createset_tag',
'PT' => 'HD',
'FM' => '%s%s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#To,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
    sub {
	my($tag,$dialog_tag,$method);
	$tag = CtFlRandHexStr(10);
	CtTbSet("DLG,".CtRlCxDlg(@_).",LocalTag", $tag);
	return ";tag=$tag";

    },
  ]
},

### To header
### Reference : RFC3261
### dialog ID
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-To-13-Res_DLG',
'PT' => 'HD',
'FM' => 'To: %s<%s>;tag=%s',
'AR' => [\q{CtSvDlg(CtRlCxDlg(@_),'LocalURI,DisplayName')}, \q{CtSvDlg(CtRlCxDlg(@_),'LocalURI,AoR')}, \q{CtSvDlg(CtRlCxDlg(@_),'LocalTag')}]
},


#######################################################
# From
#######################################################
### From header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-From-1-ReqOutoDLG_BS',
'PT' => 'HD',
'FM' => 'From: %s<%s>;tag=%s',
'AR' => [\q{CtTbl('UC,UserProfile,DisplayName','UEa2')},
         \q{CtTbl('UC,UserProfile,PublicUserIdentity','UEa2')},
    sub{
	return CtFlRandHexStr(10);
    },
  ],
},

### From header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-From-2-ReqINtheDLG_BS',
'PT' => 'HD',
'FM' => 'From: %s<%s>;tag=%s',
'AR' => [\q{CtSvDlg(CtRlCxDlg(@_),'LocalURI,DisplayName')},
         \q{CtSvDlg(CtRlCxDlg(@_),'LocalURI,AoR')},
         \q{CtSvDlg(CtRlCxDlg(@_),'LocalTag')},
  ],
},

### From header
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-From-3-CANCEL',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub{
	my $value;
	$value = CtFlv('HD,#From,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
  ],
},

### From header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-From-4-ACK-non2xx',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub{
	my $value;
	$value = CtFlv('HD,#From,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
  ],
},

### From header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-From-5-Res_BS',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub{
	my $value;
	$value = CtFlv('HD,#From,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
  ],
},


### From header
###   Reference : RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-From-6-tag_ref_pkt',
'PT' => 'HD',
'FM' => 'From: %s<%s>;tag=%s',
'AR' => [\q{CtTbl('UC,UserProfile,DisplayName','UEa2')},
         \q{CtTbl('UC,UserProfile,PublicUserIdentity','UEa2')},
    sub{
	my($value);
	$value = CtRlCxUsr(@_)->{'from-tag'};
	return $value;
    },
  ],
},


#######################################################
# Call-ID
#######################################################

### Call-ID header
###   Reference : RFC3261
###
# (update UNI)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CallID-1-ReqOutofDLG_BS',
'PT' => 'HD',
'FM' => 'Call-ID: %s',
'AR' => [
    sub {
	my ($id, $host, $callid);
	$id = CtFlRandHexStr(8);
	$host = CtTbl('UC,UserProfile,HomeNetwork', 'UEa2');
	$callid = "$id".'@'."$host";
	return $callid;
    },
  ],
},

### Call-ID header
###   Reference : RFC3261
###
# (update UNI)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CallID-2-ReqINthefDLG_BS',
'PT' => 'HD',
'FM' => 'Call-ID: %s',
'AR' => [\q{CtSvDlg(CtRlCxDlg(@_),'CallID')}],
},

### Call-ID header
###   Reference : RFC3261
###
# (update UNI)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CallID-3-CANCEL',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub {
	my ($value);
	$value = CtFlv('HD,#Call-ID,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
  ],
},

### Call-ID header
###   Reference : RFC3261
###
# (update UNI)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CallID-4-ACK-non2xx',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#Call-ID,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
  ],
},

### Call-ID header
###   Reference : RFC3261
###
# (update UNI)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CallID-5-Res_BS',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub {
	my ($value);
	$value = CtFlv('HD,#Call-ID,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
  ],
},


### Call-ID header
###   Reference : RFC3261
### 090311 Inoue added for UE-SR-B-10
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CallID-6-ref_pkt',
'PT' => 'HD',
'FM' => 'Call-ID: %s',
'AR' => [
    sub {
	my ($value);
	$value = CtRlCxUsr(@_)->{'callid'};
	return $value;
    },
  ],
},


#######################################################
# SecurityServer
#######################################################

### Security-Server header
###   Reference : RFC3329
### (IMS)
### 401(REGISTER)
### 
### P-CSCF
### P->UE
### q/ealg

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-SecurityServer-1-401',
'PT' => 'HD',
'FM' => 'Security-Server: %s',
'AR' => [
    sub {
	my ($str, $q, $alg, $ealg);
	my $negoname=CtRlCxUsr(@_)->{'security_nego'};
	$str = CtSecNego($negoname,'mech');
#	if( $q = CtSecNego($negoname,'q') ){ $str .= "q=$q;"; }

	if($alg = CtSecNego($negoname,'alg')){
	    $str .= '; alg=' . $alg;
	}

	# UE
	# 
	if( CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic',@_) ){
	    $str .= '; ealg=' . (CtTbCfg(CtRlCxUsr(@_)->{'emu_node'}, 'ealg') || CtSecNego($negoname,'ealg')) ;
	}
	elsif(CtTbCfg(CtRlCxUsr(@_)->{'emu_node'}, 'ealg')){
	    $str .= '; ealg=' . CtTbCfg(CtRlCxUsr(@_)->{'emu_node'}, 'ealg') ;
	}

	$str .= 
	    '; spi-c='  . CtSecNego($negoname,'spi_lc') .
	    '; spi-s='  . CtSecNego($negoname,'spi_ls') .
	    '; port-c=' . CtSecNego($negoname,'port_lc') .
	    '; port-s=' . CtSecNego($negoname,'port_ls');

	return $str;
    }
  ],
},

#######################################################
# CSeq
#######################################################

### CSeq header
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CSeq-1-ReqOutofDLG_BS',
'PT' => 'HD',
'FM' => 'CSeq: %s %s',
'AR' => [
    sub {
	my $seq;
	if(CtRlCxDlg(@_)){
		$seq = CtSvDlg(CtRlCxDlg(@_), 'LocalSeqNum');
		if(!$seq) {
			$seq = '1000';
			CtTbSet('DLG,'.CtRlCxDlg(@_).',LocalSeqNum', $seq);
		}
	}else{
		$seq = '1000';
	}
	return $seq;
    },
	 \q{CtRlCxUsr(@_)->{'msg_type'}},
  ],
},

### CSeq header
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CSeq-2-ReqINtheDLG_BS',
'PT' => 'HD',
'FM' => 'CSeq: %s %s',
'AR' => [
    sub {
	my $seq;
	$seq = CtSvDlg(CtRlCxDlg(@_), 'LocalSeqNum');
	if(!$seq) {
		$seq = '1000';
		CtTbSet('DLG,'.CtRlCxDlg(@_).',LocalSeqNum', $seq);
		return $seq;
	}
	$seq = $seq + 1;
	CtTbSet('DLG,'.CtRlCxDlg(@_).',LocalSeqNum', $seq);
	return $seq;
    },
	 \q{CtRlCxUsr(@_)->{'msg_type'}},
  ],
},

### CSeq header
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CSeq-3-CANCEL',
'PT' => 'HD',
'FM' => 'CSeq: %s %s',
'AR' => [\q{CtFlv('HD,#CSeq,cseqnum', CtRlCxPkt(@_))},
         \q{CtRlCxUsr(@_)->{'msg_type'}}],
},

### CSeq header
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CSeq-4-ACK',
'PT' => 'HD',
'FM' => 'CSeq: %s %s',
'AR' => [
    sub {
	my $value;
	$value = CtFlv('HD,#CSeq,cseqnum', CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    },
	 \q{CtRlCxUsr(@_)->{'msg_type'}}],
},

### CSeq header
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CSeq-5-ACK-non2xx',
'PT' => 'HD',
'FM' => 'CSeq: %s %s',
'AR' => [\q{CtFlv('HD,#CSeq,cseqnum', CtRlCxPkt(@_))},
         \q{CtRlCxUsr(@_)->{'msg_type'}}],
},

### CSeq header
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CSeq-6-Res_BS',
'PT' => 'HD',
'FM' => '%s',
'AR' => [
    sub{
	my $value;
	$value = CtFlv('HD,#CSeq,#TXT#',CtRlCxPkt(@_));
	$value =~ s/\r?\n//;
	return $value;
    }
  ],
},


### CSeq header
### for 500-BYE  090217 Inoue added
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-CSeq-7-for500BYE',
'PT' => 'HD',
'FM' => 'CSeq: 1 BYE',
'AR' => ,
},


#######################################################
# Supported
#######################################################
### Supported header (RFC3261)
###   Reference : RFC3261,RFC3262,RFC3911,RFC3327,RFC3312,RFC3840,RFC3891,RFC4092,RFC3329,RFC4028,RFC4244
###   (update UNI)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Supported-1-path',
'PT' => 'HD',
'FM' => 'Supported: %s',
'AR' => [
    sub {
	my ($Supported);
	$Supported = CtTbl('UC,Supported','UEa2');
	if ($Supported eq '') {
		$Supported = 'path';
	}
	if (ref($Supported) eq 'ARRAY') {
		$Supported = join(',', @$Supported);
	}
	return $Supported;
    },
  ],
},

### Supported header (RFC3261)
###   Reference : RFC3261,RFC3262,RFC3911,RFC3327,RFC3312,RFC3840,RFC3891,RFC4092,RFC3329,RFC4028,RFC4244
###   (update UNI)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Supported-2-null',
'PT' => 'HD',
'FM' => 'Supported: %s',
'AR' => [
    sub {
	return '';
    },
  ],
},


#######################################################
# Allow
#######################################################
### Allow header
###   Reference : RFC3261,RFC3262,RFC3311
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Allow-1-BS',
'PT' => 'HD',
'FM' => 'Allow: %s',
'AR' => [
    sub {
		my ($allow);
		$allow = CtTbl('UC,ALLOW');
		if ($allow eq '') {
			$allow = 'INVITE,ACK,CANCEL,OPTIONS,BYE';
		}
		if (ref($allow) eq 'ARRAY') {
			$allow = join(',', @$allow);
		}
		return $allow;
	},
  ],
},

### Allow header
###   Reference : RFC3261,RFC3262,RFC3311
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Allow-2-405INVITE',
'PT' => 'HD',
'FM' => 'Allow: INVITE',
},

### Allow-Events header
###   Reference : RFC3265
### OPTIONS
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Allow-Events-1-reg',
'PT' => 'HD',
'FM' => 'Allow-Events: reg',
},

#######################################################
# Accept
#######################################################
### Accept header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Accept-1-200OPTIONS',
'PT' => 'HD',
'FM' => 'Accept: application/sdp, application/3gpp-ims+xml',
},

### Accept header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Accept-2-406INVITE',
'PT' => 'HD',
'FM' => 'Accept: foo/baa',
},


### Accept-Encoding header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-AcceptEncoding-200OPTION',
'PT' => 'HD',
'FM' => 'Accept-Encoding: identity',
},

### Accept-Language header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-AcceptLanguage-200OPTION',
'PT' => 'HD',
'FM' => 'Accept-Language: en',
},

### Accept header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Accept-OPTIONS',
'PT' => 'HD',
'FM' => 'Accept: application/sdp, application/3gpp-ims+xml',
},

### Accept header
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Accept-REGISTER',
'PT' => 'HD',
'FM' => 'Accept: application/sdp, application/3gpp-ims+xml',
},

#######################################################
# Authentication-Info
#######################################################
### Authentication-Info header
###   Reference : RFC3261
### (IMS)
### 200(REGISTER)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Authentication-Info-1',
'PT' => 'HD',
'PM' => '', 
'PR' => '', 
'FM' => 'Authentication-Info: rspauth="%s",cnonce="%s",nc=%s,qop=auth',
'AR' => [
#        \q{ CtTbl('UC,DigestAuth,nextnonce') },
         \q{ CtTbl('UC,DigestAuth,rspauth') },
         \q{ CtTbl('UC,DigestAuth,cnonce') },
         \q{ CtTbl('UC,DigestAuth,nc') },],
},

#######################################################
# WWW-Authenticate
#######################################################
### WWW-Authenticate header
###   Reference : RFC3261
### (IMS)
### 401(REGISTER)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-WWWAuthenticate-1-401',
'PT' => 'HD',
'PM' => '', 
'PR' => '', 
'FM' => 'WWW-Authenticate: Digest realm="%s", nonce="%s", algorithm=AKAv1-MD5',
'AR' => [\q{ CtTbl('UC,DigestAuth,realm') },
         \q{ CtTbl('UC,DigestAuth,nonce') }],
},
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-WWWAuthenticate-1-401-sipdigest',
'PT' => 'HD',
'PM' => '', 
'PR' => '', 
'FM' => 'WWW-Authenticate: Digest realm="%s", nonce="%s", algorithm=MD5, qop="auth"',
'AR' => [\q{ CtTbl('UC,DigestAuth,realm') },
         \q{ CtTbl('UC,DigestAuth,nonce') }],
},
#qop
# 081210
#{
#'TY' => 'ENCODE',
#'ID' => 'E.P:U-WWWAuthenticate-1-401',
#'PT' => 'HD',
#'PM' => '', 
#'PR' => '', 
#'FM' => 'WWW-Authenticate: Digest realm="%s", qop="%s", nonce="%s", algorithm=AKAv1-MD5',
#'AR' => [\q{ CtTbl('UC,DigestAuth,realm') },
#         \q{ CtTbl('UC,DigestAuth,qop') },
#         \q{ CtTbl('UC,DigestAuth,nonce') }],
#},

### WWW-Authenticate header
###   Reference : RFC3261
### (IMS)
### MAC
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-WWWAuthenticate-2-401',
'PT' => 'HD',
'PM' => '', 
'PR' => '', 
'FM' => 'WWW-Authenticate: Digest realm="%s", nonce="%s", algorithm=AKAv1-MD5',
'AR' => [\q{ CtTbl('UC,DigestAuth,realm') },
         \q{ CtTbl('UC,DigestAuth,nonce') }],
},

### WWW-Authenticate header
###   Reference : RFC3261
### (IMS)
### SEQ
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-WWWAuthenticate-3-401',
'PT' => 'HD',
'PM' => '', 
'PR' => '', 
'FM' => 'WWW-Authenticate: Digest realm="%s", nonce="%s", algorithm=AKAv1-MD5',
'AR' => [\q{ CtTbl('UC,DigestAuth,realm') },
         \q{ CtTbl('UC,DigestAuth,nonce') }],
},

#######################################################
# Contact
#######################################################
### Contact header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-1-ReqOutofDLG_BS',
'PT' => 'HD',
'FM' => 'Contact: <sip:%s:%s>',
'AR' => [\q{CtTbl('UC,SecContactURI,host','UEa2')},
         \q{CtTbl('UC,SecContactURI,port','UEa2')}],
},

### Contact header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-2-ReqINtheDLG_BS',
'PT' => 'HD',
'FM' => 'Contact: <%s>',
'AR' => [\q{CtSvDlg(CtRlCxDlg(@_),'LocalURI, Contact')}],
},

### Contact header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-3-Res_BS',
'PT' => 'HD',
'FM' => 'Contact: <%s>',
'AR' => [\q{CtSvDlg(CtRlCxDlg(@_),'LocalURI, Contact')}],
},

### Contact header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-3-Res_BS-with_expires',
'PT' => 'HD',
'FM' => 'Contact: <%s>%s',
'AR' => [\q{CtSvDlg(CtRlCxDlg(@_),'LocalURI, Contact')},
    sub {
	my $expires;
	$expires = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',CtRlCxPkt(@_));

	if($expires ne ''){
		return(";expires=$expires");
	}
	if(CtUtIsExistHdr('Expires',CtRlCxPkt(@_))){
		return(';expires='. CtFlv('HD,#Expires,seconds',CtRlCxPkt(@_)));
	}
	return '';
    }],
},


### Contact header
### Reference : RFC3261
### 090120 suyama
### 
### REGISTER
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-4-200REGISTER',
'PT' => 'HD',
'FM' => 'Contact: <%s>%s',
'AR' => [
    sub {
	my($node) = @_;
	my($reg,$impu,$val,$reginfo,$port);
	if( CtRlCxUsr(@_)->{'protected'} ){
	    $reg = CtRlCxUsr(@_)->{'reg_name'};
	    $impu = CtTbl('UC,UserProfile,PublicUserIdentity',CtTbPrm('CI,target,TARGET'));
	    $reginfo = CtSvReg($reg,$impu,'','Contact','','keys');
	    if( $port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps') ){
		$val = join(":$port>,<",@$reginfo) . ":$port";
	    }
	    else{
		$val = join(">,<",@$reginfo);
	    }
	}
	else{
	    $val = 'sip:'. CtTbl('UC,ContactURI,host','UEa1');
	    if( CtTbl('UC,ContactURI,port','UEa1') ){ # 5060
		$val .= ':'. CtTbl('UC,ContactURI,port','UEa1');
	    }
	}
       
  	return $val;
    },
    
    sub {
	my $expires;
	$expires = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',CtRlCxPkt(@_));

	if($expires > 0){
		return(";expires=$expires");
	}
	if(CtUtIsExistHdr('Expires',CtRlCxPkt(@_))){
		return(';expires='. CtFlv('HD,#Expires,seconds',CtRlCxPkt(@_)));
	}
	return '';
    },
	 ],
},
    
### Contact header
### Reference : RFC3261
### 
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-5-200-REGISTER-with_expires',
'PT' => 'HD',
'FM' => 'Contact: <%s>%s',
'AR' =>  [
    sub {
	my($node) = @_;
	my($reg,$impu,$val,$reginfo,$port);
	if( CtRlCxUsr(@_)->{'protected'} ){
	    $reg = CtRlCxUsr(@_)->{'reg_name'};
	    $impu = CtTbl('UC,UserProfile,PublicUserIdentity',CtTbPrm('CI,target,TARGET'));
	    $reginfo = CtSvReg($reg,$impu,'','Contact','','keys');
	    if( $port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps') ){
		$val = (join(":$port>,<",@$reginfo)) . ":$port";
	    }
	    else{
		$val = join('>,<',@$reginfo);
	    }
	}
	else{
	    $val = 'sip:'. CtTbl('UC,ContactURI,host','UEa1');
	    if( CtTbl('UC,ContactURI,port','UEa1') ){ # 5060
		$val .= ':'. CtTbl('UC,ContactURI,port','UEa1');
	    }
	}
	return $val;
    },

    sub {
	my $expires;
        $expires = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',CtRlCxPkt(@_));

        if ($expires > 0){
	    $expires = ";expires=60";
	    return $expires;
	}elsif($expires eq 0){
	    $expires = ";expires=0";
	    return $expires;
	}
	return '';   
    },
  ],
},

### Contact header
### Reference : RFC3261
###
### 090120 suyama
#{
#'TY' => 'ENCODE',
#'ID' => 'E.P:U-Contact-6-200REGISTER-no_port',
#'PT' => 'HD',
#'FM' => 'Contact: <%s>%s',
#'AR' => [
#    sub {
#	my $aor;
#	$aor = CtTbl('UC,UserProfile,PublicUserIdentity','UEa1');
#	return $aor;
#    },
#    sub {
#	my $expires;
#	$expires = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',CtRlCxPkt(@_));
#
#	if($expires > 0){
#		return(";expires=$expires");
#	}
#	if(CtUtIsExistHdr('Expires',CtRlCxPkt(@_))){
#		return(';expires='. CtFlv('HD,#Expires,seconds',CtRlCxPkt(@_)));
#	}
#	return '';
#    },
#  ],
#},
#
### Contact header
### Reference : RFC3261
### UE-RG-B-3
### 090120 suyama
#{
#'TY' => 'ENCODE',
#'ID' => 'E.P:U-Contact-7-200REGISTER_short_expires-no_port',
#'PT' => 'HD',
#'FM' => 'Contact: %s%s',
#'AR' => [
#    sub {
#	my $contact;
#        $contact = CtFlv('HD,#Contact,c-params,#ContactParam,#TXT#',CtRlCxPkt(@_));
#	return $contact;
#    },
#    sub {
#	my $expires;
#        $expires = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',CtRlCxPkt(@_));
#        if ($expires > 0){
#	    $expires = ";expires=60";
#	    return $expires;
#	}else{
#	    return '';
#	}   
#    },
#  ],
#},


### for IPsec off SigComp on
### 090319 Inoue
### not use for Logo tester
#{
#'TY' => 'ENCODE',
#'ID' => 'E.P:U-Contact-6-200REGISTER-no_port',
#'PT' => 'HD',
#'FM' => 'Contact: <%s;comp=sigcomp;sigcomp-id=urn:uuid:%s>%s',
#'AR' => [
#    sub {
#       my $aor;
#       $aor = CtTbl('UC,UserProfile,PublicUserIdentity','UEa1');
#       return $aor;
#    },
#    \q{$SIGCOMPRemoteUuid},
#    sub {
#       my $expires;
#       $expires = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',CtRlCxPkt(@_));
#
#       if($expires > 0){
#               return(";expires=$expires");
#       }
#       if(CtUtIsExistHdr('Expires',CtRlCxPkt(@_))){
#               return(';expires='. CtFlv('HD,#Expires,seconds',CtRlCxPkt(@_)));
#       }
#       return '';
#    },
#  ],
#},


{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-8-ReqOutofDLG_BS-sec_off',
'PT' => 'HD',
'FM' => 'Contact: <sip:%s%s>',
'AR' => [\q{CtTbl('UC,ContactURI,host','UEa2')},
#         \q{CtTbl('UC,ContactURI,port','UEa2')}],
    sub {
	my $port;
	if( CtTbl('UC,ContactURI,port','UEa2') ){ # 5060
		$port = ':'. CtTbl('UC,ContactURI,port','UEa2');
	}
	return $port;
    },
  ],
},


### Contact header
###   Reference : RFC3261
###  for 485 response only  orimo added 20090206
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-9-485INVITE',
'PT' => 'HD',
'FM' => 'Contact: <%s>',
'AR' => [
	 sub{
             my @letters = ('a'..'z', 'A'..'Z', 0..9);
	     my $my_loop = 2;
             my $my_length = 1;
	     my $my_ranword;
	     for (1..$my_loop){
	          $my_ranword .= $letters[int(rand(@letters))];
	     }
	     my $my_contact = CtSvDlg(CtRlCxDlg(@_),'LocalURI,AoR');
	     @my_list = split(/\@/, $my_contact);
	     $my_contact = @my_list[0] .'_' . $my_ranword .'@'. @my_list[1];
	     return $my_contact;
	 },
      ],
},


### Contact header
###  For REGISTER
### 090206 Inoue added
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-10-REGISTER',
'PT' => 'HD',
'FM' => 'Contact: <sip:%s:%s>;expires=600000',
'AR' => [\q{CtTbl(CtRlCxUsr(@_)->{'protected'} ? 'UC,SecContactURI,host' : 'UC,ContactURI,host','UEa2')},
         \q{(CtTbl(CtRlCxUsr(@_)->{'protected'} ? 'UC,SecContactURI,port' : 'UC,ContactURI,port','UEa2'))||5060}],
},


### Contact header
###  For REGISTER with SigComp
### 090206 Inoue added
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Contact-11-200REG_SigComp',
'PT' => 'HD',
'FM' => 'Contact: <%s;comp=sigcomp;sigcomp-id=urn:uuid:%s>%s',
'AR' => [
    sub {
	my ($contact);
	if( CtRlCxUsr(@_)->{'protected'} ){
	    $contact = 'sip:'. CtTbl('UC,SecContactURI,host','UEa1'). ':'. CtTbl('UC,SecContactURI,port','UEa1');
	}
	else{
	    $contact = 'sip:'. CtTbl('UC,ContactURI,host','UEa1');
	    if( CtTbl('UC,ContactURI,port','UEa1') ){ # 5060
		$contact .= ':'. CtTbl('UC,ContactURI,port','UEa1');
	    }
	}
	return $contact;
    },
    \q{$SIGCOMPRemoteUuid},
    sub {
	my $expires;
	$expires = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',CtRlCxPkt(@_));

	if($expires > 0){
		return(";expires=$expires");
	}
	if(CtUtIsExistHdr('Expires',CtRlCxPkt(@_))){
		return(';expires='. CtFlv('HD,#Expires,seconds',CtRlCxPkt(@_)));
	}
	return '';
    },
  ],
},


#######################################################
# Content-Type
#######################################################

### Content-Type header (RegInfo)
###   Reference : RFCXXX
### (IMS)
### NOTIFY
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Content-Type-1-application_reginfo',
'PT' => 'HD',
'FM' => 'Content-Type: application/reginfo+xml'
},

### Content-Type header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Content-Type-2-application_sdp',
'PT' => 'HD',
'FM' => 'Content-Type: application/sdp',
},

### Content-Type header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Content-Type-2-application_3gpp-ims+xml',
'PT' => 'HD',
'FM' => 'Content-Type: application/3gpp-ims+xml',
},

### Content-Type header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Content-Type-3-415INVITE',
'PT' => 'HD',
'FM' => 'Content-Type: foo/baa',
},


#######################################################
# Event
#######################################################
### Event header (reg event)
###   Reference : RFC3265
### (IMS)
### SUBSCRIBE/NOTIFY
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Event-1-reg_BS-reg',
'PT' => 'HD',
'FM' => 'Event: reg',
},


### Event header (reg event)
###   Reference : RFC3265
### (IMS)
### SUBSCRIBE/NOTIFY
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Event-2-489NOTIFY',
'PT' => 'HD',
'FM' => 'Event: foo',
},


#######################################################
# Expires
#######################################################
### Expires header
###   Reference : RFC3261
### (IMS)
### 200(SUBSCRIBE)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Expires-1-200SUBSCRIBE',
'PT' => 'HD',
'FM' => 'Expires: %s',
'AR' => [
    sub {
	my ($dlgName, $expireT);
	$dlgName = CtRlCxDlg(@_);	# CtIoSendMsg()
	$expireT = CtSvDlg($dlgName, 'ExpireTime');
	return $expireT - time();
    }
  ],
},

### Expires header
###   Reference : RFC3261
### (IMS)
### 200(SUBSCRIBE)
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Expires-2-200SUBSCRIBE_short_expires',
'PT' => 'HD',
'FM' => 'Expires: %s',
'AR' => [
    sub {
	my ($dlgName, $expireT);
	$dlgName = CtRlCxDlg(@_);	# CtIoSendMsg()
	$expireT = CtSvDlg($dlgName, 'ExpireTime');
	if($expireT > 0){
            $expireT = '60';
            CtTbSet("DLG,$dlgName,ExpireTime", $expireT += time());
	return $expireT = "60";
	}
    }
  ],
 },

#######################################################
# Data
#######################################################
### Date header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Date-1-200_REGISTER',
'PT' => 'HD',
'FM' => 'Date: %s',
'AR' => [
    sub {
	my $gtime = gmtime();
	my ($wday,$mon,$day,$ttime,$year) = split(' ',$gtime);
	if($day < 10) {
		$day = "0$day";
	}
	return sprintf("$wday, $day $mon $year $ttime GMT");
    }
  ],
},

#######################################################
# P-Associated-URI
#######################################################
###
### P-Associated-URI header
### Reference : RFC3455
### (IMS)
### REGISTER 200
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-P-Associated-URI-1-Res_BS',
'PT' => 'HD',
'FM' => 'P-Associated-URI: %s<%s>',
'AR' => [
	 sub { 
	     my($display);
	     $display = CtTbl('UC,AssociatedURI,DisplayName','S-CSCFa1');
          
	     if ($display eq ''){
		 return '';
	     } 
	     return $display;

	 },
	 sub{
	     my($uri);
	     $uri = CtTbl('UC,AssociatedURI,URI','S-CSCFa1');
	     return $uri;
	 }
    ]
},

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-P-Associated-URI-Empty',
'PT' => 'HD',
'FM' => 'P-Associated-URI: ',
},

#######################################################
# Subscription-State
#######################################################
###
### Subscription-State header
###   Reference : RFC3265
### (IMS)
### NOTIFY
###   State
###   expires
##
### 090122 
### 
### 'notify_reason' => 'rejected',     : 
### 'notify_reason' => 'deactivated,'  : 
### 'notify_reason' => 'probation',    : 
### 'notify_reason' => 'timeout',      : 
### 'notify_reason' => 'giveup',       : 
### 'notify_reason' => 'noresource',   : 

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-SubscriptionState-1-NOTIFY',
'PT' => 'HD',
'FM' => 'Subscription-State: %s%s%s',
'AR' => [
    sub {
	my ($dlgName, $dlgState);
	$dlgName = CtRlCxDlg(@_);	# CtIoSendMsg()
	$dlgState = CtSvDlg($dlgName,'DialogState');
	if ($dlgState eq 'Init') {
		return 'init';
	} elsif ($dlgState eq 'Active') {
		return 'active';
	} elsif ($dlgState eq 'Terminated') {
		return 'terminated';
	} else {
		MsgPrint('WAR', "unknown DialogState\n");
		return $dlgState;
	}
    },

    sub {
	my ($dlgName, $expireT, $expires);
	$dlgName = CtRlCxDlg(@_);	# CtIoSendMsg()
	if((CtSvDlg($dlgName,'DialogState') ne 'Terminated')) {
		$expireT = CtSvDlg($dlgName, 'ExpireTime');
		$expires = ";expires=";
		$expires .= $expireT - time();
		return $expires;
	}else{
		return '';
	}
     },
    sub {
	my ($dlgName, $dlgState);
	$dlgName = CtRlCxDlg(@_);	# CtIoSendMsg()
	$dlgState = CtSvDlg($dlgName,'DialogState');
	$reason = CtRlCxUsr(@_)->{'notify_reason'};

        if($reason ne ''){
	    return ";reason=$reason";
	}else{
            return '';
        }
    },
  ],
},


#######################################################
# Max-Forwards
#######################################################

### Max-Forwards header
###   Reference : RFC3261
###
### 
### CtIoSendMsg()
###   msg_path	
###   term_node	
###   emu_node	
###   with_dlg	
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-MaxForwards-1-Req_BS',
'PT' => 'HD',
'FM' => 'Max-Forwards: %s',
'AR' => [
    sub {
	my ($msgPath, $termNode, $emuNode, $withDlg);
	$msgPath  = CtRlCxUsr(@_)->{'msg_path'};
	$termNode = CtRlCxUsr(@_)->{'term_node'};
	$emuNode  = CtRlCxUsr(@_)->{'emu_node'};
	$withDlg  = CtRlCxUsr(@_)->{'with_dlg'};

	return CtSvGenMaxForwards($msgPath, $termNode, $emuNode, $withDlg);
    }
  ],
},

#######################################################
# Content-Length
#######################################################

### Content-Length header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Content-Length-1-BS',
'PT' => 'HD',
'OD' => 'LAST',
'FM' => 'Content-Length: %s',
'AR' => [\&CtUtCalcContentLeng],
},

### Content-Length header
###   Reference : RFC3261
###   with value 0
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Content-Length-2_V0',
'PT' => 'HD',
'OD' => 'LAST',
'FM' => 'Content-Length: 0',
#'AR' => [\&CtUtCalcContentLeng],
},


#######################################################
# XML
#######################################################

###  RegInfo XML
### (IMS)
###  NOTIFY
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-RegInfo-1-NOTIFY-Body',
'PT' => 'BD',
'FM' => '%s',
'AR' => [
    sub {
	# 
	my ($dlgName, $xml);
	$dlgName = CtRlCxDlg(@_);	# CtIoSendMsg()
	if (!$dlgName) {
	CtSvError('fatal', "cannot get dialog name");
		return '';
	}
	$xml = CtSvRegGenRegInfoXML($dlgName,'',CtRlCxUsr(@_)->{'no_contact_update'});
	return $xml;
    },
  ],
},

###  
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Any-XML-Body',
'PT' => 'BD',
'FM' => '%s',
'AR' => [
    sub {
	# 
	my ($xmlData);
	my $xmlData=CtRlCxUsr(@_)->{'body_xml'};
        my $tpp = XML::TreePP->new(indent => 4, attr_prefix => '_');
        my $msg=$tpp->write($xmlData);
        $msg =~ s/\x0A/\x0D\x0A/g;
	return $msg;
    },
  ],
},

#######################################################
# P-Asserted-Identity
#######################################################

### P-Asserted-Identity header (TS24.229)
### tmp version
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-P-Asserted-Identity-1-Req_BS',
'PT' => 'HD',
'FM' => 'P-Asserted-Identity: %s<%s>',
'AR' => [
    sub{
	my $asserted_displayname = CtTbl('UC,AssertedIdentity,DisplayName', 'UEa2');
	if ($asserted_displayname eq ''){
		$asserted_displayname = '';
	}else{
		$asserted_displayname = '"'.$asserted_displayname.'" ';
	}
	return ($asserted_displayname);
    },
    sub{
	my $asserted_URI = CtTbl('UC,AssertedIdentity,URI','UEa2');
	if ($asserted_URI eq ''){
		$asserted_URI = CtTbl('UC,UserProfile,PublicUserIdentity','UEa2');
	}
	return $asserted_URI;
    },
  ],
},

### P-Asserted-Identity header (TS24.229)
### tmp version
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-P-Asserted-Identity-2-Res_BS',
'PT' => 'HD',
'FM' => 'P-Asserted-Identity: %s<%s>',
'AR' => [
    sub{
	my $asserted_displayname = CtTbl('UC,AssertedIdentity,DisplayName', 'UEa2');
	if ($asserted_displayname eq ''){
		$asserted_displayname = '';
	}else{
		$asserted_displayname = '"'.$asserted_displayname.'" ';
	}
	return ($asserted_displayname);
    },
    sub{
	my $asserted_URI = CtTbl('UC,AssertedIdentity,URI','UEa2');
	if ($asserted_URI eq ''){
		$asserted_URI = CtTbl('UC,UserProfile,PublicUserIdentity','UEa2');
	}
	return $asserted_URI;
    },
  ]
},

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-P-Asserted-Identity-3',
'PT' => 'HD',
'FM' => 'P-Asserted-Identity: <sip:%s@%s>',
'AR' => [
    \q{CtTbl('UC,AssertedIdentity,DisplayName')},
    \q{CtTbl('UC,AssertedIdentity,PublicUserIdentity')||CtTbl('UC,HostName')},
  ],
},

#######################################################
# P-Called-Party-ID
#######################################################

### P-Called-Party-IDheader (TS24.229)
### tmp version
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-P-Called-Party-ID-1-Req_BS',
'PT' => 'HD',
'FM' => 'P-Called-Party-ID: <%s>',
'AR' => [
     sub{
	my $called_party_id;
#	if ($called_party_id eq ''){
	        # modified 20090302
	        $node = CtTbPrm('CI,target,TARGET');
		$called_party_id = CtTbl('UC,UserProfile,PublicUserIdentity',$node);
#	    }
	return $called_party_id;
     },
  ],
},

#######################################################
# Min-Expires suyama added(090119)
#######################################################
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Min-Expires-1-Res_BS',
'PT' => 'HD',
'OD' => 'LAST',
'FM' => 'Min-Expires: 600000',
},


#######################################################
# Retry-After orimo added (090202)
#######################################################
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Retry-After-1-Res_BS',
'PT' => 'HD',
'FM' => 'Retry-After: %s',
'AR' => [\q{CtRlCxUsr(@_)->{'retryafter_time'}}],
 },


#######################################################
# Warning orimo added (090209)
#######################################################
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Waring-1-warn_code=304',
'PT' => 'HD',
'FM' => 'Warning: 304 nodea2 "Media type not available"',
 },

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Waring-1-warn_code=301',
'PT' => 'HD',
'FM' => 'Warning: 301 nodea2 "Incompatible network address format"',
 },

#######################################################
# Authorization inoue added (090210)
#######################################################
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Authorization-1-REGISTER',
'PT' => 'HD',
'FM' => 'Authorization: Digest %s',
'AR' => [
        sub {
	    my ($term_node);
	    my ($impi, $homeNet);
	    $term_node = CtRlCxUsr(@_)->{'term_node'};
	    if (!$term_node) {
		# term_node
		my ($emu_node) = CtRlCxUsr(@_)->{'emu_node'};
		if ($emu_node) {
		    # emu_node
		    $term_node = $emu_node;
		} else {
		    # CtTbl
		    # emu_node
		    $term_node = $DIRRoot{'ACTND'}->{'ID'};
		}
	    }
	    $impi = CtTbl('UC,UserProfile,PrivateUserIdentity', $term_node);
	    $homeNet = CtTbl('UC,UserProfile,HomeNetwork', $term_node);
            if( CtSecurityScheme() eq 'sipdigest' ){
                return "username=\"$impi\", realm=\"$homeNet\", nonce=\"\", uri=\"sip:$homeNet\", response=\"\"";
            }
            else{
                return "username=\"$impi\", realm=\"$homeNet\", nonce=\"\", uri=\"sip:$homeNet\", response=\"\", integrity-protected=\"no\"";
            }
	},
],
},



#######################################################
# Require inoue added (090210)
#######################################################
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Require-1-REGISTER',
'PT' => 'HD',
'FM' => 'Require: path',
},

{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Require-2-420INVITE',
'PT' => 'HD',
'FM' => 'Require: foo',
},


#######################################################
# SDP
#######################################################

### SDP (Protocol Version : "v=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Body-SDP-1-v=.zero',
'PT' => 'BD',
'FM' => 'v=0',
},

### SDP (Origin : "o=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Body-SDP-2-o=',
'PT' => 'BD',
'FM' => 'o=%s %s %s IN %s %s',
'AR' => [\q{CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'},'session-inf,username')},
         \q{CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'},'session-inf,session-id')},
         \q{CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'},'session-inf,version')},
         \q{CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'},'session-inf,address-type')},
         \q{CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'},'session-inf,address')}],
},

### SDP (Session Name : "s=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Body-SDP-3-s=.hyphen',
'PT' => 'BD',
'FM' => 's=-',
},

### SDP (Connection Data : "c=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Body-SDP-4-c=',
'PT' => 'BD',
'FM' => 'c=%s %s %s',
'AR' => [\q{'IN'},
         \q{CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'},'session-inf,address-type')},
         \q{CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'},'session-inf,address')}],
},

### SDP (Times : "t=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Body-SDP-5-t=.zero_zero',
'PT' => 'BD',
'FM' => 't=0 0',
},

### SDP (Media Announcements : "m=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Body-SDP-6-m=',
'PT' => 'BD',
'FM' => '%s',
'AR' => [
  sub {
	my ($ports, $types, $codecs, @list, $retAudio, $retVideo, $i);

	$ports  = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,port');
	$codecs = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,fmt-list,fmt');
	$types  = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,media');

	#********************
	# $ports, $types
	my (@ports, @codecs, @types);

	# $ports, $codecs, $types
	if('ARRAY' eq ref($ports)) {
		@ports = @$ports;
	} else {
		push(@ports, $ports);
	}
	if('ARRAY' eq ref($codecs)) {
		@codecs = @$codecs;
	} else {
		push(@codecs, $codecs);
	}
	if('ARRAY' eq ref($types)) {
		@types = @$types;
	} else {
		push(@types, $types);
	}

	# 
	if($#ports != $#codecs || $#codecs != $#types) {
		my ($MediaInfos) = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf');
		my $idx;
		@$ports = @ports;
		@$codecs = @codecs;
		@$types = @types;

		if('ARRAY' eq ref($MediaInfos)) {
			foreach(@$MediaInfos) {
				my (@tmplist) = @{$_->{'fmt-list'}};
				my ($port) = shift(@$ports);
				my ($type) = shift(@$types);

				for $idx (0..$#tmplist) {
					push(@$ports, $port);
					push(@$types, $type);
				} # end - for
			} # end - foreach
		} else {
			my (@tmplist) = @{$MediaInfos->{'fmt-list'}};
			my ($port) = shift(@$ports);
			my ($type) = shift(@$types);

			for $idx (0..$#tmplist) {
				push(@$ports, $port);
				push(@$types, $type);
			} # end - for
		} # end - if(<media-inf
	} # end - if(<
	# end - <
	#********************

	if('ARRAY' eq ref($codecs)) {
		my(@codecs);
		# @codecs = @$codecs;

		#********************
		my (@tmp);
		my ($tmpline);
		my ($flg) = 0;
		foreach(@$codecs) {
			$tmpline = $_;
			foreach(@tmp) {
				if($tmpline eq $_) {
					$flg = 1;
				}
			}
			if(1 == $flg) {
				shift(@$ports);
				shift(@$types);
			} else {
				push(@tmp, $tmpline);
				push(@$ports, shift(@$ports));
				push(@$types, shift(@$types));
			}
			$flg = 0;
		}
		@$codecs = @tmp;
		@codecs = @$codecs;
		#********************

		for($i=0; $i<=$#codecs;$i++) {
			if('audio' eq @$types[$i]) {
				if(!$retAudio) {
					$retAudio = $retAudio."m=@$types[$i] @$ports[$i] RTP/AVP";
				}
				$retAudio = $retAudio." @$codecs[$i]";
			}
		}

		for($i=0; $i<=$#codecs;$i++) {
			if('video' eq @$types[$i]) {
				if(!$retVideo) {
					$retVideo = $retVideo."m=@$types[$i] @$ports[$i] RTP/AVP";
				}
				$retVideo = $retVideo." @$codecs[$i]";
			}
		}

		if(!$retVideo) {
			return ($retAudio);
		}elsif(!$retAudio) {
			return ($retVideo);
		}else {
			return ($retAudio."\r\n".$retVideo);
		}

	} # end - if(<multiple a-line>)
	else {
		return ("m=$types $ports RTP/AVP $codecs");
	} # end - else(<single a-line>)

	return ('');
  } # end - sub(<AR>)
],
},

### SDP (Attributes : "a=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Body-SDP-7-a=',
'PT' => 'BD',
'FM' => '%s',
'AR' => [
  sub{
	my ($rcvmsg, $msg) = @_;
	my (@ret, @alines, @medias, @newmedia);
	my ($rtpmaps, $rtpmap, $mline, $attribute);

	$rtpmaps = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,fmt-list,rtpmap');
	# PrintVal(CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf'));
	@ret = @{$msg->{'RULE-RESULT'}};

	foreach(@ret) {
#PrintVal($_->{'ID'});
		if('E.P:U-Body-SDP-6-m=' eq $_->{'ID'}) {
			# PrintVal($_->{'MSG'});
			@alines= split(/\r\n/, $_->{'MSG'});
			foreach(@alines) {
				push(@newmedia, $_);
				if($_ =~ /RTP\/AVP (.*)$/) {
					@medias = split(/ /, $1);
					if('ARRAY' eq ref($rtpmaps)) {
						foreach(@$rtpmaps) {
							$mline = $_;
							if($_ =~ /rtpmap:\s*([0-9]*)/) {
								$rtpmap = $1;
								foreach(@medias) {
									if($rtpmap eq $_) {
										push(@newmedia, 'a='.$mline);
									}
								}
							}
						}
					} # end - if(<rtpmaps is ARRAY.>)
					else {
						push(@newmedia, 'a='.$rtpmaps);
					} # end - else(<rtpmaps is NOT ARRAY.>)
				}
			} # end - foreach(@alines)
#			PrintVal(\@newmedia);

			#********************
			my ($sdpinfs);
			my (@newmedia2);
			$sdpinfs = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf');

			if('ARRAY' eq ref($sdpinfs)) {
				while(($mline = shift(@newmedia))) {
					push(@newmedia2, $mline);
					if($mline =~ /m=([^\s]*)/) {
						while( ($mline = shift(@newmedia)) =~ /a=/ ) {
							push(@newmedia2, $mline);
						}
						unshift(@newmedia, $mline);
						foreach(@$sdpinfs) {
							if ($1 eq $_->{'media'}) {
							$attribute = $_->{'condition'};
							last;
							}
						}
						if($attribute) {
							push(@newmedia2, "a=$attribute");
						}
					}
				}
				@newmedia = @newmedia2;
			}else {
				if($sdpinfs->{'condition'}) {
					push(@newmedia, "a=$sdpinfs->{'condition'}");
				}
			}
			#********************

			# PrintVal(\@newmedia);
			$_->{'MSG'} = join("\r\n", @newmedia);
		}
	} # end - foreach(@ret)
	return ('');
  }
],
},

### SDP (Attributes : "b=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Body-SDP-8-b=',
'PT' => 'BD',
'FM' => '%s',
'AR' => [
  sub{
	my ($rcvmsg, $msg) = @_;
	my (@ret, @alines, @medias, @newmedia);
	my ($rtpmaps, $rtpmap, $mline,$attribute);

	$rtpmaps = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,bandwidth');
	@ret = @{$msg->{'RULE-RESULT'}};

	foreach(@ret) {
		if('E.P:U-Body-SDP-6-m=' eq $_->{'ID'}) {
			@alines= split(/\r\n/, $_->{'MSG'});
			foreach(@alines) {
				push(@newmedia, $_);
				if($_ =~ /RTP\/AVP (.*)$/) {
				@medias = split(/ /, $1);
					push(@newmedia,'b='.$rtpmaps);
				} # end - else(<rtpmaps is NOT ARRAY.>)
			} # end - foreach(@alines)
#			PrintVal(\@newmedia);

			#********************
			my ($sdpinfs);
			my (@newmedia2);
			$sdpinfs = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf');

			if('ARRAY' eq ref($sdpinfs)) {
				while(($mline = shift(@newmedia))) {
					push(@newmedia2, $mline);
					if($mline =~ /m=([^\s]*)/) {
						while( ($mline = shift(@newmedia)) =~ /a=/ ) {
							push(@newmedia2, $mline);
						}
						unshift(@newmedia, $mline);
						foreach(@$sdpinfs) {
							if ($1 eq $_->{'media'}) {
								$attribute = $_->{'condition'};
								last;
							}
						}
						if($attribute) {
							push(@newmedia2, "a=$attribute");
						}
					}
				}
				@newmedia = @newmedia2;
			}else {
				if($sdpinfs->{'condition'}) {
					push(@newmedia, "a=$sdpinfs->{'condition'}");
				}
			}
			#********************

			$_->{'MSG'} = join("\r\n", @newmedia);
		}
	} # end - foreach(@ret)
	return ('');
  }
],
},



### SDP (Connection Data : "c=IN FOO")
### For irregular test
###   Reference : RFC2327
### 20090123
{
'TY' => 'ENCODE',
'ID' => 'E.P:U-Body-SDP-9-c=bad_address-type',
'PT' => 'BD',
'FM' => 'c=%s %s %s',
'AR' => [\q{'IN'},
         \q{'FOO'},
#\q{CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'},'session-inf,address-type')},,
         \q{CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'},'session-inf,address')}],
},


######################### END #########################

);

1;
