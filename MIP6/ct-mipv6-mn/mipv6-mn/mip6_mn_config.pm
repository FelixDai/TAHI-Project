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
package mip6_mn_config;

# EXPORT PACKAGE
use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	%MN_CONF
	$DHAAD_RETRIES
	$INITIAL_BINDACK_TIMEOUT
	$INITIAL_DHAAD_TIMEOUT
	$INITIAL_SOLICIT_TIMER
	$MAX_BINDACK_TIMEOUT
	$MAX_NONCE_LIFETIME
	$MAX_TOKEN_LIFETIME
	$MAX_RR_BINDING_LIFETIME
	$MAX_UPDATE_RATE
	$PREFIX_ADV_RETRIES
	$PREFIX_ADV_TIMEOUT
	$MaxMobPfxAdvInterval
	$MinDelayBetweenRAs
	$MinMobPfxAdvInterval
	$InitialBindackTimeoutFirstReg
	$PREFIX_LIFETIME
	$VLD_LIFETIME
	$PRE_LIFETIME
	$DAD_TIME
	$ECHO_TIME
	$RR_TIME
	$BU_TIME
	$BU_MARGIN_TIME
	$BU_RETRIES
	$RTN_TIME
	$RETRANS_TIME
	$RETRANS_MARGIN
	$RETRANS_BINDACK_MARGIN
	$FIRST_RA_TIME
	$FUNC_DETAIL_BU_TO_HA_RETRANSMISSION_TIME
	$IF0
	$IF0_Recvtime
	%st_Link0
	%st_LinkX
	%st_LinkY
	%st_LinkZ
	$NOW_Link
	$CN0_Link
	$LINK0_PREFIX
	$LINKX_PREFIX
	$LINKY_PREFIX
	$LINKZ_PREFIX
	%node_hash
	%unspecified
	%loopback
	%all_node_multi
	%all_rt_multi
	%ha0_anysol
	%ha0_anycast
	%ha0_sol
	%ha0_lla
	%ha0_ga
	%ha1_sol
	%ha1_lla
	%ha1_ga
	%node0_sol
	%node0_lla
	%node0_ga
	%r1_sol
	%r1_lla
	%r1_ga
	%r2_lla
	%r2_sol
	%r2_ga
	%ha3_anycast
	%ha3_sol
	%ha3_lla
	%ha3_ga
	%cn00_sol
	%cn00_lla
	%cn00_ga
	%cn0x_sol
	%cn0x_lla
	%cn0x_ga 
	%cn0y_sol
	%cn0y_lla
	%cn0y_ga 
	%cn0_sol
	%cn0_lla
	%cn0_ga
	%cn1_sol
	%cn1_lla
	%cn1_ga
	%nut0_sol
	%nut0_lla
	%nut0_ga
	%nuth_sol
	%nuth_lla
	%nuth_ga
	%nutx_sol
	%nutx_lla
	%nutx_ga
	%nuty_sol
	%nuty_lla
	%nuty_ga
	%nutz_sol
	%nutz_lla
	%nutz_ga
	%nutf_sol
	%nutf_lla
	%nut_sol
	%nut_lla
	%addr_hash
	%addr_hash_Link0
	%addr_hash_LinkX
	%addr_hash_LinkY
	%addr_hash_LinkZ
	set_config
	display_config
	check_option
	set_node_addr
	eth2iid
	eth2last3
	vLogHTML_Info
	vLogHTML_Pass
	vLogHTML_Warn
	vLogHTML_Fail
);

# INPORT PACKAGE
use V6evalTool;


# GLOBAL VARIABLE DEFINITION
# Config Item
%MN_CONF = (
	#--------------------------------------------------------------------------
	# IPv6 Ready Logo
	#--------------------------------------------------------------------------
	'IPV6_READY_LOGO_PHASE2' => 'NO',
	'FINE_GRAIN_SELECTORS'   => 'NO',

	#--------------------------------------------------------------------------
	# function category
	#--------------------------------------------------------------------------
	'TEST_STATE_NORMAL'        => 'YES',
	'TEST_STATE_ABNORMAL'      => 'YES',

	'TEST_FUNC_BASIC'          => 'YES',
	'TEST_FUNC_REAL_HOME_LINK' => 'YES',
	'TEST_FUNC_DHAAD'          => 'YES',
	'TEST_FUNC_MPD'            => 'YES',
	'TEST_FUNC_RR'             => 'YES',
	'TEST_FUNC_RR_AS_CN'       => 'YES',
	'TEST_FUNC_IPSEC'          => 'YES',
	'TEST_FUNC_IKE'            => 'NO',

	#--------------------------------------------------------------------------
	# depend on implementation 
	#--------------------------------------------------------------------------
	'FUNC_DETAIL_HOME_ADDRESS'      => 'HOME_PREFIX_STATIC',
	'FUNC_DETAIL_HOME_STATIC_ID'    => '::3775',

	'FUNC_DETAIL_COA_ADDRESS'       => 'RFC2462',
	'FUNC_DETAIL_COA_STATIC_ID'     => '::3775',

	'FUNC_DETAIL_MN_BU_TO_HA_K'     => 'NO',
	'FUNC_DETAIL_IKE_TIME'          => 30,

	'FUNC_DETAIL_MN_BU_TO_CN_A'     => 'NO',
	'FUNC_DETAIL_MN_BU_TO_CN_REREG' => 'NO',
	'FUNC_DETAIL_MN_BRR'            => 'YES',
	'FUNC_DETAIL_RO_CHOICE'         => 'NO',

	'FUNC_DETAIL_DHAAD_ON_HOMELINK' => 'NO',

	'InitialBindackTimeoutFirstReg' => 1.5,

	#--------------------------------------------------------------------------
	# 
	#--------------------------------------------------------------------------
	'FUNC_DETAIL_BU_TO_HA_ALTCOA'   => 'YES',
	'FUNC_DETAIL_BU_TO_CN_AUTHDATA' => 'YES',

	#--------------------------------------------------------------------------
	# retransmisson
	#--------------------------------------------------------------------------
	'FUNC_DETAIL_BU_TO_HA_RETRANSMISSION'      => 'YES',
	'FUNC_DETAIL_BU_TO_HA_RETRANSMISSION_TIME' => '120',

	'FUNC_DETAIL_BU_TO_HA_128' => 'NO',
	'FUNC_DETAIL_BU_TO_HA_129' => 'NO',
	'FUNC_DETAIL_BU_TO_HA_130' => 'NO',
	'FUNC_DETAIL_BU_TO_HA_131' => 'NO',
	'FUNC_DETAIL_BU_TO_HA_132' => 'NO',
	'FUNC_DETAIL_BU_TO_HA_133' => 'NO',
	'FUNC_DETAIL_BU_TO_HA_134' => 'NO',
	'FUNC_DETAIL_BU_TO_HA_135' => 'YES',
	'FUNC_DETAIL_BU_TO_HA_255' => 'NO',

	'FUNC_DETAIL_HOTI_RETRANSMISSION' => 'YES',
	'FUNC_DETAIL_COTI_RETRANSMISSION' => 'YES',

	'FUNC_DETAIL_MN_BU_TO_CN_RETRANSMISSION' => 'NO',
	'FUNC_DETAIL_MN_BU_TO_CN_128' => 'NO',
	'FUNC_DETAIL_MN_BU_TO_CN_135' => 'YES',
	'FUNC_DETAIL_MN_BU_TO_CN_136' => 'YES',
	'FUNC_DETAIL_MN_BU_TO_CN_137' => 'YES',
	'FUNC_DETAIL_MN_BU_TO_CN_138' => 'YES',

	'FUNC_DETAIL_DHAAD_RETRANSMISSION' => 'YES',
	'FUNC_DETAIL_MPD_RETRANSMISSION'   => 'YES',

	#--------------------------------------------------------------------------
	# IPsec SA Manual
	#--------------------------------------------------------------------------
	'IPSEC_MANUAL_SA1_MN_HA0_PROTO'    => 'MH',
	'IPSEC_MANUAL_SA1_MN_HA0_SPI'      => '0x111',
	'IPSEC_MANUAL_SA1_MN_HA0_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA1_MN_HA0_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY'  => 'V6LC-111--12345678901234',
	'IPSEC_MANUAL_SA1_MN_HA0_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA1_MN_HA0_AH_KEY'   => 'V6LC-111--1234567890',

	'IPSEC_MANUAL_SA2_HA0_MN_PROTO'    => 'MH',
	'IPSEC_MANUAL_SA2_HA0_MN_SPI'      => '0x112',
	'IPSEC_MANUAL_SA2_HA0_MN_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA2_HA0_MN_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY'  => 'V6LC-112--12345678901234',
	'IPSEC_MANUAL_SA2_HA0_MN_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA2_HA0_MN_AH_KEY'   => 'V6LC-112--1234567890',

	'IPSEC_MANUAL_SA3_MN_HA0_PROTO'    => 'MH',
	'IPSEC_MANUAL_SA3_MN_HA0_SPI'      => '0x113',
	'IPSEC_MANUAL_SA3_MN_HA0_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA3_MN_HA0_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY'  => 'V6LC-113--12345678901234',
	'IPSEC_MANUAL_SA3_MN_HA0_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA3_MN_HA0_AH_KEY'   => 'V6LC-113--1234567890',

	'IPSEC_MANUAL_SA4_HA0_MN_PROTO'    => 'MH',
	'IPSEC_MANUAL_SA4_HA0_MN_SPI'      => '0x114',
	'IPSEC_MANUAL_SA4_HA0_MN_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA4_HA0_MN_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY'  => 'V6LC-114--12345678901234',
	'IPSEC_MANUAL_SA4_HA0_MN_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA4_HA0_MN_AH_KEY'   => 'V6LC-114--1234567890',

	'IPSEC_MANUAL_SA5_MN_HA0_PROTO'    => 'ICMP',
	'IPSEC_MANUAL_SA5_MN_HA0_SPI'      => '0x115',
	'IPSEC_MANUAL_SA5_MN_HA0_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA5_MN_HA0_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY'  => 'V6LC-115--12345678901234',
	'IPSEC_MANUAL_SA5_MN_HA0_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA5_MN_HA0_AH_KEY'   => 'V6LC-115--1234567890',

	'IPSEC_MANUAL_SA6_HA0_MN_PROTO'    => 'ICMP',
	'IPSEC_MANUAL_SA6_HA0_MN_SPI'      => '0x116',
	'IPSEC_MANUAL_SA6_HA0_MN_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA6_HA0_MN_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY'  => 'V6LC-116--12345678901234',
	'IPSEC_MANUAL_SA6_HA0_MN_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA6_HA0_MN_AH_KEY'   => 'V6LC-116--1234567890',

	'IPSEC_MANUAL_SA7_MN_HA0_PROTO'    => 'NONE',
	'IPSEC_MANUAL_SA7_MN_HA0_SPI'      => '0x117',
	'IPSEC_MANUAL_SA7_MN_HA0_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA7_MN_HA0_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY'  => 'V6LC-117--12345678901234',
	'IPSEC_MANUAL_SA7_MN_HA0_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA7_MN_HA0_AH_KEY'   => 'V6LC-117--1234567890',

	'IPSEC_MANUAL_SA8_HA0_MN_PROTO'    => 'NONE',
	'IPSEC_MANUAL_SA8_HA0_MN_SPI'      => '0x118',
	'IPSEC_MANUAL_SA8_HA0_MN_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA8_HA0_MN_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY'  => 'V6LC-118--12345678901234',
	'IPSEC_MANUAL_SA8_HA0_MN_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA8_HA0_MN_AH_KEY'   => 'V6LC-118--1234567890',

	'IPSEC_MANUAL_SA1_MN_HA1_PROTO'    => 'MH',
	'IPSEC_MANUAL_SA1_MN_HA1_SPI'      => '0x211',
	'IPSEC_MANUAL_SA1_MN_HA1_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA1_MN_HA1_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY'  => 'V6LC-211--12345678901234',
	'IPSEC_MANUAL_SA1_MN_HA1_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA1_MN_HA1_AH_KEY'   => 'V6LC-211--1234567890',

	'IPSEC_MANUAL_SA2_HA1_MN_PROTO'    => 'MH',
	'IPSEC_MANUAL_SA2_HA1_MN_SPI'      => '0x212',
	'IPSEC_MANUAL_SA2_HA1_MN_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA2_HA1_MN_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY'  => 'V6LC-212--12345678901234',
	'IPSEC_MANUAL_SA2_HA1_MN_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA2_HA1_MN_AH_KEY'   => 'V6LC-212--1234567890',

	'IPSEC_MANUAL_SA3_MN_HA1_PROTO'    => 'MH',
	'IPSEC_MANUAL_SA3_MN_HA1_SPI'      => '0x213',
	'IPSEC_MANUAL_SA3_MN_HA1_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA3_MN_HA1_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY'  => 'V6LC-213--12345678901234',
	'IPSEC_MANUAL_SA3_MN_HA1_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA3_MN_HA1_AH_KEY'   => 'V6LC-213--1234567890',

	'IPSEC_MANUAL_SA4_HA1_MN_PROTO'    => 'MH',
	'IPSEC_MANUAL_SA4_HA1_MN_SPI'      => '0x214',
	'IPSEC_MANUAL_SA4_HA1_MN_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA4_HA1_MN_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY'  => 'V6LC-214--12345678901234',
	'IPSEC_MANUAL_SA4_HA1_MN_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA4_HA1_MN_AH_KEY'   => 'V6LC-214--1234567890',

	'IPSEC_MANUAL_SA5_MN_HA1_PROTO'    => 'ICMP',
	'IPSEC_MANUAL_SA5_MN_HA1_SPI'      => '0x215',
	'IPSEC_MANUAL_SA5_MN_HA1_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA5_MN_HA1_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY'  => 'V6LC-215--12345678901234',
	'IPSEC_MANUAL_SA5_MN_HA1_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA5_MN_HA1_AH_KEY'   => 'V6LC-215--1234567890',

	'IPSEC_MANUAL_SA6_HA1_MN_PROTO'    => 'ICMP',
	'IPSEC_MANUAL_SA6_HA1_MN_SPI'      => '0x216',
	'IPSEC_MANUAL_SA6_HA1_MN_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA6_HA1_MN_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY'  => 'V6LC-216--12345678901234',
	'IPSEC_MANUAL_SA6_HA1_MN_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA6_HA1_MN_AH_KEY'   => 'V6LC-216--1234567890',

	'IPSEC_MANUAL_SA7_MN_HA1_PROTO'    => 'NONE',
	'IPSEC_MANUAL_SA7_MN_HA1_SPI'      => '0x217',
	'IPSEC_MANUAL_SA7_MN_HA1_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA7_MN_HA1_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY'  => 'V6LC-217--12345678901234',
	'IPSEC_MANUAL_SA7_MN_HA1_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA7_MN_HA1_AH_KEY'   => 'V6LC-217--1234567890',

	'IPSEC_MANUAL_SA8_HA1_MN_PROTO'    => 'NONE',
	'IPSEC_MANUAL_SA8_HA1_MN_SPI'      => '0x218',
	'IPSEC_MANUAL_SA8_HA1_MN_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA8_HA1_MN_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY'  => 'V6LC-218--12345678901234',
	'IPSEC_MANUAL_SA8_HA1_MN_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA8_HA1_MN_AH_KEY'   => 'V6LC-218--1234567890',

	'IPSEC_MANUAL_SA5_MN_CN0_PROTO'    => 'NONE',
	'IPSEC_MANUAL_SA5_MN_CN0_SPI'      => '0x415',
	'IPSEC_MANUAL_SA5_MN_CN0_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA5_MN_CN0_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY'  => 'V6LC-415--12345678901234',
	'IPSEC_MANUAL_SA5_MN_CN0_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA5_MN_CN0_AH_KEY'   => 'V6LC-415--1234567890',

	'IPSEC_MANUAL_SA6_CN0_MN_PROTO'    => 'NONE',
	'IPSEC_MANUAL_SA6_CN0_MN_SPI'      => '0x416',
	'IPSEC_MANUAL_SA6_CN0_MN_ALGO'     => 'ESP',
	'IPSEC_MANUAL_SA6_CN0_MN_ESP'      => 'DES3CBC',
	'IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY'  => 'V6LC-416--12345678901234',
	'IPSEC_MANUAL_SA6_CN0_MN_AH'       => 'HMACSHA1',
	'IPSEC_MANUAL_SA6_CN0_MN_AH_KEY'   => 'V6LC-416--1234567890',

	#-------------------------------------------------
	# ISAKMP SA(NUT0<->HA0) ike proposal data
	#-------------------------------------------------
	'ISAKMP_MN_HA0_ENC_ALG'     => 'DES3CBC',
	'ISAKMP_MN_HA0_HASH_ALG'    => 'HMACSHA1',
	'ISAKMP_MN_HA0_GRP_DESC'    => 'GROUP1',
#	'ISAKMP_MN_HA0_LD'          => 0,
	'ISAKMP_MN_HA0_TN_ID_TYPE'  => 'FQDN',
	'ISAKMP_MN_HA0_TN_ID'       => 'V6LC',
	'ISAKMP_MN_HA0_NUT_ID_TYPE' => 'FQDN',
	'ISAKMP_MN_HA0_NUT_ID'      => 'V6LC',
	'ISAKMP_MN_HA0_PSK'         => 'PSkey',

	#-------------------------------------------------
	# IPsec SA1/SA2(NUT0<->HA0) ike proposal data
	#-------------------------------------------------
	'IPSEC_IKE_SA12_MN_HA0_ID_PROTO' => 'MH',
	'IPSEC_IKE_SA12_MN_HA0_ESP_ALG'  => 'DES3CBC',
	'IPSEC_IKE_SA12_MN_HA0_AUTH'     => 'HMACSHA1',
#	'IPSEC_IKE_SA12_MN_HA0_LD'       => 0,

	#-------------------------------------------------
	# IPsec SA3/SA4(NUT0<->HA0) ike proposal data
	#-------------------------------------------------
	'IPSEC_IKE_SA34_MN_HA0_ID_PROTO' => 'MH',
	'IPSEC_IKE_SA34_MN_HA0_ESP_ALG'  => 'DES3CBC',
	'IPSEC_IKE_SA34_MN_HA0_AUTH'     => 'HMACSHA1',
#	'IPSEC_IKE_SA34_MN_HA0_LD'       => 0,

	#-------------------------------------------------
	# IPsec SA5/SA6(NUT0<->HA0) ike proposal data
	#-------------------------------------------------
	'IPSEC_IKE_SA56_MN_HA0_ID_PROTO' => 'ICMP',
	'IPSEC_IKE_SA56_MN_HA0_ESP_ALG'  => 'DES3CBC',
	'IPSEC_IKE_SA56_MN_HA0_AUTH'     => 'HMACSHA1',
#	'IPSEC_IKE_SA56_MN_HA0_LD'       => 0,

	#-------------------------------------------------
	# IPsec SA7/SA8(NUT0<->HA0) ike proposal data
	#-------------------------------------------------
	'IPSEC_IKE_SA78_MN_HA0_ID_PROTO' => 'NONE',
	'IPSEC_IKE_SA78_MN_HA0_ESP_ALG'  => 'DES3CBC',
	'IPSEC_IKE_SA78_MN_HA0_AUTH'     => 'HMACSHA1',
#	'IPSEC_IKE_SA78_MN_HA0_LD'       => 0,

	#-------------------------------------------------
	# ISAKMP SA(NUT0<->HA1) ike proposal data
	#-------------------------------------------------
	'ISAKMP_MN_HA1_ENC_ALG'     => 'DES3CBC',
	'ISAKMP_MN_HA1_HASH_ALG'    => 'HMACSHA1',
	'ISAKMP_MN_HA1_GRP_DESC'    => 'GROUP1',
#	'ISAKMP_MN_HA1_LD'          => 0,
	'ISAKMP_MN_HA1_TN_ID_TYPE'  => 'FQDN',
	'ISAKMP_MN_HA1_TN_ID'       => 'V6LC',
	'ISAKMP_MN_HA1_NUT_ID_TYPE' => 'FQDN',
	'ISAKMP_MN_HA1_NUT_ID'      => 'V6LC',
	'ISAKMP_MN_HA1_PSK'         => 'PSkey',

	#-------------------------------------------------
	# IPsec SA1/SA2(NUT0<->HA1) ike proposal data
	#-------------------------------------------------
	'IPSEC_IKE_SA12_MN_HA1_ID_PROTO' => 'MH',
	'IPSEC_IKE_SA12_MN_HA1_ESP_ALG'  => 'DES3CBC',
	'IPSEC_IKE_SA12_MN_HA1_AUTH'     => 'HMACSHA1',
#	'IPSEC_IKE_SA12_MN_HA1_LD'       => 0,

	#-------------------------------------------------
	# IPsec SA3/SA4(NUT0<->HA1) ike proposal data
	#-------------------------------------------------
	'IPSEC_IKE_SA34_MN_HA1_ID_PROTO' => 'MH',
	'IPSEC_IKE_SA34_MN_HA1_ESP_ALG'  => 'DES3CBC',
	'IPSEC_IKE_SA34_MN_HA1_AUTH'     => 'HMACSHA1',
#	'IPSEC_IKE_SA34_MN_HA1_LD'       => 0,

	#-------------------------------------------------
	# IPsec SA5/SA6(NUT0<->HA1) ike proposal data
	#-------------------------------------------------
	'IPSEC_IKE_SA56_MN_HA1_ID_PROTO' => 'ICMP',
	'IPSEC_IKE_SA56_MN_HA1_ESP_ALG'  => 'DES3CBC',
	'IPSEC_IKE_SA56_MN_HA1_AUTH'     => 'HMACSHA1',
#	'IPSEC_IKE_SA56_MN_HA1_LD'       => 0,

	#-------------------------------------------------
	# IPsec SA7/SA8(NUT0<->HA1) ike proposal data
	#-------------------------------------------------
	'IPSEC_IKE_SA78_MN_HA1_ID_PROTO' => 'NONE',
	'IPSEC_IKE_SA78_MN_HA1_ESP_ALG'  => 'DES3CBC',
	'IPSEC_IKE_SA78_MN_HA1_AUTH'     => 'HMACSHA1',
#	'IPSEC_IKE_SA78_MN_HA1_LD'       => 0,

	#-------------------------------------------------
	# INITIALIZE TESTER
	#-------------------------------------------------
	'ENV_INITIALIZE'    => 'BOOT',
	'ENV_ENABLE_MOBILE' => 'YES',
	'ENV_IPSEC_SET'     => 'YES',
	'ENV_FIRST_RA_NUM'  => 2,

	#-------------------------------------------------
	# OTHER(NOT CHANGE)
	#-------------------------------------------------
#	'ENV_REMOTE'  => 'YES',
	'ENV_HA1_SET' => 'NO',
	'ENV_CN0_SET' => 'NO',

	#-------------------------------------------------
	# OTHER(NOT CHANGE)
	#-------------------------------------------------
	'SET_SAME_MAC_R1R2' => 'NO',
	'SET_RA_RBIT'       => 'NO',

	#-------------------------------------------------
	# CONFIGED TESTER
	#-------------------------------------------------
	'ENV_DEBUG' => 0,

	#-------------------------------------------------
	# debug flag for tester
	#-------------------------------------------------
	'ENV_IKE_WO_IKE' =>  0
);

