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


#=================================
# 
#=================================
#use strict;

#=================================
# 
#=================================

$FVSupported = '';
$FVMinSE = '';
$FVExpires = '';
$FVRefresher = '';
$FVRequire = '';
$FVProxyRequire = '';
$FVCallID = '';
$FVTo = '';
$FVFrom = '';
$FVCSeq = '';
$FVAllow = ''; # 20060112 maeda add
$FVBody = '';

$FVSendMsg = '';
$FVSendSupported = '';
$FVSendMinSE = '';
$FVSendExpires = '';
$FVSendRefresher = '';
$FVSendRequire = '';
$FVSendProxyRequire = '';

$FVRecvInvite = 0;
$FVRecv200 = 0;

$FVRecvSupported = '';
$FVRecvRequire = '';
$FVRecvProxyRequire = '';
$FVRecvCallID = '';
$FVRecvTo = '';
$FVRecvFrom = '';
$FVRecvCSeq = '';
$FVRecvBody = '';

#=================================
# 
#=================================

@SIPUAExtendTimerRules =
(

 # DECODE: supported session-expires min-se require proxy-require
 { 'TY:'=>'DECODE', 'ID:'=>'D.SESSION_TIMER',
   'VA:'=>[
            ('HD.Supported.txt', FVSupported),
            ('HD.Min-SE.txt', FVMinSE),
            ('HD.Require.txt', FVRequire),
            ('HD.Proxy-Require.txt', FVProxyRequire),
            ('HD.Call-ID.txt', FVCallID),
            ('HD.To.txt', FVTo),
            ('HD.From.txt', FVFrom),
            ('HD.CSeq.txt', FVCSeq),
            ('HD.Allow.txt', FVAllow), # 20060112 maeda add
            ('BD.txt', FVBody),
            ( sub {
                    my @array;
                    @array = split(';', FV('HD.Session-Expires.txt', @_));
                    $FVExpires = $array[0];
                    $FVRefresher = $array[1];
              } ),
          ]
 },

 # DECODE: invite
 { 'TY:' => 'RULESET', 'ID:' => 'D.INVITE.PX',
   'RR:' => [
              'D.REQUEST',
              'D.STATUS',
              'D.SESSION_TIMER',
            ]  
 },

### 20060112 maeda add start ###
 # DECODE: update
 { 'TY:' => 'RULESET', 'ID:' => 'D.UPDATE.PX',
   'RR:' => [
              'D.REQUEST',
              'D.STATUS',
              'D.SESSION_TIMER',
            ]
 },
### 20060112 maeda add end ###

 # BODY (override)
 { 'TY:'=>'ENCODE', 'ID:'=>'E.BODY_VALID', 'PT:'=>BD,
   'FM:'=> \q{
               "v=0\r\n".
               ### "o=- ".$CNT_PUA_SDP_O_SESSION." ".$CNT_PUA_SDP_O_VERSION.
               "o=- ".$CNT_PUA_SDP_O_SESSION." ".$CNT_PUA_SDP_O_SESSION.
                 " IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS."\r\n".
               "s=-\r\n".
               "c=IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS."\r\n".
               "t=0 0\r\n".
               "m=audio $CNT_PORT_CHANGE_RTP RTP/AVP 0\r\n".  
               "a=rtpmap:0 PCMU/8000"
             },  
 },

 # BODY (override)
 { 'TY:'=>'ENCODE', 'ID:'=>'E.BODY.MEDIA-DESCRIPTION', 'PT:'=>BD,
   'FM:'=> \q{
               "v=0\r\n".
               "o=- ".$CNT_PUA_SDP_O_SESSION." ".$CNT_PUA_SDP_O_SESSION.
                 " IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS."\r\n".
               "s=-\r\n".
               "c=IN IP$SIP_PL_IP ".$CVA_PUA_IPADDRESS."\r\n".
               "t=0 0\r\n%s"
             },
   'AR:'=> [
             sub{ my($msg);
#                  $msg =JoinKeyValue("a=%s\r\n",FVs('BD.m=.val.attr.txt',@_),'txt');
                  $msg.=JoinKeyValue("%s",FVs('BD.m=.val',@_),'txt');
                  $msg=~ s/^c=.*(?:\r\n|\Z)//mg;
                  $msg=~ s/sendonly/recvonly/mg;
                  $msg=~ s/^m=\s*audio\s+[0-9]+/m=audio $CNT_PORT_CHANGE_RTP/img;
                  $msg=~ s/\r\n$//;return $msg;
             }
           ]
 },

 # SUPPORTED VALID (override)
 { 'TY:'=>'ENCODE', 'ID:'=>'E.SUPPORTED_VALID', 'PT:'=>HD,
   'FM:'=>'%s',
   'AR:'=>[
#           \q { SessionTimer_EncodeString() },    # 20050407 usako delete
### 20050407 usako add start ###
            sub {
                  my $str = $CNT_CONF{'UA-SUPPORTED'};
                  if ($str !~ /timer/) {
                    if ($str ne '') { $str .= ","; }
                    $str .= "timer";
                  }
                  SessionTimer_EncodeString($str);
            },
### 20050407 usako add end ###
          ]
 },

### 20050407 usako add start ###
 # SUPPORTED VALID (override)
 { 'TY:'=>'ENCODE', 'ID:'=>'E.RES.SUPPORTED_VALID', 'PT:'=>HD,
   'FM:'=>'%s',
   'AR:'=>[
            \q { SessionTimer_EncodeString(FV('HD.Supported.txt', @_)) },
          ]
 },
### 20050407 usako add end ###

 # ENCODE: MinSE
 { 'TY:'=>'ENCODE', 'ID:'=>'E.MIN-SE', 'PT:'=>HD,
   'FM:'=>'%s',
   'AR:'=>[
            sub { $FVMinSE ne '' ?  "Min-SE: ".$FVMinSE: "" },
          ]
 },

### 20060112 maeda add start ###
 #  ENCODE: ALLOW VALID(INVITE,ACK,CANCEL,OPTIONS,BYE,UPDATE)
 { 'TY:'=>'ENCODE',
   'ID:'=>'E.ALLOW_VALID.PLUS_UPD',
   'PT:'=>HD,
   'FM:'=>'Allow: INVITE,ACK,CANCEL,OPTIONS,BYE,UPDATE'
 },
### 20060112 maeda add end ###


 # SYNTAX: not supported timer (must)
 { 'TY:'=>'SYNTAX', 'ID:'=>'S.SESSION_TIMER_SUPPORTED', 'CA:'=>'Supported',
   'OK:'=>'Exist. You must include the \'timer\' option tag.',
   'NG:'=>'Not exist. You must include the \'timer\' option tag.',
   'RT:'=>"error",
   'PR:'=>\'FFIsExistHeader("Supported", @_)',
   'EX:'=>sub {
                my($ref);
                if(ref($FVSupported) eq 'ARRAY'){
                    if(grep{$_ =~ /timer/i}@$FVSupported){
                          return 'ok';
                    }
                    else{
                          return '';
                    }
                }
                else{
                    if ($FVSupported !~ /timer/i) { return ''; }
                    return 'ok';
                }
          },
 },

 # SYNTAX: supported (must)
 { 'TY:'=>'SYNTAX', 'ID:'=>'S.SESSION_TIMER_CHK_SUPPORTED', 'CA:'=>'Supported',
   'OK:'=>'same before recieved value.',
   'NG:'=>'different before recieved value.',
   'RT:'=>"error",
#   'PR:'=>\q{$FVRecvInvite > 0 ? 'exec': ''}, # 20060120 maeda delete
   'EX:'=>sub {
                if ($FVSupported ne $FVRecvSupported) { return ''; }
                return 'ok';
          },
},

### 20060120 maeda update start ###
 # SYNTAX: exist require (may)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_REQUIRE', 'CA:'=>'Require',
#   'OK:'=>'Exist. You are not recommended to include the \'timer\' option tag.',
#   'NG:'=>'Not exist. You ar not recommended to include the \'timer\' option tag.',
   'OK:'=>'Not exist. You are not recommended to include the \'timer\' option tag.',
   'NG:'=>'Exist. You are not recommended to include the \'timer\' option tag.',
   'RT:'=>"warning",
   'PR:'=>\'FFIsExistHeader("Require", @_)',
   'EX:'=>sub {
#                if ($FVRequire !~ /timer/) { return ''; }
                if ($FVRequire =~ /timer/) { return ''; }
                return 'ok';
          },
 },
