#!/usr/bin/perl -w
#
# Copyright (C) 2013, 2014, 2015, 2016, 2017
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
# $CHT-TL: rdisc.pm,v 1.3 2017/10/19 weifen Exp $
#
########################################################################

package rdisc;

use Exporter;
use common;
use lib '../';
use CPE6_config;
use DHCPv6_common;

BEGIN{
	$V6evalTool::TestVersion = '$Name: CE-Router_Self_Test_1_0_5 $';
}


@ISA = qw(Exporter);

@EXPORT = qw(
	startToRtAdv
	startToRtAdv_2_2_9_B
	v6LC_2_2_1
	v6LC_2_2_2_A
	v6LC_2_2_2_B
	v6LC_2_2_2_C_D_E_F
	v6LC_2_2_3
	v6LC_2_2_4
	v6LC_2_2_5
	v6LC_2_2_6_A
	v6LC_2_2_6_B_Step_4
	v6LC_2_2_6_B_Step_5_Advertising_Interface
	v6LC_2_2_6_B_Step_5_Non_Advertising_Interface
	v6LC_2_2_7
	v6LC_2_2_7_B
	v6LC_2_2_7_C
	v6LC_2_2_7_C_p1
	v6LC_2_2_7_D
	v6LC_2_2_7_E
	v6LC_2_2_7_F
	v6LC_2_2_8_A
	v6LC_2_2_8_B
	v6LC_2_2_9_A
	v6LC_2_2_9_B
	v6LC_2_2_10
	v6LC_2_2_10_A
	v6LC_2_2_10_B
	v6LC_2_2_10_C
	v6LC_2_2_10_D
	v6LC_2_2_10_E
	v6LC_2_2_10_F
	v6LC_2_2_10_G
	v6LC_2_2_10_H
	v6LC_2_2_10_I
	v6LC_2_2_11_A
	v6LC_2_2_11_B_C_D_E_F
	v6LC_2_2_12_A
	v6LC_2_2_12_B
	v6LC_2_2_13_A
	v6LC_2_2_13_B
	v6LC_2_2_13_C
	v6LC_2_2_14_A
	v6LC_2_2_14_B
	v6LC_2_2_14_C
	v6LC_2_2_15_A
	v6LC_2_2_15_B
	v6LC_2_2_15_C
	v6LC_2_2_15_D
	v6LC_2_2_15_E
	v6LC_2_2_15_F
	v6LC_2_2_16_I
	v6LC_2_2_16_J
	v6LC_2_2_17_A_B
	v6LC_2_2_17_C
	v6LC_2_2_18
	v6LC_2_2_19
);

push(@EXPORT, sort(@common::EXPORT));

#------------------------------#
# global variables             #
#------------------------------#

$pktdesc{'ra'} =
	'    Recv RA w/o SLL w/o MTU: '.
	'CE-Router (link-local) -&gt; all-nodes multicast address';
$pktdesc{'ra_sll'} =
	'    Recv RA w/ SLL w/o MTU: '.
	'CE-Router (link-local) -&gt; all-nodes multicast address';
$pktdesc{'ra_mtu'} =
	'    Recv RA w/o SLL w/ MTU: '.
	'CE-Router (link-local) -&gt; all-nodes multicast address';
$pktdesc{'ra_sll_mtu'} =
	'    Recv RA w/ SLL w/ MTU: '.
	'CE-Router (link-local) -&gt; all-nodes multicast address';
$pktdesc{'ra_rltime_zero'} =
	'    Recv RA w/o SLL w/o MTU: '.
	'CE-Router (link-local) -&gt; all-nodes multicast address';
$pktdesc{'ra_rltime_zero_sll'} =
	'    Recv RA w/ SLL w/o MTU: '.
	'CE-Router (link-local) -&gt; all-nodes multicast address';
$pktdesc{'ra_rltime_zero_mtu'} =
	'    Recv RA w/o SLL w/ MTU: '.
	'CE-Router (link-local) -&gt; all-nodes multicast address';
$pktdesc{'ra_rltime_zero_sll_mtu'} =
	'    Recv RA w/ SLL w/ MTU: '.
	'CE-Router (link-local) -&gt; all-nodes multicast address';
$pktdesc{'mcast_ra_any'} =
	'    Recv RA: '.
	'CE-Router (link-local) -&gt; all-nodes multicast address';
$pktdesc{'ra_any'} =
	'    Recv RA: CE-Router (any) -&gt; any';
$pktdesc{'rs_unspec'} =
	'    Recv RS w/o SLL: '.
	'unspecified address -&gt; all-routers multicast address';
$pktdesc{'rs'} =
	'    Recv RS w/o SLL: '.
	'NUT (link-local) -&gt; all-routers multicast address';
$pktdesc{'rs_sll'} =
	'    Recv RS w/ SLL: '.
	'NUT (link-local) -&gt; all-routers multicast address';
$pktdesc{'tn3_ereq_offlink_via_tr1'} =
        '    Send Echo Request via TR1: TN2 (global) -&gt; CE-Router (global)';
$pktdesc{'tn3_erep_offlink_via_tr1'} =
        '    Recv Echo Reply via TR1: CE-Router (global) -&gt; TN2 (global)';
$pktdesc{'tn3_erep_offlink_via_tr2'} =
        '    Recv Echo Reply via TR2: CE-Router (global) -&gt; TN2 (global)';
$pktdesc{'tn2_erep_offlink_via_tr3'} =
        '    Recv Echo Reply via TR3: CE-Router (global) -&gt; TN2 (global)';
$pktdesc{'ns_dad'} =
        '    Recv NS: CE-Router (unspecified) -&gt; CE-Router solicited-node multicast address (link-local)';



#------------------------------#
# startToRtAdv()               #
#------------------------------#
sub
startToRtAdv($)
{
	my ($Link) = @_;

	if(vRemote('racontrol.rmt', 'mode=start',
		"link0=$V6evalTool::NutDef{'Link0_device'}")) {

		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t start to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd	= $true;

	vRecv($Link,
		$MAX_INITIAL_RTR_ADVERT_INTERVAL *
		$MAX_INITIAL_RTR_ADVERTISEMENTS +
		$MIN_DELAY_BETWEEN_RAS + 1,
		0, 0);

	return($true);
}



#------------------------------#
# startToRtAdv_2_2_9_B()       #
#------------------------------#
sub
startToRtAdv_2_2_9_B($)
{
	my ($Link) = @_;

	if(vRemote('racontrol.rmt', 'mode=start',
		'maxinterval=40',
		'mininterval=30',
		"link0=$V6evalTool::NutDef{'Link0_device'}")) {

		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t start to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd	= $true;

	vRecv($Link,
		$MAX_INITIAL_RTR_ADVERT_INTERVAL *
		$MAX_INITIAL_RTR_ADVERTISEMENTS +
		$MIN_DELAY_BETWEEN_RAS + 1,
		0, 0);

	return($true);
}



#------------------------------#
# v6LC_2_2_1()                 #
#------------------------------#
sub
v6LC_2_2_1($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	Reboot the CE-Router.

#	if(vRemote('reboot.rmt', "timeout=$wait_rebootcmd")) {
#		vLogHTML('<FONT COLOR="#FF0000"><B>reboot.rmt: '.
#			'Could\'t reboot</B></FONT><BR>');
#
#		exitFail_local($Link);
#	}
	if(vRemote('reboot_async.rmt')) {
		vLogHTML('<FONT COLOR="#FF0000"><B>reboot.rmt: '.
			'Could\'t reboot</B></FONT><BR>');

		exitFail_local($Link);
	}

	if($sleep_after_reboot) {
		vSleep($sleep_after_reboot);
	}

# 2.
# 	Observe the packets transmitted by the CE-Router.

	my $bool = $false;
	my $rs = 0;
	my @recvtimes = ();
	my $wait_time = $RTR_SOLICITATION_INTERVAL * 2;

	for (my $dad = $false; ; ) {
		my %ret;
		if ($dad == $false) {
		  %ret = vRecv($Link, $wait_rebootcmd, 0, 0,'ns_dad');
		} else {
		  %ret = vRecv($Link, $wait_time, 0, 0,
			  'ns_dad', 'rs_unspec', 'rs', 'rs_sll');
		}
		if(
			($ret{'recvFrame'} eq 'rs_unspec') ||
			($ret{'recvFrame'} eq 'rs') ||
			($ret{'recvFrame'} eq 'rs_sll')
		) {
			$bool = $true;
			$rs ++;
			push(@recvtimes, $ret{'recvTime'. $ret{'recvCount'}});

			unless($dad) {
				if(
					($ret{'recvFrame'} eq 'rs') ||
					($ret{'recvFrame'} eq 'rs_sll')
				) {
					vLogHTML('<FONT COLOR="#FF0000"><B>'.
						'Any Router Solicitations '.
						'sent before the CE-Router completes DAD '.
						'must be sent from the unspecified address.'.
						'</B></FONT><BR>');

					return($false);
				}
			}

			if ($rs > 1) {
				$wait_time -= ($recvtimes[$rs] - $recvtimes[$rs - 1]);
			}
			if($rs > $MAX_RTR_SOLICITATIONS) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
					'Observed too much RSs'.
					'</B></FONT><BR>');

				return($false);
			}

			next;
		}

		if($ret{'recvFrame'} eq 'ns_dad') {
			$dad = $true;
			next;
		}

		last;
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RS'.
			'</B></FONT><BR>');

		return($false);
	}

        vLogHTML('<TABLE>');

	my $returnvalue = $true;

	for(my $d = 0; $d <= $#recvtimes; $d ++) {
		vLogHTML('<TR>');
		vLogHTML("<TD ROWSPAN=\"2\">Recv[$d]</TD>");
		vLogHTML('<TD ROWSPAN="2">:</TD>');
		vLogHTML("<TD ROWSPAN=\"2\">$recvtimes[$d] sec.</TD>");

		if($d == 0) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		}

		vLogHTML('</TR>');

		vLogHTML('<TR>');

		if($d == $#recvtimes) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		} else {
			my $delta = $recvtimes[$d + 1] - $recvtimes[$d];

			vLogHTML("<TD ROWSPAN=\"2\">Interval[$d]</TD>");
			vLogHTML('<TD ROWSPAN="2">:</TD>');
			vLogHTML("<TD ROWSPAN=\"2\">$delta sec.</TD>");

			if(
				($delta < $RTR_SOLICITATION_INTERVAL - 0.5) ||
				($delta > $RTR_SOLICITATION_INTERVAL + 0.5)
			) {
				vLogHTML('<TD ROWSPAN="2">');
				vLogHTML('<FONT COLOR="#FF0000">*</FONT>');
				vLogHTML('</TD>');
				$returnvalue = $false;
			} else {
				vLogHTML('<TD ROWSPAN="2">&nbsp;</TD>');
			}
		}

		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');

	return($returnvalue);
}



#------------------------------#
# v6LC_2_2_2_A()               #
#------------------------------#
sub
v6LC_2_2_2_A($)
{
	my ($Link) = @_;

	vClear($Link);
	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	Reboot the CE-Router.

	if(vRemote('reboot_async.rmt')) {
		vLogHTML('<FONT COLOR="#FF0000"><B>reboot.rmt: '.
			'Could\'t reboot</B></FONT><BR>');

		exitFail_local($Link);
	}

# 2.
# 	Wait until the CE-Router transmits a Router Solicitation.

	my %ret = vRecv($Link, $wait_rebootcmd, 0, 0,
		'rs_unspec', 'rs', 'rs_sll');

	if(
		($ret{'recvFrame'} ne 'rs_unspec')	&&
		($ret{'recvFrame'} ne 'rs')		&&
		($ret{'recvFrame'} ne 'rs_sll')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RS'.
			'</B></FONT><BR>');

		return($false);
	}

# 3.
# 	TR1 transmits Router Advertisement A
# 	without a Source Link-layer Address Option.
# 	The Source Address is the link-local address of TR1.
# 	The Hop Limit is 255.
# 	The ICMP Code is 0.
# 	The ICMP Checksum is valid.

	vSend($Link, 'local_ra');

	$tr1_default	= $true;
	$tr1_prefix	= $true;

# 4.
# 	Wait RTR_SOLICITATION_INTERVAL+MAX_RTR_SOLICITATION_DELAY

# 5.
# 	Observe packets transmitted from the CE-Router.

	my %ret = vRecv($Link,
		$RTR_SOLICITATION_INTERVAL + $MAX_RTR_SOLICITATION_DELAY, 0, 0,
		'rs_unspec', 'rs', 'rs_sll');

	if(
		($ret{'recvFrame'} eq 'rs_unspec')	||
		($ret{'recvFrame'} eq 'rs')		||
		($ret{'recvFrame'} eq 'rs_sll')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed RS'.
			'</B></FONT><BR>');

		return($false);
	}

	ignoreDAD($Link);

	return($true);
}



