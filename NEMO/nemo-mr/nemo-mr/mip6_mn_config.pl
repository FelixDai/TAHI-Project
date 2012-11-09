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

# INPORT PACKAGE
use Getopt::Long;
use mip6_mn_config;

my $opt_logo = 0; # 1: basic
                  # 2: fine grain

unless(open(INPUT, "logo.ini")) {
	printf(STDERR "open: logo.ini: $!\n");
	exit (-1);
}
while(<INPUT>) {
	chomp;
	$opt_logo = $_;
}
close(INPUT);

# printf(STDERR "opt_logo=$opt_logo\n");

# Set the config parameter.
&mip6_mn_config::set_config($opt_logo);

# Set the node address.
&mip6_mn_config::set_node_addr();

#------------------------------------------------------------------------------
open(CONFIG_DEF, "> mip6_mn_config.def");

if ($MN_CONF{FUNC_DETAIL_BU_TO_HA_ALTCOA} eq 'YES') {
	print CONFIG_DEF "#define FUNC_DETAIL_BU_TO_HA_ALTCOA 1\n";
}
else {
	print CONFIG_DEF "#undef FUNC_DETAIL_BU_TO_HA_ALTCOA\n";
}
if ($MN_CONF{FUNC_DETAIL_MR_REGISTRATION_MODE} eq 'EXPLICIT') {
	print CONFIG_DEF "#define FUNC_DETAIL_MR_REGISTRATION_MODE_EXPLICIT 1\n";
}
else {
	print CONFIG_DEF "#undef FUNC_DETAIL_MR_REGISTRATION_MODE_EXPLICIT\n";
}
if ($MN_CONF{FUNC_DETAIL_BU_TO_CN_AUTHDATA} eq 'YES') {
	print CONFIG_DEF "#define FUNC_DETAIL_BU_TO_CN_AUTHDATA 1\n";
}
else {
	print CONFIG_DEF "#undef FUNC_DETAIL_BU_TO_CN_AUTHDATA\n";
}

print CONFIG_DEF "\n";

print CONFIG_DEF "#define LINK0_GLOBAL_PREFIX \"$LINK0_PREFIX" . "::\"\n";

print CONFIG_DEF "#define HA_GLOBAL_ANYCAST   \"$node_hash{ha0_anycast}\"\n";

print CONFIG_DEF "#define HA0_MAC_ADDR        \"$ha0_lla{mac}\"\n";
print CONFIG_DEF "#define HA0_LLOCAL_UCAST    \"$node_hash{ha0_lla}\"\n";
print CONFIG_DEF "#define HA0_GLOBAL_UCAST    \"$node_hash{ha0_ga}\"\n";

print CONFIG_DEF "#define HA1_MAC_ADDR        \"$ha1_lla{mac}\"\n";
print CONFIG_DEF "#define HA1_LLOCAL_UCAST    \"$node_hash{ha1_lla}\"\n";
print CONFIG_DEF "#define HA1_GLOBAL_UCAST    \"$node_hash{ha1_ga}\"\n";

print CONFIG_DEF "#define HA2_MAC_ADDR        \"$ha2_lla{mac}\"\n";
print CONFIG_DEF "#define HA2_LLOCAL_UCAST    \"$node_hash{ha2_lla}\"\n";
print CONFIG_DEF "#define HA2_GLOBAL_UCAST    \"$node_hash{ha2_ga}\"\n";

print CONFIG_DEF "#define NODE0_MAC_ADDR      \"$node0_lla{mac}\"\n";
print CONFIG_DEF "#define NODE0_LLOCAL_UCAST  \"$node_hash{node0_lla}\"\n";
print CONFIG_DEF "#define NODE0_GLOBAL_UCAST  \"$node_hash{node0_ga}\"\n";

print CONFIG_DEF "\n";

print CONFIG_DEF "#define LINKX_GLOBAL_PREFIX \"$LINKX_PREFIX" . "::\"\n";

print CONFIG_DEF "#define R1_MAC_ADDR         \"$r1_lla{mac}\"\n";
print CONFIG_DEF "#define R1_LLOCAL_UCAST     \"$node_hash{r1_lla}\"\n";
print CONFIG_DEF "#define R1_GLOBAL_UCAST     \"$node_hash{r1_ga}\"\n";

