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

#=============================================================================
#
# RFC3264 "An Offer/Answer Model with the Session Description Protocol (SDP)"
#
# ToDo
#  - RFC3264 
#
#=============================================================================

## DEF.VAR
@IMS_RFC3264_SyntaxRules =
(

#########################
### Rule (RFC3264) 
#########################

### S.RFC3264-5-4
###
###

{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3264-5-4',
	'CA' => 'Body',                                  # XXX:Body?? -> Body
	'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
	'OK' => \\'an SDP message used in the offer/answer model MUST contain exactly one session description.',
	'NG' => \\'an SDP message used in the offer/answer model MUST contain exactly one session description.',
	'EX' => [
		sub {
			# 
			my ($msg) = CtRlCxPkt(@_);	# 
			my ($v) = CtFlv('BD,#v=', $msg);
			if ($v && ref($v) ne 'ARRAY') {
				return 'OK';
			} else {
				return '';		# NG
			}
		},
	],
},


#-----------------------------------------------------------------------------
# * o line
#     The numeric value of the session id and version in the o line 
#     MUST be representable with a 64 bit signed integer.[RFC3264-5-2]
#-----------------------------------------------------------------------------
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3264-5-2',
	'CA' => 'o=',								# XXX o=
	'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
	'OK' => \\'The numeric value of the session id and version in the o line MUST be representable with a 64 bit signed integer.',
	'NG' => \\'The numeric value of the session id and version in the o line MUST be representable with a 64 bit signed integer.',
	'EX' => [
		sub {
			use bigint;		# XXX:64bit
			my ($msg) = CtRlCxPkt(@_);  # 
			my ($sessid, $sessver);

			$sessid = CtFlv('BD,#o=,sessid',$msg);
			$sessver = CtFlv('BD,#o=,sessver',$msg);
			if ($sessid > 9223372036854775807) {		# (2**63)-1
				return '';	# NG
			} elsif ($sessid < -9223372036854775808) {	# -(2**63)
				return '';	# NG
			}
			if ($sessver > 9223372036854775807) {		# (2**63)-1
				return '';	# NG
			} elsif ($sessver < -9223372036854775808) {	# -(2**63)
				return '';	# NG
			}
			return 'OK';
		},
	],
},

#-----------------------------------------------------------------------------
# * o line
#     The initial value of the version MUST be less than (2**62)-1, to avoid rollovers.
#     [RFC3264-5-3]
#-----------------------------------------------------------------------------
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3264-5-3',
	'CA' => 'o=',					
	'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
	'OK' => \\'The initial value of the version MUST be less than (2**62)-1, to avoid rollovers.',
	'NG' => \\'The initial value of the version MUST be less than (2**62)-1, to avoid rollovers.',
	'EX' => [
		sub {
			use bigint;		# XXX:64bit
			my ($msg) = CtRlCxPkt(@_);  # 
    		my ($sessver) = CtFlv('BD,#o=,sessver', $msg);
			if ($sessver < 4611686018427387903) {		# (2**62)-1
				return 'OK';
			} else {
				return '';	# NG
			}
		},
	],
},




#-----------------------------------------------------------------------------
# * t line
#     The "t=" line SHOULD have a value of "0 0".[RFC3264-5-6]
#-----------------------------------------------------------------------------
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3264-5-6',
	'CA' => 't=',
	'ET' => 'warning',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
	'OK' => \\'The \"t=\" line SHOULD have a value of \"0 0\".',
	'NG' => \\'The \"t=\" line SHOULD have a value of \"0 0\".',
	'EX' => [
		sub {
			my ($msg) = CtRlCxPkt(@_);  # 
			my ($start, $stop);
			$start = CtFlv('BD,#t=,times,start-time', $msg);
			$stop = CtFlv('BD,#t=,times,stop-time', $msg);
			if (($start == 0) && ($stop == 0)) {
				return 'OK';
			} else {
				return '';  # NG
			}
		},
	],
},


