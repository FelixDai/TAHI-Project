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

/*	$Id: tiny_nd6.c,v 1.2 2002/05/30 09:46:50 fujita Exp $	*/


#include <sys/param.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_ether.h>
#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_icmp6.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_spl.h>
#include <tinyipv6/tiny_ip6_output.h>


struct nd6_nbrcache_list {
	int head;
	struct nd6_neighbor_cache entry[TINY_ND_NBRLST_SIZ];
	TinyBool valid[TINY_ND_NBRLST_SIZ];
};


struct nd6_defrouter_list {
	int head;
	int nument;
	struct nd6_defrouter entry[TINY_ND_DRLST_SIZ];
	TinyBool valid[TINY_ND_DRLST_SIZ];
};


struct nd6_prefix_list {
	int head;
	struct nd6_prefix entry[TINY_ND_PRLST_SIZ];
	TinyBool valid[TINY_ND_PRLST_SIZ];
};


static struct nd6_nbrcache_list nd6_nbrcache_list;
static struct nd6_defrouter_list nd6_defrouter_list;
static struct nd6_prefix_list nd6_prefix_list;



/* timer values */
int nd6_prune = 1;		/* walk list every 1 seconds */
int nd6_delay = 5;		/* delay first probe time 5 second */
int nd6_umaxtries = 3;	/* maximum unicast query */
int nd6_mmaxtries = 3;	/* maximum multicast query */


void
tiny_nd6_option_init(void *opt, int icmp6len, union nd_opts *ndopts)
{
	TINY_BZERO(ndopts, sizeof(*ndopts));
	ndopts->nd_opts_done = TinyFalse;
	ndopts->nd_opts_search = (struct nd_opt_hdr *)opt;
	ndopts->nd_opts_last
		= (struct nd_opt_hdr *)(((U_CHAR *)opt) + icmp6len);

	if (icmp6len == 0) {
		ndopts->nd_opts_done = TinyTrue;
		ndopts->nd_opts_search = NULL;
	}
}


struct nd_opt_hdr *
tiny_nd6_option(union nd_opts *ndopts)
{
	struct nd_opt_hdr *nd_opt;
	int olen;

	if (ndopts == NULL) {
		TINY_FATAL_ERROR("ndopts == NULL in tiny_nd6_option\n");
	}
	if (ndopts->nd_opts_last == NULL) {
		TINY_FATAL_ERROR("uninitialized ndopts in tiny_nd6_option\n");
	}
	if (ndopts->nd_opts_search == NULL) {
		return NULL;
	}
	if (ndopts->nd_opts_done == TinyTrue) {
		return NULL;
	}

	nd_opt = ndopts->nd_opts_search;

	/* make sure nd_opt_len is inside the buffer */
	if ((CADDR_T)&nd_opt->nd_opt_len >= (CADDR_T)ndopts->nd_opts_last) {
		TINY_BZERO(ndopts, sizeof(*ndopts));
		return NULL;
	}

	olen = nd_opt->nd_opt_len << 3;
	if (olen == 0) {
		/*
		 * Message validation requires that all included
		 * options have a length that is greater than zero.
		 */
		TINY_BZERO(ndopts, sizeof(*ndopts));
		return NULL;
	}

	ndopts->nd_opts_search = (struct nd_opt_hdr *)((CADDR_T)nd_opt + olen);
	if (ndopts->nd_opts_search > ndopts->nd_opts_last) {
		/* option overruns the end of buffer, invalid */
		TINY_BZERO(ndopts, sizeof(*ndopts));
		return NULL;
	}
	else if (ndopts->nd_opts_search == ndopts->nd_opts_last) {
		/* reached the end of options chain */
		ndopts->nd_opts_done = TinyTrue;
		ndopts->nd_opts_search = NULL;
	}
	return nd_opt;
}


static int nd6_maxndopt = 10;


