#!/usr/bin/perl
# @@ -- INETPkt.pm --
# Copyright (C) NTT Advanced Technology 2007

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
# 08/11/21 Diameter
# 08/10/16 
# 08/7/29  RSVP
#          INETSetupRegist
# 08/3/17 IPv4 FRAGMENT 
#   CtPkInetPacket,CtPkSetup FRAGMENT
# 08/3/11 IPv6 FRAGMENT 
#   Payload

## DEF.VAR
#============================================
# 
#============================================
%INETFLD=
('Ether'           =>14,          # size
 'Ether.DstMac'    =>0,           # pos
 'Ether.SrcMac'    =>6,           # pos
 'Ether.Type'      =>12,          # pos
 'IP4'             =>20,          # size
 'IP4.TTL'         =>0x16,        # pos
 'IP4.Protocol'    =>0x17,        # pos
 'IP4.Checksum'    =>0x18,
 'IP4.SrcAddr'     =>0x1a,        # pos
 'IP4.DstAddr'     =>0x1e,        # pos
 'IP4.UDP.SrcPort' =>0x22,
 'IP4.UDP.DstPort' =>0x24,
 'IP4.UDP.Radius.Code'=>0x2a,     # pos
 'IP4.TCP.SrcPort' =>0x22,
 'IP4.TCP.DstPort' =>0x24,
 'IP4.TCP.Flag'    =>0x2f,        # pos
 'IP4.ICMP.Type'   =>0x22,        # pos
 'IP4.UDP.ISAKMP.InitiatorCookie'         =>0x2a,
 'IP4.UDP.ISAKMP.ResponderCookie'         =>0x32,
 'IP4.UDP.ISAKMP.ExchangeType'            =>0x3c,
 'IP4.UDP.ISAKMP.MessageID'               =>0x3e,
 'IP4.UDP.ISAKMP.ExchangeType.Aggressive' =>4,
 'IP4.UDP.ISAKMP.ExchangeType.Quick'      =>32,
 'IP4.UDP.ISAKMP.ExchangeType.Info'       =>5,
 'IP4.UDP.ISAKMP.ExchangeType.Transaction'=>6,
 'IP4.UDP.ISAKMP.Flag'                    =>0x3d,
 'IP4.ESP.SPI'     =>0x22,
 'IP4.ESP.SEQNO'   =>0x26,
 'IP4.ESP.PAYLOAD' =>0x2a,
 'IP4.ICMP4.Type'  =>0x22,
 'IP6'             =>40,          # size
 'IP6.NextHeader'  =>20,          # pos
 'IP6.SrcAddr'     =>22,          # pos
 'IP6.DstAddr'     =>38,          # pos
 'UDP'             =>8,           # size
 'TCP'             =>20,          # size
 'IP6.UDP.SrcPort' =>0x36,        # pos
 'IP6.UDP.DstPort' =>0x38,        # pos
 'IP6.UDP.ISAKMP.InitiatorCookie'         =>0x3e,   # pos
 'IP6.UDP.ISAKMP.ResponderCookie'         =>0x46,   # pos
 'IP6.UDP.ISAKMP.ExchangeType'            =>0x50,   # pos
 'IP6.UDP.ISAKMP.MessageID'               =>0x52,   # pos
 'IP6.UDP.ISAKMP.Flag'                    =>0x51,   # pos
 'IP6.TCP.SrcPort' =>0x36,
 'IP6.TCP.DstPort' =>0x38,
 'IP6.ESP.SPI'     =>0x36,        # pos
 'IP6.ESP.SEQNO'   =>0x3A,        # pos
 'ICMP4'           =>8,           # size
 'ESP'             =>8,           # size
 'FRAGMENT'        =>8,           # size
 'PROTO.ICMP'      =>1,
 'PROTO.IPV4'      =>4,
 'PROTO.IPV6'      =>41,
 'PROTO.TCP'       =>6,
 'PROTO.UDP'       =>17,
 'PROTO.FRAGMENT'  =>44,
 'PROTO.ESP'       =>50,
 'PROTO.AH'        =>51,
 'PROTO.ICMP6'     =>58,
 'PORT.ISAKMP'     =>500,
 'ICMP.ECHOREQUEST'=>8,
 'ICMP.ECHOREPLY'  =>0,
);
%L3HDRSIZE=
(
 'PROTO.UDP'       =>$INETFLD{'UDP'},
 'PROTO.TCP'       =>$INETFLD{'TCP'},
 'PROTO.ESP'       =>$INETFLD{'ESP'},  
 'PROTO.ICMP'      =>$INETFLD{'ICMP4'},
 'PROTO.FRAGMENT'  =>$INETFLD{'FRAGMENT'},
);

sub INETFLD ($){return $INETFLD{shift @_};}
%INETSERVICE=
(
 53        => 'DNS',
 67        => 'DHCP4',
 68        => 'DHCP4',
 123       => 'NTP',
 500       => 'Udp_ISAKMP',
 546       => 'DHCP6',
 547       => 'DHCP6',
 1812      => 'RADIUS',
 1813      => 'RADIUS',
 3868      => 'DIAMETER',
 5060      => 'SIP',

 'PROTO_ICMP'	        =>1,
 'PROTO_IPV4'		=>4 ,
 'PROTO_ESP'		=>50,
 'PROTO_AH'		=>51,
 'PROTO_DNS'		=>53,
 'PROTO_NTP'		=>123,
 'PROTO_ISAKMP'		=>500,
 'PROTO_RADIUS'	        =>1812,
 'PROTO_RADIUS_AC'	=>1813,
);

# 
sub CtPkAddPort {my($srv,$port)=@_;$INETSERVICE{$port}=$srv;}
# 
sub CtInetService{
    my($srcPort,$dstPort,$payload)=@_;
    my($srv);

    $srv= $INETSERVICE{$srcPort} || $INETSERVICE{$dstPort};

    unless($srv){MsgPrint('WAR',"Unknown inet service port [%s] and [%s]\n",$srcPort,$dstPort);return;}
    if(!ref($srv)){return $srv;}
    elsif(ref($srv) eq 'CODE'){
	return $srv->($payload);
    }
    elsif(ref($srv) eq 'SCALAR'){
	return eval $$srv;
    }
}
# ex) 5060
#   CtPkAddPort(sub{my($palyload)=@_;return (0x80 <= hex(substr($palyload,0,2)))?'SIGCOMP':'SIP'},5060);

