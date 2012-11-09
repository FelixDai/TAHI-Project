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
package mip6_mn_common;

# EXPORT PACKAGE
use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	$SEQUENCE
	$ESP_SEQUENCE
	$ECHO_IDENTIFIER
	$ECHO_SEQUENCE
	$HOTI_COOKIE
	$COTI_COOKIE
	$HOT_INDEX
	$COT_INDEX
	$BU_SEQUENCE
	$BU_CN_SEQUENCE
	@UNEXPECT;
	$failcount
	$warncount
	$initcount
	$ignorecount
	init_mn
	term_mn
	clear_sequence
	get_sequence
	get_new_esp_sequence
	get_new_echo_identifier
	get_new_echo_sequence
	get_new_hoti_cookie
	get_new_coti_cookie
	get_new_hot_index
	get_new_cot_index
	get_new_bu_sequence
	get_new_bu_cn_sequence
	set_now_link
	set_cn_link
	check_link_name
	set_link_lifetime
	check_regitime
	check_lifetime
	check_backoff
	check_modulo
	get_homekeygentoken
	get_careofkeygentoken
	set_addr_tbl
	get_addr_tbl
	get_addr
	get_addrType
	is_Link
	get_mac
	check_addr
	check_pkt
);

# INPORT PACKAGE
use V6evalTool;
use mip6_mn_config;
use mip6_mn_ipsec;
use mip6_mn_ike;


# GLOBAL VARIABLE DEFINITION
$SEQUENCE = 1;
$ESP_SEQUENCE = 0;
$ECHO_IDENTIFIER = 100;
$ECHO_SEQUENCE = 200;
$HOTI_COOKIE = "0123456789abcdef";
$COTI_COOKIE = "fedcba9876543210";
$HOT_INDEX = 300;
$COT_INDEX = 400;
$BU_SEQUENCE = 500;
$BU_CN_SEQUENCE = 600;

# unexpect packets
@UNEXPECT = ();

$failcount = 0;
$warncount = 0;
$initcount = 0;
$ignorecount = 0;

# LOCAL VARIABLE DEFINITION
%LINK_NAME = (
	'NONE'  => 1,
	'Link0' => 1,
	'LinkX' => 1,
	'LinkY' => 1,
	'LinkZ' => 1,
);

# SUBROUTINE DECLARATION
sub init_mn();
sub term_mn();
sub clear_sequence();
sub get_sequence();
sub get_new_esp_sequence();
sub get_new_echo_identifier();
sub get_new_echo_sequence();
sub get_new_hoti_cookie();
sub get_new_coti_cookie();
sub get_new_hot_index();
sub get_new_cot_index();
sub get_new_bu_sequence();
sub get_new_bu_cn_sequence();
sub set_now_link($);
sub set_cn_link($);
sub check_link_name($);
sub set_link_lifetime($$$);
sub check_regitime($$);
sub check_lifetime($$);
sub check_backoff($$);
sub check_modulo($$$);
sub get_homekeygentoken($);
sub get_careofkeygentoken($);
sub set_addr_tbl($$$);
sub get_addr_tbl($);
sub get_addr($);
sub get_addrType($);
sub is_Link($$);
sub get_mac($);
sub check_addr($);
sub check_pkt(@);


