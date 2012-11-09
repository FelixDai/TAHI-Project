/*
 * Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009
 * Yokogawa Electric Corporation.
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
 * $TAHI: vel/lib/Cm/CmQueue.h,v 1.1.1.1 2005/07/13 01:46:14 doo Exp $
 */
#ifndef _Cm_CmQueue_h_
#define _Cm_CmQueue_h_	1
#include "CmTypes.h"
// p: previous  q: this         r: next
// Next point   p -> q -> r
// Prev point   p <- q <- r
// Double Ring Operation
// initial
//      q <- q -> q
// Deque Sequence
//      p ->      r
//      p      <- r
//      q <- q -> q
// Enque Sequence
//           q -> r
//      p <- q
//      p -> q
//           q <- r
class CmQueue {
private:
	CmQueue* prev_;
	CmQueue* next_;
public:
	CmQueue();
virtual	~CmQueue();
	CmQueue* prev() const;
	CmQueue* next() const;
	CmQueue* prev(CmQueue*);
	CmQueue* next(CmQueue*);
	CmQueue* initialize();
virtual	CmQueue* deque();
virtual	CmQueue* enque(CmQueue*);
	CmQueue* append(CmQueue*);
	CmQueue* insert(CmQueue*);
	void print(STR);
	void print();
};
inline	CmQueue* CmQueue::prev() const {return prev_;}
inline	CmQueue* CmQueue::next() const {return next_;}
inline	CmQueue* CmQueue::prev(CmQueue* p) {return prev_=p;}
inline	CmQueue* CmQueue::next(CmQueue* p) {return next_=p;}
inline	CmQueue* CmQueue::initialize() {return prev_=next_=this;}
inline	CmQueue* CmQueue::append(CmQueue* q) {return enque(q);}
inline	CmQueue* CmQueue::insert(CmQueue* q) {return prev()->enque(q);}
#endif
