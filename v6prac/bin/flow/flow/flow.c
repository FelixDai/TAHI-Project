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
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <string.h>
#include "PflowFlow.h"

int load_pkt(FILE *);
void print_footer(void);
void print_pkt(int);
void read_def(FILE *);
void sort_addr(void);
void sort_mac_addr(void);
void usage(void);

FILE *write_define = NULL;
char *input_file = NULL;
char alias[1024][1024];
char cgi_path[1024];
char file_path[1024];
char ip_addr_tbl[1024][INET6_ADDRSTRLEN];
char mac_addr_tbl[1024][INET6_ADDRSTRLEN];
int CGI = 0;
int CREATE_DEFINE = 0;
int HTML = 0;
int IDENTIFIER = 0;
int INTERACTIVE = 0;
int IP_FLOW = 1;
int MAC_FLOW = 0;
int NUMERIC = 0;
int READ_DEFINE = 0;
int WINDOW = 0;
int *ip_color = NULL;
int *ip_to_print = NULL;
int *mac_color = NULL;
int *mac_to_print = NULL;
int *print_to_ip = NULL;
int *print_to_mac = NULL;
int total_ip_addr = 0;
int total_mac_addr = 0;
int total_pkts = 0;
struct in6_addr *mac_s6 = NULL;
struct in6_addr *s6 = NULL;
struct packets *pkt = NULL;