# SUBROUTINE
#-----------------------------------------------------------------------------#
# init_mn()
#   initialize target
#-----------------------------------------------------------------------------#
sub init_mn() {

	# check if NUT is host or router
	if ($V6evalTool::NutDef{Type} ne 'router') {
		vLogHTML("This test is for the router only");
		exit $V6evalTool::exitRouterOnly;
	}

	# set NUT mac
	$IF0_NUT = $V6evalTool::NutDef{Link0_device};
	$IF1_NUT = $V6evalTool::NutDef{Link1_device};

	# set node address table
	set_node_addr();

	# display to check NUT home Link
	vLogHTML("Please check your home link should be <B>$LINK0_PREFIX/64</B><BR>");

	# for IKEv1 module
	ike_module_init();

	if ($MN_CONF{TEST_FUNC_IPSEC} eq 'YES') {
		if ($MN_CONF{TEST_FUNC_IKE} eq 'YES') {
			init_ike();
		}
	}

	# INITIALIZE
	# reset MN functionality
	if ($MN_CONF{ENV_INITIALIZE} eq 'BOOT') {
		# reboot MN
		vLogHTML('Rebooting Mobile Node by reboot.rmt<BR>');
		$ret = vRemote('reboot.rmt', '');
		if ($ret != 0) {
			vLogHTML('Cannot Reboot Mobile Node Modules<BR>');
			vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
			exit $V6evalTool::exitFatal;
		}
	}

	if ($MN_CONF{ENV_INITIALIZE} eq 'RESET') {
		# reset MN
		vLogHTML('Reseting Mobile Node by reset.rmt<BR>');
		if ($MN_CONF{TEST_FUNC_IPSEC} eq 'YES') {
			$ret = vRemote('reset.rmt', "ipsec=use", "device=$IF0_NUT", '');
		}
		else {
			$ret = vRemote('reset.rmt', "device=$IF0_NUT", '');
		}
		if ($ret != 0) {
			vLogHTML('Cannot Reset Mobile Node Modules<BR>');
			vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
			exit $V6evalTool::exitFatal;
		}
	}

#	Egress Interface gateway ?
#	if (($MN_CONF{ENV_INITIALIZE} eq 'BOOT') &&
#	    ($MN_CONF{ENV_xxxxxxxxxx} eq 'YES')) {
#		$ret = vRemote('route.rmt', 'cmd=add', 'prefix=default',
#		               "gateway=fe80::200:ff:fe00:a0a0", "if=$IF0_NUT");
#		if ($ret != 0) {
#			vLogHTML('Cannot configure route <BR>');
#			vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
#			exit $V6evalTool::exitFatal;
#		}
#	}

	if ($MN_CONF{ENV_ENABLE_MOBILE} eq 'YES') {
		vLogHTML('Restarting Mobile Router by mip6EnableMR.rmt<BR>');
		$ret = vRemote('mip6EnableMR.rmt', "device=$IF0_NUT", '');
		if ($ret != 0) {
			vLogHTML('Cannot Reset Mobile Router Modules <BR>');
			vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
			exit $V6evalTool::exitFatal;
		}
	}

	if ($MN_CONF{ENV_IPSEC_SET} eq 'YES') {
		if ($MN_CONF{TEST_FUNC_IPSEC} eq 'YES') {
			if ($MN_CONF{TEST_FUNC_IKE} eq 'YES') {
				if ($MN_CONF{ENV_IKE_WO_IKE} == 0) {
					init_mn_ike();
				}
				else {
					# dummy route for debug
					init_mn_ipsec();
				}
			}
			else {
				init_mn_ipsec();
			}
		}
	}

	# status of the test result
	$failcount = 0;
	$warncount = 0;
	$initcount = 0;
	$ignorecount = 0;

	return;
}

#-----------------------------------------------------------------------------#
# term_mn()
#-----------------------------------------------------------------------------#
sub term_mn() {

	if ($MN_CONF{ENV_IPSEC_SET} eq 'YES') {
		if ($MN_CONF{TEST_FUNC_IPSEC} eq 'YES') {
			if ($MN_CONF{TEST_FUNC_IKE} eq 'YES') {
				if ($MN_CONF{ENV_IKE_WO_IKE} == 0) {
					term_mn_ike();
				}
				else {
					# dummy route for debug
					mip6ipsecClearAll();
				}
			}
			else {
				mip6ipsecClearAll();
			}
		}
	}

	if ($MN_CONF{TEST_FUNC_IPSEC} eq 'YES') {
		if ($MN_CONF{TEST_FUNC_IKE} eq 'YES') {
			term_ike();
		}
	}

	# for IKEv1 module
	ike_module_term();

	# Clear the memory which stores the reception packet.
	vClear($if);

	# Exit with status code.
	if ($initcount != 0) {
		vLogHTML_Fail("InitFail exists.");
		exit $V6evalTool::exitInitFail;
	}
	if ($failcount != 0) {
		vLogHTML_Fail("Fail exists.");
		exit $V6evalTool::exitFail;
	}
	if ($warncount != 0) {
		vLogHTML_Warn("Warning exists.");
		exit $V6evalTool::exitWarn;
	}
	if ($ignorecount != 0) {
		vLogHTML_Info("This test case did not apply to the implementation of NUT.");
		exit $V6evalTool::exitIgnore;
	}
	vLogHTML_Pass("Pass.");
	exit $V6evalTool::exitPass;
}

