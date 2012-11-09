#!/usr/bin/perl

# Copyright(C) IPv6 Promotion Council (2004-2010). All Rights Reserved.
# 
# This documentation is produced by SIP SWG members of Certification WG in 
# IPv6 Promotion Council.
# The SWG members currently include NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT), 
# Yokogawa Electric Corporation and NTT Advanced Technology Corporation (NTT-AT).
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

#=============================================================================
#
# RFC3455 "Private Header (P-Header) Extensions to the SIP
#          for the 3rd-Generation Partnership Project (3GPP)"
#
# ToDo
#  - RFC3455 
#
#=============================================================================

## DEF.VAR
@IMS_RFC3455_SyntaxRules =
(

#=========================#
#  Rule (SYNTAX_RFC3455)  #
#=========================#


# SYNTAX Rule for RFC3455-4.2-1 (P-Called-Party-ID)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3455-4.2-1',
    'CA' => 'P-Called-Party-ID',
    'ET' => 'error',
    'OK' => 'A UAC MUST NOT insert a P-Called-Party-ID header field in any SIP request or response.',
    'NG' => 'A UAC MUST NOT insert a P-Called-Party-ID header field in any SIP request or response.',
    'EX' => \q{CtUtEq(CtFlv('HD,#P-Called-Party-ID,tag',@_),'',@_)},
},


# SYNTAX Rule for RFC3455-6.4-2 (P-Access-Network-Info)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3455-6.4-2',
    'CA' => 'P-Access-Network-Info',
    'ET' => 'warning',
    'PR' => \q{(CtFlv('SL,method',@_) eq 'REGISTER') &&
	       (CtUtEq(CtFlGet('INET,#UDP,SrcPort',@_),CtTbCfg(CtTbPrm('CI,target,TARGET'),'sip-port'),@_))},
    'OK' => '3GPP UA SHOULD NOT send P-Access-Network-Info header in any initial unauthenticated and unprotected request.',
    'NG' => '3GPP UA SHOULD NOT send P-Access-Network-Info header in any initial unauthenticated and unprotected request.',
    'EX' => \q{CtUtEq(CtFlv('HD,#P-Access-Network-Info,tag',@_),'',@_)},
},

);

1;






