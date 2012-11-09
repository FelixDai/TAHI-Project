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
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/uio.h>
#include <sys/param.h>
#include <sys/time.h>
#include <time.h>
#include <net/if.h>
#include <signal.h>
#include <stdlib.h>

FILE *output = stdout;

int ck_hoplimit(struct msghdr *);
struct in6_pktinfo *ck_in6_pktinfo(struct msghdr *);
void interrupt(int);
void print_buf(u_char *, int);
void usage(void);

int main(int argc, char **argv) {
    int err = 0;
    int on = 1;
    int s = 0;
    int sockbufsiz = 0;
    struct addrinfo *res = NULL;
    struct addrinfo hints;
    u_char buf[0xffff];

    {
        extern char *optarg;
        extern int optind;
        int ch = 0;

        while((ch = getopt(argc, argv, "b:w:")) != -1) {
            switch(ch) {
                case 'b':
                    sockbufsiz = atoi(optarg);

                    if(sockbufsiz <= 0) {
                        fprintf(stderr, "illegal sockbufsiz value -- %s\n", optarg);
                        usage();
                    }

                    break;
                case 'w':
                    output = fopen(optarg, "a");

                    if(output == NULL) {
                        perror(optarg);
                        return(1);
                    }

                    break;
                default:
                    usage();
            }
        }
        argc-= optind;
        argv+= optind;
    }

    if(argc != 1) {
        usage();
    }

    memset(&hints, 0, sizeof(hints));
    hints.ai_flags = AI_PASSIVE;
    hints.ai_family = PF_INET6;
    hints.ai_socktype = SOCK_DGRAM;
    hints.ai_protocol = IPPROTO_UDP;

    err = getaddrinfo(NULL, argv[0], &hints, &res);
    if (err != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(err));
        return(1);
    }

    s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if(s == -1) {
        perror("socket");
        freeaddrinfo(res);
        return(1);
    }

    err = setsockopt(s, IPPROTO_IPV6, IPV6_RECVHOPLIMIT, &on, sizeof(on));
    if(err != 0) {
        perror("setsockopt(IPV6_RECVHOPLIMIT)");
        close(s);
        freeaddrinfo(res);
        return(1);
    }

    err = setsockopt(s, IPPROTO_IPV6, IPV6_RECVPKTINFO, &on, sizeof(on));
    if(err != 0) {
        perror("setsockopt(IPV6_RECVPKTINFO)");
        close(s);
        freeaddrinfo(res);
        return(1);
    }

    if(sockbufsiz != 0) {
        err = setsockopt(s, SOL_SOCKET, SO_RCVBUF, &sockbufsiz, sizeof(sockbufsiz));
        if(err != 0) {
            perror("setsockopt(SO_RCVBUF)");
            close(s);
            freeaddrinfo(res);
            return(1);
        }

        err = setsockopt(s, SOL_SOCKET, SO_SNDBUF, &sockbufsiz, sizeof(sockbufsiz));
        if(err != 0) {
            perror("setsockopt(SO_SNDBUF)");
            close(s);
            freeaddrinfo(res);
            return(1);
        }
    }

    err = bind(s, res->ai_addr, res->ai_addrlen);
    if(err == -1) {
        perror("bind");
        close(s);
        freeaddrinfo(res);
        return(1);
    }

    signal(SIGINT, interrupt);

    for( ; ; ) {
        char host[MAXHOSTNAMELEN];
        char ifname[1024];
        int HOPLIMIT = 0;
        int INTERFACE = 0;
        int controllen = 0;
        int ifindex = 0;
        int recv_hoplimit = 0;
        int size = 0;
        struct cmsghdr *recv_cmsg = NULL;
        struct cmsghdr *send_cmsg = NULL;
        struct in6_pktinfo *recv_ipi6 = NULL;
        struct in6_pktinfo *send_ipi6 = NULL;
        struct iovec recv_iov;
        struct iovec send_iov;
        struct msghdr recv_msg;
        struct msghdr send_msg;
        struct sockaddr_in6 from;
        struct timeval recv_tv;
        struct timeval send_tv;
        struct tm *recv_tm_ptr = NULL;
        struct tm *send_tm_ptr = NULL;
        u_char *send_cmsg_buf = NULL;
        u_char recv_cmsg_buf[1024];

        recv_iov.iov_base = buf;
        recv_iov.iov_len = 0xffff;

        recv_msg.msg_name = (caddr_t)&from;
        recv_msg.msg_namelen = sizeof(from);
        recv_msg.msg_iov = &recv_iov;
        recv_msg.msg_iovlen = 1;

        recv_cmsg = (struct cmsghdr *)recv_cmsg_buf;
        recv_msg.msg_control = recv_cmsg_buf;
        recv_msg.msg_controllen = sizeof(recv_cmsg_buf);

        fprintf(output, "====\n");

        size = recvmsg(s, &recv_msg, 0);
        gettimeofday(&recv_tv, NULL);
        recv_tm_ptr = localtime(&recv_tv.tv_sec);

        if(size == -1) {
            perror("recvmsg");
            fprintf(output, "recvmsg err\n");
        } else {
            fprintf(output,
                    "%02d:%02d:%02d.%06u recvmsg\n",
                    recv_tm_ptr->tm_hour,
                    recv_tm_ptr->tm_min,
                    recv_tm_ptr->tm_sec,
                    (u_int32_t)recv_tv.tv_usec);

            recv_ipi6 = ck_in6_pktinfo(&recv_msg);
            if(recv_ipi6 != NULL) {
                INTERFACE = 1;
                ifindex = recv_ipi6->ipi6_ifindex;
                controllen+= CMSG_SPACE(sizeof(struct in6_pktinfo));
            }

            recv_hoplimit = ck_hoplimit(&recv_msg);
            if(recv_hoplimit != -1) {
                HOPLIMIT = 1;
            }

            if(controllen != 0) {
                send_cmsg_buf = (char *)malloc(controllen);
                if(send_cmsg_buf == NULL) {
                    perror("malloc");
                    return(1);
                }

                send_msg.msg_control = (caddr_t)send_cmsg_buf;
                send_msg.msg_controllen = controllen;
                send_cmsg = (struct cmsghdr *)send_cmsg_buf;
            }

            if(INTERFACE == 1) {
                send_ipi6 = (struct in6_pktinfo *)CMSG_DATA(send_cmsg);
                memset(send_ipi6, 0, sizeof(*send_ipi6));
                send_cmsg->cmsg_len = CMSG_LEN(sizeof(struct in6_pktinfo));
                send_cmsg->cmsg_level = IPPROTO_IPV6;
                send_cmsg->cmsg_type = IPV6_PKTINFO;
                send_cmsg = CMSG_NXTHDR(&send_msg, send_cmsg);

                send_ipi6->ipi6_ifindex = ifindex;
                bzero(&send_ipi6->ipi6_addr, sizeof(struct in6_addr));
            }

            send_iov.iov_base = buf;
            send_iov.iov_len = size;

            send_msg.msg_name = (caddr_t)&from;
            send_msg.msg_namelen = sizeof(from);
            send_msg.msg_iov = &send_iov;
            send_msg.msg_iovlen = 1;

            err = sendmsg(s, &send_msg, 0);
            gettimeofday(&send_tv, NULL);
            send_tm_ptr = localtime(&send_tv.tv_sec);

            if(err == -1) {
                perror("sendmsg");
                fprintf(output, "sendmsg err\n");
            } else {

                free(send_cmsg_buf);

                fprintf(output,
                        "%02d:%02d:%02d.%06u sendmsg\n",
                        send_tm_ptr->tm_hour,
                        send_tm_ptr->tm_min,
                        send_tm_ptr->tm_sec,
                        (u_int32_t)send_tv.tv_usec);

                fprintf(output, "\n");
                fprintf(output, "    recvmsg information\n");
                fprintf(output, "    -------------------\n");

                getnameinfo((struct sockaddr *)&from,
                            from.sin6_len,
                            host,
                            sizeof(host),
                            NULL,
                            0,
                            NI_NUMERICHOST);
                fprintf(output, "    host     = %s\n", host);

                if(INTERFACE == 1) {
                    if_indextoname(ifindex, ifname);
                    fprintf(output, "    ifname   = %s\n", ifname);
                }

                if(HOPLIMIT == 1) {
                    fprintf(output, "    hoplimit = %d\n", recv_hoplimit);
                }

                fprintf(output, "    size     = %d\n", size);

                fprintf(output, "    data     =\n");
                print_buf(buf, size);
                fprintf(output, "\n");
            }
        }
    }

    fflush(output);
    close(s);
    freeaddrinfo(res);
    fclose(output);
    return(0);
}

