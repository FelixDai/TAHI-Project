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
#if !defined(__McICMPv6_h__)
#define	__McICMPv6_h__	1

#include "McSub.h"
#include "MmHeader.h"

//////////////////////////////////////////////////////////////////////////////
//	Upper ICMPv6	RFC2663,RFC2461

//ICMPv6 Type
const int32_t TP_ICMPv6_RS			=133;
const int32_t TP_ICMPv6_RA			=134;
const int32_t TP_ICMPv6_NS			=135;
const int32_t TP_ICMPv6_NA			=136;
const int32_t TP_ICMPv6_Redirect		=137;
const int32_t TP_ICMPv6_MLDQuery		=130;
const int32_t TP_ICMPv6_MLDReport		=131;
const int32_t TP_ICMPv6_MLDDone			=132;
const int32_t TP_ICMPv6_EchoRequest		=128;
const int32_t TP_ICMPv6_EchoReply		=129;
const int32_t TP_ICMPv6_PacketTooBig		=2;
const int32_t TP_ICMPv6_DestinationUnreachable	=1;
const int32_t TP_ICMPv6_TimeExceeded		=3;
const int32_t TP_ICMPv6_ParameterProblem	=4;
const int32_t TP_ICMPv6_HomeAgentAddrDiscoveryReq	=143;
const int32_t TP_ICMPv6_HomeAgentAddrDiscoveryRep	=144;

//Option Type (ICMPv6)
const int32_t TP_Opt_ICMPv6_SLL			=1;
const int32_t TP_Opt_ICMPv6_TLL			=2;
const int32_t TP_Opt_ICMPv6_Prefix		=3;
const int32_t TP_Opt_ICMPv6_Redirected		=4;
const int32_t TP_Opt_ICMPv6_MTU			=5;
const int32_t TP_Opt_ICMPv6_AdvertisementInterval	=7;
const int32_t TP_Opt_ICMPv6_HomeAgentInformation	=8;



// meta ICMPv6 only one (reverse upptype(one)->icmptype(any) McUpp_ICMPv6_*}
class McUpp_ICMPv6_ONE :public McUpper{
private:
static	McUpp_ICMPv6_ONE* instance_;
	McUpp_ICMPv6_ONE(CSTR);
public:
virtual	~McUpp_ICMPv6_ONE();
static	McUpp_ICMPv6_ONE* instance();
	int32_t headerType()const{return TP_Upp_ICMPv6;}
	bool containsMc(const MObject* mc) const;
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
virtual uint32_t length_for_reverse(RControl&,ItPosition& at,OCTBUF& buf) const;
virtual RObject* reverse(RControl&,RObject* r_parent,ItPosition&,OCTBUF&) const;
};


//////////////////////////////////////////////////////////////////////////////
//	Header ICMPv6 (AS Upper)
class McUpp_ICMPv6 :public McHeader{
protected:
	const MmUint*	type_;
	void type_member(MmUint* meta){type_=meta; member(meta);}
        const MmUint*   Code_;
	void Code_member(MmUint* meta){Code_=meta; member(meta);}
	//
	void	common_member();
	McUpp_ICMPv6(CSTR);
public:
        const MmUint*   get_type()const{return type_;}
        const MmUint*   get_Code()const{return Code_;}
virtual	~McUpp_ICMPv6();
virtual	int32_t token() const;
	int32_t headerType()const{return TP_Upp_ICMPv6;}
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
virtual uint32_t length_for_reverse(RControl&,ItPosition& at,OCTBUF& buf) const;
	bool overwrite_DictType(RControl&,ItPosition& at,OCTBUF& buf) const;
virtual RObject* reverse(RControl& c,
		RObject* r_parent,ItPosition& at,OCTBUF& buf)const;
virtual bool generate(WControl& c,WObject* w_self,OCTBUF& buf)const;
};

class McUpp_ICMPv6_ANY :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_ANY(CSTR);
virtual	~McUpp_ICMPv6_ANY();
static	McUpp_ICMPv6_ANY* create(CSTR);
};

class McUpp_ICMPv6_RS :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_RS(CSTR);
virtual	~McUpp_ICMPv6_RS();
static	McUpp_ICMPv6_RS* create(CSTR);
	int32_t icmpv6Type()const{return TP_ICMPv6_RS;}
};

class McUpp_ICMPv6_RA :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_RA(CSTR);
virtual	~McUpp_ICMPv6_RA();
static	McUpp_ICMPv6_RA*	create(CSTR);
	int32_t icmpv6Type()const{return TP_ICMPv6_RA;}
};

class McUpp_ICMPv6_NS :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_NS(CSTR);
virtual	~McUpp_ICMPv6_NS();
static	McUpp_ICMPv6_NS* create(CSTR);
//HardCording action method
	int32_t icmpv6Type()const{return TP_ICMPv6_NS;}
};

