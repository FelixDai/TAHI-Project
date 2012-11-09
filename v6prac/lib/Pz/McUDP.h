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
#if !defined(__McUDP_h__)
#define	__McUDP_h__	1

#include "McSub.h"

//////////////////////////////////////////////////////////////////////////////
//	Upper UDP

class McUpp_UDP :public McUpper{
static	McUpp_UDP*		instance_;
static	class McTopHdr_UDP*	tophdr_;
	McUpp_UDP(CSTR);
public:
virtual ~McUpp_UDP();
static	McUpp_UDP* create(CSTR key,CSTR tophdrkey);
static	McUpp_UDP* instance(){return instance_;}
	int32_t headerType()const{return TP_Upp_UDP;}
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
virtual uint32_t length_for_reverse(RControl&,ItPosition& at,OCTBUF& buf) const;
virtual RObject* reverse(RControl& c,
		RObject* r_parent,ItPosition& at,OCTBUF& buf)const;
virtual bool generate(WControl& c,WObject* w_self,OCTBUF& buf)const;
};

class McTopHdr_UDP :public McHeader{
friend	class McUpp_UDP;
	MmUint*		Layerlength_meta_;
	void Layerlength_member(MmUint* meta){
			Layerlength_meta_=meta; member(meta);}
	McTopHdr_UDP(CSTR);
virtual ~McTopHdr_UDP();
static	McTopHdr_UDP* create(CSTR);
	int32_t headerType()const{return TP_Upp_UDP;}
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
virtual uint32_t Layerlength_for_reverse(RControl&,ItPosition&,OCTBUF&) const;
//HardCording action method
	DEC_HCGENE(Length);
};

//////////////////////////////////////////////////////////////////////////////
#endif