int ck_hoplimit(struct msghdr *msg) {
    struct cmsghdr *cmsg = NULL;

    for(cmsg = CMSG_FIRSTHDR(msg);
        cmsg;
        cmsg = CMSG_NXTHDR(msg, cmsg)) {
        if(cmsg->cmsg_level == IPPROTO_IPV6 &&
           cmsg->cmsg_type == IPV6_HOPLIMIT &&
           cmsg->cmsg_len == CMSG_LEN(sizeof(int))) {
            return(*(int *)CMSG_DATA(cmsg));
        }
    }

    return(-1);
}

struct in6_pktinfo *ck_in6_pktinfo(struct msghdr *msg) {
    struct cmsghdr *cmsg = NULL;

    for(cmsg = CMSG_FIRSTHDR(msg);
        cmsg;
        cmsg = CMSG_NXTHDR(msg, cmsg)) {
        if(cmsg->cmsg_level == IPPROTO_IPV6 &&
           cmsg->cmsg_type == IPV6_PKTINFO &&
           cmsg->cmsg_len == CMSG_LEN(sizeof(struct in6_pktinfo))) {
            return((struct in6_pktinfo *)CMSG_DATA(cmsg));
        }
    }

    return(NULL);
}

void interrupt(int sig) {
    fflush(output);

    signal(SIGINT, SIG_DFL);
    kill(getpid(), SIGINT);
    exit(1);
}

void print_buf(u_char *buf, int size) {
    int counter = 0;

    while(counter < size) {
        if(counter % 16 == 0) {
            fprintf(output, "        ");
        }
        fprintf(output, "%02x", buf[counter]);
        counter++;
        if(counter % 2 == 0) {
            fprintf(output, " ");
        }
        if(counter % 16 == 0) {
            fprintf(output, "\n");
        }
    }

    if(counter % 16 != 0) {
        fprintf(output, "\n");
    }

    return;
}

void usage(void) {
    fprintf(stderr, "usage: echo6s [-b sockbufsiz] [-w file] port\n");
    exit(1);
}
