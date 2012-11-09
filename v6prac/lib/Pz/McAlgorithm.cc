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
#include "McAlgorithm.h"
#include "ItPosition.h"
#include "WObject.h"
#include "RObject.h"
#include "PControl.h"
#include "PvObject.h"
#include "PvOctets.h"
#include "PAlgorithm.h"

//////////////////////////////////////////////////////////////////////////////
#define SUPER	McObject
McAlgorithm::McAlgorithm(CSTR str):SUPER(str){}
McAlgorithm::~McAlgorithm(){}
#undef SUPER

//////////////////////////////////////////////////////////////////////////////
#define SUPER	McAlgorithm

McAlgorithm_ESP::McAlgorithm_ESP(CSTR str):SUPER(str){}
McAlgorithm_ESP::~McAlgorithm_ESP(){}

PObject* McAlgorithm_ESP::tokenObject(int l,CSTR f) const {
	return new PaESP(this,f,l);}

McAlgorithm_ESP* McAlgorithm_ESP::create(CSTR key){
	McAlgorithm_ESP* mc = new McAlgorithm_ESP(key);
	mc->member( new MmAlgo_Pad(	"pad" ) );
	mc->member( new MmAlgo_Crypt(	"crypt" ) );
	mc->member( new MmAlgo_Auth(	"auth" ) );
	return mc;}

#undef SUPER

//////////////////////////////////////////////////////////////////////////////
#define SUPER	McAlgorithm

McAlgorithm_AH::McAlgorithm_AH(CSTR str):SUPER(str){}
McAlgorithm_AH::~McAlgorithm_AH(){}

PObject* McAlgorithm_AH::tokenObject(int l,CSTR f) const {
	return new PaAH(this,f,l);}

McAlgorithm_AH* McAlgorithm_AH::create(CSTR key){
	McAlgorithm_AH* mc = new McAlgorithm_AH(key);
	mc->member( new MmAlgo_Auth(	"auth" ) );
	return mc;}

#undef SUPER

//////////////////////////////////////////////////////////////////////////////
#define SUPER   MmUint

RObject* MmSPI::reverse(RControl& c,
		RObject* r_parent,ItPosition& at,OCTBUF& buf) const{
	RObject* r_self = SUPER::reverse(c,r_parent,at,buf);
	if(r_self){
		const PvNumber* pv = (const PvNumber*)r_self->pvalue();
		uint32_t val = pv->value();
		c.SPI() = val;}//for select SA(with pseudoinfo)
	return r_self;}

