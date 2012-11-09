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

/*	$Id: tiny_auth_algo.c,v 1.1 2002/05/29 13:30:49 fujita Exp $	*/
/*	$NetBSD: ah_core.c,v 1.19.2.3 2001/02/26 22:11:42 he Exp $	*/
/*	$KAME: ah_core.c,v 1.36 2000/07/15 16:07:48 itojun Exp $	*/

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


#include <sys/md5.h>
#include <sys/sha1.h>
#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ip6.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_auth.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/sysdep_utils.h>


#define SHA1_RESULTLEN  20
#define	HMACSIZE	16


static int tiny_auth_none_mature(struct tiny_ipsec_db *);
static int tiny_auth_none_init(struct tiny_auth_algorithm_state *,
							   struct tiny_ipsec_db *);
static void tiny_auth_none_loop(struct tiny_auth_algorithm_state *,
								CADDR_T, SIZE_T);
static void tiny_auth_none_result(struct tiny_auth_algorithm_state *, CADDR_T);

static int tiny_auth_hmac_md5_mature(struct tiny_ipsec_db *);
static int tiny_auth_hmac_md5_init(struct tiny_auth_algorithm_state *,
								   struct tiny_ipsec_db *);
static void tiny_auth_hmac_md5_loop(struct tiny_auth_algorithm_state *,
									CADDR_T, SIZE_T);
static void tiny_auth_hmac_md5_result(struct tiny_auth_algorithm_state *,
									  CADDR_T);

static int tiny_auth_hmac_sha1_mature(struct tiny_ipsec_db *);
static int tiny_auth_hmac_sha1_init(struct tiny_auth_algorithm_state *,
									struct tiny_ipsec_db *);
static void tiny_auth_hmac_sha1_loop(struct tiny_auth_algorithm_state *,
									 CADDR_T, SIZE_T);
static void tiny_auth_hmac_sha1_result(struct tiny_auth_algorithm_state *,
									   CADDR_T);


/* checksum algorithms */
static struct tiny_auth_algorithm tiny_auth_algorithms[] = {
	{
		TINY_IPSEC_PARAM_ESP_AUTH_ALG_NONE,
		0, tiny_auth_none_mature, 0, 2048,
		"none",
		tiny_auth_none_init, tiny_auth_none_loop,
		tiny_auth_none_result,
	},
	{
		TINY_IPSEC_PARAM_ESP_AUTH_ALG_HMAC_MD5,
		12, tiny_auth_hmac_md5_mature, 128, 128,
		"hmac-md5",
		tiny_auth_hmac_md5_init, tiny_auth_hmac_md5_loop,
		tiny_auth_hmac_md5_result,
	},
	{
		TINY_IPSEC_PARAM_ESP_AUTH_ALG_HMAC_SHA,
		12, tiny_auth_hmac_sha1_mature, 160, 160,
		"hmac-sha1",
		tiny_auth_hmac_sha1_init, tiny_auth_hmac_sha1_loop,
		tiny_auth_hmac_sha1_result,
	},
};


const struct tiny_auth_algorithm *
tiny_auth_algorithm_lookup(int idx)
{
	int i;
	for (i = 0; i < TINY_NUMBEROF(tiny_auth_algorithms); i ++) {
		if (tiny_auth_algorithms[i].index == idx) {
			return &tiny_auth_algorithms[i];
		}
	}
	return NULL;
}


static int
tiny_auth_none_mature(struct tiny_ipsec_db *db)
{
	if (db == NULL) {
		return -1;
	}
	return 0;
}


static int
tiny_auth_none_init(struct tiny_auth_algorithm_state *state,
			   struct tiny_ipsec_db *db)
{
	state->foo = NULL;
	return 0;
}


static void
tiny_auth_none_loop(struct tiny_auth_algorithm_state *state,
			   CADDR_T addr, SIZE_T len)
{
	/* do nothing */
}

static void
tiny_auth_none_result(struct tiny_auth_algorithm_state *state, CADDR_T addr)
{
	/* do nothing */
}

