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
# RFC3327 "SIP Extension Header Field for Registering Non-Adjacent Contacts"
#
# ToDo
#  - RFC3327 
#
#=============================================================================

## DEF.VAR
@IMS_RFC3327_SyntaxRules =
(

#=========================#
#  Rule (SYNTAX_RFC3327)  #
#=========================#


# SYNTAX Rule for RFC3327-5.1-1 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3327-5.1-1',
    'CA' => 'Supported',
    'ET' => 'warning',
    'OK' => 'The UA SHOULD include the option tag "path" as a header field value in all Supported header fields.',
    'NG' => 'The UA SHOULD include the option tag "path" as a header field value in all Supported header fields.',
    'EX' => \q{grep{$_ =~ /(?:^|,|\s)path(?:$|,|\s)/} (@{CtFlGet('INET,#SIP,HD,#Supported,option',@_[0],'T')})},
},


# SYNTAX Rule for RFC3327-5.1-2 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3327-5.1-2',
    'CA' => 'Supported',
    'ET' => 'warning',
    'OK' => 'The UA SHOULD include a Supported header field in all requests.',
    'NG' => 'The UA SHOULD include a Supported header field in all requests.',
    'EX' => \\q{INET,#SIP,HD,#Supported},
},

# 
# SYNTAX Rule for RFC3327-6.1-1 ()
# 
# 
#{
#    'TY' => 'SYNTAX',
#    'ID' => 'S.RFC3327-6.1-1',
#    'CA' => 'Security',
#    'ET' => 'warning',
#    'OK' => 'Systems using the Path mechanism SHOULD use appropriate mechanisms to provide message integrity and mutual authentication.',
#    'NG' => 'Systems using the Path mechanism SHOULD use appropriate mechanisms to provide message integrity and mutual authentication.',
#    'EX' => \\q{INET,#ESP},
#},


);

1;

