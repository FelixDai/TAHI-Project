#!/usr/bin/perl
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


# use strict;

#============================================
#    
#============================================
sub MakeFrameAttr {
    my($nut)=@_;
    my(@keys,$key,$val,$port);
    # 

    unless($nut){$nut=$CVA_TUA_IPADDRESS;}
    $port=$CNT_CONF{'UA-PORT'}?$CNT_CONF{'UA-PORT'}:(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
    @keys=keys(%SIPFrameTempl);
    foreach $key (@keys){
	if( $SIPFrameTempl{$key}->{'Module'} eq 'TAHI' ){next;}

	$val=$SIPNodeTempl{$SIPFrameTempl{$key}->{'Node'}};
	if($SIPFrameTempl{$key}->{'Dir'} eq 'in'){
	    $SIPFrameTempl{$key}->{'SrcAddr'}=$nut;
	    $SIPFrameTempl{$key}->{'DstAddr'}=$val->{'AD'};
	}
	if($SIPFrameTempl{$key}->{'Dir'} eq 'out'){
	    $SIPFrameTempl{$key}->{'SrcAddr'}=$val->{'AD'};
	    $SIPFrameTempl{$key}->{'DstAddr'}=$nut;
	    $SIPFrameTempl{$key}->{'DstPort'}=$port;
	}
	$SIPFrameTempl{$key}->{'Proto'}=$SIP_PL_IP eq 4 ? 'INET':'INET6';
    }
}
sub GetFrameAttr {
    my($frame)=@_;
    return $SIPFrameTempl{$frame};
}
sub GetFrameName {
    my($srcaddr,$dstaddr)=@_;
    my(@frames,@keys,$key,$type);
    $type=IPAddressType($srcaddr);
    @keys=keys(%SIPFrameTempl);
    foreach $key (@keys){
	if($type eq 'ip4'){
	    if(IPv4EQ($SIPFrameTempl{$key}->{'SrcAddr'},$srcaddr) && IPv4EQ($SIPFrameTempl{$key}->{'DstAddr'},$dstaddr)){
		push(@frames,$key);
	    }
	}
	else{
	    if(IPv6EQ($SIPFrameTempl{$key}->{'SrcAddr'},$srcaddr) && IPv6EQ($SIPFrameTempl{$key}->{'DstAddr'},$dstaddr)){
		push(@frames,$key);
	    }
	}
    }
    return \@frames;

}
sub MatchFrameNames {
    my($frames,$candidate)=@_;
    my(@match,$frm);
    foreach $frm (@$candidate){
	if(grep{$frm eq $_} (@$frames)){
	    push(@match,$frm);
	}
    }
    return \@match;
}
sub MatchFrameName {
    my($frames,$candidate)=@_;
    my($frm);
    foreach $frm (@$candidate){
	if(grep{$frm eq $_} (@$frames)){
	    return $frm;
	}
    }
    return '';
}

sub SelectTransportMod {
    my($frames)=@_;

    my(@tahiFrame,@sockFrame,$frame,$conn);

    if($SIP_PL_TRNS eq 'UDP'){return $frames,'';}

    foreach $frame (@$frames){
	$conn=$frame->{'Connection'};
	$frame=$frame->{'Frame'};
	if($SIPFrameTempl{$frame}->{'Module'} eq 'SOCK'){
	    push(@sockFrame,$frame);
	    unless($conn->{'Strict'}){
		push(@tahiFrame,$frame);
	    }
	}
	else{
	    push(@tahiFrame,$frame);
	}
    }
    return \@tahiFrame,\@sockFrame;
}


#============================================
#    
#============================================
sub IsAliveSocket {
    my($socketID)=@_;
    my $ret=kPacket_ConnectInfo($socketID);
    return $ret->{'Connection'} eq 2;
}

sub AddConnecion {
    my($socketID)=@_;
    unless($ConnectionTbl{$socketID}){$ConnectionTbl{$socketID}={'SocketID'=>$socketID};}
}

sub IsNewConnection {
    my($socketID)=@_;
    return $ConnectionTbl{$socketID};
}

# 
sub CNNMake {
    my($state,$strict,$trans,$socketID,$dir)=@_;
    my($conn);
    if($socketID){
	unless($state){
	    $state=IsNewConnection($socketID)?'continue':'new';
	    if($state eq 'new'){$dir='server';}
	}
	AddConnecion($socketID);
    }
    if(!$dir){$dir='client';}
    $conn={'Trans'=>$trans?$trans:$SIP_PL_TRNS,'Proto'=>$SIP_PL_IP eq 6 ? 'INET6':'INET',
	   'State'=>$state,'SocketID'=>$socketID,'Strict'=>$strict,'Dir'=>$dir};
    return $conn;
}
sub CNNCreate {
    my($node)=@_;
    return $CNN=CNNBind(CNNMake('new'),$node);
}
sub CNN(){
    return $CNN;
}
# 
sub CNNBind {
    my($conn,$node)=@_;
    unless($node){$node=$SEQCurrentActNode;}
    $conn->{'Node'}=$node->{'ID'};
    push(@{$node->{'Connection'}},$conn);
    return $conn;
}
# 
sub CNNClose {
    my($conn,$node,$delay)=@_;
    my($val);
    unless($node){$node=$SEQCurrentActNode;}
    unless($conn){$conn=$node->{'Connection'}->[0];}
    if($delay eq ''){$delay=$node->{'Dir'} eq 'server' ? 5:0;}
    if($conn && $conn->{'SocketID'}){
	$val=kPacket_Close($conn->{'SocketID'},$delay);
	if($val->{'Result'}){
	    MsgPrint('ERR',"SocketIO[Close] error[%x]\n",$val->{'Result'});
	}
	$conn->{'SocketID'}='';
    }
}
sub CNNResponse{
    my($pktinfo)=@_;
    unless($pktinfo){$pktinfo=$SIPPktInfoLast;}
    return $pktinfo->{'pkt'}->{'Connection'};
}


#============================================
#    TAHI 
#============================================
sub vCAPTURE {
    my($link)=@_;
    my($val);
    # 
    if($SIPLOGO || $SIP_PL_TRNS ne 'UDP'){
	$val=kPacket_Close(0,0);
	kPacket_Clear(0,0,0,0);
	if($val->{'Result'}){
	    MsgPrint('ERR',"SocketIO[Close] can't communicate\n");
	    return 'ERR';
	}
	$val=kPacket_StartRecv($SIP_PL_TRNS,'SIP',$SIP_PL_IP eq 6 ? 'INET6':'INET','',(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),$link);
	if($val->{'Result'}){
	    MsgPrint('ERR',"SocketIO[StartRecv:%x] can't communicate\n",$val->{'Result'});
	    return 'ERR';
	}
	# TLS 
	if($SIP_PL_TRNS =~ /TLS/i){
	    $val=kPacket_StartRecv($SIP_PL_TRNS,'SIP',$SIP_PL_IP eq 6 ? 'INET6':'INET','',5061,$link);
	    if($val->{'Result'}){
		MsgPrint('ERR',"SocketIO[StartRecv:%x] can't communicate\n",$val->{'Result'});
		return 'ERR';
	    }
	}
    }
    return vCapture($link);
}

sub vSEND {
    my($link,$conn,$frame)=@_;
    my($att,$msg,$ans,%pkt,$proto,$ip,$udp);

    # 
    $att=GetFrameAttr($frame);
    if($att->{'Module'} ne 'SOCK' || (!$SIPLOGO && ($SIP_PL_TRNS eq 'UDP' || $conn->{'Trans'} eq 'UDP'))){
	%pkt=vSend($link,$frame);
##	printf("vSend [%s] [$frame]\n",$pkt{'sentTime1'});
	$pkt{'Connection'}=CNNMake('new','',$att->{'Trans'}?$att->{'Trans'}:'UDP');
	return %pkt;
    }
    else{
	# SIP
	$msg=CNT_ReadSipMsg();

	# 
	if($conn && $conn->{'SocketID'}){
	    # 
	    if(IsAliveSocket($conn->{'SocketID'})){
		# 
		$ans=kPacket_Send($conn->{'SocketID'},length($msg),$msg);
		$pkt{'Connection'}=CNNMake('continue','','',$conn->{'SocketID'},$conn->{'Dir'});
	    }
	    # 
	    else{
		MsgPrint('WAR',"vSend connection[%s] already closed,so create new connection\n",$conn->{'SocketID'});
		# 
		$ans=kPacket_ConnectSend($SIP_PL_TRNS,'SIP',$att->{'Proto'},
					 $att->{'SrcAddr'},$att->{'DstAddr'},
					 '',$att->{'DstPort'},length($msg),$msg,$link);
		if(!$ans->{'Result'}){
		    $pkt{'Connection'}=CNNMake('unexpected','','',$ans->{'SocketID'});
		}
	    }
	}
	# 
	else{
	    # 
	    $ans=kPacket_ConnectSend($SIP_PL_TRNS,'SIP',$att->{'Proto'},
				     $att->{'SrcAddr'},$att->{'DstAddr'},
				     '',$att->{'DstPort'},length($msg),$msg,$link);
	    # 
	    if(!$ans->{'Result'}){
		$pkt{'Connection'}=CNNMake('new','','',$ans->{'SocketID'});
	    }
	}
	# TAHI
	if($ans && !$ans->{'Result'}){
	    $pkt{'status'}=$ans->{'Result'};
	    $pkt{'sentTime1'}=sprintf("%s.%03d",$ans->{'TimeStamp'},int($ans->{'TimeStamp2'}/1000));
##	printf("kPacket_Send [%s.%03d](%s)\n",$ans->{'TimeStamp'},$ans->{'TimeStamp2'}/1000,$pkt{'sentTime1'});
	    $pkt{'sendFrame'}=$frame;
	    $proto=$att->{'Proto'} eq 'INET6' ? 'IPv6' : 'IPv4';
	    $udp='Frame_Ether.Packet_' . $proto . '.Upp_UDP.';
	    $ip ='Frame_Ether.Packet_' . $proto . '.Hdr_' . $proto . '.';
	    $pkt{'Frame_Ether.Packet_' . $proto}='TRUE';
	    $pkt{$ip . 'DestinationAddress'}=$att->{'DstAddr'};
	    $pkt{$ip . 'SourceAddress'}=$att->{'SrcAddr'};
	    $pkt{$udp . 'Hdr_UDP.DestinationPort'}=$att->{'DstAddr'};
	    $pkt{$udp . 'Hdr_UDP.SourcePort'}='';
	    $pkt{$udp . 'Udp_SIP.message'}=$msg;
	}
	else{
	    $pkt{'status'}=2;
	}
	#   SIP
	return %pkt;
    }
}

sub vRECV {
    my($link,$timeout,$seektime,$count,$conn,@frames)=@_;

    if($SIPLOGO){
	return vRECVLogo(@_);
    }
    else{
	return vRECVFree(@_);
    }
}

sub vRECVFree {
    my($link,$timeout,$seektime,$count,$conn,@frames)=@_;
    my(%pkt,$tahiFrame,$sockFrame,$proto,$ip,$udp,$frame,$matchframe,$ans,$i,$att,@frm);

    # 
    @frm=map{$_->{'Frame'}}(@frames);

    if($SIP_PL_TRNS eq 'UDP'){
	%pkt=vRecv2($link,$timeout,$seektime,$count,@frm);
	$pkt{'Connection'}={'Trans'=>'UDP'};
	$pkt{'recvTime1'} = $pkt{'recvTime' . $pkt{'recvCount'}};
##	printf("vRecv2 [%s] [%s] [%s]\n",$pkt{'recvTime1'},$pkt{'recvFrame'},$pkt{'recvCount'});
	return %pkt;
    }

    # 

    ($tahiFrame,$sockFrame)=SelectTransportMod(\@frames);

    # TAHI
    if(-1<$#$tahiFrame){
	for $i(0..10) {
#	    %pkt=vRecv2($link,$sockFrame && -1<$#$sockFrame ? 1:0,0,0,@$tahiFrame);
	    %pkt=vRecv2($link,0,0,0,@$tahiFrame);
##	    printf("vRecv2 [%s][%s][%s]\n",$pkt{'status'},$pkt{'recvTime' . $pkt{'recvCount'}},$pkt{'recvCount'});

	    # 
	    if($pkt{'status'} eq 0){
##	    printf("vRecv2 [%s][%s]\n",$pkt{'status'},$pkt{'recvFrame'});
		# 
		$pkt{'recvTime1'} = $pkt{'recvTime' . $pkt{'recvCount'}};
		$att=GetFrameAttr($pkt{'recvFrame'});
		$pkt{'Connection'}=CNNMake('new','',$att->{'Trans'}?$att->{'Trans'}:'UDP','','server');
		return %pkt;
	    }
	    if($pkt{'status'} eq 1){
		last;
	    }
	}
    }
    
    # SOCKIO
    if(-1<$#$sockFrame){

	# 
	$ans=kPacket_Recv(0,1);
##	printf("kPacket_Recv [%s][%s.%03d] [%s]->[%s]\n",$ans->{'Result'},
##	       $ans->{'TimeStamp'},$ans->{'TimeStamp2'}/1000,$ans->{'SrcAddr'},$ans->{'DstAddr'});
	# 
	if($ans && !$ans->{'Result'}){
	    # 
	    $frame=MatchFrameNames(\@frm,GetFrameName($ans->{'SrcAddr'},$ans->{'DstAddr'}));
	    $matchframe=MatchFrameName(\@frm,$frame);
##	    printf("  matchframe [%s]\n",$matchframe);
	    # 
	    if(!$matchframe){
		$pkt{'status'}=2; 
		$pkt{'recvFrame'}=ref($frame) eq 'ARRAY' ? $frame->[0]:$frame;
	    }
	    # 
	    else{
		$pkt{'status'}=0;
		$pkt{'recvFrame'}=$matchframe;
	    }
	    # 

	    if($conn){
		if($conn->{'SocketID'} ne $ans->{'SocketID'}){
		    MsgPrint('WAR',"vRecv received via connection[%s],not connection[%s]\n",
			     $ans->{'SocketID'},$conn->{'SocketID'});
		    $pkt{'Connection'}=CNNMake('unexpected','','',$ans->{'SocketID'},$conn->{'Dir'});
		}
		else{
		    $pkt{'Connection'}=CNNMake('continue','','',$ans->{'SocketID'},$conn->{'Dir'});
		}
	    }
	    else{
		$pkt{'Connection'}=CNNMake('','','',$ans->{'SocketID'});
	    }

	    # TAHI
	    #  SIP
	    $pkt{'recvTime1'}=sprintf("%s.%03d",$ans->{'TimeStamp'},int($ans->{'TimeStamp2'}/1000));
	    $proto=$SIP_PL_IP eq 6 ? 'IPv6' : 'IPv4';
	    $udp='Frame_Ether.Packet_' . $proto . '.Upp_UDP.';
	    $ip ='Frame_Ether.Packet_' . $proto . '.Hdr_' . $proto . '.';
	    $pkt{'Frame_Ether.Packet_' . $proto}='TRUE';
	    $pkt{$ip . 'DestinationAddress'}=$ans->{'DstAddr'};
	    $pkt{$ip . 'SourceAddress'}=$ans->{'SrcAddr'};
	    $pkt{$udp . 'Hdr_UDP.DestinationPort'}=$ans->{'DstPort'};
	    $pkt{$udp . 'Hdr_UDP.SourcePort'}=$ans->{'SrcAddr'};
	    $ans->{'Data'} =~ s/\r\n/\n/g;
	    $pkt{$udp . 'Udp_SIP.message'}=$ans->{'Data'};
	}
	else{
	    # 
	    $pkt{'status'}= $ans->{'Result'} eq 0x8101 ? 1:2;
	}
    }
    return %pkt;
}

sub vRECVLogo {
    my($link,$timeout,$seektime,$count,$conn,@frames)=@_;
    my(%pkt,$tahiFrame,$sockFrame,$proto,$ip,$udp,$frame,$matchframe,$ans,$i,$att,@frm);

    # 
    @frm=map{$_->{'Frame'}}(@frames);

    # 
    $ans=kPacket_Recv(0,1);
    
##    printf("kPacket_Recv [%s][%s.%03d] [%s]->[%s]\n",$ans->{'Result'},
##	   $ans->{'TimeStamp'},$ans->{'TimeStamp2'}/1000,$ans->{'SrcAddr'},$ans->{'DstAddr'});

	# 
	if($ans && !$ans->{'Result'}){
	    # 
	    $frame=MatchFrameNames(\@frm,GetFrameName($ans->{'SrcAddr'},$ans->{'DstAddr'}));
	    $matchframe=MatchFrameName(\@frm,$frame);
##	    printf("  matchframe [%s]\n",$matchframe);
	    # 
	    if(!$matchframe){
		$pkt{'status'}=2; 
		$pkt{'recvFrame'}=ref($frame) eq 'ARRAY' ? $frame->[0]:$frame;
	    }
	    # 
	    else{
		$pkt{'status'}=0;
		$pkt{'recvFrame'}=$matchframe;
	    }
	    # 

	    if($conn){
		if($conn->{'SocketID'} ne $ans->{'SocketID'}){
		    MsgPrint('WAR',"vRecv received via connection[%s],not connection[%s]\n",
			     $ans->{'SocketID'},$conn->{'SocketID'});
		    $pkt{'Connection'}=CNNMake('unexpected','','',$ans->{'SocketID'},$conn->{'Dir'});
		}
		else{
		    $pkt{'Connection'}=CNNMake('continue','','',$ans->{'SocketID'},$conn->{'Dir'});
		}
	    }
	    else{
		$pkt{'Connection'}=CNNMake('','','',$ans->{'SocketID'});
	    }

	    # TAHI
	    #  SIP
	    $pkt{'recvTime1'}=sprintf("%s.%03d",$ans->{'TimeStamp'},int($ans->{'TimeStamp2'}/1000));
	    $proto=$SIP_PL_IP eq 6 ? 'IPv6' : 'IPv4';
	    $udp='Frame_Ether.Packet_' . $proto . '.Upp_UDP.';
	    $ip ='Frame_Ether.Packet_' . $proto . '.Hdr_' . $proto . '.';
	    $pkt{'Frame_Ether.Packet_' . $proto}='TRUE';
	    $pkt{$ip . 'DestinationAddress'}=$ans->{'DstAddr'};
	    $pkt{$ip . 'SourceAddress'}=$ans->{'SrcAddr'};
	    $pkt{$udp . 'Hdr_UDP.DestinationPort'}=$ans->{'DstPort'};
	    $pkt{$udp . 'Hdr_UDP.SourcePort'}=$ans->{'SrcAddr'};
	    $ans->{'Data'} =~ s/\r\n/\n/g;
	    $pkt{$udp . 'Udp_SIP.message'}=$ans->{'Data'};
	}
	else{
	    # 
	    $pkt{'status'}= $ans->{'Result'} eq 0x8101 ? 1:2;
	}

    return %pkt;
}

sub vCLEAR {
    my($link)=@_;
    if(!$SIPLOGO){
	vClear($link);
    }
}

1
