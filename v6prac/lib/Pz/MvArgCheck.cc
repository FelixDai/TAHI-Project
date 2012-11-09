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
#include "MvFunction.h"
#include "PvObject.h"
#include "PvOctets.h"
#include "PvIfName.h"
bool MvFunction::isV6Addr() const {return false;}
bool MvV6::isV6Addr() const {return true;}

bool MvFunction::checkArgument(const PFunction&,const PObjectList&) const {
	return false;}

//======================================================================
// within(int,int)
bool MvWithin::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	uint32_t n=a.size();
	CSTR name=o.metaString();
	if(n!=2) {
		o.error("E %s must have 2 arguments, not %d",name,n);
		return false;}
	a[0]->intValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be int",name);
		rc=false;}
	a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be int",name);
		rc=false;}
	return rc;}

//======================================================================
// oneof(var[,var[,...]]) || oneof(int[,int[,...]])
bool MvOneof::checkArgument(const PFunction&,const PObjectList&) const {
	bool rc=true;
	return rc;}

//======================================================================
// comb(var[,var[,...]])
bool MvComb::checkArgument(const PFunction&,const PObjectList&) const {
	bool rc=true;
	return rc;}

//======================================================================
// repeat(int,int)
bool MvRepeat::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=2) {
		o.error("E %s must have 2 arguments, not %d",name,n);
		return false;}
	a[0]->intValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be int",name);
		rc=false;}
	a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be int",name);
		rc=false;}
	return rc;}

//======================================================================
// substr(var,int,int)
bool MvSubstr::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=3) {
		o.error("E %s must have 3 arguments, not %d",name,n);
		return false;}
	if(!a[0]->isName()) {
		o.error("E %s first argument has to be name",name);
		rc=false;}
	a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be int",name);
		rc=false;}
	a[2]->intValue(ok);
	if(!ok) {
		o.error("E %s third argument has to be int",name);
		rc=false;}
	return rc;}

//======================================================================
// patch(var,int,int)
bool MvPatch::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=3) {
		o.error("E %s must have 3 arguments, not %d",name,n);
		return false;}
	if(!a[0]->isName()) {
		o.error("E %s first argument has to be name",name);
		rc=false;}
	a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be int",name);
		rc=false;}
	a[2]->intValue(ok);
	if(!ok) {
		o.error("E %s third argument has to be int",name);
		rc=false;}
	return rc;}

//======================================================================
// left(var,int)
bool MvLeft::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=2) {
		o.error("E %s must have 2 arguments, not %d",name,n);
		return false;}
	if(!a[0]->isName()) {
		o.error("E %s first argument has to be name",name);
		rc=false;}
	a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be int",name);
		rc=false;}
	return rc;}

//======================================================================
// right(var,int)
bool MvRight::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=2) {
		o.error("E %s must have 2 arguments, not %d",name,n);
		return false;}
	if(!a[0]->isName()) {
		o.error("E %s first argument has to be name",name);
		rc=false;}
	a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be int",name);
		rc=false;}
	return rc;}

//======================================================================
// v4(v4Presntation)
bool MvV4::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=1) {
		o.error("E %s must have 1 argument, not %d",name,n);
		return false;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be v4 presentation",name);
		rc=false;}
	else {
		PvV4Addr c0(a0,ok);
		if(!ok) {
			o.error("E %s(\"%s\") has to be v4 presentation",
				name,a0);
			rc=false;}}
	return rc;}

//======================================================================
// ether(etherPresntation)
bool MvEther::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=1) {
		o.error("E %s must have 1 argument, not %d",name,n);
		return false;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ether presentation",name);
		rc=false;}
	else {
		PvEther c0(a0,ok);
		if(!ok) {
			o.error("E %s(\"%s\") has to be ether presentation",
				name,a0);
			rc=false;}}
	return rc;}

//======================================================================
// ethersrc([ifname])
bool MvEtherSRC::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 argument, not %d",name,n);
		return false;}
	if(n==0) {return rc;}
	a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ifname",name);
		rc=false;}
	return rc;}

//======================================================================
// etherdst([ifname])
bool MvEtherDST::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 argument, not %d",name,n);
		return false;}
	if(n==0) {return rc;}
	a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ifname",name);
		rc=false;}
	return rc;}

//======================================================================
// nutether([ifname])
bool MvEtherNUT::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 arguments, not %d",name,n);
		return false;}
	if(n==0) {return rc;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ifname",name);
		rc=false;}
	else {
		PvIfName* n0=PvIfName::findNut(a0);
		if(n0==0) {
			o.error("W %s(%s) interface not found",name,a0);
			rc=false;}}
	return rc;}

//======================================================================
// tnether([ifname])
bool MvEtherTN::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 arguments, not %d",name,n);
		return false;}
	if(n==0) {return rc;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ifname",name);
		rc=false;}
	else {
		PvIfName* n0=PvIfName::findTn(a0);
		if(n0==0) {
			o.error("W %s(%s) interface not found",name,a0);
			rc=false;}}
	return rc;}

//======================================================================
// v62ethermulti(v6)
bool MvEtherMulti::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=1) {
		o.error("E %s must have 1 argument, not %d",name,n);
		return false;}
	if(!a[0]->isV6Addr()) {
		o.error("E %s first argument has to be V6 addr type",name);
		rc=false;}
	return rc;}

//======================================================================
// v6(v6Presntation)
bool MvV6::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=1) {
		o.error("E %s must have 1 argument, not %d",name,n);
		return false;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be v6 presentation",name);
		rc=false;}
	else {
		PvV6Addr c0(a0,ok);
		if(!ok) {
			o.error("E %s(\"%s\") has to be v6 presentation",
				name,a0);
			rc=false;}}
	return rc;}