class McUpp_ICMPv6_NA :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_NA(CSTR);
virtual	~McUpp_ICMPv6_NA();
static	McUpp_ICMPv6_NA* create(CSTR);
//HardCording action method
	int32_t icmpv6Type()const{return TP_ICMPv6_NA;}
};

class McUpp_ICMPv6_Redirect :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_Redirect(CSTR);
virtual	~McUpp_ICMPv6_Redirect();
static	McUpp_ICMPv6_Redirect* create(CSTR);
	int32_t icmpv6Type()const{return TP_ICMPv6_Redirect;}
};

template<int32_t TYPE>
class McUpp_ICMPv6_MLD :public McUpp_ICMPv6{//MLD group used template
public:
	McUpp_ICMPv6_MLD(CSTR key):McUpp_ICMPv6(key){}
	~McUpp_ICMPv6_MLD(){}
static	McUpp_ICMPv6_MLD* create(CSTR);
	int32_t icmpv6Type()const{return TYPE;}
};
typedef McUpp_ICMPv6_MLD<TP_ICMPv6_MLDQuery>	McUpp_ICMPv6_MLDQuery;
typedef McUpp_ICMPv6_MLD<TP_ICMPv6_MLDReport>	McUpp_ICMPv6_MLDReport;
typedef McUpp_ICMPv6_MLD<TP_ICMPv6_MLDDone>	McUpp_ICMPv6_MLDDone;


template<int32_t TYPE>
class McUpp_ICMPv6_Echo :public McUpp_ICMPv6{//Echo group used template
public:
	McUpp_ICMPv6_Echo(CSTR key):McUpp_ICMPv6(key){}
	~McUpp_ICMPv6_Echo(){}
static	McUpp_ICMPv6_Echo* create(CSTR);
	int32_t icmpv6Type()const{return TYPE;}
};
typedef McUpp_ICMPv6_Echo<TP_ICMPv6_EchoRequest> McUpp_ICMPv6_EchoRequest;
typedef McUpp_ICMPv6_Echo<TP_ICMPv6_EchoReply>	McUpp_ICMPv6_EchoReply;


class McUpp_ICMPv6_PacketTooBig :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_PacketTooBig(CSTR);
virtual	~McUpp_ICMPv6_PacketTooBig();
static	McUpp_ICMPv6_PacketTooBig* create(CSTR);
	int32_t icmpv6Type()const{return TP_ICMPv6_PacketTooBig;}
};

class McUpp_ICMPv6_DestinationUnreachable :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_DestinationUnreachable(CSTR);
virtual	~McUpp_ICMPv6_DestinationUnreachable();
static	McUpp_ICMPv6_DestinationUnreachable* create(CSTR);
	int32_t icmpv6Type()const{return TP_ICMPv6_DestinationUnreachable;}
};

class McUpp_ICMPv6_TimeExceeded :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_TimeExceeded(CSTR);
virtual	~McUpp_ICMPv6_TimeExceeded();
static	McUpp_ICMPv6_TimeExceeded* create(CSTR);
	int32_t icmpv6Type()const{return TP_ICMPv6_TimeExceeded;}
};

class McUpp_ICMPv6_ParameterProblem :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_ParameterProblem(CSTR);
virtual	~McUpp_ICMPv6_ParameterProblem();
static	McUpp_ICMPv6_ParameterProblem* create(CSTR);
	int32_t icmpv6Type()const{return TP_ICMPv6_ParameterProblem;}
};

//class McUpp_ICMPv6_NameLookups :public McUpp_ICMPv6{};

class McUpp_ICMPv6_HomeAgentAddrDiscoveryReq :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_HomeAgentAddrDiscoveryReq(CSTR);
virtual	~McUpp_ICMPv6_HomeAgentAddrDiscoveryReq();
static	McUpp_ICMPv6_HomeAgentAddrDiscoveryReq* create(CSTR);
	int32_t icmpv6Type()const{return TP_ICMPv6_HomeAgentAddrDiscoveryReq;}
};

class McUpp_ICMPv6_HomeAgentAddrDiscoveryRep :public McUpp_ICMPv6{
public:
	McUpp_ICMPv6_HomeAgentAddrDiscoveryRep(CSTR);
virtual	~McUpp_ICMPv6_HomeAgentAddrDiscoveryRep();
static	McUpp_ICMPv6_HomeAgentAddrDiscoveryRep* create(CSTR);
	int32_t icmpv6Type()const{return TP_ICMPv6_HomeAgentAddrDiscoveryRep;}
	DEC_HC_MLC(Address);
};



//////////////////////////////////////////////////////////////////////////////
// header = xx (reference header on the McUpp_ICMPv6_ONE)
// reference particular tophdr (on McUpp_ICMPv6_ONE)
class MmHeader_onICMPv6 :public MmReference_Must1 {
static	TypevsMcDict	dict_; //icmpv6Type vs McUpp_ICMPv6_XX
public:
	MmHeader_onICMPv6(CSTR);
virtual	~MmHeader_onICMPv6();
	int32_t token()const{return metaToken(tkn_header_ref_);}
	const TypevsMcDict* get_dict()const{return &dict_;}
static	void add(McUpp_ICMPv6* mc);
static	void add_other(McUpp_ICMPv6* mc);
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
	bool overwrite_DictType(RControl&,ItPosition& at,OCTBUF& buf)const;
};


