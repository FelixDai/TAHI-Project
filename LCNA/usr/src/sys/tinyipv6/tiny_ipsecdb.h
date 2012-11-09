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

/*	$Id: tiny_ipsecdb.h,v 1.1 2002/05/29 13:31:10 fujita Exp $	*/


#ifndef _TINYIPV6_TINY_IPSECDB_H_
#define _TINYIPV6_TINY_IPSECDB_H_


struct tiny_ipsec_db {
	U_INT32_T	sa_lt;			/* lifetime as SA */
#define	TINY_IPSEC_PARAM_LT_INVALID		0			/* invalid as SA */
#define	TINY_IPSEC_PARAM_LT_INFINITE	0xffffffff	/* infinite as SA */

	U_INT32_T	seq;			/* sequence number for SA */

	U_INT32_T	spi;			/* SPI */

	U_INT8_T	spi_valid;		/* valid flag as SA */
#define	TINY_IPSEC_PARAM_SPI_NONE	0
#define	TINY_IPSEC_PARAM_SPI_VALID	1

	U_INT8_T	outpolicy;		/* policy on output */
	U_INT8_T	inpolicy;		/* policy on input */
#define	TINY_IPSEC_PARAM_POLICY_PASS		0
#define	TINY_IPSEC_PARAM_POLICY_DISCARD		1
#define	TINY_IPSEC_PARAM_POLICY_ESP			2
#define	TINY_IPSEC_PARAM_POLICY_ESP_AUTH	3

	U_INT8_T	proto;			/* protocol */
#define	TINY_IPSEC_PARAM_PROTO_TCP	IPPROTO_TCP
#define	TINY_IPSEC_PARAM_PROTO_UDP	IPPROTO_UDP
#define	TINY_IPSEC_PARAM_PROTO_ANY	IPPROTO_IP

	struct in6_addr	s_peeraddr;	/* peer ipv6 address at send */
	struct in6_addr	r_peeraddr;	/* peer ipv6 address at recv */
	U_INT8_T	s_peeraddr_len;	/* peer ipv6 prefix length at send */
	U_INT8_T	r_peeraddr_len;	/* peer ipv6 prefix length at recv */

	U_INT8_T	s_myself;		/* my address at send */
	U_INT8_T	r_myself;		/* my address at recv */
#define	TINY_IPSEC_PARAM_MYSELF_LINKLOCAL	0x01
#define	TINY_IPSEC_PARAM_MYSELF_SITELOCAL	0x02
#define	TINY_IPSEC_PARAM_MYSELF_GLOBAL		0x04
#define	TINY_IPSEC_PARAM_MYSELF_ALL	\
	(TINY_IPSEC_PARAM_MYSELF_LINKLOCAL | \
	 TINY_IPSEC_PARAM_MYSELF_SITELOCAL | \
	 TINY_IPSEC_PARAM_MYSELF_GLOBAL)

	U_INT16_T	s_sport_l;		/* lower limit of srcport at send */
	U_INT16_T	s_sport_u;		/* upper limit of srcport at send */

	U_INT16_T	r_sport_l;		/* lower limit of srcport at recv */
	U_INT16_T	r_sport_u;		/* upper limit of srcport at recv */

	U_INT16_T	s_dport_l;		/* lower limit of dstport at send */
	U_INT16_T	s_dport_u;		/* upper limit of dstport at send */

	U_INT16_T	r_dport_l;		/* lower limit of dstport at recv */
	U_INT16_T	r_dport_u;		/* upper limit of dstport at recv */

	U_INT8_T	esp_alg;		/* esp algorithm */
#define	TINY_IPSEC_PARAM_ESP_ALG_NULL		0
#define	TINY_IPSEC_PARAM_ESP_ALG_DES		1
#define	TINY_IPSEC_PARAM_ESP_ALG_3DES		2
#define	TINY_IPSEC_PARAM_ESP_ALG_RIJNDEAL	3

	U_INT8_T	esp_auth_alg;	/* esp auth algorithm */
#define	TINY_IPSEC_PARAM_ESP_AUTH_ALG_NONE		0
#define	TINY_IPSEC_PARAM_ESP_AUTH_ALG_HMAC_MD5	1
#define	TINY_IPSEC_PARAM_ESP_AUTH_ALG_HMAC_SHA	2

	U_INT16_T	esp_key;		/* offset for esp key data */
	U_INT16_T	esp_sched;		/* offset for esp scheduled area */
	U_INT16_T	esp_auth_key;	/* offset for esp auth key data */
};


struct tiny_ipsec_db_searchkey {
	U_INT32_T	spi;		/* SPI */

	U_INT16_T	s_sport;	/* srcport at send */
	U_INT16_T	s_dport;	/* dstport at send */

	U_INT16_T	r_sport;	/* srcport at recv */
	U_INT16_T	r_dport;	/* dstport at recv */

	struct in6_addr s_peeraddr;	/* peer ipv6 address at send */
	struct in6_addr r_peeraddr;	/* peer ipv6 address at recv */

	U_INT8_T	s_myself;	/* my address at send */
	U_INT8_T	r_myself;	/* my address at recv */

	U_INT8_T	proto;		/* protocol */

	U_INT8_T	spi_valid;	/* valid flag as SA */

	U_INT8_T	dir;						/* packet direction */
#define TINY_IPSEC_QUERY_DIR_OUT	0x01	/* packet direction is out */
#define TINY_IPSEC_QUERY_DIR_IN		0x02	/* packet direction is in */

	U_INT16_T	mask;						/* mask for search item */
#define TINY_IPSEC_QUERY_MASK_SPI       0x01 /* use SPI */
#define TINY_IPSEC_QUERY_MASK_S_IPADR   0x02 /* use dst ipaddr, src/dst port at send */
#define TINY_IPSEC_QUERY_MASK_R_IPADR   0x04 /* use src ipaddr, src/dst port at recv */
#define TINY_IPSEC_QUERY_MASK_PROTO     0x08 /* use proto */
#define TINY_IPSEC_QUERY_MASK_S_MYSELF  0x10 /* use MYSELF at send*/
#define TINY_IPSEC_QUERY_MASK_R_MYSELF  0x20 /* use MYSELF at recv*/
};


struct tiny_ipsec_key {
	U_INT16_T	len;
	U_INT8_T	key[0];
};


#define TINY_IPSECDB_SPACE	2048	/* XXX : temporary */


struct tiny_ipsec_repository {
	union {
		struct {
			U_INT32_T _num_entry;
			U_CHAR _head[1];
		} _header;
		U_CHAR _data[TINY_IPSECDB_SPACE];
	} _db;
#define db_num_entry	_db._header._num_entry
#define db_head			_db._header._head
#define db_data			_db._data
};


extern TinyBool tiny_ipsec_init_done;


extern int tiny_ipsec_key_bits(U_INT16_T off);
extern int tiny_ipsec_key_len(U_INT16_T off);
extern U_INT8_T *tiny_ipsec_key_buf(U_INT16_T off);
extern U_INT8_T *tiny_ipsec_sched(U_INT16_T off);
extern TinyBool tiny_ipsec_db_search(struct tiny_ipsec_db_searchkey *key,
									  struct tiny_ipsec_db **dbentry);

extern void tiny_ipsecdb_init(void);
extern int tiny_ipsecdb_read(void *buf, int bufsiz);
extern int tiny_ipsecdb_write(void *buf, int bufsiz);


#endif	/* _TINYIPV6_TINY_IPSECDB_H_ */


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