static int
tiny_auth_hmac_md5_mature(struct tiny_ipsec_db *db)
{
	TINY_FUNC_NAME(tiny_auth_hmac_md5_mature);
	const struct tiny_auth_algorithm *algo;

	if (db->esp_auth_key == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no key is given.\n", funcname);
		return 1;
	}

	algo = tiny_auth_algorithm_lookup(db->esp_auth_alg);
	if (algo == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : unsupported algorithm.\n", funcname);
		return 1;
	}

	if (tiny_ipsec_key_bits(db->esp_auth_key) < algo->keymin
		|| algo->keymax < tiny_ipsec_key_bits(db->esp_auth_key)) {
		TINY_LOG_MSG(TINY_LOG_ERR,
					 "%s : invalid key length %d.\n", funcname,
					 tiny_ipsec_key_bits(db->esp_auth_key));
		return 1;
	}

	return 0;
}

static int
tiny_auth_hmac_md5_init(struct tiny_auth_algorithm_state *state,
						struct tiny_ipsec_db *db)
{
	TINY_FUNC_NAME(tiny_auth_hmac_md5_init);
	U_CHAR *ipad;
	U_CHAR *opad;
	U_CHAR tk[16];
	U_CHAR *key;
	SIZE_T keylen;
	SIZE_T i;
	MD5_CTX *ctxt;

	if (state == NULL) {
		TINY_FATAL_ERROR("%s : state == NULL", funcname);
	}

	state->db = db;
	state->foo = tiny_sysmem_alloc(64 + 64 + sizeof(MD5_CTX));
	if (state->foo == NULL) {
		return ENOBUFS;
	}

	ipad = (U_CHAR *)state->foo;
	opad = (U_CHAR *)(ipad + 64);
	ctxt = (MD5_CTX *)(opad + 64);

	
	/* compress the key if necessery */
	if (64 < tiny_ipsec_key_len(state->db->esp_auth_key)) {
		MD5Init(ctxt);
		MD5Update(ctxt, tiny_ipsec_key_buf(state->db->esp_auth_key),
				  tiny_ipsec_key_len(state->db->esp_auth_key));
		MD5Final(&tk[0], ctxt);
		key = &tk[0];
		keylen = 16;
	}
	else {
		key = tiny_ipsec_key_buf(state->db->esp_auth_key);
		keylen = tiny_ipsec_key_len(state->db->esp_auth_key);
	}

	TINY_BZERO(ipad, 64);
	TINY_BZERO(opad, 64);
	TINY_BCOPY(key, ipad, keylen);
	TINY_BCOPY(key, opad, keylen);
	for (i = 0; i < 64; i++) {
		ipad[i] ^= 0x36;
		opad[i] ^= 0x5c;
	}

	MD5Init(ctxt);
	MD5Update(ctxt, ipad, 64);

	return 0;
}

static void
tiny_auth_hmac_md5_loop(struct tiny_auth_algorithm_state *state,
						CADDR_T addr, SIZE_T len)
{
	TINY_FUNC_NAME(tiny_auth_hmac_md5_loop);
	MD5_CTX *ctxt;

	if ((state == NULL) || (state->foo == NULL)) {
		TINY_FATAL_ERROR("%s : state == NULL", funcname);
	}
	ctxt = (MD5_CTX *)(((CADDR_T)state->foo) + 128);
	MD5Update(ctxt, addr, len);
}

static void
tiny_auth_hmac_md5_result(struct tiny_auth_algorithm_state *state,
						  CADDR_T addr)
{
	TINY_FUNC_NAME(tiny_auth_hmac_md5_result);
	U_CHAR digest[16];
	U_CHAR *ipad;
	U_CHAR *opad;
	MD5_CTX *ctxt;

	if ((state == NULL) || (state->foo == NULL)) {
		TINY_FATAL_ERROR("%s : state == NULL", funcname);
	}

	ipad = (U_CHAR *)state->foo;
	opad = (U_CHAR *)(ipad + 64);
	ctxt = (MD5_CTX *)(opad + 64);

	MD5Final(&digest[0], ctxt);

	MD5Init(ctxt);
	MD5Update(ctxt, opad, 64);
	MD5Update(ctxt, &digest[0], sizeof(digest));
	MD5Final(&digest[0], ctxt);

	TINY_BCOPY(&digest[0], (void *)addr, HMACSIZE);

	tiny_sysmem_free(state->foo);
}

