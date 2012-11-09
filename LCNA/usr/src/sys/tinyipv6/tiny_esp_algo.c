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

/*	$Id: tiny_esp_algo.c,v 1.1 2002/05/29 13:30:53 fujita Exp $	*/
/*	$NetBSD: esp_core.c,v 1.1.1.1.2.7 2000/11/03 18:45:15 tv Exp $	*/
/*	$KAME: esp_core.c,v 1.50 2000/11/02 12:27:38 itojun Exp $	*/

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
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_esp.h>
#include <tinyipv6/tiny_auth.h>
#include <crypto/des/des_locl.h>
#include <crypto/rijndael/rijndael.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/sysdep_utils.h>


static int tiny_esp_null_mature(struct tiny_ipsec_db *);
static int tiny_esp_null_decrypt(tinybuf *, SIZE_T,
								 struct tiny_ipsec_db *,
								 const struct tiny_esp_algorithm *, int);
static int tiny_esp_null_encrypt(tinybuf *, SIZE_T, SIZE_T,
								 struct tiny_ipsec_db *,
								 const struct tiny_esp_algorithm *, int);
static int tiny_esp_descbc_mature(struct tiny_ipsec_db *);
static int tiny_esp_descbc_ivlen(const struct tiny_esp_algorithm *,
								 struct tiny_ipsec_db *);
static int tiny_esp_des_schedule(const struct tiny_esp_algorithm *,
								 struct tiny_ipsec_db *);
static int tiny_esp_des_schedlen(const struct tiny_esp_algorithm *);
static int tiny_esp_des_blockdecrypt(const struct tiny_esp_algorithm *,
									 struct tiny_ipsec_db *,
									 U_INT8_T *, U_INT8_T *);
static int tiny_esp_des_blockencrypt(const struct tiny_esp_algorithm *,
									 struct tiny_ipsec_db *,
									 U_INT8_T *, U_INT8_T *);
static int tiny_esp_cbc_mature(struct tiny_ipsec_db *);
static int tiny_esp_3des_schedule(const struct tiny_esp_algorithm *,
								  struct tiny_ipsec_db *);
static int tiny_esp_3des_schedlen(const struct tiny_esp_algorithm *);
static int tiny_esp_3des_blockdecrypt(const struct tiny_esp_algorithm *,
									  struct tiny_ipsec_db *,
									  U_INT8_T *, U_INT8_T *);
static int tiny_esp_3des_blockencrypt(const struct tiny_esp_algorithm *,
									  struct tiny_ipsec_db *,
									  U_INT8_T *, U_INT8_T *);
static int tiny_esp_rijndael_schedlen(const struct tiny_esp_algorithm *);
static int tiny_esp_rijndael_schedule(const struct tiny_esp_algorithm *,
								  struct tiny_ipsec_db *);
static int tiny_esp_rijndael_blockdecrypt(const struct tiny_esp_algorithm *,
										  struct tiny_ipsec_db *,
										  U_INT8_T *, U_INT8_T *);
static int tiny_esp_rijndael_blockencrypt(const struct tiny_esp_algorithm *,
										  struct tiny_ipsec_db *,
										  U_INT8_T *, U_INT8_T *);
static int tiny_esp_common_ivlen(const struct tiny_esp_algorithm *,
								 struct tiny_ipsec_db *);
static int tiny_esp_cbc_decrypt(tinybuf *, SIZE_T,
								struct tiny_ipsec_db *,
								const struct tiny_esp_algorithm *, int);
static int tiny_esp_cbc_encrypt(tinybuf *, SIZE_T, SIZE_T,
								struct tiny_ipsec_db *,
								const struct tiny_esp_algorithm *, int);

static void tiny_esp_fill_padding_default(U_CHAR *pad, const int len);
static TinyBool tiny_esp_check_padding_default(const U_CHAR *pad, const int len);


#define MAXIVLEN	16