# Protocol Constants
$DHAAD_RETRIES           =   4; # retransmissions
$INITIAL_BINDACK_TIMEOUT =   1; # second
$INITIAL_DHAAD_TIMEOUT   =   3; # seconds
$INITIAL_SOLICIT_TIMER   =   3; # seconds
$MAX_BINDACK_TIMEOUT     =  32; # seconds
$MAX_NONCE_LIFETIME      = 240; # seconds
$MAX_TOKEN_LIFETIME      = 210; # seconds
$MAX_RR_BINDING_LIFETIME = 420; # seconds
$MAX_UPDATE_RATE         =   3; # times
$PREFIX_ADV_RETRIES      =   3; # retransmissions
$PREFIX_ADV_TIMEOUT      =   3; # seconds

# Protocol Configuration Variables
$MaxMobPfxAdvInterval          = 86400; # Default seconds 
$MinDelayBetweenRAs            =     3; # Default seconds, Min: 0.03 seconds
$MinMobPfxAdvInterval          =   600; # Default seconds
$InitialBindackTimeoutFirstReg =   1.5; # Default seconds

# Limit Time for Judge
$PREFIX_LIFETIME        = 7200;
$VLD_LIFETIME           = 7200;
$PRE_LIFETIME           = 7200;
$DAD_TIME               = 10;
$ECHO_TIME              = 20;
$RR_TIME                = 32;
$BU_TIME                = 32;
$BU_MARGIN_TIME         = 4;
$BU_RETRIES             = 5;
$RTN_TIME               = 20;
$RETRANS_TIME           = 10;
$RETRANS_MARGIN         = 0.8;
$RETRANS_BINDACK_MARGIN = 1;
$FIRST_RA_TIME          = 6;
$FUNC_DETAIL_BU_TO_HA_RETRANSMISSION_TIME = 120;

# LOCAL VARIABLE DEFINITION
# Config Item Check
@IPV6_READY_LOGO_PHASE2 = ('YES', 'NO');
@FINE_GRAIN_SELECTORS   = ('YES', 'NO');

@TEST_STATE_NORMAL      = ('YES', 'NO');
@TEST_STATE_ABNORMAL    = ('YES', 'NO');

@TEST_FUNC_BASIC          = ('YES', 'NO');
@TEST_FUNC_REAL_HOME_LINK = ('YES', 'NO');
@TEST_FUNC_DHAAD          = ('YES', 'NO');
@TEST_FUNC_MPD            = ('YES', 'NO');
@TEST_FUNC_RR             = ('YES', 'NO');
@TEST_FUNC_RR_AS_CN       = ('YES', 'NO');
@TEST_FUNC_IPSEC          = ('YES');
@TEST_FUNC_IPSEC_out      = ('NO');
@TEST_FUNC_IKE            = ('YES', 'NO');

@FUNC_DETAIL_HOME_ADDRESS     = ('HOME_PREFIX_STATIC', 'RFC2462', 'STATIC');
@FUNC_DETAIL_HOME_ADDRESS_out = ('RFC3041');

@FUNC_DETAIL_COA_ADDRESS = ('RFC2462', 'STATIC');

@FUNC_DETAIL_MN_BU_TO_HA_K     = ('YES', 'NO');
@FUNC_DETAIL_MN_BU_TO_CN_A     = ('YES', 'NO');
@FUNC_DETAIL_MN_BU_TO_CN_REREG = ('YES', 'NO');
@FUNC_DETAIL_MN_BRR            = ('YES', 'NO');
@FUNC_DETAIL_RO_CHOICE         = ('YES', 'NO');

@FUNC_DETAIL_DHAAD_ON_HOMELINK = ('YES', 'NO');

@InitialBindackTimeoutFirstReg = ();

@FUNC_DETAIL_BU_TO_HA_ALTCOA       = ('YES');
@FUNC_DETAIL_BU_TO_HA_ALTCOA_out   = ('NO');
@FUNC_DETAIL_BU_TO_CN_AUTHDATA     = ('YES');
@FUNC_DETAIL_BU_TO_CN_AUTHDATA_out = ('NO');