%INETTypeNameID =
 (  0x0800 => 'IPV4',
    0x86dd => 'IPV6',
    0x8100 => 'VLAN',
    0x0806 => 'ARP',
    0x8863 => 'PPPoEDS',
    0x8864 => 'PPPoESS',
    0x0835 => 'RARP',
         1 => 'ICMP4',
         2 => 'IGM4',
         6 => 'TCP',
        17 => 'UDP',
        44 => 'FRAGMENT',
        46 => 'RSVP',
        50 => 'ESP',
        51 => 'AH',
        58 => 'ICMP6',
    'IPV4' => 0x0800,
    'IPV6' => 0x86DD,
    'VLAN' => 0x8100,
 'PPPoEDS' => 0x8863,
 'PPPoESS' => 0x8864,
     'ARP' => 0x0806,
    'RARP' => 0x0835,
);
%CtPkTypeName=
 (  0x0800 => 'IPv4(0x0800)',
    0x86dd => 'IPv6(0x86dd)',
    0x8100 => 'Virtual LAN(0x8100)',
    0x8863 => 'PPPoE Discovery Stage(0x8863)',
    0x8864 => 'PPPoE Session Stage(0x8864)',
    0x0806 => 'ARP(0x0806)',
    0x0835 => 'RARP(0x0835)',
    );
%INETProtoName=
 (
  1 => 'ICMP4(1)',
  2 => 'IGM4(2)',
  6 => 'TCP(6)',
  17 => 'UDP(17)',
  50 => 'ESP(50)',
  51 => 'AH(51)',
  58 => 'ICMP6(58)',
    );

# ARP IPv4
%ARPOpID = 
(
 'Request'=>1,
 'Reply'=>2,
 1=>'Request',
 2=>'Reply',
 );

%V6FragmentTxt =
(
 0  => 'End',
 1  => 'Continue',
);

%ARPOpName = 
(
 1=>'Request',
 2=>'Reply',
 );

%TCPOptionsTxt =
(
 0  => 'End of List(0)',
 1  => 'No Operation(1)',
 2  => 'Maximum Segment Size(2)',
 3  => 'Window Scale(3)',
 4  => 'SACK Permitted(4)',
 5  => 'SACK(5)',
 8  => 'Timestamp(8)',
 );

sub CtPkV6Header ($$){
    my($val,$pkt)=@_;
    if($INETTypeNameID{$val} eq 'ICMP6'){
	return $ICMP6TypeToName{hex(substr($pkt,66,2))};
    }
    return $INETTypeNameID{$val};
}
sub CtPkTypeName ($){
    my($val)=@_;
    return $INETTypeNameID{$val};
}

