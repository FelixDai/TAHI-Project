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

/*	$Id: tiny_nd6_nbr.c,v 1.1 2002/05/29 13:31:12 fujita Exp $	*/
/*	$NetBSD: nd6_nbr.c,v 1.22.4.2 2001/05/09 19:42:58 he Exp $	*/
/*	$KAME: nd6_nbr.c,v 1.51 2001/01/20 17:27:00 itojun Exp $	*/

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


#include <sys/param.h>
#include <sys/socket.h>
#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/tiny_in.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_icmp6.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/tiny_ip6_var.h>
#include <tinyipv6/tiny_in6_cksum.h>
#include <tinyipv6/tiny_ip6_output.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_netif.h>
#include <tinyipv6/sysdep_spl.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/sysdep_l2.h>


/*
 * Input an Neighbor Solicitation Message.
 */
void
tiny_nd6_ns_input(tinybuf *tbuf, int off, int icmp6len)
{
	TINY_FUNC_NAME(tiny_nd6_ns_input);
	struct ip6_hdr *ip6;
	struct nd_neighbor_solicit *nd_ns;
	TinyBool dad_ns = TinyFalse;
	struct in6_addr src6;
	struct in6_addr dst6;
	struct in6_addr tgt6;
	struct in6_addr myaddr6;
	union nd_opts ndopts;
	char *lladdr;
	int lladdrlen = 0;
	char *mylladdr;
	int mylladdrlen;
	TinyBool tentative = TinyFalse;
	TinyBool duplicated = TinyFalse;
	TinyBool tgtlla_opt;
	TinyNetif netif = tiny_physical_netif;	/* ND works only on physical interface */

	TINY_LOG_MSG(TINY_LOG_INFO, "%s : icmp6len = %d\n", funcname, icmp6len);

	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : tbuf == NULL\n", funcname);
		return;
	}
		
	ip6 = (struct ip6_hdr *)tbuf->pkt;

	if (ip6->ip6_hlim != 255) {
		goto discard;
	}

	/*
	 *	icmp6->icmp6_cksum and icmp6->icmp6_code validation
	 *	is already done in tiny_icmp6_input()
	 */

	src6 = ip6->ip6_src;
	dst6 = ip6->ip6_dst;

	if (IN6_IS_ADDR_UNSPECIFIED(&src6)) {
		/* dst has to be solicited node multicast address. */
		if (dst6.s6_addr16[0] == IPV6_ADDR_INT16_MLL
			&& dst6.s6_addr32[1] == 0
			&& dst6.s6_addr32[2] == IPV6_ADDR_INT32_ONE
			&& dst6.s6_addr8[12] == 0xff) {
			/*good*/
			dad_ns = TinyTrue;
		}
		else {
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : bad DAD packet "
						 "(wrong ip6 dst)\n", funcname);
			goto discard;
		}
	}

	if (icmp6len < sizeof(struct nd_neighbor_solicit)) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : bad NS, packet too short "
					 "icmp6len = %d\n", funcname, icmp6len);
		goto discard;
	}

	nd_ns = (struct nd_neighbor_solicit *)((CADDR_T)ip6 + off);
	tgt6 = nd_ns->nd_ns_target;

	if (IN6_IS_ADDR_MULTICAST(&tgt6)) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : bad NS target (multicast)\n",
					 funcname);
		goto discard;
	}

	icmp6len -= sizeof(*nd_ns);
	tiny_nd6_option_init(nd_ns + 1, icmp6len, &ndopts);
	if (tiny_nd6_options(&ndopts) < 0) {
		/* something wrong in option */
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : invalid option\n", funcname);
		goto discard;
	}

	lladdr = NULL;
	if (ndopts.nd_opts_src_lladdr != NULL) {
		lladdr = (char *)(ndopts.nd_opts_src_lladdr + 1);
		lladdrlen = ndopts.nd_opts_src_lladdr->nd_opt_len << 3;
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : link-layer address option found\n",
					 funcname);
	}

	if (IN6_IS_ADDR_UNSPECIFIED(&ip6->ip6_src) && (lladdr != NULL)) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : bad DAD packet "
					 "(link-layer address option)\n", funcname);
		goto discard;
	}

	/*
	 * Attaching target link-layer address to the NA?
	 * (RFC 2461 7.2.4)
	 *
	 * NS IP dst is unicast/anycast				MUST NOT add
	 * NS IP dst is solicited-node multicast	MUST add
	 *
	 * In implementation, we add target link-layer address by default.
	 * We do not add one in MUST NOT cases.
	 */
	if (!IN6_IS_ADDR_MULTICAST(&dst6)) {
		tgtlla_opt = TinyFalse;
	}
	else {
		tgtlla_opt = TinyTrue;
	}

	/*
	 * Target address (tgt6) must be either:
	 * (1) Valid unicast address for my receiving interface,
	 * (2) "tentative" address on which DAD is being performed.
	 */
	tentative = tiny_netif_is_addr_tentative(netif, &tgt6);
	if ((tiny_netif_is_addr_my_unicast(netif, &tgt6) == TinyFalse)
		&& (tentative == TinyFalse)) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : not for my address (%s)\n",
					 funcname, tiny_ip6_sprintf(&tgt6));
		goto discard;
	}

	mylladdrlen = tiny_netif_get_hardware_addr(netif, &mylladdr);

	/* here, tgt6 is my address */
	myaddr6 = tgt6;

	duplicated = tiny_netif_is_addr_duplicated(netif, &myaddr6);

	if (duplicated == TinyTrue) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : NS for my duplicated address "
					 "(%s)\n", funcname, tiny_ip6_sprintf(&myaddr6));
		goto discard;
	}

	if ((tentative == TinyTrue) && (dad_ns == TinyTrue)) {
		/* someone performs DAD with same address, while i'm performing DAD */
		/* i give up */
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : DAD NS from another node "
					 "for (%s), while performing DAD.\n", funcname,
					 tiny_ip6_sprintf(&myaddr6));
		tiny_nd6_dad_ns_input(&myaddr6);
		goto discard;
	}

	/*
	 * same media should have same link-layer address length (???)
	 */
	if ((lladdr != NULL) && ((mylladdrlen + 2 + 7) & ~7) != lladdrlen) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : lladdrlen mismatch for %s "
					 "(interface %d, NS packet %d)\n", funcname, 
					 tiny_ip6_sprintf(&tgt6), mylladdrlen, lladdrlen - 2);
	}

	if (IN6_ARE_ADDR_EQUAL(&myaddr6, &src6)) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : duplicate IP6 address %s\n",
					 funcname, tiny_ip6_sprintf(&src6));
		goto discard;
	}

	/*
	 * If the source address is unspecified address, entries must not
	 * be created or updated.
	 * It looks that sender is performing DAD.  Output NA toward
	 * all-node multicast address, to tell the sender that I'm using
	 * the address.
	 * S bit ("solicited") must be zero.
	 */
	if (IN6_IS_ADDR_UNSPECIFIED(&src6)) {
		tiny_nd6_na_output(&src6, &tgt6,
						   ((tgtlla_opt == TinyTrue)
							? ND_NA_FLAG_OVERRIDE : 0),
						   tgtlla_opt);
	}
	else {
		tiny_nd6_nbrcache_update(&src6, lladdr, lladdrlen,
								 ND_NEIGHBOR_SOLICIT, 0);
		tiny_nd6_na_output(&src6, &tgt6,
						   (((tgtlla_opt == TinyTrue)
							 ? ND_NA_FLAG_OVERRIDE : 0)
							| ND_NA_FLAG_SOLICITED),
						   tgtlla_opt);
	}

 discard:
	tinybuf_free(tbuf);
	return;
}


