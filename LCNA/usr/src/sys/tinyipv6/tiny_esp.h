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

/*	$Id: tiny_esp.h,v 1.1 2002/05/29 13:30:52 fujita Exp $	*/
/*	$NetBSD: esp.h,v 1.8.2.3 2000/09/29 06:42:42 itojun Exp $	*/
/*	$KAME: esp.h,v 1.15 2000/09/20 18:15:22 itojun Exp $	*/

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

/*
 * RFC2406 Encapsulated Security Payload.
 */

#ifndef _TINYIPV6_TINY_ESP_H_
#define _TINYIPV6_TINY_ESP_H_


struct esp {
	U_INT32_T	esp_spi;	/* ESP */
	U_INT32_T	esp_seq;	/* Sequence number */
	/*variable size*/		/* (IV and) Payload data */
	/*variable size*/		/* padding */
	/*8bit*/				/* pad size */
	/*8bit*/				/* next header */
	/*8bit*/				/* next header */
	/*variable size, 32bit bound*/	/* Authentication data */
};

struct esptail {
	U_INT8_T	esp_padlen;	/* pad length */
	U_INT8_T	esp_nxt;	/* Next header */
	/*variable size, 32bit bound*/	/* Authentication data (new IPsec)*/
};

struct tiny_esp_algorithm {
	int index;
	SIZE_T padbound;	/* pad boundary, in byte */
	int ivlenval;		/* iv length, in byte */
	int (*mature)(struct tiny_ipsec_db *);
	int keymin;			/* in bits */
	int keymax;			/* in bits */
	int (*schedlen)(const struct tiny_esp_algorithm *);
	const char *name;
	int (*ivlen)(const struct tiny_esp_algorithm *, struct tiny_ipsec_db *);
	int (*decrypt)(tinybuf *, SIZE_T, struct tiny_ipsec_db *,
				   const struct tiny_esp_algorithm *, int);
	int (*encrypt)(tinybuf *, SIZE_T, SIZE_T, struct tiny_ipsec_db *,
				   const struct tiny_esp_algorithm *, int);
	/* not supposed to be called directly */
	int (*schedule)(const struct tiny_esp_algorithm *, struct tiny_ipsec_db *);
	int (*blockdecrypt)(const struct tiny_esp_algorithm *,
						struct tiny_ipsec_db *, U_INT8_T *, U_INT8_T *);
	int (*blockencrypt)(const struct tiny_esp_algorithm *,
						struct tiny_ipsec_db *, U_INT8_T *, U_INT8_T *);
	void (*fillpadding)(U_CHAR *, const int);
	TinyBool (*checkpadding)(const U_CHAR *, const int);
};


extern const struct tiny_esp_algorithm *tiny_esp_algorithm_lookup(int);
extern int tiny_esp_max_ivlen(void);


/* crypt routines */
extern int tiny_esp_output(tinybuf *, struct tiny_ipsec_db *);
extern int tiny_esp_input(tinybuf **, int *);

extern int tiny_esp_schedule(const struct tiny_esp_algorithm *,
							 struct tiny_ipsec_db *);
extern int tiny_esp_auth(tinybuf *, SIZE_T, SIZE_T,
						 struct tiny_ipsec_db *, U_CHAR *);


#endif /*_TINYIPV6_TINY_ESP_H_*/

/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