#============================================
# 
#============================================
@INETPacketHexMap = (
 {'##'=>'INET','#Name#'=>'INET',
  'sub'=>{'NM'=>'INET','start'=>'ETHER','pattern'=> ['ETHER','IPV4','IPV6','FRAGMENT','UDP','TCP','Udp_ISAKMP','ICMP4',
						     'ICMP6_ECHOREQUEST','ICMP6_ECHOREPLY','ICMP6_RS','ICMP6_RA','ICMP6_NS','ICMP6_NA','ICMP6_UR',
						     'RADIUS','DIAMETER','ESP','RSVP',
						     'SIP','DNS','DHCP4','DHCP6','ARP','VLAN','NTP','RTP','RTCP','SIGCOMP',
						     'PPPoEDS','PPPoESS','PPPLCP','PPPCHAP','PPPIPCP','PPPCCP']},
 },
 {'##'=>'ETHER','#Name#'=>'EH',
  'field'=>
     [
      {'NM'=>'DstMac',         'EN'=>{'SZ'=>6,'TY'=>'mac'},
                               'DE'=>{'SZ'=>6,'TY'=>'mac'}},
      {'NM'=>'SrcMac',         'EN'=>{'SZ'=>6,'TY'=>'mac'},
                               'DE'=>{'SZ'=>6,'TY'=>'mac'}},
      {'NM'=>'Type',           'EN'=>{'SZ'=>2,'TY'=>'short'},'TXT'=>{'AC'=>\%CtPkTypeName},
                               'DE'=>{'SZ'=>2,'TY'=>'short','AC'=>\'$NX=CtPkTypeName($V)'}}, # 
      ]
 },

 {'##'=>'VLAN','#Name#'=>'VLAN',
  'field'=>
     [
      {'NM'=>'Priority',       'EN'=>{'SZ'=>2,'TY'=>'short','MK'=>1},  'IV'=>0,
                               'DE'=>{'SZ'=>2,'TY'=>'short','MK'=>1}},
      {'NM'=>'CFI',            'EN'=>{'SZ'=>0,'MK'=>3},                'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>3}},
      {'NM'=>'ID',             'EN'=>{'SZ'=>0,'MK'=>12},
                               'DE'=>{'SZ'=>0,'MK'=>12}},
      {'NM'=>'Type',           'EN'=>{'SZ'=>2,'TY'=>'short'},'TXT'=>{'AC'=>\%CtPkTypeName},
                               'DE'=>{'SZ'=>2,'TY'=>'short','AC'=>\'$NX=CtPkTypeName($V)'}}, # 
      ]
 },

 {'##'=>'ARP','#Name#'=>'ARP',
  'field'=>
     [
      {'NM'=>'HWType',         'EN'=>{'SZ'=>2,'TY'=>'short'}, 'IV'=>1,
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
      {'NM'=>'ProtocolType',   'EN'=>{'SZ'=>2,'TY'=>'short'}, 'IV'=>0x800,
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
      {'NM'=>'HWSize',         'EN'=>{'SZ'=>1,'TY'=>'uchar'}, 'IV'=>6,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'ProtocolSize',   'EN'=>{'SZ'=>1,'TY'=>'uchar'}, 'IV'=>4,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'Operation',      'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
      {'NM'=>'SenderMac',      'EN'=>{'SZ'=>6,'TY'=>'mac'},
                               'DE'=>{'SZ'=>6,'TY'=>'mac'}},
      {'NM'=>'SenderIP',       'EN'=>{'SZ'=>4,'TY'=>'ipv4'},
                               'DE'=>{'SZ'=>4,'TY'=>'ipv4'}},
      {'NM'=>'TargetMac',      'EN'=>{'SZ'=>6,'TY'=>'mac'},
                               'DE'=>{'SZ'=>6,'TY'=>'mac'}},
      {'NM'=>'TargetIP',       'EN'=>{'SZ'=>4,'TY'=>'ipv4'},
                               'DE'=>{'SZ'=>4,'TY'=>'ipv4'}},
      ]
  },

 {'##'=>'INET4','#Name#'=>'INET4',
  'sub'=>{'NM'=>'IP4','start'=>'IPV4','pattern'=> ['IPV4','UDP','TCP','ICMP4','RADIUS','SIP','DNS']},
 },

 {'##'=>'INET6','#Name#'=>'INET6',
  'sub'=>{'NM'=>'IP6','start'=>'IPV6','pattern'=> ['IPV6','FRAGMENT','UDP','TCP','Udp_ISAKMP','DNS']},
 },

 {'##'=>'UDPX','#Name#'=>'UDPX',
  'sub'=>{'NM'=>'UDP','start'=>'UDP','pattern'=> ['UDP','SIP','DNS']},
 },

 {'##'=>'TCPX','#Name#'=>'TCPX',
  'sub'=>{'NM'=>'TCP','start'=>'TCP','pattern'=> ['TCP','SIP','DNS']},
 },

 {'##'=>'IPV4','#Name#'=>'IP4',
  'field'=>
     [
      {'NM'=>'Version',        'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>4},  'IV'=>4,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>4}},
      # IP
      {'NM'=>'HeaderLength',   'EN'=>{'SZ'=>0,'MK'=>4},                'IV'=>5,
                               'DE'=>{'SZ'=>0,'MK'=>4}},
      {'NM'=>'DSCP',           'EN'=>{'SZ'=>1,'TY'=>'uchar'},          'IV'=>0,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      # IP
      {'NM'=>'Length',         'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short','AC'=>\q{$HXpkt=substr($HXpkt,0,($V-4)*2)}}},  ## 
      {'NM'=>'ID',             'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
      {'NM'=>'Flag',           'EN'=>{'SZ'=>2,'TY'=>'short','MK'=>4},   'IV'=>0,
                               'DE'=>{'SZ'=>2,'TY'=>'short','MK'=>4}},
      {'NM'=>'Fragment',       'EN'=>{'SZ'=>0,'MK'=>12,'AC'=>\\q{$V/8}}, 'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>12,'AC'=>\q{$F->{Fragment}*=8}}},
      {'NM'=>'TTL',            'EN'=>{'SZ'=>1,'TY'=>'uchar'},          'IV'=>64,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'Protocol',       'EN'=>{'SZ'=>1,'TY'=>'uchar'},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','AC'=>\'$NX=CtPkTypeName($V)'}},
      # IP
      {'NM'=>'Checksum',       'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
      {'NM'=>'SrcAddress',     'EN'=>{'SZ'=>4,'TY'=>'ipv4'},
                               'DE'=>{'SZ'=>4,'TY'=>'ipv4'}},
      {'NM'=>'DstAddress',     'EN'=>{'SZ'=>4,'TY'=>'ipv4'},
                               'DE'=>{'SZ'=>4,'TY'=>'ipv4'}},
      {'NM'=>'Payload',        'EN'=>{'SZ'=>'REST','TY'=>'hex'},  # 
                               'DE'=>{'SZ'=>\q{(($F->{Flag}&0x2)||$F->{Fragment})?'REST':0},'TY'=>'hex'}
                               },
      ]
  },
 {'##'=>'IPV6','#Name#'=>'IP6',
  'field'=>
     [
      {'NM'=>'Version',        'EN'=>{'SZ'=>4,'TY'=>'long','MK'=>4},  'IV'=>6,
                               'DE'=>{'SZ'=>4,'TY'=>'long','MK'=>4}},
      {'NM'=>'Traffic',        'EN'=>{'SZ'=>0,'MK'=>8},               'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>8}},
      {'NM'=>'Flowlabel',      'EN'=>{'SZ'=>0,'MK'=>20,},             'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>20}},
      # 
      {'NM'=>'PayloadLength',  'EN'=>{'SZ'=>2,'TY'=>'short'},
##                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
                               'DE'=>{'SZ'=>2,'TY'=>'short','AC'=>\q{$HXpkt=substr($HXpkt,0,(34+$V)*2)}}},  ## 
      {'NM'=>'NextPayload',    'EN'=>{'SZ'=>1,'TY'=>'uchar'},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','AC'=>\q{$NX=CtPkV6Header($V,$HXpkt)}}},
      {'NM'=>'HopLimit',       'EN'=>{'SZ'=>1,'TY'=>'uchar'},          'IV'=>65,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'SrcAddress',     'EN'=>{'SZ'=>16,'TY'=>'ipv6'},
                               'DE'=>{'SZ'=>16,'TY'=>'ipv6'}},
      {'NM'=>'DstAddress',     'EN'=>{'SZ'=>16,'TY'=>'ipv6'},
                               'DE'=>{'SZ'=>16,'TY'=>'ipv6'}},
      ]
  },
# Payload
 {'##'=>'FRAGMENT','#Name#'=>'Fragment',
  'field'=>
     [
      {'NM'=>'NextPayload',    'EN'=>{'SZ'=>1,'TY'=>'uchar'},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','AC'=>\q{$NX=CtPkV6Header($V,$HXpkt)}}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>0,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'Offset',         'EN'=>{'SZ'=>2,'TY'=>'short','MK'=>15,'AC'=>\q{$F->{'Offset'}/2}},'IV'=>0,
                               'DE'=>{'SZ'=>2,'TY'=>'short','MK'=>15,'AC'=>\q{$F->{'Offset'}=$V*2}}},
      {'NM'=>'Mflag',          'EN'=>{'SZ'=>0,'MK'=>1}, 'TXT'=>{'AC'=>\%V6FragmentTxt},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'ID',             'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'}},
      {'NM'=>'Payload',        'EN'=>{'SZ'=>'REST','TY'=>'hex'},
                               'DE'=>{'SZ'=>'REST','TY'=>'hex'}},
      ]
 },
 {'##'=>'UDP','#Name#'=>'UDP',
  'field'=>
     [
      {'NM'=>'SrcPort',        'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short','AC'=>\q{$NX=$INETSERVICE{$V}}}},
      {'NM'=>'DstPort',        'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short','AC'=>\q{$NX=$INETSERVICE{$V} unless($NX)}}},
      # UDP
      {'NM'=>'Length',         'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short',
				      'AC'=>\q{$F->{'#PAYLOAD#'}=substr($HXpkt,4);
					       if($CTX->{'UDP'}->{'undecode-payload'}){$HXpkt=substr($HXpkt,0,4);}
					       $NX=CtInetService($F->{'SrcPort'},$F->{'DstPort'},$F->{'#PAYLOAD#'}); }}},
      # 
      {'NM'=>'Checksum',       'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
      ]
  },
 {'##'=>'TCP','#Name#'=>'TCP',
  'sub'=>{'NM'=>'opt','AC'=>\q{$SZ=$F->{HeaderLength}*4-20},
	  'pattern'=>['TCPOPT_EOL','TCPOPT_NOP','TCPOPT_MAXSEGSIZE','TCPOPT_WINDSCALE','TCPOPT_TIMESTAMP','TCPOPT_SACKPERMIT','TCPOPT_SACK']},
  'field'=>
     [
      {'NM'=>'SrcPort',        'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short', 'AC'=>\q{$NX=$INETSERVICE{$V}}}},
      {'NM'=>'DstPort',        'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short', 'AC'=>\q{$NX=$INETSERVICE{$V} unless($NX)}}},
      {'NM'=>'SeqNo',          'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>0,
                               'DE'=>{'SZ'=>4,'TY'=>'long'}},
      {'NM'=>'AckNo',          'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>0,
                               'DE'=>{'SZ'=>4,'TY'=>'long'}},
      # #PAYLOAD#
      # 'undecode-payload'
      {'NM'=>'HeaderLength',   'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>4,'AC'=>\q{5+CtPkEncLength($F->{'opt'})/4} },
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>4,
				      'AC'=>\q{$F->{'#PAYLOAD#'}=substr($HXpkt,($V*4-13)*2);
					       if($CTX->{'TCP'}->{'undecode-payload'}){$HXpkt=substr($HXpkt,0,($V*4-13)*2);}
					       $NX=CtInetService($F->{'SrcPort'},$F->{'DstPort'},$F->{'#PAYLOAD#'}); }}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>4},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>4}},
      {'NM'=>'CWR',            'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'ECN-Echo',       'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Urgent-Flag',    'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Ack',            'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Push',           'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reset',          'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Syn',            'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Fin',            'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'WindowSize',     'EN'=>{'SZ'=>2,'TY'=>'short'},'IV'=>0x8000,
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
      # 
      {'NM'=>'Checksum',       'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
      {'NM'=>'Urgent',         'EN'=>{'SZ'=>2,'TY'=>'short'},'IV'=>0,
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
#      {'NM'=>'Options',        'EN'=>{'SZ'=>\'$F->{HeaderLength}*4-20','TY'=>'hex'},
#                               'DE'=>{'SZ'=>\'$F->{HeaderLength}*4-20','TY'=>'hex',AC=>\q{$F->{'#PAYLOAD#'}=$HXpkt;}}},
#      {'NM'=>'Payload',        'EN'=>{'SZ'=>'REST','TY'=>'hex'},
#                               'DE'=>{'SZ'=>'REST','TY'=>'hex'}},
      ]
  },

 {'##'=>'TCPOPT_EOL','#Name#'=>'EOL',
  'field'=>
     [
      {'NM'=>'Kind',           'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>0, 'TXT'=>{'AC'=>\%TCPOptionsTxt},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar', 'PT'=>0}},
      ]
  },
 {'##'=>'TCPOPT_NOP','#Name#'=>'NOP',
  'field'=>
     [
      {'NM'=>'Kind',           'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>1, 'TXT'=>{'AC'=>\%TCPOptionsTxt},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar', 'PT'=>1}},
      ]
  },
 {'##'=>'TCPOPT_MAXSEGSIZE','#Name#'=>'MaxSegSize',    ## RFC 793
  'field'=>
     [
      {'NM'=>'Kind',           'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>2, 'TXT'=>{'AC'=>\%TCPOptionsTxt},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar', 'PT'=>2}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>4,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'SegSize',        'EN'=>{'SZ'=>2,'TY'=>'short'},
                               'DE'=>{'SZ'=>2,'TY'=>'short'}},
      ]
  },
 {'##'=>'TCPOPT_WINDSCALE','#Name#'=>'WindowScale',    ## RFC 1323
  'field'=>
     [
      {'NM'=>'Kind',           'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>3, 'TXT'=>{'AC'=>\%TCPOptionsTxt},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar', 'PT'=>3}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>3,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'Scale',          'EN'=>{'SZ'=>1,'TY'=>'uchar'},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      ]
  },
 {'##'=>'TCPOPT_SACKPERMIT','#Name#'=>'SACKPermit',     ## RFC 2018
  'field'=>
     [
      {'NM'=>'Kind',           'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>4, 'TXT'=>{'AC'=>\%TCPOptionsTxt},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar', 'PT'=>4}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>2,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      ]
  },
 {'##'=>'TCPOPT_SACK','#Name#'=>'SACK',
  'field'=>
     [
      {'NM'=>'Kind',           'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>5, 'TXT'=>{'AC'=>\%TCPOptionsTxt},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar', 'PT'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>1,'TY'=>'uchar'},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'Value',          'EN'=>{'SZ'=>\'$F->{Length}-2','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'$F->{Length}-2','TY'=>'hex'}},
      ]
  },
 {'##'=>'TCPOPT_TIMESTAMP','#Name#'=>'TimeStamp',       ## RFC 1323
  'field'=>
     [
      {'NM'=>'Kind',           'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>8, 'TXT'=>{'AC'=>\%TCPOptionsTxt},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar', 'PT'=>8}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>10,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'TSval',          'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'}},
      {'NM'=>'TSEchoReply',    'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'}},
      ]
  },


 {'##'=>'ESP','#Name#'=>'ESP',
  'field'=>
     [
      {'NM'=>'SPI',            'EN'=>{'SZ'=>4,'TY'=>'long'},'TXT'=>{'AC'=>\q{sprintf('%08x',$V)}},
                               'DE'=>{'SZ'=>4,'TY'=>'long'}},
      {'NM'=>'SequenceNo',     'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'}},
      {'NM'=>'EncData',        'EN'=>{'SZ'=>'REST','TY'=>'hex'},
                               'DE'=>{'SZ'=>'REST','TY'=>'hex'}},
      {'NM'=>'Payload',        'EN'=>{'SZ'=>0,'TY'=>'hex'},'TXT'=>{'AC'=>\q{$V?ESPCapsuleDecode($V,$hexSt):''}},
                               'DE'=>{'SZ'=>0,'TY'=>'hex'}},
      {'NM'=>'IV',             'EN'=>{'SZ'=>0,'TY'=>'hex'},
                               'DE'=>{'SZ'=>0,'TY'=>'hex'}},
      {'NM'=>'PadLength',      'EN'=>{'SZ'=>0,'TY'=>'hex'},
                               'DE'=>{'SZ'=>0,'TY'=>'hex'}},
      {'NM'=>'NextHeader',     'EN'=>{'SZ'=>0,'TY'=>'hex'},'TXT'=>{'AC'=>\%INETProtoName},
                               'DE'=>{'SZ'=>0,'TY'=>'hex'}},
      {'NM'=>'Authenticator',  'EN'=>{'SZ'=>0,'TY'=>'hex'},
                               'DE'=>{'SZ'=>0,'TY'=>'hex'}},
      ]
  },
);

