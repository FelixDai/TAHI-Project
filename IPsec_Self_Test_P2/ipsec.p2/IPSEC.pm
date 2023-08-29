#
# Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010
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
# Perl Module for IPv6 Specification Conformance Test
#
# $Name: V6PC_P2_IPsec_1_11_1 $
#
# $TAHI: ct/ipsec.p2/IPSEC.pm,v 1.70 2013/04/16 09:46:10 doo Exp $
#

########################################################################
package IPSEC;

use Exporter;
use V6evalTool;

#======================================================================
# BEGIN - read ipsecaddr.def
#======================================================================
BEGIN {
	use File::Copy;
	my $from = 'p2_HTR_ipsecaddr.def.tmpl';
	my $to = 'p2_HTR_ipsecaddr.def';
	unless (-e $to) {
		copy($from, $to);
	}
	vCPP();
}

END {
}

@ISA = qw(Exporter);
@EXPORT = qw(
	%pktdesc
	ipsecExitPass
	ipsecExitIgnore
	ipsecExitNS
	ipsecExitWarn
	ipsecExitEndNodeOnly
	ipsecExitSGWOnly
	ipsecExitFail
	ipsecExitFatal
	seqERROR
	ipsecAsyncFail
	ipsecReboot
	ipsecRebootAsync
	ipsecRebootByError
	ipsecRebootToClean
	ipsecResetMTU
	ipsecResetNUT
	ipsecCheckNUT
	ipsecLinkDev
	ipsecSetAddr
	ipsecSetAddrSGW
	ipsecSetSAD
	ipsecSetSADAsync
	ipsecSetSPD
	ipsecSetSPDAsync
	ipsecRemoteAsyncWait
	ipsecClearAll
	ipsecEnable
	ipsecPing2NUT
	ipsecPingFromNUT
	ipsecPingFrag2NUT
	ipsecPingFragForward
	ipsecSendDummy
	ipsecForwardBidir
	ipsecForwardOneWay
	ipsecTcp2NUT
	ipsecResetTcp2NUT
	ipsecEstTcp2NUT
	ipsecAckDataTcp2NUT
	ipsecFinAckTcp2NUT
	getTimeUTC
	getTimeStamp
	ipsecConfigCheck
	ipsecOverWriteConfig
	vRecvWrapper
	vRecvNS
	vRecvRS
	);

################################################################
# debug option
################################################################
#$test_debug = "1";

################################################################
# Global constans
################################################################
$SUCCESS        = 0;
$FAIL           = -1;

$C_BLUE = '"#0000FF"';
$C_GREEN = '"#009900"';
$C_RED = '"#FF0000"';

################################################################
# Global variables
################################################################
$REBOOT_WAIT_TIME = 60;
$WAIT_ASSIGN_ADDR = 3;
$APP_TYPE = undef;
$DEF_PORT = 80;
$DEF_PORT_UDP = 7;
$TCP_TIME_WAIT = 120; #sec

$SGW_ADDR_DEF = "p2_SGW_ipsecaddr.def";
$ADDR_DEF = "p2_HTR_ipsecaddr.def";
$ADDR_DEF_TMPL = "p2_HTR_ipsecaddr.def.tmpl";

################################################################
# Advanced Function
################################################################
%advanced_functions = ();

################################################################
# Packet description
################################################################
%pktdesc = (
	'rs_from_nut_wunspec'		=> 'Receive Router Solicitation from End-Node(NUT)',
	'rs_from_nut'			=> 'Receive Router Solicitation from End-Node(NUT)',
	'rs_from_nut_wsll'		=> 'Receive Router Solicitation from End-Node(NUT)',
	'ra_to_nut'			=> 'Send Router Advertisement from Router(TN)',
	'ns_to_router'			=> 'Receive Neighbor Solicitation from End-Node(NUT)',
	'ns_to_router_linkaddr'		=> 'Receive Neighbor Solicitation from End-Node(NUT)',
	'ns_to_router_linkaddr_w_linkaddr'	=> 'Receive Neighbor Solicitation from End-Node(NUT)',
	'ns_to_router_wo_sllopt'	=> 'Receive Neighbor Solicitation from End-Node(NUT)',
	'na_from_router'		=> 'Send Neighbor Advertisement from Router(TN)',
	'na_from_router_linkaddr'	=> 'Send Neighbor Advertisement from Router(TN)',
	'na_from_router_linkaddr_w_linkaddr' => 'Send Neighbor Advertisement from Router(TN)',
	'ns_to_host'			=> 'Receive Neighbor Solicitation from SGW(NUT)',
	'ns_to_host_linkaddr'		=> 'Receive Neighbor Solicitation from SGW(NUT)',
	'ns_to_host_wo_sllopt'		=> 'Receive Neighbor Solicitation from SGW(NUT)',
	'na_from_host'			=> 'Send Neighbor Advertisement from Host(TN)',
	'na_from_host_linkaddr'		=> 'Send Neighbor Advertisement from Host(TN)',

	'echo_request_from_router'      => 'Send Echo Request from Router(TN)',
	'echo_reply_to_router'          => 'Receive Echo Reply from End-Node(NUT) to Router(TN)',

	'echo_request_from_host1'       => 'Send Echo Request from HOST-1(TN)',
	'echo_reply_to_host1'           => 'Receive Echo Reply from End-Node(NUT) to Host-1(TN)',

	'echo_request_from_host2_esp'	=> 'Send Echo Request with ESP from HOST-2(TN)',
	'echo_reply_to_host2_esp'	=> 'Receive Echo Reply with ESP from End-Node(NUT) to Host-2(TN)',

	'echo_request_from_host1_esp'	=> 'Send Echo Request with ESP from HOST-1(TN)',
	'echo_reply_to_host1_esp'	=> 'Receive Echo Reply with ESP from End-Node(NUT) to Host-1(TN)',

	'syn_request_from_router'	=> 'Send Syn Request from Router(TN)',
	'synack_reply_to_router'	=> 'Receive Syn, Ack Reply from End-Node(NUT) to Router(TN)',
	'reset_request_from_router'	=> 'Send Reset Request from Router(TN)',

	'syn_request_from_host1'	=> 'Send Syn Request from Host-1(TN)',
	'synack_reply_to_host1'		=> 'Receive Syn, Ack Reply from End-Node(NUT) to Host-1(TN)',
	'reset_request_from_host1'	=> 'Send Reset Request from Host-1(TN)',

	'syn_request_from_host2'	=> 'Send Syn Request from Host-2(TN)',
	'synack_reply_to_host2'		=> 'Receive Syn, Ack Reply from End-Node(NUT) to Host-2(TN)',
	'reset_request_from_host2'	=> 'Send Reset Request from Host-2(TN)',

	'syn_request_from_host1_esp'	=> 'Send Syn Request with ESP from Host-1(TN)',
	'synack_reply_to_host1_esp'	=> 'Receive Syn, Ack Reply with ESP from End-Node(NUT) to Host-1(TN)',
	'reset_request_from_host1_esp'	=> 'Send Reset Request with ESP from Host-1(TN)',

	'syn_request_from_host2_esp'	=> 'Send Syn Request with ESP from Host-2(TN)',
	'synack_reply_to_host2_esp'	=> 'Receive Syn, Ack Reply with ESP from End-Node(NUT) to Host-2(TN)',
	'reset_request_from_host2_esp'	=> 'Send Reset Request with ESP from Host-2(TN)',

	'ack_request_from_host1_esp'	=> 'Send Ack Request with ESP from Host1(TN) to End-Node(NUT)',
	'fin_ack_request_from_host1_esp'=> 'Send Fin/Ack Request with ESP from Host1(TN) to End-Node(NUT)',
	'ack_data_request_from_host1_esp_pad255'=> 'Send Ack w/ data Request (Padding Length 255) with ESP from Host1(TN) to End-Node(NUT)',
	'ack_data_request_from_host1_esp'	=> 'Send Ack w/ data Request with ESP from Host1(TN) to End-Node(NUT)',
	'ack_reply_from_host1_esp'		=> 'Send Ack Reply with ESP from Host1(TN) to End-Node(NUT)',

	'esptun_from_sg1_net2_echo_request_from_host2_net3_to_host1_net0'	=> 'Send Encapsulated Echo Request from Host2(TN) to Host1(TN)',
	'echo_request_from_host2_net3_to_host1_net0_via_nut'		=> 'Receive Decapsulated Echo Request from Host2(TN) to Host1(TN) via SGW(NUT)',
	'echo_reply_from_host1_net0_to_host2_net3'			=> 'Send Echo Reply from Host1(TN) to Host2(TN)',
	'esptun_to_sg1_net2_echo_reply_from_host1_net0_to_host2_net3'	=> 'Receive Encapsulated Echo Reply from Host1(TN) to Host2(TN) via SGW(NUT)',
	'echo_reply_from_host1_net0_to_host2_net3_via_nut'		=> 'Receive Echo Reply from Host1(TN) to Host2(TN) via SGW(NUT)',

	'esptun_from_sg1_net2_echo_request_from_host3_net3_to_host1_net0'	=> 'Send Encapsulated Echo Request from Host3(TN) to Host1(TN)',
	'echo_request_from_host3_net3_to_host1_net0_via_nut'		=> 'Receive Decapsulated Echo Request from Host3(TN) to Host1(TN) via SGW(NUT)',
	'echo_reply_from_host1_net0_to_host3_net3'			=> 'Send Echo Reply from Host1(TN) to Host3(TN)',
	'esptun_to_sg1_net2_echo_reply_from_host1_net0_to_host3_net3'	=> 'Receive Encapsulated Echo Reply from Host1(TN) to Host3(TN) via SGW(NUT)',

	'echo_request_from_host1_net0_to_host2_net3'			=> 'Send Echo Request from Host1(TN) to Host2(TN)',
	'esptun_to_sg1_net2_echo_request_from_host1_net0_to_host2_net3'	=> 'Receive Encapsulated Echo Request from Host1(TN) to Host2(TN) via SGW(NUT)',

	'esptun_from_host2_net2_echo_request_from_host2_net2_to_host1_net0'	=> 'Send Encapsulated Echo Request from Host2(TN) to Host1(TN)',
	'echo_request_from_host2_net2_to_host1_net0_via_nut'		=> 'Receive Decapsulated Echo Request from Host2(TN) to Host1(TN) via SGW(NUT)',
	'echo_reply_from_host1_net0_to_host2_net2'			=> 'Send Echo Reply from Host1(TN) to Host2(TN)',
	'esptun_to_host2_net2_echo_reply_from_host1_net0_to_host2_net2'	=> 'Receive Encapsulated Echo Reply from Host1(TN) to Host2(TN) via SGW(NUT)',

	'echo_request_from_host2_net1_to_host0_net0'	=> 'Send Echo Request from Host2(TN) to End-Node(NUT)',
	'echo_reply_from_host0_net0_to_host2_net1'	=> 'Receive Echo Reply from End-Node(NUT) to Host2(TN)',

	'echo_request_from_host4_net4_to_host1_net0'		=> 'Send Echo Request from Host4(TN) to Host1(TN)',
	'echo_request_from_host4_net4_to_host1_net0_via_nut'	=> 'Receive Echo Request from Host4(TN) to Host1(NUT) via SGW(NUT)',
);

#======================================================================
# ipsecExitPass()
#======================================================================
sub ipsecExitPass() {
    vLogHTML('OK<BR>');
    exit $V6evalTool::exitPass;
}

#======================================================================
# ipsecExitIgnore()
#======================================================================
sub ipsecExitIgnore() {
    exit $V6evalTool::exitIgnore;
}

#======================================================================
# ipsecExitNS()
#======================================================================
sub ipsecExitNS() {
    vLogHTML("This test is not supported now<BR>");
    exit $V6evalTool::exitNS;
}

#======================================================================
# ipsecExitWarn()
#======================================================================
sub ipsecExitWarn() {
    vLogHTML('<FONT COLOR="#00FF00">Warn</FONT><BR>');
    exit $V6evalTool::exitWarn;
}

#======================================================================
# ipsecExitEndNodeOnly()
#======================================================================
sub ipsecExitEndNodeOnly() {
    vLogHTML("This test is for the End-Node only<BR>");
    exit $V6evalTool::exitHostOnly;
}

#======================================================================
# ipsecExitSGWOnly()
#======================================================================
sub ipsecExitSGWOnly() {
    vLogHTML("This test is for the SGW only<BR>");
    exit $V6evalTool::exitRouterOnly;
}

