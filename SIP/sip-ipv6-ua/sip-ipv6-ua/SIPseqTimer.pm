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

sub SessionTimer_InitSendValue {
    $FVSendMsg = '';
    $FVSendSupported = '';
    $FVSendMinSE = '';
    $FVSendExpires = '';
    $FVSendRefresher = '';
    $FVSendRequire = '';
    $FVSendProxyRequire = '';
}

sub SessionTimer_SetSendValue {
    my ($code) = @_;

    $FVSendMsg = ($code ne '' ? $code: 'invite');
    $FVSendSupported = $FVSupported;
    $FVSendMinSE = $FVMinSE;
    $FVSendExpires = $FVExpires;
    $FVSendRefresher = $FVRefresher;
    $FVSendRequire = $FVRequire;
    $FVSendProxyRequire = $FVProxyRequire;
}

sub SessionTimer_InitRecvValue {
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
}

sub SessionTimer_SetRecvValue {
    $FVRecvSupported = $FVSupported;
    $FVRecvRequire = $FVRequire;
    $FVRecvProxyRequire = $FVProxyRequire;
    $FVRecvCallID = $FVCallID;
    $FVRecvTo = $FVTo;
    $FVRecvFrom = $FVFrom;
    $FVRecvCSeq = $FVCSeq;
    $FVRecvBody = $FVBody;

    if ($FVStatusCode eq '200') {
         $FVRecv200 = $FVRecv200 + 1;
    }
}

sub SessionTimer_Initialize {
    RegistRuleSet(\@SIPUAExtendTimerRules);

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

    SessionTimer_InitSendValue();
    SessionTimer_InitRecvValue();
}

sub SessionTimer_CheckRecvINVITE {
    my ($minSE) = @_;
    my $result = 200;

    if ($minSE ne '') {
        if ($FVExpires < $minSE) { $result = 422; }
    } elsif ($FVSendMinSE ne '') {
        if ($FVExpires < $FVSendMinSE) { $result = 422; }
    } else {
        if ($FVExpires < 90) { $result = 422; }
    }

    return $result;
}

sub SessionTimer_SD_Proxy_INVITE {
### 20060116 maeda update start ###
#    my ($supported, $minSE, $expires, $refresher, $require, $proxyRequire,$conn) = @_;
	my ($supported, $minSE, $expires, $refresher, $require, $proxyRequire,
		$conn, $rule, $addrule, $delrule) = @_;
### 20060116 maeda update end ###
    my $result;

    $FVSupported = '';
    $FVMinSE = '';
    $FVRequire = '';
    $FVProxyRequire = '';

#   if ($supported ne '') { $FVSupported = $supported; } # 20050407 usako delete
    if ($minSE ne '') { $FVMinSE = $minSE; }
    if ($expires ne '') { $FVExpires = $expires; }
    if ($refresher ne '') { $FVRefresher = $refresher; }
    if ($require ne '') { $FVRequire = $require; }
    if ($proxyRequire ne '') { $FVProxyRequire = $proxyRequire; }

### 20060116 maeda update start ###
#    $result=SD_Proxy_INVITE('','','','',$conn);
    $result=SD_Proxy_INVITE($rule, '', $addrule, $delrule, $conn);
### 20060116 maeda update end ###

    SessionTimer_SetSendValue();

    return $result;
}

### 20060116 maeda update start ###
sub SessionTimer_SD_Proxy_UPDATE {
	my ($supported, $minSE, $expires, $refresher, $require, $proxyRequire,
		$conn, $rule, $addrule, $delrule) = @_;
	my $result;

	$FVSupported = '';
	$FVMinSE = '';
	$FVRequire = '';
	$FVProxyRequire = '';

	if ($minSE ne '') { $FVMinSE = $minSE; }
	if ($expires ne '') { $FVExpires = $expires; }
	if ($refresher ne '') { $FVRefresher = $refresher; }
	if ($require ne '') { $FVRequire = $require; }
	if ($proxyRequire ne '') { $FVProxyRequire = $proxyRequire; }

	$result=SD_Proxy_UPDATE($rule, '', $addrule, $delrule, $conn);

	SessionTimer_SetSendValue();

	return $result;
}
### 20060116 maeda update end ###