int main(int argc, char **argv) {
    FILE *flow = NULL;
    FILE *input = NULL;
    FILE *read_define = NULL;
    char *name = NULL;
    char *write_def_name = NULL;
    char mac[INET6_ADDRSTRLEN];
    char v4mapped[INET6_ADDRSTRLEN];
    int counter = 0;
    int err = 0;
    int max_length = 0;

    {
        extern char *optarg;
        extern int optind;
        int ch = 0;

        while((ch = getopt(argc, argv, "CINac:d:himnw")) != -1) {
            switch(ch) {
                case 'C':
                    CGI = 1;
                    break;

                case 'N':
                    IP_FLOW = 0;
                    MAC_FLOW = 0;
                    break;

                case 'I':
                    IDENTIFIER = 1;
                    break;

                case 'a':
                    IP_FLOW = 1;
                    MAC_FLOW = 1;
                    break;

                case 'c':
                    CREATE_DEFINE = 1;
                    write_def_name = optarg;
                    break;

                case 'd':
                    READ_DEFINE = 1;

                    read_define = fopen(optarg, "r");
                    if(read_define == NULL) {
                        perror(optarg);
                        return(1);
                    }

                    break;

                case 'h':
                    HTML = 1;
                    break;

                case 'i':
                    INTERACTIVE = 1;
                    break;

                case 'm':
                    IP_FLOW = 0;
                    MAC_FLOW = 1;
                    break;

                case 'n':
                    NUMERIC = 1;
                    break;

                case 'w':
                    WINDOW = 1;
                    break;

                default:
                    usage();
            }
        }
        argc -= optind;
        argv += optind;
    }

    if(argc == 0) {
        input = stdin;
        if(CGI == 1) {
            fprintf(stderr, "option -c: CGI mode require the file name with absolute path\n");
            usage();
        }
    } else if (argc == 1) {
        input = fopen(argv[0], "r");
        if(input == NULL) {
            perror(argv[0]);
            return(1);
        }

        if(CGI == 1) {
            input_file = argv[0];
        }
    } else {
        usage();
    }

    if((CREATE_DEFINE == 1) && (READ_DEFINE == 1)) {
        usage();
    }

    if((HTML != 1) && ((CGI == 1) || (INTERACTIVE == 1))) {
        usage();
    }

    if((CGI == 1) && (INTERACTIVE == 1)) {
        usage();
    }

    if(INTERACTIVE == 1) {
        name = getlogin();
        if(name == NULL) {
            perror("getlogin");
            return(1);
        }

        fprintf(stderr, "Enter relative path from this directory to the packet.cgi.\n");
        fprintf(stderr, "%s@flow > ", name);
        fgets(cgi_path, sizeof(cgi_path), stdin);
        cgi_path[strlen(cgi_path) - 1] = '\0';

        fprintf(stderr, "Enter the relative path from packet.cgi to the input file.\n");
        fprintf(stderr, "%s@flow > ", name);
        fgets(file_path, sizeof(file_path), stdin);
        file_path[strlen(file_path) - 1] = '\0';
    }

    if(HTML == 1) {
        flow = fopen("flow.html", "w");
        if(flow == NULL) {
            perror("flow.html");
            return(1);
        }

        fprintf(flow, "<HTML>\n");
        fprintf(flow, "<HEAD>\n");
        fprintf(flow, "<TITLE>");
        fprintf(flow, "flow v.%s", DATE);
        fprintf(flow, "</TITLE>\n");
        fprintf(flow, "</HEAD>\n");
        fprintf(flow, "<FRAMESET ROWS=\"70%%,30%%\">\n");
        fprintf(flow, "<FRAME SRC=\"./body-00.html\" NAME=\"body\">\n");
        fprintf(flow, "<FRAME SRC=\"./footer.html\">\n");
        fprintf(flow, "</FRAMESET>\n");
        fprintf(flow, "</HTML>\n");
        fclose(flow);
    }

    max_length = load_pkt(input);
    fclose(input);

    ip_to_print = (int *)malloc(sizeof(int) * total_ip_addr);
    if(ip_to_print == NULL) {
        perror("malloc");
        free(pkt);
        return(1);
    }

    print_to_ip = (int *)malloc(sizeof(int) * total_ip_addr);
    if(print_to_ip == NULL) {
        perror("malloc");
        free(ip_to_print);
        free(pkt);
        return(1);
    }

    mac_to_print = (int *)malloc(sizeof(int) * total_mac_addr);
    if(mac_to_print == NULL) {
        perror("malloc");
        free(print_to_ip);
        free(ip_to_print);
        free(pkt);
        return(1);
    }

    print_to_mac = (int *)malloc(sizeof(int) * total_mac_addr);
    if(print_to_mac == NULL) {
        perror("malloc");
        free(mac_to_print);
        free(print_to_ip);
        free(ip_to_print);
        free(pkt);
        return(1);
    }

    mac_s6 = (struct in6_addr *)malloc(sizeof(struct in6_addr) * total_mac_addr);
    if(mac_s6 == NULL) {
        perror("malloc");
        free(print_to_mac);
        free(mac_to_print);
        free(print_to_ip);
        free(ip_to_print);
        free(pkt);
        return(1);
    }

    s6 = (struct in6_addr *)malloc(sizeof(struct in6_addr) * total_ip_addr);
    if(s6 == NULL) {
        perror("malloc");
        free(mac_s6);
        free(print_to_mac);
        free(mac_to_print);
        free(print_to_ip);
        free(ip_to_print);
        free(pkt);
        return(1);
    }

    if(READ_DEFINE == 1) {
        ip_color = (int *)malloc(sizeof(int) * total_ip_addr);
        if(ip_color == NULL) {
            perror("malloc");
            free(s6);
            free(mac_s6);
            free(print_to_mac);
            free(mac_to_print);
            free(print_to_ip);
            free(ip_to_print);
            free(pkt);
            return(1);
        }

        mac_color = (int *)malloc(sizeof(int) * total_mac_addr);
        if(mac_color == NULL) {
            perror("malloc");
            free(ip_color);
            free(s6);
            free(mac_s6);
            free(print_to_mac);
            free(mac_to_print);
            free(print_to_ip);
            free(ip_to_print);
            free(pkt);
            return(1);
        }
    }

    while(counter < total_ip_addr) {
        ip_to_print[counter] = counter;
        print_to_ip[counter] = counter;
        counter++;
    }

    counter = 0;
    while(counter < total_mac_addr) {
        mac_to_print[counter] = counter;
        print_to_mac[counter] = counter;
        counter++;
    }

    counter = 0;
    while(counter < total_ip_addr) {
        err = inet_pton(AF_INET6, ip_addr_tbl[counter], &s6[counter]);
        if(err != 1) {
            sprintf(v4mapped, "::ffff:%s", ip_addr_tbl[counter]);
            err = inet_pton(AF_INET6, v4mapped, &s6[counter]);
            if(err != 1) {
                fprintf(stderr, "invalid IP address: %s\n", ip_addr_tbl[counter]);
                if(READ_DEFINE == 1) {
                    free(ip_color);
                    free(mac_color);
                }

                free(s6);
                free(mac_s6);
                free(print_to_mac);
                free(mac_to_print);
                free(print_to_ip);
                free(ip_to_print);
                free(pkt);
                return(1);
            }
        }
        counter++;
    }

    counter = 0;
    while(counter < total_mac_addr) {
        sprintf(mac, "::%s", mac_addr_tbl[counter]);
        err = inet_pton(AF_INET6, mac, &mac_s6[counter]);
        if(err != 1) {
            fprintf(stderr, "invalid MAC address: %s\n", mac_addr_tbl[counter]);
            if(READ_DEFINE == 1) {
                free(ip_color);
                free(mac_color);
            }

            free(s6);
            free(mac_s6);
            free(print_to_mac);
            free(mac_to_print);
            free(print_to_ip);
            free(ip_to_print);
            free(pkt);
            return(1);
        }

        counter++;
    }

    counter = 0;
    while(counter < total_ip_addr) {
        memset(alias[counter], 0, sizeof(alias[counter]));
        counter++;
    }

    if(READ_DEFINE == 1) {
        counter = 0;
        while(counter < total_ip_addr) {
            ip_color[counter] = 0; 
            counter++;
        }

        counter = 0;
        while(counter < total_mac_addr) {
            mac_color[counter] = 0;
            counter++;
        }

        read_def(read_define);
    } else {
        sort_addr();
        sort_mac_addr();
    }

    print_pkt(max_length);

    if(CREATE_DEFINE == 1) {
        write_define = fopen(write_def_name, "w");
        if(write_define == NULL) {
            perror(write_def_name);
            free(s6);
            free(mac_s6);
            free(print_to_mac);
            free(mac_to_print);
            free(print_to_ip);
            free(ip_to_print);
            free(pkt);
            return(1);
        }

        fprintf(write_define, "# flow v.%s\n", DATE);
        fprintf(write_define, "#\n");
        fprintf(write_define, "# syntax)\n");
        fprintf(write_define, "#     ip [IP address] [alias name] [HTML color]\n");
        fprintf(write_define, "#     mac [MAC address] [HTML color]\n");
        fprintf(write_define, "#\n");
        fprintf(write_define, "# example)\n");
        fprintf(write_define, "#     ip  [fe80::200:f4ff:fe5c:e287] [link-local address] [FFD700]\n");
        fprintf(write_define, "#     ip  [10.21.0.195]              [ ]                  [FFD700]\n");
        fprintf(write_define, "#\n");
        fprintf(write_define, "#     mac [00:00:f4:5c:e2:87] [FFD700]\n");
    }

    print_footer();

    if(READ_DEFINE == 1) {
        fclose(read_define);
        free(ip_color);
        free(mac_color);
    }

    if(CREATE_DEFINE == 1) {
        fclose(write_define);
    }

    free(s6);
    free(mac_s6);
    free(print_to_mac);
    free(mac_to_print);
    free(print_to_ip);
    free(ip_to_print);
    free(pkt);
    return(0);
}