#--------------------------------------------------------------------------------------------
# * a line
#     The ptime attribute MUST be greater than zero.[RFC3264-5.1-12]
#
# 
#
# 5 Generating the Initial Offer
# 5.1 Unicast Streams
#  If the ptime attribute is present for a stream, it indicates the
#  desired packetization interval that the offerer would like to
#  receive.  The ptime attribute MUST be greater than zero.
#--------------------------------------------------------------------------------------------
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3264-5.1-12',
	'CA' => 'a=',
	'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
	'OK' => \\'The ptime attribute MUST be greater than zero.',
	'NG' => \\'The ptime attribute MUST be greater than zero.',
	'EX' => [
		sub {
			# a=ptime:
			# 
			my ($body, @lines, @types);

			$body = CtFlp('BD', CtRlCxPkt(@_));	# 
			@lines = split(/[\r\n]+/, $body);
			foreach my $line (@lines) {
				if ($line =~ /^a=ptime:(\d+)$/) {
					my ($ptime) = $1;
					if ($ptime <= 0) {
						return '';		# NG
					}
				}
			}
			return 'OK';
		},
	],
},


#--------------------------------------------------------------------------------------------
# * "t=" line  t=<start-time> <stop-time>
#   The "t=" line in the answer MUST equal that of the offer. [RFC3264-6-5]
#--------------------------------------------------------------------------------------------
# 
# 
# 
# 
#    
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3264-6-5',
	'CA' => 't=',
	'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxUsr(@_)->{'pre_req'})) },	# 
	'OK' => \\'The \"t=\" line in the answer MUST equal that of the offer. ',
	'NG' => \\'The \"t=\" line in the answer MUST equal that of the offer. ',
	'EX' => [
		sub {
			my ($msg) = CtRlCxPkt(@_);  # 
			my ($pre_req);
			my ($offer_t, $answer_t);

			$pre_req = CtRlCxUsr(@_)->{'pre_req'};	# 
			if (!$pre_req) {
				CtSvError('fatal', "pre_req is not specified(S.RFC3264-6-5)");
				return '';
			}

			$offer_t = CtFlv('BD,#t=,#TXT#', $pre_req);
			if ($offer_t) {
				$answer_t = CtFlv('BD,#t=,#TXT#', $msg);
				if ($offer_t ne $answer_t) {
					return '';	# NG
				} else {
					return 'OK';
				}
			} else {
				# 
			#	CtSvError('fatal', "pre_req does not have t= line(S.RFC3264-6-5)");
				MsgPrint('WAR', "pre_req does not have t= line(S.RFC3264-6-5)\n");
				return '';
			}
		},
	],
},

#--------------------------------------------------------------------------------------------
# * "m=" line  m=<media> <port> <proto> <fmt list>
#   The answer MUST contain exactly the same number of "m=" lines as the offer. [RFC3264-6-3]
#--------------------------------------------------------------------------------------------
# 
# 
# 
# 
#    
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3264-6-3',
	'CA' => 'm=',
	'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxUsr(@_)->{'pre_req'})) },	# 
	'OK' => \\'The answer MUST contain exactly the same number of \"m=\" lines as the offer. ',
	'NG' => \\'The answer MUST contain exactly the same number of \"m=\" lines as the offer. ',
	'EX' => [
		sub {
			my ($msg) = CtRlCxPkt(@_);  # 
			my ($pre_req) = CtRlCxUsr(@_)->{'pre_req'};	# 

			if (!$pre_req) {
				CtSvError('fatal', "pre_req is not specified(S.RFC3264-6-3)");
				return '';
			}
			# m=
			if (CtFlv('BD,#m=,media-part#N', $pre_req) != CtFlv('BD,#m=,media-part#N', $msg)) {
				return '';	# NG
			} else {
				return 'OK';
			}
		},
	],
},


#-----------------------------------------------------------------------------
# * t line
#     The "t=" line MUST be equal to "0 0".[RFC3264-9-2]
#-----------------------------------------------------------------------------
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3264-9-2',
	'CA' => 't=',
	'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
	'OK' => \\'The \"t=\" line MUST be equal to \"0 0\".',
	'NG' => \\'The \"t=\" line MUAT be equal to \"0 0\".',
	'EX' => [
		sub {
			my ($msg) = CtRlCxPkt(@_);  # 
			my ($start, $stop);
			$start = CtFlv('BD,#t=,times,start-time', $msg);
			$stop = CtFlv('BD,#t=,times,stop-time', $msg);
			if (($start == 0) && ($stop == 0)) {
				return 'OK';
			} else {
				return '';  # NG
			}
		},
	],
},



);

1;
