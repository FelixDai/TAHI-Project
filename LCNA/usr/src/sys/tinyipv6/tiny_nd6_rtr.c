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

/*	$Id: tiny_nd6_rtr.c,v 1.1 2002/05/29 13:31:13 fujita Exp $	*/
/*	$NetBSD: nd6_rtr.c,v 1.17.2.1 2001/05/09 19:43:17 he Exp $	*/
/*	$KAME: nd6_rtr.c,v 1.40 2000/06/13 03:02:29 jinmei Exp $	*/

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


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/sysdep_netif.h>
#include <tinyipv6/tiny_in.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_ip6_var.h>
#include <tinyipv6/tiny_icmp6.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/tiny_ip6_output.h>
#include <tinyipv6/tiny_in6_cksum.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/sysdep_spl.h>


static int tiny_nd6_rs_timer_done = 0;


/*
 * Receive Router Advertisement Message.
 *
 * Based on RFC 2461
 */
void
tiny_nd6_ra_input(tinybuf *tbuf, int off, int icmp6len)
{
	TINY_FUNC_NAME(tiny_nd6_ra_input);
	struct ip6_hdr *ip6;
	struct in6_addr saddr6;
	struct nd_router_advert *nd_ra;
	union nd_opts ndopts;
	struct nd6_defrouter *dr;
	TIME_T curr_time = tiny_get_systime();
	TinyNetif netif = tiny_physical_netif;
	struct nd6_neighbor_cache *nbc;
	TinyBool new_nbrcache = TinyFalse;

	TINY_LOG_MSG(TINY_LOG_INFO, "%s : icmp6len = %d (curr_num_rtr = %d)\n",
				 funcname, icmp6len, tiny_nd6_num_defrouter());

	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : tbuf == NULL\n", funcname);
		return;
	}

	ip6 = (struct ip6_hdr *)tbuf->pkt;

	saddr6 = ip6->ip6_src;
	if (!IN6_IS_ADDR_LINKLOCAL(&saddr6)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : src address is not link-local (%s)\n",
					 funcname, tiny_ip6_sprintf(&saddr6));
		goto discard;
	}

	if (ip6->ip6_hlim != 255) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : hop limit(%d) != 255\n", funcname,
					 ip6->ip6_hlim);
		goto discard;
	}

	if (icmp6len < sizeof(struct nd_router_advert)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : icmp6len too short(%d)\n", funcname,
					 icmp6len);
		goto discard;
	}

	{
		if (tiny_nd6_rs_timer_done == 0) {
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : receive unsolicite RA, "
						 "but now running RS timer, ignore it\n", funcname);
			goto discard;
		}
	}			

	nd_ra = (struct nd_router_advert *)((CADDR_T)ip6 + off);

	icmp6len -= sizeof(*nd_ra);
	tiny_nd6_option_init(nd_ra + 1, icmp6len, &ndopts);
	if (tiny_nd6_options(&ndopts) < 0) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : tiny_nd6_options() failed\n",
					 funcname);
		goto discard;
	}

	/* ok, it seems valid RA */

    {
		U_INT32_T advreachable = ntohl(nd_ra->nd_ra_reachable);
		U_SHORT rtlifetime = ntohs(nd_ra->nd_ra_router_lifetime);

		nbc = tiny_nd6_nbrcache_lookup(&saddr6);
		if (nbc == NULL) {
			nbc = tiny_nd6_nbrcache_alloc(&saddr6);
			nbc->state = TINY_NDCACHE_STALE;
			nbc->expire = 1;
			new_nbrcache = 1;
			nbc->asked = 0;
			nbc->last_send = 0;
		}
		else if (nbc->state == TINY_NDCACHE_NOSTATE) {
			nbc->state = TINY_NDCACHE_STALE;
			nbc->expire = 1;
			nbc->asked = 0;
			nbc->last_send = 0;
		}
		dr = tiny_nd6_defrouter_lookup(nbc);
		if ((dr == NULL) && (rtlifetime != 0)) {
			dr = tiny_nd6_defrouter_alloc(nbc);
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : New default router (%s)\n",
						 funcname, tiny_ip6_sprintf(&nbc->saddr6.sin6_addr));
		}
		if (dr != NULL) {
			dr->flags  = nd_ra->nd_ra_flags_reserved;
			dr->rtlifetime = rtlifetime;
			dr->expire = curr_time + dr->rtlifetime;
			if (dr->rtlifetime == 0) {
				tiny_nd6_defrouter_free(dr);
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : Obsolete default router "
							 "(%s)\n", funcname,
							 tiny_ip6_sprintf(&nbc->saddr6.sin6_addr));
				dr = NULL;
			}
		}
		/* unspecified or not? (RFC 2461 6.3.4) */
		if (advreachable != 0) {
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : RA specifies "
						 "BaseReachableTime %u\n", funcname, advreachable);
			if (advreachable <= MAX_REACHABLE_TIME &&
				BaseReachableTime != advreachable) {
				U_INT32_T save = ReachableTime;
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : update BaseReachableTime "
							 "%u -> %u\n", funcname,
							 BaseReachableTime, advreachable);
				BaseReachableTime = advreachable;
				ReachableTime = tiny_nd6_compute_rtime(BaseReachableTime);
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : updated ReachableTime "
							 "%u -> %u\n", funcname, save, ReachableTime);
				RecalcReachTime
					= curr_time	+ ND_RECALC_REACHTM_INTERVAL;	/* reset */
			}
		}
		if (nd_ra->nd_ra_curhoplimit != 0) {
			CurHopLimit = nd_ra->nd_ra_curhoplimit;
		}
		if (nd_ra->nd_ra_retransmit != 0) {
			int save = RetransTimer;
			RetransTimer = ntohl(nd_ra->nd_ra_retransmit);
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : RetransTimer %d -> %d\n",
						 funcname, save, RetransTimer);
		}
    }

	/*
	 * prefix
	 */
	if (ndopts.nd_opts_pi != NULL) {
		struct nd_opt_hdr *pt;
		struct nd_opt_prefix_info *pi;
		struct nd6_prefix *pr;

		for (pt = (struct nd_opt_hdr *)ndopts.nd_opts_pi;
			 pt <= (struct nd_opt_hdr *)ndopts.nd_opts_pi_end;
			 pt = (struct nd_opt_hdr *)((caddr_t)pt +
										(pt->nd_opt_len << 3))) {
			int new_prefix = 0;
			if (pt->nd_opt_type != ND_OPT_PREFIX_INFORMATION) {
				continue;
			}
			pi = (struct nd_opt_prefix_info *)pt;

			if (pi->nd_opt_pi_len != 4) {
				continue;
			}

			if (pi->nd_opt_pi_prefix_len > 128) {
				continue;
			}

			if (IN6_IS_ADDR_MULTICAST(&pi->nd_opt_pi_prefix)
				|| IN6_IS_ADDR_LINKLOCAL(&pi->nd_opt_pi_prefix)) {
				continue;
			}

			/* aggregatable unicast address, rfc2374 */
			if ((pi->nd_opt_pi_prefix.s6_addr8[0] & 0xe0) == 0x20
				&& pi->nd_opt_pi_prefix_len != 64) {
				continue;
			}

			if (ntohl(pi->nd_opt_pi_preferred_time)
				> ntohl(pi->nd_opt_pi_valid_time)) {
				continue;
			}

			pr = tiny_nd6_prefixlist_lookup(&pi->nd_opt_pi_prefix);
			if (pr == NULL) {
				pr = tiny_nd6_prefix_alloc(&pi->nd_opt_pi_prefix);
				new_prefix = TinyTrue;
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : New prefix information "
							 "found\n", funcname);
			}
			pr->ndpr_flag_onlink = (pi->nd_opt_pi_flags_reserved &
									ND_OPT_PI_FLAG_ONLINK) ? 1 : 0;
			pr->ndpr_flag_auto = (pi->nd_opt_pi_flags_reserved &
								  ND_OPT_PI_FLAG_AUTO) ? 1 : 0;
			pr->prefixlen = pi->nd_opt_pi_prefix_len;
			pr->vltime = ntohl(pi->nd_opt_pi_valid_time);
			pr->pltime = ntohl(pi->nd_opt_pi_preferred_time);

			if (! pr->ndpr_flag_auto) {
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : prefix(%s) option "
							 "A flag = 0, ignore it\n", funcname,
							 tiny_ip6_sprintf(&pr->prefix));
				tiny_nd6_prefix_free(pr);
				continue;
			}
			if (! pr->ndpr_flag_onlink) {
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : prefix(%s) option "
							 "L flag = 0, ignore it\n", funcname,
							 tiny_ip6_sprintf(&pr->prefix));
				tiny_nd6_prefix_free(pr);
				continue;
			}
			if (pr->pltime == ND_INFINITE_LIFETIME) {
				pr->preferred = 0;
			}
			else {
				pr->preferred = curr_time + pr->pltime;
			}
			if (pr->vltime == ND_INFINITE_LIFETIME) {
				pr->expire = 0;
			}
			else if (pr->vltime == 0) {
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : prefix(%s) vltime = 0, "
							 "detach it\n", funcname,
							 tiny_ip6_sprintf(&pr->prefix));
				new_prefix = TinyFalse;
				tiny_netif_detach_addr_with_prefix(netif, &pr->prefix,
												   pr->prefixlen);
				tiny_nd6_prefix_free(pr);
			}
			else {
				if (new_prefix) {
					pr->expire = curr_time + pr->vltime;
				}
				else {
					TIME_T new_expire = curr_time + pr->vltime;
					if (new_expire > pr->expire) {
						pr->expire = new_expire;
					}
				}
			}
			if (new_prefix == TinyTrue) {
				struct in6_addr *newaddr;
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : prefix(%s) vltime = %ld, "
							 "attach it\n", funcname,
							 tiny_ip6_sprintf(&pr->prefix), pr->vltime);
				newaddr = tiny_netif_attach_addr_with_prefix(netif,
															 &pr->prefix,
															 pr->prefixlen);
				if (newaddr == NULL) {
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : address attach failed "
								 "for %s\n", funcname, netif);
				}
				else {
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : address (%s) attached "
								 "for %s\n", funcname,
								 tiny_ip6_sprintf(newaddr), netif);
				}
			}
		}
	}

	/* ignore MTU option */
	
	/*
	 * Src linkaddress
	 */
    {
		char *lladdr = NULL;
		int lladdrlen = 0;
		char *mylladdr;
		int mylladdrlen;

		mylladdrlen = tiny_netif_get_hardware_addr(netif, &mylladdr);
	
		if (ndopts.nd_opts_src_lladdr != NULL) {
			lladdr = (char *)(ndopts.nd_opts_src_lladdr + 1);
			lladdrlen = ndopts.nd_opts_src_lladdr->nd_opt_len << 3;
		}

		if (lladdr && ((mylladdrlen + 2 + 7) & ~7) != lladdrlen) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : link-layer address length "
						 "mismatch (my lladdrlen = %d, src lladdrlen = %d)\n",
						 funcname, mylladdrlen, lladdrlen);
			goto discard;
		}

		if ((lladdr == NULL) && (new_nbrcache != 0)) {
			nbc->state = TINY_NDCACHE_NOSTATE;
		}

		tiny_nd6_nbrcache_update(&saddr6, lladdr, mylladdrlen,
								 ND_ROUTER_ADVERT, 0);
    }

 discard:
	tinybuf_free(tbuf);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : end (number of defrouter = %d)\n",
				 funcname, tiny_nd6_num_defrouter());
}


