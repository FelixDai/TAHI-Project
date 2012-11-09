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
#include <stdio.h>
#include <sys/types.h>
#include <netinet/in.h>

extern int total_ip_addr;
extern int *ip_to_print;
extern int *print_to_ip;
extern struct in6_addr *s6;

void in6_is_addr_linklocal(void);
void in6_is_addr_mc_global(void);
void in6_is_addr_mc_linklocal(void);
void in6_is_addr_mc_sitelocal(void);
void in6_is_addr_sitelocal(void);
void in6_is_addr_unspecified(void);
void in6_is_addr_v4mapped(void);

void sort_addr(void) {
    int counter = 0;
    int equal_counter = 0;
    int loop_caunter = 0;
    int loop_flag = 0;
    int sort_counter = 0;
    int swap_flag = 0;
    int tmp = 0;

    while(counter < 16) {
        swap_flag = 1;
        while(swap_flag == 1) {
            swap_flag = 0;
            sort_counter = 0;

            while(sort_counter < total_ip_addr - 1) {
                loop_flag = 0;

                if(counter == 0) {
                    loop_flag = 1;
                } else {
                    equal_counter = 0;
                    loop_caunter = 0;

                    while(loop_caunter < counter) {
                        if(s6[print_to_ip[sort_counter]].s6_addr[loop_caunter] ==
                           s6[print_to_ip[sort_counter + 1]].s6_addr[loop_caunter]) {
                            equal_counter++;
                        }

                        loop_caunter++;
                    }

                    if(equal_counter == counter) {
                        loop_flag = 1;
                    }
                }

                if((loop_flag == 1) &&
                   (s6[print_to_ip[sort_counter]].s6_addr[counter] >
                    s6[print_to_ip[sort_counter + 1]].s6_addr[counter])) {
                    tmp = print_to_ip[sort_counter];
                    print_to_ip[sort_counter] = print_to_ip[sort_counter + 1];
                    print_to_ip[sort_counter + 1] = tmp;

                    swap_flag = 1;
                }

                sort_counter++;
            }
        }

        counter++;
    }

    counter = 0;
    while(counter < total_ip_addr) {
        ip_to_print[print_to_ip[counter]] = counter;
        counter++;
    }

    in6_is_addr_mc_global();
    in6_is_addr_sitelocal();
    in6_is_addr_mc_sitelocal();
    in6_is_addr_linklocal();
    in6_is_addr_mc_linklocal();
    in6_is_addr_unspecified();
    in6_is_addr_v4mapped();

    return;
}
