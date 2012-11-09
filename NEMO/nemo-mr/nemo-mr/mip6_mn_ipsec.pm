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
package mip6_mn_ipsec;

# EXPORT PACKAGE
use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	init_mn_ipsec
	mip6ipsecClearAll
);

# INPORT PACKAGE
use V6evalTool;
use mip6_mn_config;


# GLOBAL VARIABLE DEFINITION

# LOCAL VARIABLE DEFINITION
$remote_debug = "";

%proto = (
	"ALL"  => "any",
	"MH"   => "135",
	"BU"   => "135",
	"BA"   => "135",
	"HOTI" => "135",
	"HOT"  => "135",
	"ICMP" => "ipv6-icmp",
	"MPS"  => "ipv6-icmp",
	"MPA"  => "ipv6-icmp",
	"X"    => "any",
#	"X"    => "ipv6-icmp",
);

%algo = (
	"DESCBC"   => "des-cbc",
	"DES3CBC"  => "3des-cbc",
	"HMACSHA1" => "hmac-sha1",
	"HMACMD5"  => "hmac-md5",
);

# SUBROUTINE DECLARATION
sub init_mn_ipsec();
sub mip6ipsecExitPass();
sub mip6ipsecExitNS();
sub mip6ipsecExitFail();
sub mip6ipsecSetSAD(@);
sub mip6ipsecSetSPD(@);
sub mip6ipsecClearAll();
sub mip6ipsecEnable();