int
tiny_nd6_options(union nd_opts *ndopts)
{
	TINY_FUNC_NAME(tiny_nd6_options);
	struct nd_opt_hdr *nd_opt;
	int i = 0;

	if (ndopts == NULL) {
		TINY_FATAL_ERROR("ndopts == NULL in tiny_nd6_options\n");
	}
	if (ndopts->nd_opts_last == NULL) {
		TINY_FATAL_ERROR("uninitialized ndopts in tiny_nd6_options\n");
	}
	if (ndopts->nd_opts_search == NULL) {
		return 0;
	}

	while (1) {
		nd_opt = tiny_nd6_option(ndopts);
		if ((nd_opt == NULL) && (ndopts->nd_opts_last == NULL)) {
			/*
			 * Message validation requires that all included
			 * options have a length that is greater than zero.
			 */
			TINY_BZERO(ndopts, sizeof(*ndopts));
			return -1;
		}

		if (nd_opt == NULL) {
			goto skip1;
		}

		switch (nd_opt->nd_opt_type) {
		case ND_OPT_SOURCE_LINKADDR:
		case ND_OPT_TARGET_LINKADDR:
		case ND_OPT_MTU:
		case ND_OPT_REDIRECTED_HEADER:
			if (ndopts->nd_opt_array[nd_opt->nd_opt_type] != NULL) {
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : duplicated ND6 option found "
							 "(type=%d)\n", funcname, nd_opt->nd_opt_type);
				/* XXX bark? */
			}
			else {
				ndopts->nd_opt_array[nd_opt->nd_opt_type] = nd_opt;
			}
			break;
		case ND_OPT_PREFIX_INFORMATION:
			if (ndopts->nd_opt_array[nd_opt->nd_opt_type] == 0) {
				ndopts->nd_opt_array[nd_opt->nd_opt_type] = nd_opt;
			}
			ndopts->nd_opts_pi_end = (struct nd_opt_prefix_info *)nd_opt;
			break;
		default:
			/*
			 * Unknown options must be silently ignored,
			 * to accomodate future extension to the protocol.
			 */
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : unsupported option %d - "
						 "option ignored\n", funcname, nd_opt->nd_opt_type);
			break;
		}
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ND option %d found\n",
					 funcname, nd_opt->nd_opt_type);

	skip1:
		i ++;
		if (i > nd6_maxndopt) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s: too many loop in nd opt\n",
						 funcname);
			break;
		}

		if (ndopts->nd_opts_done == TinyTrue) {
			break;
		}
	}

	return 0;
}


void
tiny_nd6_nbrcache_list_init(void)
{
	int i;
	nd6_nbrcache_list.head = 0;
	for (i = 0; i < TINY_ND_NBRLST_SIZ; i ++) {
		nd6_nbrcache_list.valid[i] = TinyFalse;
	}
}


void
tiny_nd6_defrouter_list_init(void)
{
	int i;
	nd6_defrouter_list.head = 0;
	nd6_defrouter_list.nument = 0;
	for (i = 0; i <TINY_ND_DRLST_SIZ; i ++) {
		nd6_defrouter_list.valid[i] = TinyFalse;
	}
}


void
tiny_nd6_prefix_list_init(void)
{
	int i;
	nd6_prefix_list.head = 0;
	for (i = 0; i < TINY_ND_PRLST_SIZ; i ++) {
		nd6_prefix_list.valid[i] = TinyFalse;
	}
}


U_INT32_T LinkMTU;
U_INT8_T CurHopLimit;
U_INT32_T BaseReachableTime;	/* msec */
U_INT32_T ReachableTime;		/* msec */
U_INT32_T RetransTimer;			/* msec */

U_INT32_T RecalcReachTime;


static void
tiny_nd6_hostvars_init(void)
{
	LinkMTU = TINY_MTU;
	CurHopLimit = IPV6_DEFHLIM;
	BaseReachableTime = REACHABLE_TIME;
	ReachableTime = tiny_nd6_compute_rtime(BaseReachableTime);
	RetransTimer = RETRANS_TIMER;

	RecalcReachTime = tiny_get_systime() + ND_RECALC_REACHTM_INTERVAL;
}


static TINY_TIMER_HANDLE nd6_timer_handle;


void
tiny_nd6_timer(void *dummy)
{
	TIME_T curr_time = tiny_get_systime();
	/* set next timer */
	tiny_set_timer(nd6_timer_handle, nd6_prune * 1000, tiny_nd6_timer, dummy);

	if (RecalcReachTime <= curr_time) {
		ReachableTime = tiny_nd6_compute_rtime(BaseReachableTime);
		RecalcReachTime
			= curr_time	+ ND_RECALC_REACHTM_INTERVAL;	/* reset */
	}

	tiny_nd6_defrouterlist_timer();	/* must be former than nd cache timer */
	tiny_nd6_neighborcache_timer();
	tiny_nd6_prefixlist_timer();
}


