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
 * $Id: bgp.c,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

#include "general.h"
#include "af.h"
#include "bgp.h"

/* BGP */
void
bgp(struct pktinfo *pktinfo)
{
    struct pktinfo n_hdr;
    const u_char *pkt = pktinfo->pkt;
    bpf_u_int32 len = pktinfo->len;
    struct bgp_hdr *bgp_hdr = NULL;
    struct tcphdr *tcp = (struct tcphdr *)pkt;

    len -= (tcp->th_off) * 4;
    pkt += (tcp->th_off) * 4;

    n_hdr.len = len;
    n_hdr.pkt = pkt;

    bgp_hdr = (struct bgp_hdr *)pkt;

    if (len >= BGP_HDR_SIZE) {
        if (!kflag) {
            (void)printf("%s", t_stamp);
            (void)printf("%s\n", addr);
            bgp_msg(&n_hdr);
            (void)printf("\n");
	    BGP_counter ++;
        }
        else {
            if (bgp_hdr->type != BGP_KEEPALIVE) {
                (void)printf("%s", t_stamp);
                (void)printf("%s\n", addr);
                bgp_msg(&n_hdr);
                (void)printf("\n");
	        BGP_counter ++;
            }
        }
    }
    else if (vflag) {
        (void)printf("%s", t_stamp);
        (void)printf("%s\n", addr);
        (void)printf("TCP (bgp):\n");
        (void)printf("\n");
	BGP_counter ++;
    }
} /* end of bgp */


/* BGP massage header */
void
bgp_msg(struct pktinfo *pktinfo)
{
    int x;
    struct pktinfo n_hdr;
    const u_char *pkt = pktinfo->pkt;
    bpf_u_int32 len = pktinfo->len;
    struct bgp_hdr *bgp_hdr = (struct bgp_hdr *)pkt;
    u_int16_t bgp_len = htons(bgp_hdr->length);

    n_hdr.len = len;
    n_hdr.pkt = pkt;


    if (vflag) {
        (void)printf("BGP message marker  ");
        for (x = 0;x < 16; x++)
            (void)printf("%x",bgp_hdr->marker[x]);
        (void)printf("\n");
        (void)printf("            length %d bytes\n", bgp_len);
        if (bgp_hdr->type > 0 && bgp_hdr->type < 5)
            (void)printf("            type   %d \"%s\"\n", 
		bgp_hdr->type, bgp_types[bgp_hdr->type]);
        else
            (void)printf("            type   %d \"Invalid type\"\n", bgp_hdr->type);
    }

    switch(bgp_hdr->type) {
        case BGP_OPEN:
            bgp_open(&n_hdr, bgp_len);
            break;
        case BGP_UPDATE:
            bgp_update(&n_hdr, bgp_len);
            break;
        case BGP_NOTIFICATION:
            bgp_notify(&n_hdr, bgp_len);
            break;
        case BGP_KEEPALIVE:
            bgp_keepalive(&n_hdr, bgp_len);
            break;
        default:
            (void)printf("\"ERROR BGP Invalid Type: %d\"\n",bgp_hdr->type);
            (void)printf("\n");
            break;
    }
} /* end of bgp_msg */


/* BGP OPEN message */
void
bgp_open(struct pktinfo *pktinfo, u_int16_t bgp_len)
{
    struct pktinfo n_hdr;
    struct bgp_open *bgp_open = NULL;
    struct bgp_open_opt *open_opt = NULL;
    const u_char *pkt = pktinfo->pkt;
    bpf_u_int32 len = pktinfo->len;

    bgp_open = (struct bgp_open *)pkt;

    (void)printf("BGP OPEN:");
    (void)printf(" version %d\n", bgp_open->version);
    (void)printf("AS# %d, BGP ID %s, holdtime %d\n",
        htons(bgp_open->as), addr4_string(ntohl(bgp_open->bgpid)),
	htons(bgp_open->holdtime));
    if(vflag)
         (void)printf("option paremeter length %d bytes\n", bgp_open->optlen);

    pkt += BGP_OPEN_SIZE;

    if(bgp_open->optlen != 0) {
        open_opt = (struct bgp_open_opt *)pkt;
        (void)printf("option:\n");
        pkt += bgp_open->optlen;
    }

    len -= bgp_len;
    (void)printf("\n");
    if (len > 1) {
        n_hdr.pkt = pkt;
        n_hdr.len = len;
        bgp_msg(&n_hdr);
    }
} /* end of bgp_open */


