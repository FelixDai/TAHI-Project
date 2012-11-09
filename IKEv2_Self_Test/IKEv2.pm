#!/usr/bin/perl
#
# Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009
# Yokogawa Electric Corporation.
# All rights reserved.
# 
# Redistribution and use of this software in source and binary
# forms, with or without modification, are permitted provided that
# the following conditions and disclaimer are agreed and accepted
# by the user:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with
#    the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project
#    which is related to this software (hereinafter referred to as
#    "project") nor the names of the contributors may be used to
#    endorse or promote products derived from this software without
#    specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written
#    notification to the copyrighters.
# 
# 5. The copyrighters, the project and the contributors may prohibit
#    the use of this software at any time.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# $Id: IKEv2.pm,v 1.116 2012/06/22 07:48:21 doo Exp $
#
################################################################

package IKEv2;

BEGIN
{
	push(@INC, '/usr/local/koi/libdata');
	$kCommon::TestVersion = '$Name: REL_1_1_1 $';

	require './config.pl';
	require './debug.pl';
	sub ADDRESS_FAMILY() {
		if ($ikev2_debug_ipv4) {
			return(2); # AF_INET
		}
		else {
			return(28); # AF_INET6
		}
	};
}
END   {}

use Exporter;

use Socket;
use Socket6;
use Errno qw(ECONNREFUSED);

use kCommon;
use kCrypt::DH;
use Crypt::Random qw( makerandom makerandom_octet );
use kIKE::kHelpers;
use kIKE::kConsts;
use kIKE::kGen;
use kIKE::kDec;
use kIKE::kIKE;
use kIKE::kJudge;
use kIKE::kConnection;

use IKEv2packet;

use strict;

our @ISA = qw(Exporter);

our @EXPORT = qw(
	$true
	$false

	$config_pl
	$NUTconfiguration

	$ikev2_global_setup
	$ikev2_global_cleanup

	$need_ipsec_cleanup
	$need_vpn

	%addresses

	ADDRESS_FAMILY
	AF_INET6

	IKEv2initialize

	IKEv2customize

	IKEv2setupTN
	IKEv2setupNUT

	IKEv2initiateNUT
	IKEv2waitNUT

	IKEv2create_session
	IKEv2send_IKE_SA_INIT_request
	devel_IKEv2send_IKE_SA_INIT_request
	IKEv2receive_IKE_SA_INIT_request
	devel_IKEv2receive_IKE_SA_INIT_request
	IKEv2send_IKE_SA_INIT_response
	devel_IKEv2send_IKE_SA_INIT_response
	IKEv2receive_IKE_SA_INIT_response
	devel_IKEv2receive_IKE_SA_INIT_response
	devel_IKEv2receive_IKE_SA_INIT_response2
	IKEv2send_IKE_AUTH_request
	IKEv2fill_IKE_AUTH_request
	devel_IKEv2send_IKE_AUTH_request
	IKEv2receive_IKE_AUTH_request
	devel_IKEv2receive_IKE_AUTH_request
	IKEv2receive_IKE_AUTH_response
	devel_IKEv2receive_IKE_AUTH_response
	IKEv2send_IKE_AUTH_response
	devel_IKEv2send_IKE_AUTH_response
	IKEv2send_CREATE_CHILD_SA_request
	devel_IKEv2send_CREATE_CHILD_SA_request
	IKEv2receive_CREATE_CHILD_SA_request
	devel_IKEv2receive_CREATE_CHILD_SA_request
	devel_IKEv2send_CREATE_CHILD_SA_response
	devel_IKEv2send_CREATE_CHILD_SA_response2
	IKEv2receive_CREATE_CHILD_SA_response
	devel_IKEv2receive_CREATE_CHILD_SA_response
	devel_IKEv2receive_CREATE_CHILD_SA_response2
	IKEv2send_INFORMATIONAL_request
	devel_IKEv2send_INFORMATIONAL_request
	devel_IKEv2receive_INFORMATIONAL_request
	devel_IKEv2send_INFORMATIONAL_response
	IKEv2receive_INFORMATIONAL_response
	devel_IKEv2receive_INFORMATIONAL_response
	devel_IKEv2receive_INFORMATIONAL_response2

	IKEv2send
	IKEv2build

	IKEv2set_keymat
	IKEv2get_keymat
	IKEv2gen_keymat
	devel_IKEv2gen_keymat
	IKEv2gen_child_sa_keymat
	devel_IKEv2gen_child_sa_keymat
	IKEv2set_child_sa_keymat
	IKEv2set_SPD
	IKEv2flush_SAD_SPD
	IKEv2flush_SAD
	IKEv2flush_SPD

	IKEv2load_packet
	IKEv2make_packet

	IKEv2send_TCP_SYN

	ICMPexchange
	ICMPcreate_session
	ICMPprepare
	ICMPsend
	ICMPsend_v6eval
	ICMPreceive

	loadSPD
	loadICMP
	loadTCP

	der2hexstr

	RegistKoiSignalHandler

	IKEv2log

	IKEv2exitPass
	IKEv2exitNS
	IKEv2exitFail
	IKEv2exitFatal

	IKEv2_v6eval_generate_IPsecSA
	IKEv2_v6eval_set_IPsecSA
	IKEv2_v6eval_send_recv
	IKEv2_v6eval_send
);

push(@EXPORT, @kCommon::EXPORT);
push(@EXPORT, @IKEv2packet::EXPORT);

our $true	= 1;
our $false	= 0;

our $config_pl = undef;
our $ikev2_global_setup = undef;
our $ikev2_global_cleanup = undef;

our $need_ipsec_cleanup	= $false;
our $need_vpn	= $false;

#
# $scenario
#
# 0: Common Topology for End-Node: End-Node to End-Node
# 1: Common Topology for End-Node: End-Node to SGW
# 2: Common Topology for SGW: SGW to SGW
# 3: Common Topology for SGW: SGW to End-Node
#
our $scenario = undef;
our $NUTconfiguration = undef;
our $local_endpoint_addr = undef;
our $local_policy_src_range = undef;
our $local_policy_dst_range = undef;
our $local_spd = undef;
our $local_sad = undef;
our $icmp_session = undef;
our $icmpv4_packets = undef;
our $icmpv6_packets = undef;
our $tcp_session = undef;
our %ike_sa_keymats = ();
our %addresses = ();
our $dh_group_bitlen = {
	'2'	=> 1024,
	'14'	=> 2048,
};
our $IKE_SA_SPI_STRLEN		= $kIKE::kConsts::CONSTS->{'IKE_SA_SPI_STRLEN'};
our $CHILD_SA_SPI_STRLEN	= $kIKE::kConsts::CONSTS->{'CHILD_SA_SPI_STRLEN'};

our @r_addrs0 = ();	# real addresses for Link0
our @r_addrs1 = ();	# real addresses for Link1
our @r_assigned_addrs0 = ();
our @r_assigned_addrs1 = ();

our @v_addrs0 = ();	# virtual addresses for Link0
our @v_addrs1 = ();	# virtual addresses for Link1
our @v_assigned_addrs0 = ();
our @v_assigned_addrs1 = ();

our $bool_remote_async	= $false;
use constant {
	TN_CERT_FILE => 'cert/TNcert.pem',
	TN_PRIVATE_KEY_FILE => 'cert/TNprivkey.pem',
	NUT_CERT_FILE => 'cert/NUTcert.pem',
	NUT_PRIVATE_KEY_FILE => 'cert/NUTprivkey.pem',
	CA_CERT_FILE => 'cert/demoCA/cacert.pem',
};



#prototypes
sub decode($;$);
sub collect($);



#----------------------------------------------------------------------#
# register IKEv2.pm                                                    #
#----------------------------------------------------------------------#
sub
IKEv2initialize($$)
{
	my ($nut, $tn) = @_;

	IKEv2log('initializing IKEv2 module ...');

	#------------------------------#
	# register scenario to use     #
	#------------------------------#
	unless(select_scenario($nut, $tn)) {
		IKEv2log("<FONT COLOR=\"#ff0000\">undefined scenario -- $nut to $tn</FONT>");
		return($false);
	}

	#------------------------------#
	# read config.pl               #
	#------------------------------#
	$config_pl = parse_configuration();

	#------------------------------#
	# show config.pl parameters    #
	#------------------------------#
	dump_configuration();

	#------------------------------#
	# set addresses                #
	#------------------------------#
	set_addresses();

	#------------------------------#
	# load default settings        #
	#------------------------------#
	unless(loadTNdefault()) {
		IKEv2log("<FONT COLOR=\"#ff0000\">unable to load TN default configuration.</FONT>");
		return($false);
	}

	$NUTconfiguration = loadNUTdefault();

	return($true);
}



sub
select_scenario($$)
{
	my ($nut, $tn) = @_;

	if(($nut eq 'EN') && ($tn eq 'EN')) {
		IKEv2log('configuring Common Topology for End-Node: End-Node to End-Node ...');
		$scenario = 0;

		my $key = 'common_remote_index';
		$gen_ike_sa_init_req->{$key} = $default_gen_ike_sa_init_req;
		$exp_ike_sa_init_req->{$key} = $default_exp_ike_sa_init_req;
		$gen_ike_sa_init_resp->{$key} = $default_gen_ike_sa_init_resp;
		$exp_ike_sa_init_resp->{$key} = $default_exp_ike_sa_init_resp;
		$gen_ike_auth_req->{$key} = $transport_gen_ike_auth_req;
		$exp_ike_auth_req->{$key} = $transport_exp_ike_auth_req;
		$gen_ike_auth_resp->{$key} = $transport_gen_ike_auth_resp;
		$exp_ike_auth_resp->{$key} = $transport_exp_ike_auth_resp;
		$gen_create_child_sa_req->{$key} = $transport_gen_create_child_sa_req;
		$exp_create_child_sa_req->{$key} = $transport_exp_create_child_sa_req;
		$gen_create_child_sa_resp->{$key} = $transport_gen_create_child_sa_resp;
		$exp_create_child_sa_resp->{$key} = $transport_exp_create_child_sa_resp;
		$gen_informational_req->{$key} = $default_gen_informational_req;
		$exp_informational_req->{$key} = $default_exp_informational_req;
		$gen_informational_resp->{$key} = $default_gen_informational_resp;
		$exp_informational_resp->{$key} = $default_exp_informational_resp;

		return($true);
	}

	if(($nut eq 'EN') && ($tn eq 'SGW')) {
		IKEv2log('configuring Common Topology for End-Node: End-Node to SGW ...');
		$scenario = 1;

		my $key = 'common_remote_index';
		$gen_ike_sa_init_req->{$key} = $default_gen_ike_sa_init_req;
		$exp_ike_sa_init_req->{$key} = $default_exp_ike_sa_init_req;
		$gen_ike_sa_init_resp->{$key} = $default_gen_ike_sa_init_resp;
		$exp_ike_sa_init_resp->{$key} = $default_exp_ike_sa_init_resp;
		$gen_ike_auth_req->{$key} = $tunnel_gen_ike_auth_req;
		$exp_ike_auth_req->{$key} = $tunnel_exp_ike_auth_req;
		$gen_ike_auth_resp->{$key} = $tunnel_gen_ike_auth_resp;
		$exp_ike_auth_resp->{$key} = $tunnel_exp_ike_auth_resp;
		$gen_create_child_sa_req->{$key} = $tunnel_gen_create_child_sa_req;
		$exp_create_child_sa_req->{$key} = $tunnel_exp_create_child_sa_req;
		$gen_create_child_sa_resp->{$key} = $tunnel_gen_create_child_sa_resp;
		$exp_create_child_sa_resp->{$key} = $tunnel_exp_create_child_sa_resp;
		$gen_informational_req->{$key} = $default_gen_informational_req;
		$exp_informational_req->{$key} = $default_exp_informational_req;
		$gen_informational_resp->{$key} = $default_gen_informational_resp;
		$exp_informational_resp->{$key} = $default_exp_informational_resp;

		return($true);
	}

	if(($nut eq 'SGW') && ($tn eq 'SGW')) {
		IKEv2log('configuring Common Topology for SGW: SGW to SGW ...');
		$scenario = 2;

		my $key = 'common_remote_index';
		$gen_ike_sa_init_req->{$key} = $default_gen_ike_sa_init_req;
		$exp_ike_sa_init_req->{$key} = $default_exp_ike_sa_init_req;
		$gen_ike_sa_init_resp->{$key} = $default_gen_ike_sa_init_resp;
		$exp_ike_sa_init_resp->{$key} = $default_exp_ike_sa_init_resp;
		$gen_ike_auth_req->{$key} = $tunnel_gen_ike_auth_req;
		$exp_ike_auth_req->{$key} = $tunnel_exp_ike_auth_req;
		$gen_ike_auth_resp->{$key} = $tunnel_gen_ike_auth_resp;
		$exp_ike_auth_resp->{$key} = $tunnel_exp_ike_auth_resp;
		$gen_create_child_sa_req->{$key} = $tunnel_gen_create_child_sa_req;
		$exp_create_child_sa_req->{$key} = $tunnel_exp_create_child_sa_req;
		$gen_create_child_sa_resp->{$key} = $tunnel_gen_create_child_sa_resp;
		$exp_create_child_sa_resp->{$key} = $tunnel_exp_create_child_sa_resp;
		$gen_informational_req->{$key} = $default_gen_informational_req;
		$exp_informational_req->{$key} = $default_exp_informational_req;
		$gen_informational_resp->{$key} = $default_gen_informational_resp;
		$exp_informational_resp->{$key} = $default_exp_informational_resp;

		return($true);
	}

	if(($nut eq 'SGW') && ($tn eq 'EN')) {
		IKEv2log('configuring Common Topology for SGW: SGW to End-Node ...');
		$scenario = 3;

		my $key = 'common_remote_index';
		$gen_ike_sa_init_req->{$key} = $default_gen_ike_sa_init_req;
		$exp_ike_sa_init_req->{$key} = $default_exp_ike_sa_init_req;
		$gen_ike_sa_init_resp->{$key} = $default_gen_ike_sa_init_resp;
		$exp_ike_sa_init_resp->{$key} = $default_exp_ike_sa_init_resp;
		$gen_ike_auth_req->{$key} = $tunnel_gen_ike_auth_req;
		$exp_ike_auth_req->{$key} = $tunnel_exp_ike_auth_req;
		$gen_ike_auth_resp->{$key} = $tunnel_gen_ike_auth_resp;
		$exp_ike_auth_resp->{$key} = $tunnel_exp_ike_auth_resp;
		$gen_create_child_sa_req->{$key} = $tunnel_gen_create_child_sa_req;
		$exp_create_child_sa_req->{$key} = $tunnel_exp_create_child_sa_req;
		$gen_create_child_sa_resp->{$key} = $tunnel_gen_create_child_sa_resp;
		$exp_create_child_sa_resp->{$key} = $tunnel_exp_create_child_sa_resp;
		$gen_informational_req->{$key} = $default_gen_informational_req;
		$exp_informational_req->{$key} = $default_exp_informational_req;
		$gen_informational_resp->{$key} = $default_gen_informational_resp;
		$exp_informational_resp->{$key} = $default_exp_informational_resp;

		return($true);
	}

	return($false);
}



sub
parse_configuration()
{
	my %conf = ();

	IKEv2log('parsing ./config.pl ...');

	#
	# keyword: ikev2_prefixA
	#
	#     scenario(0): Common Topology for End-Node: End-Node vs. End-Node
	#     scenario(1): Common Topology for End-Node: End-Node vs. SGW
	#     scenario(2): Common Topology for SGW: SGW vs. SGW
	#     scenario(3): Common Topology for SGW: SGW vs. End-Node
	#
	unless(defined($IKEv2::ikev2_prefixA)) {
		IKEv2exitFatal('./config.pl: ikev2_prefixA: undefined');
	}

	$conf{'ikev2_prefixA'} = $IKEv2::ikev2_prefixA;



	#
	# keyword: ikev2_prefixB
	#
	#     scenario(2): Common Topology for SGW: SGW vs. SGW
	#     scenario(3): Common Topology for SGW: SGW vs. End-Node
	#
	if($scenario > 1 && !defined($IKEv2::ikev2_prefixB)) {
		IKEv2exitFatal('./config.pl: ikev2_prefixB: undefined');
	}

	$conf{'ikev2_prefixB'} = $IKEv2::ikev2_prefixB;



	#
	# keyword: ikev2_prefixX
	#
	#     scenario(0): Common Topology for End-Node: End-Node vs. End-Node
	#     scenario(1): Common Topology for End-Node: End-Node vs. SGW
	#     scenario(2): Common Topology for SGW: SGW vs. SGW
	#     scenario(3): Common Topology for SGW: SGW vs. End-Node
	#
	unless(defined($IKEv2::ikev2_prefixX)) {
		IKEv2exitFatal('./config.pl: ikev2_prefixX: undefined');
	}

	$conf{'ikev2_prefixX'} = $IKEv2::ikev2_prefixX;



	#
	# keyword: ikev2_prefixY
	#
	#     scenario(1): Common Topology for End-Node: End-Node vs. SGW
	#     scenario(2): Common Topology for SGW: SGW vs. SGW
	#
	if(($scenario == 1 || $scenario == 2) && !defined($IKEv2::ikev2_prefixY)) {
		IKEv2exitFatal('./config.pl: ikev2_prefixY: undefined');
	}

	$conf{'ikev2_prefixY'} = $IKEv2::ikev2_prefixY;



	#
	# keyword: ikev2_link_local_addr_router_link0
	#
	unless(defined($IKEv2::ikev2_link_local_addr_router_link0)) {
		IKEv2exitFatal('./config.pl: ikev2_link_local_addr_router_link0: undefined');
	}

	$conf{'ikev2_link_local_addr_router_link0'} = $IKEv2::ikev2_link_local_addr_router_link0;



	# generate NUT's address
	{
		#
		# keyword: ikev2_global_addr_nut_link0
		#
		unless(defined($IKEv2::ikev2_interface_id_nut_link0)) {
			IKEv2exitFatal('./config.pl: ikev2_interface_id_nut_link0');
		}
		$conf{'ikev2_global_addr_nut_link0'} = $conf{'ikev2_prefixA'} . $IKEv2::ikev2_interface_id_nut_link0;



		#
		# keyword: ikev2_global_addr_nut_link1
		#
		if (($scenario == 2 || $scenario == 3) &&
		    !defined($IKEv2::ikev2_interface_id_nut_link1)) {
			IKEv2exitFatal('./config.pl: ikev2_interface_id_nut_link1: undefined');
		}
		$conf{'ikev2_global_addr_nut_link1'} = $conf{'ikev2_prefixB'} . $IKEv2::ikev2_interface_id_nut_link1;
	}



	#
	# keyword: ikev2_pre_shared_key_nut
	#
	unless(defined($IKEv2::ikev2_pre_shared_key_nut)) {
		IKEv2exitFatal('./config.pl: ikev2_pre_shared_key_nut: undefined');
	}

	$conf{'ikev2_pre_shared_key_nut'} = $IKEv2::ikev2_pre_shared_key_nut;



	#
	# keyword: ikev2_pre_shared_key_tn
	#
	unless(defined($IKEv2::ikev2_pre_shared_key_tn)) {
		IKEv2exitFatal('./config.pl: ikev2_pre_shared_key_tn: undefined');
	}

	$conf{'ikev2_pre_shared_key_tn'} = $IKEv2::ikev2_pre_shared_key_tn;



	#
	# keyword: ikev2_nut_ike_sa_lifetime
	#
	unless (defined($IKEv2::ikev2_nut_ike_sa_lifetime)) {
		IKEv2exitFatal('./config.pl: ikev2_nut_ike_sa_lifetime: undefined');
	}

	$conf{'ikev2_nut_ike_sa_lifetime'} = $IKEv2::ikev2_nut_ike_sa_lifetime;



	#
	# keyword: ikev2_nut_child_sa_lifetime
	#
	unless (defined($IKEv2::ikev2_nut_child_sa_lifetime)) {
		IKEv2exitFatal('./config.pl: ikev2_nut_child_sa_lifetime: undefined');
	}

	$conf{'ikev2_nut_child_sa_lifetime'} = $IKEv2::ikev2_nut_child_sa_lifetime;



	#
	# keyword: ikev2_nut_ike_sa_init_req_retrans_timer
	#
	unless (defined($IKEv2::ikev2_nut_ike_sa_init_req_retrans_timer)) {
		IKEv2exitFatal('./config.pl: ikev2_nut_ike_sa_init_req_retrans_timer: undefined');
	}

	$conf{'ikev2_nut_ike_sa_init_req_retrans_timer'} = $IKEv2::ikev2_nut_ike_sa_init_req_retrans_timer;



	#
	# keyword: ikev2_nut_ike_auth_req_retrans_timer
	#
	unless (defined($IKEv2::ikev2_nut_ike_auth_req_retrans_timer)) {
		IKEv2exitFatal('./config.pl: ikev2_nut_ike_auth_req_retrans_timer: undefined');
	}

	$conf{'ikev2_nut_ike_auth_req_retrans_timer'} = $IKEv2::ikev2_nut_ike_auth_req_retrans_timer;



	#
	# keyword: ikev2_nut_create_child_sa_req_retrans_timer
	#
	unless (defined($IKEv2::ikev2_nut_create_child_sa_req_retrans_timer)) {
		IKEv2exitFatal('./config.pl: ikev2_nut_create_child_sa_req_retrans_timer: undefined');
	}

	$conf{'ikev2_nut_create_child_sa_req_retrans_timer'} = $IKEv2::ikev2_nut_create_child_sa_req_retrans_timer;



	#
	# keyword: ikev2_nut_informational_req_retrans_timer
	#
	unless (defined($IKEv2::ikev2_nut_informational_req_retrans_timer)) {
		IKEv2exitFatal('./config.pl: ikev2_nut_informational_req_retrans_timer: undefined');
	}

	$conf{'ikev2_nut_informational_req_retrans_timer'} = $IKEv2::ikev2_nut_informational_req_retrans_timer;



	#
	# keyword: ikev2_nut_liveness_check_timer
	#
	unless (defined($IKEv2::ikev2_nut_liveness_check_timer)) {
		IKEv2exitFatal('./config.pl: ikev2_nut_liveness_check_timer: undefined');
	}

	$conf{'ikev2_nut_liveness_check_timer'} = $IKEv2::ikev2_nut_liveness_check_timer;



	#
	# keyword: ikev2_nut_num_of_half_opens_cookie
	#
	unless (defined($IKEv2::ikev2_nut_num_of_half_opens_cookie)) {
		IKEv2exitFatal('./config.pl: ikev2_nut_num_of_half_opens_cookie: undefined');
	}

	$conf{'ikev2_nut_num_of_half_opens_cookie'} = $IKEv2::ikev2_nut_num_of_half_opens_cookie;



	#
	# keyword: ikev2_nut_num_of_retransmissions
	#
	unless (defined($IKEv2::ikev2_nut_num_of_retransmissions)) {
		IKEv2exitFatal('./config.pl: ikev2_nut_num_of_retransmissions: undefined');
	}

	$conf{'ikev2_nut_num_of_retransmissions'} = $IKEv2::ikev2_nut_num_of_retransmissions;



	#
	# keyword: ikev2_optimize_initialization
	#
	$conf{'ikev2_optimize_initialization'} = $IKEv2::ikev2_optimize_initialization? 1: 0;



	#
	# keyword: ikev2_debug_send_create_child_sa_with_ke
	#
	$conf{'ikev2_debug_send_create_child_sa_with_ke'} = $IKEv2::ikev2_debug_send_create_child_sa_with_ke? 1: 0;



	#
	# keyword: advanced_support_initial_contact
	#
	$conf{'advanced_support_initial_contact'} = $IKEv2::advanced_support_initial_contact ? $true : $false;



	#
	# keyword: advanced_support_cookie
	#
	$conf{'advanced_support_cookie'} = $IKEv2::advanced_support_cookie ? $true : $false;



	#
	# keyword: advanced_alg_nego_ike_sa
	#
	$conf{'advanced_alg_nego_ike_sa'} = $IKEv2::advanced_alg_nego_ike_sa ? $true : $false;



	#
	# keyword: advanced_alg_nego_child_sa
	#
	$conf{'advanced_alg_nego_child_sa'} = $IKEv2::advanced_alg_nego_child_sa ? $true : $false;



	#
	# keyword: advanced_support_encr_aes_cbc
	#
	$conf{'advanced_support_encr_aes_cbc'} = $IKEv2::advanced_support_encr_aes_cbc ? $true : $false;



	#
	# keyword: advanced_support_encr_aes_ctr
	#
	$conf{'advanced_support_encr_aes_ctr'} = $IKEv2::advanced_support_encr_aes_ctr ? $true : $false;



	#
	# keyword: advanced_support_encr_null
	#
	$conf{'advanced_support_encr_null'} = $IKEv2::advanced_support_encr_null ? $true : $false;



	#
	# keyword: advanced_support_prf_aes128_cbc
	#
	$conf{'advanced_support_prf_aes128_cbc'} = $IKEv2::advanced_support_prf_aes128_cbc ? $true : $false;



	#
	# keyword: advanced_support_auth_aes_xcbc_96
	#
	$conf{'advanced_support_auth_aes_xcbc_96'} = $IKEv2::advanced_support_auth_aes_xcbc_96 ? $true : $false;



	#
	# keyword: advanced_support_auth_none
	#
	$conf{'advanced_support_auth_none'} = $IKEv2::advanced_support_auth_none ? $true : $false;



	#
	# keyword: advanced_support_dh_group14
	#
	$conf{'advanced_support_dh_group14'} = $IKEv2::advanced_support_dh_group14 ? $true : $false;



	#
	# keyword: advanced_support_esn
	#
	$conf{'advanced_support_esn'} = $IKEv2::advanced_support_esn ? $true : $false;



	#
	# keyword: advanced_support_creating_new_child_sa
	#
	$conf{'advanced_support_creating_new_child_sa'} = $IKEv2::advanced_support_creating_new_child_sa ? $true : $false;



	#
	# keyword: advanced_multiple_transform_initial_ike_sa
	#
	$conf{'advanced_multiple_transform_initial_ike_sa'} = $IKEv2::advanced_multiple_transform_initial_ike_sa ? $true : $false;



	#
	# keyword: advanced_multiple_proposal_initial_ike_sa
	#
	$conf{'advanced_multiple_proposal_initial_ike_sa'} = $IKEv2::advanced_multiple_proposal_initial_ike_sa ? $true : $false;



	#
	# keyword: advanced_multiple_transform_initial_child_sa
	#
	$conf{'advanced_multiple_transform_initial_child_sa'} = $IKEv2::advanced_multiple_transform_initial_child_sa ? $true : $false;



	#
	# keyword: advanced_multiple_proposal_initial_child_sa
	#
	$conf{'advanced_multiple_proposal_initial_child_sa'} = $IKEv2::advanced_multiple_proposal_initial_child_sa ? $true : $false;



	#
	# keyword: advanced_multiple_transform_rekey_ike_sa
	#
	$conf{'advanced_multiple_transform_rekey_ike_sa'} = $IKEv2::advanced_multiple_transform_rekey_ike_sa ? $true : $false;



	#
	# keyword: advanced_multiple_proposal_rekey_ike_sa
	#
	$conf{'advanced_multiple_proposal_rekey_ike_sa'} = $IKEv2::advanced_multiple_proposal_rekey_ike_sa ? $true : $false;



	#
	# keyword: advanced_multiple_transform_rekey_child_sa
	#
	$conf{'advanced_multiple_transform_rekey_child_sa'} = $IKEv2::advanced_multiple_transform_rekey_child_sa ? $true : $false;



	#
	# keyword: advanced_multiple_proposal_rekey_child_sa
	#
	$conf{'advanced_multiple_proposal_rekey_child_sa'} = $IKEv2::advanced_multiple_proposal_rekey_child_sa ? $true : $false;



	#
	# keyword: advanced_support_cert
	#
	$conf{'advanced_support_cert'} = $IKEv2::advanced_support_cert ? $true : $false;



	#
	# keyword: advanced_support_certreq
	#
	$conf{'advanced_support_certreq'} = $IKEv2::advanced_support_certreq ? $true : $false;



	#
	# keyword: advanced_support_rsa_digital_signature
	#
	$conf{'advanced_support_rsa_digital_signature'} = $IKEv2::advanced_support_rsa_digital_signature ? $true : $false;



	#
	# keyword: advanced_support_cfg_payload
	#
	$conf{'advanced_support_cfg_payload'} = $IKEv2::advanced_support_cfg_payload ? $true : $false;



	#
	# keyword: advanced_support_invalid_spi
	#
	$conf{'advanced_support_invalid_spi'} = $IKEv2::advanced_support_invalid_spi ? $true : $false;



	#
	# keyword: advanced_support_invalid_ke_payload
	#
	$conf{'advanced_support_invalid_ke_payload'} = $IKEv2::advanced_support_invalid_ke_payload ? $true : $false;



	#
	# keyword: advanced_support_authentication_failed
	#
	$conf{'advanced_support_authentication_failed'} = $IKEv2::advanced_support_authentication_failed ? $true : $false;


	#
	# keyword: advanced_support_pfs
	#
	$conf{'advanced_support_pfs'} = $IKEv2::advanced_support_pfs ? $true : $false;


	return(\%conf);
}



