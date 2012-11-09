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
# $Id: DHCPv6_config.pm,v 1.5 2010/03/30 07:49:57 mario Exp $
# 
# $TAHI: dhcpv6.p2/DHCPv6_config.pm,v 1.5 2010/03/30 07:49:57 mario Exp $
#
########################################################################

package DHCPv6_config;
require 'config.pl';

################################################################
# BEGIN                                                        #
################################################################
BEGIN {
        use Exporter;
        use vars qw(@ISA @EXPORT);
        @ISA    = qw(Exporter);
        @EXPORT = qw(
		     $INITIAL_RA
		     $RA_BEFORE_PING
		     $LISTEN_UDPPORT_CLT
		     $LISTEN_UDPPORT_SVRRELAY
		     $LISTEN_LLA
		     $LISTEN_GA
		     $CLEANUP
		     $WAIT_INCOMPLETE
		     $WAIT_REBOOTCMD
		     $SLEEP_AFTER_REBOOT
		     $CLEANUP_INTERVAL
		    );
	generate;
}

################################################################
# END                                                          #
################################################################
END {

}

sub generate();
sub
generate()
{
	open DEF, "> DHCPv6_test_pkt.def";
	close DEF; 
	vCPP();
}


#UDP port 
$LISTEN_UDPPORT_CLT = 546;
$LISTEN_UDPPORT_SVRRELAY = 547;

#send RA before ping 
$INITIAL_RA = $Send_Initial_RA;
$RA_BEFORE_PING = 0;

#send DHCPv6 message to unicast address
$LISTEN_LLA	= $Support_Listen_LLA; 
$LISTEN_GA	= $Support_Listen_GA; 
################################################################
# Please change the following parameters                       #
################################################################
#DUID's type
$DUID_LLT	= $Support_DUID_LLT;
$DUID_EN	= $Support_DUID_EN;
$DUID_LL	= $Support_DUID_LL;

#Support Prefix Delegation option
$PD		= 0;

#Support IA_NA option, DNS option , Stateless DHCP
$ADDRASSIGN 	= $Address_assignment;
$PREFIX_DELEGATION	= $Prefix_Delegation;
$DNS 		= $DNS_configuration;
$STATELESSDHCP	= $Stateless_DHCPv6;

#Other configuration
$MIA		= 1;
$MIAAddress	= 1;
$MServer        = 1;

#Support Authentication or not
$AUTHENTICATION	= 0;

#Support Reconfigure Key Authentication Protocol or not
$RECONFIGURE_AUTH = 0;

#Shared Secret Key type
# default is ascii
$SHARED_SECRET_KEY_TYPE	= 'MIME64';

$CLEANUP        = $Cleanup;
$WAIT_INCOMPLETE        = $Wait_Incomplete;
$WAIT_REBOOTCMD         = $Wait_Rebootcmd;
$SLEEP_AFTER_REBOOT     = $Sleep_After_Reboot;
$CLEANUP_INTERVAL       = $Cleanup_Interval;


return 1;
