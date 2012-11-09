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
package mip6_mn_ike;

# EXPORT PACKAGE
use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	$i_isakmp_ha0
	$i_sa12_ha0
	$i_sa34_ha0
	$i_sa56_ha0
	$i_sa78_ha0
	$i_isakmp_ha1
	$i_sa12_ha1
	$i_sa34_ha1
	$i_sa56_ha1
	$i_sa78_ha1
	$UP_SA_CHECKER
	$SA_SET_FLAG
	$DMMYISAKMP
	$DMMY12
	$DMMY34
	$DMMY56
	$DMMY78
	ike_module_init
	ike_module_term
	init_ike
	term_ike
	set_responder
	up_isakmp
	up_sa
	chg_endpoint
	check_sa
	set_sa
	set_isakmpinfo
	set_sainfo12
	set_sainfo34
	set_sainfo56
	set_sainfo78
	set_debug
	init_mn_ike
	term_mn_ike
);

# INPORT PACKAGE
use V6evalTool;
use IKEapi;
use mip6_mn_config;
use mip6_mn_get;

# GLOBAL VARIABLE DEFINITION
#$i_isakmp_ha0;
#$i_sa12_ha0;
#$i_sa34_ha0;
#$i_sa56_ha0;
#$i_sa78_ha0;
#$i_isakmp_ha1;
#$i_sa12_ha1;
#$i_sa34_ha1;
#$i_sa56_ha1;
#$i_sa78_ha1;

$UP_SA_CHECKER = '';
$SA_SET_FLAG = 0;

$DMMYISAKMP = 0;
$DMMY12 = 0;
$DMMY34 = 0;
$DMMY56 = 0;
$DMMY78 = 0;

# SUBROUTINE DECLARATION
sub ike_module_init();
sub ike_module_term();
sub init_ike();
sub term_ike();
sub set_responder($);
sub up_isakmp($);
sub up_sa($);
sub chg_endpoint(@);
sub check_sa($);

sub init_mn_ike();
sub term_mn_ike();
sub mip6ikeSetSPD(@);
sub mip6ikeResetSPD(@);
sub mip6ikeSetSA(@);
sub mip6ikeResetSA(@);
sub mip6ikeEnable();
sub mip6ikeExitNS();
sub mip6ikeExitFail();

# dmmy for test
sub set_sa();
sub set_isakmpinfo();
sub set_sainfo12();
sub set_sainfo34();
sub set_sainfo56();
sub set_sainfo78();
sub set_debug(@);

# LOCAL VARIABLE DEFINITION
#my %p_isakmp_ha0 = ();
#my %p_sa12_ha0   = ();
#my %p_sa34_ha0   = ();
#my %p_sa56_ha0   = ();
#my %p_sa78_ha0   = ();
#my %p_isakmp_ha1 = ();
#my %p_sa12_ha1   = ();
#my %p_sa34_ha1   = ();
#my %p_sa56_ha1   = ();
#my %p_sa78_ha1   = ();

#my @responder_link0 = ();
#my @responder_linkx = ();
#my @responder_linky = ();

my @sas = ();
my $sa_num = 0;
my $sa_cnt = 0;

my %isakmp_enc_alg = (
	'DES3CBC' => 'TI_ATTR_ENC_ALG_3DES',
	'DESCBC'  => 'TI_ATTR_ENC_ALG_DES',
);

my %isakmp_hash_alg = (
	'HMACSHA1' => 'TI_ATTR_HASH_ALG_SHA',
	'HMACMD5'  => 'TI_ATTR_HASH_ALG_MD5',
);

my %isakmp_grp_desc = (
	'GROUP1' => 'TI_ATTR_GRP_DESC_MODP768',
	'GROUP2' => 'TI_ATTR_GRP_DESC_MODP1024',
);

my %isakmp_tn_id_type = (
	'FQDN'     => 'TI_ID_FQDN',
	'USERFQDN' => 'TI_ID_USER_FQDN',
	'V6ADDR'   => 'TI_ID_IPV6_ADDR',
);

my %isakmp_nut_id_type = (
	'FQDN'     => 'TI_ID_FQDN',
	'USERFQDN' => 'TI_ID_USER_FQDN',
	'V6ADDR'   => 'TI_ID_IPV6_ADDR',
);

my %id_proto = (
	'ALL'  => 0,
	'MH'   => 135,
	'ICMP' => 58,
	'X'    => 0,
);

my %sa_esp_alg = (
	'DES3CBC' => 'TI_ESP_ALG_3DES',
	'DESCBC'  => 'TI_ESP_ALG_DES',
);

my %sa_auth = (
	'HMACSHA1' => 'TI_ATTR_AUTH_HMAC_SHA',
	'HMACMD5'  => 'TI_ATTR_AUTH_HMAC_MD5',
);

# not yet use
#my %sa_grp_desc = (
#	'GROUP1' => 'TI_ATTR_GRP_DESC_MODP768',
#	'GROUP2' => 'TI_ATTR_GRP_DESC_MODP1024',
#);

$remote_debug = "";



# SUBROUTINE
#-----------------------------------------------------------------------------#
# ike_module_init()
#-----------------------------------------------------------------------------#
sub ike_module_init() {
	# for IKEv1 module
	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		IKEInit('MN',[ERR,INF1,SEQ,JDG]);
	#	IKEInit('MN',[ERR,WARN,INF1,INF2,DBG,DBG6,DBG9,SEQ,JDG]);
	}
	else {
		IKEInit('MN',[ERR,INF1,SEQ,JDG]);
	#	IKEInit('MN',[ERR,WARN,INF1,INF2,DBG,DBG6,DBG9,SEQ,JDG]);
	}
	# end
}

#-----------------------------------------------------------------------------#
# ike_module_term()
#-----------------------------------------------------------------------------#
sub ike_module_term() {
	IKEEnd();
}

