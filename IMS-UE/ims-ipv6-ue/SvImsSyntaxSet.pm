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

## DEF.VAR
@IMS_SyntaxRuleset =
(

#######################################################
###                 Ruleset (SYNTAX)                ###
#######################################################
################################################
###                < Request >               ###
################################################

{
    'TY'=>'PROGN',
    'ID'=>'SS.Generic_SIP_Message',
    'EX'=>[
	'S.RFC3261-7-1',
	'S.RFC3261-7.1-3',
	'S.RFC3261-7.1-4',
	'S.RFC3261-20.14-1',
	'S.RFC3261-20.20-2',
	],
},#SS.Generic_SIP_Message

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.REGISTER',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-7.3-3',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-7',
	'S.RFC3261-8.1-9',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
#	'S.RFC3261-8.1-30',
	'S.RFC3261-10.2-4',
	'S.RFC3261-10.2-5',
	'S.RFC3261-10.2-9',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.10-1',
	'S.RFC3261-20.14-3',
	'S.RFC3327-5.1-1',
	'S.RFC3327-5.1-2',
	{'TY'=>'SW','S.RFC3329-2.3-2'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-4'=>'#auth-scheme:aka'},
	'S.RFC3455-4.2-1',
	'S.RFC3455-6.4-2',
	{'TY'=>'SW','S.TS24229-5.1-9'=>'#auth-scheme:sipdigest'},     #Digest
	'S.TS24229-5.1-31',
	'S.TS24229-5.1-32',
	'S.TS24229-5.1-33',
	'S.TS24229-5.1-37',
	'S.TS24229-5.1-40',
	'S.TS24229-5.1-41',
	'S.TS24229-5.1-42',
	{'TY'=>'SW','S.TS24229-5.1-69'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-70'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-71'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-72'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-73'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-74'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-75'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-76'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-93'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-94'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-95'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-96'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-97'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-98'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-99'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-100'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS33203-7.2-1'=>'#auth-scheme:aka'},     #AKA
	],
},#SS.Request.REGISTER

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.Auth_REGISTER',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-7.3-3',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-7',
	'S.RFC3261-8.1-9',
	'S.RFC3261-8.1-11',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
#	'S.RFC3261-8.1-30',
	'S.RFC3261-8.1-62',
	'S.RFC3261-10.2-4',
	'S.RFC3261-10.2-5',
	'S.RFC3261-10.2-6',
	'S.RFC3261-10.2-7',
	'S.RFC3261-10.2-9',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.10-1',
	'S.RFC3261-20.14-3',
	'S.RFC3261-21.4-1',
	{'TY'=>'SW','S.RFC3261-22.4-20'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.RFC3261-22.4-23'=>'#auth-scheme:sipdigest'},     #Digest
	'S.RFC3327-5.1-1',
	'S.RFC3327-5.1-2',
	{'TY'=>'SW','S.RFC3329-2.3-2'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-4'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-14'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-15'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-16'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-5-1'=>'#auth-scheme:aka'},     #AKA
	'S.RFC3455-4.2-1',
	{'TY'=>'SW','S.RFC2617-3-4'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.RFC2617-3-5'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.RFC2617-3-6'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.RFC2617-3-7'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.RFC2617-3-8'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.RFC2617-3-9'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-221'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-222'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-223'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-225'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-226'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-227'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-228'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-229'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-230'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-231'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-232'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-233'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-234'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-235'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-256'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-257'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-258'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-259'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS33203-7.2-9'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS33203-7.4-18'=>'#auth-scheme:aka'},     #AKA
	],
},#SS.Request.Auth_REGISTER

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.Re_REGISTER',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-7.3-3',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-7',
	'S.RFC3261-8.1-9',
	'S.RFC3261-8.1-11',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
#	'S.RFC3261-8.1-30',
	'S.RFC3261-10.2-4',
	'S.RFC3261-10.2-5',
	'S.RFC3261-10.2-6',
	'S.RFC3261-10.2-7',
	'S.RFC3261-10.2-9',
	'S.RFC3261-10.2-15',
	'S.RFC3261-10.2-16',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.10-1',
	'S.RFC3261-20.14-3',
	'S.RFC3327-5.1-1',
	'S.RFC3327-5.1-2',
	{'TY'=>'SW','S.RFC3329-2.3-2'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-4'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-14'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-15'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-16'=>'#auth-scheme:aka'},     #AKA
	'S.RFC3455-4.2-1',
	{'TY'=>'SW','S.TS24229-5.1-153'=>'#auth-scheme:aka'},     #AKA
	'S.TS24229-5.1-155',
	'S.TS24229-5.1-156',
	'S.TS24229-5.1-157',
	'S.TS24229-5.1-160',
	'S.TS24229-5.1-161',
	'S.TS24229-5.1-162',
	'S.TS24229-5.1-163',
	{'TY'=>'SW','S.TS24229-5.1-183'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-184'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-185'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-186'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-187'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-188'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-189'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-190'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-191'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-193'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-194'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-195'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-196'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-197'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-198'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-199'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-259'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS33203-7.2-1'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS33203-7.3-8'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS33203-7.4-3'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS33203-7.4-12'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS33203-7.4-14'=>'#auth-scheme:aka'},     #AKA
	],
},#SS.Request.Re_REGISTER

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.De_REGISTER',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-7.3-3',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-7',
	'S.RFC3261-8.1-9',
	'S.RFC3261-8.1-11',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
