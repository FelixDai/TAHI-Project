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

/*	$Id: tiny_ip6_input.c,v 1.1 2002/05/29 13:31:03 fujita Exp $	*/


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_icmp6.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/tiny_ip6_input.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/tiny_raw_ip6.h>
#include <tinyipv6/tiny_ipsec.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_esp.h>
#include <tinyipv6/sysdep_l4.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_utils.h>


void
tiny_ip6_input(tinybuf *tbuf)
{
	TINY_FUNC_NAME(tiny_ip6_input);
	struct ip6_hdr *ip6;
	TinyNetif netif;
	U_INT32_T plen;
	int off;
	int nxt;
	TinyBool bad_netif = TinyFalse;
	int err_type;
	int err_code;
	int err_param;
	TinyBool rv;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : tbuf->len = %d\n", funcname, tbuf->len);

	netif = tbuf->netif;
	if (tiny_netif_equal(netif, tiny_loopback_netif) == TinyTrue) {
		/* from loopback */;
	}
	else if (tiny_netif_equal(netif, tiny_physical_netif) == TinyTrue) {
		/* from physical interface */;
	}
	else {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : not from supported interface (%s), "
					 "discard packet\n", funcname, netif);
		goto discard;
	}

	if (tbuf->len < sizeof(struct ip6_hdr)) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : packet too short, len = %d, "
					 "discard\n", funcname, tbuf->len);
		goto discard;
	}

	ip6 = (struct ip6_hdr *)tbuf->pkt;

	/*
	 * IPv6 header check
	 */
	/* IP version check */
	if ((ip6->ip6_vfc & IPV6_VERSION_MASK) != IPV6_VERSION) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : invalid ip version, discard\n",
					 funcname);
		goto discard;
	}

	/* discard packet with illegal src/dst address */
	if (IN6_IS_ADDR_MULTICAST(&ip6->ip6_src)
		|| IN6_IS_ADDR_UNSPECIFIED(&ip6->ip6_dst)) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : invalid src(%s) or dst(%s) address,"
					 " discard\n", funcname,
					 tiny_ip6_sprintf(&ip6->ip6_src),
					 tiny_ip6_sprintf(&ip6->ip6_dst));
		goto discard;
	}
	if (IN6_IS_ADDR_LOOPBACK(&ip6->ip6_src)
		|| IN6_IS_ADDR_LOOPBACK(&ip6->ip6_dst)) {
		if (tiny_netif_is_loopback(netif)) {
			goto ours;
		}
		else {
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : src or dst address is loopback,"
						 " but receive from non-loopback interface, discard\n",
						 funcname);
			goto discard;
		}
	}
	/* multicast check */
	if (IN6_IS_ADDR_MULTICAST(&ip6->ip6_dst)) {
		/* XXX */
		if (tiny_netif_is_addr_my_multicast(netif, &ip6->ip6_dst)
			== TinyTrue) {
			goto ours;
		}
		else {
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : multicast packet, "
						 "but not for me (%s)\n",
						 funcname, tiny_ip6_sprintf(&ip6->ip6_dst));
			goto discard;
		}
	}
	/* unicast check */
	else if (tiny_netif_is_addr_my_unicast(netif, &ip6->ip6_dst)
			 == TinyTrue) {
		bad_netif = tiny_netif_is_addr_tentative(netif, &ip6->ip6_dst);
		bad_netif |= tiny_netif_is_addr_duplicated(netif, &ip6->ip6_dst);
		goto ours;
	}
	else {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : unicast packet, "
					 "but not for me (%s), discard\n",
					 funcname, tiny_ip6_sprintf(&ip6->ip6_dst));
		goto discard;
	}
	
 ours:

	plen = (U_INT32_T)ntohs(ip6->ip6_plen);
	off = sizeof(struct ip6_hdr);