sub
dump_configuration()
{
	my $string = '<TABLE BORDER>';

	$string .= '<TR>';
	$string .= '<TH BGCOLOR="#a8b5d8">key</TH>';
	$string .= '<TH BGCOLOR="#a8b5d8">value</TH>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>Link A prefix</TD>';
	$string .= "<TD>$config_pl->{'ikev2_prefixA'}</TD>";
	$string .= '</TR>';

	if($scenario > 1) {
		$string .= '<TR>';
		$string .= '<TD>Link B prefix</TD>';
		$string .= "<TD>$config_pl->{'ikev2_prefixB'}</TD>";
		$string .= '</TR>';
	}

	$string .= '<TR>';
	$string .= '<TD>Link X prefix</TD>';
	$string .= "<TD>$config_pl->{'ikev2_prefixX'}</TD>";
	$string .= '</TR>';

	if($scenario == 1 || $scenario == 2) {
		$string .= '<TR>';
		$string .= '<TD>Link Y prefix</TD>';
		$string .= "<TD>$config_pl->{'ikev2_prefixY'}</TD>";
		$string .= '</TR>';
	}

	$string .= '<TR>';
	$string .= '<TD>Link A link-local address (TR1)</TD>';
	$string .= "<TD>$config_pl->{'ikev2_link_local_addr_router_link0'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>Link A global address (NUT)</TD>';
	$string .= "<TD>$config_pl->{'ikev2_global_addr_nut_link0'}</TD>";
	$string .= '</TR>';

	if($scenario == 2|| ($scenario == 3)) {
		$string .= '<TR>';
		$string .= '<TD>Link B global address (NUT)</TD>';
		$string .= "<TD>$config_pl->{'ikev2_global_addr_nut_link1'}</TD>";
		$string .= '</TR>';
	}

	$string .= '<TR>';
	$string .= '<TD>pre-shared key (TN)</TD>';
	$string .= "<TD>$config_pl->{'ikev2_pre_shared_key_tn'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>pre-shared key (NUT)</TD>';
	$string .= "<TD>$config_pl->{'ikev2_pre_shared_key_nut'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>IKE_SA Lifetime</TD>';
	$string .= "<TD>$config_pl->{'ikev2_nut_ike_sa_lifetime'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>CHILD_SA Lifetime</TD>';
	$string .= "<TD>$config_pl->{'ikev2_nut_child_sa_lifetime'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>IKE_SA_INIT Request RetransTimer</TD>';
	$string .= "<TD>$config_pl->{'ikev2_nut_ike_sa_init_req_retrans_timer'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>IKE_AUTH Request RetransTimer</TD>';
	$string .= "<TD>$config_pl->{'ikev2_nut_ike_auth_req_retrans_timer'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>CREATE_CHILD_SA Request RetransTimer</TD>';
	$string .= "<TD>$config_pl->{'ikev2_nut_create_child_sa_req_retrans_timer'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>INFORMATIONAL Request RetransTimer</TD>';
	$string .= "<TD>$config_pl->{'ikev2_nut_informational_req_retrans_timer'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>Liveness Check Timer</TD>';
	$string .= "<TD>$config_pl->{'ikev2_nut_liveness_check_timer'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD># of Half-Open IKE_SAs to contain N(COOKIE)</TD>';
	$string .= "<TD>$config_pl->{'ikev2_nut_num_of_half_opens_cookie'}</TD>";
	$string .= '</TR>';

	if($config_pl->{'ikev2_optimize_initialization'}) {
		$string .= '<TR>';
		$string .= '<TD>(DEBUG) Optimize Initialization</TD>';
		$string .= '<TD>enable</TD>';
		$string .= '</TR>';
	}

	$string .= '</TABLE>';

	IKEv2log($string);

	return;
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
set_addresses()
{
	if (ADDRESS_FAMILY == AF_INET6) {
		set_addresses_ipv6();
	}
	elsif (ADDRESS_FAMILY == AF_INET) {
		set_addresses_ipv4();
	}
}


sub
set_addresses_ipv6()
{
	my %tmp = ();
	if ($scenario == 0) {
		# Common Topology for End-Node: End-Node to End-Node

		# NUT
		$tmp{'nut_global_linkA'} = $config_pl->{'ikev2_global_addr_nut_link0'};

		# TR1 link-local
		$tmp{'tr1_linklocal_linkA'} = $config_pl->{'ikev2_link_local_addr_router_link0'};
		# TR1 global
		$tmp{'tr1_global_linkA'} = "$config_pl->{'ikev2_prefixA'}::f";
		# TN1 global
		$tmp{'tn1_global_linkX'} = "$config_pl->{'ikev2_prefixX'}::1";

		# alias
		$tmp{'default_router'} = $tmp{'tr1_linklocal_linkA'};
		$tmp{'common_endpoint_tn'} = $tmp{'tn1_global_linkX'};
	}
	elsif ($scenario == 1) {
		# Common Topology for End-Node: End-Node to SGW

		# NUT
		$tmp{'nut_global_linkA'} = $config_pl->{'ikev2_global_addr_nut_link0'};

		# TR1 link-local
		$tmp{'tr1_linklocal_linkA'} = "$config_pl->{'ikev2_link_local_addr_router_link0'}";
		# TR1 global
		$tmp{'tr1_global_linkA'} = "$config_pl->{'ikev2_prefixA'}::f";
		# TN1 global
		$tmp{'tn1_global_linkX'} = "$config_pl->{'ikev2_prefixX'}::1";
		# TH1 global
		$tmp{'th1_global_linkY'} = "$config_pl->{'ikev2_prefixY'}::f";

		# TS
		$tmp{'prefixY'} = "$config_pl->{'ikev2_prefixY'}::/64";
		$tmp{'prefixY_saddr'} = "$config_pl->{'ikev2_prefixY'}:0000:0000:0000:0000";
		$tmp{'prefixY_eaddr'} = "$config_pl->{'ikev2_prefixY'}:ffff:ffff:ffff:ffff";

		# INTERNAL_IP6_ADDRESS
		$tmp{'cfg_req_internal_addr'} = "$config_pl->{'ikev2_prefixY'}::1";

		# alias
		$tmp{'default_router'} = $tmp{'tr1_linklocal_linkA'};
		$tmp{'common_endpoint_tn'} = $tmp{'tn1_global_linkX'};
	}
	elsif ($scenario == 2) {
		# Common Topology for SGW: SGW to SGW

		# NUT
		$tmp{'nut_global_linkA'} = $config_pl->{'ikev2_global_addr_nut_link0'};
		$tmp{'nut_global_linkB'} = $config_pl->{'ikev2_global_addr_nut_link1'};

		# TH1 global
		$tmp{'th1_global_linkB'} = "$config_pl->{'ikev2_prefixB'}::f";
		# TR1 link-local
		$tmp{'tr1_linklocal_linkA'} = "$config_pl->{'ikev2_link_local_addr_router_link0'}";
		# TR1 global
		$tmp{'tr1_global_linkA'} = "$config_pl->{'ikev2_prefixA'}::f";
		# TN1 global
		$tmp{'tn1_global_linkX'} = "$config_pl->{'ikev2_prefixX'}::1";
		# TH2 global
		$tmp{'th2_global_linkY'} = "$config_pl->{'ikev2_prefixY'}::f";
		# TH3 global
		$tmp{'th3_global_linkY'} = "$config_pl->{'ikev2_prefixY'}::e";

		# TS
		$tmp{'prefixB'} = "$config_pl->{'ikev2_prefixB'}::/64";
		$tmp{'prefixB_saddr'} = "$config_pl->{'ikev2_prefixB'}:0000:0000:0000:0000";
		$tmp{'prefixB_eaddr'} = "$config_pl->{'ikev2_prefixB'}:ffff:ffff:ffff:ffff";
		$tmp{'prefixY'} = "$config_pl->{'ikev2_prefixY'}::/64";
		$tmp{'prefixY_saddr'} = "$config_pl->{'ikev2_prefixY'}:0000:0000:0000:0000";
		$tmp{'prefixY_eaddr'} = "$config_pl->{'ikev2_prefixY'}:ffff:ffff:ffff:ffff";

		# alias
		$tmp{'default_router'} = $tmp{'tr1_linklocal_linkA'};
		$tmp{'common_endpoint_tn'} = $tmp{'tn1_global_linkX'};
	}
	elsif ($scenario == 3) {
		# Common Topology for SGW: SGW to End-Node

		# NUT
		$tmp{'nut_global_linkA'} = $config_pl->{'ikev2_global_addr_nut_link0'};
		$tmp{'nut_global_linkB'} = $config_pl->{'ikev2_global_addr_nut_link1'};

		# TH1 global
		$tmp{'th1_global_linkB'} = "$config_pl->{'ikev2_prefixB'}::f";
		# TR1 link-local
		$tmp{'tr1_linklocal_linkA'} = "$config_pl->{'ikev2_link_local_addr_router_link0'}";
		# TR1 global
		$tmp{'tr1_global_linkA'} = "$config_pl->{'ikev2_prefixA'}::f";
		# TN1 global
		$tmp{'tn1_global_linkX'} = "$config_pl->{'ikev2_prefixX'}::1";

		# TS
		$tmp{'prefixB'} = "$config_pl->{'ikev2_prefixB'}::/64";
		$tmp{'prefixB_saddr'} = "$config_pl->{'ikev2_prefixB'}:0000:0000:0000:0000";
		$tmp{'prefixB_eaddr'} = "$config_pl->{'ikev2_prefixB'}:ffff:ffff:ffff:ffff";

		# INTERNAL_IP6_ADDRESS
		$tmp{'cfg_req_internal_addr'} = "$config_pl->{'ikev2_prefixB'}::1";
		$tmp{'cfg_req_internal_addr2'} = "$config_pl->{'ikev2_prefixB'}::2";

		# alias
		$tmp{'default_router'} = $tmp{'tr1_linklocal_linkA'};
		$tmp{'common_endpoint_tn'} = $tmp{'tn1_global_linkX'};
	}

	%addresses = %tmp;
	return;
}



sub
set_addresses_ipv4()
{
	my %tmp = ();
	if ($scenario == 0) {
		# Common Topology for End-Node: End-Node to End-Node

		# NUT
		$tmp{'nut_global_linkA'} = $config_pl->{'ikev2_global_addr_nut_link0'};

		# TR1
		$tmp{'tr1_global_linkA'} = "$config_pl->{'ikev2_prefixA'}.15";
		# TN1
		$tmp{'tn1_global_linkX'} = "$config_pl->{'ikev2_prefixX'}.1";

		# alias
		$tmp{'default_router'} = $tmp{'tr1_global_linkA'};
		$tmp{'common_endpoint_tn'} = $tmp{'tn1_global_linkX'};
	}
	elsif ($scenario == 1) {
		# Common Topology for End-Node: End-Node to SGW

		# NUT
		$tmp{'nut_global_linkA'} = $config_pl->{'ikev2_global_addr_nut_link0'};

		# TR1
		$tmp{'tr1_global_linkA'} = "$config_pl->{'ikev2_prefixA'}.15";
		# TN1
		$tmp{'tn1_global_linkX'} = "$config_pl->{'ikev2_prefixX'}.1";
		# TH1
		$tmp{'th1_global_linkY'} = "$config_pl->{'ikev2_prefixY'}.15";

		# INTERNAL_IP4_ADDRESS
		$tmp{'cfg_req_internal_addr'} = "config_pl->{'ikev2_prefixY'}.1";

		# alias
		$tmp{'default_router'} = $tmp{'tr1_global_linkA'};
		$tmp{'common_endpoint_tn'} = $tmp{'tn1_global_linkX'};
	}
	elsif ($scenario == 2) {
		# Common Topology for SGW: SGW to SGW

		# NUT
		$tmp{'nut_global_linkA'} = $config_pl->{'ikev2_global_addr_nut_link0'};
		$tmp{'nut_global_linkB'} = $config_pl->{'ikev2_global_addr_nut_link1'};

		# TH1
		$tmp{'th1_global_linkB'} = "$config_pl->{'ikev2_prefixB'}.1";
		# TR1
		$tmp{'tr1_global_linkA'} = "$config_pl->{'ikev2_prefixA'}.15";
		# TN1
		$tmp{'tn1_global_linkX'} = "$config_pl->{'ikev2_prefixX'}.1";
		# TH2
		$tmp{'th2_global_linkY'} = "$config_pl->{'ikev2_prefixY'}.15";
		# TH3
		$tmp{'th3_global_linkY'} = "$config_pl->{'ikev2_prefixY'}.14";

		# alias
		$tmp{'default_router'} = $tmp{'tr1_global_linkA'};
		$tmp{'common_endpoint_tn'} = $tmp{'tn1_global_linkX'};
	}
	elsif ($scenario == 3) {
		# Common Topology for SGW: SGW to End-Node

		# NUT
		$tmp{'nut_global_linkA'} = $config_pl->{'ikev2_global_addr_nut_link0'};
		$tmp{'nut_global_linkB'} = $config_pl->{'ikev2_global_addr_nut_link1'};

		# TH1
		$tmp{'th1_global_linkB'} = "$config_pl->{'ikev2_prefixB'}.15";
		# TR1
		$tmp{'tr1_global_linkA'} = "$config_pl->{'ikev2_prefixA'}.15";
		# TN1
		$tmp{'tn1_global_linkX'} = "$config_pl->{'ikev2_prefixX'}.1";

		# alias
		$tmp{'default_router'} = $tmp{'tr1_global_linkA'};
		$tmp{'common_endpoint_tn'} = $tmp{'tn1_global_linkX'};
	}

	%addresses = %tmp;
	return;
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2customize($)
{
	my ($conf) = @_;

	foreach my $key (keys(%{$conf})) {
		if ($key eq 'kmp_sa_lifetime') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'kmp_sa_lifetime_time'} = $conf->{$key};
			next;
		}

		if ($key eq 'ipsec_sa_lifetime') {
			$NUTconfiguration->{'ikev2'}->{'ipsec'}->[0]->{'ipsec_sa_lifetime_time'} = $conf->{$key};
			next;
		}

		if ($key eq 'peers_id.ipaddr') {
			my $peers_id = $NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'peers_id'};
			$peers_id->{'ipaddr'} = $conf->{$key};
			next;
		}

		if ($key eq 'peers_id.fqdn') {
			my $peers_id = $NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'peers_id'};
			$peers_id->{'fqdn'} = $conf->{$key};
			next;
		}

		if ($key eq 'peers_id.rfc822addr') {
			my $peers_id = $NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'peers_id'};
			$peers_id->{'rfc822addr'} = $conf->{$key};
			next;
		}

		if ($key eq 'peers_id.keyid') {
			my $peers_id = $NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'peers_id'};
			$peers_id->{'keyid'} = $conf->{$key};
			next;
		}

		if ($key eq 'my_id.ipaddr') {
			my $my_id = $NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'my_id'};
			$my_id->{'ipaddr'} = $conf->{$key};
			next;
		}

		if ($key eq 'my_id.fqdn') {
			my $my_id = $NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'my_id'};
			$my_id->{'fqdn'} = $conf->{$key};
			next;
		}

		if ($key eq 'my_id.rfc822addr') {
			my $my_id = $NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'my_id'};
			$my_id->{'rfc822addr'} = $conf->{$key};
			next;
		}

		# algorithms for IKE_SA
		if ($key eq 'my_id.keyid') {
			my $my_id = $NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'my_id'};
			$my_id->{'keyid'} = $conf->{$key};
			next;
		}

		if ($key eq 'kmp_enc_alg') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'kmp_enc_alg'} = $conf->{$key};
			next;
		}

		if ($key eq 'kmp_prf_alg') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'kmp_prf_alg'} = $conf->{$key};
			next;
		}

		if ($key eq 'kmp_hash_alg') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'kmp_hash_alg'} = $conf->{$key};
			next;
		}

		if ($key eq 'kmp_dh_group') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'kmp_dh_group'} = $conf->{$key};
			next;
		}

		if ($key eq 'kmp_auth_method') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'kmp_auth_method'} = $conf->{$key};
			next;
		}

		if ($key eq 'need_pfs') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'need_pfs'} = $conf->{$key};
			next;
		}

		if ($key eq 'pre_shared_key_local') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'pre_shared_key'}->{'local'} = $conf->{$key};
			$config_pl->{'ikev2_pre_shared_key_tn'} = $conf->{$key};
			next;
		}

		if ($key eq 'pre_shared_key_remote') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'pre_shared_key'}->{'remote'} = $conf->{$key};
			$config_pl->{'ikev2_pre_shared_key_nut'} = $conf->{$key};
			next;
		}

		# algorithms for CHILD_SA
		if ($key eq 'esp_enc_alg') {
			$NUTconfiguration->{'ikev2'}->{'sa'}->[0]->{'esp_enc_alg'} = $conf->{$key};
			next;
		}

		if ($key eq 'esp_auth_alg') {
			$NUTconfiguration->{'ikev2'}->{'sa'}->[0]->{'esp_auth_alg'} = $conf->{$key};
			next;
		}

		if ($key eq 'ah_auth_alg') {
			$NUTconfiguration->{'ikev2'}->{'sa'}->[0]->{'ah_auth_alg'} = $conf->{$key};
			next;
		}

		# selector
		if ($key eq 'selector.0.upper_layer_protocol') {
			$NUTconfiguration->{'ikev2'}->{'selector'}->[0]->{'upper_layer_protocol'} = $conf->{$key};
			next;
		}

		if ($key eq 'selector.1.upper_layer_protocol') {
			$NUTconfiguration->{'ikev2'}->{'selector'}->[1]->{'upper_layer_protocol'} = $conf->{$key};
			next;
		}

		if ($key eq 'selector.0.src') {
			$NUTconfiguration->{'ikev2'}->{'selector'}->[0]->{'src'} = $conf->{$key};
			next;
		}

		if ($key eq 'selector.1.src') {
			$NUTconfiguration->{'ikev2'}->{'selector'}->[1]->{'src'} = $conf->{$key};
			next;
		}

		if ($key eq 'selector.0.dst') {
			$NUTconfiguration->{'ikev2'}->{'selector'}->[0]->{'dst'} = $conf->{$key};
			next;
		}

		if ($key eq 'selector.1.dst') {
			$NUTconfiguration->{'ikev2'}->{'selector'}->[1]->{'dst'} = $conf->{$key};
			next;
		}

		# extended sequence number
		if ($key eq 'ext_sequence') {
			$NUTconfiguration->{'ikev2'}->{'ipsec'}->[0]->{'ext_sequence'} = $conf->{$key};
		}

		# sa_protocol
		if ($key eq 'sa_protocol') {
			$NUTconfiguration->{'ikev2'}->{'sa'}->[0]->{'sa_protocol'} = $conf->{$key};
		}

		# nonce size
		if ($key eq 'nonce_size') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'nonce_size'}->{'nonce_size'} = $conf->{$key};
		}

		# INTERNAL_IP6_ADDR Configuration Request
		if ($key eq 'request') {
			$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'ikev2'}->{'request'} = $conf->{$key};
		}

		# INTERNAL_IP6_ADDR Configuration Response
		if ($key eq 'provide') {
			if ($conf->{$key} eq 'on') {
				$NUTconfiguration->{'ikev2'}->{'remote'}->[0]->{'provide'} = 'common_addresspool_index';
			}
		}

		if ($key eq 'addresspool') {
			$NUTconfiguration->{'ikev2'}->{'addresspool'}->[0]->{'saddr'} = $conf->{$key}->{'saddr'};
			$NUTconfiguration->{'ikev2'}->{'addresspool'}->[0]->{'eaddr'} = $conf->{$key}->{'eaddr'};
		}

	}

	return($true);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2setupTN()
{
	my $_ifconfig	= '/sbin/ifconfig';
	my $_sysctl		= '/sbin/sysctl';

	loadSPD();

	loadICMP();

	loadTCP();

	# setup=1&cleanup=1&optimize=1	[skip]	setup&cleanup
	# setup=1&cleanup=1&optimize=0	[skip]	setup&cleanup
	# setup=1&cleanup=0&optimize=1	[do]	setup
	# setup=1&cleanup=0&optimize=0	[skip]	setup
	# setup=0&cleanup=1&optimize=1	[skip]	cleanup
	# setup=0&cleanup=1&optimize=0	[skip]	cleanup
	# setup=0&cleanup=0&optimize=1	[skip]	generic
	# setup=0&cleanup=0&optimize=0	[do]	generic

	if($ikev2_global_cleanup) {
		for(my $d = 0; $d <= $#r_addrs0; $d ++) {
			push(@r_assigned_addrs0, $r_addrs0[$d]);
		}

		for(my $d = 0; $d <= $#r_addrs1; $d ++) {
			push(@r_assigned_addrs1, $r_addrs1[$d]);
		}

		if($#v_addrs0 >= 0) {
			for(my $d = 0; $d <= $#v_addrs0; $d ++) {
				push(@v_assigned_addrs0, $v_addrs0[$d]);
			}
		}

		if($#v_addrs1 >= 0) {
			for(my $d = 0; $d <= $#v_addrs1; $d ++) {
				push(@v_assigned_addrs1, $v_addrs1[$d]);
			}
		}

		return($true);
	}

	if($ikev2_global_setup && !$config_pl->{'ikev2_optimize_initialization'}) {
		return($true);
	}

	IKEv2log('setting up TN ...');

	if($ikev2_global_setup || !$config_pl->{'ikev2_optimize_initialization'}) {

		my $loopback_link0	= 'lo1';
		my $loopback_link1	= 'lo2';
		my $command = undef;

		$command = (ADDRESS_FAMILY == AF_INET6) ?
			"$_sysctl -w net.inet6.ip6.forwarding=1" :
			"$_sysctl -w net.inet.ip.forwarding=1";
		unless(ikev2Local($command)) {
			return($false);
		}

		unless(ikev2Local("$_ifconfig -a")) {
			return($false);
		}

		for(my $d = 0; $d <= $#r_addrs0; $d ++) {
			$command = (ADDRESS_FAMILY == AF_INET6) ?
				"$_ifconfig $kCommon::TnDef{'Link0'} inet6 $r_addrs0[$d]/64" :
				"$_ifconfig $kCommon::TnDef{'Link0'} inet $r_addrs0[$d] netmask 255.255.255.0 alias";

			unless(ikev2Local($command)) {
				return($false);
			}

			push(@r_assigned_addrs0, $r_addrs0[$d]);
		}

		for(my $d = 0; $d <= $#r_addrs1; $d ++) {
			$command = (ADDRESS_FAMILY == AF_INET6) ?
				"$_ifconfig $kCommon::TnDef{'Link1'} inet6 $r_addrs1[$d]/64" :
				"$_ifconfig $kCommon::TnDef{'Link1'} inet $r_addrs1[$d]  netmask 255.255.255.0 alias";

			unless(ikev2Local($command)) {
				return($false);
			}

			push(@r_assigned_addrs1, $r_addrs1[$d]);
		}

		if($#v_addrs0 >= 0) {
			ikev2Local("$_ifconfig $loopback_link0 create");

			unless(ikev2Local("$_ifconfig $loopback_link0 up")) {
				return($false);
			}

			for(my $d = 0; $d <= $#v_addrs0; $d ++) {
				$command = (ADDRESS_FAMILY == AF_INET6) ?
					"$_ifconfig $loopback_link0 inet6 $v_addrs0[$d]/64" :
					"$_ifconfig $loopback_link0 inet $v_addrs0[$d] netmask 255.255.255.0 alias";

				unless(ikev2Local($command)) {
					return($false);
				}

				push(@v_assigned_addrs0, $v_addrs0[$d]);
			}
		}

		if($#v_addrs1 >= 0) {
			unless(ikev2Local("$_ifconfig $loopback_link1 create")) {
				return($false);
			}

			unless(ikev2Local("$_ifconfig $loopback_link1 up")) {
				return($false);
			}

			for(my $d = 0; $d <= $#v_addrs1; $d ++) {
				$command = (ADDRESS_FAMILY == AF_INET6) ?
					"$_ifconfig $loopback_link1 inet6 $v_addrs1[$d]/64" :
					"$_ifconfig $loopback_link1 inet $v_addrs1[$d]  netmask 255.255.255.0 alias";

				unless(ikev2Local($command)) {
					return($false);
				}

				push(@v_assigned_addrs1, $v_addrs1[$d]);
			}
		}

		sleep(3);

		if ($scenario == 1) {
			my $af = (ADDRESS_FAMILY == AF_INET6) ?
				'inet6' : 'inet';
			$command = "route add -$af default $config_pl->{'ikev2_global_addr_nut_link0'}";

			unless (ikev2Local($command)) {
				return($false);
			}

			unless (ikev2Local("netstat -nrf $af")) {
				return($false);
			}
		}

		unless(ikev2Local("$_ifconfig -a")) {
			return($false);
		}

# 		$command = (ADDRESS_FAMILY == AF_INET6) ?
# 			"$_sysctl -w net.inet6.ip6.forwarding=1" :
# 			"$_sysctl -w net.inet.ip.forwarding=1";
# 		unless(ikev2Local($command)) {
# 			return($false);
# 		}
	}

	if(!$ikev2_global_setup && !IKEv2flush_SAD_SPD()) {
		return($false);
	}

	return($true);
}



