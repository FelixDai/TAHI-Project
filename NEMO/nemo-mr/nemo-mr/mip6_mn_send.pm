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
package mip6_mn_send;

# EXPORT PACKAGE
use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	%SEND_PACKET_ICMP_DU
	%SEND_PACKET_ICMP_PP
	%SEND_PACKET_ECHOREQUEST
	%SEND_PACKET_RA
	%SEND_PACKET_RA_LINK0
	%SEND_PACKET_RA_LINKX
	%SEND_PACKET_RA_LINKY
	%SEND_PACKET_NS
	%SEND_PACKET_NA
	%SEND_PACKET_HAADREPLY
	%SEND_PACKET_MPA
	%SEND_PACKET_BRR
	%SEND_PACKET_HOTI
	%SEND_PACKET_COTI
	%SEND_PACKET_HOT
	%SEND_PACKET_COT
	%SEND_PACKET_BA
	%SEND_PACKET_BA_CN
	%SEND_PACKET_BE
	@HAADREP_VALUE
	@HA_BA_VALUE
	$HA_BA_LIFETIME
	$HA_BA_135_AUTO
	$CN_BA_135_AUTO
	vSend_packet
	vSend_noreply
	vSend_icmp6_du
	vSend_icmp6_pp
	vSend_echorequest
	vSend_echoreply
	vSend_rs
	vSend_ra
	vSend_ns
	vSend_na
	vSend_haadreply
	vSend_mpa
	vSend_brr
	vSend_hoti
	vSend_coti
	vSend_hot
	vSend_cot
	vSend_bu_cn
	vSend_ba
	vSend_ba_cn
	vSend_be
);

# INPORT PACKAGE
use V6evalTool;
use IKEapi;
use mip6_mn_config;
use mip6_mn_get;
use mip6_mn_ike;
use mip6_mn_common;


# GLOBAL VARIABLE DEFINITION
%SEND_PACKET_ICMP_PP     = ();
%SEND_PACKET_ICMP_DU     = ();
%SEND_PACKET_ECHOREQUEST = ();
%SEND_PACKET_ECHOREPLY   = ();
%SEND_PACKET_RS          = ();
%SEND_PACKET_RA          = ();
%SEND_PACKET_RA_LINK0    = ();
%SEND_PACKET_RA_LINKX    = ();
%SEND_PACKET_RA_LINKY    = ();
%SEND_PACKET_NS          = ();
%SEND_PACKET_NA          = ();
%SEND_PACKET_HAADREPLY   = ();
%SEND_PACKET_MPA         = ();
%SEND_PACKET_BRR         = ();
%SEND_PACKET_HOTI        = ();
%SEND_PACKET_COTI        = ();
%SEND_PACKET_HOT         = ();
%SEND_PACKET_COT         = ();
%SEND_PACKET_BA          = ();
%SEND_PACKET_BA_CN       = ();
%SEND_PACKET_BE          = ();

@HA_BA_VALUE = ();
$HA_BA_LIFETIME = 0;
$HA_BA_135_AUTO = 0;
$CN_BA_135_AUTO = 0;

# LOCAL VARIABLE DEFINITION
%echorequest_echoreply_hash = (
	'Identifier'     => 'ECHO_IDENTIFIER',
	'SequenceNumber' => 'ECHO_SEQUENCE',
);

%haadrequest_haadreply_hash = (
	'Identifier' => 'HAADRep_Identifier',
	'RFlag'      => 'HAADRep_Rflag',
);

%mps_mpa_hash = (
	'Identifier' => 'MPA_Identifier'
);

%hoti_hot_hash = (
	'InitCookie' => 'HOT_HOTCOOKIE',
);

%coti_cot_hash = (
	'InitCookie' => 'COT_COTCOOKIE',
);

%bu_ba_hash = (
	'KFlag'          => 'BA_Kflag',
	'RFlag'          => 'BA_Rflag',
	'SequenceNumber' => 'BA_Sequence',
	'Lifetime'       => 'BA_Lifetime',
);

