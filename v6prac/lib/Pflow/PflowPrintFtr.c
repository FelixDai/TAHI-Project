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

extern FILE *write_define;
extern char alias[1024][1024];
extern char ip_addr_tbl[1024][INET6_ADDRSTRLEN];
extern char mac_addr_tbl[1024][INET6_ADDRSTRLEN];
extern int CREATE_DEFINE;
extern int HTML;
extern int *print_to_ip;
extern int *print_to_mac;
extern int total_pkts;
extern int total_ip_addr;
extern int total_mac_addr;

int addr_alias(void);
void print_addr_tbl(FILE *, int);
void print_information(FILE *);

void print_footer(void) {
    FILE *footer = stdout;
    int counter = 0;
    int max_length = 0;
    int max_addr_length = 0;
    int pad = 0;

    max_length = addr_alias();

    if(CREATE_DEFINE == 1) {
        if(total_ip_addr != 0) {
            fputc('\n', write_define);
            fprintf(write_define, "# IP address\n");

            while(counter < total_ip_addr) {
                if(max_addr_length < strlen(ip_addr_tbl[print_to_ip[counter]])) {
                    max_addr_length = strlen(ip_addr_tbl[print_to_ip[counter]]);
                }

                counter++;
            }

            counter = 0;
            while(counter < total_ip_addr) {
                fprintf(write_define, "ip [%s] ", ip_addr_tbl[print_to_ip[counter]]);

                pad = strlen(ip_addr_tbl[print_to_ip[counter]]);
                while(pad < max_addr_length) {
                    fputc(' ', write_define);
                    pad++;
                }

                if(strlen(alias[print_to_ip[counter]]) != 0) {
                    fprintf(write_define, "[%s] ", alias[print_to_ip[counter]]);
                    pad = strlen(alias[print_to_ip[counter]]);
                } else {
                    fprintf(write_define, "[ ] ");
                    pad = max_length;
                }

                while(pad < max_length) {
                    fputc(' ', write_define);
                    pad++;
                }

                fprintf(write_define, "[ ]\n");
                counter++;
            }
        }

        if(total_mac_addr != 0) {
            fputc('\n', write_define);
            fprintf(write_define, "# MAC address\n");

            counter = 0;
            max_addr_length = 0;
            while(counter < total_mac_addr) {
                if(max_addr_length < strlen(mac_addr_tbl[print_to_mac[counter]])) {
                    max_addr_length = strlen(mac_addr_tbl[print_to_mac[counter]]);
                }

                counter++;
            }

            counter = 0;
            while(counter < total_mac_addr) {
                fprintf(write_define, "mac [%s] ", mac_addr_tbl[print_to_mac[counter]]);

                pad = strlen(mac_addr_tbl[print_to_mac[counter]]);
                while(pad < max_addr_length) {
                    fputc(' ', write_define);
                    pad++;
                }

                fprintf(write_define, "[ ]\n");
                counter++;
            }
        }
    }

    if(HTML == 1) {
        footer = fopen("footer.html", "w");
        if(footer == NULL) {
            perror("footer.html");
            exit(1);
        }

        fprintf(footer, "<HTML>\n");
        fprintf(footer, "<HEAD>\n");
        fprintf(footer, "<TITLE>");
        fprintf(footer, "flow v.%s", DATE);
        fprintf(footer, "</TITLE>\n");
        fprintf(footer, "</HEAD>\n");
        fprintf(footer, "<BODY BGCOLOR=\"#FFFFFF\">\n");
        fprintf(footer, "<PRE>\n");
    }

    if((total_ip_addr != 0) || (total_mac_addr != 0)) {
        if(HTML != 1) {
            fputc('\n', footer);
        }

        if((HTML == 1) && (total_pkts > 1000)) {
            fprintf(footer, "<STRONG>FLOW LIST</STRONG>\n");

            counter = 0;
            while(counter <= total_pkts / 1000) {
                fprintf(footer,
                        "    <A HREF=\"./body-%02d.html\" TARGET=\"body\">%05d - ",
                        counter,
                        counter * 1000 + 1);

                if(counter == total_pkts / 1000) {
                    fprintf(footer, "%05d</A>", total_pkts);
                } else {
                    fprintf(footer, "%05d</A>", (counter + 1) * 1000);
                }

                counter++;
            }

            fprintf(footer, "\n");
            fprintf(footer, "</PRE>\n");
            fprintf(footer, "<HR>\n");
            fprintf(footer, "<PRE>\n");
        }

        print_addr_tbl(footer, max_length);

        if(HTML == 1) {
            fprintf(footer, "</PRE>\n");
            fprintf(footer, "<P>\n");
            fprintf(footer, "<PRE>");
        }

        fputc('\n', footer);
    }

    print_information(footer);

    if(HTML == 1) {
        fprintf(footer, "</PRE>\n");
        fprintf(footer, "<HR>\n");
        fprintf(footer, "<P ALIGN=\"right\">\n");
        fprintf(footer, "<STRONG><I>Generated by flow v.%s by <A HREF=\"mailto:contact@tahi.org\">TAHI Project</A></I></STRONG>\n", DATE);
        fprintf(footer, "</P>\n");
        fprintf(footer, "</BODY>\n");
        fprintf(footer, "</HTML>\n");

        fclose(footer);
    }

    return;
}
