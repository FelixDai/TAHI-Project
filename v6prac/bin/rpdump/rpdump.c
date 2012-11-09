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
 * $Id: rpdump.c,v 1.1.2.3 2001/02/08 11:43:06 akisada Exp $
 */

#include "general.h"

struct analyzer {
    pcap_handler f;
    int type;
};

static struct analyzer analyzers[] = {
    { ether,       DLT_EN10MB },
    { ether,       DLT_IEEE802 },
    { NULL,                 0 },
};

static pcap_handler
lookup_datalink(int type) {
    struct analyzer *dl;

    for (dl = analyzers; dl->f; ++dl)
	if (type == dl->type)
	    return dl->f;

    (void)fprintf(stderr, "unknown data link type 0x%x\n", type);
    exit(1);
}

int
main(argc, argv)
    int argc;
    char *argv[];

{
/* getopt */
    extern char *optarg;
    extern int optind;
    int op;

/* interface & in/out file */
    char *interface, *infile, *dmpfile;

/* pcap */
    char errbuf[PCAP_ERRBUF_SIZE];
    u_char *pcap_userdata;
    pcap_handler analyzer;
    u_int32_t	localnet, netmask;
    int promisc, to_ms, snaplen, cnt;

/* timestamp */
    time_t clock;
    struct tm *tp;

/* initialisation */
  /* flags */
    int fflag = 0;      /* set option 'f' flag */
    int iflag = 0;      /* set option 'i' flag */
    bflag = 0;      /* show only BGP4(+) flag */
    kflag = 0;      /* doesn't show KEEPALIVE flag */
    nflag = 0;      /* doesn't resolv port flag */
    rflag = 0;      /* show only RIP(ng) flag */
    vflag = 0;      /* verbose mode flag */
    v4flag = 0;	    /* show only IPv4 packets */
    v6flag = 0;	    /* show only IPv6 packets */

  /* counter */
    RIP_counter = 0;
    RIPng_counter = 0;
    BGP_counter = 0;

  /* pcap */
    pcap_userdata = NULL;
    analyzer = NULL;
    promisc = 1;
    to_ms = 1000;
    snaplen = 4096;
    cnt = -1;
    
  /* timestamp */
    offset = 1;
    tp = NULL;

  /* I/O */
    interface = NULL;
    infile = NULL;
    dmpfile = NULL;

/* end of initialisation */


/* getopt */
    while((op = getopt(argc, argv, "46abi:hknr:RvVw:")) != EOF) {
        switch(op) {
            case '4':
#ifdef DEBUG
    printf("show IPv4 only\n");
#endif
                v4flag = 1;
                break;
            case '6':
#ifdef DEBUG
    printf("show IPv6 only\n");
#endif
                v6flag = 1;
                break;
            case 'b':
#ifdef DEBUG
    printf("show BGP only\n");
#endif
                bflag = 1;
                break;
            case 'h':
                help();
            case 'i':
                iflag = 1;
                interface = optarg;
                break;
	    case 'k':
#ifdef DEBUG
    printf("doesn't show BGP KEEPALIVE\n");
#endif
		kflag = 1;
		break;
            case 'n':
		nflag = 1;
		break;
            case 'r':
                fflag = 1;
                infile = optarg;
                break;
            case 'R':
#ifdef DEBUG
    printf("show RIP/RIPng only\n");
#endif
		rflag = 1;
                break;
            case 'v':
		vflag = 1;
                break;
            case 'V':
                version();
            case 'w':
		dmpfile = optarg;
                break;
            default:
                usage();
        } /* switch */

    } /* while */
    argc -= optind;
    argv += optind;

/* end of getopt */

    if (iflag && fflag) {
        fprintf(stderr, "%s: Don't use with both of 'i' and 'f' option.\n", PROG);
        usage();
    }

    if (v4flag == 1 && v6flag == 1) {
        v4flag = 0;
        v6flag = 0;
    }

    if (bflag == 1 && rflag == 1) {
        rflag = 0;
        bflag = 0;
    }

    if (iflag != 1 && fflag != 1) {
        interface = pcap_lookupdev(errbuf);

#ifdef DEBUG
    (void)printf ("interface = %s\n", interface);
#endif

        if (interface == NULL) {
            (void)fprintf(stderr, "%s: %s\n", PROG, errbuf);
            exit(1);
        }
        iflag = 1;
    }

/* get seconds offset from GMT to local time */
    tp = localtime(&clock);
    offset = tp->tm_gmtoff;
/* end of get seconds offset from GMT to local time */

    if (iflag) {
        if ((pd = pcap_open_live (interface, snaplen, promisc, to_ms, errbuf)) == NULL) {
            (void)fprintf(stderr, "%s(pcap_open_live): %s\n", PROG, errbuf);
	    exit(1);
        }
        (void)printf("%s: listening on %s\n", PROG, interface);
        if (pcap_lookupnet(interface, &localnet, &netmask, errbuf) < 0) {
            (void)fprintf(stderr, "%s(pcap_lookupnet): %s\n", PROG, errbuf);
        }
    }
    else if (infile) {
        if ((pd = pcap_open_offline (infile, errbuf)) == NULL) {
            (void)fprintf(stderr, "%s(pcap_open_offline): %s\n", PROG, errbuf);
	    exit(1);
        }
	localnet = 0;
        netmask = 0;
    }

    setuid(getuid());

    if (dmpfile) {
    } else {
        analyzer = lookup_datalink(pcap_datalink(pd));

#ifdef DEBUG
    printf("datalink_type = %d\n",pcap_datalink(pd));
#endif

    }

    if ((pcap_loop(pd, cnt, analyzer, pcap_userdata)) < 0) {
	(void)fprintf(stderr, "%s(pcap_loop): %s\n", PROG, pcap_geterr(pd));
	exit(1);
    }
    pcap_close(pd);

	if(rflag) {
		if(v6flag && v4flag) {
			printf("RIP %d packets, RIPng %d packets\n", RIP_counter, RIPng_counter);
		} else if(v6flag) {
			printf("RIPng %d packets\n", RIPng_counter);
		} else if(v4flag) {
			printf("RIP %d packets\n", RIP_counter);
		}
	} else if(bflag) {
		printf("BGP %d packets\n", BGP_counter);
	} else {
		printf("RIP %d packets, RIPng %d packets, BGP %d packets\n", RIP_counter, RIPng_counter, BGP_counter);
	}

    return(0);
} /* main */