/* BGP NOTIFICATION message */
void
bgp_notify(struct pktinfo *pktinfo, u_int16_t bgp_len)
{
    struct bgp_notification *bgp_notify = NULL;
    const u_char *pkt = pktinfo->pkt;
    bpf_u_int32 len = pktinfo->len;

    bgp_notify = (struct bgp_notification *)pkt;

    (void)printf("BGP NOTIFICATION: ");

    if (bgp_notify->code > 0 && bgp_notify->code < 7) {
        if (vflag)
            (void)printf("code    %d \"%s\"\n",
		bgp_notify->code,  bgp_err_code[bgp_notify->code]);
        else
            (void)printf("\"%s\"\n", bgp_err_code[bgp_notify->code]);

        if(bgp_notify->code == 1) {
            if (bgp_notify->subcode > 0 && bgp_notify->subcode < 4)
                if (vflag)
                    (void)printf("                : subcode %d \"%s\"\n",
			bgp_notify->subcode, bgp_err_subcode1[bgp_notify->subcode]);
                else
                    (void)printf("                : %s\n",
			bgp_err_subcode1[bgp_notify->subcode]);
            else
                (void)printf("                : Invalid subcode %d\n",
			bgp_notify->subcode);
        }
        else if(bgp_notify->code == 2) {
            if (bgp_notify->subcode > 0 && bgp_notify->subcode < 7)
                if (vflag)
                    (void)printf("                : subcode %d \"%s\"\n",
			bgp_notify->subcode, bgp_err_subcode2[bgp_notify->subcode]);
                else
                    (void)printf("                : %s\n",
			bgp_err_subcode2[bgp_notify->subcode]);
            else
                (void)printf("                : Invalid subcode %d\n",
			bgp_notify->subcode);
        }
        if(bgp_notify->code == 3) {
            if (bgp_notify->subcode > 0 && bgp_notify->subcode < 12)
                if (vflag)
                    (void)printf("                : subcode %d \"%s\"\n",
			bgp_notify->subcode, bgp_err_subcode3[bgp_notify->subcode]);
                else
                    (void)printf("                : %s\n",
			bgp_err_subcode3[bgp_notify->subcode]);
            else
                (void)printf("                : Invalid subcode %d\n",
			bgp_notify->subcode);
        }
    }
    else {
        (void)printf("Invalid code %d\n",bgp_notify->code);
    }

    pkt += sizeof(struct bgp_notification);

    len -= bgp_len;
    (void)printf("\n");

} /* end of bgp_notify */


/* BGP KEEPALIVE message */
void
bgp_keepalive(struct pktinfo *pktinfo, u_int16_t bgp_len)
{
    struct pktinfo n_hdr;
    const u_char *pkt = pktinfo->pkt;
    bpf_u_int32 len = pktinfo->len;

    (void)printf("BGP KEEPALIVE\n");

    len -= bgp_len;
    (void)printf("\n");
    if (len > 1) {
        pkt += BGP_HDR_SIZE;
        n_hdr.pkt = pkt;
        n_hdr.len = len;
        bgp_msg(&n_hdr);
    }

} /*end of bgp_keepalive */


/* BGP UPDATE message */
void
bgp_update(struct pktinfo *pktinfo, u_int16_t bgp_len)
{
    struct pktinfo n_hdr;
    const u_char *pkt = pktinfo->pkt;
    struct bgp_update *bgp_update = (struct bgp_update *)pkt;
    bpf_u_int32 len = pktinfo->len;
    u_int16_t plen = 0;

    (void)printf("BGP UPDATE:\n");

    if (vflag)
        (void)printf("Withdrawn routes: %d bytes\n", bgp_update->withdrawnlen);

    pkt += BGP_HDR_SIZE + BGP_WITHDRAWNLEN;

    plen = htons(*(u_int16_t *)pkt);
    pkt += BGP_PATHATTRLEN;
    if (vflag)
        (void)printf("Path attribute length: %d bytes\n", plen);

    pkt = bgp_up_attr(pkt, plen);

    len -= bgp_len;

    (void)printf("\n");
    if (len > 1 && pkt != NULL) {
        n_hdr.pkt = pkt;
        n_hdr.len = len;
        bgp_msg(&n_hdr);
    }

} /*end of bgp_update */

