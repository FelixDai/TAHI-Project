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

/*	$Id: tiny_ip6_output.c,v 1.2 2002/05/30 09:46:50 fujita Exp $	*/


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/tiny_ip6_output.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/tiny_ip6_var.h>
#include <tinyipv6/tiny_ipsec.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_esp.h>
#include <tinyipv6/sysdep_l2.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/sysdep_spl.h>


int
tiny_ip6_output(tinybuf *tbuf, int flags)
{
	TINY_FUNC_NAME(tiny_ip6_output);
	struct ip6_hdr *ip6;
	int uloff;
	int nxt;
	U_INT32_T pktlen;
	U_INT32_T pldlen;
	TinyNetif netif;
	int error = 0;
	struct nd6_neighbor_cache *nbc = NULL;
	struct nd6_defrouter *dr = NULL;
	TinyBool rv;

	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : output packet buffer is NULL\n",
					 funcname);
		return 0;
	}

	ip6 = (struct ip6_hdr *) tbuf->pkt;

	/*
	  we do not use extension header (exclude ESP),
	  upper layer header offset is same as sizeof ip6_hdr.
	*/
	nxt = ip6->ip6_nxt & 0xff;
	uloff = sizeof(*ip6);

	/* append ESP header if necessary */
	rv = tiny_ipsec_outbound_policy_check(&tbuf, uloff, nxt);
	if (rv == TinyFalse) {
		/* IPsec policy DISCARD */
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : packet discard according to "
					 "ipsec outbound policy\n", funcname);
		goto discard;
	}
	else {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ipsec outbound check ok\n",
					 funcname);
	}

	ip6 = (struct ip6_hdr *) tbuf->pkt;

	pktlen = tbuf->len;
	if (pktlen > LinkMTU) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : packet too big %d (> %d)\n",
					 funcname, pktlen, LinkMTU);
		goto bad;
	}

	if (IN6_IS_ADDR_UNSPECIFIED(&ip6->ip6_src)
		&& (flags & (TINY_IPV6_DADOUTPUT | TINY_IPV6_RSOUTPUT)) == 0) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : src is unspecified, "
					 "but not DAD or RS packet\n", funcname);
		goto bad;
	}

	if (IN6_IS_ADDR_MULTICAST(&ip6->ip6_src)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : src is multicast (invalid)\n",
					 funcname);
		goto bad;
	}

	if (IN6_IS_ADDR_UNSPECIFIED(&ip6->ip6_dst)) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : dst is unspecified, what ???\n",
					 funcname);
		goto bad;
	}

	if (tiny_netif_is_addr_my_unicast(tiny_loopback_netif, &ip6->ip6_dst)
		== TinyTrue) {
		netif = tiny_loopback_netif;
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : dst %s is for loopback\n",
					 funcname, tiny_ip6_sprintf(&ip6->ip6_dst));
		nbc = NULL;
	}
	else if (IN6_IS_ADDR_MULTICAST(&ip6->ip6_dst)) {
		netif = tiny_physical_netif;
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : dst %s is multicast via %s\n",
					 funcname, tiny_ip6_sprintf(&ip6->ip6_dst), netif);
		nbc = NULL;
	}
	else {	/* unicast via physical interface */
		netif = tiny_physical_netif;

		if (tiny_netif_is_addr_on_localnet(netif, &ip6->ip6_dst)
			== TinyTrue) {
			nbc = tiny_nd6_nbrcache_lookup(&ip6->ip6_dst);
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : dst %s is on-link\n",
						 funcname, tiny_ip6_sprintf(&ip6->ip6_dst));
			if (nbc != NULL) {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s: neighbor cache "
							 "for dst (%s), status = %d\n", funcname,
							 tiny_ip6_sprintf(&ip6->ip6_dst), nbc->state);
			}
		}
		else {
			dr = tiny_nd6_choose_defrouter();
			if (dr != NULL) {
				nbc = dr->nbr;
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : dst %s is off-link, "
							 "send via router %s\n", funcname,
							 tiny_ip6_sprintf(&ip6->ip6_dst),
							 tiny_ip6_sprintf(&nbc->saddr6.sin6_addr));
				if (nbc != NULL) {
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : neighbor cache for "
								 "router (%s), status = %d\n", funcname,
								 tiny_ip6_sprintf(&nbc->saddr6.sin6_addr),
								 nbc->state);
				}
			}
			else {
				nbc = tiny_nd6_nbrcache_lookup(&ip6->ip6_dst);
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : dst %s may be off-link, "
							 "but router not found. assume as on-link\n",
							 funcname, tiny_ip6_sprintf(&ip6->ip6_dst));
				if (nbc != NULL) {
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : neighbor cache for "
								 "dst (%s), status = %d\n", funcname,
								 tiny_ip6_sprintf(&ip6->ip6_dst), nbc->state);
				}
			}
		}
		if (nbc == NULL) {
			nbc = tiny_nd6_nbrcache_alloc(&ip6->ip6_dst);
			nbc->saddrdl.sdl_alen = 0;
			nbc->state = TINY_NDCACHE_INCOMPLETE;
		}
		if (nbc->state <= TINY_NDCACHE_INCOMPLETE) {
			nbc->asked = 0;
			nbc->expire = 1;
			if ((flags & TINY_IPV6_NSOUTPUT) == 0) {
				if (nbc->hldpkt != NULL) {
					TINY_LOG_MSG(TINY_LOG_INFO, "%s : discard packet "
								 "on neighbor cache\n", funcname);
					tinybuf_free(nbc->hldpkt);
				}
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : packet queued "
							 "on neighbor cache\n", funcname);
				nbc->hldpkt = tbuf;
				nbc->asked ++;
				if (dr == NULL) {
					tiny_nd6_ns_output(NULL, &ip6->ip6_dst, nbc, 0);
				}
				else {
					tiny_nd6_ns_output(NULL, &nbc->saddr6.sin6_addr, nbc, 0);
				}
				nbc->state = TINY_NDCACHE_INCOMPLETE;				
				nbc->last_send = tiny_get_systime();
				return error;	/* XXX */
			}
		}
	}

	tbuf->netif = netif;
	pldlen = pktlen - sizeof(*ip6);
	ip6->ip6_plen = htons(pldlen);

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : if = %s, tbuf->len = %d\n", funcname,
				 netif, tbuf->len);

	if (nbc != NULL) {
		TIME_T curr_time = tiny_get_systime();
		if (nbc->state ==  TINY_NDCACHE_STALE) {
			nbc->state = TINY_NDCACHE_DELAY;
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : neighnor cache(%s) status "
						 "%d -> %d\n", funcname,
						 tiny_ip6_sprintf(&nbc->saddr6.sin6_addr),
						 TINY_NDCACHE_STALE, TINY_NDCACHE_DELAY);
			nbc->expire = curr_time + nd6_delay;
		}
		nbc->last_send = curr_time;
	}

	tiny_ip6_output_to_l2(tbuf, netif, nbc);
	return error;

 bad:
 discard:
	if (tbuf != NULL) {
		tinybuf_free(tbuf);
	}
	return error;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/

