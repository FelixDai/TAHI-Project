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
#if !defined(__AzPcap_h__)
#define	__AzPcap_h__ 1
#include "timeval.h"
#include "PvObject.h"
#include "McObject.h"
class PvOctets;
class RObject;
class PcapList;
struct pcap_pkthdr;
struct pcap;
class AzPcap:public PvTimeval {
private:
	PvOctets* frame_;
	RObject* reversed_;
static	McObject* reverser_;
static	PcapList* list_;
static	timeval topTime_;
static	MObject metaTime_;
static	bool dump_;
static	bool detail_;
static	bool describe_;
static	bool relative_;
public:
	AzPcap(const timeval&,PvOctets*,RObject*);
virtual	~AzPcap();
	AzPcap(const AzPcap&);
	AzPcap& operator=(const AzPcap&);
static	pcap* open(CSTR);
static	void creator(u_char*,const pcap_pkthdr*,const u_char*);
static	bool file(CSTR);
	const PObject* correspondingMeta(const MObject*) const;
	void vmatches(void*,...) const;
static	void matches(PObject*);
	void timePrint(CSTR) const;
	void log() const;
static	void batchDetail(u_char*,const pcap_pkthdr*,const u_char*);
static	bool batch(CSTR);
	void print() const;
static	const MObject* metaTime();
static	void logAll();
static	bool setReverser(int);
static	bool reverser(McObject*);
static	McObject* reverser();
static	bool dump();
static	void dump(bool);
static	bool detail();
static	void detail(bool);
static	bool describe();
static	void describe(bool);
static	bool relative();
static	void relative(bool);
static	const timeval& topTime();
static	PvTimeval* createTime(int32_t);
static	PvTimeval* createTime(CSTR,bool&,CSTR=0);
};
inline bool AzPcap::reverser(McObject* m) {reverser_=m; return (m!=0);}
inline McObject* AzPcap::reverser() {return reverser_;}
inline bool AzPcap::dump() {return dump_;}
inline void AzPcap::dump(bool b) {dump_=b;}
inline bool AzPcap::detail() {return detail_;}
inline void AzPcap::detail(bool b) {detail_=b;}
inline bool AzPcap::describe() {return describe_;}
inline void AzPcap::describe(bool b) {describe_=b;}
inline bool AzPcap::relative() {return relative_;}
inline void AzPcap::relative(bool b) {relative_=b;}
inline const MObject* AzPcap::metaTime() {return &metaTime_;}
inline const timeval& AzPcap::topTime() {return topTime_;}

#include "CmCltn.h"
interfaceCmList(PcapList,AzPcap);
#endif