print CONFIG_DEF "#define NODE1_MAC_ADDR      \"$node1_lla{mac}\"\n";
print CONFIG_DEF "#define NODE1_LLOCAL_UCAST  \"$node_hash{node1_lla}\"\n";
print CONFIG_DEF "#define NODE1_GLOBAL_UCAST  \"$node_hash{node1_ga}\"\n";

print CONFIG_DEF "\n";

print CONFIG_DEF "#define LINKY_GLOBAL_PREFIX \"$LINKY_PREFIX" . "::\"\n";

print CONFIG_DEF "\n";

print CONFIG_DEF "#define LINKZ_GLOBAL_PREFIX \"$LINKZ_PREFIX" . "::\"\n";

print CONFIG_DEF "#define HA3_MAC_ADDR       \"$ha3_lla{mac}\"\n";
print CONFIG_DEF "#define HA3_LLOCAL_UCAST   \"$node_hash{ha3_lla}\"\n";
print CONFIG_DEF "#define HA3_GLOBAL_UCAST   \"$node_hash{ha3_ga}\"\n";

print CONFIG_DEF "#define CN1_MAC_ADDR        \"$cn1_lla{mac}\"\n";
print CONFIG_DEF "#define CN1_LLOCAL_UCAST    \"$node_hash{cn1_lla}\"\n";
print CONFIG_DEF "#define CN1_GLOBAL_UCAST    \"$node_hash{cn1_ga}\"\n";

print CONFIG_DEF "#define VMN1_MAC_ADDR       \"$vmn1_lla{mac}\"\n";
print CONFIG_DEF "#define VMN1_LLOCAL_UCAST   \"$node_hash{vmn1_lla}\"\n";
print CONFIG_DEF "#define VMN1_GLOBAL_UCAST   \"$node_hash{vmn1_ga}\"\n";

print CONFIG_DEF "#define VMN11_MAC_ADDR       \"$vmn11_lla{mac}\"\n";
print CONFIG_DEF "#define VMN11_LLOCAL_UCAST   \"$node_hash{vmn11_lla}\"\n";
print CONFIG_DEF "#define VMN11_GLOBAL_UCAST   \"$node_hash{vmn11_ga}\"\n";

print CONFIG_DEF "\n";

print CONFIG_DEF "#define LINK1_GLOBAL_PREFIX \"$LINK1_PREFIX" . "::\"\n";

print CONFIG_DEF "#define LFN0_MAC_ADDR       \"$lfn0_lla{mac}\"\n";
print CONFIG_DEF "#define LFN0_LLOCAL_UCAST   \"$node_hash{lfn0_lla}\"\n";
print CONFIG_DEF "#define LFN0_GLOBAL_UCAST   \"$node_hash{lfn0_ga}\"\n";

print CONFIG_DEF "#define LFN1_MAC_ADDR       \"$lfn1_lla{mac}\"\n";
print CONFIG_DEF "#define LFN1_LLOCAL_UCAST   \"$node_hash{lfn1_lla}\"\n";
print CONFIG_DEF "#define LFN1_GLOBAL_UCAST   \"$node_hash{lfn1_ga}\"\n";

close(CONFIG_DEF);

#------------------------------------------------------------------------------
open(NUT_ADDR_DEF, "> mip6_mn_nut_addr.def");

printf NUT_ADDR_DEF "#define NUT0_MAC_ADDR     \"$nut0_lla{mac}\"\n";
printf NUT_ADDR_DEF "#define NUT0_SOL_MAC_ADDR \"$nut0_sol{mac}\"\n";
printf NUT_ADDR_DEF "#define NUT0_LLOCAL_UCAST \"$node_hash{nut0_lla}\"\n";
printf NUT_ADDR_DEF "#define NUT0_GLOBAL_UCAST \"$node_hash{nut0_ga}\"\n";

printf NUT_ADDR_DEF "\n";

printf NUT_ADDR_DEF "#define NUTH_LLOCAL_UCAST \"$node_hash{nuth_lla}\"\n";
printf NUT_ADDR_DEF "#define NUTH_GLOBAL_UCAST \"$node_hash{nuth_ga}\"\n";

