#!/usr/bin/perl
# @@ -- IOex.pm --
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
# 09/1/27  CtIoRecv kCommon::kPacket_Recv
# 08/12/19 KOIRecvStart kPacket_StartRecv
# 08/10/3 CtIoSend,CtIoRecv KOI
# 08/4/18 IsKOIAliveSocket 
# 08/3/17 TAHI,RAW
#   CtIoSendFragment,CtIoRecvFragment 

sub KOIRecvStart {
    my($conn)=@_;
    my($link,$val);
    $conn=CtCnGet($conn);

    # KOI
    $link=$conn->{'Link'} ? $conn->{'Link'} : 'Link0';

    $val=kCommon::kPacket_StartRecv($conn->{'transport'},$conn->{'msg-protocol'}?$conn->{'msg-protocol'}:'SIP',
			   $conn->{'protocol'},$conn->{'local-ip'},$conn->{'local-port'},$link);
    if(!$val || $val->{'Result'}){
	MsgPrint('ERR',"SocketIO[StartRecv:%x] can't communicate\n",$val->{'Result'});
	return 'ERR';
    }
    return $val->{'Result'};
}

sub KOISend {
    return CtIoSend(@_);
}

# UDP
#  
#  
#      connect: Address already in use 
#  (UDP

# 
#  1. 
#       <
#       <
#  2. 
#       KOI
#       recvfrom

# 
#  
#  CtRecvContinue()

# 
sub CtRecvContinue {
    my($conn)=@_;
    CtCnGet($conn)->{'no-auto-close'}='T';
}

sub KOIClose {
    my($conn)=@_;
    if($conn->{'transport'} ne 'TCP'){
	if($conn->{'no-auto-close'}){
	    $conn->{'no-auto-close'}='';
	}
	else{
	    kCommon::kPacket_Close($conn->{'SocketID'},0);
	    $conn->{'SocketID'}='';
	}
    }
}

sub IsKOIAliveSocket {
    my($socketID)=@_;
    if(!$socketID){return;}
    my $ret=kCommon::kPacket_ConnectInfo($socketID);
    return $ret->{'Connection'} eq 2;
}

# 
sub CtIoSendFragment {
    my($conn,$inetPkt,$sndConn,$timestamp)=@_;
    my($fragmentSize,$inetFrag,$pkt,$sendPkt,$nd,$payload,$payloadSize,$more,$offset,$id,$proto,$ret,$l3);

    unless($conn=CtCnGet($conn)){return 'Connection not exit';};

    # 
    $fragmentSize=1510;

    # 
    $pkt = CtPkEncode($inetPkt);
    $sendPkt=[];

    # 
    if(($conn->{'ModuleName'} eq 'TAHI' || $conn->{'ModuleName'} eq 'RAW') && $fragmentSize < $pkt){

	# 
	$inetFrag={'##'=>'INET','#Name#'=>'INET','INET'=>[]};
	foreach $nd (@{$inetPkt->{'INET'}}){
	    if($payload || $nd->{'##'} eq 'UDP' || $nd->{'##'} eq 'TCP' || $nd->{'##'} eq 'ESP'){
		$payload .= CtPkEncode($nd);
	    }
	    else{
		push(@{$inetFrag->{'INET'}},$nd);
	    }
	    if($nd->{'##'} =~ /^IP/){$proto=$nd->{'##'}}
	}
	unless($proto){MsgPrint('ERR',"Send fragment unknown IP header\n");return 'ERR';}
	if($proto eq 'IPV4'){
	    # 
	    $payloadSize = $fragmentSize - length(CtPkEncode($inetFrag))/2;
	    # IPv4
	    if($payloadSize % 8){
		$payloadSize -= ($payloadSize % 8);
	    }
	}
	else{
	    # 
	    $payloadSize = $fragmentSize - length(CtPkEncode($inetFrag))/2 - $L3HDRSIZE{'PROTO.FRAGMENT'};
	}
	# 
	$id = sprintf("%d",rand() * 0xffff);
	if($proto eq 'IPV4'){
	    CtFlSet("INET,#IP4,ID",$inetFrag,'Set',$id);
	}
	else{
	    CtPkAddHex($inetFrag,'FRAGMENT',{'NextPayload'=>CtFlGet("INET,#IP6,NextPayload",$inetFrag),'ID'=>$id});
	    CtFlSet("INET,#IP6,NextPayload",$inetFrag,'Set',$INETFLD{'PROTO.FRAGMENT'});
	    CtFlSet("INET,#IP6,Flowlabel",$inetFrag,'Set',$id);
	}
	$offset=0;
	while($payload){
	    # 
	    $more = ($payloadSize <= length($payload)/2)?1:0;
	    $l3=substr($payload,0,$payloadSize*2);
	    $payload=substr($payload,$payloadSize*2);

	    # 
	    if($proto eq 'IPV4'){
		CtFlSet("INET,#IP4,Flag",$inetFrag,'Set',$more?2:0);
		CtFlSet("INET,#IP4,Fragment",$inetFrag,'Set',$offset);
		$offset += $payloadSize;
	    }
	    else{
		CtFlSet("INET,#Fragment,Mflag",$inetFrag,'Set',$more);
		CtFlSet("INET,#Fragment,Offset",$inetFrag,'Set',$offset);
		# 
		$offset += $payloadSize;
	    }
	    CtPkSetup($inetFrag,$l3);
#	    PrintVal($inetFrag);
	    # 
	    $ret=CtIoSend($conn,CtPkEncode($inetFrag).$l3,$sndConn,$timestamp);
	    push (@$sendPkt,$inetFrag);
	}
    }
    else{
	$ret=CtIoSend($conn,$pkt,$sndConn,$timestamp);
	push(@$sendPkt,$inetPkt);
    }
    return $ret, $inetPkt, $sendPkt;
}

