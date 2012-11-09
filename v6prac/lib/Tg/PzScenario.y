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
 * PzScenario : Scenario File Parser
 */

%term NAME, STRING, NUMBER, BYTESIZE
%term CONN, TCP, UDP
%term TRAFFIC, COMMAND, SCENARIO
%term CONNECT, DELAY, ONEWAY, TURNAROUND, EXECUTE
%term EVENT, SYNC

%{
#include <string.h>
#include "LxScenario.h"
#include "TgScenario.h"

#if defined(__FreeBSD__) && __FreeBSD__ >= 4

#define yyparse(lex)    ScenarioParser::yyparse(lex)

#else

#define	yyparse()	ScenarioParser::yyparse()

#endif

#define yylex()		lexer_.lex()
#define yyerror		lexer_.yaccError

#define yydebug  	scenario_yydebug
#define yynerrs 	scenario_yynerrs
#define yyerrflag  	scenario_yyerrflag
#define yychar  	scenario_yychar
#define yyssp		scenario_yyssp
#define yyvsp		scenario_yyvsp
#define yyval		scenario_yyval
#define yylval		scenario_yylval
#define yyss		scenario_yyss
#define yysslim		scenario_yysslim
#define yyvs		scenario_yyvs
#define yystacksize	scenario_yystacksize
%}

// ====================================================================
//	Syntax
// ====================================================================

%%
ScenarioFile:
|		ScenarioFile ConnStatement
|		ScenarioFile EventStatement
|		ScenarioFile ActionStatement
|		ScenarioFile ScenarioStatement;

// Connection Definition ---------------------------------------------

ConnStatement:	CONN NAME "{" ConnSrc "}" "{" ConnDst "}" TCP ";" {
				ConnectStatement($2, TgInfoConn::TCP_); }
|		CONN NAME "{" ConnSrc "}" "{" ConnDst "}" UDP ";" {
				ConnectStatement($2, TgInfoConn::UDP_); }
|		CONN NAME "{" ConnSrc "}" "{" ConnDst "}" ";" {
				ConnectStatement($2, TgInfoConn::TCP_); };
ConnSrc:	NAME "," NAME "," NUMBER {
				SrcPortStatement($1, $3, (uint32_t)$5); };
ConnDst:	NAME "," NAME "," NUMBER {
				DstPortStatement($1, $3, (uint32_t)$5); };

// Event Definition --------------------------------------------------

EventStatement: EVENT NAME EventThreads ";" { EventStatement($2); };
EventThreads:	NameDef
|		NameDef "," EventThreads;

// Action Definition ------------------------------------------------

ActionStatement:	TrafficStatement
|			ExecuteStatement;

TrafficStatement: TRAFFIC NAME NAME "{" TrafficCommandList "}" {
				TrafficStatement($2, $3); };
TrafficCommandList:
|		TrafficCommandList TrafficCommand;

TrafficCommand: ConnectStatement
|		DelayStatement
|		OnewayStatement
|		TurnaroundStatement
|		SyncStatement;

ExecuteStatement: COMMAND NAME NAME "{" ExecuteCommandList "}" {
				ExecuteStatement($2, $3); };
ExecuteCommandList:
|		ExecuteCommandList ExecuteCommand;

ExecuteCommand:	DelayStatement
|		ExecuteStatement
|		SyncStatement;

ConnectStatement: CONNECT ";" { ActConnectStatement(); };
DelayStatement: DELAY NUMBER ";" { ActDelayStatement((uint32_t)$2); };
OnewayStatement: ONEWAY "{" NUMBER "," ByteSize ","  NUMBER "}" ";" { 
				ActOneWayStatement((uint32_t)$3, (uint32_t)$5, (uint32_t)$7);	}
|		ONEWAY "{" NUMBER "," ByteSize "}" ";" {
				ActOneWayStatement((uint32_t)$3, (uint32_t)$5, 0); };
TurnaroundStatement: TURNAROUND "{" NUMBER "," ByteSize ","  NUMBER "}" ";" {
				ActTurnaroundStatement((uint32_t)$3, (uint32_t)$5, (uint32_t)$7); }
|		TURNAROUND "{" NUMBER "," ByteSize "}" ";" {
				ActTurnaroundStatement((uint32_t)$3, (uint32_t)$5, 0); };
ExecuteStatement: EXECUTE STRING ";" { ActExecuteStatement($2); };
SyncStatement: SYNC NAME ";" { ActSyncStatement($2); };

// Scenario Definition ----------------------------------------------

ScenarioStatement: SCENARIO NAME "{" ScenarioActions "}" { ScenarioStatement($2); };
ScenarioActions:
|		NameDef ';' ScenarioActions;

// name, number -----------------------------------------------------

NameDef: NAME { NameStatement($1); };
ByteSize:	BYTESIZE
|		NUMBER;

%%