sub
cleanupTN()
{
	my $_sysctl	= '/sbin/sysctl';
	my $_ifconfig	= '/sbin/ifconfig';

	# setup=1&cleanup=1&optimize=1	[skip]	setup&cleanup
	# setup=1&cleanup=1&optimize=0	[skip]	setup&cleanup
	# setup=1&cleanup=0&optimize=1	[skip]	setup
	# setup=1&cleanup=0&optimize=0	[skip]	setup
	# setup=0&cleanup=1&optimize=1	[do]	cleanup
	# setup=0&cleanup=1&optimize=0	[skip]	cleanup
	# setup=0&cleanup=0&optimize=1	[skip]	generic
	# setup=0&cleanup=0&optimize=0	[do]	generic

	IKEv2log('cleaning up TN ...');

	if($need_ipsec_cleanup) {
		unless(IKEv2flush_SAD_SPD()) {
			return($false);
		}
	}

	if($ikev2_global_setup) {
		return($true);
	}

	if($ikev2_global_cleanup && !$config_pl->{'ikev2_optimize_initialization'}) {
		return($true);
	}

	if(!$ikev2_global_cleanup && $config_pl->{'ikev2_optimize_initialization'}) {
		return($true);
	}

	my $loopback_link0	= 'lo1';
	my $loopback_link1	= 'lo2';
	my $command = undef;

	$command = (ADDRESS_FAMILY == AF_INET6) ?
		"$_sysctl -w net.inet6.ip6.forwarding=0" :
		"$_sysctl -w net.inet.ip.forwarding=0";
	unless(ikev2Local($command)) {
		return($false);
	}

	if ($scenario == 1) {
		my $af = (ADDRESS_FAMILY == AF_INET6) ?
			'inet6' : 'inet';
		$command = "route delete -$af default";

		unless (ikev2Local($command)) {
			return($false);
		}

		unless (ikev2Local("netstat -nrf $af")) {
			return($false);
		}
	}

	unless(ikev2Local("$_ifconfig -a")) {
		return($false);
	}

	if($#v_assigned_addrs1 >= 0) {
		while(my $addr = pop(@v_assigned_addrs1)) {
			$command = (ADDRESS_FAMILY == AF_INET6) ?
				"$_ifconfig $loopback_link1 inet6 $addr/64 delete" :
				"$_ifconfig $loopback_link1 inet $addr delete";

			unless(ikev2Local($command)) {
				return($false);
			}
		}

		unless(ikev2Local("$_ifconfig $loopback_link1 down")) {
			return($false);
		}

		unless(ikev2Local("$_ifconfig $loopback_link1 destroy")) {
			return($false);
		}
	}

	if($#v_assigned_addrs0 >= 0) {
		while(my $addr = pop(@v_assigned_addrs0)) {
			$command = (ADDRESS_FAMILY == AF_INET6) ?
				"$_ifconfig $loopback_link0 inet6 $addr/64 delete" :
				"$_ifconfig $loopback_link0 inet $addr delete";
			unless(ikev2Local($command)) {
				return($false);
			}
		}

		unless(ikev2Local("$_ifconfig $loopback_link0 down")) {
			return($false);
		}

		unless(ikev2Local("$_ifconfig $loopback_link0 destroy")) {
			return($false);
		}
	}

	while(my $addr = pop(@r_assigned_addrs1)) {
		$command = (ADDRESS_FAMILY == AF_INET6) ?
			"$_ifconfig $kCommon::TnDef{'Link1'} inet6 $addr/64 delete" :
			"$_ifconfig $kCommon::TnDef{'Link1'} inet $addr delete";

		unless(ikev2Local($command)) {
			return($false);
		}
	}

	while(my $addr = pop(@r_assigned_addrs0)) {
		$command = (ADDRESS_FAMILY == AF_INET6) ?
			"$_ifconfig $kCommon::TnDef{'Link0'} inet6 $addr/64 delete" :
			"$_ifconfig $kCommon::TnDef{'Link0'} inet $addr delete";

		unless(ikev2Local($command)) {
			return($false);
		}
	}

	sleep(3);

	unless(ikev2Local("$_ifconfig -a")) {
		return($false);
	}

	return($true);
}



