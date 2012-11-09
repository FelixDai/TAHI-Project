#!/bin/sh
#
# Copyright (C) 2002 Yokogawa Electric Corporation , 
# INTAP(Interoperability Technology Association for Information 
# Processing, Japan) , IPA (Information-technology Promotion Agency,Japan)
# All rights reserved.
# 
# 
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

cd /dev
mknod tiny0 c 75 0
ln tiny0 tiny_nbrcache
mknod tiny1 c 75 1
ln tiny1 tiny_ipsec
chmod 600 tiny1
mknod tiny2 c 75 2
ln tiny2 tiny_defrouter
mknod tiny3 c 75 3
ln tiny3 tiny_prefix
mknod tiny4 c 75 4
ln tiny4 tiny_physifaddr
mknod tiny5 c 75 5
ln tiny5 tiny_buffer_stat
