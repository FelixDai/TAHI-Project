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
#include "McEther.h"
#include "MmHeader.h"
#include "ItPosition.h"
#include "WObject.h"
#include "RObject.h"
#include "PControl.h"
#include "PvObject.h"
#include "PvOctets.h"

//////////////////////////////////////////////////////////////////////////////
McFrame_Ether* McFrame_Ether::instance_=0;
McTopHdr_Ether* McFrame_Ether::tophdr_=0;
McFrame_Ether::McFrame_Ether(CSTR s):McFrame(s) {instance_=this;}
McFrame_Ether::~McFrame_Ether() {if(instance_==this)instance_=0;}

// COMPOSE/REVERSE
uint32_t McFrame_Ether::length_for_reverse(
		RControl& c,ItPosition& at,OCTBUF& buf) const{
	uint32_t length = tophdr_->Layerlength_for_reverse(c,at,buf);
	return length;}

//////////////////////////////////////////////////////////////////////////////
McTopHdr_Ether::McTopHdr_Ether(CSTR key):McHeader(key){}
McTopHdr_Ether::~McTopHdr_Ether(){}

// COMPOSE/REVERSE
uint32_t McTopHdr_Ether::Layerlength_for_reverse(
			RControl&,ItPosition& at,OCTBUF& buf) const {
	return buf.remainLength(at.bytes());}

bool McTopHdr_Ether::HCGENE(Type)(WControl& cntr,WObject* wmem,OCTBUF& buf) const{
	int32_t val	= get_next_protocolType(wmem);
	if(val==-1)return false;
	PvNumber def(val);
	return def.generate(cntr,wmem,buf);}
PObject* McTopHdr_Ether::HCEVAL(Type)(WObject* wmem) const{
	int32_t val	= get_next_protocolType(wmem);
	return new PvNumber(val);}


