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
#ifndef __TeCmd_h__
#define __TeCmd_h__	1

#include <sys/time.h>
#include "CmCltn.h"

struct TeCmd {
private:
	int32_t pid_;
	int16_t reqno_;
	struct timeval stime_;
public:
	TeCmd(int32_t);
	TeCmd(int32_t,int16_t);
virtual	~TeCmd();
virtual	int32_t pid() const;
virtual	int16_t reqno() const;
	void pid(const int32_t);
	void reqno(const int16_t);
	int hash() const;
	bool isEqual(const TeCmd*) const;
	bool isReqnoEqual(const TeCmd*) const;
};
inline void TeCmd::pid(const int32_t r) {pid_=r;}
inline int32_t TeCmd::pid() const {return pid_;}
inline void TeCmd::reqno(const int16_t r) {reqno_=r;}
inline int16_t TeCmd::reqno() const {return reqno_;}
inline int32_t TeCmd::hash() const {return pid_;}
inline bool TeCmd::isEqual(const TeCmd* o) const {
	return (o->pid()==pid_);}
inline bool TeCmd::isReqnoEqual(const TeCmd* o) const {
	return (o->reqno()==reqno_);}

interfaceCmSet(TeCmdSet,TeCmd);
#endif
