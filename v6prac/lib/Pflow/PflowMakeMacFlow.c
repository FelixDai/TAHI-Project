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
#include "PflowFlow.h"

extern int ALL_FLOW;
extern int HTML;
extern int MAC_FLOW;
extern int READ_DEFINE;
extern int *mac_addr_status;
extern int *mac_color;
extern int *mac_to_print;
extern int *print_to_mac;
extern int total_mac_addr;

void make_mac_flow(FILE *stream, int src, int dst, int clr) {
    int counter = 0;
    int max_counter = 0;
    int flag = 0;

    if(total_mac_addr > 52 + 1) {
        max_counter = 52 + 1;
    } else {
        max_counter = total_mac_addr;
    }

    if(src != -1) {
        src = mac_to_print[src];
        mac_addr_status[src] = 1;
    }

    if(dst != -1) {
        dst = mac_to_print[dst];
        mac_addr_status[dst] = 1;
    }

    if(src > 52) {
        src = 52;
        mac_addr_status[src] = 1;
    }

    if(dst > 52) {
        dst = 52;
        mac_addr_status[dst] = 1;
    }

    if(MAC_FLOW == 1) {
        while(counter < max_counter) {
            if((HTML == 1) &&
               (READ_DEFINE == 1) &&
              !((clr != BLACK) &&
                ((counter == src) || (counter == dst))) &&
              !(((counter > src) && (counter < dst)) ||
                ((counter < src) && (counter > dst))) &&
               (mac_color[print_to_mac[counter]] > 0) &&
               (mac_addr_status[counter] == 1)) {
                fprintf(stream, "<FONT COLOR=\"#%06x\">", mac_color[print_to_mac[counter]]);
            }

            if((counter == src) || (counter == dst)) {
                if((HTML == 1) && (flag == 0) && (clr != BLACK)) {
                    switch(clr) {
                        case RED:
                            fprintf(stream, "<FONT COLOR=\"#FF0000\">");
                            break;
                        case GREEN:
                            fprintf(stream, "<FONT COLOR=\"#008000\">");
                            break;
                        case BLUE:
                            fprintf(stream, "<FONT COLOR=\"#0000FF\">");
                            break;
                        case TEAL:
                            fprintf(stream, "<FONT COLOR=\"#008080\">");
                            break;
                        default:
                            ;
                    }
                }

                if(counter < 26) {
                    fputc('a' + counter, stream);
                } else if((counter >= 26) && (counter < 52)) {
                    fputc('A' + counter - 26, stream);
                } else {
                    fputc('?', stream);
                }

                if(src == dst) {
                    flag = 1;
                }

                if((HTML == 1) && (flag == 1) && (clr != BLACK)) {
                    fprintf(stream, "</FONT>");
                }

                flag = 1;
            } else if (((counter > src) && (counter < dst)) || ((counter < src) && (counter > dst))) {
                fputc('-', stream);
            } else if(mac_addr_status[counter] == 1) {
                fputc('|', stream);
            } else {
                fputc(' ', stream);
            }

            if((HTML == 1) &&
               (READ_DEFINE == 1) &&
              !((clr != BLACK) &&
                ((counter == src) || (counter == dst))) &&
              !(((counter > src) && (counter < dst)) ||
                ((counter < src) && (counter > dst))) &&
               (mac_color[print_to_mac[counter]] > 0) &&
               (mac_addr_status[counter] == 1)) {
                fprintf(stream, "</FONT>");
            }

            if((src < dst) && (counter + 1 == dst)) {
                if(HTML == 1) {
                    fprintf(stream, "-&gt;");
                } else {
                    printf("->");
                }
            } else if((src > dst) && (counter == dst)) {
                if(HTML == 1) {
                    fprintf(stream, "&lt;-");
                } else {
                    printf("<-");
                }
            } else if(((counter >= src) && (counter < dst)) || ((counter < src) && (counter > dst))) {
                fprintf(stream, "--");
            } else if(counter != max_counter - 1) {
                fprintf(stream, "  ");
            }

            counter++;
        }
    } else {
        if((src != -1) || (dst != -1)) {
            if(src == -1) {
                fprintf(stream, "( )");
            } else {
                if((HTML == 1) && (READ_DEFINE == 1) && (mac_color[print_to_mac[src]] > 0)) {
                    fprintf(stream, "<FONT COLOR=\"#%06x\">", mac_color[print_to_mac[src]]);
                }

                if(src < 26) {
                    fprintf(stream, "(%c)", 'a' + src);
                } else if((src >= 26) && (src < 52)) {
                    fprintf(stream, "(%c)", 'A' + src - 26);
                } else {
                    fprintf(stream, "(?)");
                }

                if((HTML == 1) && (READ_DEFINE == 1) && (mac_color[print_to_mac[src]] > 0)) {
                    fprintf(stream, "</FONT>");
                }
            }

            if(HTML == 1) {
                fprintf(stream, "-&gt;");
            } else {
                fprintf(stream, "->");
            }

            if(dst == -1) {
                fprintf(stream, "( )");
            } else {
                if((HTML == 1) && (READ_DEFINE == 1) && (mac_color[print_to_mac[dst]] > 0)) {
                    fprintf(stream, "<FONT COLOR=\"#%06x\">", mac_color[print_to_mac[dst]]);
                }

                if(dst < 26) {
                    fprintf(stream, "(%c)", 'a' + dst);
                } else if((dst >= 26) && (dst < 52)) {
                    fprintf(stream, "(%c)", 'A' + dst - 26);
                } else {
                    fprintf(stream, "(?)");
                }

                if((HTML == 1) && (READ_DEFINE == 1) && (mac_color[print_to_mac[dst]] > 0)) {
                    fprintf(stream, "</FONT>");
                }
            }
        }
    }

    return;
}
