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

sub RecActRTPLoopCount {
    my ($recvCount, $request, $recvFrame, $context) = @_;
    my (%pkt);
    $RTPrecvCount++;
    MsgPrint('INF', "RTP receive count[%s]\n", $RTPrecvCount);

    $pkt{pkt} = $recvFrame;
    $pkt{timestamp} = $recvFrame->{recvTime1};
    $pkt{dir} = 'recv';
    # RTP
    StoreRTPPktInfo(\%pkt);
    return(($recvCount <= $RTPrecvCount) ? 'OK' : '');
}

sub SD_RTP_ICMP_ERROR {
    my ($timeout, $link) = @_;
    if ($link eq '') { $link = $SIP_Link; }
    if ($timeout eq '') { $timeout = $SIP_TimeOut; }

    my ($ret, @rframes, @runknown, $sendFrame, @sframes, @sunknown, $cpp, %pkt1);
    @rframes = ();
    @sframes = ();

    # 
    $rframes[0]{'Recv'} = 'RTPany';
    $rframes[0]{'RecvMode'} = 'actstop';
    $rframes[0]{'RecvAction'} = \'RecActRTPLoopCount(1)';

    # 
    $ret = CNT_SendAndRecv(\@rframes, \@runknown, $timeout, \@SIP_AutoResponse, $link);
    if ($ret ne 'OK') {
        MsgPrint('ERR', "SIP message dose not receive[%s]\n", $ret);
        return $ret;
    }

    vCLEAR($link);

    if ($SIP_PL_IP eq '6') {
        $sendFrame = 'ICMPErrorFromPROXY';

        # 
        $cpp = sprintf(" -DSIP_RECVED_TRAFFICCLASS=%s" .
                       " -DSIP_RECVED_FLOWLABEL=%s" .
                        " -DSIP_RECVED_PAYLOADLENGTH=%s" .
                       " -DSIP_RECVED_NEXTHEADER=%s" .
                       " -DSIP_RECVED_HOPLIMIT=%s" .
                       " -DSIP_RECVED_SRC_ADDR=v6\\\(\\\"%s\\\"\\\)" .
                       " -DSIP_RECVED_DST_ADDR=v6\\\(\\\"%s\\\"\\\)" .
                       " -DSIP_RECVED_SRC_PORT=%s -DSIP_RECVED_DST_PORT=%s" .
                       " -DICMP_ERROR_TYPE=1" .
                       " -DICMP_ERROR_CODE=0 ",
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.TrafficClass'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.FlowLabel'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.PayloadLength'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.NextHeader'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.HopLimit'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.SourcePort'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.DestinationPort'});

        # 
        $cpp = SetupVCPPString($cpp);

        # 
        CNT_WriteSipMsg($rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv6.Upp_UDP.Payload.data'});
    }
    else {
        $sendFrame = 'ICMP4ErrorFromPROXY';

        # 
        $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.HeaderChecksum'} =~ /([0-9]+)\scalc/;
        $checksum = $1;
        $cpp = sprintf(" -DSIP4_RECVED_IHL=%s" .
                       " -DSIP4_RECVED_TYPEOFSERVICE=%s" .
                       " -DSIP4_RECVED_IDENTIFIER=%s" .
                       " -DSIP4_RECVED_DF=%s" .
                       " -DSIP4_RECVED_MF=%s" .
                       " -DSIP4_RECVED_FRAGMENTOFFSET=%s" .
                       " -DSIP4_RECVED_TTL=%s" .
                       " -DSIP4_RECVED_PROTOCOL=%s" .
                       " -DSIP4_RECVED_HEADERCHECKSUM=%s " .
                       " -DSIP4_RECVED_SRC_ADDR=v4\\\(\\\"%s\\\"\\\)" .
                       " -DSIP4_RECVED_DST_ADDR=v4\\\(\\\"%s\\\"\\\) " .
                       " -DSIP4_RECVED_SRC_PORT=%s -DSIP4_RECVED_DST_PORT=%s" .
                       " -DICMP_ERROR_TYPE=1" .
                       " -DICMP_ERROR_CODE=0 ",
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.IHL'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.TypeOfService'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.Identifier'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.DF'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.MF'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.FragmentOffset'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.TTL'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.Protocol'},
                       $checksum,
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.SourceAddress'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Hdr_IPv4.DestinationAddress'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Upp_UDP.Hdr_UDP.SourcePort'},
                       $rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Upp_UDP.Hdr_UDP.DestinationPort'});

        # 
        $cpp = SetupVCPPString($cpp);

        # 
        CNT_WriteSipMsg($rframes[0]{'RecvFrame'}->{'Frame_Ether.Packet_IPv4.Upp_UDP.Payload.data'});
    }

    # ICMP
    $sframes[0]{'Send'} = $sendFrame;
    $sframes[0]{'SendModf'} = $cpp;
    $sframes[0]{'SendMode'} = first;

    # 
    $ret = CNT_SendAndRecv(\@sframes, \@sunknown, $SIP_TimeOut, '', $link);

    if ($sframes[0]{'SendFrame'}) {
        $pkt1{pkt} = $sframes[0]{'SendFrame'};
        $pkt1{timestamp} = $pkt1{pkt}->{sentTime1};
        $pkt1{dir} = 'send';
        StoreICMPPktInfo(\%pkt1);
    }
    CheckStatus($ret);

    return $ret;
}


1
