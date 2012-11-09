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
#include "MvFunction.h"
#include "PvObject.h"
#include "PvOctets.h"
#include "PvAction.h"
#include "WObject.h"
#include "PvIfName.h"
#include "PControl.h"
#include <string.h>
#include <stdio.h>
MvOperator::MvOperator(CSTR s,int32_t t,int32_t o):MvKeyword(s,t),operation_(o) {}
MvOperator::~MvOperator() {}
PObject* MvOperator::tokenObject(int l,CSTR f) const {
	return new PvOperator(this,f,l);}

//======================================================================
MvAction::MvAction(CSTR s,int32_t t):MvKeyword(s,t) {}
MvAction::~MvAction(){}
WObject* MvAction::compose(WControl&,WObject* w_parent,const PObject* po) const {
	return new WmObject(w_parent,this,po);}

//----------------------------------------------------------------------
MvANY::MvANY(CSTR s,int32_t t):MvAction(s,t) {}
MvANY::~MvANY(){}
PObject* MvANY::tokenObject(int l,CSTR f) const {
	return new PvANY(this,f,l);}
WObject* MvANY::compose(WControl& c,WObject* w_parent,const PObject* po) const {
	return MvAction::compose(c,w_parent,po);
}

//----------------------------------------------------------------------
MvSTOP::MvSTOP(CSTR s,int32_t t):MvAction(s,t) {}
MvSTOP::~MvSTOP(){}
PObject* MvSTOP::tokenObject(int l,CSTR f) const {
	return new PvSTOP(this,f,l);}
WObject* MvSTOP::compose(WControl& c,WObject* w_parent,const PObject* po) const {
	return MvAction::compose(c,w_parent,po);
}

//----------------------------------------------------------------------
MvAUTO::MvAUTO(CSTR s,int32_t t):MvAction(s,t) {}
MvAUTO::~MvAUTO(){}
PObject* MvAUTO::tokenObject(int l,CSTR f) const {
	return new PvAUTO(this,f,l);}

//----------------------------------------------------------------------
MvFILL::MvFILL(CSTR s,int32_t t):MvAction(s,t) {}
MvFILL::~MvFILL(){}
PObject* MvFILL::tokenObject(int l,CSTR f) const {
	return new PvFILL(this,f,l);}

//----------------------------------------------------------------------
MvZERO::MvZERO(CSTR s,int32_t t):MvAction(s,t) {}
MvZERO::~MvZERO(){}
PObject* MvZERO::tokenObject(int l,CSTR f) const {
	return new PvZERO(this,f,l);}

//======================================================================
MvFunction::MvFunction(CSTR s):MObject(s) {}
MvFunction::~MvFunction() {}
int32_t MvFunction::token() const {return metaToken(tkn_function_);}
PObject* MvFunction::tokenObject(int l,CSTR f) const {
	return new PvFunction(this,f,l);}

bool MvFunction::functionGenerate(WControl& c,WObject* w,OCTBUF&,const PObjectList&) const {
	const PObject* s=w->object();
	s->generateNotAllow(string());
	c.result(1);
	return c;}

uint32_t MvFunction::objectLength(const PObject* o,const WObject* w) const {
	return o!=0?o->objectLength(w):0;}

PvObject* MvFunction::generateValue(WObject*,const PObjectList&) const {
	return 0;}

PvObject* MvFunction::evaluateValue(WObject*,const PObjectList&) const {
	return 0;}

bool MvFunction::generateV6Addr(const PObjectList&,PvV6Addr& into) const {
	into.zero();
	return false;}
bool MvFunction::evaluateV6Addr(const PObjectList&,PvV6Addr& into) const {
	into.zero();
	return false;}

bool MvFunction::generateOctetsWith(const PObjectList&,PvOctets& into,WObject*) const {
	into.zero();
	return false;}
int32_t MvFunction::compareObject(const PObject& r,const PObjectList& a) const {
	PvObject* eval=evaluateValue(0,a);
	int32_t rc=eval!=0?eval->compareObject(r):-1;
	delete eval;
	return rc;}