@FUNC_DETAIL_BU_TO_HA_RETRANSMISSION = ('YES', 'NO');
@FUNC_DETAIL_BU_TO_HA_128 = ('YES', 'NO');
@FUNC_DETAIL_BU_TO_HA_129 = ('YES', 'NO');
@FUNC_DETAIL_BU_TO_HA_130 = ('YES', 'NO');
@FUNC_DETAIL_BU_TO_HA_131 = ('YES', 'NO');
@FUNC_DETAIL_BU_TO_HA_132 = ('YES', 'NO');
@FUNC_DETAIL_BU_TO_HA_133 = ('YES', 'NO');
@FUNC_DETAIL_BU_TO_HA_134 = ('YES', 'NO');
@FUNC_DETAIL_BU_TO_HA_135 = ('YES', 'NO');
@FUNC_DETAIL_BU_TO_HA_255 = ('YES', 'NO');

@FUNC_DETAIL_HOTI_RETRANSMISSION = ('YES', 'NO');
@FUNC_DETAIL_COTI_RETRANSMISSION = ('YES', 'NO');

@FUNC_DETAIL_MN_BU_TO_CN_RETRANSMISSION = ('YES', 'NO');
@FUNC_DETAIL_MN_BU_TO_CN_128 = ('YES', 'NO');
@FUNC_DETAIL_MN_BU_TO_CN_135 = ('YES', 'NO');
@FUNC_DETAIL_MN_BU_TO_CN_136 = ('YES', 'NO');
@FUNC_DETAIL_MN_BU_TO_CN_137 = ('YES', 'NO');
@FUNC_DETAIL_MN_BU_TO_CN_138 = ('YES', 'NO');

@FUNC_DETAIL_DHAAD_RETRANSMISSION  = ('YES', 'NO');
@FUNC_DETAIL_MPD_RETRANSMISSION    = ('YES', 'NO');

@IPSEC_MANUAL_SA1_MN_HA0_PROTO     = ('MH', 'BU', 'ALL');
@IPSEC_MANUAL_SA1_MN_HA0_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA2_HA0_MN_PROTO     = ('MH', 'BA', 'ALL');
@IPSEC_MANUAL_SA2_HA0_MN_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA3_MN_HA0_PROTO     = ('MH', 'HOTI', 'ALL');
@IPSEC_MANUAL_SA3_MN_HA0_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA4_HA0_MN_PROTO     = ('MH', 'HOT', 'ALL');
@IPSEC_MANUAL_SA4_HA0_MN_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA5_MN_HA0_PROTO     = ('ICMP', 'MPS', 'SA1');
@IPSEC_MANUAL_SA5_MN_HA0_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA6_HA0_MN_PROTO     = ('ICMP', 'MPA', 'SA2');
@IPSEC_MANUAL_SA6_HA0_MN_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA7_MN_HA0_PROTO     = ('X', 'NONE', 'SA3');
@IPSEC_MANUAL_SA8_HA0_MN_PROTO     = ('X', 'NONE', 'SA4');
@IPSEC_MANUAL_SA1_MN_HA1_PROTO     = ('MH', 'BU', 'ALL');
@IPSEC_MANUAL_SA1_MN_HA1_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA2_HA1_MN_PROTO     = ('MH', 'BA', 'ALL');
@IPSEC_MANUAL_SA2_HA1_MN_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA3_MN_HA1_PROTO     = ('MH', 'HOTI', 'ALL');
@IPSEC_MANUAL_SA3_MN_HA1_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA4_HA1_MN_PROTO     = ('MH', 'HOT', 'ALL');
@IPSEC_MANUAL_SA4_HA1_MN_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA5_MN_HA1_PROTO     = ('ICMP', 'MPS', 'SA1');
@IPSEC_MANUAL_SA5_MN_HA1_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA6_HA1_MN_PROTO     = ('ICMP', 'MPA', 'SA2');
@IPSEC_MANUAL_SA6_HA1_MN_PROTO_out = ('NONE');
@IPSEC_MANUAL_SA7_MN_HA1_PROTO     = ('X', 'NONE', 'SA3');
@IPSEC_MANUAL_SA8_HA1_MN_PROTO     = ('X', 'NONE', 'SA4');
@IPSEC_MANUAL_SA5_MN_CN0_PROTO     = ('ICMP', 'NONE');
@IPSEC_MANUAL_SA6_CN0_MN_PROTO     = ('ICMP', 'NONE');

@ISAKMP_MN_HA0_ENC_ALG        = ('DES3CBC', 'DESCBC');
@ISAKMP_MN_HA0_HASH_ALG       = ('HMACSHA1', 'HMACMD5');
@ISAKMP_MN_HA0_GRP_DESC       = ('GROUP1', 'GROUP2');
@ISAKMP_MN_HA0_TN_ID_TYPE     = ('FQDN', 'USERFQDN');
@ISAKMP_MN_HA0_TN_ID_TYPE_out = ('V6ADDR');

@IPSEC_IKE_SA12_MN_HA0_ID_PROTO     = ('MH', 'ALL');
@IPSEC_IKE_SA12_MN_HA0_ID_PROTO_out = ('NONE');
@IPSEC_IKE_SA12_MN_HA0_ESP_ALG      = ('DES3CBC', 'DESCBC');
@IPSEC_IKE_SA12_MN_HA0_AUTH         = ('HMACSHA1', 'HMACMD5');

@IPSEC_IKE_SA34_MN_HA0_ID_PROTO     = ('MH', 'ALL');
@IPSEC_IKE_SA34_MN_HA0_ID_PROTO_out = ('NONE');
@IPSEC_IKE_SA34_MN_HA0_ESP_ALG      = ('DES3CBC', 'DESCBC');
@IPSEC_IKE_SA34_MN_HA0_AUTH         = ('HMACSHA1', 'HMACMD5');

@IPSEC_IKE_SA56_MN_HA0_ID_PROTO     = ('ICMP', 'SA12');
@IPSEC_IKE_SA56_MN_HA0_ID_PROTO_out = ('NONE');
@IPSEC_IKE_SA56_MN_HA0_ESP_ALG      = ('DES3CBC', 'DESCBC');
@IPSEC_IKE_SA56_MN_HA0_AUTH         = ('HMACSHA1', 'HMACMD5');

@IPSEC_IKE_SA78_MN_HA0_ID_PROTO = ('NONE', 'X', 'SA34');
@IPSEC_IKE_SA78_MN_HA0_ESP_ALG  = ('DES3CBC', 'DESCBC');
@IPSEC_IKE_SA78_MN_HA0_AUTH     = ('HMACSHA1', 'HMACMD5');

@ISAKMP_MN_HA1_ENC_ALG        = ('DES3CBC', 'DESCBC');
@ISAKMP_MN_HA1_HASH_ALG       = ('HMACSHA1', 'HMACMD5');
@ISAKMP_MN_HA1_GRP_DESC       = ('GROUP1', 'GROUP2');
@ISAKMP_MN_HA1_TN_ID_TYPE     = ('FQDN', 'USERFQDN');
@ISAKMP_MN_HA1_TN_ID_TYPE_out = ('V6ADDR');

@IPSEC_IKE_SA12_MN_HA1_ID_PROTO     = ('MH', 'ALL');
@IPSEC_IKE_SA12_MN_HA1_ID_PROTO_out = ('NONE');
@IPSEC_IKE_SA12_MN_HA1_ESP_ALG      = ('DES3CBC', 'DESCBC');
@IPSEC_IKE_SA12_MN_HA1_AUTH         = ('HMACSHA1', 'HMACMD5');

@IPSEC_IKE_SA34_MN_HA1_ID_PROTO     = ('MH', 'ALL');
@IPSEC_IKE_SA34_MN_HA1_ID_PROTO_out = ('NONE');
@IPSEC_IKE_SA34_MN_HA1_ESP_ALG      = ('DES3CBC', 'DESCBC');
@IPSEC_IKE_SA34_MN_HA1_AUTH         = ('HMACSHA1', 'HMACMD5');

@IPSEC_IKE_SA56_MN_HA1_ID_PROTO     = ('ICMP', 'SA12');
@IPSEC_IKE_SA56_MN_HA1_ID_PROTO_out = ('NONE');
@IPSEC_IKE_SA56_MN_HA1_ESP_ALG      = ('DES3CBC', 'DESCBC');
@IPSEC_IKE_SA56_MN_HA1_AUTH         = ('HMACSHA1', 'HMACMD5');

@IPSEC_IKE_SA78_MN_HA1_ID_PROTO = ('NONE', 'X', 'SA34');
@IPSEC_IKE_SA78_MN_HA1_ESP_ALG  = ('DES3CBC', 'DESCBC');
@IPSEC_IKE_SA78_MN_HA1_AUTH     = ('HMACSHA1', 'HMACMD5');

@ENV_INITIALIZE    = ('BOOT', 'RESET', 'RETURN', 'NONE');
@ENV_ENABLE_MOBILE = ('YES', 'NO');
@ENV_IPSEC_SET     = ('YES', 'NO');

#@ENV_REMOTE  = ('YES', 'NO');
@ENV_HA1_SET = ('YES', 'NO');
@ENV_CN0_SET = ('YES', 'NO');

@SET_SAME_MAC_R1R2 = ('YES', 'NO');
@SET_RA_RBIT       = ('YES', 'NO');

@ENV_IKE_WO_IKE     = ('0');
@ENV_IKE_WO_IKE_out = ('1');