void
tiny_nd6_init(void)
{
	tiny_nd6_nbrcache_list_init();
	tiny_nd6_defrouter_list_init();
	tiny_nd6_prefix_list_init();
	tiny_nd6_hostvars_init();

	{
		struct in6_addr linklocal;
		struct nd6_prefix *pr;
		TINY_BZERO(&linklocal, sizeof(linklocal));
		linklocal.s6_addr16[0] = htons(0xfe80);
		pr = tiny_nd6_prefix_alloc(&linklocal);
		pr->ndpr_flag_onlink = 1;
		pr->prefixlen = 64;
		pr->vltime = ND_INFINITE_LIFETIME;
		pr->expire = 0;
	}

	nd6_timer_handle = tiny_timerhandle_alloc();
	tiny_set_timer(nd6_timer_handle, 1000, tiny_nd6_timer, NULL);	/* XXX */
}


U_INT32_T
tiny_nd6_compute_rtime(U_INT32_T base)
{
	TINY_FUNC_NAME(tiny_nd6_compute_rtime);
	U_INT32_T rtime;
	U_INT32_T min_val;
	U_INT32_T max_val;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	min_val = (base >> 10) * MIN_RANDOM_FACTOR;	/* see also tiny_nd6.h */
	max_val = (base >> 10) * MAX_RANDOM_FACTOR;
	rtime = min_val + (U_INT32_T)(TINY_RANDOM() % ((max_val - min_val) + 1));
#if 0	/* XXX */
	if (rtime < min_val) {
		rtime = min_val;
	}
	else if (rtime > max_val) {
		rtime = max_val;
	}
#endif
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : return with %u\n", funcname, rtime);
	return rtime;
}


struct nd6_neighbor_cache *
tiny_nd6_nbrcache_lookup(struct in6_addr *addr)
{
	int index;
	struct nd6_neighbor_cache *nbc = NULL;
	PRILEV p;
	p = SPLNET();
	for (index = 0; index < TINY_ND_NBRLST_SIZ; index ++) {
		int i = (index + nd6_nbrcache_list.head) % TINY_ND_NBRLST_SIZ;
		if (nd6_nbrcache_list.valid[i] == TinyFalse) {
			continue;
		}
		if (IN6_ARE_ADDR_EQUAL(&nd6_nbrcache_list.entry[i].saddr6.sin6_addr,
							   addr)) {
			nbc = &nd6_nbrcache_list.entry[i];
			break;
		}
	}
	SPLX(p);
	return nbc;
}


struct nd6_neighbor_cache *
tiny_nd6_nbrcache_alloc(struct in6_addr *addr)
{
	TINY_FUNC_NAME(tiny_nd6_nbrcache_alloc);
	int index;
	struct nd6_neighbor_cache *nbc = NULL;
	PRILEV p;
	p = SPLNET();
	for (index = 0; index < TINY_ND_NBRLST_SIZ; index ++) {
		int i = (index + nd6_nbrcache_list.head) % TINY_ND_NBRLST_SIZ;
		if (nd6_nbrcache_list.valid[i] == TinyFalse) {
			nbc = &nd6_nbrcache_list.entry[i];
			TINY_BZERO(nbc, sizeof(*nbc));
			nbc->saddr6.sin6_len = sizeof(struct sockaddr_in6);
			nbc->saddr6.sin6_family = AF_INET6;
			nbc->saddr6.sin6_addr = *addr;
			nbc->saddrdl.sdl_family = AF_LINK;
			nbc->saddrdl.sdl_alen = 0;
			nbc->hldpkt = NULL;
			nbc->router = TinyFalse;
			nbc->state = TINY_NDCACHE_NOSTATE;
			nbc->expire = 1;
			nbc->asked = 0;
			nbc->last_send = 0;
			nd6_nbrcache_list.valid[i] = TinyTrue;
			break;
		}
	}
	if (nbc == NULL) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : neighbor cahche table is full, "
					 "overwrapped\n", funcname);
		nbc = &nd6_nbrcache_list.entry[nd6_nbrcache_list.head];
		if (nbc->hldpkt != NULL) {
			tinybuf_free(nbc->hldpkt);
		}
		nbc->hldpkt = NULL;
		nbc->saddr6.sin6_addr = *addr;
		nbc->state = TINY_NDCACHE_NOSTATE;
		nbc->last_send = 0;
		nd6_nbrcache_list.head ++;
		nd6_nbrcache_list.head %= TINY_ND_NBRLST_SIZ;
	}
	TINY_LOG_MSG(TINY_LOG_INFO, "%s : create neighbor cache for %s\n",
				 funcname, tiny_ip6_sprintf(addr));
	SPLX(p);
	return nbc;
}


