/*
 * Copyright (C) 1999,2000 Yokogawa Electric Corporation and
 *                         YDC Corporation.
 * All rights reserved.
 * 
 * Redistribution and use of this software in source and binary
 * forms, with or without modification, are permitted provided that
 * the following conditions and disclaimer are agreed and accepted
 * by the user:
 * 
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with
 *    the distribution.
 * 
 * 3. Neither the names of the copyrighters, the name of the project
 *    which is related to this software (hereinafter referred to as
 *    "project") nor the names of the contributors may be used to
 *    endorse or promote products derived from this software without
 *    specific prior written permission.
 * 
 * 4. No merchantable use may be permitted without prior written
 *    notification to the copyrighters.
 * 
 * 5. The copyrighters, the project and the contributors may prohibit
 *    the use of this software at any time.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING
 * BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 * $Id: rip.h,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

/*
 * RIP version 1
 *
 *     0                   1                   2                   3 3
 *     0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 *    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *    | command (1)   | version (1)   |      must be zero (2)         |
 *    +---------------+---------------+-------------------------------+
 *    | address family identifier (2) |      must be zero (2)         |
 *    +-------------------------------+-------------------------------+
 *    |                         IP address (4)                        |
 *    +---------------------------------------------------------------+
 *    |                        must be zero (4)                       |
 *    +---------------------------------------------------------------+
 *    |                        must be zero (4)                       |
 *    +---------------------------------------------------------------+
 *    |                          metric (4)                           |
 *    +---------------------------------------------------------------+
 *                                    .
 *                                    .
 *                                    .
 *
 * RIP version 2
 *
 * 
 *  0                   1                   2                   3 3
 *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * | Command (1)   | Version (1)   |           unused              |
 * +---------------+---------------+-------------------------------+
 * | Address Family Identifier (2) |        Route Tag (2)          |
 * +-------------------------------+-------------------------------+
 * |                         IP Address (4)                        |
 * +---------------------------------------------------------------+
 * |                         Subnet Mask (4)                       |
 * +---------------------------------------------------------------+
 * |                         Next Hop (4)                          |
 * +---------------------------------------------------------------+
 * |                         Metric (4)                            |
 * +---------------------------------------------------------------+
 *
 */

struct rip {
    u_int8_t	rip_cmd;
    u_int8_t	rip_ver;
    u_int16_t	rip_zero;	/* ver. 1: must be zero, ver. 2: unused */
};

#define RIP_HDR_SIZE	4
char *rip_cmds[] = {
	NULL, "REQUEST", "RESPONSE", 
	"TRACEON", "TRACEOFF", "RESERVED"
};

struct rip_rte {
    u_int16_t	afid;
    u_int16_t	rtag;	/* ver. 1: must be zero */
    u_int32_t	rte;	/* advertise route */
    u_int32_t	subnet;	/* ver. 1: must be zero */
    u_int32_t	nxt;	/* ver. 1: must be zero */
    u_int32_t	metric;
};

#define RIP_RTE_SIZE	20

#define RIP_REQ		0x1
#define RIP_RSP		0x2
#define RIP_TON		0x3	/* trace on */
#define RIP_TOFF	0x4	/* trace off */
#define RIP_RSV		0x5	/* reserved */
