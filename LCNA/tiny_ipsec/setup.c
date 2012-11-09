/*
 * Copyright (C) 2002 Yokogawa Electric Corporation , 
 * INTAP(Interoperability Technology Association for Information 
 * Processing, Japan) , IPA (Information-technology Promotion Agency,Japan)
 * All rights reserved.
 * 
 * 
 * 
 * Redistribution and use of this software in source and binary forms, with 
 * or without modification, are permitted provided that the following 
 * conditions and disclaimer are agreed and accepted by the user:
 * 
 * 1. Redistributions of source code must retain the above copyright 
 * notice, this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright 
 * notice, this list of conditions and the following disclaimer in the 
 * documentation and/or other materials provided with the distribution.
 * 
 * 3. Neither the names of the copyrighters, the name of the project which 
 * is related to this software (hereinafter referred to as "project") nor 
 * the names of the contributors may be used to endorse or promote products 
 * derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND 
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING 
 * BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 * FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE 
 * COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT,STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include "tiny_ipsec.h"
#include "setup.h"

char		*av0;
u_int8_t	*db;
int		vflag = 0, nflag = 0;

main(int argc, char **argv)
{
	extern char *optarg;
	extern int optind;
	int c;
	FILE *conf_fp = NULL;
	int dev_fd = -1;

	av0 = argv[0];

	while ((c = getopt(argc, argv, "vnc:d:")) != -1)
		switch (c) {
		case 'v':
			vflag++;
			break;
		case 'n':
			nflag++;
			break;
		case 'c':
			if (conf_fp) {
				fclose(conf_fp);
			}
			if ((conf_fp = fopen(optarg, "r")) == NULL) {
				perror(optarg);
				exit(1);
			}
			break;
		case 'd':
			if (dev_fd >= 0) {
				close(dev_fd);
			}
			if ((dev_fd = open(optarg, O_RDWR, 0)) < 0) {
				perror(optarg);
				exit(1);
			}
			break;
		case '?':
		default:
			usage();
		}
	argc -= optind;
	argv += optind;

	if (conf_fp == NULL) {
		conf_fp = fdopen(0, "r");
	}
	if (dev_fd < 0) {
		if ((dev_fd = open(TINY_IPSEC_DEVICE, O_RDWR, 0)) < 0) {
			perror(TINY_IPSEC_DEVICE);
			exit(1);
		}
	}

	if ((db = (u_int8_t *)malloc(TINY_IPSEC_DBSIZE)) == NULL) {
		fprintf(stderr, "malloc failed.\n");
		exit(1);
	}
	bzero((void *)db, TINY_IPSEC_DBSIZE);

	if (read_config(conf_fp) < 0) {
		fprintf(stderr, "read_config failed.\n");
		exit(1);
	}

	if (nflag == 0) {
		if (write(dev_fd, db, TINY_IPSEC_DBSIZE) != TINY_IPSEC_DBSIZE) {
			fprintf(stderr, "write failed.\n");
			exit(1);
		}
		if (vflag)
			fprintf(stderr, "Writing to device has been succeeded\n");
	}

	exit(0);
}

int
read_config(FILE *fp)
{
	char buf[BUFSIZ], *p, *q;
	int lineno;
	u_int8_t *dbp1 = db + sizeof(u_int32_t), *dbp2 = &db[TINY_IPSEC_DBSIZE];
	u_int32_t nentry = 0;
	struct tiny_ipsec_db entry;
	struct tiny_ipsec_key *key_esp, *key_esp_auth;
	struct tiny_ipsec_paramname *pname;
	int in_entry;
	int keysize0, keysize;
	char *error;

	entry = default_entry;
	in_entry = 0;

	for (lineno = 1; fgets(buf, BUFSIZ, fp); lineno++) {
		if (*(p = buf) == '#')
			continue;
		for (q = p; *q && *q != '\n' && *q != '#'; q++)
			;
		for (; (q > p) && (*(q - 1) == ' ' || *(q - 1) == '\t'); q--)
			;
		*q = '\0';
		while (*p == ' ' || *p == '\t')
			p++;
		for (q = p; *q && *q != ' ' && *q != '\t'; q++)
			;
		if (q == p) {
			if (in_entry == 0)
				continue;
			if (dbp1 + sizeof(entry) > dbp2) {
				fprintf(stderr, "line %d: db size over.\n", lineno);
				return -1;
			}
			make_entry(nentry, &entry);
			dbp1 += sizeof(entry);
			entry = default_entry;
			in_entry = 0;
			if (vflag)
				fprintf(stderr, "line %d: Entry #%d end. Rest of DB size = %dbytes.\n",
					lineno - 1, nentry, dbp2 - dbp1);
			continue;
		}
		if (in_entry == 0) {
			nentry++;
			in_entry++;
			if (vflag)
				fprintf(stderr, "line %d: Entry #%d begin.\n", lineno, nentry);
		}
		for (pname = &tiny_ipsec_paramname[0];
			pname->type != TINY_IPSEC_PTYPE_NONE; pname++)
			if (match(pname->name, p, q - p)) {
				goto found;
			}
		*q = '\0';
		fprintf(stderr, "line %d: invalid parameter name \"%s\".\n",
			lineno, p);
		return -1;
	found:
		key_esp = NULL;
		key_esp_auth = NULL;
		if (parse_param(pname, q, &entry, &key_esp, &key_esp_auth,
			&error) < 0) {
			fprintf(stderr, "line %d: %s\n", lineno, error);
			return -1;
		}
		if (vflag)
			fprintf(stderr, "line %d: %s\n", lineno, pname->name);
		if (key_esp) {
			keysize = sizeof(struct tiny_ipsec_key)
				+ ((key_esp->len + 7) >> 3);
			keysize0 = ((keysize + 3) >> 2) << 2;
			if (dbp1 > dbp2 - keysize0 - TINY_IPSEC_ESP_SCHEDSIZ) {
				fprintf(stderr, "line %d: db size over.\n", lineno);
				return -1;
			}
			dbp2 -= TINY_IPSEC_ESP_SCHEDSIZ;
			entry.esp_sched = dbp2 - db;
			dbp2 -= keysize0;
			bcopy((void *)key_esp, dbp2, keysize);
			entry.esp_key = dbp2 - db;
			free(key_esp);
			if (vflag)
				fprintf(stderr, "line %d: ESP_KEY = %dbytes, ESP_SCHED = %dbytes, Rest of DB = %dbytes.\n",
					lineno, keysize0,
					TINY_IPSEC_ESP_SCHEDSIZ, dbp2 - dbp1);
		}
		if (key_esp_auth) {
			keysize = sizeof(struct tiny_ipsec_key)
				+ ((key_esp_auth->len + 7) >> 3);
			keysize0 = ((keysize + 3) >> 2) << 2;
			if (dbp1 > dbp2 - keysize0) {
				fprintf(stderr, "line %d: db size over.\n", lineno);
				return -1;
			}
			dbp2 -= keysize0;
			bcopy((void *)key_esp_auth, dbp2, keysize);
			entry.esp_auth_key = dbp2 - db;
			free(key_esp_auth);
			if (vflag)
				fprintf(stderr, "line %d: ESP_AUTH_KEY = %dbytes, Rest of DB = %dbytes.\n",
					lineno, keysize0, dbp2 - dbp1);
		}
	}
	if (in_entry) {
		if (dbp1 + sizeof(entry) > dbp2) {
			fprintf(stderr, "line %d: db size over.\n", lineno);
			return -1;
		}
		make_entry(nentry, &entry);
		dbp1 += sizeof(entry);
		if (vflag)
			fprintf(stderr, "line %d: Entry #%d end. Rest of DB = %dbytes.\n",
				lineno - 1, nentry, dbp2 - dbp1);
	}

	bcopy(&nentry, db, sizeof(nentry));

	return 0;
}

int
parse_param(struct tiny_ipsec_paramname *pname, char *p,
	struct tiny_ipsec_db *ep,
	struct tiny_ipsec_key **key_esp,
	struct tiny_ipsec_key **key_esp_auth,
	char **errorp)
{
	char *q;
	u_int32_t num;
	struct in6_addr peer;
	u_int8_t prefixlen;
	u_int8_t myself;
	u_int16_t port_l, port_u;
	u_int8_t policy;
	struct tiny_ipsec_key *key = NULL;

	while (*p == ' ' || *p == '\t')
		p++;
	for (q = p; *q && *q != ' ' && *q != '\t'; q++)
		;
	if (q == p) {
		*errorp = "no args found.";
		return -1;
	}

	switch (pname->type) {
	case TINY_IPSEC_PTYPE_LIFETIME:
		if (match("infinite", p, q - p) || match("inf", p, q - p)) {
			ep->sa_lt = TINY_IPSEC_PARAM_LT_INFINITE;
		} else if (argnum(p, q - p, &num) < 0) {
			*errorp = "invalid LIFETIME.";
			return -1;
		} else {
			ep->sa_lt = num + (u_int32_t)time(NULL);
		}
		break;

	case TINY_IPSEC_PTYPE_SPI:
		if (match("none", p, q - p)) {
			ep->spi_valid = TINY_IPSEC_PARAM_SPI_NONE;
		} else if (argnum(p, q - p, &num) < 0) {
			*errorp = "invalid SPI.";
			return -1;
		} else {
			ep->spi_valid = TINY_IPSEC_PARAM_SPI_VALID;
			ep->spi = num;
		}
		break;

	case TINY_IPSEC_PTYPE_PROTO:
		if (match("any", p, q - p) || match("*", p, q - p)) {
			ep->proto = TINY_IPSEC_PARAM_PROTO_ANY;
		} else if (match("tcp", p, q - p)) {
			ep->proto = TINY_IPSEC_PARAM_PROTO_TCP;
		} else if (match("udp", p, q - p)) {
			ep->proto = TINY_IPSEC_PARAM_PROTO_UDP;
		} else {
			*errorp = "invalid PROTO.";
			return -1;
		}
		break;

	case TINY_IPSEC_PTYPE_SEND_PEER:
	case TINY_IPSEC_PTYPE_RECV_PEER:
		port_l = 0;
		port_u = 0xffff;
		if (argpeer(p, q - p, &peer, &prefixlen, &port_l, &port_u) < 0) {
			*errorp = "invalid PEER.";
			return -1;
		}
		if (pname->type == TINY_IPSEC_PTYPE_SEND_PEER) {
			ep->s_peeraddr = peer;
			ep->s_peeraddr_len = prefixlen;
			ep->s_dport_l = port_l;
			ep->s_dport_u = port_u;
		} else {
			ep->r_peeraddr = peer;
			ep->r_peeraddr_len = prefixlen;
			ep->r_sport_l = port_l;
			ep->r_sport_u = port_u;
		}
		break;

	case TINY_IPSEC_PTYPE_SEND_MYSELF:
	case TINY_IPSEC_PTYPE_RECV_MYSELF:
		port_l = 0;
		port_u = 0xffff;
		if (argmyself(p, q - p, &myself, &port_l, &port_u) < 0) {
			*errorp = "invalid MYSELF.";
			return -1;
		}
		if (pname->type == TINY_IPSEC_PTYPE_SEND_MYSELF) {
			ep->s_myself = myself;
			ep->s_sport_l = port_l;
			ep->s_sport_u = port_u;
		} else {
			ep->r_myself = myself;
			ep->r_dport_l = port_l;
			ep->r_dport_u = port_u;
		}
		break;

	case TINY_IPSEC_PTYPE_OUTPOLICY:
	case TINY_IPSEC_PTYPE_INPOLICY:
		if (match("pass", p, q - p)) {
			policy = TINY_IPSEC_PARAM_POLICY_PASS;
		} else if (match("discard", p, q - p)) {
			policy = TINY_IPSEC_PARAM_POLICY_DISCARD;
		} else if (match("esp", p, q - p)) {
			policy = TINY_IPSEC_PARAM_POLICY_ESP;
		} else if (match("esp_auth", p, q - p)) {
			policy = TINY_IPSEC_PARAM_POLICY_ESP_AUTH;
		} else {
			*errorp = "invalid POLICY.";
			return -1;
		}
		if (pname->type == TINY_IPSEC_PTYPE_OUTPOLICY) {
			ep->outpolicy = policy;
		} else {
			ep->inpolicy = policy;
		}
		break;

	case TINY_IPSEC_PTYPE_ESP_ALG:
		if (match("null", p, q - p)) {
			ep->esp_alg = TINY_IPSEC_PARAM_ESP_ALG_NULL;
		} else if (match("des", p, q - p)) {
			ep->esp_alg = TINY_IPSEC_PARAM_ESP_ALG_DES;
		} else if (match("3des", p, q - p)) {
			ep->esp_alg = TINY_IPSEC_PARAM_ESP_ALG_3DES;
		} else if (match("rijndael", p, q - p)) {
			ep->esp_alg = TINY_IPSEC_PARAM_ESP_ALG_RIJNDEAL;
		} else {
			*errorp = "invalid ESP_ALG.";
			return -1;
		}
		break;

	case TINY_IPSEC_PTYPE_ESP_AUTH_ALG:
		if (match("hmac-md5", p, q - p)) {
			ep->esp_auth_alg = TINY_IPSEC_PARAM_ESP_AUTH_ALG_HMAC_MD5;
		} else if (match("hmac-sha", p, q - p)) {
			ep->esp_auth_alg = TINY_IPSEC_PARAM_ESP_AUTH_ALG_HMAC_SHA;
		} else {
			*errorp = "invalid ESP_AUTH_ALG.";
			return -1;
		}
		break;

	case TINY_IPSEC_PTYPE_ESP_KEY:
	case TINY_IPSEC_PTYPE_ESP_AUTH_KEY:
		if (argkey(p, q - p, &key) < 0) {
			*errorp = "invalid KEY.";
			return -1;
		}
		if (pname->type == TINY_IPSEC_PTYPE_ESP_KEY) {
			*key_esp = key;
		} else {
			*key_esp_auth = key;
		}
		break;

	default:
	}

	return 0;
}

void
make_entry(u_int32_t nentry, struct tiny_ipsec_db *entry)
{
	bcopy(entry,
		&((struct tiny_ipsec_db *)(db + sizeof(nentry)))[nentry - 1],
		sizeof(struct tiny_ipsec_db));
}

int
match(char *s1, char *s2, int len)
{
	if (strlen(s1) != len)
		return 0;
	while (len--)
		if (tolower(*s1++) != tolower(*s2++))
			return 0;
	return 1;
}

int
argnum(char *p, int len, u_int32_t *nump)
{
	char *end;

	*nump = strtoul(p, &end, 0);

	if (end - p == len)
		return 0;
	else
		return -1;
}

int
argpeer(char *p, int len, struct in6_addr *peerp, u_int8_t *prefixlenp,
	u_int16_t *port_lp, u_int16_t *port_up)
{
	int port = 0, range = 0;
	u_int32_t val;
	char *q, *plen = NULL;

	if (*p == '[') {
		p++;
		for (q = p; *q; q++) {
			if (*q == '/') {
				*q = '\0';
				plen = q + 1;
				break;
			}
			if (*q == ']') {
				*q = '\0';
				if (*(q + 1) == '/')
					plen = q + 2;
				break;
			}
		}
		inet_pton(AF_INET6, p, peerp);
		if (*++q == ':')
			port++;
	} else {
		for (q = p; *q; q++)
			if (*q == '/') {
				*q = '\0';
				plen = q + 1;
				break;
			}
		inet_pton(AF_INET6, p, peerp);
	}
	if ((*prefixlenp = plen ? atoi(plen) : 128) > 128)
		return -1;

	if (port) {
		p = q + 1;
		for (q = p; *q; q++) {
			if (*q == '-') {
				*q = '\0';
				range++;
				break;
			}
		}
		if (q == p)
			*port_lp = 0;
		else {
			if (argnum(p, q - p, &val) < 0)
				return -1;
			*port_lp = (u_int16_t)val;
		}
		if (range) {
			p = q + 1;
			for (q = p; *q; q++)
				;
			if (q == p)
				*port_up = 0xffff;
			else {
				if (argnum(p, q - p, &val) < 0)
					return -1;
				*port_up = (u_int16_t)val;
			}
		} else
			*port_up = *port_lp;
		if (*port_lp > *port_up) {
			u_int16_t tmp = *port_lp;
			*port_lp = *port_up;
			*port_up = tmp;
		}
	}

	return 0;
}

int
argmyself(char *p, int len, u_int8_t *myselfp,
	u_int16_t *port_lp, u_int16_t *port_up)
{
	int inv = 0, port = 0, range = 0;
	u_int32_t val;
	char *q;

	if (*p == '!') {
		inv++;
		p++;
	}
	for (q = p; *q; q++) {
		if (*q == ':') {
			*q = '\0';
			port++;
			break;
		}
	}
	if (match("linklocal", p, q - p)) {
		if (inv)
			*myselfp = TINY_IPSEC_PARAM_MYSELF_SITELOCAL | \
				   TINY_IPSEC_PARAM_MYSELF_GLOBAL;
		else
			*myselfp = TINY_IPSEC_PARAM_MYSELF_LINKLOCAL;
	} else if (match("sitelocal", p, q - p)) {
		if (inv)
			*myselfp = TINY_IPSEC_PARAM_MYSELF_LINKLOCAL | \
				   TINY_IPSEC_PARAM_MYSELF_GLOBAL;
		else
			*myselfp = TINY_IPSEC_PARAM_MYSELF_SITELOCAL;
	} else if (match("global", p, q - p)) {
		if (inv)
			*myselfp = TINY_IPSEC_PARAM_MYSELF_LINKLOCAL | \
				   TINY_IPSEC_PARAM_MYSELF_SITELOCAL;
		else
			*myselfp = TINY_IPSEC_PARAM_MYSELF_GLOBAL;
	} else if (match("all", p, q - p)) {
		if (inv)
			*myselfp = 0;
		else
			*myselfp = TINY_IPSEC_PARAM_MYSELF_ALL;
	}

	if (port) {
		p = q + 1;
		for (q = p; *q; q++) {
			if (*q == '-') {
				*q = '\0';
				range++;
				break;
			}
		}
		if (q == p)
			*port_lp = 0;
		else {
			if (argnum(p, q - p, &val) < 0)
				return -1;
			*port_lp = (u_int16_t)val;
		}
		if (range) {
			p = q + 1;
			for (q = p; *q; q++)
				;
			if (q == p)
				*port_up = 0xffff;
			else {
				if (argnum(p, q - p, &val) < 0)
					return -1;
				*port_up = (u_int16_t)val;
			}
		} else
			*port_up = *port_lp;
		if (*port_lp > *port_up) {
			u_int16_t tmp = *port_lp;
			*port_lp = *port_up;
			*port_up = tmp;
		}
	}

	return 0;
}

int
argkey(char *p, int len, struct tiny_ipsec_key **keyp)
{
	char buf[BUFSIZ], *bp = buf, *q;
	int keylen = 0;

	bzero(buf, sizeof(buf));

	if (*keyp)
		free(*keyp);

	if (*p == '"') {
		for (q = p + 1; *q; q++) {
			switch (*q) {
			case '"':
				q++;
				goto eot;

			case '\\':
				switch (*++q) {
				case 'r':
					*bp++ = '\r';
					break;

				case 'n':
					*bp++ = '\n';
					break;

				case 't':
					*bp++ = '\t';
					break;

				case 'b':
					*bp++ = '\b';
					break;

				case 'f':
					*bp++ = '\f';
					break;

				case '0':
					*bp++ = '\0';
					break;

				default:
					*bp++ = *q;
					break;
				}
				q++;
				keylen += 8;
				break;

			default:
				*bp++ = *q;
				keylen += 8;
				break;
			}
		}
	eot:
		if (*q == '/' && *++q) {
			keylen = atoi(q);
		}
	} else if (*p == '0' && *(p+1) == 'x') {
#define	tohex(c)	(((c) >= '0' && (c) <= '9') ? (c) - '0' : \
			(((c) >= 'a' && (c) <= 'f') ? (c) - 'a' + 10 : \
			(((c) >= 'A' && (c) <= 'F') ? (c) - 'A' + 10 : 0)))
		p += 2;
		for (q = p; *q; q++) {
			if (!isxdigit(*q))
				break;
		}
		keylen = (q - p) * 4;
		if (((q - p) / 2) * 2 != q - p) {
			*bp++ = tohex(*p);
			p++;
		}
		while (p < q) {
			*bp++ = tohex(*p) * 16 + tohex(*(p+1));
			p += 2;
		}
		goto eot;
	} else
		return -1;

	if ((*keyp = (struct tiny_ipsec_key *)
		malloc(sizeof(struct tiny_ipsec_key) + (keylen+7)>>3)) == NULL) {
		return -1;
	}
	(*keyp)->len = keylen;
	bcopy(buf, &((*keyp)->key[0]), (keylen+7)>>3);

	return 0;
}

void
usage(void)
{
	fprintf(stderr, "Usage: %s [-v] [-n] [-c config-file] [-d config-device]\n", av0);
	exit(1);
}
