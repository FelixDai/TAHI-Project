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

extern char *input_file;
extern char cgi_path[1024];
extern char file_path[1024];
extern int CGI;
extern int HTML;
extern int INTERACTIVE;
extern int IP_FLOW;
extern int MAC_FLOW;
extern int *to_print;
extern int total_ip_addr;
extern int total_mac_addr;
extern int total_pkts;
extern struct packets *pkt;

void make_hdr(FILE *, int);
void make_ip_flow(FILE *, int, int, int);
void make_line(FILE *, int);
void make_mac_flow(FILE *, int, int, int);

int *ip_addr_status = NULL;
int *mac_addr_status = NULL;

void print_pkt(int max_length) {
    FILE *body = stdout;
    char file_name[1024];
    char time_to_link[1024];
    int counter = 0;
    int flag = 0;

    if(total_pkts != 0) {
        if(total_ip_addr != 0) {
            ip_addr_status = (int *)malloc(sizeof(int) * total_ip_addr);
            if(ip_addr_status == NULL) {
                perror("malloc");
                exit(1);
            }
            memset(ip_addr_status, 0, sizeof(int) * total_ip_addr);
        }

        if(total_mac_addr != 0) {
            mac_addr_status = (int *)malloc(sizeof(int) * total_mac_addr);
            if(mac_addr_status == NULL) {
                perror("malloc");
                exit(1);
            }
            memset(mac_addr_status, 0, sizeof(int) * total_mac_addr);
        }

        if(HTML != 1) {
            make_hdr(body, max_length);
            make_line(body, max_length);
        }

        while(counter < total_pkts) {
            while(max_length != strlen(pkt[counter].pkt_analyze)) {
                strcat(pkt[counter].pkt_analyze, " ");
            }

            if((HTML == 1) && (counter % 1000 == 0)) {
                if(flag != 0) {
                    fprintf(body, "</PRE>\n");
                    fprintf(body, "</BODY>\n");
                    fprintf(body, "</HTML>\n");
                    fclose(body);
                }

                sprintf(file_name, "body-%02d.html", counter / 1000);
                body = fopen(file_name, "w");
                if(body == NULL) {
                    perror(file_name);
                    exit(1);
                }
        
                fprintf(body, "<HTML>\n");
                fprintf(body, "<HEAD>\n");
                fprintf(body, "<TITLE>");
                fprintf(body, "flow v.%s", DATE);
                fprintf(body, "</TITLE>\n");
                fprintf(body, "</HEAD>\n");
                fprintf(body, "<BODY BGCOLOR=\"#FFFFFF\">\n");
                fprintf(body, "<PRE>\n");

                make_hdr(body, max_length);
                make_line(body, max_length);

                flag = 1;
            }

            if(HTML == 1) {
                fprintf(body, "<A NAME=\"%05d\">", counter + 1);
            }

            fprintf(body, "%05d ", counter + 1);

            if(HTML == 1) {
                strcpy(time_to_link, pkt[counter].pkt_time);
                time_to_link[2] = '-';
                time_to_link[5] = '-';
                time_to_link[8] = '_';

                if(CGI == 1) {
                    fprintf(body,
                            "<A HREF=\"/cgi-bin/packet.cgi?%s+%s\" TARGET=\"_blank\">",
                            pkt[counter].pkt_time,
                            input_file);
                } else if(INTERACTIVE == 1) {
                    fprintf(body,
                            "<A HREF=\"%s?%s+%s\" TARGET=\"_blank\">",
                            cgi_path,
                            pkt[counter].pkt_time,
                            file_path);
                } else {
                    fprintf(body, "<A HREF=\"./packets/%s.html\" TARGET=\"_blank\">", time_to_link);
                }
            }

            fprintf(body, "%s", pkt[counter].pkt_time);

            if(HTML == 1) {
                fprintf(body, "</A>");
            }

            fputc(' ', body);

            if((HTML == 1) && (pkt[counter].pkt_clr != BLACK)) {
                switch(pkt[counter].pkt_clr) {
                    case RED:
                        fprintf(body, "<FONT COLOR=\"#FF0000\">");
                        break;
                    case GREEN:
                        fprintf(body, "<FONT COLOR=\"#008000\">");
                        break;
                    case BLUE:
                        fprintf(body, "<FONT COLOR=\"#0000FF\">");
                        break;
                    case TEAL:
                        fprintf(body, "<FONT COLOR=\"#008080\">");
                        break;
                    default:
                        ;
                }
            }

            fprintf(body, "%s", pkt[counter].pkt_analyze);

            if((HTML == 1) && (pkt[counter].pkt_clr != BLACK)) {
                fprintf(body, "</FONT>");
            }

            if(total_ip_addr != 0) {
                fputc(' ', body);

                make_ip_flow(body,
                             pkt[counter].pkt_ip_src,
                             pkt[counter].pkt_ip_dst,
                             pkt[counter].pkt_clr);
            }

            if((IP_FLOW == 1) && (MAC_FLOW == 1) && (total_ip_addr != 0)) {
                fprintf(body, " %% ");
            } else {
                fputc(' ', body);
            }

            if(total_mac_addr != 0) {
                make_mac_flow(body,
                              pkt[counter].pkt_mac_src,
                              pkt[counter].pkt_mac_dst,
                              pkt[counter].pkt_clr);
            }

            fputc('\n', body);
            counter++;
        }

        if(HTML == 1) {
            if(flag != 0) {
                fprintf(body, "</PRE>\n");
                fprintf(body, "</BODY>\n");
                fprintf(body, "</HTML>\n");
                fclose(body);
            }
        } else {
            make_line(body, max_length);
        }

        if(total_mac_addr != 0) {
            free(mac_addr_status);
        }

        if(total_ip_addr != 0) {
            free(ip_addr_status);
        }
    } else if(HTML == 1) {
        body = fopen("body-00.html", "w");
        if(body == NULL) {
            perror("body-00.html");
            exit(1);
        }

        fprintf(body, "<HTML>\n");
        fprintf(body, "<HEAD>\n");
        fprintf(body, "<TITLE>");
        fprintf(body, "flow v.%s", DATE);
        fprintf(body, "</TITLE>\n");
        fprintf(body, "</HEAD>\n");
        fprintf(body, "<BODY BGCOLOR=\"#FFFFFF\">\n");
        fprintf(body, "</BODY>\n");
        fprintf(body, "</HTML>\n");
        fclose(body);
    }

    return;
}