// COMPOSE
WObject* MvFunction::compose(WControl& c,
		WObject* w_parent,const PObject* pv) const {
	WObject* w_self = composeWv(c,w_parent,pv);
	const PObjectList& pas = pv->args();
	args_compose(c,w_self,pas);
	return w_self;}

WObject* MvFunction::composeWv(WControl&,
		WObject* w_parent,const PObject* pv) const {
	return new WvObject(w_parent,this,pv);}

void MvFunction::args_compose(WControl&,WObject*,const PObjectList&)const{}
	
//======================================================================
MvWithin::MvWithin(CSTR s):MvFunction(s) {}
MvWithin::~MvWithin() {}

int32_t MvWithin::compareObject(const PObject& r,const PObjectList& a) const {
	int32_t cl=r.compareObject(*a[0]);
	int32_t cr=r.compareObject(*a[1]);
	return (cl>=0&&cr<=0)?0:-1;}

//======================================================================
MvOneof::MvOneof(CSTR s):MvFunction(s) {}
MvOneof::~MvOneof() {}

int32_t MvOneof::compareObject(const PObject& r,const PObjectList& a) const {
	PObject* f=a.findMatching(&r,(PObjectEqFunc)&PObject::isEqualObject);
	return f!=0?0:-1;}

// COMPOSE
WObject* MvOneof::composeWv(WControl&,
		WObject* w_parent,const PObject* pv) const {
	return new WvOneof(w_parent,this,pv);}
void MvOneof::args_compose(WControl& c,
		WObject* w_self,const PObjectList& pas) const{
	pas.elementsPerformWith((PObjectFunc)&PObject::vselfCompose,&c,w_self);}

//======================================================================
MvComb::MvComb(CSTR s):MvFunction(s) {}
MvComb::~MvComb() {}

// COMPOSE
WObject* MvComb::composeWv(WControl&,
		WObject* w_parent,const PObject* pv) const {
	return new WvComb(w_parent,this,pv);}
void MvComb::args_compose(WControl& c,
		WObject* w_self,const PObjectList& pas) const{
	pas.elementsPerformWith((PObjectFunc)&PObject::vselfCompose,&c,w_self);}

//======================================================================
MvOctets::MvOctets(CSTR s):MvFunction(s) {}
MvOctets::~MvOctets() {}
bool MvOctets::functionGenerate(WControl& c,WObject* w,OCTBUF& b,const PObjectList& a) const {
	PvOctets tmp;
	if(!generateOctetsWith(a,tmp,0)) {
		const PObject* s=w->object();
		s->error("E %s generate error",string());
		c.result(1); return c;}
	return tmp.generate(c,w,b);}

PvObject* MvOctets::generateValue(WObject*,const PObjectList& a) const {
	PvOctets* tmp=new PvOctets;
	if(!generateOctetsWith(a,*tmp,0)) {delete tmp; return 0;}
	return tmp;}

PvObject* MvOctets::evaluateValue(WObject*,const PObjectList& a) const {
	PvOctets* tmp=new PvOctets;
	if(!generateOctetsWith(a,*tmp,0)) {delete tmp; return 0;}
	return tmp;}

//======================================================================
MvRepeat::MvRepeat(CSTR s):MvOctets(s) {}
MvRepeat::~MvRepeat() {}
uint32_t MvRepeat::functionLength(const PObjectList& a,const WObject*) const {
	bool ok=true;
	return a[1]->intValue(ok);}

bool MvRepeat::generateOctetsWith(const PObjectList& a,PvOctets& oct,WObject*) const {
	bool ok=true;
	uint32_t l=a[1]->intValue(ok);
	int v=a[0]->intValue(ok);
	oct.set(l);
	memset(oct.buffer(),v,l);
	return true;}

//======================================================================
MvSubstr::MvSubstr(CSTR s):MvOctets(s) {}
MvSubstr::~MvSubstr() {}

uint32_t MvSubstr::functionLength(const PObjectList& a,const WObject*) const {
	bool ok=true;
	return a[2]->intValue(ok);}

