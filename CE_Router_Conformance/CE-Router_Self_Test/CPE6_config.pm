#!/usr/bin/perl
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
# $CHT-TL: CPE6_config.pm, v 1.3 2017/04/17 weifen $
#
################################################################

package CPE6_config;

use V6evalTool;
require '../config.pl';

################################################################
# BEGIN                                                        #
################################################################
BEGIN {
        require Exporter;
        use vars qw(@ISA @EXPORT);
        our @ISA    = qw(Exporter);
        our @EXPORT = qw(
		     $PING
		     $MTU
		     $STATEFUL_CLIENT
		     $INIT_RS_NUM
		     $GLOBAL_ADDR_SLAAC
		     $HINT
		     $DHCP_CONFIRM
		     $DHCP_RELEASE
		     $DHCP_DNSSL
		     $ULA
		     $RA_TRIGGER_DHCPv6
		     $DUID_LLT
		     $DUID_EN
		     $DUID_LL
		     $STATEFUL_SERVER
		     $LISTEN_UDPPORT_CLT
		     $LISTEN_UDPPORT_SVRRELAY
		     $WAIT_LAN_RA
		     $NEED_WAN_UP
		     $EROUTER
			 $Buff_time
		      

		     $wait_addrconf_base
		     $RetransTimerSec
		     $DupAddrDetectTransmits
		    );
}

################################################################
# END                                                          #
################################################################
END {

}

#-------------------------------------------------------------#
# global constants
#-------------------------------------------------------------#
$MAX_RTR_SOLICITATION_DELAY = 1;
$DupAddrDetectTransmits = 1;
$RETRANS_TIMER = 1;
$TimeOut = $RETRANS_TIMER + 1;

#DHCPv6 UDP port 
$LISTEN_UDPPORT_CLT = 546;
$LISTEN_UDPPORT_SVRRELAY = 547;

#
# the time for actually address assignment after ending DAD
# default: 5 sec
#
$wait_addrconf_base = $rs_time;

#
# the time between retransmit of NS
# default: 1sec
#
$RetransTimerSec = 1;

#
# how many times the target sends DAD NS packets
# default: 1 time
#
$DupAddrDetectTransmits = 1;

#
# Allowed buffer time for packet to deliver from hardware to OS
# default: 0.3
#
$Buff_time = 0.3;
#-------------------------------------------------------------#
# read from config.pl
#-------------------------------------------------------------#
$PING = $Support_Ping;
$MTU = $Support_mtu;
# $STATEFUL_CLIENT = $Stateful_Client;
# Use IA_NA for CE WAN global address
$STATEFUL_CLIENT = 1;
$INIT_RS_NUM = $Init_RS_Num;
$GLOBAL_ADDR_SLAAC = $Support_global_addr_SLAAC;

#DUCHv6 parameters
$RA_TRIGGER_DHCPv6 = $RA_trigger_DHCPv6;

#DHCPv6 Client DUID's type
$DUID_LLT	= $Support_DUID_LLT;
$DUID_EN	= $Support_DUID_EN;
$DUID_LL	= $Support_DUID_LL;
$DHCP_CONFIRM = $Support_Confirm;
$DHCP_RELEASE = $Support_Release;
$HINT = $Support_Hint;
$DHCP_DNSSL = $Support_DNSSL;

$ULA = $Support_ULA;
$STATEFUL_SERVER = $Stateful_Server;
$WAIT_LAN_RA = $wait_lan_ra;
$NEED_WAN_UP = $need_wan_up_first;
$EROUTER = $ERouter;
return 1;
