#!/usr/bin/perl -w
#
# Copyright (C) 2013
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
# $CHT-TL: rdisc.pm,v 1.0 2013/08/19 weifen Exp $
#
########################################################################

package rdisc;

use Exporter;
use common;

BEGIN{
	$V6evalTool::TestVersion = '$Name: CE-Router_Self_Test_1_0_5 $';
}


@ISA = qw(Exporter);

@EXPORT = qw(
	v6LC_2_2_4
	v6LC_2_2_5
	v6LC_2_2_9_A
	v6LC_2_2_9_B
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
$pktdesc{'ns_dad'} =
        '    Recv NS: CE-Router (unspecified) -&gt; CE-Router solicited-node multicast address (link-local)';

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
# 	TN2 transmits a Router Solicitation with an IPv6 Hop Limit of 254.
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
# 	TN2 transmits a valid Router Solicitation.

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
# 	TN2 transmits Router Solicitation A twice, 3 seconds apart.
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
# 	TN2 transmits Router Solicitation B twice, 2 seconds apart.
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
