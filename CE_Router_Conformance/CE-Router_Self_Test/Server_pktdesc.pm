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
# $CHT-TL: Server_pktdesc.pm,v 1.11 2009/12/03 06:03:10 akisada Exp $
#
# $CHT-TL: dhcpv6.p2/Server_pktdesc.pm,v 1.11 2009/12/03 06:03:10 akisada Exp $
#
########################################################################

package Server_pktdesc;
use Exporter;
@ISA = qw(Exporter);

@EXPORT = qw(
	%pktdesc
);

#--------------------------------------------------------------#
# Packet Description
#--------------------------------------------------------------#
%pktdesc = (
	na_client1_to_nut_local				=> '    Send NA: CLIENT1(Link-local) --> NUT(Link-local)',
	na_client1_to_nut_global			=> '    Send NA: CLIENT1(Global) --> NUT(Global)',
	na_client2_to_nut_local				=> '    Send NA: CLIENT2(Link-local) --> NUT(Link-local)',
	na_server1_to_nut				=> '    Send NA: SERVER1(Link-local) --> NUT(Link-local)',
	na_server1_global_to_nut			=> '    Send NA: SERVER1(Global) --> NUT(Link-local)',
	na_relay2_to_nut				=> '    Send NA  Relay2 --> NUT',
	na_relay1_0_to_nut				=> '    Send NA  Relay1(link0) -->NUT',
	na_relay1_0_global_to_nut_global		=> '    Send NA  Relay1(link0) -->NUT',
	na_relay2_0_global_to_nut_global		=> '    Send NA  Relay2(link0) -->NUT',
	na_relay2_0_to_nut				=> '    Send NA  Relay2(link0) -->NUT',

	ns_nutlla_to_server1ga				=> '    Receive NS NUT(Link-local) --> SERVER(Global)',
	ns_nutlla_to_any_client1_lla			=> '    Receive NS NUT --> Client1(Link-local)',
	ns_nutlla_to_any_client2_lla			=> '    Receive NS NUT --> Client2(Link-local)',
	ns_nut_to_any_global				=> '    Receive NS NUT --> Any',
	ns_nut_to_relay1_0				=> '    Receive NS NUT --> Relay1(link0)',
	ns_nut_to_relay1_0_global			=> '    Receive NS NUT --> Relay1(link0)',
	ns_nut_global_to_relay1_0_global		=> '    Receive NS NUT --> Relay1(link0)',
	ns_nut_global_to_relay2_0_global		=> '    Receive NS NUT --> Relay2(link0)',
	ns_nut_to_relay2_0				=> '    Receive NS NUT --> Relay2(link0)',
	ns_nut_to_relay2_0_global			=> '    Receive NS NUT --> Relay2(link0)',
	ns_nutserver_to_any				=> '    Receive NS NUT(Server) --> Any',
	ns_nutrelay_to_client				=> '    Receive NS NUT(Relay) --> Client',
	ns_nutrelay_to_client_local			=> '    Receive NS NUT(Relay) --> Client(Link-local)',
	ns_nutrelay_to_server				=> '    Receive NS NUT(Relay) --> Server',
	ns_nutrelay_to_relay				=> '    Receive NS NUT(Relay) --> Relay2',

	ra_server2_to_all_MO_1				=> '    Send RA(M O = 1)  TR --> All',
	ra_server2_to_all_addr_assign			=> '    Send RA(O =1)  TR --> All',
	ra_server2_to_all_MO_0_all_addr_assign		=> '    Send RA(M O = 0)  TR --> All',
	dadns_nutga					=> '    Receive DAD NS: NUT --> ',
	
	advertise_nut_to_client1			=> '    Receive DHCPv6 Advertise Message: NUT --> CLIENT1',
	dhcp6_advertise					=> '    Receive DHCPv6 Advertise Message',
	dhcp6_reply					=> '    Receive DHCPv6 Reply Message',
	
	relayforward_solicit_nut_to_server1		=> '    Receive DHCPv6 Relay-forward Message (Solicit): NUT --> All DHCP Servers',
	relayforward_request_nut_to_server1		=> '    Receive DHCPv6 Relay-forward Message (Request): NUT --> All DHCP Servers',
	relayforward_confirm_nut_to_server1		=> '    Receive DHCPv6 Relay-forward Message (Confirm): NUT --> All DHCP Servers',
	relayforward_renew_nut_to_server1		=> '    Receive DHCPv6 Relay-forward Message (Renew): NUT --> All DHCP Servers',
	relayforward_rebind_nut_to_server1		=> '    Receive DHCPv6 Relay-forward Message (Rebind): NUT --> All DHCP Servers', 
	relayforward_release_nut_to_server1		=> '    Receive DHCPv6 Relay-forward Message (Release): NUT --> All DHCP Servers',
	relayforward_decline_nut_to_server1		=> '    Receive DHCPv6 Relay-forward Message (Decline): NUT --> All DHCP Servers',
	relay_forward_nut_server			=> '    Receive DHCPv6 Relay-forward Message (Any): NUT --> All DHCP Servers',

	nut_to_dhcp_any					=> '    Receive DHCPv6 Any Message: NUT --> Any',

	solicit_client1_to_alldhcp			=> '    Send DHCPv6 Solicit Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	solicit_client1_to_nut				=> '    Send DHCPv6 Solicit Message: CLIENT1 --> NUT',
	solicit_client1_to_alldhcp_invalidUDP		=> '    Send DHCPv6 Solicit Message: CLIENT1 --> All DHCP Servers and Relay Agents (Invalid UDP Port)',
	solicit_client2_to_alldhcp			=> '    Send DHCPv6 Solicit Message: CLIENT2 --> All DHCP Servers and Relay Agents',

	advertise_server1_to_nut_invalid		=> '    Send DHCPv6 Advertise Message: CLIENT1 --> NUT (Invalid)',
	invalid_advertise_client1_to_alldhcp		=> '    Send DHCPv6 Advertise Message: CLIENT1 --> NUT (Invalid)',
	
	request_client1_to_alldhcp			=> '    Send DHCPv6 Request Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	request_client1_to_nut_notonlink		=> '    Send DHCPv6 Request Message (with not-onlink IA address): CLIENT1 --> All DHCP Servers and Relay Agents',
	request_client1_to_nut				=> '    Send DHCPv6 Request Message: CLIENT1 --> NUT',
	request_client2_to_alldhcp			=> '    Send DHCPv6 Request Message: CLIENT2 --> All DHCP Servers and Relay Agents',

	reply_server1_to_nut_invalid			=> '    Send DHCPv6 Reply Message: CLIENT1 --> NUT (Invalid)',
	invalid_reply_client1_to_alldhcp		=> '    Send DHCPv6 Reply Message: CLIENT1 --> NUT (Invalid)',
	
	information_request_client1_to_alldhcp		=> '    Send DHCPv6 Infomation Request Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	information_request_client1_to_nut		=> '    Send DHCPv6 Infomation Request Message: CLIENT1 --> NUT',
	information_request_client1_to_alldhcp_invalidUDP	=> '    Send DHCPv6 Information Request Message: CLIENT1 --> All DHCP Servers and Relay Agents (Invalid UDP Port)',
	
	confirm_client1_to_alldhcp			=> '    Send DHCPv6 Confirm Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	confirm_client1_to_nut				=> '    Send DHCPv6 Confirm Message: CLIENT1 --> NUT',
	confirm_client1_to_nut_notonlink		=> '    Send DHCPv6 Confirm Message (with not-onlink IA address): CLIENT1 --> All DHCP Servers and Relay Agents',
	confirm_client1_to_nut_noAddress		=> '    Send DHCPv6 Confirm Message (without IA address): CLIENT1 --> All DHCP Servers and Relay Agents',
	
	renew_client1_to_alldhcp			=> '    Send DHCPv6 Renew Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	renew_client1_to_nut_lla			=> '    Send DHCPv6 Renew Message: CLIENT1 --> NUT(Link Local Address)',
	renew_client1_to_nut_ga				=> '    Send DHCPv6 Renew Message: CLIENT1 --> NUT(Global Address)',
	renew_client1_to_alldhcp_notAppro		=> '    Send DHCPv6 Renew Message (with not-assigned IA address): CLIENT1 --> All DHCP Servers and Relay Agents',
	renew_client1_to_alldhcp_Notbind		=> '    Send DHCPv6 Renew Message (with not-delegated IA prefix): CLIENT1 --> All DHCP Servers and Relay Agents',

	rebind_client1_to_alldhcp			=> '    Send DHCPv6 Rebind Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	rebind_client1_to_nut_lla			=> '    Send DHCPv6 Rebind Message: CLIENT1 --> NUT(Link Local Address)',
	rebind_client1_to_nut_ga			=> '    Send DHCPv6 Rebind Message: CLIENT1 --> NUT(Global Address)',
	
	decline_client1_to_alldhcp			=> '    Send DHCPv6 Decline Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	decline_client1_to_nut_lla			=> '    Send DHCPv6 Decline Message: CLIENT1 --> NUT(Link Local Address)',
	decline_client1_to_nut_ga			=> '    Send DHCPv6 Decline Message: CLIENT1 --> NUT(Global Address)',

	release_client1_to_alldhcp			=> '    Send DHCPv6 Release Message: CLIENT1 --> All DHCP Servers and Relay Agents',
	release_client1_to_nut_lla			=> '    Send DHCPv6 Release Message: CLIENT1 --> NUT(Link Local Address)',
	release_client1_to_nut_ga			=> '    Send DHCPv6 Release Message: CLIENT1 --> NUT(Global Address)',

	relayforward_solicit_client1_to_alldhcp		=> '    Send DHCPv6 Reley-forward Message (Solicit): RELAY1 --> All DHCP Servers',
	relayforward_solicit_client2_to_alldhcp		=> '    Send DHCPv6 Reley-forward Message (Solicit): RELAY2 --> All DHCP Servers',
	relayforward_solicit_client1_to_alldhcp_interface_id		=> '    Send DHCPv6 Reley-forward Message (Solicit): RELAY1 --> All DHCP Servers',
	relayforward_solicit_relay2_to_nut_invalid	=> '    Send DHCPv6 Reley-forward Message (Solicit): RELAY1 --> NUT (Invalid)',
	relayforward_solicit_client4_to_relay2_to_relay1_alldhcp	=> '    Send DHCPv6 Reley-forward Message (Solicit): RELAY3 --> RELAY1 --> ALLDHCP Servers',
	relayforward_solicit_client4_to_relay2_to_relay1_alldhcp_2	=> '    Send DHCPv6 Reley-forward Message (Solicit): RELAY3 --> RELAY1 --> ALLDHCP Servers',
	relayforward_request_client1_to_alldhcp		=> '    Send DHCPv6 Reley-forward Message (Request): RELAY1 --> All DHCP Servers',
	relayforward_request_client1_to_alldhcp_interface_id		=> '    Send DHCPv6 Reley-forward Message (Request): RELAY1 --> All DHCP Servers',
	relayforward_information_relay2_to_nut_invalid	=> '    Send DHCPv6 Reley-forward Message (Information-request): RELAY1 --> NUT (Invalid)',
	relay_advertise_server1_to_client1_1relay	=> '    Send DHCPv6 Relay-reply message (Advertise): SERVER1 --> NUT',
	relay_invalid_advertise_client1_to_alldhcp	=> '    Send DHCPv6 Relay-reply message (Advertise): CLIENT1 --> NUT (Invalid)',
	#relay_reply_nut_relay				=> '    Send DHCPv6 Relay-reply message (Advertise): NUT' --> RELAY1',
	#relay_reply_nut_relay2_0			=> '    Send DHCPv6 Relay-reply message (Advertise): NUT' --> RELAY2',
	relay_reply_server1_to_client1_1relay		=> '    Send DHCPv6 Relay-reply message (Reply): SERVER1 --> NUT',
	relay_advertise_invalid				=> '    Send DHCPv6 Relay-reply message (Advertise): RELAY1 --> NUT',
);
