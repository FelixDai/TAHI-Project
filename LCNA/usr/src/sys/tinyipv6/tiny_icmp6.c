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

/*	$Id: tiny_icmp6.c,v 1.1 2002/05/29 13:30:56 fujita Exp $	*/


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_ip6_var.h>
#include <tinyipv6/tiny_icmp6.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/tiny_in6_cksum.h>
#include <tinyipv6/tiny_ip6_output.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/sysdep_utils.h>


static int tiny_icmp6_rawip6_input(tinybuf **tbufp, int off);

void
tiny_icmp6_init(void)
{
	return;
}


/*
 * Generate an error packet of type error in response to bad IP6 packet.
 */
void
tiny_icmp6_error(tinybuf *tbuf, int type, int code, int param)
{
	TINY_FUNC_NAME(tiny_icmp6_error);
	tinybuf *ntbuf;
	struct ip6_hdr *ip6;
	struct ip6_hdr *nip6;
	struct icmp6_hdr *nicmp6;
	int icmp6len;

	if (tbuf->crypt_flag == TinyTrue) {
		/* original packet was encrypted, don't send back */
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : original packet was encrypted. "
					 "do not send icmp error\n", funcname);
		return;
	}

	ip6 = (struct ip6_hdr *) tbuf->pkt;

	icmp6len = sizeof(struct icmp6_hdr)
		+ (sizeof(struct ip6_hdr) + ntohs(ip6->ip6_plen));

	if ((sizeof(struct ip6_hdr) + icmp6len) > TINY_MTU) {
		icmp6len = TINY_MTU - sizeof(struct ip6_hdr);
	}

	ntbuf = tinybuf_alloc();
	if (ntbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
					 funcname);
		return;
	}

	nip6 = (struct ip6_hdr *) ntbuf->pkt;
	TINY_BZERO(nip6, (sizeof(struct ip6_hdr) + sizeof(struct icmp6_hdr)));
	nicmp6 = (struct icmp6_hdr *)(nip6 + 1);
	nip6->ip6_flow = 0;
	nip6->ip6_vfc &= ~IPV6_VERSION_MASK;
	nip6->ip6_vfc |= IPV6_VERSION;
	nip6->ip6_dst = ip6->ip6_src;
	if (IN6_IS_ADDR_MULTICAST(&ip6->ip6_dst)) {
		TinyNetif outif;
		if ((type == ICMP6_PARAM_PROB) && (code == ICMP6_PARAMPROB_OPTION)) {
			;	/* ok */
		}
		else {
			tinybuf_free(ntbuf);
			return;
		}
		outif = tiny_netif_select_src(&nip6->ip6_dst, &nip6->ip6_src);
		if (outif == NULL) {
			tinybuf_free(ntbuf);
			return;
		}
	}
	else {
		nip6->ip6_src = ip6->ip6_dst;
	}
	nip6->ip6_plen = htons(icmp6len);
	nip6->ip6_nxt = IPPROTO_ICMPV6;
	nip6->ip6_hlim = CurHopLimit;
	TINY_BCOPY(ip6, nicmp6 + 1, icmp6len);
	ntbuf->len = sizeof(struct ip6_hdr) + icmp6len;
	nicmp6->icmp6_type = type;
	nicmp6->icmp6_code = code;
	nicmp6->icmp6_pptr = htonl((U_INT32_T)param);
	nicmp6->icmp6_cksum = 0;
	nicmp6->icmp6_cksum = tiny_in6_cksum(ntbuf, IPPROTO_ICMPV6,
										 sizeof(struct ip6_hdr), icmp6len);
	tiny_ip6_output(ntbuf, 0);
	return;
}