#-----------------------------------------------------------------------------#
# clear_sequence()
#-----------------------------------------------------------------------------#
sub clear_sequence() {
	$SEQUENCE = 1;
}

#-----------------------------------------------------------------------------#
# get_sequence()
#-----------------------------------------------------------------------------#
sub get_sequence() {
	$SEQUENCE = $SEQUENCE + 7;
	return ($SEQUENCE);
}

#-----------------------------------------------------------------------------#
# get_new_*()
#-----------------------------------------------------------------------------#
sub get_new_esp_sequence() {
	$ESP_SEQUENCE = ($ESP_SEQUENCE + 1) % 65536;
	return ($ESP_SEQUENCE);
}

sub get_new_echo_identifier() {
	$ECHO_IDENTIFIER = ($ECHO_IDENTIFIER + 1) % 65536;
	return ($ECHO_IDENTIFIER);
}

sub get_new_echo_sequence() {
	$ECHO_SEQUENCE = ($ECHO_SEQUENCE + 1) % 65536;
	return ($ECHO_SEQUENCE);
}

sub get_new_hoti_cookie() {
	$HOTI_COOKIE = substr($HOTI_COOKIE, 1, 15) . substr($HOTI_COOKIE, 0, 1);
	return ($HOTI_COOKIE);
}

sub get_new_coti_cookie() {
	$COTI_COOKIE = substr($COTI_COOKIE, 15, 1) . substr($COTI_COOKIE, 0, 15);
	return ($COTI_COOKIE);
}

sub get_new_hot_index() {
	$HOT_INDEX = ($HOT_INDEX + 1) % 65536;
	return ($HOT_INDEX);
}

sub get_new_cot_index() {
	$COT_INDEX = ($COT_INDEX + 1) % 65536;
	return ($COT_INDEX);
}

sub get_new_bu_sequence() {
	$BU_SEQUENCE = ($BU_SEQUENCE + 1) % 65536;
	return ($BU_SEQUENCE);
}

sub get_new_bu_cn_sequence() {
	$BU_CN_SEQUENCE = ($BU_CN_SEQUENCE + 1) % 65536;
	return ($BU_CN_SEQUENCE);
}

#-----------------------------------------------------------------------------#
# set_now_link($)
# <in> $link: link name(Link0/LinkX/LinkY/LinkZ)
#
# <out> complete	:  0
#		not complete: -1
#-----------------------------------------------------------------------------#
sub set_now_link($) {
	my ($link) = @_;

	# check of link name
	if ( $NOW_Link eq $link ) {
		# same
		return(0);
	}
	if ( check_link_name($link) != 0 ) {
		return(-1);
	}

	if ( $link ne 'NONE' ) {
		if ( $NOW_Link eq 'NONE' ) {
			# start
			vLogHTML("<B>NUT starts at $link.</B><BR>");
		}
		else {
			# changed current link
			vLogHTML("<B>NUT moves from $NOW_Link to $link.</B><BR>");
		}

		if ($MN_CONF{TEST_FUNC_IKE} eq 'YES') {
			set_responder($NOW_Link);
		}
	}
	else {
		# out of all link.
		vLogHTML("<B>NUT leaves from all the links.</B><BR>");
	}
	$NOW_Link = $link;

	return(1);
}

#-----------------------------------------------------------------------------#
# set_cn_link($)
# <in> $link: link name(Link0/LinkX/LinkY/LinkZ)
#
# <out> complete	:  0
#		not complete: -1
#-----------------------------------------------------------------------------#
sub set_cn_link($) {
	my ($link) = @_;

	# check of link name
	if ( check_link_name($link) == 0 ) {
		# changed cn link
		$CN0_Link = $Link;
		return(0);
	}
	return(-1);
}

#-----------------------------------------------------------------------------#
# check_link_name($)
# <in> $link: link name(Link0/LinkX/LinkY/LinkZ)
#
# <out> complete	:  0
#		not complete: -1
#-----------------------------------------------------------------------------#
sub check_link_name($) {
	my ($link) = @_;

	# check of link name
	if ($LINK_NAME{$link} == 1) {
		return(0);
	}
	return(-1);
}

