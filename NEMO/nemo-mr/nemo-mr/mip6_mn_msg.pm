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
package mip6_mn_msg;

# EXPORT PACKAGE
use Exporter;
@ISA = qw(Exporter);

@EXPORT = qw(
	%pktdesc
	%IKEsaddesc
);

#-----------------------------------------------------------------------------#
# Packet Description
#-----------------------------------------------------------------------------#
%pktdesc = (
	brr_cn0ga_nuthga                                      => '    Send    Binding Refresh Request: CN0 -> NUT0',
	brr_cn0ga_nuthga_tnl_ha0_nutx                         => '    Send    Binding Refresh Request: CN0 -> NUT0 (HA0 => NUTX)',

	brr_nuthga_cn0ga                                      => '    Receive Binding Refresh Request: NUT0 -> CN0',
	brr_nuthga_cn0ga_tnl_nutx_ha0                         => '    Receive Binding Refresh Request: NUT0 -> CN0 (NUTX => HA0)',
	brr_nuthga_cn0ga_tnl_nuty_ha0                         => '    Receive Binding Refresh Request: NUT0 -> CN0 (NUTY => HA0)',

	hoti_cn0ga_nuthga                                     => '    Send    Home Test Init: CN0 -> NUT0',
	hoti_cn0ga_nuthga_tnl_ha0_nutx                        => '    Send    Home Test Init: CN0 -> NUT0 (HA0 => NUTX)',
	hoti_cn0ga_nuthga_tnl_ha0_nuty                        => '    Send    Home Test Init: CN0 -> NUT0 (HA0 => NUTY)',

	hoti_nuthga_ha0ga                                     => '    Receive Home Test Init: NUT0 -> HA0',
	hoti_nuthga_ha0ga_tnl_nutx_ha0                        => '    Receive Home Test Init: NUT0 -> HA0 (NUTX => HA0)',
	hoti_nuthga_ha0ga_tnl_nutx_ha0_wo_ipsec               => '    Receive Home Test Init: NUT0 -> HA0 (NUTX => HA0 without IPsec)',
	hoti_nuthga_ha0ga_wo_ipsec                            => '    Receive Home Test Init: NUT0 -> HA0 without IPsec',
	hoti_nuthga_ha0ga_wo_ipsec_tnl_nutx_ha0               => '    Receive Home Test Init: NUT0 -> HA0 without IPsec (NUTX => HA0)',

	hoti_nuthga_r1ga                                      => '    Receive Home Test Init: NUT0 -> R1',
	hoti_nuthga_r1ga_tnl_nutx_ha0                         => '    Receive Home Test Init: NUT0 -> R1 (NUTX => HA0)',

	hoti_nuthga_r2ga                                      => '    Receive Home Test Init: NUT0 -> R2',
	hoti_nuthga_r2ga_tnl_nutx_ha0                         => '    Receive Home Test Init: NUT0 -> R2 (NUTX => HA0)',

	hoti_nuthga_cn0ga                                     => '    Receive Home Test Init: NUT0 -> CN0',
	hoti_nuthga_cn0ga_tnl_nuth_ha0                        => '    Receive Home Test Init: NUT0 -> CN0 (NUT0 => HA0)',
	hoti_nuthga_cn0ga_tnl_nutx_ha0                        => '    Receive Home Test Init: NUT0 -> CN0 (NUTX => HA0)',
	hoti_nuthga_cn0ga_tnl_nuty_ha0                        => '    Receive Home Test Init: NUT0 -> CN0 (NUTY => HA0)',

	hoti_nuthga_cn0yga                                    => '    Receive Home Test Init: NUT0 -> CN0Y',
	hoti_nuthga_cn0yga_tnl_nutx_ha0                       => '    Receive Home Test Init: NUT0 -> CN0Y (NUTX => HA0)',
	hoti_nuthga_cn0yga_rh2_cn0ga                          => '    Receive Home Test Init: NUT0 -> CN0Y rh-type2 CN0',
	hoti_nuthga_cn0yga_rh2_cn0ga_tnl_nutx_ha0             => '    Receive Home Test Init: NUT0 -> CN0Y rh-type2 CN0 (NUTX => HA0)',

	hoti_nuthga_cn1ga                                     => '    Receive Home Test Init: NUT0 -> CN1',
	hoti_nuthga_cn1ga_tnl_nutx_ha0                        => '    Receive Home Test Init: NUT0 -> CN1 (NUTX => HA0)',

	hoti_vmn1ga_cn0ga                                     => '    Send    Home Test Init: VMN1 -> CN0 (VMN11 -> NUT1)',
	hoti_vmn1ga_cn0ga_tnl_vmn11_ha3_l2_ing                => '    Send    Home Test Init: VMN1 -> CN0 (VMN11 => HA3) (VMN11 -> NUT1)',
#	hoti_vmn1ga_cn0ga_tnl_vmn11_ha3_tnl_nutx_ha0          => '    Send    Home Test Init: VMN1 -> CN0 (VMM11 => HA3) (VMM11 => NUT1)',
	hoti_vmn1ga_cn0ga_tnl_vmn11_ha3_l2_eg                 => '    Receive Home Test Init: VMN1 -> CN0 (VMN11 => HA3) (NUT0 -> HA0)',
	hoti_vmn1ga_cn0ga_tnl_vmn11_ha3_tnl_nutx_ha0          => '    Receive Home Test Init: VMN1 -> CN0 (VMN11 => HA3) (NUTX => HA0)',

	coti_cn0yga_nuthga                                    => '    Send    Care-of Test Init: CN0Y -> NUT0',
	coti_cn0yga_nuthga_tnl_ha0_nutx                       => '    Send    Care-of Test Init: CN0Y -> NUT0 (HA0 => NUTX)',
	coti_cn0yga_nuthga_tnl_ha0_nuty                       => '    Send    Care-of Test Init: CN0Y -> NUT0 (HA0 => NUTY)',

	coti_nutxga_ha0ga                                     => '    Receive Care-of Test Init: NUTX -> HA0',

	coti_nutxga_r1ga                                      => '    Receive Care-of Test Init: NUTX -> R1',

	coti_nutxga_r2ga                                      => '    Receive Care-of Test Init: NUTX -> R2',

	coti_nuthga_cn0ga                                     => '    Receive Care-of Test Init: NUT0 -> CN0',
	coti_nutxga_cn0ga                                     => '    Receive Care-of Test Init: NUTX -> CN0',
	coti_nutyga_cn0ga                                     => '    Receive Care-of Test Init: NUTY -> CN0',
	coti_nutxga_cn0yga                                    => '    Receive Care-of Test Init: NUTX -> CN0Y',

	coti_nutxga_cn1ga                                     => '    Receive Care-of Test Init: NUTX -> CN1',

	hot_r1ga_nuthga                                       => '    Send    Home Test: R1 -> NUT0',
	hot_r1ga_nuthga_tnl_ha0_nutx                          => '    Send    Home Test: R1 -> NUT0 (HA0 => NUTX)',

	hot_cn0ga_nuthga                                      => '    Send    Home Test: CN0 -> NUT0',
	hot_cn0ga_nuthga_tnl_ha0_nutx                         => '    Send    Home Test: CN0 -> NUT0 (HA0 => NUTX)',
	hot_cn0ga_nuthga_tnl_ha0_nuty                         => '    Send    Home Test: CN0 -> NUT0 (HA0 => NUTY)',
	hot_cn0ga_nuthga_il_len                               => '    Send    Home Test: CN0 -> NUT0 (il-HeaderExtLength)',
	hot_cn0ga_nuthga_il_len_tnl_ha0_nutx                  => '    Send    Home Test: CN0 -> NUT0 (il-HeaderExtLength) (HA0 => NUTX)',

	hot_cn1ga_nuthga                                      => '    Send    Home Test: CN1 -> NUT0',
	hot_cn1ga_nuthga_tnl_ha0_nutx                         => '    Send    Home Test: CN1 -> NUT0 (HA0 => NUTX)',

	hot_cn0ga_vmn1ga                                      => '    Send    Home Test: CN0 -> VMN1 (HA0 -> NUT0)',
	hot_cn0ga_vmn1ga_tnl_ha3_vmn11_l2_eg                  => '    Send    Home Test: CN0 -> VMN1 (HA3 => VMM11) (HA0 -> NUT0)',
	hot_cn0ga_vmn1ga_tnl_ha3_vmn11_tnl_ha0_nutx           => '    Send    Home Test: CN0 -> VMN1 (HA3 => VMN11) (HA0 => NUTX)',
	hot_cn0ga_vmn1ga_tnl_ha3_vmn11_l2_ing                 => '    Receive Home Test: CN0 -> VMN1 (HA3 => VMM11) (NUT1 -> VMM11)',

	hot_nuthga_cn0ga                                      => '    Receive Home Test: NUT0 -> CN0',
	hot_nuthga_cn0ga_tnl_nutx_ha0                         => '    Receive Home Test: NUT0 -> CN0 (NUTX => HA0)',
	hot_nuthga_cn0ga_tnl_nuty_ha0                         => '    Receive Home Test: NUT0 -> CN0 (NUTY => HA0)',

	hot_nutany_cn0ga_hoa_nuthga                           => '    Receive Home Test: NUTany -> CN0 dst-hoa NUT0',
	hot_nutany_cn0ga_hoa_nuthga_tnl_nutany_ha0            => '    Receive Home Test: NUTany -> CN0 dst-hoa NUT0 (NUTany => HA0)',

	hot_nutany_cn0yga                                     => '    Receive Home Test: NUTany -> CN0Y',

	cot_r1ga_nutxga                                       => '    Send    Care-of Test: R1 -> NUTX',

	cot_cn0ga_nuthga                                      => '    Send    Care-of Test: CN0 -> NUT0',
	cot_cn0ga_nutxga                                      => '    Send    Care-of Test: CN0 -> NUTX',
	cot_cn0ga_nutyga                                      => '    Send    Care-of Test: CN0 -> NUTY',

	cot_cn1ga_nutxga                                      => '    Send    Care-of Test: CN1 -> NUTX',

	cot_nuthga_cn0yga                                     => '    Receive Care-of Test: NUT0 -> CN0Y',
	cot_nuthga_cn0yga_tnl_nutx_ha0                        => '    Receive Care-of Test: NUT0 -> CN0Y (NUTX => HA0)',
	cot_nuthga_cn0yga_tnl_nuty_ha0                        => '    Receive Care-of Test: NUT0 -> CN0Y (NUTY => HA0)',

	cot_nutany_cn0yga                                     => '    Receive Care-of Test: NUTany -> CN0Y',
	cot_nutany_cn0yga_hoa_nuthga                          => '    Receive Care-of Test: NUTany -> CN0Y dst-hoa NUT0',
	cot_nutany_cn0yga_hoa_nuthga_tnl_nutany_ha0           => '    Receive Care-of Test: NUTany -> CN0Y dst-hoa NUT0 (NUTany => HA0)',

	bu_any_ha0ga_hoa_any                                  => '    Receive BU: ANY -> HA0 dst-hoa ANY',

	bu_nuthga_ha0ga                                       => '    Receive Binding Update: NUT0 -> HA0',
	bu_nuthga_ha0ga_hoa_nuthga                            => '    Receive Binding Update: NUT0 -> HA0 dst-hoa NUT0',
	bu_nutxga_ha0ga_hoa_nuthga                            => '    Receive Binding Update: NUTX -> HA0 dst-hoa NUT0',
	bu_nutyga_ha0ga_hoa_nuthga                            => '    Receive Binding Update: NUTY -> HA0 dst-hoa NUT0',
	bu_nutxga_ha0ga_hoa_nuthga_implicit                   => '    Receive Binding Update: NUTX -> HA0 dst-hoa NUT0 implicit',
	bu_nutxga_ha0ga_hoa_nuthga_explicit                   => '    Receive Binding Update: NUTX -> HA0 dst-hoa NUT0 explicit',

	bu_nutxga_ha0ga_hoa_nuthga_coa_any_del                => '    Receive Binding Update(delete): NUTX -> HA0 dst-hoa NUT0 alt-coa any',

	bu_nutxga_ha1ga_hoa_nuthga                            => '    Receive Binding Update: NUTX -> HA1 dst-hoa NUT0',
	bu_nutyga_ha1ga_hoa_nuthga                            => '    Receive Binding Update: NUTY -> HA1 dst-hoa NUT0',

	bu_nutxga_ha2ga_hoa_nuthga                            => '    Receive Binding Update: NUTX -> HA2 dst-hoa NUT0',

	bu_nutxga_r1ga_hoa_nuthga                             => '    Receive Binding Update: NUTX -> R1 dst-hoa NUT0',
	bu_nutxga_r1ga_hoa_nuthga_coa_nutx                    => '    Receive Binding Update: NUTX -> R1 dst-hoa NUT0 alt-coa NUTX',

	bu_nuthga_cn0ga                                       => '    Receive Binding Update: NUT0 -> CN0',
	bu_nuthga_cn0ga_hoa_nuthga                            => '    Receive Binding Update: NUT0 -> CN0 dst-hoa NUT0',
	bu_nutxga_cn0ga_hoa_nuthga                            => '    Receive Binding Update: NUTX -> CN0 dst-hoa NUT0',
	bu_nutxga_cn0ga_hoa_nuthga_coa_nutx                   => '    Receive Binding Update: NUTX -> CN0 dst-hoa NUT0 alt-coa NUTX',
	bu_nutxga_cn0ga_hoa_nuthga_coa_nuth_del               => '    Receive Binding Update(delete): NUTX -> CN0 dst-hoa NUT0 alt-coa NUT0',
	bu_nutyga_cn0ga_hoa_nuthga                            => '    Receive Binding Update: NUTY -> CN0 dst-hoa NUT0',
	bu_nutyga_cn0ga_hoa_nuthga_coa_nuty                   => '    Receive Binding Update: NUTY -> CN0 dst-hoa alt-coa NUTY',

	bu_cn0yga_nuthga_hoa_cn0ga                            => '    Send    Binding Update: CN0Y -> NUT0 dst-hoa CN0',
	bu_cn0yga_nuthga_hoa_cn0ga_tnl_ha0_nutx               => '    Send    Binding Update: CN0Y -> NUT0 dst-hoa CN0 (HA0 => NUTX)',
	bu_cn0yga_nuthga_hoa_cn0ga_tnl_ha0_nuty               => '    Send    Binding Update: CN0Y -> NUT0 dst-hoa CN0 (HA0 => NUTY)',

	bu_cn0yga_nuthga_hoa_cn0ga_coa_cn0yga                 => '    Send    Binding Update: CN0Y -> NUT0 dst-hoa CN0 alt-coa CN0Y',
	bu_cn0yga_nuthga_hoa_cn0ga_coa_cn0yga_tnl_ha0_nutx    => '    Send    Binding Update: CN0Y -> NUT0 dst-hoa CN0 alt-coa CN0Y (HA0 => NUTX)',
	bu_cn0yga_nuthga_hoa_cn0ga_coa_cn0yga_tnl_ha0_nuty    => '    Send    Binding Update: CN0Y -> NUT0 dst-hoa CN0 alt-coa CN0Y (HA0 => NUTY)',

	bu_cn0yga_nuthga_hoa_cn0ga_coa_cn0ga_del              => '    Send    Binding Update(delete): CN0Y -> NUT0 dst-hoa CN0 alt-coa CN0',
	bu_cn0yga_nuthga_hoa_cn0ga_coa_cn0ga_del_tnl_ha0_nutx => '    Send    Binding Update(delete): CN0Y -> NUT0 dst-hoa CN0 alt-coa CN0 (HA0 => NUTX)',
	bu_cn0yga_nuthga_hoa_cn0ga_coa_cn0ga_del_tnl_ha0_nuty => '    Send    Binding Update(delete): CN0Y -> NUT0 dst-hoa CN0 alt-coa CN0 (HA0 => NUTY)',

#	bu_cn0yga_nuthga_hoa_cn0ga_coa_cn0ga_del              => '    Send    Binding Update(delete): CN0Y -> NUT0 dst-hoa CN0 alt-coa CN0',
#	bu_cn0yga_nuthga_hoa_cn0ga_coa_cn0ga_del_tnl_ha0_nutx => '    Send    Binding Update(delete): CN0Y -> NUT0 dst-hoa CN0 alt-coa CN0 (HA0 => NUTX)',
#	bu_cn0yga_nuthga_hoa_cn0ga_coa_cn0ga_del_tnl_ha0_nuty => '    Send    Binding Update(delete): CN0Y -> NUT0 dst-hoa CN0 alt-coa CN0 (HA0 => NUTY)',

	ba_ha0ga_nuthga                                       => '    Send    Binding Acknowlegement: HA0 -> NUT0',
	ba_ha0ga_nutxga_rh2_nuthga                            => '    Send    Binding Acknowlegement: HA0 -> NUTX rh-type2 NUT0',
	ba_ha0ga_nutxga_rh2_nuthga_bra                        => '    Send    Binding Acknowlegement: HA0 -> NUTX rh-type2 NUT0 bra',
	ba_ha0ga_nutxga_rh2_nuthga_il_mh                      => '    Send    Binding Acknowlegement: HA0 -> NUTX rh-type2 NUT0 (il-HeaderExtLength)',
	ba_ha0ga_nutxga_rh2_nuthga_wo_ipsec                   => '    Send    Binding Acknowlegement: HA0 -> NUTX rh-type2 NUT0 without IPsec',
	ba_ha0ga_nutyga_rh2_nuthga                            => '    Send    Binding Acknowlegement: HA0 -> NUTY rh-type2 NUT0',

	ba_ha1ga_nutxga_rh2_nuthga                            => '    Send    Binding Acknowlegement: HA1 -> NUTX rh-type2 NUT0',
	ba_ha1ga_nutyga_rh2_nuthga                            => '    Send    Binding Acknowlegement: HA1 -> NUTY rh-type2 NUT0',

	ba_r1ga_nutxga_rh2_nuthga                             => '    Send    Binding Acknowlegement: R1 -> NUTX rh-type2 NUT0',

	ba_cn0ga_nuthga                                       => '    Send    Binding Acknowlegement: CN0 -> NUT0',
	ba_cn0ga_nutxga_rh2_nuthga                            => '    Send    Binding Acknowlegement: CN0 -> NUTX rh-type2 NUT0',
	ba_cn0ga_nutxga_rh2_nuthga_bra                        => '    Send    Binding Acknowlegement: CN0 -> NUTX rh-type2 NUT0 bra',
	ba_cn0ga_nutxga_rh2_nuthga_il_loction_auth            => '    Send    Binding Acknowlegement: CN0 -> NUTX rh-type2 (il-location auth)',
	ba_cn0ga_nutxga_rh2_nuthga_wo_auth                    => '    Send    Binding Acknowlegement: CN0 -> NUTX rh-type2 (without auth)',
	ba_cn0ga_nutyga_rh2_nuthga                            => '    Send    Binding Acknowlegement: CN0 -> NUTY rh-type2 NUT0',

	ba_nuthga_cn0yga_rh2_cn0ga                            => '    Receive Binding Acknowlegement: NUT0 -> CN0Y rh-type2 CN0',
	ba_nuthga_cn0yga_rh2_cn0ga_tnl_nutx_ha0               => '    Receive Binding Acknowlegement: NUT0 -> CN0Y rh-type2 CN0 (NUTX => HA0)',
	ba_nuthga_cn0yga_rh2_cn0ga_tnl_nuty_ha0               => '    Receive Binding Acknowlegement: NUT0 -> CN0Y rh-type2 CN0 (NUTY => HA0)',

	ba_nutany_cn0yga_rh2_cn0ga                            => '    Receive Binding Acknowlegement: NUTany -> CN0Y rh-type2 CN0',
	ba_nutany_cn0yga_rh2_cn0ga_hoa_nuthga                 => '    Receive Binding Acknowlegement: NUTany -> CN0Y rh-type2 CN0 dst-hoa NUT0',
	ba_nutany_cn0yga_rh2_cn0ga_hoa_nuthga_tnl_nutany_ha0  => '    Receive Binding Acknowlegement: NUTany -> CN0Y rh-type2 CN0 dst-hoa NUT0 (NUTany => HA0)',

	ba_ha3ga_vmn11ga_rh2_vmn1ga_l2_eg                     => '    Send    Binding Acknowlegement: HA3 -> VMN11 rh-type2 VMN1 (HA0 -> NUT0)',
	ba_ha3ga_vmn11ga_rh2_vmn1ga_tnl_ha0_nutx              => '    Send    Binding Acknowlegement: HA3 -> VMN11 rh-type2 VMN1 (HA0 => NUTX)',
	ba_ha3ga_vmn11ga_rh2_vmn1ga_l2_ing                    => '    Receive Binding Acknowlegement: HA3 -> VMN11 rh-type2 VMN1 (NUT1 -> VMN11)',

	be_ha0ga_nutxga                                       => '    Send    Binding Error: HA0 -> NUTX',

	be_cn0ga_nuthga                                       => '    Send    Binding Error: CN0 -> NUT0',
	be_cn0ga_nuthga_tnl_ha0_nutx                          => '    Send    Binding Error: CN0 -> NUT0 (HA0 => NUTX)',
	be_cn0ga_nutxga                                       => '    Send    Binding Error: CN0 -> NUTX',

	be_nuthga_ha0ga                                       => '    Receive Binding Error: NUT0 -> HA0',
	be_nuthga_ha0ga_tnl_nutx_ha0                          => '    Receive Binding Error: NUT0 -> HA0 (NUTX => HA0)',
	be_nutxga_ha0ga                                       => '    Receive Binding Error: NUTX -> HA0',

	be_nuthga_cn0ga                                       => '    Receive Binding Error: NUT0 -> CN0',
	be_nuthga_cn0ga_tnl_nutx_ha0                          => '    Receive Binding Error: NUT0 -> CN0 (NUTX => HA0)',

	be_nutxga_cn0ga                                       => '    Receive Binding Error: NUTX -> CN0',

	be_nuthga_cn0yga                                      => '    Receive Binding Error: NUT0 -> CN0Y',
	be_nuthga_cn0yga_tnl_nutx_ha0                         => '    Receive Binding Error: NUT0 -> CN0Y (NUTX => HA0)',

	be_nutany_cn0yga                                      => '    Receive Binding Error: NUTany -> CN0Y',
	be_nutany_cn0yga_hoa_nuth                             => '    Receive Binding Error: NUTany -> CN0Y dst-hoa NUT0',
	be_nutany_cn0yga_hoa_nuth_tnl_nutany_ha0              => '    Receive Binding Error: NUTany -> CN0Y dst-hoa NUT0 (NUTany => HA0)',

	rs_any_any                                            => '    Receive RS: ANY -> ANY',
	rs_any_any_opt_any                                    => '    Receive RS: ANY -> ANY option(free)',

	rs_node0lla_allroutermcast_opt_sll_node0              => '    Send    RS: NODE0(LLA) -> All Router Multicast sll(node0)',
	rs_node0lla_nut0lla_opt_sll_node0                     => '    Send    RS: NODE0(LLA) -> NUT0(LLA) sll(node0)',
	rs_node0lla_nut0ga_opt_sll_node0                      => '    Send    RS: NODE0(LLA) -> NUT0 sll(node0)',
	rs_node0ga_nut0ga_opt_sll_node0                       => '    Send    RS: NODE0 -> NUT0 sll(node0)',
	rs_node1lla_allroutermcast_opt_sll_node1              => '    Send    RS: NODE1(LLA) -> All Router Multicast sll(node1)',
	rs_node1lla_nutxlla_opt_sll_node1                     => '    Send    RS: NODE1(LLA) -> NUTX(LLA) sll(node1)',
	rs_node1lla_nutxga_opt_sll_node1                      => '    Send    RS: NODE1(LLA) -> NUTX sll(node1)',
	rs_node1ga_nutxga_opt_sll_node1                       => '    Send    RS: NODE1 -> NUTX',
	rs_lfn0lla_allroutermcast_opt_sll_lfn0                => '    Send    RS: LFN0(LLA) -> All Router Multicast sll(lfn0)',
	rs_lfn0ga_nut1ga_opt_sll_lfn0                         => '    Send    RS: LFN0 -> NUT1',
	rs_lfn0lla_nut1lla_opt_sll_lfn0                       => '    Send    RS: LFN0(LLA) -> NUT1(LLA)',

	ra_any_any                                            => '    Receive RA: ANY -> ANY',
	ra_any_any_opt_any                                    => '    Receive RA: ANY -> ANY option(free)',

	ra_any_any_sll_any_mtu_pfx_any                        => '    Send    RA: ANY -> ANY sll(any) prefix(any)',
	ra_any_any_sll_any_mtu_pfx_any_hainfo                 => '    Send    RA: ANY -> ANY sll(any) prefix(any) hainfo',

	ra_ha0lla_allnodemcast_sll_ha0_mtu_pfx_link0          => '    Send    RA: HA0(LLA) -> Multicast sll(ha0) prefix(link0)',
	ra_ha0lla_allnodemcast_sll_ha0_mtu_pfx_ha0ga          => '    Send    RA: HA0(LLA) -> Multicast sll(ha0) prefix(ha0)',
	ra_ha0lla_allnodemcast_sll_ha0_mtu_pfx_ha0ga_hainfo   => '    Send    RA: HA0(LLA) -> Multicast sll(ha0) prefix(ha0) hainfo',

	ra_r1lla_allnodemcast_sll_r1_mtu_pfx_linkx            => '    Send    RA: R1(LLA) -> Multicast sll(r1) prefix(linkx)',
	ra_r1lla_allnodemcast_sll_r1_mtu_pfx_r1ga             => '    Send    RA: R1(LLA) -> Multicast sll(r1) prefix(r1)',

	ra_r2lla_allnodemcast_sll_r2_mtu_pfx_linky            => '    Send    RA: R2(LLA) -> Multiacast sll(r2) prefix(linky)',
	ra_r2lla_allnodemcast_sll_r2_mtu_pfx_r2ga             => '    Send    RA: R2(LLA) -> Multicast sll(r2) prefix(r2)',

	ra_nut0lla_node0lla                                   => '    Receive RA: NUT0(LLA) -> NODE0(LLA)',
	ra_nut0lla_node0lla_opt_any                           => '    Receive RA: NUT0(LLA) -> NODE0(LLA) option(free)',
	ra_nut0ga_node0ga                                     => '    Receive RA: NUT0 -> NODE0',
	ra_nut0ga_node0ga_opt_any                             => '    Receive RA: NUT0 -> NODE0 option(free)',
	ra_nut0lla_allnodemcast                               => '    Receive RA: NUT0(LLA) -> Multicast',
	ra_nut0lla_allnodemcast_opt_any                       => '    Receive RA: NUT0(LLA) -> Multicast option(free)',
	ra_nut1lla_lfn0lla                                    => '    Receive RA: NUT1(LLA) -> LFN0(LLA)',
	ra_nut1lla_allnodemcast                               => '    Receive RA: NUT1(LLA) -> Multicast',
	ra_nut1lla_allnodemcast_opt_any                       => '    Receive RA: NUT1(LLA) -> Multicast option(free)',
	ra_nut1ga_lfn0ga                                      => '    Receive RA: NUT1 -> LFN0',
	ra_nutxlla_node1lla                                   => '    Receive RA: NUTX(LLA) -> NODE1(LLA)',
	ra_nutxlla_node1lla_opt_any                           => '    Receive RA: NUTX(LLA) -> NODE1(LLA) option(free)',
	ra_nutxga_node1ga                                     => '    Receive RA: NUTX -> NODE1',
	ra_nutxga_node1ga_opt_any                             => '    Receive RA: NUTX -> NODE1 option(free)',
	ra_nutxlla_allnodemcast                               => '    Receive RA: NUTX(LLA) -> Multicast',
	ra_nutxlla_allnodemcast_opt_any                       => '    Receive RA: NUTX(LLA) -> Multicast option(free)',

	ns_any_any                                            => '    Receive NS: ANY -> ANY',
	ns_any_any_w_ipsec                                    => '    Receive NS: ANY -> ANY with IPsec',
	ns_any_any_opt_any                                    => '    Receive NS: ANY -> ANY option(free)',
	ns_any_any_opt_any_w_ipsec                            => '    Receive NS: ANY -> ANY option(free) with IPsec',

	ns_0_nuthsol_tgt_nuthga                               => '    Receive NS: 0 -> MULTI target(nut0)',

	ns_nut0ga_ha0ga_tgt_ha0ga                             => '    Receive NS: NUT0 -> HA0 target(ha0)',
	ns_nutxlla_r1lla_tgt_r1ga                             => '    Receive NS: NUTX(LLA) -> R1(LLA) target(r1)',
	ns_nutxlla_r1ga_tgt_r1ga                              => '    Receive NS: NUTX(LLA) -> R1 target(r1)',

	ns_ha0ga_nuthsol_tgt_nuthga_sll_ha0                   => '    Send    NS: HA0 -> NUT0(SOL) target(nut0) sll(ha0)',

	ns_r1ga_nutxga_tgt_nutxga                             => '    Send    NS: R1 -> NUTX target(nutx)',

	ns_0_nut0sol_tgt_nut0ga                               => '    Send    NS: 0 -> NUT0(SOL) target(nut0)',
	ns_0_nut0sol_tgt_nut0lla                              => '    Send    NS: 0 -> NUT0(SOL) target(nut0 lla)',
	ns_0_nut0sol_tgt_nut0ga_sll_r1                        => '    Send    NS: 0 -> NUT0(SOL) target(nut0) sll(r1)',
	ns_0_nutxsol_tgt_nutxga                               => '    Send    NS: 0 -> NUTX(SOL) target(nutx)',
	ns_0_nutxsol_tgt_nutxlla                              => '    Send    NS: 0 -> NUT0(SOL) target(nutx lla)',
	ns_r1ga_nutxsol_tgt_nut0ga_sll_r1                     => '    Send    NS: R1 -> NUTX(SOL) target(nut0) sll(r1)',
	ns_node0lla_nut0sol_tgt_nut0lla_sll_node0             => '    Send    NS: NODE0(LLA) -> NUT0(SOL) target(nut0lla) sll(node0)',
	ns_node0ga_nut0sol_tgt_nut0ga_sll_node0               => '    Send    NS: NODE0 -> NUT0(SOL) target(nut0) sll(node0)',

#	ns_node1ga_nutxsol_tgt_nutxga_tll_nutx_sll_node1      => '    Send    NS: NODE1 -> NUTX(SOL) target(nutx) tll(nutx) sll(node1)',
	ns_node1ga_nutxsol_tgt_nutxga_sll_node1               => '    Send    NS: NODE1 -> NUTX(SOL) target(nutx) sll(node1)',

#	ns_node1ga_nutxsol_tgt_nutxlla_tll_nutx_sll_node1     => '    Send    NS: NODE1 -> NUTX(SOL) target(nutx lla) tll(nutx) sll(node1)',
 	ns_node1ga_nutxsol_tgt_nutxlla_sll_node1              => '    Send    NS: NODE1 -> NUTX(SOL) target(nutx lla) sll(node1)',
#	ns_node1lla_nutxsol_tgt_nutxlla_tll_nutx_sll_node1    => '    Send    NS: NODE1 -> NUTX(SOL) target(nutx lla) tll(nutx) sll(node1)',
	ns_node1lla_nutxsol_tgt_nutxlla_sll_node1             => '    Send    NS: NODE1 -> NUTX(SOL) target(nutx lla) sll(node1)',

#	ns_node1ga_nutxsol_tgt_nut0ga_tll_nut0_sll_node1      => '    Send    NS: NODE1 -> NUTX(SOL) target(nut0) tll(nut0) sll(node1)',
#	ns_node1ga_nutxsol_tgt_nut0lla_tll_nut0_sll_node1     => '    Send    NS: NODE1 -> NUTX(SOL) target(nut0 lla) tll(nut0) sll(node1)',
	ns_node1ga_nutxsol_tgt_nut0ga_sll_node1               => '    Send    NS: NODE1 -> NUTX(SOL) target(nut0) sll(node1)',
	ns_node1ga_nutxsol_tgt_nut0lla_sll_node1              => '    Send    NS: NODE1 -> NUTX(SOL) target(nut0 lla) sll(node1)',

	na_any_any                                            => '    Receive NA: ANY -> ANY',
	na_any_any_opt_any                                    => '    Receive NA: ANY -> ANY option(free)',
	na_any_any_hoa_nuthga                                 => '    Receive NA: ANY -> ANY dst-hoa NUT0',
	na_any_any_hoa_nuthga_opt_any                         => '    Receive NA: ANY -> ANY dst-hoa NUT0 option(free)',

	na_any_any_tll_any                                    => '    Send    NA: ANY -> ANY tll(any)',
	na_any_any_tll_any_w_ipsec                            => '    Send    NA: ANY -> ANY tll(any) with IPsec',

	na_ha0lla_alnodemcast_tgt_nuthlla_tll_ha0             => '    Send    NA: HA0(LLA) -> Multicast target(nut0 lla) tll(ha0)',
	na_ha0lla_alnodemcast_tgt_nuthga_tll_ha0              => '    Send    NA: HA0(LLA) -> Multicast target(nut0) tll(ha0)',

	na_ha0ga_alnodemcast_tgt_nut0ga_tll_ha0               => '    Send    NA: HA0 -> Multicast target(nuth) tll(ha0)',
	na_ha0ga_nut0ga_tgt_ha0ga_tll_ha0                     => '    Send    NA: HA0 -> NUT0 target(ha0) tll(ha0)',

	na_nuthlla_ha0ga_tgt_nuthga                           => '    Receive NA: NUT0(LLA) -> HA0 target(nut0)',
	na_nuthlla_ha0ga_tgt_nuthga_tll_nuth                  => '    Receive NA: NUT0(LLA) -> HA0 target(nut0) tll(nut0)',
	na_nuthga_ha0ga_tgt_nuthga                            => '    Receive NA: NUT0 -> HA0 target(nut0)',
	na_nuthga_ha0ga_tgt_nuthga_tll_nuth                   => '    Receive NA: NUT0 -> HA0 target(nut0) tll(nut0)',

	na_nut0lla_node0lla_tgt_nut0lla                       => '    Receive NA: NUT0(LLA) -> NODE0(LLA) target(nut0 lla)',
	na_nut0lla_node0lla_tgt_nut0lla_tll_nut0              => '    Receive NA: NUT0(LLA) -> NODE0(LLA) target(nut0 lla) tll(nut0)',
	na_nut0ga_node0ga_tgt_nut0ga                          => '    Receive NA: NUT0 -> NODE0 target(nut0)',
	na_nut0ga_node0ga_tgt_nut0ga_tll_nut0                 => '    Receive NA: NUT0 -> NODE0 target(nut0) tll(nut0)',
	na_nut0lla_alnodemcast_tgt_nut0lla                    => '    Receive NA: NUT0(LLA) -> Multicast target(nut0 lla)',
	na_nut0lla_alnodemcast_tgt_nut0lla_tll_nut0           => '    Receive NA: NUT0(LLA) -> Multicast target(nut0 lla) tll(nut0)',
	na_nut0ga_alnodemcast_tgt_nut0ga                      => '    Receive NA: NUT0 -> Multicast target(nut0)',
	na_nut0ga_alnodemcast_tgt_nut0ga_tll_nut0             => '    Receive NA: NUT0 -> Multicast target(nut0) tll(nut0)',
	na_nutxlla_alnodemcast_tgt_nutxlla                    => '    Receive NA: NUTX -> Multicast target(nutx lla)',
	na_nutxlla_alnodemcast_tgt_nutxlla_tll_nutx           => '    Receive NA: NUTX -> Multicast target(nutx lla) tll(nutx)',
	na_nutxga_alnodemcast_tgt_nutxga                      => '    Receive NA: NUTX -> Multicast target(nutx)',
	na_nutxga_alnodemcast_tgt_nutxga_tll_nutx             => '    Receive NA: NUTX -> Multicast target(nutx) tll(nutx)',
	na_nutxlla_node1ga_tgt_nutxlla                        => '    Receive NA: NUTX -> NODE1 target(nutx lla)',
	na_nutxlla_node1ga_tgt_nutxlla_tll_nutx               => '    Receive NA: NUTX -> NODE1 target(nutx lla) tll(nutx)',
	na_nutxga_node1ga_tgt_nutxga                          => '    Receive NA: NUTX -> NODE1 target(nutx)',
	na_nutxga_node1ga_tgt_nutxga_tll_nutx                 => '    Receive NA: NUTX -> NODE1 target(nutx) tll(nutx)',

	echorequest_any_any                                   => '    Receive Echo Request: ANY -> ANY',
	echorequest_any_any_tnl_any_any                       => '    Receive Echo Request: ANY -> ANY (ANY => ANY)',
	echorequest_any_any_tnl_any_any_tnl_any_any           => '    Receive Echo Request: ANY -> ANY (ANY => ANY) (ANY => ANY)',

	echorequest_ha0ga_nut0ga                              => '    Send    Echo Request: HA0 -> NUT0',
	echorequest_ha0ga_nuthga                              => '    Send    Echo Request: HA0 -> NUT0',
	echorequest_ha0ga_nuthga_tnl_ha0_nutx                 => '    Send    Echo Request: HA0 -> NUT0 (HA0 => NUTX)',
	echorequest_ha0ga_nuthga_tnl_ha0_nutx_wo_ipsec        => '    Send    Echo Request: HA0 -> NUT0 (HA0 => NUTX without IPsec)',
	echorequest_ha0ga_nuthga_wo_ipsec                     => '    Send    Echo Request: HA0 -> NUT0 without IPsec',
	echorequest_ha0ga_nuthga_wo_ipsec_tnl_ha0_nutx        => '    Send    Echo Request: HA0 -> NUT0 without IPsec (HA0 => NUTX)',
	echorequest_ha0ga_nutxga_rh2_nuthga                   => '    Send    Echo Request: HA0 -> NUTX rh-type2 NUT0',
	echorequest_ha0ga_nutyga_rh2_nuthga                   => '    Send    Echo Request: HA0 -> NUTY rh-type2 NUT0',

	echorequest_ha1ga_nutxga_rh2_nuthga                   => '    Send    Echo Request:HA1 -> NUTX rh-type2 NUTH',

	echorequest_r1lla_nutxlla                             => '    Send    Echo Request: R1(LLA) -> NUTX(LLA)',
	echorequest_r1ga_nuthga                               => '    Send    Echo Request: R1 -> NUT0',
	echorequest_r1ga_nuthga_tnl_ha0_nutx                  => '    Send    Echo Request: R1 -> NUT0 (HA0 => NUTX)',

	echorequest_r2ga_nuthga                               => '    Send    Echo Request: R2 -> NUT0',
	echorequest_r2ga_nuthga_tnl_ha0_nutx                  => '    Send    Echo Request: R2 -> NUT0 (HA0 => NUTX)',

	echorequest_cn0ga_node0ga                             => '    Send    Echo Request: CN0 -> NODE0',
	echorequest_cn0ga_node0ga_tnl_ha0_nutx                => '    Send    Echo Request: CN0 -> NODE0 (HA0 => NUTX)',

	echorequest_cn0ga_nut0ga                              => '    Send    Echo Request: CN0 -> NUT0',
	echorequest_cn0ga_nuthga                              => '    Send    Echo Request: CN0 -> NUT0',
	echorequest_cn0ga_nuthga_tnl_ha0_nutx                 => '    Send    Echo Request: CN0 -> NUT0 (HA0 => NUTX)',
	echorequest_cn0ga_nuthga_tnl_ha0_nuty                 => '    Send    Echo Request: CN0 -> NUT0 (HA0 => NUTY)',

	echorequest_cn0ga_nutxga                              => '    Send    Echo Request: CN0 -> NUTX',
	echorequest_cn0ga_nutxga_rh2_nuthga                   => '    Send    Echo Request: CN0 -> NUTX rh-type2 NUT0',
	echorequest_cn0ga_nutxga_rh2_nuthga_il_len4           => '    Send    Echo Request: CN0 -> NUTX rh-type2 NUT0 (il-HeaderExtLength)',
	echorequest_cn0ga_nutxga_rh2_nuthga_il_seg0           => '    Send    Echo Request: CN0 -> NUTX rh-type2 NUT0 (il-SegmentsLeft)',
	echorequest_cn0ga_nutxga_rh2_node0ga                  => '    Send    Echo Request: CN0 -> NUTX rh-type2 (il-Address)',
	echorequest_cn0ga_nutyga_rh2_nuthga                   => '    Send    Echo Request: CN0 -> NUTY rh-type2 NUT0',

	echorequest_cn0yga_nuthga                             => '    Send    Echo Request: CN0Y -> NUT0',
	echorequest_cn0yga_nuthga_hoa_cn0ga                   => '    Send    Echo Request: CN0Y -> NUT0 dst-hoa CN0',
	echorequest_cn0yga_nuthga_hoa_cn0ga_tnl_ha0_nutx      => '    Send    Echo Request: CN0Y -> NUT0 dst-hoa CN0 (HA0 => NUTX)',
	echorequest_cn0yga_nuthga_hoa_cn0ga_tnl_ha0_nuty      => '    Send    Echo Request: CN0Y -> NUT0 dst-hoa CN0 (HA0 => NUTY)',
	echorequest_cn0yga_nutxga_rh2_nuthga_hoa_cn0ga        => '    Send    Echo Request: CN0Y -> NUTX rh-type2 NUT0 dst-hoa CN0',
	echorequest_cn0yga_nutyga_rh2_nuthga_hoa_cn0ga        => '    Send    Echo Request: CN0Y -> NUTY rh-type NUT0 dst-hoa CN0',

	echorequest_cn1ga_nuthga                              => '    Send    Echo Request: CN1 -> NUT0',
	echorequest_cn1ga_nuthga_tnl_ha0_nutx                 => '    Send    Echo Request: CN1 -> NUT0 (HA0 => NUTX)',

	echorequest_nuthga_cn0ga                              => '    Receive Echo Request: NUT0 -> CN0',

	echorequest_cn0ga_lfn0ga_l2_eg                        => '    Send    Echo Request: CN0 -> LFN0 (HA0 -> NUT0)',
	echorequest_cn0ga_lfn0ga_tnl_ha0_nutx                 => '    Send    Echo Request: CN0 -> LFN0 (HA0 => NUTX)',
	echorequest_cn0ga_lfn0ga_tnl_ha0_nuty                 => '    Send    Echo Request: CN0 -> LFN0 (HA0 => NUTY)',
	echorequest_cn0ga_lfn0ga_tnl_ha1_nutx                 => '    Send    Echo Request: CN0 -> LFN0 (HA1 => NUTX)',
	echorequest_cn0ga_lfn0ga_l2_ing                       => '    Receive Echo Request: CN0 -> LFN0 (NUT1 -> LFN0)',

	echorequest_lfn0ga_cn0ga_l2_ing                       => '    Send    Echo Request: LFN0 -> CN0 (LFN0 -> NUT1)',
	echorequest_lfn0ga_cn0ga_tnl_lfn1_nut1                => '    Send    Echo Request: LFN0 -> CN0 (il-LFN1 => NUT1))',
	echorequest_lfn0ga_cn0ga_l2_eg                        => '    Receive Echo Request: LFN0 -> CN0 (NUT0 -> HA0)',
	echorequest_lfn0ga_cn0ga_tnl_nutx_ha0                 => '    Receive Echo Request: LFN0 -> CN0 (NUTX => HA0)',
	echorequest_lfn0ga_cn0ga_tnl_nuty_ha0                 => '    Receive Echo Request: LFN0 -> CN0 (NUTY => HA0)',
	echorequest_lfn0ga_cn0ga_tnl_nut1_nut1                => '    Send    Echo Request: LFN0 -> CN0 (il-NUT1 => NUT1)',

	echorequest_lfn1ga_cn0ga_l2_ing                       => '    Send    Echo Request: il-LFN1 -> CN0 (il-LFN1 -> NUT1)',
	echorequest_lfn1ga_cn0ga_tnl_lfn0_nut1                => '    Send    Echo Request: il-LFN1 -> CN0 (LFN0 => NUT1)',

	echorequest_lfn1ga_cn0ga_l2_eg                        => '    Receive Echo Request: il-LFN1 -> CN0 (NUTX -> HA0)',
	echorequest_lfn1ga_cn0ga_tnl_nutx_ha0                 => '    Receive Echo Request: il-LFN1 -> CN0 (NUTX => HA0)',

	echorequest_nut1ga_cn0ga_l2_ing                       => '    Send    Echo Request:il-NUT1 -> CN0 (il-NUT1 -> NUT1)',
	echorequest_nut1ga_cn0ga_tnl_lfn0_nut1                => '    Send    Echo Request:il-NUT1 -> CN0 (LFN0 => NUT1)',
	echorequest_nut1ga_cn0ga_tnl_nutx_ha0                 => '    Receive Echo Request:il-NUT1 -> CN0 (NUTX => HA0)',
	echorequest_any_any                                   => '    Receive Echo Request: ANY -> ANY',
	echorequest_any_any_tnl_any_any                       => '    Receive Echo Request: ANY -> ANY (ANY => ANY)',
	echorequest_any_any_tnl_any_any_tnl_any_any           => '    Receive Echo Request: ANY -> ANY (ANY => ANY) (ANY => ANY)',

	echoreply_any_any                                     => '    Receive Echo Reply: ANY -> ANY',
	echoreply_any_any_tnl_any_any                         => '    Receive Echo Reply: ANY -> ANY (ANY => ANY)',
	echoreply_any_any_tnl_any_any_tnl_any_any             => '    Receive Echo Reply: ANY -> ANY (ANY => ANY) (ANY => ANY)',
	echoreply_any_any_rh2_any                             => '    Receive Echo Reply: ANY -> ANY rh-type2 ANY',

	echoreply_any_cn0ga                                   => '    Receive Echo Reply: ANY -> CN0 (receive any il-packet)',

	echoreply_nut0ga_ha0ga                                => '    Receive Echo Reply: NUT0 -> HA0',

	echoreply_nuthga_ha0ga                                => '    Receive Echo Reply: NUT0 -> HA0',
	echoreply_nuthga_ha0ga_l2_any                         => '    Receive Echo Reply: NUT0 -> HA0 L2 any',
	echoreply_nuthga_ha0ga_tnl_nutx_ha0                   => '    Receive Echo Reply: NUT0 -> HA0 (NUTX => HA0)',
	echoreply_nuthga_ha0ga_tnl_nuty_ha0                   => '    Receive Echo Reply: NUT0 -> HA0 (NUTY => HA0)',
	echoreply_nutxga_ha0ga_hoa_nuthga                     => '    Receive Echo Reply: NUTX -> HA0 dst-hoa NUT0',
	echoreply_nutxga_ha0ga_hoa_nuthga_tnl_nutx_ha0        => '    Receive Echo Reply: NUTX -> HA0 dst-hoa NUT0 (NUT0 => HA0)',
	echoreply_nutyga_ha0ga                                => '    Receive Echo Reply: NUTY -> HA0',
	echoreply_nutyga_ha0ga_hoa_nuthga                     => '    Receive Echo Reply: NUTY -> HA0 dst-hoa NUT0',
	echoreply_nutyga_ha0ga_tnl_nuty_ha0                   => '    Receive Echo Reply: NUTY -> HA0 (NUTY => HA0)',
	echoreply_nutyga_ha0ga_hoa_nuthga_tnl_nuty_ha0        => '    Receive Echo Reply: NUTY -> HA0 dst-hoa NUT0 (NUTY => HA0)',

	echoreply_nut0ga_ha1ga                                => '    Receive Echo Reply: NUT0 -> HA1',

	echoreply_nuthga_ha1ga                                => '    Receive Echo Reply: NUT0 -> HA1',
	echoreply_nuthga_ha1ga_l2_any                         => '    Receive Echo Reply: NUT0 -> HA1 L2 any',
	echoreply_nuthga_ha1ga_tnl_nutx_ha1                   => '    Receive Echo Reply: NUT0 -> HA1 (NUTX => HA1)',
	echoreply_nutxga_ha1ga_hoa_nuthga                     => '    Receive Echo Reply: NUTX -> HA1 dst-hoa NUT0',
	echoreply_nutxga_ha1ga_hoa_nuthga_tnl_nutx_ha1        => '    Receive Echo Reply: NUTX -> HA1 dst-hoa NUT0 (NUT0 => HA1)',

	echoreply_nuthga_r1ga                                 => '    Receive Echo Reply: NUT0 -> R1',
	echoreply_nuthga_r1ga_tnl_nutx_ha0                    => '    Receive Echo Reply: NUT0 -> R1 (NUTX => HA0)',
	echoreply_nutxga_r1ga_hoa_nuthga                      => '    Receive Echo Reply: NUTX -> R1 dst-hoa NUT0',
	echoreply_nutxlla_r1lla                               => '    Receive Echo Reply: NUTX(LLA) -> R1(LLA)',

	echoreply_nuthga_r2ga                                 => '    Receive Echo Reply: NUT0 -> R2',
	echoreply_nuthga_r2ga_tnl_nutx_ha0                    => '    Receive Echo Reply: NUT0 -> R2 (NUTX => HA0)',

	echoreply_nut0ga_cn0ga                                => '    Receive Echo Reply: NUT0 -> CN0',
	echoreply_nuthga_cn0ga                                => '    Receive Echo Reply: NUT0 -> CN0',
	echoreply_nuthga_cn0ga_tnl_nutx_ha0                   => '    Receive Echo Reply: NUT0 -> CN0 (NUTX => HA0)',
	echoreply_nuthga_cn0ga_tnl_nuty_ha0                   => '    Receive Echo Reply: NUT0 -> CN0 (NUTY => HA0)',

	echoreply_nutxga_cn0ga                                => '    Receive Echo Reply: NUTX -> CN0',
	echoreply_nutxga_cn0ga_hoa_nuthga                     => '    Receive Echo Reply: NUTX -> CN0 dst-hoa NUT0',

	echoreply_nutyga_cn0ga                                => '    Receive Echo Reply: NUTY -> CN0',
	echoreply_nutyga_cn0ga_hoa_nuthga                     => '    Receive Echo Reply: NUTY -> CN0 dst-hoa NUT0',

	echoreply_nuthga_cn0yga                               => '    Receive Echo Reply: NUT0 -> CN0Y',
	echoreply_nuthga_cn0yga_rh2_cn0ga                     => '    Receive Echo Reply: NUT0 -> CN0Y rh-type2 CN0',
	echoreply_nuthga_cn0yga_rh2_cn0ga_tnl_nutany_ha0      => '    Receive Echo Reply: NUT0 -> CN0Y rh-type2 CN0 (NUTX => HA0)',
	echoreply_nutxga_cn0yga_rh2_cn0ga_hoa_nuthga          => '    Receive Echo Reply: NUTX -> CN0Y rh-type2 CN0 dst-hoa CN0',
	echoreply_nutyga_cn0yga_rh2_cn0ga_hoa_nuthga          => '    Receive Echo Reply: NUTY -> CN0Y rh-type2 CN0 dst-hoa NUT0',

	echoreply_nuthga_cn1ga                                => '    Receive Echo Reply: NUT0 -> CN1',
	echoreply_nuthga_cn1ga_tnl_nutx_ha0                   => '    Receive Echo Reply: NUT0 -> CN1 (NUTX => HA0)',

	echoreply_cn0ga_lfn0ga_l2_eg                          => '    Send    Echo Reply: CN0 -> LFN0 (HA0 -> NUT0)',
	echoreply_cn0ga_lfn0ga_tnl_ha0_nutx                   => '    Send    Echo Reply: CN0 -> LFN0 (HA0 => NUTX)',
	echoreply_cn0ga_lfn0ga_tnl_ha0_nuty                   => '    Send    Echo Reply: CN0 -> LFN0 (HA0 => NUTY)',
	echoreply_cn0ga_lfn0ga_l2_ing                         => '    Receive Echo Reply: CN0 -> LFN0 (NUT1 -> LFN0)',

	echoreply_lfn0ga_cn0ga_l2_ing                         => '    Send    Echo Reply: LFN0 -> CN0 (LFN0 -> NUT1)',

	echoreply_lfn0ga_cn0ga_l2_eg                          => '    Receive Echo Reply: LFN0 -> CN0 (NUT0 -> HA0)',
	echoreply_lfn0ga_cn0ga_tnl_nutx_ha0                   => '    Receive Echo Reply: LFN0 -> CN0 (NUTX => HA0)',
	echoreply_lfn0ga_cn0ga_tnl_nuty_ha0                   => '    Receive Echo Reply: LFN0 -> CN0 (NUTY => HA0)',

	echoreply_lfn0ga_cn0ga_tnl_nutx_ha1                   => '    Receive Echo Reply: LFN0 -> CN0 (NUTX => HA1)',

	icmp6_du_nuthga_cn0ga_pay_any                         => '    Receive ICMPv6 Destination Unreachable: NUT0 -> CN0 pay(any)',
	icmp6_du_nuthga_cn0ga_pay_any_tnl_nutx_ha0            => '    Receive ICMPv6 Destination Unreachable: NUT0 -> CN0 pay(any) (NUTX => HA0)',

	icmp6_du_r2ga_nuthga_pay_hoti                         => '    Send    ICMPv6 Destination Unreachable: R2 -> NUT0 pay(hoti)',
	icmp6_du_r2ga_nuthga_pay_hoti_tnl_ha0_nutx            => '    Send    ICMPv6 Destination Unreachable: R2 -> NUT0 pay(hoti) (HA0 => NUTX)',
	icmp6_du_r2ga_nutxga_pay_coti                         => '    Send    ICMPv6 Destination Unreachable: R2 -> NUTX pay(coti)',

	icmp6_pp_ha0ga_nutxga_pay_bu                          => '    Send    ICMPv6 Parameter Problem: HA0 -> NUTX pay(bu)',

	icmp6_pp_cn0ga_nuthga_pay_echorequest                 => '    Send    ICMPv6 Parameter Problem: CN0 -> NUT0 pay(echo request)',
	icmp6_pp_cn0ga_nuthga_pay_echorequest_tnl_ha0_nutx    => '    Send    ICMPv6 Parameter Problem: CN0 -> NUT0 pay(echo request) (HA0 => NUTX)',

	icmp6_pp_cn0ga_nuthga_pay_hoti                        => '    Send    ICMPv6 Parameter Problem: CN0 -> NUT0 pay(hoti)',
	icmp6_pp_cn0ga_nuthga_pay_hoti_tnl_ha0_nutx           => '    Send    ICMPv6 Parameter Problem: CN0 -> NUT0 pay(hoti) (HA0 => NUTX)',

	icmp6_pp_cn0ga_nutxga_pay_hoti                        => '    Send    ICMPv6 Parameter Problem: CN0 -> NUTX pay(hoti)',
	icmp6_pp_cn0ga_nutxga_pay_coti                        => '    Send    ICMPv6 Parameter Problem: CN0 -> NUTX pay(coti)',
	icmp6_pp_cn0ga_nutxga_pay_bu                          => '    Send    ICMPv6 Parameter Problem: CN0 -> NUTX pay(bu)',

	icmp6_pp_cn0ga_nutxga_rh2_nuthga_pay_echoreply        => '    Send    ICMPv6 Parameter Problem: CN0 -> NUTX rh-type2 NUT0 pay(echo request)',

	icmp6_pp_nuthga_ha0ga_pay_any                         => '    Receive ICMPv6 Parameter Problem: NUT0 -> HA0 pay(any)',
	icmp6_pp_nuthga_ha0ga_pay_any_tnl_nutx_ha0            => '    Receive ICMPv6 Parameter Problem: NUT0 -> HA0 pay(any) (NUTX => HA0)',

	icmp6_pp_nutxga_ha0ga_pay_any                         => '    Receive ICMPv6 Parameter Problem: NUTX -> HA0 pay(any)',
	icmp6_pp_nutxga_ha0ga_hoa_nuthga_pay_any              => '    Receive ICMPv6 Parameter Problem: NUTX -> HA0 dst-hoa NUT0 pay(any)',

	icmp6_pp_nuthga_cn0ga_pay_any                         => '    Receive ICMPv6 Parameter Problem: NUT0 -> CN0 pay(any)',
	icmp6_pp_nuthga_cn0ga_pay_any_tnl_nutx_ha0            => '    Receive ICMPv6 Parameter Problem: NUT0 -> CN0 pay(any) (NUTX => HA0)',
	icmp6_pp_nuthga_cn0ga_pay_any_tnl_nutany_ha0          => '    Receive ICMPv6 Parameter Problem: NUT0 -> CN0 pay(any) (NUTany => HA0)',

	icmp6_pp_nutany_cn0ga_pay_any                         => '    Receive ICMPv6 Parameter Problem: NUTany -> CN0 pay(any)',
	icmp6_pp_nutany_cn0ga_hoa_nuthga_pay_any              => '    Receive ICMPv6 Parameter Problem: NUTany -> CN0 dst-hoa NUT0 pay(any)',

	icmp6_pp_nutxga_cn1ga_pay_any                         => '    Receive ICMPv6 Parameter Problem: NUTX -> CN1 pay(any)',
	icmp6_pp_nutxga_cn1ga_hoa_nuthga_pay_any              => '    Receive ICMPv6 Parameter Problem: NUTX -> CN1 dst-hoa(nut0) pay(any)',

	haadrequest_nut0lla_link0haany                        => '    Receive Home Agent Address Discovery Request: NUT0(LLA) -> HAanycast',
	haadrequest_nuthga_link0haany                         => '    Receive Home Agent Address Discovery Request: NUT0 -> HAanycast',
	haadrequest_nutxga_link0haany                         => '    Receive Home Agent Address Discovery Request: NUTX -> HAanycast',
	haadrequest_nutyga_link0haany                         => '    Receive Home Agent Address Discovery Request: NUTY -> HAanycast',

	haadreply_ha0lla_nut0lla_list_ha0                     => '    Send    Home Agent Address Discovery Reply: HA0(LLA) -> NUT0 list(ha0)',
	haadreply_ha0ga_nuthga_list_ha0                       => '    Send    Home Agent Address Discovery Reply: HA0 -> NUT0 list(ha0)',
	haadreply_ha0ga_nutxga_list_ha0                       => '    Send    Home Agent Address Discovery Reply: HA0 -> NUTX list(ha0)',
	haadreply_ha0ga_nutxga_list_ha0ha1                    => '    Send    Home Agent Address Discovery Reply: HA0 -> NUTX list(ha0,ha1)',
	haadreply_ha0ga_nutxga_list_ha1ha0                    => '    Send    Home Agent Address Discovery Reply: HA0 -> NUTX list(ha1,ha0)',
	haadreply_ha0ga_nutxga_list_ha1                       => '    Send    Home Agent Address Discovery Reply: HA0 -> NUTX list(ha1)',
	haadreply_ha0ga_nutyga_list_ha0                       => '    Send    Home Agent Address Discovery Reply: HA0 -> NUTY list(ha0)',

	haadreply_ha2ga_nutxga_list_ha0ha1ha2                 => '    Send    Home Agent Address Discovery Reply: HA2 -> NUTX list(ha0,ha1,ha2)',

	mps_nutxga_ha0ga_hoa_nuthga                           => '    Receive Mobile Prefix Solicitation: NUTX -> HA0 dst-hoa NUT0',
	mps_nutyga_ha0ga_hoa_nuthga                           => '    Receive Mobile Prefix Solicitation: NUTY -> HA0 dst-hoa NUT0',
	mps_nutxga_ha1ga_hoa_nuthga                           => '    Receive Mobile Prefix Solicitation: NUTX -> HA1 dst-hoa NUT0',

	mpa_ha0ga_nutxga_pfx_ha0                              => '    Send    Mobile Prefix Advertisement: HA0 -> NUTX prefix(ha0)',
	mpa_ha0ga_nutxga_rh2_nuthga_pfx_ha0                   => '    Send    Mobile Prefix Advertisement: HA0 -> NUTX rh-type2 NUT0 prefix(ha0)',
	mpa_ha0ga_nutxga_rh2_nuthga_pfx_ha0_opt_unk           => '    Send    Mobile Prefix Advertisement: HA0 -> NUTX rh-type2 NUT0 prefix(ha0) add unknown option',
	mpa_ha0ga_nutyga_rh2_nuthga_pfx_ha0                   => '    Send    Mobile Prefix Advertisement: HA0 -> NUTY rh-type2 NUT0 prefix(ha0)',
	mpa_ha1ga_nutxga_rh2_nuthga_pfx_ha1                   => '    Send    Mobile Prefix Advertisement: HA1 -> NUTX rh-type2 NUT0 prefix(ha1)',
);