# Config Massage 0
%CONFIG_MSG_0 = (
	'TEST_STATE_NORMAL=NO',   'skips test of normal case.',
	'TEST_STATE_ABNORMAL=NO', 'skips test of abnormal case.',

	'TEST_FUNC_BASIC=YES', 'have function of basic function',
	'TEST_FUNC_BASIC=NO',  'not have function of basic function.',

	'TEST_FUNC_REAL_HOME_LINK=YES', 'have function of Real Home Link.',
	'TEST_FUNC_REAL_HOME_LINK=NO',  'not have function of Real Home Link.',

	'TEST_FUNC_DHAAD=YES', 'have function of Dynamic Home Agent Address Discovery.',
	'TEST_FUNC_DHAAD=NO',  'not have function of Dynamic Home Agent Address Discovery.',

	'TEST_FUNC_MPD=YES', 'have function of Mobile Prefix Discovery.',
	'TEST_FUNC_MPD=NO',  'not have function of Mobile Prefix Discovery.',

	'TEST_FUNC_RR=YES', 'have function of Return Routability.',
	'TEST_FUNC_RR=NO',  'not have function of Return Routability.',

	'TEST_FUNC_RR_AS_CN=YES', 'have function of Return Routability as correspondent node.',
	'TEST_FUNC_RR_AS_CN=NO',  'not have function of Return Routability as correspondent node.',

	'TEST_FUNC_IPSEC=YES', 'must used IPsec function.',
	'TEST_FUNC_IPSEC=NO',  'not used IPsec function (debug only).',

	'TEST_FUNC_IKE=YES', 'have function of ike v1 function.',
	'TEST_FUNC_IKE=NO',  'not have function of ike v1 function.',

	'FUNC_DETAIL_HOME_ADDRESS=HOME_PREFIX_STATIC', 'creates home address with static home prefix and mac-id.',
	'FUNC_DETAIL_HOME_ADDRESS=RFC2462',            'creates home address with home prefix and mac-id at home link.',
	'FUNC_DETAIL_HOME_ADDRESS=STATIC',             'creates home address with static home prefix and static-id.',
	'FUNC_DETAIL_HOME_ADDRESS=RFC3041',            'creates home address with RFC3041.',

	'FUNC_DETAIL_COA_ADDRESS=RFC2462', 'creates care-of address with foreign prefix and mac-id.',
	'FUNC_DETAIL_COA_ADDRESS=STATIC',  'creates care-of address with foreign prefix and static-id.',

	'FUNC_DETAIL_MN_BU_TO_HA_K=YES', 'sets (K) bit in BU which is transmitted to HA.',
	'FUNC_DETAIL_MN_BU_TO_HA_K=NO',  'not sets (K) bit in BU which is transmitted to HA.',

	'FUNC_DETAIL_MN_BU_TO_CN_A=YES', 'sets (A) bit in BU which is transmitted to CN.',
	'FUNC_DETAIL_MN_BU_TO_CN_A=NO',  'not sets (A) bit in BU which is transmitted to CN.',

	'FUNC_DETAIL_MN_BU_TO_CN_REREG=YES', 're-registers with CN.',
	'FUNC_DETAIL_MN_BU_TO_CN_REREG=NO',  'not re-registers with CN.',

	'FUNC_DETAIL_MN_BRR=YES', 'accepts BRR.',
	'FUNC_DETAIL_MN_BRR=NO',  'not accepts BRR.',

	'FUNC_DETAIL_RO_CHOICE=YES', 'discriminates whether it optimizes to CN or not.',
	'FUNC_DETAIL_RO_CHOICE=NO',  'not discriminates whether it optimizes to CN or not.',

	'FUNC_DETAIL_DHAAD_ON_HOMELINK=YES', 'transmits HAAD Request on Home Link.',
	'FUNC_DETAIL_DHAAD_ON_HOMELINK=NO',  'not transmits HAAD Request on Home Link.',

	'FUNC_DETAIL_BU_TO_HA_ALTCOA=YES', 'contains Alternate CoA option in BU to HA.',
	'FUNC_DETAIL_BU_TO_HA_ALTCOA=NO',  'not contains Alternate CoA option in BU to HA.',

	'FUNC_DETAIL_BU_TO_CN_AUTHDATA=YES', 'calculates Authorization Data of BU to CN correctly.',
	'FUNC_DETAIL_BU_TO_CN_AUTHDATA=NO',  'not calculates Authorization Data of BU to CN correctly.',

	'FUNC_DETAIL_BU_TO_HA_RETRANSMISSION=YES', 're-transmits BU to HA for valuable BA.',
	'FUNC_DETAIL_BU_TO_HA_RETRANSMISSION=NO',  'not re-transmits BU to HA for valuable BA.',

	'FUNC_DETAIL_BU_TO_HA_128=YES', 're-transmits of BU to HA for BA(status 128)',
	'FUNC_DETAIL_BU_TO_HA_128=NO',  'not re-transmits of BU to HA for BA(status 128)',

	'FUNC_DETAIL_BU_TO_HA_129=YES', 're-transmits of BU to HA for BA(status 129)',
	'FUNC_DETAIL_BU_TO_HA_129=NO',  'not re-transmits of BU to HA for BA(status 129)',

	'FUNC_DETAIL_BU_TO_HA_130=YES', 're-transmits of BU to HA for BA(status 130)',
	'FUNC_DETAIL_BU_TO_HA_130=NO',  'not re-transmits of BU to HA for BA(status 130)',

	'FUNC_DETAIL_BU_TO_HA_131=YES', 're-transmits of BU to HA for BA(status 131)',
	'FUNC_DETAIL_BU_TO_HA_131=NO',  'not re-transmits of BU to HA for BA(status 131)',

	'FUNC_DETAIL_BU_TO_HA_132=YES', 're-transmits of BU to HA for BA(status 132)',
	'FUNC_DETAIL_BU_TO_HA_132=NO',  'not re-transmits of BU to HA for BA(status 132)',

	'FUNC_DETAIL_BU_TO_HA_133=YES', 're-transmits of BU to HA for BA(status 133)',
	'FUNC_DETAIL_BU_TO_HA_133=NO',  'not re-transmits of BU to HA for BA(status 133)',

	'FUNC_DETAIL_BU_TO_HA_134=YES', 're-transmits of BU to HA for BA(status 134)',
	'FUNC_DETAIL_BU_TO_HA_134=NO',  'not re-transmits of BU to HA for BA(status 134)',

	'FUNC_DETAIL_BU_TO_HA_135=YES', 're-transmits of BU to HA for BA(status 135)',
	'FUNC_DETAIL_BU_TO_HA_135=NO',  'not re-transmits of BU to HA for BA(status 135)',

	'FUNC_DETAIL_BU_TO_HA_255=YES', 're-transmits of BU to HA for BA(status 255)',
	'FUNC_DETAIL_BU_TO_HA_255=NO',  'not re-transmits of BU to HA for BA(status 255)',

	'FUNC_DETAIL_HOTI_RETRANSMISSION=YES', 're-transmits HoTI for valuable HoT',
	'FUNC_DETAIL_HOTI_RETRANSMISSION=NO',  'not re-transmits HoTI for valuable HoT',

	'FUNC_DETAIL_COTI_RETRANSMISSION=YES', 're-transmits CoTI for valuable CoT',
	'FUNC_DETAIL_COTI_RETRANSMISSION=NO',  'not re-transmits CoTI for valuable CoT',

	'FUNC_DETAIL_MN_BU_TO_CN_RETRANSMISSION=YES', 're-transmits BU to CN for valuable BA',
	'FUNC_DETAIL_MN_BU_TO_CN_RETRANSMISSION=NO',  'not re-transmits BU to CN for valuable BA',

	'FUNC_DETAIL_MN_BU_TO_CN_128=YES', 're-transmits of BU to CN for BA(status 128)',
	'FUNC_DETAIL_MN_BU_TO_CN_128=NO',  'not re-transmits of BU to CN for BA(status 128)',

	'FUNC_DETAIL_MN_BU_TO_CN_135=YES', 're-transmits of BU to CN for BA(status 135)',
	'FUNC_DETAIL_MN_BU_TO_CN_135=NO',  'not re-transmits of BU to CN for BA(status 135)',

	'FUNC_DETAIL_MN_BU_TO_CN_136=YES', 're-transmits of BU to CN for BA(status 136)',
	'FUNC_DETAIL_MN_BU_TO_CN_136=NO',  'not re-transmits of BU to CN for BA(status 136)',

	'FUNC_DETAIL_MN_BU_TO_CN_137=YES', 're-transmits of BU to CN for BA(status 137)',
	'FUNC_DETAIL_MN_BU_TO_CN_137=NO',  'not re-transmits of BU to CN for BA(status 137)',

	'FUNC_DETAIL_MN_BU_TO_CN_138=YES', 're-transmits of BU to CN for BA(status 138)',
	'FUNC_DETAIL_MN_BU_TO_CN_138=NO',  'not re-transmits of BU to CN for BA(status 138)',

	'FUNC_DETAIL_DHAAD_RETRANSMISSION=YES', 're-transmits HAAD Request for valuable HAAD Reply',
	'FUNC_DETAIL_DHAAD_RETRANSMISSION=NO',  'not re-transmits HAAD Request for valuable HAAD Reply',

	'FUNC_DETAIL_MPD_RETRANSMISSION=YES', 're-transmits MPS for valuable MPA',
	'FUNC_DETAIL_MPD_RETRANSMISSION=NO',  'not re-transmits MPS for valuable MPA',

	'ENV_INITIALIZE=BOOT',   'do initialize by reboot.',
	'ENV_INITIALIZE=RESET',  'do initialize by reset.',
	'ENV_INITIALIZE=RETURN', 'do initialize by returning home.',
	'ENV_INITIALIZE=NONE',   'do not initialize.',

	'ENV_ENABLE_MOBILE=YES', 'enable mobile function.',
	'ENV_ENABLE_MOBILE=NO',  'do not anything.',

	'ENV_IPSEC_SET=YES', 'set IPsec.',
	'ENV_IPSEC_SET=NO',  'do not anything.',

	'IPSEC_MANUAL_SA1_MN_HA0_PROTO=NONE', 'not supports IPsec between MN and HA0 SA1',
	'IPSEC_MANUAL_SA2_HA0_MN_PROTO=NONE', 'not supports IPsec between MN and HA0 SA2',
	'IPSEC_MANUAL_SA5_MN_CN0_PROTO=NONE', 'not supports IPsec between MN and CN0 SA5',
	'IPSEC_MANUAL_SA6_CN0_MN_PROTO=NONE', 'not supports IPsec between MN and CN0 SA6',
);

# GLOBAL VARIABLE DEFINITION
$IF0          = Link0;
$IF0_Recvtime = $MinDelayBetweenRAs;

%st_Link0 = ();
%st_LinkX = ();
%st_LinkY = ();
%st_LinkZ = ();

$NOW_Link = 'NONE';
$CN0_Link = 'LinkZ';

$LL_PREFIX    = 'fe80::';
$SOL_PREFIX   = 'ff02::1:ff';
$LINK0_PREFIX = '3ffe:501:ffff:100';
$LINKX_PREFIX = '3ffe:501:ffff:102';
$LINKY_PREFIX = '3ffe:501:ffff:103';
$LINKZ_PREFIX = '3ffe:501:ffff:104';

$HA0_ANYSOL    = 'ff02::1:ffff:fffe';
$HA0_ANYCAST   = '3ffe:501:ffff:100:fdff:ffff:ffff:fffe';

$HA0_MAC       = '00:00:00:00:a0:a0';
$HA0_MAC_SOL   = '33:33:ff:00:a0:a0';
$HA0_IP_SOL    = 'ff02::1:ff00:a0a0';
$HA0_IP_LLA    = 'fe80::200:ff:fe00:a0a0';
$HA0_IP_GA     = '3ffe:501:ffff:100:200:ff:fe00:a0a0';

$HA1_MAC       = '00:00:00:00:a1:a1';
$HA1_MAC_SOL   = '33:33:ff:00:a1:a1';
$HA1_IP_SOL    = 'ff02::1:ff00:a1a1';
$HA1_IP_LLA    = 'fe80::200:ff:fe00:a1a1';
$HA1_IP_GA     = '3ffe:501:ffff:100:200:ff:fe00:a1a1';

$HA2_MAC       = '00:00:00:00:a2:a2';
$HA2_MAC_SOL   = '33:33:ff:00:a2:a2';
$HA2_IP_SOL    = 'ff02::1:ff00:a2a2';
$HA2_IP_LLA    = 'fe80::200:ff:fe00:a2a2';
$HA2_IP_GA     = '3ffe:501:ffff:100:200:ff:fe00:a2a2';

$NODE0_MAC     = '00:00:00:00:a3:a3';
$NODE0_MAC_SOL = '33:33:ff:00:a3:a3';
$NODE0_IP_SOL  = 'ff02::1:ff00:a3a3';
$NODE0_IP_LLA  = 'fe80::200:ff:fe00:a3a3';
$NODE0_IP_GA   = '3ffe:501:ffff:100:200:ff:fe00:a3a3';

$R1_MAC        = '00:00:00:00:a4:a4';
$R1_MAC_SOL    = '33:33:ff:00:a4:a4';
$R1_IP_SOL     = 'ff02::1:ff00:a4a4';
$R1_IP_LLA     = 'fe80::200:ff:fe00:a4a4';
$R1_IP_GA      = '3ffe:501:ffff:102:200:ff:fe00:a4a4';

$NODE1_MAC     = '00:00:00:00:a5:a5';
$NODE1_MAC_SOL = '33:33:ff:00:a5:a5';
$NODE1_IP_SOL  = 'ff02::1:ff00:a5a5';
$NODE1_IP_LLA  = 'fe80::200:ff:fe00:a5a5';
$NODE1_IP_GA   = '3ffe:501:ffff:102:200:ff:fe00:a5a5';

$R2_MAC        = '00:00:00:00:a6:a6';
$R2_MAC_SOL    = '33:33:ff:00:a6:a6';
$R2_IP_SOL     = 'ff02::1:ff00:a6a6';
$R2_IP_LLA     = 'fe80::200:ff:fe00:a6a6';
$R2_IP_GA      = '3ffe:501:ffff:103:200:ff:fe00:a6a6';

$NODE2_MAC     = '00:00:00:00:a7:a7';
$NODE2_MAC_SOL = '33:33:ff:00:a7:a7';
$NODE2_IP_SOL  = 'ff02::1:ff00:a7a7';
$NODE2_IP_LLA  = 'fe80::200:ff:fe00:a7a7';
$NODE2_IP_GA   = '3ffe:501:ffff:103:200:ff:fe00:a7a7';

$HA3_ANYCAST   = '3ffe:501:ffff:104:fdff:ffff:ffff:fffe';

$HA3_MAC       = '00:00:00:00:aa:aa';
$HA3_MAC_SOL   = '33:33:ff:00:aa:aa';
$HA3_IP_SOL    = 'ff02::1:ff00:aaaa';
$HA3_IP_LLA    = 'fe80::200:ff:fe00:aaaa';
$HA3_IP_GA     = '3ffe:501:ffff:104:200:ff:fe00:aaaa';

$CN0_MAC          = '00:00:00:00:a8:a8';
$CN0_MAC_SOL      = '33:33:ff:00:a8:a8';
$CN0_IP_SOL       = 'ff02::1:ff00:a8a8';
$CN0_IP_LLA       = 'fe80::200:ff:fe00:a8a8';
$CN0_IP_LINK0_GA  = '3ffe:501:ffff:100:200:ff:fe00:a8a8';
$CN0_IP_LINKX_GA  = '3ffe:501:ffff:102:200:ff:fe00:a8a8';
$CN0_IP_LINKY_GA  = '3ffe:501:ffff:103:200:ff:fe00:a8a8';
$CN0_IP_LINKZ_GA  = '3ffe:501:ffff:104:200:ff:fe00:a8a8';

$CN1_MAC          = '00:00:00:00:a9:a9';
$CN1_MAC_SOL      = '33:33:ff:00:a9:a9';
$CN1_IP_SOL       = 'ff02::1:ff00:a9a9';
$CN1_IP_LLA       = 'fe80::200:ff:fe00:a9a9';
$CN1_IP_GA        = '3ffe:501:ffff:104:200:ff:fe00:a9a9';

$NUT0_MAC         = '01:02:03:04:05:06';
$NUT0L_MAC_SOL    = '33:33:ff:04:05:06';
$NUT0_MAC_SOL     = '33:33:ff:04:05:06';

$NUTX_MAC         = '01:02:03:04:05:06';
$NUTX_MAC_SOL     = '33:33:ff:04:05:06';

$NUT0_IP_LINK0L_SOL = 'ff02::1:ff00:0000';
$NUT0_IP_LINK0_SOL  = 'ff02::1:ff00:0000';
$NUT0_IP_LINK0_LLA  = 'fe80::200:ff:fe00:0000';
$NUT0_IP_LINK0_GA   = '3ffe:501:ffff:100:200:ff:fe00:0000';

$NUT0_IP_HOA_SOL    = 'ff02::1:ff00:0000';
$NUT0_IP_HOA_LLA    = 'fe80::200:ff:fe00:0000';
$NUT0_IP_HOA_GA     = '3ffe:501:ffff:100:200:ff:fe00:0000';

$NUT0_IP_LINKX_SOL  = 'ff02::1:ff00:0000';
$NUT0_IP_LINKX_LLA  = 'fe80::200:ff:fe00:0000';
$NUT0_IP_LINKX_GA   = '3ffe:501:ffff:102:200:ff:fe00:0000';

$NUT0_IP_LINKY_SOL  = 'ff02::1:ff00:0000';
$NUT0_IP_LINKY_LLA  = 'fe80::200:ff:fe00:0000';
$NUT0_IP_LINKY_GA   = '3ffe:501:ffff:103:200:ff:fe00:0000';

$NUT0_IP_LINKZ_SOL  = 'ff02::1:ff00:0000';
$NUT0_IP_LINKZ_LLA  = 'fe80::200:ff:fe00:0000';
$NUT0_IP_LINKZ_GA   = '3ffe:501:ffff:104:200:ff:fe00:0000';

# Node -> Address ##################
%node_hash = ();

# Node data ########################
# Common
%unspecified    = ();
%loopback       = ();
%all_node_multi = ();
%all_rt_multi   = ();

# HA anycast
%ha0_anysol  = ();
%ha0_anycast = ();

# HA0
%ha0_sol     = ();
%ha0_lla     = ();
%ha0_ga      = ();

# HA1
%ha1_sol     = ();
%ha1_lla     = ();
%ha1_ga      = ();

