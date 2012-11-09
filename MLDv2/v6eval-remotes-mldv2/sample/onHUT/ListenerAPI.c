/*****************************************************************************/
/* ListenerAPI */
/*  2009.08.19 first */
/*  2009.12.24 Happy holiday version */
/*  2010.02.22 World scout friendship day version */
/*****************************************************************************/
/*
   This is a sample of the MLDv2 listeners application based on the service
   interface of RFC3810 section 3.

   This application is started with a signal, reads an operation in a command
   file, and calls MLDv2 listeners' service interface.

   It was tried in FreeBSD and Linux. The function of a service interface is
   chosen in a SelectSI() function. it seems that however, there is a part
   which is not supported in these OS's..
    setsourcefilter()
    setsockopt(,,MSFILTER,,)
*/
/*****************************************************************************/
/* Pre process
/*****************************************************************************/
/*
 OS       OS detail
 -------- ---------
 FREEBSD8 FreeBSD 8.0-RELEASE
 LINUX26  Linux 2.6.26-8
 USAGI    Linux 2.6.26-8 + usagi mcast-tool
*/
#define FREEBSD8

/*****************************************************************************/
/* include
/*****************************************************************************/
#include <sys/types.h>  /* socket, bind, setsockopt, getaddrinfo, freeaddrinfo */
#include <sys/socket.h> /* socket, bind, setsockopt, getaddrinfo, freeaddrinfo,
                           setsourcefilter */
#include <netinet/in.h> /* setsourcefilter */
#include <net/if.h>     /* if_nametoindex */
#include <netdb.h>      /* getaddrinfo, freeaddrinfo */
#include <unistd.h>     /* close */
#include <ctype.h>      /* isspace */
#include <errno.h>      /* errno */
#include <stdlib.h>     /* atoi, exit */
#include <stdio.h>      /* printf, fopen, fclose, fgetc */
#include <string.h>     /* memset, memcpy, strcmp, strcpy, strerror */
#include <pthread.h>    /* sigwait */
#include <signal.h>     /* sigwait, sigemptyset, sigaddset, sigprocmask */

/*****************************************************************************/
/* configuration
/*****************************************************************************/
/*
 conf_display display level
 ------------ ------------
            0 displays nothing
            1 displays any MLDv2 function call
            2 displays any function call
*/
int conf_display = 1;

/*
 conf_exec execution opportunity
 --------- ---------------------
         0 executes at a fixed interval (for debug)
         1 executes with a wakeup signal (for TAHI conformance test tool)
*/
int conf_exec = 1;

/* command file path */
char command_filepath[64]   = "./mldcommand.txt";

/*
 mldcommand.txt
 It of only one line is described at a time at once.
 syntax
   <socket id> <device id> <multiucast address> <mode> <number of source> <source address ..>

 e.g.)
   ---
   S1 fxp0 ff05::101 INCLUDE 1 2000::1
   ---

   ---
   S1 fxp0 ff05::101 INCLUDE 2 2000::1 2000::2
   ---

   ---
   S1 fxp0 ff05::101 EXCLUDE 0
   ---

   ---
   S1 fxp0 ff05::101 EXCLUDE 1 2000::1
   ---

   ---
   S1 fxp0 ff05::101 EXCLUDE 2 2000::1 2000::2
   ---

   ---
   S1 fxp0 ff05::101 INCLUDE 0
   ---
*/

/*****************************************************************************/
/* configuration depend on OS
/*****************************************************************************/
/*
 OS       signal to wake up
 -------- -----------------
 FREEBSD8 SIGINT
 LINUX26  SIGUSR1
 USAGI    SIGUSR1
*/
#if defined FREEBSD8
#define WAKEUP_SIGNAL       SIGINT
#define WAKEUP_SIGNAL_NAME  "SIGINT"
#elif defined LINUX26 || defined USAGI
#define WAKEUP_SIGNAL       SIGUSR1
#define WAKEUP_SIGNAL_NAME  "SIGUSR1"
#endif

/*****************************************************************************/
/* table */
/*****************************************************************************/
#define SOCKET_NUM  10
#define SRCLST_NUM  100
#define ADDR_LEN    40

/* struct address entry */
struct addr_entry {
	char addr_str[ADDR_LEN];
};
typedef struct addr_entry addr_entry_t;

