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
#if !defined(__LxToken_h__)
#define __LxToken_h__	1
#include "McObject.h"
#include "CmMatch.h"
class PObject;
class AzTokenSet;
//======================================================================
class AzToken:public MObject {
private:
	int32_t token_;
static	MObjectSet tokenSet_;
public:
	AzToken(CSTR s,int32_t=0);
virtual	~AzToken();
virtual	int32_t token() const;
static	void addToken(MObject*);
static	const MObject* find(CSTR);
static	MObjectSet& tokenSet();
};
inline int32_t AzToken::token() const {return token_;}
inline MObjectSet& AzToken::tokenSet() {return tokenSet_;}

//======================================================================
class AzOperator:public AzToken {
public:
	AzOperator(CSTR s,int32_t=0);
virtual	~AzOperator();
virtual PObject* tokenObject(int=0,CSTR=0) const;
};

//======================================================================
class AzAlias:public AzToken {
private:
	const MObject* realName_;
public:
	AzAlias(CSTR,const MObject*,int32_t=0);
virtual	~AzAlias();
static	bool file(CSTR);
virtual PObject* tokenObject(int=0,CSTR=0) const;
protected:
inline	const MObject* realName() const;
static	bool badAlias(CSTR,CSTR);
static	bool doAliasLine(STR);
};
inline const MObject* AzAlias::realName() const {return realName_;}

//======================================================================
class AzMatch:public CmMatch {
private:
static	CmQueue top_;
public:
	AzMatch(const MObject*,CSTR);
virtual	~AzMatch();
static	AzMatch* addToken(const MObject&);
static	const MObject* findToken(CSTR);
static	CmQueue& top();
};
inline AzMatch* AzMatch::addToken(const MObject& t) {
	return (AzMatch*)CmMatch::addToken(t,&top_);}
inline const MObject* AzMatch::findToken(CSTR s) {
	return (const MObject*)CmMatch::findToken(s,&top_);}
inline CmQueue& AzMatch::top() {return top_;}
#endif
