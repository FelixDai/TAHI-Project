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

/*
 * $Id: tiny_var.h,v 1.1 2002/05/29 13:30:30 fujita Exp $
 */


#ifndef _DEV_TINY_TINY_VAR_H_
#define _DEV_TINY_TINY_VAR_H_

#include <sys/ioctl.h>
#include <sys/types.h>

#define TINY_NEIGHBOR_CACHE		0
#define TINY_IPSEC_DB			1
#define TINY_DEFROUTER_LIST		2
#define TINY_PREFIX_LIST		3
#define TINY_IF_ADDRESS			4
#define TINY_BUFFER_STATUS		5

/* params */
struct tiny_sockopts {
	struct socket *so;
	int		code;
	void	*arg;
};


/* ioctl */
#define	TINY_RESET		_IO ('Y', 0)
#define	TINY_GHOSTVARS	_IOR('Y', 1, struct tiny_hostvars)
#define	TINY_SHOSTVARS	_IOW('Y', 2, struct tiny_hostvars)
#define	TINY_GSOCKOPTS	_IOR('Y', 3, struct tiny_sockopts)
#define	TINY_SSOCKOPTS	_IOW('Y', 4, struct tiny_sockopts)


#endif	/* _DEV_TINY_TINY_VAR_H_ */


/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