#-----------------------------------------------------------------------------#
# init_ike()
#   read "config.txt" and fix %MN_CONF.
#-----------------------------------------------------------------------------#
sub init_ike() {
my @saprof;

$UP_SA_CHECKER = '';
$SA_SET_FLAG = 0;
$sa_num = 0;
$sa_cnt = 0;

my %p_isakmp = (
	'ID'                  => 'ISAKMP',
	'PHASE'               => 1,
	'ETYPE'               => 'TI_ETYPE_AGG',
	'TN_IP_ADDR'          => "$node_hash{ha0_ga}",
	'NUT_IP_ADDR'         => "$node_hash{nuth_ga}",
	'TN_ETHER_ADDR'       => "$ha0_ga{mac}",
	'NUT_ETHER_ADDR'      => "$nuth_ga{mac}",
	'ATTR_ENC_ALG'        => 'TI_ATTR_ENC_ALG_3DES',
	'ATTR_HASH_ALG'       => 'TI_ATTR_HASH_ALG_SHA',
	'ATTR_AUTH_METHOD'    => 'TI_ATTR_AUTH_METHOD_PSKEY',
	'ATTR_PH1_GRP_DESC'   => 'TI_ATTR_GRP_DESC_MODP768',
#	'ATTR_PH1_SA_LD_TYPE' => 'TI_ATTR_SA_LD_TYPE_SEC',
#	'ATTR_PH1_SA_LD'      => 0,
	'TN_ID_TYPE'          => 'TI_ID_FQDN',
	'TN_ID'               => 'v6pc.jp',
	'NUT_ID_TYPE'         => 'TI_ID_FQDN',
	'NUT_ID'              => 'v6pc.jp',
	'PSK'                 => 'PSkey',
);

my %p_sa = (
	'ID'                  => 'SA',
	'PHASE'               => 2,
	'ETYPE'               => 'TI_ETYPE_QUICK',
	'ISAKMP_SA_ID'        => 'ISAKMP',
	'ATTR_ENC_MODE'       => 'TI_ATTR_ENC_MODE_TRNS',
	'TN_ID_ADDR'          => "$node_hash{ha0_ga}",
	'TN_ID_PORT'          => 0,
	'NUT_ID_ADDR'         => "$node_hash{nuth_ga}",
	'NUT_ID_PORT'         => 0,
	'ID_PROTO'            => 135,
	'PROTO'               => 'TI_PROTO_IPSEC_ESP',
	'ESP_ALG'             => 'TI_ESP_ALG_3DES',
	'ATTR_AUTH'           => 'TI_ATTR_AUTH_HMAC_SHA',
#	'ATTR_PH2_SA_LD_TYPE' => 'TI_ATTR_SA_LD_TYPE_SEC',
#	'ATTR_PH2_SA_LD'      => 0,
);

	#-----------------------------------------
	# ISAKMP SA (MN<->HA0)
	#-----------------------------------------
	my $sa_id     = 'isakmp_ha0';
	%p_isakmp_ha0 = %p_isakmp;
	$p_isakmp_ha0{'ID'}                = $sa_id;
	$p_isakmp_ha0{'ATTR_ENC_ALG'}      = $isakmp_enc_alg{$MN_CONF{'ISAKMP_MN_HA0_ENC_ALG'}};
	$p_isakmp_ha0{'ATTR_HASH_ALG'}     = $isakmp_hash_alg{$MN_CONF{'ISAKMP_MN_HA0_HASH_ALG'}};
	$p_isakmp_ha0{'ATTR_PH1_GRP_DESC'} = $isakmp_grp_desc{$MN_CONF{'ISAKMP_MN_HA0_GRP_DESC'}};
	$p_isakmp_ha0{'TN_ID_TYPE'}        = $isakmp_tn_id_type{$MN_CONF{'ISAKMP_MN_HA0_TN_ID_TYPE'}};
	$p_isakmp_ha0{'TN_ID'}             = $MN_CONF{'ISAKMP_MN_HA0_TN_ID'};
	$p_isakmp_ha0{'NUT_ID_TYPE'}       = $isakmp_nut_id_type{$MN_CONF{'ISAKMP_MN_HA0_NUT_ID_TYPE'}};
	$p_isakmp_ha0{'NUT_ID'}            = $MN_CONF{'ISAKMP_MN_HA0_NUT_ID'};
	$p_isakmp_ha0{'PSK'}               = $MN_CONF{'ISAKMP_MN_HA0_PSK'};

	push @sas, $sa_id;
	push @saprof, {%p_isakmp_ha0};
	push @responder_link0, { SaID =>'isakmp_ha0_0' , Action => \&up_isakmp, Arg => $sa_id};
	push @responder_linkx, { SaID =>'isakmp_ha0_x' , Action => \&up_isakmp, Arg => $sa_id};
	push @responder_linky, { SaID =>'isakmp_ha0_y' , Action => \&up_isakmp, Arg => $sa_id};
#	push @responder_p2all, { SaID =>'isakmp_ha0_0' , Action => \&up_isakmp, Arg => $sa_id};
#	push @responder_p2all, { SaID =>'isakmp_ha0_x' , Action => \&up_isakmp, Arg => $sa_id};
#	push @responder_p2all, { SaID =>'isakmp_ha0_y' , Action => \&up_isakmp, Arg => $sa_id};

	#-----------------------------------------
	# IPsec SA1/SA2 (MN<->HA0)
	#-----------------------------------------
	if (($MN_CONF{'IPSEC_IKE_SA12_MN_HA0_ID_PROTO'} eq 'MH') ||
	    ($MN_CONF{'IPSEC_IKE_SA12_MN_HA0_ID_PROTO'} eq 'ALL')) {
		$sa_id      = 'sa12_ha0';
		%p_sa12_ha0 = %p_sa;
		$p_sa12_ha0{'ID'}           = $sa_id;
		$p_sa12_ha0{'ISAKMP_SA_ID'} = $p_isakmp_ha0{'ID'};
		$p_sa12_ha0{'ID_PROTO'}     = $id_proto{$MN_CONF{'IPSEC_IKE_SA12_MN_HA0_ID_PROTO'}};
		$p_sa12_ha0{'ESP_ALG'}      = $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA12_MN_HA0_ESP_ALG'}};
		$p_sa12_ha0{'ATTR_AUTH'}    = $sa_auth{$MN_CONF{'IPSEC_IKE_SA12_MN_HA0_AUTH'}};

		push @sas, $sa_id;
		push @saprof, {%p_sa12_ha0};
#		push @responder_link0, { SaID =>'sa12_ha0_0' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linkx, { SaID =>'sa12_ha0_x' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linky, { SaID =>'sa12_ha0_y' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa12_ha0_0' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa12_ha0_x' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa12_ha0_y' , Action => \&up_sa, Arg => $sa_id};
		$sa_num ++;
	}

	#-----------------------------------------
	# IPsec SA3/SA4 (MN<->HA0)
	#-----------------------------------------
	if (($MN_CONF{'IPSEC_IKE_SA34_MN_HA0_ID_PROTO'} eq 'MH') ||
	    ($MN_CONF{'IPSEC_IKE_SA34_MN_HA0_ID_PROTO'} eq 'ALL')) {
		$sa_id      = 'sa34_ha0';
		%p_sa34_ha0 = %p_sa;
		$p_sa34_ha0{'ID'}            = $sa_id;
		$p_sa34_ha0{'ISAKMP_SA_ID'}  = $p_isakmp_ha0{'ID'};
		$p_sa34_ha0{'ATTR_ENC_MODE'} = 'TI_ATTR_ENC_MODE_TUNNEL';
		$p_sa34_ha0{'TN_ID_ADDR'}    = '0::0/0';
		$p_sa34_ha0{'ID_PROTO'}      = $id_proto{$MN_CONF{'IPSEC_IKE_SA34_MN_HA0_ID_PROTO'}};
		$p_sa34_ha0{'ESP_ALG'}       = $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA34_MN_HA0_ESP_ALG'}};
		$p_sa34_ha0{'ATTR_AUTH'}     = $sa_auth{$MN_CONF{'IPSEC_IKE_SA34_MN_HA0_AUTH'}};

		push @sas, $sa_id;
		push @saprof, {%p_sa34_ha0};
#		push @responder_link0, { SaID =>'sa34_ha0_0' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linkx, { SaID =>'sa34_ha0_x' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linky, { SaID =>'sa34_ha0_y' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa34_ha0_0' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa34_ha0_x' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa34_ha0_y' , Action => \&up_sa, Arg => $sa_id};
		$sa_num ++;
	}

	#-----------------------------------------
	# IPsec SA5/SA6 (MN<->HA0)
	#-----------------------------------------
	if (($MN_CONF{'IPSEC_IKE_SA12_MN_HA0_ID_PROTO'} ne 'ALL') &&
	    ($MN_CONF{'IPSEC_IKE_SA56_MN_HA0_ID_PROTO'} eq 'ICMP')) {
		$sa_id = 'sa56_ha0';
		%p_sa56_ha0 = %p_sa;
		$p_sa56_ha0{'ID'}           = $sa_id;
		$p_sa56_ha0{'ISAKMP_SA_ID'} = $p_isakmp_ha0{'ID'};
		$p_sa56_ha0{'ID_PROTO'}     = $id_proto{$MN_CONF{'IPSEC_IKE_SA56_MN_HA0_ID_PROTO'}};
		$p_sa56_ha0{'ESP_ALG'}      = $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA56_MN_HA0_ESP_ALG'}};
		$p_sa56_ha0{'ATTR_AUTH'}    = $sa_auth{$MN_CONF{'IPSEC_IKE_SA56_MN_HA0_AUTH'}};

		push @sas, $sa_id;
		push @saprof, {%p_sa56_ha0};
#		push @responder_link0, { SaID =>'sa56_ha0_0' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linkx, { SaID =>'sa56_ha0_x' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linky, { SaID =>'sa56_ha0_y' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa56_ha0_0' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa56_ha0_x' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa56_ha0_y' , Action => \&up_sa, Arg => $sa_id};
		$sa_num ++;
	}

	#-----------------------------------------
	# IPsec SA7/SA8 (MN<->HA0)
	#-----------------------------------------
	if (($MN_CONF{'IPSEC_IKE_SA34_MN_HA0_ID_PROTO'} ne 'ALL') &&
	    ($MN_CONF{'IPSEC_IKE_SA78_MN_HA0_ID_PROTO'} eq 'X')) {
		$sa_id      = 'sa78_ha0';
		%p_sa78_ha0 = %p_sa;
		$p_sa78_ha0{'ID'}            = $sa_id;
		$p_sa78_ha0{'ISAKMP_SA_ID'}  = $p_isakmp_ha0{'ID'};
		$p_sa78_ha0{'ATTR_ENC_MODE'} = 'TI_ATTR_ENC_MODE_TUNNEL';
		$p_sa78_ha0{'TN_ID_ADDR'}    = '0::0/0';
		$p_sa78_ha0{'ID_PROTO'}      = $id_proto{$MN_CONF{'IPSEC_IKE_SA78_MN_HA0_ID_PROTO'}};
		$p_sa78_ha0{'ESP_ALG'}       = $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA78_MN_HA0_ESP_ALG'}};
		$p_sa78_ha0{'ATTR_AUTH'}     = $sa_auth{$MN_CONF{'IPSEC_IKE_SA78_MN_HA0_AUTH'}};

		push @sas, $sa_id;
		push @saprof, {%p_sa78_ha0};
#		push @responder_link0, { SaID =>'sa78_ha0_0' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linkx, { SaID =>'sa78_ha0_x' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linky, { SaID =>'sa78_ha0_y' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa78_ha0_0' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa78_ha0_x' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa78_ha0_y' , Action => \&up_sa, Arg => $sa_id};
		$sa_num ++;
	}

	#-----------------------------------------
	# ISAKMP SA (MN<->HA1)
	#-----------------------------------------
	if ($MN_CONF{'ENV_HA1_SET'} eq 'YES') {
		$sa_id        = 'isakmp_ha1';
		%p_isakmp_ha1 = %p_isakmp;
		$p_isakmp_ha1{'ID'}                = $sa_id;
		$p_isakmp_ha1{'TN_IP_ADDR'}        = "$node_hash{'ha1_ga'}";
		$p_isakmp_ha1{'TN_ETHER_ADDR'}     = "$ha1_ga{mac}";
		$p_isakmp_ha1{'ATTR_ENC_ALG'}      = $isakmp_enc_alg{$MN_CONF{'ISAKMP_MN_HA1_ENC_ALG'}};
		$p_isakmp_ha1{'ATTR_HASH_ALG'}     = $isakmp_hash_alg{$MN_CONF{'ISAKMP_MN_HA1_HASH_ALG'}};
		$p_isakmp_ha1{'ATTR_PH1_GRP_DESC'} = $isakmp_grp_desc{$MN_CONF{'ISAKMP_MN_HA1_GRP_DESC'}};
		$p_isakmp_ha1{'TN_ID_TYPE'}        = $isakmp_tn_id_type{$MN_CONF{'ISAKMP_MN_HA1_TN_ID_TYPE'}};
		$p_isakmp_ha1{'TN_ID'}             = $MN_CONF{'ISAKMP_MN_HA1_TN_ID'};
		$p_isakmp_ha1{'NUT_ID_TYPE'}       = $isakmp_nut_id_type{$MN_CONF{'ISAKMP_MN_HA1_NUT_ID_TYPE'}};
		$p_isakmp_ha1{'NUT_ID'}            = $MN_CONF{'ISAKMP_MN_HA1_NUT_ID'};
		$p_isakmp_ha1{'PSK'}               = $MN_CONF{'ISAKMP_MN_HA1_PSK'};

		push @saprof, {%p_isakmp_ha1};
		push @responder_link0, { SaID =>'isakmp_ha1_0' , Action => \&up_isakmp, Arg => $sa_id};
		push @responder_linkx, { SaID =>'isakmp_ha1_x' , Action => \&up_isakmp, Arg => $sa_id};
		push @responder_linky, { SaID =>'isakmp_ha1_y' , Action => \&up_isakmp, Arg => $sa_id};
	}

	#-----------------------------------------
	# IPsec SA1/SA2 (MN<->HA1)
	#-----------------------------------------
	if (($MN_CONF{'ENV_HA1_SET'} eq 'YES') &&
	    (($MN_CONF{'IPSEC_IKE_SA12_MN_HA1_ID_PROTO'} eq 'MH') ||
	     ($MN_CONF{'IPSEC_IKE_SA12_MN_HA1_ID_PROTO'} eq 'ALL'))) {
		$sa_id      = 'sa12_ha1';
		%p_sa12_ha1 = %p_sa;
		$p_sa12_ha1{'ID'}           = $sa_id;
		$p_sa12_ha1{'ISAKMP_SA_ID'} = $p_isakmp_ha1{'ID'};
		$p_sa12_ha1{'TN_ID_ADDR'}   = $node_hash{'ha1_ga'};
		$p_sa12_ha1{'ID_PROTO'}     = $id_proto{$MN_CONF{'IPSEC_IKE_SA12_MN_HA1_ID_PROTO'}};
		$p_sa12_ha1{'ESP_ALG'}      = $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA12_MN_HA1_ESP_ALG'}};
		$p_sa12_ha1{'ATTR_AUTH'}    = $sa_auth{$MN_CONF{'IPSEC_IKE_SA12_MN_HA1_AUTH'}};

		push @saprof, {%p_sa12_ha1};
#		push @responder_link0, { SaID =>'sa12_ha1_0' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linkx, { SaID =>'sa12_ha1_x' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linky, { SaID =>'sa12_ha1_y' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa12_ha1_0' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa12_ha1_x' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa12_ha1_y' , Action => \&up_sa, Arg => $sa_id};
	}

	#-----------------------------------------
	# IPsec SA3/SA4 (MN<->HA1)
	#-----------------------------------------
	if (($MN_CONF{'ENV_HA1_SET'} eq 'YES') &&
	    (($MN_CONF{'IPSEC_IKE_SA34_MN_HA1_ID_PROTO'} eq 'MH') ||
	     ($MN_CONF{'IPSEC_IKE_SA34_MN_HA1_ID_PROTO'} eq 'ALL'))) {
		$sa_id      = 'sa34_ha1';
		%p_sa34_ha1 =  %p_sa;
		$p_sa34_ha1{'ID'}            = $sa_id;
		$p_sa34_ha1{'ISAKMP_SA_ID'}  = $p_isakmp_ha1{'ID'};
		$p_sa34_ha1{'ATTR_ENC_MODE'} = 'TI_ATTR_ENC_MODE_TUNNEL';
		$p_sa34_ha1{'TN_ID_ADDR'}    = '0::0/0';
		$p_sa34_ha1{'ID_PROTO'}      = $id_proto{$MN_CONF{'IPSEC_IKE_SA34_MN_HA1_ID_PROTO'}};
		$p_sa34_ha1{'ESP_ALG'}       = $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA34_MN_HA1_ESP_ALG'}};
		$p_sa34_ha1{'ATTR_AUTH'}     = $sa_auth{$MN_CONF{'IPSEC_IKE_SA34_MN_HA1_AUTH'}};

		push @saprof, {%p_sa34_ha1};
#		push @responder_link0, { SaID =>'sa34_ha1_0' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linkx, { SaID =>'sa34_ha1_x' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linky, { SaID =>'sa34_ha1_y' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa34_ha1_0' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa34_ha1_x' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa34_ha1_y' , Action => \&up_sa, Arg => $sa_id};
	}

	#-----------------------------------------
	# IPsec SA5/SA6 (MN<->HA1)
	#-----------------------------------------
	if (($MN_CONF{'ENV_HA1_SET'} eq 'YES') &&
	    (($MN_CONF{'IPSEC_IKE_SA12_MN_HA1_ID_PROTO'} ne 'ALL') &&
	     ($MN_CONF{'IPSEC_IKE_SA56_MN_HA1_ID_PROTO'} eq 'ICMP'))) {
		$sa_id      = 'sa56_ha1';
		%p_sa56_ha1 = %p_sa;
		$p_sa56_ha1{'ID'}           = $sa_id;
		$p_sa56_ha1{'ISAKMP_SA_ID'} = $p_isakmp_ha1{'ID'};
		$p_sa12_ha1{'TN_ID_ADDR'}   = $node_hash{'ha1_ga'};
		$p_sa56_ha1{'ID_PROTO'}     = $id_proto{$MN_CONF{'IPSEC_IKE_SA56_MN_HA1_ID_PROTO'}};
		$p_sa56_ha1{'ESP_ALG'}      = $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA56_MN_HA1_ESP_ALG'}};
		$p_sa56_ha1{'ATTR_AUTH'}    = $sa_auth{$MN_CONF{'IPSEC_IKE_SA56_MN_HA1_AUTH'}};

		push @saprof, {%p_sa56_ha1};
#		push @responder_link0, { SaID =>'sa56_ha1_0' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linkx, { SaID =>'sa56_ha1_x' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linky, { SaID =>'sa56_ha1_y' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa56_ha1_0' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa56_ha1_x' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa56_ha1_y' , Action => \&up_sa, Arg => $sa_id};
	}

	#-----------------------------------------
	# IPsec SA7/SA8 (MN<->HA1)
	#-----------------------------------------
	if (($MN_CONF{'ENV_HA1_SET'} eq 'YES') &&
	    (($MN_CONF{'IPSEC_IKE_SA34_MN_HA1_ID_PROTO'} ne 'ALL') &&
	     ($MN_CONF{'IPSEC_IKE_SA56_MN_HA1_ID_PROTO'} eq 'X'))) {
		$sa_id      = 'sa78_ha1';
		%p_sa78_ha1 = %p_sa;
		$p_sa78_ha1{'ID'}            = $sa_id;
		$p_sa78_ha1{'ISAKMP_SA_ID'}  = $p_isakmp_ha1{'ID'};
		$p_sa78_ha1{'ATTR_ENC_MODE'} = 'TI_ATTR_ENC_MODE_TUNNEL';
		$p_sa78_ha1{'TN_ID_ADDR'}    = '0::0/0';
		$p_sa78_ha1{'ID_PROTO'}      = $id_proto{$MN_CONF{'IPSEC_IKE_SA78_MN_HA1_ID_PROTO'}};
		$p_sa78_ha1{'ESP_ALG'}       = $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA78_MN_HA1_ESP_ALG'}};
		$p_sa78_ha1{'ATTR_AUTH'}     = $sa_auth{$MN_CONF{'IPSEC_IKE_SA78_MN_HA1_AUTH'}};

		push @saprof, {%p_sa78_ha1};
#		push @responder_link0, { SaID =>'sa78_ha1_0' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linkx, { SaID =>'sa78_ha1_x' , Action => \&up_sa, Arg => $sa_id};
#		push @responder_linky, { SaID =>'sa78_ha1_y' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa78_ha1_0' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa78_ha1_x' , Action => \&up_sa, Arg => $sa_id};
		push @responder_p2all, { SaID =>'sa78_ha1_y' , Action => \&up_sa, Arg => $sa_id};
	}

	push @responder_link0, @responder_p2all;
	push @responder_linkx, @responder_p2all;
	push @responder_linky, @responder_p2all;

	# set SA PROFILE ORIG(no use)
	$rtn = IKESetSaProf(@saprof);
	if ($rtn ne '') {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">init_ike: IKESetSaProf error($rtn)</FONT></B><BR>");
		exit $V6evalTool::exitFatal;
	}

	# set SA PROFILE each link
	IKECopySaProf('isakmp_ha0', '_0', {'NUT_IP_ADDR' => "$node_hash{nuth_ga}"});
	IKECopySaProf('isakmp_ha0', '_x', {'NUT_IP_ADDR' => "$node_hash{nutx_ga}", 'TN_ETHER_ADDR' => "$r1_lla{mac}"});
	IKECopySaProf('isakmp_ha0', '_y', {'NUT_IP_ADDR' => "$node_hash{nuty_ga}", 'TN_ETHER_ADDR' => "$r2_lla{mac}"});

	if ($MN_CONF{'ENV_HA1_SET'} eq 'YES') {
		IKECopySaProf('isakmp_ha1', '_0', {'NUT_IP_ADDR' => "$node_hash{nuth_ga}"});
		IKECopySaProf('isakmp_ha1', '_x', {'NUT_IP_ADDR' => "$node_hash{nutx_ga}", 'TN_ETHER_ADDR' => "$r1_lla{mac}"});
		IKECopySaProf('isakmp_ha1', '_y', {'NUT_IP_ADDR' => "$node_hash{nuty_ga}", 'TN_ETHER_ADDR' => "$r2_lla{mac}"});
	}

	return;
}