#-----------------------------------------------------------------------------#
# set_link_lifetime($$$)
#-----------------------------------------------------------------------------#
sub set_link_lifetime($$$) {
	my ($Link, $vld_lifetime, $pre_lifetime) = @_;
	my $now_time;

	$now_time = time;
	${"st_$Link"}{ValidLifetime} = $now_time + $vld_lifetime;
	${"st_$Link"}{PreferredLifetime} = $now_time + $pre_lifetime;

	return (${"st_$Link"}{ValidLifetime});
}

#-----------------------------------------------------------------------------#
# check_regitime($$)
#-----------------------------------------------------------------------------#
sub check_regitime($$) {
	my ($chk_time, $std_time) = @_;

#	vLogHTML("check_regi = $chk_time $std_time</BR>");
	if ($chk_time <= $std_time) {
		return 0;
	}
	else {
		return 1;
	}
}

#-----------------------------------------------------------------------------#
# check_lifetime($$)
#-----------------------------------------------------------------------------#
sub check_lifetime($$) {
	my ($chk_time, $std_time) = @_;

#	vLogHTML("check_life = $chk_time $std_time</BR>");
	if ($chk_time <= ($std_time + $BU_MARGIN_TIME)) {
		return 0;
	}
	else {
		return 1;
	}
}

#-----------------------------------------------------------------------------#
# check_backoff($$)
#-----------------------------------------------------------------------------#
sub check_backoff($$) {
	my ($chk_interval, $pre_interval) = @_;

#	vLogHTML("check_back = $chk_interval $pre_interval</BR>");
	if ($chk_interval >= (($pre_interval * $RETRANS_MARGIN) * 2)) {
		return 0;
	}
	else {
		return 1;
	}
}

#-----------------------------------------------------------------------------#
# check_modulo($$$)
# <in>  $pre_number: 
#       $cur_nunber: 
#       $modulo    : 
# <out> 1: in the Range
#       0: same
#      -1: outside the range
#-----------------------------------------------------------------------------#
sub check_modulo($$$) {
	my ($pre_number, $cur_number, $modulo) = @_;

	if ($cur_number > $pre_number) {
		if (($cur_number - $pre_number) < (2 ** ($modulo - 1))) {
			return 1;
		}
		else {
				return -1;
		}
	}
	else {
		if (($pre_number - $cur_number) > (2 ** ($modulo - 1))) {
			return 1;
		}
		else {
			return -1;
		}
	}
	return 0;
}

#-----------------------------------------------------------------------------#
# get_homekeygentoken($)
# <in>  $homenonceindex : Home Nonce Index
# <out> $homekeygentoken: Home Keygen Token
#-----------------------------------------------------------------------------#
sub get_homekeygentoken($) {
	my ($homenonceindex) = @_;

	# simple calculation
	my $homekeygentoken = 11 * $homenonceindex - 1;
	return ($homekeygentoken);
}

#-----------------------------------------------------------------------------#
# get_careofkeygentoken($)
# <in>  $careofnonceindex : Care-of Nonce Index
# <out> $careofkeygentoken: Care-of Keygen Token
#-----------------------------------------------------------------------------#
sub get_careofkeygentoken($) {
	my ($careofnonceindex) = @_;

	my $careofkeygentoken = 13 * $careofnonceindex - 1;
	return ($careofkeygentoken);
}

#-----------------------------------------------------------------------------#
# set_addr_tbl($$$)
# <in>	$addr: address(hash_key)
#		$type: address type
#		$link: link name
#
# <out> complete	:  0
#		not complete: -1
#-----------------------------------------------------------------------------#
sub set_addr_tbl($$$) {
	my ($addr, $type, $link) = @_;

	# to lower case
	$addr = lc($addr);

	# check address hash table
	if ( exists $addr_hash{$addr} ) {
		# entry is exist
		return(-1);
	} else {
		# register address table
		%tmp_hash = ( $addr, $type );
		%{"addr_hash_$link"} = (%addr_hash, %tmp_hash);
		%tmp_hash = ( $type, $addr );
		%node_hash = (%node_hash, %tmp_hash);
	}
	return(0);
}