/*
 * Output an Neighbor Solicitation Message. Caller specifies:
 *	- ICMP6 header source IP6 address
 *	- ND6 header target IP6 address
 *	- ND6 header source datalink address
 */
void
tiny_nd6_ns_output(struct in6_addr *dst6,
				   struct in6_addr *tgt6,
				   struct nd6_neighbor_cache *nbc,/* for source address determination */
				   TinyBool dad)			/* duplicated address detection */
{
	TINY_FUNC_NAME(tiny_nd6_ns_output);
	tinybuf *tbuf;
	struct ip6_hdr *ip6;
	struct nd_neighbor_solicit *nd_ns;
	int icmp6len;
	int maxlen;
	CADDR_T mac = NULL;
	int lladdrlen;
	TinyNetif outif = tiny_physical_netif;
	
	TINY_LOG_MSG(TINY_LOG_INFO, "%s : dst = %s, tgt = %s\n", funcname,
				 (dst6 != NULL) ? tiny_ip6_sprintf(dst6) : "NULL",
				 (tgt6 != NULL) ? tiny_ip6_sprintf(tgt6) : "NULL");

	if (tgt6 == NULL) {
		TINY_FATAL_ERROR("invalid NULL target\n");
	}

	if (IN6_IS_ADDR_MULTICAST(tgt6)) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : target address (%s) is multicast, "
					 "do not send NS\n", funcname, tiny_ip6_sprintf(tgt6));
		return;
	}

	if (IN6_IS_ADDR_UNSPECIFIED(tgt6)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : target address (%s) is unspecified, "
					 "do not send NS\n", funcname, tiny_ip6_sprintf(tgt6));
		return;
	}

	lladdrlen = tiny_netif_get_hardware_addr(outif, &mac);
	/* estimate the size of message */
	maxlen = sizeof(*ip6) + sizeof(*nd_ns);
	/* force 8byte boundary */
	maxlen += (sizeof(struct nd_opt_hdr) + lladdrlen + 7) & ~7;
	if (maxlen >= TINY_BUFLEN) {
		return;
	}

	tbuf = tinybuf_alloc();
	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
					 funcname);
		return;
	}

	icmp6len = sizeof(*nd_ns);
	tbuf->len = sizeof(*ip6) + icmp6len;

	/* fill neighbor solicitation packet */
	ip6 = (struct ip6_hdr *)tbuf->pkt;
	ip6->ip6_flow = 0;
	ip6->ip6_vfc &= ~IPV6_VERSION_MASK;
	ip6->ip6_vfc |= IPV6_VERSION;
	/* ip6->ip6_plen will be set later */
	ip6->ip6_nxt = IPPROTO_ICMPV6;
	ip6->ip6_hlim = 255;
	if (dst6 != NULL) {
		ip6->ip6_dst = *dst6;
	}
	else {
		ip6->ip6_dst.s6_addr16[0] = IPV6_ADDR_INT16_MLL;
		ip6->ip6_dst.s6_addr16[1] = 0;
		ip6->ip6_dst.s6_addr32[1] = 0;
		ip6->ip6_dst.s6_addr32[2] = IPV6_ADDR_INT32_ONE;
		ip6->ip6_dst.s6_addr32[3] = tgt6->s6_addr32[3];
		ip6->ip6_dst.s6_addr8[12] = 0xff;
	}
	if (dad == TinyFalse) {
		/*
		 * RFC2461 7.2.2:
		 * "If the source address of the packet prompting the
		 * solicitation is the same as one of the addresses assigned
		 * to the outgoing interface, that address SHOULD be placed
		 * in the IP Source Address of the outgoing solicitation.
		 * Otherwise, any one of the addresses assigned to the
		 * interface should be used."
		 *
		 * We use the source address for the prompting packet
		 * (src6), if:
		 * - src6 is given from the caller (by giving "ln"), and
		 * - src6 belongs to the outgoing interface.
		 * Otherwise, we perform a scope-wise match.
		 */
		struct ip6_hdr *hip6;		/* hold ip6 */
		struct in6_addr *src6;

		if ((nbc != NULL) && (nbc->hldpkt != NULL)) {
			hip6 = (struct ip6_hdr *) nbc->hldpkt->pkt;
			if (sizeof(*hip6) < nbc->hldpkt->len) {
				src6 = &hip6->ip6_src;
			}
			else {
				src6 = NULL;
			}
		}
		else {
			src6 = NULL;
		}
		if (src6 != NULL) {
			TINY_BCOPY(src6, &ip6->ip6_src, sizeof(*src6));
		}
		else {
			TinyNetif outif;
			outif = tiny_netif_select_src(&ip6->ip6_dst, &ip6->ip6_src);
			if (outif == NULL) {
				tinybuf_free(tbuf);
				return;
			}
		}
	}
	else {
		/*
		 * Source address for DAD packet must always be
		 * IPv6 unspecified address. (0::0)
		 */
		TINY_BZERO(&ip6->ip6_src, sizeof(ip6->ip6_src));
	}
	nd_ns = (struct nd_neighbor_solicit *)(ip6 + 1);
	nd_ns->nd_ns_type = ND_NEIGHBOR_SOLICIT;
	nd_ns->nd_ns_code = 0;
	nd_ns->nd_ns_reserved = 0;
	nd_ns->nd_ns_target = *tgt6;

	/*
	 * Add source link-layer address option.
	 *
	 *						spec		implementation
	 *						---			---
	 * DAD packet			MUST NOT	do not add the option
	 * there's no link layer address:
	 *				impossible	do not add the option
	 * there's link layer address:
	 *	Multicast NS		MUST add one	add the option
	 *	Unicast NS			SHOULD add one	add the option
	 */
	if ((dad == TinyFalse) && (lladdrlen > 0)) {
		int optlen = sizeof(struct nd_opt_hdr) + lladdrlen;
		struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)(nd_ns + 1);
		/* 8 byte alignments... */
		optlen = (optlen + 7) & ~7;
		
		tbuf->len += optlen;
		icmp6len += optlen;
		TINY_BZERO((CADDR_T)nd_opt, optlen);
		nd_opt->nd_opt_type = ND_OPT_SOURCE_LINKADDR;
		nd_opt->nd_opt_len = optlen >> 3;
		TINY_BCOPY(mac, (CADDR_T)(nd_opt + 1), lladdrlen);
	}

	ip6->ip6_plen = htons((U_SHORT)icmp6len);
	nd_ns->nd_ns_cksum = 0;
	nd_ns->nd_ns_cksum
		= tiny_in6_cksum(tbuf, IPPROTO_ICMPV6, sizeof(*ip6), icmp6len);

	tiny_ip6_output(tbuf, ((dad ? TINY_IPV6_DADOUTPUT : 0) | TINY_IPV6_NSOUTPUT));
}

