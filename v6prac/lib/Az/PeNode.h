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
#if !defined(__PeNode_h__)
#define __PeNode_h__   1
#include "PObject.h"
//======================================================================
class PeTRUE:public PObject {
public:
	PeTRUE();
virtual	~PeTRUE();
virtual	bool matchesWith(const PObject&) const;
virtual	void print() const;
};

//======================================================================
class PeNode:public PObject {
private:
	PObject* lvalue_;
	PObject* rvalue_;
public:
	PeNode();
virtual	~PeNode();
	PObject* node(PObject*,PObject*);
	const PObject* lvalue() const;
	const PObject* rvalue() const;
	void printReversePolish(CSTR) const;
};
inline PObject* PeNode::node(PObject* l,PObject* r) {lvalue_=l; rvalue_=r; return this;}
inline const PObject* PeNode::lvalue() const {return lvalue_;}
inline const PObject* PeNode::rvalue() const {return rvalue_;}

//======================================================================
class PeAND:public PeNode {
public:
	PeAND();
virtual	~PeAND();
virtual	bool matchesWith(const PObject&) const;
virtual	void print() const;
};

class PeOR:public PeNode {
public:
	PeOR();
virtual	~PeOR();
virtual	bool matchesWith(const PObject&) const;
virtual	void print() const;
};

//======================================================================
class PeExpr:public PeNode {
private:
	enum eOPER {
		eNOP_=0, eOPLT_=0x01,eOPEQ_=0x02,eOPGT_=0x04} op_;
static	const CSTR operSTR_[8];
inline	eOPER oper() const;
inline	CSTR operString() const;
public:
	PeExpr(int32_t);
virtual	~PeExpr();
virtual	bool matchesWith(const PObject&) const;
virtual	void print() const;
};
inline PeExpr::eOPER PeExpr::oper() const {return op_;}
inline CSTR PeExpr::operString() const {return operSTR_[oper()];}

//======================================================================
class PeUnary:public PObject {
private:
	PObject* unary_;
public:
	PeUnary();
virtual	~PeUnary();
	PObject* unary(PObject* u);
	const PObject* unary() const;
	void printReversePolish(CSTR) const;
};
inline PObject* PeUnary::unary(PObject* u) {unary_=u; return this;}
inline const PObject* PeUnary::unary() const {return unary_;}

//======================================================================
class PeNOT:public PeUnary {
public:
	PeNOT();
virtual	~PeNOT();
virtual	bool matchesWith(const PObject&) const;
virtual	void print() const;
};

//======================================================================
class PeMETA:public PObject {
private:
	const MObject* meta_;
public:
	PeMETA(const MObject*);
virtual ~PeMETA();
inline	const MObject* meta() const;
virtual	const PObject* corresponding(const PObject&) const;
virtual	void print() const;
};
inline const MObject* PeMETA::meta() const {return meta_;}
#endif
