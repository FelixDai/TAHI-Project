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

/*	$Id: tiny_netif.c,v 1.1 2002/05/29 13:31:14 fujita Exp $ */


#include <sys/param.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_addr.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/sysdep_netif.h>
#include <tinyipv6/sysdep_spl.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_nd6.h>


typedef enum {
	ADDR_FREE = 0,
	ADDR_USED,
} TINY_ADDR_STAT;


typedef enum {
	TINY_NETIF_TYPE_PHYSICAL = 1,
	TINY_NETIF_TYPE_LOOPBACK = 2,
} TINY_NETIF_TYPE;



typedef struct {
	struct in6_addr in6_addr;
	int prefixlen;
} tiny_netif_addr;


#define TINY_ADDR_FLAG_NONE			0x00
#define TINY_ADDR_FLAG_TENTATIVE	0x02
#define TINY_ADDR_FLAG_DUPLICATED	0x04
#define TINY_ADDR_FLAG_DAD_SCHED	0x08
#define	TINY_ADDR_FLAG_DAD_RUNNING	0x10


#define TINY_NETIF_NUMADDRS	\
	(TINY_ND_PRLST_SIZ + 1)				/* (+1) for link-local */

#define TINY_NETIF_NUMMCASTADDRS	2		/* all node and solicited node */


typedef struct {
	TinyNetif ifname;
	TINY_NETIF_TYPE iftype;
	int num_addrs;
	tiny_netif_addr ifaddr[TINY_NETIF_NUMADDRS];
	TINY_ADDR_STAT addr_stat[TINY_NETIF_NUMADDRS];
	int num_mcastaddrs;
	tiny_netif_addr mcastaddr[TINY_NETIF_NUMMCASTADDRS];
	TINY_ADDR_STAT maddr_stat[TINY_NETIF_NUMMCASTADDRS];
	int flags;
} tiny_netif_manage;


typedef struct {
	TinyNetif ifname;
	TINY_NETIF_TYPE iftype;
} tiny_netif_entry;


static tiny_netif_entry tiny_netif_defs[] = {
	{ TINY_PHYSIF,		TINY_NETIF_TYPE_PHYSICAL, },
	{ TINY_LOOPIF,		TINY_NETIF_TYPE_LOOPBACK, },
};
#define TINY_NUM_NETIFS			TINY_NUMBEROF(tiny_netif_defs)


TinyNetif tiny_physical_netif = NULL;
TinyNetif tiny_loopback_netif = NULL;


static tiny_netif_manage tiny_netif_list[TINY_NUM_NETIFS];


static int tiny_get_hw_ifid(TinyNetif netif, struct in6_addr *in6);
static struct in6_addr *tiny_netif_attach_mcastaddr(TinyNetif netif,
													struct in6_addr *addr6,
													int pfxlen);


static tiny_netif_manage *
tiny_get_netif_by_name(TinyNetif netif)
{
	tiny_netif_manage *tif = NULL;
	int i;
	for (i = 0; i < TINY_NUM_NETIFS; i ++) {
		if (tiny_netif_equal(tiny_netif_list[i].ifname, netif) == TinyTrue) {
			tif = &tiny_netif_list[i];
			break;
		}
	}
	return tif;
}


