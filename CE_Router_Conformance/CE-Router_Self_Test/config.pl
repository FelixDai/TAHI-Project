#!/usr/bin/perl
#
# Copyright (C) 2013, 2014, 2015, 2016
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
# $CHT-TL: config.pl, v 1.4 2016/01/20 weifen Exp $
########################################################################

# ****************************************************** #
# Basic Functions                                     #
# ****************************************************** #

# ====================================================== #
# WAN
# ====================================================== #
# Number of RS transmitted when initializing (Needed by CERouter 1.3.8)
#     zero     - only one RS
#     non-zero - more then one RS
$Init_RS_Num = 1;

#
# Need RA to trigger DHCPv6 Client
#     zero     - DHCPv6 Client sends Solicit packet automatically after initialization
#     non-zero - Needs RA to trigger DHCPv6 Client sending DHCPv6 Solicit packet
#
$RA_trigger_DHCPv6	= 1;

# DUID configuration (for Clinet)
# It is required to select one DUID type from following.
#     zero     - NUT does not support 
#     non-zero - NUT supports
#
$Support_DUID_LLT	= 0;
$Support_DUID_EN	= 0;
$Support_DUID_LL	= 1;

# ====================================================== #
# LAN
# ====================================================== #
# Support Stateful/Stateless DHCPv6 server on LAN side
#     0	- Only Stateless DHCPv6 server
#     1 - Only Stateful DHCPv6 server
#     2 - Both Stateful and Stateless DHCPv6 server
$Stateful_Server = 2;

#----------------------------------------------------------------------#
#                                                                      #
# implementation depend condition                                      #
#                                                                      #
#----------------------------------------------------------------------#

#
# Time between finishing DHCPv6 process on CE Router WAN side and 
# CE Router can provide prefix generated from DHCPv6_PD in RA
#
#     default: 6[sec]
#
$wait_lan_ra = 6;

#
# This flag is ONLY needed for LAN RFC 4862 
# CE Router initialize LAN interface with concerning WAN interface status or not
#	zero - CE Router initialize LAN interface without concerning WAN interface status.
#	non-zero - CE Router initialize LAN interface after WAN gets global address.
#
$need_wan_up_first = 0;

# ===================================================================================== #
# ===================================================================================== #
# ===================================================================================== #

# ****************************************************** #
# Advanced Functions                                     #
# ****************************************************** #

# ====================================================== #
# General
# ====================================================== #
# Support transmitting echo-request function
#     zero     - not support
#     non-zero - support
$Support_Ping = 0;

# Support mtu configuration
#     zero     - WAN does not support changing MTU value
#     non-zero - WAN supports changing MTU from the received MTU option in RA
$Support_mtu = 0;

# ERouter
#     zero     - This target device is not ERouter
#     non-zero - This target device is ERouter
$ERouter = 0;
# ====================================================== #
# WAN
# ====================================================== #
# CE WAN IPv6 addess mode (Needed by WAN_RFC4862 global address test cases)
#     zero     - WAN global address only generate from DHCPv6 IA_NA
#     non-zero - WAN global address support SLAAC 
$Support_global_addr_SLAAC = 0;

# Support DHCPv6 prefix size from hint
#     zero     - not support
#     non-zero - support
$Support_Hint = 0;

# Support Confirm Message
#     zero     - not support
#     non-zero - support
$Support_Confirm = 0;

# Support Release Message
#     zero     - not support
#     non-zero - support
$Support_Release = 0;

# Support DNS Search List option on CE WAN side
#     zero     - not support
#     non-zero - support
$Support_DNSSL = 0;

# ====================================================== #
# LAN
# ====================================================== #
# Support ULA
#     zero     - not support
#     non-zero - support
$Support_ULA = 0;

return 1;