if ($node_hash{nut0_ga} eq $node_hash{nuth_ga}) {
	printf NUT_ADDR_DEF "#define NUT0H_GLOBAL_UCAST SAME\n";
}

printf NUT_ADDR_DEF "\n";

printf NUT_ADDR_DEF "#define NUTX_MAC_ADDR     \"$nutx_lla{mac}\"\n";
printf NUT_ADDR_DEF "#define NUTX_SOL_MAC_ADDR \"$nutx_sol{mac}\"\n";
printf NUT_ADDR_DEF "#define NUTX_LLOCAL_UCAST \"$node_hash{nutx_lla}\"\n";
printf NUT_ADDR_DEF "#define NUTX_GLOBAL_UCAST \"$node_hash{nutx_ga}\"\n";

printf NUT_ADDR_DEF "\n";

printf NUT_ADDR_DEF "#define NUTY_MAC_ADDR     \"$nuty_lla{mac}\"\n";
printf NUT_ADDR_DEF "#define NUTY_SOL_MAC_ADDR \"$nuty_sol{mac}\"\n";
printf NUT_ADDR_DEF "#define NUTY_LLOCAL_UCAST \"$node_hash{nuty_lla}\"\n";
printf NUT_ADDR_DEF "#define NUTY_GLOBAL_UCAST \"$node_hash{nuty_ga}\"\n";

printf NUT_ADDR_DEF "\n";

printf NUT_ADDR_DEF "#define NUTZ_MAC_ADDR     \"$nutz_lla{mac}\"\n";
printf NUT_ADDR_DEF "#define NUTZ_SOL_MAC_ADDR \"$nutz_sol{mac}\"\n";
printf NUT_ADDR_DEF "#define NUTZ_LLOCAL_UCAST \"$node_hash{nutz_lla}\"\n";
printf NUT_ADDR_DEF "#define NUTZ_GLOBAL_UCAST \"$node_hash{nutz_ga}\"\n";

printf NUT_ADDR_DEF "\n";

printf NUT_ADDR_DEF "#define NUT1_MAC_ADDR     \"$nut1_lla{mac}\"\n";
printf NUT_ADDR_DEF "#define NUT1_LLOCAL_UCAST \"$node_hash{nut1_lla}\"\n";
printf NUT_ADDR_DEF "#define NUT1_GLOBAL_UCAST \"$node_hash{nut1_ga}\"\n";

close(NUT_ADDR_DEF);

#------------------------------------------------------------------------------
open(ADDR_INI, "> mip6_mn_addr.ini");
close(ADDR_INI);

open(CN0_ADDR_DEF, "> mip6_mn_cn0_addr.def");
close(CN0_ADDR_DEF);

#------------------------------------------------------------------------------
open(R2_ADDR_DEF, "> mip6_mn_r2_addr.def");
close(R2_ADDR_DEF);

#------------------------------------------------------------------------------
my $err = 0;
open(SA_DEF, "> mip6_mn_sa.def");

if ($MN_CONF{TEST_FUNC_IKE} eq 'YES') {
	# dummy route for debug
	if ($MN_CONF{ENV_IKE_WO_IKE} == 1) {
		goto SAEND;
	}
	# end
	print SA_DEF "#define TEST_FUNC_IKE 1\n";
	goto SAEND;
}

#------------------------------------------------------------------------------
# SA1 MN -> HA0 TRANSPORT BU
if (($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} eq 'ALL') ||
    ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} eq 'MH')  ||
    ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} eq 'BU')) {
	print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_SPI $MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA1_MN_HA0_ESP $MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP}\n";
		print "              IPSEC_MANUAL_SA1_MN_HA0_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA1_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA1_MN_HA0_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA1_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA1_MN_HA0_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA1_MN_HA0_AH $MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH}\n";
		print "              IPSEC_MANUAL_SA1_MN_HA0_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA0_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA1_MN_HA0_PROTO $MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO}\n";
	print "              IPSEC_MANUAL_SA1_MN_HA0_PROTO { ALL | MH | BU | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA2 HA0 -> MN TRANSPORT BA
