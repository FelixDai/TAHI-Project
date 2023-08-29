#!/usr/bin/perl
#
# Copyright (C) 2013, 2014, 2015, 2016,2017, 2018
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
#
# $CHT-TL: DHCPv6_common.pm, v 1.6 2018/03/07 weifen Exp $
#
########################################################################

package DHCPv6_common;

use Exporter;
use MIME::Base64;
use Digest::HMAC_MD5 qw(hmac_md5 hmac_md5_hex);
use V6evalTool;
use CPE6_config;
use strict;

use vars qw(
	@ISA
	@EXPORT
	$TRUE
	$FALSE
	$DUID_CLIENT
	$DUID_CLIENT3
	$DUID_CLIENT4
	$NUTRELAY1_LINK0_GLOBAL_UCAST
	$NUTRELAY1_LINK1_GLOBAL_UCAST
	$SERVER1_GLOBAL_UCAST
	$RELAY2_GLOBAL_UCAST
	$CID_OPTION
	$SID_OPTION
	$IA_NA_OPTION
	$IA_NA_OPTION1
	$IA_PD_OPTION
	$IA_PD_OPTION1
	$IA_TA_OPTION
	$DNS_SVR_OPTION
	$DNS_LST_OPTION
	$OptionRequest_OPTION
	$Preference_OPTION
	$ElapsedTime_OPTION
	$Authentication_OPTION
	$Authentication_OPTION2
	$ServerUnicast_OPTION
	$RapidCommit_OPTION
	$UserClass_OPTION
	$VendorClass_OPTION
	$VendorSpecificInfo_OPTION
	$IID_OPTION
	$ReconfigureMessage_OPTION
	$ReconfigureAccept_OPTION
	$RELAY_Msg_OPTION
	$StatusCode_OPTION
	$AUTH_OPTION_REQUIRED
	$SOL_MAX_DELAY
	$SOL_TIMEOUT
	$SOL_MAX_RT
	$SOL_RT
	$REQ_TIMEOUT
	$REQ_MAX_RT
	$REQ_MAX_RC
	$CNF_MAX_DELAY
	$CNF_TIMEOUT
	$CNF_MAX_RT
	$CNF_MAX_RD
	$REN_TIMEOUT
	$REN_MAX_RT
	$REB_TIMEOUT
	$REB_MAX_RT
	$INF_MAX_DELAY
	$INF_TIMEOUT
	$INF_MAX_RT
	$REL_TIMEOUT
	$REL_MAX_RC
	$DEC_TIMEOUT
	$DEC_MAX_RC
	$REC_TIMEOUT
	$REC_MAX_RC
	$RAND
	$CMP_CID
	$CMP_SID
	$CMP_IA_NA
	$CMP_IA_TA
	$CMP_IA_ADD
	$CMP_ORO
	$CMP_PREF
	$CMP_ETIME
	$CMP_RELAYMSG
	$CMP_AUTH
	$CMP_SVRUNICAST
	$CMP_STATUS_CODE
	$CMP_RAPIDCOMMIT
	$CMP_USER_CLASS
	$CMP_VENDER_CLASS
	$CMP_VENDER_SPEC
	$CMP_IID
	$CMP_RECONF_MSG
	$CMP_RECONF_ACCEPT
	$CMP_IA_PD
	$CMP_IA_PREFIX
	$CMP_DNS_SVR
	$CMP_DNS_LST
	$CMP_NTP_SVR
	$CMP_NTP_TZ
	$CMP_SIP_D
	$CMP_SIP_A
	$CMP_TRANS_ID
	$STATUS_CODE_SUCCESS
	$STATUS_CODE_UNSPECFAIL
	$STATUS_CODE_NOADDRSAVAIL
	$STATUS_CODE_NOBINDING
	$STATUS_CODE_NOTONLINK
	$STATUS_CODE_USEMULTICAST
	$STATUS_CODE_NOPREFIXAVAIL
	);

@ISA = qw(Exporter);
@EXPORT = qw(
	wait_for_dhcp6frame
	wait_for_dhcp6frame2
	wait_for_solicit
	wait_for_solicit2
	wait_for_advertise
	wait_for_request
	wait_for_request2
	wait_for_confirm
	wait_for_renew
	wait_for_renew2
	wait_for_rebind
	wait_for_rebind2
	wait_for_release
	wait_for_release2
	wait_for_reply
	wait_for_reply2
	wait_for_decline
	wait_for_reconfigure
	wait_for_information_request
	wait_for_relay_forward_solicit
	wait_for_relay_forward_request
	wait_for_relay_forward_confirm
	wait_for_relay_forward_renew
	wait_for_relay_forward_rebind
	wait_for_relay_forward_release
	wait_for_relay_forward_decline
	wait_for_relay_reply
	wait_for_relay_reply2
	wait_for_relay_reply_reply
	wait_for_relay_reply_reply2
	wait_for_relay_reply_advertise
	wait_for_relay_reply_advertise2
	wait_for_relay_reply_relay
	wait_for_relay_reply_relay2
	wait_for_relay_forward
	vRecvPacket
	vRecvPacket2
	AppendCid
	GetCidOption

	send_relay_forward
	send_relay_forward2
	send_relay_forward_request
	send_layered_relay_forward_request
	send_invalid_relay_reply
	send_relay_reply
	send_relay_reply2
	send_solicit
	send_invalid_advertise
	send_invalid_reply
	send_advertise
	send_advertise1
	send_advertise2
	send_request
	send_confirm
	send_renew
	send_rebind
	send_decline
	send_release
	send_reply
	send_reply2
	send_reply3
	send_reconfigure
	send_reconfigure_message
	send_information_request
	
	dhcpExitPass
	dhcpExitIgnore
	dhcpExitNS
	dhcpExitError
	dhcpExitFail

	dhcpReset
	dhcpCltInit
	dhcpCltStart
	dhcpCltRestart
	ck_IAoptions
	dhcpSvrInit
	dhcpSvrInitS
	dhcpDelegatingInit
	SetNUTAddr
	ifDown
	ifUp

	dhcpRelayInit
	chkMsgAfterRelay
	ckRelayMsgHopLimit
	ckRelayForwardMsgHopCount
	ckRelayReplyMsgHopCount
	ckRelayReplyMsgHopCount2
	ckRelayForwardPeerAddress
	CompareTimeUpdateCompletely

	initial_ra_w_ping
	initial_ra_w_ping_dummy
	ping_test
	ping_test_addr2
	ping_test_nut1
	ping_nut_test
	check_time
	check_lifetime
	check_equal
	check_equal_RT
	check_dest_ipaddress
	check_ipaddr_local	
	compare_message
	compare_transactionID
	compare_hopcount
	compare_id
	compare_iaid
	compare_time
	check_RecvTime
	compare_lifetimes
	compare_prefix
	get_DUID_type_conf
	get_IA_NA_number
	get_IA_PD_number
	get_IA_Prefix_number
	get_OptRequstCode
	lookup_OptRequestCode
	compare_options
	get_nut_link_number
	get_field_value
	get_udp_destport
	readElapsedtime
	getReceivedtime
	calcElapsedtime
	parse_IAPD_option
	parse_IAPD_option2
	parse_IAPrefix_option	
	options_exist
	suboptions_exist
	option_exist
	createPacketDefinitionFile
	parse_message
	check_DUID
	check_FieldValueinOption
	check_valueofAnyFieldInOption
	check_statuscode
	get_statuscode_string
	CheckTimeOfPrefixOP
	ck_IAPD_prefix_options
	ck_IAPDoptions
	CheckMessageInRelayOption
	ckRelayForwardLinkAddress
	
	ChkFuncSupport
	ChkConfig
	Ascii2Hex
	Ascii2Base64
	SharedSecretKeyCheck
	ReplayDetectCounter
	check_Auth_MD5
	clear_options
	cleanup
	specReboot

	$TRUE
	$FALSE
	$DUID_CLIENT
	$DUID_CLIENT3
	$DUID_CLIENT4
	$NUTRELAY1_LINK0_GLOBAL_UCAST
	$NUTRELAY1_LINK1_GLOBAL_UCAST
	$SERVER1_GLOBAL_UCAST
	$RELAY2_GLOBAL_UCAST
	
	$CID_OPTION
	$SID_OPTION
	$IA_NA_OPTION
	$IA_NA_OPTION1
	$IA_PD_OPTION
	$IA_PD_OPTION1
	$IA_TA_OPTION
	$DNS_SVR_OPTION
	$DNS_LST_OPTION
	$SOL_MAX_RT
	$OptionRequest_OPTION
	$Preference_OPTION
	$ElapsedTime_OPTION
	$Authentication_OPTION
	$Authentication_OPTION2
	$ServerUnicast_OPTION
	$RapidCommit_OPTION
	$UserClass_OPTION
	$VendorClass_OPTION
	$VendorSpecificInfo_OPTION
	$IID_OPTION
	$ReconfigureMessage_OPTION
	$ReconfigureAccept_OPTION
	$RELAY_Msg_OPTION
	$StatusCode_OPTION
	$AUTH_OPTION_REQUIRED
	$SOL_MAX_DELAY
	$SOL_TIMEOUT
	$SOL_RT
	$REQ_TIMEOUT
	$REQ_MAX_RT
	$REQ_MAX_RC
	$CNF_MAX_DELAY
	$CNF_TIMEOUT
	$CNF_MAX_RT
	$CNF_MAX_RD
	$REN_TIMEOUT
	$REN_MAX_RT
	$REB_TIMEOUT
	$REB_MAX_RT
	$INF_MAX_DELAY
	$INF_TIMEOUT
	$INF_MAX_RT
	$REL_TIMEOUT
	$REL_MAX_RC
	$DEC_TIMEOUT
	$DEC_MAX_RC
	$REC_TIMEOUT
	$REC_MAX_RC
	$RAND
	$CMP_CID
	$CMP_SID
	$CMP_IA_NA
	$CMP_IA_TA
	$CMP_IA_ADD
	$CMP_ORO
	$CMP_PREF
	$CMP_ETIME
	$CMP_RELAYMSG
	$CMP_AUTH
	$CMP_SVRUNICAST
	$CMP_STATUS_CODE
	$CMP_RAPIDCOMMIT
	$CMP_USER_CLASS
	$CMP_VENDER_CLASS
	$CMP_VENDER_SPEC
	$CMP_IID
	$CMP_RECONF_MSG
	$CMP_RECONF_ACCEPT
	$CMP_IA_PD
	$CMP_IA_PREFIX
	$CMP_DNS_SVR
	$CMP_DNS_LST
	$CMP_NTP_SVR
	$CMP_NTP_TZ
	$CMP_SIP_D
	$CMP_SIP_A
	$CMP_TRANS_ID
	$STATUS_CODE_SUCCESS
	$STATUS_CODE_UNSPECFAIL
	$STATUS_CODE_NOADDRSAVAIL
	$STATUS_CODE_NOBINDING
	$STATUS_CODE_NOTONLINK
	$STATUS_CODE_USEMULTICAST
	$STATUS_CODE_NOPREFIXAVAIL
	$LISTEN_UDPPORT_CLT
	$LISTEN_UDPPORT_SVRRELAY

	allocate_retransmission_instance
	register_retransmission
	evaluate_retransmission
	ResetDhcpOpt
	ChkAdvFunc
	change_maxSolRt
	cpe_initialization
	cpe_initialization_1_2
	ping_nut_ll
	wan_init_without_waiting
);

sub wait_for_dhcp6frame($$$);
sub wait_for_dhcp6frame2($$$);
sub wait_for_advertise($$);
sub wait_for_reply($$);
sub wait_for_reply2($$);
sub wait_for_reconfigure($$);
sub wait_for_relay_reply($$$$);
sub wait_for_relay_reply2($$$$);
sub wait_for_relay_reply_advertise($$$);
sub wait_for_relay_reply_advertise2($$$);
sub wait_for_relay_reply_reply($$;$);
sub wait_for_relay_reply_reply2($$;$);
sub wait_for_relay_reply_relay($$$);
sub wait_for_relay_reply_relay2($$$);
sub wait_for_relay_forward_solicit($$);
sub wait_for_relay_forward_request($$);
sub wait_for_relay_forward_confirm($$);
sub wait_for_relay_forward_renew($$);
sub wait_for_relay_forward_rebind($$);
sub wait_for_relay_forward_release($$);
sub wait_for_relay_forward_decline($$);
sub wait_for_relay_forward($$$);

sub wait_for_solicit($$);
sub wait_for_solicit2($$);
sub wait_for_request($$);
sub wait_for_request2($$);
sub wait_for_confirm($$);
sub wait_for_renew($$$);
sub wait_for_renew2($$);
sub wait_for_rebind($$$);
sub wait_for_rebind2($$);
sub wait_for_decline($$);
sub wait_for_information_request($$);
sub wait_for_release($$);
sub wait_for_release2($$$);
sub vRecvPacket($$$$@);
sub vRecvPacket2($$$$@);
sub AppendCid($$$);
sub GetCidOption($$);

sub send_solicit($$$);
sub send_invalid_advertise($$$);
sub send_invalid_reply($$$);
sub send_confirm($$$$);
sub send_renew($$$$);
sub send_rebind($$$$);
sub send_release($$$$);
sub send_decline($$$$);
sub send_information_request($$$$);
sub send_request($$$$);
sub send_advertise($$$$);
sub send_advertise2($$$$);
sub send_reply($$$$);
sub send_reply2($$$$);
sub send_reply3($$$$);
sub send_reconfigure($$$$);
sub send_reconfigure_message($$$$);

sub get_field_value($$);
#sub getElapsedtime($);
sub readElapsedtime($);
sub getReceivedtime($);
sub calcElapsedtime($$);
sub get_nut_link_number($);
sub get_OptRequstCode($);
sub lookup_OptRequestCode($$);

sub initial_ra_w_ping($$);
sub initial_ra_w_ping_dummy($$);
sub ping_test($);
sub ping_test_addr2($);
sub ping_test_nut1($);
sub ping_nut_test($$$;$);
sub check_equal($$;$);
sub check_equal_RT($$;$);
sub check_dest_ipaddress($);
sub check_ipaddr_local($$);
# for exit values
sub dhcpExitPass();
sub dhcpExitIgnore();
sub dhcpExitNS();
sub dhcpExitSkip();
sub dhcpExitError($);
sub dhcpExitFail(;$);
sub dhcpReset();
sub dhcpCltInit();
sub dhcpCltStart();
sub dhcpCltRestart();

#for interface
sub ifDown($);
sub ifUp($);

# for retransmission
sub compare_message($$);
sub compare_transactionID($$);
sub compare_hopcount($$);
sub compare_id($$$);
#sub get_iaid($$);
sub compare_iaid($$$);
sub compare_time($$$);
sub check_RecvTime($$$);
sub compare_lifetimes($$$);
sub compare_prefix($$$);
sub get_DUID_type_conf();
sub get_IA_NA_number($);
sub get_IA_PD_number($);
sub get_IA_Prefix_number($);
sub parse_IAPD_option($);
sub parse_IAPD_option2($);
sub parse_IAPrefix_option($);
sub get_udp_destport($);
#check functions
sub getMsgTypeLocStr($);
sub compare_options($$$);
sub compare_option($$$$);
sub clear_options();
sub options_exist($$);
sub suboptions_exist($$);
sub option_exist($$);
sub createPacketDefinitionFile($);
sub get_statuscode_string($);
sub get_optname_string($);
sub parse_message($);
sub ck_IAoptions($$$);
sub check_time($$);
sub check_lifetime($$);
sub check_DUID($$$);
sub check_FieldValueinOption($$$$);
sub check_valueofAnyFieldInOption($$$$);
sub check_statuscode($$$);
sub CheckTimeOfPrefixOP($$);
sub CheckMessageInRelayOption($$);
sub ck_IAPD_prefix_options($$);
sub ck_IAPDoptions($$$);
sub ckRelayForwardMsgHopCount ($$);
sub ckRelayReplyMsgHopCount ($$);
sub ckRelayReplyMsgHopCount2 ($$$);
sub ckRelayMsgHopLimit ($$);
sub ckRelayForwardPeerAddress ($$);
sub ckRelayForwardLinkAddress($$);
sub CompareTimeUpdateCompletely($$$$);
sub chkMsgAfterRelay($$);
sub parse_relay_message($);

#setup the NUT(server)
sub dhcpSvrInit($);
sub dhcpSvrInitS($);
sub dhcpDelegatingInit($);
sub SetNUTAddr($$$$);
# for relay-agent
sub dhcpRelayInit($);
sub send_relay_forward($$);
sub send_relay_forward2($$);
sub send_relay_forward_request($$$$);
sub send_layered_relay_forward_request($$$$);
sub send_invalid_relay_reply($$);
sub send_relay_reply($$$$);
sub send_relay_reply2($$$$);

#internal fuction
sub message_output($$$);

#judgement whether make the DUID test;
sub ChkFuncSupport($);

#check configuration parametor
sub ChkConfig($);

#exchange Ascii to XXXX
sub Ascii2Hex($);
sub Ascii2Base64($);

sub ResetDhcpOpt();
sub ChkAdvFunc($);
sub change_maxSolRt($);
sub cpe_initialization($$$$$);
sub cpe_initialization_1_2($$$$$);
sub wan_init_without_waiting($$$$$);
sub ping_nut_ll();

#Global Constant define
$TRUE = 1;
$FALSE = undef;

#Shared Secret Key type check
sub SharedSecretKeyCheck($$);
#Increment Replay DetectCounter
sub ReplayDetectCounter($);

#calculate MD5 
sub check_Auth_MD5($$);
sub get_Opt_String($$$$);

sub allocate_retransmission_instance($$$$);
sub register_retransmission($$$);
sub evaluate_retransmission($);

#Debug Option
my $DHCP_CHECK_DEBUG = $TRUE;


#DUID constant
$DUID_CLIENT = "00:01:00:01:00:04:93:e0:00:00:00:00:a2:a2";
$DUID_CLIENT3 = "00:01:00:01:00:04:93:e0:00:00:00:00:b3:b3";
$DUID_CLIENT4 = "00:01:00:01:00:04:93:e0:00:00:00:00:b4:b4";

#For Relay agent test;
$NUTRELAY1_LINK0_GLOBAL_UCAST = "3ffe:501:ffff:100:" . macToEui64($V6evalTool::NutDef{Link0_addr});
$NUTRELAY1_LINK1_GLOBAL_UCAST = "3ffe:501:ffff:101:" . macToEui64($V6evalTool::NutDef{Link1_addr});
$SERVER1_GLOBAL_UCAST = "3ffe:501:ffff:100:200:ff:fe00:a1a1";

#Maximum network interface number
my $MAXIFCOUNT = 1;

#For NUT(server) parameters
my $NUT_Server_Config_ref = undef;
my $NUT_Relay_Config_ref = undef;
my $NUT_Delegating_Config_ref = undef;

#RFC3315 recommanded constants 
$SOL_MAX_DELAY  =       1;
$SOL_TIMEOUT    =       1;

#RFC7083 change the solicit max retransmit value in RFC3315
$SOL_MAX_RT     =       3600;
$REQ_TIMEOUT    =       1;
$REQ_MAX_RT     =       30;
$REQ_MAX_RC     =       10;
$CNF_MAX_DELAY  =       1;
$CNF_TIMEOUT    =       1;
$CNF_MAX_RT     =       4;
$CNF_MAX_RD     =       10;
$REN_TIMEOUT    =       10;
$REN_MAX_RT     =       600;
$REB_TIMEOUT    =       10;
$REB_MAX_RT     =       600;
$INF_MAX_DELAY  =       1;
$INF_TIMEOUT    =       1;
#RFC7083 change the solicit max retransmit value in RFC3315
$INF_MAX_RT     =       3600;
$REL_TIMEOUT    =       1;
$REL_MAX_RC     =       5;
$DEC_TIMEOUT    =       1;
$DEC_MAX_RC     =       5;
$REC_TIMEOUT    =       2;
$REC_MAX_RC     =       8;
$RAND		=	0.1;

my %option_codes = (
	0 => "???",
	1 => "OPTION_CLIENTID",
	2 => "OPTION_SERVERID",
	3 => "OPTION_IA_NA",
	4 => "OPTION_IA_TA",
	5 => "OPTION_IAADDR",
	6 => "OPTION_ORO",
	7 => "OPTION_PREFERENCE",
	8 => "OPTION_ELAPSED_TIME",
	9 => "OPTION_RELAY_MSG",
	10 => "???",
	11 => "OPTION_AUTH",
	12 => "OPTION_UNICAST",
	13 => "OPTION_STATUS_CODE",
	14 => "OPTION_RAPID_COMMIT",
	15 => "OPTION_USER_CLASS",
	16 => "OPTION_VENDOR_CLASS",
	17 => "OPTION_VENDOR_OPTS",
	18 => "OPTION_INTERFACE_ID",
	19 => "OPTION_RECONF_MSG",
	20 => "OPTION_RECONF_ACCEPT",
	21 => "OPTION_SIP_SERVER_D",
	22 => "OPTION_SIP_SERVER_A",
	23 => "OPTION_DNS_SERVERS",
	24 => "OPTION_DOMAIN_LIST",
	25 => "OPTION_IA_PD",
	26 => "OPTION_IAPREFIX",
	31 => "PREFIX_INFORMATION",
	32 => "PREFIX_REQUEST",
	82 => "OPTION_SOL_MAX_RT"
	);

# for compare_options($$$)
$CMP_CID             = 1 <<  0;
$CMP_SID             = 1 <<  1;
$CMP_IA_NA           = 1 <<  2;
$CMP_IA_TA           = 1 <<  3;
$CMP_IA_ADD          = 1 <<  4;
$CMP_ORO             = 1 <<  5;
$CMP_PREF            = 1 <<  6;
$CMP_ETIME           = 1 <<  7;
$CMP_RELAYMSG        = 1 <<  8;
$CMP_AUTH            = 1 <<  9;
$CMP_SVRUNICAST      = 1 << 10;
$CMP_STATUS_CODE     = 1 << 11;
$CMP_RAPIDCOMMIT     = 1 << 12;
$CMP_USER_CLASS      = 1 << 13;
$CMP_VENDER_CLASS    = 1 << 14;
$CMP_VENDER_SPEC     = 1 << 15;
$CMP_IID             = 1 << 16;
$CMP_RECONF_MSG      = 1 << 17;
$CMP_RECONF_ACCEPT   = 1 << 18;
$CMP_IA_PD           = 1 << 19;
$CMP_IA_PREFIX       = 1 << 20;
$CMP_DNS_SVR         = 1 << 21;
$CMP_DNS_LST         = 1 << 22;
$CMP_SIP_D           = 1 << 25;
$CMP_SIP_A           = 1 << 26;
$CMP_TRANS_ID        = 1 << 27;

my %duid_types = (
	1=>"DHCPv6_DUID_LLT_Ether",
	2=>"DHCPv6_DUID_EN",
	3=>"DHCPv6_DUID_LL_Ether"
	);

my %option_defs = (
	$CMP_CID           => "Opt_DHCPv6_CID",
	$CMP_SID           => "Opt_DHCPv6_SID",
	$CMP_IA_NA         => "Opt_DHCPv6_IA_NA",
	$CMP_IA_TA         => "Opt_DHCPv6_IA_TA",
	$CMP_IA_ADD        => "Opt_DHCPv6_IA_Address",
	$CMP_ORO           => "Opt_DHCPv6_OptionRequest",
	$CMP_PREF          => "Opt_DHCPv6_Preference",
	$CMP_ETIME         => "Opt_DHCPv6_ElapsedTime",
	$CMP_RELAYMSG      => "Opt_DHCPv6_RelayMessage",
	$CMP_AUTH          => "Opt_DHCPv6_Authentication",
	$CMP_SVRUNICAST    => "Opt_DHCPv6_ServerUnicast",
	$CMP_STATUS_CODE   => "Opt_DHCPv6_StatusCode",
	$CMP_RAPIDCOMMIT   => "Opt_DHCPv6_RapidCommit",
	$CMP_USER_CLASS    => "Opt_DHCPv6_UserClass",
	$CMP_VENDER_CLASS  => "Opt_DHCPv6_VendorClass",
	$CMP_VENDER_SPEC   => "Opt_DHCPv6_VendorSpecificInfo",
	$CMP_IID           => "Opt_DHCPv6_IID",
	$CMP_RECONF_MSG    => "Opt_DHCPv6_ReconfigureMessage",
	$CMP_RECONF_ACCEPT => "Opt_DHCPv6_ReconfigureAccept",
	$CMP_IA_PD         => "Opt_DHCPv6_IA_PD",
	$CMP_IA_PREFIX     => "Opt_DHCPv6_IA_Prefix",
	$CMP_DNS_SVR       => "Opt_DHCPv6_DNS_Servers",
	$CMP_DNS_LST       => "Opt_DHCPv6_DNS_SearchList",
	$CMP_SIP_D         => "Opt_DHCPv6_SIP_ServerD",
	$CMP_SIP_A         => "Opt_DHCPv6_SIP_ServerA",
	$CMP_TRANS_ID      => "Identifier",
	);

my %dhcp6_messages = (
	"Solicit" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Solicit",
	"Advertise" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Advertise",
	"Request" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Request",
	"Confirm" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Confirm",
	"Reply" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Reply",
	"Renew" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Renew",
	"Rebind" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Rebind",
	"Release" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Release",
	"Decline" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Decline",
	"Reconfigure" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Reconfigure",
	"InformationRequest" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_InformationRequest",
	"RelayForward" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayForward",
	"RelayReply" => "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayReply",
	);
	
my %dhcp6_messages_title = (
	"Solicit" => "Udp_DHCPv6_Solicit",
	"Advertise" => "Udp_DHCPv6_Advertise",
	"Request" => "Udp_DHCPv6_Request",
	"Confirm" => "Udp_DHCPv6_Confirm",
	"Reply" => "Udp_DHCPv6_Reply",
	"Renew" => "Udp_DHCPv6_Renew",
	"Rebind" => "Udp_DHCPv6_Rebind",
	"Release" => "Udp_DHCPv6_Release",
	"Decline" => "Udp_DHCPv6_Decline",
	"Reconfigure" => "Udp_DHCPv6_Reconfigure",
	"InformationRequest" => "Udp_DHCPv6_InformationRequest",
	"RelayForward" => "Udp_DHCPv6_RelayForward",
	"RelayReply" => "Udp_DHCPv6_RelayReply",
	);

$STATUS_CODE_SUCCESS		= 0;
$STATUS_CODE_UNSPECFAIL		= 1;
$STATUS_CODE_NOADDRSAVAIL	= 2;
$STATUS_CODE_NOBINDING		= 3;
$STATUS_CODE_NOTONLINK		= 4;
$STATUS_CODE_USEMULTICAST	= 5;
$STATUS_CODE_NOPREFIXAVAIL	= 6;

my %status_codes = (
	$STATUS_CODE_SUCCESS		=> "Success",
	$STATUS_CODE_UNSPECFAIL		=> "UnspecFail",
	$STATUS_CODE_NOADDRSAVAIL	=> "NoAddrsAvail",
	$STATUS_CODE_NOBINDING		=> "NoBinding",
	$STATUS_CODE_NOTONLINK		=> "NotOnLink",
	$STATUS_CODE_USEMULTICAST	=> "UseMulticast",
	$STATUS_CODE_NOPREFIXAVAIL	=> "NoPrefixAvail"
	);

# Variables from DHCPv6_config
my $RA_TRIGGER_DHCPv6 = 1;
my $RA_BEFORE_PING = 0;
my $CLEANUP = "reboot";
my $WAIT_INCOMPLETE = 10;
my $SLEEP_AFTER_REBOOT = 5;
my $CLEANUP_INTERVAL = 5;
my $WAIT_REBOOTCMD = 70;
#--------------------------------------------------------------------------------------------#
#--------------------------------------------------------------#
# wait_for_dhcp6frame($if, $timeout, $frame)                   #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, rcv_packet)                           #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_dhcp6frame($$$) {
	my ($if, $timeout, $frame) = @_;
	my $cppstr = "";
	$cppstr .= '-D LINKN_DEVICE=$if';
	vCPP($cppstr);

	my %ret = vRecvPacket($if, $timeout, 0, 0, $frame);
	if ($ret{status} == 0) {
		vLogHTML('<B>Got Message</B><BR><BR>');
		parse_message(\%ret);
		return (0, %ret);
	}
	vLogHTML('<B>Could not get Message</B><BR>');
	return (1, %ret);
}
#--------------------------------------------------------------#
# wait_for_dhcp6frame2($if, $timeout, $frame)                  #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, rcv_packet)                           #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_dhcp6frame2($$$) {
        my ($if, $timeout, $frame) = @_;
        my $cppstr = "";
        $cppstr .= '-D LINKN_DEVICE=$if';
        vCPP($cppstr);

        my %ret = vRecvPacket2($if, $timeout, 0, 0, $frame);
        if ($ret{status} == 0) {
                vLogHTML('<B>Got Message</B><BR><BR>');
                parse_message(\%ret);
                return (0, %ret);
        }
        vLogHTML('<B>Could not get Message</B><BR>');
        return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_solicit($if, $timeout)                              #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, solicit)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_solicit($$) {
	my ($if, $timeout) = @_;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Solicit";
	