#------------------------------#
# v6LC_2_2_2_B()               #
#------------------------------#
sub
v6LC_2_2_2_B($)
{
	my ($Link) = @_;

	vClear($Link);
	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	Reboot the CE-Router.

	if(vRemote('reboot_async.rmt')) {
		vLogHTML('<FONT COLOR="#FF0000"><B>reboot.rmt: '.
			'Could\'t reboot</B></FONT><BR>');

		exitFail_local($Link);
	}

# 2.
# 	Wait until the CE-Router transmits a Router Solicitation.

	my %ret = vRecv($Link, $wait_rebootcmd, 0, 0,
		'rs_unspec', 'rs', 'rs_sll');

	if(
		($ret{'recvFrame'} ne 'rs_unspec')	&&
		($ret{'recvFrame'} ne 'rs')		&&
		($ret{'recvFrame'} ne 'rs_sll')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RS'.
			'</B></FONT><BR>');

		return($false);
	}

# 3.
# 	TR1 transmits Router Advertisement A
# 	without a Source Link-layer Address Option.
# 	The Source Address is the link-local address of TR1.
# 	The Hop Limit is 255.
# 	The ICMP Code is 0.
# 	The ICMP Checksum is valid.

	vSend($Link, 'local_ra');

	$tr1_default	= $true;
	$tr1_prefix	= $true;
	$tr1_cache	= $true;

# 4.
# 	Wait RTR_SOLICITATION_INTERVAL+MAX_RTR_SOLICITATION_DELAY

# 5.
# 	Observe packets transmitted from the CE-Router.

	my %ret = vRecv($Link,
		$RTR_SOLICITATION_INTERVAL + $MAX_RTR_SOLICITATION_DELAY, 0, 0,
		'rs_unspec', 'rs', 'rs_sll');

	if(
		($ret{'recvFrame'} eq 'rs_unspec')	||
		($ret{'recvFrame'} eq 'rs')		||
		($ret{'recvFrame'} eq 'rs_sll')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed RS'.
			'</B></FONT><BR>');

		return($false);
	}

	ignoreDAD($Link);

	return($true);
}



#------------------------------#
# v6LC_2_2_2_C_D_E_F()         #
#------------------------------#
sub
v6LC_2_2_2_C_D_E_F($)
{
	my ($Link) = @_;

	vClear($Link);
	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	Reboot the CE-Router.

	if(vRemote('reboot_async.rmt')) {
		vLogHTML('<FONT COLOR="#FF0000"><B>reboot.rmt: '.
			'Could\'t reboot</B></FONT><BR>');

		exitFail_local($Link);
	}

# 2.
# 	Wait until the CE-Router transmits a Router Solicitation.

	my %ret = vRecv($Link, $wait_rebootcmd, 0, 0,
		'rs_unspec', 'rs', 'rs_sll');

	if(
		($ret{'recvFrame'} ne 'rs_unspec')	&&
		($ret{'recvFrame'} ne 'rs')		&&
		($ret{'recvFrame'} ne 'rs_sll')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RS'.
			'</B></FONT><BR>');

		return($false);
	}

# 3.
# 	TR1 transmits Router Advertisement A
# 	without a Source Link-layer Address Option.
# 	The Source Address is the link-local address of TR1.
# 	The Hop Limit is 255.
# 	The ICMP Code is 0.
# 	The ICMP Checksum is valid.

	vSend($Link, 'local_ra');

# 4.
# 	Wait RTR_SOLICITATION_INTERVAL+MAX_RTR_SOLICITATION_DELAY

# 5.
# 	Observe packets transmitted from the CE-Router.

	my %ret = vRecv($Link,
		$RTR_SOLICITATION_INTERVAL + $MAX_RTR_SOLICITATION_DELAY, 0, 0,
		'rs_unspec', 'rs', 'rs_sll');

	if(
		($ret{'recvFrame'} ne 'rs_unspec')	&&
		($ret{'recvFrame'} ne 'rs')		&&
		($ret{'recvFrame'} ne 'rs_sll')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RS'.
			'</B></FONT><BR>');

		return($false);
	}

	ignoreDAD($Link);

	return($true);
}



#------------------------------#
# v6LC_2_2_3()                 #
#------------------------------#
sub
v6LC_2_2_3($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TN1 transmits Router Solicitation A.
# 	The Destination Address is the All-Router multicast Address.

	vSend($Link, 'local_rs');

# 2.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT).  (3 seconds)

	vRecv($Link, $RETRANS_TIMER * $MAX_UNICAST_SOLICIT, 0, 0);

# 3.
# 	TN1 transmits a link-local Echo Request to the CE-Router.

        vSend($Link, 'tn1_ereq_common');

# 4.
# 	Wait 2 seconds.

# 5.
# 	Observe the packets transmitted by the CE-Router.

	return(is_tn1_incomplete($Link));
}



#------------------------------#
# v6LC_2_2_4()                 #
#------------------------------#
sub
v6LC_2_2_4($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');


# 1.
# 	TN1 transmits a Router Solicitation with an IPv6 Hop Limit of 254.
# 	The Router Solicitation is valid otherwise.

	vSend($Link, 'rs_local');

# 2.
# 	Observe the packets transmitted by the CE-Router.

	my %ret = vRecv($Link, $MAX_RA_DELAY_TIME + 1, 0, 0, 'mcast_ra_any');
	if($ret{'recvFrame'} eq 'mcast_ra_any') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observe RA'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_2_5()                 #
#------------------------------#
sub
v6LC_2_2_5($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');


# 1.
# 	TN1 transmits a valid Router Solicitation.

	vSend($Link, 'rs_local');

# 2.
# 	Observe the packets transmitted by the CE-Router.

	my %ret = vRecv($Link, $MAX_RA_DELAY_TIME + 1, 0, 0,
		'ra_from_link1');
	if ($ret{status} == 0) {
	  my $icmp_code = $ret{"Frame_Ether.Packet_IPv6.ICMPv6_RA.code"};
	  my $icmp_len = $ret{"Frame_Ether.Packet_IPv6.Hdr_IPv6.PayloadLength"};
	  if ($icmp_code != 0) {
	    vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'icmp code is not 0'.
			'</B></FONT><BR>');
		return($false);
	  }
	  if ($icmp_len < 16) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'icmp length less then 16'.
			'</B></FONT><BR>');
		return($false);
	  }
	} else {
	    vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe RA'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_2_6_A()               #
#------------------------------#
sub
v6LC_2_2_6_A($$)
{
	my ($Link, $send) = @_;

# 1.
# 	Configure Interface A on the CE-Router to be a non-advertising interface.

# 2.
# 	Configure TR1 to transmit a RS to the CE-Router on Interface A.

	vClear($Link);
	vSend($Link, $send);

# 3.
# 	Observe the packets transmitted by the CE-Router on Interface A.

	my %ret = vRecv($Link, $MAX_RA_DELAY_TIME + 3, 0, 0, 'ra_any');
	if($ret{'recvFrame'} eq 'mcast_ra_any') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observe RA'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_2_6_B_Step_4()        #
#------------------------------#
sub
v6LC_2_2_6_B_Step_4($)
{
	my ($master) = @_;

# 4.
# 	If the CE-Router supports two network interfaces.
# 	Configure Interface A on the CE-Router to be an advertising interface
# 	and interface B to be a non-advertising interface.

	unless(startToRtAdv($master)) {
		return($false);
	}

	return($true);
}



#----------------------------------------------#
# v6LC_2_2_6_B_Step_5_Advertising_Interface()  #
#----------------------------------------------#
sub
v6LC_2_2_6_B_Step_5_Advertising_Interface($$)
{
	my ($master, $send) = @_;

# 5.
# 	Configure TR1 to transmit a RS to the CE-Router on Interface A
# 	and on Interface B.
 
	vClear($master);

	vSend($master, $send);

# 6.
# 	Observe the packets transmitted by the CE-Router on Interface A
# 	and Interface B.

	my %ret = vRecv($master, $MAX_RA_DELAY_TIME + 3, 0, 0,
			'ra', 'ra_sll', 'ra_mtu', 'ra_sll_mtu');
	if(
		($ret{'recvFrame'} ne 'ra') &&
		($ret{'recvFrame'} ne 'ra_sll') &&
		($ret{'recvFrame'} ne 'ra_mtu') &&
		($ret{'recvFrame'} ne 'ra_sll_mtu')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe RA'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($master, $MIN_DELAY_BETWEEN_RAS + 1, 0, 0);

	return($true);
}



#------------------------------------------------------#
# v6LC_2_2_6_B_Step_5_Non_Advertising_Interface()      #
#------------------------------------------------------#
sub
v6LC_2_2_6_B_Step_5_Non_Advertising_Interface($$)
{
	my ($slave, $send) = @_;

# 5.
# 	Configure TR1 to transmit a RS to the CE-Router on Interface A
# 	and on Interface B.
 
	vClear($slave);

	vSend($slave, $send);

# 6.
# 	Observe the packets transmitted by the CE-Router on Interface A
# 	and Interface B.

	my %ret = vRecv($slave, $MAX_RA_DELAY_TIME + 1, 0, 0, 'ra_any');
	if($ret{'recvFrame'} eq 'ra_any') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observe RA'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_2_7()                 #
#------------------------------#
sub
v6LC_2_2_7($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	Configure Interface A on the CE-Router to be an advertising interface
# 	with a MinRtrAdvInterval of 5 seconds
# 	and a MaxRtrInterval of 10 seconds.

	if(vRemote('racontrol.rmt', 'mode=start',
		'maxinterval=10',
		'mininterval=5',
		"link0=$V6evalTool::NutDef{'Link0_device'}")) {

		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t start to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd	= $true;

# 2.
# 	Observe the packets transmitted by the CE-Router on Interface A.

	my $ra	= 0;
	my @recvtimes = ();
	my $bool = $false;

	for( ; ; ) {
		$bool = $false;
		my %ret = vRecv($Link, 10 * 2, 0, 0,
			'ra_local', 'ra_sll_local',
			'ra_mtu_local', 'ra_mtu_sll_local');
		if(
			($ret{'recvFrame'} eq 'ra_local')	||
			($ret{'recvFrame'} eq 'ra_sll_local')	||
			($ret{'recvFrame'} eq 'ra_mtu_local')	||
			($ret{'recvFrame'} eq 'ra_mtu_sll_local')
		) {
			$ra ++;
			$bool = $true;

			push(@recvtimes, $ret{'recvTime'. $ret{'recvCount'}});

			if($ra >= $MAX_INITIAL_RTR_ADVERTISEMENTS + 3) {
				last;
			}

			next;
		}

		last;
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RA'.
			'</B></FONT><BR>');

		return($false);
	}

	if($ra < $MAX_INITIAL_RTR_ADVERTISEMENTS + 3) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less RAs'.
			'</B></FONT><BR>');

		return($false);
	}

	my $returnvalue = $true;

	vLogHTML('For the first few advertisements:');
	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE>');

	for(my $d = 0; $d < $MAX_INITIAL_RTR_ADVERTISEMENTS; $d ++) {
		vLogHTML('<TR>');
		vLogHTML("<TD ROWSPAN=\"2\">Recv[$d]</TD>");
		vLogHTML('<TD ROWSPAN="2">:</TD>');
		vLogHTML("<TD ROWSPAN=\"2\">at $recvtimes[$d] sec.</TD>");

		if($d == 0) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		}

		vLogHTML('</TR>');

		vLogHTML('<TR>');

		if($d == $MAX_INITIAL_RTR_ADVERTISEMENTS - 1) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		} else {
			my $delta = $recvtimes[$d + 1] - $recvtimes[$d];

			vLogHTML("<TD ROWSPAN=\"2\">Interval[$d]</TD>");
			vLogHTML('<TD ROWSPAN="2">:</TD>');
			vLogHTML(sprintf("<TD ROWSPAN=\"2\">%.1f sec.</TD>",
				$delta));

			if($delta > $MAX_INITIAL_RTR_ADVERT_INTERVAL + 0.5) {
				vLogHTML('<TD ROWSPAN="2">');
				vLogHTML('<FONT COLOR="#FF0000">*</FONT>');
				vLogHTML('</TD>');
				$returnvalue = $false;
			} else {
				vLogHTML('<TD ROWSPAN="2">&nbsp;</TD>');
			}
		}

		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');

	vLogHTML('For the following consecutive advertisements');
	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE>');

	for(my $d = $MAX_INITIAL_RTR_ADVERTISEMENTS;
		$d < $MAX_INITIAL_RTR_ADVERTISEMENTS + 3; $d ++) {

		vLogHTML('<TR>');
		vLogHTML("<TD ROWSPAN=\"2\">Recv[$d]</TD>");
		vLogHTML('<TD ROWSPAN="2">:</TD>');
		vLogHTML("<TD ROWSPAN=\"2\">at $recvtimes[$d] sec.</TD>");

		if($d == $MAX_INITIAL_RTR_ADVERTISEMENTS) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		}

		vLogHTML('</TR>');

		vLogHTML('<TR>');

		if($d == $MAX_INITIAL_RTR_ADVERTISEMENTS + 3 - 1) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		} else {
			my $delta = $recvtimes[$d + 1] - $recvtimes[$d];

			vLogHTML("<TD ROWSPAN=\"2\">Interval[$d]</TD>");
			vLogHTML('<TD ROWSPAN="2">:</TD>');
			vLogHTML(sprintf("<TD ROWSPAN=\"2\">%.1f sec.</TD>",
				$delta));

			if(($delta > 10 + 0.5) ||
				($delta < 5 - 0.5)) {

				vLogHTML('<TD ROWSPAN="2">');
				vLogHTML('<FONT COLOR="#FF0000">*</FONT>');
				vLogHTML('</TD>');
				$returnvalue = $false;
			} else {
				vLogHTML('<TD ROWSPAN="2">&nbsp;</TD>');
			}
		}

		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');

	unless($returnvalue) {
		vLogHTML('<FONT COLOR="#FF0000">'.
			'invalid interval'.
			'</FONT><BR>');
	}

	return($returnvalue);
}