#-----------------------------------------------------------------------------#
# term_ike()
#-----------------------------------------------------------------------------#
sub term_ike() {

#	IKEEnd();
}

#-----------------------------------------------------------------------------#
# set_responder()
#-----------------------------------------------------------------------------#
sub set_responder($) {
	my ($link) = @_;

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">set_responder: link=$link</FONT></B><BR>");
	}
	# end

	if ($link eq 'Link0') {
		IKESetResponder(@responder_link0);
	}
	elsif ($link eq 'LinkX'){
		IKESetResponder(@responder_linkx);
	}
	elsif ($link eq 'LinkY'){
		IKESetResponder(@responder_linky);
	}
	else {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">set_responder: link=$link</FONT></B><BR>");
		exit $V6evalTool::exitFatal;
	}

	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		PrintVal($IKEapi::IKESAEnable);
	}
	return;
}

#-----------------------------------------------------------------------------#
# up_isakmp() 
#-----------------------------------------------------------------------------#
sub up_isakmp($) {
my ($arg) = @_;

	my $sa_id = $arg->{'UserArgs'};
	my $sainfo = "i_" . $sa_id;
	my $profile = "p_" . $sa_id;

	# get sainfo
	${$sainfo} = $arg->{'SaInfo'};
	# as SA establish time
	${$sainfo}->{'START_TIME'} = time;

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">up_isakmp: sa_id=$sa_id</FONT></B><BR>");
		vLogHTML("<B>  PROFILE_ID = ${$sainfo}->{'PROFILE_ID'}</B><BR>");
		vLogHTML("<B>  ISAKMP_HND = ${$sainfo}->{'SA_HANDLER'}</B><BR>");
		vLogHTML("<B>  START_TIME = ${$sainfo}->{'START_TIME'}</B><BR>");
		vLogHTML("<B>  LIFETIME   = ${$sainfo}->{'LIFETIME'}</B><BR>");
	}
	# end

	# return
	if ($UP_SA_CHECKER eq $sa_id) {
		return 1;
	}
	return;
}

