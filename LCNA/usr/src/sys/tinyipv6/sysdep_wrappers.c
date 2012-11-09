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

/*	$Id: sysdep_wrappers.c,v 1.1 2002/05/29 13:30:46 fujita Exp $	*/


#include <sys/param.h>
#include <sys/types.h>
#include <sys/proc.h>
#include <sys/mbuf.h>
#include <sys/socket.h>
#include <sys/protosw.h>
#include <sys/socketvar.h>
#include <sys/errno.h>
#include <net/if.h>
#include <net/route.h>
#include <netinet/in.h>
#include <netinet/ip6.h>
#include <netinet6/ip6_var.h>
#include <netinet6/in6_pcb.h>
#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_ip6_var.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/tiny_icmp6.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/sysdep_l2.h>
#include <tinyipv6/sysdep_wrappers.h>


struct ip6stat ip6stat;


void
ip6intr(void)
{
  tiny_ip6intr();
}
  
void
in6_ifattach(struct ifnet *ifp, struct ifnet *altifp)
{
	TINY_FUNC_NAME(in6_ifattach);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	tiny_netif_addr_setup(ifp->if_xname);
}

void
in6_if_up(struct ifnet *ifp)
{
	TINY_FUNC_NAME(in6_if_up);
	char *ifname = ifp->if_xname;
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called for %s\n", funcname, ifname);
	if (tiny_netif_equal(ifname, tiny_physical_netif) == TinyTrue) {
		tiny_netif_setup_multicast(ifname);
		tiny_netif_sched_dad(ifname);
		tiny_nd6_sched_send_rs(4500);	/* XXX */
	}
	else {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : nothing to be done for %s\n",
					 funcname, ifname);
	}
}

void
nd6_setmtu(struct ifnet *ifp)
{
	TINY_FUNC_NAME(nd6_setmtu);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);	
	/* do nothing */
}

char *
ip6_sprintf(struct in6_addr *addr)
{
	return tiny_ip6_sprintf(addr);
}


void
nd6_nud_hint(struct rtentry *rt, struct in6_addr *dst6, int force)
{
	TINY_FUNC_NAME(nd6_nud_hint);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
}

void
icmp6_error(struct mbuf *m, int type, int code, int param)
{
	TINY_FUNC_NAME(icmp6_error);
	tinybuf *tbuf;
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	tbuf = sysbuf2tinybuf(m);
	tiny_icmp6_error(tbuf, type, code, param);
	tinybuf_free(tbuf);
}

int
icmp6_input(struct mbuf **mp, int *offp, int proto)
{
	TINY_FUNC_NAME(icmp6_input);
	tinybuf *tbuf;
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	tbuf = sysbuf2tinybuf(*mp);
	return tiny_icmp6_input(&tbuf, offp);
}

int
ip6_ctloutput(int op, struct socket *so, int level,
			  int optname, struct mbuf **mp)
{
	TINY_FUNC_NAME(ip6_ctloutput);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return 0;
}

void
rip6_init(void)
{
}

int
rip6_input(struct mbuf **mp, int *offp, int proto)
{
	TINY_FUNC_NAME(rip6_input);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return 0;
}

int
rip6_output(struct mbuf *m, ...)
{
	TINY_FUNC_NAME(rip6_output);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return 0;
}

void
rip6_ctlinput(int cmd, struct sockaddr *sa, void *d)
{
	TINY_FUNC_NAME(rip6_ctlinput);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
}

int
rip6_ctloutput(int op, struct socket *so, int level,
			   int optname, struct mbuf **m)
{
	TINY_FUNC_NAME(rip6_ctloutput);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return 0;
}

int
rip6_usrreq(register struct socket *so, int req, struct mbuf *m,
			struct mbuf *nam, struct mbuf *control, struct proc *p)
{
	TINY_FUNC_NAME(rip6_usrreq);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return 0;
}

void
ip6_savecontrol(register struct in6pcb *in6p, register struct mbuf **mp,
				register struct ip6_hdr *ip6, register struct mbuf *m)
{
	TINY_FUNC_NAME(ip6_savecontrol);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
}

int
in6_selecthlim(struct in6pcb *in6p, struct ifnet *ifp)
{
	TINY_FUNC_NAME(in6_selecthlim);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return CurHopLimit;	/* XXX */
}