/* struct command table */
struct command_table {
	char            sock_str[8];
	char            if_str[8];
	addr_entry_t    mcast_entry;
	char            fmode_str[8];
	char            num_str[8];
	addr_entry_t    msrc_list[SRCLST_NUM];
};

/* struct socket entry */
struct socket_entry {
	char sock_str[8];
	int  sock_id;
	int  mld_exist; /* 0: nothing, 1: exist */
};
typedef struct socket_entry socket_entry_t;

/* struct socket table */
struct socket_table {
	socket_entry_t entry[SOCKET_NUM];
};

/* tables */
struct command_table Command_ST;
struct socket_table Socket_ST;
int Socket_NO = -1;

/*****************************************************************************/
/* proto type */
/*****************************************************************************/
/* original filter mode */
#define FMODE_INCLUDE 1
#define FMODE_EXCLUDE 2

/* original id for service intareface */
#define SI_NOSUPPORT           -1
#define SI_NEEDLESS             0
#define SI_SETSOCKOPT_GROUP     1
#define SI_SETSOCKOPT_SOURCE    2
#define SI_SETSOCKOPT_MSFILTER 10
#define SI_SETSOURCEFILTER     20

int InitFunc(void);
int InitCommand(void);
int InitSocket(void);
int ReadCommand(char *);
int GetSocket(char *);
int IPv6MulticastListen(int, int, addr_entry_t *, int, int, addr_entry_t *);
int SelectSI(int, int, int);
void TermFunc(void);

/*****************************************************************************/
/* main */
/*****************************************************************************/
int main (int argc, char **argv) {
int rc;
sigset_t sig_set;
int sig_no;
int sock_id;
int if_id;
int fmode;
char *tfmode;
int src_num;

	/* initial */
	rc = InitFunc();
	if (rc != 0) {
		return (-1);
	}

	if (conf_exec == 1) {
		/* set signal */
		if (conf_display>1) printf("call sigemptyset(&sig_set)\n");
		sigemptyset(&sig_set);
		if (conf_display>1) printf("call sigaddset(&sig_set, %s(%d))\n", WAKEUP_SIGNAL_NAME, WAKEUP_SIGNAL);
		rc = sigaddset(&sig_set, WAKEUP_SIGNAL);
		if (rc != 0) {
			printf("return %d sigaddset() w/ errno %d, %s\n", rc, errno, strerror(errno));
			return (-1);
		}
		if (conf_display>1) printf("call sigprocmask(SIG_BLOCK(%d), &sig_set, NULL)\n", SIG_BLOCK);
		rc = sigprocmask(SIG_BLOCK, &sig_set, NULL);
		if (rc != 0) {
			printf("return %d sigaddset() w/ errno %d, %s\n", rc, errno, strerror(errno));
			return (-1);
		}
	}

	/* loop */
	while (1) {

		if (conf_exec == 1) {
			/* wait signal */
			if (conf_display>1) printf("call sigwait(&sig_set, &sig_no)\n");
			sigwait(&sig_set, &sig_no);
			if (sig_no != WAKEUP_SIGNAL) {
				continue;
			}
		}

		/* read command */
		rc = ReadCommand(command_filepath);
		if (rc != 0) {
			break;
		}

		/* get & find socket */
		sock_id = GetSocket(Command_ST.sock_str);
		if (sock_id < 0) {
			break;
		}

		/* find inferface */
		if (conf_display>1) printf("call if_nametoindex(%s)\n", Command_ST.if_str);
		if_id = if_nametoindex(Command_ST.if_str);
		if (if_id == 0) {
			printf("return %d if_nametoindex() w/ errno %d, %s\n", if_id, errno, strerror(errno));
			break;
		}

		/* filter mode */
		if (strcmp(Command_ST.fmode_str, "INCLUDE") == 0) {
			fmode = FMODE_INCLUDE;
			tfmode = "INCLUDE";
		}
		else if (strcmp(Command_ST.fmode_str, "EXCLUDE") == 0) {
			fmode = FMODE_EXCLUDE;
			tfmode = "EXCLUDE";
		}
		else {
			printf("syntax error: filter mode %s\n", Command_ST.fmode_str);
			break;
		}

		/* number of sources */
		if (conf_display>1) printf("call atoi(%s)\n", Command_ST.num_str);
		src_num = atoi(Command_ST.num_str);

		/****************************************/
		/* common service interface in RFC 3810 */
		/****************************************/
		printf("call IPv6MulticastListen(%d, %d, %s, %s, %d, &source_list)\n",
			sock_id, if_id, Command_ST.mcast_entry.addr_str, tfmode, src_num);
		rc = IPv6MulticastListen(sock_id, if_id, &Command_ST.mcast_entry,
			fmode, src_num, Command_ST.msrc_list);
		if (rc != 0) {
			/*
			printf("return %d IPv6MulticastListen() w/ errno %d, %s\n", rc, errno, strerror(errno));
			*/
			break;
		}

		if (conf_exec == 0) {
			/* sleep for a fixed interval */
			if (conf_display>1) printf("call sleep(10)\n");
			sleep(10);
		}
	}

	/* term */
	TermFunc();
	exit(0);
}

