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
# RFC2617 "HTTP Authentication: Basic and Digest Access Authentication"
#
# ToDo
#  - RFC2617 
#
#=============================================================================

## DEF.VAR
@IMS_RFC2617_SyntaxRules =
(

#=========================#
#  Rule (SYNTAX_RFC2617)  #
#=========================#

# SYNTAX Rule for RFC2617-3-4 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC2617-3-4',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop', CtUtLastSndMsg())},
    'OK' => \\'The qop value(%s) MUST be one of the alternatives(%s) the server indicated it supports in the WWW-Authenticate header, if present.',
    'NG' => \\'The qop value(%s) MUST be one of the alternatives(%s) the server indicated it supports in the WWW-Authenticate header, if present.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,qop', @_),
                      CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop', CtUtLastSndMsg()),@_)},
},

# SYNTAX Rule for RFC2617-3-5 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC2617-3-5',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop', CtUtLastSndMsg())},
    'OK' => 'The qop SHOULD be used if the server indicated that qop is supported by providing a qop directive in the WWW-Authenticate header field.',
    'NG' => 'The qop SHOULD be used if the server indicated that qop is supported by providing a qop directive in the WWW-Authenticate header field.',
    'EX' => \q{CtFlv('HD,#Authorization,credentials,credential,digestresp,list,qop', @_) &&
               CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop', CtUtLastSndMsg())},
},

# SYNTAX Rule for RFC2617-3-6 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC2617-3-6',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop', CtUtLastSndMsg())},
    'OK' => 'The cnonce MUST be specified if a qop directive is sent a qop directive in the WWW-Authenticate header field.',
    'NG' => 'The cnonce MUST be specified if a qop directive is sent a qop directive in the WWW-Authenticate header field.',
    'EX' => \q{CtFlv('HD,#Authorization,credentials,credential,digestresp,list,cnonce', @_)},
},

# SYNTAX Rule for RFC2617-3-7 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC2617-3-7',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{!CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop', CtUtLastSndMsg())},
    'OK' => 'The cnonce MUST NOT be specified if the server did not send a qop directive in the WWW-Authenticate header field.',
    'NG' => 'The cnonce MUST NOT be specified if the server did not send a qop directive in the WWW-Authenticate header field.',
    'EX' => \q{!CtFlv('HD,#Authorization,credentials,credential,digestresp,list,cnonce', @_)},
},

# SYNTAX Rule for RFC2617-3-8 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC2617-3-8',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop', CtUtLastSndMsg())},
    'OK' => 'The nonce-count MUST be specified if a qop directive is sent a qop directive in the WWW-Authenticate header field.',
    'NG' => 'The nonce-count MUST be specified if a qop directive is sent a qop directive in the WWW-Authenticate header field.',
    'EX' => \q{CtFlv('HD,#Authorization,credentials,credential,digestresp,list,nc', @_)},
},

# SYNTAX Rule for RFC2617-3-9 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC2617-3-9',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{!CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop', CtUtLastSndMsg())},
    'OK' => 'The nonce-count MUST NOT be specified if the server did not send a qop directive in the WWW-Authenticate header field.',
    'NG' => 'The nonce-count MUST NOT be specified if the server did not send a qop directive in the WWW-Authenticate header field.',
    'EX' => \q{CtFlv('HD,#Authorization,credentials,credential,digestresp,list,nc', @_) eq ''},
},

);

1;
