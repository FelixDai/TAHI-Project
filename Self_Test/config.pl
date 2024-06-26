#!/usr/bin/perl
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
# $TAHI: ct/config.pl,v 1.3 2010/03/26 05:00:32 akisada Exp $
#
########################################################################

#----------------------------------------------------------------------#
#                                                                      #
# Configure the advanced functionalities support                       #
#                                                                      #
#----------------------------------------------------------------------#

#
# The support of transmitting Echo Requests and configuring packet size
#     v6LC.2.2.25, v6LC.4.1.10, v6LC.4.1.11, v6LC.5.1.1
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$TRANSMITTING_EREQ		= 1;

#
# The support of multicast routing
#     v6LC.1.1.10 H, I, J, K
#     v6LC.1.2.7 G, H
#     v6LC.5.1.4 B
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$MULTICAST_ROUTING		= 1;

#
# The support of link MTU configuration
#     v6LC.5.1.4, v6LC.5.1.11 B, v6LC.5.1.12 B, v6LC.5.1.13 B
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$MTU_CONFIGURATION		= 1;

#
# The support of Hop-by-hop option process
#     v6LC.1.2.6 & v6LC.1.2.7
#     zero     - NUT does not support
#     non-zero - NUT supports
#
$PROCESS_HBH                    = 1;

#
# The support of sending more than three RSs
#     v6LC.2.2.1
#     zero     - NUT does not support
#     non-zero - NUT supports
#
$SENDING_MORE_RSs               = 1;

#
# The support of sending only one RS
#     v6LC.2.2.2
#     zero     - NUT does not support
#     non-zero - NUT supports
#
$SENDING_ONE_RS                = 0;
#
# The support of Type C host
#     v6LC.2.2.23
#     zero     - NUT does not support
#     non-zero - NUT supports
#
$TYPE_C_HOST                    = 1;
#
# support to process Beyond Scope of Source Address
#     v6LC.5.1.3.E
#     zero     - NUT does not support
#     non-zero - NUT supports
#
$BEYOND_SCOPE_SADDR              = 1;
# 
# support to detect the duplicate fragments
#     v6LC.1.2.5.C & G
#     zero     - NUT does not support
#     non-zero - NUT supports
# 
$DETECT_DUPLICATE_FRAGS         = 1;
#
# support to track the connection for ICMPv6
#     v6LC.4.1.12
#     zero     - NUT does not support
#     non-zero - NUT supports
#
$PROCESS_RA_DNS			= 1;
#
# support to process RA DNS (host only)
#     v6LC.2.2.25
#     zero     - NUT does not support
#     non-zero - NUT supports
#

$ICMPv6_CONNET_TRACKING           = 1;


#----------------------------------------------------------------------#
#                                                                      #
# Configure target environment                                         #
#                                                                      #
#----------------------------------------------------------------------#

#
# The support of multiple physical network interfaces
#     zero     - one physical interface router
#     non-zero - generic router which has multiple interfaces
#
$HAS_MULTIPLE_INTERFACES	= 1;



1;
