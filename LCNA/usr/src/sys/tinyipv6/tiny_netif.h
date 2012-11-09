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

/*	$Id: tiny_netif.h,v 1.1 2002/05/29 13:31:15 fujita Exp $ */


#ifndef _TINYIPV6_TINY_NETIF_H_
#define _TINYIPV6_TINY_NETIF_H_

extern TinyNetif tiny_loopback_netif;
extern TinyNetif tiny_physical_netif;

extern void tiny_netif_addr_setup(TinyNetif netif);

extern void tiny_netif_list_init(void);
extern struct in6_addr *
tiny_netif_addr_attach(TinyNetif netif, struct in6_addr *addr6,
					   int pfxlen, int flags);
extern struct in6_addr *
tiny_netif_get_linklocal_addr(TinyNetif netif, struct in6_addr *addr);
extern struct in6_addr *
tiny_netif_attach_addr_with_prefix(TinyNetif netif,
								   struct in6_addr *prefix, int pfxlen);
extern void
tiny_netif_detach_addr_with_prefix(TinyNetif netif,
								   struct in6_addr *prefix, int pfxlen);

extern TinyNetif tiny_netif_search_addr(struct in6_addr *addr);

extern TinyBool tiny_netif_is_addr_my_unicast(TinyNetif netif,
											   struct in6_addr *addr);
extern  TinyBool tiny_netif_is_addr_on_localnet(TinyNetif netif,
												 struct in6_addr *addr);
extern TinyBool tiny_netif_is_addr_my_multicast(TinyNetif netif,
												 struct in6_addr *addr);
extern TinyNetif tiny_netif_select_src(struct in6_addr *dst,
										struct in6_addr *src);
extern TinyBool tiny_netif_is_loopback(TinyNetif netif);

extern void tiny_netif_dad_succeed(TinyNetif netif, struct in6_addr *addr);
extern void tiny_netif_dad_failed(TinyNetif netif, struct in6_addr *addr);

extern TinyBool tiny_netif_is_addr_tentative(TinyNetif netif,
											  struct in6_addr *addr);
extern TinyBool tiny_netif_is_addr_duplicated(TinyNetif netif,
											   struct in6_addr *addr);

extern void tiny_netif_setup_multicast(TinyNetif netif);
extern void tiny_netif_start_dad(TinyNetif netif);
extern void tiny_netif_sched_dad(TinyNetif netif);
extern TinyBool tiny_netif_is_dad_running(TinyNetif netif);

extern void tiny_netif_address_timer(TinyNetif netif);

extern TinyBool tiny_netif_is_valid(TinyNetif netif);
extern TinyBool tiny_netif_equal(TinyNetif netif1, TinyNetif netif2);

extern int tiny_print_physif_addrlist(char *buf, int buflen);


#endif	/* _TINYIPV6_TINY_NETIF_H_ */


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