# NODE0
%node0_sol   = ();
%node0_lla   = ();
%node0_ga    = ();

# R1
%r1_sol      = ();
%r1_lla      = ();
%r1_ga       = ();

# R2
%r2_sol      = ();
%r2_lla      = ();
%r2_ga       = ();

# HA3 anycast
%ha3_anycast = ();

# HA3
%ha3_sol     = ();
%ha3_lla     = ();
%ha3_ga      = ();

# CN00
%cn00_sol    = ();
%cn00_lla    = ();
%cn00_ga     = ();

# CN0X
%cn0x_sol    = ();
%cn0x_lla    = ();
%cn0x_ga     = ();

# CN0Y
%cn0y_sol    = ();
%cn0y_lla    = ();
%cn0y_ga     = ();

# CN0
%cn0_sol     = ();
%cn0_lla     = ();
%cn0_ga      = ();

# CN1
%cn1_sol     = ();
%cn1_lla     = ();
%cn1_ga      = ();

# NUT0
%nut0l_sol   = ();
%nut0_sol    = ();
%nut0_lla    = ();
%nut0_ga     = ();

# HOME
%nuth_sol    = ();
%nuth_lla    = ();
%nuth_ga     = ();

# NUTX
%nutx_sol    = ();
%nutx_lla    = ();
%nutx_ga     = ();

# NUTY
%nuty_sol    = ();
%nuty_lla    = ();
%nuty_ga     = ();

# NUTZ
%nutz_sol    = ();
%nutz_lla    = ();
%nutz_ga     = ();

# NUT foreign
%nutf_sol    = ();
%nutf_lla    = ();

# NUT all
%nut_sol     = ();
%nut_lla     = ();

# address -> Node ##################
%addr_hash       = ();
%addr_hash_Link0 = ();
%addr_hash_LinkX = ();
%addr_hash_LinkY = ();
%addr_hash_LinkZ = ();

# SUBROUTINE DECLARATION
sub set_config($);
#sub set_remote();
sub display_config();
sub check_option(@);

sub set_node_addr();
sub nut_addr();
sub cn_addr();
sub r2_addr();
sub decomp_mac($$);
sub eth2iid(@);
sub eth2last3(@);
sub decomp_mac_2($$);
sub eth2iid_2(@);
sub eth2last3_2(@);

sub vLogHTML_Info($);
sub vLogHTML_Pass($);
sub vLogHTML_Warn($);
sub vLogHTML_Fail($);


# SUBROUTINE
#-----------------------------------------------------------------------------#
# set_config($)
#   read "config.txt" and fix %MN_CONF.
#-----------------------------------------------------------------------------#
sub set_config($) {
	my($opt_logo) = @_;

	# set config parameter
	open(CONFIG_TXT, "config.txt");
	while (<CONFIG_TXT>) {
		chomp;

		my $line = $_;

		if ($line =~ /^\s*(\S+)\s+(\S+)/) {
			if (defined($MN_CONF{$1})) {
				$MN_CONF{$1} = $2;
			}
		}
	}
	close(CONFIG_TXT);

	# Fix Configure
	if ($opt_logo eq '1') {
		$MN_CONF{'IPV6_READY_LOGO_PHASE2'} = "YES";
		$MN_CONF{'FINE_GRAIN_SELECTORS'} = "NO";
	}
	elsif ($opt_logo eq '2') {
		$MN_CONF{'IPV6_READY_LOGO_PHASE2'} = "YES";
		$MN_CONF{'FINE_GRAIN_SELECTORS'} = "YES";
	}

	# IPsec configuration
	if ($MN_CONF{TEST_FUNC_IPSEC} eq 'YES') {
		# MANUAL MN-HA0
		if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO} = 'SA1';
		}
		if ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO} = 'SA2';
		}
		if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO} = 'SA3';
		}
		if ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO} = 'SA4';
		}

		# MANUAL MN-HA1
		if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO} = 'SA1';
		}
		if ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO} = 'SA2';
		}
		if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO} = 'SA3';
		}
		if ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO} = 'SA4';
		}

		# IKEv1 MN-HA0
		if ($MN_CONF{IPSEC_IKE_SA12_MN_HA0_ID_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_IKE_SA56_MN_HA0_ID_PROTO} = 'SA12';
		}
		if ($MN_CONF{IPSEC_IKE_SA34_MN_HA0_ID_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_IKE_SA78_MN_HA0_ID_PROTO} = 'SA34';
		}

		# IKEv1 MN-HA1
		if ($MN_CONF{IPSEC_IKE_SA12_MN_HA1_ID_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_IKE_SA56_MN_HA1_ID_PROTO} = 'SA12';
		}
		if ($MN_CONF{IPSEC_IKE_SA34_MN_HA1_ID_PROTO} eq 'ALL') {
			$MN_CONF{IPSEC_IKE_SA78_MN_HA1_ID_PROTO} = 'SA34';
		}
	}
	else {
		# IKEv1 disable
		$MN_CONF{TEST_FUNC_IKE} = 'NO';

		# IPsec not used(debug mode)
		$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_PROTO} = 'NONE';
		$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_PROTO} = 'NONE';
	}

	# refer to nut.def
	#set_remote();

	# set variable
	$InitialBindackTimeoutFirstReg            = 0 + $MN_CONF{InitialBindackTimeoutFirstReg};
	$FIRST_RA_TIME                            = 0 + $MinDelayBetweenRAs * ($MN_CONF{ENV_FIRST_RA_NUM} + 1);
	$FUNC_DETAIL_BU_TO_HA_RETRANSMISSION_TIME = 0 + $MN_CONF{FUNC_DETAIL_BU_TO_HA_RETRANSMISSION_TIME};

	# IPv6 Ready Logo check
	if ($MN_CONF{IPV6_READY_LOGO_PHASE2} eq 'YES') {
		$msgs = '';

		# Test Condition
		if ($MN_CONF{'ENV_INITIALIZE'} ne 'BOOT') {
			$msgs .= "  ENV_INITIALIZE must be BOOT\n";
		}
		if ($MN_CONF{'TEST_STATE_NORMAL'} ne 'YES') {
			$msgs .= "  TEST_STATE_NORMAL must be YES\n";
		}
		if ($MN_CONF{'TEST_STATE_ABNORMAL'} ne 'YES') {
			$msgs .= "  TEST_STATE_ABNORMAL must be YES\n";
		}
		if ($MN_CONF{'TEST_FUNC_BASIC'} ne 'YES') {
			$msgs .= "  TEST_FUNC_BASIC must be YES\n";
		}
		if ($MN_CONF{'TEST_FUNC_IPSEC'} ne 'YES') {
			$msgs .= "  TEST_FUNC_IPSEC must be YES\n";
		}
		if ($MN_CONF{'TEST_FUNC_IKE'} ne 'NO') {
			$msgs .= "  TEST_FUNC_IKE must be NO\n";
		}

		if ($MN_CONF{'FUNC_DETAIL_BU_TO_HA_ALTCOA'} ne 'YES') {
			$msgs .= "  FUNC_DETAIL_BU_TO_HA_ALTCOA must be YES\n";
		}
		if ($MN_CONF{'FUNC_DETAIL_BU_TO_CN_AUTHDATA'} ne 'YES') {
			$msgs .= "  FUNC_DETAIL_BU_TO_CN_AUTHDATA must be YES\n";
		}

		if ($MN_CONF{'FINE_GRAIN_SELECTORS'} ne 'YES') {
			# BASIC
			if ($MN_CONF{'IPSEC_MANUAL_SA1_MN_HA0_PROTO'} ne 'MH') {
				$msgs .= "  IPSEC_MANUAL_SA1_MN_HA0_PROTO must be MH\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA2_HA0_MN_PROTO'} ne 'MH') {
				$msgs .= "  IPSEC_MANUAL_SA2_HA0_MN_PROTO must be MH\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA1_MN_HA1_PROTO'} ne 'MH') {
				$msgs .= "  IPSEC_MANUAL_SA1_MN_HA1_PROTO must be MH\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA2_HA1_MN_PROTO'} ne 'MH') {
				$msgs .= "  IPSEC_MANUAL_SA2_HA1_MN_PROTO must be MH\n";
			}
		}
		else {
			# Advance Funciotn "IPsec v3"
			if ($MN_CONF{'IPSEC_MANUAL_SA1_MN_HA0_PROTO'} ne 'BU') {
				$msgs .= "  IPSEC_MANUAL_SA1_MN_HA0_PROTO must be BU\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA2_HA0_MN_PROTO'} ne 'BA') {
				$msgs .= "  IPSEC_MANUAL_SA2_HA0_MN_PROTO must be BA\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA1_MN_HA1_PROTO'} ne 'BU') {
				$msgs .= "  IPSEC_MANUAL_SA1_MN_HA1_PROTO must be BU\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA2_HA1_MN_PROTO'} ne 'BA') {
				$msgs .= "  IPSEC_MANUAL_SA2_HA1_MN_PROTO must be BA\n";
			}
		}

		if ($MN_CONF{'IPSEC_MANUAL_SA7_MN_HA0_PROTO'} ne 'NONE') {
			$msgs .= "  IPSEC_MANUAL_SA7_MN_HA0_PROTO must be NONE\n";
		}
		if ($MN_CONF{'IPSEC_MANUAL_SA8_HA0_MN_PROTO'} ne 'NONE') {
			$msgs .= "  IPSEC_MANUAL_SA8_HA0_MN_PROTO must be NONE\n";
		}
		if ($MN_CONF{'IPSEC_MANUAL_SA7_MN_HA1_PROTO'} ne 'NONE') {
			$msgs .= "  IPSEC_MANUAL_SA7_MN_HA1_PROTO must be NONE\n";
		}
		if ($MN_CONF{'IPSEC_MANUAL_SA8_HA1_MN_PROTO'} ne 'NONE') {
			$msgs .= "  IPSEC_MANUAL_SA8_HA1_MN_PROTO must be NONE\n";
		}

		if ($MN_CONF{'IPSEC_MANUAL_SA5_MN_CN0_PROTO'} ne 'NONE') {
			$msgs .= "  IPSEC_MANUAL_SA5_MN_CN0_PROTO must be NONE\n";
		}
		if ($MN_CONF{'IPSEC_MANUAL_SA6_CN0_MN_PROTO'} ne 'NONE') {
			$msgs .= "  IPSEC_MANUAL_SA6_CN0_MN_PROTO must be NONE\n";
		}

		# Advanced Real Home Link - "TEST_FUNC_REAL_HOME_LINK"

		# Advanced DHAAD - "TEST_FUNC_DHAAD"

		# Advanced MPD - "TEST_FUNC_MPD"
		if ($MN_CONF{'TEST_FUNC_MPD'} eq 'YES') {
			if ($MN_CONF{'FINE_GRAIN_SELECTORS'} ne 'YES') {
				if ($MN_CONF{'IPSEC_MANUAL_SA5_MN_HA0_PROTO'} ne 'ICMP') {
					$msgs .= "  If TEST_FUNC_MPD be YES, IPSEC_MANUAL_SA5_MN_HA0_PROTO must be ICMP\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA6_HA0_MN_PROTO'} ne 'ICMP') {
					$msgs .= "  If TEST_FUNC_MPD be YES, IPSEC_MANUAL_SA6_HA0_MN_PROTO must be ICMP\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA5_MN_HA1_PROTO'} ne 'ICMP') {
					$msgs .= "  If TEST_FUNC_MPD be YES, IPSEC_MANUAL_SA5_MN_HA1_PROTO must be ICMP\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA6_HA1_MN_PROTO'} ne 'ICMP') {
					$msgs .= "  If TEST_FUNC_MPD be YES, IPSEC_MANUAL_SA6_HA1_MN_PROTO must be ICMP\n";
				}
			}
			else {
				if ($MN_CONF{'IPSEC_MANUAL_SA5_MN_HA0_PROTO'} ne 'MPS') {
					$msgs .= "  If TEST_FUNC_MPD be YES, IPSEC_MANUAL_SA5_MN_HA0_PROTO must be MPS\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA6_HA0_MN_PROTO'} ne 'MPA') {
					$msgs .= "  If TEST_FUNC_MPD be YES, IPSEC_MANUAL_SA6_HA0_MN_PROTO must be MPA\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA5_MN_HA1_PROTO'} ne 'MPS') {
					$msgs .= "  If TEST_FUNC_MPD be YES, IPSEC_MANUAL_SA5_MN_HA1_PROTO must be MPS\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA6_HA1_MN_PROTO'} ne 'MPA') {
					$msgs .= "  If TEST_FUNC_MPD be YES, IPSEC_MANUAL_SA6_HA1_MN_PROTO must be MPA\n";
				}
			}
		}
		else {
			if ($MN_CONF{'IPSEC_MANUAL_SA5_MN_HA0_PROTO'} ne 'NONE') {
				$msgs .= "  If TEST_FUNC_MPD be NO, IPSEC_MANUAL_SA5_MN_HA0_PROTO must be NONE\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA6_HA0_MN_PROTO'} ne 'NONE') {
				$msgs .= "  If TEST_FUNC_MPD be NO, IPSEC_MANUAL_SA6_HA0_MN_PROTO must be NONE\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA5_MN_HA1_PROTO'} ne 'NONE') {
				$msgs .= "  If TEST_FUNC_MPD be NO, IPSEC_MANUAL_SA5_MN_HA1_PROTO must be NONE\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA6_HA1_MN_PROTO'} ne 'NONE') {
				$msgs .= "  If TEST_FUNC_MPD be NO, IPSEC_MANUAL_SA6_HA1_MN_PROTO must be NONE\n";
			}
		}

		# Advanced Return Routability - "TEST_FUNC_RR"
		if ($MN_CONF{'TEST_FUNC_RR'} eq 'YES') {
			if ($MN_CONF{'FINE_GRAIN_SELECTORS'} ne 'YES') {
				if ($MN_CONF{'IPSEC_MANUAL_SA3_MN_HA0_PROTO'} ne 'MH') {
					$msgs .= "  If TEST_FUNC_RR be YES, IPSEC_MANUAL_SA3_MN_HA0_PROTO must be MH\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA4_HA0_MN_PROTO'} ne 'MH') {
					$msgs .= "  If TEST_FUNC_RR be YES, IPSEC_MANUAL_SA4_HA0_MN_PROTO must be MH\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA3_MN_HA1_PROTO'} ne 'MH') {
					$msgs .= "  If TEST_FUNC_RR be YES, IPSEC_MANUAL_SA3_MN_HA1_PROTO must be MH\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA4_HA1_MN_PROTO'} ne 'MH') {
					$msgs .= "  If TEST_FUNC_RR be YES, IPSEC_MANUAL_SA4_HA1_MN_PROTO must be MH\n";
				}
			}
			else {
				if ($MN_CONF{'IPSEC_MANUAL_SA3_MN_HA0_PROTO'} ne 'HOTI') {
					$msgs .= "  If TEST_FUNC_RR be YES, IPSEC_MANUAL_SA3_MN_HA0_PROTO must be HOTI\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA4_HA0_MN_PROTO'} ne 'HOT') {
					$msgs .= "  If TEST_FUNC_RR be YES, IPSEC_MANUAL_SA4_HA0_MN_PROTO must be HOT\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA3_MN_HA1_PROTO'} ne 'HOTI') {
					$msgs .= "  If TEST_FUNC_RR be YES, IPSEC_MANUAL_SA3_MN_HA1_PROTO must be HOTI\n";
				}
				if ($MN_CONF{'IPSEC_MANUAL_SA4_HA1_MN_PROTO'} ne 'HOT') {
					$msgs .= "  If TEST_FUNC_RR be YES, IPSEC_MANUAL_SA4_HA1_MN_PROTO must be HOT\n";
				}
			}
		}
		else {
			if ($MN_CONF{'IPSEC_MANUAL_SA3_MN_HA0_PROTO'} ne 'NONE') {
				$msgs .= "  If TEST_FUNC_RR be NO, IPSEC_MANUAL_SA3_MN_HA0_PROTO must be NONE\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA4_HA0_MN_PROTO'} ne 'NONE') {
				$msgs .= "  If TEST_FUNC_RR be NO, IPSEC_MANUAL_SA4_HA0_MN_PROTO must be NONE\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA3_MN_HA1_PROTO'} ne 'NONE') {
				$msgs .= "  If TEST_FUNC_RR be NO, IPSEC_MANUAL_SA3_MN_HA1_PROTO must be NONE\n";
			}
			if ($MN_CONF{'IPSEC_MANUAL_SA4_HA1_MN_PROTO'} ne 'NONE') {
				$msgs .= "  If TEST_FUNC_RR be NO, IPSEC_MANUAL_SA4_HA1_MN_PROTO must be NONE\n";
			}
		}

		# Advanced Mobile to Mobile - "TEST_FUNC_RR_AS_CN"
		if ($MN_CONF{'TEST_FUNC_RR_AS_CN'} eq 'YES') {
			if ($MN_CONF{'TEST_FUNC_RR'} ne 'YES') {
				$msgs .= "  If TEST_FUNC_RR_AS_CN be YES, TEST_FUNC_RR must be YES\n";
			}
		}

		# Check result
		if ($msgs ne '') {
			vLogHTML("\ncheck whether the config setting conforms to IPv6 Ready Logo.\n");
			vLogHTML("$msgs");
			exit $V6evalTool::exitFatal;
		}
	}

	return;
}