sub SessionTimer_SD_Proxy_STATUS {
### 20060112 maeda update start ###
#    my ($code, $request,
#        $supported, $minSE, $expires, $refresher, $require, $proxyRequire,$conn) = @_;
	my ($code, $request,
		$supported, $minSE, $expires, $refresher, $require, $proxyRequire,
		$conn, $rule, $addrule, $delrule) = @_;
### 20060112 maeda update end ###

#    my $rule; # 20060116 maeda delete
    my $result;

    $FVSupported = '';
    $FVMinSE = '';
    $FVRequire = '';
    $FVProxyRequire = '';

#   if ($supported ne '') { $FVSupported = $supported; } # 20050407 usako delete

    if ($code eq '422') {
        $rule = 'E.STATUS-422-RETURN.PX1';
        $FVExpires = '';
        $FVMinSE = $minSE;
        if ($FVMinSE eq ''  ||  $FVMinSE < 90) { $FVMinSE = '90'; }
    } else {
        if ($expires ne '') { $FVExpires = $expires; }
        if ($refresher ne '') { $FVRefresher = $refresher; }
        if ($require ne '') { $FVRequire = $require; }
        if ($proxyRequire ne '') { $FVProxyRequire = $proxyRequire; }

        if ($FVExpires ne '') {
#           if ($FVSupported !~ /timer/) { $FVSupported = "timer"; }
                                                         # 20050407 usako delete
            if ($FVRequire !~ /timer/) { $FVRequire = "timer"; }
            if ($FVRefresher eq '') {
                $FVRefresher = ($refresher ne '' ? $refresher: "refresher=uac");
            }
        }
    }

### 20060112 maeda update start ###
#    $result=SD_Proxy_STATUS($code, $request, $rule,'','','',$conn);
	$result=SD_Proxy_STATUS($code, $request, $rule, '', $addrule, $delrule, $conn);
### 20060112 maeda update end ###

    SessionTimer_SetSendValue($code);
    if ($code eq '200') { $FVRecvInvite = $FVRecvInvite + 1; }

    return $result;
}

sub SessionTimer_GetWaitTime {
    my ($expires) = @_;
    my $wait = 0;

    if ($FVExpires > 0) { $wait = $FVExpires / 2; }
    if ($wait <= 0  &&  $expires > 0) { $wait = $expires / 2; }
#    if ($wait > 0) { $wait = $wait - ($wait * 0.1); } # 20060117 maeda delete

    LOG_OK("wait [$wait]sec");

    return $wait;
}

### 20060117 maeda add start ###
sub SessionTimer_GetRecvWaitTime {
	my ($expires) = @_;
	my $wait = 0;

	if ($FVExpires > 0) {
		$wait = $FVExpires / 2;
	}
	else {
		if ($expires > 0) {
			$wait = $expires / 2;
		}
	}

	if ($wait > 0) {
		# Because time accuracy is not good, time is brought forward.
		--$wait;
	}

	return $wait;
}

sub SessionTimer_GetRecvTimeout {
	my ($expires) = @_;
	my $wait = 0;

	if ($FVExpires > 0) {
		$wait = $FVExpires;
	}
	else {
		if ($expires > 0) {
			$wait = $expires;
		}
	}

	if ($wait > 0) {
		if ($wait / 3 < 32) {
			$wait = $wait - $wait / 3;
		}
		else {
			$wait = $wait - 32;
		}
	}

	return $wait;
}
### 20060117 maeda add end ###

sub SessionTimer_GetMinSE {
    return $FVMinSE;
}

### 20060123 maeda add start ###
sub SessionTimer_SetMinSE {
	my ($minSE) = @_;
	$FVMinSE = $minSE;
	$FVSendMinSE = $minSE;
}

sub SessionTimer_GetSessionExpires {
	return $FVExpires;
}

sub SessionTimer_SetSessionExpires {
	my ($expires) = @_;
	$FVExpires = $expires;
	$FVSendExpires = $expires;
}
### 20060123 maeda add end ###

sub SessionTimer_BufferClear {
    my ($link) = @_;
    if ($link eq '') { $link = $SIP_Link; }
    vCLEAR($link);
}

### 20060118 maeda add start ###
sub SessionTimer_DropMsg {
	my ($dropTime) = @_;

	my $frame;
	my $prevTime;
	my $thisTime;
	my $waitTime;
	my($result);

	if ($SIP_PL_IP eq '6') {
		$frame = 'SIPtoPROXY';
	}
	elsif ($SIP_PL_IP eq '4') {
		$frame = 'SIP4toPROXY';
	}

	# drop message
	$prevTime = time();
	$waitTime = $dropTime;
	while ($waitTime > 0) {
		$result = RecvAndEvalDecodeRule('', $frame, REQUEST, '', '', '', $waitTime,
				'', 'autoRegist', $SIP_DNS_ANSWER_MODE);
		$thisTime = time();
		$waitTime -= ($thisTime - $prevTime);
		$prevTime = $thisTime;
	}

	# drop RTP
	SessionTimer_BufferClear();
}

sub SessionTimer_DropReSndMsg {
	my $frame;
	my $pktinf;
	my $prevTime;
	my $thisTime;
	my $waitTime;
	my($result);

	if ($SIP_PL_IP eq '6') {
		$frame = 'SIPtoPROXY';
	}
	elsif ($SIP_PL_IP eq '4') {
		$frame = 'SIP4toPROXY';
	}

	$pktinf = GetSIPPktInfoIndex();

	# drop resend request message
	$prevTime = time();
	$waitTime = 32 - ($prevTime - $pktinf->{timestamp});
	while ($waitTime > 0) {
		$result = RecvAndEvalDecodeRule('', $frame, REQUEST, '', '', '', $waitTime,
				'', 'autoRegist', $SIP_DNS_ANSWER_MODE);
		$thisTime = time();
		$waitTime -= ($thisTime - $prevTime);
		$prevTime = $thisTime;
	}

	# drop RTP
	SessionTimer_BufferClear();
}
### 20060118 maeda add end ###

sub usako_debug {
    print "[$FVSupported][$FVExpires][$FVRefresher][$FVMinSE][$FVRequire][$FVProxyRequire]\n";
}

#
1