static struct in6_addr *
tiny_netif_attach_addr(TinyNetif netif, struct in6_addr *addr6,
					   int pfxlen, int flags)
{
	TINY_FUNC_NAME(tiny_netif_addr_attach);
	int i;
	tiny_netif_manage *tif = tiny_get_netif_by_name(netif);
	struct in6_addr *in6 = NULL;
	PRILEV p = SPLNET();
	if (tif == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no such interface (%s)\n",
					 funcname, netif);
		goto end;
	}
	switch (tif->iftype) {
	case TINY_NETIF_TYPE_LOOPBACK:
		if (!IN6_IS_ADDR_LINKLOCAL(addr6)) {
			if (pfxlen != TINY_LOOPBACK_PREFIX_LEN) {
				TINY_LOG_MSG(TINY_LOG_ERR, "%s : unsupported prefix length "
							 "for address %s/%d\n", funcname,
							 tiny_ip6_sprintf(addr6), pfxlen);
			goto end;
			}
		}
		else {
			if (pfxlen != TINY_DEFAULT_PREFIX_LEN) {
				TINY_LOG_MSG(TINY_LOG_ERR, "%s : unsupported prefix length "
							 "for address %s/%d\n", funcname,
							 tiny_ip6_sprintf(addr6), pfxlen);
				goto end;
			}
		}
		break;
	case TINY_NETIF_TYPE_PHYSICAL:
		if (pfxlen != TINY_DEFAULT_PREFIX_LEN) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : unsupported prefix length "
						 "for address %s/%d\n", funcname,
						 tiny_ip6_sprintf(addr6), pfxlen);
			goto end;
		}
		break;
	default:
		TINY_FATAL_ERROR("%s : unknown interface type\n", funcname);
		goto end;
		break;
	}
	for (i = 0; i < TINY_NETIF_NUMADDRS; i ++) {
		if ((tif->addr_stat[i] == ADDR_USED)
			&& (tif->ifaddr[i].prefixlen == pfxlen)
			&& IN6_ARE_ADDR_EQUAL(&tif->ifaddr[i].in6_addr, addr6)) {
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : already attached %s for %s\n",
						 funcname, tiny_ip6_sprintf(addr6), netif);
			in6 = &tif->ifaddr[i].in6_addr;
			goto end;
		}
	}
	if (tif->num_addrs == TINY_NETIF_NUMADDRS) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : can't attach more address for %s\n",
					 funcname, netif);
		goto end;
	}
	for (i = 0; i < TINY_NETIF_NUMADDRS; i ++) {
		if (tif->addr_stat[i] != ADDR_FREE) {
			continue;
		}
		else {
			tif->ifaddr[i].in6_addr = *addr6;
			tif->ifaddr[i].prefixlen = pfxlen;
			tif->flags |= flags;
			tif->addr_stat[i] = ADDR_USED;
			tif->num_addrs ++;
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : attached address %s for %s\n",
						 funcname, tiny_ip6_sprintf(addr6), netif);
			in6 = &tif->ifaddr[i].in6_addr;
			goto end;
		}
	}
 end:
	SPLX(p);
	return in6;
}


void
tiny_netif_addr_setup(TinyNetif netif)
{
	TINY_FUNC_NAME(tiny_netif_addr_setup);
	struct in6_addr addr;
	static TinyBool loopif_done = TinyFalse;
	static TinyBool physif_done = TinyFalse;
	tiny_netif_list_init();

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called for %s\n", funcname, netif);

	if (loopif_done == TinyTrue) {
		;/* already done */
	}
	else if (TINY_STRNCMP(netif, tiny_loopback_netif,
						  TINY_STRLEN(tiny_loopback_netif)) == 0) {
		/* setup loopback interface */
		addr = in6addr_loopback;
		tiny_netif_attach_addr(tiny_loopback_netif, &addr, 128, 0);

		addr.s6_addr16[0] = htons(0xfe80);
		addr.s6_addr16[1] = 0;
		addr.s6_addr32[1] = 0;
		addr.s6_addr32[2] = 0;
		addr.s6_addr32[3] = htonl(1);
		tiny_netif_attach_addr(tiny_loopback_netif, &addr, 64, 0);
		loopif_done = TinyTrue;
	}

	if (physif_done == TinyTrue) {
		;/* already done */
	}
	else if (TINY_STRNCMP(netif, tiny_physical_netif, TINY_STRLEN(tiny_physical_netif)) == 0) {
		/* setup physical interface */
		addr.s6_addr16[0] = htons(0xfe80);
		addr.s6_addr16[1] = 0;
		addr.s6_addr32[1] = 0;
		tiny_get_hw_ifid(tiny_physical_netif, &addr);
		tiny_netif_attach_addr(tiny_physical_netif, &addr,
							   64, TINY_ADDR_FLAG_TENTATIVE);
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : use %s as my unicast address\n",
					 funcname, tiny_ip6_sprintf(&addr));

		/*
		 * multicast address setup
		 *	don't care with loopback interface
		 */
		/* join link-local all-nodes multicast address */
		addr.s6_addr16[0] = htons(0xff02);
		addr.s6_addr16[1] = 0;
		addr.s6_addr32[1] = 0;
		addr.s6_addr32[2] = 0;
		addr.s6_addr32[3] = htonl(1);
		tiny_netif_attach_mcastaddr(tiny_physical_netif, &addr, 32);
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : use %s as my multicast address\n",
					 funcname, tiny_ip6_sprintf(&addr));

		/* join solicited-node multicast address */
		tiny_get_hw_ifid(tiny_physical_netif, &addr);
		addr.s6_addr16[0] = htons(0xff02);
		addr.s6_addr16[1] = 0;
		addr.s6_addr32[1] = 0;
		addr.s6_addr32[2] = htonl(1);
		addr.s6_addr8[12] = 0xff;
		tiny_netif_attach_mcastaddr(tiny_physical_netif, &addr, 32);
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : use %s as my multicast address\n",
					 funcname, tiny_ip6_sprintf(&addr));
		physif_done = TinyTrue;
	}
}


