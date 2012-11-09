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
#include "PControl.h"
#include "RObject.h"
#include "PvOctets.h"
#include <stdio.h>

//////////////////////////////////////////////////////////////////////////
void Con_IPinfo::reverse_postIPChecksum(RControl& c,RObject* hdr){
	if(postIPChecksum_)postIPChecksum_->post_reverse(*this,c,hdr);}
void Con_IPinfo::generate_postIPChecksum(WControl& c,OCTBUF& buf,WObject* hdr){
	if(postIPChecksum_)postIPChecksum_->post_generate(*this,c,buf,hdr);}

void Con_IPinfo::reverse_postAHICV(RControl& c,RObject* pkt){
	if(postAHICV_)postAHICV_->post_reverse(*this,c,pkt);}
void Con_IPinfo::generate_postAHICV(WControl& c,OCTBUF& buf,WObject* pkt){
	if(postAHICV_)postAHICV_->post_generate(*this,c,buf,pkt);}

void Con_IPinfo::reverse_postUppChecksum(RControl& c,RObject* up){
	if(postUppChecksum_)postUppChecksum_->post_reverse(*this,c,up);}
void Con_IPinfo::generate_postUppChecksum(WControl& c,OCTBUF& buf,WObject* up){
	if(postUppChecksum_)postUppChecksum_->post_generate(*this,c,buf,up);}

void Con_IPinfo::print(){
	#define PRCR	printf("\n")
	printf("== IPinfo == "); PRCR;
	printf("SrcAddr	    = "); if(SrcAddr_)SrcAddr_->print(); PRCR;
	printf("DstAddr     = "); if(DstAddr_)DstAddr_->print(); PRCR;
	printf("LastDstAddr = "); if(LastDstAddr_)LastDstAddr_->print(); PRCR;
	printf("RouteisLeft = %s",(Route_isLeft_?"true":"false"));
	}


//----------------------------------------------------------------------
// RESET
void PControl::reset() {
	error_=false;
	resultcode_=0; 
	IPinfo_=0;
	}

void WControl::reset() {
	PControl::reset();
	stop_=false;
	dict_=0;
	pushing_SA_=0;}

void RControl::reset() {
	PControl::reset();
	DictType_.reset();
	SPI_=0;
	poping_SA_=0;
	ESPinfo_.reset();}

void WSAControl::reset() {
	WControl::reset();}
void RSAControl::reset() {
	RControl::reset();
	current_=0;}

void RControl::unmatchMessage(CSTR,const PvObject*,const PvObject*) {}

//----------------------------------------------------------------------
// PUSH SA/POP SA
void WControl::set_push_SA(const PaObject* sa){
	if(sa==0) {set_warning(1);}
	push_SA(sa);
	pushing_SA(sa);}
void RControl::set_pop_SA(eAlgorithm a){
	Con_IPinfo* ip=IPinfo();
	const PvObject* dst=ip!=0?ip->LastDstAddr():0;
	const PaObject* sa = pop_SA(a,SPI_,dst);
	if(sa==0) {set_warning(1);}
	poping_SA(sa);}

void WControl::push_SA(const PaObject*){}
const PaObject* RControl::pop_SA(eAlgorithm,uint32_t,const PvObject*){return 0;}

#include "PAlgorithm.h"
void WSAControl::push_SA(const PaObject* sa) {
	AlgorithmList* l=algorithms();
	if(l!=0) l->append((PaObject*)sa);}

const PaObject* RSAControl::pop_SA(eAlgorithm,uint32_t,const PvObject*) {
	uint32_t i=current_++;
	AlgorithmList* l=algorithms();
	const PaObject* sa=0;
	if(l!=0) {
		uint32_t i9=l->size();
		sa=i<i9?l->index(i):0;}
	return sa;}

//----------------------------------------------------------------------
// CONSTRUCTOR/DESTRUCTOR
PControl::PControl():error_(false),resultcode_(0),IPinfo_(0){}
PControl::~PControl() {reset();}
WControl::WControl(bool l,bool d):PControl(),
		logging_(l),debug_(d),stop_(false),dict_(0),pushing_SA_(0){}
WControl::~WControl() {reset();}
RControl::RControl():PControl(),DictType_(),SPI_(0),poping_SA_(0),ESPinfo_() {}
RControl::~RControl() {reset();}

WSAControl::WSAControl(AlgorithmList* l):WControl(false,false),algorithms_(l) {}
WSAControl::~WSAControl() {reset();}
RSAControl::RSAControl(AlgorithmList* l):RControl(),current_(0),algorithms_(l) {}
RSAControl::~RSAControl() {reset();}

//////////////////////////////////////////////////////////////////////////////