#	'S.RFC3261-8.1-30',
	'S.RFC3261-10.2-4',
	'S.RFC3261-10.2-5',
	'S.RFC3261-10.2-6',
	'S.RFC3261-10.2-7',
	'S.RFC3261-10.2-9',
	'S.RFC3261-10.2-13',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.10-1',
	'S.RFC3261-20.14-3',
	'S.RFC3327-5.1-1',
	'S.RFC3327-5.1-2',
	{'TY'=>'SW','S.RFC3329-2.3-14'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-15'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-16'=>'#auth-scheme:aka'},
	{'TY'=>'SW','S.RFC3329-2.3-2'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-4'=>'#auth-scheme:aka'},
	'S.RFC3455-4.2-1',
	{'TY'=>'SW','S.TS24229-5.1-259'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-290'=>'#auth-scheme:aka'},     #AKA
	'S.TS24229-5.1-296',
	'S.TS24229-5.1-297',
	'S.TS24229-5.1-298',
	'S.TS24229-5.1-300',
	'S.TS24229-5.1-301',
	'S.TS24229-5.1-302',
	{'TY'=>'SW','S.TS24229-5.1-313'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-314'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-315'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-316'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-317'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-318'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-319'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-320'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-322'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-323'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-324'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-325'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-326'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-327'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-328'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-329'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS33203-7.2-1'=>'#auth-scheme:aka'},     #AKA
	],
},#SS.Request.De_REGISTER

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.SUBSCRIBE',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-2',
	'S.RFC3261-8.1-7',
	'S.RFC3261-8.1-9',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
	'S.RFC3261-8.1-24',
#	'S.RFC3261-8.1-30',
	'S.RFC3261-8.1-38',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.10-1',
	'S.RFC3261-20.14-3',
	'S.RFC3265-3.1-1',
	'S.RFC3265-3.1-4',
	'S.RFC3265-3.3-5',
	'S.RFC3265-7.2-2',
	{'TY'=>'SW','S.RFC3329-2.3-14'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-15'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-16'=>'#auth-scheme:aka'},
	'S.RFC3455-4.2-1',
	'S.TS24229-5.1-123',
	'S.TS24229-5.1-124',
	'S.TS24229-5.1-125',
	'S.TS24229-5.1-126',
	'S.TS24229-5.1-127',
	'S.TS24229-5.1-129',
	{'TY'=>'SW','S.TS24229-5.1-131'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-132'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-355'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-356'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-357'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-358'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-363'=>'#auth-scheme:sipdigest'},     #Digest
	'S.TS24229-5.1-378',
	{'TY'=>'SW','S.TS24229-5.1-379'=>'#auth-scheme:aka'},     #AKA
	'S.TS24229-5.1-398',
	'S.TS24229-5.1-400',
	{'TY'=>'SW','S.TS24229-5.1-402'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-403'=>'#auth-scheme:sipdigest'},     #Digest
	'S.TS24229-5.1-404',
	{'TY'=>'SW','S.TS24229-5.1-130'=>'#auth-scheme:aka'},     #AKA
	],
},#SS.Request.SUBSCRIBE

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.Re_SUBSCRIBE',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-10',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
#	'S.RFC3261-8.1-30',
	'S.RFC3261-8.1-38',
	'S.RFC3261-12.2-1',
	'S.RFC3261-12.2-2',
	'S.RFC3261-12.2-3',
	'S.RFC3261-12.2-4',
	'S.RFC3261-12.2-6',
	'S.RFC3261-12.2-7',
	'S.RFC3261-12.2-8',
	'S.RFC3261-12.2-9',
	'S.RFC3261-12.2-14',
	'S.RFC3261-12.2-15',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.10-1',
	'S.RFC3261-20.14-3',
	'S.RFC3265-3.1-1',
	'S.RFC3265-3.1-4',
	'S.RFC3265-3.3-5',
	'S.RFC3265-7.2-2',
	{'TY'=>'SW','S.RFC3329-2.3-14'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-15'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-16'=>'#auth-scheme:aka'},     #AKA
	'S.RFC3455-4.2-1',
	'S.TS24229-5.1-133',
	{'TY'=>'SW','S.TS24229-5.1-355'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-356'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-357'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-358'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-363'=>'#auth-scheme:sipdigest'},     #Digest
	'S.TS24229-5.1-386',
	],
},#SS.Request.Re_SUBSCRIBE

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Response.200_NOTIFY',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7-2',
	'S.RFC3261-8.1-10',
	'S.RFC3261-8.2-36',
	'S.RFC3261-8.2-37',
	'S.RFC3261-8.2-38',
	'S.RFC3261-8.2-39',
	'S.RFC3261-8.2-41',
	'S.RFC3261-8.2-44',
	'S.RFC3261-17.1-1',
	'S.RFC3261-18.2-13',
	'S.RFC3261-18.2-5',
	'S.RFC3261-18.2-6',
	'S.RFC3261-20.14-3',
	'S.RFC3455-4.2-1',
	],
},#SS.Response.200_NOTIFY

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.INVITE',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7.4-1',
	'S.RFC3261-7.4-3',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-2',
	'S.RFC3261-8.1-7',
	'S.RFC3261-8.1-9',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
	'S.RFC3261-8.1-24',
