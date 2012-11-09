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
#if !defined(__AzLexer_h__)
#define __AzLexer_h__ 1
#if defined(__USE_CONDITION_LEXER__)
#define yydebug  	name2(Az,_yydebug)
#define yynerrs 	name2(Az,_yynerrs)
#define yyerrflag  	name2(Az,_yyerrflag)
#define yychar  	name2(Az,_yychar)
#define yyssp		name2(Az,_yyssp)
#define yyvsp		name2(Az,_yyvsp)
#define yyval		name2(Az,_yyval)
#define yylval		name2(Az,_yylval)
#define yyss		name2(Az,_yyss)
#define yysslim		name2(Az,_yysslim)
#define yyvs		name2(Az,_yyvs)
#define yystacksize	name2(Az,_yystacksize)
#endif

#include "CmLexer.h"
#include "CmString.h"
#include "CmTypes.h"
#include <stdio.h>

class McObject;
class MvAction;
class MvFunction;
class AzToken;
class AzLexer:public CmLexer {
private:
public:
	int32_t lex();
	AzLexer(CSTR=0);
virtual	~AzLexer();
static	void loop(AzLexer&);
protected:
static	void initialize();
virtual	STR controls(STR);
virtual	STR nextToken();
static	void operation(CSTR,int32_t);
static	void token(CSTR,int32_t);
	int32_t compoundMember(CSTR);
	int32_t nameResolve(STR);
};

extern int AzParse(AzLexer& lexer,PObject**);
#endif