//////////////////////////////////////////////////////////////////////////////
//	Option for ICMPv6

//abstruct class
class McOpt_ICMPv6 :public McOption{
protected:
	MmUint*	type_;
	void	type_member(MmUint* meta){type_=meta; member(meta);}
	MmUint*	length_;
	void	length_member(MmUint* meta){length_=meta; member(meta);}
	void	common_member();
	McOpt_ICMPv6(CSTR);
public:
virtual	~McOpt_ICMPv6();
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
virtual uint32_t length_for_reverse(RControl&,ItPosition& at,OCTBUF& buf) const;
	bool overwrite_DictType(RControl&,ItPosition& at,OCTBUF& buf) const;
//HardCording action method
	DEC_HCGENE(Length);
};

//any optionType Format (for unknown option type)
class McOpt_ICMPv6_ANY :public McOpt_ICMPv6{
public:
	McOpt_ICMPv6_ANY(CSTR);
virtual	~McOpt_ICMPv6_ANY();
static	McOpt_ICMPv6_ANY* create(CSTR);
};

class McOpt_ICMPv6_SLL :public McOpt_ICMPv6{
public:
	McOpt_ICMPv6_SLL(CSTR);
virtual	~McOpt_ICMPv6_SLL();
static	McOpt_ICMPv6_SLL* create(CSTR);
	int32_t optionType()const{return TP_Opt_ICMPv6_SLL;}
};

class McOpt_ICMPv6_TLL :public McOpt_ICMPv6{
public:
	McOpt_ICMPv6_TLL(CSTR);
virtual	~McOpt_ICMPv6_TLL();
static	McOpt_ICMPv6_TLL* create(CSTR);
	int32_t optionType()const{return TP_Opt_ICMPv6_TLL;}
};

class McOpt_ICMPv6_Prefix :public McOpt_ICMPv6{
public:
	McOpt_ICMPv6_Prefix(CSTR);
virtual	~McOpt_ICMPv6_Prefix();
static	McOpt_ICMPv6_Prefix* create(CSTR);
	int32_t optionType()const{return TP_Opt_ICMPv6_Prefix;}
};

class McOpt_ICMPv6_MTU :public McOpt_ICMPv6{
public:
	McOpt_ICMPv6_MTU(CSTR);
virtual	~McOpt_ICMPv6_MTU();
static	McOpt_ICMPv6_MTU* create(CSTR);
	int32_t optionType()const{return TP_Opt_ICMPv6_MTU;}
};

class McOpt_ICMPv6_Redirected :public McOpt_ICMPv6{
public:
	McOpt_ICMPv6_Redirected(CSTR);
virtual	~McOpt_ICMPv6_Redirected();
static	McOpt_ICMPv6_Redirected* create(CSTR);
	int32_t optionType()const{return TP_Opt_ICMPv6_Redirected;}
};

class McOpt_ICMPv6_AdvertisementInterval :public McOpt_ICMPv6{
public:
	McOpt_ICMPv6_AdvertisementInterval(CSTR);
virtual	~McOpt_ICMPv6_AdvertisementInterval();
static	McOpt_ICMPv6_AdvertisementInterval* create(CSTR);
	int32_t optionType()const{return TP_Opt_ICMPv6_AdvertisementInterval;}
};

class McOpt_ICMPv6_HomeAgentInformation :public McOpt_ICMPv6{
public:
	McOpt_ICMPv6_HomeAgentInformation(CSTR);
virtual	~McOpt_ICMPv6_HomeAgentInformation();
static	McOpt_ICMPv6_HomeAgentInformation* create(CSTR);
	int32_t optionType()const{return TP_Opt_ICMPv6_HomeAgentInformation;}
};


//////////////////////////////////////////////////////////////////////////////
// option = xx (reference option(ICMPv6) on the McUpp_ICMPv6_XX)
class MmOption_onICMPv6:public MmReference_More0 {
static	TypevsMcDict	dict_;	//optionType(ICMPv6) vs McOption_ICMPv6_XX
public:
	MmOption_onICMPv6(CSTR);
virtual	~MmOption_onICMPv6();
	int32_t token()const{return metaToken(tkn_option_ref_);}
	const TypevsMcDict* get_dict()const{return &dict_;}
static	void add(McOpt_ICMPv6* mc);
static	void add_other(McOpt_ICMPv6* mc);
// COMPOSE/REVERSE INTERFACE --------------------------------------------------
	bool overwrite_DictType(RControl&,ItPosition& at,OCTBUF& buf)const;
};

//////////////////////////////////////////////////////////////////////////////
#endif
