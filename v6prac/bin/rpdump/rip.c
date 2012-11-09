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
 * $Id: rip.c,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

#include "general.h"
#include "af.h"
#include "rip.h"

void
rip(struct pktinfo *pktinfo)
{
    struct rip *rip = NULL;
    struct rip_rte *rip_rte = NULL;
    const u_char *pkt = pktinfo->pkt;
    u_int len = pktinfo->len;

    if (len > RIP_HDR_SIZE) {
        (void)printf("%s", t_stamp);
        (void)printf("%s\n", addr);
        RIP_counter ++;
        rip = (struct rip *)pkt;
	if (rip->rip_cmd > 0 && rip->rip_cmd < 6) {
	    (void)printf("RIPv%d: %s\n", rip->rip_ver, rip_cmds[rip->rip_cmd]);
	    pkt += RIP_HDR_SIZE;
	    len -= RIP_HDR_SIZE;
            if (len >= RIP_RTE_SIZE) {
		if (rip->rip_cmd == 1)
		    (void)printf("Request Routes\n");
		else
		    (void)printf("Routing Table Entry\n");
		while (len > 0) {
		    rip_rte = (struct rip_rte *)pkt;
                    if (vflag) {
                        if (rip->rip_ver == 2)
                            (void)printf("%s, route tag = %d\n",
				af_numbers[htons(rip_rte->afid)], rip_rte->rtag);
                        if (rip->rip_ver == 1)
                            (void)printf("%s, mustbezero = %d\n",
				af_numbers[rip_rte->afid], rip_rte->rtag);
                    }
                    if (rip->rip_ver == 1) {
                        (void)printf("%s metric = %ld\n",
			    addr4_string(htonl(rip_rte->rte)),
			    htonl(rip_rte->metric));
                    }
                    else if (rip->rip_ver == 2) {
                        (void)printf("%s",
			    addr4_string(htonl(rip_rte->rte)));
                        (void)printf("/%s",
			    addr4_string(htonl(rip_rte->subnet)));
                        (void)printf("\tgw:%s",
			    addr4_string(htonl(rip_rte->nxt)));
                        (void)printf(" metric = %ld\n",
			    htonl(rip_rte->metric));
                    }

		    pkt += RIP_RTE_SIZE;
		    len -= RIP_RTE_SIZE;
		}
	    }
        }
	else {
	    (void)printf("RIP: Invalid command\n");
        }
    }
    (void)printf("\n");
}
