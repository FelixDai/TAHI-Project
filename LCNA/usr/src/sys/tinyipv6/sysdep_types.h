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

/*	$Id: sysdep_types.h,v 1.1 2002/05/29 13:30:44 fujita Exp $	*/

#ifndef	_TINYIPV6_SYSDEP_TYPES_H_
#define	_TINYIPV6_SYSDEP_TYPES_H_


#include <sys/param.h>
#include <sys/types.h>


typedef char		INT8_T;
typedef u_char		U_CHAR;		/* unsigned char			*/
typedef u_short		U_SHORT;	/* unsigned short			*/
typedef u_int		U_INT;		/* unsigned int				*/
typedef u_long		U_LONG;		/* unsigned long			*/
typedef u_int8_t	U_INT8_T;	/* unsigned 8 bit integer	*/
typedef u_int16_t	U_INT16_T;	/* unsigned 16 bit integer	*/
typedef u_int32_t	U_INT32_T;	/* unsigned 32 bit integer	*/
typedef u_quad_t	U_QUAD_T;	/* unsigned 64 bit integer	*/

typedef caddr_t		CADDR_T;	/* core address				*/

typedef size_t		SIZE_T;

typedef U_QUAD_T	STAT_T;		/* for statistics	*/
typedef long		TIME_T;


#endif	/*	_TINYIPV6_SYSDEP_TYPES_H_	*/


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
