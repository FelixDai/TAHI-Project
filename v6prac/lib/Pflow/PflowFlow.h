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
#define DATE "20000511"

struct packets {
    char pkt_time[1024];
    int pkt_mac_src;
    int pkt_mac_dst;
    int pkt_ip_src;
    int pkt_ip_dst;
    char pkt_analyze[1024];
    int pkt_clr;
};

struct upper {
    int upp_x;
    int upp_y;
    char upp_data[1024];
};

#define BLACK 0
#define RED 1
#define GREEN 2
#define BLUE 3
#define TEAL 4

#define IN6_IS_ADDR_ALLNODES(a) \
        (((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff010000)) || \
          (*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000))) && \
          (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
          (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
          (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000001)))

#define IN6_IS_ADDR_ALLROUTERS(a) \
        (((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff010000)) || \
          (*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) || \
          (*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff050000))) && \
          (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
          (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
          (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000002)))

#define IN6_IS_ADDR_UNASSIGNED(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000003)))

#define IN6_IS_ADDR_DVMRP(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000004)))

#define IN6_IS_ADDR_OSPFIGP(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000005)))

#define IN6_IS_ADDR_OSPFIGPDESIGNATED(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000006)))

#define IN6_IS_ADDR_STROUTERS(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000007)))

#define IN6_IS_ADDR_STHOSTS(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000008)))

#define IN6_IS_ADDR_RIP(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000009)))

#define IN6_IS_ADDR_EIGRP(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000000a)))

#define IN6_IS_ADDR_MOBILE(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000000b)))

#define IN6_IS_ADDR_PIM(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000000d)))

#define IN6_IS_ADDR_RSVPENCAPSULATION(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000000e)))

#define IN6_IS_ADDR_LINKNAME(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00010001)))

#define IN6_IS_ADDR_DHCPAGENTS(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00010002)))

#define IN6_IS_ADDR_SOLICITED(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff020000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == ntohl(0x00000001)) && \
         (*(u_int8_t *)(&(a)->s6_addr[12]) == 0xff))

#define IN6_IS_ADDR_DHCPSERVERS(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff050000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00010003)))

#define IN6_IS_ADDR_DHCPRELAYS(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff050000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00010004)))

#define IN6_IS_ADDR_SERVICELOCATION(a) \
        ((*(u_int32_t *)(&(a)->s6_addr[0]) == ntohl(0xff050000)) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int16_t *)(&(a)->s6_addr[12]) == ntohs(0x0001)) && \
        ((*(u_int8_t *)(&(a)->s6_addr[14]) >= 0x10) && \
         (*(u_int8_t *)(&(a)->s6_addr[14]) <= 0x13)))

#define IN6_IS_ADDR_RESERVED(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == 0))

#define IN6_IS_ADDR_VMTP(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000100)))

#define IN6_IS_ADDR_NTP(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000101)))

#define IN6_IS_ADDR_SGIDOGFIGHT(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000102)))

#define IN6_IS_ADDR_RWHOD(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000103)))

#define IN6_IS_ADDR_VNP(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000104)))

#define IN6_IS_ADDR_ARTIFICIALHORIZONS(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000105)))

#define IN6_IS_ADDR_NSS(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000106)))

#define IN6_IS_ADDR_AUDIONEWS(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000107)))

#define IN6_IS_ADDR_SUNNIS(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000108)))

#define IN6_IS_ADDR_MTP(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000109)))

#define IN6_IS_ADDR_IETF1LOWAUDIO(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000010a)))

#define IN6_IS_ADDR_IETF1AUDIO(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000010b)))

#define IN6_IS_ADDR_IETF1VIDEO(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000010c)))

#define IN6_IS_ADDR_IETF2LOWAUDIO(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000010d)))

#define IN6_IS_ADDR_IETF2AUDIO(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000010e)))

#define IN6_IS_ADDR_IETF2VIDEO(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000010f)))

#define IN6_IS_ADDR_MUSICSERVICE(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000110)))

#define IN6_IS_ADDR_SEANETTELEMETRY(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000111)))

#define IN6_IS_ADDR_SEANETIMAGE(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000112)))

#define IN6_IS_ADDR_MLOADD(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000113)))

#define IN6_IS_ADDR_ANYPRIVATEEXPERIMENT(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000114)))

#define IN6_IS_ADDR_DVMRPONMOSPF(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000115)))

#define IN6_IS_ADDR_SVRLOC(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000116)))

#define IN6_IS_ADDR_XINGTV(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000117)))

#define IN6_IS_ADDR_MICROSOFTDS(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000118)))

#define IN6_IS_ADDR_NBCPRO(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000119)))

#define IN6_IS_ADDR_NBCPFN(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000011a)))

#define IN6_IS_ADDR_LMSCCALREN1(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000011b)))

#define IN6_IS_ADDR_LMSCCALREN2(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000011c)))

#define IN6_IS_ADDR_LMSCCALREN3(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000011d)))

#define IN6_IS_ADDR_LMSCCALREN4(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000011e)))

#define IN6_IS_ADDR_AMPRINFO(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000011f)))

#define IN6_IS_ADDR_MTRACE(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000120)))

#define IN6_IS_ADDR_RSVPENCAP1(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000121)))

#define IN6_IS_ADDR_RSVPENCAP2(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000122)))

#define IN6_IS_ADDR_SVRLOCDA(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000123)))

#define IN6_IS_ADDR_RLNSERVER(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000124)))

#define IN6_IS_ADDR_PROSHAREMC(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000125)))

#define IN6_IS_ADDR_DANTZ(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000126)))

#define IN6_IS_ADDR_CISCORPANNOUNCE(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000127)))

#define IN6_IS_ADDR_CISCORPDISCOVERY(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000128)))

#define IN6_IS_ADDR_GATEKEEPER(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000129)))

#define IN6_IS_ADDR_IBERIAGAMES(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x0000012a)))

#define IN6_IS_ADDR_RWHOGROUP(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000201)))

#define IN6_IS_ADDR_SUNRPCPMAPPROCCALLIT(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00000202)))

#define IN6_IS_ADDR_MULTIMEDIACONFERENCECALLS(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int16_t *)(&(a)->s6_addr[12]) == ntohs(0x0002)) && \
        ((*(u_int8_t *)(&(a)->s6_addr[14]) <= 0x7e) || \
        ((*(u_int8_t *)(&(a)->s6_addr[14]) == 0x7f) && \
         (*(u_int8_t *)(&(a)->s6_addr[15]) <= 0xfd))))

#define IN6_IS_ADDR_SAPV1ANNOUNCEMENTS(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00027ffe)))

#define IN6_IS_ADDR_SAPV0ANNOUNCEMENTS(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[12]) == ntohl(0x00027fff)))

#define IN6_IS_ADDR_SAPDYNAMICASSIGNMENTS(a) \
        ((*(u_int8_t *)(&(a)->s6_addr[0]) == 0xff) && \
         (*(u_int8_t *)(&(a)->s6_addr[1]) <= 0x0f) && \
         (*(u_int16_t *)(&(a)->s6_addr[2]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[4]) == 0) && \
         (*(u_int32_t *)(&(a)->s6_addr[8]) == 0) && \
         (*(u_int16_t *)(&(a)->s6_addr[12]) == ntohs(0x0002)) && \
        ((*(u_int8_t *)(&(a)->s6_addr[14]) >= 0x80) && \
         (*(u_int8_t *)(&(a)->s6_addr[14]) <= 0xff)))
