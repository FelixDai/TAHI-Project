#include <sys/types.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <net/if.h>

extern char    *optarg;
extern int      optind;
extern int      optopt;
extern int      opterr;
extern int      optreset;

void usage(void) {
    fprintf(stderr, "usage: mcast6s [-I interface] [-c count] [-h hoplimit]");
    fprintf(stderr, " [-i wait] [-s size]\n");
    fprintf(stderr, "               [-w file] address port\n");
    exit(1);
}

int main(int argc, char **argv) {
    FILE               *w;
    char                buf[0xffff];
    float               wait;
    int                 ch;
    int                 count;
    int                 counter;
    int                 err;
    int                 hop_flag;
    int                 hoplimit;
    int                 index;
    int                 index_flag;
    int                 pad;
    int                 s;
    int                 size;
    struct addrinfo    *res;
    struct addrinfo     hints;
    struct timeval      tv;
    struct tm          *now;

    count = 1;
    hoplimit = 0;
    hop_flag = 0;
    index_flag = 0;
    size = 16;
    w = stdout;
    wait = 0;

    while ((ch = getopt(argc, argv, "I:c:h:i:s:w:")) != -1) {
        switch(ch) {
            case 'I':
                index = if_nametoindex(optarg);
                if (index == 0) {
                    perror("if_nametoindex");
                    return(1);
                }
                index_flag = 1;
                break;
            case 'c':
                count = atoi(optarg);
                break;
            case 'h':
                hoplimit = atoi(optarg);
                hop_flag = 1;
                break;
            case 'i':
                wait = atof(optarg);
                break;
            case 's':
                size = atoi(optarg);
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
    hints.ai_flags = AI_CANONNAME;
    hints.ai_family = PF_INET6;
    hints.ai_socktype = SOCK_DGRAM;
    hints.ai_protocol = IPPROTO_UDP;

    err = getaddrinfo(argv[0], argv[1], &hints, &res);
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

    if (hop_flag == 1) {
        err = setsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_HOPS, &hoplimit
                          , sizeof(hoplimit));
        if (err < 0) {
            perror("setsockopt IPV6_MULTICAST_HOPS");
            close(s);
            return(1);
        }
    }

    if (index_flag == 1) {
        err = setsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_IF, &index
                          , sizeof(index));
        if (err < 0) {
            perror("setsockopt IPV6_MULTICAST_IF");
            close(s);
            return(1);
        }
    }

    counter = 0;
    while (counter < count) {
        sprintf(buf, "%04d", counter);
        pad = strlen(buf);
        while (pad < size) {
            buf[pad] = '@';
            pad = pad + 1;
        }

        gettimeofday(&tv, NULL);
        err = sendto(s, buf, size, 0, res->ai_addr, res->ai_addrlen);
        if (err < 0) {
            perror("sendto");
        } else {
        now = localtime(&tv.tv_sec);
            fprintf(w, "sendto: %02d:%02d:%02d.%06ld->%s\n"
                     , now->tm_hour, now->tm_min, now->tm_sec, tv.tv_usec, buf);
        }
        usleep(wait * 1000000);
        counter = counter + 1;
    }
    close(s);
    freeaddrinfo(res);
    return(0);
}