void
tiny_nd6_rs_output(void *dummy)
{
	TINY_FUNC_NAME(tiny_nd6_rs_output);
	TinyNetif netif = tiny_physical_netif;
	tinybuf *tbuf;
	struct ip6_hdr *ip6;
	struct nd_router_solicit *nd_rs;
	struct nd_opt_hdr *nd_opt;
	int nd_opt_len;
	int icmp6len;
	int mylladdrlen;
	char *mylladdr;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);

	tbuf = tinybuf_alloc();
	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
					 funcname);
		return;
	}

	ip6 = (struct ip6_hdr *) tbuf->pkt;
	nd_rs = (struct nd_router_solicit *)(ip6 + 1);
	icmp6len = sizeof(*nd_rs);
	ip6->ip6_flow = 0;
	ip6->ip6_vfc &= ~IPV6_VERSION_MASK;
	ip6->ip6_vfc |= IPV6_VERSION;
	ip6->ip6_dst = in6addr_linklocal_allrouters;
	{
		TinyNetif outif;
		outif = tiny_netif_select_src(&ip6->ip6_dst, &ip6->ip6_src);
		if (outif == NULL) {
			TINY_BZERO(&ip6->ip6_src, sizeof(ip6->ip6_src));
		}
	}
	if (IN6_IS_ADDR_UNSPECIFIED(&ip6->ip6_src)) {
		nd_opt_len = 0;
	}
	else {
		nd_opt = (struct nd_opt_hdr *)(nd_rs + 1);
		mylladdrlen = tiny_netif_get_hardware_addr(netif, &mylladdr);
		nd_opt_len = sizeof(*nd_opt) + mylladdrlen;
		/* force 8octets boundary */
		nd_opt_len = ((nd_opt_len + 7) & ~7);
	}
	icmp6len += nd_opt_len;
	tbuf->len = sizeof(struct ip6_hdr) + icmp6len;
	ip6->ip6_plen = htons(icmp6len);
	ip6->ip6_nxt = IPPROTO_ICMPV6;
	ip6->ip6_hlim = 255;
	TINY_BZERO(nd_rs, icmp6len);
	nd_rs->nd_rs_type = ND_ROUTER_SOLICIT;
	nd_rs->nd_rs_code = 0;
	nd_rs->nd_rs_reserved = 0;
	if (nd_opt_len != 0) {
		nd_opt->nd_opt_type = ND_OPT_SOURCE_LINKADDR;
		nd_opt->nd_opt_len = nd_opt_len >> 3;
		TINY_BCOPY(mylladdr, nd_opt + 1, mylladdrlen);
	}
	nd_rs->nd_rs_cksum = 0;
	nd_rs->nd_rs_cksum
		= tiny_in6_cksum(tbuf, IPPROTO_ICMPV6, sizeof(*ip6), icmp6len);

	tiny_ip6_output(tbuf, TINY_IPV6_RSOUTPUT);

	TINY_LOG_MSG(TINY_LOG_INFO, "%s : end\n", funcname);	

}


