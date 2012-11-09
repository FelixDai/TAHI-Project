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

/*	$Id: tiny_nd6.h,v 1.1 2002/05/29 13:31:11 fujita Exp $ */


#ifndef _TINYIPV6_TINY_ND6_H_
#define _TINYIPV6_TINY_ND6_H_


#include <net/if_dl.h>


typedef enum {
	TINY_NDCACHE_NOSTATE = -2,
	TINY_NDCACHE_WAITDELETE = -1,
	TINY_NDCACHE_INCOMPLETE = 0,
	TINY_NDCACHE_REACHABLE = 1,
	TINY_NDCACHE_STALE = 2,
	TINY_NDCACHE_DELAY = 3,
	TINY_NDCACHE_PROBE = 4,
} TINY_NDCACHE_STATE;


struct nd6_neighbor_cache {
	struct sockaddr_in6 saddr6;
	struct sockaddr_dl saddrdl;
	tinybuf *hldpkt;
	TinyBool router;
	TINY_NDCACHE_STATE state;
	TIME_T expire;
	TIME_T asked;
	TIME_T last_send;
};

struct nd6_defrouter {
	struct nd6_neighbor_cache *nbr;
	U_CHAR flags;
	U_SHORT rtlifetime;
	TIME_T expire;
};


struct nd6_prefix {
	struct in6_addr prefix;
	struct {
		U_CHAR onlink : 1;
		U_CHAR autonomous : 1;
		U_CHAR reserved : 6;
	} flags;
#define ndpr_flag_onlink	flags.onlink
#define ndpr_flag_auto		flags.autonomous
	U_CHAR prefixlen;
	U_CHAR origin;
	TIME_T vltime;
	TIME_T pltime;
	TIME_T expire;
	TIME_T preferred;
};


#define ND_RECALC_REACHTM_INTERVAL	(60 * 120) /* 2hours */


/* protocol constants */
#define MAX_RTR_SOLICITATION_DELAY	1	/* 1sec */
#define RTR_SOLICITATION_INTERVAL	4	/* 4sec */
#define MAX_RTR_SOLICITATIONS		3

#define ND_INFINITE_LIFETIME		0xffffffff

/* node constants */
#define MAX_REACHABLE_TIME		3600000	/* msec */
#define REACHABLE_TIME			30000	/* msec */
#define RETRANS_TIMER			1000	/* msec */
/*
 *	XXX (i386 only???, i don't know)
 *	in kernel, it is better to avoid using fload
 */
#define MIN_RANDOM_FACTOR		512		/* 0.5 * 1024 */
#define MAX_RANDOM_FACTOR		1536	/* 1.5 * 1024 */


/* nd6.c */
extern int nd6_prune;
extern int nd6_delay;
extern int nd6_umaxtries;
extern int nd6_mmaxtries;


union nd_opts {
	struct nd_opt_hdr *nd_opt_array[9];
	struct {
		struct nd_opt_hdr *zero;
		struct nd_opt_hdr *src_lladdr;
		struct nd_opt_hdr *tgt_lladdr;
		struct nd_opt_prefix_info *pi_beg;/* multiple opts, start */
		struct nd_opt_rd_hdr *rh;
		struct nd_opt_mtu *mtu;
		struct nd_opt_hdr *search;	/* multiple opts */
		struct nd_opt_hdr *last;	/* multiple opts */
		TinyBool done;
		struct nd_opt_prefix_info *pi_end;/* multiple opts, end */
	} nd_opt_each;
#define nd_opts_src_lladdr	nd_opt_each.src_lladdr
#define nd_opts_tgt_lladdr	nd_opt_each.tgt_lladdr
#define nd_opts_pi			nd_opt_each.pi_beg
#define nd_opts_pi_end		nd_opt_each.pi_end
#define nd_opts_rh			nd_opt_each.rh
#define nd_opts_mtu			nd_opt_each.mtu
#define nd_opts_search		nd_opt_each.search
#define nd_opts_last		nd_opt_each.last
#define nd_opts_done		nd_opt_each.done
};


extern void tiny_nd6_ns_input(tinybuf *tbuf, int off, int icmp6len);
extern void tiny_nd6_ns_output(struct in6_addr *dst6, struct in6_addr *tgt6,
							   struct nd6_neighbor_cache *nc, TinyBool dad);
extern void tiny_nd6_na_input(tinybuf *tbuf, int off, int icmp6len);
extern void tiny_nd6_na_output(struct in6_addr *dst6, struct in6_addr *tgt6,
							   U_LONG flags, TinyBool tgtlladdr);
extern void tiny_nd6_ra_input(tinybuf *tbuf, int off, int icmp6len);
extern void tiny_nd6_rs_output(void *dummy);

extern void tiny_nd6_option_init(void *opt, int icmp6len,
								 union nd_opts *ndopts);
extern struct nd_opt_hdr *tiny_nd6_option(union nd_opts *ndopts);
extern int tiny_nd6_options(union nd_opts *ndopts);

extern void tiny_nd6_nbrcache_list_init(void);
extern void tiny_nd6_defrouter_list_init(void);
extern void tiny_nd6_prefix_list_init(void);
extern void tiny_nd6_init(void);
extern U_INT32_T tiny_nd6_compute_rtime(U_INT32_T base);
extern void tiny_nd6_timer(void *dummy);
extern void tiny_nd6_neighborcache_timer(void);
extern void tiny_nd6_defrouterlist_timer(void);
extern void tiny_nd6_prefixlist_timer(void);

extern struct nd6_neighbor_cache *tiny_nd6_nbrcache_lookup(struct in6_addr *addr);
extern struct nd6_neighbor_cache *tiny_nd6_nbrcache_alloc(struct in6_addr *addr);
extern void tiny_nd6_nbrcache_free(struct nd6_neighbor_cache *nbc);
extern void tiny_nd6_nbrcache_update(struct in6_addr *from,	char *lladdr,
									 int lladdrlen, int type, int code);

extern struct nd6_defrouter *tiny_nd6_choose_defrouter(void);
extern int tiny_nd6_num_defrouter(void);
extern struct nd6_defrouter *tiny_nd6_defrouter_lookup(struct nd6_neighbor_cache *nbc);
extern struct nd6_defrouter *tiny_nd6_defrouter_alloc(struct nd6_neighbor_cache *nbc);
extern void tiny_nd6_defrouter_free(struct nd6_defrouter *dr);

extern struct nd6_prefix *tiny_nd6_prefixlist_lookup(struct in6_addr *addr);
extern struct nd6_prefix *tiny_nd6_prefix_alloc(struct in6_addr *addr);
extern void tiny_nd6_prefix_free(struct nd6_prefix *pr);


extern void tiny_nd6_dad_na_input(struct in6_addr *addr);
extern void tiny_nd6_dad_ns_input(struct in6_addr *addr);
extern void tiny_nd6_sched_dad(struct in6_addr *addr, int delay);


extern void tiny_nd6_sched_send_rs(int delay);
extern void tiny_nd6_send_rs_timer(void *arg);


extern U_INT32_T RecalcReachTime;



extern int tiny_nd6_print_ndcache_list(char *buf, int size);
extern int tiny_nd6_print_defrouter_list(char *buf, int size);
extern int tiny_nd6_print_prefix_list(char *buf, int size);


#endif /* _TINYIPV6_TINY_ND6_H_ */


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