#======================================================================
# ipsecExitFail()
#======================================================================
sub ipsecExitFail() {
    vLogHTML('<FONT COLOR="#FF0000">NG</FONT><BR>');
    exit $V6evalTool::exitFail;
}

#======================================================================
# ipsecExitFatal()
#======================================================================
sub ipsecExitFatal() {
    vLogHTML('<FONT COLOR="#FF0000">Fatal</FONT><BR>');
    exit $V6evalTool::exitFatal;
}

#======================================================================
# secERROR()
#======================================================================
sub seqERROR($) {
    my ($msg) = @_;
    vLog($msg);
    vLogHTML('<FONT COLOR="#FF0000">ERROR</FONT><BR>');
    exit $V6evalTool::exitFail;
}

#======================================================================
# ipsecAsyncFail()
#======================================================================
sub ipsecAsyncFail($) {
	my ($msg) = @_;
	vLog($msg);
	vLogHTML('<FONT COLOR="#FF0000">Async Fail</FONT><BR>');
	seqTermination();
#	confess "Sequence Stop" if $debug > 0;
	exit $V6evalTool::exitFail;
}

#======================================================================
# ipsecReboot() - reboot NUT
#======================================================================

sub ipsecReboot() {
	vLogHTML("Target: Reboot");
	$ret = vRemote("reboot.rmt", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot reboot NUT<BR>");
		ipsecExitFatal();
	}
}

#======================================================================
# ipsecRebootAsync() - reboot NUT asynchronously
#======================================================================

sub ipsecRebootAsync() {
	vLogHTML("Target: Reboot Asynchronously");
	$ret = vRemoteAsync("reboot.rmt", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot reboot NUT<BR>");
		ipsecExitFatal();
	}
}

#======================================================================
# ipsecRebootByError() - reboot NUT
#======================================================================

sub ipsecRebootByError($;$){
	my ($IF0, $IF1) = @_;

	if($IPSEC::MANUAL_ADDR_CONF eq undef){
		vLogHTML("Target: Reboot asynchronously");
		my $ret = vRemoteAsync("reboot.rmt", $remote_debug);
		if ($ret) {
			vLogHTML("Cannot reboot NUT<BR>");
			ipsecExitFatal();
		}
	}
	else{
		vLogHTML("Target: Reboot");
		my $ret = ipsecReboot();
		if ($ret) {
			vLogHTML("Cannot reboot NUT<BR>");
			ipsecExitFatal();
		}
	}

	#======================================================================
	# Type check of NUT
	#======================================================================
	my $type=$V6evalTool::NutDef{Type};

	if($REBOOT_TO_CLEAR_SA_CONF ne undef){
		if($MANUAL_ADDR_CONF ne undef){
			if($type eq 'host'){
				my $IF0_NAME = ipsecLinkDev("$IF0");
				my $ret = undef;
				$ret = vRemote(
					'manualaddrconf.rmt',
					"if=$IF0_NAME",
					"addr=$IPSEC::IPsecAddr{'IPSEC_NUT_NET0_ADDR'}",
					"len=$IPSEC::IPsecAddr{'IPSEC_NET0_PREFIX_LEN'}",
					'type=unicast'
					);

				if ($ret) {
					vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
					exit $V6evalTool::exitFatal;
				}

				$ret = vRemote(
					'route.rmt',
					'cmd=add',
					"if=$IF0_NAME",
					#"prefix=$IPSEC::IPsecAddr{'IPSEC_NET1_PREFIX'}",
					#"prefixlen=$IPSEC::IPsecAddr{'IPSEC_NET1_PREFIX_LEN'}",
					"prefix=default",
					"gateway=$IPSEC::IPsecAddr{'IPSEC_ROUTER_NET0_ADDR'}",
					);

				if ($ret) {
					vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
					exit $V6evalTool::exitFatal;
				}
				vSleep($WAIT_ASSIGN_ADDR);
			}
			else{
				vSleep($REBOOT_WAIT_TIME);
			}
		}
		else{
			my %ret = vRecvRS($IF0, $REBOOT_WAIT_TIME, 0, 0, 0);
			if ($ret{status} != 0) {
				vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
				ipsecExitFail();
			}
			vSleep($WAIT_ASSIGN_ADDR);
		}
	}
	elsif($type eq 'host'){
		if($MANUAL_ADDR_CONF ne undef){
			my $IF0_NAME = ipsecLinkDev("$IF0");
			my $ret = undef;
			$ret = vRemote(
				'manualaddrconf.rmt',
				"if=$IF0_NAME",
				"addr=$IPSEC::IPsecAddr{'IPSEC_NUT_NET0_ADDR'}",
				"len=$IPSEC::IPsecAddr{'IPSEC_NET0_PREFIX_LEN'}",
				'type=unicast'
				);

			if ($ret) {
				vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
				exit $V6evalTool::exitFatal;
			}

			$ret = vRemote(
				'route.rmt',
				'cmd=add',
				"if=$IF0_NAME",
				#"prefix=$IPSEC::IPsecAddr{'IPSEC_NET1_PREFIX'}",
				#"prefixlen=$IPSEC::IPsecAddr{'IPSEC_NET1_PREFIX_LEN'}",
				"prefix=default",
				"gateway=$IPSEC::IPsecAddr{'IPSEC_ROUTER_NET0_ADDR'}",
				);

			if ($ret) {
				vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
				exit $V6evalTool::exitFatal;
			}
			vSleep($WAIT_ASSIGN_ADDR);
		}
		else{
			my %ret = vRecvRS($IF0, $REBOOT_WAIT_TIME, 0, 0, 0);
			if ($ret{status} != 0) {
				vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
				ipsecExitFail();
			}
			vSleep($WAIT_ASSIGN_ADDR);
		}
	}

	if($IPSEC::MANUAL_ADDR_CONF eq undef){
		ipsecRemoteAsyncWait();
	}
	return;
}


#======================================================================
# ipsecRebootToClean() - cleanup NUT status
#     none  success to set address to NUT
#     exit  error
#======================================================================

sub ipsecRebootToClean(;$$) {
	my ($IF0, $IF1) = @_;
	my $type=$V6evalTool::NutDef{Type};

	#######################
	# Cleanup NUT
	#######################
	if($MANUAL_ADDR_CONF ne undef){
		vLogHTML("Target: Cleanup NUT");
		my $ret = ipsecReboot();
		if ($ret) {
			vLogHTML("Cannot reboot NUT<BR>");
			ipsecExitFatal();
		}
		if($type eq 'host'){
			my $IF0_NAME = ipsecLinkDev("$IF0");
			my $ret = undef;
			$ret = vRemote(
				'manualaddrconf.rmt',
				"if=$IF0_NAME",
				"addr=$IPSEC::IPsecAddr{'IPSEC_NUT_NET0_ADDR'}",
				"len=$IPSEC::IPsecAddr{'IPSEC_NET0_PREFIX_LEN'}",
				'type=unicast'
				);

			if ($ret) {
				vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
				exit $V6evalTool::exitFatal;
			}

			$ret = vRemote(
				'route.rmt',
				'cmd=add',
				"if=$IF0_NAME",
				#"prefix=$IPSEC::IPsecAddr{'IPSEC_NET1_PREFIX'}",
				#"prefixlen=$IPSEC::IPsecAddr{'IPSEC_NET1_PREFIX_LEN'}",
				"prefix=default",
				"gateway=$IPSEC::IPsecAddr{'IPSEC_ROUTER_NET0_ADDR'}",
				);

			if ($ret) {
				vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
				exit $V6evalTool::exitFatal;
			}
			vSleep($WAIT_ASSIGN_ADDR);
		}
		else{
			vSleep($REBOOT_WAIT_TIME);
		}
	}
	elsif($type eq 'router'){
		vLogHTML("Target: Cleanup NUT");
		my $ret = ipsecReboot();
		if ($ret) {
			vLogHTML("Cannot reboot NUT<BR>");
			ipsecExitFatal();
		}

		if($IF0 eq undef || $IF1 eq undef){
			vLogHTML('<FONT COLOR="#FF0000">NG: interface name is null</FONT>');
			exit $V6evalTool::exitFatal;
		}
		my $ret = ipsecSetAddrSGW($IF0, $IF1);
		if ($ret eq $IPSEC::FAIL){
			ipsecExitFail();
		}
	}
	else{
		vLogHTML("Target: Cleanup NUT asynchronously");
		my $ret = vRemoteAsync("reboot.rmt", $remote_debug);
		if ($ret) {
			vLogHTML("Cannot reboot NUT<BR>");
			ipsecExitFatal();
		}

		my %ret = vRecvRS($IF0, $REBOOT_WAIT_TIME, 0, 0, 0);
		if ($ret{status} != 0) {
			vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
			ipsecExitFail();
		}

		vSleep($WAIT_ASSIGN_ADDR);
		ipsecRemoteAsyncWait();
	}

	return;
}


#======================================================================
# ipsecResetMTU() - reset the MTU of NUT
#======================================================================

sub ipsecResetMTU() {
	vLogHTML("Target: Reset the MTU");
	$ret = vRemote("clearmtu.rmt", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot reset MTU of NUT<BR>");
		ipsecExitFatal();
	}
}

#======================================================================
# ipsecResetNUT() - reset the NUT
#     none  success to reset NUT
#     exit  error
#======================================================================

sub ipsecResetNUT(;$$) {
	my ($IF0, $IF1) = @_;

	vLogHTML("Target: Reset NUT ");

	if($REBOOT_TO_RESET_MTU ne undef){
		ipsecRebootToClean($IF0,$IF1);
	}
	else{
		ipsecResetMTU();
	}
	return;
}


#======================================================================
# ipsecCheckNUT() - check NUT
#======================================================================

sub ipsecCheckNUT($;$$) {
	my($require,$function_type,$function_name) = @_;

	#======================================================================
	# Over write configuration by config file
	#======================================================================
	ipsecOverWriteConfig();

	#======================================================================
	# Check support function
	#======================================================================
	vLogHTML("Test Type: $function_type, Function Name: $function_name") if $test_debug;
	my $match = undef;
	if($function_type eq 'ADVANCED'){
		foreach my $key (keys %advanced_functions){
			if (($function_name eq $key) && ($advanced_functions{$key} eq 'yes')){
				vLogHTML("$key: $advanced_functions{$key}") if $test_debug;
				$match++;
				last;
			}
		}
		if(!$match){
			ipsecExitNS();
		}
	}

	$type=$V6evalTool::NutDef{Type};
	if($type eq 'host') {
		# In those cases configuration are wrong.
		if ($require eq 'sgw' && $DEV_TYPE ne 'sgw') {
			ipsecExitSGWOnly();
		}
		elsif ($require eq 'host' && $DEV_TYPE eq 'sgw') {
			ipsecExitEndNodeOnly();
		}
	}
	elsif($type eq 'router') {
		# a router should run both type test (sgw, endo-node)
		if ($require eq 'sgw' && $DEV_TYPE ne 'sgw') {
			ipsecExitSGWOnly();
		}
		elsif ($require eq 'host' && $DEV_TYPE eq 'sgw') {
			ipsecExitEndNodeOnly();
		}
	}
	else {
		vLogHTML("Unknown NUT type $type : check nut.def<BR>");
		ipsecExitFatal();
	}
}

sub ipsecLinkDev($)
{
	my ($req_link) = @_;
	my $link_name = undef;

	my $KEY = $req_link . "_device";
	foreach(keys(%V6evalTool::NutDef)) {
		if(/^$KEY/) {
			$link_name=$V6evalTool::NutDef{$_};
			last;
		}
	}
	vLogHTML("Link Device name: $link_name<BR>") if $test_debug;
	return $link_name;
}

