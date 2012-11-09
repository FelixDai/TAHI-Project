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
# $Id: debug.pl,v 1.5 2009/08/31 07:06:26 doo Exp $
#
################################################################


$ikev2_debug_ipv4 = 0;

$ikev2_optimize_initialization	= 0;

$ikev2_debug_send_create_child_sa_with_ke	= 0;

unless ($ikev2_debug_ipv4) {
	return(1);
}



# Link A:
#     Common Topology for End-Node: End-Node vs. End-Node
#     Common Topology for End-Node: End-Node vs. SGW
#     Common Topology for SGW: SGW vs. SGW
#     Common Topology for SGW: SGW vs. End-Node
$ikev2_prefixA	= '192.168.0';


# Link B:
#     Common Topology for SGW: SGW vs. SGW
#     Common Topology for SGW: SGW vs. End-Node
$ikev2_prefixB	= '192.168.1';



# Link X:
#     Common Topology for End-Node: End-Node vs. End-Node
#     Common Topology for End-Node: End-Node vs. SGW
#     Common Topology for SGW: SGW vs. SGW
#     Common Topology for SGW: SGW vs. End-Node
$ikev2_prefixX	= '192.168.2';



# Link Y:
#     Common Topology for End-Node: End-Node vs. SGW
#     Common Topology for SGW: SGW vs. SGW
$ikev2_prefixY	= '192.168.3';



# Link A: Common Topology for End-Node: End-Node vs. End-Node
# Link A: Common Topology for End-Node: End-Node vs. SGW
# Link A: Common Topology for SGW: SGW vs. SGW
# Link A: Common Topology for SGW: SGW vs. End-Node
$ikev2_global_addr_nut_link0	= $ikev2_prefixA. '.123';



# Link B: Common Topology for SGW: SGW vs. SGW
# Link B: Common Topology for SGW: SGW vs. End-Node
#$ikev2_global_addr_nut_link1	= $ikev2_prefixB. '.123';



# Link A: Common Topology for End-Node: End-Node vs. End-Node
# Link A: Common Topology for End-Node: End-Node vs. SGW
# Link B: Common Topology for SGW: SGW vs. SGW
# Link B: Common Topology for SGW: SGW vs. End-Node
# NUT is End-Node
$ikev2_link_local_addr_router_link0	= '192.168.0.15';

# NUT is SGW
#$ikev2_link_local_addr_router_link0	= '192.168.1.15';

1;
