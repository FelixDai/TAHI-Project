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
#include <string.h>
#include <stdlib.h>
#include <netdb.h>
#include <sys/param.h>
#include "PflowFlow.h"

extern int NUMERIC;
extern int WINDOW;
extern struct packets *pkt;
extern struct upper upp;

void tcp(char *line, int counter) {
    char *token = NULL;
    struct servent *dst_s = NULL;
    struct servent *src_s = NULL;

    if(strstr(line, "log:| | | | SourcePort                       = ") != NULL) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");

        upp.upp_x = atoi(token);
    }

    if(strstr(line, "log:| | | | DestinationPort                  = ") != NULL) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");

        upp.upp_y = atoi(token);

        strcpy(upp.upp_data, "TCP[");

        if(NUMERIC != 1) {
            src_s = getservbyport(htons(upp.upp_x), "tcp");
            if(src_s == NULL) {
                sprintf(upp.upp_data, "%s%d", upp.upp_data, upp.upp_x);
            } else {
                strcat(upp.upp_data, src_s->s_name);
            }
        } else {
            sprintf(upp.upp_data, "%s%d", upp.upp_data, upp.upp_x);
        }

        strcat(upp.upp_data, ",");

        if(NUMERIC != 1) {
            dst_s = getservbyport(htons(upp.upp_y), "tcp");
            if(dst_s == NULL) {
                sprintf(upp.upp_data, "%s%d", upp.upp_data, upp.upp_y);
            } else {
                strcat(upp.upp_data, dst_s->s_name);
            }
        } else {
            sprintf(upp.upp_data, "%s%d", upp.upp_data, upp.upp_y);
        }

        strcat(upp.upp_data, "]");
    }

    if(strcmp(line, "log:| | | | URGFlag                          = 0\n\0") == 0) {
        strcat(upp.upp_data, "[ ");
    }

    if(strcmp(line, "log:| | | | URGFlag                          = 1\n\0") == 0) {
        strcat(upp.upp_data, "[U");
        pkt[counter].pkt_clr = BLUE;
    }

    if(strcmp(line, "log:| | | | ACKFlag                          = 0\n\0") == 0) {
        strcat(upp.upp_data, " ");
    }

    if(strcmp(line, "log:| | | | ACKFlag                          = 1\n\0") == 0) {
        strcat(upp.upp_data, "A");
    }

    if(strcmp(line, "log:| | | | PSHFlag                          = 0\n\0") == 0) {
        strcat(upp.upp_data, " ");
    }

    if(strcmp(line, "log:| | | | PSHFlag                          = 1\n\0") == 0) {
        strcat(upp.upp_data, "P");
    }

    if(strcmp(line, "log:| | | | RSTFlag                          = 0\n\0") == 0) {
        strcat(upp.upp_data, " ");
    }

    if(strcmp(line, "log:| | | | RSTFlag                          = 1\n\0") == 0) {
        strcat(upp.upp_data, "R");
        pkt[counter].pkt_clr = BLUE;
    }

    if(strcmp(line, "log:| | | | SYNFlag                          = 0\n\0") == 0) {
        strcat(upp.upp_data, " ");
    }

    if(strcmp(line, "log:| | | | SYNFlag                          = 1\n\0") == 0) {
        strcat(upp.upp_data, "S");
        pkt[counter].pkt_clr = BLUE;
    }

    if(strcmp(line, "log:| | | | FINFlag                          = 0\n\0") == 0) {
        strcat(upp.upp_data, " ]");

        if(WINDOW != 1) {
            strcat(pkt[counter].pkt_analyze, upp.upp_data);
        }
    }

    if(strcmp(line, "log:| | | | FINFlag                          = 1\n\0") == 0) {
        strcat(upp.upp_data, "F]");
        pkt[counter].pkt_clr = BLUE;

        if(WINDOW != 1) {
            strcat(pkt[counter].pkt_analyze, upp.upp_data);
        }
    }

    if((WINDOW == 1) && (strstr(line, "log:| | | | Window                           = ") != NULL)) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");

        sprintf(upp.upp_data, "%s[w=%s]", upp.upp_data, &token[1]);
        strcat(pkt[counter].pkt_analyze, upp.upp_data);
    }

    return;
}
