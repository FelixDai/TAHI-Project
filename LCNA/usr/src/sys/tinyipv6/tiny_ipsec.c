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

/*	$Id: tiny_ipsec.c,v 1.1 2002/05/29 13:31:06 fujita Exp $	*/


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_esp.h>
#include <tinyipv6/tiny_ipsec.h>
#include <tinyipv6/sysdep_utils.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>


int tiny_ipsec_dafault_policy
#if 1
	= TINY_IPSEC_PARAM_POLICY_PASS;
#else
	= TINY_IPSEC_PARAM_POLICY_DISCARD;
/*
  NOTICE:
  if default policy is 'DISCARD',
  it may be discarded necessary packet such as router advertisement.
*/
#endif


TinyBool
tiny_ipsec_inbound_policy_check(tinybuf **tbufp, int off, int proto)
{
	TINY_FUNC_NAME(tiny_ipsec_inbound_policy_check);
	tinybuf *tbuf = *tbufp;
	struct ip6_hdr *ip6;
	struct tcphdr *tcp;
	struct udphdr *udp;
	struct tiny_ipsec_db *db = NULL;
	struct tiny_ipsec_db_searchkey key;
	TinyBool rv = TinyTrue;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : inbound check with proto %d\n",
				 funcname, proto);

	if (tiny_ipsec_init_done == TinyFalse) {
		/* IPsec information does not exist, do nothing */
		rv = TinyTrue;
		goto end;
	}

	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : tbuf == NULL\n", funcname);
		rv = TinyFalse;
		goto end;
	}

	ip6 = (struct ip6_hdr *) tbuf->pkt;

	TINY_BZERO(&key, sizeof(key));

	key.dir = TINY_IPSEC_QUERY_DIR_IN;

	key.r_peeraddr = ip6->ip6_src;
	key.mask |= TINY_IPSEC_QUERY_MASK_R_IPADR;

	if (IN6_IS_ADDR_LINKLOCAL(&ip6->ip6_dst)) {
		key.r_myself = TINY_IPSEC_PARAM_MYSELF_LINKLOCAL;
	}
	else if (IN6_IS_ADDR_SITELOCAL(&ip6->ip6_dst)) {
		key.r_myself = TINY_IPSEC_PARAM_MYSELF_SITELOCAL;
	}
	else {
		key.r_myself = TINY_IPSEC_PARAM_MYSELF_GLOBAL;
	}
	key.mask |= TINY_IPSEC_QUERY_MASK_R_MYSELF;

	switch (proto) {
	case IPPROTO_TCP:
		key.proto = TINY_IPSEC_PARAM_PROTO_TCP;
		tcp = (struct tcphdr *)((CADDR_T)ip6 + off);
		key.r_sport = ntohs(tcp->th_sport);
		key.r_dport = ntohs(tcp->th_dport);
		break;
	case IPPROTO_UDP:
		key.proto = TINY_IPSEC_PARAM_PROTO_UDP;
		udp = (struct udphdr *)((CADDR_T)ip6 + off);
		key.r_sport = ntohs(udp->uh_sport);
		key.r_dport = ntohs(udp->uh_dport);
		break;
	default:
		key.proto = TINY_IPSEC_PARAM_PROTO_ANY;
		break;
	}
	key.mask |= TINY_IPSEC_QUERY_MASK_PROTO;

	rv = tiny_ipsec_db_search(&key, &db);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ipsec db search returns with %s\n",
				 funcname, (rv == TinyTrue) ? "TRUE" : "FALSE");

	if (db != NULL) {
		rv = TinyTrue;
		switch (db->inpolicy) {
		case TINY_IPSEC_PARAM_POLICY_PASS:
			/* okey, do nothing */
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : IPsec policy PASS\n", funcname);
			break;
		case TINY_IPSEC_PARAM_POLICY_DISCARD:
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : found IPsec policy DISCARD\n",
						 funcname);
			rv = TinyFalse;
			goto end;
			break;
		case TINY_IPSEC_PARAM_POLICY_ESP_AUTH:
			if (tbuf->auth_flag == TinyFalse) {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : needs IPsec\n", funcname);
				rv = TinyFalse;
				goto end;
			}
			/* not break, fall through */
		case TINY_IPSEC_PARAM_POLICY_ESP:
			if (tbuf->crypt_flag == TinyFalse) {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : needs IPsec\n", funcname);
				rv = TinyFalse;
				goto end;
			}
			break;
		default:
			TINY_FATAL_ERROR("implementation error, unknown IPsec policy\n");
			break;
		}
	}
	else {
		/* use default policy */
		if (tiny_ipsec_dafault_policy == TINY_IPSEC_PARAM_POLICY_DISCARD) {
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : use default policy DISCARD\n",
						 funcname);
			rv = TinyFalse;
		}
		else {
			rv = TinyTrue;
		}
	}
 end:
	return rv;
}