#------------------------------#
# v6LC_2_2_7_B()               #
#------------------------------#
sub
v6LC_2_2_7_B($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 3.
# 	Configure Interface A on the CE-Router to be an advertising interface
# 	with a MinRtrAdvInterval of 198 seconds
# 	and a MaxRtrInterval of 600 seconds.




	if(vRemote('racontrol.rmt', 'mode=start',
		'maxinterval=600',
		'mininterval=198',
		"link0=$V6evalTool::NutDef{'Link0_device'}")) {

		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t start to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd	= $true;

# 4.
# 	Observe the packets transmitted by the CE-Router on Interface A.

	my $ra	= 0;
	my @recvtimes = ();
	my $bool = $false;

	for( ; ; ) {
		$bool = $false;
		my %ret = vRecv($Link, 16 * 2, 0, 0,
			'ra_local', 'ra_sll_local',
			'ra_mtu_local', 'ra_mtu_sll_local');
		if(
			($ret{'recvFrame'} eq 'ra_local')	||
			($ret{'recvFrame'} eq 'ra_sll_local')	||
			($ret{'recvFrame'} eq 'ra_mtu_local')	||
			($ret{'recvFrame'} eq 'ra_mtu_sll_local')
		) {
			$ra ++;
			$bool = $true;

			push(@recvtimes, $ret{'recvTime'. $ret{'recvCount'}});

			if($ra >= $MAX_INITIAL_RTR_ADVERTISEMENTS) {
				last;
			}

			next;
		}

		last;
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RA'.
			'</B></FONT><BR>');

		return($false);
	}

	if($ra < $MAX_INITIAL_RTR_ADVERTISEMENTS) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less RAs'.
			'</B></FONT><BR>');

		return($false);
	}

	my $returnvalue = $true;

	vLogHTML('<BLOCKQUOTE>');
	vLogHTML('<TABLE>');

	for(my $d = 0; $d < $MAX_INITIAL_RTR_ADVERTISEMENTS; $d ++) {
		vLogHTML('<TR>');
		vLogHTML("<TD ROWSPAN=\"2\">Recv[$d]</TD>");
		vLogHTML('<TD ROWSPAN="2">:</TD>');
		vLogHTML("<TD ROWSPAN=\"2\">at $recvtimes[$d] sec.</TD>");

		if($d == 0) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		}

		vLogHTML('</TR>');

		vLogHTML('<TR>');

		if($d == $MAX_INITIAL_RTR_ADVERTISEMENTS - 1) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		} else {
			my $delta = $recvtimes[$d + 1] - $recvtimes[$d];

			vLogHTML("<TD ROWSPAN=\"2\">Interval[$d]</TD>");
			vLogHTML('<TD ROWSPAN="2">:</TD>');
			vLogHTML(sprintf("<TD ROWSPAN=\"2\">%.1f sec.</TD>",
				$delta));

			if(($delta > $MAX_INITIAL_RTR_ADVERT_INTERVAL + 0.5) ||
			   ($delta < $MAX_INITIAL_RTR_ADVERT_INTERVAL - 0.5)) {
				vLogHTML('<TD ROWSPAN="2">');
				vLogHTML('<FONT COLOR="#FF0000">*</FONT>');
				vLogHTML('</TD>');
				$returnvalue = $false;
			} else {
				vLogHTML('<TD ROWSPAN="2">&nbsp;</TD>');
			}
		}

		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');

	unless($returnvalue) {
		vLogHTML('<FONT COLOR="#FF0000">'.
			'invalid interval'.
			'</FONT><BR>');
	}

	return($returnvalue);
}