#-----------------------------------------------------------------------------#
# get_addr_tbl($)
# <in> $addr: address
#
# <out> address info
#-----------------------------------------------------------------------------#
sub get_addr_tbl($) {
	my ($addr) = @_;
	my %addr_tbl = ();

	# to lower case
	$addr = lc($addr);

	# check address hash table
	if ( exists $addr_hash{$addr} ) {
		# entry is exist
		%addr_tbl = %{"$addr_hash{$addr}"};
	}
	return(%addr_tbl);
}

#-----------------------------------------------------------------------------#
# get_addr($)
# <in> $addr_type
#
# <out> address
#-----------------------------------------------------------------------------#
sub get_addr($) {
	my ($addr_type) = @_;
	my $addr = '';

	# check address hash table
	if ( exists $node_hash{$addr_type} ) {
		# entry is exist
		$addr = $node_hash{$addr_type};
	}
	return($addr);
}

#-----------------------------------------------------------------------------#
# get_addrType($)
# <in> $addr: address
#
# <out> address type
#-----------------------------------------------------------------------------#
sub get_addrType($) {
	my ($addr) = @_;
	my $ret = 'unknown';

	# to lower case
	$addr = lc($addr);

	# check address hash table
	if ( exists $addr_hash{$addr} ) {
		# entry is exist
		$ret = "$addr_hash{$addr}";
	}
	return($ret);
}

#-----------------------------------------------------------------------------#
# is_Link($$)
# <in> $addr: address
#      $link: link name(Link0/LinkX/LinkY/LinkZ)
#
# <out> node exist in Link0      :  0
#       node dose not exist Link0: -1
#-----------------------------------------------------------------------------#
sub is_Link($$) {
	my ($addr, $link) = @_;
	my %addr_tbl = ();
	my $ret = -1;

	# to lower case
	$addr = lc($addr);

	# check address hash table
	if ( exists ${"addr_hash_$link"}{$addr} ) {
		# entry is exist
		%addr_tbl = %{"addr_hash_$link{$addr}"};
		# check node name
		if ( substr($addr_tbl{'node_name'}, 0, 2) eq 'cn' ) {
			if ( $link eq $CN0_Link ) {
				$ret = 0;
			}
		} else {
			$ret = 0;
		}
	}
	return($ret);
}

#-----------------------------------------------------------------------------#
# get_mac($)
# <in> $addr: address
#
# <out> mac address
#       node dose not exist: -1
#-----------------------------------------------------------------------------#
sub get_mac($) {
	my ($addr) = @_;
	my $ret = -1;

	# to lower case
	$addr = lc($addr);

	# check address hash table
	if ( exists ${"addr_hash"}{$addr} ) {
		# entry is exist
		%addr_tbl = %{"$addr_hash{$addr}"};
		$ret = $addr_tbl{'mac'};
	}
	return($ret);
}

#-----------------------------------------------------------------------------#
# check_addr($)
# <in>  $addr: ipv6 address
#
# <out> $trn : unspecified/unicast/multicast(multi-anycast)/anycast/loopback
#-----------------------------------------------------------------------------#
sub check_addr($) {
	my ($addr) = @_;

	$addr = lc($addr);

	$tmp = substr($addr,0,2);
	if ( $tmp eq "ff" ){
		return('multicast');
	}
	$tmp2 = substr( $addr, (length($addr) - 19), length($addr) );
	if ( $tmp2 eq "fdff:ffff:ffff:fffe" ) {
		return('anycast');
	}
	if ( $addr eq "::" ) {
		return('unspecified');
	}
	if ( $addr eq "::1" ) {
		return('loopback');
	}
	return('unicast');
}

#-----------------------------------------------------------------------------#
# check_pkt(@)
# <in>  *lastname: check key
#
# <out> :
#-----------------------------------------------------------------------------#
sub check_pkt(@){
	my (@lastname) = @_;
	my %lastname = @lastname;
	my $first;
	my $last;

	while (($first, $last) = each(%lastname)){
		vLogHTML_Info("        key($first)           => value($last)");
	}

	return(0);
}

# End of File
1;