if (($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} eq 'ALL') ||
    ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} eq 'MH')  ||
    ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} eq 'BA')) {
	print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_SPI $MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA2_HA0_MN_ESP $MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA2_HA0_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA2_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA2_HA0_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA2_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA2_HA0_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA2_HA0_MN_AH $MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH}\n";
		print "              IPSEC_MANUAL_SA2_HA0_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA2_HA0_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA2_HA0_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA2_HA0_MN_PROTO { ALL | MH | BA | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA3 MN -> HA0 TUNNEL HOTI
if (($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} eq 'ALL') ||
    ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} eq 'MH')  ||
    ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} eq 'HOTI')) {
	print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_SPI $MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA3_MN_HA0_ESP $MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP}\n";
		print "              IPSEC_MANUAL_SA3_MN_HA0_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA3_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA3_MN_HA0_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA3_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA3_MN_HA0_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA3_MN_HA0_AH $MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH}\n";
		print "              IPSEC_MANUAL_SA3_MN_HA0_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA0_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA3_MN_HA0_PROTO $MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO}\n";
	print "              IPSEC_MANUAL_SA3_MN_HA0_PROTO { ALL | MH | HOTI | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA4 HA0 -> MN TUNNEL HOT
if (($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} eq 'ALL') ||
    ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} eq 'MH')  ||
    ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} eq 'HOT')) {
	print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_SPI $MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA4_HA0_MN_ESP $MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA4_HA0_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA4_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA4_HA0_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA4_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA4_HA0_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA4_HA0_MN_AH $MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH}\n";
		print "              IPSEC_MANUAL_SA4_HA0_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA4_HA0_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA4_HA0_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA4_HA0_MN_PROTO { ALL | MH | HOT | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA5 MN -> HA0 TRANSPORT MPS
if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} eq 'ALL') {
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_PROTO_ALL 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_SPI $MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_ESP_DES3CBC 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_ESP_DESCBC 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY}\"\n";
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_AH_HMACSHA1 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_AH_HMACMD5 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH_KEY}\"\n";
}
elsif (($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO} eq 'ICMP') ||
	   ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO} eq 'MPS')) {
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_SPI $MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA5_MN_HA0_ESP $MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP}\n";
		print "              IPSEC_MANUAL_SA5_MN_HA0_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_HA0_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_HA0_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA5_MN_HA0_AH $MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH}\n";
		print "              IPSEC_MANUAL_SA5_MN_HA0_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA0_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA5_MN_HA0_PROTO $MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO}\n";
	print "              IPSEC_MANUAL_SA5_MN_HA0_PROTO { ICMP | MPS | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA6 HA0 -> MN TRANSPORT MPA
if ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} eq 'ALL') {
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_PROTO_ALL 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_SPI $MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_ESP_DES3CBC 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_ESP_DESCBC 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY}\"\n";
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_AH_HMACSHA1 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_AH_HMACMD5 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH_KEY}\"\n";
}
elsif (($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO} eq 'ICMP')  ||
       ($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO} eq 'MPA')) {
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_SPI $MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA6_HA0_MN_ESP $MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA6_HA0_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_HA0_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_HA0_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA6_HA0_MN_AH $MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH}\n";
		print "              IPSEC_MANUAL_SA6_HA0_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA0_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA6_HA0_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA6_HA0_MN_PROTO { ICMP | MPA | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA7 MN -> HA0 TUNNEL X
if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} eq 'ALL') {
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_PROTO_ALL 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_SPI $MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_ESP_DES3CBC 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_ESP_DESCBC 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY}\"\n";
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_AH_HMACSHA1 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_AH_HMACMD5 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH_KEY}\"\n";
}
elsif ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO} eq 'X') {
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_SPI $MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA7_MN_HA0_ESP $MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP}\n";
		print "              IPSEC_MANUAL_SA7_MN_HA0_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA7_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA7_MN_HA0_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA7_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA7_MN_HA0_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA7_MN_HA0_AH $MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH}\n";
		print "              IPSEC_MANUAL_SA7_MN_HA0_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA0_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA7_MN_HA0_PROTO $MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO}\n";
	print "              IPSEC_MANUAL_SA7_MN_HA0_PROTO { X | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA8 HA0 -> MN TUNNEL X
if ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} eq 'ALL') {
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_PROTO_ALL 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_SPI $MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_ESP_DES3CBC 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_ESP_DESCBC 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY}\"\n";
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_AH_HMACSHA1 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_AH_HMACMD5 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH_KEY}\"\n";
}
elsif ($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO} eq 'X') {
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_SPI $MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY { string(24 characters) }\n";
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA8_HA0_MN_ESP $MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA8_HA0_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA8_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA8_HA0_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA8_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA8_HA0_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA8_HA0_MN_AH $MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH}\n";
		print "              IPSEC_MANUAL_SA8_HA0_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA0_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA8_HA0_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA8_HA0_MN_PROTO { X | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA9 MOBILE NETWORK PREFIX -> HA0 TUNNEL
if ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_PROTO} eq 'X') {
	print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_SPI $MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA9_MN_HA0_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA9_MN_HA0_ESP $MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_ESP}\n";
		print "              IPSEC_MANUAL_SA9_MN_HA0_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA9_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA9_MN_HA0_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA9_MN_HA0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA9_MN_HA0_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA9_MN_HA0_AH $MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_AH}\n";
		print "              IPSEC_MANUAL_SA9_MN_HA0_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA0_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA9_MN_HA0_PROTO $MN_CONF{IPSEC_MANUAL_SA9_MN_HA0_PROTO}\n";
	print "              IPSEC_MANUAL_SA9_MN_HA0_PROTO { X | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA10 Payload Packets HA0 -> MOBILE NETWORK PREFIX TUNNEL
if ($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_PROTO} eq 'X') {
	print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_SPI $MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY { string(24 characters) }\n";
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA10_HA0_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA10_HA0_MN_ESP $MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA10_HA0_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA10_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA10_HA0_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA10_HA0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA10_HA0_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA10_HA0_MN_AH $MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_AH}\n";
		print "              IPSEC_MANUAL_SA10_HA0_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA10_HA0_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA10_HA0_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA10_HA0_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA10_HA0_MN_PROTO { X | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA1 MN -> HA1 TRANSPORT BU
if (($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} eq 'ALL') ||
    ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} eq 'MH')  ||
    ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} eq 'BU')) {
	print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_SPI $MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA1_MN_HA1_ESP $MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP}\n";
		print "              IPSEC_MANUAL_SA1_MN_HA1_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA1_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA1_MN_HA1_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA1_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA1_MN_HA1_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA1_MN_HA1_AH $MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH}\n";
		print "              IPSEC_MANUAL_SA1_MN_HA1_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA1_MN_HA1_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA1_MN_HA1_PROTO $MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO}\n";
	print "              IPSEC_MANUAL_SA1_MN_HA1_PROTO { ALL | MH | BU | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA2 HA1 -> MN TRANSPORT BA
if (($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} eq 'ALL') ||
    ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} eq 'MH')  ||
    ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} eq 'BA')) {
	print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_SPI $MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA2_HA1_MN_ESP $MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA2_HA1_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA2_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA2_HA1_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA2_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA2_HA1_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA2_HA1_MN_AH $MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH}\n";
		print "              IPSEC_MANUAL_SA2_HA1_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA2_HA1_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA2_HA1_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA2_HA1_MN_PROTO { ALL | MH | BA | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA3 MN -> HA1 TUNNEL HOTI
if (($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} eq 'ALL') ||
    ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} eq 'MH')  ||
    ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} eq 'HOTI')) {
	print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_SPI $MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA3_MN_HA1_ESP $MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP}\n";
		print "              IPSEC_MANUAL_SA3_MN_HA1_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA3_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA3_MN_HA1_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA3_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA3_MN_HA1_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA3_MN_HA1_AH $MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH}\n";
		print "              IPSEC_MANUAL_SA3_MN_HA1_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA3_MN_HA1_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA3_MN_HA1_PROTO $MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO}\n";
	print "              IPSEC_MANUAL_SA3_MN_HA1_PROTO { ALL | MH | HOTI | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA4 HA1 -> MN TUNNEL HOT