/*****************************************************************************/
/* initialize finction */
/*****************************************************************************/
int InitFunc (void) {

	/* alloc & initial memory */
	InitCommand();
	InitSocket();
	return (0);
}

/*****************************************************************************/
/* initialize command table */
/*****************************************************************************/
int InitCommand (void) {
	memset(&Command_ST, 0x00, sizeof(Command_ST));
	return (0);
}

/*****************************************************************************/
/* initialize socket table */
/*****************************************************************************/
int InitSocket (void) {
	memset(&Socket_ST, 0x00, sizeof(Socket_ST));
	return (0);
}

/*****************************************************************************/
/* read command */
/*****************************************************************************/
int ReadCommand (char *filepath) {
int id=0, i=0;
FILE *fp;
int c;

	/* clear command table */
	InitCommand();

	/* open command file */
	if (conf_display>1) printf("call fopen(%s, r)\n", filepath);
	fp = fopen(filepath, "r");
	if (fp == NULL) {
		printf("return %x fopen() w/ errno %d, %s\n", fp, errno, strerror(errno));
		return (-1);
	}

	/* read & strage command */
	while (1) {
		c = fgetc(fp);
		if (c == EOF) {
			break;
		}
		if (isspace(c)) {
			if (i != 0) {
				/* next word */
				id ++;
				i = 0;
			}
			continue;
		}
		switch (id) {
		case 0: /* socket */
			Command_ST.sock_str[i] = (char)c;
			break;
		case 1: /* interface */
			Command_ST.if_str[i] = (char)c;
			break;
		case 2: /* multicast address */
			Command_ST.mcast_entry.addr_str[i] = (char)c;
			break;
		case 3: /* filter mode */
			Command_ST.fmode_str[i] = (char)c;
			break;
		case 4: /* number of sources */
			Command_ST.num_str[i] = (char)c;
			break;
		default: /* source */
			Command_ST.msrc_list[id - 5].addr_str[i] = (char)c;
			break;
		}
		i++;
	}

	/* close file */
	if (conf_display>1) printf("call fclose(fp)\n");
	fclose(fp);

	if (id < 4) {
		printf("syntax error: few arguments %d < 4\n", id);
		return (-1);
	}

	return (0);
}

/*****************************************************************************/
/* get socket */
/*****************************************************************************/
int GetSocket (char *sock_str) {
int i;
int n = -1;
int sock_id;
struct sockaddr_in6 sa_in6;
int rc;

	/* serch */
	for (i=0; i<SOCKET_NUM; i++) {
		/* verify ID */
		if (strcmp(sock_str, Socket_ST.entry[i].sock_str) == 0) {
			/* Bingo! Already exist */
			/* current number in Socket_ST */
			Socket_NO = i;
			return (Socket_ST.entry[i].sock_id);
		}
		/* prepare emtpy entry */
		else if ((n == -1) && Socket_ST.entry[i].sock_id == 0) {
			break;
		}
	}

	/* get empty entry */
	if (i == SOCKET_NUM) {
		printf("error: socket table is an overflow, %d entry\n", SOCKET_NUM);
		return (-1);
	}

	/* create socket */
	if (conf_display>1) printf("call socket(PF_INET6, SOCK_DGRAM, IPPROTO_UDP)\n");
	sock_id = socket(PF_INET6, SOCK_DGRAM, IPPROTO_UDP);
	if (sock_id < 0) {
		printf("return %d socket() w/ errno %d, %s\n", sock_id, errno, strerror(errno));
		return (-1);
	}

	/* set new entry */
	strcpy(Socket_ST.entry[i].sock_str, sock_str);
	Socket_ST.entry[i].sock_id = sock_id;
	Socket_ST.entry[i].mld_exist = 0;
	/* current number in Socket_ST */
	Socket_NO = i;

	/* bind */
	/*
	memset(&sa_in6, 0, sizeof(sa_in6));
	sa_in6.sin6_family = PF_INET6;
	sa_in6.sin6_port   = htons(5555);
	sa_in6.sin6_addr   = in6addr_any;
	if (conf_display>1) printf("call bind(%d, &sa_in6, %d)\n", sock_id, sizeof(sa_in6));
	rc = bind(sock_id, (struct sockaddr *)&sa_in6, sizeof(sa_in6));
	if (rc != 0) {
		printf("return %d bind() w/ errno %d, %s\n", rc, errno, strerror(errno));
		return (-1);
	}
	*/

	return (sock_id);
}

