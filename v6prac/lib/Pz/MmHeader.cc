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
#include "MmHeader.h"
#include "PControl.h"
#include "PvOctets.h"
#include "WObject.h"
#include <stdio.h>

//////////////////////////////////////////////////////////////////////////////
//Must find 1 Compound

bool MmReference_Must1::containsMc(const MObject* mc)const{
	const TypevsMcDict* dict = get_dict();
	return dict->contains(mc);}

// COMPOSE
void MmReference_Must1::composeList(WControl& c,
		WObject* w_parent,const PObjectList& pls)const{
	const PObject* pl =
		pls.reverseMatching(this,(PObjectEqFunc)&PObject::isEqualMeta);
	pl ? pl->selfCompose(c,w_parent) : compose(c,w_parent,0);}

WObject* MmReference_Must1::compose(WControl& c,
		WObject* w_parent,const PObject* pl)const{
	if(!pl){w_parent->mustDefineMem(this); return 0;}	//ErrorHandling
	const PObject* right = pl->rvalue();
	if(!right){w_parent->mustDefineMem(this); return 0;}	//ErrorHandling
	const TypevsMcDict* keep = c.dict();
	c.dict_set(get_dict());	//set composeable Mc type dict
	WObject* wc = right->selfCompose(c,w_parent);	//forward to right
	c.dict_set(keep);
	return wc;}

// REVERSE
RObject* MmReference_Must1::reverse(RControl& c,
		RObject* r_parent,ItPosition& at,OCTBUF& buf)const{
	RObject* rc=0;
	const TypevsMcDict* dict = get_dict();
	Con_DictType keep = c.DictType();
	if(overwrite_DictType(c,at,buf)){
		MObject* mc = dict->find(c.DictType());
		if(!mc)find_error(c);
		rc = mc ? mc->reverse(c,r_parent,at,buf) : 0;}//forward to Mc
	if(keepType_)c.DictType() = keep;//keep nexttype from overwrite_DictType
	return rc;}

void MmReference_Must1::find_error(RControl& c)const{
	const Con_DictType& Dtype = c.DictType();
	/**/ if(Dtype.uneffect()){
		fprintf(stderr,"err:%s.%s Type is not set by before compound\n",
			compound()->string(),string());}
	else if(Dtype.finish()){
		fprintf(stderr,"err:%s.%s can not find Needless type of finish\n",
			compound()->string(),string());}
	else if(Dtype.other()){
		fprintf(stderr,"err:%s.%s can not find compound as othertype\n",
			compound()->string(),string());}
	else{	fprintf(stderr,"err:%s.%s can not find compound type[%d]\n",
			compound()->string(),string(),Dtype.type());}
	c.set_error(1);
	}

//////////////////////////////////////////////////////////////////////////////
//Must find more than 0

bool MmReference_More0::containsMc(const MObject* mc)const{
	const TypevsMcDict* dict = get_dict();
	return dict->contains(mc);}

// COMPOSE
void MmReference_More0::composeList(WControl& c,
		WObject* w_parent,const PObjectList& pls)const{
	pls.elementsPerformWith(
		(PObjectFunc)&PObject::vmatchselfCompose,&c,w_parent,this);
	}

WObject* MmReference_More0::compose(WControl& c,
		WObject* w_parent,const PObject* pl)const{
	if(!pl){return 0;}					//NO Error
	const PObject* right = pl->rvalue();
	if(!right){w_parent->mustDefineMem(this); return 0;}	//ErrorHandling
	const TypevsMcDict* keep = c.dict();
	c.dict_set(get_dict());	//set composeable Mc type dict
	WObject* wc = right->selfCompose(c,w_parent);	//forward to right
	c.dict_set(keep);
	return wc;}

// REVERSE
RObject* MmReference_More0::reverse(RControl& c,
		RObject* r_parent,ItPosition& at,OCTBUF& buf)const{
	RObject* rc=0;
	const TypevsMcDict* dict = get_dict();
	Con_DictType keep = c.DictType();
	do{	rc=0;
		if(overwrite_DictType(c,at,buf)){
			MObject* mc = dict->find(c.DictType());
			if(!mc)break; //forward to Mc
			rc = mc ? mc->reverse(c,r_parent,at,buf) : 0;}
		} while(rc && c);
	if(keepType_)c.DictType() = keep;//keep nexttype from overwrite_DictType
	return rc;}

//////////////////////////////////////////////////////////////////////////////
MmFrame::MmFrame(CSTR key):MmReference_Must1(key) {}
MmFrame::~MmFrame() {}

void MmFrame::add(McObject* mc){
	dict_.add(mc->DataLinkLayer_Type(),mc);}
void MmFrame::add_other(McObject* mc){dict_.add_other(mc);}
TypevsMcDict MmFrame::dict_;

//////////////////////////////////////////////////////////////////////////////
MmPacket_onEther::MmPacket_onEther(CSTR key):MmReference_Must1(key) {}
MmPacket_onEther::~MmPacket_onEther() {}

void MmPacket_onEther::add(McObject* mc){
	dict_.add(mc->protocolType(),mc);}
void MmPacket_onEther::add_other(McObject* mc){dict_.add_other(mc);}
TypevsMcDict MmPacket_onEther::dict_;

//////////////////////////////////////////////////////////////////////////////
MmPacket_onNull::MmPacket_onNull(CSTR key):MmReference_Must1(key) {}
MmPacket_onNull::~MmPacket_onNull() {}

void MmPacket_onNull::add(McObject* mc){
	dict_.add(mc->protocolFamily(),mc);}
void MmPacket_onNull::add_other(McObject* mc){dict_.add_other(mc);}
TypevsMcDict MmPacket_onNull::dict_;

//////////////////////////////////////////////////////////////////////////////
MmTopHdr::MmTopHdr(CSTR key,McObject* tophdr):MmReference_Must1(key){
	dict_.add_other(tophdr);}//only add othertype
MmTopHdr::~MmTopHdr(){}

bool MmTopHdr::overwrite_DictType(RControl& c,ItPosition&,OCTBUF&)const{
	c.DictType().other_Set(); //only overwrite othertype
	return true;}

//////////////////////////////////////////////////////////////////////////////
MmExtent_onIP::MmExtent_onIP(CSTR key):MmReference_More0(key){}
MmExtent_onIP::~MmExtent_onIP(){}

void MmExtent_onIP::add(McObject* mc){
	dict_.add(mc->headerType(),mc);}
void MmExtent_onIP::add_other(McObject* mc){dict_.add_other(mc);}
TypevsMcDict MmExtent_onIP::dict_;

//////////////////////////////////////////////////////////////////////////////
MmUpper_onIP::MmUpper_onIP(CSTR key):MmReference_Must1(key){}
MmUpper_onIP::~MmUpper_onIP(){}

void MmUpper_onIP::add(McObject* mc){
	dict_.add(mc->headerType(),mc);}
void MmUpper_onIP::add_other(McObject* mc){dict_.add_other(mc);}
TypevsMcDict MmUpper_onIP::dict_;

//////////////////////////////////////////////////////////////////////////////
MmPayload::MmPayload(CSTR key):MmReference_Must1(key,true) {}
MmPayload::~MmPayload() {}

void MmPayload::add_other(McObject* mc){dict_.add_other(mc);}
TypevsMcDict MmPayload::dict_;

bool MmPayload::overwrite_DictType(RControl& c,ItPosition&,OCTBUF&)const{
	c.DictType().other_Set(); //othertype overwrite
	return true;}