#------------------------------#
# v6LC_2_2_7_C()               #
#------------------------------#
sub
v6LC_2_2_7_C($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure</B></U></FONT><BR>');

	unless(vrfyRouterConfigurationVariables()) {
		exitFail_local($Link);
		#NOTREACHED
	}
	
	if(vRemote('racontrol.rmt', 'mode=start',
		"maxinterval=$min_MaxRtrAdvInterval",
		"mininterval=$min_MinRtrAdvInterval",
		"chlim=$min_AdvCurHopLimit",
		"raflagsM=false",
		"raflagsO=false",
		"rltime=$min_AdvDefaultLifetime",
		"rtime=$min_AdvReachableTime",
		"retrans=$min_AdvRetransTimer",
		"pinfoflagsL=false",
		"pinfoflagsA=false",
		"vltime=$min_AdvValidLifetime",
		"pltime=$min_AdvPreferredLifetime",
		"mtu=$min_AdvLinkMTU",
		"link0=$V6evalTool::NutDef{'Link0_device'}")) {

		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t start to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd	= $true;

	my $cpp = '';
	$cpp .= "-DCPP_ADVCURHOPLIMIT=$min_AdvCurHopLimit ";
	$cpp .= "-DCPP_ADVDEFAULTLIFETIME=$min_AdvDefaultLifetime ";
	$cpp .= "-DCPP_ADVREACHABLETIME=$min_AdvReachableTime ";
	$cpp .= "-DCPP_ADVRETRANSTIMER=$min_AdvRetransTimer ";
	$cpp .= "-DCPP_ADVVALIDLIFETIME=$min_AdvValidLifetime ";
	$cpp .= "-DCPP_ADVPREFERREDLIFETIME=$min_AdvPreferredLifetime ";
	$cpp .= "-DCPP_ADVLINKMTU=$min_AdvLinkMTU ";

	vCPP($cpp);

	if($min_AdvLinkMTU) {
		my %ret = vRecv($Link, 4 * 2, 0, 0,
			'ra_mtu_local', 'ra_mtu_sll_local');
		if(
			($ret{'recvFrame'} eq 'ra_mtu_local')	||
			($ret{'recvFrame'} eq 'ra_mtu_sll_local')
		) {
			return($true);
		}
	} else {
		my %ret = vRecv($Link, 4 * 2, 0, 0,
			'ra_local', 'ra_sll_local');
		if(
			($ret{'recvFrame'} eq 'ra_local')	||
			($ret{'recvFrame'} eq 'ra_sll_local')
		) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RA'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# v6LC_2_2_7_C_p1()            #
#------------------------------#
sub
v6LC_2_2_7_C_p1($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure</B></U></FONT><BR>');

	unless(vrfyRouterConfigurationVariables()) {
		exitFail_local($Link);
		#NOTREACHED
	}
	
	if(vRemote('racontrol.rmt', 'mode=start',
		'maxinterval=4',
		'mininterval=3',
		'chlim=0',
		'raflagsM=false',
		'raflagsO=false',
		'rltime=0',
		'rtime=0',
		'retrans=0',
		'pinfoflagsL=false',
		'pinfoflagsA=false',
		'vltime=0',
		'pltime=0',
		"link0=$V6evalTool::NutDef{'Link0_device'}")) {

		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t start to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd	= $true;

	my $cpp = '';
	$cpp .= "-DCPP_ADVCURHOPLIMIT=$min_AdvCurHopLimit ";
	$cpp .= "-DCPP_ADVDEFAULTLIFETIME=$min_AdvDefaultLifetime ";
	$cpp .= "-DCPP_ADVREACHABLETIME=$min_AdvReachableTime ";
	$cpp .= "-DCPP_ADVRETRANSTIMER=$min_AdvRetransTimer ";
	$cpp .= "-DCPP_ADVVALIDLIFETIME=$min_AdvValidLifetime ";
	$cpp .= "-DCPP_ADVPREFERREDLIFETIME=$min_AdvPreferredLifetime ";
	$cpp .= "-DCPP_ADVLINKMTU=$min_AdvLinkMTU ";

	vCPP($cpp);

	my %ret = vRecv($Link, 4 * 2, 0, 0,
		'ra_local', 'ra_sll_local', 'ra_mtu_local', 'ra_mtu_sll_local');
	if(
		($ret{'recvFrame'} eq 'ra_local')	||
		($ret{'recvFrame'} eq 'ra_sll_local')	||
		($ret{'recvFrame'} eq 'ra_mtu_local')	||
		($ret{'recvFrame'} eq 'ra_mtu_sll_local')
	) {
		return($true);
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RA'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# v6LC_2_2_7_D()               #
#------------------------------#
sub
v6LC_2_2_7_D($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure</B></U></FONT><BR>');

	unless(vrfyRouterConfigurationVariables()) {
		exitFail_local($Link);
		#NOTREACHED
	}
	
	if(vRemote('racontrol.rmt', 'mode=start',
		"maxinterval=$max_MaxRtrAdvInterval",
		"mininterval=$max_MinRtrAdvInterval",
		"chlim=$max_AdvCurHopLimit",
		"raflagsM=true",
		"raflagsO=true",
		"rltime=$max_AdvDefaultLifetime",
		"rtime=$max_AdvReachableTime",
		"retrans=$max_AdvRetransTimer",
		"pinfoflagsL=true",
		"pinfoflagsA=true",
		"vltime=$max_AdvValidLifetime",
		"pltime=$max_AdvPreferredLifetime",
		"mtu=$max_AdvLinkMTU",
		"link0=$V6evalTool::NutDef{'Link0_device'}")) {

		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t start to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd			= $true;
	$rut_rtadvd_param_change	= $true;

	my $cpp = '';
	$cpp .= "-DCPP_ADVCURHOPLIMIT=$max_AdvCurHopLimit ";
	$cpp .= "-DCPP_ADVDEFAULTLIFETIME=$max_AdvDefaultLifetime ";
	$cpp .= "-DCPP_ADVREACHABLETIME=$max_AdvReachableTime ";
	$cpp .= "-DCPP_ADVRETRANSTIMER=$max_AdvRetransTimer ";
	$cpp .= "-DCPP_ADVVALIDLIFETIME=$max_AdvValidLifetime ";
	$cpp .= "-DCPP_ADVPREFERREDLIFETIME=$max_AdvPreferredLifetime ";
	$cpp .= "-DCPP_ADVLINKMTU=$max_AdvLinkMTU ";

	vCPP($cpp);

	my %ret = vRecv($Link, 16 * 2, 0, 0,
		'ra_mtu_local', 'ra_mtu_sll_local');
	if(
		($ret{'recvFrame'} eq 'ra_mtu_local')	||
		($ret{'recvFrame'} eq 'ra_mtu_sll_local')
	) {
		return($true);
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RA'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# v6LC_2_2_7_E()               #
#------------------------------#
sub
v6LC_2_2_7_E($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure</B></U></FONT><BR>');

	if(vRemote('racontrol.rmt', 'mode=start',
		"link0_prefix=8000::",
		"link0=$V6evalTool::NutDef{'Link0_device'}")) {

		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t start to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd			= $true;
	$rut_rtadvd_param_change	= $true;

	my %ret = vRecv($Link, 16 * 2, 0, 0,
		'ra_local', 'ra_sll_local', 'ra_mtu_local', 'ra_mtu_sll_local');
	if(
		($ret{'recvFrame'} eq 'ra_local')	||
		($ret{'recvFrame'} eq 'ra_sll_local')	||
		($ret{'recvFrame'} eq 'ra_mtu_local')	||
		($ret{'recvFrame'} eq 'ra_mtu_sll_local')
	) {
		return($true);
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RA'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# v6LC_2_2_7_F()               #
#------------------------------#
sub
v6LC_2_2_7_F($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure</B></U></FONT><BR>');

	if(vRemote('racontrol.rmt', 'mode=start',
		"link0_prefix=fec0::",
		"link0=$V6evalTool::NutDef{'Link0_device'}")) {

		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t start to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd			= $true;
	$rut_rtadvd_param_change	= $true;

	my %ret = vRecv($Link, 16 * 2, 0, 0,
		'ra_local', 'ra_sll_local', 'ra_mtu_local', 'ra_mtu_sll_local');
	if(
		($ret{'recvFrame'} eq 'ra_local')	||
		($ret{'recvFrame'} eq 'ra_sll_local')	||
		($ret{'recvFrame'} eq 'ra_mtu_local')	||
		($ret{'recvFrame'} eq 'ra_mtu_sll_local')
	) {
		return($true);
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RA'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# v6LC_2_2_8_A()               #
#------------------------------#
sub
v6LC_2_2_8_A($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	Configure Interface A on the CE-Router to be an advertising interface.

	unless(startToRtAdv($Link)) {
		return($false);
	}

# 2.
# 	Configure Interface A on the CE-Router to discontinue
# 	be an advertising interface.
 
	if(vRemote('racontrol.rmt', 'mode=stop')) {
		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t stop to send RA</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_rtadvd	= $false;

# 3.
# 	Observe the packets transmitted by the CE-Router on Interface A.

	my $ra  = 0;
	my $bool = $false;

	for( ; ; ) {
		my %ret = vRecv($Link, $MAX_INITIAL_RTR_ADVERT_INTERVAL + 1,
			0, 0,
			'ra_rltime_zero',			'ra_rltime_zero_sll',
			'ra_rltime_zero_mtu',		'ra_rltime_zero_sll_mtu',
			'ra_rltime_zero_no_pi',		'ra_rltime_zero_no_pi_sll',
			'ra_rltime_zero_no_pi_mtu',	'ra_rltime_zero_no_pi_sll_mtu');
		if(
			($ret{'recvFrame'} eq 'ra_rltime_zero')		||
			($ret{'recvFrame'} eq 'ra_rltime_zero_sll')	||
			($ret{'recvFrame'} eq 'ra_rltime_zero_mtu')	||
			($ret{'recvFrame'} eq 'ra_rltime_zero_sll_mtu')	||
			($ret{'recvFrame'} eq 'ra_rltime_zero_no_pi')	||
			($ret{'recvFrame'} eq 'ra_rltime_zero_no_pi_sll')	||
			($ret{'recvFrame'} eq 'ra_rltime_zero_no_pi_mtu')	||
			($ret{'recvFrame'} eq 'ra_rltime_zero_no_pi_sll_mtu')
		) {
			$ra ++;
			$bool = $true;

			if($ra > $MAX_FINAL_RTR_ADVERTISEMENTS) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
					'Observe too much RA'.
					'</B></FONT><BR>');
				return($false);
			}

			next;
		}

		last;
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe RA'.
			'</B></FONT><BR>');

		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_2_8_B()               #
#------------------------------#
sub
v6LC_2_2_8_B($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 4.
# 	Configure Interface A on the CE-Router to be an advertising interface.

	unless(startToRtAdv($Link)) {
		return($false);
	}

# 5.
# 	Disable the CE-Router's IP forwarding capability.

	if(vRemote('sysctl.rmt',
		'name=net.inet6.ip6.forwarding',
		'value=0')) {

		vLogHTML('<FONT COLOR="#FF0000"><B>sysctl.rmt: '.
			'Could\'t set kernel state</B></FONT><BR>');

		exitFail_local($Link);
		#NOTREACHED
	}

	$rut_ipv6_forwarding_disable = $true;

# 6.
# 	Observe the packets transmitted by the NUT on Interface A.

	vSend($Link, 'rs_local');

	my %ret = vRecv($Link, $MAX_RA_DELAY_TIME + 1, 0, 0,
		'ra_rltime_zero', 'ra_rltime_zero_sll');
	if(
		($ret{'recvFrame'} ne 'ra_rltime_zero') &&
		($ret{'recvFrame'} ne 'ra_rltime_zero_sll')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe RA'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_2_9_A()               #
#------------------------------#
sub
v6LC_2_2_9_A($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');


	my @delays	= ();

	for(my $d = 0; $d < 2; $d ++) {
		vLogHTML('<FONT SIZE="4"><U><B>'.
			"Delay[$d] calculation".
			'</B></U></FONT><BR>');

# 1.
# 	TN1 transmits Router Solicitation A twice, 3 seconds apart.
# 	The Destination Address is the all-routers multicast address.

		my %vsend = vSend($Link, 'rs_local');

# 2.
# 	Observe the packets transmitted by the CE-Router.

                my %vrecv = vRecv($Link, $MAX_RA_DELAY_TIME + 1, 0, 0,
		      'ra_from_link1');
		if ($vrecv{status} == 0) {
		  my $icmp_code = $vrecv{"Frame_Ether.Packet_IPv6.ICMPv6_RA.code"};
		  my $icmp_len = $vrecv{"Frame_Ether.Packet_IPv6.Hdr_IPv6.PayloadLength"};
		  if ($icmp_code != 0) {
		      vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'icmp code is not 0'.
			'</B></FONT><BR>');
		      return($false);
		  }
		  if ($icmp_len < 16) {
		      vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'icmp length less then 16'.
			'</B></FONT><BR>');
		      return($false);
		  }
		} else {
		    vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe RA'.
			'</B></FONT><BR>');
		    return($false);
		}

		my $sendtime = $vsend{'sentTime1'};
		my $recvtime = $vrecv{'recvTime' . $vrecv{'recvCount'}};

		vLogHTML('<BLOCKQUOTE>');
		vLogHTML('<TABLE>');
		vLogHTML('<TR>');
		vLogHTML("<TD>Send RS[$d]</TD>");
		vLogHTML('<TD>:</TD>');
		vLogHTML("<TD>at $sendtime sec.</TD>");
		vLogHTML('</TR>');
		vLogHTML('<TR>');
		vLogHTML("<TD>Recv RA[$d]</TD>");
		vLogHTML('<TD>:</TD>');
		vLogHTML("<TD>at $recvtime sec.</TD>");
		vLogHTML('</TR>');

		my $delta = $recvtime - $sendtime;

		vLogHTML('<TR>');
		vLogHTML("<TD>Delay[$d]</TD>");
		vLogHTML('<TD>:</TD>');
		vLogHTML("<TD>$delta sec.</TD>");
		vLogHTML('</TR>');
		vLogHTML('</TABLE>');
		vLogHTML('</BLOCKQUOTE>');

                push(@delays, $delta);

		if($d + 1 < 2) {
			vRecv($Link, $MIN_DELAY_BETWEEN_RAS + 1, 0, 0);
		}
	}

	my $returnv = $true;

	vLogHTML('<FONT SIZE="4"><U><B>'.
		'Summary of calculation'.
		'</B></U></FONT><BR>');

	vLogHTML('<BLOCKQUOTE>');
        vLogHTML('<TABLE>');

	for(my $d = 0; $d <= $#delays; $d ++) {
		my $delay = $delays[$d];

		if($delay > $MAX_RA_DELAY_TIME) {
			$returnv = $false;
		}

		vLogHTML('<TR>');
		vLogHTML("<TD>Delay[$d]</TD>");
		vLogHTML('<TD>:</TD>');
		vLogHTML("<TD>$delay sec.</TD>");
		vLogHTML(
			($delay > $MAX_RA_DELAY_TIME) ?
			'<TD><FONT COLOR="#FF0000">*</FONT></TD>' :
			'<TD>&nbsp;</TD>'
		);
		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');
	vLogHTML('</BLOCKQUOTE>');
	return($returnv);
}



#------------------------------#
# v6LC_2_2_9_B()               #
#------------------------------#
sub
v6LC_2_2_9_B($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 3.
# 	Configure the CE-Router with a MinRtrAdvInterval of 30 seconds
# 	and a MaxRtrAdvInterval of 40 seconds.


	my @recvtimes = ();
	my $bool = $false;

	for(my $d = 0; $d < 10; $d ++) {
# 4.
# 	TN1 transmits Router Solicitation B twice, 2 seconds apart.
# 	The destination Address is the all-routers multicast address.

		vSend($Link, 'rs_local');

# 5.
# 	Observe the packets transmitted by the CE-Router.
# 	Repeat Step 4.

                my %ret = vRecv($Link, $MAX_RA_DELAY_TIME + 1, 0, 0,
			'ra_from_link1');
		if ($ret{status} == 0) {
		  my $icmp_code = $ret{"Frame_Ether.Packet_IPv6.ICMPv6_RA.code"};
		  my $icmp_len = $ret{"Frame_Ether.Packet_IPv6.Hdr_IPv6.PayloadLength"};
		  if ($icmp_code != 0) {
		      vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'icmp code is not 0'.
			'</B></FONT><BR>');
		      return($false);
		  }
		  if ($icmp_len < 16) {
		      vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'icmp length less then 16'.
			'</B></FONT><BR>');
		      return($false);
		  }


		

		  push(@recvtimes, $ret{'recvTime'. $ret{'recvCount'}});
		  if($bool) {
		    last;
		  }
		  $bool = $true;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe RA'.
			'</B></FONT><BR>');
		return($false);
	}

	unless($#recvtimes) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observed too less RAs'.
			'</B></FONT><BR>');
		return($false);
	}

	vLogHTML('<TABLE>');

	my $returnvalue = $true;

	for(my $d = 0; $d <= $#recvtimes; $d ++) {
		vLogHTML('<TR>');
		vLogHTML("<TD ROWSPAN=\"2\">Recv[$d]</TD>");
		vLogHTML('<TD ROWSPAN="2">:</TD>');
		vLogHTML("<TD ROWSPAN=\"2\">$recvtimes[$d] sec.</TD>");

		if($d == 0) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		}

		vLogHTML('</TR>');

		vLogHTML('<TR>');

		if($d == $#recvtimes) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		} else {
			my $delta = $recvtimes[$d + 1] - $recvtimes[$d];

			vLogHTML("<TD ROWSPAN=\"2\">Interval[$d]</TD>");
			vLogHTML('<TD ROWSPAN="2">:</TD>');
			vLogHTML("<TD ROWSPAN=\"2\">$delta sec.</TD>");

			if($delta < $MIN_DELAY_BETWEEN_RAS) {
				vLogHTML('<TD ROWSPAN="2">');
				vLogHTML('<FONT COLOR="#FF0000">*</FONT>');
				vLogHTML('</TD>');
				$returnvalue = $false;
			} else {
				vLogHTML('<TD ROWSPAN="2">&nbsp;</TD>');
			}
		}

		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');

	return($returnvalue);
}



#------------------------------#
# v6LC_2_2_10()                #
#------------------------------#
sub
v6LC_2_2_10($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR1 transmits Router Advertisement A.
	if (!$STATEFUL_CLIENT) {
	  vSend($Link, 'local_ra_tr1');
	}
	$tr1_default	= $true;
	$tr1_prefix	= $true;
	$tr1_force	= $true;

	ignoreDAD($Link);

# 2.
# 	TR1 transmits Packet A, an Echo Request.

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tn3_ereq_offlink_via_tr1');

# 3.
# 	Observe the packets transmitted by the CE-Router.
# 	TR1 transmits a Neighbor Advertisement
# 	in response to any Neighbor Solicitations from the CE-Router.

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn3_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn3_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 4.
# 	TR2 transmits Router Advertisement B.
	if ($STATEFUL_CLIENT) {
	  vSend($Link, 'local_ra_tr2_m1');
	} else {
	  vSend($Link, 'local_ra_tr2');
	}

	$tr2_default	= $true;
	$tr2_prefix	= $true;
	$tr2_force	= $true;

# 5.
# 	TN2 transmits Packet A every 3 seconds for 30 seconds.
# 	Packet A is an ICMPv6 Echo Request
# 	that has an off-link global source address.

# 6.
# 	Observe the packets transmitted by the CE-Router.

# 7.
# 	When Reachable Time expires, and the CE-Router solicits TR1,
# 	no Neighbor Advertisements are transmitted by TR1.

	@frames	= sort(keys(%tr1_ucast_nd_common));

	$bool = $false;

	for(my $d = 0; $d < 10; $d ++) {
		my $erep = $false;

		vSend($Link, 'tn3_ereq_offlink_via_tr1');
		%ret = vRecv($Link, $TimeOut, 0, 0,
			'tn3_erep_offlink_via_tr1', @frames);

		if($ret{'recvFrame'} eq 'tn3_erep_offlink_via_tr1') {
			$erep = $true;
			%ret = vRecv($Link, 3, 0, 0, @frames);
		}

		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				$bool = $true;
				last;
			}
		}

		if($bool) {
			vRecv($Link,
				$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
				0, 0);

			$tr1_cache = $false;

			last;
		}

		if($erep) {
			next;
		}

		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply or NS'.
			'</B></FONT><BR>');

		return($false);
		last;
	}

# 8.
# 	Observe the packets transmitted by the CE-Router.

	@frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tn3_ereq_offlink_via_tr1');

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			vRecv($Link,
				$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
				0, 0);

			$tr2_cache = $false;
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return($false);
}



#------------------------------#
# v6LC_2_2_10_A()              #
#------------------------------#
sub
v6LC_2_2_10_A($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(startToRtAdv($Link)) {
		return($false);
	}

	my %vsend = vSend($Link, 'rs_local');
	$tn1_cache = $true;

	vRecv($Link, $MAX_RA_DELAY_TIME + 1, 0, 0);

	vSend($Link, 'tn1_ereq_common');

	return(is_tn1_stale($Link));
}



#------------------------------#
# v6LC_2_2_10_B()              #
#------------------------------#
sub
v6LC_2_2_10_B($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(startToRtAdv($Link)) {
		return($false);
	}

	vSend($Link, 'rs_local');

	vRecv($Link, $MAX_RA_DELAY_TIME + 1, 0, 0);

	vSend($Link, 'tn1_ereq_common');

	return(is_tn1_incomplete($Link));
}



#------------------------------#
# v6LC_2_2_10_C()              #
#------------------------------#
sub
v6LC_2_2_10_C($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(startToRtAdv($Link)) {
		return($false);
	}

	unless(tn1_none_to_incomplete($Link)) {
		return($false);
	}

	vSend($Link, 'rs_local');
	$tn1_cache = $true;

	return(is_tn1_stale($Link));
}



#------------------------------#
# v6LC_2_2_10_D()              #
#------------------------------#
sub
v6LC_2_2_10_D($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(startToRtAdv($Link)) {
		return($false);
	}

	unless(tn1_none_to_reachable($Link)) {
		return($false);
	}

	vSend($Link, 'rs_local');

	vSend($Link, 'tn1_ereq_diff');

	return(is_tn1_stale_diff($Link));
}



#------------------------------#
# v6LC_2_2_10_E()              #
#------------------------------#
sub
v6LC_2_2_10_E($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(startToRtAdv($Link)) {
		return($false);
	}

	unless(tn1_none_to_reachable($Link)) {
		return($false);
	}

	vSend($Link, 'rs_local');

	vSend($Link, 'tn1_ereq_common');

	return(is_tn1_reachable($Link));
}



#------------------------------#
# v6LC_2_2_10_F()              #
#------------------------------#
sub
v6LC_2_2_10_F($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(startToRtAdv($Link)) {
		return($false);
	}

	unless(tn1_none_to_stale($Link)) {
		return($false);
	}

	vSend($Link, 'rs_local');

	vSend($Link, 'tn1_ereq_diff');

	return(is_tn1_stale_diff($Link));
}



#------------------------------#
# v6LC_2_2_10_G()              #
#------------------------------#
sub
v6LC_2_2_10_G($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(startToRtAdv($Link)) {
		return($false);
	}

	unless(tn1_none_to_stale($Link)) {
		return($false);
	}

	vSend($Link, 'rs_local');

	vSend($Link, 'tn1_ereq_common');

	return(is_tn1_stale($Link));
}



#------------------------------#
# v6LC_2_2_10_H()              #
#------------------------------#
sub
v6LC_2_2_10_H($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(startToRtAdv($Link)) {
		return($false);
	}

	unless(tn1_none_to_probe($Link)) {
		return($false);
	}

	vSend($Link, 'rs_local');

	vSend($Link, 'tn1_ereq_diff');

	return(is_tn1_stale_diff($Link));
}



#------------------------------#
# v6LC_2_2_10_I()              #
#------------------------------#
sub
v6LC_2_2_10_I($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(startToRtAdv($Link)) {
		return($false);
	}

	unless(tn1_none_to_probe($Link)) {
		return($false);
	}

	vSend($Link, 'rs_local');

	vSend($Link, 'tn1_ereq_common');

	return(is_tn1_probe($Link));
}



#------------------------------#
# v6LC_2_2_11_A()              #
#------------------------------#
sub
v6LC_2_2_11_A($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR1 transmits the Router Advertisement.
# 	The Source Address is the global address of TR1.
# 	The Router Advertisements is valid otherwise.

	vSend($Link, 'local_ra');

# 2.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT).  (3 seconds)

	ignoreDAD($Link);

# 3.
# 	TR1 transmits a link-local Echo Request to the CE-Router.

	vSend($Link, 'local_ereq');

# 4.
# 	Wait 2 seconds and observe the packets transmitted by the CE-Router.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'local_mcast_ns');
	unless($ret{'recvFrame'} eq 'local_mcast_ns') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
		0, 0);

	return($true);
}



#------------------------------#
# v6LC_2_2_11_B_C_D_E_F()      #
#------------------------------#
sub
v6LC_2_2_11_B_C_D_E_F($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 5.
# 	TR1 transmits the Router Advertisement.
# 	For Part B, The Hop Limit is 2.
# 	For Part C, The Checksum is 0.
# 	For Part D, The ICMP Code is 1.
# 	For Part E, The ICMP Length is 14.
# 	For Part F, The Option of Length is 0.
#   The Router Advertisement is valid otherwise.

	vSend($Link, 'local_ra');

# 6.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT). (3 seconds)

	ignoreDAD($Link);

# 7.
# 	TR1 transmits a link-local Echo Request to the CE-Router.

	vSend($Link, 'tr1_ereq_common');

# 8.
# 	Wait 2 seconds and observe the packets transmitted by the CE-Router.

	my @frames	= sort(keys(%tr1_mcast_nd_common));

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			vRecv($Link,
				$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
				0, 0);

			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe NS'.
		'</B></FONT><BR>');

	return($false);
}


#------------------------------#
# v6LC_2_2_12_A()              #
#------------------------------#
sub
v6LC_2_2_12_A($)
{
	my ($Link) = @_;

	my $CurHopLimit = 0;

	return(v6LC_2_2_12_strict($Link, $CurHopLimit));
}

#------------------------------#
# v6LC_2_2_12_B()              #
#------------------------------#
sub
v6LC_2_2_12_B($)
{
	my ($Link) = @_;

	my $CurHopLimit = 100;

	return(v6LC_2_2_12_strict($Link, $CurHopLimit));
}



#------------------------------#
# v6LC_2_2_12_strict()         #
#------------------------------#
sub
v6LC_2_2_12_strict($$)
{
	my ($Link, $CurHopLimit) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TN1 transmits an Echo Request to the CE-Router.

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_common));

	vSend($Link, 'tn1_ereq_common');

# 2.
# 	Observe the packets transmitted by the CE-Router.

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn1_mcast_nd_common{$frame});
			$tn1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
	unless($ret{'recvFrame'} eq 'tn1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	# >>>>>>>>>>>>>>> from >>>>>>>>>>>>>>> #
	my $default_chlim = $ret{'Frame_Ether.Packet_IPv6.Hdr_IPv6.HopLimit'};
	vLogHTML("<BR>CurHopLimit: $default_chlim<BR><BR>");

	unless($default_chlim) {
		vLogHTML('<FONT COLOR="#FF0000"><B>CurHopLimit is 0</B></FONT><BR>');
		return($false);
	}
	# <<<<<<<<<<<<<<<< to <<<<<<<<<<<<<<<< #

# 3.
# 	TR1 transmits a Router Advertisement
# 	with a Cur Hop Limit value of 100.


	vSend($Link, 'local_ra');


# 4.
# 	TN1 transmits an Echo Request to the CE-Router.

	vSend($Link, 'tn1_ereq_common');

# 5.
# 	Observe the packets transmitted by the CE-Router.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'local_erep');
	unless($ret{'recvFrame'} eq 'local_erep') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	# >>>>>>>>>>>>>>> from >>>>>>>>>>>>>>> #
	my $configured_chlim = $ret{'Frame_Ether.Packet_IPv6.Hdr_IPv6.HopLimit'};
	vLogHTML("<BR>CurHopLimit: $configured_chlim<BR>");

	if($CurHopLimit) {
		if ($configured_chlim != $CurHopLimit) {
			vLogHTML("<FONT COLOR=\"#FF0000\"><B>CurHopLimit $configured_chlim is incorrect. It should be $CurHopLimit.".
				"</B></FONT><BR>");
			return($false);
		}
	} else {
		if ($configured_chlim != $default_chlim) {
			vLogHTML("<FONT COLOR=\"#FF0000\"><B>CurHopLimit $configured_chlim is incorrect. It should be $default_chlim.".
				"</B></FONT><BR>");
			return($false);
		}
	}
	# <<<<<<<<<<<<<<<< to <<<<<<<<<<<<<<<< #

	return($true);
}



#------------------------------#
# v6LC_2_2_13_A()              #
#------------------------------#
sub
v6LC_2_2_13_A($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	$tr1_change_param	= $true;
	$tr1_force		= $true;

# 2.
# 	TN2 transmits a global Echo Request to the CE-Router
# 	every second for 19 seconds.

# 3.
# 	Observe the packets transmitted by the CE-Router.

	my %ret = ();

	for(my $d = 0; $d < 19; $d ++) {
		vSend($Link, 'tn3_ereq_offlink_via_tr1');

		%ret = vRecv($Link, $TimeOut, 0, 0, 'tn3_erep_offlink_via_tr1');
		unless($ret{'recvFrame'} eq 'tn3_erep_offlink_via_tr1') {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe Echo Reply'.
				'</B></FONT><BR>');
			return($false);
		}

		vRecv($Link, 1, 0, 0);
	}

	#
	#              |       |
	#              |       | $send_ra0   <----+
	# RA           | ----> * 0 sec.           |
	#              |       | $send_ra1   <-+  |
	#              |       |               |  |
	#             ...     ...             (a)(b)
	#              |       |               |  |
	# Echo Request | ----> |               |  |
	#              |       | $prev_time0 <-+  |
	# Echo Reply   | <---- |                  |
	#              |       | $prev_time1      |
	#              |       * 20 sec.          |
	# Echo Request | ----> |                  |
	#              |       | $recv_x0         |
	# no response  |   X-- |                  |
	#              |       | $recv_x1    <----+
	#              |       |
	#              V       V
	#
	#     (a) < 20
	#     (b) > 20
	#

	my $margin = 0.5;

# 4.
# 	TR1 transmits the Router Advertisement.

	my $send_ra0 = time - $margin;
	if ($STATEFUL_CLIENT) {
	  %ret = vSend($Link, 'local_ra_m1_update');
	} else {
	  %ret = vSend($Link, 'local_ra');
	}
	my $send_ra1 = time + $margin;

	$tr1_force = $true;

# 5.
# 	TN2 transmits a global Echo Request to the CE-Router
# 	every second for 21 seconds.

# 6.
# 	Observe the packets transmitted by the CE-Router.

	my @frames	= (
				   'tr1_mcast_ns_linklocal_common',
				   'tn3_erep_offlink_via_tr1',
				  );
	my @tr1_ns = keys(%tr1_ucast_nd_common);
	my $lifetime = 20;

	my $prev_time0 = $send_ra0;
	my $prev_time1 = $send_ra1;

	for ( ; ; ) {
		vClear($Link);
 		vSend($Link, 'tn3_ereq_offlink_via_tr1');

		my $recv_x0 = time - $margin;
		%ret = vRecv($Link, $TimeOut, 0, 0, @frames, @tr1_ns);
		my $recv_x1 = time + $margin;

		foreach my $ns (@tr1_ns) {
			if ($ret{'recvFrame'} eq $ns) {
				vSend($Link, $tr1_ucast_nd_common{$ns});
				last;
			}
		}

		my $delta_in  = $prev_time0 - $send_ra1;
		my $delta_out = $recv_x1    - $send_ra0;

		if ($ret{'recvFrame'} eq 'tr1_mcast_ns_linklocal_common' ||
			$ret{'recvFrame'} eq 'tn3_erep_offlink_via_tr1') {

			unless($delta_in <= $lifetime) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
					 "$delta_in &lt; invalid expiration &lt; $delta_out".
					 '</B></FONT><BR>');
				return($false);
			}
		} else {
			unless($delta_out => $lifetime) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
					 "$delta_in &lt; invalid expiration &lt; $delta_out".
					 '</B></FONT><BR>');
				return($false);
			}

			return($true);
			## PASS
		}

		$prev_time0 = $recv_x0;
		$prev_time1 = $recv_x1;
	}
}


