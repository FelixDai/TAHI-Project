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

/*	$Id: tiny_esp_output.c,v 1.1 2002/05/29 13:30:55 fujita Exp $	*/
/*	$NetBSD: esp_output.c,v 1.1.1.1.2.6 2000/10/05 14:51:57 itojun Exp $	*/
/*	$KAME: esp_output.c,v 1.35 2000/10/05 03:25:23 itojun Exp $	*/

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
#include <tinyipv6/sysdep_utils.h>
#include <tinyipv6/tiny_utils.h>


/*
 * RFC2406 Encapsulated Security Payload.
 */

/*
 * Modify the packet so that the payload is encrypted.
 * On failure, free the given buffer and return NULL.
 *
 * on invocation:
 *		m   nexthdrp md
 *		v   v        v
 *	IP ......... payload
 * during the encryption:
 *		m   nexthdrp mprev md
 *		v   v        v     v
 *		IP ............... esp iv payload pad padlen nxthdr
 *	    	               <--><-><------><--------------->
 *		                   esplen plen    extendsiz
 *		                       ivlen
 *	                   <-----> esphlen
 *		<-> hlen
 *		<-----------------> espoff
 */
int
tiny_esp_output(tinybuf *tbuf, struct tiny_ipsec_db *db)
{
	TINY_FUNC_NAME(tiny_esp_output);
	U_INT32_T spi;
	SIZE_T espoff;
	int ivlen;
	SIZE_T plen;
	SIZE_T extendsiz;
	const struct tiny_esp_algorithm *algo;
	int error;
	U_INT8_T nxt;

	if (tbuf->len < sizeof(struct ip6_hdr)) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : buffer too short\n", funcname);
		tinybuf_free(tbuf);
		return 0;
	}

	if (db == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : db is NULL\n", funcname);
		tinybuf_free(tbuf);
		return EINVAL;
	}

	algo = tiny_esp_algorithm_lookup(db->esp_alg);
	if (algo == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : unsupported algorithm: SPI=%u\n",
					 funcname, (U_INT32_T)db->spi);
		tinybuf_free(tbuf);
		return EINVAL;
	}

	spi = htonl(db->spi);
	ivlen = (*algo->ivlen)(algo, db);
	/* should be okey */
	if (ivlen < 0) {
		TINY_FATAL_ERROR("invalid ivlen");
	}
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : ivlen = %d\n", funcname, ivlen);

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : before esp_output, tbuf->len = %d\n",
				 funcname, tbuf->len);

    {
		/*
		 * insert ESP header.
		 */
		struct ip6_hdr *ip6;
		struct esp *esp;
		U_CHAR *ivp;
		tinybuf *work;
		SIZE_T esplen;		/* sizeof(struct esp) */
		SIZE_T esphlen;		/* sizeof(struct esp) + ivlen*/
		SIZE_T hlen;		/* ip header len */

		esplen = sizeof(struct esp);
		esphlen = esplen + ivlen;
		hlen = sizeof(struct ip6_hdr);

		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : esphlen = %d\n", funcname, esphlen);

		if (tbuf->len + esphlen > TINY_BUFLEN) {
			/* data too big */
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : data too large\n", funcname);
			error = ENOBUFS;
			tinybuf_free(tbuf);
			goto fail;
		}

		work = tinybuf_alloc();
		if (work == NULL) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
						 funcname);
			error = ENOBUFS;
			tinybuf_free(tbuf);
			goto fail;
		}
		/* save original packet */
		tinybuf_copy(tbuf, work);

		ip6 = (struct ip6_hdr *)tbuf->pkt;
		plen = tbuf->len - sizeof(*ip6);
		nxt = ip6->ip6_nxt;
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : original plen = %d, nxt = %d\n",
					 funcname, plen, nxt);

		ip6->ip6_nxt = IPPROTO_ESP;

		/*
		 * we do not support extension headers, except ESP header.
		 */

		/* copy the upper-layer */
		TINY_BCOPY((CADDR_T)work->pkt + hlen,
				   (CADDR_T)tbuf->pkt + hlen + esphlen, work->len - hlen);

		tbuf->len += esphlen;
		plen += esphlen;

		tinybuf_free(work);

		/* initialize esp header. */
		esp = (struct esp *)(ip6 + 1);
		espoff = sizeof(struct ip6_hdr);
		esp->esp_spi = spi;
		esp->esp_seq = htonl(++ db->seq);	/* XXX : correct ??? */

		/* XXX : fill iv with random */
		ivp = (U_CHAR *)(esp + 1);
		tiny_random_stream(ivlen, ivp);

		{
			/*
			 */
			struct esptail *esptail;
			SIZE_T padbound;
			U_CHAR *padhead;
			int padlen;

			if (algo->padbound)
				padbound = algo->padbound;
			else
				padbound = 4;
			/* ESP packet, including nxthdr field, must be length of 4n */
			if (padbound < 4)
				padbound = 4;
	
			extendsiz = padbound - (plen % padbound);
			if (extendsiz < sizeof(struct esptail)) {
				extendsiz += padbound;
			}

			if (tbuf->len + extendsiz > TINY_BUFLEN) {
				/* packet data too big */
				error = ENOBUFS;
				tinybuf_free(tbuf);
				TINY_LOG_MSG(TINY_LOG_ERR, "%s : packet too big size = %d\n",
							 funcname, tbuf->len + extendsiz);
				goto fail;
			}
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s: esp padding & trailer length = ",
						 "%d\n", funcname, extendsiz);

			padhead = (U_CHAR *)tbuf->pkt + tbuf->len;
			padlen = extendsiz - sizeof(struct esptail);

			tbuf->len += extendsiz;
			plen += extendsiz;
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : plen = %d\n", funcname, plen);

			if (algo->fillpadding != NULL) {
				/* padding area */
				(*algo->fillpadding)(padhead, padlen);
			}

			/* initialize esp trailer. */
			esptail
				= (struct esptail *)((CADDR_T)tbuf->pkt + tbuf->len
									 - sizeof(struct esptail));
			esptail->esp_nxt = nxt;
			esptail->esp_padlen = extendsiz - sizeof(struct esptail);

			/*
			 * pre-compute and cache intermediate key
			 */
			error = tiny_esp_schedule(algo, db);
			if (error) {
				TINY_LOG_MSG(TINY_LOG_ERR, "%s : tiny_esp_schedule() "
							 "error (%d)\n", funcname, error);
				tinybuf_free(tbuf);
				goto fail;
			}

			/*
			 * encrypt the packet, based on security association
			 * and the algorithm specified.
			 */
			if (algo->encrypt == NULL)
				TINY_FATAL_ERROR("internal error: no encrypt function");

			if ((*algo->encrypt)(tbuf, espoff, plen, db, algo, ivlen)) {
				/* tbuf is already freed */
				TINY_LOG_MSG(TINY_LOG_ERR, "%s : packet encryption failure\n",
							 funcname);
				error = EINVAL;
				goto fail;
			}
		}

		{
			/*
			 * calculate ICV if required.
			 */
			if (db->esp_auth_key == NULL) {
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : esp_auth_key not found, "
							 "skip auth\n", funcname);
				goto noantireplay;
			}

			if (db->esp_auth_alg == TINY_IPSEC_PARAM_ESP_AUTH_ALG_NONE) {
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : auth_algo is NONE, "
							 "skip auth\n", funcname);
				goto noantireplay;
			}

			{
				const struct tiny_auth_algorithm *aalgo;
				U_CHAR authbuf[AUTH_MAXSUMSIZE];
				SIZE_T siz;

				aalgo = tiny_auth_algorithm_lookup(db->esp_auth_alg);
				if (aalgo == NULL) {
					TINY_LOG_MSG(TINY_LOG_INFO, "%s : esp_auth_algo is NONE\n",
								 funcname);
					goto noantireplay;
				}
				siz = (aalgo->sumsiz + 3) & ~(4 - 1);
				if (AUTH_MAXSUMSIZE < siz) {
					TINY_FATAL_ERROR("assertion failed for AUTH_MAXSUMSIZE");
				}
				if (tbuf->len + siz > TINY_BUFLEN) {
					/* packet data too big */
					TINY_LOG_MSG(TINY_LOG_ERR, "%s : packet too big (%d)\n",
								 funcname, tbuf->len + siz);
					error = ENOBUFS;
					tinybuf_free(tbuf);
					goto fail;
				}
				TINY_LOG_MSG(TINY_LOG_INFO, "%s : auth checksum size = %d\n",
							 funcname, siz);

				if (tiny_esp_auth(tbuf, espoff, tbuf->len - espoff,
								  db, authbuf)) {
					TINY_LOG_MSG(TINY_LOG_ERR, "%s : ESP checksum generation "
								 "failure\n", funcname);
					tinybuf_free(tbuf);
					error = EINVAL;
					goto fail;
				}

				TINY_BCOPY(authbuf, (CADDR_T)tbuf->pkt + tbuf->len, siz);
				tbuf->len += siz;
			}
		}
	}

 noantireplay:
	if (tbuf == NULL) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : buffer is NULL after encryption\n",
					 funcname);
	}

	return 0;

 fail:
	return error;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