#	'S.RFC3261-8.1-30',
	'S.RFC3261-8.1-38',
	'S.RFC3261-13.1-1',
	'S.RFC3261-13.2-1',
	'S.RFC3261-13.2-3',
	'S.RFC3261-13.2-12',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.10-1',
	'S.RFC3261-20.15-1',
	'S.RFC3265-3.3-5',
	{'TY'=>'SW','S.RFC3329-2.3-14'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-15'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-16'=>'#auth-scheme:aka'},
	'S.RFC3455-4.2-1',
	'S.RFC4566-5.2-3',
	'S.RFC4566-5.3-1',
	'S.RFC4566-5.3-2',
	'S.RFC4566-5.3-4',
	'S.RFC4566-5.7-1',
	'S.RFC4566-5.7-7',
	'S.RFC4566-5-2',
	'S.RFC4566-5-3',
	'S.RFC4566-5-4',
	{'TY'=>'SW','S.TS24229-5.1-355'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-356'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-357'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-358'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-363'=>'#auth-scheme:sipdigest'},     #Digest
	'S.TS24229-5.1-378',
	{'TY'=>'SW','S.TS24229-5.1-379'=>'#auth-scheme:aka'},     #AKA
	'S.TS24229-5.1-398',
	'S.TS24229-5.1-400',
	{'TY'=>'SW','S.TS24229-5.1-402'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-403'=>'#auth-scheme:sipdigest'},     #Digest
	'S.TS24229-5.1-404',
	'S.TS24229-5.1-454',
	'S.TS24229-6.1-1',
	'S.TS24229-6.1-26',
	'S.TS24229-6.1-3',
	'S.TS24229-6.1-7',
	],
},#SS.Request.INVITE

######################################