#------------------------------#
# v6LC_2_2_13_B()              #
#------------------------------#
sub
v6LC_2_2_13_B($)
{
	my ($Link) = @_;
	my %magic = (
		  'tn3_erep_offlink_via_tr1'	=> 'local_ra_tr1',
		  'tn3_erep_offlink_via_tr2'	=> 'local_ra_tr2',
	);
	my $tr1_cache = $false;
	my $tr2_cache = $false;
	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 7.
# 	TN3 transmits a global Echo Request to the CE-Router.

	vSend($Link, 'tn3_ereq_offlink_via_tr1');

# 8.
# 	Observe the packets transmitted by the CE-Router.
	my @frames	= sort(keys(%tr1_mcast_nd_common));
	my @frames2	= sort(keys(%tr2_mcast_nd_common));
	
	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames,@frames2);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			vLogHTML('Receive NS for TR1, sends TR1 NA.<BR>');
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			my %ret2 = vRecv($Link, $TimeOut, 0, 0, sort(keys(%magic)));
			unless(defined($magic{$ret2{'recvFrame'}})) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe Echo Reply'.
				'</B></FONT><BR>');
				return($false);
			}
			vLogHTML('Receive echo reply Using TR1 as next hop.<BR>');			
			last;
		}
	}
	
	if ($tr1_cache == $false) {
		foreach my $frame (@frames2) {
			if($ret{'recvFrame'} eq $frame) {
				vLogHTML('Receive NS for TR2, sends TR2 NA.<BR>');
				vSend($Link, $tr2_mcast_nd_common{$frame});
				$tr2_cache = $true;
				my %ret2 = vRecv($Link, $TimeOut, 0, 0, sort(keys(%magic)));
				unless(defined($magic{$ret2{'recvFrame'}})) {
					vLogHTML('<FONT COLOR="#FF0000"><B>'.
					'Could\'t observe Echo Reply'.
					'</B></FONT><BR>');
					return($false);
				}
				vLogHTML('Receive echo reply Using TR2 as next hop.<BR>');	
				last;
			}
		}
	}
	
	if (($tr1_cache == $false)  && ($tr2_cache == $false)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe NS for Router TR1 or TR2'.
		'</B></FONT><BR>');
		return($false);
	}

