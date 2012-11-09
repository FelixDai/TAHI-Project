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

#=================================================================
#
# RFC4566 "Session Discription Protocol" (Section ALL)
#
# ToDo
#  - RFC4566 
#
#=================================================================

## DEF.VAR
@IMS_RFC4566_SyntaxRules =
(

#########################
### Rule (RFC4566) 
#########################

#--------------------------------------------------------------------------------------------
# SYNTAX Rule for RFC4566-5-2 ()
# 
# 
#--------------------------------------------------------------------------------------------
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC4566-5-2',
    'CA' => 'Body',
    'ET' => 'error',
    'OK' => 'Whitespace MUST NOT be used on either side of the "=" sign.',
    'NG' => 'Whitespace MUST NOT be used on either side of the "=" sign.',
    'EX' => sub {
	CtFlGet('INET,#SIP,#TXT#',@_) =~ /$PtSIPMessageMT/;
	my $body = $3;
	return !($body && (($body =~ /^[a-z]\s+=/mg) || ($body =~ /^[a-z]=[\x20\x9]+\S+/mg)));}
},

#--------------------------------------------------------------------------------------------
# v,o,s,(c),t,m,(c) line is REQUIRED in the SDP message.
# (c line MUST included session level information or all of media infomation)
# [RFC4566-5-3]
#
# ChangeLog   : 20090312 orimo "Syntax message updated"
#--------------------------------------------------------------------------------------------
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC4566-5-3',
	'CA' => 'Body',				      	# XXX:Body?? -> Body
	'ET' => 'warning',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
	'OK' => 'v,o,s,(c),t,m,(c) lines are REQUIRED in the SDP message. (c line MUST included session level information or all of media information).',
	'NG' => 'v,o,s,(c),t,m,(c) lines are REQUIRED in the SDP message. (c line MUST included session level information or all of media information).',
	'EX' => [
		sub {
			my ($msg) = CtRlCxPkt(@_);	# 

			# 
			if (!CtFlv('BD,#v=', $msg)) { return ''; } # NG
			if (!CtFlv('BD,#o=', $msg)) { return ''; } # NG
			if (!CtFlv('BD,#s=', $msg)) { return ''; } # NG
			if (!CtFlv('BD,#t=', $msg)) { return ''; } # NG
			if (!CtFlv('BD,#m=', $msg)) { return ''; } # NG

			# 
			if (CtFlv('BD,#c=', $msg)) {
				# Session Description
				# 
				return 'OK';
			} else {
				# Session Description
				# Media Description
				my ($nMedia);
				$nMedia = CtFlv('BD,#m=,media-part#N', $msg);
				if ($nMedia > 0) {
					for my $i (0..$nMedia-1) {
						# Media Description
						if (!CtFlv("BD,#m=,media-part#$i,descriptions,#c=,nettype", $msg)) {
							# 
							return '';	# NG
						}
					}
				} else {
					# Session Description
					# 
					return '';	# NG XXX:
				}
			}
			return 'OK';
		},
	],
},