### 20060120 maeda update end ###

 # SYNTAX: require (must)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_REQUIRE_MUST', 'CA:'=>'Require',
   'OK:'=>'When refresher=uac, Require header MUST exist',
   'NG:'=>'When refresher=uac, Require header MUST exist',
   'RT:'=>"error",
   'PR:'=>\q{FFIsExistHeader("Session-Expires", @_) && FV("HD.Session-Expires.val.param.refresher=",@_) eq uac},
   'EX:'=>sub {
                my $require = FFIsExistHeader("Require", @_);
                if ($FVSendExpires ne $FVExpires) {
                    if ($require eq '') { return ''; }
                	if ($FVRequire !~ /timer/) { return ''; }
                }
                if ($FVSendRefresher ne $FVRefresher) {
                    if ($require eq '') { return ''; }
                	if ($FVRequire !~ /timer/) { return ''; }
                }
                if ($FVRefresher eq 'refresher=uac') {
                	if ($FVRequire !~ /timer/) { return ''; }
                }
                if ($FVRefresher eq 'refresher=uas') {
                	if ($FVRequire !~ /timer/) { return ''; }
                }

                return 'ok';
          },
 },

 # SYNTAX: require (must)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_REQUIRE_SHOULD', 'CA:'=>'Require',
   'OK:'=>'When refresher=uas, Require header SHOULD Exist.',
   'NG:'=>'When refresher=uas, Require header SHOULD Exist.',
   'RT:'=>"warning",
   'PR:'=>\q{FFIsExistHeader("Session-Expires", @_) && FV("HD.Session-Expires.val.param.refresher=",@_) eq uas},
   'EX:'=>sub {
                my $require = FFIsExistHeader("Require", @_);
                if ($FVSendExpires ne $FVExpires) {
                    if ($require eq '') { return ''; }
                	if ($FVRequire !~ /timer/) { return ''; }
                }
                if ($FVSendRefresher ne $FVRefresher) {
                    if ($require eq '') { return ''; }
                	if ($FVRequire !~ /timer/) { return ''; }
                }
                if ($FVRefresher eq 'refresher=uac') {
                	if ($FVRequire !~ /timer/) { return ''; }
                }
                if ($FVRefresher eq 'refresher=uas') {
                	if ($FVRequire !~ /timer/) { return ''; }
                }

                return 'ok';
          },
 },


 # SYNTAX: require (must)
 { 'TY:'=>'SYNTAX', 'ID:'=>'S.SESSION_TIMER_CHK_REQUIRE', 'CA:'=>'Require',
   'OK:'=>'same before recieved value.',
   'NG:'=>'different before recieved value.',
   'RT:'=>"error",
#   'PR:'=>\q{$FVRecvInvite > 0 ? 'exec': ''}, # 20060120 maeda delete
   'EX:'=>sub {
                if ($FVRequire ne $FVRecvRequire) { return ''; }
                return 'ok';
          },
 },