static const struct tiny_esp_algorithm tiny_esp_algorithms[] = {
	{
		TINY_IPSEC_PARAM_ESP_ALG_NULL,
		1, 0, tiny_esp_null_mature, 0, 2048, 0,
		"null",
		tiny_esp_common_ivlen, tiny_esp_null_decrypt,
		tiny_esp_null_encrypt, NULL,
		NULL, NULL,
	},
	{
		TINY_IPSEC_PARAM_ESP_ALG_DES,
		8, 8, tiny_esp_descbc_mature, 64, 64, tiny_esp_des_schedlen,
		"des-cbc",
		tiny_esp_descbc_ivlen, tiny_esp_cbc_decrypt,
		tiny_esp_cbc_encrypt, tiny_esp_des_schedule,
		tiny_esp_des_blockdecrypt, tiny_esp_des_blockencrypt,
		tiny_esp_fill_padding_default, tiny_esp_check_padding_default,
	},
	{
		TINY_IPSEC_PARAM_ESP_ALG_3DES,
		8, 8, tiny_esp_cbc_mature, 192, 192, tiny_esp_3des_schedlen,
		"3des-cbc",
		tiny_esp_common_ivlen, tiny_esp_cbc_decrypt,
		tiny_esp_cbc_encrypt, tiny_esp_3des_schedule,
		tiny_esp_3des_blockdecrypt, tiny_esp_3des_blockencrypt,
		tiny_esp_fill_padding_default, tiny_esp_check_padding_default,
	},
	{
		TINY_IPSEC_PARAM_ESP_ALG_RIJNDEAL,
		16, 16, tiny_esp_cbc_mature, 128, 256, tiny_esp_rijndael_schedlen,
		"rijndael-cbc",
		tiny_esp_common_ivlen, tiny_esp_cbc_decrypt,
		tiny_esp_cbc_encrypt, tiny_esp_rijndael_schedule,
		tiny_esp_rijndael_blockdecrypt, tiny_esp_rijndael_blockencrypt,
		tiny_esp_fill_padding_default, tiny_esp_check_padding_default,
	},
};


const struct tiny_esp_algorithm *
tiny_esp_algorithm_lookup(int idx)
{
	int i;
	for (i = 0; i < TINY_NUMBEROF(tiny_esp_algorithms); i ++) {
		if (tiny_esp_algorithms[i].index == idx) {
			return &tiny_esp_algorithms[i];
		}
	}
	return NULL;
}

int
tiny_esp_max_ivlen(void)
{
	int idx;
	int ivlen;

	ivlen = 0;
	for (idx = 0; idx < TINY_NUMBEROF(tiny_esp_algorithms); idx++) {
		if (tiny_esp_algorithms[idx].ivlenval > ivlen)
			ivlen = tiny_esp_algorithms[idx].ivlenval;
	}

	return ivlen;
}

int
tiny_esp_schedule(const struct tiny_esp_algorithm *algo,
				  struct tiny_ipsec_db *db)
{
	TINY_FUNC_NAME(tiny_esp_schedule);
	int error;
	/* check for key length */
	if (tiny_ipsec_key_bits(db->esp_key) < algo->keymin
		|| tiny_ipsec_key_bits(db->esp_key) > algo->keymax) {
		TINY_LOG_MSG(TINY_LOG_ERR,
					 "%s %s: unsupported key length %d: "
					 "needs %d to %d bits\n", funcname,
					 algo->name, tiny_ipsec_key_bits(db->esp_key),
					 algo->keymin, algo->keymax);
		return EINVAL;
	}

	/* no schedule necessary */
	if ((algo->schedule == NULL) || (algo->schedlen == NULL)) {
		return 0;
	}

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s %s: length = %d\n", funcname,
				 algo->name, algo->schedlen(algo));

	error = (*algo->schedule)(algo, db);
	if (error != 0) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: error %d\n", funcname,
					 algo->name, error);
	}
	return error;
}

