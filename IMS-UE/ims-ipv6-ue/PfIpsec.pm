#!/usr/bin/perl
# @@ -- IPSECsvc.pm --

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
# 09/2/19 Crypt::CBC
#         Crypt::OpenSSL::AES

#============================================
# 
#============================================
# 
sub IKEPrf {
    my($algo,$key,@data)=@_;
    my($digest,$data);

    # 
    $data=join('',@data);

    # 
    if($algo =~ /hmac-sha/){
	$digest=IKEHmacSHA1($key,$data);
    }
    else{
	$digest=IKEHmacMD5($key,$data);
    }
    return $digest;
}
sub IKEHmacMD5 {
    my($key,$data)=@_;
    my($hmac,$digest,%ret);

    $hmac = Digest::HMAC_MD5->new(pack('H' . length($key), $key));
    $hmac->add(pack('H' . length($data), $data));
    $digest=$hmac->hexdigest;

    return $digest;
}
sub IKEHmacSHA1 {
    my($key,$data)=@_;
    my($hmac,$digest,%ret);
    $hmac = Digest::HMAC_SHA1->new(pack('H' . length($key), $key));
    $hmac->add(pack('H' . length($data), $data));
    $digest=$hmac->hexdigest;
    return $digest;
}
sub IKESHA1 {
    my($data)=@_;
    my($ctx);

    $ctx = Digest::SHA1->new;
    $ctx->add(pack('H' . length($data), $data));
    return $ctx->hexdigest;
}
sub IKEMD5 {
    my($data)=@_;
    return Digest::MD5::md5_hex( pack('H' . length($data), $data) );
}


#============================================
# ESP
#============================================
sub ESPIPSetup {
    my($inet,$payload,$offset)=@_;
    my($protocol,$ip);
    
    $ip=INETIP($inet);
    $protocol=$INETTypeNameID{$inet->{'INET'}->[0]->{'Type'}};
    if($protocol eq 'IPV4'){
	$ip->{'Protocol'}=$INETFLD{'PROTO.ESP'};
	$ip->{'Length'}=$INETFLD{'IP4'}+$L3HDRSIZE{'PROTO.ESP'}+length($payload)/2-$offset;
	$ip->{'Checksum'}=CtUtIp4ChkSum($ip);
    }
    else{
	$ip->{'NextPayload'}=$INETFLD{'PROTO.ESP'};
	$ip->{'PayloadLength'}=$L3HDRSIZE{'PROTO.ESP'}+length($payload)/2-$offset;
    }
    return $inet;
}


#   
sub ESPTransportPayload {
    my($connID,$saInst,$payloadProto,$payload)=@_;
    
    # 
    CtCnGet($connID)->{'transport'}='';

    # payloadProto 
    # payload UDP|TCP
    return ESPTunnelPayload($connID,$saInst,$payloadProto,$payload);
}