### 20060120 maeda update start ###
 # SYNTAX: exist proxy-require (may)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_PROXY_REQUIRE', 'CA:'=>'Proxy-Require',
#   'OK:'=>'Exist. You are not recommended to include the \'timer\' option tag.',
#   'NG:'=>'Not exist. You ar not recommended to include the \'timer\' option tag.',
   'OK:'=>'Not exist. You are not recommended to include the \'timer\' option tag.',
   'NG:'=>'Exist. You are not recommended to include the \'timer\' option tag.',
   'RT:'=>"warning",
   'PR:'=>\'FFIsExistHeader("Proxy-Require", @_)',
   'EX:'=>sub {
#                if ($FVProxyRequire !~ /timer/) { return ''; }
                if ($FVProxyRequire =~ /timer/) { return ''; }
                return 'ok';
          },
 },
### 20060120 maeda update end ###

 # SYNTAX: proxy-require (must)
 { 'TY:'=>'SYNTAX',
    'ID:'=>'S.SESSION_TIMER_CHK_PROXY_REQUIRE', 'CA:'=>'Proxy-Require',
   'OK:'=>'same before recieved value.',
   'NG:'=>'different before recieved value.',
   'RT:'=>"error",
#   'PR:'=>\q{$FVRecvInvite > 0 ? 'exec': ''}, # 20060120 maeda delete
   'EX:'=>sub {
                if ($FVProxyRequire ne $FVRecvProxyRequire) { return ''; }
                return 'ok';
          },
 },

 # SYNTAX: exist min-se (may)
 { 'TY:'=>'SYNTAX', 'ID:'=>'S.SESSION_TIMER_MIN_SE_MAY', 'CA:'=>'Min-SE',
   'OK:'=>'Exist. You may include this header.',
   'NG:'=>'Not exist. You may include this header.',
   'RT:'=>"warning",
### 20060120 maeda delete start ###
#   'PR:'=>sub {
#                if ($FVStatusCode eq '422') { return ''; }
#                if ($FVRequestMethod eq 'INVITE'  &&  $FVSendMsg eq '422') {
#                    return '';
#                }
#                return 'exec';
#          },
### 20060120 maeda delete end ###
   'EX:'=>\'FFIsExistHeader("Min-SE", @_)',
 },

 # SYNTAX: exist min-se
 #   recv 200 (must not)
 { 'TY:'=>'SYNTAX', 'ID:'=>'S.SESSION_TIMER_MIN_SE_MUSTNOT', 'CA:'=>'Min-SE',
   'OK:'=>'Not exist. You must not include this header.',
   'NG:'=>'Exist. You must not include this header.',
   'RT:'=>"error",
   'LG:'=>"NOT",
   'EX:'=>\'FFIsExistHeader("Min-SE", @_)',
 },

 # SYNTAX: exist min-se
 #   recv 422 (must)
 #   send 422 -> recv invite (must)
 { 'TY:'=>'SYNTAX', 'ID:'=>'S.SESSION_TIMER_MIN_SE_MUST', 'CA:'=>'Min-SE',
   'OK:'=>'Exist. You must include this header.',
   'NG:'=>'Not exist. You must include this header.',
   'RT:'=>"error",
   'PR:'=>sub {
                if ($FVStatusCode eq '422') { return 'exec'; }
### 20060120 maeda update start ###
#                if ($FVRequestMethod eq 'INVITE'  &&  $FVSendMsg eq '422') {
#                    return 'exec';
#                }
                 if ($FVSendMinSE ne '') { return 'exec'; }
### 20060120 maeda update end ###
                return '';
          },
   'EX:'=>\'FFIsExistHeader("Min-SE", @_)',
 },

 # SYNTAX: min-se < 90 (must not)
 { 'TY:'=>'SYNTAX', 'ID:'=>'S.SESSION_TIMER_CHK_MIN_SE', 'CA:'=>'Min-SE',
   'OK:'=>'Must not be less than 90(or Min-SE).',
   'NG:'=>'Must not be less than 90(or Min-SE).',
   'RT:'=>"error",
   'PR:'=>\q{$FVMinSE ne '' ? 'exec': ''},
   'EX:'=>sub {
                if ($FVMinSE < 90) { return ''; }
                if ($FVSendMinSE ne '') {
                    if ($FVMinSE < $FVSendMinSE) { return ''; }
                }
                return 'ok';
          },
 },

 # SYNTAX: exist session-expires
 # recv invite (may)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_EXPIRES_MAY', 'CA:'=>'Session-Expires',
   'OK:'=>'Exist. You may include this header.',
   'NG:'=>'Not exist. You may include this header.',
   'RT:'=>"warning",
   'EX:'=>\'FFIsExistHeader("Session-Expires", @_)',
 },

 # SYNTAX: exist session-expires
 # recv 200, exist requires (must)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_EXPIRES_MUST', 'CA:'=>'Session-Expires',
   'OK:'=>'Exist. You must include this header.',
   'NG:'=>'Not exist. You must include this header.',
   'RT:'=>"error",
   'PR:'=>\'FFIsExistHeader("Require", @_)',
   'EX:'=>\'FFIsExistHeader("Session-Expires", @_)',
 },

 # SYNTAX: exist session-expires
 # recv 422 (must not)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_EXPIRES_MUSTNOT', 'CA:'=>'Session-Expires',
   'OK:'=>'Not exist. You must not include this header.',
   'NG:'=>'Exist. You must not include this header.',
   'RT:'=>"error",
   'LG:'=>"NOT",
   'EX:'=>\'FFIsExistHeader("Session-Expires", @_)',
 },

 # SYNTAX: exist session-expires (must)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_EXPIRES_MIN', 'CA:'=>'Session-Expires',
   'OK:'=>'Session-Expires >= Min-SE(or 90).',
   'NG:'=>'Session-Expires < Min-SE(or 90).',
   'RT:'=>"error",
   'PR:'=>\q{$FVExpires ne '' ? 'exec': ''},
   'EX:'=>sub {
                if ($FVExpires < 90) { return ''; }
                if ($FVMinSE ne '') {
                    if ($FVExpires < $FVMinSE) { return ''; }
                }
                if ($FVSendMinSE ne '') {
                    if ($FVExpires < $FVSendMinSE) { return ''; }
                }
                return 'ok';
          },
 },

 # SYNTAX: exist session-expires (must not)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_EXPIRES_MAX', 'CA:'=>'Session-Expires',
   'OK:'=>'Session-Expires <= sent Session-Expires.',
   'NG:'=>'Session-Expires > sent Session-Expires.',
   'RT:'=>"error",
   'PR:'=>\q{$FVExpires ne ''  &&  $FVSendExpires ne '' ? 'exec': ''},
   'EX:'=>sub {
                if ($FVExpires > $FVSendExpires) { return ''; }
                return 'ok';
          },
 },

 # SYNTAX: exist session-expires (should)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_EXPIRES_SAME', 'CA:'=>'Session-Expires',
   'OK:'=>'same from previous value.',
   'NG:'=>'differs from previous value.',
   'RT:'=>"warning",
   'PR:'=>\q{$FVExpires ne ''  &&  $FVSendExpires ne '' ? 'exec': ''},
   'EX:'=>sub {
                if ($FVExpires ne $FVSendExpires) { return ''; }
                return 'ok';
          },
 },

 # SYNTAX: exist session-expires (should not)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_EXPIRES_1800', 'CA:'=>'Session-Expires',
   'OK:'=>'Session-Expires >= 1800.',