{
    'TY'=>'PROGN',
    'ID'=>'SS.Response.180_INVITE',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7-2',
	'S.RFC3261-8.2-36',
	'S.RFC3261-8.2-37',
	'S.RFC3261-8.2-38',
	'S.RFC3261-8.2-39',
	'S.RFC3261-8.2-42',
	'S.RFC3261-8.2-43',
	'S.RFC3261-18.2-13',
	'S.RFC3261-18.2-5',
	'S.RFC3261-18.2-6',
	'S.RFC3261-20.14-3',
	'S.RFC3455-4.2-1',
	],
},#SS.Response.180_INVITE

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Response.200_INVITE',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.4-1',
	'S.RFC3261-7.4-3',
	'S.RFC3261-8.1-10',
	'S.RFC3261-8.2-36',
	'S.RFC3261-8.2-37',
	'S.RFC3261-8.2-38',
	'S.RFC3261-8.2-39',
	'S.RFC3261-8.2-42',
	'S.RFC3261-8.2-43',
	'S.RFC3261-8.2-44',
	'S.RFC3261-12.1-2',
	'S.RFC3261-12.1-3',
	'S.RFC3261-12.1-4',
	'S.RFC3261-12.1-5',
	'S.RFC3261-13.1-1',
	'S.RFC3261-13.2-12',
	'S.RFC3261-13.2-6',
	'S.RFC3261-13.3-10',
	'S.RFC3261-18.2-13',
	'S.RFC3261-18.2-5',
	'S.RFC3261-18.2-6',
	'S.RFC3261-20.10-1',
	'S.RFC3261-20.15-1',
	'S.RFC3265-3.3-5',
	'S.RFC3455-4.2-1',
	'S.RFC4566-5.2-3',
	'S.RFC4566-5.3-1',
	'S.RFC4566-5.3-2',
	'S.RFC4566-5.3-4',
	'S.RFC4566-5.7-1',
	'S.RFC4566-5.7-7',
	'S.RFC4566-5-2',
	'S.RFC4566-5-3',
	'S.RFC4566-5-4',
	{'TY'=>'SW','S.TS24229-5.1-444'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-445'=>'#auth-scheme:sipdigest'},     #Digest
	'S.TS24229-6.1-1',
	'S.TS24229-6.1-3',
	'S.TS24229-6.1-7',
	],
},#SS.Response.200_INVITE

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.ACK',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-10',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
	'S.RFC3261-8.1-38',
	'S.RFC3261-12.2-1',
	'S.RFC3261-12.2-2',
	'S.RFC3261-12.2-3',
	'S.RFC3261-12.2-4',
	'S.RFC3261-12.2-6',
	'S.RFC3261-12.2-14',
	'S.RFC3261-12.2-15',
	'S.RFC3261-13.2-19',
	'S.RFC3261-13.2-20',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.14-3',
	'S.RFC3455-4.2-1',
	{'TY'=>'SW','S.TS24229-5.1-356'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-358'=>'#auth-scheme:sipdigest'},     #Digest
	],
},#SS.Request.ACK
    
######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.BYE',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-10',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
#	'S.RFC3261-8.1-30',
	'S.RFC3261-8.1-38',
	'S.RFC3261-12.2-1',
	'S.RFC3261-12.2-2',
	'S.RFC3261-12.2-3',
	'S.RFC3261-12.2-4',
	'S.RFC3261-12.2-6',
	'S.RFC3261-12.2-7',
	'S.RFC3261-12.2-8',
	'S.RFC3261-12.2-9',
	'S.RFC3261-12.2-14',
	'S.RFC3261-12.2-15',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.14-3',
	{'TY'=>'SW','S.RFC3329-2.3-14'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-15'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-16'=>'#auth-scheme:aka'},
	'S.RFC3455-4.2-1',
	{'TY'=>'SW','S.TS24229-5.1-356'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-358'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-363'=>'#auth-scheme:sipdigest'},     #Digest
	],
},#SS.Request.BYE

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Response.200_BYE',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7-2',
	'S.RFC3261-8.1-10',
	'S.RFC3261-8.2-36',
	'S.RFC3261-8.2-37',
	'S.RFC3261-8.2-38',
	'S.RFC3261-8.2-39',
	'S.RFC3261-8.2-41',
	'S.RFC3261-8.2-44',
	'S.RFC3261-17.1-1',
	'S.RFC3261-18.2-13',
	'S.RFC3261-18.2-5',
	'S.RFC3261-18.2-6',
	'S.RFC3261-20.14-3',
	'S.RFC3455-4.2-1',
	],
},#SS.Response.200_BYE

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.CANCEL',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
	'S.RFC3261-8.2-18',
	'S.RFC3261-9.1-11',
	'S.RFC3261-9.1-2',
	'S.RFC3261-9.1-3',
	'S.RFC3261-9.1-4',
	'S.RFC3261-9.1-5',
	'S.RFC3261-20.14-3',
	'S.RFC3455-4.2-1',
	{'TY'=>'SW','S.TS24229-5.1-356'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-363'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-358'=>'#auth-scheme:sipdigest'},     #Digest
	],
},#SS.Request.CANCEL

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Response.200_CANCEL',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7-2',
	'S.RFC3261-8.2-36',
	'S.RFC3261-8.2-37',
	'S.RFC3261-8.2-38',
	'S.RFC3261-8.2-39',
	'S.RFC3261-8.2-42',
	'S.RFC3261-8.2-43',
	'S.RFC3261-17.1-1',
	'S.RFC3261-18.2-13',
	'S.RFC3261-18.2-5',
	'S.RFC3261-18.2-6',
	'S.RFC3261-20.14-3',
	'S.RFC3455-4.2-1',
	],
},#SS.Response.200_CANCEL

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Response.3XX-6XX',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7-2',
	'S.RFC3261-8.2-36',
	'S.RFC3261-8.2-37',
	'S.RFC3261-8.2-38',
	'S.RFC3261-8.2-39',
	'S.RFC3261-8.2-41',
	'S.RFC3261-8.2-42',
	'S.RFC3261-8.2-43',
	'S.RFC3261-8.2-44',
	'S.RFC3261-18.2-13',
	'S.RFC3261-18.2-5',
	'S.RFC3261-18.2-6',
	'S.RFC3261-20.14-3',
	'S.RFC3455-4.2-1',
	],
},#SS.Response.3XX-6XX

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.ACK_non-2xx',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
	'S.RFC3261-8.2-18',
	'S.RFC3261-17.1-23',
	'S.RFC3261-17.1-32',
	'S.RFC3261-17.1-33',
	'S.RFC3261-17.1-34',
	'S.RFC3261-17.1-35',
	'S.RFC3261-17.1-36',
	'S.RFC3261-17.1-37',
	'S.RFC3261-17.1-38',
	'S.RFC3261-20.14-3',
	'S.RFC3455-4.2-1',
	{'TY'=>'SW','S.TS24229-5.1-356'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-358'=>'#auth-scheme:sipdigest'},     #Digest
	],
},#SS.Request.ACK_non-2xx

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Request.OPTIONS',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.1-1',
	'S.RFC3261-7.1-2',
	'S.RFC3261-7-2',
	'S.RFC3261-8.1-1',
	'S.RFC3261-8.1-2',
	'S.RFC3261-8.1-7',
	'S.RFC3261-8.1-9',
	'S.RFC3261-8.1-14',
	'S.RFC3261-8.1-15',
	'S.RFC3261-8.1-16',
	'S.RFC3261-8.1-17',
	'S.RFC3261-8.1-18',
	'S.RFC3261-8.1-19',
	'S.RFC3261-8.1-20',
	'S.RFC3261-8.1-21',
	'S.RFC3261-8.1-23',