# 
sub ESPTunnelPayload {
    my($connID,$saInst,$payloadProto,$payload)=@_;
    my($inetSt,$pad,$cbc,$i,$padstr,$ive,$key,$hexmsg,$cipher,$calcHash,$plane,$authSize);

    # 
    ESPUpdateSeqNo($saInst);

    # 
    $cbc=$AKADoi{$saInst->{'encAlgo'}}->{'cbcBlock'};
    $pad = $cbc - (length($payload)/2 + 2) % $cbc;
    if($pad eq $cbc){$pad=0;}

    # 
    for $i (1..$pad){$padstr .=sprintf('%02x',$i);}
    $plane=$payload . $padstr . sprintf('%02x%02x',$pad,$payloadProto);

    $hexmsg=$plane;
    if($saInst->{'encAlgo'} !~ /null/i){
	# 
	$ive=pack('H' . length($saInst->{'IV'}),$saInst->{'IV'});
	$key=pack('H' . length($saInst->{'encKey'}),$saInst->{'encKey'});
	$hexmsg=pack('H*',$plane);
	
	# 
	$cipher = Crypt::CBC->new( {'key'             => $key,
				    'keysize'         => length($key),
				    'cipher'          => $AKADoi{$saInst->{'encAlgo'}}->{'cipher'},
				    'iv'              => $ive,
				    'regenerate_key'  => 0,
#				    'literal_key'     => 1,  'regenerate_key'=0 
				    'padding'         => \&IPSEC_padding,
				    'prepend_iv'      => 0
				    });
	$hexmsg=$cipher->encrypt_hex($hexmsg);
    }
    if(CtLgLevel('AUTH')){
	printf("===== Encrypt Packet ====\n");
	printf("  IV      [%s]\n",unpack('H16',$ive));
	printf("  ENCkey  [%s]\n",unpack('H48',$key));
	printf("  IKEEncAlgo[%s]\n",$AKADoi{$saInst->{'encAlgo'}}->{'cipher'});
	printf("  Padding [%s]\n",$pad);
	printf("  NextProt[%s]\n",$payloadProto);
	printf("  Plane   [%s]\n",$plane);
	printf("  Crypt   [%s]\n",$hexmsg);
	printf("===========================\n");
    }

    # 
    $hexmsg = sprintf('%08x%08x%s',$saInst->{'spi'},$saInst->{'seqno'},
		      ($saInst->{'encAlgo'} !~ /null/i) ? $saInst->{'IV'} : '') . $hexmsg;

    # ESP
    $calcHash=IKEPrf($saInst->{'authAlgo'},$saInst->{'authKey'},$hexmsg);
    $authSize=$AKADoi{$saInst->{'authAlgo'}}->{'length'}/8;
    if(CtLgLevel('AUTH')){
	printf("===== Auth Calc ====\n");
	printf("  Algo[%s] Key[%s] AuthSize[%s]\n",$saInst->{'authAlgo'},$saInst->{'authKey'},$authSize);
	printf("  payload [%s]\n",$hexmsg);
	printf("  CalcAuth[%s]\n",$calcHash);
	printf("===========================\n");
    }

    # 
    $hexmsg .= substr($calcHash,0,$authSize*2);
    $saInst->{'IV'}=substr($hexmsg,length($hexmsg)-$cbc*2,$cbc*2);

    # IKE
    $inetSt=CtPkInetPacket($connID);

    # HEX
    CtPkAddHex($inetSt,'ESP',{'SPI'=>$saInst->{'spi'},'SequenceNo'=>$saInst->{'seqno'},
			     'EncData'=>substr($hexmsg,16),'Payload'=>$payload,
			     'PadLength'=>$pad,'NextHeader'=>$payloadProto,'IV'=>unpack('H16',$ive),
			     'Authenticator'=>substr($calcHash,0,$authSize*2)});
    return $inetSt;
}