# 9.
# 	TR1 transmits a Router Advertisement with Router Lifetime set to zero.

	vSend($Link, 'local_ra_tr1');
	vSleep(1);
# 10.
# 	TN3 transmits a global Echo Request to the CE-Router.

	vSend($Link, 'tn3_ereq_offlink_via_tr1');

# 11.
# 	Observe the packets transmitted by the CE-Router.

	if ($tr2_cache == $false) {
		my %ret = vRecv($Link, $TimeOut, 0, 0,@frames2);
		foreach my $frame (@frames2) {
			if($ret{'recvFrame'} eq $frame) {
				vLogHTML('Receive NS for TR2, sends TR2 NA.<BR>');
				vSend($Link, $tr2_mcast_nd_common{$frame});
				$tr2_cache = $true;	
				last;
			}
		}
	}
	%ret = vRecv($Link, $TimeOut, 0, 0, sort(keys(%magic)));
	unless(defined($magic{$ret{'recvFrame'}})) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 12.
# 	TR2 transmits a Router Advertisement with Router Lifetime set to zero.

	vSend($Link, 'local_ra_tr2');
	vSleep(1);
# 13.
# 	TN3 transmits a global Echo Request to the CE-Router.

	vSend($Link, 'tn3_ereq_offlink_via_tr1');

# 14.
# 	Observe the packets transmitted by the CE-Router.

	%ret = vRecv($Link, $TimeOut, 0, 0,
		'tr1_mcast_ns_linklocal_common',
		'tr2_mcast_ns_linklocal_common',
		'tn3_erep_offlink_via_tr1', 'tn3_erep_offlink_via_tr2');

	if(
		($ret{'recvFrame'} eq 'tr1_mcast_ns_linklocal_common') ||
		($ret{'recvFrame'} eq 'tr2_mcast_ns_linklocal_common')
	) {
		vRecv($Link,
			$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
			0, 0);

		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observe NS</B></FONT><BR>');

		return($false);
	}

	if(
		($ret{'recvFrame'} eq 'tn3_erep_offlink_via_tr1') ||
		($ret{'recvFrame'} eq 'tn3_erep_offlink_via_tr2')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observe Echo Reply</B></FONT><BR>');

		return($false);
	}

	vRecv($Link, $TimeOut * ($MAX_MULTICAST_SOLICIT - 1), 0, 0);

	return($true);
}


#------------------------------#
# v6LC_2_2_13_C()              #
#------------------------------#
sub
v6LC_2_2_13_C($)
{
	my ($Link) = @_;

	my %magic = (
		'tn3_erep_offlink_via_tr1'	=> 'local_ra_tr1',
		'tn3_erep_offlink_via_tr2'	=> 'local_ra_tr2',
	);
	my $tr1_cache = $false;
	my $tr2_cache = $false;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 15.
# 	TN3 transmits a global Echo Request to the CE-Router.

	vSend($Link, 'tn3_ereq_offlink_via_tr1');

# 16.
# 	Observe the packets transmitted by the CE-Router.

	my @frames	= sort(keys(%tr1_mcast_nd_common));
	my @frames2	= sort(keys(%tr2_mcast_nd_common));
	
	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames,@frames2);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			vLogHTML('Receive NS for TR1, sends TR1 NA.<BR>');
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			my %ret2 = vRecv($Link, $TimeOut, 0, 0, sort(keys(%magic)));
			unless(defined($magic{$ret2{'recvFrame'}})) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe Echo Reply'.
				'</B></FONT><BR>');
				return($false);
			}
			vLogHTML('Receive echo reply Using TR1 as next hop.<BR>');			
			last;
		}
	}
	
	if ($tr1_cache == $false) {
		foreach my $frame (@frames2) {
			if($ret{'recvFrame'} eq $frame) {
				vLogHTML('Receive NS for TR2, sends TR2 NA.<BR>');
				vSend($Link, $tr2_mcast_nd_common{$frame});
				$tr2_cache = $true;
				my %ret2 = vRecv($Link, $TimeOut, 0, 0, sort(keys(%magic)));
				unless(defined($magic{$ret2{'recvFrame'}})) {
					vLogHTML('<FONT COLOR="#FF0000"><B>'.
					'Could\'t observe Echo Reply'.
					'</B></FONT><BR>');
					return($false);
				}
				vLogHTML('Receive echo reply Using TR2 as next hop.<BR>');	
				last;
			}
		}
	}
	
	if (($tr1_cache == $false)  && ($tr2_cache == $false)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe NS for Router TR1 or TR2'.
		'</B></FONT><BR>');
		return($false);
	}

# 17.
# 	TR1 transmits a Router Advertisement with Router Lifetime set to five.

	vSend($Link, 'local_ra_tr1');

# 18.
# 	Wait seven seconds.

	vRecv($Link, 7, 0, 0);

# 19.
# 	TN3 transmits a global Echo Request to the CE-Router.

	vSend($Link, 'tn3_ereq_offlink_via_tr1');

# 20.
# 	Observe the packets transmitted by the CE-Router.

	if ($tr2_cache == $false) {
		my %ret = vRecv($Link, $TimeOut, 0, 0,@frames2);
		foreach my $frame (@frames2) {
			if($ret{'recvFrame'} eq $frame) {
				vLogHTML('Receive NS for TR2, sends TR2 NA.<BR>');
				vSend($Link, $tr2_mcast_nd_common{$frame});
				$tr2_cache = $true;	
				last;
			}
		}
	}
	%ret = vRecv($Link, $TimeOut, 0, 0, sort(keys(%magic)));
	unless(defined($magic{$ret{'recvFrame'}})) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 21.
# 	TR2 transmits a Router Advertisement with Router Lifetime set to five.

	vSend($Link,'local_ra_tr2');
	
# 22.
# 	Wait seven seconds.

	vRecv($Link, 7, 0, 0);

# 23.
# 	TN2 transmits a global Echo Request to the CE-Router.

	vSend($Link, 'tn3_ereq_offlink_via_tr1');

# 24.
# 	Observe the packets transmitted by the CE-Router.

	%ret = vRecv($Link, $TimeOut, 0, 0,
		'tr1_mcast_ns_linklocal_common',
		'tr2_mcast_ns_linklocal_common',
		'tn3_erep_offlink_via_tr1', 'tr1_mcast_ns_linklocal_common');

	if(
		($ret{'recvFrame'} eq 'tr1_mcast_ns_linklocal_common') ||
		($ret{'recvFrame'} eq 'tr2_mcast_ns_linklocal_common')
	) {
		vRecv($Link,
			$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
			0, 0);

		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observe NS</B></FONT><BR>');

		return($false);
	}

	if(
		($ret{'recvFrame'} eq 'tn3_erep_offlink_via_tr1') ||
		($ret{'recvFrame'} eq 'tn3_erep_offlink_via_tr2')
	) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observe Echo Reply</B></FONT><BR>');

		return($false);
	}

        vRecv($Link, $TimeOut * ($MAX_MULTICAST_SOLICIT - 1), 0, 0);

        return($true);
}


#------------------------------#
# v6LC_2_2_14_A()              #
#------------------------------#
sub
v6LC_2_2_14_A($)
{
	my ($Link) = @_;

	my $start;
	my $end;
	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR1 transmits the Router Advertisement
# 	with a Reachable Time of 10 seconds.

	vSend($Link, 'local_ra');
	$tr1_default	= $true;
	$tr1_prefix	= $true;
	$tr1_force	= $true;

# 2.
# 	TN1 transmits a link-local Echo Request to the CE-Router.
# 	TN1 must reply to any Neighbor Solicitations from the CE-Router.

	vSend($Link, 'tn1_ereq_common');

# 3.
# 	Observe the packets transmitted by the CE-Router.

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_common));

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			$start = $ret{'recvTime'. $ret{'recvCount'}};
			vSend($Link, $tn1_mcast_nd_common{$frame});
			$tn1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
	unless($ret{'recvFrame'} eq 'tn1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 4.
# 	Repeat Step 2 every second for 40 seconds.

# 5.
# 	Observe the packets transmitted by the CE-Router.

	my @frames	= sort(keys(%tn1_ucast_nd_common));
	$bool		= $false;
	my $probe	= 0;
	my $got_ereq	= $false;

	for(my $d = 0; $d < 40; $d ++) {
		vSend($Link, 'tn1_ereq_common');
		$got_ereq = $false;
		%ret = vRecv($Link, $TimeOut,
			0, 0, 'tn1_erep_common', @frames);

		if($ret{'recvFrame'} eq 'tn1_erep_common') {
			$got_ereq	= $true;
			%ret = vRecv($Link, 1, 0, 0, @frames);
		}

		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				$bool = $true;
				$end = $ret{'recvTime'. $ret{'recvCount'}};
				vSend($Link, $tn1_ucast_nd_common{$frame});
				$tn1_cache = $true;
				
				# calculate the NS interval
				my $delay = $end - $start;
				vLogHTML("NS interval is $delay sec.<BR>");
				if (($delay < 10 ) || ($delay > 20)) {
					vLogHTML('<FONT COLOR="#FF0000">'.
					'invalid NS ReachableTime,should between 10 and 20 seconds'.
					'</FONT><BR>');
					return($false);
				}
				$start = $end;

				if (!$got_ereq) {
					%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
					if ($ret{'status'} != 0) {
					  vLogHTML('<FONT COLOR="#FF0000"><B>'.
					  'Could\'t observe Echo Reply'.
					  '</B></FONT><BR>');

					  return($false);
					}
				}
				last;
			}
		}

		
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');

		return($false);
	}
	$ret = v6LC_2_2_14_B($Link,$start);
	return $ret;
}



#------------------------------#
# v6LC_2_2_14_B()              #
#------------------------------#
sub
v6LC_2_2_14_B($$)
{
	my ($Link,$start) = @_;
	my $got_ereq	= $false;
	my $end;
	my $skip = 1;		# Since receive different RA, we skip checking first NS range
	vLogHTML("Send RA with reachable time of 40 seconds.<BR>");

# 6.
# 	TR1 transmits the Router Advertisement with a Reachable Time
# 	of 40 seconds.

	vSend($Link, 'local_ra_40');
	$tr1_default	= $true;
	$tr1_prefix	= $true;
	$tr1_force	= $true;

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_ucast_nd_common));

	vSend($Link, 'tn1_ereq_common');

	%ret = vRecv($Link, $TimeOut,0, 0, 'tn1_erep_common', @frames);
	if($ret{'recvFrame'} eq 'tn1_erep_common') {
		$got_ereq = $true;
	}
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			$start = $ret{'recvTime'. $ret{'recvCount'}};
			vSend($Link, $tn1_ucast_nd_common{$frame});
			$start = $ret{'recvTime'. $ret{'recvCount'}};
			$tn1_cache = $true;
			$skip = 0;
			if (!$got_ereq) {
				%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
				unless($ret{'recvFrame'} eq 'tn1_erep_common') {
					vLogHTML('<FONT COLOR="#FF0000"><B>'.
						'Could\'t observe Echo Reply'.
						'</B></FONT><BR>');
					return($false);
				}
			}
			last;
		}
	}