#======================================================================
#  $retstat = ipsecSetAddr() - set address for End-Node
#
#  $retstat : return status
#     0    success
#    -1    something error
#======================================================================
sub
ipsecSetAddr($)
{
	my ($IF0) = @_;

	print STDERR "IF: $IF0\n";

	%pktdesc = (
		%pktdesc,
	);

	#======================================================================
	# Type check of NUT
	#======================================================================
	my $type=$V6evalTool::NutDef{Type};

	my $cpp = undef;
	#======================================================================
	# Setup NUT address
	#======================================================================
	if($MANUAL_ADDR_CONF ne undef){
		$cpp = "-DMANUAL_ADDR_CONF ";
		$cpp .= "-DIPSECGLOBALADDR=\\\"$IPSEC::IPsecAddr{'IPSEC_NUT_NET0_ADDR'}\\\" ";
		vCPP($cpp);
	}

	if($REBOOT_TO_CLEAR_SA_CONF ne undef){
		if($MANUAL_ADDR_CONF eq undef){
			my %ret = vRecvRS($IF0, $REBOOT_WAIT_TIME, 0, 0, 0);
			if ($ret{status} != 0) {
				vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
				goto error;
			}
			vSleep($WAIT_ASSIGN_ADDR);
		}
		else{
			vSleep($REBOOT_WAIT_TIME);
		}
	}
	elsif($type eq 'host'){
		if($MANUAL_ADDR_CONF eq undef){
			my %ret = vRecvRS($IF0, $REBOOT_WAIT_TIME, 0, 0, 0);
			if ($ret{status} != 0) {
				vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
				goto error;
			}
			vSleep($WAIT_ASSIGN_ADDR);
		}
		else{
			vSleep($WAIT_ASSIGN_ADDR);
		}
	}

	if($MANUAL_ADDR_CONF ne undef){
		my $IF0_NAME = ipsecLinkDev("$IF0");
		my $ret = undef;
		$ret = vRemote(
			'manualaddrconf.rmt',
			"if=$IF0_NAME",
			"addr=$IPSEC::IPsecAddr{'IPSEC_NUT_NET0_ADDR'}",
			"len=$IPSEC::IPsecAddr{'IPSEC_NET0_PREFIX_LEN'}",
			'type=unicast'
			);

		if ($ret) {
			vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
			exit $V6evalTool::exitFatal;
		}

		$ret = vRemote(
			'route.rmt',
			'cmd=add',
			"if=$IF0_NAME",
			#"prefix=$IPSEC::IPsecAddr{'IPSEC_NET1_PREFIX'}",
			#"prefixlen=$IPSEC::IPsecAddr{'IPSEC_NET1_PREFIX_LEN'}",
			"prefix=default",
			"gateway=$IPSEC::IPsecAddr{'IPSEC_ROUTER_NET0_ADDR'}",
			);

		if ($ret) {
			vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
			exit $V6evalTool::exitFatal;
		}

		vSleep($WAIT_ASSIGN_ADDR);
	}

	#======================================================================
	# ping TN(Router) <-> NUT
	#======================================================================
	my $addr = undef;
	if($MANUAL_ADDR_CONF ne undef){
		$addr = $IPSEC::IPsecAddr{'IPSEC_NUT_NET0_ADDR'};
	}
	else{
		vClear($IF0);
		%status = vSend($IF0, echo_request_from_router);
		$addr = $status{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
		$cpp = "-DMANUAL_ADDR_CONF ";
		$cpp .= "-DIPSECGLOBALADDR=\\\"$addr\\\" ";
		vCPP($cpp);
		# To stable nut status
		%ret = vRecvWrapper($IF0, 5, 0, 0, 0,'echo_reply_to_router');
	}

	if(open(IN, "$ADDR_DEF_TMPL") == 0) {;
		print STDERR "$AADR_DEF_TMPL: $!\n";
		goto error;
	}
	if(open(OUT, "> $ADDR_DEF") == 0) {
		print STDERR "$ADDR_DEF: $!\n";
		goto error;
	}
	while(<IN>) {
		if(/#define\s+IPSEC_NUT_NET0_ADDR/) {
			s/IPSECGLOBALADDR/\"$addr\"/;
		}
		elsif(/#define\s+IPSEC_TN_NET1_HOST2_ADDR\s+\"(\S+)\"/) {
			$IPsecAddr{IPSEC_TN_NET1_HOST2_ADDR} = $1;
		}
		elsif(/#define\s+IPSEC_TN_NET1_HOST3_ADDR\s+\"(\S+)\"/) {
			$IPsecAddr{IPSEC_TN_NET1_HOST3_ADDR} = $1;
		}
		print OUT $_;
		$IPsecAddr{IPSEC_NUT_NET0_ADDR} = $addr;
	}
	close(IN);
	close(OUT);

	print "#define IPSEC_NUT_NET0_ADDR         $IPsecAddr{IPSEC_NUT_NET0_ADDR}\n" if $test_debug;
	print "#define IPSEC_NUT_NET1_ADDR         $IPsecAddr{IPSEC_NUT_NET1_ADDR}\n" if $test_debug;

	vLogHTML('OK<BR>');
	$retstat = $SUCCESS;
	return ($retstat);

error:
	$retstat = $FAIL;
	return ($retstat);
}

#======================================================================
#  $retstat = ipsecSetAddrSGW() - set address for SGW
#
#  $retstat : return status
#     0 success
#    -1 something error
#======================================================================
sub
ipsecSetAddrSGW($$)
{
	my ($IF0, $IF1) = @_;

	print STDERR "IF: $IF0, IF1: $IF1\n";

	%pktdesc = (
		%pktdesc,
	);

	#======================================================================
	# Setup NUT address
	#======================================================================
	if($REBOOT_TO_CLEAR_SA_CONF ne undef){
		vSleep($REBOOT_WAIT_TIME);
	}

	my $IF0_NAME = ipsecLinkDev("$IF0");
	my $IF1_NAME = ipsecLinkDev("$IF1");

	my $ret = undef;
	$ret = vRemote(
		'manualaddrconf.rmt',
		"if=$IF0_NAME",
		"addr=$IPSEC::IPsecAddr{'IPSEC_NUT_NET0_ADDR'}",
		"len=$IPSEC::IPsecAddr{'IPSEC_NET0_PREFIX_LEN'}",
		'type=unicast'
		);

	if ($ret) {
		vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
		exit $V6evalTool::exitFatal;
	}

	$ret = vRemote(
		'manualaddrconf.rmt',
		"if=$IF1_NAME",
		"addr=$IPSEC::IPsecAddr{'IPSEC_NUT_NET1_ADDR'}",
		"len=$IPSEC::IPsecAddr{'IPSEC_NET1_PREFIX_LEN'}",
		'type=unicast'
		);

	if ($ret) {
		vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
		exit $V6evalTool::exitFatal;
	}

	#======================================================================
	# Set up default route
	#======================================================================
	$ret = vRemote(
		'route.rmt',
		'cmd=add',
		"if=$IF1_NAME",
		"prefix=default",
		#"prefixlen=$IPSEC::IPsecAddr{'IPSEC_DEFAULT_PREFIX_LEN'}",
		"gateway=$IPSEC::IPsecAddr{'IPSEC_ROUTER_NET1_ADDR'}",
		);

	if ($ret) {
		vLogHTML('<FONT COLOR="#FF0000">NG</FONT>');
		exit $V6evalTool::exitFatal;
	}

	vSleep($WAIT_ASSIGN_ADDR);

	vLogHTML('OK<BR>');
	$retstat = $SUCCESS;
	return ($retstat);

error:
	$retstat = $FAIL;
	return ($retstat);
}


#======================================================================
# ipsecSetSAD() - set SAD entries
#======================================================================

sub ipsecSetSAD(@) {
	vLogHTML("Target: Set SAD entries: @_");
	$ret = vRemote("ipsecSetSAD.rmt", "@_", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Set SAD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
		    ipsecExitNS();
		}
		else {
		    ipsecExitFail();
		}
	}
}

#======================================================================
# ipsecSetSADAsync() - set SAD entries
#======================================================================

sub ipsecSetSADAsync(@) {
	vLogHTML("Target: Set SAD entries: @_");
	$ret = vRemoteAsync("ipsecSetSAD.rmt", "@_", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Set SAD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
		    ipsecExitNS();
		}
		else {
		    ipsecExitFail();
		}
	}
}

#======================================================================
# ipsecSetSPD() - set SPD entries
#======================================================================

sub ipsecSetSPD(@) {
	vLogHTML("Target: Set SPD entries: @_");
	$ret = vRemote("ipsecSetSPD.rmt", "@_", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Set SPD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
		    ipsecExitNS();
		}
		else {
		    ipsecExitFail();
		}
	}
}

#======================================================================
# ipsecSetSPDAsync() - set SPD entries
#======================================================================

sub ipsecSetSPDAsync(@) {
	vLogHTML("Target: Set SPD entries: @_");
	$ret = vRemoteAsync("ipsecSetSPD.rmt", "@_", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Set SPD entries: @_ <BR>");
		if ($ret == $V6evalTool::exitNS) {
		    ipsecExitNS();
		}
		else {
		    ipsecExitFail();
		}
	}
}

#==============================================
#  Wait for asynchronous remote script
#  forked by vRemoteAsync()
#==============================================
sub ipsecRemoteAsyncWait() {
	my $ret = vRemoteAsyncWait();
	ipsecAsyncFail("vRemoteAsyncWait failed :return status = $ret") if $ret != 0;
}

#======================================================================
# ipsecClearAll() - clear all SAD and SPD entries
#======================================================================

sub ipsecClearAll() {
	vLogHTML("Target: Clear all SAD and SPD entries");
	$ret = vRemote("ipsecClearAll.rmt", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot Clear all SAD and SPD entries<BR>");
		if ($ret == $V6evalTool::exitNS) {
		    ipsecExitNS();
		}
		else {
		    ipsecExitFail();
		}
	}
}

#======================================================================
# ipsecEnable() - Enable and start IPsec function
#======================================================================

sub ipsecEnable() {
	vLogHTML("Target: Enable and start IPsec function");
	$ret = vRemote("ipsecEnable.rmt", $remote_debug);
	if ($ret) {
		vLogHTML("Cannot start IPsec<BR>");
		if ($ret == $V6evalTool::exitNS) {
		    ipsecExitNS();
		}
		else {
		    ipsecExitFail();
		}
	}
}

########################################################################
#       Get time string
#
#       If more detailed format is required, you may switch to use
#       prepared perl modlue.
#-----------------------------------------------------------------------
sub getTimeUTC() {
        my $sec = time;
        my $timestr = sprintf('%16d', $sec);
        $timestr;
}

sub getTimeStamp() {
        my ($sec,$min,$hour) = localtime;
        my $timestr = sprintf('%02d:%02d:%02d', $hour, $min, $sec);
        $timestr;
}

#======================================================================
# ($retstat, %ret) = ipsecPing2NUT() - emulate ping to NUT
#
#  $retstat : return status
#    'GOT_REPLY' ping to NUT successfully
#    'NO_REPLY'  echo request ignored by NUT
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#======================================================================
sub ipsecPing2NUT($$$) {
	my ($IF,
	$echo_request_to_nut,     # "echo_request"
	$echo_reply_from_nut_s,   # "echo_reply1 echo_reply2 ..."
	) = @_;
	my ($retstat,	# return status 1
		%ret);	# return status 2 (last vRecv())
	my (@echo_reply_from_nut_s) = split(/\s+/, $echo_reply_from_nut_s);

	vClear($IF);
	## send echo request to NUT
	vSend($IF, $echo_request_to_nut);

	## receive echo reply or ns from NUT
	%ret = vRecvWrapper($IF, 3, 0, 0, 0, @echo_reply_from_nut_s);
	unless($ret{'recvCount'}){
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}
	my $match = undef;
	foreach my $frames (@echo_reply_from_nut_s){
		if ($ret{recvFrame} eq $frames) {
			$match++;
			last;
		}
	}
	if (!$match) {
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}

	## receive syn,ack reply or ns from NUT
	## if NC state is PROBE, force NC to be REACHABLE
	vRecvNS($IF, 3, 0, 0, 2);

	$retstat = 'GOT_REPLY';
	return ($retstat, %ret);
}



#======================================================================
# ($retstat, %ret) = ipsecPingFromNUT() - emulate ping from NUT
#
#  $retstat : return status
#    'GOT_REQUEST' ping from NUT successfully
#    'NO_REQUEST'  no echo reply
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#======================================================================
sub ipsecPingFromNUT($$$) {
	my ($IF,
	$echo_request_from_nut,
	$echo_reply_to_nut, 
	) = @_;

	my ($retstat,	# return status 1
		%ret);	# return status 2 (last vRecv())

	## receive echo reply or ns from NUT
	%ret = vRecvWrapper($IF, 10, 0, 0, 0, $echo_request_from_nut);
	unless($ret{'recvCount'}){
		$retstat = 'NO_REQUEST';
		return ($retstat, %ret);
	}

	unless($ret{recvFrame} eq $echo_request_from_nut) {
		$retstat = 'NO_REQUEST';
		return ($retstat, %ret);
	}

	my $cpp = '';
	my $base = 'Frame_Ether.Packet_IPv6.Hdr_ESP.';

	$cpp .= " -DICMP_IDENTIFIER_DYN=$ret{$base.
		'Decrypted.ESPPayload.ICMPv6_EchoRequest.Identifier'}";

	$cpp .= " -DICMP_SEQUENCENUMBER_DYN=$ret{$base.
		'Decrypted.ESPPayload.ICMPv6_EchoRequest.SequenceNumber'}";

	$cpp .= " -DESP_SEQUENCENUMBER_DYN=$ret{$base. 'SequenceNumber'}";

	$cpp .= " -DECHO_DATA_DYN=\\\"$ret{$base.
		'Decrypted.ESPPayload.ICMPv6_EchoRequest.Payload.data'}\\\"";

	vCPP($cpp);

	## send echo request to NUT
	vSend($IF, $echo_reply_to_nut);

	## receive syn,ack reply or ns from NUT
	## if NC state is PROBE, force NC to be REACHABLE
	vRecvNS($IF, 3, 0, 0, 2);

	$retstat = 'GOT_REQUEST';

	return ($retstat, %ret);
}