void
tiny_nd6_nbrcache_free(struct nd6_neighbor_cache *nbc)
{
	TINY_FUNC_NAME(tiny_nd6_nbrcache_free);
	int i;
	PRILEV p;
	p = SPLNET();
	for (i = 0; i < TINY_ND_NBRLST_SIZ; i ++) {
		if (&nd6_nbrcache_list.entry[i] == nbc) {
			if (nbc->hldpkt != NULL) {
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : discard packet "
							 "on neigbor cache\n", funcname);
				tinybuf_free(nbc->hldpkt);
			}
			nbc->hldpkt = NULL;
			nd6_nbrcache_list.valid[i] = TinyFalse;
			break;
		}
	}
	SPLX(p);
}


void
tiny_nd6_nbrcache_update(struct in6_addr *from,	char *lladdr, int lladdrlen,
						 int type,	/* ICMP6 type */
						 int code)	/* type dependent information */
{
	TINY_FUNC_NAME(tiny_nd6_nbrcache_update);
	struct nd6_neighbor_cache *nbc = NULL;
	TinyBool is_newentry;
	struct sockaddr_dl *sdl = NULL;
	TinyBool do_update;
	TinyBool olladdr;
	TinyBool llchange;
	int newstate = 0;
	PRILEV p;

	if (from == NULL) {
		TINY_FATAL_ERROR("from == NULL in tiny_nd6_nbrcache_update()");
	}

	/* nothing must be updated for unspecified address */
	if (IN6_IS_ADDR_UNSPECIFIED(from)) {
		return;
	}

	p = SPLNET();

	nbc = tiny_nd6_nbrcache_lookup(from);
	if (nbc == NULL) {
		nbc = tiny_nd6_nbrcache_alloc(from);
		is_newentry = TinyTrue;
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : cahce for (%s) is newly created\n",
					 funcname, tiny_ip6_sprintf(from));
	}
	else {
		is_newentry = TinyFalse;
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : original cache state for (%s) "
					 "= %d\n", funcname, tiny_ip6_sprintf(from), nbc->state);
	}

	sdl = &nbc->saddrdl;

	olladdr = (sdl->sdl_alen != 0) ? TinyTrue : TinyFalse;
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : original link-layer address %s\n",
				 funcname, olladdr ? "found" : "not found");
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : link-layer address length = %d\n",
				 funcname, lladdrlen);
	if ((olladdr == TinyTrue) && (lladdr != NULL)) {
		if (TINY_BCMP(lladdr, LLADDR(sdl), lladdrlen) != 0) {
			llchange = TinyTrue;
		}
		else {
			llchange = TinyFalse;
		}
	}
	else {
		llchange = TinyFalse;
	}
	if (llchange == TinyTrue) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : link-layer address has changed\n",
					 funcname);
	}

	/*
	 * newentry	olladdr	lladdr  llchange	(*=record)
	 *	0		n		n		--			(1)
	 *	0		y		n		--			(2)
	 *	0		n		y		--			(3) * STALE
	 *	0		y		y		n			(4) *
	 *	0		y		y		y			(5) * STALE
	 *	1		--		n		--			(6)   NOSTATE(= PASSIVE)
	 *	1		--		y		--			(7) * STALE
	 */

	if (lladdr != NULL) {					/* (3-5) and (7) */
		/*
		 * Record source link-layer address
		 */
		sdl->sdl_alen = lladdrlen;
		TINY_BCOPY(lladdr, LLADDR(sdl), lladdrlen);
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : link-layer address found, "
					 "link-layer address lengtn = %d\n", funcname, lladdrlen);
	}
	else {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : link-layer address not found\n",
					 funcname);
	}

	if (is_newentry == TinyFalse) {
		if (((olladdr == TinyFalse) && (lladdr != NULL))/* (3) */
			|| ((olladdr == TinyTrue) && (lladdr != NULL)
				&& (llchange == TinyTrue))) {	/* (5) */
			do_update = TinyTrue;
			newstate = TINY_NDCACHE_STALE;
		}
		else {										/* (1-2,4) */
			do_update = TinyFalse;
		}
	}
	else {
		do_update = TinyTrue;
		if (lladdr == NULL) {						/* (6) */
			newstate = TINY_NDCACHE_NOSTATE;
		}
		else {										/* (7) */
			newstate = TINY_NDCACHE_STALE;
		}
	}

	if (do_update == TinyTrue) {
		/*
		 * Update the state of the neighbor cache.
		 */
		nbc->state = newstate;

		if (nbc->state == TINY_NDCACHE_STALE) {
			if (nbc->hldpkt != NULL) {
				tinybuf *hld = nbc->hldpkt;
				nbc->hldpkt = NULL;
				tiny_ip6_output(hld, 0);
			}
		}
		else if (nbc->state == TINY_NDCACHE_INCOMPLETE) {
			/* probe right away */
			nbc->expire = tiny_get_systime();
		}
	}

	/*
	 * ICMP6 type dependent behavior about the 'IsRouter'
	 *
	 * NS: clear IsRouter if new entry
	 * RS: clear IsRouter
	 * RA: set IsRouter if there's lladdr
	 *
	 * RA case, (1):
	 * The spec says that we must set IsRouter in the following cases:
	 * - If lladdr exist, set IsRouter.  This means (1-5).
	 * - If it is old entry (!newentry), set IsRouter.  This means (7).
	 * So, based on the spec, in (1-5) and (7) cases we must set IsRouter.
	 * A quetion arises for (1) case.  (1) case has no lladdr in the
	 * neighbor cache, this is similar to (6).
	 * This case is rare but we figured that we MUST NOT set IsRouter.
	 *
	 * newentry olladdr  lladdr  llchange	    NS  RS  RA
	 *		0		n		n		--		(1)	p	c   ?
	 *		0		y		n		--		(2)	p	c   s
	 *		0		n		y		--		(3)	p	c   s
	 *		0		y		y		n		(4)	p	c   s
	 *		0		y		y		y		(5)	p	c   s
	 *		1		--		n		--		(6) c	c	p
	 *		1		--		y		--		(7) c	c   s
	 *
	 *										(c=clear s=set p=preserve)
	 */
	switch (type & 0xff) {
	case ND_NEIGHBOR_SOLICIT:
		/*
		 * New entry must have IsRouter flag cleared.
		 */
		if (is_newentry == TinyTrue) {	/*(6-7)*/
			nbc->router = TinyFalse;
		}
		break;
	case ND_ROUTER_SOLICIT:
		/*
		 * IsRouter flag must always be cleared.
		 */
		nbc->router = TinyFalse;
		break;
	case ND_ROUTER_ADVERT:
		/*
		 * Mark an entry with lladdr as a router.
		 */
		if (((is_newentry == TinyFalse)
			 && ((olladdr == TinyTrue) || (lladdr != NULL)))	/* (2-5) */
			|| ((is_newentry == TinyTrue)
				&& (lladdr != NULL))) {			/* (7) */
			nbc->router = TinyTrue;
		}
		break;
	}
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : new cache state for (%s) %d\n",
				 funcname, tiny_ip6_sprintf(from), nbc->state);
	SPLX(p);
}