bool MvSubstr::generateSubstr(WObject* w,PObject* o,PObject* l,PvOctets& oct) const {
	bool ok=true;
	uint32_t tl=w->length();
	uint32_t ol=o!=0?o->intValue(ok):0;
	uint32_t ll=l!=0?l->intValue(ok):tl-ol;
	if(tl<ol+ll) {
		WObject* p=w->parent();
		const PObject* s=p->object();
		s->error("E substr(%s=%d,%d,%d) exceeded",w->nameString(),tl,ol,ll);
		return false;}
	PvOctets ref(tl);
	WControl wc;
	w->generate(wc,ref);
	if(!wc) {return false;}
	oct.set(ll);
	ref.substr(ol,ll,&oct);
	return true;}

bool MvSubstr::generateOctetsWith(const PObjectList& a,PvOctets& oct,WObject* w) const {
	if(w==0) {return MvOctets::generateOctetsWith(a,oct,w);}
	return generateSubstr(w,a[1],a[2],oct);}

// COMPOSE
WObject* MvSubstr::composeWv(WControl&,
		WObject* w_parent,const PObject* pv) const {
	return new WvSubstr(w_parent,this,pv);}
void MvSubstr::args_compose(WControl& c,
		WObject* w_self,const PObjectList& pas) const{
	WControl wc; //new WControl, don't use c(break pushSA,IPinfo,etc..)
	const PObject* pa = pas[0];
	pa->selfCompose(wc,w_self);
	if(wc.error())c.set_error(wc.resultcode());
	}

//======================================================================
MvPatch::MvPatch(CSTR s):MvSubstr(s) {}
MvPatch::~MvPatch() {}

uint32_t MvPatch::functionLength(const PObjectList&,const WObject* w) const {
	WObject *n=w->nextChild();
	return n!=0?n->length():0;}

bool MvPatch::generateOctetsWith(const PObjectList& a,PvOctets& oct,WObject* w) const {
	if(w==0) {return MvOctets::generateOctetsWith(a,oct,w);}
	bool ok=true;
	uint32_t tl=w->length();
	int offset=a[1]!=0?a[1]->intValue(ok):0; // xxx
	int val=a[2]!=0?a[2]->intValue(ok):0;    // xxx
       	oct.set(tl);
	WControl wc;
	w->generate(wc,oct);
	if(!wc) {return false;}
	ItPosition at;
	at.addBytes(offset);
	uint32_t orgval=oct.decodeUint(at,8);
	printf("patch: offset(%d): (%02x) -> (%02x)\n",offset,orgval,val);
	oct.encodeUint(val,at,8);
	return true;}

//======================================================================
MvLeft::MvLeft(CSTR s):MvSubstr(s) {}
MvLeft::~MvLeft() {}

uint32_t MvLeft::functionLength(const PObjectList& a,const WObject*) const {
	bool ok=true;
	return a[1]->intValue(ok);}

bool MvLeft::generateOctetsWith(const PObjectList& a,PvOctets& oct,WObject* w) const {
	if(w==0) {return MvOctets::generateOctetsWith(a,oct,w);}
	return generateSubstr(w,0,a[1],oct);}

//======================================================================
MvRight::MvRight(CSTR s):MvSubstr(s) {}
MvRight::~MvRight() {}

uint32_t MvRight::functionLength(const PObjectList& a,const WObject* w) const {
	bool ok=true;
	int l=a[1]->intValue(ok);
	WObject *n=w->nextChild();
	return n!=0?n->length()-l:0;}

bool MvRight::generateOctetsWith(const PObjectList& a,PvOctets& oct,WObject* w) const {
	if(w==0) {return MvOctets::generateOctetsWith(a,oct,w);}
	return generateSubstr(w,a[1],0,oct);}

//======================================================================
MvV4::MvV4(CSTR s):MvFunction(s) {}
MvV4::~MvV4() {}
bool MvV4::generateV4Addr(const PObjectList& a,PvV4Addr& into) const {
	bool ok=true;
	CSTR s=a[0]->strValue(ok);
	return into.pton(s);}