static int
tiny_auth_hmac_sha1_mature(struct tiny_ipsec_db *db)
{
	TINY_FUNC_NAME(tiny_auth_hmac_sha1_mature);
	const struct tiny_auth_algorithm *algo;

	if (db->esp_auth_key == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no key is given.\n", funcname);
		return 1;
	}

	algo = tiny_auth_algorithm_lookup(db->esp_auth_alg);
	if (algo == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : unsupported algorithm.\n", funcname);
		return 1;
	}

	if (tiny_ipsec_key_bits(db->esp_auth_key) < algo->keymin
		|| algo->keymax < tiny_ipsec_key_bits(db->esp_auth_key)) {
		TINY_LOG_MSG(TINY_LOG_ERR,
					 "%s : invalid key length %d.\n", funcname,
					 tiny_ipsec_key_bits(db->esp_auth_key));
		return 1;
	}

	return 0;
}

static int
tiny_auth_hmac_sha1_init(struct tiny_auth_algorithm_state *state,
						 struct tiny_ipsec_db *db)
{
	TINY_FUNC_NAME(tiny_auth_hmac_sha1_init);
	U_CHAR *ipad;
	U_CHAR *opad;
	SHA1_CTX *ctxt;
	U_CHAR tk[SHA1_RESULTLEN];	/* SHA-1 generates 160 bits */
	U_CHAR *key;
	SIZE_T keylen;
	SIZE_T i;

	if (state == NULL) {
		TINY_FATAL_ERROR("%s : state == NULL", funcname);
	}

	state->db = db;
	state->foo = tiny_sysmem_alloc(64 + 64 + sizeof(SHA1_CTX));
	if (state->foo == NULL) {
		return ENOBUFS;
	}

	ipad = (U_CHAR *)state->foo;
	opad = (U_CHAR *)(ipad + 64);
	ctxt = (SHA1_CTX *)(opad + 64);

	/* compress the key if necessery */
	if (64 < tiny_ipsec_key_len(state->db->esp_auth_key)) {
		SHA1Init(ctxt);
		SHA1Update(ctxt, tiny_ipsec_key_buf(state->db->esp_auth_key),
				   tiny_ipsec_key_len(state->db->esp_auth_key));
		SHA1Final(&tk[0], ctxt);
		key = &tk[0];
		keylen = SHA1_RESULTLEN;
	}
	else {
		key = tiny_ipsec_key_buf(state->db->esp_auth_key);
		keylen = tiny_ipsec_key_len(state->db->esp_auth_key);
	}

	TINY_BZERO(ipad, 64);
	TINY_BZERO(opad, 64);
	TINY_BCOPY(key, ipad, keylen);
	TINY_BCOPY(key, opad, keylen);
	for (i = 0; i < 64; i++) {
		ipad[i] ^= 0x36;
		opad[i] ^= 0x5c;
	}

	SHA1Init(ctxt);
	SHA1Update(ctxt, ipad, 64);

	return 0;
}

static void
tiny_auth_hmac_sha1_loop(struct tiny_auth_algorithm_state *state,
						 CADDR_T addr, SIZE_T len)
{
	TINY_FUNC_NAME(tiny_auth_hmac_sha1_loop);
	SHA1_CTX *ctxt;

	if ((state == NULL) || (state->foo == NULL)) {
		TINY_FATAL_ERROR("%s : state == NULL", funcname);
	}

	ctxt = (SHA1_CTX *)(((U_CHAR *)state->foo) + 128);
	SHA1Update(ctxt, (CADDR_T)addr, (SIZE_T)len);
}

static void
tiny_auth_hmac_sha1_result(struct tiny_auth_algorithm_state *state,
						   CADDR_T addr)
{
	TINY_FUNC_NAME(tiny_auth_hmac_sha1_result);
	U_CHAR digest[SHA1_RESULTLEN];	/* SHA-1 generates 160 bits */
	U_CHAR *ipad;
	U_CHAR *opad;
	SHA1_CTX *ctxt;

	if ((state == NULL) || (state->foo == NULL)) {
		TINY_FATAL_ERROR("%s : state == NULL", funcname);
	}

	ipad = (U_CHAR *)state->foo;
	opad = (U_CHAR *)(ipad + 64);
	ctxt = (SHA1_CTX *)(opad + 64);

	SHA1Final((CADDR_T)&digest[0], ctxt);

	SHA1Init(ctxt);
	SHA1Update(ctxt, opad, 64);
	SHA1Update(ctxt, (CADDR_T)&digest[0], sizeof(digest));
	SHA1Final((CADDR_T)&digest[0], ctxt);

	TINY_BCOPY(&digest[0], (void *)addr, HMACSIZE);

	tiny_sysmem_free(state->foo);
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