static int
tiny_esp_null_mature(struct tiny_ipsec_db *db)
{
	/* anything is okay */
	return 0;
}

static int
tiny_esp_null_decrypt(tinybuf *tbuf,
					  SIZE_T off,		/* offset to ESP header */
					  struct tiny_ipsec_db *db,
					  const struct tiny_esp_algorithm *algo,
					  int ivlen)
{
	return 0; /* do nothing */
}

static int
tiny_esp_null_encrypt(tinybuf *tbuf,
					  SIZE_T off,	/* offset to ESP header */
					  SIZE_T plen,	/* payload length (to be encrypted) */
					  struct tiny_ipsec_db *db,
					  const struct tiny_esp_algorithm *algo,
					  int ivlen)
{
	return 0; /* do nothing */
}

static int
tiny_esp_descbc_mature(struct tiny_ipsec_db *db)
{
	TINY_FUNC_NAME(tiny_esp_descbc_mature);
	const struct tiny_esp_algorithm *algo;

	if (db->esp_key == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no key is given.\n", funcname);
		return 1;
	}

	algo = tiny_esp_algorithm_lookup(db->esp_alg);
	if (algo == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : unsupported algorithm.\n", funcname);
		return 1;
	}

	if (tiny_ipsec_key_bits(db->esp_key) < algo->keymin ||
	    tiny_ipsec_key_bits(db->esp_key) > algo->keymax) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : invalid key length %d.\n", funcname,
					 tiny_ipsec_key_bits(db->esp_key));
		return 1;
	}

	/* weak key check */
	if (des_is_weak_key((des_cblock *)tiny_ipsec_key_buf(db->esp_key))) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : weak key was passed.\n", funcname);
		return 1;
	}

	return 0;
}

static int
tiny_esp_descbc_ivlen(const struct tiny_esp_algorithm *algo,
					  struct tiny_ipsec_db *db)
{

	if (db == NULL) {
		return 8;	/* XXX */
	}
	else {
		return 8;
	}
}

static int
tiny_esp_des_schedlen(const struct tiny_esp_algorithm *algo)
{
	return sizeof(des_key_schedule);
}

static int
tiny_esp_des_schedule(const struct tiny_esp_algorithm *algo,
					  struct tiny_ipsec_db *db)
{

	if (des_key_sched((des_cblock *)tiny_ipsec_key_buf(db->esp_key),
					  *(des_key_schedule *)tiny_ipsec_sched(db->esp_sched))) {
		return EINVAL;
	}
	else {
		return 0;
	}
}

static int
tiny_esp_des_blockdecrypt(const struct tiny_esp_algorithm *algo,
						  struct tiny_ipsec_db *db, U_INT8_T *s, U_INT8_T *d)
{

	/* assumption: d has a good alignment */
	TINY_BCOPY(s, d, sizeof(DES_LONG) * 2);
	des_ecb_encrypt((des_cblock *)d, (des_cblock *)d,
					*(des_key_schedule *)tiny_ipsec_sched(db->esp_sched),
					DES_DECRYPT);
	return 0;
}

static int
tiny_esp_des_blockencrypt(const struct tiny_esp_algorithm *algo,
						  struct tiny_ipsec_db *db, U_INT8_T *s, U_INT8_T *d)
{

	/* assumption: d has a good alignment */
	TINY_BCOPY(s, d, sizeof(DES_LONG) * 2);
	des_ecb_encrypt((des_cblock *)d, (des_cblock *)d,
					*(des_key_schedule *)tiny_ipsec_sched(db->esp_sched),
					DES_ENCRYPT);
	return 0;
}