#-----------------------------------------------------------------------------#
# up_sa() version auto
#-----------------------------------------------------------------------------#
sub up_sa($) {
my ($arg) = @_;
my $keys ='';

# SA MN->HA define 
my %sa_in_hash = (
	'sa12_ha0' => 'IPSEC_MANUAL_SA1_MN_HA0',
	'sa34_ha0' => 'IPSEC_MANUAL_SA3_MN_HA0',
	'sa56_ha0' => 'IPSEC_MANUAL_SA5_MN_HA0',
	'sa78_ha0' => 'IPSEC_MANUAL_SA7_MN_HA0',
	'sa12_ha1' => 'IPSEC_MANUAL_SA1_MN_HA1',
	'sa34_ha1' => 'IPSEC_MANUAL_SA3_MN_HA1',
	'sa56_ha1' => 'IPSEC_MANUAL_SA5_MN_HA1',
	'sa78_ha1' => 'IPSEC_MANUAL_SA7_MN_HA1',
);

# SA MN<-HA define
my %sa_out_hash = (
	'sa12_ha0' => 'IPSEC_MANUAL_SA2_HA0_MN',
	'sa34_ha0' => 'IPSEC_MANUAL_SA4_HA0_MN',
	'sa56_ha0' => 'IPSEC_MANUAL_SA6_HA0_MN',
	'sa78_ha0' => 'IPSEC_MANUAL_SA8_HA0_MN',
	'sa12_ha1' => 'IPSEC_MANUAL_SA2_HA1_MN',
	'sa34_ha1' => 'IPSEC_MANUAL_SA4_HA1_MN',
	'sa56_ha1' => 'IPSEC_MANUAL_SA6_HA1_MN',
	'sa78_ha1' => 'IPSEC_MANUAL_SA8_HA1_MN',
);

	my $sa_id = $arg->{'UserArgs'};
	my $sainfo = "i_" . $sa_id;
	my $profile = "p_" . $sa_id;

	# first establish check count
	if (!defined(${$sainfo}->{SA_HANDLER})) {
		$sa_cnt ++;
	}
	# get sainfo
	${$sainfo} = $arg->{'SaInfo'};
	# as SA establish time
	${$sainfo}->{'START_TIME'} = time;

	# vcpp as ipsec.def
	my $sa_in = $sa_in_hash{$sa_id};
	my $sa_out = $sa_out_hash{$sa_id};

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">up_sa: sa_id=$sa_id</FONT></B><BR>");
		vLogHTML("<B>  PROFILE_ID   = ${$sainfo}->{'PROFILE_ID'}</B><BR>");
		vLogHTML("<B>  IPsec(in)    = $sa_in</B><BR>");
		vLogHTML("<B>  IPsec(out)   = $sa_out</B><BR>");
		vLogHTML("<B>  ID_PROTO     = ${$profile}{'ID_PROTO'}</B><BR>");
		vLogHTML("<B>  ISAKMP_HND   = ${$sainfo}->{'ISAKMP_SA_HANDLER'}</B><BR>");
		vLogHTML("<B>  SA_HANDLER   = ${$sainfo}->{'SA_HANDLER'}</B><BR>");
		vLogHTML("<B>  START_TIME   = ${$sainfo}->{'START_TIME'}</B><BR>");
		vLogHTML("<B>  IN_LIFETIME  = ${$sainfo}->{'IN_LIFETIME'}</B><BR>");
		vLogHTML("<B>  OUT_LIFETIME = ${$sainfo}->{'OUT_LIFETIME'}</B><BR>");
	}
	# end

	if ((${$profile}{ID_PROTO} eq '0') ||
	    (${$profile}{ID_PROTO} eq '58') ||
	    (${$profile}{ID_PROTO} eq '135')) {

		if (${$profile}{ID_PROTO} eq '0') {
			$keys .= "-D$sa_in" . "_PROTO_ALL=1 ";
			$keys .= "-D$sa_out" . "_PROTO_ALL=1 ";
		}
		elsif (${$profile}{ID_PROTO} eq '58') {
			$keys .= "-D$sa_in" . "_PROTO_ICMP=1 ";
			$keys .= "-D$sa_out" . "_PROTO_ICMP=1 ";
		}
		elsif (${$profile}{ID_PROTO} eq '135') {
			$keys .= "-D$sa_in" . "_PROTO_MH=1 ";
			$keys .= "-D$sa_out" . "_PROTO_MH=1 ";
		}

		$keys .= "-D$sa_in" . "_SPI=${$sainfo}->{'IN_SPI'} " ;
		$keys .= "-D$sa_out" . "_SPI=${$sainfo}->{'OUT_SPI'} ";

		$keys .= "-D$sa_in" . "_ALGO_ESP=1 ";
		$keys .= "-D$sa_out" . "_ALGO_ESP=1 ";

		if (${$sainfo}->{'ESP_ALG'} eq 'TI_ESP_ALG_3DES') {
			$keys .= "-D$sa_in" . "_ESP_DES3CBC=1 ";
			$keys .= "-D$sa_out" . "_ESP_DES3CBC=1 ";

			$keys .= "-D$sa_in" . "_ESP_KEY=\\\"${$sainfo}->{'IN_ENC_KEY'}\\\" ";
			$keys .= "-D$sa_out" . "_ESP_KEY=\\\"${$sainfo}->{'OUT_ENC_KEY'}\\\" ";
		}
		elsif (${$sainfo}->{'ESP_ALG'} eq 'TI_ATTR_ENC_ALG_DES') {
			$keys .= "-D$sa_in" . "_ESP_DESCBC=1 ";
			$keys .= "-D$sa_out" . "_ESP_DESCBC=1 ";

			$keys .= "-D$sa_in" . "_ESP_KEY=\\\"${$sainfo}->{'IN_ENC_KEY'}\\\" ";
			$keys .= "-D$sa_out" . "_ESP_KEY=\\\"${$sainfo}->{'OUT_ENC_KEY'}\\\" ";
		}

		if (${$sainfo}->{'ATTR_AUTH'} eq 'TI_ATTR_AUTH_HMAC_SHA') {
			$keys .= "-D$sa_in" . "_AH_HMACSHA1=1 ";
			$keys .= "-D$sa_out" . "_AH_HMACSHA1=1 ";

			$keys .= "-D$sa_in" . "_AH_KEY=\\\"${$sainfo}->{'IN_AUTH_KEY'}\\\" ";
			$keys .= "-D$sa_out" . "_AH_KEY=\\\"${$sainfo}->{'OUT_AUTH_KEY'}\\\" ";
		}
		elsif (${$sainfo}->{'ATTR_AUTH'} eq 'TI_ATTR_AUTH_HMAC_MD5') {
			$keys .= "-D$sa_in" . "_AH_HMACMD5=1 ";
			$keys .= "-D$sa_out" . "_AH_HMACMD5=1 ";

			$keys .= "-D$sa_in" . "_AH_KEY=\\\"${$sainfo}->{'IN_AUTH_KEY'}\\\" ";
			$keys .= "-D$sa_out" . "_AH_KEY=\\\"${$sainfo}->{'OUT_AUTH_KEY'}\\\" ";
		}
	}

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B>  keys = $keys</B><BR>");
	}
	# end

	# vcpp
	VCppRegist($sa_id, $keys); 

	# check sa all
	if ($sa_cnt == $sa_num) {
		$SA_SET_FLAG = 1;
	}

	# return
	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B>  sa_num      = $sa_num</B><BR>");
		vLogHTML("<B>  sa_cnt      = $sa_cnt</B><BR>");
		vLogHTML("<B>  SA_SET_FLAG = $SA_SET_FLAG</B><BR>");
	}
	# end
	if ($UP_SA_CHECKER eq $sa_id) {
		return 1;
	}
	elsif (($UP_SA_CHECKER eq 'sa56_ha0') &&
	       ($sa_id eq 'sa12_ha0') &&
	       ($p_sa12_ha0{'ID_PROTO'} eq 'ALL')) {
		return 1;
	}
	elsif (($UP_SA_CHECKER eq 'sa78_ha0') &&
	       ($sa_id eq 'sa34_ha0') &&
	       ($p_sa34_ha0{'ID_PROTO'} eq 'ALL')) {
		return 1;
	}
	elsif ($UP_SA_CHECKER eq 'ALL') {
		if ($SA_SET_FLAG == 1) {
			return 1;
		}
	}
	return;
}

