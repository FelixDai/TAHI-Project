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
#include "McIPv6.h"
#include "ItPosition.h"
#include "WObject.h"
#include "RObject.h"
#include "PControl.h"
#include "PvObject.h"
#include "PvOctets.h"
#include <stdio.h>

#define DEF_ALIGNMENT_IPv6	8

//////////////////////////////////////////////////////////////////////////////
#define SUPER	McPacket
McPacket_IPv6* McPacket_IPv6::instance_=0;
McTopHdr_IPv6* McPacket_IPv6::tophdr_=0;
McPacket_IPv6::McPacket_IPv6(CSTR s):SUPER(s) {instance_=this;}
McPacket_IPv6::~McPacket_IPv6() {if(instance_==this)instance_=0;}

// COMPOSE/REVERSE
uint32_t McPacket_IPv6::length_for_reverse(
		RControl& c,ItPosition& at,OCTBUF& buf) const{
	uint32_t length = tophdr_->Layerlength_for_reverse(c,at,buf);
	return length;}

RObject* McPacket_IPv6::reverseRc(RControl& c,
		RObject* r_parent,const ItPosition& at,PvObject* pv)const{
	RcPacket_IP* rc = new RcPacket_IP(r_parent,this,at,pv);
	c.set_IPinfo(rc->IPinfo());
	return rc;}

WObject* McPacket_IPv6::composeWc(WControl& c,
		WObject* w_parent,const PObject* pc) const {
	WcPacket_IP* wc = new WcPacket_IP(w_parent,this,pc);
	c.set_IPinfo(wc->IPinfo());
	return wc;}

RObject* McPacket_IPv6::reverse(RControl& c,
		RObject* r_parent,ItPosition& at,OCTBUF& buf)const{
	Con_IPinfo* keep = c.IPinfo();
	RcPacket_IP* rc = (RcPacket_IP*)SUPER::reverse(c,r_parent,at,buf);
	if(!c.error()){
		Con_IPinfo* info = rc->IPinfo();
		info->reverse_postAHICV(c,rc);}
	c.set_IPinfo(keep);
	return rc;}

WObject* McPacket_IPv6::compose(WControl& c,
		WObject* w_parent,const PObject* pc) const{
	Con_IPinfo* keep = c.IPinfo();
	WObject* rtn = SUPER::compose(c,w_parent,pc);
	c.set_IPinfo(keep);
	return rtn;}

bool McPacket_IPv6::generate(WControl& c,WObject* w_self,OCTBUF& buf) const {
	Con_IPinfo* keep = c.IPinfo();
	WcPacket_IP* wc = (WcPacket_IP*)w_self;
	c.set_IPinfo(wc->IPinfo());
	bool rtn = SUPER::generate(c,w_self,buf);
	if(!c.error()){
		Con_IPinfo* info = wc->IPinfo();
		info->generate_postAHICV(c,buf,wc);}
	c.set_IPinfo(keep);
	return rtn;}

bool McPacket_IPv6::overwrite_ICV(ICVControl&,
		const ItPosition&,OCTBUF&,const TObject*)const{
	return true;}//useless overwrite tunnelPacket

#undef SUPER

//----------------------------------------------------------------------------
#define SUPER	McHeader

McTopHdr_IPv6::McTopHdr_IPv6(CSTR key):SUPER(key),Layerlength_(0){}
McTopHdr_IPv6::~McTopHdr_IPv6(){}
uint32_t McTopHdr_IPv6::alignment_requirement() const{
	McHeader::provisional_AH_alignment_v4_v6_=DEF_ALIGNMENT_IPv6;
	return DEF_ALIGNMENT_IPv6;}

// COMPOSE/REVERSE
uint32_t McTopHdr_IPv6::Layerlength_for_reverse(
			RControl& c,ItPosition& at,OCTBUF& buf) const {
	if(!Layerlength_)return SUPER::Layerlength_for_reverse(c,at,buf);
	uint32_t remainlen	= buf.remainLength(at.bytes()); 
	uint32_t Payloadlen	= Layerlength_->value(at,buf);
	uint32_t hdrlen		= length_for_reverse(c,at,buf);
//TAHI_SPEC if (Payloadlen==0 JumboPayload) then use remainlen
	uint32_t Layerlength	= Payloadlen ? (Payloadlen+hdrlen) : remainlen;
	return Layerlength;}

