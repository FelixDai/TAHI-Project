/*
 * Copyright (C) 1999,2000 Yokogawa Electric Corporation and
 *                         YDC Corporation.
 * All rights reserved.
 * 
 * Redistribution and use of this software in source and binary
 * forms, with or without modification, are permitted provided that
 * the following conditions and disclaimer are agreed and accepted
 * by the user:
 * 
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with
 *    the distribution.
 * 
 * 3. Neither the names of the copyrighters, the name of the project
 *    which is related to this software (hereinafter referred to as
 *    "project") nor the names of the contributors may be used to
 *    endorse or promote products derived from this software without
 *    specific prior written permission.
 * 
 * 4. No merchantable use may be permitted without prior written
 *    notification to the copyrighters.
 * 
 * 5. The copyrighters, the project and the contributors may prohibit
 *    the use of this software at any time.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING
 * BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
#include "McSub.h"
#include "McNull.h"
#include "McEther.h"
#include "McIPv6.h"
#include "McMIPv6.h"
#include "McICMPv6.h"
#include "McRR.h"
#include "McIPv4.h"
#include "McICMPv4.h"
#include "McARP.h"
#include "McNoNext.h"
#include "McUDP.h"
#include "McTCP.h"
#include "McAlgorithm.h"
#include "McESP.h"
#include "McAH.h"

#include "MmObject.h"
#include "MmChecksum.h"
#include "MmHeader.h"
#include "MmData.h"
#include "PvObject.h"
#include "PvOctets.h"
#include "PvAction.h"
#include "PvAutoItem.h"
#include "PControl.h"
#include "WObject.h"
#include <stdio.h>
#define	UN(n) PvNumber::unique(n)
#define	V6TN()PvV6Addr::TN()
#define	V6NUT()PvV6Addr::NUT()
#define	ETTN()PvEther::TN()
#define	ETNUT()PvEther::NUT()
#define	MUST()PvMUSTDEF::must()
#define EVALANY()	new PvANY()
#define GENEHC(mc,cls,mem)	new PvHCgene(mc,(HCgenefunc)&cls::HCGENE(mem))
#define EVALHC(mc,cls,mem)	new PvHCeval(mc,(HCevalfunc)&cls::HCEVAL(mem))

#define ICVCONST()	0
#define ICVZERO()	new ICV_Zero()
#define ICVHC(mc,cls,mem)	new ICV_HC(mc,(METH_HC_OWICV)&cls::HC_OWICV(mem))
#define ICVOPTDATA(mc,cls)	ICVHC(mc,cls,OptExtData)

#define DEF_EVALSKIP	true
#define DEF_EVALGO	false
#define DEF_OPTCHKSUM	true
#define DEF_MUSTCHKSUM	false
#define DEF_NOPSEUDO	false
#define DEF_MUSTPSEUDO	true

McObject* McObject::addCompound(McObject* mc){
	mc->confirmed();
	set_.add(mc);
	return mc;}
#define LEXADD(classname,lexname) addCompound(classname::create(lexname))
#define LEXADD2(classname,lexname,tophdrnm)		\
	addCompound(classname::create(lexname,tophdrnm))
#define MCCR(classname,lexname) classname::create(lexname)

McObject* McObject::initialize(){
	static bool hasBeenHere=false;
	if(hasBeenHere) return 0;
	hasBeenHere=true;
/* Payload */
	LEXADD(McPayload,			"Payload" );

/* DataLinkLayer */
	// Ether
	McObject* mc=
	LEXADD2(McFrame_Ether,			"Frame_Ether","Hdr_Ether" );
	LEXADD2(McFrame_Null,			"Frame_Null","Hdr_Null" );

/* NetworkLayer */
	// IPv6
	LEXADD2(McPacket_IPv6,			"Packet_IPv6","Hdr_IPv6" );
	 
	LEXADD(McHdr_Ext_HopByHop,		"Hdr_HopByHop" );
	LEXADD(McHdr_Ext_Destination,		"Hdr_Destination" );
	LEXADD(McHdr_Ext_Routing,		"Hdr_Routing" );
	LEXADD(McHdr_Ext_Fragment,		"Hdr_Fragment" );
	 
	LEXADD(McOpt_Ext_ANY,			"Opt_ANY" );
	LEXADD(McOpt_Ext_Pad1,			"Opt_Pad1" );
	LEXADD(McOpt_Ext_PadN,			"Opt_PadN" );
	LEXADD(McOpt_Ext_JumboPayload,		"Opt_JumboPayload" );
	LEXADD(McOpt_Ext_RouterAlert,		"Opt_RouterAlert" );
	LEXADD(McOpt_Ext_TunnelEncap,		"Opt_TunnelEncapslation" );
	LEXADD(McOpt_Ext_MIPBindingUpdate,	"Opt_MIPBindingUpdate" );
	LEXADD(McOpt_Ext_MIPBindingAck,		"Opt_MIPBindingAck" );
	LEXADD(McOpt_Ext_MIPBindingReq,		"Opt_MIPBindingReq" );
	LEXADD(McOpt_Ext_MIPHomeAddress,	"Opt_MIPHomeAddress" );
	LEXADD(McOpt_MIP_ANY,			"Opt_MIP_ANY" );
	LEXADD(McOpt_MIP_Pad1,			"Opt_MIP_Pad1" );
	LEXADD(McOpt_MIP_PadN,			"Opt_MIP_PadN" );
	LEXADD(McOpt_MIP_UniqID,		"Opt_MIP_UniqID" );
	LEXADD(McOpt_MIP_AlternateCareOfAddr,	"Opt_MIP_AlternateCareOfAddr" );
	// IPsec
	LEXADD(McHdr_Ext_AH,			"Hdr_AH" );
	LEXADD(McAlgorithm_AH,			"AHAlgorithm" );
	LEXADD(McHdr_Ext_ESP,			"Hdr_ESP" );
	LEXADD(McAlgorithm_ESP,			"ESPAlgorithm" );

	// IPv4
	LEXADD2(McPacket_IPv4,			"Packet_IPv4","Hdr_IPv4" );
	McOpt_IPv4::create_options();

	//ARP
 	LEXADD2(McPacket_ARP,			"Packet_ARP","Hdr_ARP" );
	//RARP
	LEXADD2(McPacket_RARP,			"Packet_RARP","Hdr_RARP" );

