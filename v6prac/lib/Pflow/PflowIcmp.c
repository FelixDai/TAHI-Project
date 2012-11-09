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

void icmp(char *line, int counter) {
    FILE *action = NULL;
    char *token = NULL;
    char file_name[1024];

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
                case 0:
                    strcpy(upp.upp_data, "EchoReply");
                    break;
                case 3:
                    strcpy(upp.upp_data, "DstUnreachable");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 4:
                    strcpy(upp.upp_data, "SrcQuench");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 5:
                    strcpy(upp.upp_data, "Redirect");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 8:
                    strcpy(upp.upp_data, "Echo");
                    break;
                case 11:
                    strcpy(upp.upp_data, "TimeExceeded");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 12:
                    strcpy(upp.upp_data, "ParamProblem");
                    pkt[counter].pkt_clr = GREEN;
                    break;
                case 13:
                    strcpy(upp.upp_data, "Timestamp");
                    break;
                case 14:
                    strcpy(upp.upp_data, "TimestampReply");
                    break;
                case 15:
                    strcpy(upp.upp_data, "InfoRequest");
                    break;
                case 16:
                    strcpy(upp.upp_data, "InfoReply");
                    break;
                case 17:
                    strcpy(upp.upp_data, "AddrMaskRequest");
                    break;
                case 18:
                    strcpy(upp.upp_data, "AddrMaskReply");
                    break;
                case 255:
                    if(IDENTIFIER == 1) {
                        sprintf(upp.upp_data, "ACTION %03d", upp.upp_y);
                        pkt[counter].pkt_clr = TEAL;

                        sprintf(file_name, "action-%03d.html", upp.upp_y);
                        action = fopen(file_name, "w");
                        if(action == NULL) {
                            perror(file_name);
                            exit(1);
                        }

                        fprintf(action, "<HTML>\n");
                        fprintf(action, "<HEAD>\n");
                        fprintf(action, "<TITLE>");
                        fprintf(action, "flow v.%s", DATE);
                        fprintf(action, "</TITLE>\n");
                        fprintf(action, "</HEAD>\n");
                        fprintf(action, "<FRAMESET ROWS=\"70%%,30%%\">\n");
                        fprintf(action,
                                "<FRAME SRC=\"./body-%02d.html#%05d\" NAME=\"body\">\n",
                                (counter + 1) / 1000,
                                counter + 1);
                        fprintf(action, "<FRAME SRC=\"./footer.html\">\n");
                        fprintf(action, "</FRAMESET>\n");
                        fprintf(action, "</HTML>\n");
                        fclose(action);
                    } else {
                        sprintf(upp.upp_data, "ICMPv4[T:%d,C:%d]", upp.upp_x, upp.upp_y);
                    }

                    break;
                default:
                    sprintf(upp.upp_data, "ICMPv4[T:%d,C:%d]", upp.upp_x, upp.upp_y);
            }

            strcpy(pkt[counter].pkt_analyze, upp.upp_data);
        }
    }

    return;
}