#--------------------------------------------------------------------------------------------
# all MUST appear in exactly the following order: 
# "v,o,s,(i),(u),(e),(p),(c),(b),t,(r),(z),(k),(a),m,(i),(c),(b),(k),(a)"
# (the line enclosed in "()" is OPTIONAL)[RFC4566-5-4]
#
# ChangeLog   : 20090312 orimo "Syntax message updated"
#--------------------------------------------------------------------------------------------
# 
# 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC4566-5-4',
	'CA' => 'Body',								# XXX:Body?? -> Body
	'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
	'OK' => 'all MUST appear in exactly the following order: "v,o,s,(i),(u),(e),(p),(c),(b),t,(r),(z),(k),(a),m,(i),(c),(b),(k),(a)"(the line enclosed in "()" is OPTIONAL)',
	'NG' => 'all MUST appear in exactly the following order: "v,o,s,(i),(u),(e),(p),(c),(b),t,(r),(z),(k),(a),m,(i),(c),(b),(k),(a)"(the line enclosed in "()" is OPTIONAL)',
	'EX' => [
		sub {
			#-----------------------------------------------------------------------
			# RFC4566
			#
			#     Session description
			#        v=  (protocol version)
			#        o=  (originator and session identifier)
			#        s=  (session name)
			#        i=* (session information)
			#        u=* (URI of description)
			#        e=* (email address)
			#        p=* (phone number)
			#        c=* (connection information -- not required if included in
			#             all media)
			#        b=* (zero or more bandwidth information lines)
			#        One or more time descriptions ("t=" and "r=" lines; see below)
			#        z=* (time zone adjustments)
			#        k=* (encryption key)
			#        a=* (zero or more session attribute lines)
			#        Zero or more media descriptions
			#
			#     Time description
			#        t=  (time the session is active)
			#        r=* (zero or more repeat times)
			#
			#     Media description, if present
			#        m=  (media name and transport address)
			#        i=* (media title)
			#        c=* (connection information -- optional if included at
			#             session level)
			#        b=* (zero or more bandwidth information lines)
			#        k=* (encryption key)
			#        a=* (zero or more media attribute lines)
			#
			# NOTE: OPTIONAL items are marked with a "*"
			#-----------------------------------------------------------------------
			my (%SessionDescOrder) = (	# SessionDescription
				# m:
				'v' => 1,	# m
				'o' => 2,	# m
				's' => 3,	# m
				'i' => 4,	# o
				'u' => 5,	# o
				'e' => 6,	# o
				'p' => 7,	# o
				'c' => 8,	# o
				'b' => 9,	# oo
				't' => 10,	# mm	# TimeDescription
				'r' => 11,	# oo	# TimeDescription
				'z' => 12,	# o
				'k' => 13,	# o
				'a' => 14,	# oo
				'm' => 15,	# oo -> MediaDesciption
			);
			my (%MediaDescOrder) = (	# MediaDescription
				'v' => -1,	# m
				'o' => -1,	# m
				's' => -1,	# m
			#	'i' => -1,	# o
				'u' => -1,	# o
				'e' => -1,	# o
				'p' => -1,	# o
			#	'c' => -1,	# o
			#	'b' => -1,	# oo
				't' => -1,	# mm	# TimeDescription
				'r' => -1,	# oo	# TimeDescription
				'z' => -1,	# o
			#	'k' => -1,	# o
			#	'a' => -1,	# oo
				'm' => 1,	# m
				'i' => 2,	# o
				'c' => 3,	# o(session
				'b' => 4,	# oo
				'k' => 5,	# o
				'a' => 6,	# oo
			);
			my ($last_pos) = 100;	# 
			my ($context) = 'SD';	# 
			my ($body, @lines, @types);

			$body = CtFlp('BD', CtRlCxPkt(@_));	# 
			@lines = split(/[\r\n]+/, $body);
			foreach my $line (@lines) {
				if ($line =~ /^([a-z])=.*$/) {	# type=value
					my ($type) = $1;	# 
					my ($pos);			# 

					if ($type eq 'v') {					# v
						if ($last_pos == 100) {			# 
							# 
							$last_pos = $SessionDescOrder{$type};
							next;
						}
					} elsif ($type eq 'm') {			# m
						if ($context eq 'MD') {			# 2
							# 
							# 
							#    2
							$last_pos = $MediaDescOrder{$type};
							next;
						}
						# 
					}

					if ($context eq 'SD') {
						# 
						$pos = $SessionDescOrder{$type};
					} else {
						# 
						$pos = $MediaDescOrder{$type};
					}
					if (!$pos) {	# 
						next;		# XXX:
					}
					if ($pos < $last_pos) {
						# 
						if ($type eq 't') {
							# TimeDescription
							# t
							# 
							if ($last_pos - $pos > 1) {
								return '';	# NG
							}
						} else {
							return '';	# NG
						}
					} elsif ($pos == $last_pos) {
						# 
						# 
					#	unless ($type eq 'b' or $type eq 't' or $type eq 'r' or $type eq 'a' or $type eq 'm') {
					#		return '';	# NG: XXX:b,t,r,a,m
					#	}
					}

					# 
					$last_pos = $pos;	# 

					if ($type eq 'm') {
						# 
						$context = 'MD';	# media-level
						# 
						$last_pos = $MediaDescOrder{$type};
					}
				}
			}
			return 'OK';
		},
	],
},