void
tiny_netif_list_init(void)
{
	TINY_FUNC_NAME(tiny_netif_list_init);
	static TinyBool init_done = TinyFalse;
	int i;
	int j;

	if (init_done == TinyTrue) {
		return;
	}
	else {
		init_done = TinyTrue;
	}

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);

	TINY_BZERO(tiny_netif_list, sizeof(tiny_netif_list));
	for (i = 0; i < TINY_NUM_NETIFS; i ++) {
		tiny_netif_list[i].ifname = tiny_netif_defs[i].ifname;
		tiny_netif_list[i].iftype = tiny_netif_defs[i].iftype;
		tiny_netif_list[i].flags = 0;
		tiny_netif_list[i].num_addrs = 0;
		for (j = 0; j < TINY_NETIF_NUMADDRS; j ++) {
			tiny_netif_list[i].addr_stat[j] = ADDR_FREE;
		}
		tiny_netif_list[i].num_mcastaddrs = 0;
		for (j = 0; j < TINY_NETIF_NUMMCASTADDRS; j ++) {
			tiny_netif_list[i].maddr_stat[j] = ADDR_FREE;
		}
		if ((tiny_netif_list[i].iftype == TINY_NETIF_TYPE_PHYSICAL)
			&& (tiny_physical_netif == NULL)) {
			tiny_physical_netif = tiny_netif_list[i].ifname;
		}
		if ((tiny_netif_list[i].iftype == TINY_NETIF_TYPE_LOOPBACK)
			&& (tiny_loopback_netif == NULL)) {
			tiny_loopback_netif = tiny_netif_defs[i].ifname;
		}
	}

	tiny_netif_addr_setup(tiny_loopback_netif);
	TINY_LOG_MSG(TINY_LOG_INFO, "%s : Using %s as loopback interface\n",
				 funcname, tiny_loopback_netif);

	tiny_netif_addr_setup(tiny_physical_netif);
	TINY_LOG_MSG(TINY_LOG_INFO, "%s : Using %s as physical interface\n",
				 funcname, tiny_physical_netif);
}


