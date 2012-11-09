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
#include "PeNode.h"
#include "PvObject.h"
#include "AzParse.h"
#include "PControl.h"
#include "RObject.h"
#include "McObject.h"
//======================================================================
// MATCHESWITH
bool PeTRUE::matchesWith(const PObject&) const {return true;}
bool PeAND::matchesWith(const PObject& pcap) const {
	const PObject* l=lvalue();
	const PObject* r=rvalue();
	return (l!=0&&l->matchesWith(pcap))&&(r!=0&&r->matchesWith(pcap));}
bool PeOR::matchesWith(const PObject& pcap) const {
	const PObject* l=lvalue();
	const PObject* r=rvalue();
	return (l!=0&&l->matchesWith(pcap))||(r!=0&&r->matchesWith(pcap));}
bool PeExpr::matchesWith(const PObject& pcap) const {
	const PObject* lm=lvalue();
	const PObject* rm=rvalue();
	const PObject* lo=lm!=0?lm->corresponding(pcap):0;
	const PObject* ro=rm!=0?rm->corresponding(pcap):0;
	if(lo==0||ro==0) return false;
	WControl c;
	int32_t x=lo->compareObjectWith(c,*ro);
	bool cmp=false;
	uint32_t op=oper();
	/**/ if(x< 0) {cmp=op&eOPLT_;}
	else if(x==0) {cmp=op&eOPEQ_;}
	else if(x> 0) {cmp=op&eOPGT_;}
	return cmp;}
bool PeNOT::matchesWith(const PObject& pcap) const {
	const PObject* u=unary();
	return !(u!=0&&u->matchesWith(pcap));}

//======================================================================
// CORRESPONDING
const PObject* PeMETA::corresponding(const PObject& pcap) const {
	const MObject* m=meta();
	return pcap.correspondingMeta(m);}

#include <stdio.h>
//======================================================================
// FOR DEBUGGING
void PeNode::printReversePolish(CSTR s) const {
	printf(" ");
	const PObject* l=lvalue();
	if(l!=0) {l->print();}
	else	 {printf("NULL");}
	printf(" ");
	const PObject* r=rvalue();
	if(r!=0) {r->print();}
	else	 {printf("NULL");}
	printf(" %s",s);}

void PeUnary::printReversePolish(CSTR s) const {
	const PObject* u=unary();
	printf(" ");
	if(u!=0) {u->print();}
	else	 {printf("NULL");}
	printf(" %s",s);}

void PeTRUE::print() const {printf("TRUE");}
void PeAND::print() const {printReversePolish("AND");}
void PeOR::print() const {printReversePolish("OR");}
void PeExpr::print() const {printReversePolish(operString());}
void PeNOT::print() const {printReversePolish("NOT");}
void PeMETA::print() const {
	const MObject* m=meta();
	const MObject* c=m!=0?m->compound():0;
	printf(" %s.%s",c!=0?c->string():"NOCLASS",m!=0?m->string():"NOMETA");}

//======================================================================
// CONSTRUCTOR AND DESTRUCTOR
PeTRUE::PeTRUE():PObject() {}
PeTRUE::~PeTRUE() {}
PeNode::PeNode():PObject(),lvalue_(0),rvalue_(0) {}
PeNode::~PeNode() {
	delete lvalue_; lvalue_=0;
	delete rvalue_; rvalue_=0;}
PeAND::PeAND():PeNode() {}
PeAND::~PeAND() {}
PeOR::PeOR():PeNode() {}
PeOR::~PeOR() {}
PeExpr::PeExpr(int32_t o):PeNode(),op_(eNOP_) {
	switch(o) {
		case EQ:	op_=eOPEQ_;			break;
		case LT:	op_=eOPLT_;			break;
		case LE:	op_=eOPER(eOPLT_|eOPEQ_);	break;
		case GT:	op_=eOPGT_;			break;
		case GE:	op_=eOPER(eOPGT_|eOPEQ_);	break;
		case NE:	op_=eOPER(eOPLT_|eOPGT_);	break;
		default: break;}}
PeExpr::~PeExpr() {}
PeUnary::PeUnary():PObject(),unary_(0) {}
PeUnary::~PeUnary() {
	delete unary_; unary_=0;}
PeNOT::PeNOT():PeUnary() {}
PeNOT::~PeNOT() {}
PeMETA::PeMETA(const MObject* m):PObject(),meta_(m) {}
PeMETA::~PeMETA() {}
const CSTR PeExpr::operSTR_[8]={"-","<","=","<=",">","!=",">=","-"};
