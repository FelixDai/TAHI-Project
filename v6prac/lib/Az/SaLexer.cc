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

#define ApplicationLexer SaLexer 
//----------------------------------------------------------------------
// LEX MAIN ROUTINE
#define	__USER_SA_SALZEXR__	1
#include "SaLexer.h"
#include "SaToken.h"
#include "SaParse.h"
#include "PvObject.h"
#include "PvName.h"
#include "MfAlgorithm.h"
#include "CmMain.h"

extern int yydebug;
extern PObject* yylval;
STR SaLexer::controls(STR s) {
	dbgFlags[0]=yydebug;
	s=CmLexer::controls(s);
	yydebug=dbgFlags[0];
	return s;}
STR SaLexer::nextToken() {
	return CmLexer::nextToken();}

SaLexer::SaLexer(CSTR s):CmLexer(s) {
	SaLexer::initialize();}
SaLexer::~SaLexer() {}

int32_t SaLexer::lex() {
	yylval=0;
	STR s=nextToken();
	if(s==0) {return 0;}
	int c=*s;
	const MObject* t=0;
	/**/ if(isAlpha(c)) {
		CmCString tmp;
		CSTR str=nameLex(s,tmp);
		t=SaToken::find(str);
		if(t!=0) {
			yylval=t->tokenObject(lineNo(),fileName());
			return t->token();}
		PvName* name=PvName::tokenObject(str,lineNo(),fileName());
		yylval=name;
		return NAME;}
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
		t=SaMatch::findToken(s);
		if(t!=0) {
			s=next(t->length());
			yylval=t->tokenObject();
			return t->token();}
		return YYERRCODE;}}

//----------------------------------------------------------------------
// DICTINARY MANUPULATION
inline void SaLexer::token(CSTR s,int32_t n) {
	SaToken* t=new SaToken(s,n);
	if(isAlpha(*s)) {SaToken::addToken(t);}
	else		{SaMatch::addToken(*t);}}

inline void SaLexer::function(MObject* f) {
	SaToken::addToken(f);}

//----------------------------------------------------------------------
// LEXER INITIALIZATION
void SaLexer::initialize() {
	static bool hasBeenHere=false;
	if(hasBeenHere) return;
	hasBeenHere=true;
	CmLexer::initialize();
	token("=",EQ);
	token("(",LP);
	token(")",RP);
	token("{",LC);
	token("}",RC);
	token(",",CM);
	token(";",SM);
	token("v4",V4);
	token("v6",V6);
	token("host",HOST);
	token("spi",SPI);
	token("crypt",CRYPT);
	token("auth",AUTH);
	//--------------------------------------------------------------
	// CRYPT ALGORITHM
	token("ESPAlgorithm",ESP);
	function(new MfCrypt("null_crypt",0,0,1));
	function(new MfDESCBC("descbc",8,8,8));
	function(new MfBLOWFISH("blowfish",8,8,8));
	function(new MfRC5("rc5",8,8,8));
	function(new MfCAST128("cast128",8,8,8));
	function(new MfDES3CBC("des3cbc",8*3,8,8));
	//--------------------------------------------------------------
	// AUTH ALGORITHM
	token("AHAlgorithm",AH);
	function(new MfAuth("null_auth",0,1));
	function(new MfHMACMD5("hmacmd5",12,4));
	function(new MfHMACSHA1("hmacsha1",12,4));
	MObject::tokenArray_[MObject::tkn_cryptfunc_]=CRYPTFUNC;
	MObject::tokenArray_[MObject::tkn_authfunc_]=AUTHFUNC;
}

bool SaLexer::file(CSTR s) {
	SaLexer lexer((s!=0&&strcmp(s,"-")!=0)?s:0);
	SaParse(lexer);
	return lexer.errorCount()==0;}
