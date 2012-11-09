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

# use strict;

# 
# 09/6/ 3  CtSvSDPCreate bandwidth
# 09/2/ 9  CtRlSyntaxResult

###############################################################################
#
# SIP Service Function
#
###############################################################################

#=============================================================================
# SIP
#=============================================================================

#-----------------------------------------------------------------------------
# SIP
#   
#     $field: 
#     $msg: SIP
#   
#     
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtFlv {
    my ($field, $msg) = @_;
    return CtFlGet('INET,#SIP,' . $field, $msg);
}


#-----------------------------------------------------------------------------
# SIP
#   
#     $field: 
#     $msg: SIP
#     $mode:
#        Set
#        SET
#             
#             
#        EncSet
#                
#                
#                
#                
#        Add
#        Append
#        Del
#        Ins
#             
#                         $P
#                         $I
#                         $FV
#                         $NV
#     $val: 
#   
#     
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtFlfs {
    my ($field, $msg, $mode, $val) = @_;
    return CtFlSet('INET,#SIP,' . $field, $msg, $mode, $val);
}


#-----------------------------------------------------------------------------
# SIP
#   
#     $field: 
#     $msg: SIP
#   
#     
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtFlfd {
    my ($field, $msg) = @_;
    return CtFlDel('INET,#SIP,' . $field, $msg);
}


#-----------------------------------------------------------------------------
# SIP
#   
#     $field: SL / HD / BD
#     $msg: SIP
#   
#     
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtFlp {
    my ($field, $msg) = @_;
    my ($sipMsg, $ret);

    $sipMsg = CtFlGet('INET,#SIP,#TXT#', $msg);
    $sipMsg =~ /^((?:.+))$PtCRLF((?:.+$PtCRLF)+)$PtCRLF((?:.+$PtCRLF?)*)/;
    if ($field eq 'SL') {
        $ret = $1;
    }
    elsif ($field eq 'HD') {
        $ret = $2;
    }
    elsif ($field eq 'BD') {
        $ret = $3;
    }

    return $ret;
}


#-----------------------------------------------------------------------------
# 
#   
#     
#   
#     
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtUtLastSndMsg {
    my ($node);
    $node = $DIRRoot{'ACTND'};
    return $node->{'LASTSDPKT'};
}


