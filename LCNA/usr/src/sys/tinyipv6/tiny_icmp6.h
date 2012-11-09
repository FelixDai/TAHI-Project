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

/*	$Id: tiny_icmp6.h,v 1.1 2002/05/29 13:30:57 fujita Exp $	*/
/*	$NetBSD: icmp6.h,v 1.9.2.4 2000/08/16 01:22:21 itojun Exp $	*/
/*	$KAME: icmp6.h,v 1.22 2000/08/03 15:25:16 jinmei Exp $	*/

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
 * Copyright (c) 1982, 1986, 1993
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
 *	@(#)ip_icmp.h	8.1 (Berkeley) 6/10/93
 */


#ifndef	_TINYIPV6_TINY_ICMP6_H_
#define	_TINYIPV6_TINY_ICMP6_H_


#define ICMPV6_PLD_MAXLEN	\
	(IPV6_MMTU - sizeof(struct ip6_hdr) - sizeof(struct icmp6_hdr))

struct icmp6_hdr {
	U_INT8_T	icmp6_type;				/* type field */
	U_INT8_T	icmp6_code;				/* code field */
	U_INT16_T	icmp6_cksum;			/* checksum field */
	union {
		U_INT32_T	icmp6_un_data32[1]; /* type-specific field */
		U_INT16_T	icmp6_un_data16[2]; /* type-specific field */
		U_INT8_T	icmp6_un_data8[4];  /* type-specific field */
	} icmp6_dataun;
#define icmp6_data32	icmp6_dataun.icmp6_un_data32
#define icmp6_data16	icmp6_dataun.icmp6_un_data16
#define icmp6_data8		icmp6_dataun.icmp6_un_data8
#define icmp6_pptr		icmp6_data32[0]		/* parameter prob */
#define icmp6_mtu		icmp6_data32[0]		/* packet too big */
#define icmp6_id		icmp6_data16[0]		/* echo request/reply */
#define icmp6_seq		icmp6_data16[1]		/* echo request/reply */
#define icmp6_maxdelay	icmp6_data16[0]		/* mcast group membership */
};


/* supported ICMP6 'type' on tiny-ipv6 */
#define ICMP6_DST_UNREACH			1	/* dest unreachable, codes: */
#define ICMP6_PACKET_TOO_BIG		2	/* packet too big */
#define ICMP6_TIME_EXCEEDED			3	/* time exceeded, code: */
#define ICMP6_PARAM_PROB			4	/* ip6 header bad */

#define ICMP6_ECHO_REQUEST			128	/* echo service */
#define ICMP6_ECHO_REPLY			129	/* echo reply */

#define ND_ROUTER_SOLICIT			133	/* router solicitation */
#define ND_ROUTER_ADVERT			134	/* router advertisment */
#define ND_NEIGHBOR_SOLICIT			135	/* neighbor solicitation */
#define ND_NEIGHBOR_ADVERT			136	/* neighbor advertisment */
#define ND_REDIRECT					137	/* redirect */

/* supported ICMP6 'code' on tiny-ipv6 */
#define ICMP6_DST_UNREACH_NOROUTE		0	/* no route to destination */
#define ICMP6_DST_UNREACH_ADMIN	 		1	/* administratively prohibited */
#define ICMP6_DST_UNREACH_NOTNEIGHBOR	2	/* not a neighbor(obsolete) */
#define ICMP6_DST_UNREACH_BEYONDSCOPE	2	/* beyond scope of source address */
#define ICMP6_DST_UNREACH_ADDR			3	/* address unreachable */
#define ICMP6_DST_UNREACH_NOPORT		4	/* port unreachable */

#define ICMP6_TIME_EXCEED_TRANSIT 		0	/* ttl==0 in transit */
#define ICMP6_TIME_EXCEED_REASSEMBLY	1	/* ttl==0 in reass */

#define ICMP6_PARAMPROB_HEADER 	 		0	/* erroneous header field */
#define ICMP6_PARAMPROB_NEXTHEADER		1	/* unrecognized next header */
#define ICMP6_PARAMPROB_OPTION			2	/* unrecognized option */


/*
 * Neighbor Discovery
 */

struct nd_router_solicit {	/* router solicitation */
	struct icmp6_hdr 	nd_rs_hdr;
	/* could be followed by options */
#define nd_rs_type		nd_rs_hdr.icmp6_type
#define nd_rs_code		nd_rs_hdr.icmp6_code
#define nd_rs_cksum		nd_rs_hdr.icmp6_cksum
#define nd_rs_reserved	nd_rs_hdr.icmp6_data32[0]
};


struct nd_router_advert {	/* router advertisement */
	struct icmp6_hdr	nd_ra_hdr;
	U_INT32_T			nd_ra_reachable;	/* reachable time */
	U_INT32_T			nd_ra_retransmit;	/* retransmit timer */
	/* could be followed by options */
#define nd_ra_type				nd_ra_hdr.icmp6_type
#define nd_ra_code				nd_ra_hdr.icmp6_code
#define nd_ra_cksum				nd_ra_hdr.icmp6_cksum
#define nd_ra_curhoplimit		nd_ra_hdr.icmp6_data8[0]
#define nd_ra_flags_reserved	nd_ra_hdr.icmp6_data8[1]
#define ND_RA_FLAG_MANAGED		0x80
#define ND_RA_FLAG_OTHER		0x40
#define nd_ra_router_lifetime	nd_ra_hdr.icmp6_data16[1]
};


struct nd_neighbor_solicit {	/* neighbor solicitation */
	struct icmp6_hdr	nd_ns_hdr;
	struct in6_addr		nd_ns_target;	/*target address */
	/* could be followed by options */
#define nd_ns_type		nd_ns_hdr.icmp6_type
#define nd_ns_code		nd_ns_hdr.icmp6_code
#define nd_ns_cksum		nd_ns_hdr.icmp6_cksum
#define nd_ns_reserved	nd_ns_hdr.icmp6_data32[0]
};


struct nd_neighbor_advert {	/* neighbor advertisement */
	struct icmp6_hdr	nd_na_hdr;
	struct in6_addr		nd_na_target;	/* target address */
	/* could be followed by options */
#define nd_na_type		nd_na_hdr.icmp6_type
#define nd_na_code		nd_na_hdr.icmp6_code
#define nd_na_cksum		nd_na_hdr.icmp6_cksum
#define nd_na_flags_reserved	nd_na_hdr.icmp6_data32[0]
};

#if BYTE_ORDER == BIG_ENDIAN
#define ND_NA_FLAG_ROUTER		0x80000000
#define ND_NA_FLAG_SOLICITED	0x40000000
#define ND_NA_FLAG_OVERRIDE		0x20000000
#else
#if BYTE_ORDER == LITTLE_ENDIAN
#define ND_NA_FLAG_ROUTER		0x80
#define ND_NA_FLAG_SOLICITED	0x40
#define ND_NA_FLAG_OVERRIDE		0x20
#endif
#endif


struct nd_opt_hdr {		/* Neighbor discovery option header */
	U_INT8_T	nd_opt_type;
	U_INT8_T	nd_opt_len;
	/* followed by option specific data*/
};

#define ND_OPT_SOURCE_LINKADDR		1
#define ND_OPT_TARGET_LINKADDR		2
#define ND_OPT_PREFIX_INFORMATION	3
#define ND_OPT_REDIRECTED_HEADER	4
#define ND_OPT_MTU					5

struct nd_opt_prefix_info {	/* prefix information */
	U_INT8_T	nd_opt_pi_type;
	U_INT8_T	nd_opt_pi_len;
	U_INT8_T	nd_opt_pi_prefix_len;
	U_INT8_T	nd_opt_pi_flags_reserved;
	U_INT32_T	nd_opt_pi_valid_time;
	U_INT32_T	nd_opt_pi_preferred_time;
	U_INT32_T	nd_opt_pi_reserved2;
	struct in6_addr	nd_opt_pi_prefix;
};

#define ND_OPT_PI_FLAG_ONLINK	0x80
#define ND_OPT_PI_FLAG_AUTO		0x40


struct nd_opt_mtu {		/* MTU option */
	U_INT8_T	nd_opt_mtu_type;
	U_INT8_T	nd_opt_mtu_len;
	U_INT16_T	nd_opt_mtu_reserved;
	U_INT32_T	nd_opt_mtu_mtu;
};



extern void tiny_icmp6_init(void);
extern void tiny_icmp6_error(tinybuf *tbuf,
							 int type, int code, int param);
extern int tiny_icmp6_input(tinybuf **tbufp, int *offp);


#endif	/* _TINYIPV6_TINY_ICMP6_H_ */


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