# 
sub CtIoSend {
    my($conn,$msg,$sendconn,$timestamp,$sendedmsg)=@_;
    my($ans,$link);

    $$sendconn=$conn;
    unless($conn=CtCnGet($conn)){return 'Connection not exit';};

    # KOI
    $link=$conn->{'Link'} ? $conn->{'Link'} : 'Link0';

    # 
    if($conn->{'ModuleName'} eq 'SIM'){
	$$timestamp=Time::HiRes::gettimeofday();
	return '';
    }

    # TAHI
    if($conn->{'ModuleName'} eq 'TAHI'){
	$ans=PKTbufSend(pack('H*',$msg));
	$$timestamp=$ans->{'TimeSec'}.'.'.sprintf("%06d",$ans->{'TimeUsec'});
	return '';
    }
    # RAW
    elsif($conn->{'ModuleName'} eq 'RAW'){
	unless(ref($conn->{'SocketID'})){MsgPrint('ERR',"Conn[%s] Raw Socket not exit.\n",$conn->{'ID'});return 'RAW Socket not open';}
	$$timestamp=SendRawPacket($conn->{'SocketID'},substr($msg,$INETFLD{'Ether'}*2));
	return '';
    }
    # PCAP2
    elsif($conn->{'ModuleName'} eq 'PCAP2'){
	unless(ref($conn->{'SocketID'})){MsgPrint('ERR',"Conn[%s] PCAP2 Socket not exit.\n",$conn->{'ID'});return 'PCAP2 Socket not open';}
        ($ans, $$sendedmsg, $$timestamp) = ReadPcap1pkt($conn->{'SocketID'}->{'send'},
							$conn->{'SocketID'}->{'captbl'},'send',$conn->{'SocketID'}->{'send-cond'});
	return $ans;
    }

    # 
    if( $conn->{'SocketID'}){
	# 
	if(IsKOIAliveSocket($conn->{'SocketID'})){
	    # 
##            printf("send sock alive[%s][%s]\n",$conn->{'local-port'},$conn->{'peer-port'});
	    $ans=kCommon::kPacket_Send($conn->{'SocketID'},length($msg),$msg);
	    $conn->{'status'}='continue';
	}
	# 
	else{
	    MsgPrint('WAR',"vSend connection[%s] already closed,so create new connection\n",$conn->{'SocketID'});
	    # 
##            printf("send sock repoen [%s][%s]\n",$conn->{'local-port'},$conn->{'peer-port'});
	    $ans=kCommon::kPacket_ConnectSend($conn->{'transport'},$conn->{'msg-protocol'}?$conn->{'msg-protocol'}:'SIP',$conn->{'protocol'},
				     $conn->{'local-ip'},$conn->{'peer-ip'},
				     $conn->{'local-port'},$conn->{'peer-port'},length($msg),$msg,$link);
	    if($ans && !$ans->{'Result'}){
		$conn->{'status'}='open';
		$conn->{'SocketID'}=$ans->{'SocketID'};
		$conn->{'direction'}='client';
		if($conn->{'transport'} eq 'UDP'){
		    kCommon::kPacket_Close($conn->{'SocketID'},0);$conn->{'SocketID'}='';
		}
	    }
	}
    }
    # 
    else{
##	printf("send new sock [%s][%s]\n",$conn->{'local-port'},$conn->{'peer-port'});
	# 
	$ans=kCommon::kPacket_ConnectSend($conn->{'transport'},$conn->{'msg-protocol'}?$conn->{'msg-protocol'}:'SIP',$conn->{'protocol'},
				 $conn->{'local-ip'},$conn->{'peer-ip'},
				 $conn->{'local-port'},$conn->{'peer-port'},length($msg),$msg,$link);
	# 
	if($ans && !$ans->{'Result'}){
	    $conn->{'SocketID'}=$ans->{'SocketID'};
	    $conn->{'status'}='open';
	    $conn->{'direction'}='client';
	    if($conn->{'transport'} eq 'UDP'){
		kCommon::kPacket_Close($conn->{'SocketID'},0);$conn->{'SocketID'}='';
	      }
	}
    }
    # 
    $$timestamp=sprintf("%s.%03d",$ans->{'TimeStamp'},int($ans->{'TimeStamp2'}/1000));
    return $ans ? $ans->{'Result'} : 'param error';
}

# 
sub CtIoRecvs {
    my($connlist)=@_;
    my($connid,$ret,$recvdata,$recvConn,$timestamp,$ext);

    $ret='NoData';
    # 
    foreach $connid (@$connlist){
	# 
	$ret=CtIoRecv($connid,0,\$recvdata,\$recvConn,\$timestamp,\$ext);
	if(!$ret){
	    return '',$recvConn,length($recvdata),$recvdata,$timestamp,$ext;
	}
    }
    return $ret;
}

