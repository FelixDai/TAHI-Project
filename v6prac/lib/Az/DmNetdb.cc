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
#include "DmNetdb.h"
#include <stdio.h>
#include <netdb.h>
#include <sys/socket.h>
#include "PObject.h"
#include "PvOctets.h"
#include "McObject.h"
void DmNetdb::describe(const MObject* m,const PObject* o) const {
	if(o==0) return;
	if(convert())	{describeConvert(m,o);}
	else		{DmName::describe(m,o);}}

void DmNetdb::describeConvert(const MObject* m,const PObject* o) const {
	DmName::describe(m,o);}

void DmPort::describeConvert(const MObject* m,const PObject* o) const {
	if(o==0) return;
	bool bl=false;
	int32_t port=o->intValue(bl);
	PortName* pn=0;
	if(bl) {pn=lookup(port,protocol());}
	if(pn==0) {DmNetdb::describeConvert(m,o);}
	else {
		CSTR s=name();
		printf(" %s%s",s!=0?s:"",pn->name());}}

void DmAddr::describeConvert(const MObject* m,const PObject* o) const {
	if(o==0) return;
	OctetsName* on=lookup((const PvOctets*)o,dictionary());
	if(on==0) {DmNetdb::describeConvert(m,o);}
	else {
		CSTR s=name();
		printf(" %s%s",s!=0?s:"",on->name());}}

void DmNetdb::initialize() {
	static bool hasBennHere=false;
	if(hasBennHere) return;
	hasBennHere=true;
	McObject* mc=0;
	MObject* m=0;
#define mcname(a,b)if((mc=McObject::find(#a))!=0){mc->describer(new DmCompound(#b));}
#define mmv6(a,b)if((m=mc->findMember(#a))!=0){m->describer(new DmV6Addr(#b));}
#define mmv4(a,b)if((m=mc->findMember(#a))!=0){m->describer(new DmV4Addr(#b));}
#define mmname(a,b)if((m=mc->findMember(#a))!=0){m->describer(new DmName(#b));}
#define mmport(p,a,b)if((m=mc->findMember(#a))!=0){m->describer(new DmPort(#b,p));}
#define mmbool(a,b)if((m=mc->findMember(#a))!=0){m->describer(new DmBool(#b));}
	//--------------------------------------------------------------
	// Network Layer TopHeader
	mcname(Hdr_IPv6,			IPv6);
	if(mc!=0) {
		mmv6(SourceAddress,		src=);
		mmv6(DestinationAddress,	dst=);}
	mcname(Hdr_IPv4,			IPv4);
	if(mc!=0) {
		mmv4(SourceAddress,		src=);
		mmv4(DestinationAddress,	dst=);}
	//--------------------------------------------------------------
	// Extension Header
	mcname(Hdr_HopByHop,			HBH);
	mcname(Hdr_Destination,			DST);
	mcname(Hdr_Routing,			RT);
	mcname(Hdr_Fragment,			FRG);
	mcname(Hdr_AH,				AH);
	mcname(Hdr_ESP,				ESP);
	//--------------------------------------------------------------
	// ICMPv6: Upper Layer Protocol
	mcname(ICMPv6_ANY,			ICMPv6_ANY);
	mcname(ICMPv6_RS,			RS);
	mcname(ICMPv6_RA,			RA);
	mcname(ICMPv6_NS,			NS);
	mcname(ICMPv6_NA,			NA);
	mcname(ICMPv6_Redirect,			RED);
	mcname(ICMPv6_MLDQuery,			MLDQ);
	mcname(ICMPv6_MLDReport,		MLDR);
	mcname(ICMPv6_MLDDone,			MLDD);
	mcname(ICMPv6_EchoRequest,		EREQ);
	mcname(ICMPv6_EchoReply,		EREP);
	mcname(ICMPv6_DestinationUnreachable,	DUR);
	mcname(ICMPv6_TimeExceeded,		TEX);
	mcname(ICMPv6_ParameterProblem,		PP);
	mcname(ICMPv6_RouterRenumbering,	RR);
	mcname(ICMPv6_NameLookups,		NL);
	//--------------------------------------------------------------
	// TCP: Upper Layer Protocol
	mcname(Hdr_TCP,				TCP);
	if(mc!=0) {
		mmport(DmPort::tcp_,SourcePort,		src=);
		mmport(DmPort::tcp_,DestinationPort,	dst=);
		mmbool(URGFlag,			URG);
		mmbool(ACKFlag,			ACK);
		mmbool(PSHFlag,			PSH);
		mmbool(RSTFlag,			RST);
		mmbool(SYNFlag,			SYN);
		mmbool(FINFlag,			FIN);}
	//--------------------------------------------------------------
	// UDP: Upper Layer Protocol
	mcname(Hdr_UDP,				UDP);
	if(mc!=0) {
		mmport(DmPort::udp_,SourcePort,		src=);
		mmport(DmPort::udp_,DestinationPort,	dst=);}
#undef mmbool
#undef mmport
#undef mmname
#undef mmv6
#undef mcname
}