#2006.7.14   'NG:'=>'Session-Expires < 1800. Session-Expires parameter recommended less than 1800.',
   'NG:'=>'Session-Expires not equal 1800. Session-Expires parameter recommended 1800.',
  'RT:'=>"warning",
   'PR:'=>\q{$FVExpires ne '' ? 'exec': ''},
   'EX:'=>sub {
                if ($FVExpires < 1800) { return ''; }
                return 'ok';
          },
 },

 # SYNTAX: exist refresher
 # recv invite (may)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_REFRESHER_MAY', 'CA:'=>'Session-Expires(Refresher)',
   'OK:'=>'Not exist. Not include refresher parameter is RECOMMENDED.',
   'NG:'=>'Exist. Not include refresher parameter is RECOMMENDED',
   'RT:'=>"warning",
   'PR:'=>\'FFIsExistHeader("Session-Expires", @_)',
   'EX:'=>sub {
                if ($FVRefresher eq '') { return 'ok'; }
                return '';
          },
 },

 # SYNTAX: exist refresher
 # recv 200, exist requires (must)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_REFRESHER_MUST', 'CA:'=>'Session-Expires(Refresher)',
   'OK:'=>'Exist. You must include this header.',
   'NG:'=>'Not exist. You must include this header.',
   'RT:'=>"error",
   'EX:'=>sub {
                if ($FVRefresher eq '') { return ''; }
                return 'ok';
          },
 },