void
tiny_nd6_neighborcache_timer(void)
{
	TINY_FUNC_NAME(tiny_nd6_neighborcache_timer);
	int index;
	TIME_T curr_time = tiny_get_systime();

#if 0
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : RetransTimer = %d, ReachableTime = %d\n",
				 funcname, RetransTimer, ReachableTime);
#endif

	for (index = 0; index < TINY_ND_NBRLST_SIZ; index ++) {
		int i = (index + nd6_nbrcache_list.head) % TINY_ND_NBRLST_SIZ;
		if (nd6_nbrcache_list.valid[i] == TinyTrue) {
			struct nd6_neighbor_cache *nbc = &nd6_nbrcache_list.entry[i];
			if (nbc->expire == 0) {	/* infinite */
				continue;
			}
			switch (nbc->state) {
			case TINY_NDCACHE_NOSTATE:
				{
					TinyBool in_use = TinyFalse;
					{
						/* first, make clean defrouterlist */
						struct nd6_defrouter *dr;
						dr = tiny_nd6_defrouter_lookup(nbc);
						if (dr != NULL) {
							in_use = TinyTrue;
						}
					}
					if (in_use == TinyFalse) {
						tiny_nd6_nbrcache_free(nbc);
						TINY_LOG_MSG(TINY_LOG_INFO, "%s : discard "
									 "neighbor cache(%s)\n", funcname,
							tiny_ip6_sprintf(&nbc->saddr6.sin6_addr));
					}
				}
				break;
			case TINY_NDCACHE_INCOMPLETE:
				if (nbc->asked >= nd6_mmaxtries) {
					tiny_nd6_nbrcache_free(nbc);
				}
				else if ((nbc->last_send + RetransTimer / 1000) <= curr_time) {
					tiny_nd6_ns_output(NULL, &nbc->saddr6.sin6_addr, nbc, 0);
					nbc->last_send = curr_time;
					nbc->asked ++;
				}
				break;
			case TINY_NDCACHE_REACHABLE:
				if (nbc->expire <= curr_time) {
					nbc->state = TINY_NDCACHE_STALE;
					nbc->asked = 0;
					TINY_LOG_MSG(TINY_LOG_INFO, "%s : neighnor cache(%s) "
								 "status %d -> %d\n", funcname,
								 tiny_ip6_sprintf(&nbc->saddr6.sin6_addr),
								 TINY_NDCACHE_REACHABLE, TINY_NDCACHE_STALE);
				}
				break;
			case TINY_NDCACHE_DELAY:
				if (nbc->expire <= curr_time) {
					nbc->state = TINY_NDCACHE_PROBE;
					nbc->asked = 0;
					TINY_LOG_MSG(TINY_LOG_INFO, "%s : neighnor cache(%s) "
								 "status %d -> %d\n", funcname,
								 tiny_ip6_sprintf(&nbc->saddr6.sin6_addr),
								 TINY_NDCACHE_DELAY, TINY_NDCACHE_PROBE);
					tiny_nd6_ns_output(&nbc->saddr6.sin6_addr, 
									   &nbc->saddr6.sin6_addr, nbc, 0);
					nbc->last_send = curr_time;
					nbc->asked ++;
				}
				break;
			case TINY_NDCACHE_PROBE:
				if (nbc->asked >= nd6_umaxtries) {
					TinyBool in_use = TinyFalse;
					{
						/* first, make clean defrouterlist */
						struct nd6_defrouter *dr;
						dr = tiny_nd6_defrouter_lookup(nbc);
						if (dr != NULL) {
							in_use = TinyTrue;
							dr->nbr->state = TINY_NDCACHE_NOSTATE;
						}
					}
					if (in_use == TinyFalse) {
						tiny_nd6_nbrcache_free(nbc);
						TINY_LOG_MSG(TINY_LOG_INFO, "%s : discard "
									 "neighbor cache(%s)\n", funcname,
									 tiny_ip6_sprintf(&nbc->saddr6.sin6_addr));
					}
					else {
						TINY_LOG_MSG(TINY_LOG_INFO, "%s : neighbor cache(%s) "
									 "status %d -> %d, instead of diacard\n",
									 funcname,
									 tiny_ip6_sprintf(&nbc->saddr6.sin6_addr),
									 TINY_NDCACHE_PROBE, TINY_NDCACHE_NOSTATE);
					}
					continue;
				}
				if ((nbc->last_send + RetransTimer / 1000) <= curr_time) {
					tiny_nd6_ns_output(&nbc->saddr6.sin6_addr, 
									   &nbc->saddr6.sin6_addr, nbc, 0);
					nbc->last_send = curr_time;
					nbc->asked ++;
				}
				break;
			default:
				break;	/* XXX ??? */
			}
		}
	}
	return;
}