# SUBROUTINE
#--------------------------------------------------------------#
# init_mn_ipsec()                                              #
#                                                              #
# Notes:                                                       #
#       Reset MN functionality with ipsec                      #
#                                                              #
#--------------------------------------------------------------#
sub init_mn_ipsec() {
	my $nuth = $node_hash{nuth_ga};
	my $ha0  = $node_hash{ha0_ga};
	my $ha1  = $node_hash{ha1_ga};
	my $cn0  = $node_hash{cn0_ga};

	mip6ipsecClearAll();

	# SA1 MN -> HA0 BU
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} ne 'NONE') {
		mip6ipsecSetSAD(
			"src=$nuth",
			"dst=$ha0",
			"spi=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_SPI}",
			"mode=transport",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=$nuth",
			"dst=$ha0",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO}}",
			"direction=out",
			"mode=transport",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_SPI}",
			"ommit", "nodump",
		);
	}
	# SA2 HA0 -> MN BA
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} ne 'NONE') {
		mip6ipsecSetSAD(
			"src=$ha0",
			"dst=$nuth",
			"spi=$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_SPI}",
			"mode=transport",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=$ha0",
			"dst=$nuth",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO}}",
			"direction=in",
			"mode=transport",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_SPI}",
			"ommit", "nodump",
		);
	}

	# HA1
	if (($MN_CONF{ENV_HA1_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA1 MN -> HA1 BU
		if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} ne 'NONE') {
			mip6ipsecSetSAD(
				"src=$nuth",
				"dst=$ha1",
				"spi=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_SPI}",
				"mode=transport",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=$nuth",
				"dst=$ha1",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO}}",
				"direction=out",
				"mode=transport",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_SPI}",
				"ommit", "nodump",
			);
		}
		# SA2 HA1 -> MN BA
		if ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} ne 'NONE') {
			mip6ipsecSetSAD(
				"src=$ha1",
				"dst=$nuth",
				"spi=$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_SPI}",
				"mode=transport",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=$ha1",
				"dst=$nuth",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO}}",
				"direction=in",
				"mode=transport",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_SPI}",
				"ommit", "nodump",
			);
		}
	}

	# SA5 MN -> HA0 Prefix Discovery
	if (($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} ne 'ALL') &&
	    ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO} ne 'NONE')) {
		mip6ipsecSetSAD(
			"src=$nuth",
			"dst=$ha0",
			"spi=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_SPI}",
			"mode=transport",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=$nuth",
			"dst=$ha0",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO}}",
			"direction=out",
			"mode=transport",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_SPI}",
			"ommit", "nodump",
		);
	}
	# SA6 HA0 -> MN Prefix Discovery
	if (($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} ne 'ALL') &&
	    ($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO} ne 'NONE')) {
		mip6ipsecSetSAD(
			"src=$ha0",
			"dst=$nuth",
			"spi=$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_SPI}",
			"mode=transport",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=$ha0",
			"dst=$nuth",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO}}",
			"direction=in",
			"mode=transport",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_SPI}",
			"ommit", "nodump",
		);
	}

	# HA1
	if (($MN_CONF{ENV_HA1_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA5 MN -> HA1 Prefix Discovery
		if (($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} ne 'ALL') &&
		    ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO} ne 'NONE')) {
			mip6ipsecSetSAD(
				"src=$nuth",
				"dst=$ha1",
				"spi=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_SPI}",
				"mode=transport",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=$nuth",
				"dst=$ha1",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO}}",
				"direction=out",
				"mode=transport",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_SPI}",
				"ommit", "nodump",
			);
		}
		# SA6 HA1 -> MN Prefix Discovery
		if (($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} ne 'ALL') &&
		    ($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO} ne 'NONE')) {
			mip6ipsecSetSAD(
				"src=$ha1",
				"dst=$nuth",
				"spi=$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_SPI}",
				"mode=transport",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=$ha1",
				"dst=$nuth",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO}}",
				"direction=in",
				"mode=transport",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_SPI}",
				"ommit", "nodump",
			);
		}
	}

	# CN0 Payload
	if (($MN_CONF{ENV_CN0_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA5 MN -> CN0 ICMP
		if ($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_PROTO} ne 'NONE') {
			mip6ipsecSetSAD(
				"src=$nuth",
				"dst=$cn0",
				"spi=$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_SPI}",
				"mode=transport",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=$nuth",
				"dst=$cn0",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_PROTO}}",
				"direction=out",
				"mode=transport",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_SPI}",
				"ommit", "nodump",
			);
		}
		# SA6 CN0 -> MN ICMP
		if ($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_PROTO} ne 'NONE') {
			mip6ipsecSetSAD(
				"src=$cn0",
				"dst=$nuth",
				"spi=$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_SPI}",
				"mode=transport",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=$cn0",
				"dst=$nuth",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_PROTO}}",
				"direction=in",
				"mode=transport",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_SPI}",
				"ommit", "nodump",
			);
		}
	}

	# SA3 MN -> HA0 Return Routability Signaling
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} ne 'NONE') {
		mip6ipsecSetSAD(
			"src=$nuth",
			"dst=$ha0",
			"spi=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_SPI}",
			"mode=tunnel",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=$nuth",
			"dst=::/0",
			"tsrc=$nuth",
			"tdst=$ha0",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO}}",
			"direction=out",
			"mode=tunnel",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_SPI}",
			"nodump",
		);
	}
	# SA4 HA0 -> MN Return Routability Signaling
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} ne 'NONE') {
		mip6ipsecSetSAD(
			"src=$ha0",
			"dst=$nuth",
			"spi=$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_SPI}",
			"mode=tunnel",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=::/0",
			"dst=$nuth",
			"tsrc=$ha0",
			"tdst=$nuth",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO}}",
			"direction=in",
			"mode=tunnel",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_SPI}",
			"nodump",
		);
	}

	# HA1
	if (($MN_CONF{ENV_HA1_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA3 MN -> HA1 Return Routability Signaling
		if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} ne 'NONE') {
			mip6ipsecSetSAD(
				"src=$nuth",
				"dst=$ha1",
				"spi=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_SPI}",
				"mode=tunnel",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=$nuth",
				"dst=::/0",
				"tsrc=$nuth",
				"tdst=$ha1",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO}}",
				"direction=out",
				"mode=tunnel",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_SPI}",
				"nodump",
			);
		}
		# SA4 HA1 -> MN Return Routability Signaling
		if ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} ne 'NONE') {
			mip6ipsecSetSAD(
				"src=$ha1",
				"dst=$nuth",
				"spi=$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_SPI}",
				"mode=tunnel",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=::/0",
				"dst=$nuth",
				"tsrc=$ha1",
				"tdst=$nuth",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO}}",
				"direction=in",
				"mode=tunnel",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_SPI}",
				"nodump",
			);
		}
	}

	# SA7 MN -> HA0 Payload Packets
	if (($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} ne 'ALL') &&
	    ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO} ne 'NONE')) {
		mip6ipsecSetSAD(
			"src=$nuth",
			"dst=$ha0",
			"spi=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_SPI}",
			"mode=tunnel",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=$nuth",
			"dst=::/0",
			"tsrc=$nuth",
			"tdst=$ha0",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO}}",
			"direction=out",
			"mode=tunnel",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_SPI}",
			"nodump",
		);
	}
	# SA8 HA0 -> MN Payload Packets
	if (($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} ne 'ALL') &&
	    ($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO} ne 'NONE')) {
		mip6ipsecSetSAD(
			"src=$ha0",
			"dst=$nuth",
			"spi=$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_SPI}",
			"mode=tunnel",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=::/0",
			"dst=$nuth",
			"tsrc=$ha0",
			"tdst=$nuth",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO}}",
			"direction=in",
			"mode=tunnel",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_SPI}",
			"nodump",
		);
	}

	# HA1
	if (($MN_CONF{ENV_HA1_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA7 MN -> HA1 Payload Packets
		if (($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} ne 'ALL') &&
		    ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO} ne 'NONE')) {
			mip6ipsecSetSAD(
				"src=$nuth",
				"dst=$ha1",
				"spi=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_SPI}",
				"mode=tunnel",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=$nuth",
				"dst=::/0",
				"tsrc=$nuth",
				"tdst=$ha1",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO}}",
				"direction=out",
				"mode=tunnel",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_SPI}",
				"nodump",
			);
		}
		# SA8 HA1 -> MN Payload Packets
		if (($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} ne 'ALL') &&
		    ($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO} ne 'NONE')) {
			mip6ipsecSetSAD(
				"src=$ha1",
				"dst=$nuth",
				"spi=$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_SPI}",
				"mode=tunnel",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=::/0",
				"dst=$nuth",
				"tsrc=$ha1",
				"tdst=$nuth",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO}}",
				"direction=in",
				"mode=tunnel",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_SPI}",
				"nodump",
			);
		}
	}

	# SA9 MN -> HA0 Payload Packets
	if ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_PROTO} eq 'X') {
		mip6ipsecSetSAD(
			"src=$nuth",
			"dst=$ha0",
			"spi=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_SPI}",
			"mode=tunnel",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=$MNP",
			"dst=::/0",
			"tsrc=$nuth",
			"tdst=$ha0",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_PROTO}}",
			"direction=out",
			"mode=tunnel",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_SPI}",
			"nodump",
		);
	}
	# SA10 HA0 -> MN Payload Packets
	if ($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_PROTO} eq 'X') {
		mip6ipsecSetSAD(
			"src=$ha0",
			"dst=$nuth",
			"spi=$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_SPI}",
			"mode=tunnel",
			"protocol=esp",
			"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP}}",
			"ealgokey=$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY}",
			"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH}}",
			"eauthkey=$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH_KEY}",
			"unique=$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_SPI}",
			"nodump",
		);
		mip6ipsecSetSPD(
			"src=::/0",
			"dst=$MNP",
			"tsrc=$ha0",
			"tdst=$nuth",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_PROTO}}",
			"direction=in",
			"mode=tunnel",
			"protocol=esp",
			'level=unique',
			"unique=$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_SPI}",
			"nodump",
		);
	}

	# HA1
	if (($MN_CONF{ENV_HA1_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA9 MN -> HA1 Payload Packets
		if ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_PROTO} eq 'X'){
			mip6ipsecSetSAD(
				"src=$nuth",
				"dst=$ha1",
				"spi=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_SPI}",
				"mode=tunnel",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=$MNP",
				"dst=::/0",
				"tsrc=$nuth",
				"tdst=$ha1",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_PROTO}}",
				"direction=out",
				"mode=tunnel",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_SPI}",
				"nodump",
			);
		}

		# SA10 HA1 -> MN Payload Packets
		if ($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_PROTO} eq 'X'){
			mip6ipsecSetSAD(
				"src=$ha1",
				"dst=$nuth",
				"spi=$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_SPI}",
				"mode=tunnel",
				"protocol=esp",
				"ealgo=$algo{$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP}}",
				"ealgokey=$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY}",
				"eauth=$algo{$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH}}",
				"eauthkey=$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH_KEY}",
				"unique=$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_SPI}",
				"nodump",
			);
			mip6ipsecSetSPD(
				"src=::/0",
				"dst=$MNP",
				"tsrc=$ha1",
				"tdst=$nuth",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_PROTO}}",
				"direction=in",
				"mode=tunnel",
				"protocol=esp",
				'level=unique',
				"unique=$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_SPI}",
				"nodump",
			);
		}
	}

	mip6ipsecEnable();

	return;
}

