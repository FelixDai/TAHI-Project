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

/*  $Id: tiny_conf.h,v 1.1 2002/05/29 13:30:51 fujita Exp $ */


#ifndef _TINYIPV6_TINY_CONF_H_
#define _TINYIPV6_TINY_CONF_H_


/*
 *  Interface definition
 */
#ifndef TINY_LOOPIF
#define TINY_LOOPIF    "lo0"			/* loopback interface name */
#endif

#ifndef TINY_PHYSIF
#define TINY_PHYSIF    "fxp0"			/* physical interface name */
#endif


#define TINY_IFNAMSIZ  16				/* Max length of interface name */


/*
 *	MTU for tiny
 */
#ifndef TINY_MTU
#define TINY_MTU       IPV6_MMTU       /* use IPv6 Minimum MTU as default */
#endif


/*
 *	Prefix length
 */
#define TINY_DEFAULT_PREFIX_LEN			64
#define TINY_LOOPBACK_GLOBAL_PREFIX_LEN	128


/*
 *	Buffer for tiny
 */
#define TINY_BUFLEN    1500				/* packet buffer size for tiny */
#define TINY_BUFNUM    8				/* number of packet buffer */


/*
 *	Table size for tiny
 */
#define TINY_ND_DRLST_SIZ		4		/* table size for default router */
#define TINY_ND_PRLST_SIZ   	8		/* table size for prefix */
#define TINY_ND_NBRLST_SIZ		16		/* table size for neighbor cache */


extern U_INT32_T    LinkMTU;
extern U_INT8_T     CurHopLimit;
extern U_INT32_T    BaseReachableTime;
extern U_INT32_T    ReachableTime;
extern U_INT32_T    RetransTimer;


struct tiny_hostvars {
	U_INT32_T	LinkMTU;
	U_INT32_T	BaseReachableTime;
	U_INT32_T	ReachableTime;
	U_INT32_T	RetransTimer;
	U_INT8_T	CurHopLimit;
};


extern void tiny_get_hostvars(struct tiny_hostvars *hv);
extern void tiny_set_hostvars(struct tiny_hostvars *hv);


#endif  /*  _TINYIPV6_TINY_CONF_H_  */


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/

