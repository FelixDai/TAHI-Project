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
########################################################################

package mipv6;

use Exporter;
use V6evalTool;
use config;

use ike;

BEGIN {
	$V6evalTool::TestVersion = '$Name: NEMO_1_0_2 $';
}
END   {}



@ISA = qw(Exporter);

@EXPORT = qw(
	$true
	$false
	$Link0
	$Link1
	@mrs
	$parent_mr
	%mn
	%cn
	%icmp_error_router
	$binding_created
	$binding_lifetime
	$mpa_valid_lifetime
	$have_ha0_entry
	$have_ha1_entry
	$have_ha0_multiple_entry
	@rtadv_flood
	%pktdesc
	mipv6init
	exitPass
	exitInitFail
	exitFail
	exitFatal
	rtadv_exchange
	rtadv_exchange_using_local_packet_definition
	rtadv_exchange_get_valid_lifetime
	dhaad_confirmation
	dhaad_confirmation_using_local_packet_definition
	dhaad_confirmation_with_time
	mipv6registration
	mipv6registration_using_local_packet_definition
	mipv6registration_not_home_subnet
	mipv6registration_icmp_error
	mipv6ignore_registration
	mipv6sending_mcast_na
	proxy_nd
	mipv6dad
	mipv6dad_receiving_na
	mipv6dad_none
	mipv6de_registration
	mipv6de_registration_using_local_packet_definition
	mipv6de_registration_unrecognized_mh_type
	mipv6de_registration_icmp_error
	mpd_confirmation
	mpd_confirmation_returning_binding_error
	linklocal_echo
	binding_confirmation
	binding_confirmation_using_local_packet_definition
	binding_confirmation_not_home_subnet
	binding_confirmation_with_time
	reverse_tunnel_HoTI
	ignore_reverse_tunnel_HoTI
	tunnel_HoT
	reverse_tunnel_ereq
	reverse_tunnel_ereq_using_local_packet_definition
	tunnel_ereq
	tunnel_ereq_using_local_packet_definition
	relay_icmp_error
	relay_icmp_error_rut1
	relay_icmp_error_using_local_packet_definition
	reverse_tunnel_mnp_ereq
	reverse_tunnel_mnp_ereq_using_local_packet_definition
	tunnel_mnp_ereq
	tunnel_mnp_ereq_using_local_packet_definition
	relay_mnp_icmp_error_using_local_packet_definition
	reverse_tunnel_mnp_haad_using_local_packet_definition
	reverse_tunnel_mnp_mps_using_local_packet_definition
	reverse_tunnel_mnp_HoTI_using_local_packet_definition
	reverse_tunnel_mnp_CoTI_using_local_packet_definition
	reverse_tunnel_mnp_HoT_using_local_packet_definition
	reverse_tunnel_mnp_CoT_using_local_packet_definition
	reverse_tunnel_mnp_BU_using_local_packet_definition
	reverse_tunnel_mnp_BA_using_local_packet_definition
	reverse_tunnel_mnp_BRR_using_local_packet_definition
	tunnel_mnp_haad_using_local_packet_definition
	tunnel_mnp_mpa_using_local_packet_definition
	tunnel_mnp_HoTI_using_local_packet_definition
	tunnel_mnp_CoTI_using_local_packet_definition
	tunnel_mnp_HoT_using_local_packet_definition
	tunnel_mnp_CoT_using_local_packet_definition
	tunnel_mnp_BU_using_local_packet_definition
	tunnel_mnp_BA_using_local_packet_definition
	nest_dhaad_confirmation_using_local_packet_definition
	nest_mipv6registration_using_local_packet_definition
	nest_mpd_confirmation_using_local_packet_definition
	nest_binding_confirmation_using_local_packet_definition
	nest_reverse_tunnel_HoTI_using_local_packet_definition
	nest_tunnel_HoT_using_local_packet_definition
	nest_mnp_ereq_using_local_packet_definition
	nest_reverse_tunnel_ereq_using_local_packet_definition
	nest_tunnel_erep_using_local_packet_definition
);

push(@EXPORT, sort(@V6evalTool::EXPORT, @config::EXPORT));



#------------------------------#
# global constants             #
#------------------------------#
$true  = 1;
$false = 0;

$Link0 = 'Link0';
$Link1 = 'Link1';

$Link0_device = $V6evalTool::NutDef{'Link0_device'};
$Link1_device = $V6evalTool::NutDef{'Link1_device'};

$sequence_def = './sequence.def';

# relate BA_ACCEPT_STATUS in mipv6.def
$ba_accept_status = '0';

# relate in config.def
# $ike_ba_k_bit            = ($USE_IKE_BA_K_BIT)? 1: 0;

$MAX_RTR_SOLICITATION_DELAY = 1;
$RETRANS_TIMER              = 1;
$DELAY_FIRST_PROBE_TIME     = 5;
$MAX_UNICAST_SOLICIT        = 3;
$MAX_ANYCAST_DELAY_TIME     = 1;
$MAX_RA_DELAY_TIME          = 0.5;
$MIN_DELAY_BETWEEN_RAS      = 3;
$DupAddrDetectTransmits     = 1;

%link = (
	'USE_LINK0X' => $Link0,
	'USE_LINK0Y' => $Link0,
	'USE_LINK1X' => $Link1,
	'USE_LINK1Y' => $Link1,
	'USE_LINK0A' => $Link0,
	'USE_LINK1A' => $Link1,
);

%nest = (
	'USE_LINK0X' => 0,
	'USE_LINK0Y' => 0,
	'USE_LINK1X' => 0,
	'USE_LINK1Y' => 0,
	'USE_LINK0A' => 1,
	'USE_LINK1A' => 1,
);

%link_dir_rv = (
	'USE_LINK0X' => 0,
	'USE_LINK0Y' => 0,
	'USE_LINK1X' => 1,
	'USE_LINK1Y' => 1,
	'USE_LINK0A' => 0,
	'USE_LINK1A' => 1,
);

%mn = (
	'USE_LINK0X' => 'MR0X',
	'USE_LINK0Y' => 'MR0Y',
	'USE_LINK1X' => 'MR1X',
	'USE_LINK1Y' => 'MR1Y',
	'USE_LINK0A' => 'VMN0A',
	'USE_LINK1A' => 'VMN1A',
);

%cn = (
	'USE_LINK0X' => 'CN0X',
	'USE_LINK0Y' => 'CN0Y',
	'USE_LINK1X' => 'CN1X',
	'USE_LINK1Y' => 'CN1Y',
	'USE_LINK0A' => 'CN0X',
	'USE_LINK1A' => 'CN1X',
);

%router = (
	'USE_LINK0X' => 'R0',
	'USE_LINK0Y' => 'R0',
	'USE_LINK1X' => 'R1',
	'USE_LINK1Y' => 'R1',
	'USE_LINK0A' => 'R0',
	'USE_LINK1A' => 'R1',
);

%icmp_error_router = (
	'USE_LINK0X' => 'R0X',
	'USE_LINK0Y' => 'R0X',
	'USE_LINK1X' => 'R1X',
	'USE_LINK1Y' => 'R1X',
	'USE_LINK0A' => 'R0X',
	'USE_LINK1A' => 'R1X',
);

%cn0 = (
	'USE_CN0_GLOBAL'    => 'CN0 (global)',
	'USE_CN0_LINKLOCAL' => 'CN0 (link-local)',
);

%nd_mcast = (
	'rx_mcast_ns_linklocal_sll' => 'rx_na_linklocal',
	'rx_mcast_ns_global_sll'    => 'rx_na_global',
);

%nd4cn0_mcast = (
	'cn0_mcast_ns_linklocal_sll' => 'cn0_na_linklocal',
	'cn0_mcast_ns_global_sll'    => 'cn0_na_global',
);

%nd_ucast = (
	'rx_ucast_ns_linklocal_sll' => 'rx_na_linklocal',
	'rx_ucast_ns_linklocal'     => 'rx_na_linklocal',
	'rx_ucast_ns_global_sll'    => 'rx_na_global',
	'rx_ucast_ns_global'        => 'rx_na_global',
);

%nd_mcast_hoa = (
	'reachability_hoa_mcast_ns_linklocal_sll' => 'reachability_hoa_na_linklocal',
	'reachability_hoa_mcast_ns_global_sll'    => 'reachability_hoa_na_global',
);

# check for unexpect
$F = 'Frame_Ether';
$P = 'Packet_IPv6';
$E = 'Hdr_ESP.Decrypted.ESPPayload';
$X = 'Hdr_ESP.Decrypted.ESPPayload.Payload.data';
$Y = 'Hdr_ESP.Crypted';

%name_head_hash = (
	'icmp6_du'      => 'ICMPv6_DestinationUnreachable', # ICMP   1
	'icmp6_pp'      => 'ICMPv6_ParameterProblem',       # ICMP   4
	'echorequest'   => 'ICMPv6_EchoRequest',            # ICMP 128
	'echoreply'     => 'ICMPv6_EchoReply',              # ICMP 129
	'mldreport'     => 'ICMPv6_MLDReport',              # ICMP 131
	'rs'            => 'ICMPv6_RS',                     # ICMP 133
	'ra'            => 'ICMPv6_RA',                     # ICMP 134
	'ns'            => 'ICMPv6_NS',                     # ICMP 135
	'na'            => 'ICMPv6_NA',                     # ICMP 136
	'redirect'      => 'ICMPv6_Redirect',               # ICMP 137
	'mld2report'    => 'ICMPv6_MLDv2Report',            # ICMP 143
	'haadrequest'   => 'ICMPv6_HAADRequest',            # ICMP 144
	'haadreply'     => 'ICMPv6_HAADReply',              # ICMP 145
	'mps'           => 'ICMPv6_MobilePrefixSol',        # ICMP 146
	'mpa'           => 'ICMPv6_MobilePrefixAdvertise',  # ICMP 147
	'brr'           => 'Hdr_MH_BRR',                    # MH     0
	'hoti'          => 'Hdr_MH_HoTI',                   # MH     1
	'coti'          => 'Hdr_MH_CoTI',                   # MH     2
	'hot'           => 'Hdr_MH_HoT',                    # MH     3
	'cot'           => 'Hdr_MH_CoT',                    # MH     4
	'bu'            => 'Hdr_MH_BU',                     # MH     5
	'bu_cn'         => 'Hdr_MH_BU',                     # MH     5
	'ba'            => 'Hdr_MH_BA',                     # MH     6
	'ba_cn'         => 'Hdr_MH_BA',                     # MH     6
	'be'            => 'Hdr_MH_BE',                     # MH     7
);

%name_check_hash = (
	'icmp6_du'      => '1',
	'icmp6_pp'      => '1',
	'echorequest'   => '1',
	'echoreply'     => '1',
	'mldreport'     => '0',
	'rs'            => '0',
	'ra'            => '0',
	'ns'            => '0',
	'na'            => '0',
	'redirect'      => '1',
	'mld2report'    => '0',
	'haadrequest'   => '1',
	'haadreply'     => '1',
	'mps'           => '1',
	'mpa'           => '1',
	'brr'           => '1',
	'hoti'          => '1',
	'coti'          => '1',
	'hot'           => '1',
	'cot'           => '1',
	'bu'            => '1',
	'bu_cn'         => '1',
	'ba'            => '1',
	'ba_cn'         => '1',
	'be'            => '1',
);



#------------------------------#
# global variables             #
#------------------------------#
$capture_link0           = $false;
$capture_link1           = $false;

@mrs                     = ();
$parent_mr               = 0; # mr device No. 0-3
$link_dir                = 0;

$movement_compat         = 'USE_LINK0X';

$have_binding_cache      = $false;
$last_accepted_sequence  = 0;
$linklocal_compat        = $false;
$kbit_compat             = $false;
$mr_regist               = $false;
$binding_created         = -1;
$binding_lifetime        = -1;
$mpa_valid_lifetime      = -1;

$movement_compat2        = 'USE_LINK0A';

$have_binding_cache2     = $false;
$last_accepted_sequence2 = 0;
$linklocal_compat2       = $false;
$kbit_compat2            = $false;
$mr_regist2              = $false;

$have_ha0_entry          = $false;
$have_ha1_entry          = $false;
$have_ha0_multiple_entry = $false; # for HA_7_2_15
$have_ha_entry_flood     = $false;
@rtadv_flood             = ();

%sequence = (
	'SA1_SEQ' => 0,
	'SA3_SEQ' => 0,
	'SA5_SEQ' => 0,
	'SA7_SEQ' => 0,
	'SA9_SEQ' => 0,
	'nest_SA1_SEQ' => 0,
	'nest_SA3_SEQ' => 0,
	'nest_SA5_SEQ' => 0,
	'nest_SA7_SEQ' => 0,
	'nest_SA9_SEQ' => 0,
);

@UNEXPECT = ();
@frames_known = ();
@frames_ilesp = ();

%pktdesc = (
	'coa_ereq'					=>
		'    Send Echo Request: MN0X -&gt; RUT (Link0)',
	'coa_erep'					=>
		'    Recv Echo Reply: RUT (Link0) -&gt; MN0X',
	'mps_common'					=>
		'    Send MPS w/ HaO: MN0X -&gt; RUT (Link0)',
	'coa_ereq_hao'					=>
		'    Send Echo Request w/ HaO: MN0X -&gt; RUT (Link0)',
	'coa_ereq_hao_not_home_subnet'			=>
		'    Send Echo Request w/ HaO: MN0X -&gt; RUT (Link0)',
	'mpa_common'				=>
		'    Recv MPA w/ RH: RUT (Link0) -&gt; MN0X',
	'coa_erep_routing'				=>
		'    Recv Echo Reply w/ RH: RUT (Link0) -&gt; MN0X',
	'coa_erep_routing_not_home_subnet'		=>
		'    Recv Echo Reply w/ RH: RUT (Link0) -&gt; MN0X',

	'rx_mcast_ns_linklocal_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, link-local) -&gt; '.
		'R0 solicited-node multicast address',
	'rx_ucast_ns_linklocal_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, link-local) -&gt; R0',
	'rx_ucast_ns_linklocal'				=>
		'    Recv NS w/o SLL: RUT (Link0, link-local) -&gt; R0',
	'rx_na_linklocal'				=>
		'    Send NA (RSO) w/ TLL: R0 -&gt; RUT (Link0, link-local)',

	'rx_mcast_ns_global_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, global) -&gt; '.
		'R0 solicited-node multicast address',
	'rx_ucast_ns_global_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, global) -&gt; R0',
	'rx_ucast_ns_global'				=>
		'    Recv NS w/o SLL: RUT (Link0, global) -&gt; R0',
	'rx_na_global'					=>
		'    Send NA (RSO) w/ TLL: R0 -&gt; RUT (Link0, global)',

	'hoa_mcast_ns_linklocal_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, link-local) -&gt; '.
		'MN0 solicited-node multicast address',
	'hoa_ucast_ns_linklocal_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, link-local) -&gt; MN0',
	'hoa_ucast_ns_linklocal'			=>
		'    Recv NS w/o SLL: RUT (Link0, link-local) -&gt; MN0',
	'hoa_na_linklocal'				=>
		'    Send NA (rSO) w/ TLL: MN0 -&gt; RUT (Link0, link-local)',
	'hoa_mcast_ns_global_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, global) -&gt; '.
		'MN0 solicited-node multicast address',
	'hoa_ucast_ns_global_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, global) -&gt; MN0',
	'hoa_ucast_ns_global'				=>
		'    Recv NS w/o SLL: RUT (Link0, global) -&gt; MN0',
	'hoa_na_global'					=>
		'    Send NA (rSO) w/ TLL: MN0 -&gt; RUT (Link0, global)',
	'bu_common'					=>
		'    Send BU (seq:0, ahlk, ltime:0) w/ HaO: '.
		'MN0X -&gt; RUT (Link0)',
	'ba_common'					=>
		'    Recv BA (stat:0, k, seq:0, ltime:0) w/ RH: '.
		'RUT (Link0) -&gt; MN0X',
	'be_common'					=>
		'    Recv BE (stat:1): RUT (Link0) -&gt; MN0X',
	'be_common_not_home_subnet'			=>
		'    Recv BE (stat:1): RUT (Link0) -&gt; MN0X',
	'be_dereg_common'				=>
		'    Recv BE (stat:2): RUT (Link0) -&gt; MN0',
	'hoti_tunnel_common'				=>
		'    Send HoTI (reverse tunneled): '.
		'MN0X -&gt; RUT (Link0): MN0 -&gt; CN0X',
	'hoti_common'					=>
		'    Recv HoTI: MN0 -&gt; CN0X',
	'hot_tunnel_common'				=>
		'    Recv HoT (tunneled): '.
		'RUT (Link0) -&gt; MN0X: CN0X -&gt; MN0',
	'hot_common'					=>
		'    Send HoT: CN0X -&gt; MN0',
	'ereq_mn2cn_tunnel_common'			=>
		'    Send Echo Request (reverse tunneled): '.
		'MN0X -&gt; RUT (Link0): MR0 -&gt; CN0X',
	'ereq_mn2cn_common'				=>
		'    Recv Echo Request: MR0 -&gt; CN0X',
	'ereq_cn2mn_tunnel_common'			=>
		'    Recv Echo Request (tunneled): '.
		'RUT (Link0) -&gt; MN0X: CN0X -&gt; MR0',
	'ereq_cn2mn_common'				=>
		'    Send Echo Request: CN0X -&gt; MR0',
	'proxy_dad_ns_global'				=>
		'    Recv NS w/o SLL: unspecified address -&gt; '.
		'MN0 (global) solicited-node multicast address',
	'proxy_dad_ns_linklocal'			=>
		'    Recv NS w/o SLL: unspecified address -&gt; '.
		'MN0 (link-local) solicited-node multicast address',
	'proxy_dad_na_global'				=>
		'    Send NA (rsO, target=MN0 (global)) w/ TLL: '.
		'MN0 (link-local) -&gt; all-nodes multicast address',
	'proxy_dad_na_linklocal'			=>
		'    Send NA (rsO, target=MN0 (link-local)) w/ TLL: '.
		'MN0 (link-local) -&gt; all-nodes multicast address',

	'proxy_mcast_ns_global_sll'			=>
		'    Send NS w/ SLL: CN0 (global) -&gt; '.
		'MN0 (global) solicited-node multicast address',
	'invalid_proxy_mcast_ns_global_sll'		=>
		'    Send NS (invalid target) w/ SLL: CN0 (global) -&gt; '.
		'MN0 (global) solicited-node multicast address',
	'proxy_ucast_ns_global'				=>
		'    Send NS w/o SLL: CN0 (global) -&gt; MN0 (global)',
	'invalid_proxy_ucast_ns_global'			=>
		'    Send NS (invalid target) w/o SLL: '.
		'CN0 (global) -&gt; MN0 (global)',
	'proxy_ucast_ns_global_sll'			=>
		'    Send NS w/ SLL: CN0 (global) -&gt; MN0 (global)',
	'invalid_proxy_ucast_ns_global_sll'		=>
		'    Send NS (invalid target) w/ SLL: '.
		'CN0 (global) -&gt; MN0 (global)',
	'proxy_dad_ns_global_from_cn0'			=>
		'    Send NS w/o SLL: unspecified address -&gt; '.
		'MN0 (global) solicited-node multicast address',
	'invalid_proxy_dad_ns_global_from_cn0'		=>
		'    Send NS (invalid target) w/o SLL: '.
		'unspecified address -&gt; '.
		'MN0 (global) solicited-node multicast address',
	'proxy_dad_ns_linklocal_from_cn0'		=>
		'    Send NS w/o SLL: unspecified address -&gt; '.
		'MN0 (link-local) solicited-node multicast address',
	'invalid_proxy_dad_ns_linklocal_from_cn0'		=>
		'    Send (invalid target) NS w/o SLL: '.
		'unspecified address -&gt; '.
		'MN0 (link-local) solicited-node multicast address',
	'proxy_na_global_from_global'			=>
		'    Recv NA (rSo) w/o TLL: '.
		'RUT (Link0, global) -&gt; CN0 (global)',
	'invalid_proxy_na_global_from_global'		=>
		'    Recv NA (rSo, invalid target) w/o TLL: '.
		'RUT (Link0, global) -&gt; CN0 (global)',
	'proxy_na_global_from_linklocal'		=>
		'    Recv NA (rSo) w/o TLL: '.
		'RUT (Link0, link-local) -&gt; CN0 (global)',
	'invalid_proxy_na_global_from_linklocal'		=>
		'    Recv NA (rSo, invalid target) w/o TLL: '.
		'RUT (Link0, link-local) -&gt; CN0 (global)',
	'proxy_na_global_tll_from_global'		=>
		'    Recv NA (rSo) w/ TLL: '.
		'RUT (Link0, global) -&gt; CN0 (global)',
	'invalid_proxy_na_global_tll_from_global'	=>
		'    Recv NA (rSo, invalid target) w/ TLL: '.
		'RUT (Link0, global) -&gt; CN0 (global)',
	'proxy_na_global_tll_from_linklocal'		=>
		'    Recv NA (rSo) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; CN0 (global)',
	'invalid_proxy_na_global_tll_from_linklocal'	=>
		'    Recv NA (rSo, invalid target) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; CN0 (global)',
	'proxy_dad_na_global_from_cn0_global'		=>
		'    Recv NA (rso, target=MN0 (global)) w/ TLL: '.
		'RUT (Link0, global) -&gt; all-nodes multicast address',
	'invalid_proxy_dad_na_global_from_cn0_global'		=>
		'    Recv NA (rso, target=CN0 (global)) w/ TLL: '.
		'RUT (Link0, global) -&gt; all-nodes multicast address',
	'proxy_dad_na_global_from_cn0_linklocal'	=>
		'    Recv NA (rso, target=MN0 (global)) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; all-nodes multicast address',
	'invalid_proxy_dad_na_global_from_cn0_linklocal'	=>
		'    Recv NA (rso, target=CN0 (global)) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; all-nodes multicast address',
	'proxy_dad_na_linklocal_from_cn0_global'	=>
		'    Recv NA (rso, target=MN0 (link-local)) w/ TLL: '.
		'RUT (Link0, global) -&gt; all-nodes multicast address',
	'invalid_proxy_dad_na_linklocal_from_cn0_global'	=>
		'    Recv NA (rso, target=CN0 (link-local)) w/ TLL: '.
		'RUT (Link0, global) -&gt; all-nodes multicast address',
	'proxy_dad_na_linklocal_from_cn0_linklocal'	=>
		'    Recv NA (rso, target=MN0 (link-local)) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; all-nodes multicast address',
	'invalid_proxy_dad_na_linklocal_from_cn0_linklocal'	=>
		'    Recv NA (rso, target=CN0 (link-local)) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; all-nodes multicast address',
	'unsolicited_mcast_na_global_from_global'	=>
		'    Recv NA (rsO, target=MN0 (global)) w/ TLL: '.
		'RUT (Link0, global) -&gt; all-nodes multicast address',
	'unsolicited_mcast_na_global_from_linklocal'	=>
		'    Recv NA (rsO, target=MN0 (global)) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; all-nodes multicast address',
	'unsolicited_mcast_na_linklocal_from_global'	=>
		'    Recv NA (rsO, target=MN0 (link-local)) w/ TLL: '.
		'RUT (Link0, global) -&gt; all-nodes multicast address',
	'unsolicited_mcast_na_linklocal_from_linklocal'	=>
		'    Recv NA (rsO, target=MN0 (link-local)) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; all-nodes multicast address',

	'proxy_mcast_ns_linklocal_sll'			=>
		'    Send NS w/ SLL: CN0 (global) -&gt; '.
		'MN0 (link-local) solicited-node multicast address',
	'invalid_proxy_mcast_ns_linklocal_sll'		=>
		'    Send NS (invalid target) w/ SLL: CN0 (global) -&gt; '.
		'MN0 (link-local) solicited-node multicast address',
	'proxy_ucast_ns_linklocal'			=>
		'    Send NS w/o SLL: CN0 (global) -&gt; MN0 (link-local)',
	'invalid_proxy_ucast_ns_linklocal'		=>
		'    Send NS (invalid target) w/o SLL: '.
		'CN0 (global) -&gt; MN0 (link-local)',
	'proxy_ucast_ns_linklocal_sll'			=>
		'    Send NS w/ SLL: CN0 (global) -&gt; MN0 (link-local)',
	'invalid_proxy_ucast_ns_linklocal_sll'		=>
		'    Send NS (invalid target) w/ SLL: '.
		'CN0 (global) -&gt; MN0 (link-local)',
	'proxy_na_linklocal_from_linklocal'		=>
		'    Recv NA (rSo) w/o TLL: '.
		'RUT (Link0, link-local) -&gt; CN0 (global)',
	'invalid_proxy_na_linklocal_from_linklocal'	=>
		'    Recv NA (rSo, invalid target) w/o TLL: '.
		'RUT (Link0, link-local) -&gt; CN0 (global)',
	'proxy_na_linklocal_from_global'		=>
		'    Recv NA (rSo) w/o TLL: '.
		'RUT (Link0, global) -&gt; CN0 (global)',
	'invalid_proxy_na_linklocal_from_global'		=>
		'    Recv NA (rSo, invalid target) w/o TLL: '.
		'RUT (Link0, global) -&gt; CN0 (global)',
	'proxy_na_linklocal_tll_from_linklocal'		=>
		'    Recv NA (rSo) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; CN0 (global)',
	'invalid_proxy_na_linklocal_tll_from_linklocal'		=>
		'    Recv NA (rSo, invalid target) w/ TLL: '.
		'RUT (Link0, link-local) -&gt; CN0 (global)',
	'proxy_na_linklocal_tll_from_global'		=>
		'    Recv NA (rSo) w/ TLL: '.
		'RUT (Link0, global) -&gt; CN0 (global)',
	'invalid_proxy_na_linklocal_tll_from_global'	=>
		'    Recv NA (rSo, invalid target) w/ TLL: '.
		'RUT (Link0, global) -&gt; CN0 (global)',

	'cn0_mcast_ns_linklocal_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, link-local) -&gt; '.
		'CN0 (global) solicited-node multicast address',
	'cn0_mcast_ns_global_sll'			=>
		'    Recv NS w/ SLL: RUT (Link0, global) -&gt; '.
		'CN0 (global) solicited-node multicast address',
	'cn0_na_linklocal'				=>
		'    Send NA (rSO) w/ TLL: '.
		'CN0 (global) -&gt; RUT (Link0, link-local)',
	'cn0_na_global'					=>
		'    Send NA (rSO) w/ TLL: '.
		'CN0 (global) -&gt; RUT (Link0, global)',

	'haad_request'					=>
		'    Send HAAD Request: '.
		'MN0X -&gt; Home-Agents anycast address',
	'haad_reply'					=>
		'    Recv HAAD Reply (RUT): RUT (Link0) -&gt; MN0X',
	'rs_common'					=>
		'    Send RS w/o SLL: unspecified address -&gt; '.
		'all-routers multicast address',
	'ra_common'					=>
		'    Recv RA (H=1): RUT (Link0, link-local) -&gt; '.
		'all-nodes multicast address',

	'ra_delete_ha0_entry'				=>
		'    Send RA (H=0) w/ HAI (hapref=0) w/ PI (R=1): '.
		'HA0 (link-local) -&gt; all-nodes multicast address',
	'ra_delete_ha1_entry'				=>
		'    Send RA (H=0) w/ HAI (hapref=0) w/ PI (R=1): '.
		'HA1 (link-local) -&gt; all-nodes multicast address',
	'ra_delete_ha0_multiple_entry'			=>
		'    Send RA (H=0) w/ HAI (hapref=0) '.
		'w/ PI0 (R=1) w/ PI1 (R=1): '.
		'HA0 (link-local) -&gt; all-nodes multicast address',

	'linklocal_ereq_from_cn0_to_mn0'		=>
		'    Send Echo Request: '.
		'CN0 (link-local) -&gt; MN0 (link-local)',
	'dstunreach_ha0_cn0'				=>
		'    Recv Destination Unreachable: '.
		'RUT (Link0, link-local) -&gt; CN0 (link-local)',
	'dstunreach_ha0_cn0_hl_m1'			=>
		'    Recv Destination Unreachable: '.
		'RUT (Link0, link-local) -&gt; CN0 (link-local)',

	'timeexceeded_rx_rut'				=>
		'    Send Time Exceeded: '.
		'R0X -&gt; RUT (Link0, global)',

	'dst_unreach_rut_cn'				=>
		'    Recv Destination Unreachable: '.
		'RUT (Link0, global) -&gt; CN0Y',

	'dst_unreach_rut1_cn'				=>
		'    Recv Destination Unreachable: '.
		'RUT (Link1, global) -&gt; CN1Y',
);