/*
 * Neighbor advertisement input handling.
 *
 * Based on RFC 2461
 * Based on RFC 2462 (duplicated address detection)
 *
 */
void
tiny_nd6_na_input(tinybuf *tbuf, int off, int icmp6len)
{
	TINY_FUNC_NAME(tiny_nd_na_input);
	struct ip6_hdr *ip6;
	struct nd_neighbor_advert *nd_na;
	TinyBool dad_na = TinyFalse;
	struct in6_addr dst6;
	struct in6_addr tgt6;
	int flags;
	TinyBool is_router;
	TinyBool is_solicited;
	TinyBool is_override;
	char *lladdr = NULL;
	int lladdrlen = 0;
	char *mylladdr;
	int mylladdrlen;
	union nd_opts ndopts;
	TinyNetif netif = tiny_physical_netif;	/* ND works only on physical interface */
	struct nd6_neighbor_cache *nbc;
	struct sockaddr_dl *sdl;
	int saved_stat;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : icmp6len = %d\n", funcname, icmp6len);

	ip6 = (struct ip6_hdr *)tbuf->pkt;

	if (ip6->ip6_hlim != 255) {
		goto discard;
	}

	dst6 = ip6->ip6_dst;

	if (icmp6len < sizeof(struct nd_neighbor_advert)) {
		goto discard;
	}

	nd_na = (struct nd_neighbor_advert *)((CADDR_T)ip6 + off);

	tgt6 = nd_na->nd_na_target;
	flags = nd_na->nd_na_flags_reserved;
	is_router = ((flags & ND_NA_FLAG_ROUTER) != 0) ? TinyTrue : TinyFalse;
	is_solicited = ((flags & ND_NA_FLAG_SOLICITED) != 0)
		? TinyTrue : TinyFalse;
	is_override = ((flags & ND_NA_FLAG_OVERRIDE) != 0)
		? TinyTrue : TinyFalse;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : R=%d, S=%d, O=%d\n",
				 funcname, is_router, is_solicited, is_override);

	if (IN6_IS_ADDR_MULTICAST(&tgt6)) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : target address "
					 "is invalid (multicast)\n", funcname);
		goto discard;
	}

	if (IN6_IS_ADDR_MULTICAST(&dst6)) {
		if (is_solicited == TinyTrue) {
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : dst address "
						 "is multicast with solicited flag (invalid)\n",
						 funcname);
			goto discard;
		}
		dad_na = TinyTrue;
	}

	icmp6len -= sizeof(*nd_na);
	tiny_nd6_option_init(nd_na + 1, icmp6len, &ndopts);
	if (tiny_nd6_options(&ndopts) < 0) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : tiny_nd6_options() error\n",
					 funcname);
		goto discard;
	}

	if (ndopts.nd_opts_tgt_lladdr != NULL) {
		lladdr = (char *)(ndopts.nd_opts_tgt_lladdr + 1);
		lladdrlen = ndopts.nd_opts_tgt_lladdr->nd_opt_len << 3;
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : includes link-layer address, "
					 "link-layer address length = %d\n", funcname, lladdrlen);
	}
	else {
		if (dad_na == TinyTrue) {
#if 1	/* XXX */
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : DAD NA for %s must include "
						 "link-layer address, but not found, ignore it\n",
						 funcname, tiny_ip6_sprintf(&tgt6));
			goto discard;
#else
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : DAD NA for %s must include "
						 "link-layer address, but not found.\n",
						 funcname, tiny_ip6_sprintf(&tgt6));
