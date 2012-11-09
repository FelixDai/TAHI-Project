#!/usr/bin/perl
#
# Copyright(C) IPv6 Promotion Council (2004,2005). All Rights Reserved.
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


# 
# 10/1/ 4  CNTLENGTH_EXISTandBODY(UDP)

#======================================
# Rule definition
#    for UA test (Transport Layer)
#======================================
      
@SIPUATransportDependentRules =
(    
     
##################
### Rule (ENCODE)
##################

##################
### Rule (SYNTAX)
##################

### Judgment rule for processing stat-line
### (Basis for a determination : RFC3261-7-19)
###
### This judgment should be executed as a standalone scenario.
### So, not implemented.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for SIPS-URI
### (Basis for a determination : RFC3261-8-6)
### 
### This judgment is executed in each rules.
### So, not implemented.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for "Contact" header (SIPS-URI)
### (Basis for a determination : RFC3261-8-26)
###
### A judgment to be equivalent of this judgment is exected in S.CONTACT-URI_REMOTE-CONTACT-URI.
### So, not implemented.
### (Of course, apart from it, you can implement it originally.)
###
###   written by Horisawa (2006.1.30)

### Judgment rule for Location Service
### (Basis for a determination : RFC3261-8-34)
###
### This is a judgment for DNS query and internal operation of UAC.
### So, not implemented.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for TLS
### (Basis for a determination : RFC3261-8-35)
### 
### In current structure, it is difficult to judge what protocol was used as a transport protocol.
### So, this judgment is not implemented yet.
### 
###   written by Horisawa (2006.1.30)

### Judgment rule for information to user
### (Basis for a determination : RFC3261-8-50)
###
### It is impossible to know whether the target UA informed it or not from received messages.
### So, this judgment is not implemented.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for "Contact" header in response
### (Basis for a determination : RFC3261-12-6)
###   written by Horisawa 
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3261-12-6_Contact',
 'CA:'=>'Contact',
 'OK:'=>'If the request that initiated the dialog contained a SIPS-URI in the Request-URI or the topmost Record-Route header field or Contact header field, the Contact header field for the response MUST be a SIPS-URI.',
 'NG:'=>'If the request that initiated the dialog contained a SIPS-URI in the Request-URI or the topmost Record-Route header field or Contact header field, the Contact header field for the response MUST be a SIPS-URI.',
 'PR:'=>\q{($SIP_PL_TRNS eq "TLS") && FFIsExistHeader("Contact",@_) && 
 			(FFIsMatchStr('sips\:',FVib('send','','','RQ.Request-Line.uri.txt','RQ.Request-Line.method','INVITE'))
			|| FFIsMatchStr('sips\:',FVib('send','','','HD.Record-Route.val.route.txt','RQ.Request-Line.method','INVITE')->[0]) 
			|| FFIsMatchStr('sips\:',FVib('send','','','HD.Contact.val.contact.txt','RQ.Request-Line.method','INVITE')))
		},
 'EX:'=>\q{FFIsMatchStr('sips\:',\\\'HD.Contact.val.contact.txt','','',@_)},
},

### Judgment rule for "Contact" header in request
### (Basis for a determination : RFC3261-12-21)
###   written by Horisawa (2006.1.30)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.RFC3261-12-21_Contact',
 'CA:'=>'Contact',
 'OK:'=>'If the request has a Request-URI or a topmost Route header field value with a SIPS-URI , the Contact header field MUST contain a SIPS-URI.',
 'NG:'=>'If the request has a Request-URI or a topmost Route header field value with a SIPS-URI , the Contact header field MUST contain a SIPS-URI.',
 'PR:'=>\q{($SIP_PL_TRNS eq "TLS") && FFop('eq',\\\'RQ.Request-Line.method','INVITE',@_) &&
			FFIsExistHeader("Contact",@_) && 
			(FFIsMatchStr('sips\:',FV('RQ.Request-Line.uri.txt',@_)) 
			|| FFIsMatchStr('sips\:',FV('HD.Route.val.route.ad.ad.txt',@_)))
		},
 'EX:'=>\q{FFIsMatchStr('sips\:',\\\'HD.Contact.val.contact.txt','','',@_)},
},

