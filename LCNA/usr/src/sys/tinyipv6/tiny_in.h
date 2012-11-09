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

/*	$Id: tiny_in.h,v 1.1 2002/05/29 13:30:57 fujita Exp $	*/
/*	$NetBSD: in.h,v 1.47.4.2 2001/04/24 22:21:35 he Exp $	*/

/*
 * Copyright (c) 1982, 1986, 1990, 1993
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
 *	@(#)in.h	8.3 (Berkeley) 1/3/94
 */

/*
 * Constants and structures defined by the internet system,
 * Per RFC 790, September 1981, and numerous additions.
 */

#ifndef _TINYIPV6_TINY_IN_H_
#define	_TINYIPV6_TINY_IN_H_


/*
 * Protocols
 */
#define	IPPROTO_IP			0		/* dummy for IP */
#define IPPROTO_HOPOPTS		0		/* IP6 hop-by-hop options */
#define	IPPROTO_TCP			6		/* tcp */
#define	IPPROTO_UDP			17		/* user datagram protocol */
#define IPPROTO_IPV6		41		/* IP6 header */
#define IPPROTO_ROUTING		43		/* IP6 routing header */
#define IPPROTO_FRAGMENT	44		/* IP6 fragmentation header */
#define	IPPROTO_ESP			50 		/* encap. security payload */
#define	IPPROTO_AH			51 		/* authentication header */
#define IPPROTO_IPV6_ICMP	58		/* IPv6 ICMP */
#define IPPROTO_ICMPV6		58		/* ICMP6 */
#define IPPROTO_NONE		59		/* IP6 no next header */
#define IPPROTO_DSTOPTS		60		/* IP6 destination option */

#define	IPPROTO_RAW			255		/* raw IP packet */
#define	IPPROTO_MAX			256

/* last return value of *_input(), meaning "all job for this pkt is done".  */
#define	IPPROTO_DONE		257


/*
 * Local port number conventions:
 *
 * Ports < IPPORT_RESERVED are reserved for privileged processes (e.g. root),
 * unless a kernel is compiled with IPNOPRIVPORTS defined.
 *
 * When a user does a bind(2) or connect(2) with a port number of zero,
 * a non-conflicting local port address is chosen.
 *
 * The default range is IPPORT_ANONMIX to IPPORT_ANONMAX, although
 * that is settable by sysctl(3); net.inet.ip.anonportmin and
 * net.inet.ip.anonportmax respectively.
 *
 * A user may set the IPPROTO_IP option IP_PORTRANGE to change this
 * default assignment range.
 *
 * The value IP_PORTRANGE_DEFAULT causes the default behavior.
 *
 * The value IP_PORTRANGE_HIGH is the same as IP_PORTRANGE_DEFAULT,
 * and exists only for FreeBSD compatibility purposes.
 *
 * The value IP_PORTRANGE_LOW changes the range to the "low" are
 * that is (by convention) restricted to privileged processes.
 * This convention is based on "vouchsafe" principles only.
 * It is only secure if you trust the remote host to restrict these ports.
 * The range is IPPORT_RESERVEDMIN to IPPORT_RESERVEDMAX.
 */

#define	IPPORT_RESERVED		1024
#define	IPPORT_ANONMIN		49152
#define	IPPORT_ANONMAX		65535
#define	IPPORT_RESERVEDMIN	600
#define	IPPORT_RESERVEDMAX	(IPPORT_RESERVED-1)


#ifndef _NETINET_IN_H_
/*
 * Internet address (a structure for historical reasons)
 */
struct in_addr {
	U_INT32_T s_addr;
} __attribute__((__packed__));


/*
 * Socket address, internet style.
 */
struct sockaddr_in {
	U_INT8_T  sin_len;
	U_INT8_T  sin_family;
	U_INT16_T sin_port;
	struct    in_addr sin_addr;
	INT8_T    sin_zero[8];
};
#endif	/* _NETINET_IN_H_ */

#define IP_MAX_MEMBERSHIPS      20      /* per socket; must fit in one mbuf */

#endif /* _TINYIPV6_TINY_IN_H_ */

/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/

