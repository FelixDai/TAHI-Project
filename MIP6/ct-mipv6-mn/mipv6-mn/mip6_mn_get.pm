#!/usr/bin/perl -w
#
# Copyright (C) IPv6 Promotion Council,
# NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT),
# Yokogwa Electoric Corporation, YASKAWA INFORMATION SYSTEMS Corporation
# and NTT Advanced Technology Corporation(NTT-AT) All rights reserved.
# 
# Technology Corporation.
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

# PACKAGE
package mip6_mn_get;

# EXPORT PACKAGE
use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	set_frames
	get_value_of_packet
	get_value_of_packet_by_name
	get_value_of_unexpect
	get_name_of_unexpect
	get_strange_unexpect
	get_value_of_icmp6_du
	get_value_of_icmp6_pp
	get_value_of_echorequest
	get_value_of_echoreply
	get_value_of_rs
	get_value_of_ra
	get_value_of_ns
	get_value_of_na
	get_value_of_haadrequest
	get_value_of_haadreply
	get_value_of_mps
	get_value_of_mpa
	get_value_of_brr
	get_value_of_hoti
	get_value_of_coti
	get_value_of_hot
	get_value_of_cot
	get_value_of_bu
	get_value_of_bu_cn
	get_value_of_ba
	get_value_of_ba_cn
	get_value_of_be
	get_value_of_ipv6
);

# INPORT PACKAGE
use V6evalTool;
use mip6_mn_config;


# GLOBAL VARIABLE DEFINITION

# LOCAL VARIABLE DEFINITION
$ipv6_frame = 'Frame_Ether.Packet_IPv6';
@frames_known = ();
@frames_ilesp = ();

$F = 'Frame_Ether';
$P = 'Packet_IPv6';
$E = 'Hdr_ESP.Decrypted.ESPPayload';
$X = 'Hdr_ESP.Decrypted.ESPPayload.Payload.data';
$Y = 'Hdr_ESP.Crypted';

%name_head_hash = (
	'icmp6_du'    => 'ICMPv6_DestinationUnreachable', # ICMP   1
	'icmp6_pp'    => 'ICMPv6_ParameterProblem',       # ICMP   4
	'echorequest' => 'ICMPv6_EchoRequest',            # ICMP 128
	'echoreply'   => 'ICMPv6_EchoReply',              # ICMP 129
	'mldreport'   => 'ICMPv6_MLDReport',              # ICMP 131
	'rs'          => 'ICMPv6_RS',                     # ICMP 133
	'ra'          => 'ICMPv6_RA',                     # ICMP 134
	'ns'          => 'ICMPv6_NS',                     # ICMP 135
	'na'          => 'ICMPv6_NA',                     # ICMP 136
	'redirect'    => 'ICMPv6_Redirect',               # ICMP 137
	'mld2report'  => 'ICMPv6_MLDv2Report',            # ICMP 143
	'haadrequest' => 'ICMPv6_HAADRequest',            # ICMP 144
	'haadreply'   => 'ICMPv6_HAADReply',              # ICMP 145
	'mps'         => 'ICMPv6_MobilePrefixSol',        # ICMP 146
	'mpa'         => 'ICMPv6_MobilePrefixAdvertise',  # ICMP 147
	'brr'         => 'Hdr_MH_BRR',                    # MH     0
	'hoti'        => 'Hdr_MH_HoTI',                   # MH     1
	'coti'        => 'Hdr_MH_CoTI',                   # MH     2
	'hot'         => 'Hdr_MH_HoT',                    # MH     3
	'cot'         => 'Hdr_MH_CoT',                    # MH     4
	'bu'          => 'Hdr_MH_BU',                     # MH     5
	'bu_cn'       => 'Hdr_MH_BU',                     # MH     5
	'ba'          => 'Hdr_MH_BA',                     # MH     6
	'ba_cn'       => 'Hdr_MH_BA',                     # MH     6
	'be'          => 'Hdr_MH_BE',                     # MH     7
);