### Judgment rule for secure flag
### (Basis for a determination : RFC3261-12-55)
###
### Because a state of a secure flag is an internal state of target UA, 
###  it is difficult to know the state of a secure flag of the target UA from a message directly.
### So, this judgment is not implemented.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for timer A 
### (Basis for a determination : RFC3261-17-5)
###
### Because timer A is the internal parameter of target UA, 
###  it is difficult to certain whether it started or not.
### (In addition, it is difficult to know whether it is the retransmission 
###   by TCP or SIP transaction layer from messages directly.)
### So, this judgment is not implemented.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for T1 value
### (Basis for a determination : RFC3261-17-13)
###
### It is difficult to know from messages directly, whether the target knows RTT or not.
### So, this judgment is not implemented.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for connection
### (Basis for a determination : RFC3261-18-1, RFC3261-18-2)
###
### It is difficult to know from messages directly, till when a target keep the connection.
### So, this judgment is not implemented.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for using UDP/TCP
### (Basis for a determination : RFC3261-18-3)
###
### It is possible to judge them by each tests itselves.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for 
### (Basis for a determination : RFC3261-18-4)
###
### This is an explanatory description. (not for judgment)
###
###   written by Horisawa (2006.1.30)

### Judgment rule for request message size
### (Basis for a determination : RFC3261-18-5)
###   written by Horisawa (2006.1.30)
###
### From messages, it is impossible to know whether the target knows its MTU size or not.
### So, this judgment is not implemented.
###
###   written by Horisawa (2006.1.30)

### Judgment rule for "Via" header
### (Basis for a determination : RFC3261-18-6)
###
### This judgment has already implemented as S.VIA-TRANSPORT_UDP in SIPrule.pm.
###
###   written by Horisawa (2006.1.30)




), # @SIPUATransportDependentRules

@SIPUAUDPDependentRules =
(

##################
### Rule (SYNTAX)
##################

### Judgment rule for "Content-Length" header
### (Basis for a determination : RFC3261-20-28)
###   moved from SIPrule.pm by Horisawa (2006.1.30)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.CNTLENGTH_EXISTandBODY',
 'CA:'=>'Content-Length',
 'OK:'=>\\'A Content-Length header SHOULD be present, and the value(%s) SHOULD equal the size(%s) of the message-body, in deci
mal number of octets.', 
 'NG:'=>\\'A Content-Length header SHOULD be present, and the value(%s) SHOULD equal the size(%s) of the message-body, in deci
mal number of octets.', 
 'RT:'=>"warning", 
 'EX:'=>\q{FFop('eq',\\\'HD.Content-Length.val',length(FV('BD.txt',@_)),@_)}
},

), # @SIPUAUDPDependentRules

@SIPUATCPDependentRules =
(

##################
### Rule (SYNTAX)
##################

### Judgment rule for "Content-Length" header
### (Basis for a determination : RFC3261-18-41, RFC3251-20-3, RFC3261-20-29)
###   moved from SIPrule.pm by Horisawa (2006.1.30)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.CNTLENGTH_EXISTandBODY',
 'CA:'=>'Content-Length',
 'OK:'=>\\'The Content-Length header MUST be used with stream oriented transports, and the value(%s) MUST equal the size(%s) of the message-body, in decimal number of octets.', 
 'NG:'=>\\'The Content-Length header MUST be used with stream oriented transports, and the value(%s) MUST equal the size(%s) of the message-body, in decimal number of octets.', 
 'EX:'=>\q{FFop('eq',\\\'HD.Content-Length.val',length(FV('BD.txt',@_)),@_)}
},

), # @SIPUATCPDependentRules

@SIPUATLSDependentRules =
(

##################
### Rule (SYNTAX)
##################

### Judgment rule for "Content-Length" header
### (Basis for a determination : RFC3261-18-41, RFC3261-20-3, RFC3261-20-29)
###   moved from SIPrule.pm by Horisawa (2006.1.30)
{'TY:'=>'SYNTAX',
 'ID:'=>'S.CNTLENGTH_EXISTandBODY',
 'CA:'=>'Content-Length',
 'OK:'=>\\'The Content-Length header MUST be used with stream oriented transports, and the value(%s) MUST equal the size(%s) of the message-body, in decimal number of octets.', 
 'NG:'=>\\'The Content-Length header MUST be used with stream oriented transports, and the value(%s) MUST equal the size(%s) of the message-body, in decimal number of octets.', 
 'EX:'=>\q{FFop('eq',\\\'HD.Content-Length.val',length(FV('BD.txt',@_)),@_)}
},

), # @SIPUATLSDependentRules

return 1;