sub CtIoRecv {
    my($connID,$timeout,$recvdata,$recvConn,$timestamp,$ext)=@_;
    my($ans,$conn,$data);

    $conn=CtCnGet($connID);

    # 
    if($conn->{'ModuleName'} eq 'SIM'){
	($ans,$$recvdata,$$recvConn,$$timestamp)=SimFileRecv($connID,$timeout);
	return $ans;
    }

    elsif($conn->{'ModuleName'} eq 'RAW'){
	($ans,$data,$$timestamp)=CAPGet();
	if(!$ans){
	    $$recvdata=unpack('H*',$data);
	    $$recvConn=$connID;
	    return '';
	}
	return 'No Data';
    }

    elsif($conn->{'ModuleName'} eq 'TAHI'){
	$data=PKTbufRead($timeout);
	if($data->{'Result'} eq 0 && $data->{'Packet'}){
	    # 
	    $$recvdata=unpack('H*',$data->{'Packet'});
##	    if(1){
	    if($conn->{'FragmentEnable'}){
		$$recvdata = CtIoRecvFragment($conn,$$recvdata);
	    }
	    $$timestamp=$data->{'TimeSec'}.'.'.sprintf("%06d",$data->{'TimeUsec'});
	    $$recvConn=$connID;
	    return '';
	}
	return 'No Data';
    }

    # PCAP
    elsif ($conn->{'ModuleName'} eq 'PCAP') {
        ($ans, $data, $$timestamp) = ReadPcap1pkt($conn->{'SocketID'},'','recv',$conn->{'SocketID'}->{'recv-cond'});
        if ($ans ne '') {
            return $ans;
        }
        $$recvdata = unpack('H*', $data);
        $$recvConn = $connID;
        return '';
    }
    elsif ($conn->{'ModuleName'} eq 'PCAP2') {
	unless($conn->{'SocketID'}->{'recv'}){return 'nodata';}
        ($ans, $data, $$timestamp) = ReadPcap1pkt($conn->{'SocketID'}->{'recv'},$conn->{'SocketID'}->{'captbl'},'recv',
						  $conn->{'SocketID'}->{'recv-cond'});
        if ($ans ne '') {
            return $ans;
        }
	$connID = CtCnMake( {%$conn} ); # 
        $$recvdata = unpack('H*', $data);
        $$recvConn = $connID;
        return '';
    }
    elsif ($conn->{'ModuleName'} ne 'KOI') {
	MsgPrint('ERR',"Unknown module name[%s]\n",$conn->{'ModuleName'});
        return '';
    }    

    # KOI
    $ans=kCommon::kPacket_Recv(0,$timeout);

    if($ans && !$ans->{'Result'}){
	my($connID2);

	# 
	if($connID2=FindConnectionFromSocket($ans->{'SocketID'})){
	    $conn=CtCnGet($connID2);
	}
	# printf("find sock[%s] to conn[%s] tarnsport[%s]\n",$ans->{'SocketID'},$connID2,$conn->{'transport'});
	# printf("!!! KOI can' get protocol DDDDDDDD [%s][%s]\n",$connID,$conn->{'transport'},$ans->{'Protocol'});
	# KOI 
	if(!$connID2 || $conn->{'transport'} eq 'UDP'){
	    # 
	    if($conn->{'transport'} ne 'TCP'){kCommon::kPacket_Close($ans->{'SocketID'},0);$ans->{'SocketID'}='';}

##            printf("koi_recv srcport[%s] dstport[%s]\n",$ans->{'SrcPort'},$ans->{'DstPort'});
	    $connID2 = CtCnMake( {'SocketID'=>$ans->{'SocketID'},'status'=>'open','ModuleName'=>'KOI',
				  'transport'=>$conn->{'transport'}||'UDP',
				  'direction'=>'server','protocol'=>$ans->{'AddrType'} eq 4 ? 'INET' : 'INET6',
				  'local-ip'=>$ans->{'DstAddr'},'local-port'=>$ans->{'DstPort'},
				  'peer-ip'=>$ans->{'SrcAddr'},'peer-port'=>$ans->{'SrcPort'},
				  'Node'=>CtCnGet($connID)->{'Node'}} );
	}
	else{
	    #
	    $conn->{'status'}='continue';
	}
	$$timestamp=sprintf("%s.%03d",$ans->{'TimeStamp'},int($ans->{'TimeStamp2'}/1000));
	$$recvdata=$ans->{'Data'};
	$$recvConn=$connID2;
	$$ext={'koi-result'=>$ans};
	return '';
    }
    return $ans->{'Result'}?$ans->{'Result'}:'IOERR';
}

