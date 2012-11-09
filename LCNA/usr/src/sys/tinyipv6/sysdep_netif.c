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

/*	$Id: sysdep_netif.c,v 1.1 2002/05/29 13:30:39 fujita Exp $	*/


#include <sys/types.h>
#include <sys/param.h>
#include <sys/socket.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <net/if_dl.h>

#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/sysdep_netif.h>
#include <tinyipv6/sysdep_spl.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/sysdep_l2.h>


static struct ifnet *
netif2sysif(TinyNetif netif)
{
	return ifunit(netif);
}


int
tiny_netif_get_hardware_addr(TinyNetif netif, char **hwa)
{
	TINY_FUNC_NAME(tiny_netif_get_hardware_addr);
	struct ifnet *ifp;
	struct ifaddr *ifa;
	struct sockaddr_dl *sdl;
	int len = -1;
	PRILEV p = SPLNET();
	if (tiny_netif_is_valid(netif) == TinyFalse) {
		TINY_FATAL_ERROR("%s : invalid argument", funcname);
		goto end;
	}
	ifp = netif2sysif(netif);
	if (ifp == NULL) {
		TINY_FATAL_ERROR("%s : no such interface %s", funcname, netif);
		goto end;
	}
	for (ifa = ifp->if_addrlist.tqh_first; ifa; ifa = ifa->ifa_list.tqe_next) {
		if (ifa->ifa_addr->sa_family != AF_LINK)
			continue;
		sdl = (struct sockaddr_dl *)ifa->ifa_addr;
		if ((sdl != NULL) && (sdl->sdl_alen != 0)) {
			*hwa = (char *)LLADDR(sdl);
			len = sdl->sdl_alen;
			goto end;
		}
	}
 end:
	SPLX(p);
	return len;
}


struct sockaddr_dl *
tiny_netif_get_sockaddr_dl(TinyNetif netif)
{
	TINY_FUNC_NAME(tiny_netif_get_sockaddr_dl);
	struct ifnet *ifp;
	struct ifaddr *ifa;
	struct sockaddr_dl *sdl = NULL;
	PRILEV p = SPLNET();
	if (tiny_netif_is_valid(netif) == TinyFalse) {
		TINY_FATAL_ERROR("%s : invalid argument", funcname);
		goto end;
	}
	ifp = netif2sysif(netif);
	if (ifp == NULL) {
		TINY_FATAL_ERROR("%s : no such interface %s", funcname, netif);
		goto end;
	}
	for (ifa = ifp->if_addrlist.tqh_first; ifa; ifa = ifa->ifa_list.tqe_next) {
		if (ifa->ifa_addr->sa_family != AF_LINK) {
			continue;
		}
		sdl = (struct sockaddr_dl *)ifa->ifa_addr;
		break;
	}
 end:
	SPLX(p);
	return sdl;
}


TinyBool
tiny_netif_support_multicast(TinyNetif netif)
{
	TINY_FUNC_NAME(tiny_netif_support_multicast);
	struct ifnet *ifp;
	if (tiny_netif_is_valid(netif) == TinyFalse) {
		TINY_FATAL_ERROR("%s : invalid argument", funcname);
		return TinyFalse;
	}
	ifp = netif2sysif(netif);
	if (ifp == NULL) {
		TINY_FATAL_ERROR("%s : no such interface %s", funcname, netif);
		return TinyFalse;
	}
	if ((ifp->if_flags & IFF_MULTICAST) != 0) {
		return TinyTrue;
	}
	else {
		return TinyFalse;
	}
}


struct  in6_ifreq {
	char    ifr_name[IFNAMSIZ];
	struct  sockaddr_in6 addr;
};


int
tiny_netif_receive_l2_multicast(TinyNetif netif, struct in6_addr *multi6)
{
	TINY_FUNC_NAME(tiny_netif_receive_l2_multicast);
	struct ifnet *ifp;
	struct in6_ifreq ifr;
	int ret = 0;
	PRILEV p = SPLNET();
	if (tiny_netif_is_valid(netif) == TinyFalse) {
		TINY_FATAL_ERROR("%s : invalid argument\n", funcname);
		goto end;
	}
	ifp = netif2sysif(netif);
	if (ifp == NULL) {
		TINY_FATAL_ERROR("%s : no such interface %s", funcname, netif);
		goto end;
	}
	TINY_BZERO(&ifr.addr, sizeof(struct sockaddr_in6));
	ifr.addr.sin6_len = sizeof(struct sockaddr_in6);
	ifr.addr.sin6_family = AF_INET6;
	ifr.addr.sin6_addr = *multi6;
	if (ifp->if_ioctl != NULL) {
		ret = (*ifp->if_ioctl)(ifp, SIOCADDMULTI, (CADDR_T)&ifr);
		if (ret != 0) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : ioctl(SIOCADDMULTI) error (%d)\n",
						 funcname, ret);
		}
		else {
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ioctl(SIOCADDMULTI) ok\n",
						 funcname);
		}
	}
 end:
	SPLX(p);
	return ret;
}


TinyBool
tiny_netif_is_available(TinyNetif netif)
{
	struct ifnet *ifp;
	if (tiny_netif_is_valid(netif) == TinyFalse) {
		return TinyFalse;
	}
	ifp = netif2sysif(netif);
	if (ifp == NULL) {
		return TinyFalse;
	}
	if ((ifp->if_flags & (IFF_UP | IFF_RUNNING)) == (IFF_UP | IFF_RUNNING)) {
		return TinyTrue;
	}
	else {
		return TinyFalse;
	}
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