void DmPort::initialize() {
	static bool hasBennHere=false;
	if(hasBennHere) return;
	hasBennHere=true;
	DmNetdb::initialize();
	(void)setservent(1);
	struct servent* se=0;
	for(;(se=getservent())!=0;) {
		int16_t p=htons(se->s_port);
		/**/ if(strcmp(se->s_proto,"udp")==0) {
			udpSets_.filter(new PortName(p,se->s_name));}
		else if(strcmp(se->s_proto,"tcp")==0) {
			tcpSets_.filter(new PortName(p,se->s_name));}}}

PortName* DmPort::lookup(int32_t port,eProtocol prot) {
	PortName tmp((int16_t)port);
	switch(prot) {
		case none_: break;
		case udp_: return udpSets_.find(&tmp);
		case tcp_: return tcpSets_.find(&tmp);}
	return 0;}

OctetsName* DmAddr::lookup(const PvOctets* po,OctetsSet* sets) {
	if(sets==0) {return 0;}
	OctetsName tmp(po);
	OctetsName* f=sets->find(&tmp);
	if(f!=0) {return f;}
	COCTSTR os=po->string();
	uint32_t ol=po->length();
	struct hostent* h=gethostbyaddr((CSTR)os,ol,po->addressFamily());
	if(h==0) {return 0;}
	PvOctets* addr=new PvOctets(ol,(OCTSTR)os,true);
	OctetsName* on=new OctetsName(addr,h->h_name);
	return (OctetsName*)sets->filter(on);}

PortName::PortName(int16_t p,CSTR s):port_(p),name_(s) {}
uint32_t PortName::hash() const {return port_;}
bool PortName::isEqual(const PortName* o) const {return port_==o->port_;}
CSTR PortName::name() const {return name_.string();}

OctetsName::OctetsName(const PvOctets* p,CSTR s):octets_(p),name_(s) {}
uint32_t OctetsName::hash() const {return octets_->hash();}
bool OctetsName::isEqual(const OctetsName* o) const {
	return octets()->isEqual(o->octets());}
CSTR OctetsName::name() const {return name_.string();}
const PvOctets* OctetsName::octets() const {return octets_;}

const uint32_t setDefaultSize_=1024;
DmNetdb::DmNetdb(CSTR s):DmName(s) {}
DmNetdb::~DmNetdb() {}

DmPort::DmPort(CSTR s,eProtocol p):DmNetdb(s),protocol_(p) {}
DmPort::~DmPort() {}
PortSet DmPort::udpSets_(setDefaultSize_);
PortSet DmPort::tcpSets_(setDefaultSize_);

DmAddr::DmAddr(CSTR s):DmNetdb(s) {}
DmAddr::~DmAddr() {}
OctetsSet* DmAddr::dictionary() const {return 0;}

DmV6Addr::DmV6Addr(CSTR s):DmAddr(s) {}
DmV6Addr::~DmV6Addr() {}
OctetsSet* DmV6Addr::dictionary() const {return &sets_;}
OctetsSet DmV6Addr::sets_(setDefaultSize_);

DmV4Addr::DmV4Addr(CSTR s):DmAddr(s) {}
DmV4Addr::~DmV4Addr() {}
OctetsSet* DmV4Addr::dictionary() const {return &sets_;}
OctetsSet DmV4Addr::sets_(setDefaultSize_);

bool DmNetdb::convert_=false;
implementCmSet(PortSet,PortName);
implementCmSet(OctetsSet,OctetsName);
