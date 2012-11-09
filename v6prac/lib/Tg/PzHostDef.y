/* -*-Mode: C++-*-
 *
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
 *
 * PzHostDef : Host Definition File Parser
 */

%term NAME, STRING, NUMBER
%term HOST, INTERFACE, IPV4, IPV6, MAC, TGAGENT

%{
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "LxHostDef.h"
#include "TgHostDef.h"

#if defined(__FreeBSD__) && __FreeBSD__ >= 4

#define yyparse(lex)    HostDefParser::yyparse(lex)

#else

#define	yyparse()	HostDefParser::yyparse()

#endif

#define	yylex()		lexer_.lex()
#define yyerror		lexer_.yaccError

#define yydebug  	host_yydebug
#define yynerrs 	host_yynerrs
#define yyerrflag  	host_yyerrflag
#define yychar  	host_yychar
#define yyssp		host_yyssp
#define yyvsp		host_yyvsp
#define yyval		host_yyval
#define yylval		host_yylval
#define yyss		host_yyss
#define yysslim		host_yysslim
#define yyvs		host_yyvs
#define yystacksize	host_yystacksize
%}

// ====================================================================
//	Syntax
// ====================================================================

%%

HostFile:
|		HostFile HostStatement;

HostStatement:	HOST NAME "{" HostItems "}"		{HostStatement($2);};
HostItems:
|		HostItems NicStatement
|		HostItems TgaStatement;

NicStatement:	INTERFACE NAME "{" IpDefList "}"	{NicStatement($2);};

TgaStatement:	TGAGENT NAME NUMBER ";"			{TgaStatement($2,(uint32_t)$3);}
|		TGAGENT NAME ";"			{TgaStatement($2,(uint32_t)0);};

IpDefList:
|		IpDefList MacStatement
|		IpDefList IpStatement;

MacStatement:	MAC STRING ";"				{MacStatement($2);};

IpStatement:	IPV4 NAME STRING ";"			{Ipv4Statement($2,$3);}
|		IPV6 NAME STRING ";"			{Ipv6Statement($2,$3);};

%%
