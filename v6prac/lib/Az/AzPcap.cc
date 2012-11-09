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
#include "AzPcap.h"
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <net/bpf.h>
#include "CmMain.h"
#include "RObject.h"
#include "PvOctets.h"
#include "ItPosition.h"
#include "AzSA.h"
#include "McObject.h"
#include "McEther.h"
#include "McNull.h"
extern "C" {
#include <pcap.h>
extern int pcap_offline_read(pcap_t*,int,pcap_handler,u_char);
}
AzPcap::AzPcap(const timeval& t,PvOctets*f,RObject* r):PvTimeval(t),
	frame_(f),reversed_(r) {
	if(topTime_==EPOCHTIMEVAL) {topTime_=t;}}
AzPcap::AzPcap(const AzPcap& o):PvTimeval(o.value()),
	frame_(o.frame_),reversed_(o.reversed_) {}
AzPcap& AzPcap::operator=(const AzPcap& o) {
	PvTimeval::operator=(o);
	frame_=o.frame_, reversed_=o.reversed_;
	return *this;}
AzPcap::~AzPcap() {
	delete frame_; frame_=0;
	delete reversed_; reversed_=0;}

void AzPcap::creator(u_char*,const pcap_pkthdr* h,const u_char* p) {
	u_int len=h->len;
	u_int caplen=h->caplen;
	if(caplen<len) {
		eoutf("capture truncated at %d length %d\n",caplen,len);}
	PvOctets* rcv=new PvOctets(len,(OCTSTR)p,true);
	ItPosition rit;
	AzRControl rc;
	RObject* ro=reverser_->reverse(rc,0,rit,*rcv);
	AzPcap* pc=new AzPcap(h->ts,rcv,ro);
	if(dbgFlags['r']) {pc->print();}
	list_->add(pc);}

bool AzPcap::setReverser(int dlt) {
	switch(dlt) {
		case DLT_EN10MB:
			return reverser(McFrame_Ether::instance());
		case DLT_NULL:
			return reverser(McFrame_Null::instance());
		default: break;}
	return false;}

pcap* AzPcap::open(CSTR name) {
	char errbuf[PCAP_ERRBUF_SIZE];
	if(name==0) return 0;
	pcap* pt=pcap_open_offline((STR)name,errbuf);
	if(pt==0) {eoutf("%s\n",errbuf); return pt;}
	int dlt=pcap_datalink(pt);
	if(!setReverser(dlt)) {
		eoutf("dont know data link type %d\n",dlt);
		pcap_close(pt);
		return 0;}
	return pt;}

bool AzPcap::file(CSTR name) {
	pcap* pt=open(name);
	if(pt==0) {return false;}
	FILE* file=pcap_file(pt);
	int no=fileno(file);
	struct stat st;
	fstat(no,&st);
	u_long m9=st.st_size/80;
	list_=new PcapList(m9);
	int n=pcap_offline_read(pt,0,&AzPcap::creator,0);
	if(dbgFlags['S']) {
		printf("%d %ld %ld %d\n",n,m9,list_->size(),pcap_datalink(pt));}
	pcap_close(pt);
	return true;}

void AzPcap::timePrint(CSTR s) const {
	if(relative()) {
		timeval delta=value()-topTime_;
		printf("%s:%05ld.%06ld",s,delta.tv_sec,delta.tv_usec);
		return;}
	printf("%s:",s); PvTimeval::print();}

static uint32_t selectedNo_=0;
void AzPcap::log() const {
	if(dump()) {
		timePrint("dump");
		frame_->dump("\ndump:  "); printf("\n");}
	if(describe()) {
		timePrint("desc");
		reversed_->describe(0); printf("\n");}
	if(detail()) {
		timePrint("log"); printf("\n");
		reversed_->log(0);}}

void AzPcap::batchDetail(u_char*,const pcap_pkthdr* h,const u_char* p) {
	u_int len=h->len;
	u_int caplen=h->caplen;
	if(caplen<len) {
		eoutf("capture truncated at %d length %d\n",caplen,len);}
	PvOctets* rcv=new PvOctets(len,(OCTSTR)p,false);
	ItPosition rit;
	AzRControl rc;
	RObject* ro=reverser_->reverse(rc,0,rit,*rcv);
	AzPcap pc(h->ts,rcv,ro);
	selectedNo_++;
	pc.log();}

bool AzPcap::batch(CSTR name) {
	pcap* pt=open(name);
	if(pt==0) {return false;}
	selectedNo_=0;
	pcap_offline_read(pt,0,&AzPcap::batchDetail,0);
	pcap_close(pt);
	printf("count: %d packet%s selected\n",
		selectedNo_,selectedNo_>1?"s":"");
	return true;}

const PObject* AzPcap::correspondingMeta(const MObject* m) const {
	if(m==metaTime()) return this;
	const TObject *to=reversed_->corresponding(m);
	return to!=0?to->pvalue():0;}

void AzPcap::vmatches(void* v,...) const {
	PObject* cond=(PObject*)v;
	bool b=cond->matchesWith(*this);
	if(b) {selectedNo_++; log();}}

void AzPcap::matches(PObject* cond) {
	selectedNo_=0;
	list_->elementsPerformWith(&AzPcap::vmatches,(void*)cond);
	printf("count: %d packet%s selected\n",
		selectedNo_,selectedNo_>1?"s":"");}

void AzPcap::logAll() {
	list_->elementsPerform((AzPcapFunc)&AzPcap::log);}

void AzPcap::print() const {reversed_->log(0);}

PvTimeval* AzPcap::createTime(int32_t t) {
	bool rt=relative();
	timeval tv=rt?topTime():EPOCHTIMEVAL;
	tv.tv_sec+=t;
	return new PvTimeval(tv);}

PvTimeval* AzPcap::createTime(CSTR s,bool& b,CSTR fmt) {
	time_t now=time(0);
	struct tm tm=*localtime(&now);
	const char *p=strptime(s,fmt!=0?fmt:"%Y/%m/%d %T",&tm);
	b=(p!=0);
	timeval tv;
	tv.tv_sec=(p!=0)?mktime(&tm):0;
	tv.tv_usec=0;
	return new PvTimeval(tv);}

McObject* AzPcap::reverser_=0;
PcapList* AzPcap::list_=0;
timeval AzPcap::topTime_={0,0};
MObject AzPcap::metaTime_("time");
bool AzPcap::dump_=false;
bool AzPcap::detail_=false;
bool AzPcap::describe_=true;
bool AzPcap::relative_=false;
implementCmList(PcapList,AzPcap);