#endif
		}
	}

	/*
	 * Target address matches one of my interface address.
	 *
	 * If my address is tentative, this means that there's somebody
	 * already using the same address as mine.  This indicates DAD failure.
	 * This is defined in RFC 2462.
	 *
	 * Otherwise, process as defined in RFC 2461.
	 */
	if ((tiny_netif_is_addr_tentative(netif, &tgt6) == TinyTrue)
		&& (dad_na == TinyTrue)) {
		tiny_nd6_dad_na_input(&tgt6);
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : DAD for %s failed\n", funcname, 
					 tiny_ip6_sprintf(&tgt6));
		goto discard;
	}

	/*
	 * same media should have same link-layer address length (???)
	 */
	mylladdrlen = tiny_netif_get_hardware_addr(netif, &mylladdr);
	if ((lladdr != NULL) && ((mylladdrlen + 2 + 7) & ~7) != lladdrlen) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : lladdrlen mismatch for %s "
					 "(netif %d, NA packet %d)\n", funcname,
					 tiny_ip6_sprintf(&tgt6), mylladdrlen, lladdrlen - 2);
	}

	/*
	 * If no neighbor cache entry is found, NA SHOULD silently be discarded.
	 */
	nbc = tiny_nd6_nbrcache_lookup(&tgt6);
	if (nbc == NULL) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : neighbor cache for %s not found\n",
					 funcname, tiny_ip6_sprintf(&tgt6));
		goto discard;
	}

	sdl = &nbc->saddrdl;

	saved_stat = nbc->state;

	if (nbc->state == TINY_NDCACHE_INCOMPLETE) {
		/*
		 * If the link-layer has address, and no lladdr option came,
		 * discard the packet.
		 */
		if ((mylladdrlen != 0) && (lladdr == NULL)) {
			goto discard;
		}

		/*
		 * Record link-layer address, and update the state.
		 */
		sdl->sdl_alen = lladdrlen;
		TINY_BCOPY(lladdr, LLADDR(sdl), lladdrlen);
		if (is_solicited == TinyTrue) {
			nbc->state = TINY_NDCACHE_REACHABLE;
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : current ReachableTime = %d\n",
						 funcname, ReachableTime);
			nbc->expire = tiny_get_systime() + (ReachableTime / 1000);
		}
		else {
			nbc->state = TINY_NDCACHE_STALE;
		}
		nbc->router = is_router;
	}
	else {
		TinyBool llchange;

		/*
		 * Check if the link-layer address has changed or not.
		 */
		if (lladdr == NULL) {
			llchange = TinyFalse;
		}
		else {
			if (sdl->sdl_alen != 0) {
				if (TINY_BCMP(lladdr, LLADDR(sdl), mylladdrlen) != 0) {
					llchange = TinyTrue;
				}
				else {
					llchange = TinyFalse;
				}
			}
			else {
				llchange = TinyTrue;
			}
		}

		if (llchange == TinyTrue) {
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : link-layer address changed \n",
						 funcname);
		}
		/*
		 * This is VERY complex.  Look at it with care.
		 *
		 * override solicit lladdr llchange		action
		 *										(L: record lladdr)
		 *
		 *		0		0		n		--		(2c)
		 *		0		0		y		n		(2b) L
		 *		0		0		y		y		(1)    REACHABLE->STALE
		 *		0		1		n		--		(2c)   *->REACHABLE
		 *		0		1		y		n		(2b) L *->REACHABLE
		 *		0		1		y		y		(1)    REACHABLE->STALE
		 *		1		0		n		--		(2a)
		 *		1		0		y		n		(2a) L
		 *		1		0		y		y		(2a) L *->STALE
		 *		1		1		n		--		(2a)   *->REACHABLE
		 *		1		1		y		n		(2a) L *->REACHABLE
		 *		1		1		y		y		(2a) L *->REACHABLE
		 */
		if ((is_override == TinyFalse)
			&& ((lladdr != NULL) && (llchange == TinyTrue))) {	   /* (1) */
			/*
			 * If state is REACHABLE, make it STALE.
			 * no other updates should be done.
			 */
			if (nbc->state == TINY_NDCACHE_REACHABLE) {
				nbc->state = TINY_NDCACHE_STALE;
			}
			goto discard;
		}
		else if ((is_override == TinyTrue)	   				/* (2a) */
				 || ((is_override == TinyFalse)
					 && ((lladdr != NULL) && (llchange == TinyFalse)))	/* (2b) */
				 || (lladdr == NULL)) {				  		/* (2c) */
			/*
			 * Update link-local address, if any.
			 */
			if (lladdr != NULL) {
				sdl->sdl_alen = mylladdrlen;
				TINY_BCOPY(lladdr, LLADDR(sdl), mylladdrlen);
			}

			/*
			 * If solicited, make the state REACHABLE.
			 * If not solicited and the link-layer address was
			 * changed, make it STALE.
			 */
			if (is_solicited == TinyTrue) {
				nbc->state = TINY_NDCACHE_REACHABLE;
				if (nbc->expire != 0) {
					nbc->expire = tiny_get_systime() + (ReachableTime / 1000);
				}
			}
			else {
				if ((lladdr != NULL) && (llchange == TinyTrue)) {
					nbc->state = TINY_NDCACHE_STALE;
				}
			}
		}

		if ((nbc->router == TinyTrue) && (is_router == TinyFalse)) {
			/*
			 * The peer dropped the router flag.
			 * Remove the sender from the Default Router List and
			 * update the Destination Cache entries.
			 */
			struct nd6_defrouter *dr;
			PRILEV p;	/* XXX */

			p = SPLNET();
			dr = tiny_nd6_defrouter_lookup(nbc);
			if (dr != NULL) {
				tiny_nd6_defrouter_free(dr);
			}
			SPLX(p);
		}
		nbc->router = is_router;
	}
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : neighnor cache status %d -> %d\n",
				 funcname, saved_stat, nbc->state);
	nbc->asked = 0;
	if (nbc->hldpkt != NULL) {
		tinybuf *hld = nbc->hldpkt;
		nbc->hldpkt = NULL;
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : output packet on neighbor cache\n",
					 funcname);
		tiny_ip6_output(hld, 0);
	}

 discard:
	tinybuf_free(tbuf);
}