bool McTopHdr_IPv6::HCGENE(PayloadLength)(
		WControl& cntr,WObject* wmem,OCTBUF& buf) const{
	WObject* wc		= wmem->parent();	//TopHdr_IPv6
	uint32_t hdrlen		= wc->size().bytes();
	WObject* packet		= wc->parent();		//Packet_IPv6
	uint32_t pktlen		= packet->size().bytes();
	uint32_t valulen	= pktlen - hdrlen;
	PvNumber def(valulen);
	return def.generate(cntr,wmem,buf);}

bool McTopHdr_IPv6::HCGENE(NextHeader)(WControl& cntr,WObject* wmem,OCTBUF& buf) const{
	int32_t val		= get_next_headerType(wmem);
	if(val==-1)return false;
	PvNumber def(val);
	return def.generate(cntr,wmem,buf);}
PObject* McTopHdr_IPv6::HCEVAL(NextHeader)(WObject* wmem) const{
	int32_t val		= get_next_headerType(wmem);
	return new PvNumber(val);}

void McTopHdr_IPv6::HC_ForIPinfo(SourceAddress)(
		Con_IPinfo& info,TObject* tmem) const {
	const PvObject* pv = tmem->pvalue();
	info.SrcAddr(pv);}
void McTopHdr_IPv6::HC_ForIPinfo(DestinationAddress)(
		Con_IPinfo& info,TObject* tmem) const {
	const PvObject* pv = tmem->pvalue();
	info.DstAddr(pv);}

bool McTopHdr_IPv6::overwrite_ICV(ICVControl& c,
		const ItPosition& at,OCTBUF& buf,const TObject* t)const{
	return t->overwrite_ICV_child(c,at,buf);}

bool McTopHdr_IPv6::HC_OWICV(DestinationAddress)(ICVControl& c,
		const ItPosition& at,OCTBUF& buf,const TObject* t)const{
	const OCTBUF* last = (const OCTBUF*)c.LastDstAddr();
	if(last)buf.encode(at,*last);
	const PvObject* shift = t->pvalue();
	c.ShiftRoutAddr(shift);
	return true;}

#undef SUPER

//////////////////////////////////////////////////////////////////////////////
#define DEF_LENGTH_ELEM_Ext	8
#define DEF_LENGTH_OFFSET_Ext	8

#define SUPER	McHeader
McHdr_Ext::McHdr_Ext(CSTR key):SUPER(key),length_(0){}
McHdr_Ext::~McHdr_Ext(){}
uint32_t McHdr_Ext::alignment_requirement() const{
	return DEF_ALIGNMENT_IPv6;}//exclude ESP

// COMPOSE/REVERSE
uint32_t McHdr_Ext::length_for_reverse(
		RControl& c,ItPosition& at,OCTBUF& buf)const{
	if(!length_)return SUPER::length_for_reverse(c,at,buf);
	uint32_t valulen= length_->value(at,buf);
	uint32_t length	= (valulen*DEF_LENGTH_ELEM_Ext)+DEF_LENGTH_OFFSET_Ext;
	return length;}

bool McHdr_Ext::HCGENE(NextHeader)(WControl& cntr,WObject* wmem,OCTBUF& buf) const{
	int32_t val	= get_next_headerType(wmem);
	if(val==-1)return false;
	PvNumber def(val);
	return def.generate(cntr,wmem,buf);}
PObject* McHdr_Ext::HCEVAL(NextHeader)(WObject* wmem) const{
	int32_t val	= get_next_headerType(wmem);
	return new PvNumber(val);}

bool McHdr_Ext::HCGENE(HeaderExtLength)(
			WControl& cntr,WObject* wmem,OCTBUF& buf) const{
	WObject* wc	= wmem->parent();	//Hdr_Ext_XX
	uint32_t reallen= wc->size().bytes();
	uint32_t valulen= (reallen-DEF_LENGTH_OFFSET_Ext)/DEF_LENGTH_ELEM_Ext;
	PvNumber def(valulen);
	return def.generate(cntr,wmem,buf);}

