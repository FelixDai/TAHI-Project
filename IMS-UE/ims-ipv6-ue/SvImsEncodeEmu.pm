#!/usr/bin/perl
# @@ -- SIPruleENCODE.pm --

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

# 
#   08/12/ 5 
#     E.U:P-Header.Record-Route.CopyIfExists 
#   08/10/15 
#     E.U:P-Header.Authorization.DigestAKA, E.U:P-Header.Authorization.DigestAKA.qop
#      
#     E.U:P-Header.Authorization.DigestAKA.qop 

##############################################################################################
# 
##############################################################################################

#----------------------------------------------
# 
#----------------------------------------------
%ReasonPhrase = (
	'100' => 'Trying',
	'180' => 'Ringing',
	'181' => 'Call Is Being Forwarded',
	'182' => 'Queued',
	'183' => 'Session Progress',
	'200' => 'OK',
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
	'413' => 'Request Entity Too Large',
	'414' => 'Request-URI Too Large',
	'415' => 'Unsupported Media Type',
	'416' => 'Unsupported URI Scheme',
	'420' => 'Bad Extension',
	'421' => 'Extension Required',
	'423' => 'Interval Too Brief',
	'480' => 'Temporarily not available',
	'481' => 'Call Leg/Transaction Does Not Exist',
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
	'500' => 'Internal Server Error',
	'501' => 'Not Implemented',
	'502' => 'Bad Gateway',
	'503' => 'Service Unavailable',
	'504' => 'Server Time-out',
	'505' => 'SIP Version not supported',
	'513' => 'Message Too Large',
);


@IMS_EmuEncodeRules = 
(

##############################################################################################
# 
##############################################################################################

###########################
# 1st REGISTER
###########################
# 
# 
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.1ST_REGISTER',
'EX' => [
	 'E.U:P-Request-Line.1ST_REGISTER',			# RequestURI
	 'E.U:P-Header.Via.Request',
	 'E.U:P-Header.Max-Forwards',
	 'E.U:P-Header.From.Request.WithoutDLG',	# From.URI
	 'E.U:P-Header.To.Request.IMPUofTermNode', 	# To.URI
	 'E.U:P-Header.Contact.1ST_REGISTER',		# Contact.URI
	 'E.U:P-Header.Call-ID.Request.WithoutDLG',
##	 'E.U:P-Header.Authorization.1st',			# Authorization

	 {'TY'=>'SW','E.U:P-Header.Security-Client'=>'#ipsec:on'},			# UC,SecurityAgreement
	 {'TY'=>'SW','E.U:P-Header.Require.sec-agree'=>'#ipsec:on'},		# Fixed
	 {'TY'=>'SW','E.U:P-Header.Proxy-Require.sec-agree'=>'#ipsec:on'},	# Fixed
	 'E.U:P-Header.CSeq.Request.WithoutDLG',
	 'E.U:P-Header.Supported.path',				# Fixed

	 'E.U:P-Header.Content-Length.calc',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# REGISTER
###########################
# 1st REGISTER
#   (1) AUTS REGISTER
#   (2) 2nd REGISTER(with Auth Rsponse)
#   (3) Re-REGISTER
#   (4) De-REGISTER
# 
# 
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.REGISTER',
'EX' => [
	 'E.U:P-Request-Line.WithDLG',				# XXX: REGISTER
	 'E.U:P-Header.Via.Request',
	 'E.U:P-Header.Max-Forwards',
	 'E.U:P-Header.From.REGISTER',				# From.Tag
	 'E.U:P-Header.To.REGISTER', 				# To.Tag
	 'E.U:P-Header.Contact.WithDLG.WithExpires',
	 'E.U:P-Header.Call-ID.Request.WithDLG',
##	 'E.U:P-Header.Authorization.1st',			# Authorization

	 {'TY'=>'SW','E.U:P-Header.Security-Client'=>'#ipsec:on'},			# UC,SecurityAgreement
	 {'TY'=>'SW','E.U:P-Header.Require.sec-agree'=>'#ipsec:on'},		# Fixed
	 {'TY'=>'SW','E.U:P-Header.Proxy-Require.sec-agree'=>'#ipsec:on'},	# Fixed

	 'E.U:P-Header.CSeq.Request.WithDLG',
	 'E.U:P-Header.Supported.path',				# Fixed

	 'E.U:P-Header.Content-Length.calc',
	 ],
'AE' => \&CtRlMargeEncode
},


###########################
# ini-SUBSCRIBE
###########################
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.INI_SUBSCRIBE',
'EX' => [
	'E.U:P-Request-Line.INI_SUBSCRIBE',				# RequestURI
	'E.U:P-Header.Via.Request',
	'E.U:P-Header.Max-Forwards',
	'E.U:P-Header.Route',							# 
	'E.U:P-Header.From.Request.WithoutDLG',			# From.URI
	'E.U:P-Header.To.Request.IMPUofTermNode',		# To.URI
	'E.U:P-Header.Call-ID.Request.WithoutDLG',
	'E.U:P-Header.CSeq.Request.WithoutDLG',

	'E.U:P-Header.Allow-Events.reg',				# Fixed
	'E.U:P-Header.Event.reg',						# Fixed

	 {'TY'=>'SW','E.U:P-Header.Security-Verify'=>'#ipsec:on'},			# 
	 {'TY'=>'SW','E.U:P-Header.Require.sec-agree'=>'#ipsec:on'},		# Fixed
	 {'TY'=>'SW','E.U:P-Header.Proxy-Require.sec-agree'=>'#ipsec:on'},	# Fixed

#	'E.U:P-Header.Contact.WithoutDLG',
	 {'TY'=>'SW','E.U:P-Header.Contact.WithoutDLG'=>'#ipsec:on'},	# Fixed
	 {'TY'=>'SW','E.U:P-Header.Contact.WithoutDLG_no_port'=>'#ipsec:off'},	# Fixed
	'E.U:P-Header.Expires', 
	'E.U:P-Header.Content-Length.calc',
	],
'AE' => \&CtRlMargeEncode
},

#
###########################
# re-SUBSCRIBE
###########################
# 
# XXX:
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.SUBSCRIBE',
'EX' => [
	'E.U:P-Request-Line.WithDLG',
	'E.U:P-Header.Via.Request',
	'E.U:P-Header.Max-Forwards',
	'E.U:P-Header.Route',
	'E.U:P-Header.From.Request.WithDLG',
	'E.U:P-Header.To.Request.WithDLG', 
	'E.U:P-Header.Call-ID.Request.WithDLG',
	'E.U:P-Header.CSeq.Request.WithDLG',

	'E.U:P-Header.Allow-Events.reg',				# Fixed
	'E.U:P-Header.Event.reg',						# Fixed

#	'E.U:P-Header.Security-Verify',					# 
#	'E.U:P-Header.Require.sec-agree',				# Fixed
#	'E.U:P-Header.Proxy-Require.sec-agree',			# Fixed
	 {'TY'=>'SW','E.U:P-Header.Security-Verify'=>'#ipsec:on'},			# 
	 {'TY'=>'SW','E.U:P-Header.Require.sec-agree'=>'#ipsec:on'},		# Fixed
	 {'TY'=>'SW','E.U:P-Header.Proxy-Require.sec-agree'=>'#ipsec:on'},	# Fixed

	'E.U:P-Header.Contact.WithDLG',
	'E.U:P-Header.Expires', 
	'E.U:P-Header.Content-Length.calc',
	],
'AE' => \&CtRlMargeEncode
},

######################
# ini-INVITE Request #
######################
# SDP
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.1ST_INVITE',
'EX' => [
	'E.U:P-Request-Line.WithoutDLG',
	'E.U:P-Header.Via.Request',
	'E.U:P-Header.Route',							# 
	'E.U:P-Header.Max-Forwards',
	'E.U:P-Header.From.Request.WithoutDLG',
	'E.U:P-Header.To.Request.WithoutDLG',
	'E.U:P-Header.Call-ID.Request.WithoutDLG',
	'E.U:P-Header.CSeq.Request.WithoutDLG',
	 {'TY'=>'SW','E.U:P-Header.Contact.WithoutDLG'=>'#ipsec:on'},	# Fixed
	 {'TY'=>'SW','E.U:P-Header.Contact.WithoutDLG_no_port'=>'#ipsec:off'},	# Fixed

	'E.U:P-Header.Supported.none',					# Fixed:INVITE
	'E.U:P-Header.Allow.IMS',						# Fixed
	'E.U:P-Header.Allow-Events.reg',				# Fixed
        'E.U:P-Header.Accept.application_sdp',

	 {'TY'=>'SW','E.U:P-Header.Security-Verify'=>'#ipsec:on'},			# 
	 {'TY'=>'SW','E.U:P-Header.Require.sec-agree'=>'#ipsec:on'},		# Fixed
	 {'TY'=>'SW','E.U:P-Header.Proxy-Require.sec-agree'=>'#ipsec:on'},	# Fixed

	'E.U:P-Header.Content-Type.application_sdp',	# SDP
	'E.U:P-Header.Content-Length.calc',
	'E.U:P-Body.SDP.v=.zero',
	'E.U:P-Body.SDP.o=',
	'E.U:P-Body.SDP.s=.hyphen',
	'E.U:P-Body.SDP.c=',
	'E.U:P-Body.SDP.t=.zero_zero',
	'E.U:P-Body.SDP.m=',				# XXX:m,a,b
	'E.U:P-Body.SDP.a=',
	'E.U:P-Body.SDP.b=',
	],
'AE' => \&CtRlMargeEncode
},

#####################
# re-INVITE Request #
#####################
# re-INVITE
# 
# XXX:
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.INVITE',
'EX' => [
	'E.U:P-Request-Line.WithDLG',
	'E.U:P-Header.Via.Request',
	'E.U:P-Header.Route',							# 
	'E.U:P-Header.Max-Forwards',
	'E.U:P-Header.From.Request.WithDLG',
	'E.U:P-Header.To.Request.WithDLG',
	'E.U:P-Header.Call-ID.Request.WithDLG',
	'E.U:P-Header.CSeq.Request.WithDLG',
	'E.U:P-Header.Contact.WithDLG',

	'E.U:P-Header.Supported.none',					# Fixed:INVITE
	'E.U:P-Header.Allow.IMS',						# Fixed
	'E.U:P-Header.Allow-Events.reg',				# Fixed

#	'E.U:P-Header.Security-Verify',					# UC,SecurityVerify
#	'E.U:P-Header.Require.sec-agree',				# Fixed
#	'E.U:P-Header.Proxy-Require.sec-agree',			# Fixed 
	 {'TY'=>'SW','E.U:P-Header.Security-Verify'=>'#ipsec:on'},			# 
	 {'TY'=>'SW','E.U:P-Header.Require.sec-agree'=>'#ipsec:on'},		# Fixed
	 {'TY'=>'SW','E.U:P-Header.Proxy-Require.sec-agree'=>'#ipsec:on'},	# Fixed

#	'E.U:P-Header.Content-Type.application_sdp',	# SDP
	'E.U:P-Header.Content-Length.calc',
#	'E.U:P-Body.SDP.v=.zero',
#	'E.U:P-Body.SDP.o=',
#	'E.U:P-Body.SDP.s=.hyphen',
#	'E.U:P-Body.SDP.c=',
#	'E.U:P-Body.SDP.t=.zero_zero',
#	'E.U:P-Body.SDP.m=',				# XXX:m,a,b
#	'E.U:P-Body.SDP.a=',
#	'E.U:P-Body.SDP.b=',
	],