/*
 * Neighbor advertisement output handling.
 */
void
tiny_nd6_na_output(struct in6_addr *dst6,
				   struct in6_addr *tgt6,
				   U_LONG flags,
				   TinyBool tgtlladdr)/* TRUE if include target link-layer address */
{
	TINY_FUNC_NAME(tiny_nd6_na_output);
	tinybuf *tbuf;
	struct ip6_hdr *ip6;
	struct nd_neighbor_advert *nd_na;
	int icmp6len;
	int maxlen;
	CADDR_T mac = NULL;
	int lladdrlen;
	TinyNetif outif = tiny_physical_netif;	/* ND works only on physical interface */

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);

	lladdrlen = tiny_netif_get_hardware_addr(outif, &mac);

	/* estimate the size of message */
	maxlen = sizeof(struct ip6_hdr) + sizeof(struct nd_neighbor_advert);

	/* force 8byte boundary */
	maxlen += (sizeof(struct nd_opt_hdr) + lladdrlen + 7) & ~7;

	if (maxlen >= TINY_BUFLEN) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : data too large (%d)\n",
					 funcname, maxlen);
		return;
	}

	tbuf = tinybuf_alloc();
	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
					 funcname);
		return;
	}

	icmp6len = sizeof(*nd_na);
	tbuf->len = sizeof(struct ip6_hdr) + icmp6len;

	/* fill neighbor advertisement packet */
	ip6 = (struct ip6_hdr *)tbuf->pkt;
	ip6->ip6_flow = 0;
	ip6->ip6_vfc &= ~IPV6_VERSION_MASK;
	ip6->ip6_vfc |= IPV6_VERSION;
	ip6->ip6_nxt = IPPROTO_ICMPV6;
	ip6->ip6_hlim = 255;
	if (IN6_IS_ADDR_UNSPECIFIED(dst6)) {
		/* reply to DAD */
		ip6->ip6_dst.s6_addr16[0] = IPV6_ADDR_INT16_MLL;
		ip6->ip6_dst.s6_addr16[1] = 0;
		ip6->ip6_dst.s6_addr32[1] = 0;
		ip6->ip6_dst.s6_addr32[2] = 0;
		ip6->ip6_dst.s6_addr32[3] = IPV6_ADDR_INT32_ONE;
		flags &= ~ND_NA_FLAG_SOLICITED;
	}
	else {
		ip6->ip6_dst = *dst6;
	}

	/*
	 * Select a source address
	 */
	{
		TinyNetif outif;
		outif = tiny_netif_select_src(&ip6->ip6_dst, &ip6->ip6_src);
		if (outif == NULL) {
			tinybuf_free(tbuf);
			return;
		}
	}
	nd_na = (struct nd_neighbor_advert *)(ip6 + 1);
	nd_na->nd_na_type = ND_NEIGHBOR_ADVERT;
	nd_na->nd_na_code = 0;
	nd_na->nd_na_target = *tgt6;

	/*
	 * "tgtlladdr" indicates NS's condition for adding tgtlladdr or not.
	 * see tiny_nd6_ns_input() for details.
	 * Basically, if NS packet is sent to unicast/anycast addr,
	 * target lladdr option SHOULD NOT be included.
	 */
	if ((tgtlladdr == TinyTrue) && (mac != NULL)) {
		int optlen = sizeof(struct nd_opt_hdr) + lladdrlen;
		struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)(nd_na + 1);
		
		/* roundup to 8 bytes alignment! */
		optlen = (optlen + 7) & ~7;

		tbuf->len += optlen;
		icmp6len += optlen;
		TINY_BZERO((CADDR_T)nd_opt, optlen);
		nd_opt->nd_opt_type = ND_OPT_TARGET_LINKADDR;
		nd_opt->nd_opt_len = optlen >> 3;
		TINY_BCOPY(mac, (CADDR_T)(nd_opt + 1), lladdrlen);
	}
	else {
		flags &= ~ND_NA_FLAG_OVERRIDE;
	}

	ip6->ip6_plen = htons((U_SHORT)icmp6len);
	nd_na->nd_na_flags_reserved = flags;
	nd_na->nd_na_cksum = 0;
	nd_na->nd_na_cksum
		= tiny_in6_cksum(tbuf, IPPROTO_ICMPV6, sizeof(*ip6), icmp6len);

	tiny_ip6_output(tbuf, 0);
}


