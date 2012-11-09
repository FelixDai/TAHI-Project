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
package mip6_mn_neighbor;

# EXPORT PACKAGE
use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	$LINK0_RA_TYPE
	$HA1_STATE
	vReply_rs
	vReply_ra
	vReply_ns
	vReply_na
	vSend_ra2
	vSend_na2
	check_rs
	check_ra
	check_ns
	check_na
	set_ha1_is_rt
	unset_ha1_is_rt
	ha1_enable
	ha1_desable
);

# INPORT PACKAGE
use V6evalTool;
use IKEapi;
use mip6_mn_config;
use mip6_mn_get;
use mip6_mn_common;
use mip6_mn_send;

# GLOBAL VARIABLE DEFINITION
$LINK0_RA_TYPE = 'HA_RA';
$HA1_STATE = 'DISABLE';

# LOCAL VARIABLE DEFINITION

# SUBROUTINE DECLARATION
sub vReply_rs($$$@);
sub vReply_ra($$$@);
sub vReply_ns($$$@);
sub vReply_na($$$@);
sub vSend_ra2($$);
sub vSend_na2($$);
sub check_rs($$);
sub check_ra($$);
sub check_ns($$);
sub check_na($$);
sub set_ha1_is_rt();
sub unset_ha1_is_rt();
sub ha1_enable();
sub ha1_desable();

# SUBROUTINE
#-----------------------------------------------------------------------------#
# Router Solicitation
#-----------------------------------------------------------------------------#
sub vReply_rs($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my %send_packet;

	# check of RS packet
	if( check_rs(1, $src_packet) != 0 ) {
		vLogHTML_Info("    no-reply");
		%send_packet = ('status', 2);
		return (0);
	}

	# sending RA packet
	%send_packet = vSend_ra2($if, $src_packet);
	return (%send_packet);
}