sub
ikev2Local($)
{
	my ($cmd) = @_;

	my $timestr = kCommon::getTimeStamp();

	my $store = $SIG{CHLD};
	$SIG{CHLD} = 'DEFAULT';
	my $output = `$cmd 2>&1`;
# XXX
#	my $output = `$cmd`;
#	my $output = system("$cmd 2>&1");
# 	my $status = $? & 0xffff;

	$SIG{CHLD} = $store;

	kCommon::prOut("ikev2Local(\"$cmd\")");
	kCommon::prOut($output);

	$output =~ s/\r//g;
	$output =~ s/&/&amp;/g;
	$output =~ s/"/&quot;/g;
	$output =~ s/</&lt;/g;
	$output =~ s/>/&gt;/g;

	kCommon::prLogHTML("<TR VALIGN=\"top\">\n");
	kCommon::prLogHTML("<TD>$timestr</TD>\n");
	kCommon::prLogHTML("<TD width=\"100%\">\n");
	kCommon::prLogHTML("ikev2Local(\"$cmd\")<BR>\n");
	kCommon::prLogHTML("<PRE>$output</PRE>");
	kCommon::prLogHTML("</TD>\n");
	kCommon::prLogHTML("</TR>");

	my $status = $? & 0xffff;

	if($status) {
		return($false);
	}

	return($true);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2setupNUT()
{
	# setup=1&cleanup=1&optimize=1  [skip]	[skip]
	# setup=1&cleanup=1&optimize=0  [skip]	[skip]
	# setup=1&cleanup=0&optimize=1  [do]	[skip]	setup
	# setup=1&cleanup=0&optimize=0  [skip]  [skip]	setup
	# setup=0&cleanup=1&optimize=1  [skip]  [skip]	cleanup
	# setup=0&cleanup=1&optimize=0  [skip]  [skip]	cleanup
	# setup=0&cleanup=0&optimize=1  [skip]	[do]	generic
	# setup=0&cleanup=0&optimize=0  [do]	[do]	generic

	if($ikev2_global_cleanup) {
		return($true);
	}

	if($ikev2_global_setup && !$config_pl->{'ikev2_optimize_initialization'}) {
		return($true);
	}

	IKEv2log('setting up NUT ...');

	my @remote_argument = ();

	my %ifconfig = ();
	my %route = ();
	my %ikev2 = ();

	if(($ikev2_global_setup && $config_pl->{'ikev2_optimize_initialization'}) ||
	(!$ikev2_global_setup && !$config_pl->{'ikev2_optimize_initialization'})) {
		#
		# ifconfig.rmt
		#
		expand_ifconfig_setupNUT(\%ifconfig, $NUTconfiguration);
		for (my $i = 0; $i < $ifconfig{'ifconfig.num'}; $i++) {
			@remote_argument = ();

			push(@remote_argument,
			     'ifconfig.address=' . $ifconfig{"ifconfig.$i.address"});
			push(@remote_argument,
			     'ifconfig.address_family=' . $ifconfig{"ifconfig.$i.address_family"});
			push(@remote_argument,
			     'ifconfig.interface=' . $ifconfig{"ifconfig.$i.interface"});

			if(kRemote('ifconfig.rmt', '', @remote_argument)) {
				return($false);
			}
		}

		#
		# route.rmt
		#
		expand_route_setupNUT(\%route, $NUTconfiguration);
		@remote_argument = ();
		for my $key (sort(keys(%route))) {
			push(@remote_argument, "$key=$route{$key}");
		}

		if(kRemote('route.rmt', '', @remote_argument)) {
			return($false);
		}

	}

	#
	# ikev2.rmt
	#
	if(!$ikev2_global_setup) {
		@remote_argument = ();
		push(@remote_argument, "operation=stop");
		if(kRemote('ikev2.rmt', '', @remote_argument)) {
			return($false);
		}

		expand_ikev2_setupNUT(\%ikev2, $NUTconfiguration);
		@remote_argument = ();
		for my $key (sort(keys(%ikev2))) {
			push(@remote_argument, "$key=$ikev2{$key}");
		}

		if(kRemote('ikev2.rmt', '', @remote_argument)) {
			return($false);
		}
	}

	return($true);
}



sub
cleanupNUT()
{
	# setup=1&cleanup=1&optimize=1	[skip]	[skip]
	# setup=1&cleanup=1&optimize=0	[skip]	[skip]
	# setup=1&cleanup=0&optimize=1	[skip]	[skip]	setup
	# setup=1&cleanup=0&optimize=0	[skip]	[skip]	setup
	# setup=0&cleanup=1&optimize=0	[skip]	[skip]	cleanup

	# setup=0&cleanup=0&optimize=1	[skip]	[do]	generic

	# setup=0&cleanup=0&optimize=0	[do]	[do]	generic
	# setup=0&cleanup=1&optimize=1	[do]	[skip]	cleanup

	if($ikev2_global_setup) {
		return($true);
	}

	if($ikev2_global_cleanup && !$config_pl->{'ikev2_optimize_initialization'}) {
		return($true);
	}

	if($bool_remote_async) {
		kRemoteAsyncWait();
	}

	IKEv2log('cleaning up NUT ...');

	my @remote_argument = ();

	my %ifconfig = ();
	my %route = ();

	if(!$ikev2_global_cleanup) {
		#
		# ikev2.rmt
		#
		@remote_argument = ();
		push(@remote_argument, "operation=stop");
		if(kRemote('ikev2.rmt', '', @remote_argument)) {
			return($false);
		}
	}

	if(($ikev2_global_cleanup && $config_pl->{'ikev2_optimize_initialization'}) ||
(!$ikev2_global_cleanup && !$config_pl->{'ikev2_optimize_initialization'})) {
		#
		# route.rmt
		#
		expand_route_setupNUT(\%route, $NUTconfiguration);
		@remote_argument = ();
		push(@remote_argument, "operation=delete");
		for my $key (sort(keys(%route))) {
			push(@remote_argument, "$key=$route{$key}");
		}

		if(kRemote('route.rmt', '', @remote_argument)) {
			return($false);
		}
	}

	if(($ikev2_global_cleanup && $config_pl->{'ikev2_optimize_initialization'}) ||
	(!$ikev2_global_cleanup && !$config_pl->{'ikev2_optimize_initialization'})) {
		#
		# ifconfig.rmt
		#
		expand_ifconfig_setupNUT(\%ifconfig, $NUTconfiguration);
		for (my $i = 0; $i < $ifconfig{'ifconfig.num'}; $i++) {
			@remote_argument = ();

			push(@remote_argument, "operation=delete");
			push(@remote_argument,
			     'ifconfig.address=' . $ifconfig{"ifconfig.$i.address"});
			push(@remote_argument,
			     'ifconfig.address_family=' . $ifconfig{"ifconfig.$i.address_family"});
			push(@remote_argument,
			     'ifconfig.interface=' . $ifconfig{"ifconfig.$i.interface"});

			if(kRemote('ifconfig.rmt', '', @remote_argument)) {
				return($false);
			}
		}
	}

	return($true);
}



sub
expand_ifconfig_setupNUT($$)
{
	my ($configuration, $ref) = @_;

	return(expandConfigurationNUT($configuration, 'ifconfig', $ref->{'ifconfig'}));
}



sub
expand_route_setupNUT($$)
{
	my ($configuration, $ref) = @_;

	return(expandConfigurationNUT($configuration, 'route', $ref->{'route'}));
}



sub
expand_ikev2_setupNUT($$)
{
	my ($configuration, $ref) = @_;

	return(expandConfigurationNUT($configuration, 'ikev2', $ref->{'ikev2'}));
}



sub
expand_ikev2_selector_setupNUT($$)
{
	my ($configuration, $ref) = @_;

	return(expandConfigurationNUT($configuration, 'ikev2.selector', $ref->{'ikev2'}->{'selector'}));
}


sub
expand_ikev2_policy_setupNUT($$)
{
	my ($configuration, $ref) = @_;

	return(expandConfigurationNUT($configuration, 'ikev2.policy', $ref->{'ikev2'}->{'policy'}));
}


sub
expand_ikev2_sa_setupNUT($$)
{
	my ($configuration, $ref) = @_;

	return(expandConfigurationNUT($configuration, 'ikev2.sa', $ref->{'ikev2'}->{'sa'}));
}


sub
expandConfigurationNUT($$$)
{
	my ($base, $prefix, $ref) = @_;

	my $type = ref($ref);

	if($type eq 'HASH') {
		while(my ($key, $value) = each(%$ref)) {
			expandConfigurationNUT($base, sprintf("%s.%s", $prefix, $key), $value);
		}

		return;
	}

	if($type eq 'ARRAY') {
		my $d = 0;

		for($d = 0; $d <= $#$ref; $d ++) {
			expandConfigurationNUT($base, sprintf("%s.%d", $prefix, $d), $ref->[$d]);
		}

		$base->{"$prefix.num"} = $d;

		return;
	}

	$base->{$prefix} = $ref;

	return;
}



sub
loadTNdefault()
{
	if (ADDRESS_FAMILY != AF_INET6 && ADDRESS_FAMILY != AF_INET) {
		IKEv2exitFatal('<FONT COLOR="#ff0000">unknown address family (' .
			       ADDRESS_FAMILY . '). line '. __LINE__ .'</FONT>');
	}

	unless($scenario) {
		# Common Topology for End-Node: End-Node to End-Node

		if (ADDRESS_FAMILY == AF_INET6) {
			# TR1
			push(@r_addrs0, $addresses{'tr1_linklocal_linkA'} . "%$kCommon::TnDef{'Link0'}");
			push(@r_addrs0, $addresses{'tr1_global_linkA'});

			# TN1
			push(@v_addrs0, $addresses{'tn1_global_linkX'});
		}
		elsif (ADDRESS_FAMILY == AF_INET) {
			# TR1
			push(@r_addrs0, $addresses{'tr1_global_linkA'});
			# TN1
			push(@v_addrs0, $addresses{'tn1_global_linkX'});
		}

		return($true);
	}

	if($scenario == 1) {
		# Common Topology for End-Node: End-Node to SGW

		if (ADDRESS_FAMILY == AF_INET6) {
			# TR1
			push(@r_addrs0, $addresses{'tr1_linklocal_linkA'} . "%$kCommon::TnDef{'Link0'}");
			push(@r_addrs0, $addresses{'tr1_global_linkA'});

			# TN1
			push(@v_addrs0, $addresses{'tn1_global_linkX'});

			# TH1
			push(@v_addrs0, $addresses{'th1_global_linkY'});
		}
		elsif (ADDRESS_FAMILY == AF_INET) {
			# TR
			push(@r_addrs0, $addresses{'tr1_global_linkA'});

			# TN1
			push(@v_addrs0, $addresses{'tn1_global_linkX'});

			# TH1
			push(@v_addrs0, $addresses{'th1_global_linkY'});
		}

		return($true);
	}

	if($scenario == 2) {
		# Common Topology for SGW: SGW to SGW
		if (ADDRESS_FAMILY == AF_INET6) {
			# TH1
			push(@r_addrs1, $addresses{'th1_global_linkB'});

			# TR1
			push(@r_addrs0, $addresses{'tr1_linklocal_linkA'} . "%$kCommon::TnDef{'Link0'}");
			push(@r_addrs0, $addresses{'tr1_global_linkA'});

			# TN1
			push(@v_addrs0, $addresses{'tn1_global_linkX'});

			# TH2
			push(@v_addrs0, $addresses{'th2_global_linkY'});

			# TH3
			push(@v_addrs0, $addresses{'th3_global_linkY'});
		}
		elsif (ADDRESS_FAMILY == AF_INET) {
			# TH1
			push(@r_addrs1, $addresses{'th1_global_linkB'});

			# TR1
			push(@r_addrs0, $addresses{'tr1_global_linkA'});

			# TN1
			push(@v_addrs0, $addresses{'tn1_global_linkX'});

			# TH2
			push(@v_addrs0, $addresses{'th2_global_linkY'});

			# TH3
			push(@v_addrs0, $addresses{'th3_global_linkY'});
		}

		return($true);
	}

	if($scenario == 3) {
		# Common Topology for SGW: SGW to End-Node
		if (ADDRESS_FAMILY == AF_INET6) {
			# TH1
			push(@r_addrs1, $addresses{'th1_global_linkB'});

			# TR1
			push(@r_addrs0, $addresses{'tr1_linklocal_linkA'} . "%$kCommon::TnDef{'Link0'}");
			push(@r_addrs0, $addresses{'tr1_global_linkA'});

			# TN1
			push(@v_addrs0, $addresses{'tn1_global_linkX'});
		}
		elsif (ADDRESS_FAMILY == AF_INET) {
			# TH1
			push(@r_addrs1, $addresses{'th1_global_linkB'});

			# TR1
			push(@r_addrs0, $addresses{'tr1_global_linkA'});

			# TN1
			push(@v_addrs0, $addresses{'tn1_global_linkX'});
		}

		return($true);
	}

	return($false);
}



sub
loadNUTdefault()
{
	my $common_remote_index	= 'common_remote_index';
	my $common_policy_index	= 'common_policy_index';
	my $common_ipsec_index	= 'common_ipsec_index';
	my $common_sa_index	= 'common_sa_index';
	my $common_selector_index_outbound	= 'common_selector_index_outbound';
	my $common_selector_index_inbound	= 'common_selector_index_inbound';

	my $common_endpoint_nut	= $config_pl->{'ikev2_global_addr_nut_link0'};

	my $common_pre_shared_key_local	= $config_pl->{'ikev2_pre_shared_key_nut'};
	my $common_pre_shared_key_remote	= $config_pl->{'ikev2_pre_shared_key_tn'};

	if (ADDRESS_FAMILY != AF_INET6 && ADDRESS_FAMILY != AF_INET) {
		IKEv2exitFatal('<FONT COLOR="#ff0000">unknown address family (' .
			       ADDRESS_FAMILY . '). line '. __LINE__ .'</FONT>');
	}

	my %conf = (
		'ifconfig'	=> [
			{
				'interface'	=> $kCommon::NutDef{'Link0'},
				'address_family'=> (ADDRESS_FAMILY == AF_INET6) ?
							'inet6' : 'inet',
				'address'	=> (ADDRESS_FAMILY == AF_INET6) ?
							"$common_endpoint_nut/64" :
							"$common_endpoint_nut",
			},
		],
		'route'	=> [
			{
				'network'	=> (ADDRESS_FAMILY == AF_INET6) ?
							"$config_pl->{'ikev2_prefixX'}::/64" :
							"$config_pl->{'ikev2_prefixX'}/24",
				'gateway'	=> (ADDRESS_FAMILY == AF_INET6) ?
							"$addresses{'default_router'}%$kCommon::NutDef{'Link0'}" :
							"$config_pl->{'ikev2_link_local_addr_router_link0'}",
				'address_family'=> (ADDRESS_FAMILY == AF_INET6) ?
							'inet6' : 'inet',
				'interface'	=> $kCommon::NutDef{'Link0'},
			}
		],
		'ikev2' => {
			# 'setval'	=> {},
			# 'default'	=> {},
			'interface'	=> {
				'ike'	=> [
					{
						'address'	=> $common_endpoint_nut,
						'port'	=> '500'
					}
				],
				# 'spmd'	=> [
				# 	{
				# 		'unix'	=> '/var/run/racoon2/spmif'
				# 	}
				# ],
				# 'spmd_password'	=> '/usr/local/etc/racoon2/spmd.pwd'
			},
			# 'resolver'	=> {
			# 	'resolver'	=> 'off'
			# },
			'remote'	=> [
				{
					'remote_index'	=> $common_remote_index,
					# 'acceptable_kmp'	=> [
					# 	'ikev2'
					# ],
					'ikev2'	=> {
						'nonce_size'		=> {
						},
						'initial_contact'	=> {
							'initial_contact'	=> 'off'
						},
						'send_cert_req'	=> {
							'send_cert_req'	=> 'on'
						},
						'my_id'	=> {
							'ipaddr'	=> [
								$common_endpoint_nut,
							],
							'fqdn'	=> [
							],
							'rfc822addr'	=> [
							],
							'keyid'	=> [
							],
						},
						'peers_id'	=> {
							'ipaddr'	=> [
								$addresses{'common_endpoint_tn'},
							],
							'fqdn'	=> [
							],
							'rfc822addr'	=> [
							],
							'keyid'	=> [
							],
						},
						'peers_ipaddr'	=> {
							'address'	=> $addresses{'common_endpoint_tn'},
							'port'	=> '500'
						},
						'kmp_sa_lifetime_time' => $config_pl->{'ikev2_nut_ike_sa_lifetime'},
						'kmp_enc_alg'	=> [
							'3des_cbc'
						],
						'kmp_prf_alg'	=> [
							'hmac_sha1'
						],
						'kmp_hash_alg'	=> [
							'hmac_sha1'
						],
						'kmp_dh_group'	=> [
							'modp1024'
						],
						'kmp_auth_method'	=> [
							'psk'
						],
						'need_pfs'	=> 'off',
						'pre_shared_key'	=> {
							'local'	=> $common_pre_shared_key_local,
							'remote'	=> $common_pre_shared_key_remote
						}
					}
				}
			],
			'selector'	=> [
				{
					'selector_index'	=> $common_selector_index_outbound,
					'direction'	=> 'outbound',
					'src'	=> {
						'address'	=> $common_endpoint_nut,
						'address_family'=> (ADDRESS_FAMILY == AF_INET6) ?
									'inet6' : 'inet',
					},
					'dst'	=> {
						'address'	=> $addresses{'common_endpoint_tn'},
						'address_family'=> (ADDRESS_FAMILY == AF_INET6) ?
									'inet6' : 'inet',
					},
					'upper_layer_protocol'	=> {
						'protocol'	=> 'any'
					},
					'policy_index'	=> $common_policy_index
				},
				{
					'selector_index'	=> $common_selector_index_inbound,
					'direction'	=> 'inbound',
					'src'	=> {
						'address'	=> $addresses{'common_endpoint_tn'},
						'address_family'=> (ADDRESS_FAMILY == AF_INET6) ?
									'inet6' : 'inet',
					},
					'dst'	=> {
						'address'	=> $common_endpoint_nut,
						'address_family'=> (ADDRESS_FAMILY == AF_INET6) ?
									'inet6' : 'inet',
					},
					'upper_layer_protocol'	=> {
						'protocol'	=> 'any'
					},
					'policy_index'	=> $common_policy_index
				}
			],
			'policy'	=> [
				{
					'policy_index'	=> $common_policy_index,
					# 'action'	=> 'auto_ipsec',
					'ipsec_mode'	=> 'transport',
					# 'ipsec_level'	=> 'require',
					'ipsec_index'	=> [
						$common_ipsec_index
					],
					'remote_index'	=> $common_remote_index
				}
			],
			'ipsec'		=> [
				{
					'ipsec_index'	=> $common_ipsec_index,
					'ipsec_sa_lifetime_time' => $config_pl->{'ikev2_nut_child_sa_lifetime'},
					'ext_sequence'	=> 'off',
					'sa_index'	=> [
						$common_sa_index
					]
				}
			],
			'sa'		=> [
				{
					'sa_index'	=> $common_sa_index,
					'sa_protocol'	=> 'esp',
					'esp_enc_alg'	=> [
						'3des_cbc'
					],
					'esp_auth_alg'	=> [
						'hmac_sha1'
					]
				}
			],
			'addresspool'	=> [
				{
					'saddr' => '',
					'eaddr' => '',
				},
			],
		}
	);

	if($scenario == 0) {
		# Common Topology for End-Node: End-Node to End-Node

		# XXX

		return(\%conf);
	}

	if($scenario == 1) {
		# Common Topology for End-Node: End-Node to SGW

		if (ADDRESS_FAMILY == AF_INET6) {
			# set route
			my $route = $conf{'route'};
			my $r = undef;
			# add route to Link Y
			$r = {
				'network'	=> "$config_pl->{'ikev2_prefixY'}::/64",
				'gateway'	=> "$addresses{'default_router'}%$kCommon::NutDef{'Link0'}",
				'address_family'=> 'inet6',
				'interface'	=> $kCommon::NutDef{'Link0'},
			};
			push(@{$route}, $r);

			# set selector address
			my $selector = $conf{'ikev2'}->{'selector'};
			foreach my $sel (@{$selector}) {
				if ($sel->{'direction'} eq 'outbound') {
					#$sel->{'dst'}->{'address'} = $addresses{'th1_global_linkY'};
					$sel->{'dst'}->{'address'} = $addresses{'prefixY'};
				}
				elsif ($sel->{'direction'} eq 'inbound') {
					#$sel->{'src'}->{'address'} = $addresses{'th1_global_linkY'};
					$sel->{'src'}->{'address'} = $addresses{'prefixY'};
				}
			}

			# set policy.ipsec_mode
			my $policy = $conf{'ikev2'}->{'policy'};
			foreach my $pol (@{$policy}) {
				$pol->{'ipsec_mode'} = 'tunnel';

				$pol->{'my_sa_ipaddr'} = $common_endpoint_nut;

				$pol->{'peers_sa_ipaddr'} = $addresses{'common_endpoint_tn'};
			}
		}
		elsif (ADDRESS_FAMILY == AF_INET) {
			# set route
			my $route = $conf{'route'};
			my $r = undef;
			# add route to Link Y
			$r = {
				'network'	=> "$config_pl->{'ikev2_prefixY'}/24",
				'gateway'	=> "$config_pl->{'ikev2_link_local_addr_router_link0'}",
				'address_family'=> 'inet',
				'interface'	=> $kCommon::NutDef{'Link0'},
			};
			push(@{$route}, $r);

			# set selector address
			my $selector = $conf{'ikev2'}->{'selector'};
			foreach my $sel (@{$selector}) {
				if ($sel->{'direction'} eq 'outbound') {
					$sel->{'dst'}->{'address'} = $config_pl->{ikev2_prefixY}. '.15';
				}
				elsif ($sel->{'direction'} eq 'inbound') {
					$sel->{'src'}->{'address'} = $config_pl->{ikev2_prefixY}. '.15';
				}
			}

			# set policy.ipsec_mode
			my $policy = $conf{'ikev2'}->{'policy'};
			foreach my $pol (@{$policy}) {
				$pol->{'ipsec_mode'} = 'tunnel';

				$pol->{'my_sa_ipaddr'} = $common_endpoint_nut;

				$pol->{'peers_sa_ipaddr'} = $addresses{'common_endpoint_tn'};
			}
		}

		return(\%conf);
	}

	if($scenario == 2) {
		# Common Topology for SGW: SGW to SGW

		if (ADDRESS_FAMILY == AF_INET6) {
			# set route
			my $route = $conf{'route'};
			my $r = undef;
			# add route to Link Y
			$r = {
				'network'	=> "$config_pl->{'ikev2_prefixY'}::/64",
				'gateway'	=> "$addresses{'default_router'}%$kCommon::NutDef{'Link0'}",
				'address_family'=> 'inet6',
				'interface'	=> $kCommon::NutDef{'Link0'},
			};
			push(@{$route}, $r);

			# set selector address
			my $selector = $conf{'ikev2'}->{'selector'};
			foreach my $sel (@{$selector}) {
				if ($sel->{'direction'} eq 'outbound') {
					$sel->{'src'}->{'address'} = $addresses{'prefixB'};
					$sel->{'dst'}->{'address'} = $addresses{'prefixY'};
				}
				elsif ($sel->{'direction'} eq 'inbound') {
					$sel->{'src'}->{'address'} = $addresses{'prefixY'};
					$sel->{'dst'}->{'address'} = $addresses{'prefixB'};
				}
			}

			# set policy.ipsec_mode
			my $policy = $conf{'ikev2'}->{'policy'};
			foreach my $pol (@{$policy}) {
				$pol->{'ipsec_mode'} = 'tunnel';

				$pol->{'my_sa_ipaddr'} = $common_endpoint_nut; #$config_pl->{'ikev2_global_addr_nut_link0'};

				$pol->{'peers_sa_ipaddr'} = $addresses{'common_endpoint_tn'};
			}

			# set ifconfig
			my $ifconfig = $conf{'ifconfig'};
			$r = {
				'interface'	=> $kCommon::NutDef{'Link1'},
				'address_family'	=> 'inet6',
				'address'	=> "$config_pl->{'ikev2_global_addr_nut_link1'}/64",
			};
			push(@{$ifconfig}, $r);

			return(\%conf);
		}
		elsif (ADDRESS_FAMILY == AF_INET) {
			# set route
			my $route = $conf{'route'};
			my $r = undef;
			# add route to Link Y
			$r = {
				'network'	=> "$config_pl->{'ikev2_prefixY'}/24",
				'gateway'	=> "$config_pl->{'ikev2_link_local_addr_router_link0'}",
				'address_family'=> 'inet',
				'interface'	=> $kCommon::NutDef{'Link0'},
			};
			push(@{$route}, $r);

			# set selector address
			my $selector = $conf{'ikev2'}->{'selector'};
			foreach my $sel (@{$selector}) {
				if ($sel->{'direction'} eq 'outbound') {
					$sel->{'src'}->{'address'} = $config_pl->{ikev2_prefixB}. '.1';
					$sel->{'dst'}->{'address'} = $config_pl->{ikev2_prefixY}. '.1';
				}
				elsif ($sel->{'direction'} eq 'inbound') {
					$sel->{'src'}->{'address'} = $config_pl->{ikev2_prefixY}. '.1';
					$sel->{'dst'}->{'address'} = $config_pl->{ikev2_prefixB}. '.1';
				}
			}

			# set policy.ipsec_mode
			my $policy = $conf{'ikev2'}->{'policy'};
			foreach my $pol (@{$policy}) {
				$pol->{'ipsec_mode'} = 'tunnel';

				$pol->{'my_sa_ipaddr'} = $common_endpoint_nut; #$config_pl->{'ikev2_global_addr_nut_link0'};

				$pol->{'peers_sa_ipaddr'} = $addresses{'common_endpoint_tn'};
			}

			# set ifconfig
			my $ifconfig = $conf{'ifconfig'};
			$r = {
				'interface'	=> $kCommon::NutDef{'Link1'},
				'address_family'	=> 'inet',
				'address'	=> "$config_pl->{'ikev2_global_addr_nut_link1'}",
			};
			push(@{$ifconfig}, $r);

			return(\%conf);
		}
	}

	if($scenario == 3) {
		# Common Topology for SGW: SGW to End-Node

		if (ADDRESS_FAMILY == AF_INET6) {
			# set selector address
			my $selector = $conf{'ikev2'}->{'selector'};
			foreach my $sel (@{$selector}) {
				if ($sel->{'direction'} eq 'outbound') {
					$sel->{'src'}->{'address'} = $addresses{'prefixB'};
					$sel->{'dst'}->{'address'} = $addresses{'tn1_global_linkX'};
				}
				elsif ($sel->{'direction'} eq 'inbound') {
					$sel->{'src'}->{'address'} = $addresses{'tn1_global_linkX'};
					$sel->{'dst'}->{'address'} = $addresses{'prefixB'};
				}
			}

			# set policy.ipsec_mode
			my $policy = $conf{'ikev2'}->{'policy'};
			foreach my $pol (@{$policy}) {
				$pol->{'ipsec_mode'} = 'tunnel';

				$pol->{'my_sa_ipaddr'} = $common_endpoint_nut;

				$pol->{'peers_sa_ipaddr'} = $addresses{'common_endpoint_tn'};
			}

			# set ifconfig
			my $ifconfig = $conf{'ifconfig'};
			my $tmp = {
				'interface'	=> $kCommon::NutDef{'Link1'},
				'address_family'	=> 'inet6',
				'address'	=> "$config_pl->{'ikev2_global_addr_nut_link1'}/64",
			};
			push(@{$ifconfig}, $tmp);
		}
		elsif (ADDRESS_FAMILY == AF_INET) {
			# set selector address
			my $selector = $conf{'ikev2'}->{'selector'};
			foreach my $sel (@{$selector}) {
				if ($sel->{'direction'} eq 'outbound') {
					$sel->{'src'}->{'address'} = $config_pl->{ikev2_prefixB}. '.15';
					$sel->{'dst'}->{'address'} = $config_pl->{ikev2_prefixX}. '.15';
				}
				elsif ($sel->{'direction'} eq 'inbound') {
						$sel->{'src'}->{'address'} = $config_pl->{ikev2_prefixX}. '.15';
						$sel->{'dst'}->{'address'} = $config_pl->{ikev2_prefixB}. '.15';
				}
			}

			# set policy.ipsec_mode
			my $policy = $conf{'ikev2'}->{'policy'};
			foreach my $pol (@{$policy}) {
				$pol->{'ipsec_mode'} = 'tunnel';

				$pol->{'my_sa_ipaddr'} = $common_endpoint_nut;

				$pol->{'peers_sa_ipaddr'} = $addresses{'common_endpoint_tn'};
			}

			# set ifconfig
			my $ifconfig = $conf{'ifconfig'};
			my $tmp = {
				'interface'	=> $kCommon::NutDef{'Link1'},
				'address_family'	=> 'inet',
				'address'	=> "$config_pl->{'ikev2_global_addr_nut_link1'}",
			};
			push(@{$ifconfig}, $tmp);
		}

		return(\%conf);
	}

	return(undef);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2initiateNUT($)
{
	my ($index) = @_;

	my @remote_argument = ();
	my %ikev2 = ();

	if ($scenario == 0 || $scenario == 1) {
		#
		# ikev2.rmt
		#
		expand_ikev2_selector_with_index_NUT($index, \%ikev2, $NUTconfiguration);
		@remote_argument = ();
		for my $key (sort(keys(%ikev2))) {
			push(@remote_argument, "$key=$ikev2{$key}");
		}

		kPacket_Clear(0, 0, 0, 0);

		if ($scenario == 0) {
			push(@remote_argument, "target=$addresses{'tn1_global_linkX'}");
		}
		else {
			push(@remote_argument, "target=$addresses{'th1_global_linkY'}");
		}
		push(@remote_argument, "operation=initiate");
		if(kRemoteAsync('ikev2.rmt', '', @remote_argument)) {
			return($false);
		}

		$bool_remote_async = $true;

		return($true);
	}
	elsif ($scenario == 2) {
		kPacket_Clear(0, 0, 0, 0);

		my $cpp_ip_src_linkb = '2001:db8:1:2::f';
		my $cpp_ip_dst_linky = '2001:db8:f:2::f';

		my $cpp = '';
		$cpp .= "-DCPP_IP_TH2_LINKY=\\\"$cpp_ip_dst_linky\\\" ";
		$cpp .= "-DCPP_IP_TH1_LINKB=\\\"$cpp_ip_src_linkb\\\" ";

		kLogHTML("vCPP($cpp)");
		vCPP($cpp);

		vSend('Link1', 'ereq_initiate');

		return($true);
	}
	elsif ($scenario == 3) {
		kPacket_Clear(0, 0, 0, 0);

		my $cpp_ip_src_linkb = '2001:db8:1:2::f';
		my $cpp_ip_dst_linkx = '2001:db8:f:1::1';

		my $cpp = '';
		$cpp .= "-DCPP_IP_TN1_LINKX=\\\"$cpp_ip_dst_linkx\\\" ";
		$cpp .= "-DCPP_IP_TH1_LINKB=\\\"$cpp_ip_src_linkb\\\" ";

		kLogHTML("vCPP($cpp)");
		vCPP($cpp);

		vSend('Link1', 'ereq_initiate');

		return($true);
	}

	return($false);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2waitNUT()
{
	return(kCommon::kRemoteAsyncWait());
}



sub
expand_ikev2_selector_with_index_NUT($$$)
{
	my ($index, $configuration, $ref) = @_;

	my $selector = $ref->{'ikev2'}->{'selector'};

	for(my $d = 0; $d <= $#$selector; $d ++) {
		if($selector->[$d]->{'selector_index'} eq $index) {
			return(expandConfigurationNUT($configuration, "selector", $selector->[$d]));
		}
	}

	$configuration = undef;

	return;
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2send($$;$)
{
	my ($session, $data, $material) = @_;

	kPacket_Clear(0, 0, 0, 0);
	my $ret = $session->send($data, length($data), $ike_sa_keymats{$material});
	unless(defined($ret)) {
		return(undef);
	}

	my @decoded = decode($data, $material);
	$ret = collect(\@decoded);
	return($ret);
}

sub IKEv2build($$$)
{
	my ($msg, $material, $is_initiator) = @_;
	my $ret = kIKE::kIKE::kBuildIKEv2($msg, $material, $is_initiator);
	return($ret);
}

sub
devel_IKEv2send_IKE_SA_INIT_request($$)
{
	my ($session, $index) = @_;

	my $req = kIKE::kHelpers::cloneStructure($gen_ike_sa_init_req->{$index});
	my $dh = undef;

	for(my $d = 0; $d <= $#$req; $d ++) {
		if($req->[$d]->{'self'} eq 'HDR') {
			my $header = $req->[$d];

			if($header->{'initSPI'} eq 'generate') {
				my $initSPI = Math::BigInt->new(makerandom(Size => 64, Strength => 0));

				$req->[$d]->{'initSPI'} = kIKE::kHelpers::as_hex2($initSPI, $IKE_SA_SPI_STRLEN);
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'KE') {
			my $payload = $req->[$d];
			my $publicKey = undef;

			my $group =
				(defined($payload->{'group'}) && ($payload->{'group'} !~ /^\s*auto\s*$/i)) ?
					kTransformTypeID(kTransformType('D-H'), $payload->{'group'}):
					0;

			($dh, $publicKey) = kGenDHPublicKey($group);
			if ($payload->{'publicKey'} eq 'generate') {
				my $dhlen = $dh_group_bitlen->{$group} / 4;
				$req->[$d]->{'publicKey'} = kIKE::kHelpers::as_hex2($publicKey, $dhlen);
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'Ni, Nr') {
			my $payload = $req->[$d];

			if($payload->{'nonce'} eq 'generate') {
				my $length = int(rand(240)) + 16;
				my $nonce = Math::BigInt->new(makerandom(Size => ($length * 8), Strength => 0));

				$req->[$d]->{'nonce'} = kIKE::kHelpers::as_hex2($nonce, $length * 2);
			}
		}
	}

	my $raw = kBuildIKEv2($req);
	unless(defined($raw)) {
		return(undef);
	}

	kPacket_Clear(0, 0, 0, 0);
	my $ret = $session->send($raw, length($raw));
	unless(defined($ret)) {
		return(undef);
	}



	my @decoded = decode($raw);
	my $ike_sa_init_req = collect(\@decoded);
	$ike_sa_init_req->{'data'} = $raw;
	$ike_sa_init_req->{'dh'} = $dh;

	return($ike_sa_init_req);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
devel_IKEv2receive_IKE_SA_INIT_request($$)
{
	my ($session, $indices) = @_;

	my $ret = $session->recv();
	unless (defined($ret)) {
		return(undef);
	}

	my $raw = $ret->{'Data'};

	my @decoded = decode($raw);

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("<pre>Compare the received packet with packets($str)</pre>");

	my $matched_index = undef;
	foreach my $index (@{$indices}) {
		my $expected = kIKE::kHelpers::cloneStructure($exp_ike_sa_init_req->{$index});

		my $prepareRes = kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_ike_sa_init_req->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return(undef);
	}

	my $ike_sa_init_req = collect(\@decoded);
	$ike_sa_init_req->{'data'} = $raw;
	$ike_sa_init_req->{'matched_index'} = $matched_index;

	return($ike_sa_init_req);
}

#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
devel_IKEv2send_IKE_SA_INIT_response($$$)
{
	my ($session, $index, $ike_sa_init_req) = @_;

	my $resp = kIKE::kHelpers::cloneStructure($gen_ike_sa_init_resp->{$index});
	my $dh = undef;

	for(my $d = 0; $d <= $#$resp; $d ++) {
		if($resp->[$d]->{'self'} eq 'HDR') {
			my $header = $resp->[$d];

			if($header->{'initSPI'} eq 'read') {
				$resp->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
			}

			if($header->{'respSPI'} eq 'generate') {
				my $respSPI = Math::BigInt->new(makerandom(Size => 64, Strength => 0));

				$resp->[$d]->{'respSPI'} = kIKE::kHelpers::as_hex2($respSPI, $IKE_SA_SPI_STRLEN);
			}

			if($header->{'messID'} eq 'read') {
				$resp->[$d]->{'messID'} = $ike_sa_init_req->{'messID'};
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'KE') {
			my $payload = $resp->[$d];

			if($payload->{'publicKey'} eq 'generate') {
				my $group =
					(defined($payload->{'group'}) && ($payload->{'group'} !~ /^\s*auto\s*$/i))?
						kTransformTypeID(kTransformType('D-H'), $payload->{'group'}):
						0;
				my $publicKey = undef;

				($dh, $publicKey) = kGenDHPublicKey($group);

				my $dhlen = $dh_group_bitlen->{$group} / 4;
				$resp->[$d]->{'publicKey'} = kIKE::kHelpers::as_hex2($publicKey, $dhlen);
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'Ni, Nr') {
			my $payload = $resp->[$d];

			if($payload->{'nonce'} eq 'generate') {
				my $length = int(rand(240)) + 16;
				my $nonce = Math::BigInt->new(makerandom(Size => ($length * 8), Strength => 0));

				$resp->[$d]->{'nonce'} = kIKE::kHelpers::as_hex2($nonce, $length * 2);
			}
		}

		if($resp->[$d]->{'self'} eq 'N' && $resp->[$d]->{'type'} eq 'COOKIE') {
			my $payload = $resp->[$d];

			if($payload->{'data'} eq 'generate') {
				my $cookie_datalen = 32;
				my $cookie = Math::BigInt->new(makerandom('Size' => $cookie_datalen, 'Strength' => 0));

				$resp->[$d]->{'data'} = kIKE::kHelpers::as_hex2($cookie, $cookie_datalen / 4);
			}
		}
	}

	my $raw = kBuildIKEv2($resp);
	unless(defined($raw)) {
		return(undef);
	}

	kPacket_Clear(0, 0, 0, 0);
	my $ret = $session->send($raw, length($raw));
	unless(defined($ret)) {
		return(undef);
	}

	my @decoded = decode($raw);

	my $ike_sa_init_resp = collect(\@decoded);
	$ike_sa_init_resp->{'dh'} = $dh;
	$ike_sa_init_resp->{'data'} = $raw;

	return($ike_sa_init_resp);
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
devel_IKEv2receive_IKE_SA_INIT_response($$$)
{
	my ($session, $indices, $ike_sa_init_req) = @_;

	my $ret = $session->recv();
	unless (defined($ret)) {
		return(undef);
	}

	my $raw = $ret->{'Data'};

	my @decoded = decode($raw);

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	my $matched_index = undef;
	foreach my $index (@{$indices}) {
		# prepare expected
		my $expected = kIKE::kHelpers::cloneStructure($exp_ike_sa_init_resp->{$index});

		for(my $d = 0; $d <= $#$expected; $d ++) {
			if($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if($header->{'initSPI'} eq 'read') {
					$expected->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
				}

				if($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = $ike_sa_init_req->{'messID'};
				}

				last;
			}
		}

		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_ike_sa_init_resp->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return(undef);
	}

	my $ike_sa_init_resp = collect(\@decoded);
	if (defined($ike_sa_init_resp->{'public'}) && defined($ike_sa_init_req->{'dh'})) {
		my $shared_secret = kComputeDHSharedSecret($ike_sa_init_req->{'dh'},
							   $ike_sa_init_resp->{'public'});
		$ike_sa_init_resp->{'secret'} = $shared_secret;
	}
	$ike_sa_init_resp->{'data'} = $raw;
	$ike_sa_init_resp->{'matched_index'} = $matched_index;

	return($ike_sa_init_resp);
}

sub
devel_IKEv2receive_IKE_SA_INIT_response2($$$)
{
	my ($session, $indices, $ike_sa_init_req) = @_;

	my $received = undef;
	my $matched_index = undef;
	my $ret = $session->recv();
	unless (defined($ret)) {
		return($received, $matched_index);
	}
	$received = $true;

	my $raw = $ret->{'Data'};

	my @decoded = decode($raw);

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	foreach my $index (@{$indices}) {
		# prepare expected
		my $expected = kIKE::kHelpers::cloneStructure($exp_ike_sa_init_resp->{$index});

		for(my $d = 0; $d <= $#$expected; $d ++) {
			if($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if($header->{'initSPI'} eq 'read') {
					$expected->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
				}

				if($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = $ike_sa_init_req->{'messID'};
				}

				last;
			}
		}

		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_ike_sa_init_resp->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return($received, $matched_index);
	}

	my $ike_sa_init_resp = collect(\@decoded);
	if (defined($ike_sa_init_resp->{'public'}) && defined($ike_sa_init_req->{'dh'})) {
		my $shared_secret = kComputeDHSharedSecret($ike_sa_init_req->{'dh'},
							   $ike_sa_init_resp->{'public'});
		$ike_sa_init_resp->{'secret'} = $shared_secret;
	}
	$ike_sa_init_resp->{'data'} = $raw;
	$ike_sa_init_resp->{'matched_index'} = $matched_index;

	return($received, $ike_sa_init_resp);
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub IKEv2fill_IKE_AUTH_request($$$$$)
{
	my ($session, $index, $ike_sa_init_req, $ike_sa_init_resp, $material) = @_;

	if ($scenario) {
		use_tunnel_mode($gen_ike_auth_req, $index, 1);
	}

	my $req = kIKE::kHelpers::cloneStructure($gen_ike_auth_req->{$index});
	my $id = undef;
	my $auth = undef;
	my $is_initiator = $true;

	for(my $d = 0; $d <= $#$req; $d ++) {
		if($req->[$d]->{'self'} eq 'HDR') {
			my $header = $req->[$d];

			if($header->{'initSPI'} eq 'read') {
				$req->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
			}

			if($header->{'respSPI'} eq 'read') {
				$req->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
			}

			if($header->{'messID'} eq 'read') {
				$req->[$d]->{'messID'} = $ike_sa_init_req->{'messID'} + 1;
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'IDi') {
			my $payload = $req->[$d];

			# XXX ID expand

			if($payload->{'value'} eq 'read') {
				$req->[$d]->{'value'} = $addresses{'common_endpoint_tn'};
			}

			$id = $req->[$d];

			next;
		}

		if ($req->[$d]->{'self'} eq 'AUTH') {
			$auth = $req->[$d];
			next;
		}

		if($req->[$d]->{'self'} eq 'SA') {
			my $payload = $req->[$d];
			my $proposals = $payload->{'proposals'};

			for(my $i = 0; $i <= $#$proposals; $i ++) {
				my $proposal = $proposals->[$i];

				if(($proposal->{'id'} eq 'ESP') && ($proposal->{'spi'} eq 'generate')) {
					my $spi = Math::BigInt->new(makerandom(Size =>32, Strength => 0));
					$req->[$d]->{'proposals'}->[$i]->{'spi'} = kIKE::kHelpers::as_hex2($spi, $CHILD_SA_SPI_STRLEN);
				}
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'TSi') {
			my $payload = $req->[$d];
			my $selectors = $payload->{'selectors'};

			for(my $i = 0; $i <= $#$selectors; $i ++) {
				my $selector = $selectors->[$i];

				if($selector->{'saddr'} eq 'read') {
					$req->[$d]->{'selectors'}->[$i]->{'saddr'} =
						read_TSi_saddr($is_initiator);
				}

				if($selector->{'eaddr'} eq 'read') {
					$req->[$d]->{'selectors'}->[$i]->{'eaddr'} =
						read_TSi_eaddr($is_initiator);
				}
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'TSr') {
			my $payload = $req->[$d];
			my $selectors = $payload->{'selectors'};

			for(my $i = 0; $i <= $#$selectors; $i ++) {
				my $selector = $selectors->[$i];

				if($selector->{'saddr'} eq 'read') {
					$req->[$d]->{'selectors'}->[$i]->{'saddr'} =
						read_TSr_saddr($is_initiator);
				}

				if($selector->{'eaddr'} eq 'read') {
					$req->[$d]->{'selectors'}->[$i]->{'eaddr'} =
						read_TSr_eaddr($is_initiator);
				}
			}
		}
	}

	for(my $d = 0; $d <= $#$req; $d ++) {
		if($req->[$d]->{'self'} eq 'AUTH') {
			my $payload = $req->[$d];

			if($payload->{'data'} eq 'generate') {
				my $auth_data =
					kCalcAuthenticationData($material,
								$is_initiator,
								$req->[$d],
								($auth->{'method'} eq 'SK_MIC') ? $config_pl->{'ikev2_pre_shared_key_tn'} : TN_PRIVATE_KEY_FILE,
								($auth->{'method'} eq 'SK_MIC') ? undef : TN_CERT_FILE,
								$ike_sa_init_req->{'data'},
								$ike_sa_init_resp->{'nonce'},
								$ike_sa_init_resp->{'nonceLen'} * 2, # nonce string length
								$id);
				unless(defined($auth_data)) {
					return(undef);
				}

				$req->[$d]->{'data'} = $auth_data;
			}

			last;
		}
	}

	return($req);
}

sub
devel_IKEv2send_IKE_AUTH_request($$$$$)
{
	my ($session, $index, $ike_sa_init_req, $ike_sa_init_resp, $material) = @_;

	my $req = undef;
	$req = IKEv2fill_IKE_AUTH_request($session,
					  $index,
					  $ike_sa_init_req,
					  $ike_sa_init_resp,
					  $material);

	my $raw = kBuildIKEv2($req, $material, $true);
	unless(defined($raw)) {
		return(undef);
	}

	kPacket_Clear(0, 0, 0, 0);
	my $ret = $session->send($raw, length($raw), $ike_sa_keymats{$material});
	unless(defined($ret)) {
		return(undef);
	}

	my @decoded = decode($raw, $material);
	my $ike_auth_req = collect(\@decoded);
	$ike_auth_req->{'data'} = $raw;

	return($ike_auth_req);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
# calculate and compare Authentication Data
sub IKEv2authenticate($$$$$)
{
	my ($is_initiator, $material, $ike_sa_init_req, $ike_sa_init_resp, $msg) = @_;

	my $exp_auth_data = undef;
	my $rcv_id = undef;
	my $rcv_auth = undef;
	my $rcv_auth_data = undef;
	my $rcv_cert = undef;
	my $rcv_cert_data = undef;
	my $payload_type = $msg->[0]->{'nexttype'};
	my $msg_data = undef;
	my $nonce = undef;
	my $nonce_len = undef;

	if ($is_initiator) {
		$msg_data = $ike_sa_init_req->{'data'};
		$nonce = $ike_sa_init_resp->{'nonce'};
		$nonce_len = $ike_sa_init_resp->{'nonceLen'} * 2; # nonce string length
	}
	else {
		$msg_data = $ike_sa_init_resp->{'data'};
		$nonce = $ike_sa_init_req->{'nonce'};
		$nonce_len = $ike_sa_init_req->{'nonceLen'} * 2; # nonce string length
	}

	foreach my $payload1 (@{$msg}) {
		if ($payload_type eq 'E') {
			my $innerPayloads = $payload1->{'innerPayloads'};
			$payload_type = $payload1->{'innerType'};
			foreach my $payload2 (@{$innerPayloads}) {
				if ($is_initiator && $payload_type eq 'IDi') {
					$rcv_id = $payload2;
				}
				elsif (!$is_initiator && $payload_type eq 'IDr') {
					$rcv_id = $payload2;
				}
				elsif ($payload_type eq 'AUTH') {
					$rcv_auth = $payload2;
					$rcv_auth_data = $payload2->{'data'};
				}
				elsif ($payload_type eq 'CERT') {
					$rcv_cert = $payload2;
					$rcv_cert_data = $payload2->{'cert_data'};
				}
				$payload_type = $payload2->{'nexttype'};
			}
		}

		$payload_type = $payload1->{'nexttype'};
	}

	my $ret = 1;
	unless (defined($rcv_auth) && defined($rcv_id)) {
		return($ret);
	}

	my $exp_auth_data =
		kCalcAuthenticationData($material,
					$is_initiator, # NUT is initiator
					$rcv_auth,
					($rcv_auth->{'method'} eq 'SK_MIC') ? $config_pl->{'ikev2_pre_shared_key_tn'} : NUT_PRIVATE_KEY_FILE,
					($rcv_auth->{'method'} eq 'SK_MIC') ? undef : NUT_CERT_FILE,
					$msg_data,
					$nonce,
					$nonce_len,
					$rcv_id);

	if ($rcv_cert) {
		$exp_auth_data = unpack('H*', $exp_auth_data);
	}
	else {
		$exp_auth_data = unpack('H*', $exp_auth_data);
	}

	my $str = '<pre><b>Check Authentication: ';
	if ($exp_auth_data ne $rcv_auth_data) {
		$ret = undef;
		$str .= '<FONT COLOR="#ff0000">NG</FONT>';
	}
	else {
		$str .= 'OK';
	}
	$str .= "</b>\n";

	$str .= 'expected(' . $exp_auth_data . ")\n";
	$str .= 'received(' . $rcv_auth_data . ")";
	$str .= '</pre>';
	IKEv2log($str);

	return($ret);
}

sub
devel_IKEv2receive_IKE_AUTH_request($$$$$)
{
	my ($session, $indices, $ike_sa_init_req, $ike_sa_init_resp, $material) = @_;

	my $ret = $session->recv($ike_sa_keymats{$material});
	unless (defined($ret)) {
		return(undef);
	}

	my @decoded = decode($ret->{'Data'}, $material);
	my $is_initiator = $false;
	unless (IKEv2authenticate(!$is_initiator,
				  $material,
				  $ike_sa_init_req,
				  $ike_sa_init_resp,
				  \@decoded)) {
		return(undef);
	}

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	my $matched_index = undef;
	foreach my $index (@{$indices}) {
		# prepare expected
		if ($scenario) {
			use_tunnel_mode($exp_ike_auth_req, $index, 0);
		}

		my $expected = kIKE::kHelpers::cloneStructure($exp_ike_auth_req->{$index});

		for (my $d = 0; $d <= $#$expected; $d ++) {
			if ($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if ($header->{'initSPI'} eq 'read') {
					$expected->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
				}

				if ($header->{'respSPI'} eq 'read') {
					$expected->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
				}

				if ($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = $ike_sa_init_req->{'messID'} + 1;
				}

				next;
			}

			if ($expected->[$d]->{'self'} eq 'E') {
				my $payload = $expected->[$d];
				my $innerPayloads = $payload->{'innerPayloads'};

				for (my $i = 0; $i <= $#$innerPayloads; $i ++) {
					if ($innerPayloads->[$i]->{'self'} eq 'IDi') {
						my $payload = $innerPayloads->[$i];

						if ($payload->{'value'} eq 'read') {
							$expected->[$d]->{'innerPayloads'}->[$i]->{'value'}
								= ipaddr_tobin($config_pl->{'ikev2_global_addr_nut_link0'});
						}

						next;
					}

					if ($innerPayloads->[$i]->{'self'} eq 'TSi') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSi_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSi_eaddr($is_initiator));
							}
						}

						next;
					}

					if ($innerPayloads->[$i]->{'self'} eq 'TSr') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSr_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSr_eaddr($is_initiator));
							}
						}
					}
				}
			}
		}

		# check payload order and complement expected payload
		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_ike_auth_req->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return(undef);
	}

	my $ike_auth_req = collect(\@decoded);

	return($ike_auth_req);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2send_IKE_AUTH_response($$$$$)
{
	return(devel_IKEv2send_IKE_AUTH_response(@_));
}

sub
devel_IKEv2send_IKE_AUTH_response($$$$$;$)
{
	my ($session, $index, $ike_sa_init_req, $ike_sa_init_resp, $material, $send) = @_;

	if ($scenario) {
		use_tunnel_mode($gen_ike_auth_resp, $index, 1);
	}

	my $resp = kIKE::kHelpers::cloneStructure($gen_ike_auth_resp->{$index});
	my $id = undef;
	my $auth = undef;
	my $is_initiator = $false;

	for(my $d = 0; $d <= $#$resp; $d ++) {
		if($resp->[$d]->{'self'} eq 'HDR') {
			my $header = $resp->[$d];

			if($header->{'initSPI'} eq 'read') {
				$resp->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
			}

			if($header->{'respSPI'} eq 'read') {
				$resp->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
			}

			if($header->{'messID'} eq 'read') {
				$resp->[$d]->{'messID'} = $ike_sa_init_req->{'messID'} + 1;
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'IDr') {

			my $payload = $resp->[$d];

			# XXX ID expand

			if($payload->{'value'} eq 'read') {
				$resp->[$d]->{'value'} = $addresses{'common_endpoint_tn'};
			}

			$id = $resp->[$d];

			next;
		}

		if ($resp->[$d]->{'self'} eq 'AUTH') {
			$auth = $resp->[$d];
			next;
		}

		if($resp->[$d]->{'self'} eq 'SA') {
			my $payload = $resp->[$d];
			my $proposals = $payload->{'proposals'};

			for(my $i = 0; $i <= $#$proposals; $i ++) {
				my $proposal = $proposals->[$i];

				if(($proposal->{'id'} eq 'ESP') && ($proposal->{'spi'} eq 'generate')) {
					my $spi = Math::BigInt->new(makerandom(Size =>32, Strength => 0));
					$resp->[$d]->{'proposals'}->[$i]->{'spi'} = kIKE::kHelpers::as_hex2($spi, $CHILD_SA_SPI_STRLEN);
				}
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'TSi') {
			my $payload = $resp->[$d];
			my $selectors = $payload->{'selectors'};

			for(my $i = 0; $i <= $#$selectors; $i ++) {
				my $selector = $selectors->[$i];

				if($selector->{'saddr'} eq 'read') {
					$resp->[$d]->{'selectors'}->[$i]->{'saddr'} =
						read_TSi_saddr($is_initiator);
				}

				if($selector->{'eaddr'} eq 'read') {
					$resp->[$d]->{'selectors'}->[$i]->{'eaddr'} =
						read_TSi_eaddr($is_initiator);
				}
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'TSr') {
			my $payload = $resp->[$d];
			my $selectors = $payload->{'selectors'};

			for(my $i = 0; $i <= $#$selectors; $i ++) {
				my $selector = $selectors->[$i];

				if($selector->{'saddr'} eq 'read') {
					$resp->[$d]->{'selectors'}->[$i]->{'saddr'} =
						read_TSr_saddr($is_initiator);
				}

				if($selector->{'eaddr'} eq 'read') {
					$resp->[$d]->{'selectors'}->[$i]->{'eaddr'} =
						read_TSr_eaddr($is_initiator);
				}
			}
		}
	}

	for(my $d = 0; $d <= $#$resp; $d ++) {
		if($resp->[$d]->{'self'} eq 'AUTH') {
			my $payload = $resp->[$d];

			if($payload->{'data'} eq 'generate') {
				my $auth_data =
					kCalcAuthenticationData($material,
								$is_initiator,
								$resp->[$d],
								($auth->{'method'} eq 'SK_MIC') ? $config_pl->{'ikev2_pre_shared_key_tn'} : TN_PRIVATE_KEY_FILE,
								($auth->{'method'} eq 'SK_MIC') ? undef : TN_CERT_FILE,
								$ike_sa_init_resp->{'data'},
								$ike_sa_init_req->{'nonce'},
								$ike_sa_init_req->{'nonceLen'} * 2, # nonce string length
								$id);

				unless(defined($auth_data)) {
					return(undef);
				}

				$resp->[$d]->{'data'} = $auth_data;
			}

			last;
		}
	}

	my $raw = kBuildIKEv2($resp, $material, $is_initiator);
	unless(defined($raw)) {
		return(undef);
	}

	if (!defined($send) || $send) {
		kPacket_Clear(0, 0, 0, 0);
		my $ret = $session->send($raw, length($raw), $ike_sa_keymats{$material});
		unless(defined($ret)) {
			return(undef);
		}
	}

	my @decoded = decode($raw, $material);
	my $ike_auth_resp = collect(\@decoded);

	return($ike_auth_resp);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub remove_use_transport_mode_from_gen($$)
{
	my ($pkt_def, $index) = @_;

	# remove N(USE_TRANSPORT_MODE) to use tunnel mode
	my $gen = $pkt_def->{$index};
	my @tmp = grep {
		my $ret = 0;
		if ($_->{'self'} ne 'N') { $ret = 1; }
		if ($_->{'type'} ne 'USE_TRANSPORT_MODE') { $ret = 1; }
		$ret;
	} @{$gen};

	$pkt_def->{$index} = \@tmp;
}

sub remove_use_transport_mode_from_exp($$)
{
	my ($pkt_def, $index) = @_;

	# remove N(USE_TRANSPORT_MODE) to use tunnel mode
	my $exp = $pkt_def->{$index};
	my @tmp = @{$exp};
	foreach my $payload (@tmp) {
		if ($payload->{'self'} eq 'E') {
			my @payloads = grep {
				my $ret = 0;
				if ($_->{'self'} ne 'N') { $ret = 1; }
				if ($_->{'type'} ne 'USE_TRANSPORT_MODE') { $ret = 1; }
				$ret;
			} @{$payload->{'innerPayloads'}};

			$payload->{'innerPayloads'} = \@payloads;
		}
	}

	# set correct nexttype
	for (my $i = 0; $i < scalar(@tmp); $i++) {
		my $payload = $tmp[$i];

		if ($payload->{'self'} eq 'E') {
			my $num = scalar(@{$payload->{'innerPayloads'}});
			if ($num) {
				$payload->{'innerType'} = $payload->{'innerPayloads'}->[0]->{'self'};
			}
			else {
				$payload->{'innerType'} = '0';
			}

			for (my $j = 0; $j < scalar(@{$payload->{'innerPayloads'}}); $j++) {
				my $cur = $payload->{'innerPayloads'}->[$j];
				my $next = $payload->{'innerPayloads'}->[$j+1];
				unless (defined($next)) {
					$cur->{'nexttype'} = '0';
					next;
				}
				$cur->{'nexttype'} = $next->{'self'};
			}

			next;
		}
	}

	$pkt_def->{$index} = \@tmp;
}


sub
devel_IKEv2receive_IKE_AUTH_response($$$$$$)
{
	my ($session, $indices, $ike_sa_init_req, $ike_sa_init_resp, $ike_auth_req, $material) = @_;

	my $ret = $session->recv($ike_sa_keymats{$material});
	unless (defined($ret)) {
		return(undef);
	}

	my @decoded = decode($ret->{'Data'}, $material);
	my $is_initiator = $true;
	unless (IKEv2authenticate(!$is_initiator,
				  $material,
				  $ike_sa_init_req,
				  $ike_sa_init_resp,
				  \@decoded)) {
		return(undef);
	}

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	my $matched_index = undef;
	foreach my $index (@{$indices}) {
		# prepare expected
		if ($scenario) {
			use_tunnel_mode($exp_ike_auth_resp, $index, 0);
		}

		my $expected = kIKE::kHelpers::cloneStructure($exp_ike_auth_resp->{$index});

		for(my $d = 0; $d <= $#$expected; $d ++) {
			if($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if($header->{'initSPI'} eq 'read') {
					$expected->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
				}

				if($header->{'respSPI'} eq 'read') {
					$expected->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
				}

				if($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = $ike_auth_req->{'messID'};
				}

				next;
			}

			if($expected->[$d]->{'self'} eq 'E') {
				my $payload = $expected->[$d];
				my $innerPayloads = $payload->{'innerPayloads'};

				for (my $i = 0; $i <= $#$innerPayloads; $i ++) {
					if ($innerPayloads->[$i]->{'self'} eq 'IDr') {
						my $payload = $innerPayloads->[$i];

						if ($payload->{'value'} eq 'read') {
							$expected->[$d]->{'innerPayloads'}->[$i]->{'value'}
								= ipaddr_tobin($config_pl->{'ikev2_global_addr_nut_link0'});
						}

						next;
					}

					if ($innerPayloads->[$i]->{'self'} eq 'TSi') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSi_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSi_eaddr($is_initiator));
							}
						}

						next;
					}

					if ($innerPayloads->[$i]->{'self'} eq 'TSr') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSr_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSr_eaddr($is_initiator));
							}
						}
					}
				}
			}
		}

		# check payload order and complement expected payload
		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_ike_auth_resp->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return(undef);
	}

	my $ike_auth_resp = collect(\@decoded);

	return($ike_auth_resp);
}



sub
devel_IKEv2send_CREATE_CHILD_SA_request($$$$$$)
{
	my ($session, $index, $ike_sa_init_req, $ike_sa_init_resp, $prev_msg_req, $material) = @_;

	if ($scenario) {
		use_tunnel_mode($gen_create_child_sa_req, $index, 1);
	}

	my $req = kIKE::kHelpers::cloneStructure($gen_create_child_sa_req->{$index});
	my $dh = undef;
	my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};

	for(my $d = 0; $d <= $#$req; $d ++) {
		if($req->[$d]->{'self'} eq 'HDR') {
			my $header = $req->[$d];

			if($header->{'initSPI'} eq 'read') {
				$req->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
			}

			if($header->{'respSPI'} eq 'read') {
				$req->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
			}

			if($header->{'messID'} eq 'read') {
				$req->[$d]->{'messID'} = $ike_sa_keymats{$material}->{'is_initiator'} ?
							$ike_sa_keymats{$material}->{'initiator_msg_id'}++:
							$ike_sa_keymats{$material}->{'responder_msg_id'}++;
			}

			if($header->{'initiator'} eq 'read') {
				$req->[$d]->{'initiator'} = $is_initiator ? '1' : '0';
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'N' && $req->[$d]->{'type'} eq 'REKEY_SA') {
			my $payload = $req->[$d];

			if($payload->{'spi'} eq 'read') {
				$req->[$d]->{'spi'} = read_N_REKEY_spi();
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'SA') {
			my $payload = $req->[$d];
			my $proposals = $payload->{'proposals'};

			for(my $i = 0; $i <= $#$proposals; $i ++) {
				my $proposal = $proposals->[$i];
				my $spi_size = undef;
				my $spi = undef;

				if ($proposal->{'spi'} eq 'generate') {
					$spi_size = ($proposal->{'id'} eq 'IKE') ?
						$IKE_SA_SPI_STRLEN * 4 :
						$CHILD_SA_SPI_STRLEN * 4;
				}
				$spi = Math::BigInt->new(makerandom(Size => $spi_size, Strength => 0));
				$req->[$d]->{'proposals'}->[$i]->{'spi'} = kIKE::kHelpers::as_hex2($spi, $spi_size / 4);
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'Ni, Nr') {
			my $payload = $req->[$d];

			if($payload->{'nonce'} eq 'generate') {
				my $length = int(rand(240)) + 16;
				my $nonce = Math::BigInt->new(makerandom(Size => ($length * 8), Strength => 0));

				$req->[$d]->{'nonce'} = kIKE::kHelpers::as_hex2($nonce, $length * 2);
			}
		}

		if($req->[$d]->{'self'} eq 'KE') {
			my $payload = $req->[$d];

			if($payload->{'publicKey'} eq 'generate') {
				my $group =
					(defined($payload->{'group'}) && ($payload->{'group'} !~ /^\s*auto\s*$/i))?
						kTransformTypeID(kTransformType('D-H'), $payload->{'group'}):
						0;
				my $publicKey = undef;

				($dh, $publicKey) = kGenDHPublicKey($group);

				$req->[$d]->{'publicKey'} = substr($publicKey->as_hex, 2);
				my $dhlen = $dh_group_bitlen->{$group} / 4;
				$req->[$d]->{'publicKey'} = kIKE::kHelpers::as_hex2($publicKey, $dhlen);
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'TSi') {
			my $payload = $req->[$d];
			my $selectors = $payload->{'selectors'};

			for(my $i = 0; $i <= $#$selectors; $i ++) {
				my $selector = $selectors->[$i];

				if($selector->{'saddr'} eq 'read') {
					$req->[$d]->{'selectors'}->[$i]->{'saddr'} =
						read_TSi_saddr($is_initiator);
				}

				if($selector->{'eaddr'} eq 'read') {
					$req->[$d]->{'selectors'}->[$i]->{'eaddr'} =
						read_TSi_eaddr($is_initiator);
				}
			}

			next;
		}

		if($req->[$d]->{'self'} eq 'TSr') {
			my $payload = $req->[$d];
			my $selectors = $payload->{'selectors'};

			for(my $i = 0; $i <= $#$selectors; $i ++) {
				my $selector = $selectors->[$i];

				if($selector->{'saddr'} eq 'read') {
					$req->[$d]->{'selectors'}->[$i]->{'saddr'} =
						read_TSr_saddr($is_initiator);
				}

				if($selector->{'eaddr'} eq 'read') {
					$req->[$d]->{'selectors'}->[$i]->{'eaddr'} =
						read_TSr_eaddr($is_initiator);
				}
			}
		}
	}

	my $raw = kBuildIKEv2($req, $material, $is_initiator);
	unless(defined($raw)) {
		return(undef);
	}

	kPacket_Clear(0, 0, 0, 0);
	my $ret = $session->send($raw, length($raw), $ike_sa_keymats{$material});
	unless(defined($ret)) {
		return(undef);
	}

	# store sending packet information
	my @decoded = decode($raw, $material);
	my $create_child_sa_req = collect(\@decoded);
	my $public = undef;
	{
		$public = $create_child_sa_req->{'public'};
		if (!defined($public)) {
			if ($is_initiator) {
				$public = $ike_sa_init_resp->{'public'};
			}
			else {
				$public = $ike_sa_init_req->{'public'};
			}
		}
		if (!defined($dh)) {
			if ($is_initiator) {
				$dh = $ike_sa_init_req->{'dh'};
			}
			else {
				$dh = $ike_sa_init_resp->{'dh'};
			}
		}

		my $shared_secret = kComputeDHSharedSecret($dh, $public);
		$create_child_sa_req->{'secret'} = $shared_secret;
	}
	$create_child_sa_req->{'dh'} = $dh;
	$create_child_sa_req->{'public'} = $public;
	$create_child_sa_req->{'data'} = $raw;

	return($create_child_sa_req);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2receive_CREATE_CHILD_SA_request()
{
	return(devel_IKEv2receive_CREATE_CHILD_SA_request(@_));
}


sub
devel_IKEv2receive_CREATE_CHILD_SA_request($$$$$$)
{
	my ($session, $indices, $ike_sa_init_req, $ike_sa_init_resp, $prev_msg_req, $material) = @_;

	my $ret = $session->recv($ike_sa_keymats{$material});
	unless (defined($ret)) {
		return(undef);
	}

	my @decoded = decode($ret->{'Data'}, $material);

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	my $matched_index = undef;
	foreach my $index (@{$indices}) {
		# prepare expected
		if ($scenario) {
			use_tunnel_mode($exp_create_child_sa_req, $index, 0);
		}

		my $expected = kIKE::kHelpers::cloneStructure($exp_create_child_sa_req->{$index});
		my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};

		for (my $d = 0; $d <= $#$expected; $d ++) {
			if ($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if ($header->{'initSPI'} eq 'read') {
					$expected->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
				}

				if ($header->{'respSPI'} eq 'read') {
					$expected->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
				}

				if ($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = !$ike_sa_keymats{$material}->{'is_initiator'} ?
						$ike_sa_keymats{$material}->{'initiator_msg_id'}++:
							$ike_sa_keymats{$material}->{'responder_msg_id'}++;
				}

				if ($header->{'initiator'} eq 'read') {
					$expected->[$d]->{'initiator'} = (!$is_initiator) ? '1' : '0';
				}

				next;
			}

			if ($expected->[$d]->{'self'} eq 'E') {
				my $payload = $expected->[$d];
				my $innerPayloads = $payload->{'innerPayloads'};

				for (my $i = 0; $i <= $#$innerPayloads; $i ++) {

					if ($innerPayloads->[$i]->{'self'} eq 'TSi') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSi_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSi_eaddr($is_initiator));
							}
						}

						next;
					}

					if ($innerPayloads->[$i]->{'self'} eq 'TSr') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSr_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSr_eaddr($is_initiator));
							}
						}
					}
				}
			}
		}

		# check payload order and complement expected payload
		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_create_child_sa_req->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return(undef);
	}

	my $create_child_sa_req = collect(\@decoded);

	return($create_child_sa_req);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2send_CREATE_CHILD_SA_response()
{
	return(devel_IKEv2send_CREATE_CHILD_SA_response(@_));
}