static void
tiny_icmp6_echo_reply(tinybuf *tbuf, int off)
{
	TINY_FUNC_NAME(tiny_icmp6_echo_reply);
	struct ip6_hdr *ip6;
	struct icmp6_hdr *icmp6;
	int icmp6len;
	tinybuf *ntbuf;
	struct ip6_hdr *nip6;
	struct icmp6_hdr *nicmp6;
	int noff;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);

	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : tbuf == NULL\n", funcname);
		goto end;
	}
	ip6 = (struct ip6_hdr *)tbuf->pkt;
	icmp6 = (struct icmp6_hdr *)((CADDR_T)tbuf->pkt + off);
	icmp6len = tbuf->len - off;

	ntbuf = tinybuf_alloc();
	if (ntbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
					 funcname);
		goto end;
	}

	nip6 = (struct ip6_hdr *)ntbuf->pkt;
	nicmp6 = (struct icmp6_hdr *)(nip6 + 1);
	if (off > sizeof(struct ip6_hdr)) {
		/* tbuf includes option header, skip it */
		TINY_BCOPY(ip6, nip6, sizeof(struct ip6_hdr));
		TINY_BCOPY(icmp6, nicmp6, icmp6len);
	}
	else {
		TINY_BCOPY(ip6, nip6, sizeof(struct ip6_hdr) + icmp6len);
	}
	noff = sizeof(struct ip6_hdr);
	ntbuf->len = noff + icmp6len;
	nicmp6->icmp6_type = ICMP6_ECHO_REPLY;
	nicmp6->icmp6_code = 0;
	nip6->ip6_flow = 0;
	nip6->ip6_vfc &= ~IPV6_VERSION_MASK;
	nip6->ip6_vfc |= IPV6_VERSION;
	nip6->ip6_dst = ip6->ip6_src;
	if (IN6_IS_ADDR_MULTICAST(&ip6->ip6_dst)) {
		TinyNetif outif;
		outif = tiny_netif_select_src(&nip6->ip6_dst, &nip6->ip6_src);
		if (outif == NULL) {
			tinybuf_free(ntbuf);
			return;
		}
	}
	else {
		nip6->ip6_src = ip6->ip6_dst;
	}
	nip6->ip6_plen = htons(icmp6len);
	nip6->ip6_nxt = IPPROTO_ICMPV6;
	nip6->ip6_hlim = CurHopLimit;
	nicmp6->icmp6_cksum = 0;
	nicmp6->icmp6_cksum = tiny_in6_cksum(ntbuf, IPPROTO_ICMPV6,
										 sizeof(struct ip6_hdr), icmp6len);
	tiny_ip6_output(ntbuf, 0);		/* XXX */
 end:
}


/*
 * Process a received ICMP6 message.
 */