### 20060120 maeda update start ###
 # SYNTAX: check refresher
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_REFRESHER', 'CA:'=>'Session-Expires(Refresher)',
#   'OK:'=>'This header must be \'uac\', \'uas\', \'none\'.',
#   'NG:'=>'This header must be \'uac\', \'uas\', \'none\'. or differs from previous value.',
#   'RT:'=>"error",
   'OK:'=>'This parameter recommend \'uac\'.',
   'NG:'=>'This parameter recommend \'uac\'.',
   'RT:'=>"warning",
   'PR:'=>\'FFIsExistHeader("Session-Expires", @_)',
   'EX:'=>sub {
#                if ($FVSendRefresher ne '') {
#                    if ($FVSendRefresher ne $FVRefresher) { return ''; }
#                }
#                if ($FVStatusCode eq '200'  &&  $FVRefresher eq '') {
#                    return '';
#                }
#                if ($FVRefresher ne '') {
#                    if ($FVRefresher ne 'refresher=uac'  &&
#                        $FVRefresher ne 'refresher=uas') {
#                        return '';
#                    }
#                }
                if ($FVRefresher ne 'refresher=uac') { return ''; }
                return 'ok';
          },
 },
### 20060120 maeda update end ###

 # SYNTAX: call-id (should)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_CALL_ID', 'CA:'=>'Call-ID',
   'OK:'=>'same before recieved value.',
   'NG:'=>'different before recieved value.',
   'RT:'=>"warning",