#============================================
# INET 
#============================================
#============================================
# IP/UDP/TCP 
#============================================
$IPID=0x1000;
sub INETETHER($){return $_[0]->{'INET'}->[0];}
sub INETIP   ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?$_[0]->{'INET'}->[2]:$_[0]->{'INET'}->[1];}
sub INETIPx  ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?2:1;}
sub INETPPP  ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?$_[0]->{'INET'}->[2]:$_[0]->{'INET'}->[1];}
sub INETPPPx ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?2:1;}
sub INETUDP  ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?$_[0]->{'INET'}->[3]:$_[0]->{'INET'}->[2];}
sub INETUDPx ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?3:2;}
sub INETTCP  ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?$_[0]->{'INET'}->[3]:$_[0]->{'INET'}->[2];}
sub INETTCPx ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?3:2;}
sub INETESP  ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?$_[0]->{'INET'}->[3]:$_[0]->{'INET'}->[2];}
sub INETICMP ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?$_[0]->{'INET'}->[3]:$_[0]->{'INET'}->[2];}
sub INETUDPPL($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?$_[0]->{'INET'}->[4]:$_[0]->{'INET'}->[3];}
sub CtPkL2x  ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?3:2;}
sub INETL3x  ($){$_[0]->{'INET'}->[0]->{'Type'} eq $INETTypeNameID{'VLAN'}?4:3;}
sub INETPOS  ($$){$INETFLD{$_[0]}+$_[1];}
# sub INETIP($){return $_[0]->{'INET'}->[1];}
# sub INETIPx($){return 1;}
# sub INETUDP($){return $_[0]->{'INET'}->[2];}
# sub INETUDPx($){return 2;}
# sub INETTCP($){return $_[0]->{'INET'}->[2];}
# sub INETTCPx($){return 2;}
# sub INETESP($){return $_[0]->{'INET'}->[2];}
# sub INETICMP($){return $_[0]->{'INET'}->[2];}
# sub INETUDPPL($){return $_[0]->{'INET'}->[3];}
# sub CtPkL2x($){return 2;}
# sub INETL3x($){return 3;}
## DEF.END

