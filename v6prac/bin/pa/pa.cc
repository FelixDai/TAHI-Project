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
#include "CmMain.h"
#include "PvOctets.h"
#include "McObject.h"
#include "AzPcap.h"
#include "AzLexer.h"
#include "AzToken.h"
#include "McNull.h"
#include "DmNetdb.h"
#include "SaLexer.h"
#include <netdb.h>
static int myEout(const char* fmt,va_list v) {
	fprintf(stderr,"err:");
	return vfprintf(stderr,fmt,v);}

static CSTR alias=0;
static CSTR sas=0;
static bool batch=false;
bool doOption(CmMain& m,StringList& l) {
	regEoutFunc(myEout);
	bool rc=true;
	STR p;
	for(char**argv=m.argv();*argv&&(p=*++argv);) {
		if(*p!='-') {
			l.add(new CmCString(p));
			continue;}
		switch(*++p) {
			case 'd': CmMain::setDbgFlags(++p);	break;
			case 'a': alias=*++argv;	break;
			case 's': sas=*++argv;		break;
			case 'b': batch=true;		break;
			default:			break;}}
	return rc;}

bool fileCheck(CSTR s,CSTR f) {
	if(f==0) return true;
	FILE* iod=fopen(f,"r");
	if(iod!=0) {fclose(iod); return true;}
	eoutf("cannot open %s file %s\n",s,f);
	return false;}

applMain() {
	StringList list;
	doOption(*main,list);
	if(list.size()<1) {
		eoutf("pcap file not specified\n"); exit(1);}
	CSTR pcap=list[0]->string();
	bool ok=true;
	if(!fileCheck("pcap",pcap)) {ok=false;}
	if(!fileCheck("sa",sas)) {ok=false;}
	if(!fileCheck("alias",alias)) {ok=false;}
	if(!ok) {exit(1);}
	PvOctets::defaultNotUsed();
	McObject::initialize();
	DmPort::initialize();
	if(sas!=0 && !SaLexer::file(sas)) {exit(1);}
	if(batch) {
		DmNetdb::convert(false);
		AzPcap::dump(false);
		AzPcap::describe(false);
		AzPcap::detail(true);
		AzPcap::batch(pcap);
		exit(0);}
	if(alias!=0 && !AzAlias::file(alias)) {exit(1);}
	if(!AzPcap::file(pcap)) {exit(1);}
	(void)setservent(1);
	AzLexer lex(0);
	AzLexer::loop(lex);
	(void)endservent();
	exit(0);}