struct nd6_defrouter *
tiny_nd6_choose_defrouter(void)
{
	TINY_FUNC_NAME(tiny_nd6_choose_defrouter);
	int index;
	static int prev = -1;
	struct nd6_defrouter *dr = NULL;
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called, current routers = %d\n",
				 funcname, nd6_defrouter_list.nument);
	for (index = 0; index < TINY_ND_DRLST_SIZ; index ++) {
		int i = (index + nd6_defrouter_list.head) % TINY_ND_DRLST_SIZ;
		struct nd6_neighbor_cache *nbr;
		if (nd6_defrouter_list.valid[i] == TinyFalse) {
			continue;
		}
		nbr = nd6_defrouter_list.entry[i].nbr;
		if (nbr == NULL) {
			continue;
		}
		if ((nbr->state > TINY_NDCACHE_INCOMPLETE)
			&& (nbr->router == TinyTrue)) {
			dr = &nd6_defrouter_list.entry[i];
			break;
		}
	}
	if (dr == NULL) {
		for (index = 0; index < TINY_ND_DRLST_SIZ; index ++) {
			int i = (index + nd6_defrouter_list.head) % TINY_ND_DRLST_SIZ;
			struct nd6_neighbor_cache *nbr;
			if (nd6_defrouter_list.valid[i] == TinyFalse) {
				continue;
			}
			nbr = nd6_defrouter_list.entry[i].nbr;
			if (nbr == NULL) {
				continue;
			}
			if ((nbr->state != TINY_NDCACHE_INCOMPLETE)
				|| (nbr->router == TinyFalse)) {
				continue;
			}
			if ((nd6_defrouter_list.nument > 1) && (prev >= i)) {
				continue;
			}
			else {
				dr = &nd6_defrouter_list.entry[i];
				prev = i;
				break;
			}
		}
	}
	if ((dr == NULL) && (nd6_defrouter_list.nument != 0)) {
		for (index = 0; index < TINY_ND_DRLST_SIZ; index ++) {
			int i = (index + nd6_defrouter_list.head) % TINY_ND_DRLST_SIZ;
			if (nd6_defrouter_list.valid[i] == TinyTrue) {
				if ((nd6_defrouter_list.nument > 1) && (prev >= i)) {
					continue;
				}
				dr = &nd6_defrouter_list.entry[i];
				prev = i;
				break;
			}
		}
	}
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : returns with %s\n", funcname,
				 ((dr == NULL) ? "NULL" : "non-NULL"));
	return dr;
}


