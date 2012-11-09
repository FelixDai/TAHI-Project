#!/usr/local/bin/perl
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


#use strict;

# 
# 10/1/ 4  S.EXPIRES_DECIMAL
#          S.AUTHORIZ.HEADER_MUSTNOT-CONCAT,S.P-AUTH.HEADER_MUSTNOT-CONCAT
#          S.VIA-URI_HOSTNAME
#          S.RFC3261-12-21_Contact,S.REQUIRE-TAG_OPTION,S.P-REQUIRE-TAG_OPTION
#             (S.RFC3261-12-21_Contact

#=================================
# 
#=================================
$CNT_TTC_HEADER_LEN = 255 - 2; # CRLF
$CNT_TTC_VIA_BRANCH_LEN = 32;
$CNT_TTC_TAG_LEN = 32;
$CNT_TTC_CALLID_LEN = 64;
$CNT_TTC_CSEQ_NUM_MAX = 999900;
$CNT_TTC_RSEQ_NUM_MAX = 999900;
$CNT_TTC_CONTACT_URI_USR_LEN = 32;
$CNT_TTC_CONTACT_URI_LEN = 64;
$CNT_TTC_SDP_O_USERNAME_LEN = 10;
$CNT_TTC_SDP_O_SESSIONID_MAX = 999900;
$CNT_TTC_SDP_S_SESSIONNAME_LEN = 10;
$CNT_TTC_SDP_A_PTIME = 20;


# TTC
@TTCRules =
(

#=============================================================================
# JJ90.21 SDP
#   TTC
#     c=
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID_CLINE-IN-MEDIA',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "t=0 0\r\n" .
                  "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "a=rtpmap:0 PCMU/8000"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
            ],
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY.MEDIA-DESCRIPTION_CLINE-IN-MEDIA',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "t=0 0\r\n" .
                  "%s"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
                sub {
                        my($msg);
                        $msg.=JoinKeyValue("%s",FVs('BD.m=.val',@_),'txt');
                        $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $CNT_PORT_CHANGE_RTP/img;
                        $msg=~ s/^c=.*(?:\r\n|\Z)//mg;
                        $msg=~ s/sendonly/recvonly/mg;
                        $msg=~ s/^(m=.*)$/${1}\r\nc=IN IP$SIP_PL_IP $CVA_PUA_IPADDRESS\r\n/img;
                        $msg=~ s/\r\n$//;return $msg;
                    },
            ],
 },

#=============================================================================
# JJ90.21 SDP
#   TTC
#     a=rtpmap
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID_OMIT_RTPMAP',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n" .
                  "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
            ],
 },

#=============================================================================
# JJ90.21 SDP
#  TTC
#    c=
#    JF-IETF-RFC3264[3]

#
# THIS RULE IS FOR IPV4 ONLY.
#
#   written by Horisawa (2006.2.21)
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID_CONNADDR-ALL0',
   'SP:' => 'TTC',
   'PT:' => 'BD',
   'FM:' =>
    \q{"v=0\r\n" .
       "o=- ".$CNT_PUA_SDP_O_SESSION." %s IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS."\r\n".
       "s=-\r\n".
       "c=IN IP$SIP_PL_IP 0.0.0.0\r\n".
       "t=0 0\r\n%s"
    },
   'AR:'=>[
        sub{
            $CNT_PUA_SDP_O_VERSION++;
            return $CNT_PUA_SDP_O_VERSION;
        },
        sub{
            my($msg,@mdec);
            push(@mdec,$msg);
            push(@mdec,map($_->{txt}, @{$CVA_TUA_M_MEDIA_DESCRIPTION->{'m='}}));
            $msg=JoinKeyValue("%s",\@mdec);
            $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $CNT_PORT_CHANGE_RTP/img;
            $msg=~ s/\r\n$//;return $msg;
        }
    ]
 },

#=============================================================================
# JJ90.21 m=
#  TTC
#    m=
#    
#    
#    re-INVITE
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.M_NOTEXIST-OFFER_M_NOTEXIST',
   'SP:' => 'TTC',
   'CA:' => 'm=',
   'OK:' => "The answer must not include m line, if the offer without m line be received.",
   'NG:' => "The answer must not include m line, if the offer without m line be received.",
   'EX:' => \q{!FFIsExistHeader("m=", @_)},
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID_NO-MEDIA',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP $CVA_PUA_IPADDRESS\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP $CVA_PUA_IPADDRESS\r\n" .
                  "t=0 0"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
            ],
 },

#=============================================================================
# JJ90.21 
#  TTC
#    
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.M-PORT_NOTSUPPORT',
   'SP:' => 'TTC',
   'CA:' => 'm=',
   'OK:' => "The port in m line in SDP must be 0, if media is not support.",
   'NG:' => "The port in m line in SDP must be 0, if media is not support.",
   'PR:' => \'FFIsExistHeader("m=", @_)',
   'EX:' => sub {
                    my $answer;
                    my $media;
                    my $port;
                    $answer = FVs('BD.m=.val.media.txt', @_);
                    foreach (@$answer) {
                        $_ =~ /\s*(\S+)\s+(\S+)\s/;
                        $media = $1;
                        $port = $2;
                        if ($media eq 'audio') {
                            if ($port == 0) {
                                return '';
                            }
                        }
                        else {
                            if ($port != 0) {
                                return '';
                            }
                        }
                    }
                    return 'ok';
                },
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID_MEDIA_MULTI',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP $CVA_PUA_IPADDRESS\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP $CVA_PUA_IPADDRESS\r\n" .
                  "t=0 0\r\n" .
                  "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n" .
                  "a=rtpmap:0 PCMU/8000\r\n" .
                  "m=application %s udp wb\r\n" .
                  "a=orient:portrait"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
                \q{$CNT_PORT_CHANGE_RTP + 1},
            ],
 },

#=============================================================================
# JJ90.21 
#  TTC
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.A-PTIME_SAME-AS-OFFER',
   'SP:' => 'TTC',
   'CA:' => 'Body',
   'OK:' => \\'The packet(%s) time of a line in SDP must be equal to that(%s) on offer, if acceptable received packet interval.',
   'NG:' => \\'The packet(%s) time of a line in SDP must be equal to that(%s) on offer, if acceptable received packet interval.',
   'PR:' => sub {
                    my $preOline;
                    my $preVer;
                    my $curVer;
                    $preOline = FVib('recv',
                                     -1,
                                     '',
                                     'BD.o=.txt',
                                     'RQ.Status-Line.code',
                                     '200');
                    $preOline =~ /\s*.+\s+.+\s+(.+)\s+/;
                    $preVer = $1;
                    if ($preVer eq '') {
                        return '';
                    }
                    $curVer = FFGetIndexValSeparateDelimiter(\\'BD.o=.txt', 2, ' ', @_);
                    if ($curVer eq '') {
                        return '';
                    }
                    if ($curVer <= $preVer) {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => sub {
                    my $offerPtime = '';
                    my $answerPtime = '';
                    my $type;
                    $type = FVib('send',
                                 '',
                                 '',
                                 'BD.m=.val.attr.txt',
                                 'RQ.Status-Line.txt', '',
                                 'BD.txt', \q{$val});
                    foreach (@$type) {
                        if ($_ =~ /\s*ptime\s*:\s*(.+)\s*/) {
                            $offerPtime = $1;
                            last;
                        }
                    }
                    $type = FVs('BD.m=.val.attr.txt', @_);
                    foreach (@$type) {
                        if ($_ =~ /\s*ptime\s*:\s*(.+)\s*/) {
                            $answerPtime = $1;
                            last;
                        }
                    }
                    return FFop('==', $answerPtime, $offerPtime, @_);
                },
 },

#   written by Horisawa (2006.2.22)
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID_A-PTIME',
   'SP:' => 'TTC',
   'PT:' => 'BD',
   'FM:' => \q{"a=ptime:$CNT_TTC_SDP_A_PTIME"},
 },

#=============================================================================
# JJ90.24 
#   TTC
#     
#   RFC3261
#     
#     
 { 
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.M-MEDIA_AUDIO',
   'SP:' => 'TTC',
   'CA:' => 'm=',
   'OK:' => "The media in m line in SDP must be audio.",
   'NG:' => "The media in m line in SDP must be audio.",
   'PR:' => \'FFIsExistHeader("m=", @_)',
   'EX:' => sub {
                    my $media;
                    $media = FVs('BD.m=.val.media.media', @_);
                    foreach (@$media) {
                        if ($_ eq 'audio') {
                            return 'ok';
                        }
                    }
                    return '';
                },
 },

