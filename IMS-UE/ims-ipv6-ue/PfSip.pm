#!/usr/bin/perl
# @@ -- SIPbnf.pm --
# Copyright (C) NTT Advanced Technology 2007
#

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

# 
# 09/3/18 $PtSIPMessage
# 08/2/28 sip: sips: 
#         Referred-By
# 07/11/14 
#   
#   
#   
#     $PtContactExtension= qq{(?!(?:(?i:q)$PtEQUAL|(?i:expires)$PtEQUAL))$PtGenericParam};
# 07/10/ 5 NTT-NSLAB:18
#   Reason 

## DEF.VAR
# SIP 
#  qq{}
#  q{}
#  |
#  
#  [*XXX | YYY] 
#  OR
#  perl 

# 
# user-param      =  "user=" ( "phone" / "ip" / other-user)
# transport-param =  "transport=" ( "udp" / "tcp" / "sctp" / "tls" / other-transport)
# composite-type  =  "message" / "multipart" / extension-token
# discrete-type   =  "text" / "image" / "audio" / "video" / "application" / extension-token
# qop-value       =  "auth" / "auth-int" / token
# algorithm       =  "algorithm" EQUAL ( "MD5" / "MD5-sess" / token )
# Info-Param      =  ( "purpose" EQUAL ( "icon" / " info" / "card" / token ) ) / generic-param
# handling-param  =  "handling" EQUAL ( "optional" / "required" / other-handling )
# disp-type       =  "render" / "session" / "icon" / "alert" / disp-extension-token
# transport       =  "UDP" / "TCP" / "TLS" / "SCTP" / other-transport
# event-reason-value=   "deactivated" / "probation" / "rejected" / "timeout" / "giveup" / "noresource" / event-reason-extension
# substate-value    = "active" / "pending" / "terminated" / extension-substate
# priv-value        =  "header" / "session" / "user" / "none" / "critical" / token
# mechanism-name   = ( "digest" / "tls" / "ipsec-ike" / "ipsec-man" / token )
# access-type      = "IEEE-802.11a" / "IEEE-802.11b" / "3GPP-GERAN" / "3GPP-UTRAN-FDD" / "3GPP-UTRAN-TDD" / "3GPP-CDMA2000" / token

#### 

# ALPHA          =  %x41-5A / %x61-7A  ; A-Z / a-z
#

# BIT            =  "0" / "1"
#

# CHAR           =  %x01-7F            ; any 7-bit US-ASCII character,
#

# CR             =  %x0D               ; carriage return
$PtCR              = q{\x0D};             #2006/01/18
#$PtCR              = qq{\r};             #

# LF             =  %x0A               ; linefeed
$PtLF              = q{\x0A};             #2006/01/18
#$PtLF              = qq{\n};             #

# CRLF             =  CR LF              ; Internet standard newline
$PtCRLF            = qq{$PtCR$PtLF};

# CTL              =  %x00-1F / %x7F     ; controls
#

# DIGIT            =  %x30-39            ; 0-9
#

# DQUOTE           =  %x22               ; " (Double Quote)
$PtDQUOTE          = q{\x22};             #2006/01/18
#$PtDQUOTE          = q{"};

# HEXDIG           =  DIGIT / "A" / "B" / "C" / "D" / "E" / "F"
#$PtHex

# HTAB             =  %x09               ; horizontal tab
$PtHTAB            = q{\x09};             #2006/01/18
#$PtHTAB            = q{\t};

# LWSP             =  *(WSP / CRLF WSP)  ; linear white space (past newline)
#

# OCTET            =  %x00-FF            ; 8 bits of data
#

# SP               =  %x20               ; space
$PtSP              = q{\x20};             #2006/01/18
#$PtSP              = q{ };

# VCHAR            =  %x21-7E            ; visible (printing) characters
#

# WSP              =  SP / HTAB          ; white space
$PtWSP             = qq{(?:$PtSP|$PtHTAB)};

#### 

#$PtCRLF            = "\r\n";    #2006/01/13Comment
$PtDigit           = q{[0-9]};
$PtHex             = qq{(?:$PtDigit|[A-Fa-f])};
$PtUpalpha         = q{[A-Z]};
$PtLowalpha        = q{[a-z]};
$PtAlpha           = qq{(?:$PtLowalpha|$PtUpalpha)};

# alphanum         =  ALPHA / DIGIT
$PtAlphanum        = qq{(?:$PtAlpha|$PtDigit)};

# reserved         =  ";" / "/" / "?" / ":" / "@" / "&" / "=" / "+" / "$" / ","
$PtReserved        = q{(?:[;\/\?:\@&=\+\$,])};

