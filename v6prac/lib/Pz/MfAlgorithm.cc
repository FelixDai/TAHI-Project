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
#include "MfAlgorithm.h"
#include "PAlgorithm.h"
#include "PvOctets.h"
#include "CmMain.h"
#include "sslconfig.h"
#include <strings.h>
//----------------------------------------------------------------------
OCTBUF* MfESPPad::Padding_Octets(uint32_t len) const {
	return padding_->substr(0,len);}

OCTBUF* MfESPPad::defaultOctets(uint32_t len) {
	MfESPPad* m=defaultPadding();
	return m!=0?m->Padding_Octets(len):new PvOctets(len);}

//----------------------------------------------------------------------
// NULL AUTHENTIFICATION
OCTSTR MfAuth::init(OCTSTR,const PObjectList&) const {return 0;}
void MfAuth::update(OCTSTR,const PObjectList&,const OCTBUF&) const {}
PvOctets* MfAuth::result(OCTSTR,const PObjectList&) const {return 0;}
uint32_t MfAuth::alignment(const PObjectList&) const {return alignUnit();}

//----------------------------------------------------------------------
// NULL CRYPT ALGORITHM
uint32_t MfCrypt::alignment(const PObjectList& args) const {
	uint32_t n=alignTimes(args);
	uint8_t u=alignUnit();
	return n>1?n*u:u;}

bool MfCrypt::alignmentCheck(uint32_t l,const PObjectList& args) const {
	uint8_t reqAlign=alignUnit();
	if(l%reqAlign!=0) {
		printf("log: length %d not match with required alignment %d on %s\n",
			l,reqAlign,string());
		return false;}
	uint32_t funcAlign=alignment(args);
	if(l%funcAlign!=0) {
		printf("log: length %d not match with function alignment %d on %s\n",
			l,funcAlign,string());}
	return true;}

//----------------------------------------------------------------------
uint32_t MfCrypt::alignTimes(const PObjectList& args) const {
	uint32_t n=1;
	if(args.size()>0) {
		bool ok=true;
		n=args[0]->intValue(ok);
		if(!ok) n=1;}
	return n>1?n:1;}

uint32_t MfCryptKey::alignTimes(const PObjectList& args) const {
	uint32_t n=1;
	if(args.size()>2) {
		bool ok=true;
		n=args[2]->intValue(ok);
		if(!ok) n=1;}
	return n>1?n:1;}

//----------------------------------------------------------------------
const PObject* MfCrypt::key(const PObjectList&) const {
	return 0;}

const PObject* MfCryptKey::key(const PObjectList& args) const {
	return (args.size()>0)?args[0]:0;}

//----------------------------------------------------------------------
void MfCrypt::encrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject*,OCTSTR) const {
	memcpy(os,is,l);}
void MfCrypt::decrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject*,OCTSTR) const {
	memcpy(os,is,l);}

//----------------------------------------------------------------------
OCTBUF* MfCrypt::encryptOctets(const OCTBUF& text,const PObjectList& a,OCTBUF* ivec) const {
	if(dbgFlags['E']) {printf("===text\n"); text.dump(); printf("\n");}
	//--------------------------------------------------------------
	// length check
	uint32_t lenc=text.length();
	//--------------------------------------------------------------
	// initial vector
	// if no ivec specified in function, it's depend on malloc
	// how can i return random value?
	// should i make it error?
	OCTSTR ivp=0;
	if(a.size()>1) {
		bool ok=true;
		ivp=(OCTSTR)a[1]->octetsValue(ok);}
	uint32_t ivlen=ivecLength();
	if(ivec!=0) {ivec->set(ivlen,ivp);}
	PvOctets ivwork(ivlen,ivp,true);	// IV field changes
	PvOctets* enc=new PvOctets(ivlen+lenc);
	OCTSTR os=enc->buffer();
	OCTSTR is=(OCTSTR)text.string();
	const PObject* k=key(a);
	OCTSTR wp=ivwork.buffer();
	memcpy(os,wp,ivlen); os+=ivlen;		// initali vector
	if(!alignmentCheck(lenc,a)) {
		MfCrypt::encrypt(os,is,lenc,k,wp);}
	else {
		encrypt(os,is,lenc,k,wp);}
	if(dbgFlags['E']) {printf("===encrypt\n"); enc->dump(); printf("\n");}
	return enc;}