### 20060120 maeda delete start ###
#   'PR:'=>\q{$FVRequestMethod eq 'INVITE'  &&  $FVSendMsg eq '422' ?
#                    'exec': '' },
### 20060120 maeda delete end ###
   'EX:'=>sub {
                if ($FVCallID ne $FVRecvCallID) { return ''; }
                return 'ok';
          },
 },

 # SYNTAX: to (should)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_TO', 'CA:'=>'To',
   'OK:'=>'same before recieved value.',
   'NG:'=>'different before recieved value.',
   'RT:'=>"warning",
### 20060120 maeda delete start ###
#   'PR:'=>\q{$FVRequestMethod eq 'INVITE'  &&  $FVSendMsg eq '422' ?
#                    'exec': '' },
### 20060120 maeda delete end ###
   'EX:'=>sub {
                if ($FVTo ne $FVRecvTo) { return ''; }
                return 'ok';
          },
 },

 # SYNTAX: from (should)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_FROM', 'CA:'=>'From',
   'OK:'=>'same before recieved value.',
   'NG:'=>'different before recieved value.',
   'RT:'=>"warning",
### 20060120 maeda delete start ###
#   'PR:'=>\q{$FVRequestMethod eq 'INVITE'  &&  $FVSendMsg eq '422' ?
#                    'exec': '' },
### 20060120 maeda delete end ###
   'EX:'=>sub {
                if ($FVFrom ne $FVRecvFrom) { return ''; }
                return 'ok';
          },
 },

 # SYNTAX: cseq (should)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_CSEQ', 'CA:'=>'CSeq',
   'OK:'=>'before recieved value + 1.',
   'NG:'=>'not before recieved value + 1.',
   'RT:'=>"warning",
### 20060120 maeda delete start ###
#   'PR:'=>\q{$FVRequestMethod eq 'INVITE'  &&  $FVSendMsg eq '422' ?
#                    'exec': '' },
### 20060120 maeda delete end ###
   'EX:'=>sub {
                my @cseq1 = split(/ /, $FVRecvCSeq);
                my @cseq2 = split(/ /, $FVCSeq);
                $cseq1[0] = $cseq1[0] + 1;
### print "### cseq[$cseq1[0]][$cseq2[0]] ###\n";
                if ($cseq1[0] ne $cseq2[0]) { return ''; }
                return 'ok';
          },
 },

### 20060112 maeda add start ###
 # SYNTAX: allow (should)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_ALLOW', 'CA:'=>'Allow',
   'OK:'=>'Should include UPDATE.',
   'NG:'=>'Not include UPDATE. Should include UPDATE.',
   'RT:'=>"warning",
   'PR:'=>\'FFIsExistHeader("Allow", @_)',
   'EX:'=>sub {
                my($ref);
                if(ref($FVAllow) eq 'ARRAY'){
                    if(grep{$_ =~ /UPDATE/i}@$FVAllow){
                          return 'ok';
                    }
                    else{
                          return '';
                    }
                }
                else{
                    if ($FVAllow !~ /UPDATE/i) { return ''; }
                    return 'ok';
                }
          },
 },
### 20060112 maeda add end ###

 # SYNTAX: sdp (should)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_SDP', 'CA:'=>'SDP',
   'OK:'=>'same before recieved value.',
   'NG:'=>'different before recieved value.',
   'RT:'=>"warning",
### 20060120 maeda update start ###
#   'PR:'=>\q{$FVRecvInvite > 0  ||  $FVRecv200 > 0 ? 'exec': ''},
   'PR:'=>sub {
                if (FVal('HD.CSeq.val.method') eq 'UPDATE') { return ''; }
                if ($FVRecvInvite > 0  ||  $FVRecv200 > 0) { return 'exec'; }
                return '';
          },
### 20060120 maeda update end ###
   'EX:'=>sub {
                if ($FVBody ne $FVRecvBody) { return ''; }
                return 'ok';
          },
 },

