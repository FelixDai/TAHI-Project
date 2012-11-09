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
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <string.h>
#include <netinet/in.h>
#include <netinet/ip6.h>
#include <signal.h>
#include <sys/time.h>
#include <unistd.h>
#include <sys/uio.h>
#include <sys/errno.h>
#include <sys/param.h>
#include <net/if.h>
#include <arpa/inet.h>
#include <err.h>

/* PING6 */
#define A(bit)          rcvd_tbl[(bit)>>3]      /* identify byte in array */
#define B(bit)          (1 << ((bit) & 0x07))   /* identify bit in byte */
#define SET(bit)        (A(bit) |= B(bit))
#define CLR(bit)        (A(bit) &= (~B(bit)))
#define TST(bit)        (A(bit) & B(bit))

char rcvd_tbl[0x2000];
/* PING6 */

FILE *output = stdout;
char *send_cmsg_buf = NULL;
char *hostname = NULL;
double max_round_trip = 0.0;
double min_round_trip = 999999999.0;
double sum_round_trip = 0.0;
double wait = 1.0;
int HOPLIMIT = 0;
int INTERFACE = 0;
int NUMERICHOST = 0;
int QUIET = 0;
int SRCADDR = 0;
int controllen = 0;
int hoplimit = 0;
int id = 0;
int s = 0;
int size = 0;
int timing = 0;
long count = 0;
long duplicate = 0;
long recv_count = 0;
long seq = 0;
struct addrinfo *res = NULL;
struct in6_addr addr;
struct msghdr send_msg;
struct sockaddr_in6 dst;
struct sockaddr_in6 src;
struct ip6_rthdr *rthdr = NULL;
u_char send_buf[0x20000];

const char *print_addr(struct sockaddr_in6 *);
int ck_hoplimit(struct msghdr *);
struct in6_pktinfo *ck_in6_pktinfo(struct msghdr *);
void expired(int);
void interrupt(int);
void print_pkt(u_char *, int, struct msghdr *);
void send_message(void);
void summary(void);
void usage(void);

struct echo6_hdr {
    u_int16_t echo6_id;
    u_int16_t echo6_seq;
};

