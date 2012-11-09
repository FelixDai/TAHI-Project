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

/*	$Id: sysdep_wrappers.h,v 1.1 2002/05/29 13:30:46 fujita Exp $	*/


#ifndef	_TINYIPV6_SYSDEP_WRAPPERS_H_
#define	_TINYIPV6_SYSDEP_WRAPPERS_H_


extern void ip6intr(void);
extern void in6_ifattach(struct ifnet *ifp, struct ifnet *altifp);
extern void in6_if_up(struct ifnet *ifp);
extern void nd6_setmtu(struct ifnet *ifp);
extern char *ip6_sprintf(struct in6_addr *addr);
extern void nd6_nud_hint(struct rtentry *rt, struct in6_addr *dst6, int force);
extern void icmp6_error(struct mbuf *m, int type, int code, int param);
extern int icmp6_input(struct mbuf **mp, int *offp, int proto);
extern int ip6_ctloutput(int op, struct socket *so, int level,
						 int optname, struct mbuf **mp);
extern void rip6_init(void);
extern int rip6_input(struct mbuf **mp, int *offp, int proto);
extern int rip6_output(struct mbuf *m, ...);
extern void rip6_ctlinput(int cmd, struct sockaddr *sa, void *d);
extern int rip6_ctloutput(int op, struct socket *so, int level,
						  int optname, struct mbuf **m);
extern int rip6_usrreq(register struct socket *so, int req, struct mbuf *m,
					   struct mbuf *nam, struct mbuf *control, struct proc *p);
extern void ip6_savecontrol(register struct in6pcb *in6p,
							register struct mbuf **mp,
							register struct ip6_hdr *ip6,
							register struct mbuf *m);
extern int in6_selecthlim(struct in6pcb *in6p, struct ifnet *ifp);
extern int in6_localaddr(struct in6_addr *in6);
extern int ip6_optlen(struct in6pcb *in6p);
extern u_char inet6ctlerrmap[];
extern int in6_control(struct  socket *so, u_long cmd, caddr_t data,
					   struct ifnet *ifp, struct proc *p);
extern void in6_purgeif(struct ifnet *ifp);
extern int ip6_bindv6only;
extern int in6_pcbsetport(struct in6_addr *laddr, struct in6pcb *in6p);
extern struct in6_addr *in6_selectsrc(struct sockaddr_in6 *dstsock,
									  struct ip6_pktopts *opts,
									  struct ip6_moptions *mopts,
									  struct route_in6 *ro,
									  struct in6_addr *laddr, int *errorp);
extern void ip6_freemoptions(register struct ip6_moptions *im6o);
extern int ip6_setpktoptions(struct mbuf *control,
							 struct ip6_pktopts *opt, int priv);




#endif	/*	_TINYIPV6_SYSDEP_WRAPPERS_H_	*/


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
