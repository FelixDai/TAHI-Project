#
# Copyright (C) 2013, 2014
# Chunghwa Telecommunication Labratories (CHT-TL)
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
# $CHT-TL: icmp.pm,v 1.2 2014/07/17 weifen Exp $
#-----------------------------------------------------------------

package icmp;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
		mkNCE_Link
		mkNCE_Global
		icmp_vRecv
		setup
	    );

use V6evalTool;

require './config.pl';

use lib '../.';
use DHCPv6_common;
use CPE6_config;

BEGIN { }
END { }

$subPass = 0; #This value presents that subroutine ended normally: subroutine PASS
$subFail = 32; #This value presents that subroutine ended abnormally: subroutine FAIL
$subFatal = 64; #FATAL (terminate series of related tests)

#-----------------------------------------------------------------
# make Neighbor Cache Entry
# In NUT,
#   make TN's link local address	 
#-----------------------------------------------------------------
sub mkNCE_Link (;$) {
	my ($IF) = @_;
	my ($reachable) = 0;

	$IF = Link1 if (!$IF) ;

#	%main::pktdesc = (
#	    ns_local			=> 'Receive Neighbor Solicitation',
#	    ns_local_sll		=> 'Receive Neighbor Solicitation',
#	    na_local			=> 'Send Neighbor Advertisement',
#	    echo_request_link_local	=> 'Send Echo Request (Link-local address)',
#	    echo_reply_link_local	=> 'Receive Echo Reply (Link-local address)',
#	);

	$main::pktdesc{ns_local} = 'Receive Neighbor Solicitation';
	$main::pktdesc{ns_local_sll} = 'Receive Neighbor Solicitation';
	$main::pktdesc{na_local} = 'Send Neighbor Advertisement';
	$main::pktdesc{echo_request_link_local} = 'Send Echo Request (Link-local address)';
	$main::pktdesc{echo_reply_link_local} = 'Receive Echo Reply (Link-local address)';

ECHO_AGAIN:
	vSend($IF, echo_request_link_local);

	%ret = vRecv($IF, $wait_reply, 0, 0, echo_reply_link_local,
		     ns_local, ns_local_sll);

	if ($ret{status} != 0) {
		vLog("TN can not receive Echo Reply or NS from NUT");
		return($subFail);
	}
	elsif ($ret{recvFrame} eq 'echo_reply_link_local') {
		$reachable++; #hide added,correct?
		# do nothing
	}
	elsif ($ret{recvFrame} eq 'ns_local' ||
	       $ret{recvFrame} eq 'ns_local_sll') {
		vSend($IF, na_local);
		$reachable++;

		%ret = vRecv($IF, $wait_reply, 0, 0, echo_reply_link_local);

		if ($ret{status} != 0) {
			vLog("TN can not receive Echo Reply from NUT");
			return($subFail);
		}
		elsif ($ret{recvFrame} eq 'echo_reply_link_local') {
			return($subPass);
		}
		else {
			vLog("TN received an expected packet from NUT");
		};
	};

	if ($reachable == 0) {
		$reachable++;
		goto ECHO_AGAIN;
	}

	return($subPass);
}


