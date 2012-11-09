#include <sys/types.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <string.h>
#include <net/if.h>
#include <arpa/inet.h>

extern char    *optarg;
extern int      optind;
extern int      optopt;
extern int      opterr;
extern int      optreset;

void usage(void) {
    fprintf(stderr, "usage: mcast6c [-I interface] [-c count] [-w file]");
    fprintf(stderr, " address port\n");
    exit(1);
}

int main(int argc, char **argv) {
    FILE               *w;
    char                buf[0xffff];
    int                 ch;
    int                 count;
    int                 counter;
    int                 err;
    int                 index;
    int                 s;
    struct addrinfo    *res;
    struct addrinfo     hints;
    struct ipv6_mreq    mreq;
    struct timeval      tv;
    struct tm          *now;

    count = 1;
    w = stdout;
    index = 0;

    while ((ch = getopt(argc, argv, "I:c:w:")) != -1) {
        switch(ch) {
            case 'I':
                index = if_nametoindex(optarg);
                if (index == 0) {
                    perror("if_nametoindex");
                    return(1);
                }
                break;
            case 'c':
                count = atoi(optarg);
                break;
            case 'w':
                w = fopen(optarg, "a");
                if (w == NULL) {
                    perror(optarg);
                    return(1);
                }
                break;
            default:
                usage();
        }
    }
    argc -= optind;
    argv += optind;

    if (argc != 2) {
        usage();
    }

    bzero(&hints, sizeof(struct addrinfo));
    hints.ai_flags = AI_PASSIVE;
    hints.ai_family = PF_INET6;
    hints.ai_socktype = SOCK_DGRAM;
    hints.ai_protocol = IPPROTO_UDP;

    err = getaddrinfo(NULL, argv[1], &hints, &res);
    if (err != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(err));
        return(1);
    }

    s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (s < 0) {
        perror("socket");
        close(s);
        return(1);
    }

    mreq.ipv6mr_interface = index;
    inet_pton(res->ai_family, argv[0], &mreq.ipv6mr_multiaddr);

#ifdef LINUX
    err = setsockopt(s, IPPROTO_IPV6, IPV6_ADD_MEMBERSHIP, &mreq, sizeof(mreq));
#else
    err = setsockopt(s, IPPROTO_IPV6, IPV6_JOIN_GROUP, &mreq, sizeof(mreq));
#endif

    if (err < 0) {
        perror("setsockopt IPV6_JOIN_GROUP");
        close(s);
        return (1);
    }

    err = bind(s, res->ai_addr, res->ai_addrlen);
    if (err < 0) {
        perror("bind");
        close(s);
        return(1);
    }

    counter = 0;
    while (counter < count) {
        err = recvfrom(s, buf, sizeof(buf), 0, res->ai_addr, &res->ai_addrlen);
        gettimeofday(&tv, NULL);
        if (err < 0) {
            perror("recvfrom");
        } else {
            now = localtime(&tv.tv_sec);
            fprintf(w, "recvfrom: %02d:%02d:%02d.%06ld->%s\n"
                     , now->tm_hour, now->tm_min, now->tm_sec, tv.tv_usec
                     , buf);
        }
        counter = counter + 1;
    }

#ifdef LINUX
    err = setsockopt(s, IPPROTO_IPV6, IPV6_DROP_MEMBERSHIP, &mreq
                      , sizeof(mreq));
#else
    err = setsockopt(s, IPPROTO_IPV6, IPV6_LEAVE_GROUP, &mreq, sizeof(mreq));
#endif

    if (err < 0) {
        perror("setsockopt IPV6_LEAVE_GROUP");
        close(s);
        return(1);
    }
    close(s);
    freeaddrinfo(res);
    return(0);
}