sub CtPkInetCreate {
    my($srcMac,$dstMac,$params)=@_;
    my($inet,$type,$param);

    if($params && ref($params) ne 'ARRAY'){$params=[$params];}
    $type=$params ? $params->[0]->{'type'} : 'IPV4'; # PPPoEDS | PPPoESS | VLAN | ARP | RARP | IPV4 | IPV6
    
    $inet={'##'=>'INET','#Name#'=>'INET'};
    CtPkAddHex($inet,'ETHER',{'SrcMac'=>$srcMac||'00:00:00:00:00:00','DstMac'=>$dstMac||'00:00:00:00:00:00','Type'=>$INETTypeNameID{$type}});

    foreach $param (@$params){
	CtPkAddHex($inet->{'INET'},$param->{'type'},$param->{'params'});
    }
    return $inet;
}

# transmit
sub CtPkInetPacket {
    my($conn,$transmit,$dir,$l2ext,$l3ext)=@_;
    my($inet,$protocol,$transport,@params);

    unless(ref($conn)){$conn=CtCnGet($conn);}
    $protocol=$conn->{'protocol'} eq 'INET' ? 'IPV4':($conn->{'protocol'} eq 'INET6' ? 'IPV6' : $conn->{'protocol'});

    # VLAN | PPPoEDS | PPPoESS | ARP | RARP 
    if($transmit){push(@params,ref($transmit) eq 'HASH' ? $transmit:@$transmit);}
    elsif($conn->{'vlan'} ne ''){
	push(@params,{'type'=>'VLAN','params'=>{'ID'=>$conn->{'vlan'},'Type'=>$INETTypeNameID{$protocol}}});
    }

    # INET | INET6  
    $transport=$INETFLD{'PROTO.' . $conn->{'transport'}};
    if($dir eq 'in'){
	push(@params,{'type'=>$protocol,
		      'params'=>{'SrcAddress'=>$conn->{'peer-ip'},'DstAddress'=>$conn->{'local-ip'},'ID'=>$IPID,
				 'NextPayload'=>$transport, 'Protocol'=>$transport, %$l2ext}});
    }
    else{
	push(@params,{'type'=>$protocol,
		      'params'=>{'SrcAddress'=>$conn->{'local-ip'},'DstAddress'=>$conn->{'peer-ip'},'ID'=>$IPID,
				 'NextPayload'=>$transport, 'Protocol'=>$transport, %$l2ext}});
    }

    # IPv6 FRAGMENT 
    if($l3ext->{'type'}){
	push(@params,{'type'=>$l3ext->{'type'},'params'=>{%$l3ext}});
    }
    # UDP | TCP  
    elsif($conn->{'transport'} eq 'UDP' || $conn->{'transport'} eq 'TCP'){
	if($dir eq 'in'){
	    push(@params,{'type'=>$conn->{'transport'},'params'=>{'SrcPort'=>$conn->{'peer-port'},'DstPort'=>$conn->{'local-port'}, %$l3ext}});
	}
	else{
	    push(@params,{'type'=>$conn->{'transport'},'params'=>{'SrcPort'=>$conn->{'local-port'},'DstPort'=>$conn->{'peer-port'}, %$l3ext}});
	}
    }

    if($dir eq 'in'){
	$inet=CtPkInetCreate($conn->{'peer-mac'},$conn->{'local-mac'},\@params);
    }
    else{
	$inet=CtPkInetCreate($conn->{'local-mac'},$conn->{'peer-mac'},\@params);
    }
    # TCP
    if(!$l3ext->{'type'} && $conn->{'transport'} eq 'TCP' && $l3ext->{'#PAYLOAD#'}){
	CtFlGet('INET,#TCP',$inet)->{'#PAYLOAD#'}=$l3ext->{'#PAYLOAD#'};
    }
    return $inet;
}

