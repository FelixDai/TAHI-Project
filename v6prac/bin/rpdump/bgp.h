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
 * $Id: bgp.h,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

/* RFC1771
 *
 * BGP message header format
 *
 *     0                   1                   2                   3
 *     0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 *    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *    |                                                               |
 *    +                                                               +
 *    |                                                               |
 *    +                                                               +
 *    |                           Marker                              |
 *    +                                                               +
 *    |                                                               |
 *    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *    |          Length               |      Type     |
 *    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *
 * Length :
 *	unsigned integer in octets.
 * Type :
 *	1 - OPEN
 *	2 - UPDATE
 *	3 - NOTIFICATION
 *	4 - KEEPALIVE
 */

struct bgp_hdr {
    u_int8_t	marker[16];
    u_int16_t	length;
    u_int8_t	type;
};

#define BGP_HDR_SIZE		19

#define BGP_OPEN		0x1	/* open message */
#define BGP_UPDATE		0x2	/* update message */
#define BGP_NOTIFICATION	0x3	/* notifcation message */
#define BGP_KEEPALIVE		0x4	/* keepalive message */

char *bgp_types[] = {
    NULL, "OPEN", "UPDATE", "NOTIFICATION", "KEEPALIVE"
};

/* OPEN message format
 *
 *       0                   1                   2                   3
 *     0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 *     +-+-+-+-+-+-+-+-+
 *     |    Version    |
 *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *     |     My Autonomous System      |
 *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *     |           Hold Time           |
 *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *     |                         BGP Identifier                        |
 *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *     | Opt Parm Len  |
 *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *     |                                                               |
 *     |                       Optional Parameters                     |
 *     |                                                               |
 *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *
 * version :
 *	4
 *
 * optional parameters
 *
 *        0                   1
 *        0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
 *       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-...
 *       |  Parm. Type   | Parm. Length  |  Parameter Value (variable)
 *       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-...
 *
 */

struct bgp_open {
    u_int8_t	maker[16];
    u_int16_t	length;
    u_int8_t	type;
    u_int8_t	version;
    u_int16_t	as;
    u_int16_t	holdtime;
    u_int32_t	bgpid;
    u_int8_t	optlen;
};

#define BGP_OPEN_SIZE		29

struct bgp_open_opt {
    u_int8_t	parm_type;
    u_int8_t	parm_len;
};

/* UPDATE message format
 *
 *   Path Attributes
 *                 0                   1
 *              0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
 *             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *             |  Attr. Flags  |Attr. Type Code|
 *             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *
 */

struct bgp_update {
    u_int8_t	maker[16];
    u_int16_t	length;
    u_int8_t	type;
    u_int16_t	withdrawnlen;
};

#define BGP_WITHDRAWNLEN	2	/* Withdrawn routes length field */
#define BGP_PATHATTRLEN		2	/* Path attribute length field */

struct p_attr {
    u_int8_t attr_flags;
    u_int8_t attr_type;
    union {
        u_int8_t len;
        u_int16_t elen;
    } _p__len;
};

#define p_attr_len	_p__len.len
#define p_attr_elen	_p__len.elen

#define bgp_p_attr_len(p) \
        (((p)->attr_flags & 0x10) ? 1 : 0)

#define BGP_UP_ATTR_LEN		3	/* Path attrbute length */

#define BGP_UP_ORIGIN	0x1	/* origin */
#define BGP_UP_ASPATH	0x2	/* as_path */
#define BGP_UP_NXTHOP	0x3	/* next hop */
#define BGP_UP_MED	0x4	/* multi exit disk */
#define BGP_UP_PREF	0x5	/* local preference */
#define BGP_UP_ATMAGGR	0x6	/* atmic aggregate */
#define BGP_UP_AGGRGTR	0x7	/* aggregator */
#define BGP_UP_CMT	0x8	/* communities -RFC1997- */
#define BGP_UP_ORGNTR	0x9	/* originator id  -RFC1998- */
#define BGP_UP_CLSTR	0xa	/* cluster list -RFC1998- */
#define BGP_UP_MPNLRI	0xe	/* multiprotocol reachable NLRI -RFC2283- */
#define BGP_UP_MPUNLRI	0xf	/* multiprotocol unreachable NLRI -RFC2283- */