/*****************************************************************************/
/* IPv6MulticastListen */
/*   common service interface in RFC3810 */
/*   convert into the function of implementation dependence */
/*****************************************************************************/
int IPv6MulticastListen (int sock_id, int if_id, addr_entry_t *mcast_entry, int fmode, int src_num, addr_entry_t *msrc_list) {

struct sockaddr sa_mcast;
struct sockaddr_in6 sa6_mcast;
struct sockaddr_storage sa_msrc_list[SRCLST_NUM];
struct addrinfo hints;
struct addrinfo *res;
int rc;
int af;
int i;
int si_id;
socklen_t sa_len;
int fm;
int optname;
char *toptname;
void *optval;
socklen_t optlen;
#if defined FREEBSD8
struct ipv6_mreq mcast_req;
struct group_source_req mcast_src1_req;
struct __msfilterreq mcast_srcs_req;
#elif defined LINUX26 || defined USAGI
struct group_req mcast_req;
struct group_source_req mcast_src1_req;
struct group_filter_n
{
	unsigned int                     gf_interface;  /* interface index */
	struct sockaddr_storage          gf_group;      /* multicast address */
	unsigned int                     gf_fmode;      /* filter mode */
	unsigned int                     gf_numsrc;     /* number of sources */
	struct sockaddr_storage          gf_slist[SRCLST_NUM];  /* source addresses */
};
struct group_filter_n mcast_srcs_req;
#endif

	/* clear */
	memset(&sa_mcast, 0x00, sizeof(struct sockaddr));
	memset(&sa6_mcast, 0x00, sizeof(struct sockaddr_in6));
	memset(&sa_msrc_list[0], 0x00, sizeof(struct sockaddr_storage) * SRCLST_NUM);

	/* create sockaddr(=sockaddr_storage) for multicast */
//	sa_mcast.sa_family = PF_UNSPEC;
	memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_flags = AI_NUMERICHOST;
//	hints.ai_family = PF_UNSPEC;
	hints.ai_family = PF_INET6;
	hints.ai_socktype = 0;
//	hints.ai_socktype = SOCK_STREAM;
//	hints.ai_socktype = SOCK_DGRAM;
//	hints.ai_socktype = SOCK_RAW;
	hints.ai_protocol = 0;
//	hints.ai_protocol = IPPROTO_TCP;
//	hints.ai_protocol = IPPROTO_UDP;
//	hints.ai_addrlen  = 0;
//	hints.ai_canonname = NULL;
//	hints.ai_addr = NULL;
//	hints.ai_next = NULL;
	if (conf_display>1) printf("call getaddrinfo(%s, NULL, &hints, &res)\n", mcast_entry->addr_str);
	rc = getaddrinfo(mcast_entry->addr_str, NULL, &hints, &res);
	if (rc != 0) {
		printf("return %d getaddrinfo() w/ errno %d, %s\n", rc, errno, gai_strerror(errno));
		return (-1);
	}
//	af = res->ai_family;
	memcpy(&sa_mcast, res->ai_addr, res->ai_addrlen);
	freeaddrinfo(res);

	/* create sockaddr_in6 for multicast */
#if defined FREEBSD8
	sa6_mcast.sin6_len = sizeof(struct sockaddr_in6);
#endif
	sa6_mcast.sin6_family = AF_INET6;
	sa6_mcast.sin6_port = htons(5555);
	sa6_mcast.sin6_flowinfo = 0;
	if (conf_display>1) printf("call inet_pton(AF_INET6, %s, &(sa6_mcast.sin6_addr))\n", mcast_entry->addr_str);
	rc = inet_pton(AF_INET6, mcast_entry->addr_str, &(sa6_mcast.sin6_addr));
	if (rc != 1) {
		if (rc == 0) {
			printf("syntax error: multicast address %s\n", mcast_entry->addr_str);
		}
		else {
			printf("return %d inet_pton() w/ errno %d, %s\n", rc, errno, gai_strerror(errno));
		}
		return (-1);
	}
	sa6_mcast.sin6_scope_id = 0xff;

	/* multicast source list */
	for (i=0; i<src_num; i++) {
//		sa_msrc_list[i].ss_family = PF_UNSPEC;
//		hints.ai_family = af;

		/* create sockaddr(=sockaddr_storage) multicast source */
		if (conf_display>1) printf("call getaddrinfo(%s, NULL, &hints, &res)\n", msrc_list[i].addr_str);
		rc = getaddrinfo(msrc_list[i].addr_str, NULL, &hints, &res);
		if (rc != 0) {
			printf("return %d getaddrinfo() w/ errno %d, %s\n", rc, errno, gai_strerror(errno));
			return (-1);
		}
		memcpy(&sa_msrc_list[i], res->ai_addr, res->ai_addrlen);
		freeaddrinfo(res);
	}

	/*********************************************************************/
	/* service interface depend on implementation */
	/*********************************************************************/
	si_id = SelectSI(fmode, src_num, Socket_ST.entry[Socket_NO].mld_exist);
	switch (si_id) {
	case SI_NEEDLESS:
		printf("INFO: Needless.\n");
		break;

	case SI_SETSOCKOPT_GROUP:
		/*************************************************************/
		/*
		int setsockopt(
			int s, // socket id
			int level, // IPPROTO_IPV6
			int optname, // FREEBSD8: IPV6_JOIN_GROUP,IPV6_LEAVE_GROUP
			             // LINUX26 : MCAST_JOIN_GROUP,MCAST_LEAVE_GROUP
			const void *optval, // FREEBSD8: struct ipv6_mreq
			                    // LINUX26:  struct group_req
			socklen_t optlen); // length of above struct
		*/
		/*************************************************************/

		/* option */
		if (fmode == FMODE_INCLUDE) {
#if defined FREEBSD8
			optname = IPV6_LEAVE_GROUP;
			toptname = "IPV6_LEAVE_GROUP";
#elif defined LINUX26 || defined USAGI
			optname = MCAST_LEAVE_GROUP;
			toptname = "MCAST_LEAVE_GROUP";
#endif
		}
		else { /* FMODE_EXCLUDE */
#if defined FREEBSD8
			optname = IPV6_JOIN_GROUP;
			toptname = "IPV6_JOIN_GROUP";
#elif defined LINUX26 || defined USAGI
			optname = MCAST_JOIN_GROUP;
			toptname = "MCAST_JOIN_GROUP";
#endif
		}

		/* option data */
		optval = &mcast_req;

#if defined FREEBSD8
		/* multicast address */
		mcast_req.ipv6mr_multiaddr = sa6_mcast.sin6_addr;
		/* interface index */
		mcast_req.ipv6mr_interface = if_id;
#elif defined LINUX26 || defined USAGI
		/* interface index */
		mcast_req.gr_interface = if_id;
		/* multicast address */
		memcpy(&mcast_req.gr_group, &sa_mcast, sizeof(struct sockaddr_storage));
#endif

		/* option data length */
#if defined FREEBSD8
		optlen = sizeof(struct ipv6_mreq);
#elif defined LINUX26 || defined USAGI
		optlen = sizeof(struct group_req);
#endif

		if (conf_display>0) printf("call setsockopt(%d, IPPROTO_IPV6(%d), %s(%d), optval, %d)\n",
			sock_id, IPPROTO_IPV6, toptname, optname, optlen);
		rc = setsockopt(sock_id, IPPROTO_IPV6, optname, optval, optlen);
		if (rc != 0) {
			printf("return %d setsockopt() w/ errno %d, %s\n", rc, errno, strerror(errno));
			if ((errno != EADDRINUSE) && (errno != EADDRNOTAVAIL)) {
				return (-1);
			}
		}

		/* current number in Socket_ST */
		if (fmode == FMODE_INCLUDE) {
			Socket_ST.entry[Socket_NO].mld_exist = 0;
		}
		else { /* FMODE_EXCLUDE */
			Socket_ST.entry[Socket_NO].mld_exist = 1;
		}
	break;

	case SI_SETSOCKOPT_SOURCE:
		/*************************************************************/
		/*
		int setsockopt(
			int s, // socket id
			int level, // IPPROTO_IPV6
			int optname, // MCAST_JOIN_SOURCE_GROUP/MCAST_LEAVE_SOURCE_GROUP
			const void *optval, // struct group_source_req
			socklen_t optlen); // length of above struct
		*/
		/*************************************************************/

		/* option */
		if (fmode == FMODE_INCLUDE) {
			optname = MCAST_JOIN_SOURCE_GROUP;
			toptname = "MCAST_JOIN_SOURCE_GROUP";
		}
		else { /* FMODE_EXCLUDE */
			/* This is not fit. */
			optname = MCAST_LEAVE_SOURCE_GROUP;
			toptname = "MCAST_LEAVE_SOURCE_GROUP";
		}

		/* option data */
		optval = &mcast_src1_req;
		/* interface index */
		mcast_src1_req.gsr_interface = if_id;
		/* group address */
		memcpy(&mcast_src1_req.gsr_group, &sa_mcast, sizeof(struct sockaddr_storage));
		/* source address */
		memcpy(&mcast_src1_req.gsr_source, &sa_msrc_list[0], sizeof(struct sockaddr_storage));

		/* option data length */
		optlen = sizeof(struct group_source_req);

		if (conf_display>0) printf("call setsockopt(%d, IPPROTO_IPV6(%d), %s(%d), optval, %d)\n",
			sock_id, IPPROTO_IPV6, toptname, optname, optlen);
		rc = setsockopt(sock_id, IPPROTO_IPV6, optname, optval, optlen);
		if (rc != 0) {
			printf("return %d setsockopt() w/ errno %d, %s\n", rc, errno, strerror(errno));
			if ((errno != EADDRINUSE) && (errno != EADDRNOTAVAIL)) {
				return (-1);
			}
		}

		/* current number in Socket_ST */
		Socket_ST.entry[Socket_NO].mld_exist = 1;
		break;

	case SI_SETSOCKOPT_MSFILTER:
		/*************************************************************/
		/*
		int setsockopt(
			int s, // socket id
			int level, // IPPROTO_IPV6
			int optname, // IPV6_MSFILTER
			const void *optval, // struct __msfilterreq
			socklen_t optlen); // length of above struct
		*/
		/*************************************************************/

		/* option */
#if defined FREEBSD8
		optname = IPV6_MSFILTER;
		toptname = "IPV6_MSFILTER";
#elif defined LINUX26 || defined USAGI
		optname = MCAST_MSFILTER;
		toptname = "MCAST_MSFILTER";
#endif

		/* option data */
		optval = &mcast_srcs_req;

#if defined FREEBSD8
		/* interface index */
		mcast_srcs_req.msfr_ifindex = if_id;
		/* filter mode for group */
		if (fmode == FMODE_INCLUDE) {
			mcast_srcs_req.msfr_fmode = MCAST_INCLUDE;
		}
		else { /* FMODE_EXCLUDE */
			mcast_srcs_req.msfr_fmode = MCAST_EXCLUDE;
		}
		/* # of sources in msfr_srcs */
		mcast_srcs_req.msfr_nsrcs = src_num;
		/* group address */
		memcpy(&mcast_srcs_req.msfr_group, &sa_mcast, sizeof(struct sockaddr_storage));
		/* pointer to the first member of a contiguous array of sources to filter in full */
		mcast_srcs_req.msfr_srcs = sa_msrc_list;
#elif defined LINUX26 || defined USAGI
		/* interface index */
		mcast_srcs_req.gf_interface = if_id;
		/* multicast address */
		memcpy(&mcast_srcs_req.gf_group, &sa_mcast, sizeof(struct sockaddr_storage));
		/* filter mode */
		if (fmode == FMODE_INCLUDE) {
			mcast_srcs_req.gf_fmode = MCAST_INCLUDE;
		}
		else { /* FMODE_EXCLUDE */
			mcast_srcs_req.gf_fmode = MCAST_EXCLUDE;
		}
		/* number of sources */
		mcast_srcs_req.gf_numsrc = src_num;
		/* source addresses */
		memcpy(mcast_srcs_req.gf_slist, sa_msrc_list, GROUP_FILTER_SIZE(src_num));
#endif

		/* option data length */
#if defined FREEBSD8
		optlen = sizeof(struct __msfilterreq);
#elif defined LINUX26 || defined USAGI
		optlen = GROUP_FILTER_SIZE(src_num);
#endif

		if (conf_display>0) printf("call setsockopt(%d, IPPROTO_IPV6(%d), %s(%d), optval, %d)\n",
			sock_id, IPPROTO_IPV6, toptname, optname, optlen);
		rc = setsockopt(sock_id, IPPROTO_IPV6, optname, optval, optlen);
		if (rc != 0) {
			printf("return %d setsockopt() w/ errno %d, %s\n", rc, errno, strerror(errno));
			if ((errno != EADDRINUSE) && (errno != EADDRNOTAVAIL)) {
				return (-1);
			}
		}
		break;

#if defined FREEBSD8 || defined USAGI
	case SI_SETSOURCEFILTER:
		/*************************************************************/
		/*
		int setsourcefilter(
			int s, // socket id
			uint32_t interface, // interface id
			struct sockaddr *group, // (struct sockaddr_in6) multicast
			socklen_t grouplen, // length of above struct
			uint32_t fmode, // MCAST_INCLUDE/MCAST_EXCLUDE
			uint32_t numsrc, // number of multicast source
			struct sockaddr_storage *slist); // multicast source list
		*/
		/*************************************************************/

		/* grouplen */
		sa_len = sizeof(struct sockaddr_in6);

		/* filter mode */
		if (fmode == FMODE_INCLUDE) {
			fm = MCAST_INCLUDE;
		}
		else { /* FMODE_EXCLUDE */
			fm = MCAST_EXCLUDE;
		}

		if (conf_display>0) printf("call setsourcefilter(%d, %d, sa6_mcast, %d, %d, %d, sa_msrc_list)\n",
			sock_id, if_id, sa_len, fm, src_num);
		rc = setsourcefilter(sock_id, if_id, (struct sockaddr *)&sa6_mcast, sa_len, fm, src_num, &sa_msrc_list[0]);
		if (rc != 0) {
			printf("return %d setsourcefilter() w/ errno %d, %s\n", rc, errno, strerror(errno));
			if ((errno != EADDRINUSE) && (errno != EADDRNOTAVAIL)) {
				return (-1);
			}
		}

		/* current number in Socket_ST */
		Socket_ST.entry[Socket_NO].mld_exist = 1;
		break;
#endif

	default:
		printf("INFO: NO SUPPORT.\n");
		break;
	}

	return (0);
}