TinyBool
tiny_ipsec_outbound_policy_check(tinybuf **tbufp, int off, int proto)
{
	TINY_FUNC_NAME(tiny_ipsec_outbound_policy_check);
	tinybuf *tbuf = *tbufp;
	struct ip6_hdr *ip6;
	struct tcphdr *tcp;
	struct udphdr *udp;
	struct tiny_ipsec_db *db = NULL;
	struct tiny_ipsec_db_searchkey key;
	TinyBool rv = TinyTrue;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : outbound check with proto %d\n",
				 funcname, proto);

	if (tiny_ipsec_init_done == TinyFalse) {
		/* IPsec information does not exist, do nothing */
		rv = TinyTrue;
		goto end;
	}

	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : tbuf == NULL\n", funcname);
		rv = TinyFalse;
		goto end;
	}

	ip6 = (struct ip6_hdr *) tbuf->pkt;

	TINY_BZERO(&key, sizeof(key));

	key.dir = TINY_IPSEC_QUERY_DIR_OUT;

	key.s_peeraddr = ip6->ip6_dst;
	key.mask |= TINY_IPSEC_QUERY_MASK_S_IPADR;

	if (IN6_IS_ADDR_LINKLOCAL(&ip6->ip6_src)) {
		key.s_myself = TINY_IPSEC_PARAM_MYSELF_LINKLOCAL;
	}
	else if (IN6_IS_ADDR_SITELOCAL(&ip6->ip6_src)) {
		key.s_myself = TINY_IPSEC_PARAM_MYSELF_SITELOCAL;
	}
	else {
		key.s_myself = TINY_IPSEC_PARAM_MYSELF_GLOBAL;
	}
	key.mask |= TINY_IPSEC_QUERY_MASK_S_MYSELF;

	switch (proto) {
	case IPPROTO_TCP:
		key.proto = TINY_IPSEC_PARAM_PROTO_TCP;
		tcp = (struct tcphdr *)((CADDR_T)ip6 + off);
		key.s_sport = ntohs(tcp->th_sport);
		key.s_dport = ntohs(tcp->th_dport);
		break;
	case IPPROTO_UDP:
		key.proto = TINY_IPSEC_PARAM_PROTO_UDP;
		udp = (struct udphdr *)((CADDR_T)ip6 + off);
		key.s_sport = ntohs(udp->uh_sport);
		key.s_dport = ntohs(udp->uh_dport);
		break;
	default:
		key.proto = TINY_IPSEC_PARAM_PROTO_ANY;
		break;
	}
	key.mask |= TINY_IPSEC_QUERY_MASK_PROTO;

	rv = tiny_ipsec_db_search(&key, &db);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ipsec db search returns with %s\n",
				 funcname, (rv == TinyTrue) ? "TRUE" : "FALSE");

	if (db != NULL) {
		int err = 0;
		rv = TinyTrue;
		switch (db->outpolicy) {
		case TINY_IPSEC_PARAM_POLICY_PASS:
			/* okey, do nothing */
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : IPsec policy PASS\n", funcname);
			break;
		case TINY_IPSEC_PARAM_POLICY_DISCARD:
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : IPsec policy DISCARD\n",
						 funcname);
			rv = TinyFalse;
			goto end;
			break;
		case TINY_IPSEC_PARAM_POLICY_ESP:
		case TINY_IPSEC_PARAM_POLICY_ESP_AUTH:
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : needs IPsec, insert ESP\n",
						 funcname);
			err = tiny_esp_output(tbuf, db);
			if (err != 0) {
				TINY_LOG_MSG(TINY_LOG_ERR, "%s : tiny_esp_output returns %d\n",
							 funcname, err);
				rv = TinyFalse;
				goto end;
			}
			else {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ESP insert succeed\n",
							 funcname);
			}
			break;
		default:
			TINY_FATAL_ERROR("implementation error, unknown IPsec policy\n");
			break;
		}
	}
	else {
		/* use default policy */
		if (tiny_ipsec_dafault_policy == TINY_IPSEC_PARAM_POLICY_DISCARD) {
			TINY_LOG_MSG(TINY_LOG_INFO, "%s : use default policy DISCARD\n",
						 funcname);
			rv = TinyFalse;
		}
		else {
			rv = TinyTrue;
		}
	}
 end:
	return rv;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
