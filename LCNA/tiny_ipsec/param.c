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
#include <netinet/in.h>
#include "tiny_ipsec.h"

struct tiny_ipsec_paramname tiny_ipsec_paramname[] = {
	{TINY_IPSEC_PTYPE_LIFETIME,	"[lifetime]"},
	{TINY_IPSEC_PTYPE_LIFETIME,	"[lt]"},
	{TINY_IPSEC_PTYPE_SPI,		"[spi]"},
	{TINY_IPSEC_PTYPE_PROTO,	"[proto]"},
	{TINY_IPSEC_PTYPE_PROTO,	"[prt]"},
	{TINY_IPSEC_PTYPE_SEND_PEER,	"[send_peer]"},
	{TINY_IPSEC_PTYPE_SEND_PEER,	"[s_peer]"},
	{TINY_IPSEC_PTYPE_RECV_PEER,	"[recv_peer]"},
	{TINY_IPSEC_PTYPE_RECV_PEER,	"[r_peer]"},
	{TINY_IPSEC_PTYPE_SEND_MYSELF,	"[send_myself]"},
	{TINY_IPSEC_PTYPE_SEND_MYSELF,	"[s_my]"},
	{TINY_IPSEC_PTYPE_RECV_MYSELF,	"[recv_myself]"},
	{TINY_IPSEC_PTYPE_RECV_MYSELF,	"[r_my]"},
	{TINY_IPSEC_PTYPE_OUTPOLICY,	"[outpolicy]"},
	{TINY_IPSEC_PTYPE_OUTPOLICY,	"[opol]"},
	{TINY_IPSEC_PTYPE_INPOLICY,	"[inpolicy]"},
	{TINY_IPSEC_PTYPE_INPOLICY,	"[ipol]"},
	{TINY_IPSEC_PTYPE_ESP_ALG,	"[esp_alg]"},
	{TINY_IPSEC_PTYPE_ESP_ALG,	"[esp_a]"},
	{TINY_IPSEC_PTYPE_ESP_KEY,	"[esp_key]"},
	{TINY_IPSEC_PTYPE_ESP_AUTH_ALG,	"[esp_auth_alg]"},
	{TINY_IPSEC_PTYPE_ESP_AUTH_KEY,	"[esp_auth_key]"},
	{TINY_IPSEC_PTYPE_NONE,		NULL}
};

struct tiny_ipsec_db default_entry = {
	TINY_IPSEC_PARAM_LT_INFINITE,		/* sa_lt */
	0,					/* seq */
	0,					/* spi */
	TINY_IPSEC_PARAM_SPI_NONE,		/* spi_valid */
	TINY_IPSEC_PARAM_POLICY_PASS,		/* outpolicy */
	TINY_IPSEC_PARAM_POLICY_PASS,		/* inpolicy */
	TINY_IPSEC_PARAM_PROTO_ANY,		/* proto */
	{0},					/* s_peeraddr */
	{0},					/* r_peeraddr */
	0,					/* s_peeraddr_len */
	0,					/* r_peeraddr_len */
	TINY_IPSEC_PARAM_MYSELF_ALL,		/* s_myself */
	TINY_IPSEC_PARAM_MYSELF_ALL,		/* r_myself */
	0,					/* s_sport_l */
	0xffff,					/* s_sport_u */
	0,					/* r_sport_l */
	0xffff,					/* r_sport_u */
	0,					/* s_dport_l */
	0xffff,					/* s_dport_u */
	0,					/* r_dport_l */
	0xffff,					/* r_dport_u */
	TINY_IPSEC_PARAM_ESP_ALG_NULL,		/* esp_alg */
	TINY_IPSEC_PARAM_ESP_AUTH_ALG_NONE,	/* esp_auth_lag */
	0,					/* esp_key */
	0					/* esp_auth_key */
};
