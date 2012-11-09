#!/usr/bin/perl
# @@ -- PKTbuf.pm --
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
# 09/1/27  bytecode

#============================================
# PKTCAP
#============================================
# 
%PKTBUFCmd=(
	   'CMD-CONNECT-REQ'  => 0x0100,
	   'CMD-CONNECT-ANS'  => 0x8100,
	   'CMD-CLOSE-REQ'    => 0x0200,
	   'CMD-CLOSE-ANS'    => 0x8200,
	   'CMD-SEND-REQ'     => 0x0001,
	   'CMD-SEND-ANS'     => 0x8001,
	   'CMD-READ-REQ'     => 0x0002,
	   'CMD-READ-ANS'     => 0x8002,
	   'CMD-CAPTURE-REQ'  => 0x0003,
	   'CMD-CAPTURE-ANS'  => 0x8003,
	   'CMD-STOP-REQ'     => 0x0004,
	   'CMD-STOP-ANS'     => 0x8004,
	   'CMD-WRAP-REQ'     => 0x0005,
	   'CMD-WRAP-ANS'     => 0x8005,
	   'CMD-NOWRAP-REQ'   => 0x0006,
	   'CMD-NOWRAP-ANS'   => 0x8006,
	   'CMD-CLEAR-REQ'    => 0x0007,
	   'CMD-CLEAR-ANS'    => 0x8007,
	   'CMD-DUMP-REQ'     => 0x0008,
	   'CMD-DUMP-ANS'     => 0x8008,
	   'CMD-DATA-REQ'     => 0x0009,
	   'CMD-DATA-ANS'     => 0x8009,
	   'CMD-STATUS-REQ'   => 0x000a,
	   'CMD-STATUS-ANS'   => 0x800a,
);

# 
$PKTBUFSocket='';

#============================================
# 
#============================================
# 
sub PKTbufInitialize {
    my($path,$filter)=@_;

    if($filter){PKTbufAddFilter($filter)};

    # 
    if($PKTBUFSocket){close($PKTBUFSocket);$PKTBUFSocket=0;}

    # UNIX
    if( !($PKTBUFSocket=CtIoOpenUD($path)) ){
	MsgPrint('ERR',"PKTbuf IO module can't access\n");
	return 'Socket open error';
    }
    return '';
}

#============================================
# 
#============================================

# 
sub PKTbufConnect {
    my($cmdreq,$cmdres,%result);

    if(!$PKTBUFSocket){return {'Result'=>0x8103};}

    $cmdreq=pack('n2 N a7',$PKTBUFCmd{'CMD-CONNECT-REQ'},7,$$,'pktrecv');

    # 
    CtIoWriteUD($PKTBUFSocket,$cmdreq);

    # 
    $cmdres=CtIoReadUD($PKTBUFSocket);

    ($result{'Command'},$result{'Length'},$result{'Result'})=unpack('n2 N', $cmdres);
    return \%result;
}

# 
sub PKTbufCapture {
    my($cmdreq,$cmdres,%result);

    if(!$PKTBUFSocket){return {'Result'=>0x8103};}

    $cmdreq=pack('n2 N',$PKTBUFCmd{'CMD-CAPTURE-REQ'},0,0);

    # 
    CtIoWriteUD($PKTBUFSocket,$cmdreq);

    # 
    $cmdres=CtIoReadUD($PKTBUFSocket);

    ($result{'Command'},$result{'Length'},$result{'Result'})=unpack('n2 N', $cmdres);
    return \%result;
}

# 
sub PKTbufClear {
    my($cmdreq,$cmdres,%result);

    if(!$PKTBUFSocket){return {'Result'=>0x8103};}

    $cmdreq=pack('n2 N',$PKTBUFCmd{'CMD-CLEAR-REQ'},0,0);

    # 
    CtIoWriteUD($PKTBUFSocket,$cmdreq);

    # 
    $cmdres=CtIoReadUD($PKTBUFSocket);

    ($result{'Command'},$result{'Length'},$result{'Result'})=unpack('n2 N', $cmdres);
    return \%result;
}

