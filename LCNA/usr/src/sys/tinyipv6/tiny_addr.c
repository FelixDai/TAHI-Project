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

/*	$Id: tiny_addr.c,v 1.1 2002/05/29 13:30:47 fujita Exp $ */

#include <sys/param.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_types.h>
#include <tinyipv6/tiny_addr.h>
#include <tinyipv6/sysdep_utils.h>


struct in6_addr *
tiny_get_prefix_from_addr(struct in6_addr *addr, int pfxlen,
						  struct in6_addr *prefix)
{
	TINY_FUNC_NAME(tiny_get_prefix_from_addr);
	struct in6_addr mask;
	int i;
	int p;
	if ((pfxlen < 0) || (pfxlen > 128)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : invalid prefix length %d\n",
					 funcname, pfxlen);
		return NULL;
	}
	for (i = 0; i < 4; i ++) {
		mask.s6_addr32[i] = 0xffffffff;
	}
	p = 128 - pfxlen;
	i = 15;
	while (p > 0) {
		if (p >= 8) {
			mask.s6_addr8[i] = 0;
			i --;
			p -= 8;
		}
		else {
			mask.s6_addr8[i] <<= p;
			p = 0;
		}
	}
	for (i = 0; i < 4; i ++) {
		prefix->s6_addr32[i] = addr->s6_addr32[i] & mask.s6_addr32[i];
	}
	return prefix;
}


struct in6_addr *
tiny_get_ifid_from_addr(struct in6_addr *addr, int pfxlen,
						struct in6_addr *ifid)
{
	TINY_FUNC_NAME(tiny_get_ifid_from_addr);
	struct in6_addr mask;
	int i;
	int p;
	if ((pfxlen < 0) || (pfxlen > 128)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : invalid prefix length %d\n",
					 funcname, pfxlen);
		return NULL;
	}
	for (i = 0; i < 4; i ++) {
		mask.s6_addr32[i] = 0xffffffff;
	}
	p = pfxlen;
	i = 0;
	while (p > 0) {
		if (p >= 8) {
			mask.s6_addr8[i] = 0;
			i ++;
			p -= 8;
		}
		else {
			mask.s6_addr8[i] >>= p;
			p = 0;
		}
	}
	for (i = 0; i < 4; i ++) {
		ifid->s6_addr32[i] = addr->s6_addr32[i] & mask.s6_addr32[i];
	}
	return ifid;
}


int
tiny_addr_get_match_length(struct in6_addr *addr1, struct in6_addr *addr2)
{
	int len = 0;
	int i;
	for (i = 0; i < 4; i ++) {
		if (addr1->s6_addr32[i] == addr2->s6_addr32[i]) {
			len += 32;
		}
		else {
			int j;
			for (j = 0; j < 2; j ++) {
				int idx = i * 2 + j;
				if (addr1->s6_addr16[idx] == addr2->s6_addr16[idx]) {
					len += 16;
				}
				else {
					int k;
					for (k = 0; k < 2; k ++) {
						int idx2 = idx * 2 + k;
						if (addr1->s6_addr8[idx2] == addr2->s6_addr8[idx2]) {
							len += 8;
						}
						else {
							int l;
							U_INT8_T xor
								= addr1->s6_addr8[idx2]
								^ addr2->s6_addr8[idx2];
							for (l = 0; l < 8; l ++) {
								if ((xor & 0x80) == 0){
									len ++;
									xor <<= 1;
								}
								else {
									break;
								}
							}
							break;
						}
					}
					break;
				}
			}
			break;
		}
	}
	return len;
}


TinyBool
tiny_addr_prefix_equal(struct in6_addr *addr,
						struct in6_addr *prefix, int prefixlen)
{
	if (tiny_addr_get_match_length(addr, prefix) >= prefixlen) {
		return TinyTrue;
	}
	else {
		return TinyFalse;
	}
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