'AE' => \&CtRlMargeEncode
},

###############################
# ACK Request(2xx
###############################
# 2xx
#  2xx
#  
#  CSeq
#  2xx
#  Proxy-Require
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.ACK.2xx',
'EX' => [										# MSG
	'E.U:P-Request-Line.WithDLG',				# DLG,RemoteTarget + 'ACK'(msg_type)
	'E.U:P-Header.Via.Request',
	'E.U:P-Header.Max-Forwards',
	'E.U:P-Header.Route',						# DLG,RouteSet
	'E.U:P-Header.From.Request.WithDLG',		# DLG
	'E.U:P-Header.To.Request.WithDLG',			# DLG
	'E.U:P-Header.Call-ID.Request.WithDLG',		# DLG
	'E.U:P-Header.CSeq.Request.CopyNum',		# MSG
#	'E.U:P-Header.Contact.WithDLG',				# ACK
##	'E.U:P-Header.Allow',						# ACK
##	'E.U:P-Header.Supported',					# ACK

#	'E.U:P-Header.Require.CopyIfExists',		# MSG
#	'E.U:P-Header.Proxy-Require.CopyIfExists',	# MSG

##	'E.U:P-Header.Authorization.CopyIfExists',	# MSG
	'E.U:P-Header.Content-Length.calc',
	],
'AE' => \&CtRlMargeEncode
},

###############################
# ACK Request(
###############################
# 3xx-6xx
# XXX:
#     
# 
# 
# 
# To
# 
# 
# ACK
# 
# ACK
# 
# 
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.ACK.3456',
'EX' => [										# MSG
	'E.U:P-Request-Line.CopyURI',				# MSG
	'E.U:P-Header.Via.Request.Copy1st',			# MSG.Via[0] 
	'E.U:P-Header.Max-Forwards',
	'E.U:P-Header.Route.CopyIfExists',			# MSG
	'E.U:P-Header.From.CopyAll',				# MSG
	'E.U:P-Header.To.CopyAll',				# XXX:
	'E.U:P-Header.Call-ID.CopyAll',				# MSG

	'E.U:P-Header.CSeq.Request.CopyNum',		# MSG
#	'E.U:P-Header.Contact',						# ACK
##	'E.U:P-Header.Allow',						# ACK
##	'E.U:P-Header.Supported',					# ACK

##	'E.U:P-Header.Require.CopyIfExists',		# 
##	'E.U:P-Header.Proxy-Require.CopyIfExists',	# 

##	'E.U:P-Header.Authorization.CopyIfExists',	# MSG
	'E.U:P-Header.Content-Length.calc',
	],
'AE' => \&CtRlMargeEncode
},

##################
# CANCEL Request #
##################
#  CANCEL
#  
#  
#  CANCEL
#  
#  
#  
#  
#  CANCEL
#  

{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.CANCEL',
'EX' => [										# MSG
	'E.U:P-Request-Line.CopyURI',				# MSG
	'E.U:P-Header.Via.Request.Copy1st',			# MSG
	'E.U:P-Header.Route.CopyIfExists',			# MSG
	'E.U:P-Header.Max-Forwards.70',				# CANCEL

	'E.U:P-Header.From.CopyAll',				# MSG
	'E.U:P-Header.To.CopyAll',					# MSG
	'E.U:P-Header.Call-ID.CopyAll',				# MSG

	'E.U:P-Header.CSeq.Request.CopyNum',		# MSG
#	'E.U:P-Header.Authorization.CopyIfExists',	# XXX:MSG
##	'E.U:P-Header.Contact',						# XXX:CANCEL
##	'E.U:P-Header.Allow',						# XXX:CANCEL
##	'E.U:P-Header.Supported',					# XXX:CANCEL

##	'E.U:P-Header.Security-Verify',				# XXX:CANCEL
##	'E.U:P-Header.Proxy-Require.sec-agree',		# XXX
##	'E.U:P-Header.Require.sec-agree',			# XXX

	'E.U:P-Header.Content-Length.calc',
	],
'AE' => \&CtRlMargeEncode
},

###############
# BYE Request #
###############
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.BYE',
'EX' => [
	'E.U:P-Request-Line.WithDLG',				# DLG,RemoteTarget + 'BYE'
	'E.U:P-Header.Via.Request',
	'E.U:P-Header.Route',						# DLG,RouteSet
###	'E.U:P-Header.Record-Route.Request',
	'E.U:P-Header.Max-Forwards',
	'E.U:P-Header.From.Request.WithDLG',		# DLG,LocalURI,AoR + DLG,LocalTag
	'E.U:P-Header.To.Request.WithDLG',			# DLG,RemoteURI,AoR + DLG,RemoteTag
	'E.U:P-Header.Call-ID.Request.WithDLG',		# DLG,CallID
	'E.U:P-Header.CSeq.Request.WithDLG',		# DLG,LocalSeqNum + 'BYE'
##	'E.U:P-Header.Contact',						# BYE
#	'E.U:P-Header.Allow',
#	'E.U:P-Header.Supported',

	 {'TY'=>'SW','E.U:P-Header.Security-Verify'=>'#ipsec:on'},			# 
	 {'TY'=>'SW','E.U:P-Header.Require.sec-agree'=>'#ipsec:on'},		# Fixed
	 {'TY'=>'SW','E.U:P-Header.Proxy-Require.sec-agree'=>'#ipsec:on'},	# Fixed

	'E.U:P-Header.Content-Length.calc',
	],
'AE' => \&CtRlMargeEncode
},

###################
# OPTIONS Request #
###################
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.OPTIONS.WithoutDLG',
'EX' => [
	'E.U:P-Request-Line.WithoutDLG',
	'E.U:P-Header.Via.Request',
###	'E.U:P-Header.Record-Route.Request',
	'E.U:P-Header.Max-Forwards',
	'E.U:P-Header.Route',						# UC,DefaultRouteSet
	'E.U:P-Header.From.Request.WithoutDLG',		# 
	'E.U:P-Header.To.Request.WithoutDLG',		# 
	'E.U:P-Header.Call-ID.Request.WithoutDLG',	# 
	'E.U:P-Header.CSeq.Request.WithoutDLG',		# 
###	'E.U:P-Header.Contact.WithoutDLG',			# MAY
##	'E.U:P-Header.Allow',
##	'E.U:P-Header.Supported',
##	'E.U:P-Header.Accept.application_sdp',		# OPTIONS

	 {'TY'=>'SW','E.U:P-Header.Security-Verify'=>'#ipsec:on'},			# 
	 {'TY'=>'SW','E.U:P-Header.Require.sec-agree'=>'#ipsec:on'},		# Fixed
	 {'TY'=>'SW','E.U:P-Header.Proxy-Require.sec-agree'=>'#ipsec:on'},	# Fixed

	'E.U:P-Header.Content-Length.calc',
	],
'AE' => \&CtRlMargeEncode
},

###################
# OPTIONS Request #
###################
# XXX: 
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Request.OPTIONS.WithDLG',
'EX' => [
	'E.U:P-Request-Line.WithDLG',				# DLG,RemoteTarget + 'OPTIONS'
	'E.U:P-Header.Via.Request',
#	'E.U:P-Header.Record-Route.Request',
	'E.U:P-Header.Max-Forwards',
	'E.U:P-Header.Route',						# DLG,RouteSet
	'E.U:P-Header.From.Request.WithDLG',		# DLG,LocalURI,AOR &  DLG,LocalTag
	'E.U:P-Header.To.Request.WithDLG',			# DLG,RemoteURI & DLG,RemoteTag
	'E.U:P-Header.Call-ID.Request.WithDLG',		# DLG,CallID
	'E.U:P-Header.CSeq.Request.WithDLG',		# DLG,LocalSeqNum + 'OPTIONS'
#	'E.U:P-Header.Contact.WithDLG',				# DLG,LocalURI,Contact (MAY
##	'E.U:P-Header.Allow',
##	'E.U:P-Header.Supported',

#	'E.U:P-Header.Security-Verify',				# UC,SecurityVerify
#	'E.U:P-Header.Proxy-Require.sec-agree',		# Fixed
#	'E.U:P-Header.Require.sec-agree',			# Fixed
	 {'TY'=>'SW','E.U:P-Header.Security-Verify'=>'#ipsec:on'},			# 
	 {'TY'=>'SW','E.U:P-Header.Require.sec-agree'=>'#ipsec:on'},		# Fixed
	 {'TY'=>'SW','E.U:P-Header.Proxy-Require.sec-agree'=>'#ipsec:on'},	# Fixed

	'E.U:P-Header.Content-Length.calc',
	],
'AE' => \&CtRlMargeEncode
},


###########################
# 180(INVITE) Response
###########################
# 
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Response.180-INVITE',
'EX' => [
	'E.U:P-Status-Line',
	'E.U:P-Header.Via.Response',				# MSG
#	'E.U:P-Header.Record-Route.CopyIfExists',	# MSG
	'E.U:P-Header.From.CopyAll',
	'E.U:P-Header.To.Response.WithDLG',			# XXX:To.Tag
	'E.U:P-Header.Call-ID.CopyAll',
	'E.U:P-Header.CSeq.CopyAll',
##	'E.U:P-Header.Contact.WithDLG',				# 2009/7/12 
	'E.U:P-Header.Content-Length.calc',
	],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(INVITE) Response