bool MvV4::functionGenerate(WControl& c,WObject* w,OCTBUF& b,const PObjectList& a) const {
	PvV4Addr tmp;
	if(!generateV4Addr(a,tmp)) {
		const PObject* s=w->object();
		s->error("E %s generate error",string());
		c.result(1); return c;}
	return tmp.generate(c,w,b);}

PvObject* MvV4::generateValue(WObject*,const PObjectList& a) const {
	PvV4Addr* tmp=new PvV4Addr;
	if(!generateV4Addr(a,*tmp)) {delete tmp; return 0;}
	return tmp;}

PvObject* MvV4::evaluateValue(WObject*,const PObjectList& a) const {
	PvV4Addr* tmp=new PvV4Addr;
	if(!generateV4Addr(a,*tmp)) {delete tmp; return 0;}
	return tmp;}

//======================================================================
MvEther::MvEther(CSTR s):MvFunction(s) {}
MvEther::~MvEther() {}
bool MvEther::generateEther(const PObjectList& a,PvEther& into) const {
	bool ok=true;
	CSTR s=a[0]->strValue(ok);
	return into.pton(s);}

bool MvEther::evaluateEther(const PObjectList& a,PvEther& into) const {
	return generateEther(a,into);}

bool MvEther::generateTN(const PObject* t,PvEther& into) const {
	bool ok=true;
	CSTR ifn=(t!=0)?t->strValue(ok):0;
	PvIfName* pvif=PvIfName::findTn(ifn);
	if(pvif==0) 	{into.zero(); return false;}
	else		{into=*pvif->ether(); return true;}}

bool MvEther::generateNUT(const PObject* t,PvEther& into) const {
	bool ok=true;
	CSTR ifn=(t!=0)?t->strValue(ok):0;
	PvIfName* pvif=PvIfName::findNut(ifn);
	if(pvif==0) 	{into.zero(); return false;}
	else		{into=*pvif->ether(); return true;}}

bool MvEther::functionGenerate(WControl& c,WObject* w,OCTBUF& b,const PObjectList& a) const {
	PvEther tmp;
	if(!generateEther(a,tmp)) {
		const PObject* s=w->object();
		s->error("E %s generate error",string());
		c.result(1); return c;}
	return tmp.generate(c,w,b);}

PvObject* MvEther::generateValue(WObject*,const PObjectList& a) const {
	PvEther* tmp=new PvEther;
	if(!generateEther(a,*tmp)) {delete tmp; return 0;}
	return tmp;}

PvObject* MvEther::evaluateValue(WObject*,const PObjectList& a) const {
	PvEther* tmp=new PvEther;
	if(!evaluateEther(a,*tmp)) {delete tmp; return 0;}
	return tmp;}

//======================================================================
MvEtherSRC::MvEtherSRC(CSTR s):MvEther(s) {}
MvEtherSRC::~MvEtherSRC() {}
bool MvEtherSRC::generateEther(const PObjectList& a,PvEther& into) const {
	uint32_t n=a.size();
	return generateTN(n>0?a[0]:0,into);}

bool MvEtherSRC::evaluateEther(const PObjectList& a,PvEther& into) const {
	uint32_t n=a.size();
	return generateNUT(n>0?a[0]:0,into);}

//======================================================================
MvEtherDST::MvEtherDST(CSTR s):MvEther(s) {}
MvEtherDST::~MvEtherDST() {}
bool MvEtherDST::generateEther(const PObjectList& a,PvEther& into) const {
	uint32_t n=a.size();
	return generateNUT(n>0?a[0]:0,into);}

bool MvEtherDST::evaluateEther(const PObjectList& a,PvEther& into) const {
	uint32_t n=a.size();
	return generateTN(n>0?a[0]:0,into);}