/* BGP UPDATE Path Attributes */
const u_char *
bgp_up_attr(register const u_char *pkt, register u_int16_t plen)
{
    int attr_len, prefixlen, e_prefix;
    int as_seq_len = NULL;
    struct mp_nlri *mp_nlri = NULL;
    struct mp_un_nlri *mp_un_nlri = NULL;
    struct in6_addr NLRI;
    register int x;
    int external = 0;

    while (plen > 0) {
        struct p_attr *p_attr = (struct p_attr *)pkt;

        external = bgp_p_attr_len(p_attr);
        if (external == 1) {
            attr_len = htons(p_attr->p_attr_elen);
            pkt += BGP_UP_ATTR_LEN + 1;
            plen -= BGP_UP_ATTR_LEN + 1;
        }
        else {
            attr_len = p_attr->p_attr_len;
            pkt += BGP_UP_ATTR_LEN;
            plen -= BGP_UP_ATTR_LEN;
        }

        switch(p_attr->attr_type) {
            case BGP_UP_ORIGIN:
                (void)printf("ORIGIN[%s%s%s%s]:",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
                if (attr_len != 1)
                    (void)printf(" invalid length\n");
                else
                    (void)printf(" %s, ", bgp_up_origin[*(u_int8_t *)pkt]);
                pkt += attr_len;
                plen -= attr_len;
                break;
            case BGP_UP_ASPATH:
                (void)printf("AS_PATH[%s%s%s%s]",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
                if (attr_len == 0) {
                    (void)printf(": length %d, ", attr_len);
                }
                else {
                    if (*(u_int8_t *)pkt == 1) {
                        (void)printf("(SET):");
                    }
                    else if (*(u_int8_t *)pkt == 2) {
                        (void)printf("(SEQUENCE):");
                    }
                    else {
                        (void)printf(": Invalid path segment type, ");
                        pkt += attr_len;
                        break;
                    }
                    pkt ++;
                    as_seq_len = *(u_int8_t *)pkt;
                    pkt ++;
                    while (as_seq_len > 0) {
                        (void)printf(" %d", htons(*(u_int16_t *)pkt));
                        pkt += 2;
                        as_seq_len --;
                    }
                    (void)printf(", ");
                }
                plen -= attr_len;
                break;
            case BGP_UP_NXTHOP:
                (void)printf("\nNext BGP ID[%s%s%s%s]: ",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
                if (attr_len != 4)
                    (void)printf("Invalid length %d, ", attr_len);
                else
                    (void)printf("%s, ", addr4_string(ntohl(*(u_int32_t *)pkt)));
                pkt += attr_len;
                plen -= attr_len;
                break;
            case BGP_UP_MED:
                (void)printf("MED[%s%s%s%s]: ",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
		if (attr_len != 4)
		    (void)printf("Invalid length %d, ", attr_len);
		(void)printf("%ld, ", htonl(*(u_int32_t *)pkt));
                pkt += attr_len;
                plen -= attr_len;
                break;
            case BGP_UP_PREF:
                (void)printf("Local pref[%s%s%s%s]: ",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
                if (attr_len != 4)
                    (void)printf("Invalid length %d", attr_len);
                else
                    (void)printf("%ld", ntohl(*(u_int32_t *)pkt));
                pkt += attr_len;
                plen -= attr_len;
                break;
            case BGP_UP_ATMAGGR:
                (void)printf("\nATOOMIC AGGREGATE[%s%s%s%s]: ",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
                if (attr_len != 0)
		    (void)printf("Invalid length %d", attr_len);
                pkt += attr_len;
                plen -= attr_len;
                break;
            case BGP_UP_AGGRGTR:
                (void)printf("\nAGGREGATOR[%s%s%s%s]: ",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
                if (attr_len != 6) {
		    (void)printf("Invalid length %d", attr_len);
		}
		else {
                    (void)printf("AS# %d, ", htons(*(u_int16_t *)pkt));
		    pkt += 2;
		    (void)printf("BGP ID %s", addr4_string(ntohl(*(u_int32_t *)pkt)));
		}

                pkt += attr_len;
                plen -= attr_len;
                break;
            case BGP_UP_CMT:
                pkt += attr_len;
                plen -= attr_len;
                break;
            case BGP_UP_ORGNTR:
                (void)printf("\nORIGINATOR ID[%s%s%s%s]: ",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
                if (attr_len != 4)
                    (void)printf("Invalid length %d, ", attr_len);
                else
                    (void)printf("%s,", addr4_string(ntohl(*(u_int32_t *)pkt)));
                pkt += attr_len;
                plen -= attr_len;
                break;
            case BGP_UP_CLSTR:
                (void)printf("\nCLUSTER LIST[%s%s%s%s]: ",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
                if (attr_len % 4 == 0) {
                    while (attr_len > 0) {
                        (void)printf("%s, ",
                            addr4_string(ntohl(*(u_int32_t *)pkt)));
                        pkt += 4;
                        plen -= 4;
			attr_len -= 4;
                    }
                }
                else {
                    (void)printf("Invalid length %d,", attr_len);
                    pkt += attr_len;
                    plen -= attr_len;
                }
                break;
            case BGP_UP_MPNLRI:
                (void)printf("\nMP_REACH_NLRI[%s%s%s%s]: ",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");
                mp_nlri = (struct mp_nlri *)pkt;
                (void)printf("%s", af_numbers[htons(mp_nlri->afid)]);
                (void)printf(" %s\n", SAFIDs[mp_nlri->safid]);

                plen -= attr_len;
                pkt += MP_REACH_NLRI_LEN;
                attr_len -= MP_REACH_NLRI_LEN;

                if (mp_nlri->nxthoplen%16 == 0 && mp_nlri->nxthoplen != 0) {
                    (void)printf("Next hop address: %s\n", addr6_string((struct in6_addr *)pkt));
                    pkt += sizeof(struct in6_addr);
                    if (mp_nlri->nxthoplen == 32) {
                        (void)printf("      link-local: %s\n", addr6_string((struct in6_addr *)pkt));
                        pkt += sizeof(struct in6_addr);
                    }
                }
                else {
                    (void)printf("Invalid length of Next hop network address\n");
                }
                attr_len -= mp_nlri->nxthoplen;

                if (*(u_int8_t *)pkt > 0) {
                }
                else {
                    pkt ++;
                    attr_len --;
                }

                while (attr_len > 0) {
                    prefixlen = 0;
                    e_prefix = 0;

                    prefixlen = *(u_int8_t *)pkt;
                    pkt ++;
                    attr_len --;
                    e_prefix = prefixlen / 16;
                    if (prefixlen % 16 != 0)
                        e_prefix ++;

                    for (x = 0; x < e_prefix * 2; x++) {
                        NLRI.s6_addr[x] = *(u_int8_t *)pkt;
                        pkt ++;
                    }
                    attr_len -= e_prefix * 2;
                    for (x = e_prefix * 2; x < 16; x++){
                        NLRI.s6_addr[x] = 0;
                    }
                    (void)printf("NLRI: %s/%d\n", addr6_string(&NLRI), prefixlen);
                }
                break;
            case BGP_UP_MPUNLRI:
                (void)printf("MP_UNREACH_NLRI[%s%s%s%s]: ",
                    p_attr->attr_flags & 0x80 ? "O" : "",
                    p_attr->attr_flags & 0x40 ? "T" : "",
                    p_attr->attr_flags & 0x20 ? "P" : "",
                    p_attr->attr_flags & 0x10 ? "E" : "");

                mp_un_nlri = (struct mp_un_nlri *)pkt;
                (void)printf("%s", af_numbers[htons(mp_un_nlri->afid)]);
                (void)printf(" %s\n", SAFIDs[mp_un_nlri->safid]);

                plen -= attr_len;
                pkt += MP_UNREACH_NLRI_LEN;
                attr_len -= MP_UNREACH_NLRI_LEN;

                while (attr_len > 0) {
                    prefixlen = 0;
                    e_prefix = 0;

                    prefixlen = *(u_int8_t *)pkt;
                    pkt ++;
                    attr_len --;
                    e_prefix = prefixlen / 16;
                    if (prefixlen % 16 != 0)
                        e_prefix ++;

                    for (x = 0; x < e_prefix * 2; x++) {
                        NLRI.s6_addr[x] = *(u_int8_t *)pkt;
                        pkt ++;
                    }
                    attr_len -= e_prefix * 2;
                    for (x = e_prefix * 2; x < 16; x++){
                        NLRI.s6_addr[x] = 0;
                    }
                    (void)printf("Withdrawn route: %s/%d\n", addr6_string(&NLRI), prefixlen);
                }
                break;
            default:
                (void)printf("Invalid path attribute type %d\n", p_attr->attr_type);
                pkt = NULL;
                plen = 0;
                break;
        }

    }
    return pkt;

} /* end of bgp_up_attr */