static struct in6_addr *
tiny_netif_attach_mcastaddr(TinyNetif netif, struct in6_addr *addr6,
							int pfxlen)
{
	TINY_FUNC_NAME(tiny_netif_attach_mcastaddr);
	int i;
	tiny_netif_manage *tif = tiny_get_netif_by_name(netif);
	struct in6_addr *in6 = NULL;
	PRILEV p = SPLNET();
	if (tif == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no such interface %s\n",
					 funcname, netif);
		goto end;
	}
	else {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called, currentm = %d\n",
					 funcname, tif->num_mcastaddrs);
	}
	for (i = 0; i < TINY_NETIF_NUMMCASTADDRS; i ++) {
		if ((tif->maddr_stat[i] == ADDR_USED)
			&& (tif->mcastaddr[i].prefixlen == pfxlen)
			&& IN6_ARE_ADDR_EQUAL(&tif->mcastaddr[i].in6_addr, addr6)) {
			TINY_LOG_MSG(TINY_LOG_INFO,
						 "%s : address %s already attached for %s\n",
						 funcname, tiny_ip6_sprintf(addr6), netif);
			in6 = &tif->mcastaddr[i].in6_addr;
			goto end;
		}
	}
	if (tif->num_mcastaddrs == TINY_NETIF_NUMMCASTADDRS) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : can't attach more address for %s\n",
					 funcname, netif);
		goto end;
	}
	for (i = 0; i < TINY_NETIF_NUMMCASTADDRS; i ++) {
		if (tif->maddr_stat[i] != ADDR_FREE) {
			continue;
		}
		else {
			tif->mcastaddr[i].in6_addr = *addr6;
			tif->mcastaddr[i].prefixlen = pfxlen;
			tif->maddr_stat[i] = ADDR_USED;
			tif->num_mcastaddrs ++;
			in6 = &tif->mcastaddr[i].in6_addr;
			break;
		}
	}
 end:
	SPLX(p);
	return in6;
}


struct in6_addr *
tiny_netif_get_linklocal_addr(TinyNetif netif, struct in6_addr *addr)
{
	TINY_FUNC_NAME(tiny_netif_get_linklocal_addr);
	int i;
	tiny_netif_manage *tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no such interface %s\n",
					 funcname, netif);
		return NULL;
	}
	for (i = 0; i < TINY_NETIF_NUMADDRS; i ++) {
		if ((tif->addr_stat[i] == ADDR_USED)
			&& IN6_IS_ADDR_LINKLOCAL(&tif->ifaddr[i].in6_addr)) {
			*addr = tif->ifaddr[i].in6_addr;
			return addr;
		}
	}
	return NULL;
}


struct in6_addr *
tiny_netif_attach_addr_with_prefix(TinyNetif netif,
								   struct in6_addr *prefix, int pfxlen)
{
	TINY_FUNC_NAME(tiny_netif_attach_addr_with_prefix);
	tiny_netif_manage *tif;
	struct in6_addr *ret = NULL;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : try to attach address for %s "
				 "with prefix(%s/%d)\n", funcname,
				 netif, tiny_ip6_sprintf(prefix), pfxlen);

	if (pfxlen != TINY_DEFAULT_PREFIX_LEN) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : unsupported prefix length %d\n",
					 funcname, pfxlen);
		return NULL;
	}
	tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no such interface %s\n",
					 funcname, netif);
		return NULL;
	}
	if (tif->num_addrs >= 1) {
		struct in6_addr addr;
		struct in6_addr ifid;
		struct in6_addr linklocal;
		int i;
		tiny_netif_get_linklocal_addr(netif, &linklocal);
		tiny_get_prefix_from_addr(prefix, pfxlen, &addr);
		tiny_get_ifid_from_addr(&linklocal, pfxlen, &ifid);
		for (i = 0; i < 4; i ++) {
			addr.s6_addr32[i] |= ifid.s6_addr32[i];
		}
		ret = tiny_netif_attach_addr(netif, &addr, pfxlen, tif->flags);
	}
	else if (tif->num_addrs == 0) {
		struct in6_addr addr;
		tiny_get_prefix_from_addr(prefix, pfxlen, &addr);		
		tiny_get_hw_ifid(netif, &addr);
		ret = tiny_netif_attach_addr(netif, &addr, pfxlen,
									 TINY_ADDR_FLAG_TENTATIVE);
		if (tiny_netif_is_available(netif) == TinyTrue) {
			tiny_nd6_sched_dad(&addr, 1000);	/* XXX */
		}
	}
	return ret;
}


void
tiny_netif_detach_addr_with_prefix(TinyNetif netif,
								   struct in6_addr *prefix, int pfxlen)
{
	TINY_FUNC_NAME(tiny_netif_detach_addr_with_prefix);
	tiny_netif_manage *tif;
	int i;

