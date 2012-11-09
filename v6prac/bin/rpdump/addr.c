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
 * $Id: addr.c,v 1.1.2.1 2001/02/07 12:43:45 endo Exp $
 */

#include "general.h"
#include <netdb.h>

char sportname[96];
char dportname[96];

/* printer of IPv4 addresses */
char *
v4_addr (struct addr_4 *addr_4, int encap)
{
    int sport = 0;
    int dport = 0;
    char src_addr[1024], dst_addr[1024], c_srcp[96], c_dstp[96];
    char *src_port = NULL;
    char *dst_port = NULL;

    strcpy(c_srcp, " ");
    strcpy(c_dstp, " ");

    strcpy(src_addr, addr4_string(addr_4->src));
    strcpy(dst_addr, addr4_string(addr_4->dst));

    if (addr_4->nxtflag == 1) {
        sport = htons(addr_4->p_tcp->th_sport);
        dport = htons(addr_4->p_tcp->th_dport);

        if(!nflag && !vflag) {
	    src_port = port_string(sport, addr_4->nxtflag, 0);
	    dst_port = port_string(dport, addr_4->nxtflag, 1);
        }
        else {
	    sprintf(c_srcp, "%d", sport);
	    sprintf(c_dstp, "%d", dport);
	    src_port = c_srcp;
	    dst_port = c_dstp;
        }

        if (encap > 0)
            sprintf(addr, "%s [%s.%s > %s.%s]", addr,
		src_addr, src_port, dst_addr, dst_port);
        else
            sprintf(addr, "from %s.%s to %s.%s",
		src_addr, src_port, dst_addr, dst_port);

        addr_4->p_tcp = NULL;
        addr_4->p_udp = NULL;
    }
    else if (addr_4->nxtflag == 2) {
        sport = htons(addr_4->p_udp->uh_sport);
        dport = htons(addr_4->p_udp->uh_dport);

        if(!nflag && !vflag) {
	    src_port = port_string(sport, addr_4->nxtflag, 0);
	    dst_port = port_string(dport, addr_4->nxtflag, 1);
        }
        else {
	    sprintf(c_srcp, "%d", sport);
	    sprintf(c_dstp, "%d", dport);
	    src_port = c_srcp;
	    dst_port = c_dstp;
        }

        if (encap > 0)
            sprintf(addr, "%s [%s.%s > %s.%s]", addr,
		src_addr, src_port, dst_addr, dst_port);
        else
            sprintf(addr, "from %s.%s to %s.%s",
		src_addr, src_port, dst_addr, dst_port);

        addr_4->p_tcp = NULL;
        addr_4->p_udp = NULL;
    }
    else {
        if (encap > 0)
            sprintf(addr, "%s [%s > %s]", addr,
		src_addr, dst_addr);
        else
            sprintf(addr, "from %s to %s",
		src_addr, dst_addr);
    }

    return addr;

} /* end of printer of IPv4 address */


/* addr4_string */
char *
addr4_string (register u_int32_t addr_4)
{

    sprintf(r_addr, " ");

    sprintf(r_addr, "%d.%d.%d.%d", addr_4/0x1000000,
        (addr_4%0x1000000)/0x10000, ((addr_4%0x1000000)%0x10000)/0x100,
        ((addr_4%0x1000000)%0x10000)%0x100);

    return r_addr;

} /* end of addr4_string */