struct dadq_entry {
	struct in6_addr addr;
	TINY_TIMER_HANDLE *dad_timer_handle;
	int dad_ns_in;
	int dad_na_in;
};


#define DADQSIZ		4
struct dadq {
	struct dadq_entry entry[DADQSIZ];
	TinyBool valid[DADQSIZ];
};


static struct dadq dadq;


static void
tiny_dadq_init(void)
{
	int i;
	for (i = 0; i < DADQSIZ; i ++) {
		dadq.valid[i] = TinyFalse;
	}
}


static struct dadq_entry *
tiny_dadq_alloc(void)
{
	int i;
	struct dadq_entry *dq = NULL;
	for (i = 0; i < DADQSIZ; i ++) {
		if (dadq.valid[i] == TinyFalse) {
			dadq.valid[i] = TinyTrue;
			dq = &dadq.entry[i];
			TINY_BZERO(&dq->addr, sizeof(dq->addr));
			dq->dad_timer_handle = NULL;
			dq->dad_ns_in = 0;
			dq->dad_na_in = 0;
			break;
		}
	}
	return dq;
}


static void
tiny_dadq_free(struct dadq_entry *dq)
{
	int i;
	for (i = 0; i < DADQSIZ; i ++) {
		if (&dadq.entry[i] == dq) {
			dadq.valid[i] = TinyFalse;
			break;
		}
	}
}