	if (pfxlen != TINY_DEFAULT_PREFIX_LEN) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : unsupported prefix length %d\n",
					 funcname, pfxlen);
		return;
	}
	tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no such interface %s\n",
					 funcname, netif);
		return;
	}
	for (i = 0; i < TINY_NETIF_NUMADDRS; i ++) {
		if (tif->addr_stat[i] != ADDR_USED) {
			continue;
		}
		if (tiny_addr_prefix_equal(&tif->ifaddr[i].in6_addr, prefix, pfxlen)
			== TinyTrue) {
			tif->addr_stat[i] = ADDR_FREE;
			tif->num_addrs --;
			TINY_LOG_MSG(TINY_LOG_INFO, "address %s detached from %s\n",
						 tiny_ip6_sprintf(&tif->ifaddr[i].in6_addr), netif);
			break;
		}
	}
}


TinyNetif
tiny_netif_search_addr(struct in6_addr *addr)
{
	tiny_netif_manage *tif;
	int i;
	int j;
	for (i = 0; i < TINY_NUM_NETIFS; i ++) {
		tif = &tiny_netif_list[i];
		for (j = 0; j < TINY_NETIF_NUMADDRS; j ++) {
			if (tif->addr_stat[j] == ADDR_USED) {
				if (IN6_ARE_ADDR_EQUAL(addr, &tif->ifaddr[j].in6_addr)) {
					return (tif->ifname);
				}
			}
		}
	}
	return NULL;
}


TinyBool
tiny_netif_is_addr_my_unicast(TinyNetif netif, struct in6_addr *addr)
{
	tiny_netif_manage *tif;
	int i;
	if (IN6_IS_ADDR_MULTICAST(addr)) {
		return TinyFalse;
	}
	tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		return TinyFalse;
	}
	if (tif->flags & (TINY_ADDR_FLAG_TENTATIVE | TINY_ADDR_FLAG_DUPLICATED)) {
		return TinyFalse;
	}
	for (i = 0; i < TINY_NETIF_NUMADDRS; i ++) {
		if (tif->addr_stat[i] != ADDR_USED) {
			continue;
		}
		if (IN6_ARE_ADDR_EQUAL(&tif->ifaddr[i].in6_addr, addr)) {
			return TinyTrue;
		}
	}
	return TinyFalse;
}


TinyBool
tiny_netif_is_addr_on_localnet(TinyNetif netif, struct in6_addr *addr)
{
	tiny_netif_manage *tif;
	int i;
	if (IN6_IS_ADDR_MULTICAST(addr)) {
		return TinyFalse;
	}
	tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		return TinyFalse;
	}
	if (tif->flags & (TINY_ADDR_FLAG_TENTATIVE | TINY_ADDR_FLAG_DUPLICATED)) {
		return TinyFalse;
	}
	for (i = 0; i < TINY_NETIF_NUMADDRS; i ++) {
		if (tif->addr_stat[i] != ADDR_USED) {
			continue;
		}
		if (tiny_addr_prefix_equal(addr, &tif->ifaddr[i].in6_addr,
									tif->ifaddr[i].prefixlen) == TinyTrue) {
			return TinyTrue;
		}
	}
	return TinyFalse;
}


TinyBool
tiny_netif_is_addr_my_multicast(TinyNetif netif, struct in6_addr *addr)
{
	tiny_netif_manage *tif;
	int i;
	if (!IN6_IS_ADDR_MULTICAST(addr)) {
		return TinyFalse;
	}
	tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		return TinyFalse;
	}
	for (i = 0; i < TINY_NETIF_NUMMCASTADDRS; i ++) {
		if (tif->maddr_stat[i] != ADDR_USED) {
			continue;
		}
		if (IN6_ARE_ADDR_EQUAL(&tif->mcastaddr[i].in6_addr, addr)) {
			return TinyTrue;
		}
	}
	return TinyFalse;
}