#======================================================================
# ($retstat, $payload, %ret) = ipsecPingFrag2NUT() - emulate ping to NUT (Fragment)
#
#  $retstat : return status
#    'GOT_REPLY' ping to NUT successfully
#    'ERROR'     found something failure
#  $payload : return payload raw data
#  %ret : status of last vRecv()
#======================================================================
sub ipsecPingFrag2NUT($$$$$) {
	my ($IF,
		$echo_request_to_nut_1st,
		$echo_request_to_nut_2nd,
		$echo_reply_from_nut_1st,
		$echo_reply_from_nut_2nd,
	) = @_;
	my ($retstat,    # return status 1
		%ret);   # return status 2 (last vRecv())

	vClear($IF);

	## send echo request to NUT
	vSend($IF, $echo_request_to_nut_1st);
	if ($echo_request_to_nut_2nd ne 'null'){
		vSend($IF, $echo_request_to_nut_2nd);
	}

	my $base_path = 'Frame_Ether.Packet_IPv6.Payload.data';

	my $payload_1st = undef;
	my $payload_2nd = undef;
	my $payload = undef;
	## receive echo reply or ns from NUT
	%ret = vRecvWrapper($IF, 3, 0, 0, 0, $echo_reply_from_nut_1st, $echo_reply_from_nut_2nd);

	if($test_debug > 1){
		foreach my $key (keys %ret) {
			vLogHTML("$key: $ret{$key}<BR>");
		}
	}

	if ($ret{status} == 0 && $ret{recvFrame} eq $echo_reply_from_nut_1st) {
		$payload_1st = $ret{$base_path};
		%ret = vRecvWrapper($IF, 5, 0, 0, 0, $echo_reply_from_nut_2nd);
		if ($ret{status} == 0 && $ret{recvFrame} eq $echo_reply_from_nut_2nd) {
			$retstat = 'GOT_REPLY';
			$payload_2nd = $ret{$base_path};
			$payload = $payload_1st . $payload_2nd;
			chomp($payload);
			vLogHTML("Reassembled Payload:<BR>$payload<BR>") if $test_debug;
			## receive syn,ack reply or ns from NUT
			## if NC state is PROBE, force NC to be REACHABLE
			vRecvNS($IF, 3, 0, 0, 2);
			return ($retstat, $payload, %ret);
		}
	}
	if ($ret{status} == 0 && $ret{recvFrame} eq $echo_reply_from_nut_2nd) {
		%ret = vRecvWrapper($IF, 5, 0, 0, 0, $echo_reply_from_nut_1st);
		$payload_2nd = $ret{$base_path};
		if ($ret{status} == 0 && $ret{recvFrame} eq $echo_reply_from_nut_1st) {
			$retstat = 'GOT_REPLY';
			$payload_1st = $ret{$base_path};
			$payload = $payload_1st . $payload_2nd;
			chomp($payload);
			vLogHTML("Reassembled Payload:<BR>$payload<BR>") if $test_debug;
			## receive syn,ack reply or ns from NUT
			## if NC state is PROBE, force NC to be REACHABLE
			vRecvNS($IF, 3, 0, 0, 2);
			return ($retstat, $payload, %ret);
		}
	}
	$retstat = 'ERROR';
	$payload = 'NULL';
	vLogHTML("Reassembled Payload:<BR>$payload<BR>") if $test_debug;
	return ($retstat, $payload, %ret);
}

#======================================================================
# ($retstat, %ret) = ipsecPingFragForward() - emulate ping to NUT (Fragment)
#
#  $retstat : return status
#    'GOT_REPLY' ping to NUT successfully
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#======================================================================
sub ipsecPingFragForward($$$$$) {
	my ($IF_to_nut, $IF_from_nut,
		$echo_request_to_nut_1st,
		$echo_request_to_nut_2nd,
		$echo_request_from_nut_s,
	) = @_;
	my ($retstat,    # return status 1
		%ret);   # return status 2 (last vRecv())

	my (@packet_from_nut_s) = split(/\s+/, $echo_request_from_nut_s);

	vClear($IF_to_nut);
	vClear($IF_from_nut);

	## send echo request to NUT
	vSend($IF_to_nut, $echo_request_to_nut_1st);
	if ($echo_request_to_nut_2nd ne 'null'){
		vSend($IF_to_nut, $echo_request_to_nut_2nd);
	}

	## receive echo reply or ns from NUT
	%ret = vRecvWrapper($IF_from_nut, 2, 0, 0, 2, @packet_from_nut_s);

	if($test_debug > 1){
		foreach my $key (keys %ret) {
			vLogHTML("$key: $ret{$key}<BR>");
		}
	}

	unless($ret{'recvCount'}){
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}
	my $match = undef;
	foreach my $frames (@packet_from_nut_s){
		if ($ret{recvFrame} eq $frames) {
			$match++;
			last;
		}
	}
	if (!$match) {
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}

	$retstat = 'GOT_REPLY';
	return ($retstat, %ret);
}

#=========================================================================================
# ($retstat, %ret) = ipsecSendDummy() - checking Dummy packet
#
#  $retstat : return status
#    0  success
#   -1  not correct packet
#  %ret : status of last vRecv()
#=========================================================================================
sub ipsecSendDummy($$$$) {
	my (	$IF_to_dummy,  # I/F for send to Dummy
		$cpp,	       # cpp
		$payload,      # compared payload data of NUT
		$dummy_packet, # dummy packet(s) from NUT
	) = @_;
	my ($retstat,    # return status 1
		%ret);   # return status 2 (last vRecv())

	#================================
	# get SPI from original paylod
	#================================
	my $spi = substr ($payload, 0, 8);
	$spi = hex $spi;
	vLogHTML("SPI: $spi<BR>") if $test_debug ;

	#=========================================
	# get Sequence Number from original paylod
	#=========================================
	my $seqnum = substr ($payload, 8, 8);
	$seqnum = hex $seqnum;
	vLogHTML("Sequence Number: $seqnum<BR>") if $test_debug;

	#================================
	# get IV from original paylod
	#================================
	my $iv = substr ($payload, 16, 16);
	if($iv ne udnef){
		$cpp .= " -DINITIAL_VECTOR=\\\"$iv\\\"";
	}
	else{
		vLogHTML("<FONT COLOR=\"#FF0000\">Can't get IV</FONT><BR>");
		$retstat = $FAIL;
		return ($retstat, %ret);
	}
	vLogHTML("IV: $iv<BR>") if $test_debug;
	vLogHTML("CPP: $cpp<BR>") if $test_debug > 1;
	vCPP($cpp);

	#================================
	# ping TN(Host1) --> Dummy Target
	#================================
	my $base_path = 'Frame_Ether.Packet_IPv6.Hdr_ESP';

	vClear($IF_to_dummy);
	%ret = vSend3($IF_to_dummy, $dummy_packet);

	if($test_debug > 1){
		foreach my $key (keys %ret) {
			vLogHTML("$key: $ret{$key}<BR>");
		}
	}

	#================================
	# SPI compare
	#================================
	my $dummy_spi = $ret{$base_path.'.SPI'};
	if ($spi ne $dummy_spi){
		vLogHTML("<FONT COLOR=\"#FF0000\">Not match SPI: $spi, ex: $dummy_spi</FONT><BR>");
		$retstat = $FAIL;
		return ($retstat, %ret);
	}

	#================================
	# Sequence Number compare
	#================================
	my $dummy_seqnum = $ret{$base_path.'.SequenceNumber'};
	if ($seqnum ne $dummy_seqnum){
		vLogHTML("<FONT COLOR=\"#FF0000\">Not match Sequence Number: $seqnum, ex: $dummy_seqnum</FONT><BR>");
		$retstat = $FAIL;
		return ($retstat, %ret);
	}

	#================================
	# Encrypted data compare
	#================================
	my $encrypted = substr ($payload, 16);
	my $enc_length = length $encrypted;
	vLogHTML("Compared Encrypted Payload($enc_length):<BR>$encrypted<BR>") if $test_debug;

	my $dummy_payload = $ret{$base_path.'.Crypted'};
	chomp($dummy_payload);
	my $dummy_length = length $dummy_payload;
	vLogHTML("Expected Created Payload($dummy_length):<BR>$dummy_payload<BR>") if $test_debug;

	if ($encrypted ne $dummy_payload){
		vLogHTML("<FONT COLOR=\"#FF0000\">Not match Encrypted data:</FONT><BR>comp:<BR>$encrypted<BR>Ex:<BR>$dummy_payload<BR>");
		$retstat = $FAIL;
		return ($retstat, %ret);
	}

	vLogHTML("<FONT COLOR=\"#0000FF\">Reassembled data is matched with expected data</FONT><BR>");
	$retstat = $SUCCESS;

	return ($retstat, %ret);
}

#=========================================================================================
# ($retstat, %ret) = ipsecForwardBidir() - checking Forwarding packet bi-directionally
#
#  $retstat : return status
#    'GOT_REPLY' got encapsulated packet from NUT successfully
#    'NO_REPLY'  no packet from NUT
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#=========================================================================================
sub ipsecForwardBidir($$$$$$) {
	my (	$IF_to_nut,		  # I/F for send to NUT
		$IF_from_nut,		  # I/F for recv from NUT
		$packet_to_nut,           # packet to NUT (before encapsulation)
		$packet_from_nut_s,       # packet(s) from NUT (after encapsulation)
		$packet_to_nut2,          # packet to NUT (after encapsulation)
		$packet_from_nut_s2,      # packet(s) from NUT (before encapsulation)
	) = @_;
	my ($retstat,    # return status 1
		%ret);   # return status 2 (last vRecv())
	my (@packet_from_nut_s) = split(/\s+/, $packet_from_nut_s);
	my (@packet_from_nut_s2) = split(/\s+/, $packet_from_nut_s2);

	#=======================================
	# ping TN(Host1) <-> TN(Host2,3) via NUT
	#=======================================
	vClear($IF_to_nut);
	vClear($IF_from_nut);

	vSend($IF_to_nut, $packet_to_nut);

	%ret = vRecvWrapper($IF_from_nut, 5, 0, 0, 0, @packet_from_nut_s);
	unless($ret{'recvCount'}){
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}
	my $match = undef;
	foreach my $frames (@packet_from_nut_s){
		if ($ret{recvFrame} eq $frames) {
			$match++;
			last;
		}
	}
	if (!$match) {
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}

	vClear($IF_to_nut);
	vClear($IF_from_nut);

	vSend($IF_from_nut, $packet_to_nut2);
	%ret = vRecvWrapper($IF_to_nut, 5, 0, 0, 0, @packet_from_nut_s2);
	unless($ret{'recvCount'}){
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}
	my $match = undef;
	foreach my $frames (@packet_from_nut_s2){
		if ($ret{recvFrame} eq $frames) {
			$match++;
			last;
		}
	}
	if (!$match) {
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}

	$retstat = 'GOT_REPLY';
	return ($retstat, %ret);
}

#=========================================================================================
# ($retstat, %ret) = ipsecForwardOneWay() - checking Forwarding packet one-way
#
#  $retstat : return status
#    'GOT_REPLY' got encapsulated packet from NUT successfully
#    'NO_REPLY'  no packet from NUT
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#=========================================================================================
sub ipsecForwardOneWay($$$$) {
	my (	$IF_to_nut,		  # I/F for send to NUT
		$IF_from_nut,		  # I/F for recv from NUT
		$packet_to_nut,           # packet to NUT (before encapsulation)
		$packet_from_nut_s,       # packet(s) from NUT (after encapsulation)
	) = @_;
	my ($retstat,    # return status 1
		%ret);   # return status 2 (last vRecv())
	my (@packet_from_nut_s) = split(/\s+/, $packet_from_nut_s);

	#=======================================
	# ping TN(Host1) --> TN(Host2,3) via NUT
	#=======================================
	vClear($IF_to_nut);
	vClear($IF_from_nut);

	vSend($IF_to_nut, $packet_to_nut);

	%ret = vRecvWrapper($IF_from_nut, 5, 0, 0, 0, @packet_from_nut_s);
	unless($ret{'recvCount'}){
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}
	my $match = undef;
	foreach my $frames (@packet_from_nut_s){
		if ($ret{recvFrame} eq $frames) {
			$match++;
			last;
		}
	}
	if (!$match) {
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}

	$retstat = 'GOT_REPLY';
	return ($retstat, %ret);
}