/* UpperLayer */
	//NoNext
	LEXADD(McUpp_NoNext,			"Upp_NoNext" );

	//ICMPv6
	LEXADD(McUpp_ICMPv6_ANY,		"ICMPv6_ANY" );
	LEXADD(McUpp_ICMPv6_RS,			"ICMPv6_RS" );
	LEXADD(McUpp_ICMPv6_RA,			"ICMPv6_RA" );
	LEXADD(McUpp_ICMPv6_NS,			"ICMPv6_NS" );
	LEXADD(McUpp_ICMPv6_NA,			"ICMPv6_NA" );
	LEXADD(McUpp_ICMPv6_Redirect,		"ICMPv6_Redirect" );
	LEXADD(McUpp_ICMPv6_MLDQuery,		"ICMPv6_MLDQuery");
	LEXADD(McUpp_ICMPv6_MLDReport,		"ICMPv6_MLDReport");
	LEXADD(McUpp_ICMPv6_MLDDone,		"ICMPv6_MLDDone");
	LEXADD(McUpp_ICMPv6_EchoRequest,	"ICMPv6_EchoRequest" );
	LEXADD(McUpp_ICMPv6_EchoReply,		"ICMPv6_EchoReply" );
	LEXADD(McUpp_ICMPv6_PacketTooBig,	"ICMPv6_PacketTooBig" );
	LEXADD(McUpp_ICMPv6_DestinationUnreachable,"ICMPv6_DestinationUnreachable" );
	LEXADD(McUpp_ICMPv6_TimeExceeded,	"ICMPv6_TimeExceeded" );
	LEXADD(McUpp_ICMPv6_ParameterProblem,	"ICMPv6_ParameterProblem" );
	LEXADD(McUpp_ICMPv6_RouterRenumbering,	"ICMPv6_RouterRenumbering" );
//	LEXADD(McUpp_ICMPv6_NameLookups,	"ICMPv6_NameLookups" );
	LEXADD(McUpp_ICMPv6_HomeAgentAddrDiscoveryReq,	"ICMPv6_HomeAgentAddrDiscoveryReq" );
	LEXADD(McUpp_ICMPv6_HomeAgentAddrDiscoveryRep,	"ICMPv6_HomeAgentAddrDiscoveryRep" );
	
	LEXADD(McOpt_ICMPv6_ANY,		"Opt_ICMPv6_ANY" );
	LEXADD(McOpt_ICMPv6_SLL,		"Opt_ICMPv6_SLL" );
	LEXADD(McOpt_ICMPv6_TLL,		"Opt_ICMPv6_TLL" );
	LEXADD(McOpt_ICMPv6_Prefix,		"Opt_ICMPv6_Prefix" );
	LEXADD(McOpt_ICMPv6_Redirected,	"Opt_ICMPv6_Redirected" );
	LEXADD(McOpt_ICMPv6_MTU,		"Opt_ICMPv6_MTU" );
	LEXADD(McOpt_ICMPv6_AdvertisementInterval,	"Opt_ICMPv6_AdvertisementInterval");
	LEXADD(McOpt_ICMPv6_HomeAgentInformation,	"Opt_ICMPv6_HomeAgentInformation");

	//ICMPv4
	LEXADD(McUpp_ICMPv4_ANY,		"ICMPv4_ANY" );
	LEXADD(McUpp_ICMPv4_DestinationUnreachable,"ICMPv4_DestinationUnreachable" );
	LEXADD(McUpp_ICMPv4_TimeExceeded,	"ICMPv4_TimeExceeded" );
	LEXADD(McUpp_ICMPv4_ParameterProblem,	"ICMPv4_ParameterProblem" );
	LEXADD(McUpp_ICMPv4_Redirect,	 	"ICMPv4_Redirect" );
	LEXADD(McUpp_ICMPv4_EchoRequest,	"ICMPv4_EchoRequest" );
	LEXADD(McUpp_ICMPv4_EchoReply,		"ICMPv4_EchoReply" );

	//UDP
	LEXADD2(McUpp_UDP,			"Upp_UDP","Hdr_UDP" );

	//TCP
	LEXADD2(McUpp_TCP,			"Upp_TCP","Hdr_TCP" );
	McOpt_TCP::create_options();

	//
	return mc;}


/////// Mc creater implementaion /////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
McPayload* McPayload::create(CSTR key){
	McPayload* mc = new McPayload(key);
	mc->member( new MmData(	"data" ) );
	// dict
	MmPayload::add_other(mc);		//payload=
	MmFrame::add_other(mc);			//frame=
	MmPacket_onEther::add_other(mc);	//Frame_Ether::packet=
	MmPacket_onNull::add_other(mc);		//Frame_Null::packet=
	MmUpper_onIP::add_other(mc);		//Packet_IP::upper=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McFrame_Ether* McFrame_Ether::create(CSTR key,CSTR tophdrkey){
	addCompound(tophdr_ = McTopHdr_Ether::create(tophdrkey));
	McFrame_Ether* mc = new McFrame_Ether(key);
	mc->member( new MmTopHdr(		"header",tophdr_ ) );
	mc->member( new MmPacket_onEther(	"packet" ) );
	// dict
	MmFrame::add(mc);			//frame=
	return mc;}

