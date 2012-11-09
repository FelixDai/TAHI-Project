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
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "PflowFlow.h"

extern struct packets *pkt;

int next_header(char *line, int counter, int status) {
    char *token = NULL;
    int nxt_hdr = 0;

    if(strstr(line, "log:| | | NextHeader                       = ") != NULL) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");
        nxt_hdr = atoi(token);

        if(status == 0) {
            memset(pkt[counter].pkt_analyze, 0, sizeof(pkt[counter].pkt_analyze));
        }

        switch(nxt_hdr) {
            case 0:
                strcat(pkt[counter].pkt_analyze, "H,");
                break;
            case 4:
                strcat(pkt[counter].pkt_analyze, "IPv4");
                break;
            case 6:
                break;
            case 17:
                break;
            case 41:
                strcat(pkt[counter].pkt_analyze, "IPv6");
                break;
            case 43:
                strcat(pkt[counter].pkt_analyze, "R,");
                break;
            case 44:
                break;
            case 50:
                break;
            case 51:
                strcat(pkt[counter].pkt_analyze, "A,");
                break;
            case 58:
                break;
            case 59:
                strcat(pkt[counter].pkt_analyze, "NoNextHeader");
                break;
            case 60:
                strcat(pkt[counter].pkt_analyze, "D,");
                break;
            case 103:
                strcat(pkt[counter].pkt_analyze, "PIM");
                break;
            default:
                strcat(pkt[counter].pkt_analyze, "N/A");
        }

        return(nxt_hdr);
    }

    return(-1);
}
