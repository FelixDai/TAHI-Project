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

/*	$Id: sysdep_utils.h,v 1.1 2002/05/29 13:30:45 fujita Exp $	*/


#ifndef	_TINYIPV6_SYSDEP_UTILS_H_
#define	_TINYIPV6_SYSDEP_UTILS_H_


#include <sys/types.h>
#include <sys/systm.h>
#include <sys/errno.h>
#include <sys/syslog.h>


#define TINY_BZERO(addr, size)			bzero(addr, size)
#define TINY_BCOPY(src, dst, size)		bcopy(src, dst, size)
#define TINY_BCMP(addr1, addr2, size)	bcmp(addr1, addr2, size)
#define TINY_STRLEN(str)				strlen(str)
#define TINY_STRNCMP(str1, str2, len)	strncmp(str1, str2, len)


#define TINY_FUNC_NAME(FUNC)	char *funcname = #FUNC
#if 0
#define TINY_FUNC_NAME(FUNC)	/* none */
#endif

#if 0
#define TINY_LOG_MSG	tiny_log
#else
#define	TINY_LOG_MSG	log
#endif

void tiny_log(int pri, char *fmt, ...);


#define TINY_LOG_EMERG		LOG_EMERG	/* system is unusable */
#define TINY_LOG_ALERT		LOG_ALERT	/* action must be taken immediately */
#define TINY_LOG_CRIT		LOG_CRIT	/* critical conditions */
#define TINY_LOG_ERR		LOG_ERR		/* error conditions */
#define TINY_LOG_WARNING	LOG_WARNING	/* warning conditions */
#define TINY_LOG_NOTICE		LOG_NOTICE	/* normal but significant condition */
#define TINY_LOG_INFO		LOG_INFO	/* informational */
#define TINY_LOG_DEBUG		LOG_DEBUG	/* debug-level messages */


#define TINY_FATAL_ERROR		tiny_fatal_error


void tiny_fatal_error(const char *fmt, ...);


extern void *tiny_sysmem_alloc(unsigned int size);
extern void tiny_sysmem_free(void *ptr);


extern TIME_T tiny_get_systime(void);


typedef void *TINY_TIMER_HANDLE;

extern TINY_TIMER_HANDLE tiny_timerhandle_alloc(void);
extern void tiny_timerhandle_free(TINY_TIMER_HANDLE handle);

extern void tiny_set_timer(TINY_TIMER_HANDLE handle, int ms,
						   void (*func)(void *), void *arg);
extern void tiny_cancel_timer(TINY_TIMER_HANDLE handle);

extern long tiny_random(void);


#define TINY_RANDOM()	tiny_random()


#define	TINY_INLINE		__inline


#endif	/*	_TINYIPV6_SYSDEP_UTILS_H_	*/


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