bool McHdr_Ext::overwrite_ICV(ICVControl& c,
		const ItPosition& at,OCTBUF& buf,const TObject* t)const{
	return t->overwrite_ICV_child(c,at,buf);}
#undef SUPER

#define SUPER	McHdr_Ext
//----------------------------------------------------------------------------
McHdr_Ext_HopByHop::McHdr_Ext_HopByHop(CSTR key):SUPER(key){}
McHdr_Ext_HopByHop::~McHdr_Ext_HopByHop(){}

//----------------------------------------------------------------------------
McHdr_Ext_Destination::McHdr_Ext_Destination(CSTR key):SUPER(key){}
McHdr_Ext_Destination::~McHdr_Ext_Destination(){}

//----------------------------------------------------------------------------
McHdr_Ext_Routing::McHdr_Ext_Routing(CSTR key):SUPER(key){}
McHdr_Ext_Routing::~McHdr_Ext_Routing(){}

uint32_t McHdr_Ext_Routing::HC_MLC(Address)(
		const ItPosition& at,OCTBUF& buf)const{
	uint32_t length=length_->value(at,buf);
	return length/2;}

void McHdr_Ext_Routing::HC_ForIPinfo(SegmentsLeft)(
		Con_IPinfo& info,TObject* tmem) const {
	const PvNumber* pv = (const PvNumber*)tmem->pvalue();
	uint32_t segmentsleft = pv->value();
	bool isLeft = segmentsleft>0;
	info.Route_isLeft(isLeft);}
void McHdr_Ext_Routing::HC_ForIPinfo(Address)(
		Con_IPinfo& info,TObject* tmem) const {
	const PvObject* pv = tmem->pvalue();
	if(info.Route_isLeft()){
		info.LastDstAddr(pv);}
	}

bool McHdr_Ext_Routing::overwrite_ICV(ICVControl& c,
		const ItPosition& at,OCTBUF& buf,const TObject* t)const{
	uint32_t count = HC_MLC(Address)(at,buf);
	c.RoutAddrmax(count);
	c.RoutAddrindex(0);
	c.SegmentsLeft(0);
	return SUPER::overwrite_ICV(c,at,buf,t);}

bool McHdr_Ext_Routing::HC_OWICV(SegmentsLeft)(ICVControl& c,
		const ItPosition& at,OCTBUF& buf,const TObject* t)const{
	uint32_t lastnodevalue=0;
	const MmUint* m = (const MmUint*)t->meta();
	m->encode(lastnodevalue,at,buf);
	//
	const PvNumber* pv = (const PvNumber*)t->pvalue();
	uint32_t value = pv->value();
	c.SegmentsLeft(value);
	return true;}

bool McHdr_Ext_Routing::HC_OWICV(Address)(ICVControl& c,
		const ItPosition& at,OCTBUF& buf,const TObject* t)const{
	bool isShift = c.isShift_RoutAddr();
	if(isShift){
		const OCTBUF* shift = (const OCTBUF*)c.ShiftRoutAddr();
		if(shift)buf.encode(at,*shift);
		const PvObject* next = t->pvalue();
		c.ShiftRoutAddr(next);} //next ShiftRoutAddr
	c.inc_RoutAddrindex();
	return true;}

//----------------------------------------------------------------------------
McHdr_Ext_Fragment::McHdr_Ext_Fragment(CSTR key):SUPER(key){}
McHdr_Ext_Fragment::~McHdr_Ext_Fragment(){}

// COMPOSE/REVERSE
RObject* McHdr_Ext_Fragment::reverse(RControl& c,
		RObject* r_parent,ItPosition& at,OCTBUF& buf)const{
	RObject* r_self = SUPER::reverse(c,r_parent,at,buf);
	c.DictType().other_Set(); // nextType must overewrite other(McPayload)
	return r_self;}

bool McHdr_Ext_Fragment::overwrite_ICV(ICVControl&,
		const ItPosition&,OCTBUF&,const TObject*)const{
	fprintf(stderr,"err:unable calculate ICV with %s\n",string());
	return false;}