%IKEsaddesc = (
	'p_isakmp_ha0_0' => 'MN<=>HA0 ISAKMP SA',
	'p_isakmp_ha0_x' => 'MN<=>HA0 ISAKMP SA',
	'p_isakmp_ha0_y' => 'MN<=>HA0 ISAKMP SA',

	'p_sa12_ha0_0'   => 'MN<=>HA0 IPsec SA1/SA2',
	'p_sa12_ha0_x'   => 'MN<=>HA0 IPsec SA1/SA2',
	'p_sa12_ha0_y'   => 'MN<=>HA0 IPsec SA1/SA2',

	'p_sa34_ha0_0'   => 'MN<=>HA0 IPsec SA3/SA4',
	'p_sa34_ha0_x'   => 'MN<=>HA0 IPsec SA3/SA4',
	'p_sa34_ha0_y'   => 'MN<=>HA0 IPsec SA3/SA4',

	'p_sa56_ha0_0'   => 'MN<=>HA0 IPsec SA5/SA6',
	'p_sa56_ha0_x'   => 'MN<=>HA0 IPsec SA5/SA6',
	'p_sa56_ha0_y'   => 'MN<=>HA0 IPsec SA5/SA6',

	'p_sa78_ha0_0'   => 'MN<=>HA0 IPsec SA7/SA8',
	'p_sa78_ha0_x'   => 'MN<=>HA0 IPsec SA7/SA8',
	'p_sa78_ha0_y'   => 'MN<=>HA0 IPsec SA7/SA8',

	'p_isakmp_ha1_0' => 'MN<=>HA1 ISAKMP SA',
	'p_isakmp_ha1_x' => 'MN<=>HA1 ISAKMP SA',
	'p_isakmp_ha1_y' => 'MN<=>HA1 ISAKMP SA',

	'p_sa12_ha1_0'   => 'MN<=>HA1 IPsec SA1/SA2',
	'p_sa12_ha1_x'   => 'MN<=>HA1 IPsec SA1/SA2',
	'p_sa12_ha1_y'   => 'MN<=>HA1 IPsec SA1/SA2',

	'p_sa34_ha1_0'   => 'MN<=>HA1 IPsec SA3/SA4',
	'p_sa34_ha1_x'   => 'MN<=>HA1 IPsec SA3/SA4',
	'p_sa34_ha1_y'   => 'MN<=>HA1 IPsec SA3/SA4',

	'p_sa56_ha1_0'   => 'MN<=>HA1 IPsec SA5/SA6',
	'p_sa56_ha1_x'   => 'MN<=>HA1 IPsec SA5/SA6',
	'p_sa56_ha1_y'   => 'MN<=>HA1 IPsec SA5/SA6',

	'p_sa78_ha1_0'   => 'MN<=>HA1 IPsec SA7/SA8',
	'p_sa78_ha1_x'   => 'MN<=>HA1 IPsec SA7/SA8',
	'p_sa78_ha1_y'   => 'MN<=>HA1 IPsec SA7/SA8',
);

# End of File
1;