###########################
# 
# 
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Response.200-INVITE',
'EX' => [
	'E.U:P-Status-Line',
	'E.U:P-Header.Via.Response',
	'E.U:P-Header.Record-Route.CopyIfExists',	# MSG
	'E.U:P-Header.From.CopyAll',
	'E.U:P-Header.To.Response.WithDLG',			# XXX:To.Tag
	'E.U:P-Header.Call-ID.CopyAll',
	'E.U:P-Header.CSeq.CopyAll',

	'E.U:P-Header.Contact.WithDLG',				# XXX:200 INVITE
	'E.U:P-Header.Supported.none',				# Fixed:200 INVITE
	'E.U:P-Header.Allow.IMS',					# Fixed:200 INVITE

	'E.U:P-Header.Content-Type.application_sdp',	# XXX:SDP
	'E.U:P-Header.Content-Length.calc',
	'E.U:P-Body.SDP.v=.zero',
	'E.U:P-Body.SDP.o=',
	'E.U:P-Body.SDP.s=.hyphen',
	'E.U:P-Body.SDP.c=',
	'E.U:P-Body.SDP.t=.zero_zero',
	'E.U:P-Body.SDP.m=',			# XXX:m,a,b
	'E.U:P-Body.SDP.a=',
	'E.U:P-Body.SDP.b=',
	],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(CANCEL) Response
###########################
# 
# 
# XXX:RFC3261
#     
#     [MUST]
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Response.200-CANCEL',
'EX' => [
	 'E.U:P-Status-Line',
	 'E.U:P-Header.Via.Response',
	 'E.U:P-Header.From.CopyAll',
#	 'E.U:P-Header.To.CopyAll',					# 
	 'E.U:P-Header.To.Response.WithoutDLG',		# XXX:MSG
	 'E.U:P-Header.Call-ID.CopyAll',
	 'E.U:P-Header.CSeq.CopyAll',
	 'E.U:P-Header.Content-Length.calc',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(NOTIFY) Response
###########################
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Response.200-NOTIFY',
'EX' => [
	 'E.U:P-Status-Line',
	 'E.U:P-Header.Via.Response',
	 'E.U:P-Header.From.CopyAll',
	 'E.U:P-Header.To.Response.WithDLG',		# XXX:
	 'E.U:P-Header.Call-ID.CopyAll',
	 'E.U:P-Header.CSeq.CopyAll',
	 'E.U:P-Header.Content-Length.calc',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(BYE) Response
###########################
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Response.200-BYE',
'EX' => [
	 'E.U:P-Status-Line',
	 'E.U:P-Header.Via.Response',
	 'E.U:P-Header.From.CopyAll',
	 'E.U:P-Header.To.Response.WithDLG',		# XXX:
	 'E.U:P-Header.Call-ID.CopyAll',
	 'E.U:P-Header.CSeq.CopyAll',
	 'E.U:P-Header.Content-Length.calc',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 200(OPTIONS) Response
###########################
# 
# Allow
# 
# 
# 
#    
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Response.200-OPTIONS',
'EX' => [
	'E.U:P-Status-Line',
	'E.U:P-Header.Via.Response',
	'E.U:P-Header.From.CopyAll',
	'E.U:P-Header.To.Response.WithoutDLG',			# XXX:
	'E.U:P-Header.Call-ID.CopyAll',
	'E.U:P-Header.CSeq.CopyAll',
##	'E.U:P-Header.Contact',							# 200 OPTIONS

	'E.U:P-Header.Allow.IMS',						# 200 OPTIONS
	'E.U:P-Header.Supported.path',					# 200 OPTIONS
	'E.U:P-Header.Accept.application_sdp',			# 200 OPTIONS
	'E.U:P-Header.Accept-Encoding.gzip',			# 200 OPTIONS
	'E.U:P-Header.Accept-Language.en',				# 200 OPTIONS
	'E.U:P-Header.Allow-Events.reg',				# XXX:??

	'E.U:P-Header.Content-Type.application_sdp',	# XXX:SDP
	'E.U:P-Header.Content-Length.calc',
	'E.U:P-Body.SDP.v=.zero',						# SDP
	'E.U:P-Body.SDP.o=',
	'E.U:P-Body.SDP.s=.hyphen',
	'E.U:P-Body.SDP.c=',
	'E.U:P-Body.SDP.t=.zero_zero',
	'E.U:P-Body.SDP.m=',				# XXX:m,a,b
	'E.U:P-Body.SDP.a=',
	'E.U:P-Body.SDP.b=',
	 ],
'AE' => \&CtRlMargeEncode
},

###########################
# 487(INVITE) Response
###########################
# 
{
'TY' => 'PROGN',
'ID' => 'ES.U:P-Response.487-INVITE',
'EX' => [
	 'E.U:P-Status-Line',
	 'E.U:P-Header.Via.Response',
	 'E.U:P-Header.From.CopyAll',
	 'E.U:P-Header.To.Response.WithDLG',		# XXX:
	 'E.U:P-Header.Call-ID.CopyAll',
	 'E.U:P-Header.CSeq.CopyAll',
	 'E.U:P-Header.Content-Length.calc',
	 ],
'AE' => \&CtRlMargeEncode
},


##############################################################################################
# 
##############################################################################################


#============================================================
# Request-LINE (with Dialog)
#============================================================
# 
# RequestURI
# Method
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Request-Line.WithDLG',					# DLG, PRM(msg_type)
'PT' => 'SL',
'FM' => '%s',
'AR' => [
	sub {
		my ($msg_type, $dlg);

		$msg_type = CtRlCxUsr(@_)->{'msg_type'};	# 
		unless ($msg_type =~ /^[A-Z]+$/) { 			# 
         	CtSvError('fatal', "invalid msg_type($msg_type)");
			return '';
		}
		$dlg = CtRlCxDlg(@_);
		if (!$dlg) {
			# XXX: 
         	CtSvError('fatal', "cannot get dialog name");
			return '';
		}
		# RequestURI
		return "$msg_type " .  CtSvDlg($dlg,'RemoteTarget') . " SIP/2.0";
	},
],
},

#============================================================
# Request-LINE (without Dialog)
#============================================================
# 
# 
# RequestURI
# Method
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Request-Line.WithoutDLG',				# UC, PRM(msg_type,dest_node)
'PT' => 'SL',
'FM' => '%s',
'AR' => [
	sub {
	    my ($msg_type, $dest_node);
	    my ($uri);
	    
	    $msg_type = CtRlCxUsr(@_)->{'msg_type'};	# 
	    unless ($msg_type =~ /^[A-Z]+$/) {			# 
         	CtSvError('fatal', "invalid msg_type($msg_type)");
		return '';
	    }
	    
	    # XXX:
	    ##	$dest_node = CtTbPrm('CI,target');
	    # XXX:
	    $dest_node = CtRlCxUsr(@_)->{'dest_node'};
	    if (!$dest_node) {
         	CtSvError('fatal', "dest_node is not specified");
		return '';
	    }
	    
	    # 
	    $uri = CtTbl('UC,UserProfile,PublicUserIdentity', $dest_node);
	    return "$msg_type $uri SIP/2.0";
	},
],
},

#============================================================
# Request-LINE (1st REGISTER)
#============================================================
# 
# RequestURI
# Method
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Request-Line.1ST_REGISTER',			# UC, PRM(msg_type,term_node)
'PT' => 'SL',
'FM' => '%s',
'AR' => [
	sub {
	    my ($msg_type, $term_node);		# term_node
	    my ($uri);
	    
	    $msg_type = CtRlCxUsr(@_)->{'msg_type'};	# 
	    unless ($msg_type =~ /^[A-Z]+$/) {			# 
         	CtSvError('fatal', "invalid msg_type($msg_type)");
		return '';
	    }
	    
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
	    # 
	    $uri = CtTbl('UC,UserProfile,HomeNetwork', $term_node);
	    return "$msg_type sip:$uri SIP/2.0";
	},
],
},

#============================================================
# Request-LINE (ini-SUBSCRIBE)
#============================================================
# 
# RequestURI
# Method
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Request-Line.INI_SUBSCRIBE',			# UC, PRM(msg_type,term_node)
'PT' => 'SL',
'FM' => '%s',
'AR' => [
	sub {
	    my ($msg_type, $term_node);		# term_node
	    my ($uri);
	    
	    $msg_type = CtRlCxUsr(@_)->{'msg_type'};	# 
	    unless ($msg_type =~ /^[A-Z]+$/) {			# 
         	CtSvError('fatal', "invalid msg_type($msg_type)");
		return '';
	    }
	    
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
	    # 
	    $uri = CtTbl('UC,UserProfile,PublicUserIdentity', $term_node);
	    return "$msg_type $uri SIP/2.0";
	},
],
},


#============================================================
# Request-LINE (copy)
#============================================================
# 
# RequestURI
# Method
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Request-Line.CopyURI',					# MSG, PRM(msg_type)
'PT' => 'SL',
'FM' => '%s',
'AR' => [
	sub {
	    my ($msg_type);
	    my ($uri);
	    
	    $msg_type = CtRlCxUsr(@_)->{'msg_type'};	# 
	    unless ($msg_type =~ /^[A-Z]+$/) { 			# 
         	CtSvError('fatal', "invalid msg_type($msg_type)");
		return '';
	    }
	    # 
	    $uri = CtFlv('SL,uri,#TXT#', CtRlCxPkt(@_));
	    return "$msg_type $uri SIP/2.0";
	},
],
},

#============================================================
# Status-Line 
#============================================================
# 
# ResponseCode
# ReasonPhrase
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Status-Line',							# PRM(msg_type)
'PT' => 'SL',
'FM' => '%s',
'AR' => [
	sub {
	    my ($msg_type);
	    my ($reason);
	    
	    $msg_type = CtRlCxUsr(@_)->{'msg_type'};	# 
	    unless ($msg_type =~ /^\d+$/) {				# 
         	CtSvError('fatal', "invalid msg_type($msg_type)");
		return '';
	    }
	    $reason = $ReasonPhrase{$msg_type};			# reason phrase
	    if (!$reason) {
		CtSvError('fatal', "reason phrase is not defined for $msg_type");
		return '';
	    }
	    return "SIP/2.0 $msg_type $reason";
	},
],
},

##########################################
# From
# 
#  (1) E.U:P-Header.From.REGISTER
#  (2) E.U:P-Header.From.Request.WithDLG
#  (3) E.U:P-Header.From.Request.WithoutDLG
# 
#  (1) E.U:P-Header.From.CopyAll
##########################################

#============================================================
# From (REGISTER)
#============================================================
# 
# DisplayName
# From.URI
# From.Tag
# XXX: REGISTER
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.From.REGISTER',					# DLG
'PT' => 'HD',
'FM' => 'From: %s<%s>;tag=%s',
'AR' => [
	sub {	# From.DisplayName
	    my ($dname) = CtSvDlg(CtRlCxDlg(@_),'LocalURI,DisplayName');
	    if ($dname) {
		$dname .= ' ';	# 
	    }
	    return $dname;
	},
	sub {	# From.URI
	    return CtSvDlg(CtRlCxDlg(@_),'LocalURI,AoR');
	},
	sub {	# From.Tag
	    my ($tag) = CtFlRandHexStr(10);	# XXX:
	    my ($dlg) = CtRlCxDlg(@_);
	    if ($dlg) {
		# XXX: 
		# XXX:
		CtTbSet("DLG,$dlg,LocalTag", $tag);
	    }
	    return ($tag);
	},
],
},