#------------------------------#
# vLogHTML_()                  #
#------------------------------#
sub
vLogHTML_headline($) {
	my ($string) = @_;
	vLogHTML('<FONT SIZE="-1"><U><B>'.$string.'</B></U></FONT><BR>');
	return;
}



sub
vLogHTML_red($) {
	my ($string) = @_;
	vLogHTML('<FONT COLOR="#FF0000">'.$string.'</FONT><BR>');
	return;
}



sub
vLogHTML_redb($) {
	my ($string) = @_;
	vLogHTML('<FONT COLOR="#FF0000"><B>'.$string.'</B></FONT><BR>');
	return;
}



sub
vLogHTML_red5ub($) {
	my ($string) = @_;
	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.$string.'</B></U></FONT><BR>');
	return;
}



#------------------------------#
# pktdesc_movement()           #
#------------------------------#
sub
pktdesc_movement($)
{
	my ($movement) = @_;

	$pktdesc{'coa_ereq'}			=
		"    Send Echo Request: $mn{$movement} -&gt; RUT (Link0)";

	$pktdesc{'coa_erep'}			=
		"    Recv Echo Reply: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'coa_ereq_hao'}		=
		'    Send Echo Request w/ HaO: '.
		"$mn{$movement} -&gt; RUT (Link0)";

	$pktdesc{'mps_common'}			=
		'    Send MPS w/ HaO: '.
		"$mn{$movement} -&gt; RUT (Link0)";

	$pktdesc{'coa_ereq_hao_not_home_subnet'}	=
		'    Send Echo Request w/ HaO: '.
		"$mn{$movement} -&gt; RUT (Link0)";

	$pktdesc{'coa_erep_routing'}		=
		"    Recv Echo Reply w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'mpa_common'}		=
		"    Recv MPA w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'coa_erep_routing_not_home_subnet'}	=
		"    Recv Echo Reply w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'rx_mcast_ns_linklocal_sll'}	=
		'    Recv NS w/ SLL: '.
		"RUT ($link{$movement}, link-local) -&gt; ".
		"$router{$movement} solicited-node multicast address";

	$pktdesc{'rx_ucast_ns_linklocal_sll'}	=
		'    Recv NS w/ SLL: '.
		"RUT ($link{$movement}, link-local) -&gt; $router{$movement}";

	$pktdesc{'rx_ucast_ns_linklocal'}	=
		'    Recv NS w/o SLL: '.
		"RUT ($link{$movement}, link-local) -&gt; $router{$movement}";

	$pktdesc{'rx_na_linklocal'}		=
		'    Send NA (RSO) w/ TLL: '.
		"$router{$movement} -&gt; RUT ($link{$movement}, link-local)";

	$pktdesc{'rx_mcast_ns_global_sll'}	=
		'    Recv NS w/ SLL: '.
		"RUT ($link{$movement}, global) -&gt; ".
		"$router{$movement} solicited-node multicast address";

	$pktdesc{'rx_ucast_ns_global_sll'}	=
		'    Recv NS w/ SLL: '.
		"RUT ($link{$movement}, global) -&gt; $router{$movement}";

	$pktdesc{'rx_ucast_ns_global'}		=
		'    Recv NS w/o SLL: '.
		"RUT ($link{$movement}, global) -&gt; $router{$movement}";

	$pktdesc{'rx_na_global'}		=
		'    Send NA (RSO) w/ TLL: '.
		"$router{$movement} -&gt; RUT ($link{$movement}, global)";

	$pktdesc{'be_common'}			=
		"    Recv BE (stat:1): RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'be_common_not_home_subnet'}	=
		"    Recv BE (stat:1): RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'hoti_tunnel_common'}		=
		'    Send HoTI (reverse tunneled): '.
		"$mn{$movement} -&gt; RUT (Link0): MN0 -&gt; $cn{$movement}";

	$pktdesc{'hoti_common'}			=
		"    Recv HoTI: MN0 -&gt; $cn{$movement}";

	$pktdesc{'hot_tunnel_common'}		=
		'    Recv HoT (tunneled): '.
		"RUT (Link0) -&gt; $mn{$movement}: $cn{$movement} -&gt; MN0";

	$pktdesc{'hot_common'}			=
		"    Send HoT: $cn{$movement} -&gt; MN0";

	$pktdesc{'ereq_mn2cn_tunnel_common'}	=
		'    Send Echo Request (reverse tunneled): '.
		"$mn{$movement} -&gt; RUT (Link0): MN0 -&gt; $cn{$movement}";

	$pktdesc{'ereq_mn2cn_common'}		=
		"    Recv Echo Request: MN0 -&gt; $cn{$movement}";

	$pktdesc{'ereq_cn2mn_tunnel_common'}	=
		'    Recv Echo Request (tunneled): '.
		"RUT (Link0) -&gt; $mn{$movement}: $cn{$movement} -&gt; MN0";

	$pktdesc{'ereq_cn2mn_common'}		=
		"    Send Echo Request: $cn{$movement} -&gt; MN0";

	$pktdesc{'ereq_cn2lfn_tunnel_common'}	=
		'    Recv Echo Request (tunneled): '.
		"RUT (Link0) -&gt; $mn{$movement}: $cn{$movement} -&gt; LFN";

	$pktdesc{'ereq_cn2lfn_common'}		=
		"    Send Echo Request: $cn{$movement} -&gt; LFN";


	$pktdesc{'haad_request'}		=
		'    Send HAAD Request: '.
		"$mn{$movement} -&gt; Mobile IPv6 Home-Agents anycast address";

	$pktdesc{'haad_reply'}			=
		"    Recv HAAD Reply (RUT): RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'timeexceeded_rx_rut'}		=
		'    Send Time Exceeded: '.
		"$icmp_error_router{$movement} -&gt; RUT (Link0, global)";

	$pktdesc{'dst_unreach_rut_cn'}		=
		'    Recv Destination Unreachable: '.
		"RUT (Link0, global) -&gt; $cn{$movement}";

	$pktdesc{'dst_unreach_rut1_cn'}		=
		'    Recv Destination Unreachable: '.
		"RUT (Link1, global) -&gt; $cn{$movement}";

	return;
}



#------------------------------#
# pktdesc_cn0_scope()          #
#------------------------------#
sub
pktdesc_cn0_scope($)
{
	my ($cn0_scope) = @_;

	$pktdesc{'proxy_mcast_ns_global_sll'}		=
		"    Send NS w/ SLL: $cn0{$cn0_scope} -&gt; ".
			'MN0 (global) solicited-node multicast address';
	$pktdesc{'invalid_proxy_mcast_ns_global_sll'}	=
		"    Send NS (invalid target) w/ SLL: $cn0{$cn0_scope} -&gt; ".
			'MN0 (global) solicited-node multicast address';
	$pktdesc{'proxy_ucast_ns_global'}		=
		"    Send NS w/o SLL: $cn0{$cn0_scope} -&gt; MN0 (global)";
	$pktdesc{'invalid_proxy_ucast_ns_global'}	=
		'    Send NS (invalid target) w/o SLL: '.
		"$cn0{$cn0_scope} -&gt; MN0 (global)";
	$pktdesc{'proxy_ucast_ns_global_sll'}		=
		"    Send NS w/ SLL: $cn0{$cn0_scope} -&gt; MN0 (global)";
	$pktdesc{'invalid_proxy_ucast_ns_global_sll'}	=
		'    Send NS (invalid target) w/ SLL: '.
		"$cn0{$cn0_scope} -&gt; MN0 (global)";

	$pktdesc{'proxy_na_global_from_global'}	=
		'    Recv NA (rSo) w/o TLL: '.
			"RUT (Link0, global) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'invalid_proxy_na_global_from_global'}	=
		'    Recv NA (rSo, invalid target) w/o TLL: '.
			"RUT (Link0, global) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'proxy_na_global_from_linklocal'}	=
		'    Recv NA (rSo) w/o TLL: '.
			"RUT (Link0, link-local) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'invalid_proxy_na_global_from_linklocal'}	=
		'    Recv NA (rSo, invalid target) w/o TLL: '.
			"RUT (Link0, link-local) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'proxy_na_global_tll_from_global'}	=
		'    Recv NA (rSo) w/ TLL: '.
			"RUT (Link0, global) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'invalid_proxy_na_global_tll_from_global'}	=
		'    Recv NA (rSo, invalid target) w/ TLL: '.
			"RUT (Link0, global) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'proxy_na_global_tll_from_linklocal'}	=
		'    Recv NA (rSo) w/ TLL: '.
			"RUT (Link0, link-local) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'invalid_proxy_na_global_tll_from_linklocal'}	=
		'    Recv NA (rSo, invalid target) w/ TLL: '.
			"RUT (Link0, link-local) -&gt; $cn0{$cn0_scope}";

	$pktdesc{'proxy_mcast_ns_linklocal_sll'}		=
		"    Send NS w/ SLL: $cn0{$cn0_scope} -&gt; ".
			'MN0 (link-local) solicited-node multicast address';
	$pktdesc{'invalid_proxy_mcast_ns_linklocal_sll'}	=
		"    Send NS (invalid target) w/ SLL: $cn0{$cn0_scope} -&gt; ".
			'MN0 (link-local) solicited-node multicast address';
	$pktdesc{'proxy_ucast_ns_linklocal'}			=
		"    Send NS w/o SLL: $cn0{$cn0_scope} -&gt; MN0 (link-local)";
	$pktdesc{'invalid_proxy_ucast_ns_linklocal'}		=
		'    Send NS (invalid target) w/o SLL: '.
		"$cn0{$cn0_scope} -&gt; MN0 (link-local)";
	$pktdesc{'proxy_ucast_ns_linklocal_sll'}		=
		"    Send NS w/ SLL: $cn0{$cn0_scope} -&gt; MN0 (link-local)";
	$pktdesc{'invalid_proxy_ucast_ns_linklocal_sll'}	=
		'    Send NS (invalid target) w/ SLL: '.
		"$cn0{$cn0_scope} -&gt; MN0 (link-local)";
	$pktdesc{'proxy_na_linklocal_from_global'}		=
		'    Recv NA (rSo) w/o TLL: '.
			"RUT (Link0, global) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'invalid_proxy_na_linklocal_from_global'}	=
		'    Recv NA (rSo, invalid target) w/o TLL: '.
			"RUT (Link0, global) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'proxy_na_linklocal_from_linklocal'}	=
		'    Recv NA (rSo) w/o TLL: '.
			"RUT (Link0, link-local) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'invalid_proxy_na_linklocal_from_linklocal'}	=
		'    Recv NA (rSo, invalid target) w/o TLL: '.
			"RUT (Link0, link-local) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'proxy_na_linklocal_tll_from_global'}		=
		'    Recv NA (rSo) w/ TLL: '.
			"RUT (Link0, global) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'invalid_proxy_na_linklocal_tll_from_global'}		=
		'    Recv NA (rSo, invalid target) w/ TLL: '.
			"RUT (Link0, global) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'proxy_na_linklocal_tll_from_linklocal'}	=
		'    Recv NA (rSo) w/ TLL: '.
			"RUT (Link0, link-local) -&gt; $cn0{$cn0_scope}";
	$pktdesc{'invalid_proxy_na_linklocal_tll_from_linklocal'}	=
		'    Recv NA (rSo, invalid target) w/ TLL: '.
			"RUT (Link0, link-local) -&gt; $cn0{$cn0_scope}";

	$pktdesc{'cn0_mcast_ns_linklocal_sll'}		=
		'    Recv NS w/ SLL: RUT (Link0, link-local) -&gt; '.
			"$cn0{$cn0_scope} solicited-node multicast address";
	$pktdesc{'cn0_mcast_ns_global_sll'}		=
		'    Recv NS w/ SLL: RUT (Link0, global) -&gt; '.
			"$cn0{$cn0_scope} solicited-node multicast address";
	$pktdesc{'cn0_na_linklocal'}			=
		'    Send NA (rSO) w/ TLL: '.
			"$cn0{$cn0_scope} -&gt; RUT (Link0, link-local)";
	$pktdesc{'cn0_na_global'}			=
		'    Send NA (rSO) w/ TLL: '.
			"$cn0{$cn0_scope} -&gt; RUT (Link0, global)";

	return;
}



#------------------------------#
# read_sequence_def()          #
#------------------------------#
sub
read_sequence_def()
{
	if(-r $sequence_def) {
		local(*INPUT);

		unless(open(INPUT, $sequence_def)) {
			vLogHTML_red("open: $sequence_def: $!");

			return($false);
		}

		my $SA1_SEQ	= 0;
		my $SA3_SEQ	= 0;
		my $SA5_SEQ	= 0;
		my $SA7_SEQ	= 0;
		my $SA9_SEQ	= 0;
		my $nest_SA1_SEQ	= 0;
		my $nest_SA3_SEQ	= 0;
		my $nest_SA5_SEQ	= 0;
		my $nest_SA7_SEQ	= 0;
		my $nest_SA9_SEQ	= 0;

		while(<INPUT>) {
			chomp;

			if($_ =~ /^\s*#define\s+(\S+)\s+(\S+)\s*$/) {
				eval("\$$1\t= $2\n");
			}
		}

		close(INPUT);

		$sequence{'SA1_SEQ'}	= $SA1_SEQ;
		$sequence{'SA3_SEQ'}	= $SA3_SEQ;
		$sequence{'SA5_SEQ'}	= $SA5_SEQ;
		$sequence{'SA7_SEQ'}	= $SA7_SEQ;
		$sequence{'SA9_SEQ'}	= $SA7_SEQ;
		$sequence{'nest_SA1_SEQ'}	= $SA1_SEQ;
		$sequence{'nest_SA3_SEQ'}	= $SA3_SEQ;
		$sequence{'nest_SA5_SEQ'}	= $SA5_SEQ;
		$sequence{'nest_SA7_SEQ'}	= $SA7_SEQ;
		$sequence{'nest_SA9_SEQ'}	= $SA7_SEQ;
	}

	return($true);
}



#------------------------------#
# overwrite_sequence_def()     #
#------------------------------#
sub
overwrite_sequence_def()
{
	local(*OUTPUT);

	unless(open(OUTPUT, "> $sequence_def")) {
		vLogHTML("<FONT COLOR=\"#FF0000\">open: $sequence_def: $!".
			'</FONT><BR>');

		return($false);
	}

	print(OUTPUT "#ifndef HAVE_SEQUENCE_DEF\n");
	print(OUTPUT "#define HAVE_SEQUENCE_DEF\n");

	foreach my $key (sort(keys(%sequence))) {
		print(OUTPUT "\n");
		print(OUTPUT "#ifndef $key\n");
		print(OUTPUT "#define $key\t$sequence{$key}\n");
		print(OUTPUT "#endif\t// $key\n");
	}

	print(OUTPUT "#endif\t// HAVE_SEQUENCE_DEF\n");

	close(OUTPUT);

	return($true);
}



