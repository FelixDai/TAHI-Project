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

/*	$Id: sysdep_l2.c,v 1.1 2002/05/29 13:30:36 fujita Exp $	*/


#include <sys/param.h>
#include <machine/intr.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_ether.h>
#include <sys/mbuf.h>


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/tiny_ip6_input.h>
#include <tinyipv6/sysdep_spl.h>
#include <tinyipv6/sysdep_l2.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/tiny_utils.h>


struct ifqueue ip6intrq;
static int ip6qmaxlen = IFQ_MAXLEN;


void
tiny_ip6q_init(void)
{
	ip6intrq.ifq_maxlen = ip6qmaxlen;
}


void
tiny_ip6intr(void)
{
	TINY_FUNC_NAME(tiny_ip6intr);
	PRILEV p;
	struct mbuf *m;
	tinybuf *tbuf;

	for (;;) {
		p = SPLIMP();
		IF_DEQUEUE(&ip6intrq, m);
		SPLX(p);

		if (m == 0)
			break;

		tbuf = sysbuf2tinybuf((void *)m);
		if (tbuf == NULL) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : tbuf == NULL\n", funcname);
			return;
		}

		tiny_ip6_input(tbuf);
	}
}


int
tiny_ip6intrq_length(void)
{
	PRILEV p;
	int len;
	p = SPLIMP();
	len = ip6intrq.ifq_len;
	SPLX(p);
	return len;
}


/*
 * output IP6 packet to L2
 */
void
tiny_ip6_output_to_l2(tinybuf *tbuf, TinyNetif netif,
					  struct nd6_neighbor_cache *nbc)
{
	TINY_FUNC_NAME(tiny_ip6_output_to_l2);
	struct ifnet *ifp;
	struct mbuf *m;
	struct ip6_hdr *ip6;
	struct sockaddr_in6 dst;
	int rv;

	ifp = ifunit(netif);
	if (tbuf == NULL) {
		return;
	}

	ip6 = (struct ip6_hdr *)tbuf->pkt;

	if (nbc != NULL) {
		dst = nbc->saddr6;
	}
	else {
		dst.sin6_len = sizeof(struct sockaddr_in6);
		dst.sin6_family = AF_INET6;
		dst.sin6_addr = ip6->ip6_dst;
	}

	m = (struct mbuf *)tinybuf2sysbuf(tbuf);
	if (m == NULL) {
		/* XXX */
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : m == NULL\n", funcname);
		return;
	}

	if (ifp == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : ifp == NULL\n", funcname);
		return;
	}

	if (IN6_IS_ADDR_MULTICAST(&ip6->ip6_dst)) {
		m->m_flags |= M_MCAST;	/* XXX */
	}

TINY_LOG_MSG(TINY_LOG_INFO, "%s : src = %s, dst = %s\n", funcname,
				 tiny_ip6_sprintf(&ip6->ip6_src),
				 tiny_ip6_sprintf(&dst.sin6_addr));
	rv = (*ifp->if_output)(ifp, m, (struct sockaddr *)&dst, NULL);/* XXX */
	if (rv != 0) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : if_output() returns %d\n",
					 funcname, rv);
	}
}


/***XXX***/
int
nd6_storelladdr(struct ifnet *ifp, struct rtentry *rt, struct mbuf *m,
				struct sockaddr *dst, U_CHAR *desten)/* in ether_output() */
{
	TINY_FUNC_NAME(nd6_storelladdr);
	struct nd6_neighbor_cache *nbc;
	struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)dst;
	char enaddr[6];

	if (IN6_IS_ADDR_MULTICAST(&saddr6->sin6_addr)) {
		ETHER_MAP_IPV6_MULTICAST(&saddr6->sin6_addr, enaddr);
	}
	else {
		nbc = tiny_nd6_nbrcache_lookup(&saddr6->sin6_addr);
		if (nbc == NULL) {
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : can't find neighbor cache"
						 " entry for %s\n", funcname,
						 tiny_ip6_sprintf(&saddr6->sin6_addr));
			/* XXX */
			ETHER_MAP_IPV6_MULTICAST(&saddr6->sin6_addr, enaddr);
		}
		else {
			TINY_BCOPY(LLADDR(&nbc->saddrdl), enaddr, sizeof(enaddr));
		}
	}
	TINY_BCOPY(enaddr, desten, sizeof(enaddr));
	TINY_LOG_MSG(TINY_LOG_INFO, "%s : dst = %s\n", funcname,
				 ether_sprintf(enaddr));
	return 1;
}



/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