static int
tiny_esp_cbc_mature(struct tiny_ipsec_db *db)
{
	TINY_FUNC_NAME(tiny_esp_cbc_mature);
	int keylen;
	const struct tiny_esp_algorithm *algo;
	U_INT8_T *key;

	if (db->esp_key == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : no key is given.\n", funcname);
		return 1;
	}

	algo = tiny_esp_algorithm_lookup(db->esp_alg);
	if (algo == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR,"%s %s: unsupported algorithm.\n",
					 funcname, algo->name);
		return 1;
	}

	keylen = tiny_ipsec_key_bits(db->esp_key);
	if (keylen < algo->keymin || algo->keymax < keylen) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: invalid key length %d.\n",
					 funcname, algo->name, tiny_ipsec_key_bits(db->esp_key));
		return 1;
	}
	switch (db->esp_alg) {
	case TINY_IPSEC_PARAM_ESP_ALG_3DES:
		/* weak key check */
		key = tiny_ipsec_key_buf(db->esp_key);
		if (des_is_weak_key((des_cblock *)key)
			|| des_is_weak_key((des_cblock *)(key + 8))
			|| des_is_weak_key((des_cblock *)(key + 16))) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: weak key was passed.\n",
						 funcname, algo->name);
			return 1;
		}
		break;
	case TINY_IPSEC_PARAM_ESP_ALG_RIJNDEAL:
		/* allows specific key sizes only */
		if (!(keylen == 128 || keylen == 192 || keylen == 256)) {
			TINY_LOG_MSG(TINY_LOG_ERR,"%s %s: invalid key length %d.\n",
						 funcname, algo->name, keylen);
			return 1;
		}
		break;
	}

	return 0;
}

static int
tiny_esp_3des_schedlen(const struct tiny_esp_algorithm *algo)
{
	return sizeof(des_key_schedule) * 3;
}

static int
tiny_esp_3des_schedule(const struct tiny_esp_algorithm *algo,
					   struct tiny_ipsec_db *db)
{
	int error;
	des_key_schedule *p;
	int i;
	char *k;

	p = (des_key_schedule *)tiny_ipsec_sched(db->esp_sched);
	k = tiny_ipsec_key_buf(db->esp_key);
	for (i = 0; i < 3; i++) {
		error = des_key_sched((des_cblock *)(k + 8 * i), p[i]);
		if (error)
			return EINVAL;
	}
	return 0;
}

static int
tiny_esp_3des_blockdecrypt(const struct tiny_esp_algorithm *algo,
						   struct tiny_ipsec_db *db, U_INT8_T *s, U_INT8_T *d)
{
	des_key_schedule *p;

	/* assumption: d has a good alignment */
	p = (des_key_schedule *)tiny_ipsec_sched(db->esp_sched);
	TINY_BCOPY(s, d, sizeof(DES_LONG) * 2);
	des_ecb_encrypt((des_cblock *)d, (des_cblock *)d, p[2], DES_DECRYPT);
	des_ecb_encrypt((des_cblock *)d, (des_cblock *)d, p[1], DES_ENCRYPT);
	des_ecb_encrypt((des_cblock *)d, (des_cblock *)d, p[0], DES_DECRYPT);
	return 0;
}

static int
tiny_esp_3des_blockencrypt(const struct tiny_esp_algorithm *algo,
						   struct tiny_ipsec_db *db,U_INT8_T *s, U_INT8_T *d)
{
	des_key_schedule *p;

	/* assumption: d has a good alignment */
	p = (des_key_schedule *)tiny_ipsec_sched(db->esp_sched);
	TINY_BCOPY(s, d, sizeof(DES_LONG) * 2);
	des_ecb_encrypt((des_cblock *)d, (des_cblock *)d, p[0], DES_ENCRYPT);
	des_ecb_encrypt((des_cblock *)d, (des_cblock *)d, p[1], DES_DECRYPT);
	des_ecb_encrypt((des_cblock *)d, (des_cblock *)d, p[2], DES_ENCRYPT);
	return 0;
}

static int
tiny_esp_rijndael_schedlen(const struct tiny_esp_algorithm *algo)
{
	return sizeof(keyInstance) * 2;
}