#============================================================
# From (Request with Dialog)
#============================================================
# 
# DisplayName
#   
# From.URI
#   
# From.Tag
#   
# 
#    
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.From.Request.WithDLG',			# DLG
'PT' => 'HD',
'FM' => 'From: %s',
'AR' => [
	sub {
	    my ($dlg);
	    my ($dname, $uri, $tag);
	    
	    $dlg = CtRlCxDlg(@_);
	    if (!$dlg) {
         	CtSvError('fatal', "cannot get dialog name");
		return '';
	    }
	    $dname = CtSvDlg($dlg,'LocalURI,DisplayName');
	    $uri = CtSvDlg($dlg,'LocalURI,AoR');
	    $tag = CtSvDlg($dlg, 'LocalTag');
	    if (!$tag) {
		# LocalTag
		# XXX:
		$tag = CtFlRandHexStr(10);
		CtTbSet("DLG,$dlg,LocalTag", $tag);
	    }
	    if ($dname) {
		# 
		$dname .= ' ';	# 
	    }
	    return "$dname<$uri>;tag=$tag";
	},
],
},

#============================================================
# From (Request without Dialog)
#============================================================
# 
# 
# From,DisplayName
# From.URI
# From.Tag
# 
#    CtTbSet
# XXX:From
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.From.Request.WithoutDLG',			# UC, PRM(term_node)
'PT' => 'HD',
'FM' => 'From: %s',
'AR' => [
	sub {
	    my ($term_node);			# 
	    my ($dname, $uri, $tag);
	    
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
	    $dname = CtTbl('UC,UserProfile,DisplayName', $term_node);
	    if ($dname) {
		$dname .= ' ';	# 
	    }
	    $uri = CtTbl('UC,UserProfile,PublicUserIdentity', $term_node);
	    $tag = CtFlRandHexStr(10);	# From.Tag
	    return "$dname<$uri>;tag=$tag";
	},
],
},

#============================================================
# From (Response)
#============================================================
# 
# 
# From
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.From.CopyAll',					# MSG
'PT' => 'HD',
'FM' => '%s',
'AR' => [
	sub {
	    my ($from);
	    $from = CtFlv('HD,#From,#TXT#', CtRlCxPkt(@_));
	    $from =~ s/\r?\n//;
	    return $from;
	},
],
},

##########################################
# To
# 
#  (1) E.U:P-Header.To.REGISTER
#  (2) E.U:P-Header.To.Request.WithDLG
#  (3) E.U:P-Header.To.Request.WithoutDLG'
# 
#  XXX:
#  (1) E.U:P-Header.To.Response.WithDLG		# 
#  (2) E.U:P-Header.To.CopyAll				# 
#  (3) E.U:P-Header.To.Response.WithoutDLG	# 
##########################################

#============================================================
# To (REGISTER)
#============================================================
# 
# To.DisplayName
# To.URI
# To.Tag
###     Re-REGISTER
###     
###     
###     
### XXX: REGISTER
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.To.REGISTER',						# DLG
'PT' => 'HD',
'FM' => 'To: %s<%s>',
'AR' => [
	sub {	# To.DisplayName
	    my ($dname) = CtSvDlg(CtRlCxDlg(@_),'RemoteURI,DisplayName');
	    if ($dname) {
		$dname .= ' ';	# 
	    }
	    return $dname;
	},
	\q{CtSvDlg(CtRlCxDlg(@_),'RemoteURI,AoR')},
],
},

#============================================================
# To (Request with Dialog)
#============================================================
# 
# To.DisplayName
# To.URI
# To.Tag
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.To.Request.WithDLG',				# DLG
'PT' => 'HD',
'FM' => 'To: %s',
'AR' => [
	sub {
	    my ($dlg, $dname, $uri, $tag, $to);
	    $dlg = CtRlCxDlg(@_);
	    if (!$dlg) {
         	CtSvError('fatal', "cannot get dialog name");
		return '';
	    }
	    $dname = CtSvDlg($dlg,'RemoteURI,DisplayName');
	    $uri = CtSvDlg($dlg,'RemoteURI,AoR');
	    $tag = CtSvDlg($dlg, 'RemoteTag');
	    if ($dname) {
		$dname .= ' ';	# 
		$to = "$dname<$uri>";
	    } else {
		$to = "<$uri>";
	    }
	    if ($tag) {
		# 
		# 
		$to .= ";tag=$tag";
	    }
	    return $to;
	},
],
},

#============================================================
# To (Request without Dialog, PublicUserIdentity of dest_node)
#============================================================
# 
# 
# To.DisplayName
# To.URI
# To.Tag
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.To.Request.WithoutDLG',			# UC, PRM(dest_node)
'PT' => 'HD',
'FM' => 'To: %s',
'AR' => [
	sub {
	    my ($dest_node);
	    my ($dname, $uri);
	    
	    # XXX:
	    ##	$dest_node = CtTbPrm('CI,target');			# 
	    # XXX:
	    $dest_node = CtRlCxUsr(@_)->{'dest_node'};	# 
	    if (!$dest_node) {
           	CtSvError('fatal', "dest_node is not specified");
		return '';
	    }
	    $dname = CtTbl('UC,UserProfile,DisplayName', $dest_node);
	    if ($dname) {
		$dname .= ' ';	# 
	    }
	    $uri = CtTbl('UC,UserProfile,PublicUserIdentity', $dest_node);
	    return "$dname<$uri>";
	},
],
},

#============================================================
# To (PublicUserIdentity of term_node)
#============================================================
# 
# To.DisplayName
# To.URI
# To.Tag
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.To.Request.IMPUofTermNode',			# UC, PRM(term_node)
'PT' => 'HD',
'FM' => 'To: %s',
'AR' => [
	sub {
	    my ($term_node);			# 
	    my ($dname, $uri);
	    
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
	    $dname = CtTbl('UC,UserProfile,DisplayName', $term_node);
	    if ($dname) {
		$dname .= ' ';	# 
	    }
	    $uri = CtTbl('UC,UserProfile,PublicUserIdentity', $term_node);
	    return "$dname<$uri>";
	},
],
},

#============================================================
# To (Response)
#============================================================
# 
# To.DisplayName
# To.URI
# To.Tag
# 
#     (To.Tag
# XXX: To.Response.EstablishDLG
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.To.Response.WithDLG',				# DLG, MSG
#'ID' => 'E.U:P-Header.To.Response.EstablishDLG',		# DLG, MSG
'PT' => 'HD',
'FM' => 'To: %s<%s>;tag=%s',
'AR' => [
	sub {	# To.DisplayName
	    my ($dname) = CtFlv('HD,#To,addr,display', CtRlCxPkt(@_));
	    if ($dname ne '') {
		$dname .= ' ';
	    }
	    return $dname;
	},
	sub {	# To.URI
	    return CtFlv('HD,#To,addr,uri,#TXT#', CtRlCxPkt(@_));
	},
	sub {	# To.Tag
	    my ($dlg, $tag, $tagField);
	    
	    $dlg = CtRlCxDlg(@_);
	    if (!$dlg) {
         	CtSvError('fatal', "dialog is not specified");
		return '';
	    }
	    $tag = CtSvDlg($dlg, 'LocalTag');	# Callee
	    if (!$tag) {
		# 
		# XXX:
		$tag = CtFlRandHexStr(10);
		CtTbSet("DLG,$dlg,LocalTag", $tag);
	    }
	    return ($tag);
	},
],
},

#============================================================
# To (Response)
#============================================================
# 
# 
# To
# 
# 
# XXX:
#     
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.To.CopyAll',						# MSG
'PT' => 'HD',
'FM' => '%s',
'AR' => [
	sub {
	    my ($msg);
	    my ($to);
	    $msg = CtRlCxUsr(@_)->{'ref_res'};	# 
	    if (!$msg) {
		# ref_res
		$msg = CtRlCxPkt(@_);
	    }
	    $to = CtFlv('HD,#To,#TXT#', $msg);
	    $to =~ s/\r?\n//;	# 
	    return $to;
	},
],
},

#============================================================
# To (Response)
#============================================================
# 
# To.DisplayName
# To.URI
# To.Tag
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.To.Response.WithoutDLG',			# MSG
#'ID' => 'E.U:P-Header.To.Response.CopyGenTag',			# MSG
'PT' => 'HD',
'FM' => 'To: %s<%s>;tag=%s',
'AR' => [
	sub {	# To.DisplayName
	    my ($dname) = CtFlv('HD,#To,addr,display', CtRlCxPkt(@_));
	    if ($dname ne '') {
		$dname .= ' ';
	    }
	    return $dname;
	},
	sub {	# To.URI
	    return CtFlv('HD,#To,addr,uri,#TXT#', CtRlCxPkt(@_));
	},
	sub {	# To.Tag
	    my ($tag) = CtFlv('HD,#To,params,list,tag-id', CtRlCxPkt(@_));
	    if (!$tag) {
		# To.Tag
		$tag = CtFlRandHexStr(10);
	    }
	    return $tag;
	},
],
},

##########################################
# 4
#  (1) E.U:P-Header.Contact.WithDLG
#  (2) E.U:P-Header.Contact.WithoutDLG
#  (3) E.U:P-Header.Contact.WithDLG.WithExpires
#  (4) E.U:P-Header.Contact.1ST_REGISTER
##########################################

#============================================================
# Contact
#============================================================
# 
# Contact.URI
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Contact.WithDLG',					# DLG
'PT' => 'HD',
'FM' => 'Contact: <%s>',
#'AR' => [\q{CtSvDlg(CtRlCxDlg(@_),'LocalURI, Contact')}],
'AR' => [
	sub {
		return CtSvDlg(CtRlCxDlg(@_),'LocalURI, Contact');
	}
],
},

#============================================================
# Contact (without dialog)
#============================================================
# 
# Contact.URI
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Contact.WithoutDLG',				# PRM(term_node)
'PT' => 'HD',
'FM' => 'Contact: %s',
'AR' => [
	sub {
	    my ($term_node);			# 
	    
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
	    return StrURI(CtTbl('UC,SecContactURI', $term_node),'','show5060');
	},
],
},

{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Contact.WithoutDLG_no_port',				# PRM(term_node)
'PT' => 'HD',
'FM' => 'Contact: %s',
'AR' => [
	sub {
	    my ($term_node);			# 
	    
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
	    return StrURI(CtTbl('UC,ContactURI', $term_node),'','show5060');
	},
],
},