#define EUI64_GBIT				0x01
#define EUI64_UBIT				0x02
#define EUI64_TO_IFID(in6)	do {(in6)->s6_addr[8] ^= EUI64_UBIT; } while (0)
#define EUI64_GROUP(in6)		((in6)->s6_addr[8] & EUI64_GBIT)
#define EUI64_INDIVIDUAL(in6)	(!EUI64_GROUP(in6))
#define EUI64_LOCAL(in6)		((in6)->s6_addr[8] & EUI64_UBIT)
#define EUI64_UNIVERSAL(in6)	(!EUI64_LOCAL(in6))

#define IFID_LOCAL(in6)			(!EUI64_LOCAL(in6))
#define IFID_UNIVERSAL(in6)		(!EUI64_UNIVERSAL(in6))


static int
tiny_get_hw_ifid(TinyNetif netif,
				 struct in6_addr *in6)	/* upper 64bits are preserved */
{
	char *addr;
	int addrlen;
	static U_INT8_T allzero[8] = { 0, 0, 0, 0, 0, 0, 0, 0, };
	static U_INT8_T allone[8] =	{ 0xff, 0xff, 0xff, 0xff,
								  0xff, 0xff, 0xff, 0xff, };

	addrlen = tiny_netif_get_hardware_addr(netif, &addr);
	if (addrlen < 0) {
		return -1;
	}

	/* get EUI64 */
	if (addrlen != 8 && addrlen != 6)
		return -1;

	if (TINY_BCMP(addr, allzero, addrlen) == 0)
		return -1;
	if (TINY_BCMP(addr, allone, addrlen) == 0)
		return -1;

	/* make EUI64 address */
	if (addrlen == 8)
		TINY_BCOPY(addr, &in6->s6_addr[8], 8);
	else if (addrlen == 6) {
		in6->s6_addr[8] = addr[0];
		in6->s6_addr[9] = addr[1];
		in6->s6_addr[10] = addr[2];
		in6->s6_addr[11] = 0xff;
		in6->s6_addr[12] = 0xfe;
		in6->s6_addr[13] = addr[3];
		in6->s6_addr[14] = addr[4];
		in6->s6_addr[15] = addr[5];
	}

	/* sanity check: g bit must not indicate "group" */
	if (EUI64_GROUP(in6))
		return -1;

	/* convert EUI64 into IPv6 interface identifier */
	EUI64_TO_IFID(in6);

	/*
	 * sanity check: ifid must not be all zero, avoid conflict with
	 * subnet router anycast
	 */
	if ((in6->s6_addr[8] & ~(EUI64_GBIT | EUI64_UBIT)) == 0x00 &&
		TINY_BCMP(&in6->s6_addr[9], allzero, 7) == 0) {
		return -1;
	}

	return 0;
}


TinyNetif
tiny_netif_select_src(struct in6_addr *dst, struct in6_addr *src)
{
	TINY_FUNC_NAME(tiny_netif_select_src);
	int i;
	int j;
	tiny_netif_manage *tif;
	int bestmatch  = 0;
	tiny_netif_manage *match_tif = NULL;
	int match_addr_idx = -1;
	tiny_netif_manage *physif = NULL;
	int linklocaladdr_idx;
	PRILEV p;

	p = SPLNET();
	for (i = 0; i < TINY_NUM_NETIFS; i ++) {
		tif = &tiny_netif_list[i];
		if (tif->flags
			& (TINY_ADDR_FLAG_TENTATIVE | TINY_ADDR_FLAG_DUPLICATED)) {
			continue;
		}
		for (j = 0; j < TINY_NETIF_NUMADDRS; j ++) {
			if (tif->addr_stat[j] == ADDR_USED) {
				int match;
				int islinklocal
					= IN6_IS_ADDR_LINKLOCAL(&tif->ifaddr[j].in6_addr);
				if ((physif == NULL)
					&& (tif->iftype == TINY_NETIF_TYPE_PHYSICAL)
					&& islinklocal) {
					physif = tif;
					linklocaladdr_idx = j;
				}
				match = tiny_addr_get_match_length(dst,
												   &tif->ifaddr[j].in6_addr);
				if (match > bestmatch) {
					if ((tif->iftype == TINY_NETIF_TYPE_LOOPBACK)
						&& (match != 128)) {
						continue;
					}
					bestmatch = match;
					match_tif = tif;
					match_addr_idx = j;
				}
			}
		}
	}
	SPLX(p);
	if (bestmatch > 0) {
		*src = match_tif->ifaddr[match_addr_idx].in6_addr;
		return match_tif->ifname;
	}
	else {
		/* i have only link-local but dst is global, use link-local */
		if (physif != NULL) {
			*src = physif->ifaddr[linklocaladdr_idx].in6_addr;
			return physif->ifname;
		}
		else {
			/* link-local address for physical interface
			   is tentative or duplicated */
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : can't find "
						 "any suitable address\n", funcname);
			return NULL;
		}
	}
}