#=============================================================================
# JJ90.24 REGISTER
#  TTC
#    maddr-param
#  RFC3261
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.CONTACT-MADDR_NOEXIST',
   'SP:' => 'TTC',
   'CA:' => 'Contact',
   'OK:' => "The maddr parameter of Request-URI must not include.",
   'NG:' => "The maddr parameter of Request-URI must not include.",
   'PR:' => \'FFIsExistHeader("Contact", @_)',
   'EX:' => sub {
                    my $maddr;
                    $maddr = FV('HD.Contact.val.contact.ad.ad.param.maddr-param', @_);
                    if ($maddr ne '') {
                        return '';
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 REGISTER
#  TTC
#    qop
#    
#    qop
#    
#  RFC3261
#    
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.AUTHORIZ-QOP.NOT_EXIST',
   'SP:' => 'TTC',
   'CA:' => 'Authorization',
   'OK:' => "The qop parameter must not include when not received qop parameter.",
   'NG:' => "The qop parameter must not include when not received qop parameter.",
   'PR:' => sub {
                    if (!FFIsExistHeader("Authorization", @_)) {
                        return '';
                    }
                    if (FVib('send', '', '',
                             'HD.WWW-Authenticate.val.digest.qop',
                             'RQ.Status-Line.code', '401') ne '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => sub {
                    if (FV('HD.Authorization.val.digest.qop', @_) ne '') {
                        return '';
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 
#  TTC
#    MD5
#  RFC3261
#    MD5/MD5-sess
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.AUTHORIZ-ALGORITHM.MD5',
   'SP:' => 'TTC',
   'CA:' => 'Authorization',
   'OK:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.',
   'NG:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.',
   'PR:' => \\'HD.Authorization.val.digest.algorithm',
   'EX:' => \q{FFop('eq', \\\'HD.Authorization.val.digest.algorithm', 'MD5', @_)},
 },

#=============================================================================
# JJ90.24 INVITE
#  TTC
#    qop
#    
#    qop
#    
#  RFC3261
#    
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.P-AUTH-QOP.NOT_EXIST',
   'SP:' => 'TTC',
   'CA:' => 'Proxy-Authorization',
   'OK:' => "The qop parameter must not include when not received qop parameter.",
   'NG:' => "The qop parameter must not include when not received qop parameter.",
   'PR:' => sub {
                    if (!FFIsExistHeader("Proxy-Authorization", @_)) {
                        return '';
                    }
                    if (FVib('send', '', '',
                             'HD.Proxy-Authenticate.val.digest.qop',
                             'RQ.Status-Line.code', '407') ne '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => sub {
                    if (FV('HD.Proxy-Authorization.val.digest.qop', @_) ne '') {
                        return '';
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 
#  TTC
#    MD5
#  RFC3261
#    MD5/MD5-sess
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.P-AUTH-ALGORITHM.MD5',
   'SP:' => 'TTC',
   'CA:' => 'Proxy-Authorization',
   'OK:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.',
   'NG:' => \\'The algorithm(%s) parameter must be \"MD5\" if the algorithm parameter exists.',
   'PR:' => \\'HD.Proxy-Authorization.val.digest.algorithm',
   'EX:' => \q{FFop('eq', \\\'HD.Proxy-Authorization.val.digest.algorithm', 'MD5', @_)},
 },

#=============================================================================
# JJ90.24 Early
#  TTC
#    SDP
#    
#  RFC3311
#    
#    

#   written by Horisawa (2006.2.21)
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.M-LINE_SAME-PAYLOAD-TYPE_UA-21-4-1',
   'SP:' => 'TTC',
   'CA:' => 'Body',
   'OK:' => "The media path based on the SDP of the firest 1xx response MUST NOT be modified.",
   'NG:' => "The media path based on the SDP of the firest 1xx response MUST NOT be modified.",
#   'PR:' => \q{FV('BD.txt', @_)},
   'EX:' => \q{FFop('eq',FV('BD.m=.val.media.fmt',@_),FVif('send','','','BD.m=.val.media.fmt','RQ.Status-Line.code','183'),@_)},
 },

#=============================================================================
# JJ90.24 Early
#  TTC
#    1xx
#  RFC3311
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP_NOTEXIST-1XX',
   'SP:' => 'TTC',
   'CA:' => 'Body',
   'OK:' => "The 1XX response must not include SDP.",
   'NG:' => "The 1XX response must not include SDP.",
   'EX:' => \q{length(FV('BD.txt', @_)) == 0},
 },

#=============================================================================
# JJ90.24 
#  TTC
#    REGISTER
#    
#  RFC3261
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.CONTACT_DIFF-REG',
   'SP:' => 'TTC',
   'CA:' => 'Contact',
   'OK:' => \\'A Contact(%s) header field must be different from that(%s) in REGISTER.',
   'NG:' => \\'A Contact(%s) header field must be different from that(%s) in REGISTER.',
   'PR:' => \'FFIsExistHeader("Contact", @_)',
   'EX:' => \q{FFop('ne',
                    FV('HD.Contact.val.contact.ad.ad.txt', @_),
                    FVib('recv',
                         '',
                         '',
                         'HD.Contact.val.contact.ad.ad.txt',
                         'RQ.Request-Line.method',
                         'REGISTER'),
                    @_)
              },
 },

#=============================================================================
# JJ90.24 
#  TTC
#    ITU-T
#    
#    
#  IETF
#    
 { 
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.M-MEDIA-CODEC_G711U',
   'SP:' => 'TTC',
   'CA:' => 'm=',
   'OK:' => "The fmt list in m line in SDP must include 0(support G.711u-Law).",
   'NG:' => "The fmt list in m line in SDP must include 0(support G.711u-Law).",
   'PR:' => sub {
                    my $media;
                    if (!FFIsExistHeader("m=", @_)) {
                        return '';
                    }
                    $media = FVs('BD.m=.val.media.media', @_);
                    foreach (@$media) {
                        if ($_ eq 'audio') {
                            return 'exec';
                        }
                    }
                    return '';
                },
   'EX:' => sub {
                    my $media;
                    my $fmtlsts;
                    my @fmtlst;
                    my $fmt;
                    $media = FVs('BD.m=.val.media.media', @_);
                    $fmtlsts = FVs('BD.m=.val.media.fmt', @_);
                    foreach (@$media) {
                        if ($_ eq 'audio') {
                            @fmtlst = split(/\s+/, @$fmtlsts[0]);
                            foreach $fmt (@fmtlst) {
                                if ($fmt eq '0') {
                                    return 'ok';
                                }
                            }
                        }
                        shift @$fmtlsts;
                    }
                    return '';
                },
 },

 { 
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.A-RTPMAP-G711U_0',
   'SP:' => 'TTC',
   'CA:' => 'a=',
   'OK:' => "The payload type of a line that encoding name is G.711u-Law must be 0 if rtpmap exists.",
   'NG:' => "The payload type of a line that encoding name is G.711u-Law must be 0 if rtpmap exists.",
   'PR:' => sub {
                    my $media;
                    if (!FFIsExistHeader("m=", @_)) {
                        return '';
                    }
                    $media = FVs('BD.m=.val.media.media', @_);
                    foreach (@$media) {
                        if ($_ eq 'audio') {
                            return 'exec';
                        }
                    }
                    return '';
                },
   'EX:' => sub {
                    my $codec;
                    $codec = FVs('BD.m=.val.attr.txt', @_);
                    foreach (@$codec) {
                        if ($_ =~ /^\s*rtpmap\s*:\s*(\d)+\s+PCMU\/8000\s*/) {
                            if ($1 != 0) {
                                return '';
                            }
                        }
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 
#  TTC
#    
#  RFC3261
#    Initial-INVITE
#    200OK(
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP_EXIST-INITIAL_INVITE',
   'SP:' => 'TTC',
   'CA:' => 'Body',
   'OK:' => "Initial-INVITE must include offer.",
   'NG:' => "Initial-INVITE must include offer.",
   'PR:' => \q{FV('HD.To.val.param.tag', @_) eq ''},
   'EX:' => \q{length(FV('BD.txt', @_)) > 0},
 },

#=============================================================================
# JJ90.24 RTP
#  TTC
#    
#    
#  IETF
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.NOT-TRANS-BYE-ICMP',
   'SP:' => 'TTC',
   'CA:' => 'SIP',
   'OK:' => "Client must not transmit BYE after client received ICMP Unreachable.",
   'NG:' => "Client must not transmit BYE after client received ICMP Unreachable.",
   'EX:' => \q{FFop('ne', \\\'RQ.Request-Line.method', 'BYE', @_)},
 },

 {
   'TY:' => 'RULESET',
   'ID:' => 'SSet.NOT-TRANS-BYE-ICMP',
   'SP:' => 'TTC',
   'RR:' => [
              'S.NOT-TRANS-BYE-ICMP',
            ],
 },

#=============================================================================
# JJ90.24 Initial-INVITE
#  TTC
#    a=inactive,a=sendonly,a=recvonly
#    a=ptime
#  IETF
#    
 { 
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.M-MEDIA-INTERACTIVE-INITIAL_INVITE',
   'SP:' => 'TTC',
   'CA:' => 'a=',
   'OK:' => "The a line in SDP must not be setting \"inactive\" or \"sendonly\", \"recvonly\".",
   'NG:' => "The a line in SDP must not be setting \"inactive\" or \"sendonly\", \"recvonly\".",
   'PR:' => sub {
                    if (FV('HD.To.val.param.tag', @_) ne '') {
                        return '';
                    }
                    if (FV('BD.m=.val.attr.field', @_) eq '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => sub {
                    my $type;
                    $type = FVs('BD.m=.val.attr.field', @_);
                    foreach (@$type) {
                        if ($_ =~ /(inactive|sendonly|recvonly)/) {
                            return '';
                        }
                    }
                    return 'ok';
                },
 },

 { 
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.A-PTIME_20MSEC-INITIAL_INVITE',
   'SP:' => 'TTC',
   'CA:' => 'a=',
   'OK:' => "The packet time of a line in SDP recommend setting $CNT_TTC_SDP_A_PTIME msec.",
   'NG:' => "The packet time of a line in SDP recommend setting $CNT_TTC_SDP_A_PTIME msec.",
   'RT:' => "warning",
   'PR:' => sub {
                    if (FV('HD.To.val.param.tag', @_) ne '') {
                        return '';
                    }
                    if (FV('BD.m=.val.attr.field', @_) eq '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => sub {
                    my $type;
                    $type = FVs('BD.m=.val.attr.txt', @_);
                    foreach (@$type) {
                        if ($_ =~ /^\s*ptime\s*:\s*(\d+)\s*/) {
                            if ($1 != $CNT_TTC_SDP_A_PTIME) {
                                return '';
                            }
                        }
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 Initial-INVITE
#  TTC
#    Media Descrition
#    
#  IETF
#    audio,video
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.M-LINE_NOTREPEAT-INITIAL_INVITE',
   'SP:' => 'TTC',
   'CA:' => 'm=',
   'OK:' => "The m line in SDP must include only one.",
   'NG:' => "The m line in SDP must include only one.",
   'PR:' => sub {
                    if (FV('HD.To.val.param.tag', @_) ne '') {
                        return '';
                    }
                    if (!FFIsExistHeader("m=", @_)) {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => \q{FFop('==', FVcount(FVs('BD.m=.val', @_)), 1, @_)},
 },

#=============================================================================
# JJ90.24 Initial-INVITE
#  TTC
#    
#    
#  IETF
#    Initial-INVITE
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID-MEDIA_INACTIVE',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n" .
                  "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n" .
                  "a=rtpmap:0 PCMU/8000\r\n" .
                  "a=inactive"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
            ],
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID-MEDIA_SENDONLY',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n" .
                  "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n" .
                  "a=rtpmap:0 PCMU/8000\r\n" .
                  "a=sendonly"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
            ],
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID-MEDIA_RECVONLY',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n" .
                  "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n" .
                  "a=rtpmap:0 PCMU/8000\r\n" .
                  "a=recvonly"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
            ],
 },

#=============================================================================
# JJ90.24 
#  TTC
#    
#    
#    
#    
#    
#    o=
#      
#          
#          
#  RFC3261
#    
#    [MUST]
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID-SELECT_CODEC-INC',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n%s"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
                sub {
                        my $msg;
                        $msg .= JoinKeyValue("%s", FVs('BD.m=.val',@_), 'txt');
                        $msg =~ s/^c=.*(?:\r\n|\Z)//mg;
                        $msg =~ s/^m=\s*audio\s+[0-9]+/m=audio $CNT_PORT_CHANGE_RTP/img;
                        $msg =~ s/\r\n$//;
                        return $msg;
                    },
            ],
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID-SELECT_CODEC-NOT_INC',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n%s"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                \'$CNT_PUA_SDP_O_VERSION',
                sub {
                        my $msg;
                        $msg .= JoinKeyValue("%s", FVs('BD.m=.val',@_), 'txt');
                        $msg =~ s/^c=.*(?:\r\n|\Z)//mg;
                        $msg =~ s/^m=\s*audio\s+[0-9]+/m=audio $CNT_PORT_CHANGE_RTP/img;
                        $msg =~ s/\r\n$//;
                        return $msg;
                    },
            ],
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID-CODEC_MULTI-INC',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n" .
                  "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0 3 4 8 9\r\n" .
                  "a=rtpmap:0 PCMU/8000\r\n" .
                  "a=rtpmap:3 GSM/8000\r\n" .
                  "a=rtpmap:4 G723/8000\r\n" .
                  "a=rtpmap:8 PCMA/8000\r\n" .
                  "a=rtpmap:9 G722/8000"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
            ],
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID-CODEC_MULTI-NOT_INC',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n" .
                  "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0 3 4 8 9\r\n" .
                  "a=rtpmap:0 PCMU/8000\r\n" .
                  "a=rtpmap:3 GSM/8000\r\n" .
                  "a=rtpmap:4 G723/8000\r\n" .
                  "a=rtpmap:8 PCMA/8000\r\n" .
                  "a=rtpmap:9 G722/8000"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                \'$CNT_PUA_SDP_O_VERSION',
            ],
 },

#=============================================================================
# JJ90.24 
#  TTC
#    4

 # Request-URI: 
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.R-URI-USER_PHONE_NUMBER',
   'SP:' => 'TTC',
   'CA:' => 'Request',
   'OK:' => "The user value must be telephone number.",
   'NG:' => "The user value must be telephone number.",
   'EX:' => \q{FFIsMatchStr('^\d+$', \\\'RQ.Request-Line.uri.ad.userinfo', '', '', @_)},
 },

 # Request-URI: (186)
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.R-URI-USER_PREFIX_186_EXIST',
   'SP:' => 'TTC',
   'CA:' => 'Request',
   'OK:' => "The user value must append prefix \"186\", even if operator call a telephone number without prefix \"186\".",
   'NG:' => "The user value must append prefix \"186\", even if operator call a telephone number without prefix \"186\".",
   'EX:' => \q{FFIsMatchStr('^186', \\\'RQ.Request-Line.uri.ad.userinfo', '', '', @_)},
 },

 # Request-URI: 186
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.R-URI-USER_PREFIX_186_NOTEXIST',
   'SP:' => 'TTC',
   'CA:' => 'Request',
   'OK:' => "The user value must not append prefix \"186\", even if operator call a telephone number with prefix \"186\".",
   'NG:' => "The user value must not append prefix \"186\", even if operator call a telephone number with prefix \"186\".",
   'EX:' => \q{!FFIsMatchStr('^186', \\\'RQ.Request-Line.uri.ad.userinfo', '', '', @_)},
 },

 # Request-URI: (184)
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.R-URI-USER_PREFIX_184_EXIST',
   'SP:' => 'TTC',
   'CA:' => 'Request',
   'OK:' => "The user value must append prefix \"184\", even if operator call a telephone number without prefix \"184\".",
   'NG:' => "The user value must append prefix \"184\", even if operator call a telephone number without prefix \"184\".",
   'EX:' => \q{FFIsMatchStr('^184', \\\'RQ.Request-Line.uri.ad.userinfo', '', '', @_)},
 },

 # Request-URI: 184
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.R-URI-USER_PREFIX_184_NOTEXIST',
   'SP:' => 'TTC',
   'CA:' => 'Request',
   'OK:' => "The user value must not append prefix \"184\", even if operator call a telephone number with prefix \"184\".",
   'NG:' => "The user value must not append prefix \"184\", even if operator call a telephone number with prefix \"184\".",
   'EX:' => \q{!FFIsMatchStr('^184', \\\'RQ.Request-Line.uri.ad.userinfo', '', '', @_)},
 },

 # Request-URI
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.R-URI_REMOTE-URI_186',
   'SP:' => 'TTC',
   'CA:' => 'Request',
   'OK:' => \\'Request-URI(%s) MUST equal remote target URI(%s) of the Tester(form of IP address, port number is not acceptable).',
   'NG:' => \\'Request-URI(%s) MUST equal remote target URI(%s) of the Tester(form of IP address, port number is not acceptable).',
   'EX:' => sub {
                    my $targetUri;
                    my $localUri;
                    $targetUri = FV('RQ.Request-Line.uri.ad.txt', @_);
                    $localUri = $CVA_PUA_URI;
                    if ($localUri !~ /^sips?:186/) {
                        $localUri =~ s/^(sips?:)/${1}186/
                    }
                    FFCompareAddress('UserInfoHostPort', 'name-strict', $targetUri, $localUri, @_);
                },
 },

 # Request-URI
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.R-URI_REMOTE-URI_184',
   'SP:' => 'TTC',
   'CA:' => 'Request',
   'OK:' => \\'Request-URI(%s) MUST equal remote target URI(%s) of the Tester(form of IP address, port number is not acceptable).',
   'NG:' => \\'Request-URI(%s) MUST equal remote target URI(%s) of the Tester(form of IP address, port number is not acceptable).',
   'EX:' => sub {
                    my $targetUri;
                    my $localUri;
                    $targetUri = FV('RQ.Request-Line.uri.ad.txt', @_);
                    $localUri = $CVA_PUA_URI;
                    if ($localUri !~ /^sips?:184/) {
                        $localUri =~ s/^(sips?:)/${1}184/
                    }
                    FFCompareAddress('UserInfoHostPort', 'name-strict', $targetUri, $localUri, @_);
                },
 },

 # From: Anonymous
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.FROM-URI_ANONYMOUS-URI',
   'CA:' => 'From',
   'SP:' => 'TTC',
   'OK:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'NG:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'PR:' => \'FFIsExistHeader("From", @_)',
   'EX:' => \q{FFCompareAddress('UserInfoHostPort',
                                'strict-without-port',
                                FV('HD.From.val.ad.txt', @_),
                                '"Anonymous" <sip:anonymous@anonymous.invalid>',
                                @_)},
 },

 # From: Coin line/payphone
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.FROM-URI_COIN_LINE-URI',
   'CA:' => 'From',
   'SP:' => 'TTC',
   'OK:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'NG:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'PR:' => \'FFIsExistHeader("From", @_)',
   'EX:' => \q{FFCompareAddress('UserInfoHostPort',
                                'strict-without-port',
                                FV('HD.From.val.ad.txt', @_),
                                '"Coin line/payphone" <sip:anonymous@anonymous.invalid>',
                                @_)},
 },

 # From: Interaction with other service
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.FROM-URI_INTERACTION-URI',
   'CA:' => 'From',
   'SP:' => 'TTC',
   'OK:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'NG:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'PR:' => \'FFIsExistHeader("From", @_)',
   'EX:' => \q{FFCompareAddress('UserInfoHostPort',
                                'strict-without-port',
                                FV('HD.From.val.ad.txt', @_),
                                '"Interaction with other service" <sip:anonymous@anonymous.invalid>',
                                @_)},
 },

 # From: Unavailable
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.FROM-URI_UNAVAILABLE-URI',
   'CA:' => 'From',
   'SP:' => 'TTC',
   'OK:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'NG:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'PR:' => \'FFIsExistHeader("From", @_)',
   'EX:' => \q{FFCompareAddress('UserInfoHostPort',
                                'strict-without-port',
                                FV('HD.From.val.ad.txt', @_),
                                '"Unavailable" <sip:anonymous@anonymous.invalid>',
                                @_)},
 },

 # From: unknown
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.FROM-URI_UNKNOWN-URI',
   'CA:' => 'From',
   'SP:' => 'TTC',
   'OK:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'NG:' => \\'The URI(%s) in the From field must equal reason for Calling line identification restriction(%s).',
   'PR:' => \'FFIsExistHeader("From", @_)',
   'EX:' => \q{FFCompareAddress('UserInfoHostPort',
                                'strict-without-port',
                                FV('HD.From.val.ad.txt', @_),
                                '"unknown" <sip:anonymous@anonymous.invalid>',
                                @_)},
 },

 # To: Request-URI
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.TO-URI_R-URI',
   'SP:' => 'TTC',
   'CA:' => 'To',
   'OK:' => \\'The URI(%s) in the To field must equal the Request-URI(%s).',
   'NG:' => \\'The URI(%s) in the To field must equal the Request-URI(%s).',
   'PR:' => \'FFIsExistHeader("To", @_)',
   'EX:' => \q{FFCompareAddress('UserInfoHostPort',
                                'strict-without-port',
                                FV('HD.To.val.ad.ad.txt', @_),
                                FV('RQ.Request-Line.uri.ad.txt', @_),
                                @_)},
 },

 # To: (184)
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.TO-URI_REMOTE-URI_184',
   'CA:' => 'To',
   'SP:' => 'TTC',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.',
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.',
   'PR:' => \'FFIsExistHeader("To", @_)',
   'EX:' => sub {
                    my $targetUri;
                    my $localUri;
                    $targetUri = FV('HD.To.val.ad.ad.txt', @_);
                    $localUri = $CVA_TUA_URI;
                    if ($localUri !~ /^sips?:184/) {
                        $localUri =~ s/^(sips?:)/${1}184/
                    }
                    FFCompareAddress('UserInfoHostPort', 'name-strict', $targetUri, $localUri, @_);
                },
 },

 # To: (186)
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.TO-URI_REMOTE-URI_186',
   'CA:' => 'To',
   'SP:' => 'TTC',
   'OK:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.',
   'NG:' => \\'The URI(%s) in the To field MUST equal the remote URI(%s) of the Tester.',
   'PR:' => \'FFIsExistHeader("To", @_)',
   'EX:' => sub {
                    my $targetUri;
                    my $localUri;
                    $targetUri = FV('HD.To.val.ad.ad.txt', @_);
                    $localUri = $CVA_TUA_URI;
                    if ($localUri !~ /^sips?:186/) {
                        $localUri =~ s/^(sips?:)/${1}186/
                    }
                    FFCompareAddress('UserInfoHostPort', 'name-strict', $targetUri, $localUri, @_);
                },
 },

 # Privacy: 
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.PRIVACY_EXIST',
   'SP:' => 'TTC',
   'CA:' => 'Privacy',
   'OK:' => 'A Privacy header field must exist in this message.',
   'NG:' => 'A Privacy header field must exist in this message.',
   'EX:' => \q{FFIsExistHeader('Privacy', @_)},
 },

 # Privacy: none
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.PRIVACY_VALUE_NONE',
   'SP:' => 'TTC',
   'CA:' => 'Privacy',
   'OK:' => \\'A Privacy header field(%s) must have the value \"none\"',
   'NG:' => \\'A Privacy header field(%s) must have the value \"none\"',
   'PR:' => \'FFIsExistHeader("Privacy", @_)',
   'EX:' => \q{FFop('eq', FV('HD.Privacy.txt', @_ ), 'none', @_)},
 },

 # Privacy: id
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.PRIVACY_VALUE_ID',
   'SP:' => 'TTC',
   'CA:' => 'Privacy',
   'OK:' => \\'A Privacy header field(%s) must have the value \"id\"',
   'NG:' => \\'A Privacy header field(%s) must have the value \"id\"',
   'PR:' => \'FFIsExistHeader("Privacy", @_)',
   'EX:' => \q{FFop('eq' , FV('HD.Privacy.txt',@_ ), 'id', @_)},
 },

 # Privacy: 
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.PRIVACY_NOTEXIST',
   'SP:' => 'TTC',
   'CA:' => 'Privacy',
   'OK:' => 'A Privacy header field must not exist in this message.',
   'NG:' => 'A Privacy header field must not exist in this message.',
   'EX:' => \q{!FFIsExistHeader('Privacy', @_)},
 },

 # P-Preferred-Identity: 
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.P-PREF-ID_EXIST',
   'SP:' => 'TTC',
   'CA:' => 'P-Preferred-Identity',
   'OK:' => 'A P-Preferred-Identity header field must exist in this message.',
   'NG:' => 'A P-Preferred-Identity header field must exist in this message.',
   'EX:' => \q{FFIsExistHeader("P-Preferred-Identity", @_)},
 },

 # P-Preferred-Identity: 
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.P-PREF-ID_NOTEXIST',
   'SP:' => 'TTC',
   'CA:' => 'P-Preferred-Identity',
   'OK:' => 'A P-Preferred-Identity header field must not exist in this message.',
   'NG:' => 'A P-Preferred-Identity header field must not exist in this message.',
   'EX:' => \q{!FFIsExistHeader("P-Preferred-Identity", @_)},
 },

 # 
 {
   'TY:' => 'RULESET',
   'ID:' => 'SSet.CLIP_METHOD1',
   'SP:' => 'TTC',
   'RR:' => [
              'S.RFC3323-4-1_headers',
              'S.RFC3325-9-5_P-Preferred-Identity',
              'S.RFC3325-9-6_P-Preferred-Identity',
              'S.RFC3325-9-7_P-Preferred-Identity',
              'S.R-URI-USER_PHONE_NUMBER',
              'S.R-URI-USER_PREFIX_186_NOTEXIST',
              'S.TO-URI_R-URI',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_NONE',
            ],
 },

 # 
 {
   'TY:' => 'RULESET',
   'ID:' => 'SSet.CLIR_METHOD1',
   'SP:' => 'TTC',
   'RR:' => [
              'S.RFC3323-4-1_headers',
              'S.RFC3323-4-5_From',
              'S.RFC3323-4-6_From',
              'S.RFC3325-9-5_P-Preferred-Identity',
              'S.RFC3325-9-6_P-Preferred-Identity',
              'S.RFC3325-9-7_P-Preferred-Identity',
              'S.R-URI-USER_PHONE_NUMBER',
              'S.R-URI-USER_PREFIX_184_NOTEXIST',
              'S.TO-URI_R-URI',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_EXIST',
            ],
 },

 # 
 {
   'TY:' => 'RULESET',
   'ID:' => 'SSet.CLIP_METHOD2',
   'SP:' => 'TTC',
   'RR:' => [
              'S.RFC3323-4-1_headers',
              'S.RFC3325-9-5_P-Preferred-Identity',
              'S.RFC3325-9-6_P-Preferred-Identity',
              'S.RFC3325-9-7_P-Preferred-Identity',
              'S.R-URI-USER_PHONE_NUMBER',
              'S.R-URI-USER_PREFIX_186_EXIST',
              'S.TO-URI_R-URI',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_NONE',
            ],
 },

 # 
 {
   'TY:' => 'RULESET',
   'ID:' => 'SSet.CLIR_METHOD2',
   'SP:' => 'TTC',
   'RR:' => [
              'S.RFC3323-4-1_headers',
              'S.RFC3323-4-5_From',
              'S.RFC3323-4-6_From',
              'S.RFC3325-9-5_P-Preferred-Identity',
              'S.RFC3325-9-6_P-Preferred-Identity',
              'S.RFC3325-9-7_P-Preferred-Identity',
              'S.R-URI-USER_PHONE_NUMBER',
              'S.R-URI-USER_PREFIX_184_EXIST',
              'S.TO-URI_R-URI',
              'S.PRIVACY_EXIST',
              'S.PRIVACY_VALUE_ID',
              'S.P-PREF-ID_EXIST',
            ],
 },

 # 
 {
   'TY:' => 'RULESET',
   'ID:' => 'SSet.CLIP_METHOD3',
   'SP:' => 'TTC',
   'RR:' => [
              'S.RFC3323-4-1_headers',
              'S.R-URI-USER_PHONE_NUMBER',
              'S.R-URI-USER_PREFIX_186_EXIST',
              'S.TO-URI_R-URI',
              'S.PRIVACY_NOTEXIST',
              'S.P-PREF-ID_NOTEXIST',
            ],
 },

 # 
 {
   'TY:' => 'RULESET',
   'ID:' => 'SSet.CLIR_METHOD3',
   'SP:' => 'TTC',
   'RR:' => [
              'S.RFC3323-4-1_headers',
              'S.RFC3323-4-5_From',
              'S.RFC3323-4-6_From',
              'S.R-URI-USER_PHONE_NUMBER',
              'S.R-URI-USER_PREFIX_184_EXIST',
              'S.TO-URI_R-URI',
              'S.PRIVACY_NOTEXIST',
              'S.P-PREF-ID_NOTEXIST',
            ],
 },

 # 
 {
   'TY:' => 'RULESET',
   'ID:' => 'SSet.CLIP_METHOD4',
   'SP:' => 'TTC',
   'RR:' => [
              'S.RFC3323-4-1_headers',
              'S.R-URI-USER_PHONE_NUMBER',
              'S.R-URI-USER_PREFIX_186_EXIST',
              'S.TO-URI_R-URI',
              'S.PRIVACY_NOTEXIST',
              'S.P-PREF-ID_NOTEXIST',
            ],
 },

 # 
 {
   'TY:' => 'RULESET',
   'ID:' => 'SSet.CLIR_METHOD4',
   'SP:' => 'TTC',
   'RR:' => [
              'S.RFC3323-4-1_headers',
              'S.R-URI-USER_PHONE_NUMBER',
              'S.R-URI-USER_PREFIX_184_EXIST',
              'S.TO-URI_R-URI',
              'S.PRIVACY_NOTEXIST',
              'S.P-PREF-ID_NOTEXIST',
            ],
 },

 # From: Anonymous
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.FROM_ANONYMOUS-URI_LOCAL-TAG',
   'SP:' => 'TTC',
   'PT:' => HD,
   'NX:' => 'Call-ID',
   'FM:' => 'From: "Anonymous" <sip:anonymous@anonymous.invalid>;tag=%s',
   'AR:' => [$CVA_LOCAL_TAG, ],
 },

 # From: Coin line/payphone
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.FROM_COIN_LINE-URI_LOCAL-TAG',
   'SP:' => 'TTC',
   'PT:' => HD,
   'NX:' => 'Call-ID',
   'FM:' => 'From: "Coin line/payphone" <sip:anonymous@anonymous.invalid>;tag=%s',
   'AR:' => [$CVA_LOCAL_TAG, ],
 },

 # From: Interaction with other service
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.FROM_INTERACTION-URI_LOCAL-TAG',
   'SP:' => 'TTC',
   'PT:' => HD,
   'NX:' => 'Call-ID',
   'FM:' => 'From: "Interaction with other service" <sip:anonymous@anonymous.invalid>;tag=%s',
   'AR:' => [$CVA_LOCAL_TAG, ],
 },

 # From: Unavailable
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.FROM_UNAVAILABLE-URI_LOCAL-TAG',
   'SP:' => 'TTC',
   'PT:' => HD,
   'NX:' => 'Call-ID',
   'FM:' => 'From: "Unavailable" <sip:anonymous@anonymous.invalid>;tag=%s',
   'AR:' => [$CVA_LOCAL_TAG, ],
 },

 # From: unknown
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.FROM_UNKNOWN-URI_LOCAL-TAG',
   'SP:' => 'TTC',
   'PT:' => HD,
   'NX:' => 'Call-ID',
   'FM:' => 'From: "unknown" <sip:anonymous@anonymous.invalid>;tag=%s',
   'AR:' => [$CVA_LOCAL_TAG, ],
 },

 # To: URI=TUA NOTAG (184)
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.TO_TUA-URI_NO-TAG_184',
   'SP:' => 'TTC',
   'PT:' => HD,
   'NX:' => 'From',
   'FM:' => 'To: "184%s" <%s:184%s@%s>',
   'AR:' => [
              $CNT_CONF{'UA-USER'},
              \q{($SIP_PL_TRNS eq "TLS") ? "sips" : "sip"},
              $CNT_CONF{'UA-USER'},
              $CNT_CONF{'UA-HOSTNAME'},
            ],
 },

 # To: URI=TUA NOTAG (186)
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.TO_TUA-URI_NO-TAG_186',
   'SP:' => 'TTC',
   'PT:' => HD,
   'NX:' => 'From',
   'FM:' => 'To: "186%s" <%s:186%s@%s>',
   'AR:' => [
              $CNT_CONF{'UA-USER'},
              \q{($SIP_PL_TRNS eq "TLS") ? "sips" : "sip"},
              $CNT_CONF{'UA-USER'},
              $CNT_CONF{'UA-HOSTNAME'},
            ],
 },

 # Privacy: 
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.PRIVACY_NONE',
   'SP:' => 'TTC',
   'PT:' => HD,
   'FM:' => 'Privacy: none',
 },

 # Privacy: 
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.PRIVACY_ID',
   'SP:' => 'TTC',
   'PT:' => HD,
   'FM:' => 'Privacy: id',
 },

 # P-Asserted-Identity: sip(/sips/TLS) URI
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.P-ASSERTED-IDENTITY_SIP',
   'SP:' => 'TTC',
   'PT:' => HD,
   'FM:' => 'P-Asserted-Identity: "%s" <%s>',
   'AR:' => [$CNT_CONF{'PUA-USER'}, $CVA_PUA_URI,],
 },

 # P-Asserted-Identity: tel URI
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.P-ASSERTED-IDENTITY_TEL',
   'SP:' => 'TTC',
   'PT:' => HD,
   'FM:' => 'P-Asserted-Identity: "%s" <tel:%s>',
   'AR:' => [$CNT_CONF{'PUA-USER'}, $CNT_CONF{'PUA-USER'},],
 },

 # P-Asserted-Identity: tel URI
 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.P-ASSERTED-IDENTITY_TEL-E164-81',
   'SP:' => 'TTC',
   'PT:' => HD,
   'FM:' => 'P-Asserted-Identity: "%s" <tel:%s>',
   'AR:' => [
              sub {
                      my $phoneNumber = $CNT_CONF{'PUA-USER'};
                      if ($phoneNumber =~ /^010/) {
                          $phoneNumber =~ s/^010/+/;
                      }
                      elsif ($phoneNumber =~ /^0/) {
                          $phoneNumber =~ s/^0/+81/;
                      }
                      return $phoneNumber;
                  },
              sub {
                      my $phoneNumber = $CNT_CONF{'PUA-USER'};
                      if ($phoneNumber =~ /^010/) {
                          $phoneNumber =~ s/^010/+/;
                      }
                      elsif ($phoneNumber =~ /^0/) {
                          $phoneNumber =~ s/^0/+81/;
                      }
                      return $phoneNumber;
                  },
            ],
 },