# Ether
sub CtPkPacketIP {
    my($conn,$dir,$ext)=@_;
    my($inet,$protocol,$transport,@params,$param);

    unless(ref($conn)){$conn=CtCnGet($conn);}
    $protocol=$conn->{'protocol'} eq 'INET' ? 'IPV4':($conn->{'protocol'} eq 'INET6' ? 'IPV6' : $conn->{'protocol'});

    # INET | INET6  
    $transport=$INETFLD{'PROTO.' . $conn->{'transport'}};
    if($dir eq 'in'){
	push(@params,{'type'=>$protocol,
		      'params'=>{'SrcAddress'=>$conn->{'peer-ip'},'DstAddress'=>$conn->{'local-ip'},'ID'=>$IPID,
				 'NextPayload'=>$transport, 'Protocol'=>$transport, %$ext}});
    }
    else{
	push(@params,{'type'=>$protocol,
		      'params'=>{'SrcAddress'=>$conn->{'local-ip'},'DstAddress'=>$conn->{'peer-ip'},'ID'=>$IPID,
				 'NextPayload'=>$transport, 'Protocol'=>$transport, %$ext}});
    }

    # UDP | TCP  
    if($conn->{'transport'} eq 'TCP' || $conn->{'transport'} eq 'UDP'){
	if($dir eq 'in'){
	    push(@params,{'type'=>$conn->{'transport'},'params'=>{'SrcPort'=>$conn->{'peer-port'},'DstPort'=>$conn->{'local-port'}}});
	}
	else{
	    push(@params,{'type'=>$conn->{'transport'},'params'=>{'SrcPort'=>$conn->{'local-port'},'DstPort'=>$conn->{'peer-port'}}});
	}
    }

    $inet={'##'=>'INET','#Name#'=>'INET','INET'=>[]};
    foreach $param (@params){
	CtPkAddHex($inet->{'INET'},$param->{'type'},$param->{'params'});
    }
    return $inet;
}

sub CtPkAddLayer2 {
    my($inet,$l2,$timestamp)=@_;
    $inet->{'INET'}->[CtPkL2x($inet)]=$l2 if($l2);
    $inet->{'#TimeStamp#'} = $timestamp if($timestamp);
}
sub CtPkAddLayer3 {
    my($inet,$l3,$timestamp,$append)=@_;
    if($l3){
	if(ref($l3) eq 'HASH'){
	    if($append){
		push(@{$inet->{'INET'}},$l3);
	    }
	    else{
		$inet->{'INET'}->[INETL3x($inet)]=$l3;
	    }
	}
	elsif(ref($l3) eq 'ARRAY'){
	    my($pos,$tmp);
	    $pos = $append ? $#{$inet->{'INET'}} : INETL3x($inet);
	    foreach $tmp (@$l3){
		$inet->{'INET'}->[$pos++] = $tmp;
	    }
	}
    }
    $inet->{'#TimeStamp#'} = $timestamp if($timestamp);
}
sub CtPkSetUDP {
    my($inet,$srcport,$dstport)=@_;
    if($srcport){$inet->[2]->{'SrcPort'}=$srcport;}
    if($dstport){$inet->[2]->{'DstPort'}=$dstport;}
}