#define TINY_IS_VALID_HEADER(hdr)		\
	((hdr == IPPROTO_TCP) || (hdr == IPPROTO_UDP) || (hdr == IPPROTO_RAW) \
	|| (hdr == IPPROTO_ICMPV6) || (hdr == IPPROTO_HOPOPTS) \
	|| (hdr == IPPROTO_DSTOPTS) || (hdr == IPPROTO_ROUTING) \
	|| (hdr == IPPROTO_FRAGMENT) || (hdr == IPPROTO_NONE) \
	|| (hdr == IPPROTO_ESP) || (hdr == IPPROTO_AH))

	nxt = ip6->ip6_nxt & 0xff;
	if (! TINY_IS_VALID_HEADER(nxt)) {
		err_type = ICMP6_PARAM_PROB;
		err_code = ICMP6_PARAMPROB_NEXTHEADER;
		err_param = (int)(&ip6->ip6_nxt) - (int)ip6;
		goto error;
	}

	/* packet length check */
	if (tbuf->len - sizeof(struct ip6_hdr) < plen) {
		/* too short */
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : packet too short must be %d, "
					 "actual %d, discard\n", funcname,
					 sizeof(struct ip6_hdr) + plen, tbuf->len);
		goto discard;
	}
	else if (tbuf->len - sizeof(struct ip6_hdr) > plen) {
		TINY_LOG_MSG(TINY_LOG_INFO, "%s : packet too large, must be %d, "
					 "actual %d, shorten it\n",	funcname,
					 sizeof(struct ip6_hdr) + plen, tbuf->len);
		tbuf->len = sizeof(struct ip6_hdr) + plen;
	}

 exthdr:

	/*
	 * extension header (or upper layer header)
	 *		we don't care header order
	 */
	while (1) {

		if (off > tbuf->len) {
			err_type = ICMP6_PARAM_PROB;
			err_code = ICMP6_PARAMPROB_OPTION;	/* XXX */
			err_param = off;
			goto error;
		}

		switch (nxt) {
			struct ip6_hbh *hbh;
			struct ip6_dest *dest;
			int optlen;
			U_INT8_T opt_err_act;
			U_INT8_T *optp;
		case IPPROTO_TCP:
		case IPPROTO_UDP:
		case IPPROTO_RAW:	/* XXX : ??? */
		case IPPROTO_ICMPV6:
			goto upper;
			break;
		case IPPROTO_HOPOPTS:
			hbh = (struct ip6_hbh *) ((CADDR_T)ip6 + off);
			nxt = hbh->ip6h_nxt;
			if (! TINY_IS_VALID_HEADER(nxt)) {
				err_type = ICMP6_PARAM_PROB;
				err_code = ICMP6_PARAMPROB_NEXTHEADER;
				err_param = off;
				goto error;
			}
			optlen = ((hbh->ip6h_len + 1) << 3) - sizeof(struct ip6_hbh);
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : found HopHdr, optlen = %d\n",
						 funcname, optlen);
			optp = (U_INT8_T *)hbh + sizeof(struct ip6_hbh);
			off += sizeof(struct ip6_hbh);
			while (optlen > 0) {
				switch (*optp) {
				case IP6OPT_PAD1:
					off ++;
					optlen --;
					optp ++;
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : found Pad1\n",
								 funcname);
					break;
				case IP6OPT_PADN:
					if (optlen < IP6OPT_MINLEN) {
						TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : opt too short, "
									 "len = %d\n", funcname, optlen);
						goto discard;
					}
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : found PadN, N = %d\n",
								 funcname, *(optp + 1));
					off += (*(optp + 1) + 2);
					optlen -= (*(optp + 1) + 2);
					optp += (*(optp + 1) + 2);
					break;
				case IP6OPT_RTALERT:
				case IP6OPT_JUMBO:
					/* not supported, fall down */
				default:
					/* unrecognized */
					opt_err_act = ((*optp) & 0xc0) >> 6;
					switch (opt_err_act) {
					case 0:
						off ++;
						optlen --;
						optp ++;
						TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : unknown opt, "
									 "0x%02x, skip it\n", funcname, *optp);
						break;
					case 1:
						TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : unknown opt, "
									 "0x%02x, discard it\n", funcname, *optp);
						goto discard;
						break;
					case 2:
						err_type = ICMP6_PARAM_PROB;
						err_code = ICMP6_PARAMPROB_OPTION;
						err_param = off;
						TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : unknown opt, "
									 "0x%02x, report it\n", funcname, *optp);
						goto error;
						break;
					case 3:
						if (IN6_IS_ADDR_MULTICAST(&ip6->ip6_dst)) {
							TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : unknown opt, "
										 "0x%02x, discard it\n",
										 funcname, *optp);
							goto discard;
						}
						else {
							err_type = ICMP6_PARAM_PROB;
							err_code = ICMP6_PARAMPROB_OPTION;
							err_param = off;
							TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : unknown opt, "
										 "0x%02x, report it\n",
										 funcname, *optp);
							goto error;
						}
						break;
					}
					break;
				}
			}
			goto exthdr;
			break;
		case IPPROTO_DSTOPTS:
			dest = (struct ip6_dest *)((CADDR_T)ip6 + off);
			nxt = dest->ip6d_nxt;
			if (! TINY_IS_VALID_HEADER(nxt)) {
				err_type = ICMP6_PARAM_PROB;
				err_code = ICMP6_PARAMPROB_NEXTHEADER;
				err_param = off;
				goto error;
			}
			optlen = ((dest->ip6d_len + 1) << 3) - sizeof(struct ip6_dest);
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : found DstHdr, len = %d\n",
						 funcname, optlen);
			optp = (U_INT8_T *)dest + sizeof(struct ip6_dest);
			off += sizeof(struct ip6_dest);
			while (optlen > 0) {
				switch (*optp) {
				case IP6OPT_PAD1:
					off ++;
					optlen --;
					optp ++;
					break;
				case IP6OPT_PADN:
					if (optlen < IP6OPT_MINLEN) {
						goto discard;
					}
					off += (*(optp + 1) + 2);
					optlen -= (*(optp + 1) + 2);
					optp += (*(optp + 1) + 2);
					break;
				default:
					/* unrecognized */
					opt_err_act = ((*optp) & 0xc0) >> 6;
					switch (opt_err_act) {
					case 0:
						off ++;
						optlen --;
						optp ++;
						break;
					case 1:
						goto discard;
						break;
					case 2:
						err_type = ICMP6_PARAM_PROB;
						err_code = ICMP6_PARAMPROB_OPTION;
						err_param = off;
						goto error;
						break;
					case 3:
						if (IN6_IS_ADDR_MULTICAST(&ip6->ip6_dst)) {
							goto discard;
						}
						else {
							err_type = ICMP6_PARAM_PROB;
							err_code = ICMP6_PARAMPROB_OPTION;
							err_param = off;
							goto error;
						}
						break;
					}
					break;
				}
			}
			goto exthdr;
			break;
		case IPPROTO_ROUTING:
		case IPPROTO_FRAGMENT:
		case IPPROTO_AH:
			err_type = ICMP6_PARAM_PROB;
			err_code = ICMP6_PARAMPROB_NEXTHEADER;
			err_param = off;
			goto error;
			break;
		case IPPROTO_NONE:
			/* no next header */
			return;
			break;
		case IPPROTO_ESP:
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ESP header found, tbuf->len = "
						 "%d\n", funcname, tbuf->len);
			tiny_esp_input(&tbuf, &off);
			if (tbuf == NULL) {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : tiny_esp_input() "
							 "returns with tbuf == NULL\n", funcname);
				return;
			}
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : tiny_esp_input() "
						 "returns with off = %d, tbuf->len = %d\n",
						 funcname, off, tbuf->len);
			ip6 = (struct ip6_hdr *)tbuf->pkt;
			nxt = ip6->ip6_nxt;
			break;
		default:
			/* XXX */
			err_type = ICMP6_PARAM_PROB;
			err_code = ICMP6_PARAMPROB_NEXTHEADER;
			err_param = off;
			goto error;
			break;
		}
	}