static int
tiny_esp_rijndael_schedule(const struct tiny_esp_algorithm *algo,
						   struct tiny_ipsec_db *db)
{
	keyInstance *k;
	char keymat[256 / 4 + 1];
	U_CHAR *p, *ep;
	char *q, *eq;

	/* rijndael_makeKey wants hex string for the key */
	if (tiny_ipsec_key_len(db->esp_key) * 2 > sizeof(keymat) - 1) {
		return -1;
	}
	p = tiny_ipsec_key_buf(db->esp_key); 
	ep = p + tiny_ipsec_key_len(db->esp_key);
	q = keymat;
	eq = &keymat[sizeof(keymat) - 1];
	while (p < ep && q < eq) {
		sprintf(q, "%02x", *p);
		q += 2;
		p++;
	}
	*eq = '\0';

	k = (keyInstance *)tiny_ipsec_sched(db->esp_sched);
	if (rijndael_makeKey(&k[0], DIR_DECRYPT,
						 tiny_ipsec_key_len(db->esp_key) * 8, keymat) < 0) {
		return -1;
	}
	if (rijndael_makeKey(&k[1], DIR_ENCRYPT,
						 tiny_ipsec_key_len(db->esp_key) * 8, keymat) < 0) {
		return -1;
	}
	return 0;

}

static int
tiny_esp_rijndael_blockdecrypt(const struct tiny_esp_algorithm *algo,
							   struct tiny_ipsec_db *db,
							   U_INT8_T *s, U_INT8_T *d)
{
	cipherInstance c;
	keyInstance *p;

	/* does not take advantage of CBC mode support */
	TINY_BZERO(&c, sizeof(c));
	if (rijndael_cipherInit(&c, MODE_CBC, NULL) < 0) {
		return -1;
	}
	p = (keyInstance *)tiny_ipsec_sched(db->esp_sched);
	if (rijndael_blockDecrypt(&c, &p[0], s, algo->padbound * 8, d) < 0) {
		return -1;
	}
	return 0;
}

static int
tiny_esp_rijndael_blockencrypt(const struct tiny_esp_algorithm *algo,
							   struct tiny_ipsec_db *db,
							   U_INT8_T *s, U_INT8_T *d)
{
	cipherInstance c;
	keyInstance *p;

	/* does not take advantage of CBC mode support */
	TINY_BZERO(&c, sizeof(c));
	if (rijndael_cipherInit(&c, MODE_CBC, NULL) < 0) {
		return -1;
	}
	p = (keyInstance *)tiny_ipsec_sched(db->esp_sched);
	if (rijndael_blockEncrypt(&c, &p[1], s, algo->padbound * 8, d) < 0) {
		return -1;
	}
	return 0;
}

static int
tiny_esp_common_ivlen(const struct tiny_esp_algorithm *algo,
					  struct tiny_ipsec_db *db)
{
	TINY_FUNC_NAME(tiny_esp_common_ivlen);
	if (algo == NULL) {
		TINY_FATAL_ERROR("%s : unknown algorithm", funcname);
	}
	return algo->ivlenval;
}