McTopHdr_Ether* McTopHdr_Ether::create(CSTR key){
	McTopHdr_Ether* mc = new McTopHdr_Ether(key);
	mc->member( new MmEther("DestinationAddress",	ETNUT(),ETTN()));
	mc->member( new MmEther("SourceAddress",	ETTN(),	ETNUT()));
	mc->nextType_member(
		    new MmUint(	"Type", 16, GENEHC(mc,McTopHdr_Ether,Type),EVALHC(mc,McTopHdr_Ether,Type) ) );
	// no dict
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McPacket_IPv6* McPacket_IPv6::create(CSTR key,CSTR tophdrkey){
	addCompound(tophdr_ = McTopHdr_IPv6::create(tophdrkey));
	McPacket_IPv6* mc = new McPacket_IPv6(key);
	mc->member( new MmTopHdr(	"header",tophdr_) );
	mc->member( new MmExtent_onIP(	"exthdr" ) );
	mc->member( new MmUpper_onIP(	"upper" ) );
	// dict
	MmPacket_onNull::add(mc);		//Frame_Null::packet=
	MmPacket_onEther::add(mc);		//Frame_Ether::packet=
	MmUpper_onIP::add(mc);			//Packet_IP::upper=(tunnel)
	return mc;}

McTopHdr_IPv6* McTopHdr_IPv6::create(CSTR key){
	McTopHdr_IPv6* mc = new McTopHdr_IPv6(key);
	mc->member( new MmUint( "Version",	4,
			UN(6),	UN(6),		ICVCONST() ) );
	mc->member( new MmUint( "TrafficClass",	8,
			UN(0),	EVALANY(),	ICVZERO() ) );
	mc->member( new MmUint( "FlowLabel",	20,
			UN(0),	EVALANY(),	ICVZERO() ) );
	mc->Layerlength_member(
		    new MmUint(	"PayloadLength",16,
			GENEHC(mc,McTopHdr_IPv6,PayloadLength),
			EVALANY(),		ICVCONST() ) );
	mc->nextType_member(
		    new MmUint( "NextHeader",	8,
			GENEHC(mc,McTopHdr_IPv6,NextHeader),
			EVALHC(mc,McTopHdr_IPv6,NextHeader),	ICVCONST() ) );
	mc->member( new MmUint( "HopLimit",	8,
			UN(64),	EVALANY(),	ICVZERO() ) );
	mc->member( new MmV6Addr( "SourceAddress",
			V6TN(),	V6NUT(),	ICVCONST(),
			(METH_HC_ForIPinfo)&McTopHdr_IPv6::HC_ForIPinfo(SourceAddress) ) );
	mc->member( new MmV6Addr( "DestinationAddress",
			V6NUT(),V6TN(),		ICVHC(mc,McTopHdr_IPv6,DestinationAddress), 
			(METH_HC_ForIPinfo)&McTopHdr_IPv6::HC_ForIPinfo(DestinationAddress) ) );
	// no dict
	return mc;}


//////////////////////////////////////////////////////////////////////////////
McHdr_Ext_HopByHop* McHdr_Ext_HopByHop::create(CSTR key){
	McHdr_Ext_HopByHop* mc = new McHdr_Ext_HopByHop(key);
	mc->nextType_member(
		    new MmUint( "NextHeader",	8,
			GENEHC(mc,McHdr_Ext_HopByHop,NextHeader),
			EVALHC(mc,McHdr_Ext_HopByHop,NextHeader),	ICVCONST() ) );
	mc->length_member(
		    new MmUint( "HeaderExtLength",8,
			GENEHC(mc,McHdr_Ext_HopByHop,HeaderExtLength),
			EVALANY(),		ICVCONST() ) );
	mc->member( new MmOption_onExt("option") );
	// dict
	MmExtent_onIP::add(mc);		//Packet_IP::exthdr=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McHdr_Ext_Destination* McHdr_Ext_Destination::create(CSTR key){
	McHdr_Ext_Destination* mc = new McHdr_Ext_Destination(key);
	mc->nextType_member(
		    new MmUint( "NextHeader",	8,
			GENEHC(mc,McHdr_Ext_HopByHop,NextHeader),
			EVALHC(mc,McHdr_Ext_HopByHop,NextHeader),	ICVCONST() ) );
	mc->length_member(
		    new MmUint( "HeaderExtLength",8,
			GENEHC(mc,McHdr_Ext_HopByHop,HeaderExtLength),
			EVALANY(),		ICVCONST() ) );
	mc->member( new MmOption_onExt("option") );
	// dict
	MmExtent_onIP::add(mc);		//Packet_IP::exthdr=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McHdr_Ext_Routing* McHdr_Ext_Routing::create(CSTR key){
	McHdr_Ext_Routing* mc = new McHdr_Ext_Routing(key);
	mc->nextType_member(
		    new MmUint( "NextHeader",	8,
			GENEHC(mc,McHdr_Ext_Routing,NextHeader),
			EVALHC(mc,McHdr_Ext_Routing,NextHeader),	ICVCONST() ) );
	mc->length_member(
		    new MmUint( "HeaderExtLength",8,
			GENEHC(mc,McHdr_Ext_Routing,HeaderExtLength),
			EVALANY(),		ICVCONST() ) );
	mc->member( new MmUint( "RoutingType",	8,
			UN(0),	UN(0),		ICVCONST() ) );
	mc->member( new MmUint( "SegmentsLeft",	8,
			UN(0),	UN(0),		ICVHC(mc,McHdr_Ext_Routing,SegmentsLeft) ,
			(METH_HC_ForIPinfo)&McHdr_Ext_Routing::HC_ForIPinfo(SegmentsLeft) ) );
	mc->member( new MmUint( "Reserved",	32,
			UN(0),	UN(0),		ICVCONST() ) );
	mc->member( new MmMultiple(
			new MmV6Addr( "Address",
				MUST(),MUST(),	ICVHC(mc,McHdr_Ext_Routing,Address), 
				(METH_HC_ForIPinfo)&McHdr_Ext_Routing::HC_ForIPinfo(Address) ),
			(METH_HC_MLC)&McHdr_Ext_Routing::HC_MLC(Address) ) );
	// dict
	MmExtent_onIP::add(mc);		//Packet_IP::exthdr=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McHdr_Ext_Fragment* McHdr_Ext_Fragment::create(CSTR key){
	McHdr_Ext_Fragment* mc = new McHdr_Ext_Fragment(key);
	mc->nextType_member(
		    new MmUint( "NextHeader",	8,	MUST(),	MUST() ) );
	mc->member( new MmUint( "Reserved1",	8,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "FragmentOffset",13,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved2",	2,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "MFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Identification",32,	UN(0),	UN(0) ) );
	// dict
	MmExtent_onIP::add(mc);		//Packet_IP::exthdr=
	return mc;}


//////////////////////////////////////////////////////////////////////////////
void McOpt_Ext::common_member(){
	int32_t Type = optionType();
	type_member(
		new MmUint( "OptionType",	8,
			UN(Type),UN(Type),	ICVCONST() ) );
	length_member(
		new MmUint( "OptDataLength",	8,
			GENEHC(this,McOpt_Ext,OptDataLength),
			EVALANY(),		ICVCONST() ) );
	}

McOpt_Ext_ANY* McOpt_Ext_ANY::create(CSTR key){
	McOpt_Ext_ANY* mc = new McOpt_Ext_ANY(key);
	mc->common_member();
	mc->member( new MmData( "data" ,DEF_EVALGO,	ICVOPTDATA(mc,McOpt_Ext_ANY) ) );
	// dict
	MmOption_onExt::add_other(mc);	//Hdr_Ext_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_Ext_Pad1* McOpt_Ext_Pad1::create(CSTR key){
	McOpt_Ext_Pad1* mc = new McOpt_Ext_Pad1(key);
	int32_t Type = mc->optionType();
	mc->type_member(
		new MmUint( "OptionType",	8,
			UN(Type),UN(Type),	ICVCONST() ) );
	// dict
	MmOption_onExt::add(mc);		//Hdr_Ext_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_Ext_PadN* McOpt_Ext_PadN::create(CSTR key){
	McOpt_Ext_PadN* mc = new McOpt_Ext_PadN(key);
	mc->common_member();
	mc->member( new MmData( "pad",	DEF_EVALSKIP,	ICVOPTDATA(mc,McOpt_Ext_PadN) ) );
	// dict
	MmOption_onExt::add(mc);		//Hdr_Ext_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_Ext_JumboPayload* McOpt_Ext_JumboPayload::create(CSTR key){
	McOpt_Ext_JumboPayload* mc = new McOpt_Ext_JumboPayload(key);
	mc->common_member();
	mc->member( new MmUint( "JumboPayloadLength",32,
			GENEHC(mc,McOpt_Ext_JumboPayload,JumboPayloadLength),
			EVALANY(),		ICVOPTDATA(mc,McOpt_Ext_JumboPayload) ) );
	// dict
	MmOption_onExt::add(mc);		//Hdr_Ext_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_Ext_RouterAlert* McOpt_Ext_RouterAlert::create(CSTR key){
	McOpt_Ext_RouterAlert* mc = new McOpt_Ext_RouterAlert(key);
	mc->common_member();
	mc->member( new MmUint( "Value",	16,
			MUST(),	MUST(),		ICVOPTDATA(mc,McOpt_Ext_RouterAlert) ) );
	// dict
	MmOption_onExt::add(mc);		//Hdr_Ext_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_Ext_TunnelEncap* McOpt_Ext_TunnelEncap::create(CSTR key){
	McOpt_Ext_TunnelEncap* mc = new McOpt_Ext_TunnelEncap(key);
	mc->common_member();
	mc->member( new MmUint( "Limit",	8,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_TunnelEncap) ) );
	// dict
	MmOption_onExt::add(mc);		//Hdr_Ext_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_Ext_MIPBindingUpdate* McOpt_Ext_MIPBindingUpdate::create(CSTR key){
	McOpt_Ext_MIPBindingUpdate* mc = new McOpt_Ext_MIPBindingUpdate(key);
	mc->common_member();
	mc->member( new MmUint( "Acknowledge",	1,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingUpdate) ) );
	mc->member( new MmUint( "HomeRegistration",	1,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingUpdate) ) );
	mc->member( new MmUint( "Router",	1,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingUpdate) ) );
	mc->member( new MmUint( "DAD",	1,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingUpdate) ) );
	mc->member( new MmUint( "Reservd",	4,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingUpdate) ) );
	mc->member( new MmUint( "PrefixLength",	8,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingUpdate) ) );
	mc->member( new MmUint( "SequenceNumber",	16,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingUpdate) ) );
	mc->member( new MmUint( "Lifetime",	32,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingUpdate) ) );
	mc->member( new MmOption_onMIP("option") );
	// dict
	MmOption_onExt::add(mc);		//Hdr_Ext_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_Ext_MIPBindingAck* McOpt_Ext_MIPBindingAck::create(CSTR key){
	McOpt_Ext_MIPBindingAck* mc = new McOpt_Ext_MIPBindingAck(key);
	mc->common_member();
	mc->member( new MmUint( "Status",	8,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingAck) ) );
	mc->member( new MmUint( "SequenceNumber",	16,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingAck) ) );
	mc->member( new MmUint( "Lifetime",	32,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingAck) ) );
	mc->member( new MmUint( "Refresh",	32,
			UN(0),	UN(0),		ICVOPTDATA(mc,McOpt_Ext_MIPBindingAck) ) );
	mc->member( new MmOption_onMIP("option") );
	// dict
	MmOption_onExt::add(mc);		//Hdr_Ext_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_Ext_MIPHomeAddress* McOpt_Ext_MIPHomeAddress::create(CSTR key){
	McOpt_Ext_MIPHomeAddress* mc = new McOpt_Ext_MIPHomeAddress(key);
	mc->common_member();
	mc->member( new MmV6Addr( "HomeAddress",	MUST(),MUST()));
	mc->member( new MmOption_onMIP("option") );
	// dict
	MmOption_onExt::add(mc);		//Hdr_Ext_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_Ext_MIPBindingReq* McOpt_Ext_MIPBindingReq::create(CSTR key){
	McOpt_Ext_MIPBindingReq* mc = new McOpt_Ext_MIPBindingReq(key);
	mc->common_member();
	mc->member( new MmOption_onMIP("option") );
	// dict
	MmOption_onExt::add(mc);		//Hdr_Ext_XX::option=
	return mc;}


