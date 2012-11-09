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

/*	$Id: tiny_utils.c,v 1.1 2002/05/29 13:31:27 fujita Exp $	*/


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/tiny_utils.h>


char *
tiny_ip6_sprintf(register struct in6_addr *addr)
{
	static char digits[] = "0123456789abcdef";
	static int ip6round = 0;
	static char ip6buf[8][48];
	register int i;
	register char *cp;
	register U_SHORT *a = (U_SHORT *)addr;
	register U_CHAR *d;
	int dcolon = 0;

	ip6round = (ip6round + 1) & 7;
	cp = ip6buf[ip6round];

	for (i = 0; i < 8; i ++) {
		if (dcolon == 1) {
			if (*a == 0) {
				if (i == 7)
					*cp ++ = ':';
				a ++;
				continue;
			}
			else
				dcolon = 2;
		}
		if (*a == 0) {
			if (dcolon == 0 && *(a + 1) == 0) {
				if (i == 0)
					*cp ++ = ':';
				*cp ++ = ':';
				dcolon = 1;
			}
			else {
				*cp ++ = '0';
				*cp ++ = ':';
			}
			a ++;
			continue;
		}
		d = (U_CHAR *)a;
		*cp ++ = digits[*d >> 4];
		*cp ++ = digits[*d ++ & 0xf];
		*cp ++ = digits[*d >> 4];
		*cp ++ = digits[*d & 0xf];
		*cp ++ = ':';
		a ++;
	}
	*-- cp = 0;
	return (ip6buf[ip6round]);
}


char *
tiny_hexstr_printf(U_CHAR *input, U_CHAR *output, int size)
{
	int i;
	int work;
	for (i = 0; i < size; i ++) {
		work = (int)input[i];
		work &= 0xff;
		sprintf(&output[i * 2], "%02x", work);
	}
	output[i * 2] = 0;
	return output;
}


void
tiny_random_stream(int len, char *dst)
{
	union {
		long l;
		char c[4];
	} ubuf;
	int n = 0;

	if (dst == NULL) {
		return;
	}
	while (n + sizeof(ubuf.c) <= len) {
		ubuf.l = TINY_RANDOM();
		TINY_BCOPY(ubuf.c, dst + n, sizeof(ubuf.c));
		n += sizeof(ubuf.c);
	}
	if (n != len) {
		ubuf.l = TINY_RANDOM();
		TINY_BCOPY(ubuf.c, dst + n, (len - n));
	}
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