#------------------------------#
# update_seq_sa1_sa2()         #
#------------------------------#
sub
update_seq_sa1_sa2($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($USE_SA1_SA2) {
				$sequence{'SA1_SEQ'} ++;
				$sequence{'SA1_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#------------------------------#
# update_seq_sa3_sa4()         #
#------------------------------#
sub
update_seq_sa3_sa4($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($USE_SA3_SA4) {
				$sequence{'SA3_SEQ'} ++;
				$sequence{'SA3_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			if($HOA_ADDRESS && $USE_SA9_SA10) {
				$sequence{'SA9_SEQ'} ++;
				$sequence{'SA9_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#------------------------------#
# update_seq_sa5_sa6()         #
#------------------------------#
sub
update_seq_sa5_sa6($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($UNIQ_TRANS_SA && $USE_SA5_SA6) {
				$sequence{'SA5_SEQ'} ++;
				$sequence{'SA5_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			if(!$UNIQ_TRANS_SA && $USE_SA1_SA2) {
				$sequence{'SA1_SEQ'} ++;
				$sequence{'SA1_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#------------------------------#
# update_seq_sa7_sa8()         #
#------------------------------#
sub
update_seq_sa7_sa8($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($UNIQ_TUNNEL_SA && $USE_SA7_SA8) {
				$sequence{'SA7_SEQ'} ++;
				$sequence{'SA7_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			if(!$UNIQ_TUNNEL_SA && $USE_SA3_SA4) {
				$sequence{'SA3_SEQ'} ++;
				$sequence{'SA3_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			if($HOA_ADDRESS && $USE_SA9_SA10) {
				$sequence{'SA9_SEQ'} ++;
				$sequence{'SA9_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#------------------------------#
# update_seq_sa9_sa10()        #
#------------------------------#
sub
update_seq_sa9_sa10($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($USE_SA9_SA10) {
				$sequence{'SA9_SEQ'} ++;
				$sequence{'SA9_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#-----------------------------------#
# update_seq_nest_sa1_sa2()         #
#-----------------------------------#
sub
update_seq_nest_sa1_sa2($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($USE_SA1_SA2) {
				$sequence{'nest_SA1_SEQ'} ++;
				$sequence{'nest_SA1_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#-----------------------------------#
# update_seq_nest_sa3_sa4()         #
#-----------------------------------#
sub
update_seq_nest_sa3_sa4($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($USE_SA3_SA4) {
				$sequence{'nest_SA3_SEQ'} ++;
				$sequence{'nest_SA3_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			if($HOA_ADDRESS && $USE_SA9_SA10) {
				$sequence{'nest_SA9_SEQ'} ++;
				$sequence{'nest_SA9_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#-----------------------------------#
# update_seq_nest_sa5_sa6()         #
#-----------------------------------#
sub
update_seq_nest_sa5_sa6($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($UNIQ_TRANS_SA && $USE_SA5_SA6) {
				$sequence{'nest_SA5_SEQ'} ++;
				$sequence{'nest_SA5_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			if(!$UNIQ_TRANS_SA && $USE_SA1_SA2) {
				$sequence{'nest_SA1_SEQ'} ++;
				$sequence{'nest_SA1_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#------------------------------#
# update_seq_nest_sa7_sa8()    #
#------------------------------#
sub
update_seq_nest_sa7_sa8($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($UNIQ_TUNNEL_SA && $USE_SA7_SA8) {
				$sequence{'nest_SA7_SEQ'} ++;
				$sequence{'nest_SA7_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			if(!$UNIQ_TUNNEL_SA && $USE_SA3_SA4) {
				$sequence{'nest_SA3_SEQ'} ++;
				$sequence{'nest_SA3_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			if($HOA_ADDRESS && $USE_SA9_SA10) {
				$sequence{'nest_SA9_SEQ'} ++;
				$sequence{'nest_SA9_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#------------------------------------#
# update_seq_nest_sa9_sa10()         #
#------------------------------------#
sub
update_seq_nest_sa9_sa10($$)
{
	my (
		$cpp,
		$use_ipsec
	) = @_;

	my $bool	= $false;

	if($HAVE_IPSEC) {
		for( ; ; ) {
			if($USE_SA9_SA10) {
				$sequence{'nest_SA9_SEQ'} ++;
				$sequence{'nest_SA9_SEQ'} &= 0xffffffff;

				$bool	= $true;
				last;
			}

			last;
		}

		if($bool && !overwrite_sequence_def()) {
			exitFatal();
		}

		if($bool) {
			$$use_ipsec = $true;
			$$cpp .= "-DUSE_SEQUENCE_DEF ";
		}
	}

	return($bool);
}



#------------------------------#
# mipv6init()                  #
#------------------------------#
sub
mipv6init($)
{
	my ($movement) = @_;

	dump_configuration();

	if($V6evalTool::NutDef{'Type'} ne 'router') {
		exitRouterOnly();
	}

	vLogHTML_red5ub('INITIALIZATION');

	if($HAVE_HOME_LINK) {
		vCapture($Link0);
		$capture_link0	= $true;
	}

	if($HAVE_FOREIGN_LINK) {
		vCapture($Link1);
		$capture_link1	= $true;
	}

	IKEapi::IKEInit('HA',[ERR,INF1,INF2,SEQ,JDG]);
	# IKEapi::IKEInit('HA',[ERR,WARN,INF1,INF2,DBG,SEQ,JDG]);

	if(!$NEED_REBOOT && !$ROTATE_HOA) {
		if($HAVE_IPSEC) {
			if(!initESP()) {
				return($false);
			}
		}
	}

	if($NEED_REBOOT) {
		if(!rebootRUT()) {
			return($false);
		}
	}

	if($NEED_ANYCAST) {
		if(vRemote('manualaddrconf.rmt',
			"if=$Link0_device",
			'addr=3ffe:501:ffff:100:fdff:ffff:ffff:fffe',
			'len=64',
			'type=anycast',
			'')) {
			vLogHTML_red('manualaddrconf.rmt: Couldn\'t assign the address.');
			exitFatal();
		}
	}

	if($NEED_ENABLE) {
		if(vRemote('mip6EnableHA.rmt',
			"device=$Link0_device",
			($HAVE_IPSEC && $USE_SA1_SA2)? 'ipsec': '',
			'')) {
			vLogHTML_red('mip6EnableHA.rmt: Can\'t enable HA function');
			exitFatal();
		}
	}

	if($NEED_ROUTE) {
		if(!configureRoute()) {
			return($false);
		}
	}

	if($NEED_IPSEC) {
		if($HAVE_IPSEC) {
			if(!configureIPsec_ex($movement)) {
				return($false);
			}
		}
	}

	if($NEED_RA) {
		if(vRemote('racontrol.rmt',
			'mode=start',
			'mipv6',
			'hapref=10',
			'hatime=1800',
			"link0=$Link0_device",
			'')) {
			vLogHTML_red('racontrol.rmt: Couldn\'t start to send RA');
			exitFatal();
		}
	}

	unless(reachabilityConfirmations()) {
		return($false);
	}

	return($true);
}



#------------------------------#
# dump_configuration()         #
#------------------------------#
sub
dump_configuration()
{
	vLogHTML_red5ub('CONFIGURATION');

	vLogHTML('<HR>');



	vLogHTML('o <U><B><TT>Initialization</TT></B></U>');

	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE BORDER>');

	dump_bool('NEED_REBOOT');
	dump_second('REBOOT_TIMEOUT');
	dump_bool('ROTATE_HOA');

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');



	vLogHTML('o <U><B><TT>Physical Topology</TT></B></U>');

	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE BORDER>');

	dump_bool('HAVE_HOME_LINK');
	dump_bool('HAVE_FOREIGN_LINK');

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');



	vLogHTML('o <U><B><TT>Home address</TT></B></U>');

	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE BORDER>');

	dump_bool('HOME_ADDRESS');

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');



	vLogHTML('o <U><B><TT>BU mode</TT></B></U>');

	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE BORDER>');

	dump_bool('BU_MODE');

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');



	vLogHTML('o <U><B><TT>Available Functions</TT></B></U>');

	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE BORDER>');

	dump_bool('HAVE_DHAAD');
	dump_bool('HAVE_MPD');

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');



	vLogHTML('o <U><B><TT>IPsec</TT></B></U>');

	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE BORDER>');

	dump_bool('HAVE_IPSEC');

	if($HAVE_IPSEC) {
		dump_bool('UNIQ_TRANS_SA');
		dump_bool('GRAN_TRANS_SA_TYPE');
		dump_bool('UNIQ_TUNNEL_SA');
		dump_bool('GRAN_TUNNEL_SA_TYPE');

		dump_bool('USE_SA1_SA2');
		dump_bool('USE_SA3_SA4');

		if($UNIQ_TRANS_SA) {
			dump_bool('USE_SA5_SA6');
		}

		if($UNIQ_TUNNEL_SA) {
			dump_bool('USE_SA7_SA8');
		}

		dump_bool('USE_SA9_SA10');
	}

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');

	if($HAVE_IPSEC && !$HAVE_IKE) {
		vLogHTML('<BLOCKQUOTE>');

		if($USE_SA1_SA2) {
			dump_sa('SA1');
			dump_sa('SA2');
		}

		if($USE_SA3_SA4) {
			dump_sa('SA3');
			dump_sa('SA4');
		}

		if($UNIQ_TRANS_SA && $USE_SA5_SA6) {
			dump_sa('SA5');
			dump_sa('SA6');
		}

		if($UNIQ_TUNNEL_SA && $USE_SA7_SA8) {
			dump_sa('SA7');
			dump_sa('SA8');
		}

		if($USE_SA9_SA10) {
			dump_sa('SA9');
			dump_sa('SA10');
		}

		vLogHTML('</BLOCKQUOTE>');
	}

	vLogHTML('<HR>');

	return;
}



#------------------------------#
# dump_bool()                  #
#------------------------------#
sub
dump_bool($)
{
	my ($key) = @_;

	vLogHTML('<TR>');
	vLogHTML("<TD><TT>$key</TT></TD>");

	if($$key) {
		vLogHTML('<TD><TT>true</TT></TD>');
	} else {
		vLogHTML('<TD><TT>false</TT></TD>');
	}

	vLogHTML('</TR>');

	return;
}



#------------------------------#
# dump_second()                #
#------------------------------#
sub
dump_second($)
{
	my ($key) = @_;

	vLogHTML('<TR>');
	vLogHTML("<TD><TT>$key</TT></TD>");
	vLogHTML("<TD><TT>$$key sec.</TT></TD>");
	vLogHTML('</TR>');

	return;
}



#------------------------------#
# dump_sa()                    #
#------------------------------#
sub
dump_sa($)
{
	my ($key) = @_;

	vLogHTML("o <U><B><TT>$key</TT></B></U>");

	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE BORDER>');

	unless($HAVE_IKE) {
		dump_value($key. '_SPI');
	}

	dump_bool('USE_'. $key. '_DES_CBC');

	unless($HAVE_IKE) {
		dump_value($key. '_ENC_KEY');
	}

	dump_bool('USE_'. $key. '_HMAC_MD5');

	unless($HAVE_IKE) {
		dump_value($key. '_HASH_KEY');
	}

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');

	return;
}



#------------------------------#
# dump_value()                 #
#------------------------------#
sub
dump_value($)
{
	my ($key) = @_;

	vLogHTML('<TR>');
	vLogHTML("<TD><TT>$key</TT></TD>");
	vLogHTML("<TD><TT>$$key</TT></TD>");
	vLogHTML('</TR>');

	return;
}



#------------------------------#
# initESP()                    #
#------------------------------#
sub
initESP()
{
	unless(read_sequence_def() && overwrite_sequence_def()) {
		exitFatal();
	}

	my $cpp = '-DUSE_SEQUENCE_DEF';
	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	return($true);
}



#------------------------------#
# rebootRUT()                  #
#------------------------------#
sub
rebootRUT()
{
	vLogHTML_headline('reboot RUT');

	if(vRemote('reboot.rmt', "timeout=$REBOOT_TIMEOUT", '')) {
		vLogHTML_redb('reboot.rmt: Couldn\'t reboot');

		exitFatal();
	}

	return($true);
}



#------------------------------#
# configureRoute()             #
#------------------------------#
sub
configureRoute()
{
	vLogHTML_headline('configure Route');

	if($HAVE_HOME_LINK) {
		if(vRemote('route.rmt', 'cmd=add',
			'prefix=default',
			"gateway=fe80::200:ff:fe00:a0a0", "if=$Link0_device")) {

			vLogHTML_red('route.rmt: Can\'t configure route');
			exitFatal();
		}

		if(!($BU_MODE)) {
			if(vRemote('route.rmt', 'cmd=add',
				'prefix=3ffe:501:ffff:111::', 'prefixlen=64',
				"gateway=fe80::200:ff:fe00:11", "if=$Link0_device")) {

				vLogHTML_red('route.rmt: Can\'t configure route');
				exitFatal();
			}
			if(vRemote('route.rmt', 'cmd=add',
				'prefix=3ffe:501:ffff:112::', 'prefixlen=64',
				"gateway=fe80::200:ff:fe00:12", "if=$Link0_device")) {

				vLogHTML_red('route.rmt: Can\'t configure route');
				exitFatal();
			}
			if(vRemote('route.rmt', 'cmd=add',
				'prefix=3ffe:501:ffff:113::', 'prefixlen=64',
				"gateway=fe80::200:ff:fe00:12", "if=$Link0_device")) {

				vLogHTML_red('route.rmt: Can\'t configure route');
				exitFatal();
			}
			if(vRemote('route.rmt', 'cmd=add',
				'prefix=3ffe:501:ffff:114::', 'prefixlen=64',
				"gateway=fe80::200:ff:fe00:14", "if=$Link0_device")) {

				vLogHTML_red('route.rmt: Can\'t configure route');
				exitFatal();
			}
		}
		else {
			if(vRemote('route.rmt', 'cmd=add',
				'prefix=3ffe:501:ffff:121::', 'prefixlen=64',
				"gateway=fe80::200:ff:fe00:21", "if=$Link0_device")) {

				vLogHTML_red('route.rmt: Can\'t configure route');
				exitFatal();
			}
			if(vRemote('route.rmt', 'cmd=add',
				'prefix=3ffe:501:ffff:122::', 'prefixlen=64',
				"gateway=fe80::200:ff:fe00:22", "if=$Link0_device")) {

				vLogHTML_red('route.rmt: Can\'t configure route');
				exitFatal();
			}
			if(vRemote('route.rmt', 'cmd=add',
				'prefix=3ffe:501:ffff:123::', 'prefixlen=64',
				"gateway=fe80::200:ff:fe00:22", "if=$Link0_device")) {

				vLogHTML_red('route.rmt: Can\'t configure route');
				exitFatal();
			}
			if(vRemote('route.rmt', 'cmd=add',
				'prefix=3ffe:501:ffff:124::', 'prefixlen=64',
				"gateway=fe80::200:ff:fe00:24", "if=$Link0_device")) {

				vLogHTML_red('route.rmt: Can\'t configure route');
				exitFatal();
			}
		}
	}

	if($HAVE_HOME_LINK && $HAVE_FOREIGN_LINK) {
		if(vRemote('route.rmt', 'cmd=add',
			'prefix=3ffe:501:ffff:1101::', 'prefixlen=64',
			"gateway=fe80::200:ff:fe00:a1a1", "if=$Link1_device")) {

			vLogHTML_red('route.rmt: Can\'t configure route');
			exitFatal();
		}

		if(vRemote('route.rmt', 'cmd=add',
			'prefix=3ffe:501:ffff:2101::', 'prefixlen=64',
			"gateway=fe80::200:ff:fe00:a1a1", "if=$Link1_device")) {

			vLogHTML_red('route.rmt: Can\'t configure route');
			exitFatal();
		}

		if(vRemote('route.rmt', 'cmd=add',
			'prefix=3ffe:501:ffff:3101::', 'prefixlen=64',
			"gateway=fe80::200:ff:fe00:a1a1", "if=$Link1_device")) {

			vLogHTML_red('route.rmt: Can\'t configure route');
			exitFatal();
		}
	}

	if(!$HAVE_HOME_LINK && $HAVE_FOREIGN_LINK) {
		if(vRemote('route.rmt', 'cmd=add',
			'prefix=default',
			"gateway=fe80::200:ff:fe00:a1a1", "if=$Link1_device")) {

			vLogHTML_red('route.rmt: Can\'t configure route');
			exitFatal();
		}
	}

	return($true);
}



#------------------------------#
# configureIPsec_ex()          #
#------------------------------#
sub
configureIPsec_ex($)
{
	my ($movement) = @_;

	my $home_agent      = '';
	my $mobile_node     = '';
	my $mobile_prefix   = '';
	my $mobile_prefix_2 = '';
	my %adr;

	my %adr_HNP_implicit = (
		'1' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:100:200:ff:fe00:11',
			'NEMO_PREFIX'   => '3ffe:501:ffff:111::/64',
		},
		'2' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:100:200:ff:fe00:12',
			'NEMO_PREFIX'   => '3ffe:501:ffff:112::/64',
			'NEMO_PREFIX_2' => '3ffe:501:ffff:113::/64',
		},
		'4' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:100:200:ff:fe00:14',
			'NEMO_PREFIX'   => '3ffe:501:ffff:114::/64',
		},
	);

	my %adr_HNP_explicit = (
		'1' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:100:200:ff:fe00:21',
			'NEMO_PREFIX'   => '3ffe:501:ffff:121::/64',
		},
		'2' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:100:200:ff:fe00:22',
			'NEMO_PREFIX'   => '3ffe:501:ffff:122::/64',
			'NEMO_PREFIX_2' => '3ffe:501:ffff:123::/64',
		},
		'4' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:100:200:ff:fe00:24',
			'NEMO_PREFIX'   => '3ffe:501:ffff:124::/64',
		},
	);

	my %adr_MNP_implicit = (
		'1' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:111:200:ff:fe00:11',
			'NEMO_PREFIX'   => '3ffe:501:ffff:111::/64',
		},
		'2' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:112:200:ff:fe00:12',
			'NEMO_PREFIX'   => '3ffe:501:ffff:112::/64',
			'NEMO_PREFIX_2' => '3ffe:501:ffff:113::/64',
		},
		'4' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:114:200:ff:fe00:14',
			'NEMO_PREFIX'   => '3ffe:501:ffff:114::/64',
		},
	);

	my %adr_MNP_explicit = (
		'1' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:121:200:ff:fe00:21',
			'NEMO_PREFIX'   => '3ffe:501:ffff:121::/64',
		},
		'2' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:122:200:ff:fe00:22',
			'NEMO_PREFIX'   => '3ffe:501:ffff:122::/64',
			'NEMO_PREFIX_2' => '3ffe:501:ffff:123::/64',
		},
		'4' => {
			'HOME_ADDRESS'  => '3ffe:501:ffff:124:200:ff:fe00:24',
			'NEMO_PREFIX'   => '3ffe:501:ffff:124::/64',
		},
	);

	if ($HOA_ADDRESS == 0) {
		if ($BU_MODE == 0) {
			%adr = %adr_HNP_implicit;
		}
		else {
			%adr = %adr_HNP_explicit;
		}
	}
	else {
		if ($BU_MODE == 0) {
			%adr = %adr_MNP_implicit;
		}
		else {
			%adr = %adr_MNP_explicit;
		}
	}

	unless(calculate_addrs_ha(\$home_agent)) {
		return($false);
	}

	vLogHTML_red5ub('configure SPD and SAD');

	if (vRemote('ipsecClearAll.rmt', '')) {
		vLogHTML_redb('ipsecClearAll.rmt: Can\'t clear IPsec configuration.');
		exitFatal();
	}

	foreach $no (@mrs) {

		$mobile_node     = $adr{$no}->{HOME_ADDRESS};
		$mobile_prefix   = $adr{$no}->{NEMO_PREFIX};
		$mobile_prefix_2 = $adr{$no}->{NEMO_PREFIX_2};

		print "mobile_node     = $mobile_node\n";
		print "mobile_prefix   = $mobile_prefix\n";
		print "mobile_prefix_2 = $mobile_prefix_2\n";

		if ($USE_SA1_SA2 &&
			!configureIPsec_SA1_SA2_ex($no, $home_agent, $mobile_node)) {

			return($false);
		}

		if ($USE_SA3_SA4 &&
			!configureIPsec_SA3_SA4_ex($no, $home_agent, $mobile_node)) {

			return($false);
		}

		if ($UNIQ_TRANS_SA && $USE_SA5_SA6 &&
			!configureIPsec_SA5_SA6_ex($no, $home_agent, $mobile_node)) {

			return($false);
		}

		if ($UNIQ_TUNNEL_SA && $USE_SA7_SA8 &&
			!configureIPsec_SA7_SA8_ex($no, $home_agent, $mobile_node)) {

			return($false);
		}

		if ($UNIQ_TUNNEL_SA && $USE_SA9_SA10 &&
			!configureIPsec_SA9_SA10_ex($no, $home_agent, $mobile_node, $mobile_prefix, $mobile_prefix_2)) {

			return($false);
		}

	}

	if (vRemote('ipsecEnable.rmt', '')) {
		vLogHTML_redb('ipsecEnable.rmt: Can\'t enable IPsec function.');

		exitFatal();
	}

	return($true);
}



#------------------------------#
# calculate_addrs_ha()         #
#------------------------------#
sub
calculate_addrs_ha($)
{
	my ($home_agent) = @_;

	vLogHTML_headline('calculate RUT address');

	$pktdesc{'calculate_home_agent'} =
		'    Send dummy packet for RUT address calculation';

	my %magic	= (
		'calculate_home_agent'	=> $home_agent,
	);

	my $TargetAddress = 'Frame_Ether.Packet_IPv6.ICMPv6_NS.TargetAddress';
	my $SourceAddress = 'Frame_Ether.Hdr_Ether.SourceAddress';

	vClear($capture_link0? $Link0: $Link1);

	foreach my $dummy (sort(keys(%magic))) {
		my %ret = vSend($capture_link0? $Link0: $Link1, $dummy);

		unless(defined($ret{$TargetAddress})) {
			vLogHTML_redb('calculate_addrs: Can\'t get TargetAddress.');

			return($false);
		}

		my $ref = $magic{$dummy};
		$$ref = $ret{$TargetAddress};
	}

	IKEvRecv($capture_link0? $Link0: $Link1,
		$MAX_RTR_SOLICITATION_DELAY + $RETRANS_TIMER * $DupAddrDetectTransmits + 1, 0, 0);

	vLogHTML("<FONT SIZE=\"-1\"><B>".
		"HA(inet6): $$home_agent</B></FONT><BR>");

	return($true);
}



#------------------------------#
# configureIPsec_SA1_SA2_ex()  #
#------------------------------#
sub
configureIPsec_SA1_SA2_ex($$$)
{
	my ($no, $home_agent, $mobile_node) = @_;

	my %sas = (
		'1' => {
			'sa1_spi'       => $SA1_SPI,
			'sa1_ealgokey'  => $SA1_ENC_KEY,
			'sa1_eauthkey'  => $SA1_HASH_KEY,
			'sa1_unique'    => $SA1_SPI,
			'sa2_spi'       => $SA2_SPI,
			'sa2_ealgokey'  => $SA2_ENC_KEY,
			'sa2_eauthkey'  => $SA2_HASH_KEY,
			'sa2_unique'    => $SA2_SPI,
		},
		'2' => {
			'sa1_spi'       => $D2_SA1_SPI,
			'sa1_ealgokey'  => $D2_SA1_ENC_KEY,
			'sa1_eauthkey'  => $D2_SA1_HASH_KEY,
			'sa1_unique'    => $D2_SA1_SPI,
			'sa2_spi'       => $D2_SA2_SPI,
			'sa2_ealgokey'  => $D2_SA2_ENC_KEY,
			'sa2_eauthkey'  => $D2_SA2_HASH_KEY,
			'sa2_unique'    => $D2_SA2_SPI,
		},
		'4' => {
			'sa1_spi'       => $D4_SA1_SPI,
			'sa1_ealgokey'  => $D4_SA1_ENC_KEY,
			'sa1_eauthkey'  => $D4_SA1_HASH_KEY,
			'sa1_unique'    => $D4_SA1_SPI,
			'sa2_spi'       => $D4_SA2_SPI,
			'sa2_ealgokey'  => $D4_SA2_ENC_KEY,
			'sa2_eauthkey'  => $D4_SA2_HASH_KEY,
			'sa2_unique'    => $D4_SA2_SPI,
		},
	);

	my $sa;
	$sa = $sas{$no};

	vLogHTML_headline('configure SA1/SA2');

	# SA1: MN->HA ESP transport mode (BU)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$mobile_node",
		"dst=$home_agent",
		'protocol=esp',
		"spi=$sa->{sa1_spi}",
		'mode=transport',
		$USE_SA1_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa1_ealgokey}\"",
		$USE_SA1_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa1_eauthkey}\"",
		"unique=$sa->{sa1_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		"src=$mobile_node",
		"dst=$home_agent",
		$UNIQ_TRANS_SA? 'upperspec=135': 'upperspec=any',
		$GRAN_TRANS_SA_TYPE? 'msgtype=5': 'msgtype=any',
		'direction=in',
		'policy=ipsec',
		'protocol=esp',
		'mode=transport',
		'level=unique',
		"unique=$sa->{sa1_unique}",
		'ommit',
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	# SA2: HA->MN ESP transport mode (BA)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$home_agent",
		"dst=$mobile_node",
		'protocol=esp',
		"spi=$sa->{sa2_spi}",
		'mode=transport',
		$USE_SA2_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa2_ealgokey}\"",
		$USE_SA2_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa2_eauthkey}\"",
		"unique=$sa->{sa2_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		"src=$home_agent",
		"dst=$mobile_node",
		$UNIQ_TRANS_SA? 'upperspec=135': 'upperspec=any',
		$GRAN_TRANS_SA_TYPE? 'msgtype=6': 'msgtype=any',
		'direction=out',
		'policy=ipsec',
		'protocol=esp',
		'mode=transport',
		'level=unique',
		"unique=$sa->{sa2_unique}",
		'ommit',
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	return($true);
}



#------------------------------#
# configureIPsec_SA3_SA4_ex()  #
#------------------------------#
sub
configureIPsec_SA3_SA4_ex($$$)
{
	my ($no, $home_agent, $mobile_node) = @_;

	my %sas = (
		'1' => {
			'sa3_spi'       => $SA3_SPI,
			'sa3_ealgokey'  => $SA3_ENC_KEY,
			'sa3_eauthkey'  => $SA3_HASH_KEY,
			'sa3_unique'    => $SA3_SPI,
			'sa4_spi'       => $SA4_SPI,
			'sa4_ealgokey'  => $SA4_ENC_KEY,
			'sa4_eauthkey'  => $SA4_HASH_KEY,
			'sa4_unique'    => $SA4_SPI,
		},
		'2' => {
			'sa3_spi'       => $D2_SA3_SPI,
			'sa3_ealgokey'  => $D2_SA3_ENC_KEY,
			'sa3_eauthkey'  => $D2_SA3_HASH_KEY,
			'sa3_unique'    => $D2_SA3_SPI,
			'sa4_spi'       => $D2_SA4_SPI,
			'sa4_ealgokey'  => $D2_SA4_ENC_KEY,
			'sa4_eauthkey'  => $D2_SA4_HASH_KEY,
			'sa4_unique'    => $D2_SA4_SPI,
		},
		'4' => {
			'sa3_spi'       => $D4_SA3_SPI,
			'sa3_ealgokey'  => $D4_SA3_ENC_KEY,
			'sa3_eauthkey'  => $D4_SA3_HASH_KEY,
			'sa3_unique'    => $D4_SA3_SPI,
			'sa4_spi'       => $D4_SA4_SPI,
			'sa4_ealgokey'  => $D4_SA4_ENC_KEY,
			'sa4_eauthkey'  => $D4_SA4_HASH_KEY,
			'sa4_unique'    => $D4_SA4_SPI,
		},
	);

	my $sa;
	$sa = $sas{$no};

	vLogHTML_headline('configure SA3/SA4');

	# SA3: MN->HA ESP tunnel mode (HoTI)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$mobile_node",
		"dst=$home_agent",
		'protocol=esp',
		"spi=$sa->{sa3_spi}",
		'mode=tunnel',
		$USE_SA3_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa3_ealgokey}\"",
		$USE_SA3_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa3_eauthkey}\"",
		"unique=$sa->{sa3_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		"src=$mobile_node",
		'dst=::/0',
		$UNIQ_TUNNEL_SA? 'upperspec=135': 'upperspec=any',
		$GRAN_TUNNEL_SA_TYPE? 'msgtype=1': 'msgtype=any',
		'direction=in',
		'policy=ipsec',
		'protocol=esp',
		'mode=tunnel',
		"tsrc=$mobile_node",
		"tdst=$home_agent",
		'level=unique',
		"unique=$sa->{sa3_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	# SA4: HA->MN ESP tunnel mode (HoT)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$home_agent",
		"dst=$mobile_node",
		'protocol=esp',
		"spi=$sa->{sa4_spi}",
		'mode=tunnel',
		$USE_SA4_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa4_ealgokey}\"",
		$USE_SA4_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa4_eauthkey}\"",
		"unique=$sa->{sa4_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		'src=::/0',
		"dst=$mobile_node",
		$UNIQ_TUNNEL_SA? 'upperspec=135': 'upperspec=any',
		$GRAN_TUNNEL_SA_TYPE? 'msgtype=6': 'msgtype=any',
		'direction=out',
		'policy=ipsec',
		'protocol=esp',
		'mode=tunnel',
		"tsrc=$home_agent",
		"tdst=$mobile_node",
		'level=unique',
		"unique=$sa->{sa4_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	return($true);
}



#-----------------------------#
# configureIPsec_SA5_SA6_ex() #
#-----------------------------#
sub
configureIPsec_SA5_SA6_ex($$$)
{
	my ($no, $home_agent, $mobile_node) = @_;

	my %sas = (
		'1' => {
			'sa5_spi'       => $SA5_SPI,
			'sa5_ealgokey'  => $SA5_ENC_KEY,
			'sa5_eauthkey'  => $SA5_HASH_KEY,
			'sa5_unique'    => $SA5_SPI,
			'sa6_spi'       => $SA6_SPI,
			'sa6_ealgokey'  => $SA6_ENC_KEY,
			'sa6_eauthkey'  => $SA6_HASH_KEY,
			'sa6_unique'    => $SA6_SPI,
		},
		'2' => {
			'sa5_spi'       => $D2_SA5_SPI,
			'sa5_ealgokey'  => $D2_SA5_ENC_KEY,
			'sa5_eauthkey'  => $D2_SA5_HASH_KEY,
			'sa5_unique'    => $D2_SA5_SPI,
			'sa6_spi'       => $D2_SA6_SPI,
			'sa6_ealgokey'  => $D2_SA6_ENC_KEY,
			'sa6_eauthkey'  => $D2_SA6_HASH_KEY,
			'sa6_unique'    => $D2_SA6_SPI,
		},
		'4' => {
			'sa5_spi'       => $D4_SA5_SPI,
			'sa5_ealgokey'  => $D4_SA5_ENC_KEY,
			'sa5_eauthkey'  => $D4_SA5_HASH_KEY,
			'sa5_unique'    => $D4_SA5_SPI,
			'sa6_spi'       => $D4_SA6_SPI,
			'sa6_ealgokey'  => $D4_SA6_ENC_KEY,
			'sa6_eauthkey'  => $D4_SA6_HASH_KEY,
			'sa6_unique'    => $D4_SA6_SPI,
		},
	);

	my $sa;
	$sa = $sas{$no};

	vLogHTML_headline('configure SA5/SA6');

	# SA5: MN->HA ESP transport mode (MPS)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$mobile_node",
		"dst=$home_agent",
		'protocol=esp',
		"spi=$sa->{sa5_spi}",
		'mode=transport',
		$USE_SA5_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa5_ealgokey}\"",
		$USE_SA5_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa5_eauthkey}\"",
		"unique=$sa->{sa5_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		"src=$mobile_node",
		"dst=$home_agent",
		'upperspec=icmp6',
		$GRAN_TRANS_SA_TYPE? 'msgtype=146': 'msgtype=any',
		'direction=in',
		'policy=ipsec',
		'protocol=esp',
		'mode=transport',
		'level=unique',
		"unique=$sa->{sa5_unique}",
		'ommit',
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	# SA6: HA->MN ESP transport mode (MPA)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$home_agent",
		"dst=$mobile_node",
		'protocol=esp',
		"spi=$sa->{sa6_spi}",
		'mode=transport',
		$USE_SA6_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa6_ealgokey}\"",
		$USE_SA6_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa6_eauthkey}\"",
		"unique=$sa->{sa6_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		"src=$home_agent",
		"dst=$mobile_node",
		'upperspec=icmp6',
		$GRAN_TRANS_SA_TYPE? 'msgtype=147': 'msgtype=any',
		'direction=out',
		'policy=ipsec',
		'protocol=esp',
		'mode=transport',
		'level=unique',
		"unique=$sa->{sa6_unique}",
		'ommit',
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	return($true);
}



#-----------------------------#
# configureIPsec_SA7_SA8_ex() #
#-----------------------------#
sub
configureIPsec_SA7_SA8_ex($$$)
{
	my ($no, $home_agent, $mobile_node) = @_;

	my %sas = (
		'1' => {
			'sa7_spi'       => $SA7_SPI,
			'sa7_ealgokey'  => $SA7_ENC_KEY,
			'sa7_eauthkey'  => $SA7_HASH_KEY,
			'sa7_unique'    => $SA7_SPI,
			'sa8_spi'       => $SA8_SPI,
			'sa8_ealgokey'  => $SA8_ENC_KEY,
			'sa8_eauthkey'  => $SA8_HASH_KEY,
			'sa8_unique'    => $SA8_SPI,
		},
		'2' => {
			'sa7_spi'       => $D2_SA7_SPI,
			'sa7_ealgokey'  => $D2_SA7_ENC_KEY,
			'sa7_eauthkey'  => $D2_SA7_HASH_KEY,
			'sa7_unique'    => $D2_SA7_SPI,
			'sa8_spi'       => $D2_SA8_SPI,
			'sa8_ealgokey'  => $D2_SA8_ENC_KEY,
			'sa8_eauthkey'  => $D2_SA8_HASH_KEY,
			'sa8_unique'    => $D2_SA8_SPI,
		},
		'4' => {
			'sa7_spi'       => $D4_SA7_SPI,
			'sa7_ealgokey'  => $D4_SA7_ENC_KEY,
			'sa7_eauthkey'  => $D4_SA7_HASH_KEY,
			'sa7_unique'    => $D4_SA7_SPI,
			'sa8_spi'       => $D4_SA8_SPI,
			'sa8_ealgokey'  => $D4_SA8_ENC_KEY,
			'sa8_eauthkey'  => $D4_SA8_HASH_KEY,
			'sa8_unique'    => $D4_SA8_SPI,
		},
	);

	my $sa;
	$sa = $sas{$no};

	vLogHTML_headline('configure SA7/SA8');

	# SA7: MN->HA ESP tunnel mode (X)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$mobile_node",
		"dst=$home_agent",
		'protocol=esp',
		"spi=$sa->{sa7_spi}",
		'mode=tunnel',
		$USE_SA7_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa7_ealgokey}\"",
		$USE_SA7_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa7_eauthkey}\"",
		"unique=$sa->{sa7_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		"src=$mobile_node",
		'dst=::/0',
		'upperspec=any',
		'direction=in',
		'policy=ipsec',
		'protocol=esp',
		'mode=tunnel',
		"tsrc=$mobile_node",
		"tdst=$home_agent",
		'level=unique',
		"unique=$sa->{sa7_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	# SA8: HA->MN ESP tunnel mode (X)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$home_agent",
		"dst=$mobile_node",
		'protocol=esp',
		"spi=$sa->{sa8_spi}",
		'mode=tunnel',
		$USE_SA8_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa8_ealgokey}\"",
		$USE_SA8_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa8_eauthkey}\"",
		"unique=$sa->{sa8_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		'src=::/0',
		"dst=$mobile_node",
		'upperspec=any',
		'direction=out',
		'policy=ipsec',
		'protocol=esp',
		'mode=tunnel',
		"tsrc=$home_agent",
		"tdst=$mobile_node",
		'level=unique',
		"unique=$sa->{sa8_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	return($true);
}



#------------------------------#
# configureIPsec_SA9_SA10_ex() #
#------------------------------#
sub
configureIPsec_SA9_SA10_ex($$$$$)
{
	my ($no, $home_agent, $mobile_node, $mobile_prefix, $mobile_prefix_2) = @_;

	my %sas = (
		'1' => {
			'sa9_spi'       => $SA9_SPI,
			'sa9_ealgokey'  => $SA9_ENC_KEY,
			'sa9_eauthkey'  => $SA9_HASH_KEY,
			'sa9_unique'    => $SA9_SPI,
			'sa10_spi'      => $SA10_SPI,
			'sa10_ealgokey' => $SA10_ENC_KEY,
			'sa10_eauthkey' => $SA10_HASH_KEY,
			'sa10_unique'   => $SA10_SPI,
		},
		'2' => {
			'sa9_spi'         => $D2_SA9_SPI,
			'sa9_ealgokey'    => $D2_SA9_ENC_KEY,
			'sa9_eauthkey'    => $D2_SA9_HASH_KEY,
			'sa9_unique'      => $D2_SA9_SPI,
			'sa10_spi'        => $D2_SA10_SPI,
			'sa10_ealgokey'   => $D2_SA10_ENC_KEY,
			'sa10_eauthkey'   => $D2_SA10_HASH_KEY,
			'sa10_unique'     => $D2_SA10_SPI,
			'sa9_2_spi'       => $D2_2_SA9_SPI,
			'sa9_2_ealgokey'  => $D2_2_SA9_ENC_KEY,
			'sa9_2_eauthkey'  => $D2_2_SA9_HASH_KEY,
			'sa9_2_unique'    => $D2_2_SA9_SPI,
			'sa10_2_spi'      => $D2_2_SA10_SPI,
			'sa10_2_ealgokey' => $D2_2_SA10_ENC_KEY,
			'sa10_2_eauthkey' => $D2_2_SA10_HASH_KEY,
			'sa10_2_unique'   => $D2_2_SA10_SPI,
		},
		'4' => {
			'sa9_spi'       => $D4_SA9_SPI,
			'sa9_ealgokey'  => $D4_SA9_ENC_KEY,
			'sa9_eauthkey'  => $D4_SA9_HASH_KEY,
			'sa9_unique'    => $D4_SA9_SPI,
			'sa10_spi'      => $D4_SA10_SPI,
			'sa10_ealgokey' => $D4_SA10_ENC_KEY,
			'sa10_eauthkey' => $D4_SA10_HASH_KEY,
			'sa10_unique'   => $D4_SA10_SPI,
		},
	);

	my $sa;
	$sa = $sas{$no};

	vLogHTML_headline('configure SA9/SA10_headline');

	# SA9: MNP->HA ESP tunnel mode (X)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$mobile_node",
		"dst=$home_agent",
		'protocol=esp',
		"spi=$sa->{sa9_spi}",
		'mode=tunnel',
		$USE_SA9_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa9_ealgokey}\"",
		$USE_SA9_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa9_eauthkey}\"",
		"unique=$sa->{sa9_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		"src=$mobile_prefix",
		'dst=::/0',
		'upperspec=any',
		'direction=in',
		'policy=ipsec',
		'protocol=esp',
		'mode=tunnel',
		"tsrc=$mobile_node",
		"tdst=$home_agent",
		'level=unique',
		"unique=$sa->{sa9_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	# SA10: HA->MN ESP tunnel mode (X)

	if (!$HAVE_IKE &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$home_agent",
		"dst=$mobile_node",
		'protocol=esp',
		"spi=$sa->{sa10_spi}",
		'mode=tunnel',
		$USE_SA10_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa10_ealgokey}\"",
		$USE_SA10_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa10_eauthkey}\"",
		"unique=$sa->{sa10_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if(vRemote(
		'ipsecSetSPD.rmt',
		'src=::/0',
		"dst=$mobile_prefix",
		'upperspec=any',
		'direction=out',
		'policy=ipsec',
		'protocol=esp',
		'mode=tunnel',
		"tsrc=$home_agent",
		"tdst=$mobile_node",
		'level=unique',
		"unique=$sa->{sa10_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	if ($no == 2) {
		vLogHTML_headline('configure SA9/SA10 multi');
	}

	# SA9: MNP->HA ESP tunnel mode (X)

	if (!$HAVE_IKE && ($no == 2) &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$mobile_node",
		"dst=$home_agent",
		'protocol=esp',
		"spi=$sa->{sa9_2_spi}",
		'mode=tunnel',
		$USE_SA9_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa9_2_ealgokey}\"",
		$USE_SA9_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa9_2_eauthkey}\"",
		"unique=$sa->{sa9_2_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if (($no == 2) &&
	   vRemote(
		'ipsecSetSPD.rmt',
		"src=$mobile_prefix_2",
		'dst=::/0',
		'upperspec=any',
		'direction=in',
		'policy=ipsec',
		'protocol=esp',
		'mode=tunnel',
		"tsrc=$mobile_node",
		"tdst=$home_agent",
		'level=unique',
		"unique=$sa->{sa9_2_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	# SA10: HA->MN ESP tunnel mode (X)

	if (!$HAVE_IKE && ($no == 2) &&
	   vRemote(
		'ipsecSetSAD.rmt',
		"src=$home_agent",
		"dst=$mobile_node",
		'protocol=esp',
		"spi=$sa->{sa10_2_spi}",
		'mode=tunnel',
		$USE_SA10_DES_CBC?  'ealgo=des-cbc':  'ealgo=3des-cbc',
		"ealgokey=\"$sa->{sa10_2_ealgokey}\"",
		$USE_SA10_HMAC_MD5? 'eauth=hmac-md5': 'eauth=hmac-sha1',
		"eauthkey=\"$sa->{sa10_2_eauthkey}\"",
		"unique=$sa->{sa10_2_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSAD.rmt: Can\'t configure SA');

		exitFatal();
	}

	if (($no == 2) &&
	   vRemote(
		'ipsecSetSPD.rmt',
		'src=::/0',
		"dst=$mobile_prefix_2",
		'upperspec=any',
		'direction=out',
		'policy=ipsec',
		'protocol=esp',
		'mode=tunnel',
		"tsrc=$home_agent",
		"tdst=$mobile_node",
		'level=unique',
		"unique=$sa->{sa10_2_unique}",
		'nodump'
	)) {
		vLogHTML_red('ipsecSetSPD.rmt: Can\'t configure SPD');

		exitFatal();
	}

	return($true);
}



#------------------------------#
# reachabilityConfirmations()  #
#------------------------------#
sub
reachabilityConfirmations()
{
	vLogHTML_headline('Reachability Confirmations');

	my @magic	= ();

	if($HAVE_HOME_LINK) {
		push(@magic, 'USE_LINK0X');
		push(@magic, 'USE_LINK0Y');
	}

	if($HAVE_FOREIGN_LINK) {
		push(@magic, 'USE_LINK1X');
		push(@magic, 'USE_LINK1Y');
	}

	for my $movement (@magic) {
		my $cpp = "-D$movement";
		ike::VCppRegistMIP($cpp);
		ike::VCppApply();

		my %ret		= ();
		my $bool	= $false;

		pktdesc_movement($movement);

		# state: ANY (R)
		vClear($link{$movement});
		vSend($link{$movement}, 'coa_ereq');

		%ret = IKEvRecv($link{$movement},
			$RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_mcast)), 'coa_erep');

		foreach my $frame (sort(keys(%nd_mcast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: INCOMPLETE (R)
				vClear($link{$movement});
				vSend($link{$movement}, $nd_mcast{$frame});

				# state: REACHABLE (R)
				$bool	= $true;
				%ret = IKEvRecv($link{$movement},
					$RETRANS_TIMER + 1, 0, 0,
					'coa_erep');

				last;
			}
		}

		if($ret{'recvFrame'} ne 'coa_erep') {
			vLogHTML_redb('Couldn\'t get Echo Reply');

			return($false);
		}

		unless($bool) {
			# state: REACHABLE/STALE/DELAY/PROBE (R)
			%ret = IKEvRecv($link{$movement},
				$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
				sort(keys(%nd_ucast)));

			foreach my $frame (sort(keys(%nd_ucast))) {
				if($ret{'recvFrame'} eq $frame) {
					# state: PROBE (R)
					vSend($link{$movement}, $nd_ucast{$frame});

					last;
				}
			}

			# state: REACHABLE (R)
		}
	}

	return($true);
}



#------------------------------#
# exitPass()                   #
#------------------------------#
sub
exitPass()
{
	vLogHTML('<B>PASS</B><BR>');
	exitCommon($V6evalTool::exitPass);
}



#------------------------------#
# exitRouterOnly()             #
#------------------------------#
sub
exitRouterOnly()
{
	vLogHTML('<FONT COLOR="#FF8080"><B>Router Only</B></FONT><BR>');
	exitCommon($V6evalTool::exitRouterOnly);
}



#------------------------------#
# exitInitFail()               #
#------------------------------#
sub
exitInitFail()
{
	vLogHTML_redb('Initialization Fail');
	exitCommon($V6evalTool::exitInitFail);
}



#------------------------------#
# exitFail()                   #
#------------------------------#
sub
exitFail()
{
	vLogHTML_redb('FAIL');
	exitCommon($V6evalTool::exitFail);
}



#------------------------------#
# exitFatal()                  #
#------------------------------#
sub
exitFatal()
{
	vLogHTML_redb('internal error');
	exitCommon($V6evalTool::exitFatal);
}



#------------------------------#
# exitCommon()                 #
#------------------------------#
sub
exitCommon($)
{
	my ($ecode) = @_;

	# find strange packets
	if ( @UNEXPECT ) {
		vLogHTML("<TR><TD></TD><TD><B>Unexpect packet is examined.</B><BR>");

		set_frames();

		for $unexpect ( @UNEXPECT ) {
			($rtn, $kind_name) = get_strange_unexpect(0, \%$unexpect);
			$no = $$unexpect{vRecvPKT} - 1;
			if ($rtn == 1){
				vLogHTML("<A HREF=\"#vRecvPKT$no\">    packet is $kind_name</A>".
				         "<B><FONT COLOR=\"#FF8080\">:  WARN: This packet might be a failure that should not be sent.</FONT></B><BR>");
				if($ecode == $V6evalTool::exitPass) {
					$ecode = $V6evalTool::exitWarn;
				}
			}
			else {
				vLogHTML("<A HREF=\"#vRecvPKT$no\">    packet is $kind_name</A><BR>");
			}
		}
		vLogHTML("</TD></TR>");
	}

	if(!$NEED_REBOOT && !$ROTATE_HOA && $have_binding_cache2 &&
		!nest_mipv6registration_using_local_packet_definition(
			$movement_compat2,
			($last_accepted_sequence2 + 1) & 0xffff,
			1,
			1,
			$linklocal_compat2? 1: 0,
			0,
			$mr_regist2? 1: 0,
			0,
			0,
			0,
			-1,
			($last_accepted_sequence2 + 1) & 0xffff,
			0,
			'tunnel_de_bu_common2',
			'tunnel_ba_common2'
		)) {

		if($ecode == $V6evalTool::exitPass) {
			vLogHTML_redb('Cleanup Fail');

			$ecode	= $V6evalTool::exitCleanupFail;
		}
	}

	if(!$NEED_REBOOT && !$ROTATE_HOA && $have_binding_cache &&
		!mipv6registration_using_local_packet_definition(
			$movement_compat,
			($last_accepted_sequence + 1) & 0xffff,
			1,
			1,
			$linklocal_compat? 1: 0,
			$kbit_compat ? 1: 0,
			$mr_regist? 1: 0,
			0,
			0,
			0,
			-1,
			($last_accepted_sequence + 1) & 0xffff,
			0,
			($parent_mr==0)? 'de_bu_common': 'local_de_bu',
			($parent_mr==0)? 'ba_common': 'local_ba'
		)) {

		if($ecode == $V6evalTool::exitPass) {
			vLogHTML_redb('Cleanup Fail');

			$ecode	= $V6evalTool::exitCleanupFail;
		}
	}

	if($HAVE_HOME_LINK && $have_ha0_entry) {
		vSend($Link0, 'ra_delete_ha0_entry');
	}

	if($HAVE_HOME_LINK && $have_ha0_multiple_entry) {
		vSend($Link0, 'ra_delete_ha0_multiple_entry');
	}

	if($HAVE_HOME_LINK && $have_ha1_entry) {
		vSend($Link0, 'ra_delete_ha1_entry');
	}

	if($HAVE_HOME_LINK && $have_ha_entry_flood) {
		my $cpp = '-DUSE_LOCAL_RA_DEREG_DEF';
		ike::VCppRegistMIP($cpp);
		ike::VCppApply();

		foreach my $ra (@rtadv_flood) {
			vSend($Link0, $ra);
		}
	}

	ike::finalizeIKE();

	if($capture_link1) {
		vStop($Link1);
	}

	if($capture_link0) {
		vStop($Link0);
	}

	exit($ecode);
}



#-----------------------#
# set_frames()          #
#-----------------------#
sub
set_frames()
{

	@frames_known = ();
	@frames_ilesp = ();

	#
	# known
	#
	# transport
	push @frames_known, "$F.$P";
	push @frames_known, "$F.$P.$E";

	# tunnel
	push @frames_known, "$F.$P.$P";
	push @frames_known, "$F.$P.$P.$E";
	push @frames_known, "$F.$P.$E.$P";
	push @frames_known, "$F.$P.$E.$P.$E";

	# nested tunnel
	push @frames_known, "$F.$P.$P.$P";
	push @frames_known, "$F.$P.$P.$P.$E";
	push @frames_known, "$F.$P.$P.$E.$P";
	push @frames_known, "$F.$P.$P.$E.$P.$E";
	push @frames_known, "$F.$P.$E.$P.$P";
	push @frames_known, "$F.$P.$E.$P.$P.$E";
	push @frames_known, "$F.$P.$E.$P.$E.$P";
	push @frames_known, "$F.$P.$E.$P.$E.$P.$E";

	#
	# ilesp
	#
	# transport
	push @frames_ilesp, "$F.$P";

	# tunnel
	push @frames_ilesp, "$F.$P.$P";
	push @frames_ilesp, "$F.$P.$E.$P";

	# nested tunnel
	push @frames_ilesp, "$F.$P.$P.$P";
	push @frames_ilesp, "$F.$P.$P.$E.$P";
	push @frames_ilesp, "$F.$P.$E.$P.$P";
	push @frames_ilesp, "$F.$P.$E.$P.$E.$P";

	return;
}



#---------------------------------------#
# sub get_strange_unexpect($$)          #
#---------------------------------------#
sub
get_strange_unexpect($$)
{
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



#------------------------------#
# rtadv_exchange()             #
#------------------------------#
sub
rtadv_exchange(@)
{
	my (@rtadv) = @_;

	vLogHTML_headline('Receiving Router Advertisement Messages');

	my %ret	= ();

	vClear($Link0);
	vSend($Link0, 'rs_common');

	%ret = IKEvRecv($Link0,
		$MIN_DELAY_BETWEEN_RAS + $MAX_RA_DELAY_TIME + $RETRANS_TIMER + 1, 0, 0,
		'ra_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	if($ret{'recvFrame'} ne 'ra_common') {
		vLogHTML_redb('Couldn\'t get RA');

		return($false);
	}

	my $base          = 'Frame_Ether.Packet_IPv6.ICMPv6_RA.';
	my $HI_RFlag      = $base. 'Opt_ICMPv6_HomeAgentInfo.RFlag';
	my $HI_Preference = $base. 'Opt_ICMPv6_HomeAgentInfo.Preference';
	my $PI_RFlag      = $base. 'Opt_ICMPv6_Prefix.RFlag';

	unless(defined($ret{$HI_RFlag})) {
		vLogHTML_redb('Couldn\'t get RA w/Home Agent Information Option');

		return($false);
	}

	unless(defined($ret{$HI_Preference})) {
		vLogHTML_redb('Couldn\'t get RA w/Home Agent Information Option');

		return($false);
	}

	unless(defined($ret{$PI_RFlag})) {
		vLogHTML_redb('Couldn\'t get RA w/Prefix Information Option');

		return($false);
	}

	unless($ret{$HI_RFlag}) {
		vLogHTML_redb('configuration problem -- Home Agent Information Option RFlag must not be zero');

		return($false);
	}

	unless($ret{$HI_Preference}) {
		vLogHTML_redb('configuration problem -- Home Agent Information Option Preference must be non-zero value');

		return($false);
	}

	unless($ret{$PI_RFlag}) {
		vLogHTML_redb('configuration problem -- Prefix Information Option RFlag must not be zero');

		return($false);
	}

	foreach my $ra (@rtadv) {
		vSend($Link0, $ra);
	}

	return($true);
}



#------------------------------------------------------#
# rtadv_exchange_using_local_packet_definition()       #
#------------------------------------------------------#
sub
rtadv_exchange_using_local_packet_definition(@)
{
	my (@rtadv) = @_;

	vLogHTML_headline('Receiving Router Advertisement Messages');

	my %ret	= ();

	vClear($Link0);
	vSend($Link0, 'rs_common');

	%ret = IKEvRecv($Link0,
		$MIN_DELAY_BETWEEN_RAS + $MAX_RA_DELAY_TIME + $RETRANS_TIMER + 1, 0, 0,
		'ra_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	if($ret{'recvFrame'} ne 'ra_common') {
		vLogHTML_redb('Couldn\'t get RA');

		return($false);
	}

	my $base          = 'Frame_Ether.Packet_IPv6.ICMPv6_RA.';
	my $HI_RFlag      = $base. 'Opt_ICMPv6_HomeAgentInfo.RFlag';
	my $HI_Preference = $base. 'Opt_ICMPv6_HomeAgentInfo.Preference';
	my $PI_RFlag      = $base. 'Opt_ICMPv6_Prefix.RFlag';

	unless(defined($ret{$HI_RFlag})) {
		vLogHTML_redb('Couldn\'t get RA w/Home Agent Information Option');

		return($false);
	}

	unless(defined($ret{$HI_Preference})) {
		vLogHTML_redb('Couldn\'t get RA w/Home Agent Information Option');

		return($false);
	}

	unless(defined($ret{$PI_RFlag})) {
		vLogHTML_redb('Couldn\'t get RA w/Prefix Information Option');

		return($false);
	}

	unless($ret{$HI_RFlag}) {
		vLogHTML_redb('configuration problem -- Home Agent Information Option RFlag must not be zero');

		return($false);
	}

	unless($ret{$HI_Preference}) {
		vLogHTML_redb('configuration problem -- Home Agent Information Option Preference must be non-zero value');

		return($false);
	}

	unless($ret{$PI_RFlag}) {
		vLogHTML_redb('configuration problem -- Prefix Information Option RFlag must not be zero');

		return($false);
	}

	my $cpp = '-DUSE_LOCAL_RA_REG_DEF';
	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	foreach my $ra (@rtadv) {
		vSend($Link0, $ra);
	}

	$have_ha_entry_flood	= $true;

	return($true);
}



#--------------------------------------#
# rtadv_exchange_get_valid_lifetime()  #
#--------------------------------------#
sub
rtadv_exchange_get_valid_lifetime($)
{
	my ($valid_lifetime) = @_;

	vLogHTML_headline('Receiving Router Advertisement Messages');

	my %ret	= ();

	vClear($Link0);
	vSend($Link0, 'rs_common');

	%ret = IKEvRecv($Link0,
		$MIN_DELAY_BETWEEN_RAS + $MAX_RA_DELAY_TIME + $RETRANS_TIMER + 1, 0, 0,
		'ra_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	if($ret{'recvFrame'} ne 'ra_common') {
		vLogHTML_redb('Couldn\'t get RA');

		return($false);
	}

	my $base             = 'Frame_Ether.Packet_IPv6.ICMPv6_RA.';
	my $HI_RFlag         = $base. 'Opt_ICMPv6_HomeAgentInfo.RFlag';
	my $HI_Preference    = $base. 'Opt_ICMPv6_HomeAgentInfo.Preference';
	my $PI_RFlag         = $base. 'Opt_ICMPv6_Prefix.RFlag';
	my $PI_ValidLifetime = $base. 'Opt_ICMPv6_Prefix.ValidLifetime';

	unless(defined($ret{$HI_RFlag})) {
		vLogHTML_redb('Couldn\'t get RA w/Home Agent Information Option');

		return($false);
	}

	unless(defined($ret{$HI_Preference})) {
		vLogHTML_redb('Couldn\'t get RA w/Home Agent Information Option');

		return($false);
	}

	unless(defined($ret{$PI_RFlag})) {
		vLogHTML_redb('Couldn\'t get RA w/Prefix Information Option');

		return($false);
	}

	unless(defined($ret{$PI_ValidLifetime})) {
		vLogHTML_redb('Couldn\'t get RA w/Prefix Information Option');

		return($false);
	}

	unless($ret{$HI_RFlag}) {
		vLogHTML_redb('configuration problem -- Home Agent Information Option RFlag must not be zero');

		return($false);
	}

	unless($ret{$HI_Preference}) {
		vLogHTML_redb('configuration problem -- Home Agent Information Option Preference must be non-zero value');

		return($false);
	}

	unless($ret{$PI_RFlag}) {
		vLogHTML_redb('configuration problem -- Prefix Information Option RFlag must not be zero');

		return($false);
	}

	$$valid_lifetime = $ret{$PI_ValidLifetime};

	return($true);
}



#------------------------------#
# dhaad_confirmation()         #
#------------------------------#
sub
dhaad_confirmation($$$$@)
{
	my (
		$movement,
		$haadreq_r,
		$haadrep_r,
		$haad_request,
		@haad_reply,
	) = @_;

	vLogHTML_headline('Dynamic Home Agent Address Discovery');

	my $cpp	= '';

	$cpp .= "-D$movement ";
	$cpp .= "-DDHAAD_REQ_R=$haadreq_r ";
	$cpp .= ($haadrep_r < 0)? "-DDHAAD_REP_R=any ": "-DDHAAD_REP_R=$haadrep_r ";

	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;

	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $haad_request);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @haad_reply);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@haad_reply);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $bool	= $false;

	foreach my $frame (sort(@haad_reply)) {
		if($ret{'recvFrame'} eq $frame) {
			$bool	= $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML_redb('Couldn\'t get HAAD Reply');

		return($false);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------------------------------#
# dhaad_confirmation_using_local_packet_definition()   #
#------------------------------------------------------#
sub
dhaad_confirmation_using_local_packet_definition($$$$@)
{
	my (
		$movement,
		$haadreq_r,
		$haadrep_r,
		$haad_request,
		@haad_reply,
	) = @_;

	vLogHTML_headline('Dynamic Home Agent Address Discovery');

	my $cpp	= '';

	$cpp .= "-DUSE_LOCAL_HAAD_REPLY_DEF ";
	$cpp .= "-D$movement ";
	$cpp .= "-DDHAAD_REQ_R=$haadreq_r ";
	$cpp .= ($haadrep_r < 0)? "-DDHAAD_REP_R=any ": "-DDHAAD_REP_R=$haadrep_r ";

	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;

	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $haad_request);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @haad_reply);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@haad_reply);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $bool	= $false;

	foreach my $frame (sort(@haad_reply)) {
		if($ret{'recvFrame'} eq $frame) {
			$bool	= $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML_redb('Couldn\'t get HAAD Reply');

		return($false);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#--------------------------------------#
# dhaad_confirmation_with_time()       #
#--------------------------------------#
sub
dhaad_confirmation_with_time($$$$$$$)
{
	my (
		$movement,
		$haadreq_r,
		$haadrep_r,
		$haad_request,
		$haad_reply_true,
		$haad_reply_false,
		$bool
	) = @_;

	vLogHTML_headline('Dynamic Home Agent Address Discovery');

	my $cpp	= '';

	$cpp .= "-D$movement ";
	$cpp .= "-DDHAAD_REQ_R=$haadreq_r ";
	$cpp .= ($haadrep_r < 0)? "-DDHAAD_REP_R=any ": "-DDHAAD_REP_R=$haadrep_r ";

	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();

	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $haad_request);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)),
		sort(keys(%nd_ucast)),
		$haad_reply_true, $haad_reply_false);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$haad_reply_true, $haad_reply_false);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	foreach my $frame (sort(keys(%nd_ucast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: PROBE (R)
			vSend($link{$movement}, $nd_ucast{$frame});

			# state: REACHABLE (R)
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$haad_reply_true, $haad_reply_false);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if(($ret{'recvFrame'} ne $haad_reply_true) &&
	   ($ret{'recvFrame'} ne $haad_reply_false)) {
		vLogHTML_redb('Couldn\'t get HAAD Reply');

		return($false);
	}

	if($ret{'recvFrame'} eq $haad_reply_false) {
		$have_ha0_entry	= $false;
		$$bool		= $true;
	}

	return($true);
}



#------------------------------#
# mipv6registration()          #
#------------------------------#
sub
mipv6registration($$$$$$$$$$$$$)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime
	) = @_;

	vLogHTML_headline($bu_lifetime? 'Home Registration': 'Home De-Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (1, 2);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_common	= '';
	$bu_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_common .= $bu_a_bit? 'A': 'a';
	$bu_common .= $bu_h_bit? 'H': 'h';
	$bu_common .= $bu_l_bit? 'L': 'l';
	$bu_common .= $bu_k_bit? 'K': 'k';
	$bu_common .= $bu_r_bit? 'R': 'r';
	$bu_common .= ", ltime:$bu_lifetime) w/ HaO: ";
	$bu_common .= "$mn{$movement} -&gt; RUT (Link0)";

	my $ba_common	= '';
	$ba_common .= "    Recv BA (stat:$ba_status, ";
	$ba_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_common .= ", seq:$ba_sequence";
	$ba_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_common .= ") w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'bu_common'}	= $bu_common;
	$pktdesc{'ba_common'}	= $ba_common;

	my %ret		= ();
	my $bool	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence	= $bu_sequence;
	}

	unless($ba_status) {
		$movement_compat	= $movement;

		$link_dir		= $link_dir_rv{$movement};

		if($ba_lifetime) {
			$have_binding_cache	= $true;
		}
		else {
			$have_binding_cache	= $false;
		}

		if($bu_l_bit) {
			$linklocal_compat	= $true;
		}

		if($bu_k_bit) {
			$kbit_compat		= $true;
		}

		if($bu_r_bit) {
			$mr_regist		= $true;
		}
	}



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, 'bu_common');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'ba_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'ba_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ba_common') {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	$binding_created	= time;

	my $base	= 'Frame_Ether.Packet_IPv6';

	if($HAVE_IPSEC && $USE_SA1_SA2) {
		$base .= '.Hdr_ESP.Decrypted.ESPPayload';
	}

	$base .= '.Hdr_MH_BA';

	unless(defined($ret{"$base.Lifetime"})) {
		vLogHTML_red('shuldn\'t reach here');

		exit($V6evalTool::exitFatal);
	}

	$binding_lifetime	= $ret{"$base.Lifetime"};

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------------------------------#
# mipv6registration_using_local_packet_definition()    #
#------------------------------------------------------#
sub
mipv6registration_using_local_packet_definition($$$$$$$$$$$$$$$)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime,
		$local_bu,
		$local_ba
	) = @_;

	vLogHTML_headline($bu_lifetime? 'Home Registration': 'Home De-Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (1, 2);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_common	= '';
	$bu_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_common .= $bu_a_bit? 'A': 'a';
	$bu_common .= $bu_h_bit? 'H': 'h';
	$bu_common .= $bu_l_bit? 'L': 'l';
	$bu_common .= $bu_k_bit? 'K': 'k';
	$bu_common .= $bu_r_bit? 'R': 'r';
	$bu_common .= ", ltime:$bu_lifetime) w/ HaO: ";
	$bu_common .= "$mn{$movement} -&gt; RUT (Link0)";

	my $ba_common	= '';
	$ba_common .= "    Recv BA (stat:$ba_status, ";
	$ba_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_common .= ", seq:$ba_sequence";
	$ba_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_common .= ") w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{$local_bu}	= $bu_common;
	$pktdesc{$local_ba}	= $ba_common;

	my %ret		= ();
	my $bool	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence	= $bu_sequence;
	}

	unless($ba_status) {
		$movement_compat	= $movement;

		$link_dir		= $link_dir_rv{$movement};

		if($ba_lifetime) {
			$have_binding_cache	= $true;
		}
		else {
			$have_binding_cache	= $false;
		}

		if($bu_l_bit) {
			$linklocal_compat	= $true;
		}

		if($bu_k_bit) {
			$kbit_compat		= $true;
		}

		if($bu_r_bit) {
			$mr_regist		= $true;
		}
	}



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $local_bu);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $local_ba);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$local_ba);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $local_ba) {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	my $base	= 'Frame_Ether.Packet_IPv6';

	if($HAVE_IPSEC && $USE_SA1_SA2) {
		$base .= '.Hdr_ESP.Decrypted.ESPPayload';
	}

	$base .= '.Hdr_MH_BA';

	unless(defined($ret{"$base.Lifetime"})) {
		vLogHTML_red('shuldn\'t reach here');

		exit($V6evalTool::exitFatal);
	}

	$binding_lifetime	= $ret{"$base.Lifetime"};

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#--------------------------------------#
# mipv6registration_not_home_subnet()  #
#--------------------------------------#
sub
mipv6registration_not_home_subnet($$$$$$$$$$$$$)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime
	) = @_;

	vLogHTML_headline($bu_lifetime? 'Home Registration': 'Home De-Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	# This routine never use ESP transport mode agains mobility header

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (1, 2);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_common	= '';
	$bu_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_common .= $bu_a_bit? 'A': 'a';
	$bu_common .= $bu_h_bit? 'H': 'h';
	$bu_common .= $bu_l_bit? 'L': 'l';
	$bu_common .= $bu_k_bit? 'K': 'k';
	$bu_common .= $bu_r_bit? 'R': 'r';
	$bu_common .= ", ltime:$bu_lifetime) w/ HaO: ";
	$bu_common .= "$mn{$movement} -&gt; RUT (Link0)";

	my $ba_common	= '';
	$ba_common .= "    Recv BA (stat:$ba_status, ";
	$ba_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_common .= ", seq:$ba_sequence";
	$ba_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_common .= ") w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'bu_not_home_subnet'}	= $bu_common;
	$pktdesc{'ba_not_home_subnet'}	= $ba_common;

	my %ret		= ();
	my $bool	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence	= $bu_sequence;
	}

	unless($ba_status) {
		$movement_compat	= $movement;

		$link_dir		= $link_dir_rv{$movement};

		if($ba_lifetime) {
			$have_binding_cache	= $true;
		}
		else {
			$have_binding_cache	= $false;
		}

		if($bu_l_bit) {
			$linklocal_compat	= $true;
		}

		if($bu_k_bit) {
			$kbit_compat		= $true;
		}

		if($bu_r_bit) {
			$mr_regist		= $true;
		}
	}



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, 'bu_not_home_subnet');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'ba_not_home_subnet');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'ba_not_home_subnet');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ba_not_home_subnet') {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	my $base	= 'Frame_Ether.Packet_IPv6.Hdr_MH_BA';

	unless(defined($ret{"$base.Lifetime"})) {
		vLogHTML_red('shuldn\'t reach here');

		exit($V6evalTool::exitFatal);
	}

	$binding_lifetime	= $ret{"$base.Lifetime"};

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#--------------------------------------#
# mipv6registration_icmp_error()       #
#--------------------------------------#
sub
mipv6registration_icmp_error($$$$$$$$$@)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$send_bu,
		@recv_icmp_error
	) = @_;

	vLogHTML_headline($bu_lifetime? 'Home Registration': 'Home De-Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	# This routine must not use ESP transport mode

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";

	my @salist = (1, 2);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	$last_accepted_sequence	= $bu_sequence;

	if($bu_l_bit) {
		$linklocal_compat	= $true;
	}

	if($bu_k_bit) {
		$kbit_compat		= $true;
	}

	if($bu_r_bit) {
		$mr_regist		= $true;
	}



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $send_bu);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_icmp_error);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_icmp_error);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $got_icmp_error	= $false;

	foreach my $frame (sort(@recv_icmp_error)) {
		if($ret{'recvFrame'} eq $frame) {
			$got_icmp_error	= $true;
			last;
		}
	}

	unless($got_icmp_error) {
		vLogHTML_redb('Couldn\'t get Parameter Problem');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# mipv6ignore_registration()   #
#------------------------------#
sub
mipv6ignore_registration($$$$$$$$$$$$$$@)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime,
		$bu_send,
		@ba_recv
	) = @_;

	vLogHTML_headline($bu_lifetime? 'Home Registration': 'Home De-Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (1, 2);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_common	= '';
	$bu_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_common .= $bu_a_bit? 'A': 'a';
	$bu_common .= $bu_h_bit? 'H': 'h';
	$bu_common .= $bu_l_bit? 'L': 'l';
	$bu_common .= $bu_k_bit? 'K': 'k';
	$bu_common .= $bu_r_bit? 'R': 'r';
	$bu_common .= ", ltime:$bu_lifetime) w/ HaO: ";
	$bu_common .= "$mn{$movement} -&gt; RUT (Link0)";

	my $ba_common	= '';
	$ba_common .= "    Recv BA (stat:$ba_status, ";
	$ba_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_common .= ", seq:$ba_sequence";
	$ba_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_common .= ") w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{$bu_send}	= $bu_common;
	$pktdesc{'ba_common'}	= $ba_common;

	my %ret		= ();
	my $unknown	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence	= $bu_sequence;
	}

	unless($ba_status) {
		$movement_compat	= $movement;

		unless($ba_lifetime) {
			$have_binding_cache	= $false;
		}

		if($bu_l_bit) {
			$linklocal_compat	= $true;
		}

		if($bu_k_bit) {
			$kbit_compat		= $true;
		}

		if($bu_r_bit) {
			$mr_regist		= $true;
		}
	}



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $bu_send);

	my $bool	= $false;
	my $now_time = time;
	my $end_time = $now_time + ($RETRANS_TIMER + 1);
	while ($now_time < $end_time) {

		$sec = $end_time - $now_time;
		%ret = IKEvRecv($link{$movement},
			$sec, 0, 0,
			sort(keys(%nd_mcast)), @ba_recv);
		$now_time = time;

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		if ($ret{'status'} == 0) {
			foreach my $frame (sort(keys(%nd_mcast))) {
				if($ret{'recvFrame'} eq $frame) {
					# state: INCOMPLETE (R)
					vSend($link{$movement}, $nd_mcast{$frame});

					# state: REACHABLE (R)
					$unknown	= $true;
					goto AAA;
				}
			}

			foreach my $frame (sort(@ba_recv)) {
				if($ret{'recvFrame'} eq $frame) {
					$bool	= $true;
					goto BBB;
				}
			}
		}
		elsif ($ret{'status'} == 1) {
			;
		}

AAA:
	}