sub
devel_IKEv2send_CREATE_CHILD_SA_response2($$$$$$)
{
	my ($session, $index, $ike_sa_init_req, $ike_sa_init_resp, $prev_msg_req, $material, $send) = @_;

	devel_IKEv2send_CREATE_CHILD_SA_response($session,
						 $index,
						 $ike_sa_init_req,
						 $ike_sa_init_resp,
						 $prev_msg_req,
						 $material,
						 0);
}



sub
devel_IKEv2send_CREATE_CHILD_SA_response($$$$$$;$)
{
	my ($session, $index, $ike_sa_init_req, $ike_sa_init_resp, $create_child_sa_req, $material, $send) = @_;

	if ($scenario) {
		use_tunnel_mode($gen_create_child_sa_resp, $index, 1);
	}

	my $resp = kIKE::kHelpers::cloneStructure($gen_create_child_sa_resp->{$index});
	my $dh = undef;
	my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};

	for(my $d = 0; $d <= $#$resp; $d ++) {
		if($resp->[$d]->{'self'} eq 'HDR') {
			my $header = $resp->[$d];

			if($header->{'initSPI'} eq 'read') {
				$resp->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
			}

			if($header->{'respSPI'} eq 'read') {
				$resp->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
			}

			if($header->{'messID'} eq 'read') {
				$resp->[$d]->{'messID'} = $create_child_sa_req->{'messID'};
			}

			if($header->{'initiator'} eq 'read') {
				$resp->[$d]->{'initiator'} = $is_initiator ? '1' : '0';
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'N' && $resp->[$d]->{'type'} eq 'REKEY_SA') {
			my $payload = $resp->[$d];

			if($payload->{'spi'} eq 'read') {
				$resp->[$d]->{'spi'} = read_N_REKEY_spi();
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'SA') {
			my $payload = $resp->[$d];
			my $proposals = $payload->{'proposals'};

			for(my $i = 0; $i <= $#$proposals; $i ++) {
				my $proposal = $proposals->[$i];
				my $spi_size = undef;
				my $spi = undef;

				if ($proposal->{'spi'} eq 'generate') {
					$spi_size = ($proposal->{'id'} eq 'IKE') ?
						$IKE_SA_SPI_STRLEN * 4 :
						$CHILD_SA_SPI_STRLEN * 4;
				}
				$spi = Math::BigInt->new(makerandom(Size => $spi_size, Strength => 0));
				$resp->[$d]->{'proposals'}->[$i]->{'spi'} = kIKE::kHelpers::as_hex2($spi, $spi_size / 4);
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'Ni, Nr') {
			my $payload = $resp->[$d];

			if($payload->{'nonce'} eq 'generate') {
				my $length = int(rand(240)) + 16;
				my $nonce = Math::BigInt->new(makerandom(Size => ($length * 8), Strength => 0));

				$resp->[$d]->{'nonce'} = kIKE::kHelpers::as_hex2($nonce, $length * 2);
			}
		}

		if($resp->[$d]->{'self'} eq 'KE') {
			my $payload = $resp->[$d];

			if($payload->{'publicKey'} eq 'generate') {
				my $group =
					(defined($payload->{'group'}) && ($payload->{'group'} !~ /^\s*auto\s*$/i))?
						kTransformTypeID(kTransformType('D-H'), $payload->{'group'}):
						0;
				my $publicKey = undef;

				($dh, $publicKey) = kGenDHPublicKey($group);

				my $dhlen = $dh_group_bitlen->{$group} / 4;
				$resp->[$d]->{'publicKey'} = kIKE::kHelpers::as_hex2($publicKey, $dhlen);
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'TSi') {
			my $payload = $resp->[$d];
			my $selectors = $payload->{'selectors'};

			for(my $i = 0; $i <= $#$selectors; $i ++) {
				my $selector = $selectors->[$i];

				if($selector->{'saddr'} eq 'read') {
					$resp->[$d]->{'selectors'}->[$i]->{'saddr'} =
						read_TSi_saddr($is_initiator);
				}

				if($selector->{'eaddr'} eq 'read') {
					$resp->[$d]->{'selectors'}->[$i]->{'eaddr'} =
						read_TSi_eaddr($is_initiator);
				}
			}

			next;
		}

		if($resp->[$d]->{'self'} eq 'TSr') {
			my $payload = $resp->[$d];
			my $selectors = $payload->{'selectors'};

			for(my $i = 0; $i <= $#$selectors; $i ++) {
				my $selector = $selectors->[$i];

				if($selector->{'saddr'} eq 'read') {
					$resp->[$d]->{'selectors'}->[$i]->{'saddr'} =
						read_TSr_saddr($is_initiator);
				}

				if($selector->{'eaddr'} eq 'read') {
					$resp->[$d]->{'selectors'}->[$i]->{'eaddr'} =
						read_TSr_eaddr($is_initiator);
				}
			}
		}
	}

	my $raw = kBuildIKEv2($resp, $material, $is_initiator);
	unless(defined($raw)) {
		return(undef);
	}

	if (!defined($send) || $send) {
		kPacket_Clear(0, 0, 0, 0);
		my $ret = $session->send($raw, length($raw), $ike_sa_keymats{$material});
		unless(defined($ret)) {
			return(undef);
		}
	}

	# store sending packet information
	my @decoded = decode($raw, $material);
	my $create_child_sa_resp = collect(\@decoded);
	my $public = undef;
	{
		$public = $create_child_sa_resp->{'public'};
		if (!defined($public)) {
			if ($is_initiator) {
				$public = $ike_sa_init_resp->{'public'};
			}
			else {
				$public = $ike_sa_init_req->{'public'};
			}
		}
		if (!defined($dh)) {
			if ($is_initiator) {
				$dh = $ike_sa_init_req->{'dh'};
			}
			else {
				$dh = $ike_sa_init_resp->{'dh'};
			}
		}

		my $shared_secret = kComputeDHSharedSecret($dh, $public);
		$create_child_sa_resp->{'secret'} = $shared_secret;
	}
	$create_child_sa_resp->{'dh'} = $dh;
	$create_child_sa_resp->{'public'} = $public;

	return($create_child_sa_resp);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
devel_IKEv2receive_CREATE_CHILD_SA_response($$$$$$)
{
	my ($session, $indices, $ike_sa_init_req, $ike_sa_init_resp, $create_child_sa_req, $material) = @_;

	my $ret = $session->recv($ike_sa_keymats{$material});
	unless (defined($ret)) {
		return(undef);
	}

	my @decoded = decode($ret->{'Data'}, $material);

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};
	my $matched_index = undef;
	foreach my $index (@{$indices}) {
		# prepare expected
		if ($scenario) {
			use_tunnel_mode($exp_create_child_sa_resp, $index, 0);
		}
		my $expected = kIKE::kHelpers::cloneStructure($exp_create_child_sa_resp->{$index});

		for (my $d = 0; $d <= $#$expected; $d ++) {
			if ($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if ($header->{'initSPI'} eq 'read') {
					$expected->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
				}

				if ($header->{'respSPI'} eq 'read') {
					$expected->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
				}

				if ($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = $create_child_sa_req->{'messID'};
				}

				if ($header->{'initiator'} eq 'read') {
					$expected->[$d]->{'initiator'} = (!$is_initiator) ? '1' : '0';
				}

				next;
			}

			if ($expected->[$d]->{'self'} eq 'E') {
				my $payload = $expected->[$d];
				my $innerPayloads = $payload->{'innerPayloads'};

				for (my $i = 0; $i <= $#$innerPayloads; $i ++) {

					if ($innerPayloads->[$i]->{'self'} eq 'TSi') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSi_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSi_eaddr($is_initiator));
							}
						}

						next;
					}

					if ($innerPayloads->[$i]->{'self'} eq 'TSr') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSr_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSr_eaddr($is_initiator));
							}
						}
					}
				}
			}
		}

		# check payload order and complement expected payload
		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_create_child_sa_resp->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return(undef);
	}

	my $create_child_sa_resp = collect(\@decoded);
	my $public = undef;
	my $dh = undef;
	{
		$public = $create_child_sa_req->{'public'};
		if (!defined($public)) {
			if ($is_initiator) {
				$public = $ike_sa_init_resp->{'public'};
			}
			else {
				$public = $ike_sa_init_req->{'public'};
			}

		}
		$dh = $create_child_sa_req->{'dh'};
		if (!defined($dh)) {
			if ($is_initiator) {
				$dh = $ike_sa_init_req->{'dh'};
			}
			else {
				$dh = $ike_sa_init_resp->{'dh'};
			}

		}
	}
	{
		my $shared_secret = kComputeDHSharedSecret($dh, $public);
		$create_child_sa_resp->{'secret'} = $shared_secret;
	}

	return($create_child_sa_resp);
}