# mark             =  "-" / "_" / "." / "!" / "~" / "*" / "'" / "(" / ")"
$PtMark            = q{[\-_\.!~\*'\(\)]};

# unreserved       =  alphanum / mark
$PtUnreserved      = qq{(?:$PtAlphanum|$PtMark)};

# escaped          =  "%" HEXDIG HEXDIG
$PtEscaped         = qq{%$PtHex$PtHex};

# LWS              = [*WSP CRLF] 1*WSP
$PtLWS             = qq{(?:(?:$PtWSP)*$PtCRLF)?(?:$PtWSP)+};   # 2006/01/13
#$PtLWS             = q{(?:(?:\s)*\r\n)?(?:\s)+};   # 2003/12/15
#$PtLWS             = q{(?:(?:\s)*\r\n)?(?:\s)?};


# SWS              = [LWS] ; sep whitespace
$PtSWS             = qq{(?:$PtLWS)?};
#$PtSWS            = q{(?:\s|\r\n)+?};

# HCOLON           =  *( SP / HTAB ) ":" SWS
$PtHCOLON          = qq{(?:(?:$PtSP|$PtHTAB)*:$PtSWS)};         # 2006/01/13
#$PtHCOLON          = qq{(?:\\s*?:$PtSWS)};         # 2003/12/15
#$PtHCOLON          = qq{(?:\\s*?:(?:[ \t]*(?!\r\n))?)};

# UTF8-CONT        =  %x80-BF
$PtUTF8CONT        = q{[\x80-\xBF]};

# UTF8-NONASCII    =  %xC0-DF 1UTF8-CONT / %xE0-EF 2UTF8-CONT / %xF0-F7 3UTF8-CONT / %xF8-Fb 4UTF8-CONT / %xFC-FD 5UTF8-CONT
$PtUTF8NONASCII    = qq{[\xC0-\xDF]$PtUTF8CONT|[\xE0-\xEF](?:$PtUTF8CONT){2}|[\xF0-\xF7](?:$PtUTF8CONT){3}|[\xF8-\xFB](?:$PtUTF8CONT){4}|[\xFC-\xFD](?:$PtUTF8CONT){5}};

# TEXT-UTF8char    =  %x21-7E / UTF8-NONASCII
$PtTEXTUTF8char    = qq{(?:[\x21-\x7E]|$PtUTF8NONASCII)};

# TEXT-UTF8-TRIM   =  1*TEXT-UTF8char *(*LWS TEXT-UTF8char)
$PtTEXTUTF8TRIM    = qq{(?:$PtTEXTUTF8char)+(?:(?:$PtLWS)*$PtTEXTUTF8char)*};

# LHEX             =  DIGIT / %x61-66 ;
$PtLHEX            = qq{(?:$PtDigit|[\x61-\x66])};

# RFC4566
# token-char       =   %x21 / %x23-27 / %x2A-2B / %x2D-2E / %x30-39 / %x41-5A / %x5E-7E
# token-char       =  alphanum / "!" / "#" / "$" / "%" / "&" / "'" / "*" / "+" / "-" / "." / "^" / "_" / "`" / "{" / "|" / "}" / "~"

# token            =  1*(alphanum / "-" / "." / "!" / "%" / "*" / "_" / "+" / "`" / "'" / "~" )
$PtToken           = qq{(?:$PtAlphanum|[\\\-\\\.!%\\\*_\\\+`'~])+};

# separators       =  "(" / ")" / "<" / ">" / "@" / "," / ";" / ":" / "\\" / DQUOTE / "/" / "[" / "]" / "?" / "=" /
#                       "{" / "}" / SP / HTAB
$PtSeparators      = qq{(?:[\\\(\\\)<>\@,;:\\\\\]|$PtDQUOTE|[\\/[]\?={}]|$PtSP|$PtHTAB)};    # 2006/01/13
#$PtSeparators      = q{[\(\)<>\@,;:\\\"/[]\?={}\s]};

# word             =  1*(alphanum / "-" / "." / "!" / "%" / "*" / "_" / "+" / "`" / "'" / "~" /
#                       "(" / ")" / "<" / ">" / ":" / "\" / DQUOTE /  "/" / "[" / "]" / "?" / "{" / "}" )
$PtWord            = qq{(?:$PtAlphanum|[\\\-\\\.!%\\\*_\\\+`'~\\\(\\\)<>:"\\/\\\[\\\]\\\?\\\{\\\}])+};

# STAR             =  SWS "*" SWS ; 
$PtSTAR            = qq{(?:$PtSWS\\\*$PtSWS)};

# SLASH            =  SWS "/" SWS ; 
$PtSLASH           = qq{(?:$PtSWS\\/(?:$PtSWS))};

# EQUAL            =  SWS "=" SWS ; 
$PtEQUAL           = qq{(?:$PtSWS=$PtSWS)};

# LPAREN           =  SWS "(" SWS ; 
$PtLPAREN          = qq{(?:$PtSWS\\\($PtSWS)};

# RPAREN           =  SWS ")" SWS ; 
$PtRPAREN          = qq{(?:$PtSWS\\\)$PtSWS)};

# RAQUOT           =  ">" SWS ; 
$PtRAQUOT          = qq{(?:$PtSWS>$PtSWS)};

# LAQUOT           =  SWS "<"; 
$PtLAQUOT          = qq{(?:$PtSWS<$PtSWS)};

# COMMA            =  SWS "," SWS ; 
$PtCOMMA           = qq{(?:$PtSWS,$PtSWS)};

# SEMI             =  SWS ";" SWS ; 
$PtSEMI            = qq{(?:$PtSWS;$PtSWS)};

# COLON            =  SWS ":" SWS ; 
$PtCOLON           = qq{(?:$PtSWS:$PtSWS)};

# LDQUOT           =  SWS DQUOTE; 
$PtLDQUOT          = qq{(?:$PtSWS")};

# RDQUOT           =  DQUOTE SWS ; 
$PtRDQUOT          = qq{(?:"$PtSWS)};

# ctext            = %x21-27 / %x2A-5B / %x5D-7E / UTF8-NONASCII  / LWS
$PtCtext           = qq{(?:[\x21-\x27]|[\x2A-\x5B]|[\x5D-\x7E]|$PtUTF8NONASCII|$PtLWS)};

# qdtext           = LWS / %x21 / %x23-5B / %x5D-7E
$PtQdtext          = qq{(?:$PtLWS|\x21|[\x23-\x5B]|[\x5D-\x7E])};

# quoted-pair      = "\" (%x00-09 / %x0B-0C / %x0E-7F)
$PtQuotedPair     =  qq{\\\\(?:[\x00-\x09]|[\x0B-\x0C]|[\x0E-\x7F])};

# quoted-string    = SWS DQUOTE *(qdtext / quoted-pair ) DQUOTE
$PtQuotedString    = qq{(?:$PtSWS"(?:$PtQdtext|$PtQuotedPair)*")};

# comment          =  LPAREN *(ctext / quoted-pair / comment) RPAREN    
#$PtComment0        = qq{(?:$PtSWS\\\($PtSWS).*\\\)};
$PtComment0        = qq{$PtLPAREN(?:$PtCtext|$PtQuotedPair)*$PtRPAREN};
$PtComment         = qq{$PtLPAREN(?:$PtCtext|$PtQuotedPair|(?:$PtComment0))*$PtRPAREN};

# other-transport =  token
$PtOtherTransport = $PtToken;

# other-user      =  token
$PtOtherUser      = $PtToken;

# user-unreserved =  "&" / "=" / "+" / "\$" / "," / ";" / "?" / "/"
$PtUserUnreserved = q{[&=\+\$,;\?\/]};

# user            =  1*( unreserved / escaped / user-unreserved )
$PtUser           = qq{(?:$PtUnreserved|$PtEscaped|$PtUserUnreserved)+};

# password        =  *( unreserved / escaped / "&" / "=" / "+" / "\$" / "," )
$PtPassword       = qq{(?:$PtUnreserved|$PtEscaped|[&=\\\+\\\$,])*?};

# hex4            =  1*4HEXDIG
$PtHex4           = qq{(?:$PtHex){1,4}};

# hexseq          =  hex4 *( ":" hex4)
$PtHexseq         = qq{$PtHex4(?::$PtHex4)*};

# hexpart
#   
# 
# hexpart         =  hexseq / hexseq "::" [ hexseq ] / "::" [ hexseq ]
$PtHexpart        = qq{(?:$PtHexseq(?:::)(?:$PtHexseq)?|::(?:$PtHexseq)?|$PtHexseq)};

# toplabel        =  ALPHA / ALPHA *( alphanum / "-" ) alphanum
#$PtToplabel       = qq{(?:$PtAlpha|(?:$PtAlpha(?:$PtAlpha|-)*$PtAlphanum))};
$PtToplabel       = qq{(?:(?:$PtAlpha(?:$PtAlphanum|-)*$PtAlphanum)|$PtAlpha)};

# domainlabel     =  alphanum / alphanum *( alphanum / "-" ) alphanum
# $PtDomainlabel    = qq{(?:$PtAlphanum|(?:$PtAlphanum(?:$PtAlphanum|-)*$PtAlphanum))};
$PtDomainlabel    = qq{(?:(?:$PtAlphanum(?:$PtAlphanum|-)*$PtAlphanum)|$PtAlphanum)};

# IPv4address     =  1*3DIGIT "." 1*3DIGIT "." 1*3DIGIT "." 1*3DIGIT
$PtIPv4address    = qq{(?:$PtDigit){1,3}\\\.(?:$PtDigit){1,3}\\\.(?:$PtDigit){1,3}\\\.(?:$PtDigit){1,3}};

# IPv6address     =  hexpart [ ":" IPv4address ]
$PtIPv6address    = qq{$PtHexpart(?::$PtIPv4address)?};

# IPv6reference   =  "[" IPv6address "]"
$PtIPv6reference  = qq{\\\[(?:$PtIPv6address)\\\]};

# hostname        =  *( domainlabel "." ) toplabel [ "." ]
$PtHostname       = qq{(?:$PtDomainlabel\\\.)*$PtToplabel\\\.?};

# port            =  1*DIGIT
$PtPort           = qq{(?:$PtDigit)+};

# host            =  hostname / IPv4address / IPv6reference
$PtHost           = qq{(?:$PtHostname|$PtIPv4address|$PtIPv6reference)};

# param-unreserved=  "[" / "]" / "/" / ":" / "&" / "+" / "\$"
$PtParamUnreserved= q{[\[\]\/:&\+\$]};

# paramchar       =  param-unreserved / unreserved / escaped
$PtParamchar      = qq{$PtParamUnreserved|$PtUnreserved|$PtEscaped};

# pname           =  1*paramchar
$PtPname          = qq{(?:$PtParamchar)+};

# pvalue          =  1*paramchar
$PtPvalue         = qq{(?:$PtParamchar)+};

# hnv-unreserved  =  "[" / "]" / "/" / "?" / ":" / "+" / "\$"
$PtHnvUnreserved  = q{[\[\]\/\?:\+\$]};

# hname           =  1*( hnv-unreserved / unreserved / escaped )
$PtHname          = qq{(?:$PtHnvUnreserved|$PtUnreserved|$PtEscaped)+};

# hvalue          =  *( hnv-unreserved / unreserved / escaped )
$PtHvalue         = qq{(?:$PtHnvUnreserved|$PtUnreserved|$PtEscaped)*};

# pchar           =  unreserved / escaped / ":" / "@" / "&" / "=" / "+" / "\$" / ","
$PtPchar          = qq{$PtUnreserved|$PtEscaped|(?:[:\@&=\\\+\\\$,])};

# param           =  *pchar
$PtParam          = qq{(?:$PtPchar)*};

# scheme          =  ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
$PtScheme         = qq{$PtAlpha(?:$PtAlpha|$PtDigit|(?:[\\\+\\\-\\\.]))*};

# segment         =  *pchar *( ";" param )
#  
#  $PtSegment        = qq{(?:$PtPchar)*(?:;$PtParam)*};
$PtSegment        = qq{(?:$PtPchar)+(?:(?!;tag=);$PtParam)*};

# path-segments   =  segment *( "/" segment )
$PtPathSegments    = qq{$PtSegment(?:\\/(?:$PtSegment))*};

# abs-path        =  "/" path-segments
$PtAbsPath        = qq{\\/(?:$PtPathSegments)};

# reg-name        =  1*( unreserved / escaped / "\$" / "," / ";" / ":" / "@" / "&" / "=" / "+" )
#   
# $PtRegName        = qq{(?:$PtUnreserved|$PtEscaped|(?:[\\\$,;:\@&=\\\+]))+};
$PtRegName        = qq{(?:$PtUnreserved|$PtEscaped|(?:[\\\$,;:\@&=\\\+]))};

# hostport        =  host [ ":" port ]
$PtHostport       = qq{$PtHost(?::$PtPort)?};

# telephone-subscriber = 
# $PtTelephoneSubscriber =

# userinfo        =  ( user / telephone-subscriber ) [ ":" password ] "@"
# $PtUserinfo       = qq{(?:(?:$PtUser|$PtTelephoneSubscriber)(?::$PtPassword)?@)};
$PtUserinfo       = qq{(?:$PtUser(?::$PtPassword)?\@)};

# srvr            =  [ [ userinfo "@" ] hostport ]
$PtSrvr           = qq{(?:$PtUserinfo|\@)?$PtHostport};

# authority       =  srvr / reg-name
#  net-path 
$PtAuthority      = qq{$PtSrvr|(?:$PtRegName(?!;tag=))+$PtRegName?};

# net-path        =  "//" authority [ abs-path ]
$PtNetPath        = qq{\\/\\/(?:$PtAuthority)(?:$PtAbsPath)?};

# uric            =  reserved / unreserved / escaped
$PtUric           = qq{$PtReserved|$PtUnreserved|$PtEscaped};

# uric-no-slash   =  unreserved / escaped / ";" / "?" / ":" / "@" / "&" / "=" / "+" / "\$" / ","
$PtUricNoSlash    = qq{$PtUnreserved|$PtEscaped|(?:[;\\\?:\@&=\+\\\$,])};

# query           =  *uric
$PtQuery          = qq{(?:$PtUric)*?};

# hier-part       =  ( net-path / abs-path ) [ "?" query ]
$PtHierPart       = qq{(?:$PtNetPath|$PtAbsPath)(?:\\\?$PtQuery)?};

# opaque-part     =  uric-no-slash *uric
#  absoluteUri 
# $PtOpaquePart     = qq{(?:$PtUricNoSlash)(?:$PtUric)*?};
$PtOpaquePart     = qq{(?:$PtUricNoSlash)(?:(?:(?:$PtUric)(?!;tag=))*(?:$PtUric))};

# extension-method =  token
$PtExtensionMethod = qq{$PtToken};

# Zone            = 'GMT' Add 'UTC' / 'JST'
$PtZone           = qq{(?i:GMT|UTC|JST)};

# time            =  2DIGIT ":" 2DIGIT ":" 2DIGIT   ; 00:00:00 - 23:59:59
$PtTime1           = qq{(?:$PtDigit$PtDigit$PtCOLON$PtDigit$PtDigit$PtCOLON$PtDigit$PtDigit)};

# wkday           =  "Mon" / "Tue" / "Wed" / "Thu" / "Fri" / "Sat" / "Sun"
$PtWkday          = qq{(?i:Mon|Tue|Wed|Thu|Fri|Sat|Sun)};

# month           =  "Jan" / "Feb" / "Mar" / "Apr" / "May" / "Jun" / "Jul" / "Aug" / "Sep" / "Oct" / "Nov" / "Dec"
$PtMonth          = qq{(?i:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)};

# date1           =  2DIGIT SP month SP 4DIGIT      ; 
$PtDate1          = qq{(?i:$PtDigit$PtDigit$PtSP$PtMonth$PtSP$PtDigit$PtDigit$PtDigit$PtDigit)};    #2006/01/13
#$PtDate1          = qq{(?i:$PtDigit$PtDigit\\s$PtMonth\\s$PtDigit$PtDigit$PtDigit$PtDigit)};

# SIP-date        =  rfc1123-date
# rfc1123-date    =  wkday "," SP date1 SP time SP "GMT"
$PtSIPdate        =  qq{(?i:$PtWkday,$PtSP$PtDate1$PtSP$PtTime1$PtSP(?:GMT))};    #2006/01/13
#$PtSIPdate        =  qq{(?i:$PtWkday,\\s$PtDate1\\s$PtTime\\sGMT)};

# Method          =  INVITEm / ACKm / OPTIONSm / BYEm / CANCELm / REGISTERm / SUBSCRIBEm / NOTIFYm / REFERm / PRACKm / extension-method
$PtMethod         = qq{(?:(?-i:INVITE|ACK|OPTIONS|BYE|CANCEL|REGISTER|SUBSCRIBE|NOTIFY|REFER|PRACK)|$PtExtensionMethod)};

# maddr-param     =  "maddr=" host
$PtMaddrParam     = qq{(?i:maddr)=$PtHost};

# lr-param        =  "lr"
$PtLrParam       =  q{(?i:lr)};

# other-param     =  pname [ "=" pvalue ]
$PtOtherParam     = qq{$PtPname(?:=$PtPvalue)?};

# ttl               =  1*3DIGIT ; 0 
$PtTtl            = qq{(?:$PtDigit){1,3}};

# ttl-param       =  "ttl=" ttl
$PtTtlParam       = qq{(?:(?i:ttl)=$PtTtl)};

# method-param    =  "method=" Method
$PtMethodParam    = qq{(?:(?i:method)=$PtMethod)};

# user-param      =  "user=" ( "phone" / "ip" / other-user)
# $PtUserParam      = qq{(?:(?i:user)=(?:(?i:phone|ip)|$PtOtherUser))};
$PtUserParam      = qq{(?:(?i:user)=(?:$PtOtherUser))};

# transport-param =  "transport=" ( "udp" / "tcp" / "sctp" / "tls" / other-transport)
# $PtTransportParam = qq{(?:(?i:transport)=(?:(?i:udp|tcp|sctp|tls)|$PtOtherTransport))};
$PtTransportParam = qq{(?:(?i:transport)=$PtOtherTransport)};

# header          =  hname "=" hvalue
$PtHeader         = qq{$PtHname=$PtHvalue};

# headers         =  "?" header *( "&" header )
$PtHeaders        = qq{\\\?$PtHeader(?:&$PtHeader)*};

# uri-parameter   =  transport-param / user-param / method-param / ttl-param / maddr-param / lr-param / other-param
$PtUriParameter   = qq{(?:$PtTransportParam|$PtUserParam|$PtMethodParam|$PtTtlParam|$PtMaddrParam|$PtLrParam|$PtOtherParam)};

# uri-parameters  =  *( ";" uri-parameter)
# 
$PtUriParameters  = qq{(?:(?!;tag=);$PtUriParameter)*};

# absoluteURI     =  scheme ":" ( hier-part / opaque-part )
$PtAbsoluteUri    = qq{(?:$PtScheme:(?:$PtHierPart|$PtOpaquePart))};

# SIP-URI         = "sip:" [ userinfo ] hostport uri-parameters [ headers ]
$PtSIPUri         = qq{(?i:sip:)(?:$PtUserinfo)?$PtHostport$PtUriParameters(?:$PtHeaders)?};

# SIPS-URI        = "sips:" [ userinfo ] hostport uri-parameters [ headers ]
$PtSIPSUri        = qq{(?i:sips:)(?:$PtUserinfo)?$PtHostport$PtUriParameters(?:$PtHeaders)?};

# TELEPHONE-URI  (RFC 3966)
# visual-separator     = "-" / "." / "(" / ")"
$PtVisualSeparator     = q{(?:[\-\.\(\)])};

# phonedigit-hex       = HEXDIG / "*" / "#" / [ visual-separator ]
$PtPhonedigitHex       = qq{(?:$PtHex|\\\*|#|$PtVisualSeparator)};

# phonedigit           = DIGIT / [ visual-separator ]
$PtPhonedigit          = qq{(?:$PtDigit|$PtVisualSeparator)};

# pname                = 1*( alphanum / "-" )
$PtPname3966           = qq{(?:$PtAlphanum|-)+};

# parameter            = ";" pname3966 ["=" pvalue ]
$PtParameter           = qq{(?:;$PtPname3966(?:=(?:$PtPvalue))?)};

# domainname           = *( domainlabel "." ) toplabel [ "." ]
$PtDomainname          = qq{(?:(?:$PtDomainlabel\\\.)*$PtToplabel(?:\\\.)?)};

# local-number-digits  = *phonedigit-hex (HEXDIG / "*" / "#")*phonedigit-hex
$PtLocalNumberDigits   = qq{(?:(?:$PtPhonedigitHex)*(?:$PtHex|\\\*|#)*$PtPhonedigitHex)};

# global-number-digits = "+" *phonedigit DIGIT *phonedigit
$PtGlobalNumberDigits  = qq{(?:\\\+(?:$PtPhonedigit)*$PtDigit(?:$PtPhonedigit)*)};

# descriptor           = domainname / global-number-digits
$PtDescriptor          = qq{(?:$PtDomainname|$PtGlobalNumberDigits)};

# context              = ";phone-context=" descriptor
$PtContext             = qq{(?:;phone-context=$PtDescriptor)};

# extension            = ";ext=" 1*phonedigit
$PtExtension           = qq{(?:;ext=(?:$PtPhonedigit)+)};

# isdn-subaddress      = ";isub=" 1*uric
$PtIsdnSubaddress      = qq{(?:;isub=(?:$PtUric)+)};

# par                  = parameter / extension / isdn-subaddress
$PtPar                 = qq{(?:$PtParameter|$PtExtension|$PtIsdnSubaddress)};

# local-number         = local-number-digits *par context *par
$PtLocalNumber         = qq{(?:$PtLocalNumberDigits(?:$PtPar)*$PtContext(?:$PtPar)*)};

# global-number        = global-number-digits *par
$PtGlobalNumber        = qq{(?:$PtGlobalNumberDigits(?:$PtPar)*)};

# telephone-subscriber = global-number / local-number
$PtTelephoneSubscriber = qq{(?:$PtGlobalNumber|$PtLocalNumber)};

# telephone-uri        = "tel:" telephone-subscriber
$PtTelephoneUri        = qq{(?:tel:$PtTelephoneSubscriber)};


# Reason-Phrase   =  *(reserved / unreserved / escaped / UTF8-NONASCII / UTF8-CONT / SP / HTAB)
$PtReasonPhrase   = qq{(?:$PtReserved|$PtUnreserved|$PtEscaped|$PtUTF8NONASCII|$PtUTF8CONT|$PtSP|$PtHTAB)*};    #2006/01/13
#$PtReasonPhrase   = qq{(?:$PtReserved|$PtUnreserved|$PtEscaped|$PtUTF8NONASCII|$PtUTF8CONT|\\s)*};

# SIP-Version     =  "SIP" "/" 1*DIGIT "." 1*DIGIT
$PtSIPVersion     = qq{SIP\\/(?:$PtDigit)+\\\.(?:$PtDigit)+};

# Request-URI     =  SIP-URI / SIPS-URI / absoluteURI
$PtRequestURI     = qq{(?:$PtSIPUri|$PtSIPSUri|$PtAbsoluteUri)};

# Request-Line    =  Method SP Request-URI SP SIP-Version CRLF
$PtRequestLine    = qq{$PtMethod$PtSP$PtRequestURI$PtSP$PtSIPVersion};    #2006/01/13
#$PtRequestLine    = qq{$PtMethod\\s$PtRequestURI\\s$PtSIPVersion};

# Status-Line     =  SIP-Version SP Status-Code SP Reason-Phrase CRLF
$PtStatusLine     = qq{(?:$PtSIPVersion$PtSP(?:$PtDigit){1,3}$PtSP$PtReasonPhrase)};    #2006/01/13
#$PtStatusLine     = qq{(?:$PtSIPVersion\\s(?:$PtDigit){1,3}\\s$PtReasonPhrase)};

##################################################################################

# m-value         =  token / quoted-string
$PtMValue         = qq{(?:$PtToken|$PtQuotedString)};

# m-attribute     =  token
$PtMAttribute     = qq{$PtToken};

# m-parameter     =  m-attribute EQUAL m-value
$PtMParameter     = qq{$PtMAttribute$PtEQUAL$PtMValue};

# iana-token      =  token
$PtIanaToken      = qq{$PtToken};

# x-token         =  "x-" token
$PtXToken         = qq{(?i:x-)$PtToken};

# ietf-token      =  token
$PtIetfToken      = qq{$PtToken};

# extension-token =  ietf-token / x-token
$PtExtensionToken = qq{(?:$PtIetfToken|$PtXToken)};

# m-subtype       =  extension-token / iana-token
$PtMSubtype       = qq{(?:$PtExtensionToken|$PtIanaToken)};

# composite-type  =  "message" / "multipart" / extension-token
# $PtCompositeType  = qq{(?:(?i:message|multipart)|$PtExtensionToken)};
$PtCompositeType  = qq{(?:$PtExtensionToken)};

# discrete-type   =  "text" / "image" / "audio" / "video" / "application" / extension-token
# $PtDiscreteType   = qq{(?:(?i:text|image|audio|video|application)|$PtExtensionToken)};
$PtDiscreteType   = qq{(?:$PtExtensionToken)};

# m-type          = discrete-type / composite-type
$PtMType          = qq{(?:$PtDiscreteType|$PtCompositeType)};

# media-type      =  m-type SLASH m-subtype *(SEMI m-parameter)
$PtMediaType      = qq{$PtMType$PtSLASH$PtMSubtype(?:$PtSEMI$PtMParameter)*};

# gen-value       =  token / host / quoted-string
$PtGenValue       = qq{(?:$PtToken|$PtHost|$PtQuotedString)};

# generic-param   =  token [ EQUAL gen-value ]
$PtGenericParam   = qq{$PtToken(?:$PtEQUAL$PtGenValue)?};

# qvalue          =  ( "0" [ "." 0*3DIGIT ] ) / ( "1" [ "." 0*3("0") ] )
$PtQvalue         = qq{(?:(?:0(?:\\\.(?:$PtDigit){0,3})?)|(?:1(?:\\\.0{0,3})?))};

# nonce-value     =  quoted-string
$PtNonceValue     = qq{$PtQuotedString};

# delta-seconds   =  1*DIGIT
$PtDeltaSeconds   = qq{$PtDigit+};

#accept-param     = ("q" EQUAL qvalue) / generic-param
$PtAcceptParam    = qq{(?:(?i:q)$PtEQUAL$PtQvalue|$PtGenericParam)};

#media-range      =  ( "*/*" / ( m-type SLASH "*" ) / ( m-type SLASH m-subtype ) ) *( SEMI m-parameter )
$PtMediaRange     = qq{(?:\\\*/\\\*|$PtMType$PtSLASH\\\*|$PtMType$PtSLASH$PtMSubtype)(?:$PtSEMI$PtMParameter)*};

#accept-range     =  media-range *(SEMI accept-param)
$PtAcceptRange   = qq{$PtMediaRange(?:$PtSEMI$PtAcceptParam)*};

#Accept           =  "Accept" HCOLON [ accept-range *(COMMA accept-range) ]
$PtAccept         = qq{(?i:Accept)$PtHCOLON(?:$PtAcceptRange(?:$PtCOMMA$PtAcceptRange)*)?};

#content-coding   = token
$PtContentCoding  = qq{$PtToken};

#codings          =  content-coding / "*"
$PtCodings        = qq{(?:$PtContentCoding|\\\*)};

#encoding         =  codings *(SEMI accept-param)
$PtEncoding       = qq{$PtCodings(?:$PtSEMI$PtAcceptParam)*};

#Accept-encoding  =  "Accept-Encoding" HCOLON [ encoding *(COMMA encoding) ]
$PtAcceptEncoding = qq{(?i:Accept-Encoding)$PtHCOLON(?:$PtEncoding(?:$PtCOMMA$PtEncoding)*)?};

#language-range   =  ( ( 1*8ALPHA *( "-" 1*8ALPHA ) ) / "*" )
$PtLanguageRange  = qq{(?:(?:$PtAlpha){1,8}(?:-(?:$PtAlpha){1,8})*|\\\*)};

#language         =  language-range *(SEMI accept-param)
$PtLanguage       = qq{$PtLanguageRange(?:$PtSEMI$PtAcceptParam)*};

#Accept-Language  =  "Accept-Language" HCOLON [ language *( COMMA language ) ]
$PtAcceptLanguage = qq{(?i:Accept-Language)$PtHCOLON(?:$PtLanguage(?:$PtCOMMA$PtLanguage)*)?};

#alert-param      =  LAQUOT absoluteURI RAQUOT *( SEMI generic-param )
$PtAlertParam     = qq{$PtLAQUOT$PtAbsoluteUri$PtRAQUOT(?:$PtSEMI$PtGenericParam)*};

#Alert-Info       =  "Alert-Info" HCOLON alert-param *(COMMA alert-param)
$PtAlertInfo      = qq{(?i:Alert-Info)$PtHCOLON$PtAlertParam(?:$PtCOMMA$PtAlertParam)*};

# Allow           =  "Allow" HCOLON [Method *(COMMA Method)]
$PtAllow          = qq{(?i:Allow)$PtHCOLON(?:$PtMethod(?:$PtCOMMA$PtMethod)*)?};

# rr-param        =  generic-param
$PtRrParam        = qq{$PtGenericParam};

# qop-value       =  "auth" / "auth-int" / token
# $PtQopValue       = qq{(?:(?i:auth-int|auth)|$PtToken)};    # 040301 
$PtQopValue       = qq{(?:$PtToken)};

# qop-options     =  "qop" EQUAL LDQUOT qop-value *("," qop-value) RDQUOT
$PtQopOptions     = qq{(?i:qop)$PtEQUAL$PtLDQUOT$PtQopValue(?:,$PtQopValue)*$PtRDQUOT};

# algorithm       =  "algorithm" EQUAL ( "MD5" / "MD5-sess" / token )   # 040301 
# $PtAlgorithm      = qq{(?i:algorithm)$PtEQUAL(?:(?i:MD5-sess|MD5)|$PtToken)};
$PtAlgorithm      = qq{(?i:algorithm)$PtEQUAL$PtToken};

# URI             =  absoluteURI / abs-path
$PtURI            = qq{(?:$PtAbsoluteUri|$PtAbsPath)};

# domain          =  "domain" EQUAL LDQUOT URI *( 1*SP URI ) RDQUOT
$PtDomain         = qq{(?i:domain)$PtEQUAL$PtLDQUOT$PtURI(?:$PtSP+$PtURI)*$PtRDQUOT};    #2006/01/13
#$PtDomain         = qq{(?i:domain)$PtEQUAL$PtLDQUOT$PtURI(?:\s+$PtURI)*$PtRDQUOT};

# stale           =  "stale" EQUAL ( "true" / "false" )
$PtStale          = qq{(?i:stale)$PtEQUAL(?i:true|false)};

# opaque          =  "opaque" EQUAL quoted-string
$PtOpaque         = qq{(?i:opaque)$PtEQUAL$PtQuotedString};

# nonce-value     =  quoted-string
$PtNonceValue     = qq{$PtQuotedString};

# nonce           =  "nonce" EQUAL nonce-value
$PtNonce          = qq{(?i:nonce)$PtEQUAL$PtNonceValue};

# realm-value     =  quoted-string
$PtRealmValue     = qq{$PtQuotedString};

# realm           =  "realm" EQUAL realm-value
$PtRealm          = qq{(?i:realm)$PtEQUAL$PtRealmValue};

# auth-scheme     =  token
$PtAuthScheme     = qq{$PtToken};

# auth-param-name =  token
$PtAuthParamName  = qq{$PtToken};

# auth-param      =  auth-param-name EQUAL ( token / quoted-string )
$PtAuthParam      = qq{$PtAuthParamName$PtEQUAL(?:$PtToken|$PtQuotedString)};

# other-response  =  auth-scheme LWS auth-param *(COMMA auth-param)
$PtOtherResponse  = qq{$PtAuthScheme$PtLWS$PtAuthParam(?:$PtCOMMA$PtAuthParam)*};

# request-digest  =  LDQUOT 32LHEX RDQUOT
$PtRequestDigest  = qq{$PtLDQUOT(?:$PtLHEX){32}$PtRDQUOT};

# dresponse       =  "response" EQUAL request-digest
$PtDresponse      = qq{(?i:response)$PtEQUAL$PtRequestDigest};

# qq{}->q{}
# nc-value        =  8LHEX
$PtNcValue        = qq{(?:$PtLHEX){8}};

# nonce-count     =  "nc" EQUAL nc-value
$PtNonceCount     = qq{(?i:nc)$PtEQUAL$PtNcValue};

# cnonce-value    =  nonce-value
$PtCnonceValue    = qq{$PtNonceValue};

# cnonce          =  "cnonce" EQUAL cnonce-value
$PtCnonce         = qq{(?i:cnonce)$PtEQUAL$PtCnonceValue};

# message-qop     =  "qop" EQUAL qop-value
# $PtMessageQop     = qq{(?i:qop)$PtEQUAL$PtLDQUOT$PtQopValue$PtRDQUOT};
$PtMessageQop     = qq{(?i:qop)$PtEQUAL$PtQopValue};

# digest-cln      =  realm / domain / nonce / opaque / stale / algorithm / qop-options / auth-param
$PtDigestCln      = qq{(?:$PtRealm|$PtDomain|$PtNonce|$PtOpaque|$PtStale|$PtAlgorithm|$PtQopOptions|$PtAuthParam)};

# other-challenge =  auth-scheme LWS auth-param  *(COMMA auth-param)
$PtOtherChallenge = qq{$PtAuthScheme$PtLWS$PtAuthParam(?:$PtCOMMA$PtAuthParam)*};

# challenge       =  ("Digest" LWS digest-cln *(COMMA digest-cln)) / other-challenge
$PtChallenge      = qq{(?:(?:(?i:Digest)$PtLWS$PtDigestCln(?:$PtCOMMA$PtDigestCln)*)|$PtOtherChallenge)};

# HTTP/1.1
$PtHttpURL        = qq{http://$PtHost(?::$PtPort)?(?:$PtAbsPath(?:\\?$PtQuery)?)?};

# digest-uri-value=  rquest-uri ; HTTP/1.1
$PtDigestUriValue = qq{(?:$PtHttpURL|$PtRequestURI)};

# digest-uri      =  "uri" EQUAL LDQUOT digest-uri-value RDQUOT
$PtDigestUri      = qq{(?i:uri)$PtEQUAL$PtLDQUOT$PtDigestUriValue$PtRDQUOT};

# username-value  =  quoted-string
$PtUserNameValue  = qq{$PtQuotedString};

# username        =  "username" EQUAL username-value
$PtUserName       = qq{(?i:username)$PtEQUAL$PtUserNameValue};

# dig-resp        =  username / realm / nonce / digest-uri / dresponse / algorithm / cnonce / opaque / message-qop / nonce-count / auth-param
$PtDigResp        = qq{(?:$PtUserName|$PtRealm|$PtNonce|$PtDigestUri|$PtDresponse|$PtAlgorithm|$PtCnonce|$PtOpaque|$PtMessageQop|$PtNonceCount|$PtAuthParam)};

# digest-response =  dig-resp *(COMMA dig-resp)
$PtDigestResponse = qq{$PtDigResp(?:$PtCOMMA$PtDigResp)*};

# credentials     =  ("Digest" LWS digest-response) / other-response
$PtCredentials    = qq{(?:(?i:Digest)$PtLWS$PtDigestResponse|$PtOtherResponse)};

# Authorization   =  "Authorization" HCOLON credentials
$PtAuthorization  = qq{(?i:Authorization)$PtHCOLON$PtCredentials};

#response-digest  =  LDQUOT *LHEX RDQUOT
$PtResponseDigest = qq{$PtLDQUOT(?:$PtLHEX)*$PtRDQUOT};

#response-auth    =  "rspauth" EQUAL response-digest
$PtResponseAuth   = qq{(?i:rspauth)$PtEQUAL$PtResponseDigest};

# nextnonce       =  "nextnonce" EQUAL nonce-value
$PtNextNonce      = qq{(?i:nextnonce)$PtEQUAL$PtNonceValue};

# ainfo           =  nextnonce / message-qop / response-auth / cnonce / nonce-count
$PtAinfo          = qq{(?:$PtNextNonce|$PtMessageQop|$PtResponseAuth|$PtCnonce|$PtNonceCount)};

# Authentication-Info  =  "Authentication-Info" HCOLON ainfo *(COMMA ainfo)
$PtAuthenticationInfo =  qq{(?i:Authentication-Info)$PtHCOLON$PtAinfo(?:$PtCOMMA$PtAinfo)*};

# callid          =  word [ "@" word ]
$PtCallid         = qq{$PtWord(?:\@$PtWord)?};

# Call-ID         =  ( "Call-ID" / "i" ) HCOLON callid
$PtCallID         = qq{(?i:Call-ID|i)$PtHCOLON$PtCallid};

# Info-Param      =  ( "purpose" EQUAL ( "icon" / " info" / "card" / token ) ) / generic-param
# $PtInfoParam      = qq{(?:(?i:purpose)$PtEQUAL(?i:icon|info|card|$PtToken)|$PtGenericParam)};
$PtInfoParam      = qq{(?:(?i:purpose)$PtEQUAL$PtToken|$PtGenericParam)};

# Info            =  LAQUOT absoluteURI RAQUOT *( SEMI info-param )
$PtInfo           = qq{$PtLAQUOT$PtAbsoluteUri$PtRAQUOT(?:$PtSEMI$PtInfoParam)*};

# Call-Info       =  ( "Call-Info" ) HCOLON info *( COMMA info )
$PtCallInfo       = qq{(?i:Call-Info)$PtHCOLON$PtInfo(?:$PtCOMMA$PtInfo)*};

# contact-extension  =  generic-param
$PtContactExtension= qq{(?!(?:(?i:q)$PtEQUAL|(?i:expires)$PtEQUAL))$PtGenericParam};
# $PtContactExtension= qq{$PtGenericParam};

# c-p-expires     =  "expires" EQUAL delta-seconds
$PtCPExpires      = qq{(?i:expires)$PtEQUAL$PtDeltaSeconds};

# c-p-q           =  "q" EQUAL qvalue
$PtCPQ            = qq{(?i:q)$PtEQUAL$PtQvalue};

# contact-params  =  c-p-q / c-p-expires / contact-extension
$PtContactParams  = qq{(?:$PtCPQ|$PtCPExpires|$PtContactExtension)};
# $PtContactParams  = qq{(?:$PtContactExtension)};

# display-name    =  *(token LWS)/ quoted-string
#   
#   from: NUT<sip:NUT\@[3ffe:501:ffff:5:2a0:deff:fe14:e2ec]>;tag=6209640784
# $PtDisplayName    = qq{(?:(?:$PtToken$PtLWS)+|$PtQuotedString)};
$PtDisplayName    = qq{(?:(?:$PtToken(?:$PtLWS)??)+|$PtQuotedString)};

# addr-spec       =  SIP-URI / SIPS-URI / absoluteURI
$PtAddrSpec       = qq{(?:$PtSIPUri|$PtSIPSUri|$PtAbsoluteUri)};

# name-addr       =  [ display-name ] LAQUOT addr-spec RAQUOT
$PtNameAddr       = qq{(?:$PtDisplayName)?$PtLAQUOT$PtAddrSpec$PtRAQUOT};

# contact-param   =  (name-addr / addr-spec) *(SEMI contact-params)
$PtContactParam   = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtContactParams)*};

# Contact         =  ("Contact" / "m" ) HCOLON ( STAR / (contact-param *(COMMA contact-param)))
$PtContact        = qq{(?i:Contact|m)$PtHCOLON(?:$PtSTAR|(?:$PtContactParam(?:$PtCOMMA$PtContactParam)*))};

# disp-extension-token  =  token
$PtDispExtensionToken = qq{$PtToken};

# other-handling  =  token
$PtOtherHandling  = qq{$PtToken};

# handling-param  =  "handling" EQUAL ( "optional" / "required" / other-handling )
# $PtHandlingParam  = qq{(?i:handling)$PtEQUAL(?:optional|required|$PtOtherHandling)};
$PtHandlingParam  = qq{(?i:handling)$PtEQUAL(?:$PtOtherHandling)};

# disp-param      =  handling-param / generic-param
$PtDispParam      = qq{(?:$PtHandlingParam|$PtGenericParam)};

# disp-type       =  "render" / "session" / "icon" / "alert" / disp-extension-token
# $PtDispType       = qq{(?i:render|session|icon|alert|$PtDispExtensionToken)};
$PtDispType       = qq{(?:$PtDispExtensionToken)};

# Content-Disposition   =  "Content-Disposition" HCOLON disp-type *( SEMI disp-param )
$ContentDisposition = qq{(?i:Content-Disposition)$PtHCOLON$PtDispType(?:$PtSEMI$PtDispParam)*};

# Content-Encoding =  ( "Content-Encoding" / "e" ) HCOLON content-coding *(COMMA content-coding)
$ContentEncoding  = qq{(?i:Content-Encoding|e)$PtHCOLON$PtContentCoding(?:$PtCOMMA$PtContentCoding)*};

# subtag          =  1*8ALPHA
$PtSubTag         = qq{(?:$PtAlpha){1,8}};

# primary-tag     =  1*8ALPHA
$PtPrimaryTag     = qq{(?:$PtAlpha){1,8}};

# language-tag    =  primary-tag *( "-" subtag )
$PtLanguageTag    = qq{$PtPrimaryTag(?:-$PtSubTag)*};

# Content-Language =  "Content-Language" HCOLON language-tag *(COMMA language-tag)
$PtContentLanguage = qq{(?i:Content-Language)$PtHCOLON$PtLanguageTag(?:$PtCOMMA$PtLanguageTag)*};

# Content-Length  =  ( "Content-Length" / "l" ) HCOLON 1*DIGIT
$PtContentLength  = qq{(?i:Content-Length|l)$PtHCOLON(?:$PtDigit)+};

# Content-Type    =  ( "Content-Type" / "c" ) HCOLON media-type
$PtContentType    = qq{(?i:Content-Type|c)$PtHCOLON$PtMediaType};

# CSeq            =  "CSeq" HCOLON 1*DIGIT LWS Method
$PtCSeq           = qq{(?i:CSeq)$PtHCOLON(?:$PtDigit)+$PtLWS$PtMethod};

# Date            = 'Date' HCOLON SIP-date
$PtDate           = qq{(?i:Date)$PtHCOLON$PtSIPdate};

# error-uri       =  LAQUOT absoluteURI RAQUOT *( SEMI generic-param )
$PtErrorUri       = qq{$PtLAQUOT$PtAbsoluteUri$PtRAQUOT(?:$PtSEMI$PtGenericParam)*};

# Error-Info      =  "Error-Info" HCOLON error-uri *(COMMA error-uri)
$PtErrorInfo      = qq{(?i:Error-Info)$PtHCOLON$PtErrorUri(?:$PtCOMMA$PtErrorUri)*};

# Expires         =  "Expires" HCOLON delta-seconds
$PtExpires        = qq{(?i:Expires)$PtHCOLON$PtDeltaSeconds};

# tag-param       =  "tag" EQUAL token
$PtTagParam       = qq{(?:(?i:tag)$PtEQUAL$PtToken)};

# from-param      =  tag-param / generic-param
$PtFromParam      = qq{(?:$PtTagParam|$PtGenericParam)};

# from-spec       =  ( name-addr / addr-spec ) *( SEMI from-param )
$PtFromSpec       = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtFromParam)*};

# From            =  ( "From" / "f" ) HCOLON from-spec
$PtFrom           = qq{(?i:From|f)$PtHCOLON$PtFromSpec};

# rplyto-param    =  generic-param
$PtReplyToParam   = qq{(?:$PtGenericParam)};

# rplyto-spec     =  ( name-addr / addr-spec ) *( SEMI rplyto-param )
$PtReplyToSpec    = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtReplyToParam)*};

# Reply-To        =  "Reply-To" HCOLON rplyto-spec
$PtReplyTo        = qq{(?i:Reply-To)$PtHCOLON$PtReplyToSpec};

# In-Reply-To     =  ( "In-Reply-To" ) HCOLON callid *( COMMA callid )
$PtInReplyTo      = qq{(?i:In-Reply-To)$PtHCOLON$PtCallid(?:$PtCOMMA$PtCallid)*};

# Max-Forwards    =  "Max-Forwards" HCOLON 1*DIGIT
$PtMaxForwards    = qq{(?i:Max-Forwards)$PtHCOLON$PtDigit+};

# MIME-Version    =  "MIME-Version" HCOLON 1*DIGIT "." 1*DEGIT
$PtMIMEversion    = qq{(?i:MIME-Version)$PtHCOLON$PtDigit+\\\.$PtDigit+};

# Min-Expires     =  "Min-Expires" HCOLON delta-seconds
$PtMinExpires     = qq{(?i:Min-Expires)$PtHCOLON$PtDeltaSeconds};

# Organization    =  "Organization" HCOLON [TEXT-UTF8-TRIM]
$PtOrganization   = qq{(?i:Organization)$PtHCOLON(?:$PtTEXTUTF8TRIM)?};

# other-priority  =  token
$PtOtherPriority  = qq{$PtToken};

# priority-value  =  "emergency" / "urgent" / "normal" / "non-urgent" / (token)
$PtPriorityValue  = qq{(?i:emergency|urgent|normal|non-urgen|\\($PtOtherPriority\\))};

# Priority        =  "Priority" HCOLON priority-value
$PtPriority       = qq{(?i:Priority)$PtHCOLON$PtPriorityValue};

# Proxy-Authorization  =  "Proxy-Authorization" HCOLON credentials
$PtProxyAuthorization= qq{(?i:Proxy-Authorization)$PtHCOLON$PtCredentials};

# option-tag      =  token
$PtOptionTag      = qq{$PtToken};

# Proxy-Require   =  "Proxy-Require" HCOLON option-tag *(COMMA option-tag)
$PtProxyRequire   = qq{(?i:Proxy-Require)$PtHCOLON$PtOptionTag(?:$PtCOMMA$PtOptionTag)*};

# rr-param        =  generic-param
$PtRrParam        = qq{$PtGenericParam};

# rec-route       =  name-addr *( SEMI rr-param )
$PtRecRoute       = qq{$PtNameAddr(?:$PtSEMI$PtRrParam)*};

# Record-Route    =  "Record-Route" HCOLON rec-route *(COMMA rec-route)
$PtRecordRoute    = qq{(?i:Record-Route)$PtHCOLON$PtRecRoute(?:$PtCOMMA$PtRecRoute)*};

# rplyto-param    =  generic-param
$PtRplytoParam    = qq{$PtGenericParam};

# rplyto-spec     =  ( name-addr / addr-spec ) *( SEMI rplyto-param )
$PtRplytoSpec     = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtRplytoParam)*};

# Reply-To        =  "Reply-To" HCOLON rplyto-spec
$PtReplyTo        = qq{(?i:Reply-To)$PtHCOLON$PtRplytoSpec};

# Require         =  "Require" HCOLON option-tag *(COMMA option-tag)
$PtRequire        = qq{(?i:Require)$PtHCOLON$PtOptionTag(?:$PtCOMMA$PtOptionTag)*};

# retry-param     =  ("duration" EQUAL delta-seconds) / generic-param
$PtRetryParam     = qq{(?:(?i:duration)$PtEQUAL$PtDeltaSeconds|$PtGenericParam)};

# Retry-After     =  "Retry-After" HCOLON delta-seconds [ comment ] *( SEMI retry-param )
$PtRetryAfter    = qq{(?i:Retry-After)$PtHCOLON$PtDeltaSeconds(?:$PtComment)?(?:$PtSEMI$PtRetryParam)*};

# route-param     =  name-addr *( SEMI rr-param )
$PtRouteParam     = qq{$PtNameAddr(?:$PtSEMI$PtRrParam)*};

# Route           =  "Route" HCOLON route-param *(COMMA route-param)
$PtRoute          = qq{(?i:Route)$PtHCOLON$PtRouteParam(?:$PtCOMMA$PtRouteParam)*};

# product         =  token [SLASH product-version]
$PtProduct        = qq{$PtToken(?:$PtSLASH$PtToken)*};

# server-val      =  product / comment
$PtServerVal      = qq{(?:$PtProduct|$PtComment)};

# Server          =  "Server" HCOLON server-val *(LWS server-val)
$PtServer         = qq{(?i:Server)$PtHCOLON$PtServerVal(?:$PtLWS$PtServerVal)*};

# Subject         =  ( "Subject" / "s" ) HCOLON [TEXT-UTF8-TRIM]
$PtSubject        = qq{(?i:Subject|s)$PtHCOLON(?:$PtTEXTUTF8TRIM)?};

# Supported       =  ( "Supported" / "k" ) HCOLON [option-tag *(COMMA option-tag)]
$PtSupported      = qq{(?i:Supported|k)$PtHCOLON(?:$PtOptionTag(?:$PtCOMMA$PtOptionTag)*)?};

# delay           =  *(DIGIT) [ "." *(DIGIT) ]
$PtDelay          = qq{(?:$PtDigit)*(?:\\\.(?:$PtDigit)*)?};

# Timestamp       =  "Timestamp" HCOLON 1*(DIGIT) [ "." *(DIGIT) ] [ LWS delay ]
$PtTimestamp      = qq{(?i:Timestamp)$PtHCOLON(?:$PtDigit)+(?:\\\.(?:$PtDigit)*)?(?:$PtLWS$PtDelay)?};

# to-param        =  tag-param / generic-param
$PtToParam        = qq{(?:$PtTagParam|$PtGenericParam)};

# to-spec         =  ( name-addr / addr-spec ) *( SEMI to-param )
$PtToSpec         = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtToParam)*};

# To              =  ( "To" / "t" ) HCOLON ( name-addr / addr-spec ) *( SEMI to-param )
$PtTo             = qq{(?i:To|t)$PtHCOLON$PtToSpec};

# Unsupported     =  "Unsupported" HCOLON option-tag *(COMMA option-tag)
$PtUnsupported    = qq{(?i:Unsupported)$PtHCOLON$PtOptionTag(?:$PtCOMMA$PtOptionTag)*};

# User-Agent      =  "User-Agent" HCOLON server-val *(LWS server-val)
$PtUserAgent      = qq{(?i:User-Agent)$PtHCOLON$PtServerVal(?:$PtLWS$PtServerVal)*};

# sent-by         =  host [ COLON port ]
$PtSentBy         = qq{$PtHost(?:$PtCOLON$PtPort)?};

# transport       =  "UDP" / "TCP" / "TLS" / "SCTP" / other-transport
# $PtTransport      = qq{(?:(?i:UDP|TCP|TLS|SCTP)|$PtOtherTransport)};
$PtTransport      = qq{(?:$PtOtherTransport)};

# protocol-version=  token
$PtProtocolVersion= qq{$PtToken};

# protocol-name   =  "SIP" / token
$PtProtocolName   = qq{(?:(?i:SIP)|$PtToken)};

# sent-protocol   =  protocol-name SLASH protocol-version SLASH transport
$PtSentProtocol   = qq{$PtProtocolName$PtSLASH$PtProtocolVersion$PtSLASH$PtTransport};

# via-extension   =  generic-param
$PtViaExtension   = qq{$PtGenericParam};

# via-branch      =  "branch" EQUAL token
$PtViaBranch      = qq{(?i:branch)$PtEQUAL$PtToken};

# via-received    =  "received" EQUAL (IPv4address / IPv6address)
$PtViaReceived    = qq{(?i:received)$PtEQUAL(?:$PtIPv4address|$PtIPv6address)};

# via-maddr       =  "maddr" EQUAL host
$PtViaMaddr       = qq{(?i:maddr)$PtEQUAL$PtHost};

# via-ttl         =  "ttl" EQUAL ttl
$PtViaTtl         = qq{(?i:ttl)$PtEQUAL$PtTtl};

# via-params      =  via-ttl / via-maddr / via-received / via-branch / via-extension
$PtViaParams      = qq{(?:$PtViaTtl|$PtViaMaddr|$PtViaReceived|$PtViaBranch|$PtViaExtension)};

# via-parm        =  sent-protocol LWS sent-by *( SEMI via-params )
$PtViaParm        = qq{$PtSentProtocol$PtLWS$PtSentBy(?:$PtSEMI$PtViaParams)*};

# Via             =  ( "Via" / "v" ) HCOLON via-parm *(COMMA via-parm)
$PtVia            = qq{(?i:Via|v)$PtHCOLON$PtViaParm(?:$PtCOMMA$PtViaParm)*};

# WWW-Authenticate  =  "WWW-Authenticate" HCOLON challenge
$PtWWWAuthenticate= qq{(?i:WWW-Authenticate)$PtHCOLON$PtChallenge};

# pseudonym = token
$PtPseudonym = qq{$PtToken};

# warn-code = 3DIGIT
$PtWarnCode = qq{(?i:$PtDigit$PtDigit$PtDigit)};

# warn-agent = hostport / pseudonym
$PtWarnAgent = qq{(?:$PtHostport|$PtPseudonym)};

# warn-text = quoted-string
$PtWarnText = qq{$PtQuotedString}; 

#warning-value  = warn-code SP warn-agent SP warn-text
$PtWarningValue = qq{(?:(?:$PtWarnCode)(?:$PtSP$PtWarnAgent)(?:$PtSP$PtWarnText))};

# Warning  =  "Warning" HCOLON warning-value *(COMMA warning-value)
$PtWarning = qq{(?i:Warning)$PtHCOLON$PtWarningValue(?:$PtCOMMA$PtWarningValue)*};

# Proxy-Authenticate  =  "Proxy-Authenticate" HCOLON challenge
$PtProxyAuthenticate = qq{(?i:Proxy-Authenticate)$PtHCOLON$PtChallenge};

############# extension ##############
# -----------------------------
#        rfc3262
# -----------------------------
# CSeq-num          =  1*DIGIT
$PtCSeqNum          = qq{(?:$PtDigit)+};
# response-num      =  1*DIGIT
$PtResponseNum      = qq{(?:$PtDigit)+};
# RAck              =  "RAck" HCOLON response-num LWS CSeq-num LWS Method
$PtRAck             = qq{(?i:RAck)$PtHCOLON$PtResponseNum$PtLWS$PtCSeqNum$PtLWS$PtMethod};
# RSeq              =  "RSeq" HCOLON response-num
$PtRSeq             = qq{(?i:RSeq)$PtHCOLON$PtResponseNum};

# -----------------------------
#        rfc3265
# -----------------------------
# token-nodot       =  1*( alphanum / "-"  / "!" / "%" / "*" / "_" / "+" / "`" / "'" / "~" )
$PtTokenNodot       = qq{(?:$PtAlphanum|[\\\-!%\\\*_\\\+`'~])+};
# event-package     =  token-nodot
$PtEventPackage     = $PtTokenNodot;
# event-template    =  token-nodot
$PtEventTemplate    = $PtTokenNodot;
# event-param       =  generic-param / ( "id" EQUAL token )
$PtEventParam       = qq{(?:$PtGenericParam|(?i:id)$PtEQUAL$PtToken)};
# event-type        =  event-package *( "." event-template )
$PtEventType        = qq{(?:$PtEventPackage(?:\\\.$PtEventTemplate)*)};

# Event             =  ( "Event" / "o" ) HCOLON event-type *( SEMI event-param )
$PtEvent            = qq{(?i:Event|o)$PtHCOLON$PtEventType(?:$PtSEMI$PtEventParam)*};

# Allow-Events =  ( "Allow-Events" / "u" ) HCOLON event-type *(COMMA event-type)
$PtAllowEvents      = qq{(?i:Allow-Events|u)$PtHCOLON$PtEventType(?:$PtCOMMA$PtEventParam)*};

# extension-substate= token
$PtExtensionSubstate= $PtToken;
# event-reason-extension = token
$PtEventReasonExtension=$PtToken;
# event-reason-value=   "deactivated" / "probation" / "rejected" / "timeout" / "giveup" / "noresource" / event-reason-extension
# $PtEventReasonValue = qq{(?:(?i:deactivated|probation|rejected|timeout|giveup|noresource)|$PtEventReasonExtension)};
$PtEventReasonValue = qq{(?:$PtEventReasonExtension)};
# subexp-params     =   ("reason" EQUAL event-reason-value) / ("expires" EQUAL delta-seconds) / ("retry-after" EQUAL delta-seconds) / generic-param
$PtSubexpParams     = qq{(?:(?:(?i:reason)$PtEQUAL$PtEventReasonValue)|(?:(?i:expires)$PtEQUAL$PtDeltaSeconds)|(?:(?i:retry-after)$PtEQUAL$PtDeltaSeconds)|$PtGenericParam)};
# substate-value    = "active" / "pending" / "terminated" / extension-substate
# $PtSubstateValue    = qq{(?:(?i:active|pending|terminated)|$PtExtensionSubstate)};
$PtSubstateValue    = qq{(?:$PtExtensionSubstate)};

# Subscription-State= "Subscription-State" HCOLON substate-value *( SEMI subexp-params )
$PtSubscriptionState= qq{(?i:Subscription-State)$PtHCOLON$PtSubstateValue(?:$PtSEMI$PtSubexpParams)*};

# -----------------------------
#        rfc3515
# -----------------------------
# Refer-To          = ("Refer-To" / "r") HCOLON ( name-addr / addr-spec ) *
$PtReferTo          = qq{(?i:Refer-To|r)$PtHCOLON(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtGenericParam)*};
$PtReferToParam     = qq{(?:$PtTagParam|$PtGenericParam)};

# -----------------------------
#        rfc3323
# -----------------------------
# priv-value        =  "header" / "session" / "user" / "none" / "critical" / token
# $PtPrivValue        =  qq{(?:(?i:header|session|user|none|critical)|$PtToken)};
$PtPrivValue        =  qq{(?:$PtToken)};
# Privacy-hdr       =  "Privacy" HCOLON priv-value *(";" priv-value)
$PtPrivacy          =  qq{(?i:Privacy)$PtHCOLON$PtPrivValue(?:$PtSEMI$PtPrivValue)*};

# -----------------------------
#        rfc3325
# -----------------------------
# PAssertedID-value = name-addr / addr-spec
$PtPAssertedIDValue = qq{(?:$PtNameAddr|$PtAddrSpec)};
# PAssertedID       = "P-Asserted-Identity" HCOLON PAssertedID-value *(COMMA PAssertedID-value)
$PtPAssertedID      =  qq{(?i:P-Asserted-Identity)$PtHCOLON$PtPAssertedIDValue(?:$PtCOMMA$PtPAssertedIDValue)*};

# PPreferredID-value = name-addr / addr-spec
$PtPPreferredIDValue= qq{(?:$PtNameAddr|$PtAddrSpec)};
# PPreferredID      = "P-Preferred-Identity" HCOLON PPreferredID-value *(COMMA PPreferredID-value)
$PtPPreferredID     =  qq{(?i:P-Preferred-Identity)$PtHCOLON$PtPPreferredIDValue(?:$PtCOMMA$PtPPreferredIDValue)*};

# -----------------------------
#        rfc4028
# -----------------------------
### draft-ietf-sip-session-timer-15 Sec.4,5 
# refresher-param   = 'refresher' EQUAL  ('uas' / 'uac')
$PtRefresherParam   = qq{(?:(?i:refresher)$PtEQUAL(?i:uas|uac))};

# se-params         = refresher-param / generic-param
$PtSEParams         = qq{(?:$PtRefresherParam|$PtGenericParam)};

# Session-Expires   = ('Session-Expires' / 'x') HCOLON delta-seconds *(SEMI se-params)
$PtSessionExpires   = qq{(?i:Session-Expires|x)$PtHCOLON$PtDeltaSeconds(?:$PtSEMI$PtSEParams)*};

# Min-SE            =  'Min-SE' HCOLON delta-seconds *(SEMI generic-param)
$PtMinSE            = qq{(?i:Min-SE)$PtHCOLON$PtDeltaSeconds(?:$PtSEMI$PtGenericParam)*};

# -----------------------------
#        rfc3892
# -----------------------------
# atom   = 1*( alphanum / "-" / "!" / "%" / "*" / "_" / "+" / "`" / "'" / "~" )
$PtAtom = qq{(?:$PtAlphanum|[\\\-!%\\\*_\\\+`'~])+};

# dot-atom = atom *( "." atom )
$PtDotAtom = qq{$PtAtom(?:\\\.$PtAtom)*};

# sip-clean-msg-id = LDQUOT dot-atom "@" (dot-atom / host) RDQUOT
$PtSipCleanMsgId = qq{$PtLDQUOT$PtDotAtom\@(?:$PtDotAtom|$PtHost)$PtRDQUOT}; 

# referredby-id-param = "cid" EQUAL sip-clean-msg-id 
$PtReferredByIdParam = qq{(?:cid)$PtEQUAL$PtSipCleanMsgId};

# referrer-uri = (name-addr / addr-spec)
$PtReferrerUri = qq{(?:$PtNameAddr|$PtAddrSpec)};

# Referred-By = ("Referred-By" / "b") HCOLON referrer-uri *(SEMI (referredby-id-param / generic-param) )
$PtReferredBy = qq{(?i:Referred-By|b)$PtHCOLON$PtReferrerUri(?:$PtSEMI(?:$PtReferredByIdParam|$PtGenericParam))*};

# -----------------------------
#        rfc3608
# -----------------------------
# Service-Route = "Service-Route" HCOLON sr-value *( COMMA sr-value)
$PtServiceRoute = qq{(?i:Service-Route)$PtHCOLON$PtRouteParam(?:$PtCOMMA$PtRouteParam)*};
# sr-value        = name-addr *( SEMI rr-param )  == route-param

# -----------------------------
#        rfc3329
# -----------------------------
# extension        = generic-param
# digest-verify    = "d-ver" EQUAL LDQUOT 32LHEX RDQUOT
$PtDigestVerify    = qq{(?:(?i:d-ver)$PtEQUAL$PtRequestDigest)};

# digest-qop       = "d-qop" EQUAL token
$PtDigestQop       = qq{(?:(?i:d-qop)$PtEQUAL$PtToken)};

# digest-algorithm = "d-alg" EQUAL token
$PtDigestAlgorithm = qq{(?:(?i:d-alg)$PtEQUAL$PtToken)};

# qvalue           = ( "0" [ "." 0*3DIGIT ] )  / ( "1" [ "." 0*3("0") ] )
# preference       = "q" EQUAL qvalue  ==> c-p-q

# mech-parameters  = ( preference / digest-algorithm / digest-qop / digest-verify / extension )
$PtMechParameters  = qq{(?:$PtCPQ|$PtDigestAlgorithm|$PtDigestQop|$PtDigestVerify|$PtGenericParam)};

# mechanism-name   = ( "digest" / "tls" / "ipsec-ike" / "ipsec-man" / token )
# $PtMechanismName   = qq{(?:(?i:digest|tls|ipsec-ike|ipsec-man)|$PtToken)};
$PtMechanismName   = qq{(?:$PtToken)};

# sec-mechanism    = mechanism-name *(SEMI mech-parameters)
$PtSecMechanism    = qq{$PtMechanismName(?:$PtSEMI$PtMechParameters)*};

# security-client  = "Security-Client" HCOLON sec-mechanism *(COMMA sec-mechanism)
$PtSecurityClient  = qq{(?i:Security-Client)$PtHCOLON$PtSecMechanism(?:$PtCOMMA$PtSecMechanism)*};

# security-server  = "Security-Server" HCOLON sec-mechanism *(COMMA sec-mechanism)
$PtSecurityServer  = qq{(?i:Security-Server)$PtHCOLON$PtSecMechanism(?:$PtCOMMA$PtSecMechanism)*};

# security-verify  = "Security-Verify" HCOLON sec-mechanism *(COMMA sec-mechanism)
$PtSecurityVerify  = qq{(?i:Security-Verify)$PtHCOLON$PtSecMechanism(?:$PtCOMMA$PtSecMechanism)*};

# -----------------------------
#        rfc4244
# -----------------------------
# hi-extension     = generic-param
# hi-index         = "index" EQUAL 1*DIGIT *(DOT 1*DIGIT)
$PtHiIndex         = qq{(?:(?i:index)$PtEQUAL$PtDigit(?:\.$PtDigit)*)};

# hi-param         = hi-index / hi-extension
$PtHiParam         = qq{(?:$PtHiIndex|$PtGenericParam)};

# hi-targeted-to-uri= name-addr
# hi-entry         = hi-targeted-to-uri *( SEMI hi-param )
$PtHiEntry         = qq{$PtNameAddr(?:$PtSEMI$PtHiParam)*};

# History-Info     = "History-Info" HCOLON hi-entry *(COMMA hi-entry)
$PtHistoryInfo     = qq{(?i:History-Info)$PtHCOLON$PtHiEntry(?:$PtCOMMA$PtHiEntry)*};

# -----------------------------
#        rfc3326
# -----------------------------
# reason-extension  =  generic-param
# reason-text       =  "text" EQUAL quoted-string
$PtReasonText       = qq{(?:(?i:text)$PtEQUAL$PtQuotedString)};

# cause             =  1*DIGIT
# protocol-cause    =  "cause" EQUAL cause
$PtProtocolCause    = qq{(?:(?i:cause)$PtEQUAL(?:$PtDigit)+)};

# reason-params     =  protocol-cause / reason-text / reason-extension
$PtReasonParams     = qq{(?:$PtProtocolCause|$PtReasonText|$PtGenericParam)};

# protocol          =  "SIP" / "Q.850" / token
# reason-value      =  protocol *(SEMI reason-params)
$PtReasonValue      =  qq{$PtToken(?:$PtSEMI$PtReasonParams)*};

# Reason            = "Reason" HCOLON reason-value *(COMMA reason-value)
$PtReason           = qq{(?i:Reason)$PtHCOLON$PtReasonValue(?:$PtCOMMA$PtReasonValue)*};


# -----------------------------
#        rfc3327
# -----------------------------
# path-value       = name-addr *( SEMI rr-param ) ==> rec-route
# Path             = "Path" HCOLON path-value *( COMMA path-value )
$PtPath            = qq{(?i:Path)$PtHCOLON$PtRecRoute(?:$PtCOMMA$PtRecRoute)*};

# -----------------------------
#        rfc3455
# -----------------------------
# ai-param         = generic-param
# p-aso-uri-spec   = name-addr *( SEMI ai-param ) ==> rec-route
# P-Associated-URI = "P-Associated-URI" HCOLON (p-aso-uri-spec) *(COMMA p-aso-uri-spec)
$PtPAssociatedURI  = qq{(?i:P-Associated-URI)$PtHCOLON(?:$PtRecRoute)?(?:$PtCOMMA$PtRecRoute)*};

# cpid-param       = generic-param
# called-pty-id-spec = name-addr *( SEMI cpid-param) ==> rec-route
# P-Called-Party-ID = "P-Called-Party-ID" HCOLON called-pty-id-spec
$PtPCalledPartyID  = qq{(?i:P-Called-Party-ID)$PtHCOLON$PtRecRoute(?:$PtCOMMA$PtRecRoute)*};

# vnetwork-param   = generic-param
# vnetwork-spec    = (token / quoted-string) *( SEMI vnetwork-param)
$PtVvnetworkSpec   = qq{(?:$PtToken|$PtQuotedString)(?:$PtSEMI$PtGenericParam)*};
# P-Visited-Network-ID = "P-Visited-Network-ID" HCOLON vnetwork-spec *(COMMA vnetwork-spec)
$PtPVisitedNetworkID = qq{(?i:P-Visited-Network-ID)$PtHCOLON$PtVvnetworkSpec(?:$PtCOMMA$PtVvnetworkSpec)*};

# utran-cell-id-3gpp = "utran-cell-id-3gpp" EQUAL (token / quoted-string)
$PtUtranCellId3gpp = qq{(?i:utran-cell-id-3gpp)$PtEQUAL$PtMValue};
# cgi-3gpp         = "cgi-3gpp" EQUAL (token / quoted-string)
$PtCgi3gpp         = qq{(?i:cgi-3gpp)$PtEQUAL$PtMValue};
# extension-access-info  = gen-value
# access-info      = cgi-3gpp / utran-cell-id-3gpp / extension-access-info
$PtAccessInfo      = qq{(?:$PtCgi3gpp|$PtUtranCellId3gpp|$PtGenericParam)};
# access-type      = "IEEE-802.11a" / "IEEE-802.11b" / "3GPP-GERAN" / "3GPP-UTRAN-FDD" / "3GPP-UTRAN-TDD" / "3GPP-CDMA2000" / token
# $PtAccessType      = qq{(?:(?i:IEEE-802.11a|IEEE-802.11b|3GPP-GERAN|3GPP-UTRAN-FDD|3GPP-UTRAN-TDD|3GPP-CDMA2000)|$PtToken)};
$PtAccessType      = qq{(?:$PtToken)};
# access-net-spec  = access-type *( SEMI access-info)
# P-Access-Network-Info  = "P-Access-Network-Info" HCOLON access-net-spec
$PtPAccessNetworkInfo = qq{(?i:P-Access-Network-Info)$PtHCOLON$PtAccessType(?:$PtSEMI$PtAccessInfo)*};

# ecf              = "ecf" EQUAL gen-value
$PtEcf             = qq{(?:(?i:ecf)$PtEQUAL$PtGenValue)};
# ccf              = "ccf" EQUAL gen-value
$PtCcf             = qq{(?:(?i:ccf)$PtEQUAL$PtGenValue)};
# charge-addr-params = ccf / ecf / generic-param
$PtChargeAddrParams= qq{(?:$PtCcf|$PtEcf|$PtGenericParam)};
# P-Charging-Addr  = "P-Charging-Function-Addresses" HCOLON charge-addr-params *( SEMI charge-addr-params)
$PtPChargingAddr   = qq{(?i:P-Charging-Function-Addresses)$PtHCOLON$PtChargeAddrParams(?:$PtSEMI$PtChargeAddrParams)*};

# term-ioi         = "term-ioi" EQUAL gen-value
$PtTermIoi         = qq{(?:(?i:term-ioi)$PtEQUAL$PtGenValue)};
# orig-ioi         = "orig-ioi" EQUAL gen-value
$PtOrigIoi         = qq{(?:(?i:orig-ioi)$PtEQUAL$PtGenValue)};
# icid-gen-addr    = "icid-generated-at" EQUAL host
$PtIcidGenAddr     = qq{(?:(?i:icid-generated-at)$PtEQUAL$PtGenValue)};
# icid-value       = "icid-value" EQUAL gen-value
$PtIcidValue       = qq{(?:(?i:icid-value)$PtEQUAL$PtGenValue)};
# charge-params    = icid-gen-addr / orig-ioi / term-ioi / generic-param
$PtChargeParams    = qq{(?:$PtIcidGenAddr|$PtOrigIoi|$PtTermIoi|$PtGenericParam)};
# P-Charging-Vector= "P-Charging-Vector" HCOLON icid-value *( SEMI charge-params)
$PtPChargingVector = qq{(?i:P-Charging-Vector)$PtHCOLON$PtIcidValue(?:$PtSEMI$PtChargeParams)*};

# -----------------------------
#        sip-privacy-01
# -----------------------------

# other-rpi-token    = token ["=" (token | quoted-string)]
$PtOtherRpiToken     = qq{(?:$PtToken(?:=(?:$PtToken|$PtQuotedString))?)};

# rpi-privacy        = "privacy" "=" 1#( ("full" | "name" | "uri" | "off" | token ) [ "-" ( "network" | token ) ]  )
$PtRpiPrivacy        = qq{(?:privacy=(?:(?:full|name|uri|off|$PtToken)(?:-(?:network|$PtToken))?))};

# rpi-id-type        = "id-type" "=" ( "subscriber" | "user" | "alias" | "return" | "term"  | token )
$PtRpiIdType         = qq{(?:id-type=(?:subscriber|user|alias|return|term|$PtToken))};

# rpi-pty-type       = "party" "=" ( "calling" | "called"  | token )
$PtRpiPtyType        = qq{(?:party=(?:calling|called|$PtToken))};

# rpi-screen         = "screen" "=" ("no" | "yes" )
$PtRpiScreen         = qq{(?:screen=(?:no|yes))};

# rpi-token          = rpi-screen | rpi-pty-type | rpi-id-type | rpi-privacy | other-rpi-token
$PtRpiToken          = qq{(?:$PtRpiScreen|$PtRpiScreen|$PtRpiPtyType|$PtRpiIdType|$PtRpiPrivacy|$PtOtherRpiToken)};

# Remote-Party-ID    = "Remote-Party-ID" ":" [display-name] "<" addr-spec ">" *(";" rpi-token)
$PtRemotePartyID     = qq{(?i:Remote-Party-ID)$PtHCOLON(?:$PtDisplayName)?$PtLAQUOT$PtAddrSpec$PtRAQUOT(?:$PtSEMI$PtRpiToken)*};


############# SDP ##############################
# RFC 2327 4566

# space =               %d32
$PtSpace                = q{(?: )};

# tab =                 %d9
$PtTab                  = q{(?:\xd9)};

# CRLF =                %d13.10

# safe =                alpha-numeric |
#                       "'" | "'" | "-" | "." | "/" | ":" | "?" | """ |
#                       "#" | "$" | "&" | "*" | ";" | "=" | "@" | "[" |
#                       "]" | "^" | "_" | "`" | "{" | "|" | "}" | "+" |
#                       "~" | "
$PtSafe                 = qq{(?:$PtAlphanum|['\\\-\\\.\\/:\\\?"#\\\$&\\\*;=\\\@\\\[\\\]^_`\\\{\\\|\\\}\\\+~])};
$PtSafe2                = qq{(?:$PtAlphanum|[' \\\-\\\.\\/:\\\?"#\\\$&\\\*\\\@\\\[\\\]^_`\\\{\\\|\\\}\\\+~])};

# email-safe =          safe | space | tab
$PtEmailSafe            = qq{(?:$PtSafe|$PtSpace|$PtTab)+};

# ALPHA =               "a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|
#                       "l"|"m"|"n"|"o "|"p"|"q"|"r"|"s"|"t"|"u"|"v"|
#                       "w"|"x"|"y"|"z"|"A"|"B"|"C "|"D"|"E"|"F"|"G"|
#                       "H"|"I"|"J"|"K"|"L"|"M"|"N"|"O"|"P"|" Q"|"R"|
#                       "S"|"T"|"U"|"V"|"W"|"X"|"Y"|"Z"

# POS_DIGIT             %x31-39                 ; 0 is not an allowed backref
$PtPosDigit             = q{(?:[1-9])};

# integer =             POS-DIGIT *(DIGIT)
$PtInteger              =qq{(?:0|(?:$PtPosDigit)(?:$PtDigit)*)};

# float                 =  integer [.*DIGIT]
$PtFloat                = qq{(?:$PtDigit)+(?:\\\.(?:$PtDigit)*)?};

# decimal-uchar =       DIGIT | POS-DIGIT DIGIT | ("1" 2*(DIGIT)) | ("2" ("0"|"1"|"2"|"3"|"4") DIGIT)
#                             | ("2" "5" ("0"|"1"|"2"|"3"|"4"|"5"))

#   byte-string   =   1*(0x01..0x09|0x0b|0x0c|0x0e..0xff)
#$PtByteString     = qq{(?:0x[0-9a-f][0-9a-f])+};
$PtByteString     = qq{(?:[^\r\n]+)};

# text =                byte-string
#                       ;
#                       ;
$PtText                 =$PtByteString;

# unicast-address =     IP4-address | IP6-address
$PtUnicastAaddress      = qq{(?:$PtIPv4address|$PtIPv6address)};

# FQDN =                4*(alpha-numeric|"-"|".")
#                       ;RFC1035
$PtFQDN                 = qq{(?:$PtAlphanum|[-\\\.])+};

# addr =                FQDN | unicast-address
$PtAddr                 = qq{(?:$PtUnicastAaddress|$PtFQDN)};

# addrtype =            "IP4" | "IP6
$PtAddrType             = q{(?:IP4|IP6)};

# nettype =             "IN"
$PtNetType              = q{(?:IN)};

# phone =               "+" POS-DIGIT 1*(space | "-" | DIGIT)
#                       ;
$PtPhone                = qq{(?:\\\+)$PtPosDigit(?:[0-9 -])+};

# phone-number =        phone | phone "(" email-safe ")" | email-safe "<" phone ">"
$PtPhoneNumber          = qq{(?:$PtPhone|$PtPhone\\\($PtEmailSafe\\\)|$PtEmailSafe<$PtPhone>)};

# uri=                  ;RFC1630p
# $PtURI

# email =               ;RFC822
#   RFC822: address     =  mailbox / group
#           addr-spec   =  local-part "@" domain
# $PtSrvr
$PtEmail                = $PtSrvr;

# email-address =       email | email "(" email-safe ")" | email-safe "<" email ">"
#   ( 
$PtEmailAddress         = qq{(?:$PtEmail(?:$PtSpace)*\\\($PtEmailSafe\\\)|$PtEmailSafe<$PtEmail>|$PtEmail)};

# username =            safe
#                       ;
$PtSafeUsername         = qq{(?:$PtSafe)+};

# bandwidth =           1*(DIGIT)
$PtBandwidth            =qq{(?:$PtDigit)+};

# bwtype =              1*(alpha-numeric)      ;;; add -
$PtBwtype               =qq{(?:$PtAlphanum|-)+};

# fixed-len-time-unit = "d" | "h" | "m" | "s"
$PtFixedLenTimeUnit     =q{(?:[dhms])};

# typed-time =          1*(DIGIT) [fixed-len-time-unit]
$PtTypedTime            =qq{(?:$PtDigit)+(?:$PtFixedLenTimeUnit)?};

# repeat-interval =     typed-time
$PtRepeatInterval       =$PtTypedTime;

# time =                POS-DIGIT 9*(DIGIT)
#                       ;2
$PtTime                 =qq{$PtPosDigit(?:$PtDigit)+};

# stop-time =           time | "0"
$PtStopTime             =qq{(?:$PtTime|0)};

# start-time =          time | "0"
$PtStartTime            =qq{(?:$PtTime|0)};

# ttl =                 decimal-uchar

# multicast-address =   3*(decimal-uchar ".") decimal-uchar "/" ttl [ "/" integer ]
#                       ;
$PtMulticastAddress    =qq{$PtIPv4address(?:\\/)(?:$PtDigit){1,3}};

# connection-address =  multicast-address | addr
$PtConnectionAddress    =qq{(?:$PtMulticastAddress|$PtAddr)};

# sess-version =        1*(DIGIT)
#                       ;
$PtSessVersion          =qq{(?:$PtDigit)+};

# sess-id =             1*(DIGIT)
#                       ;
$PtSessId               =qq{(?:$PtDigit)+};

# att-value =           byte-string
$PtAttValue             =qq{$PtByteString};

## att-value =           [^;]+ [; [^;]+ = [^;]+ ]*      ;;;   by ota
#$PtAttValue             =qq{(?:(?:$PtSafe2)+(?:;(?:$PtSafe2)+=(?:$PtSafe2)+)*)};

# att-field =           1*(alpha-numeric)   ;;; add '-'   by ota
$PtAttField             =qq{(?:$PtAlphanum|\-)+};

# attribute =           (att-field ":" att-value) | att-field
$PtAttribute            =qq{(?:(?:$PtAttField:$PtAttValue)|$PtAttField)};

# port =                1*(DIGIT)
#                       ;UDP

# proto  =              token *("/" token)  # RFC4566
# proto =               1*(alpha-numeric)
#                       ;
$PtProto                =qq{(?:$PtAlphanum|/)+};

# fmt =                 1*(alpha-numeric)
#                       ;
$PtFmt                  =qq{(?:$PtAlphanum)+};

# media =               1*(alpha-numeric)
#                       ;
$PtMedia                =q{(?:audio|video|application|data)};

# media-field =         "m=" media space port ["/" integer] space proto 1*(space fmt) CRLF
$PtMediaField           =qq{(?i:m)=(?:$PtMedia$PtSpace$PtPort(?:\\/(?:$PtInteger))?$PtSpace$PtProto(?:$PtSpace$PtFmt)+$PtCRLF)};

# attribute-fields =    *("a=" attribute CRLF)
$PtAttributeFields      =qq{(?i:a)=(?:$PtAttribute$PtCRLF)};

# key-data =            email-safe | "~" | "
$PtKeyData              =qq{(?:$PtEmailSafe|~)};

# key-type =            "prompt" | "clear:" key-data | "base64:" key-data | "uri:" uri
$PtKeyType              =qq{(?:prompt|clear:|$PtKeyData|base64:$PtKeyData|uri:$PtURI)};

# key-field =           ["k=" key-type CRLF]
$PtKeyField             =qq{(?i:k)=(?:$PtKeyType$PtCRLF)};

# zone-adjustments =    "z=" time space ["-"] typed-time *(space time space ["-"] typed-time)  ;; add "z="
$PtZoneAdjustments      =qq{(?:(?i:z)=$PtTime$PtSpace(?:-)?$PtTypedTime(?:$PtSpace$PtTime$PtSpace(?:-)?$PtTypedTime)*)};

# repeat-fields =       "r=" repeat-interval space typed-time 1*(space typed-time)
$PtRepeatFields         =qq{(?i:r)=(?:$PtRepeatInterval$PtSpace$PtTypedTime(?:$PtSpace$PtTypedTime)*)};

# time-fields =         1*( "t=" start-time space stop-time *(CRLF repeat-fields) CRLF) [zone-adjustments CRLF]
$PtTimeFields           =qq{(?:(?i:t)=(?:$PtStartTime$PtSpace$PtStopTime(?:$PtCRLF$PtRepeatFields)*$PtCRLF))+(?:$PtZoneAdjustments$PtCRLF)?};

# bandwidth-fields =    *("b=" bwtype ":" bandwidth CRLF)
$PtBandwidthFields      =qq{(?i:b)=$PtBwtype:$PtBandwidth$PtCRLF};

# connection-field =    ["c=" nettype space addrtype space connection-address CRLF]
#                       ;connection field
$PtConnectionField      =qq{(?i:c)=(?:$PtNetType$PtSpace$PtAddrType$PtSpace$PtConnectionAddress$PtCRLF)};

# phone-number =        phone | phone "(" email-safe ")" | email-safe "<" phone ">"
$PtPhoneNumber          = qq{(?:$PtPhone\\\($PtEmailSafe\\\)|$PtEmailSafe<$PtPhone>|$PtPhone)};

# phone-fields =        *("p=" phone-number CRLF)
$PtPhoneFields          =qq{(?i:p)=(?:$PtPhoneNumber$PtCRLF)};

# email-fields =        *("e=" email-address CRLF)
$PtEmailFields          =qq{(?i:e)=(?:$PtEmailAddress$PtCRLF)};

# uri-field =           ["u=" uri CRLF]
$PtUriField             =qq{(?i:u)=(?:$PtURI$PtCRLF)};

# information-field =   ["i=" text CRLF]
$PtInformationField     =qq{(?i:i)=(?:$PtText$PtCRLF)};

# session-name-field =  "s=" text CRLF
$PtSessionNameField      =qq{(?i:s)=(?:$PtText$PtCRLF)};

# origin-field =        "o=" username space sess-id space sess-version space nettype space addrtype space addr CRLF
$PtOriginField           =qq{(?i:o)=$PtSafeUsername$PtSpace$PtSessId$PtSpace$PtSessVersion$PtSpace$PtNetType$PtSpace$PtAddrType$PtSpace$PtAddr$PtCRLF};

# proto-version =       "v=" 1*DIGIT CRLF
$PtProtoVersion          =qq{(?i:v)=(?:$PtDigit)+$PtCRLF};

# media-descriptions =  *( media-field information-field *(connection-field) bandwidth-fields key-field attribute-fields )
$PtMediaDescriptions    =qq{(?:$PtMediaField(?:$PtInformationField)?(?:$PtConnectionField)*(?:$PtBandwidthFields)*(?:$PtKeyField)?(?:$PtAttributeFields)*)};

# announcement =        proto-version origin-field session-name-field information-field uri-field email-fields
#                       phone-fields  connection-field bandwidth-fields time-fields key-field attribute-fields
#                       media-descriptions
$PtAnnouncement         =qq{$PtProtoVersion$PtOriginField$PtSessionNameField(?:$PtInformationField)?(?:$PtUriField)?(?:$PtEmailFields)*(?:$PtPhoneFields)?(?:$PtConnectionField)?(?:$PtBandwidthFields)*$PtTimeFields(?:$PtKeyField)?(?:$PtAttributeFields)*(?:$PtMediaDescriptions)*};


################################################

# Request         =  Request-Line *( message-header ) CRLF [ message-body ]
$PtRequest        = qq{$PtRequestLine(?:$PtMessageHeader)*$PtCRLF(?:$PtMessageBody)?};

# Response        =  Status-Line *( message-header ) CRLF [ message-body ]
$PtResponse       = qq{$PtStatusLine(?:$PtMessageHeader)*$PtCRLF(?:$PtMessageBody)?};

# SIP-message     =  Request / Response
# $PtSIPMessage     = qq{$PtRequest|$PtResponse};
$PtSIPMessage     = "^(?:[^\r\n]+)$PtCRLF(?:[^\r\n]+$PtCRLF)+$PtCRLF(?:[^\r\n]+$PtCRLF?)*";
$PtSIPMessageMT   = "^((?:[^\r\n]+))$PtCRLF((?:[^\r\n]+$PtCRLF)+)$PtCRLF((?:[^\r\n]+$PtCRLF?)*)";

## DEF.END


1;