static int
tiny_esp_cbc_decrypt(tinybuf *tbuf, SIZE_T off,
					 struct tiny_ipsec_db *db,
					 const struct tiny_esp_algorithm *algo, int ivlen)
{
	TINY_FUNC_NAME(tiny_esp_cbc_decrypt);
	tinybuf *work = NULL;
	SIZE_T ivoff;
	SIZE_T bodyoff;
	SIZE_T decoff;
	U_INT8_T iv[MAXIVLEN];
	U_INT8_T *ivp;
	int blocklen;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);

	if (ivlen != algo->ivlenval || ivlen > sizeof(iv)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: unsupported ivlen %d\n",
					 funcname, algo->name, ivlen);
		tinybuf_free(tbuf);
		return EINVAL;
	}

	/* assumes blocklen == padbound */
	blocklen = algo->padbound;

	ivoff = off + sizeof(struct esp);
	bodyoff = ivoff + ivlen;

	/* grab iv */
	TINY_BCOPY(tbuf->pkt + ivoff, iv, ivlen);

	/* extend iv */
	if (ivlen == blocklen) {
		;	/* do nothing */
	}
	else if (ivlen == 4 && blocklen == 8) {
		TINY_BCOPY(&iv[0], &iv[4], 4);
		iv[4] ^= 0xff;
		iv[5] ^= 0xff;
		iv[6] ^= 0xff;
		iv[7] ^= 0xff;
	}
	else {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: unsupported ivlen/blocklen: "
					 "%d %d\n", funcname, algo->name, ivlen, blocklen);
		tinybuf_free(tbuf);
		return EINVAL;
	}

	if (tbuf->len < bodyoff) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: bad len %d/%lu\n", funcname, 
					 algo->name, tbuf->len, (unsigned long)bodyoff);
		tinybuf_free(tbuf);
		return EINVAL;
	}
	if ((tbuf->len - bodyoff) % blocklen) {
		TINY_LOG_MSG(TINY_LOG_ERR,
					 "%s %s: payload length must be multiple of %d\n",
					 funcname, algo->name, blocklen);
		tinybuf_free(tbuf);
		return EINVAL;
	}

	work = tinybuf_alloc();
	if (work == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
					 funcname);
		tinybuf_free(tbuf);
		return ENOBUFS;
	}
	tinybuf_copy(tbuf, work);

	ivp = iv;
	decoff = bodyoff;

	while (decoff < work->len) {
		int i;
		U_INT8_T *p;
		U_INT8_T *c;

		p = (U_INT8_T *)tbuf->pkt + decoff;
		c = (U_INT8_T *)work->pkt + decoff;

		/* decrypt */
		(*algo->blockdecrypt)(algo, db, c, p);

		/* xor */
		for (i = 0; i < blocklen; i++)
			p[i] ^= ivp[i];

		/* next iv */
		ivp = c;

		decoff += blocklen;
	}

	if (work != NULL) {
		tinybuf_free(work);
	}

	/* just in case */
	TINY_BZERO(iv, sizeof(iv));

	return 0;
}

static int
tiny_esp_cbc_encrypt(tinybuf *tbuf, SIZE_T off, SIZE_T plen,
					 struct tiny_ipsec_db *db,
					 const struct tiny_esp_algorithm *algo, int ivlen)
{
	TINY_FUNC_NAME(tiny_esp_cbc_encrypt);
	tinybuf *work = NULL;
	SIZE_T ivoff;
	SIZE_T bodyoff;
	SIZE_T encoff;
	U_INT8_T iv[MAXIVLEN];
	U_INT8_T *ivp;
	int blocklen;

	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : called\n", funcname);

	if (ivlen != algo->ivlenval || ivlen > sizeof(iv)) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: unsupported ivlen %d\n",
					 funcname, algo->name, ivlen);
		tinybuf_free(tbuf);
		return EINVAL;
	}

	/* assumes blocklen == padbound */
	blocklen = algo->padbound;

	ivoff = off + sizeof(struct esp);
	bodyoff = ivoff + ivlen;

	/* grab iv */
	TINY_BCOPY(tbuf->pkt + ivoff, iv, ivlen);

	/* extend iv */
	if (ivlen == blocklen) {
		;	/* do nothing */
	}
	else if (ivlen == 4 && blocklen == 8) {
		TINY_BCOPY(&iv[0], &iv[4], 4);
		iv[4] ^= 0xff;
		iv[5] ^= 0xff;
		iv[6] ^= 0xff;
		iv[7] ^= 0xff;
	}
	else {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: unsupported ivlen/blocklen: "
					 "%d %d\n", funcname, algo->name, ivlen, blocklen);
		tinybuf_free(tbuf);
		return EINVAL;
	}

	if (tbuf->len < bodyoff) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: bad len %d/%lu\n", funcname, 
					 algo->name, tbuf->len, (unsigned long)bodyoff);
		tinybuf_free(tbuf);
		return EINVAL;
	}
	if ((tbuf->len - bodyoff) % blocklen) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s %s: payload length "
					 "must be multiple of %lu\n", funcname,
					 algo->name, (unsigned long)algo->padbound);
		tinybuf_free(tbuf);
		return EINVAL;
	}

	work = tinybuf_alloc();
	if (work == NULL) {
		/* XXX */
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : buffer allocation failed\n",
					 funcname);
		tinybuf_free(tbuf);
		return ENOBUFS;
	}
	tinybuf_copy(tbuf, work);

	ivp = iv;
	encoff = bodyoff;

	while (encoff < work->len) {
		int i;
		U_INT8_T *p;
		U_INT8_T *c;

		p = (U_INT8_T *)work->pkt + encoff;
		c = (U_INT8_T *)tbuf->pkt + encoff;

		/* xor */
		for (i = 0; i < blocklen; i++)
			p[i] ^= ivp[i];

		/* encrypt */
		(*algo->blockencrypt)(algo, db, p, c);

		/* next iv */
		ivp = c;

		encoff += blocklen;
	}

	if (work != NULL) {
		tinybuf_free(work);
	}

	/* just in case */
	TINY_BZERO(iv, sizeof(iv));

	return 0;
}