//======================================================================
MvEtherNUT::MvEtherNUT(CSTR s):MvEther(s) {}
MvEtherNUT::~MvEtherNUT() {}
bool MvEtherNUT::generateEther(const PObjectList& a,PvEther& into) const {
	uint32_t n=a.size();
	return generateNUT(n>0?a[0]:0,into);}

//======================================================================
MvEtherTN::MvEtherTN(CSTR s):MvEther(s) {}
MvEtherTN::~MvEtherTN() {}
bool MvEtherTN::generateEther(const PObjectList& a,PvEther& into) const {
	uint32_t n=a.size();
	return generateTN(n>0?a[0]:0,into);}

//======================================================================
MvEtherMulti::MvEtherMulti(CSTR s):MvEther(s) {}
MvEtherMulti::~MvEtherMulti() {}
bool MvEtherMulti::generateEther(const PObjectList& a,PvEther& into) const {
	PvV6Addr v6;
	PObject* p=a[0];
	if(!p->generateV6Addr(v6)) {return false;}
	into.multicast(v6);
	return true;}

PvObject* MvEtherMulti::generateValue(WObject*,const PObjectList& a) const {
	PvV6Addr v6;
	PObject* p=a[0];
	if(!p->generateV6Addr(v6)) {return 0;}
	PvEther* tmp=new PvEther;
	tmp->multicast(v6);
	return tmp;}

PvObject* MvEtherMulti::evaluateValue(WObject*,const PObjectList& a) const {
	PvV6Addr v6;
	PObject* p=a[0];
	if(!p->evaluateV6Addr(v6)) {return 0;}
	PvEther* tmp=new PvEther;
	tmp->multicast(v6);
	return tmp;}

//======================================================================
MvV6::MvV6(CSTR s):MvFunction(s) {}
MvV6::~MvV6() {}
bool MvV6::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	bool ok=true;
	CSTR s=a[0]->strValue(ok);
	return into.pton(s);}

bool MvV6::evaluateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	return generateV6Addr(a,into);}

bool MvV6::generateTN(const PObject* t,PvV6Addr& into) const {
	bool ok=true;
	CSTR ifn=(t!=0)?t->strValue(ok):0;
	PvIfName* pvif=PvIfName::findTn(ifn);
	if(pvif==0) 	{into.zero(); return false;}
	else		{into=*pvif->v6addr(); return true;}}

bool MvV6::generateNUT(const PObject* t,PvV6Addr& into) const {
	bool ok=true;
	CSTR ifn=(t!=0)?t->strValue(ok):0;
	PvIfName* pvif=PvIfName::findNut(ifn);
	if(pvif==0) 	{into.zero(); return false;}
	else		{into=*pvif->v6addr(); return true;}}

bool MvV6::functionGenerate(WControl& c,WObject* w,OCTBUF& b,const PObjectList& a) const {
	PvV6Addr tmp;
	if(!generateV6Addr(a,tmp)) {
		const PObject* s=w->object();
		s->error("E %s generate error",string());
		c.result(1); return c;}
	return tmp.generate(c,w,b);}

PvObject* MvV6::generateValue(WObject*,const PObjectList& a) const {
	PvV6Addr* tmp=new PvV6Addr;
	if(!generateV6Addr(a,*tmp)) {delete tmp; return 0;}
	return tmp;}

PvObject* MvV6::evaluateValue(WObject*,const PObjectList& a) const {
	PvV6Addr* tmp=new PvV6Addr;
	if(!evaluateV6Addr(a,*tmp)) {delete tmp; return 0;}
	return tmp;}

//======================================================================
MvV6SRC::MvV6SRC(CSTR s):MvV6(s) {}
MvV6SRC::~MvV6SRC() {}
bool MvV6SRC::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	uint32_t n=a.size();
	return generateTN(n>0?a[0]:0,into);}

bool MvV6SRC::evaluateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	uint32_t n=a.size();
	return generateNUT(n>0?a[0]:0,into);}

//======================================================================
MvV6DST::MvV6DST(CSTR s):MvV6(s) {}
MvV6DST::~MvV6DST() {}
bool MvV6DST::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	uint32_t n=a.size();
	return generateNUT(n>0?a[0]:0,into);}

