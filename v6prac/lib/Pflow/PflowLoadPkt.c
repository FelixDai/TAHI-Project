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
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include "PflowFlow.h"

extern int CGI;
extern int HTML;
extern int INTERACTIVE;
extern int total_pkts;
extern struct packets *pkt;

int analyze_time(char *, int);
void esp_hdr(char *, int, int);
int ether_type(char *, int);
void frag_hdr(char *, int, int);
void icmp(char *, int);
void icmpv6(char *, int);
void ip_dst_addr(char *, int);
void ip_src_addr(char *, int);
void mac_dst_addr(char *, int);
void mac_src_addr(char *, int);
int next_header(char *, int, int);
int protocol(char *, int, int);
void tcp(char *, int);
void udp(char *, int);

struct upper upp;

int load_pkt(FILE *stream) {
    FILE *output = NULL;
    char file_name[1024];
    char str[1024];
    char tmp_str[1024];
    int counter = 0;
    int err = 0;
    int eth_type = -1;
    int exist_flag = 0;
    int flag = 0;
    int length = 0;
    int max_length = 0;
    int nxt_hdr = -1;
    int nxt_hdr_status = 0;
    int nxt_prtcl = -1;
    int nxt_prtcl_status = 0;
    int tmp_eth_type = -1;
    int tmp_nxt_hdr = -1;
    int tmp_nxt_prtcl = -1;

    if((HTML == 1) && ((CGI != 1) && (INTERACTIVE != 1))){
        err = mkdir("./packets", 0755);
        if((err != 0) && (errno != EEXIST)){
            perror("packets");
            exit(1);
        }

        if(errno == EEXIST) {
            fprintf(stderr, "warning: directory `packets' already exist.\n");
            exist_flag = 1;
        }
    }

    while(fgets(str, sizeof(str), stream)) {
        if(((HTML == 1) && ((CGI != 1) && (INTERACTIVE != 1))) && (exist_flag != 1)) {
            strcpy(tmp_str, str);
        }

        if(analyze_time(str, counter) == 1) {
            eth_type = -1;
            length = 0;
            nxt_hdr = -1;
            nxt_hdr_status = 0;
            nxt_prtcl = -1;
            nxt_prtcl_status = 0;
            tmp_eth_type = -1;
            tmp_nxt_hdr = -1;
            tmp_nxt_prtcl = -1;

            pkt[counter].pkt_mac_src = -1;
            pkt[counter].pkt_mac_dst = -1;
            pkt[counter].pkt_ip_src = -1;
            pkt[counter].pkt_ip_dst = -1;
            strcpy(pkt[counter].pkt_analyze, "N/A");
            pkt[counter].pkt_clr = BLACK;

            upp.upp_x = -1;
            upp.upp_y = -1;
            memset(upp.upp_data, 0, sizeof(upp.upp_data));

            if(((HTML == 1) && ((CGI != 1) && (INTERACTIVE != 1))) && (exist_flag != 1)) {
                if(flag != 0) {
                    fprintf(output ,"</PRE>\n");
                    fprintf(output ,"</BODY>\n");
                    fprintf(output ,"</HTML>\n");
                    fclose(output);
                }

                sprintf(file_name, "./packets/%s.html", pkt[counter].pkt_time);
                file_name[12] = '-';
                file_name[15] = '-';
                file_name[18] = '_';

                output = fopen(file_name, "w");
                if(output == NULL) {
                    perror(file_name);
                    exit(1);
                }

                fprintf(output ,"<HTML>\n");
                fprintf(output ,"<HEAD>\n");
                fprintf(output ,"<TITLE>");
                fprintf(output ,"%s", pkt[counter].pkt_time);
                fprintf(output ,"</TITLE>\n");
                fprintf(output ,"</HEAD>\n");
                fprintf(output ,"<BODY BGCOLOR=\"#FFFFFF\">\n");
                fprintf(output ,"<PRE>\n");

                flag = 1;
            }

            counter++;
        }

        if(((HTML == 1) && ((CGI != 1) && (INTERACTIVE != 1))) && (exist_flag != 1)) {
            if((tmp_str[0] == 'l') &&
               (tmp_str[1] == 'o') &&
               (tmp_str[2] == 'g') &&
               (tmp_str[3] == ':')) {
                fprintf(output ,"%s", &tmp_str[4]);
            }
        }

        mac_dst_addr(str, counter - 1);
        mac_src_addr(str, counter - 1);

        tmp_eth_type = ether_type(str, counter - 1);
        if(tmp_eth_type != -1) {
            eth_type = tmp_eth_type;
        }

        if(eth_type == 2048) {
            ip_src_addr(str, counter - 1);
            ip_dst_addr(str, counter - 1);

            tmp_nxt_prtcl = protocol(str, counter - 1, nxt_prtcl_status);
            if(tmp_nxt_prtcl != -1) {
                nxt_prtcl = tmp_nxt_prtcl;
                nxt_prtcl_status = 1;
            }
        } else if(eth_type == 34525) {
            ip_src_addr(str, counter - 1);
            ip_dst_addr(str, counter - 1);

            if(nxt_hdr == 44) {
                frag_hdr(str, counter - 1, nxt_hdr_status);
            } else if(nxt_hdr == 50) {
                esp_hdr(str, counter - 1, nxt_hdr_status);
            } else {
                tmp_nxt_hdr = next_header(str, counter - 1, nxt_hdr_status);
                if(tmp_nxt_hdr != -1) {
                    nxt_hdr = tmp_nxt_hdr;
                    nxt_hdr_status = 1;
                }
            }
        }

        if(nxt_prtcl == 1) {
            icmp(str, counter - 1);
        }

        if(nxt_prtcl == 6) {
            tcp(str, counter - 1);
        }

        if(nxt_prtcl == 17) {
            udp(str, counter - 1);
        }

        if(nxt_hdr == 6) {
            tcp(str, counter - 1);
        }

        if(nxt_hdr == 17) {
            udp(str, counter - 1);
        }

        if(nxt_hdr == 58) {
            icmpv6(str, counter - 1);
        }

        if(counter != 0) {
            length = strlen(pkt[counter - 1].pkt_analyze);
            if(max_length < length) {
                max_length = length;
            }
        }
    }

    if(((HTML == 1) && ((CGI != 1) && (INTERACTIVE != 1))) && (exist_flag != 1) && (flag != 0)) {
        fprintf(output ,"</PRE>\n");
        fprintf(output ,"</BODY>\n");
        fprintf(output ,"</HTML>\n");
        fclose(output);
    }

    total_pkts = counter;
    return(max_length);
}