# 
#   IPSEC
sub CtIoRecvFragment {
    my($conn, $hexPkt)=@_;
    my($inetSt,$frag,$offset);

    # 
    ($inetSt)=CtPkDecode('INET',$hexPkt);

    # IPv6
    if( $frag=CtFlGet('INET,#Fragment',$inetSt) ){
	# UDP ESP 
	if($frag->{'NextPayload'} ne $INETFLD{'PROTO.UDP'} && $frag->{'NextPayload'} ne $INETFLD{'PROTO.ESP'}){
	    MsgPrint('ERR',"Unsupport Fragment Next Payload [%s]\n",$frag->{'NextPayload'});
	}
	else{
	    # 
	    if(!$frag->{'Offset'}){
		$conn->{'FragmentID'}=$frag->{'ID'};
		$conn->{'FragmentPayload'}=$frag->{'Payload'};
		$conn->{'FragmentNextPayload'}=$frag->{'NextPayload'};
		$conn->{'FragmentHeader'}=
##		    unpack('H*',substr($data->{'Packet'},0,length($data->{'Packet'})-length($frag->{'Payload'})/2-8));
		    substr($hexPkt,0,length($hexPkt)-length($frag->{'Payload'})-16);
		MsgPrint('FRAG',"Recv fragmentID [%s] start\n",$conn->{'FragmentID'});
	    }
	    # ID
	    elsif($conn->{'FragmentID'} ne $frag->{'ID'}){
		MsgPrint('ERR',"Unknown fragment ID. expected[%s] != packet[%s]\n",$conn->{'FragmentID'},$frag->{'ID'});
		goto SKIP;
	    }
	    # 
	    elsif($frag->{'Offset'}<=$conn->{'FragmentOffset'}){
		MsgPrint('ERR',"Fragment offset order invalid,  packet[%s] <= received[%s]\n",
			 $frag->{'Offset'},$conn->{'FragmentOffset'});
		goto SKIP;
	    }
	    # 
	    else{
		$conn->{'FragmentPayload'} .= $frag->{'Payload'};
		$conn->{'FragmentOffset'} = $frag->{'Offset'};
		MsgPrint('FRAG',"Recv fragmentID [%s] continue [%s]\n",$conn->{'FragmentID'},$conn->{'FragmentOffset'});
	    }
	    # 
	    unless($frag->{'Mflag'}){
		# IPv6
		my($len);
		$len=length($conn->{'FragmentHeader'});
		$hexPkt =
		    substr($conn->{'FragmentHeader'},0,$len-72) . 
			sprintf('%04x',(length($conn->{'FragmentPayload'})/2) & 0xffff) .  # Payload-length
			sprintf('%02x',$conn->{'FragmentNextPayload'}) .                   # Nextpayload
			substr($conn->{'FragmentHeader'},$len-66) .                        # Hop + Adress x 2
			$conn->{'FragmentPayload'};
		MsgPrint('FRAG',"Recv fragmentID[%s] completed. proto[%x] header[%s] payload[%s]\n",
		       $conn->{'FragmentID'},$conn->{'FragmentNextPayload'},
		       length($conn->{'FragmentHeader'}),length($conn->{'FragmentPayload'}));
		$conn->{'FragmentID'}=$conn->{'FragmentHeader'}=$conn->{'FragmentPayload'}=$conn->{'FragmentOffset'}='';
	    }
	}
    }
    # IPv4
    elsif( ($offset=CtFlGet('INET,#IP4,Fragment',$inetSt)) || (CtFlGet('INET,#IP4,Flag',$inetSt) & 0x02) ){
	# 
	if(!$offset){
	    $conn->{'FragmentID'}=CtFlGet('INET,#IP4,ID',$inetSt);
	    $conn->{'FragmentPayload'}=CtFlGet('INET,#IP4,Payload',$inetSt);
	    $conn->{'FragmentHeader'}=
		substr($hexPkt,0,length($hexPkt)-length($conn->{'FragmentPayload'}));
	    MsgPrint('FRAG',"Recv fragmentID [%s] start\n",$conn->{'FragmentID'});
	}
	# ID
	elsif($conn->{'FragmentID'} ne CtFlGet('INET,#IP4,ID',$inetSt)){
	    MsgPrint('ERR',"Unknown fragment ID. expected[%s] != packet[%s]\n",CtFlGet('INET,#IP4,ID',$inetSt),$frag->{'ID'});
	    goto SKIP;
	}
	# 
	elsif($offset<=$conn->{'FragmentOffset'}){
	    MsgPrint('ERR',"Fragment offset order invalid,  packet[%s] <= received[%s]\n",
		     $offset,$conn->{'FragmentOffset'});
	    goto SKIP;
	}
	# 
	else{
	    $conn->{'FragmentPayload'} .= CtFlGet('INET,#IP4,Payload',$inetSt);
	    $conn->{'FragmentOffset'} = $offset;
	    MsgPrint('FRAG',"Recv fragmentID [%s] continue [%s]\n",$conn->{'FragmentID'},$conn->{'FragmentOffset'});
	}
	# 
	unless( (CtFlGet('INET,#IP4,Flag',$inetSt) & 0x02) ){
	    # IPv4
	    my($len,$inet);
	    $len=length($conn->{'FragmentHeader'});
	    $hexPkt =
		substr($conn->{'FragmentHeader'},0,$len-36) . 
		sprintf('%04x',(length($conn->{'FragmentPayload'})/2 + 8 + 20) & 0xffff) .  # IP Length(Payload + UDP + IP)
		substr($conn->{'FragmentHeader'},$len-32,4) .  # IP ID
		'0000' .                                       # IP Fragment
		substr($conn->{'FragmentHeader'},$len-24) . 
		$conn->{'FragmentPayload'};
	    MsgPrint('FRAG',"Recv fragmentID[%s] completed. proto[%x] header[%s] payload[%s]\n",
		     $conn->{'FragmentID'},$conn->{'FragmentNextPayload'},
		     length($conn->{'FragmentHeader'}),length($conn->{'FragmentPayload'}));
	    $conn->{'FragmentID'}=$conn->{'FragmentHeader'}=$conn->{'FragmentPayload'}=$conn->{'FragmentOffset'}='';
#	    ($inet)=CtPkDecode('INET',$hexPkt);
#	    PrintVal($inet);exit;
	}
    }
SKIP:
    return $hexPkt;
}