sub
devel_IKEv2receive_CREATE_CHILD_SA_response2($$$$$$)
{
	my ($session, $indices, $ike_sa_init_req, $ike_sa_init_resp, $create_child_sa_req, $material) = @_;

	my $received = undef;
	my $matched_index = undef;
	my $ret = $session->recv($ike_sa_keymats{$material});
	unless (defined($ret)) {
		return($received, $matched_index);
	}
	$received = $true;

	my @decoded = decode($ret->{'Data'}, $material);

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};
	foreach my $index (@{$indices}) {
		# prepare expected
		if ($scenario) {
			use_tunnel_mode($exp_create_child_sa_resp, $index, 0);
		}
		my $expected = kIKE::kHelpers::cloneStructure($exp_create_child_sa_resp->{$index});

		for (my $d = 0; $d <= $#$expected; $d ++) {
			if ($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if ($header->{'initSPI'} eq 'read') {
					$expected->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
				}

				if ($header->{'respSPI'} eq 'read') {
					$expected->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
				}

				if ($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = $create_child_sa_req->{'messID'};
				}

				if ($header->{'initiator'} eq 'read') {
					$expected->[$d]->{'initiator'} = (!$is_initiator) ? '1' : '0';
				}

				next;
			}

			if ($expected->[$d]->{'self'} eq 'E') {
				my $payload = $expected->[$d];
				my $innerPayloads = $payload->{'innerPayloads'};

				for (my $i = 0; $i <= $#$innerPayloads; $i ++) {

					if ($innerPayloads->[$i]->{'self'} eq 'TSi') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSi_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSi_eaddr($is_initiator));
							}
						}

						next;
					}

					if ($innerPayloads->[$i]->{'self'} eq 'TSr') {
						my $payload = $innerPayloads->[$i];
						my $selectors = $payload->{'selectors'};

						for (my $j = 0; $j <= $#$selectors; $j ++) {
							my $selector = $selectors->[$j];

							if ($selector->{'saddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'saddr'} =
									ipaddr_tobin(read_TSr_saddr($is_initiator));
							}

							if ($selector->{'eaddr'} eq 'read') {
								$expected->[$d]->{'innerPayloads'}->[$i]->{'selectors'}->[$j]->{'eaddr'} =
									ipaddr_tobin(read_TSr_eaddr($is_initiator));
							}
						}
					}
				}
			}
		}

		# check payload order and complement expected payload
		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_create_child_sa_resp->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return($received, $matched_index);
	}

	my $create_child_sa_resp = collect(\@decoded);
	my $public = undef;
	my $dh = undef;
	{
		$public = $create_child_sa_req->{'public'};
		if (!defined($public)) {
			if ($is_initiator) {
				$public = $ike_sa_init_resp->{'public'};
			}
			else {
				$public = $ike_sa_init_req->{'public'};
			}

		}
		$dh = $create_child_sa_req->{'dh'};
		if (!defined($dh)) {
			if ($is_initiator) {
				$dh = $ike_sa_init_req->{'dh'};
			}
			else {
				$dh = $ike_sa_init_resp->{'dh'};
			}

		}
	}
	{
		my $shared_secret = kComputeDHSharedSecret($dh, $public);
		$create_child_sa_resp->{'secret'} = $shared_secret;
	}

	return($create_child_sa_resp);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
devel_IKEv2send_INFORMATIONAL_request($$$$$$)
{
	my ($session, $index, $ike_sa_init_req, $ike_sa_init_resp, $prev_msg_req, $material) = @_;

	my $req = kIKE::kHelpers::cloneStructure($gen_informational_req->{$index});
	my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};

	for(my $d = 0; $d <= $#$req; $d ++) {
		if($req->[$d]->{'self'} eq 'HDR') {
			my $header = $req->[$d];

			if($header->{'initSPI'} eq 'read') {
				my $spi = undef;
				if (ref($ike_sa_init_req->{'spi'}) eq 'ARRAY') {
					$spi = $ike_sa_init_req->{'spi'}->[0];
				}
				else {
					$spi = $ike_sa_init_req->{'spi'};
				}
				$req->[$d]->{'initSPI'} = $spi;
			}

			if($header->{'respSPI'} eq 'read') {
				$req->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
			}

			if($header->{'messID'} eq 'read') {
				$req->[$d]->{'messID'} = $ike_sa_keymats{$material}->{'is_initiator'} ?
							$ike_sa_keymats{$material}->{'initiator_msg_id'}++:
							$ike_sa_keymats{$material}->{'responder_msg_id'}++;
			}

			if($header->{'initiator'} eq 'read') {
				$req->[$d]->{'initiator'} = $is_initiator ? '1' : '0';
			}

			next;
		}
	}

	my $raw = kBuildIKEv2($req, $material, $is_initiator);
	unless(defined($raw)) {
		return(undef);
	}

	kPacket_Clear(0, 0, 0, 0);
	my $ret = $session->send($raw, length($raw), $ike_sa_keymats{$material});
	unless(defined($ret)) {
		return(undef);
	}

	# store sending packet information
	my @decoded = decode($raw, $material);
	my $informational_req = collect(\@decoded);
	$informational_req->{'data'} = $raw;

	return($informational_req);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