#	my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_solicit");
	my %ret = vRecvPacket($if, $timeout, 0, 0, "dhcp6_solicit");
	if(defined($ret{"$base"})) {
		if ($AUTH_OPTION_REQUIRED){
			$ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
		}
		vLogHTML('<B>got DHCPv6 Solicit Message</B><BR>');
		parse_message(\%ret);
		if (! defined($ret{"$base\.Opt_DHCPv6_CID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Solicit Message MUST include CID option.</B></FONT> see 15.2 Solicit Message(id-28)<BR>');
			return (1, %ret);
		}
		if (defined($ret{"$base\.Opt_DHCPv6_SID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Solicit Message MUST NOT include SID option.</B></FONT> see 15.2 Solicit Message(id-28)<BR>');
			return (1, %ret);
		}
		return (0, %ret);
	}
	vLogHTML('<B>Could not get Solicit Message</B><BR>');
	return (1, %ret);
}
#--------------------------------------------------------------#
# wait_for_solicit2($if, $timeout)                             #
#                                                              #
# Notes:for PD                                                 #
#                                                              #
#    SUCCESS: return (0, solicit)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_solicit2($$) {
        my ($if, $timeout) = @_;
        my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Solicit";
        
#       my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_solicit");
        my %ret = vRecvPacket2($if, $timeout, 0, 0, "dhcp6_solicit");
        if(defined($ret{"$base"})) {
                if ($AUTH_OPTION_REQUIRED){
                        $ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
                }
                vLogHTML('<B>got DHCPv6 Solicit Message</B><BR>');
                parse_message(\%ret);
                if (! defined($ret{"$base\.Opt_DHCPv6_CID"})) {
                        vLogHTML('<FONT COLOR="#FF0000"><B>Solicit Message MUST include CID option.</B></FONT> see 15.2 Solicit Message(id-28)<BR>');
                        return (1, %ret);
                }
                if (defined($ret{"$base\.Opt_DHCPv6_SID"})) {
                        vLogHTML('<FONT COLOR="#FF0000"><B>Solicit Message MUST NOT include SID option.</B></FONT> see 15.2 Solicit Message(id-28)<BR>');
                        return (1, %ret);
                }
                return (0, %ret);
        }
        vLogHTML('<B>Could not get Solicit Message</B><BR>');
        return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_advertise($if, $timeout)                            #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, advertise)                            #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_advertise($$) {
	my ($if, $timeout) = @_;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Advertise";

	my %ret = vRecvPacket($if, $timeout, 0, 0, "dhcp6_advertise");
	if(defined($ret{"$base"})) {
		if ($AUTH_OPTION_REQUIRED){
			$ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
		}
		vLogHTML('<B>got DHCPv6 Advertise Message</B><BR>');
		parse_message(\%ret);
		if (! defined($ret{"$base\.Opt_DHCPv6_SID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Advertise Message MUST include SID option.</B></FONT> see 15.3 Advertise Message(id-28)<BR>');
			return (1, %ret);
		}
		if (! defined($ret{"$base\.Opt_DHCPv6_CID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Advertise Message MUST include CID option.</B></FONT> see 15.3 Advertise Message(id-28)<BR>');
			return (1, %ret);
		}
		return (0, %ret);
	}
	else{
		vLogHTML('<B>Can not got DHCPv6 Advertise Message</B><BR>');
		return (1, %ret);
	}
}
#--------------------------------------------------------------#
# wait_for_request($if, $timeout)                              #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, request)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_request($$) {
	my ($if, $timeout) = @_;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Request";
	
#	my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_request");
	my %ret = vRecvPacket($if, $timeout, 0, 0, "dhcp6_request");
	if($ret{"status"}!= 0){
		return ($ret{"status"},%ret);
	}
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Request Message</B><BR>');
		if ($AUTH_OPTION_REQUIRED){
			$ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
		}
		parse_message(\%ret);
		return (0, %ret);
	}
	vLogHTML('<B>Could not get Request Message</B><BR>');
	return (1, %ret);
}
#--------------------------------------------------------------#
# wait_for_request2($if, $timeout)                              #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, request)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_request2($$) {
        my ($if, $timeout) = @_;
        my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Request";
        
#       my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_request");
        my %ret = vRecvPacket2($if, $timeout, 0, 0, "dhcp6_request");
        if($ret{"status"}!= 0){
                return ($ret{"status"},%ret);
        }
        if(defined($ret{"$base"})) {
                vLogHTML('<B>got DHCPv6 Request Message</B><BR>');
                if ($AUTH_OPTION_REQUIRED){
                        $ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
                }
                parse_message(\%ret);
                return (0, %ret);
        }
        vLogHTML('<B>Could not get Request Message</B><BR>');
        return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_confirm($if, $timeout)                              #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, confirm)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_confirm($$) {
	my ($if, $timeout) = @_;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Confirm";
	
#	my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_confirm");
	my %ret = vRecvPacket($if, $timeout, 0, 0, "dhcp6_confirm");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Confirm Message</B><BR>');
		if ($AUTH_OPTION_REQUIRED){
			$ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
		}
		parse_message(\%ret);
		if (! defined($ret{"$base\.Opt_DHCPv6_CID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Confirm Message MUST include CID option.</B></FONT> see 15.5 Confirm Message(id-28)<BR>');
			return (1, %ret);
		}
		if (defined($ret{"$base\.Opt_DHCPv6_SID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Confirm Message MUST NOT include SID option.</B></FONT> see 15.5 Confirm Message(id-28)<BR>');
			return (1, %ret);
		}
		return (0, %ret);
	}
	vLogHTML('<B>Could not get Confirm Message</B><BR>');
	return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_renew($if, $timeout,$na_or_pd)                      #
#  $na_or_pd = 0 : just want renew message                     #
#  $na_or_pd = 1 : care renew IA_NA                            #
#  $na_or_pd = 2 : care renew IA_PD                            #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, renew)                                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_renew($$$) {
	my ($if, $timeout, $na_or_pd) = @_;
	my ($initime,$wait_time) = (0,0);
	my $get_pd_release = 0;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Renew";
	my %ret;
	my $found = 0;
	while (($wait_time < $timeout) && (!$found)) {
		%ret = vRecvPacket($if, $timeout - $wait_time, 0, 0, "dhcp6_renew");
		if($ret{"status"}!= 0){
			return ($ret{"status"},%ret);
		}
		if ($na_or_pd == 1) { 
			if (defined($ret{"$base\.Opt_DHCPv6_IA_NA"})) {
				$found = 1;
			} else {
				vLogHTML('<B>got DHCPv6 renew IA_PD Message, send reply for that renew</B><BR>');
				$IA_PD_OPTION = "opt_IA_PD_PF1";
				$IA_NA_OPTION = undef;
				my ($retrep, %rep) = send_reply($if, "reply_server1_to_nut", \%ret,"");
			}
		} elsif ($na_or_pd == 2){
			if (defined($ret{"$base\.Opt_DHCPv6_IA_PD"})) {
				$found = 1;
			} else {
				vLogHTML('<B>got DHCPv6 renew IA_NA Message, send reply for that renew</B><BR>');
				$IA_NA_OPTION = "opt_IA_NA_Addr_woStatus";
				$IA_PD_OPTION = undef;
				my ($retrep, %rep) = send_reply($if, "reply_server1_to_nut", \%ret,"");
			} 
		} elsif ($na_or_pd == 0){
			$found = 1;
		}

		if (!$found) {
			if (!$initime) {
				$initime = $ret{'recvTime1'};
			} else {
				$wait_time = $ret{'recvTime1'} - $initime;
			}
		}
		
	}
	if ($found){
		if ($AUTH_OPTION_REQUIRED){
			$ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
		}
		parse_message(\%ret);
		if (! defined($ret{"$base\.Opt_DHCPv6_SID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Renew Message MUST include SID option.</B></FONT> see 15.6 Renew Message(id-28)<BR>');
			return (1, %ret);
		}
		if (! defined($ret{"$base\.Opt_DHCPv6_CID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Renew Message MUST include CID option.</B></FONT> see 15.6 Renew Message(id-28)<BR>');
			return (1, %ret);
		}
		return (0, %ret);
	} else {
		vLogHTML('<B>Did not get any expected renew Message</B><BR>');
		return (1, %ret);
	}
}

#--------------------------------------------------------------#
# wait_for_renew2($if, $timeout)                               #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, renew)                                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_renew2($$) {
        my ($if, $timeout) = @_;
        my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Renew";
        
#       my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_renew");
        my %ret = vRecvPacket2($if, $timeout, 0, 0, "dhcp6_renew");

        if(defined($ret{"$base"})) {
                vLogHTML('<B>got DHCPv6 Renew Message</B><BR>');
                if ($AUTH_OPTION_REQUIRED){
                        $ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
                }
                parse_message(\%ret);
                if (! defined($ret{"$base\.Opt_DHCPv6_SID"})) {
                        vLogHTML('<FONT COLOR="#FF0000"><B>Renew Message MUST include SID option.</B></FONT> see 15.6 Renew Message(id-28)<BR>');
                        return (1, %ret);
                }
                if (! defined($ret{"$base\.Opt_DHCPv6_CID"})) {
                        vLogHTML('<FONT COLOR="#FF0000"><B>Renew Message MUST include CID option.</B></FONT> see 15.6 Renew Message(id-28)<BR>');
                        return (1, %ret);
                }
                return (0, %ret);
        }
        vLogHTML('<B>Could not get Renew Message</B><BR>');
        return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_rebind($if, $timeout,$na_or_pd)                     #

#  $na_or_pd = 0 : just want rebind message                    #
#  $na_or_pd = 1 : care rebind IA_NA                           #
#  $na_or_pd = 2 : care rebind IA_PD                           #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, rebind)                               #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_rebind($$$) {
	my ($if, $timeout, $na_or_pd) = @_;
	my ($initime,$wait_time) = (0,0);
	my $get_pd_release = 0;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Rebind";
	my %ret;
	my $found = 0;
	while (($wait_time < $timeout) && (!$found)){
		%ret = vRecvPacket($if, $timeout - $wait_time, 0, 0, "dhcp6_rebind");
		if($ret{"status"}!= 0){
			return ($ret{"status"},%ret);
		}
		if ($na_or_pd == 1) { 
			if (defined($ret{"$base\.Opt_DHCPv6_IA_NA"})) {
				$found = 1;
			} else {
				vLogHTML('<B>got DHCPv6 rebind IA_PD Message, send reply for that rerebind</B><BR>');
				$IA_NA_OPTION = undef;
				$IA_PD_OPTION = "opt_IA_PD_PF1";
				my ($retrep, %rep) = send_reply($if, "reply_server1_to_nut", \%ret,"");
			}
		} elsif ($na_or_pd == 2){
			if (defined($ret{"$base\.Opt_DHCPv6_IA_PD"})) {
				$found = 1;
			} else {
				vLogHTML('<B>got DHCPv6 rebind IA_NA Message, send reply for that rebind</B><BR>');
				$IA_NA_OPTION = "opt_IA_NA_Addr_woStatus";
				$IA_PD_OPTION = undef;
				my ($retrep, %rep) = send_reply($if, "reply_server1_to_nut", \%ret,"");
			} 
		}

		if (!$found) {
			if (!$initime) {
				$initime = $ret{'recvTime1'};
			} else {
				$wait_time = $ret{'recvTime1'} - $initime;
			}
		}
		
	}
	if ($found){
		if ($AUTH_OPTION_REQUIRED){
			$ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
		}
		parse_message(\%ret);
		if (defined($ret{"$base\.Opt_DHCPv6_SID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Rebind Message MUST NOT include SID option.</B></FONT> see 15.7 Rebind Message(id-28)<BR>');
			return (1, %ret);
		}
		if (! defined($ret{"$base\.Opt_DHCPv6_CID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Rebind Message MUST include CID option.</B></FONT> see 15.7 Rebind Message(id-28)<BR>');
			return (1, %ret);
		}
		return (0, %ret);
	} else {
		vLogHTML('<B>Did not get any expected renew Message</B><BR>');
		return (1, %ret);
	}
}

#--------------------------------------------------------------#
# wait_for_rebind2($if, $timeout)                              #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, rebind)                               #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_rebind2($$) {
        my ($if, $timeout) = @_;
        my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Rebind";
        
#       my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_rebind");
        my %ret = vRecvPacket2($if, $timeout, 0, 0, "dhcp6_rebind");
        if(defined($ret{"$base"})) {
                vLogHTML('<B>got DHCPv6 Rebind Message</B><BR>');
                if ($AUTH_OPTION_REQUIRED){
                        $ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
                }
                parse_message(\%ret);
                if (! defined($ret{"$base\.Opt_DHCPv6_CID"})) {
                        vLogHTML('<FONT COLOR="#FF0000"><B>Rebind Message MUST include CID option.</B></FONT> see 15.7 Rebind Message(id-28)<BR>');
                        return (1, %ret);
                }
                if (defined($ret{"$base\.Opt_DHCPv6_SID"})) {
                        vLogHTML('<FONT COLOR="#FF0000"><B>Rebind Message MUST NOT include SID option.</B></FONT> see 15.7 Rebind Message(id-28)<BR>');
                        return (1, %ret);
                }
                return (0, %ret);
        }
        vLogHTML('<B>Could not get Rebind Message</B><BR>');
        return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_release($if, $timeout)                              #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, release)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_release($$) {
	my ($if, $timeout) = @_;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Release";

#	my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_release");
	my %ret = vRecvPacket($if, $timeout, 0, 0, "dhcp6_release");
	if($ret{"status"}!= 0){
		return ($ret{"status"},%ret);
	}
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Release Message</B><BR>');
		if ($AUTH_OPTION_REQUIRED){
			$ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
		}
		parse_message(\%ret);
		if (! defined($ret{"$base\.Opt_DHCPv6_SID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Release Message MUST include SID option.</B></FONT> see 15.9 Release Message(id-28)<BR>');
			return (1, %ret);
		}
		if (! defined($ret{"$base\.Opt_DHCPv6_CID"})) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Release Message MUST include CID option.</B></FONT> see 15.9 Release Message(id-28)<BR>');
			return (1, %ret);
		}
		return (0, %ret);
	}
	vLogHTML('<B>Could not get Release Message</B><BR>');
	return (1, %ret);
}
#--------------------------------------------------------------#
# wait_for_release2($if, $timeout,$na_or_pd)                     #

#  $na_or_pd = 0 : just want release message                    #
#  $na_or_pd = 1 : care release IA_NA                           #
#  $na_or_pd = 2 : care release IA_PD                           #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, release)                               #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_release2($$$) {
	my ($if, $timeout, $na_or_pd) = @_;
	my ($initime,$wait_time) = (0,0);
	my $get_pd_release = 0;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Release";
	my %ret;
	my $found = 0;
	while (($wait_time < $timeout) && (!$found)){
		%ret = vRecvPacket($if, $timeout - $wait_time, 0, 0, "dhcp6_release");
		if($ret{"status"}!= 0){
			return ($ret{"status"},%ret);
		}
		if ($na_or_pd == 1) { 
			if (defined($ret{"$base\.Opt_DHCPv6_IA_NA"})) {
				$found = 1;
			} else {
				vLogHTML('<B>got DHCPv6 release IA_PD Message, send reply for that release</B><BR>');
				$IA_NA_OPTION = undef;
				my ($retrep, %rep) = send_reply($if, "reply_server1_to_nut", \%ret,"");
			}
		} elsif ($na_or_pd == 2){
			if (defined($ret{"$base\.Opt_DHCPv6_IA_PD"})) {
				$found = 1;
			} else {
				vLogHTML('<B>got DHCPv6 release IA_NA Message, send reply for that release</B><BR>');
				$IA_PD_OPTION = undef;
				my ($retrep, %rep) = send_reply($if, "reply_server1_to_nut", \%ret,"");
			} 
		}

		if (!$found) {
			if (!$initime) {
				$initime = $ret{'recvTime1'};
			} else {
				$wait_time = $ret{'recvTime1'} - $initime;
			}
		}
		
	}
	if ($found){
		vLogHTML('<B>Got expected DHCPv6 Release Message</B><BR>');
		parse_message(\%ret);
		return (0, %ret);
	} else {
		vLogHTML('<B>Did not get any expected release Message</B><BR>');
		return (1, %ret);
	}
}
#--------------------------------------------------------------#
# wait_for_reply($if, $timeout)                                #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, reply)                                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_reply($$) {
	my ($if, $timeout) = @_;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Reply";

	my %ret = vRecvPacket($if, $timeout, 0, 0, "dhcp6_reply");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Reply Message</B><BR>');
		if ($AUTH_OPTION_REQUIRED){
			$ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
		}
		parse_message(\%ret);
		return (0, %ret);
	}
	vLogHTML('<B>Could not get Reply Message</B><BR>');
	return (1, %ret);
}
#--------------------------------------------------------------#
# wait_for_reply2($if, $timeout)                               #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, reply)                                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_reply2($$) {
        my ($if, $timeout) = @_;
        my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Reply";

        my %ret = vRecvPacket2($if, $timeout, 0, 0, "dhcp6_reply");
        if(defined($ret{"$base"})) {
                vLogHTML('<B>got DHCPv6 Reply Message</B><BR>');
                if ($AUTH_OPTION_REQUIRED){
                        $ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_A
uthentication\.ReplayDetection"};
                }
                parse_message(\%ret);
                return (0, %ret);
        }
        vLogHTML('<B>Could not get Reply Message</B><BR>');
        return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_reconfigure($if, $timeout)                          #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, reconfigure)                          #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_reconfigure($$) {
	my ($if, $timeout) = @_;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Reconfigure";

	my %ret = vRecvPacket($if, $timeout, 0, 0, "dhcp6_reconfigure");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Reconfigure Message</B><BR>');
		$ret{'Recv_RecMsgType'} = $ret{"$base\.Opt_DHCPv6_Reconfigure\.Type"};
		parse_message(\%ret);
		return (0, %ret);
	}
	vLogHTML('<B>Could not get Reconfigure Message</B><BR>');
	return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_information_request($if, $timeout)                  #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, information_request)                  #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_information_request($$) {
	my ($if, $timeout) = @_;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_InformationRequest";
	
#	my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_information_request");
	my %ret = vRecvPacket($if, $timeout, 0, 0, "dhcp6_information_request");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Information-request Message</B><BR>');
		if ($AUTH_OPTION_REQUIRED){
			$ret{'Recv_ReplayDetection'} = $ret{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"};
		}
		parse_message(\%ret);
		return (0, %ret);
	}
	vLogHTML('<B>Could not get Information-request Message</B><BR>');
	return (1, %ret);
}
#--------------------------------------------------------------#
# wait_for_decline($if, $timeout)                              #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, decline)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_decline($$) {
	my ($if, $timeout) = @_;
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Decline";
#	my %ret = vRecv3($if, $timeout, 0, 0, "dhcp6_decline");
	my %ret = vRecvPacket($if, $timeout, 0, 0, "dhcp6_decline");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Decline Message</B><BR>');
		parse_message(\%ret);
		return (0, %ret);
	}
	vLogHTML('<B>Could not get Decline Message</B><BR>');
	return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_relay_forward($if, $maxcount,$strFramename)         #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_forward_solicit)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_forward($$$){
	my ($if, $maxcount,$strFramename) = @_;

	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);

	my $strbase = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayForward";
	my $retrycount = 0;
	for(my $count=0;$count<$maxcount;$count++){
		my %ret = vRecvPacket($if, 5, 0, 0,"$strFramename");
	#	my %ret = vRecvPacket2($if, 5, 0, 0,"$strFramename");
		if(0 != $ret{"status"} ||(!defined( $ret{$strbase}))){
#			dhcpExitError("NG: Can not receive expected Relay Forward Message");
			return (1, %ret);
		}
		elsif( 0 == $ret{"status"}){
			parse_relay_message(\%ret);
			return (0,%ret);
		}
	}
}

#--------------------------------------------------------------#
# wait_for_relay_forward_solicit($if, $maxcount)               #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_forward_solicit)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_forward_solicit($$) {
	my ($if, $maxcount) = @_;

	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);

	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayForward\.Opt_DHCPv6_RelayMessage\.Udp_DHCPv6_Solicit";
	my $retrycount = 0;
retry:
	my %ret = vRecvPacket($if, 5, 0, 0,"relayforward_solicit_nut_to_server1");
	if($ret{'status'}){
		vLogHTML('<B>Could not get Relay Forward Message(Solicit)</B><BR>');
		return (1,%ret);
	}
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Relay Forward Message(Solicit)</B><BR>');
		parse_relay_message(\%ret);
		return (0, %ret);
	}
	
	if ($retrycount < $maxcount) {
		$retrycount++;
		goto retry;
	}
	vLogHTML('<B>Could not get Relay Forward Message(Solicit)</B><BR>');
	return (1, %ret);
}


#--------------------------------------------------------------#
# wait_for_relay_forward_request($if, $maxcount)               #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_forward_request)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_forward_request($$) {
	my ($if, $maxcount) = @_;
 
	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);

	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayForward\.Opt_DHCPv6_RelayMessage\.Udp_DHCPv6_Request";
	my $retrycount = 0;
retry:
	my %ret = vRecvPacket($if, 5, 0, 0,"relayforward_request_nut_to_server1");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Relay Forward Message(Request)</B><BR>');
		parse_relay_message(\%ret);
		return (0, %ret);
	}
	
	if ($retrycount < $maxcount) {
		$retrycount++;
		goto retry;
	}
	vLogHTML('<B>Could not get Relay Forward Message(Request)</B><BR>');
	return (1, %ret);
}


#--------------------------------------------------------------#
# wait_for_relay_forward_confirm($if, $maxcount)               #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_forward_request)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_forward_confirm($$) {
	my ($if, $maxcount) = @_;

	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);

	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayForward\.Opt_DHCPv6_RelayMessage\.Udp_DHCPv6_Confirm";
	my $retrycount = 0;
retry:
	my %ret = vRecvPacket($if, 5, 0, 0,"relayforward_confirm_nut_to_server1");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Relay Forward Message(Confirm)</B><BR>');
		parse_relay_message(\%ret);
		return (0, %ret);
	}
	
	if ($retrycount < $maxcount) {
		$retrycount++;
		goto retry;
	}
	vLogHTML('<B>Could not get Relay Forward Message(Confirm)</B><BR>');
	return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_relay_forward_renew($if, $maxcount)                 #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_forward_request)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_forward_renew($$) {
	my ($if, $maxcount) = @_;

	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);

	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayForward\.Opt_DHCPv6_RelayMessage\.Udp_DHCPv6_Renew";
	my $retrycount = 0;
retry:
	my %ret = vRecvPacket($if, 5, 0, 0,"relayforward_renew_nut_to_server1");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Relay Forward Message(Renew)</B><BR>');
		parse_relay_message(\%ret);
		return (0, %ret);
	}
	
	if ($retrycount < $maxcount) {
		$retrycount++;
		goto retry;
	}
	vLogHTML('<B>Could not get Relay Forward Message(Renew)</B><BR>');
	return (1, %ret);
}


#--------------------------------------------------------------#
# wait_for_relay_forward_rebind($if, $maxcount)                 #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_forward_request)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_forward_rebind($$) {
	my ($if, $maxcount) = @_;

	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);

	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayForward\.Opt_DHCPv6_RelayMessage\.Udp_DHCPv6_Rebind";
	my $retrycount = 0;
retry:
	my %ret = vRecvPacket($if, 5, 0, 0,"relayforward_rebind_nut_to_server1");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Relay Forward Message(Rebind)</B><BR>');
		parse_relay_message(\%ret);
		return (0, %ret);
	}
	
	if ($retrycount < $maxcount) {
		$retrycount++;
		goto retry;
	}
	vLogHTML('<B>Could not get Relay Forward Message(Rebind)</B><BR>');
	return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_relay_forward_release($if, $maxcount)                 #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_forward_request)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_forward_release($$) {
	my ($if, $maxcount) = @_;

	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);

	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayForward\.Opt_DHCPv6_RelayMessage\.Udp_DHCPv6_Release";
	my $retrycount = 0;
retry:
	my %ret = vRecvPacket($if, 5, 0, 0,"relayforward_release_nut_to_server1");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Relay Forward Message(Release)</B><BR>');
		parse_relay_message(\%ret);
		return (0, %ret);
	}
	
	if ($retrycount < $maxcount) {
		$retrycount++;
		goto retry;
	}
	vLogHTML('<B>Could not get Relay Forward Message(Release)</B><BR>');
	return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_relay_forward_decline($if, $maxcount)                 #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_forward_request)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_forward_decline($$) {
	my ($if, $maxcount) = @_;

	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);

	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayForward\.Opt_DHCPv6_RelayMessage\.Udp_DHCPv6_Decline";
	my $retrycount = 0;
retry:
	my %ret = vRecvPacket($if, 5, 0, 0,"relayforward_decline_nut_to_server1");
	if(defined($ret{"$base"})) {
		vLogHTML('<B>got DHCPv6 Relay Forward Message(Decline)</B><BR>');
		parse_relay_message(\%ret);
		return (0, %ret);
	}
	
	if ($retrycount < $maxcount) {
		$retrycount++;
		goto retry;
	}
	vLogHTML('<B>Could not get Relay Forward Message(Decline)</B><BR>');
	return (1, %ret);
}
#--------------------------------------------------------------------#
# wait_for_relay_reply($if, $maxcount,$framename,$mod)               #
# Now only support 1 relay agent                                     #
# mod:  adv& reply                                                   #
#--------------------------------------------------------------------#
sub wait_for_relay_reply($$$$) {
	my ($if, $maxcount,$framename,$mod) = @_;

	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);

	my %replymsgtype = (
		"Advertise" => ".Udp_DHCPv6_Advertise",
		"Reply" => ".Udp_DHCPv6_Reply",
		"Relay" => ".Udp_DHCPv6_RelayReply"
		);
	$framename = "relay_reply_nut_relay" if(!defined($framename));	
	my $Relay_reply_base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayReply\.Opt_DHCPv6_RelayMessage";

	my %ret = ();
	for(my $i=0;$i<$maxcount;$i++){
		%ret = vRecvPacket($if, 5, 0, 0,$framename);
		if(defined($ret{$Relay_reply_base}) && (0 == $ret{'status'})){
			parse_relay_message(\%ret);
			if(!defined($replymsgtype{$mod})){
				#vLogHTML("<B>The expected message type is $mod</B><BR>");
				vLogHTML('<B>The type of message which be relayed is not correct!</B><BR>');
				return (1,%ret);
			}
			my $strIndex = $Relay_reply_base.$replymsgtype{$mod};
			DebugStrOut("The Index is $strIndex");
			if(defined($ret{$strIndex})){
				vLogHTML('<B>Received DHCPv6 Relay Reply Message</B><BR>');
				return (0, %ret);
			}
		}
	}
	vLogHTML("<B>Could not get expected Relay Reply Message ($mod)</B><BR>");
	return (1, %ret);
}
#--------------------------------------------------------------------#
# wait_for_relay_reply2($if, $maxcount,$framename,$mod)              #
# Now only support 1 Delegating Router                               #
# mod:  adv& reply                                                   #
#--------------------------------------------------------------------#
sub wait_for_relay_reply2($$$$) {
        my ($if, $maxcount,$framename,$mod) = @_;

        my $cpp = undef;
        my $type=$V6evalTool::NutDef{Type};
        if($type eq 'router') {
                $cpp .= ' -D LINK1';
        }
        $cpp .= ' -D SERVERRELAY';
        vCPP($cpp);

        my %replymsgtype = (
                "Advertise" => ".Udp_DHCPv6_Advertise",
                "Reply" => ".Udp_DHCPv6_Reply",
                "Relay" => ".Udp_DHCPv6_RelayReply"
                );
        $framename = "relay_reply_nut_relay" if(!defined($framename));  
        my $Relay_reply_base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_RelayReply\.Opt_DHCPv6_RelayMessage";

        my %ret = ();
        for(my $i=0;$i<$maxcount;$i++){
                %ret = vRecvPacket2($if, 5, 0, 0,$framename);
                if(defined($ret{$Relay_reply_base}) && (0 == $ret{'status'})){
                        parse_relay_message(\%ret);
                        if(!defined($replymsgtype{$mod})){
                                #vLogHTML("<B>The expected message type is $mod</B><BR>");
                                vLogHTML('<B>The type of message which be relayed is not correct!</B><BR>');
                                return (1,%ret);
                        }
                        my $strIndex = $Relay_reply_base.$replymsgtype{$mod};
                        DebugStrOut("The Index is $strIndex");
                        if(defined($ret{$strIndex})){
                                vLogHTML('<B>Received DHCPv6 Relay Reply Message</B><BR>');
                                return (0, %ret);
                        }
                }
        }
        vLogHTML("<B>Could not get expected Relay Reply Message ($mod)</B><BR>");
        return (1, %ret);
}

#--------------------------------------------------------------#
# wait_for_relay_reply_advertise($if, $maxcount,$strFrameName) #
# for 1 relay's test case                                      #     
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_reply_advertise)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_reply_advertise($$$) {
	my ($if, $maxcount,$strFrameName) = @_;
	return wait_for_relay_reply($if,$maxcount,$strFrameName,'Advertise');
}
#--------------------------------------------------------------#
# wait_for_relay_reply_advertise2($if, $maxcount,$strFrameName)#
# for 1 Delegating Router's test case                          #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_reply_advertise)                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_reply_advertise2($$$) {
        my ($if, $maxcount,$strFrameName) = @_;
        return wait_for_relay_reply2($if,$maxcount,$strFrameName,'Advertise');
}

#--------------------------------------------------------------#
# wait_for_relay_reply_reply($if, $maxcount,$strFrameName)     #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_reply_reply)                    #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_reply_reply($$;$) {
	my ($if, $maxcount,$strFrameName) = @_;
	return wait_for_relay_reply($if,$maxcount,$strFrameName,'Reply');
}
#--------------------------------------------------------------#
# wait_for_relay_reply_reply2($if, $maxcount,$strFrameName)    #
#                                                              #
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_reply_reply)                    #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_reply_reply2($$;$) {
        my ($if, $maxcount,$strFrameName) = @_;
        return wait_for_relay_reply2($if,$maxcount,$strFrameName,'Reply');
}

#--------------------------------------------------------------#
# wait_for_relay_reply_relay($if, $maxcount)                   #
#                                                              #     
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_reply_relay)                    #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_reply_relay($$$) {
	my ($if, $maxcount,$strFrameName) = @_;
	return wait_for_relay_reply($if,$maxcount,$strFrameName,'Relay');
}

#--------------------------------------------------------------#
# wait_for_relay_reply_relay2($if, $maxcount)                  #
#                                                              #     
# Notes:                                                       #
#                                                              #
#    SUCCESS: return (0, relay_reply_relay2)                   #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_relay_reply_relay2($$$) {
        my ($if, $maxcount,$strFrameName) = @_;
        return wait_for_relay_reply2($if,$maxcount,$strFrameName,'Relay');
}

#--------------------------------------------------------------#
# send_relay_forward($if, $relaymsg)                           #
#                                                              #
# Notes:                                                       #
#    make Relayforward Message                                 #
#    SUCCESS: return (0, %ret)                                 #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_relay_forward($$) {
	my ($if, $relaymsg) = @_;
	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';

#	#for send relay-forward request
#	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayReply.Udp_DHCPv6_Advertise";
#
# 	if(defined($SID_OPTION)){
# 		my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($relaymsg,$base);
# 		$cpp .= $cpp_cp;
# 	}	
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);
	my %ret = vSend3($if, $relaymsg);
	parse_relay_message(\%ret);
	return (0, %ret) if(0 == $ret{status});
	return (1, %ret);
}

#--------------------------------------------------------------#
# send_relay_forward2($if, $relaymsg)                           #
#                                                              #
# Notes:                                                       #
#    make Relayforward Message                                 #
#    SUCCESS: return (0, %ret)                                 #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_relay_forward2($$) {
        my ($if, $relaymsg) = @_;
        my $cpp = undef;
        my $type=$V6evalTool::NutDef{Type};
#        if($type eq 'router') {
#                $cpp .= ' -D LINK1';
#        }
        $cpp .= ' -D SERVERRELAY';

#       #for send relay-forward request
#       my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayReply.Udp_DHCPv6_Advertise";
#
#       if(defined($SID_OPTION)){
#               my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($relaymsg,$base);
#               $cpp .= $cpp_cp;
#       }       
        createPacketDefinitionFile("DHCPv6_test_pkt.def");
        vCPP($cpp);
        my %ret = vSend3($if, $relaymsg);
        parse_relay_message(\%ret);
        return (0, %ret) if(0 == $ret{status});
        return (1, %ret);
}

#--------------------------------------------------------------#
# send_relay_forward_request($if, $relaymsg, $relayreply, $cpp)#
#                                                              #
# Notes:                                                       #
#    make Relayforward Message                                 #
#    SUCCESS: return (0, %ret)                                 #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_relay_forward_request($$$$) {
	my ($if, $relaymsg, $relayadvertise, $cpp) = @_;

	$cpp = defined($cpp) ? $cpp : '';
	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';

	#for send relay-forward request
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayReply.Opt_DHCPv6_RelayMessage.Udp_DHCPv6_Advertise";

 	if(defined($SID_OPTION)){
 		my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($relayadvertise,$base);
 		$cpp .= $cpp_cp;
 	}	
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);
	my %ret = vSend3($if, $relaymsg);
	parse_relay_message(\%ret);
	return (0, %ret) if(0 == $ret{status});
	return (1, %ret);
}

#----------------------------------------------------------------------#
# send_layered_relay_forward_request($if, $relaymsg, $relayreply, $cpp)#
#                                                                      #
# Notes:                                                               #
#    make Relayforward Message                                         #
#    SUCCESS: return (0, %ret)                                         #
#    FAILURE: return (1, ???)                                          #
#----------------------------------------------------------------------#
sub send_layered_relay_forward_request($$$$) {
        my ($if, $relaymsg, $relayadvertise, $cpp) = @_;

        $cpp = defined($cpp) ? $cpp : '';
        my $type=$V6evalTool::NutDef{Type};
        if($type eq 'router') {
                $cpp .= ' -D LINK1';
        }
        $cpp .= ' -D SERVERRELAY';

        #for send relay-forward request
        my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayReply.Opt_DHCPv6_RelayMessage.Udp_DHCPv6_RelayReply.Opt_DHCPv6_RelayMessage.Udp_DHCPv6_Advertise";

        if(defined($SID_OPTION)){
                my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($relayadvertise,$base);
                $cpp .= $cpp_cp;
        }       
        createPacketDefinitionFile("DHCPv6_test_pkt.def");
        vCPP($cpp);
        my %ret = vSend3($if, $relaymsg);
        parse_relay_message(\%ret);
        return (0, %ret) if(0 == $ret{status});
        return (1, %ret);
}

#--------------------------------------------------------------#
# send_invalid_relay_reply($if, $relaymsg)                     #
#                                                              #
# Notes:                                                       #
#    make RelayReply Message                                   #
#    SUCCESS: return (0, %ret)                                 #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_invalid_relay_reply($$) {
        my ($if, $relaymsg) = @_;
        my $cpp = undef;
        my $type=$V6evalTool::NutDef{Type};
#        if($type eq 'router') {
#                $cpp .= ' -D LINK1';
#        }
        $cpp .= ' -D SERVERRELAY';

#       #for send relay-forward request
#       my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayReply.Udp_DHCPv6_Advertise";
#
#       if(defined($SID_OPTION)){
#               my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($relaymsg,$base);
#               $cpp .= $cpp_cp;
#       }       
        createPacketDefinitionFile("DHCPv6_test_pkt.def");
        vCPP($cpp);
        my %ret = vSend3($if, $relaymsg);
        parse_relay_message(\%ret);
        return (0, %ret) if(0 == $ret{status});
        return (1, %ret);
}

#--------------------------------------------------------------#
# sub send_relay_reply($if,$relay_reply,$solicit,$cpp)         #
#                                                              #
#Notes:                                                        #
#       Send relay-reply message to the relay agent            #
#       Success: return (0, relay-reply);                      #
#       Fail: return (1,????);                                 #
#--------------------------------------------------------------#
sub send_relay_reply($$$$){
	my ($if,$relay_reply,$solicit,$cpp) = @_;

	$cpp = defined($cpp) ? $cpp : '';
	
	#if NUT sends IID option, TN copes it.
	if( 0 ==options_exist($solicit,$CMP_IID)){
		$cpp .= '-D INSERT_IID=1';
		my $ID = $$solicit{"Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayForward.Opt_DHCPv6_IID.Identifier"};
		$cpp .= " -D\'IID_IDENTIFIER=$ID\' ";
	}

	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	$cpp .= MakeCppForReplyMessage($solicit,".Udp_DHCPv6_RelayForward.Opt_DHCPv6_RelayMessage");

	my $type=$V6evalTool::NutDef{Type};
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);
	#printf("cpp is $cpp<BR>");

	my %ret = vSend3($if,$relay_reply);
	parse_relay_message(\%ret);
	return (0,%ret);
}

#--------------------------------------------------------------#
# sub send_relay_reply2($if,$relay_reply,$solicit,$cpp)         #
#                                                              #
#Notes:                                                        #
#       Send relay-reply message to the relay agent            #
#       Success: return (0, relay-reply);                      #
#       Fail: return (1,????);                                 #
#--------------------------------------------------------------#
sub send_relay_reply2($$$$){
        my ($if,$relay_reply,$solicit,$cpp) = @_;

        $cpp = defined($cpp) ? $cpp : '';
 
        #if NUT sends IID option, TN copes it.
        if( 0 ==options_exist($solicit,$CMP_IID)){
                $cpp .= '-D INSERT_IID=1';
                my $ID = $$solicit{"Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayForward.Opt_DHCPv6_IID.Identifier"};
                $cpp .= " -D\'IID_IDENTIFIER=$ID\' ";
        }

        createPacketDefinitionFile("DHCPv6_test_pkt.def");
        $cpp .= MakeCppForReplyMessage($solicit,".Udp_DHCPv6_RelayForward.Opt_DHCPv6_RelayMessage");

        my $type=$V6evalTool::NutDef{Type};
#        if($type eq 'router') {
#                $cpp .= ' -D LINK1';
#        }
        $cpp .= ' -D SERVERRELAY';
        vCPP($cpp);
        #printf("cpp is $cpp<BR>");

        my %ret = vSend3($if,$relay_reply);
        parse_relay_message(\%ret);
        return (0,%ret);
}

#--------------------------------------------------------------#
# send_solicit($if, $solicit, $cpp)                            #
#                                                              #
# Notes:                                                       #
#    make Solicit Message                                      #
#    SUCCESS: return (0, solicit)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_solicit($$$) {
	my ($if, $solicit, $cpp) = @_;
	$cpp = defined($cpp) ? $cpp : '';
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);
	my %ret = vSend3($if, $solicit);
	parse_message(\%ret);
	return (0, %ret) if(0 == $ret{status});
	return (1, %ret);
}
#--------------------------------------------------------------#
# send_invalid_advertise($if, $advertise, $cpp)                #
#                                                              #
# Notes:                                                       #
#    make Invalid Advertise Message                            #
#    SUCCESS: return (0, advertise)                            #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_invalid_advertise($$$) {
        my ($if, $advertise, $cpp) = @_;
        $cpp = defined($cpp) ? $cpp : '';
        createPacketDefinitionFile("DHCPv6_test_pkt.def");
        vCPP($cpp);
        my %ret = vSend3($if, $advertise);
        parse_message(\%ret);
        return (0, %ret) if(0 == $ret{status});
        return (1, %ret);
}
#--------------------------------------------------------------#
# send_invalid_reply($if, $reply, $cpp)                        #
#                                                              #
# Notes:                                                       #
#    make Invalid Reply Message                                #
#    SUCCESS: return (0, reply)                                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_invalid_reply($$$) {
        my ($if, $reply, $cpp) = @_;
        $cpp = defined($cpp) ? $cpp : '';
        createPacketDefinitionFile("DHCPv6_test_pkt.def");
        vCPP($cpp);
        my %ret = vSend3($if, $reply);
        parse_message(\%ret);
        return (0, %ret) if(0 == $ret{status});
        return (1, %ret);
}


#--------------------------------------------------------------#
# send_advertise($if, $advertise, $solicit, $cpp)              #
#                                                              #
# Notes:                                                       #
#    make Advertise Message by using received Solicit          #
#    SUCCESS: return (0, advertise)                            #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_advertise($$$$) {
	my ($if, $advertise, $solicit, $cpp) = @_;
	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Solicit";
	my $optstr = "";
	my $cppstr = "";
	# make packet definition
	#
	#
	#
	
        $cppstr .= SetCidOption($solicit, $base);
	print "**********************************\n";
	print "cppstr = $cppstr \n";
	print "**********************************\n";
	
#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"};
#  		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=ether(\"$optstr\")\' ";
#	}	
#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"};
#		$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
#	}
	
	# when receive DUID Code =1 and Hareware type is not 1
#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"};
#		$cppstr .= " -D\'NUT_DUID_HARDWARE_TYPE = $optstr\' ";
#	}
#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"};
#		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=hexstr(\"$optstr\")\' ";
#	}	
#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"};
#		$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
#	}	
	
		
	if(defined($$solicit{"$base.Identifier"}))
	{
    	$optstr = $$solicit{"$base.Identifier"};
		$cppstr .= " -D\'ID_ADV=$optstr\' ";
	}
	# set IA Options
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_NA.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_NA.Identifier"};
		$cppstr .= " -D\'IA_NA_IDENTIFIER=$optstr\' ";
	}
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_TA.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_TA.Identifier"};
		$cppstr .= " -D\'IA_TA_IDENTIFIER=$optstr\' ";
	}
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_PD.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_PD.Identifier"};
		$cppstr .= " -D\'IA_PD_IDENTIFIER=$optstr\' ";
	}
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	print "\n cpp: $cppstr \n";
	$cppstr .= $cpp;
	vCPP($cppstr);

	# send DHCPv6 Advertise Message
	my %ret = vSend3($if, $advertise);
	parse_message(\%ret);
	return (0, %ret) if(0 == $ret{status});
	return (1, %ret);
}

sub send_advertise1($$$$) {
	my ($if, $advertise, $solicit, $cpp) = @_;

	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Solicit";
	my $optstr = "";
	my $cppstr = "";
	
	
	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"}))
	{
		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"};
  		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=ether(\"$optstr\")\' ";
	}	
	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"}))
	{
		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"};
		$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
	}
	
	# when receive DUID Code =1 and Hareware type is not 1
	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"}))
	{
		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"};
		$cppstr .= " -D\'NUT_DUID_HARDWARE_TYPE = $optstr\' ";
	}
	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"}))
	{
		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"};
		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=hexstr(\"$optstr\")\' ";
	}	
	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"}))
	{
		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"};
		$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
	}	
	
		
	if(defined($$solicit{"$base.Identifier"}))
	{
    	$optstr = $$solicit{"$base.Identifier"};
		$cppstr .= " -D\'ID_ADV=$optstr\' ";
	}
	# set IA Options
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_NA.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_NA.Identifier"};
		$cppstr .= " -D\'IA_NA_IDENTIFIER=$optstr\' ";
	}
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_TA.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_TA.Identifier"};
		$cppstr .= " -D\'IA_TA_IDENTIFIER=$optstr\' ";
	}
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_PD.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_PD.Identifier"};
		$cppstr .= " -D\'IA_PD_IDENTIFIER=$optstr\' ";
	}
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	print "\n cpp: $cppstr \n";
	$cppstr .= $cpp;
	vCPP($cppstr);

	# send DHCPv6 Advertise Message
	my %ret = vSend3($if, $advertise);
	parse_message(\%ret);
	return (0, %ret) if(0 == $ret{status});
	return (1, %ret);
}
#--------------------------------------------------------------#
# send_advertise2($if, $advertise, $solicit, $cpp)             #
#                                                              #
# Notes:                                                       #
#    make Advertise Message by using received Solicit          #
#    SUCCESS: return (0, advertise)                            #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_advertise2($$$$) {
	my ($if, $advertise, $solicit, $cpp) = @_;

	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Solicit";
	my $optstr = "";
	my $cppstr = "";
	# make packet definition

#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"};
#   		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=ether(\"$optstr\")\' ";
#	}	
#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"};
#		$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
#	}
	
	# when receive DUID Code =1 and Hareware type is not 1
#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"};
#		$cppstr .= " -D\'NUT_DUID_HARDWARE_TYPE = $optstr\' ";
#	}
#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"};
#		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=hexstr(\"$optstr\")\' ";
#	}	
#	if(defined($$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"}))
#	{
#		$optstr = $$solicit{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"};
#		$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
#	}	
	
	$cppstr .= SetCidOption($solicit, $base);		
	if(defined($$solicit{"$base.Identifier"}))
	{
    	$optstr = $$solicit{"$base.Identifier"};
		$cppstr .= " -D\'ID_ADV=$optstr\' ";
	}
	

	# set IA Options
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_NA.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_NA.Identifier"};
		$cppstr .= " -D\'IA_NA_IDENTIFIER_1=$optstr\' "
	}
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_TA.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_TA.Identifier"};
		$cppstr .= " -D\'IA_TA_IDENTIFIER=$optstr\' ";
	}
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_PD.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_PD.Identifier"};
		$cppstr .= " -D\'IA_PD_IDENTIFIER=$optstr\' ";
	}

	if(defined($$solicit{"$base.Opt_DHCPv6_IA_TA.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_TA.Identifier"};
		$cppstr .= " -D\'IA_TA_IDENTIFIER_2=$optstr\' ";
	}
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_NA.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_NA2.Identifier"};
		$cppstr .= " -D\'IA_NA_IDENTIFIER_2=$optstr\' "
	}
	if(defined($$solicit{"$base.Opt_DHCPv6_IA_PD.Identifier"}))
	{
	   	$optstr = $$solicit{"$base.Opt_DHCPv6_IA_PD2.Identifier"};
		$cppstr .= " -D\'IA_PD_IDENTIFIER_2=$optstr\' ";
	}
	
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
#	print "\n cpp: $cppstr \n";
	$cppstr .= $cpp;
	vCPP($cppstr);

	# send DHCPv6 Advertise Message
	my %ret = vSend3($if, $advertise);
	parse_message(\%ret);
	return (0, %ret) if(0 == $ret{status});
	return (1, %ret);
}

#--------------------------------------------------------------#
# GetSvrDUIDfromPreMsg( $ref_mag, $base)                       #
#                                                              #
# Notes:                                                       #
#    make $cpp for DUID from last message                      #
#    SUCCESS: return (0, $cpp)                                 #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub GetSvrDUIDfromPreMsg($$){
	my ($ref_msg,$base) = @_;
	my %DUIDTYPE = ("DHCPv6_DUID_LLT_Ether"=>1,
			"DHCPv6_DUID_EN"=>2,
			"DHCPv6_DUID_LL_Ether"=>3
			);
	my $duidtype = undef;
	my $duidindexname = undef;
	my $cpp = undef;


	foreach (keys %DUIDTYPE) {
		if(defined($$ref_msg{"$base.Opt_DHCPv6_SID.$_"})){
			$duidindexname = $base.".Opt_DHCPv6_SID.".$_;
			$duidtype = $DUIDTYPE{$_};
			last;
		}
	}

	vLogHTML("index str is $duidindexname<BR>" );
	
	my $hexData = undef;	
	if(defined($duidtype)){

		if(1 == $duidtype || 3 == $duidtype){
			my $hardwaretype = $$ref_msg{"$duidindexname.HardwareType"};
			my $time = $$ref_msg{"$duidindexname.Time"};
			my $linkerlayeraddress = $$ref_msg{"$duidindexname.LinkLayerAddress"};
			$linkerlayeraddress =~ s/://g;
			my $endofaddress = $$ref_msg{"$duidindexname.[Needless].data"};

			if(defined($endofaddress)){
				$linkerlayeraddress .= $endofaddress;
			}

			if(1 == $duidtype){
				$hexData = sprintf("%04x%08x",$hardwaretype,$time);
				$hexData .= $linkerlayeraddress;
				$cpp = " -D\'DUIDANY_SID_TYPE=1\' ";
			}
			else{
				$hexData = sprintf("%04x",$hardwaretype);
				$hexData .= $linkerlayeraddress;
				$cpp = " -D\'DUIDANY_SID_TYPE=3\' ";
			}
			if( (!defined($hardwaretype)) || (!defined($linkerlayeraddress))){
				vLogHTML("The format of DUID is wrong!<BR>");
				vLogHTML("Hardware type: $hardwaretype<BR>");
				vLogHTML("linkerlayeraddress is $linkerlayeraddress<BR>");
				vLogHTML("hexData is $hexData<BR>");
				
				return (1,$cpp);
			}
			if((!defined($time)) && (1 == $duidtype)){
				vLogHTML("The format of DUID is wrong!<BR>");
				vLogHTML("time is $time<BR>");
				vLogHTML("hexData is $hexData<BR>");
				return (1,$cpp);
			}
		
			$cpp .= " -D\'DUIDANY_SID_DATA=hexstr(\"$hexData\")\' ";
		}	
		elsif( 2 == $duidtype){
			my $enterprisenumber = $$ref_msg{"$duidindexname.EnterpriseNumber"};
			my $id = $$ref_msg{"$duidindexname.Identifier"};
			my $endofid = $$ref_msg{"$duidindexname.[Needless].data"};
			if(defined($endofid)){
				$id .= $endofid;
			}
			
			$cpp = " -D\'DUIDANY_SID_TYPE=2\' ";
		
			$hexData = sprintf("%08x",$enterprisenumber);
			$hexData .= $id;
			if( (!defined($enterprisenumber)) || (!defined($id ))){
				vLogHTML("The format of DUID is wrong!<BR>");
				vLogHTML("Enterprisenumber: $enterprisenumber<BR>");
				vLogHTML("ID is $id<BR>");
				vLogHTML("hexData is $hexData<BR>");
				return (1,$cpp);
			}
			$cpp .= " -D\'DUIDANY_SID_DATA=hexstr(\"$hexData\")\' ";
		}
	}
	else{
	#	vLogHTML("Can not found DUID in this message<BR>");
		return (1,$cpp);
	}	
	#vLogHTML("The value of cpp is $cpp<BR>");
	return (0,$cpp);
}

