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
%term NAME
%term STRING
%term NUMBER
%term FUNCTION
%term TIME
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

/* delimiter */
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

/* function */
%term ETHER
%term V4
%term V6
%term ANY
%term TO_DATE

/* command */
%term ALL
%term ON
%term OFF
%term RESOLV
%term DUMP
%term DESCRIBE
%term DETAIL
%term STATUS
%term RELATIVE
%term SA

/* Precedence and Order of Evaluation */
%left CM
%right ASOP EQ
%left OROR
%left XORXOR
%left ANDAND
%left OR
%left XOR
%left AND
%left EQUOP
%left RELOP
%left SHIFTL SHIFTR
%left ADD SUB
%left MUL DIVOP
%right NOT INC DEC
%right QUEST
%left LB LP

%{
#define __USE_CONDITION_LEXER__ 1
#include "AzLexer.h"
#include "CmTypes.h"
#include "PvObject.h"
#include "PvOctets.h"
#include "PeNode.h"
#include "DmNetdb.h"
#include "AzPcap.h"
#include "PvXOctets.h"
#include "AzSA.h"
#define YYSTYPE	PObject*

#if defined(__FreeBSD__) && __FreeBSD__ >= 4

#define YYPARSE_PARAM lexer
#define YYPARSE_PARAM_TYPE AzLexer&
#define	yyparse(lex)AzParse(lex,PObject** cond)

#else

#define	yyparse()AzParse(AzLexer& lexer,PObject** cond)

#endif

#define	yylex()lexer.lex()
#define yyerror lexer.yaccError
%}

%%
%{
%}

statement:						{*cond=0;}
|			command				{*cond=0;}
|			condition			{*cond=$1;};
condition:		ALL				{$$=new PeTRUE;}
|			search.cond			{$$=$1;};
column.name:		NAME				{$$=$1;};
comparison.operator:	EQ				{$$=$1;}
|			GT				{$$=$1;}
|			LT				{$$=$1;}
|			GE				{$$=$1;}
|			LE				{$$=$1;}
|			NE 				{$$=$1;};
constant:		NUMBER				{$$=$1;};
function:		ETHER LP STRING RP {
				bool bl=false;
				CSTR s=((const PvString*)($3))->value();
				PvEther* o=new PvEther(s,bl);
				if(!bl) {delete o; o=0;}
				$$=o;}
|			V4 LP STRING RP {
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
				$$=o;}
|			ETHER LP STRING CM NUMBER RP {
				bool bl=false;
				CSTR s=((const PvString*)($3))->value();
				uint32_t w=(uint32_t)((const PvNumber*)($5))->value();
				PvXEther* o=new PvXEther(s,bl,w);
				if(!bl) {delete o; o=0;}
				$$=o;}
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
value.exp:		constant			{$$=$1;}
|			function			{$$=$1;}
|			ANY				{$$=$1;};
date.number:		NUMBER				{
				int32_t i=((PvNumber*)$1)->value();
				$$=AzPcap::createTime(i);}
date.function:		TO_DATE LP STRING RP {
				bool bl=false;
				PvString* ps=(PvString*)$3;
				CSTR s=ps->value();
				$$=AzPcap::createTime(s,bl);
				if(!bl) {lexer.error('E',"to_date format error: %s\n",s);}
				delete ps;}
|			TO_DATE LP STRING CM STRING RP {
				bool bl=false;
				PvString* ps3=(PvString*)$3;
				PvString* ps5=(PvString*)$5;
				CSTR s=ps3->value();
				CSTR fmt=ps5->value();
				$$=AzPcap::createTime(s,bl,fmt);
				if(!bl) {lexer.error('E',"to_date format error: %s,\"%s\"\n",s,fmt);}
				delete ps3; delete ps5;};
date.exp:		date.number			{$$=$1;}
|			date.function			{$$=$1;};
predicate:		column.name comparison.operator value.exp
							{$$=$2->node($1,$3);}
|			TIME comparison.operator date.exp
							{$$=$2->node($1,$3);};
bool.primary:		predicate			{$$=$1;}
|			LP search.cond RP		{$$=$2;};
bool.factor:		bool.primary			{$$=$1;}
|			NOT bool.primary		{$$=$1->unary($2);};
bool.term:		bool.factor			{$$=$1;}
|			bool.term AND  bool.factor	{$$=$2->node($1,$3);};
search.cond:		bool.term			{$$=$1;}
|			search.cond OR bool.term	{$$=$2->node($1,$3);};
command:		RESOLV		{DmNetdb::convert(!DmNetdb::convert());	$$=0;}
|			RESOLV	ON	{DmNetdb::convert(true);		$$=0;}
|			RESOLV	OFF	{DmNetdb::convert(false);		$$=0;}
|			DUMP		{AzPcap::dump(!AzPcap::dump());		$$=0;}
|			DUMP	ON	{AzPcap::dump(true);			$$=0;}
|			DUMP	OFF	{AzPcap::dump(false);			$$=0;}
|			DESCRIBE	{AzPcap::describe(!AzPcap::describe());	$$=0;}
|			DESCRIBE ON	{AzPcap::describe(true);		$$=0;}
|			DESCRIBE OFF	{AzPcap::describe(false);		$$=0;}
|			DETAIL		{AzPcap::detail(!AzPcap::detail());	$$=0;}
|			DETAIL	ON	{AzPcap::detail(true);			$$=0;}
|			DETAIL	OFF	{AzPcap::detail(false);			$$=0;}
|			RELATIVE	{AzPcap::relative(!AzPcap::relative());	$$=0;}
|			RELATIVE ON	{AzPcap::relative(true);		$$=0;}
|			RELATIVE OFF	{AzPcap::relative(false);		$$=0;}
|			STATUS		{
				printf("resolv:  \t%s\n",DmNetdb::convert()?"ON":"OFF");
				printf("dump:    \t%s\n",AzPcap::dump()?"ON":"OFF");
				printf("describe:\t%s\n",AzPcap::describe()?"ON":"OFF");
				printf("detail:  \t%s\n",AzPcap::detail()?"ON":"OFF");
				printf("relative:\t%s\n",AzPcap::relative()?"ON":"OFF");
				$$=0;};
|			SA		{AzSA::showSA();};
%%