%bu_ba_cn_hash = (
	'KFlag'                            => 'BA_Kflag',
	'RFlag'                            => 'BA_Rflag',
	'SequenceNumber'                   => 'BA_Sequence',
	'Lifetime'                         => 'BA_Lifetime',
	'Opt_MH_NonceIndices.HoNonceIndex' => 'HOT_NONCE_INDEX',
	'Opt_MH_NonceIndices.CoNonceIndex' => 'COT_NONCE_INDEX',
	# HOCOOKIE                   : keygentoken(hexstr(KCN), v6(NUTH_GLOBAL_UCAST), hexstr(HOT_NONCE), 0)
	# COCOOKIE                   : keygentoken(hexstr(KCN), v6(NUTX_GLOBAL_UCAST), hexstr(COT_NONCE), 1)
	# BA_AUTHENTICATOR_TN_TO_NUTX: bsa(kbm(HOCOOKIE, COCOOKIE), v6(NUTX_GLOBAL_UCAST), v6(TN_GLOBAL_UCAST))
);

%bu_be_hash = (
	'Destination_HomeAddress' => 'BE_Addr',
);

# SUBROUTINE DECLARATION
sub vSend_packet($$@);
sub vSend_noreply($$$@);
sub vSend_icmp6_du($$$@);
sub vSend_icmp6_pp($$$@);
sub vSend_echorequest($$$@);
sub vSend_echoreply($$$@);
sub vSend_rs($$$@);
sub vSend_ra($$$@);
sub vSend_ns($$$@);
sub vSend_na($$$@);
sub vSend_haadreply($$$@);
sub vSend_mpa($$$@);
sub vSend_brr($$$@);
sub vSend_hoti($$$@);
sub vSend_coti($$$@);
sub vSend_hot($$$@);
sub vSend_cot($$$@);
sub vSend_bu_cn($$$@);
sub vSend_ba($$$@);
sub vSend_ba_cn($$$@);
sub vSend_be($$$@);


# SUBROUTINE
#-----------------------------------------------------------------------------#
# vSend_packet($$@)
#
# <in>  $if         : interface name
#       $packet_name: packet name
#       @send_value : (= %send_value = ($vabliable => $value))
#
# <out> %send_packet: packet hash (= return value of vSend())
#-----------------------------------------------------------------------------#
sub vSend_packet($$@) {
	my ($if, $packet_name, @send_value) = @_;
	my %send_value = @send_value;

	# set value 
	my $cpp = '';
	while (my ($variable, $value) = each(%send_value)) {
#		if ($MN_CONF{ENV_DEBUG} > 1) {
#			print "        -D$variable=$value\n"
#		}
		$cpp .= "-D$variable=$value ";
	}
	VCppApply($cpp, '', '', 'force');

	my %send_packet = vSend2($if, $packet_name);
	return (%send_packet);
}

#-----------------------------------------------------------------------------#
# vSend_noreply
#
# <in>  $if            : interface name
#       $packet_name   : packet name
#       $src_packet    : packet hash (= return value of vRecv())
#       @variable_value: (= %variable_value = ($vabliable => $value))
#
# <out> %send_packet: packet hash (= return value of vSend())
#-----------------------------------------------------------------------------#
sub vSend_noreply($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my %send_packet = ('status', 2);

	vLogHTML_Info("    no reply");
	return (%send_packet);
}

#-----------------------------------------------------------------------------#
# ICMPv6 Destination Unreachable
#-----------------------------------------------------------------------------#
sub vSend_icmp6_du($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my @send_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();
	@send_value = ('ESP_SEQ', $esp_sequence);

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_ICMP_DU = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_icmp6_du(1, \%SEND_PACKET_ICMP_DU);
#	}
	return (%SEND_PACKET_ICMP_DU);
}

#-----------------------------------------------------------------------------#
# ICMPv6 Parameter Problem
#-----------------------------------------------------------------------------#
sub vSend_icmp6_pp($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my @send_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();
	@send_value = ('ESP_SEQ', $esp_sequence);

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_ICMP_PP = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_icmp6_pp(1, \%SEND_PACKET_ICMP_PP);
#	}
	return (%SEND_PACKET_ICMP_PP);
}

#-----------------------------------------------------------------------------#
# Echo Request
#-----------------------------------------------------------------------------#
sub vSend_echorequest($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my $echo_identifier;
	my $echo_sequence;
	my @send_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();

	# ECHO request
	$echo_identifier = get_new_echo_identifier();
	$echo_sequence = get_new_echo_sequence();
	@send_value = (
		'ESP_SEQ',         $esp_sequence,
		'ECHO_IDENTIFIER', $echo_identifier,
		'ECHO_SEQUENCE',   $echo_sequence);

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_ECHOREQUEST = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_echorequest(1, \%SEND_PACKET_ECHOREQUEST);
#	}
	return (%SEND_PACKET_ECHOREQUEST);
}