//////////////////////////////////////////////////////////////////////////////

void McOpt_MIP::common_member(){
	int32_t Type = optionType();
	type_member(
		new MmUint( "Type",	8, UN(Type),UN(Type) ) );
	length_member(
		new MmUint( "Length",	8, GENEHC(this,McOpt_MIP,Length),EVALANY() ) );
	}

McOpt_MIP_ANY* McOpt_MIP_ANY::create(CSTR key){
	McOpt_MIP_ANY* mc = new McOpt_MIP_ANY(key);
	mc->common_member();
	mc->member( new MmData( "data" ) );
	// dict
	MmOption_onMIP::add_other(mc);	//Upp_MIP_XX::option=
	return mc;}
//////////////////////////////////////////////////////////////////////////////
McOpt_MIP_Pad1* McOpt_MIP_Pad1::create(CSTR key){
	McOpt_MIP_Pad1* mc = new McOpt_MIP_Pad1(key);
	int32_t Type = mc->optionType();
#if 0
	new MmUint( "Type",	8, UN(Type),UN(Type) );
#else
	mc->type_member(new MmUint("Type", 8, UN(Type), UN(Type)));
#endif
	// dict
	MmOption_onMIP::add(mc);		//Upp_MIP_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_MIP_PadN* McOpt_MIP_PadN::create(CSTR key){
	McOpt_MIP_PadN* mc = new McOpt_MIP_PadN(key);
	mc->common_member();
	mc->member( new MmData( "pad" ) );
	// dict
	MmOption_onMIP::add(mc);		//Hdr_MIP_XX::option=
	return mc;}

McOpt_MIP_UniqID* McOpt_MIP_UniqID::create(CSTR key){
	McOpt_MIP_UniqID* mc = new McOpt_MIP_UniqID(key);
	mc->common_member();
#if 0
	new MmUint( "UniqID",	16, UN(0),UN(0) );
#else
	mc->member( new MmUint( "UniqID",	16,	UN(0),	UN(0) ) );
#endif
	// dict
	MmOption_onMIP::add(mc);		//Upp_MIP_XX::option=
	return mc;}