# ESP
sub ESPDecryptPacket {
    my($inetSt,$conn)=@_;
    my($spi,$seqNo,$saInst,$authSize,$esp,$payload,$calcHash,$iv,$cbc,$cipher,$cryptMsg,$key,$hexmsg,$nextProto,$pad,$authData,$ext);

    # SPI,SeqNo
    $spi=CtFlGet('INET,#ESP,SPI',$inetSt);
    $seqNo=CtFlGet('INET,#ESP,SequenceNo',$inetSt);

    # SA
    if(!($saInst=CtFindSA($spi,'in'))){
	MsgPrint('AKA',"ESP spi[%s] can't find SA list\n",$spi);
	return;
    }

    # 
    if($seqNo < $saInst->{'seqno'}){
	MsgPrint('AKA',"ESP spi[%s] seqno[%s < %s] invalid\n",$spi,$seqNo,$saInst->{'seqno'});
	return;
    }

    # 
    $authSize=$AKADoi{$saInst->{'authAlgo'}}->{'length'}/8;
    $esp=CtPkEncode(CtFlGet('INET,#ESP',$inetSt));
    $authData=substr($esp,length($esp)-$authSize*2);
    $payload=substr($esp,0,length($esp)-$authSize*2);

    # ESP

    $calcHash=IKEPrf($saInst->{'authAlgo'},$saInst->{'authKey'},$payload);
    if(CtLgLevel('AUTH')){
	printf("===== Auth Check ====\n");
	printf("  Algo[%s] Key[%s] AuthSize[%s]\n",$saInst->{'authAlgo'},$saInst->{'authKey'},$authSize);
	printf("  size    [%s]\n",length($payload)-$authSize*2);
	printf("  payload [%s]\n",$payload);
	printf("  Auth    [%s]\n",$authData);
	printf("  CalcAuth[%s]\n",$calcHash);
	printf("===========================\n");
    }
    if(substr($calcHash,0,$authSize*2) ne $authData){
	return;
    }

    # NULL
    if($saInst->{'encAlgo'} !~ /null/i){
	# CBC
	$cbc=$AKADoi{$saInst->{'encAlgo'}}->{'cbcBlock'};
	$iv=substr($payload,8*2,$cbc*2);
	$cryptMsg=$hexmsg=substr($payload,8*2+$cbc*2);
	# 
	$iv=pack('H' . length($iv),$iv);
	$key=pack('H' . length($saInst->{'encKey'}),$saInst->{'encKey'});
	
	# 
	$cipher = Crypt::CBC->new( {'key'             => $key,
				    'keysize'         => length($key),
				    'cipher'          => $AKADoi{$saInst->{'encAlgo'}}->{'cipher'},
				    'iv'              => $iv,
				    'regenerate_key'  => 0,
#				    'literal_key'     => 1,
				    'prepend_iv'      => 0,
				    'padding'         => \&IPSEC_padding,
				});
	$hexmsg=unpack('H*',$cipher->decrypt_hex($hexmsg));
    }
    else{
	$hexmsg=substr($payload,8*2);
    }

    # 
    $nextProto=hex(substr($hexmsg,length($hexmsg)-2,2));
    $pad=hex(substr($hexmsg,length($hexmsg)-4,2));
    $payload=substr($hexmsg,0,length($hexmsg)-$pad*2-4);

    if(CtLgLevel('AUTH')){
	printf("===== Decrypt Packet ====\n");
	printf("  IV      [%s]\n",unpack('H16',$iv));
	printf("  ENCkey  [%s]\n",unpack('H48',$key));
	printf("  IKEEncAlgo[%s]\n",$AKADoi{$saInst->{'encAlgo'}}->{'cipher'});
	printf("  Crypt   [%s]\n",$cryptMsg);
	printf("  DeCrypt [%s]\n",$hexmsg);
	printf("  Padding [%s]\n",$pad);
	printf("  NextProt[%s]\n",$nextProto);
	printf("  Payload [%s]\n",$payload);
	printf("===========================\n");
    }

    # 
    $esp=CtFlGet('INET,#ESP',$inetSt);
    $esp->{'IV'}=unpack('H16',$iv);
    $esp->{'Payload'}=$payload;
    $esp->{'EncData'}=$cryptMsg;
    $esp->{'PadLength'}=$pad;
    $esp->{'NextHeader'}=$nextProto;
    $esp->{'Authenticator'}=$authData;

    # hexSt
    $inetSt={%$inetSt,%$ext};
    if($nextProto eq $INETFLD{'PROTO.UDP'}){
	($payload)=CtPkDecode('UDP',$payload);
    }
    elsif($nextProto eq $INETFLD{'PROTO.TCP'}){
	($payload)=CtPkDecode('TCP',$payload);
    }
    else{
	MsgPrint('WAR',"Unsupported ESP next protocol[%s]\n",$nextProto);
    }
    push(@{$inetSt->{'INET'}},$payload);

    # 
    CtCnGet($conn)->{'spi'}=$spi;

    return $inetSt;
}

# 
sub ESPUpdateSeqNo {
    my($saInst)=@_;

    if($saInst->{'seqno'}){
	$saInst->{'seqno'}++;
	if(!($saInst->{'seqno'})){$saInst->{'seqno'}=1;}
    }
    else{
	# 
	$saInst->{'seqno'}=1;
	$saInst->{'IV'}=ESPNewIV($saInst->{'encAlgo'});
    }
}
# ESP
sub ESPNewIV {
    my($encAlgo)=@_;
    my $size=$AKADoi{$encAlgo}->{'cbcBlock'};
    return $size ? CtRandom($size) : '';
}