#======================================================================
# ($retstat, %ret) = ipsecTcp2NUT() - emulate TCP to NUT
#
#  $retstat : return status
#    'GOT_REPLY' tcp send syn to NUT successfully
#    'NO_REPLY'  tcp syn ignored by NUT
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#======================================================================
sub ipsecTcp2NUT($$$$;$$){
	my ($IF,
		$CPP,
		$syn_request_from_host1_esp,   # "send syn request"
		$synack_reply_to_host1_esp_s,  # "recv syn,ack replys"
		$ns_from_nut,             # "ns target address global"
		$na_to_nut,               # "na target address global"
		$ns_from_nut_linkaddr,    # "ns target address link-local"
		$na_to_nut_linkaddr       # "na target address link-local"
	) = @_;
	my ($retstat,	# return status 1
		%ret);	# return status 2 (last vRecv())
	my (@synack_reply_to_host1_esp_s) = split(/\s+/, $synack_reply_to_host1_esp_s);

	## set vCPP
	vCPP("$CPP");

	## send echo request to NUT
	vSend($IF, $syn_request_from_host1_esp);

	## receive syn,ack reply or ns from NUT
	%ret = vRecvWrapper($IF, 5, 0, 0, 0, @synack_reply_to_host1_esp_s);
	unless($ret{'recvCount'}){
		vLogHTML('Cannot receive TCP Syn, Ack Reply.<BR>');
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}
	my $match = undef;
	foreach my $frames (@synack_reply_to_host1_esp_s){
		if ($ret{recvFrame} eq $frames) {
			$match++;
			last;
		}
	}
	if(!$match){
		vLogHTML('Cannot receive TCP Syn, Ack Reply.<BR>');
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}

	$retstat = 'GOT_REPLY';
	return ($retstat, %ret);
}

#======================================================================
# ($retstat, %ret) = ipsecResetTcp2NUT() - emulate TCP to NUT
#
#  $retstat : return status
#    'GOT_REPLY' tcp send reset to NUT successfully
#    'NO_REPLY'  tcp reset ignored by NUT
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#======================================================================
sub ipsecResetTcp2NUT($$$;$$){
	my ($IF,
		$CPP,
		$reset_request_from_host1_esp,   # "send reset request"
		$ns_from_nut,             # "ns target address global"
		$na_to_nut,               # "na target address global"
		$ns_from_nut_linkaddr,    # "ns target address link-local"
		$na_to_nut_linkaddr       # "na target address link-local"
	) = @_;
	my ($retstat,	# return status 1
		%ret);	# return status 2 (last vRecv())
	my (@synack_reply_to_host1_esp_s) = split(/\s+/, $synack_reply_to_host1_esp_s);

	## set vCPP
	vCPP("$CPP");

	## set default packet name
	$ns_from_nut = 'ns_to_router'   unless defined $ns_from_nut;
	$na_to_nut   = 'na_from_router' unless defined $na_to_nut;
	$ns_from_nut_linkaddr = 'ns_to_router_linkaddr'   unless defined $ns_from_nut_linkaddr;
	$na_to_nut_linkaddr   = 'na_from_router_linkaddr' unless defined $na_to_nut_linkaddr;

	## send echo request to NUT
	vSend($IF, $reset_request_from_host1_esp);

	## receive syn,ack reply or ns from NUT
	## if NC state is PROBE, force NC to be REACHABLE
	%ret = vRecvNS($IF, 6, 0, 0, 2);
	if ($ret{status} != 0) {
		vLogHTML('Reset connection between NT and  NUT<BR>');
		$retstat = 'GOT_REPLY';
		return ($retstat, %ret);
	}

	$retstat = 'NO_REPLY';
	return ($retstat, %ret);
}

#======================================================================
# ($retstat, %ret) = ipsecEstTcp2NUT() - emulate TCP to NUT
#
#  $retstat : return status
#    'GOT_REPLY' tcp send syn to NUT successfully
#    'NO_REPLY'  tcp syn ignored by NUT
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#======================================================================
sub ipsecEstTcp2NUT($$$$$$$){
	my ($IF,
		$CPP,
		$seqcount,
		$base_path,
		$syn_request_from_host1_esp,   # "send syn request"
		$synack_reply_to_host1_esp_s,  # "recv syn,ack replys"
		$ack_request_from_host1_esp,   # "recv syn,ack replys"
	) = @_;
	my ($retstat,	# return status 1
		%ret);	# return status 2 (last vRecv())
	my (@synack_reply_to_host1_esp_s) = split(/\s+/, $synack_reply_to_host1_esp_s);

	## set vCPP
	vCPP("$CPP");

	## send syn request to NUT
	vSend($IF, $syn_request_from_host1_esp);

	## receive syn,ack reply or ns from NUT
	%ret = vRecvWrapper($IF, 1, 0, 0, 0, @synack_reply_to_host1_esp_s);
	unless($ret{'recvCount'}){
		vLogHTML('Cannot receive TCP Syn, Ack Reply.<BR>');
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}
	my $match = undef;
	foreach my $frames (@synack_reply_to_host1_esp_s){
		if ($ret{recvFrame} eq $frames) {
			$match++;
			last;
		}
	}
	if(!$match){
		vLogHTML('Cannot receive TCP Syn, Ack Reply.<BR>');
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}

	$port=$ret{$base_path.'.Hdr_TCP.SourcePort'};
	$seq=$ret{$base_path.'.Hdr_TCP.SequenceNumber'};
	$ack=$ret{$base_path.'.Hdr_TCP.AcknowledgmentNumber'};

	vLogHTML("Host-1 receive Syn, Ack SequenceNumber=$seq, AcknowledgmentNumber=$ack from End-Node(NUT).<BR>");

	$seqcount++;
	$seq++;
	$CPP .= " -DFROM_SEQUENCENUMBER=$seqcount";
	$CPP .= " -DSEQ=$ack -DACK=$seq";

	## set vCPP
	vCPP("$CPP");

	## send ack request to NUT
	vLogHTML("Host-1 sent Ack SequenceNumber=$seq, AcknowledgmentNumber=$ack to End-Node(NUT).<BR>");
	vSend($IF, $ack_request_from_host1_esp);
	vLogHTML("Host-1 established connection with End-Node(NUT)<BR>");

	## receive syn,ack reply or ns from NUT
	## if NC state is PROBE, force NC to be REACHABLE
	#vRecvNS($IF, 3, 0, 0, 2);

	$retstat = 'GOT_REPLY';
	return ($retstat, %ret);
}

#======================================================================
# ($retstat, %ret) = ipsecAckDataTcpNUT() - emulate TCP to NUT
#
#  $retstat : return status
#    'GOT_REPLY' tcp send ack/data to NUT successfully
#    'NO_REPLY'  tcp ack/data ignored by NUT
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#======================================================================
sub ipsecAckDataTcp2NUT($$$$$;$$$){
	my ($IF,
		$CPP,
		$seqcount,
		$base_path,
		$ack_data_request_from_host1_esp,# "send ack/data request"
		$ack_data_reply_to_host1_esp_s,  # "recv ack/data replys"
		$ack_request_from_host1_esp,     # "send ack request"
	) = @_;
	my ($retstat,	# return status 1
		%ret);	# return status 2 (last vRecv())
	my (@ack_data_reply_to_host1_esp_s) = split(/\s+/, $ack_data_reply_to_host1_esp_s);

	#------------------------
	# set vCPP
	#------------------------
	vCPP("$CPP");

	#------------------------
	# set default packet name
	#------------------------
	$ack_request_from_host1_esp	= 'ack_request_from_host1_esp' unless defined $ack_request_from_host1_esp;

	#------------------------
	# send ack w/ data request to NUT
	#------------------------
	vSend($IF, $ack_data_request_from_host1_esp);

	#------------------------
	# receive ack w/ data reply or ns from NUT
	#------------------------
	my $match = undef;
	%ret = vRecvWrapper($IF, 1, 0, 0, 0, @ack_data_reply_to_host1_esp_s);
	unless($ret{'recvCount'}){
		vLogHTML('Cannot receive TCP Ack w/ data Reply.<BR>');
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}
	foreach my $frames (@ack_data_reply_to_host1_esp_s){
		if ($ret{recvFrame} eq $frames) {
			$match++;
			last;
		}
	}
	if(!$match){
		vLogHTML('Cannot receive TCP Ack w/ data Reply.<BR>');
		$retstat = 'NO_REPLY';
		return ($retstat, %ret);
	}

	my $port=$ret{$base_path.'.Hdr_TCP.SourcePort'};
	if($port eq '7'){
		my $seq =$ret{$base_path.'.Hdr_TCP.SequenceNumber'};
		my $ack=$ret{$base_path.'.Hdr_TCP.AcknowledgmentNumber'};

		vLogHTML("Host-1 received Ack w/ Date, SequenceNumber=$seq, AcknowledgmentNumber=$ack from End-Node(NUT).<BR>");

		$seqcount++;
		$seq = $seq + length($ret{$base_path.'.Payload.data'})/2;
		$CPP .= " -DESP_FROM_HOST1=esp_from_host_seq -DESP_TO_HOST1=esp_to_host";
		$CPP .= " -DFROM_SEQUENCENUMBER=$seqcount";
		$CPP .= " -DSEQ=$ack -DACK=$seq";

		## set vCPP
		vCPP("$CPP");

		#------------------------
		# send ack request to NUT
		#------------------------
		vLogHTML("Host-1 sent Ack SequenceNumber=$ack, AcknowledgmentNumber=$seq to End-Node(NUT).<BR>");
		vClear($IF);
		vSend($IF, $ack_request_from_host1_esp);
	}

	#------------------------
	# receive syn,ack reply or ns from NUT
	# if NC state is PROBE, force NC to be REACHABLE
	#------------------------
	#vRecvNS($IF, 6, 0, 0, 2);

	$retstat = 'GOT_REPLY';
	return ($retstat, %ret);
}

