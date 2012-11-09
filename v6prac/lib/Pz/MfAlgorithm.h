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
#if !defined(__MfAlgorithm_h__)
#define	__MfAlgorithm_h__	1
#include "MvFunction.h"
#include <openssl/des.h>
#include <openssl/evp.h>
#include <openssl/blowfish.h>
#include <openssl/rc5.h>
#include <openssl/cast.h>

class PFunction;
class PObjectList;
//======================================================================
class MfESPPad:public MvFunction {
private:
static	MfESPPad* defaultPadding_;
	PvOctets* padding_;
public:
	MfESPPad(CSTR,PvOctets*);
virtual ~MfESPPad();
virtual int32_t token() const;
virtual PObject* tokenObject(int l,CSTR f) const;
virtual bool checkArgument(const PFunction&,const PObjectList&) const;
//----------------------------------------------------------------------
virtual	OCTBUF* Padding_Octets(uint32_t) const;
static	MfESPPad* defaultPadding();
static	MfESPPad* defaultPadding(MfESPPad*);
static	OCTBUF* defaultOctets(uint32_t);
};
inline int32_t MfESPPad::token() const {return metaToken(tkn_padfunc_);}
inline MfESPPad* MfESPPad::defaultPadding() {return defaultPadding_;}
inline MfESPPad* MfESPPad::defaultPadding(MfESPPad* m) {
	MfESPPad* o=defaultPadding_; defaultPadding_=m; return o;}

class PFunction;
//======================================================================
class MfAuth:public MvFunction {
private:
	uint8_t icvLength_;
	uint8_t alignUnit_;
	uint16_t dummy_;
public:
	MfAuth(CSTR,uint8_t,uint8_t);
virtual	~MfAuth();
inline	uint8_t icvLength() const;
inline	uint8_t alignUnit() const;
virtual int32_t token() const;
virtual PObject* tokenObject(int l,CSTR f) const;
virtual bool checkArgument(const PFunction&,const PObjectList&) const;
//----------------------------------------------------------------------
virtual	OCTSTR init(OCTSTR,const PObjectList&) const;
virtual	void update(OCTSTR,const PObjectList&,const OCTBUF&) const;
virtual	PvOctets* result(OCTSTR,const PObjectList&) const;
virtual	uint32_t alignment(const PObjectList&) const;
};
inline int32_t MfAuth::token() const {return metaToken(tkn_authfunc_);}
inline uint8_t MfAuth::icvLength() const {return icvLength_;}
inline uint8_t MfAuth::alignUnit() const {return alignUnit_;}

//----------------------------------------------------------------------
class MfHMAC:public MfAuth {
public:
	MfHMAC(CSTR,uint8_t,uint8_t);
virtual	~MfHMAC();
virtual bool checkArgument(const PFunction&,const PObjectList&) const;
virtual	EVP_MD* evp() const=0;
virtual	OCTSTR init(OCTSTR,const PObjectList&) const;
virtual	void update(OCTSTR,const PObjectList&,const OCTBUF&) const;
virtual	PvOctets* result(OCTSTR,const PObjectList&) const;
};

//----------------------------------------------------------------------
class MfHMACMD5:public MfHMAC {
public:
	MfHMACMD5(CSTR,uint8_t,uint8_t);
virtual	~MfHMACMD5();
virtual	EVP_MD* evp() const;
};

//----------------------------------------------------------------------
class MfHMACSHA1:public MfHMAC {
public:
	MfHMACSHA1(CSTR,uint8_t,uint8_t);
virtual	~MfHMACSHA1();
virtual	EVP_MD* evp() const;
};

class PFunction;
//======================================================================
class MfCrypt:public MvFunction {
private:
	uint8_t keyLength_;
	uint8_t ivecLength_;
	uint8_t alignUnit_;
	uint8_t dummy_;
public:
	MfCrypt(CSTR,uint8_t,uint8_t,uint8_t);
virtual	~MfCrypt();
virtual int32_t token() const;
virtual PObject* tokenObject(int l,CSTR f) const;
virtual bool checkArgument(const PFunction&,const PObjectList&) const;
//----------------------------------------------------------------------
inline	uint8_t keyLength() const;
inline	uint8_t ivecLength() const;
inline	uint8_t alignUnit() const;
virtual	const PObject* key(const PObjectList&) const;
virtual	uint32_t alignment(const PObjectList&) const;
virtual	uint32_t alignTimes(const PObjectList&) const;
virtual	bool alignmentCheck(uint32_t,const PObjectList&) const;
virtual	OCTBUF* encryptOctets(const OCTBUF&,const PObjectList&,OCTBUF* =0) const;
virtual	OCTBUF* decryptOctets(const OCTBUF&,const PObjectList&,OCTBUF*&) const;
virtual	void encrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
virtual	void decrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
};
inline int32_t MfCrypt::token() const {return metaToken(tkn_cryptfunc_);}
inline uint8_t MfCrypt::keyLength() const {return keyLength_;};
inline uint8_t MfCrypt::ivecLength() const {return ivecLength_;};
inline uint8_t MfCrypt::alignUnit() const {return alignUnit_;};

//----------------------------------------------------------------------
class MfCryptKey:public MfCrypt {
public:
	MfCryptKey(CSTR,uint8_t,uint8_t,uint8_t);
virtual	~MfCryptKey();
virtual bool checkArgument(const PFunction&,const PObjectList&) const;
virtual	const PObject* key(const PObjectList&) const;
virtual	uint32_t alignTimes(const PObjectList&) const;
};

//----------------------------------------------------------------------
class MfDESCBC:public MfCryptKey {
public:
	MfDESCBC(CSTR,uint8_t,uint8_t,uint8_t);
virtual	~MfDESCBC();
	void scheduleKeys(const PObject*,des_key_schedule&) const;
virtual	void encrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
virtual	void decrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
};

//----------------------------------------------------------------------
class MfBLOWFISH:public MfCryptKey {
public:
	MfBLOWFISH(CSTR,uint8_t,uint8_t,uint8_t);
virtual	~MfBLOWFISH();
	void scheduleKeys(const PObject*,BF_KEY&) const;
virtual	void encrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
virtual	void decrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
};

//----------------------------------------------------------------------
class MfRC5:public MfCryptKey {
public:
	MfRC5(CSTR,uint8_t,uint8_t,uint8_t);
virtual	~MfRC5();
	void scheduleKeys(const PObject*,RC5_32_KEY&) const;
virtual	void encrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
virtual	void decrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
};

//----------------------------------------------------------------------
class MfCAST128:public MfCryptKey {
public:
	MfCAST128(CSTR,uint8_t,uint8_t,uint8_t);
virtual	~MfCAST128();
	void scheduleKeys(const PObject*,CAST_KEY&) const;
virtual	void encrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
virtual	void decrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
};

//----------------------------------------------------------------------
class MfDES3CBC:public MfCryptKey {
public:
	MfDES3CBC(CSTR,uint8_t,uint8_t,uint8_t);
virtual	~MfDES3CBC();
	void scheduleKeys(const PObject*,
		des_key_schedule&,des_key_schedule&,des_key_schedule&) const;
virtual	void encrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
virtual	void decrypt(OCTSTR,OCTSTR,uint32_t,const PObject*,OCTSTR) const;
};

//----------------------------------------------------------------------
class MfESPPadAny:public MfESPPad {
public:
	MfESPPadAny(CSTR,PvOctets*);
	~MfESPPadAny();
};
#endif