#============================================
# 
#============================================
sub ESPMatchPacket {
    my($msg,$connID,$ext,$node,$param)=@_;
    my($saInst,$inetSt,$spi,$seqNo,$payload,$authData,$calcHash,$cryptMsg,$iv,$esp,
       $authSize,$key,$cipher,$hexmsg,$nextProto,$pad,$cbc,$nxt,$hexString);

    MsgPrint('PRMT',"----ESPMatchPacket-----\n");

    if(ref($msg)){
	$inetSt=$msg;
    }
    else{
	($inetSt,$nxt,$hexString)=CtPkDecode('INET',$msg);
    }

    # 

    # ESP
    unless(CtFlGet('INET,#ESP',$inetSt)){return '',$inetSt;}
    
    # SPI,SeqNo
    $spi=CtFlGet('INET,#ESP,SPI',$inetSt);
    $seqNo=CtFlGet('INET,#ESP,SequenceNo',$inetSt);

    # SA
    if(!($saInst=CtFindSA($spi,'in'))){return '',$inetSt;}

    # 
    if($seqNo < $saInst->{'seqno'}){return '',$inetSt;}

    # 
    $authSize=$AKADoi{$saInst->{'authAlgo'}}->{'length'}/8;
    $esp=CtPkEncode(CtFlGet('INET,#ESP',$inetSt));
    $authData=substr($esp,length($esp)-$authSize*2);
    $payload=substr($esp,0,length($esp)-$authSize*2);

    # ESP
    $calcHash=IKEPrf($saInst->{'authAlgo'},$saInst->{'authKey'},$payload);
    if(CtLgLevel('AUTH')){
	printf("===== Auth Check ====\n");
	printf("  Algo[%s] Key[%s] AuthSize[%s]\n",$saInst->{'authAlgo'},$saInst->{'authKey'},$authSize);
	printf("  size    [%s]\n",length($payload)-$authSize*2);
	printf("  payload [%s]\n",$payload);
	printf("  Auth    [%s]\n",$authData);
	printf("  CalcAuth[%s]\n",$calcHash);
	printf("===========================\n");
    }
    if(substr($calcHash,0,$authSize*2) ne $authData){return '',$inetSt;}

    # NULL
    if($saInst->{'encAlgo'} !~ /null/i){
	# CBC
	$cbc=$AKADoi{$saInst->{'encAlgo'}}->{'cbcBlock'};
	$iv=substr($payload,8*2,$cbc*2);
	$cryptMsg=$hexmsg=substr($payload,8*2+$cbc*2);
	# 
	$iv=pack('H' . length($iv),$iv);
	$key=pack('H' . length($saInst->{'encKey'}),$saInst->{'encKey'});
	
	# 
	$cipher = Crypt::CBC->new( {'key'             => $key,
				    'keysize'         => length($key),
				    'cipher'          => $AKADoi{$saInst->{'encAlgo'}}->{'cipher'},
				    'iv'              => $iv,
				    'regenerate_key'  => 0,
#				    'literal_key'     => 1,
				    'prepend_iv'      => 0,
				    'padding'         => \&IPSEC_padding,
				});
	$hexmsg=unpack('H*',$cipher->decrypt_hex($hexmsg));
    }
    else{
	$hexmsg=substr($payload,8*2);
    }

    # 
    $nextProto=hex(substr($hexmsg,length($hexmsg)-2,2));
    $pad=hex(substr($hexmsg,length($hexmsg)-4,2));
    $payload=substr($hexmsg,0,length($hexmsg)-$pad*2-4);

    if(CtLgLevel('AUTH')){
	printf("===== Decrypt Packet ====\n");
	printf("  IV      [%s]\n",unpack('H16',$iv));
	printf("  ENCkey  [%s]\n",unpack('H48',$key));
	printf("  IKEEncAlgo[%s]\n",$AKADoi{$saInst->{'encAlgo'}}->{'cipher'});
	printf("  Crypt   [%s]\n",$cryptMsg);
	printf("  DeCrypt [%s]\n",$hexmsg);
	printf("  Padding [%s]\n",$pad);
	printf("  NextProt[%s]\n",$nextProto);
	printf("  Payload [%s]\n",$payload);
	printf("===========================\n");
    }

    # 
    $esp=CtFlGet('INET,#ESP',$inetSt);
    $esp->{'IV'}=unpack('H16',$iv);
    $esp->{'Payload'}=$payload;
    $esp->{'EncData'}=$cryptMsg;
    $esp->{'PadLength'}=$pad;
    $esp->{'NextHeader'}=$nextProto;
    $esp->{'Authenticator'}=$authData;

    # hexSt
    $inetSt={%$inetSt,%$ext};
    MsgPrint('PRMT',"Received ESP message\n");

    return 'OK', $inetSt, {'INHERIT-SA'=>$saInst};
}