devel_IKEv2receive_INFORMATIONAL_request($$$$$$)
{
	my ($session, $indices, $ike_sa_init_req, $ike_sa_init_resp, $prev_msg_req, $material) = @_;

	my $ret = $session->recv($ike_sa_keymats{$material});
	unless (defined($ret)) {
		return(undef);
	}

	my @decoded = decode($ret->{'Data'}, $material);
	my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	my $matched_index = undef;
	foreach my $index (@{$indices}) {
		# prepare expected
		my $expected = kIKE::kHelpers::cloneStructure($exp_informational_req->{$index});

		for (my $d = 0; $d <= $#$expected; $d ++) {
			if ($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if ($header->{'initSPI'} eq 'read') {
					$expected->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
				}

				if ($header->{'respSPI'} eq 'read') {
					$expected->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
				}

				if ($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = !$ike_sa_keymats{$material}->{'is_initiator'} ?
						$ike_sa_keymats{$material}->{'initiator_msg_id'}++:
							$ike_sa_keymats{$material}->{'responder_msg_id'}++;
				}

				if ($header->{'initiator'} eq 'read') {
					$expected->[$d]->{'initiator'} = (!$is_initiator) ? '1' : '0';
				}

				next;
			}

			if ($expected->[$d]->{'self'} eq 'E') {
				my $payload = $expected->[$d];
				my $innerPayloads = $payload->{'innerPayloads'};

				for (my $i = 0; $i <= $#$innerPayloads; $i ++) {
					# XXX
					;
				}
			}
		}

		# check payload order and complement expected payload
		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_informational_req->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return(undef);
	}

	my $informational_req = collect(\@decoded);

	return($informational_req);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
devel_IKEv2send_INFORMATIONAL_response($$$$$$)
{
	my ($session, $index, $ike_sa_init_req, $ike_sa_init_resp, $informational_req, $material) = @_;

	my $resp = kIKE::kHelpers::cloneStructure($gen_informational_resp->{$index});
	my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};

	for(my $d = 0; $d <= $#$resp; $d ++) {
		if($resp->[$d]->{'self'} eq 'HDR') {
			my $header = $resp->[$d];

			if($header->{'initSPI'} eq 'read') {
				$resp->[$d]->{'initSPI'} = $ike_sa_init_req->{'spi'};
			}

			if($header->{'respSPI'} eq 'read') {
				$resp->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
			}

			if($header->{'messID'} eq 'read') {
				$resp->[$d]->{'messID'} = $informational_req->{'messID'};
			}

			if($header->{'initiator'} eq 'read') {
				$resp->[$d]->{'initiator'} = $is_initiator ? '1' : '0';
			}

			next;
		}
	}

	my $raw = kBuildIKEv2($resp, $material, $is_initiator);
	unless(defined($raw)) {
		return(undef);
	}

	kPacket_Clear(0, 0, 0, 0);
	my $ret = $session->send($raw, length($raw), $ike_sa_keymats{$material});
	unless(defined($ret)) {
		return(undef);
	}

	my @decoded = decode($raw, $material);
	my $informational_resp = collect(\@decoded);

	return($informational_resp);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
devel_IKEv2receive_INFORMATIONAL_response($$$$$$)
{
	my ($session, $indices, $ike_sa_init_req, $ike_sa_init_resp, $informational_req, $material) = @_;

	my $ret = $session->recv($ike_sa_keymats{$material});
	unless (defined($ret)) {
		return(undef);
	}

	my @decoded = decode($ret->{'Data'}, $material);
	my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	my $matched_index = undef;
	foreach my $index (@{$indices}) {
		# prepare expected
		my $expected = kIKE::kHelpers::cloneStructure($exp_informational_resp->{$index});

		for (my $d = 0; $d <= $#$expected; $d ++) {
			if ($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if ($header->{'initSPI'} eq 'read') {
					my $spi = undef;
					if (ref($ike_sa_init_req->{'spi'}) eq 'ARRAY') {
						$spi = $ike_sa_init_req->{'spi'}->[0];
					}
					else {
						$spi = $ike_sa_init_req->{'spi'};
					}
					$expected->[$d]->{'initSPI'} = $spi;
				}

				if ($header->{'respSPI'} eq 'read') {
					$expected->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
				}

				if ($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = $informational_req->{'messID'};
				}

				if ($header->{'initiator'} eq 'read') {
					$expected->[$d]->{'initiator'} = (!$is_initiator) ? '1' : '0';
				}

				next;
			}

			if ($expected->[$d]->{'self'} eq 'E') {
				my $payload = $expected->[$d];
				my $innerPayloads = $payload->{'innerPayloads'};

				for (my $i = 0; $i <= $#$innerPayloads; $i ++) {
					# XXX
					;
				}
			}
		}

		# check payload order and complement expected payload
		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_informational_resp->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return(undef);
	}

	my $informational_resp = collect(\@decoded);

	return($informational_resp);
}



sub
devel_IKEv2receive_INFORMATIONAL_response2($$$$$$)
{
	my ($session, $indices, $ike_sa_init_req, $ike_sa_init_resp, $informational_req, $material) = @_;

	my $received = undef;
	my $matched_index = undef;
	my $ret = $session->recv($ike_sa_keymats{$material});
	unless (defined($ret)) {
		return($received, $matched_index);
	}
	$received = $true;

	my @decoded = decode($ret->{'Data'}, $material);
	my $is_initiator = $ike_sa_keymats{$material}->{'is_initiator'};

	unless (ref($indices)) {
		$indices = [ $indices ];
	}

	# compare
	my $str = '';
	foreach my $index (@{$indices}) {
		$str .= "'$index'";
		$str .= ",";
	}
	$str = substr($str, 0, -1);
	IKEv2log("Compare the received packet with packets($str)");

	foreach my $index (@{$indices}) {
		# prepare expected
		my $expected = kIKE::kHelpers::cloneStructure($exp_informational_resp->{$index});

		for (my $d = 0; $d <= $#$expected; $d ++) {
			if ($expected->[$d]->{'self'} eq 'HDR') {
				my $header = $expected->[$d];

				if ($header->{'initSPI'} eq 'read') {
					my $spi = undef;
					if (ref($ike_sa_init_req->{'spi'}) eq 'ARRAY') {
						$spi = $ike_sa_init_req->{'spi'}->[0];
					}
					else {
						$spi = $ike_sa_init_req->{'spi'};
					}
					$expected->[$d]->{'initSPI'} = $spi;
				}

				if ($header->{'respSPI'} eq 'read') {
					$expected->[$d]->{'respSPI'} = $ike_sa_init_resp->{'spi'};
				}

				if ($header->{'messID'} eq 'read') {
					$expected->[$d]->{'messID'} = $informational_req->{'messID'};
				}

				if ($header->{'initiator'} eq 'read') {
					$expected->[$d]->{'initiator'} = (!$is_initiator) ? '1' : '0';
				}

				next;
			}

			if ($expected->[$d]->{'self'} eq 'E') {
				my $payload = $expected->[$d];
				my $innerPayloads = $payload->{'innerPayloads'};

				for (my $i = 0; $i <= $#$innerPayloads; $i ++) {
					# XXX
					;
				}
			}
		}

		# check payload order and complement expected payload
		my $prepareRes = kIKE::kJudge::kJudgePrepare(\@decoded, $expected);
		unless ($prepareRes) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		my $operation = $operation_informational_resp->{$index};

		# judge
		my $result = kJudgeIKEMessage(\@decoded, $expected, $operation);
		unless ($result->{'result'}) {
			IKEv2log("<b>Not match with packet('$index')</b>");
			next;
		}

		IKEv2log("<b>Match with packet('$index')</b>");
		$matched_index = $index;
		last;
	}

	unless (defined($matched_index)) {
		return($received, $matched_index);
	}

	my $informational_resp = collect(\@decoded);

	return($received, $informational_resp);
}



sub use_tunnel_mode($$$)
{
	my ($pkt_def, $index, $gen) = @_;

	if ($gen) {
		remove_use_transport_mode_from_gen($pkt_def, $index);
	}
	else {
		remove_use_transport_mode_from_exp($pkt_def, $index);
	}

	return;
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2gen_keymat($$$$)
{
	my ($req, $dh, $ike_sa_init_req, $ike_sa_init_resp) = @_;

	my $string = undef;

	my $ike_sa_init_req_nonce = $ike_sa_init_req->{'nonce'};
	my $Ni = substr($ike_sa_init_req_nonce->as_hex, 2);
	my $ike_sa_init_resp_nonce = $ike_sa_init_resp->{'nonce'};
	my $Nr = substr($ike_sa_init_resp_nonce->as_hex, 2);

	my $public = undef;
	if ($req) {
		$public = $ike_sa_init_resp->{'public'};
	}
	else {
		$public = $ike_sa_init_req->{'public'};
	}
	my $ike_sa_init_secret = kComputeDHSharedSecret($dh, $public);
	my $shared_secret = substr($ike_sa_init_secret->as_hex, 2);

	# $string = substr($dh->{'p'}->as_hex, 2);
	$string = sprintf("%x", $dh->{'p'});
	IKEv2log("akisada: p: $string");

	# $string = substr($dh->{'g'}->as_hex, 2);
	$string = sprintf("%x", $dh->{'g'});
	IKEv2log("akisada: g: $string");

	# $string = substr($dh->{'pub_key'}->as_hex, 2);
	$string = sprintf("%x", $dh->{'pub_key'});
	IKEv2log("akisada: pub_key: $string");

	# $string = substr($dh->{'priv_key'}->as_hex, 2);
	$string = sprintf("%x", $dh->{'priv_key'});
	IKEv2log("akisada: priv_key: $string");

	# $string = substr($dh->{'prime_len'}->as_hex, 2);
	$string = sprintf("%x", $dh->{'prime_key'});
	IKEv2log("akisada: prime_len: $string");

	$string = substr($ike_sa_init_req->{'public'}->as_hex, 2);
	IKEv2log("akisada: g^i: $string");

	$string = '<TABLE BORDER>';

	$string .= '<TR>';
	$string .= '<TH BGCOLOR="#a8b5d8">key</TH>';
	$string .= '<TH BGCOLOR="#a8b5d8">value</TH>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>g^ir</TD>';
	$string .= "<TD>$shared_secret</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>Ni</TD>';
	$string .= "<TD>$Ni</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>Nr</TD>';
	$string .= "<TD>$Nr</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>SPIi</TD>';
	$string .= "<TD>$ike_sa_init_req->{'spi'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>SPIr</TD>';
	$string .= "<TD>$ike_sa_init_resp->{'spi'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>IKEv2 Transform Type 1 Algorithms</TD>';
	$string .= "<TD>$ike_sa_init_resp->{'encr'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>IKEv2 Transform Type 2 Algorithms</TD>';
	$string .= "<TD>$ike_sa_init_resp->{'prf'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>IKEv2 Transform Type 3 Algorithms</TD>';
	$string .= "<TD>$ike_sa_init_resp->{'integ'}</TD>";
	$string .= '</TR>';

	$string .= '</TABLE>';

	IKEv2log($string);

	return(kIKE::kIKE::kPrepareIKEEncryption(
		$ike_sa_init_resp->{'encr'},
		$ike_sa_init_resp->{'encrAttr'},
		$ike_sa_init_resp->{'integ'},
		$ike_sa_init_resp->{'integAttr'},
		$ike_sa_init_resp->{'prf'},
		$ike_sa_init_resp->{'prfAttr'},
		$Ni,
		$Nr,
		$shared_secret,
		$ike_sa_init_req->{'spi'},
		$ike_sa_init_resp->{'spi'}
	));
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2set_keymat($$)
{
	my ($key, $value) = @_;

	$ike_sa_keymats{$key} = $value;

	return($true);
}

sub
IKEv2get_keymat($)
{
	my ($keymat) = @_;

	return($ike_sa_keymats{$keymat});
}

#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
devel_IKEv2gen_keymat($$$;$$$)
{
	my ($is_initiator, $ike_sa_init_req, $ike_sa_init_resp, $create_child_sa_req, $create_child_sa_resp, $old_material) = @_;

	my $string = undef;

	my $req = undef;
	my $resp = undef;
	$req = (defined($old_material)) ?
		$create_child_sa_req :
		$ike_sa_init_req;
	$resp = (defined($old_material)) ?
		$create_child_sa_resp :
		$ike_sa_init_resp;

	my $Ni = kIKE::kHelpers::as_hex2($req->{'nonce'}, $req->{'nonceLen'} * 2);
	my $Nr = kIKE::kHelpers::as_hex2($resp->{'nonce'}, $resp->{'nonceLen'} * 2);
	my $dh = $is_initiator? $req->{'dh'}: $resp->{'dh'};
	my $shared_secret = undef;

	if  (defined($old_material)) {
		my $public = $is_initiator? $resp->{'public'}: $req->{'public'};
		if (defined($public)) {
			my $create_child_sa_secret = kComputeDHSharedSecret($dh, $public);
			my $dhlen = $dh_group_bitlen->{$dh->g} / 4;

			$shared_secret = kIKE::kHelpers::as_hex2($create_child_sa_secret, $dhlen);
		}
	}
	else {
		my $public = $is_initiator? $resp->{'public'}: $req->{'public'};
		my $ike_sa_init_secret = kComputeDHSharedSecret($dh, $public);
		my $dhlen = $dh_group_bitlen->{$dh->g} / 4;

		$shared_secret = kIKE::kHelpers::as_hex2($ike_sa_init_secret, $dhlen);
	}

	my $initiators_spi = (defined($old_material)) ? $req->{'spi'}->[0] : $req->{'spi'};
	my $responders_spi = (defined($old_material)) ? $resp->{'spi'} : $resp->{'spi'};
	$string = '<TABLE BORDER>';

	$string .= '<TR>';
	$string .= '<TH BGCOLOR="#a8b5d8">key</TH>';
	$string .= '<TH BGCOLOR="#a8b5d8">value</TH>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>g^i</TD>';
	$string .= "<TD>";
	$string .= kIKE::kHelpers::as_hex2($req->{'public'}, $dh_group_bitlen->{$dh->g} / 4);
	$string .= "</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>g^r</TD>';
	$string .= "<TD>";
	$string .= kIKE::kHelpers::as_hex2($resp->{'public'}, $dh_group_bitlen->{$dh->g} / 4);
	$string .= "</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>g^ir</TD>';
	$string .= "<TD>$shared_secret</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>Ni</TD>';
	$string .= "<TD>$Ni</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>Nr</TD>';
	$string .= "<TD>$Nr</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>SPIi</TD>';
	$string .= "<TD>";
	$string .= $initiators_spi;
	$string .= "</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>SPIr</TD>';
	$string .= "<TD>";
	$string .= $responders_spi;
	$string .= "</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>IKEv2 Transform Type 1 Algorithms</TD>';
	$string .= "<TD>$resp->{'encr'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>IKEv2 Transform Type 2 Algorithms</TD>';
	$string .= "<TD>$resp->{'prf'}</TD>";
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>IKEv2 Transform Type 3 Algorithms</TD>';
	$string .= "<TD>$resp->{'integ'}</TD>";
	$string .= '</TR>';

	$string .= '</TABLE>';

	IKEv2log($string);

	my $keymat = kIKE::kIKE::kPrepareIKEEncryption($resp->{'encr'},
						       $resp->{'encrAttr'},
						       $resp->{'integ'},
						       $resp->{'integAttr'},
						       $resp->{'prf'},
						       $resp->{'prfAttr'},
						       $Ni,
						       $Nr,
						       $shared_secret,
						       $initiators_spi,
						       $responders_spi,
						       $old_material);

	# if $old_material is defined, this new keying material is rekeyed one.
	my $initiator_msg_id = (defined($old_material)) ? 0 : 2;
	my $responder_msg_id = 0;
	my $value = {
		'keying_material'	=>	$keymat,
		'is_initiator'		=>	$is_initiator,
		'initiators_spi'	=>	$initiators_spi,
		'responders_spi'	=>	$responders_spi,
		'initiator_msg_id'	=>	$initiator_msg_id,
		'responder_msg_id'	=>	$responder_msg_id,
	};
	IKEv2set_keymat($keymat, $value);

	return($keymat);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub IKEv2gen_child_sa_keymat($$$$$$)
{
	my ($material, $dh, $ike_sa_init_req, $ike_sa_init_resp, $ike_auth_req, $ike_auth_resp) = @_;

	my $child_sa_keymat = undef;

	my $ni = $ike_sa_init_req->{nonce};
	$ni = substr($ni->as_hex, 2);
	my $nr = $ike_sa_init_resp->{nonce};
	$nr = substr($nr->as_hex, 2);
	$child_sa_keymat = kIKE::kIKE::kPrepareSAEncryption($ike_auth_resp->{encr},
							    $ike_auth_resp->{encrAttr},
							    $ike_auth_resp->{integ},
							    $ike_auth_resp->{integAttr},
							    $ni,
							    $nr,
							    $material);

	my $string = undef;
	$string = '<TABLE BORDER>';

	$string .= '<TR>';
	$string .= '<TH BGCOLOR="#a8b5d8">key</TH>';
	$string .= '<TH BGCOLOR="#a8b5d8">value</TH>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>er</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->er) . '</TD>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>ar</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->ar) . '</TD>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>ei</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->ei) . '</TD>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>ai</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->ai) . '</TD>';
	$string .= '</TR>';

	$string .= '</TABLE>';

	IKEv2log($string);

	return($child_sa_keymat);
}


sub
devel_IKEv2gen_child_sa_keymat($$$$$$;$$)
{
	my ($initiali_exchange, $material, $ike_sa_init_req, $ike_sa_init_resp, $ike_auth_req, $ike_auth_resp, $create_child_sa_req, $create_child_sa_resp) = @_;

	my $child_sa_keymat = undef;

	my $ni = undef;
	my $nr = undef;
	my $ni_len = undef;
	my $nr_len = undef;
	my $encr = undef;
	my $encrAttr = undef;
	my $integ = undef;
	my $integAttr = undef;

	if ($initiali_exchange) {
		$ni = $ike_sa_init_req->{'nonce'};
		$nr = $ike_sa_init_resp->{'nonce'};
		$ni_len = $ike_sa_init_req->{'nonceLen'};
		$nr_len = $ike_sa_init_resp->{'nonceLen'};

		$encr = $ike_auth_resp->{'encr'};
		$encrAttr = $ike_auth_resp->{'encrAttr'};
		$integ = $ike_auth_resp->{'integ'};
		$integAttr = $ike_auth_resp->{'integAttr'};
	}
	else {
		$ni = $create_child_sa_req->{'nonce'};
		$nr = $create_child_sa_resp->{'nonce'};
		$ni_len = $create_child_sa_req->{'nonceLen'};
		$nr_len = $create_child_sa_resp->{'nonceLen'};

		$encr = $create_child_sa_resp->{'encr'};
		$encrAttr = $create_child_sa_resp->{'encrAttr'};
		$integ = $create_child_sa_resp->{'integ'};
		$integAttr = $create_child_sa_resp->{'integAttr'};
	}

	$ni = kIKE::kHelpers::as_hex2($ni, $ni_len * 2);
	$nr = kIKE::kHelpers::as_hex2($nr, $nr_len * 2);
	$child_sa_keymat = kIKE::kIKE::kPrepareSAEncryption($encr,
							    $encrAttr,
							    $integ,
							    $integAttr,
							    $ni,
							    $nr,
							    $material);

	my $string = undef;
	$string = '<TABLE BORDER>';

	$string .= '<TR>';
	$string .= '<TH BGCOLOR="#a8b5d8">key</TH>';
	$string .= '<TH BGCOLOR="#a8b5d8">value</TH>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>er</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->er) . '</TD>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>ar</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->ar) . '</TD>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>ei</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->ei) . '</TD>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>ai</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->ai) . '</TD>';
	$string .= '</TR>';

	$string .= '</TABLE>';

	IKEv2log($string);

	return($child_sa_keymat);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub IKEv2set_child_sa_keymat($$$$;$$$$)
{
	my ($req, $material, $ike_auth_req, $ike_auth_resp, $sad_in, $sad_out, $spd_in, $spd_out) = @_;

	$local_sad = loadSAD($req, $material, $ike_auth_req, $ike_auth_resp);

	$sad_in  = 1 unless (defined($sad_in));
	$sad_out = 1 unless (defined($sad_out));
	$spd_in  = 1 unless (defined($spd_in));
	$spd_out = 1 unless (defined($spd_out));

	# XXX
	# default /sbin/setkey can not set null as encryption algorithm
	# security/ipsec-tools is required
	# my $_setkey = '/sbin/setkey';
	my $_setkey = '/usr/local/sbin/setkey';
	my $cmd = "$_setkey -c << EOF\n";
	$cmd .= dump_sad($local_sad, $sad_in, $sad_out);
	$cmd .= dump_spd($local_spd, $spd_in, $spd_out);
	$cmd .= "EOF\n";

	unless (ikev2Local($cmd)) {
		return($false);
	}

	$need_ipsec_cleanup = $true;

	$cmd = "$_setkey -DP";
	unless (ikev2Local($cmd)) {
		return($false);
	}

	$cmd = "$_setkey -D";
	unless (ikev2Local($cmd)) {
		return($false);
	}

	return($true);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
loadSPD()
{
	my %selector = ();
	my %sa = ();
	my %policy = ();

	expand_ikev2_selector_setupNUT(\%selector, $NUTconfiguration);
	expand_ikev2_sa_setupNUT(\%sa, $NUTconfiguration);
	expand_ikev2_policy_setupNUT(\%policy, $NUTconfiguration);

	$local_spd = [];
	my $local_inbound_idx = undef;
	my $local_outbound_idx = undef;
	foreach (my $i = 0; $i < $selector{'ikev2.selector.num'}; $i++) {
		my $direction = undef;

		if ($selector{"ikev2.selector.$i.direction"} eq 'inbound') {
			$direction = 'out';
		}
		elsif ($selector{"ikev2.selector.$i.direction"} eq 'outbound') {
			$direction = 'in';
		}
		else {
			next;
		}

		my $src_range_addr = defined($selector{"ikev2.selector.$i.src.address"}) ?
					($selector{"ikev2.selector.$i.src.address"}) :
					'';
		my $dst_range_addr = defined($selector{"ikev2.selector.$i.dst.address"}) ?
					($selector{"ikev2.selector.$i.dst.address"}) :
					'';
		my $src_range_port = defined($selector{"ikev2.selector.$i.src.port"}) ?
					($selector{"ikev2.selector.$i.src.port"}) :
					'any';
		my $dst_range_port = defined($selector{"ikev2.selector.$i.dst.port"}) ?
					($selector{"ikev2.selector.$i.dst.port"}) :
					'any';
		my $upperspec = defined($selector{"ikev2.selector.$i.upper_layer_protocol.protocol"}) ?
					$selector{"ikev2.selector.$i.upper_layer_protocol.protocol"} :
					'any';
		my $process = 'ipsec';
		my $protocol = defined($sa{'ikev2.sa.0.sa_protocol'}) ?
				$sa{'ikev2.sa.0.sa_protocol'} :
				'esp';
		my $mode = defined($policy{'ikev2.policy.0.ipsec_mode'}) ?
				$policy{'ikev2.policy.0.ipsec_mode'} :
				'transport';
		my $level = 'require';

		my $sp = {
			  'direction'		=> $direction,
			  'src_range_addr'	=> $src_range_addr,
			  'dst_range_addr'	=> $dst_range_addr,
			  'src_range_port'	=> $src_range_port,
			  'dst_range_port'	=> $dst_range_port,
			  'src_range'	=> $src_range_addr . '[' . $src_range_port . ']',
			  'dst_range'	=> $dst_range_addr . '[' . $dst_range_port . ']',
			  'upperspec'	=> $upperspec,
			  'process'	=> $process,
			  'protocol'	=> $protocol,
			  'mode'	=> $mode,
			  'level'	=> $level,
		};

		push(@{$local_spd}, $sp);

		if ($sp->{'mode'} eq 'transport') {
			next;
		}

		if ($selector{"ikev2.selector.$i.direction"} eq 'inbound') {
			$sp->{'src_endpoint'} =
				defined($policy{'ikev2.policy.0.peers_sa_ipaddr'}) ?
				$policy{'ikev2.policy.0.peers_sa_ipaddr'} :
				'';
			$sp->{'dst_endpoint'} =
				defined($policy{'ikev2.policy.0.my_sa_ipaddr'}) ?
				$policy{'ikev2.policy.0.my_sa_ipaddr'} :
				'';
		}
		elsif ($selector{"ikev2.selector.$i.direction"} eq 'outbound') {
			$sp->{'src_endpoint'} =
				defined($policy{'ikev2.policy.0.my_sa_ipaddr'}) ?
				$policy{'ikev2.policy.0.my_sa_ipaddr'} :
				'';
			$sp->{'dst_endpoint'} =
				defined($policy{'ikev2.policy.0.peers_sa_ipaddr'}) ?
				$policy{'ikev2.policy.0.peers_sa_ipaddr'} :
				'';
		}
	}

	if (0) {
		printf("dbg ===> dump_spd\n%s\n", dump_spd($local_spd));
		printf("dbg ===> dump_spd_setkey\n%s\n", dump_spd_setkey($local_spd));
	}

	return($local_spd);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
loadSAD($$$$)
{
	my ($req, $material, $ike_auth_req, $ike_auth_resp) = @_;

	my $sad_algorithms = {
		# encryption
		'3DES'		=> '3des-cbc',		# ENCR_3DES
		'NULL'		=> 'null',		# ENCR_NULL
		'AES_CBC'	=> 'rijndael-cbc',	# ENCR_AES_CBC
		'AES_CTR'	=> 'aes-ctr',		# ENCR_AES_CTR
		# authentication
		'NONE'		=> 'none',		# NONE
		'HMAC_SHA1_96'	=> 'hmac-sha1',		# AUTH_HMAC_SHA1_96
		'AES_XCBC_96'	=> 'aes-xcbc-mac',	# AUTH_AES_XCBC_96
	};

	my %sa = ();
	expand_ikev2_sa_setupNUT(\%sa, $NUTconfiguration);

	# get request SPI value
	my $num_resp_transforms = 0;
	$num_resp_transforms++ if ($ike_auth_resp->{encr});
	# consider that INTEG_NONE is omitted
	$num_resp_transforms++ if ($ike_auth_resp->{integ} && length(join('', @{$ike_auth_req->{'integ'}})));
	$num_resp_transforms++ if ($ike_auth_resp->{esn});

	my @matched = undef;
	my $proposals = $ike_auth_req->{proposals};
	my $ike_auth_req_spi = undef;
	foreach my $proposal (@{$proposals}) {
		my $transforms = $proposal->{transforms};
		@matched = grep { $ike_auth_resp->{lc($_->{type})} eq $_->{id} } @{$transforms};
		if ($num_resp_transforms == scalar(@matched)) {
			$ike_auth_req_spi = $proposal->{spi};
			last;
		}
	}
	unless ($ike_auth_req_spi) {
		# cannot get SPI value
		return($false);
	}

	my $ike_auth_resp_spi = $ike_auth_resp->{'spi'};
	my $ealgo = $sad_algorithms->{$ike_auth_resp->{'encr'}};
	my $aalgo = $sad_algorithms->{$ike_auth_resp->{'integ'}};
	unless (defined($aalgo)) {
		# if INTEG_NONE is omitted, specify 'none' explicitly
		$aalgo = 'none';
	}
	my $ei = unpack('H*', $material->ei);
	my $ai = unpack('H*', $material->ai);
	my $er = unpack('H*', $material->er);
	my $ar = unpack('H*', $material->ar);
	my $sa_protocol = defined($sa{'ikev2.sa.0.sa_protocol'}) ?
		$sa{'ikev2.sa.0.sa_protocol'} :
		'esp';

	my $local_sa_out = {
		'src'		=> $addresses{'common_endpoint_tn'},
		'dst'		=> $config_pl->{'ikev2_global_addr_nut_link0'},
		'protocol'	=> $sa_protocol,
		'spi'		=> '0x' . (($req) ? $ike_auth_resp_spi : $ike_auth_req_spi),
		'ealgo'		=> $ealgo,
		'ealgo_key'	=> '0x' . (($req) ? $ei : $er),
		'aalgo'		=> $aalgo,
		'aalgo_key'	=> '0x' . (($req) ? $ai : $ar),
		'my_direction'	=> 'out',
	};

	my $local_sa_in = {
		'src'		=> $config_pl->{'ikev2_global_addr_nut_link0'},
		'dst'		=> $addresses{'common_endpoint_tn'},
		'protocol'	=> $sa_protocol,
		'spi'		=> '0x' . (($req) ? $ike_auth_req_spi : $ike_auth_resp_spi),
		'ealgo'		=> $ealgo,
		'ealgo_key'	=> '0x' . (($req) ? $er : $ei),
		'aalgo'		=> $aalgo,
		'aalgo_key'	=> '0x' . (($req) ? $ar : $ai),
		'my_direction'	=> 'in',
	};

	my $local_sad = [];
	push(@{$local_sad}, $local_sa_out);
	push(@{$local_sad}, $local_sa_in);

	if (0) {
		printf("dbg ===> dump_sad\n%s\n", dump_sad($local_sad));
		printf("dbg ===> dump_sad_setkey\n%s\n", dump_sad_setkey($local_sad));
	}

	return($local_sad);
}


sub
dump_spd($$$)
{
	my ($spd, $in, $out) = @_;

	my $str = '';
	foreach my $sp (@{$spd}) {
		if ($in == 0 && $sp->{'direction'} eq 'in') {
			next;
		}
		if ($out == 0 && $sp->{'direction'} eq 'out') {
			next
		}

		if(($need_vpn) && ($scenario == 1)) {
			if($sp->{'direction'} eq 'in') {
				$sp->{'src_range'} =
					(ADDRESS_FAMILY == AF_INET6)?
						$config_pl->{'ikev2_prefixY'} . '::1':
						$config_pl->{'ikev2_prefixY'} . '.1';
			} elsif($sp->{'direction'} eq 'out') {
				$sp->{'dst_range'} =
					(ADDRESS_FAMILY == AF_INET6)?
						$config_pl->{'ikev2_prefixY'} . '::1':
						$config_pl->{'ikev2_prefixY'} . '.1';
			}
		}

		$str .= 'spdadd ';
		$str .= $sp->{'src_range'};
		$str .=  ' ';
		$str .= $sp->{'dst_range'};
		$str .=  ' ';
		$str .= $sp->{'upperspec'};
		$str .= "\n";
		$str .= ' -P ';
		$str .= $sp->{'direction'};
		$str .=  ' ';
		$str .= $sp->{'process'};
		$str .=  ' ';
		$str .= $sp->{'protocol'};
		$str .= '/';
		$str .= $sp->{'mode'};
		$str .= '/';
		if ($sp->{'mode'} eq 'tunnel') {
			$str .= $sp->{'src_endpoint'};
			$str .= '-';
			$str .= $sp->{'dst_endpoint'};
		}
		$str .= '/';
		$str .= $sp->{'level'};
		$str .= ";\n";
	}
	return($str);
}


sub
dump_spd_setkey($)
{
	my ($spd) = @_;

	my $str = '';
	foreach my $sp (@{$spd}) {
		$str .= $sp->{'src_range'};
		$str .= ' ';
		$str .= $sp->{'dst_range'};
		$str .= ' ';
		$str .= $sp->{'upperspec'};
		$str .= "\n\t";
		$str .= $sp->{'direction'};
		$str .= ' ';
		$str .= $sp->{'process'};
		$str .= "\n\t";
		$str .= $sp->{'protocol'};
		$str .= '/';
		$str .= $sp->{'mode'};
		$str .= '/';
		if ($sp->{'mode'} eq 'tunnel') {
			$str .= $sp->{'src_endpoint'};
			$str .= '-';
			$str .= $sp->{'dst_endpoint'};
		}
		$str .= '/';
		$str .= $sp->{'level'};
		$str .= "\n";
	}
	return($str);
}


sub
dump_sad($$$)
{
	my ($sad, $in, $out) = @_;

	my $str = '';
	foreach my $sa (@{$sad}) {
		if ($in == 0 && $sa->{'my_direction'} eq 'in') {
			next;
		}
		if ($out == 0 && $sa->{'my_direction'} eq 'out') {
			next
		}
		$str .= 'add ';
		$str .= $sa->{'src'};
		$str .= ' ';
		$str .= $sa->{'dst'};
		$str .= ' ';
		$str .= $sa->{'protocol'};
		$str .= ' ';
		$str .= $sa->{'spi'};
		$str .= "\n";
		if ($sa->{'protocol'} eq 'esp') {
			$str .= ' -E ';
			$str .= $sa->{'ealgo'};
			$str .= ' ';
			if ($sa->{'ealgo'} ne 'null') {
				$str .= $sa->{'ealgo_key'};
			}
			$str .= "\n";
		}
		if ($sa->{'aalgo'} ne 'none') {
			$str .= ' -A ';
			$str .= $sa->{'aalgo'};
			$str .= ' ';
			$str .= $sa->{'aalgo_key'};
		}
		$str .= ";\n";
	}
	return($str);
}


sub
dump_sad_setkey($)
{
	my ($sad) = @_;

	my $str = '';
	foreach my $sa (@{$sad}) {
		$str .= $sa->{'src'};
		$str .= ' ';
		$str .= $sa->{'dst'};
		$str .= "\n";
		$str .= $sa->{'protocol'};
		$str .= ' spi=';
		$str .= hex($sa->{'spi'}) . '(0x' . $sa->{'spi'} . ')';
		if ($sa->{'protocol'} eq 'esp') {
			$str .= "\n\tE:";
			$str .= $sa->{'ealgo'};
			$str .= ' ';
			$str .= $sa->{'ealgo_key'};
		}
		if ($sa->{'aalgo'} ne 'none') {
			$str .= "\n\tA:";
			$str .= $sa->{'aalgo'};
			$str .= ' ';
			$str .= $sa->{'aalgo_key'};
		}
		$str .= "\n";
	}
	return($str);
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2set_SPD($$)
{
	my ($u, $v) = @_;

	foreach my $elm (@{$local_spd}) {
		foreach my $key (keys(%{$elm})) {
			if ($key eq $u) {
				$elm->{$key} = $v;
				last;
			}
		}
	}

	return($true)
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2flush_SAD_SPD()
{
	unless (IKEv2flush_SAD()) {
		return($false);
	}

	unless (IKEv2flush_SPD()) {
		return($false);
	}

	$need_ipsec_cleanup = $false;

	return($true);
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2flush_SAD()
{
	my $_setkey = '/sbin/setkey';

	unless(ikev2Local("$_setkey -D")) {
		return($false);
	}

	unless(ikev2Local("$_setkey -F")) {
		return($false);
	}

	sleep(3);

	unless(ikev2Local("$_setkey -D")) {
		return($false);
	}

	return($true);
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2flush_SPD()
{
	my $_setkey = '/sbin/setkey';

	unless(ikev2Local("$_setkey -DP")) {
		return($false);
	}

	unless(ikev2Local("$_setkey -FP")) {
		return($false);
	}

	sleep(3);

	unless(ikev2Local("$_setkey -DP")) {
		return($false);
	}

	return($true);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub IKEv2load_packet($;$)
{
	my ($packets, $index) = @_;

	unless (defined($index)) {
		$index = 'common_remote_index';
	}

	my $expected = kIKE::kHelpers::cloneStructure($packets->{$index});

	return($expected);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub IKEv2make_packet($$$$)
{
	my ($packets, $expected_param, $original_index, $expected_index) = @_;

	# load packet specified by index
	my $expected = IKEv2load_packet($packets, $original_index);

	# process each payload to be modified
	foreach my $payload_type (keys(%{$expected_param})) {
		my $params = $expected_param->{$payload_type};

		# get specified payload
		my $payload = kIKE::kHelpers::get_payload($expected, $payload_type);
		unless (defined($payload)) {
			IKEv2log("IKEv2make_packet(): " .
				 "There is no $payload_type payload.");
			next;
		}


		# fill parameters
		foreach my $param_name (keys(%{$params})) {
			$payload->{$param_name} = $params->{$param_name};
		}
	}

	# register modified packet by using specified index
	$packets->{$expected_index} = $expected;

	return($expected_index);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2create_session($)
{
	my ($index) = @_;

	my %interface = ();
	my %remote = ();

	expand_ikev2_interface_with_index_NUT(0, \%interface, $NUTconfiguration);
	expand_ikev2_remote_with_index_NUT($index, \%remote, $NUTconfiguration);

	#for my $key (sort(keys(%interface))) {
	#	print("$key=$interface{$key}\n");
	#}

	#for my $key (sort(keys(%remote))) {
	#	print("$key=$remote{$key}\n");
	#}

	my $tn_addr	= $remote{'remote.ikev2.peers_ipaddr.address'};
	my $tn_port	= $remote{'remote.ikev2.peers_ipaddr.port'};

	my $nut_addr	= $interface{'interface.address'};
	my $nut_port	= $interface{'interface.port'};

	my $session = kIKE::kConnection->new(
		'Link0',	# $interface (Link0|Link1|...)
		(ADDRESS_FAMILY == AF_INET6) ? 'INET6' : 'INET', # address family (INET|INET6)
		'UDP',		# protocol (TCP|UDP|ICMP)
		'IKEv2',	# frameid (NULL|DNS|SIP|IKEv2)
		$tn_addr,	# srcaddr [undef] 0.0.0.0 or :: is used
		$tn_port,	# srcport [undef] 0 is used
		$nut_addr,	# dstaddr
		$nut_port,	# dstport
	);

	return($session);
}



sub
expand_ikev2_interface_with_index_NUT($$$)
{
	my ($index, $configuration, $ref) = @_;

	return(expandConfigurationNUT($configuration, 'interface', $ref->{'ikev2'}->{'interface'}->{'ike'}->[$index]));
}



sub
expand_ikev2_remote_with_index_NUT($$$)
{
	my ($index, $configuration, $ref) = @_;

	my $remote = $ref->{'ikev2'}->{'remote'};

	for(my $d = 0; $d <= $#$remote; $d ++) {
		if($remote->[$d]->{'remote_index'} eq $index) {
			return(expandConfigurationNUT($configuration, 'remote', $remote->[$d]));
		}
	}

	$configuration = undef;

	return;
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub ICMPexchange($$@)
{
	my ($tn, $nut, @args) = @_;
	my $ret = undef;

	if ($tn eq 'EN' && $nut eq 'EN') {
		$ret = ICMPexchange_EN_EN(@args)
	}
	elsif ($tn eq 'SGW' && $nut eq 'SGW') {
		$ret = ICMPexchange_SGW_SGW(@args)
	}

	return($ret);
}

sub ICMPexchange_EN_EN($)
{
	my ($icmp_session) = @_;
	my $ret = undef;
	my $str = '';

	#--------------------------------------#
	# send Echo Request                    #
	#--------------------------------------#
	$str  = '<PRE>';
	$str .= "    (I)             (R)\n";
	$str .= "    NUT             TN1\n";
	$str .= "     |               |\n";
	$str .= "     |<--------------| IPsec (Echo Request)\n";
	$str .= "     |               |\n";
	$str .= "     V               V";
	$str .= '</PRE>';
	IKEv2log($str);

	$ret = ICMPsend($icmp_session, 'echo_request');
	unless(defined($ret)) {
		return(-1);
	}

	#--------------------------------------#
	# receive Echo Reply                   #
	#--------------------------------------#
	$str  = '<PRE>';
	$str .= "    (I)             (R)\n";
	$str .= "    NUT             TN1\n";
	$str .= "     |               |\n";
	$str .= "     |-------------->| IPsec (Echo Reply)\n";
	$str .= "     |               |\n";
	$str .= "     V               V";
	$str .= '</PRE>';
	IKEv2log($str);

	$ret = ICMPreceive($icmp_session);
	unless(defined($ret)) {
		return(0);
	}

	return($ret);
}

sub ICMPexchange_SGW_SGW($$)
{
	my ($icmp_session_th2, $icmp_session_th1) = @_;
	my $ret = undef;
	my $str = '';

	#--------------------------------------#
        # send Echo Reply                      #
        #--------------------------------------#
        $str  = '<PRE>';
        $str .= "                    (I)             (R)\n";
        $str .= "    TH1             NUT             TN1             TH2\n";
        $str .= "     |               |               |               |\n";
        $str .= "     |<--------------+===============+---------------| IPsec (Echo Reply)\n";
        $str .= "     |               |               |               |\n";
        $str .= "     V               V";
        $str .= '</PRE>';
        IKEv2log($str);

        $ret = ICMPsend($icmp_session_th2, 'echo_request');
        unless(defined($ret)) {
		return(-1);
        }

        #--------------------------------------#
        # receive Echo Reply                   #
        #--------------------------------------#
        $ret = ICMPreceive($icmp_session_th1);
        unless(defined($ret)) {
		return(0);
        }

        #--------------------------------------#
        # send Echo Reply                      #
        #--------------------------------------#
	$str  = '<PRE>';
	$str .= "                    (I)             (R)\n";
	$str .= "    TH1             NUT             TN1             TH2\n";
	$str .= "     |               |               |               |\n";
	$str .= "     |---------------+===============+-------------->| IPsec {Echo Reply}\n";
	$str .= "     |               |               |               |\n";
	$str .= "     V               V               V               V";
	$str .= '</PRE>';

	IKEv2log($str);

	$ret = ICMPsend_v6eval('TH1sendtoTH2', 'echo_reply');
	unless (defined($ret)) {
		return(-1);
	}

	#--------------------------------------#
	# receive Echo Reply                   #
	#--------------------------------------#
	$ret = ICMPreceive($icmp_session_th2);
	unless(defined($ret)) {
		return(0);
	}

	return($ret);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
ICMPcreate_session($)
{
	my ($index) = @_;

	my $protocol	= 'ICMP';
	my $frameid	= 'NULL';

	my $s = $icmp_session->{$index};
	my $session = undef;
	$session = kIKE::kConnection->new($s->{'interface'},
					  (ADDRESS_FAMILY == AF_INET6) ? 'INET6' : 'INET',
					  $protocol,
					  $frameid,
					  $s->{'saddr'},
					  $s->{'sport'},
					  $s->{'daddr'},
					  $s->{'dport'});

	if (defined($session)) {
		ICMPprepare($session);
	}

	return($session);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
ICMPprepare($)
{
	my ($session) = @_;

	unless (defined($session)) {
		return(undef)
	}

	my $timeout = $session->{'timeout'};
	$session->timeout(1);
	ICMPreceive($session);
	$session->timeout($timeout);

	return($true);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
ICMPsend($$)
{
	my ($session, $packet) = @_;

	# ICMPv4/v6 Type (1) + ICMPv4/v6 Code (1) + ICMPv4/v6 Checksum (2)
	my $icmp_packets = (ADDRESS_FAMILY == AF_INET6) ? $icmpv6_packets : $icmpv4_packets;
	my $data = pack('C C n',
			$icmp_packets->{$packet}->{'type'},
			$icmp_packets->{$packet}->{'code'},
			0);

	my $ret = $session->send($data, length($data));
	unless (defined($ret)) {
		return(undef);
	}

	return(ICMPparse($ret->{'Data'}));
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
ICMPsend_v6eval($$)
{
	my ($index, $packet) = @_;

	my $session = $icmp_session->{$index};
	my $link = $session->{'interface'};
	my $srcaddr = $session->{'saddr'};
	my $dstaddr = $session->{'daddr'};
	my $timestr = kCommon::getTimeStamp();
	my $af = (ADDRESS_FAMILY == AF_INET6) ? 'INET6' : 'INET';

	kCommon::prOut("try to send...");

	IKEv2v6eval::RegistV6evalSignalHandler();
	my %ret = IKEv2v6eval::IKEv2vSend($link, $srcaddr, $dstaddr, $packet, $af);
	RegistKoiSignalHandler();

	kCommon::prLogHTML("\n<TR VALIGN=\"TOP\">\n<TD>$timestr</TD><TD>");
	kCommon::prLogHTML("Send<br>"
				. "&nbsp;&nbsp;SrcAddr:${srcaddr}<br>"
				. "&nbsp;&nbsp;DstAddr:${dstaddr}<br>");


	if ($ret{'status'}) {
		kCommon::prLogHTML("failed</TD></TR>");
		return(undef);
	}

	kCommon::prLogHTML("done</TD></TR>");
	return($true);
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
ICMPreceive($)
{
	my ($session) = @_;

	my $ret = $session->recv();
	unless (defined($ret)) {
		return(undef);
	}

	return(ICMPparse($ret->{'Data'}));
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
ICMPparse($)
{
	my ($data) = @_;

	my $icmp = { };
	my $offset = 0;

	$icmp->{'RawData'} = $data;
	$icmp->{'Length'} = length($data);
	($icmp->{'Type'}, $icmp->{'Code'}, $icmp->{'Checksum'}) = unpack('C C n', $data);
	$offset += 4;

	if ($icmp->{'Type'} == 128 || $icmp->{'Type'} == 129) {
		# Echo Request / Echo Reply
		if ($icmp->{'Length'} > $offset) {
			$icmp->{'Identifier'} = unpack('n', substr($data, $offset, 2));
			$offset += 2;
			$icmp->{'SeqNum'} = unpack('n', substr($data, $offset, 2));
			$offset += 2;
			$icmp->{'Data'} = unpack('H*', substr($data, $offset));
			$offset = length($data);
		}
	}
	elsif ($icmp->{'Type'} == 200 || $icmp->{'Type'} == 201) {
		# Private Experimentation
		;
	}

	return($icmp);
}


#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
loadICMP()
{
	my $session = {};
	my $s = undef;

	if ($scenario == 0) {
		$s = {
			'interface' => 'Link0',
			'saddr' => $addresses{'tn1_global_linkX'},
			'sport'	=> 0,
			'daddr' => $addresses{'nut_global_linkA'},
			'dport'	=> 0,
		};
		$session->{'TN1sendtoNUT'} = $s;

		$s = {
			'interface' => 'Link0',
			'saddr' => $addresses{'tr1_global_linkA'},
			'sport'	=> 0,
			'daddr'	=> $addresses{'nut_global_linkA'},
			'dport'	=> 0,
		};
		$session->{'TR1sendtoNUT'} = $s;
	}
	elsif ($scenario == 1) {
		$s = {
			'interface' => 'Link0',
			'saddr' => $addresses{'th1_global_linkY'},
			'sport'	=> 0,
			'daddr'	=> $addresses{'nut_global_linkA'},
			'dport'	=> 0,
		};
		$session->{'TH1sendtoNUT'} = $s;

		if ($need_vpn) {
			$s = {
				'interface' => 'Link0',
				'saddr' => $addresses{'th1_global_linkY'},
				'sport'	=> 0,
				'daddr' => $addresses{'cfg_req_internal_addr'},
				'dport'	=> 0,
			};
			$session->{'TH1sendtoNUTconf'} = $s;
		}
	}
	elsif ($scenario == 2) {
		$s = {
			'interface' => 'Link0',
			'saddr' => $addresses{'th3_global_linkY'},
			'sport'	=> 0,
			'daddr'	=> $addresses{'th1_global_linkB'},
			'dport'	=> 0,
		};
		$session->{'TH3sendtoTH1'} = $s;

		$s = {
			'interface' => 'Link1',
			'saddr'	=> $addresses{'th1_global_linkB'},
			'sport'	=> 0,
			'daddr' => $addresses{'th3_global_linkY'},
			'dport'	=> 0,
		};
		$session->{'TH1sendtoTH3'} = $s;

		$s = {
			'interface' => 'Link0',
			'saddr' => $addresses{'th2_global_linkY'},
			'sport'	=> 0,
			'daddr'	=> $addresses{'th1_global_linkB'},
			'dport'	=> 0,
		};
		$session->{'TH2sendtoTH1'} = $s;

		$s = {
			'interface' => 'Link1',
			#'interface' => 'Link0',
			'saddr'	=> $addresses{'th1_global_linkB'},
			'sport'	=> 0,
			'daddr' => $addresses{'th2_global_linkY'},
			'dport'	=> 0,
		};
		$session->{'TH1sendtoTH2'} = $s;

		$s = {
			'interface' => 'Link0',
			'saddr' => $addresses{'tr1_global_linkA'},
			'sport' => 0,
			'daddr' => $addresses{'nut_global_linkA'},
			'dport' => 0,
		};
		$session->{'TR1sendtoNUT'} = $s;

		$s = {
			'interface' => 'Link1',
			'saddr' => $addresses{'th1_global_linkB'},
			'sport'	=> 0,
			'daddr'	=> $addresses{'th2_global_linkY'},
			'dport'	=> 0,
		};
		$session->{'TH1recvfromTH2'} = $s;

		$s = {
			'interface' => 'Link1',
			'saddr' => $addresses{'th1_global_linkB'},
			'sport'	=> 0,
			'daddr' => $addresses{'nut_global_linkB'},
			'dport'	=> 0,
		};
		$session->{'TH1sendtoNUT'} = $s;
	}
	elsif ($scenario == 3) {
		$s = {
			'interface' => 'Link0',
			'saddr' => $addresses{'tn1_global_linkX'},
			'sport'	=> 0,
			'daddr'	=> $addresses{'th1_global_linkB'},
			'dport'	=> 0,
		};
		$session->{'TN1sendtoTH1'} = $s;

		$s = {
			'interface' => 'Link1',
			'saddr' => $addresses{'th1_global_linkB'},
			'sport'	=> 0,
			'daddr'	=> $addresses{'tn1_global_linkX'},
			'dport'	=> 0,
		};
		$session->{'TH1sendtoTN1'} = $s;

		$s = {
			'interface' => 'Link1',
			'saddr' => $addresses{'th1_global_linkB'},
			'sport'	=> 0,
			'daddr' => $addresses{'nut_global_linkB'},
			'dport'	=> 0,
		};
		$session->{'TH1sendtoNUT'} = $s;

		if ($need_vpn) {
			$s = {
				'interface' => 'Link0',
				'saddr' => $addresses{'cfg_req_internal_addr'},
				'sport'	=> 0,
				'daddr' => $addresses{'th1_global_linkB'},
				'dport'	=> 0,
			};
			$session->{'TN1confsendtoTH1'} = $s;
		}
	}

	$icmpv4_packets = {
		'echo_reply' =>
			{
				'type' => 0,
				'code' => 0,
			},
		'dest_unreach' =>
			{
				'type' => 3,
				'code' => 0,
			},
		'echo_request' =>
			{
				'type' => 8,
				'code' => 0,
			},
	};
	$icmpv6_packets = {
		'dest_unreach' =>
			{
				'type' => 1,
				'code' => 0,
			},
		'echo_request' =>
			{
				'type' => 128,
				'code' => 0,
			},
		'echo_reply' =>
			{
				'type' => 129,
				'code' => 0,
			},
		'private_experimentation' =>
			{	# Private experimentation (See RFC4443)
				'type' => 200,
				'code' => 0,
			},
	};

	$icmp_session = $session;
}



#----------------------------------------------------------------------#
# subroutines to read paramegters                                      #
#----------------------------------------------------------------------#
sub
IKEv2send_TCP_SYN($)
{
	my ($index) = @_;

	my $af = undef;
	my $socktype = undef;
	my $protocol = undef;
	my $canonname = undef;
	my @res = undef;
	my $ret = undef;
	local (*SOCKET);

	my $session = $tcp_session->{$index};

	unless ($session) {
		return($false);
	}

	# src
	my $srcaddr = undef;
	@res = getaddrinfo($session->{'saddr'}, $session->{'sport'},
			   AF_UNSPEC, SOCK_STREAM, 0, AI_PASSIVE);
	while (scalar(@res) >= 5) {
		($af, $socktype, $protocol, $srcaddr, $canonname, @res) = @res;

		last;
	}

	# dst
	my $dstaddr = undef;
	@res = getaddrinfo($session->{'daddr'}, $session->{'dport'},
			   AF_UNSPEC, SOCK_STREAM);
	while (scalar(@res) >= 5) {
		($af, $socktype, $protocol, $dstaddr, $canonname, @res) = @res;

		unless (socket(SOCKET, $af, $socktype, $protocol)) {
			next;
		}

		unless (bind(SOCKET, $srcaddr)) {
			close(SOCKET);
			next;
		}

		unless (connect(SOCKET, $dstaddr)) {
			close(SOCKET);
			$ret = $!;
			last;
		}

		last;
	}

	close(SOCKET);

	my $str = "<TR VALIGN=\"top\">\n";
	$str .= '<TD>' . kCommon::getTimeStamp() . "</TD>\n";
	if ($ret == ECONNREFUSED) {
		$str .= '<TD>send TCP SYN packet and receive TCP RST packet</TD>';
	}
	else {
		$str .= "<TD>send TCP SYN packet and can't receive TCP RST packet</TD>";
	}
	$str .= '</TR>';
	kCommon::prLogHTML($str);

	return(($ret == ECONNREFUSED)? $true : $false);
}



sub
loadTCP()
{
	my $session = {};

	if ($scenario == 0) {
		my $s = undef;
		$s = {
			'saddr'	=> $addresses{'tn1_global_linkX'},
			'sport'	=> '33333',
			'daddr'	=> $addresses{'nut_global_linkA'},
			'dport' => '33333',
		};
		$session->{'TN1sendtoNUT'} = $s;
	}
	elsif ($scenario == 2) {
		my $s = undef;
		$s = {
			'saddr' => $addresses{'th2_global_linkY'},
			'sport'	=> '33333',
			'daddr'	=> $addresses{'th1_global_linkB'},
			'dport' => '33333',
		};
		$session->{'TH2sendtoTH1'} = $s;
	}
	$tcp_session = $session;
}



# <--------------------------- for v6eval ---------------------------- #
sub IKEv2_v6eval_generate_IPsecSA($$$$$$;$$)
{
	my ($initiali_exchange, $material, $ike_sa_init_req, $ike_sa_init_resp, $ike_auth_req, $ike_auth_resp, $create_child_sa_req, $create_child_sa_resp) = @_;

	my $child_sa_keymat = undef;

	my $ni = undef;
	my $nr = undef;
	my $ni_len = undef;
	my $nr_len = undef;
	my $encr = undef;
	my $encrAttr = undef;
	my $integ = undef;
	my $integAttr = undef;

	if ($initiali_exchange) {
		$ni = $ike_sa_init_req->{'nonce'};
		$nr = $ike_sa_init_resp->{'nonce'};
		$ni_len = $ike_sa_init_req->{'nonceLen'};
		$nr_len = $ike_sa_init_resp->{'nonceLen'};

		$encr = $ike_auth_resp->{'encr'};
		$encrAttr = $ike_auth_resp->{'encrAttr'};
		$integ = $ike_auth_resp->{'integ'};
		$integAttr = $ike_auth_resp->{'integAttr'};
	}
	else {
		$ni = $create_child_sa_req->{'nonce'};
		$nr = $create_child_sa_resp->{'nonce'};
		$ni_len = $create_child_sa_req->{'nonceLen'};
		$nr_len = $create_child_sa_resp->{'nonceLen'};

		$encr = $create_child_sa_resp->{'encr'};
		$encrAttr = $create_child_sa_resp->{'encrAttr'};
		$integ = $create_child_sa_resp->{'integ'};
		$integAttr = $create_child_sa_resp->{'integAttr'};
	}

	$ni = kIKE::kHelpers::as_hex2($ni, $ni_len * 2);
	$nr = kIKE::kHelpers::as_hex2($nr, $nr_len * 2);
	$child_sa_keymat = kIKE::kIKE::kPrepareSAEncryption($encr,
							    $encrAttr,
							    $integ,
							    $integAttr,
							    $ni,
							    $nr,
							    $material);

	my $string = undef;
	$string = '<TABLE BORDER>';

	$string .= '<TR>';
	$string .= '<TH BGCOLOR="#a8b5d8">key</TH>';
	$string .= '<TH BGCOLOR="#a8b5d8">value</TH>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>er</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->er) . '</TD>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>ar</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->ar) . '</TD>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>ei</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->ei) . '</TD>';
	$string .= '</TR>';

	$string .= '<TR>';
	$string .= '<TD>ai</TD>';
	$string .= '<TD>' . unpack('H*', $child_sa_keymat->ai) . '</TD>';
	$string .= '</TR>';

	$string .= '</TABLE>';

	IKEv2log($string);

	return($child_sa_keymat);
}

sub IKEv2_v6eval_set_IPsecSA($$$$;$)
{
	my ($req, $material, $ike_auth_req, $ike_auth_resp, $conf) = @_;

	$local_sad = loadSAD($req, $material, $ike_auth_req, $ike_auth_resp);

	my $ret = $false;

	my $sa_in = undef;
	my $sa_out = undef;
	foreach my $sa (@{$local_sad}) {
		if ($sa->{'my_direction'} eq 'in') {
			$sa_in = $sa;
		}
		elsif ($sa->{'my_direction'} eq 'out') {
			$sa_out = $sa;
		}
	}

	unless (defined($sa_in)) {
		IKEv2log("<FONT COLOR=\"#ff0000\">unable to load inbound SA.</FONT>");
		return($ret);
	}
	unless (defined($sa_out)) {
		IKEv2log("<FONT COLOR=\"#ff0000\">unable to load outbound SA.</FONT>");
		return($ret);
	}

	my $cpp = undef;
	if (exists($conf->{'cpp'}) && $conf->{'cpp'}) {
		$cpp = $conf->{'cpp'};
	}
	else {
		$cpp = '';
	}

	my $cpp_ip_tn1_linkx	= $sa_out->{'src'};
	my $cpp_ip_nut_linka	= $sa_out->{'dst'};
	$cpp	.= "-DCPP_IP_TN1_LINKX=\\\"$cpp_ip_tn1_linkx\\\" ";
	$cpp	.= "-DCPP_IP_NUT_LINKA=\\\"$cpp_ip_nut_linka\\\" ";

	if ($scenario == 0) {
	}
	elsif ($scenario == 1) {
		my $cpp_ip_src_th1_linka = '2001:db8:f:2::f';
		$cpp    .= "-DCPP_IP_TH1_LINKY=\\\"$cpp_ip_src_th1_linka\\\" ";
	}
	elsif ($scenario == 2) {
		my $cpp_ip_src_th3_linky = '2001:db8:f:2::e';
		my $cpp_ip_src_th2_linky = '2001:db8:f:2::f';
		my $cpp_ip_dst_linkb = '2001:db8:1:2::f';
		$cpp	.= "-DCPP_IP_TH3_LINKY=\\\"$cpp_ip_src_th3_linky\\\" ";
		$cpp	.= "-DCPP_IP_TH2_LINKY=\\\"$cpp_ip_src_th2_linky\\\" ";
		$cpp	.= "-DCPP_IP_TH1_LINKB=\\\"$cpp_ip_dst_linkb\\\" ";
	}
	elsif ($scenario == 3) {
		my $cpp_ip_dst_linkb = '2001:db8:1:2::f';
		$cpp    .= "-DCPP_IP_TH1_LINKB=\\\"$cpp_ip_dst_linkb\\\" ";
	}
	else {
		IKEv2log("<FONT COLOR=\"#ff0000\">undefined scenario($scenario).</FONT>");
		return($ret);
	}

	my $cpp_esp_spi_in	= $sa_in->{'spi'};
	my $cpp_esp_spi_out	= $sa_out->{'spi'};
	$cpp	.= "-DCPP_ESP_SPI_IN=$cpp_esp_spi_in ";
	$cpp	.= "-DCPP_ESP_SPI_OUT=$cpp_esp_spi_out ";

	my $esn = exists($conf->{'esn'}) && $conf->{'esn'};

	if($esn) {
		$cpp	.= "-DCPP_ALGO_IN=des3cbc_hmacsha1_in_esn ";
		$cpp	.= "-DCPP_ALGO_OUT=des3cbc_hmacsha1_out_esn ";
	}
	elsif(($sa_out->{'ealgo'} eq '3des-cbc') &&
	   ($sa_out->{'aalgo'} eq 'hmac-sha1')) {
		$cpp	.= "-DCPP_ALGO_IN=des3cbc_hmacsha1_in ";
		$cpp	.= "-DCPP_ALGO_OUT=des3cbc_hmacsha1_out ";
	} elsif(($sa_out->{'ealgo'} eq 'null') &&
	        ($sa_out->{'aalgo'} eq 'hmac-sha1')) {
		$cpp	.= "-DCPP_ALGO_IN=null_crypt_hmacsha1_in ";
		$cpp	.= "-DCPP_ALGO_OUT=null_crypt_hmacsha1_out ";
	} elsif(($sa_out->{'ealgo'} eq 'rijndael-cbc') &&
	        ($sa_out->{'aalgo'} eq 'hmac-sha1')) {
		$cpp	.= "-DCPP_ALGO_IN=aescbc_hmacsha1_in ";
		$cpp	.= "-DCPP_ALGO_OUT=aescbc_hmacsha1_out ";
	} elsif(($sa_out->{'ealgo'} eq 'aes-ctr') &&
	        ($sa_out->{'aalgo'} eq 'hmac-sha1')) {
#		$cpp	.= "-DDEBUG_AES_CTR ";
		$cpp	.= "-DCPP_ALGO_IN=aesctr_hmacsha1_in ";
		$cpp	.= "-DCPP_ALGO_OUT=aesctr_hmacsha1_out ";
	} elsif(($sa_out->{'ealgo'} eq '3des-cbc') &&
	        ($sa_out->{'aalgo'} eq 'null')) {
		$cpp	.= "-DCPP_ALGO_IN=des3cbc_null_auth_in ";
		$cpp	.= "-DCPP_ALGO_OUT=des3cbc_null_auth_out ";
	} elsif(($sa_out->{'ealgo'} eq '3des-cbc') &&
	        ($sa_out->{'aalgo'} eq 'aes-xcbc-mac')) {
		$cpp	.= "-DCPP_ALGO_IN=des3cbc_aesxcbc_in ";
		$cpp	.= "-DCPP_ALGO_OUT=des3cbc_aesxcbc_out ";
	} else {
		IKEv2log("<FONT COLOR=\"#ff0000\">undefined ealgo and aalog.</FONT>");
		return($ret);
	}

	if($sa_out->{'ealgo'} eq '3des-cbc') {
		my $cpp_key_in	= $sa_in->{'ealgo_key'};
		$cpp_key_in	= substr($cpp_key_in, 2);
		$cpp	.= "-DCPP_DES3CBC_KEY_IN=\\\"$cpp_key_in\\\" ";

		my $cpp_key_out	= $sa_out->{'ealgo_key'};
		$cpp_key_out	= substr($cpp_key_out, 2);
		$cpp	.= "-DCPP_DES3CBC_KEY_OUT=\\\"$cpp_key_out\\\" ";
	} elsif($sa_out->{'ealgo'} eq 'null') {
		;
	} elsif($sa_out->{'ealgo'} eq 'rijndael-cbc') {
		my $cpp_key_in	= $sa_in->{'ealgo_key'};
		$cpp_key_in	= substr($cpp_key_in, 2);
		$cpp	.= "-DCPP_AESCBC_KEY_IN=\\\"$cpp_key_in\\\" ";

		my $cpp_key_out	= $sa_out->{'ealgo_key'};
		$cpp_key_out	= substr($cpp_key_out, 2);
		$cpp	.= "-DCPP_AESCBC_KEY_OUT=\\\"$cpp_key_out\\\" ";
	} elsif($sa_out->{'ealgo'} eq 'aes-ctr') {
		my $cpp_key_in	= $sa_in->{'ealgo_key'};
		$cpp_key_in	= substr($cpp_key_in, 2);
		$cpp	.= "-DCPP_AESCTR_KEY_IN=\\\"$cpp_key_in\\\" ";

		my $cpp_key_out	= $sa_out->{'ealgo_key'};
		$cpp_key_out	= substr($cpp_key_out, 2);
		$cpp	.= "-DCPP_AESCTR_KEY_OUT=\\\"$cpp_key_out\\\" ";
	} else {
		IKEv2log("<FONT COLOR=\"#ff0000\">undefined ealgo key.</FONT>");
		return($ret);
	}

	if($sa_out->{'aalgo'} eq 'hmac-sha1') {
		my $cpp_key_in	= $sa_in->{'aalgo_key'};
		$cpp_key_in	= substr($cpp_key_in, 2);
		$cpp	.= "-DCPP_HMACSHA1_KEY_IN=\\\"$cpp_key_in\\\" ";

		my $cpp_key_out	= $sa_out->{'aalgo_key'};
		$cpp_key_out	= substr($cpp_key_out, 2);
		$cpp	.= "-DCPP_HMACSHA1_KEY_OUT=\\\"$cpp_key_out\\\" ";
	} elsif($sa_out->{'aalgo'} eq 'null') {
		;
	} elsif($sa_out->{'aalgo'} eq 'aes-xcbc-mac') {
		my $cpp_key_in	= $sa_in->{'aalgo_key'};
		$cpp_key_in	= substr($cpp_key_in, 2);
		$cpp	.= "-DCPP_AESXCBC_KEY_IN=\\\"$cpp_key_in\\\" ";

		my $cpp_key_out	= $sa_out->{'aalgo_key'};
		$cpp_key_out	= substr($cpp_key_out, 2);
		$cpp	.= "-DCPP_AESXCBC_KEY_OUT=\\\"$cpp_key_out\\\" ";
	} else {
		IKEv2log("<FONT COLOR=\"#ff0000\">undefined aalgo key.</FONT>");
		return($ret);
	}

	IKEv2log("$cpp");
	vCPP($cpp);

	return($cpp);
}

sub IKEv2_v6eval_send_recv($$$@)
{
	my ($slink, $rlink, $spkt, @rpkts) = @_;

	my $ret	= undef;

	sleep(3);

	vCapture($rlink);

	vClear($rlink);

	vSend($slink, $spkt);

	my %vrecv = vRecv($rlink, 3, 0, 0, @rpkts);
	for(my $d = 0; $d <= $#rpkts; $d ++) {
		unless (defined($vrecv{'recvFrame'})) {
			next;
		}

		if($vrecv{'recvFrame'} eq $rpkts[$d]) {
			$ret	= 1;
		}
	}

	vStop($rlink);

	return($ret, %vrecv);
}

sub IKEv2_v6eval_send($$)
{
	my ($slink, $spkt) = @_;

	my $ret	= undef;

	sleep(3);

	return(vSend($slink, $spkt));
}
# ---------------------------- for v6eval ---------------------------> #



#----------------------------------------------------------------------#
# local subroutines                                                    #
#----------------------------------------------------------------------#
sub decode($;$)
{
	my ($data, $material) = @_;
	return(kIKE::kIKE::kParseIKEMessage($data, $material));
}

sub collect($)
{
	my ($msg) = @_;

	my $exchange_type = $msg->[0]->{'exchType'};
	unless (defined($exchange_type)) {
		IKEv2exitFatal('collect(): ExchType value in decoded message is undefined');
	}

	my $response = $msg->[0]->{'response'};
	unless (defined($response)) {
		IKEv2exitFatal('collect(): Response bit in decoded message is undefined');
	}

	my $ret = undef;
	if ($exchange_type eq 'IKE_SA_INIT') {
		if (!$response) { # IKE_SA_INIT request
			$ret = kParseIKESecurityAssociationInitializationRequest($msg);
		}
		else { # IKE_SA_INIT response
			$ret = kParseIKESecurityAssociationInitializationResponse($msg);
		}
	}
	elsif ($exchange_type eq 'IKE_AUTH') {
		if (!$response) { # IKE_AUTH request
			$ret = kParseIKEAuthenticationRequest($msg);
		}
		else { # IKE_AUTH response
			$ret = kParseIKEAuthenticationResponse($msg);
		}
	}
	elsif ($exchange_type eq 'CREATE_CHILD_SA') {
		if (!$response) { # CREATE_CHILD_SA request
			$ret = kParseCreateChildSecurityAssociationRequest($msg);
		}
		else { # CREATE_CHILD_SA response
			$ret = kParseCreateChildSecurityAssociationResponse($msg);
		}
	}
	elsif ($exchange_type eq 'INFORMATIONAL') {
		if (!$response) { # INFORMATIONAL request
			$ret = kParseInformationalRequest($msg);
		}
		else { # INFORMATIONAL response
			$ret = kParseInformationalResponse($msg);
		}
	}
	else {
		IKEv2exitFatal('collect(): Unknown Exchange Type ('. $exchange_type .')');
	}

	return($ret);
}



#----------------------------------------------------------------------#
# subroutines to read paramegters                                      #
#----------------------------------------------------------------------#
sub
read_TSi_saddr($)
{
	my ($req) = @_;
	my $addr = undef;

	if ($req) {
		if ($scenario == 0) {
			$addr = $addresses{'tn1_global_linkX'};
		} elsif ($scenario == 1) {
			$addr = $addresses{'prefixY_saddr'};
		} elsif ($scenario == 2) {
			$addr = $addresses{'prefixY_saddr'};
		} elsif ($scenario == 3) {
			$addr = $addresses{'tn1_global_linkX'};
		}
	}
	else {
		if ($scenario == 0) {
			$addr = $config_pl->{'ikev2_global_addr_nut_link0'};
		} elsif ($scenario == 1) {
			if($need_vpn) {
				$addr = $addresses{'cfg_req_internal_addr'};
			} else {
				$addr = $config_pl->{'ikev2_global_addr_nut_link0'};
			}
		} elsif ($scenario == 2) {
			$addr = $addresses{'prefixB_saddr'};
		} elsif ($scenario == 3) {
			$addr = $addresses{'prefixB_saddr'};
		}
	}
	return($addr);
}

sub
read_TSi_eaddr($)
{
	my ($req) = @_;
	my $addr = undef;

	if ($req) {
		if ($scenario == 0) {
			$addr = $addresses{'tn1_global_linkX'};
		} elsif ($scenario == 1) {
			$addr = $addresses{'prefixY_eaddr'};
		} elsif ($scenario == 2) {
			$addr = $addresses{'prefixY_eaddr'};
		} elsif ($scenario == 3) {
			$addr = $addresses{'tn1_global_linkX'};
		}
	} else {
		if ($scenario == 0) {
			$addr = $config_pl->{'ikev2_global_addr_nut_link0'};
		} elsif ($scenario == 1) {
			if ($need_vpn) {
				$addr = $addresses{'cfg_req_internal_addr'};
			} else {
				$addr = $config_pl->{'ikev2_global_addr_nut_link0'};
			}
		} elsif ($scenario == 2) {
			$addr = $addresses{'prefixB_eaddr'};
		} elsif ($scenario == 3) {
			$addr = $addresses{'prefixB_eaddr'};
		}
	}
	return($addr);
}

sub
read_TSr_saddr($)
{
	my ($req) = @_;
	my $addr = undef;

	if ($req) {
		if ($scenario == 0 || $scenario == 1) {
			$addr = $config_pl->{'ikev2_global_addr_nut_link0'};
		} elsif ($scenario == 2) {
			$addr = $addresses{'prefixB_saddr'};
		} elsif ($scenario == 3) {
			if ($need_vpn) {
				$addr = $addresses{'cfg_req_internal_addr'};
			} else {
				$addr = $addresses{'prefixB_saddr'};
			}
		}
	}
	else {
		if ($scenario == 0) {
			$addr = $addresses{'tn1_global_linkX'};
		} elsif ($scenario == 1) {
			$addr = $addresses{'prefixY_saddr'};
		} elsif ($scenario == 2) {
			$addr = $addresses{'prefixY_saddr'};
		} elsif ($scenario == 3) {
			$addr = $addresses{'tn1_global_linkX'};
		}
	}
	return($addr);
}

sub
read_TSr_eaddr($)
{
	my ($req) = @_;
	my $addr = undef;

	if ($req) {
		if ($scenario == 0 || $scenario == 1) {
			$addr = $config_pl->{'ikev2_global_addr_nut_link0'};
		} elsif ($scenario == 2) {
			$addr = $addresses{'prefixB_eaddr'};
		} elsif ($scenario == 3) {
			if ($need_vpn) {
				$addr = $addresses{'cfg_req_internal_addr'};
			} else {
				$addr = $addresses{'prefixB_eaddr'};
			}
		}
	}
	else {
		if ($scenario == 0) {
			$addr = $addresses{'tn1_global_linkX'};
		} elsif ($scenario == 1) {
			$addr = $addresses{'prefixY_eaddr'};
		} elsif ($scenario == 2) {
			$addr = $addresses{'prefixY_eaddr'};
		} elsif ($scenario == 3) {
			$addr = $addresses{'tn1_global_linkX'};
		}
	}
	return($addr);
}

sub
read_N_REKEY_spi()
{
	my $spi = undef;
	foreach my $sa (@{$local_sad}) {
		if ($sa->{'my_direction'} eq 'out') {
			$spi = substr($sa->{'spi'}, 2);
		}
	}
	return($spi);
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub der2hexstr($)
{
	my ($der) = @_;
	local (*IN);
	if (open(IN, $der) == 0) {
		IKEv2log(kDump_Common_Error());
		return($false);
	}
	binmode (IN);

	my $hexstr = undef;
	my $buf  = undef;
	while (read(IN, $buf, 16)) {
		foreach my $n ( unpack( "C16", $buf ) ) {
			$hexstr .= sprintf("%02x", $n );
		}
	}

	close(IN);
	return($hexstr);
}


sub AF_INET6() {
	return(28);
};

#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
RegistKoiSignalHandler() {
	$SIG{CHLD} = \&kCommon::handleChildProcess;
}



#----------------------------------------------------------------------#
# log                                                                  #
#----------------------------------------------------------------------#
sub IKEv2log($)
{
	my ($str) = @_;

	unless (defined($str)) {
		return;
	}

	kCommon::prLogHTML("<tr VALIGN=\"top\">\n");
	kCommon::prLogHTML("<td></td>\n");
	kCommon::prLogHTML("<td width=\"100%\">$str</td>\n");
	kCommon::prLogHTML("</tr>\n");

	return;
}



#----------------------------------------------------------------------#
#                                                                      #
#----------------------------------------------------------------------#
sub
IKEv2exitPass(@)
{
	my (@argv) = @_;

	IKEv2log('<FONT COLOR="#FF0000" SIZE="+1"><U><B>TEST CLEANUP</B></U></FONT>');

	unless(cleanupNUT()) {
		IKEv2exitFatal('<FONT COLOR="#ff0000">NUT cleanup failure</FONT>');
	}

	unless(cleanupTN()) {
		IKEv2exitFatal('<FONT COLOR="#ff0000">TN cleanup failure</FONT>');
	}

	exitCommon($kCommon::exitPass,
		@argv, 'PASS');
}



sub
IKEv2exitNS(@)
{
	my (@argv) = @_;

	IKEv2log('<FONT COLOR="#FF0000" SIZE="+1"><U><B>TEST CLEANUP</B></U></FONT>');

	exitCommon($kCommon::exitNS,
		@argv, '<FONT COLOR="#00ff00">Not supported</FONT>');
}



sub
IKEv2exitFail(@)
{
	my (@argv) = @_;

	IKEv2log('<FONT COLOR="#FF0000" SIZE="+1"><U><B>TEST CLEANUP</B></U></FONT>');

	unless(cleanupNUT()) {
		IKEv2exitFatal('<FONT COLOR="#ff0000">NUT cleanup failure</FONT>');
	}

	unless(cleanupTN()) {
		IKEv2exitFatal('<FONT COLOR="#ff0000">TN cleanup failure</FONT>');
	}

	exitCommon($kCommon::exitFail,
		@argv, '<FONT COLOR="#ff0000">FAIL</FONT>');
}



sub
IKEv2exitFatal(@)
{
	my (@argv) = @_;

	exitCommon($kCommon::exitFatal,
		@argv, '<FONT COLOR="#ff0000">internal error</FONT>');
}



sub
exitCommon($@)
{
	my ($exitCode, @argv) = @_;

	for(my $d = 0; $d <= $#argv; $d ++) {
		IKEv2log($argv[$d]);
	}

	exit($exitCode);
}



1;