# 
sub PKTbufRead {
    my($timeout)=@_;
    my($cmdreq,$cmdres,%result,$data,@tim,@tim2,$tmp);

    if(!$PKTBUFSocket){return {'Result'=>0x8103};}
RETRY:
    @tim=Time::HiRes::gettimeofday();

    $cmdreq=pack('n2 N N2',$PKTBUFCmd{'CMD-READ-REQ'},8,0,@tim[0]+$timeout,@tim[1]);

#    MsgPrint('ERR',"start\n");
    # 
    CtIoWriteUD($PKTBUFSocket,$cmdreq);

    # 
    $cmdres=CtIoReadUD($PKTBUFSocket,8);
    ($result{'Command'},$result{'Length'},$result{'Result'})=unpack('n2 N', $cmdres);

    if($result{'Length'}){
	$cmdres=CtIoReadUD($PKTBUFSocket);
	($result{'TimeSec'},$result{'TimeUsec'},$tmp,$result{'Packet'})=unpack('N2 a10 a*', $cmdres);

	# 
	if($PKTbufFILTER){
##	    printf("[%s]\n",unpack('H*',$result{'Packet'}));
	    if( PKTbufEvalFilter($PKTbufFILTER,unpack('H*',$result{'Packet'})) ){
		return \%result;
	    }

##	    printf("PKTbufRead filter unmatched. packet discard\n");
	    # 
	    @tim2=Time::HiRes::gettimeofday();
	    $timeout = (@tim[0]+$timeout) - @tim2[0];
	    if(0<$timeout){ goto RETRY; }
	    return {'Result'=>0x8103};
	}
    }
#    printf("PKTbufRead[%s] end time[%s.%s]\n",$result{'Result'},$result{'TimeSec'},$result{'TimeUsec'});
#    printf("[%s]\n",unpack('H*',$result{'Packet'}));

    return \%result;
}

# 
sub PKTbufSend {
    my($data)=@_;
    my($cmdreq,$cmdres,%result);

    if(!$PKTBUFSocket){return {'Result'=>0x8103};}

    $cmdreq=pack('n2 N',$PKTBUFCmd{'CMD-SEND-REQ'},length($data),0);

    # 
    CtIoWriteUD($PKTBUFSocket,$cmdreq);
    CtIoWriteUD($PKTBUFSocket,$data);

#    MsgPrint('ERR',"start\n");
    # 
    $cmdres=CtIoReadUD($PKTBUFSocket,8);
    ($result{'Command'},$result{'Length'},$result{'Result'})=unpack('n2 N', $cmdres);

    if($result{'Length'}){
	$cmdres=CtIoReadUD($PKTBUFSocket);
	($result{'TimeSec'},$result{'TimeUsec'})=unpack('N2', $cmdres);
    }
#    MsgPrint('ERR',"end time[%s.%s]\n",$result{'TimeSec'},$result{'TimeUsec'});
    return \%result;
}

