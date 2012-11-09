#!/usr/bin/perl 
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
#use strict;

# SIP 
#  qq{}
#  q{}
#  |
#  
#  [*XXX | YYY] 
#  OR
#  perl 

$PtCRLF            = "\r\n";
$PtDigit           = q{[0-9]};
$PtHex             = qq{(?:$PtDigit|[A-Fa-f])};
$PtUpalpha         = q{[A-Z]};
$PtLowalpha        = q{[a-z]};
$PtAlpha           = qq{(?:$PtLowalpha|$PtUpalpha)};

# alphanum         =  ALPHA / DIGIT
$PtAlphanum        = qq{(?:$PtAlpha|$PtDigit)};

# reserved         =  ";" / "/" / "?" / ":" / "@" / "&" / "=" / "+" / "$" / ","
$PtReserved        = q{(?:[;/\?:\@&=\+\$,])};

# mark             =  "-" / "_" / "." / "!" / "~" / "*" / "'" / "(" / ")"
$PtMark            = q{[\-_\.!~\*'\(\)]};

# unreserved       =  alphanum / mark
$PtUnreserved      = qq{(?:$PtAlphanum|$PtMark)};

# escaped          =  "%" HEXDIG HEXDIG
$PtEscaped         = qq{%$PtHex$PtHex};

# LWS              = [*WSP CRLF] 1*WSP
$PtLWS             = q{(?:(?:\s)*\r\n)?(?:\s)+};   # 2003/12/15
#$PtLWS             = q{(?:(?:\s)*\r\n)?(?:\s)?};


# SWS              = [LWS] ; sep whitespace
$PtSWS             = qq{(?:$PtLWS)?};
#$PtSWS            = q{(?:\s|\r\n)+?};

# HCOLON           =  *( SP / HTAB ) ":" SWS
$PtHCOLON          = qq{(?:\\s*?:$PtSWS)};         # 2003/12/15
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

# token            =  1*(alphanum / "-" / "." / "!" / "%" / "*" / "_" / "+" / "`" / "'" / "~" )
$PtToken           = qq{(?:$PtAlphanum|[\\\-\\\.!%\\\*_\\\+`'~])+};

# separators       =  "(" / ")" / "<" / ">" / "@" / "," / ";" / ":" / "\\" / DQUOTE / "/" / "[" / "]" / "?" / "=" /
#                       "{" / "}" / SP / HTAB
$PtSeparators      = q{[\(\)<>\@,;:\\\"/[]\?={}\s]};

# word             =  1*(alphanum / "-" / "." / "!" / "%" / "*" / "_" / "+" / "`" / "'" / "~" /
#                       "(" / ")" / "<" / ">" / ":" / "\" / DQUOTE /  "/" / "[" / "]" / "?" / "{" / "}" )
$PtWord            = qq{(?:$PtAlphanum|[\\\-\\\.!%\\\*_\\\+`'~\\\(\\\)<>:"/\\\[\\\]\\\?\\\{\\\}])+};

# STAR             =  SWS "*" SWS ; 
$PtSTAR            = qq{(?:$PtSWS\\\*$PtSWS)};

# SLASH            =  SWS "/" SWS ; 
$PtSLASH           = qq{(?:$PtSWS/$PtSWS)};

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

# quoted-pair      = "\\" (%x00-09 / %x0B-0C / %x0E-7F)
$PtQuotedPair     =  q{\\\(?:[\x00-\x09]|[\x0B-\x0C]|[\x0E-\x7F])};

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
$PtUserUnreserved = q{[&=\+\$,;\?/]};

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
$PtToplabel       = qq{(?:(?:$PtAlpha(?:$PtAlpha|-)*$PtAlphanum)|$PtAlpha)};

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
$PtParamUnreserved= q{[\[\]/:&\+\$]};

# paramchar       =  param-unreserved / unreserved / escaped
$PtParamchar      = qq{$PtParamUnreserved|$PtUnreserved|$PtEscaped};

# pname           =  1*paramchar
$PtPname          = qq{(?:$PtParamchar)+};

# pvalue          =  1*paramchar
$PtPvalue         = qq{(?:$PtParamchar)+};

# hnv-unreserved  =  "[" / "]" / "/" / "?" / ":" / "+" / "\$"
$PtHnvUnreserved  = q{[\[\]/\?:\+\$]};

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
$PtSegment        = qq{(?:$PtPchar)*(?:;$PtParam)*};

# path-segments   =  segment *( "/" segment )
$PtPathSegments    = qq{$PtSegment(?:/$PtSegment)*};

# abs-path        =  "/" path-segments
$PtAbsPath        = qq{/$PtPathSegments};

# reg-name        =  1*( unreserved / escaped / "\$" / "," / ";" / ":" / "@" / "&" / "=" / "+" )
$PtRegName        = qq{(?:$PtUnreserved|$PtEscaped|(?:[\\\$,;:\@&=\\\+]))+};

# hostport        =  host [ ":" port ]
$PtHostport       = qq{$PtHost(?::$PtPort)?};

# telephone-subscriber = 
# $PtTelephoneSubscriber =

# userinfo        =  ( user / telephone-subscriber ) [ ":" password ] "@"
# $PtUserinfo       = qq{(?:(?:$PtUser|$PtTelephoneSubscriber)(?::$PtPassword)?@)};
$PtUserinfo       = qq{(?:$PtUser(?::$PtPassword)?\@)};

# srvr            =  [ [ userinfo "@" ] hostport ]
$PtSrvr           = qq{(?:$PtUserinfo\@)?$PtHostport};

# authority       =  srvr / reg-name
$PtAuthority      = qq{$PtSrvr|$PtRegName};

# net-path        =  "//" authority [ abs-path ]
$PtNetPath        = qq{//$PtAuthority(?:$PtAbsPath)?};

# uric            =  reserved / unreserved / escaped
$PtUric           = qq{$PtReserved|$PtUnreserved|$PtEscaped};

# uric-no-slash   =  unreserved / escaped / ";" / "?" / ":" / "@" / "&" / "=" / "+" / "\$" / ","
$PtUricNoSlash    = qq{$PtUnreserved|$PtEscaped|(?:[;\\\?:\@&=\+\\\$,])};

# query           =  *uric
$PtQuery          = qq{(?:$PtUric)*?};

# SIP-Version     =  "SIP" "/" 1*DIGIT "." 1*DIGIT
$PtSIPVersion     = qq{SIP\/(?:$PtDigit)+\\\.(?:$PtDigit)+};

# hier-part       =  ( net-path / abs-path ) [ "?" query ]
$PtHierPart       = qq{(?:$PtNetPath|$PtAbsPath)(?:\\\?$PtQuery)?};

# opaque-part     =  uric-no-slash *uric
$PtOpaquePart     = qq{$PtUricNoSlash(?:$PtUric)*?};

# extension-method =  token
$PtExtensionMethod = qq{$PtToken};

# Method          =  INVITEm / ACKm / OPTIONSm / BYEm / CANCELm / REGISTERm / SUBSCRIBEm / NOTIFYm / REFERm / PRACKm / UPDATEm / INFOm / MESSAGEm / PUBLISHm / extension-method
$PtMethod         = qq{(?:(?-i:INVITE|ACK|OPTIONS|BYE|CANCEL|REGISTER|SUBSCRIBE|NOTIFY|REFER|PRACK|UPDATE|INFO|MESSAGE|PUBLISH)|$PtExtensionMethod)};

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
$PtUserParam      = qq{(?:(?i:user)=(?:(?i:phone|ip)|$PtOtherUser))};

# transport-param =  "transport=" ( "udp" / "tcp" / "sctp" / "tls" / other-transport)
$PtTransportParam = qq{(?:(?i:transport)=(?:(?i:udp|tcp|sctp|tls)|$PtOtherTransport))};

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
$PtSIPUri         = qq{sip:(?:$PtUserinfo)?$PtHostport$PtUriParameters(?:$PtHeaders)?};

# SIPS-URI        = "sips:" [ userinfo ] hostport uri-parameters [ headers ]
$PtSIPSUri        = qq{sips:(?:$PtUserinfo)?$PtHostport$PtUriParameters(?:$PtHeaders)?};

# Reason-Phrase   =  *(reserved / unreserved / escaped / UTF8-NONASCII / UTF8-CONT / SP / HTAB)
$PtReasonPhrase   = qq{(?:$PtReserved|$PtUnreserved|$PtEscaped|$PtUTF8NONASCII|$PtUTF8CONT|\\s)*};

# SIP-Version     =  "SIP" "/" 1*DIGIT "." 1*DIGIT
$PtSIPVersion     = qq{SIP\/(?:$PtDigit)+\\\.(?:$PtDigit)+};

# Request-URI     =  SIP-URI / SIPS-URI / absoluteURI
$PtRequestURI     = qq{(?:$PtSIPUri|$PtSIPSUri|$PtAbsoluteUri)};

# Request-Line    =  Method SP Request-URI SP SIP-Version CRLF
$PtRequestLine    = qq{$PtMethod\\s$PtRequestURI\\s$PtSIPVersion};

# Status-Line     =  SIP-Version SP Status-Code SP Reason-Phrase CRLF
$PtStatusLine     = qq{(?:$PtSIPVersion\\s(?:$PtDigit){1,3}\\s$PtReasonPhrase)};

##################################################################################

# qvalue          =  ( "0" [ "." 0*3DIGIT ] ) / ( "1" [ "." 0*3("0") ] )
$PtQvalue         = qq{(?:(?:0(?:\\\.(?:$PtDigit){0,3})?)|(?:1(?:\\\.0{0,3})?))};

# nonce-value     =  quoted-string
$PTNonceValue     = qq{$PtQuotedString};

# delta-seconds   =  1*DIGIT
$PtDeltaSeconds   = qq{$PtDigit+};

# Allow           =  "Allow" HCOLON [Method *(COMMA Method)]
$PtAllow          = qq{(?i:Allow)$PtHCOLON(?:$PtMethod(?:$PtCOMMA$PtMethod)*)?};

# rr-param        =  generic-param
$PtRrParam        = qq{$PtGenericParam};

# qop-value       =  "auth" / "auth-int" / token
#$PtQopValue       = qq{(?:(?i:auth-int|auth)|$PtToken)};    # 040301 
$PtQopValue       = qq{(?:$PtToken)}; # 20060207 maeda FIX

# qop-options     =  "qop" EQUAL LDQUOT qop-value *("," qop-value) RDQUOT
$PtQopOptions     = qq{(?i:qop)$PtEQUAL$PtLDQUOT$PtQopValue(?:,$PtQopValue)*$PtRDQUOT};

# algorithm       =  "algorithm" EQUAL ( "MD5" / "MD5-sess" / token )   # 040301 
#$PtAlgorithm      = qq{(?i:algorithm)$PtEQUAL(?:(?i:MD5-sess|MD5)|$PtToken)};
$PtAlgorithm      = qq{(?i:algorithm)$PtEQUAL(?:$PtToken)}; # 20060207 maeda FIX

# URI             =  absoluteURI / abs-path
$PtURI            = qq{(?:$PtAbsoluteURI|$PtAbsPath)};

# domain          =  "domain" EQUAL LDQUOT URI *( 1*SP URI ) RDQUOT
$PtDomain         = qq{(?i:domain)$PtEQUAL$PtLDQUOT$PtURI(?:\s+$PtURI)*$PtRDQUOT};

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
$PtUsernameValue  = qq{$PtQuotedString};

# username        =  "username" EQUAL username-value
$PtUsername       = qq{(?i:username)$PtEQUAL$PtUsernameValue};

# dig-resp        =  username / realm / nonce / digest-uri / dresponse / algorithm / cnonce / opaque / message-qop / nonce-count / auth-param
$PtDigResp        = qq{(?:$PtUsername|$PtRealm|$PtNonce|$PtDigestUri|$PtDresponse|$PtAlgorithm|$PtCnonce|$PtOpaque|$PtMessageQop|$PtNonceCount|$PtAuthParam)};

# digest-response =  dig-resp *(COMMA dig-resp)
$PtDigestResponse = qq{$PtDigResp(?:$PtCOMMA$PtDigResp)*};

# credentials     =  ("Digest" LWS digest-response) / other-response
$PtCredentials    = qq{(?:(?:(?i:Digest)$PtLWS$PtDigestResponse)|$PtOtherResponse)};

# Authorization   =  "Authorization" HCOLON credentials
$PtAuthorization  = qq{(?i:Authorization)$PtHCOLON$PtCredentials};

# Content-Length  =  ( "Content-Length" / "l" ) HCOLON 1*DIGIT
$PtContentLength  = qq{(?i:Content-Length|l)$PtHCOLON(?:$PtDigit)+};

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
$PtCompositeType  = qq{(?:(?i:message|multipart)|$PtExtensionToken)};

# discrete-type   =  "text" / "image" / "audio" / "video" / "application" / extension-token
$PtDiscreteType   = qq{(?:(?i:text|image|audio|video|application)|$PtExtensionToken)};

# m-type          = discrete-type / composite-type
$PtMType          = qq{(?:$PtDiscreteType|$PtCompositeType)};

# media-type      =  m-type SLASH m-subtype *(SEMI m-parameter)
$PtMediaType      = qq{$PtMType$PtSLASH$PtMSubtype(?:$PtSEMI$PtMParameter)*};

# Content-Type    =  ( "Content-Type" / "c" ) HCOLON media-type
$PtContentType    = qq{(?i:Content-Type|c)$PtHCOLON$PtMediaType};

# CSeq            =  "CSeq" HCOLON 1*DIGIT LWS Method
$PtCSeq           = qq{(?i:CSeq)$PtHCOLON(?:$PtDigit)+$PtLWS$PtMethod};

# Expires         =  "Expires" HCOLON delta-seconds
$PtExpires        = qq{(?i:Expires)$PtHCOLON$PtDeltaSeconds};

# gen-value       =  token / host / quoted-string
$PtGenValue       = qq{(?:$PtToken|$PtHost|$PtQuotedString)};

# generic-param   =  token [ EQUAL gen-value ]
$PtGenericParam   = qq{$PtToken(?:$PtEQUAL$PtGenValue)?};

# tag-param       =  "tag" EQUAL token
$PtTagParam       = qq{(?:(?i:tag)$PtEQUAL$PtToken)};

# from-param      =  tag-param / generic-param
$PtFromParam      = qq{(?:$PtTagParam|$PtGenericParam)};

# display-name    =  *(token LWS)/ quoted-string
#   
#   from: NUT<sip:NUT\@[3ffe:501:ffff:5:2a0:deff:fe14:e2ec]>;tag=6209640784
# $PtDisplayName    = qq{(?:(?:$PtToken$PtLWS)+|$PtQuotedString)};
$PtDisplayName    = qq{(?:(?:$PtToken(?:$PtLWS)??)+|$PtQuotedString)};

# addr-spec       =  SIP-URI / SIPS-URI / absoluteURI
$PtAddrSpec       = qq{(?:$PtSIPUri|$PtSIPSUri|$PtAbsoluteUri)};

# name-addr       =  [ display-name ] LAQUOT addr-spec RAQUOT
$PtNameAddr       = qq{(?:$PtDisplayName)?$PtLAQUOT$PtAddrSpec$PtRAQUOT};

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

# callid          =  word [ "@" word ]
$PtCallid         = qq{$PtWord(?:\@$PtWord)?};

# Call-ID         =  ( "Call-ID" / "i" ) HCOLON callid
$PtCallID         = qq{(?i:Call-ID|i)$PtHCOLON$PtCallid};

# c-p-q           =  "q" EQUAL qvalue
$PtCPQ            = qq{(?i:q)$PtEQUAL$PtQvalue};

# c-p-expires     =  "expires" EQUAL delta-seconds
$PtCPExpires      = qq{(?i:expires)$PtEQUAL$PtDeltaSeconds};

# contact-extension  =  generic-param
$PtContactExtension= qq{$PtGenericParam};

# contact-params  =  c-p-q / c-p-expires / contact-extension
$PtContactParams  = qq{(?:$PtCPQ|$PtCPExpires|$PtContactExtension)};

# contact-param   =  (name-addr / addr-spec) *(SEMI contact-params)
$PtContactParam   = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtContactParams)*};

# Contact         =  ("Contact" / "m" ) HCOLON ( STAR / (contact-param *(COMMA contact-param)))
$PtContact        = qq{(?i:Contact|m)$PtHCOLON(?:$PtSTAR|(?:$PtContactParam(?:$PtCOMMA$PtContactParam)*))};

# Max-Forwards    =  "Max-Forwards" HCOLON 1*DIGIT
$PtMaxForwards    = qq{(?i:Max-Forwards)$PtHCOLON$PtDigit+};

# Proxy-Authorization  =  "Proxy-Authorization" HCOLON credentials
$PtProxyAuthorization= qq{(?i:Proxy-Authorization)$PtHCOLON$PtCredentials};

# rr-param        =  generic-param
$PtRrParam        = qq{$PtGenericParam};

# rec-route       =  name-addr *( SEMI rr-param )
$PtRecRoute       = qq{$PtNameAddr(?:$PtSEMI$PtRrParam)*};

# Record-Route    =  "Record-Route" HCOLON rec-route *(COMMA rec-route)
$PtRecordRoute    = qq{(?i:Record-Route)$PtHCOLON$PtRecRoute(?:$PtCOMMA$PtRecRoute)*};

# route-param     =  name-addr *( SEMI rr-param )
$PtRouteParam     = qq{$PtNameAddr(?:$PtSEMI$PtRrParam)*};

# Route           =  "Route" HCOLON route-param *(COMMA route-param)
$PtRoute          = qq{(?i:Route)$PtHCOLON$PtRouteParam(?:$PtCOMMA$PtRouteParam)*};

# retry-param     =  ("duration" EQUAL delta-seconds) / generic-param
$PtRetryParam     = qq{(?:(?i:duration)$PtEQUAL$PtDeltaSeconds|$PtGenericParam)};

# to-param        =  tag-param / generic-param
$PtToParam        = qq{(?:$PtTagParam|$PtGenericParam)};

# to-spec         =  ( name-addr / addr-spec ) *( SEMI from-param )
$PtToSpec         = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtToParam)*};

# To              =  ( "To" / "t" ) HCOLON ( name-addr / addr-spec ) *( SEMI to-param )
$PtTo             = qq{(?i:To|t)$PtHCOLON$PtToSpec};

# sent-by         =  host [ COLON port ]
$PtSentBy         = qq{$PtHost(?:$PtCOLON$PtPort)?};

# transport       =  "UDP" / "TCP" / "TLS" / "SCTP" / other-transport
$PtTransport      = qq{(?:(?i:UDP|TCP|TLS|SCTP)|$PtOtherTransport)};

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

# Proxy-Authenticate  =  "Proxy-Authenticate" HCOLON challenge
$PtProxyAuthenticate = qq{(?i:Proxy-Authenticate)$PtHCOLON$PtChallenge};

# time          =  2DIGIT ":" 2DIGIT ":" 2DIGIT   ; 00:00:00 - 23:59:59
$PtTime         = qq{(?i:$PtDigit$PtDigit:$PtDigit$PtDigit:$PtDigit$PtDigit)};

# wkday         =  "Mon" / "Tue" / "Wed" / "Thu" / "Fri" / "Sat" / "Sun"
$PtWkday        = qq{(?i:Mon|Tue|Wed|Thu|Fri|Sat|Sun)};

# month         =  "Jan" / "Feb" / "Mar" / "Apr" / "May" / "Jun" / "Jul" / "Aug" / "Sep" / "Oct" / "Nov" / "Dec"
$PtMonth        = qq{(?i:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)};

# date1         =  2DIGIT SP month SP 4DIGIT      ; 
$PtDate1         = qq{(?i:$PtDigit$PtDigit\\s$PtMonth\\s$PtDigit$PtDigit$PtDigit$PtDigit)};

# SIP-date      =  rfc1123-date
# rfc1123-date  =  wkday "," SP date1 SP time SP "GMT"
$PtSIPdate      =  qq{(?i:$PtWkday,\\s$PtDate1\\s$PtTime\\sGMT)};

############# extension ##############################
### rfc3262
# CSeq-num          =  1*DIGIT
$PtCSeqNum          = qq{(?:$PtDigit)+};
# response-num      =  1*DIGIT
$PtResponseNum      = qq{(?:$PtDigit)+};
# RAck              =  "RAck" HCOLON response-num LWS CSeq-num LWS Method
$PtRAck             = qq{(?i:RAck)$PtHCOLON$PtResponseNum$PtLWS$PtCSeqNum$PtLWS$PtMethod};
# RSeq              =  "RSeq" HCOLON response-num
$PtRSeq             = qq{(?i:RSeq)$PtHCOLON$PtResponseNum};

### rfc3265
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
$PtEventReasonValue = qq{(?:(?i:deactivated|probation|rejected|timeout|giveup|noresource)|$PtEventReasonExtension)};
# subexp-params     =   ("reason" EQUAL event-reason-value) / ("expires" EQUAL delta-seconds) / ("retry-after" EQUAL delta-seconds) / generic-param
$PtSubexpParams     = qq{(?:(?:(?i:reason)$PtEQUAL$PtEventReasonValue)|(?:(?i:expires)$PtEQUAL$PtDeltaSeconds)|(?:(?i:retry-after)$PtEQUAL$PtDeltaSeconds)|$PtGenericParam)};
# substate-value    = "active" / "pending" / "terminated" / extension-substate
$PtSubstateValue    = qq{(?:(?i:active|pending|terminated)|$PtExtensionSubstate)};

# Subscription-State= "Subscription-State" HCOLON substate-value *( SEMI subexp-params )
$PtSubscriptionState= qq{(?i:Subscription-State)$PtHCOLON$PtSubstateValue(?:$PtSEMI$PtSubexpParams)*};

### rfc3515
# Refer-To          = ("Refer-To" / "r") HCOLON ( name-addr / addr-spec ) *
$PtReferTo          = qq{(?i:Refer-To|r)$PtHCOLON(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtGenericParam)*};
$PtReferToParam     = qq{(?:$PtTagParam|$PtGenericParam)};

### rfc3323/3325
# priv-value        =  "header" / "session" / "user" / "none" / "critical" / "id" / "history" / token
$PtPrivValue        =  qq{(?:(?i:header|session|user|none|critical|id|history)|$PtToken)};
# Privacy-hdr       =  "Privacy" HCOLON priv-value *(";" priv-value)
$PtPrivacy          =  qq{(?i:Privacy)$PtHCOLON$PtPrivValue(?:$PtSEMI$PtPrivValue)*};

### rfc3325
# PAssertedID-value = name-addr / addr-spec
$PtPAssertedIDValue = qq{(?:$PtNameAddr|$PtAddrSpec)};
# PAssertedID       = "P-Asserted-Identity" HCOLON PAssertedID-value *(COMMA PAssertedID-value)
$PtPAssertedID      =  qq{(?i:P-Asserted-Identity)$PtHCOLON$PtPAssertedIDValue(?:$PtCOMMA$PtPAssertedIDValue)*};

# PPreferredID-value = name-addr / addr-spec
$PtPPreferredIDValue= qq{(?:$PtNameAddr|$PtAddrSpec)};
# PPreferredID      = "P-Preferred-Identity" HCOLON PPreferredID-value *(COMMA PPreferredID-value)
$PtPPreferredID     =  qq{(?i:P-Preferred-Identity)$PtHCOLON$PtPPreferredIDValue(?:$PtCOMMA$PtPPreferredIDValue)*};

### draft-ietf-sip-session-timer-15 Sec.4,5 
# refresher-param   = 'refresher' EQUAL  ('uas' / 'uac')
$PtRefresherParam   = qq{(?:(?i:refresher)$PtEQUAL(?i:uas|uac))};

# se-params         = refresher-param / generic-param
$PtSEParams         = qq{(?:$PtRefresherParam|$PtGenericParam)};

# Session-Expires   = ('Session-Expires' / 'x') HCOLON delta-seconds *(SEMI se-params)
$PtSessionExpires   = qq{(?i:Session-Expires|x)$PtHCOLON$PtDeltaSeconds(?:$PtSEMI$PtSEParams)*};

# Min-SE            =  'Min-SE' HCOLON delta-seconds *(SEMI generic-param)
$PtMinSE            = qq{(?i:Min-SE)$PtHCOLON$PtDeltaSeconds(?:$PtSEMI$PtGenericParam)*};


############# SDP ##############################

#   space         =   %d32
$PtSpace          = q{(?: )};

#   POS-DIGIT     =  "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"
$PtPosDigit           = q{[1-9]};

#   integer       =  POS-DIGIT *(DIGIT)
$PtInteger        = qq{(?:0|(?:$PtPosDigit)(?:$PtDigit)*)};
$PtSignedInteger  = qq{(?:-?)(?:0|(?:$PtPosDigit)(?:$PtDigit)*)};

#   float         =  integer [.*DIGIT]
$PtFloat          = qq{(?:$PtDigit)+(?:\\\.(?:$PtDigit)*)?};

#   proto         = 1*(alpha-numeric)
$PtProto          = qq{(?:$PtAlphanum|/)+};

#   fmt           =   1*(alpha-numeric)
$PtFmt            = qq{(?:$PtAlphanum)+};

#   media         = 1*(alpha-numeric)
$PtMedia          = qq{(?:$PtAlphanum)+};

#   media-field   =  "m=" media space port ["/" integer] space proto 1*(space fmt) CRLF
$PtMediaField     =  qq{(?:$PtMedia$PtSpace$PtPort(?:/$PtInteger)?$PtSpace$PtProto(?:$PtSpace$PtFmt)+)};

#   byte-string   =   1*(0x01..0x09|0x0b|0x0c|0x0e..0xff)
#$PtByteString     = qq{(?:0x[0-9a-f][0-9a-f])+};
$PtByteString     = qq{(?:[^\r\n]+)};

#   att-field     =  1*(alpha-numeric)
$PtAttField       = qq{(?:$PtAlphanum)+};

#   att-value =           byte-string     2003/12/01 
$PtAttValue       = qq{(?:$PtByteString)};

$PtInformationField=
#   attribute-fields =    *("a=" attribute CRLF)
#   attribute     =  (att-field ":" att-value) | att-field
$PtAttributeFields=  qq{(?:(?:$PtAttField:$PtAttValue)|(?:$PtAttField))};

# information-field =   ["i=" text CRLF]
$PtInformationField=qq{(?:$PtByteString)};

# connection-field = ["c=" nettype space addrtype space connection-address CRLF]
$PtConnectionField =qq{(?:$PtByteString)};

# bandwidth-fields =    *("b=" bwtype ":" bandwidth CRLF)
$PtBandwidthFields =qq{(?:$PtByteString)};

# key-field =           ["k=" key-type CRLF]
$PtKeyField        =qq{(?:$PtByteString)};

# media-descriptions =  *( media-field information-field *(connection-field) bandwidth-fields key-field attribute-fields )
$PtMediaDescriptions=qq{$PtMediaField$PtCRLF(?:(?i:i)=$PtInformationField$PtCRLF)?(?:(?i:c)=$PtConnectionField$PtCRLF)*(?:(?i:b)=$PtBandwidthFields$PtCRLF)*(?:(?i:k)=$PtKeyField$PtCRLF)?(?:(?i:a)=$PtAttributeFields$PtCRLF)*};

################################################

# Request         =  Request-Line *( message-header ) CRLF [ message-body ]
$PtRequest        = qq{$PtRequestLine(?:$PtMessageHeader)*$PtCRLF(?:$PtMessageBody)?};

# Response        =  Status-Line *( message-header ) CRLF [ message-body ]
$PtResponse       = qq{$PtStatusLine(?:$PtMessageHeader)*$PtCRLF(?:$PtMessageBody)?};

# SIP-message     =  Request / Response
$PtSIPMessage     = qq{$PtRequest|$PtResponse};



#######################################
#
# 
#   name:    
#   pattern: 
#   match:   
#   type:    
#   bind:    match
#
#######################################

%STCallID =
('name'    => 'CallID',
 'pattern' => '', 
 'match'   => "($PtCallid)", 
 'type'    => hash,
 'bind' => [{'index'=>'call-id','struct'=>''}],
);


%STContentType =
('name'    => 'ContentType',
 'pattern' => '', 
 'match'   => "($PtMType)$PtSLASH($PtMSubtype)((?:$PtSEMI$PtMParameter)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'type',   'struct'=>''},
	    {'index'=>'subtype','struct'=>''},
	    {'index'=>'param',  'struct'=>''}],
);

%STCSeq =
('name'    => 'CSeq',
 'pattern' => '', 
 'match'   => "((?:$PtDigit)+)$PtLWS($PtMethod)", 
 'type'    => hash,
 'bind' => [{'index'=>'csno',  'struct'=>''},
	    {'index'=>'method','struct'=>''}],
);

%STDate =
('name'    => 'Date',
 'pattern' => '', 
 'match'   => "($PtWkday),\\s($PtDate1)\\s($PtTime)\\s(GMT)", 
 'type'    => hash,
 'bind' => [{'index'=>'wkday','struct'=>''},
	    {'index'=>'date1','struct'=>''},
	    {'index'=>'time','struct'=>''},
	    {'index'=>'zone','struct'=>''}],
);

%STHostport =
('name'    => 'Hostport',
 'pattern' => '', 
 'match'   => "($PtHost)(?::($PtPort))?", 
 'type'    => hash,
 'bind' => [{'index'=>'host',  'struct'=>''},
	    {'index'=>'port',  'struct'=>''}],
);

%STUriParameter =
('name'    => 'UriParameter',
# 'match'   => "($PtTransportParam)|($PtUserParam)|($PtMethodParam)|($PtTtlParam)|($PtMaddrParam)|($PtLrParam)|($PtOtherParam)", 
 'match'   => "(?:(?i:transport)=((?:(?i:udp|tcp|sctp|tls)|$PtOtherTransport)))|(?:(?i:user)=((?:(?i:phone|ip)|$PtOtherUser)))|(?:(?i:method)=($PtMethod))|(?:(?i:ttl)=($PtTtl))|(?:(?i:maddr)=($PtHost))|((?i:lr))|($PtOtherParam)", 
 'type'    => hash,
 'bind' =>[{'index'=>'transport-param','struct'=>''},
	   {'index'=>'user-param',     'struct'=>''},
	   {'index'=>'method-param',   'struct'=>''},
	   {'index'=>'ttl-param',      'struct'=>''},
	   {'index'=>'maddr-param',    'struct'=>''},
	   {'index'=>'lr-param',       'struct'=>''},
	   {'index'=>'other-param',    'struct'=>''},]
);

%STUriParameters =
('name'    => 'STUriParameters',
 'pattern' => '', 
 'match'   => ";($PtUriParameter)", 
 'type'    => array,
 'bind' =>[{'index'=>'',      'struct'=>\%STUriParameter}],
);


%STSIPUri =
('name'    => 'SIPUri',
 'match'   => "sip:(?:($PtUser(?::$PtPassword)?)\@)?($PtHostport)($PtUriParameters)((?:$PtHeaders)?)", 
 'type'    => hash,
 'bind' =>[{'index'=>'userinfo','struct'=>''},
	   {'index'=>'hostport','struct'=>\%STHostport},
	   {'index'=>'param',   'struct'=>\%STUriParameters},
	   {'index'=>'header',  'struct'=>''},]
);

%STSIPSUri =
('name'    => 'SIPSUri',
 'match'   => "sips:((?:$PtUserinfo)?)($PtHostport)($PtUriParameters)((?:$PtHeaders)?)", 
 'type'    => hash,
 'bind' =>[{'index'=>'userinfo','struct'=>''},
	   {'index'=>'hostport','struct'=>''},
	   {'index'=>'param',   'struct'=>\%STUriParameters},
	   {'index'=>'header',  'struct'=>''},]
);

%STSentBy=
('name'    => 'SentBy',
 'pattern' => $PtSentBy, 
 'match'   => "($PtHost)(?:$PtCOLON($PtPort))?", 
 'type'    => hash,
 'bind' =>[{'index'=>'host',    'struct'=>''},                    # 
	   {'index'=>'port',    'struct'=>''}]
);

%STSentProtocol=
('name'    => 'SentProtocol',
 'pattern' => $PtSentProtocol, 
 'match'   => "($PtProtocolName)$PtSLASH($PtProtocolVersion)$PtSLASH($PtTransport)", 
 'type'    => hash,
 'bind' =>[{'index'=>'name',    'struct'=>''},                    # 
	   {'index'=>'ver',     'struct'=>''},
	   {'index'=>'trans',   'struct'=>''}]
);

%STGenericParam=
('name'    => 'GenericParam',
 'pattern' => $PtGenericParam, 
# 'match'   => "($PtToken(?:$PtEQUAL$PtGenValue)?)", 
 'match'   => "(.+)", 
 'type'    => hash,
 'bind' =>[{'index'=>'generic', 'struct'=>''}]
);

%STTagParam=
('name'    => 'TagParam',
 'pattern' => $PtTagParam, 
 'match'   => "(?i:tag)$PtEQUAL($PtToken)", 
 'type'    => hash,
 'bind' =>[{'index'=>'tag',    'struct'=>''}]
);

%STFromParam =
('name'    => 'FromParam',
 'match'   => "($PtTagParam)|($PtGenericParam)", 
 'type'    => one,                                             # 
 'bind' =>[{'index'=>'',      'struct'=>\%STTagParam},
	   {'index'=>'',      'struct'=>\%STGenericParam},]
);

%STFromParams =
('name'    => 'FromParams',
 'pattern' => '', 
 'match'   => "$PtSEMI($PtFromParam)", 
 'type'    => array,
 'bind' =>[{'index'=>'',      'struct'=>\%STFromParam}],
);

%STReplyToParams =
('name'    => 'ReplyToParams',
 'pattern' => '', 
 'match'   => "$PtSEMI($PtReplyToParam)", 
 'type'    => array,
 'bind' =>[{'index'=>'',      'struct'=>\%STGenericParam}],
);

%STToParams =
('name'    => 'ToParams',
 'pattern' => '', 
 'match'   => "$PtSEMI($PtToParam)", 
 'type'    => array,
 'bind' =>[{'index'=>'',      'struct'=>\%STFromParam}],
);

%STAddrSpec=
('name'    => 'AddrSpec',
 'pattern' => $PtAddrSpec, 
 'match'   => "(?:($PtSIPUri)|($PtSIPSUri)|($PtAbsoluteUri))", 
 'type'    => hash,
 'bind' =>[{'index'=>'ad',    'struct'=>\%STSIPUri},
	   {'index'=>'ad',    'struct'=>\%STSIPSUri},
	   {'index'=>'ad',    'struct'=>''}]
);

%STNameAddr=
('name'    => 'NameAddr',
 'pattern' => $PtNameAddr, 
 'match'   => "((?:$PtDisplayName)?)$PtLAQUOT(?:($PtSIPUri)|($PtSIPSUri)|($PtAbsoluteUri))$PtRAQUOT", 
 'type'    => hash,
 'bind' =>[{'index'=>'disp',  'struct'=>''},                    # 
	   {'index'=>'ad',    'struct'=>\%STSIPUri},
	   {'index'=>'ad',    'struct'=>\%STSIPSUri},
	   {'index'=>'ad',    'struct'=>''}]
);

%STCPQ=
('name'    => 'CPQ',
 'pattern' => $PtCPQ, 
 'match'   => "(?i:q)$PtEQUAL($PtQvalue)", 
 'type'    => hash,
 'bind' =>[{'index'=>'q=',    'struct'=>''}]
);

%STCPExpires=
('name'    => 'CPExpires',
 'pattern' => $PtCPExpires, 
 'match'   => "(?i:expires)$PtEQUAL($PtDeltaSeconds)", 
 'type'    => hash,
 'bind' =>[{'index'=>'expires=',    'struct'=>''}]
);

%STContactExtension=
('name'    => 'ContactExtension',
 'pattern' => $PtGenericParam, 
 'match'   => "($PtGenericParam)", 
 'type'    => hash,
 'bind' =>[{'index'=>'extension',    'struct'=>''}]
);

%STContactParamsItem=
('name'    => 'ContactParamsItem',
 'pattern' => '', 
 'match'   => "($PtCPQ)|($PtCPExpires)|($PtContactExtension)", 
 'type'    => one,
 'bind' => [{'index'=>'', 'struct'=>\%STCPQ},
            {'index'=>'', 'struct'=>\%STCPExpires},
            {'index'=>'', 'struct'=>\%STContactExtension},],
);

%STContactParams=
('name'    => 'ContactParams',
 'pattern' => '', 
 'match'   => "(?:$PtSEMI($PtContactParams))", 
 'type'    => array,
 'bind' => [{'index'=>'',      'struct'=>\%STContactParamsItem}],
);

%STContactParam=
('name'    => 'ContactParam',
 'pattern' => '', 
 'match'   => "(?:($PtNameAddr)|($PtAddrSpec))((?:$PtSEMI$PtContactParams)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'ad',    'struct'=>\%STNameAddr},
	    {'index'=>'ad',    'struct'=>\%STAddrSpec},
	    {'index'=>'param', 'struct'=>\%STContactParams}],
);

%STContactParamS=
('name'    => 'ContactParamS',
 'pattern' => '',
 'match'   => "(?:$PtCOMMA($PtContactParam))", 
 'type'    => array,
 'bind' => [{'index'=>'',    'struct'=>\%STContactParam}],
);

%STContact=
('name'    => 'Contact',
 'pattern' => $PtContact, 
 'match'   => "(?:$PtSTAR|(?:($PtContactParam)((?:$PtCOMMA$PtContactParam)*)))", 
 'type'    => 'marge-array',
 'bind' => [{'index'=>'contact', 'struct'=>\%STContactParam},
	    {'index'=>'rest',    'struct'=>\%STContactParamS}],
);

%STExpires =
('name'    => 'Expires',
 'pattern' => '', 
 'match'   => "($PtDeltaSeconds)", 
 'type'    => hash,
 'bind' => [{'index'=>'seconds',  'struct'=>''}],
);

%STRouteParam=
('name'    => 'RouteParam',
 'pattern' => '',
 'match'   => "($PtNameAddr)((?:$PtSEMI$PtRrParam)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'ad',    'struct'=>\%STNameAddr},
            {'index'=>'param', 'struct'=>''}],
);

%STRouteParamS=
('name'    => 'RouteParamS',
 'pattern' => '',
 'match'   => "(?:$PtCOMMA($PtRouteParam))", 
 'type'    => array,
 'bind' => [{'index'=>'',    'struct'=>\%STRouteParam}],
);

%STRoute=
('name'    => 'Route',
 'pattern' => $PtRoute, 
 'match'   => "(?:($PtRouteParam))((?:$PtCOMMA$PtRouteParam)*)", 
 'type'    => 'marge-array',
 'bind' => [{'index'=>'route','struct'=>\%STRouteParam},
	    {'index'=>'rest', 'struct'=>\%STRouteParamS}],
);

%STRecordRouteParam=
('name'    => 'RecordRouteParam',
 'pattern' => '',
 'match'   => "($PtNameAddr)((?:$PtSEMI$PtRrParam)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'ad',    'struct'=>\%STNameAddr},
            {'index'=>'param', 'struct'=>''}],
);

%STRecordRouteParamS=
('name'    => 'RecordRouteParamS',
 'pattern' => '',
 'match'   => "(?:$PtCOMMA($PtRecRoute))", 
 'type'    => array,
 'bind' => [{'index'=>'',    'struct'=>\%STRecordRouteParam}],
);

%STRecordRoute=
('name'    => 'RecordRoute',
 'pattern' => $PtRecordRoute, 
 'match'   => "((?:$PtRecRoute))((?:$PtCOMMA$PtRecRoute)*)", 
 'type'    => 'marge-array',
 'bind' => [{'index'=>'route','struct'=>\%STRecordRouteParam},
	    {'index'=>'rest', 'struct'=>\%STRecordRouteParamS}],
);

%STFrom=
('name'    => 'From',
 'pattern' => $PtFrom, 
 'match'   => "(?:($PtNameAddr)|($PtAddrSpec))((?:$PtSEMI$PtFromParam)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'ad',    'struct'=>\%STNameAddr},
	    {'index'=>'ad',    'struct'=>\%STAddrSpec},
	    {'index'=>'param', 'struct'=>\%STFromParams}],
);

# 
%STRetryAfter=
('name'    => 'RetryAfter',
 'match'   => "^($PtDeltaSeconds)((?:$PtComment0)?)((?:$PtSEMI$PtRetryParam)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'delta',  'struct'=>''},
	    {'index'=>'comment','struct'=>''},
	    {'index'=>'retry',  'struct'=>''}],
);

%STTimestamp=
('name'    => 'Timestamp',
 'match'   => "($PtFloat)(?:$PtLWS($PtFloat))?", 
 'type'    => hash,
 'bind' => [{'index'=>'timestamp','struct'=>''},
	    {'index'=>'delay',    'struct'=>''}],
);

%STReplyTo=
('name'    => 'ReplyTo',
 'pattern' => $PtReplyTo, 
 'match'   => "(?:($PtNameAddr)|($PtAddrSpec))((?:$PtSEMI$PtReplyToParam)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'ad',    'struct'=>\%STNameAddr},
	    {'index'=>'ad',    'struct'=>\%STAddrSpec},
	    {'index'=>'param', 'struct'=>\%STReplyToParams}],
);

%STMaxForwards =
('name'    => 'MaxForwards',
 'pattern' => '', 
 'match'   => "($PtDigit+)", 
 'type'    => hash,
 'bind' => [{'index'=>'num','struct'=>''}],
);

%STTo=
('name'    => 'To',
 'pattern' => $PtTo, 
 'match'   => "(?:($PtNameAddr)|($PtAddrSpec))((?:$PtSEMI$PtToParam)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'ad',    'struct'=>\%STNameAddr},
	    {'index'=>'ad',    'struct'=>\%STAddrSpec},
	    {'index'=>'param', 'struct'=>\%STToParams}],
);

%STRefresherParam =
('name'    => 'Refresher',
 'pattern' => $PtRefresherParam, 
 'match'   => "(?i:refresher)$PtEQUAL((?i:uas|uac))", 
 'type'    => hash,
 'bind' => [{'index'=>'refresher=', 'struct'=>''}],
);

%STSEParam =
('name'    => 'SeParam',
 'pattern' => '', 
 'match'   => "($PtRefresherParam)|($PtGenericParam)", 
 'type'    => one,
 'bind' =>[{'index'=>'',      'struct'=>\%STRefresherParam},
	   {'index'=>'',      'struct'=>\%STGenericParam},]
);

%STSEParams =
('name'    => 'SeParams',
 'pattern' => '', 
 'match'   => "$PtSEMI((?:$PtRefresherParam|$PtGenericParam))", 
 'type'    => array,
 'bind' =>[{'index'=>'',      'struct'=>\%STSEParam}],
);

%STSessionExpires =
('name'    => 'Session-Expires',
 'pattern' => $PtSessionExpires, 
 'match'   => "($PtDeltaSeconds)((?:$PtSEMI$PtSEParams)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'seconds', 'struct'=>''},
	    {'index'=>'param','struct'=>\%STSEParams}],
);

%STMinSEParams =
('name'    => 'MinSEParams',
 'pattern' => '', 
 'match'   => "$PtSEMI($PtGenericParam)", 
 'type'    => array,
 'bind' =>[{'index'=>'',      'struct'=>\%STGenericParam}],
);

%STMinSE =
('name'    => 'Min-SE',
 'pattern' => $PtMinSE, 
 'match'   => "($PtDeltaSeconds)((?:$PtSEMI$PtGenericParam)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'seconds', 'struct'=>''},
	    {'index'=>'param','struct'=>\%STMinSEParams}],
);

%STRequestLine=
('name'    => 'RequestLine',
 'pattern' => $PtRequestLine, 
 'match'   => "($PtMethod)\\s($PtRequestURI)\\s($PtSIPVersion)", 
 'type'    => hash,
 'bind' => [{'index'=>'method', 'struct'=>},
	    {'index'=>'uri',    'struct'=>\%STAddrSpec},
	    {'index'=>'version','struct'=>}],
);

%STStatusLine=
('name'    => 'StatusLine',
 'pattern' => $PtStatusLine, 
 'match'   => "($PtSIPVersion)\\s((?:$PtDigit){1,3})\\s($PtReasonPhrase)", 
 'type'    => hash,
 'bind' => [{'index'=>'version', 'struct'=>''},
	    {'index'=>'code',    'struct'=>''},
	    {'index'=>'reason',  'struct'=>''}],
);

%STViaReceived=
('name'    => 'ViaReceived',
 'pattern' => $PtViaReceived, 
 'match'   => "(?i:received)$PtEQUAL((?:$PtIPv4address|$PtIPv6address))", 
 'type'    => hash,
 'bind' =>[{'index'=>'received=',    'struct'=>''}]
);


%STViaBranch=
('name'    => 'ViaBranch',
 'pattern' => $PtViaBranch, 
 'match'   => "(?i:branch)$PtEQUAL($PtToken)", 
 'type'    => hash,
 'bind' =>[{'index'=>'branch=',    'struct'=>''}]
);

%STViaParamItem=
('name'    => 'ViaParamsItem',
 'pattern' => '', 
 'match'   => "$PtViaTtl|$PtViaMaddr|($PtViaReceived)|($PtViaBranch)|$PtViaExtension", 
 'type'    => one,
 'bind' => [{'index'=>'', 'struct'=>\%STViaReceived},
            {'index'=>'', 'struct'=>\%STViaBranch},],
);

# 
%STViaParams=
('name'    => 'ViaParams',
 'pattern' => '', 
 'match'   => "((?:$PtViaTtl|$PtViaMaddr|$PtViaReceived|$PtViaBranch|$PtViaExtension))", 
 'type'    => array,
 'bind' => [{'index'=>'',      'struct'=>\%STViaParamItem}],
);

%STViaParam=
('name'    => 'ViaParam',
 'pattern' => '', 
 'match'   => "($PtSentProtocol)$PtLWS(($PtSentBy)((?:$PtSEMI$PtViaParams)*))", 
 'type'    => hash,
 'bind' => [{'index'=>'proto', 'struct'=>\%STSentProtocol},
	    {'index'=>'by',    'struct'=>''},
	    {'index'=>'sendby','struct'=>\%STSentBy},
	    {'index'=>'param', 'struct'=>\%STViaParams}],
);

%STViaParamS=
('name'    => 'ViaParamS',
 'pattern' => '',
 'match'   => "(?:$PtCOMMA($PtViaParm))", 
 'type'    => array,
 'bind' => [{'index'=>'',    'struct'=>\%STViaParam}],
);

%STVia =
('name'    => 'Via',
 'pattern' => $PtVia, 
 'match'   => "($PtViaParm)((?:$PtCOMMA$PtViaParm)*)", 
 'type'    => 'marge-array',
 'bind' => [{'index'=>'via',     'struct'=>\%STViaParam},
	    {'index'=>'rest',    'struct'=>\%STViaParamS}],
);

%STAllowMethods =
('name'    => 'Allow',
 'pattern' => '', 
 'match'   => "(?:($PtMethod))|(?:$PtCOMMA($PtMethod))", 
 'type'    => array,
 'bind' => [{'index'=>'methods', 'struct'=>''}],
);

%STAllow =
('name'    => 'Allow',
 'pattern' => '', 
 'match'   => "(.*)", 
 'type'    => hash,
 'bind' => [{'index'=>'methods', 'struct'=>\%STAllowMethods}],
);


%STUsername=
('name'    => 'Username',
 'pattern' => '', 
 'match'   => "(?i:username)$PtEQUAL($PtUsernameValue)", 
 'type'    => hash,
 'bind' =>[{'index'=>'username',    'struct'=>''}]
);
%STRealm=
('name'    => 'Realm',
 'pattern' => '', 
 'match'   => "(?i:realm)$PtEQUAL($PtRealmValue)", 
 'type'    => hash,
 'bind' =>[{'index'=>'realm',    'struct'=>''}]
);
%STNonce=
('name'    => 'Nonce',
 'pattern' => '', 
 'match'   => "(?i:nonce)$PtEQUAL($PtNonceValue)", 
 'type'    => hash,
 'bind' =>[{'index'=>'nonce',    'struct'=>''}]
);
%STDigestUri=
('name'    => 'DigestUri',
 'pattern' => '', 
 'match'   => "(?i:uri)$PtEQUAL($PtLDQUOT$PtDigestUriValue$PtRDQUOT)", 
 'type'    => hash,
 'bind' =>[{'index'=>'uri',    'struct'=>''}]
);
%STDresponse=
('name'    => 'Dresponse',
 'pattern' => '', 
 'match'   => "(?i:response)$PtEQUAL($PtRequestDigest)", 
 'type'    => hash,
 'bind' =>[{'index'=>'response',    'struct'=>''}]
);
%STAlgorithm=
('name'    => 'Algorithm',
 'pattern' => '', 
# 'match'   => "(?i:algorithm)$PtEQUAL((?:(?i:MD5|MD5-sess)|$PtToken))", 
 'match'   => "(?i:algorithm)$PtEQUAL((?:$PtToken))", # 20060207 maeda FIX
 'type'    => hash,
 'bind' =>[{'index'=>'algorithm',    'struct'=>''}]
);
%STCnonce=
('name'    => 'Cnonce',
 'pattern' => '', 
 'match'   => "(?i:cnonce)$PtEQUAL($PtCnonceValue)", 
 'type'    => hash,
 'bind' =>[{'index'=>'cnonce',    'struct'=>''}]
);
%STOpaque=
('name'    => 'Opaque',
 'pattern' => '', 
 'match'   => "(?i:opaque)$PtEQUAL($PtQuotedString)", 
 'type'    => hash,
 'bind' =>[{'index'=>'opaque',    'struct'=>''}]
);
%STMessageQop=
('name'    => 'MessageQop',
 'pattern' => '', 
 'match'   => "(?i:qop)$PtEQUAL($PtQopValue)", 
 'type'    => hash,
 'bind' =>[{'index'=>'qop',    'struct'=>''}]
);
%STNonceCount=
('name'    => 'NonceCount',
 'pattern' => '', 
 'match'   => "(?i:nc)$PtEQUAL($PtNcValue)", 
 'type'    => hash,
 'bind' =>[{'index'=>'nc',    'struct'=>''}]
);
%STAuthParam=
('name'    => 'AuthParam',
 'pattern' => '', 
 'match'   => "($PtAuthParamName)$PtEQUAL((?:$PtToken|$PtQuotedString))", 
 'type'    => hash,
 'bind' =>[{'index'=>'name',   'struct'=>''},
	   {'index'=>'val',    'struct'=>''}]
);

%STAuthorizationDigest =
('name'    => 'AuthorizationDigest',
 'pattern' => '', 
 'match'   => "($PtUsername)|($PtRealm)|($PtNonce)|($PtDigestUri)|($PtDresponse)|($PtAlgorithm)|($PtCnonce)|($PtOpaque)|($PtMessageQop)|($PtNonceCount)|($PtAuthParam)", 
 'type'    => one,
 'bind' => [{'index'=>'', 'struct'=>\%STUsername},
	    {'index'=>'', 'struct'=>\%STRealm},
	    {'index'=>'', 'struct'=>\%STNonce},
	    {'index'=>'', 'struct'=>\%STDigestUri},
	    {'index'=>'', 'struct'=>\%STDresponse},
	    {'index'=>'', 'struct'=>\%STAlgorithm},
	    {'index'=>'', 'struct'=>\%STCnonce},
	    {'index'=>'', 'struct'=>\%STOpaque},
	    {'index'=>'', 'struct'=>\%STMessageQop},
	    {'index'=>'', 'struct'=>\%STNonceCount},
	    {'index'=>'', 'struct'=>\%STAuthParam}],
);

%STAuthorizationDigestS =
('name'    => 'AuthorizationDigestS',
 'pattern' => '', 
 'match'   => "(?:($PtUsername)|($PtRealm)|($PtNonce)|($PtDigestUri)|($PtDresponse)|($PtAlgorithm)|($PtCnonce)|($PtOpaque)|($PtMessageQop)|($PtNonceCount)|($PtAuthParam))", 
 'type'    => array,
 'bind' => [{'index'=>'', 'struct'=>\%STAuthorizationDigest}],
);


%STAuthorization =
('name'    => 'Authorization',
 'pattern' => '', 
 'match'   => "(?:(?i:Digest)$PtLWS($PtDigestResponse))|$PtOtherResponse", 
 'type'    => hash,
 'bind' => [{'index'=>'digest', 'struct'=>\%STAuthorizationDigestS},
	    {'index'=>'other',  'struct'=>''}],
);

%STProxyAuthorization =
('name'    => 'ProxyAuthorization',
 'pattern' => '', 
 'match'   => "(?:(?i:Digest)$PtLWS($PtDigestResponse))|$PtOtherResponse", 
 'type'    => hash,
 'bind' => [{'index'=>'digest', 'struct'=>\%STAuthorizationDigestS},
	    {'index'=>'other',  'struct'=>''}],
);

# domain              =  "domain" EQUAL LDQUOT URI *( 1*SP URI ) RDQUOT
# stale               =  "stale" EQUAL ( "true" / "false" )
# qop-options         =  "qop" EQUAL LDQUOT qop-value *("," qop-value) RDQUOT

%STDomain=
('name'    => 'Domain',
 'pattern' => '', 
 'match'   => "(?i:domain)$PtEQUAL($PtLDQUOT$PtURI(?:\s+$PtURI)*$PtRDQUOT)", 
 'type'    => hash,
 'bind' =>[{'index'=>'domain',    'struct'=>''}]
);
%STStale=
('name'    => 'Stale',
 'pattern' => '', 
 'match'   => "(?i:stale)$PtEQUAL((?i:true|false))", 
 'type'    => hash,
 'bind' =>[{'index'=>'stale',    'struct'=>''}]
);
%STQopOptions=
('name'    => 'QopOptions',
 'pattern' => '', 
 'match'   => "(?i:qop)$PtEQUAL($PtLDQUOT$PtQopValue(?:,$PtQopValue)*$PtRDQUOT)", 
 'type'    => hash,
 'bind' =>[{'index'=>'qop',    'struct'=>''}]
);

%STDigestCln =
('name'    => 'AuthorizationDigest',
 'pattern' => '', 
 'match'   => "($PtRealm)|($PtDomain)|($PtNonce)|($PtOpaque)|($PtStale)|($PtAlgorithm)|($PtQopOptions)|($PtAuthParam)", 
 'type'    => one,
 'bind' => [{'index'=>'', 'struct'=>\%STRealm},
	    {'index'=>'', 'struct'=>\%STDomain},
	    {'index'=>'', 'struct'=>\%STNonce},
	    {'index'=>'', 'struct'=>\%STOpaque},
	    {'index'=>'', 'struct'=>\%STStale},
	    {'index'=>'', 'struct'=>\%STAlgorithm},
	    {'index'=>'', 'struct'=>\%STQopOptions},
	    {'index'=>'', 'struct'=>\%STAuthParam}],
);

%STDigestClnS =
('name'    => 'AuthorizationDigestS',
 'pattern' => '', 
 'match'   => "(?:($PtRealm)|($PtDomain)|($PtNonce)|($PtOpaque)|($PtStale)|($PtAlgorithm)|($PtQopOptions)|($PtAuthParam))", 
 'type'    => array,
 'bind' => [{'index'=>'', 'struct'=>\%STDigestCln}],
);

%STWWWAuthenticate =
('name'    => 'WWW-Authenticate',
 'pattern' => '', 
 'match'   => "(?:(?i:Digest)$PtLWS($PtDigestCln(?:$PtCOMMA$PtDigestCln)*))|$PtOtherResponse", 
 'type'    => hash,
 'bind' => [{'index'=>'digest', 'struct'=>\%STDigestClnS},
	    {'index'=>'other',  'struct'=>''}],
);

%STProxyAuthenticate =
('name'    => 'Proxy-Authenticate',
 'pattern' => '', 
 'match'   => "(?:(?i:Digest)$PtLWS($PtDigestCln(?:$PtCOMMA$PtDigestCln)*))|$PtOtherResponse", 
 'type'    => hash,
 'bind' => [{'index'=>'digest', 'struct'=>\%STDigestClnS},
	    {'index'=>'other',  'struct'=>''}],
);

%STPrivacy=
('name'    => 'Privacy',
 'pattern' => $PtPrivacy, 
 'match'   => "(?:($PtPrivValue))|(?:$PtSEMI($PtPrivValue))", 
 'type'    => array,
 'bind' => [{'index'=>'val', 'struct'=>''}],
);

%STPAssertedIDParam=
('name'    => 'PAssertedIDParam',
 'pattern' => '', 
 'match'   => "(?:($PtNameAddr)|($PtAddrSpec))", 
 'type'    => hash,
 'bind' => [{'index'=>'ad',    'struct'=>\%STNameAddr},
	    {'index'=>'ad',    'struct'=>\%STAddrSpec}],
);

%STPAssertedIDParamS=
('name'    => 'PAssertedIDParamS',
 'pattern' => '',
 'match'   => "(?:$PtCOMMA($PtPAssertedIDValue))", 
 'type'    => array,
 'bind' => [{'index'=>'',    'struct'=>\%STPAssertedIDParam}],
);

%STPAssertedID=
('name'    => 'P-Asserted-Identity',
 'pattern' => $PtPAssertedID, 
 'match'   => "($PtPAssertedIDValue)((?:$PtCOMMA$PtPAssertedIDValue)*)", 
 'type'    => 'marge-array',
 'bind' => [{'index'=>'val',     'struct'=>\%STPAssertedIDParam},
	    {'index'=>'rest',    'struct'=>\%STPAssertedIDParamS}],
);

%STPPreferredIDParam=
('name'    => 'PPreferredIDParam',
 'pattern' => '', 
 'match'   => "(?:($PtNameAddr)|($PtAddrSpec))", 
 'type'    => hash,
 'bind' => [{'index'=>'ad',    'struct'=>\%STNameAddr},
	    {'index'=>'ad',    'struct'=>\%STAddrSpec}],
);

%STPPreferredIDParamS=
('name'    => 'PPreferredIDParamS',
 'pattern' => '',
 'match'   => "(?:$PtCOMMA($PtPAssertedIDValue))", 
 'type'    => array,
 'bind' => [{'index'=>'',    'struct'=>\%STPAssertedIDParam}],
);

%STPPreferredID=
('name'    => 'P-Preferred-Identity',
 'pattern' => $PtPPreferredID, 
 'match'   => "(?:($PtPPreferredIDValue))|(?:$PtCOMMA($PtPPreferredIDValue))", 
 'type'    => 'marge-array',
 'bind' => [{'index'=>'val',     'struct'=>\%STPPreferredIDParam},
	    {'index'=>'rest',    'struct'=>\%STPPreferredIDParamS}],
);

%STRAck=
('name'    => 'RAck',
 'pattern' => $PtRAck, 
 'match'   => "($PtResponseNum)$PtLWS($PtCSeqNum)$PtLWS($PtMethod)", 
 'type'    => 'hash',
 'bind' => [{'index'=>'responsenum','struct'=>''},
	    {'index'=>'cseqnum',    'struct'=>''},
	    {'index'=>'method',     'struct'=>''}],
);

%STRSeq=
('name'    => 'RSeq',
 'pattern' => $PtRSeq, 
 'match'   => "($PtResponseNum)", 
 'type'    => 'hash',
 'bind' => [{'index'=>'responsenum','struct'=>''}],
);

%STReferToParam =
('name'    => 'ReferToParam',
 'match'   => "($PtTagParam)|($PtGenericParam)", 
 'type'    => 'one',
 'bind' =>[{'index'=>'',      'struct'=>\%STTagParam},
	   {'index'=>'',      'struct'=>\%STGenericParam},]
);

%STReferToParams =
('name'    => 'ReferToParams',
 'pattern' => '', 
 'match'   => "$PtSEMI($PtReferToParam)", 
 'type'    => 'array',
 'bind' =>[{'index'=>'',      'struct'=>\%STReferToParam}],
);

%STReferTo=
('name'    => 'ReferTo',
 'pattern' => $PtReferTo, 
 'match'   => "(?:($PtNameAddr)|($PtAddrSpec))(.*)",
 'type'    => 'hash',
 'bind' => [{'index'=>'ad',    'struct'=>\%STNameAddr},
	    {'index'=>'ad',    'struct'=>\%STAddrSpec},
	    {'index'=>'param', 'struct'=>\%STReferToParams}],
);

############# SDP ##############################

%STMediaField =
('name'    => 'MediaField',
 'pattern' => '', 
 'match'   => "($PtMedia)$PtSpace($PtPort(?:/$PtInteger)?)$PtSpace($PtProto)((?:$PtSpace$PtFmt)+)", 
 'type'    => hash,
 'bind' => [{'index'=>'media', 'struct'=>''},
	    {'index'=>'port',  'struct'=>''},
	    {'index'=>'proto', 'struct'=>''},
	    {'index'=>'fmt',   'struct'=>''}],
);

%STBandwidthFieldS =
('name'    => 'BandwidthFieldS',
 'pattern' => '', 
 'match'   => "(?:(?i:b)=($PtBandwidthFields)$PtCRLF)", 
 'type'    => array,
 'bind' => [{'index'=>'methods', 'struct'=>''}],
);

%STConnectionFieldS =
('name'    => 'ConnectionFieldS',
 'pattern' => '', 
 'match'   => "(?:(?i:c)=($PtConnectionField)$PtCRLF)", 
 'type'    => array,
 'bind' => [{'index'=>'methods', 'struct'=>''}],
);

%STAttributeFields =
('name'    => 'AttributeFields',
 'pattern' => '', 
 'match'   => "(?:($PtAttField):($PtAttValue))|((?:$PtAttField))", 
 'type'    => hash,
 'bind' => [{'index'=>'field', 'struct'=>''},
	    {'index'=>'value', 'struct'=>''},
	    {'index'=>'field', 'struct'=>''}]
);

%STAttributeFieldsS =
('name'    => 'AttributeFieldsS',
 'pattern' => '', 
 'match'   => "(?:(?i:a)=((?:$PtAttributeFields))$PtCRLF)", 
 'type'    => array,
 'bind' => [{'index'=>'methods', 'struct'=>\%STAttributeFields}],
);

%STMediaDescriptions =
('name'    => 'MediaDescriptions',
 'pattern' => '', 
 'match'   => "($PtMediaField)$PtCRLF(?:(?i:i)=($PtInformationField)$PtCRLF)?((?:(?i:c)=$PtConnectionField$PtCRLF)*)((?:(?i:b)=$PtBandwidthFields$PtCRLF)*)(?:(?i:k)=($PtKeyField)$PtCRLF)?((?:(?i:a)=(?:$PtAttributeFields)$PtCRLF)*)", 
 'type'    => hash,
 'bind' => [{'index'=>'media',     'struct'=>\%STMediaField},
	    {'index'=>'info',      'struct'=>''},
	    {'index'=>'connection','struct'=>\%STConnectionFieldS},
	    {'index'=>'bandwidth', 'struct'=>\%STBandwidthFieldS},
	    {'index'=>'key',       'struct'=>''},
	    {'index'=>'attr',      'struct'=>\%STAttributeFieldsS}]
);


# 
$PtnMainPart      = qq{^(.+?)$PtCRLF(.+?$PtCRLF)$PtCRLF(.*)};

# 
$PtTAGS            = qq{(?:^(?:(?i:Accept)|(?i:Accept-Encoding)|(?i:Accept-Language)|(?i:Alert-Info)|(?i:Allow)|(?i:Authentication-Info)|(?i:Authorization)|(?i:Call-ID)|(?i:Call-Info)|(?i:Contact)|(?i:Content-Disposition)|(?i:Content-Encoding)|(?i:Content-Language)|(?i:Content-Length)|(?i:Content-Type)|(?i:CSeq)|(?i:Date)|(?i:Error-Info)|(?i:Expires)|(?i:From)|(?i:In-Reply-To)|(?i:Max-Forwards)|(?i:MIME-Version)|(?i:Min-Expires)|(?i:Min-SE)|(?i:Organization)|(?i:Priority)|(?i:Proxy-Authenticate)|(?i:Proxy-Authorization)|(?i:Proxy-Require)|(?i:Record-Route)|(?i:Reply-To)|(?i:Require)|(?i:Retry-After)|(?i:Route)|(?i:Server)|(?i:Session-Expires)|(?i:Subject)|(?i:Supported)|(?i:Timestamp)|(?i:To)|(?i:Unsupported)|(?i:User-Agent)|(?i:Via)|(?i:Warning)|(?i:Allow-Events)|(?i:WWW-Authenticate)|(?i:Privacy)|(?i:P-Asserted-Identity)|(?i:P-Preferred-Identity)|(?i:RAck)|(?i:RSeq)|(?i:[imelcfsktv])))};
#$PtTAGS            = qq{(?:^(?:(?i:Accept)|(?i:Accept-Encoding)|(?i:Accept-Language)|(?i:Alert-Info)|(?i:Allow)|(?i:Authentication-Info)|(?i:Authorization)|(?i:Call-ID)|(?i:Supported)|(?i:Warning)|(?i:Allow-Events)|(?i:Accept)))};
# 
$PtUNHEADER        = qq{(?!^$PtTAGS$PtHCOLON)(.*?)$PtCRLF};
# 
$PtHEADER          = qq{$PtTAGS$PtHCOLON(?:(?:.*?$PtCRLF)|(?:$PtUNHEADER))};

###############################################
# 
#
#  name:     
#  pattern:  
#  func:     
#  rex:      
#
%PatternNameDB={};
@FirstPatternTable=
(
 {'name' => 'Request-Line',	'pattern' => "$PtMethod\\s$PtRequestURI\\s$PtSIPVersion",
                                'struct'  => \%STRequestLine},
 {'name' => 'Status-Line',	'pattern' => "$PtSIPVersion\\s(?:$PtDigit){1,3}\\s$PtReasonPhrase",
                                'struct'  => \%STStatusLine},
);

@HdrPatternTable=
(
# {'name' => 'Accept',		  'pattern' => "(?i:Accept)$PtHCOLON((?:(?!\r\n\\S+:).+)?)"},  
 {'name' => 'Accept',		  'pattern' => "(?i:Accept)$PtHCOLON(.*?)"},
 {'name' => 'Accept-Encoding',	  'pattern' => "(?i:Accept-Encoding)$PtHCOLON(.*?)"},
 {'name' => 'Accept-Language',	  'pattern' => "(?i:Accept-Language)$PtHCOLON(.*?)"},
 {'name' => 'Alert-Info',	  'pattern' => "(?i:Alert-Info)$PtHCOLON(.*?)"},
 {'name' => 'Allow',		  'pattern' => $PtAllow,  'struct' => \%STAllow},
 {'name' => 'Authentication-Info','pattern' => "(?i:Authentication-Info)$PtHCOLON(.*?)"},
 {'name' => 'Authorization',	  'pattern' => $PtAuthorization,  'struct' => \%STAuthorization},
 {'name' => 'Call-ID',		  'pattern' => $PtCallID,  'alias'=> 'i',  'struct' => \%STCallID},
 {'name' => 'Call-Info',	  'pattern' => "(?i:Call-Info)$PtHCOLON(.*?)"},
 {'name' => 'Contact',		  'pattern' => $PtContact,  'alias'=> 'm',  'struct' => \%STContact},
 {'name' => 'Content-Disposition','pattern' => "(?i:Content-Disposition)$PtHCOLON(.*?)"},
 {'name' => 'Content-Encoding',	  'pattern' => "(?i:Content-Encoding|e)$PtHCOLON(.*?)",  'alias'=> 'e'},
 {'name' => 'Content-Language',	  'pattern' => "(?i:Content-Language)$PtHCOLON(.*?)"},
 {'name' => 'Content-Length',	  'pattern' => $PtContentLength,  'alias'=> 'l'},
 {'name' => 'Content-Type',	  'pattern' => $PtContentType,  'alias'=> 'c', 'struct' => \%STContentType},
 {'name' => 'CSeq',		  'pattern' => $PtCSeq,   'struct' => \%STCSeq},
 {'name' => 'Date',		  'pattern' => "(?i:Date)$PtHCOLON($PtSIPdate)", 'struct' => \%STDate},
 {'name' => 'Error-Info',	  'pattern' => "(?i:Error-Info)$PtHCOLON(.*?)"},
 {'name' => 'Expires',		  'pattern' => $PtExpires,  'struct' => \%STExpires},
 {'name' => 'From',		  'pattern' => $PtFrom,  'alias'=> 'f',  'struct' => \%STFrom},
 {'name' => 'In-Reply-To',	  'pattern' => "(?i:In-Reply-To)$PtHCOLON(.*?)"},
 {'name' => 'Max-Forwards',	  'pattern' => $PtMaxForwards},
 {'name' => 'MIME-Version',	  'pattern' => "(?i:MIME-Version)$PtHCOLON(.*?)"},
 {'name' => 'Min-SE',	          'pattern' => $PtMinSE, 'struct' => \%STMinSE},
 {'name' => 'Min-Expires',	  'pattern' => "(?i:Min-Expires)$PtHCOLON(.*?)"},
 {'name' => 'Organization',	  'pattern' => "(?i:Organization)$PtHCOLON(.*?)"},
 {'name' => 'Priority',		  'pattern' => "(?i:Priority)$PtHCOLON(.*?)"},
 {'name' => 'Proxy-Authenticate', 'pattern' => "(?i:Proxy-Authenticate)$PtHCOLON(.*?)",'struct' => \%STProxyAuthenticate},
 {'name' => 'Proxy-Authorization','pattern' => $PtProxyAuthorization,  'struct'  => \%STProxyAuthorization},
 {'name' => 'Proxy-Require',	  'pattern' => "(?i:Proxy-Require)$PtHCOLON(.*?)",},
 {'name' => 'Record-Route',	  'pattern' => $PtRecordRoute,  'struct' => \%STRecordRoute},
 {'name' => 'Reply-To',		  'pattern' => $PtReplyTo, 'struct' => \%STReplyTo},
 {'name' => 'Require',		  'pattern' => "(?i:Require)$PtHCOLON(.*?)",},
 {'name' => 'Retry-After',	  'pattern' => "(?i:Retry-After)$PtHCOLON(.*?)",  'struct' => \%STRetryAfter},
 {'name' => 'Route',		  'pattern' => $PtRoute,   'struct' => \%STRoute},
 {'name' => 'Server',		  'pattern' => "(?i:Server)$PtHCOLON(.*?)",},
 {'name' => 'Session-Expires',	  'pattern' => $PtSessionExpires,  'alias'=> 'x', 'struct' => \%STSessionExpires},
 {'name' => 'Subject',		  'pattern' => "(?i:Subject|s)$PtHCOLON(.*?)",  'alias'=> 's'},
 {'name' => 'Supported',	  'pattern' => "(?:Supported|k)$PtHCOLON(.*?)", 'alias'=> 'k'},
 {'name' => 'Timestamp',	  'pattern' => "(?i:Timestamp)$PtHCOLON(.*?)",  'struct'  => \%STTimestamp},
 {'name' => 'To',		  'pattern' => $PtTo,  'alias'=> 't', 'struct' => \%STTo},
 {'name' => 'Unsupported',	  'pattern' => "(?i:Unsupported)$PtHCOLON(.*?)"},
 {'name' => 'User-Agent',	  'pattern' => "(?i:User-Agent)$PtHCOLON(.*?)"},
 {'name' => 'Via',		  'pattern' => $PtVia,  'alias'=> 'v', 'struct' => \%STVia},
 {'name' => 'Warning',		  'pattern' => "(?i:Warning):(.*?)",},
 {'name' => 'Allow-Events',	  'pattern' => "(?i:Allow-Events):(.*?)",},
 {'name' => 'WWW-Authenticate',	  'pattern' => $PtWWWAuthenticate, 'struct' => \%STWWWAuthenticate},
 {'name' => 'Anonymity',	  'pattern' => "(?i:Anonymity)$PtHCOLON(.*?)"},
 {'name' => 'Referred-By',	  'pattern' => "(?i:Referred-By)$PtHCOLON(.*?)"},
 {'name' => 'Privacy',	          'pattern' => $PtPrivacy, 'struct' => \%STPrivacy},
 {'name' => 'P-Asserted-Identity','pattern' => $PtPAssertedID, 'struct' => \%STPAssertedID},
 {'name' => 'P-Preferred-Identity','pattern' => $PtPPreferredID, 'struct' => \%STPPreferredID},
 {'name' => 'RAck',	          'pattern' => $PtRAck, 'struct' => \%STRAck},
 {'name' => 'RSeq',	          'pattern' => $PtRSeq, 'struct' => \%STRSeq}, );


# SDP order defined by RFC2327 (v,o,s,(i),(u),(e),(p),(c),(b),t,(r),(z),(k),(a),m,(i),(c),(b),(k),a)
# Mutliple Time descriptions(t= and r=) is not supported yet
@BodyPatternTable=
(
 {'name' => 'a=',  'pattern' => "(?i:a)=($PtAttributeFields)",    'struct'  => \%STAttributeFields,},
 {'name' => 'b=',  'pattern' => "(?i:b)=($PtBandwidthFields)",},
 {'name' => 'c=',  'pattern' => "(?i:c)=($PtConnectionField)",},
 {'name' => 'e=',  'pattern' => "(?i:e)=(.+?)",},
 {'name' => 'i=',  'pattern' => "(?i:i)=($PtInformationField)",},
 {'name' => 'k=',  'pattern' => "(?i:k)=($PtKeyField)",},
 {'name' => 'm=',  'pattern' => "(?i:m)=($PtMediaDescriptions)", 'struct'  => \%STMediaDescriptions,},
 {'name' => 'o=',  'pattern' => "(?i:o)=(.+?)",},
 {'name' => 'p=',  'pattern' => "(?i:p)=(.+?)",},
 {'name' => 'r=',  'pattern' => "(?i:r)=(.+?)",},
 {'name' => 's=',  'pattern' => "(?i:s)=(.+?)",},
 {'name' => 't=',  'pattern' => "(?i:t)=(.+?)",},
 {'name' => 'u=',  'pattern' => "(?i:u)=(.+?)",},
 {'name' => 'v=',  'pattern' => "(?i:v)=(.+?)",},
 {'name' => 'z=',  'pattern' => "(?i:z)=(.+?)",} );

%BNFPatternTable;

# 
$SIPLastParseST = '';

# 
$SIPFindTag='';
$SIPFindNextTbl='';
$SIPFindNextPos=0;

# 
@FindFieldValueList;

###############################################
# 
#   
#     request:  
#     status:  
#     header:  
#     body:  
#     command_txt:  
#     header_txt:  
#     body_txt:  
#     frame_txt:  
#   request
#     method:  
#     uri:  
#     version:  
#     txt:  
#   status
#     version:  
#     code:  
#     reason:  
#     txt:  
#   header
#     tag:
#     val:  
#     txt:  

# 
sub SipParseInitilaize{
    my($i);
    # 
    $PTMainPart    = qr/$PtnMainPart/s ;  # /s
    for($i=0; $i<=$#FirstPatternTable; $i++){
	$FirstPatternTable[$i]{rex} = qr/$FirstPatternTable[$i]{pattern}/s;
	$PatternNameDB{lc($FirstPatternTable[$i]{name})}=$FirstPatternTable[$i]{name};
    }
    for($i=0; $i<=$#HdrPatternTable; $i++){
	$HdrPatternTable[$i]{rex} = qr/$HdrPatternTable[$i]{pattern}/s;
	$PatternNameDB{lc($HdrPatternTable[$i]{name})}=$HdrPatternTable[$i]{name};
	if($HdrPatternTable[$i]{alias}){$PatternNameDB{lc($HdrPatternTable[$i]{alias})}=$HdrPatternTable[$i]{name};}
    }
    for($i=0; $i<=$#BodyPatternTable; $i++){
	if($BodyPatternTable[$i]{name} eq 'm='){
	    $BodyPatternTable[$i]{rex} = qr/((?i:m)=$PtMediaDescriptions)/s;
	}
	else{
	    $BodyPatternTable[$i]{rex} = qr/$BodyPatternTable[$i]{pattern}$PtCRLF/s;
	}
	$PatternNameDB{lc($BodyPatternTable[$i]{name})}=$BodyPatternTable[$i]{name};
    }
    $BNFPatternTable{PtNameAddr}      = qr/$PtNameAddr/s;
    $BNFPatternTable{PtAddrSpec}      = qr/$PtAddrSpec/s;
    $BNFPatternTable{PtSIPUri}        = qr/$PtSIPUri/s;
    $BNFPatternTable{PtSIPSUri}       = qr/$PtSIPSUri/s;
    $BNFPatternTable{PtAbsoluteUri}   = qr/$PtAbsoluteUri/s;
    $BNFPatternTable{PtUserinfo}      = qr/$PtUserinfo/s;
    $BNFPatternTable{PtHostport}      = qr/$PtHostport/s;
    $BNFPatternTable{PtUriParameters} = qr/$PtUriParameters/s;
    $BNFPatternTable{PtHeaders}       = qr/$PtHeaders/s;
}

# SIP
#  
sub SipParsePart{
    my($pMsg,$part)=@_;
    my($request,$header,$body,%pktInfo,$partInfo,$i,@val,@stack);

    # 
    if(ref($pMsg) ne 'HASH'){
	if( $pMsg =~ /$PTMainPart/ ){
	    $request=$1;$header=$2;$body=$3;
	    $pktInfo{frame_txt}=$pMsg;
	    $pktInfo{command_txt}=$request;
	    $pktInfo{header_txt}=$header;
	    $pktInfo{body_txt}=$body;
	    $pktInfo{frame_txt}=$pMsg;
	    $pMsg=\%pktInfo;
	}
	else{
	    @stack=caller(1);
	    MsgPrint('ERR',"Unmatch sip pattern[%s] called[%s]\n",$pMsg,$stack[3]);
	    LOG_Err("Sip message format illegal(CRLF mismatch etc..)");
	    $pMsg='';
	    goto EXIT;
	}
    }
    if(!$part){
	$partInfo=$pMsg;
	goto EXIT;
    }

    # 
    if($pMsg->{ParseLevel}->{ALL} || $pMsg->{ParseLevel}->{$part}){
	MsgPrint('HEX',"Already Parising [$part]\n");

	if($part eq 'COMMAND'){
	    $partInfo=$pMsg->{command};
	}
	elsif($part eq 'HEADER'){
	    $partInfo=$pMsg->{header};
	}
	elsif($part eq 'BODY'){
	    $partInfo=$pMsg->{body};
	}
	elsif($part ne 'ALL'){
	    if(substr($part,1,1) eq '='){
		$body=$pMsg->{body};
		for($i=0;$i<=$#$body;$i++){
		    # 
		    if( $$body[$i]->{val} && $$body[$i]->{tag} eq $part ){
			push(@val,$$body[$i]);
			$partInfo=\@val;
		    }
		}
	    }
	    else{
		$header=$pMsg->{header};
		for($i=0;$i<=$#$header;$i++){
		    # 
#		    if( $$header[$i]->{val} && $$header[$i]->{tag} eq $part ){
		    if( $$header[$i]->{tag} eq $part ){
			push(@val,$$header[$i]);
			$partInfo=\@val;
		    }
		}
	    }
	}
	goto EXIT;
    }

    # 
    if($part eq 'ALL' || $part eq 'COMMAND' ){
	MsgPrint(HEX, "Parising COMMAND\n");
	$partInfo=SipParseRequestAndStatus($pMsg->{command_txt});
	$pMsg->{command}=$partInfo;
    }

    # 
    if($part eq 'ALL' || $part eq 'HEADER' ){
	MsgPrint('HEX', "Parising HEADER\n");
	if(!$pMsg->{header}){
#	    $pMsg->{header}=CodeTimeEx('SipParseHeader1', $pMsg->{header_txt});
	    $pMsg->{header}=SipParseHeader1($pMsg->{header_txt});
	}
	$partInfo=$pMsg->{header};
	if($part eq 'ALL'){
#	    ($pMsg->{header},$partInfo)=CodeTimeEx('SipParseHeader2',$pMsg->{header},'*');
	    ($pMsg->{header},$partInfo)=SipParseHeader2($pMsg->{header},'*');
	}
    }

    # 
    if($part eq 'ALL' || $part eq 'BODY' ){
	MsgPrint('HEX', "Parising BODY\n");
	if(!$pMsg->{body}){
	    $pMsg->{body}=SipParseBody1($pMsg->{body_txt});
	}
	$partInfo=$pMsg->{body};
	if($part eq 'ALL'){
	    ($pMsg->{body},$partInfo)=SipParseBody2($pMsg->{body},'*');
	}
    }

    # 
    if($part ne 'ALL' && $part ne 'COMMAND' && $part ne 'HEADER' && $part ne 'BODY' ){
	MsgPrint('HEX', "Parising $part\n");
	if(substr($part,1,1) eq '='){
	    # 
	    if(!$pMsg->{body}){
		$pMsg->{body}=SipParseBody1($pMsg->{body_txt});
	    }
	    ($pMsg->{body},$partInfo)=SipParseBody2($pMsg->{body},$part);
	}
	else{
	    # 
	    if(!$pMsg->{header}){
#		$pMsg->{header}=CodeTimeEx('SipParseHeader1',$pMsg->{header_txt});
		$pMsg->{header}=SipParseHeader1($pMsg->{header_txt});
	    }
#	    ($pMsg->{header},$partInfo)=CodeTimeEx('SipParseHeader2',$pMsg->{header},$part);
	    ($pMsg->{header},$partInfo)=SipParseHeader2($pMsg->{header},$part);
	}
    }
  EXIT:
    $partInfo=$pMsg if($part eq 'ALL');

    # 
    if($partInfo){$pMsg->{ParseLevel}->{$part}=done;}

    $SIPLastParseST=$pMsg if($pMsg);
    return ($pMsg,$partInfo);
}

# 
sub SipParseRequestAndStatus {
    my($pMsg)=@_;
    my($pktInfo,$i);
    if($pMsg ne ''){
#	print "SipParseRequestAndStatus[$pMsg]\n";
	for($i=0; $i<=$#FirstPatternTable; $i++){
	    if( $pMsg =~ /\G$FirstPatternTable[$i]{rex}/mgc ){
		$pktInfo=SIPMakeStruct($pMsg,$FirstPatternTable[$i]{struct});
		$pktInfo={'tag'=>$FirstPatternTable[$i]{name},$FirstPatternTable[$i]{name}=>$pktInfo,'txt'=>$pMsg};
		last;
	    }
	}
	if($pktInfo eq ''){
#	    PrintVal($pMsg);BT();
	    MsgPrint('ERR',"Request / Status line missmatch\n");
	}
	return $pktInfo;
    }
    return 0;
}

# 
sub SipParseHeader1 {
    my($pMsg)=@_;
    my($i,$tag,@tags,$groupNo,$name,$txt);
    my $cont='cont';
    my %groupNum=(); # 

    if($pMsg ne ''){
	while($cont){
	    $cont='';
	    # 
#	    if( $pMsg =~ /\G($PtTAGS)$PtHCOLON((?:(?:$PtUNHEADER)*|(?:.*?$PtCRLF)))/mgco ){
	    # 
	    if( $pMsg =~ /\G(\S+?):((?:(?:(?:.*?$PtCRLF)(?:\s+?.*?$PtCRLF)+)|(?:.*?$PtCRLF)))/mgco ){
		if($name=$PatternNameDB{lc($1)}){
		    $txt=$2;
		    # 
		    $txt =~ s/\r\n//g;
		    # 
		    $txt =~ s/^\s*//;
		    # 
		    $txt =~ s/\s*$//;
		    $tag={};
		    # 
		    if( $groupNum{$name} ){
			$groupNo=$groupNum{$name}->{group}+1;
		    }
		    else{
			$groupNo=1;
		    }
		    
		    %$tag=('tag'=>$name,'txt'=>$txt,'group'=>$groupNo);
		    
		    # 
		    if(1<$groupNo){
			$groupNum{$name}->{next} = \%$tag;
		    }
		    $groupNum{$name}=\%$tag;
		    
		    
		    # 
		    $tag->{txt} =~ s/\r\n//;
		    push( @tags,\%$tag);
		    $cont='find';
#		    print "Tag[$name] Arg[$txt] Tag[\%$tag]\n";
		}
		else{
		    $name=$1;
		    $cont='skip';
		    $txt=$2;
		    # 
		    $txt =~ s/\r\n//g;
		    # 
		    $txt =~ s/^\s*//;
		    # 
		    $txt =~ s/\s*$//;
		    $tag={};
		    %$tag=('tag'=>$name,'txt'=>$txt,'group'=>1);
		    $tag->{txt} =~ s/\r\n//;
		    push( @tags,\%$tag);
		    MsgPrint('WAR',"Header Tag[$name] unknown,so parse skip.[$txt]\n");
		}
	    }
	    elsif($pMsg =~ /\G(.+?)$PtCRLF/mgc){
		# 
		$cont='skip';
		MsgPrint('ERR',"Header Tag[$1] dose not have : ,so skip\n");
	    }
#	    else{
#		MsgPrint('ERR',"Sip Parsing error, can't continue.[$pMsg]\n");
#	    }
	}
	return \@tags;
    }
    return 0;
}

# 
#   
sub SipParseHeader2 {
    my($tags,$tag)=@_;
    my($i,$j,@val);
    for($i=0;$i<=$#$tags;$i++){
	# 
	if( !$$tags[$i]->{val} && ($$tags[$i]->{tag} eq $tag || $tag eq '*')){
	    for($j=0; $j<=$#HdrPatternTable; $j++){
		if( $HdrPatternTable[$j]{name} eq $$tags[$i]->{tag} ){
		    last;
		}
	    }
	    $$tags[$i]->{val} = SIPMakeStruct($$tags[$i]->{txt},$HdrPatternTable[$j]{struct});
	    push(@val,$$tags[$i]);
	}
    }
    return ($tags,\@val);
}

sub FFParseHeader {
    my ($tag,$rule,$pktinfo,$context) = @_;
    my($ngtag,$txt,$partInfo);
    ($pktinfo,$partInfo)=SipParsePart($pktinfo,'HEADER');
#    PrintVal($partInfo);
    ($ngtag,$txt)=SipParseHeader3($partInfo,$tag);
    $context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'PARSE','ARG1:'=>$ngtag,'ARG2:'=>$txt};
    return !$ngtag;
}

sub SipParseHeader3 {
    my($tags,$tag)=@_;
    my($i,$j,@val,$msg);
    for($i=0;$i<=$#$tags;$i++){
	if( $tag eq '*' || $$tags[$i]->{tag} eq $tag ){
	    for($j=0; $j<=$#HdrPatternTable; $j++){
		if( $HdrPatternTable[$j]{name} eq $$tags[$i]->{tag} ){
		    last;
		}
	    }
	    $msg = $$tags[$i]->{tag} . ': ' . $$tags[$i]->{txt};
	    if( $msg =~ /^$HdrPatternTable[$j]{'pattern'}$/){
#		printf("OK[%s][%s]\n",$$tags[$i]->{tag},$msg);
	    }
	    else{
#		printf("NG[%s][%s]\n",$$tags[$i]->{tag},$msg);
		return $$tags[$i]->{tag},$$tags[$i]->{txt};
	    }
	}
    }
    return;
}


# 
sub SipParseBody1 {
    my($pMsg)=@_;
    my($i,$tag,@tags,$groupNo);
    my $cont='cont';
    my %groupNum=();

    if($pMsg ne ''){
	while($cont){
	    $cont='';
	    for($i=0; $i<=$#BodyPatternTable; $i++){
		if( $pMsg =~ /\G$BodyPatternTable[$i]{rex}/mgc ){
		    $tag={};
		    # 
		    if( $groupNum{$BodyPatternTable[$i]{name}} ){
			$groupNo=$groupNum{$BodyPatternTable[$i]{name}}->{group}+1;
		    }
		    else{
			$groupNo=1;
		    }

		    %$tag=('tag'=>$BodyPatternTable[$i]{name},'txt'=>$1,'group'=>$groupNo );
		    if(1<$groupNo){
			$groupNum{$BodyPatternTable[$i]{name}}->{next} = \%$tag;
		    }
		    $groupNum{$BodyPatternTable[$i]{name}}=\%$tag;
		    

		    # 
#		    $tag->{txt} =~ s/\r\n//;
		    push( @tags,\%$tag);
		    $cont='find';
#		    print 'Body Tag[' , $BodyPatternTable[$i]{name} , '] ' , 'Arg[' , $1 , "] Tag[",\%$tag, "]\n";
		}
	    }
	    # 
	    if($cont eq ''){
		if( $pMsg =~ /\G(.+?)$PtCRLF/mgc ){
		    $cont='skip';
		    MsgPrint('ERR',"Body Tag skip[$1]\n");
		}
	    }
	}
	return \@tags;
    }
    return 0;
}

# 
#   
sub SipParseBody2 {
    my($tags,$tag)=@_;
    my($i,$j,@val);
    for($i=0;$i<=$#$tags;$i++){
	# 
	if( !$$tags[$i]->{val} && ($$tags[$i]->{tag} eq $tag || $tag eq '*')){
	    for($j=0; $j<=$#BodyPatternTable; $j++){
		if( $BodyPatternTable[$j]{name} eq $$tags[$i]->{tag} ){
		    last;
		}
	    }
	    # 
	    if($BodyPatternTable[$j]{struct}){
		$$tags[$i]->{val} = SIPMakeStruct($$tags[$i]->{txt},$BodyPatternTable[$j]{struct});
	    }
	    elsif( $BodyPatternTable[$j]{func} ){
		$$tags[$i]->{val}=$BodyPatternTable[$j]{func}->($$tags[$i]->{txt});
	    }
	    else {
		$$tags[$i]->{val}={'id'=>$$tags[$i]->{tag},'param'=>$$tags[$i]->{txt}};
	    }
	    push(@val,$$tags[$i]);
	}
    }
    return ($tags,\@val);
}

sub FFParseBody {
    my ($tag,$rule,$pktinfo,$context) = @_;
    my($ngtag,$txt);
    ($ngtag,$txt)=SipParseBody3($pktinfo->{body},$tag);
    $context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'PARSE','ARG1:'=>$ngtag,'ARG2:'=>$txt};
    return !$ngtag;
}

sub SipParseBody3 {
    my($tags,$tag)=@_;
    my($i,$j,@val,$msg);
#    PrintItem($tags);
    for($i=0;$i<=$#$tags;$i++){
	if( $tag eq '*' || $$tags[$i]->{tag} eq $tag ){
	    for($j=0; $j<=$#BodyPatternTable; $j++){
		if( $BodyPatternTable[$j]{name} eq $$tags[$i]->{tag} ){
		    last;
		}
	    }
	    
	    #$msg = $$tags[$i]->{tag} . $$tags[$i]->{txt};	#2004.11.16 senba del.m
	    #2004.11.16 senba add start.
	    if($$tags[$i]->{tag} eq 'm='){
	       $msg = $$tags[$i]->{txt};
	    }
	    else{
	       $msg = $$tags[$i]->{tag} . $$tags[$i]->{txt};
	    }
            #2004.11.16 senba add end.

	    if( $msg =~ /^$BodyPatternTable[$j]{'pattern'}$/){
#		printf("OK[%s][%s]\n",$$tags[$i]->{tag},$msg);
	    }
	    else{
#		printf("NG[%s][%s]\n",$$tags[$i]->{tag},$msg);
		return $$tags[$i]->{tag},$$tags[$i]->{txt};
	    }
	}
    }
    return;
}

# 
sub SIPParseEqual{
    my($val1,$val2,$except)=@_;
    my(@key1,@key2,$i,$j,$ar1,$ar2,$i,$size);

    if(!ref($val1) && !ref($val2)){
	return($val1 eq $val2);
    }
    elsif(ref($val1) eq 'HASH' || ref($val2) eq 'HASH'){
	# 
	if($except){
	    if(ref($val1) && grep{$_ eq $val1->{id}} @$except){return 'T';}
	    if(ref($val2) && grep{$_ eq $val2->{id}} @$except){return 'T';}
	}
	if(!ref($val1) || !ref($val2)){return '';}
	@key1 = sort keys %$val1;
	@key2 = sort keys %$val2;
	# 
	if($#key1<$#key2){
	    for($i=0;$i<=$#key2;$i++){
		if($key2[$i] eq 'txt'){next;} # 
		if(!SIPParseEqual($val1->{$key2[$i]},$val2->{$key2[$i]},$except)){return '';}
	    }
	}
	else{
	    for($i=0;$i<=$#key1;$i++){
		if($key1[$i] eq 'txt'){next;} # 
		if(!SIPParseEqual($val1->{$key1[$i]},$val2->{$key1[$i]},$except)){return '';}
	    }
	}
	return 'T';
    }
    elsif(ref($val1) eq 'ARRAY' || ref($val2) eq 'ARRAY'){
#	PrintVal($val1);
#	PrintVal($val2);
	if(!ref($val1)){$val1=[$val1];}
	if(!ref($val2)){$val2=[$val2];}
	# 
	$size=$#$val1<$#$val2?$#$val2:$#$val1;
	for($i=0;$i<=$size;$i++){
	    if(!SIPParseEqual($val1->[$i],$val2->[$i],$except)){return '';}
	}
	return 'T';
    }
    else{
	return '';
    }
}

sub SipInfoDump {
    my($pktInfo)=@_;
    my($i,$tags);

#    printf( "SipInfoDump type[%s][%s]\n",ref($pktInfo),$pktInfo);
#    print "Sip Message=[$pktInfo->{frame_txt}]\n";

    if(ref($pktInfo) eq 'HASH'){
	# 
	if($pktInfo->{command}){
	    $tags=$pktInfo->{command};
	    # print "Requst/Status Line=[$pktInfo->{command_txt}]\n";
	    printf "  %s [$pktInfo->{command_txt}]\n",$pktInfo->{command}->{tag},$pktInfo->{command}->{txt};
	    SipStructDump($pktInfo->{command}->{$pktInfo->{command}->{tag}},3);
	}

# 	# 
# 	if($pktInfo->{request}){
# 	    print "  Method=[$pktInfo->{request}->{method}]\n";
# 	    print "  Uri=";SipStructDump($pktInfo->{request}->{uri},4);
# 	    print "  Version=[$pktInfo->{request}->{version}]\n";
# 	}
	
# 	# 
# 	if($pktInfo->{status}){
# 	    print "  Version=[$pktInfo->{status}->{version}]\n";
# 	    print "  Code=[$pktInfo->{status}->{code}]\n";
# 	    print "  Reason=[$pktInfo->{status}->{reason}]\n";
# 	}
	
	# 
#    print "Header=[",$pktInfo->{header_txt},"]\n";
	if($pktInfo->{header}){
	    $tags=$pktInfo->{header};
	    for($i=0;$i<=$#$tags;$i++){
		print "  No[$i][$$tags[$i]->{group}] Tag[$$tags[$i]->{tag}] Arg[$$tags[$i]->{txt}] Next[$$tags[$i]->{next}]\n";
		if($$tags[$i]->{val}){
		    print "        Val=";SipStructDump($$tags[$i]->{val},10);
		}
	    }
	}
	
	# 
#    print "Body=[",$pktInfo->{body_txt},"]\n";
	if($pktInfo->{body}){
	    $tags=$pktInfo->{body};
	    for($i=0;$i<=$#$tags;$i++){
		if($$tags[$i]->{next}){
		    printf "  No[$i][$$tags[$i]->{group}] Tag[$$tags[$i]->{tag}] Arg[$$tags[$i]->{txt}] nextArg[%s]\n",
		    $$tags[$i]->{next}->{txt};
		}
		else{
		    print "  No[$i][$$tags[$i]->{group}] Tag[$$tags[$i]->{tag}] Arg[$$tags[$i]->{txt}]\n";
		}
	    }
	}
#    print "Body=[",$pktInfo->{body}?$pktInfo->{body}->{txt} : 'none',"]\n";

    }
    elsif (ref($pktInfo) eq 'ARRAY'){
	SipStructDump($pktInfo);
    }
}


# 
# 
sub MsgPrint {
    my($level,$frm,@args)=@_;
    my($diff,$indent,@stack,$i);
    if(!grep{$_ eq $level} @SIPrexDEBUG){return '';}
#    $indent=1;$i=1;
#    while(@stack=caller($i++)){if($stack[3] eq 'main::GetSIPField'){$indent=1;}elsif(!$stack[6]){$indent++;}}
#    $indent=sprintf( sprintf("%%%ds",$indent-2), " " );
    if($SIM_Support_HiRes){
	$diff=($CNT_LAST_MSG_TIME?
	       Time::HiRes::tv_interval($CNT_LAST_MSG_TIME, [Time::HiRes::gettimeofday()]):0);
	printf($level . "[%6.1f]: " . $frm,$diff*1000,@args);
#	printf($level . "[%6.1f]:$indent" . $frm,$diff*1000,@args);
	$CNT_LAST_MSG_TIME=[Time::HiRes::gettimeofday()];
    }
    else{
	printf($level . ": " . $frm,@args);
#	printf($level . ":$indent" . $frm,@args);
    }
    return '';
}

sub MsgIndentPrint {
    my($val,$indent)=@_;
    if(!(grep{$_ eq 'DBG'} @SIPrexDEBUG)){return;}
    if($indent>0){
	printf( sprintf("%%%ds",$indent), " " );
    }
    print "$val";
}
sub IsLogLevel {
    my($level)=@_;
    return( grep{$_ eq $level} @SIPrexDEBUG );
}
# 
sub SIPMakeStruct {
    my($msg,$strTbl,$indent)=@_;

    if( $#_ < 2 ){ $indent=1; }
    my($match,$bind,$struct,$val,$i,@matched,$submsg,$indx,@vals);

    MsgIndentPrint("Enter name=[$strTbl->{name}] [$msg]\n",$indent);

    # 
    if(ref($strTbl->{match}) ne 'Regexp'){
	$strTbl->{match} = qr/$strTbl->{match}/;
    }
    $match = $strTbl->{match};
#    $match = qr/$strTbl->{match}/;  # 
    $bind = $strTbl->{bind};

    # 
    if($strTbl->{type} eq 'hash'){
	$struct={};
	$struct->{id}  = $strTbl->{name};
	$struct->{txt} = $msg;

	# 
	if(@matched = $msg =~ /$match/){

	    # 
	    for($i=0;$i<=$#$bind;$i++){

		# 
		$submsg=$matched[$i];

		# 
		if($submsg eq '') {next;}

		MsgIndentPrint("bind<hash>=[$i][$$bind[$i]{index}] match=[$submsg]\n",$indent);

		# 
#		if( $$bind[$i]{struct} && $submsg ){
		if( $$bind[$i]{struct} ){
		    $val=SIPMakeStruct($submsg,$$bind[$i]{struct},$indent+1);
		}
		else {
		    $val=$submsg;
		}

		MsgIndentPrint("val<hash>=[$val]\n",$indent);

		# 
		if($val ne ''){
		    $struct->{$$bind[$i]{index}} = $val;
		    # 
		    # if($$bind[$i]{struct}){$struct->{$$bind[$i]{index} . '-txt'} = $submsg;}
		}
	    }
	    return \%$struct;
	}
    }
    elsif($strTbl->{type} eq 'array'){
	$struct=();

	$indx=0;
	# 
	@matched = ($msg =~ /$match/g);
	foreach $submsg (@matched){
	    if($submsg){
		# 
		for($i=0;$i<=$#$bind;$i++){
		
		    MsgIndentPrint("bind<array>=[$i] match=[$submsg]\n",$indent);
		
		    # 
#		    if( $$bind[$i]{struct} && $submsg ){
		    if( $$bind[$i]{struct} ){
			$val=SIPMakeStruct($submsg,$$bind[$i]{struct},$indent+1);
		    }
		    else {
			$val=$submsg;
		    }
		
		    MsgIndentPrint("val<array>[$i]=[$val]\n",$indent);
		
		    # 
		    if($val ne ''){
			$$struct[$indx] = $val;
			# 
			# if($$bind[$i]{struct}){$struct->{$$bind[$i]{index} . '-txt'} = $submsg;}
		    }
		}
		$indx++;
	    }
	}
	return \@$struct;

    }
    # AAA(, AAA)* 
    elsif($strTbl->{type} eq 'marge-array'){
	$struct={};
	$struct->{id}  = $strTbl->{name};
	$struct->{txt} = $msg;

	# 
	if(@matched = $msg =~ /$match/){

	    # 
	    for($i=0;$i<=$#$bind;$i++){

		# 
		$submsg=$matched[$i];

		# 
		if($submsg eq '') {next;}

		MsgIndentPrint("bind<marge-array>=[$i][$$bind[$i]{index}] match=[$submsg]\n",$indent);

		# 
#		if( $$bind[$i]{struct} && $submsg ){
		if( $$bind[$i]{struct} ){
		    $val=SIPMakeStruct($submsg,$$bind[$i]{struct},$indent+1);
		}
		else {
		    $val=$submsg;
		}

		MsgIndentPrint("val<marge-array>=[$val]\n",$indent);

		# 
		if($val ne ''){
		    if(ref($val) eq 'ARRAY'){
			push(@vals,@$val);
		    }
		    else{
			push(@vals,$val);
		    }
		}
	    }
	    # 
	    $struct->{$$bind[0]{index}} = \@vals;

	    return \%$struct;
	}
	
    }
    elsif($strTbl->{type} eq 'one'){
	# 
	if($msg =~ /$match/){
	    
	    # 
	    for($i=0;$i<=$#$bind;$i++){
		
		# 
		$submsg=eval sprintf("\$%d",$i+1);
		
		if($submsg eq ''){next;}
		
		MsgIndentPrint("bind<one>=[$i] match=[$submsg]\n",$indent);
		
		# 
		if( $$bind[$i]{struct} ){
		    $val=SIPMakeStruct($submsg,$$bind[$i]{struct},$indent+1);
		}
		else {
		    $val=$submsg;
		}
		
		MsgIndentPrint("one=[$val]\n",$indent);
		return $val;
	    }
	    
	}
    }
    elsif($strTbl->{type} eq ''){
	return $msg;
    }
}

# 
sub SipStructDump {
    my($struct,$indent)=@_;
    my($i,$val,$key);
    if( $#_ < 1 ){
	$indent=1;
	print("-----SipStructDump----------\n");
    }
    push(@SIPrexDEBUG,'DBG');

#    print "Level[$indent]\n";
    if(ref($struct) eq 'HASH'){
	print "{\n";
	while(($key,$val)=each(%$struct)){
	    MsgIndentPrint("$key =>",$indent);
	    SipStructDump($val,$indent+1);
	}
	MsgIndentPrint("}\n",$indent-1);
    }
    elsif(ref($struct) eq 'ARRAY'){
	print "\n";
	for($i=0;$i<=$#$struct;$i++){
	    MsgIndentPrint("No[$i] =",$indent);
	    SipStructDump($$struct[$i],$indent+1);
	}
    }
    else{
#	MsgIndentPrint($struct,$indent);
	print " $struct\n";
    }
    pop(@SIPrexDEBUG);
}


# 
sub FNHrFrom {
    my($msg) = @_;
    print "FNHrFrom [$msg]\n";
}
sub FNHrTo {
    my($msg) = @_;
    print "FNHrTo [$msg]\n";
}
sub FNHrCallId {
    my($msg) = @_;
    print "FNHrCallId [$msg]\n";
}

sub FNBdAequal {
    my($msg) = @_;
    print "FNBdAequal [$msg]\n";
}

# 
sub FindSIPHeader {
    my ($tag,$pkt) = @_;
    my($i,$tags);

    $SIPFindTag='';
    $SIPFindNextTbl='';
    $SIPFindNextPos=0;

    if( $#_ < 1 ){ $pkt=$SIPLastParseST; }
    if(!$pkt || !$pkt->{header} ){
	return;
    }
    if( $#_ < 0 || $tag eq '' ){ return  $pkt->{header_txt};}

    $tags=$pkt->{header};
    for($i=0;$i<=$#$tags;$i++){
	if( $$tags[$i]->{tag} eq $tag ){
	    $SIPFindTag=$tag;
	    $SIPFindNextTbl=$tags;
	    $SIPFindNextPos=$i+1;
	    return ($$tags[$i]->{txt},$$tags[$i]->{val});
	}
    }
    return;
}
# 
sub IsCorrectPrioriyTagGroup {
    my ($group,$rule,$pktinfo) = @_;
    my($i,$tags,$ahead,@match);
    if( $pktinfo eq '' ){ $pktinfo=$SIPLastParseST; }

    SipParsePart($pktinfo,'HEADER');
    $tags=$pktinfo->{header};
    if( $group eq '' || $tags eq ''){ return;}

    $ahead=1;
    for($i=0;$i<=$#$tags;$i++){
	@match=grep{ $_ eq $$tags[$i]->{tag} } @$group;  # 040301 
	if(@match){
	    if( !$ahead ){ # 
#		print "tag=@match is uncorrect\n";
		return $match[0];
	    }
	}
	else{
	    $ahead='';
	}
    }
    return '';
}

# 
sub IsCorrectTagOrder {
    my ($order,$part,$rule,$pktinfo) = @_;
    my($i,$j,$tags,@tags);
    if( $pktinfo eq '' ){ $pktinfo=$SIPLastParseST; }

    if(!$part || $part eq 'BD'){
	SipParsePart($pktinfo,'BODY');
	@tags=map{$_->{tag} eq 'm='?$_->{txt}=~/^([a-x]=)/img:$_->{tag}} @{$pktinfo->{body}};
	$tags=\@tags;
#	PrintVal($tags);
    }
    elsif( $part eq 'HD'){
	SipParsePart($pktinfo,'HEADER');
	@tags=map{$_->{tag}} @{$pktinfo->{header}};
	$tags=\@tags;
    }
    if( $order eq ''){ return '';}
    if( $tags eq '' || $#$tags eq -1){ return 'MATCH';}

#    PrintItem("$#$order <=> $#$tags ");
    for($i=0,$j=0;$i<=$#$tags && $j<=$#$order;$i++,$j++){
#	PrintItem("$order->[$j] ne $$tags[$i]");
	# 
	if(ref($order->[$j]) eq 'SCALAR'){
	    if(${$order->[$j]} ne $$tags[$i]){$i--;next;}
	}
	elsif( $order->[$j] ne $$tags[$i] ){return ''}
	# 
	for($i++;$i<=$#$tags;$i++){
	    if( (ref($order->[$j])?${$order->[$j]}:$order->[$j]) ne $$tags[$i] ){
		$i--;
		last;
	    }
	}
    }
    return 'MATCH';
}

sub FindSIPBody {
    my ($tag,$pkt) = @_;
    my($i,$tags);

    $SIPFindTag='';
    $SIPFindNextTbl='';
    $SIPFindNextPos=0;

    if( $#_ < 1 ){ $pkt=$SIPLastParseST; }
    if(!$pkt || !$pkt->{body} ){
	return;
    }
    if( $#_ < 0 || $tag eq ''){ return  $pkt->{body_txt};}

    $tags=$pkt->{body};
    for($i=0;$i<=$#$tags;$i++){
	if( $$tags[$i]->{tag} eq $tag ){
	    $SIPFindTag=$tag;
	    $SIPFindNextTbl=$tags;
	    $SIPFindNextPos=$i+1;
	    return ($$tags[$i]->{txt},$$tags[$i]->{val});
	}
    }
    return;
}
sub FindSIPNext {
    my ($tag) = @_;
    my ($tags,$i);
    if( $#_ == 0 ){ $SIPFindTag=$tag; }

    if(!$SIPFindNextTbl || !$SIPFindTag){
	return;
    }
    $tags=$SIPFindNextTbl;
    for($i=$SIPFindNextPos;$i<=$#$tags;$i++){
	if( $$tags[$i]->{tag} eq $SIPFindTag ){
	    $SIPFindNextPos=$i+1;
	    return ($$tags[$i]->{txt},$$tags[$i]->{val});
	}
    }
    $SIPFindTag='';
    $SIPFindNextTbl='';
    $SIPFindNextPos=0;
    return;
}

#  
#     
sub GetSIPField {
    my($field,$pktinfo,$index)=@_;
    my(@tags,$vals,$val,$count,$partinfo,@tmp);
    @tags=split(/\./,$field);
    if($tags[0] eq 'HD'){
	if(!$tags[1]){
	    ($pktinfo,$partinfo)=SipParsePart($pktinfo,'HEADER');
	    return ($partinfo,1,$partinfo);
	}
	elsif($tags[1] eq 'txt'){
	    ($pktinfo,$partinfo)=SipParsePart($pktinfo,'HEADER');
	    return ($pktinfo->{header_txt},1,$pktinfo->{header_txt});
	}
	else{
	    ($pktinfo,$pktinfo)=SipParsePart($pktinfo,$tags[1]);
	    if($index ne '') {$pktinfo=$pktinfo->[$index];}
	    shift @tags;shift @tags;
	}
    }
    elsif($tags[0] eq 'BD'){
	if(!$tags[1]){
	    ($pktinfo,$partinfo)=SipParsePart($pktinfo,'BODY');
	    return ($partinfo,1,$partinfo);
	}
	elsif($tags[1] eq 'txt'){
	    ($pktinfo,$partinfo)=SipParsePart($pktinfo,'BODY');
	    return ($pktinfo->{body_txt},1,$pktinfo->{body_txt});
	}
	else{
	    ($pktinfo,$pktinfo)=SipParsePart($pktinfo,$tags[1]);
	    if($index ne '') {$pktinfo=$pktinfo->[$index];}
	    shift @tags;shift @tags;
	}
    }
    elsif($tags[0] eq 'RQ' || $tags[0] eq 'ST'){
	($pktinfo,$pktinfo)=SipParsePart($pktinfo,'COMMAND');
	shift @tags;
    }
    elsif($tags[0] eq 'TS'){
	if(!$pktinfo->{timestamp}){return('',0,'');}
	return($pktinfo->{timestamp},1,$pktinfo->{timestamp});
    }
    elsif($tags[0] eq 'UDP'){
	if(!$pktinfo->{pkt}){return('',0,'');}
	$pktinfo=$pktinfo->{pkt};
	shift @tags;
	@tags = $SIP_PL_IP eq 4 ? 
	    ('Frame_Ether','Packet_IPv4','Upp_UDP','Hdr_UDP',@tags):
	    ('Frame_Ether','Packet_IPv6','Upp_UDP','Hdr_UDP',@tags);
	$val=$pktinfo->{join('.',@tags)};
	if($val ne ''){return ($val,1,$val);}
	return('',0,'');
    }
    elsif($tags[0] eq 'IP6'){
	if(!$pktinfo->{pkt}){return('',0,'');}
	$pktinfo=$pktinfo->{pkt};
	shift @tags;
	@tags = $SIP_PL_IP eq 4 ?
	    ('Frame_Ether','Packet_IPv4','Hdr_IPv4',@tags):
	    ('Frame_Ether','Packet_IPv6','Hdr_IPv6',@tags);
	$val=$pktinfo->{join('.',@tags)};
	if($val ne ''){return ($val,1,$val);}
	return('',0,'');
    }
    elsif($tags[0] eq 'SIP'){
	return($pktinfo->{frame_txt},1,$pktinfo->{frame_txt});
    }
    elsif($tags[0] eq 'FRAME'){
	$val=$pktinfo->{pkt}->{recvFrame}?$pktinfo->{pkt}->{recvFrame}:$pktinfo->{pkt}->{sendFrame};
	if($val ne ''){return ($val,1,$val);}
	return('',0,'');
    }
    # 
    elsif($tags[0] eq 'RTP'){
	if(!$RTPPktInfoLast || !$RTPPktInfoLast->{pkt}){return('',0,'');}
	$pktinfo=$RTPPktInfoLast->{pkt};
	if($tags[1] eq 'IP6'){
	    shift @tags;shift @tags;
	    @tags = ('Frame_Ether','Packet_IPv6','Hdr_IPv6',@tags);
	}
	elsif($tags[1] eq 'IP4'){
	    shift @tags;shift @tags;
	    @tags = ('Frame_Ether','Packet_IPv4','Hdr_IPv4',@tags);
	}
	elsif($tags[1] eq 'UDP'){
	    shift @tags;shift @tags;
	    @tags = $SIP_PL_IP eq 4 ?
		('Frame_Ether','Packet_IPv4','Upp_UDP','Hdr_UDP',@tags):
		('Frame_Ether','Packet_IPv6','Upp_UDP','Hdr_UDP',@tags);
	}
	$val=$pktinfo->{join('.',@tags)};
	if($val ne ''){return ($val,1,$val);}
	return('',0,'');
    }
    # 
    $vals=GetSIPField2($pktinfo,@tags);
    if(ref($vals) eq 'ARRAY'){
	@tmp=grep{$_ ne 'Nil'} @$vals;
	$count = $#tmp+1;
	$vals=(0<$count?\@tmp:'');
	$val=$vals->[0];
    }
    elsif($vals eq 'Nil'){
	$count=0;
	$vals='';
	$val='';
    }
    else{
	$count=1;
	$val=$vals;
    }
    return ($vals,$count,$val);
}

sub GetSIPField2 {
    my($pktinfo,@tags)=@_;
    my($tag,$val,@vals,$i);

    if($pktinfo eq ''){return 'Nil';}
    if($#tags eq -1 ){return $pktinfo;}

    if(ref($pktinfo) eq 'ARRAY'){
	for($i=0;$i<=$#$pktinfo;$i++){
	    $val=GetSIPField2($pktinfo->[$i],@tags);
	    if(ref($val) eq 'ARRAY'){
		@vals = (@vals,@$val);
	    }
	    elsif($val ne ''){
		push(@vals,$val);
	    }
	}
	$val=(0<=$#vals?\@vals:'');
    }
    else{
	$tag=shift(@tags);
	$val=GetSIPField2($pktinfo->{$tag},@tags);
    }
    return $val;
}

# SIP
#   GetSIPParseField('via.sendby.host','SIP/2.0/UDP [3ffe:501:ffff:5::10]:5060',\%STVia);
sub GetSIPParseField {
    my($field,$msg,$strTbl)=@_;
    my($val,$pktinfo,$partinfo);
    if(ref($strTbl) ne 'HASH'){
	return;
    }
    ($pktinfo,$partinfo)=SIPMakeStruct($msg,$strTbl);
    $val=GetSIPField2($pktinfo,split(/\./,$field));
    return $val;
}

# 
sub FindSIPFieldValues {
    my($name,$struct,$field)=@_;
    my($rval,$rfield,$i,$val,$key);

    print("FindSIPFieldValues [$field]\n");
    if(ref($struct) eq 'ARRAY'){
	print("FindSIPFieldValues ARRAY($#$struct) [$field]\n");
	for($i=0;$i<=$#$struct;$i++){
	    FindSIPFieldValues($name,$$struct[$i],$field);
	}
    }
    elsif (ref($struct) eq 'HASH'){
	print("FindSIPFieldValues HASH [$field]\n");
	while(($key,$val)=each(%$struct)){
	    if($key eq $name){
		if($field eq ''){$rfield=$name;}
		else {$rfield=$field . '.' . $name;}
		print("  push field=>$val  val=>$rfield\n");
		push(@FindFieldValueList,{'field' => $val,'val' => $rfield});
	    }
	}
	while(($key,$val)=each(%$struct)){
	    if(ref($val) eq 'ARRAY' || ref($val) eq 'HASH'){
		if($field eq ''){$rfield=$key;}
		else {$rfield=$field . '.' . $key;}
		FindSIPFieldValues($name,$val,$rfield);
	    }
	}
    }
}

# 
sub FindSIPField {
    my($name,$struct)=@_;
    my($item);
    undef(@FindFieldValueList);

    FindSIPFieldValues($name,$struct);
    $item = pop(@FindFieldValueList);
    if($item){
	return($item->{val},$item->{field});
    }
}
sub FindSIPNextField {
    my($item);
    $item = pop(@FindFieldValueList);
    if($item){
	return($item->{val},$item->{field});
    }
}

sub PrintVal {
    my($val,$limit,$title,$indent)=@_;
    my(@stack);
    if( $indent eq ''){$indent=3;}
    @stack=caller(1);
    printf("-----PrintVal(%s / %s)----------\n",$title,$stack[3]);
    PrintVL($val,$indent,$limit);
}
sub PrintVL {
    my($val,$indent,$limit,$structMode)=@_;
    my($i,$key,$v,@keys,$class);

    unless($limit eq ''){
	if( --$limit < 0 ){return;}
    }
    if(ref($val) eq 'ARRAY'){
ARRAY:
	if($#$val<0){
	    printf( sprintf('%%%ds',$indent), " " );
	    printf("Array element Nothing\n");
	}
	for($i=0;$i<=$#$val;$i++){
	    printf( sprintf('%%%ds',$indent), " " );
	    if(!ref($val->[$i])){
		printf("No[%s] = %s\n",$i,($val->[$i] eq '')?Nil:$val->[$i]);
	    }
	    else{
		printf("No[%s] =\n",$i);
		PrintVL($val->[$i],$indent+3,$limit,$structMode);
	    }
	}
    }
    elsif(ref($val) eq 'HASH'){
HASH:
	@keys=sort(keys(%$val));
	for $i (0..$#keys){
	    $key=$keys[$i];
	    $v=$val->{$key};
	    printf( sprintf('%%%ds',$indent), " " );
	    if(!ref($v)){
		printf($class.$key.': = %s(%x)' ."\n",($v eq '')?Nil:$v,($v eq '')?Nil:$v);
	    }
	    else{
		printf($class.$key.': =' ."\n",$key);
		PrintVL($v,$indent+3,$limit,$structMode);
	    }
	}
    }
    elsif(ref($val) eq 'SCALAR'){
	printf( sprintf("%%%ds",$indent), " " );
	printf("%s = \n",$val);
	PrintVL($$val,$indent+3,$limit,$structMode);
    }
    elsif(ref($val) eq 'Math::Pari'){
 	printf( sprintf("%%%ds",$indent), " " );
 	printf( "Pari:: %s\n", Math::Pari::pari2pv($val) );
    }
    elsif($structMode && ref($val) =~ /[^:]+::[^:]+/){
	if($val =~ /=HASH\(0x.+\)/){
	    if($printed{$val}){
		goto ATOM;
	    }
	    else{
#		printf( sprintf("%%%ds",$indent), " " );
#		printf('<' . ref($val) . ">\n");
		$printed{$val}='T';
		$class='<'.ref($val).'>';
		goto HASH;
	    }
	}
	elsif($val =~ /=ARRAY\(0x.+\)/){
	    if($printed{$val}){
		goto ATOM;
	    }
	    else{
#		printf( sprintf("%%%ds",$indent), " " );
#		printf('<' . ref($val) . ">\n");
		$printed{$val}='T';
		goto ARRAY;
	    }
	}
	goto ATOM;
    }
    else{
ATOM:
	printf( sprintf("%%%ds",$indent), " " );
	printf( "%s\n", ($val eq '')?'Nil':$val );
    }
}
sub PrintItem {
    my($val,@stack)=@_;
    @stack=caller(1);
    printf("-----PrintItem(%s)----------\n",$stack[3]);
    printf("   [%s] ref:[%s]",$val,ref($val));
    if(ref($val) eq 'SCALAR'){
	printf("  *ref[%s]",$$val);
    }
    printf("\n");
    return $val;
}
sub PrintVal2 {
    my($val,$indent)=@_;
    my(@stack);
    if( $#_ < 1 ){
	$indent=3;
	@stack=caller(1);
	printf("-----PrintVal(%s)----------\n",$stack[3]);
    }
    my($i,$key,$v);
    if(ref($val) eq 'ARRAY'){
	if($#$val<0){
	    printf( sprintf("%%%ds",$indent), " " );
	    printf("Array element Nothing\n");
	}
	for($i=0;$i<=$#$val;$i++){
	    printf( sprintf("%%%ds",$indent), " " );
	    printf("No[%s] =\n",$i);
	    PrintVal2($val->[$i],$indent+3);
	}
    }
    elsif(ref($val) eq 'HASH'){
	if($val->{'frame_txt'}){
	    printf( sprintf("%%%ds",$indent), " " );
	    printf("Key[frame_txt] =%s\n",$val->{'frame_txt'});
	}
	else{
	    while(($key,$v)=each(%$val)){
		printf( sprintf("%%%ds",$indent), " " );
		printf("Key[%s] =\n",$key);
		PrintVal2($v,$indent+3);
	    }
	}
    }
    elsif(ref($val) eq 'SCALAR'){
	printf( sprintf("%%%ds",$indent), " " );
	printf("SCALAR(%s) =\n",$val);
	PrintVal2($$val,$indent+3);
    }
    else{
	printf( sprintf("%%%ds",$indent), " " );
	printf( "%s\n", ($val eq '')?'Nil':$val );
    }
}
sub BT {
    my($i,@stack);
    while(@stack=caller($i++)){} $i-=2;
    while(-1<$i && (@stack=caller($i--))){
	printf("BT: %s\n",$stack[3]);
    }
}
sub PV {
    my($val,$indent)=@_;
    my(@stack);
    if( $#_ < 1 ){
	$indent=3;
	@stack=caller(1);
	printf("-----PrintVal(%s)----------\n",$stack[3]);
    }
    my($i,$key,$v);
    if(ref($val) eq 'ARRAY'){
	if($#$val<0){
	    printf( sprintf("%%%ds",$indent), " " );
	    printf("Array element Nothing\n");
	}
	for($i=0;$i<=$#$val;$i++){
	    printf( sprintf("%%%ds",$indent), " " );
	    printf("No[%s] =\n",$i);
	    PrintVal($val->[$i],$indent+3);
	}
    }
    elsif(ref($val) eq 'HASH'){
	while(($key,$v)=each(%$val)){
	    printf( sprintf("%%%ds",$indent), " " );
	    printf("Key[%s] =\n",$key);
	    PrintVal($v,$indent+3);
	}
    }
    elsif(ref($val) eq 'SCALAR'){
	printf( sprintf("%%%ds",$indent), " " );
	printf("SCALAR(%s) =\n",$val);
	PrintVal($$val,$indent+3);
    }
    else{
	printf( sprintf("%%%ds",$indent), " " );
	printf( "%s\n", ($val eq '')?'Nil':$val );
    }
    exit;
}

sub PrintFA {
    my($pktinfo)=@_;
    my($tmp);
    %PRINTPkt=();
    if(!$pktinfo){$pktinfo=$SIPPktInfoLast;}
    ($pktinfo,$tmp)=SipParsePart($pktinfo,'ALL');
    # 
    PrintPktCollect($pktinfo);
    # 
    PrintPktTagVal($pktinfo->{'frame_txt'});
}

sub PrintPktTagVal {
    my($sipTxt)=@_;
    my(@keys,$i,$j,$vals);

    printf("--------  PrintFA  -------\n$sipTxt-------------------\n");
    @keys=sort keys(%PRINTPkt);
    for $i (0..$#keys){
	if( $keys[$i] =~ /\.id$/ ){next;}
	printf("[%s]\n",$keys[$i]);
	$vals=$PRINTPkt{$keys[$i]};
	for $j (0..$#$vals){
	    printf("   (%02d) %s\n",$j+1,$vals->[$j]);
	}
    }
}

sub PrintPktCollect {
    my($pktinfo)=@_;
    my($i,$part,$tag);
    
    # 
    $tag=$pktinfo->{'command'}->{'tag'};
    PrintPktCollectVal($pktinfo->{'command'}->{$tag},'RQ.' . $tag);

    # 
    $part=$pktinfo->{'header'};
    for $i (0..$#$part){
	$tag='HD.' . $part->[$i]->{'tag'} . '.val';
	PrintPktCollectVal($part->[$i]->{'val'},$tag);
    }

    # 
    $part=$pktinfo->{'body'};
    for $i (0..$#$part){
	$tag='BD.' . $part->[$i]->{'tag'} . '.val';
	PrintPktCollectVal($part->[$i]->{'val'},$tag);
    }
}

sub PrintPktCollectVal {
    my($pktinfo,$tag)=@_;
    my(@keys,$i,$name);
    
    if(ref($pktinfo) eq 'ARRAY'){
	for $i (0..$#$pktinfo){
	    PrintPktCollectVal($pktinfo->[$i],$tag);
	}
    }
    else{
	@keys=keys(%$pktinfo);
	for $i (0..$#keys){
	    if($tag){
		$name=$tag . '.' . $keys[$i];
	    }
	    else{
		$name=$keys[$i];
	    }
	    if( !ref($pktinfo->{$keys[$i]}) ){
		push(@{$PRINTPkt{$name}},$pktinfo->{$keys[$i]});
	    }
	    else{
		PrintPktCollectVal($pktinfo->{$keys[$i]},$name);
	    }
	}
    }
}

sub PrintPkt {
    my($pktinfo,$level,$cmnt)=@_;
    my($i);
    if(ref($pktinfo) eq 'ARRAY'){
	for $i (0..$#$pktinfo){
	    PrintPkt($pktinfo->[$i],$level,'No.' . $i);
	}
    }
    else{
	if(!$level){
	    printf("%s ND[%s] %s(%s) %s Pkt[%s]\n",
		   $cmnt,$pktinfo->{'Node'},$pktinfo->{'dir'},$pktinfo->{'timestamp'},
		   $SIP_PL_IP eq 6 ?
		   $pktinfo->{'pkt'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'}:
		   $pktinfo->{'pkt'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.DestinationAddress'},
		   $pktinfo->{'command_txt'});
	    
	}
    }
}

# 
sub HexString {
    my($val)=@_;
    my($i,$c);
    printf("----------------------------------\n");
    printf("$val\n");
    printf("----------------------------------");
    for($i=0;$i<length($val);$i++){
	$c=substr($val,$i,1);
	if(!($i % 16)){printf(" ");}
	if(!($i % 32)){printf("\n");}
	printf("%02x:",ord($c));
    }
    printf("\n");
}

sub IPAddressType {
    my($msg)=@_;
    my($hex4);
    $hex4='[0-9a-fA-F]{1,4}(?::[0-9a-fA-F]{1,4})*';
    if($msg =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/){return 'ip4';}
    if($msg =~ /^(?:$hex4(?:::)(?:$hex4)?|::(?:$hex4)?|$hex4)$/){return 'ip6';}
    if($msg =~ /^\[(?:$hex4(?:::)(?:$hex4)?|::(?:$hex4)?|$hex4)\]$/){return 'ip6';}
    return '';
}

# 192.168.0.1
sub IsIPV4Address {
    my($msg)=@_;
    if($msg =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/){return 'OK';}
    return ;
}

# MAC
sub GenerateIPv6FromMac {
    my ($mac,$prefix) = @_;
    my (@hex,@oct,$first,$colon);
    $colon=$prefix; $colon =~ s/[^:]//g;
    if(4<length($colon)){$prefix=substr($prefix,0,length($prefix)-1);}
    @hex=split(/:/,$mac);
    @oct=map(hex,@hex);
    $first=shift @oct; $first=($first & 0x02) ? ($first & 0xfd):($first | 2);
    return sprintf("%s%02x%02x:%02xff:fe%02x:%02x%02x", $prefix,$first,shift @oct,shift @oct,@oct);
#   return sprintf("%s%02x%02x:%02xff:fe%02x:%02x%02x", $prefix,(shift @oct)|0x02,shift @oct,shift @oct,@oct);
}

# IPv6
sub IPv6StrToVal {
    my($strAddr)=@_;
    my(@addrs,@addrVal,$i,$left,$right,$index);
    $index=0;
    for($i=0;$i<8;$i++){ $addrVal[$i]=0; }

    # ::
    @addrs=split(/::/,$strAddr);

    $left=$addrs[0];
    $right=$addrs[1];

    # 
    if($left){
	@addrs=split(/:/,$left);
	for($i=0;$i<=$#addrs;$i++){
	    $addrVal[$index]=hex(lc($addrs[$i]));
	    $index++;
#	    PrintItem("$addrs[$i] = " . hex($addrs[$i]));
	}
    }

    # 
    if($right){
	@addrs=split(/:/,$right);
	$index=7;
	for($i=$#addrs;0<=$i;$i--){
	    $addrVal[$index]=hex(lc($addrs[$i]));
	    $index--;
	}
    }
#    for($i=0;$i<8;$i++){PrintItem("$i = $addrVal[$i]");}

    return @addrVal;
}

# 
sub IPv6WithMaskStrToVal {
    my($strAddr,$omit)=@_;
    my($addr,$masklen,$idx,$mask,@valAddr,@valMask,$i);
    if( $strAddr =~ /(.+)\/([0-9]*)$/ ){
	$addr=$1;
	$masklen=$2;
	if(128<$masklen){$masklen=128;}
	$idx=8;
	while(0<$masklen-16){
	    $mask .= ':ffff';
	    $idx--;
	    $masklen-=16;
	}
	if(0<$masklen){
	    $mask .= ':' . sprintf("%04x",(((2 ** $masklen)-1) << (16-$masklen)));
	    $idx--;
	}
	while(0<$idx){
	    $mask .= ':0';
	    $idx--;
	}
	$mask = substr($mask,1);
	@valAddr=IPv6StrToVal($addr);
	@valMask=IPv6StrToVal($mask);
	for $i (0..7){$valAddr[$i]=$valAddr[$i] & $valMask[$i];}
	$addr=IPv6ValToStr(\@valAddr);
	if($omit){$mask=IPv6ValToStr(\@valMask);}
    }
    else{
	$addr=$strAddr;
	$mask='';
    }
    return $addr,$mask;
}
sub IPv6StrToHex {
    my($strAddr)=@_;
    my($i,@val,$hex);
    if(ref($strAddr) || !$strAddr){return;}
    @val=IPv6StrToVal($strAddr);
    for $i (0..7){
	$hex .= sprintf("%04x",$val[$i]);
    }
    return $hex;
}
sub IPv6ValToStr {
    my($valAddr)=@_;
    my($i,$hex,$last);
    for($i=7;0<=$i;$i--){
	if($valAddr->[$i]){last;}
    }
    $last=$i;
    for $i (0..$last){
	$hex .= sprintf("%x%s",$valAddr->[$i],($i eq $last)?'':':');
    }
    if($last ne 7){$hex .= '::';}
    return $hex;
}
sub IPv6StrToFullStr {
    my($strAddr)=@_;
    my($i,@val,$hex);
    if(ref($strAddr) || !$strAddr){return;}
    @val=IPv6StrToVal($strAddr);
    for $i (0..6){
	$hex .= sprintf("%04x:",$val[$i]);
    }
    $hex .= sprintf("%04x",$val[7]);
    return $hex;
}
sub IPv6EQ {
    my($addr1,$addr2)=@_;
    my($i,@val1,@val2);
    @val1=IPv6StrToVal($addr1);
    @val2=IPv6StrToVal($addr2);
    for $i (0..7){
	if($val1[$i] ne $val2[$i]){return;}
    }
    return 'OK';
}
sub IPv4EQ {
    my($addr1,$addr2)=@_;
    $addr1=IPv4StrToHex($addr1);$addr2=IPv4StrToHex($addr2);
    return $addr1 && $addr1 eq $addr2;
}
sub IPv4StrToHex {
    my($strAddr)=@_;
    my(@val,$i,$hex);
    @val=split(/\./,$strAddr);
#    PrintVal(\@val);
    for $i (0..3){
	$hex .= sprintf("%02x",$val[$i]);
    }
    return $hex;
}
sub IPv4StrToVal {
    my($strAddr)=@_;
    my(@val,$i,$hex);
    @val=split(/\./,$strAddr);
    for $i (0..3){
	$hex = $hex * 256 + $val[$i];
    }
    return $hex;
}
sub IPv4AddAddeess {
    my($strAddr,$add)=@_;
    my(@val);
    @val=split(/\./,$strAddr);
    $val[3] = ($val[3] + $add) % 255;
    return $val[0] . '.' . $val[1] . '.' . $val[2] . '.' . $val[3];
}
# 255.255.255.0 => 24
sub IPv4MaskStrToVal {
    my($v4addr)=@_;
    my(@ipaddr,$count,$val,$i);
    @ipaddr = split(/\./, $v4addr);
    foreach $val (@ipaddr){
	for $i (0..7){
	    if($val){$count++;}
	    else{goto EXIT;};
	    $val=($val << 1) & 0xFF;
	}
    }
EXIT:
    return $count;
}
# 192.168.0.1/24 => [192.168.0.1, 255.255.255.0]
sub IPv4WithMaskStrToVal {
    my($strAddr,$omit)=@_;
    $strAddr =~ //;
    if( $strAddr =~ /(.+)\/([0-9]*)$/ ){
	return IPv4MaskToAddress($1,$2);
    }
    else{
	return $strAddr,'';
    }
}
# 
sub IPv4MaskToAddress {
    my($v4addr,$mask,$fil)=@_;
    my(@maskaddr,@ipaddr,$i);
    
    @ipaddr = split(/\./, $v4addr);
    for $i (0..3){
	if( 8 <= $mask ){
	    $maskaddr[$i]=0xFF;
	    $mask-=8;
	    $ipaddr[$i] = $maskaddr[$i] & $ipaddr[$i];
	}
	else{
	    $maskaddr[$i]=0x100 - (2 ** (8-$mask));
	    if($fil){
		$ipaddr[$i] = ($maskaddr[$i] & $ipaddr[$i]) + (2**(8-$mask)-1);
	    }
	    else{
		$ipaddr[$i] = $maskaddr[$i] & $ipaddr[$i];
	    }
	    $mask=0;
	}
    }
#    printf("mask[%d] [%x.%x.%x.%x]\n",$mask,$maskaddr[0],$maskaddr[1],$maskaddr[2],$maskaddr[3]);
    return "$ipaddr[0].$ipaddr[1].$ipaddr[2].$ipaddr[3]",
           "$maskaddr[0].$maskaddr[1].$maskaddr[2].$maskaddr[3]";
}

# IP
#  0                     0         0
#  10.0.0.0      255.0.0.0         8.10
#  10.0.0.0      255.255.255.0     24.10.0.0
#  10.17.0.0     255.255.0.0       16.10.17
#  10.27.129.0   255.255.255.0     24.10.27.129
#  10.229.0.128  255.255.255.128   25.10.229.0.128
#  10.198.122.47 255.255.255.255   32.10.129.122.47
sub IPv4andMaskDescriptor {
    my($addr,$mask)=@_;
    my($masklen,$part,@addr,$desc);
    @addr=split(/\./,$addr);
    $masklen=IPv4MaskStrToVal($mask) || '0';
    $part=($masklen+7)/8;
    $desc=$masklen;
    foreach $no (1..$part){
	$desc .= '.' . $addr[$no-1];
    }
    return $desc;
}
sub IPv4andMaskDescriptorToHex {
    my($desc)=@_;
    my($val,@vals);
    @vals=split(/\./,$desc);
    map{$val.=sprintf('%02x',$_)}(@vals);
    return $val;
}

# 48 -> ffff:ffff:ffff:0000:0000:0000:0000:0000
sub IPv6BitMaskToAddress {
    my($maskbit,$omit)=@_;
    my($maskAddr,$i,$sub);
#    if(!$maskbit && $omit){return '0::';}
    if(!$maskbit && $omit){return '::';}
    for $i (0..7){
	if(16 <= $maskbit){$sub=0xffff;}
	elsif(0<$maskbit){$sub=(2**$maskbit-1)<<(16-$maskbit);}
	else{$sub=0;}
	if(!$sub && $omit){
	    return $maskAddr . '::';
	}
	$maskAddr .= sprintf("%s%04x",$maskAddr?':':'',$sub);
	$maskbit-=16;
    }
    return $maskAddr;
}

# '01:02:03:04:05:06',3 => '010203040506000000'
sub MacStrToHex {
    my($strAddr,$len)=@_;
    my(@tmp,$i,$val);
    @tmp=split(/:/,$strAddr);
    for $i(0..5){$val .=$tmp[$i];}
    if($len){$len*=2;$val.=sprintf(sprintf("%%0%d.%ds",$len,$len),0)}
    return $val;
}

sub IsIPAddress {
    my($msg)=@_;
    return ($msg =~ /^$PtIPv6address$/ || $msg =~ /^$PtIPv6reference$/ || $msg =~ /^$PtIPv4address$/) ;
}

sub ArrayToStr {
    my($val)=@_;
    my($msg,$i);
    if(ref($val) eq 'ARRAY'){
	for($i=0;$i<=$#$val;$i++){
	    $msg=sprintf($msg?"%s,%s":"%s%s",$msg, $val->[$i]);
	}
    }
    return $msg;
}

###########################################
1


