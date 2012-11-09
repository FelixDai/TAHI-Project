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
 * $Id: ip.c,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

#include "general.h"

void
ip(struct pktinfo *pktinfo)
{
    register const struct ip *ipv4 = NULL;
    register int ipv4_p = 0;                           /* next header */
    const struct in_addr *ipv4_src = NULL;
    const struct in_addr *ipv4_dst = NULL;
    struct addr_4 addr_ipv4;
    struct udphdr *udphdr = NULL;
    struct tcphdr *tcphdr = NULL;
    struct pktinfo n_hdr;
    u_int32_t src = 0;
    u_int32_t dst = 0;
    char *addr = NULL;
    const u_char *pkt = pktinfo->pkt;
    bpf_u_int32 len = pktinfo->len;

    ipv4 = (const struct ip *)pkt;

    /* next header type code */
    ipv4_p = ipv4->ip_p;

    /* IPv4 address */
    ipv4_src = &ipv4->ip_src;
    ipv4_dst = &ipv4->ip_dst;
    src = htonl(ipv4_src->s_addr);
    dst = htonl(ipv4_dst->s_addr);

    addr_ipv4.src = src;
    addr_ipv4.dst = dst;

    len -= sizeof(struct ip);
    pkt += sizeof(struct ip);

    n_hdr.len = len;
    n_hdr.pkt = pkt;

    addr_ipv4.p_tcp = NULL;
    addr_ipv4.p_udp = NULL;
    addr_ipv4.nxtflag = 0;

    if (ipv4_p == IPPROTO_TCP) {
        tcphdr = (struct tcphdr *)pkt;
        addr_ipv4.p_tcp = tcphdr;
        addr_ipv4.nxtflag = 1;
    }
    else if (ipv4_p == IPPROTO_UDP) {
        udphdr = (struct udphdr *)pkt;
        addr_ipv4.p_udp = udphdr;
        addr_ipv4.nxtflag = 2;
    }

    addr = v4_addr(&addr_ipv4, encap);

    encap ++;

    switch(ipv4_p) {
        case IPPROTO_IPV4 :	/* IP header */
            ip(&n_hdr);
            break;
        case IPPROTO_TCP :	/* tcp */
            if (rflag != 1)
                tcp(&n_hdr);
            break;
        case IPPROTO_UDP :	/* user datagram protocol */
            if (bflag != 1)
                udp(&n_hdr);
            break;
        case IPPROTO_IPV6 :	/* IP6 header */
            ipv6(&n_hdr);
            break;
        default:
    } /* end of switch */
} /* end of ip() */