#-----------------------------------------------------------------------------#
# Send Router Advertisement
#-----------------------------------------------------------------------------#
sub vSend_ra2($$) {
	my ($if, $src_packet) = @_;
	my %field_value;
	my $cpp = '';
	my $saddr = '';
	my $smac = '';
	my %send_packet = (
		'Link0' => 'ra_any_any_sll_any_mtu_pfx_any_hainfo',
		'LinkX' => 'ra_any_any_sll_any_mtu_pfx_any',
		'LinkY' => 'ra_any_any_sll_any_mtu_pfx_any',
		'LinkZ' => 'ra_any_any_sll_any_mtu_pfx_any_hainfo',
		'Link1' => 'ra_any_any_sll_any_mtu_pfx_any',
	);
	my %sender = (
		'Link0' => 'ha0_lla',
		'LinkX' => 'r1_lla',
		'LinkY' => 'r2_lla',
		'LinkZ' => 'ha3_lla',
		'Link1' => 'none',
	);
	my %h_flag = (
		'Link0' => '1',
		'LinkX' => '0',
		'LinkY' => '0',
		'LinkZ' => '1',
		'Link1' => '0',
	);
	my %link_prefix = (
		'Link0' => $LINK0_PREFIX,
		'LinkX' => $LINKX_PREFIX,
		'LinkY' => $LINKY_PREFIX,
		'LinkZ' => $LINKZ_PREFIX,
		'Link1' => $LINK1_PREFIX,
	);
	my %iid = (
		'Link0' => ':200:ff:fe00:a0a0',
		'LinkX' => '::',
		'LinkY' => '::',
		'LinkZ' => ':200:ff:fe00:aaaa',
		'Link1' => '::',
	);
	my %preinfo_r_flag = (
		'Link0' => '1',
		'LinkX' => '0',
		'LinkY' => '0',
		'LinkZ' => '1',
		'Link1' => '0',
	);
	my %hainfo_r_flag = (
		'Link0' => '1',
		'LinkX' => '0',
		'LinkY' => '0',
		'LinkZ' => '1',
		'Link1' => '0',
	);

	$msg_name = "Send    RA: ";

	$field_value{SourceAddress} = $$src_packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
	$field_value{DestinationAddress} = $$src_packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};

	$rs_dst_type = get_addrType( $field_value{'DestinationAddress'} );
	if ( ( $rs_dst_type eq 'all_rt_multi' ) ||
	     ( $rs_dst_type eq 'all_node_multi' ) ||
	     ( $CUR_Link ne 'Link0' ) ) {
		$saddr = get_addr( $sender{$CUR_Link} );
		%saddr_tbl = get_addr_tbl( $saddr );
		$smac = $saddr_tbl{'mac'};
	} else {
		%saddr_tbl = get_addr_tbl( $field_value{'DestinationAddress'} );
# RA source must be set lla
#		if ( $saddr_tbl{'addr_type'} eq 'ga' ) {
#			$saddr_type = sprintf "%s%s", $saddr_tbl{'node_name'}, "_ga";
#		}
#		else {
#			$saddr_type = sprintf "%s%s", $saddr_tbl{'node_name'}, "_lla";
#		}
		$saddr_type = sprintf "%s%s", $saddr_tbl{'node_name'}, "_lla";
		$saddr = get_addr($saddr_type);
		$smac  = $saddr_tbl{'mac'};
	}

	%daddr_tbl = get_addr_tbl( $field_value{'SourceAddress'} );
	if ( ( get_addrType( $field_value{'SourceAddress'} ) eq 'unspecified' ) ||
	     ( !( defined($daddr_tbl{'node_name'}) ) ) ) {
		$daddr = 'ff02::1';
		$dmac  = '33:33:00:00:00:01';
	} else {
		$daddr = $field_value{'SourceAddress'};
		$dmac  = $daddr_tbl{'mac'};
	}
	$prefix = sprintf "%s%s", $link_prefix{$CUR_Link}, $iid{$CUR_Link};

	# change of RA packet value
	$cpp .= "-DIP_SRC_ADDR_ANY=\\\"$saddr\\\" ";
	$cpp .= "-DIP_DEST_ADDR_ANY=\\\"$daddr\\\" ";
	$cpp .= "-DSRC_MAC_ANY=\\\"$smac\\\" ";
	$cpp .= "-DDEST_MAC_ANY=\\\"$dmac\\\" ";
	$now_time = time;
	$vld = int(${"st_$CUR_Link"}{ValidLifetime} - $now_time);
	$pre = int(${"st_$CUR_Link"}{PreferredLifetime} - $now_time);
	$cpp .= "-DPREINFO_VLD_Lifetime=$vld ";
	$cpp .= "-DPREINFO_PRE_Lifetime=$pre ";

	if ( ( $CUR_Link eq 'Link0' ) && ( $LINK0_RA_TYPE ne 'HA_RA' ) ) {
		$cpp .= "-DRA_Hflag_1=0 ";
		$prefix = sprintf "%s::", $link_prefix{$CUR_Link};
		$cpp .= "-DPREFIX_INFO_ANY=\\\"$prefix\\\" ";
	} else {
		$cpp .= "-DRA_Hflag_1=$h_flag{$CUR_Link} ";
		$cpp .= "-DPREINFO_Rflag_0=$preinfo_r_flag{$CUR_Link} ";
		$cpp .= "-DPREFIX_INFO_ANY=\\\"$prefix\\\" ";
	}
	VCppApply($cpp, '', '', 'force');

	# Sending RA packet
	if ( ( $CUR_Link eq 'Link0' ) && ( $LINK0_RA_TYPE ne 'HA_RA' ) ) {
		# HA0 is Router
		%SEND_PACKET_RA = vSend2($if, 'ra_any_any_sll_any_mtu_pfx_any');
	} else {
		%SEND_PACKET_RA = vSend2($if, $send_packet{$CUR_Link});
	}

	# print received packet name
	$msg_name .= make_msg($saddr, $daddr, '0');
	vLogHTML_Info("    $msg_name");

	return (%SEND_PACKET_RA);
}

#-----------------------------------------------------------------------------#
# Router Advertisement
#-----------------------------------------------------------------------------#
sub vReply_ra($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;

	# check of RA packet
	$ret = check_ra(1, $src_packet);
	vLogHTML_Warn("        Received RA");
	return (0);
}

