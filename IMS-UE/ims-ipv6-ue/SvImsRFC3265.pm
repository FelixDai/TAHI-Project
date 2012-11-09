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

#=================================================================
#
# RFC3265 "Security Mechanism Agreement for SIP" (Section ALL)
#
# ToDo
#  - RFC3265 
#
#=================================================================

## DEF.VAR
@IMS_RFC3265_SyntaxRules =
(

#=======================#
#    Rule (RFC3265)     # 
#=======================#

### Judgment rule for 'Expires'
###(Basis for a determination : RFC3265-3.1-1)
###   written by suyama (2007.1.17)
### 
### 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3265-3.1-1',
	'CA' => 'Expires',
	'ET' => 'warning',
	'PR' => \q{(CtFlv('SL,method',@_) eq 'SUBSCRIBE')},
	'OK' => 'The SUBSCRIBE requests SHOULD contain an "Expires" header.',
	'NG' => 'The SUBSCRIBE requests SHOULD contain an "Expires" header.',
        'EX' =>  \\q{INET,#SIP,HD,#Expires},
},

### Judgment rule for 'Event'
###(Basis for a determination : RFC3265-3.1-4)
###   written by suyama (2007.1.17)
### 
### 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3265-3.1-4',
	'CA' => 'Event',
	'ET' => 'error',
	'PR' => \q{(CtFlv('SL,method',@_) eq 'SUBSCRIBE')},
	'OK' => 'Subscribers MUST include exactly one "Event" header in SUBSCRIBE requests, indicating to which event or class of events they are subscribing.',
	'NG' => 'Subscribers MUST include exactly one "Event" header in SUBSCRIBE requests, indicating to which event or class of events they are subscribing.',
        'EX' =>  \\q{INET,#SIP,HD,#Event},
},

### Judgment rule for 'Retry-After'
###(Basis for a determination : TS3265-3.2-21)
### written by suyama (09/2/16 suyama)
### 
### 
{
    'TY'=> 'SYNTAX', 
    'ID'=> 'S.RFC3265-3.2-21', 
    'CA'=> 'Message', 
    'ET'=> 'warning',
    'OK'=> 'The client SHOULD NOT attempt re-subscription until after the number of seconds specified by the "retry-after" parameter.',
    'NG'=> 'The client SHOULD NOT attempt re-subscription until after the number of seconds specified by the "retry-after" parameter.'
},

### 
{
    'TY'=> 'SYNTAX', 
    'ID'=> 'S.RFC3265-3.2-22', 
    'CA'=> 'Message', 
    'ET'=> 'warning',
    'OK'=> 'The subscriber SHOULD retry immediately with a new subscription when the reason code indicates "deactivated".',
    'NG'=> 'The subscriber SHOULD retry immediately with a new subscription when the reason code indicates "deactivated".'
},

### Judgment rule for 'Allow-Events'
###(Basis for a determination : RFC3265-3.3-5)
###   written by murata (2008.1.17)
### 
### 
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3265-3.3-5',
        'CA' => 'Allow-Events',
        'ET' => 'warning',
#       'PR' => \q{(CtFlv('SL,method',@_) eq 'OPTIONS')},
        'OK' => 'Any node implementing one or more event packages SHOULD include an appropriate "Allow-Events" header indicating all supported events in all methods which initiate dialogs and their responses and OPTIONS responses.',
        'NG' => 'Any node implementing one or more event packages SHOULD include an appropriate "Allow-Events" header indicating all supported events in all methods which initiate dialogs and their responses and OPTIONS responses.',
        'EX' => \q{CtUtIsMember('reg',CtFlv('HD,#Allow-Events,eventtype',@_),@_)},
},

### 
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3265-7.2-2',
        'CA' => 'Event',
        'ET' => 'error',
        'OK' => 'There MUST be exactly one event type listed per event header.',
        'NG' => 'There MUST be exactly one event type listed per event header.',
        'EX' =>  \\q{INET,#SIP,HD,#Event,eventtype},
},

);

1;







