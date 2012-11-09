#!/bin/sh
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
# $TAHI: ct-ikev2/cert/MakeCert.sh,v 1.1 2008/10/20 11:08:07 doo Exp $
#
################################################################

mkdir ./demoCA/
mkdir ./demoCA/certs
mkdir ./demoCA/crl
mkdir ./demoCA/newcerts
mkdir ./demoCA/private
echo "01" > ./demoCA/serial
echo "01" > ./demoCA/crlnumber
touch ./demoCA/index.txt

cp /etc/ssl/openssl.cnf ./openssl.nut.cnf
vi openssl.nut.cnf
cp /etc/ssl/openssl.cnf ./openssl.tn.cnf
vi openssl.tn.cnf
#
#           If the following parametor is not included openssl.cnf,
#           please add it after [ CA_default ] section.
#
#           42c42
#           < #unique_subject       = no  # Set to 'no' to allow creation of
#           ---
#           > unique_subject        = yes # Set to 'no' to allow creation of

#==========#
# CA       #
#==========#
echo ""
echo "===> enter CA phase"
echo "> openssl req -config openssl.nut.cnf -new -x509 -newkey rsa:1024 -sha1 \\"
echo "		-keyform PEM -keyout ./demoCA/private/cakey.pem \\"
echo "		-outform PEM -out ./demoCA/cacert.pem \\"
echo "		-days 365"
echo ""
openssl req -config openssl.nut.cnf -new -x509 -newkey rsa:1024 -sha1 \
		-keyform PEM -keyout ./demoCA/private/cakey.pem \
		-outform PEM -out ./demoCA/cacert.pem \
		-days 365

cp -p ./demoCA/cacert.pem `openssl x509 -noout -hash -in ./demoCA/cacert.pem`.0

openssl ca -config openssl.nut.cnf -gencrl \
		-out `openssl x509 -noout -hash -in ./demoCA/cacert.pem`.r0
echo "===> leave CA phase"


#==========#
# NUT      #
#==========#
echo ""
echo "===> enter NUT phase"
openssl req -config openssl.nut.cnf -new -nodes -newkey rsa:1024 -sha1 \
		-keyform PEM -keyout NUTprivkey.pem \
		-outform PEM -out NUTrequest.pem \
		-days 365

chmod 0600 NUTprivkey.pem

openssl ca -config openssl.nut.cnf -policy policy_anything \
		-in NUTrequest.pem -out NUTcert.pem
echo "===> leave NUT phase"


#==========#
# TN       #
#==========#
echo ""
echo "===> enter TN phase"
openssl req -config openssl.tn.cnf -new -nodes -newkey rsa:1024 -sha1 \
		-keyform PEM -keyout TNprivkey.pem \
		-outform PEM -out TNrequest.pem \
		-days 365

chmod 0600 TNprivkey.pem

openssl ca -config openssl.tn.cnf -policy policy_anything \
		-in TNrequest.pem -out TNcert.pem
echo "===> leave TN phase"


#==============================================#
# Convert a certificate from PEM to DER format #
#==============================================#
echo ""
echo "===> enter convert phase"
openssl x509 -in TNcert.pem -inform PEM -out TNcert.der -outform DER
openssl x509 -in NUTcert.pem -inform PEM -out NUTcert.der -outform DER
openssl x509 -in ./demoCA/cacert.pem -inform PEM -out ./demoCA/cacert.der -outform DER

#Convert a private key from PEM to DER format
openssl rsa -in TNprivkey.pem  -outform DER -out TNprivkey.der
openssl rsa -in NUTprivkey.pem  -outform DER -out NUTprivkey.der
echo "===> leave convert phase"

