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

/*	$Id: sysdep_l4.c,v 1.1 2002/05/29 13:30:37 fujita Exp $	*/


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6_output.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_esp.h>
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/sysdep_l4.h>


extern int tcp6_input(struct mbuf **, int *, int);
extern int udp6_input(struct mbuf **, int *, int);


void
tiny_tcp_input(tinybuf **tbufp, int *offp)
{
	TINY_FUNC_NAME(tiny_tcp_input);
	tinybuf *tbuf = *tbufp;
	int off = *offp;
	struct mbuf *m;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : offset = %d\n", funcname, off);

	m = (struct mbuf *)tinybuf2sysbuf(tbuf);
	if (m == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : Can't get mbuf in tiny_tcp_input()\n",
					 funcname);
		return;
	}
	tcp6_input(&m, offp, IPPROTO_TCP);
	return;
}


void
tiny_udp_input(tinybuf **tbufp, int *offp)
{
	TINY_FUNC_NAME(tiny_udp_input);
	tinybuf *tbuf = *tbufp;
	int off = *offp;
	struct mbuf *m;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : offset = %d\n", funcname, off);

	m = (struct mbuf *)tinybuf2sysbuf(tbuf);
	if (m == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : Can't get mbuf\n", funcname);
		return;
	}
	udp6_input(&m, offp, IPPROTO_UDP);
	return;
}


/*** XXX ***/
int
ip6_output(struct mbuf *m0, void *opt, void *ro,
		   int flags, void *im6o, struct ifnet **ifpp)
{
	TINY_FUNC_NAME(ip6_output);
	tinybuf *tbuf;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);

	tbuf = sysbuf2tinybuf(m0);
	if (tbuf == NULL) {
		/* XXX */
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer transform failed\n", funcname);
		return ENOBUFS;
	}
	return tiny_ip6_output(tbuf, 0);
}


int
tiny_getsockopt(struct socket *so, int code, void *arg)
{
	return 0;
}


int
tiny_setsockopt(struct socket *so, int code, void *arg)
{
	return 0;
}



/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
