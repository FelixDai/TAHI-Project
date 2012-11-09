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
#include <string.h>
#include "CmLexer.h"
#include "AzToken.h"
#include "AzParse.h"
#include "PeNode.h"
#include <stdio.h>
AzToken::AzToken(CSTR s,int32_t t):MObject(s),token_(t) {}
AzToken::~AzToken() {}
void AzToken::addToken(MObject* t) {
	MObjectSet& set=tokenSet();
	MObject* a=(AzToken*)set.filter(t);
	if(t!=a) {CmLexer::instance()->error('U',"duplicate %s",a->string());}}

const MObject* AzToken::find(CSTR s) {
	MObjectSet& set=tokenSet();
	MObject tmp(s);
	return (const MObject*)set.find(&tmp);}

PObject* AzOperator::tokenObject(int,CSTR) const {
	PObject* po=0;
	int32_t t=token();
	switch(t) {
		case AND:	po=new PeAND(); break;
		case OR:	po=new PeOR(); break;
		case NOT:	po=new PeNOT(); break;
		case EQ: case LT: case LE: case GT: case GE: case NE:
				po=new PeExpr(t); break;
		default: break;}
	return po;}

PObject* AzAlias::tokenObject(int=0,CSTR=0) const {
	return new PeMETA(realName());}
const CSTR delm=" \t\n";
static CSTR fileName_=0;
static int lineNo_=0;
bool AzAlias::badAlias(CSTR r,CSTR s) {
	CmLexer::eouts(fileName_,lineNo_,'E',"%s on '%s'\n",r,s);
	return false;}
bool AzAlias::doAliasLine(STR s) {
	CmCString org(s);
	STR p=strchr(s,'#');
	if(p!=0) {*p=0;}
	STR real=strtok(s,delm);
	if(real==0) {return true;}
	STR alias=strtok(NULL,delm);
	if(alias==0) {return badAlias("bad format",org.string());}
	p=strchr(real,'.');
	if(p==0) {return badAlias("bad member",org.string());}
	*p=0;
	const MObject* mm=McObject::findClassMember(real,p+1);
	if(mm==0) {return badAlias("member not found",org.string());}
	addToken(new AzAlias(alias,mm));
	return true;}

bool AzAlias::file(CSTR s) {
	FILE* iod=fopen(s,"r");
	fileName_=s;
	if(iod==0) {
		eoutf("cannot open aliase file %s\n",s);
		return false;}
	bool rc=true;
	char buf[BUFSIZ];
	lineNo_=0;
	for(;fgets(buf,sizeof(buf),iod);) {
		lineNo_++;
		if(!doAliasLine(buf)) rc=false;}
	fclose(iod);
	return rc;}

AzOperator::AzOperator(CSTR s,int32_t t):AzToken(s,t) {}
AzOperator::~AzOperator() {}

AzAlias::AzAlias(CSTR s,const MObject* m,int32_t t):AzToken(s,t!=0?t:NAME),realName_(m) {}
AzAlias::~AzAlias() {}

AzMatch::AzMatch(const MObject* t,CSTR s):CmMatch(t,s) {}
AzMatch::~AzMatch() {}

const uint32_t defaultLxTokenSize=512;
MObjectSet AzToken::tokenSet_(defaultLxTokenSize);
CmQueue AzMatch::top_;