static struct dadq_entry *
tiny_nd6_dadq_find(struct in6_addr *addr)
{
	int i;
	struct dadq_entry *dq = NULL;
	for (i = 0; i < DADQSIZ; i ++) {
		if ((dadq.valid[i] == TinyTrue)
			&& IN6_ARE_ADDR_EQUAL(&dadq.entry[i].addr, addr)) {
			dq = &dadq.entry[i];
			break;
		}
	}
	return dq;
}


static void
tiny_nd6_dad_timer(struct dadq_entry *dq)
{
	TINY_FUNC_NAME(tiny_nd6_dad_timer);
	TinyNetif dadif = tiny_physical_netif;
	struct in6_addr *addr;
	PRILEV p;

	p = SPLSOFTNET();
	if (dq == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : called with null parameter\n",
					 funcname);
		goto end;
	}
	addr = &dq->addr;
	if (tiny_netif_is_addr_duplicated(dadif, addr)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : called with duplicated address "
					 "%s(%s)\n", funcname, tiny_ip6_sprintf(addr), dadif);
		goto end;
	}
	if (tiny_netif_is_addr_tentative(dadif, addr) == TinyFalse) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : called with non-tentative address "
					 "%s(%s)\n", funcname, tiny_ip6_sprintf(addr), dadif);
		goto end;
	}
	if ((dq->dad_ns_in == 0) && (dq->dad_na_in == 0)) {
		tiny_netif_dad_succeed(dadif, addr);
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : DAD succeed for %s(%s)\n",
					 funcname, tiny_ip6_sprintf(addr), dadif);
	}
	else {
		tiny_netif_dad_failed(dadif, addr);
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : DAD failed for %s(%s), "
					 "NS = %d, NA = %d\n", funcname, tiny_ip6_sprintf(addr),
					 dadif, dq->dad_ns_in, dq->dad_na_in);
	}
	tiny_timerhandle_free(dq->dad_timer_handle);
	dq->dad_timer_handle = NULL;
	tiny_dadq_free(dq);
 end:
	SPLX(p);
}