# // 
# //  
# //  
# //  
# //  
# //  
# //  
# //  
# int GenericSendIn (int connID,int size,unsigned char *data,void *inparam,
# 				   int **connID2,char *timestamp,void *outparam)

# //
# //  
# //  
# //  
# //  
# //  
# //  
# //  
# //  
# int GenericRecvIn (int connID,int timeOut,void *inparam, 
# 				   int **connID2,int *size,char **buff,char *timestamp,void *outparam)


#============================================
# TAHI
#============================================
sub NewSessionTahiPacket {
    my($connID,$inetSt)=@_;
    my($val,$conn,$protocol,$transport);
    $conn=CtCnGet($connID);
    if($conn->{'ModuleName'} ne 'TAHI' || $conn->{'SocketID'}){return $connID;}

    $val = $INETTypeNameID{CtFlGet('INET,#EH,Type',$inetSt)};
    $protocol = $val eq 'IPV4' ? 'INET' : ($val eq 'IPV6' ? 'INET6' : ($val eq 'VLAN' ? 'VLAN' :'ARP'));
    $transport = CtFlGet('INET,#UDP',$inetSt) ? 'UDP' : (CtFlGet('INET,#TCP',$inetSt) ? 'TCP' : (CtFlGet('INET,#ARP',$inetSt) ? 'ARP' : ''));

    $conn->{'interface'}=$conn->{'interface'}||$conn->{'Node'}->{'AD'}->{'interface'};
    $conn->{'peer-mac'} =CtFlGet('INET,#EH,SrcMac',$inetSt);
    $conn->{'local-mac'}=CtFlGet('INET,#EH,DstMac',$inetSt);
    $conn->{'protocol'}=$protocol;
    $conn->{'peer-ip'}=$protocol eq 'INET' ? CtFlGet('INET,#IP4,SrcAddress',$inetSt):CtFlGet('INET,#IP6,SrcAddress',$inetSt);
    $conn->{'local-ip'}=$protocol eq 'INET' ? CtFlGet('INET,#IP4,DstAddress',$inetSt):CtFlGet('INET,#IP6,DstAddress',$inetSt);
    $conn->{'transport'}=$transport;
    $conn->{'peer-port'}=$transport eq 'UDP' ? CtFlGet('INET,#UDP,SrcPort',$inetSt):
	($transport eq 'TCP' ? CtFlGet('INET,#TCP,SrcPort',$inetSt) : '');
    $conn->{'local-port'}=$transport eq 'UDP' ? CtFlGet('INET,#UDP,DstPort',$inetSt):
			    ($transport eq 'TCP' ? CtFlGet('INET,#TCP,DstPort',$inetSt) : '');
    return $connID;
}

#============================================
# 
#============================================
## DEF.VAR
%RawPacketSock;
## DEF.END

## DEF.VAR
# Raw packet 
%RAWEtherType=(0x0800=>'ip4',0x86dd=>'ip6',0x8100=>'vlan',0x0806=>'arp',0x0835=>'rarp',
	       0x8863=>'pppds',0x8864=>'pppss',
	       'ip4'=>'ip4','ip6'=>'ip6','vlan'=>'vlan','arp'=>'arp','rarp'=>'rarp',
	       'pppds'=>'pppds','pppss'=>'pppss','INET'=>'ip4','INET6'=>'ip6','ARP'=>'arp',);
## DEF.END

# $ifName:'ep0'  $type:[ip4|ip6|vlan|arp|rarp|pppds|pppss]  $srcMac:'00:04:76:f8:55:dd'

# IP

# PKTCAP

# 

#============================================
# 
#============================================

# 
# @_ 

# HEX
# @_ BIN

# BIN
# @_ BIN

# BIN
# @_ 

# 
# @_ 

# 
# @_ 

# 
# 


#============================================
# 
#============================================

sub CtIoOpenUD {
    my ($path,$protocol)=@_;
    if(!$protocol){$protocol='tcp';}
    my ($sock);

    if( !($sock=IO::Socket::UNIX->new(Type=>(($protocol eq 'tcp')?SOCK_STREAM:SOCK_DGRAM),Peer=>$path) )){
	MsgPrint('WAR',"Can't create unix domain socket[$path] protocol[$protocol]\n");
	return;
    }
    $sock->autoflush(1);
    return $sock;
}

# 
sub CtIoReadUD  {
    my ($sock,$size)=@_;
    my ($ret,$data,$i);
    $ret=sysread($sock, $data, $size?$size:2048);

    if($ret){
#	MsgPrint('IO',"data read[". unpack('H' . length($data)*2,$data)."]\n");
##	MsgPrint('IO',"data read[". unpack('H100',$data) ."]\n");
    }
    elsif($ret eq 0){
	return -1;
    }
    return $data;
}

# 
sub CtIoWriteUD {
    my($sock, $data) = @_;
    syswrite($sock, $data, length $data);
##    MsgPrint('IO',"data write[". unpack('H100',$data) ."]\n");
}



#============================================
# 
#============================================