### 20060120 maeda add start ###
 # SYNTAX: sdp (UPDATE)
 { 'TY:'=>'SYNTAX',
   'ID:'=>'S.SESSION_TIMER_CHK_NOSDP', 'CA:'=>'SDP',
   'OK:'=>'Recommended that the UPDATE request not contain an offer.',
   'NG:'=>'Recommended that the UPDATE request not contain an offer.',
   'RT:'=>"warning",
   'EX:'=>sub { if ($FVBody ne '') { return ''; } return 'ok'; },
 },
### 20060120 maeda add end ###

 # SYNTAX: ruleset (Initial-INVITE)
 { 'TY:'=>'RULESET', 'ID:'=>'SSet.SESSION_TIMER_INVITE',
   'RR:'=>[
            'S.SESSION_TIMER_SUPPORTED',
            'S.SESSION_TIMER_REQUIRE',
            'S.SESSION_TIMER_PROXY_REQUIRE',
#            'S.SESSION_TIMER_MIN_SE_MAY',
#            'S.SESSION_TIMER_MIN_SE_MUST', # 20060120 maeda delete
            'S.SESSION_TIMER_CHK_MIN_SE',
#            'S.SESSION_TIMER_EXPIRES_MAY', # 20060120 maeda delete
            'S.SESSION_TIMER_CHK_EXPIRES_MIN',
#            'S.SESSION_TIMER_CHK_EXPIRES_SAME', # 20060120 maeda delete
            'S.SESSION_TIMER_CHK_EXPIRES_1800',
            'S.SESSION_TIMER_REFRESHER_MAY',
#            'S.SESSION_TIMER_CHK_REFRESHER', # 20060120 maeda delete

### 20060120 maeda delete start ###
#            'S.SESSION_TIMER_CHK_SUPPORTED',
#            'S.SESSION_TIMER_CHK_REQUIRE',
#            'S.SESSION_TIMER_CHK_PROXY_REQUIRE',
#            'S.SESSION_TIMER_CHK_SDP',
#
#            'S.SESSION_TIMER_CHK_CALL_ID',
#            'S.SESSION_TIMER_CHK_TO',
#            'S.SESSION_TIMER_CHK_FROM',
#            'S.SESSION_TIMER_CHK_CSEQ',
### 20060120 maeda delete end ###
          ]
 },

### 20060120 maeda add start ###
 # SYNTAX: ruleset (re-INVITE)
 { 'TY:'=>'RULESET', 'ID:'=>'SSet.SESSION_TIMER_RE-INVITE',
   'RR:'=>[
            'S.SESSION_TIMER_MIN_SE_MUST',
            'S.SESSION_TIMER_CHK_MIN_SE',
            'S.SESSION_TIMER_EXPIRES_MAY',
            'S.SESSION_TIMER_CHK_EXPIRES_MIN',
            'S.SESSION_TIMER_CHK_EXPIRES_SAME',
            'S.SESSION_TIMER_REFRESHER_MUST',
            'S.SESSION_TIMER_CHK_REFRESHER',

            'S.SESSION_TIMER_CHK_SUPPORTED',
            'S.SESSION_TIMER_CHK_REQUIRE',
            'S.SESSION_TIMER_CHK_PROXY_REQUIRE',
            'S.SESSION_TIMER_CHK_SDP',
          ]
 },

 # SYNTAX: ruleset (UPDATE)
 { 'TY:'=>'RULESET', 'ID:'=>'SSet.SESSION_TIMER_UPDATE',
   'RR:'=>[
            'S.SESSION_TIMER_MIN_SE_MUST',
            'S.SESSION_TIMER_CHK_MIN_SE',
            'S.SESSION_TIMER_EXPIRES_MAY',
            'S.SESSION_TIMER_CHK_EXPIRES_MIN',
            'S.SESSION_TIMER_CHK_EXPIRES_SAME',
            'S.SESSION_TIMER_REFRESHER_MUST',
            'S.SESSION_TIMER_CHK_REFRESHER',

            'S.SESSION_TIMER_CHK_SUPPORTED',
            'S.SESSION_TIMER_CHK_REQUIRE',
            'S.SESSION_TIMER_CHK_PROXY_REQUIRE',
            'S.SESSION_TIMER_CHK_NOSDP',
          ]
 },

 # SYNTAX: ruleset (retry session timer)
 { 'TY:'=>'RULESET', 'ID:'=>'SSet.SESSION_TIMER_RETRY_422',
   'RR:'=>[
            'S.SESSION_TIMER_CHK_CALL_ID',
            'S.SESSION_TIMER_CHK_TO',
            'S.SESSION_TIMER_CHK_FROM',
            'S.SESSION_TIMER_CHK_CSEQ',
          ]
 },