/*****************************************************************************/
/* Select Function */
/*
 OS       filter   num of current
          mode     source exist   function              memo
 -------- -------- ------ ------- --------              ----
 FreeBSD8 INCLUDE       0 nothing -                     setsockopt() return errno 49
          INCLUDE       0 exist   setsockopt() with IPV6_LEAVE_GROUP and ipv6_mreq
          INCLUDE       1 nothing setsockopt() with MCAST_JOIN_SOURCE_GROUP and group_source_req
          INCLUDE       1 exist   setsourcefilter()
          INCLUDE      >1 nothing (NO SUPPORT?)         setsourcefilter() return errno 49
          INCLUDE      >1 exist   setsourcefilter()
          EXCLUDE       0 nothing setsockopt() with IPV6_JOIN_GROUP and ipv6_mreq
          EXCLUDE       0 exist   setsourcefilter()
          EXCLUDE      >0 nothing (NO SUPPORT?)         setsourcefilter() return errno 49
          EXCLUDE      >0 exist   setsourcefilter()
 
*/
/*****************************************************************************/
int SelectSI(int fmode, int srcnum, int exist) {
int si_id = SI_NOSUPPORT;

#if defined FREEBSD8
	if (fmode == FMODE_INCLUDE) {
		if (srcnum == 0) {
			if (exist == 0) {
				si_id = SI_NEEDLESS;            // needless
			}
			else {
				si_id = SI_SETSOCKOPT_GROUP;
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
//				si_id = SI_SETSOURCEFILTER;     // fail
			}
		}
		else if (srcnum == 1) {
			if (exist == 0) {
				si_id = SI_SETSOCKOPT_SOURCE;
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
//				si_id = SI_SETSOURCEFILTER;     // fail
			}
			else {
//				si_id = SI_SETSOCKOPT_MSFILTER; // good
				si_id = SI_SETSOURCEFILTER;     // good
			}
		}
		else {
			if (exist == 0) {
				si_id = SI_NOSUPPORT;           // NO SUPPORT?
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
//				si_id = SI_SETSOURCEFILTER;     // fail
			}
			else {
//				si_id = SI_SETSOCKOPT_MSFILTER; // good
				si_id = SI_SETSOURCEFILTER;     // good
			}
		}
	}
	else { /* (fmode == FMODE_EXCLUDE) */
		if (srcnum == 0) {
			if (exist == 0) {
				si_id = SI_SETSOCKOPT_GROUP;
			}
			else {
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
				si_id = SI_SETSOURCEFILTER;     // good
			}
		}
		else {
			if (exist == 0) {
				si_id = SI_NOSUPPORT;           // NO SUPPORT?
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
//				si_id = SI_SETSOURCEFILTER;     // fail
			}
			else {
//				si_id = SI_SETSOCKOPT_MSFILTER; // good
				si_id = SI_SETSOURCEFILTER;     // good
			}
		}
	}
#elif defined LINUX26
	if (fmode == FMODE_INCLUDE) {
		if (srcnum == 0) {
			if (exist == 0) {
				si_id = SI_NEEDLESS;            // needless
			}
			else {
				si_id = SI_SETSOCKOPT_GROUP;
			}
		}
		else if (srcnum == 1) {
			if (exist == 0) {
				si_id = SI_SETSOCKOPT_SOURCE;
			}
			else {
				si_id = SI_SETSOCKOPT_MSFILTER; // good
			}
		}
		else {
			if (exist == 0) {
				si_id = SI_NOSUPPORT;           // NO SUPPORT?
			}
			else {
				si_id = SI_SETSOCKOPT_MSFILTER; // good
			}
		}
	}
	else { /* (fmode == FMODE_EXCLUDE) */
		if (srcnum == 0) {
			if (exist == 0) {
				si_id = SI_SETSOCKOPT_GROUP;
			}
			else {
				si_id = SI_SETSOCKOPT_GROUP;
			}
		}
		else {
			if (exist == 0) {
				si_id = SI_NOSUPPORT;           // NO SUPPORT?
			}
			else {
				si_id = SI_SETSOCKOPT_MSFILTER; // good
			}
		}
	}
#elif defined USAGI
	if (fmode == FMODE_INCLUDE) {
		if (srcnum == 0) {
			if (exist == 0) {
				si_id = SI_NEEDLESS;            // needless
			}
			else {
				si_id = SI_SETSOCKOPT_GROUP;
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
//				si_id = SI_SETSOURCEFILTER;     // fail
			}
		}
		else if (srcnum == 1) {
			if (exist == 0) {
				si_id = SI_SETSOCKOPT_SOURCE;
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
//				si_id = SI_SETSOURCEFILTER;     // fail
			}
			else {
//				si_id = SI_SETSOCKOPT_MSFILTER; // good
				si_id = SI_SETSOURCEFILTER;     // good
			}
		}
		else {
			if (exist == 0) {
				si_id = SI_NOSUPPORT;           // NO SUPPORT?
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
//				si_id = SI_SETSOURCEFILTER;     // fail
			}
			else {
//				si_id = SI_SETSOCKOPT_MSFILTER; // good
				si_id = SI_SETSOURCEFILTER;     // good
			}
		}
	}
	else { /* (fmode == FMODE_EXCLUDE) */
		if (srcnum == 0) {
			if (exist == 0) {
				si_id = SI_SETSOCKOPT_GROUP;
			}
			else {
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
				si_id = SI_SETSOURCEFILTER;     // good
			}
		}
		else {
			if (exist == 0) {
				si_id = SI_NOSUPPORT;           // NO SUPPORT?
//				si_id = SI_SETSOCKOPT_MSFILTER; // fail
//				si_id = SI_SETSOURCEFILTER;     // fail
			}
			else {
//				si_id = SI_SETSOCKOPT_MSFILTER; // good
				si_id = SI_SETSOURCEFILTER;     // good
			}
		}
	}
#endif
	return (si_id);
}

/*****************************************************************************/
/* term func */
/*****************************************************************************/
void TermFunc (void) {
int i;

	/* close socket */
	for (i=0; i<SOCKET_NUM; i++) {
		if (Socket_ST.entry[i].sock_id != 0) {
			if (conf_display>1) printf("call close(%d)\n", Socket_ST.entry[i].sock_id);
			close(Socket_ST.entry[i].sock_id);
			memset(&Socket_ST.entry[i], 0x00, sizeof(socket_entry_t));
		}
	}
}
