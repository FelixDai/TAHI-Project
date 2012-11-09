#!/usr/bin/perl
# Copyright (C) 1999,2000 Yokogawa Electric Corporation and
#                         YDC Corporation.
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
# $Id: pareport.pl,v 1.4 2000/03/02 09:02:01 teraoka Exp $
# pareport - pa output file reporting tool

$inputfile = "$ARGV[0]" ;

############################
######## initialize ########
############################
# Mode
$Mod_Ether = 0 ;
$Mod_IP = 1 ;
$Mod_IPv6 = 0 ;
$Mod_ExtHdr = 0 ;
$Mod_HopByHop = 0 ;
$Mod_Destination = 0 ;
$Mod_Fragment = 0 ;
$Mod_JumboPayload = 0 ;
$Mod_ICMPv6 = 0 ;		           # ICMPv6 GENERAL
$Mod_ICMPv6_RS = 0 ;
$Mod_ICMPv6_RA = 0 ;
$Mod_ICMPv6_NA = 0 ;
$Mod_ICMPv6_Redirect = 0 ;
$Mod_ICMPv6_PacketTooBig = 0 ;
$Mod_ICMPv6_DestinationUnreachable = 0 ;
$Mod_ICMPv6_ParameterProblem = 0 ;
$Mod_ICMPv6_TimeExceeded = 0 ;
$Mod_TCP = 0 ;
$Mod_UDP = 0 ;
$Mod_PayloadZero = 0 ;
$Mod_SDmismatch = 0 ;

# Variable
$Var_DstAdr = 0 ;                    # 1 : unicast, 2 : multicast
$Var_PayloadLength = 0 ;
$Var_HopLimit = 0 ;
$Var_MFlag = 0 ;                     # 0 : last, 1 : continue
$Var_Payload = 0 ;                   # for Fragment packet

# Header
$Hdr_IPv4 = 0 ;
$Hdr_IPv6 = 0 ;
$Cou_Other = 0 ;
$Cou_ExtHdr = 0 ;
$Hdr_HopByHop = 0 ;
$Hdr_Destination = 0 ;
$Hdr_Routing = 0 ;
$Hdr_Fragment = 0 ;
$Hdr_AH = 0 ;
$Hdr_ESP = 0 ;
$Hdr_TCP = 0 ;
$Hdr_UDP = 0 ;

# Option
$Opt_JumboPayload = 0 ;

# ICMPv6
$ICMPv6_RS = 0 ;
$ICMPv6_RA = 0 ;
$ICMPv6_NS = 0 ;
$ICMPv6_NA = 0 ;
$ICMPv6_NS_ToSo = 0 ;
$ICMPv6_NS_FrUni = 0 ;
$ICMPv6_NS_FrDAD = 0 ;
$ICMPv6_NS_ToUni = 0 ;
$ICMPv6_NA_ToUni = 0 ;
$ICMPv6_NA_ToDAD = 0 ;
$ICMPv6_Redirect = 0 ;
$ICMPv6_Redirect_DIP = 0 ;
$ICMPv6_Redirect_LIP = 0 ;
$ICMPv6_MLD = 0 ;
$ICMPv6_MLDQuery = 0 ;
$ICMPv6_MLDReport = 0 ;
$ICMPv6_MLDDone = 0 ;
$ICMPv6_PacketTooBig = 0 ;
$ICMPv6_DestinationUnreachable = 0 ;
$ICMPv6_ParameterProblem = 0 ;
$ICMPv6_TimeExceeded = 0 ;

# ICMP Code
$ICMPv6_DesUnr_NoRo = 0 ;
$ICMPv6_DesUnr_AP = 0 ;
$ICMPv6_DesUnr_PU = 0 ;
$ICMPv6_DesUnr_PT = 0 ;
$ICMPv6_TimeExceeded_H = 0 ;
$ICMPv6_TimeExceeded_F = 0 ;
$ICMPv6_ParameterProblem = 0 ;
$ICMPv6_ParameterProblem_E = 0 ;
$ICMPv6_ParameterProblem_N = 0 ;
$ICMPv6_ParameterProblem_I = 0 ;

# Unicast
$Cou_Uni = 0 ;
$Cou_U_General = 0 ;
$Cou_U_LoopBack = 0 ;
$Cou_U_LinkLocal = 0 ;
$Cou_U_SiteLocal = 0 ;
$Cou_U_Global = 0 ;

# Multicast
$Cou_M_general = 0 ;
$Cou_M_reserved = 0 ;
$Cou_M_well = 0 ;
$Cou_M_Node_all_w = 0 ;
$Cou_M_Node_node_w = 0 ;
$Cou_M_Node_link_w = 0 ;
$Cou_M_AllRoutes_w = 0 ;
$Cou_M_Routes_node_w = 0 ;
$Cou_M_Routes_link_w = 0 ;
$Cou_M_Routes_site_w = 0 ;
$Cou_M_AllPRoutes_w = 0 ;
$Cou_M_PRoutes_node_w = 0 ;
$Cou_M_PRoutes_link_w = 0 ;
$Cou_M_PRoutes_site_w = 0 ;
$Cou_M_Solicited_w = 0 ;
$Cou_M_Others_w = 0 ;
$Cou_M_trans = 0 ;

# etc
$Cou_TotalPkt = 0 ;
$Cou_v6ov6 = 0 ;
$Cou_v4ov6 = 0 ;
$Cou_v6ov4 = 0 ;
$Cou_v4ov4 = 0 ;
$Cou_NS_Hop_Limit = 0 ;
$Cou_NA_Hop_Limit = 0 ;
$Cou_RS_Hop_Limit = 0 ;
$Cou_RA_Hop_Limit = 0 ;
$Cou_v4_compati = 0 ;
$Cou_v4_mapped = 0 ;
$Cou_RIPng = 0 ;

# Error
$Err_Ether = 0 ;
$Err_Header_value = 0 ;
$Err_LoopBack = 0 ;
$Err_Multicast = 0 ;
$Err_SDmismatch = 0 ;
$Err_RH_Multicast = 0 ;
$Err_Frag_Jumbo = 0 ;
$Err_Frag_Aligment = 0 ;
$Err_v6PayloadLength = 0 ;
$Err_PayloadLength = 0 ;
$Err_UDPlength_JP = 0 ;
$Err_UDPlength_woJP = 0 ;
$Err_JumboPayloadLength = 0 ;
$Err_HopByHop = 0 ;
$Err_HopByHop_2t = 0 ;
$Err_Destination = 0 ;
$Err_ICMPv6_PacketTooBig = 0 ;
$Err_ICMPv6_Unrecognize = 0 ;
$Err_UDP_checksum = 0 ;
$Err_TCP_checksum = 0 ;
$Err_ICMP_checksum = 0 ;
$Err_ICMPv6_Redirect_HL = 0 ;
$Err_ICMPv6_Redirect_DL = 0 ;