BBB:

	unless($bool) {
		return($true);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	vLogHTML_redb('got BA');

	return($false);
}



#------------------------------#
# mipv6sending_mcast_na()      #
#------------------------------#
sub
mipv6sending_mcast_na($$$$$$$$$$$$$$)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime,
		$na_bool
	) = @_;

	vLogHTML_headline($bu_lifetime? 'Home Registration': 'Home De-Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	$cpp .= ($na_bool == $true)? '-DPROXY_ND ': '';

	my @salist = (1, 2);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_common	= '';
	$bu_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_common .= $bu_a_bit? 'A': 'a';
	$bu_common .= $bu_h_bit? 'H': 'h';
	$bu_common .= $bu_l_bit? 'L': 'l';
	$bu_common .= $bu_k_bit? 'K': 'k';
	$bu_common .= $bu_r_bit? 'R': 'r';
	$bu_common .= ", ltime:$bu_lifetime) w/ HaO: ";
	$bu_common .= "$mn{$movement} -&gt; RUT (Link0)";

	my $ba_common	= '';
	$ba_common .= "    Recv BA (stat:$ba_status, ";
	$ba_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_common .= ", seq:$ba_sequence";
	$ba_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_common .= ") w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'bu_common'}	= $bu_common;
	$pktdesc{'ba_common'}	= $ba_common;

	my %ret		= ();
	my $unknown	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence	= $bu_sequence;
	}

	unless($ba_status) {
		$movement_compat	= $movement;

		$link_dir		= $link_dir_rv{$movement};

		if($ba_lifetime) {
			$have_binding_cache	= $true;
		}
		else {
			$have_binding_cache	= $false;
		}

		if($bu_l_bit) {
			$linklocal_compat	= $true;
		}

		if($bu_k_bit) {
			$kbit_compat		= $true;
		}

		if($bu_r_bit) {
			$mr_regist		= $true;
		}
	}

	my $unsolicited_mcast_na_global		= $false;
	my $unsolicited_mcast_na_linklocal	= $false;
	my $ba_common				= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, 'bu_common');

	for( ; ; ) {
		if($bu_l_bit                       &&
		   $unsolicited_mcast_na_global    &&
		   $unsolicited_mcast_na_linklocal &&
		   $ba_common) {
			last;
		}

		%ret = IKEvRecv($link{$movement},
			$RETRANS_TIMER + 1, 0, 0,
			$unknown? (): sort(keys(%nd_mcast)),
			'unsolicited_mcast_na_global_from_global',
			'unsolicited_mcast_na_global_from_linklocal',
			'unsolicited_mcast_na_linklocal_from_global',
			'unsolicited_mcast_na_linklocal_from_linklocal',
			'ba_common');

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		#------------------------------#
		# RUT -> R: NA (INCOMPLETE)    #
		#------------------------------#
		my $bool	= $false;

		unless($unknown) {
			foreach my $frame (sort(keys(%nd_mcast))) {
				if($ret{'recvFrame'} eq $frame) {
					# state: INCOMPLETE (R)
					vSend($link{$movement}, $nd_mcast{$frame});

					# state: REACHABLE (R)
					$bool		= $true;
					$unknown	= $true;

					last;
				}
			}
		}

		if($bool) {
			next;
		}

		#----------------------------------------------#
		# RUT -> multicast: NA (global, unsolicited)   #
		#----------------------------------------------#
		if(($ret{'recvFrame'} eq 'unsolicited_mcast_na_global_from_global') ||
		   ($ret{'recvFrame'} eq 'unsolicited_mcast_na_global_from_linklocal')) {
			$unsolicited_mcast_na_global = $true;

			unless($na_bool) {
				vLogHTML_redb('got NA (target=global)');

				return($false);
			}

			next;
		}

		#------------------------------------------------------#
		# RUT -> multicast: NA (link-local, unsolicited)       #
		#------------------------------------------------------#
		if(($ret{'recvFrame'} eq 'unsolicited_mcast_na_linklocal_from_global') ||
		   ($ret{'recvFrame'} eq 'unsolicited_mcast_na_linklocal_from_linklocal')) {
			$unsolicited_mcast_na_linklocal = $true;

			unless(($bu_l_bit) || ($na_bool)) {
				vLogHTML_redb('got NA (target=link-local)');

				return($false);
			}

			next;
		}

		#------------------------------#
		# RUT -> MN: BA w/ RH          #
		#------------------------------#
		if($ret{'recvFrame'} eq 'ba_common') {
			$ba_common			= $true;

			next;
		}

		last;
	}

	unless($ba_common) {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	if($na_bool){
		unless($unsolicited_mcast_na_global) {
			vLogHTML_redb('Couldn\'t get NA (rflag=1, oflag=1, target=global)');

			return($false);
		}

		if($bu_l_bit &&
		   !$unsolicited_mcast_na_linklocal) {
			vLogHTML_redb('Couldn\'t get NA (rflag=1, oflag=1, target=link-local)');

			return($false);
		}
	}



	#------------------------------#
	# RUT -> R: NA (PROBE)         #
	#------------------------------#
	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# proxy_nd()                   #
#------------------------------#
sub
proxy_nd($$$$@)
{
	my (
		$bool,
		$movement,
		$cn0_scope, 
		$vsend,
		@vrecv
	) = @_;

	vLogHTML_headline('Proxy ND Test');

	my $cpp = '';

	$cpp .= "-D$movement ";
	$cpp .= "-D$cn0_scope ";

	$cpp .= ($bool == $true)? '-DPROXY_ND ': '';

	my @salist = (1, 2, 5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);
	pktdesc_cn0_scope($cn0_scope);

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (CN0)
	vClear($link{$movement});
	vSend($link{$movement}, $vsend);

	%ret = IKEvRecv($link{$movement},
		$MAX_ANYCAST_DELAY_TIME + $RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd4cn0_mcast)), @vrecv);

	# save unexpect
	# push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd4cn0_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (CN0)
			vClear($link{$movement});
			vSend($link{$movement}, $nd4cn0_mcast{$frame});

			# state: REACHABLE (CN0)
			$unknown        = $true;
			%ret = IKEvRecv($link{$movement},
				$MAX_ANYCAST_DELAY_TIME + $RETRANS_TIMER + 1, 0, 0,
				@vrecv);

			# save unexpect
			# push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_na = $false;

	foreach my $frame (sort(@vrecv)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_na	= $true;
			last;
		}
	}

	unless($get_na) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get NA');
		}

		return($bool? $false: $true);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (CN0)

		IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, 0, 0);

		# save unexpect
		# push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		# state: REACHABLE/NONE (CN0)
	}

	unless($bool) {
		vLogHTML_redb('got NA');
	}

	return($bool? $true: $false);
}