#============================================================
# Contact (REGISTER)
#============================================================
# 
# Contact.URI
# Contact.expires
# (
# 
### XXX:expires
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Contact.WithDLG.WithExpires',		# DLG,PRM(expires)
'PT' => 'HD',
'FM' => 'Contact: <%s>;expires=%s',
'AR' => [
	\q{CtSvDlg(CtRlCxDlg(@_),'LocalURI,Contact')},
	sub {
	    my ($expires);
	    $expires = CtRlCxUsr(@_)->{'expires'};
	    unless (defined($expires)) {
		$expires = 600000;	# IMS
	    }
	    return $expires;
	},
],
},

#============================================================
# Contact (1st REGISTER)
#============================================================
# 
# Contact.URI
# Contact.expires
# (
# 
### XXX:expires
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Contact.1ST_REGISTER',				# PRM(term_node,expires)
'PT' => 'HD',
'FM' => 'Contact: <%s>;expires=%s',
'AR' => [
	sub {
	    my ($term_node);			# 
	    
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
	    return StrURI(CtTbl('UC,ContactURI', $term_node), 'NoBrackets','show5060');
	},
	sub {
	    my ($expires);
	    $expires = CtRlCxUsr(@_)->{'expires'};
	    unless (defined($expires)) {
		$expires = 600000;	# IMS
	    }
	    return $expires;
	},
],
},


##########################################
# 3
#  
#    (1) E.U:P-Header.Call-ID.Request.WithDLG
#    (2) E.U:P-Header.Call-ID.Request.WithoutDLG
#  
#    (1) E.U:P-Header.Call-ID.CopyAll
##########################################

#============================================================
# Call-ID (Request with Dialog)
#============================================================
# 
# 
# XXX:
#       Caller
#       Callee
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Call-ID.Request.WithDLG',			# DLG
'PT' => 'HD',
'FM' => 'Call-ID: %s',
'AR' => [
	sub {
	    my ($id);

	    $id = CtSvDlg(CtRlCxDlg(@_),'CallID');
	    if (!$id) {
		# 
		my ($term_node);	# 
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
		##	$id = CtFlCallID(CtRlCxDlg(@_));
		$id = CtFlRandHexStr(8);					# 
		$id .= '@';
		$id .= CtTbl('UC,UserProfile,HomeNetwork',$term_node); # XXX:
		
		# 
		# XXX:
		CtTbSet('DLG,'.CtRlCxDlg(@_).',CallID', $id);
	    }
	    return $id;
	}
],
},

#============================================================
# Call-ID (Request without Dialog)
#============================================================
# 
# 
# XXX:
#     
#        
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Call-ID.Request.WithoutDLG',		# PRM(term_node)
'PT' => 'HD',
'FM' => 'Call-ID: %s',
'AR' => [
	sub {
	    my ($term_node);	# 
	    my ($usr, $host);
	    
	#	return CtFlCallID(CtRlCxDlg(@_)); # 

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
	    $usr = CtFlRandHexStr(8);								# 
	##	$host = CtTbl('UC,HostName',$term_node);				# 
	    $host = CtTbl('UC,UserProfile,HomeNetwork',$term_node); # 
	    
	    return $usr . '@' . $host;
	}
],
},

#============================================================
# Call-ID (Response)
#============================================================
# 
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Call-ID.CopyAll',				# MSG
'PT' => 'HD',
'FM' => 'Call-ID: %s',
'AR' => [
    sub {
	return CtFlv('HD,#Call-ID,call-id', CtRlCxPkt(@_));
     }
],
},

##########################################
# 4
#  (1) E.U:P-Header.CSeq.Request.WithDLG
#  (2) E.U:P-Header.CSeq.Request.WithoutDLG
#  (3) E.U:P-Header.CSeq.Request.CopyNum
#  (4) E.U:P-Header.CSeq.CopyAll
##########################################

#============================================================
# CSeq (Request with Dialog)
#============================================================
# 
# CSeq.Num
# CSeq.Method
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.CSeq.Request.WithDLG',			# PRM(msg_type),DLG
'PT' => 'HD',
'FM' => 'CSeq: %s',
'AR' => [
	sub {
	    my ($msg_type, $dlg, $cseq_num);
	    
	    $msg_type = CtRlCxUsr(@_)->{'msg_type'};	# 
	    unless ($msg_type =~ /^[A-Z]+$/) {
         	CtSvError('fatal', "cannot get msg_type for CSeq");
		return '';
	    }
	    $dlg = CtRlCxDlg(@_);
	    if ($dlg) {
		$cseq_num = CtSvDlg($dlg, 'LocalSeqNum');	# 
		if ($cseq_num eq '') {
		    $cseq_num = '1000';	# XXX:
		} else {
		    $cseq_num++;
		}
		# 
		# XXX:
		CtTbSet("DLG,$dlg,LocalSeqNum", $cseq_num);
	    } else {
         	CtSvError('fatal', "dialog name is not specified");
		return '';
	    }
	    return "$cseq_num $msg_type";
	}
],
},

#============================================================
# CSeq (Request without Dialog)
#============================================================
# 
# CSeq.Num
# CSeq.Method
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.CSeq.Request.WithoutDLG',			# PRM(msg_type,cseq_num)
'PT' => 'HD',
'FM' => 'CSeq: %s',
'AR' => [
	sub {
	    my ($msg_type, $cseq_num);
	    
	    $msg_type = CtRlCxUsr(@_)->{'msg_type'};	# 
	    unless ($msg_type =~ /^[A-Z]+$/) {
         	CtSvError('fatal', "cannot get msg_type for CSeq");
		return '';
	    }
	    $cseq_num = CtRlCxUsr(@_)->{'cseq_num'};
	    if ($cseq_num eq '') {
		# RFC3261
		$cseq_num = 1;  # XXX:
	    }
	    return "$cseq_num $msg_type";
	}
],
},

#============================================================
# CSeq (CANCEL/ACK Request)
#============================================================
# 
# CSeq.Num
# CSeq.Method
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.CSeq.Request.CopyNum',			# PRM(msg_type), MSG
'PT' => 'HD',
'FM' => 'CSeq: %s',
'AR' => [
	sub {
	    my ($msg_type, $cseqnum);
	    $msg_type = CtRlCxUsr(@_)->{'msg_type'};	# 
	    unless ($msg_type =~ /^[A-Z]+$/) {
         	CtSvError('fatal', "cannot get msg_type for CSeq");
		return '';
	    }
	    # CSeq.Num
	    if (1) {	# XXX: DEBUG
		my ($msg) = CtRlCxPkt(@_);
		$cseqnum = CtFlv('HD,#CSeq,cseqnum', $msg);
		if ($cseqnum eq '') {
		    PrintFA($msg);
		}
	    } else {
		$cseqnum = CtFlv('HD,#CSeq,cseqnum', CtRlCxPkt(@_));
	    }
	    return "$cseqnum $msg_type";
	}
],
},

#============================================================
# CSeq (Response)
#============================================================
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.CSeq.CopyAll',					# MSG
'PT' => 'HD',
'FM' => 'CSeq: %s %s',
'AR' => [\q{CtFlv('HD,#CSeq,cseqnum', CtRlCxPkt(@_))},
         \q{CtFlv('HD,#CSeq,method', CtRlCxPkt(@_))},
],
},

#============================================================
# Expires (SUBSCRIBE)
#============================================================
# 
# CtIoSendMsg()
# (
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Expires',							# PRM(expires)
'PT' => 'HD',
'FM' => 'Expires: %s',
'AR' => [
	sub {
	    my ($expires);
	    $expires = CtRlCxUsr(@_)->{'expires'};
	###	unless (defined($expires)) {
	    if (!defined($expires)) {
		$expires = 600000;	# IMS
	    }
	    return $expires;
	},
],
},

##########################################
# 4
#  (1) E.U:P-Header.Authorization.1st
#  (2) E.U:P-Header.Authorization.AUTS
#  (3) E.U:P-Header.Authorization.DigestAKA
#  (4) E.U:P-Header.Authorization.Copy
#  (5) E.U:P-Header.Authorization.SipDigest
##########################################

#============================================================
# Authorization header (1st REGISTER)
#============================================================
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.1st',				# UC, PRM(term_node)
'PT' => 'HD',
'PM' => '', 
'FM' => 'Authorization: Digest %s',
'AR' => [
	sub {
	    my ($term_node);		# 
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
	    return "username=\"$impi\", realm=\"$homeNet\", nonce=\"\", uri=\"sip:$homeNet\", response=\"\"";
	},
],
},

# nonce 
# nonce 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.1st.nonce',				# UC, PRM(term_node)
'PT' => 'HD',
'PM' => '', 
'FM' => 'Authorization: Digest %s',
'AR' => [
	sub {
	    my ($term_node);		# 
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
	    return "username=\"$impi\", realm=\"$homeNet\", nonce=\"".CtRlCxUsr(@_)->{'nonce'}."\", uri=\"sip:$homeNet\", response=\"\"";
	},
],
},

#============================================================
# Authorization header (AUTS REGISTER)
#============================================================
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.DigestAKA.auts',				# UC, MSG, PRM(term_node,sqnMS)
'PT' => 'HD',
'PM' => '', 
'FM' => 'Authorization: Digest %s',
'AR' => [
	sub {
	    my ($term_node, $sqnMS);			# term_node
	    my ($realm, $nonce, $uri, $response, $impi, $homeNet, $auts);
	    my ($algo) = 'AKAv1-MD5';	# 
	    
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
	    $uri = 'sip:' . $homeNet;
	    
	    # 
	    $realm = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,realm',CtRlCxPkt(@_));
	    $nonce = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',CtRlCxPkt(@_));
	    
	    # Basic
	    $response = CtUtCalcAuthBasicMD5($impi,
					     $realm,
					     ###		 pack('H*',CtAKAxres($impi)),
					     '',		# XXX:AUTS
					     'REGISTER',
					     $uri,
					     $nonce);
	    
	    # 
	    $sqnMS = CtRlCxUsr(@_)->{'sqnMS'};
	    if ($sqnMS eq '') {
		MsgPrint('WAR', "sqnMS is not specified\n");
		# XXX:
	    }
	    # AUTS
	    # RFC3310 
	    $auts = base64encode( pack('H*',CtAKAGetAuts($impi,$sqnMS)) );

	    return "username=\"$impi\", realm=\"$homeNet\", nonce=\"$nonce\", algorithm=$algo, uri=\"$uri\", response=\"$response\", auts=\"$auts\"";
	},
],
},

