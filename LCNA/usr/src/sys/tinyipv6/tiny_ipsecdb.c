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

/*	$Id: tiny_ipsecdb.c,v 1.1 2002/05/29 13:31:08 fujita Exp $	*/

#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_in.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_addr.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_utils.h>


static struct tiny_ipsec_repository tiny_ipsec_repository;
TinyBool tiny_ipsec_init_done = TinyFalse;


int
tiny_ipsec_key_bits(U_INT16_T off)
{
	TINY_FUNC_NAME(tiny_ipsec_key_bits);
	struct tiny_ipsec_key *kp;
	if (off > sizeof(tiny_ipsec_repository)) {
		TINY_FATAL_ERROR("%s : offset overrun %d\n", funcname, off);
		return -1;
	}
	kp = (struct tiny_ipsec_key *)((CADDR_T)&tiny_ipsec_repository + off);
	return (int)(kp->len);
}


int
tiny_ipsec_key_len(U_INT16_T off)
{
	TINY_FUNC_NAME(tiny_ipsec_key_len);
	if (off > sizeof(tiny_ipsec_repository)) {
		TINY_FATAL_ERROR("%s : offset overrun (%d)\n", funcname, off);
		return -1;
	}
	return (tiny_ipsec_key_bits(off) >> 3);
}


U_INT8_T *
tiny_ipsec_key_buf(U_INT16_T off)
{
	TINY_FUNC_NAME(tiny_ipsec_key_buf);
	struct tiny_ipsec_key *kp;
	if (off > sizeof(tiny_ipsec_repository)) {
		TINY_FATAL_ERROR("%s : offset overrun (%d)\n", funcname, off);
		return NULL;
	}
	kp = (struct tiny_ipsec_key *)((CADDR_T)&tiny_ipsec_repository + off);
	return kp->key;
}


U_INT8_T *
tiny_ipsec_sched(U_INT16_T off)
{
	TINY_FUNC_NAME(tiny_ipsec_sched);
	if (off > sizeof(tiny_ipsec_repository)) {
		TINY_FATAL_ERROR("%s : offset overrun (%d)\n", funcname, off);
		return NULL;
	}
	return  (U_INT8_T *)((CADDR_T)&tiny_ipsec_repository + off);
}


