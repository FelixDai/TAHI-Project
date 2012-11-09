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
#if !defined(__McICMPv4_h__)
#define	__McICMPv4_h__	1

#include "McSub.h"
#include "MmHeader.h"

//////////////////////////////////////////////////////////////////////////////
//	Upper ICMPv4	RFC792

//ICMPv4 Type
const int32_t TP_ICMPv4_EchoReply		=0;
const int32_t TP_ICMPv4_DestinationUnreachable	=3;
const int32_t TP_ICMPv4_Redirect		=5;
const int32_t TP_ICMPv4_EchoRequest		=8;
const int32_t TP_ICMPv4_TimeExceeded		=11;
const int32_t TP_ICMPv4_ParameterProblem	=12;


// meta ICMPv4 only one (reverse upptype(one)->icmptype(any) McUpp_ICMPv4_*}
class McUpp_ICMPv4_ONE :public McUpper{
private:
static	McUpp_ICMPv4_ONE* instance_;
	McUpp_ICMPv4_ONE(CSTR);
public:
virtual	~McUpp_ICMPv4_ONE();
static	McUpp_ICMPv4_ONE* instance();
	int32_t headerType()const{return TP_Upp_ICMPv4;}
	bool containsMc(const MObject* mc) const;
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
virtual uint32_t length_for_reverse(RControl&,ItPosition& at,OCTBUF& buf) const;
virtual RObject* reverse(RControl&,RObject* r_parent,ItPosition&,OCTBUF&) const;
};

//////////////////////////////////////////////////////////////////////////////
//	Header ICMPv4 (AS Upper)
class McUpp_ICMPv4 :public McHeader{
protected:
	MmUint*	type_;
	void	type_member(MmUint* meta){type_=meta; member(meta);}
	void	common_member();
	McUpp_ICMPv4(CSTR);
public:
virtual	~McUpp_ICMPv4();
virtual	int32_t token() const;
	int32_t headerType()const{return TP_Upp_ICMPv4;}
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
virtual uint32_t length_for_reverse(RControl&,ItPosition& at,OCTBUF& buf) const;
	bool overwrite_DictType(RControl&,ItPosition& at,OCTBUF& buf) const;
virtual	RObject* reverse(RControl& c,
		RObject* r_parent,ItPosition& at,OCTBUF& buf)const;
virtual bool generate(WControl& c,WObject* w_self,OCTBUF& buf)const;
};

class McUpp_ICMPv4_ANY :public McUpp_ICMPv4{
public:
	McUpp_ICMPv4_ANY(CSTR);
virtual	~McUpp_ICMPv4_ANY();
static	McUpp_ICMPv4_ANY* create(CSTR);
};

class McUpp_ICMPv4_DestinationUnreachable :public McUpp_ICMPv4{
public:
	McUpp_ICMPv4_DestinationUnreachable(CSTR);
virtual	~McUpp_ICMPv4_DestinationUnreachable();
static	McUpp_ICMPv4_DestinationUnreachable* create(CSTR);
	int32_t icmpv4Type()const{return TP_ICMPv4_DestinationUnreachable;}
};

class McUpp_ICMPv4_TimeExceeded :public McUpp_ICMPv4{
public:
	McUpp_ICMPv4_TimeExceeded(CSTR);
virtual	~McUpp_ICMPv4_TimeExceeded();
static	McUpp_ICMPv4_TimeExceeded* create(CSTR);
	int32_t icmpv4Type()const{return TP_ICMPv4_TimeExceeded;}
};

class McUpp_ICMPv4_ParameterProblem :public McUpp_ICMPv4{
public:
	McUpp_ICMPv4_ParameterProblem(CSTR);
virtual	~McUpp_ICMPv4_ParameterProblem();
static	McUpp_ICMPv4_ParameterProblem* create(CSTR);
	int32_t icmpv4Type()const{return TP_ICMPv4_ParameterProblem;}
};

class McUpp_ICMPv4_Redirect :public McUpp_ICMPv4{
public:
	McUpp_ICMPv4_Redirect(CSTR);
virtual	~McUpp_ICMPv4_Redirect();
static	McUpp_ICMPv4_Redirect* create(CSTR);
	int32_t icmpv4Type()const{return TP_ICMPv4_Redirect;}
};

template<int32_t TYPE>
class McUpp_ICMPv4_Echo :public McUpp_ICMPv4{//Echo group used template
public:
	McUpp_ICMPv4_Echo(CSTR key):McUpp_ICMPv4(key){}
	~McUpp_ICMPv4_Echo(){}
static	McUpp_ICMPv4_Echo* create(CSTR);
	int32_t icmpv4Type()const{return TYPE;}
};
typedef McUpp_ICMPv4_Echo<TP_ICMPv4_EchoRequest> McUpp_ICMPv4_EchoRequest;
typedef McUpp_ICMPv4_Echo<TP_ICMPv4_EchoReply>	McUpp_ICMPv4_EchoReply;


//////////////////////////////////////////////////////////////////////////////
// header = xx (reference header on the McUpp_ICMPv4_ONE)
// reference particular tophdr (on McUpp_ICMPv4_ONE)
class MmHeader_onICMPv4 :public MmReference_Must1 {
static	TypevsMcDict	dict_; //icmpv4Type vs McUpp_ICMPv4_XX
public:
	MmHeader_onICMPv4(CSTR);
virtual ~MmHeader_onICMPv4();
	int32_t token()const{return metaToken(tkn_header_ref_);}
	const TypevsMcDict* get_dict()const{return &dict_;}
static	void add(McUpp_ICMPv4* mc);
static	void add_other(McUpp_ICMPv4* mc);
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
	bool overwrite_DictType(RControl&,ItPosition& at,OCTBUF& buf)const;
};

/////////////////////////////////////////////////////////////////////////////
#endif