sub CtPkSetup {
    my($inet,$payload,$offset)=@_;
    my($protocol,$ip,$l3,$trans,$ipx,$icmp,$optlen,$no);
    
    for $no (0..$#{$inet->{'INET'}}){
	if($inet->{'INET'}->[$no]->{'##'} =~ /^IP/){$ipx=$no;last;}
    }
##    $ipx=($inet->{'INET'}->[0]->{'##'} =~ /IP/) ? 0 : INETIPx($inet);
    $ip=$inet->{'INET'}->[$ipx];
    $l3=$inet->{'INET'}->[$ipx+1];
    $protocol=$inet->{'INET'}->[$ipx]->{'##'};
    $trans=$inet->{'INET'}->[$ipx+1]->{'##'};
    if($protocol eq 'IPV4'){
	if($trans eq 'TCP'){
	    $ip->{'Protocol'}=$INETFLD{'PROTO.TCP'};
	    unless($payload){
		$payload=CtFlGet('INET,#TCP',$inet)->{'#PAYLOAD#'}||CtPkEncode($inet->{'INET'}->[$ipx+2]);
	    }
	    $optlen=CtPkEncLength($l3->{'opt'});
	    $ip->{'Length'}=$INETFLD{'IP4'}+$L3HDRSIZE{'PROTO.TCP'}+$optlen+length($payload)/2-$offset;
	    $l3->{'HeaderLength'}=($INETFLD{'TCP'}+$optlen)/4;
	    $ip->{'Checksum'}=CtUtIp4ChkSum($ip);
	    $l3->{'Checksum'}=CtUtTCPChkSum($ip,$l3,substr($payload,$offset));
	}
	elsif($trans eq 'UDP'){
	    $ip->{'Protocol'}=$INETFLD{'PROTO.UDP'};
	    unless($payload){
		$payload=CtPkEncode($inet->{'INET'}->[$ipx+2]);
##		printf("playload length[%s][%s]\n",length($payload),$payload);
	    }
	    $ip->{'Length'}=$INETFLD{'IP4'}+$L3HDRSIZE{'PROTO.UDP'}+length($payload)/2-$offset;
	    $l3->{'Length'}=$INETFLD{'UDP'}+length($payload)/2-$offset;
	    $ip->{'Checksum'}=CtUtIp4ChkSum($ip);
	    $l3->{'Checksum'}=CtUtUDPChkSum($ip,$l3,substr($payload,$offset));
	}
	elsif($trans eq 'ESP'){
	    $ip->{'Protocol'}=$INETFLD{'PROTO.ESP'};
	    unless($payload){
		$payload=CtPkEncode($inet->{'INET'}->[$ipx+1]);
		$offset=8;
	    }
	    $ip->{'Length'}=$INETFLD{'IP4'}+$L3HDRSIZE{'PROTO.ESP'}+length($payload)/2-$offset;
	    $ip->{'Checksum'}=CtUtIp4ChkSum($ip);
	}
	elsif($trans =~ /^ICMP/i){
	    $ip->{'Protocol'}=$INETFLD{'PROTO.ICMP'};
	    unless($payload){
		$payload=CtPkEncode($inet->{'INET'}->[$ipx+1]);
		$offset=$L3HDRSIZE{'PROTO.ICMP'};
	    }
	    $ip->{'Length'}=$INETFLD{'IP4'}+$L3HDRSIZE{'PROTO.ICMP'}+length($payload)/2-$offset;
	    $ip->{'Checksum'}=CtUtIp4ChkSum($ip);
	}
	elsif($INETSETUP{$trans}){
	    $ip->{'Length'}=$INETFLD{'IP4'}+$INETSETUP{$trans}($l3,$inet,'IPV4',$ip)-$offset;
	    $ip->{'Checksum'}=IP4CheckSum($ip);
	}
	else{
	    $ip->{'Length'}=$INETFLD{'IP4'}+length($payload)/2-$offset;
	    $ip->{'Checksum'}=CtUtIp4ChkSum($ip);
	}
    }
    elsif($protocol eq 'IPV6'){
	if($trans eq 'TCP'){
	    $ip->{'NextPayload'}=$INETFLD{'PROTO.TCP'};
	    unless($payload){
		$payload=CtFlGet('INET,#TCP',$inet)->{'#PAYLOAD#'};;
	    }
	    $ip->{'PayloadLength'}=$L3HDRSIZE{'PROTO.TCP'}+length($payload)/2-$offset;
	    $l3->{'Length'}=$INETFLD{'TCP'}+length($payload)/2-$offset;
	    $l3->{'Checksum'}=CtUtTCPChkSum($ip,$l3,substr($payload,$offset));
	}
	elsif($trans eq 'UDP'){
	    $ip->{'NextPayload'}=$INETFLD{'PROTO.UDP'};
	    unless($payload){
		$payload=CtPkEncode($inet->{'INET'}->[$ipx+2]);
	    }
	    $ip->{'PayloadLength'}=$L3HDRSIZE{'PROTO.UDP'}+length($payload)/2-$offset;
	    $l3->{'Length'}=$INETFLD{'UDP'}+length($payload)/2-$offset;
	    $l3->{'Checksum'}=CtUtUDPChkSum($ip,$l3,substr($payload,$offset));
	}
	elsif($trans eq 'ESP'){
	    $ip->{'NextPayload'}=$INETFLD{'PROTO.ESP'};
	    unless($payload){
		$payload=CtPkEncode($inet->{'INET'}->[$ipx+1]);
#		printf("playload length[%s][%s]\n",length($payload),$payload);
		$offset=8;
	    }
	    $ip->{'PayloadLength'}=$L3HDRSIZE{'PROTO.ESP'}+length($payload)/2-$offset;
	}
	elsif($trans =~ /^ICMP/i){
	    $icmp=INETICMP($inet);
	    $ip->{'NextPayload'}=$INETFLD{'PROTO.ICMP6'};
	    unless($payload){
		$payload=CtPkEncode($inet->{'INET'}->[$ipx+1]);
		$offset=$L3HDRSIZE{'PROTO.ICMP6'};
	    }
	    $ip->{'PayloadLength'}=$L3HDRSIZE{'PROTO.ICMP6'}+length($payload)/2-$offset;
	    $icmp->{'Checksum'}=CtUtIcmpChkSum($ip,$icmp);
	}
	elsif($trans eq 'FRAGMENT'){
	    $ip->{'PayloadLength'}=$L3HDRSIZE{'PROTO.FRAGMENT'}+length($payload)/2-$offset;
	}
	elsif($INETSETUP{$trans}){
	    $ip->{'PayloadLength'}=$INETSETUP{$trans}($l3,$inet,'IPV6',$ip)-$offset;
	}
    }
    return $inet;
}


# INETSetup
%INETSETUP;
sub INETSetupRegist {
    my($proto,$setup)=@_;
    $INETSETUP{$proto}=$setup;
}


# 
sub CtPkFrameAttr {
    my($inetSt)=@_;
    my($sport,$dport,$type,$proto,$service);

    # 
    $type=$INETTypeNameID{CtFlGet('INET,#EH,Type',$inetSt)};
    if($type eq 'PPPoESS'){
	if(CtFlGet('INET,#LCP',$inetSt)){$proto='LCP';}
	elsif(CtFlGet('INET,#CHAP',$inetSt)){$proto='CHAP';}
	elsif(CtFlGet('INET,#IPCP',$inetSt)){$proto='IPCP';}
	elsif(CtFlGet('INET,#CCP',$inetSt)){$proto='CCP';}
    }
    elsif( CtFlGet('INET,#IP4',$inetSt) ){
	$proto=CtFlGet('INET,#IP4,Protocol',$inetSt);
	$proto=$INETTypeNameID{$proto}?$INETTypeNameID{$proto}:$proto;
	if($proto eq 'UDP'){
	    $sport=CtFlGet('INET,#UDP,SrcPort',$inetSt);
	    $dport=CtFlGet('INET,#UDP,DstPort',$inetSt);
	    $service=$INETSERVICE{$dport};
	}
    }
    elsif( CtFlGet('INET,#IP6',$inetSt) ){
	$proto=CtFlGet('INET,#IP6,NextPayload',$inetSt);
	$proto=$INETTypeNameID{$proto}?$INETTypeNameID{$proto}:$proto;
	if($proto eq 'UDP'){
	    $sport=CtFlGet('INET,#UDP,SrcPort',$inetSt);
	    $dport=CtFlGet('INET,#UDP,DstPort',$inetSt);
	    $service=$INETSERVICE{$dport};
	}
	if($proto eq 'ICMP6'){
	    $service=$ICMP6TypeID{CtFlGet('INET,ICMPType',$inetSt)};
	}
    }
    return $type,$proto,$service;
}


# @@ -- TCPsvc.pm --

# use strict;

## DEF.VAR
# TCP 
%TCPStatus = 
(
 'LISTEN'    =>0,
 'SYN-SEND'  =>1,
 'SYN-RECV'  =>2,
 'ESTABLISH' =>3,
 'FIN-WAIT1' =>4,
 'FIN-WAIT2' =>5,
 'CLOSEING'  =>6,
 'LAST-ACK'  =>7,
 'TIME-WAIT' =>8,
 'CLOSED'    =>9,
 'LISTEN-ACCEPT' => -1,
 );

# 
$TCPMSS = 1440;
# $TCPMSS=5;

# TCP
$TCPRTT = 2;

