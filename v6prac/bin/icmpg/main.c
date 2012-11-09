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
#include <sys/types.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/socket.h>
#include <net/if.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

struct msghdr send_msg;

int icmpv4(unsigned char *, int, int);
int icmpv6(unsigned char *, int, int);
void print_send_buffer(unsigned char *, int);
void usage(void);

int main(int argc, char **argv) {
    char *dst;
    int C = 0;
    int T = 0;
    int code = 0;
    int err = 0;
    int type = 0;
    int s = 0;
    int size = 0;
    struct addrinfo *res;
    struct addrinfo hints;
    struct iovec send_iov;
    u_char send_buffer[1024];

    {
        extern char *optarg;
        extern int optind;
        int ch;

        while((ch = getopt(argc, argv, "C:T:")) != -1) {
            switch(ch) {
                case 'C':
                    C = 1;
                    code = atoi(optarg);
                    if((code < 0) || (code > 255)) {
                        fprintf(stderr, "icmpg: illegal code -- %d\n", code);
                        usage();
                        return(1);
                    }
                    break;
                case 'T':
                    T = 1;
                    type = atoi(optarg);
                    if((type < 0) || (type > 255)) {
                        fprintf(stderr, "icmpg: illegal type -- %d\n", type);
                        usage();
                        return(1);
                    }
                    break;
                default:
                    usage();
                    return(1);
            }
        }
        argc-= optind;
        argv+= optind;
    }

    if((C == 0) || (T == 0) || (argc != 1)) {
        usage();
        return(1);
    } else {
        dst = argv[argc - 1];
    }

    bzero(&hints, sizeof(struct addrinfo));
    hints.ai_flags = AI_CANONNAME;
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_RAW;

    err = getaddrinfo(dst, NULL, &hints, &res);
    if(err != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(err));
        freeaddrinfo(res);
        return(1);
    }

    switch(res->ai_family) {
        case PF_INET:
            res->ai_protocol = IPPROTO_ICMP;
            size = icmpv4(send_buffer, type, code);
            break;
        case PF_INET6:
            res->ai_protocol = IPPROTO_ICMPV6;
            size = icmpv6(send_buffer, type, code);
            break;
        default:
            fprintf(stderr, "icmpg: ai_family not supported\n");
            freeaddrinfo(res);
            return(1);
    }

    s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if(s < 0) {
        perror("socket");
        close(s);
        freeaddrinfo(res);
        return(1);
    }

    send_iov.iov_base = send_buffer;
    send_iov.iov_len = size;

    send_msg.msg_name = (caddr_t)res->ai_addr;
    send_msg.msg_namelen = res->ai_addrlen;
    send_msg.msg_iov = &send_iov;
    send_msg.msg_iovlen = 1;

    err = sendmsg(s, &send_msg, 0);
    if (err == -1) {
        perror("sendmsg");
        close(s);
        freeaddrinfo(res);
        return(1);
    }

    print_send_buffer(send_buffer, size);

    close(s);
    freeaddrinfo(res);
    return(0);
}
