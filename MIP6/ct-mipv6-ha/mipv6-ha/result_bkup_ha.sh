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
	echo "usage: result_bkup.sh <target name>"
	echo "       <target name>: link a TargetName in nut.def"
	echo ""
	echo "example: result_bkup.sh kame-snap"
	exit 1
fi

# directory
CUR_DIR="${1}_"`date +20%y%m%d%H%M%S`
RESULT_DIR="RESULT/${CUR_DIR}"

# make the directory
if test -d "${RESULT_DIR}"
then
	echo "${RESULT_DIR} is exist."
	exit 1
fi

mkdir -p ${RESULT_DIR}

# analyzer
# analyzer.pl > /dev/null

# backup
cp -p *.txt         ${RESULT_DIR}
cp -p *.def         ${RESULT_DIR}
rm ${RESULT_DIR}/HA_*.def
cp -p *.dump        ${RESULT_DIR}
cp -p index.html    ${RESULT_DIR}
cp -p summary.html  ${RESULT_DIR}
cp -p report.html   ${RESULT_DIR}
cp -p [1-9]*.html   ${RESULT_DIR}
# cp -p analysis.html ${RESULT_DIR}

# html
REPORT_HTML="${RESULT_DIR}/report_parts.html"
# ANALYSIS_HTML="${RESULT_DIR}/analysis_parts.html"

# .html border
REPORT_BORDER="<TR><TD><BR></TD><TD><B> ${CUR_DIR} </B></TD><TD><BR></TD><TD><BR></TD><TD><BR></TD><TD><BR></TD><TD><BR></TD></TR>"

# ANALYSIS_BORDER="<TR><TD><BR></TD><TD><B> ${CUR_DIR} </B></TD><TD><BR></TD><TD><BR></TD><TD><BR></TD><TD><BR></TD></TR>"

echo "${REPORT_BORDER}"   > ${REPORT_HTML}
# echo "${ANALYSIS_BORDER}" > ${ANALYSIS_HTML}

# terget test
grep -H -a "CommandLine" `ls [1-9]*.html | sort -n` | cut -f3 -d/ | cut -f1 -d. > no.tmp

# gather tests
while read TESTNO
do
	if test "${TESTNO}" = ""
	then
		countinue
	fi
	HTML="${TESTNO}.html"
	DEF="${TESTNO}.def"
	echo "${HTML}"
	cp -p ${HTML} ${RESULT_DIR}
	cp -p ${DEF} ${RESULT_DIR}
	grep -a ${HTML} report.html   >> ${REPORT_HTML}
#	grep -a ${HTML} analysis.html >> ${ANALYSIS_HTML}
done < no.tmp

# update html
ex -s ${REPORT_HTML} <<_END
:%s/HREF="\.\//HREF="/g
:%s/HREF="/HREF="${CUR_DIR}\//g
:wq
_END

# ex -s ${ANALYSIS_HTML} <<_END
# :%s/HREF="\.\//HREF="/g
# :%s/HREF="/HREF="${CUR_DIR}\//g
# :wq
# _END

# End of file