#------------------------------#
# mipv6dad()                   #
#------------------------------#
sub
mipv6dad($$$$$$$$$$$$$$$)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime,
		$dad_global,
		$dad_linklocal
	) = @_;

	vLogHTML_headline('Home Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (1, 2, 5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_common	= '';
	$bu_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_common .= $bu_a_bit? 'A': 'a';
	$bu_common .= $bu_h_bit? 'H': 'h';
	$bu_common .= $bu_l_bit? 'L': 'l';
	$bu_common .= $bu_k_bit? 'K': 'k';
	$bu_common .= $bu_r_bit? 'R': 'r';
	$bu_common .= ", ltime:$bu_lifetime) w/ HaO: ";
	$bu_common .= "$mn{$movement} -&gt; RUT (Link0)";

	my $ba_common	= '';
	$ba_common .= "    Recv BA (stat:$ba_status, ";
	$ba_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_common .= ", seq:$ba_sequence";
	$ba_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_common .= ") w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'bu_common'}	= $bu_common;
	$pktdesc{'ba_common'}	= $ba_common;

	my %ret		= ();
	my $bool	= $false;

	my $ba_common			= $false;
	my $proxy_dad_ns_global		= $false;
	my $proxy_dad_ns_linklocal	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence	= $bu_sequence;
	}

	unless($ba_status) {
		$movement_compat	= $movement;

		$link_dir		= $link_dir_rv{$movement};

		if($ba_lifetime) {
			$have_binding_cache	= $true;
		}
		else {
			$have_binding_cache	= $false;
		}

		if($bu_l_bit) {
			$linklocal_compat	= $true;
		}

		if($bu_k_bit) {
			$kbit_compat		= $true;
		}

		if($bu_r_bit) {
			$mr_regist		= $true;
		}
	}



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, 'bu_common');

	for( ; ; ) {
		my $continue	= $false;

		%ret = IKEvRecv($link{$movement},
			$RETRANS_TIMER + 1, 0, 0,
			$proxy_dad_ns_global? '': 'proxy_dad_ns_global',
			$proxy_dad_ns_linklocal? '': 'proxy_dad_ns_linklocal',
			$bool? (): sort(keys(%nd_mcast)),
			'ba_common');

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_mcast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: INCOMPLETE (R)
				vClear($link{$movement});
				vSend($link{$movement}, $nd_mcast{$frame});

				# state: REACHABLE (R)
				$bool		= $true;
				$continue	= $true;
				last;
			}
		}

		if($continue) {
			next;
		}

		if($ret{'recvFrame'} eq 'proxy_dad_ns_global') {
			$proxy_dad_ns_global	= $true;
			next;
		}

		if($ret{'recvFrame'} eq 'proxy_dad_ns_linklocal') {
			$proxy_dad_ns_linklocal	= $true;
			next;
		}

		if($ret{'recvFrame'} eq 'ba_common') {
			$ba_common	= $true;
		}

		last;
	}

	unless($ba_common) {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	if($dad_global && !$proxy_dad_ns_global) {
		vLogHTML_redb('Couldn\'t get DAD (global)');

		return($false);
	}

	if($dad_linklocal && !$proxy_dad_ns_linklocal) {
		vLogHTML_redb('Couldn\'t get DAD (link-local)');

		return($false);
	}

	if(!$dad_global && $proxy_dad_ns_global) {
		vLogHTML_redb('get unexpected DAD (global)');

		return($false);
	}

	if(!$dad_linklocal && $proxy_dad_ns_linklocal) {
		vLogHTML_redb('get unexpected DAD (link-local)');

		return($false);
	}

	unless($ba_common) {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# mipv6dad_receiving_na()      #
#------------------------------#
sub
mipv6dad_receiving_na($$$$$$$$$$$$$$$)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime,
		$ns_global,
		$na_global
	) = @_;

	vLogHTML_headline('Home Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (1, 2, 5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_common	= '';
	$bu_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_common .= $bu_a_bit? 'A': 'a';
	$bu_common .= $bu_h_bit? 'H': 'h';
	$bu_common .= $bu_l_bit? 'L': 'l';
	$bu_common .= $bu_k_bit? 'K': 'k';
	$bu_common .= $bu_r_bit? 'R': 'r';
	$bu_common .= ", ltime:$bu_lifetime) w/ HaO: ";
	$bu_common .= "$mn{$movement} -&gt; RUT (Link0)";

	my $ba_common	= '';
	$ba_common .= "    Recv BA (stat:$ba_status, ";
	$ba_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_common .= ", seq:$ba_sequence";
	$ba_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_common .= ") w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'bu_common'}	= $bu_common;
	$pktdesc{'ba_common'}	= $ba_common;

	my %ret		= ();
	my $bool	= $false;

	my @nd	= sort(keys(%nd_mcast));

	my $proxy_dad_ns = $ns_global? 'proxy_dad_ns_global': 'proxy_dad_ns_linklocal';

	my $proxy_dad_na = $na_global? 'proxy_dad_na_global': 'proxy_dad_na_linklocal';

	my $interface	= $link{$movement};
	my $timeout	= $RETRANS_TIMER + 1;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	$last_accepted_sequence	= $bu_sequence;

	$movement_compat	= $movement;

	$link_dir		= $link_dir_rv{$movement};

	if($ba_lifetime) {
		$have_binding_cache	= $true;
	}
	else {
		$have_binding_cache	= $false;
	}

	if($bu_l_bit) {
		$linklocal_compat	= $true;
	}

	if($bu_k_bit) {
		$kbit_compat		= $true;
	}

	if($bu_r_bit) {
		$mr_regist		= $true;
	}



	# state: ANY (R)
	vClear($interface);
	vSend($interface, 'bu_common');

	%ret = IKEvRecv($interface,
		$timeout, 0, 0,
		$proxy_dad_ns);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	if($ret{'recvFrame'} ne $proxy_dad_ns) {
		if($ns_global){
			vLogHTML_redb('Couldn\'t get DAD (global)');
		}else{
			vLogHTML_redb('Couldn\'t get DAD (link-local)');
		}

		return($false);
	}



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status > 127) {
		$have_binding_cache	= $false;
	}



	vClear($interface);
	vSend($interface, $proxy_dad_na);

	%ret = IKEvRecv($interface,
		$timeout, 0, 0,
		@nd, 'ba_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($interface);
			vSend($interface, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($interface,
				$timeout, 0, 0,
				'ba_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ba_common') {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($interface,
			$DELAY_FIRST_PROBE_TIME + $timeout, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($interface, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# mipv6dad_none()              #
#------------------------------#
sub
mipv6dad_none($$$$$$$$$$$$$)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime,
	) = @_;

	vLogHTML_headline('Home Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (1, 2, 5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_common	= '';
	$bu_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_common .= $bu_a_bit? 'A': 'a';
	$bu_common .= $bu_h_bit? 'H': 'h';
	$bu_common .= $bu_l_bit? 'L': 'l';
	$bu_common .= $bu_k_bit? 'K': 'k';
	$bu_common .= $bu_r_bit? 'R': 'r';
	$bu_common .= ", ltime:$bu_lifetime) w/ HaO: ";
	$bu_common .= "$mn{$movement} -&gt; RUT (Link0)";

	my $ba_common	= '';
	$ba_common .= "    Recv BA (stat:$ba_status, ";
	$ba_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_common .= ", seq:$ba_sequence";
	$ba_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_common .= ") w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{'bu_common'}	= $bu_common;
	$pktdesc{'ba_common'}	= $ba_common;

	my %ret		= ();
	my $bool	= $false;

	my $ba_common			= $false;
	my $proxy_dad_ns_global		= $false;
	my $proxy_dad_ns_linklocal	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence	= $bu_sequence;
	}

	unless($ba_status) {
		$movement_compat		= $movement;

		$link_dir		= $link_dir_rv{$movement};

		if ($ba_lifetime) {
			$have_binding_cache	= $true;
		}
		else {
			$have_binding_cache	= $false;
		}

		if($bu_l_bit) {
			$linklocal_compat	= $true;
		}

		if($bu_k_bit) {
			$kbit_compat		= $true;
		}

		if($bu_r_bit) {
			$mr_regist		= $true;
		}
	}



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, 'bu_common');
	vSend($link{$movement}, 'proxy_dad_na_global');
	vSend($link{$movement}, 'proxy_dad_na_linklocal');

	for( ; ; ) {
		my $continue	= $false;

		%ret = IKEvRecv($link{$movement},
			$RETRANS_TIMER + 1, 0, 0,
			$proxy_dad_ns_global?    '': 'proxy_dad_ns_global',
			$proxy_dad_ns_linklocal? '': 'proxy_dad_ns_linklocal',
			$bool?                   (): sort(keys(%nd_mcast)),
			'ba_common');

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_mcast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: INCOMPLETE (R)
				vClear($link{$movement});
				vSend($link{$movement}, $nd_mcast{$frame});

				# state: REACHABLE (R)
				$bool		= $true;
				$continue	= $true;
				last;
			}
		}

		if($continue) {
			next;
		}

		if($ret{'recvFrame'} eq 'proxy_dad_ns_global') {
			$proxy_dad_ns_global	= $true;
			next;
		}

		if($ret{'recvFrame'} eq 'proxy_dad_ns_linklocal') {
			$proxy_dad_ns_linklocal	= $true;
			next;
		}

		if($ret{'recvFrame'} eq 'ba_common') {
			$ba_common	= $true;
		}

		last;
	}

	if($proxy_dad_ns_global) {
		vLogHTML_redb('get unexpected DAD (global)');

		return($false);
	}

	if($proxy_dad_ns_linklocal) {
		vLogHTML_redb('get unexpected DAD (link-local)');

		return($false);
	}

	unless($ba_common) {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# mipv6de_registration()       #
#------------------------------#
sub
mipv6de_registration($$$$$$$$$$$$$)
{
	my (
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$bu_use_hao,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime
	) = @_;

	vLogHTML_headline('Home De-Registration');

	$nd_mcast{'hoa_mcast_ns_linklocal_sll'}	= 'hoa_na_linklocal';
	$nd_mcast{'hoa_mcast_ns_global_sll'}	= 'hoa_na_global';

	$nd_ucast{'hoa_ucast_ns_linklocal_sll'}	= 'hoa_na_linklocal';
	$nd_ucast{'hoa_ucast_ns_linklocal'}	= 'hoa_na_linklocal';
	$nd_ucast{'hoa_ucast_ns_global_sll'}	= 'hoa_na_global';
	$nd_ucast{'hoa_ucast_ns_global'}	= 'hoa_na_global';

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= !$bu_use_hao? '-DNOT_TO_USE_HAO ': '';
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (1, 2);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	my $bu_dereg_common	= '';
	$bu_dereg_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_dereg_common .= $bu_a_bit? 'A': 'a';
	$bu_dereg_common .= $bu_h_bit? 'H': 'h';
	$bu_dereg_common .= $bu_l_bit? 'L': 'l';
	$bu_dereg_common .= $bu_k_bit? 'K': 'k';
	$bu_dereg_common .= $bu_r_bit? 'R': 'r';
	$bu_dereg_common .= ", ltime:$bu_lifetime) ";
	$bu_dereg_common .= $bu_use_hao? 'w/ HaO: ': 'w/o HaO: ';
	$bu_dereg_common .= 'MN0 -&gt; RUT (Link0)';

	my $ba_dereg_common	= '';
	$ba_dereg_common .= "    Recv BA (stat:$ba_status, ";
	$ba_dereg_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_dereg_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_dereg_common .= ", seq:$ba_sequence";
	$ba_dereg_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_dereg_common .= ') : RUT (Link0) -&gt; MN0';

	$pktdesc{'bu_dereg_common'}	= $bu_dereg_common;
	$pktdesc{'ba_dereg_common'}	= $ba_dereg_common;

	my %ret		= ();
	my $bool	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence	= $bu_sequence;
	}

	if(!$ba_status && !$ba_lifetime) {
		$have_binding_cache	= $false;
	}



	# state: ANY (R)
	vClear($Link0);
	vSend($Link0, 'bu_dereg_common');

	%ret = IKEvRecv($Link0,
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'ba_dereg_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($Link0);

			if(($nd_mcast{$frame} eq 'hoa_na_global') &&
				update_seq_sa5_sa6(\$cpp, \$use_ipsec)) {

				ike::VCppRegistMIP($cpp);
				ike::VCppApply();
			}

			vSend($Link0, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($Link0,
				$RETRANS_TIMER + 1, 0, 0,
				'ba_dereg_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ba_dereg_common') {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($Link0,
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				if(($nd_mcast{$frame} eq 'hoa_na_global') &&
					update_seq_sa5_sa6(\$cpp, \$use_ipsec)) {

					ike::VCppRegistMIP($cpp);
					ike::VCppApply();
				}

				# state: PROBE (R)
				vSend($Link0, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------------------------------------#
# mipv6de_registration_using_local_packet_definition()       #
# NOTE: for Home Link De-regstration only
#------------------------------------------------------------#
sub
mipv6de_registration_using_local_packet_definition($$$$$$$$$$$$$$$)
{
	my (
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$bu_use_hao,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime,
		$local_bu,
		$local_ba
	) = @_;

	vLogHTML_headline('Home De-Registration');

	$nd_mcast{'hoa_mcast_ns_linklocal_sll'}	= 'hoa_na_linklocal';
	$nd_mcast{'hoa_mcast_ns_global_sll'}	= 'hoa_na_global';

	$nd_ucast{'hoa_ucast_ns_linklocal_sll'}	= 'hoa_na_linklocal';
	$nd_ucast{'hoa_ucast_ns_linklocal'}	= 'hoa_na_linklocal';
	$nd_ucast{'hoa_ucast_ns_global_sll'}	= 'hoa_na_global';
	$nd_ucast{'hoa_ucast_ns_global'}	= 'hoa_na_global';

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (1, 2);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_dereg_common	= '';
	$bu_dereg_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_dereg_common .= $bu_a_bit? 'A': 'a';
	$bu_dereg_common .= $bu_h_bit? 'H': 'h';
	$bu_dereg_common .= $bu_l_bit? 'L': 'l';
	$bu_dereg_common .= $bu_k_bit? 'K': 'k';
	$bu_dereg_common .= $bu_r_bit? 'R': 'r';
	$bu_dereg_common .= ", ltime:$bu_lifetime) ";
	$bu_dereg_common .= $bu_use_hao? 'w/ HaO: ': 'w/o HaO: ';
	$bu_dereg_common .= 'MN0 -&gt; RUT (Link0)';

	my $ba_dereg_common	= '';
	$ba_dereg_common .= "    Recv BA (stat:$ba_status, ";
	$ba_dereg_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_dereg_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_dereg_common .= ", seq:$ba_sequence";
	$ba_dereg_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_dereg_common .= ') : RUT (Link0) -&gt; MN0';

	$pktdesc{'local_bu'}		= $bu_dereg_common;
	$pktdesc{'ba_dereg_common'}	= $ba_dereg_common;

	my %ret		= ();
	my $bool	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence	= $bu_sequence;
	}

	if(!$ba_status && !$ba_lifetime) {
		$have_binding_cache	= $false;
	}



	# state: ANY (R)
	vClear($Link0);
	vSend($Link0, $local_bu);

	%ret = IKEvRecv($Link0,
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $local_ba);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($Link0);

			if(($nd_mcast{$frame} eq 'hoa_na_global') &&
				update_seq_sa5_sa6(\$cpp, \$use_ipsec)) {

				ike::VCppRegistMIP($cpp);
				ike::VCppApply();
			}

			vSend($Link0, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($Link0,
				$RETRANS_TIMER + 1, 0, 0,
				$local_ba);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $local_ba) {
		vLogHTML_redb('Couldn\'t get BA');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($Link0,
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				if(($nd_mcast{$frame} eq 'hoa_na_global') &&
					update_seq_sa5_sa6(\$cpp, \$use_ipsec)) {

					ike::VCppRegistMIP($cpp);
					ike::VCppApply();
				}

				# state: PROBE (R)
				vSend($Link0, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#----------------------------------------------#
# mipv6de_registration_unrecognized_mh_type()  #
#----------------------------------------------#
sub
mipv6de_registration_unrecognized_mh_type($$$$$$$$$)
{
	my (
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$bu_use_hao,
		$bu_send
	) = @_;

	vLogHTML_headline('Home De-Registration');

	$nd_mcast{'hoa_mcast_ns_linklocal_sll'}	= 'hoa_na_linklocal';
	$nd_mcast{'hoa_mcast_ns_global_sll'}	= 'hoa_na_global';

	$nd_ucast{'hoa_ucast_ns_linklocal_sll'}	= 'hoa_na_linklocal';
	$nd_ucast{'hoa_ucast_ns_linklocal'}	= 'hoa_na_linklocal';
	$nd_ucast{'hoa_ucast_ns_global_sll'}	= 'hoa_na_global';
	$nd_ucast{'hoa_ucast_ns_global'}	= 'hoa_na_global';

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= !$bu_use_hao? '-DNOT_TO_USE_HAO ': '';

	my @salist = (1, 2);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	my $bu_dereg_common	= '';
	$bu_dereg_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_dereg_common .= $bu_a_bit? 'A': 'a';
	$bu_dereg_common .= $bu_h_bit? 'H': 'h';
	$bu_dereg_common .= $bu_l_bit? 'L': 'l';
	$bu_dereg_common .= $bu_k_bit? 'K': 'k';
	$bu_dereg_common .= $bu_r_bit? 'R': 'r';
	$bu_dereg_common .= ", ltime:$bu_lifetime) ";
	$bu_dereg_common .= $bu_use_hao? 'w/ HaO: ': 'w/o HaO: ';
	$bu_dereg_common .= 'MN0 -&gt; RUT (Link0)';

	$pktdesc{$bu_send}	= $bu_dereg_common;

	my %ret		= ();
	my $bool	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	$last_accepted_sequence	= $bu_sequence;



	# state: ANY (R)
	vClear($Link0);
	vSend($Link0, $bu_send);

	%ret = IKEvRecv($Link0,
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'be_dereg_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($Link0);

			if(($nd_mcast{$frame} eq 'hoa_na_global') &&
				update_seq_sa5_sa6(\$cpp, \$use_ipsec)) {

				ike::VCppRegistMIP($cpp);
				ike::VCppApply();
			}

			vSend($Link0, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($Link0,
				$RETRANS_TIMER + 1, 0, 0,
				'be_dereg_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'be_dereg_common') {
		vLogHTML_redb('Couldn\'t get BE');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($Link0,
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				if(($nd_mcast{$frame} eq 'hoa_na_global') &&
					update_seq_sa5_sa6(\$cpp, \$use_ipsec)) {

					ike::VCppRegistMIP($cpp);
					ike::VCppApply();
				}

				# state: PROBE (R)
				vSend($Link0, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#--------------------------------------#
# mipv6de_registration_icmp_error()    #
#--------------------------------------#
sub
mipv6de_registration_icmp_error($$$$$$$$@)
{
	my (
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$bu_send,
		@recv_icmp_error
	) = @_;

	vLogHTML_headline('Home De-Registration');

	$nd_mcast{'hoa_mcast_ns_linklocal_sll'}	= 'hoa_na_linklocal';
	$nd_mcast{'hoa_mcast_ns_global_sll'}	= 'hoa_na_global';

	$nd_ucast{'hoa_ucast_ns_linklocal_sll'}	= 'hoa_na_linklocal';
	$nd_ucast{'hoa_ucast_ns_linklocal'}	= 'hoa_na_linklocal';
	$nd_ucast{'hoa_ucast_ns_global_sll'}	= 'hoa_na_global';
	$nd_ucast{'hoa_ucast_ns_global'}	= 'hoa_na_global';

	my $use_ipsec	= $false;

	my $cpp	= '';

	# This routine must not use ESP transport mode for MH

	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";

	my @salist = (1, 2, 5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	my $bu_dereg_common	= '';
	$bu_dereg_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_dereg_common .= $bu_a_bit? 'A': 'a';
	$bu_dereg_common .= $bu_h_bit? 'H': 'h';
	$bu_dereg_common .= $bu_l_bit? 'L': 'l';
	$bu_dereg_common .= $bu_k_bit? 'K': 'k';
	$bu_dereg_common .= $bu_r_bit? 'R': 'r';
	$bu_dereg_common .= ", ltime:$bu_lifetime) ";
	$bu_dereg_common .= $bu_use_hao? 'w/ HaO: ': 'w/o HaO: ';
	$bu_dereg_common .= 'MN0 -&gt; RUT (Link0)';

	$pktdesc{$bu_send}	= $bu_dereg_common;

	my %ret		= ();
	my $bool	= $false;



	# state: ANY (R)
	vClear($Link0);
	vSend($Link0, $bu_send);

	%ret = IKEvRecv($Link0,
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_icmp_error);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($Link0);

			if(($nd_mcast{$frame} eq 'hoa_na_global') &&
				update_seq_sa5_sa6(\$cpp, \$use_ipsec)) {

				ike::VCppRegistMIP($cpp);
				ike::VCppApply();
			}

			vSend($Link0, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($Link0,
				$RETRANS_TIMER + 1, 0, 0,
				@recv_icmp_error);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $got_icmp_error	= $false;

	foreach my $frame (sort(@recv_icmp_error)) {
		if($ret{'recvFrame'} eq $frame) {
			$got_icmp_error = $true;
			last;
		}
	}

	unless($got_icmp_error) {
		vLogHTML_redb('Couldn\'t get Parameter Problem');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($Link0,
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				if(($nd_mcast{$frame} eq 'hoa_na_global') &&
					update_seq_sa5_sa6(\$cpp, \$use_ipsec)) {

					ike::VCppRegistMIP($cpp);
					ike::VCppApply();
				}

				# state: PROBE (R)
				vSend($Link0, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# mpd_confirmation()           #
#------------------------------#
sub
mpd_confirmation($$$@)
{
	my (
		$movement,
		$bool,
		$mps,
		@mpa,
	) = @_;

	vLogHTML_headline('Mobile Prefix Discovery');

	my $use_ipsec   = $false;

	my $cpp	= '';

	update_seq_sa5_sa6(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $mps);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @mpa);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@mpa);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $got_mpa	= $false;

	foreach my $frame (sort(@mpa)) {
		if($ret{'recvFrame'} eq $frame) {
			$got_mpa	= $true;
			last;
		}
	}

	unless($got_mpa) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get MPA');
		}

		return($bool? $false: $true);
	}

	my $base = 'Frame_Ether.Packet_IPv6.';

	if($HAVE_IPSEC &&
	   ((!$UNIQ_TRANS_SA && $USE_SA1_SA2) ||
	    ($UNIQ_TRANS_SA && $USE_SA5_SA6))) {
		$base .= 'Hdr_ESP.Decrypted.ESPPayload.';
	}

	$base .= 'ICMPv6_MobilePrefixAdvertise.';

	my $ValidLifetime = $base. 'Opt_ICMPv6_Prefix.ValidLifetime';

	unless(defined($ret{$ValidLifetime})) {
		vLogHTML_redb('Couldn\'t get MPA w/Prefix Information Option');

		return($false);
	}

	$mpa_valid_lifetime = $ret{$ValidLifetime};

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	unless($bool) {
		vLogHTML_redb('got MPA');
	}

	return($bool);
}



#----------------------------------------------#
# mpd_confirmation_returning_binding_error()   #
#----------------------------------------------#
sub
mpd_confirmation_returning_binding_error($$$@)
{
	my (
		$movement,
		$bool,
		$mps,
		@be,
	) = @_;

	vLogHTML_headline('Mobile Prefix Discovery');

	my $use_ipsec   = $false;

	my $cpp	= '';

	update_seq_sa5_sa6(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $mps);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @be);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@be);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $got_be	= $false;

	foreach my $frame (sort(@be)) {
		if($ret{'recvFrame'} eq $frame) {
			$got_be	= $true;
			last;
		}
	}

	unless($got_be) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get BE');
		}

		return($bool? $false: $true);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	unless($bool) {
		vLogHTML_redb('got BE');
	}

	return($bool);
}



#------------------------------#
# linklocal_echo()             #
#------------------------------#
sub
linklocal_echo($$$$@)
{
	my (
		$bool,
		$movement,
		$cn0_scope, 
		$vsend,
		@vrecv
	) = @_;

	vLogHTML_headline('Processing Intercepted Packets');

	my $cpp = '';

	$cpp .= "-D$movement ";
	$cpp .= "-D$cn0_scope ";

	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	pktdesc_movement($movement);
	pktdesc_cn0_scope($cn0_scope);

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (CN0)
	vClear($link{$movement});
	vSend($link{$movement}, $vsend);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd4cn0_mcast)), @vrecv);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd4cn0_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (CN0)
			vClear($link{$movement});
			vSend($link{$movement}, $nd4cn0_mcast{$frame});

			# state: REACHABLE (CN0)
			$unknown        = $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@vrecv);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_icmp = $false;

	foreach my $frame (sort(@vrecv)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_icmp	= $true;
			last;
		}
	}

	unless($get_icmp) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get Destination Unreachable');
		}

		return($bool? $false: $true);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (CN0)

		IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, 0, 0);

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		# state: REACHABLE/NONE (CN0)
	}

	unless($bool) {
		vLogHTML_redb('got Destination Unreachable');
	}

	return($bool? $true: $false);
}



#------------------------------#
# binding_confirmation()       #
#------------------------------#
sub
binding_confirmation($$)
{
	my (
		$movement,
		$bool
	) = @_;

	vLogHTML_headline('Binding Existence Test');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa5_sa6(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $expect	= $bool? 'coa_erep_routing': 'be_common';

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, 'coa_ereq_hao');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $expect);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$expect);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $expect) {
		my $packet = $bool? 'Echo Reply w/ RH': 'BE';

		vLogHTML_redb("Couldn't get $packet.");

		return($false);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#----------------------------------------------------------#
# binding_confirmation_using_local_packet_definition()     #
#----------------------------------------------------------#
sub
binding_confirmation_using_local_packet_definition($$$$)
{
	my (
		$movement,
		$bool,
		$send_packet,
		$recv_packet
	) = @_;

	vLogHTML_headline('Binding Existence Test');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa5_sa6(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $send_packet);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $recv_packet);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$recv_packet);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $recv_packet) {
		my $packet = $bool? 'Echo Reply w/ RH': 'BE';

		vLogHTML_redb("Couldn't get $packet.");

		return($false);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#----------------------------------------------#
# binding_confirmation_not_home_subnet()       #
#----------------------------------------------#
sub
binding_confirmation_not_home_subnet($$)
{
	my (
		$movement,
		$bool
	) = @_;

	vLogHTML_headline('Binding Existence Test');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa5_sa6(\$cpp, \$use_ipsec);

	# this routine never use ESP transport mode agains ICMP as upper-layer

	$cpp .= "-D$movement ";

	my @salist = (5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $expect	= $bool?
		'coa_erep_routing_not_home_subnet':
		'be_common_not_home_subnet';

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, 'coa_ereq_hao_not_home_subnet');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $expect);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$expect);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $expect) {
		my $packet = $bool? 'Echo Reply w/ RH': 'BE';

		vLogHTML_redb("Couldn't get $packet.");

		return($false);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#--------------------------------------#
# binding_confirmation_with_time()     #
#--------------------------------------#
sub
binding_confirmation_with_time($$)
{
	my (
		$movement,
		$bool
	) = @_;

	vLogHTML_headline('Binding Existence Test');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa5_sa6(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (5, 6);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply('', '', '', 'force');

	pktdesc_movement($movement);

	my %ret		= ();



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, 'coa_ereq_hao');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)),
		sort(keys(%nd_ucast)),
		'coa_erep_routing',
		'be_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'coa_erep_routing', 'be_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	foreach my $frame (sort(keys(%nd_ucast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: PROBE (R)
			vSend($link{$movement}, $nd_ucast{$frame});

			# state: REACHABLE (R)
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'coa_erep_routing', 'be_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if(($ret{'recvFrame'} ne 'coa_erep_routing') &&
 	   ($ret{'recvFrame'} ne 'be_common')) {
		vLogHTML_redb('Couldn\'t get Echo Request and BE');

		return($false);
	}

	if($ret{'recvFrame'} eq 'be_common') {
		$have_binding_cache	= $false;
		$$bool = $true;
	}

	return($true);
}



# no use
#------------------------------#
# reverse_tunnel_HoTI()        #
#------------------------------#
sub
reverse_tunnel_HoTI($)
{
	my ($movement) = @_;

	vLogHTML_headline('Reverse Tunneling (HoTI)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa3_sa4(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (3, 4);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, 'hoti_tunnel_common');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'hoti_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'hoti_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'hoti_common') {
		vLogHTML_redb('Couldn\'t get HoTI.');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



# no use
#--------------------------------------#
# ignore_reverse_tunnel_HoTI()         #
#--------------------------------------#
sub
ignore_reverse_tunnel_HoTI($$)
{
	my ($movement, $local_hoti) = @_;

	vLogHTML_headline('Reverse Tunneling (HoTI)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa3_sa4(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (3, 4);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $local_hoti);

	my $now_time = time;
	my $end_time = $now_time + ($RETRANS_TIMER + 1);
	while ($now_time < $end_time) {

		$sec = $end_time - $now_time;
		%ret = IKEvRecv($link{$movement},
			$sec, 0, 0,
			sort(keys(%nd_mcast)), 'hoti_common');
		$now_time = time;

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		if ($ret{'status'} == 0) {
			foreach my $frame (sort(keys(%nd_mcast))) {
				if($ret{'recvFrame'} eq $frame) {
					# state: INCOMPLETE (R)
					vSend($link{$movement}, $nd_mcast{$frame});

					# state: REACHABLE (R)
					$bool	= $true;
					goto AAA;
				}
			}

			if($ret{'recvFrame'} eq 'hoti_common') {
				last;
			}
		}
		elsif ($ret{'status'} == 1) {
			;
		}

AAA:
	}

	if($ret{'recvFrame'} ne 'hoti_common') {
		return($true);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	vLogHTML_redb('got HoTI.');

	return($false);
}



# no use
#------------------------------#
# tunnel_HoT()                 #
#------------------------------#
sub
tunnel_HoT($)
{
	my ($movement) = @_;

	vLogHTML_headline('Tunneling (HoT)');

	my $cpp = "-D$movement ";

	my @salist = (3, 4);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, 'hot_common');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'hot_tunnel_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'hot_tunnel_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'hot_tunnel_common') {
		vLogHTML_redb('Couldn\'t get HoT.');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# reverse_tunnel_ereq()        #
#------------------------------#
sub
reverse_tunnel_ereq($)
{
	my ($movement) = @_;

	vLogHTML_headline('Reverse Tunneling (payload packet)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa7_sa8(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (7, 8);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, 'ereq_mn2cn_tunnel_common');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'ereq_mn2cn_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'ereq_mn2cn_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ereq_mn2cn_common') {
		vLogHTML_redb('Couldn\'t get Echo Request.');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------------------------------#
# reverse_tunnel_ereq_using_local_packet_definition()  #
#------------------------------------------------------#
sub
reverse_tunnel_ereq_using_local_packet_definition($$$$)
{
	my (
		$movement,
		$bool,
		$local_tunnel_ereq,
		$local_ereq
	) = @_;

	vLogHTML_headline('Reverse Tunneling (payload packet)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa7_sa8(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (7, 8);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $local_tunnel_ereq);

	my $now_time = time;
	my $end_time = $now_time + ($RETRANS_TIMER + 1);
	while ($now_time < $end_time) {

		$sec = $end_time - $now_time;
		%ret = IKEvRecv($link{$movement},
			$sec, 0, 0,
			sort(keys(%nd_mcast)), $local_ereq);
		$now_time = time;

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		if ($ret{'status'} == 0) {
			foreach my $frame (sort(keys(%nd_mcast))) {
				if($ret{'recvFrame'} eq $frame) {
					# state: INCOMPLETE (R)
					vSend($link{$movement}, $nd_mcast{$frame});

					# state: REACHABLE (R)
					$unknown	= $true;
					goto AAA;
				}
			}

			if($ret{'recvFrame'} eq $local_ereq) {
				last;
			}
		}
		elsif ($ret{'status'} == 1) {
			;
		}

AAA:
	}

	if($ret{'recvFrame'} eq $local_ereq) {
		unless($bool) {
			vLogHTML_redb('get Echo Request.');

			return ($false);
		}
	}
	else {
		if($bool) {
			vLogHTML_redb('Couldn\'t get Echo Request.');

			return($false);
		}
		else {
			return($true);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# tunnel_ereq()                #
#------------------------------#
sub
tunnel_ereq($)
{
	my ($movement) = @_;

	vLogHTML_headline('Tunneling (payload packet)');

	my $cpp = "-D$movement ";

	my @salist = (7, 8);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, 'ereq_cn2mn_common');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'ereq_cn2mn_tunnel_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'ereq_cn2mn_tunnel_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ereq_cn2mn_tunnel_common') {
		vLogHTML_redb('Couldn\'t get Echo Request.');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------------------------------------#
# tunnel_ereq_using_local_packet_definition()                #
#------------------------------------------------------------#
sub
tunnel_ereq_using_local_packet_definition($$$$)
{
	my (
		$movement,
		$bool,
		$send_packet,
		$recv_packet
	) = @_;

	vLogHTML_headline('Tunneling (payload packet)');

	my $cpp = "-D$movement ";
	my @salist = (7, 8);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_packet);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $recv_packet);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$recv_packet);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $recv_packet) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get Echo Request.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got Echo Request.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# relay_icmp_error()           #
#------------------------------#
sub
relay_icmp_error($)
{
	my ($movement) = @_;

	vLogHTML_headline('Tunneling (payload packet)');

	my $cpp = "-D$movement";

	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, 'ereq_cn2mn_common');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'ereq_cn2mn_tunnel_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'ereq_cn2mn_tunnel_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ereq_cn2mn_tunnel_common') {
		vLogHTML_redb('Couldn\'t get Echo Request.');

		return($false);
	}



	vSend($link{$movement}, 'timeexceeded_rx_rut');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'dst_unreach_rut_cn');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'dst_unreach_rut_cn');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'dst_unreach_rut_cn') {
		vLogHTML_redb('Couldn\'t get Destination Unreachable.');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------#
# relay_icmp_error_rut1()      #
#------------------------------#
sub
relay_icmp_error_rut1($)
{
	my ($movement) = @_;

	vLogHTML_headline('Tunneling (payload packet)');

	my $cpp = "-D$movement";

	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, 'ereq_cn2mn_common');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'ereq_cn2mn_tunnel_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'ereq_cn2mn_tunnel_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ereq_cn2mn_tunnel_common') {
		vLogHTML_redb('Couldn\'t get Echo Request.');

		return($false);
	}

	vSend($link{$movement}, 'timeexceeded_rx_rut');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'dst_unreach_rut_cn', 'dst_unreach_rut1_cn');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'dst_unreach_rut_cn', 'dst_unreach_rut1_cn');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if(($ret{'recvFrame'} ne 'dst_unreach_rut_cn') &&
	   ($ret{'recvFrame'} ne 'dst_unreach_rut1_cn')) {
		vLogHTML_redb('Couldn\'t get Destination Unreachable.');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-------------------------------------------------------#
# relay_icmp_error_using_local_packet_definition()      #
#-------------------------------------------------------#
sub
relay_icmp_error_using_local_packet_definition($$$$$)
{
	my (
		$movement,
		$echo_req,
		$tunnel_echo_req,
		$timeexceeded,
		$dst_unreach
	) = @_;

	vLogHTML_headline('Tunneling (payload packet)');

	my $cpp = "-D$movement";

	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $echo_req);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $tunnel_echo_req);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$tunnel_echo_req);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $tunnel_echo_req) {
		vLogHTML_redb('Couldn\'t get Echo Request.');

		return($false);
	}

	vSend($link{$movement}, $timeexceeded);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $dst_unreach);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$tunnel_echo_req);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $dst_unreach) {
		vLogHTML_redb('Couldn\'t get Destination Unreachable.');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#----------------------------------#
# reverse_tunnel_mnp_ereq()        #
#----------------------------------#
sub
reverse_tunnel_mnp_ereq($)
{
	my ($movement) = @_;

	vLogHTML_headline('Reverse Tunneling (payload packet)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, 'ereq_lfn2cn_tunnel_common');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'ereq_lfn2cn_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'ereq_lfn2cn_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ereq_lfn2cn_common') {
		vLogHTML_redb('Couldn\'t get Echo Request.');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#----------------------------------------------------------#
# reverse_tunnel_mnp_ereq_using_local_packet_definition()  #
#----------------------------------------------------------#
sub
reverse_tunnel_mnp_ereq_using_local_packet_definition($$$$)
{
	my (
		$movement,
		$bool,
		$send_packet,
		$recv_packet
	) = @_;

	vLogHTML_headline('Reverse Tunneling (payload packet)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_packet);

	my $now_time = time;
	my $end_time = $now_time + ($RETRANS_TIMER + 1);
	while ($now_time < $end_time) {

		$sec = $end_time - $now_time;
		%ret = IKEvRecv($link{$movement},
			$sec, 0, 0,
			sort(keys(%nd_mcast)), $recv_packet);
		$now_time = time;

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		if ($ret{'status'} == 0) {
			foreach my $frame (sort(keys(%nd_mcast))) {
				if($ret{'recvFrame'} eq $frame) {
					# state: INCOMPLETE (R)
					vSend($link{$movement}, $nd_mcast{$frame});

					# state: REACHABLE (R)
					$unknown	= $true;
					goto AAA;
				}
			}

			if($ret{'recvFrame'} eq $recv_packet) {
				last;
			}
		}
		elsif ($ret{'status'} == 1) {
			;
		}

AAA:
	}

	if($ret{'recvFrame'} eq $recv_packet) {
		unless($bool) {
			vLogHTML_redb('get Echo Request.');

			return ($false);
		}
	}
	else {
		if($bool) {
			vLogHTML_redb('Couldn\'t get Echo Request.');

			return($false);
		}
		else {
			return($true);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#---------------------------#
# tunnel_mnp_ereq()         #
#---------------------------#
sub
tunnel_mnp_ereq($$)
{
	my (
		$movement,
		$bool
	) = @_;

	vLogHTML_headline('Tunneling (payload packet)');

	my $cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, 'ereq_cn2lfn_common');

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), 'ereq_cn2lfn_tunnel_common');

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				'ereq_cn2lfn_tunnel_common');

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne 'ereq_cn2lfn_tunnel_common') {
		if($bool) {
			vLogHTML_redb('Couldn\'t get Echo Request.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got Echo Request.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------------------------------------#
# tunnel_mnp_ereq_using_local_packet_definition()            #
#------------------------------------------------------------#
sub
tunnel_mnp_ereq_using_local_packet_definition($$$$)
{
	my (
		$movement,
		$bool,
		$send_packet,
		$recv_packet
	) = @_;

	vLogHTML_headline('Tunneling (payload packet)');

	my $cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_packet);

	my $now_time = time;
	my $end_time = $now_time + ($RETRANS_TIMER + 1);
	while ($now_time < $end_time) {

		$sec = $end_time - $now_time;
		%ret = IKEvRecv($link{$movement},
			$sec, 0, 0,
			sort(keys(%nd_mcast)), $recv_packet);
		$now_time = time;

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		if ($ret{'status'} == 0) {
			foreach my $frame (sort(keys(%nd_mcast))) {
				if($ret{'recvFrame'} eq $frame) {
					# state: INCOMPLETE (R)
					# vClear($link{$movement});
					vSend($link{$movement}, $nd_mcast{$frame});

					# state: REACHABLE (R)
					$unknown	= $true;
					#%ret = IKEvRecv($link{$movement},
					#	$RETRANS_TIMER + 1, 0, 0,
					#	$recv_packet);

					# save unexpect
					# push @UNEXPECT, @{ $ret{'SaUnexpect'} };

					#last;
					goto AAA;
				}
			}

			if($ret{'recvFrame'} eq $recv_packet) {
				last;
			}
		}
		elsif ($ret{'status'} == 1) {
			;
		}

AAA:
	}

	if($ret{'recvFrame'} eq $recv_packet) {
		unless($bool) {
			vLogHTML_redb('got Echo Request.');

			return($false);
		}
	}
	else {
		if($bool) {
			vLogHTML_redb('Couldn\'t get Echo Request.');

			return($false);
		}
		else {
			return($true);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-----------------------------------------------------------#
# relay_mnp_icmp_error_using_local_packet_definition()      #
#-----------------------------------------------------------#
sub
relay_mnp_icmp_error_using_local_packet_definition($$$$$)
{
	my (
		$movement,
		$echo_req,
		$tunnel_echo_req,
		$timeexceeded,
		$dst_unreach
	) = @_;

	vLogHTML_headline('Tunneling (payload packet)');

	my $cpp = "-D$movement";

	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $bool	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $echo_req);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $tunnel_echo_req);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$tunnel_echo_req);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $tunnel_echo_req) {
		vLogHTML_redb('Couldn\'t get Echo Request.');

		return($false);
	}

	vSend($link{$movement}, $timeexceeded);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $dst_unreach);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$tunnel_echo_req);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $dst_unreach) {
		vLogHTML_redb('Couldn\'t get Destination Unreachable.');

		return($false);
	}

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-----------------------------------------------------------#
# reverse_tunnel_mnp_haad_using_local_packet_definition()   #
#-----------------------------------------------------------#
sub
reverse_tunnel_mnp_haad_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_haad,
		@recv_haad
	) = @_;

	vLogHTML_headline('Reverse Tunneling (HAAD Request)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_haad);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_haad);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_haad);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_haad = $false;

	foreach my $frame (sort(@recv_haad)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_haad	= $true;
			last;
		}
	}

	unless($get_haad) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get HAAD Request.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got HAAD Request.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#----------------------------------------------------------#
# reverse_tunnel_mnp_mps_using_local_packet_definition()   #
#----------------------------------------------------------#
sub
reverse_tunnel_mnp_mps_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_mps,
		@recv_mps
	) = @_;

	vLogHTML_headline('Reverse Tunneling (MPS)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_mps);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_mps);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_mps);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_mps = $false;

	foreach my $frame (sort(@recv_mps)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_mps	= $true;
			last;
		}
	}

	unless($get_mps) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get MPS.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got MPS.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-----------------------------------------------------------#
# reverse_tunnel_mnp_HoTI_using_local_packet_definition()   #
#-----------------------------------------------------------#
sub
reverse_tunnel_mnp_HoTI_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_hoti,
		@recv_hoti
	) = @_;

	vLogHTML_headline('Reverse Tunneling (HoTI)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;

	vClear($link{$movement});
	vSend($link{$movement}, $send_hoti);



	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_hoti);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_hoti);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_hoti = $false;

	foreach my $frame (sort(@recv_hoti)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_hoti	= $true;
			last;
		}
	}

	unless($get_hoti) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get HoTI.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got HoTI.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-----------------------------------------------------------#
