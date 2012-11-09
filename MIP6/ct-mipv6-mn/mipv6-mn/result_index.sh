#!/bin/sh
#
# Copyright (C) IPv6 Promotion Council,
# NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT),
# Yokogwa Electoric Corporation, YASKAWA INFORMATION SYSTEMS Corporation
# and NTT Advanced Technology Corporation(NTT-AT) All rights reserved.
# 
# Technology Corporation.
# 
# Redistribution and use of this software in source and binary forms, with 
# or without modification, are permitted provided that the following 
# conditions and disclaimer are agreed and accepted by the user:
# 
# 1. Redistributions of source code must retain the above copyright 
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright 
# notice, this list of conditions and the following disclaimer in the 
# documentation and/or other materials provided with the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project which 
# is related to this software (hereinafter referred to as "project") nor 
# the names of the contributors may be used to endorse or promote products 
# derived from this software without specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written 
# notification to the copyrighters. However, using this software for the 
# purpose of testing or evaluating any products including merchantable 
# products may be permitted without any notification to the copyrighters.
# 
# 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING 
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE 
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT,STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
# THE POSSIBILITY OF SUCH DAMAGE.
#
########################################################################
#
#set -x
#

# command
if test "$1" = ""
then
	echo "usage: result_index.sh <target name>"
	echo "       <target name>: link a TargetName in nut.def"
	echo ""
	echo "example: result_index.sh kame-snap"
	exit 1
fi

# html
REPORT_HTML="RESULT/${1}_report.html"
ANALYSIS_HTML="RESULT/${1}_analysis.html"

# .html header
REPORT_HEAD='<HTML>
<HEAD>
<TITLE>Conformance Test for Mobile Node merge</TITLE>
<META NAME="GENERATOR" CONTENT="TAHI IPv6 Conformance Test Suite">
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER><TABLE BORDER=1>
<TR BGCOLOR="#CCCCCC">
<TH>No.</TH><TH>Title</TH><TH>Result</TH><TH>Log</TH><TH>Script</TH><TH>Packet</TH><TH>Dump<BR>(bin)</TH></TR>'

ANALYSIS_HEAD='<HTML>
<HEAD>
<TITLE>IPv6 Test Commentaries merge</TITLE>
<META NAME="GENERATOR" CONTENT="TAHI IPv6 Conformance Test Suite">
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER><TABLE BORDER=1>
<TR BGCOLOR="#CCCCCC">
<TH>No.</TH><TH>Title</TH><TH>Result</TH><TH>Log</TH><TH>Script</TH><TH>Comments</TH></TR>'

echo "${REPORT_HEAD}"   > ${REPORT_HTML}
echo "${ANALYSIS_HEAD}" > ${ANALYSIS_HTML}

# target directory
ls -d RESULT/*/ | grep "RESULT/${1}" > dir.tmp

# merge .html
while read DIR
do
	cat ${DIR}report_parts.html   >> ${REPORT_HTML}
	cat ${DIR}analysis_parts.html >> ${ANALYSIS_HTML}
done < dir.tmp

# End of file