#=============================================================================
# JJ90.24 SIP
#  TTC
#    
#      255byte
#    
#      
#  IETF
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.HEADERS_LEN-MAXIMUM',
   'SP:' => 'TTC',
   'CA:' => 'Header',
   'OK:' => "The length of each header line must be less than or equal to $CNT_TTC_HEADER_LEN bytes.",
   'NG:' => "The length of each header line must be less than or equal to $CNT_TTC_HEADER_LEN bytes. There are one or more header lines exceeding this limit.",
   'EX:' => \q{!grep{$CNT_TTC_HEADER_LEN<length($_)} split(/\r\n/,FV('header_txt', @_))},
 },

#=============================================================================
# JJ90.24 Via
#  TTC
#    
#      -
#    
#      
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.VIA_SEND_EQUALS',
   'SP:' => 'TTC',
   'CA:' => 'Via',
   'OK:' => \\'The Via headers(%s) MUST equal those(%s) in the request(except received parameter of 1st Via).',
   'NG:' => \\'The Via headers(%s) MUST equal those(%s) in the request(except received parameter of 1st Via).',
   'PR:' => \'FFIsExistHeader("Via", @_)',
   'EX:' => sub {
                    my ($rule, $pktinfo, $context) = @_;
                    my $sndVia;
                    my $rcvVia;
                    my $sndViaNum;
                    my $rcvViaNum;

                    $sndVia = FVib('send', '', '', 'HD.Via.val.txt', 'RQ.Status-Line.txt', '');
                    $sndViaNum = scalar(@$sndVia);
                    $rcvVia = FVs('HD.Via.val.txt', @_);
                    $rcvViaNum = scalar(@$rcvVia);

                    $context->{'RESULT-DETAIL:'} = {
                                                     'TY:' => '2op',
                                                     'OP:' => 'via',
                                                     'ARG1:' => $rcvVia,
                                                     'ARG2:' => $sndVia,
                                                   };

                    if ($sndViaNum != $rcvViaNum) {
                        return '';
                    }
                    for ($i = 0; $i < $sndViaNum; ++$i) {
                        if (!OpViaMachLine($sndVia->[$i], $rcvVia->[$i], $i)) {
                            return '';
                        }
                    }
                    return 'MATCH';
                },
 },

 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.VIA-BRANCH_SEND_EQUALS',
   'SP:' => 'TTC',
   'CA:' => 'Via',
   'OK:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
   'NG:' => \\'The Via branch value(%s) MUST equal the Via branch(%s) which Tester has sent last time.',
   'PR:' => \'FFIsExistHeader("Via", @_)',
   'EX:' => \q{
                  FFop('EQ',
                       FVs('HD.Via.val.via.param.branch=', @_),
                       FVib('send', '', '', 'HD.Via.val.via.param.branch=', 'RQ.Status-Line.txt', ''),
                       @_)
              },
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.VIA_10HOP',
   'SP:' => 'TTC',
   'PT:' => HD,
   'NX:' => 'Max-Forwards',
   'FM:' => 'Via: SIP/2.0/%s %s',
   'AR:' => [
              $SIP_PL_TRNS,
              sub {
                      ++$CVA_COUNT_BRANCH;
                      $VIAS_10HOP_PORT = ($SIP_PL_TRNS eq "TLS") ? "5061" : "5060";
                      if ($SIP_PL_IP eq '6') {
                          $VIAS_10HOP_A_IP = "3ffe:501:ffff:51::50";
                          $VIAS_10HOP_B_IP = "3ffe:501:ffff:52::50";
                          $VIAS_10HOP_C_IP = "3ffe:501:ffff:53::50";
                          $VIAS_10HOP_D_IP = "3ffe:501:ffff:54::50";
                          $VIAS_10HOP_E_IP = "3ffe:501:ffff:55::50";
                          $VIAS_10HOP_F_IP = "3ffe:501:ffff:56::50";
                          $VIAS_10HOP_G_IP = "3ffe:501:ffff:57::50";
                      }
                      else {
                          $VIAS_10HOP_A_IP = "192.1.50.50";
                          $VIAS_10HOP_B_IP = "192.2.50.50";
                          $VIAS_10HOP_C_IP = "192.3.50.50";
                          $VIAS_10HOP_D_IP = "192.4.50.50";
                          $VIAS_10HOP_E_IP = "192.5.50.50";
                          $VIAS_10HOP_F_IP = "192.6.50.50";
                          $VIAS_10HOP_G_IP = "192.7.50.50";
                      }
                      @VIAS_10HOP = ("$CNT_PX1_HOSTPORT;branch=z9hG4bKp$CVA_COUNT_BRANCH",
                                     "a.com:$VIAS_10HOP_PORT;branch=z9hG4bKa$CVA_COUNT_BRANCH;received=$VIAS_10HOP_A_IP",
                                     "b.com:$VIAS_10HOP_PORT;branch=z9hG4bKb$CVA_COUNT_BRANCH;received=$VIAS_10HOP_B_IP",
                                     "c.com:$VIAS_10HOP_PORT;branch=z9hG4bKc$CVA_COUNT_BRANCH;received=$VIAS_10HOP_C_IP",
                                     "d.com:$VIAS_10HOP_PORT;branch=z9hG4bKd$CVA_COUNT_BRANCH;received=$VIAS_10HOP_D_IP",
                                     "e.com:$VIAS_10HOP_PORT;branch=z9hG4bKe$CVA_COUNT_BRANCH;received=$VIAS_10HOP_E_IP",
                                     "f.com:$VIAS_10HOP_PORT;branch=z9hG4bKf$CVA_COUNT_BRANCH;received=$VIAS_10HOP_F_IP",
                                     "g.com:$VIAS_10HOP_PORT;branch=z9hG4bKg$CVA_COUNT_BRANCH;received=$VIAS_10HOP_G_IP",
                                     "$CNT_PX2_HOSTPORT;branch=z9hG4bKh$CVA_COUNT_BRANCH;received=$CVA_PX2_IPADDRESS",
                                     "$CNT_PUA_HOSTPORT;branch=z9hG4bKu$CVA_COUNT_BRANCH;received=$CVA_PUA_IPADDRESS");
                      return join("\r\nVia: SIP/2.0/$SIP_PL_TRNS ", @VIAS_10HOP);
                  },
            ],
 },

