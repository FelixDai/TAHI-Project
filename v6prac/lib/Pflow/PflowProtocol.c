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
extern struct upper upp;

int protocol(char *line, int counter, int status) {
    char *token = NULL;
    int nxt_prtcl = 0;

    if((strstr(line, "log:| | | MF                               = ") != NULL) ||
       (strstr(line, "log:| | | Flags                            = ") != NULL)) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");
        upp.upp_x = atoi(token);
    }

    if(strstr(line, "log:| | | FragmentOffset                   = ") != NULL) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");
        upp.upp_y = atoi(token);
    }

    if(strstr(line, "log:| | | Protocol                         = ") != NULL) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");
        nxt_prtcl = atoi(token);

        if(status == 0) {
            memset(pkt[counter].pkt_analyze, 0, sizeof(pkt[counter].pkt_analyze));
        }

        switch(nxt_prtcl) {
            case 1:
                strcpy(upp.upp_data, "ICMPv4");
                break;
            case 4:
                strcpy(upp.upp_data, "IPv4");
                break;
            case 6:
                strcpy(upp.upp_data, "TCP");
                break;
            case 17:
                strcpy(upp.upp_data, "UDP");
                break;
            case 41:
                strcpy(upp.upp_data, "IPv6");
                break;
            default:
                strcpy(upp.upp_data, "N/A");
        }

        if((upp.upp_x == 0) && (upp.upp_y == 0)) {
            switch(nxt_prtcl) {
                case 1:
                case 6:
                case 17:
                    break;
                default:
                    strcpy(pkt[counter].pkt_analyze, upp.upp_data);
            }

            return(nxt_prtcl);
        } else if ((upp.upp_x == 1) && (upp.upp_y == 0)) {
            strcpy(pkt[counter].pkt_analyze, "frag(");
            strcat(pkt[counter].pkt_analyze, upp.upp_data);
            strcat(pkt[counter].pkt_analyze, ")");
        } else if ((upp.upp_x == 1) && (upp.upp_y != 0)) {
            strcpy(pkt[counter].pkt_analyze, "frag(");
            strcat(pkt[counter].pkt_analyze, upp.upp_data);
            strcat(pkt[counter].pkt_analyze, ")[M]");
        } else if ((upp.upp_x == 0) && (upp.upp_y != 0)) {
            strcpy(pkt[counter].pkt_analyze, "frag(");
            strcat(pkt[counter].pkt_analyze, upp.upp_data);
            strcat(pkt[counter].pkt_analyze, ")[E]");
        }
    }

    return(-1);
}