%name_check_hash = (
	'icmp6_du'    => '1',
	'icmp6_pp'    => '1',
	'echorequest' => '1',
	'echoreply'   => '1',
	'mldreport'   => '0',
	'rs'          => '0',
	'ra'          => '1',
	'ns'          => '0',
	'na'          => '0',
	'redirect'    => '1',
	'mld2report'  => '0',
	'haadrequest' => '1',
	'haadreply'   => '1',
	'mps'         => '1',
	'mpa'         => '1',
	'brr'         => '1',
	'hoti'        => '1',
	'coti'        => '1',
	'hot'         => '1',
	'cot'         => '1',
	'bu'          => '1',
	'bu_cn'       => '1',
	'ba'          => '1',
	'ba_cn'       => '1',
	'be'          => '1',
);

%ipsec_frame = (
	'1' => '.Hdr_ESP.Decrypted.ESPPayload',
);

%name_field_hash = (
	'icmp6_du'    => 'icmp6_du_field',
	'icmp6_pp'    => 'icmp6_pp_field',
	'echorequest' => 'echorequest_field',
	'echoreply'   => 'echoreply_field',
	'rs'          => 'rs_field',
	'ra'          => 'ra_field',
	'ns'          => 'ns_field',
	'na'          => 'na_field',
	'haadrequest' => 'haadrequest_field',
	'haadreply'   => 'haadreply_field',
	'mps'         => 'mps_field',
	'mpa'         => 'mpa_field',
	'brr'         => 'brr_field',
	'hoti'        => 'hoti_field',
	'coti'        => 'coti_field',
	'hot'         => 'hot_field',
	'cot'         => 'cot_field',
	'bu'          => 'bu_field',
	'bu_cn'       => 'bu_cn_field',
	'ba'          => 'ba_field',
	'ba_cn'       => 'ba_cn_field',
	'be'          => 'be_field',
);

@icmp6_du_field = (
	'Code',
);

@icmp6_pp_field = (
	'Code',
	'Pointer',
);

@echorequest_field = (
	'Identifier',
	'SequenceNumber',
);

@echoreply_field = (
	'Identifier',
	'SequenceNumber',
);

@rs_field = (
	# none
);

@ra_field = (
	'HFlag',
	'LifeTime',
	'Opt_ICMPv6_Prefix.RFlag',
	'Opt_ICMPv6_Prefix.ValidLifetime',
	'Opt_ICMPv6_Prefix.PreferredLifetime',
);

@ns_field = (
	'Code',
	'TargetAddress',
);

@na_field = (
	'Code',
	'RFlag',
	'SFlag',
	'OFlag',
	'TargetAddress',
	'Opt_ICMPv6_TLL.LinkLayerAddress',
);

@haadrequest_field = (
	'Identifier',
);

@haadreply_field = (
	'Identifier',
	'Address',
);

@mps_field = (
	'Identifier',
);

@mpa_field = (
	'Identifier',
	'MFlag',
	'OFlag',
	'ValidLifetime',
	'PreferredLifetime',
);

@brr_field = (
	# none
);

@hoti_field = (
	'InitCookie',
);

@coti_field = (
	'InitCookie',
);

@hot_field = (
	'Index',
	'InitCookie',
	'KeygenToken',
);

@cot_field = (
	'Index',
	'InitCookie',
	'KeygenToken',
);

@bu_field = (
	'SequenceNumber',
	'AFlag',
	'HFlag',
	'LFlag',
	'KFlag',
	'Lifetime',
);

@bu_cn_field = (
	'SequenceNumber',
	'AFlag',
	'HFlag',
	'LFlag',
	'KFlag',
	'Lifetime',
	'Opt_MH_NonceIndices.HoNonceIndex',
	'Opt_MH_NonceIndices.CoNonceIndex',
	'Opt_MH_BindingAuthData.Authenticator',
#	'Opt_MH_AlternateCoA.Address'
);

@ba_field = (
	'Status',
	'KFlag',
	'SequenceNumber',
	'Lifetime',
	'Opt_MH_BindingRefreshAdvice.Interval',
);

@ba_cn_field = (
	'Status',
	'KFlag',
	'SequenceNumber',
	'Lifetime',
	'Opt_MH_BindingAuthData.Authenticator',
);

@be_field = (
	'Status',
	'Address',
);