{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.DigestAKA.qop.auts',
'PT' => 'HD',
'PM' => '', 
'FM' => 'Authorization: Digest %s',
'AR' => [
	sub {
	    my ($term_node,$sqnMS,$auts);	# term_node
	    my ($realm, $nonce, $uri, $response, $impi, $homeNet,$opaque,$nc,$cnonce,$qop);
	    my ($algo) = 'AKAv1-MD5';	# 
	    
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
	    $uri = 'sip:' . $homeNet;
	    
	    # 
	    $realm = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,realm',CtRlCxPkt(@_));
	    $nonce = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',CtRlCxPkt(@_));
	    $qop   = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop',CtRlCxPkt(@_));
	    $opaque= CtTbl('UC,DigestAuth,opaque');
	    $nc    = CtTbl('UC,DigestAuth,nc');    # '00000001';
	    $cnonce= CtTbl('UC,DigestAuth,nonce'); # SipRandHexStr(32);

	    $response = CtUtAuthDigestMD5($impi,
					  $realm,
					  '',		# XXX:AUTS
					  'REGISTER',
					  $uri,
					  $nonce,
					  $nc,
					  $cnonce,
					  $qop);
	    
	    # 
	    $sqnMS = CtRlCxUsr(@_)->{'sqnMS'};
	    if ($sqnMS eq '') {
		MsgPrint('WAR', "sqnMS is not specified\n");
		# XXX:
	    }
	    # AUTS
	    # RFC3310 
	    $auts = base64encode( pack('H*',CtAKAGetAuts($impi,$sqnMS)) );

	    return "username=\"$impi\", realm=\"$homeNet\", qop=$qop, nonce=\"$nonce\",opaque=\"$opaque\",nc=$nc,cnonce=\"$cnonce\", algorithm=$algo, uri=\"$uri\", response=\"$response\", auts=\"$auts\"";
	},
],
},

#============================================================
# Authorization header (2nd REGISTER)
#============================================================
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.DigestAKA',			# MSG, PRM(term_node)
'PT' => 'HD',
'PM' => '', 
#'FM' => 'Authorization: Digest username="%s", realm="%s", nonce="", uri="sip:%s", response=""',
'FM' => 'Authorization: Digest %s',
'AR' => [
	sub {
	    my ($term_node);				# term_node
	    my ($realm, $nonce, $uri, $response, $impi, $homeNet,$pw);
	    my ($algo) = 'AKAv1-MD5';	# 
	    
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
	    $uri = 'sip:' . $homeNet;
	    
	    # 
	    $realm = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,realm',CtRlCxPkt(@_));
	    $nonce = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',CtRlCxPkt(@_));
	    
	    # 
	    if( !CtEnableIpsec() && CtSecurityScheme() ne 'aka'){
		$pw = CtFindAKA($impi,CtRlCxUsr(@_)->{'security_nego'})->{'AKA'}->{'KEY'};
		$pw =~ s/(?:00)*$//;
		$pw = pack('H*',$pw);
	    }
	    else{
		$pw = pack('H*',CtAKAxres($impi,'',CtRlCxUsr(@_)->{'security_nego'}));
	    }

	    # Basic
	    $response = CtUtCalcAuthBasicMD5($impi,
					     $realm,
					     $pw,
					     'REGISTER',
					     $uri,
					     $nonce);
	    
	    return "username=\"$impi\", realm=\"$homeNet\", nonce=\"$nonce\", algorithm=$algo, uri=\"$uri\", response=\"$response\"";
	},
 ],
},
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.DigestAKA.noAlgorithm',
'PT' => 'HD',
'PM' => '', 
'FM' => 'Authorization: Digest %s',
'AR' => [
	sub {
	    my ($term_node);				# term_node
	    my ($realm, $nonce, $uri, $response, $impi, $homeNet,$pw);
	    
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
	    $uri = 'sip:' . $homeNet;
	    
	    # 
	    $realm = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,realm',CtRlCxPkt(@_));
	    $nonce = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',CtRlCxPkt(@_));
	    
	    # 
	    if( !CtEnableIpsec() && CtSecurityScheme() ne 'aka'){
		$pw = CtFindAKA($impi)->{'AKA'}->{'KEY'};
		$pw =~ s/(?:00)*$//;
		$pw = pack('H*',$pw);
	    }
	    else{
		$pw = pack('H*',CtAKAxres($impi));
	    }

	    # Basic
	    $response = CtUtCalcAuthBasicMD5($impi,
					     $realm,
					     $pw,
					     'REGISTER',
					     $uri,
					     $nonce);
	    
	    return "username=\"$impi\", realm=\"$homeNet\", nonce=\"$nonce\", uri=\"$uri\", response=\"$response\"";
	},
 ],
},
# WWW-Authenticate qop="auth" 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.DigestAKA.qop',			# MSG, PRM(term_node)
'PT' => 'HD',
'PM' => '', 
#'FM' => 'Authorization: Digest username="%s", realm="%s", qop=%s, nonce="%s", opaque="%s", nc=%s, cnonce="%s", uri="%s", response="%s"',
'FM' => 'Authorization: Digest %s',
'AR' => [
	sub {
	    my ($term_node);				# term_node
	    my ($realm, $nonce, $uri, $response, $impi, $homeNet,$opaque,$nc,$cnonce,$qop,$pw);
	    my ($algo) = 'AKAv1-MD5';	# 
	    
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
	    $uri = 'sip:' . $homeNet;
	    
	    # 
	    $realm = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,realm',CtRlCxPkt(@_));
	    $nonce = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',CtRlCxPkt(@_));
	    $qop   = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop',CtRlCxPkt(@_));
	    $opaque= CtTbl('UC,DigestAuth,opaque');
	    $nc    = CtTbl('UC,DigestAuth,nc');    # '00000001';
	    $cnonce= CtTbl('UC,DigestAuth,nonce'); # SipRandHexStr(32);

	    # 
	    if( !CtEnableIpsec() && CtSecurityScheme() ne 'aka'){
		$pw = CtFindAKA($impi)->{'AKA'}->{'KEY'};
		$pw =~ s/(?:00)*$//;
		$pw = pack('H*',$pw);
	    }
	    else{
		$pw = pack('H*',CtAKAxres($impi));
	    }
	    $response = CtUtAuthDigestMD5($impi,
					  $realm,
					  $pw,
					  'REGISTER',
					  $uri,
					  $nonce,
					  $nc,
					  $cnonce,
					  $qop);
	    
	    return "username=\"$impi\", realm=\"$homeNet\", qop=$qop, nonce=\"$nonce\",opaque=\"$opaque\",nc=$nc,cnonce=\"$cnonce\", algorithm=$algo, uri=\"$uri\", response=\"$response\"";
	},
],
},

# WWW-Authenticate qop="auth" 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.DigestAKA.qop.noAlgorithm',			# MSG, PRM(term_node)
'PT' => 'HD',
'PM' => '', 
#'FM' => 'Authorization: Digest username="%s", realm="%s", qop=%s, nonce="%s", opaque="%s", nc=%s, cnonce="%s", uri="%s", response="%s"',
'FM' => 'Authorization: Digest %s',
'AR' => [
	sub {
	    my ($term_node);				# term_node
	    my ($realm, $nonce, $uri, $response, $impi, $homeNet,$opaque,$nc,$cnonce,$qop,$pw);

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
	    $uri = 'sip:' . $homeNet;
	    
	    # 
	    $realm = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,realm',CtRlCxPkt(@_));
	    $nonce = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',CtRlCxPkt(@_));
	    $qop   = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop',CtRlCxPkt(@_));
	    $opaque= CtTbl('UC,DigestAuth,opaque');
	    $nc    = CtTbl('UC,DigestAuth,nc');    # '00000001';
	    $cnonce= CtTbl('UC,DigestAuth,nonce'); # SipRandHexStr(32);

	    # 
	    if( !CtEnableIpsec() && CtSecurityScheme() ne 'aka'){
		$pw = CtFindAKA($impi)->{'AKA'}->{'KEY'};
		$pw =~ s/(?:00)*$//;
		$pw = pack('H*',$pw);
	    }
	    else{
		$pw = pack('H*',CtAKAxres($impi));
	    }
	    $response = CtUtAuthDigestMD5($impi,
					  $realm,
					  $pw,
					  'REGISTER',
					  $uri,
					  $nonce,
					  $nc,
					  $cnonce,
					  $qop);
	    
	    return "username=\"$impi\", realm=\"$homeNet\", qop=$qop, nonce=\"$nonce\",opaque=\"$opaque\",nc=$nc,cnonce=\"$cnonce\", uri=\"$uri\", response=\"$response\"";
	},
],
},

#============================================================
# Authorization header (AUTS REGISTER)
#============================================================
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.SipDigest',			# MSG, PRM(term_node)
'PT' => 'HD',
'PM' => '', 
#'FM' => 'Authorization: Digest username="%s", realm="%s", qop=%s, nonce="%s", opaque="%s", nc=%s, cnonce="%s", uri="%s", response="%s"',
'FM' => 'Authorization: Digest %s',
'AR' => [
	sub {
	    my ($term_node);				# term_node
	    my ($realm, $nonce, $uri, $response, $impi, $homeNet,$opaque,$nc,$cnonce,$qop,$pw);

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
	    $uri = 'sip:' . $homeNet;
	    
	    # 
	    $realm = CtTbl('UC,DigestAuth,realm');
	    $nonce = CtTbl('UC,DigestAuth,nonce');
	    $qop   = CtTbl('UC,DigestAuth,qop');
	    $pw    = CtTbl('UC,DigestAuth,password'); # 
	    $nc    = CtTbl('UC,DigestAuth,nc');    # '00000001';
	    $cnonce= CtTbl('UC,DigestAuth,cnonce'); # SipRandHexStr(32);

	    $response = CtUtAuthDigestMD5($impi,
					  $realm,
					  $pw,
					  'REGISTER',
					  $uri,
					  $nonce,
					  $nc,
					  $cnonce,
					  $qop);
	    
	    return "username=\"$impi\", realm=\"$homeNet\", qop=$qop, nonce=\"$nonce\",nc=$nc,cnonce=\"$cnonce\", uri=\"$uri\", response=\"$response\"";
	},
],
},

#============================================================
# Authorization header (Re-REGISTER)
#============================================================
# 
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.Copy',				# MSG
'PT' => 'HD',
'FM' => '%s',	# #TXT#
'AR' => [
	sub {
	    my ($authorization);
	    $authorization = CtFlv('HD,#Authorization,#TXT#', CtRlCxUsr(@_)->{'auth_reg'});
	    $authorization =~ s/\r?\n//;
	    if (!$authorization) {
		MsgPrint('WAR', "cannot get Authorization header from reference message\n");
		# XXX:
	    }
	    return $authorization;
	},
],
},
# algorithm
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Authorization.Copy.noAlgorithm',
'PT' => 'HD',
'FM' => 'Authorization: Digest %s',	# #TXT#
'AR' => [
	sub {
	    my (@params);
	    @params=map{($_->{'tag'} !~ /algorithm/) ? (','.$_->{'tag'}.'="'.$_->{$_->{'tag'}}.'"'):''}
	                 (@{CtFlv("HD,#Authorization,credentials,credential,digestresp,list", CtRlCxUsr(@_)->{'auth_reg'})});
	    return substr(join('',@params),1);
	},
],
},