#-----------------------------------------------------------------------------
# 
#   
#     
#   
#     
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtUtLastRcvMsg {
    my ($node);
    $node = $DIRRoot{'ACTND'};
    return $node->{'LASTRVPKT'};
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# Basic
#   
#     $usr
#     $realm
#     $pw
#     $method
#     $uri
#     $nonce
#   
#     
#   
#     RFC2069
#-----------------------------------------------------------------------------
sub CtUtCalcAuthBasicMD5 {
    my ($usr, $realm, $pw, $method, $uri, $nonce) = @_;
    my ($ret, $a1, $a2);

    # A1
    $a1 = md5_hex("${usr}:${realm}:${pw}");

    # A2
    $a2 = md5_hex("${method}:${uri}");

    # 
    $ret = md5_hex("${a1}:${nonce}:${a2}");

    return $ret;
}


#-----------------------------------------------------------------------------
# 
#   
#     $usr
#     $realm
#     $pw
#     $method
#     $uri
#     $nonce
#     $nc
#     $cnonce
#     $qop
#   
#     
#   
#     RFC2617
#-----------------------------------------------------------------------------
sub CtUtAuthDigestMD5 {
    my ($usr, $realm, $pw, $method, $uri, $nonce, $nc, $cnonce, $qop) = @_;
    my ($ret, $a1, $a2);

    # A1
    $a1 = md5_hex("${usr}:${realm}:${pw}");

    # A2
    $a2 = md5_hex("${method}:${uri}");

    # 
    $ret = md5_hex("${a1}:${nonce}:${nc}:${cnonce}:${qop}:${a2}");

    return $ret;
}


#-----------------------------------------------------------------------------
# 
#   
#     $usr
#     $realm
#     $pw
#     $method
#     $uri
#     $body
#     $nonce
#     $nc
#     $cnonce
#     $qop
#   
#     
#   
#     RFC2617
#-----------------------------------------------------------------------------
sub CtUtAuthIntDigestMD5 {
    my ($usr, $realm, $pw, $method, $uri, $body, $nonce, $nc, $cnonce, $qop) = @_;
    my ($ret, $a1, $a2);

    # A1
    $a1 = md5_hex("${usr}:${realm}:${pw}");

    # A2
    $a2 = md5_hex("${method}:${uri}:${body}");

    # 
    $ret = md5_hex("${a1}:${nonce}:${nc}:${cnonce}:${qop}:${a2}");

    return $ret;
}


#=============================================================================
# SIP
#=============================================================================

#-----------------------------------------------------------------------------
# 16
#   
#     $len
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtFlRandHexStr {
    my ($len) = @_;
    my ($str, $num);

    for (1..$len) {
        $str .= sprintf("%x", rand(16));
    }

    return $str;
}


#-----------------------------------------------------------------------------
# 
#   
#     $node
#   
#     
#   
#     
#     
#-----------------------------------------------------------------------------
sub CtFlRouteInf {
    my ($node) = @_;
    my ($routeInf);

    $routeInf = {
                    'address' => CtTbUsr($node->{'ID'}, 'address'),
                    'sip-port' => CtTbUsr($node->{'ID'}, 'sip-port'),
                    'URI' => CtTbl('UC,URI', $node),
                };

    return $routeInf;
}


#-----------------------------------------------------------------------------
# Via
#   
#     $start
#     $end
#   
#     Via(
#   
#     
#-----------------------------------------------------------------------------
sub CtFlVia {
    my ($start, $end) = @_;
    my ($routeInf, $num, $idx);
    my ($trans, $host, $port, $branch, $received);
    my (@via);

    if ($start eq '' || $end eq '') {
        CtSvError('fatal', "node name nothing: start[$start] end[$end]");
        return '';
    }

    # 
    $trans = CtTbPrm('CI,transport');

    # 
    if ($start eq $end) {
        $host = CtTbl('UC,URI,FQDN', $start);
        $port = CtTbUsr($start, 'sip-port');
        if ($port ne '') {
            $port = ':' . $port;
        }
        $branch = CtFlRandHexStr(4);
        push(@via, "SIP/2.0/${trans} ${host}${port};branch=z9hG4bK${branch}");
        return \@via;
    }

    # 
    $routeInf = CtNDTraceNode($start, $end, \&CtFlRouteInf);
    if ($#$routeInf < 0) {
        CtSvError('fatal', "route info nothing");
        return '';
    }

    # 
    $idx = $#$routeInf;
    $host = $$routeInf[$idx]->{'URI'}->{'FQDN'};
    $port = $$routeInf[$idx]->{'sip-port'};
    if ($port ne '') {
        $port = ':' . $port;
    }
    $branch = CtFlRandHexStr(4);
    push(@via, "SIP/2.0/${trans} ${host}${port};branch=z9hG4bK${branch}");

    # 
    $num = $#$routeInf - 1;
    for ($idx = $num; $idx >= 0; --$idx) {
        $host = $$routeInf[$idx]->{'URI'}->{'FQDN'};
        $port = $$routeInf[$idx]->{'sip-port'};
        if ($port ne '') {
            $port = ':' . $port;
        }
        $branch = CtFlRandHexStr(4);
        $received = $$routeInf[$idx]->{'address'};
        push(@via, "SIP/2.0/${trans} ${host}${port};branch=z9hG4bK${branch};received=${received}");
    }

    return \@via;
}


#-----------------------------------------------------------------------------
# Route
#   
#     $start
#     $end
#     $param
#   
#     Route(
#   
#     
#-----------------------------------------------------------------------------
sub CtFlRoute {
    my ($start, $end, $param) = @_;
    my ($routeInf, $idx);
    my ($host, $uriParam);
    my (@route);
    # maddr
    my ($addr);

    if ($start eq '' || $end eq '') {
        CtSvError('fatal', "node name nothing: start[$start] end[$end]");
        return '';
    }

    # URI
    if ($param eq '') {
        $uriParam = '';
    }
    else {
        $uriParam = ';' . $param;
    }

    # 
    if ($start eq $end) {
        $host = CtTbl('UC,URI,ContactURI', $start);
        if ($host eq '') {
            $host = CtTbl('UC,URI,RequestURI', $start);
        }
        # maddr
        if(';maddr' eq $uriParam) {
            $addr = CtTbUsr($start, 'address');
            push(@route, "<${host}${uriParam}=${addr}>");
        }
        # 
        else {
            push(@route, "<${host}${uriParam}>");
        }
        return \@route;
    }

    # 
    $routeInf = CtNDTraceNode($start, $end, \&CtFlRouteInf);
    if ($#$routeInf < 0) {
        CtSvError('fatal', "route info nothing");
        return '';
    }

    for $idx (0..$#$routeInf) {
        $host = $$routeInf[$idx]->{'URI'}->{'ContactURI'};
        if ($host eq '') {
            $host = $$routeInf[$idx]->{'URI'}->{'RequestURI'};
        }
        # $uriParam
        if(';maddr' eq $uriParam) {
            $addr = $$routeInf[$idx]->{'address'};
            push(@route, "<${host}${uriParam}=${addr}>");
        }
        # lr
        else {
            push(@route, "<${host}${uriParam}>");
        }
    }

    return \@route;
}


#-----------------------------------------------------------------------------
# Record-Route
#   
#     $start
#     $end
#     $param
#   
#     Recode-Route(
#   
#     
#-----------------------------------------------------------------------------
sub CtFlRecordRoute {
    my ($start, $end, $param) = @_;
    my ($routeInf, $idx);
    my ($host, $uriParam);
    my (@recordRoute);

    if ($start eq '' || $end eq '') {
        CtSvError('fatal', "node name nothing: start[$start] end[$end]");
        return '';
    }

    # URI
    if ($param eq '') {
        $uriParam = '';
    }
    else {
        $uriParam = ';' . $param;
    }

    # 
    if ($start eq $end) {
        $host = CtTbl('UC,URI,ContactURI', $start);
        if ($host eq '') {
            $host = CtTbl('UC,URI,RequestURI', $start);
        }
        push(@recordRoute, "<${host}${uriParam}>");
        return \@recordRoute;
    }

    # 
    $routeInf = CtNDTraceNode($start, $end, \&CtFlRouteInf);
    if ($#$routeInf < 0) {
        CtSvError('fatal', "route info nothing");
        return '';
    }

    # 
    for ($idx = $#$routeInf; $idx >= 0; --$idx) {
        $host = $$routeInf[$idx]->{'URI'}->{'ContactURI'};
        if ($host eq '') {
            $host = $$routeInf[$idx]->{'URI'}->{'RequestURI'};
        }
        push(@recordRoute, "<${host}${uriParam}>");
    }

    return \@recordRoute;
}


#-----------------------------------------------------------------------------
# Call-ID
#   
#     $dialogid
#   
#     Call-ID
#   
#     
#-----------------------------------------------------------------------------
sub CtFlCallID {
    my ($dialogid) = @_;
    my ($usr, $host);
    my ($callid);

    # 
    $usr = CtFlRandHexStr(8);

    # 
    $host = CtSvDlg($dialogid, 'LocalURI,Contact');
    if ($host =~ /\@/) {
        $host =~ s/^[^@]*//;
        # 
        if ($host =~ /^(\@\[[:0-9a-fA-F]+\])/) {
            $host = $1;
        }
        else {
            $host =~ s/[>:;].*$//;
        }
        $callid = $usr . $host;
    }
    else {
        $host =~ s/^.+://;
        $callid = $usr . '@' . $host;
    }

    return $callid;
}


#-----------------------------------------------------------------------------
# URI
#   
#     $uri
#     $scheme
#   
#     scheme
#   
#     
#-----------------------------------------------------------------------------
sub CtFlUriMchScheme {
    my ($uri, $scheme) = @_;
    my (@ret, $curUri, $curScheme);

    if ($uri eq '' || $scheme eq '') {
        MsgPrint('WAR', "parameter error: uri[%s] scheme[%s]\n", $uri, $scheme);
        return '';
    }

    if (ref($uri) ne 'ARRAY') {
        $uri = [$uri];
    }
    if (ref($scheme) ne 'ARRAY') {
        $scheme = [$scheme];
    }

    foreach $curUri (@$uri) {
        foreach $curScheme (@$scheme) {
            if ($curUri =~ /^$curScheme:/) {
                push(@ret, $curUri);
            }
        }
    }

    if ($#ret < 0) {
        return '';
    }

    return \@ret;
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# SIP URI
#   
#     $uriA
#     $uriB
#   
#     
#       0
#       0
#   
#     (sip|sips):userinfo@hostport;param
#     
#       
#     
#-----------------------------------------------------------------------------
sub CtFlCmpSipURI {
    my ($uriA, $uriB) = @_;
    my ($uri1, $uri2, $port1, $port2);

    if ($uriA eq '' || $uriB eq '') {
        MsgPrint('WAR', "uri nothing: A[%s] B[%s]\n", $uriA, $uriB);
        return 0;
    }

    # 
    if ($uriA =~ /^sip:/) {
        ($uri1) = CtPkDecode('SIP:SIPUri', $uriA);
        $port1 = 5060;
    }
    elsif ($uriA =~ /^sips:/) {
        ($uri1) = CtPkDecode('SIP:SIPSUri', $uriA);
        $port1 = 5061;
    }
    else {
        MsgPrint('WAR', "uri is not sip or sips:[%s]\n", $uriA);
        return 0;
    }

    if ($uriB =~ /^sip:/) {
        ($uri2) = CtPkDecode('SIP:SIPUri', $uriB);
        $port2 = 5060;
    }
    elsif ($uriB =~ /^sips:/) {
        ($uri2) = CtPkDecode('SIP:SIPSUri', $uriB);
        $port2 = 5061;
    }
    else {
        MsgPrint('WAR', "uri is not sip or sips:[%s]\n", $uriB);
        return 0;
    }

    # scheme
    if ($uri1->{'scheme'} ne $uri2->{'scheme'}) {
        return 0;
    }

    # userinfo
    if ($uri1->{'userinfo'} ne $uri2->{'userinfo'}) {
        return 0;
    }

    # host
    if ($uri1->{'host'} ne $uri2->{'host'}) {
        return 0;
    }

    # port
    if ($uri1->{'port'} ne '') {
        $port1 = $uri1->{'port'};
    }
    if ($uri2->{'port'} ne '') {
        $port2 = $uri2->{'port'};
    }
    if ($port1 ne $port2) {
        return 0;
    }

    return 1;
}


#-----------------------------------------------------------------------------
# 
#   
#     $msgA
#     $msgB
#     $ignHdrLst: 
#   
#     
#       0
#       0
#   
#     
#-----------------------------------------------------------------------------
sub CtUtCmpHdrOrder {
    my ($msgA, $msgB, $ignHdrLst) = @_;
    my ($hdrLstA, $hdrLstB, $idxA, $idxB, $lstNumA, $lstNumB);

    if ($msgA eq '' || $msgB eq '') {
        MsgPrint('WAR', "msg nothing: A[%s] B[%s]\n", $msgA, $msgB);
        return 0;
    }

    $hdrLstA = CtFlv('HD,#Name#', $msgA);
    $hdrLstB = CtFlv('HD,#Name#', $msgB);

    for ($idxA = 0, $idxB = 0, $lstNumA = $#$hdrLstA, $lstNumB = $#$hdrLstB;
         $idxA <= $lstNumA && $idxB <= $lstNumB; ) {
        if ($hdrLstA->[$idxA] ne $hdrLstB->[$idxB]) {
            if ( grep {$_ eq $hdrLstA->[$idxA]} (@$ignHdrLst) ) {
                ++$idxA;
                next;
            }
            elsif ( grep {$_ eq $hdrLstB->[$idxB]} (@$ignHdrLst) ) {
                ++$idxB;
                next;
            }
            else {
                return 0;
            }
        }
        ++$idxA;
        ++$idxB;
    }

    for (; $idxA <= $lstNumA; ++$idxA) {
        if ( !grep {$_ eq $hdrLstA->[$idxA]} (@$ignHdrLst) ) {
            return 0;
        }
    }
    for (; $idxB <= $lstNumB; ++$idxB) {
        if ( !grep {$_ eq $hdrLstB->[$idxB]} (@$ignHdrLst) ) {
            return 0;
        }
    }

    return 1;
}



# @@ -- SipRule.pm --

# use strict;

###############################################################################
#
# SIP Rule Control
#
###############################################################################

## DEF.VAR
#=============================================================================
# ENCODE
#=============================================================================

%SipEncodeSortHdr =
(
    # RFC3261-7-7
    'Via'                   => 101,
    'v'                     => 101,
    'Route'                 => 102,
    'Record-Route'          => 103,
    'Proxy-Require'         => 104,
    'Max-Forwards'          => 105,
    'Session-Expires'       => 106,
    'x'                     => 106,
    'Min-SE'                => 107,
    'Proxy-Authorization'   => 108,

    # Proxy-Authorization
    'Proxy-Authenticate'    => 201,
    'Authorization'         => 202,
    'WWW-Authenticate'      => 203,

    # 
    'From'                  => 301,
    'f'                     => 301,
    'To'                    => 302,
    't'                     => 302,
    'Call-ID'               => 303,
    'i'                     => 303,
    'CSeq'                  => 304,

    # CSeq
    'RSeq'                  => 401,
    'RAck'                  => 402,

    # 
    'Contact'               => 501,
    'm'                     => 501,
    'Require'               => 502,
    'Supported'             => 503,
    'k'                     => 503,
    'Unsupported'           => 504,
    'Allow'                 => 505,

    # 

    # 
    'Content-Type'          => 2001,
    'c'                     => 2001,
    'Content-Language'      => 2002,
    'Content-Encoding'      => 2003,
    'e'                     => 2003,
    'Content-Disposition'   => 2004,
    'Content-Length'        => 2005,
    'l'                     => 2005,
);
## DEF.END


#=============================================================================
# SIP
#=============================================================================

#-----------------------------------------------------------------------------
# SIP
#   
#     $rule
#     $addrule
#     $delrule
#     $dialogid
#     $msg
#     $param
#   
#     
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtRlJudgeSyntax {
    my ($rule, $addrule, $delrule, $dialogid, $msg, $param) = @_;
    my ($ruleResult, $recRuleResult, %context);

    if ($rule eq '') {
        CtSvError('fatal', "rule nothing");
        return '', '';
    }

    if ($msg eq '') {
        # 
        # 
        $msg = CtUtLastRcvMsg();
        if ($msg eq '') {
            CtSvError('fatal', "not receive message");
            return '', '';
        }
    }

    # 
    $context{'usr_dlg'} = $dialogid;
    $context{'usr_pkt'} = $msg;
    $context{'usr_param'} = $param;

    ($ruleResult, $recRuleResult) =
        CtRlJudge($rule, $msg, \%context, $addrule, $delrule, '');

    if(CtLgLevel('FLOW')){FlowPrint('RR',"Syntax judgement [%s]",$rule);}

    return $ruleResult, $recRuleResult;
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $param,...
#   
#     SIP
#   
#     PROGN
#     
#     
#       
#       => 
#     
#       => 
#-----------------------------------------------------------------------------
sub CtRlMargeEncode {
    my ($hexSt, $context) = @_;
    my ($ruleResultList, $curResult, $curRule);
    my ($part, $pos, $idx, $authIntParam, $authIntResponse);
    my ($msg, @startLineList, @headerList, @bodyList, $msgBody);

    # 
    $ruleResultList = $context->{'RULE-RESULT'};

    # 
    foreach $curResult (@$ruleResultList) {
        # 
        $part = $curResult->{'MSG'};
        # 
        if ($part eq '') { next; }

        # 
        $curRule = CtRlFindFromID($curResult->{'ID'});
        # ENCODE
        if ($curRule->{'TY'} ne 'ENCODE') { next; }

        # 
        $pos = $curRule->{'PT'};
        # 
        if ($pos eq 'SL') {
            # Start-Line
            push(@startLineList, $part);
        }
        elsif ($pos eq 'HD') {
            # Header
            push(@headerList, $part);
        }
        elsif ($pos eq 'BD') {
            # Body
            push(@bodyList, $part);
        }
        else {
            # 
            MsgPrint('WAR',
                     "unknown part position: rule ID[%s] PT[%s]\n",
                     $curResult->{'ID'}, $pos);
        }
    }

    # 
    if ($context->{'usr_param'}->{'sortHdrFlg'} ne 'off') {
        @headerList = sort CtRlSortHdrPos @headerList;
    }

    # auth-int
    if ($#bodyList >= 0) {
        $msgBody = join("\r\n", @bodyList) . "\r\n";
    }

    # auth-int
    $authIntParam =  $context->{'usr_param'}->{'auth-int'};
    if ($authIntParam ne '') {
        # 
        $authIntResponse = CtUtAuthIntDigestMD5(
                                $authIntParam->{'usr'},
                                $authIntParam->{'realm'},
                                $authIntParam->{'pw'},
                                $authIntParam->{'method'},
                                $authIntParam->{'uri'},
                                $msgBody,
                                $authIntParam->{'nonce'},
                                $authIntParam->{'nc'},
                                $authIntParam->{'cnonce'},
                                $authIntParam->{'qop'});
        # ________________________________
        for ($idx = 0; $idx <= $#headerList; ++$idx) {
            if ($headerList[$idx] =~ /________________________________/) {
                $headerList[$idx] =~ s/________________________________/$authIntResponse/;
                last;
            }
        }
    }

    # 
    if ($#startLineList >= 0) {
        $msg = join(' ', @startLineList) . "\r\n";
    }
    if ($#headerList >= 0) {
        $msg .= join("\r\n", @headerList) . "\r\n\r\n";
    }
    $msg .= $msgBody;

    return $msg;
}


#-----------------------------------------------------------------------------
# 
#   
#     
#   
#     
#   
#     ENCODE
#-----------------------------------------------------------------------------
sub CtRlSortHdrPos {
    my ($aNum, $bNum, $tag);

    $a =~ /^([^ :]*)/;
    $tag = $1;
    $aNum = $SipEncodeSortHdr{$tag};
    $aNum = $aNum ? $aNum : 1000;

    $b =~ /^([^ :]*)/;
    $tag = $1;
    $bNum = $SipEncodeSortHdr{$tag};
    $bNum = $bNum ? $bNum : 1000;

    if ($aNum == $bNum) {
        return 0;
    }
    elsif ($aNum > $bNum) {
        return 1;
    }

    return -1;
}


#-----------------------------------------------------------------------------
# auth-int
#   
#     $usr
#     $realm
#     $pw
#     $method
#     $uri
#     $nonce
#     $nc
#     $cnonce
#     $qop
#     $param,...
#   
#     
#   
#     RFC2617
#     
#     
#     
#-----------------------------------------------------------------------------
sub CtUtSetAuthParam {
    my ($usr, $realm, $pw, $method, $uri, $nonce, $nc, $cnonce, $qop, $msg, $context) = @_;

    $context->{'usr_param'}->{'auth-int'} =
        {
            'usr' => $usr,
            'realm' => $realm,
            'pw' => $pw,
            'method' => $method,
            'uri' => $uri,
            'nonce' => $nonce,
            'nc' => $nc,
            'cnonce' => $cnonce,
            'qop' => $qop,
        };

    return '________________________________';
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $param,...
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtRlCxDlg {
    my ($param, $context) = @_;

    return $context->{'usr_dlg'};
}


#-----------------------------------------------------------------------------
# 
#   
#     $param,...
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtRlCxUsr {
    my ($param, $context) = @_;

    return defined($context->{'usr_param'}) ? $context->{'usr_param'} : {};
}


#-----------------------------------------------------------------------------
# 
#   
#     $param,...
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtRlCxPkt {
    my ($param, $context) = @_;

    return $context->{'usr_pkt'};
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# Content-Length
#   
#     $param,...
#   
#     Content-Length
#   
#     ENCODE
#     
#-----------------------------------------------------------------------------
sub CtUtCalcContentLeng {
    my ($hexSt, $context) = @_;
    my ($len);
    my ($ruleResultList, $curResult, $curRule);
    my ($part, $pos);

    # Content-Length
    $len = 0;

    # 
    $ruleResultList = $context->{'RULE-RESULT'};

    # 
    foreach $curResult (@$ruleResultList) {
        # 
        $part = $curResult->{'MSG'};
        # 
        if ($part eq '') { next; }

        # 
        $curRule = CtRlFindFromID($curResult->{'ID'});
        # ENCODE
        if ($curRule->{'TY'} ne 'ENCODE') { next; }

        # 
        $pos = $curRule->{'PT'};
        # 
        if ($pos eq 'BD') {
#            $len += length($part) + length("\r\n");
            $len += length($part) + 2;
        }
    }

    return $len;
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $tag
#     $param,...
#   
#     
#       0
#       0
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtUtIsExistHdr {
    my ($tag, $msg, $context) = @_;
    my ($ret, @ngList, $cur, $hdr);

    if ($tag eq '') {
        MsgPrint('WAR', "tag nothing\n");
        return 0;
    }
    if ($msg eq '') {
        MsgPrint('WAR', "msg nothing\n");
        return 0;
    }

    # 
    $ret = 1;

    if (ref($tag) eq 'ARRAY') {
        foreach $cur (@$tag) {
            $hdr = CtFlv("HD,#$cur", $msg);
            if ($hdr eq '') {
                push(@ngList, $cur);
                $ret = 0;
            }
        }
    }
    else {
        $hdr = CtFlv("HD,#$tag", $msg);
        if ($hdr eq '') {
            push(@ngList, $tag);
            $ret = 0;
        }
    }

    # HTML
    CtRlSetEvalResult($context, '2op', 'EQ', $ret, $tag, \@ngList);

    return $ret;
}


#-----------------------------------------------------------------------------
# SIPS URI
#   
#     $tag
#     $param,...
#   
#     
#       0
#       0
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtUtIsExistHdrUri {
    my ($tag, $msg, $context) = @_;
    my ($ret, @ngList, $cur, $uri, $flg, $curUri);

    if ($msg eq '') {
        MsgPrint('WAR', "msg nothing\n");
        return 0;
    }

    if ($tag eq '') {
        # 
        $tag = ['Request', 'Route', 'Record-Route',
                'From', 'To', 'Contact', 'Reply-To',
                'P-Asserted-Identity', 'P-Preferred-Identity',
                'P-Associated-URI', 'Service-Route',
                'Path', 'History-Info',];
    }
    elsif (ref($tag) ne 'ARRAY') {
        # 
        $tag = [$tag];
    }

    # 
    $ret = 1;

    foreach $cur (@$tag) {
        # Request-URI
        if ($cur eq 'Request') {
            # Request-URI
            $uri = CtFlv("SL,uri,#TXT#", $msg);
            if ($uri ne '' && $uri !~ /^sips:/) {
                push(@ngList, $cur);
                $ret = 0;
            }
        }
        # From, To, Reply-To
        elsif ($cur eq 'From' || $cur eq 'To' || $cur eq 'Reply-To') {
            $uri = CtFlv("HD,#$cur,addr,uri,#TXT#", $msg);
            if ($uri ne '' && $uri !~ /^sips:/) {
                push(@ngList, $cur);
                $ret = 0;
            }
        }
        # Contact
        elsif ($cur eq 'Contact') {
            $uri = CtFlv("HD,#$cur,c-params,addr,uri,#TXT#", $msg);
            if (ref($uri) eq 'ARRAY') {
                $flg = 0;
                foreach $curUri (@$uri) {
                    if ($curUri !~ /^sips:/) {
                        $ret = 0;
                        $flg = 1;
                        last;
                    }
                }
                if ($flg) {
                    push(@ngList, $cur);
                }
            }
            else {
                if ($uri ne '' && $uri !~ /^sips:/) {
                    push(@ngList, $cur);
                    $ret = 0;
                }
            }
        }
        # Route, Record-Route, Service-Route, Path
        elsif ($cur eq 'Route' || $cur eq 'Record-Route' ||
               $cur eq 'Service-Route' || $cur eq 'Path') {
            $uri = CtFlv("HD,#$cur,routes,addr,uri,#TXT#", $msg);
            if (ref($uri) eq 'ARRAY') {
                $flg = 0;
                foreach $curUri (@$uri) {
                    if ($curUri !~ /^sips:/) {
                        $ret = 0;
                        $flg = 1;
                        last;
                    }
                }
                if ($flg) {
                    push(@ngList, $cur);
                }
            }
            else {
                if ($uri ne '' && $uri !~ /^sips:/) {
                    push(@ngList, $cur);
                    $ret = 0;
                }
            }
        }
        # P-Asserted-Identity, P-Preferred-Identity
        elsif ($cur eq 'P-Asserted-Identity' || $cur eq 'P-Preferred-Identity') {
            $uri = CtFlv("HD,#$cur,ids,addr,uri,#TXT#", $msg);
            if (ref($uri) eq 'ARRAY') {
                $flg = 0;
                foreach $curUri (@$uri) {
                    if ($curUri !~ /^sips:/) {
                        $ret = 0;
                        $flg = 1;
                        last;
                    }
                }
                if ($flg) {
                    push(@ngList, $cur);
                }
            }
            else {
                if ($uri ne '' && $uri !~ /^sips:/) {
                    push(@ngList, $cur);
                    $ret = 0;
                }
            }
        }
        # P-Associated-URI
        elsif ($cur eq 'P-Associated-URI') {
            $uri = CtFlv("HD,#PAssociatedURI,assocuri,addr,uri,#TXT#", $msg);
            if (ref($uri) eq 'ARRAY') {
                $flg = 0;
                foreach $curUri (@$uri) {
                    if ($curUri !~ /^sips:/) {
                        $ret = 0;
                        $flg = 1;
                        last;
                    }
                }
                if ($flg) {
                    push(@ngList, $cur);
                }
            }
            else {
                if ($uri ne '' && $uri !~ /^sips:/) {
                    push(@ngList, $cur);
                    $ret = 0;
                }
            }
        }
        # History-Info
        elsif ($cur eq 'History-Info') {
            $uri = CtFlv("HD,#$cur,entry,addr,uri,#TXT#", $msg);
            if (ref($uri) eq 'ARRAY') {
                $flg = 0;
                foreach $curUri (@$uri) {
                    if ($curUri !~ /^sips:/) {
                        $ret = 0;
                        $flg = 1;
                        last;
                    }
                }
                if ($flg) {
                    push(@ngList, $cur);
                }
            }
            else {
                if ($uri ne '' && $uri !~ /^sips:/) {
                    push(@ngList, $cur);
                    $ret = 0;
                }
            }
        }
        else {
            MsgPrint('WAR', "not support tag(%s)\n", $cur);
        }
    }

    # HTML
    CtRlSetEvalResult($context, '2op', 'EQ', $ret, \@ngList, $tag);

    return $ret;
}


#-----------------------------------------------------------------------------
# 
#   
#     $tagList
#     $param,...
#   
#     
#       0
#       0
#   
#     SIP
#     
#-----------------------------------------------------------------------------
sub CtUtChkHdrOrd {
    my ($tagList, $msg, $context) = @_;
    my ($flg, $idx, $cur, $hdrList, $match);
    my ($ret, @ngList);

    if ($tagList eq '') {
        MsgPrint('WAR', "tagList nothing\n");
        return 0;
    }
    if (ref($tagList) ne 'ARRAY') {
        MsgPrint('WAR', "tagList is not ARRAY\n");
        return 0;
    }
    if ($msg eq '') {
        MsgPrint('WAR', "msg nothing\n");
        return 0;
    }

    # 
    $ret = 1;

    # SIP
    $hdrList = CtFlv('HD,#Name#', $msg);

    $flg = 0;
    foreach $cur (@$hdrList) {
        # 
        for ($idx = 0, $match = 0; $idx <= $#$tagList; ++$idx) {
            if ($tagList->[$idx] eq $cur) {
                $match = 1;
                last;
            }
        }
        if ($match) {
            if ($flg) {
                push(@ngList, $cur);
                $ret = 0;
            }
        }
        else {
            # 
            $flg = 1;
        }
    }

    # HTML
    CtRlSetEvalResult($context, '2op', 'EQ', $ret, $tagList, \@ngList);

    return $ret;
}


#-----------------------------------------------------------------------------
# Authorization response
#   
#     $pw
#     $param,...
#   
#     
#       0
#       0
#   
#     Authorization
#     
#-----------------------------------------------------------------------------
sub CtUtAuthResponse {
    my ($pw, $msg, $context) = @_;
    my ($hdr, $authHdrName, $ret);
    my ($usr, $realm, $method, $uri, $body, $nonce, $nc, $cnonce, $qop);

    # 
    $hdr = CtFlv('HD,#Authorization', $msg);
    if ($hdr ne '') {
        $authHdrName = 'HD,#Authorization';
    }
    else {
        $hdr = CtFlv('HD,#Proxy-Authorization', $msg);
        if ($hdr ne '') {
            $authHdrName = 'HD,#Proxy-Authorization';
        }
        else {
            return;
        }
    }

    # 
    $usr = CtFlv("$authHdrName,credentials,credential,digestresp,list,username", $msg);

    # realm
    $realm = CtFlv("$authHdrName,credentials,credential,digestresp,list,realm", $msg);

    # 
    $method = CtFlv("SL,method", $msg);

    # URI
    $uri = CtFlv("$authHdrName,credentials,credential,digestresp,list,uri", $msg);

    # 
    $body = CtFlp('BD', $msg);

    # nonce
    $nonce = CtFlv("$authHdrName,credentials,credential,digestresp,list,nonce", $msg);

    # nc
    $nc = CtFlv("$authHdrName,credentials,credential,digestresp,list,nc", $msg);

    # cnonce
    $cnonce = CtFlv("$authHdrName,credentials,credential,digestresp,list,cnonce", $msg);

    # qop
    $qop = CtFlv("$authHdrName,credentials,credential,digestresp,list,qop", $msg);

    if ($qop eq '') {
        # 
        $ret = CtUtCalcAuthBasicMD5($usr, $realm, $pw, $method, $uri, $nonce);
    }
    elsif ($qop eq 'auth') {
        # 
        $ret = CtUtAuthDigestMD5($usr, $realm, $pw, $method, $uri, $nonce, $nc, $cnonce, $qop);
    }
    elsif ($qop eq 'auth-int') {
        # 
        $ret = CtUtAuthIntDigestMD5($usr, $realm, $pw, $method, $uri, $body, $nonce, $nc, $cnonce, $qop);
    }
    else {
        return;
    }
    return $ret;
}

sub CtUtChkAuthResponse {
    my ($pw, $msg, $context) = @_;
    my ($hdr,$authHdrName, $ret,$response);

    if ($msg eq '') {
        MsgPrint('WAR', "msg nothing\n");
        return 0;
    }

    # 
    $hdr = CtFlv('HD,#Authorization', $msg);
    if ($hdr ne '') {
        $authHdrName = 'HD,#Authorization';
    }
    else {
        $hdr = CtFlv('HD,#Proxy-Authorization', $msg);
        if ($hdr ne '') {
            $authHdrName = 'HD,#Proxy-Authorization';
        }
        else {
            return;
        }
    }

    # response
    $response = CtFlv("$authHdrName,credentials,credential,digestresp,list,response", $msg);
    if ($response eq '') {
        MsgPrint('RULE', "response parameter nothing\n");
        # HTML
        CtRlSetEvalResult($context, '2op', 'EQ', 0, '', '');
        return 0;
    }

    # 
    $ret = CtUtAuthResponse(@_);

    unless($ret){
	# HTML
	CtRlSetEvalResult($context, '2op', 'EQ', 0, '', '');
	return 0;
    }

    if ($response ne $ret) {
        # HTML
        CtRlSetEvalResult($context, '2op', 'EQ', 0, $response, $ret);
        return 0;
    }

    # HTML
    CtRlSetEvalResult($context, '2op', 'EQ', 1, $response, $ret);

    return 1;
}


#-----------------------------------------------------------------------------
# SIP URI
#   
#     $uriA
#     $uriB
#     $param,...
#   
#     
#       0
#       0
#   
#     (sip|sips):userinfo@hostport;param
#     
#       
#     
#-----------------------------------------------------------------------------
sub CtRlChkSipURI {
    my ($uriA, $uriB, $msg, $context) = @_;
    my ($uri1, $uri2, $idx, $ret);

    if ($uriA eq '' || $uriB eq '') {
        MsgPrint('WAR', "uri nothing: A[%s] B[%s]\n", $uriA, $uriB);
        CtRlSetEvalResult($context, '2op', 'EQ', 0, $uriA, $uriB);
        return 0;
    }

    if (ref($uriA) eq 'ARRAY' && ref($uriB) eq 'ARRAY') {
        # 
        if ($#$uriA ne $#$uriB) {
            MsgPrint('RULE', "not equal array num: A[%d] B[%d]\n", $#$uriA, $#$uriB);
            CtRlSetEvalResult($context, '2op', 'EQ', 0, $uriA, $uriB);
            return 0;
        }

        for $idx (0..$#$uriA) {
            if ($uriA->[$idx] =~ /^tel:/) {
                if ($uriA->[$idx] eq $uriB->[$idx]) {
                    $ret = 1;
                }
                else {
                    $ret = 0;
                    last;
                }
            }
            else {
                $ret = CtFlCmpSipURI($uriA->[$idx], $uriB->[$idx]);
                if (!($ret)) {
                    last;
                }
            }
        }
    }
    else {
        # 
        if (ref($uriA) eq 'ARRAY') {
            $uri1 = $uriA->[0];
            $uri2 = $uriB;
        }
        elsif (ref($uriB) eq 'ARRAY') {
            $uri1 = $uriA;
            $uri2 = $uriB->[0];
        }
        else {
            $uri1 = $uriA;
            $uri2 = $uriB;
        }

        if ($uri1 =~ /^tel:/) {
            if ($uri1 eq $uri2) {
                $ret = 1;
            }
            else {
                $ret = 0;
            }
        }
        else {
            $ret = CtFlCmpSipURI($uri1, $uri2);
        }
    }

    # HTML
    CtRlSetEvalResult($context, '2op', 'EQ', $ret, $uriA, $uriB);

    return $ret;
}


#-----------------------------------------------------------------------------
# Via
#   
#     $Via
#     $param,...
#   
#     
#       0
#       0
#   
#     Via
#     
#     
#     
#     
#-----------------------------------------------------------------------------
sub CtRlCmpVia {
    my ($via, $msg, $context) = @_;
    my ($cur, $idx, $viaRec, @viaA, @viaB);

    if ($via eq '' || $msg eq '') {
        MsgPrint('WAR', "parameter nothing: via[%s] msg[%s]\n", $via, $msg);
        return 0;
    }

    # Via
    if (ref($via) eq 'ARRAY') {
         foreach $cur (@$via) {
            ($viaRec) = CtPkDecode('SIP:ViaParm', $cur);
            push(@viaA, $viaRec);
        }
    }
    else {
        ($viaRec) = CtPkDecode('SIP:ViaParm', $via);
        push(@viaA, $viaRec);
    }
    $viaRec = CtFlv('HD,#Via,records', $msg);
    if (ref($viaRec) ne 'ARRAY') {
        push(@viaB, $viaRec);
    }
    else {
        @viaB = @$viaRec;
    }

    if ($#viaA != $#viaB) {
        # HTML
        CtRlSetEvalResult($context, '2op', 'EQ', 0, CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg), $via);
        # Via
        return 0;
    }

    # sent-protocol
    # 06-09-05 
    # if (CtFlGet('proto', $viaA[0]) ne CtFlGet('proto', $viaB[0])) {
    if (CtFlGet('protoname', $viaA[0]) ne CtFlGet('protoname', $viaB[0])
        || CtFlGet('transport', $viaA[0]) ne CtFlGet('transport', $viaB[0])
        || CtFlGet('version', $viaA[0]) ne CtFlGet('version', $viaB[0])) {
        # HTML
        CtRlSetEvalResult($context, '2op', 'EQ', 0, CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg), $via);
        return 0;
    }
    # sentby
    if (!CtUtIsCmpMember('eq', CtFlGet('sentby', $viaA[0]),
                        CtFlGet('sentby', $viaB[0]))) {
        # HTML
        CtRlSetEvalResult($context, '2op', 'EQ', 0, CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg), $via);
        return 0;
    }
    # branch
    if (CtFlGet('params,list,branch', $viaA[0]) ne
            CtFlGet('params,list,branch', $viaB[0])) {
        # HTML
        CtRlSetEvalResult($context, '2op', 'EQ', 0, CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg), $via);
        return 0;
    }
    # 1

    for ($idx = 1; $idx <= $#viaA; ++$idx) {
        # sent-protocol
        # 06-09-05 
        # if (CtFlGet('proto', $viaA[$idx]) ne CtFlGet('proto', $viaB[$idx])) {
        if (CtFlGet('protoname', $viaA[$idx]) ne CtFlGet('protoname', $viaB[$idx])
            || CtFlGet('transport', $viaA[$idx]) ne CtFlGet('transport', $viaB[$idx])
            || CtFlGet('version', $viaA[$idx]) ne CtFlGet('version', $viaB[$idx])) {
            # HTML
            CtRlSetEvalResult($context, '2op', 'EQ', 0, CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg), $via);
            return 0;
        }
        # sentby
        if (!CtUtIsCmpMember('eq', CtFlGet('sentby', $viaA[$idx]),
                            CtFlGet('sentby', $viaB[$idx]))) {
            # HTML
            CtRlSetEvalResult($context, '2op', 'EQ', 0, CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg), $via);
            return 0;
        }
        # branch
        if (CtFlGet('params,list,branch', $viaA[$idx]) ne
                CtFlGet('params,list,branch', $viaB[$idx])) {
            # HTML
            CtRlSetEvalResult($context, '2op', 'EQ', 0, CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg), $via);
            return 0;
        }
        # received
        if (CtFlGet('params,list,addr,ip', $viaA[$idx]) ne
                CtFlGet('params,list,addr,ip', $viaB[$idx])) {
            # HTML
            CtRlSetEvalResult($context, '2op', 'EQ', 0, CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg), $via);
            return 0;
        }
    }

    # HTML
    CtRlSetEvalResult($context, '2op', 'EQ', 1, CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg), $via);

    return 1;
}

