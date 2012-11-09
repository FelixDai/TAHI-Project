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
#include "PflowFlow.h"

extern int IDENTIFIER;
extern struct packets *pkt;
extern struct upper upp;

void icmpv6(char *line, int counter) {
    char *token = NULL;

    if(strstr(line, "log:| | | Type                             = ") != NULL) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");

        upp.upp_x = atoi(token);
    }

    if(strstr(line, "log:| | | Code                             = ") != NULL) {
        token = strtok(line, "=");
        token = strtok(NULL, "\n");

        upp.upp_y = atoi(token);

        if((upp.upp_x != -1) && (upp.upp_y != -1)) {
            switch(upp.upp_x) {
                case 1:
                    strcpy(upp.upp_data, "DstUnreachable");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 2:
                    strcpy(upp.upp_data, "PktTooBig");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 3:
                    strcpy(upp.upp_data, "TimeExceeded");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 4:
                    strcpy(upp.upp_data, "ParamProblem");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 128:
                    strcpy(upp.upp_data, "EchoRequest");
                    break;
                case 129:
                    strcpy(upp.upp_data, "EchoReply");
                    break;
                case 130:
                    strcpy(upp.upp_data, "MLDQuery");
                    break;
                case 131:
                    strcpy(upp.upp_data, "MLDReport");
                    break;
                case 132:
                    strcpy(upp.upp_data, "MLDDone");
                    break;
                case 133:
                    strcpy(upp.upp_data, "RS");
                    pkt[counter].pkt_clr = RED;
                    break;
                case 134:
                    strcpy(upp.upp_data, "RA");
                    pkt[counter].pkt_clr = RED;
                    break;
                case 135:
                    strcpy(upp.upp_data, "NS");
                    pkt[counter].pkt_clr = RED;
                    break;
                case 136:
                    strcpy(upp.upp_data, "NA");
                    pkt[counter].pkt_clr = RED;
                    break;
                case 137:
                    strcpy(upp.upp_data, "Redirect");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 138:
                    strcpy(upp.upp_data, "RouterRenumbering");
                    break;
                case 139:
                    strcpy(upp.upp_data, "NIQuery");
                    break;
                case 140:
                    strcpy(upp.upp_data, "NIReply");
                    break;
                case 255:
                    if(IDENTIFIER == 1) {
                        memset(pkt[counter].pkt_analyze, 0, sizeof(pkt[counter].pkt_analyze));
                        sprintf(upp.upp_data, "ACTION %03d", upp.upp_y);
                        pkt[counter].pkt_clr = TEAL;
                    } else {
                        sprintf(upp.upp_data, "ICMPv6[T:%d,C:%d]", upp.upp_x, upp.upp_y);
                    }

                    break;
                default:
                    sprintf(upp.upp_data, "ICMPv6[T:%d,C:%d]", upp.upp_x, upp.upp_y);
            }

            strcat(pkt[counter].pkt_analyze, upp.upp_data);
        }
    }

    return;
}