static TINY_TIMER_HANDLE nd6_send_rs_hdl;
static int tiny_nd6_start_send_rs_timer = 0;


void
tiny_nd6_sched_send_rs(int delay)
{
	if (tiny_nd6_start_send_rs_timer != 0) {
		return;
	}
	else {
		tiny_nd6_start_send_rs_timer ++;
		nd6_send_rs_hdl = tiny_timerhandle_alloc();
		tiny_nd6_send_rs_timer((void *)delay);
	}
}


void
tiny_nd6_send_rs_timer(void *arg)
{
	TINY_FUNC_NAME(tiny_nd6_send_rs_timer);
	static int tries = 0;
	int delay = (int)arg;
	int num_defrouter;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : delay = %d, tries = %d\n",
				 funcname, delay, tries);
	if (tries == 0) {
		tries ++;
		delay += TINY_RANDOM() % ((MAX_RTR_SOLICITATION_DELAY * 1000) + 1);
		tiny_set_timer(nd6_send_rs_hdl, delay,
					   tiny_nd6_send_rs_timer, (void *)0);
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : scheduled myself at "
					 "%d millisecond later, tries = %d\n", funcname,
					 delay, tries);
		return;
	}

	num_defrouter = tiny_nd6_num_defrouter();
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : num_defrotuer = %d\n",
				 funcname, num_defrouter);
	if ((num_defrouter == 0) && (tries <= MAX_RTR_SOLICITATIONS)) {
		tiny_nd6_rs_output(NULL);
		tiny_nd6_rs_timer_done = 1;
		delay = (RTR_SOLICITATION_INTERVAL * 1000);
		tiny_set_timer(nd6_send_rs_hdl, delay,
					   tiny_nd6_send_rs_timer, (void *)0);
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : scheduled myself at "
					 "%d millisecond later, tries = %d\n", funcname,
					 delay, tries);
		tries ++;
	}
	else {
		tiny_timerhandle_free(nd6_send_rs_hdl);
	}
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