int
tiny_nd6_num_defrouter(void)
{
	return nd6_defrouter_list.nument;
}


struct nd6_defrouter *
tiny_nd6_defrouter_lookup(struct nd6_neighbor_cache *nbc)
{
	int index;
	struct nd6_defrouter *dr = NULL;
	for (index = 0; index < TINY_ND_DRLST_SIZ; index ++) {
		int i = (index + nd6_defrouter_list.head) % TINY_ND_DRLST_SIZ;
		if (nd6_defrouter_list.valid[i] == TinyFalse) {
			continue;
		}
		if (nd6_defrouter_list.entry[i].nbr == nbc) {
			dr = &nd6_defrouter_list.entry[i];
			break;
		}
	}
	return dr;
}


struct nd6_defrouter *
tiny_nd6_defrouter_alloc(struct nd6_neighbor_cache *nbc)
{
	TINY_FUNC_NAME(tiny_nd6_defrouter_alloc);
	int index;
	struct nd6_defrouter *dr;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);

	for (index = 0; index < TINY_ND_DRLST_SIZ; index ++) {
		int i = (index + nd6_defrouter_list.head) % TINY_ND_DRLST_SIZ;
		if (nd6_defrouter_list.valid[i] == TinyFalse) {
			dr = &nd6_defrouter_list.entry[i];
			TINY_BZERO(dr, sizeof(*dr));
			dr->nbr = nbc;
			nd6_defrouter_list.valid[i] = TinyTrue;
			nd6_defrouter_list.nument ++;
			break;
		}
	}
	if (dr == NULL) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : default router list full, "
					 "overwrapped\n", funcname);
		dr = &nd6_defrouter_list.entry[nd6_defrouter_list.head];
		TINY_BZERO(dr, sizeof(*dr));
		dr->nbr = nbc;
		nd6_defrouter_list.head ++;
		nd6_defrouter_list.head %= TINY_ND_DRLST_SIZ;
	}

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : end\n", funcname);

	return dr;
}


void
tiny_nd6_defrouter_free(struct nd6_defrouter *dr)
{
	int i;
	for (i = 0; i < TINY_ND_DRLST_SIZ; i ++) {
		if (&nd6_defrouter_list.entry[i] == dr) {
			nd6_defrouter_list.valid[i] = TinyFalse;
			nd6_defrouter_list.nument --;
			break;
		}
	}
}


void
tiny_nd6_defrouterlist_timer(void)
{
	int index;
	struct nd6_defrouter *dr;
	for (index = 0; index < TINY_ND_DRLST_SIZ; index ++) {
		int i = (index + nd6_defrouter_list.head) % TINY_ND_DRLST_SIZ;
		if (nd6_defrouter_list.valid[i] == TinyTrue) {
			dr = &nd6_defrouter_list.entry[i];
			if (dr->expire <= tiny_get_systime()) {
				tiny_nd6_defrouter_free(dr);
			}
		}
	}
}


struct nd6_prefix *
tiny_nd6_prefixlist_lookup(struct in6_addr *addr)
{
	int index;
	struct nd6_prefix *pr = NULL;
	for (index = 0; index < TINY_ND_PRLST_SIZ; index ++) {
		int i = (index + nd6_prefix_list.head) % TINY_ND_PRLST_SIZ;
		if (nd6_prefix_list.valid[i] == TinyFalse) {
			continue;
		}
		if (IN6_ARE_ADDR_EQUAL(&nd6_prefix_list.entry[i].prefix, addr)) {
			pr = &nd6_prefix_list.entry[i];
			break;
		}
	}
	return pr;
}