# 
#   mode  rough : 
#         NIL   : 
#   
sub CtRlSyntaxResult {
    my($rules,$context,$mode)=@_;
    my($rule,$result);
    $rules = [$rules] unless(ref($rules));
    foreach $rule (@$rules){
	($result)=CtRlGetEvalResult($rule,$context);
	unless($result){
	    MsgPrint('ERR',"Syntax rule[%s] no evaled\n",$rule);
	    return;
	}
	if($result eq 'ERR'){return;}
	if(!$mode && $result eq 'WAR'){return;}
    }
    return 'OK';
}


# @@ -- SipParam.pm --

# use strict;

###############################################################################
#
# SIP Carry Over Parameter Control
#
###############################################################################

#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $fileName
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtUtLoadCOCfg {
    my ($fileName) = @_;
    my ($line, $section, $key, $val, @vals, $no);

    unless( open(COCFG, $fileName) ){
	MsgPrint(INIT,"Can't open [%s]\n",$fileName);
	return ;
    }
    # 1
    while ($line = <COCFG>) {
        # 
        if ($line =~ /^\s*#/) { next; }
        # 
        if ($line =~ /^\[(.+)\]\s*$/) {
            $section = $1;
            last;
        }
    }
    # 2
    while ($line = <COCFG>) {
        # 
        if ($line =~ /^\s*#/) { next; }
        # 
        if ($line =~ /^\[(.+)\]\s*$/) {
            $section = $1;
            next;
        }
        # 
        if ($line =~ /^(\S+)\s+(\S*)\s*$/) {
            $key = $1;
            $val = $2;
	    if($val =~ /^\[.+\]$/){
		$val =~ s/^\[(.+)\]$/$1/;
		@vals = split(/,/, $val);
		foreach $no (0..$#vals){
		    $vals[$no] =~ s/^\s*(\S+)\s*$/$1/;
		}
		CtTbPrmSet("COCFG,$section,$key", \@vals,'T');
	    }
	    else{
		CtTbPrmSet("COCFG,$section,$key", $val);
	    }
        }
    }
    close(COCFG);
}


#-----------------------------------------------------------------------------
# 
#   
#     $fileName
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtUtSaveCOCfg {
    my ($fileName) = @_;
    my ($cocfg, $section, $lst, $key, $val, @keys);

    $cocfg = CtTbPrm("COCFG");
    if ($cocfg eq '') {
        return;
    }

    open(COCFG, "> $fileName");
    while (($section, $lst) = each(%$cocfg)) {
        # 
        if (keys(%$lst) == 0) {
            next;
        }
        print COCFG "[$section]\n";
	@keys=sort(keys(%$lst));
	foreach $key (@keys){
	    if(ref($lst->{$key}) eq 'ARRAY'){
		$val=join(",",@{$lst->{$key}});
		print COCFG "$key		[". $val ."]\n";
	    }
	    else{
		print COCFG "$key		". $lst->{$key} ."\n";
	    }
	}
#         while (($key, $val) = each(%$lst)) {
#             print COCFG "$key $val\n";
#         }
        print COCFG "\n";
    }
    close(COCFG);
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $section
#     $key
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtUtGetCOCfg {
    my ($section, $key) = @_;

    return CtTbPrm("COCFG,$section,$key");
}


#-----------------------------------------------------------------------------
# 
#   
#     $section
#     $key
#     $val
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtUtSetCOCfg {
    my ($section, $key, $val) = @_;

    CtTbPrmSet("COCFG,$section,$key", $val);
}


#-----------------------------------------------------------------------------
# 
#   
#     $section
#     $key
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtUtDelCOCfg {
    my ($section, $key) = @_;
    my ($data);

    $data = CtTbPrm("COCFG,$section");
    if ($data ne '') {
        delete($data->{$key});
    }
}



# @@ -- SipSdp.pm --

# use strict;

###############################################################################
#
# SIP SDP Control
#
###############################################################################

#=============================================================================
# SDP
#=============================================================================

#-----------------------------------------------------------------------------
# SDP
#   
#     $sdpid
#     $param
#     $node
#   
#     
#   
#     SDP
#-----------------------------------------------------------------------------
sub CtSvSDPCreate {
    my ($sdpid, $param, $node) = @_;
    my ($pver, $usr, $sid, $sver, $snet, $strans, $sip, $name, $sbnd, $start, $stop, $key, $sst);
    my ($media, $port, $mnet, $mtrans, $mip, $mbnd, $msts, $ptime, @fmtlist);
    my ($utc, $prot, $trans,$ssts);
    my ($sdp, $mediainf);

    if ($sdpid eq '') {
        CtSvError('fatal', "sdpid nothing");
        return;
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return;
    }

    # 
    $utc = time();
    # 
    $prot = CtTbPrm('CI,protocol');
    if ($prot eq 'INET') {
        $trans = 'IP4';
    }
    else {
        $trans = 'IP6';
    }

    # 
    if ($param->{'session-inf'} ne '' &&
        ref($param->{'session-inf'}) ne 'HASH') {
        CtSvError('fatal', "session-inf is not HASH");
        return;
    }

    # 
    if ($param->{'session-inf'}->{'ProtocolVersion'} ne '') {
        $pver = $param->{'session-inf'}->{'ProtocolVersion'};
    }
    else {
        $pver = 0;
    }

    # 
    if ($param->{'session-inf'}->{'username'} ne '') {
        $usr = $param->{'session-inf'}->{'username'};
    }
    else {
        $usr = '-';
    }

    # 
    if ($param->{'session-inf'}->{'session-id'} ne '') {
        $sid = $param->{'session-inf'}->{'session-id'};
    }
    else {
        $sid = $utc % 999900;
    }

    # 
    if ($param->{'session-inf'}->{'version'} ne '') {
        $sver = $param->{'session-inf'}->{'version'};
    }
    else {
        $sver = $sid; # 
    }

    # 
    if ($param->{'session-inf'}->{'network-type'} ne '') {
        $snet = $param->{'session-inf'}->{'network-type'};
    }
    else {
        $snet = 'IN';
    }

    # 
    if ($param->{'session-inf'}->{'address-type'} ne '') {
        $strans = $param->{'session-inf'}->{'address-type'};
    }
    else {
        $strans = $trans;
    }

    # 
    if ($param->{'session-inf'}->{'address'} ne '') {
        $sip = $param->{'session-inf'}->{'address'};
    }
    else {
        $sip = CtTbUsr($node->{'ID'}, 'address');
    }

    # 
    if ($param->{'session-inf'}->{'session-name'} ne '') {
        $name = $param->{'session-inf'}->{'session-name'};
    }
    else {
        $name = '-';
    }

    # 
    if ($param->{'session-inf'}->{'Bandwidth'} ne '') {
        $sbnd = $param->{'session-inf'}->{'Bandwidth'};
    }
    else {
        $sbnd = '';
    }

    # 
    if ($param->{'session-inf'}->{'start-time'} ne '') {
        $start = $param->{'session-inf'}->{'start-time'};
    }
    else {
        $start = 0;
    }

    # 
    if ($param->{'session-inf'}->{'stop-time'} ne '') {
        $stop = $param->{'session-inf'}->{'stop-time'};
    }
    else {
        $stop = 0;
    }

    # 
    if ($param->{'session-inf'}->{'EncryptionKeys'} ne '') {
        $key = $param->{'session-inf'}->{'EncryptionKeys'};
    }
    else {
        $key = '';
    }

    # 
    if ($param->{'session-inf'}->{'condition'} ne '') {
        $ssts = $param->{'session-inf'}->{'condition'};
    }
    else {
        $ssts = '';
    }

    # 
    if ($param->{'media-inf'} ne '') {
        if (ref($param->{'media-inf'}) ne 'ARRAY') {
            CtSvError('fatal', "media-inf list is not ARRAY");
            return;
        }
        if (ref($param->{'media-inf'}->[0]) ne 'HASH') {
            CtSvError('fatal', "media-inf is not HASH");
            return;
        }
        $mediainf = $param->{'media-inf'};
    }
    else {
        # 
        $media = 'audio';

        # 
        $port = CtTbUsr($node->{'ID'}, 'rtp-port');

        # 
        $mnet = 'IN';

        # 
        $mtrans = $trans;

        # 
        $mip = CtTbUsr($node->{'ID'}, 'address');

        # 
        $mbnd = 'AS:75';

        # 
        $msts = '';

        # 
        $ptime = '';

        # fmt
        push(@fmtlist, {'fmt' => 0, 'rtpmap' => 'rtpmap:0 PCMU/8000'});

        $mediainf = [
                        {
                            'media' => $media,
                            'port' => $port,
                            'fmt-list' => \@fmtlist,
                            'network-type' => $mnet,
                            'address-type' => $mtrans,
                            'connection-address' => $mip,
                            'Bandwidth' => $mbnd,
                            'condition' => $msts,
                            'ptime' => $ptime,
                        },
                    ];
    }

    $sdp = {
               'session-inf' => {
                                    'ProtocolVersion' => $pver,
                                    'username' => $usr,
                                    'session-id' => $sid,
                                    'version' => $sver,
                                    'network-type' => $snet,
                                    'address-type' => $strans,
                                    'address' => $sip,
                                    'session-name' => $name,
                                    'Bandwidth' => $sbnd,
                                    'start-time' => $start,
                                    'stop-time' => $stop,
                                    'EncryptionKeys' => $key,
                                    'condition' => $sst,
                                },
               'media-inf' => $mediainf,
           };

    CtSvSDPSet($sdpid, $sdp, $node);
}


#-----------------------------------------------------------------------------
# SDP
#   
#     $sdpid
#     $msg
#     $node
#   
#     
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtSvSDPUpdate {
    my ($sdpid, $msg, $node) = @_;
    my ($type, $subtype, $cur, $mediaNum, $idx, $sts, $bwtype, $bw, @mediaInf);
    my ($fmt, $fmtIdx, @lst, $lstIdx);
    my ($pver, $sbwtype, $sbw, $startTm, $stopTm, $sst);
    my ($media, $port, $mnet, $mtrans, $mip, $mbnd, $msts, $ptime, $fmtlist,$prot);

    if ($sdpid eq '') {
        CtSvError('fatal', "sdpid nothing");
        return;
    }
    if ($msg eq '') {
        CtSvError('fatal', "msg nothing");
        return;
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return;
    }

    # 
    if ($msg->{'#Direction#'} ne 'in') {
        return;
    }

    # Content-Type
    $type = CtFlv('HD,#Content-Type,type', $msg);
    $subtype = CtFlv('HD,#Content-Type,subtype', $msg);
    if ($type ne 'application' || $subtype ne 'sdp') {
        # SDP
        return;
    }

    # 
    $pver = CtFlv('BD,#v=,version', $msg);
    if ($pver ne '') {
        CtTbSet("SDP,$sdpid,session-inf,ProtocolVersion", $pver, $node);
    }

    # 
    $sbwtype = CtFlv('BD,#b=,bandwith-field,bwtype', $msg);
    if ($sbwtype ne '') {
        $sbw = CtFlv('BD,#b=,bandwith-field,bandwidth', $msg);
        CtTbSet("SDP,$sdpid,session-inf,Bandwidth", "$sbwtype:$sbw", $node);
    }

    # 
    $startTm = CtFlv('BD,#t=,times,start-time', $msg);
    if ($startTm ne '') {
        CtTbSet("SDP,$sdpid,session-inf,start-time", $startTm, $node);
    }

    # 
    $stopTm = CtFlv('BD,#t=,times,stop-time', $msg);
    if ($stopTm ne '') {
        CtTbSet("SDP,$sdpid,session-inf,stop-time", $stopTm, $node);
    }

    # 
    $sst = CtFlv('BD,#a=,attribute-field,attribute', $msg);
    # 
    if (ref($sst) eq 'ARRAY') {
        foreach $cur (@$sst) {
            if ($cur eq 'sendrecv') {
                # 
                CtTbSet("SDP,$sdpid,session-inf,condition", 'sendrecv', $node);
            }
            elsif ($cur eq 'sendonly') {
                # 
                CtTbSet("SDP,$sdpid,session-inf,condition", 'recvonly', $node);
            }
            elsif ($cur eq 'recvonly') {
                # 
                CtTbSet("SDP,$sdpid,session-inf,condition", 'sendonly', $node);
            }
            elsif ($cur eq 'inactive') {
                # 
                CtTbSet("SDP,$sdpid,session-inf,condition", 'inactive', $node);
            }
        }
    }
    else {
        if ($sst eq 'sendrecv') {
            # 
            CtTbSet("SDP,$sdpid,session-inf,condition", 'sendrecv', $node);
        }
        elsif ($sst eq 'sendonly') {
            # 
            CtTbSet("SDP,$sdpid,session-inf,condition", 'recvonly', $node);
        }
        elsif ($sst eq 'recvonly') {
            # 
            CtTbSet("SDP,$sdpid,session-inf,condition", 'sendonly', $node);
        }
        elsif ($sst eq 'inactive') {
            # 
            CtTbSet("SDP,$sdpid,session-inf,condition", 'inactive', $node);
        }
    }

    $mediaNum = CtFlv('BD,#m=,media-part#N', $msg);
    # 
    if ($mediaNum > 0) {
        # 
        $prot = CtTbPrm('CI,protocol');
        if ($prot eq 'INET') {
            $mtrans = 'IP4';
        }
        else {
            $mtrans = 'IP6';
        }

        # 
        $port = CtTbUsr($node->{'ID'}, 'rtp-port');

        # 
        $mnet = 'IN';

        # 
        $mip = CtTbUsr($node->{'ID'}, 'address');

        --$mediaNum;
        for $idx (0..$mediaNum) {
            # 
            $media = CtFlv("BD,#m=,media-part#$idx,media-field,media", $msg);

            # 
            $bwtype = CtFlv("BD,#m=,media-part#$idx,descriptions,#b=,bandwith-field,bwtype", $msg);
            if ($bwtype ne '') {
                $bw = CtFlv("BD,#m=,media-part#$idx,descriptions,#b=,bandwith-field,bandwidth", $msg);
                $mbnd = "$bwtype:$bw";
            }
            else {
                $mbnd = '';
            }

            # 
            $sts = CtFlv("BD,#m=,media-part#$idx,descriptions,#a=,attribute-field,attribute", $msg);
            $msts = '';
            $ptime = '';
            $fmtlist = [];
            # 
            if (ref($sts) eq 'ARRAY') {
                foreach $cur (@$sts) {
                    if ($cur eq 'sendrecv') {
                        # 
                        $msts = 'sendrecv';
                    }
                    elsif ($cur eq 'sendonly') {
                        # 
                        $msts = 'recvonly';
                    }
                    elsif ($cur eq 'recvonly') {
                        # 
                        $msts = 'sendonly';
                    }
                    elsif ($cur eq 'inactive') {
                        # 
                        $msts = 'inactive';
                    }
                    elsif ($cur =~ /^ptime:(\d+)/) {
                        # 
                        $ptime = $1;
                    }
                    elsif ($cur =~ /^rtpmap:(\d+)/) {
                        # rtpmap
                        push(@$fmtlist, {'fmt' => $1, 'rtpmap' => $cur});
                    }
                }
            }
            else {
                if ($sts eq 'sendrecv') {
                    # 
                    $msts = 'sendrecv';
                }
                elsif ($sts eq 'sendonly') {
                    # 
                    $msts = 'recvonly';
                }
                elsif ($sts eq 'recvonly') {
                    # 
                    $msts = 'sendonly';
                }
                elsif ($sts eq 'inactive') {
                    # 
                    $msts = 'inactive';
                }
                elsif ($sts =~ /^ptime:(\d+)/) {
                    # 
                    $ptime = $1;
                }
                elsif ($sts =~ /^rtpmap:(\d+)/) {
                    # rtpmap
                    push(@$fmtlist, {'fmt' => $1, 'rtpmap' => $sts});
                }
            }
            # 
            $fmt = CtFlv("BD,#m=,media-part#$idx,media-field,fmt", $msg);
            @lst = split(/ /, $fmt);
            for ($lstIdx = 0, $fmtIdx = 0; $lstIdx <= $#lst; ++$lstIdx, ++$fmtIdx) {
                if ($fmtIdx > $#$fmtlist) {
                    # rtpmap
                    push(@$fmtlist, {'fmt' => $lst[$lstIdx], 'rtpmap' => ''});
                }
                elsif ($lst[$lstIdx] != $fmtlist->[$fmtIdx]->{'fmt'}) {
                    # rtpmap
                    splice(@$fmtlist, $fmtIdx, 0, {'fmt' => $lst[$lstIdx], 'rtpmap' => ''});
                }
            }

            push(@mediaInf,
                    {
                        'media' => $media,
                        'port' => $port,
                        'fmt-list' => $fmtlist,
                        'network-type' => $mnet,
                        'address-type' => $mtrans,
                        'connection-address' => $mip,
                        'Bandwidth' => $mbnd,
                        'condition' => $msts,
                        'ptime' => $ptime,
                    });
        }

        # 
        # (
        CtTbSet("SDP,$sdpid,media-inf", \@mediaInf, $node);
    }
}


#-----------------------------------------------------------------------------
# SDP
#   
#     $sdpid
#     $msg
#     $nodeName
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtSvSDPSave {
    my ($sdpid, $msg, $nodeName) = @_;
    my ($pver, $usr, $sid, $sver, $snet, $strans, $sip, $name, $sbnd, $start, $stop, $key, $sst);
    my ($media, $port, $mnet, $mtrans, $mip, $mbnd, $msts, $ptime, $fmtlist);
    my ($type, $subtype, $sbwtype, $sbw, $mediaNum, $idx, $cur, $sts, $bwtype, $bw);
    my ($fmt, $fmtIdx, @lst, $lstIdx, $node);
    my ($sdp, $mediainf);

    if ($sdpid eq '') {
        CtSvError('fatal', "sdpid nothing");
        return;
    }
    if ($msg eq '') {
        CtSvError('fatal', "msg nothing");
        return;
    }

    # 
    $node = CtNDFromName($nodeName);
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node(name:$nodeName) is not HASH");
        return;
    }

    # Content-Type
    $type = CtFlv('HD,#Content-Type,type', $msg);
    $subtype = CtFlv('HD,#Content-Type,subtype', $msg);
    if ($type ne 'application' || $subtype ne 'sdp') {
        # SDP
        return;
    }

    # 
    $pver = CtFlv('BD,#v=,version', $msg);

    # 
    $usr = CtFlv('BD,#o=,username', $msg);

    # 
    $sid = CtFlv('BD,#o=,sessid', $msg);

    # 
    $sver = CtFlv('BD,#o=,sessver', $msg);

    # 
    $snet = CtFlv('BD,#c=,nettype', $msg);

    # 
    $strans = CtFlv('BD,#c=,addrtype', $msg);

    # 
    $sip = CtFlv('BD,#c=,addr', $msg);

    # 
    $name = CtFlv('BD,#s=,sessname', $msg);

    # 
    $sbwtype = CtFlv('BD,#b=,bandwith-field,bwtype', $msg);
    if ($sbwtype ne '') {
        $sbw = CtFlv('BD,#b=,bandwith-field,bandwidth', $msg);
        $sbnd = "$sbwtype:$sbw";
    }

    # 
    $start = CtFlv('BD,#t=,times,start-time', $msg);

    # 
    $stop = CtFlv('BD,#t=,times,stop-time', $msg);

    # 
    $key = CtFlv('BD,#k=,key-type', $msg);

    # 
    $sst = CtFlv('BD,#a=,attribute-field,attribute', $msg);

    $mediainf = [];
    $mediaNum = CtFlv('BD,#m=,media-part#N', $msg);
    # 
    if ($mediaNum > 0) {
        --$mediaNum;
        for $idx (0..$mediaNum) {
            # 
            $media = CtFlv("BD,#m=,media-part#$idx,media-field,media", $msg);

            # 
            $port = CtFlv("BD,#m=,media-part#$idx,media-field,port", $msg);

            # 
            $mnet = CtFlv("BD,#m=,media-part#$idx,descriptions,#c=,nettype", $msg);

            # 
            $mtrans = CtFlv("BD,#m=,media-part#$idx,descriptions,#c=,addrtype", $msg);

            # 
            $mip = CtFlv("BD,#m=,media-part#$idx,descriptions,#c=,addr", $msg);

            # 
            $bwtype = CtFlv("BD,#m=,media-part#$idx,descriptions,#b=,bandwith-field,bwtype", $msg);
            if ($bwtype ne '') {
                $bw = CtFlv("BD,#m=,media-part#$idx,descriptions,#b=,bandwith-field,bandwidth", $msg);
                $mbnd = "$bwtype:$bw";
            }
            else {
                $mbnd = '';
            }

            # 
            $sts = CtFlv("BD,#m=,media-part#$idx,descriptions,#a=,attribute-field,attribute", $msg);
            $msts = '';
            $ptime = '';
            $fmtlist = [];
            # 
            if (ref($sts) eq 'ARRAY') {
                foreach $cur (@$sts) {
                    if ($cur eq 'sendrecv') {
                        $msts = 'sendrecv';
                    }
                    elsif ($cur eq 'sendonly') {
                        $msts = 'sendonly';
                    }
                    elsif ($cur eq 'recvonly') {
                        $msts = 'recvonly';
                    }
                    elsif ($cur eq 'inactive') {
                        $msts = 'inactive';
                    }
                    # 
                    elsif ($cur =~ /^ptime:(\d+)/) {
                        $ptime = $1;
                    }
                    # rtpmap
                    elsif ($cur =~ /^rtpmap:(\d+)/) {
                        push(@$fmtlist, {'fmt' => $1, 'rtpmap' => $cur});
                    }
                }
            }
            else {
                if ($sts eq 'sendrecv') {
                    $msts = 'sendrecv';
                }
                elsif ($sts eq 'sendonly') {
                    $msts = 'sendonly';
                }
                elsif ($sts eq 'recvonly') {
                    $msts = 'recvonly';
                }
                elsif ($sts eq 'inactive') {
                    $msts = 'inactive';
                }
                # 
                elsif ($sts =~ /^ptime:(\d+)/) {
                    $ptime = $1;
                }
                # rtpmap
                elsif ($sts =~ /^rtpmap:(\d+)/) {
                    push(@$fmtlist, {'fmt' => $1, 'rtpmap' => $sts});
                }
            }
            # 
            $fmt = CtFlv("BD,#m=,media-part#$idx,media-field,fmt", $msg);
            @lst = split(/ /, $fmt);
            for ($lstIdx = 0, $fmtIdx = 0; $lstIdx <= $#lst; ++$lstIdx, ++$fmtIdx) {
                if ($fmtIdx > $#$fmtlist) {
                    # rtpmap
                    push(@$fmtlist, {'fmt' => $lst[$lstIdx], 'rtpmap' => ''});
                }
                elsif ($lst[$lstIdx] != $fmtlist->[$fmtIdx]->{'fmt'}) {
                    # rtpmap
                    splice(@$fmtlist, $fmtIdx, 0, {'fmt' => $lst[$lstIdx], 'rtpmap' => ''});
                }
            }

            push(@$mediainf,
                    {
                        'media' => $media,
                        'port' => $port,
                        'fmt-list' => $fmtlist,
                        'network-type' => $mnet,
                        'address-type' => $mtrans,
                        'connection-address' => $mip,
                        'Bandwidth' => $mbnd,
                        'condition' => $msts,
                        'ptime' => $ptime,
                    });
        }
    }

    $sdp = {
               'session-inf' => {
                                    'ProtocolVersion' => $pver,
                                    'username' => $usr,
                                    'session-id' => $sid,
                                    'version' => $sver,
                                    'network-type' => $snet,
                                    'address-type' => $strans,
                                    'address' => $sip,
                                    'session-name' => $name,
                                    'Bandwidth' => $sbnd,
                                    'start-time' => $start,
                                    'stop-time' => $stop,
                                    'EncryptionKeys' => $key,
                                    'condition' => $sst,
                                },
               'media-inf' => $mediainf,
           };

    CtSvSDPSet($sdpid, $sdp, $node);
}


#=============================================================================
# SDP
#=============================================================================

#-----------------------------------------------------------------------------
# SDP
#   
#     $sdpid
#     $node
#   
#     SDP
#   
#     
#-----------------------------------------------------------------------------
sub CtSvSDPGet {
    my ($sdpid, $node) = @_;

    if ($sdpid eq '') {
        CtSvError('fatal', "sdpid nothing");
        return '';
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    return CtTbl("SDP,$sdpid", $node);
}


#-----------------------------------------------------------------------------
# SDP
#   
#     $sdpid
#     $sdp
#     $node
#   
#     
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtSvSDPSet {
    my ($sdpid, $sdp, $node) = @_;
    my ($oldSdp);

    if ($sdpid eq '') {
        CtSvError('fatal', "sdpid nothing");
        return;
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return;
    }

    # 
    $oldSdp = CtSvSDPGet($sdpid, $node);
    if ($oldSdp ne '') {
        MsgPrint('WAR', "Overwrite SDP info: SDP ID[%s]\n", $sdpid);
    }

    CtTbSet("SDP,$sdpid", $sdp, $node);
}


#-----------------------------------------------------------------------------
# SDP
#   
#     $sdpid
#     $field
#     $node
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtSvSdp {
    my ($sdpid, $field, $node) = @_;

    if ($sdpid eq '') {
        CtSvError('fatal', "sdpid nothing");
        return;
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return;
    }

    return CtTbl("SDP,$sdpid,$field", $node);
}



1;