# reverse_tunnel_mnp_CoTI_using_local_packet_definition()   #
#-----------------------------------------------------------#
sub
reverse_tunnel_mnp_CoTI_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_coti,
		@recv_coti
	) = @_;

	vLogHTML_headline('Reverse Tunneling (CoTI)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_coti);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_coti);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_coti);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_coti = $false;

	foreach my $frame (sort(@recv_coti)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_coti	= $true;
			last;
		}
	}

	unless($get_coti) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get CoTI.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got CoTI.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-----------------------------------------------------------#
# reverse_tunnel_mnp_HoT_using_local_packet_definition()    #
#-----------------------------------------------------------#
sub
reverse_tunnel_mnp_HoT_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_hot,
		@recv_hot,
	) = @_;

	vLogHTML_headline('Reverse Tunneling (HoT)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_hot);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_hot);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_hot);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_hot = $false;

	foreach my $frame (sort(@recv_hot)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_hot	= $true;
			last;
		}
	}

	unless($get_hot) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get HoT.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got HoT.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-----------------------------------------------------------#
# reverse_tunnel_mnp_CoT_using_local_packet_definition()    #
#-----------------------------------------------------------#
sub
reverse_tunnel_mnp_CoT_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_cot,
		@recv_cot,
	) = @_;

	vLogHTML_headline('Reverse Tunneling (CoT)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_cot);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_cot);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_cot);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_cot = $false;

	foreach my $frame (sort(@recv_cot)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_cot	= $true;
			last;
		}
	}

	unless($get_cot) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get CoT.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got CoT.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#---------------------------------------------------------#