## DEF.VAR
# 
%PKTRequireTemplate=
( 'INET'  =>{'file'=>'INETPkt',  'tbl'=>'INETPacketHexMap'},
  'DHCP'  =>{'file'=>'DHCPpkt',  'tbl'=>'DHCPPacketHexMap'},
  'ICMP'  =>{'file'=>'ICMPpkt',  'tbl'=>'ICMPPacketHexMap'},
  'PPP'   =>{'file'=>'PPPpkt',   'tbl'=>'PPPPacketHexMap'},
  'RTP'   =>{'file'=>'RTPpkt',   'tbl'=>'RTPPacketHexMap'},
  'DNS'   =>{'file'=>'DNSpkt',   'tbl'=>'DNSPacketHexMap'},
  'SSL'   =>{'file'=>'SSLpkt',   'tbl'=>'SSLPacketHexMap'},
  'IKE'   =>{'file'=>'IKEPkt',   'tbl'=>'SSLPacketHexMap'},
  'NTP'   =>{'file'=>'NTPpkt',   'tbl'=>'SSLPacketHexMap'},
  'Radius'=>{'file'=>'RadiusPkt','tbl'=>'RADIUSHexMap'},
  );
## DEF.END

# 

#============================================
# 
#============================================

# 
#   

# 
#   

# Sip





#============================================
# PCAP
#============================================
sub GetPcapConn {
    my($id)=@_;
    return $DIRRoot{'SC'}->{'PCAP'}->{$id};
}
sub SetPcapConn {
    my($id,$conn)=@_;
    $DIRRoot{'SC'}->{'PCAP'}->{$id}=$conn;
}
# PCAP
#  $filter               : 
#  $mode                 : 2way(
#  $sendcond,$recvcond   : 
#  $sendstart,$recvstart : 
sub OpenPcapConn {
    my($id,$filename,$filter,$targetmac,$mode,$sendcond,$recvcond,$sendstart,$recvstart)=@_;
    my($fil,$ret,$pcapid1,$pcapid2);

    if($targetmac && $mode eq '2way'){

	$fil = $filter . ($filter ? ' and ':'') . 'ether dst ' . $targetmac;
	printf("OpenPcapConn [%s]\n",$fil);
        ($ret, $pcapid1) = OpenPcapDmpData($filename, $fil, '', '', $sendstart);
        if ($ret) {
            MsgPrint('ERR', "PCAP file[$filename] filter[%s] open error: $ret",$fil);
            return '';
        }

	$fil = $filter . ($filter ? ' and ':'') . 'ether src ' . $targetmac;
	printf("OpenPcapConn [%s]\n",$fil);
        ($ret, $pcapid2) = OpenPcapDmpData($filename, $fil, '', '', $recvstart);
        if ($ret) {
            MsgPrint('ERR', "PCAP file[$filename] filter[%s] open error: $ret",$fil);
            return '';
        }

	SetPcapConn($id,{'send'=>$pcapid1,'recv'=>$pcapid2,'captbl'=>{'difftime'=>''},'send-cond'=>$sendcond,'recv-cond'=>$recvcond});
    }
    return $id;
}
# PCAP
sub OpenPcapDmpData {
    my ($filename, $filter_str, $optimize, $netmask, $start) = @_;
    my ($pcap, $err, $filter, $ret, $i, %header);

    # PCAP
    $pcap = Net::Pcap::open_offline($filename, \$err);
    if (!defined($pcap)) {
        return "Can't read '$filename': $err\n", '';
    }

    # 
    if(1<$start){
	foreach $i (2..$start){
	    Net::Pcap::next($pcap, \%header);
##	      printf("[%s]",$i);
	  }
    }

    # 
    if ($filter_str ne '' || $optimize ne '' || $netmask ne '') {
	printf("PCAP: cap file open<%s> filter[%s]\n",$filename,$filter_str);
        $ret = Net::Pcap::compile($pcap, \$filter, $filter_str, $optimize, $netmask);
        if ($ret) {
            return "Unable to compile packet filter\n", '';
        }
        Net::Pcap::setfilter($pcap, $filter);
    }

    return '', $pcap;
}


# TCP
#
# TCP
# 
#   Match          : 
#   NoRetarnsFrame : 
#   ValidFrame     : 
#   Session : 
#             Frame      : 
#             LastFrame  : 
#             TCPFrame   : Ether+IP+TCP

# TCP
sub CtIoTCPSessID {
    my($inet)=@_;
    my($srcip,$srcport,$dstip,$dstport);
    $srcip=CtUtV4StrToHex(CtFlGet('INET,#IP4,SrcAddress',$inet)) || CtUtV6StrToHex(CtFlGet('INET,#IP6,SrcAddress',$inet));
    $dstip=CtUtV4StrToHex(CtFlGet('INET,#IP4,DstAddress',$inet)) || CtUtV6StrToHex(CtFlGet('INET,#IP6,DstAddress',$inet));
    $srcport=CtFlGet('INET,#TCP,SrcPort',$inet);
    $dstport=CtFlGet('INET,#TCP,DstPort',$inet);
    return 'TCP:'.$srcip.':'.$srcport.':'.$dstip.':'.$dstport;
}
sub CtIoUDPSessID {
    my($inet)=@_;
    my($srcip,$srcport,$dstip,$dstport);
    $srcip=CtUtV4StrToHex(CtFlGet('INET,#IP4,SrcAddress',$inet)) || CtUtV6StrToHex(CtFlGet('INET,#IP6,SrcAddress',$inet));
    $dstip=CtUtV4StrToHex(CtFlGet('INET,#IP4,DstAddress',$inet)) || CtUtV6StrToHex(CtFlGet('INET,#IP6,DstAddress',$inet));
    $srcport=CtFlGet('INET,#UDP,SrcPort',$inet);
    $dstport=CtFlGet('INET,#UDP,DstPort',$inet);
    return 'UDP:'.$srcip.':'.$srcport.':'.$dstip.':'.$dstport;
}