struct mp_nlri {
    u_int16_t afid;		/* Address Family Identifier */
    u_int8_t safid;		/* Subsequent Address Family Identifier */
    u_int8_t nxthoplen;		/* Length of Next Hop Network Address */
};

struct mp_un_nlri {
    u_int16_t afid;		/* Address Family Identifier */
    u_int8_t safid;		/* Subsequent Address Family Identifier */
};

#define MP_REACH_NLRI_LEN	4
#define MP_UNREACH_NLRI_LEN	3

char *bgp_up_origin[] = {
    "IGP", "EGP", "INCOMPLETE"
};

char *SAFIDs[]= {	/* Subsequent Address Family Identifier */
    NULL, "unicast", "multicast", "unicast & multicast"
};

/*
 * Notification message format
 *
 *      0                   1                   2                   3
 *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *     | Error code    | Error subcode |           Data                |
 *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                               +
 *     |                                                               |
 *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *
 * Error code :
 *	1 - Message Header Error
 *	2 - OPEN Message Error
 *	3 - UPDATE Message Error
 *	4 - Hold Timer Expired
 *	5 - Finite State Machine Error
 *	6 - Cease
 *
 * Error subcode :
 *	Message Header Error subcodes:
 *		1  - Connection Not Synchronized.
 *		2  - Bad Message Length.
 *		3  - Bad Message Type.
 *	OPEN Message Error subcodes:
 *		1  - Unsupported Version Number.
 *		2  - Bad Peer AS.
 *		3  - Bad BGP Identifier.
 *		4  - Unsupported Optional Parameter.
 *		5  - Authentication Failure.
 *		6  - Unacceptable Hold Time.
 *	UPDATE Message Error subcodes:
 *		1 - Malformed Attribute List.
 *		2 - Unrecognized Well-known Attribute.
 *		3 - Missing Well-known Attribute.
 *		4 - Attribute Flags Error.
 *		5 - Attribute Length Error.
 *		6 - Invalid ORIGIN Attribute
 *		7 - AS Routing Loop.
 *		8 - Invalid NEXT_HOP Attribute.
 *		9 - Optional Attribute Error.
 *		10 - Invalid Network Field.
 *		11 - Malformed AS_PATH.
 *
 */

struct bgp_notification {
    u_int8_t	maker[16];
    u_int16_t	length;
    u_int8_t	type;
    u_int8_t	code;
    u_int8_t	subcode;
};

char *bgp_err_code[] = {
    NULL, "Message Header Error", "OPEN Message Error",
    "UPDATE Message Error", "Hold Timer Expired",
    "Finite State Machine Error", "Cease"
};

char *bgp_err_subcode1[] = {
    NULL, "Connection Not Synchronized.",
    "Bad Message Length.", "Bad Message Type."
};

char *bgp_err_subcode2[] = {
    NULL, "Unsupported Version Number.",
    "Bad Peer AS.", "Bad BGP Identifier.",
    "Unsupported Optional Parameter.",
    "Authentication Failure.", "Unacceptable Hold Time."
};

char *bgp_err_subcode3[] = {
    NULL, "Malformed Attribute List.",
    "Unrecognized Well-known Attribute.",
    "Missing Well-known Attribute.",
    "Attribute Flags Error.", "Attribute Length Error.",
    "Invalid ORIGIN Attribute.", "AS Routing Loop.",
    "Invalid NEXT_HOP Attribute.", "Optional Attribute Error.",
    "Invalid Network Field.", "Malformed AS_PATH."
};
