#
# $Name: CE-Router_Self_Test_1_0_5 $
#
# Copyright (C) 2013
# Chunghwa Telecommunication Labratories (CHT-TL)
# All rights reserved.
# 
# Redistribution and use of this software in source and binary
# forms, with or without modification, are permitted provided that
# the following conditions and disclaimer are agreed and accepted
# by the user:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with
#    the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project
#    which is related to this software (hereinafter referred to as
#    "project") nor the names of the contributors may be used to
#    endorse or promote products derived from this software without
#    specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written
#    notification to the copyrighters.
# 
# 5. The copyrighters, the project and the contributors may prohibit
#    the use of this software at any time.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# $CHT-TL: Makefile,v 1.0 2013/06/30 weifen Exp $
#
################################################################

PERL    = /usr/bin/perl
POD2HTML= -$(PERL) -e 'use Pod::Html; pod2html("--noindex", @ARGV);'
RM      = /bin/rm

TITLE_CPE	= 'WAN-RFC7084'

INDEX_CPE	= INDEX_p2_cpe


#------------------------------#
# cpe	                       #
#------------------------------#
document_ipv6ready_p2_ce:
	$(AUTORUN) -profile $(INDEX_CPE) -title=$(TITLE_CPE)
        
ipv6ready_p2_ce: document_ipv6ready_p2_ce
	-$(RM) -f CPE6_test_pkt.def index.html summary.html report.html DHCPv6_test_pkt.def
	chmod +x *.seq
	touch CPE6_test_pkt.def DHCPv6_test_pkt.def
	$(AUTORUN) $(AROPT) -F -tiny -title=$(TITLE_CPE) $(INDEX_CPE)


clean:
	-$(RM) -f *.pcap *.dump *.log [0-9]*.html index.html report.html summary.html CPE6_test_pkt.def DHCPv6_test_pkt.def

.include "../Makefile.inc"