TinyBool
tiny_ipsec_db_search(struct tiny_ipsec_db_searchkey *key,
					 struct tiny_ipsec_db **dbentry)
{
	TINY_FUNC_NAME(tiny_ipsec_db_search);
	int i;
	TinyBool rv = TinyFalse;
	struct tiny_ipsec_db *db
		= (struct tiny_ipsec_db *)tiny_ipsec_repository.db_head;
	U_INT16_T mask = key->mask;
	TIME_T curr_time = tiny_get_systime();
	if (mask == 0) {
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : no mask in key\n", funcname);
		goto end;
	}
	TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : num entry = %d\n", funcname,
				 tiny_ipsec_repository.db_num_entry);
	for (i = 0; i < tiny_ipsec_repository.db_num_entry; i ++, db ++) {
		if ((CADDR_T)db > ((CADDR_T)&tiny_ipsec_repository
						   + sizeof(tiny_ipsec_repository))) {
			TINY_LOG_MSG(TINY_LOG_ERR, "%s : entry[%d] is out of bound\n",
						 funcname, i);
			break;
		}
		if ((db->sa_lt != TINY_IPSEC_PARAM_LT_INFINITE)
			&& (db->sa_lt < curr_time)) {
			db->spi_valid = TINY_IPSEC_PARAM_SPI_NONE;
			TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
						 "has invalid lifetime, no match\n", funcname, i);
			continue;
		}
		if (mask & TINY_IPSEC_QUERY_MASK_SPI) {
			if (key->spi_valid == TINY_IPSEC_PARAM_SPI_VALID) {
				if (db->spi_valid != TINY_IPSEC_PARAM_SPI_VALID) {
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
								 "has invalid spi, no match\n", funcname, i);
					continue;
				}
				if (db->spi != key->spi) {
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
								 "spi not match db(%d) != key(%d)\n",
								 funcname, i, db->spi, key->spi);
					continue;
				}
			}
			else {	/* key->ipsec_spi_valid == TINY_IPSEC_PARAM_SPI_NONE */
				if (db->spi_valid != TINY_IPSEC_PARAM_SPI_NONE) {
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
								 "spi db(not vaild), spi key(valid)\n",
								 funcname, i);
					continue;
				}
			}
		}
		if (mask & TINY_IPSEC_QUERY_MASK_PROTO) {
			if (!((db->proto == TINY_IPSEC_PARAM_PROTO_ANY)
				  || (db->proto == key->proto))) {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
							 "protocol not match, db(%d) != key(%d)\n",
							 funcname, i, db->proto, key->proto);
				continue;
			}
		}
		if (mask & TINY_IPSEC_QUERY_MASK_S_IPADR) {
			if (tiny_addr_prefix_equal(&key->s_peeraddr, &db->s_peeraddr,
									   db->s_peeraddr_len) == TinyFalse) {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
							 "send address not match\n", funcname, i);
				TINY_LOG_MSG(TINY_LOG_DEBUG, "db->s_peeraddr = %s : "
							 "key->s_peeraddr = %s\n",
							 tiny_ip6_sprintf(&db->s_peeraddr),
							 tiny_ip6_sprintf(&key->s_peeraddr));
				continue;
			}
			if ((key->proto == TINY_IPSEC_PARAM_PROTO_TCP)
				|| (key->proto == TINY_IPSEC_PARAM_PROTO_UDP)) {
				if (((key->s_sport < db->s_sport_l)
					 || (key->s_sport > db->s_sport_u))
					|| ((key->s_dport < db->s_dport_l)
						|| (key->s_dport > db->s_dport_u))) {
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
								 "send port not match\n", funcname, i);
					TINY_LOG_MSG(TINY_LOG_DEBUG, "db->s_peeraddr = %s : "
								 "key->s_peeraddr = %s\n",
								 tiny_ip6_sprintf(&db->s_peeraddr),
								 tiny_ip6_sprintf(&key->s_peeraddr));
					TINY_LOG_MSG(TINY_LOG_DEBUG, "db->s_sport = (%d, %d) : "
								 "key->s_sport = %d\n",	db->s_sport_l,
								 db->s_sport_u, key->s_sport);
					TINY_LOG_MSG(TINY_LOG_DEBUG, "db->s_dport = (%d, %d) : "
								 "key->s_dport = %d\n", db->s_dport_l,
								 db->s_dport_u, key->s_dport);
					continue;
				}
			}
		}
		else if (mask & TINY_IPSEC_QUERY_MASK_R_IPADR) {
			if (tiny_addr_prefix_equal(&key->r_peeraddr, &db->r_peeraddr,
									   db->r_peeraddr_len) == TinyFalse) {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
							 "recv address not match\n", funcname, i);
				TINY_LOG_MSG(TINY_LOG_DEBUG, "db->r_peeraddr = %s : "
							 "key->r_peeraddr = %s\n",
							 tiny_ip6_sprintf(&db->r_peeraddr),
							 tiny_ip6_sprintf(&key->r_peeraddr));
				continue;
			}
			if ((key->proto == TINY_IPSEC_PARAM_PROTO_TCP)
				|| (key->proto == TINY_IPSEC_PARAM_PROTO_UDP)) {
				if (((key->r_sport < db->r_sport_l)
					 || (key->r_sport > db->r_sport_u))
					|| ((key->r_dport < db->r_dport_l)
						|| (key->r_dport > db->r_dport_u))) {
					TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
								 "recv port not match\n", funcname, i);
					TINY_LOG_MSG(TINY_LOG_DEBUG, "db->r_peeraddr = %s : "
								 "key->r_peeraddr = %s\n",
								 tiny_ip6_sprintf(&db->r_peeraddr),
								 tiny_ip6_sprintf(&key->r_peeraddr));
					TINY_LOG_MSG(TINY_LOG_DEBUG, "db->r_sport = (%d, %d) : "
								 "key->r_sport = %d\n", db->r_sport_l,
								 db->r_sport_u, key->r_sport);
					TINY_LOG_MSG(TINY_LOG_DEBUG, "db->r_dport = (%d, %d) : "
								 "key->r_dport = %d\n", db->r_dport_l,
								 db->r_dport_u, key->r_dport);
					continue;
				}
			}
		}
		if (mask & TINY_IPSEC_QUERY_MASK_S_MYSELF) {
			if ((db->s_myself & key->s_myself) == 0) {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
							 "(send) my addr not match\n", funcname, i);
				continue;
			}
		}
		else if (mask & TINY_IPSEC_QUERY_MASK_R_MYSELF) {
			if ((db->r_myself & key->r_myself) == 0) {
				TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : entry[%d] "
							 "(recv) my addr not match\n", funcname, i);
				continue;
			}
		}
		TINY_LOG_MSG(TINY_LOG_DEBUG, "%s : match entry[%d]\n", funcname, i);
		rv = TinyTrue;
		*dbentry = db;
		goto end;
	}		
 end:
	return rv;
}


void
tiny_ipsecdb_init(void)
{
	tiny_ipsec_init_done = 0;
	tiny_ipsec_repository.db_num_entry = 0;
}


int
tiny_ipsecdb_read(void *buf, int bufsiz)
{
	int size = sizeof(tiny_ipsec_repository);
	if (bufsiz < size) {
		return -1;
	}
	else {
		TINY_BCOPY(&tiny_ipsec_repository, buf, size);
		return size;
	}
}


int
tiny_ipsecdb_write(void *buf, int bufsiz)
{
	int size = sizeof(tiny_ipsec_repository);
	if (bufsiz < size) {
		return -1;
	}
	else {
		TINY_BCOPY(buf, &tiny_ipsec_repository, size);
		tiny_ipsec_init_done = 1;
		return size;
	}
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