struct nd6_prefix *
tiny_nd6_prefix_alloc(struct in6_addr *addr)
{
	int index;
	struct nd6_prefix *pr;
	for (index = 0; index < TINY_ND_PRLST_SIZ; index ++) {
		int i = (index + nd6_prefix_list.head) % TINY_ND_PRLST_SIZ;
		if (nd6_prefix_list.valid[i] == TinyFalse) {
			pr = &nd6_prefix_list.entry[i];
			TINY_BZERO(pr, sizeof(*pr));
			pr->prefix = *addr;
			nd6_prefix_list.valid[i] = TinyTrue;
			break;
		}
	}
	if (pr == NULL) {
		pr = &nd6_prefix_list.entry[nd6_prefix_list.head ++];
		TINY_BZERO(pr, sizeof(*pr));
		pr->prefix = *addr;
		nd6_prefix_list.head %= TINY_ND_PRLST_SIZ;
	}
	return pr;
}


void
tiny_nd6_prefix_free(struct nd6_prefix *pr)
{
	int i;
	for (i = 0; i < TINY_ND_PRLST_SIZ; i ++) {
		if (&nd6_prefix_list.entry[i] == pr) {
			nd6_prefix_list.valid[i] = TinyFalse;
			break;
		}
	}
}


void
tiny_nd6_prefixlist_timer(void)
{
	int index;
	struct nd6_prefix *pr;
	TinyNetif netif = tiny_physical_netif;
	for (index = 0; index < TINY_ND_PRLST_SIZ; index ++) {
		int i = (index + nd6_prefix_list.head) % TINY_ND_PRLST_SIZ;
		if (nd6_prefix_list.valid[i] == TinyTrue) {
			pr = &nd6_prefix_list.entry[i];
			if (pr->expire == 0) {	/* infinite */
				continue;
			}
			if (pr->expire <= tiny_get_systime()) {
				tiny_netif_detach_addr_with_prefix(netif, &pr->prefix,
												   pr->prefixlen);
			}
		}
	}
}


int
tiny_nd6_print_ndcache_list(char *buf, int size)
{
	int i;
	int len = 0;
	int linelen;
	char *pos = buf;
	for (i = 0; i < TINY_ND_NBRLST_SIZ; i ++) {
		char *statstr[] = {
			"no_state   ",
			"wait_delete",
			"incomplete ",
			"reachable  ",
			"stale      ",
			"delay      ",
			"probe      ",
		};
		int j = (i + nd6_nbrcache_list.head) % TINY_ND_NBRLST_SIZ;
		struct nd6_neighbor_cache *nbc;
		if (!nd6_nbrcache_list.valid[j]) {
			continue;
		}
		nbc = &nd6_nbrcache_list.entry[j];
		linelen = snprintf(pos, size - len, "%s\t%s\t%s%s\t%s\n",
						   tiny_ip6_sprintf(&nbc->saddr6.sin6_addr),
						   ether_sprintf(nbc->saddrdl.sdl_data
										 + nbc->saddrdl.sdl_nlen),
						   statstr[nbc->state + 2],
						   (nbc->expire == 0) ? "(parmanent)" : "",
						   (nbc->hldpkt != NULL) ? "(pkthld)" : "");
		pos += linelen;
		len += linelen;
		if (pos >= buf + size) {
			break;
		}
	}
	return len;
}


int
tiny_nd6_print_defrouter_list(char *buf, int size)
{
	int i;
	int len = 0;
	int linelen;
	char *pos = buf;
	for (i = 0; i < TINY_ND_DRLST_SIZ; i ++) {
		int j = (i + nd6_defrouter_list.head) % TINY_ND_DRLST_SIZ;
		struct nd6_defrouter *dr;
		if (!nd6_defrouter_list.valid[j]) {
			continue;
		}
		dr = &nd6_defrouter_list.entry[j];
		linelen = snprintf(pos, size - len, "%s\n",
						   tiny_ip6_sprintf(&dr->nbr->saddr6.sin6_addr));
		pos += linelen;
		len += linelen;
		if (pos >= buf + size) {
			break;
		}
	}
	return len;
}


int
tiny_nd6_print_prefix_list(char *buf, int size)
{
	int i;
	int len = 0;
	int linelen;
	char *pos = buf;
	for (i = 0; i < TINY_ND_PRLST_SIZ; i ++) {
		int j = (i + nd6_prefix_list.head) % TINY_ND_PRLST_SIZ;
		struct nd6_prefix *pr;
		if (!nd6_prefix_list.valid[j]) {
			continue;
		}
		pr = &nd6_prefix_list.entry[j];
		linelen = snprintf(pos, size - len, "%s/%d\n",
						   tiny_ip6_sprintf(&pr->prefix),
						   pr->prefixlen);
		pos += linelen;
		len += linelen;
		if (pos > buf + size) {
			break;
		}
	}
	return len;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
