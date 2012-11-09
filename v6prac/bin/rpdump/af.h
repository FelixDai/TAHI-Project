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
 * $Id: af.h,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

#define AF_INET         1       /* IP (IP version 4) */
#define AF_INET6        2       /* IP6 (IP version 6) */
#define AF_NSAP         3       /* NSAP */
#define AF_HDLC         4       /* HDLC (8-bit multidrop) */
#define AF_BBN          5       /* BBN 1822 */
#define AF_802          6       /* 802 (includes all 802 media plus Ethernet "canonical format") */
#define AF_E163         7       /* E.163 */
#define AF_E164         8       /* E.164 (SMDS, Frame Relay, ATM) */
#define AF_F69          9       /* F.69 (Telex) */
#define AF_X121         10      /* X.121 (X.25, Frame Relay) */
#define AF_IPX          11      /* IPX */
#define AF_ATALK        12      /* Appletalk */
#define AF_DECNET       13      /* Decnet IV */
#define AF_BANYAN       14      /* Banyan Vines */
#define AF_E164NSAP     15      /* E.164 with NSAP format subaddress */
#define AF_DNS          16      /* DNS (Domain Name System) */
#define AF_ASNO         18      /* AS Number */

static char *af_numbers[] = {
    NULL, "IP", "IPv6", "NSAP", "HDLC", "BBN", "802",
    "E.163", "E.164", "F.96", "X.121", "IPX", "Appletalk",
    "Decnet IV", "Banyan Vines", "E.164 with NSAP", "DNS", NULL, "AS Number"
};