#======================================================================
# ($retstat, %ret) = ipsecFinAckTcp2NUT() - emulate TCP to NUT
#
#  $retstat : return status
#    'GOT_REPLY' tcp send fin/ack to NUT successfully
#    'NO_REPLY'  tcp fin/ack ignored by NUT
#    'ERROR'     found something failure
#  %ret : status of last vRecv()
#======================================================================
sub ipsecFinAckTcp2NUT($$$$$$$$){
	my ($IF,
		$CPP,
		$seqcount,
		$base_path,
		$fin_ack_to_host1_esp_s, # "fin,ack"
		$ack_from_host1_esp,     # "ack"
		$fin_ack_from_host1_esp, # "fin,ack"
		$ack_to_host1_esp_s      # "ack"
	) = @_;
	my ($retstat,	# return status 1
		%ret);	# return status 2 (last vRecv())
	my (@fin_ack_to_host1_esp_s) = split(/\s+/, $fin_ack_to_host1_esp_s);
	my (@ack_to_host1_esp_s) = split(/\s+/, $ack_to_host1_esp_s);

	#------------------------
	# create vCPP hash list
	#------------------------
	vLogHTML("vCPP: $CPP<BR>") if $test_debug;
	my %CPP_HASH = ();
	while ($CPP =~ m/-D(\S+)=(\S+)\s*/g){
		$CPP_HASH{$1} = $2;
	}

	#----------------------
	# port check
	#----------------------
	if ($IPSEC::NUT_RECV_PORT ne undef){
		$port = $NUT_RECV_PORT;
	}
	else{
		$port = $DEF_PORT;
	}

	#----------------------
	# echo(7) case
	#----------------------
	if($port eq '7'){
		#---------------
		# set new vCPP
		#---------------
		$CPP_HASH{'ACKFLAG'}=1;
		$CPP_HASH{'PSHFLAG'}=0;
		$CPP_HASH{'SYNFLAG'}=0;
		$CPP_HASH{'FINFLAG'}=1;
		$CPP = undef;
		for my $i (keys %CPP_HASH){
			$CPP .= "-D$i=$CPP_HASH{$i} ";
		}
		vLogHTML("vCPP: $CPP<BR>") if $test_debug;
		vCPP("$CPP");

		#-----------------------------------
		# send fin,ack request to NUT
		#-----------------------------------
		vSend($IF, $ack_from_host1_esp);

		#---------------
		# set new vCPP
		#---------------
		$CPP_HASH{'ACKFLAG'}=1;
		$CPP_HASH{'PSHFLAG'}=0;
		$CPP_HASH{'SYNFLAG'}=0;
		$CPP_HASH{'FINFLAG'}=any;
		$CPP = undef;
		for my $i (keys %CPP_HASH){
			$CPP .= "-D$i=$CPP_HASH{$i} ";
		}
		vLogHTML("vCPP: $CPP<BR>") if $test_debug;
		vCPP("$CPP");
		#-----------------------------------
		# receive ack reply or ns from NUT
		#-----------------------------------
		my $match = undef;
		%ret = vRecvWrapper($IF, 5, 0, 0, 0, @fin_ack_to_host1_esp_s);
		unless($ret{'recvCount'}){
			vLogHTML('Cannot receive TCP Ack Reply.<BR>');
			$retstat = 'NO_REPLY';
			return ($retstat, %ret);
		}
		foreach my $frames (@fin_ack_to_host1_esp_s){
			if ($ret{recvFrame} eq $frames) {
				$match++;
				last;
			}
		}
		if(!$match){
			vLogHTML('Cannot receive TCP Ack Reply.<BR>');
			$retstat = 'NO_REPLY';
			return ($retstat, %ret);
		}

		$seq=$ret{$base_path.'.Hdr_TCP.SequenceNumber'};
		$ack=$ret{$base_path.'.Hdr_TCP.AcknowledgmentNumber'};
		$fin=$ret{$base_path.'.Hdr_TCP.FINFlag'};

		if (!$fin) {
			vLogHTML("Host-1 received Ack SequenceNumber=$seq, AcknowledgmentNumber=$ack from End-Node(NUT).<BR>");

			#---------------
			# set new vCPP
			#---------------
			$CPP_HASH{'ACKFLAG'}=1;
			$CPP_HASH{'PSHFLAG'}=0;
			$CPP_HASH{'SYNFLAG'}=0;
			$CPP_HASH{'FINFLAG'}=1;
			$CPP = undef;
			for my $i (keys %CPP_HASH){
				$CPP .= "-D$i=$CPP_HASH{$i} ";
			}
			vLogHTML("vCPP: $CPP<BR>") if $test_debug;
			vCPP("$CPP");

			#-----------------------------------------
			# receive fin,ack reply or ns from NUT
			#-----------------------------------------
			my $match = undef;
			%ret = vRecvWrapper($IF, 5, 0, 0, 0, @ack_to_host1_esp_s);
			unless($ret{'recvCount'}){
				vLogHTML('Cannot receive TCP Fin,Ack Reply.<BR>');
				$retstat = 'NO_REPLY';
				return ($retstat, %ret);
			}
			foreach my $frames (@ack_to_host1_esp_s){
				if ($ret{recvFrame} eq $frames) {
					$match++;
					last;
				}
			}
			if(!$match){
				vLogHTML('Cannot receive TCP Fin,Ack Reply.<BR>');
				$retstat = 'NO_REPLY';
				return ($retstat, %ret);
			}

			$seq=$ret{$base_path.'.Hdr_TCP.SequenceNumber'};
			$ack=$ret{$base_path.'.Hdr_TCP.AcknowledgmentNumber'};
		}

		vLogHTML("Host-1 received Fin, Ack, SequenceNumber=$seq, AcknowledgmentNumber=$ack from End-Node(NUT).<BR>");

		#---------------
		# set new vCPP
		#---------------
		$seqcount++;
		$seq++;
		$CPP_HASH{'ACKFLAG'}=1;
		$CPP_HASH{'PSHFLAG'}=0;
		$CPP_HASH{'SYNFLAG'}=0;
		$CPP_HASH{'FINFLAG'}=0;
		$CPP_HASH{'FROM_SEQUENCENUMBER'}=$seqcount;
		$CPP_HASH{'SEQ'}=$ack;
		$CPP_HASH{'ACK'}=$seq;
		$CPP = undef;
		for my $i (keys %CPP_HASH){
			$CPP .= "-D$i=$CPP_HASH{$i} ";
		}
		vLogHTML("vCPP: $CPP<BR>") if $test_debug;
		vCPP("$CPP");

		#------------------------
		# send ack request to NUT
		#------------------------
		vLogHTML("Host-1 sent Ack SequenceNumber=$seq, AcknowledgmentNumber=$ack to End-Node(NUT).<BR>");
		vSend($IF, $fin_ack_from_host1_esp);

		## receive syn,ack reply or ns from NUT
		## if NC state is PROBE, force NC to be REACHABLE
		vRecvNS($IF, 3, 0, 0, 2);
	}
	#----------------------
	# default http(80)
	#----------------------
	else{
		#----------------------------------------------
		# receive fin, ack request or ns from NUT
		#----------------------------------------------
		#---------------
		# set new vCPP
		#---------------
		$CPP_HASH{'ACKFLAG'}=1;
		$CPP_HASH{'PSHFLAG'}=0;
		$CPP_HASH{'SYNFLAG'}=0;
		$CPP_HASH{'FINFLAG'}=1;
		$CPP = undef;
		for my $i (keys %CPP_HASH){
			$CPP .= "-D$i=$CPP_HASH{$i} ";
		}
		vLogHTML("vCPP: $CPP<BR>") if $test_debug;
		vCPP("$CPP");

		#----------------------------------
		# receive fin, ack request from NUT
		#----------------------------------
		my $match = undef;
		%ret = vRecvWrapper($IF, 5, 0, 0, 0, @fin_ack_to_host1_esp_s);
		unless($ret{'recvCount'}){
			vLogHTML('Cannot receive TCP Ack Reply.<BR>');
			$retstat = 'NO_REPLY';
			return ($retstat, %ret);
		}
		foreach my $frames (@fin_ack_to_host1_esp_s){
			if ($ret{recvFrame} eq $frames) {
				$match++;
				last;
			}
		}
		if(!$match){
			vLogHTML('Cannot receive TCP Ack Reply.<BR>');
			$retstat = 'NO_REPLY';
			return ($retstat, %ret);
		}

		$seq=$ret{$base_path.'.Hdr_TCP.SequenceNumber'};
		$ack=$ret{$base_path.'.Hdr_TCP.AcknowledgmentNumber'};

		my $payloaddata = $ret{$base_path.'.Payload.data'};
		chomp($payloaddata);
		my $payloadlength = length($payloaddata)/2;

		vLogHTML("Host-1 received Fin, Ack SequenceNumber=$seq, AcknowledgmentNumber=$ack from End-Node(NUT).<BR>");

		#---------------
		# set new vCPP
		#---------------
		if($payloadlength == 0 || $payloadlength eq undef){
			$seq++;
		}
		else{
			$seq = $seq + $payloadlength;
		}

		$CPP_HASH{'ACKFLAG'}=1;
		$CPP_HASH{'PSHFLAG'}=0;
		$CPP_HASH{'SYNFLAG'}=0;
		$CPP_HASH{'FINFLAG'}=0;
		$CPP_HASH{'FROM_SEQUENCENUMBER'}=$seqcount;
		$CPP_HASH{'SEQ'}=$ack;
		$CPP_HASH{'ACK'}=$seq;
		$CPP = undef;
		for my $i (keys %CPP_HASH){
			$CPP .= "-D$i=$CPP_HASH{$i} ";
		}
		vLogHTML("vCPP: $CPP<BR>") if $test_debug;
		vCPP("$CPP");

		#----------------------------------------------
		# send ack request to NUT
		#----------------------------------------------
		vClear($IF);
		vSend($IF, $ack_from_host1_esp);

		$seq=$ret{$base_path.'.Hdr_TCP.SequenceNumber'};
		$ack=$ret{$base_path.'.Hdr_TCP.AcknowledgmentNumber'};

		vLogHTML("Host-1 sent Ack SequenceNumber=$seq, AcknowledgmentNumber=$ack to End-Node(NUT)<BR>");

		#--------------
		# set vCPP
		#--------------
		$seqcount++;
		$CPP_HASH{'ACKFLAG'}=1;
		$CPP_HASH{'PSHFLAG'}=0;
		$CPP_HASH{'SYNFLAG'}=0;
		$CPP_HASH{'FINFLAG'}=1;
		$CPP_HASH{'FROM_SEQUENCENUMBER'}=$seqcount;
		$CPP = undef;
		for my $i (keys %CPP_HASH){
			$CPP .= "-D$i=$CPP_HASH{$i} ";
		}
		vLogHTML("vCPP: $CPP<BR>") if $test_debug;
		vCPP("$CPP");

		#------------------------------------
		# send fin, ack to NUT
		#------------------------------------
		vSend($IF, $fin_ack_from_host1_esp);

		$seq=$ret{$base_path.'.Hdr_TCP.SequenceNumber'};
		$ack=$ret{$base_path.'.Hdr_TCP.AcknowledgmentNumber'};

		vLogHTML("Host-1 sent Fin, Ack SequenceNumber=$seq, AcknowledgmentNumber=$ack to End-Node(NUT).<BR>");

		#--------------
		# set net vCPP
		#--------------
		$seqcount++;
		$CPP_HASH{'ACKFLAG'}=1;
		$CPP_HASH{'PSHFLAG'}=0;
		$CPP_HASH{'SYNFLAG'}=0;
		$CPP_HASH{'FINFLAG'}=0;
		$CPP_HASH{'FROM_SEQUENCENUMBER'}=$seqcount;
		$CPP_HASH{'SEQ'}=$ack;
		$CPP_HASH{'ACK'}=$seq;
		$CPP = undef;
		for my $i (keys %CPP_HASH){
			$CPP .= "-D$i=$CPP_HASH{$i} ";
		}
		vLogHTML("vCPP: $CPP<BR>") if $test_debug;
		vCPP("$CPP");

		#----------------------------------
		# receive ack reply or ns from NUT
		#----------------------------------
		my $match = undef;
		%ret = vRecvWrapper($IF, 5, 0, 0, 0, @ack_to_host1_esp_s);
		unless($ret{'recvCount'}){
			vLogHTML('Cannot receive TCP Fin,Ack Reply.<BR>');
			$retstat = 'NO_REPLY';
			return ($retstat, %ret);
		}
		foreach my $frames (@ack_to_host1_esp_s){
			if ($ret{recvFrame} eq $frames) {
				$match++;
				last;
			}
		}
		if(!$match){
			vLogHTML('Cannot receive TCP Fin,Ack Reply.<BR>');
			$retstat = 'NO_REPLY';
			return ($retstat, %ret);
		}

		$seq=$ret{$base_path.'.Hdr_TCP.SequenceNumber'};
		$ack=$ret{$base_path.'.Hdr_TCP.AcknowledgmentNumber'};

		vLogHTML("Host-1 received Ack SequenceNumber=$seq, AcknowledgmentNumber=$ack from End-Node(NUT)<BR>");

		## receive syn,ack reply or ns from NUT
		## if NC state is PROBE, force NC to be REACHABLE
		vRecvNS($IF, 3, 0, 0, 2);
	}

	$retstat = 'GOT_REPLY';
	return ($retstat, %ret);
}

#======================================================================
# ipsecConfigCheck($IF)
#
#  Check NUT configuration (global address / default router)
#  BUT , now this function only send RA.
#  return 0     : PASS
#         other : FAIL
#======================================================================
sub ipsecConfigCheck($) {
	my ($IF) = @_;

	if ($IPsecAddr{IPSEC_IPVERSION} != 4) {
		vSend($IF, ra_to_nut);
		vRecvNS($IF0, $WAIT_ASSIGN_ADDR, 0, 0, 0);
	}
	return 0;
}