int
tiny_icmp6_input(tinybuf **tbufp, int *offp)
{
	TINY_FUNC_NAME(tiny_icmp6_input);
	tinybuf *tbuf = *tbufp;
	int off = *offp;
	struct ip6_hdr *ip6;
	struct icmp6_hdr *icmp6;
	int cksum;
	int type;
	int code;
	int icmp6len;
	tinybuf *ntbuf;

	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : tbuf == NULL\n", funcname);
		goto end;
	}

	ip6 = (struct ip6_hdr *)tbuf->pkt;

	icmp6len = tbuf->len - off;
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : icmp6len = %d\n", funcname, icmp6len);
	if (icmp6len < sizeof(struct icmp6_hdr)) {
		/* packet is too short */
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : packet too short\n", funcname);
		goto discard;
	}

	icmp6 = (struct icmp6_hdr *)((CADDR_T)ip6 + off);
	type = icmp6->icmp6_type;
	code = icmp6->icmp6_code;

	cksum = tiny_in6_cksum(tbuf, IPPROTO_ICMPV6, off, icmp6len);
	if (cksum != 0) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : checksum error, "
					 "(type =%d, code = %d)\n", funcname, type, code);
		goto discard;
	}

	switch (type) {
	case ICMP6_DST_UNREACH:
		switch (code) {
		case ICMP6_DST_UNREACH_NOPORT:
			/* XXX */
			break;
		case ICMP6_DST_UNREACH_NOROUTE:
		case ICMP6_DST_UNREACH_ADMIN:
		case ICMP6_DST_UNREACH_ADDR:
			goto unsupported;
		default:
			goto badcode;
		}
		goto deliver;
		break;
	case ICMP6_PACKET_TOO_BIG:
		if (code != 0)
			goto badcode;
		goto unsupported;
		break;
	case ICMP6_TIME_EXCEEDED:
		switch (code) {
		case ICMP6_TIME_EXCEED_TRANSIT:
		case ICMP6_TIME_EXCEED_REASSEMBLY:
			/* XXX */
			break;
		default:
			goto badcode;
		}
		goto deliver;
		break;
	case ICMP6_PARAM_PROB:
		switch (code) {
		case ICMP6_PARAMPROB_NEXTHEADER:
		case ICMP6_PARAMPROB_HEADER:
		case ICMP6_PARAMPROB_OPTION:
			/* XXX */
			break;
		default:
			goto badcode;
		}
		goto deliver;
		break;
	case ICMP6_ECHO_REQUEST:
		if (code != 0)
			goto badcode;
		tiny_icmp6_echo_reply(tbuf, off);
		break;
	case ICMP6_ECHO_REPLY:
		if (code != 0)
			goto badcode;
		goto deliver;
		break;
	case ND_ROUTER_SOLICIT:
		goto unsupported;
		break;
	case ND_ROUTER_ADVERT:
		if (code != 0)
			goto badcode;
		if (icmp6len < sizeof(struct nd_router_advert))
			goto badlen;
		ntbuf = tinybuf_alloc();
		if (ntbuf == NULL) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
						 funcname);
			goto discard;
		}
		tinybuf_copy(tbuf, ntbuf);
		tiny_nd6_ra_input(ntbuf, off, icmp6len);
		break;
	case ND_NEIGHBOR_SOLICIT:
		if (code != 0)
			goto badcode;
		if (icmp6len < sizeof(struct nd_neighbor_solicit))
			goto badlen;
		ntbuf = tinybuf_alloc();
		if (ntbuf == NULL) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
						 funcname);
			goto discard;
		}
		tinybuf_copy(tbuf, ntbuf);
		tiny_nd6_ns_input(ntbuf, off, icmp6len);
		break;
	case ND_NEIGHBOR_ADVERT:
		if (code != 0)
			goto badcode;
		if (icmp6len < sizeof(struct nd_neighbor_advert))
			goto badlen;
		ntbuf = tinybuf_alloc();
		if (ntbuf == NULL) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
						 funcname);
			goto discard;
		}
		tinybuf_copy(tbuf, ntbuf);
		tiny_nd6_na_input(ntbuf, off, icmp6len);
		break;
	case ND_REDIRECT:
		goto unsupported;
		break;
	default:
		if (icmp6->icmp6_type < ICMP6_ECHO_REQUEST) {
			/* ICMPv6 error messages */
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : unknown ICMPv6 error message "
						 "(type = %d, code = %d)\n", funcname, type, code);
			goto deliver;
		}
		else {
			/* ICMPv6 informational messages */
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : unknown ICMPv6 informational "
						 "message (type = %d, code = %d)\n", funcname,
						 type, code);
			goto discard;
		}
		break;
	deliver:
		/* XXX : deliver to upper protocol */
		
		break;

	unsupported:
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : unsupported icmp "
					 "(type = %d, code = %d)\n", funcname, type, code);
		break;
	badcode:
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : bad code (type = %d, code = %d)\n",
					 funcname, type, code);
		break;
	badlen:
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : packet too short "
					 "(type = %d, code = %d, len = %d)\n", funcname,
					 type, code, icmp6len);
		break;
	}

	tiny_icmp6_rawip6_input(&tbuf, off);
	return IPPROTO_DONE;

 discard:
	tinybuf_free(tbuf);
 end:
	return IPPROTO_DONE;
}


static int
tiny_icmp6_rawip6_input(tinybuf **tbufp, int off)
{
	/* XXX */
	tinybuf *tbuf = *tbufp;
	if (tbuf != NULL) {
		tinybuf_free(tbuf);
	}
	return IPPROTO_DONE;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