# SUBROUTINE DECLARATION
sub set_frames();
sub get_value_of_packet($$$@);
sub get_value_of_packet_by_name($$$@);
sub get_value_of_unexpect($$);
sub get_name_of_unexpect($$);
sub get_strange_unexpect($$);
sub get_value_of_icmp6_du($$@);
sub get_value_of_icmp6_pp($$@);
sub get_value_of_echorequest($$@);
sub get_value_of_echoreply($$@);
sub get_value_of_rs($$@);
sub get_value_of_ra($$@);
sub get_value_of_ns($$@);
sub get_value_of_na($$@);
sub get_value_of_haadrequest($$@);
sub get_value_of_haadreply($$@);
sub get_value_of_mps($$@);
sub get_value_of_mpa($$@);
sub get_value_of_brr($$@);
sub get_value_of_hoti($$@);
sub get_value_of_coti($$@);
sub get_value_of_hot($$@);
sub get_value_of_cot($$@);
sub get_value_of_bu($$@);
sub get_value_of_bu_cn($$@);
sub get_value_of_ba($$@);
sub get_value_of_ba_cn($$@);
sub get_value_of_be($$@);
sub get_value_of_ipv6($$);


# SUBROUTINE
#-----------------------------------------------------------------------------#
# set_frames()
#
# <out> @frames_known, @frames_ilesp
#-----------------------------------------------------------------------------#
sub set_frames() {
	@frames_known = ();
	@frames_ilesp = ();

	# transport
	push @frames_known, "$F.$P";
	push @frames_known, "$F.$P.$E";
	# tunnel
	push @frames_known, "$F.$P.$P";
	push @frames_known, "$F.$P.$P.$E";
	push @frames_known, "$F.$P.$E.$P";
	push @frames_known, "$F.$P.$E.$P.$E";

	# transport
	push @frames_ilesp, "$F.$P";
	# tunnel
	push @frames_ilesp, "$F.$P.$P";
	push @frames_ilesp, "$F.$P.$E.$P";

	return;
}

#-----------------------------------------------------------------------------#
# get_value_of_packet($$$@)
#
# <in>  $display: 
#       $packet : packet hash (= return value of vSend()/vRecv())
#       $frame  : frame name
#       @field  : field names
#
# <out> %field_value: field value hash
#-----------------------------------------------------------------------------#
sub get_value_of_packet($$$@) {
	($display, $packet, $frame, @field) = @_;
	my $full;
	my %field_value;

	# check $packet by $frame
	while (1) {
		# IPv6.X
		$full = "$ipv6_frame.$frame";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.ESP.X
		$full = "$ipv6_frame.Hdr_ESP.Decrypted.ESPPayload.$frame";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.IPv6.X
		$full = "$ipv6_frame.Packet_IPv6.$frame";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.ESP.IPv6.X
		$full = "$ipv6_frame.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.$frame";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.IPv6.ESP.X
		$full = "$ipv6_frame.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.$frame";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.ESP.IPv6.ESP.X
		$full = "$ipv6_frame.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.$frame";
		if (defined($$packet{"$full"})) {
			last;
		}

		# It deals with the change of MH type.
		# IPv6.Hdr_MH_ANY
		$full = "$ipv6_frame.Hdr_MH_ANY";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.ESP.Hdr_MH_ANY
		$full = "$ipv6_frame.Hdr_ESP.Decrypted.ESPPayload.Hdr_MH_ANY";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.IPv6.Hdr_MH_ANY
		$full = "$ipv6_frame.Packet_IPv6.Hdr_MH_ANY";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.ESP.IPv6.Hdr_MH_ANY
		$full = "$ipv6_frame.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_MH_ANY";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.IPv6.ESP.Hdr_MH_ANY
		$full = "$ipv6_frame.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Hdr_MH_ANY";
		if (defined($$packet{"$full"})) {
			last;
		}
		# IPv6.ESP.IPv6.ESP.Hdr_MH_ANY
		$full = "$ipv6_frame.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Hdr_MH_ANY";
		if (defined($$packet{"$full"})) {
			last;
		}

		mip6_mn_common::vLogHTML_Fail("    packet does not contain the $frame.");
		exit $V6evalTool::exitFatal;
	}

	# get value of $packet by @field
	foreach $_ (@field) {
#		if ($MN_CONF{ENV_DEBUG} > 0) {
#			print "        $full.$_\n";
#		}
		$field_value{$_} = $$packet{"$full.$_"};
#		if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#			vLogHTML_Info("        $_ = $field_value{$_}");
#		}
	}

	return (%field_value);
}