# 7.
# 	Repeat Step 2 every seconds for 140 seconds.

# 8.
# 	Observe the packets transmitted by the CE-Router.

	my @frames	= sort(keys(%tn1_ucast_nd_common));
	$bool		= $false;
	my $probe	= 0;

	for(my $d = 0; $d < 140; $d ++) {
		vSend($Link, 'tn1_ereq_common');
		$got_ereq = $false;
		%ret = vRecv($Link, $TimeOut,
			0, 0, 'tn1_erep_common', @frames);

		if($ret{'recvFrame'} eq 'tn1_erep_common') {
			$got_ereq	= $true;
			%ret = vRecv($Link, 1, 0, 0, @frames);
		}

		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				$bool = $true;
				$end = $ret{'recvTime'. $ret{'recvCount'}};
				vSend($Link, $tn1_ucast_nd_common{$frame});
				$tn1_cache = $true;
				
				if (!$skip) {
				  # calculate the NS interval
				  my $delay = $end - $start;
				  vLogHTML("NS interval is $delay sec.<BR>");
				  if (($delay < 25 ) || ($delay > 65)) {
					  vLogHTML('<FONT COLOR="#FF0000">'.
					  'invalid NS ReachableTime,should between 25 and 65 seconds'.
					  '</FONT><BR>');
					  return($false);
				  }
				  $skip = 0;
				}
				$start = $end;
				if (!$got_ereq) {
					%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
					if ($ret{'status'} != 0) {
						vLogHTML('<FONT COLOR="#FF0000"><B>'.
							'Could\'t observe Echo Reply'.
							'</B></FONT><BR>');

						return($false);
					}
				}
				last;
			}
		}



	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');

		return($false);
	}


	return($true);
}


#------------------------------#
# v6LC_2_2_14_C()              #
#------------------------------#
sub
v6LC_2_2_14_C($)
{
	my ($Link) = @_;

	$rut_rtadvd = $true;

	if (vRemote('racontrol.rmt', 'mode=start',
				"link0=$V6evalTool::NutDef{'Link0_device'}",
				"rltime=0",
				"rtime=10000"
				)) {

		vLogHTML('<FONT COLOR="#FF0000">racontrol.rmt: '.
				 'Can\'t enable RA function</FONT><BR>');

		return(-1);
	}

	$nut_rtime = $true;

# 10.
	vSend($Link, 'tn1_ereq_common');

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_common));

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn1_mcast_nd_common{$frame});
			$tn1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
	unless($ret{'recvFrame'} eq 'tn1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $reachable	= $ret{'recvTime'. $ret{'recvCount'}};

# 12.
# 	Repeat Step 10 every seconds for 40 seconds.

# 13.
# 	Observe the packets transmitted by the CE-Router.

	my @frames	= sort(keys(%tn1_ucast_nd_common));
	$bool		= $false;
	my $probe	= 0;
	my $got_ereq	= $false;

	for(my $d = 0; $d < 40; $d ++) {
		vSend($Link, 'tn1_ereq_common');

		%ret = vRecv($Link, $TimeOut,
			0, 0, 'tn1_erep_common', @frames);

		if($ret{'recvFrame'} eq 'tn1_erep_common') {
			$got_ereq	= $true;
			%ret = vRecv($Link, 1, 0, 0, @frames);
		}

		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				$bool = $true;
				$probe = $ret{'recvTime'. $ret{'recvCount'}};
				last;
			}
		}

		if($bool) {
			vRecv($Link,
				$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
				0, 0);

			last;
		}

		unless($got_ereq) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe Echo Reply'.
				'</B></FONT><BR>');

			return($false);
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');

		return($false);
	}

	my $delay = $probe - $DELAY_FIRST_PROBE_TIME;
	my $result = $delay - $reachable;

	vLogHTML("enter REACHABLE at $reachable sec.<BR>");
	vLogHTML("enter DELAY at $delay sec.<BR>");
	vLogHTML("enter PROBE at $probe sec.<BR>");
	vLogHTML("ReachableTime is $result sec.<BR>");

	if((5 >= $result) || (15 <= $result)) {
		vLogHTML('<FONT COLOR="#FF0000">'.
			'invalid ReachableTime'.
			'</FONT><BR>');

		return($false);
	}

	return($true);
}


#------------------------------#
# v6LC_2_2_15_A()              #
#------------------------------#
sub
v6LC_2_2_15_A($)
{
	my ($Link) = @_;

	my $tr2_linklocal="FE80::200:ff:fe00:a1a1";
	my $tr2_mac="00:00:00:00:a1:a1";
	vCPP("-D\'TR1_LINKLOCAL=\"$tr2_linklocal\"\' -D\'TR1_MAC_ADDR=ether(\"$tr2_mac\")\'");

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR2 transmits Router Advertisement A.

	vSend($Link, 'local_ra_update');
	$tr1_change_param	= $true;
	$tr1_force		= $true;
	$tr1_cache		= $true;

# 2.
# 	TR2 transmits an Echo Request to the CE-Router.

	vSend($Link, 'tr1_ereq_common');

# 3.
# 	Check the NCE of TR2 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

	return(is_tr1_stale($Link));
}



#------------------------------#
# v6LC_2_2_15_B()              #
#------------------------------#
sub
v6LC_2_2_15_B($)
{
	my ($Link) = @_;
	my $tr2_linklocal="FE80::200:ff:fe00:a1a1";
	my $tr2_mac="00:00:00:00:a1:a1";
	vCPP("-D\'TR1_LINKLOCAL=\"$tr2_linklocal\"\' -D\'TR1_MAC_ADDR=ether(\"$tr2_mac\")\'");

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 4.
# 	TR2 transmits Echo Request B.
# 	TR2 does not respond to any Neighbor Solicitations from the CE-Router.

# 5.
# 	Observe the packets transmitted by the CE-Router
# 	and check the NCE of TR2 on the CE-Router.

	unless(tr1_none_to_incomplete($Link)) {
		return($false);
	}

# 6.
# 	TR2 transmits Router Advertisement A.

	vSend($Link, 'local_ra_update');
	$tr1_change_param	= $true;
	$tr1_force		= $true;
	$tr1_cache		= $true;

# 7.
# 	Check the NCE of TR2 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

	return(is_tr1_stale($Link));
}



#------------------------------#
# v6LC_2_2_15_C()              #
#------------------------------#
sub
v6LC_2_2_15_C($)
{
	my ($Link) = @_;
	my $tr2_linklocal="FE80::200:ff:fe00:a1a1";
	my $tr2_mac="00:00:00:00:a1:a1";
	vCPP("-D\'TR1_LINKLOCAL=\"$tr2_linklocal\"\' -D\'TR1_MAC_ADDR=ether(\"$tr2_mac\")\'");
	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 8.
# 	TR2 transmits Echo Request B.
# 	TR2 does not respond to any Neighbor Solicitations from the CE-Router.

# 9.
# 	Observe the packets transmitted by the CE-Router
# 	and check the NCE of TR1 on the CE-Router.

# 10.
# 	TR2 transmits Neighbor Advertisement C.

# 11.
# 	Check the NCE of TR2 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

	unless(tr1_none_to_reachable($Link)) {
		return($false);
	}

# 12.
# 	TR1 transmits Router Advertisement A
# 	with a different Source Link-layer Address.

	vSend($Link, 'local_ra_update');
	$tr1_change_param	= $true;
	$tr1_force		= $true;
	$tr1_cache		= $true;

# 13.
# 	TR1 transmits an Echo Request to the CE-Router.

	vSend($Link, 'tr1_ereq_common');

# 14.
# 	Check the NCE of TR1 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

	return(is_tr1_stale_diff($Link));
}



#------------------------------#
# v6LC_2_2_15_D()              #
#------------------------------#
sub
v6LC_2_2_15_D($)
{
	my ($Link) = @_;
	my $tr2_linklocal="FE80::200:ff:fe00:a1a1";
	my $tr2_mac="00:00:00:00:a1:a1";
	vCPP("-D\'TR1_LINKLOCAL=\"$tr2_linklocal\"\' -D\'TR1_MAC_ADDR=ether(\"$tr2_mac\")\'");
	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 8.
# 	TR2 transmits Echo Request B.
# 	TR2 does not respond to any Neighbor Solicitations from the CE-Router.

# 9.
# 	Observe the packets transmitted by the CE-Router
# 	and check the NCE of TR1 on the CE-Router.

# 10.
# 	TR2 transmits Neighbor Advertisement C.

# 11.
# 	Check the NCE of TR2 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

	unless(tr1_none_to_reachable($Link)) {
		return($false);
	}

	$tr1_cache	= $true;

# 12.
# 	TR2 transmits Router Advertisement A
# 	with a different Source Link-layer Address.

	vSend($Link, 'local_ra_update');
	$tr1_change_param	= $true;
	$tr1_force		= $true;

# 13.
# 	TR2 transmits an Echo Request to the CE-Router.

	vSend($Link, 'tr1_ereq_common');

# 14.
# 	Check the NCE of TR1 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my @mframes	= sort(keys(%tr1_mcast_nd_common));
	my @uframes	= sort(keys(%tr1_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut,
		0, 0, @mframes, @uframes);
	foreach my $frame (@mframes) {
		if($ret{'recvFrame'} eq $frame) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'CE-Router is in INCOMPLETE'.
				'</B></FONT><BR>');

			vRecv($Link,
				$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
				0, 0);

			$tr1_cache	= $true;

			return($false);
		}
	}

	foreach my $frame (@uframes) {
		if($ret{'recvFrame'} eq $frame) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'CE-Router is in PROBE'.
				'</B></FONT><BR>');

			vRecv($Link,
				$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
				0, 0);

			$tr1_cache	= $true;

			return($false);
		}
	}

	return($true);
}



#------------------------------#
# v6LC_2_2_15_E()              #
#------------------------------#
sub
v6LC_2_2_15_E($)
{
	my ($Link) = @_;
	my $tr2_linklocal="FE80::200:ff:fe00:a1a1";
	my $tr2_mac="00:00:00:00:a1:a1";
	vCPP("-D\'TR1_LINKLOCAL=\"$tr2_linklocal\"\' -D\'TR1_MAC_ADDR=ether(\"$tr2_mac\")\'");

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 17.
# 	TR2 transmits Echo Request B.
# 	TR2 does not respond to any Neighbor Solicitations from the CE-Router.

# 18.
# 	Observe the packets transmitted by the CE-Router
# 	and check the NCE of TR1 on the CE-Router.

# 19.
# 	TR2 transmits Neighbor Advertisement C.

# 20.
# 	Check the NCE of TR2 on the CE-Router and observe the packets
# 	transmitted by the CE-Router.

# 21.
# 	Wait (REACHABLE_TIME * MAX_RANDOM_FACTOR) seconds.

# 22.
# 	TR2 transmits Echo Request B.

# 23.
# 	Check the NCE of TR2 on the CE-Router and observe the packets
# 	transmitted by the CE-Router.

# 24.
# 	Wait (DELAY_FIRST_PROBE_TIME) seconds.

# 25.
# 	Check the NCE of TR2 on the CE-Router and observe the packets
# 	transmitted by the CE-Router.

	unless(tr1_none_to_probe($Link)) {
		return($false);
	}

# 26.
# 	TR2 transmits Router Advertisement A
# 	with a different Source Link-layer Address.

	vSend($Link, 'local_ra_update');
	$tr1_change_param	= $true;
	$tr1_cache		= $true;
	$tr1_force		= $true;

# 27.
# 	TR2 transmits an Echo Request to the CE-Router.

	vSend($Link, 'tr1_ereq_common');

# 28.
# 	Check the NCE of TR2 on the CE-Router and observe the packets
# 	transmitted by the CE-Router.

	return(is_tr1_stale_diff($Link));
}