#undef SUPER

//////////////////////////////////////////////////////////////////////////////
#define DEF_LENGTH_OFFSET_OptExt	2

#define SUPER	McOption
McOpt_Ext::McOpt_Ext(CSTR key):SUPER(key),type_(0),length_(0){}
McOpt_Ext::~McOpt_Ext(){}

// COMPOSE/REVERSE
uint32_t McOpt_Ext::length_for_reverse(
		RControl& c,ItPosition& at,OCTBUF& buf) const{
	if(!length_)return SUPER::length_for_reverse(c,at,buf);
	uint32_t valulen	= length_->value(at,buf);
	uint32_t length		= valulen+DEF_LENGTH_OFFSET_OptExt;
	return length;}

bool McOpt_Ext::HCGENE(OptDataLength)(WControl& cntr,WObject* wmem,OCTBUF& buf) const{
	WObject* wc = wmem->parent();
	uint32_t reallen	= wc->size().bytes();
	uint32_t valulen	= reallen-DEF_LENGTH_OFFSET_OptExt;
	PvNumber def(valulen);
	return def.generate(cntr,wmem,buf);}

bool McOpt_Ext::overwrite_DictType(
		RControl& c,ItPosition& at,OCTBUF& buf)const{
	uint32_t limit = buf.remainLength(at.bytes());
	if(limit==0)return false;		//End of Ext Header
	//
	ItPosition tmpat=at;
	RObject* rtype = type_->reverse(c,0,tmpat,buf);
	if(!rtype)return false;			//Type field decode error
	//
	const PvNumber* pv = (const PvNumber*)rtype->pvalue();
	uint32_t typevalue = pv->value();
	c.DictType().type_Set(typevalue);       //self Type set
	delete rtype;
	return true;}

bool McOpt_Ext::overwrite_ICV(ICVControl& c,
		const ItPosition& at,OCTBUF& buf,const TObject* t)const{
	uint32_t typeval = type_ ? type_->value(at,buf) : 0;
	bool isZero = !!(typeval&0x00000020);
	c.isZero_ExtOptData(isZero);
	bool rtn = t->overwrite_ICV_child(c,at,buf);
	c.isZero_ExtOptData(false);
	return rtn;}

bool McOpt_Ext::HC_OWICV(OptExtData)(ICVControl& c,
		const ItPosition& at,OCTBUF& buf,const TObject* t)const{
	bool isZero = c.isZero_ExtOptData();
	ICV_Zero owzero;
	return isZero ? owzero.overwrite(c,at,buf,t) : true;}

#undef SUPER

#define SUPER	McOpt_Ext
//----------------------------------------------------------------------------
McOpt_Ext_ANY::McOpt_Ext_ANY(CSTR key):SUPER(key){}
McOpt_Ext_ANY::~McOpt_Ext_ANY(){}

//----------------------------------------------------------------------------
McOpt_Ext_Pad1::McOpt_Ext_Pad1(CSTR key):SUPER(key){}
McOpt_Ext_Pad1::~McOpt_Ext_Pad1(){}

//----------------------------------------------------------------------------
McOpt_Ext_PadN::McOpt_Ext_PadN(CSTR key):SUPER(key){}
McOpt_Ext_PadN::~McOpt_Ext_PadN(){}

//----------------------------------------------------------------------------
#define DEF_ALIGNMENT_OptExt_JumboPayload	4
McOpt_Ext_JumboPayload::McOpt_Ext_JumboPayload(CSTR key):SUPER(key){}
McOpt_Ext_JumboPayload::~McOpt_Ext_JumboPayload(){}
uint32_t McOpt_Ext_JumboPayload::alignment_requirement() const{
	//now return fixvalue ("JumboPayloadLength" 4byte)
	return DEF_ALIGNMENT_OptExt_JumboPayload;}

bool McOpt_Ext_JumboPayload::HCGENE(JumboPayloadLength)(
		WControl& cntr,WObject* wmem,OCTBUF& buf) const{
	WObject* opt	= wmem->parent();		//Opt_Ext_JumboPayload
	WObject* hdr	= opt->parent();		//Hdr_Ext_HopByHop
	uint32_t offset	= hdr->distance();
	WObject* packet	= hdr->parent();		//Packet_IPv6
	uint32_t pktlen	= packet->size().bytes();
	uint32_t valulen= pktlen-offset;
	PvNumber def(valulen);
	return def.generate(cntr,wmem,buf);}

