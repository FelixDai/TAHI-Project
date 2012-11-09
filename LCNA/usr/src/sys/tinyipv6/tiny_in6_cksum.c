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

/*	$Id: tiny_in6_cksum.c,v 1.1 2002/05/29 13:30:59 fujita Exp $	*/
/*	$NetBSD: in6_cksum.c,v 1.7 2000/02/06 12:49:43 itojun Exp $	*/

/*
 * Copyright (C) 1995, 1996, 1997, and 1998 WIDE Project.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the project nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/*
 * Copyright (c) 1988, 1992, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)in_cksum.c	8.1 (Berkeley) 6/10/93
 */


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_in6_cksum.h>
#include <tinyipv6/sysdep_utils.h>


/*
 * Checksum routine for Internet Protocol family headers
 *
 * This routine is very heavily used in the network
 * code and should be modified for each CPU to be as fast as possible.
 */

#define ADDCARRY(x)  (x > 65535 ? x -= 65535 : x)
#define REDUCE {l_util.l = sum; sum = l_util.s[0] + l_util.s[1]; ADDCARRY(sum);}

int
tiny_in6_cksum(register tinybuf *tbuf, U_INT8_T nxt,
			   U_INT32_T off, int len)
{
	register U_INT16_T *w;
	register int sum = 0;
	register int rest = 0;
	int byte_swapped = 0;
	struct ip6_hdr *ip6;
	union {
		U_INT16_T phs[4];
		struct {
			U_INT32_T	ph_len;
			U_INT8_T	ph_zero[3];
			U_INT8_T	ph_nxt;
		} ph;
	} uph;
	union {
		U_INT8_T	c[2];
		U_INT16_T	s;
	} s_util;
	union {
		U_INT16_T s[2];
		U_INT32_T l;
	} l_util;

	/* sanity check */
	if (tbuf->len < off + len) {
		/* XXX: */
		panic("tiny_in6_cksum() : tbuf->len < off + len\n",
			  tbuf->len, off, len);
	}

	TINY_BZERO(&uph, sizeof(uph));

	/*
	 * First create IP6 pseudo header and calculate a summary.
	 */
	ip6 = (struct ip6_hdr *)tbuf->pkt;

	w = (U_INT16_T *)&ip6->ip6_src;
	uph.ph.ph_len = htonl(len);
	uph.ph.ph_nxt = nxt;

	/* IPv6 source address */
	sum += w[0]; sum += w[1];
	sum += w[2]; sum += w[3];
	sum += w[4]; sum += w[5];
	sum += w[6]; sum += w[7];
	/* IPv6 destination address */
	sum += w[8]; sum += w[9];
	sum += w[10]; sum += w[11];
	sum += w[12]; sum += w[13];
	sum += w[14]; sum += w[15];
	/* Payload length and upper layer identifier */
	sum += uph.phs[0];  sum += uph.phs[1];
	sum += uph.phs[2];  sum += uph.phs[3];

	/*
	 * Secondly calculate a summary of packet buffer excluding offset.
	 */
	w = (U_INT16_T *)((CADDR_T)tbuf->pkt + off);
	rest = tbuf->len - off;
	if (len < rest)
		rest = len;
	len -= rest;
	/*
	 * Force to even boundary.
	 */
	if ((1 & (long) w) && (rest > 0)) {
		REDUCE;
		sum <<= 8;
		s_util.c[0] = *(U_CHAR *)w;
		w = (U_INT16_T *)((char *)w + 1);
		rest --;
		byte_swapped = 1;
	}
	/*
	 * Unroll the loop to make overhead from
	 * branches &c small.
	 */
	while ((rest -= 32) >= 0) {
		sum += w[0]; sum += w[1]; sum += w[2]; sum += w[3];
		sum += w[4]; sum += w[5]; sum += w[6]; sum += w[7];
		sum += w[8]; sum += w[9]; sum += w[10]; sum += w[11];
		sum += w[12]; sum += w[13]; sum += w[14]; sum += w[15];
		w += 16;
	}
	rest += 32;
	while ((rest -= 8) >= 0) {
		sum += w[0]; sum += w[1]; sum += w[2]; sum += w[3];
		w += 4;
	}
	rest += 8;
	if (rest == 0 && byte_swapped == 0)
		goto next;
	REDUCE;
	while ((rest -= 2) >= 0) {
		sum += *w++;
	}
	if (byte_swapped) {
		REDUCE;
		sum <<= 8;
		byte_swapped = 0;
		if (rest == -1) {
			s_util.c[1] = *(char *)w;
			sum += s_util.s;
			rest = 0;
		}
		else {
			rest = -1;
		}
	}
	else if (rest == -1) {
		s_util.c[0] = *(char *)w;
	}
 next:

	if (len) {
		/* XXX : error */
	}

	if (rest == -1) {
		s_util.c[1] = 0;
		sum += s_util.s;
	}
	REDUCE;
	return (~sum & 0xffff);
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
