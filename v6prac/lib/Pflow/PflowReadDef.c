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
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>

extern char alias[1024][1024];
extern int *ip_color;
extern int *mac_color;
extern int total_ip_addr;
extern int total_mac_addr;
extern int *ip_to_print;
extern int *mac_to_print;
extern int *print_to_ip;
extern int *print_to_mac;
extern struct in6_addr *s6;
extern struct in6_addr *mac_s6;

void read_def(FILE *stream) {
    char *token = NULL;
    char str[1024];
    char mac[INET6_ADDRSTRLEN];
    char v4mapped[INET6_ADDRSTRLEN];
    int *dup_ip_ck = NULL;
    int *dup_mac_ck = NULL;
    int IP = 0;
    int MAC = 0;
    int counter = 0;
    int def_ip_addr = 0;
    int def_mac_addr = 0;
    int equal_flag = 0;
    int err = 0;
    int line = 0;
    struct in6_addr def_s6;
    struct in6_addr def_mac_s6;

    dup_ip_ck = (int *)malloc(sizeof(int) * total_ip_addr);
    if(dup_ip_ck == NULL) {
        perror("malloc");
        exit(1);
    }

    dup_mac_ck = (int *)malloc(sizeof(int) * total_mac_addr);
    if(dup_mac_ck == NULL) {
        perror("malloc");
        free(dup_ip_ck);
        exit(1);
    }

    while(counter < total_ip_addr) {
        dup_ip_ck[counter] = 0;
        counter++;
    }

    counter = 0;
    while(counter < total_mac_addr) {
        dup_mac_ck[counter] = 0;
        counter++;
    }

    while(fgets(str, sizeof(str), stream)) {
        line++;
        IP = 0;
        MAC = 0;

        if((str[0] == '\n') || (str[0] == '#')) {
            continue;
        }

        if((str[0] == 'i') && (str[1] == 'p')) {
            IP = 1;
        } else if((str[0] == 'm') && (str[1] == 'a') && (str[2] == 'c')) {
            MAC = 1;
        } else {
            fprintf(stderr, "line %d: syntax error\n", line);
            free(dup_mac_ck);
            free(dup_ip_ck);
            exit(1);
        }

        if((IP == 1) || (MAC == 1)) {
            token = strtok(str, "[");
            token = strtok(NULL, "]");

            if(IP == 1) {
                err = inet_pton(AF_INET6, token, &def_s6);
                if(err != 1) {
                    sprintf(v4mapped, "::ffff:%s", token);
                    err = inet_pton(AF_INET6, v4mapped, &def_s6);
                    if(err != 1) {
                        fprintf(stderr, "line %d: invalid IP address: %s\n", line, token);
                        free(dup_mac_ck);
                        free(dup_ip_ck);
                        exit(1);
                    }
                }

                counter = 0;
                equal_flag = 0;
                while(counter < total_ip_addr) {
                    if(IN6_ARE_ADDR_EQUAL(&s6[counter], &def_s6) == 1) {
                        print_to_ip[def_ip_addr] = counter;
                        equal_flag = 1;
                        if(dup_ip_ck[counter] == 1) {
                            fprintf(stderr, "line %d: duplicate IP address: %s\n", line, token);
                            free(dup_mac_ck);
                            free(dup_ip_ck);
                            exit(1);
                        } else {
                            dup_ip_ck[counter] = 1;
                        }
                    }

                    counter++;
                }

                if(equal_flag == 0) {
                    fprintf(stderr, "line %d: invalid IP address: %s\n", line, token);
                    free(dup_mac_ck);
                    free(dup_ip_ck);
                    exit(1);
                }

                def_ip_addr++;
            }

            if(MAC == 1) {
                sprintf(mac, "::%s", token);
                err = inet_pton(AF_INET6, mac, &def_mac_s6);
                if(err != 1) {
                    fprintf(stderr, "line %d: invalid MAC address: %s\n", line, token);
                    free(dup_mac_ck);
                    free(dup_ip_ck);
                    exit(1);
                }

                counter = 0;
                equal_flag = 0;
                while(counter < total_mac_addr) {
                    if(IN6_ARE_ADDR_EQUAL(&mac_s6[counter], &def_mac_s6) == 1) {
                        print_to_mac[def_mac_addr] = counter;
                        equal_flag = 1;
                        if(dup_mac_ck[counter] == 1) {
                            fprintf(stderr, "line %d: duplicate MAC address: %s\n", line, token);
                            free(dup_mac_ck);
                            free(dup_ip_ck);
                            exit(1);
                        } else {
                            dup_mac_ck[counter] = 1;
                        }
                    }

                    counter++;
                }

                if(equal_flag == 0) {
                    fprintf(stderr, "line %d: invalid MAC address: %s\n", line, token);
                    free(dup_mac_ck);
                    free(dup_ip_ck);
                    exit(1);
                }

                def_mac_addr++;
            }

            token = strtok(NULL, "[");
            token = strtok(NULL, "]");

            if(IP == 1) {
                strcpy(alias[print_to_ip[def_ip_addr - 1]], token);
            }

            if(MAC == 1) {
                sscanf(token, "%x", &mac_color[print_to_mac[def_mac_addr - 1]]);
                if((mac_color[print_to_mac[def_mac_addr - 1]] < 0) ||
                   (mac_color[print_to_mac[def_mac_addr - 1]] > 0xffffff)) {
                    fprintf(stderr, "line %d: invalid MAC address color: %s\n", line, token);
                    free(dup_mac_ck);
                    free(dup_ip_ck);
                    exit(1);
                }
            }

            if(IP == 1) {
                token = strtok(NULL, "[");
                token = strtok(NULL, "]");

                sscanf(token, "%x", &ip_color[print_to_ip[def_ip_addr - 1]]);
                if((ip_color[print_to_ip[def_ip_addr - 1]] < 0) || 
                   (ip_color[print_to_ip[def_ip_addr - 1]] > 0xffffff)) {
                    fprintf(stderr, "line %d: invalid IP address color: %s\n", line, token);
                    free(dup_mac_ck);
                    free(dup_ip_ck);
                    exit(1);
                }   
            }
        }
    }

    if(def_ip_addr != total_ip_addr) {
        fprintf(stderr, "definition error: IP\n");
        free(dup_mac_ck);
        free(dup_ip_ck);
        exit(1);
    }

    if(def_mac_addr != total_mac_addr) {
        fprintf(stderr, "definition error: MAC\n");
        free(dup_mac_ck);
        free(dup_ip_ck);
        exit(1);
    }

    counter = 0;
    while(counter < total_ip_addr) {
        ip_to_print[print_to_ip[counter]] = counter;
        counter++;
    }

    counter = 0;
    while(counter < total_mac_addr) {
        mac_to_print[print_to_mac[counter]] = counter;
        counter++;
    }

    free(dup_mac_ck);
    free(dup_ip_ck);
    return;
}