int
tiny_esp_auth(tinybuf *tbuf,
			  SIZE_T skip,	/* offset to ESP header */
			  SIZE_T length,	/* payload length */
			  struct tiny_ipsec_db *db,
			  U_CHAR *sum)
{
	TINY_FUNC_NAME(tiny_esp_auth);
	struct tiny_auth_algorithm_state s;
	U_CHAR sumbuf[AUTH_MAXSUMSIZE];
	const struct tiny_auth_algorithm *algo;
	SIZE_T siz;
	int error;

	/* sanity checks */
	if (tbuf->len < skip) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : buf length(%d) < skip(%d)\n",
					 funcname, tbuf->len, skip);
		return EINVAL;
	}
	if (tbuf->len < skip + length) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : buf length < skip + length\n",
					 funcname);
		return EINVAL;
	}
	/*
	 * length of esp part (excluding authentication data) must be 4n,
	 * since nexthdr must be at offset 4n+3.
	 */
	if ((length % 4) != 0) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : length is not multiple of 4\n",
					 funcname);
		return EINVAL;
	}
	if (db == NULL) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : NULL SA passed\n", funcname);
		return EINVAL;
	}
	algo = tiny_auth_algorithm_lookup(db->esp_auth_alg);
	if (algo == NULL) {
		TINY_LOG_MSG(TINY_LOG_ERR, "%s : bad ESP auth algorithm passed: %d\n",
					 funcname, db->esp_auth_alg);
		return EINVAL;
	}

	siz = ((algo->sumsiz + 3) & ~(4 - 1));
	if (sizeof(sumbuf) < siz) {
		TINY_LOG_MSG(TINY_LOG_DEBUG,
					 "%s : AH_MAXSUMSIZE is too small: siz=%lu\n",
					 funcname, (U_LONG)siz);
		return EINVAL;
	}

	error = (*algo->init)(&s, db);
	if (error) {
		return error;
	}

	(*algo->update)(&s, tbuf->pkt + skip, length);

	(*algo->result)(&s, sumbuf);
	TINY_BCOPY(sumbuf, sum, siz);
	
	return 0;
}


static void
tiny_esp_fill_padding_default(U_CHAR *pad, const int len)
{
	int i;
	for (i = 0; i < len; i ++) {
		pad[i] = (U_CHAR)((i + 1) & 0xff);
	}
}


static TinyBool
tiny_esp_check_padding_default(const U_CHAR *pad, const int len)
{
	int i;
	for (i = 0; i < len; i ++) {
		if (pad[i] != ((U_CHAR)((i + 1) & 0xff))) {
			return TinyFalse;
		}
	}
	return TinyTrue;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