############################
######## open file #########
############################
&sub_open ( "IPv6", "Hdr_IPv6" ) ;
&sub_open ( "IPv4", "Hdr_IPv4" ) ;
&sub_open ( "Other", "Cou_Other" ) ;
&sub_open ( "<B>IPv6 over IPv6</B>", "Cou_v6ov6" ) ;
&sub_open ( "<B>IPv4 over IPv6</B>", "Cou_v4ov6" ) ;
&sub_open ( "<B>IPv6 over IPv4</B>", "Cou_v6ov4" ) ;
&sub_open ( "<B>IPv4 over IPv4</B>", "Cou_v4ov4" ) ;
# ExtHdr ------------------------------------------------------------------
&sub_open ( "Hop-by-Hop Options Header", "Hdr_HopByHop" ) ;
&sub_open ( "Routing Header", "Hdr_Routing" ) ;
&sub_open ( "Fragment Header", "Hdr_Fragment" ) ;
&sub_open ( "Destination Options Header", "Hdr_Destination" ) ;
&sub_open ( "AH Header", "Hdr_AH" ) ;
&sub_open ( "ESP Header", "Hdr_ESP" ) ;
# Extension Header Option -------------------------------------------------
&sub_open ( "Jumbo Payload option", "Opt_JumboPayload" ) ;
# ICMP --------------------------------------------------------------------
&sub_open ( "Neighbor Solicitation", "ICMPv6_NS" ) ;
&sub_open ( "To Solicited Address", "ICMPv6_NS_ToSo" ) ;
&sub_open ( "From Unicast", "ICMPv6_NS_FrUni" ) ;
&sub_open ( "From Unspecified&lt;DAD&gt;", "ICMPv6_NS_FrDAD" ) ;
&sub_open ( "To Unicast Address", "ICMPv6_NS_ToUni" ) ;
&sub_open ( "Neighbor Advertisement", "ICMPv6_NA" ) ;
&sub_open ( "To Unicast", "ICMPv6_NA_ToUni" ) ;
&sub_open ( "To All-nodes&lt;DAD&gt;", "ICMPv6_NA_ToDAD" ) ;
&sub_open ( "Router Solicitation", "ICMPv6_RS" ) ;
&sub_open ( "Router Advertisement", "ICMPv6_RA" ) ;
# Address -----------------------------------------------------------------
&sub_open ( "IPv6 Unicast", "Cou_Uni" ) ;
&sub_open ( "Loop-Back", "Cou_U_LoopBack" ) ;
&sub_open ( "Link-local", "Cou_U_LinkLocal" ) ;
&sub_open ( "Site-local", "Cou_U_SiteLocal" ) ;
&sub_open ( "Global", "Cou_U_Global" ) ;
&sub_open ( "IPv6 Multicast", "Cou_M_general" ) ;
&sub_open ( "Reserved(Not Used)", "Cou_M_reserved" ) ;
&sub_open ( "Well-known", "Cou_M_well" ) ;
&sub_open ( "All nodes", "Cou_M_Node_all_w" ) ;
&sub_open ( "node scope", "Cou_M_Node_node_w" ) ;
&sub_open ( "link scope", "Cou_M_Node_link_w" ) ;
&sub_open ( "All Routers", "Cou_M_AllRoutes_w" ) ;
&sub_open ( "node scope", "Cou_M_Routes_node_w" ) ;
&sub_open ( "link scope", "Cou_M_Routes_link_w" ) ;
&sub_open ( "site scope", "Cou_M_Routes_site_w" ) ;
&sub_open ( "All PIM Routers", "Cou_M_AllPRoutes_w" ) ;
&sub_open ( "node scope", "Cou_M_PRoutes_node_w" ) ;
&sub_open ( "link scope", "Cou_M_PRoutes_link_w" ) ;
&sub_open ( "site scope", "Cou_M_PRoutes_site_w" ) ;
&sub_open ( "Solicited-node", "Cou_M_Solicited_w" ) ;
&sub_open ( "others", "Cou_M_Others_w" ) ;
&sub_open ( "Transient", "Cou_M_trans" ) ;
&sub_open ( "IPv4 Compatible", "Cou_v4_compati" ) ;
&sub_open ( "IPv4 Mapped", "Cou_v4_mapped" ) ;
&sub_open ( "MLD", "ICMPv6_MLD" ) ;
&sub_open ( "MLD Query", "ICMPv6_MLDQuery" ) ;
&sub_open ( "MLD Report", "ICMPv6_MLDReport" ) ;
&sub_open ( "MLD Done", "ICMPv6_MLDDone" ) ;
&sub_open ( "RIPng", "Cou_RIPng" ) ;
# ICMP ERROR --------------------------------------------------------------
&sub_open ( "Destination Unreachable", "ICMPv6_DestinationUnreachable" ) ;
&sub_open ( "No Route to Destination", "ICMPv6_DesUnr_NoRo" ) ;
&sub_open ( "Administratively Prohibited", "ICMPv6_DesUnr_AP" ) ;
&sub_open ( "Address Unreachable", "ICMPv6_DesUnr_PU" ) ;
&sub_open ( "Port Unreachable", "ICMPv6_DesUnr_PT" ) ;
&sub_open ( "Packet Too Big", "ICMPv6_PacketTooBig" ) ;
&sub_open ( "Time Exceed", "ICMPv6_TimeExceeded" ) ;
&sub_open ( "HOP Limit", "ICMPv6_TimeExceeded_H" ) ;
&sub_open ( "Fragment Reassembly", "ICMPv6_TimeExceeded_F" ) ;
&sub_open ( "Parameter Problem", "ICMPv6_ParameterProblem" ) ;
&sub_open ( "Errornous Header", "ICMPv6_ParameterProblem_E" ) ;
&sub_open ( "Unrecognized NextHeader", "ICMPv6_ParameterProblem_N" ) ;
&sub_open ( "Unrecognized IPv6 Option", "ICMPv6_ParameterProblem_I" ) ;
&sub_open ( "Unrecognized ICMP", "Err_ICMPv6_Unrecognize" ) ;
&sub_open ( "<B>Redirect Packets</B>", "ICMPv6_Redirect" ) ;
&sub_open ( "Target IP = Destination IP", "ICMPv6_Redirect_DIP" ) ;
&sub_open ( "Target IP = Link-local IP", "ICMPv6_Redirect_LIP" ) ;
# Etc ERROR ---------------------------------------------------------------
&sub_open ( "Unknown Frame", "Err_Ether" ) ;
&sub_open ( "Header Value Error", "Err_Header_value" ) ;
&sub_open ( "TCP Checksum Error", "Err_TCP_checksum" ) ;
&sub_open ( "UDP Checksum Error", "Err_UDP_checksum" ) ;
&sub_open ( "ICMP Checksum Error", "Err_ICMP_checksum" ) ;
&sub_open ( "Packet Too Big and MTU < 1280 octets",
	"Err_ICMPv6_PacketTooBig" ) ;
&sub_open ( "Loopback", "Err_LoopBack" ) ;
&sub_open ( "Multicast", "Err_Multicast" ) ;
&sub_open ( "Source/Destination Address Mismatch", "Err_SDmismatch" ) ;
&sub_open ( "HOP-by-HOP not First Extension", "Err_HopByHop" ) ;
&sub_open ( "HOP-by-HOP Extension Appear > 1 times", "Err_HopByHop_2t" ) ;
&sub_open ( "Destination Extension Appear > 1 times", "Err_Destination" ) ;
&sub_open ( "Jumbo Payload Length <= 65,535", "Err_JumboPayloadLength" ) ;
&sub_open ( "IPv6 Payload Length != Zero", "Err_v6PayloadLength" ) ;
&sub_open ( "Length field of UDP Header != Zero", "Err_UDPlength_woJP" ) ;
&sub_open ( "IPv6 Header Length Zero without Jumbo Payload option",
	"Err_PayloadLength" ) ;
&sub_open ( "UDP Length Zero without Jumbo Payload option",
	"Err_UDPlength_JP" ) ;
&sub_open ( "Fragment + Jumbo Payload option", "Err_Frag_Jumbo" ) ;
&sub_open ( "Fragment Packet Alignment Violation", "Err_Frag_Aligment" ) ;
&sub_open ( "Routing Header Check", "Err_RH_Multicast" ) ;
&sub_open ( "RS Hop Limit != 255", "Cou_RS_Hop_Limit" ) ;
&sub_open ( "RA Hop Limit != 255", "Cou_RA_Hop_Limit" ) ;
&sub_open ( "NS Hop Limit != 255", "Cou_NS_Hop_Limit" ) ;
&sub_open ( "NA Hop Limit != 255", "Cou_NA_Hop_Limit" ) ;
&sub_open ( "Redirect HOP Limit != 255", "Err_ICMPv6_Redirect_HL" ) ;
&sub_open ( "Redirect Target != Destination && Redirect Target != Link-local",
	"Err_ICMPv6_Redirect_DL" ) ;

############################
######## Main Loop #########
############################
while(<>){
#	print "$_\n" ;
	if(/^desc:/) {
		chop ;
		# print "$_\n" ;
		$Desc_old = $Desc ;
		$Desc = $_ ;
	}
# Frame_Ether -------------------------------------------------------------
	if(/:Frame_Ether/) {
		if( $Mod_IP == 0 ){
			$Cou_Other++ ;
			&sub_list( "Cou_Other", $Desc_old ) ;
		}
		if( ( $Mod_PayloadZero == 1 ) && ( $Mod_JumboPayload == 0 ) ){
			$Err_PayloadLength++ ;
			&sub_list( "Err_PayloadLength", $Desc_old ) ;
		}
		if( ( $Mod_SDmismatch == 1 ) && ( $Mod_ICMPv6_Redirect == 0 ) ){
			$Err_SDmismatch++ ;
			&sub_list( "Err_SDmismatch", $Desc_old ) ;
		}
		$Mod_Ether = 0 ;
		$Mod_IP = 0 ;
		$Mod_IPv6 = 0 ;
		$Mod_Fragment = 0 ;
		$Mod_JumboPayload = 0 ;
		$Mod_ExtHdr = 0 ;
		$Mod_HopByHop = 0 ;
		$Mod_Destination = 0 ;
		$Mod_ICMPv6 = 0 ;
		$Mod_ICMPv6_RS = 0 ;
		$Mod_ICMPv6_RA = 0 ;
		$Mod_ICMPv6_NA = 0 ;
		$Mod_ICMPv6_Redirect = 0 ;
		$Mod_ICMPv6_PacketTooBig = 0 ;
		$Mod_ICMPv6_DestinationUnreachable = 0 ;
		$Mod_ICMPv6_ParameterProblem = 0 ;
		$Mod_ICMPv6_TimeExceeded = 0 ;
		$Mod_TCP = 0 ;
		$Mod_UDP = 0 ;
		$Mod_PayloadZero = 0 ;
		$Mod_SDmismatch = 0 ;
		$Var_DstAdr = 0 ;
		$Var_PayloadLength = 0 ;
		$Var_HopLimit = 0 ;
		$Var_MFlag = 0 ;
		$Var_Payload = 0 ;
		$Cou_TotalPkt++ ;
		next ;
	}
# Hdr_Ether -------------------------------------------------------------
	if(/ Hdr_Ether/) {
		$Mod_Ether = 1 ;
		next ;
	}
# Header ------------------------------------------------------------------
	if(/ Hdr_IPv4/) {
		if( $Mod_IP == 4 ){
			$Cou_v4ov4++ ;
			&sub_list( "Cou_v4ov4", $Desc ) ;
			next ;
		}
		if( $Mod_IP == 6 ){
			$Cou_v4ov6++ ;
			&sub_list( "Cou_v4ov6", $Desc ) ;
			next ;
		}
		$Hdr_IPv4++ ;
		&sub_list( "Hdr_IPv4", $Desc ) ;

		$Mod_IP = 4 ;
		next ;
	}
	if(/ Hdr_IPv6/) {
		@pairs = split(/:/, $_) ;
		# print "$pairs[2]\n" ;
		$tmpstr = $pairs[2] ;
		@pairs = split(/\)/, $tmpstr) ;
		# print "$pairs[0]\n" ;
		if( $pairs[0] != 40 ) {
			$Err_Header_value++ ;
			&sub_list( "Err_Header_value", $Desc ) ;
		}

		if( $Mod_IP == 4 ){
			$Cou_v6ov4++ ;
			&sub_list( "Cou_v6ov4", $Desc ) ;
			next ;
		}
		if( $Mod_IP == 6 ){
			$Cou_v6ov6++ ;
			&sub_list( "Cou_v6ov6", $Desc ) ;
			next ;
		}
		$Hdr_IPv6++ ;
		&sub_list( "Hdr_IPv6", $Desc ) ;

		$Mod_IP = 6 ;
		$Mod_IPv6 = 1 ;
		next ;
	}