/*
 * Start Duplicated Address Detection (DAD) for specified interface address.
 */
static void
tiny_nd6_dad_start(struct dadq_entry *dq)
{
	TINY_FUNC_NAME(tiny_nd6_dad_start);
	TinyNetif dadif = tiny_physical_netif;

	if ((dq->dad_ns_in != 0) || (dq->dad_na_in != 0)) {
		tiny_netif_dad_failed(dadif, &dq->addr);
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : DAD for %s failed before starting,"
					  " NS = %d, NA = %d\n", funcname,
					  tiny_ip6_sprintf(&dq->addr), dq->dad_ns_in,
					  dq->dad_na_in);
		tiny_timerhandle_free(dq->dad_timer_handle);
		dq->dad_timer_handle = NULL;
		tiny_dadq_free(dq);
		return;
	}
	tiny_nd6_ns_output(NULL, &dq->addr, NULL, 1);
	tiny_netif_start_dad(dadif);
	tiny_set_timer(dq->dad_timer_handle, RetransTimer,
				 (void (*)(void *))tiny_nd6_dad_timer, dq);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : DAD timer started for %s(%s)\n",
				 funcname, tiny_ip6_sprintf(&dq->addr), dadif);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ip6intrq length = %d\n",
				 funcname, tiny_ip6intrq_length());
}


void
tiny_nd6_sched_dad(struct in6_addr *addr, int delay)
{
	TINY_FUNC_NAME(tiny_nd6_sched_dad);
	TinyNetif dadif = tiny_physical_netif;
	struct dadq_entry *dq;
	static TinyBool dadq_init = TinyFalse;
	int ns_pend_msec = TINY_RANDOM() % (MAX_RTR_SOLICITATION_DELAY * 1000);

	if (dadq_init == TinyFalse) {
		tiny_dadq_init();
		dadq_init = TinyTrue;
	}

	if (tiny_netif_is_addr_tentative(dadif, addr) == TinyFalse) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called with non-tentative address "
					 "%s(%s)\n", funcname, tiny_ip6_sprintf(addr), dadif);
		return;
	}
	
	dq = tiny_dadq_alloc();

	if (dq == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : dadq allocation failed for "
					 "%s(%s)\n", funcname, tiny_ip6_sprintf(addr), dadif);
		return;
	}

	dq->addr = *addr;
	dq->dad_timer_handle = tiny_timerhandle_alloc();
	if (tiny_netif_is_available(dadif) == TinyFalse) {
		ns_pend_msec += delay;
	}
	tiny_set_timer(dq->dad_timer_handle, ns_pend_msec,
				   (void (*)(void *))tiny_nd6_dad_start, dq);
}


void
tiny_nd6_dad_na_input(struct in6_addr *addr)
{
	TINY_FUNC_NAME(tiny_nd6_na_input);
	struct dadq_entry *dq;
	TinyNetif dadif = tiny_physical_netif;

	dq = tiny_nd6_dadq_find(addr);
	if (dq == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : can't find dadq for %s(%s)\n",
					 funcname, tiny_ip6_sprintf(addr), dadif);
		return;
	}
	dq->dad_na_in ++;
}


void
tiny_nd6_dad_ns_input(struct in6_addr *addr)
{
	TINY_FUNC_NAME(tiny_nd6_dad_ns_input);
	struct dadq_entry *dq;
	TinyNetif dadif = tiny_physical_netif;

	dq = tiny_nd6_dadq_find(addr);
	if (dq == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : can't find dadq for %s(%s)\n",
					funcname, tiny_ip6_sprintf(addr), dadif);
		return;
	}
	dq->dad_ns_in ++;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
