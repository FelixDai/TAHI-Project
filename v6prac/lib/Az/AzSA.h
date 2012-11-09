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
#if !defined(__AzSA_h__)
#define __AzSA_h__
#include "PAlgorithm.h"
#include "PControl.h"
class SaSet;
class SaLexer;
class AzSA:public PaESP {
private:
	eAlgorithm protocol_;
	uint32_t spi_;
	const PvOctets* host_;
static	SaSet espSet_;
static	SaSet ahSet_;
public:
	AzSA(eAlgorithm,PObject*,const SaLexer&);
	AzSA(eAlgorithm,uint32_t,const PvOctets*);
virtual	~AzSA();
	void spi_member(PObject*);
	void host_member(PObject*);
virtual	PObject* crypt_member(PObject*);
inline	eAlgorithm protocol() const;
inline	uint32_t spi() const;
inline	const PvOctets* host() const;
	const AzSA* findSA();
	void defined();
	uint32_t hash() const;
	bool isEqual(const AzSA*) const;
	bool checkRequirement() const;
virtual	void print() const;
virtual	void log() const;
virtual	void logSelf() const;
static	void showSA(CSTR=0);
};
inline eAlgorithm AzSA::protocol() const {return protocol_;}
inline uint32_t AzSA::spi() const {return spi_;}
inline const PvOctets* AzSA::host() const {return host_;}

class AzRControl:public RControl {
public:
	AzRControl();
	~AzRControl();
virtual	const PaObject* pop_SA(eAlgorithm,uint32_t,const PvObject*);
virtual	void unmatchMessage(CSTR,const PvObject*,const PvObject*);
};
#include "CmCltn.h"
interfaceCmSet(SaSet,AzSA);
#endif