#-----------------------------------------------------------------------------#
# set_remote()
#-----------------------------------------------------------------------------#
#sub set_remote() {
#
#	if ($V6evalTool::NutDef{System} ne 'manual') {
#		$MN_CONF{ENV_REMOTE} = 'YES';
#	} else {
#		$MN_CONF{ENV_REMOTE} = 'NO';
#	}
#}

#-----------------------------------------------------------------------------#
# display_config()
#   display fixed %MN_CONF.
#-----------------------------------------------------------------------------#
sub display_config() {
	my $name;
	my $flag;
	my $val;
	my $values;

	foreach $name (sort(keys(%MN_CONF))) {
		@values = (@{$name});
		if (@values != 0) {
			$flag = 0;
			foreach $val (@values) {
				if ($MN_CONF{$name} eq $val) {
					vLogHTML("CONFIG PARAMETER: $name = $MN_CONF{$name}<BR>");
					$flag = 1;
					last;
				}
			}
			if ($flag == 1) {
				next;
			}
			@values_out = (@{"$name"."_out"});
			if (@values_out != 0) {
				foreach $val (@values_out) {
					if ($MN_CONF{$name} eq $val) {
						vLogHTML("<B><FONT COLOR=\"#FF0000\">CONFIG PARAMETER: $name = $MN_CONF{$name}</FONT></B><BR>");
						$flag = 1;
						last;
					}
				}
			}
			if ($flag == 0) {
				vLogHTML("<B><FONT COLOR=\"#FF0000\">CONFIG PARAMETER: $name = $MN_CONF{$name} (nonstandard)</FONT></B><BR>");
				exit $V6evalTool::exitInitFail;
			}
		}
		else {
			vLogHTML("CONFIG PARAMETER: $name = $MN_CONF{$name}<BR>");
		}
	}

	return;
}

#-----------------------------------------------------------------------------#
# check_option(@)
#   check %MN_CONF and condition of test sequence.
# <in>  @options: condition of test sequence
#                 = ('<name>', '<arg>', <kind>, repeat...)
#-----------------------------------------------------------------------------#
sub check_option(@) {
	my (@options0) = @_;
	my $name0;
	my $arg0;
	my $name;
	my $arg;
	my $kind;
	my @options;

	vLogHTML("After the following options are checked, this test is executed.<BR>");

	$flag = 0;
	while (($name0, $arg0) = each(%MN_CONF)) {
		$flag_0 = 0;
		$flag_1 = 0;
		@options = @options0;
		while (1) {
			($name, $arg, $kind, @options) = @options;
			if ($name eq undef) {
				last;
			}
			if ($name0 eq $name) {
				$flag_0 = 1;
				if ($arg0 eq $arg) {
					if ($kind == 0) {
						$flag_1 = 1;
					}
					else {
						$flag_1 = 0;
					}
					last;
				}
				else {
					if ($kind == 0) {
						$flag_1 = 0;
					}
					else {
						$flag_1 = 1;
					}
				}
			}
		}
		if ($flag_0 == 1) {
			if ($flag_1 == 1) {
				vLogHTML("match $name0 = $arg0.<BR>");
			}
			else {
				$aaa = "$name0"."=$arg0";
				vLogHTML("unmatch $name0 = $arg0. $CONFIG_MSG_0{$aaa}<BR>");
				$flag = 1;
			}
		}
	}
	if ($flag == 1) {
		exit $V6evalTool::exitIgnore;
	}
	return;
}