#-----------------------------------------------------------------------------#
# Neighbor Solicitation
#-----------------------------------------------------------------------------#
sub vReply_ns($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;
	my %send_packet;

	# check of NS packet
	if( check_ns(1, $src_packet) != 0 ) {
		vLogHTML_Info("    no-reply");
		%send_packet = ('status', 2);
		return (%send_packet);
	}

	# sending NA
	%send_packet = vSend_na2($if, $src_packet);
	return (%send_packet);
}

#-----------------------------------------------------------------------------#
# Send Neighbor Solicitation
#-----------------------------------------------------------------------------#
sub vSend_na2($$) {
	my ($if, $packet) = @_;
	my %field_value;
	my $cpp = '';
	$msg_name = "Send    NA: ";

	# get value of IPv6 Header
	%field_value = get_value_of_ipv6(0, $packet);

	# get value of ICMPv6 Header
	@field = ('Opt_ICMPv6_SLL');
	%value_ns = get_value_of_ns(0, $packet, @field);

	# make NA packet
	%saddr_tbl = get_addr_tbl( $field_value{DestinationAddress} );
	if ( $saddr_tbl{'addr_type'} eq 'ga' ) {
		$type = "_ga";
	}
	else {
		$type = "_lla";
	}
	%saddr_tbl = get_addr_tbl( $value_ns{'TargetAddress'} );
# NA source is set sending node's address.
#	$saddr_type = sprintf "%s%s", $saddr_tbl{'node_name'}, "_lla";
	$saddr_type = sprintf "%s%s", $saddr_tbl{'node_name'}, $type;
	$saddr = get_addr($saddr_type);
	$smac  = $saddr_tbl{'mac'};
	$tmac  = $saddr_tbl{'mac'};

	# check of SourceAddress in NS
	if ( get_addrType( $field_value{'SourceAddress'} ) eq 'unspecified' ) {
		# SourceAddress is unspecified
		$daddr     = get_addr('all_node_multi');
		$s_flag    = 0;
		%daddr_tbl = get_addr_tbl('ff02::1');
		$dmac      = $daddr_tbl{'mac'};
	} else {
		# Source Address is unicast
		$daddr     = $field_value{'SourceAddress'};
		$s_flag    = 1;
		%daddr_tbl = get_addr_tbl($field_value{'SourceAddress'});
		$dmac      = $daddr_tbl{'mac'};
	}

	# Target Node is Router?
	if ( $saddr_tbl{'node_type'} eq 'router' ) {
		$r_flag = "1";
	} else {
		$r_flag = "0";
	}
	$o_flag = "1";
	$taddr  = $value_ns{'TargetAddress'} ;

	# change of NA packet value
	$cpp .= "-DIP_SRC_ADDR_ANY=\\\"$saddr\\\" ";
	$cpp .= "-DIP_DEST_ADDR_ANY=\\\"$daddr\\\" ";
	$cpp .= "-DIP_TAGET_ADDR_ANY=\\\"$taddr\\\" ";
	$cpp .= "-DSRC_MAC_ANY=\\\"$smac\\\" ";
	$cpp .= "-DDEST_MAC_ANY=\\\"$dmac\\\" ";
	$cpp .= "-DTARGET_MAC_ANY=\\\"$tmac\\\" ";
	$cpp .= "-DNA_Rflag_1=$r_flag ";
	$cpp .= "-DNA_Sflag_1=$s_flag ";
	$cpp .= "-DNA_Oflag_1=$o_flag ";
	VCppApply($cpp, '', '', 'force');

	# sending NA packet
	if ((($saddr eq $node_hash{ha0_ga}) || ($saddr eq $node_hash{ha1_ga})) &&
	    ($daddr eq $node_hash{nuth_ga})) {
		%SEND_PACKET_NA = vSend2($if, 'na_any_any_tll_any_w_ipsec');
	}
	else {
		%SEND_PACKET_NA = vSend2($if, 'na_any_any_tll_any');
	}

	# print send packet name
	$msg_name .= make_msg($saddr, $daddr, $taddr);
	vLogHTML_Info("    $msg_name");

	return (%SEND_PACKET_NA);
}

#-----------------------------------------------------------------------------#
# Neighbor Advertisement
#-----------------------------------------------------------------------------#
sub vReply_na($$$@) {
	my ($if, $packet_name, $src_packet, @variable_value) = @_;

	# check of NA packet
	$ret = check_na(0, $src_packet);
	return (0);
}

