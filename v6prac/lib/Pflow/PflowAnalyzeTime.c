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
#include <string.h>
#include <stdlib.h>
#include "PflowFlow.h"

extern struct packets *pkt;

int analyze_time(char *line, int counter) {
    char *token;

    if((line[0] == 'l') &&
       (line[1] == 'o') &&
       (line[2] == 'g') &&
       (line[3] == ':') &&
      ((line[4] >= '0') && (line[4] <= '9')) &&
      ((line[5] >= '0') && (line[5] <= '9')) &&
      ((line[6] >= '0') && (line[6] <= '9')) &&
      ((line[7] >= '0') && (line[7] <= '9')) &&
       (line[8] == '/')) {
        if(pkt == NULL) {
            pkt = (struct packets *)malloc(sizeof(struct packets));
            if(pkt == NULL) {
                perror("malloc");
                exit(1);
            }
        } else {
            pkt = (struct packets *)realloc(pkt, sizeof(struct packets) * (counter + 1));
            if(pkt == NULL) {
                perror("realloc");
                exit(1);
            }
        }

        token = strtok(line, " ");
        token = strtok(NULL, "\n");
        strcpy(pkt[counter].pkt_time, token);
        return(1);
    } else {
        return(0);
    }
}