#-----------------------------------------------------------------------------#
# set_node_addr()
# <in> none.
#
# <out> none.
#-----------------------------------------------------------------------------#
sub set_node_addr() {

	nut_addr();
	cn_addr();
	r2_addr();

	%node_hash = (
		# Common
		'unspecified'    => '::',
		'loopback'       => '::1',
		'all_node_multi' => 'ff02::1',
		'all_rt_multi'   => 'ff02::2',

		# HA anycast
		'ha0_anysol'  => $HA0_ANYSOL,
		'ha0_anycast' => $HA0_ANYCAST,

		# HA0
		'ha0_sol'     => $HA0_IP_SOL,
		'ha0_lla'     => $HA0_IP_LLA,
		'ha0_ga'      => $HA0_IP_GA,

		# HA1
		'ha1_sol'     => $HA1_IP_SOL,
		'ha1_lla'     => $HA1_IP_LLA,
		'ha1_ga'      => $HA1_IP_GA,

		# NODE0
		'node0_sol'   => $NODE0_IP_SOL,
		'node0_lla'   => $NODE0_IP_LLA,
		'node0_ga'    => $NODE0_IP_GA,

		# R1
		'r1_sol'      => $R1_IP_SOL,
		'r1_lla'      => $R1_IP_LLA,
		'r1_ga'       => $R1_IP_GA,

		# R2
		'r2_sol'      => $R2_IP_SOL,
		'r2_lla'      => $R2_IP_LLA,
		'r2_ga'       => $R2_IP_GA,

		# HA3 anycast
		'ha3_anycast' => $HA3_ANYCAST,

		# HA3
		'ha3_sol'     => $HA3_IP_SOL,
		'ha3_lla'     => $HA3_IP_LLA,
		'ha3_ga'      => $HA3_IP_GA,

		# CN00
		'cn00_sol'    => $CN0_IP_SOL,
		'cn00_lla'    => $CN0_IP_LLA,
		'cn00_ga'     => $CN0_IP_LINK0_GA,

		# CN0X
		'cn0x_sol'    => $CN0_IP_SOL,
		'cn0x_lla'    => $CN0_IP_LLA,
		'cn0x_ga'     => $CN0_IP_LINKX_GA,

		# CN0Y
		'cn0y_sol'    => $CN0_IP_SOL,
		'cn0y_lla'    => $CN0_IP_LLA,
		'cn0y_ga'     => $CN0_IP_LINKY_GA,

		# CN0
		'cn0_sol'     => $CN0_IP_SOL,
		'cn0_lla'     => $CN0_IP_LLA,
		'cn0_ga'      => $CN0_IP_LINKZ_GA,

		# CN1
		'cn1_sol'     => $CN1_IP_SOL,
		'cn1_lla'     => $CN1_IP_LLA,
		'cn1_ga'      => $CN1_IP_GA,

		# NUT0
		'nut0l_sol'   => $NUT0_IP_LINK0L_SOL,
		'nut0_sol'    => $NUT0_IP_LINK0_SOL,
		'nut0_lla'    => $NUT0_IP_LINK0_LLA,
		'nut0_ga'     => $NUT0_IP_LINK0_GA,

		# HOME
		'nuth_sol'    => $NUT0_IP_HOA_SOL,
		'nuth_lla'    => $NUT0_IP_HOA_LLA,
		'nuth_ga'     => $NUT0_IP_HOA_GA,

		# NUTX
		'nutx_sol'    => $NUT0_IP_LINKX_SOL,
		'nutx_lla'    => $NUT0_IP_LINKX_LLA,
		'nutx_ga'     => $NUT0_IP_LINKX_GA,

		# NUTY
		'nuty_sol'    => $NUT0_IP_LINKY_SOL,
		'nuty_lla'    => $NUT0_IP_LINKY_LLA,
		'nuty_ga'     => $NUT0_IP_LINKY_GA,

		# NUTZ
		'nutz_sol'    => $NUT0_IP_LINKZ_SOL,
		'nutz_lla'    => $NUT0_IP_LINKZ_LLA,
		'nutz_ga'     => $NUT0_IP_LINKZ_GA,

		# NUT foreign
		'nutf_sol'    => $NUT0_IP_LINKX_SOL,
		'nutf_lla'    => $NUT0_IP_LINKX_LLA,

		# NUT all
		'nut_sol'     => $NUT0_IP_LINK0_SOL,
		'nut_lla'     => $NUT0_IP_LINK0_LLA,
	);

	# Common
	%unspecified    = ( 'addr_type' => 'unspecifid',     'node_type' => 'unknown', 'node_name' => 'unknown', 'mac' => '00:00:00:00:00:00' );
	%loopback       = ( 'addr_type' => 'loopback',       'node_type' => 'unknown', 'node_name' => 'unknown', 'mac' => '00:00:00:00:00:00' );
	%all_node_multi = ( 'addr_type' => 'all_node_multi', 'node_type' => 'unknown', 'node_name' => 'unknown', 'mac' => '33:33:00:00:00:01' );
	%all_rt_multi   = ( 'addr_type' => 'all_rt_multi',   'node_type' => 'unknown', 'node_name' => 'unknown', 'mac' => '33:33:00:00:00:02' );

	# HA anycast
	%ha0_anysol  = ( 'addr_type' => 'sol', 'node_type' => 'router', 'node_name' => 'ha0',  'mac' => $HA0_MAC_SOL );
	%ha0_anycast = ( 'addr_type' => 'any', 'node_type' => 'router', 'node_name' => 'ha0',  'mac' => $HA0_MAC );

	# HA0
	%ha0_sol     = ( 'addr_type' => 'sol', 'node_type' => 'router', 'node_name' => 'ha0',  'mac' => $HA0_MAC_SOL );
	%ha0_lla     = ( 'addr_type' => 'lla', 'node_type' => 'router', 'node_name' => 'ha0',  'mac' => $HA0_MAC );
	%ha0_ga      = ( 'addr_type' => 'ga',  'node_type' => 'router', 'node_name' => 'ha0',  'mac' => $HA0_MAC );

	# HA1
	%ha1_sol     = ( 'addr_type' => 'sol', 'node_type' => 'router', 'node_name' => 'ha1',  'mac' => $HA1_MAC_SOL );
	%ha1_lla     = ( 'addr_type' => 'lla', 'node_type' => 'router', 'node_name' => 'ha1',  'mac' => $HA1_MAC );
	%ha1_ga      = ( 'addr_type' => 'ga',  'node_type' => 'router', 'node_name' => 'ha1',  'mac' => $HA1_MAC );

	# NODE0
	%node0_sol   = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'node0', 'mac' => $NODE0_MAC_SOL );
	%node0_lla   = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'node0', 'mac' => $NODE0_MAC );
	%node0_ga    = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'node0', 'mac' => $NODE0_MAC );

	# R1
	%r1_sol      = ( 'addr_type' => 'sol', 'node_type' => 'router', 'node_name' => 'r1',   'mac' => $R1_MAC_SOL );
	%r1_lla      = ( 'addr_type' => 'lla', 'node_type' => 'router', 'node_name' => 'r1',   'mac' => $R1_MAC );
	%r1_ga       = ( 'addr_type' => 'ga',  'node_type' => 'router', 'node_name' => 'r1',   'mac' => $R1_MAC );

	# R2
	%r2_sol      = ( 'addr_type' => 'sol', 'node_type' => 'router', 'node_name' => 'r2',   'mac' => $R2_MAC_SOL );
	%r2_lla      = ( 'addr_type' => 'lla', 'node_type' => 'router', 'node_name' => 'r2',   'mac' => $R2_MAC );
	%r2_ga       = ( 'addr_type' => 'ga',  'node_type' => 'router', 'node_name' => 'r2',   'mac' => $R2_MAC );

	# HA3 anycast
	%ha3_anycast = ( 'addr_type' => 'any', 'node_type' => 'router', 'node_name' => 'ha3',  'mac' => $HA3_MAC );

	# HA3
	%ha3_sol     = ( 'addr_type' => 'sol', 'node_type' => 'router', 'node_name' => 'ha3',  'mac' => $HA3_MAC_SOL );
	%ha3_lla     = ( 'addr_type' => 'lla', 'node_type' => 'router', 'node_name' => 'ha3',  'mac' => $HA3_MAC );
	%ha3_ga      = ( 'addr_type' => 'ga',  'node_type' => 'router', 'node_name' => 'ha3',  'mac' => $HA3_MAC );

	# CN00
	%cn00_sol    = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'cn00', 'mac' => $CN0_MAC_SOL );
	%cn00_lla    = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'cn00', 'mac' => $CN0_MAC );
	%cn00_ga     = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'cn00', 'mac' => $CN0_MAC );

	# CN0X
	%cn0x_sol    = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'cn0x', 'mac' => $CN0_MAC_SOL );
	%cn0x_lla    = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'cn0x', 'mac' => $CN0_MAC );
	%cn0x_ga     = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'cn0x', 'mac' => $CN0_MAC );

	# CN0Y
	%cn0y_sol    = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'cn0y', 'mac' => $CN0_MAC_SOL );
	%cn0y_lla    = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'cn0y', 'mac' => $CN0_MAC );
	%cn0y_ga     = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'cn0y', 'mac' => $CN0_MAC );

	# CN0
	%cn0_sol     = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'cn0',  'mac' => $CN0_MAC_SOL );
	%cn0_lla     = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'cn0',  'mac' => $CN0_MAC );
	%cn0_ga      = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'cn0',  'mac' => $CN0_MAC );

	# CN1
	%cn1_sol     = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'cn1',  'mac' => $CN1_MAC_SOL );
	%cn1_lla     = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'cn1',  'mac' => $CN1_MAC );
	%cn1_ga      = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'cn1',  'mac' => $CN1_MAC );

	# NUT0
	%nut0l_sol   = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'nut0', 'mac' => $NUT0L_MAC_SOL );
	%nut0_sol    = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'nut0', 'mac' => $NUT0_MAC_SOL );
	%nut0_lla    = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'nut0', 'mac' => $NUT0_MAC );
	%nut0_ga     = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'nut0', 'mac' => $NUT0_MAC );

	# HOME
	%nuth_sol    = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'nuth', 'mac' => $NUT0_MAC_SOL );
	%nuth_lla    = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'nuth', 'mac' => $NUT0_MAC );
	%nuth_ga     = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'nuth', 'mac' => $NUT0_MAC );

	# NUTX
	%nutx_sol    = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'nutx', 'mac' => $NUTX_MAC_SOL );
	%nutx_lla    = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'nutx', 'mac' => $NUTX_MAC );
	%nutx_ga     = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'nutx', 'mac' => $NUTX_MAC );

	# NUTY
	%nuty_sol    = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'nuty', 'mac' => $NUTX_MAC_SOL );
	%nuty_lla    = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'nuty', 'mac' => $NUTX_MAC );
	%nuty_ga     = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'nuty', 'mac' => $NUTX_MAC );

	# NUTZ
	%nutz_sol    = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'nutz', 'mac' => $NUTX_MAC_SOL );
	%nutz_lla    = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'nutz', 'mac' => $NUTX_MAC );
	%nutz_ga     = ( 'addr_type' => 'ga',  'node_type' => 'host',   'node_name' => 'nutz', 'mac' => $NUTX_MAC );

	# NUT foreign
	%nutf_sol    = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'nutf', 'mac' => $NUTX_MAC_SOL );
	%nutf_lla    = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'nutf', 'mac' => $NUTX_MAC );

	# NUT all
	%nut_sol     = ( 'addr_type' => 'sol', 'node_type' => 'host',   'node_name' => 'nut',  'mac' => $NUT0_MAC_SOL );
	%nut_lla     = ( 'addr_type' => 'lla', 'node_type' => 'host',   'node_name' => 'nut',  'mac' => $NUT0_MAC );

	%addr_hash_Link0 = (
		# Common
		'::'             => 'unspecified',
		'::1'            => 'loopback',
		'ff02::1'        => 'all_node_multi',
		'ff02::2'        => 'all_rt_multi',

		# HA anycast
		$HA0_ANYSOL      => 'ha0_anysol',
		$HA0_ANYCAST     => 'ha0_anycast',

		# HA0
		$HA0_IP_SOL      => 'ha0_sol',
		$HA0_IP_LLA      => 'ha0_lla',
		$HA0_IP_GA       => 'ha0_ga',

		# HA1
		$HA1_IP_SOL      => 'ha1_sol',
		$HA1_IP_LLA      => 'ha1_lla',
		$HA1_IP_GA       => 'ha1_ga',

		# NODE0
		$NODE0_IP_SOL    => 'node0_sol',
		$NODE0_IP_LLA    => 'node0_lla',
		$NODE0_IP_GA     => 'node0_ga',

		# CN00
		$CN0_IP_SOL      => 'cn00_sol',
		$CN0_IP_LLA      => 'cn00_lla',
		$CN0_IP_LINK0_GA => 'cn00_ga',

		# NUT0
		$NUT0_IP_LINK0L_SOL => 'nut0l_sol',
#		$NUT0_IP_LINK0_SOL  => 'nut0_sol',
#		$NUT0_IP_LINK0_LLA  => 'nut0_lla',
#		$NUT0_IP_LINK0_GA   => 'nut0_ga',
	);

	# HOME
	$addr_hash_Link0{$NUT0_IP_LINK0_SOL} = 'nut0_sol';
	$addr_hash_Link0{$NUT0_IP_LINK0_LLA} = 'nut0_lla';
	$addr_hash_Link0{$NUT0_IP_LINK0_GA}  = 'nut0_ga';
	$addr_hash_Link0{$NUT0_IP_HOA_SOL}   = 'nuth_sol';
	$addr_hash_Link0{$NUT0_IP_HOA_LLA}   = 'nuth_lla';
	$addr_hash_Link0{$NUT0_IP_HOA_GA}    = 'nuth_ga';

	%addr_hash_LinkX = (
		# Common
		'::'               => 'unspecified',
		'::1'              => 'loopback',
		'ff02::1'          => 'all_node_multi',
		'ff02::2'          => 'all_rt_multi',

		# R1
		$R1_IP_SOL         => 'r1_sol',
		$R1_IP_LLA         => 'r1_lla',
		$R1_IP_GA          => 'r1_ga',

		# CN0X
		$CN0_IP_SOL        => 'cn0x_sol',
		$CN0_IP_LLA        => 'cn0x_lla',
		$CN0_IP_LINKX_GA   => 'cn0x_ga',

		# NUTX
		$NUT0_IP_LINKX_SOL => 'nutx_sol',
		$NUT0_IP_LINKX_LLA => 'nutx_lla',
		$NUT0_IP_LINKX_GA  => 'nutx_ga',
	);

	%addr_hash_LinkY = (
		# Common
		'::'               => 'unspecified',
		'::1'              => 'loopback',
		'ff02::1'          => 'all_node_multi',
		'ff02::2'          => 'all_rt_multi',

		# R2
		$R2_IP_SOL         => 'r2_sol',
		$R2_IP_LLA         => 'r2_lla',
		$R2_IP_GA          => 'r2_ga',

		# CN0Y
		$CN0_IP_SOL        => 'cn0y_sol',
		$CN0_IP_LLA        => 'cn0y_lla',
		$CN0_IP_LINKY_GA   => 'cn0y_ga',

		# NUTY
		$NUT0_IP_LINKY_SOL => 'nuty_sol',
		$NUT0_IP_LINKY_LLA => 'nuty_lla',
		$NUT0_IP_LINKY_GA  => 'nuty_ga',
	);

	%addr_hash_LinkZ = (
		# Common
		'::'               => 'unspecified',
		'::1'              => 'loopback',
		'ff02::1'          => 'all_node_multi',
		'ff02::2'          => 'all_rt_multi',

		# HA3 anycast
		$HA3_ANYCAST       => 'ha3_anycast',

		# HA3
		$HA3_IP_SOL        => 'ha3_sol',
		$HA3_IP_LLA        => 'ha3_lla',
		$HA3_IP_GA         => 'ha3_ga',

		# CN0
		$CN0_IP_SOL        => 'cn0_sol',
		$CN0_IP_LLA        => 'cn0_lla',
		$CN0_IP_LINKZ_GA   => 'cn0_ga',

		# CN1
		$CN1_IP_SOL        => 'cn1_sol',
		$CN1_IP_LLA        => 'cn1_lla',
		$CN1_IP_GA         => 'cn1_ga',

		# NUTZ
		$NUT0_IP_LINKZ_SOL => 'nutz_sol',
		$NUT0_IP_LINKZ_LLA => 'nutz_lla',
		$NUT0_IP_LINKZ_GA  => 'nutz_ga',
	);

	%addr_hash = (%addr_hash_LinkZ, %addr_hash_LinkY, %addr_hash_LinkX, %addr_hash_Link0);

	# NUT0 foreign
	$addr_hash{$NUT0_IP_LINKX_SOL} = 'nutf_sol';
	$addr_hash{$NUT0_IP_LINKX_LLA} = 'nutf_lla';

	# NUT0 all
	$addr_hash{$NUT0_IP_LINK0_SOL} = 'nut_sol';
	$addr_hash{$NUT0_IP_LINK0_LLA} = 'nut_lla';

	if ($MN_CONF{ENV_DEBUG} != 0) {
		print "node_hash ************************\n";
		foreach $aa (sort(keys(%node_hash))) {
			vLogHTML("key=$aa, val=$node_hash{$aa}, <BR>");
		}
		print "node_hash end ********************\n";
		print "addr_hash ************************\n";
		foreach $aa (sort(keys(%addr_hash))) {
			vLogHTML("key=$aa, val=$addr_hash{$aa}, <BR>");
		}
		print "addr_hash end*********************\n";
	}

	vLogHTML("HoA address    : $node_hash{'nuth_ga'}<BR>");
	vLogHTML("Care-of address: $node_hash{'nutx_ga'}<BR>");
	vLogHTML("ha0 address    : $node_hash{'ha0_ga'}<BR>");
	vLogHTML("cn0 address    : $node_hash{'cn0_ga'}<BR>");
}