#-----------------------------------------------------------------------------#
# chg_endpoint() 
#-----------------------------------------------------------------------------#
sub chg_endpoint(@) {
	my ($packet) = @_;
	my $sa_handler, $nut_ip, $tn_ether, %sa_info;

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		return;
	}
	# end

	%value_ba = get_value_of_ba(0, $packet);
	%value_ipv6 = get_value_of_ipv6(0, $packet);

	if ($value_ba{'KFlag'} == 1) {
		if ($value_ipv6{SourceAddress} eq $node_hash{'ha0_ga'}) {
			$sa_handler = $i_isakmp_ha0->{'SA_HANDLER'};
			if ($NOW_Link eq "Link0") {
				$nut_ip   = "$node_hash{nuth_ga}";
				$tn_ether = "$ha0_ga{mac}";
			}
			elsif ($NOW_Link eq "LinkX") {
				$nut_ip   = "$node_hash{nutx_ga}";
				$tn_ether = "$r1_lla{mac}";
			}
			elsif ($NOW_Link eq "LinkY") {
				$nut_ip   = "$node_hash{nuty_ga}";
				$tn_ether = "$r2_lla{mac}";
			}
		}
		elsif ($value_ipv6{SourceAddress} eq $node_hash{'ha1_ga'}) {
			$sa_handler = $i_isakmp_ha1->{'SA_HANDLER'};
			if ($NOW_Link eq "Link0") {
				$nut_ip   = "$node_hash{nuth_ga}";
				$tn_ether = "$HA1_MAC";
			}
			elsif ($NOW_Link eq "LinkX") {
				$nut_ip   = "$node_hash{nutx_ga}";
				$tn_ether = "$r1_lla{mac}";
			}
			elsif ($NOW_Link eq "LinkY") {
				$nut_ip   = "$node_hash{nuty_ga}";
				$tn_ether = "$r2_lla{mac}";
			}
		}
		# dummy route for debug
		if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
			vLogHTML("<B>chg_endpoint: SA_HANDLER=$sa_handler</B><BR>");
			vLogHTML("<B>chg_endpoint: NUT_IP    =$nut_ip</B><BR>");
			vLogHTML("<B>chg_endpoint: TN_ETHER  =$tn_ether</B><BR>");
		}
		# end
		%sa_info = ( 'NUT_IP_ADDR' => $nut_ip, 'TN_ETHER_ADDR' => $tn_ether);
		IKEChgSaInfo($sa_handler, %sa_info);
	}

	return;
}

#-----------------------------------------------------------------------------#
# check_sa()
#
# - rtnval
#   0: establish
#   1: not establish
#   2: no sa profile
#-----------------------------------------------------------------------------#
sub check_sa($) {
	my ($sa) = @_;

	# check sa profile
	if (defined(${"p_" . "$sa"}{'ID'})) {
		$profile = "p_" . "$sa";
	}
	elsif ($sa eq "sa56_ha0") {
		if ($p_sa12_ha0{'ID_PROTO'} eq 'ALL') {
			$profile = "p_sa12_ha0";
		}
		else {
			return (2);
		}
	}
	elsif ($sa eq "sa78_ha0") {
		if ($p_sa34_ha0{'ID_PROTO'} eq 'ALL') {
			$profile = "p_sa34_ha0";
		}
		else {
			return (2);
		}
	}
	else {
		return (2);
	}

	# check sa info
	if (!defined(${"i_$sa"}->{'SA_HANDLER'})) {
		return (1);
	}

	# establish
	return (0);
}

# dmmy for test
#-----------------------------------------------------------------------------#
# set_sa()
#-----------------------------------------------------------------------------#
sub set_sa() {

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">set_sa: sas=@sas</FONT></B><BR>");
	}
	# end

	foreach $_ (@sas) {
		if ($_ eq 'isakmp_ha0') {
			set_isakmpinfo();
		}
		if ($_ eq 'sa12_ha0') {
			set_sainfo12();
		}
		if ($_ eq 'sa34_ha0') {
			set_sainfo34();
		}
		if ($_ eq 'sa56_ha0') {
			set_sainfo56();
		}
		if ($_ eq 'sa78_ha0') {
			set_sainfo78();
		}
	}
}

