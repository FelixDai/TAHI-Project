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
#if !defined(__McAlgorithm_h__)
#define	__McAlgorithm_h__	1
#include "McObject.h"

//======================================================================
// IPsec Algorithm (SA)
class McAlgorithm : public McObject{
protected:
	McAlgorithm(CSTR);
public:
virtual	~McAlgorithm();
virtual	int32_t token() const{return metaToken(tkn_algorithm_);}
};

//======================================================================
// IPsec Algorithm for ESP (SA)
class McAlgorithm_ESP :public McAlgorithm{
protected:
	McAlgorithm_ESP(CSTR);
public:
virtual	~McAlgorithm_ESP();
static	McAlgorithm_ESP* create(CSTR);
virtual	PObject* tokenObject(int l,CSTR f) const;	
};

//======================================================================
// IPsec Algorithm for AH (SA)
class McAlgorithm_AH : public McAlgorithm{
protected:
	McAlgorithm_AH(CSTR);
public:
virtual	~McAlgorithm_AH();
static	McAlgorithm_AH* create(CSTR);
virtual	PObject* tokenObject(int l,CSTR f) const;	
};

#include "MmObject.h"
//======================================================================
class MmAlgo_Pad : public MmObject{
public: MmAlgo_Pad(CSTR s):MmObject(s){}
virtual	~MmAlgo_Pad(){}
virtual	int32_t token() const{return metaToken(tkn_algomem_pad_);}
};

class MmAlgo_Crypt : public MmObject{
public: MmAlgo_Crypt(CSTR s):MmObject(s){}
virtual	~MmAlgo_Crypt(){}
virtual	int32_t token() const{return metaToken(tkn_algomem_crypt_);}
};

class MmAlgo_Auth : public MmObject{
public: MmAlgo_Auth(CSTR s):MmObject(s){}
virtual	~MmAlgo_Auth(){}
virtual	int32_t token() const{return metaToken(tkn_algomem_auth_);}
};

//======================================================================
class MmSPI : public MmUint{//for SA selecting in reverse
public:
	MmSPI(CSTR s,uint16_t w,const PObject* g=0,const PObject* e=0,
		const ICVoverwriter* ow=0,METH_HC_ForIPinfo meth=0):
		MmUint(s,w,g,e,ow,meth){}
virtual	~MmSPI(){}
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
virtual RObject* reverse(RControl&,RObject* r_parent,ItPosition&,OCTBUF&) const;
};

#endif