#============================================================
# Security-Client
#============================================================
# 
# 
# XXX:
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Security-Client',					# UC, PRM(term_node)
'PT' => 'HD',
'FM' => 'Security-Client: %s',
'AR' => [
	sub {
	    my ($term_node);		# term_node
	    my ($mech, $q, $alg, $ealg, $spi_c, $spi_s, $port_c, $port_s);
	    my ($str);
	    
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
	    $sc = CtTbl('UC,SecurityClient', $term_node);
	    if (!$sc) {
		MsgPrint('WAR', "cannot get UC,SecurityClient\n");
	    }
	    return $sc;
	},
],
},


#============================================================
# Security-Client
#============================================================
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Security-Client.Obsolete',			# UC, PRM(term_node)
'PT' => 'HD',
#'FM' => 'Security-Client: ipsec-3gpp; alg=%s; spi-c=%s; spi-s=%s; port-c=%s; port-s=%s',
'FM' => 'Security-Client: %s',
'AR' => [
	sub {
	    my ($term_node);		# term_node
	    my ($mech, $q, $alg, $ealg, $spi_c, $spi_s, $port_c, $port_s);
	    my ($str,$negoname);
	    
	    $term_node = CtRlCxUsr(@_)->{'term_node'};
	    $negoname=CtRlCxUsr(@_)->{'security_nego'};

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
	    $str = CtSecNego($negoname,'mech', $term_node) || 'ipsec-3gpp';
	    
	    if( $q = CtSecNego($negoname,'q', $term_node) ){ $str .= '; q=' . $q; }
	    $str .= '; alg=' . (CtSecNego($negoname,'alg', $term_node) || 'hmac-sha-1-96'); # 
	    if( $ealg = CtSecNego($negoname,'ealg', $term_node) ){
		# ealg
		$str .= '; ealg='.$ealg;
	    }
	    $str .= 
		'; spi-c='  . CtSecNego($negoname,'spi_lc',$term_node) .
		'; spi-s='  . CtSecNego($negoname,'spi_ls',$term_node) .
		'; port-c=' . CtSecNego($negoname,'port_lc',$term_node) .
		'; port-s=' . CtSecNego($negoname,'port_ls',$term_node);

	    return $str;
	},
],
},

#============================================================
# Route
#============================================================
# 
# Route
# RouteSet
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Route',							# DLG or UC, PRM(term_node)
'PT' => 'HD',
#'PR' => \q{CtSvDlg(CtRlCxDlg(@_), 'RouteSet') ne ''},	# RouteSet
'PR' => [
	sub {
	    my ($term_node, $dlg);		# term_node
	    
	    $term_node = CtRlCxUsr(@_)->{'term_node'};
	    if (!$term_node) {
		# 
			my ($emu_node) = CtRlCxUsr(@_)->{'emu_node'};
			if ($emu_node) {
			    $term_node = $emu_node;
			} else {
			    # CtTbl
			    # 
			    $term_node = $DIRRoot{'ACTND'}->{'ID'};
			}
		    }
	    if (CtTbl('UC,DefaultRouteSet', $term_node)) {
		# UC,DefaultRouteSet
		return 1;
	    }
	    $dlg = CtRlCxDlg(@_);	# 
	    if ($dlg and CtSvDlg($dlg, 'RouteSet')) {
		# 
		return 1;
	    }
	    return 0;
	},
],
'FM' => 'Route: %s',
'AR' => [
	sub {
	    my ($dlg, $route);
	    $dlg = CtRlCxDlg(@_);	# 
	    if ($dlg) {
		$route = CtSvDlg($dlg, 'RouteSet');
	    } else {
		$route = '';
	    }

	    if ($route eq '') {
		# 
		# 
		my ($term_node) = CtRlCxUsr(@_)->{'term_node'};
		if (!$term_node) {
		    # 
		    my ($emu_node) = CtRlCxUsr(@_)->{'emu_node'};
		    if ($emu_node) {
			$term_node = $emu_node;
		    } else {
			# CtTbl
			# 
			$term_node = $DIRRoot{'ACTND'}->{'ID'};
		    }
		}
		$route = CtTbl('UC,DefaultRouteSet', $term_node);
		if ($dlg) {
		    # 
		    # XXX:
	            CtTbSet("DLG,$dlg,RouteSet", $route);
		}
	    }
	    if (ref($route) eq 'ARRAY') {
#			$route = join ("\r\nRoute: ", @$route);
		$route = join (",", @$route);
	    }
	    
	    return ($route);
	},
],
},

#============================================================
# Route (copy)
#============================================================
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Route.CopyIfExists',				# MSG
'PT' => 'HD',
'PR' => \q{ CtUtIsExistHdr('Route', CtRlCxPkt(@_)) },	# Route
'FM' => 'Route: %s',
'AR' => [
	sub {
	    my ($route);
	    $route = CtFlv('HD,#Route,#REST#', CtRlCxPkt(@_));
	    if (ref($route) eq 'ARRAY') {
#			$route = join ("\r\nRoute: ", @$route);
		$route = join (",", @$route);
	    }
	    return ($route);
	},
],
},


##########################################
# 3
#  (1) E.U:P-Header.Security-Verify
#  (2) E.U:P-Header.Security-Verify.FromResponse
#  (3) E.U:P-Header.Security-Verify.FromRequest
# XXX:(2)
#     
##########################################

#============================================================
# Security-Verify (UC,SecurityVerify)
#============================================================
# 
# XXX:REGISTER
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Security-Verify',				# UC, PRM(term_node)
'PT' => 'HD',
'FM' => 'Security-Verify: %s',
'AR' => [
	sub {
	    my ($term_node);		# term_node
	    my ($sv);
	    
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
	    $sv = CtTbl('UC,SecurityVerify', $term_node);
	    if (ref($sv) eq 'ARRAY') {
		$sv = join("\r\nSecurity-Verify: ", @$sv);
	    }
	    return ($sv);
	},
],
},

#============================================================
# Security-Verify (from response)
#============================================================
# 
# 
# XXX:Security-Verify
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Security-Verify.FromResponse',	# MSG
'PT' => 'HD',
'FM' => 'Security-Verify: %s',
'AR' => [
	sub {
	    my ($sv);
	    $sv = CtFlv('HD,#Security-Server,#REST#', CtRlCxPkt(@_));
	    if (ref($sv) eq 'ARRAY') {
		$sv = join("\r\nSecurity-Verify: ", @$sv);
	    }
	    MsgPrint('RULE', "Security-Verify Info [$sv]\n");
	    return ($sv);
	},
],
},

#============================================================
# Security-Verify (from request)
#============================================================
# 
# XXX:Security-Verify
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Security-Verify.FromRequest',		# MSG
'PT' => 'HD',
'FM' => 'Security-Verify: %s',
'AR' => [
	sub {
	    my ($sv);
	    $sv = CtFlv('HD,#Security-Verify,#REST#', CtRlCxUsr(@_)->{'pre_req'});
	    if (ref($sv) eq 'ARRAY') {
		$sv = join("\r\nSecurity-Verify: ", @$sv);
	    }
	    MsgPrint('RULE', "Security-Verify Info [$sv]\n");
	    return ($sv);
	},
],
},

#============================================================
# Require (copy)
#============================================================
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Require.CopyIfExists',			# MSG
'PT' => 'HD',
'PR' => \q{ CtUtIsExistHdr('Require', CtRlCxPkt(@_)) },			# Require
'FM' => 'Require: %s',
'AR' => [
	sub {
	    my ($option);
	    $option  = CtFlv('HD,#Require,option',CtRlCxPkt(@_));
	    return $option;
	},
],
},

#============================================================
# Require (sec-agree)
#============================================================
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Require.sec-agree',				# NONE
'PT' => 'HD',
'FM' => 'Require: sec-agree',
},

#============================================================
# Proxy-Require (sec-agree)
#============================================================
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Proxy-Require.sec-agree',			# NONE
'PT' => 'HD',
'FM' => 'Proxy-Require: sec-agree',
},

#============================================================
# Proxy-Require (copy)
#============================================================
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Proxy-Require.CopyIfExists',		# MSG
'PT' => 'HD',
'PR' => \q{ CtUtIsExistHdr('Proxy-Require', CtRlCxPkt(@_)) },	# Proxy-Require
'FM' => 'Proxy-Require: %s',
'AR' => [
	sub {
		my ($option);
		$option  = CtFlv('HD,#Proxy-Require,option',CtRlCxPkt(@_));
		return $option;
	},
],
},

#============================================================
# Unsupported (sec-agree)
#============================================================
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Unsupported.require',
'PT' => 'HD',
'FM' => 'Unsupported: %s',
'AR' => [\q{CtFlv('HD,#Require,option',CtRlCxPkt(@_))}]
},

#============================================================
# Supported (path)
#============================================================
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Supported.none',					# NONE
'PT' => 'HD',
'FM' => 'Supported: ',
},

{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Supported.path',
'PT' => 'HD',
'FM' => 'Supported: path',
},

#============================================================
# Allow (INVITE,ACK,CANCEL,OPTIONS,BYE)
#============================================================
# RFC3261
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Allow.IMS',
'PT' => 'HD',
'FM' => 'Allow: INVITE,ACK,CANCEL,OPTIONS,BYE',			# NONE
},

#============================================================
# Allow-Events (reg)
#============================================================
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Allow-Events.reg',				# NONE
'PT' => 'HD',
'FM' => 'Allow-Events: reg',
},

#============================================================
# Event (reg)
#============================================================
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Event.reg',						# NONE
'PT' => 'HD',
'FM' => 'Event: reg',
},

#============================================================
# Content-Length
#============================================================
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Content-Length.calc',				# NONE
'PT' => 'HD',
'OD' => 'LAST',
'FM' => 'Content-Length: %s',
'AR' => [\&CtUtCalcContentLeng],
},

