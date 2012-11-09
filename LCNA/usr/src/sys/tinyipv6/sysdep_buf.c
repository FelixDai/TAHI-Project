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

/*	$Id: sysdep_buf.c,v 1.1 2002/05/29 13:30:34 fujita Exp $	*/


#include <sys/types.h>
#include <sys/param.h>
#include <sys/socket.h>
#include <net/if.h>
#include <sys/mbuf.h>

#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/sysdep_spl.h>
#include <tinyipv6/sysdep_utils.h>


tinybuf *
sysbuf2tinybuf(void *sysbuf)
{
	struct mbuf *m = (struct mbuf *)sysbuf;
	struct mbuf *m0 = m;
	tinybuf *tbuf;
	char *dst;
	int len;

	if (m == NULL) {
		return NULL;
	}

	if ((m->m_flags & M_PKTHDR) == 0) {	/* m must be head of mbuf chain */
		return NULL;
	}

	tbuf = tinybuf_alloc();
	if (tbuf == NULL) {	/* can't allocate buffer */
		goto err;
	}
	tbuf->netif = m->m_pkthdr.rcvif->if_xname;
	dst = tbuf->pkt;

	tbuf->len = 0;
	len = m->m_pkthdr.len;
	if (len > sizeof(tbuf->pkt)) {	/* packet too large */
		goto err;
	}

	while (m != NULL) {
		TINY_BCOPY(m->m_data, dst, m->m_len);
		dst += m->m_len;
		tbuf->len += m->m_len;
		m = m->m_next;
	}

	if (tbuf->len != len) {	/* length mismatch */
		goto err;
	}

	m_freem(m0);
	return tbuf;

 err:
	if (tbuf != NULL) {
		tinybuf_free(tbuf);
	}
	m_freem(m0);
	return NULL;
}


void *
tinybuf2sysbuf(tinybuf *tbuf)
{
	struct mbuf *m;

	if (tbuf == NULL) {
		return NULL;
	}

	MGETHDR(m, M_DONTWAIT, MT_HEADER);
	if (m == NULL) {
		goto err;
	}

	if (tbuf->len <= sizeof(m->m_pktdat)) {
		TINY_BCOPY(tbuf->pkt, m->m_data, tbuf->len);
		m->m_pkthdr.len = m->m_len = tbuf->len;
	}
	else {
		MCLGET(m, M_DONTWAIT);
		if ((m->m_flags & M_EXT) != M_EXT) {
			goto err;
		}
		TINY_BCOPY(tbuf->pkt, m->m_data, tbuf->len);
		m->m_pkthdr.len = m->m_len = tbuf->len;
	}

	if (tbuf->netif != NULL) {
		m->m_pkthdr.rcvif = ifunit(tbuf->netif);
	}

	tinybuf_free(tbuf);
	return (void *)m;

 err:
	if (m != NULL) {
		m_freem(m);
	}
	if (tbuf != NULL) {
		tinybuf_free(tbuf);
	}
	return NULL;
}


void *
write2sysbuf(CADDR_T *data, int len)
{
	struct mbuf *m;

	if (data == NULL) {
		return NULL;
	}

	MGETHDR(m, M_DONTWAIT, MT_HEADER);
	if (m == NULL) {
		goto err;
	}

	if (len <= sizeof(m->m_pktdat)) {
		TINY_BCOPY(data, m->m_data, len);
		m->m_pkthdr.len = m->m_len = len;
	}
	else {
		MCLGET(m, M_DONTWAIT);
		if ((m->m_flags & M_EXT) != M_EXT) {
			goto err;
		}
		TINY_BCOPY(data, m->m_data, len);
		m->m_pkthdr.len = m->m_len = len;
	}

	return (void *)m;

 err:
	if (m != NULL) {
		m_freem(m);
	}
	return NULL;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