#-----------------------------------------------------------------------------#
# check_rs($$)
#
# <out>  0: ok. and reply
#        1: ok. and no reply (DAD)
#       -1: ng. illegal or unknown address at link
#-----------------------------------------------------------------------------#
sub check_rs($$) {
	my ($display, $packet) = @_;
	my %field_value;
	$msg_name = "Receive RS: ";

	# get value of IPv6 Header
	$field_value{SourceAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
	$field_value{DestinationAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
	$field_value{HopLimit} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.HopLimit'};

	# get value of ICMPv6 Header
	@field = ('Opt_ICMPv6_SLL');
	%value_rs = get_value_of_rs(0, $packet, @field);

	# print received packet name
	$msg_name .= make_msg($field_value{SourceAddress}, $field_value{DestinationAddress}, '0');
	vLogHTML_Info("    $msg_name");

	# check of HopLimit value
	if ( $field_value{HopLimit} != 255 ){
		# HopLimit is invalid value
		if ( $display == 1 ) {
			vLogHTML_Warn("        HopLimit is not 255.");
			$warncount ++;
		}
		return (-1);
	}

	# check of SourceAddress
	$addr_type = check_addr( $field_value{SourceAddress} );
	if ( ( $addr_type eq 'unspecified' ) &&
	     ( defined($value_rs{'Opt_ICMPv6_SLL'}) ) ) {
		# Source Address is unspecified and SLL option is included
		if ( $display == 1 ) {
			vLogHTML_Warn("        SLL option must not be included when source address is unspecified address.");
			$warncount ++;
		}
		return (-1);
	}

	# check of DestinationAddress
	%daddr_tbl = get_addr_tbl( $field_value{DestinationAddress} );
	$daddr_type = check_addr( $field_value{DestinationAddress} );
	if ( ( $daddr_tbl{'node_type'} eq 'host' ) ||
	     ( $daddr_type eq 'unspecifid' ) ||
	     ( $daddr_type eq 'loopback' ) ) {
		# DestinationAddress is not router
		if ( $display == 1 ) {
			vLogHTML_Warn("        Destination Address is not router.");
			$warncount ++;
		}
		return (-1);
	}
	if( is_Link($field_value{DestinationAddress}, $CUR_Link) != 0 ) {
		# dose not exist
		if ( $display == 1 ) {
			vLogHTML_Info("        DestinationAddress is unknown node.[$field_value{DestinationAddress}]");
		}
		return (-1);
	}
	if ( ( $daddr_tbl{'node_name'} eq 'ha1' ) && ( $HA1_STATE eq 'DISABLE' ) ) {
		# ha1 is desable
		if ( $display == 1 ) {
			vLogHTML_Info("        DestinationAddress is unknown node.[$field_value{DestinationAddress}]");
		}
		return (-1);
	}
	return (0);
}

#-----------------------------------------------------------------------------#
# check_ra($$)
#-----------------------------------------------------------------------------#
sub check_ra($$) {
	my ($display, $packet) = @_;
	my %field_value;
	$msg_name = "Receive RA: ";

	# get value of IPv6 Header
	$field_value{SourceAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
	$field_value{DestinationAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
	$field_value{HopLimit} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.HopLimit'};

	# print received packet name
	$msg_name .= make_msg($field_value{SourceAddress}, $field_value{DestinationAddress}, '0');
	vLogHTML_Info("    $msg_name");

	# check of HopLimit value
	if ( $field_value{HopLimit} != 255 ){
		# HopLimit is invalid value
		if ( $display == 1 ) {
			vLogHTML_Warn("        HopLimit is not 255.");
			$warncount ++;
		}
		return (-1);
	}
	return (0);
}

#-----------------------------------------------------------------------------#
# check_ns($$)
#-----------------------------------------------------------------------------#
sub check_ns($$) {
	my ($display, $packet) = @_;
	my %field_value;
	$msg_name = "Receive NS: ";

	# get value of IPv6 Header
	$field_value{SourceAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
	$field_value{DestinationAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
	$field_value{HopLimit} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.HopLimit'};

	# get value of ICMPv6 Header
	@field = ('Opt_ICMPv6_SLL');
	%value_ns = get_value_of_ns(0, $packet, @field);

	# print received packet name
	$msg_name .= make_msg($field_value{SourceAddress}, $field_value{DestinationAddress}, $value_ns{TargetAddress} );
	vLogHTML_Info("    $msg_name");

	# check of HopLimit value
	if ( $field_value{HopLimit} != 255 ){
		# HopLimit is invalid value
		if ( $display == 1 ) {
			vLogHTML_Warn("        HopLimit is invalid value[$field_value{HopLimit}]");
			$warncount ++;
		}
		return (-1);
	}

	# check of SourceAddress
	%saddr_tbl = get_addr_tbl( $field_value{'SourceAddress'} );
	if ( !(defined($saddr_tbl{'node_name'}) ) ) {
		# SourceAddress is unknown
		if ( $display == 1 ) {
			vLogHTML_Warn("        Source address is unknown node.[$field_value{'SourceAddress'}]");
			$warncount ++;
		}
		return (-1);
	}
	$addr_type = check_addr( $field_value{'SourceAddress'} );
	if ( ( $addr_type eq 'multicast' ) ||
	     ( $addr_type eq 'anycast' ) ) {
		# SourceAddress is multicast or anycast
		if ( $display == 1 ) {
			vLogHTML_Warn("        Source address is invalid type.[$addr_type]");
			$warncount ++;
		}
		return (-1);
	} elsif ( ( $addr_type eq 'unspecified' ) &&
	          ( defined($$packet{'Frame_Ether.Packet_IPv6.ICMPv6_NS.Opt_ICMPv6_SLL'}) ) ) {
		# Source Address is unspecified and SLL option is included
		if ( $display == 1 ) {
			vLogHTML_Warn("        SLL option must not be included when source address is unspecified address.");
			$warncount ++;
		}
		return (-1);
	}

	# check of DestinationAddress
	%daddr_tbl = get_addr_tbl( $field_value{DestinationAddress} );
	$daddr_type = check_addr( $field_value{DestinationAddress} );
	if ( ( $daddr_type eq 'unspecifid' ) ||
	     ( $daddr_type eq 'loopback' ) ) {
		# DestinationAddress is not router
		if ( $display == 1 ) {
			vLogHTML_Warn("        Destination Address is invalid.[$daddr_type]");
			$warncount ++;
		}
		return (-1);
	}

	# check of TargetAddress
	$addr_type = check_addr( $value_ns{TargetAddress} );
	if ( ( $addr_type eq 'unspecified' ) ||
	     ( $addr_type eq 'multicast' ) ) {
		# TargetAddress is unspecified or multicast
		if ( $display == 1 ) {
			vLogHTML_Warn("        Target address is invalid type.[$addr_type]");
			$warncount ++;
		}
		return (-1);
	}

	if( is_Link($field_value{DestinationAddress}, $CUR_Link) != 0 ) {
		# dose not exist
		if ( $display == 1 ) {
#			vLogHTML_Info("debug: CUR_Link=$CUR_Link");
			vLogHTML_Info("        DestinationAddress is unknown node.[$field_value{DestinationAddress}]");
		}
		return (-1);
	}

	# check of target node
	if ( substr($taddr_tbl{'node_name'}, 0, 3) eq 'nut' ) {
		# TargetAddress is NUT
		vLogHTML_Info("        NS is DAD");
		return (1);
	}

	# Node's existence check
	if( is_Link($value_ns{'TargetAddress'}, $CUR_Link) != 0 ) {
		# dose not exist
		if ( $display == 1 ) {
			vLogHTML_Info("        Target address is unknown node.[$value_ns{'TargetAddress'}]");
		}
		return (-1);
	}

	# check of Destination and Target address
	%taddr_tbl = get_addr_tbl( $value_ns{'TargetAddress'} );
	if ( substr($taddr_tbl{'node_name'}, 0, 2) ne substr($daddr_tbl{'node_name'}, 0, 2) ) {
		# DestinationAddress and TargetAddress are a mismatch.
		if ( $display == 1 ) {
			vLogHTML_Info("        Destination address is invalid.[$field_value{DestinationAddress}]");
		}
		return (-1);
	}

	return (0);
}

#-----------------------------------------------------------------------------#
# check_na($$)
#-----------------------------------------------------------------------------#
sub check_na($$) {
	my ($display, $packet) = @_;
	my %field_value;
	$msg_name = "Receive NA: ";

	# get value of IPv6 Header
	$field_value{SourceAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
	$field_value{DestinationAddress} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
	$field_value{HopLimit} = $$packet{'Frame_Ether.Packet_IPv6.Hdr_IPv6.HopLimit'};

	# get value of ICMPv6 Header
	@field = ('Opt_ICMPv6_TLL');
	%value_na = get_value_of_na(0, $packet, @field);

	# print received packet name
	$msg_name .= make_msg($field_value{SourceAddress}, $field_value{DestinationAddress}, $value_na{TargetAddress} );
	vLogHTML_Info("    $msg_name");

	# check of HopLimit value
	if ( $field_value{HopLimit} != 255 ){
		# HopLimit is invalid value
		if ( $display == 1 ) {
			vLogHTML_Warn("        HopLimit is not 255.");
			$warncount ++;
		}
		return (-1);
	}

	# check of TargetAddress
	$addr_type = check_addr( $value_na{'TargetAddress'} );
	if ( ( $addr_type eq 'multicast' ) ) {
		# TargetAddress is multicast
		if ( $display == 1 ) {
			vLogHTML_Warn("        Destination address is invalid type.");
			$warncount ++;
		}
		return (-1);
	}

	# check of DestinationAddress and (S)Flag
	$addr_type = check_addr( $field_value{DestinationAddress} );
	if ( ( $addr_type eq 'multicast' ) && ( $value_na{SFlag} != 0) ) {
		# DestinationAddress is multicast and (S)flag is ON
		if ( $display == 1 ) {
			vLogHTML_Warn("        Solicited flag is not zero.");
			$warncount ++;
		}
		return (-1);
	}

	return (0);
}

#-----------------------------------------------------------------------------#
# make_msg($$$)
#-----------------------------------------------------------------------------#
sub make_msg($$$) {
	my ($saddr, $daddr, $taddr ) = @_;
	my $out_msg = '';

	# get SourceAddress table 
	%saddr_tbl = get_addr_tbl($saddr);
	if( !(defined($saddr_tbl{'node_name'}) ) ) {
		$node_name = 'unknown';
		$addr_type = '';
	} else {
		$node_name = uc($saddr_tbl{'node_name'});
		$addr_type = uc($saddr_tbl{'addr_type'});
	}
	$out_msg = sprintf "%s(%s)", $node_name, $addr_type;

	# get DestinationAddress table
	%daddr_tbl = get_addr_tbl($daddr);
	if( !(defined($daddr_tbl{'node_name'}) ) ) {
		$node_name = 'unknown';
		$addr_type = '';
	} else {
		$node_name = uc($daddr_tbl{'node_name'});
		$addr_type = uc($daddr_tbl{'addr_type'});
	}
	$out_msg .= sprintf " -> %s(%s)", $node_name, $addr_type;

	# check of TargetAddress
	if( $taddr ne '0' ) {
		%taddr_tbl = get_addr_tbl($taddr);
		if( !(defined($taddr_tbl{'node_name'}) ) ) {
			$node_name = 'unknown';
		} else {
			$node_name = uc($taddr_tbl{'node_name'});
		}
		$out_msg .= sprintf "(TARGET=%s)", $node_name;
	}
	return($out_msg);
}

#-----------------------------------------------------------------------------#
# set_ha1_is_rt()
#-----------------------------------------------------------------------------#
sub set_ha1_is_rt() {
	$LINK0_RA_TYPE = 'RT_RA';
}

#-----------------------------------------------------------------------------#
# unset_ha1_is_rt()
#-----------------------------------------------------------------------------#
sub unset_ha1_is_rt() {
	$LINK0_RA_TYPE = 'HA_RA';
}

#-----------------------------------------------------------------------------#
# ha1_enable()
#-----------------------------------------------------------------------------#
sub ha1_enable() {
	$HA1_STATE = 'ENABLE';
}

#-----------------------------------------------------------------------------#
# ha1_desable()
#-----------------------------------------------------------------------------#
sub ha1_desable() {
	$HA1_STATE = 'DISABLE';
}

# End of File
1;
