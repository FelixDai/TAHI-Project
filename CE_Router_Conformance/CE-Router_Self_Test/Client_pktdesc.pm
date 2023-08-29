#!/usr/bin/perl
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
# $CHT-TL: Client_pktdesc.pm,v 1.13 2010/02/03 12:22:56 mario Exp $
#
# $CHT-TL: dhcpv6.p2/Client_pktdesc.pm,v 1.13 2010/02/03 12:22:56 mario Exp $
#
########################################################################

package Client_pktdesc;
use Exporter;
@ISA = qw(Exporter);

@EXPORT = qw(
	%pktdesc
);

#--------------------------------------------------------------#
# Packet Description
#--------------------------------------------------------------#
%pktdesc = (

	rs				=> '    Receive RS: NUT --> Multicast',
	rs_nut_to_server1		=> '    Receive RS: NUT --> SERVER1',
	dadns_nutga			=> '    Receive DAD NS: :: --> NUT (Addr by DHCP)',
	dadns_nut2ga			=> '    Receive DAD NS: :: --> NUT (Addr3 by DHCP)',
	dadna_to_nutga			=> '    Send DAD NA: SERVER1 --> Lnik-local Allnode Multicast Address',
	echorequest_server1_to_nut	=> '    Send Echo Request: SERVER1 --> NUT (Addr by DHCP)',
	echorequest_server1_to_nut_byra	=> '    Send Echo Request: SERVER1 --> NUT (Addr1 by RA)',
	echorequest_server1_to_nut_addr2=> '    Send Echo Request: SERVER1 --> NUT (Addr2 by RA, prefix is different)',
	echorequest_server1_to_nut1	=> '    Send Echo Request: SERVER1 --> NUT (Relay agent Link1 address)',
	echorequest_server2_to_nut1	=> '    Send Echo Request: SERVER2 --> NUT (Relay agent Link1 address)',
	echorequest_server1_to_nut2	=> '    Send Echo Request: SERVER1 --> NUT (Addr3 by DHCP)',
	echorequest_server2_to_nut2	=> '    Send Echo Request: SERVER2 --> NUT (Addr3 by DHCP)',
	echoreply_nut_to_server1	=> '    Receive Echo Reply: NUT (Addr) (by DHCP) --> SERVER1',
	echoreply_nut_byra_to_server1	=> '    Receive Echo Reply: NUT (Addr1 by RA) --> SERVER1',
	echoreply_nut_addr2_to_server1	=> '    Receive Echo Reply: NUT (Addr2 by RA) --> SERVER1',
	echoreply_nut1_to_server1	=> '    Receive Echo Reply: NUT (Relay agent Link1 address) --> SERVER1',
	echoreply_nut1_to_server2	=> '    Receive Echo Reply: NUT (Relay agent Link1 address) --> SERVER2',
	echoreply_nut2_to_server1	=> '    Receive Echo Reply: NUT (Addr3 by DHCP) --> SERVER1',
	echoreply_nut2_to_server2	=> '    Receive Echo Reply: NUT (Addr3 by DHCP) --> SERVER2',
	ra_server2_to_all		=> '	Send RA(M flag=1): ROUTER --> ALL',
	ra_server2_to_all_M_1_addr_assig => '    Send RA(M =1 with two prefix)  TR --> All',
	ra_server2_to_all_MO_1		=> '	Send RA(M & O flag=1): ROUTER --> ALL',
	ra_server2_to_all_M_0		=> '	Send RA(M flag=0): ROUTER --> ALL',
	ra_server2_to_all_MO_0		=> '	Send RA(M & O flag=0): ROUTER --> ALL',
	ra_server1_to_nut		=> '	Send RA: SERVER1 --> NUT',
	ra_server2_to_all_addr_assign   => '	Send RA(M flag=0, O flag=1): ROUTER --> ALL',
	ra_server2_to_all_addr_assign_O_0   => '	Send RA(M flag=0, O flag=0): ROUTER --> ALL',
	ns_nutga_to_any_server1ga	=> '    Receive NS: NUT (Addr by DHCP) --> SERVER1 (TGT: Global)',
	ns_nutga_byra_to_any_server1ga	=> '    Receive NS: NUT (Addr1 by RA) --> SERVER1 (TGT: Global)',
	ns_nutga_byra_to_any_server1lla	=> '    Receive NS: NUT (Addr1 by RA) --> SERVER1 (TGT: Link-local)',
	ns_nutga_addr2_to_any_server1ga	=> '    Receive NS: NUT (Addr2 by RA, prefix is different) --> SERVER1 (TGT: Global)',
	ns_nutga_addr2_to_any_server1lla=> '    Receive NS: NUT (Addr2 by RA, prefix is different) --> SERVER1 (TGT: Link-local)',
	ns_nut2ga_to_any_server1lla	=> '    Receive NS: NUT (Addr3 by DHCP) --> SERVER1 (TGT: Link-local)',
	ns_nutlla_to_any_server1lla	=> '    Receive NS: NUT (Link-local) --> SERVER1 (TGT: Link-local)',
	ns_nutlla_to_server1ga		=> '    Receive NS: NUT (Link-local) --> SERVER1 (Global)',
	na_server1ga_to_nutga		=> '    Send NA: SERVER1 (Global) --> NUT (Addr by DHCP)',
	na_server1ga_to_nutga_byra	=> '    Send NA: SERVER1 (Global) --> NUT (Addr1 by RA)',
	na_server1ga_to_nutga_byra_lla	=> '    Send NA: SERVER1 (Global) --> NUT (Addr1 by RA, TGT: Link-local)',
	na_server1ga_to_nutga_addr2	=> '    Send NA: SERVER1 (Global) --> NUT (Addr2 by RA, prefix is different)',
	na_server1ga_to_nutga_addr2_lla => '    Send NA: SERVER1 (Global) --> NUT (Addr2 by RA, TGT: Link-local)',
	na_server1_to_nut		=> '    Send NA: SERVER1 (Link-local) --> NUT (Link-local)',
	na_server1_global_to_nut	=> '    Send NA: SERVER1 (Global) --> NUT (Link-local)',

	ns_nut_to_DNS			=> '    Receive NS: NUT --> DNS Server',
	ns_nut_dhcp_to_dns			=> '    Receive NS: NUT --> DNS Server',
	na_dns_to_nut			=> '    Send NA: DNS Server --> NUT',
	na_dns_to_nut_dhcp			=> '    Send NA: DNS Server --> NUT',
	dns_squery			=> '    Receive DNS SQUERY: NUT --> DNS Server',
	nut_dhcp_dns_squery		=> '    Receive DNS SQUERY: NUT --> DNS Server',

	na_client0_to_nut		=> '    Send NA: CLIENT0 --> NUT',
	na_relay0_0_to_nut		=> '    Send NA: RELAY0(Link0) --> NUT',

	advertise_server1_to_all	=> '    Send DHCPv6 Advertise Message: SERVER1 --> multicast',
	advertise_server1_to_nut		=> '    Send DHCPv6 Advertise Message: SERVER1 --> NUT',
	advertise_server1_to_nut_invalid_udp	=> '    Send DHCPv6 Advertise Message: SERVER1 --> NUT (Invalid UDP Port)',
	advertise_server1_to_nut_invalid_udp_2	=> '    Send DHCPv6 Advertise Message: SERVER1 --> NUT (Invalid UDP Port)',
	
	reply_server1_to_all			=> '    Send DHCPv6 Reply Message: SERVER1 --> multicast',
	reply_server1_to_nut			=> '    Send DHCPv6 Reply Message: SERVER1 --> NUT',
	reply_server1_to_nut_invalid_udp	=> '    Send DHCPv6 Reply Message: SERVER1 --> NUT (Invalid UDP Port)',

	solicit_client1_to_alldhcp_invalid	=> '    Send DHCPv6 Solicit Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	request_client1_to_alldhcp_invalid	=> '    Send DHCPv6 Request Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	confirm_client1_to_alldhcp_invalid	=> '    Send DHCPv6 Confrim Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	renew_client1_to_alldhcp_invalid	=> '    Send DHCPv6 Renew Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	rebind_client1_to_alldhcp_invalid	=> '    Send DHCPv6 Rebind Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	decline_client1_to_alldhcp_invalid	=> '    Send DHCPv6 Decline Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	release_client1_to_alldhcp_invalid	=> '    Send DHCPv6 Release Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	relayforward_solicit_client1_to_alldhcp_invalid	=> '    Send DHCPv6 Relay-forward Message (Solicit): RELAY1 --> All DHCP Servers',
	relay_reply_server1_to_client1_1relay_invalid	=> '    Send DHCPv6 Relay-reply Message (Reply): SERVER1 --> NUT',
	information_request_client1_to_alldhcp_invalid	=> '    Send DHCPv6 Information-Request Message: CLIENT1 --> All DHCP Servers and Relay Agents',

	solicit_client1_to_alldhcp		=> '    Send DHCPv6 Solicit Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	request_client1_to_alldhcp		=> '    Send DHCPv6 Request Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	confirm_client1_to_alldhcp		=> '    Send DHCPv6 Confirm Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	renew_client1_to_alldhcp		=> '    Send DHCPv6 Renew Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	rebind_client1_to_alldhcp		=> '    Send DHCPv6 Rebind Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	decline_client1_to_alldhcp		=> '    Send DHCPv6 Decline Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	release_client1_to_alldhcp		=> '    Send DHCPv6 Release Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	information_request_client1_to_alldhcp	=> '    Send DHCPv6 Information-Request Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	relayforward_solicit_client1_to_alldhcp	=> '    Send DHCPv6 Relay-forward Message (Solicit): RELAY1 --> All DHCP Servers',
	relay_reply_server1_to_client1_1relay	=> '    Send DHCPv6 Relay-reply Message (Reply): SERVER1 --> NUT',

	reconfigure_server1_to_all			=> '    Send DHCPv6 Reconfigure Message: SERVER1 --> multicast',
	reconfigure_server1_to_nut			=> '    Send DHCPv6 Reconfigure Message: SERVER1 --> NUT',
	
	dhcp6_solicit_nut_to_alldhcp			=> '	Receive DHCPv6 Solicit Message: NUT --> All DHCP Servers and Relay Agents',
	dhcp6_solicit_nut_to_server1			=> '	Receive DHCPv6 Solicit Message: NUT --> SERVER1',
	
	dhcp6_request_nut_to_alldhcp				=> '    Receive DHCPv6 Request Message: NUT --> All DHCP Servers and Relay Agents',
	dhcp6_request_nut_to_server1				=> '    Receive DHCPv6 Request Message: NUT --> SERVER1',
	
	dhcp6_renew_nut_to_alldhcp			=> '    Receive DHCPv6 Renew Message: CLIENT0 --> All DHCP Servers and Relay Agents',
	dhcp6_renew_nut_to_nut				=> '    Receive DHCPv6 Renew Message: CLIENT0 --> NUT',
	
	dhcp6_rebind_nut_to_alldhcp				=> '    Receive DHCPv6 Rebind Message: NUT --> All DHCP Servers and Relay Agents',
	dhcp6_rebind_nut_to_server1				=> '    Receive DHCPv6 Rebind Message: NUT --> SERVER1',
	
	dhcp6_confirm_nut_to_alldhcp				=> '    Receive DHCPv6 Confirm Message: NUT --> All DHCP Servers and Relay Agents',
	dhcp6_confirm_nut_to_server1				=> '    Receive DHCPv6 Confirm Message: NUT --> SERVER1',
	
	release_nut_to_alldhcp				=> '    Receive DHCPv6 Release Message: NUT --> All DHCP Servers and Relay Agents',
	release_nut_to_server1				=> '    Receive DHCPv6 Release Message: NUT --> SERVER1',

	dhcp6_solicit				=> '	Receive DHCPv6 Solicit Message',
	dhcp6_request				=> '	Receive DHCPv6 Request Message',
	dhcp6_decline				=> '    Receive DHCPv6 Decline Message',
	dhcp6_confirm				=> '    Receive DHCPv6 Confirm Message',
	dhcp6_renew				=> '    Receive DHCPv6 Renew Message',
	dhcp6_rebind				=> '    Receive DHCPv6 Rebind Message',
	dhcp6_release				=> '    Receive DHCPv6 Release Message',
	dhcp6_information_request 		=> '    Receive DHCPv6 Information-Request Message',

	dst_unreach				=> '    Receive ICMP Error Message (Destination Unreachable)', 

        #--- Cleanup for Host
        'cleanup_ra'                    => 'Send Router Advertisement (any Lifetimes set to 0)',
        'cleanup_na'                    => 'Send Neighbor Advertisement (Link-Local Address with Different Link-layer Address)',
        'cleanup_na_g'                  => 'Send Neighbor Advertisement (Global address with Different Link-layer Address)',
        'cleanup_echo_request'          => 'Send Echo Request',
        'cleanup_echo_request_g'        => 'Send Echo Request (Global)',

);