OCTBUF* MfCrypt::decryptOctets(const OCTBUF& cipher,const PObjectList& a,
		OCTBUF*& ivec) const {
	if(dbgFlags['D']) {printf("===cipher\n"); cipher.dump(); printf("\n");}
	//--------------------------------------------------------------
	// length check: use super class decrypt
	uint32_t lcipher=cipher.length();
	uint32_t ivlen=ivecLength();
	uint32_t ldec=lcipher-ivlen;
	//--------------------------------------------------------------
	// initial vector
	OCTSTR cp=(OCTSTR)cipher.string();
	if(ivlen>0) {
		if(ivec==0) {ivec=new PvOctets(0);}
		ivec->set(ivlen,cp);}
	PvOctets ivwork(ivlen,cp,true);		// IV field changes
	PvOctets* dec=new PvOctets(ldec);
	OCTSTR os=dec->buffer();
	OCTSTR is=cp+ivlen;
	const PObject* k=key(a);
	OCTSTR wp=ivwork.buffer();
	if(!alignmentCheck(ldec,a)) {
		MfCrypt::decrypt(os,is,ldec,k,wp);}
	else {
		decrypt(os,is,ldec,k,wp);}
	if(dbgFlags['D']) {printf("===decrypt\n"); dec->dump(); printf("\n");}
	return dec;}

#include <openssl/des.h>
//----------------------------------------------------------------------
// DESCBC CRYPT ALGORITHM
void MfDESCBC::scheduleKeys(const PObject* key,des_key_schedule& schd) const {
	bool ok=true;
	COCTSTR keys=key->octetsValue(ok);
	des_key_sched((DES_CBLOCK_IN)keys,schd);}

void MfDESCBC::encrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	des_key_schedule schd;
	scheduleKeys(key,schd);
	des_cbc_encrypt(is,os,l,schd,(DES_CBLOCK_IO)iv,DES_ENCRYPT);}

void MfDESCBC::decrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	des_key_schedule schd;
	scheduleKeys(key,schd);
	des_cbc_encrypt(is,os,l,schd,(DES_CBLOCK_IO)iv,DES_DECRYPT);}

#include <openssl/blowfish.h>
//----------------------------------------------------------------------
// BLOWFISH CRYPT ALGORITHM
void MfBLOWFISH::scheduleKeys(const PObject* key,BF_KEY& schd) const {
	bool ok=true;
	COCTSTR keys=key->octetsValue(ok);
	BF_set_key(&schd,key->length(),(OCTSTR)keys);}

void MfBLOWFISH::encrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	BF_KEY schd;
	scheduleKeys(key,schd);
	BF_cbc_encrypt(is,os,l,&schd,iv,DES_ENCRYPT);}

void MfBLOWFISH::decrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	BF_KEY schd;
	scheduleKeys(key,schd);
	BF_cbc_encrypt(is,os,l,&schd,iv,DES_DECRYPT);}

#include <openssl/rc5.h>
//----------------------------------------------------------------------
// RC5 CRYPT ALGORITHM
void MfRC5::scheduleKeys(const PObject* key,RC5_32_KEY& schd) const {
	bool ok=true;
	COCTSTR keys=key->octetsValue(ok);
	RC5_32_set_key(&schd,key->length(),(OCTSTR)keys,RC5_16_ROUNDS);}

void MfRC5::encrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	RC5_32_KEY schd;
	scheduleKeys(key,schd);
	RC5_32_cbc_encrypt(is,os,l,&schd,iv,DES_ENCRYPT);}

void MfRC5::decrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	RC5_32_KEY schd;
	scheduleKeys(key,schd);
	RC5_32_cbc_encrypt(is,os,l,&schd,iv,DES_DECRYPT);}

#include <openssl/cast.h>
//----------------------------------------------------------------------
// CAST128 CRYPT ALGORITHM
void MfCAST128::scheduleKeys(const PObject* key,CAST_KEY& schd) const {
	bool ok=true;
	COCTSTR keys=key->octetsValue(ok);
	CAST_set_key(&schd,key->length(),(OCTSTR)keys);}

void MfCAST128::encrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	CAST_KEY schd;
	scheduleKeys(key,schd);
	CAST_cbc_encrypt(is,os,l,&schd,iv,DES_ENCRYPT);}