TinyBool
tiny_netif_is_loopback(TinyNetif netif)
{
	tiny_netif_manage *tif = tiny_get_netif_by_name(netif);
	if ((tif != NULL) && (tif->iftype == TINY_NETIF_TYPE_LOOPBACK)) {
		return TinyTrue;
	}
	else {
		return TinyFalse;
	}
}


void
tiny_netif_dad_succeed(TinyNetif netif, struct in6_addr *addr)
{
	tiny_netif_manage *tif;
	PRILEV p;
	p = SPLNET();
	tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		goto end;
	}
	else {
		struct nd6_neighbor_cache *nbc;
		tif->flags &= ~TINY_ADDR_FLAG_TENTATIVE;
		nbc = tiny_nd6_nbrcache_lookup(addr);
		if (nbc == NULL) {
			nbc = tiny_nd6_nbrcache_alloc(addr);
		}
		TINY_BCOPY(tiny_netif_get_sockaddr_dl(netif), &nbc->saddrdl,
				   sizeof(nbc->saddrdl));	/* XXX */
		nbc->state = TINY_NDCACHE_REACHABLE;
		nbc->expire = 0;
	}
 end:
	SPLX(p);
}


void
tiny_netif_dad_failed(TinyNetif netif, struct in6_addr *addr)
{
	tiny_netif_manage *tif;
	PRILEV p;
	p = SPLNET();
	tif = tiny_get_netif_by_name(netif);
	if (tif != NULL) {
		tif->flags &= ~TINY_ADDR_FLAG_TENTATIVE;
		tif->flags |= TINY_ADDR_FLAG_DUPLICATED;
	}
	SPLX(p);
}


TinyBool
tiny_netif_is_addr_tentative(TinyNetif netif, struct in6_addr *addr)
{
	tiny_netif_manage *tif = tiny_get_netif_by_name(netif);
	if (tif != NULL) {
		if (tif->flags & TINY_ADDR_FLAG_TENTATIVE) {
			return TinyTrue;
		}
	}
	return TinyFalse;
}


TinyBool
tiny_netif_is_addr_duplicated(TinyNetif netif, struct in6_addr *addr)
{
	tiny_netif_manage *tif = tiny_get_netif_by_name(netif);
	if (tif != NULL) {
		if (tif->flags & TINY_ADDR_FLAG_DUPLICATED) {
			return TinyTrue;
		}
	}
	return TinyFalse;
}


void
tiny_netif_setup_multicast(TinyNetif netif)
{
	TINY_FUNC_NAME(tiny_netif_setup_multicast);
	int i;
	tiny_netif_manage *tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no such interface %s\n",
					 funcname, netif);
		return;
	}
	for (i = 0; i < TINY_NETIF_NUMMCASTADDRS; i ++) {
		if (tif->maddr_stat[i] == ADDR_USED) {
			int ret;
			ret = tiny_netif_receive_l2_multicast(netif,
												  &tif->mcastaddr[i].in6_addr);
			if (ret == 0) {	/* succeed */
				;
			}
			else {
				TINY_LOG_MSG(TINY_LOG_ERR, "%s : failed for %s\n",
							 funcname, netif);
			}
		}
	}
}


