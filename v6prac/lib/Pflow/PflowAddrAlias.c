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
 */

/*
 * RFC 2375
 *
 * IPv6 Multicast Address Assignments
 */

#include <stdio.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <string.h>
#include "PflowFlow.h"

extern char alias[1024][1024];
extern int NUMERIC;
extern int total_ip_addr;
extern struct in6_addr *s6;

char *resolve_addr(struct in6_addr *);

int addr_alias(void) {
    int counter = 0;
    int max_length = 0;
    char *name = NULL;

    while(counter < total_ip_addr) {
        if(strcmp(alias[counter], " \0") == 0) {
            memset(alias[counter], 0, sizeof(alias[counter]));
        }

        if(NUMERIC != 1) {
            if(strlen(alias[counter]) == 0) {
                name = resolve_addr(&s6[counter]);
                if(name != NULL) {
                    strcpy(alias[counter], name);
                }
            }

            if(strlen(alias[counter]) == 0) {
                if(IN6_IS_ADDR_UNSPECIFIED(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Unspecified Address");
                }

                if(IN6_IS_ADDR_ALLNODES(&s6[counter]) == 1) {
                    strcpy(alias[counter], "All Nodes Address");
                }

                if(IN6_IS_ADDR_ALLROUTERS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "All Routers Address");
                }

                if(IN6_IS_ADDR_UNASSIGNED(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Unassigned");
                }

                if(IN6_IS_ADDR_DVMRP(&s6[counter]) == 1) {
                    strcpy(alias[counter], "DVMRP Routers");
                }

                if(IN6_IS_ADDR_OSPFIGP(&s6[counter]) == 1) {
                    strcpy(alias[counter], "OSPFIGP");
                }

                if(IN6_IS_ADDR_OSPFIGPDESIGNATED(&s6[counter]) == 1) {
                    strcpy(alias[counter], "OSPFIGP Designated Routers");
                }

                if(IN6_IS_ADDR_STROUTERS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "ST Routers");
                }

                if(IN6_IS_ADDR_STHOSTS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "ST Hosts");
                }

                if(IN6_IS_ADDR_RIP(&s6[counter]) == 1) {
                    strcpy(alias[counter], "RIP Routers");
                }

                if(IN6_IS_ADDR_EIGRP(&s6[counter]) == 1) {
                    strcpy(alias[counter], "EIGRP Routers");
                }

                if(IN6_IS_ADDR_MOBILE(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Mobile-Agents");
                }

                if(IN6_IS_ADDR_PIM(&s6[counter]) == 1) {
                    strcpy(alias[counter], "All PIM Routers");
                }

                if(IN6_IS_ADDR_RSVPENCAPSULATION(&s6[counter]) == 1) {
                    strcpy(alias[counter], "RSVP-ENCAPSULATION");
                }

                if(IN6_IS_ADDR_LINKNAME(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Link Name");
                }

                if(IN6_IS_ADDR_DHCPAGENTS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "All-dhcp-agents");
                }

                if(IN6_IS_ADDR_SOLICITED(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Solicited-Node Address");
                }

                if(IN6_IS_ADDR_DHCPSERVERS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "All-dhcp-servers");
                }

                if(IN6_IS_ADDR_DHCPRELAYS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "All-dhcp-relays");
                }

                if(IN6_IS_ADDR_SERVICELOCATION(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Service Location");
                }

                if(IN6_IS_ADDR_RESERVED(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Reserved Multicast Address");
                }

                if(IN6_IS_ADDR_VMTP(&s6[counter]) == 1) {
                    strcpy(alias[counter], "VMTP Managers Group");
                }

                if(IN6_IS_ADDR_NTP(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Network Time Protocol (NTP)");
                }

                if(IN6_IS_ADDR_SGIDOGFIGHT(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SGI-Dogfight");
                }

                if(IN6_IS_ADDR_RWHOD(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Rwhod");
                }

                if(IN6_IS_ADDR_VNP(&s6[counter]) == 1) {
                    strcpy(alias[counter], "VNP");
                }

                if(IN6_IS_ADDR_ARTIFICIALHORIZONS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Artificial Horizons - Aviator");
                }

                if(IN6_IS_ADDR_NSS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "NSS - Name Service Server");
                }

                if(IN6_IS_ADDR_AUDIONEWS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "AUDIONEWS - Audio News Multicast");
                }

                if(IN6_IS_ADDR_SUNNIS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SUN NIS+ Information Service");
                }

                if(IN6_IS_ADDR_MTP(&s6[counter]) == 1) {
                    strcpy(alias[counter], "MTP Multicast Transport Protocol");
                }

                if(IN6_IS_ADDR_IETF1LOWAUDIO(&s6[counter]) == 1) {
                    strcpy(alias[counter], "IETF-1-LOW-AUDIO");
                }

                if(IN6_IS_ADDR_IETF1AUDIO(&s6[counter]) == 1) {
                    strcpy(alias[counter], "IETF-1-AUDIO");
                }

                if(IN6_IS_ADDR_IETF1VIDEO(&s6[counter]) == 1) {
                    strcpy(alias[counter], "IETF-1-VIDEO");
                }

                if(IN6_IS_ADDR_IETF2LOWAUDIO(&s6[counter]) == 1) {
                    strcpy(alias[counter], "IETF-2-LOW-AUDIO");
                }

                if(IN6_IS_ADDR_IETF2AUDIO(&s6[counter]) == 1) {
                    strcpy(alias[counter], "IETF-2-AUDIO");
                }

                if(IN6_IS_ADDR_IETF2VIDEO(&s6[counter]) == 1) {
                    strcpy(alias[counter], "IETF-2-VIDEO");
                }

                if(IN6_IS_ADDR_MUSICSERVICE(&s6[counter]) == 1) {
                    strcpy(alias[counter], "MUSIC-SERVICE");
                }

                if(IN6_IS_ADDR_SEANETTELEMETRY(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SEANET-TELEMETRY");
                }

                if(IN6_IS_ADDR_SEANETIMAGE(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SEANET-IMAGE");
                }

                if(IN6_IS_ADDR_MLOADD(&s6[counter]) == 1) {
                    strcpy(alias[counter], "MLOADD");
                }

                if(IN6_IS_ADDR_ANYPRIVATEEXPERIMENT(&s6[counter]) == 1) {
                    strcpy(alias[counter], "any private experiment");
                }

                if(IN6_IS_ADDR_DVMRPONMOSPF(&s6[counter]) == 1) {
                    strcpy(alias[counter], "DVMRP on MOSPF");
                }

                if(IN6_IS_ADDR_SVRLOC(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SVRLOC");
                }

                if(IN6_IS_ADDR_XINGTV(&s6[counter]) == 1) {
                    strcpy(alias[counter], "XINGTV");
                }

                if(IN6_IS_ADDR_MICROSOFTDS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "microsoft-ds");
                }

                if(IN6_IS_ADDR_NBCPRO(&s6[counter]) == 1) {
                    strcpy(alias[counter], "nbc-pro");
                }

                if(IN6_IS_ADDR_NBCPFN(&s6[counter]) == 1) {
                    strcpy(alias[counter], "nbc-pfn");
                }

                if(IN6_IS_ADDR_LMSCCALREN1(&s6[counter]) == 1) {
                    strcpy(alias[counter], "lmsc-calren-1");
                }

                if(IN6_IS_ADDR_LMSCCALREN2(&s6[counter]) == 1) {
                    strcpy(alias[counter], "lmsc-calren-2");
                }

                if(IN6_IS_ADDR_LMSCCALREN3(&s6[counter]) == 1) {
                    strcpy(alias[counter], "lmsc-calren-3");
                }

                if(IN6_IS_ADDR_LMSCCALREN4(&s6[counter]) == 1) {
                    strcpy(alias[counter], "lmsc-calren-4");
                }

                if(IN6_IS_ADDR_AMPRINFO(&s6[counter]) == 1) {
                    strcpy(alias[counter], "ampr-info");
                }

                if(IN6_IS_ADDR_MTRACE(&s6[counter]) == 1) {
                    strcpy(alias[counter], "mtrace");
                }

                if(IN6_IS_ADDR_RSVPENCAP1(&s6[counter]) == 1) {
                    strcpy(alias[counter], "RSVP-encap-1");
                }

                if(IN6_IS_ADDR_RSVPENCAP2(&s6[counter]) == 1) {
                    strcpy(alias[counter], "RSVP-encap-2");
                }

                if(IN6_IS_ADDR_SVRLOCDA(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SVRLOC-DA");
                }

                if(IN6_IS_ADDR_RLNSERVER(&s6[counter]) == 1) {
                    strcpy(alias[counter], "rln-server");
                }

                if(IN6_IS_ADDR_PROSHAREMC(&s6[counter]) == 1) {
                    strcpy(alias[counter], "proshare-mc");
                }

                if(IN6_IS_ADDR_DANTZ(&s6[counter]) == 1) {
                    strcpy(alias[counter], "dantz");
                }

                if(IN6_IS_ADDR_CISCORPANNOUNCE(&s6[counter]) == 1) {
                    strcpy(alias[counter], "cisco-rp-announce");
                }

                if(IN6_IS_ADDR_CISCORPDISCOVERY(&s6[counter]) == 1) {
                    strcpy(alias[counter], "cisco-rp-discovery");
                }

                if(IN6_IS_ADDR_GATEKEEPER(&s6[counter]) == 1) {
                    strcpy(alias[counter], "gatekeeper");
                }

                if(IN6_IS_ADDR_IBERIAGAMES(&s6[counter]) == 1) {
                    strcpy(alias[counter], "iberiagames");
                }

                if(IN6_IS_ADDR_RWHOGROUP(&s6[counter]) == 1) {
                    strcpy(alias[counter], "\"rwho\" Group (BSD) (unofficial)");
                }

                if(IN6_IS_ADDR_SUNRPCPMAPPROCCALLIT(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SUN RPC PMAPPROC_CALLIT");
                }

                if(IN6_IS_ADDR_MULTIMEDIACONFERENCECALLS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "Multimedia Conference Calls");
                }

                if(IN6_IS_ADDR_SAPV1ANNOUNCEMENTS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SAPv1 Announcements");
                }

                if(IN6_IS_ADDR_SAPV0ANNOUNCEMENTS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SAPv0 Announcements (deprecated)");
                }

                if(IN6_IS_ADDR_SAPDYNAMICASSIGNMENTS(&s6[counter]) == 1) {
                    strcpy(alias[counter], "SAP Dynamic Assignments");
                }
            }
        }

        if(max_length < strlen(alias[counter])) {
            max_length = strlen(alias[counter]);
        }

        counter++;
    }

    return(max_length);
}
