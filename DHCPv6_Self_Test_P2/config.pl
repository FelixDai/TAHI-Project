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
# $TAHI: dhcpv6.p2/config.pl,v 1.1 2010/03/30 10:29:49 mario Exp $
########################################################################

#----------------------------------------------------------------------#
#                                                                      #
# Configure the advanced functionalities support                       #
#                                                                      #
#----------------------------------------------------------------------#
#----------------------------------------------------------------------#
# Following is three main Advanced functionalities of DHCPv6 Logo      #
#----------------------------------------------------------------------#

#
# RFC 3315: Dynamic Host Configuration Protocol for IPv6 (DHCPv6)
#
# support addrss assignment in RFC 3315
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$Address_assignment	= 1;


#
# RFC 3633: IPv6 Prefix Options for Dynamic Host Configuration Protocol
#           (DHCP) version 6
#
# support IPv6 prefix options
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$Prefix_Delegation	= 1;


#
# RFC 3646: DNS Configuration options for Dynamic Host Configuration
#           Protocol for IPv6 (DHCPv6)
#
# support DNS configuration options
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$DNS_configuration	= 1;


#
# RFC 3736: Stateless Dynamic Host Configuration Protocol (DHCP) Service
#           for IPv6
#
# support stateless DHCPv6
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$Stateless_DHCPv6	= 1;


#----------------------------------------------------------------------#
# Following is necessary configuration of DHCPv6 Logo test             #
#----------------------------------------------------------------------#

#
# DUID configuration (for Clinet, Server and Relay agent)
# It is required to select one DUID type from following.
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$Support_DUID_LLT	= 1;
$Support_DUID_EN	= 0;
$Support_DUID_LL	= 0;

#
# Initial RA configuration (for Clinet and Server)
#     zero     - TR doesn't send a RA 
#     non-zero - TR sends a RA w/ or w/o M and/or O bit for initialization of NUT
#
$Send_Initial_RA	= 1;


#
# Send Packet configuration (for Server)
# When TN sends DHCPv6 message to unicast address, it is required to select one of the two packets from following. 
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$Support_Listen_LLA	= 1;
$Support_Listen_GA	= 0;

#------- cleanup
$Cleanup        = "normal";     # Common Cleanup Procedure.
                                # Available actions are:
                                #   normal: (UNTER CONSTRUCTION)
                                #     (1) send RA with Router/Prefix Life Time
                                #         set to zero.
                                #     (2) send NA with SLL containing
                                #         a different cached address.
                                #     (3) Transmit Echo Request.
                                #         (never respond to NS)
                                #   reboot:
                                #     (1) reboot target.
                                #     (2) sleep $sleep_after_reboot
                                #   nothing:
                                #       do nothing.
                                #       (only sleep $cleanup_interval)

$Wait_Incomplete        = 10;   # wait for Target Neighbor Node Cache state
                                # transit to INCOMPLETE.
                                # default: 10[sec]
                                # note: this is only used in cleanup "normal".
                                #       DELAY_FIRST_PROBE_TIME = 5 [sec],
                                #       RETRANS_TIMER = 1,000[msec],
                                #       MAX_UNICAST_SOLICIT = 3,
                                #       5 + 1.000 * 3 = 8[sec]

$Wait_Rebootcmd         = 300;  # maximum waiting time for putting reboot
                                # command to NUT
                                #
                                # *if you specify SystemType as manual in 
                                # nut.def, you DO NOT NEED to care about this.
                                # (300[sec])

$Sleep_After_Reboot     = 10;   # sleep time after reboot.
                                # default: 10[sec]
                                # note: this is used not only in cleanup,
                                #       but also in Initialization(v6LC.1.0.0)

$Cleanup_Interval       = 5;    # sleep time in cleanup "nothing" procedure.
                                # default: 5[sec]

#----------------------------------------------------------------------#
# Following is optional configuration of DHCPv6 Logo test              #
#----------------------------------------------------------------------#
#You may want to config the transmission and retransmission parameters.
#If you want to modify these parameters, 
#you could config in DHCPv6_common.pm("#RFC3315 recommanded constants" part ) file. 
#But we strongly recommend that you don't modify this part.
#While in this test, you should use the default values in RFC3315.

return 1;