# reverse_tunnel_mnp_BU_using_local_packet_definition()   #
#---------------------------------------------------------#
sub
reverse_tunnel_mnp_BU_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_bu,
		@recv_bu
	) = @_;

	vLogHTML_headline('Reverse Tunneling (BU)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;

	vClear($link{$movement});
	vSend($link{$movement}, $send_bu);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_bu);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_bu);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_bu = $false;

	foreach my $frame (sort(@recv_bu)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_bu	= $true;
			last;
		}
	}

	unless($get_bu) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get BU.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got BU.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#----------------------------------------------------------#
# reverse_tunnel_mnp_BA_using_local_packet_definition()    #
#----------------------------------------------------------#
sub
reverse_tunnel_mnp_BA_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_ba,
		@recv_ba,
	) = @_;

	vLogHTML_headline('Reverse Tunneling (BA)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_ba);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_ba);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_ba);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_ba = $false;

	foreach my $frame (sort(@recv_ba)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_ba	= $true;
			last;
		}
	}

	unless($get_ba) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get BA.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got BA.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-----------------------------------------------------------#
# reverse_tunnel_mnp_BRR_using_local_packet_definition()    #
#-----------------------------------------------------------#
sub
reverse_tunnel_mnp_BRR_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_brr,
		@recv_brr,
	) = @_;

	vLogHTML_headline('Reverse Tunneling (BRR)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_brr);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_brr);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_brr);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_brr = $false;

	foreach my $frame (sort(@recv_brr)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_brr	= $true;
			last;
		}
	}

	unless($get_brr) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get BRR.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got BRR.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#----------------------------------------------------#