#-----------------------------------------------------------------------------#
# set_isakmpinfo()
#   dmmy ISAKMPInfo
#-----------------------------------------------------------------------------#
sub set_isakmpinfo() {

	# 
	if ($DMMYISAKMP != 0) {
		return;
	}
	$DMMYISAKMP ++;

	my %isakmpinfo = (
		'PROFILE_ID' => 'isakmp_ha0_0',
		'SA_HANDLER' => 0,
		'PHASE'      => '1',
		'LIFETIME'   => $MN_CONF{ISAKMP_MN_HA0_LD},
		'STATUS'     => 'VALID',
	);

	$isakmpinfo{'SA_HANDLER'} = int(rand 10000) + 1;
	$isakmpinfo{'LIFETIME'}   = 120;

	my $arg = {
		'SaInfo'    => {%isakmpinfo},
		'UserArgs'  => 'isakmp_ha0',
		'SaExpired' => ''
	};

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">set_isakmpinfo:</FONT></B><BR>");
		vLogHTML("<B>  PROFILE_ID = $arg->{'SaInfo'}->{'PROFILE_ID'}</B><BR>");
		vLogHTML("<B>  SA_HANDLER = $arg->{'SaInfo'}->{'SA_HANDLER'}</B><BR>");
	}
	# end

	# call CALLBACK
	up_isakmp($arg);

	return;
}

#-----------------------------------------------------------------------------#
# set_sainfo12()
#   dmmy SaInfo
#-----------------------------------------------------------------------------#
sub set_sainfo12() {

	#
	if (%p_sa12_ha0 == 0) {
		return;
	}

	#
	if ($DMMY12 != 0) {
		return;
	}
	$DMMY12 ++;

	my %sainfo12 = (
		'PROFILE_ID'        => 'sa12_ha0_0',
		'SA_HANDLER'        => 0,
		'PHASE'             => '2',
		'ISAKMP_SA_HANDLER' => $i_isakmp_ha0->{'SA_HANDLER'},
		'ESP_ALG'           => $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA12_MN_HA0_ESP_ALG'}},
		'ATTR_AUTH'         => $sa_auth{$MN_CONF{'IPSEC_IKE_SA12_MN_HA0_AUTH'}},
		'IN_SPI'            => $MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_SPI},
		'IN_ENC_KEY'        => $MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY},
		'IN_AUTH_KEY'       => $MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_AH_KEY},
		'IN_LIFETIME'       => $MN_CONF{IPSEC_IKE_SA12_MN_HA0_LD},
		'IN_STATUS'         => 'VALID',
		'OUT_SPI'           => $MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_SPI},
		'OUT_ENC_KEY'       => $MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_ESP_KEY},
		'OUT_AUTH_KEY'      => $MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_AH_KEY},
		'OUT_LIFETIME'      => $MN_CONF{IPSEC_IKE_SA12_MN_HA0_LD},
		'OUT_STATUS'        => 'VALID',
	);

	$sainfo12{'SA_HANDLER'}   = int(rand 10000) + 1;
	$sainfo12{'IN_LIFETIME'}  = 90;
	$sainfo12{'OUT_LIFETIME'} = 90;

	my $arg = {
		'SaInfo'    => {%sainfo12},
		'UserArgs'  => 'sa12_ha0',
		'SaExpired' => ''
	};

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">set_sainfo12:</FONT></B><BR>");
		vLogHTML("<B>  PROFILE_ID = $arg->{'SaInfo'}->{'PROFILE_ID'}</B><BR>");
		vLogHTML("<B>  SA_HANDLER = $arg->{'SaInfo'}->{'SA_HANDLER'}</B><BR>");
		vLogHTML("<B>  ISAKMP_HND = $arg->{'SaInfo'}->{'ISAKMP_SA_HANDLER'}</B><BR>");
	}
	# end

	# call CALLBACK
	up_sa($arg);

	return;
}

#-----------------------------------------------------------------------------#
# set_sainfo34()
#   dmmy SaInfo
#-----------------------------------------------------------------------------#
sub set_sainfo34() {

	#
	if (%p_sa34_ha0 == 0) {
		return;
	}

	#
	if ($DMMY34 != 0) {
		return;
	}
	$DMMY34 ++;

	my %sainfo34 = (
		'PROFILE_ID'        => 'sa34_ha0_0',
		'SA_HANDLER'        => 0,
		'PHASE'             => '2',
		'ISAKMP_SA_HANDLER' => $i_isakmp_ha0->{'SA_HANDLER'},
		'ESP_ALG'           => $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA34_MN_HA0_ESP_ALG'}},
		'ATTR_AUTH'         => $sa_auth{$MN_CONF{'IPSEC_IKE_SA34_MN_HA0_AUTH'}},
		'IN_SPI'            => $MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_SPI},
		'IN_ENC_KEY'        => $MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_ESP_KEY},
		'IN_AUTH_KEY'       => $MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_AH_KEY},
		'IN_LIFETIME'       => $MN_CONF{IPSEC_IKE_SA34_MN_HA0_LD},
		'IN_STATUS'         => 'VALID',
		'OUT_SPI'           => $MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_SPI},
		'OUT_ENC_KEY'       => $MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_ESP_KEY},
		'OUT_AUTH_KEY'      => $MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_AH_KEY},
		'OUT_LIFETIME'      => $MN_CONF{IPSEC_IKE_SA34_MN_HA0_LD},
		'OUT_STATUS'        => 'VALID',
	);

	$sainfo34{'SA_HANDLER'}   = int(rand 10000) + 1;
	$sainfo34{'IN_LIFETIME'}  = 90;
	$sainfo34{'OUT_LIFETIME'} = 90;

	my $arg = {
		'SaInfo'    => {%sainfo34},
		'UserArgs'  => 'sa34_ha0',
		'SaExpired' => ''
	};

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">set_sainfo34:</FONT></B><BR>");
		vLogHTML("<B>  PROFILE_ID = $arg->{'SaInfo'}->{'PROFILE_ID'}</B><BR>");
		vLogHTML("<B>  SA_HANDLER = $arg->{'SaInfo'}->{'SA_HANDLER'}</B><BR>");
		vLogHTML("<B>  ISAKMP_HND = $arg->{'SaInfo'}->{'ISAKMP_SA_HANDLER'}</B><BR>");
	}
	# end

	# call CALLBACK
	up_sa($arg);

	return;
}

#-----------------------------------------------------------------------------#
# set_sainfo56()
#   dmmy SaInfo
#-----------------------------------------------------------------------------#
sub set_sainfo56() {

	#
	if (%p_sa56_ha0 == 0) {
		return;
	}

	#
	if ($DMMY56 != 0) {
		return;
	}
	$DMMY56 ++;

	my %sainfo56 = (
		'PROFILE_ID'        => 'sa56_ha0_0',
		'SA_HANDLER'        => 0,
		'PHASE'             => '2',
		'ISAKMP_SA_HANDLER' => $i_isakmp_ha0->{'SA_HANDLER'},
		'ESP_ALG'           => $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA56_MN_HA0_ESP_ALG'}},
		'ATTR_AUTH'         => $sa_auth{$MN_CONF{'IPSEC_IKE_SA56_MN_HA0_AUTH'}},
		'IN_SPI'            => $MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_SPI},
		'IN_ENC_KEY'        => $MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_ESP_KEY},
		'IN_AUTH_KEY'       => $MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_AH_KEY},
		'IN_LIFETIME'       => $MN_CONF{IPSEC_IKE_SA56_MN_HA0_LD},
		'IN_STATUS'         => 'VALID',
		'OUT_SPI'           => $MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_SPI},
		'OUT_ENC_KEY'       => $MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_ESP_KEY},
		'OUT_AUTH_KEY'      => $MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_AH_KEY},
		'OUT_LIFETIME'      => $MN_CONF{IPSEC_IKE_SA56_MN_HA0_LD},
		'OUT_STATUS'        => 'VALID',
	);

	$sainfo56{'SA_HANDLER'}   = int(rand 10000) + 1;
	$sainfo56{'IN_LIFETIME'}  = 90;
	$sainfo56{'OUT_LIFETIME'} = 90;

	my $arg = {
		'SaInfo'    => {%sainfo56},
		'UserArgs'  => 'sa56_ha0',
		'SaExpired' => ''
	};

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">set_sainfo56:</FONT></B><BR>");
		vLogHTML("<B>  PROFILE_ID = $arg->{'SaInfo'}->{'PROFILE_ID'}</B><BR>");
		vLogHTML("<B>  SA_HANDLER = $arg->{'SaInfo'}->{'SA_HANDLER'}</B><BR>");
		vLogHTML("<B>  ISAKMP_HND = $arg->{'SaInfo'}->{'ISAKMP_SA_HANDLER'}</B><BR>");
	}
	# end

	# call CALLBACK
	up_sa($arg);

	return;
}