if (($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} eq 'ALL') ||
    ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} eq 'MH')  ||
    ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} eq 'HOT')) {
	print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_SPI $MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA4_HA1_MN_ESP $MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA4_HA1_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA4_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA4_HA1_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA4_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA4_HA1_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA4_HA1_MN_AH $MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH}\n";
		print "              IPSEC_MANUAL_SA4_HA1_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA4_HA1_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA4_HA1_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA4_HA1_MN_PROTO { ALL | MH | HOT | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA5 MN -> HA1 TRANSPORT MPS
if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} eq 'ALL') {
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_PROTO_ALL 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_SPI $MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_ESP_DES3CBC 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_ESP_DESCBC 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_ESP_KEY}\"\n";
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_AH_HMACSHA1 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_AH_HMACMD5 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_AH_KEY}\"\n";
}
elsif (($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO} eq 'ICMP') ||
       ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO} eq 'MPS')) {
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_SPI $MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_HA1_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA5_MN_HA1_ESP $MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_ESP}\n";
		print "              IPSEC_MANUAL_SA5_MN_HA1_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_HA1_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_HA1_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA5_MN_HA1_AH $MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_AH}\n";
		print "              IPSEC_MANUAL_SA5_MN_HA1_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_HA1_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA5_MN_HA1_PROTO $MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO}\n";
	print "              IPSEC_MANUAL_SA5_MN_HA1_PROTO { ICMP | MPS | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA6 HA1 -> MN TRANSPORT MPA
if ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} eq 'ALL') {
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_PROTO_ALL 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_SPI $MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_ESP_DES3CBC 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_ESP_DESCBC 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_ESP_KEY}\"\n";
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_AH_HMACSHA1 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_AH_HMACMD5 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_AH_KEY}\"\n";
}
elsif (($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO} eq 'ICMP')  ||
       ($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO} eq 'MPA')) {
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_SPI $MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_HA1_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA6_HA1_MN_ESP $MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA6_HA1_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_HA1_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_HA1_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA6_HA1_MN_AH $MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_AH}\n";
		print "              IPSEC_MANUAL_SA6_HA1_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA6_HA1_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA6_HA1_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA6_HA1_MN_PROTO { ICMP | MPA | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA7 MN -> HA1 TUNNEL X
if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} eq 'ALL') {
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_PROTO_ALL 1";
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_SPI $MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_ESP_DES3CBC 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_ESP_DESCBC 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_ESP_KEY}\"\n";
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_AH_HMACSHA1 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_AH_HMACMD5 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_AH_KEY}\"\n";
}
elsif ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO} eq 'X') {
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_SPI $MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA7_MN_HA1_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA7_MN_HA1_ESP $MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_ESP}\n";
		print "              IPSEC_MANUAL_SA7_MN_HA1_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA7_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA7_MN_HA1_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA7_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA7_MN_HA1_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA7_MN_HA1_AH $MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_AH}\n";
		print "              IPSEC_MANUAL_SA7_MN_HA1_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA7_MN_HA1_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA7_MN_HA1_PROTO $MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO}\n";
	print "              IPSEC_MANUAL_SA7_MN_HA1_PROTO { X | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA8 HA1 -> MN TUNNEL X
if ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} eq 'ALL') {
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_PROTO_ALL 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_SPI $MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_ESP_DES3CBC 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_ESP_DESCBC 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_ESP_KEY}\"\n";
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_AH_HMACSHA1 1\n";
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_AH_HMACMD5 1\n";
	}
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_AH_KEY}\"\n";
}
elsif ($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO} eq 'X') {
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_SPI $MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA8_HA1_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA8_HA1_MN_ESP $MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA8_HA1_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA8_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA8_HA1_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA8_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA8_HA1_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA8_HA1_MN_AH $MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_AH}\n";
		print "              IPSEC_MANUAL_SA8_HA1_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA8_HA1_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA8_HA1_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA8_HA1_MN_PROTO { X | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA9 MOBILE NETWORK PREFIX -> HA1 TUNNEL
if ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_PROTO} eq 'X') {
	print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_SPI $MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA9_MN_HA1_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA9_MN_HA1_ESP $MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_ESP}\n";
		print "              IPSEC_MANUAL_SA9_MN_HA1_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA9_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA9_MN_HA1_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA9_MN_HA1_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA9_MN_HA1_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA9_MN_HA1_AH $MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_AH}\n";
		print "              IPSEC_MANUAL_SA9_MN_HA1_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA9_MN_HA1_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA9_MN_HA1_PROTO $MN_CONF{IPSEC_MANUAL_SA9_MN_HA1_PROTO}\n";
	print "              IPSEC_MANUAL_SA9_MN_HA1_PROTO { X | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA10 Payload Packets HA1 -> MOBILE NETWORK PREFIX TUNNEL
if ($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_PROTO} eq 'X') {
	print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_SPI $MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA10_HA1_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA10_HA1_MN_ESP $MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA10_HA1_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA10_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA10_HA1_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA10_HA1_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA10_HA1_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA10_HA1_MN_AH $MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_AH}\n";
		print "              IPSEC_MANUAL_SA10_HA1_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA10_HA1_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA10_HA1_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA10_HA1_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA10_HA1_MN_PROTO { X | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA5 MN -> CN0 TRANSPORT MPS
if ($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_PROTO} eq 'ICMP') {
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_SPI $MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_CN0_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA5_MN_CN0_ESP $MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_ESP}\n";
		print "              IPSEC_MANUAL_SA5_MN_CN0_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_CN0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_CN0_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA5_MN_CN0_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA5_MN_CN0_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA5_MN_CN0_AH $MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_AH}\n";
		print "              IPSEC_MANUAL_SA5_MN_CN0_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA5_MN_CN0_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA5_MN_CN0_PROTO $MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_PROTO}\n";
	print "              IPSEC_MANUAL_SA5_MN_CN0_PROTO { ICMP | NONE }\n";
	$err ++;
}

#------------------------------------------------------------------------------
# SA6 CN0 -> MN TRANSPORT MPA
if ($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_PROTO} eq 'ICMP') {
	print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_PROTO_" . "$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_PROTO} 1\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_SPI $MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_SPI}\n";
	print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_ALGO_ESP 1\n";
	if ($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP} eq 'DES3CBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_ESP_DES3CBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY}) == 24) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY { string(24 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP} eq 'DESCBC') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_ESP_DESCBC 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY}) == 8) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_CN0_MN_ESP_KEY { string(8 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA6_CN0_MN_ESP $MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_ESP}\n";
		print "              IPSEC_MANUAL_SA6_CN0_MN_ESP { DES3CBC | DESCBC }\n";
		$err ++;
	}
	if ($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH} eq 'HMACSHA1') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_AH_HMACSHA1 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH_KEY}) == 20) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_CN0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_CN0_MN_AH_KEY { string(20 characters) }\n";
			$err ++;
		}
	}
	elsif ($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH} eq 'HMACMD5') {
		print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_AH_HMACMD5 1\n";
		if (length($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH_KEY}) == 16) {
			print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH_KEY}\"\n";
		}
		else {
			print "Out of range: IPSEC_MANUAL_SA6_CN0_MN_AH_KEY \"$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH_KEY}\"\n";
			print "              IPSEC_MANUAL_SA6_CN0_MN_AH_KEY { string(16 characters) }\n";
			$err ++;
		}
	}
	else {
		print "Out of range: IPSEC_MANUAL_SA6_CN0_MN_AH $MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_AH}\n";
		print "              IPSEC_MANUAL_SA6_CN0_MN_AH { HMACSHA1 | HMACMD5 }\n";
		$err ++;
	}
}
elsif ($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_PROTO} eq 'NONE') {
	print SA_DEF "#define IPSEC_MANUAL_SA6_CN0_MN_PROTO_NONE 1\n";
}
else {
	print "Out of range: IPSEC_MANUAL_SA6_CN0_MN_PROTO $MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_PROTO}\n";
	print "              IPSEC_MANUAL_SA6_CN0_MN_PROTO { ICMP | NONE }\n";
	$err ++;
}

SAEND:

close(SA_DEF);

if ($err > 0) {
	exit;
}

# End of File