# tunnel_mnp_haad_using_local_packet_definition()    #
#----------------------------------------------------#
sub
tunnel_mnp_haad_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_haad,
		@recv_haad,
	) = @_;

	vLogHTML_headline('Tunneling (HAAD Reply)');

	my $cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_haad);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_haad);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_haad);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_haad = $false;

	foreach my $frame (sort(@recv_haad)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_haad	= $true;
			last;
		}
	}

	unless($get_haad) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get HAAD Reply.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got HAAD Reply.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#---------------------------------------------------#
# tunnel_mnp_mpa_using_local_packet_definition()    #
#---------------------------------------------------#
sub
tunnel_mnp_mpa_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_mpa,
		@recv_mpa,
	) = @_;

	vLogHTML_headline('Tunneling (MPA)');

	my $cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_mpa);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_mpa);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_mpa);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_mpa = $false;

	foreach my $frame (sort(@recv_mpa)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_mpa	= $true;
			last;
		}
	}

	unless($get_mpa) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get MPA.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got MPA.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#---------------------------------------------------#
# tunnel_mnp_HoTI_using_local_packet_definition()   #
#---------------------------------------------------#
sub
tunnel_mnp_HoTI_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_hoti,
		@recv_hoti
	) = @_;

	vLogHTML_headline('Tunneling (HoTI)');

	$cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_hoti);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_hoti);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_hoti);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_hoti = $false;

	foreach my $frame (sort(@recv_hoti)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_hoti	= $true;
			last;
		}
	}

	unless($get_hoti) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get HoTI.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got HoTI.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#---------------------------------------------------#
# tunnel_mnp_CoTI_using_local_packet_definition()   #
#---------------------------------------------------#
sub
tunnel_mnp_CoTI_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_coti,
		@recv_coti
	) = @_;

	vLogHTML_headline('Tunneling (CoTI)');

	$cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_coti);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_coti);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_coti);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_coti = $false;

	foreach my $frame (sort(@recv_coti)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_coti	= $true;
			last;
		}
	}

	unless($get_coti) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get CoTI.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got CoTI.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#---------------------------------------------------#
# tunnel_mnp_HoT_using_local_packet_definition()    #
#---------------------------------------------------#
sub
tunnel_mnp_HoT_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_hot,
		@recv_hot,
	) = @_;

	vLogHTML_headline('Tunneling (HoT)');

	my $cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;

	vClear($link{$movement});
	vSend($link{$movement}, $send_hot);



	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_hot);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_hot);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_hot = $false;

	foreach my $frame (sort(@recv_hot)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_hot	= $true;
			last;
		}
	}

	unless($get_hot) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get HoT.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got HoT.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#---------------------------------------------------#
# tunnel_mnp_CoT_using_local_packet_definition()    #
#---------------------------------------------------#
sub
tunnel_mnp_CoT_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_cot,
		@recv_cot,
	) = @_;

	vLogHTML_headline('Tunneling (CoT)');

	my $cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_cot);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_cot);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_cot);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_cot = $false;

	foreach my $frame (sort(@recv_cot)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_cot	= $true;
			last;
		}
	}

	unless($get_cot) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get CoT.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got CoT.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-------------------------------------------------#
# tunnel_mnp_BU_using_local_packet_definition()   #
#-------------------------------------------------#
sub
tunnel_mnp_BU_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_bu,
		@recv_bu
	) = @_;

	vLogHTML_headline('Tunneling (BU)');

	$cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_bu);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_bu);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_bu);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_bu = $false;

	foreach my $frame (sort(@recv_bu)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_bu	= $true;
			last;
		}
	}

	unless($get_bu) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get BU.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got BU.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#--------------------------------------------------#
# tunnel_mnp_BA_using_local_packet_definition()    #
#--------------------------------------------------#
sub
tunnel_mnp_BA_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_ba,
		@recv_ba,
	) = @_;

	vLogHTML_headline('Tunneling (BA)');

	my $cpp = "-D$movement ";
	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;

	vClear($link{$movement});
	vSend($link{$movement}, $send_ba);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_ba);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_ba);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_ba = $false;

	foreach my $frame (sort(@recv_ba)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_ba	= $true;
			last;
		}
	}

	unless($get_ba) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get BA.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got BA.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-----------------------------------------------------------#
# nest_dhaad_confirmation_using_local_packet_definition()   #
#-----------------------------------------------------------#
sub
nest_dhaad_confirmation_using_local_packet_definition($$$$@)
{
	my (
		$movement,
		$haadreq_r,
		$haadrep_r,
		$haad_request,
		@haad_reply,
	) = @_;

	vLogHTML_headline('Dynamic Home Agent Address Discovery');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-DUSE_LOCAL_HAAD_REPLY_DEF ";
	$cpp .= "-D$movement ";
	$cpp .= "-DDHAAD_REQ_R=$haadreq_r ";
	$cpp .= ($haadrep_r < 0)? "-DDHAAD_REP_R=any ": "-DDHAAD_REP_R=$haadrep_r ";

	my @salist = (9, 10);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $haad_request);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @haad_reply);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@haad_reply);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $bool	= $false;

	foreach my $frame (sort(@haad_reply)) {
		if($ret{'recvFrame'} eq $frame) {
			$bool	= $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML_redb('Couldn\'t get HAAD Reply');

		return($false);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#-----------------------------------------------------------#
# nest_mipv6registration_using_local_packet_definition()    #
#-----------------------------------------------------------#
sub
nest_mipv6registration_using_local_packet_definition($$$$$$$$$$$$$$$)
{
	my (
		$movement,
		$bu_sequence,
		$bu_a_bit,
		$bu_h_bit,
		$bu_l_bit,
		$bu_k_bit,
		$bu_r_bit,
		$bu_lifetime,
		$ba_status,
		$ba_k_bit,
		$ba_r_bit,
		$ba_sequence,
		$ba_lifetime,
		$local_bu,
		$local_ba
	) = @_;

	vLogHTML_headline($bu_lifetime? 'Home Registration': 'Home De-Registration');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);
	update_seq_nest_sa1_sa2(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";
	$cpp .= "-DBU_SN=$bu_sequence ";
	$cpp .= "-DBU_A=$bu_a_bit ";
	$cpp .= "-DBU_H=$bu_h_bit ";
	$cpp .= "-DBU_L=$bu_l_bit ";
	$cpp .= "-DBU_K=$bu_k_bit ";
	$cpp .= "-DBU_R=$bu_r_bit ";
	$cpp .= "-DBU_LT=$bu_lifetime ";
	$cpp .= "-DBA_STAT=$ba_status ";
	$cpp .= ($ba_k_bit < 0)? "-DBA_K=any ": "-DBA_K=$ba_k_bit ";
	$cpp .= ($ba_r_bit < 0)? "-DBA_R=any ": "-DBA_R=$ba_r_bit ";
	$cpp .= "-DBA_SN=$ba_sequence ";
	$cpp .= ($ba_lifetime <= 0)?
		"-DBA_LT_OPERAND=EQ ": "-DBA_LT_OPERAND=LE ";
	$cpp .= ($ba_lifetime < 0)? "-DBA_LT=any ": "-DBA_LT=$ba_lifetime ";
	$cpp .= (!$ba_status && !$ba_lifetime)?
		'-DNOT_TO_USE_BINDING_REFRESH_ADVICE ': '';

	my @salist = (9, 10, 101, 102);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my $bu_common	= '';
	$bu_common .= "    Send BU (seq:$bu_sequence, ";
	$bu_common .= $bu_a_bit? 'A': 'a';
	$bu_common .= $bu_h_bit? 'H': 'h';
	$bu_common .= $bu_l_bit? 'L': 'l';
	$bu_common .= $bu_k_bit? 'K': 'k';
	$bu_common .= $bu_r_bit? 'R': 'r';
	$bu_common .= ", ltime:$bu_lifetime) w/ HaO: ";
	$bu_common .= "$mn{$movement} -&gt; RUT (Link0)";

	my $ba_common	= '';
	$ba_common .= "    Recv BA (stat:$ba_status, ";
	$ba_common .= ($ba_k_bit<0)? '': ($ba_k_bit? 'K': 'k');
	$ba_common .= ($ba_r_bit<0)? '': ($ba_r_bit? 'R': 'r');
	$ba_common .= ", seq:$ba_sequence";
	$ba_common .= $ba_lifetime? '': ", ltime:$ba_lifetime";
	$ba_common .= ") w/ RH: RUT (Link0) -&gt; $mn{$movement}";

	$pktdesc{$local_bu}	= $bu_common;
	$pktdesc{$local_ba}	= $ba_common;

	my %ret		= ();
	my $bool	= $false;



	#------------------------------#
	# exitCommon() control         #
	#------------------------------#
	if($ba_status ne 135) {
		$last_accepted_sequence2	= $bu_sequence;
	}

	unless($ba_status) {
		$movement_compat2	= $movement;

		$link_dir		= $link_dir_rv{$movement};

		if ($ba_lifetime) {
			$have_binding_cache2	= $true;
		}
		else {
			$have_binding_cache2	= $false;
		}

		if($bu_l_bit) {
			$linklocal_compat2	= $true;
		}

		if($bu_k_bit) {
			$kbit_compat2		= $true;
		}

		if($bu_r_bit) {
			$mr_regist2		= $true;
		}
	}



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $local_bu);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $local_ba);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$bool	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$local_ba);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $local_ba) {
		vLogHTML_red('Couldn\'t get BA');

		return($false);
	}

	my $base	= 'Frame_Ether.Packet_IPv6';

	if($HAVE_IPSEC && $USE_SA9_SA10) {
		$base .= '.Hdr_ESP.Decrypted.ESPPayload';
	}

	$base .= '.Packet_IPv6';

	if($HAVE_IPSEC && $USE_SA1_SA2) {
		$base .= '.Hdr_ESP.Decrypted.ESPPayload';
	}

	$base .= '.Hdr_MH_BA';

	unless(defined($ret{"$base.Lifetime"})) {
		vLogHTML_red('shuldn\'t reach here');

		exit($V6evalTool::exitFatal);
	}

	$binding_lifetime	= $ret{"$base.Lifetime"};

	unless($bool) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#---------------------------------------------------------#
# nest_mpd_confirmation_using_local_packet_definition()   #
#---------------------------------------------------------#
sub
nest_mpd_confirmation_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$mps,
		@mpa,
	) = @_;

	vLogHTML_headline('Mobile Prefix Discovery');

	my $use_ipsec   = $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);
	update_seq_nest_sa5_sa6(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10, 105, 106);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $mps);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @mpa);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@mpa);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $got_mpa	= $false;

	foreach my $frame (sort(@mpa)) {
		if($ret{'recvFrame'} eq $frame) {
			$got_mpa	= $true;
			last;
		}
	}

	unless($got_mpa) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get MPA');
		}

		return($bool? $false: $true);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	unless($bool) {
		vLogHTML_redb('got MPA');
	}

	return($bool);
}



#---------------------------------------------------------------#
# nest_binding_confirmation_using_local_packet_definition()     #
#---------------------------------------------------------------#
sub
nest_binding_confirmation_using_local_packet_definition($$$$)
{
	my (
		$movement,
		$bool,
		$send_packet,
		$recv_packet
	) = @_;

	vLogHTML_headline('Binding Existence Test');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);
	update_seq_nest_sa5_sa6(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10, 105, 106);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $send_packet);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $recv_packet);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$recv_packet);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $recv_packet) {
		my $packet = $bool? 'Echo Reply w/ RH': 'BE';

		vLogHTML_redb("Couldn't get $packet.");

		return($false);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#------------------------------------------------------------#
# nest_reverse_tunnel_HoTI_using_local_packet_definition()   #
#------------------------------------------------------------#
sub
nest_reverse_tunnel_HoTI_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_hoti,
		@recv_hoti
	) = @_;

	vLogHTML_headline('Reverse Tunneling (HoTI)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);
	update_seq_nest_sa3_sa4(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10, 103, 104);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_hoti);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_hoti);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_hoti);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_hoti = $false;

	foreach my $frame (sort(@recv_hoti)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_hoti	= $true;
			last;
		}
	}

	unless($get_hoti) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get HoTI.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got HoTI.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#----------------------------------------------------#
# nest_tunnel_HoT_using_local_packet_definition()    #
#----------------------------------------------------#
sub
nest_tunnel_HoT_using_local_packet_definition($$$@)
{
	my (
		$movement,
		$bool,
		$send_hot,
		@recv_hot,
	) = @_;

	vLogHTML_headline('Tunneling (HoT)');

	my $cpp = "-D$movement ";
	my @salist = (9, 10, 103, 104);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_hot);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), @recv_hot);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				@recv_hot);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_hot = $false;

	foreach my $frame (sort(@recv_hot)) {
		if($ret{'recvFrame'} eq $frame) {
			$get_hot	= $true;
			last;
		}
	}

	unless($get_hot) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get HoT.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got HoT.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	return($true);
}



#---------------------------------------------------#
# nest_mnp_ereq_using_local_packet_definition()     #
#---------------------------------------------------#
sub
nest_mnp_ereq_using_local_packet_definition($$$$)
{
	my (
		$movement,
		$bool,
		$send_packet,
		$recv_packet
	) = @_;

	vLogHTML_headline('Binding Existence Test');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);
	update_seq_nest_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10, 109, 110);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	# state: ANY (R)
	vClear($link{$movement});
	vSend($link{$movement}, $send_packet);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $recv_packet);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$recv_packet);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	if($ret{'recvFrame'} ne $recv_packet) {
		if ($bool) {
			vLogHTML_redb("Couldn't get Echo Reply.");
		}

		return($bool? $false: $true);
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	unless($bool) {
		vLogHTML_redb('got Echo Reply');
	}

	return($bool? $true: $false);
}



#------------------------------------------------------------#
# nest_reverse_tunnel_ereq_using_local_packet_definition()   #
#------------------------------------------------------------#
sub
nest_reverse_tunnel_ereq_using_local_packet_definition($$$$)
{
	my (
		$movement,
		$bool,
		$send_tunnel_tunnel_ereq,
		$recv_ereq
	) = @_;

	vLogHTML_headline('Reverse Tunneling (payload packet)');

	my $use_ipsec	= $false;

	my $cpp	= '';

	update_seq_sa9_sa10(\$cpp, \$use_ipsec);
	update_seq_nest_sa9_sa10(\$cpp, \$use_ipsec);

	$cpp .= "-D$movement ";

	my @salist = (9, 10, 109, 110);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_tunnel_tunnel_ereq);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $recv_ereq);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$recv_ereq);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}

	my $get_hoti = $false;

	unless($ret{'recvFrame'} eq $recv_ereq) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get Echo.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got Echo.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	unless($bool) {
		vLogHTML_redb('got Echo.');
	}

	return($bool? $true: $false);
}



#----------------------------------------------------#
# nest_tunnel_erep_using_local_packet_definition()   #
#----------------------------------------------------#
sub
nest_tunnel_erep_using_local_packet_definition($$$$)
{
	my (
		$movement,
		$bool,
		$send_erep,
		$recv_tunnel_tunnel_erep,
	) = @_;

	vLogHTML_headline('Tunneling (payload packet)');

	my $cpp = "-D$movement ";
	my @salist = (9, 10, 109, 110);
	my $cpp_ipsec = getSA(@salist);

	ike::VCppRegistMIP($cpp);
	ike::VCppRegistIPsec($cpp_ipsec);
	ike::VCppApply();

	pktdesc_movement($movement);

	my %ret		= ();
	my $unknown	= $false;



	vClear($link{$movement});
	vSend($link{$movement}, $send_erep);

	%ret = IKEvRecv($link{$movement},
		$RETRANS_TIMER + 1, 0, 0,
		sort(keys(%nd_mcast)), $recv_tunnel_tunnel_erep);

	# save unexpect
	push @UNEXPECT, @{ $ret{'SaUnexpect'} };

	foreach my $frame (sort(keys(%nd_mcast))) {
		if($ret{'recvFrame'} eq $frame) {
			# state: INCOMPLETE (R)
			vClear($link{$movement});
			vSend($link{$movement}, $nd_mcast{$frame});

			# state: REACHABLE (R)
			$unknown	= $true;
			%ret = IKEvRecv($link{$movement},
				$RETRANS_TIMER + 1, 0, 0,
				$recv_tunnel_tunnel_erep);

			# save unexpect
			push @UNEXPECT, @{ $ret{'SaUnexpect'} };

			last;
		}
	}


	unless($ret{'recvFrame'} eq $recv_tunnel_tunnel_erep) {
		if($bool) {
			vLogHTML_redb('Couldn\'t get Echo.');

			return($false);
		}
	}
	else {
		unless($bool) {
			vLogHTML_redb('got Echo.');

			return($false);
		}
	}

	unless($unknown) {
		# state: REACHABLE/STALE/DELAY/PROBE (R)
		%ret = IKEvRecv($link{$movement},
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER + 1, 0, 0,
			sort(keys(%nd_ucast)));

		# save unexpect
		push @UNEXPECT, @{ $ret{'SaUnexpect'} };

		foreach my $frame (sort(keys(%nd_ucast))) {
			if($ret{'recvFrame'} eq $frame) {
				# state: PROBE (R)
				vSend($link{$movement}, $nd_ucast{$frame});

				last;
			}
		}

		# state: REACHABLE (R)
	}

	unless($bool) {
		vLogHTML_redb('got Echo.');
	}

	return($bool? $true: $false);
}



1;
