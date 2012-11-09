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
#include <unistd.h>
#include <netinet/in.h>
#include <string.h>
#include "PflowFlow.h"

extern char alias[1024][1024];
extern char ip_addr_tbl[1024][INET6_ADDRSTRLEN];
extern char mac_addr_tbl[1024][INET6_ADDRSTRLEN];
extern int *mac_color;
extern int *ip_color;
extern int HTML;
extern int READ_DEFINE;
extern int *print_to_ip;
extern int *print_to_mac;
extern int total_ip_addr;
extern int total_mac_addr;

void print_addr_tbl(FILE *stream, int max_length) {
    int counter = 0;
    int pad = 0;
    int total_length = 0;

    if(total_ip_addr != 0) {
        if(HTML != 1) {
            fprintf(stream, "IP ADDRESS LIST\n");
        }

        while(counter < total_ip_addr) {
            if(strlen(alias[print_to_ip[counter]]) == 0) {
                strcpy(alias[print_to_ip[counter]], ip_addr_tbl[print_to_ip[counter]]);
            } else {
                while(strlen(alias[print_to_ip[counter]]) < max_length) {
                    strcat(alias[print_to_ip[counter]], " ");
                }

                sprintf(alias[print_to_ip[counter]],
                        "%s (%s)",
                        alias[print_to_ip[counter]],
                        ip_addr_tbl[print_to_ip[counter]]);
            }

            if(HTML == 1) {
                if(total_length < strlen(alias[print_to_ip[counter]])) {
                    total_length = strlen(alias[print_to_ip[counter]]);
                }
            } else {
                if(counter < 26) {
                    fprintf(stream, "    [%c] = %s\n", 'a' + counter, alias[print_to_ip[counter]]);
                } else if((counter >= 26) && (counter < 52)) {
                    fprintf(stream, "    [%c] = %s\n", 'A' + counter - 26, alias[print_to_ip[counter]]);
                } else {
                    fprintf(stream, "    [?] = %s\n", alias[print_to_ip[counter]]);
                }
            }

            counter++;
        }

        if(HTML != 1) {
            fputc('\n', stream);
        }
    }

    if(HTML == 1) {
        if(total_ip_addr != 0) {
            fprintf(stream, "<STRONG>IP ADDRESS LIST</STRONG>");
        }

        if((total_ip_addr != 0) && (total_mac_addr != 0)) {
            counter = 5;
            while(counter < total_length) {
                fputc(' ', stream);
                counter++;
            }
        }

        if(total_mac_addr != 0) {
            fprintf(stream, "<STRONG>MAC ADDRESS LIST</STRONG>\n");
        }

        counter = 0;
        while((counter < total_ip_addr) || (counter < total_mac_addr)) {
            if(total_ip_addr != 0) {
                if(counter < total_ip_addr) {
                    if((READ_DEFINE == 1) && (ip_color[print_to_ip[counter]] > 0)) {
                        fprintf(stream, "<FONT COLOR=\"#%06x\">", ip_color[print_to_ip[counter]]);
                    }

                    if(counter < 26) {
                        fprintf(stream, "[%c]", 'a' + counter);
                    } else if((counter >= 26) && (counter < 52)) {
                        fprintf(stream, "[%c]", 'A' + counter - 26);
                    } else {
                        fprintf(stream, "[?]");
                    }

                    fprintf(stream, " = %s", alias[print_to_ip[counter]]);

                    if((READ_DEFINE == 1) && (ip_color[print_to_ip[counter]] > 0)) {
                        fprintf(stream, "</FONT>");
                    }

                    if(counter < total_mac_addr) {
                        pad = strlen(alias[print_to_ip[counter]]);
                        while(pad < total_length) {
                            fputc(' ', stream);
                            pad++;
                        }
                    }
                } else {
                    fprintf(stream, "      ");

                    pad = 0;
                    while(pad < total_length) {
                        fputc(' ', stream);
                        pad++;
                    }
                }
            }

            if(counter < total_mac_addr) {
                fprintf(stream, "    ");

                if((READ_DEFINE == 1) && (mac_color[print_to_mac[counter]] > 0)) {
                    fprintf(stream, "<FONT COLOR=\"#%06x\">", mac_color[print_to_mac[counter]]);
                }

                if(counter < 26) {
                    fprintf(stream, "(%c)", 'a' + counter);
                } else if((counter >= 26) && (counter < 52)) {
                    fprintf(stream, "(%c)", 'A' + counter - 26);
                } else {
                    fprintf(stream, "(?)");
                }

                fprintf(stream, " = %s", mac_addr_tbl[print_to_mac[counter]]);

                if((READ_DEFINE == 1) && (mac_color[print_to_mac[counter]] > 0)) {
                    fprintf(stream, "</FONT>");
                }
            }

            fputc('\n', stream);

            counter++;
        }
    }

    if((HTML != 1) && (total_mac_addr != 0)) {
        fprintf(stream, "MAC ADDRESS LIST\n");

        counter = 0;
        while(counter < total_mac_addr) {
            if(counter < 26) {
                fprintf(stream, "    (%c) = %s\n", 'a' + counter, mac_addr_tbl[print_to_mac[counter]]);
            } else if((counter >= 26) && (counter < 52)) {
                fprintf(stream,
                        "    (%c) = %s\n",
                        'A' + counter - 26,
                        mac_addr_tbl[print_to_mac[counter]]);
            } else {
                fprintf(stream, "    (?) = %s\n", mac_addr_tbl[print_to_mac[counter]]);
            }

            counter++;
        }
    }

    return;
}