# TCP 
sub ReadPcap {
    my ($pcap,$header,$mode,$tbl) = @_;
    my($frame,$packet,$unpackmsg,$inet,$status,$frame,$tcp,$sessID,$sess,@sessID,$match);

    # 
    if($tbl){

	# 
	if($tbl->{'Session'}){
	    @sessID=keys(%{$tbl->{'Session'}});
	    foreach $sessID (@sessID){
		$sess=$tbl->{'Session'}->{$sessID};
		if($sess->{'Type'} ne 'TCP'){next;}
		while(1){
		    
		    # 
		    ($status,$sess->{'Frame'},$frame)=$tbl->{'ValidFrame'}->($sess->{'Frame'});
		    
		    # 
		    if($status){last;}
		    
		    # 
		    if($mode eq 'send' && $tbl->{'NoRetarnsFrame'} && $sess->{'LastFrame'} eq $frame){
			my ($node,$peer);
			MsgPrint('WAR',"PCAP Retrans frame. skipped-1\n");
			# 
			($inet)=CtPkDecode('INET',$sess->{'TCPFrame'}.$frame);
			$inet->{'#TimeStamp#'}=sprintf("%d.%06d", $header->{'tv_sec'}, $header->{'tv_usec'});
			if( $node=CtNDGetFromAddr(CtFlGet('INET,#IP4,SrcAddress',$inet)||CtFlGet('INET,#IP6,SrcAddress',$inet)) ){
			    $peer=$node->{'LASTSDPKT'}->{'#peer-id#'}||$node->{'LINK'}->{'LINK'};
			    if(CtUtIsFunc("CtIoAddCapt")){
				CtIoAddCapt($inet, $node, '', $node->{'ID'},$peer);
			    }
			    else{
				CtScAddCapt($node, $inet, 'out','','','','',"$node->{'ID'}:$peer");
			    }
			}
			next;
		    }
		    
		    # 
		    $sess->{'LastFrame'}=$frame;
		    
		    return pack('H*',$sess->{'TCPFrame'}.$frame);
		}
	    }
	}
	
	# 
	while($packet = Net::Pcap::next($pcap, $header)){
	    
	    # TCP
	    $unpackmsg=unpack('H*',$packet);
	    ($inet)=CtPkDecode('INET',$unpackmsg,{'TCP'=>{'undecode-payload'=>'T'},'UDP'=>{'undecode-payload'=>'T'}});

	    # 
	    if($match=$tbl->{'Match'}){
		if(ref($match) eq 'SCALAR'){ unless(eval $$match){next;} }
		elsif(ref($match) eq 'CODE'){unless($match->($inet)){next;}}
		else{unless(CtFlGet($match,$inet)){next;}}
	    }

	    # 
	    if(CtFlGet('INET,#UDP',$inet)){
		# 
		$sessID=CtIoUDPSessID($inet);
		
		# 
		$frame=CtFlGet('INET,#UDP,#PAYLOAD#',$inet);
		
		# 
		unless($frame){next;}

		# 
		$tbl->{'Session'}->{$sessID}->{'Type'} = 'UDP';
		$sess=$tbl->{'Session'}->{$sessID};
		if($mode eq 'send' && $tbl->{'NoRetarnsFrame'} && $sess->{'LastFrame'} eq $frame){
		    my ($node,$peer);
		    MsgPrint('WAR',"PCAP Retrans frame. skipped-2\n");
		    # 
		    ($inet)=CtPkDecode('INET',$unpackmsg);
		    $inet->{'#TimeStamp#'}=sprintf("%d.%06d", $header->{'tv_sec'}, $header->{'tv_usec'});
		    if( $node=CtNDGetFromAddr(CtFlGet('INET,#IP4,SrcAddress',$inet)||CtFlGet('INET,#IP6,SrcAddress',$inet)) ){
			$peer=$node->{'LASTSDPKT'}->{'#peer-id#'}||$node->{'LINK'}->{'LINK'}||$node->{'REL'}->{'LINK'};
			unless($peer){
			    $peer=CtNDGetFromAddr(CtFlGet('INET,#IP4,DstAddress',$inet)||CtFlGet('INET,#IP6,DstAddress',$inet));
			}
			if(CtUtIsFunc("CtIoAddCapt")){
			    CtIoAddCapt($inet, $node, '', $node->{'ID'},$peer);
			}
			else{
			    CtScAddCapt($node, $inet, 'out','','','','',"$node->{'ID'}:$peer");
			}
		    }
		    next;
		}
		$sess->{'LastFrame'} = $frame;
		return $packet;
	    }

	    # 
	    if(!CtFlGet('INET,#TCP',$inet)){return $packet;}
	    
	    # 
	    $sessID=CtIoTCPSessID($inet);

	    # 
	    $frame=CtFlGet('INET,#TCP,#PAYLOAD#',$inet);
	    $tcp=substr($unpackmsg,0,length($unpackmsg)-length($frame));
		
	    # 
	    unless($frame){next;}
	    
	    # 
	    $tbl->{'Session'}->{$sessID}->{'Type'} = 'TCP';
	    $sess=$tbl->{'Session'}->{$sessID};
	    $sess->{'TCPFrame'} = $tcp;
	    $sess->{'Frame'} .= $frame;
	    
	    # 
	    ($status,$sess->{'Frame'},$frame)=$tbl->{'ValidFrame'}->($sess->{'Frame'});
	    
	    # 
	    if($status){next;}
#	    printf("Mode[%s] Last SIP Frame[%s] \n",$mode,pack('H*',$tbl->{'LastFrame'}));
#	    printf("SIP Frame [%s]\n",pack('H*',$frame));
	    
	    # 
	    if($mode eq 'send' && $tbl->{'NoRetarnsFrame'} && $sess->{'LastFrame'} eq $frame){
		my ($node,$peer);
		MsgPrint('WAR',"PCAP Retrans frame. skipped-3\n");
		# 
		($inet)=CtPkDecode('INET',$unpackmsg);
		$inet->{'#TimeStamp#'}=sprintf("%d.%06d", $header->{'tv_sec'}, $header->{'tv_usec'});
		if( $node=CtNDGetFromAddr(CtFlGet('INET,#IP4,SrcAddress',$inet)||CtFlGet('INET,#IP6,SrcAddress',$inet)) ){
		    $peer=$node->{'LASTSDPKT'}->{'#peer-id#'}||$node->{'LINK'}->{'LINK'};
		    if(CtUtIsFunc("CtIoAddCapt")){
			CtIoAddCapt($inet, $node, '', $node->{'ID'},$peer);
		    }
		    else{
			CtScAddCapt($node, $inet, 'out','','','','',"$node->{'ID'}:$peer");
		    }
		}
		next;
	    }
	    
	    # 
	    $sess->{'LastFrame'}=$frame;
##	    printf("##### PCAP2 Frame OK #####\n");
	    return pack('H*',$sess->{'TCPFrame'}.$frame);
	}
    }
    else{
	return Net::Pcap::next($pcap, $header);
    }
    return '';
}

