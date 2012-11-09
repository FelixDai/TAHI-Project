#
# Copyright (C) IPv6 Promotion Council,
# NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT),
# Yokogwa Electoric Corporation, 
# and NTT Advanced Technology Corporation(NTT-AT) All rights reserved.
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

PREFIX		= /usr/local/v6eval
INSTALL_DIR	= $(PREFIX)/ct-sip-ipv6-ua/sip-ipv6-ua
CATEGORY_DIR	= regist session transaction m_dialog auth header routing request response dialog options dns transport icmp 
FILES		= *.def INDEX* *.html config.*

all:

install:
	install -d -o bin -g bin -m 755 $(INSTALL_DIR)
	@for subdir in ${CATEGORY_DIR}; do \
		install -d -o bin -g bin -m 755 $(INSTALL_DIR)/UA/$$subdir; \
	done
	@for subdir in ${CATEGORY_DIR}; do \
		install -c -o bin -g bin -m 555 UA/$$subdir/*.seq  $(INSTALL_DIR)/UA/$$subdir; \
		install -c -o bin -g bin -m 444 UA/$$subdir/*.html $(INSTALL_DIR)/UA/$$subdir; \
	done
	install -d -o bin -g bin -m 755 $(INSTALL_DIR)/UA/generic; \
	install -d -o bin -g bin -m 755 $(INSTALL_DIR)/UA/connect_check; \
	install -c -o bin -g bin -m 444 UA/generic/*.html $(INSTALL_DIR)/UA/generic; \
	install -c -o bin -g bin -m 555 UA/connect_check/*.seq  $(INSTALL_DIR)/UA/connect_check; \
	install -c -o bin -g bin -m 555 *.pm          $(INSTALL_DIR)
	install -c -o bin -g bin -m 555 *.pl          $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 *.wav          $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 $(FILES)      $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 Makefile.test $(INSTALL_DIR)/Makefile

.include "Makefile.test"