McOpt_MIP_AlternateCareOfAddr* McOpt_MIP_AlternateCareOfAddr::create(CSTR key){
	McOpt_MIP_AlternateCareOfAddr* mc = new McOpt_MIP_AlternateCareOfAddr(key);
	mc->common_member();
	mc->member( new MmV6Addr( "AlternateCareOfAddr",
			MUST(),MUST()));
	// dict
	MmOption_onMIP::add(mc);		//Upp_MIP_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McPacket_IPv4* McPacket_IPv4::create(CSTR key,CSTR tophdrkey){
	addCompound(tophdr_ = McTopHdr_IPv4::create(tophdrkey));
	McPacket_IPv4* mc = new McPacket_IPv4(key);
	mc->member( new MmTopHdr(	"header",tophdr_) );
	mc->member( new MmExtent_onIP(	"exthdr" ) );
	mc->member( new MmUpper_onIP(	"upper" ) );
	// dict
	MmPacket_onNull::add(mc);		//Frame_Null::packet=
	MmPacket_onEther::add(mc);		//Frame_Ether::packet=
	MmUpper_onIP::add(mc);			//Packet_IP::upper=(tunnel)
	return mc;}

McTopHdr_IPv4* McTopHdr_IPv4::create(CSTR key){
	McTopHdr_IPv4* mc = new McTopHdr_IPv4(key);
	mc->member( new MmUint( "Version",	4,
			UN(4),	UN(4),		ICVCONST() ) );
	mc->length_member(
		    new MmUint( "IHL",		4,
			GENEHC(mc,McTopHdr_IPv4,IHL),
			EVALANY(),		ICVCONST() ) );
	mc->member( new MmUint( "TypeOfService",8,
			UN(0),	EVALANY(),	ICVZERO() ) );
	mc->Layerlength_member(
		    new MmUint(	"TotalLength",	16,
			GENEHC(mc,McTopHdr_IPv4,TotalLength),
			EVALANY(),		ICVCONST() ) );
	mc->member( new MmUint( "Identifier",	16,
			UN(0),	EVALANY(),	ICVCONST() ) );
	mc->Flags_member(
		    new MmUint( "Reserved",	1,
			UN(0),	UN(0),		ICVZERO() ) );
	mc->Flags_member(
		    new MmUint( "DF",		1,
			UN(0),	EVALANY(),	ICVZERO() ) );
	mc->Flags_member(
		    new MmUint( "MF",		1,
 			UN(0),	UN(0),		ICVZERO() ) );
	mc->fragoffset_member(
		    new MmUint( "FragmentOffset",13,
			UN(0),	UN(0),		ICVZERO() ) );
	mc->member( new MmUint( "TTL",		8,
			UN(255),EVALANY(),	ICVZERO() ) );
	mc->nextType_member(
		    new MmUint( "Protocol",	8,
			GENEHC(mc,McTopHdr_IPv4,Protocol),
			EVALHC(mc,McTopHdr_IPv4,Protocol),	ICVCONST() ) );
	mc->member( new MmIPChecksum( "HeaderChecksum",16,
			DEF_MUSTCHKSUM, 	ICVZERO() ) );
	mc->member( new MmV4Addr( "SourceAddress",
			MUST(),MUST(),		ICVCONST(),
			(METH_HC_ForIPinfo)&McTopHdr_IPv4::HC_ForIPinfo(SourceAddress) ) );
	mc->member( new MmV4Addr( "DestinationAddress",
			MUST(),MUST(),		ICVHC(mc,McTopHdr_IPv4,DestinationAddress),
			(METH_HC_ForIPinfo)&McTopHdr_IPv4::HC_ForIPinfo(DestinationAddress) ) );
	mc->member( new MmOption_onIPv4( "option" ) );
	mc->member( new MmData(	"Padding",DEF_EVALSKIP,	ICVCONST() ) );
	// no dict
	return mc;}


//////////////////////////////////////////////////////////////////////////////
McUpp_NoNext* McUpp_NoNext::create(CSTR key){
	McUpp_NoNext* mc = new McUpp_NoNext(key);
	mc->member( new MmData(	"data" ) );
	// dict
	MmUpper_onIP::add(mc);			//Packet_IP::upper=
	return mc;}


//////////////////////////////////////////////////////////////////////////////
void McUpp_ICMPv6::common_member(){
	int32_t Type = icmpv6Type();
	type_member(
		new MmUint( "Type",		8,	UN(Type),UN(Type) ) );
	Code_member(
		new MmUint( "Code",		8,	UN(0),	UN(0) ) );
	member( new MmUppChecksum( "Checksum",	16 ) );
	//isEqual(DEF_MUSTCHKSUM,DEF_MUSTPSEUDO,ICVCONST)
	}