# Header object -----------------------------------------------------------
	if(/ Type                             = /) {
		if( $Mod_Ether != 0 ){
			@pairs = split(/=/, $_) ;
#			(TBD)
#			print "$pairs[1]\n" ;
#			if( $pairs[1] != 34525 ) {
#				$Err_Ether++ ;
#				&sub_list( "Err_Ether", $Desc ) ;
#			}
			$Mod_Ether = 0 ;
		}
		next ;
	}
	if(/ PayloadLength                    = /) {
		@pairs = split(/=/, $_) ;
		# print "$pairs[1]\n" ;
		$Var_PayloadLength = $pairs[1] ;
		if( $Var_PayloadLength == 0 ) {
			$Mod_PayloadZero = 1 ;
		}
		next ;
	}
	if(/ HopLimit/) {
		@pairs = split(/=/, $_) ;
		# print "$pairs[1]\n" ;
		$Var_HopLimit = $pairs[1] ;
		next ;
	}
# ExtHdr ------------------------------------------------------------------
	if(/ Hdr_HopByHop/) {
		$Hdr_HopByHop++ ;
		&sub_list( "Hdr_HopByHop", $Desc ) ;
		if( $Mod_ExtHdr != 0 ){
			$Err_HopByHop++ ;
			&sub_list( "Err_HopByHop", $Desc ) ;
		}
		if( $Mod_HopByHop != 0 ){
			$Err_HopByHop_2t++ ;
			&sub_list( "Err_HopByHop_2t", $Desc ) ;
		}
		$Mod_ExtHdr++ ;
		$Mod_HopByHop = 1 ;
		next ;
	}
	if(/ Hdr_Destination/) {
		if( $Mod_Destination != 0 ){
			$Err_Destination++ ;
			&sub_list( "Err_Destination", $Desc ) ;
		}
		$Hdr_Destination++ ;
		&sub_list( "Hdr_Destination", $Desc ) ;
		$Mod_ExtHdr++ ;
		$Mod_Destination = 1 ;
		next ;
	}
	if(/ Hdr_Routing/) {
		$Hdr_Routing++ ;
		&sub_list( "Hdr_Routing", $Desc ) ;
		if( $Var_DstAdr == 2 ) {
			$Err_RH_Multicast++ ;
			&sub_list( "Err_RH_Multicast", $Desc ) ;
		}
		$Mod_ExtHdr++ ;
		next ;
	}
	if(/ Hdr_Fragment/) {
		$Hdr_Fragment++ ;
		&sub_list( "Hdr_Fragment", $Desc ) ;
		$Mod_Fragment = 1 ;
		if( $Mod_JumboPayload != 0 ) {
			$Err_Frag_Jumbo++ ;
			&sub_list( "Err_Frag_Jumbo", $Desc ) ;
		}
		$Mod_ExtHdr++ ;
		next ;
	}
	if(/ MFlag/) {
		@pairs = split(/=/, $_) ;
		# print "$pairs[1]\n" ;
		$Var_MFlag = $pairs[1] ;
		next ;
	}
	if(/ Payload                         \(length:/) {
		if( $Var_MFlag == 1 ){
			$Var_MFlag = 0 ;
			@pairs = split(/:/, $_) ;
			# print "$pairs[2]\n" ;
			$tmpstr = $pairs[2] ;
			@pairs = split(/\)/, $tmpstr) ;
			# print "$pairs[0]\n" ;
			$Var_Payload = $pairs[0] ;
			if( ( $Var_Payload % 8 ) != 0 ) {
				$Err_Frag_Aligment++ ;
				&sub_list( "Err_Frag_Aligment", $Desc ) ;
				next ;
			}
		}
	}
	if(/ Hdr_AH/) {
		$Hdr_AH++ ;
		&sub_list( "Hdr_AH", $pairs[1], $Desc ) ;
		next ;
	}
	if(/ Hdr_ESP/) {
		$Hdr_ESP++ ;
		&sub_list( "Hdr_ESP", $Desc ) ;
		next ;
	}
# Extension Header Option -------------------------------------------------
	if(/ Opt_JumboPayload/) {
		$Opt_JumboPayload++ ;
		&sub_list( "Opt_JumboPayload", $Desc ) ;
		$Mod_JumboPayload = 1 ;
		if( $Mod_Fragment != 0 ) {
			$Err_Frag_Jumbo++ ;
			&sub_list( "Err_Frag_Jumbo", $Desc ) ;
		}
		if( $Var_PayloadLength != 0 ) {
			$Err_v6PayloadLength++ ;
			&sub_list( "Err_v6PayloadLength", $Desc ) ;
		}
		next ;
	}
	if(/ JumboPayloadLength/) {
		@pairs = split(/=/, $_) ;
		# print "$pairs[1]\n" ;
		if( $pairs[1] <= 65535 ) {
			$Err_JumboPayloadLength++ ;
			&sub_list( "Err_JumboPayloadLength", $Desc ) ;
		}
		next ;
	}
# Source Address ----------------------------------------------------------
	if( ( / SourceAddress                    = / ) && ( $Mod_IP == 6 ) ){
		@pairs = split(/=/, $_) ;
		# print "$pairs[1]\n" ;
		$SourceAddress = $pairs[1] ;
		chop $SourceAddress ;
		if(/ SourceAddress                    = ::1/) {
			$Err_LoopBack++ ;
			&sub_list( "Err_LoopBack", $Desc ) ;
		}
		if(/ SourceAddress                    = ff/) {
			$Err_Multicast++ ;
			&sub_list( "Err_Multicast", $Desc ) ;
		}
		next ;
	}
# Target Address ----------------------------------------------------------
	if( ( / TargetAddress                    = / ) && ( $Mod_IP == 6 ) ){
		if( $Mod_ICMPv6_Redirect == 1 ){
			@pairs = split(/=/, $_) ;
			# print "$pairs[1]\n" ;
			$Rdirect_TargetAddress = $pairs[1] ;
			chop $Rdirect_TargetAddress ;
			if( $Rdirect_TargetAddress =~ / fe80/ ){
				$ICMPv6_Redirect_LIP++ ;
				&sub_list( "ICMPv6_Redirect_LIP", $Desc ) ;
			}
		}
		if( $Mod_ICMPv6_NA == 1 ){
			if( $_ =~ /ff02/ ){
				$ICMPv6_NA_ToDAD++ ;
				&sub_list( "ICMPv6_NA_ToDAD", $Desc ) ;
			} else {
				$ICMPv6_NA_ToUni++ ;
				&sub_list( "ICMPv6_NA_ToUni", $Desc ) ;
			}
		}
		next ;
	}
