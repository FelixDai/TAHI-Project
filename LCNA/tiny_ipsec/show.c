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
#include "show.h"

char		*av0;
u_int8_t	*db;

main(int argc, char **argv)
{
	extern char *optarg;
	extern int optind;
	int c;
	int dev_fd = -1;

	av0 = argv[0];

	while ((c = getopt(argc, argv, "d:")) != -1)
		switch (c) {
		case 'd':
			if (dev_fd >= 0) {
				close(dev_fd);
			}
			if ((dev_fd = open(optarg, O_RDONLY, 0)) < 0) {
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

	if (dev_fd < 0) {
		if ((dev_fd = open(TINY_IPSEC_DEVICE, O_RDONLY, 0)) < 0) {
			perror(TINY_IPSEC_DEVICE);
			exit(1);
		}
	}

	if ((db = (u_int8_t *)malloc(TINY_IPSEC_DBSIZE)) == NULL) {
		fprintf(stderr, "malloc failed.\n");
		exit(1);
	}
	if (read(dev_fd, db, TINY_IPSEC_DBSIZE) != TINY_IPSEC_DBSIZE) {
		fprintf(stderr, "read failed.\n");
		exit(1);
	}

	if (show_config() < 0) {
		fprintf(stderr, "show_config failed.\n");
		exit(1);
	}

	exit(0);
}

int
show_config(void)
{
	u_int32_t nentry;
	struct tiny_ipsec_db *ep;
	int i, start = 1;

	bcopy(db, &nentry, sizeof(nentry));

	if ((ep = (struct tiny_ipsec_db *)
		malloc(sizeof(struct tiny_ipsec_db) * nentry)) == NULL) {
		fprintf(stderr, "malloc failed.\n");
		return -1;
	}
	bzero((void *)ep, sizeof(struct tiny_ipsec_db) * nentry);

	for (i = 0; i < nentry; i++) {
		if (!start)
			printf("\n");
		else
			start = 0;

		bcopy(&((struct tiny_ipsec_db *)(db + sizeof(nentry)))[i], &ep[i],
			sizeof(struct tiny_ipsec_db));

		show_entry(&ep[i]);
	}
}

void
show_entry(struct tiny_ipsec_db *ep)
{
	struct tiny_ipsec_key *key;
	int keysize;
	char *p, *q, dummy[100];
	u_int32_t now = (u_int32_t)time(NULL);

	switch (ep->sa_lt) {
	case TINY_IPSEC_PARAM_LT_INVALID:
	expired:
		printf("#[lifetime] EXPIRED\n");
		break;

	case TINY_IPSEC_PARAM_LT_INFINITE:
		printf("[lifetime] INFINITE\n");
		break;

	default:
		if (ep->sa_lt <= now)
			goto expired;
		printf("[lifetime] %d\n", ep->sa_lt - now);
		break;
	}

	if (ep->spi_valid == TINY_IPSEC_PARAM_SPI_VALID) {
		printf("[spi] 0x%x\n", ep->spi);
	}

	switch (ep->proto) {
	case TINY_IPSEC_PARAM_PROTO_TCP:
		printf("[proto] TCP\n");
		break;

	case TINY_IPSEC_PARAM_PROTO_UDP:
		printf("[proto] UDP\n");
		break;

	case TINY_IPSEC_PARAM_PROTO_ANY:
		printf("[proto] ANY\n");
		break;
	}

	printf("[send_peer] [%s]", inet_ntop(AF_INET6, (void *)&ep->s_peeraddr,
		dummy, 100));
	if (ep->s_peeraddr_len < 128)
		printf("/%d", ep->s_peeraddr_len);
	show_portspec(ep->s_dport_l, ep->s_dport_u);

	printf("[recv_peer] [%s]", inet_ntop(AF_INET6, (void *)&ep->r_peeraddr,
		dummy, 100));
	if (ep->r_peeraddr_len < 128)
		printf("/%d", ep->r_peeraddr_len);
	show_portspec(ep->r_sport_l, ep->r_sport_u);

	switch (ep->s_myself) {
	case TINY_IPSEC_PARAM_MYSELF_LINKLOCAL:
		printf("[send_myself] LINKLOCAL");
		show_portspec(ep->s_sport_l, ep->s_sport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_SITELOCAL:
		printf("[send_myself] SITELOCAL");
		show_portspec(ep->s_sport_l, ep->s_sport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_GLOBAL:
		printf("[send_myself] GLOBAL");
		show_portspec(ep->s_sport_l, ep->s_sport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_ALL:
		printf("[send_myself] ALL");
		show_portspec(ep->s_sport_l, ep->s_sport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_SITELOCAL |
	     TINY_IPSEC_PARAM_MYSELF_GLOBAL:
		printf("[send_myself] !LINKLOCAL");
		show_portspec(ep->s_sport_l, ep->s_sport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_LINKLOCAL |
	     TINY_IPSEC_PARAM_MYSELF_GLOBAL:
		printf("[send_myself] !SITELOCAL");
		show_portspec(ep->s_sport_l, ep->s_sport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_LINKLOCAL |
	     TINY_IPSEC_PARAM_MYSELF_SITELOCAL:
		printf("[send_myself] !GLOBAL");
		show_portspec(ep->s_sport_l, ep->s_sport_u);
		break;

	case 0:
		printf("[send_myself] !ALL");
		show_portspec(ep->s_sport_l, ep->s_sport_u);
		break;
	}

	switch (ep->r_myself) {
	case TINY_IPSEC_PARAM_MYSELF_LINKLOCAL:
		printf("[recv_myself] LINKLOCAL");
		show_portspec(ep->r_dport_l, ep->r_dport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_SITELOCAL:
		printf("[recv_myself] SITELOCAL");
		show_portspec(ep->r_dport_l, ep->r_dport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_GLOBAL:
		printf("[recv_myself] GLOBAL");
		show_portspec(ep->r_dport_l, ep->r_dport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_ALL:
		printf("[recv_myself] ALL");
		show_portspec(ep->r_dport_l, ep->r_dport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_SITELOCAL |
	     TINY_IPSEC_PARAM_MYSELF_GLOBAL:
		printf("[recv_myself] !LINKLOCAL");
		show_portspec(ep->r_dport_l, ep->r_dport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_LINKLOCAL |
	     TINY_IPSEC_PARAM_MYSELF_GLOBAL:
		printf("[recv_myself] !SITELOCAL");
		show_portspec(ep->r_dport_l, ep->r_dport_u);
		break;

	case TINY_IPSEC_PARAM_MYSELF_LINKLOCAL |
	     TINY_IPSEC_PARAM_MYSELF_SITELOCAL:
		printf("[recv_myself] !GLOBAL");
		show_portspec(ep->r_dport_l, ep->r_dport_u);
		break;

	case 0:
		printf("[recv_myself] !ALL");
		show_portspec(ep->r_dport_l, ep->r_dport_u);
		break;
	}

	switch (ep->outpolicy) {
	case TINY_IPSEC_PARAM_POLICY_PASS:
		printf("[outpolicy] PASS\n");
		break;

	case TINY_IPSEC_PARAM_POLICY_DISCARD:
		printf("[outpolicy] DISCARD\n");
		break;

	case TINY_IPSEC_PARAM_POLICY_ESP:
		printf("[outpolicy] ESP\n");
		break;

	case TINY_IPSEC_PARAM_POLICY_ESP_AUTH:
		printf("[outpolicy] ESP_AUTH\n");
		break;
	}

	switch (ep->inpolicy) {
	case TINY_IPSEC_PARAM_POLICY_PASS:
		printf("[inpolicy] PASS\n");
		break;

	case TINY_IPSEC_PARAM_POLICY_DISCARD:
		printf("[inpolicy] DISCARD\n");
		break;

	case TINY_IPSEC_PARAM_POLICY_ESP:
		printf("[inpolicy] ESP\n");
		break;

	case TINY_IPSEC_PARAM_POLICY_ESP_AUTH:
		printf("[inpolicy] ESP_AUTH\n");
		break;
	}

	switch (ep->esp_alg) {
	case TINY_IPSEC_PARAM_ESP_ALG_NULL:
		printf("[esp_alg] NULL\n");
		break;

	case TINY_IPSEC_PARAM_ESP_ALG_DES:
		printf("[esp_alg] DES\n");
		break;

	case TINY_IPSEC_PARAM_ESP_ALG_3DES:
		printf("[esp_alg] 3DES\n");
		break;

	case TINY_IPSEC_PARAM_ESP_ALG_RIJNDEAL:
		printf("[esp_alg] RIJNDEAL\n");
        break;
	}

	if (ep->esp_key) {
		key = (struct tiny_ipsec_key *)(db + ep->esp_key);
		keysize = (key->len + 7) >> 3;
		printf("[esp_key] 0x");
		for (p = key->key, q = p + keysize; p < q; p++) {
			u_int8_t u = (*p >> 4) & 0xf, l = *p & 0xf;
			putchar(u < 10 ? '0' + u : 'a' + u - 10);
			putchar(l < 10 ? '0' + l : 'a' + l - 10);
		}
		if (keysize != key->len >> 3)
			printf("/%d", key->len);
		putchar('\n');
		printf("#[esp_key] \"");
		for (p = key->key, q = p + keysize; p < q; p++) {
			putchar(*p);
		}
		printf("\"/%d\n", key->len);
	}

	switch (ep->esp_auth_alg) {
	case TINY_IPSEC_PARAM_ESP_AUTH_ALG_HMAC_MD5:
		printf("[esp_auth_alg] HMAC_MD5\n");
		break;

	case TINY_IPSEC_PARAM_ESP_AUTH_ALG_HMAC_SHA:
		printf("[esp_auth_alg] HMAC_SHA\n");
		break;
	}

	if (ep->esp_auth_key) {
		key = (struct tiny_ipsec_key *)(db + ep->esp_auth_key);
		keysize = (key->len + 7) >> 3;
		printf("[esp_auth_key] 0x");
		for (p = key->key, q = p + keysize; p < q; p++) {
			u_int8_t u = (*p >> 4) & 0xf, l = *p & 0xf;
			putchar(u < 10 ? '0' + u : 'a' + u - 10);
			putchar(l < 10 ? '0' + l : 'a' + l - 10);
		}
		if (keysize != key->len >> 3)
			printf("/%d", key->len);
		putchar('\n');
		printf("#[esp_auth_key] \"");
		for (p = key->key, q = p + keysize; p < q; p++) {
			putchar(*p);
		}
		printf("\"/%d\n", key->len);
	}
}

void
show_portspec(u_int16_t lower, u_int16_t upper)
{
	if (lower > upper) {
		u_int16_t tmp = lower;
		lower = upper;
		upper = tmp;
	}

	if (lower == 0 && upper == 0xffff) {
		printf("\n");
		return;
	}

	if (lower == upper) {
		printf(":%d\n", lower);
		return;
	}

	if (lower == 0) {
		printf(":-%d\n", upper);
		return;
	}

	if (upper == 0xffff) {
		printf(":%d-\n", lower);
		return;
	}

	printf(":%d-%d\n", lower, upper);
	return;
}

void
usage(void)
{
	fprintf(stderr, "Usage: %s [-d config-device]\n", av0);
	exit(1);
}