#-----------------------------------------------------------------------------#
# get_value_of_packet_by_name($$$@)
#
# <in>  $display  : 
#       $packet   : packet hash (= return value of vSend()/vRecv())
#       $kind_name: packet name
#       @field    : field names
#
# <out> %field_value: field hash
#-----------------------------------------------------------------------------#
sub get_value_of_packet_by_name($$$@) {
	my ($display, $packet, $kind_name, @field) = @_;

	# get frame by $kind_name
	my $frame = $name_head_hash{"$kind_name"};
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		if (!(defined("$frame"))) {
#			vLogHTML_Fail("    $kind_name is unknown.");
#			exit $V6evalTool::exitFatal;
#		}
#	}

	# get value of $packet by default field + @field
	@field = (@{$name_field_hash{$kind_name}}, @field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# get_value_of_unexpect($$)
#
# <in>  $display: 
#       $packet : packet hash (= return value of vSend()/vRecv())
#
# <out> $rtn        : (=0) OK / (=1) FAIL
#       %field_value: field hash
#-----------------------------------------------------------------------------#
sub get_value_of_unexpect($$) {
	my ($display, $packet) = @_;

	# get name by $packet
	my ($rtn, $kind_name, $frame) = get_name_of_unexpect($display, $packet);
	if ($rtn != 0) {
		# $packet is unknown
		return (1, 0);
	}

	# get value of $packet by default @field
	my @field = @{$name_field_hash{$kind_name}};
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);

	return (0, %field_value);
}

#-----------------------------------------------------------------------------#
# sub get_name_of_unexpect($$)
#
# <in>  $display: 
#       $packet : packet hash (= return value of vSend()/vRecv())
#
# <out> $rtn      : (=0) OK / (=1) FAIL
#       $kind_name: packet name
#       $frame    : packet frame
#-----------------------------------------------------------------------------#
sub get_name_of_unexpect($$) {
	my ($display, $packet) = @_;
	my $frame1;
	my $frame2;

	# seach name of $packet
	my %frame_hash = %name_head_hash;
	while (my ($kind_name, $frame) = each(%frame_hash)) {
		if ($kind_name eq "bu_cn") {
			next;
		}
		# check $packet by frame
		$frame1 = "$ipv6_frame.$frame";
		$frame2 = "$ipv6_frame.Hdr_ESP.Decrypted.ESPPayload.$frame";
		$frame3 = "$ipv6_frame.Packet_IPv6.$frame";
		$frame4 = "$ipv6_frame.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.$frame";
		$frame5 = "$ipv6_frame.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.$frame";
		$frame6 = "$ipv6_frame.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.$frame";
		if ((defined($$packet{"$frame1"})) ||
		    (defined($$packet{"$frame2"})) ||
		    (defined($$packet{"$frame3"})) ||
		    (defined($$packet{"$frame4"})) ||
		    (defined($$packet{"$frame5"})) ||
		    (defined($$packet{"$frame6"}))) {
			# BINGO !!
#			if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#				vLogHTML_Info("    packet is $kind_name.");
#			}
			return (0, $kind_name, $frame);
		}
	}

	# $packet is unknown
#	if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#		vLogHTML_Info("    packet is unknown.");
#	}
	return (1, 0, 0);
}

#-----------------------------------------------------------------------------#
# sub get_strange_unexpect($$)
#
# <in>  $display: 
#       $packet : packet hash (= return value of vSend()/vRecv())
#
# <out> $rtn      : (=0) none / (=1) find
#       $kind_name: packet name
#-----------------------------------------------------------------------------#
sub get_strange_unexpect($$) {
	my ($display, $packet) = @_;

	my %tmp_name_head_hash = ();
	my @tmp_frames = ();
	my $kind_name;
	my $head;
	my $frame;

#	print "Frame = $$packet{'recvFrame'}\n";

	# seach name of $packet
	%tmp_name_head_hash = %name_head_hash;
	while (($kind_name, $head) = each(%tmp_name_head_hash)) {

		@tmp_frames = @frames_known;
		foreach $frame (@tmp_frames) {

			if (defined($$packet{"$frame.$head"})) {
				# BINGO !!
				if ($name_check_hash{$kind_name}) {
					return (1, $kind_name);
				}
				else {
					return (0, $kind_name);
				}
			}
		}
	}

	# seach il-esp of $packet
	@tmp_frames = @frames_ilesp;
	foreach $frame (@tmp_frames) {

		if (defined($$packet{"$frame.$X"})) {
			return (1, 'decryption and unknown');
		}
		if (defined($$packet{"$frame.$Y"})) {
			return (1, 'un decryption');
		}
	}

	return (0, 'unknown');
}

#-----------------------------------------------------------------------------#
# ICMPv6 Destination Unreachable
#
# <in>  $display: 
#       $packet : packet hash (= return value of vSend()/vRecv())
#       @field  : field names
#
# <out> %field_value: field hash
#-----------------------------------------------------------------------------#
sub get_value_of_icmp6_du($$@) {
	my ($display, $packet, @field) = @_;

	# set $frame
	my $frame = "$name_head_hash{'icmp6_du'}";
	# set @field
	unshift(@field, @icmp6_du_field);
	# get value of $packet by @field
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# ICMPv6 Parameter Problem
#-----------------------------------------------------------------------------#
sub get_value_of_icmp6_pp($$@) {
	my ($display, $packet, @field) = @_;

	# set $frame
	my $frame = "$name_head_hash{'icmp6_pp'}";
	# set @field
	unshift(@field, @icmp6_pp_field);
	# get value of $packet by @field
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Echo Request
#-----------------------------------------------------------------------------#
sub get_value_of_echorequest($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'echorequest'}";
	unshift(@field, @echorequest_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Echo Reply
#-----------------------------------------------------------------------------#
sub get_value_of_echoreply($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'echoreply'}";
	unshift(@field, @echoreply_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Router Solicitation
#-----------------------------------------------------------------------------#
sub get_value_of_rs($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'rs'}";
	unshift(@field, @rs_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Router Advertisement
#-----------------------------------------------------------------------------#
sub get_value_of_ra($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'ra'}";
	unshift(@field, @ra_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Neighbor Solicitation
#-----------------------------------------------------------------------------#
sub get_value_of_ns($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'ns'}";
	unshift(@field, @ns_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Neighbor Advertisement
#-----------------------------------------------------------------------------#
sub get_value_of_na($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'na'}";
	unshift(@field, @na_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Home Agent Address Discovery Request
#-----------------------------------------------------------------------------#
sub get_value_of_haadrequest($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'haadrequest'}";
	unshift(@field, @haadrequest_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Home Agent Address Discovery Reply
#-----------------------------------------------------------------------------#
sub get_value_of_haadreply($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'haadreply'}";
	unshift(@field, @haadreply_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Mobile Prefix Solicitation
#-----------------------------------------------------------------------------#
sub get_value_of_mps($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'mps'}";
	unshift(@field, @mps_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Mobile Prefix Advertisement
#-----------------------------------------------------------------------------#
sub get_value_of_mpa($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'mpa'}";
	unshift(@field, @mpa_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Binding Refresh Request
#-----------------------------------------------------------------------------#
sub get_value_of_brr($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'brr'}";
	unshift(@field, @brr_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Home Test Init
#-----------------------------------------------------------------------------#
sub get_value_of_hoti($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'hoti'}";
	unshift(@field, @hoti_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Care-of Test Init
#-----------------------------------------------------------------------------#
sub get_value_of_coti($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'coti'}";
	unshift(@field, @coti_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Home Test
#-----------------------------------------------------------------------------#
sub get_value_of_hot($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'hot'}";
	unshift(@field, @hot_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Care-of Test
#-----------------------------------------------------------------------------#
sub get_value_of_cot($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'cot'}";
	unshift(@field, @cot_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Binding Update
#-----------------------------------------------------------------------------#
sub get_value_of_bu($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'bu'}";
	unshift(@field, @bu_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Binding Update to CN
#-----------------------------------------------------------------------------#
sub get_value_of_bu_cn($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'bu_cn'}";
	unshift(@field, @bu_cn_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Binding Acknowledgement
#-----------------------------------------------------------------------------#
sub get_value_of_ba($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'ba'}";
	unshift(@field, @ba_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Binding Acknowledgement (CN)
#-----------------------------------------------------------------------------#
sub get_value_of_ba_cn($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'ba_cn'}";
	unshift(@field, @ba_cn_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# Binding Error
#-----------------------------------------------------------------------------#
sub get_value_of_be($$@) {
	my ($display, $packet, @field) = @_;

	my $frame = "$name_head_hash{'be'}";
	unshift(@field, @be_field);
	my %field_value = get_value_of_packet($display, $packet, $frame, @field);
	return (%field_value);
}

#-----------------------------------------------------------------------------#
# IPv6 Header, Destination Header, Routing Header
# <in>  $display: 
#       $packet : packet hash (= return value of vSend()/vRecv())
#
# <out> %field_value: field hash
#-----------------------------------------------------------------------------#
sub get_value_of_ipv6($$) {
	my ($display, $packet) = @_;
	my %field_value;

	$field_value{SourceAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
	$field_value{DestinationAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
#	if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#		vLogHTML_Info("        SourceAddress = $field_value{SourceAddress}");
#		vLogHTML_Info("        DestinationAddress = $field_value{DestinationAddress}");
#	}

	if (defined($$packet{'Frame_Ether.Packet_IPv6.Packet_IPv6.Hdr_IPv6'})) {

		$field_value{inner_SourceAddress} = 
			$$packet{'Frame_Ether.Packet_IPv6.Packet_IPv6.Hdr_IPv6.SourceAddress'};
		$field_value{inner_DestinationAddress} =
			$$packet{'Frame_Ether.Packet_IPv6.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
#		if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#			vLogHTML_Info("        inner_SourceAddress = $field_value{inner_SourceAddress}");
#			vLogHTML_Info("        inner_DestinationAddress = $field_value{inner_DestinationAddress}");
#		}

		if (defined($$packet{'Frame_Ether.Packet_IPv6.Packet_IPv6.Hdr_Destination'})) {
			$field_value{Destination_HomeAddress} = 
				$$packet{'Frame_Ether.Packet_IPv6.Packet_IPv6.Hdr_Destination.Opt_HomeAddress.HomeAddress'};
#			if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#				vLogHTML_Info("        inner_HomeAddressOption = $field_value{Destination_HomeAddress}");
#			}
		}

		if (defined($$packet{'Frame_Ether.Packet_IPv6.Packet_IPv6.Hdr_Routing'})) {
			$field_value{Routing_Address} = 
				$$packet{'Frame_Ether.Packet_IPv6.Packet_IPv6.Hdr_Routing.Address'};
#			if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#				vLogHTML_Info("        inner_RoutingAddress = $field_value{Routing_Address}");
#			}
		}
	}
	elsif (defined($$packet{'Frame_Ether.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_IPv6'})) {

		$field_value{inner_SourceAddress} =
			$$packet{'Frame_Ether.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_IPv6.SourceAddress'};
		$field_value{inner_DestinationAddress} =
			$$packet{'Frame_Ether.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
#		if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#			vLogHTML_Info("        inner_SourceAddress = $field_value{inner_SourceAddress}");
#			vLogHTML_Info("        inner_DestinationAddress = $field_value{inner_DestinationAddress}");
#		}

		if (defined($$packet{'Frame_Ether.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_Destination'})) {
			$field_value{Destination_HomeAddress} = 
				$$packet{'Frame_Ether.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_Destination.Opt_HomeAddress.HomeAddress'};
#			if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#				vLogHTML_Info("        inner_HomeAddressOption = $field_value{Destination_HomeAddress}");
#			}
		}

		if (defined($$packet{'Frame_Ether.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_Routing'})) {
			$field_value{Routing_Address} = 
				$$packet{'Frame_Ether.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Packet_IPv6.Hdr_Routing.Address'};
#			if (($MN_CONF{ENV_DEBUG} > 0) || ($display == 1)) {
#				vLogHTML_Info("        inner_RoutingAddress = $field_value{Routing_Address}");
#			}
		}
	}
	else {

		if (defined($$packet{'Frame_Ether.Packet_IPv6.Hdr_Destination'})) {
			$field_value{Destination_HomeAddress} = 
				$$packet{'Frame_Ether.Packet_IPv6.Hdr_Destination.Opt_HomeAddress.HomeAddress'};
		}

		if (defined($$packet{'Frame_Ether.Packet_IPv6.Hdr_Routing'})) {
			$field_value{Routing_Address} = 
				$$packet{'Frame_Ether.Packet_IPv6.Hdr_Routing.Address'};
		}

	}

	return (%field_value);
}

# End of File
1;
