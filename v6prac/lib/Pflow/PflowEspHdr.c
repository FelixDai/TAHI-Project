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

void esp_hdr(char *line, int counter, int status) {
    char *token = NULL;
    int nxt_hdr = 0;

    if(strstr(line, "log:| | | | NextHeader                       = ") != NULL) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");
        nxt_hdr = atoi(token);

        if(status == 0) {
            memset(pkt[counter].pkt_analyze, 0, sizeof(pkt[counter].pkt_analyze));
        }

        switch(nxt_hdr) {
            case 0:
                strcpy(upp.upp_data, "E,HBH");
                break;
            case 4:
                strcpy(upp.upp_data, "E,IPv4");
                break;
            case 6:
                strcpy(upp.upp_data, "E,TCP");
                break;
            case 17:
                strcpy(upp.upp_data, "E,UDP");
                break;
            case 41:
                strcpy(upp.upp_data, "E,IPv6");
                break;
            case 43:
                strcpy(upp.upp_data, "E,RH");
                break;
            case 44:
                strcpy(upp.upp_data, "E,FH");
                break;
            case 50:
                strcpy(upp.upp_data, "E,ESP");
                break;
            case 51:
                strcpy(upp.upp_data, "E,AH");
                break;
            case 58:
                strcpy(upp.upp_data, "E,ICMPv6");
                break;
            case 59:
                strcpy(upp.upp_data, "E,NoNextHeader");
                break;
            case 60:
                strcpy(upp.upp_data, "E,DH");
                break;
            case 103:
                strcpy(upp.upp_data, "E,PIM");
                break;
            default:
                strcpy(upp.upp_data, "E,N/A");
        }

        strcat(pkt[counter].pkt_analyze, upp.upp_data);
    }
    return;
}