void
tiny_netif_sched_dad(TinyNetif netif)
{
	TINY_FUNC_NAME(tiny_netif_sched_dad);
	int i;
	tiny_netif_manage *tif;
	PRILEV p;
	if (tiny_netif_equal(netif, tiny_physical_netif) == TinyFalse) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : no need dad for interface %s\n",
					 funcname, netif);
		return;
	}
	tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : no such interface %s\n",
					 funcname, netif);
		return;
	}
	p = SPLNET();
	if ((tif->flags & TINY_ADDR_FLAG_TENTATIVE) == 0) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : no need dad for interface %s"
					 "(not tentative)\n", funcname, netif);
	}
	else if ((tif->flags & TINY_ADDR_FLAG_DAD_SCHED) != 0) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : DAD already scheduled "
					 "for interface %s\n", funcname, netif);
	}
	else {
		for (i = 0; i < TINY_NETIF_NUMADDRS; i ++) {
			if (tif->addr_stat[i] == ADDR_USED) {
				tiny_nd6_sched_dad(&tif->ifaddr[i].in6_addr, 3000);	/* XXX */
				tif->flags |= TINY_ADDR_FLAG_DAD_SCHED;
			}
		}
	}
	SPLX(p);
}


void
tiny_netif_start_dad(TinyNetif netif)
{
	tiny_netif_manage *tif;
	if (tiny_netif_equal(netif, tiny_physical_netif) == TinyFalse) {
		TINY_LOG_MSG(TINY_LOG_INFO, "no need dad for interface %s\n", netif);
		return;
	}
	tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		/* XXX */
		TINY_LOG_MSG(TINY_LOG_INFO, "no need dad for interface %s\n", netif);
		return;
	}
	tif->flags |= TINY_ADDR_FLAG_DAD_RUNNING;
}


TinyBool
tiny_netif_is_dad_running(TinyNetif netif)
{
	tiny_netif_manage *tif;
	if (tiny_netif_equal(netif, tiny_physical_netif) == TinyFalse) {
		TINY_LOG_MSG(TINY_LOG_INFO, "no need dad for interface %s\n", netif);
		return 0;
	}
	tif = tiny_get_netif_by_name(netif);
	if (tif == NULL) {
		TINY_LOG_MSG(TINY_LOG_INFO, "no suchinterface %s\n", netif);
		return 0;
	}
	if ((tif->flags & TINY_ADDR_FLAG_DAD_RUNNING) == 0) {
		return TinyFalse;
	}
	else {
		return TinyTrue;
	}
}


TinyBool
tiny_netif_is_valid(TinyNetif netif)
{
	if (netif == NULL) {
		return TinyFalse;
	}
	else {
		return TinyTrue;
	}
}


TinyBool
tiny_netif_equal(TinyNetif netif1, TinyNetif netif2)
{
	int len1 = TINY_STRLEN(netif1);
	int len2 = TINY_STRLEN(netif2);
	if (len1 != len2) {
		return TinyFalse;
	}
	else if (TINY_BCMP(netif1, netif2, len1) == 0) {
		return TinyTrue;
	}
	else {
		return TinyFalse;
	}
}


/* XXX */
int
tiny_print_physif_addrlist(char *buf, int buflen)
{
	tiny_netif_manage *tif = NULL;
	TinyNetif netif = tiny_physical_netif;
	char *ifstat;
	int i;
	int len = 0;
	for (i = 0; i < TINY_NUM_NETIFS; i ++) {
		if (tiny_netif_equal(tiny_netif_list[i].ifname, netif) == TinyTrue) {
			tif = &tiny_netif_list[i];
			break;
		}
	}
	if (tif == NULL) {
		return 0;
	}
	if (tif->flags & TINY_ADDR_FLAG_TENTATIVE) {
		ifstat = "[tentative]";
	}
	else if (tif->flags & TINY_ADDR_FLAG_DUPLICATED) {
		ifstat = "[duplicated]";
	}
	else {
		ifstat = "";
	}
	len += sprintf(buf, "%s%s\n", netif, ifstat);
	for (i = 0; i < TINY_NETIF_NUMADDRS; i ++) {
		if (tif->addr_stat[i] == ADDR_USED) {
			len += sprintf(buf + len, "%s\n",
						   tiny_ip6_sprintf(&tif->ifaddr[i].in6_addr));
			/* XXX : check buffer overflow */
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