#undef TINY_IS_VALID_HEADER

 upper:
	/* to upper layer protocol */
	if ((bad_netif == TinyTrue) && (nxt != IPPROTO_ICMPV6)) {
		goto discard;
	}

	/* IPsec policy check */
	rv = tiny_ipsec_inbound_policy_check(&tbuf, off, nxt);
	if (rv == TinyFalse) {
		/* IPsec policy DISCARD */
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : packet discard according to "
					 "ipsec inbound policy\n", funcname);
		goto discard;
	}
	else {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ipsec inbound check ok\n",
					 funcname);
	}

	switch (nxt) {
	case IPPROTO_TCP:
		tiny_tcp_input(&tbuf, &off);
		break;
	case IPPROTO_UDP:
		tiny_udp_input(&tbuf, &off);
		break;
	case IPPROTO_RAW:	/* XXX : ??? */
		tiny_rip6_input(&tbuf, &off);
		break;
	case IPPROTO_ICMPV6:
		tiny_icmp6_input(&tbuf, &off);
		break;
	default:
		err_type = ICMP6_PARAM_PROB;
		err_code = ICMP6_PARAMPROB_NEXTHEADER;
		err_param = off;
		goto error;
		break;
	}

	return;

 error:
	tiny_icmp6_error(tbuf, err_type, err_code, err_param);

 discard:
	if (tbuf != NULL) {
		tinybuf_free(tbuf);
	}
	return;
}


char *
tiny_ip6_get_prevhdr(tinybuf *tbuf, int off)
{
	struct ip6_hdr *ip6 = (struct ip6_hdr *)tbuf->pkt;

	if (off == sizeof(struct ip6_hdr)) {
		return (&ip6->ip6_nxt);
	}
	else {
		int len;
		int nxt;
		struct ip6_ext *ip6e = NULL;

		nxt = ip6->ip6_nxt;
		len = sizeof(struct ip6_hdr);
		while (len < off) {
			ip6e = (struct ip6_ext *)((CADDR_T)tbuf->pkt + len);

			switch(nxt) {
			case IPPROTO_FRAGMENT:
				len += sizeof(struct ip6_frag);
				break;
			case IPPROTO_AH:
				len += (ip6e->ip6e_len + 2) << 2;
				break;
			default:
				len += (ip6e->ip6e_len + 1) << 3;
				break;
			}
			nxt = ip6e->ip6e_nxt;
		}
		if (ip6e) {
			return(&ip6e->ip6e_nxt);
		}
		else {
			return NULL;
		}
	}
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
