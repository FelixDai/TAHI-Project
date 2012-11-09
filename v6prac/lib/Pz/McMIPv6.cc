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
#include "McMIPv6.h"
#include "ItPosition.h"
#include "WObject.h"
#include "RObject.h"
#include "PControl.h"
#include "PvObject.h"
#include "PvOctets.h"

//////////////////////////////////////////////////////////////////////////////
#define DEF_ALIGNMENT_OptMIP		8
#define DEF_LENGTH_ELEM_OptMIP	2

McOpt_MIP::McOpt_MIP(CSTR key):McOption(key),type_(0),length_(0){}
McOpt_MIP::~McOpt_MIP(){}

// COMPOSE/REVERSE
uint32_t McOpt_MIP::length_for_reverse(
		RControl& c,ItPosition& at,OCTBUF& buf) const{
	if(!length_)return McOption::length_for_reverse(c,at,buf);
	uint32_t valulen	= length_->value(at,buf);
	uint32_t length		= valulen+DEF_LENGTH_ELEM_OptMIP;
	return length;}

bool McOpt_MIP::overwrite_DictType(
		RControl& c,ItPosition& at,OCTBUF& buf)const{
	uint32_t limit = buf.remainLength(at.bytes());
	if(limit==0)return false;		//End of MIP Header
	//
	ItPosition tmpat=at;
	RObject* rtype = type_->reverse(c,0,tmpat,buf);
	if(!rtype)return false;			//Type field decode error
	//
	const PvNumber* pv = (const PvNumber*)rtype->pvalue();
	uint32_t typevalue = pv->value();
	c.DictType().type_Set(typevalue);	//self Type set
	delete rtype;
	return true;}

bool McOpt_MIP::HCGENE(Length)(
		WControl& cntr,WObject* wmem,OCTBUF& buf) const{
	WObject* wc = wmem->parent();
	uint32_t reallen	= wc->size().bytes();
	uint32_t valulen	= reallen-DEF_LENGTH_ELEM_OptMIP;
	PvNumber def(valulen);
	return def.generate(cntr,wmem,buf);}

//////////////////////////////////////////////////////////////////////////////
McOpt_MIP_ANY::McOpt_MIP_ANY(CSTR key):McOpt_MIP(key){}
McOpt_MIP_ANY::~McOpt_MIP_ANY(){}

//////////////////////////////////////////////////////////////////////////////
McOpt_MIP_Pad1::McOpt_MIP_Pad1(CSTR key):McOpt_MIP(key){}
McOpt_MIP_Pad1::~McOpt_MIP_Pad1(){}

//////////////////////////////////////////////////////////////////////////////
McOpt_MIP_PadN::McOpt_MIP_PadN(CSTR key):McOpt_MIP(key){}
McOpt_MIP_PadN::~McOpt_MIP_PadN(){}

//////////////////////////////////////////////////////////////////////////////
#define DEF_ALIGNMENT_Opt_MIP_UniqID 2

McOpt_MIP_UniqID::McOpt_MIP_UniqID(CSTR key):McOpt_MIP(key){}
McOpt_MIP_UniqID::~McOpt_MIP_UniqID(){}

#if 0
uint32_t McOpt_MIP_UniqID::alignment_requirement() const{
	return DEF_ALIGNMENT_Opt_MIP_UniqID;
}
#endif

//////////////////////////////////////////////////////////////////////////////
#define DEF_ALIGNMENT_Opt_MIP_AlternateCareOfAddr 8

McOpt_MIP_AlternateCareOfAddr::McOpt_MIP_AlternateCareOfAddr(CSTR key):McOpt_MIP(key){}
McOpt_MIP_AlternateCareOfAddr::~McOpt_MIP_AlternateCareOfAddr(){}

#if 0
uint32_t McOpt_MIP_AlternateCareOfAddr::alignment_requirement() const{
	return DEF_ALIGNMENT_Opt_MIP_AlternateCareOfAddr;
}
#endif

//////////////////////////////////////////////////////////////////////////////
MmOption_onMIP::MmOption_onMIP(CSTR key):MmReference_More0(key,true) {}
MmOption_onMIP::~MmOption_onMIP() {}

void MmOption_onMIP::add(McOpt_MIP* mc){
	dict_.add(mc->optionType(),mc);}
void MmOption_onMIP::add_other(McOpt_MIP* mc){dict_.add_other(mc);}
TypevsMcDict MmOption_onMIP::dict_;

// REVERSE
bool MmOption_onMIP::overwrite_DictType(
		RControl& c,ItPosition& at,OCTBUF& buf)const{
	McOpt_MIP* any = (McOpt_MIP*)dict_.find_other();
	return any->overwrite_DictType(c,at,buf);}