#-----------------------------------------------------------------
# make Neighbor Cache Entry
# In NUT,
#   make TN's global local address	 
#-----------------------------------------------------------------
sub mkNCE_Global (;$) {
	my ($IF) = @_;
	my ($reachable) = 0;

	$IF = Link1 if (!$IF) ;
        
#	%main::pktdesc = (
#	    ns_global			=> 'Receive Neighbor Solicitation',
#	    ns_global_sll		=> 'Receive Neighbor Solicitation',
#	    na_global			=> 'Send Neighbor Advertisement',
#	    ns_global_from_local	=> 'Receive Neighbor Solicitation',
#	    ns_global_sll_from_local	=> 'Receive Neighbor Solicitation',
#	    na_global_to_local		=> 'Send Neighbor Advertisement',
#	    echo_request_global		=> 'Send Echo Request (Global address)',
#	    echo_reply_global		=> 'Receive Echo Reply (Global address)',
#	);
	$main::pktdesc{ns_global} = 'Receive Neighbor Solicitation';
	$main::pktdesc{ns_global_sll} = 'Receive Neighbor Solicitation';
	$main::pktdesc{na_global} = 'Send Neighbor Advertisement';
	$main::pktdesc{ns_global_from_local} = 'Receive Neighbor Solicitation';
	$main::pktdesc{ns_global_sll_from_local} = 'Receive Neighbor Solicitation';
	$main::pktdesc{na_global_to_local} = 'Send Neighbor Advertisement';
	$main::pktdesc{echo_request_global} = 'Send Echo Request (Global address)';
	$main::pktdesc{echo_reply_global} = 'Receive Echo Reply (Global address)';

ECHO_AGAIN:
	vSend($IF, echo_request_global);

RECV_AGAIN:
	%ret = vRecv($IF, $wait_reply, 0, 0, echo_reply_global,
		     ns_global, ns_global_sll,
		     ns_global_from_local, ns_global_sll_from_local,
		     ns_local, ns_local_sll);

	if ($ret{status} != 0) {
		vLog("TN can not receive Echo Reply or NS from NUT");
		return($subFail);
	}
	elsif ($ret{recvFrame} eq 'echo_reply_global') {
		$reachable++; #hide added,correct?
		# do nothing
	}
	elsif ($ret{recvFrame} eq 'ns_global' ||
	       $ret{recvFrame} eq 'ns_global_sll' ||
	       $ret{recvFrame} eq 'ns_global_from_local' ||
	       $ret{recvFrame} eq 'ns_global_sll_from_local' ||
	       $ret{recvFrame} eq 'ns_local' ||
	       $ret{recvFrame} eq 'ns_local_sll') {

		if ($ret{recvFrame} eq 'ns_global' ||
		    $ret{recvFrame} eq 'ns_global_sll') {
			vSend($IF, na_global);
			$reachable++;
		}
		elsif ($ret{recvFrame} eq 'ns_global_from_local' ||
		       $ret{recvFrame} eq 'ns_global_sll_from_local') {
			vSend($IF, na_global_to_local);
			$reachable++;
		}
		elsif ($ret{recvFrame} eq 'ns_local' ||
		       $ret{recvFrame} eq 'ns_local_sll') {
			vSend($IF, na_local);
			goto RECV_AGAIN;
		};

		%ret = vRecv($IF, $wait_reply, 0, 0, echo_reply_global);

		if ($ret{status}) {
			vLog("TN can not receive Echo Reply from NUT");
			return($subFail);
		}
		elsif ($ret{recvFrame} eq 'echo_reply_global') {
			# do nothing
		}
		else {
			vLog("TN received an expected packet from NUT");
		};
	};

	if ($reachable == 0) {
		$reachable++;
		goto ECHO_AGAIN;
	}

	return($subPass);
}


#-----------------------------------------------------------------
# wrapper of vRecv
# handling NSs
#-----------------------------------------------------------------
sub icmp_vRecv ($$$$@) {
	my($interface, $tout, $count, $seektime, @expect) = @_;
	my($rcv_ns_local, $rcv_ns_global);

	$rcv_ns_local = 0;
	$rcv_ns_global = 0;

	while (1) {
		%ret = vRecv($interface, $tout, $count, $seektime,
			     @expect,
			     ns_local, ns_local_sll,
			     ns_global, ns_global_sll);

		if ($ret{recvFrame} eq 'ns_local' ||
		    $ret{recvFrame} eq 'ns_local_sll') {
			if ($rcv_ns_local != 0) {
				last;
			};

			vSend($interface, na_local);
			$rcv_ns_local = 1;
		}
		elsif ($ret{recvFrame} eq 'ns_global' ||
		       $ret{recvFrame} eq 'ns_global_sll') {
			if ($rcv_ns_global != 0) {
				last;
			};

			vSend($interface, na_global);
			$rcv_ns_global = 1;
		}
		else {
			last;
		};
	};

	return(%ret);
}

#-----------------------------------------------------------------
# setup() - setup test sequence
#-----------------------------------------------------------------
sub setup() {	
	my $IF0 = "Link0";
	my $IF1 = "Link1";
	vLog("Setup");
	
	#
	# following parts(mkNCE_Link() and mkNCE_global()) are not written in 
	# IOL specificatoion.
	# TAHI original.
	#

	
	my $ra = $STATEFUL_CLIENT ? 'ra_MsetOset' : 'ra_MclearOset';
	my ($ret,$tn2_prefix) = cpe_initialization($ra,$IF0,$IF1,$STATEFUL_CLIENT,0);
	if ($ret != 0) {
    vLogHTML('<FONT COLOR="#FF0000">CPE initialization fail!</FONT><BR>');
    dhcpExitFail();
	}
	if ($tn2_prefix =~ /3ffe:501:ffff/ ) {
	  vLogHTML("<B>RA includes the global prefix($tn2_prefix).</B></BR>");
	} else {
		vLogHTML('<FONT COLOR="#FF0000">Did not get golbal prefix from RA!</FONT><BR>');
	  dhcpExitFail();
	}

	vCPP("-D\'PREFIX_FROM_PD=\"$tn2_prefix\"\' ");


#	$ret = mkNCE_Global();
	
#	if ($ret != $icmp::subPass) {
#		vLogHTML('<FONT COLOR="#FF0000">*** NUT can not be initialized !! ***</FONT><BR>');
#		return($subFail);
#	}
#	else {
#		vLog("TN created the entry of TN's global address to Neighbor cache of NUT.");
#	};

	return($icmp::subPass);
}
