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
 * $Id: usage.c,v 1.1.2.1 2001/02/07 12:43:46 endo Exp $
 */

#include "general.h"

  /**********************/
 /**  usage function  **/
/**********************/

int
usage()
{
    (void)fprintf(stderr, "usage: %s (-i interface | -r dump_file) [-w file] [-46bhRvV]\n",PROG);
    exit(1);
}

  /*********************/
 /**  help function  **/
/*********************/

int
help()
{
    printf ("**************************************************************************\n");
    printf ("***                          usage of %s                           ***\n",PROG);
    printf ("**************************************************************************\n");
    printf ("\n");
    printf ("Input  :\n");
    printf ("-i interface               Specify to listen on interface. If unspecified,\n");
    printf ("                           rpdump searches the system interface list for\n");
    printf ("                           the lowest numbered, configured up interface\n");
    printf ("                           (excluding loop-back).\n");
    printf ("-r file                    Read packets from dump_file which was created\n");
    printf ("                           by tcpdump with -w option.\n");
    printf ("\n");
    printf ("Show   :\n");
    printf ("-4                         Show only IPv4 packets. If you use this option\n");
    printf ("                           with option \"-6\" then all packets are shown.\n");
    printf ("-6                         Show only IPv6 packets. If you use this option\n");
    printf ("                           with option \"-4\" then all packets are shown.\n");
    printf ("-b                         Show only BGP4(+). If you use this option\n");
    printf ("                           with option \"-r\" then all packets are shown.\n");
    printf ("-k                         Don't show BGP KEEPALIVE.\n");
    printf ("-h                         This screen.\n");
    printf ("-n                         Don't convert port numbers to names.\n");
    printf ("-R                         Show only RIP(ng). If you use this option\n");
    printf ("                           with option \"-b\" then all packets are shown.\n");
    printf ("-v                         Show verbose mode.\n");
    printf ("-V                         Show version.\n");

    exit(0);
}

  /***********************/
 /** version function  **/
/***********************/

int
version()
{
    printf("%s: version %s\n", PROG, VERSION);
    exit(0);
}
