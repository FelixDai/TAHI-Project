#
# Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009
# Yokogawa Electric Corporation.
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
# $Id: Makefile,v 1.6 2010/03/30 01:05:45 doo Exp $
#
################################################################



DEBUG=	true



TITLE_EN_I=	'IPv6 Conformance Test for IKEv2<BR>(End Node - Initiator)'
TITLE_EN_R=	'IPv6 Conformance Test for IKEv2<BR>(End Node - Responder)'
TITLE_SGW_I=	'IPv6 Conformance Test for IKEv2<BR>(Security Gateway - Initiator)'
TITLE_SGW_R=	'IPv6 Conformance Test for IKEv2<BR>(Security Gateway - Responder)'
TITLE_EN=	'IPv6 Conformance Test for IKEv2<BR>(End Node)'
TITLE_SGW=	'IPv6 Conformance Test for IKEv2<BR>(Security Gateway)'
TITLE=	'IPv6 Conformance Test for IKEv2'



INDEX_EN_I=	INDEX_EN_I
INDEX_EN_R=	INDEX_EN_R
INDEX_SGW_I=	INDEX_SGW_I
INDEX_SGW_R=	INDEX_SGW_R
INDEX_EN=	${INDEX_EN_I} ${INDEX_EN_R}
INDEX_SGW=	${INDEX_SGW_I} ${INDEX_SGW_R}
INDEX=	${INDEX_EN} ${INDEX_SGW}



PERL=	/usr/bin/perl
AUTORUN=	/usr/local/koi/bin/autorun



CLEAN=	index.html report.html summary.html [0-9]*.html *.dump *.pcap pod2htmd.tmp pod2htmi.tmp

.if defined(DEBUG)
CLEAN+= */*.html
.endif



clean:
	@( rm -f ${CLEAN} )



document:
	${AUTORUN} -profile -nofooter -title=${TITLE} ${INDEX}

document_enode:
	${AUTORUN} -profile -nofooter -title=${TITLE_EN} ${INDEX_EN}

document_enode_initiator:
	${AUTORUN} -profile -nofooter -title=${TITLE_EN_I} ${INDEX_EN_I}

document_enode_responder:
	${AUTORUN} -profile -nofooter -title=${TITLE_EN_R} ${INDEX_EN_R}

document_sgw:
	${AUTORUN} -profile -nofooter -title=${TITLE_SGW} ${INDEX_SGW}

document_sgw_initiator:
	${AUTORUN} -profile -nofooter -title=${TITLE_SGW_I} ${INDEX_SGW_I}

document_sgw_responder:
	${AUTORUN} -profile -nofooter -title=${TITLE_SGW_R} ${INDEX_SGW_R}



test: document
	@( rm -f index.html report.html summary.html )
	${AUTORUN} ${AROPT} -F -tiny -title=${TITLE} ${INDEX}

test_enode: document_enode
	@( rm -f index.html report.html summary.html )
	${AUTORUN} ${AROPT} -F -tiny -title=${TITLE_EN} ${INDEX_EN}

test_enode_initiator: document_enode_initiator
	@( rm -f index.html report.html summary.html )
	${AUTORUN} ${AROPT} -F -tiny -title=${TITLE_EN_I} ${INDEX_EN_I}

test_enode_responder: document_enode_responder
	@( rm -f index.html report.html summary.html )
	${AUTORUN} ${AROPT} -F -tiny -title=${TITLE_EN_R} ${INDEX_EN_R}

test_sgw: document_sgw
	@( rm -f index.html report.html summary.html )
	${AUTORUN} ${AROPT} -F -tiny -title=${TITLE_SGW} ${INDEX_SGW}

test_sgw_initiator: document_sgw_initiator
	@( rm -f index.html report.html summary.html )
	${AUTORUN} ${AROPT} -F -tiny -title=${TITLE_SGW_I} ${INDEX_SGW_I}

test_sgw_responder: document_sgw_responder
	@( rm -f index.html report.html summary.html )
	${AUTORUN} ${AROPT} -F -tiny -title=${TITLE_SGW_R} ${INDEX_SGW_R}

certificate:
	cd cert && sh ./MakeCert.sh