//----------------------------------------------------------------------------
#define DEF_ALIGNMENT_OptExt_RouterAlert	2
McOpt_Ext_RouterAlert::McOpt_Ext_RouterAlert(CSTR key):SUPER(key){}
McOpt_Ext_RouterAlert::~McOpt_Ext_RouterAlert(){}
uint32_t McOpt_Ext_RouterAlert::alignment_requirement() const{
	//now return fixvalue ("Value" 2byte)
	return DEF_ALIGNMENT_OptExt_RouterAlert;}

//----------------------------------------------------------------------------
#define DEF_ALIGNMENT_OptExt_TunnelEncap	2
McOpt_Ext_TunnelEncap::McOpt_Ext_TunnelEncap(CSTR key):SUPER(key){}
McOpt_Ext_TunnelEncap::~McOpt_Ext_TunnelEncap(){}
uint32_t McOpt_Ext_TunnelEncap::alignment_requirement() const{
	//now return fixvalue ("Value" 2byte)
	return DEF_ALIGNMENT_OptExt_TunnelEncap;}

//----------------------------------------------------------------------------
#define DEF_ALIGNMENT_Opt_Ext_MIPBindingUpdate 4

McOpt_Ext_MIPBindingUpdate::McOpt_Ext_MIPBindingUpdate(CSTR key):SUPER(key){}
McOpt_Ext_MIPBindingUpdate::~McOpt_Ext_MIPBindingUpdate(){}

#if 0
uint32_t McOpt_Ext_MIPBindingUpdate::alignment_requirement() const{
	return DEF_ALIGNMENT_Opt_Ext_MIPBindingUpdate;
}
#endif

//----------------------------------------------------------------------------
#define DEF_ALIGNMENT_Opt_Ext_MIPBindingAck 4

McOpt_Ext_MIPBindingAck::McOpt_Ext_MIPBindingAck(CSTR key):SUPER(key){}
McOpt_Ext_MIPBindingAck::~McOpt_Ext_MIPBindingAck(){}

#if 0
uint32_t McOpt_Ext_MIPBindingAck::alignment_requirement() const{
	return DEF_ALIGNMENT_Opt_Ext_MIPBindingAck;
}
#endif

//----------------------------------------------------------------------------
McOpt_Ext_MIPBindingReq::McOpt_Ext_MIPBindingReq(CSTR key):SUPER(key){}
McOpt_Ext_MIPBindingReq::~McOpt_Ext_MIPBindingReq(){}

//----------------------------------------------------------------------------
#define DEF_ALIGNMENT_Opt_Ext_MIPHomeAddress 8

McOpt_Ext_MIPHomeAddress::McOpt_Ext_MIPHomeAddress(CSTR key):SUPER(key){}
McOpt_Ext_MIPHomeAddress::~McOpt_Ext_MIPHomeAddress(){}

#if 0
uint32_t McOpt_Ext_MIPHomeAddress::alignment_requirement() const{
	return DEF_ALIGNMENT_Opt_Ext_MIPHomeAddress;
}
#endif

#undef SUPER

///////////////////////////////////////////////////////////////////////////////
MmOption_onExt::MmOption_onExt(CSTR key):MmReference_More0(key,true) {}
MmOption_onExt::~MmOption_onExt() {}

void MmOption_onExt::add(McOpt_Ext* mc){
	dict_.add(mc->optionType(),mc);}
void MmOption_onExt::add_other(McOpt_Ext* mc){dict_.add_other(mc);}
TypevsMcDict MmOption_onExt::dict_;

// REVERSE
bool MmOption_onExt::overwrite_DictType(
		RControl& c,ItPosition& at,OCTBUF& buf)const{
	McOpt_Ext* any = (McOpt_Ext*)dict_.find_other();
	return any->overwrite_DictType(c,at,buf);}

///////////////////////////////////////////////////////////////////////////////