#
# PCAP
#   
#   pcap  : PCAP
#   CapTbl: 
#         difftime:
#         packet:
#         timestamp:
#         response-timestamp:
#   mode  : recv | send
#   cond  : 
#   
# $conn:
sub ReadPcap1pkt {
    my ($pcap,$captbl,$mode,$cond) = @_;
    my ($packet, %header, $timestamp, $packet2, %header2, $caution);

# 

    if($captbl){ # PCAP2
	if($mode eq 'recv'){  # 

	    if( $captbl->{'difftime'} ){
		# 
		if($captbl->{'timestamp'}){
		    if(CtUtGetTimeStamp()>$captbl->{'timestamp'}+$captbl->{'difftime'}){
##		    printf("time OK [%s][%s]\n",CtUtGetTimeStamp(),$captbl->{'timestamp'}+$captbl->{'difftime'});
			# 
			$packet=$captbl->{'packet'};
			$timestamp=$captbl->{'timestamp'};
			# 
			$packet2 = ReadPcap($pcap, \%header2, $mode, $cond);
			if ($packet2 eq '' || !defined(%header2)) {
			    $captbl->{'packet'}='';
			    $captbl->{'timestamp'}='';
			}
			else{
			    $captbl->{'packet'}=$packet2;
			    $captbl->{'timestamp'}=sprintf("%d.%06d", $header2{'tv_sec'}, $header2{'tv_usec'});
			}
		    }
		    else{
##		    printf("time NG [%s][%s]\n",CtUtGetTimeStamp(),$captbl->{'timestamp'}+$captbl->{'difftime'});
			return 'timeout';
		    }
		}
		else{
		    return 'No Data', '', '';
		}
	    }
	    else{
		# 
		$packet = ReadPcap($pcap, \%header, $mode, $cond);
		if ($packet eq '' || !defined(%header)) {
		    return 'No Data', '', '';
		}
		$timestamp = sprintf("%d.%06d", $header{'tv_sec'}, $header{'tv_usec'});
		$captbl->{'difftime'}=CtUtGetTimeStamp()-$timestamp;
		printf("PCAP: 1st data read %s\n",$timestamp,$captbl->{'difftime'});
		# 
		$packet2 = ReadPcap($pcap, \%header2, $mode, $cond);
		if ($packet2 eq '' || !defined(%header2)) {
		    $captbl->{'packet'}='';
		    $captbl->{'timestamp'}='';
		}
		else{
		    $captbl->{'packet'}=$packet2;
		    $captbl->{'timestamp'}=sprintf("%d.%06d", $header2{'tv_sec'}, $header2{'tv_usec'});
		    printf("PCAP: 1st next read %s\n",$captbl->{'timestamp'});
		}
	    }
	}
	else{
	    # 
	    $packet = ReadPcap($pcap, \%header, $mode, $cond);
	    if ($packet eq '' || !defined(%header)) {
		return 'No Data', '', '';
	    }
	    $timestamp = sprintf("%d.%06d", $header{'tv_sec'}, $header{'tv_usec'});
	}
	# 
	if($captbl->{'response-timestamp'} && $timestamp < $captbl->{'response-timestamp'}){
	    $caution = '*** pickup packet timestamp reversed ***';
	}
	$captbl->{'response-timestamp'}=$timestamp;
	printf("PCAP: <%s> [%s] %s\n",$mode,$timestamp,$caution);
    }
    else{
	$packet = ReadPcap($pcap, \%header, $mode, $cond);
	if ($packet eq '' || !defined(%header)) {
	    return 'No Data', '', '';
	}
	$timestamp = sprintf("%d.%06d", $header{'tv_sec'}, $header{'tv_usec'});
    }

    return '', $packet, $timestamp;
}

# PCAP

# PCAP
#   
#   





1;
