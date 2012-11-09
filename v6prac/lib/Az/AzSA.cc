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
#include "AzSA.h"
#include "PvOctets.h"
#include "SaLexer.h"
#include <stdio.h>
bool AzSA::checkRequirement() const {
	if(spi_==0) {error("E has to define spi for '%s'",nameString());}
	if(host_==0) {error("E has to define host for '%s'",nameString());}
	return (spi_!=0&&host_!=0);}
void AzSA::defined() {
	if(!checkRequirement()) {return;}
	SaSet& set=protocol_==eAH_?ahSet_:espSet_;
	AzSA* o=(AzSA*)set.filter(this);
	if(o!=this) {error("E duplicate SA with %s",o->nameString());}}
uint32_t AzSA::hash() const {
	return host_!=0?host_->hash()*spi_:spi_;}
bool AzSA::isEqual(const AzSA* o) const {
	return spi()==o->spi()&&host()->isEqual(o->host());}
void AzSA::print() const {
	printf("==%s %s spi=%d ",protocol_==eAH_?"AH":"ESP",nameString(),spi_);
	if(host_!=0) {host_->print();}
	printf("\n");
	PaESP::print();}
void AzSA::log() const {
	printf("--------------------------------------------\n");
	print();}
void AzSA::logSelf() const {}

void AzSA::spi_member(PObject* s) {bool ok; spi_=s->intValue(ok);}
void AzSA::host_member(PObject* h) {host_=h->octetString();}
PObject* AzSA::crypt_member(PObject* c) {
	if(protocol_==eAH_) {
		error("W AH %s cannot specify crypt",nameString());
		delete c; return 0;}
	return PaESP::crypt_member(c);}
AzSA::AzSA(eAlgorithm e,uint32_t s,const PvOctets* h):PaESP(0,0,0),
	protocol_(e),spi_(s),host_(h) {}
AzSA::AzSA(eAlgorithm e,PObject* s,const SaLexer& l):PaESP(0,l.fileName(),l.lineNo()),
	protocol_(e),spi_(0),host_(0) {
	name(s);}
AzSA::~AzSA() {}

const AzSA* AzSA::findSA() {
	SaSet& set=protocol_==eAH_?ahSet_:espSet_;
	return set.find(this);}

const PaObject* AzRControl::pop_SA(eAlgorithm a,uint32_t s,const PvObject* o) {
	if(o==0) {return 0;}
	const PvOctets* h=o->octetString();
	AzSA tmp(a,s,h);
	const AzSA* sa=tmp.findSA();
	if(h!=o) {delete h;}
	if(sa==0) {
		printf("err:SA not found for protocol=%s SPI=%d address=",a==eAH_?"AH":"ESP",s);
		o->print(); printf("\n");}
	return sa;}

void AzRControl::unmatchMessage(CSTR s,const PvObject* rcv,const PvObject* calc) {
	printf("err: %s is unmatch received:",s); rcv->print();
	printf("!= calculate:"); calc->print(); printf("\n");}

void AzSA::showSA(CSTR) {
	espSet_.elementsPerform((AzSAFunc)&AzSA::log);
	ahSet_.elementsPerform((AzSAFunc)&AzSA::log);}

AzRControl::AzRControl():RControl() {}
AzRControl::~AzRControl() {}

SaSet AzSA::espSet_(1024);
SaSet AzSA::ahSet_(1024);
implementCmSet(SaSet,AzSA);
