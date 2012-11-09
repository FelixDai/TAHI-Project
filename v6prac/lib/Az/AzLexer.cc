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

//----------------------------------------------------------------------
// LEX MAIN ROUTINE
#define __USE_CONDITION_LEXER__ 1
#include "AzLexer.h"
#include "AzToken.h"
#include "AzParse.h"
#include "AzPcap.h"
#include "PeNode.h"
#include "PvObject.h"
#include "MvFunction.h"
#include "CmMain.h"

extern int yydebug;
extern PObject* yylval;
STR AzLexer::controls(STR s) {
	int c=*s;
	if(c==0) {current(0); return s;}
	dbgFlags[0]=yydebug;
	s=CmLexer::controls(s);
	yydebug=dbgFlags[0];
	return s;}
STR AzLexer::nextToken() {
	STR s=CmLexer::nextToken();
	for(;(s!=0&&s[0]=='\\'&&s[1]=='\n');) {
		s=getLine();
		s=CmLexer::nextToken();}
	return s;}
AzLexer::AzLexer(CSTR s):CmLexer(s) {
	AzLexer::initialize();}
AzLexer::~AzLexer() {}

int32_t AzLexer::compoundMember(CSTR c) {
	STR s=nextToken();
	if(s==0) {return YYERRCODE;}
	CmCString tmp;
	CSTR m=nameLex(s,tmp);
	const MObject* mm=McObject::findClassMember(c,m);
	if(mm==0) {return YYERRCODE;}
	yylval=new PeMETA(mm);
	return NAME;}
	
int32_t AzLexer::nameResolve(STR s) {
	CmCString tmp;
	CSTR str=nameLex(s,tmp);
	s=nextToken();
	if(s!=0 && *s=='.') {				/* MEMBER */
		next();
		return compoundMember(str);}
	const MObject* t=AzToken::find(str);
	if(t==0) {return YYERRCODE;}
	yylval=t->tokenObject();
	return t->token();}		/* SINGLE KEYWORD */

int32_t AzLexer::lex() {
	yylval=0;
	STR s=nextToken();
	if(s==0) {return 0;}
	int c=*s;
	const MObject* t=0;
	/**/ if(isAlpha(c)) {
		return nameResolve(s);}
	else if(isdigit(c)) {				/* NUMBER	*/
		int32_t n=digitLex(s);
		yylval=new PvNumber(n);
		return NUMBER;}
	else if(c=='"'||c=='\''){			/* QUOTE	*/
		CmCString tmp;
		CSTR str=stringLex(s,tmp);
		yylval=new PvString(str);
		return STRING;}
	else {						/* DELIMITER	*/
		t=AzMatch::findToken(s);
		if(t!=0) {
			s=next(t->length());
			yylval=t->tokenObject();
			return t->token();}
		return YYERRCODE;}}

//----------------------------------------------------------------------
// MAIN LOOP
void AzLexer::loop(AzLexer& lex) {
	for(;!lex.eof();) {
		lex.getLine();
		PObject* cond=0;
		AzParse(lex,&cond);
		if(cond==0) continue;
		if(dbgFlags['c']) {cond->print(); puts("");}
		AzPcap::matches(cond);
		delete cond;}
}
	
//----------------------------------------------------------------------
// DELIMITERS(NO TOKEN OBJECTS)
void AzLexer::operation(CSTR s,int32_t n) {
	AzOperator* t=new AzOperator(s,n);
	if(isAlpha(*s)) {AzToken::addToken(t);}
	else		{AzMatch::addToken(*t);}}

//----------------------------------------------------------------------
// DICTINARY MANUPULATION
inline void AzLexer::token(CSTR s,int32_t n) {
	AzToken* t=new AzToken(s,n);
	if(isAlpha(*s)) {AzToken::addToken(t);}
	else		{AzMatch::addToken(*t);}}

//----------------------------------------------------------------------
// LEXER INITIALIZATION
void AzLexer::initialize() {
	static bool hasBeenHere=false;
	if(hasBeenHere) return;
	hasBeenHere=true;
	CmLexer::initialize();
	const MObject* mt=AzPcap::metaTime();
	AzToken::addToken(new AzAlias(mt->string(),mt,TIME));
	operation("=",EQ);
	operation("!=",NE);
	operation("<",LT);
	operation(">",GT);
	operation("<=",LE);
	operation(">=",GE);
	operation("&&",AND);
	operation("||",OR);
	operation("!",NOT);
	operation("AND",AND);
	operation("OR",OR);
	operation("NOT",NOT);
	//--------------------------------------------------------------
	token("(",LP);
	token(")",RP);
	token(",",CM);
	token("all",ALL);
	token("v4",V4);
	token("ether",ETHER);
	token("v6",V6);
	token("to_date",TO_DATE);
	token("resolv",RESOLV);
	token("dump",DUMP);
	token("describe",DESCRIBE);
	token("detail",DETAIL);
	token("relative",RELATIVE);
	token("on",ON);
	token("off",OFF);
	token("status",STATUS);
	token("sa",SA);
	AzToken::addToken(new MvANY("any",ANY));
}