#============================================================
# Max-Forwards
#============================================================
# 
# CtIoSendMsg()
#   msg_path	
#   emu_node	
#   term_node	
#   with_dlg	
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Max-Forwards',					# PRM(msg_path,emu_node,term_node,with_dlg)
'PT' => 'HD',
'FM' => 'Max-Forwards: %s',
'AR' => [
	sub {
	    my ($msg_path, $emu_node, $term_node, $with_dlg);
	    
	    $msg_path = CtRlCxUsr(@_)->{'msg_path'};
	    if (!$msg_path) {
		MsgPrint('WAR', "no meg_path\n");
		# XXX: CANCEL
		# XXX: 
		# XXX: 
		#	return 70;
	    }
	    $emu_node = CtRlCxUsr(@_)->{'emu_node'};	# 
	    if (!$emu_node) {
		# 
		$emu_node = $DIRRoot{'ACTND'}->{'ID'};
	    }
	    $term_node = CtRlCxUsr(@_)->{'term_node'};	# 
	    if (!$term_node) {
		# 
		$term_node = $emu_node;
	    }
	    $with_dlg = CtRlCxUsr(@_)->{'with_dlg'};
	    if ($with_dlg eq '') {
		# 
		# XXX:
		#	if (CtRlCxDlg(@_)) {
		#		$with_dlg = 1;
		#	} else {
		#		$with_dlg = 0;
		#	}
	    }
	    return CtSvGenMaxForwards($msg_path, $term_node, $emu_node, $with_dlg);	
	}
],
},

#============================================================
# Max-Forwards (70)
#============================================================
# 
# 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Max-Forwards.70',					# NONE
'PT' => 'HD',
'FM' => 'Max-Forwards: 70',
},

#============================================================
# Via (Request)
#============================================================
# 
# 
# CtIoSendMsg()
#   msg_path	
#   emu_node	
#   term_node	
#   with_dlg	
#   protected	IPSec
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Via.Request',						# PRM(msg_path,emu_node,term_node,with_dlg,protected)
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
	sub {
	    my ($msg_path, $emu_node, $term_node, $with_dlg, $protected);
	    my ($addRcvd) = 1; 	# XXX: 0
	    
	    $msg_path = CtRlCxUsr(@_)->{'msg_path'};
	    if (!$msg_path) {
		# Via
         	CtSvError('fatal', "msg_path is not specified");
	    }
	    $emu_node = CtRlCxUsr(@_)->{'emu_node'};	#
	    if (!$emu_node) {
		# 
		$emu_node = $DIRRoot{'ACTND'}->{'ID'};
	    }
	    $term_node = CtRlCxUsr(@_)->{'term_node'};	# 
	    if (!$term_node) {
		# 
		$term_node = $emu_node;
	    }
	    $with_dlg = CtRlCxUsr(@_)->{'with_dlg'};
	    $protected = CtRlCxUsr(@_)->{'protected'};
	    if ($protected eq '') {
		# XXX:
	    }
	    return CtSvGenRequestVia($msg_path, $term_node, $emu_node, $with_dlg, $protected, $addRcvd);
	}
],
},

#============================================================
# Via (copy 1st Via)
#============================================================
# 
# 
# XXX: 
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Via.Request.Copy1st',				# MSG
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
	sub {
		# 
		my ($via);
		my ($msg) = CtRlCxPkt(@_);	# CtIoSendMsg()

	##	$via = CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg);
	#	$via = CtFlv('HD,#Via,records,#ViaParm', $msg);
	#	if (ref($via) eq 'ARRAY') {
	#		CtFlDel('params,list,#ViaReceived', $via->[0]);	# received
	#		foreach my $v (@$via) {
	#			my ($ve) = CtPkEncode($v, '');
	#			$ve =~ s/^,//;
	#			push(@result, $ve);
	#		}
	#		# XXX:
	#		# XXX:
	#		# XXX:
	#	} else {
	#	}

		my ($viaEnc) = CtFlv('HD,#Via#0,records,#ViaParm#0', $msg);
		CtFlDel('params,list,#ViaReceived', $viaEnc);	# XXX:received
		$via = CtPkEncode($viaEnc, '');
		$via =~ s/^,//;

		return $via;
	}
],
},

#============================================================
# Via (copy 1st Via)
#============================================================
# XXX:
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Via.Request.Copy',				# MSG
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
	sub {
		# 
		my ($via);
		my ($msg) = CtRlCxPkt(@_);	# CtIoSendMsg()
		$via = CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg);
		if (ref($via) eq 'ARRAY') {
			return $via->[0];	# XXX: UE
		} else {
			return $via;
		}
	}
],
},

#============================================================
# Via header (Response)
#============================================================
# 
# CtIoSendMsg()
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Via.Response',					# MSG
'PT' => 'HD',
'FM' => 'Via: %s',
'AR' => [
	sub {
		my ($refReq);
		my ($via);

		$refReq = CtRlCxPkt(@_);	# CtIoSendMsg()
		return CtSvGenResponseVia($refReq);

		# XXX: 1st Via
	#	$via = CtFlv('HD,#Via,records,#ViaParm,#TXT#', $refReq);
	#	if (ref($via) eq 'ARRAY') {
	#		# 
	#		foreach my $v (@$via) {
	#			# 'Via:'
	#			# 2
	#			$v =~ s/^,//;
	#		}
	#		return join(',', @$via);
	#	} else {
	#		return $via;
	#	}
	}
],
},

#============================================================
# Record-Route (copy)
#============================================================
# 
# 
# 
#    
#    
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Record-Route.CopyIfExists',
'PT' => 'HD',
'PR' => \q{ CtUtIsExistHdr('Record-Route', CtRlCxPkt(@_)) },	# Record-Route
'FM' => 'Record-Route: %s',
'AR' => [
	sub {
		my ($rr);
		$rr = CtFlv('HD,#Record-Route,#REST#', CtRlCxPkt(@_));
		if (ref($rr) eq 'ARRAY') {
		    $rr = join (",", @$rr);
		}
		return ($rr);
	},
],
},

#######################################################
# Accept
#######################################################
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Accept.application_sdp',				# NONE
'PT' => 'HD',
'FM' => 'Accept: application/sdp, application/3gpp-ims+xml',
},

#######################################################
# Accept-Encoding
#######################################################
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Accept-Encoding.gzip',				# NONE
'PT' => 'HD',
'FM' => 'Accept-Encoding: gzip',
},

#######################################################
# Accept-Language
#######################################################
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Accept-Language.en',					# NONE
'PT' => 'HD',
'FM' => 'Accept-Language: en',
},


#######################################################
# SDP
#######################################################

### SDP (Protocol Version : "v=")
###   Reference : RFC2327
###

{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Body.SDP.v=.zero',
'PT' => 'BD',
'FM' => 'v=0',
},

### SDP (Origin : "o=")
###   Reference : RFC2327
###

{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Body.SDP.o=',
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
'ID' => 'E.U:P-Body.SDP.s=.hyphen',
'PT' => 'BD',
'FM' => 's=-',
},

### SDP (Session Name : "s=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Body.SDP.s=',
'PT' => 'BD',
'FM' => 's=%s',
'AR' => [sub {
    my ($sfield) = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'session-inf,session-name');
    if($sfield) {
        return ($sfield);
    } else {
        return ('-');
    }
}],
},

### SDP (Connection Data : "c=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Body.SDP.c=',
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
'ID' => 'E.U:P-Body.SDP.t=.zero_zero',
'PT' => 'BD',
'FM' => 't=0 0',
},


### SDP (Media Announcements : "m=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Body.SDP.m=',
'PT' => 'BD',
'FM' => '%s',
'AR' => [
  sub {
    my ($ports, $types, $codecs, @list, $retAudio, $retVideo);
	my ($idx, $i);

    $ports  = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,port');
    $codecs = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,fmt-list,fmt');
    $types  = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,media');

    # $ports, $types
    {
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
    } # end - <

    if('ARRAY' eq ref($codecs)) {
      my(@codecs);
      # @codecs = @$codecs;

      {
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
      }


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
      }
      elsif(!$retAudio) {
        return ($retVideo);
      }
      else {
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

### SDP (Attributes : "b=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Body.SDP.b=',
'PT' => 'BD',
'FM' => '%s',
'AR' => [
  sub{
    my ($rcvmsg, $msg) = @_;
    my (@ret, @alines, @medias, @newmedia);
    my ($rtpmaps, $rtpmap, $mline);
    $rtpmaps = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,Bandwidth');
    @ret = @{$msg->{'RULE-RESULT'}};
    foreach(@ret) {
      if('E.U:P-Body.SDP.m=' eq $_->{'ID'}) {
        @alines= split(/\r\n/, $_->{'MSG'});
        foreach(@alines) {
          push(@newmedia, $_);
          if($_ =~ /RTP\/AVP (.*)$/) {
           @medias = split(/ /, $1);
              push(@newmedia,'b='.$rtpmaps);
            } # end - else(<rtpmaps is NOT ARRAY.>)
        } # end - foreach(@alines)
#         PrintVal(\@newmedia);

        {
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
          }
          else {
            if($sdpinfs->{'condition'}) {
              push(@newmedia, "a=$sdpinfs->{'condition'}");
            }
          }
        }

        $_->{'MSG'} = join("\r\n", @newmedia);
      }
    } # end - foreach(@ret)
    return ('');
  }
],
},

### SDP (Attributes : "a=")
###   Reference : RFC2327
###
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Body.SDP.a=',
'PT' => 'BD',
'FM' => '%s',
'AR' => [
  sub{
    my ($rcvmsg, $msg) = @_;
    my (@ret, @alines, @medias, @newmedia);
    my ($rtpmaps, $rtpmap, $mline);
    $rtpmaps = CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf,fmt-list,rtpmap');
    # PrintVal(CtSvSdp(CtRlCxUsr(@_)->{'sdp_id'}, 'media-inf'));
    @ret = @{$msg->{'RULE-RESULT'}};
    foreach(@ret) {
      if('E.U:P-Body.SDP.m=' eq $_->{'ID'}) {
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
        # PrintVal(\@newmedia);

        {
          my ($sdpinfs);
          my (@newmedia2);
          my ($attribute);
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
          }
          else {
            if($sdpinfs->{'condition'}) {
              push(@newmedia, "a=$sdpinfs->{'condition'}");
            }
          }
        }

        # PrintVal(\@newmedia);
        $_->{'MSG'} = join("\r\n", @newmedia);
      }
    } # end - foreach(@ret)
    return ('');
  }
],
},


### Content-Type header
###   Reference : RFC3261
###
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.Content-Type.application_sdp',
'PT' => 'HD',
'FM' => 'Content-Type: application/sdp',
},


### P-Access-Network-Info
### Reference : 
### 090428 Inoue added
{
'TY' => 'ENCODE',
'ID' => 'E.U:P-Header.P-Access-Network-Info',
'PT' => 'HD',
'FM' => 'P-Access-Network-Info: 3GPP-UTRAN-TDD;utran-cell-id-3gpp=123456A1BDS23',
},



);	# IMS_EmuEncodeRules
## DEF.END


1;