### 20060120 maeda add end ###

 # SYNTAX: ruleset (recv 200 response)
 { 'TY:'=>'RULESET', 'ID:'=>'SSet.SESSION_TIMER_200',
   'RR:'=>[
#            'S.SESSION_TIMER_SUPPORTED', # 20060120 maeda delete
            'S.SESSION_TIMER_REQUIRE_MUST',
            'S.SESSION_TIMER_REQUIRE_SHOULD',
#            'S.SESSION_TIMER_PROXY_REQUIRE', # 20060120 maeda delete
            'S.SESSION_TIMER_MIN_SE_MUSTNOT',
            'S.SESSION_TIMER_EXPIRES_MUST',
            'S.SESSION_TIMER_CHK_EXPIRES_MIN',
            'S.SESSION_TIMER_CHK_EXPIRES_MAX',
#            'S.SESSION_TIMER_CHK_EXPIRES_1800', # 20060123 maeda delete
            'S.SESSION_TIMER_REFRESHER_MUST',
#            'S.SESSION_TIMER_CHK_REFRESHER', # 20060120 maeda delete

            'S.SESSION_TIMER_CHK_SDP',
          ]
 },

 # SYNTAX: ruleset (recv 422 response)
 { 'TY:'=>'RULESET', 'ID:'=>'SSet.SESSION_TIMER_422',
   'RR:'=>[
            'S.SESSION_TIMER_MIN_SE_MUST',
            'S.SESSION_TIMER_CHK_MIN_SE',
#            'S.SESSION_TIMER_EXPIRES_MUSTNOT', # 20060123 maeda delete
          ]
 },

 # 422 Session Interval Too Small
 { 'TY:'=>'ENCODE', 'ID:'=>'E.STATUS-422', 'PT:'=>RQ,
   'FM:'=>'SIP/2.0 422 Session Interval Too Small',
 },

 # 422 ALL-RETURN
 # ALL-RETURN(VIA,FROM,TO,CALL-ID,CSEQ,Content-Length=0)
 { 'TY:'=>'RULESET', 'ID:'=>'E.STATUS-422-RETURN.PX1', 'MD:'=>SEQ,
   'RR:'=>[
            'E.STATUS-422',
            'E.VIA-RETURN',
            'EESet.BASIC-FTCC-RETURN-TOTAG-C_INVITE',
            'E.MIN-SE',
            'E.CONTENT-LENGTH_0',
          ],
   'EX:'=>\&MargeSipMsg
 },

 # Proxy receives ACK for 422 Session Interval Too Small
 { 'TY:'=>'RULESET', 'ID:'=>'SSet.REQUEST.422-ACK.PX',
   'RR:'=>[
            'SSet.REQUEST.non2xx-ACK',
           ]
 },


);

#=================================
# 
#=================================

sub SessionTimer_EncodeString {
	my ($supported) = @_;                       # 20050407 usako add

    my $result = '';
    my $sw = 0;

    if ($FVProxyRequire ne '') {
        $result .= ("Proxy-Require: ".$FVProxyRequire); $sw = 1;
    }
    if ($FVRequire ne '') {
        if ($sw) { $result .= "\r\n"; $sw = 0; }
        $result .= ("Require: ".$FVRequire); $sw = 1;
    }

#   if ($FVSupported ne '') {                   # 20050407 usako delete
    if ($supported ne '') {                     # 20050407 usako add
        if ($sw) { $result .= "\r\n"; $sw = 0; }
#       $result .= ("Supported: ".$FVSupported); $sw = 1;
                                                #20050407 usako delete
        $result .= ("Supported: ".$supported); $sw = 1;    # 20050407 usako add
        $FVSupported = $supported;                         # 20050407 usako add
    }

    if ($FVExpires ne '') {
        if ($sw) { $result .= "\r\n"; $sw = 0; }
        $result .= ("Session-Expires: ".$FVExpires);
        if ($FVRefresher ne '') { $result .= (";".$FVRefresher); }
        $sw = 1;
    }
    if ($FVMinSE ne '') {
        if ($sw) { $result .= "\r\n"; $sw = 0; }
        $result .= ("Min-SE: ".$FVMinSE);
    }

    return $result;
}

#
1