#=====================================================
#ipsecOverWriteConfig() - overwrite config
#=====================================================
sub
ipsecOverWriteConfig()
{
	{
		require './config.pl';

		if (defined($DEV_TYPE)) {
			$FromConfig{'DEV_TYPE'} = ($DEV_TYPE eq 'sgw') ? 'sgw' : 'end_node';
			$DEV_TYPE = $FromConfig{'DEV_TYPE'};
		}

		if (defined($BYPASS_POLICY_SUPPORT)) {
			$FromConfig{'BYPASS_POLICY_SUPPORT'} = ($BYPASS_POLICY_SUPPORT eq 'yes') ? 'yes' : undef;
			$BYPASS_POLICY_SUPPORT = $FromConfig{'BYPASS_POLICY_SUPPORT'};
		}

		if (defined($DISCARD_POLICY_SUPPORT)) {
			$FromConfig{'DISCARD_POLICY_SUPPORT'} = ($DISCARD_POLICY_SUPPORT eq 'yes') ? 'yes' : undef;
			$DISCARD_POLICY_SUPPORT = $FromConfig{'DISCARD_POLICY_SUPPORT'};
		}

		if (defined($DUMMY_PACKET_SUPPORT)) {
			$FromConfig{'DUMMY_PACKET_SUPPORT'} = ($DUMMY_PACKET_SUPPORT eq 'yes') ? 'yes' : undef;
			$DUMMY_PACKET_SUPPORT = $FromConfig{'DUMMY_PACKET_SUPPORT'};
		}

		if (defined($TFC_PADDING_TUNNEL_SUPPORT)) {
			$FromConfig{'TFC_PADDING_TUNNEL_SUPPORT'} = ($TFC_PADDING_TUNNEL_SUPPORT eq 'yes') ? 'yes' : undef;
			$TFC_PADDING_TUNNEL_SUPPORT = $FromConfig{'TFC_PADDING_TUNNEL_SUPPORT'};
		}

		if (defined($TFC_PADDING_TRANS_SUPPORT)) {
			$FromConfig{'TFC_PADDING_TRANS_SUPPORT'} = ($TFC_PADDING_TRANS_SUPPORT eq 'yes') ? 'yes' : undef;
			$TFC_PADDING_TRANS_SUPPORT = $FromConfig{'TFC_PADDING_TRANS_SUPPORT'};
		}

		if (defined($TUNNEL_MODE_WITH_SGW_SUPPORT)) {
			$FromConfig{'TUNNEL_MODE_WITH_SGW_SUPPORT'} = ($TUNNEL_MODE_WITH_SGW_SUPPORT eq 'yes') ? 'yes' : undef;
			$TUNNEL_MODE_WITH_SGW_SUPPORT = $FromConfig{'TUNNEL_MODE_WITH_SGW_SUPPORT'};
		}

		if (defined($TUNNEL_MODE_WITH_SGW_FRAGMENTATION_SUPPORT)) {
			$FromConfig{'TUNNEL_MODE_WITH_SGW_FRAGMENTATION_SUPPORT'} = ($TUNNEL_MODE_WITH_SGW_FRAGMENTATION_SUPPORT eq 'yes') ? 'yes' : undef;
			$TUNNEL_MODE_WITH_SGW_FRAGMENTATION_SUPPORT = $FromConfig{'TUNNEL_MODE_WITH_SGW_FRAGMENTATION_SUPPORT'};
		}

		if (defined($ICMP_TYPE_CODE_SELECTOR_SUPPORT)) {
			$FromConfig{'ICMP_TYPE_CODE_SELECTOR_SUPPORT'} = ($ICMP_TYPE_CODE_SELECTOR_SUPPORT eq 'yes') ? 'yes' : undef;
			$ICMP_TYPE_CODE_SELECTOR_SUPPORT = $FromConfig{'ICMP_TYPE_CODE_SELECTOR_SUPPORT'};
		}

		if (defined($PASSIVE_NODE)) {
			$FromConfig{'PASSIVE_NODE'} = ($PASSIVE_NODE eq 'yes') ? 'yes' : undef;
			$PASSIVE_NODE = $FromConfig{'PASSIVE_NODE'};
		}

		if (defined($USE_PORT_UNREACHABLE)) {
			$FromConfig{'USE_PORT_UNREACHABLE'} = ($USE_PORT_UNREACHABLE eq 'yes') ? 'yes' : undef;
			$USE_PORT_UNREACHABLE = $FromConfig{'USE_PORT_UNREACHABLE'};
		}

		if (defined($TripleDES_CBC_AES_XCBC_SUPPORT)) {
			$FromConfig{'3DES_CBC_AES_XCBC_SUPPORT'} = ($TripleDES_CBC_AES_XCBC_SUPPORT eq 'yes') ? 'yes' : undef;
			$TripleDES_CBC_AES_XCBC_SUPPORT = $FromConfig{'TripleDES_CBC_AES_XCBC_SUPPORT'};
		}

		if (defined($TripleDES_CBC_NULL_SUPPORT)) {
			$FromConfig{'3DES_CBC_NULL_SUPPORT'} = ($TripleDES_CBC_NULL_SUPPORT eq 'yes') ? 'yes' : undef;
			$TripleDES_CBC_NULL_SUPPORT = $FromConfig{'TripleDES_CBC_NULL_SUPPORT'};
		}

		if (defined($TripleDES_CBC_HMAC_SHA2_256_SUPPORT)) {
			$FromConfig{'3DES_CBC_HMAC_SHA2_256_SUPPORT'} = ($TripleDES_CBC_HMAC_SHA2_256_SUPPORT eq 'yes') ? 'yes' : undef;
			$TripleDES_CBC_HMAC_SHA2_256_SUPPORT = $FromConfig{'TripleDES_CBC_HMAC_SHA2_256_SUPPORT'};
		}

		if (defined($AES_CBC_HMAC_SHA1_SUPPORT)) {
			$FromConfig{'AES_CBC_HMAC_SHA1_SUPPORT'} = ($AES_CBC_HMAC_SHA1_SUPPORT eq 'yes') ? 'yes' : undef;
			$AES_CBC_HMAC_SHA1_SUPPORT = $FromConfig{'AES_CBC_HMAC_SHA1_SUPPORT'};
		}

		if (defined($AES_CTR_HMAC_SHA1_SUPPORT)) {
			$FromConfig{'AES_CTR_HMAC_SHA1_SUPPORT'} = ($AES_CTR_HMAC_SHA1_SUPPORT eq 'yes') ? 'yes' : undef;
			$AES_CTR_HMAC_SHA1_SUPPORT = $FromConfig{'AES_CTR_HMAC_SHA1_SUPPORT'};
		}

		if (defined($NULL_HMAC_SHA1_SUPPORT)) {
			$FromConfig{'NULL_HMAC_SHA1_SUPPORT'} = ($NULL_HMAC_SHA1_SUPPORT eq 'yes') ? 'yes' : undef;
			$NULL_HMAC_SHA1_SUPPORT = $FromConfig{'NULL_HMAC_SHA1_SUPPORT'};
		}

		if (defined($CAMELLIA_CBC_HMAC_SHA1_SUPPORT)) {
			$FromConfig{'CAMELLIA_CBC_HMAC_SHA1_SUPPORT'} = ($CAMELLIA_CBC_HMAC_SHA1_SUPPORT eq 'yes') ? 'yes' : undef;
			$CAMELLIA_CBC_HMAC_SHA1_SUPPORT = $FromConfig{'CAMELLIA_CBC_HMAC_SHA1_SUPPORT'};
		}

		if (defined($MANUAL_ADDR_CONF)) {
			$FromConfig{'MANUAL_ADDR_CONF'} = ($MANUAL_ADDR_CONF eq 'yes') ? 'yes' : undef;
			$MANUAL_ADDR_CONF = $FromConfig{'MANUAL_ADDR_CONF'};
		}

		if (defined($IPSEC_NUT_NET0_ADDR)) {
			$FromConfig{'IPSEC_NUT_NET0_ADDR'} = $IPSEC_NUT_NET0_ADDR;
			$IPSEC_NUT_NET0_ADDR = $FromConfig{'IPSEC_NUT_NET0_ADDR'};
		}

		if (defined($NUT_RECV_PORT)) {
			$FromConfig{'NUT_RECV_PORT'} = $NUT_RECV_PORT;
			$NUT_RECV_PORT = $FromConfig{'NUT_RECV_PORT'};
		}

		if (defined($REBOOT_WAIT_TIME)) {
			$FromConfig{'REBOOT_WAIT_TIME'} = $REBOOT_WAIT_TIME;
			$REBOOT_WAIT_TIME = $FromConfig{'REBOOT_WAIT_TIME'};
		}

		if (defined($WAIT_ASSIGN_ADDR)) {
			$FromConfig{'WAIT_ASSIGN_ADDR'} = $WAIT_ASSIGN_ADDR;
			$WAIT_ASSIGN_ADDR = $FromConfig{'WAIT_ASSIGN_ADDR'};
		}

		if (defined($REBOOT_TO_RESET_MTU)) {
			$FromConfig{'REBOOT_TO_RESET_MTU'} = ($REBOOT_TO_RESET_MTU eq 'yes') ? 'yes' : undef;
			$REBOOT_TO_RESET_MTU = $FromConfig{'REBOOT_TO_RESET_MTU'};
		}

		if (defined($REBOOT_TO_CLEAR_SA_CONF)) {
			$FromConfig{'REBOOT_TO_CLEAR_SA_CONF'} = ($REBOOT_TO_CLEAR_SA_CONF eq 'yes') ? 'yes' : undef;
			$REBOOT_TO_CLEAR_SA_CONF = $FromConfig{'REBOOT_TO_CLEAR_SA_CONF'};
		}

		if (defined($REBOOT_AFTER_SET_SA_CONF)) {
			$FromConfig{'REBOOT_AFTER_SET_SA_CONF'} = ($REBOOT_AFTER_SET_SA_CONF eq 'yes') ? 'yes' : undef;
			$REBOOT_AFTER_SET_SA_CONF = $FromConfig{'REBOOT_AFTER_SET_SA_CONF'};
		}

		if (defined($TCP_TIME_WAIT)) {
			$FromConfig{'TCP_TIME_WAIT'} = $TCP_TIME_WAIT;
			$TCP_TIME_WAIT = $FromConfig{'TCP_TIME_WAIT'};
		}
	}

	#=====================================================
	# Device type check
	#=====================================================
	if($FromConfig{'DEV_TYPE'} ne undef){
		$DEV_TYPE = $FromConfig{'DEV_TYPE'};
	}

	if($DEV_TYPE eq 'sgw'){
		open (FILE, "$SGW_ADDR_DEF") || die "Cannot open $!\n";
	}
	else{
		open (FILE, "$ADDR_DEF") || die "Cannot open $!\n";
	}
	while ( <FILE> ) {
		if ( /^#define\s+(\S+)\s+(\S+)/ ) {
			#print  $1 . " " . $2 . "\n";
			$IPsecAddr{$1} = $2;
		}
	}
	close FILE;

	#=====================================================
	# Advanced Function Support list
	#=====================================================
	%advanced_functions = (
		'BYPASS_POLICY_SUPPORT'
			=> $FromConfig{'BYPASS_POLICY_SUPPORT'},
		'DISCARD_POLICY_SUPPORT'
			=> $FromConfig{'DISCARD_POLICY_SUPPORT'},
		'TUNNEL_MODE_WITH_SGW_SUPPORT'
			=> $FromConfig{'TUNNEL_MODE_WITH_SGW_SUPPORT'},
		'TUNNEL_MODE_WITH_SGW_FRAGMENTATION_SUPPORT'
			=> $FromConfig{'TUNNEL_MODE_WITH_SGW_FRAGMENTATION_SUPPORT'},
		'3DES_CBC_AES_XCBC_SUPPORT'
			=> $FromConfig{'3DES_CBC_AES_XCBC_SUPPORT'},
		'3DES_CBC_NULL_SUPPORT'
			=> $FromConfig{'3DES_CBC_NULL_SUPPORT'},
		'3DES_CBC_HMAC_SHA2_256_SUPPORT'
			=> $FromConfig{'3DES_CBC_HMAC_SHA2_256_SUPPORT'},
		'AES_CBC_HMAC_SHA1_SUPPORT'
			=> $FromConfig{'AES_CBC_HMAC_SHA1_SUPPORT'},
		'NULL_HMAC_SHA1_SUPPORT'
			=> $FromConfig{'NULL_HMAC_SHA1_SUPPORT'},
		'ICMP_TYPE_CODE_SELECTOR_SUPPORT'
			=> $FromConfig{'ICMP_TYPE_CODE_SELECTOR_SUPPORT'},
		'PASSIVE_NODE'
			=> $FromConfig{'PASSIVE_NODE'},
		'USE_PORT_UNREACHABLE'
			=> $FromConfig{'USE_PORT_UNREACHABLE'},
		'DUMMY_PACKET_SUPPORT'
			=> $FromConfig{'DUMMY_PACKET_SUPPORT'},
		'TFC_PADDING_TRANS_SUPPORT'
			=> $FromConfig{'TFC_PADDING_TRANS_SUPPORT'},
		'TFC_PADDING_TUNNEL_SUPPORT'
			=> $FromConfig{'TFC_PADDING_TUNNEL_SUPPORT'},
		'AES_CTR_HMAC_SHA1_SUPPORT'
			=> $FromConfig{'AES_CTR_HMAC_SHA1_SUPPORT'},
		'CAMELLIA_CBC_HMAC_SHA1_SUPPORT'
			=> $FromConfig{'CAMELLIA_CBC_HMAC_SHA1_SUPPORT'},
	);

	if(($advanced_functions{'BYPASS_POLICY_SUPPORT'} ne 'yes') && 
		($advanced_functions{'DISCARD_POLICY_SUPPORT'} ne 'yes')){
		vLogHTML("<FONT COLOR=\"#FF0000\">Either of Bypass Policy or Discard Policy MUST be required</FONT><BR>");
		ipsecExitFail();
	}

	if ($test_debug > 2){
		for $i (keys %advanced_functions){
			vLogHTML("YYYY $i: $advanced_functions{$i}");
		}
	}

	if($FromConfig{'NUT_RECV_PORT'} ne undef){
		$NUT_RECV_PORT = $FromConfig{'NUT_RECV_PORT'};
	}

	if($FromConfig{'TN_RECV_PORT'} ne undef){
		$TN_RECV_PORT = $FromConfig{'TN_RECV_PORT'};
	}

	if($FromConfig{'MANUAL_ADDR_CONF'} ne undef){
		$MANUAL_ADDR_CONF = $FromConfig{'MANUAL_ADDR_CONF'};
		if($FromConfig{'IPSEC_NUT_NET0_ADDR'} ne undef){
			$IPSEC::IPsecAddr{'IPSEC_NUT_NET0_ADDR'} = $FromConfig{'IPSEC_NUT_NET0_ADDR'};
		}
		else{
			vLogHTML("<FONT COLOR=\"#FF0000\">If MANUAL_ADDR_CONF is yes, IPSEC_NUT_NET0_ADDR MUST be defined in $config_file</FONT><BR>");
			ipsecExitFail();
		}
	}

	if($FromConfig{'REBOOT_WAIT_TIME'} ne undef){
		$REBOOT_WAIT_TIME = $FromConfig{'REBOOT_WAIT_TIME'};
	}
	if($FromConfig{'WAIT_ASSIGN_ADDR'} ne undef){
		$WAIT_ASSIGN_ADDR = $FromConfig{'WAIT_ASSIGN_ADDR'};
	}

	if($FromConfig{'REBOOT_TO_RESET_MTU'} ne undef){
		$REBOOT_TO_RESET_MTU = $FromConfig{'REBOOT_TO_RESET_MTU'};
	}
	if($FromConfig{'REBOOT_TO_CLEAR_SA_CONF'} ne undef){
		$REBOOT_TO_CLEAR_SA_CONF = $FromConfig{'REBOOT_TO_CLEAR_SA_CONF'};
	}
	if($FromConfig{'REBOOT_AFTER_SET_SA_CONF'} ne undef){
		$REBOOT_AFTER_SET_SA_CONF = $FromConfig{'REBOOT_AFTER_SET_SA_CONF'};
	}

	if($FromConfig{'TCP_TIME_WAIT'} ne undef){
		$TCP_TIME_WAIT = $FromConfig{'TCP_TIME_WAIT'};
	}

	return;
}