bool MvV6DST::evaluateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	uint32_t n=a.size();
	return generateTN(n>0?a[0]:0,into);}

//======================================================================
MvV6TN::MvV6TN(CSTR s):MvV6(s) {}
MvV6TN::~MvV6TN() {}
bool MvV6TN::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	uint32_t n=a.size();
	return generateTN(n>0?a[0]:0,into);}

//======================================================================
MvV6NUT::MvV6NUT(CSTR s):MvV6(s) {}
MvV6NUT::~MvV6NUT() {}
bool MvV6NUT::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	uint32_t n=a.size();
	return generateNUT(n>0?a[0]:0,into);}

//======================================================================
MvV6PTN::MvV6PTN(CSTR s):MvV6(s) {}
MvV6PTN::~MvV6PTN() {}
bool MvV6PTN::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	bool ok=true;
	uint32_t n=a.size();
	CSTR net=a[0]->strValue(ok);
	int len=a[1]->intValue(ok);
	PvV6Addr tmp;
	if(!generateTN(n>2?a[2]:0,tmp)) {return false;}
	return into.netMerge(net,len,tmp);}

//======================================================================
MvV6PNUT::MvV6PNUT(CSTR s):MvV6(s) {}
MvV6PNUT::~MvV6PNUT() {}
bool MvV6PNUT::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	bool ok=true;
	uint32_t n=a.size();
	CSTR net=a[0]->strValue(ok);
	int len=a[1]->intValue(ok);
	PvV6Addr tmp;
	if(!generateNUT(n>2?a[2]:0,tmp)) {return false;}
	return into.netMerge(net,len,tmp);}

//======================================================================
MvV6Merge::MvV6Merge(CSTR s):MvV6(s) {}
MvV6Merge::~MvV6Merge() {}
bool MvV6Merge::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	bool ok=true;
	CSTR net=a[0]->strValue(ok);
	int len=a[1]->intValue(ok);
	PvV6Addr v6;
	PObject* p=a[2];
	if(!p->generateV6Addr(v6)) {return false;}
	return into.netMerge(net,len,v6);}

PvObject* MvV6Merge::generateValue(WObject*,const PObjectList& a) const {
	bool ok=true;
	CSTR net=a[0]->strValue(ok);
	int len=a[1]->intValue(ok);
	PvV6Addr v6;
	PObject* p=a[2];
	if(!p->generateV6Addr(v6)) {return 0;}
	PvV6Addr* tmp=new PvV6Addr;
	tmp->netMerge(net,len,v6);
	return tmp;}

PvObject* MvV6Merge::evaluateValue(WObject*,const PObjectList& a) const {
	bool ok=true;
	CSTR net=a[0]->strValue(ok);
	int len=a[1]->intValue(ok);
	PvV6Addr v6;
	PObject* p=a[2];
	if(!p->evaluateV6Addr(v6)) {return 0;}
	PvV6Addr* tmp=new PvV6Addr;
	tmp->netMerge(net,len,v6);
	return tmp;}

//======================================================================
MvV6V6::MvV6V6(CSTR s):MvV6(s) {}
MvV6V6::~MvV6V6() {}
bool MvV6V6::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	bool ok=true;
	CSTR net=a[0]->strValue(ok);
	int len=a[1]->intValue(ok);
	CSTR host=a[2]->strValue(ok);
	PvV6Addr hostAddr(host,ok);	if(!ok) {return false;}
	return into.netMerge(net,len,hostAddr);}

//======================================================================
MvV6Ether::MvV6Ether(CSTR s):MvV6(s) {}
MvV6Ether::~MvV6Ether() {}
bool MvV6Ether::generateV6Addr(const PObjectList& a,PvV6Addr& into) const {
	bool ok=true;
	CSTR ep=a[0]->strValue(ok);
	PvEther eth(ep,ok);
	PvEUI64 eui64(eth);
	const PvV6Addr& l=PvV6Addr::linkLocal();
	return l.merge(64,eui64,&into);}