void MfCAST128::decrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	CAST_KEY schd;
	scheduleKeys(key,schd);
	CAST_cbc_encrypt(is,os,l,&schd,iv,DES_DECRYPT);}

//----------------------------------------------------------------------
// DES3CBC CRYPT ALGORITHM
void MfDES3CBC::scheduleKeys(const PObject* key,des_key_schedule& schd0,
		des_key_schedule& schd1,des_key_schedule& schd2) const{
	bool ok=true;
	COCTSTR keys=key->octetsValue(ok);
	des_key_sched((DES_CBLOCK_IN)keys,schd0);
	des_key_sched((DES_CBLOCK_IN)(keys+8),schd1);
	des_key_sched((DES_CBLOCK_IN)(keys+16),schd2);}

void MfDES3CBC::encrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	des_key_schedule schd0,schd1,schd2;
	scheduleKeys(key,schd0,schd1,schd2);
	des_ede3_cbc_encrypt(is,os,l,schd0,schd1,schd2,(DES_CBLOCK_IO)iv,DES_ENCRYPT);}

void MfDES3CBC::decrypt(OCTSTR os,OCTSTR is,uint32_t l,const PObject* key,OCTSTR iv) const {
	des_key_schedule schd0,schd1,schd2;
	scheduleKeys(key,schd0,schd1,schd2);
	des_ede3_cbc_encrypt(is,os,l,schd0,schd1,schd2,(DES_CBLOCK_IO)iv,DES_DECRYPT);}

#include <openssl/hmac.h>
//----------------------------------------------------------------------
// HMAC AUTHENTIFICATION ALGORITHM
OCTSTR MfHMAC::init(OCTSTR cp,const PObjectList& a) const {
	HMAC_CTX* ctx=cp!=0?(HMAC_CTX*)cp:new HMAC_CTX;
	bool ok=true;
	COCTSTR key=0;
	uint32_t keylen=0;
	if(a.size()>0) {
		key=a[0]->octetsValue(ok);
		keylen=a[0]->length();}
	HMAC_Init(ctx,(OCTSTR)key,keylen,evp());
	return (OCTSTR)ctx;}

void MfHMAC::update(OCTSTR cp,const PObjectList&,const OCTBUF& s) const {
	HMAC_CTX* ctx=(HMAC_CTX*)cp;
	HMAC_Update(ctx,(OCTSTR)s.string(),s.length());}

PvOctets* MfHMAC::result(OCTSTR cp,const PObjectList&) const {
	HMAC_CTX* ctx=(HMAC_CTX*)cp;
	uint32_t len=EVP_MAX_MD_SIZE;
	octet m[EVP_MAX_MD_SIZE];
	HMAC_Final(ctx,m,&len);
	uint32_t icvlen=icvLength();
	PvOctets* rc=new PvOctets(icvlen);
	OCTSTR os=rc->buffer();
	memcpy(os,m,icvlen);
	HMAC_cleanup(ctx);
	return rc;}

//----------------------------------------------------------------------
// EVP ALGORITHM
EVP_MD* MfHMAC::evp() const {return 0;}
EVP_MD* MfHMACMD5::evp() const {return EVP_md5();}
EVP_MD* MfHMACSHA1::evp() const {return EVP_sha1();}

//----------------------------------------------------------------------
bool MfESPPad::checkArgument(const PFunction&,const PObjectList&) const {
	return true;}
bool MfAuth::checkArgument(const PFunction&,const PObjectList&) const {
	return true;}

//----------------------------------------------------------------------
// xxx([key])
bool MfHMAC::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	uint32_t n=a.size();
	CSTR name=o.metaString();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 argument, not %d",name,n);
		return false;}
	if(n==0) {return true;}
	a[0]->octetsValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be octets",name);
		rc=false;}
	return rc;}

//----------------------------------------------------------------------
// null([alignment])
bool MfCrypt::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	uint32_t n=a.size();
	CSTR name=o.metaString();
	if(n!=0&&n!=1) {
		o.error("E %s must have 0 or 1 argument, not %d",name,n);
		return false;}
	if(n==0) {return true;}
	a[0]->intValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be int",name);
		rc=false;}
	return rc;}

