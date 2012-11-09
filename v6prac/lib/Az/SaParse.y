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
/* operator */
%term ADD
%term SUB
%term MUL
%term AND
%term OR
%term XOR
%term QUEST
%term COLON
%term NOT
%term INC
%term DEC

/* operators */
%term ASOP
%term RELOP
%term EQUOP
%term DIVOP
%term SHIFTL
%term SHIFTR
%term ANDAND
%term XORXOR
%term OROR

/* delimiters */
%term LP
%term RP
%term LC
%term RC
%term LB
%term RB
%term CM
%term SM
%term EQ
%term NE
%term LT
%term GT
%term LE
%term GE
%term SH
%term SQ

/* keywords */
%term NAME
%term STRING
%term NUMBER
%term CRYPTFUNC
%term AUTHFUNC
%term V4
%term V6
%term AH
%term ESP
%term HOST
%term SPI
%term CRYPT
%term AUTH

%{
#define	__USER_SA_SALZEXR__	1
#include "SaLexer.h"
#include "CmTypes.h"
#include "PvOctets.h"
#include "PvXOctets.h"
#include "AzSA.h"
#define YYSTYPE	PObject*

#if defined(__FreeBSD__) && __FreeBSD__ >= 4

#define YYPARSE_PARAM lexer
#define YYPARSE_PARAM_TYPE SaLexer&
#define yyparse(lex)SaParse(lex)

#else

#define	yyparse()SaParse(SaLexer& lexer)

#endif

#define	yylex()lexer.lex()
#define yyerror lexer.yaccError
%}

%%
%{
static AzSA* compound_=0;
static PoQueue funcQue_;
static PvFunction* function_=0;
static PvNumbers* numbers_=0;
%}

file:			algorithm.def.l.;
algorithm.def.l.:
|			algorithm.def.l;
algorithm.def.l:	algorithm.def
|			algorithm.def.l algorithm.def;
algorithm.def:		algorithm.prefix algorithm.body RC	{
				compound_->defined(); compound_=0;};
algorithm.prefix:	esp.prefix			{$$=$1;}
|			ah.prefix			{$$=$1;};
esp.prefix:		ESP NAME LC			{
				compound_=new AzSA(eESP_,$2,lexer);};
ah.prefix:		AH NAME LC			{
				compound_=new AzSA(eAH_,$2,lexer);};
algorithm.body:		algomem.def.l.;
algomem.def.l.:						{$$=0;}
|			algomem.def.l			{$$=$1;};
algomem.def.l:		algomem.def
|			algomem.def.l algomem.def;
algomem.def:		SPI EQ NUMBER SM		{
				compound_->spi_member($3);};
|			HOST EQ addrfunc SM {
				compound_->host_member($3);};
|			CRYPT EQ crpytfunc SM {
				compound_->crypt_member($3);};
|			AUTH EQ authfunc SM {
				compound_->auth_member($3);};

number.l.:						{$$=0;}
|			number.l			{$$=$1;};
number.l:		NUMBER				{numbers_->add($1);};
|			number.l CM NUMBER		{numbers_->add($3);};
values.prefix:		LC				{numbers_=new PvNumbers;}
values:			values.prefix number.l. RC 	{
				PvNumbers* ns=numbers_; numbers_=0;
				PvOctets* oct=ns->octetString();
				delete ns;
				$$=oct;}
sarg.term:		NUMBER				{$$=$1;}
|			STRING				{
				PObject* p=$1;
				PvOctets* pv=p->octetString();
				if(p!=pv) {delete p;}
				$$=pv;}
|			values				{$$=$1;};
sarg.l.:						{$$=0;}
|			sarg.l				{$$=$1;}; 
sarg.l:			sarg.term			{function_->argument($1);}
|			sarg.l CM sarg.term		{function_->argument($3);};

crpyt_call:		CRYPTFUNC LP			{
				function_=(PvFunction*)funcQue_.push($1); $$=$1;};
crpytfunc:		crpyt_call sarg.l. RP		{
				function_->checkArgument();
				$$=$1; function_=(PvFunction*)funcQue_.pop();};
auth_call:		AUTHFUNC LP			{
				function_=(PvFunction*)funcQue_.push($1); $$=$1;};
authfunc:		auth_call sarg.l. RP		{
				function_->checkArgument();
				$$=$1; function_=(PvFunction*)funcQue_.pop();};
addrfunc:		V4 LP STRING RP {
				bool bl=false;
				CSTR s=((const PvString*)($3))->value();
				PvV4Addr* o=new PvV4Addr(s,bl);
				if(!bl) {delete o; o=0;}
				$$=o;}
|			V6 LP STRING RP {
				bool bl=false;
				CSTR s=((const PvString*)($3))->value();
				PvV6Addr* o=new PvV6Addr(s,bl);
				if(!bl) {delete o; o=0;}
				$$=o;};
/*
|			V4 LP STRING CM NUMBER RP {
				bool bl=false;
				CSTR s=((const PvString*)($3))->value();
				uint32_t w=(uint32_t)((const PvNumber*)($5))->value();
				PvXV4Addr* o=new PvXV4Addr(s,bl,w);
				if(!bl) {delete o; o=0;}
				$$=o;}
|			V6 LP STRING CM NUMBER RP {
				bool bl=false;
				CSTR s=((const PvString*)($3))->value();
				uint32_t w=(uint32_t)((const PvNumber*)($5))->value();
				PvXV6Addr* o=new PvXV6Addr(s,bl,w);
				if(!bl) {delete o; o=0;}
				$$=o;};
*/
%%