McUpp_ICMPv6_ANY* McUpp_ICMPv6_ANY::create(CSTR key){
	McUpp_ICMPv6_ANY* mc = new McUpp_ICMPv6_ANY(key);
	mc->common_member();
	mc->member( new MmData( "data" ) );
	// dict
	MmHeader_onICMPv6::add_other(mc);	//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_RS* McUpp_ICMPv6_RS::create(CSTR key){
	McUpp_ICMPv6_RS* mc = new McUpp_ICMPv6_RS(key);
	mc->common_member();
	mc->member( new MmUint( "Reserved",	32,	UN(0),	UN(0) ) );
	mc->member( new MmOption_onICMPv6( "option" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_RA* McUpp_ICMPv6_RA::create(CSTR key){
	McUpp_ICMPv6_RA* mc = new McUpp_ICMPv6_RA(key);
	mc->common_member();
	mc->member( new MmUint( "CurHopLimit",	8,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "MFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "OFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "HFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved",	5,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "LifeTime",	16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "ReachableTime",32,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "RetransTimer",	32,	UN(0),	UN(0) ) );
	mc->member( new MmOption_onICMPv6( "option" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_NS* McUpp_ICMPv6_NS::create(CSTR key){
	McUpp_ICMPv6_NS* mc = new McUpp_ICMPv6_NS(key);
	mc->common_member();
	mc->member( new MmUint( "Reserved",	32,	UN(0),	UN(0) ) );
	mc->member( new MmV6Addr( "TargetAddress",	V6NUT(),V6TN()));
	mc->member( new MmOption_onICMPv6( "option" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_NA* McUpp_ICMPv6_NA::create(CSTR key){
	McUpp_ICMPv6_NA* mc = new McUpp_ICMPv6_NA(key);
	mc->common_member();
	mc->member( new MmUint( "RFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "SFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "OFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved",	29,	UN(0),	UN(0) ) );
	mc->member( new MmV6Addr( "TargetAddress",	V6TN(),	V6NUT()));
	mc->member( new MmOption_onICMPv6( "option" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_Redirect* McUpp_ICMPv6_Redirect::create(CSTR key){
	McUpp_ICMPv6_Redirect* mc = new McUpp_ICMPv6_Redirect(key);
	mc->common_member();
	mc->member( new MmUint( "Reserved",	32,	UN(0),	UN(0) ) );
	mc->member( new MmV6Addr( "TargetAddress",	MUST(),	MUST() ) );
	mc->member( new MmV6Addr( "DestinationAddress",	MUST(),	MUST() ) );
	mc->member( new MmOption_onICMPv6( "option" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
template<uint32_t TYPE>
McUpp_ICMPv6_MLD<TYPE>* McUpp_ICMPv6_MLD<TYPE>::create(CSTR key){
	McUpp_ICMPv6_MLD<TYPE>* mc = new McUpp_ICMPv6_MLD<TYPE>(key);
	mc->common_member();
	mc->member( new MmUint( "MaxResponseDelay",16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved",	16,	UN(0),	UN(0) ) );
	mc->member( new MmV6Addr( "MulticastAddress",	MUST(),	MUST() ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
template<uint32_t TYPE>
McUpp_ICMPv6_Echo<TYPE>* McUpp_ICMPv6_Echo<TYPE>::create(CSTR key){
	McUpp_ICMPv6_Echo<TYPE>* mc = new McUpp_ICMPv6_Echo<TYPE>(key);
	mc->common_member();
	mc->member( new MmUint( "Identifier",	16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "SequenceNumber",16,	UN(0),	UN(0) ) );
	mc->member( new MmPayload( "payload" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_PacketTooBig* McUpp_ICMPv6_PacketTooBig::create(CSTR key){
	McUpp_ICMPv6_PacketTooBig* mc = new McUpp_ICMPv6_PacketTooBig(key);
	mc->common_member();
	mc->member( new MmUint( "MTU",		32,	MUST(),	MUST() ) );
	mc->member( new MmPayload( "payload" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_DestinationUnreachable* McUpp_ICMPv6_DestinationUnreachable::create(CSTR key){
	McUpp_ICMPv6_DestinationUnreachable* mc = new McUpp_ICMPv6_DestinationUnreachable(key);
	mc->common_member();
	mc->member( new MmUint( "Unused",	32,	UN(0),	UN(0) ) );
	mc->member( new MmPayload( "payload" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_TimeExceeded* McUpp_ICMPv6_TimeExceeded::create(CSTR key){
	McUpp_ICMPv6_TimeExceeded* mc = new McUpp_ICMPv6_TimeExceeded(key);
	mc->common_member();
	mc->member( new MmUint( "Unused",	32,	UN(0),	UN(0) ) );
	mc->member( new MmPayload( "payload" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_ParameterProblem* McUpp_ICMPv6_ParameterProblem::create(CSTR key){
	McUpp_ICMPv6_ParameterProblem* mc = new McUpp_ICMPv6_ParameterProblem(key);
	mc->common_member();
	mc->member( new MmUint( "Pointer",	32,	MUST(),	MUST() ) );
	mc->member( new MmPayload( "payload" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_RouterRenumbering* McUpp_ICMPv6_RouterRenumbering::create(CSTR key){
	McUpp_ICMPv6_RouterRenumbering* mc = new McUpp_ICMPv6_RouterRenumbering(key);
	mc->common_member();
	mc->member( new MmUint( "SequenceNumber",	32,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "SegmentNumber",	8,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "TFlag",		1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "RFlag",		1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "AFlag",		1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "SFlag",		1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "PFlag",		1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved1",		3,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "MaxDelay",		16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved2",		32,	UN(0),	UN(0) ) );
	mc->member( new MmPayload( "payload" ) );
	// dict
	MmHeader_onICMPv6::add(mc);		//Upp_ICMPv6::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_HomeAgentAddrDiscoveryReq* McUpp_ICMPv6_HomeAgentAddrDiscoveryReq::create(CSTR key) {
	McUpp_ICMPv6_HomeAgentAddrDiscoveryReq* mc = new McUpp_ICMPv6_HomeAgentAddrDiscoveryReq(key);
	mc->common_member();
	mc->member( new MmUint( "Identifier",	16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved1",	32,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved2",	32,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved3",	16,	UN(0),	UN(0) ) );
	mc->member( new MmV6Addr( "HomeAddress",	MUST(),	MUST() ) );
	MmHeader_onICMPv6::add(mc);
	return mc;
}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv6_HomeAgentAddrDiscoveryRep* McUpp_ICMPv6_HomeAgentAddrDiscoveryRep::create(CSTR key) {
	McUpp_ICMPv6_HomeAgentAddrDiscoveryRep* mc = new McUpp_ICMPv6_HomeAgentAddrDiscoveryRep(key);
	mc->common_member();
	mc->member( new MmUint( "Identifier",	16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved1",	32,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved2",	32,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved3",	16,	UN(0),	UN(0) ) );
#if 0
	mc->member( new MmV6Addr( "HomeAgentAddr",	MUST(),	MUST() ) );
#else
	mc->member(
		new MmMultiple(
			new MmV6Addr( "HomeAgentAddr", MUST(), MUST() ),
			(METH_HC_MLC)&McUpp_ICMPv6_HomeAgentAddrDiscoveryRep::HC_MLC(Address)
		)
	);
#endif

	MmHeader_onICMPv6::add(mc);
	return mc;
}



//////////////////////////////////////////////////////////////////////////////

void McOpt_ICMPv6::common_member(){
	int32_t Type = optionType();
	type_member(
		new MmUint( "Type",	8, UN(Type),UN(Type) ) );
	length_member(
		new MmUint( "Length",	8, GENEHC(this,McOpt_ICMPv6,Length),EVALANY() ) );
	}

McOpt_ICMPv6_ANY* McOpt_ICMPv6_ANY::create(CSTR key){
	McOpt_ICMPv6_ANY* mc = new McOpt_ICMPv6_ANY(key);
	mc->common_member();
	mc->member( new MmData( "data" ) );
	// dict
	MmOption_onICMPv6::add_other(mc);	//Upp_ICMPv6_XX::option=
	return mc;}
//////////////////////////////////////////////////////////////////////////////
McOpt_ICMPv6_SLL* McOpt_ICMPv6_SLL::create(CSTR key){
	McOpt_ICMPv6_SLL* mc = new McOpt_ICMPv6_SLL(key);
	mc->common_member();
	mc->member( new MmEther( "LinkLayerAddress",	ETNUT(),ETTN()));
	// dict
	MmOption_onICMPv6::add(mc);		//Upp_ICMPv6_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_ICMPv6_TLL* McOpt_ICMPv6_TLL::create(CSTR key){
	McOpt_ICMPv6_TLL* mc = new McOpt_ICMPv6_TLL(key);
	mc->common_member();
	mc->member( new MmEther( "LinkLayerAddress",	ETNUT(),ETTN()));
	// dict
	MmOption_onICMPv6::add(mc);		//Upp_ICMPv6_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_ICMPv6_Prefix* McOpt_ICMPv6_Prefix::create(CSTR key){
	McOpt_ICMPv6_Prefix* mc = new McOpt_ICMPv6_Prefix(key);
	mc->common_member();
	mc->member( new MmUint( "PrefixLength",	8,	UN(64),	UN(64) ) );
	mc->member( new MmUint( "LFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "AFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "RFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved1",	5,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "ValidLifetime",32,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "PreferredLifetime",32,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved2",	32,	UN(0),	UN(0) ) );
	mc->member( new MmV6Addr( "Prefix",		MUST(),	MUST() ) );
	// dict
	MmOption_onICMPv6::add(mc);		//Upp_ICMPv6_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_ICMPv6_MTU* McOpt_ICMPv6_MTU::create(CSTR key){
	McOpt_ICMPv6_MTU* mc = new McOpt_ICMPv6_MTU(key);
	mc->common_member();
	mc->member( new MmUint( "Reserved",	16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "MTU",		32,	UN(1500),UN(1500) ) );
	// dict
	MmOption_onICMPv6::add(mc);		//Upp_ICMPv6_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_ICMPv6_Redirected* McOpt_ICMPv6_Redirected::create(CSTR key){
	McOpt_ICMPv6_Redirected* mc = new McOpt_ICMPv6_Redirected(key);
	mc->common_member();
#ifdef YDC_YET_IMPL
	//request to define MmReserved
	mc->member( new MmReserved( "Reserved", OCTET6,
			new PvZERO(),
			new PvZERO() ) );
#else
	//Sorry devide two MmUint(16bits,32bits)
	mc->member( new MmUint( "Reserved1",	16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Reserved2",	32,	UN(0),	UN(0) ) );
#endif
	mc->member( new MmPayload( "payload" ) );
	// dict
	MmOption_onICMPv6::add(mc);		//Upp_ICMPv6_XX::option=
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McOpt_ICMPv6_AdvertisementInterval* McOpt_ICMPv6_AdvertisementInterval::create(CSTR key) {
	McOpt_ICMPv6_AdvertisementInterval* mc = new McOpt_ICMPv6_AdvertisementInterval(key);
	mc->common_member();
	mc->member( new MmUint( "Reserved",			16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "AdvertisementInterval",	32,	UN(0),	UN(0) ) );
	MmOption_onICMPv6::add(mc);
	return mc;
}

//////////////////////////////////////////////////////////////////////////////
McOpt_ICMPv6_HomeAgentInformation* McOpt_ICMPv6_HomeAgentInformation::create(CSTR key) {
McOpt_ICMPv6_HomeAgentInformation* mc = new McOpt_ICMPv6_HomeAgentInformation(key);
	mc->common_member();
	mc->member( new MmUint( "Reserved",		16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "HomeAgentPreference",	16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "HomeAgentLifetime",	16,	UN(0),	UN(0) ) );
	MmOption_onICMPv6::add(mc);
	return mc;
}


//////////////////////////////////////////////////////////////////////////////
McUpp_UDP* McUpp_UDP::create(CSTR key,CSTR tophdrkey){
	addCompound(tophdr_ = McTopHdr_UDP::create(tophdrkey));
	McUpp_UDP* mc = new McUpp_UDP(key);
	mc->member( new MmTopHdr(	"header",tophdr_ ) );
	mc->member( new MmPayload(	"payload" ) );
	// dict
	MmUpper_onIP::add(mc);			//Packet_IP::upper=
	return mc;}

McTopHdr_UDP* McTopHdr_UDP::create(CSTR key){
	McTopHdr_UDP* mc = new McTopHdr_UDP(key);
	mc->member( new MmUint( "SourcePort",	16,	MUST(),	MUST() ) );
	mc->member( new MmUint( "DestinationPort",16,	MUST(),	MUST() ) );
	mc->Layerlength_member(
		    new MmUint( "Length",	16,
			GENEHC(mc,McTopHdr_UDP,Length), EVALANY() ) );
	mc->member( new MmUppChecksum( "Checksum",16, DEF_OPTCHKSUM ) );
	// no dict
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_TCP* McUpp_TCP::create(CSTR key,CSTR tophdrkey){
	addCompound(tophdr_ = McTopHdr_TCP::create(tophdrkey));
	McUpp_TCP* mc = new McUpp_TCP(key);
	mc->member( new MmTopHdr(	"header",tophdr_ ) );
	mc->member( new MmPayload(	"payload" ) );
	// dict
	MmUpper_onIP::add(mc);			//Packet_IP::upper=
	return mc;}

McTopHdr_TCP* McTopHdr_TCP::create(CSTR key){
	McTopHdr_TCP* mc = new McTopHdr_TCP(key);
	mc->member( new MmUint( "SourcePort",	16,	MUST(),	MUST() ) );
	mc->member( new MmUint( "DestinationPort",16,	MUST(),	MUST() ) );
	mc->member( new MmUint( "SequenceNumber",32,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "AcknowledgmentNumber",32,UN(0),UN(0) ) );
	mc->length_member(
		    new MmUint( "DataOffset",	4,
			GENEHC(mc,McTopHdr_TCP,DataOffset), EVALANY() ) );
	mc->member( new MmUint( "Reserverd",	6,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "URGFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "ACKFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "PSHFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "RSTFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "SYNFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "FINFlag",	1,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Window",	16,	UN(0),	UN(0) ) );
	mc->member( new MmUppChecksum( "Checksum",16) );
	mc->member( new MmUint( "UrgentPointer",16,	UN(0),	UN(0) ) );
	mc->member( new MmOption_onTCP( "option" ) );
	mc->member( new MmData( "Padding",DEF_EVALSKIP ) );
	// no dict
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McPacket_ARP* McPacket_ARP::create(CSTR key,CSTR tophdrkey){
	addCompound(tophdr_ = McTopHdr_ARP::create(tophdrkey));
	McPacket_ARP* mc = new McPacket_ARP(key);
	mc->member( new MmTopHdr(	"header",tophdr_) );
	// dict
	MmPacket_onEther::add(mc);		//Frame_Ether::packet=
	return mc;}

McTopHdr_ARP* McTopHdr_ARP::create(CSTR key){
	McTopHdr_ARP* mc = new McTopHdr_ARP(key);
	mc->member( new MmUint( "Hardware",	16,	UN(1),	UN(1) ) );
	mc->member( new MmUint( "Protocol",	16,	UN(2048),UN(2048) ) );
	mc->member( new MmUint( "HLEN",		8,	UN(6),	UN(6) ) );
	mc->member( new MmUint( "PLEN",		8,	UN(4),	UN(4) ) );
	mc->member( new MmUint( "Operation",	16,	UN(2),	UN(1) ) );
	mc->member( new MmEther("SenderHAddr",		ETTN(),	ETNUT()));
	mc->member( new MmV4Addr("SenderPAddr",		UN(0),	UN(0) ) );
	mc->member( new MmEther("TargetHAddr",		ETNUT(),ETTN()));
	mc->member( new MmV4Addr("TargetPAddr",		UN(0),	UN(0) ) );
	// no dict
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McPacket_RARP* McPacket_RARP::create(CSTR key,CSTR tophdrkey){
	addCompound(tophdr_ = McTopHdr_RARP::create(tophdrkey));
	McPacket_RARP* mc = new McPacket_RARP(key);
	mc->member( new MmTopHdr(	"header",tophdr_) );
	// dict
	MmPacket_onEther::add(mc);		//Frame_Ether::packet=
	return mc;}

McTopHdr_RARP* McTopHdr_RARP::create(CSTR key){
	McTopHdr_RARP* mc = new McTopHdr_RARP(key);
	mc->member( new MmUint( "Hardware",	16,	UN(1),	UN(1) ) );
	mc->member( new MmUint( "Protocol",	16,	UN(2048),UN(2048) ) );
	mc->member( new MmUint( "HLEN",		8,	UN(6),	UN(6) ) );
	mc->member( new MmUint( "PLEN",		8,	UN(4),	UN(4) ) );
	mc->member( new MmUint( "Operation",	16,	UN(3),	UN(4) ) );
	mc->member( new MmEther("SenderHAddr",		ETTN(),	ETNUT()));
	mc->member( new MmV4Addr("SenderPAddr",		UN(0),	UN(0) ) );
	mc->member( new MmEther("TargetHAddr",		ETNUT(),ETTN()));
	mc->member( new MmV4Addr("TargetPAddr",		UN(0),	UN(0) ) );
	// no dict
	return mc;}

//////////////////////////////////////////////////////////////////////////////
void McUpp_ICMPv4::common_member(){
	int32_t Type = icmpv4Type();
	type_member(
		new MmUint( "Type",		8,	UN(Type),UN(Type) ) );
	member( new MmUint( "Code",		8,	UN(0),	UN(0) ) );
	member( new MmUppChecksum( "Checksum",	16,
			DEF_MUSTCHKSUM, DEF_NOPSEUDO ) );
	}

McUpp_ICMPv4_ANY* McUpp_ICMPv4_ANY::create(CSTR key){
	McUpp_ICMPv4_ANY* mc = new McUpp_ICMPv4_ANY(key);
	mc->common_member();
	mc->member( new MmData( "data" ) );
	//dict
	MmHeader_onICMPv4::add_other(mc);	//Upp_ICMPv4::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv4_DestinationUnreachable* McUpp_ICMPv4_DestinationUnreachable::create(CSTR key){
	McUpp_ICMPv4_DestinationUnreachable* mc =
		new McUpp_ICMPv4_DestinationUnreachable(key);
	mc->common_member();
	mc->member( new MmUint( "Unused",	32,	UN(0),	UN(0) ) );
	mc->member( new MmPayload( "payload" ) );
	//dict
	MmHeader_onICMPv4::add(mc);		//Upp_ICMPv4::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv4_TimeExceeded* McUpp_ICMPv4_TimeExceeded::create(CSTR key){
	McUpp_ICMPv4_TimeExceeded* mc = new McUpp_ICMPv4_TimeExceeded(key);
	mc->common_member();
	mc->member( new MmUint( "Unused",	32,	UN(0),	UN(0) ) );
	mc->member( new MmPayload( "payload" ) );
	//dict
	MmHeader_onICMPv4::add(mc);		//Upp_ICMPv4::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv4_ParameterProblem* McUpp_ICMPv4_ParameterProblem::create(CSTR key){
	McUpp_ICMPv4_ParameterProblem* mc =
		new McUpp_ICMPv4_ParameterProblem(key);
	mc->common_member();
	mc->member( new MmUint( "Pointer",	8,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "Unused",	24,	UN(0),	UN(0) ) );
	mc->member( new MmPayload( "payload" ) );
	//dict
	MmHeader_onICMPv4::add(mc);		//Upp_ICMPv4::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
McUpp_ICMPv4_Redirect* McUpp_ICMPv4_Redirect::create(CSTR key){
	McUpp_ICMPv4_Redirect* mc = new McUpp_ICMPv4_Redirect(key);
	mc->common_member();
	mc->member( new MmV4Addr("GatewayInternetAddress", MUST(), MUST() ) );
	mc->member( new MmPayload( "payload" ) );
	//dict
	MmHeader_onICMPv4::add(mc);		//Upp_ICMPv4::header= (upper=)
	return mc;}

//////////////////////////////////////////////////////////////////////////////
template<uint32_t TYPE>
McUpp_ICMPv4_Echo<TYPE>* McUpp_ICMPv4_Echo<TYPE>::create(CSTR key){
	McUpp_ICMPv4_Echo<TYPE>* mc = new McUpp_ICMPv4_Echo<TYPE>(key);
	mc->common_member();
	mc->member( new MmUint( "Identifier",	16,	UN(0),	UN(0) ) );
	mc->member( new MmUint( "SequenceNumber",16,	UN(0),	UN(0) ) );
	mc->member( new MmPayload( "payload" ) );
	//dict
	MmHeader_onICMPv4::add(mc);		//Upp_ICMPv4::header= (upper=)
	return mc;}