int
in6_localaddr(struct in6_addr *in6)
{
	TINY_FUNC_NAME(in6_localaddr);
	TinyBool res;
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	res = tiny_netif_is_addr_my_unicast(tiny_loopback_netif, in6);
	if (res == TinyTrue) {
		return 1;
	}
	res = tiny_netif_is_addr_on_localnet(tiny_physical_netif, in6);
	if (res == TinyTrue) {
		return 1;
	}
	return 0;
}

int
ip6_optlen(struct in6pcb *in6p)
{
	TINY_FUNC_NAME(ip6_optlen);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return 0;
}

U_CHAR  inet6ctlerrmap[PRC_NCMDS] = {
	0,              0,              0,              0,
	0,              EMSGSIZE,       EHOSTDOWN,      EHOSTUNREACH,
	EHOSTUNREACH,   EHOSTUNREACH,   ECONNREFUSED,   ECONNREFUSED,
	EMSGSIZE,       EHOSTUNREACH,   0,              0,
	0,              0,              0,              0,
	ENOPROTOOPT
};

int
in6_control(struct  socket *so, u_long cmd, caddr_t data,
			struct ifnet *ifp, struct proc *p)
{
	TINY_FUNC_NAME(in6_control);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return 0;
}

void
in6_purgeif(struct ifnet *ifp)
{
	TINY_FUNC_NAME(in6_purgeif);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
}

int ip6_bindv6only = 1;

int
in6_pcbsetport(struct in6_addr *laddr, struct in6pcb *in6p)
{
	TINY_FUNC_NAME(in6_pcbsetport);
	struct socket *so = in6p->in6p_socket;
	struct in6pcb *head = in6p->in6p_head;
	u_int16_t last_port, lport = 0;
	int wild = 0;
	void *t;
	u_int16_t min, max;
	struct proc *p = curproc;		/* XXX */

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	/* XXX: this is redundant when called from in6_pcbbind */
	if ((so->so_options & (SO_REUSEADDR|SO_REUSEPORT)) == 0
		&& ((so->so_proto->pr_flags & PR_CONNREQUIRED) == 0
			|| (so->so_options & SO_ACCEPTCONN) == 0))
		wild = IN6PLOOKUP_WILDCARD;

	if (in6p->in6p_flags & IN6P_LOWPORT) {
#ifndef IPNOPRIVPORTS
		if (p == 0 || (suser(p->p_ucred, &p->p_acflag) != 0))
			return (EACCES);
#endif
		min = ip6_lowportmin;
		max = ip6_lowportmax;
	}
	else {
		min = ip6_anonportmin;
		max = ip6_anonportmax;
	}

	/* value out of range */
	if (head->in6p_lport < min)
		head->in6p_lport = min;
	else if (head->in6p_lport > max)
		head->in6p_lport = min;
	last_port = head->in6p_lport;
	goto startover;	/*to randomize*/
	for (;;) {
		lport = htons(head->in6p_lport);
		t = in6_pcblookup(head, &zeroin6_addr, 0, laddr, lport, wild);
		if (t == 0)
			break;
	startover:
		if (head->in6p_lport >= max)
			head->in6p_lport = min;
		else
			head->in6p_lport++;
		if (head->in6p_lport == last_port)
			return (EADDRINUSE);
	}

	in6p->in6p_lport = lport;
	return(0);		/* success */
}

struct in6_addr *
in6_selectsrc(struct sockaddr_in6 *dstsock, struct ip6_pktopts *opts,
			  struct ip6_moptions *mopts, struct route_in6 *ro,
			  struct in6_addr *laddr, int *errorp)
{
	TINY_FUNC_NAME(in6_selectsrc);
	struct in6_addr *dst;
	static struct in6_addr src;
	char *ifname;
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	dst = &dstsock->sin6_addr;
	*errorp = 0;

	if (IN6_IS_ADDR_MULTICAST(dst)) {
		ifname = tiny_physical_netif;
		tiny_netif_get_linklocal_addr(ifname, &src);
	}
	else {
		ifname = tiny_netif_select_src(dst, &src);
	}
	if (ifname != NULL) {
		return (&src);
	}
	else {
		*errorp = EADDRNOTAVAIL;
		return NULL;
	}
}

void
ip6_freemoptions(register struct ip6_moptions *im6o)
{
	TINY_FUNC_NAME(ip6_freemoptions);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return;
}

int
ip6_setpktoptions(struct mbuf *control, struct ip6_pktopts *opt, int priv)
{
	TINY_FUNC_NAME(ip6_setpktoptions);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);
	return 0;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