#	'S.RFC3261-8.1-30',
	'S.RFC3261-8.1-38',
	'S.RFC3261-11.1-1',
	'S.RFC3261-18.1-7',
	'S.RFC3261-20.14-3',
	{'TY'=>'SW','S.RFC3329-2.3-14'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-15'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.RFC3329-2.3-16'=>'#auth-scheme:aka'},
	'S.RFC3455-4.2-1',
	{'TY'=>'SW','S.TS24229-5.1-356'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-358'=>'#auth-scheme:sipdigest'},     #Digest
	{'TY'=>'SW','S.TS24229-5.1-363'=>'#auth-scheme:sipdigest'},     #Digest
	'S.TS24229-5.1-378',
	{'TY'=>'SW','S.TS24229-5.1-379'=>'#auth-scheme:aka'},     #AKA
	'S.TS24229-5.1-398',
	'S.TS24229-5.1-400',
	{'TY'=>'SW','S.TS24229-5.1-402'=>'#auth-scheme:aka'},     #AKA
	{'TY'=>'SW','S.TS24229-5.1-403'=>'#auth-scheme:sipdigest'},     #Digest
	'S.TS24229-5.1-404',
	],
},#SS.Request.OPTIONS

######################################
{
    'TY'=>'PROGN',
    'ID'=>'SS.Response.200_OPTIONS',
    'EX'=>[
	'SS.Generic_SIP_Message',
	'S.RFC3261-7.4-1',
	'S.RFC3261-7.4-3',
	'S.RFC3261-8.2-36',
	'S.RFC3261-8.2-37',
	'S.RFC3261-8.2-38',
	'S.RFC3261-8.2-39',
	'S.RFC3261-8.2-42',
	'S.RFC3261-8.2-43',
	'S.RFC3261-11.2-2',
	'S.RFC3261-11.2-4',
	'S.RFC3261-11-1',
	'S.RFC3261-13.1-1',
	'S.RFC3261-13.2-12',
	'S.RFC3261-17.1-1',
	'S.RFC3261-18.2-5',
	'S.RFC3261-18.2-6',
	'S.RFC3261-18.2-13',
	'S.RFC3261-20.15-1',
	'S.RFC3265-3.3-5',
	'S.RFC3455-4.2-1',
	'S.RFC4566-5.2-3',
	'S.RFC4566-5.3-1',
	'S.RFC4566-5.3-2',
	'S.RFC4566-5.3-4',
	'S.RFC4566-5.7-1',
	'S.RFC4566-5.7-7',
	'S.RFC4566-5-2',
	'S.RFC4566-5-3',
	'S.RFC4566-5-4',
	'S.TS24229-6.1-1',
	'S.TS24229-6.1-3',
	'S.TS24229-6.1-7',
	],
},#SS.Response.200_OPTIONS
######################################

);

1;