#======================================================================
# vRecvWrapper()
#======================================================================
sub
vRecvWrapper($$$$$@)
{
	my ($IF, $timeout, $seektime, $count, $loopcount, @frames) = @_;
	my %ret = ();

	# Packet descriptions
	%pktdesc = (
		%pktdesc,
	);

	my %nd = ();
	if($DEV_TYPE eq 'sgw'){
		%nd = (
			'ns_to_router'		=> 'na_from_router',
			'ns_to_router_linkaddr'	=> 'na_from_router_linkaddr',
			'ns_to_router_wo_sllopt'=> 'na_from_router',
			'ns_to_host'		=> 'na_from_host',
			'ns_to_host_linkaddr'	=> 'na_from_host_linkaddr',
			'ns_to_host_wo_sllopt'	=> 'na_from_host',
			'rs_from_nut_wunspec'	=> 'ra_to_nut',
			'rs_from_nut'		=> 'ra_to_nut',
			'rs_from_nut_wsll'	=> 'ra_to_nut',
		);
	}
	else{
		%nd = (
			'ns_to_router'		=> 'na_from_router',
			'ns_to_router_linkaddr'	=> 'na_from_router_linkaddr',
			'ns_to_router_wo_sllopt'=> 'na_from_router',
			'ns_to_router_linkaddr_w_linkaddr'	=> 'na_from_router_linkaddr_w_linkaddr',
			'rs_from_nut_wunspec'	=> 'ra_to_nut',
			'rs_from_nut'		=> 'ra_to_nut',
			'rs_from_nut_wsll'	=> 'ra_to_nut',
		);
	}

	for( ; ; ) {
		%ret = vRecv3($IF, $timeout, $seektime, $count,
				@frames, keys(%nd));
		$loopcount = $loopcount - 1;

		if($ret{'recvCount'}) {
			my $continue    = 0;

			while(my ($recv, $send) = each(%nd)) {
				if($ret{'recvFrame'} eq $recv) {
					vSend($IF, $send);
					$continue ++;
				}
			}

			if($continue) {
				next;
			}
		}

		if($loopcount < 1){
			last;
		}
	}

	return(%ret);
}

#======================================================================
# vRecvNS()
#======================================================================
sub
vRecvNS($$$$$)
{
	my ($IF, $timeout, $seektime, $count, $loopcount) = @_;
	my %ret = ();

	# Packet descriptions
	%pktdesc = (
		%pktdesc,
	);

	my %nd = ();
	if($DEV_TYPE eq 'sgw'){
		%nd = (
			'ns_to_router'		=> 'na_from_router',
			'ns_to_router_linkaddr'	=> 'na_from_router_linkaddr',
			'ns_to_router_wo_sllopt'=> 'na_from_router',
			'ns_to_host'		=> 'na_from_host',
			'ns_to_host_linkaddr'	=> 'na_from_host_linkaddr',
			'ns_to_host_wo_sllopt'	=> 'na_from_host',
		);
	}
	else{
		%nd = (
			'ns_to_router'		=> 'na_from_router',
			'ns_to_router_linkaddr'	=> 'na_from_router_linkaddr',
			'ns_to_router_wo_sllopt'=> 'na_from_router',
			'ns_to_router_linkaddr_w_linkaddr'	=> 'na_from_router_linkaddr_w_linkaddr',
		);
	}

	for( ; ; ) {
		%ret = vRecv3($IF, $timeout, $seektime, $count,
				keys(%nd));

		if($ret{'recvCount'}) {
			while(my ($recv, $send) = each(%nd)) {
				if($ret{'recvFrame'} eq $recv) {
					vSend($IF, $send);
					vLogHTML("NC about Router was PROBE state, but now it's REACHABLE.<BR>") if $test_debug;
				}
			}
		}

		$loopcount = $loopcount -1;

		if($loopcount<1) {
			last;
		}
	}

	return(%ret);
}


#======================================================================
# vRecvRS()
#======================================================================
sub
vRecvRS($$$$$)
{
	my ($IF, $timeout, $seektime, $count, $loopcount) = @_;
	my %ret = ();

	# Packet descriptions
	%pktdesc = (
		%pktdesc,
	);

	my %rs = (
		'rs_from_nut_wunspec'   => 'ra_to_nut',
		'rs_from_nut'           => 'ra_to_nut',
		'rs_from_nut_wsll'      => 'ra_to_nut',
	);

	for( ; ; ) {
		%ret = vRecv3($IF, $timeout, $seektime, $count,
				keys(%rs));

		$loopcount = $loopcount -1;

		if($ret{'recvCount'}) {
			my $continue    = 0;

			while(my ($recv, $send) = each(%rs)) {
				if($ret{'recvFrame'} eq $recv) {
					vSend($IF, $send);
					$continue ++;
				}
			}

			if($continue) {
				last;
			}
		}

		if($loopcount < 1){
			last;
		}
	}

	return(%ret);
}

1;
########################################################################
__END__

=head1 NAME

IPSEC.pm - utility functions for IPsec test

=head1 SYNOPSIS

=begin html
<PRE>
use <A HREF="./IPSEC.pm">IPSEC</A>;
</PRE>

=end html

=head1 DESCRIPTION

This module contains methods to test IPsec.

=head2 Functions

=over

=item ipsecExitPass()

Output 'OK' to log and exit (exit code is Pass).

=item ipsecExitIgnore()

Output no message and Exit (exit code is Ignore).

=item ipsecExitNS()

Output 'This test is not supported now' to log and Exit (exit code is NS).

=item ipsecExitWarn()

Output 'Warn' (color is green) to log and Exit (exit code is Warn).

=item ipsecExitEndNodeOnly()

Output 'This test is for the host only' to log and Exit (exit code is EndNodeOnly).

=item ipsecExitSGWOnly()

Output 'This test is for the router only' to log and Exit (exit code is SGWOnly).

=item ipsecExitFail()

Output 'NG' (color is red) to log and Exit (exit code is Fail).

=item ipsecExitFatal()

Output 'Fatal' (color is red) to log and Exit (exit code is Fatal).

=item ipsecReboot()

Reboot the target.

This function calls 'reboot.rmt' simply.

=item ipsecRebootAsync()

Reboot the target asynchronously.

This function calls 'reboot.rmt' simply.

=item ipsecCheckNUT($require)

Check NUT type in 'nut.def'.
Parameter $require is one of 'host' or  'router'.

If 'Type' in nut.def does not match to $require, 
output message and exit (EndNodeOnly, SGWOnly or Fatal).

=item ipsecSetAddr($IF0)

Set Address for End-Node. $IF0 is link for Link0.

=item ipsecSetAddrSGW($IF0, $IF1)

Set Address for SGW. $IF0 is link for Link0, $IF1 is link for Link1.

=item ipsecSetSAD(@params)

Set SAD (Security Association Database) entry.

This function calls 'ipsecSetSAD.rmt' with @params simply.
If remote command fails, output message and exit (Fail).

=item ipsecSetSADAsync(@params)

Same function as the above.
But set SAD (Security Association Database) entry asynchronously.

=item ipsecSetSPD(@params)

Set SPD (Security Policy Database) entry.

This function calls 'ipsecSetSPD.rmt' with @params simply.
If remote command fails, output message and exit (Fail).

=item ipsecSetSPDAsync(@params)

Same function as the above.
But set SPD (Security Policy Database) entry asynchronously.

=item ipsecClearAll()

Clear all SAD and SPD entries.

This function calls 'ipsecClearAll.rmt' simply.
If remote command fails, output message and exit (Fail).

=item ipsecEnable()

Enable and start IPsec function.

This function calls 'ipsecEnable.rmt' simply.
If remote command fails, output message and exit (Fail).

=item ipsecPing2NUT($IF, $req, $rep [,$ns, $na])

Emulate Ping to NUT.

Send $req to NUT and wait $rep from NUT.

If NS is received from NUT, send NA to NUT and wait $rep again.

=item ipsecPingFrag2NUT($IF, $req1st, $req2nd, $rep1st, $rep2nd)

Emulate Fragmented Ping to NUT.

Send $req1st and $req2nd to NUT and wait $rep1st and $rep2nd from NUT.

=item ipsecForwardBidir($IFs, $IFr, $p1, $p2, $p3, $p4)

Check packet forwarding with encapsulation bi-directionally.

Send $p1 to NUT's $IFs and wait $p2 from NUT's $IFr.

If NS is received from NUT, send NA to NUT and wait $p2 again.

Send $p3 to NUT's $IFs and wait $p4 from NUT's $IFr.

If NS is received from NUT, send NA to NUT and wait $p4 again.

=item ipsecForwardOneWay($IFs, $IFr, $p1, $p2)

Check packet forwarding with encapsulation one-way.

Send $p1 to NUT's $IFs and wait $p2 from NUT's $IFr.

If NS is received from NUT, send NA to NUT and wait $p2 again.

=back

=head1 SEE ALSO

  perldoc V6EvalTool
  perldoc V6Remote
  perldoc /usr/local/v6eval/bin/manual/ipsecSetSAD.rmt
  perldoc /usr/local/v6eval/bin/manual/ipsecSetSPD.rmt
  perldoc /usr/local/v6eval/bin/manual/ipsecClearAll.rmt
  perldoc /usr/local/v6eval/bin/manual/ipsecEnable.rmt


=cut