# IPsec
#   
#   
sub IPSEC_padding ($$$) {
  my ($b,$bs,$decrypt) = @_;
  my($pad,$count);
##  PrintVal(\@_);
  if ($decrypt eq 'd') {
     return $b;
  }
  if(!(length $b)){ # 
#      $pad= pack("C*", (0) x ($bs-1), $bs-1);
       $pad = '';
  }
  else{
      $count=$bs - length($b) % $bs - 1;
      if(0<$count){
	  $pad= $b . pack("C*", (0) x ($count),$count);
      }
      else{
	  $pad= $b . pack("C*", (0) x ($count+1));
      }
  }
## PrintItem(unpack('H16',$pad));
  return $pad;
}

# 
sub ESPCapsuleDecode {
    my($hexString,$inet)=@_;
    my($hexSt);
    if($inet->{'NextHeader'} eq $INETFLD{'PROTO.IPV4'}){
	($hexSt)=CtPkDecode('INET4',$hexString);
    }
    elsif($inet->{'NextHeader'} eq $INETFLD{'PROTO.IPV6'}){
	($hexSt)=CtPkDecode('INET6',$hexString);
    }
    elsif($inet->{'NextHeader'} eq $INETFLD{'PROTO.UDP'}){
	($hexSt)=CtPkDecode('UDPX',$hexString);
    }
    elsif($inet->{'NextHeader'} eq $INETFLD{'PROTO.TCP'}){
	($hexSt)=CtPkDecode('TCPX',$hexString);
    }
    return $hexSt;
}
#============================================
# 
#============================================
sub AddESPAction {
    my($node,$func,$command,$rule,$id,$timeout)=@_;

    # 
    if(!ref($node)){$node=CtNDFromName($node);}
    if(ref($node) ne 'HASH'){return;}

    # 
    if(!$id){$id = 'ST:' . $node->{'TLNO'};}
    # 
    if(!$timeout){$timeout=$ScenarioTimeOut;}

    # 
    if($command eq 'START'){
	CtNDAddActEx($node,$id,$func,$rule,'send',$timeout);
    }
    elsif($command eq 'TIMER'){
	# 
	CtNDAddActEx($node,$id,$func,$rule,'timer',$timeout);
    }
    else{
	# 
	CtNDAddActEx($node,$id,$func,$rule,'recv',$timeout,{'SAID'=>$command,'MATCH'=>\&ESPMatchPacket});
    }
}

#============================================
# ESP
#============================================
sub RecvESP {
    my($node,$command,$timeout)=@_;
    return SEQ_Recv($node,\&ESPMatchPacket,
		    {'SAID'=>$command,'MATCH'=>\&ESPMatchPacket},$timeout);
}

#============================================
# ESP
#============================================
sub SendESP {
    my($connID,$saInst,$inetSt,$comment)=@_;
    my($sendConn,$timestamp,$result,$node,$conn);

    # 
    $conn=CtCnGet($connID);

    # 
    $node=$conn->{'Node'};

    # INET
    CtPkSetup($inetSt);

    # RAW 
    if($result=CtIoSend($connID,CtPkEncode($inetSt),\$sendConn,\$timestamp)){ return $result; }
    $inetSt->{'#TimeStamp#'}=$timestamp;

    # 
    $comment=sprintf("  SPI:%08x",CtFlGet('INET,#ESP,SPI',$inetSt)) unless($comment);
    IKAddCapture($node,$inetSt,'out','','ESP',$comment,'','','',$saInst);
}


#============================================
# ESP
#============================================

# IP
sub INETTTLDecrimentPkt {
    my($pkt)=@_;
    my($ttl,$newpkt,$checksum,$offset);

    # IP
    $offset=-$INETFLD{'Ether'};

    $ttl=hex(substr($pkt,INETPOS('IP4.TTL',$offset)*2,2));
#    printf("TTL [$ttl]\n");
    $newpkt=substr($pkt,0,INETPOS('IP4.TTL',$offset)*2) . sprintf("%02x",--$ttl) . 
	substr($pkt,INETPOS('IP4.Protocol',$offset)*2,2) . '0000' .
	substr($pkt,INETPOS('IP4.SrcAddr',$offset)*2);
#    PrintItem($newpkt);
#    PrintItem($pkt);
    $checksum=CtUtHexChkSum($newpkt);
#    PrintItem($checksum);
    $newpkt=substr($pkt,0,INETPOS('IP4.TTL',$offset)*2) . sprintf("%02x",$ttl) . 
	substr($pkt,INETPOS('IP4.Protocol',$offset)*2,2) . sprintf("%04x",$checksum) . 
	substr($pkt,INETPOS('IP4.SrcAddr',$offset)*2);
    return $newpkt;
}

1;