#======================================================================
# mip6ipsecExitPass()
#======================================================================
sub mip6ipsecExitPass() {
	vLogHTML('OK<BR>');
	exit $V6evalTool::exitPass;
}

#======================================================================
# mip6ipsecExitNS()
#======================================================================
sub mip6ipsecExitNS() {
	vLogHTML("This test is not supported now<BR>");
	exit $V6evalTool::exitNS;
}

#======================================================================
# mip6ipsecExitFail()
#======================================================================
sub mip6ipsecExitFail() {
	vLogHTML('<FONT COLOR="#FF0000">NG</FONT><BR>');
	exit $V6evalTool::exitFatal;
}

#======================================================================
# mip6ipsecSetSAD() - set SAD entries
#======================================================================
sub mip6ipsecSetSAD(@) {
	vLogHTML("Target: Set SAD entries: @_");
	$ret = vRemote("ipsecSetSAD.rmt", "@_", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Set SAD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
			mip6ipsecExitNS();
		}
		else {
			mip6ipsecExitFail();
		}
	}
}

#======================================================================
# mip6ipsecSetSPD() - set SPD entries
#======================================================================
sub mip6ipsecSetSPD(@) {
	vLogHTML("Target: Set SPD entries: @_");
	$ret = vRemote("ipsecSetSPD.rmt", "@_", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Set SPD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
			mip6ipsecExitNS();
		}
		else {
			mip6ipsecExitFail();
		}
	}
}