#-----------------------------------------------------------------------------#
# nut_addr()
# <in> none.
# <out> none.
#-----------------------------------------------------------------------------#
sub nut_addr() {
	my @mac_addr;
	my $l_sol_iid;
	my $sol_iid;
	my $lla_iid;
	my $ga_iid;
	my $tmp_iid;

	# Link0
	if ($MN_CONF{FUNC_DETAIL_HOME_ADDRESS} eq 'STATIC') {
		$NUT0_MAC = lc($V6evalTool::NutDef{Link0_addr});
		@mac_addr = decomp_mac($NUT0_MAC, 'Link0 in NUT.def');
		$NUT0L_MAC_SOL = sprintf "33:33:ff:%02x:%02x:%02x", hex($mac_addr[3]), hex($mac_addr[4]), hex($mac_addr[5]);

		$l_sol_iid = eth2last3(@mac_addr);
		$lla_iid = eth2iid(@mac_addr);

		@mac_addr = decomp_mac_2("$MN_CONF{FUNC_DETAIL_HOME_STATIC_ID}", "FUNC_DETAIL_HOME_STATIC_ID");
		$NUT0_MAC_SOL = sprintf "33:33:ff:%02x:%02x:%02x", hex($mac_addr[3]), hex($mac_addr[4]), hex($mac_addr[5]);

		$sol_iid = eth2last3_2(@mac_addr);
		$tmp_iid = eth2iid_2(@mac_addr);
		$ga_iid = "::" . "$tmp_iid";
	}
	else {
		$NUT0_MAC = lc($V6evalTool::NutDef{Link0_addr});
		@mac_addr = decomp_mac($NUT0_MAC, 'Link0 in NUT.def');
		$NUT0L_MAC_SOL = sprintf "33:33:ff:%02x:%02x:%02x", hex($mac_addr[3]), hex($mac_addr[4]), hex($mac_addr[5]);
		$NUT0_MAC_SOL = $NUT0L_MAC_SOL;

		$l_sol_iid = eth2last3(@mac_addr);
		$sol_iid = $l_sol_iid;
		$lla_iid = eth2iid(@mac_addr);
		$ga_iid = ":" . "$lla_iid";
	}

	$NUT0_IP_LINK0L_SOL = sprintf "%s%s", $SOL_PREFIX,   $l_sol_iid;
	$NUT0_IP_LINK0_SOL  = sprintf "%s%s", $SOL_PREFIX,   $sol_iid;
	$NUT0_IP_LINK0_LLA  = sprintf "%s%s", $LL_PREFIX,    $lla_iid;
	$NUT0_IP_LINK0_GA   = sprintf "%s%s", $LINK0_PREFIX, $ga_iid;

#	vLogHTML("NUT0_MAC          = $NUT0_MAC ");
#	vLogHTML("NUT0_MAC_SOL      = $NUT0_MAC_SOL ");
#	vLogHTML("NUT0_IP_LINK0_SOL = $NUT0_IP_LINK0_SOL ");
#	vLogHTML("NUT0_IP_LINK0_LLA = $NUT0_IP_LINK0_LLA ");
#	vLogHTML("NUT0_IP_LINK0_GA  = $NUT0_IP_LINK0_GA  ");

	# LinkX,Y,Z
	if ($MN_CONF{FUNC_DETAIL_COA_ADDRESS} eq 'STATIC') {
		$NUTX_MAC = lc($V6evalTool::NutDef{Link0_addr});
		@mac_addr = decomp_mac($NUTX_MAC, 'Link0 in NUT.def');

		$lla_iid = eth2iid(@mac_addr);

		@mac_addr = decomp_mac_2("$MN_CONF{FUNC_DETAIL_COA_STATIC_ID}", "FUNC_DETAIL_COA_STATIC_ID");
		$NUTX_MAC_SOL = sprintf "33:33:ff:%02x:%02x:%02x", hex($mac_addr[3]), hex($mac_addr[4]), hex($mac_addr[5]);

		$sol_iid = eth2last3_2(@mac_addr);
		$tmp_iid = eth2iid_2(@mac_addr);
		$ga_iid = "::" . "$tmp_iid";
	}
	else {
		$NUTX_MAC = lc($V6evalTool::NutDef{Link0_addr});
		@mac_addr = decomp_mac($NUTX_MAC, 'Link0 in NUT.def');
		$NUTX_MAC_SOL = sprintf "33:33:ff:%02x:%02x:%02x", hex($mac_addr[3]), hex($mac_addr[4]), hex($mac_addr[5]);

		$sol_iid = eth2last3(@mac_addr);
		$lla_iid = eth2iid(@mac_addr);
		$ga_iid = ":" . "$lla_iid";
	}

	$NUT0_IP_LINKX_SOL = sprintf "%s%s", $SOL_PREFIX,   $sol_iid;
	$NUT0_IP_LINKX_LLA = sprintf "%s%s", $LL_PREFIX,    $lla_iid;
	$NUT0_IP_LINKX_GA  = sprintf "%s%s", $LINKX_PREFIX, $ga_iid;

#	vLogHTML("NUTX_MAC          = $NUTX_MAC ");
#	vLogHTML("NUTX_MAC_SOL      = $NUTX_MAC_SOL ");
#	vLogHTML("NUT0_IP_LINKX_SOL = $NUT0_IP_LINKX_SOL ");
#	vLogHTML("NUT0_IP_LINKX_LLA = $NUT0_IP_LINKX_LLA ");
#	vLogHTML("NUT0_IP_LINKX_GA  = $NUT0_IP_LINKX_GA  ");

	$NUT0_IP_LINKY_SOL = sprintf "%s%s", $SOL_PREFIX,   $sol_iid;
	$NUT0_IP_LINKY_LLA = sprintf "%s%s", $LL_PREFIX,    $lla_iid;
	$NUT0_IP_LINKY_GA  = sprintf "%s%s", $LINKY_PREFIX, $ga_iid;

	$NUT0_IP_LINKZ_SOL = sprintf "%s%s", $SOL_PREFIX,   $sol_iid;
	$NUT0_IP_LINKZ_LLA = sprintf "%s%s", $LL_PREFIX,    $lla_iid;
	$NUT0_IP_LINKZ_GA  = sprintf "%s%s", $LINKZ_PREFIX, $ga_iid;

	# HOA
	$NUT0_IP_HOA_SOL = $NUT0_IP_LINK0_SOL;
	$NUT0_IP_HOA_LLA = $NUT0_IP_LINK0_LLA;
	$NUT0_IP_HOA_GA  = $NUT0_IP_LINK0_GA;
}

#-----------------------------------------------------------------------------#
# cn_addr()
# <in>   none.
# <out>  none.
#-----------------------------------------------------------------------------#
sub cn_addr() {
	my $ADDR = 0;
	my @mac_addr;
	my $sol_iid;
	my $lla_iid;

	if ($MN_CONF{ENV_INITIALIZE} eq 'RETURN') {
		# read number
		open(ADDR_INI, "mip6_mn_addr.ini");
		$ADDR += <ADDR_INI>;
		close(ADDR_INI);
	}

	# CN0
	$CN0_MAC = sprintf "00:00:00:%02x:a8:a8", $ADDR;
	@mac_addr = decomp_mac($CN0_MAC, 'cn_addr() in mipv6_mn_config.pm');
	$CN0_MAC_SOL = sprintf "33:33:ff:%02x:a8:a8", $ADDR;

	$sol_iid = eth2last3(@mac_addr);
	$lla_iid = eth2iid(@mac_addr);
	$CN0_IP_SOL      = sprintf "%s%s" , $SOL_PREFIX,   $sol_iid;
	$CN0_IP_LLA      = sprintf "%s%s" , $LL_PREFIX,    $lla_iid;
	$CN0_IP_LINK0_GA = sprintf "%s:%s", $LINK0_PREFIX, $lla_iid;
	$CN0_IP_LINKX_GA = sprintf "%s:%s", $LINKX_PREFIX, $lla_iid;
	$CN0_IP_LINKY_GA = sprintf "%s:%s", $LINKY_PREFIX, $lla_iid;
	$CN0_IP_LINKZ_GA = sprintf "%s:%s", $LINKZ_PREFIX, $lla_iid;

	# write mip6_mn_cn0_addr.def
	open(CN0_ADDR_DEF, "> mip6_mn_cn0_addr.def");

	printf CN0_ADDR_DEF "#define CN00_MAC_ADDR       \"$CN0_MAC\"\n";
	printf CN0_ADDR_DEF "#define CN00_LLOCAL_UCAST   \"$CN0_IP_LLA\"\n";
	printf CN0_ADDR_DEF "#define CN00_GLOBAL_UCAST   \"$CN0_IP_LINK0_GA\"\n";

	printf CN0_ADDR_DEF "\n";

	printf CN0_ADDR_DEF "#define CN0X_MAC_ADDR       \"$CN0_MAC\"\n";
	printf CN0_ADDR_DEF "#define CN0X_LLOCAL_UCAST   \"$CN0_IP_LLA\"\n";
	printf CN0_ADDR_DEF "#define CN0X_GLOBAL_UCAST   \"$CN0_IP_LINKX_GA\"\n";

	printf CN0_ADDR_DEF "\n";

	printf CN0_ADDR_DEF "#define CN0Y_MAC_ADDR       \"$CN0_MAC\"\n";
	printf CN0_ADDR_DEF "#define CN0Y_LLOCAL_UCAST   \"$CN0_IP_LLA\"\n";
	printf CN0_ADDR_DEF "#define CN0Y_GLOBAL_UCAST   \"$CN0_IP_LINKY_GA\"\n";

	printf CN0_ADDR_DEF "\n";

	printf CN0_ADDR_DEF "#define CN0_MAC_ADDR        \"$CN0_MAC\"\n";
	printf CN0_ADDR_DEF "#define CN0_LLOCAL_UCAST    \"$CN0_IP_LLA\"\n";
	printf CN0_ADDR_DEF "#define CN0_GLOBAL_UCAST    \"$CN0_IP_LINKZ_GA\"\n";

	close(CN0_ADDR_DEF);

	if ($MN_CONF{ENV_INITIALIZE} eq 'RETURN') {
		$ADDR = ($ADDR + 1) % 256;
		open(ADDR_INI, "> mip6_mn_addr.ini");
		print ADDR_INI "$ADDR\n";
		close(ADDR_INI);
	}
}

#-----------------------------------------------------------------------------#
# r2_addr()
# <in> none.
# <out> none.
#-----------------------------------------------------------------------------#
sub r2_addr() {
	my @mac_addr;
	my $sol_iid;
	my $lla_iid;

	# R2
	if ($MN_CONF{SET_SAME_MAC_R1R2} eq 'YES') {
		$R2_MAC     = $R1_MAC;
		$R2_MAC_SOL = $R1_MAC_SOL;
	}
	@mac_addr = decomp_mac($R2_MAC, 'r2_addr() in mip6_mn_config.pm');

	$sol_iid   = eth2last3(@mac_addr);
	$lla_iid   = eth2iid(@mac_addr);
	$R2_IP_SOL = sprintf "%s%s",  $SOL_PREFIX,   $sol_iid;
	$R2_IP_LLA = sprintf "%s%s",  $LL_PREFIX,    $lla_iid;
	$R2_IP_GA  = sprintf "%s:%s", $LINKY_PREFIX, $lla_iid;

	# write mip6_mn_r2_addr.def
	open(R2_ADDR_DEF, "> mip6_mn_r2_addr.def");

	printf R2_ADDR_DEF "#define R2_MAC_ADDR      \"$R2_MAC\"\n";
	printf R2_ADDR_DEF "#define R2_LLOCAL_UCAST  \"$R2_IP_LLA\"\n";
	printf R2_ADDR_DEF "#define R2_GLOBAL_UCAST  \"$R2_IP_GA\"\n";

	close(R2_ADDR_DEF);
}

#-----------------------------------------------------------------------------#
# decomp_mac()
# <in>  $mac_addr : mac address
#       $msg      : strings (work point)
# <out> @mac_list : 
#-----------------------------------------------------------------------------#
sub decomp_mac($$) {
	my($mac_addr, $msg) = @_;
	my @mac_list = ();

	# check of mac address format
	if( $mac_addr =~ /([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9])/ ) {
		@mac_list = ($1, $2, $3, $4, $5, $6);
	}
	else {
		vLogHTML("MAC Address is invalid. $msg in nut.def");
		exit $V6evalTool::exitFatal;
	}

	return(@mac_list);
}

#-----------------------------------------------------------------------------#
# eth2iid()
# <in>  $mac_addr : mac address
# <out> $iid      : interface id
#-----------------------------------------------------------------------------#
sub eth2iid(@) {
	my(@mac_addr) = @_;
	my $iid = '';
	my $tmp_iid;

	$iid = sprintf "%x", (hex($mac_addr[0])^0x2);
	$iid .= sprintf "%s", $mac_addr[1];
	if ( hex($mac_addr[2]) != 0 ) {
		$iid .= sprintf ":%xff:fe", hex($mac_addr[2]);
	} else {
		$iid .= ":ff:fe";
	}
	$iid .= sprintf "%02x", hex($mac_addr[3]);
	$tmp_iid = "$mac_addr[4]$mac_addr[5]";
	$iid .= sprintf ":%x", hex($tmp_iid);

	return($iid);
}

#-----------------------------------------------------------------------------#
# eth2last3()
# <in>  @mac_addr : mac address
# <out> $last3    : interface id list 2byte
#-----------------------------------------------------------------------------#
sub eth2last3(@) {
	my(@mac_addr) = @_;
	my $last2 = '';
	my $last3 = '';

	$last2 = "$mac_addr[4]$mac_addr[5]";
	$last3 = sprintf "%02x:%x", hex($mac_addr[3]), hex($last2);

	return($last3);
}

#-----------------------------------------------------------------------------#
# decomp_mac_2()
# <in>  $mac_addr : static id
#       $msg      : strings (work point)
# <out> @mac_list : 
#-----------------------------------------------------------------------------#
sub decomp_mac_2($$) {
	my($mac_addr, $msg) = @_;
	my @mac_list = ();

	# check of mac address format
	if( $mac_addr =~ /::([a-f0-9]+)/ ) {
		$ab = $1;
		$b = sprintf "%lx", (hex($ab) % 256);
		$a = sprintf "%lx", ((hex($ab) - hex($b)) / 256);
		@mac_list = (0, 0, 0, 0, $a, $b);
	}
	else {
		vLogHTML("MAC Address is invalid. $msg in config.txt");
		exit $V6evalTool::exitFatal;
	}

	return(@mac_list);
}

#-----------------------------------------------------------------------------#
# eth2iid_2()
# <in>  $mac_addr : mac address
# <out> $iid      : interface id
#-----------------------------------------------------------------------------#
sub eth2iid_2(@) {
	my(@mac_addr) = @_;
	my $iid = '';
	my $tmp_iid;

	$tmp_iid = "$mac_addr[4]$mac_addr[5]";
	$iid = sprintf "%x", hex($tmp_iid);

	return($iid);
}

#-----------------------------------------------------------------------------#
# eth2last3_2()
# <in>  @mac_addr : mac address
# <out> $last3    : interface id list 2byte
#-----------------------------------------------------------------------------#
sub eth2last3_2(@) {
	my(@mac_addr) = @_;
	my $last2 = '';
	my $last3 = '';

	$last2 = "$mac_addr[4]$mac_addr[5]";
	$last3 = sprintf "%02x:%x", hex($mac_addr[3]), hex($last2);

	return($last3);
}

#-----------------------------------------------------------------------------#
# vLogHTML_Info($)
# <in>  $msg: strings
#-----------------------------------------------------------------------------#
sub vLogHTML_Info($) {
	my ($msg) = @_;

	vLogHTML("$msg<BR>");
	return;
}

#-----------------------------------------------------------------------------#
# vLogHTML_Pass($)
# <in>  $msg: strings
#-----------------------------------------------------------------------------#
sub vLogHTML_Pass($) {
	my ($msg) = @_;

	vLogHTML("$msg<BR>");
	return;
}

#-----------------------------------------------------------------------------#
# vLogHTML_Warn($)
# <in>  $msg
#-----------------------------------------------------------------------------#
sub vLogHTML_Warn($) {
	my ($msg) = @_;

	vLogHTML("<B><FONT COLOR=\"#FF8080\">$msg</FONT></B><BR>");
	return;
}

#-----------------------------------------------------------------------------#
# vLogHTML_Fail($)
# <in>  $msg
#-----------------------------------------------------------------------------#
sub vLogHTML_Fail($) {
	my ($msg) = @_;

	vLogHTML("<B><FONT COLOR=\"#FF0000\">$msg</FONT></B><BR>");
	return;
}

# End of File
1;