# Destinationt Address ----------------------------------------------------
	if( ( / DestinationAddress               = / ) && ( $Mod_IP == 6 ) ){
		@pairs = split(/=/, $_) ;
		# print "$pairs[1]\n" ;
		$DestinationAddress = $pairs[1] ;
		chop $DestinationAddress ;
		if( $Mod_ICMPv6_Redirect == 1 ){
			if( $Rdirect_TargetAddress =~ $DestinationAddress ){
				$ICMPv6_Redirect_DIP++ ;
				&sub_list( "ICMPv6_Redirect_DIP", $Desc ) ;
			}
			if( ( $Rdirect_TargetAddress !~ $DestinationAddress ) &&
				( $Rdirect_TargetAddress !~ /fe80/ ) ) {
				$Err_ICMPv6_Redirect_DL++ ;
				&sub_list( "Err_ICMPv6_Redirect_DL", $Desc ) ;
			}
		}
		if( $Mod_IPv6 == 1 ){
			$Mod_IPv6 = 0 ;
		} else {
			# if not Hdr_IPv6 then exit.
			next ;
		}
		# Unicast
		if( $DestinationAddress eq " ::1" ){
			$Cou_U_LoopBack++ ;
			$Cou_Uni++ ;
			&sub_list( "Cou_U_LoopBack", $Desc ) ;
			&sub_list( "Cou_Uni", $Desc ) ;
			$Var_DstAdr = 1 ;
			next ;
		}
		if( $DestinationAddress =~ / fe80:/ ){
			$Cou_U_LinkLocal++ ;
			$Cou_Uni++ ;
			&sub_list( "Cou_U_LinkLocal", $Desc ) ;
			&sub_list( "Cou_Uni", $Desc ) ;
			$Var_DstAdr = 1 ;
			if( ( $SourceAddress =~ / fec0:/ ) || ( $SourceAddress =~ / 3ffe:/ ) ){
				$Mod_SDmismatch = 1 ;
			}
			next ;
		}
		if( $DestinationAddress =~ / fec0:/ ){
			$Cou_U_SiteLocal++ ;
			$Cou_Uni++ ;
			&sub_list( "Cou_U_SiteLocal", $Desc ) ;
			&sub_list( "Cou_Uni", $Desc ) ;
			$Var_DstAdr = 1 ;
			if( ( $SourceAddress =~ / fe80:/ ) || ( $SourceAddress =~ / 3ffe:/ ) ){
				$Mod_SDmismatch = 1 ;
			}
			next ;
		}
		if( $DestinationAddress =~ / 3ffe:/ ){
			$Cou_U_Global++ ;
			$Cou_Uni++ ;
			&sub_list( "Cou_U_Global", $Desc ) ;
			&sub_list( "Cou_Uni", $Desc ) ;
			$Var_DstAdr = 1 ;
			if( ( $SourceAddress =~ / fe80:/ ) || ( $SourceAddress =~ / fec0:/ ) ){
				$Mod_SDmismatch = 1 ;
			}
			next ;
		}
		# Multicast
		if(/ DestinationAddress               = ff/) {     # Multicast GLOBAL
			$Cou_M_general++ ;
			&sub_list( "Cou_M_general", $Desc ) ;
			$Var_DstAdr = 2 ;
			# Reserved
			if( $DestinationAddress =~ / ff[0-1][0-9a-f]::$/ ){
				$Cou_M_reserved++ ;
				&sub_list( "Cou_M_reserved", $Desc ) ;
				next ;
			}
			# Well-known
			if( $DestinationAddress =~ / ff0/ ){
				$Cou_M_well++ ;
				&sub_list( "Cou_M_well", $Desc ) ;
				# All nodes
				if( $DestinationAddress eq " ff01::1" ){
					$Cou_M_Node_node_w++ ;
					$Cou_M_Node_all_w++ ;
					&sub_list( "Cou_M_Node_node_w", $Desc ) ;
					&sub_list( "Cou_M_Node_all_w", $Desc ) ;
					next ;
				}
				if( $DestinationAddress eq " ff02::1" ){
					$Cou_M_Node_link_w++ ;
					$Cou_M_Node_all_w++ ;
					&sub_list( "Cou_M_Node_link_w", $Desc ) ;
					&sub_list( "Cou_M_Node_all_w", $Desc ) ;
					next ;
				}
				# All Routers
				if( $DestinationAddress eq " ff01::2" ){
					$Cou_M_Routes_node_w++ ;
					$Cou_M_AllRoutes_w++ ;
					&sub_list( "Cou_M_Routes_node_w", $Desc ) ;
					&sub_list( "Cou_M_AllRoutes_w", $Desc ) ;
					next ;
				}
				if( $DestinationAddress eq " ff02::2" ){
					$Cou_M_Routes_link_w++ ;
					$Cou_M_AllRoutes_w++ ;
					&sub_list( "Cou_M_Routes_link_w", $Desc ) ;
					&sub_list( "Cou_M_AllRoutes_w", $Desc ) ;
					next ;
				}
				if( $DestinationAddress eq " ff05::2" ){
					$Cou_M_Routes_site_w++ ;
					$Cou_M_AllRoutes_w++ ;
					&sub_list( "Cou_M_Routes_site_w", $Desc ) ;
					&sub_list( "Cou_M_AllRoutes_w", $Desc ) ;
					next ;
				}
				# All PIM Routers
				if( $DestinationAddress eq " ff01::d" ){
					$Cou_M_PRoutes_node_w++ ;
					$Cou_M_AllPRoutes_w++ ;
					&sub_list( "Cou_M_PRoutes_node_w", $Desc ) ;
					&sub_list( "Cou_M_AllPRoutes_w", $Desc ) ;
					next ;
				}
				if( $DestinationAddress eq " ff02::d" ){
					$Cou_M_PRoutes_link_w++ ;
					$Cou_M_AllPRoutes_w++ ;
					&sub_list( "Cou_M_PRoutes_link_w", $Desc ) ;
					&sub_list( "Cou_M_AllPRoutes_w", $Desc ) ;
					next ;
				}
				if( $DestinationAddress eq " ff05::d" ){
					$Cou_M_PRoutes_site_w++ ;
					$Cou_M_AllPRoutes_w++ ;
					&sub_list( "Cou_M_PRoutes_site_w", $Desc ) ;
					&sub_list( "Cou_M_AllPRoutes_w", $Desc ) ;
					next ;
				}
				# Solicited-node
				if( $DestinationAddress =~ / ff02::1:ff/ ){
					$Cou_M_Solicited_w++ ;
					&sub_list( "Cou_M_Solicited_w", $Desc ) ;
					next ;
				}
				# Others
				$Cou_M_Others_w++ ;
				&sub_list( "Cou_M_Others_w", $Desc ) ;
				next ;
			}
			# Transient
			if( $DestinationAddress =~ / ff1/ ){
				$Cou_M_trans++ ;
				&sub_list( "Cou_M_trans", $Desc ) ;
			}
			next ;
		}
#		IPv4 Compatible(TBD)
#		if(/ DestinationAddress               = ::ffff:/) {
#			$Cou_v4_compati++ ;
#			next ;
#		}
		# IPv4 Mapped
		if(/ DestinationAddress               = ::ffff:/) {
			$Cou_v4_mapped++ ;
			&sub_list( "Cou_v4_mapped", $Desc ) ;
			next ;
		}
	}
