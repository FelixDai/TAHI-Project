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
 * $Id: general.h,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

#include <pcap.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <sys/param.h>
#include <sys/stat.h>
#include <sys/types.h>

#include <net/ethernet.h>

#include <netinet/in_systm.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/ip6.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>

#define PROG            "rpdump"
#define VERSION         "1.0"


/* flags */
    int bflag;	/* show only BGP4(+) flag */
    int dflag;	/* divide flag */
    int kflag;	/* dosen't show KEEPALIVE flag */
    int nflag;	/* dosen't resolv port flag */
    int rflag;	/* show only RIP(ng) flag */
    int tflag;	/* write to text flag */
    int vflag;	/* verbose mode flag */
    int v4flag;	/* show only IPv4 packets */
    int v6flag;	/* show only IPv6 packets */
    int encap;  /* encapsulation flag */

/* counter */
    int RIP_counter;	/* RIP packet counter */
    int RIPng_counter;	/* RIPng packet counter */
    int BGP_counter;	/* BGP packet counter */

/* pcap */
    pcap_t *pd;
    struct bpf_program fcode;

/* I/O */
    char *txtfile;

/* timestamp */
    int offset;
    char t_stamp[1024];

/* address */
    char addr[1024];
    char r_addr[1024];

/* structs */
    struct pktinfo {
        bpf_u_int32 len;
        const u_char *pkt;
    };

    struct addr_4 {
        u_int32_t src;
        u_int32_t dst;
        int nxtflag; /* 0 = other, 1 = tcp, 2 = udp) */
        union {
	    struct tcphdr *tcp;
	    struct udphdr *udp;
        } __next_p;
    };

    struct addr_6 {
        struct in6_addr src;
        struct in6_addr dst;
        int nxtflag; /* 0 = other, 1 = tcp, 2 = udp) */
        union {
	    struct tcphdr *tcp;
	    struct udphdr *udp;
        } __next_p;
    };

#define p_tcp __next_p.tcp
#define p_udp __next_p.udp

/* ethertypes */
#ifndef ETHERTYPE_IP
#define ETHERTYPE_IP            0x0800  /* IP protocol */
#endif

/* IPv6 */
#ifndef ETHERTYPE_IPV6
#define ETHERTYPE_IPV6          0x86dd /* IPv6 */
#endif

/* routing protocols */
#define RIP_PORT	520
#define RIPNG_PORT	521
#define BGP_PORT	179

/* utility routines */
    extern int help();
    extern int usage();
    extern int version();
    extern void timestamp(const struct timeval *);
    extern char * v4_addr(struct addr_4 *, int); /* struct addr_4, encapflag */
    extern char * v6_addr(struct addr_6 *, int); /* struct addr_6, encapflag */
    extern char * addr4_string(u_int32_t);
    extern char * addr6_string(struct in6_addr *);
    extern char * port_string(int, int, int);

/* analyzer routines */
    extern void ether(u_char *, const struct pcap_pkthdr *, const u_char *);
    extern void ip(struct pktinfo *);
    extern void ipv6(struct pktinfo *);
    extern void udp(struct pktinfo *);
    extern void tcp(struct pktinfo *);

    extern void rip(struct pktinfo *);

    extern void ripng(struct pktinfo *);

    extern void bgp(struct pktinfo *);
    extern void bgp_msg(struct pktinfo *);
    extern void bgp_open(struct pktinfo *, u_int16_t);
    extern void bgp_update(struct pktinfo *, u_int16_t);
    extern void bgp_notify(struct pktinfo *, u_int16_t);
    extern void bgp_keepalive(struct pktinfo *, u_int16_t);
    extern const u_char * bgp_up_attr(const u_char *, u_int16_t);