#=============================================================================
# JJ90.24 Via-branch
#  TTC
#    
#      z9hG4bK
#    
#      
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.VIA-BRANCH_LEN-MAXIMUM',
   'SP:' => 'TTC',
   'CA:' => 'Via',
   'OK:' => "The length of branch ID(excluding \'z9hG4bK\') must be less than or equal to $CNT_TTC_VIA_BRANCH_LEN bytes.",
   'NG:' => "The length of branch ID(excluding \'z9hG4bK\') must be less than or equal to $CNT_TTC_VIA_BRANCH_LEN bytes.",
   'PR:' => \q{FV('HD.Via.val.via.param.branch=', @_) ne ''},
   'EX:' => sub {
                    my $viaBranch;
                    my $branchLen;
                    $viaBranch = FV('HD.Via.val.via.param.branch=', @_);
                    $branchLen = length($viaBranch);
                    if (substr($viaBranch, 0, 7) eq "z9hG4bK") {
                        if ($branchLen - 7 > $CNT_TTC_VIA_BRANCH_LEN) {
                            return '';
                        }
                    }
                    else {
                        if ($branchLen > $CNT_TTC_VIA_BRANCH_LEN) {
                            return '';
                        }
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 To/From tag
#  TTC
#    
#      
#    
#      
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.FROM-TAG_LEN-MAXIMUM',
   'SP:' => 'TTC',
   'CA:' => 'From',
   'OK:' => "The length of from tag must be less than or equal to $CNT_TTC_TAG_LEN bytes.",
   'NG:' => "The length of from tag must be less than or equal to $CNT_TTC_TAG_LEN bytes.",
   'PR:' => sub {
                    my $curFromTag;
                    my $curTo;
                    my $curCallID;
                    my $ret;
                    $curFromTag = FV('HD.From.val.param.tag', @_);
                    if ($curFromTag eq '') {
                        return '';
                    }
                    if (FV('HD.To.val.param.tag', @_) ne '') {
                        return '';
                    }
                    $curTo = FV('HD.To.val.ad.ad.txt', @_);
                    $curCallID = FV('HD.Call-ID.val.txt', @_);
                    $ret = FVib('recv', -1, '', '',
                                'RQ.Status-Line.txt', '',
                                'HD.From.val.param.tag', $curFromTag,
                                'HD.To.val.ad.ad.txt', $curTo,
                                'HD.Call-ID.val.txt', $curCallID);
                    if ($ret ne '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => \q{FFop('<=', length(FV('HD.From.val.param.tag', @_)), $CNT_TTC_TAG_LEN, @_)},
 },

 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.TO-TAG_LEN-MAXIMUM',
   'SP:' => 'TTC',
   'CA:' => 'To',
   'OK:' => "The length of to tag must be less than or equal to $CNT_TTC_TAG_LEN bytes.",
   'NG:' => "The length of to tag must be less than or equal to $CNT_TTC_TAG_LEN bytes.",
   'PR:' => sub {
                    my $curCallID;
                    my $ret;
                    if (FV('HD.To.val.param.tag', @_) eq '') {
                        return '';
                    }
                    $curCallID = FV('HD.Call-ID.val.txt', @_);
                    $ret = FVib('recv', -1, '', '',
                                'HD.Call-ID.val.txt', $curCallID);
                    if ($ret ne '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => \q{FFop('<=', length(FV('HD.To.val.param.tag', @_)), $CNT_TTC_TAG_LEN, @_)},
 },

#=============================================================================
# JJ90.24 Call-ID
#  TTC
#    
#      
#    
#      
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.CALLID_LEN-MAXIMUM',
   'SP:' => 'TTC',
   'CA:' => 'Call-ID',
   'OK:' => "The length of Call-ID must be less than or equal to $CNT_TTC_CALLID_LEN bytes.",
   'NG:' => "The length of Call-ID must be less than or equal to $CNT_TTC_CALLID_LEN bytes.",
   'PR:' => sub {
                    my $curFromTag;
                    my $curTo;
                    my $curCallID;
                    my $ret;
                    $curCallID = FV('HD.Call-ID.val.txt', @_);
                    if ($curCallID eq '') {
                        return '';
                    }
                    if (FV('HD.To.val.param.tag', @_) ne '') {
                        return '';
                    }
                    $curFromTag = FV('HD.From.val.param.tag', @_);
                    $curTo = FV('HD.To.val.ad.ad.txt', @_);
                    $ret = FVib('recv', -1, '', '',
                                'RQ.Status-Line.txt', '',
                                'HD.From.val.param.tag', $curFromTag,
                                'HD.To.val.ad.ad.txt', $curTo,
                                'HD.Call-ID.val.txt', $curCallID);
                    if ($ret ne '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => \q{FFop('<=', length(FV('HD.Call-ID.val.txt', @_)), $CNT_TTC_CALLID_LEN, @_)},
 },

#=============================================================================
# JJ90.24 CSeq
#  TTC
#    
#      
#    
#      
#  RFC3261
#    2**31
#    32
 { 'TY:' => 'SYNTAX',
   'ID:' => 'S.CSEQ-SEQNO_RANGE',
   'SP:' => 'TTC',
   'CA:' => 'CSeq',
   'OK:' => \\'The first sequence number value must be range 1 to $CNT_TTC_CSEQ_NUM_MAX.',
   'NG:' => \\'The first sequence number value must be range 1 to $CNT_TTC_CSEQ_NUM_MAX.',
   'PR:' => sub {
                    my $curFromTag;
                    my $curTo;
                    my $curCallID;
                    my $ret;
                    if (!FFIsExistHeader("CSeq", @_)) {
                        return '';
                    }
                    $curFromTag = FV('HD.From.val.param.tag', @_);
                    $curTo = FV('HD.To.val.ad.ad.txt', @_);
                    $curCallID = FV('HD.Call-ID.val.txt', @_);
                    $ret = FVib('recv', -1, '', '',
                                'RQ.Status-Line.txt', '',
                                'HD.From.val.param.tag', $curFromTag,
                                'HD.To.val.ad.ad.txt', $curTo,
                                'HD.Call-ID.val.txt', $curCallID);
                    if ($ret ne '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => sub {
                    my $csno;
                    $csno = FV('HD.CSeq.val.csno', @_);
                    if ($csno < 1 || $csno > $CNT_TTC_CSEQ_NUM_MAX) {
                        return '';
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 RSeq
#  TTC
#    
#      
#    
#      
#  RFC3262
#    2**31
#    32
 { 'TY:' => 'SYNTAX',
   'ID:' => 'S.RSEQ-SEQNO_RANGE',
   'SP:' => 'TTC',
   'CA:' => 'RSeq',
   'OK:' => \\'The RSeq value must be range 1 to $CNT_TTC_RSEQ_NUM_MAX.',
   'NG:' => \\'The RSeq value must be range 1 to $CNT_TTC_RSEQ_NUM_MAX.',
   'PR:' => \'FFIsExistHeader("RSeq", @_)',
   'EX:' => sub {
                    my $responsenum;
                    $responsenum = FV('HD.RSeq.val.responsenum', @_);
                    if ($responsenum < 1 || $responsenum > $CNT_TTC_RSEQ_NUM_MAX) {
                        return '';
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 remote target
#  TTC
#    
#      user
#      
#    
#      
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.CONTACT-URI-USER_LEN-MAXIMUM',
   'SP:' => 'TTC',
   'CA:' => 'Contact',
   'OK:' => "The length of userinfo in Contact URI must be less than or equal to $CNT_TTC_CONTACT_URI_USR_LEN bytes.",
   'NG:' => "The length of userinfo in Contact URI must be less than or equal to $CNT_TTC_CONTACT_URI_USR_LEN bytes. There are one or more header lines exceeding this limit.",
   'PR:' => \'FFIsExistHeader("Contact", @_)',
   'EX:' => \q{!grep{$CNT_TTC_CONTACT_URI_USR_LEN<length($_)} @{FVs('HD.Contact.val.contact.ad.ad.userinfo',@_)}},
 },

 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.CONTACT-URI_LEN-MAXIMUM',
   'SP:' => 'TTC',
   'CA:' => 'Contact',
   'OK:' => "The length of Contact URI must be less than or equal to $CNT_TTC_CONTACT_URI_LEN bytes.",
   'NG:' => "The length of Contact URI must be less than or equal to $CNT_TTC_CONTACT_URI_LEN bytes. There are one or more header lines exceeding this limit.",
   'PR:' => \'FFIsExistHeader("Contact", @_)',
   'EX:' => \q{!grep{$CNT_TTC_CONTACT_URI_LEN<length($_)} @{FVs('HD.Contact.val.contact.ad.ad.txt',@_)}},
 },

#=============================================================================
# JJ90.24 SDP o=
#  TTC
#    
#      
#    
#      
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.O-USERNAME_LEN-MAXIMUM',
   'SP:' => 'TTC',
   'CA:' => 'o=',
   'OK:' => "The length of username of o line in SDP must be less than or equal to $CNT_TTC_SDP_O_USERNAME_LEN bytes.",
   'NG:' => "The length of username of o line in SDP must be less than or equal to $CNT_TTC_SDP_O_USERNAME_LEN bytes.",
   'PR:' => \'FFIsExistHeader("o=", @_)',
   'EX:' => sub {
                    my($val);
                    $val = FFGetIndexValSeparateDelimiter(\\'BD.o=.txt', 0, ' ', @_);
                    if (length($val) > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                        return '';
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 SDP o=
#  TTC
#    
#      
#    
#      
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.O-SESSIONID_RANGE',
   'SP:' => 'TTC',
   'CA:' => 'o=',
   'OK:' => "The first session id of o line in SDP must be less than or equal to $CNT_TTC_SDP_O_SESSIONID_MAX.",
   'NG:' => "The first session id of o line in SDP must be less than or equal to $CNT_TTC_SDP_O_SESSIONID_MAX.",
   'PR:' => sub {
                    my $curCallID;
                    my $ret;
                    if (!FFIsExistHeader("o=", @_)) {
                        return '';
                    }
                    $curCallID = FV('HD.Call-ID.val.txt', @_);
                    $ret = FVib('recv', -1, '', '',
                                'HD.Call-ID.val.txt', $curCallID,
                                'BD.txt', \q{$val});
                    if ($ret ne '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => sub {
                    my($val);
                    $val = FFGetIndexValSeparateDelimiter(\\'BD.o=.txt', 1, ' ', @_);
                    if ($val > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                        return '';
                    }
                    return 'ok';
                },
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY_VALID',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n" .
                  "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n" .
                  "a=rtpmap:0 PCMU/8000"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
            ],
 },

 {
   'TY:' => 'ENCODE',
   'ID:' => 'E.BODY.MEDIA-DESCRIPTION',
   'SP:' => 'TTC',
   'PT:' => BD,
   'FM:' => \q{
                  "v=0\r\n" .
                  "o=- %s %s IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "s=-\r\n" .
                  "c=IN IP$SIP_PL_IP " . $CVA_PUA_IPADDRESS . "\r\n" .
                  "t=0 0\r\n" .
                  "%s"
              },
   'AR:' => [
                sub {
                        if ($CNT_PUA_SDP_O_SESSION > $CNT_PUA_SDP_O_VERSION) {
                            if ($CNT_PUA_SDP_O_SESSION > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                                $CNT_PUA_SDP_O_SESSION = $CNT_PUA_SDP_O_SESSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                                $CNT_PUA_SDP_O_VERSION = $CNT_PUA_SDP_O_VERSION % $CNT_TTC_SDP_O_SESSIONID_MAX;
                            }
                        }
                        return $CNT_PUA_SDP_O_SESSION;
                    },
                sub {
                        ++$CNT_PUA_SDP_O_VERSION;
                        return $CNT_PUA_SDP_O_VERSION;
                    },
                sub {
                        my($msg);
                        $msg.=JoinKeyValue("%s",FVs('BD.m=.val',@_),'txt');
                        $msg=~ s/^c=.*(?:\r\n|\Z)//mg;
                        $msg=~ s/sendonly/recvonly/mg;
                        $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $CNT_PORT_CHANGE_RTP/img;
                        $msg=~ s/\r\n$//;return $msg;
                    },
            ],
 },

#=============================================================================
# JJ90.24 SDP o=
#  TTC
#    
#      
#    
#      
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.O-VERSION_RANGE',
   'SP:' => 'TTC',
   'CA:' => 'o=',
   'OK:' => "The first version of o line in SDP must be less than or equal to $CNT_TTC_SDP_O_SESSIONID_MAX.",
   'NG:' => "The first version of o line in SDP must be less than or equal to $CNT_TTC_SDP_O_SESSIONID_MAX.",
   'PR:' => sub {
                    my $curCallID;
                    my $ret;
                    if (!FFIsExistHeader("o=", @_)) {
                        return '';
                    }
                    $curCallID = FV('HD.Call-ID.val.txt', @_);
                    $ret = FVib('recv', -1, '', '',
                                'HD.Call-ID.val.txt', $curCallID,
                                'BD.txt', \q{$val});
                    if ($ret ne '') {
                        return '';
                    }
                    return 'exec';
                },
   'EX:' => sub {
                    my($val);
                    $val = FFGetIndexValSeparateDelimiter(\\'BD.o=.txt', 2, ' ', @_);
                    if ($val > $CNT_TTC_SDP_O_SESSIONID_MAX) {
                        return '';
                    }
                    return 'ok';
                },
 },

#=============================================================================
# JJ90.24 SDP s=
#  TTC
#    
#      
#    
#      
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.SDP.S_LEN-MAXIMUM',
   'SP:' => 'TTC',
   'CA:' => 's=',
   'OK:' => "The length of session name of s line in SDP must be less than or equal to $CNT_TTC_SDP_S_SESSIONNAME_LEN bytes.",
   'NG:' => "The length of session name of s line in SDP must be less than or equal to $CNT_TTC_SDP_S_SESSIONNAME_LEN bytes.",
   'PR:' => \'FFIsExistHeader("s=", @_)',
   'EX:' => \q{FFop('<=', length(FV('BD.s=.txt', @_)), $CNT_TTC_SDP_S_SESSIONNAME_LEN, @_)},
 },

#=============================================================================
# JJ90.24 Initial-INVITE
#  TTC
#    
#  RFC3261
#    TCP
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.CNTLENGTH_EXIST-INITIAL_INVITE',
   'SP:' => 'TTC',
   'CA:' => 'Content-Length',
   'OK:' => "Initial-INVITE must be setting Content-Length header.",
   'NG:' => "Initial-INVITE must be setting Content-Length header.",
   'PR:' => \q{FV('HD.To.val.param.tag', @_) eq ''},
   'EX:' => \q{FFIsExistHeader("Content-Length", @_)},
 },

#=============================================================================
# JJ90.24 Initial-INVITE
#  TTC
#    
#  IETF
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.P-REQUIRE_NOEXIST-INITIAL_INVITE',
   'SP:' => 'TTC',
   'CA:' => 'Proxy-Require',
   'OK:' => "The Proxy-Require header must not be used in Initial-INVITE.",
   'NG:' => "The Proxy-Require header must not be used in Initial-INVITE.",
   'PR:' => \q{FV('HD.To.val.param.tag', @_) eq ''},
   'EX:' => \q{!FFIsExistHeader("Proxy-Require", @_)},
 },

#=============================================================================
# JJ90.24 Initial-INVITE
#  TTC
#    
#  IETF
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.REQUIRE_NOEXIST-INITIAL_INVITE',
   'SP:' => 'TTC',
   'CA:' => 'Require',
   'OK:' => "The Require header must not be used in Initial-INVITE.",
   'NG:' => "The Require header must not be used in Initial-INVITE.",
   'PR:' => \q{FV('HD.To.val.param.tag', @_) eq ''},
   'EX:' => \q{!FFIsExistHeader("Require", @_)},
 },

#=============================================================================
# JJ90.24 Initial-INVITE
#  TTC
#    
#  RFC3261
#    
 {
   'TY:' => 'SYNTAX',
   'ID:' => 'S.ROUTE_NOEXIST-INITIAL_INVITE',
   'SP:' => 'TTC',
   'CA:' => 'Route',
   'OK:' => "A Route header field must not be used in Initial-INVITE.",
   'NG:' => "A Route header field must not be used in Initial-INVITE.",
   'PR:' => \q{FV('HD.To.val.param.tag', @_) eq ''},
   'EX:' => \q{!FFIsExistHeader("Route", @_)},
 },



##############################################################################
# 

 # 
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.ALLMesg',
   'SP:' => 'TTC',
   'RR:' => [
              'S.TAG-PRIORITY',
              'S.HEADERS_LEN-MAXIMUM',          # add TTC
              'S.VIA_EXIST',
              'S.VIA-BRANCH_z9hG4bK',
              'S.VIA_NOTIPADDRESS',
              'S.VIA-BRANCH_EXIST',
              'S.VIA-BRANCH_LEN-MAXIMUM',       # add TTC
              'S.FROM_EXIST',
              'S.FROM_QUOTE',
              'S.TO_EXIST',
              'S.TO_QUOTE',
              'S.CALLID_EXIST',
              'S.CONTACT-URI-USER_LEN-MAXIMUM', # add TTC
              'S.CONTACT-URI_LEN-MAXIMUM',      # add TTC
              'S.CSEQ_EXIST',
              'S.CSEQ-SEQNO_32BIT',
              'S.CNTLENGTH_EXISTandBODY',
              'S.CNTLENGTH_NOBODY_0',
              'S.CNTTYPE_VALID',
              'S.CNTTYPE_APP-SDP',
#              'S.PORT-SIGNAL_DEFAULTS',
            ],
 },

 # SDP
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.SDP',
   'SP:' => 'TTC',
   'RR:' => [
              'S.SDP.TAG_PRIORITY',
              'S.SDP.TAG-ONE_LINE-EXIST',
              'S.SDP.V_EQUAL-ZERO',
              'S.SDP.O-IN_VALID',
              'S.SDP.O-IP_VALID',
              'S.SDP.O-ADDR_TAG-ADDR',
              'S.SDP.O-SESSIONID_64BIT',
              'S.SDP.O-VERSION_64BIT',
              'S.SDP.O-USERNAME_LEN-MAXIMUM', # add TTC
              'S.SDP.O-SESSIONID_RANGE',      # add TTC
              'S.SDP.O-VERSION_RANGE',        # add TTC
              'S.SDP.S_VALID',
              'S.SDP.S_LEN-MAXIMUM',          # add TTC
              'S.SDP.C-IN_VALID',
              'S.SDP.C-IP_VALID',
              'S.SDP.C-CONNECTADDR_TARGET',
              'S.SDP.T_VALID',
              'S.SDP.M_EXIST',
              'S.SDP.M-MEDIA_AUDIO',          # add TTC
              'S.SDP.M-MEDIA-CODEC_G711U',    # add TTC
              'S.SDP.A-PTIME_VALID',
              'S.SDP.A-RTPMAP-G711U_0',       # add TTC
            ],
 },

 # Digest
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.DigestAuth.NOPX',
   'SP:' => 'TTC',
   'RR:' => [
              'S.AUTHORIZ.DIGEST',
              'S.AUTHORIZ-NC.EXIST',
              'S.AUTHORIZ-NONCE.EXIST',
              'S.AUTHORIZ-NONCE.REQ-NONCE',
              'S.AUTHORIZ-REALM.EXIST',
              'S.AUTHORIZ-REALM.REQ-REALM',
              'S.AUTHORIZ-RESPONSE.EXIST',
              'S.AUTHORIZ-RESPONSE.CALCULATE',
              'S.AUTHORIZ-URI.EXIST',
              'S.AUTHORIZ-URI.DQUOT',
              'S.AUTHORIZ-CNONCE.EXIST',
              'S.AUTHORIZ-USERNAME.EXIST',
              'S.AUTHORIZ-USERNAME_CONFIG',
              'S.AUTHORIZ-qop.Auth',
##            'S.AUTHORIZ.HEADER_MUSTNOT-CONCAT',
              'S.AUTHORIZ-ALGORITHM.MD5',         # add TTC
           ],
 },

 # Digest
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.DigestNoQop.NOPX',
   'SP:' => 'TTC',
   'RR:' => [
              'S.AUTHORIZ.DIGEST',
              'S.AUTHORIZ-NONCE.EXIST',
              'S.AUTHORIZ-NONCE.REQ-NONCE',
              'S.AUTHORIZ-REALM.EXIST',
              'S.AUTHORIZ-REALM.REQ-REALM',
              'S.AUTHORIZ-RESPONSE.EXIST',
              'S.AUTHORIZ-URI.EXIST',
              'S.AUTHORIZ-URI.DQUOT',
              'S.AUTHORIZ-USERNAME.EXIST',
              'S.AUTHORIZ-USERNAME_CONFIG',
##            'S.AUTHORIZ.HEADER_MUSTNOT-CONCAT',
              'S.AUTHORIZ-RESPONSE-NOQOP.CALCULATE',
              'S.AUTHORIZ-QOP.NOT_EXIST',            # add TTC
              'S.AUTHORIZ-ALGORITHM.MD5',            # add TTC
           ],
 },

 # Digest
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.DigestAuth.PX',
   'SP:' => 'TTC',
   'RR:' => [
              'S.P-AUTH.DIGEST',
              'S.P-AUTH-NC.EXIST',
              'S.P-AUTH-NONCE.EXIST',
              'S.P-AUTH-NONCE.REQ-NONCE',
              'S.P-AUTH-REALM.EXIST',
              'S.P-AUTH-REALM.REQ-REALM',
              'S.P-AUTH-RESPONSE.EXIST',
              'S.P-AUTH-RESPONSE.CALCULATE',
              'S.P-AUTH-URI.EXIST',
              'S.P-AUTH-URI.DQUOT',
              'S.P-AUTH-CNONCE.EXIST',
              'S.P-AUTH-USERNAME.EXIST',
              'S.P-AUTH-USERNAME_CONFIG',
              'S.P-AUTH-qop.Auth',
##            'S.P-AUTH.HEADER_MUSTNOT-CONCAT',
              'S.P-AUTH-ALGORITHM.MD5',         # add TTC
           ],
 },

 # Digest
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.DigestNoQop.PX',
   'SP:' => 'TTC',
   'RR:' => [
              'S.P-AUTH.DIGEST',
              'S.P-AUTH-NONCE.EXIST',
              'S.P-AUTH-NONCE.REQ-NONCE',
              'S.P-AUTH-REALM.EXIST',
              'S.P-AUTH-REALM.REQ-REALM',
              'S.P-AUTH-RESPONSE.EXIST',
              'S.P-AUTH-URI.EXIST',
              'S.P-AUTH-URI.DQUOT',
              'S.P-AUTH-USERNAME.EXIST',
              'S.P-AUTH-USERNAME_CONFIG',
##            'S.P-AUTH.HEADER_MUSTNOT-CONCAT',
              'S.P-AUTH-RESPONSE-NOQOP.CALCULATE',
              'S.P-AUTH-QOP.NOT_EXIST',            # add TTC
              'S.P-AUTH-ALGORITHM.MD5',            # add TTC
           ],
 }, 

 # %% RSeq check rule set. %%
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.RSEQ',
   'SP:' => 'TTC',
   'RR:' => [
              'S.RSEQ_EXIST',
              'S.RSEQ-SEQNO_32BIT',
              'S.RSEQ-SEQNO_RANGE',                    # add TTC
              'S.RSEQ-SEQNO-REQ-RSEQ-SEQNO_INCREMENT',
            ],
 },

 # 
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.ReqMesg',
   'SP:' => 'TTC',
   'RR:' => [
              'SSet.ALLMesg',
##            'S.VIA-URI_HOSTNAME',
              'S.VIA-TRANSPORT_UDP',
              'S.R-URI_NOQUOTE',
              'S.R-LINE_VERSION',
              'S.MAX-FORWARDS_EXIST',
              'S.MAX-FORWARDS',
              'S.FROM-TAG_EXIST',
              'S.FROM-TAG_LEN-MAXIMUM',       # add TTC
              'S.CALLID_LEN-MAXIMUM',         # add TTC
              'S.CSEQ-METHOD_REQLINE-METHOD',
              'S.CSEQ-SEQNO_RANGE',           # add TTC
##            'S.RFC3261-12-21_Contact',      # TLS dependent
##            'S.REQUIRE-TAG_OPTION',
##            'S.P-REQUIRE-TAG_OPTION',
            ],
 },

 # 
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.ResMesg',
   'SP:' => 'TTC',
   'RR:' => [
              'SSet.ALLMesg',
              'S.FROM-URI_LOCAL-URI',
              'S.FROM-TAG_LOCAL-TAG',
              'S.TO-URI_REMOTE-URI',
              'S.TO-TAG_LEN-MAXIMUM',    # add TTC
              'S.CALLID_VALID',
              'S.CSEQ-SEQNO_SEND-SEQNO',
              'S.RSEQ-SEQNO_RANGE',      # add TTC
              'S.RFC3261-12-6_Contact',  # TLS dependent
            ],
 },

 # REGISTER
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.REGISTER',
   'SP:' => 'TTC',
   'RR:' => [
              'SSet.ReqMesg',
              'SSet.URICompMsgRG',
              'S.MUSTNOT-HEADER_REGISTER',
              'S.R-URI_NOUSERINFO',
              'S.TO-TAG_NOEXIST',
##            'S.EXPIRES_DECIMAL',
              'S.CONTACT-ACTION_NOEXIST',
              'S.CONTACT-MADDR_NOEXIST',               # add TTC
              'S.CSEQ-METHOD_REGISTER',
              'S.CSEQ-SEQNO-REQ-CSEQ-SEQNO_INCREMENT',
            ],
 },

 # Proxy receives INVITE.
 { 'TY:' => 'RULESET',
   'ID:' => 'SSet.REQUEST.INVITE.PX',
   'SP:' => 'TTC',
   'RR:' => [
              'SSet.INVITE',
              'S.VIA-BRANCH_HISTORY-BRANCH-NOTEXIST',
              'S.TO-TAG_NOEXIST',
              'S.CNTLENGTH_EXIST-INITIAL_INVITE',         # add TTC
              'S.ROUTE_NOEXIST-INITIAL_INVITE',           # add TTC
              'S.REQUIRE_NOEXIST-INITIAL_INVITE',         # add TTC
              'S.P-REQUIRE_NOEXIST-INITIAL_INVITE',       # add TTC
              'S.SDP_EXIST-INITIAL_INVITE',               # add TTC
              'S.SDP.M-LINE_NOTREPEAT-INITIAL_INVITE',    # add TTC
              'S.SDP.M-MEDIA-INTERACTIVE-INITIAL_INVITE', # add TTC
              'S.SDP.A-PTIME_20MSEC-INITIAL_INVITE',      # add TTC
              'D.COMMON.FIELD.REQUEST',
            ],
 },

);