#-----------------------------------------------------------------------------#
# set_sainfo78()
#   dmmy SaInfo
#-----------------------------------------------------------------------------#
sub set_sainfo78() {

	#
	if (%p_sa78_ha0 == 0) {
		return;
	}

	#
	if ($DMMY78 != 0) {
		return;
	}
	$DMMY78 ++;

	my %sainfo78 = (
		'PROFILE_ID'        => 'sa78_ha0_0',
		'SA_HANDLER'        => 0,
		'PHASE'             => '2',
		'ISAKMP_SA_HANDLER' => $i_isakmp_ha0->{'SA_HANDLER'},
		'ESP_ALG'           => $sa_esp_alg{$MN_CONF{'IPSEC_IKE_SA78_MN_HA0_ESP_ALG'}},
		'ATTR_AUTH'         => $sa_auth{$MN_CONF{'IPSEC_IKE_SA78_MN_HA0_AUTH'}},
		'IN_SPI'            => $MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_SPI},
		'IN_ENC_KEY'        => $MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_ESP_KEY},
		'IN_AUTH_KEY'       => $MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_AH_KEY},
		'IN_LIFETIME'       => $MN_CONF{IPSEC_IKE_SA78_MN_HA0_LD},
		'IN_STATUS'         => 'VALID',
		'OUT_SPI'           => $MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_SPI},
		'OUT_ENC_KEY'       => $MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_ESP_KEY},
		'OUT_AUTH_KEY'      => $MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_AH_KEY},
		'OUT_LIFETIME'      => $MN_CONF{IPSEC_IKE_SA78_MN_HA0_LD},
		'OUT_STATUS'        => 'VALID',
	);

	$sainfo78{'SA_HANDLER'}   = int(rand 10000) + 1;
	$sainfo78{'IN_LIFETIME'}  = 90;
	$sainfo78{'OUT_LIFETIME'} = 90;

	my $arg = {
		'SaInfo'    => {%sainfo78},
		'UserArgs'  => 'sa78_ha0',
		'SaExpired' => ''
	};

	# dummy route for debug
	if ($MN_CONF{'ENV_IKE_WO_IKE'} == 1) {
		vLogHTML("<B><FONT COLOR=\"#FF0000\">set_sainfo78:</FONT></B><BR>");
		vLogHTML("<B>  PROFILE_ID = $arg->{'SaInfo'}->{'PROFILE_ID'}</B><BR>");
		vLogHTML("<B>  SA_HANDLER = $arg->{'SaInfo'}->{'SA_HANDLER'}</B><BR>");
		vLogHTML("<B>  ISAKMP_HND = $arg->{'SaInfo'}->{'ISAKMP_SA_HANDLER'}</B><BR>");
	}
	# end

	# call CALLBACK
	up_sa($arg);

	return;
}

#-----------------------------------------------------------------------------#
# set_debug()
#-----------------------------------------------------------------------------#
sub set_debug(@) {
my (@rensou) = @_;
my %rensou = @rensou;
my $key, $val;

	vLogHTML("<B><FONT COLOR=\"#00FFFF\">set_debug:</FONT></B><BR>");

	while (($key, $val) = each (%rensou)){
		vLogHTML("<B>  ($key, $val)</FONT></B><BR>");
	}

	return;
}

#-----------------------------------------------------------------------------#
# init_mn_ike()
#-----------------------------------------------------------------------------#
sub init_mn_ike() {

	my $nuth = $node_hash{nuth_ga};
	my $ha0  = $node_hash{ha0_ga};
	my $ha1  = $node_hash{ha1_ga};
	my $cn0  = $node_hash{cn0_ga};

	mip6ikeResetSA("saddump");
	mip6ikeResetSPD("spddump");

# under construction
if (0) {
	# SA1 MN -> HA0 BU
	if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} ne 'NONE') {
		mip6ikeSetSPD(
			"src=$nuth",
			"dst=$ha0",
			"sport=any",
			"dport=any",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO}}",
			"direction=out",
			"mode=transport",
			"protocol=esp",
		);
	}
	# SA2 HA0 -> MN BA
	if ($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} ne 'NONE') {
		mip6ikeSetSPD(
			"src=$ha0",
			"dst=$nuth",
			"sport=any",
			"dport=any",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO}}",
			"direction=in",
			"mode=transport",
			"protocol=esp",
		);
	}

	# HA1
	if (($MN_CONF{ENV_HA1_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA1 MN -> HA1 BU
		if ($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} ne 'NONE') {
			mip6ikeSetSPD(
				"src=$nuth",
				"dst=$ha1",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO}}",
				"direction=out",
				"mode=transport",
				"protocol=esp",
			);
		}
		# SA2 HA1 -> MN BA
		if ($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} ne 'NONE') {
			mip6ikeSetSPD(
				"src=$ha1",
				"dst=$nuth",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO}}",
				"direction=in",
				"mode=transport",
				"protocol=esp",
			);
		}
	}

	# SA5 MN -> HA0 Prefix Discovery
	if (($MN_CONF{IPSEC_MANUAL_SA1_MN_HA0_PROTO} ne 'ALL') &&
	    ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO} ne 'NONE')) {
		mip6ikeSetSPD(
			"src=$nuth",
			"dst=$ha0",
			"sport=any",
			"dport=any",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA5_MN_HA0_PROTO}}",
			"direction=out",
			"mode=transport",
			"protocol=esp",
		);
	}
	# SA6 HA0 -> MN Prefix Discovery
	if (($MN_CONF{IPSEC_MANUAL_SA2_HA0_MN_PROTO} ne 'ALL') &&
	    ($MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO} ne 'NONE')) {
		mip6ikeSetSPD(
			"src=$ha0",
			"dst=$nuth",
			"sport=any",
			"dport=any",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA6_HA0_MN_PROTO}}",
			"direction=in",
			"mode=transport",
			"protocol=esp",
		);
	}

	# HA1
	if (($MN_CONF{ENV_HA1_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA5 MN -> HA1 Prefix Discovery
		if (($MN_CONF{IPSEC_MANUAL_SA1_MN_HA1_PROTO} ne 'ALL') &&
		    ($MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO} ne 'NONE')) {
			mip6ikeSetSPD(
				"src=$nuth",
				"dst=$ha1",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA5_MN_HA1_PROTO}}",
				"direction=out",
				"mode=transport",
				"protocol=esp",
			);
		}
		# SA6 HA1 -> MN Prefix Discovery
		if (($MN_CONF{IPSEC_MANUAL_SA2_HA1_MN_PROTO} ne 'ALL') &&
		    ($MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO} ne 'NONE')) {
			mip6ikeSetSPD(
				"src=$ha1",
				"dst=$nuth",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA6_HA1_MN_PROTO}}",
				"direction=in",
				"mode=transport",
				"protocol=esp",
			);
		}
	}

