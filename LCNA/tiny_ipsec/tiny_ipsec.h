/*
 * Copyright (C) 2002 Yokogawa Electric Corporation , 
 * INTAP(Interoperability Technology Association for Information 
 * Processing, Japan) , IPA (Information-technology Promotion Agency,Japan)
 * All rights reserved.
 * 
 * 
 * 
 * Redistribution and use of this software in source and binary forms, with 
 * or without modification, are permitted provided that the following 
 * conditions and disclaimer are agreed and accepted by the user:
 * 
 * 1. Redistributions of source code must retain the above copyright 
 * notice, this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright 
 * notice, this list of conditions and the following disclaimer in the 
 * documentation and/or other materials provided with the distribution.
 * 
 * 3. Neither the names of the copyrighters, the name of the project which 
 * is related to this software (hereinafter referred to as "project") nor 
 * the names of the contributors may be used to endorse or promote products 
 * derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND 
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING 
 * BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 * FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE 
 * COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT,STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ipsecdb.h>


#define	TINY_IPSEC_DBSIZE	TINY_IPSECDB_SPACE
#define	TINY_IPSEC_DEVICE	"/dev/tiny_ipsec"
#define	TINY_IPSEC_ESP_SCHEDSIZ	384


struct tiny_ipsec_paramname {
	int type;
#define	TINY_IPSEC_PTYPE_NONE		0
#define	TINY_IPSEC_PTYPE_LIFETIME	1
#define	TINY_IPSEC_PTYPE_SPI		2
#define	TINY_IPSEC_PTYPE_PROTO		3
#define	TINY_IPSEC_PTYPE_SEND_PEER	4
#define	TINY_IPSEC_PTYPE_RECV_PEER	5
#define	TINY_IPSEC_PTYPE_SEND_MYSELF	6
#define	TINY_IPSEC_PTYPE_RECV_MYSELF	7
#define	TINY_IPSEC_PTYPE_OUTPOLICY	8
#define	TINY_IPSEC_PTYPE_INPOLICY	9
#define	TINY_IPSEC_PTYPE_ESP_ALG	10
#define	TINY_IPSEC_PTYPE_ESP_KEY	11
#define	TINY_IPSEC_PTYPE_ESP_AUTH_ALG	12
#define	TINY_IPSEC_PTYPE_ESP_AUTH_KEY	13
	char *name;
};
