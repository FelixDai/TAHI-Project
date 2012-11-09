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
#if !defined(__McMIPv6_h__)
#define	__McMIPv6_h__	1

#include "McSub.h"
#include "MmHeader.h"

//Option Type (ICMPv6)
const int32_t TP_Opt_MIP_Pad1			=0;
const int32_t TP_Opt_MIP_PadN			=1;
const int32_t TP_Opt_MIP_UniqID			=2;
const int32_t TP_Opt_MIP_AlternateCareOfAddr	=4;

//////////////////////////////////////////////////////////////////////////////
//	Option for MIP

//abstruct class
class McOpt_MIP :public McOption{
protected:
	MmUint*	type_;
	void	type_member(MmUint* meta){type_=meta; member(meta);}
	MmUint*	length_;
	void	length_member(MmUint* meta){length_=meta; member(meta);}
	void	common_member();
	McOpt_MIP(CSTR);
public:
virtual	~McOpt_MIP();
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
virtual uint32_t length_for_reverse(RControl&,ItPosition& at,OCTBUF& buf) const;
	bool overwrite_DictType(RControl&,ItPosition& at,OCTBUF& buf) const;
//HardCording action method
	DEC_HCGENE(Length);
};

//////////////////////////////////////////////////////////////////////////////
// option = xx (reference option(MIP) on the McUpp_MIP_XX)
class MmOption_onMIP:public MmReference_More0 {
static	TypevsMcDict	dict_;	//optionType(MIP) vs McOption_MIP_XX
public:
	MmOption_onMIP(CSTR);
virtual	~MmOption_onMIP();
	int32_t token()const{return metaToken(tkn_option_ref_);}
	const TypevsMcDict* get_dict()const{return &dict_;}
static	void add(McOpt_MIP* mc);
static	void add_other(McOpt_MIP* mc);
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
	bool overwrite_DictType(RControl&,ItPosition& at,OCTBUF& buf)const;
};

//////////////////////////////////////////////////////////////////////////////
//any optionType Format (for unknown option type)
class McOpt_MIP_ANY :public McOpt_MIP{
public:
	McOpt_MIP_ANY(CSTR);
virtual	~McOpt_MIP_ANY();
static	McOpt_MIP_ANY* create(CSTR);
};

class McOpt_MIP_Pad1 :public McOpt_MIP{
public:
	McOpt_MIP_Pad1(CSTR);
virtual	~McOpt_MIP_Pad1();
static	McOpt_MIP_Pad1* create(CSTR);
	int32_t optionType()const{return TP_Opt_MIP_Pad1;}
};

class McOpt_MIP_PadN :public McOpt_MIP{
	McOpt_MIP_PadN(CSTR);
public:
virtual	~McOpt_MIP_PadN();
static	McOpt_MIP_PadN* create(CSTR);
	int32_t optionType()const{return TP_Opt_MIP_PadN;}
virtual bool disused() const{return true;}	//disuse evaluate
};

class McOpt_MIP_UniqID :public McOpt_MIP{
public:
	McOpt_MIP_UniqID(CSTR);
virtual	~McOpt_MIP_UniqID();
static	McOpt_MIP_UniqID* create(CSTR);
	int32_t optionType()const{return TP_Opt_MIP_UniqID;}
#if 0
	uint32_t alignment_requirement() const;
#endif
};

class McOpt_MIP_AlternateCareOfAddr :public McOpt_MIP{
public:
	McOpt_MIP_AlternateCareOfAddr(CSTR);
virtual	~McOpt_MIP_AlternateCareOfAddr();
static	McOpt_MIP_AlternateCareOfAddr* create(CSTR);
	int32_t optionType()const{return TP_Opt_MIP_AlternateCareOfAddr;}
#if 0
	uint32_t alignment_requirement() const;
#endif
};

#endif
