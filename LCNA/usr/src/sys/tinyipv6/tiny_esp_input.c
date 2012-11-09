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

/*	$Id: tiny_esp_input.c,v 1.1 2002/05/29 13:30:54 fujita Exp $	*/
/*	$NetBSD: esp_input.c,v 1.1.1.1.2.7 2001/04/06 00:27:26 he Exp $	*/
/*	$KAME: esp_input.c,v 1.33 2000/09/12 08:51:49 itojun Exp $	*/

/*
 * Copyright (C) 1995, 1996, 1997, and 1998 WIDE Project.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the project nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_esp.h>
#include <tinyipv6/tiny_auth.h>
#include <tinyipv6/tiny_ip6_input.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_utils.h>


TinyBool tiny_esp_inspect_padding = TinyTrue;


/*
 * RFC2406 Encapsulated Security Payload.
 */


int
tiny_esp_input(tinybuf **tbufp, int *offp)
{
	TINY_FUNC_NAME(tiny_esp_input);
	tinybuf *tbuf = *tbufp;
	int off = *offp;
	struct ip6_hdr *ip6;
	struct esp *esp;
	struct esptail esptail;
	U_INT32_T spi;
	struct tiny_ipsec_db *db;
	struct tiny_ipsec_db_searchkey key;
	SIZE_T taillen;
	U_INT16_T nxt;
	const struct tiny_esp_algorithm *algo;
	int ivlen;
	SIZE_T esplen;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : tbuf->len = %d, off = %d\n",
				 funcname, tbuf->len, off);

	/* sanity check for alignment. */
	if (off % 4 != 0 || tbuf->len % 4 != 0) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : packet alignment problem "
					 "(off=%d, pktlen=%d)\n", funcname, off, tbuf->len);
		goto bad;
	}

	ip6 = (struct ip6_hdr *)tbuf->pkt;

	if (tbuf->len < off) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : offet overruns buffer length "
					 "buflen=%d, offset=%d\n", funcname, tbuf->len, off);
		goto bad;
	}

	esp = (struct esp *)((char *)ip6 + off);

	if (ntohs(ip6->ip6_plen) == 0) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : ESP with IPv6 jumbogram "
					 "is not supported.\n", funcname);
		goto bad;
	}

	/* find the security association. */
	spi = (U_INT32_T)ntohl(esp->esp_spi);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : spi = %d\n", funcname, spi);

	TINY_BZERO(&key, sizeof(key));
	key.spi = spi;
	key.spi_valid =	TINY_IPSEC_PARAM_SPI_VALID;
	key.mask = TINY_IPSEC_QUERY_MASK_SPI;

	if (tiny_ipsec_db_search(&key, &db) == 0) {
		TINY_LOG_MSG(TINY_LOG_WARNING, "%s : no key association found "
					 "for spi %u\n", funcname, spi);
		goto bad;
	}
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : SA found for spi %u\n", funcname, spi);

	algo = tiny_esp_algorithm_lookup(db->esp_alg);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ESP_ALGO = %d\n",
				 funcname, db->esp_alg);
	if (algo == NULL) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : unsupported encryption "
					 "algorithm for spi %u\n", funcname, spi);
		goto bad;
	}
	else {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ESP_ALGO = %s for spi %u\n",
					 funcname, algo->name, spi);
	}

	/* check if we have proper ivlen information */
	/* XXX */
	ivlen = (*algo->ivlen)(algo, db);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ivlen = %d\n", funcname, ivlen);
	if (ivlen < 0) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : inproper ivlen\n", funcname);
		goto bad;
	}

	if (db->esp_auth_alg == TINY_IPSEC_PARAM_ESP_AUTH_ALG_NONE) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : skip replay check\n", funcname);
		goto noreplaycheck;
	}

	/*
	 * check for sequence number.
	 */
	if ((db->seq != 0) && (ntohl(esp->esp_seq) <= db->seq)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : sequence error esp->esp_seq(%d) "
					 "<= db->seq(%d)\n", funcname, ntohl(esp->esp_seq),
					 db->seq);
		goto bad;
	}

	/* check ICV */
    {
		U_CHAR sum0[AUTH_MAXSUMSIZE];
		U_CHAR sum[AUTH_MAXSUMSIZE];
		const struct tiny_auth_algorithm *sumalgo;
		SIZE_T siz;

		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ESP_AUTH_ALGO = %d\n",
					 funcname, db->esp_auth_alg);
		sumalgo = tiny_auth_algorithm_lookup(db->esp_auth_alg);
		if (sumalgo == NULL) {
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : sumalgo is NULL, "
						 "skip replay check\n", funcname);
			goto noreplaycheck;
		}
		siz = ((sumalgo->sumsiz + 3) & ~(4 - 1));
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : sum size = %d\n", funcname, siz);
		if (AUTH_MAXSUMSIZE < siz) {
			TINY_LOG_MSG(TINY_LOG_DEBUG,
						 "%s : AH_MAXSUMSIZE must be larger than %lu\n",
						 funcname, (U_LONG)siz);
			goto bad;
		}

		TINY_BCOPY(tbuf->pkt + (tbuf->len - siz), sum0, siz);

		if (tiny_esp_auth(tbuf, off, tbuf->len - off - siz, db, sum)) {
			TINY_LOG_MSG(TINY_LOG_WARNING, "%s : auth fail, "
						 "can't calc checksum\n", funcname);
			goto bad;
		}

		if (TINY_BCMP(sum0, sum, siz) != 0) {
			TINY_LOG_MSG(TINY_LOG_WARNING, "%s : checksum mismatch\n",
						 funcname);
			goto bad;
		}

		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ICV OK\n", funcname);
		tbuf->auth_flag = 1;

		/* strip off the authentication data */
		tbuf->len -= siz;
		ip6 = (struct ip6_hdr *)tbuf->pkt;
		ip6->ip6_plen = htons(ntohs(ip6->ip6_plen) - siz);

		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : AUTH DONE, tbuf->len = %d\n",
					 funcname, tbuf->len);
    }

 noreplaycheck:

	db->seq = ntohl(esp->esp_seq);

	esplen = sizeof(struct esp);

	if (tbuf->len < off + esplen + ivlen + sizeof(esptail)) {
		TINY_LOG_MSG(TINY_LOG_WARNING, "%s : packet too short\n", funcname);
		goto bad;
	}

	ip6 = (struct ip6_hdr *)tbuf->pkt;	/*set it again just in case*/

	/*
	 * pre-compute and cache intermediate key
	 */
	if (tiny_esp_schedule(algo, db) != 0) {
		goto bad;
	}

	/*
	 * decrypt the packet.
	 */
	if (algo->decrypt == NULL) {
		TINY_FATAL_ERROR("internal error: no decrypt function");
	}
	if ((*algo->decrypt)(tbuf, off, db, algo, ivlen)) {
		/* tbuf is already freed */
		tbuf = NULL;
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : decrypt failed\n", funcname);
		goto bad;
	}

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : decrypt succeed\n", funcname);
	tbuf->crypt_flag = 1;

	/*
	 * find the trailer of the ESP.
	 */
	TINY_BCOPY((CADDR_T)tbuf->pkt + tbuf->len - sizeof(esptail),
			   &esptail, sizeof(esptail));
	nxt = esptail.esp_nxt;
	taillen = esptail.esp_padlen + sizeof(esptail);
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ESP taillen = %d\n", funcname, taillen);

	if (tbuf->len < taillen
		|| tbuf->len - taillen < sizeof(struct ip6_hdr)) {
		TINY_LOG_MSG(TINY_LOG_WARNING,
					 "%s : bad pad length, bad packet length\n", funcname);
		goto bad;
	}

	if ((tiny_esp_inspect_padding == TinyTrue)
		&& (algo->checkpadding != NULL)) {
		/* check padding area */
		if ((*algo->checkpadding)((U_CHAR *)tbuf->pkt + (tbuf->len - taillen),
								  esptail.esp_padlen) == TinyFalse) {
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : bad padding content, discard\n",
						 funcname);
			goto bad;
		}
	}

	/* strip off the trailing pad area. */
	tbuf->len -= taillen;

	ip6->ip6_plen = htons(ntohs(ip6->ip6_plen) - taillen);

	{
		/*
		 * strip off ESP header and IV.
		 */
		size_t stripsiz;
		char *prvnxtp;
		tinybuf *work;

		work = tinybuf_alloc();
		if (work == NULL) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
						 funcname);
			goto bad;
		}
		tinybuf_copy(tbuf, work);

		/*
		 * Set the next header field of the previous header correctly.
		 */
		prvnxtp = tiny_ip6_get_prevhdr(tbuf, off);
		*prvnxtp = nxt;

		stripsiz = esplen + ivlen;

		ip6 = (struct ip6_hdr *)tbuf->pkt;
		TINY_BCOPY((CADDR_T)work->pkt + off + stripsiz,
				   (CADDR_T)tbuf->pkt + off,
				   tbuf->len - off - stripsiz);
		ip6->ip6_plen = htons(ntohs(ip6->ip6_plen) - stripsiz);
		ip6->ip6_nxt = nxt;
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ESP header strip size = %d\n",
					 funcname, stripsiz);
		tbuf->len -= stripsiz;
		tinybuf_free(work);
	}

	tbuf->crypt_flag = 1;

	*offp = off;
	*tbufp = tbuf;

	return IPPROTO_DONE;

 bad:
	if (*tbufp != NULL) {
		tinybuf_free(*tbufp);
	}
	*tbufp = NULL;
	return IPPROTO_DONE;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