#-----------------------------------------------------------------------------
# * o line
#     For both IP4 and IP6, the fully qualified domain name is the form that SHOULD be 
#     given unless this is unavailable, in which case the globally unique address 
#     MAY be substituted.[RFC4566-5.2-3]
#
# ChangeLog   : 20090312 orimo "Syntax message updated"
#     
#-----------------------------------------------------------------------------
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC4566-5.2-3',		
	'CA' => 'o=',							
	'PR' => sub {
	    my ($host);
	    $host = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,host',@_);
	    return $host && !CtUtIPAdType($host);
	},

	'OK' => 'For both IP4 and IP6, the fully qualified domain name is the form that SHOULD be given unless this is unavailable, in which case the globally unique address MAY be substituted.',
	'NG' => 'For both IP4 and IP6, the fully qualified domain name is the form that SHOULD be given unless this is unavailable, in which case the globally unique address MAY be substituted.',
	'EX' => [
		sub {
			my ($msg) = CtRlCxPkt(@_);  # 
			my ($addr);

			# o=<username> <sess-id> <sess-version> <nettype> <addrtype> <unicast-address>
			$addr = CtFlv('BD,#o=,addr', $msg);
			if (!$addr) {
				return '';	# NG XXX:
			}
			# 
			if ($addr =~ /^[A-Za-z0-9\-\.]+$/) {	# ABNF
				return 'OK';
			} else {
				return '';	# NG
			}
		},
	],
},


#--------------------------------------------------------------------------------------------
# There MUST be one and only one "s=" field per session description.
# s= 
#--------------------------------------------------------------------------------------------
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC4566-5.3-1',
    'CA' => 's=',
    'ET' => 'error',
    'OK' => 'There MUST be one and only one "s=" field per session description.',
    'NG' => 'There MUST be one and only one "s=" field per session description.',
    'EX' => \q{$#{CtFlGet('INET,#SIP,BD,#s=',@_[0],'T')} < 1},
},


#--------------------------------------------------------------------------------------------
# SYNTAX Rule for RFC4566-5.3-2 ()
# 
#--------------------------------------------------------------------------------------------
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC4566-5.3-2',
    'CA' => 's=',
    'ET' => 'error',
    'OK' => 'The "s=" field MUST NOT be empty.',
    'NG' => 'The "s=" field MUST NOT be empty.',
    'EX' => sub {
	CtFlGet('INET,#SIP,#TXT#',@_) =~ /$PtSIPMessageMT/;
	my $body = $3;
	return !($body =~ /^s=[\r\n]/gm);
    },
},


#--------------------------------------------------------------------------------------------
# SYNTAX Rule for RFC4566-5.3-4 ()
# 
#--------------------------------------------------------------------------------------------
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC4566-5.3-4',
    'CA' => 's=',
    'ET' => 'warning',
    'OK' => 'If a session has no meaningful name, the value "s= " SHOULD be used.',
    'NG' => 'If a session has no meaningful name, the value "s= " SHOULD be used.',
    'EX' => sub{my $a=CtFlv('BD,#s=,sessname',@_);
		return ($a eq '' || $a eq '-' || $a =~/^\s+$/);}
},

#--------------------------------------------------------------------------------------------
# * "c=" line  c=<nettype> <addrtype> <connection-address>
#   A session description MUST contain either at least one "c=" field in each media description or 
#   a single "c=" field at the session level. [RFC4566-5.7-1]
#
# ChangeLog   : 20090312 orimo "Syntax message updated"
#--------------------------------------------------------------------------------------------
# 
# 
# 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC4566-5.7-1',
	'CA' => 'c=',
	'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# Body
	'OK' => 'A session description MUST contain either at least one "c=" field in each media description or a single "c=" field at the session level.',
	'NG' => 'A session description MUST contain either at least one "c=" field in each media description or a single "c=" field at the session level.',
	'EX' => [
		sub {
			my ($msg) = CtRlCxPkt(@_);	# 

			if (CtFlv('BD,#c=', $msg)) {
				# Session Description
				# 
				return 'OK';
			} else {
				# Session Description
				# Media Description
				my ($nMedia);
				$nMedia = CtFlv('BD,#m=,media-part#N', $msg);
				if ($nMedia > 0) {
					for my $i (0..$nMedia-1) {
						# Media Description
						if (!CtFlv("BD,#m=,media-part#$i,descriptions,#c=,nettype", $msg)) {
							# 
							return '';	# NG
						}
					}
				} else {
					# Session Description
					# 
					return '';	# NG XXX:
				}
			}
			return 'OK';
		},
	],
},


#--------------------------------------------------------------------------------------------
# SYNTAX Rule for RFC4566-5.7-7 ()
# 
#--------------------------------------------------------------------------------------------
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC4566-5.7-7',
    'CA' => 'c=',
    'ET' => 'error',
    'OK' => 'A session-level "c=" field  MUST NOT specify Multiple addresses or "c=" lines.',
    'NG' => 'A session-level "c=" field  MUST NOT specify Multiple addresses or "c=" lines.',
    'EX' => \q{$#{CtFlGet('INET,#SIP,BD,#c=',@_[0],'T')} < 1},
},

);

1;