# exclude in IKEv1
if (0) {
	# CN0 Payload
	if (($MN_CONF{ENV_CN0_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA5 MN -> CN0 ICMP
		if ($MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_PROTO} ne 'NONE') {
			mip6ikeSetSPD(
				"src=$nuth",
				"dst=$cn0",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA5_MN_CN0_PROTO}}",
				"direction=out",
				"mode=transport",
				"protocol=esp",
			);
		}
		# SA6 CN0 -> MN ICMP
		if ($MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_PROTO} ne 'NONE') {
			mip6ikeSetSPD(
				"src=$cn0",
				"dst=$nuth",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA6_CN0_MN_PROTO}}",
				"direction=in",
				"mode=transport",
				"protocol=esp",
			);
		}
	}
}

	# SA3 MN -> HA0 Return Routability Signaling
	if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} ne 'NONE') {
		mip6ikeSetSPD(
			"src=$nuth",
			"dst=::/0",
			"tsrc=$nuth",
			"tdst=$ha0",
			"sport=any",
			"dport=any",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO}}",
			"direction=out",
			"mode=tunnel",
			"protocol=esp",
		);
	}
	# SA4 HA0 -> MN Return Routability Signaling
	if ($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} ne 'NONE') {
		mip6ikeSetSPD(
			"src=::/0",
			"dst=$nuth",
			"tsrc=$ha0",
			"tdst=$nuth",
			"sport=any",
			"dport=any",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO}}",
			"direction=in",
			"mode=tunnel",
			"protocol=esp",
		);
	}

	# HA1
	if (($MN_CONF{ENV_HA1_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA3 MN -> HA1 Return Routability Signaling
		if ($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} ne 'NONE') {
			mip6ikeSetSPD(
				"src=$nuth",
				"dst=::/0",
				"tsrc=$nuth",
				"tdst=$ha1",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO}}",
				"direction=out",
				"mode=tunnel",
				"protocol=esp",
			);
		}
		# SA4 HA1 -> MN Return Routability Signaling
		if ($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} ne 'NONE') {
			mip6ikeSetSPD(
				"src=::/0",
				"dst=$nuth",
				"tsrc=$ha1",
				"tdst=$nuth",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO}}",
				"direction=in",
				"mode=tunnel",
				"protocol=esp",
			);
		}
	}

	# SA7 MN -> HA0 Payload Packets
	if (($MN_CONF{IPSEC_MANUAL_SA3_MN_HA0_PROTO} ne 'ALL') &&
	    ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO} ne 'NONE')) {
		mip6ikeSetSPD(
			"src=$nuth",
			"dst=::/0",
			"tsrc=$nuth",
			"tdst=$ha0",
			"sport=any",
			"dport=any",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA7_MN_HA0_PROTO}}",
			"direction=out",
			"mode=tunnel",
			"protocol=esp",
		);
	}
	# SA8 HA0 -> MN Payload Packets
	if (($MN_CONF{IPSEC_MANUAL_SA4_HA0_MN_PROTO} ne 'ALL') &&
	    ($MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO} ne 'NONE')) {
		mip6ikeSetSPD(
			"src=::/0",
			"dst=$nuth",
			"tsrc=$ha0",
			"tdst=$nuth",
			"sport=any",
			"dport=any",
			"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA8_HA0_MN_PROTO}}",
			"direction=in",
			"mode=tunnel",
			"protocol=esp",
		);
	}

	# HA1
	if (($MN_CONF{ENV_HA1_SET} eq 'YES') || ($MN_CONF{ENV_INITIALIZE} eq 'RETURN')) {
		# SA7 MN -> HA1 Payload Packets
		if (($MN_CONF{IPSEC_MANUAL_SA3_MN_HA1_PROTO} ne 'ALL') &&
		    ($MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO} ne 'NONE')) {
			mip6ikeSetSPD(
				"src=$nuth",
				"dst=::/0",
				"tsrc=$nuth",
				"tdst=$ha1",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA7_MN_HA1_PROTO}}",
				"direction=out",
				"mode=tunnel",
				"protocol=esp",
			);
		}
		# SA8 HA1 -> MN Payload Packets
		if (($MN_CONF{IPSEC_MANUAL_SA4_HA1_MN_PROTO} ne 'ALL') &&
		    ($MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO} ne 'NONE')) {
			mip6ikeSetSPD(
				"src=::/0",
				"dst=$nuth",
				"tsrc=$ha1",
				"tdst=$nuth",
				"sport=any",
				"dport=any",
				"upperspec=$proto{$MN_CONF{IPSEC_MANUAL_SA8_HA1_MN_PROTO}}",
				"direction=in",
				"mode=tunnel",
				"protocol=esp",
			);
		}
	}

	my $pre_key_hex = Ascii2Hex($MN_CONF{ISAKMP_MN_HA0_PSK});

	mip6ikeSetSA(
		"dst=",
			# <destination_address>
		"dst_port=",
			# <destination_port>
		"exchange_mode=aggressive",
			# {aggressive}
		"doi=1",
			# 1: ipsec_doi
		"situation=",
			# 1: SIT_IDENTITY_ONLY
			# 2: SIT_SECRECY
			# 4: SIT_INTEGRITY
		"isakmp_src_id_type=",
			# {address|fqdn|user_fqdn}
		"isakmp_src_id=",
			# <id>|<string>
#		"peers_id_type=undef",
#		"peers_id=undef",
#		"verify_identifier=",
#		"certificate_type=",
#		"certificate_file=",
#		"privkey_file=",
#		"peers_certfile=",
#		"send_cert=",
#		"send_cr=",
#		"verify_cert=",
#		"nonce_size=",
		"dh_group=",
			# 1: group1
			# 2: group2
		"lifetime=",
			# <seconds>
		"lifetime_unit=seconds",
			# seconds
		"encryption_algorithm=",
			# {des|3des}
		"hash_algorithm=",
			# {md5|sha1}
		"authentication_method=pre_shared_key",
			# {pre_shared_key}
#		"dh_group_2=",
#		"lifetime_2=",
#		"lifetime_unit_2=",
#		"encryption_algorithm_2=",
#		"hash_algorithm_2=",
#		"authentication_method_2=",
		"key_id=",
			# <address?>
		"key_value=0x"."$pre_key_hex",
			# pre_shared_key?
		"ph2_id_type=",
			# {source_id|address|annonymous}
		"ph2_src_id=",
			# <address>
		"ph2_dst_id=",
			# <address>
#		"ph2_src_port=",
#		"ph2_dst_port=",
		"ph2_src_upper=",
			# any|tcp|udp|ipv6-icmp|icmp6|src_proto_number
		"ph2_dst_upper=",
			# any|tcp|udp|ipv6-icmp|icmp6|dst_proto_number
		"pfs_group=off",
			# off
		"ph2_p_num=1",
		"ph2_p1_t_num=1",
		"ph2_p1_t1_lt=",
			# <seconds>
		"ph2_p1_t1_lt_unit=seconds",
			# seconds
		"ph2_p1_t1_enc_alg=",
			# {ESP_3DES|ESP_DES}
		"ph2_p1_t1_auth_alg=",
			# {AH_SHA|AH_MD5}
		"ph2_p1_t1_auth_mtd=",
			# {HMAC_SHA|HMAC_MD5}
#		"compression_algorithm=",
	);

}
# under construction

	mip6ikeEnable();

	return;
}

#-----------------------------------------------------------------------------#
# term_mn_ike()
#-----------------------------------------------------------------------------#
sub term_mn_ike() {
	mip6ikeResetSA("saddump");
	mip6ikeResetSPD("spddump");
}

#======================================================================
# mip6ikeSetSPD() - set SPD entries
#======================================================================
sub mip6ikeSetSPD(@) {
	vLogHTML("Target: Set SPD entries: @_");
	$ret = vRemote("ipsecSetSPD.rmt", "@_", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Set SPD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
			mip6ikeExitNS();
		}
		else {
			mip6ikeExitFail();
		}
	}
}

#======================================================================
# mip6ikeResetSPD()
#======================================================================
sub mip6ikeResetSPD(@) {
	vLogHTML("Target: Clear SPD entries: @_");
	$ret = vRemote("ipsecResetSPD.rmt", "@_", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Cear SPD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
			mip6ikeExitNS();
		}
		else {
			exit $V6evalTool::exitFail;
		}
	}
}

#======================================================================
# mip6ikeSetSA() - Enable and start IKEv1 function
#======================================================================
sub mip6ikeSetSA(@) {
	vLogHTML("Target: Set IKEv1 SA entries: @_");
	my $debug = undef;
	if ($remote_debug) {
		$debug = "remote_debug=$remote_debug";
	}
	$ret = vRemote("ikeSetSA.rmt", "@_", $debug);
	if ($ret) {
		vLogHTML("Cannot Set IKEv1 SAD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
			mip6ikeExitNS();
		}
		else {
			mip6ikeExitFail();
		}
	}
}

#======================================================================
# mip6ikeResetSA()
#======================================================================
sub mip6ikeResetSA(@) {
	vLogHTML("Target: Reset IKEv1 SA entries: @_");
	$ret = vRemote("ikeResetSA.rmt", "@_", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Reset IKEv1 SAD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
			mip6ikeExitNS();
		}
		else {
			exit $V6evalTool::exitFail;
		}
	}
}

#======================================================================
# mip6ikeEnable() - Enable and start IKEv1 function
#======================================================================
sub mip6ikeEnable() {
	vLogHTML("Target: Enable and start IKEv1 function");
#	$ret = vRemote("ikeEnable.rmt", $remote_debug);
	$ret = vRemote("ikeEnable.rmt", $remote_debug, 'testtype=mip6mn');
	if ($ret) {
		vLogHTML("Cannot Enable IKEv1<BR>");
		if ($ret == $V6evalTool::exitNS) {
			mip6ikeExitNS();
		}
		else {
			mip6ikeExitFail();
		}
	}
}

#======================================================================
# mip6ikeExitNS()
#======================================================================
sub mip6ikeExitNS() {
	vLogHTML("This test is not supported now<BR>");
	exit $V6evalTool::exitNS;
}

#======================================================================
# mip6ikeExitFail()
#======================================================================
sub mip6ikeExitFail() {
	vLogHTML('<FONT COLOR="#FF0000">NG</FONT><BR>');
	exit $V6evalTool::exitFatal;
}

# End of File
1;