#------------------------------#
# v6LC_2_2_15_F()              #
#------------------------------#
sub
v6LC_2_2_15_F($)
{
	my ($Link) = @_;
	my $tr2_linklocal="FE80::200:ff:fe00:a1a1";
	my $tr2_mac="00:00:00:00:a1:a1";
	vCPP("-D\'TR1_LINKLOCAL=\"$tr2_linklocal\"\' -D\'TR1_MAC_ADDR=ether(\"$tr2_mac\")\'");

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 17.
# 	TR2 transmits Echo Request B.
# 	TR2 does not respond to any Neighbor Solicitations from the CE-Router.

# 18.
# 	Observe the packets transmitted by the CE-Router
# 	and check the NCE of TR1 on the CE-Router.

# 19.
# 	TR2 transmits Neighbor Advertisement C.

# 20.
# 	Check the NCE of TR2 on the CE-Router and observe the packets
# 	transmitted by the CE-Router.

# 21.
# 	Wait (REACHABLE_TIME * MAX_RANDOM_FACTOR) seconds.

# 22.
# 	TR2 transmits Echo Request B.

# 23.
# 	Check the NCE of TR2 on the CE-Router and observe the packets
# 	transmitted by the CE-Router.

# 24.
# 	Wait (DELAY_FIRST_PROBE_TIME) seconds.

# 25.
# 	Check the NCE of TR2 on the CE-Router and observe the packets
# 	transmitted by the CE-Router.

	unless(tr1_none_to_probe($Link)) {
		return($false);
	}

# 26.
# 	TR2 transmits Router Advertisement A
# 	with a different Source Link-layer Address.

	vSend($Link, 'local_ra_update');
	$tr1_change_param	= $true;
	$tr1_cache		= $true;
	$tr1_force		= $true;

# 27.
# 	TR2 transmits an Echo Request to the CE-Router.

# 28.
# 	Check the NCE of TR2 on the CE-Router and observe the packets
# 	transmitted by the CE-Router.

	my @frames = sort(keys(%tr1_ucast_nd_common));

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			vRecv($Link,
				$TimeOut * ($MAX_UNICAST_SOLICIT - 2),
				0, 0);

			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe NS'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# v6LC_2_2_16_I()              #
#------------------------------#
sub
v6LC_2_2_16_I($)
{
	my ($Link) = @_;
	my $tr2_linklocal="FE80::200:ff:fe00:a1a1";
	my $tr2_mac="00:00:00:00:a1:a1";
	vCPP("-D\'TR1_LINKLOCAL=\"$tr2_linklocal\"\' -D\'TR1_MAC_ADDR=ether(\"$tr2_mac\")\'");

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 35.
# 	TR2 transmits Echo Request B.
# 	TR2 does not respond to any Neighbor Solicitations from the CE-Router.

# 36.
# 	Observe the packets transmitted by the CE-Router
# 	and check the NCE of TR1 on the CE-Router.

# 37.
# 	TR2 transmits Neighbor Advertisement C.

# 38.
# 	Check the NCE of TR2 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

# 39.
# 	Wait (REACHABLE_TIME * MAX_RANDOM_FACTOR) seconds.

	unless(tr1_none_to_stale($Link)) {
		return($false);
	}

# 40.
# 	TR2 transmits Router Advertisement A
# 	with a different Source Link-layer Address.

	vSend($Link, 'local_ra_update');
	$tr1_change_param	= $true;
	$tr1_cache		= $true;
	$tr1_force		= $true;

# 41.
# 	TR2 transmits an Echo Request to the CE-Router.

	vSend($Link, 'tr1_ereq_common');

# 42.
# 	Check the NCE of TR2 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

	return(is_tr1_stale_diff($Link));
}



#------------------------------#
# v6LC_2_2_16_J()              #
#------------------------------#
sub
v6LC_2_2_16_J($)
{
	my ($Link) = @_;
	my $tr2_linklocal="FE80::200:ff:fe00:a1a1";
	my $tr2_mac="00:00:00:00:a1:a1";
	vCPP("-D\'TR1_LINKLOCAL=\"$tr2_linklocal\"\' -D\'TR1_MAC_ADDR=ether(\"$tr2_mac\")\'");

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 35.
# 	TR2 transmits Echo Request B.
# 	TR2 does not respond to any Neighbor Solicitations from the CE-Router.

# 36.
# 	Observe the packets transmitted by the CE-Router
# 	and check the NCE of TR1 on the CE-Router.

# 37.
# 	TR2 transmits Neighbor Advertisement C.

# 38.
# 	Check the NCE of TR2 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

# 39.
# 	Wait (REACHABLE_TIME * MAX_RANDOM_FACTOR) seconds.

	unless(tr1_none_to_stale($Link)) {
		return($false);
	}

# 40.
# 	TR2 transmits Router Advertisement A
# 	with a different Source Link-layer Address.

	vSend($Link, 'local_ra_update');
	$tr1_change_param	= $true;
	$tr1_cache		= $true;
	$tr1_force		= $true;

# 41.
# 	TR2 transmits an Echo Request to the CE-Router.

	vSend($Link, 'tr1_ereq_common');

# 42.
# 	Check the NCE of TR2 on the CE-Router
# 	and observe the packets transmitted by the CE-Router.

	return(is_tr1_stale($Link));
}



#------------------------------#
# v6LC_2_2_17_A_B()            #
#------------------------------#
sub
v6LC_2_2_17_A_B($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');
	#--------------#
	if ($STATEFUL_CLIENT) {
	  my ($ret,$tn1_prefix) = cpe_initialization_1_2('ra_MsetOset_local',$Link0,"",$STATEFUL_CLIENT,0);
	  if ($ret==1) {
	    vLogHTML('<FONT COLOR="#FF0000"><B>Fail to initialize CPE!</B></FONT><BR>');
	    return($false);
	  }
	}

	#--------------#
	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_mcast_ns_linklocal_common');
	unless($ret{'recvFrame'} eq 'tr1_mcast_ns_linklocal_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}


	$pktdesc{'local_tr1_na_linklocal'} =
		'    Send NA (rSO) w/ TLL: '.
		'TR1 (link-local) -&gt; NUT (link-local)';

	vSend($Link, 'local_tr1_na_linklocal');
	$tr1_cache = $true;

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}



	$tr1_default	= $true;
	$tr1_prefix	= $true;

	vSend($Link, 'local_ra');
	ignoreDAD($Link);


	vSleep(5);
	#--------------#
	vSend($Link, 'tn3_ereq_offlink_via_tr1');



	#--------------#
	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn3_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn3_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_2_17_C()              #
#------------------------------#
sub
v6LC_2_2_17_C($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	#--------------#
	if ($STATEFUL_CLIENT) {
    my ($ret,$param) = cpe_initialization_1_2('local_ra_m1',$Link0,"",$STATEFUL_CLIENT,0);
	  if ($ret==1) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Fail to initialize CPE!</B></FONT><BR>');
			return($false);
	  }
	}

	#--------------#
	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_mcast_ns_linklocal_common');
	unless($ret{'recvFrame'} eq 'tr1_mcast_ns_linklocal_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}


	$pktdesc{'local_tr1_na_linklocal'} =
		'    Send NA (rSO) w/ TLL: '.
		'TR1 (link-local) -&gt; NUT (link-local)';

	vSend($Link, 'local_tr1_na_linklocal');
	$tr1_cache = $true;

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}



  vSend($Link, 'local_ra');

	$tr1_default	= $true;
	$tr1_prefix	= $true;

	ignoreDAD($Link);



	#--------------#
	if ($STATEFUL_CLIENT) {
	  $pktdesc{'local_tn3_ereq_offlink_via_tr1_iana'} =
		  '    Send Echo Request via TR1: '.
		  'TN2 (global) -&gt; CE-Router (global)';

	  $pktdesc{'local_tn3_erep_offlink_via_tr1_iana'} =
		  '    Recv Echo Reply via TR1: CE-Router (global) -&gt; TN2 (global)';
	
	  vSend($Link, 'local_tn3_ereq_offlink_via_tr1_iana');



	  #--------------#
	  %ret = vRecv($Link, $TimeOut, 0, 0, 'local_tn3_erep_offlink_via_tr1_iana');
	  unless($ret{'recvFrame'} eq 'local_tn3_erep_offlink_via_tr1_iana') {
		  vLogHTML('<FONT COLOR="#FF0000"><B>'.
			  'Could\'t observe Echo Reply'.
			  '</B></FONT><BR>');
		  return($false);
	  }

	  return($true);
	} else {
	  $pktdesc{'local_tn3_ereq_offlink_via_tr1'} =
		  '    Send Echo Request via TR1: '.
		  'TN2 (global) -&gt; CE-Router (global)';

	  $pktdesc{'local_tn3_erep_offlink_via_tr1'} =
		  '    Recv Echo Reply via TR1: CE-Router (global) -&gt; TN2 (global)';
	
	  vSend($Link, 'local_tn3_ereq_offlink_via_tr1');



	  #--------------#
	  %ret = vRecv($Link, $TimeOut, 0, 0, 'local_tn3_erep_offlink_via_tr1');
	  unless($ret{'recvFrame'} eq 'local_tn3_erep_offlink_via_tr1') {
		  vLogHTML('<FONT COLOR="#FF0000"><B>'.
			  'Could\'t observe Echo Reply'.
			  '</B></FONT><BR>');
		  return($false);
	  }

	  return($true);
	}
}



#------------------------------#
# v6LC_2_2_18()                #
#------------------------------#
sub
v6LC_2_2_18($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');



	#--------------#
	vSend($Link, 'local_ra');

	$tr1_default	= $true;
	$tr1_prefix	= $true;
	$tr1_cache	= $true;

	ignoreDAD($Link);



	#--------------#
	$pktdesc{'local_tn3_ereq_offlink_via_tr1'} =
		'    Send Echo Request via TR1: '.
		'TN2 (global) -&gt; CE-Router (link-local)';

	$pktdesc{'local_tn3_erep_offlink_via_tr1'} =
		'    Recv Echo Reply via TR1: '.
		'CE-Router (link-local) -&gt; TN2 (global)';

	vSend($Link, 'local_tn3_ereq_offlink_via_tr1');



	#--------------#
	%ret = vRecv($Link, $TimeOut, 0, 0, 'local_tn3_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'local_tn3_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_2_19()                #
#------------------------------#
sub
v6LC_2_2_19($$)
{
	my ($Link,$stateful_addr) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	# 1.
	# 	TR1 transmits Router Advertisement A to the CE-Router.
	vClear($Link);
	if ($stateful_addr == 1) {
	  vSend($Link,'local_ra_m1');
	} else {
	  vSend($Link, 'local_ra');
	}
	ignoreDAD($Link);

	$force_reboot	= $false;

	# 2.
	# 	TN1 transmits Echo Request B to the CE-Router.
	vClear($Link);
	vSend($Link, 'local_ereq');

	# 3.
	# 	Observe the packets transmitted by the CE-Router.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'local_mcast_ns_sll');
	if($ret{'recvFrame'} ne 'local_mcast_ns_sll') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vClear($Link);
	vSend($Link, 'local_na');

	%ret = vRecv($Link, $TimeOut, 0, 0, 'local_erep');
	unless($ret{'recvFrame'} eq 'local_erep') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#--------------------------------------------------------------#
# vrfyRouterConfigurationVariables()                           #
#--------------------------------------------------------------#
sub
vrfyRouterConfigurationVariables()
{
	if(($min_MaxRtrAdvInterval < 4) || ($max_MaxRtrAdvInterval > 1800)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>MaxRtrAdvInterval '.
			'MUST be no less than 4 seconds and no greater than 1800 seconds.'.
			'</B></FONT><BR>');

		return($false);
	}

	if(($min_MinRtrAdvInterval < 3) ||
	   ($max_MinRtrAdvInterval > $max_MaxRtrAdvInterval * 0.75)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>MinRtrAdvInterval '.
			'MUST be no less than 3 seconds and no greater than '.
			'.75 * MaxRtrAdvInterval.</B></FONT><BR>');

		return($false);
	}

	if($max_AdvReachableTime > 3600000) {
		vLogHTML('<FONT COLOR="#FF0000"><B>AdvReachableTime '.
			'MUST be no greater than 3,600,000 milliseconds (1 hour).'.
			'</B></FONT><BR>');

		return($false);
	}

	if((($min_AdvDefaultLifetime > 0) &&
	    ($min_AdvDefaultLifetime < $min_MaxRtrAdvInterval)) ||
	   ($max_AdvDefaultLifetime > 9000)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>AdvDefaultLifetime '.
			'MUST be either zero or between MaxRtrAdvInterval and 9000 '.
			'seconds.</B></FONT><BR>');

		return($false);
	}

	if($max_AdvPreferredLifetime > $max_AdvValidLifetime) {
		vLogHTML('<FONT COLOR="#FF0000"><B>AdvPreferredLifetime '.
			'MUST NOT be larger than AdvValidLifetime.</B></FONT><BR>');

		return($false);
	}

	return($true);
}



1;
