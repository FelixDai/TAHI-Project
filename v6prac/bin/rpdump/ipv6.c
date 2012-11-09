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
 * $Id: ipv6.c,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

#include "general.h"

void
ipv6(struct pktinfo *pktinfo)
{
    register struct ip6_hdr *ip6 = NULL;
    struct addr_6 addr_6;
    struct tcphdr *tcphdr = NULL;
    struct udphdr *udphdr = NULL;
    struct pktinfo n_hdr;
    register int ipv6_p = 0;
    char *addr = NULL;
    const u_char *pkt = pktinfo->pkt;
    bpf_u_int32 len = pktinfo->len;

    ip6 = (struct ip6_hdr *)pkt;
    ipv6_p = ip6->ip6_nxt;

    addr_6.src = ip6->ip6_src;
    addr_6.dst = ip6->ip6_dst;

    len -= sizeof(struct ip6_hdr);
    pkt += sizeof(struct ip6_hdr);

    n_hdr.len = len;
    n_hdr.pkt = pkt;

    addr_6.p_udp = NULL;
    addr_6.p_tcp = NULL;
    addr_6.nxtflag = 0;

    if (ipv6_p == IPPROTO_TCP) {
        tcphdr = (struct tcphdr *)pkt;
        addr_6.p_tcp = tcphdr;
        addr_6.nxtflag = 1;
    }
    else if (ipv6_p == IPPROTO_UDP) {
        udphdr = (struct udphdr *)pkt;
        addr_6.p_udp = udphdr;
        addr_6.nxtflag = 2;
    }

    addr = v6_addr(&addr_6, encap);

    encap ++;

#ifndef IPPROTO_OSPF
#define IPPROTO_OSPF 89
#endif
#ifndef IPPROTO_IPV4
#define IPPROTO_IPV4    4
#endif


    switch(ipv6_p) {
        case IPPROTO_HOPOPTS:
            break;
        case IPPROTO_DSTOPTS:
            break;
        case IPPROTO_FRAGMENT:
            break;
        case IPPROTO_ROUTING:
            break;
        case IPPROTO_TCP:
            if (rflag != 1)
                tcp(&n_hdr);
            break;
        case IPPROTO_UDP:
            if (bflag != 1)
                udp(&n_hdr);
            break;
        case IPPROTO_OSPF:
            break;
        case IPPROTO_IPV6:
            ipv6(&n_hdr);
            break;
        case IPPROTO_IPV4:
            ip(&n_hdr);
            break;
        default:
    }
}/* ipv6 */