#======================================================================
# mip6ipsecClearAll() - clear all SAD and SPD entries
#======================================================================
sub mip6ipsecClearAll() {
	vLogHTML("Target: Clear all SAD and SPD entries");
	$ret = vRemote("ipsecClearAll.rmt", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Clear all SAD and SPD entries<BR>");
		if ($ret == $V6evalTool::exitNS) {
			mip6ipsecExitNS();
		}
		else {
			mip6ipsecExitFail();
		}
	}
}

#======================================================================
# mip6ipsecEnable() - Enable and start IPsec function
#======================================================================
sub mip6ipsecEnable() {
	vLogHTML("Target: Enable and start IPsec function");
#	$ret = vRemote("ipsecEnable.rmt", $remote_debug);
	$ret = vRemote("ipsecEnable.rmt", 'testtype=mip6mn', $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Enable IPsec<BR>");
		if ($ret == $V6evalTool::exitNS) {
			mip6ipsecExitNS();
		}
		else {
			mip6ipsecExitFail();
		}
	}
}

########################################################################
# Subroutine which makes global address from EUI-64
#-----------------------------------------------------------------------
sub vMAC2GLOBALAddr($$) {
	my (
		$prefix, # Link prefix
		$addr    # MAC Address
	) = @_;
	my (@str, @str1, @hex);

	@str1=split(/"/,$prefix);
	@str=split(/:/,@str1[1]);

	@hex = (@str[0],@str[1],@str[2],@str[3]);

	@str=split(/:/,$addr);
	foreach(@str) {
		push @hex,hex($_);
	};

	#
	# invert universal/local bit
	@hex[4] ^= 0x02;

	sprintf "%s:%s:%s:%s:%02x%02x:%02xff:fe%02x:%02x%02x",@hex;
}

########################################################################

1;
########################################################################
__END__