#--------------------------------------------------------------#
# send_request($if, $request, $advertise, $cpp)                #
#                                                              #
# Notes:                                                       #
#    make Request Message by using received Advertisement      #
#    SUCCESS: return (0, request)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_request($$$$) {
	my ($if, $request, $advertise, $cpp) = @_;

	$cpp = defined($cpp) ? $cpp : '';

	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Advertise";
	
	my $optstr = "";

	my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($advertise,$base);
	$cpp .= $cpp_cp;
	
	if(defined($$advertise{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"}))
	{
		$optstr = $$advertise{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"};
		$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
	}

	#In a message
	#   sent by a delegating router to a requesting router, the requesting
	#   router MUST use the values in the T1 and T2 fields for the T1 and T2
	#   parameters.  The values in the T1 and T2 fields are the number of
	#   seconds until T1 and T2.
	if(defined($$advertise{"$base.Opt_DHCPv6_IA_PD"}))
	{
    	$optstr = $$advertise{"$base.Opt_DHCPv6_IA_PD.Time1"};
		$cpp .= " -D\'IA_PD_TIME1=$optstr\' " if $optstr;
    	$optstr = $$advertise{"$base.Opt_DHCPv6_IA_PD.Time2"};
		$cpp .= " -D\'IA_PD_TIME2=$optstr\' " if $optstr;
	}

	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);

	# send DHCPv6 Request Message
	my %ret = vSend3($if, $request);
	parse_message(\%ret);
	return (0, %ret) if(0 == $ret{status});
	return (1, %ret);
}
#--------------------------------------------------------------#
# send_confirm($if, $confirm, $reply, $cpp)                    #
#                                                              #
# Notes:                                                       #
#    make Confirm Message by using received Reply              #
#    SUCCESS: return (0, confirm)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_confirm($$$$) {
	my ($if, $confirm, $reply, $cpp) = @_;
	
	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Reply";
	my $optstr = "";

	# make packet definition
	#$SID_OPTION = undef;
	#Comment: the SID Must not in Confrim message!!!
	if(defined($SID_OPTION)){
		my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($reply,$base);
		$cpp .= $cpp_cp;
	}
	
	if(defined($$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"}))
	{
		$optstr = $$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"};
		$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
	} elsif (defined($$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"})) {
		$optstr = $$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"};
		$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
	}
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	#default value is 0;
	$cpp .= " -D\'IA_ADDR_PLTIME=0\' -D\'IA_ADDR_VLTIME=0\' ";
	$cpp .= " -D\'IA_NA_TIME1=0\' -D\'IA_NA_TIME2=0\' ";
	vCPP($cpp);

	# send DHCPv6 Confirm Message
	my %ret = vSend3($if, $confirm);
	parse_message(\%ret);
	return (0, %ret) if(0 == $ret{status});
	return (1, %ret);
}
#--------------------------------------------------------------#
# send_renew($if, $renew, $reply, $cpp)                        #
#                                                              #
# Notes:                                                       #
#    make Renew Message by using received Reply                #
#    SUCCESS: return (0, renew)                                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_renew($$$$) {
	my ($if, $renew, $reply, $cpp) = @_;
	
	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Reply";
	my $optstr = "";

	# make packet definition

	my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($reply,$base);

	$cpp .= $cpp_cp;

	#add by haoda 8/31
	if(defined($$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"})){
		$optstr = $$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"};
		$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
	}
	elsif (defined($$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"})) {
    		$optstr = $$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"};
		$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
	}
	#add by haoda .....8/31

	
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);

	# send DHCPv6 Renew Message
	my %ret = vSend3($if, $renew);
	parse_message(\%ret);
	return (0, %ret) if(0 == $ret{status});
	return (1, %ret);
}
#--------------------------------------------------------------#
# send_rebind($if, $rebind, $reply, $cpp)                      #
#                                                              #
# Notes:                                                       #
#    make Rebind Message by using received Reply               #
#    SUCCESS: return (0, rebind)                               #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_rebind($$$$) {
	my ($if, $rebind, $reply, $cpp) = @_;
	
	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Reply";
	my $optstr = "";

	# make packet definition
	if(defined($SID_OPTION)){
		my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($reply,$base);
		$cpp .= $cpp_cp;
	}
	
	if (0 > index($cpp, "IA_ADDR_ADDR")) {
		if(defined($$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"}))
		{
			$optstr = $$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"};
			$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
		} elsif (defined($$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"})) {
			$optstr = $$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"};
			$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
		}
	}

	$cpp .= " -D\'IA_ADDR_PLTIME=7000\' -D\'IA_ADDR_VLTIME=11000\' ";

	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);

	# send DHCPv6 Rebind Message
	my %ret = vSend3($if, $rebind);
	if(defined($ret{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Rebind"})) {
		parse_message(\%ret);
		return (0, %ret) if(0 == $ret{status});
	}
	return (1, %ret);
}
#--------------------------------------------------------------#
# send_decline($if, $decline, $reply, $cpp)                    #
#                                                              #
# Notes:                                                       #
#    make Decline Message by using received Reply              #
#    SUCCESS: return (0, decline)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_decline($$$$) {
	my ($if, $decline, $reply, $cpp) = @_;
	
	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Reply";
	my $optstr = "";

	# make packet definition

	my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($reply,$base);

	$cpp .= $cpp_cp;
	if(defined($$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address"}))
	{
		$optstr = $$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.PreferredLifetime"};
		$cpp .= " -D\'IA_ADDR_PLTIME=$optstr\' ";
		$optstr = $$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.ValidLifetime"};
		$cpp .= " -D\'IA_ADDR_VLTIME=$optstr\' ";
	}
	if (0 > index($cpp, "IA_ADDR_ADDR")) {
		if(defined($$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"}))
		{
			$optstr = $$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"};
			$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
		} elsif (defined($$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"})) {
			$optstr = $$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"};
			$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
		}
	}
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);

	# send DHCPv6 Decline Message
	my %ret = vSend3($if, $decline);
	if(defined($ret{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Decline"})) {
		parse_message(\%ret);
		return (0, %ret) if(0 == $ret{status});
	}
	return (1, %ret);
}
#--------------------------------------------------------------#
# send_release($if, $release, $reply, $cpp)                    #
#                                                              #
# Notes:                                                       #
#    make Release Message by using received Reply              #
#    SUCCESS: return (0, release)                              #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_release($$$$) {
	my ($if, $release, $reply, $cpp) = @_;
	
	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Reply";
	my $optstr = "";

	# make packet definition

	my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($reply,$base);

	$cpp .= $cpp_cp;
	if(defined($$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address"}))
	{
		$optstr = $$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.PreferredLifetime"};
		$cpp .= " -D\'IA_ADDR_PLTIME=$optstr\' ";
		$optstr = $$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.ValidLifetime"};
		$cpp .= " -D\'IA_ADDR_VLTIME=$optstr\' ";
	}
	if (0 > index($cpp, "IA_ADDR_ADDR")) {
		if(defined($$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"}))
		{
			$optstr = $$reply{"$base.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.Address"};
			$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
		} elsif (defined($$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"})) {
			$optstr = $$reply{"$base.Opt_DHCPv6_IA_TA.Opt_DHCPv6_IA_Address.Address"};
			$cpp .= " -D\'IA_ADDR_ADDR=v6(\"$optstr\")\' ";
		}
	}
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);

	# send DHCPv6 Release Message
	my %ret = vSend3($if, $release);
	if(defined($ret{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Release"})) {
		parse_message(\%ret);
		return (0, %ret) if(0 == $ret{status});
	}
	return (1, %ret);
}


#--------------------------------------------------------------#
# SetCidOption($frame, $base)                                  #
#                                                              #
# Notes:                                                       #
#    According to original message set CID opiton.             #
#                                                              #
# IN:                                                          #
#    $frame                                                    #
#    $base                                                     #
#                                                              #
# OUT:                                                         #
#    $cppstr                                                   #
#                                                              #
#--------------------------------------------------------------#
sub SetCidOption($$){
	my ($frame, $base) = @_;
	
	my $optstr = "";
	my $cppstr = "";

	# DUID LLT, Hardware Type = 1
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Type"}))
	{
		$CID_OPTION = "opt_CID_LLT_nut";
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"};
		$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"};
		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=ether(\"$optstr\")\' ";
	}
	
	#DUID LLT, Hardware Type = other than 1
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Type"}))
	{
		$CID_OPTION = "opt_CID_LLT_nut";
		
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"};
		$cppstr .= " -D\'NUT_DUID_HARDWARE_TYPE = $optstr\'";
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"};
		$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"};
		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=hexstr(\"$optstr\")\'";
	}
	
	#DUID EN
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_EN.Type"}))
	{
		$CID_OPTION = "opt_CID_EN_nut";
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_EN.EnterpriseNumber"};
#		$cppstr .= " -D\'NUT_DUID_EN_ENNUM =hexstr(\"$optstr\")\' ";
#XXX            hide modified above line 
		$cppstr .= " -D\'NUT_DUID_EN_ENNUM =$optstr\' ";
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_EN.Identifier"};
		$cppstr .= " -D\'NUT_DUID_EN_ID=hexstr(\"$optstr\")\' ";
	}
	
	# DUID LL, Hardware Type = 1
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_Ether.Type"}))
	{
		$CID_OPTION = "opt_CID_LL_nut";
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_Ether.LinkLayerAddress"};
		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=ether(\"$optstr\")\'";
	}
	
	#DUID LL, Hardware Type = other than 1
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_ANY.Type"}))
	{
		$CID_OPTION = "opt_CID_LL_nut";
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_ANY.HardwareType"};
		$cppstr .= " -D\'NUT_DUID_HARDWARE_TYPE = $optstr\' ";
		$optstr = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_ANY.LinkLayerAddress"};
		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=hexstr(\"$optstr\")\'";
	}

#	print " -----------------------------------------------------------------\n";
	print " cppstr = $cppstr \n";
#	print " -----------------------------------------------------------------\n";
	return ($cppstr);
}

#--------------------------------------------------------------#
# AppendCid($cid_string, $tail, $tail_len)                     #
#                                                              #
# Notes:                                                       #
#    Append tail to the end of cid_string.                     #
#                                                              #
# IN:                                                          #
#    $cid_string                                               #
#    $tail                                                     #
#    $tail_len                                                 #
#                                                              #
# OUT:                                                         #
#    $cid_string(hex)                                          #
#                                                              #
#--------------------------------------------------------------#
sub AppendCid($$$){
  my ($cid_string, $tail, $tail_len) = @_;
  my $hex;
  my $i = 0;
  $hex = sprintf("%x",$tail);

  # Append
  while ($i < (2*$tail_len - length($hex))) {
    $cid_string .= "0";
    $i++;
  }
  $cid_string .= $hex;
  return $cid_string;
}
#--------------------------------------------------------------#
# GetCidOption($frame, $base)                                  #
#                                                              #
# Notes:                                                       #
#    Get CID option from original message.                     #
#                                                              #
# IN:                                                          #
#    $frame                                                    #
#    $base                                                     #
#                                                              #
# OUT:                                                         #
#    $cid string(hex)                                          #
#                                                              #
#--------------------------------------------------------------#
sub GetCidOption($$){
	my ($frame, $base) = @_;	
	my $duid_type;
	my $hwd_type;
	my $mac;
	my $len;
	my $time;
	my $client_duid="0001";
	# DUID LLT, Hardware Type = 1
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Type"}))
	{
		$duid_type = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Type"};
		$hwd_type = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.HardwareType"};
		$time = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"};
		$mac = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"};
		$mac =~ s/://g;
		vLogHTML("WAN MAC is $mac<BR>");
		$len = length($mac)/2 + 8;  # MAC address length + DUID type(2 bytes) + hardware type(2 bytes) + time(4 bytes)

		# Append CID total length
		$client_duid = AppendCid($client_duid,$len,2);

		# Append DUID type
		$client_duid = AppendCid($client_duid,$duid_type,2);

		# Append hardware type
		$client_duid = AppendCid($client_duid,$hwd_type,2);

		# Append time
		$client_duid = AppendCid($client_duid,$time,4);

		# Append mac
		$client_duid .= $mac;
	}

	#DUID LLT, Hardware Type = other than 1
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Type"}))
	{	
		$duid_type = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Type"};
		$hwd_type = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"};
		$time = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"};
		$mac = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"};
		$mac =~ s/://g;
		vLogHTML("!!!!! MAC is $mac<BR>");
		$len = length($mac)/2 + 8;  # MAC address length + DUID type(2 bytes) + hardware type(2 bytes) + time(4 bytes)

		# Append CID total length
		$client_duid = AppendCid($client_duid,$len,2);

		# Append DUID type
		$client_duid = AppendCid($client_duid,$duid_type,2);

		# Append hardware type
		$client_duid = AppendCid($client_duid,$hwd_type,2);

		# Append time
		$client_duid = AppendCid($client_duid,$time,4);

		# Append mac
		$client_duid .= $mac;
	}

	#DUID EN
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_EN.Type"}))
	{
		$duid_type = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_EN.Type"};
		my $ent_num = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_EN.EnterpriseNumber"};
		my $id = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_EN.Identifier"};
		# calculate bytes of identifier
		my $hex = sprintf("%x",$id);
		if ($hex/2 == 1) {
		   $hex++;
		}
		$len = length($hex)/2 + 6;  # identifier length + DUID type(2 bytes) + enterprise number(4 bytes)
		
		# Append CID total length
		$client_duid = AppendCid($client_duid,$len,2);

		# Append DUID type
		$client_duid = AppendCid($client_duid,$duid_type,2);

		# Append enterprise number
		$client_duid = AppendCid($client_duid,$ent_num,4);

		# Append identifier
		$client_duid = AppendCid($client_duid,$id,$hex/2);
	}

	# DUID LL, Hardware Type = 1
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_Ether.Type"}))
	{
		vLogHTML("DUID LL, Hardware Type = 1 <BR>");

		# Get MAC and calculate its length
		$mac = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_Ether.LinkLayerAddress"};
		$mac =~ s/://g;
		vLogHTML("!!!!! MAC is $mac<BR>");
		$len = length($mac)/2 + 4;  # MAC address length + DUID type(2 bytes) + hardware type(2 bytes)		 
		
		# Append CID total length
		$client_duid = AppendCid($client_duid,$len,2);

		# Append DUID Type
		$duid_type = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_Ether.Type"};
		$client_duid = AppendCid($client_duid,$duid_type,2);

		# Append hardware type
		$hwd_type = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_Ether.HardwareType"};
		$client_duid = AppendCid($client_duid,$hwd_type,2);

		# Append MAC	
		$client_duid .= $mac;
	}

	#DUID LL, Hardware Type = other than 1
	if(defined($$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_ANY.Type"}))
	{
		vLogHTML("DUID LL, Type other than 1 <BR>");

		# Get MAC and calculate its length
		$mac = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_ANY.LinkLayerAddress"};
		$mac =~ s/://g;
		vLogHTML("!!!!! MAC is $mac<BR>");
		$len = length($mac)/2 + 4;  # MAC address length + DUID type(2 bytes) + hardware type(2 bytes)

		# Append CID total length
		$client_duid = AppendCid($client_duid,$len,2);
		
		# Append DUID Type
		$duid_type = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_ANY.Type"};
		$client_duid = AppendCid($client_duid,$duid_type,2);

		# Append hardware type
		$hwd_type = $$frame{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LL_ANY.HardwareType"};
		$client_duid = AppendCid($client_duid,$hwd_type,2);

		# Append MAC
		$client_duid .= $mac;
	}
	vLogHTML("client DUID is $client_duid<BR>");
	return ($client_duid);
}	
##
#
sub send_reply($$$$) {
	my ($if, $reply, $sol_or_req, $cpp) = @_;

	my $framestring = $sol_or_req->{"Frame_Ether.Packet_IPv6.Upp_UDP"};
	my @frames = grep(/Udp_DHCPv6/,split(' ',$framestring));
	if(scalar(@frames) > 1 ){
		vLogHTML("<B>send_reply:Receive Packet has some frames: @frames</B><BR>");	
		return (1, ());
	}
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.$frames[0]";

	$cpp = defined($cpp) ? $cpp : '';
	my $optstr = "";
	my $cppstr = SetCidOption($sol_or_req,$base);
		
	print "\n cppstr = $cppstr \n";	
	if(defined($$sol_or_req{"$base.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Identifier"};
			$cppstr .= " -D\'ID_REP=$optstr\' ";
		}
	# set IA Options
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_NA.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_NA.Identifier"};
			$cppstr .= " -D\'IA_NA_IDENTIFIER=$optstr\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_TA.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_TA.Identifier"};
			$cppstr .= " -D\'IA_TA_IDENTIFIER=$optstr\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_PD.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_PD.Identifier"};
			$cppstr .= " -D\'IA_PD_IDENTIFIER=$optstr\' ";
		}
	
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	$cppstr .= $cpp;
#	print "\n cpp string is $cppstr \n ";
	vCPP($cppstr);

	# send DHCPv6 Reply Message
	my %ret = vSend3($if, $reply);
	if(defined($ret{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Reply"})) {
		parse_message(\%ret);
		return (0, %ret) if(0 == $ret{status});
	}
	return (1, %ret);
}

#--------------------------------------------------------------#
# send_reply($if, $reply, $sol_or_req, $cpp)                   #
#                                                              #
# Notes:                                                       #
#    make Reply Message by using received Request              #
#    SUCCESS: return (0, reply)                                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_reply1($$$$) {
	my ($if, $reply, $sol_or_req, $cpp) = @_;

	my $framestring = $sol_or_req->{"Frame_Ether.Packet_IPv6.Upp_UDP"};
	my @frames = grep(/Udp_DHCPv6/,split(' ',$framestring));
	if(scalar(@frames) > 1 ){
		vLogHTML("<B>send_reply:Receive Packet has some frames: @frames</B><BR>");	
		return (1, ());
	}
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.$frames[0]";

	$cpp = defined($cpp) ? $cpp : '';
	my $optstr = "";
	my $cppstr = "";
		
	# make packet definition
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"}))
		{
    			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"};
			$cppstr .= " -D\'NUT_DUID_MAC_ADDR=ether(\"$optstr\")\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"}))
		{
	    		$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"};
			$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
		}
	
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"};
			$cppstr .= " -D\'NUT_DUID_HARDWARE_TYPE = $optstr\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"};
			$cppstr .= " -D\'NUT_DUID_MAC_ADDR=hexstr(\"$optstr\")\' ";
		}	
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"};
			$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
		}	
	if(defined($$sol_or_req{"$base.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Identifier"};
			$cppstr .= " -D\'ID_REP=$optstr\' ";
		}
	# set IA Options
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_NA.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_NA.Identifier"};
			$cppstr .= " -D\'IA_NA_IDENTIFIER=$optstr\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_TA.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_TA.Identifier"};
			$cppstr .= " -D\'IA_TA_IDENTIFIER=$optstr\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_PD.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_PD.Identifier"};
			$cppstr .= " -D\'IA_PD_IDENTIFIER=$optstr\' ";
		}
	
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	$cppstr .= $cpp;
	#	print "\n cpp string is $cppstr \n ";
	vCPP($cppstr);

	# send DHCPv6 Reply Message
	my %ret = vSend3($if, $reply);
	if(defined($ret{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Reply"})) {
		parse_message(\%ret);
		return (0, %ret) if(0 == $ret{status});
	}
	return (1, %ret);
}

#--------------------------------------------------------------#
# send_reply2($if, $reply, $sol_or_req, $cpp)                   #
#                                                              #
# Notes:                                                       #
#    make Reply Message by using received Request              #
#    SUCCESS: return (0, reply)                                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_reply2($$$$) {
	my ($if, $reply, $sol_or_req, $cpp) = @_;

	my $framestring = $sol_or_req->{"Frame_Ether.Packet_IPv6.Upp_UDP"};
	my @frames = grep(/Udp_DHCPv6/,split(' ',$framestring));
	if(scalar(@frames) > 1 ){
		vLogHTML("<B>send_reply:Receive Packet has some frames: @frames</B><BR>");	
		return (1, ());
	}
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.$frames[0]";

	$cpp = defined($cpp) ? $cpp : '';
	my $optstr = "";
	my $cppstr = "";
		
	# make packet definition
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"};
			$cppstr .= " -D\'NUT_DUID_MAC_ADDR=ether(\"$optstr\")\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"};
			$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
		}

	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.HardwareType"};
			$cppstr .= " -D\'NUT_DUID_HARDWARE_TYPE = $optstr\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"};
			$cppstr .= " -D\'NUT_DUID_MAC_ADDR=hexstr(\"$optstr\")\' ";
		}	
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"};
			$cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
		}	
		
	if(defined($$sol_or_req{"$base.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Identifier"};
			$cppstr .= " -D\'ID_REP=$optstr\' ";
		}
	# set IA Options
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_NA.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_NA.Identifier"};
			$cppstr .= " -D\'IA_NA_IDENTIFIER_1=$optstr\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_TA.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_TA.Identifier"};
			$cppstr .= " -D\'IA_TA_IDENTIFIER=$optstr\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_PD.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_PD.Identifier"};
			$cppstr .= " -D\'IA_PD_IDENTIFIER=$optstr\' ";
		}
	if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_NA2.Identifier"}))
		{
			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_NA2.Identifier"};
			$cppstr .= " -D\'IA_NA_IDENTIFIER_2=$optstr\' ";
		}
	
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	$cppstr .= $cpp;
#	print "\n cpp string is $cppstr \n ";
	vCPP($cppstr);

	# send DHCPv6 Reply Message
	my %ret = vSend3($if, $reply);
	if(defined($ret{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Reply"})) {
		parse_message(\%ret);
		return (0, %ret) if(0 == $ret{status});
	}
	return (1, %ret);
}

#----------------------------------------------------------------#
#sub MakeCppForReplyMessage($frame,$strRelaybase)                #
# the sample of $strRelaybase                                    #
# ".Udp_DHCPv6_RelayReply.Opt_DHCPv6_RelayMessage"               #
#return $cpp                                                     #
#----------------------------------------------------------------#
sub MakeCppForReplyMessage($$){
	my ($sol_or_req,$strRelaybase) = @_;
	my $cpp = "";

	my $strComm = "Frame_Ether.Packet_IPv6.Upp_UDP";
	#Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayForward.Opt_DHCPv6_IID.Identifier
	my $strIndexforIID = "$strComm.Udp_DHCPv6_RelayForward";

	if(defined ($strRelaybase)){
		$strComm .= $strRelaybase;
	}

	my @arMsg = (".Udp_DHCPv6_Request",
			".Udp_DHCPv6_Solicit",
			".Udp_DHCPv6_Confirm",
			".Udp_DHCPv6_Renew",
			".Udp_DHCPv6_Rebind",
			".Udp_DHCPv6_Release",
			".Udp_DHCPv6_Decline",
			".Udp_DHCPv6_IID");
	my $base = "";
	my $optstr = "";

	for (my $i = 0; $i < 7; $i++)
	{
		$base = $strComm.$arMsg[$i];
		#vLogHTML($base);
		# make packet definition
		if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"}))
		{
    			$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.LinkLayerAddress"};
			$cpp .= " -D\'NUT_DUID_MAC_ADDR=ether(\"$optstr\")\' ";
		}
		if(defined($$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"}))
		{
	    		$optstr = $$sol_or_req{"$base.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"};
			$cpp .= " -D\'NUT_DUID_TIME=$optstr\' ";
		}
		if(defined($$sol_or_req{"$base.Identifier"}))
		{
	    		$optstr = $$sol_or_req{"$base.Identifier"};
			$cpp .= " -D\'ID_REP=$optstr\' ";
		}
		# set IA Options
		if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_NA.Identifier"}))
		{
	    		$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_NA.Identifier"};
			$cpp .= " -D\'IA_NA_IDENTIFIER=$optstr\' ";
		}
		if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_TA.Identifier"}))
		{
	    		$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_TA.Identifier"};
			$cpp .= " -D\'IA_TA_IDENTIFIER=$optstr\' ";
		}
		if(defined($$sol_or_req{"$base.Opt_DHCPv6_IA_PD.Identifier"}))
		{
	    		$optstr = $$sol_or_req{"$base.Opt_DHCPv6_IA_PD.Identifier"};
			$cpp .= " -D\'IA_PD_IDENTIFIER=$optstr\' ";
		}
		if(defined($$sol_or_req{"$strIndexforIID.Opt_DHCPv6_IID.Identifier"}))
		{
	    		$optstr = $$sol_or_req{"$strIndexforIID.Opt_DHCPv6_IID.Identifier"};
			$cpp .= " -D\'IID_IDENTIFIER=hexstr(\"$optstr\",4)\' ";
		}		
		last if ( ! "" eq $optstr);
	}
	return $cpp;
}
#--------------------------------------------------------------#
# send_reconfigure($if, $reconfigure, $rep, $cpp)              #
#                                                              #
# Notes:                                                       #
#    make Reply Message by using received Request              #
#    SUCCESS: return (0, reply)                                #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_reconfigure($$$$) {
	my ($if, $reconfigure, $rep, $cpp) = @_;

	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Reply";
	my $optstr = "";

	#XXX 2006/06/29 modified
	my $framestring = $rep->{"Frame_Ether.Packet_IPv6.Upp_UDP"};
	my @frames = grep(/Udp_DHCPv6/,split(' ',$framestring));
	my $base2 = "Frame_Ether.Packet_IPv6.Upp_UDP.$frames[0]";
	my $cpp .= SetCidOption($rep,$base2);

	# make packet definition

	my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($rep,$base);
	$cpp .= $cpp_cp;
	if(defined($$rep{"$base.Identifier"}))
	{
		$optstr = $$rep{"$base.Identifier"};
		$cpp .= " -D\'ID_REP=$optstr\' ";
	}
	# set IA Options
	if(defined($$rep{"$base.Opt_DHCPv6_IA_NA.Identifier"}))
	{
		$optstr = $$rep{"$base.Opt_DHCPv6_IA_NA.Identifier"};
		$cpp .= " -D\'IA_NA_IDENTIFIER=$optstr\' ";
	}
	
	if(defined($$rep{"$base.Opt_DHCPv6_IA_TA.Identifier"}))
	{
		$optstr = $$rep{"$base.Opt_DHCPv6_IA_TA.Identifier"};
		$cpp .= " -D\'IA_TA_IDENTIFIER=$optstr\' ";
	}

	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);

	# send DHCPv6 Reconfigure Message
	my %ret = vSend3($if, $reconfigure);
	if(defined($ret{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Reconfigure"})) {
		parse_message(\%ret);
		return (0, %ret) if(0 == $ret{status});
	}
	return (1, %ret);
}

#-----------------------------------------------------------------------#
# send_reconfigure_message($if,$solicit ,$reconfigure, $key_value)      #
#                                                                       #
# Notes:                                                                #
#    make and send Reconfigure Message                                  #
#    SUCCESS: return (0, reply)                                         #
#    FAILURE: return (1, ???)                                           #
#-----------------------------------------------------------------------#
sub send_reconfigure_message($$$$) {
	my ($if, $solicit, $reconfigure, $auth_key) = @_;

	my $cid_opt = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Solicit";
	my $optstr="";
	my $cppstr="";
	if(defined($$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Type"})) {
	# CID type is 1(LLT) and hardware type is 1
	  $optstr="opt_CID_LLT_nut";
	  $cppstr .="-D\'CID=$optstr\' ";
	
	  $optstr = $$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_Ether.Time"};
	  $cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
	
	} elsif (defined($$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Type"})) {
		# CID type is 1(LLT) and hardware type is not 1
	
	  $optstr="opt_CID_LLT_nut";
	  $cppstr .="-D\'CID=$optstr\' ";
	
	#	if(defined($$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"}))
	#	{
	#		$optstr = $$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.LinkLayerAddress"};
	#		$cppstr .= " -D\'NUT_DUID_MAC_ADDR=hexstr(\"$optstr\")\' ";
	#	}	
	
	  if(defined($$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"}))
	  {
	    $optstr = $$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_LLT_ANY.Time"};
	    $cppstr .= " -D\'NUT_DUID_TIME=$optstr\' ";
	  }	
	} elsif (defined($$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_EN.Type"})) {
	   $optstr="opt_CID_EN_nut";
	   $cppstr .="-D\'CID=$optstr\' ";
	} elsif (defined($$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_LL_Ether.Type"})) {
	   $optstr="opt_CID_LL_nut";
	   $cppstr .="-D\'CID=$optstr\' ";
	} elsif (defined($$solicit{"$cid_opt.Opt_DHCPv6_CID.DHCPv6_DUID_LL_ANY.Type"})) {
	   $optstr="opt_CID_LL_nut";
	   $cppstr .="-D\'CID=$optstr\' ";
	} else {
	  cpe6ExitError("<B><FONT COLOR=\"#FF0000\">Can not set CID option for reconfigure message.</FONT></B><BR>");
	}

#	my $optstr = "auth_type_hmac";
#	$cpp .= " -D\'AUTH_INFO=$optstr\' ";
	$cppstr .= " -D\'AUTH_VALUE=hexstr(\"$auth_key\",16)\' ";
	# send DHCPv6 Reconfigure Message

	print "\n cpp: $cppstr \n";
	vCPP($cppstr);

	my %rec = vSend3($if, $reconfigure);
	if(defined($rec{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Reconfigure"})) {
		parse_message(\%rec);
		return (0, %rec) if(0 == $rec{status});
	}
	return (1, %rec);
}

#--------------------------------------------------------------#
# send_information_request($if, $information_request,          #
#                                           $advertise, $cpp)  #
#                                                              #
# Notes:                                                       #
#    make information request Message                          #
#    SUCCESS: return (0, information_request)                  #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub send_information_request($$$$) {
	my ($if, $information_request, $advertise, $cpp) = @_;

	$cpp = defined($cpp) ? $cpp : '';
	my $base = "Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_Advertise";
	my $optstr = "";
	
	# make packet definition
	my ($ret,$cpp_cp) = GetSvrDUIDfromPreMsg($advertise,$base);
	$cpp .= $cpp_cp;

	#No SID option in Information-request message
	createPacketDefinitionFile("DHCPv6_test_pkt.def");
	vCPP($cpp);

	# send DHCPv6 Information Request Message
	my %ret = vSend3($if, $information_request);
	if(defined($ret{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Udp_DHCPv6_InformationRequest"})) {
		parse_message(\%ret);
		return (0, %ret) if(0 == $ret{status});
	}
	return (1, %ret);
}
#--------------------------------------------------------------#
# initial_ra_w_ping($if)                                       #
#                                                              #
# Notes:                                                       #
#    Send RA                                                   #
#    ping from Server1 to NUT (Global Address)                 #
#    Prefix is 3ffe:501:ffff:100::/64                          #
#    SUCCESS: return 0                                         #
#    FAILURE: return 1                                         #
#--------------------------------------------------------------#
sub initial_ra_w_ping($$) {
	my ($if, $paket) = @_;

	my $IF0_NUT = $V6evalTool::NutDef{"Link0_device"};
	if($RA_TRIGGER_DHCPv6){

		vRecv($if, 3, 0, 0, 'rs_nut_to_server1');
		vSend($if, $paket);

		vSleep(5);
		vSend($if, 'echorequest_server1_to_nut_byra');
		my %ret = vRecv($if, 5, 0, 0, 'ns_nutga_byra_to_any_server1ga','ns_nutga_byra_to_any_server1lla','ns_nutlla_to_server1ga','echoreply_nut_byra_to_server1');
		if ($ret{recvFrame} eq 'echoreply_nut_byra_to_server1'){
			vLogHTML("<B>Server1 received Echo Reply from NUT.</B><BR>");
			return 0;
		}elsif($ret{recvFrame} eq 'ns_nutga_byra_to_any_server1ga'){
			vSend($if, 'na_server1ga_to_nutga_byra');
		}elsif($ret{recvFrame} eq 'ns_nutga_byra_to_any_server1lla'){
			vSend($if, 'na_server1ga_to_nutga_byra_lla');
		}elsif($ret{recvFrame} eq 'ns_nutlla_to_server1ga'){
			vSend($if, 'na_server1_global_to_nut');
		}
		%ret = ();
		%ret = vRecv($if, 5, 0, 0, 'echoreply_nut_byra_to_server1');
		if ($ret{recvFrame} eq 'echoreply_nut_byra_to_server1') {
			vLogHTML("<B>Server1 received Echo Reply from NUT.</B><BR>");	
			return 0 ;
		}
		vLogHTML("<B>Server1 could not receive Echo Reply from NUT.</B><BR>");	
		return 1;
	}
	return 1;
}
sub initial_ra_w_ping_dummy($$) {
        my ($if, $paket) = @_;

        my $IF0_NUT = $V6evalTool::NutDef{"Link0_device"};
        if($RA_TRIGGER_DHCPv6){

                my $ret = vRemote("dhcp6c.rmt", "stop", "$if=$IF0_NUT");
                
                if($ret != 0) {
                        vLogHTML('<FONT COLOR="#FF0000">Cannot Initialize DHCPv6 Client program.</FONT><BR>');
                        dhcpExitFail;
                };

                vRecv($if, 3, 0, 0, 'rs_nut_to_server1');
                vSend($if, $paket);

                vSleep(5);
#                vSend($if, 'echorequest_server1_to_nut_byra');
                my %ret = vRecv($if, 5, 0, 0, 'ns_nutga_byra_to_any_server1ga','ns_nutga_byra_to_any_server1lla','ns_nutlla_to_server1ga','echoreply_nut_byra_to_server1');
                if ($ret{recvFrame} eq 'echoreply_nut_byra_to_server1'){
                        vLogHTML("<B>Server1 received Echo Reply from NUT.</B><BR>");
                        return 0;
                }elsif($ret{recvFrame} eq 'ns_nutga_byra_to_any_server1ga'){
                        vSend($if, 'na_server1ga_to_nutga_byra');
                }elsif($ret{recvFrame} eq 'ns_nutga_byra_to_any_server1lla'){
                        vSend($if, 'na_server1ga_to_nutga_byra_lla');
                }elsif($ret{recvFrame} eq 'ns_nutlla_to_server1ga'){
                        vSend($if, 'na_server1_global_to_nut');
                }
                %ret = ();
#                %ret = vRecv($if, 5, 0, 0, 'echoreply_nut_byra_to_server1');
#                if ($ret{recvFrame} eq 'echoreply_nut_byra_to_server1') {
#                        vLogHTML("<B>Server1 received Echo Reply from NUT.</B><BR>");   
#                        return 0 ;
#                }
                vLogHTML("<B>Server1 could not receive Echo Reply from NUT.</B><BR>");  
                return 1;
        }
        return 1;
}

#--------------------------------------------------------------#
# ping_test($if)                                               #
#                                                              #
# Notes:                                                       #
#    ping from Server1 to NUT (Global Address assigned by DHCP)#
#    SUCCESS: return 0                                         #
#    FAILURE: return 1                                         #
#--------------------------------------------------------------#
sub ping_test($) {
	my ($if) = @_;

	vLogHTML("<B>Server1 transmit Echo Request to NUT(global address assigned by DHCP).</B><BR>");

	if($RA_BEFORE_PING){
		vRecv($if, 3, 0, 0, 'rs_nut_to_server1');
		vSleep(5);
#		vSend($if, 'ra_server1_to_nut');
		vSend($if, 'ra_server2_to_all');
	}
	vSend($if, 'echorequest_server1_to_nut');
	my %ret = vRecv($if, 5, 0, 0, 'ns_nutga_to_any_server1ga','ns_nutga_to_any_server1lla','echoreply_nut_to_server1');
	if ( $ret{recvFrame} eq 'echoreply_nut_to_server1'){
		vLogHTML("<B>Server1 received Echo Reply from NUT.</B><BR>");	
		return 0;
	}elsif($ret{recvFrame} eq 'ns_nutga_to_any_server1ga'){
		vSend($if, 'na_server1ga_to_nutga');
	}elsif($ret{recvFrame} eq 'ns_nutga_to_any_server1lla'){
		vSend($if, 'na_ll_tr1_to_nut');
	}
	%ret = ();
	%ret = vRecv($if, 5, 0, 0, 'echoreply_nut_to_server1');
	if($ret{recvFrame} eq 'echoreply_nut_to_server1') {
		vLogHTML("<B>Server1 received Echo Reply from NUT.</B><BR>");	
		return 0 ;
	}
	vLogHTML("<B>Server1 cannot receive Echo Reply from NUT.</B><BR>");	
	return 1;
}


#--------------------------------------------------------------#
# ping_test_addr2($if)                                         #
#                                                              #
# Notes:                                                       #
#    ping from Server1 to NUT (Global Address assigned by RA)  #
#    Prefix is 3ffe:501:ffff:101::/64                          #
#    SUCCESS: return 0                                         #
#    FAILURE: return 1                                         #
#--------------------------------------------------------------#
sub ping_test_addr2($) {
	my ($if) = @_;

	vLogHTML("<B>Server1 transmit Echo Request to NUT(global address assigned by RA).</B><BR>");

	vSend($if, 'echorequest_server1_to_nut_addr2');
	my %ret = vRecv($if, 5, 0, 0, 'ns_nutga_addr2_to_any_server1ga','ns_nutga_addr2_to_any_server1lla','echoreply_nut_addr2_to_server1');
	if ($ret{recvFrame} eq 'echoreply_nut_addr2_to_server1'){
		vLogHTML("<B>Server1 received Echo Reply from NUT.</B><BR>");	
		return 0;
	}elsif($ret{recvFrame} eq 'ns_nutga_addr2_to_any_server1ga'){
		vSend($if, 'na_server1ga_to_nutga_addr2');
	}elsif($ret{recvFrame} eq 'ns_nutga_addr2_to_any_server1lla'){
		vSend($if, 'na_server1ga_to_nutga_addr2_lla');
	}
	%ret = ();
	%ret = vRecv($if, 5, 0, 0, 'echoreply_nut_addr2_to_server1');
	if($ret{recvFrame} eq 'echoreply_nut_addr2_to_server1') {
		vLogHTML("<B>Server1 received Echo Reply from NUT.</B><BR>");	
		return 0;
	}
	vLogHTML("<B><FONT COLOR=\"#FF0000\">Server1 could not receive Echo Reply from NUT.</FONT></B><BR>");
	return 1;
}

#------------------------------------------------------------------#
# ping_test_nut1($if)                                              #
#                                                                  #
# Notes:                                                           #
#    ping from Server2 to NUT (Global Address)                     #
#    This function is mainly used for checking Relay agent address #
#    SUCCESS: return 0                                             #
#    FAILURE: return 1                                             #
#------------------------------------------------------------------#
sub ping_test_nut1($) {
	my ($if) = @_;

	vLogHTML("<B>Server2 transmit Echo Request to NUT($if).</B><BR>");

	vSend($if, 'echorequest_server2_to_nut1');
	my %ret = vRecv($if, 5, 0, 0, 'ns_nut1ga_to_any_server2ga','ns_nut1ga_to_any_server2lla','echoreply_nut1_to_server2');
	if ( $ret{recvFrame} eq 'echoreply_nut1_to_server2'){
		vLogHTML("<B>Server2 received Echo Reply from NUT.</B><BR>");
		return (0, %ret);
	}elsif($ret{recvFrame} eq 'ns_nut1ga_to_any_server2ga'){
		vSend($if, 'na_server2ga_to_nut1ga');
	}elsif($ret{recvFrame} eq 'ns_nut1ga_to_any_server2lla'){
		vSend($if, 'na_server2ga_to_nut1ga_lla');
	}
	%ret = ();
	%ret = vRecv($if, 5, 0, 0, 'echoreply_nut1_to_server2');
	if($ret{recvFrame} eq 'echoreply_nut1_to_server2') {
		vLogHTML("<B>Server2 received Echo Reply from NUT.</B><BR>");
		return (0, %ret);
	}
	vLogHTML("<B><FONT COLOR=\"#FF0000\">Server2 could not receive Echo Reply from NUT.</FONT></B><BR>");
	return (1, %ret);
}

#--------------------------------------------------------------#
# ping_nut_test($;$$$)                                         #
#                                                              #
# Notes:                                                       #
#    ping from Server($EchoName) to NUT($ReplyName $AddrNum)   #
# IN:                                                          #
#    $if: NUT Interface                                        #
#    $EchoName: Server(TN) that assign address to NUT          #
#    $ReplyName: NUT                                           #
#    $AddrNum:  NUT address prefix                             #
# return:                                                      #
#    0 : Pass                                                  #
#    1 : Fail                                                  #
# eg.                                                          #
#    ping_nut_test($IF0,sever1,nut,2);                         #
#--------------------------------------------------------------#
sub ping_nut_test($$$;$){
	
	my ($if, $EchoName, $ReplyName, $AddrNum) = @_;
	
	my $SendFrameName  = "echorequest_".$EchoName."_to_".$ReplyName.$AddrNum;
	my $SendFrameName1 = "na_".$EchoName."ga"."_to_".$ReplyName.$AddrNum."ga";
	my $SendFrameName2 = "na_".$EchoName."ga"."_to_".$ReplyName.$AddrNum."lla";
	my $RecvFrameName  = "echoreply_".$ReplyName.$AddrNum."_to_".$EchoName;
	my $RecvFrameName1 = "ns_".$ReplyName.$AddrNum."ga"."_to_"."any_".$EchoName."ga";
	my $RecvFrameName2 = "ns_".$ReplyName.$AddrNum."ga"."_to_"."any_".$EchoName."lla";
	my %ret = undef;
	
	vLogHTML("<B>$EchoName transmit Echo Request to $ReplyName$AddrNum.</B><BR>");
	vSend($if, $SendFrameName);
	%ret = vRecv($if, 3, 0, 0, $RecvFrameName, $RecvFrameName1);
	if ($ret{recvFrame} eq $RecvFrameName){
		vLogHTML("<B>$EchoName recevied Echo Reply from $ReplyName$AddrNum.</B><BR>");
		return 0; 
	}
	elsif($ret{recvFrame} eq $RecvFrameName1 ){
		vSend($if, $SendFrameName1);
	}
	elsif($ret{recvFrame} eq $RecvFrameName2 ){
		vSend($if, $SendFrameName2);
	}
	%ret = ();
	%ret = vRecv($if, 5, 0, 0, $RecvFrameName);
	if($ret{recvFrame} eq $RecvFrameName){
		vLogHTML("<B>$EchoName recevied Echo Reply from $ReplyName$AddrNum.</B><BR>");
		return 0;
	}
	vLogHTML("<B><FONT COLOR=\"#FF0000\">$EchoName could not receive Echo Reply.</FONT></B><BR>");
	return 1;
}

#--------------------------------------------------------------#
# SetNUTAddr($$$$)                                             #
#                                                              #
# Notes:                                                       #
#       set the address of NUT(Server)                         #
#                                                              #
#--------------------------------------------------------------#
sub SetNUTAddr($$$$){
	# Now only for host
	my ($IFName,$address,$len,$type) = @_;
	my $ret = vRemote('manualaddrconf.rmt',"if=$IFName","addr=$address","len=$len","type=$type");
	dhcpExitFail if (0 != $ret);
}
#--------------------------------------------------------------#
# ifDown($)                                                    #
#                                                              #
# Notes:                                                       #
#       interface down                                         #
#                                                              #
#--------------------------------------------------------------#
sub ifDown($){
	my ($IFName) = @_;
	my $ret = vRemote("dhcp6c.rmt", "ifdown", "link0=$IFName");
	if($ret != 0) {
		vLogHTML('<FONT COLOR="#FF0000">Cannot down the interface of DHCPv6 Client</FONT><BR>');
		dhcpExitFail;
	};
}

#--------------------------------------------------------------#
# ifUp($)                                                      #
#                                                              #
# Notes:                                                       #
#       interface up                                           #
#    Recv RS if NUT send RS                                    #
#    Send RA                                                   #
#    ping from Server1 to NUT (Global Address)                 #
#    Prefix is 3ffe:501:ffff:100::/64                          #
#    SUCCESS: return 0                                         #
#    FAILURE: return 1                                         #
#                                                              #
#--------------------------------------------------------------#
sub ifUp($){
	my ($IFName) = @_;
	my $ret = vRemote("dhcp6c.rmt", "ifup", "link0=$IFName");
	if($ret != 0) {
		vLogHTML('<FONT COLOR="#FF0000">Cannot up the interface of DHCPv6 Client</FONT><BR>');
		dhcpExitFail;
	};

	if($RA_TRIGGER_DHCPv6) {
		#vRecv("Link0", 3, 0, 0, 'rs_nut_to_server1');
		vClear("Link0");
                vSend("Link0", 'ra_server2_to_all');
                #vRecv("Link0", 3, 0, 0, 'dadns_nutga');
                #vSleep(3);
	}
}

#--------------------------------------------------------------#
# vRecvPacket($ifname, $timeout, $seektime, $count, @frames)   #
# Out:                                                         #
#     %frame                                                   #
#--------------------------------------------------------------#
sub vRecvPacket($$$$@)
{
	my ($ifname, $timeout, $seektime, $count, @frames) = @_;
	my (%ret,%nd) = ((),());
	my $type=$V6evalTool::NutDef{Type};
	if($ifname eq 'Link0') {
		%nd = (
			'ns_nutlla_to_any_server1lla'=> 'na_server1_to_nut',
			'ns_nutlla_to_server1ga'=> 'na_server1_global_to_nut',
			'ns_nutlla_to_any_client1_lla'=> 'na_client1_to_nut_local',
			'ns_nutlla_to_any_client2_lla'=> 'na_client2_to_nut_local',
			'ns_nut_to_any_client1_global'	=> 'na_client1_to_nut_global',
			'ns_nut_to_relay1_0'	=>'na_relay1_0_to_nut',
			'ns_nut_to_relay1_0_global'	=>'na_relay1_0_to_nut_global',
			'ns_nut_global_to_relay1_0_global'	=>'na_relay1_0_global_to_nut_global',
			'ns_nut_to_relay2_0'	=>'na_relay2_0_to_nut',
			'ns_nut_to_relay2_0_global'	=>'na_relay2_0_to_nut_global',
			'ns_nut_global_to_relay2_0_global'	=>'na_relay2_0_global_to_nut_global',
#		        'ns_nutga_to_any' => 'na_server1ga_to_nutga',
			'ns_nutga_to_any_server1lla' => 'na_server1ga_to_nutga_server1lla',
		);
	}
	elsif($ifname eq 'Link1'){
		%nd = (
			'ns_nutlla_to_any_client1_lla'	=> 'na_client1_to_nut_local',
			'ns_nutlla_to_any_client2_lla'	=> 'na_client2_to_nut_local',
			'ns_nut_to_any_client1_global'	=> 'na_client1_to_nut_global',
			'ns_nutrelay_to_client_local'	=> 'na_client1_to_nut_local',
			'ns_nutrelay_to_client_global'	=> 'na_client1_to_nut_global',
			'ns_nutrelay_to_server'	=> 'na_server1_to_nut',
			'ns_nutrelay_to_relay'	=>'na_relay2_to_nut',
		);
	}
	while(1) {
		%ret = vRecv3($ifname, $timeout, $seektime, $count,@frames, keys(%nd));
		if($ret{'recvCount'}) {
			my $continue = 0;
			while(my ($recv, $send) = each(%nd)) {
				if($recv && $ret{'recvFrame'} eq $recv) {
					vSend($ifname, $send);
					$continue ++;
				}
			}
			if($continue) {
				next;
			}
		}
	last;
	}	
	return(%ret);
}

#--------------------------------------------------------------#
# vRecvPacket2($ifname, $timeout, $seektime, $count, @frames)  #
# Out:                                                         #
#     %frame                                                   #
#--------------------------------------------------------------#
sub vRecvPacket2($$$$@)
{
        my ($ifname, $timeout, $seektime, $count, @frames) = @_;
        my (%ret,%nd) = ((),());
        my $type=$V6evalTool::NutDef{Type};
        if($type eq 'host') {
                %nd = (
                        'ns_nutlla_to_any_server1lla'=> 'na_server1_to_nut',
                        'ns_nutlla_to_server1ga'=> 'na_server1_global_to_nut',
                        'ns_nutlla_to_any_client1_lla'=> 'na_client1_to_nut_local',
                        'ns_nutlla_to_any_client2_lla'=> 'na_client2_to_nut_local',
                        'ns_nut_to_any_client1_global'  => 'na_client1_to_nut_global',
                        'ns_nut_to_relay1_0'    =>'na_relay1_0_to_nut',
                        'ns_nut_to_relay1_0_global'     =>'na_relay1_0_to_nut_global',
                        'ns_nut_global_to_relay1_0_global'      =>'na_relay1_0_global_to_nut_global',
                        'ns_nut_to_relay2_0'    =>'na_relay2_0_to_nut',
                        'ns_nut_to_relay2_0_global'     =>'na_relay2_0_to_nut_global',
                        'ns_nut_global_to_relay2_0_global'      =>'na_relay2_0_global_to_nut_global',
#                       'ns_nutga_to_any' => 'na_server1ga_to_nutga',
                        'ns_nutga_to_any_server1lla' => 'na_server1ga_to_nutga_server1lla',
                );
        }
        elsif($type eq 'router'){
                %nd = (
                        'ns_nutlla_to_any_client1_lla'  => 'na_client1_to_nut_local',
                        'ns_nutlla_to_any_client2_lla'  => 'na_client2_to_nut_local',
                        'ns_nut_to_any_client1_global'  => 'na_client1_to_nut_global',
                        'ns_nutrelay_to_client_local'   => 'na_client1_to_nut_local',
                        'ns_nutrelay_to_client_global'  => 'na_client1_to_nut_global',
                        'ns_nutrelay_to_server' => 'na_server1_to_nut',
                        'ns_nutrelay_to_relay'  =>'na_relay2_to_nut',

                        'ns_nut_global_to_relay1_0_global'      =>'na_relay1_0_global_to_nut_global',
			'ns_nutlla_to_any_server1lla'=> 'na_server1_to_nut',
                        'ns_nutlla_to_server1ga'=> 'na_server1_global_to_nut',
                        'ns_nut_to_relay1_0'    =>'na_relay1_0_to_nut',
                        'ns_nut_to_relay1_0_global'     =>'na_relay1_0_to_nut_global',
                        'ns_nut_to_relay2_0'    =>'na_relay2_0_to_nut',
                        'ns_nut_to_relay2_0_global'     =>'na_relay2_0_to_nut_global',
                        'ns_nut_global_to_relay2_0_global'      =>'na_relay2_0_global_to_nut_global',
#                       'ns_nutga_to_any' => 'na_server1ga_to_nutga',
                        'ns_nutga_to_any_server1lla' => 'na_server1ga_to_nutga_server1lla',
                        );
        }
        while(1) {
                %ret = vRecv3($ifname, $timeout, $seektime, $count,@frames, keys(%nd));
                if($ret{'recvCount'}) {
                        my $continue = 0;
                        while(my ($recv, $send) = each(%nd)) {
                                if($recv && $ret{'recvFrame'} eq $recv) {
                                       vSend($ifname, $send);
                                        $continue ++;
                                }
                        }
                        if($continue) {
                                next;
                        }
               }
        last;
        }       
        return(%ret);
#while(1) {
#                # in vRecv3, receive NS 
#                %ret = vRecv3($ifname, $timeout, $seektime, $count,@frames, keys(%nd));
#                        my $key = '';
#                        my $value = '';
#
#                        print "print return value\n";
#                        while(($key,$value) = each (%ret)){
#                                print "$key,$value\n";
#                        }
#                print "recvCount:$ret{'recvCount'}\n";
#                # if recvCount is defined
#                if($ret{'recvCount'}) {
#                        my $continue = 0;
#                        # $recv is key, $recv is value
#                        while(my ($recv, $send) = each(%nd)) {
#                                        print "recv,send:$recv, $send\n";
#                                        print "recvFrame:$ret{'recvFrame'}\n";
#                                if($recv && $ret{'recvFrame'} eq $recv) {
#                                                print "recv:$recv\n";
#                                                print "recvFrame:$ret{'recvFrame'}\n";
#                                                print "send:$send\n";
#                                        # send NA
#                                        vSend($ifname, $send);
#                                        $continue ++;
#                                        print "continue:$continue\n";
#                                }
#                        }
#                        if($continue) {
#                                next;
#                        }
#                }
#        last;
#        }       
#        return(%ret);

}


#--------------------------------------------------------------#
# createPacketDefinitionFile(filename)                         #
#                                                              #
# Notes:                                                       #
#       make packet definition                                 #
#                                                              #
#--------------------------------------------------------------#
sub createPacketDefinitionFile($){
	my ($filename) = @_;
	my $OptionDesc = "";
	
	my $portno = 546;
	
	$OptionDesc .= "\t\toption = ".$CID_OPTION.";\n" if (! $CID_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$SID_OPTION.";\n" if (! $SID_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$IA_NA_OPTION.";\n" if (! $IA_NA_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$IA_NA_OPTION1.";\n" if (! $IA_NA_OPTION1 eq "");
	$OptionDesc .= "\t\toption = ".$IA_TA_OPTION.";\n" if (! $IA_TA_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$IA_PD_OPTION.";\n" if (! $IA_PD_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$IA_PD_OPTION1.";\n" if (! $IA_PD_OPTION1 eq "");
	$OptionDesc .= "\t\toption = ".$OptionRequest_OPTION.";\n" if (! $OptionRequest_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$Preference_OPTION.";\n" if (! $Preference_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$ElapsedTime_OPTION.";\n" if (! $ElapsedTime_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$Authentication_OPTION.";\n" if (! $Authentication_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$Authentication_OPTION2.";\n" if (! $Authentication_OPTION2 eq "");
	$OptionDesc .= "\t\toption = ".$ServerUnicast_OPTION.";\n" if (! $ServerUnicast_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$RapidCommit_OPTION.";\n" if (! $RapidCommit_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$UserClass_OPTION.";\n" if (! $UserClass_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$VendorClass_OPTION.";\n" if (! $VendorClass_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$VendorSpecificInfo_OPTION.";\n" if (! $VendorSpecificInfo_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$IID_OPTION.";\n" if (! $IID_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$ReconfigureMessage_OPTION.";\n" if (! $ReconfigureMessage_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$ReconfigureAccept_OPTION.";\n" if (! $ReconfigureAccept_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$StatusCode_OPTION.";\n" if (! $StatusCode_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$DNS_SVR_OPTION.";\n" if (! $DNS_SVR_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$DNS_LST_OPTION.";\n" if (! $DNS_LST_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$RELAY_Msg_OPTION.";\n" if (! $RELAY_Msg_OPTION eq "");
	$OptionDesc .= "\t\toption = ".$SOL_RT.";\n" if (! $SOL_RT eq "");
	
	open(OUT, ">./$filename")|| return 2;

	print OUT "/* \n";
	print OUT "*** DO NOT EDIT THIS FILE ***\n";
	print OUT "*/\n";

	#--------------------------------------------------------------#
	#                    *** for Server Test ***                   #
	#--------------------------------------------------------------#
	# DHCPv6 Solicit: CLIENT1 ----> multicast
	print OUT "FEM_dhcp6_solicit(\n";
	print OUT "\tsolicit_client1_to_alldhcp,\n";
	print OUT "\t_HETHER_client1_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_SOL;\n";
	print OUT "\t}\n";
	print OUT ")\n";

	# DHCPv6 Solicit: CLIENT2 ----> multicast
	print OUT "FEM_dhcp6_solicit(\n";
	print OUT "\tsolicit_client2_to_alldhcp,\n";
	print OUT "\t_HETHER_client2_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(CLIENT2_LLOCAL_UCAST);\n";
	print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_SOL2;\n";
	print OUT "\t}\n";
	print OUT ")\n";

	# DHCPv6 Solicit: CLIENT1 ----> NUT
	print OUT "FEM_dhcp6_solicit(\n";
	print OUT "\tsolicit_client1_to_nut,\n";
	print OUT "\t_HETHER_client1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(NUT_LLOCAL_UCAST);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_SOL;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";

	# DHCPv6 Request: CLIENT1 ----> multicast
	print OUT "FEM_dhcp6_request(\n";
	print OUT "\trequest_client1_to_alldhcp,\n";
	print OUT "\t_HETHER_client1_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_REQ;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";

	# DHCPv6 Request: CLIENT2 ----> multicast
	print OUT "FEM_dhcp6_request(\n";
	print OUT "\trequest_client2_to_alldhcp,\n";
	print OUT "\t_HETHER_client2_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(CLIENT2_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_REQ2;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";

	# DHCPv6 Request: CLIENT1 ----> NUT
	print OUT "FEM_dhcp6_request(\n";
	print OUT "\trequest_client1_to_nut,\n";
	print OUT "\t_HETHER_client1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(NUT_LLOCAL_UCAST);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_REQ;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";

	# DHCPv6 Information Request: CLIENT1 ----> multicast
	print OUT "FEM_dhcp6_information_request(\n";
	print OUT "\tinformation_request_client1_to_alldhcp,\n";
	print OUT "\t_HETHER_client1_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t    _SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_INFOREQ;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";

	# DHCPv6 Information Request: CLIENT1 ----> NUT
	print OUT "FEM_dhcp6_information_request(\n";
	print OUT "\tinformation_request_client1_to_nut,\n";
	print OUT "\t_HETHER_client1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t    _SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(NUT_LLOCAL_UCAST);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_INFOREQ;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";

	# DHCPv6 Confirm: CLIENT1 ----> multicast
	print OUT "FEM_dhcp6_confirm(\n";
	print OUT "\tconfirm_client1_to_alldhcp,\n";
	print OUT "\t_HETHER_client1_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_CONFIRM;\n";
	print OUT "\t}\n";
	print OUT ")\n";
	
	# DHCPv6 Confirm: CLIENT1 ----> NUT
	print OUT "FEM_dhcp6_confirm(\n";
	print OUT "\tconfirm_client1_to_nut,\n";
	print OUT "\t_HETHER_client1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(NUT_LLOCAL_UCAST);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_CONFIRM;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";

	# DHCPv6 Renew: CLIENT1 ----> multicast
	print OUT "FEM_dhcp6_renew(\n";
	print OUT "\trenew_client1_to_alldhcp,\n";
	print OUT "\t_HETHER_client1_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_RENEW;\n";
	print OUT "\t}\n";
	print OUT ")\n";
	
	# DHCPv6 Renew: CLIENT1 ----> NUT(link local address)
	print OUT "FEM_dhcp6_renew(\n";
	print OUT "\trenew_client1_to_nut_lla,\n";
	print OUT "\t_HETHER_client1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(NUT_LLOCAL_UCAST);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_RENEW;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";
	
        # DHCPv6 Renew: CLIENT1 ----> NUT(global address)
        print OUT "FEM_dhcp6_renew(\n";
        print OUT "\trenew_client1_to_nut_ga,\n";
        print OUT "\t_HETHER_client1_to_nut,\n";
        print OUT "\t{\n";
        print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
        print OUT "\t\t_DST(NUT_GLOBAL_UCAST_ADDR1);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\t_SPORT($portno);\n";
        print OUT "\t\t_DPORT(547);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\tIdentifier = ID_RENEW;\n";
        print OUT $OptionDesc;
        print OUT "\t}\n";
        print OUT ")\n";

	# DHCPv6 Rebind: CLIENT1 ----> multicast
	print OUT "FEM_dhcp6_rebind(\n";
	print OUT "\trebind_client1_to_alldhcp,\n";
	print OUT "\t_HETHER_client1_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_REBIND;\n";
	print OUT "\t}\n";
	print OUT ")\n";
	
	# DHCPv6 Rebind: CLIENT1 ----> NUT(link local address)
	print OUT "FEM_dhcp6_rebind(\n";
	print OUT "\trebind_client1_to_nut_lla,\n";
	print OUT "\t_HETHER_client1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(NUT_LLOCAL_UCAST);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_REBIND;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";
	
        # DHCPv6 Rebind: CLIENT1 ----> NUT(global address)
        print OUT "FEM_dhcp6_rebind(\n";
        print OUT "\trebind_client1_to_nut_ga,\n";
        print OUT "\t_HETHER_client1_to_nut,\n";
        print OUT "\t{\n";
        print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
        print OUT "\t\t_DST(NUT_GLOBAL_UCAST_ADDR1);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\t_SPORT($portno);\n";
        print OUT "\t\t_DPORT(547);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\tIdentifier = ID_REBIND;\n";
        print OUT $OptionDesc;
        print OUT "\t}\n";
        print OUT ")\n";

	# DHCPv6 Release: CLIENT1 ----> multicast
	print OUT "FEM_dhcp6_release(\n";
	print OUT "\trelease_client1_to_alldhcp,\n";
	print OUT "\t_HETHER_client1_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_RELEASE;\n";
	print OUT "\t}\n";
	print OUT ")\n";
	
	# DHCPv6 Release: CLIENT1 ----> NUT(link local address)
	print OUT "FEM_dhcp6_release(\n";
	print OUT "\trelease_client1_to_nut_lla,\n";
	print OUT "\t_HETHER_client1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(NUT_LLOCAL_UCAST);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_RELEASE;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";
	
        # DHCPv6 Release: CLIENT1 ----> NUT(global address)
        print OUT "FEM_dhcp6_release(\n";
        print OUT "\trelease_client1_to_nut_ga,\n";
        print OUT "\t_HETHER_client1_to_nut,\n";
        print OUT "\t{\n";
        print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
        print OUT "\t\t_DST(NUT_GLOBAL_UCAST_ADDR1);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\t_SPORT($portno);\n";
        print OUT "\t\t_DPORT(547);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\tIdentifier = ID_RELEASE;\n";
        print OUT $OptionDesc;
        print OUT "\t}\n";
        print OUT ")\n";

	# DHCPv6 Decline: CLIENT1 ----> multicast
	print OUT "FEM_dhcp6_decline(\n";
	print OUT "\tdecline_client1_to_alldhcp,\n";
	print OUT "\t_HETHER_client1_to_alldhcp,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_DECLINE;\n";
	print OUT "\t}\n";
	print OUT ")\n";
	
	# DHCPv6 Decline: CLIENT1 ----> NUT(link local address)
	print OUT "FEM_dhcp6_decline(\n";
	print OUT "\tdecline_client1_to_nut_lla,\n";
	print OUT "\t_HETHER_client1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(NUT_LLOCAL_UCAST);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n";
	print OUT "\t\t_DPORT(547);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\tIdentifier = ID_DECLINE;\n";
	print OUT $OptionDesc;
	print OUT "\t}\n";
	print OUT ")\n";

        # DHCPv6 Decline: CLIENT1 ----> NUT(global address)
        print OUT "FEM_dhcp6_decline(\n";
        print OUT "\tdecline_client1_to_nut_ga,\n";
        print OUT "\t_HETHER_client1_to_nut,\n";
        print OUT "\t{\n";
        print OUT "\t\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
        print OUT "\t\t_DST(NUT_GLOBAL_UCAST_ADDR1);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\t_SPORT($portno);\n";
        print OUT "\t\t_DPORT(547);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\tIdentifier = ID_DECLINE;\n";
        print OUT $OptionDesc;
        print OUT "\t}\n";
        print OUT ")\n";

        # DHCPv6 Invalid Advertise: CLIENT1 ----> multicast
        print OUT "FEM_dhcp6_advertise(\n";
        print OUT "\tinvalid_advertise_client1_to_alldhcp,\n";
        print OUT "\t_HETHER_client1_to_alldhcp,\n";
        print OUT "\t{\n";
        print OUT "\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
        print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
#       print OUT "\tHopLimit = 1;\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\t_SPORT($portno);\n";
        print OUT "\t\t_DPORT(547);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT $OptionDesc;
        print OUT "\t\tIdentifier = ID_ADV;\n";
        print OUT "\t}\n";
        print OUT ")\n";

	# DHCPv6 Invalid Reply: CLIENT1 ----> multicast
        print OUT "FEM_dhcp6_reply(\n";
        print OUT "\tinvalid_reply_client1_to_alldhcp,\n";
        print OUT "\t_HETHER_client1_to_alldhcp,\n";
        print OUT "\t{\n";
        print OUT "\t_SRC(CLIENT1_LLOCAL_UCAST);\n";
        print OUT "\t_DST(v6(_ALLDHCPAGENTS_MCAST_ADDR));\n";
#       print OUT "\tHopLimit = 1;\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\t_SPORT($portno);\n";
        print OUT "\t\t_DPORT(547);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT $OptionDesc;
        print OUT "\t\tIdentifier = ID_REP;\n";
        print OUT "\t}\n";
        print OUT ")\n";

	#--------------------------------------------------------------#
	#                 For Relay agent test                         #
	#-------------------- From Here -------------------------------#
	# DHCPv6 Advertise: SERVER1 ----> CLIENT1
	print OUT "FEM_dhcp6_advertise(\n";
	print OUT "\tadvertise_server1_to_client1,\n";
	print OUT "\t_HETHER_server1_to_client1,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(SERVER1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(CLIENT1_LLOCAL_UCAST);\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n"; #$portno++;
	print OUT "\t\t_DPORT(546);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_ADV;\n";
	print OUT "\t}\n";
	print OUT ")\n";
	
	# DHCPv6 Reply: SERVER1 ----> NUT
	print OUT "FEM_dhcp6_reply(\n";
	print OUT "\treply_server1_to_client1,\n";
	print OUT "\t_HETHER_server1_to_client1,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(SERVER1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(CLIENT1_LLOCAL_UCAST);\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n"; #$portno++;
	print OUT "\t\t_DPORT(546);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_REP;\n";
	print OUT "\t}\n";
	print OUT ")\n";	

	# DHCPv6 Reconfigure: SERVER1 ----> CLIENT1
	print OUT "FEM_dhcp6_reconfigure(\n";
	print OUT "\treconfigure_server1_to_client1,\n";
	print OUT "\t_HETHER_server1_to_client1,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(SERVER1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(CLIENT1_LLOCAL_UCAST);\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n"; #$portno++;
	print OUT "\t\t_DPORT(546);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_RECONF;\n";
	print OUT "\t}\n";
	print OUT ")\n";

	#-------------------- To Here ---------------------------------#

	# DHCPv6 Advertise: SERVER1 ----> NUT
	print OUT "FEM_dhcp6_advertise(\n";
	print OUT "\tadvertise_server1_to_nut,\n";
	print OUT "\t_HETHER_server1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(SERVER1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(NUT_LLOCAL_UCAST);\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n"; #$portno++;
	print OUT "\t\t_DPORT(546);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_ADV;\n";
	print OUT "\t}\n";
	print OUT ")\n";
	

	
	# DHCPv6 Advertise: SERVER2 ----> NUT
	
	print OUT "FEM_dhcp6_advertise(\n";
	print OUT "\tadvertise_server2_to_nut,\n";
	print OUT "\t_HETHER_server2_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(SERVER2_LLOCAL_UCAST);\n";
	print OUT "\t_DST(NUT_LLOCAL_UCAST);\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n"; $portno++;
	print OUT "\t\t_DPORT(546);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_ADV;\n";
	print OUT "\t}\n";
	print OUT ")\n";

	
	# DHCPv6 Reply: SERVER1 ----> NUT
	print OUT "FEM_dhcp6_reply(\n";
	print OUT "\treply_server1_to_nut,\n";
	print OUT "\t_HETHER_server1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(SERVER1_LLOCAL_UCAST);\n";
	print OUT "\t_DST(NUT_LLOCAL_UCAST);\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n"; $portno++;
	print OUT "\t\t_DPORT(546);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_REP;\n";
	print OUT "\t}\n";
	print OUT ")\n";


	# DHCPv6 Reply: SERVER2 ----> NUT
	print OUT "FEM_dhcp6_reply(\n";
	print OUT "\treply_server2_to_nut,\n";
	print OUT "\t_HETHER_server2_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t_SRC(SERVER2_LLOCAL_UCAST);\n";
	print OUT "\t_DST(NUT_LLOCAL_UCAST);\n";
#	print OUT "\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n"; $portno++;
	print OUT "\t\t_DPORT(546);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT $OptionDesc;
	print OUT "\t\tIdentifier = ID_REP;\n";
	print OUT "\t}\n";
	print OUT ")\n";

	
	# DHCPv6 Reconfigure: SERVER1 ----> NUT
	print OUT "FEM_dhcp6_reconfigure(\n";
	print OUT "\treconfigure_server1_to_nut,\n";
	print OUT "\t_HETHER_server1_to_nut,\n";
	print OUT "\t{\n";
	print OUT "\t\t_SRC(SERVER1_LLOCAL_UCAST);\n";
	print OUT "\t\t_DST(NUT_LLOCAL_UCAST);\n";
#	print OUT "\t\tHopLimit = 1;\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t\t_SPORT($portno);\n"; $portno++;
	print OUT "\t\t_DPORT(546);\n";
	print OUT "\t},\n";
	print OUT "\t{\n";
	print OUT "\t$OptionDesc";
#	print OUT "\t\tIdentifier = ID_RECONF;\n";
	print OUT "\t\tIdentifier = 0;\n";
	print OUT "\t}\n";
	print OUT ")\n";

my $portno = 546;
	# DHCPv6 Advertise with invalid UDP port: SERVER1 ----> NUT
        print OUT "FEM_dhcp6_advertise(\n";
        print OUT "\tadvertise_server1_to_nut_invalid_udp,\n";
        print OUT "\t_HETHER_server1_to_nut,\n";
        print OUT "\t{\n";
        print OUT "\t_SRC(SERVER1_LLOCAL_UCAST);\n";
        print OUT "\t_DST(NUT_LLOCAL_UCAST);\n";
#       print OUT "\tHopLimit = 1;\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT "\t\t_SPORT($portno);\n"; 
        print OUT "\t\t_DPORT(33536);\n";
        print OUT "\t},\n";
        print OUT "\t{\n";
        print OUT $OptionDesc;
        print OUT "\t\tIdentifier = ID_ADV;\n";
        print OUT "\t}\n";
        print OUT ")\n";
	close(OUT);

	return 0;
}

#--------------------------------------------------------------#
# clear_options()                                              #
#                                                              #
# Notes:                                                       #
#    clear global variables xx_OPTIONs                         #
#--------------------------------------------------------------#
sub clear_options(){

	my @def_options = (
		       \$CID_OPTION,
		       \$SID_OPTION,
		       \$IA_NA_OPTION,
		       \$IA_NA_OPTION1,
		       \$IA_TA_OPTION,
		       \$IA_PD_OPTION,
		       \$IA_PD_OPTION1,
		       \$OptionRequest_OPTION,
		       \$Preference_OPTION,
		       \$ElapsedTime_OPTION,
		       \$Authentication_OPTION,
		       \$Authentication_OPTION2,
		       \$ServerUnicast_OPTION,
		       \$RapidCommit_OPTION,
		       \$UserClass_OPTION,
		       \$VendorClass_OPTION,
		       \$VendorSpecificInfo_OPTION,
		       \$IID_OPTION,
		       \$ReconfigureMessage_OPTION,
		       \$ReconfigureAccept_OPTION,
		       \$StatusCode_OPTION,
		       \$DNS_SVR_OPTION,
		       \$DNS_LST_OPTION,
		       \$RELAY_Msg_OPTION,
		      );

	foreach my $def_option (@def_options){
		$$def_option = "";
	}

	return 0;
}

#--------------------------------------------------------------#
# compare_options($frame1, $frame2, $optnum)                   #
#                                                              #
# Notes:                                                       #
#    compare options in frame1 and frame2                      #
#    MATCH: return 0                                           #
#    UNMATCH: return 1                                         #
#--------------------------------------------------------------#
sub compare_options($$$) {
	my ($cmp_frame1, $cmp_frame2, $optnum) = @_;
	my $unmatch = 0;

	my $base1;
	my $base2;
	my $optbase1;
	my $optbase2;
	
	foreach(keys %dhcp6_messages) {
		$base1 = $dhcp6_messages{$_};
		last if (defined($$cmp_frame1{$base1}));
		$base1 = "";
	}
	
	foreach(keys %dhcp6_messages) {
		$base2 = $dhcp6_messages{$_};
		last if (defined($$cmp_frame2{$base2}));
		$base2 = "";
	}
	
	foreach(keys %option_defs) {
		if (0 != ($_ & $optnum)) {
			vLogHTML("<B>Comparing $option_defs{$_} </B><BR>");
			$optbase1 = "$base1"."."."$option_defs{$_}";
			$optbase2 = "$base2"."."."$option_defs{$_}";
			if (!defined ($$cmp_frame1{"$optbase1"}) || $$cmp_frame1{"$optbase1"} eq '' ) {
				vLogHTML("<FONT COLOR=\"#FF0000\"><B>not found: $optbase1 in Packet</B><BR><BR></FONT>");
				$unmatch++;
			} elsif (!defined ($$cmp_frame2{"$optbase2"}) || $$cmp_frame2{"$optbase2"} eq '') {
				vLogHTML("<FONT COLOR=\"#FF0000\"><B>not found: $optbase2 in Packet</B><BR><BR></FONT>");
				$unmatch++;
			} elsif (!($$cmp_frame1{"$optbase1"} eq $$cmp_frame2{"$optbase2"})) {
				my $msg = "<b><font color='red'>$optbase1 unmatched.</font></b>:";
				$msg .= $$cmp_frame1{"$optbase1"};
				$msg .= " != ";
				$msg .= $$cmp_frame2{"$optbase2"};
				$msg .= "<BR>";
				vLogHTML($msg);
				$unmatch++;
			} else {
				my $cmp_base1 = $optbase1;
				my $cmp_base2 = $optbase2;
				$unmatch += compare_option($cmp_frame1,"$cmp_base1", $cmp_frame2,"$cmp_base2");
			}
		}
	}
	return 0 if (0 == $unmatch);
	return 1;
}

sub compare_option($$$$) {

	my ($cmp_frame1,$tmp_base1, $cmp_frame2,$tmp_base2) = @_;
	my $unmatch = 0;
	foreach(split(" ", $$cmp_frame1{"$tmp_base1"})) {
		if (! defined($$cmp_frame1{"$tmp_base1.$_"})){
			return 0;
		}
		if ($$cmp_frame1{"$tmp_base1.$_"} eq $$cmp_frame2{"$tmp_base2.$_"}) {
			my $msg = "<b><font color='blue'>$_ matched.</font></b>:";
			$msg .= $$cmp_frame1{"$tmp_base1.$_"};
			$msg .= " == ";
			$msg .= $$cmp_frame2{"$tmp_base2.$_"};
			$msg .= "<BR>";
			vLogHTML($msg);
			$unmatch = compare_option($cmp_frame1,"$tmp_base1.$_",$cmp_frame2,"$tmp_base2.$_");
		} else {
			my $msg = "<b><font color='red'>$_ unmatched.</font></b>:";
			$msg .= $$cmp_frame1{"$tmp_base1.$_"};
			$msg .= " != ";
			$msg .= $$cmp_frame2{"$tmp_base2.$_"};
			$msg .= "<BR>";
			vLogHTML($msg);
			return 1;
		}
	}
	return $unmatch;
}

#--------------------------------------------------------------#
# chkMsgAfterRelay(\$Org_frame, \$Frame_Relay)                 #
#                                                              #
# Notes:                                                       #
#    compare messages between before relay & after relay       #
#    MATCH: return 0                                           #
#    UNMATCH: return 1                                         #
#--------------------------------------------------------------#
sub chkMsgAfterRelay($$) {
	my ($ref_org_frame,$ref_frame_Relay) = @_;
	my $strBaseIndex = "Frame_Ether.Packet_IPv6.Upp_UDP";

	#Get the Relay type(Relay-forward or Relay-reply)
	#Hdr_UDP Udp_DHCPv6_RelayForward
	my $strRelayIndex = $$ref_frame_Relay{"$strBaseIndex"};
	return 1 if(!defined($strRelayIndex));

	if($strRelayIndex =~ /RelayForward/){
		$strRelayIndex = $strBaseIndex.".Udp_DHCPv6_RelayForward.Opt_DHCPv6_RelayMessage.";
	}
	elsif ($strRelayIndex =~ /RelayReply/){
		$strRelayIndex = $strBaseIndex.".Udp_DHCPv6_RelayReply.Opt_DHCPv6_RelayMessage.";
	}

	#Get the Org Msg type
	#Sample:  Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Solicit
	my ($ret,$orgMsgtype) = getMsgTypeLocStr($ref_org_frame);
	DebugStrOut("the full original Msg string is $orgMsgtype<BR>");
	if(1== $ret){
		return 1;
	}

	my $Msgtype = undef;
	if($orgMsgtype =~ /Frame_Ether.Packet_IPv6.Upp_UDP.(.*)/){
		$Msgtype = $1;
		DebugStrOut("The original Msg type is $Msgtype<BR>");
	}

	#Compare the contents between 2 frames
	my $str_org_key = undef;
	foreach (keys %$ref_org_frame){
		$str_org_key = $_;
		if($str_org_key=~ /Frame_Ether.Packet_IPv6.Upp_UDP.$Msgtype(.*)/){
			if($$ref_org_frame{$str_org_key} ne $$ref_frame_Relay{"$strRelayIndex$Msgtype".$1}){
				DebugStrOut("orgin:  $str_org_key  -->  $$ref_org_frame{$str_org_key}<BR>");
				my $temp = "$strRelayIndex$Msgtype".$1;
				DebugStrOut("Relay: $temp $$ref_frame_Relay{$temp}<BR>");			
				return 1;
			}
		}
	}

	vLogHTML("Relayed message is consitent with the orginal message!<BR>");
	return 0;
}

#--------------------------------------------------------------#
# options_exist($frame, $optnum)                               #
#                                                              #
# Notes:                                                       #
#    check if specified options exist or not.                  #
#                                                              #
# return:                                                      #
#      0: exist                                                #
#      1: not exist                                            #
#--------------------------------------------------------------#
sub options_exist($$) {
	my ($frame, $optnum) = @_;
	my $targetopt = "";
	my $notfound = 0;
	my $base;

	vLogHTML("Checking existing option...<BR>");
	
	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		last if (defined($$frame{$base}));
		$base = "";
	}

	foreach(keys %option_defs) {
		if (0 != ($_ & $optnum)) {
#			vLogHTML("Checking $option_defs{$_} ");
			if (! defined($$frame{"$base"."."."$option_defs{$_}"})) {
				vLogHTML("<B>$option_defs{$_} not found</B><BR>");
				$notfound++;
			} 
			else {
				vLogHTML("<B>$option_defs{$_} found<BR></B>");
			}
		}
	}
	
	return 1 if (0 != $notfound);
	return 0;
}


#-------------------------------------------------------------#
# suboptions_exist($frame,$optnum)                            #
# Note                                                        #
#      check the existence of sub option in the $frame        #
# Input:                                                      #
#      $frame: reference of packet frame                      #
# return:                                                     #
#      0: exist                                               #
#      1: not exist                                           #
#-------------------------------------------------------------#
sub suboptions_exist($$){
	my($frame,$optnum) = @_;

	my $FlagAllFound = 0;
	my $strCMP= undef;
	my $FlagFound = 0;
	
	vLogHTML("Checking existing sub options...<BR>");
	foreach (keys %option_defs) {
		if (0 != ($_ & $optnum)) {
			my $optionname = $option_defs{$_};
			next if (!defined($optionname));
			$strCMP = "$optionname#";
			$FlagFound = 0;
#			vLogHTML("Begin check $optionname.<BR>");
			foreach my $title  (keys %$frame){
				if($title =~  /$strCMP/){
					vLogHTML("<B>$optionname found</B><BR>");
					$FlagAllFound |= $_;
					$FlagFound = 1;
					last;
				};
			}
			vLogHTML("<B>$optionname not found</B><BR>") unless $FlagFound;
		}
	}

	if( $optnum != $FlagAllFound){
		return 1;
	}

	return 0;
	
}


#--------------------------------------------------------------#
#  option_exist($frame,$strIndex)                              #
#  Note:                                                       #
#       check if the special Option indexed by the $strIndex   #
#       exists in the $frame                                   #
#                                                              #
#  Input:                                                      #
#       $frame: reference of packet frame                      #
#       $str_index:index string for access the special field   #
#                  in the result hash.                         #
#  return:                                                     #
#       0: exist                                               #
#       1: not exist                                           #
#   undef: error                                               #
#--------------------------------------------------------------#
sub option_exist($$){
	my($frame,$str_index) = @_;
	my $optionname = $str_index;

#	$str_index =~/\w+$/;
#	$optionname = $&;

	#Get message type by index;
	vLogHTML("Checking existing option more specific...<BR>");
	my $MsgTypeFrame = getMsgTypeLocStr($frame);
	if(!defined($MsgTypeFrame)){
		vLogHTML("<B>Message label not found</B><BR>");
		return undef;	
	}

	$MsgTypeFrame .= ".$str_index";
	#vLogHTML("Index is $str_index<BR>");
	if($$frame{$MsgTypeFrame}){
		vLogHTML("<B>$optionname found</B><BR>");
		return 0;
	}
	vLogHTML("<B>$optionname not found</B><BR>");
	return 1;	
}


#--------------------------------------------------------------#
# check_statuscode($ref_frame,$message_label,$code)            #
#                                                              #
# Return                                                       #
#	0 match                                                #
#	1 not match                                            #
# Notes:                                                       #
#	The $code is value of the status code                  #
#                                                              #
#--------------------------------------------------------------#
sub check_statuscode($$$) {
	my ($ref_frame,$message_label,$status_code) = @_;
	vLogHTML("Checking status code...<BR>");
	my $statusName = get_statuscode_string($status_code);
	my $retStatusCode = get_field_value($ref_frame,$message_label);
#print "statusname:$statusName\n";
#print "retStatusCode:$retStatusCode\n";

	if($status_code == $retStatusCode){
		vLogHTML("<B>Status code is $status_codes{$retStatusCode}($retStatusCode): match</B><BR>");
		return 0;
	}
#	my $indexstr = undef;
#	foreach  (keys (%$ref_frame)){
#		$indexstr = $_;
#		#vLogHTML("string index $indexstr <BR>");
#		if($indexstr =~ /(.*)Opt_DHCPv6_StatusCode([2-9]*).StatusCode([1-9]*)$/){
#			#vLogHTML("matched string index $indexstr ,value  $$ref_frame{$indexstr}<BR>");
#			#vLogHTML("expected status: $status_code<BR>");
#			if($status_code == $$ref_frame{$indexstr}){
#				vLogHTML("The status code $statusName has been returned<BR>");
#				return 0;
#			}
#		}
#	}
	vLogHTML("<B>Status code is $status_codes{$retStatusCode}($retStatusCode): not match</B><BR>");
	return 1;
}

#--------------------------------------------------------------#
# get_statuscode_string($code)                                 #
#                                                              #
# Notes:                                                       #
#     return Status Codes Name                                 #
#                                                              #
#--------------------------------------------------------------#
sub get_statuscode_string($) {
	my ($val) = @_;
	return $status_codes{$val};
}
#--------------------------------------------------------------#
# get_optname_string($code)                                    #
#                                                              #
# Notes:                                                       #
#     return Option Codes Name                                 #
#                                                              #
#--------------------------------------------------------------#
sub get_optname_string($) {
	my ($val) = @_;
	return $option_codes{$val};
}
#--------------------------------------------------------------#
# parse_message($frame)                                        #
#                                                              #
# Notes:                                                       #
#	parse and show DHCPv6 Messages                         #
#                                                              #
#--------------------------------------------------------------#
sub parse_message($) {
	my ($frame) = @_;
	my $base;
	my $msgType;
	
	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		if (defined($$frame{"$base"})) {
			$msgType = $_;
			last;
		}
		$base = "";
	}

	message_output($frame,$msgType,$base);
	return;
}


#--------------------------------------------------------------#
# get_DUID_type_conf()                                     #
#                                                              #
# Notes:                                                       #
#	From configfile,get the DUID type            #
#                                                              #
# IN:                                                          #
#       $frame                                                 #   
# return:                                                      #
#       0: No DUID type                                      #     
#       others: DUID type                         #
#                                                              #
#--------------------------------------------------------------#
sub get_DUID_type_conf() {
	my $duidtype;

	if (!ChkAdvFunc('DUID_LLT')) {
		return 1;
	}
	if (!ChkAdvFunc('DUID_EN')) {
		return 2;
	}
	if (!ChkAdvFunc('DUID_LL')) {
		return 3;
	}

	return 0;
}

#--------------------------------------------------------------#
# get_IA_NA_number($frame)                                     #
#                                                              #
# Notes:                                                       #
#	From message,get the number of IA_NA option            #
#                                                              #
# IN:                                                          #
#       $frame                                                 #   
# return:                                                      #
#       0: No IA_NA option                                     #     
#       others: number of IA_NA option                         #
#                                                              #
#--------------------------------------------------------------#
sub get_IA_NA_number($) {
	my ($frame) = @_;
	my $base;

	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		if (defined($$frame{"$base"})) {
			last;
		}
		$base = "";
	}
	
	if(!defined($$frame{"$base"."."."Opt_DHCPv6_IA_NA.Identifier"})){
		return 0;
	}

	my $number = 1;
	my $num = $number + 1;
	while(defined($$frame{$base."."."Opt_DHCPv6_IA_NA".$num."."."Identifier"})){
#		vLogHTML("<B><FONT COLOR=\"#FF0000\">$base.Opt_DHCPv6_IA_NA$num.Identifier</FONT></B><BR>");
		$num ++;
	}
	if($num > 2){
		$number = $num - 1; 
	}
	return $number;
}

#--------------------------------------------------------------#
# get_IA_PD_number($frame)                                     #
#                                                              #
# Notes:                                                       #
#	From message,get the number of IA_PD option            #
#                                                              #
# IN:                                                          #
#       $frame                                                 #   
# return:                                                      #
#       0: No IA_PD option                                     #     
#       others: number of IA_PD option                         #
#                                                              #
#--------------------------------------------------------------#
sub get_IA_PD_number($) {

	my ($frame) = @_;
	my $base;

	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		if (defined($$frame{"$base"})) {
			last;
		}
		$base = "";
	}
	
	if(!defined($$frame{"$base"."."."Opt_DHCPv6_IA_PD.Identifier"})){
		return 0;
	}

	my $number = 1;
	my $num = $number + 1;
	while(defined($$frame{$base."."."Opt_DHCPv6_IA_PD".$num."."."Identifier"})){
#		vLogHTML("<B><FONT COLOR=\"#FF0000\">$base.Opt_DHCPv6_IA_PD$num.Identifier</FONT></B><BR>");
		$num ++;
	}
	if($num > 2){
		$number = $num -1;
	}	
	return $number;
}

#--------------------------------------------------------------#
# get_IA_Prefix_number($frame)                                 #
#                                                              #
# Notes:                                                       #
#	From message,get the number of IA_PD Prefix option     #
#                                                              #
# IN:                                                          #
#       $frame                                                 #   
# return:                                                      #
#       0: No IA_PD Prefix option                              #     
#       others: number of IA_PD Prefix option                  #
#                                                              #
#--------------------------------------------------------------#
sub get_IA_Prefix_number($){
	my ($frame) = @_;
	my $base;

	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		if (defined($$frame{"$base"})) {
			last;
		}
		$base = "";
	}
	
	if(!defined($$frame{"$base"."."."Opt_DHCPv6_IA_PD.Opt_DHCPv6_IA_Prefix.Code"})){
		return 0;
	}

	my $number = 1;
	my $num = $number + 1;
	while(defined($$frame{$base."."."Opt_DHCPv6_IA_PD.Opt_DHCPv6_IA_Prefix".$num."."."Code"})){
		$num ++;
	}
	if($num > 2){
		$number = $num -1;
	}	
	return $number;
}


#--------------------------------------------------------------#
# CompareTimeUpdateCompletely($ref_frame1,$ref_frame2,$strMsgType1,$strMsgType2)                                 #
# Notes:                                                       #
#check if the message has updated completely     #
#                                                              #
# IN:                                                          #
#       $ref_frame1                                                 #   
#       $ref_frame2                                                 #   
#       $strMsgType1                                                 #   
#       $strMsgType2                                                 #   
# return:                                                      #
#       0: Has update completely                             #     
#       1: Not update               #
#                                                              #
#--------------------------------------------------------------#
sub CompareTimeUpdateCompletely($$$$){
	my ($ref_frame1,$ref_frame2,$strMsgType1,$strMsgType2) = @_;

	my $strBase1 = $dhcp6_messages{$strMsgType1};
	my $strBase2 = $dhcp6_messages{$strMsgType2};

	
	#check the new lifetimes & T1/T2 times
	my $Base_T1 =$$ref_frame1{"$strBase1.Opt_DHCPv6_IA_NA.Time1"};
	my $Base_T2 =$$ref_frame1{"$strBase1.Opt_DHCPv6_IA_NA.Time2"};
	my $T1 = $$ref_frame2{"$strBase2.Opt_DHCPv6_IA_NA.Time1"};
	my $T2 = $$ref_frame2{"$strBase2.Opt_DHCPv6_IA_NA.Time2"};
	my $Base_PreTime = $$ref_frame1{"$strBase1.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.PreferredLifetime"};
	my $Base_LifeTime = $$ref_frame1{"$strBase1.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.ValidLifetime"};
	my $PreTime = $$ref_frame2{"$strBase2.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.PreferredLifetime"};
	my $LifeTime = $$ref_frame2{"$strBase2.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_Address.ValidLifetime"};

	#vLogHTML("$strBase1.Opt_DHCPv6_IA_NA.Time1");

	if(!defined($Base_PreTime)|| !defined($Base_LifeTime)|| !defined($Base_T1) || !defined($Base_T2)){
		vLogHTML("<B>The IA option in $strMsgType1 is not correctly.</B><BR>");
		return 1;
	}
	
	if(!defined($PreTime)|| !defined($LifeTime)|| !defined($T1) || !defined($T2)){
		vLogHTML("<B>The IA option in $strMsgType2 is not correctly.</B><BR>");
		return 1;
	}
	
	if ($Base_T1 == $T1){
		vLogHTML("Invalid T1,(Not update)");
		return 1;
	}
	if ($Base_T2 == $T2){
		vLogHTML("Invalid T2,(Not update)");
		return 1;
	}
	if ($Base_PreTime == $PreTime){
		vLogHTML("Invalid Preferred life time,(Not update)");
		return 1;
	}
	if ($Base_LifeTime == $LifeTime){
		vLogHTML("Invalid Valid life time,(Not update)");
		return 1;
	}
	return 0;
}

#-------------------------------------------------------------------------
#message_output($frame,$msgtype,$basestr)
#
#------------------------------------------------------------------------
sub message_output($$$){
	my ($frame,$msgType,$orgbase) = @_;
	my $optbase = undef;
	my $optionstr = undef;
	my $base = undef;
	
	# HTML start
	if( "Relay Message option" eq $msgType){
		vLogHTML("<B>Relay Message Option </B><BR>");
		foreach(keys %dhcp6_messages_title) {
			$base = "$orgbase.".$dhcp6_messages_title{$_};
			if (defined($$frame{"$base"})) {
				$msgType = $_;
				last;
			}
			$base = "";
		}
		if("" ne $base){
			vLogHTML("<B>$msgType Message in Relay Message Option</B><BR>");
		}
	}else{
		vLogHTML("<B>$msgType Message</B><BR>");
		$base = $orgbase;

	}
	
	vLogHTML("<table BORDER=1>");
	vLogHTML("<tr><td>DHCPv6 Option</td><td>Values</td></tr>");
	
	foreach(keys %option_defs) {
		my $i = 0;
		$optbase = "$base"."."."$option_defs{$_}";
		$optionstr = "";
		
		if (! defined($$frame{"$optbase"})) {
			next;
		}
		
		# Opt_DHCPv6_CID or Opt_DHCPv6_SID
		if (("Opt_DHCPv6_CID" eq $option_defs{$_}) || ("Opt_DHCPv6_SID" eq $option_defs{$_})) {
			if(defined($$frame{"$optbase\.DHCPv6_DUID_LLT_Ether"})) {
				$optionstr .= "<B>DUID-LLT</B> HardwareType = ".$$frame{"$optbase\.DHCPv6_DUID_LLT_Ether\.HardwareType"}."<BR>";
				$optionstr .= "<B>DUID-LLT</B> MAC = ".$$frame{"$optbase\.DHCPv6_DUID_LLT_Ether\.LinkLayerAddress"}."<BR>";
				$optionstr .= "<B>DUID-LLT</B> TIME = ".$$frame{"$optbase\.DHCPv6_DUID_LLT_Ether\.Time"}."<BR>";
			}
			if(defined($$frame{"$optbase\.DHCPv6_DUID_LLT_ANY"})) {
				$optionstr .= "<B>DUID-LLT(not Ethernet)</B> MAC= ".$$frame{"$optbase\.DHCPv6_DUID_LLT_ANY\.LinkLayerAddress"}."<BR>";
				$optionstr .= "<B>DUID-LLT(not Ethernet)</B> TIME= ".$$frame{"$optbase\.DHCPv6_DUID_LLT_ANY\.Time"}."<BR>";
			}
			if(defined($$frame{"$optbase\.DHCPv6_DUID_EN"})) {
				$optionstr .= "<B>DUID-EN</B> EnterpriseNumber= ".$$frame{"$optbase\.DHCPv6_DUID_EN\.EnterpriseNumber"}."<BR>";
				$optionstr .= "<B>DUID-EN</B> Identifier= ".$$frame{"$optbase\.DHCPv6_DUID_EN\.Identifier"}."<BR>";
			}
			if(defined($$frame{"$optbase\.DHCPv6_DUID_LL_Ether"})) {
				$optionstr .= "<B>DUID-LL</B> HardwareType = ".$$frame{"$optbase\.DHCPv6_DUID_LL_Ether\.HardwareType"}."<BR>";
				$optionstr .= "<B>DUID-LL</B> LinkLayerAddress= ".$$frame{"$optbase\.DHCPv6_DUID_LL_Ether\.LinkLayerAddress"}."<BR>";
			}
			if(defined($$frame{"$optbase\.DHCPv6_DUID_ANY"})) {
				$optionstr .= "<B>DUID (unknown)</B><BR>";
			}
		}
		
		# Opt_DHCPv6_IA_NA (process multi- IA_NA)
		if ("Opt_DHCPv6_IA_NA" eq $option_defs{$_}) {
			$optionstr .= "<B>Option 1</B>"."<BR>";
			$optionstr .= "Identifier= ".$$frame{"$optbase\.Identifier"}."<BR>";
			$optionstr .= "T1= ".$$frame{"$optbase\.Time1"}."<BR>";
			$optionstr .= "T2= ".$$frame{"$optbase\.Time2"}."<BR>";
			if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Address"})) {
				$optionstr .= "<B>#IA_Addr Option</B><BR>";
				$optionstr .= "Addr= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address\.Address"}."<BR>";
				$optionstr .= "PreferredLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address\.PreferredLifetime"}."<BR>";
				$optionstr .= "ValidLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address\.ValidLifetime"}."<BR>";
				if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Address.Opt_DHCPv6_StatusCode"})) {
					$optionstr .= "<B>#StatusCode Option</B><BR>";
					$optionstr .= "StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
					$optionstr .= get_statuscode_string($$frame{"$optbase\.Opt_DHCPv6_IA_Address\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
				}
			}
			my $number = 2;

			#	while(defined($$frame{"$optbase.Opt_DHCPv6_IA_Address$number"})){
			#	$optionstr .= "<B>#IA_Addr Option $number</B><BR>";
			#	$optionstr .= "Addr= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address$number\.Address"}."<BR>";
			#	$optionstr .= "PreferredLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address$number\.PreferredLifetime"}."<BR>";
			#	$optionstr .= "ValidLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address$number\.ValidLifetime"}."<BR>";
			#	if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Address$number.Opt_DHCPv6_StatusCode"})) {
			#		$optionstr .= "<B>#StatusCode Option</B><BR>";
			#		$optionstr .= "StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address$number\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
			#	 	$optionstr .= get_statuscode_string($$frame{"$optbase\.Opt_DHCPv6_IA_Address$number\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
			#	 
			#	}
			#	$number ++ ;
			#}	
			
			if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Address2"})){
				$optionstr .= "<B>#IA_Addr Option 2</B><BR>";
				$optionstr .= "Addr= ".$$frame{"$optbase.Opt_DHCPv6_IA_Address2.Address"}."<BR>";
				$optionstr .= "PreferredLifetime= ".$$frame{"$optbase.Opt_DHCPv6_IA_Address2\.PreferredLifetime"}."<BR>";
				$optionstr .= "ValidLifetime= ".$$frame{"$optbase.Opt_DHCPv6_IA_Address2\.ValidLifetime"}."<BR>";
			
				if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Address2\.Opt_DHCPv6_StatusCode"})){
					$optionstr .= "<B>#StatusCode Option</B><BR>";
					$optionstr .= "StatusCode= ".$$frame{"$optbase.Opt_DHCPv6_IA_Address2\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
					$optionstr .= get_statuscode_string($$frame{"$optbase.Opt_DHCPv6_IA_Address2\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
				}
			}	
			#if(defined($$frame{"$optbase.Opt_DHCPv6_StatusCode"})) {
				#$optionstr .= "<B>#StatusCode Option</B><BR> StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
				#$optionstr .= get_statuscode_string($$frame{"$optbase\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
				#}
			#while(defined($$frame{"$optbase$count"})){
				
				#vLogHTML("optbase = $optbase <BR>");
				#vLogHTML("optbase$coutn = $optbase$count");

			#my $iaaddrnum = 2;
			#my $optiaaddr = "$optbase.Opt_DHCPv6_IA_Address$iaaddrnum";

			#	while(defined($$frame{"$optiaaddr"})){
			#	$optionstr .= "<B>#IA_Addr Option $iaaddrnum</B><BR>";
			#	$optionstr .= "Addr= ".$$frame{"$optiaaddr\.Address"}."<BR>";
			#	$optionstr .= "PreferredLifetime= ".$$frame{"$optiaaddr\.PreferredLifetime"}."<BR>";
			#	$optionstr .= "ValidLifetime= ".$$frame{"$optiaaddr\.ValidLifetime"}."<BR>";
			
			#	if(defined($$frame{"$optiaaddr\.Opt_DHCPv6_StatusCode"})){
			#		$optionstr .= "<B>#StatusCode Option</B><BR>";
			#		$optionstr .= "StatusCode= ".$$frame{"$optiaaddr\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
			#		$optionstr .= get_statuscode_string($$frame{"$optiaaddr\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
			#	}
			#	$iaaddrnum++;
			#}
				
			if(defined($$frame{"$optbase.Opt_DHCPv6_StatusCode"})) {
				$optionstr .= "<B>#StatusCode Option</B><BR> StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
				$optionstr .= get_statuscode_string($$frame{"$optbase\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
			}
			my $count =2;
			#vLogHTML("$optbase$count");
			while(defined($$frame{"$optbase$count"})){
				
				#vLogHTML("optbase = $optbase <BR>");
				#vLogHTML("optbase$coutn = $optbase$count");
				
				$optionstr .= "<B>Option $count"."</B><BR>";
				$optionstr .= "Identifier= ".$$frame{"$optbase$count\.Identifier"}."<BR>";
				$optionstr .= "T1= ".$$frame{"$optbase$count\.Time1"}."<BR>";
				$optionstr .= "T2= ".$$frame{"$optbase$count\.Time2"}."<BR>";
				if(defined($$frame{"$optbase$count.Opt_DHCPv6_IA_Address"})) {
					$optionstr .= "<B>#IA_Addr Option</B><BR>";
					$optionstr .= "Addr= ".$$frame{"$optbase$count\.Opt_DHCPv6_IA_Address\.Address"}."<BR>";
					$optionstr .= "PreferredLifetime= ".$$frame{"$optbase$count\.Opt_DHCPv6_IA_Address\.PreferredLifetime"}."<BR>";
					$optionstr .= "ValidLifetime= ".$$frame{"$optbase$count\.Opt_DHCPv6_IA_Address\.ValidLifetime"}."<BR>";
					if(defined($$frame{"$optbase$count.Opt_DHCPv6_IA_Address.Opt_DHCPv6_StatusCode"})) {
						$optionstr .= "<B>#StatusCode Option</B><BR>";
						$optionstr .= "StatusCode= ".$$frame{"$optbase$count\.Opt_DHCPv6_IA_Address\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
						$optionstr .= get_statuscode_string($$frame{"$optbase$count\.Opt_DHCPv6_IA_Address\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
					}
				}
				if(defined($$frame{"$optbase$count.Opt_DHCPv6_StatusCode"})) {
					$optionstr .= "<B>#StatusCode Option</B><BR> StatusCode= ".$$frame{"$optbase$count\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
					$optionstr .= get_statuscode_string($$frame{"$optbase$count\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
				}
				$count++;
			}
		}

		# Opt_DHCPv6_IA_TA
		if ("Opt_DHCPv6_IA_TA" eq $option_defs{$_}) {
			$optionstr .= "Identifier= ".$$frame{"$optbase\.Identifier"}."<BR>";
			if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Address"})) {
				$optionstr .= "<B>#IA_Addr Option</B><BR>";
				$optionstr .= "Addr= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address\.Address"}."<BR>";
				$optionstr .= "PreferredLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address\.PreferredLifetime"}."<BR>";
				$optionstr .= "ValidLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address\.ValidLifetime"}."<BR>";
				if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Address.Opt_DHCPv6_StatusCode"})) {
					$optionstr .= "<B>#StatusCode Option</B><BR>";
					$optionstr .= "StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Address\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
					$optionstr .= get_statuscode_string($$frame{"$optbase\.Opt_DHCPv6_IA_Address\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
				}
			}
			if(defined($$frame{"$optbase\.Opt_DHCPv6_StatusCode"})) {
				$optionstr .= "<B>#StatusCode Option</B><BR> StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_StatusCode\.StatusCode"};
			}
		}
		
		# Opt_DHCPv6_IA_PD
	#	if ("Opt_DHCPv6_IA_PD" eq $option_defs{$_}) {
	#		$optionstr .= "Identifier= ".$$frame{"$optbase\.Identifier"}."<BR>";
	#		$optionstr .= "T1= ".$$frame{"$optbase\.Time1"}."<BR>";
	#		$optionstr .= "T2= ".$$frame{"$optbase\.Time2"}."<BR>";
	#		if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Prefix#"})) {
	#			my $count = $$frame{"$optbase.Opt_DHCPv6_IA_Prefix#"};
	#			for(my $i=1; $i<=$count;$i++){
	#				$optionstr .= "<B>#IA_Prefix Option $i</B><BR>";
	#				if(1 == $i){
	#					$optionstr .= "Prefix= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.Prefix"}."<BR>";
	#					$optionstr .= "Prefix Length= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.PrefixLength"}."<BR>";
	#					$optionstr .= "PreferredLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.PreferredLifetime"}."<BR>";
	#					$optionstr .= "ValidLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.ValidLifetime"}."<BR>";
	#					if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Prefix.Opt_DHCPv6_StatusCode"})) {
	#						$optionstr .= "<B>#StatusCode Option</B><BR>";
	#						$optionstr .= "StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
	#						$optionstr .= get_statuscode_string($$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
	#					}
	#				}
	#				else{
	#					$optionstr .= "Prefix= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix$i\.Prefix"}."<BR>";
	#					$optionstr .= "Prefix Length= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix$i\.PrefixLength"}."<BR>";
	#					$optionstr .= "PreferredLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix$i\.PreferredLifetime"}."<BR>";
	#					$optionstr .= "ValidLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix$i\.ValidLifetime"}."<BR>";
	#					if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Prefix$i.Opt_DHCPv6_StatusCode"})) {
	#						$optionstr .= "<B>#StatusCode Option</B><BR>";
	#						$optionstr .= "StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix$i\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
	#						$optionstr .= get_statuscode_string($$frame{"$optbase\.Opt_DHCPv6_IA_Prefix$i\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
	#					}
	#				}
	#			}
	#		}
	#	}
                # Opt_DHCPv6_IA_PD (process multi- IA_PD)
                if ("Opt_DHCPv6_IA_PD" eq $option_defs{$_}) {
                        $optionstr .= "<B>Option 1</B>"."<BR>";
                        $optionstr .= "Identifier= ".$$frame{"$optbase\.Identifier"}."<BR>";
                        $optionstr .= "T1= ".$$frame{"$optbase\.Time1"}."<BR>";
                        $optionstr .= "T2= ".$$frame{"$optbase\.Time2"}."<BR>";
                        if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Prefix"})) {
                                $optionstr .= "<B>#IA_Prefix Option</B><BR>";
                                $optionstr .= "Prefix= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.Prefix"}."<BR>";
                                $optionstr .= "PreferredLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.PreferredLifetime"}."<BR>";
                                $optionstr .= "ValidLifetime= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.ValidLifetime"}."<BR>";
                                if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Prefix.Opt_DHCPv6_StatusCode"})) {
                                        $optionstr .= "<B>#StatusCode Option</B><BR>";
                                        $optionstr .= "StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
                                        $optionstr .= get_statuscode_string($$frame{"$optbase\.Opt_DHCPv6_IA_Prefix\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
                                }
                        }
                        my $number = 2;
                        if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Prefix2"})){
                                $optionstr .= "<B>#IA_Prefix Option 2</B><BR>";
                                $optionstr .= "Prefix= ".$$frame{"$optbase.Opt_DHCPv6_IA_Prefix2.Prefix"}."<BR>";
                                $optionstr .= "PreferredLifetime= ".$$frame{"$optbase.Opt_DHCPv6_IA_Prefix2\.PreferredLifetime"}."<BR>";
                                $optionstr .= "ValidLifetime= ".$$frame{"$optbase.Opt_DHCPv6_IA_Prefix2\.ValidLifetime"}."<BR>";
                        
                                if(defined($$frame{"$optbase.Opt_DHCPv6_IA_Prefix2\.Opt_DHCPv6_StatusCode"})){
                                        $optionstr .= "<B>#StatusCode Option</B><BR>";
                                        $optionstr .= "StatusCode= ".$$frame{"$optbase.Opt_DHCPv6_IA_Prefix2\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
                                        $optionstr .= get_statuscode_string($$frame{"$optbase.Opt_DHCPv6_IA_Prefix2\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
                                }
                        }       
                        if(defined($$frame{"$optbase.Opt_DHCPv6_StatusCode"})) {
                                $optionstr .= "<B>#StatusCode Option</B><BR> StatusCode= ".$$frame{"$optbase\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
                                $optionstr .= get_statuscode_string($$frame{"$optbase\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
                        }
                        my $count =2;
                        #vLogHTML("$optbase$count");
                        while(defined($$frame{"$optbase$count"})){
                                
                                #vLogHTML("optbase = $optbase <BR>");
                                #vLogHTML("optbase$coutn = $optbase$count");
                                
                                $optionstr .= "<B>Option $count"."</B><BR>";
                                $optionstr .= "Identifier= ".$$frame{"$optbase$count\.Identifier"}."<BR>";
                                $optionstr .= "T1= ".$$frame{"$optbase$count\.Time1"}."<BR>";
                                $optionstr .= "T2= ".$$frame{"$optbase$count\.Time2"}."<BR>";
                                if(defined($$frame{"$optbase$count.Opt_DHCPv6_IA_Prefix"})) {
                                        $optionstr .= "<B>#IA_Prefix Option</B><BR>";
                                        $optionstr .= "Prefix= ".$$frame{"$optbase$count\.Opt_DHCPv6_IA_Prefix\.Prefix"}."<BR>";
                                        $optionstr .= "PreferredLifetime= ".$$frame{"$optbase$count\.Opt_DHCPv6_IA_Prefix\.PreferredLifetime"}."<BR>";
                                        $optionstr .= "ValidLifetime= ".$$frame{"$optbase$count\.Opt_DHCPv6_IA_Prefix\.ValidLifetime"}."<BR>";
                                        if(defined($$frame{"$optbase$count.Opt_DHCPv6_IA_Prefix.Opt_DHCPv6_StatusCode"})) {
                                                $optionstr .= "<B>#StatusCode Option</B><BR>";
                                                $optionstr .= "StatusCode= ".$$frame{"$optbase$count\.Opt_DHCPv6_IA_Prefix\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
                                                $optionstr .= get_statuscode_string($$frame{"$optbase$count\.Opt_DHCPv6_IA_Prefix\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
                                        }
                                }
                                if(defined($$frame{"$optbase$count.Opt_DHCPv6_StatusCode"})) {
                                        $optionstr .= "<B>#StatusCode Option</B><BR> StatusCode= ".$$frame{"$optbase$count\.Opt_DHCPv6_StatusCode\.StatusCode"}." ";
                                        $optionstr .= get_statuscode_string($$frame{"$optbase$count\.Opt_DHCPv6_StatusCode\.StatusCode"})." <BR>";
                                }
                                $count++;
                        }
		}


		# Opt_DHCPv6_OptionRequest
		if ("Opt_DHCPv6_OptionRequest" eq $option_defs{$_}) {
			$optionstr .= "OptionCode = ".$$frame{"$optbase.OptionCode"}." ".get_optname_string($$frame{"$optbase.OptionCode"})."<BR>";
			for (my $n=0; $n<20; $n++) {
				if (defined ($$frame{"$optbase.OptionCode_$n"})) {
					$optionstr .= "OptionCode = ".$$frame{"$optbase.OptionCode_$n"}." ".get_optname_string($$frame{"$optbase.OptionCode_$n"})."<BR>";
				}
			}
		}
		# Opt_DHCPv6_Preference
		if ("Opt_DHCPv6_Preference" eq $option_defs{$_}) {
			$optionstr .= "Preference = ".$$frame{"$optbase\.Preference"}."<BR>";
		}
		# Opt_DHCPv6_ElapsedTime
		if ("Opt_DHCPv6_ElapsedTime" eq $option_defs{$_}) {
			$optionstr .= "Time = ".$$frame{"$optbase\.Time"}."<BR>";
		}
		# Opt_DHCPv6_RelayMessage
		if ("Opt_DHCPv6_RelayMessage" eq $option_defs{$_}) {
			$optionstr = "";
		}
		# Opt_DHCPv6_Authentication
		if ("Opt_DHCPv6_Authentication" eq $option_defs{$_}) {
			$optionstr .= "Protocol = ".$$frame{"$base\.Opt_DHCPv6_Authentication\.Protocol"}."<BR>";
			$optionstr .= "Algorithm = ".$$frame{"$base\.Opt_DHCPv6_Authentication\.Algorithm"}."<BR>";
			$optionstr .= "ReplayDetection = ".$$frame{"$base\.Opt_DHCPv6_Authentication\.ReplayDetection"}."<BR>";
			$optionstr .= "<B>Authentication information</B>:"."<BR>";
			if ($$frame{"$base\.Opt_DHCPv6_Authentication\.Protocol"} eq '2'){
				if(defined($$frame{"$base\.Opt_DHCPv6_Authentication\.DHCPv6_Auth_Delayed\.Realm"})){
					$optionstr .= "<DD>DHCP realm = ".$$frame{"$base\.Opt_DHCPv6_Authentication\.DHCPv6_Auth_Delayed\.Realm"}."<BR>";
					$optionstr .= "<DD>key ID = ".$$frame{"$base\.Opt_DHCPv6_Authentication\.DHCPv6_Auth_Delayed\.Identifier"}."<BR>";
					$optionstr .= "<DD>HMAC-MD5 = ".$$frame{"$base\.Opt_DHCPv6_Authentication\.DHCPv6_Auth_Delayed\.Authenticator"}."<BR>";
				}
				else{
					$optionstr .= "<DD><B>Nothing</B>"."<BR>";
				}
			}
			elsif ($$frame{"$base\.Opt_DHCPv6_Authentication\.Protocol"} eq '3'){
				$optionstr .= "<DD>Type = ".$$frame{"$base\.Opt_DHCPv6_Authentication\.DHCPv6_Auth_ReconfigureKey\.Type"}."<BR>";
				$optionstr .= "<DD>Value = ".$$frame{"$base\.Opt_DHCPv6_Authentication\.DHCPv6_Auth_ReconfigureKey\.data"}."<BR>";
			}
		}
		# Opt_DHCPv6_ServerUnicast
		if ("Opt_DHCPv6_ServerUnicast" eq $option_defs{$_}) {
			$optionstr .= "Address= ".$$frame{"$base\.Opt_DHCPv6_ServerUnicast\.Address"}."<BR>";
		}
		# Opt_DHCPv6_StatusCode
		if ("Opt_DHCPv6_StatusCode" eq $option_defs{$_}) {
			$optionstr = "StatusCode= ".$$frame{"$optbase\.StatusCode"}." ";
			$optionstr .= get_statuscode_string($$frame{"$optbase\.StatusCode"})." <BR>";
			for ($i=2; $i<5; $i++) {
				if (defined ($$frame{"$optbase$i\.StatusCode"})) {
					$optionstr .= "StatusCode= ".$$frame{"$optbase$i\.StatusCode"}." ";
					$optionstr .= get_statuscode_string($$frame{"$optbase$i\.StatusCode"})." <BR>";
				}
			}
		}
		# Opt_DHCPv6_RapidCommit
		if ("Opt_DHCPv6_RapidCommit" eq $option_defs{$_}) {
			$optionstr = "*";
		}
		# Opt_DHCPv6_UserClass or Opt_DHCPv6_VendorClass
		if (("Opt_DHCPv6_UserClass" eq $option_defs{$_}) || ("Opt_DHCPv6_VendorClass" eq $option_defs{$_})) {
			# $optionstr .= "data = ".$$frame{'"$optbase"."$option_defs{$_}".".data"'}."<BR>";
		}
		# Opt_DHCPv6_VendorSpecificInfo
		if ("Opt_DHCPv6_VendorSpecificInfo" eq $option_defs{$_}) {
			$optionstr .= "EnterpriseNumber = ".$$frame{"$base\.Opt_DHCPv6_VendorSpecificInfo\.EnterpriseNumber"}."<BR>";
			# $optionstr .= "data = ".$$frame{"$optbase\.Opt_DHCPv6_VendorSpecificInfo\.data"}."<BR>";
		}
		# Opt_DHCPv6_IID
		if ("Opt_DHCPv6_IID" eq $option_defs{$_}) {
			$optionstr .= "Identifier = ".$$frame{"$optbase\.Identifier"}."<BR>";
		}
		# Opt_DHCPv6_ReconfigureMessage
		if ("Opt_DHCPv6_ReconfigureMessage" eq $option_defs{$_}) {
			$optionstr .= "Type = ".$$frame{"$optbase\.Type"}."<BR>";
		}
		# Opt_DHCPv6_ReconfigureAccept
		if ("Opt_DHCPv6_ReconfigureAccept" eq $option_defs{$_}) {
			$optionstr .= "<BR>";
		}
		# Opt_DHCPv6_DNS_Servers
		if ("Opt_DHCPv6_DNS_Servers" eq $option_defs{$_}) {
			$optionstr = "DNS = ".$$frame{"$optbase\.Address"}."<BR>";
		}
		# Opt_DHCPv6_DNS_SearchList
		if ("Opt_DHCPv6_DNS_SearchList" eq $option_defs{$_}) {
			$optionstr = "SearchList = ".$$frame{"$optbase\.SearchString"}."<BR>";
		}
		# Opt_DHCPv6_ANY
		if ("Opt_DHCPv6_ANY" eq $option_defs{$_}) {
			$optionstr .= "Code = ".$$frame{"$optbase\.Code"};
		}
		# Transaction Identifier
		if ("Identifier" eq $option_defs{$_}) {
			$optionstr .= "Identifier = ".$$frame{"$base".".Identifier"};
		}
		vLogHTML("<tr><td><B>$option_defs{$_}</B></td><td>$optionstr</td></tr>");
	}
	vLogHTML("</table>");
}

#--------------------------------------------------------------#
#  get_field_value($ref_frame,$fieldname)                      #
#                                                              #
#  Notes:                                                      #
#	get value of specified field name                      #
#                                                              #
#  Input:                                                      #
#       $ref_frame: reference of packet frame                  #
#       $filedname: filed name                                 #
#                                                              #
#  return:                                                     #
#       value: pass                                            #
#       undef: fail                                            #
#  eg                                                          #
#  get_field_value(\%frame,"Opt_DHCPv6_StatusCode.StatusCode");#
#--------------------------------------------------------------#
sub get_field_value($$){
	my($ref_frame,$fieldname) = @_;
	my ($ret, $msgindex) = getMsgTypeLocStr($ref_frame);
	if($ret){
		vLogHTML("Invalid DHCP message type!");
		return undef;
	}
	$msgindex .= ".$fieldname";
#	vLogHTML("index is $msgindex<BR>");
	my $val_field = $$ref_frame{$msgindex};
	if(!defined($val_field)){
		vLogHTML("Can't found specified field.<BR>");
		return undef;
	}
	return $val_field; 
}

##--------------------------------------------------------------#
## getElapsedtime($)                                            #
##                                                              #
## Notes:                                                       #
##	get the Elsapse time from message                       #
## Input:                                                       #
##       $frame                                                 #
## return:                                                      #
## eg.  getElapsedtime(\%frame)                                 #
##--------------------------------------------------------------#
#sub getElapsedtime($){
#
#	my ($frame) = @_;
#	my $pktcount = 0;
#	my $time = 0;
#	
##	$pktcount = $$frame{"recvCount"};
##	print"\npkt count is  $pktcount\n" if($pktcount ne 1);
##	$time = $$frame{"recvTime$pktcount"};
#
##	return $time;
#	my %content = get_field_value($frame,"Opt_DHCPv6_ElapsedTime.Time");
#	my $time = $content{"Time"};
##	$time = (($time>>8)&0x00ff)+(($time<<8)&0xff00);
#	$time = $time/100;	
#	return $time;	
#}

#--------------------------------------------------------------#
# readElapsedtime($)                                           #
#                                                              #
# Notes:                                                       #
#	read the Elsapse time field of message                 #
# Input:                                                       #
#       $frame                                                 #
# return:                                                      #
#       value: pass                                            #
#       undef: fail                                            #
# eg.  readElapsedtime(\%frame)                                #
#--------------------------------------------------------------#
sub readElapsedtime($){

	my ($frame) = @_;
	my $pktcount = 0;
	my $time = 0;

	my $value = get_field_value($frame,"Opt_DHCPv6_ElapsedTime.Time");
	if(defined($value)){
		my $time = $value;
		$time = $time/100;
		return $time;
	}
	else{
		return undef;
	}
}

#--------------------------------------------------------------#
# getReceivedtime($)                                           #
#                                                              #
# Notes:                                                       #
#	get the time when expected packet received             #
# Input:                                                       #
#       $frame                                                 #
# return:                                                      #
#       value                                                  #
# eg.  getReceivedtime(\%frame)                                #
#--------------------------------------------------------------#
sub getReceivedtime($){

	my ($frame) = @_;
	my $pktcount = 0;
	my $time = 0;
	
	$pktcount = $$frame{"recvCount"};
	print"\npkt count is  $pktcount\n" if($pktcount ne 1);
	$time = $$frame{"recvTime$pktcount"};

	return $time;
}

#--------------------------------------------------------------#
# calcElapsedtime($$)                                          #
#                                                              #
# Notes:                                                       #
#	get the time when expected packet received             #
# Input:                                                       #
#       $frame                                                 #
#       $TimetoCompare                                         #
# return:                                                      #
#       value                                                  #
# eg.  calcElapsedtime(\%frame, $prev)                         #
#--------------------------------------------------------------#
sub calcElapsedtime($$){

	my ($frame, $prev) = @_;
	my $pktcount = 0;
	my $time = 0;
	
	$pktcount = $$frame{"recvCount"};
	print"\npkt count is  $pktcount\n" if($pktcount ne 1);
	$time = $$frame{"recvTime$pktcount"} - $prev;

	return $time;
}


#--------------------------------------------------------------#
# parse_relay_message($frame)                                  #
#                                                              #
# Notes:                                                       #
#	parse and show DHCPv6 Relay Messages                   #
#                                                              #
#--------------------------------------------------------------#
sub parse_relay_message($) {
	my $frame_ref = $_[0];
	my $strBaseRelayForwardIndex = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayForward";
	my $strBaseRelayReplyIndex = "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayReply";
	my $strBaseIndex = undef;

	#Relay-forward message
	if(defined ($$frame_ref{$strBaseRelayForwardIndex})){
		message_output($frame_ref,"Relay-forward",$strBaseRelayForwardIndex);
		$strBaseIndex .= $strBaseRelayForwardIndex.".Opt_DHCPv6_RelayMessage";
	}
	elsif(defined($$frame_ref{$strBaseRelayReplyIndex})){
		message_output($frame_ref,"Relay-reply",$strBaseRelayReplyIndex);
		$strBaseIndex = $strBaseRelayReplyIndex.".Opt_DHCPv6_RelayMessage";
	}
	else{
		return;
	}

	if(defined($$frame_ref{$strBaseIndex})){
		message_output($frame_ref,"Relay Message option",$strBaseIndex);
	}
	
}

#--------------------------------------------------------------#
#                                                              #
#                                                              #
# Notes:                                                       #
#	Exit value process sub-route                           #
#                                                              #
#--------------------------------------------------------------#
################################################################
# dhcpExitPass()
################################################################
sub dhcpExitPass() {
#======================================================================
vLogHTML("<FONT SIZE=3>*** Target test finish ***<FONT><BR>");
#======================================================================
	dhcpReset();
	vLogHTML('<B>OK</B><BR>');
	exit $V6evalTool::exitPass;
}

################################################################
# dhcpExitIgnore()
# Exit with value Ignore this test
################################################################
sub dhcpExitIgnore() {
	exit $V6evalTool::exitIgnore;
}

################################################################
# dhcpExitNS()
# Exit with value "Not support"
################################################################
sub dhcpExitNS() {
#	dhcpReset();
	vLogHTML("This test is not supported by NUT now<BR>");
	exit $V6evalTool::exitNS;
}
################################################################
# dhcpExitSkip()
# Exit with value "skip"
################################################################
sub dhcpExitSkip() {
	vLogHTML("This test is skipped<BR>");
	exit $V6evalTool::exitSkip;
}

################################################################
# dhcpExitError()
# Note:
#      Exit with error message.
################################################################
sub dhcpExitError($) {
	my ($msg) = @_;
	vLogHTML("<FONT COLOR=\"#FF0000\">NG: <B>$msg</B> </FONT><BR>");
	dhcpReset();
	exit $V6evalTool::exitFail;
}

################################################################
# dhcpExitFail(;$msg)
# Note:
#	The test is failed.
################################################################
sub dhcpExitFail(;$) {
	my ($msg) = @_;
	if(defined($msg)){
		$msg = ": " . $msg;
	}
	else{
		$msg = "";
	}
	vLogHTML("<FONT COLOR=\"#FF0000\">NG$msg</FONT><BR>");
	dhcpReset();
	exit $V6evalTool::exitFail;
}


################################################################
# dhcpReset()
# Reset the test environment to the original status
# Now it Only use for Server!!!!
# can not use it in initial test!!!
# 
################################################################
sub dhcpReset() {
	my $count = 0;
	my $IFName = undef;
	my $Base_ref = undef;
	my $ret = undef;
	#only used for server or relay agent;
	
	vRemote('reboot.rmt','');
	return;
}

#---------------------------------------------------------------#
# dhcpRelayInit(\$Relay_Config_Ref)
# Initial the DHCP server
# Note:
# 	Only use for the NUT type Relay agent!!!!
# 	now only support 1 init_opcode!!!
# ---------------Sample-----------------------------------------
#initial NUT config parameters,
#my %NUT_Relay_Config = (
#	'if_nut0'=> "$V6evalTool::NutDef{Link0_device}",
#	'if_nut1' => "$V6evalTool::NutDef{Link1_device}",
#	'if_add0' => "fe80::200:ff:fe00:a4a4",
#	'if_add1' => "fe80::200:ff:fe00:a5a5",
#	'if_length0' => "64",
#	'if_length1' => "64",
#	'if_type0'=> "unicast",
#	'if_type1'=> "unicast",
#	'init_opcode' => "vRemote(\"dhcp6s.rmt\", \"start\",\"link0=$V6evalTool::NutDef{Link0_device}\",\"startaddr=3ffe:501:ffff:100::10\",\"endaddr=3ffe:501:ffff:100::11\")"
#);
#
#---------------------------------------------------------------#
sub dhcpRelayInit($){
	$NUT_Relay_Config_ref = $_[0];

	my $cpp = undef;
	my $type=$V6evalTool::NutDef{Type};
#	if($type ne 'router') {
#		vLogHTML("NG: The test of Relay-agent only can be run on the router!<BR>");
#		vLogHTML("Please check the NUT setting file.<BR>");
#		exit $V6evalTool::exitNS;
#	}
	if($type eq 'router') {
		$cpp .= ' -D LINK1';
	}
	$cpp .= ' -D SERVERRELAY';
	vCPP($cpp);
	dhcpSvrRelayCommonInit($NUT_Relay_Config_ref);
	return;
}


#---------------------------------------------------------------#
# dhcpSvrInit(\$Server_Config_Ref)
# Initial the DHCP server
# Note:
# 	Only use for the NUT type Server!!!!
# 	now only support 1 init_opcode!!!
# ---------------Sample-----------------------------------------
#my %NUT_Server_Config = {
#	"if_nut0" => $V6evalTool::NutDef{Link0_device},
#	"if_add0" => "fe80::200:ff:fe00:a1a1",
#	"if_length0" => "64",
#	"if_type0"=> "unicast",
#	"init_opcode" => 
#};
#---------------------------------------------------------------#
sub dhcpSvrInit($){
	$NUT_Server_Config_ref = $_[0];
	if($RA_TRIGGER_DHCPv6){
		#vSend("Link0", 'ra_server2_to_all_MO_1');
		vSend("Link0", 'ra_server2_to_all_MO_0_all_addr_assign');
		vRecv("Link0", 3, 0, 0, 'dadns_nutga');
		vSleep(3);
	}
	dhcpSvrRelayCommonInit($NUT_Server_Config_ref);
	return ;
}

sub dhcpSvrInitS($){
	$NUT_Server_Config_ref = $_[0];
	if($RA_TRIGGER_DHCPv6){
		#vSend("Link0", 'ra_server2_to_all_addr_assign');
		vSend("Link0", 'ra_server2_to_all_MO_0_all_addr_assign');
		vRecv("Link0", 3, 0, 0, 'dadns_nutga');
		vSleep(3);
	}
	dhcpSvrRelayCommonInit($NUT_Server_Config_ref);
	return ;
}

#---------------------------------------------------------------#
# dhcpDelegatingInit(\$Delegating_Config_Ref)
# Initial the DHCP server
# Note:
#       Only use for the NUT type Delegating Router!!!!
#       now only support 1 init_opcode!!!
# ---------------Sample-----------------------------------------
#initial NUT config parameters,
#my %NUT_Delegating_Config = (
#       'if_nut0'=> "$V6evalTool::NutDef{Link0_device}",
#       'if_nut1' => "$V6evalTool::NutDef{Link1_device}",
#       'if_add0' => "fe80::200:ff:fe00:a4a4",
#       'if_add1' => "fe80::200:ff:fe00:a5a5",
#       'if_length0' => "64",
#       'if_length1' => "64",
#       'if_type0'=> "unicast",
#       'if_type1'=> "unicast",
#       'init_opcode' => "vRemote(\"dhcp6s.rmt\", \"start\",\"link0=$V6evalTool::NutDef{Link0_device}\",\"startaddr=3ffe:501:ffff:100::10\",\"endaddr=3ffe:501:ffff:100::11\")"
#);
#
#---------------------------------------------------------------#
sub dhcpDelegatingInit($){
        $NUT_Delegating_Config_ref = $_[0];

        my $cpp = undef;
        my $type=$V6evalTool::NutDef{Type};
#       if($type ne 'router') {
#               vLogHTML("NG: The test of Delegating Router(Server) only can be run on the router!<BR>"); 
#               vLogHTML("Please check the NUT setting file.<BR>");
#               exit $V6evalTool::exitNS;
#       }
       if($type eq 'router') {
               $cpp .= ' -D LINK1';
       }
        $cpp .= ' -D SERVERRELAY';
        vCPP($cpp);
        dhcpSvrRelayCommonInit($NUT_Delegating_Config_ref);
        return;
}


#---------------------------------------------------------------#
# dhcpSvrRelayCommonInit($Config_Ref)
# Initial the DHCP NUT
# Note:
#---------------------------------------------------------------#
sub dhcpSvrRelayCommonInit($){
	my $Base_ref = $_[0];

	my $count = 0;
	my ($if,$add,$length,$type,$opcode) =(undef,undef,undef,undef);

	while($MAXIFCOUNT >= $count){
		($if,$add,$length,$type) = ($$Base_ref{"if_nut".$count},
					$$Base_ref{"if_add".$count},
					$$Base_ref{"if_length".$count},
					$$Base_ref{"if_type".$count});
		if ((defined $if)&& (defined $add) && (defined $length)&& (defined $type) ){
			# set the address of DHCPv6 Server
			SetNUTAddr($if,$add,$length,$type);
		}
		$count++;
	}

# start NUT
	$opcode = $$Base_ref{"init_opcode"};
	my $ret = undef;
	if(defined($opcode)){
		vLogHTML($opcode);
		#$ret = eval($opcode);
		$opcode =~ s/\"//g;
		if ($opcode =~ /vRemote\((.*)\)/){
		        my $strOption = $1;
			vLogHTML($strOption);
			my @cmdOp = split(/,/,$strOption);
			my $Filename = shift @cmdOp;
			my $opts = shift @cmdOp;
			$ret = vRemote($Filename,$opts,@cmdOp);
			# For output debug messages;
			# print $@;
			# vSleep(1);
		}
	}

	if($ret != 0) {
	    vLogHTML('<FONT COLOR="#FF0000">Cannot Initialize NUT.</FONT><BR>');
	    dhcpExitFail();
	};	
#Begin capture;
	$count = 0;
	while($MAXIFCOUNT >= $count){
		if(defined($$Base_ref{"if_nut".$count})){
			my $tnif = "Link$count";
			vCapture($tnif);
			vClear($tnif);
		}
			$count ++;
	}

#For SolidDNS 
	my $system=$V6evalTool::NutDef{System};
	if($system eq 'soliddns') {
		if($RA_TRIGGER_DHCPv6){
			#vSend("Link0", 'ra_server2_to_all_addr_assign');
			vSend("Link0", 'ra_server2_to_all_MO_0_all_addr_assign');
			vRecv("Link0", 3, 0, 0, 'dadns_nutga');
			vSleep(3);
		}
        }
	return;
}

#--------------------------------------------------------------#
# ChkFuncSupport(\$Fuction_type)                               #
#                                                              #
# Notes:                                                       #
#	check if the function has been support                 #
#	The function code are listed in dhcpv6_conf.           #
#                                                              #
# Input:  Function type                                        #	
#--------------------------------------------------------------#
sub ChkFuncSupport($){
	my ($config_param) = @_;
	my $param = ${$DHCPv6_config::{$config_param}};
	if($param){
		return 0;
	}
	return 1;
}

#--------------------------------------------------------------#
# ChkConfig(\$Config_Param)                                    #
#                                                              #
# Notes:                                                       #
#	check if the configration parametor is defined         #
#	The function parametors are listed in dhcpv6_conf.     #
#                                                              #
# Input:  Function type                                        #	
#--------------------------------------------------------------#
sub ChkConfig($){
	my ($config_param) = @_;
	my $param = ${$DHCPv6_config::{$config_param}};
	if($param){
		return $param;
	}
	return 1;
}

#--------------------------------------------------------------#
#Ascii2Hex()                                                   #
# Notes:                                                       #
#	Exchange ascii to binary                               #
#                                                              #
# Input:  ascii                                                #	
#--------------------------------------------------------------#
sub
Ascii2Hex($)
{
	my ($ascii_hex) = @_;

	$ascii_hex =~ s/(.)/unpack("H2", $1)/ego;

#	vLogHTML("ASCII to HEX: $ascii_hex<BR>");

	return($ascii_hex);
}

#--------------------------------------------------------------#
#Ascii2Base64()                                                #
# Notes:                                                       #
#	Encode ascii to base64                                 #
#                                                              #
# Input:  ascii                                                #	
#--------------------------------------------------------------#
sub
Ascii2Base64($)
{
	my ($ascii_base) = @_;

	$ascii_base = encode_base64($ascii_base, '');

#	vLogHTML("ASCII to BASE64: $ascii_base<BR>");

	return($ascii_base);
}

#--------------------------------------------------------------#
#SharedSecretKeyCheck()                                        #
# Notes:                                                       #
#	Shared secret key check to cover dependency            #
#       of implementation                                      #
# Input:                                                       #	
#       1st: secret key type                                   #	
#       2nd: ascii shared secret key                           #	
# Return:                                                      #	
#       value: depend on implementation                        #	
#              Now support only MIME64(BASE64)                 #	
#--------------------------------------------------------------#
sub
SharedSecretKeyCheck($$){
	my ($secret_type, $secret_key) = @_;
	if ($secret_type  eq 'MIME64'){
		$secret_key = Ascii2Base64($secret_key);
	}
	return($secret_key);
}

#--------------------------------------------------------------#
#ReplayDetectCounter()                                         #
# Notes:                                                       #
#	Increment replay detection field                       #
#                                                              #
# Input:  Hex replay detection counter                         #	
#--------------------------------------------------------------#
sub
ReplayDetectCounter($)
{
	my ($hex_counter) = @_;
	my ($bitdata, $i_bitdata, $replay_counter) = undef;
	$bitdata = unpack("B64", pack("H*", $hex_counter));
	$i_bitdata = $bitdata | '0000000000000000000000000000000000000000000000000000000000000001';
	$replay_counter = unpack("H*", pack("B64", $i_bitdata));
	vLogHTML("Increment replay detection field: $replay_counter<BR>");
	return($replay_counter);
}

#--------------------------------------------------------------#
# checkDUID(\$frame,$OptionTYpe,$Type)                         #
#                                                              #
# Notes:                                                       #
#	check the format of DUID,only use for check msgs       #
#       include sid or cid                                     #
# In:                                                          #
#       \$frame: data frame                                    #
#       $OptionType:the type of ID option  $CMP_SID,$CMP_CID   #
#       $Type:DUID's type  1,LLT 2,EN 3,LL                     #
#Return:                                                       #
#       0:success                                              #
#       1:NG                                                   #
#--------------------------------------------------------------#
sub check_DUID($$$){
	my ($refFrame,$optype,$duidtype)=@_;
	my $optbase = "";

	#check whether the message has the option
	return 1 if (0 != options_exist($refFrame,$optype));

	#obtain base index
	my $temp;
	foreach(keys %dhcp6_messages) {
		$temp  = $dhcp6_messages{$_};
		if (defined($$refFrame{$temp})){
		$optbase = "$temp"."."."$option_defs{$optype}";
		last;
		}
	}

	if("" eq $optbase){
		return 1;
	}

	my $duidbase = "$optbase"."."."$duid_types{$duidtype}";
	return 1 if(!defined($$refFrame{$duidbase}));

	my $duidValIndex = undef;
	
	if (1 == $duidtype){
		$duidValIndex = "$duidbase"."."."Type";
		my $duidHardtypeIndex = "$duidbase"."."."HardwareType";
		my $timeIndex = "$duidbase"."."."Time";
		my $LLAIndex = "$duidbase"."."."LinkLayerAddress";
		
		if((1 == $$refFrame{$duidValIndex}) &&
		  (defined( $$refFrame{$duidHardtypeIndex}) )&&
		  (defined($$refFrame{$timeIndex}))&&
		  (defined($$refFrame{$LLAIndex}))){
		  vLogHTML("DUID type:<FONT COLOR='#F25B00'>$duid_types{$duidtype}</FONT><br>");
		  return 0;
		 }
	}
	elsif (2 == $duidtype) {
		$duidValIndex = "$duidbase"."."."Type";
		my $duidIDIndex = "$duidbase"."."."Identifier";
		my $duidEnIndex = "$duidbase"."."."EnterpriseNumber";
		if((2 == $$refFrame{$duidValIndex}) &&
		  (defined($$refFrame{$duidEnIndex})) &&
		  (defined($$refFrame{$duidIDIndex}))){
                  vLogHTML("DUID type:<FONT COLOR='#F25B00'>$duid_types{$duidtype}</FONT><br>");
		  return 0;
		 }
	}
	elsif (3 == $duidtype) {
		$duidValIndex = "$duidbase"."."."Type";
		my $duidHardtypeIndex = "$duidbase"."."."HardwareType";
		my $duidLLAIndex = "$duidbase"."."."LinkLayerAddress";
		if((3 == $$refFrame{$duidValIndex}) &&
		  (defined($$refFrame{$duidHardtypeIndex})) &&
		  (defined($$refFrame{$duidLLAIndex}))){
                  vLogHTML("DUID type:<FONT COLOR='#F25B00'>$duid_types{$duidtype}</FONT><br>");
		  return 0;
		 }
	}
	return 1;
}

#--------------------------------------------------------------#
# ck_IAoptions($frame1, $frame2,$count)                        #
#                                                              #
# Notes:                                                       #
#    check the IA options in 2 frames,                         #
#    if the number and ID is same,pass                         #
#    please use it after options_exit                          #
#    Only use for 1 message packet                             #
#                                                              #
#    Input:                                                    #
#         2 references for the frames need to compare          #
#         IA count number                                      #
#    EXIST: return 0                                           #
#    NOT EXIST: return 1                                       #
#--------------------------------------------------------------#
sub ck_IAoptions($$$) {
	my ($frame1,$frame2,$count) = @_;
	if(!defined($frame1) || !defined($frame2)){
		vLogHTML("NULL frame has been used!");
		return 1;
	}
	my ($ret1,$basStr1) = getMsgTypeLocStr($frame1);
	my ($ret2,$basStr2) = getMsgTypeLocStr($frame2);

	if($ret1 || $ret2){
		vLogHTML("Invalid Message!");
		return 1;
	}

# Sample: Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Solicit.Opt_DHCPv6_IA_NA.Opt_DHCPv6_IA_NA2
	
	my ($ID1,$ID2)=("","");
	# attention, replace 10 to constant varible at the following work stage.
	# Max. value of IA options
	return 0 if (1== $count);
	while($count>1 ){
		#vLogHTML("$basStr1.Opt_DHCPv6_IA_NA$count.Identifier");
		$ID1 = $$frame1{"$basStr1.Opt_DHCPv6_IA_NA$count.Identifier"};
		$ID2 = $$frame2{"$basStr2.Opt_DHCPv6_IA_NA$count.Identifier"};

		if((!defined($ID1) || !defined($ID2))){
			$ID1 = $$frame1{"$basStr1.Opt_DHCPv6_IA_TA$count.Identifier"};
			$ID2 = $$frame2{"$basStr2.Opt_DHCPv6_IA_TA$count.Identifier"};
			if((!defined($ID1) || !defined($ID2))){
				vLogHTML("<B>Can not found specific number of IA options</B><BR>");
				return 1;
			}
		}
		if($ID1 != $ID2){
			vLogHTML("<B>The value of IA option is un-expected!</B><BR>");
			return 1;
		}
		$count--;
	}
	
	return 0;	
}

#--------------------------------------------------------------#
# ck_IAPDoptions($frame1, $frame2,$count)                        #
#                                                              #
# Notes:                                                       #
#    check the IA_PD options in 2 frames,                         #
#    if the number and ID is same,pass                         #
#    please use it after options_exit                          #
#    Only use for 1 message packet                             #
#                                                              #
#    Input:                                                    #
#         2 references for the frames need to compare          #
#         IA_PD count number                                      #
#    EXIST: return 0                                           #
#    NOT EXIST: return 1                                       #
#--------------------------------------------------------------#
sub ck_IAPDoptions($$$) {
	my ($frame1,$frame2,$count) = @_;
	if(!defined($frame1) || !defined($frame2)){
		vLogHTML("NULL frame has been used!");
		return 1;
	}
	my ($ret1,$basStr1) = getMsgTypeLocStr($frame1);
	my ($ret2,$basStr2) = getMsgTypeLocStr($frame2);

	if($ret1 || $ret2){
		vLogHTML("Invalid Message!");
		return 1;
	}

# Sample: Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_Solicit.Opt_DHCPv6_IA_PD2
	
	my ($ID1,$ID2)=("","");
	# attention, replace 10 to constant varible at the following work stage.
	# Max. value of IA options
	return 0 if (1== $count);
	while($count>1 ){
		#vLogHTML("$basStr1.Opt_DHCPv6_IA_PD$count.Identifier");
		$ID1 = $$frame1{"$basStr1.Opt_DHCPv6_IA_PD$count.Identifier"};
		$ID2 = $$frame2{"$basStr2.Opt_DHCPv6_IA_PD$count.Identifier"};

		if((!defined($ID1) || !defined($ID2))){
			vLogHTML("<B>Can not found special number of IA_PD options</B><BR>");
			return 1;
		}

		if($ID1 != $ID2){
			vLogHTML("<B>The value of IA_PD option is un-expected!</B><BR>");
			return 1;
		}
		$count--;
	}
	
	return 0;	
}





#--------------------------------------------------------------#
# ck_IAPD_prefix_options($frame1, $frame2)                     #
#                                                              #
# Notes:                                                       #
#    Compare the count of prefix options in IA_PD option       #
# Input:                                                       #
#         2 references for the frames need to compare          #
#    match: return 0                                           #
#    not match: return 1                                       #
#--------------------------------------------------------------#
sub ck_IAPD_prefix_options($$) {
	my ($ref_frame1,$ref_frame2) = @_;
	my $strBase1 = getMsgTypeLocStr($ref_frame1);
	my $strBase2 = getMsgTypeLocStr($ref_frame2);

	#check the count of IA_PD prefix options
	my $strIndex = "Opt_DHCPv6_IA_PD.Opt_DHCPv6_IA_Prefix#";
	#vLogHTML("index is $strBase1.$strIndex");
	my $count1 = $$ref_frame1{"$strBase1.$strIndex"};
	my $count2 = $$ref_frame2{"$strBase2.$strIndex"};

	#vLogHTML("count1 is $count1, and count2 is $count2 <BR>");
	if((!defined($count1)) || !defined($count2)){
		return 1;
	}
	if( $count1 eq $count2){
		return 0;
	}
	return 1;
}

#--------------------------------------------------------------#
# getMsgTypeLocStr($ref_frame)                                 #
#--------------------------------------------------------------#
sub getMsgTypeLocStr($){
	my $ref_frame = $_[0];
	my $base = "";
	
	# get the base location of message type;
	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		last if (defined($$ref_frame{$base}));
		$base = "";
	}
	if ("" eq $base) {
		vLogHTML("<B>Error message type!</B><BR>");
		return 1;
	}
	else{
		return (0,$base);
	}
}


#--------------------------------------------------------------#
#  CheckTimeOfPrefixOP($refframe1,$refframe2)                  #
#  check time value in Prefix Option                           #
#                                                              #
#  IN:                                                         #
#       $frame1,$frame2: reference of packet frame             #
#  return:                                                     #
#       0: pass                                                #
#       1: fail                                                #
#--------------------------------------------------------------#
sub CheckTimeOfPrefixOP($$){
	my($ref_frame1, $ref_frame2) = @_;
#Get the begin index string for message
	my $MsgTypeFrame1 = getMsgTypeLocStr($ref_frame1);
	my $MsgTypeFrame2 = getMsgTypeLocStr($ref_frame2);
	
#Compare the value of the Identifier in IA_PD Prefix option 
	if($$ref_frame1{"$MsgTypeFrame1.Opt_DHCPv6_IA_PD.Identifier"} 
	== $$ref_frame2{"$MsgTypeFrame2.Opt_DHCPv6_IA_PD.Identifier"}){
		if(($$ref_frame1{"$MsgTypeFrame1.Opt_DHCPv6_IA_PD.Opt_DHCPv6_IA_Prefix.ValidLifetime"} 
		== $$ref_frame2{"$MsgTypeFrame2.Opt_DHCPv6_IA_PD.Opt_DHCPv6_IA_Prefix.ValidLifetime"})
		&& 
		($$ref_frame1{"$MsgTypeFrame1.Opt_DHCPv6_IA_PD.Opt_DHCPv6_IA_Prefix.PreferredLifetime"} 
		== $$ref_frame2{"$MsgTypeFrame2.Opt_DHCPv6_IA_PD.Opt_DHCPv6_IA_Prefix.PreferredLifetime"}))
		{
			vLogHTML("The Preferred lifetime & Valid lifetime is same<BR>");
			return 0;	
		}
		else{
			return 1;
		}
	}
	else{
		vLogHTML("<B>NG:Don't found IA_PD option!</B><BR>");
		return 1;
	}	
}


#--------------------------------------------------------------#
#  CheckMessageInRelayOption($frame,$msgname)                  #
#                                                              #
#  IN:                                                         #
#       $frame: reference of packet frame                      #
#  return:                                                     #
#       0: pass                                                #
#       1: fail                                                #
#--------------------------------------------------------------#

sub CheckMessageInRelayOption($$){
	my ($ref_frame,$msgname) = @_;
	my $msg_index = $dhcp6_messages_title{$msgname};
	$msg_index .= '#';
	my $title = undef;
	#vLogHTML("$msg_index<BR>");
	foreach  my $title  (keys %$ref_frame){
		#vLogHTML("$title<BR>");
		if($title =~/$msg_index/){
			return 0;
		};
	}	
	return 1;
}

#--------------------------------------------------------------#
#  check_valueinOption($frame,$opnum,$fieldname,$expVal)       #
#  check value in option                                       #
#                                                              #
#  IN:                                                         #
#       $frame: reference of packet frame                      #
#  return:                                                     #
#       0: pass                                                #
#       1: fail                                                #
#--------------------------------------------------------------#
sub check_FieldValueinOption($$$$){
	my($frame,$opnum,$fieldname,$expval) = @_;
	vLogHTML("Checking option's value...<BR>");
	my ($ret, $msgindex) = getMsgTypeLocStr($frame);

	if( 0 != $ret){
		dhcpExitFail();
	}
	my $optype = $option_defs{$opnum};
	# now, only support 1 level field following the option name
	my $Valfield = $$frame{"$msgindex.$optype.$fieldname"};
	#vLogHTML("The index of special field $fieldname is $msgindex.$optype.$fieldname!<BR>");
	#vLogHTML($Valfield);
	
	# locate the field index string automatically;
	#
	if(!defined($Valfield)){
		vLogHTML("<B>This field does not exist!</B><BR>");
	}
	return 0 if ($expval == $Valfield);
	vLogHTML("The value of specified field is $Valfield<B></B>,but expected value is  <B>$expval</B><BR>");
	return 1;
}

#------------------------------------------------------------------#
#  check_valueofAnyFieldInOption($frame,$opnum,$fieldname,$expVal) #
#  check value of any field in option                              #
#                                                                  #
#  IN:                                                             #
#       $frame: reference of packet frame                          #
#  return:                                                         #
#       0: pass                                                    #
#       1: fail                                                    #
#------------------------------------------------------------------#
sub check_valueofAnyFieldInOption($$$$){
	my($frame,$opnum,$fieldname,$expval) = @_;

	
	my $strIndex = undef;
	my $flgEqual = 0;
 	my $Valfield = undef;	#The actuall value of found field
	
	my $strCMP = $option_defs{$opnum};	#Option name;
	
	foreach my $title  (keys %$frame){
		if($title =~  /($strCMP)$/){
			#Process the first option;
			$strIndex = $title.".$fieldname";
			if(defined ($$frame{$strIndex})){
				$Valfield = $$frame{$strIndex};
				if($expval eq $Valfield){
					vLogHTML("Begin check $strIndex<BR>");
					vLogHTML("value is $Valfield<BR>");
					$flgEqual = 1;
					last;
				}
			}
		}
		#Get the count of the special options
		my $optionCount = $$frame{"$title#"};
		if($optionCount >1){
			#process the other option
			for(my $i=2;$i<= $optionCount;$i++){
					$strIndex = "$title$i".".$fieldname";
					if(defined ($$frame{$strIndex})){
						$Valfield = $$frame{$strIndex};
						if($expval eq $Valfield){
							vLogHTML("Begin check $strIndex<BR>");
							vLogHTML("value is $Valfield<BR>");
							$flgEqual = 1;
							last;
						}
					}				
			}
		}
	}
	
 	if(!defined($Valfield)){
		dhcpExitError("Can not find specified field!");
		return 1;
	}
	return 0 if (1 == $flgEqual);
	dhcpExitError("The value of specified field is $Valfield<B></B>,but expected value is  <B>$expval</B><BR>");
	return 1;

}

#-----------------------------------------------#
#  dhcpCltInit()                                #
#  Initialize dhcpv6 Client                     #      
#                                               #
#  IN:                                          #
#                                               #      
#  return:                                      #
#       0: pass                                 #
#       1: fail                                 #
#-----------------------------------------------#      
sub dhcpCltInit(){
	vLogHTML("<B>==== NUT Initialization ====</B><BR>");
	if ( 0 != vRemote('reboot.rmt','')) {
		vLogHTML('<FONT COLOR="#FF0000">Initialization Failed!</FONT>');
		return 1;
	}
	vLogHTML("<B>==== NUT Initialization OK ====</B><BR>");
	vSleep(10);
	return 0;
}

#-----------------------------------------------#
#  dhcpCltRestart()                             #
#  Restart dhcpv6 Client program                #      
#                                               #
#  IN:                                          #
#                                               #      
#  return:                                      #
#       0: pass                                 #
#       1: fail                                 #
#-----------------------------------------------#      
sub dhcpCltRestart(){
	my $ret = 1;
	my $IF0_NUT = $V6evalTool::NutDef{Link0_device};
	$ret = vRemote("dhcp6c.rmt", "restart", "link0=$IF0_NUT");
	if($ret != 0) {
		vLogHTML('<FONT COLOR="#FF0000">Cannot Restart DHCPv6 Client.</FONT><BR>');
		dhcpExitFail;
	};
}

#-----------------------------------------------#
#  dhcpCltStart()                               #
#  Start dhcpv6 Client program                  #      
#                                               #
#  IN:                                          #
#                                               #      
#  return:                                      #
#       0: pass                                 #
#       1: fail                                 #
#-----------------------------------------------#      
sub dhcpCltStart(){
	my $ret = 1;
	my $IF0_NUT = $V6evalTool::NutDef{Link0_device};
	$ret = vRemote("dhcp6c.rmt", "start", "link0=$IF0_NUT");
	if($ret != 0){
		vLogHTML('<FONT COLOR="#FF0000">Cannot Initialize DHCPv6 Client program!</FONT><BR>');
		dhcpExitFail;
	};
}

#-----------------------------------------------#
#  check_equal($$;$)                            #
#  check if the former is equalt to latter      #
#    even if there is random factor             #      
#    for IRT evaluation                         #
#                                               #
#  IN:                                          #
#       former: value to be checked             #
#       latter: rand*latter is the latter       #      
#  return:                                      #
#       0: pass                                 #
#       1: fail                                 #
#-----------------------------------------------#      
sub check_equal($$;$){
	my ($former,$latter,$RAND) = @_;
	if (defined $RAND){
		if(($former < ($latter - $latter*$RAND)) or ($former > ($latter + $latter*$RAND))){
			return 1;
		}
		else{
			return 0;
		}
	}
	else{
		if($former != $latter){
			return 1;
		}
		else{
			return 0;
		}
	}
}

#-----------------------------------------------#
#  check_equal_RT($$;$)                         #
#  check if the former is equalt to latter      #
#    even if there is random factor             #      
#    for RT evaluation                          #
#                                               #
#  IN:                                          #
#       former: value to be checked             #
#       latter: rand*latter is the latter       #      
#  return:                                      #
#       0: pass                                 #
#       1: later                                #
#      -1: faster                               #
#-----------------------------------------------#      
sub check_equal_RT($$;$){
	my ($former,$latter,$RAND) = @_;
	if (defined $RAND){
		if($former > ($latter*2 + $latter*$RAND)){
			return 1;
		}
		elsif($former < ($latter*2 - $latter*$RAND)){
			return -1;
		}
		else{
			return 0;
		}
	}
	else{
		if($former > $latter){
			return 1;
		}
		elsif($former < $latter){
			return -1;
		}
		else{
			return 0;
		}
	}
}

#-----------------------------------------------#
#  sub ckRelayForwardPeerAddress($$);
#  Check whether the peer-address is equal to the previous message's source address     #      
#  * Only can be used for the relay option in the first level of Relay-forward message                                             #
#  IN:                                          #
#       \%relayframe: reference to relay message   #
#       \%ref_sourceframe: reference to source message   #
#  return:                                      #
#       0: pass                                 #
#       1: fail                                 #
#-----------------------------------------------#      
sub ckRelayForwardPeerAddress ($$){
	my ($ref_relayframe,$ref_sourceframe) = @_;
	my ($val_peeraddress,$val_sourceaddress)= undef;
	
	$val_sourceaddress = $$ref_sourceframe{"Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress"};
	$val_peeraddress = $$ref_relayframe{"Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayForward.PeerAddr"};
	
	if($val_sourceaddress ne $val_peeraddress){
		vLogHTML("<FONT COLOR=\"#FF0000\">The peer-address ($val_peeraddress) in the Relay message is not equal to the previous message's source address ($val_sourceaddress)!</FONT><BR>");
		return 1;
	}
	vLogHTML("<B>Checking the peer-address field is passed.</B><BR>");
	return 0;
}

#-----------------------------------------------#
#  sub ckRelayForwardLinkAddress($$);
#  Check the link-address field in the Relay-forward message from other Relay agent    #      
#  Only can be used for the relay option in the first level of Relay message                                             #
#  IN:                                          #
#       \%frame1: reference to relay message   #
#       $globaladd: global address
#  return:                                      #
#       0: pass                                 #
#       1: fail                                 #
#-----------------------------------------------#      
sub ckRelayForwardLinkAddress ($$){
	my ($ref_relayframe,$globaladd) = @_;

	# check the hop-count
	my $val =$$ref_relayframe{"Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayForward.LinkAddr"};
	if(0 eq $val){
		vLogHTML("The link-address is 0<BR>");
		return 0;
	}
	elsif ($globaladd eq $val){
		vLogHTML("The link-address is global address<BR>");
		return 0;
	}
	elsif(0 == suboptions_exist($ref_relayframe,$CMP_IID)){
		vLogHTML("<B>Using Interface-ID option</B><BR>");
		return 0;
	}
	vLogHTML("<FONT COLOR=\"#FF0000\">The Link-address($val) in the Relay message is invalid!</FONT><BR>");
	return 1;
}


#-----------------------------------------------------------#
# sub ckRelayMsgHopLimit($);                                #
# Note                                                      #
#   Check the value of HopLimit field in the Relay message  #      
#   Only can be used for the relay option in the            # 
#   first level of Relay message                            #
# Input:                                                    #
#    \%relayframe: reference to relay message               #
#    $expectVal                                             #
# return:                                                   #
#    0: pass                                                #
#    1: fail                                                #
#-----------------------------------------------------------#
sub ckRelayMsgHopLimit ($$){
	my ($ref_relayframe,$expectval) = @_;
	my $val = undef;
		
	# check the HopLimit
	$val = $$ref_relayframe{"Frame_Ether.Packet_IPv6.Hdr_IPv6.HopLimit"};
	if("$expectval" ne $val){
		vLogHTML("<FONT COLOR=\"#FF0000\">The HopLimit value in the Relay message is $val, but the value expected is 32!</FONT><BR>");
		return 1;
	}
	vLogHTML("<B>Checking the HopLimit field is passed.</B><BR>");
	return 0;
}


#-----------------------------------------------------------#
# sub ckRelayForwardMsgHopCount($$);                        #
# Note                                                      #
#   Check the value of hop-count field in the Relay message #      
#   Only can be used for the relay option in the first      #
#   level of Relay message                                  #
# Input:                                                    #
#       \%frame1: reference to relay message                #
#       $expectVal                                          #
# return:                                                   #
#       0: pass                                             #
#       1: fail                                             #
#-----------------------------------------------------------#
sub ckRelayForwardMsgHopCount ($$){
	my ($ref_relayframe ,$expectval) = @_;
	my $val = undef;
	
	# check the hop-count
	$val = $$ref_relayframe{"Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayForward.HopCount"};
	if("$expectval" ne $val){
		vLogHTML("The hop-count value in the Relay message is $val, but the value expected is 0!<BR>");
		return 1;
	}
	vLogHTML("<B>Checking the hop-count field is passed.</B><BR>");
	return 0;
}

#-----------------------------------------------------------#
# sub ckRelayReplyMsgHopCount($$);                          #
# Note                                                      #
#   Check the value of hop-count field in the Relay message #      
#   Only can be used for the relay option in the first      #
#   level of Relay message                                  #
# Input:                                                    #
#       \%frame1: reference to relay message                #
#       $expectVal                                          #
# return:                                                   #
#       0: pass                                             #
#       1: fail                                             #
#-----------------------------------------------------------#
sub ckRelayReplyMsgHopCount ($$){
        my ($ref_relayframe ,$expectval) = @_;
        my ($val1, $val2) = (undef, undef);
        
        # check the hop-count
        $val1 = $$ref_relayframe{"Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayReply.HopCount"};
        $val2 = $$ref_relayframe{"Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DHCPv6_RelayReply.Opt_DHCPv6_RelayMessage.Udp_DHCPv6_RelayReply.HopCount"};
        if("$expectval" ne $val1){
                vLogHTML("The hop-count value in the Relay message is $val1, but the value expected is 0!<BR>");
                return 1;
        }
        vLogHTML("<B>Checking the hop-count field is passed.</B><BR>");
        return 0;

        if("$expectval" ne $val2){
                vLogHTML("The hop-count value in the Relay message is $val2, but the value expected is 0!<BR>");
                return 1;
        }
        vLogHTML("<B>Checking the hop-count field is passed.</B><BR>");
        return 0;
}

#-----------------------------------------------------------#
# sub ckRelayReplyMsgHopCount2($$);                         #
# Note                                                      #
#   Check the value of hop-count field in the Relay message #
#   Only can be used for the relay option in the first      #
#   level of Relay message                                  #
# Input:                                                    #
#       \%frame1: reference to relay message                #
#       $expectVal                                          #
# return:                                                   #
#       0: pass                                             #
#       1: fail                                             #
#-----------------------------------------------------------#
sub ckRelayReplyMsgHopCount2 ($$$){
        my ($ref_relayframe ,$baseopt, $expectval) = @_;
        my $val = undef;

        # check the hop-count
        $val = $$ref_relayframe{"$baseopt"};
        if("$expectval" ne $val){
                vLogHTML("The hop-count value in the Relay message is $val, but the value expected is 0!<BR>");
                return 1;
        }
        vLogHTML("<B>Checking the hop-count field is passed.</B><BR>");
        return 0;
}

#-----------------------------------------------#
#  comapre_message($$)                          #
#  Compare two frame                            #      
#                                               #
#  IN:                                          #
#       \%frame1: reference to frame 1          #
#       \%frame2: reference to frame 2          #      
#  return:                                      #
#       0: pass                                 #
#       1: fail                                 #
#-----------------------------------------------#      
sub compare_message($$){
	my ($frame1,$frame2) = @_;
	my ($base1,$base2) = (undef,undef);
	my ($transid1,$transid2) = (undef,undef);
	my ($baseopts1,$baseopts2) = (undef,undef);
	
	foreach(keys %dhcp6_messages){
		$base1 = $dhcp6_messages{$_};
		last if (defined($$frame1{$base1}));
		$base1 = "";
	}
	foreach(keys %dhcp6_messages){
		$base2 = $dhcp6_messages{$_};
		last if (defined($$frame2{$base2}));
		$base2 = "";
	}
	
	#compare the msg-type
	if($base1 ne $base2){
		vLogHTML("<FONT COLOR=\"#FF0000\">first message:  $base1 </FONT><BR>");
		vLogHTML("<FONT COLOR=\"#FF0000\">second message: $base2 </FONT><BR>");
		vLogHTML('<FONT COLOR="#FF0000"> message type is not same </FONT><BR>');
		return 1;
	}
	#compare the identifier
	$transid1 = "$base1"."."."Identifier";
	$transid2 = "$base2"."."."Identifier";
	if($$frame1{$transid1} ne $$frame2{$transid2}){
		vLogHTML('<FONT COLOR="#FF0000"> message identifier is not same </FONT><BR>');
		return 1;
	}
	#compare the options
	foreach(keys %option_defs) {
		$baseopts1 = "$base1"."."."$option_defs{$_}";
		$baseopts2 = "$base2"."."."$option_defs{$_}";
		
		if($$frame1{$baseopts1} ne $$frame2{$baseopts2}){
			print "\n $$frame1{$baseopts1}";
			print "\n $$frame2{$baseopts2}";
			vLogHTML('<FONT COLOR="#FF0000"> message option is not same </FONT><BR>');
			return 1;
		}
	}
	return 0;
}

sub DebugStrOut($){
	#my $str = $_[0];
	my ($str) = @_;
	if($DHCP_CHECK_DEBUG){
		vLogHTML("$str <BR>");
	}
}

sub compare_transactionID($$){
        my ($frame1,$frame2) = @_;
        my ($base1,$base2) = (undef,undef);
        my ($transid1,$transid2) = (undef,undef);
        
        foreach(keys %dhcp6_messages){
                $base1 = $dhcp6_messages{$_};
                last if (defined($$frame1{$base1}));
                $base1 = "";
        }
        foreach(keys %dhcp6_messages){
                $base2 = $dhcp6_messages{$_};
                last if (defined($$frame2{$base2}));
                $base2 = "";
        }
        
        #compare the identifier
        $transid1 = $$frame1{"$base1"."."."Identifier"};
        $transid2 = $$frame2{"$base2"."."."Identifier"};
	#print "Transaction-ID1:$transid1\n";
	#print "Transaction-ID2:$transid2\n";
        if($transid1 eq $transid2){
		return 0;
	}
	eles{
                vLogHTML('<FONT COLOR="#FF0000">Transaction-ID is the different value. </FONT><BR>');
                return 1;
        }
}

sub compare_hopcount($$){
        my ($frame1,$frame2) = @_;
        my ($base1,$base2) = (undef,undef);
        my ($hopcount1,$hopcount2) = (undef,undef);
        
        foreach(keys %dhcp6_messages){
                $base1 = $dhcp6_messages{$_};
                last if (defined($$frame1{$base1}));
                $base1 = "";
        }
        foreach(keys %dhcp6_messages){
                $base2 = $dhcp6_messages{$_};
                last if (defined($$frame2{$base2}));
                $base2 = "";
        }
        
        #compare the hop-count
        $hopcount1 = $$frame1{"$base1"."."."HopCount"};
        $hopcount2 = $$frame2{"$base2"."."."HopCount"};
        print "hopcount1:$hopcount1\n";
        print "hopcount2:$hopcount2\n";
        if($$frame1{$hopcount1} ne $$frame2{$hopcount2}){
                vLogHTML('<FONT COLOR="#FF0000"> Hop-count is not same </FONT><BR>');
                return 1;
        }
}


sub compare_iaid($$$){
	my ($frame1, $frame2, $optype)= @_;
	my ($iaid1, $iaid2) = (0, 0);
	my ($base1, $base2) = (undef, undef);
	my ($optbase1, $optbase2) = (undef, undef);
	foreach(keys %dhcp6_messages){
		$base1 = $dhcp6_messages{$_};
		last if (defined($$frame1{$base1}));
		$base1 = "";
	}
	foreach(keys %dhcp6_messages){
		$base2 = $dhcp6_messages{$_};
		last if (defined($$frame2{$base2}));
		$base2 = "";
	}
	$optbase1 = $base1.".".$option_defs{"$optype"};
	$optbase2 = $base2.".".$option_defs{"$optype"};
	
	$iaid1 = $$frame1{$optbase1."."."Identifier"};
	$iaid2 = $$frame2{$optbase2."."."Identifier"};
	
	print "iaid1 = $iaid1 \n";
	print "iaid2 = $iaid2 \n";
	if($iaid1 eq $iaid2){
		vLogHTML("<FONT COLOR=\"#FF0000\">IAID is the same value. <FONT><BR>");
		return 0;
	}
	else{
		vLogHTML("<FONT COLOR=\"#FF0000\">First message IAID is $iaid1 <FONT><BR>");
		vLogHTML("<FONT COLOR=\"#FF0000\">Second message IAID is $iaid2 <FONT><BR>");
		return 1;
	}
}

sub compare_prefix($$$){
        my ($frame1, $frame2, $optype)= @_;
        my ($prefix1, $prefix2) = (0, 0);
        my ($base1, $base2) = (undef, undef);
        my ($optbase1, $optbase2) = (undef, undef);
        foreach(keys %dhcp6_messages){
                $base1 = $dhcp6_messages{$_};
                last if (defined($$frame1{$base1}));
                $base1 = "";
        }
        foreach(keys %dhcp6_messages){
                $base2 = $dhcp6_messages{$_};
                last if (defined($$frame2{$base2}));
                $base2 = "";
        }
        $optbase1 = $base1.".".$option_defs{"$CMP_IA_PD"}.".".$option_defs{"$optype"};
        $optbase2 = $base2.".".$option_defs{"$CMP_IA_PD"}.".".$option_defs{"$optype"};
        
        $prefix1 = $$frame1{$optbase1."."."Prefix"};
        $prefix2 = $$frame2{$optbase2."."."Prefix"};
        
        print "prefix1 = $prefix1 \n";
        print "prefix2 = $prefix2 \n";
        if($prefix1 eq $prefix2){
                return 0;
        }
        else{
                vLogHTML("<FONT COLOR=\"#FF0000\">First message PREFIX is $prefix1 <FONT><BR>");
                vLogHTML("<FONT COLOR=\"#FF0000\">Second message PREFIX is $prefix2 <FONT><BR>");
                return 1;
        }
}

sub compare_time($$$){
        my ($frame1, $frame2, $optype)= @_;
        my ($time1, $time2) = (0, 0);
	my ($time3, $time4) = (0, 0);
        my ($base1, $base2) = (undef, undef);
        my ($optbase1, $optbase2) = (undef, undef);
        foreach(keys %dhcp6_messages){
                $base1 = $dhcp6_messages{$_};
                last if (defined($$frame1{$base1}));
                $base1 = "";
        }
        foreach(keys %dhcp6_messages){
                $base2 = $dhcp6_messages{$_};
                last if (defined($$frame2{$base2}));
                $base2 = "";
        }
        $optbase1 = $base1.".".$option_defs{"$optype"};
        $optbase2 = $base2.".".$option_defs{"$optype"};
        
        $time1 = $$frame1{$optbase1."."."Time1"};
        $time2 = $$frame2{$optbase2."."."Time1"};
        
        $time3 = $$frame1{$optbase1."."."Time2"};
        $time4 = $$frame2{$optbase2."."."Time2"};

        print "Time1 = $time1 \n";
        print "Time1 = $time2 \n";
        print "Time2 = $time3 \n";
        print "Time2 = $time4 \n";

        if(($time1 eq $time2) && ($time3 eq $time4)){
                vLogHTML("<FONT COLOR=\"#FF0000\">First message TIME1 is $time1 <FONT><BR>");
                vLogHTML("<FONT COLOR=\"#FF0000\">Second message TIME1 is $time2 <FONT><BR>");
                vLogHTML("<FONT COLOR=\"#FF0000\">First message TIME2 is $time3 <FONT><BR>");
                vLogHTML("<FONT COLOR=\"#FF0000\">Second message TIME2 is $time4 <FONT><BR>");
                return 0;
        }
        else{
                return 1;
        }
}
sub check_RecvTime($$$){
        my ($frame1, $frame2, $time)= @_;
        my ($time1, $time2) = (0, 0);
	my $count = 0;
        my $recvtime = 0;
	my $recvtimeCnt = 0;

	$time1 = $time * 0.95;
	$time2 = $time * 1.05;
		print "time1:$time1\n";
		print "time2:$time2\n";

        $count = $$frame2{recvCount};
        	print "frame:$$frame2{recvFrame}\n";
        	print "Count:$$frame2{recvCount}\n";

        if ($count == 1){
                $recvtime = $$frame2{recvTime1} - $$frame1{sentTime1};

                print"recvtime1:$$frame2{recvTime1}\n";
                print"senttime1:$$frame1{sentTime1}\n";

                        if(($time1 < $recvtime) && ($recvtime < $time2)){
                                vLogHTML("<FONT COLOR=\"#FF0000\">Received Time is $recvtime<FONT><BR>");
                                return 0;
                        }
                        else{
                                return 1;
                        }

        }
        elsif ($count >= 1){
                $recvtimeCnt = $$frame2{"recvTime$count"};
                print "recvTimeCnt:$recvtimeCnt\n";
                print "senttime1:$$frame1{sentTime1}\n";

                $recvtime = $recvtimeCnt - $$frame1{sentTime1};
                        if(($time1 < $recvtime) && ($recvtime < $time2)){
                                vLogHTML("<FONT COLOR=\"#FF0000\">Received Time is $recvtime<FONT><BR>");
                                return 0;
                        }
                        else{
                                return 1;
                        }
        }
        else{
                vLogHTML('<B>Could not get expected Message</B><BR>');
                return 1;
        }
}

sub compare_lifetimes($$$){
        my ($frame1, $frame2, $optype)= @_;
        my ($pltime1, $pltime2) = (0, 0);
        my ($vltime1, $vltime2) = (0, 0);
        my ($base1, $base2) = (undef, undef);
        my ($optbase1, $optbase2) = (undef, undef);
        foreach(keys %dhcp6_messages){
                $base1 = $dhcp6_messages{$_};
                last if (defined($$frame1{$base1}));
                $base1 = "";
        }
        foreach(keys %dhcp6_messages){
                $base2 = $dhcp6_messages{$_};
                last if (defined($$frame2{$base2}));
                $base2 = "";
        }
        $optbase1 = $base1.".".$option_defs{"$optype"};
        $optbase2 = $base2.".".$option_defs{"$optype"};

        $pltime1 = $$frame1{"$optbase1.Opt_DHCPv6_IA_Prefix.PreferredLifetime"};
        $pltime2 = $$frame2{"$optbase2.Opt_DHCPv6_IA_Prefix.PreferredLifetime"};

        $vltime1 = $$frame1{"$optbase1.Opt_DHCPv6_IA_Prefix.ValidLifetime"};
        $vltime2 = $$frame2{"$optbase2.Opt_DHCPv6_IA_Prefix.ValidLifetime"};

        print "PreferredLifeTime1 = $pltime1 \n";
        print "PreferredLifeTime2 = $pltime2 \n";
        print "ValidLifeTime1 = $vltime1 \n";
        print "ValidLifeTime2 = $vltime2 \n";

        if(($pltime1 eq $pltime2) && ($vltime1 eq $vltime2)){
                return 0;
        }
        else{
                vLogHTML("<FONT COLOR=\"#FF0000\">First message PreferredLifeTime1 is $pltime1 <FONT><BR>");
                vLogHTML("<FONT COLOR=\"#FF0000\">Second message PreferredLifeTime2 is $pltime2 <FONT><BR>");
                vLogHTML("<FONT COLOR=\"#FF0000\">First message ValidLifeTime1 is $vltime1 <FONT><BR>");
                vLogHTML("<FONT COLOR=\"#FF0000\">Second message ValidLifeTime2 is $vltime2 <FONT><BR>");
                return 1;
        }
}


sub check_time($$){
        my ($frame,$val) = @_;
        my ($base1,$base2) = (undef,undef);
        my ($time1,$time2) = (undef,undef);

        foreach(keys %dhcp6_messages){
                $base1 = $dhcp6_messages{$_};
                last if (defined($$frame{$base1}));
                $base1 = "";
        }
        foreach(keys %dhcp6_messages){
                $base2 = $dhcp6_messages{$_};
                last if (defined($$frame{$base2}));
                $base2 = "";
        }

	my $optbase1 = $base1.".".$option_defs{"$CMP_IA_PD"}."."."Time1";
	my $optbase2 = $base2.".".$option_defs{"$CMP_IA_PD"}."."."Time2";

        #check T1 and T2 
        $time1 = $$frame{"$optbase1"};
        $time2 = $$frame{"$optbase2"};
        print "T1:$time1\n";
        print "T2:$time2\n";

        if(($$frame{$time1} eq $val) && ($$frame{$time2} eq $val)){
                vLogHTML('<FONT COLOR="#FF0000"> T1 and T2 is non-zero values </FONT><BR>');
                return 1;
        }
	elsif(($$frame{$time1}) > ($$frame{$time2})){
                vLogHTML('<FONT COLOR="#FF0000"> T2 is grater value than T1 </FONT><BR>');
                return 2;
	}
	else{
                vLogHTML('<FONT COLOR="#FF0000"> T1 and T2 are the correct values </FONT><BR>');
		return 0;
	}
}

sub check_lifetime($$){
        my ($frame,$val) = @_;
        my ($base1,$base2) = (undef,undef);
        my ($time1,$time2) = (undef,undef);

        foreach(keys %dhcp6_messages){
                $base1 = $dhcp6_messages{$_};
                last if (defined($$frame{$base1}));
                $base1 = "";
        }
        foreach(keys %dhcp6_messages){
                $base2 = $dhcp6_messages{$_};
                last if (defined($$frame{$base2}));
                $base2 = "";
        }

	my $baseiapd1 = $base1.".".'Opt_DHCPv6_IA_PD';
	my $baseiapd2 = $base2.".".'Opt_DHCPv6_IA_PD';
        my $optbase1 = $baseiapd1.".".$option_defs{"$CMP_IA_PREFIX"}."."."PreferredLifetime";
        my $optbase2 = $baseiapd2.".".$option_defs{"$CMP_IA_PREFIX"}."."."ValidLifetime";

        #check PreferredLifetime and ValidLifetime 
        my $pltime = $$frame{"$optbase1"};
        my $vltime = $$frame{"$optbase2"};
        print "PreferredLifetime:$pltime\n";
        print "ValidLifetime:$vltime\n";

        if(($$frame{$pltime} != $val) && ($$frame{$vltime} != $val)){
                vLogHTML('<FONT COLOR="#FF0000"> PreferredLifetime and ValidLifetime is non-zero values </FONT><BR>');
                return 1;
        }
        else{
                vLogHTML('<FONT COLOR="#FF0000"> PreferredLifetime and ValidLifetime are the correct values </FONT><BR>');
                return 0;
        }
}

#-----------------------------------------------#
#  compare_id($$$)                              #
#  compare the SID or CID                       #      
#                                               #
#  IN:                                          #
#      $frame1					#
#      $frame2					#	
#      $optype                                  #      
#  return:                                      #
#       0: pass                                 #
#       1: fail                                 #
#-----------------------------------------------#      
sub compare_id($$$){
	my ($frame1, $frame2, $optype)= @_;
	my ($base1, $base2) = (undef, undef);
	my ($optbase1, $optbase2) = (undef, undef);
	my ($duid1, $duid2) = (undef, undef);
	my $retval = 1;

	
	foreach(keys %dhcp6_messages){
		$base1 = $dhcp6_messages{$_};
		last if (defined($$frame1{$base1}));
		$base1 = "";
	}
	foreach(keys %dhcp6_messages){
		$base2 = $dhcp6_messages{$_};
		last if (defined($$frame2{$base2}));
		$base2 = "";
	}
	$optbase1 = $base1.".".$option_defs{"$optype"};
	$optbase2 = $base2.".".$option_defs{"$optype"};
	foreach(keys %duid_types){
		my $duidbase1 = $optbase1.".".$duid_types{$_};
		my $duidbase2 = $optbase2.".".$duid_types{$_};
		my $duidtype1 = $$frame1{$duidbase1."."."Type"};
		my $duidtype2 = $$frame2{$duidbase2."."."Type"};
		
		if(defined($duidtype1) and defined($duidtype2)){
			#vLogHTML("optbase1 : $optbase1 <BR>");
			#vLogHTML("optbase2 : $optbase2 <BR>");
			#vLogHTML("duidbase1 : $duidbase1 <BR>");
			#vLogHTML("duidbase2 : $duidbase2 <BR>");
			#vLogHTML("duidtype1 : $duidtype1 <Br>");
			#vLogHTML("duidtype2 : $duidtype2 <BR>");
			if($duid_types{$_} eq "DHCPv6_DUID_LLT_Ether"){
				$retval = check_duid_para($frame1,$frame2,$duidbase1,$duidbase2,"LinkLayerAddress");
				$retval |= check_duid_para($frame1,$frame2,$duidbase1,$duidbase2,"Time");
				if($retval !=0){
					vLogHTML("<FONT COLOR=\"#FF0000\">Not Match! <FONT><BR>");
					return 1;
				}
				last;
			}
			elsif($duid_types{$_} eq "DHCPv6_DUID_EN"){
				$retval = check_duid_para($frame1,$frame2,$duidbase1,$duidbase2,"EnterpriseNumber");
				$retval |= check_duid_para($frame1,$frame2,$duidbase1,$duidbase2,"Identifier");
				if($retval !=0){
					 vLogHTML("<FONT COLOR=\"#FF0000\">Not Match! <FONT><BR>");
					 return 1;
				 }
				last;
			}
			elsif($duid_types{$_} eq "DHCPv6_DUID_LL_Ether"){
				$retval = check_duid_para($frame1,$frame2,$duidbase1,$duidbase2,"LinkLayerAddress");
				if($retval !=0){
					vLogHTML("<FONT COLOR=\"#FF0000\">Not Match! <FONT><BR>");
					return 1;
				}
				last;
			}
			elsif($duid_types{$_} eq "DHCPv6_DUID_LLT_ANY"){
				$retval = check_duid_para($frame1,$frame2,$duidbase1,$duidbase2,"LinkLayerAddress");
				$retval |= check_duid_para($frame1,$frame2,$duidbase1,$duidbase2,"Time");
				$retval |= check_duid_para($frame1,$frame2,$duidbase1,$duidbase2,"HardwareType");
				if($retval !=0){
					 vLogHTML("<FONT COLOR=\"#FF0000\">Not Match! <FONT><BR>");
					 return 1;
				 }
				 last;
			}
		}
	}
	return 0;
}
sub check_duid_para($$$$$){
	my ($frame1, $frame2, $duidbase1, $duidbase2, $parameter) = @_;
	my ($value1, $value2) = (undef, undef);
	
	$value1 = $$frame1{$duidbase1.".".$parameter};
	$value2 = $$frame2{$duidbase2.".".$parameter};
	#vLogHTML("value1 = $value1 <BR> ");
	#vLogHTML("value2 = $value2 <BR> ");
	if(!defined($value1)){
		vLogHTML("<FONT COLOR=\"#FF0000\">invalid parameter ! <FONT><BR>");
		return 1;
	}
	if(!defined($value2)){
		vLogHTML("<FONT COLOR=\"#FF0000\">invalid parameter ! <FONT><BR>");
		return 1;
	}
	if($value1 eq $value2){
		#vLogHTML("same content <BR>");
		return 0;
	}
	return 1;
}

#-----------------------------------------------#
#  check_dest_ipaddress($)                      #
#   check whether dest IP address is  unicast   #
#      IP address                               #
#                                               #
#  IN:                                          #
#      $frame					#
#                                               #
#  return:                                      #
#       0: Multicast                            #
#       1: Unicast                              #
#-----------------------------------------------#      
sub check_dest_ipaddress($){
	my ($frame) = @_;
	my $destIPaddr = $$frame{"Frame_Ether\.Packet_IPv6\.Hdr_IPv6\.DestinationAddress"};
	print "\n dest IP Address is $destIPaddr \n";
	if($destIPaddr =~ /ff02::1:2/){
		vLogHTML('<FONT COLOR="#FF0000"> Destination IP address is Multicast Address(ff02::1:2).</FONT><BR>');
		return 0;
	}

	return 1;
}

#-----------------------------------------------#
#  check_ipaddr_local($$)                       #
#   check whether dest IP address is link-local #
#      IP address                               # 
#                                               #
#  IN:                                          #
#      $frame					#
#      $type                                    #
#  return:                                      #
#       0: non-link-local IP Address            #
#       1: Fail or link-local IP Address        #
#-----------------------------------------------#
sub check_ipaddr_local($$){
	my ($frame,$type) = @_;
	my $ipaddress = undef;
	
#	vLogHTML("<FONT COLOR=\"#FF0000\"><B> Type is $type </B></FONT><BR>");
	
	
	if($type eq "SourceAddress"){
		$ipaddress = $$frame{"Frame_Ether\.Packet_IPv6\.Hdr_IPv6\.SourceAddress"};
	}
	elsif($type eq "DestinationAddress"){
		$ipaddress = $$frame{"Frame_Ether\.Packet_IPv6\.Hdr_IPv6\.DestinationAddress"};
	}
	else{
		vLogHTML("<FONT COLOR=\"#FF0000\"><B> Address Type is error!</B></FONT><BR>");
		return 1;
	}
	
	vLogHTML("<FONT><B> Address is $ipaddress </B></FONT><BR>");
	
	if ($ipaddress !~ /fe80::/){
		vLogHTML("<FONT COLOR=\"#FF0000\"><B>$type is not Link-local Address! </B></FONT><BR>");
		return 1;
	}
	return 0;
}

#-----------------------------------------------#
#  get_nut_link_number($)                       #
#   According to Source MAC Address, get Link   #
#      number of NUT                            # 
#                                               #
#  IN:                                          #
#      $frame					#
#                                               #
#  return:                                      #
#       0~4: Normally return value              #
#       5: Abnormally return value              #
#-----------------------------------------------#
sub get_nut_link_number($){
	my ($frame) = @_;
	my $macaddress = undef;
	
	$macaddress = $$frame{"Frame_Ether.Hdr_Ether.SourceAddress"};
	vLogHTML("<FONT COLOR=\"#FF0000\"><B>NUT Link MAC Address is $macaddress </B></FONT><BR>");
	
	for(my $n=0; $n<=4; $n++){
		if(defined($V6evalTool::NutDef{"Link".$n."_addr"})){
			if ($V6evalTool::NutDef{"Link".$n."_addr"} eq $macaddress )
			{
				return $n;
			}
		}
	
	}	
	return 5;
}


#-----------------------------------------------#
#  get_udp_destport($)                          #
#    From message, get destination UDP port     #
#      number                                   # 
#                                               #
#  IN:                                          #
#      $frame					#
#                                               #
#  return:                                      #
#       0: wrong number                         #
#       others:  return port value              #
#-----------------------------------------------#
sub get_udp_destport($){
	my ($frame) = @_;
	my $port = undef;

	$port = $$frame{"Frame_Ether\.Packet_IPv6\.Upp_UDP\.Hdr_UDP\.DestinationPort"};
	return $port;
}




#-----------------------------------------------#
#  parse_IAPD_option($)                         #
#    From message, parse the content of IAPD    #
#                                               # 
#                                               #
#  IN:                                          #
#      $frame					#
#                                               #
#  return:                                      #
#                                               #
#                                               #
#-----------------------------------------------#
sub parse_IAPD_option($){
	my ($frame) = @_;
	my $base = undef;
	
	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		last if (defined($$frame{$base}));
		$base = "";
	}
	
	my $baseopt = $base."."."Opt_DHCPv6_IA_PD";
	#if(!defined($$frame{$baseopt})){
	#	vLogHTML("<FONT COLOR=\"#FF0000\">IA_PD option not found! </FONT><BR>");
	#	return 0;
	#}
	vLogHTML("<B>IA_PD option 1:</B><BR>");
	vLogHTML("<B>Identifier = $$frame{$baseopt.\".\".\"Identifier\"}</B><BR>");
	vLogHTML("<B>Time1 = $$frame{$baseopt.\".\".\"Time1\"}</B><BR>");
	vLogHTML("<B>Time2 = $$frame{$baseopt.\".\".\"Time2\"}</B><BR>");
	my $num = 2;
	while(defined($$frame{$baseopt.$num})){
		vLogHTML("<B>IA_PD option $num:</B><BR>");
		vLogHTML("<B>Identifier = $$frame{$baseopt.$num.\".\".\"Identifier\"}</B><BR>");
		vLogHTML("<B>Time1 = $$frame{$baseopt.$num.\".\".\"Time1\"}</B><BR>");
		vLogHTML("<B>Time2 = $$frame{$baseopt.$num.\".\".\"Time2\"}</B><BR>");
		$num ++; 
	}
	
}

#-----------------------------------------------#
#  parse_IAPD_option2($)                        #
#    From message, parse the content of IAPD    #
#                                               # 
#                                               #
#  IN:                                          #
#      $frame                                   #
#                                               #
#  return:                                      #
#                                               #
#                                               #
#-----------------------------------------------#
sub parse_IAPD_option2($){
        my ($frame) = @_;
        my $base = undef;
        
        foreach(keys %dhcp6_messages) {
                $base = $dhcp6_messages{$_};
                last if (defined($$frame{$base}));
                $base = "";
        }
        
        my $baseopt = $base."."."Opt_DHCPv6_IA_PD";
        #if(!defined($$frame{$baseopt})){
        #       vLogHTML("<FONT COLOR=\"#FF0000\">IA_PD option not found! </FONT><BR>");
        #       return 0;
        #}
	
        my ($frame) = @_;
        my $baseopt = $base."."."Opt_DHCPv6_IA_PD";
	if($$frame{$baseopt."."."Code"} != 25){
		dhcpExitError("<B>Option code is not correct value</B>");
	}

        vLogHTML("<B>IA_PD option 1:</B><BR>");
        vLogHTML("<B>Code = $$frame{$baseopt.\".\".\"Code\"}</B><BR>");
        vLogHTML("<B>Length = $$frame{$baseopt.\".\".\"Length\"}</B><BR>");
        vLogHTML("<B>Identifier = $$frame{$baseopt.\".\".\"Identifier\"}</B><BR>");
        vLogHTML("<B>Time1 = $$frame{$baseopt.\".\".\"Time1\"}</B><BR>");
        vLogHTML("<B>Time2 = $$frame{$baseopt.\".\".\"Time2\"}</B><BR>");
	
        my $num = 2;
        while(defined($$frame{$baseopt.$num})){
                vLogHTML("<B>IA_PD option $num:</B><BR>");
        	vLogHTML("<B>Code = $$frame{$baseopt.$num.\".\".\"Code\"}</B><BR>");
       		vLogHTML("<B>Length = $$frame{$baseopt.$num.\".\".\"Length\"}</B><BR>");
                vLogHTML("<B>Identifier = $$frame{$baseopt.$num.\".\".\"Identifier\"}</B><BR>");
                vLogHTML("<B>Time1 = $$frame{$baseopt.$num.\".\".\"Time1\"}</B><BR>");
                vLogHTML("<B>Time2 = $$frame{$baseopt.$num.\".\".\"Time2\"}</B><BR>");
                $num ++; 
        }
}



#-----------------------------------------------#
#  parse_IAPrefix_option($)                     #
#    From message, parse the content of IAPD    #
#        Prefix option                          # 
#                                               #
#  IN:                                          #
#      $frame					#
#                                               #
#  return:                                      #
#      0: PASS                                  #
#      1: FAIL                                  #
#-----------------------------------------------#
sub parse_IAPrefix_option($){
	my ($frame) = @_;
	my $base = undef;
	
	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		last if (defined($$frame{$base}));
		$base = "";
	}
	my $baseopt = $base."."."Opt_DHCPv6_IA_PD"."."."Opt_DHCPv6_IA_Prefix" ;
	if(!defined($$frame{$baseopt})){
		vLogHTML("<FONT COLOR=\"#FF0000\">IA_Prefix option not found! </FONT><BR>");
		return 1;
	}
	my $code = $$frame{$baseopt.".Code"};
	if ($code != 26) {
		vLogHTML("<FONT COLOR=\"#FF0000\">Error!Code in IA_Prefix option is not 26. </FONT><BR>");
		return 1;
	}
	vLogHTML("<B>Option-Code = $$frame{$baseopt.\".\".\"Code\"}</B><BR>");
	vLogHTML("<B>Option-length = $$frame{$baseopt.\".\".\"Length\"}</B><BR>");
	vLogHTML("<B>PrefferedLifetime = $$frame{$baseopt.\".\".\"PreferredLifetime\"}</B><BR>");
	vLogHTML("<B>ValidLifetime = $$frame{$baseopt.\".\".\"ValidLifetime\"}</B><BR>");
	vLogHTML("<B>PrefixLength = $$frame{$baseopt.\".\".\"PrefixLength\"}</B><BR>");
	vLogHTML("<B>Prefix = $$frame{$baseopt.\".\".\"Prefix\"}</B><BR>");

	return 0;
	
}

sub get_OptRequstCode($){
	my ($frame) = @_;
	my $base = undef;
	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		last if (defined($$frame{$base}));
		$base = "";
	}
	my $baseopt = $base."."."Opt_DHCPv6_OptionRequest";

	if(!defined($$frame{$baseopt})){
		vLogHTML("<FONT COLOR=\"#FF0000\">Option Request option not found! </FONT><BR>");
		
		return 1;
	}
	foreach(keys %$frame){
		print "$_ : $$frame{$_}\n";
	}
	
        my $OptionRequestCode = $$frame{$baseopt."."."OptionCode"};	
	print "\nReuested-Option-Code is $OptionRequestCode \n";
	return $OptionRequestCode;
}


sub lookup_OptRequestCode($$){
	my ($frame, $testcode) = @_;
	my $base = undef;

	foreach(keys %dhcp6_messages) {
		$base = $dhcp6_messages{$_};
		last if (defined($$frame{$base}));
		$base = "";
	}
	my $baseopt = $base."."."Opt_DHCPv6_OptionRequest";
	if(!defined($$frame{$baseopt})){
		vLogHTML("<FONT COLOR=\"#FF0000\">Option Request option not found! </FONT><BR>");
		return 1;
	}
	
	my $optlen  = $$frame{$baseopt."."."Length"};
	my $optnum  = $optlen/2;
	my $count = 0;
	my $reqoptcode = 0;
	my $found = 1;
	
	$reqoptcode = $$frame{$baseopt."."."OptionCode"};
	print "OptionRequestCode = $reqoptcode\n";
	if ($reqoptcode eq $testcode){
		$found = 0;
	}
	if($optnum eq 1){
		return $found;
	}
	else{
		for($count = 2; $count <= $optnum; $count++){
			$reqoptcode = $$frame{$baseopt."."."OptionCode"."_".$count};
			print "OptionRequestCode = $reqoptcode\n";
			if ($reqoptcode eq $testcode){
				$found  = 0;
			}		
		}
		return $found;	
	}
}

#-----------------------------------------------#
#  check_Auth_MD5($)                            #
#    From message, calculate Authenticator MD5  #
#                                               #
#  IN:                                          #
#      $frame $secret_key			#
#                                               #
#  return:                                      #
#      0: PASS                                  #
#      1: FAIL                                  #
#-----------------------------------------------#
sub check_Auth_MD5($$){

	my ($ret_ref,$secretkey) = @_;

	my $udp_path = 'Frame_Ether.Packet_IPv6.Upp_UDP';
	$ret_ref->{$udp_path} =~ /(Udp_DHCPv6_\S+)/;
	my $udp_name = $1;
	unless(defined($udp_name)){
		DebugStrOut("check_Auth_MD5:can't find DHCPv6 section\n");
		return 1;
	}
	my $dhcp_path = "$udp_path.$udp_name";
	my $type = $ret_ref->{"${dhcp_path}.Type"};
	my $indetifier = $ret_ref->{"${dhcp_path}.Identifier"};
	my $packet_string =  sprintf("%02x%06x",$type,$indetifier); 
	my $receive_md5 = '';
	my @dhcp_names = split(' ',$ret_ref->{$dhcp_path});

	foreach my $dhcp_name (@dhcp_names){
		if($dhcp_name =~ /^Opt_/){
			my $ret = get_Opt_String("$dhcp_path.$dhcp_name",
						 $ret_ref,
						 \$packet_string,
						 \$receive_md5);
			if($ret != 0){
				return(1);
			}
		}
	} 
	
	my $packet_bin = pack("H*", $packet_string);  
	my $key_bin = pack("H*", Ascii2Hex($secretkey));
	my $calc_md5=hmac_md5_hex($packet_bin, $key_bin);

	DebugStrOut("############packet##############");
	DebugStrOut("$packet_string");
	DebugStrOut("############calc_md5############");
	DebugStrOut("$calc_md5");
	DebugStrOut("############rcv_md5#############");
	DebugStrOut("$receive_md5");
	DebugStrOut("################################");

	if($calc_md5 eq $receive_md5){
		vLogHTML("Authentication HMAC HASH matched.<BR>");
	}else{
		DebugStrOut("Authentication HMAC HASH does not match!");
		return 1;
	}
	return 0;
}

sub get_Opt_String($$$$){
	my ($dhcp_path,$ret_ref,$string_ref,$md5_ref) = @_;
	my $code = $ret_ref->{"${dhcp_path}.Code"};
	my $length = $ret_ref->{"${dhcp_path}.Length"};
	$$string_ref .= sprintf("%04x%04x",$code,$length);

	if($option_codes{$code} =~ /OPTION_CLIENTID/ ||
	   $option_codes{$code} =~ /OPTION_SERVERID/
	  ){
		$ret_ref->{$dhcp_path} =~ /(DHCPv6_DUID\S+)/;
		my $duid_name = $1;
		my $duid_path = "${dhcp_path}.$duid_name";

		my $ret = get_DUID_Strig($duid_path,$ret_ref,$length,$string_ref);

		if($ret != 0){
			return(1);
		}

	}elsif($option_codes{$code} =~ /OPTION_IA_NA/ ||
	       $option_codes{$code} =~ /OPTION_IA_TA/
	      ){
		my $iaid = $ret_ref->{"${dhcp_path}.Identifier"};
		my $time1 = $ret_ref->{"${dhcp_path}.Time1"};
		my $time2 = $ret_ref->{"${dhcp_path}.Time2"};
		$$string_ref .= sprintf("%08x%08x%08x",$iaid,$time1,$time2);

	}elsif($option_codes{$code} =~ /OPTION_IAADDR/){
		my $address = addressToBytes($ret_ref->{"${dhcp_path}.Address"});
		my $preferredlifetime = $ret_ref->{"${dhcp_path}.PreferredLifetime"};
		my $validlifetime = $ret_ref->{"${dhcp_path}.ValidLifetime"};
		$$string_ref .= $address;
		$$string_ref .= sprintf("%08x%08x",$preferredlifetime,$validlifetime);
	}elsif($option_codes{$code} =~ /OPTION_ORO/){
		my $opt_num = $length / 2;
		for(my $i=0;$i < $opt_num;$i++){
			my $optioncode = '';
			if($i > 0){
				$optioncode = $ret_ref->{"${dhcp_path}.OptionCode${i}"};
			}else{
				$optioncode = $ret_ref->{"${dhcp_path}.OptionCode"};
			}
			$$string_ref .= sprintf("%04x",$optioncode);
		}
	}elsif($option_codes{$code} =~ /OPTION_ELAPSED_TIME/){
		my $time = $ret_ref->{"${dhcp_path}.Time"};
		$$string_ref .= sprintf("%04x",$time);

	}elsif($option_codes{$code} =~ /OPTION_AUTH/){
		my $protocol = $ret_ref->{"${dhcp_path}.Protocol"};
		my $algorithm = $ret_ref->{"${dhcp_path}.Algorithm"};
		my $rdm = $ret_ref->{"${dhcp_path}.RDM"};
		my $replaydetection = $ret_ref->{"${dhcp_path}.ReplayDetection"};
		$$string_ref .= sprintf("%02x%02x%02x",$protocol,$algorithm,$rdm);
		$$string_ref .= $replaydetection;
		#only DHCPv6_Auth_Delayed is used for while
		if($protocol == 2){
			my $auth_path = "${dhcp_path}.DHCPv6_Auth_Delayed";
			my $realm = $ret_ref->{"${auth_path}.Realm"};
			my $identifier = $ret_ref->{"${auth_path}.Identifier"};
			my $authenticator = $ret_ref->{"${auth_path}.Authenticator"};
			my $auth_length = length($authenticator);
			$$md5_ref = $authenticator;
			$$string_ref .= $realm;
			$$string_ref .= sprintf("%08x",$identifier);
			$$string_ref .= sprintf("%s","0"x$auth_length);
		}elsif($protocol == 3){
			my $auth_path = "${dhcp_path}.DHCPv6_Auth_ReconfigureKey";
			my $type = $ret_ref->{"${auth_path}.Type"};
			my $data = $ret_ref->{"${auth_path}.data"};
			$$md5_ref = $data;
			$$string_ref .= sprintf("%02x",$type);
			$$string_ref .= sprintf("%s","0"x32);
		}
	}elsif($option_codes{$code} =~ /OPTION_STATUS_CODE/){
		my $statuscode = $ret_ref->{"${dhcp_path}.StatusCode"};
		my $message = $ret_ref->{"${dhcp_path}.Message"};
		$$string_ref .= sprintf("%04x",$statuscode);
		$$string_ref .= $message;
	}elsif($option_codes{$code} =~ /OPTION_RECONF_MSG/){
		my $msgtype = $ret_ref->{"${dhcp_path}.Type"};
		$$string_ref .= sprintf("%02x",$msgtype);
	}else{
		DebugStrOut("get_Opt_String:unexpected option_code:$code");
		return(1);
	}

	foreach my $dhcp_name (split(" ",$ret_ref->{$dhcp_path})){
		if($dhcp_name =~ /^Opt_/){
			my $ret = get_Opt_String($dhcp_path . "." . $dhcp_name,$ret_ref,$string_ref,$md5_ref);
			if($ret != 0){
				return(1);
			}
		}
	}
	return 0;
}

sub get_DUID_Strig($$$$){
	my ($duid_path,$ret_ref,$length,$string_ref) = @_;
	
	my $type = $ret_ref->{"$duid_path.Type"};

	if($duid_types{$type} eq "DHCPv6_DUID_LLT_Ether"){
		my $hardwaretype = $ret_ref->{"${duid_path}.HardwareType"};
		my $time = $ret_ref->{"${duid_path}.Time"};
		my $linklayeraddress = $ret_ref->{"${duid_path}.LinkLayerAddress"};
		$$string_ref .= sprintf("%04x%04x%08x",$type,$hardwaretype,$time);
		$linklayeraddress =~ s/://g;
		$$string_ref .= $linklayeraddress;

	}elsif($duid_types{$type} eq "DHCPv6_DUID_LL_Ether"){
		my $hardwaretype = $ret_ref->{"${duid_path}.HardwareType"};
		my $linklayeraddress = $ret_ref->{"${duid_path}.LinkLayerAddress"};
		$$string_ref .= sprintf("%04x%04x",$type,$hardwaretype);
		$linklayeraddress =~ s/://;
		$$string_ref .= $linklayeraddress;

	}elsif($duid_types{$type} eq "DHCPv6_DUID_EN"){
		my $enterprisenumber = $ret_ref->{"${duid_path}.EnterpriseNumber"};
		my $id = $ret_ref->{"${duid_path}.Identifier"};
		my $endofid = $ret_ref->{"${duid_path}.[Needless].data"};
		my $duid_length = $length - 6;
		$$string_ref .= sprintf("%04x%08x%0${duid_length}x",$type,$enterprisenumber,$id);

	}else{
		DebugStrOut("get_DUID_Strig:unexpected DUID type:$type");
		return 1;
	}
	return 0;
}

##############################################
# Change expression from Ascii to Byte string
#
# return value: byte expression string
##############################################
sub addressToBytes($){
        my ($addString) = @_;
        my $rtnString = undef;
        my @addressCells = split(':',$addString);
        my $cellNum = @addressCells;

        if($cellNum < 8){
                my $colons = ':' x (8 - $cellNum + 2);
                $addString =~ s/::/$colons/;
        }

        @addressCells = split(/:/,$addString,-1);
        my $num = 0;
        for(;$num < 8;$num++){
                $rtnString .= sprintf("%04s",$addressCells[$num]);
        }

        DebugStrOut("Original Address: $addString -> Address Bytes: $rtnString");

        return $rtnString;
}

##############################################
# Change expression from MAC to EUI-64
# e.g.   MAC    == "00:d0:59:ca:6e:9f"
# ->     EUI-64 == "2d0:59ff:feca:6e9f"
# return value: EUI-64 base string
##############################################
sub macToEui64($) {
	my ($mac) = @_;
	my @mac_octets = map hex, split (":", $mac);
	my @eui64_octets = ($mac_octets[0] ^ 0x02,
			@mac_octets[1..2],
			0xff, 0xfe,
			@mac_octets[3..5]);
	my $eui64 = sprintf ("%x:%x:%x:%x", unpack ("nnnn", pack ("CCCCCCCC", @eui64_octets)));
#	DebugStrOut("MAC: $mac -> EUI-64: $eui64");
	return $eui64;
}



sub
allocate_retransmission_instance($$$$)
{
	my ($irt, $mrt, $mrc, $mrd) = @_;

	my $retransmission_instance	= {
		'irt'	=> $irt,
		'mrt'	=> $mrt,
		'mrc'	=> $mrc,
		'mrd'	=> $mrd,
		'retransmission'	=> []
	};


	return($retransmission_instance);
}



sub
register_retransmission($$$)
{
	my ($instance, $date, $elapsed_time) = @_;

	my $retransmission	= $instance->{'retransmission'};

	push(@$retransmission,
		{ 'date' => $date, 'elapsed_time' => $elapsed_time });

	return;
}



sub
evaluate_retransmission($)
{
	my ($instance) = @_;

	my $irt	= $instance->{'irt'};
	my $mrt	= $instance->{'mrt'};
	my $mrc	= $instance->{'mrc'};
	my $mrd	= $instance->{'mrd'};
	my $retransmission	= $instance->{'retransmission'};

	my $judgment	= 0;
	my $basis	= 0;
	my $prev	= 0;
	my $min_rt  = $irt * (1 - $RAND);
	my $max_rt  = $irt * (1 + $RAND);

	vLogHTML("<TABLE BORDER>\n");
	vLogHTML("<TR><TH>IRT</TH><TD>$irt</TD></TR>\n");
	vLogHTML("<TR><TH>MRT</TH><TD>$mrt</TD></TR>\n");
	vLogHTML("<TR><TH>MRC</TH><TD>$mrc</TD></TR>\n");
	vLogHTML("<TR><TH>MRD</TH><TD>$mrd</TD></TR>\n");
	vLogHTML("</TABLE>\n");

	vLogHTML("<TABLE BORDER>\n");
	vLogHTML("<TR>");
	vLogHTML("<TH>#</TH>");
	vLogHTML("<TH>Interval</TH>");
	vLogHTML("<TH>Duration</TH>");
	vLogHTML("<TH>Elapsed Time</TH>");
	vLogHTML("<TH>Judgment</TH>");
	vLogHTML("</TR>\n");

	for(my $d = 0; $d <= $#$retransmission; $d ++) {
		my $message	= $retransmission->[$d];

		my $date	= $message->{'date'};

		unless($basis) {
			$basis	= $date;
		}

		unless($prev) {
			$prev	= $date;
		}

		my $interval	= $date - $prev;
		my $duration	= $date - $basis;
		my $elapsed_time	= $message->{'elapsed_time'};
		my $message	= '<B>PASS</B>';

		if($duration) {
			if($duration > 65535 / 100) {
				if($elapsed_time != 65535) {
					$message	= '<FONT COLOR="#ff0000"><B>FAIL</B><BR>';
					$message	.= 'NUT must use the value 0xffff to represent any elapsed time values<BR>';
					$message	.= 'greater than the largest time value that can be represented<BR>';
					$message	.= 'in the Elapsed Time option.</FONT>';

					$judgment	++;
				}
			} else {
				if(abs($elapsed_time - $duration * 100) >= 0.5 * 100) {
					$message	= '<FONT COLOR="#ff0000"><B>FAIL</B><BR>';
					$message	.= 'The elapsed-time is different from the actual duration.</FONT>';

					$judgment	++;
				}
			}
		} else {
			if($elapsed_time) {
				$message	= '<FONT COLOR="#ff0000"><B>FAIL</B><BR>';
				$message	.= 'The elapsed-time field must be set to 0<BR>';
				$message	.= 'in the first message<BR>';
				$message	.= 'in the message exchange.</FONT>';

				$judgment	++;
			}
		}

		if($interval) {
			if(($interval >= $max_rt + 0.5) || ($interval <= $min_rt - 0.5)) {
				$message	= '<FONT COLOR="#ff0000"><B>FAIL</B><BR>';
				$message	.= "RT must be $min_rt &lt;= RT &lt;= $max_rt</FONT>";

				$judgment	++;
			}

			$min_rt	= $interval * (2 - $RAND);
			$max_rt	= $interval * (2 + $RAND);

			if($mrt) {
				if($min_rt > $mrt || $max_rt > $mrt) {
					$min_rt = $mrt * (1 - $RAND);
					$max_rt = $mrt * (1 + $RAND);
				}
			}
		}

		if($mrd) {
			if($duration > $mrd) {
				$message	= '<FONT COLOR="#ff0000"><B>FAIL</B><BR>';
				$message	.= 'Unless MRD is zero, the message exchange fails once MRD seconds have<BR>';
				$message	.= 'elapsed since the client first transmitted the message.</FONT>';

				$judgment	++;
			}
		}

		if($mrc) {
			if($d > $mrc) {
				$message	= '<FONT COLOR="#ff0000"><B>FAIL</B><BR>';
				$message	.= 'Unless MRC is zero, the message exchange fails once the client has<BR>';
				$message	.= 'transmitted the message MRC times.</FONT>';

				$judgment	++;
			}
		}

		$prev	= $date;

		vLogHTML("<TR>\n");
		vLogHTML("<TD>$d</TD>");
		vLogHTML("<TD>$interval</TD>");
		vLogHTML("<TD>$duration</TD>");
		vLogHTML("<TD>$elapsed_time</TD>");
		vLogHTML("<TD>$message</TD>");
		vLogHTML("</TR>\n");
	}

	vLogHTML("</TABLE>\n");

	return($judgment);
}

#===============================================================
# cleanup($Link0[, $Link1]) - Test Cleanup for Client in RFC3736
#===============================================================
sub cleanup {
        my($ret);

        if ($V6evalTool::NutDef{'Type'} eq 'router') {
                $ret = _cleanup_Router(@_);
        } else {
                $ret = _cleanup_Host(@_);
        }

        return ($ret);
}

sub _cleanup_Host {
        my($IF0) = @_;
        my($ret);

       my $Success = 0;           # subroutine exit status
       my $Failure = 1;
       my $useRA = 1;

        vLogHTML('--- Cleanup NUT<BR>');

        if ($CLEANUP eq 'normal') {
                if ($useRA == 1) {      # use Global Address
                        vSend("Link0", 'cleanup_na_g');
                        vSend("Link0", 'cleanup_echo_request_g');
                        vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($WAIT_INCOMPLETE sec.)<BR>");
                        vRecv("Link0", $WAIT_INCOMPLETE, 0, 0);
                        vSend("Link0", 'cleanup_ra');
                        $useRA = 0;
                }

                vSend("Link0", 'cleanup_na');
                vSend("Link0", 'cleanup_echo_request');
                vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($WAIT_INCOMPLETE sec.)<BR>");
                vRecv("Link0", $WAIT_INCOMPLETE, 0, 0);
        } elsif ($CLEANUP eq 'reboot') {
                $ret = specReboot();
                vSleep($SLEEP_AFTER_REBOOT);
                if ($ret) {
                        $ret = $Failure;
                } else {
                        $ret = $Success;
                }
        } elsif ($CLEANUP eq 'nothing') {
                vSleep($CLEANUP_INTERVAL);
                $ret = $Success;
        } else {
                vLogHTML("unrecognized cleanup keyword ``$CLEANUP'' in config.pl<BR>");
                $ret = $Failure;
        }

        return ($ret);
}

sub _cleanup_Router {
        my($IF0, $IF1) = @_;
        my($ret, $tnaddr, $nutdev);
#
#        vLogHTML('--- Cleanup CE-Router<BR>');
#
##        if ($CLEANUP eq 'normal') {
##                vClear($IF0);
##                desc_vSend($IF0, 'cleanup_na');
##                desc_vSend($IF0, 'cleanup_echo_request');
##                vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($WAIT_INCOMPLETE sec.)<BR>");
##                vRecv($IF0, $WAIT_INCOMPLETE, 0, 0);
##
##                if (defined($IF1) && $IF1) {
##                        # many tests which unused Link1 is not needed
##                        # to cleanup Global address on Link0 also.
##                        desc_vSend($IF0, 'cleanup_na_g');
##                        desc_vSend($IF0, 'cleanup_echo_request_g');
##                        vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($WAIT_INCOMPLETE sec.)<BR>");
##                        vRecv($IF0, $WAIT_INCOMPLETE, 0, 0);
##
##                        vClear($IF1);
##                        desc_vSend($IF1, 'cleanup_na_1');
##                        desc_vSend($IF1, 'cleanup_echo_request_1');
##                        vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($WAIT_INCOMPLETE sec.)<BR>");
##                        vRecv($IF1, $WAIT_INCOMPLETE, 0, 0);
##
##                        desc_vSend($IF1, 'cleanup_na_g_1');
##                        desc_vSend($IF1, 'cleanup_echo_request_g_1');
##                        vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($WAIT_INCOMPLETE sec.)<BR>");
##                        vRecv($IF1, $WAIT_INCOMPLETE, 0, 0);
##                }
##
##                $ret = cleanup_deleteRoute();
##        } elsif ($CLEANUP eq 'reboot') {
##                $ret = specReboot();
##                vSleep($SLEEP_AFTER_REBOOT);
##                if ($ret) {
##                        $ret = $Failure;
##                } else {
##                        $ret = $Success;
##                }
##        } elsif ($CLEANUP eq 'nothing') {
##                $ret = cleanup_deleteRoute();
##                vSleep($CLEANUP_INTERVAL);
##        }
#
        return ($ret);
}

#===============================================================
# specReboot() - reboot target
#===============================================================
# argument:
#    nothing
# return:
#    Success / Failure
#===============================================================
sub specReboot {
        my ($ret);

       my $remote_debug = '';
        my $Success = 0;           # subroutine exit status
        my $Failure = 1;

        vLogHTML('Target: Reboot<BR>');
        $ret = vRemote('reboot.rmt', $remote_debug, "timeout=$WAIT_REBOOTCMD");

        if ($ret == 0) {
                return ($Success);
        } else {
                return ($Failure);
        }
}

#--------------------------------------------------------------#
# ResetDhcpOpt()                                               #
#                                                              #
# Notes:                                                       #
#	Reset dhcpv6 option to default vaule.                  #
#                                                              #
# Input:  None                                                 #	
#--------------------------------------------------------------#
sub ResetDhcpOpt(){
	$SID_OPTION = "";
	$IA_NA_OPTION = "";
	$IA_NA_OPTION1 = "";
	$IA_TA_OPTION = "";
	$IA_PD_OPTION = "";
	$IA_PD_OPTION1 = "";
	$OptionRequest_OPTION = "";
	$Preference_OPTION = "";
	$ElapsedTime_OPTION = "";
	$Authentication_OPTION = "";
	$Authentication_OPTION2 = "";
	$ServerUnicast_OPTION = "";
	$RapidCommit_OPTION = "";
	$UserClass_OPTION = "";
	$VendorClass_OPTION = "";
	$VendorSpecificInfo_OPTION = "";
	$IID_OPTION = "";
	$ReconfigureMessage_OPTION = "";
	$ReconfigureAccept_OPTION = "";
	$StatusCode_OPTION = "";
	$DNS_SVR_OPTION = "";
	$DNS_LST_OPTION = "";
	$RELAY_Msg_OPTION = "";
	return 1;
}

#--------------------------------------------------------------#
# ChkAdvFunc(\$Fuction_type)                                   #
#                                                              #
# Notes:                                                       #
#	check if the function has been support                 #
#	The function code are listed in CPE6_config.           #
#                                                              #
# Input:  Function type                                        #	
#--------------------------------------------------------------#
sub ChkAdvFunc($){
	my ($config_param) = @_;
#${$DHCPv6_config::{$config_param}};
	my $param = ${$CPE6_config::{$config_param}};
	if($param){
		vLogHTML("<B>ChkAdvFunc : param = $param ; config_param = $config_param</B><BR>");
		return 0;
	}
	return 1;
}

#--------------------------------------------------------------#
# change_maxSolRt()                                            #
#                                                              #
# Notes:                                                       #
#	Change the default value of SOL_MAX_RT                       #
#                                                              #
# Input:  new value for SOL_MAX_RT                             #
#	                                                             #
#--------------------------------------------------------------#
sub change_maxSolRt($) {
    my ($value) = @_;
    $SOL_MAX_RT = $value;
    return 0;
}

#--------------------------------------------------------------#
# ping_nut_ll()                                                   #
#                                                              #
# Notes:                                                       #
#	Send echo request to NUT's link-local address                #
#                                                              #
# Input:  N/A                                                  #
#	                                                             #
#--------------------------------------------------------------#
sub ping_nut_ll() {
	my $IF0="Link0";
# Echo request TR1 -> CE-Router
	vSend($IF0,'ereq_tr1_to_nut');
	my %ret = vRecv($IF0, 5 ,0 ,0, 'erep_nut_to_tr1','ns_any_to_tr1');
	if ($ret{'status'} == 0) {
	  if ($ret{'recvFrame'} eq 'erep_nut_to_tr1') {
	    vLogHTML('TR1 receives echo reply from CE-Router<BR>');
	  } else {
	    vLogHTML('Receive NS from CE-Router.Send NA.<BR>');
	    vSend($IF0, 'na_ll_tr1_to_nut');
	    my %ret1 = vRecv($IF0, 5 ,0 ,0, 'erep_nut_to_tr1');
	    if ($ret1{'status'} == 0) {
	      vLogHTML('TR1 receives echo reply from CE-Router<BR>');
	    } else {
	      vLogHTML('Did not receive Echo Reply<BR>');
	      vLogHTML('<FONT COLOR="#FF0000">NG</FONT><BR>');
	      return 1;
	    }
	  }
	} else {
	  vLogHTML('Did not receive echo reply or NS.<BR>');
	  vLogHTML('<FONT COLOR="#FF0000">NG</FONT><BR>');
	  return 1;
	}
	return 0;
}

#--------------------------------------------------------------#
# cpe_initialization()                                         #
#                                                              #
# Notes:                                                       #
#	1. Provide CE Router WAN side parameter;                     #
# 2. use echo request and echo reply to let CE Router has      #
#      neighbor cache of TR1;                                  #
#	3. check if CE pass the parameter to its LAN side.           #
#                                                              #
# Input:  RA, WAN interface, LAN interface, WAN address mode   #
#	and need to provide what kind of stateless option            #
#--------------------------------------------------------------#
sub cpe_initialization($$$$$) {
	my ($ra,$IF0, $IF1, $iana, $stateless_option) = @_;
	my $dns_option = 1;
	my $dnssl_option = 1;
	my $stateful_option;

# 1.Send RA
	if ($iana) {
		# 2 parameters : IA_NA & IA_PD
		$stateful_option = 2;
	} else {
		# 1 parameter : IA_PD
		$stateful_option = 1;
	}
	vSend($IF0, $ra);
	
	my $ping_result = ping_nut_ll();
	if ($ping_result != 0) {
		vLogHTML("<B>Ping test FAIL!.</B><BR>");
		return (1, "");
	}

# 2.Wait until DHCPv6 Solicit arrives
	my ($retsol,%sol) = wait_for_solicit2($IF0, 30);
	if($retsol != 0) {
		vLogHTML("<B>Could not get Solicit Message.</B><BR>");
		return (1, %sol);
	}
	if ($stateful_option == 2 ) {
		if (0 != options_exist(\%sol, ($CMP_IA_NA | $CMP_IA_PD))) {
			vLogHTML("<B>DHCPv6 Solicit do not include necessay stateful options.</B><BR>");
			return (1, %sol);
		}
	} else {
		if (0 != options_exist(\%sol, $CMP_IA_PD)) {
			vLogHTML("<B>DHCPv6 Solicit do not include necessay stateful options.</B><BR>");
			return (1, %sol);
		}
	}

#	$stateless_option 
#	0 : does not need any stateless option
#	1 : need DNS Server option in DHCPv6
#	2 : need Domain Name Search List option in DHCPv6
#	3 : need both DNS server option and domain search list option in DHCPv6

	if ($stateless_option) {
		if ($stateless_option == 1) {
			$dns_option = lookup_OptRequestCode(\%sol,23);
			if ($dns_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include DNS Sever options.</B><BR>");
				return (1, %sol);
			}
		} elsif ($stateless_option == 2) {
			$dnssl_option = lookup_OptRequestCode(\%sol,24);
			if ($dnssl_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include Domain Name Seach List options.</B><BR>");
				return (1, %sol);
			}
		} elsif ($stateless_option == 3) {
			$dns_option = lookup_OptRequestCode(\%sol,23);
			$dnssl_option = lookup_OptRequestCode(\%sol,24);
			if ($dns_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include DNS Seve options.</B><BR>");
				return (1, %sol);
			}
			if ($dnssl_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include Domain Name Seach List options.</B><BR>");
				return (1, %sol);
			}
		}
	}
# 3.Send DHCPv6 Advetise message
	$SID_OPTION = "opt_SID_LLT_server1";
	if ($stateful_option == 2) {
		$IA_NA_OPTION = "opt_IA_NA_Addr_woStatus";
	}
	$IA_PD_OPTION = "opt_IA_PD_PF1";
	$DNS_SVR_OPTION = "opt_DNS_Name_Server1";
	$DNS_LST_OPTION = "opt_DNS_ServerSearchList";

	  
	my ($retadv, %adv) = send_advertise($IF0, "advertise_server1_to_nut", \%sol, "");
	if($retadv != 0) {
		vLogHTML("<B>Failed to send DHCPv6 Advetisement.</B><BR>");
		return (1, %adv);
	}
# 4.Wait until DHCPv6 Request arrives
	my ($reteq,%req) = wait_for_request2($IF0, 30);
	if($reteq != 0) {
		vLogHTML("<B>Could not get DHCPv6 equest Message.</B><BR>");
		return (1, %req);
	}

	 if ($stateful_option == 2 ) {
		if (0 != options_exist(\%req, ($CMP_IA_NA | $CMP_IA_PD))) {
			vLogHTML("<B>DHCPv6 Request message do not include necessay stateful options.</B><BR>");
			return (1, %req);
		}
	} else {
		if (0 != options_exist(\%req, $CMP_IA_PD)) {
			vLogHTML("<B>DHCPv6 Request message do not include necessay stateful options.</B><BR>");
			return (1, %req);
		}
	}
	
	if (!$dns_option) {
			$dns_option = lookup_OptRequestCode(\%req,23);
			if ($dns_option) {
				vLogHTML("<B>DHCPv6 Request do not include DNS Sever options.</B><BR>");
				return (1, %req);
			}
	}

	if (!$dnssl_option) {
			$dnssl_option = lookup_OptRequestCode(\%req,24);
			if ($dnssl_option) {
				vLogHTML("<B>DHCPv6 Request do not include Domain Name Seach List options.</B><BR>");
				return (1, %req);
			}
	}
# 5.Send DHCPv6 Reply message
	$SID_OPTION = "opt_SID_LLT_server1";
	if ($stateful_option == 2) {
		$IA_NA_OPTION = "opt_IA_NA_Addr_woStatus";
	}
	$IA_PD_OPTION = "opt_IA_PD_PF1";
	$DNS_SVR_OPTION = "opt_DNS_Name_Server1";
	$DNS_LST_OPTION = "opt_DNS_ServerSearchList";
#	$StatusCode_OPTION = "opt_StatusCode";

	my ($retep, %rep) = send_reply($IF0, "reply_server1_to_nut", \%req, "");
	if($retep != 0) {
		vLogHTML("<B>Failed to send DHCPv6 Reply.</B><BR>");
		return (1, %rep);
	}

	if ($iana) {
	  vCPP("-D\'NUT_ADDR=NUT_GLOBAL_ADDR_From_IANA' ");
	}

	if ($IF1) {
	  vSleep($WAIT_LAN_RA);
	  vClear($IF1);
	  vSend($IF1,'rs_tn5_to_nut');
	  my %ret = vRecvPacket($IF1, 10, 0, 0, "ra_any");
	  if ($ret{status} == 0) {
	    # Get global prefix
	    my $count = 1;
	    my $base = 'Frame_Ether.Packet_IPv6.ICMPv6_RA.Opt_ICMPv6_Prefix';
	    my $prefix_opt = $base;
	    my $tn2_prefix = "";
	    my $global_prefix = 0;
	    my $prefix_opt_num = $ret{"Frame_Ether.Packet_IPv6.ICMPv6_RA.Opt_ICMPv6_Prefix#"};
	    
	    while (($count <= $prefix_opt_num) && ($global_prefix == 0)){
	      $tn2_prefix = $ret{$prefix_opt."."."Prefix"};
	      if (!(($tn2_prefix =~ /fc/) || ($tn2_prefix =~ /fd/))) {
					vLogHTML("<B>Get global prefix($tn2_prefix) in RA.</B><BR>");
					$global_prefix = 1;
					vCPP("-D\'PREFIX_FROM_PD=\"$tn2_prefix\"\' ");
	      } 
	      $count++;
	      $prefix_opt = $base.$count;
	    }
	    return (0,$tn2_prefix); 
	  }else {
	    vLogHTML("<B>Error : Did not receive RA with Router Lifetime  > 0.</B><BR>");
	    return (1,%ret);
	  }
	} else {
	  # Wait 5 seconds to ignore WAN global address DAD
	  vSleep(5);
	  return (0,"");
	}
}

#--------------------------------------------------------------#
# cpe_initialization_1_2()                                     #
#                                                              #
# Notes:                                                       #
#	1. Provide CE Router WAN side parameter;                     # 
#	2. check if CE pass the parameter to its LAN side.           #
#                                                              #
# Input:  RA, WAN interface, LAN interface, WAN address mode   #
#	and need to provide what kind of stateless option            #
#--------------------------------------------------------------#
sub cpe_initialization_1_2($$$$$) {
	my ($ra,$IF0, $IF1, $iana, $stateless_option) = @_;
	my $dns_option = 1;
	my $dnssl_option = 1;
	my $stateful_option;
# 1.Send RA
	if ($iana) {
		# 2 parameters : IA_NA & IA_PD
		$stateful_option = 2;
#		vSend($IF0, 'ra_MsetOset');
	} else {
		# 1 parameter : IA_PD
		$stateful_option = 1;
#		vSend($IF0, 'ra_MclearOset');
	}
	vSend($IF0, $ra);
# 2.Wait until DHCPv6 Solicit arrives
	my ($retsol,%sol) = wait_for_solicit2($IF0, 30);
	if($retsol != 0) {
		vLogHTML("<B>Could not get Solicit Message.</B><BR>");
		return (1, %sol);
	}
	if ($stateful_option == 2 ) {
		if (0 != options_exist(\%sol, ($CMP_IA_NA | $CMP_IA_PD))) {
			vLogHTML("<B>DHCPv6 Solicit do not include necessay stateful options.</B><BR>");
			return (1, %sol);
		}
	} else {
		if (0 != options_exist(\%sol, $CMP_IA_PD)) {
			vLogHTML("<B>DHCPv6 Solicit do not include necessay stateful options.</B><BR>");
			return (1, %sol);
		}
	}

#	$stateless_option 
#	0 : does not need any stateless option
#	1 : need DNS Server option in DHCPv6
#	2 : need Domain Name Search List option in DHCPv6
#	3 : need both DNS server option and domain search list option in DHCPv6

	if ($stateless_option) {
		if ($stateless_option == 1) {
			$dns_option = lookup_OptRequestCode(\%sol,23);
			if ($dns_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include DNS Sever options.</B><BR>");
				return (1, %sol);
			}
		} elsif ($stateless_option == 2) {
			$dnssl_option = lookup_OptRequestCode(\%sol,24);
			if ($dnssl_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include Domain Name Seach List options.</B><BR>");
				return (1, %sol);
			}
		} elsif ($stateless_option == 3) {
			$dns_option = lookup_OptRequestCode(\%sol,23);
			$dnssl_option = lookup_OptRequestCode(\%sol,24);
			if ($dns_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include DNS Seve options.</B><BR>");
				return (1, %sol);
			}
			if ($dnssl_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include Domain Name Seach List options.</B><BR>");
				return (1, %sol);
			}
		}
	}
# 3.Send DHCPv6 Advetise message
	$SID_OPTION = "opt_SID_LLT_server1";
	if ($stateful_option == 2) {
		$IA_NA_OPTION = "opt_IA_NA_Addr_woStatus";
	}
	$IA_PD_OPTION = "opt_IA_PD_PF1";
	$DNS_SVR_OPTION = "opt_DNS_Name_Server1";
	$DNS_LST_OPTION = "opt_DNS_ServerSearchList";

	  
	my ($retadv, %adv) = send_advertise($IF0, "advertise_server1_to_nut", \%sol, "");
	if($retadv != 0) {
		vLogHTML("<B>Failed to send DHCPv6 Advetisement.</B><BR>");
		return (1, %adv);
	}
# 4.Wait until DHCPv6 Request arrives
	my ($reteq,%req) = wait_for_request2($IF0, 30);
	if($reteq != 0) {
		vLogHTML("<B>Could not get DHCPv6 equest Message.</B><BR>");
		return (1, %req);
	}

	 if ($stateful_option == 2 ) {
		if (0 != options_exist(\%req, ($CMP_IA_NA | $CMP_IA_PD))) {
			vLogHTML("<B>DHCPv6 Request message do not include necessay stateful options.</B><BR>");
			return (1, %req);
		}
	} else {
		if (0 != options_exist(\%req, $CMP_IA_PD)) {
			vLogHTML("<B>DHCPv6 Request message do not include necessay stateful options.</B><BR>");
			return (1, %req);
		}
	}
	
	if (!$dns_option) {
			$dns_option = lookup_OptRequestCode(\%req,23);
			if ($dns_option) {
				vLogHTML("<B>DHCPv6 Request do not include DNS Sever options.</B><BR>");
				return (1, %req);
			}
	}

	if (!$dnssl_option) {
			$dnssl_option = lookup_OptRequestCode(\%req,24);
			if ($dnssl_option) {
				vLogHTML("<B>DHCPv6 Request do not include Domain Name Seach List options.</B><BR>");
				return (1, %req);
			}
	}
# 5.Send DHCPv6 Reply message
	$SID_OPTION = "opt_SID_LLT_server1";
	if ($stateful_option == 2) {
		$IA_NA_OPTION = "opt_IA_NA_Addr_woStatus";
	}
	$IA_PD_OPTION = "opt_IA_PD_PF1";
	$DNS_SVR_OPTION = "opt_DNS_Name_Server1";
	$DNS_LST_OPTION = "opt_DNS_ServerSearchList";
	$StatusCode_OPTION = "opt_StatusCode";

	my ($retep, %rep) = send_reply($IF0, "reply_server1_to_nut", \%req, "");
	if($retep != 0) {
		vLogHTML("<B>Failed to send DHCPv6 Reply.</B><BR>");
		return (1, %rep);
	}

	if ($iana) {
	  vCPP("-D\'NUT_ADDR=NUT_GLOBAL_ADDR_From_IANA' ");
	}

	if ($IF1) {
	  vSleep($WAIT_LAN_RA);
	  vClear($IF1);
	  vSend($IF1,'rs_tn5_to_nut');
	  my %ret = vRecvPacket($IF1, 10, 0, 0, "ra_any");
	  if ($ret{status} == 0) {
	    # Get global prefix
	    my $count = 1;
	    my $base = 'Frame_Ether.Packet_IPv6.ICMPv6_RA.Opt_ICMPv6_Prefix';
	    my $prefix_opt = $base;
	    my $tn2_prefix = "";
	    my $global_prefix = 0;
	    my $prefix_opt_num = $ret{"Frame_Ether.Packet_IPv6.ICMPv6_RA.Opt_ICMPv6_Prefix#"};
	    
	    while (($count <= $prefix_opt_num) && ($global_prefix == 0)){
	      $tn2_prefix = $ret{$prefix_opt."."."Prefix"};
	      if (!(($tn2_prefix =~ /fc/) || ($tn2_prefix =~ /fd/))) {
					vLogHTML("<B>Get global prefix($tn2_prefix) in RA.</B><BR>");
					$global_prefix = 1;
					vCPP("-D\'PREFIX_FROM_PD=\"$tn2_prefix\"\' ");
	      } 
	      $count++;
	      $prefix_opt = $base.$count;
	    }
	    return (0,$tn2_prefix); 
	  }else {
	    vLogHTML("<B>Error : Did not receive RA with Router Lifetime  > 0.</B><BR>");
	    return (1,%ret);
	  }
	} else {
	  # Wait 3 seconds to ignore WAN global address DAD
	  vSleep(3);
	  return (0,"");
	}
}

#--------------------------------------------------------------#
# wan_init_without_waiting()                                   #
#                                                              #
# Notes:                                                       #
#	1. Provide CE Router WAN side parameter;                     #
# 2. use echo request and echo reply to let CE Router has      #
#      neighbor cache of TR1;                                  #
#	3. check if CE pass the parameter to its LAN side.           #
#                                                              #
# Input:  RA, WAN interface, LAN interface, WAN address mode   #
#	and need to provide what kind of stateless option            #
#--------------------------------------------------------------#
sub wan_init_without_waiting($$$$$) {
	my ($ra,$IF0, $IF1, $iana, $stateless_option) = @_;
	my $dns_option = 1;
	my $dnssl_option = 1;
	my $stateful_option;

# 1.Send RA
	if ($iana) {
		# 2 parameters : IA_NA & IA_PD
		$stateful_option = 2;
	} else {
		# 1 parameter : IA_PD
		$stateful_option = 1;
	}
	vSend($IF0, $ra);
	
	my $ping_result = ping_nut_ll();
	if ($ping_result != 0) {
		vLogHTML("<B>Ping test FAIL!.</B><BR>");
		return (1, "");
	}

# 2.Wait until DHCPv6 Solicit arrives
	my ($retsol,%sol) = wait_for_solicit2($IF0, 30);
	if($retsol != 0) {
		vLogHTML("<B>Could not get Solicit Message.</B><BR>");
		return (1, %sol);
	}
	if ($stateful_option == 2 ) {
		if (0 != options_exist(\%sol, ($CMP_IA_NA | $CMP_IA_PD))) {
			vLogHTML("<B>DHCPv6 Solicit do not include necessay stateful options.</B><BR>");
			return (1, %sol);
		}
	} else {
		if (0 != options_exist(\%sol, $CMP_IA_PD)) {
			vLogHTML("<B>DHCPv6 Solicit do not include necessay stateful options.</B><BR>");
			return (1, %sol);
		}
	}

#	$stateless_option 
#	0 : does not need any stateless option
#	1 : need DNS Server option in DHCPv6
#	2 : need Domain Name Search List option in DHCPv6
#	3 : need both DNS server option and domain search list option in DHCPv6

	if ($stateless_option) {
		if ($stateless_option == 1) {
			$dns_option = lookup_OptRequestCode(\%sol,23);
			if ($dns_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include DNS Sever options.</B><BR>");
				return (1, %sol);
			}
		} elsif ($stateless_option == 2) {
			$dnssl_option = lookup_OptRequestCode(\%sol,24);
			if ($dnssl_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include Domain Name Seach List options.</B><BR>");
				return (1, %sol);
			}
		} elsif ($stateless_option == 3) {
			$dns_option = lookup_OptRequestCode(\%sol,23);
			$dnssl_option = lookup_OptRequestCode(\%sol,24);
			if ($dns_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include DNS Seve options.</B><BR>");
				return (1, %sol);
			}
			if ($dnssl_option) {
				vLogHTML("<B>DHCPv6 Solicit do not include Domain Name Seach List options.</B><BR>");
				return (1, %sol);
			}
		}
	}
# 3.Send DHCPv6 Advetise message
	$SID_OPTION = "opt_SID_LLT_server1";
	if ($stateful_option == 2) {
		$IA_NA_OPTION = "opt_IA_NA_Addr_woStatus";
	}
	$IA_PD_OPTION = "opt_IA_PD_PF1";
	$DNS_SVR_OPTION = "opt_DNS_Name_Server1";
	$DNS_LST_OPTION = "opt_DNS_ServerSearchList";

	  
	my ($retadv, %adv) = send_advertise($IF0, "advertise_server1_to_nut", \%sol, "");
	if($retadv != 0) {
		vLogHTML("<B>Failed to send DHCPv6 Advetisement.</B><BR>");
		return (1, %adv);
	}
# 4.Wait until DHCPv6 Request arrives
	my ($reteq,%req) = wait_for_request2($IF0, 30);
	if($reteq != 0) {
		vLogHTML("<B>Could not get DHCPv6 equest Message.</B><BR>");
		return (1, %req);
	}

	 if ($stateful_option == 2 ) {
		if (0 != options_exist(\%req, ($CMP_IA_NA | $CMP_IA_PD))) {
			vLogHTML("<B>DHCPv6 Request message do not include necessay stateful options.</B><BR>");
			return (1, %req);
		}
	} else {
		if (0 != options_exist(\%req, $CMP_IA_PD)) {
			vLogHTML("<B>DHCPv6 Request message do not include necessay stateful options.</B><BR>");
			return (1, %req);
		}
	}
	
	if (!$dns_option) {
			$dns_option = lookup_OptRequestCode(\%req,23);
			if ($dns_option) {
				vLogHTML("<B>DHCPv6 Request do not include DNS Sever options.</B><BR>");
				return (1, %req);
			}
	}

	if (!$dnssl_option) {
			$dnssl_option = lookup_OptRequestCode(\%req,24);
			if ($dnssl_option) {
				vLogHTML("<B>DHCPv6 Request do not include Domain Name Seach List options.</B><BR>");
				return (1, %req);
			}
	}
# 5.Send DHCPv6 Reply message
	$SID_OPTION = "opt_SID_LLT_server1";
	if ($stateful_option == 2) {
		$IA_NA_OPTION = "opt_IA_NA_Addr_woStatus";
	}
	$IA_PD_OPTION = "opt_IA_PD_PF1";
	$DNS_SVR_OPTION = "opt_DNS_Name_Server1";
	$DNS_LST_OPTION = "opt_DNS_ServerSearchList";
#	$StatusCode_OPTION = "opt_StatusCode";

	my ($retep, %rep) = send_reply($IF0, "reply_server1_to_nut", \%req, "");
	if($retep != 0) {
		vLogHTML("<B>Failed to send DHCPv6 Reply.</B><BR>");
		return (1, %rep);
	}

	if ($iana) {
	  vCPP("-D\'NUT_ADDR=NUT_GLOBAL_ADDR_From_IANA' ");
	}

}
########################################################################
__END__

=head1 NAME

DHCPv6_common - Perl module for DHCPv6 

=head1 SYNOPSIS

  use DHCPv6_common;

=head1 ENVIRONMENT


=head1 DESCRIPTION


=head1 FILES


=head1 SUPPORTED FUNCTIONS

=over 4

=head1 dhcpReset

sub dhcpReset() 
	after test, reset the test environment.

=head1 dhcpExitError

sub dhcpExitError($) 
	Exit with error message.
	
=cut