# 
$TCPWINDOWSIZE = 0x2000;

#
# 
#
#  { 'peer-ip'=> ..., 'TCP'=>{'Status'=>...} }
#
#
#  State          : TCP
#  SeqNo          : 
#  AckNo          : 
#  MSS            : 
#  WaitingData    : 
#  WindowSize     : 
#  UnRecvAckData  : 
#  UnSeqNoData    : 
#  RecvData       : 
#  ReserveRecvData: 
#                     {INET=>IP/TCP
#  PayloadDecode  : 
#  ActionMode     : 
#
#  
#    CONNECTED    : 
#    SENDED       : 
#    DATA         : 
#    RECV         : 
#    CLOSED       : 
#    ERROR        : 


#============================================
# TCP 
#============================================
#
# TCP
#  
%TCPActionTbl = 
(
 'LISTEN'    =>{'SYN'    =>{'AC'=>'TCPListenSYN',     'NX'=>'SYN-RECV'},},
 'SYN-SEND'  =>{'SYN+ACK'=>{'AC'=>'TCPSynSendSYNACK', 'NX'=>'ESTABLISH'},
		'RST'    =>{'AC'=>'TCPRST',           'NX'=>'CLOSED'},},
 'SYN-RECV'  =>{'ACK'    =>{'AC'=>'TCPSynRecvACK',    'NX'=>'ESTABLISH'},
		'RST'    =>{'AC'=>'TCPRST',           'NX'=>'CLOSED'},},
 'ESTABLISH' =>{'ACK'    =>{'AC'=>'TCPEstablishACK',  'NX'=>'ESTABLISH'},
		'DATA'   =>{'AC'=>'TCPEstablishDATA', 'NX'=>'ESTABLISH'},
		'Send'   =>{'AC'=>'TCPEstablishSEND', 'NX'=>'ESTABLISH'},
		'FIN'    =>{'AC'=>'TCPEstablishFIN',  'NX'=>'LAST-ACK'},
		'RST'    =>{'AC'=>'TCPRST',           'NX'=>'CLOSED'},
		'Reset'  =>{'AC'=>'TCPEstablishRESET','NX'=>'CLOSED'},
		'Close'  =>{'AC'=>'TCPEstablishCLOSE','NX'=>'FIN-WAIT1'}},
 'FIN-WAIT1' =>{'ACK'    =>{'AC'=>'TCPFinWait1ACK',   'NX'=>'FIN-WAIT2'},
		'FIN'    =>{'AC'=>'TCPFinWait1FIN',   'NX'=>'CLOSEING'},},
 'FIN-WAIT2' =>{'FIN'    =>{'AC'=>'TCPFinWait2FIN',   'NX'=>'CLOSED'},},
 'CLOSEING'  =>{'ACK'    =>{'AC'=>'TCPCloseingACK',   'NX'=>'CLOSED'},},
 'LAST-ACK'  =>{'ACK'    =>{'AC'=>'TCPLastAckACK',    'NX'=>'CLOSED'},},
 'CLOSED'    =>{'Connect'=>{'AC'=>'TCPClosedConnect', 'NX'=>'SYN-SEND'},
		'Send'   =>{'AC'=>'TCPClosedSend',    'NX'=>'SYN-SEND'},
	        'Listen' =>{'AC'=>'TCPClosedListen',  'NX'=>'LISTEN'},},
);
## DEF.END

#============================================
# TCP 
#============================================

#============================================
# TCP 
#============================================
# 
# 
# 

# 

# 

# 


# 
#   CONTINUE:

# 

# 


#============================================
# TCP
#============================================


#============================================
# TCP 
#   
#      
#      
#      
#============================================

# 

# 

# 

# SYN 

# SYN+ACK

# ACK

# 

# 

# 
#   

# 

# 

# 


# FIN 





# 

#============================================
# 
#============================================

#============================================
# TCP 
#============================================

#============================================
# TCP 
#============================================


#============================================
# TCP 
#============================================

#============================================
# TCP 
#============================================

#============================================
# TCP 
#     
#============================================

#============================================
# TCP 
#============================================

# 


#============================================
# 
#============================================
# dir:in|out


#============================================
# TCP
#============================================

# TCP


# TCP
# TCPAddOption($inet,'TCPOPT_WINDSCALE',{'Kind'=>100});

# 


# 

#============================================
# TCP 
#============================================


#============================================
# TCP 
#============================================

# 

# 
#  $accept TRUE:

# 


#============================================
# 
#
#   
#     
#                      
#                     
#   
#     
#     
#     
#
#============================================

# SIP
sub CtPkSIPEextractPkt {
    my($hexdata)=@_;
    my($txt,$pattrn,$clen,$header,$body,$rest,$payloadinet,$reserve);

    # HEX
    $txt=pack('H*',$hexdata);

    # SIP
    $pattrn='(^(?:.+)(?:\x0D\x0A)(?:.+(?:\x0D\x0A))+(?:\x0D\x0A))((?:.+(?:\x0D\x0A)?)*)$';

    # Content-Length
    $clen='Content-Length:\s*([0-9]+)';

    # SIP
    if($txt =~ /$pattrn/){
	$header=$1;
	$body=$2;
	# Content-Length
	if($txt =~ /$clen/){
	    $body=substr($body,0,$1);
	    $rest=substr($body,$1);

	    # $rest
            if($rest =~ /^[\s\x0D\x0A]+(.*)$/g){
		$rest=$1;
	    }

	    # SIP
	    ($payloadinet)=CtPkDecode('SIP',unpack('H*',$header.$body));

            # 
            # $reserve = ...

	    # 
	    return '',unpack('H*',$rest),{'SIP'=>$payloadinet},$reserve;
	}
	# Content-Length
	# SIP
	($payloadinet)=CtPkDecode('SIP',unpack('H*',$txt));
	return '','',{'SIP'=>$payloadinet},$reserve;
    }
    # 
    return 'NG',$hexdata;
}


# @@ -- XMLPkt.pm --
# Copyright (C) NTT Advanced Technology 2007
#
# use strict;

# 
use XML::TreePP;

sub XMLHexDEcode {
    my($xml)=@_;
    my($tpp);
    $tpp = XML::TreePP->new();
    $tpp->set(text_node_key => 'txt');
#    $tpp->set(cdata_scalar_ref => 1);
#    $tpp->set(attr_prefix => '-'); # 
#    $tpp->set(force_array => ['XMLSetDetail']);
    return $tpp->parse($xml);
}

1;