# ICMP --------------------------------------------------------------------
	if(/ ICMPv6_NS/) {
		$ICMPv6_NS++ ;
		&sub_list( "ICMPv6_NS", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		if( $DestinationAddress =~ /ff02/ ){
			$ICMPv6_NS_ToSo++ ;
			&sub_list( "ICMPv6_NS_ToSo", $Desc ) ;
			if( $SourceAddress eq " ::" ){
				$ICMPv6_NS_FrDAD++ ;
				&sub_list( "ICMPv6_NS_FrDAD", $Desc ) ;
			} else {
				$ICMPv6_NS_FrUni++ ;
				&sub_list( "ICMPv6_NS_FrUni", $Desc ) ;
			}
		} else {
			$ICMPv6_NS_ToUni++ ;
			&sub_list( "ICMPv6_NS_ToUni", $Desc ) ;
		}
		if( $Var_HopLimit != 255 ) {
			$Cou_NS_Hop_Limit++ ;
			&sub_list( "Cou_NS_Hop_Limit", $Desc ) ;
		}
		next ;
	}
	if(/ ICMPv6_NA/) {
		$ICMPv6_NA++ ;
		&sub_list( "ICMPv6_NA", $Desc ) ;

		$Mod_ICMPv6 = 1 ;
		$Mod_ICMPv6_NA = 1 ;
		if( $Var_HopLimit != 255 ) {
			$Cou_NA_Hop_Limit++ ;
			&sub_list( "Cou_NA_Hop_Limit", $Desc ) ;
		}
		next ;
	}
	if(/ ICMPv6_RS/) {
		$ICMPv6_RS++ ;
		&sub_list( "ICMPv6_RS", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		$Mod_ICMPv6_RS = 1 ;
		if( $Var_HopLimit != 255 ) {
			$Cou_RS_Hop_Limit++ ;
			&sub_list( "Cou_RS_Hop_Limit", $Desc ) ;
		}
		next ;
	}
	if(/ ICMPv6_RA/) {
		$ICMPv6_RA++ ;
		&sub_list( "ICMPv6_RA", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		$Mod_ICMPv6_RA = 1 ;
		if( $Var_HopLimit != 255 ) {
			$Cou_RA_Hop_Limit++ ;
			&sub_list( "Cou_RA_Hop_Limit", $Desc ) ;
		}
		next ;
	}
	if(/ ICMPv6_Redirect/) {
		$ICMPv6_Redirect++ ;
		&sub_list( "ICMPv6_Redirect", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		$Mod_ICMPv6_Redirect = 1 ;
		if( $Var_HopLimit != 255 ) {
			$Err_ICMPv6_Redirect_HL++ ;
			&sub_list( "Err_ICMPv6_Redirect_HL", $Desc ) ;
		}
		next ;
	}
	if(/ ICMPv6_MLDQuery/) {
		$ICMPv6_MLDQuery++ ;
		$ICMPv6_MLD++ ;
		&sub_list( "ICMPv6_MLDQuery", $Desc ) ;
		&sub_list( "ICMPv6_MLD", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		next ;
	}
	if(/ ICMPv6_MLDReport/) {
		$ICMPv6_MLDReport++ ;
		$ICMPv6_MLD++ ;
		&sub_list( "ICMPv6_MLDReport", $Desc ) ;
		&sub_list( "ICMPv6_MLD", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		next ;
	}
	if(/ ICMPv6_MLDDone/) {
		$ICMPv6_MLDDone++ ;
		$ICMPv6_MLD++ ;
		&sub_list( "ICMPv6_MLDDone", $Desc ) ;
		&sub_list( "ICMPv6_MLD", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		next ;
	}
# ICMP ERROR --------------------------------------------------------------
	if(/ ICMPv6_DestinationUnreachable/) {
		$ICMPv6_DestinationUnreachable++ ;
		&sub_list( "ICMPv6_DestinationUnreachable", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		$Mod_ICMPv6_DestinationUnreachable = 1 ;
		next ;
	}
	if(/ ICMPv6_PacketTooBig/) {
		$ICMPv6_PacketTooBig++ ;
		&sub_list( "ICMPv6_PacketTooBig", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		$Mod_ICMPv6_PacketTooBig = 1 ;
		next ;
	}
	if(/ ICMPv6_TimeExceeded/) {
		$ICMPv6_TimeExceeded++ ;
		&sub_list( "ICMPv6_TimeExceeded", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		$Mod_ICMPv6_TimeExceeded = 1 ;
		next ;
	}
	if(/ ICMPv6_ParameterProblem/) {
		$ICMPv6_ParameterProblem++ ;
		&sub_list( "ICMPv6_ParameterProblem", $Desc ) ;
		$Mod_ICMPv6 = 1 ;
		$Mod_ICMPv6_ParameterProblem = 1 ;
	}
# Etc ERROR ---------------------------------------------------------------
	if(/ Code                             = /) {
		@pairs = split(/=/, $_) ;
		# print "$pairs[1]\n" ;
		$tmpnum = $pairs[1] ;
		if( $Mod_ICMPv6_DestinationUnreachable == 1 ){
			$Mod_ICMPv6_DestinationUnreachable = 0 ;
			if( $tmpnum == 0 ) {
				$ICMPv6_DesUnr_NoRo++ ;
				&sub_list( "ICMPv6_DesUnr_NoRo", $Desc ) ;
				next ;
			}
			if( $tmpnum == 1 ) {
				$ICMPv6_DesUnr_AP++ ;
				&sub_list( "ICMPv6_DesUnr_AP", $Desc ) ;
				next ;
			}
			if( $tmpnum == 3 ) {
				$ICMPv6_DesUnr_PU++ ;
				&sub_list( "ICMPv6_DesUnr_PU", $Desc ) ;
				next ;
			}
			if( $tmpnum == 4 ) {
				$ICMPv6_DesUnr_PT++ ;
				&sub_list( "ICMPv6_DesUnr_PT", $Desc ) ;
				next ;
			}
			$Err_ICMPv6_Unrecognize++ ;
			&sub_list( "Err_ICMPv6_Unrecognize", $Desc ) ;
		}
		if( $Mod_ICMPv6_TimeExceeded == 1 ){
			$Mod_ICMPv6_TimeExceeded = 0 ;
			if( $tmpnum == 0 ) {
				$ICMPv6_TimeExceeded_H++ ;
				&sub_list( "ICMPv6_TimeExceeded_H", $Desc ) ;
				next ;
			}
			if( $tmpnum == 1 ) {
				$ICMPv6_TimeExceeded_F++ ;
				&sub_list( "ICMPv6_TimeExceeded_F", $Desc ) ;
				next ;
			}
			$Err_ICMPv6_Unrecognize++ ;
			&sub_list( "Err_ICMPv6_Unrecognize", $Desc ) ;
		}
		if( $Mod_ICMPv6_ParameterProblem == 1 ){
			$Mod_ICMPv6_ParameterProblem = 0 ;
			if( $tmpnum == 0 ) {
				$ICMPv6_ParameterProblem_E++ ;
				&sub_list( "ICMPv6_ParameterProblem_E", $Desc ) ;
				next ;
			}
			if( $tmpnum == 1 ) {
				$ICMPv6_ParameterProblem_N++ ;
				&sub_list( "ICMPv6_ParameterProblem_N", $Desc ) ;
				next ;
			}
			if( $tmpnum == 2 ) {
				$ICMPv6_ParameterProblem_I++ ;
				&sub_list( "ICMPv6_ParameterProblem_I", $Desc ) ;
				next ;
			}
			$Err_ICMPv6_Unrecognize++ ;
			&sub_list( "Err_ICMPv6_Unrecognize", $Desc ) ;
		}
		next ;
	}
	if(/ MTU                              = /) {
		if( $Mod_ICMPv6_PacketTooBig == 1 ){
			$Mod_ICMPv6_PacketTooBig = 0 ;
			@pairs = split(/=/, $_) ;
			# print "$pairs[1]\n" ;
			if( $pairs[1] < 1280 ) {
				$Err_ICMPv6_PacketTooBig++ ;
				&sub_list( "Err_ICMPv6_PacketTooBig", $Desc ) ;
			}
		}
		next ;
	}
# TCP & UDP ---------------------------------------------------------------
	if(/ Hdr_UDP/) {
		$Mod_UDP = 1 ;
		next ;
	}
	if(/ Hdr_TCP/) {
		$Mod_TCP = 1 ;
		next ;
	}
# etc ---------------------------------------------------------------------
	if(/ SourcePort                       = 521/) {
		$Cou_RIPng++ ;
		&sub_list( "Cou_RIPng", $Desc ) ;
		next ;
	}
	if(/ Checksum                         = /) {
		@pairs = split(/=/, $_) ;
		# print "$pairs[1]\n" ;
		$tmpstr = $pairs[1] ;
		@pairs = split(/ /, $tmpstr) ;
		# print "$pairs[1]\n" ;
		# print "$pairs[2]\n" ;
		if( $pairs[2] =~ $pairs[1] ){
			$Mod_UDP = 0 ;
			$Mod_TCP = 0 ;
			$Mod_ICMPv6 = 0 ;
			next ;
		}
		if( $Mod_UDP == 1 ) {
			$Mod_UDP = 0 ;
			$Err_UDP_checksum++ ;
			&sub_list( "Err_UDP_checksum", $Desc ) ;
		}
		if( $Mod_TCP == 1 ) {
			$Mod_TCP = 0 ;
			$Err_TCP_checksum++ ;
			&sub_list( "Err_TCP_checksum", $Desc ) ;
		}
		if( $Mod_ICMPv6 == 1 ) {
			$Mod_ICMPv6 = 0 ;
			$Err_ICMP_checksum++ ;
			&sub_list( "Err_ICMP_checksum", $Desc ) ;
		}
		next ;
	}
	if(/ Length                           = /) {
		if( $Mod_UDP == 1 ) {
			$Mod_ICMPv6_PacketTooBig = 0 ;
			@pairs = split(/=/, $_) ;
			# print "$pairs[1]\n" ;
			if( ( $pairs[1] == 0 ) && ( $Mod_JumboPayload != 1 ) ) {
				$Err_UDPlength_JP++ ;
				&sub_list( "Err_UDPlength_JP", $Desc ) ;
			}
			if( ( $pairs[1] != 0 ) && ( $Mod_JumboPayload != 0 ) ) {
				$Err_UDPlength_woJP++ ;
				&sub_list( "Err_UDPlength_woJP", $Desc ) ;
			}
		}
		next ;
	}
}

############################
######## count #############
############################
#$Cou_Other = $Cou_TotalPkt - $Hdr_IPv6 - $Hdr_IPv4 ;
$Cou_ExtHdr = $Hdr_HopByHop + $Hdr_Routing + $Hdr_Fragment + $Hdr_Destination
	+ $Hdr_AH + $Hdr_ESP ;
$Cou_Incorrect = $Err_TCP_checksum + $Err_UDP_checksum + $Err_ICMP_checksum ;
$Cou_Unexpect = $Err_LoopBack + $Err_Multicast + $Err_SDmismatch ;

############################
######## print #############
############################
# for cgi
#print "Content-type: text/html\n\n";
print "<HTML>\n" ;
print "<HEAD>\n" ;
print "<TITLE>\n" ;
print "Interoprability Test Result Statistics\n" ;
print "</TITLE>\n" ;
print "</HEAD>\n" ;
print "<BODY BGCOLOR=\"#FFFFFF\">\n" ;
print "<H2>Interoprability Test Result Statistics</H2>\n" ;
#print "<TABLE BORDER=1 WIDTH=500>\n" ;
print "<TABLE BORDER=1>\n" ;
print "<TR>\n" ;
print "  <TD WIDTH=20>\n" ;
print "  <TD WIDTH=15>\n" ;
print "  <TD WIDTH=10>\n" ;
print "  <TD WIDTH=5>\n" ;
print "  <TD WIDTH=5>\n" ;
print "  <TD WIDTH=5>\n" ;
print "  <TD WIDTH=5>\n" ;
print "</TR>\n" ;
print "<TR>\n" ;
print "<TD ALIGN=center COLSPAN=5><B>ITEM</B>\n" ;
print "<TD ALIGN=left><B>count</B></A>\n" ;
print "<TD ALIGN=left><B>mark</B></A>\n" ;
print "</TR>\n" ;
&sub_print ( 0, "<B>Total Packets</B>", "-1", $Cou_TotalPkt, 0 ) ;
# Header ------------------------------------------------------------------
&sub_print ( 1, "IPv6", "Hdr_IPv6", $Hdr_IPv6, 0 ) ;
&sub_print ( 1, "IPv4", "Hdr_IPv4", $Hdr_IPv4, 0 ) ;
&sub_print ( 1, "Other", "Cou_Other", $Cou_Other, 0 ) ;
# Tunnel ------------------------------------------------------------------
print "<TR>\n</TR>\n" ;
&sub_print ( -2, "<B>Tunnel</B>", "-1", -1, 0 ) ;
&sub_print ( 1, "IPv6 over IPv6", "Cou_v6ov6", $Cou_v6ov6, 0 ) ;
&sub_print ( 1, "IPv4 over IPv6", "Cou_v4ov6", $Cou_v4ov6, 0 ) ;
&sub_print ( 1, "IPv6 over IPv4", "Cou_v6ov4", $Cou_v6ov4, 0 ) ;
&sub_print ( 1, "IPv4 over IPv4", "Cou_v4ov4", $Cou_v4ov4, 0 ) ;
&sub_print ( 2, "IPv4 Compatible", "Cou_v4_compati", $Cou_v4_compati, 2 ) ;
&sub_print ( 2, "IPv4 Mapped", "Cou_v4_mapped", $Cou_v4_mapped, 2 ) ;
# ExtHdr ------------------------------------------------------------------
print "<TR>\n</TR>\n" ;
&sub_print ( 0, "<B>IPv6 Extension Headers</B>", "-1", $Cou_ExtHdr, 0 ) ;
&sub_print ( 1, "Hop-by-Hop Options Header", "Hdr_HopByHop", $Hdr_HopByHop,
	0 ) ;
&sub_print ( 1, "Routing Header", "Hdr_Routing", $Hdr_Routing, 0 ) ;
&sub_print ( 1, "Fragment Header", "Hdr_Fragment", $Hdr_Fragment, 0 ) ;
&sub_print ( 1, "Destination Options Header", "Hdr_Destination",
	$Hdr_Destination, 0 ) ;
&sub_print ( 1, "AH Header", "Hdr_AH", $Hdr_AH, 0 ) ;
&sub_print ( 1, "ESP Header", "Hdr_ESP", $Hdr_ESP, 0 ) ;
print "<TR>\n</TR>\n" ;
&sub_print ( 1, "HOP-by-HOP not First Extension", "Err_HopByHop",
	$Err_HopByHop, 2 ) ;
&sub_print ( 1, "HOP-by-HOP Extension Appear > 1 times", "Err_HopByHop_2t",
	$Err_HopByHop_2t, 2 ) ;
&sub_print ( 1, "Routing Header Check", "Err_RH_Multicast", $Err_RH_Multicast,
	2 ) ;
&sub_print ( 2, "Multicast address exist", "Err_RH_Multicast", 
	$Err_RH_Multicast, 2 ) ;
&sub_print ( 2, "Fragment + Jumbo Payload option", "Err_Frag_Jumbo",
	$Err_Frag_Jumbo, 2 ) ;
&sub_print ( 2, "Fragment Packet Alignment Violation", "Err_Frag_Aligment",
	$Err_Frag_Aligment, 2 ) ;
&sub_print ( 2, "Destination Extension Appear > 1 times", "Err_Destination",
	$Err_Destination, 2 ) ;
print "<TR>\n</TR>\n" ;
# Extension Header Option -------------------------------------------------
&sub_print ( 1, "Jumbo Payload option", "Opt_JumboPayload",
	$Opt_JumboPayload, 0 ) ;
print "<TR>\n</TR>\n" ;
&sub_print ( 2, "Jumbo Payload Length <= 65,535", "Err_JumboPayloadLength",
	$Err_JumboPayloadLength, 2 ) ;
&sub_print ( 2, "IPv6 Payload Length != Zero", "Err_v6PayloadLength",
	$Err_v6PayloadLength, 2 ) ;
&sub_print ( 2, "Length field of UDP Header != Zero", "Err_UDPlength_woJP",
	$Err_UDPlength_woJP, 2 ) ;
&sub_print ( 2, "IPv6 Header Length Zero without Jumbo Payload option",
	"Err_PayloadLength", $Err_PayloadLength, 2 ) ;
&sub_print ( 2, "UDP Length Zero without Jumbo Payload option",
	"Err_UDPlength_JP", $Err_UDPlength_JP, 2 ) ;
print "<TR>\n</TR>\n" ;
# Address -----------------------------------------------------------------
&sub_print ( -2, "<B>Source Address</B>", "-1", -1, 0 ) ;
&sub_print ( 1, "Unexpected SourceAddress Check", "-1", $Cou_Unexpect, 2 ) ;
&sub_print ( 2, "Loopback", "Err_LoopBack", $Err_LoopBack, 2 ) ;
&sub_print ( 2, "Multicast", "Err_Multicast", $Err_Multicast, 2 ) ;
&sub_print ( 2, "Source/Destination Address Mismatch", "Err_SDmismatch",
	$Err_SDmismatch, 2 ) ;
print "<TR>\n</TR>\n" ;
&sub_print ( -2, "<B>Destination Address</B>", "-1", -1, 0 ) ;
&sub_print ( 1, "IPv6 Unicast", "Cou_Uni", $Cou_Uni, 0 ) ;
&sub_print ( 2, "Loop-Back", "Cou_U_LoopBack", $Cou_U_LoopBack, 2 ) ;
&sub_print ( 2, "Link-local", "Cou_U_LinkLocal", $Cou_U_LinkLocal, 0 ) ;
&sub_print ( 2, "Site-local", "Cou_U_SiteLocal", $Cou_U_SiteLocal, 0 ) ;
&sub_print ( 2, "Global", "Cou_U_Global", $Cou_U_Global, 0 ) ;
&sub_print ( 1, "IPv6 Multicast", "Cou_M_general", $Cou_M_general, 0 ) ;
&sub_print ( 2, "Reserved(Not Used)", "Cou_M_reserved", $Cou_M_reserved, 2 ) ;
&sub_print ( 2, "Well-known", "Cou_M_well", $Cou_M_well, 0 ) ;
&sub_print ( 3, "All nodes", "Cou_M_Node_all_w", $Cou_M_Node_all_w, 0 ) ;
&sub_print ( 4, "node scope", "Cou_M_Node_node_w", $Cou_M_Node_node_w, 2 ) ;
&sub_print ( 4, "link scope", "Cou_M_Node_link_w", $Cou_M_Node_link_w, 0 ) ;
&sub_print ( 3, "All Routers", "Cou_M_AllRoutes_w", $Cou_M_AllRoutes_w, 0 ) ;
&sub_print ( 4, "node scope", "Cou_M_Routes_node_w", $Cou_M_Routes_node_w, 2 ) ;
&sub_print ( 4, "link scope", "Cou_M_Routes_link_w", $Cou_M_Routes_link_w, 0 ) ;
&sub_print ( 4, "site scope", "Cou_M_Routes_site_w", $Cou_M_Routes_site_w, 0 ) ;
&sub_print ( 3, "All PIM Routers", "Cou_M_AllPRoutes_w", $Cou_M_AllPRoutes_w,
	0 ) ;
&sub_print ( 4, "node scope", "Cou_M_PRoutes_node_w", $Cou_M_PRoutes_node_w,
	2 ) ;
&sub_print ( 4, "link scope", "Cou_M_PRoutes_link_w", $Cou_M_PRoutes_link_w,
	0 ) ;
&sub_print ( 4, "site scope", "Cou_M_PRoutes_site_w", $Cou_M_PRoutes_site_w,
	2) ;
&sub_print ( 3, "Solicited-node", "Cou_M_Solicited_w", $Cou_M_Solicited_w, 0 ) ;
&sub_print ( 3, "others", "Cou_M_Others_w", $Cou_M_Others_w, 0 ) ;
&sub_print ( 2, "Transient", "Cou_M_trans", $Cou_M_trans, 0 ) ;
&sub_print ( 1, "RIPng", "Cou_RIPng", $Cou_RIPng, 0 ) ;
# ICMP --------------------------------------------------------------------
print "<TR>\n</TR>\n" ;
&sub_print ( -2, "<B>ICMP</B>", "-1", -1, 0 ) ;
&sub_print ( 1, "Neighbor Solicitation", "ICMPv6_NS", $ICMPv6_NS, 0 ) ;
&sub_print ( 2, "To Solicited Address", "ICMPv6_NS_ToSo", $ICMPv6_NS_ToSo, 0 ) ;
&sub_print ( 3, "From Unicast", "ICMPv6_NS_FrUni", $ICMPv6_NS_FrUni, 0 ) ;
&sub_print ( 3, "From Unspecified&lt;DAD&gt;", "ICMPv6_NS_FrDAD",
	$ICMPv6_NS_FrDAD, 1 ) ;
&sub_print ( 2, "To Unicast Address", "ICMPv6_NS_ToUni", $ICMPv6_NS_ToUni, 0 ) ;
&sub_print ( 1, "NS Hop Limit != 255", "Cou_NS_Hop_Limit", $Cou_NS_Hop_Limit,
	2 ) ;
&sub_print ( 1, "Neighbor Advertisement", "ICMPv6_NA", $ICMPv6_NA, 0 ) ;
&sub_print ( 2, "To Unicast", "ICMPv6_NA_ToUni", $ICMPv6_NA_ToUni, 0 ) ;
&sub_print ( 2, "To All-nodes&lt;DAD&gt;", "ICMPv6_NA_ToDAD",
	$ICMPv6_NA_ToDAD, 0 ) ;
&sub_print ( 1, "NA Hop Limit != 255", "Cou_NA_Hop_Limit", $Cou_NA_Hop_Limit,
	2 ) ;
&sub_print ( 1, "Router Solicitation", "ICMPv6_RS", $ICMPv6_RS, 0 ) ;
&sub_print ( 1, "RS Hop Limit != 255", "Cou_RS_Hop_Limit", $Cou_RS_Hop_Limit,
	2 ) ;
&sub_print ( 1, "Router Advertisement", "ICMPv6_RA", $ICMPv6_RA, 0 ) ;
&sub_print ( 1, "RA Hop Limit != 255", "Cou_RA_Hop_Limit", $Cou_RA_Hop_Limit,
	2 ) ;
print "<TR>\n</TR>\n" ;
&sub_print ( 1, "Redirect Packets", "ICMPv6_Redirect",
	$ICMPv6_Redirect, 1 ) ;
&sub_print ( 2, "Target IP = Destination IP", "ICMPv6_Redirect_DIP",
	$ICMPv6_Redirect_DIP, 1 ) ;
&sub_print ( 2, "Target IP = Link-local IP", "ICMPv6_Redirect_LIP",
	$ICMPv6_Redirect_LIP, 1 ) ;
&sub_print ( 1, "Redirect HOP Limit != 255", "Err_ICMPv6_Redirect_HL",
	$Err_ICMPv6_Redirect_HL, 2 ) ;
&sub_print ( 1,
	"Redirect Target != Destination && Redirect Target != Link-local",
	"Err_ICMPv6_Redirect_DL", $Err_ICMPv6_Redirect_DL, 2 ) ;
print "<TR>\n</TR>\n" ;
&sub_print ( 1, "MLD", "ICMPv6_MLD", $ICMPv6_MLD, 0 ) ;
&sub_print ( 2, "MLD Query", "ICMPv6_MLDQuery", $ICMPv6_MLDQuery, 0 ) ;
&sub_print ( 2, "MLD Report", "ICMPv6_MLDReport", $ICMPv6_MLDReport, 0 ) ;
&sub_print ( 2, "MLD Done", "ICMPv6_MLDDone", $ICMPv6_MLDDone, 0 ) ;
# ICMP ERROR --------------------------------------------------------------
print "<TR>\n</TR>\n" ;
&sub_print ( -2, "<B>ICMP ERROR</B>", "-1", 0, 0, 1 ) ;
&sub_print ( 1, "Destination Unreachable", "ICMPv6_DestinationUnreachable",
	$ICMPv6_DestinationUnreachable, 1 ) ;
&sub_print ( 2, "No Route to Destination", "ICMPv6_DesUnr_NoRo",
	$ICMPv6_DesUnr_NoRo, 1 ) ;
&sub_print ( 2, "Administratively Prohibited", "ICMPv6_DesUnr_AP",
	$ICMPv6_DesUnr_AP, 1 ) ;
&sub_print ( 2, "Address Unreachable", "ICMPv6_DesUnr_PU", $ICMPv6_DesUnr_PU,
	1 ) ;
&sub_print ( 2, "Port Unreachable", "ICMPv6_DesUnr_PT", $ICMPv6_DesUnr_PT, 1 ) ;
&sub_print ( 1, "Packet Too Big", "ICMPv6_PacketTooBig",
	$ICMPv6_PacketTooBig, 1 ) ;
&sub_print ( 1, "Time Exceed", "ICMPv6_TimeExceeded", $ICMPv6_TimeExceeded,
	1 ) ;
&sub_print ( 2, "HOP Limit", "ICMPv6_TimeExceeded_H", $ICMPv6_TimeExceeded_H,
	1 ) ;
&sub_print ( 2, "Fragment Reassembly", "ICMPv6_TimeExceeded_F",
	$ICMPv6_TimeExceeded_F, 1 ) ;
&sub_print ( 1, "Parameter Problem", "ICMPv6_ParameterProblem",
	$ICMPv6_ParameterProblem, 1 ) ;
&sub_print ( 2, "Errornous Header", "ICMPv6_ParameterProblem_E",
	$ICMPv6_ParameterProblem_E, 1 ) ;
&sub_print ( 2, "Unrecognized NextHeader", "ICMPv6_ParameterProblem_N",
	$ICMPv6_ParameterProblem_N, 1 ) ;
&sub_print ( 2, "Unrecognized IPv6 Option", "ICMPv6_ParameterProblem_I",
	$ICMPv6_ParameterProblem_I, 1 ) ;
&sub_print ( 1, "Unrecognized ICMP", "Err_ICMPv6_Unrecognize", 
	$Err_ICMPv6_Unrecognize, 1 ) ;
print "<TR>\n</TR>\n" ;
&sub_print ( 1, "Packet Too Big and MTU < 1280 octets",
	"Err_ICMPv6_PacketTooBig", $Err_ICMPv6_PacketTooBig, 2 ) ;
# Etc ERROR ---------------------------------------------------------------
print "<TR>\n</TR>\n" ;
&sub_print ( 0, "<FONT COLOR=\"#FF0000\"><B>Incorrect Packet</B></FONT>",
	"-1", $Cou_Incorrect, 2 ) ;
&sub_print ( 1, "Unknown Frame", "Err_Ether", $Err_Ether, 2 ) ;
&sub_print ( 1, "Header Value Error", "Err_Header_value", $Err_Header_value,
	2 ) ;
&sub_print ( 1, "TCP Checksum Error", "Err_TCP_checksum", $Err_TCP_checksum,
	2 ) ;
&sub_print ( 1, "UDP Checksum Error", "Err_UDP_checksum", $Err_UDP_checksum,
	2 ) ;
&sub_print ( 1, "ICMP Checksum Error", "Err_ICMP_checksum", $Err_ICMP_checksum,
	2 ) ;
print "</TABLE>\n" ;
print "<H5 ALIGN=left>\n" ;
print "input file : $inputfile<BR>\n" ;
print "Tool Serial : 2000.02.24 Version 1.01\n" ;
print "</H5>\n" ;
print '</PRE>' ;
print "</BODY>\n" ;
print "</HTML>\n" ;

############################
######## close file ########
############################
&sub_close( "Hdr_IPv6" ) ;
&sub_close( "Hdr_IPv6" ) ;
&sub_close( "Hdr_IPv4" ) ;
&sub_close( "Cou_Other" ) ;
&sub_close( "Cou_v6ov6" ) ;
&sub_close( "Cou_v4ov6" ) ;
&sub_close( "Cou_v6ov4" ) ;
&sub_close( "Cou_v4ov4" ) ;
# ExtHdr ------------------------------------------------------------------
&sub_close( "Hdr_HopByHop" ) ;
&sub_close( "Hdr_Routing" ) ;
&sub_close( "Hdr_Fragment" ) ;
&sub_close( "Hdr_Destination" ) ;
&sub_close( "Hdr_AH" ) ;
&sub_close( "Hdr_ESP" ) ;
# Extension Header Option -------------------------------------------------
&sub_close( "Opt_JumboPayload" ) ;
# ICMP --------------------------------------------------------------------
&sub_close( "ICMPv6_NS" ) ;
&sub_close( "ICMPv6_NS_ToSo" ) ;
&sub_close( "ICMPv6_NS_FrUni" ) ;
&sub_close( "ICMPv6_NS_FrDAD" ) ;
&sub_close( "ICMPv6_NS_ToUni" ) ;
&sub_close( "ICMPv6_NA" ) ;
&sub_close( "ICMPv6_NA_ToUni" ) ;
&sub_close( "ICMPv6_NA_ToDAD" ) ;
&sub_close( "ICMPv6_RS" ) ;
&sub_close( "ICMPv6_RA" ) ;
# Address -----------------------------------------------------------------
&sub_close( "Cou_Uni" ) ;
&sub_close( "Cou_U_LoopBack" ) ;
&sub_close( "Cou_U_LinkLocal" ) ;
&sub_close( "Cou_U_SiteLocal" ) ;
&sub_close( "Cou_U_Global" ) ;
&sub_close( "Cou_M_general" ) ;
&sub_close( "Cou_M_reserved" ) ;
&sub_close( "Cou_M_well" ) ;
&sub_close( "Cou_M_Node_all_w" ) ;
&sub_close( "Cou_M_Node_node_w" ) ;
&sub_close( "Cou_M_Node_link_w" ) ;
&sub_close( "Cou_M_AllRoutes_w" ) ;
&sub_close( "Cou_M_Routes_node_w" ) ;
&sub_close( "Cou_M_Routes_link_w" ) ;
&sub_close( "Cou_M_Routes_site_w" ) ;
&sub_close( "Cou_M_AllPRoutes_w" ) ;
&sub_close( "Cou_M_PRoutes_node_w" ) ;
&sub_close( "Cou_M_PRoutes_link_w" ) ;
&sub_close( "Cou_M_PRoutes_site_w" ) ;
&sub_close( "Cou_M_Solicited_w" ) ;
&sub_close( "Cou_M_Others_w" ) ;
&sub_close( "Cou_M_trans" ) ;
&sub_close( "Cou_v4_compati" ) ;
&sub_close( "Cou_v4_mapped" ) ;
&sub_close( "ICMPv6_MLD" ) ;
&sub_close( "ICMPv6_MLDQuery" ) ;
&sub_close( "ICMPv6_MLDReport" ) ;
&sub_close( "ICMPv6_MLDDone" ) ;
&sub_close( "Cou_RIPng" ) ;
# ICMP ERROR --------------------------------------------------------------
&sub_close( "ICMPv6_DestinationUnreachable" ) ;
&sub_close( "ICMPv6_DesUnr_NoRo" ) ;
&sub_close( "ICMPv6_DesUnr_AP" ) ;
&sub_close( "ICMPv6_DesUnr_PU" ) ;
&sub_close( "ICMPv6_DesUnr_PT" ) ;
&sub_close( "ICMPv6_PacketTooBig" ) ;
&sub_close( "ICMPv6_TimeExceeded" ) ;
&sub_close( "ICMPv6_TimeExceeded_H" ) ;
&sub_close( "ICMPv6_TimeExceeded_F" ) ;
&sub_close( "ICMPv6_ParameterProblem" ) ;
&sub_close( "ICMPv6_ParameterProblem_E" ) ;
&sub_close( "ICMPv6_ParameterProblem_N" ) ;
&sub_close( "ICMPv6_ParameterProblem_I" ) ;
&sub_close( "Err_ICMPv6_Unrecognize" ) ;
&sub_close( "ICMPv6_Redirect" ) ;
&sub_close( "ICMPv6_Redirect_DIP" ) ;
&sub_close( "ICMPv6_Redirect_LIP" ) ;
# Etc ERROR ---------------------------------------------------------------
&sub_close( "Err_Ether" ) ;
&sub_close( "Err_Header_value" ) ;
&sub_close( "Err_TCP_checksum" ) ;
&sub_close( "Err_UDP_checksum" ) ;
&sub_close( "Err_ICMP_checksum" ) ;
&sub_close( "Err_ICMPv6_PacketTooBig" ) ;
&sub_close( "Err_LoopBack" ) ;
&sub_close( "Err_Multicast" ) ;
&sub_close( "Err_SDmismatch" ) ;
&sub_close( "Err_HopByHop" ) ;
&sub_close( "Err_HopByHop_2t" ) ;
&sub_close( "Err_Destination" ) ;
&sub_close( "Opt_JumboPayload" ) ;
&sub_close( "Err_JumboPayloadLength" ) ;
&sub_close( "Err_v6PayloadLength" ) ;
&sub_close( "Err_UDPlength_woJP" ) ;
&sub_close( "Err_PayloadLength" ) ;
&sub_close( "Err_UDPlength_JP" ) ;
&sub_close( "Err_Frag_Jumbo" ) ;
&sub_close( "Err_Frag_Aligment" ) ;
&sub_close( "Err_RH_Multicast" ) ;
&sub_close( "Cou_RS_Hop_Limit" ) ;
&sub_close( "Cou_RA_Hop_Limit" ) ;
&sub_close( "Cou_NS_Hop_Limit" ) ;
&sub_close( "Cou_NA_Hop_Limit" ) ;
&sub_close( "Err_ICMPv6_Redirect_HL" ) ;
&sub_close( "Err_ICMPv6_Redirect_DL" ) ;
# -------------------------------------------------------------------------
sub sub_open
{
	$fd = "OUT_" . $_[1] ;
	$fs = "./out/" . $_[1] . ".htm" ;

	open( $fd, "> $fs" ) ;
	print( $fd "<HTML>\n<BODY BGCOLOR=\"#FFFFFF\">\n<PRE>\n" ) ;
	print( $fd "<H2>$_[0]</H2>\n" ) ;
}

# -------------------------------------------------------------------------
sub sub_close
{
	$fd = "OUT_" . $_[0] ;

	print( $fd "</PRE>\n</BODY>\n</HTML>\n" ) ;
	close( $fd ) ;
}

# -------------------------------------------------------------------------
sub sub_list
{
	$fd = "OUT_" . $_[0] ;

	@desc_split = split(/ /, $_[1] ) ;
	$desc_split[1] =~ s/:/-/g ;
	$desc_split[1] =~ s/\./_/g ;

# for cgi
#	print( $fd
#		"<A HREF=./packet.cgi?$desc_split[1]+../$inputfile>$_[1]</A>\n" ) ;
# for non-cgi
	print( $fd
		"<A HREF=\"../packets/$desc_split[1].html\" TARGET=\"_blank\">$_[1]</A>\n"
		) ;
}

# -------------------------------------------------------------------------
sub sub_print
{
# $_[0]	: column
#		-2	: Don't make list file & no mark
#		-1	: Don't make list file
#		>0	: column count
# $_[1]	: TITLE
# $_[2]	: reference mode
#		>=0	: reference on
#		<0	: reference off
# $_[3]	: count
# $_[4]	: mark
#		0	: normal
#		1	: note
#		2	: warn

	$fs = "<A HREF=./out/" . $_[2] . ".htm>" ;
	$color[0] = "<FONT COLOR=\"#000000\">" ;
	$color[1] = "<FONT COLOR=\"#009900\">" ;
	$color[2] = "<FONT COLOR=\"#FF0000\">" ;

	print "<TR>\n" ;

	for (1..$_[0]) {
#		print "  <TD WIDTH=20>\n" ;
		print "  <TD>\n" ;
	}

	$x = 5 - $_[0] ;

	print "  <TD COLSPAN=$x>$color[$_[4]] $_[1] </FONT>\n" ;

	if ( $_[0] >= 0 ) {
		if ( $_[2] eq "-1" ) {
			print "  <TD ALIGN=right>$_[3]</A>\n" ;
		} else {
			print "  <TD ALIGN=right>$fs $_[3]</A>\n" ;
		}
	}
	if ( $_[0] > -2 ) {
		if ( $_[4] == 0 ) {
			print "  <TD ALIGN=left><BR>\n" ;
		} elsif ( $_[4] == 1 ) {
			print "  <TD ALIGN=left>$color[$_[4]]NOTE</FONT>\n" ;
		} elsif ( $_[4] == 2 ) {
			print "  <TD ALIGN=left>$color[$_[4]]WARN</FONT>\n" ;
		}
	}
	print "</TR>\n" ;
}
# -------------------------------------------------------------------------
