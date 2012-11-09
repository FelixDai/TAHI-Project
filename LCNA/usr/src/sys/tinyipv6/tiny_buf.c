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

/*	$Id: tiny_buf.c,v 1.1 2002/05/29 13:30:49 fujita Exp $	*/


#include <sys/param.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/sysdep_spl.h>
#include <tinyipv6/sysdep_utils.h>


typedef enum  {
	TINYBUF_FREE = 0,
	TINYBUF_USED,
} tinybuf_stat;

typedef struct {
	tinybuf tbuf;
	tinybuf_stat stat;
} tinybuf_manage;

static tinybuf_manage *tinybuf_pool = NULL;


#if 0
#define TINY_BUFFER_LEAK_DEBUG
#endif

static int tinybuf_alloced;


void
tinybuf_pool_init(void)
{
	int i;
	PRILEV p;
	unsigned int size
		= (unsigned int)(sizeof(tinybuf_manage) * TINY_BUFNUM);

	p = SPLIMP();
	if (tinybuf_pool == NULL) {
		tinybuf_pool = (tinybuf_manage *)tiny_sysmem_alloc(size);
		if (tinybuf_pool == NULL) {
			TINY_FATAL_ERROR("Can't alloc buffer for tiny\n");
		}
	}
	for (i = 0; i < TINY_BUFNUM; i++) {
		tinybuf_pool[i].stat = TINYBUF_FREE;
	}
	tinybuf_alloced = 0;
	SPLX(p);
}


tinybuf *
tinybuf_alloc(void)
{
	tinybuf *tbuf = NULL;
	int i;
	PRILEV p;
	p = SPLIMP();
	if (tinybuf_pool == NULL) {
		tinybuf_pool_init();
	}
	for (i = 0; i < TINY_BUFNUM; i++) {
		if (tinybuf_pool[i].stat == TINYBUF_FREE) {
			tinybuf_pool[i].stat = TINYBUF_USED;
			tbuf = &tinybuf_pool[i].tbuf;
			tbuf->len = 0;
			tbuf->netif = NULL;
			tbuf->crypt_flag = TinyFalse;
			tbuf->auth_flag = TinyFalse;
			tinybuf_alloced ++;
#ifdef TINY_BUFFER_LEAK_DEBUG
			TINY_LOG_MSG(TINY_LOG_DEBUG,
						 "tinybuf_alloc() : tinybuf_alloced = %d\n",
						 tinybuf_alloced);
#endif
			break;
		}
	}
	SPLX(p);
	return tbuf;
}


void
tinybuf_free(tinybuf *tbuf)
{
	PRILEV p;
	p = SPLIMP();
	if ((tinybuf_pool != NULL) && (tbuf != NULL)) {
		int i;
		for (i = 0; i < TINY_BUFNUM; i ++) {
			if (&tinybuf_pool[i].tbuf == tbuf) {
				tinybuf_pool[i].stat = TINYBUF_FREE;
				tinybuf_alloced --;
#ifdef TINY_BUFFER_LEAK_DEBUG
				TINY_LOG_MSG(TINY_LOG_DEBUG,
							 "tinybuf_free() : tinybuf_alloced = %d\n",
							 tinybuf_alloced);
#endif
				break;
			}
		}
	}
	SPLX(p);
}


int
tinybuf_available(void)
{
	if (tinybuf_pool == NULL) {
		return 0;
	}
	else {
		return (TINY_BUFNUM - tinybuf_alloced);
	}
}


void
tinybuf_copy(tinybuf *src, tinybuf *dst)
{
	if ((src != NULL) && (dst != NULL)) {
		TINY_BCOPY(src, dst, sizeof(*src));
	}
}


int
tiny_print_buffer_status(char *buf, int buflen)
{
	int i;
	int len = 0;
	char tmpbuf[64];
	int l;
#define MSGCOPY								\
	do {									\
		if (buflen < len + l) {				\
			l = buflen - len;				\
		}									\
		TINY_BCOPY(tmpbuf, buf + len, l);	\
		len += l;							\
	} while (0)
	if (tinybuf_pool == NULL) {
		l = snprintf(tmpbuf, sizeof(tmpbuf), "buffer not initialized\n");
		MSGCOPY;
		return len;
	}
	l = snprintf(tmpbuf, sizeof(tmpbuf),
				 "USED %d/TOTAL %d\n", tinybuf_alloced, TINY_BUFNUM);
	MSGCOPY;
	for (i = 0; i < TINY_BUFNUM; i ++) {
		char *str;
		if (buflen <= len) {
			break;
		}
		if (tinybuf_pool[i].stat == TINYBUF_FREE) {
			str = "FREE";
		}
		else {
			str = "USED";
		}
		l = snprintf(tmpbuf, sizeof(tmpbuf), "[%d] %s\n", i, str);
		MSGCOPY;
	}
#undef MSGCOPY
	return len;
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