int main(int argc, char **argv) {
    char *ifname = NULL;
    int SEC;
    int counter = 0;
    int err = 0;
    int ifindex = 0;
    int on = 1;
    int recv_size = 0;
    int sockbufsiz = 0;
    struct addrinfo hints;
    struct cmsghdr *send_cmsg = NULL;
    struct in6_pktinfo *send_ipi6 = NULL;
    struct itimerval it;
    struct sockaddr_in6 from;
    u_char *recv_buf = NULL;
    u_char *send_buf_ptr = NULL;

    size = sizeof(struct echo6_hdr) + sizeof(struct timeval);
    send_buf_ptr = &send_buf[sizeof(struct echo6_hdr)];

    {
        extern char *optarg;
        extern int optind;
        int ch = 0;

        while((ch = getopt(argc, argv, "I:S:b:c:h:i:nqs:w:")) != -1) {
            switch(ch) {
                case 'I':
                    INTERFACE = 1;
                    ifname = optarg;
                    ifindex = if_nametoindex(ifname);

                    if(ifindex == 0) {
                        fprintf(stderr, "echo6c: invalid interface name -- %s\n", ifname);
                        usage();
                    }

                    break;
                case 'S':
                    SRCADDR = 1;

                    err = inet_pton(AF_INET6, optarg, &addr);
                    if(err != 1) {
                        fprintf(stderr, "invalid IPv6 address -- %s\n", optarg);
                        usage();
                    }

                    break;
                case 'b':
                    sockbufsiz = atoi(optarg);

                    if(sockbufsiz <= 0) {
                        fprintf(stderr, "illegal sockbufsiz value -- %s\n", optarg);
                        usage();
                    }

                    break;
                case 'c':
                    count = atol(optarg);

                    if(count <= 0) {
                        fprintf(stderr, "illegal number of packets -- %s\n", optarg);
                        usage();
                    }

                    break;
                case 'h':
                    HOPLIMIT = 1;
                    hoplimit = atof(optarg);

                    if((255 < hoplimit) || (hoplimit < -1)) {
                        fprintf(stderr, "illegal hoplimit -- %s\n", optarg);
                        usage();
                    }

                    break;
                case 'i':
                    wait = atof(optarg);

                    if(wait < 0.000001) {
                        fprintf(stderr, "illegal timing interval -- %s\n", optarg);
                        usage();
                    }

                    break;
                case 'n':
                    NUMERICHOST = 1;
                    break;
                case 'q':
                    QUIET = 1;
                    break;
                case 's':
                    size = atoi(optarg);
                    if(size < 0) {
                        fprintf(stderr, "illegal datalen value -- %s\n", optarg);
                        usage();
                    } else if(size < 4) {
                        fprintf(stderr, "datalen value too small, maximum is %d\n", 4);
                        usage();
                    } else if(size > 131024) {
                        fprintf(stderr, "datalen value too large, maximum is %d\n", 131024);
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

    if(argc < 2) {
        usage();
    }

    bzero(&hints, sizeof(struct addrinfo));
    if(NUMERICHOST == 0) {
        hints.ai_flags = AI_CANONNAME;
    }
    hints.ai_family = PF_INET6;
    hints.ai_socktype = SOCK_DGRAM;
    hints.ai_protocol = IPPROTO_UDP;

    if(size >= sizeof(struct echo6_hdr) + sizeof(struct timeval)) {
        timing = 1;
    }

    for(counter = 4; counter < size; ++counter) {
        *send_buf_ptr++ = counter;
    }

    if(HOPLIMIT == 1) {
        controllen+= CMSG_SPACE(sizeof(int));
    }

    if((INTERFACE == 1) || (SRCADDR == 1)) {
        controllen+= CMSG_SPACE(sizeof(struct in6_pktinfo));
    }

    if(argc > 2) {
        controllen+= CMSG_SPACE(inet6_rth_space(IPV6_RTHDR_TYPE_0, argc - 2));
/* RFC2292
        controllen+= inet6_rthdr_space(IPV6_RTHDR_TYPE_0, argc - 2);
 */
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

    if(HOPLIMIT == 1) {
        send_cmsg->cmsg_len = CMSG_LEN(sizeof(int));
        send_cmsg->cmsg_level = IPPROTO_IPV6;
        send_cmsg->cmsg_type = IPV6_HOPLIMIT;
        *(int *)(CMSG_DATA(send_cmsg)) = hoplimit;

        send_cmsg = CMSG_NXTHDR(&send_msg, send_cmsg);
    }

    if((INTERFACE == 1) || (SRCADDR == 1)) {
        send_ipi6 = (struct in6_pktinfo *)CMSG_DATA(send_cmsg);
        memset(send_ipi6, 0, sizeof(*send_ipi6));
        send_cmsg->cmsg_len = CMSG_LEN(sizeof(struct in6_pktinfo));
        send_cmsg->cmsg_level = IPPROTO_IPV6;
        send_cmsg->cmsg_type = IPV6_PKTINFO;
        send_cmsg = CMSG_NXTHDR(&send_msg, send_cmsg);

        if(INTERFACE == 1) {
            send_ipi6->ipi6_ifindex = ifindex;
        } else {
            bzero(&send_ipi6->ipi6_ifindex, sizeof(send_ipi6->ipi6_ifindex));
        }

        if(SRCADDR == 1) {
            send_ipi6->ipi6_addr = addr;
        } else {
            bzero(&send_ipi6->ipi6_addr, sizeof(struct in6_addr));
        }
    }

    if(argc > 2) {
        int hops = 0;
	int rthdrlen = 0;

	rthdrlen = inet6_rth_space(IPV6_RTHDR_TYPE_0, argc - 2);
	send_cmsg->cmsg_len = CMSG_LEN(rthdrlen);
	send_cmsg->cmsg_level = IPPROTO_IPV6;
	send_cmsg->cmsg_type = IPV6_RTHDR;
	rthdr = (struct ip6_rthdr *)CMSG_DATA(send_cmsg);
	rthdr = inet6_rth_init((void *)rthdr, rthdrlen, IPV6_RTHDR_TYPE_0, argc - 2);

/* RFC2292
        send_cmsg = (struct cmsghdr *)inet6_rthdr_init(send_cmsg, IPV6_RTHDR_TYPE_0);
        if(send_cmsg == NULL) {
            perror("inet6_rthdr_init");
            free(send_cmsg_buf);
            return(1);
        }
 */

	if(rthdr == NULL) {
		errx(1, "can't initialize rthdr");
	}

        for(hops = 0; hops < argc - 2; hops++) {
            struct addrinfo *rth_res = NULL;

            err = getaddrinfo(argv[hops], NULL, &hints, &rth_res);
            if(err != 0) {
                fprintf(stderr, "%s\n", gai_strerror(err));
                freeaddrinfo(rth_res);
                free(send_cmsg_buf);
                return(1);
            }

		if(inet6_rth_add(rthdr, &((struct sockaddr_in6 *)(rth_res->ai_addr))->sin6_addr)) {
			errx(1, "can't add an intermediate node");
		}

/* RFC2292
            err = inet6_rthdr_add(send_cmsg, &((struct sockaddr_in6 *)rth_res->ai_addr)->sin6_addr, IPV6_RTHDR_LOOSE);
            if(err != 0) {
                perror("inet6_rthdr_add");
                freeaddrinfo(rth_res);
                free(send_cmsg_buf);
                return(1);
            }
 */

            freeaddrinfo(rth_res);
        }

/* RFC2292
        if(inet6_rthdr_lasthop(send_cmsg, IPV6_RTHDR_LOOSE) != 0) {
            perror("inet6_rthdr_lasthop");
            free(send_cmsg_buf);
            return(1);
        }
 */
        send_cmsg = CMSG_NXTHDR(&send_msg, send_cmsg);
    }

    err = getaddrinfo(argv[argc - 2], argv[argc - 1], &hints, &res);
    if (err != 0) {
        freeaddrinfo(res);
        fprintf(stderr, "%s\n", gai_strerror(err));
        return(1);
    }

    if(res->ai_canonname != 0) {
        hostname = res->ai_canonname;
    } else {
        hostname = argv[argc - 2];
    }

    memcpy(&dst, res->ai_addr, res->ai_addrlen);

    s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if(s < 0) {
        close(s);
        freeaddrinfo(res);
        perror("socket");
        return(1);
    }

    err = setsockopt(s, IPPROTO_IPV6, IPV6_RECVPKTINFO, &on, sizeof(on));
    if(err != 0) {
        perror("setsockopt(IPV6_RECVPKTINFO)");
        close(s);
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

    recv_size = 40 + 8 + 256 + size;
    recv_buf = (u_char *)malloc((u_int)recv_size);
    if(recv_buf == NULL) {
        close(s);
        freeaddrinfo(res);
        perror("malloc");
        return(1);
    }

    if(sockbufsiz != 0) {
        int recv_sockbufsiz = 0;

        recv_sockbufsiz = 40 + 8 + 256 + sockbufsiz;

        if(size > sockbufsiz) {
            fprintf(stderr, "you need -b to increase socket buffer size\n");
        }

        err = setsockopt(s, SOL_SOCKET, SO_SNDBUF, &sockbufsiz, sizeof(sockbufsiz));
        if(err != 0) {
            perror("setsockopt(SO_SNDBUF)");
            close(s);
            freeaddrinfo(res);
            free(recv_buf);
            return(1);
        }

        err = setsockopt(s, SOL_SOCKET, SO_RCVBUF, &recv_sockbufsiz, sizeof(recv_sockbufsiz));
        if(err != 0) {
            perror("setsockopt(SO_RCVBUF)");
            close(s);
            freeaddrinfo(res);
            free(recv_buf);
            return(1);
        }
    } else if(size > 8 * 1024) {
        fprintf(stderr, "you need -b to increase socket buffer size\n");
    }

    {
        int tmp = 0;
        int namelen = 0;

        namelen = sizeof(src);

        tmp = socket(AF_INET6, SOCK_DGRAM, 0);
        if(tmp < 0) {
            perror("socket");
            close(tmp);
            close(s);
            freeaddrinfo(res);
            free(recv_buf);
            return(1);
        }

        src.sin6_family = AF_INET6;
        src.sin6_addr = dst.sin6_addr;
        src.sin6_port = ntohs(31337);
        src.sin6_scope_id = dst.sin6_scope_id;

	if(send_ipi6 != NULL) {
		err = setsockopt(tmp, IPPROTO_IPV6, IPV6_PKTINFO, (void *)send_ipi6, sizeof(*send_ipi6));
		if(err != 0) {
			perror("setsockopt(IPV6_PKTINFO)");
			close(tmp);
			close(s);
			freeaddrinfo(res);
			free(recv_buf);
			return(1);
		}
	}

	if(HOPLIMIT == 1) {
		err = setsockopt(tmp, IPPROTO_IPV6, IPV6_HOPLIMIT, (void *)&hoplimit, sizeof(hoplimit));
		if(err != 0) {
			perror("setsockopt(IPV6_HOPLIMIT)");
			close(tmp);
			close(s);
			freeaddrinfo(res);
			free(recv_buf);
			return(1);
		}
	}

	if(rthdr != NULL) {
/* TMP
		err = setsockopt(tmp, IPPROTO_IPV6, IPV6_RTHDR, (void *)rthdr, ((rthdr->ip6r_len + 1) << 3));
 */
err = setsockopt(tmp, IPPROTO_IPV6, IPV6_RTHDR, (void *)rthdr, (rthdr->ip6r_len + 1) << 3);

		if(err != 0) {
			perror("setsockopt(IPV6_RTHDR)");
			close(tmp);
			close(s);
			freeaddrinfo(res);
			free(recv_buf);
			return(1);
		}
	}

/* RFC2292
        if(controllen != 0) {
            err = setsockopt(tmp, IPPROTO_IPV6, IPV6_PKTOPTIONS, (void *)send_msg.msg_control, send_msg.msg_controllen);
            if(err != 0) {
                perror("setsockopt(IPV6_PKTOPTIONS)");
                close(tmp);
                close(s);
                freeaddrinfo(res);
                free(recv_buf);
                return(1);
            }
        }
 */

        err = connect(tmp, (struct sockaddr *)&src, namelen);
        if(err < 0) {
            perror("UDP connect");
            close(tmp);
            close(s);
            freeaddrinfo(res);
            free(recv_buf);
            return(1);
        }

        err = getsockname(tmp, (struct sockaddr *)&src, &namelen);
        if(err < 0){
            perror("getsockname");
            close(tmp);
            close(s);
            freeaddrinfo(res);
            free(recv_buf);
            return(1);
        }

        close(tmp);
    }

    id = getpid() & 0xFFFF;

    fprintf(output, "ECHO6(%d=40+8+%d bytes) ", size + 48, size);
    fprintf(output, "%s --> ", print_addr(&src));
    fprintf(output, "%s\n", print_addr(&dst));

    signal(SIGALRM, expired);
    signal(SIGINT, interrupt);

    SEC = wait * 1000000;
    it.it_interval.tv_sec = SEC /1000000;
    it.it_interval.tv_usec = SEC % 1000000;
    it.it_value.tv_sec = 0;
    it.it_value.tv_usec = 1;

    setitimer(ITIMER_REAL, &it, NULL);

    for( ; ; ) {
        struct cmsghdr *recv_cmsg = NULL;
        struct iovec recv_iov;
        struct msghdr recv_msg;
        u_char recv_cmsg_buf[1024];

        memset(&recv_iov, 0, sizeof(recv_iov));
        recv_iov.iov_base = (caddr_t)recv_buf;
        recv_iov.iov_len = recv_size;

        recv_msg.msg_name = (caddr_t)&from;
        recv_msg.msg_namelen = sizeof(from);
        recv_msg.msg_iov = &recv_iov;
        recv_msg.msg_iovlen = 1;

        recv_cmsg = (struct cmsghdr *)recv_cmsg_buf;
        recv_msg.msg_control = (caddr_t)recv_cmsg_buf;
        recv_msg.msg_controllen = sizeof(recv_cmsg_buf);

        err = recvmsg(s, &recv_msg, 0);
        if(err < 0) {
            if(errno == EINTR) {
                continue;
            } else {
                perror("recvmsg");
                continue;
            }
        }

        print_pkt(recv_buf, err, &recv_msg);

        if(count && recv_count >= count) {
            break;
        }
    }

    summary();

    free(recv_buf);
    close(s);
    freeaddrinfo(res);
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

void ck_round_trip(register struct timeval *in, register struct timeval *out) {
    in->tv_usec = in->tv_usec - out->tv_usec;

    if(in->tv_usec < 0) {
        in->tv_usec = in->tv_usec + 1000000;
        in->tv_sec--;
    }

    in->tv_sec = in->tv_sec - out->tv_sec;
}

void expired(int sig) {
    struct itimerval it;

    if((count == 0) || (seq < count)) {
        send_message();
        return;
    }

    signal(SIGALRM, interrupt);

    if(recv_count != 0) {
        it.it_value.tv_sec =  2 * max_round_trip / 1000;

        if(it.it_value.tv_sec == 0) {
            it.it_value.tv_sec = 1;
        }

    } else {
            it.it_value.tv_sec = 10;
    }

    it.it_interval.tv_sec = 0;
    it.it_interval.tv_usec = 0;
    it.it_value.tv_usec = 0;

    setitimer(ITIMER_REAL, &it, NULL);

    return;
}

void interrupt(int sig) {
    summary();

    signal(SIGINT, SIG_DFL);
    kill(getpid(), SIGINT);
    exit(1);
}

const char *print_addr(struct sockaddr_in6 *addr) {
    int flags = 0;
    static char host[MAXHOSTNAMELEN];

    if(NUMERICHOST == 1) {
        flags = NI_NUMERICHOST;
    }

    flags |= NI_WITHSCOPEID;

    getnameinfo((struct sockaddr *)addr, addr->sin6_len, host, sizeof(host), NULL, 0, flags);
    return(host);
}

void print_pkt(u_char *recv_buf, int err, struct msghdr *recv_msg) {
    double round_trip = 0;
    int dupflag = 0;
    int recv_hoplimit = 0;
    struct echo6_hdr *echo6 = NULL;
    struct in6_pktinfo *recv_ipi6 = NULL;
    struct sockaddr_in6 *from = (struct sockaddr_in6 *)recv_msg->msg_name;
    struct timeval tp;
    struct timeval *time_ptr;

    if(timing == 1) {
        gettimeofday(&tp, NULL);
    }

    echo6 = (struct echo6_hdr *)recv_buf;

    if(echo6->echo6_id != id) {
printf("  DEBUG  echo6->echo6_id = [%d] id = [%d]\n", echo6->echo6_id, id);
        return;
    } else {
        recv_count++;

        if(timing == 1) {
            time_ptr = (struct timeval *)&recv_buf[sizeof(struct echo6_hdr)];
            ck_round_trip(&tp, time_ptr);
            round_trip = ((double)tp.tv_sec) * 1000.0 + ((double)tp.tv_usec) / 1000.0;

            sum_round_trip += round_trip;

            if(round_trip < min_round_trip) {
                min_round_trip = round_trip;
            }

            if(round_trip > max_round_trip) {
                max_round_trip = round_trip;
            }
        }

/* PING6 */
        if(TST(echo6->echo6_seq % 0x10000)) {
            ++duplicate;
            --recv_count;
            dupflag = 1;
        } else {
            SET(echo6->echo6_seq % 0x10000);
            dupflag = 0;
        }
/* PING6 */

        if(QUIET == 1) {
            return;
        }

        recv_hoplimit = ck_hoplimit(recv_msg);
        if(recv_hoplimit == -1) {
            fprintf(stderr, "failed to get receiving hop limit\n");
            return;
        }

        recv_ipi6 = ck_in6_pktinfo(recv_msg);
        if(recv_ipi6 == NULL) {
            fprintf(stderr, "failed to get receiving pakcet information\n");
            return;
        }

        fprintf(output, "%d bytes from %s, echo6_seq=%u", err, print_addr(from), echo6->echo6_seq);
        fprintf(output, " hlim=%d", recv_hoplimit);

        if(timing == 1) {
            fprintf(output, " time=%g ms", round_trip);
        }

        if(dupflag == 1) {
            printf("(DUP!)");
        }

        fprintf(output, "\n");
        fflush(output);
        return;
    }
}

void send_message(void) {
    int err = 0;
    struct echo6_hdr *echo6 = NULL;
    struct iovec send_iov;

    echo6 = (struct echo6_hdr *)send_buf;
    echo6->echo6_id = id;
    echo6->echo6_seq = seq++;

    if(timing == 1) {
        gettimeofday((struct timeval *)&send_buf[sizeof(struct echo6_hdr)], NULL);
    }

    memset(&send_iov, 0, sizeof(send_iov));
    send_iov.iov_base = send_buf;
    send_iov.iov_len = size;

    send_msg.msg_name = (caddr_t)&dst;
    send_msg.msg_namelen = sizeof(dst);
    send_msg.msg_iov = &send_iov;
    send_msg.msg_iovlen = 1;

    err = sendmsg(s, &send_msg, 0);
    if((err == -1) || (err != size)) {
        perror("sendmsg");
        (void)printf("echo6c: wrote %s %d chars, ret=%d\n", hostname, size, err);
    }

    return;
}

void summary(void) {
    register int avg_round_trip = 0;

    fprintf(output, "\n--- %s echo6c statistics ---\n", hostname);
    fprintf(output, "%ld packets transmitted, ", seq);
    fprintf(output, "%ld packets received, ", recv_count);

    if(duplicate != 0) {
        printf("+%ld duplicates, ", duplicate);
    }

    if(seq != 0) {
        if (recv_count > seq) {
            fprintf(output, "-- somebody's printing up packets!");
        } else {
            fprintf(output, "%d%% packet loss", (int)(((seq - recv_count) * 100) / seq));
        }
    }

    fprintf(output, "\n");

    if((recv_count != 0) && (timing == 1)) {
        avg_round_trip = 1000.0 * sum_round_trip / recv_count;
        fprintf(output, "round-trip min/avg/max = %g/%g/%g ms\n", min_round_trip, ((double)avg_round_trip) / 1000.0, max_round_trip);
        fflush(output);
    }
}

void usage(void) {
    fprintf(stderr, "usage: echo6c [-nq] [-I interface] [-S sourceaddr] [-b sockbufsiz] [-c count] [-h hoplimit] [-i wait] [-s packetsize] [-w file] [hops...] host port\n");
    exit(1);
}