//----------------------------------------------------------------------
// xxx(key[,ivec[,alignment]])
bool MfCryptKey::checkArgument(const PFunction& o,const PObjectList& a) const {
	bool ok=true;
	bool rc=true;
	uint32_t n=a.size();
	CSTR name=o.metaString();
	if(n!=1&&n!=2&&n!=3) {
		o.error("E %s mast have 1-3 arguments, not %d",name,n);
		return false;}
	a[0]->octetsValue(ok);
	if(!ok) {
		o.error("E %s first argument has to be octets",name);
		rc=false;}
	else {
		uint32_t l=a[0]->length();
		uint32_t kl=keyLength();
		if(l!=kl) {
			o.error("E %s key length has to be %d, not %d",name,kl,l);
			rc=false;}}
	if(n>1) {
		a[1]->octetsValue(ok);
		if(!ok) {
			o.error("E %s second argument has to be octets",name);
			rc=false;}
		else {
			uint32_t l=a[1]->length();
			uint32_t il=ivecLength();
			if(l!=il) {
				o.error("E %s ivec length has to be %d, not %d",name,il,l);
				rc=false;}}}
	if(n==3) {
		uint32_t t=a[2]->intValue(ok);
		if(!ok) {
			o.error("E %s third argument has to be int",name);
			rc=false;}
		uint32_t l=t*alignUnit();
		if(l>256) {
			o.error("E %s alignment %d is too big",name,t);
			rc=false;}}
	return rc;}

//----------------------------------------------------------------------
PObject* MfESPPad::tokenObject(int l,CSTR f) const {
	return new PfESPPad(this,f,l);}
PObject* MfCrypt::tokenObject(int l,CSTR f) const {
	return new PfCrypt(this,f,l);}
PObject* MfAuth::tokenObject(int l,CSTR f) const {
	return new PfAuth(this,f,l);}

//----------------------------------------------------------------------
// CONSTRUCTOR/DESTRUCTOR
MfESPPad::MfESPPad(CSTR s,PvOctets* o):MvFunction(s),padding_(o) {}
MfESPPad::~MfESPPad() {}
MfCrypt::MfCrypt(CSTR s,uint8_t k,uint8_t i,uint8_t a):MvFunction(s),
	keyLength_(k),ivecLength_(i),alignUnit_(a),dummy_(0) {}
MfCrypt::~MfCrypt() {}
MfESPPadAny::MfESPPadAny(CSTR s,PvOctets* o):MfESPPad(s,o) {}
MfESPPadAny::~MfESPPadAny() {}
MfCryptKey::MfCryptKey(CSTR s,uint8_t k,uint8_t i,uint8_t a):MfCrypt(s,k,i,a) {}
MfCryptKey::~MfCryptKey() {}
MfDESCBC::MfDESCBC(CSTR s,uint8_t k,uint8_t i,uint8_t a):MfCryptKey(s,k,i,a) {}
MfDESCBC::~MfDESCBC() {}
MfBLOWFISH::MfBLOWFISH(CSTR s,uint8_t k,uint8_t i,uint8_t a):MfCryptKey(s,k,i,a) {}
MfBLOWFISH::~MfBLOWFISH() {}
MfRC5::MfRC5(CSTR s,uint8_t k,uint8_t i,uint8_t a):MfCryptKey(s,k,i,a) {}
MfRC5::~MfRC5() {}
MfCAST128::MfCAST128(CSTR s,uint8_t k,uint8_t i,uint8_t a):MfCryptKey(s,k,i,a) {}
MfCAST128::~MfCAST128() {}
MfDES3CBC::MfDES3CBC(CSTR s,uint8_t k,uint8_t i,uint8_t a):MfCryptKey(s,k,i,a) {}
MfDES3CBC::~MfDES3CBC() {}
MfAuth::MfAuth(CSTR s,uint8_t i,uint8_t a):MvFunction(s),
	icvLength_(i),alignUnit_(a),dummy_(0) {}
MfAuth::~MfAuth() {}
MfHMAC::MfHMAC(CSTR s,uint8_t i,uint8_t a):MfAuth(s,i,a) {}
MfHMAC::~MfHMAC() {}
MfHMACMD5::MfHMACMD5(CSTR s,uint8_t i,uint8_t a):MfHMAC(s,i,a) {}
MfHMACMD5::~MfHMACMD5() {}
MfHMACSHA1::MfHMACSHA1(CSTR s,uint8_t i,uint8_t a):MfHMAC(s,i,a) {}
MfHMACSHA1::~MfHMACSHA1() {}

MfESPPad* MfESPPad::defaultPadding_=0;