/* printer of IPv6 addresses */
char *
v6_addr (struct addr_6 *addr_6, int encap)
{
    char src_addr[1024], dst_addr[1024], c_srcp[96], c_dstp[96];
    char *src_port = NULL;
    char *dst_port = NULL;
    u_short sport = 0;
    u_short dport = 0;

    strcpy(c_srcp, " ");
    strcpy(c_dstp, " ");

    strcpy(src_addr, addr6_string(&addr_6->src));
    strcpy(dst_addr, addr6_string(&addr_6->dst));

    if (addr_6->nxtflag == 1) {
        sport = htons(addr_6->p_tcp->th_sport);
        dport = htons(addr_6->p_tcp->th_dport);

        if(!nflag && !vflag) {
	    src_port = port_string(sport, addr_6->nxtflag, 0);
	    dst_port = port_string(dport, addr_6->nxtflag, 1);
        }
        else {
            sprintf(c_srcp, "%d", sport);
            sprintf(c_dstp, "%d", dport);
	    src_port = c_srcp;
	    dst_port = c_dstp;
        }

        if (encap > 0) 
            sprintf (addr, "%s [%s.%s > %s.%s]", addr,
                src_addr, src_port,
                dst_addr, dst_port);
        else
            sprintf (addr, "from %s.%s to %s.%s",
                src_addr, src_port,
                dst_addr, dst_port);

        addr_6->p_udp = NULL;
        addr_6->p_tcp = NULL;
    }
    else if (addr_6->nxtflag == 2) {
        sport = htons(addr_6->p_udp->uh_sport);
        dport = htons(addr_6->p_udp->uh_dport);

        if(!nflag && !vflag) {
	    src_port = port_string(sport, addr_6->nxtflag, 0);
	    dst_port = port_string(dport, addr_6->nxtflag, 1);
        }
        else {
            sprintf(c_srcp, "%d", sport);
            sprintf(c_dstp, "%d", dport);
	    src_port = c_srcp;
	    dst_port = c_dstp;
        }

        if (encap > 0) 
            sprintf (addr, "%s [%s.%s > %s.%s]", addr,
                src_addr, src_port,
                dst_addr, dst_port);
        else
            sprintf (addr, "from %s.%s to %s.%s",
                src_addr, src_port,
                dst_addr, dst_port);

        addr_6->p_udp = NULL;
        addr_6->p_tcp = NULL;
    }
    else {
        if (encap > 0) 
            sprintf (addr, "%s [%s > %s]", addr, src_addr, dst_addr);
        else
            sprintf (addr, "from %s to %s", src_addr, dst_addr);
    }

    return addr;
}/* end of printer of IPv6 address */

/* addr6_string */
char *
addr6_string (struct in6_addr *addr)
{
    u_int8_t p[16];
    u_int16_t paddr[8];
    int y;
    int w = 0;
    int x = 0;
    int v = 0;
    int count = 0;

    sprintf(r_addr, " ");

    for (y = 0; y < 16; y++)
        p[y] = addr->s6_addr[y];

    for (y = 0;y < 8; y++) {
        paddr[y] = p[y * 2 + 1] + p[y * 2] * 0x100;
        if (v == 1 && paddr[y] == 0) {
        }
        else if (x == 1 && paddr[y] == 0) {
            count ++;
            v = 1;
        }
        else if (paddr[y] == 0) {
            x = 1;
        }
        else {
            x = 0;
            v = 0;
        }
    }

    v = 0;
    x = 0;

    for (y = 0;y < 8; y++) {
        paddr[y] = p[y * 2 + 1] + p[y * 2] * 0x100;

        if (y == 0) {
            if (paddr[y] == 0 && paddr[y+1] == 0) {
            }
            else {
                sprintf(r_addr, "%x", paddr[y]);
            }
        }
        else if (w == 1 && paddr[y] == 0) {
            if (count == 1) {
                x = 1;
            }
            else {
                count --;
                v = 1;
                w = 0;
                sprintf(r_addr, "%s:%x", r_addr, paddr[y]);
            }
        }
        else if (x == 0 && paddr[y] == 0) {
            if (count == 1) {
                w = 1;
                if (paddr[y + 1] == 0)
                    sprintf(r_addr, "%s:", r_addr);
                else
                    sprintf(r_addr, "%s:%x", r_addr, paddr[y]);
            }
            else {
                w = 1;
                sprintf(r_addr, "%s:%x", r_addr, paddr[y]);
            }
        }
        else if (v == 1 && paddr[y] == 0) {
            sprintf(r_addr, "%s:%x", r_addr, paddr[y]);
        }
        else {
            w = 0;
            v = 0;
            sprintf(r_addr, "%s:%x", r_addr, paddr[y]);
        }
    }
    if (w == 1)
        sprintf(r_addr, "%s:", r_addr);

    return r_addr;

} /* end of addr6_string */

char *
port_string (int port, int proto, int flag)
{
    struct servent *servent = NULL;

    if (flag ==0)
        strcpy(sportname, " ");
    else
        strcpy(dportname, " ");

    if (proto == 1) {
        servent = getservbyport(htons(port), "tcp");
	if (servent == NULL)
            if (flag == 0)
	        sprintf(sportname, "%d", port);
            else
	        sprintf(dportname, "%d", port);
	else
            if (flag == 0)
	        strcpy(sportname, servent->s_name);
            else
	        strcpy(dportname, servent->s_name);
    }
    else if (proto == 2) {
        servent = getservbyport(htons(port), "udp");
	if (servent == NULL)
            if (flag == 0)
	        sprintf(sportname, "%d", port);
            else
	        sprintf(dportname, "%d", port);
	else
            if (flag == 0)
	        strcpy(sportname, servent->s_name);
            else
	        strcpy(dportname, servent->s_name);
    }

    if (flag ==0)
        return sportname;
    else
        return dportname;
}
