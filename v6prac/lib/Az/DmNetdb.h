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
#if !defined(__DmNetdb_h__)
#define __DmNetdb_h__	1
#include "pzCommon.h"
#include "DmObject.h"
#include "CmString.h"
#include "CmCltn.h"
class DmNetdb:public DmName {
private:
static	bool convert_;
public:
	DmNetdb(CSTR);
virtual	~DmNetdb();
virtual	void describe(const MObject*,const PObject* o) const;
virtual	void describeConvert(const MObject*,const PObject* o) const;
static	void initialize();
static	void convert(bool);
static	bool convert();
};
inline void DmNetdb::convert(bool b) {convert_=b;}
inline bool DmNetdb::convert() {return convert_;}

class PortName {
	int16_t port_;
	CmCString name_;
public:
	PortName(int16_t,CSTR =0);
	uint32_t hash() const;
	bool isEqual(const PortName*) const;
	CSTR name() const;
};
interfaceCmSet(PortSet,PortName);

class DmPort:public DmNetdb {
public:
	enum eProtocol {none_=0,tcp_,udp_};
private:
	eProtocol protocol_;
static	PortSet udpSets_;
static	PortSet tcpSets_;
public:
	DmPort(CSTR,eProtocol);
virtual	~DmPort();
virtual	void describeConvert(const MObject*,const PObject* o) const;
	eProtocol protocol() const {return protocol_;}
static	void initialize();
static	PortName* lookup(int32_t,eProtocol);
};

class OctetsName {
	const PvOctets* octets_;
	CmCString name_;
public:
	OctetsName(const PvOctets*,CSTR =0);
	uint32_t hash() const;
	bool isEqual(const OctetsName*) const;
	CSTR name() const;
	const PvOctets* octets() const;
};
interfaceCmSet(OctetsSet,OctetsName);

class DmAddr:public DmNetdb {
public:
	DmAddr(CSTR);
virtual	~DmAddr();
virtual	void describeConvert(const MObject*,const PObject* o) const;
static	OctetsName* lookup(const PvOctets*,OctetsSet*);
virtual	OctetsSet* dictionary() const;
};

class DmV4Addr:public DmAddr {
private:
static	OctetsSet sets_;
public:
	DmV4Addr(CSTR);
virtual	~DmV4Addr();
virtual	OctetsSet* dictionary() const;
};

class DmV6Addr:public DmAddr {
private:
static	OctetsSet sets_;
public:
	DmV6Addr(CSTR);
virtual	~DmV6Addr();
virtual	OctetsSet* dictionary() const;
};
#endif