//======================================================================
// v6src([ifname])
bool MvV6SRC::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 argument, not %d",name,n);
		return false;}
	if(n==0) {return rc;}
	a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ifname",name);
		rc=false;}
	return rc;}

//======================================================================
// v6dst([ifname])
bool MvV6DST::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 argument, not %d",name,n);
		return false;}
	if(n==0) {return rc;}
	a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ifname",name);
		rc=false;}
	return rc;}

//======================================================================
// nutv6([ifname])
bool MvV6NUT::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 argument, not %d",name,n);
		return false;}
	if(n==0) {return rc;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ifname",name);
		rc=false;}

	else {
		PvIfName* n0=PvIfName::findNut(a0);
		if(n0==0) {
			o.error("W %s(%s) interface not found",name,a0);
			rc=false;}}
	return rc;}

//======================================================================
// tnv6([ifname])
bool MvV6TN::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 argument, not %d",name,n);
		return false;}
	if(n==0) {return rc;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ifname",name);
		rc=false;}
	else {
		PvIfName* n0=PvIfName::findTn(a0);
		if(n0==0) {
			o.error("W %s(%s) interface not found",name,a0);
			rc=false;}}
	return rc;}

//======================================================================
// v6(v6Presntation,bitwidth[,ifname])
bool MvV6PNUT::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=2&&n!=3) {
		o.error("E %s must have 2 or 3 arguments, not %d",name,n);
		return false;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be v6 presentation",name);
		rc=false;}
	else {
		PvV6Addr c0(a0,ok);
		if(!ok) {
			o.error("E %s(\"%s\",,) has to be v6 presentation",
				name,a0);
			rc=false;}}
	int a1=a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be int",name);
		rc=false;}
	else if(a1<0||a1>int(sizeof(v6addr)*8)) {
		o.error("E %s(,%d,) has to be prefix bit width",
			name,a1);
		rc=false;}
	if(n==2) {return rc;}
	CSTR a2=a[2]->strValue(ok);
	if(!ok) {
		o.error("E %s third argument has to be ifname",name);
		rc=false;}
	else {
		PvIfName* n2=PvIfName::findNut(a2);
		if(n2==0) {
			o.error("W %s(,,%s) interface not found",name,a2);
			rc=false;}}
	return rc;}

//======================================================================
// v6(v6Presntation,bitwidth[,ifname])
bool MvV6PTN::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=2&&n!=3) {
		o.error("E %s must have 2 or 3 arguments, not %d",name,n);
		return false;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be v6 presentation",name);
		rc=false;}
	else {
		PvV6Addr c0(a0,ok);
		if(!ok) {
			o.error("E %s(\"%s\",,) has to be v6 presentation",
				name,a0);
			rc=false;}}
	int a1=a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be prefix bit width",name);
		rc=false;}
	else if(a1<0||a1>int(sizeof(v6addr)*8)) {
		o.error("E %s(,%d,) has to be prefix bit width",
			name,a1);
		rc=false;}
	if(n==2) {return rc;}
	CSTR a2=a[2]->strValue(ok);
	if(!ok) {
		o.error("E %s third argument has to be ifname",name);
		rc=false;}
	else {
		PvIfName* n2=PvIfName::findTn(a2);
		if(n2==0) {
			o.error("W %s(,,%s) interface not found",name,a2);
			rc=false;}}
	return rc;}

//======================================================================
// v6(v6Presntation,bitwidth,v6)
bool MvV6Merge::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=3) {
		o.error("E %s must have 3 arguments, not %d",name,n);
		return false;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be v6 presentation",name);
		rc=false;}
	else {
		PvV6Addr c0(a0,ok);
		if(!ok) {
			o.error("E %s(\"%s\",,) has to be v6 presentation",
				name,a0);
			rc=false;}}
	int a1=a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be int",name);
		rc=false;}
	else if(a1<0||a1>int(sizeof(v6addr)*8)) {
		o.error("E %s(,%d,) has to be prefix bit width",
			name,a1);
		rc=false;}
	if(!a[2]->isV6Addr()) {
		o.error("E %s third argument has to be V6 addr type",name);
		rc=false;}
	return rc;}

//======================================================================
// v6(v6Presntation,bitwidth,v6Presntation)
bool MvV6V6::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=3) {
		o.error("E %s must have 3 arguments, not %d",name,n);
		return false;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be v6 presentation",name);
		rc=false;}
	else {
		PvV6Addr c0(a0,ok);
		if(!ok) {
			o.error("E %s(\"%s\",,) has to be v6 presentation",
				name,a0);
			rc=false;}}
	int a1=a[1]->intValue(ok);
	if(!ok) {
		o.error("E %s second argument has to be int",name);
		rc=false;}
	else if(a1<0||a1>int(sizeof(v6addr)*8)) {
		o.error("E %s(,%d,) has to be prefix bit width",
			name,a1);
		rc=false;}
	CSTR a2=a[2]->strValue(ok);
	if(!ok) {
		o.error("E %s third argument has to be v6 presentation",name);
		rc=false;}
	else {
		PvV6Addr c2(a2,ok);
		if(!ok) {
			o.error("E %s(,,\"%s\") has to be v6 presentation",
				name,a2);
			rc=false;}}
	return rc;}

//======================================================================
// ether(etherPresntation)
bool MvV6Ether::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	CSTR name=o.metaString();
	uint32_t n=a.size();
	if(n!=1) {
		o.error("E %s must have 1 argument, not %d",name,n);
		return false;}
	CSTR a0=a[0]->strValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be ether presentation",name);
		rc=false;}
	else {
		PvEther c0(a0,ok);
		if(!ok) {
			o.error("E %s(\"%s\") has to be ether presentation",
				name,a0);
			rc=false;}}
	return rc;}