# 
#   
# ex) 
#    (and (ip4 src c0a81833)(port dst 5060)(proto 17))
#    (and (ip6) (not (eth src 0090cc5a8017)))
sub PKTbufAddFilter {
    my($filter)=@_;
    $PKTbufFILTER=CtParseLisp($filter);
    if(ref($PKTbufFILTER) eq 'ARRAY' && -1<$#$PKTbufFILTER){
	$PKTbufFILTER=$PKTbufFILTER->[0];
    }
    else{
	$PKTbufFILTER='';
    }
    return $PKTbufFILTER;
}
sub PKTbufEvalFilter {
    my($exp,$pkt,$indx)=@_;
    my($op,$arg,$args,@vals,$type);

    unless(ref($exp)){return $exp;}

    $op=$exp->{'op'};
    $args=$exp->{'args'};

    if($op eq 'and'){
	foreach $arg (@$args){
	    if(!PKTbufEvalFilter($arg,$pkt,$indx+1)){return '';}
	}
	return 'OK';
    }
    elsif($op eq 'or'){
	foreach $arg (@$args){
	    if(PKTbufEvalFilter($arg,$pkt,$indx+1)){return 'OK';}
	}
	return '';
    }
    elsif($op eq 'ip6'){
	# ip6 | ip6 src XXX | ip6 dst XXX
	if($args->[0] eq 'src'){
	    return lc(substr($pkt,$INETFLD{'IP6.SrcAddr'}*2,32)) eq lc($args->[1]);
	}
	elsif($args->[0] eq 'dst'){
	    return lc(substr($pkt,$INETFLD{'IP6.DstAddr'}*2,32)) eq lc($args->[1]);
	}
	else{
##	    printf("%sip6 [%s]\n",' ' x $indx,lc(substr($pkt,$INETFLD{'Ether.Type'}*2,4)) eq '86dd');
	    return lc(substr($pkt,$INETFLD{'Ether.Type'}*2,4)) eq '86dd';
	}
    }
    elsif($op eq 'ip4'){
	# ip4 | ip4 src XXX | ip4 dst XXX
	if($args->[0] eq 'src'){
	    return lc(substr($pkt,$INETFLD{'IP4.SrcAddr'}*2,8)) eq lc($args->[1]);
	}
	elsif($args->[0] eq 'dst'){
	    return lc(substr($pkt,$INETFLD{'IP4.DstAddr'}*2,8)) eq lc($args->[1]);
	}
	else{
	    return substr($pkt,$INETFLD{'Ether.Type'}*2,4) eq '0800';
	}
    }
    elsif($op eq 'eth'){
	# eth src XXX | eth dst XXX
	if($args->[0] eq 'src'){
	    return lc(substr($pkt,$INETFLD{'Ether.SrcMac'},12)) eq lc($args->[1]);
	}
	elsif($args->[0] eq 'dst'){
##	    printf("%sether [%s][%s]\n",' ' x $indx,lc(substr($pkt,$INETFLD{'Ether.DstMac'}*2,12)), lc($args->[1]));
##	    printf("%sether [%s]\n",' ' x $indx,lc(substr($pkt,$INETFLD{'Ether.DstMac'}*2,12)) eq lc($args->[1]));
	    return lc(substr($pkt,$INETFLD{'Ether.DstMac'}*2,12)) eq lc($args->[1]);
	}
	return '';
    }
    elsif($op eq 'port'){
	# port src XXX | port dst XXX
	# IP6|IP4
	$type=lc(substr($pkt,$INETFLD{'Ether.Type'}*2,4));
	if( $type eq '0800' ){
	    $type=lc(substr($pkt,$INETFLD{'IP4.Protocol'}*2,2));
	    if($type eq '11'){ # UDP
		if($args->[0] eq 'src'){
		    return hex(substr($pkt,$INETFLD{'IP4.UDP.SrcPort'}*2,4)) eq $args->[1];
		}
		elsif($args->[0] eq 'dst'){
		    return hex(substr($pkt,$INETFLD{'IP4.UDP.DstPort'}*2,4)) eq $args->[1];
		}
	    }
	    elsif($type eq '6'){ # TCP
		if($args->[0] eq 'src'){
		    return hex(substr($pkt,$INETFLD{'IP4.TCP.SrcPort'}*2,4)) eq $args->[1];
		}
		elsif($args->[0] eq 'dst'){
		    return hex(substr($pkt,$INETFLD{'IP4.TCP.DstPort'}*2,4)) eq $args->[1];
		}
	    }
	}
	elsif( $type eq '86dd' ){
	    $type=lc(substr($pkt,$INETFLD{'IP6.NextHeader'}*2,2));
	    if($type eq '11'){ # UDP
		if($args->[0] eq 'src'){
		    return hex(substr($pkt,$INETFLD{'IP6.UDP.SrcPort'}*2,4)) eq $args->[1];
		}
		elsif($args->[0] eq 'dst'){
##		    printf("%sdst port [%s][%s]\n",' 'x$indx,hex(substr($pkt,$INETFLD{'IP6.UDP.DstPort'}*2,4)),$args->[1]);
		    return hex(substr($pkt,$INETFLD{'IP6.UDP.DstPort'}*2,4)) eq $args->[1];
		}
	    }
	    elsif($type eq '6'){ # TCP
		if($args->[0] eq 'src'){
		    return hex(substr($pkt,$INETFLD{'IP6.TCP.SrcPort'}*2,4)) eq $args->[1];
		}
		elsif($args->[0] eq 'dst'){
		    return hex(substr($pkt,$INETFLD{'IP6.TCP.DstPort'}*2,4)) eq $args->[1];
		}
	    }
	}
	return '';
    }
    elsif($op eq 'proto'){
	$type=lc(substr($pkt,$INETFLD{'Ether.Type'}*2,4));
	if( $type eq '0800' ){
	    return hex(substr($pkt,$INETFLD{'IP4.Protocol'}*2,2)) eq $args->[0];
	}
	elsif( $type eq '86dd' ){
##	    printf("%sproto [%s][%s]\n",' ' x $indx,hex(substr($pkt,$INETFLD{'IP6.NextHeader'}*2,2)),$args->[0]);
	    return hex(substr($pkt,$INETFLD{'IP6.NextHeader'}*2,2)) eq $args->[0];
	}
	return '';
    }
    elsif($op eq 'not'){
	return !PKTbufEvalFilter($args->[0],$pkt,$indx+1);
    }
    elsif($op eq 'eq'){
	# eq 
	return lc(substr($pkt,$args->[0],$args->[1])) eq lc($args->[2]);
    }
    else{
	# 
	foreach $arg (@$args){
	    push(@vals,PKTbufEvalFilter($arg,$pkt,$indx+1));
	}
	return $op->($pkt,@vals);
    }
}


1;
