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
 * $Id: ripng.c,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

#include "general.h"
#include "ripng.h"

/* RIPng */
void
ripng(struct pktinfo *pktinfo)
{
    struct ripng *ripng = NULL;
    struct ripng_rte *rte = NULL;
    const u_char *pkt = pktinfo->pkt;
    u_int len = pktinfo->len;
    char *rte_addr = NULL;

    if (len < sizeof(struct ripng)) {
        (void)printf("%s", t_stamp);
        (void)printf("%s\n", addr);
        printf("packet capture error\n");
    }
    else {
        ripng = (struct ripng *)pkt;

        (void)printf("%s", t_stamp);
        (void)printf("%s\n", addr);
        RIPng_counter ++;
        if (ripng->ripng_cmd > 2 || ripng->ripng_cmd == 0) {
            if (vflag) {
                (void)printf("RIPng: version %d\n", ripng->ripng_ver);
                (void)printf("     : command %d \"Invalid command\"\n", ripng->ripng_cmd);
            }
            else {
                (void)printf("RIPng: Invalid command %d\n", ripng->ripng_cmd);
            }
        }
        else {
            if (vflag) {
                (void)printf("RIPng: version %d\n", ripng->ripng_ver);
                (void)printf("     : command %d \"%s\"\n", ripng->ripng_cmd, ripng_cmds[ripng->ripng_cmd]);
            }
            else {
                (void)printf("RIPNG: %s\n", ripng_cmds[ripng->ripng_cmd]);
            }
            len -= sizeof(struct ripng);
            pkt += sizeof(struct ripng);

            if (len >= sizeof(struct ripng_rte)) {

                if (ripng->ripng_cmd == RIPNG_RSP)
                    (void)printf("Routing Table Entry\n");
                else
                    (void)printf("Request Routes\n");

                while (len > 0) {			/* Routing Table Entry */
                    rte = (struct ripng_rte *)pkt;

                    rte_addr = addr6_string(&rte->rte);

                    if (rte->metric == 16 && ripng->ripng_cmd == RIPNG_REQ) {
                        if (rte->prefix != 0 || strcmp(rte_addr, "::") == 0) {
                            (void)printf("Invalid value.\n"); 
                            (void)printf("Prefix and prefix length must be zero.\n");
                            (void)printf("%s/%d\tmetric = %d\n", rte_addr,
					rte->prefix, rte->metric);
                        }
                        else {
                            (void)printf("entire routing table\n");
                        }
                    }
                    else if (rte->metric == 255 && ripng->ripng_cmd == RIPNG_RSP) {
                        if (rte->rtag != 0 || rte->prefix != 0) {
                            (void)printf("Invalid value.\n"); 
                            (void)printf("The route tag and prefix length must be zero.\n");
                            (void)printf("%s/%d\tmetric = %d route tag = %d\n", rte_addr,
				    rte->prefix, rte->metric, htons(rte->rtag));
                        }
                        else {
                            (void)printf("Next Hop  %s\n", rte_addr);
                        }
                    }
                    else {
                        (void)printf("%s/%d\tmetric = %d  route tag = %d\n", rte_addr,
				rte->prefix, rte->metric, htons(rte->rtag));
                    }

                    len -= sizeof(struct ripng_rte);
                    pkt += sizeof(struct ripng_rte);
                } /* end of while */
            }
        }
    }
    (void)printf("\n");
}/* end of ripng */