#-----------------------------------------------------------------------------#
# Echo Request
#-----------------------------------------------------------------------------#
sub vSend_echoreply($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my @send_value;
	my %src_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();
	$echo_identifier = get_new_echo_identifier();
	$echo_sequence = get_new_echo_sequence();
	@send_value = (
		'ESP_SEQ',         $esp_sequence,
		'ECHO_IDENTIFIER', $echo_identifier,
		'ECHO_SEQUENCE',   $echo_sequence);

	# ECHO reply
	if ($src_packet != 0) {
		%src_value = get_value_of_echorequest(0, $src_packet);
		while (my ($field, $variable) = each(%echorequest_echoreply_hash)) {
			push(@send_value, $variable, $src_value{$field});
		}
	}

	# input
	push(@send_value, @variable_value);

	# send packet
	%SEND_PACKET_ECHOREPLY = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_echoreply(1, \%SEND_PACKET_ECHOREPLY);
#	}
	return (%SEND_PACKET_ECHOREPLY);
}

#-----------------------------------------------------------------------------#
# Router Solicitation
#-----------------------------------------------------------------------------#
sub vSend_rs($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;

	%SEND_PACKET_RS = vSend_packet($if, $packet_name, @variable_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_rs(1, \%SEND_PACKET_RS);
#	}
	return (%SEND_PACKET_RS);
}

#-----------------------------------------------------------------------------#
# Router Advertisement
#-----------------------------------------------------------------------------#
sub vSend_ra($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my @send_value;

	# Prefix Lifetime
	$now_time = time;
	$vld = int(${"st_$NOW_Link"}{ValidLifetime} - $now_time);
	$pre = int(${"st_$NOW_Link"}{PreferredLifetime} - $now_time);
	if ($vld <= 0) {$vld = 1};
	if ($pre <= 0) {$pre = 1};
	@send_value = (
		"PREINFO_VLD_Lifetime", $vld,
		"PREINFO_PRE_Lifetime", $pre);

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_RA = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_ra(1, \%SEND_PACKET_RA);
#	}
	return (%SEND_PACKET_RA);
}

#-----------------------------------------------------------------------------#
# Neighbor Solicitation
#-----------------------------------------------------------------------------#
sub vSend_ns($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;

	%SEND_PACKET_NS = vSend_packet($if, $packet_name, @variable_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_ns(1, \%SEND_PACKET_NS);
#	}
	return (%SEND_PACKET_NS);
}

#-----------------------------------------------------------------------------#
# Neighbor Advertisement
#-----------------------------------------------------------------------------#
sub vSend_na($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;

	%SEND_PACKET_NA = vSend_packet($if, $packet_name, @variable_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_na(1, \%SEND_PACKET_NA);
#	}
	return (%SEND_PACKET_NA);
}

#-----------------------------------------------------------------------------#
# vSend_haadreply($$$@)
#-----------------------------------------------------------------------------#
sub vSend_haadreply($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my @send_value;
	my %src_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();
	@send_value = ('ESP_SEQ', $esp_sequence);

	# HAAD reply
	if ($src_packet != 0) {
		%src_value = get_value_of_haadrequest(0, $src_packet);
		while (my ($field, $variable) = each(%haadrequest_haadreply_hash)) {
			push(@send_value, $variable, $src_value{$field});
		}
	}

	# input global
	push(@send_value, @HAADREP_VALUE);

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_HAADREPLY = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_haadreply(1, \%SEND_PACKET_HAADREPLY);
#	}
	return (%SEND_PACKET_HAADREPLY);
}

#-----------------------------------------------------------------------------#
# Mobile Prefix Advertisement
#-----------------------------------------------------------------------------#
sub vSend_mpa($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my @send_value;
	my %src_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();
	@send_value = ('ESP_SEQ', $esp_sequence);

	# MPS
	if ($src_packet != 0) {
		%src_value = get_value_of_mps(0, $src_packet);
		while (my ($field, $variable) = each(%mps_mpa_hash)) {
			push(@send_value, $variable, $src_value{$field});
		}
	}

	# Prefix Lifetime
	$now_time = time;
	$vld = int($st_Link0{ValidLifetime} - $now_time);
	$pre = int($st_Link0{PreferredLifetime} - $now_time);
	if ($vld <= 0) {$vld = 1};
	if ($pre <= 0) {$pre = 1};
	push(@send_value, 'PREINFO_MPA_VLD_Lifetime', $vld);
	push(@send_value, 'PREINFO_MPA_PRE_Lifetime', $pre);

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_MPA = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_mpa(1, \%SEND_PACKET_MPA);
#	}
	return (%SEND_PACKET_MPA);
}

#-----------------------------------------------------------------------------#
# Binding Refresh Request
#-----------------------------------------------------------------------------#
sub vSend_brr($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my @send_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();
	@send_value = ('ESP_SEQ', $esp_sequence);

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_BRR = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_brr(1, \%SEND_PACKET_BRR);
#	}
	return (%SEND_PACKET_BRR);
}

#-----------------------------------------------------------------------------#
# Home Test Init (send to MN)
#-----------------------------------------------------------------------------#
sub vSend_hoti($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my $hoti_cookie;
	my @send_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();

	# Cookie
	$hoti_cookie = get_new_hoti_cookie();
	@send_value = ('ESP_SEQ', $esp_sequence, 'HOTI_HOTCOOKIE', "\\\"$hoti_cookie\\\"");

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_HOTI = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_hoti(1, \%SEND_PACKET_HOTI);
#	}
	return (%SEND_PACKET_HOTI);
}

#-----------------------------------------------------------------------------#
# Care-of Test Init (send to MN)
#-----------------------------------------------------------------------------#
sub vSend_coti($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my $coti_cookie;
	my @send_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();

	# Cookie
	$coti_cookie = get_new_coti_cookie();
	@send_value = ('ESP_SEQ', $esp_sequence, 'COTI_COTCOOKIE', "\\\"$coti_cookie\\\"");

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_COTI = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_coti(1, \%SEND_PACKET_COTI);
#	}
	return (%SEND_PACKET_COTI);
}

#-----------------------------------------------------------------------------#
# Home Test
#-----------------------------------------------------------------------------#
sub vSend_hot($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my $hot_index;
	my @send_value;
	my %src_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();

	# Nonce
	$hot_index = get_new_hot_index();
	@send_value = (
		'ESP_SEQ',         $esp_sequence,
		'HOT_NONCE_INDEX', $hot_index);

	# HoTI
	if ($src_packet != 0) {
		%src_value = get_value_of_hoti(0, $src_packet);
		while (my ($field, $variable) = each(%hoti_hot_hash)) {
			if ($field eq 'InitCookie') {
				push(@send_value, $variable, "\\\"$src_value{$field}\\\"");
			}
			else {
				push(@send_value, $variable, $src_value{$field});
			}
		}
	}

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_HOT = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_hot(1, \%SEND_PACKET_HOT);
#	}
	return (%SEND_PACKET_HOT);
}

#-----------------------------------------------------------------------------#
# Care-of Test
#-----------------------------------------------------------------------------#
sub vSend_cot($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my $cot_index;
	my @send_value;
	my %src_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();

	# Nonce
	$cot_index = get_new_cot_index();
	@send_value = (
		'ESP_SEQ',         $esp_sequence,
		'COT_NONCE_INDEX', $cot_index);

	# CoTI
	if ($src_packet != 0) {
		%src_value = get_value_of_coti(0, $src_packet);
		while (my ($field, $variable) = each(%coti_cot_hash)) {
			if ($field eq 'InitCookie') {
				push(@send_value, $variable, "\\\"$src_value{$field}\\\"");
			}
			else {
				push(@send_value, $variable, $src_value{$field});
			}
		}
	}

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_COT = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_cot(1, \%SEND_PACKET_COT);
#	}
	return (%SEND_PACKET_COT);
}

#-----------------------------------------------------------------------------#
# Binding Update (send to MN(+CN))
#-----------------------------------------------------------------------------#
sub vSend_bu_cn($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my $bu_sequence;
	my @send_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();

	# Sequence
	$bu_sequence = get_new_bu_cn_sequence();
	@send_value = (
		'ESP_SEQ',    $esp_sequence,
		'BU_Seqence', $bu_sequence);

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_BU_CN = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_bu_cn(1, \%SEND_PACKET_BU_CN);
#	}
	return (%SEND_PACKET_BU_CN);
}

#-----------------------------------------------------------------------------#
# Binding Acknowledgement
#-----------------------------------------------------------------------------#
sub vSend_ba($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my @send_value;
	my %src_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();
	@send_value = ('ESP_SEQ', $esp_sequence);

	# BU
	if ($src_packet != 0) {
		%src_value = get_value_of_bu(0, $src_packet);
		while (my ($field, $variable) = each(%bu_ba_hash)) {
			push(@send_value, $variable, $src_value{$field});
		}
	}

	# input global
	push(@send_value, @HA_BA_VALUE);

	# Sequence#
	if ($HA_BA_135_AUTO == 1) {
		if ($src_packet != 0) {
			$seq = ($src_value{SequenceNumber} + (2 ** 15)) % (2 ** 16);
			push(@send_value, 'BA_Status', 135, 'BA_Sequence', $seq);
		}
	}

	# Prefix Lifetime
	$now_time = time;
	$ba_lifetime = int(($st_Link0{ValidLifetime} - $now_time) / 4);
	if ($ba_lifetime <= 0){
		vLogHTML("Don't send BA. Home Link was expired : Home Link Prefix Lifetime =$ba_lifetime<BR>");
		return;
	}
	if ($HA_BA_LIFETIME != 0) {
		if ($ba_lifetime > $HA_BA_LIFETIME) {
			$ba_lifetime = $HA_BA_LIFETIME;
		}
	}
	if ($src_packet != 0) {
		if ($ba_lifetime > $src_value{Lifetime}) {
			$ba_lifetime = $src_value{Lifetime};
		}
	}
	push(@send_value, 'BA_Lifetime', $ba_lifetime);

	# input local
	push(@send_value, @variable_value);

	%SEND_PACKET_BA = vSend_packet($if, $packet_name, @send_value);
	if ($MN_CONF{'TEST_FUNC_IKE'} eq 'YES') {
		chg_endpoint(\%SEND_PACKET_BA);
	}
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_ba(1, \%SEND_PACKET_BA);
#	}
	return (%SEND_PACKET_BA);
}

#-----------------------------------------------------------------------------#
# Binding Acknowledgement from CN
#-----------------------------------------------------------------------------#
sub vSend_ba_cn($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my %src_value;
	my @send_value;
	my $send_flag = 0;

	# ESP
	$esp_sequence = get_new_esp_sequence();
	@send_value = ('ESP_SEQ', $esp_sequence);

	# BU CN
	if ($src_packet != 0) {
		%src_value = get_value_of_bu_cn(0, $src_packet);
		while (my ($field, $variable) = each(%bu_ba_cn_hash)) {
			push(@send_value, $variable, $src_value{$field});
		}
		if ($src_value{'AFlag'} == 1) {
			$send_flag = 1;
		}
	}

	my %wk = @variable_value;
	if ($wk{'BA_AFlag'} == 1) {
		$send_flag = 1;
	}
	if ($send_flag == 0) {
		vSend_noreply($if, -1, -1);
		return;
	}

	# Sequence#
	if ($CN_BA_135_AUTO == 1) {
		if ($src_packet != 0) {
			$seq = ($src_value{SequenceNumber} + (2 ** 15)) % (2 ** 16);
			push(@send_value, 'BA_Status', 135, 'BA_Sequence', $seq);
		}
	}

	# Prefix Lifetime
	$now_time = time;
	$ba_lifetime = int(($st_LinkZ{ValidLifetime} - $now_time) / 4);
	if ($src_packet != 0) {
		if ($src_value{Lifetime} <= $ba_lifetime) {
			$ba_lifetime = $src_value{Lifetime};
		}
	}
	else {
		if ($ba_lifetime <= 0) {$ba_lifetime = 1};
	}
	push(@send_value, 'BA_Lifetime', $ba_lifetime);

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_BA_CN = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_ba(1, \%SEND_PACKET_BA_CN);
#	}
	return (%SEND_PACKET_BA_CN);
}

#-----------------------------------------------------------------------------#
# Binding Error
#-----------------------------------------------------------------------------#
sub vSend_be($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my $esp_sequence;
	my @send_value;
	my %src_value;

	# ESP
	$esp_sequence = get_new_esp_sequence();
	@send_value = ('ESP_SEQ', $esp_sequence);

	# SRC
	if ($src_packet != 0) {
		%src_value = get_value_of_ipv6(0, $src_packet);
		while (my ($field, $variable) = each(%bu_be_hash)) {
			if ($field eq 'Destination_HomeAddress') {
				push(@send_value, $variable, "\\\"$src_value{$field}\\\"");
			}
			else {
				push(@send_value, $variable, $src_value{$field});
			}
		}
	}

	# input
	push(@send_value, @variable_value);

	%SEND_PACKET_BE = vSend_packet($if, $packet_name, @send_value);
#	if ($MN_CONF{ENV_DEBUG} > 0) {
#		get_value_of_be(1, \%SEND_PACKET_BE);
#	}
	return (%SEND_PACKET_BE);
}

# End of File
1;
