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

/*	$Id: sysdep_utils.c,v 1.1 2002/05/29 13:30:44 fujita Exp $	*/


#include <sys/param.h>
#include <sys/kernel.h>
#include <sys/time.h>
#include <sys/callout.h>
#include <sys/malloc.h>
#include <sys/errno.h>
#include <sys/syslog.h>
#include <machine/stdarg.h>


#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/sysdep_utils.h>


void
tiny_log(int pri, char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	switch (pri) {
	case TINY_LOG_EMERG:
	case TINY_LOG_ALERT:
	case TINY_LOG_CRIT:
	case TINY_LOG_ERR:
	case TINY_LOG_WARNING:
	case TINY_LOG_NOTICE:
	case TINY_LOG_INFO:
	case TINY_LOG_DEBUG:
		log(pri, fmt, ap);
		break;
	default:
		break;
	}
	va_end(ap);
}


void
tiny_fatal_error(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	panic(fmt, ap);
	va_end(ap);
}


#define TINY_SYSMEM_TYPE	M_TEMP		/* XXX */


void *
tiny_sysmem_alloc(unsigned int size)
{
	return malloc((unsigned long)size, TINY_SYSMEM_TYPE, M_NOWAIT);
}


void
tiny_sysmem_free(void *ptr)
{
	free(ptr, TINY_SYSMEM_TYPE);
}


#define HALF_SEC_IN_MICROSEC 500000

TIME_T
tiny_get_systime(void)
{
	if (time.tv_usec >= HALF_SEC_IN_MICROSEC) {
		return (time.tv_sec + 1);
	}
	else {
		return time.tv_sec;
	}
}

#undef HALF_SEC_IN_MICROSEC


TINY_TIMER_HANDLE
tiny_timerhandle_alloc(void)
{
	struct callout *c;
	c = (struct callout *)tiny_sysmem_alloc(sizeof(struct callout));
	callout_init(c);
	return (TINY_TIMER_HANDLE)c;
}


void
tiny_timerhandle_free(TINY_TIMER_HANDLE handle)
{
	tiny_sysmem_free(handle);
}


void
tiny_set_timer(TINY_TIMER_HANDLE handle, int ms,
			   void (*func)(void *), void *arg)
{
	int ticks;
	ticks = ms * hz / 1000;
	callout_reset(handle, ticks, func, arg);
}


void
tiny_cancel_timer(TINY_TIMER_HANDLE handle)
{
	callout_stop(handle);
}


long
tiny_random(void)
{
	return random();
}


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
