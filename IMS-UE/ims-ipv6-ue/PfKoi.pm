#!/usr/bin/perl
# @@ -- SIPkoi.pm --

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

# 
# 08/12/19 kPacket_ParserAttach

## package kCommon;
package kCommon;

## DEF.VAR
# use strict;
use Exporter;
use File::Basename;
use IO::Socket;


@ISA = qw(Exporter);
@EXPORT = qw(
	kPacket_ConnectSend
	kPacket_Send
	kPacket_Recv
	kPacket_Close
	kPacket_StartRecv
	kPacket_ConnectInfo
	kPacket_DataInfo
	kPacket_Clear
	kPacket_TlsSetup
	kPacket_TlsClear
	kPacket_ParserAttach

	kInsert

	kDump_Common_Error
	kLogHTML
);



#----------------------------------------------------------------------#
# Function prototypes                                                  #
#----------------------------------------------------------------------#
sub kPacket_ConnectSend($$$$$$$$$$);
sub kPacket_Send($$$);
sub kPacket_Recv($$);
sub kPacket_Close($$);
sub kPacket_StartRecv($$$$$$);
sub kPacket_ConnectInfo($);
sub kPacket_DataInfo($);
sub kPacket_Clear($$$$);
sub kPacket_TlsSetup($$$$$$$);
sub kPacket_TlsClear($);
sub kPacket_ParserAttach($$$);


sub PKTSendCMD($$;$);
sub kWriteUnixDomain($$);
sub kReadUnixDomain($);
sub kCheckDataLength($$);


sub kMakeData($$);
sub kMakeConnectSendAck($);
sub kMakeSendAck($);
sub kMakeRecvAck($);
sub kMakeCloseAck($);
sub kMakeListenAck($);
sub kMakeConnInfoAck($);
sub kMakeDataInfoAck($);
sub kMakeClearAck($);


sub kInetPtoN($$);
sub kInetNtoP($$);


sub kInsert($$;$$$);


sub kInit_Common_Error();
sub kReg_Common_Error($$$$);
sub kDump_Common_Error();

sub kLogHTML($);

sub kModule_Initialize(;$$);
sub kModule_Terminate(;$);
sub kBoot_SocketIO($$$);

# sub sigchld();
## DEF.END



#----------------------------------------------------------------------#
# kPacket_ConnectSend()                                                #
#----------------------------------------------------------------------#
sub
kPacket_ConnectSend($$$$$$$$$$)
{
	my(
		$protocol,
		$frameid,
		$addrfamily,
		$srcaddr,
		$dstaddr,
		$srcport,
		$dstport,
		$datalen,
		$data,
		$interface
	) = @_;

	my $function = 'kPacket_ConnectSend';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;


	#--------------------------------------------------------------#
	# $protocol: 'TCP', 'UDP'                                      #
	#--------------------------------------------------------------#
	unless(defined($protocol)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "protocol must be defined.");

		return(undef);
	}

	unless(defined($sockio_proto{$protocol})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "unknown protocol -- $protocol");

		return(undef);
	}

	my $_protocol_ = $sockio_proto{$protocol};


	#--------------------------------------------------------------#
	# $frameid: 'NULL', 'DNS', 'SIP'                               #
	#--------------------------------------------------------------#
	unless(defined($frameid)) { $frameid = 'NULL'; }
	unless(defined($sockio_frame{$frameid})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "unknown frameid -- $frameid");

		return(undef);
	}

	my $_frameid_ = $sockio_frame{$frameid};


	#--------------------------------------------------------------#
	# $addrfamily: 'INET', 'INET6'                                 #
	#--------------------------------------------------------------#
	unless(defined($addrfamily)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "addrfamily must be defined.");

		return(undef);
	}

	unless(defined($sockio_af{$addrfamily})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "unknown addrfamily -- $addrfamily");

		return(undef);
	}

	my $_addrfamily_ = $sockio_af{$addrfamily};


	#--------------------------------------------------------------#
	# $srcaddr:                                                    #
	#--------------------------------------------------------------#
	unless(defined($srcaddr)) {
		for( ; ; ) {
			if($_addrfamily_ == 4) {
				$srcaddr = '0.0.0.0';
				last;
			}

			if($_addrfamily_ == 6) {
				$srcaddr = '::';
				last;
			}

			kReg_Common_Error(__FILE__, __LINE__, $function,
					  "unknown addrfamily -- $addrfamily");

			return(undef);
		}
	}

	my $_srcaddr_ = kInetPtoN($_addrfamily_, $srcaddr);

	unless(defined($_srcaddr_)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "kInetPtoN: failure -- $srcaddr");

		return(undef);
	}


	#--------------------------------------------------------------#
	# $dstaddr:                                                    #
	#--------------------------------------------------------------#
	unless(defined($dstaddr)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "dstaddr must be defined.");

		return(undef);
	}

	my $_dstaddr_ = kInetPtoN($_addrfamily_, $dstaddr);
	unless(defined($_dstaddr_)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "kInetPtoN: failure -- $dstaddr");

		return(undef);
	}


	#--------------------------------------------------------------#
	# $srcport:                                                    #
	#--------------------------------------------------------------#
	unless(defined($srcport)) { $srcport = 0; }
	my $_srcport_ = $srcport;


	#--------------------------------------------------------------#
	# $dstport:                                                    #
	#--------------------------------------------------------------#
	unless(defined($dstport)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "dstport must be defined.");

		return(undef);
	}

	my $_dstport_ = $dstport;


	#--------------------------------------------------------------#
	# $data:                                                       #
	#--------------------------------------------------------------#
	unless(defined($data)) { $data = ''; }
	my $_data_ = $data;


	#--------------------------------------------------------------#
	# $datalen:                                                    #
	#--------------------------------------------------------------#
	unless(defined($datalen)) { $datalen = length($data); }
	my $_datalen_ = $datalen;


	#--------------------------------------------------------------#
	# $interface: 'Link0', 'Link1', ...                            #
	#--------------------------------------------------------------#
	unless(defined($interface)) { $interface = 'Link0'; }

	my $interfaceid = 0;

	if($interface =~ /^\s*Link(\d+)\s*$/) {
		$interfaceid = $1;
	} else {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "unknown interface -- $interface");

		return(undef);
	}

	my $_interface_ = $interfaceid;

	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "Bad file descriptor");

		return(undef);
	}

	#--------------------------------------------------------------#
	# message construction                                         #
	#--------------------------------------------------------------#
	my $_message_ =
		pack(
			'n4 C2 n',
			$sockio_cmd{'CMD-CONNECT-REQ'},
			$SOCKIO_SEQ,
			$_srcport_,
			$_dstport_,
			$_addrfamily_,
			$_protocol_,
			$_interface_
		);

	$_message_ .= $_srcaddr_;
	$_message_ .= $_dstaddr_;

	$_message_ .=
		pack(
			'n2 N',
			0,
			$_frameid_,
			$_datalen_
		);

	$_message_ .= $_data_;

	return(PKTSendCMD($SOCKFD, 'CMD-CONNECT-REQ', $_message_));
}



#----------------------------------------------------------------------#
# kPacket_Send()                                                       #
#----------------------------------------------------------------------#
sub
kPacket_Send($$$)
{
	my ($socketid, $datalen, $data) = @_;

	my $function = 'kPacket_Send';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $socketid:                                                   #
	#--------------------------------------------------------------#
	unless(defined($socketid)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "socketid must be defined.");

		return(undef);
	}

	#--------------------------------------------------------------#
	# $data:                                                       #
	#--------------------------------------------------------------#
	unless(defined($data)) { $data = ''; }
	my $_data_ = $data;

	#--------------------------------------------------------------#
	# $socketid:                                                   #
	#--------------------------------------------------------------#
	unless(defined($datalen)) { $datalen = length($data); }
	my $_datalen_ = $datalen;

	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "Bad file descriptor");

		return(undef);
	}

	my $_reserve_ = 0;
	my $_message_ = pack('n4 N',
			     $sockio_cmd{'CMD-SEND-REQ'},
			     $SOCKIO_SEQ,
			     $socketid,
			     $_reserve_,
			     $_datalen_
			    );
	$_message_ .= $_data_;

	return(PKTSendCMD($SOCKFD, 'CMD-SEND-REQ', $_message_));
}



#----------------------------------------------------------------------#
# kPacket_Recv()                                                       #
#----------------------------------------------------------------------#
sub
kPacket_Recv($$)
{
	my ($socketid, $sec) = @_;

	my $function = 'kPacket_Recv';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $socketid:                                                   #
	#--------------------------------------------------------------#
	unless(defined($socketid)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "socketid must be defined.");

		return(undef);
	}

	my $_sec_ = defined($sec)? $sec: 0;

	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "Bad file descriptor");

		return(undef);
	}

	my $_message_ =
		pack(
			'n4',
			$sockio_cmd{'CMD-READ-REQ'},
			$SOCKIO_SEQ,
			$socketid,
			$_sec_
		);

	return(PKTSendCMD($SOCKFD, 'CMD-READ-REQ', $_message_));
}



#----------------------------------------------------------------------#
# kPacket_Close()                                                      #
#----------------------------------------------------------------------#
sub
kPacket_Close($$)
{
	my ($socketid, $sec) = @_;

	my $function = 'kPacket_Close';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $socketid:                                                   #
	#--------------------------------------------------------------#
	unless(defined($socketid)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "socketid must be defined.");

		return(undef);
	}

	#--------------------------------------------------------------#
	# $sec:                                                        #
	#--------------------------------------------------------------#
	my $_sec_ = defined($sec) ? $sec : 0;


	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "Bad file descriptor");

		return(undef);
	}

	my $_message_ = pack('n4',
			     $sockio_cmd{'CMD-CLOSE-REQ'},
			     $SOCKIO_SEQ,
			     $socketid,
			     $_sec_
			    );

	return(PKTSendCMD($SOCKFD, 'CMD-CLOSE-REQ', $_message_));
}



#----------------------------------------------------------------------#
# kPacket_StartRecv()                                                     #
#----------------------------------------------------------------------#
sub
kPacket_StartRecv($$$$$$)
{
	my ($protocol,
	    $frameid,
	    $addrfamily,
	    $srcaddr,
	    $srcport,
	    $interface) = @_;

	my $function = 'kPacket_StartRecv';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $protocol: 'TCP', 'UDP'                                      #
	#--------------------------------------------------------------#
	unless(defined($protocol)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "protocol must be defined.");

		return(undef);
	}

	unless(defined($sockio_proto{$protocol})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "unknown protocol -- $protocol");

		return(undef);
	}

	my $_protocol_ = $sockio_proto{$protocol};

	#--------------------------------------------------------------#
	# $frameid: 'NULL', 'DNS', 'SIP'                               #
	#--------------------------------------------------------------#
	unless(defined($frameid)) { $frameid = 'NULL'; }
	unless(defined($sockio_frame{$frameid})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "unknown frameid -- $frameid");

		return(undef);
	}

	my $_frameid_ = $sockio_frame{$frameid};

	#--------------------------------------------------------------#
	# $addrfamily: 'INET', 'INET6'                                 #
	#--------------------------------------------------------------#
	unless(defined($addrfamily)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "addrfamily must be defined.");

		return(undef);
	}

	unless(defined($sockio_af{$addrfamily})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "unknown addrfamily -- $addrfamily");

		return(undef);
	}

	my $_addrfamily_ = $sockio_af{$addrfamily};

	#--------------------------------------------------------------#
	# $srcaddr:                                                    #
	#--------------------------------------------------------------#
	unless($srcaddr) { ## by hok
		for( ; ; ) {
			if($_addrfamily_ == 4) {
				$srcaddr = '0.0.0.0';
				last;
			}

			if($_addrfamily_ == 6) {
				$srcaddr = '::';
				last;
			}

			kReg_Common_Error(__FILE__, __LINE__, $function,
					  "unknown addrfamily -- $addrfamily");

			return(undef);
		}
	}

	my $_srcaddr_ = kInetPtoN($_addrfamily_, $srcaddr);

	unless(defined($_srcaddr_)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "kInetPtoN: failure -- $srcaddr");

		return(undef);
	}

	#--------------------------------------------------------------#
	# $srcport:                                                    #
	#--------------------------------------------------------------#
	unless(defined($srcport)) { $srcport = 0; }
	my $_srcport_ = $srcport;

	#--------------------------------------------------------------#
	# $interface: 'Link0', 'Link1', ...                            #
	#--------------------------------------------------------------#
	unless(defined($interface)) { $interface = 'Link0'; }

	my $interfaceid = 0;

	if($interface =~ /^\s*Link(\d+)\s*$/) {
		$interfaceid = $1;
	} else {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "unknown interface -- $interface");

		return(undef);
	}

	my $_interface_ = $interfaceid;

	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "Bad file descriptor");

		return(undef);
	}

	my $_message_ = pack('n4 C2 n',
			     $sockio_cmd{'CMD-LISTEN-REQ'},
			     $SOCKIO_SEQ,
			     $_interface_,
			     $_frameid_,
			     $_addrfamily_,
			     $_protocol_,
			     $_srcport_
			    );

	$_message_ .= $_srcaddr_;

	return(PKTSendCMD($SOCKFD, 'CMD-LISTEN-REQ', $_message_));
}



#----------------------------------------------------------------------#
# kPacket_ConnectInfo()                                                #
#----------------------------------------------------------------------#
sub
kPacket_ConnectInfo($)
{
	my ($socketid) = @_;

	my $function = 'kPacket_ConnectInfo';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $socketid:                                                   #
	#--------------------------------------------------------------#
	unless(defined($socketid)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "socketid must be defined.");

		return(undef);
	}


	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "Bad file descriptor");

		return(undef);
	}

	my $_message_ = pack('n3',
			     $sockio_cmd{'CMD-CONNINFO-REQ'},
			     $SOCKIO_SEQ,
			     $socketid
			    );

	return(PKTSendCMD($SOCKFD, 'CMD-CONNINFO-REQ', $_message_));
}



#----------------------------------------------------------------------#
# kPacket_DataInfo()                                                   #
#----------------------------------------------------------------------#
sub
kPacket_DataInfo($)
{
	my ($dataid) = @_;

	my $function = 'kPacket_DataInfo';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $dataid:                                                     #
	#--------------------------------------------------------------#
	unless(defined($dataid)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "dataid must be defined.");

		return(undef);
	}

	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "Bad file descriptor");

		return(undef);
	}

	my $_message_ = pack('n2 N',
			     $sockio_cmd{'CMD-DATAINFO-REQ'},
			     $SOCKIO_SEQ,
			     $dataid
			    );

	return(PKTSendCMD($SOCKFD, 'CMD-DATAINFO-REQ', $_message_));
}



#----------------------------------------------------------------------#
# kPacket_Clear()                                                      #
#----------------------------------------------------------------------#
sub
kPacket_Clear($$$$)
{
	my ($socketid_flag,
	    $dataid_flag,
	    $socketid,
	    $dataid) = @_;

	my $function = 'kPacket_Clear';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $socketid_flag:                                              #
	#--------------------------------------------------------------#
	unless(defined($socketid_flag)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "socketid_flag must be defined.");

		return(undef);
	}

	#--------------------------------------------------------------#
	# $dataid_flag:                                                #
	#--------------------------------------------------------------#
	unless(defined($dataid_flag)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "dataid must be defined.");

		return(undef);
	}

	#--------------------------------------------------------------#
	# $socketid:                                                   #
	#--------------------------------------------------------------#
	unless(defined($socketid)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "socketid must be defined.");

		return(undef);
	}

	#--------------------------------------------------------------#
	# $dataid:                                                     #
	#--------------------------------------------------------------#
	unless(defined($dataid)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "dataid must be defined.");

		return(undef);
	}


	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "Bad file descriptor");

		return(undef);
	}

	my $_message_ = pack('n5 N',
			     $sockio_cmd{'CMD-CLEARBUFFER-REQ'},
			     $SOCKIO_SEQ,
			     $socketid_flag,
			     $dataid_flag,
			     $socketid,
			     $dataid
			    );

	return(PKTSendCMD($SOCKFD, 'CMD-CLEARBUFFER-REQ', $_message_));
}

#----------------------------------------------------------------------#
# kPacket_TlsSetup()                                                   #
#----------------------------------------------------------------------#
sub
kPacket_TlsSetup($$$$$$$)
{
	my ($sessionmode,$initialmode,$ssltimeout,$sslversion,$passwd,$rootpem,$mypem) = @_;

	my $function = 'kPacket_TlsSetup';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $sessionmode:                                                #
	#--------------------------------------------------------------#
	if(!defined($sessionmode) || !$sessionmode) {
	    $sessionmode=0;
	}
	else{
	    $sessionmode=1;
	}

	if(!$ssltimeout) {
	    $ssltimeout=0;
	}

	if($sslversion =~ /SSLv2/i) {
	    $sslversion=2;
	}
	elsif($sslversion =~ /SSLv23/i) {
	    $sslversion=23;
	}
	elsif($sslversion =~ /SSLv3/i) {
	    $sslversion=3;
	}
	elsif($sslversion =~ /TLSv1/i) {
	    $sslversion=1;
	}
	else{
	    $sslversion=1;
	}

	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,"Bad file descriptor");
		return(undef);
	}

	my $_message_ = pack('n6 a32 a128 a128',
			     $sockio_cmd{'CMD-TLSSETUP-REQ'},
			     $SOCKIO_SEQ,
			     $sessionmode,
			     $initialmode,
			     $ssltimeout,
			     $sslversion,
			     $passwd,
			     $rootpem,
			     $mypem
			    );

	return(PKTSendCMD($SOCKFD, 'CMD-TLSSETUP-REQ', $_message_));
}

#----------------------------------------------------------------------#
# kPacket_TlsClear()                                                   #
#----------------------------------------------------------------------#
sub
kPacket_TlsClear($)
{
	my ($socketid) = @_;

	my $function = 'kPacket_TlsClear';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $sessionmode:                                                #
	#--------------------------------------------------------------#

	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,"Bad file descriptor");
		return(undef);
	}

	my $_message_ = pack('n3',
			     $sockio_cmd{'CMD-TLSCLEAR-REQ'},
			     $SOCKIO_SEQ,
			     $socketid,
			    );

	return(PKTSendCMD($SOCKFD, 'CMD-TLSCLEAR-REQ', $_message_));
}

#----------------------------------------------------------------------#
# kPacket_ParserAttach()                                               #
#----------------------------------------------------------------------#
sub
kPacket_ParserAttach($$$)
{
	my ($paserid,
	    $pasername,
	    $modulepath) = @_;

	my $function = 'kPacket_ParserAttach';
	kInit_Common_Error();

	$SOCKIO_SEQ ++;
	$SOCKIO_SEQ &= 0xffff;

	#--------------------------------------------------------------#
	# $paserid:                                              #
	#--------------------------------------------------------------#
	unless(defined($paserid)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "paserid must be defined.");

		return(undef);
	}

	#--------------------------------------------------------------#
	# $pasername:                                                #
	#--------------------------------------------------------------#
	unless(defined($pasername)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "pasername must be defined.");

		return(undef);
	}

	#--------------------------------------------------------------#
	# $modulepath:                                                   #
	#--------------------------------------------------------------#
	unless(defined($modulepath)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "modulepath must be defined.");

		return(undef);
	}

	unless($SOCKFD) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "Bad file descriptor");

		return(undef);
	}

	my $_message_ = pack('n3 a64 a128',
			     $sockio_cmd{'CMD-PARSERATTACH-REQ'},
			     $SOCKIO_SEQ,
			     $paserid,
			     $pasername,
			     $modulepath,
			    );

	return(PKTSendCMD($SOCKFD, 'CMD-PARSERATTACH-REQ', $_message_));
}

#----------------------------------------------------------------------#
# PKTSendCMD()                                                         #
#----------------------------------------------------------------------#
sub
PKTSendCMD($$;$)
{
	my ($sock, $cmd, $send_msg) = @_;

	my $function = 'PKTSendCMD';

	unless(defined($send_msg)) {
		$send_msg = '';
	}

	unless(exists($sockio_cmd{$cmd})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\%sockio_cmd: unknown key -- $cmd");

		return(undef);
	}

	my $answer_cmd = $cmd;
	$answer_cmd =~ s/REQ/ANS/g;

	unless(defined(kWriteUnixDomain($sock, $send_msg))) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"kWriteUnixDomain: $!");

		return(undef);
	}

	my $recv_msg = kReadUnixDomain($sock);
	unless(defined($recv_msg)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"kReadUnixDomain: failure");

		return(undef);
	}

	for(my $d = 0; ; $d ++) {
		my $bool = kCheckDataLength($answer_cmd, $recv_msg);
		unless(defined($bool)) {
			kReg_Common_Error(__FILE__, __LINE__, $function,
				"kCheckDataLength: failure");

			return(undef);
		}

		if($bool) {
			last;
		}

		my $buf = kReadUnixDomain($sock);

		unless(defined($buf)) {
			kReg_Common_Error(__FILE__, __LINE__, $function,
				"kReadUnixDomain: failure");

			return(undef);
		}

		$recv_msg .= $buf;

		if($d > 2) {
			kReg_Common_Error(__FILE__, __LINE__, $function,
				"data size from socket I/O is too short.");

			return(undef);
		}
	}

	my $result = kMakeData($cmd, $recv_msg);

	unless(defined($result)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"kMakeData: failure");

		return(undef);
	}

	return($result);
}



#----------------------------------------------------------------------#
# kWriteUnixDomain()                                                   #
#----------------------------------------------------------------------#
sub
kWriteUnixDomain($$)
{
	my ($sock, $data) = @_;

	return(syswrite($sock, $data, length($data)));
}



#----------------------------------------------------------------------#
# kReadUnixDomain()                                                    #
#----------------------------------------------------------------------#
sub
kReadUnixDomain($)
{
	my ($sock) = @_;
	my $data = '';

	my $function = 'kReadUnixDomain';

	my $ret = sysread($sock, $data, 0xffff);
	unless(defined($ret)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"read: $!");

		return(undef);
	}

	return($data);
}



#----------------------------------------------------------------------#
# kCheckDataLength()                                                   #
#----------------------------------------------------------------------#
sub
kCheckDataLength($$)
{
	my ($cmd, $data) = @_;

	my $function = 'kCheckDataLength';

	my $dataLength = length($data);

	unless(defined($sockio_cmdlen{$cmd})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\%sockio_cmdlen: unknown key -- $cmd");

		return(undef);
	}

	if(defined($sockio_cmdlen{$cmd})) {
		my $length = $sockio_cmdlen{$cmd};

		if(!ref($length)) {
			return($length <= $dataLength);
		} elsif(ref($length) eq 'CODE') {
			$length = $length->($data);
			return($length <= $dataLength);
		}
	}

	return(1);
}


#----------------------------------------------------------------------#
# kMakeData()                                                         #
#----------------------------------------------------------------------#
sub
kMakeData($$)
{
	my ($cmd, $data) = @_;

	my $function = 'kMakeData';

	my $result = '';

	if($cmd eq 'CMD-CONNECT-REQ') {
		$result = kMakeConnectSendAck($data);
	} elsif($cmd eq 'CMD-SEND-REQ') {
		$result = kMakeSendAck($data);
	} elsif($cmd eq 'CMD-READ-REQ') {
		$result = kMakeRecvAck($data);
	} elsif($cmd eq 'CMD-CLOSE-REQ') {
		$result = kMakeCloseAck($data);
	} elsif($cmd eq 'CMD-LISTEN-REQ') {
		$result = kMakeListenAck($data);
	} elsif($cmd eq 'CMD-CONNINFO-REQ') {
		$result = kMakeConnInfoAck($data);
	} elsif($cmd eq 'CMD-DATAINFO-REQ') {
		$result = kMakeDataInfoAck($data);
	} elsif($cmd eq 'CMD-CLEARBUFFER-REQ') {
		$result = kMakeClearAck($data);
	} elsif($cmd eq 'CMD-TLSSETUP-REQ') {
		$result = kMakeClearAck($data);
	} elsif($cmd eq 'CMD-TLSCLEAR-REQ') {
		$result = kMakeClearAck($data);
	} elsif($cmd eq 'CMD-PARSERATTACH-REQ') {
		$result = kMakeClearAck($data);
	} else {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"unknown command -- $cmd");

		return(undef);
	}

	return($result);
}



#----------------------------------------------------------------------#
# kMakeConnectSendAck()                                                #
#----------------------------------------------------------------------#
sub
kMakeConnectSendAck($)
{
	my ($data) = @_;

	my $value  = 0;
	my %result = ();

	my $function = 'kMakeConnectSendAck';

	my $size = 20;
	my $datalen = length($data);
	if($size != $datalen) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "\$datalen: $datalen -- ".
				  "requires just $size byte.");
		return(undef);
	}

	($result{'Command'},
	 $result{'RequestNum'},
	 $result{'Result'},
	 $result{'SocketID'},
	 $result{'DataID'},
	 $result{'TimeStamp'},
	 $result{'TimeStamp2'}) = unpack('n4 N3', $data);

	if ($result{'Result'} != 0) {
		my $val = sprintf("%x", $result{'Result'});
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "result: $result{'Result'}(0x$val) -- ".
				  "fails.");
#		return undef;    by hok
	}

	return(\%result);
}



#----------------------------------------------------------------------#
# kMakeSendAck()                                                       #
#----------------------------------------------------------------------#
sub
kMakeSendAck($)
{
	my ($data) = @_;

	my %result = ();

	my $function = 'kMakeSendAck';

	my $size = 20;
	my $datalen = length($data);
	if($size != $datalen) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "\$datalen: $datalen -- ".
				  "requires just $size byte.");
		return(undef);
	}

	($result{'Command'},
	 $result{'RequestNum'},
	 $result{'Result'},
	 $result{'SocketID'},
	 $result{'DataID'},
	 $result{'TimeStamp'},
	 $result{'TimeStamp2'}) = unpack('n4 N3', $data);

	if ($result{'Result'} != 0) {
		my $val = sprintf("%x", $result{'Result'});
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "result: $result{'Result'}(0x$val) -- ".
				  "fails.");
##		return undef;
	}

	return(\%result);
}



#----------------------------------------------------------------------#
# kMakeRecvAck()                                                       #
#----------------------------------------------------------------------#
sub
kMakeRecvAck($)
{
	my ($data) = @_;

	my $value  = 0;
	my %result = ();

	my $function = 'kMakeRecvAck';

	my $size    = 64;
	my $datalen = length($data);
	if($size > $datalen) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$datalen: $datalen -- ".
			"requires more than $size byte.");

		return(undef);
	}

	($result{'Command'},
	 $result{'RequestNum'},
	 $result{'Result'},
	 $result{'SocketID'},
	 $result{'DataID'},
	 $result{'TimeStamp'},
	 $result{'TimeStamp2'},
	 $result{'SrcPort'},
	 $result{'DstPort'},
	 $result{'AddrType'},
	 $result{'Reserve1'},
	 $result{'Reserve2'},
	 $data
	) = unpack('n4 N3 n2 C2 n a*', $data);

	if ($result{'Result'} != 0) {
		my $val = sprintf("%x", $result{'Result'});
		if ($result{'Result'} != 33025) {
			kReg_Common_Error(__FILE__, __LINE__, $function,
				  "result: $result{'Result'}(0x$val) -- ".
				  "fails.");
		}
		return(\%result);
		return undef;
	}

	($value, $data) = unpack('a16 a*', $data);
	$result{'SrcAddr'} = kInetNtoP($result{'AddrType'}, $value);
	unless(defined($result{'SrcAddr'})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "kInetNtoP: failure");

		return(\%result);
		return(undef);
	}

	($value, $data) = unpack('a16 a*', $data);
	$result{'DstAddr'} = kInetNtoP($result{'AddrType'}, $value);
	unless(defined($result{'DstAddr'})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "kInetNtoP: failure");

		return(\%result);
		return(undef);
	}

	($result{'DataLength'},
	 $result{'Data'}
	) = unpack('N a*', $data);

	if($datalen - $size != $result{'DataLength'}) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$datalen: $datalen -- requires $size byte.");

		return(\%result);
		return(undef);
	}
	return(\%result);
}



#----------------------------------------------------------------------#
# kMakeCloseAck()                                                      #
#----------------------------------------------------------------------#
sub
kMakeCloseAck($)
{
	my ($data) = @_;
	my %result = ();

	my $function = 'kMakeCloseAck';

	my $size = 8;
	my $datalen = length($data);
	if($size != $datalen) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$datalen: $datalen -- ".
			"requires just $size byte.");

		return(undef);
	}

	($result{'Command'},
	 $result{'RequestNum'},
	 $result{'Result'},
	 $result{'SocketID'}) = unpack('n4', $data);

	if ($result{'Result'} != 0) {
		my $val = sprintf("%x", $result{'Result'});
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "result: $result{'Result'}(0x$val) -- ".
				  "fails.");
##		return undef;
	}

	return \%result;
}



#----------------------------------------------------------------------#
# kMakeListenAck()                                                     #
#----------------------------------------------------------------------#
sub
kMakeListenAck($)
{
	my ($data) = @_;
	my %result = ();

	my $function = 'kMakeListenAck';

	my $size = 8;
	my $datalen = length($data);
	if($size != $datalen) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$datalen: $datalen -- ".
			"requires just $size byte.");

		return(undef);
	}

	($result{'Command'},
	 $result{'RequestNum'},
	 $result{'Result'},
	 $result{'SocketID'}) = unpack('n4', $data);

	if ($result{'Result'} != 0) {
		my $val = sprintf("%x", $result{'Result'});
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "result: $result{'Result'}(0x$val) -- ".
				  "fails.");
##		return undef;
	}

	return \%result;
}



#----------------------------------------------------------------------#
# kMakeConnInfoAck()                                                   #
#----------------------------------------------------------------------#
sub
kMakeConnInfoAck($)
{
	my ($data) = @_;
	my $value = 0;
	my %result = ();

	my $function = 'kMakeConnInfoAck';

	my $size    = 64;
	my $datalen = length($data);
	if($size != $datalen) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$datalen: $datalen -- ".
			"requires just $size byte.");

		return(undef);
	}

	($result{'Command'},
	 $result{'RequestNum'},
	 $result{'Result'},
	 $result{'Protocol'},
	 $result{'Connection'},
	 $result{'AddrType'},
	 $result{'Reserve1'},
	 $result{'Reserve2'},
	 $result{'SrcPort'},
	 $result{'DstPort'},
	 $data
	) = unpack('n3 C4 n3 a*', $data);

	if ($result{'Result'} != 0) {
		my $val = sprintf("%x", $result{'Result'});
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "result: $result{'Result'}(0x$val) -- ".
				  "fails.");
		return(\%result);
		return undef;
	}

	($value, $data) = unpack('a16 a*', $data);
	$result{'SrcAddr'} = kInetNtoP($result{'AddrType'}, $value);
	unless(defined($result{'SrcAddr'})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "kInetNtoP: failure");

		return(\%result);
		return(undef);
	}

	($value, $data) = unpack('a16 a*', $data);
	$result{'DstAddr'} = kInetNtoP($result{'AddrType'}, $value);
	unless(defined($result{'DstAddr'})) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "kInetNtoP: failure");

		return(\%result);
		return(undef);
	}

	($result{'FrameID'},
	 $result{'Interface'},
	 $result{'TLSmode'},
	 $result{'TLSssl'},
	 $result{'TLSsession'},
	) = unpack('n2 N3', $data);

	return \%result;
}



#----------------------------------------------------------------------#
# kMakeDataInfoAck()                                                   #
#----------------------------------------------------------------------#
sub
kMakeDataInfoAck($)
{
	my ($data) = @_;

	my $value = 0;
	my %result = ();

	my $function = 'kMakeDataInfoAck';

	my $size    = 20;
	my $datalen = length($data);
	if($size > $datalen) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$datalen: $datalen -- ".
			"requires more than $size byte.");

		return(undef);
	}

	($result{'Command'},
	 $result{'RequestNum'},
	 $result{'Result'},
	 $result{'SocketID'},
	 $result{'TimeStamp'},
	 $result{'TimeStamp2'},
	 $result{'DataLength'},
	 $data
	) = unpack('n4 N3 a*', $data);

	if ($result{'Result'} != 0) {
		my $val = sprintf("%x", $result{'Result'});
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "result: $result{'Result'}(0x$val) -- ".
				  "fails.");
		return(\%result);
		return undef;
	}

	if($datalen - $size != $result{'DataLength'}) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			       "\$datalen: $datalen -- requires $size byte.");

		return(\%result);
		return(undef);
	}

	$result{'Data'} = $data;

	return \%result;
}



#----------------------------------------------------------------------#
# kMakeClearAck()                                                      #
#----------------------------------------------------------------------#
sub
kMakeClearAck($)
{
	my ($data) = @_;
	my %result = ();

	my $function = 'kMakeClearAck';

	my $size = 6;
	my $datalen = length($data);
	if($size != $datalen) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "\$datalen: $datalen -- ".
				  "requires just $size byte.");
		return undef;
	}

	($result{'Command'},
	 $result{'RequestNum'},
	 $result{'Result'}
	 ) = unpack('n3', $data);

	if ($result{'Result'} != 0) {
		my $val = sprintf("%x", $result{'Result'});
		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "result: $result{'Result'}(0x$val) -- ".
				  "fails.");
		return(\%result);
		return undef;
	}

	return \%result;
}



#----------------------------------------------------------------------#
# kInetPtoN()                                                          #
#----------------------------------------------------------------------#
sub
kInetPtoN($$)
{
	my ($af, $src) = @_;

	my $function = 'kInetPtoN';

	my @elements = ();
	my $dst      = undef;

	if(($af != 4) && ($af != 6)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"unknown af -- $af");

		return(undef);
	}

	for( ; ; ) {
		if(($af == 4) && ($src =~ /^\s*([0-9\.]+)\s*$/)) {
			@elements = split(/\./, $1);

			for(my $d = scalar(@elements); $d < 16; $d ++) {
				push(@elements, '0');
			}

			$dst = pack('C16', @elements);

			last;
		}

		if(($af == 6) &&
		   ($src =~ /^\s*([0-9A-Za-z:]+)\s*$/)) {
			my ($upper, $lower) = split(/::/, $1);

			my @up  = ();
			my @low = ();

			if(defined($upper)) {
				@up = split(/:/, $upper);
			}

			if(defined($lower)) {
				@low = split(/:/, $lower);
			}

			for(my $d = scalar(@up); $d < 8 - scalar(@low); $d ++) {
				push(@up, '0');
			}

			foreach my $elm (@up, @low) {
				push(@elements, hex($elm));
			}

			$dst = pack('n8', @elements);

			last;
		}

		kReg_Common_Error(__FILE__, __LINE__, $function,
			"No address associated with hostname -- $src");

		return(undef);
	}

	return($dst);
}



#----------------------------------------------------------------------#
# kInetNtoP()                                                          #
#----------------------------------------------------------------------#
sub
kInetNtoP($$)
{
	my ($af, $src) = @_;

	my $function = 'kInetNtoP';

	my @elements = ();
	my $dst = undef;

	for( ; ; ) {
		if($af == 4) {
			my $size = 4;
			if(length($src) < $size) { ## by hok
				kReg_Common_Error(__FILE__, __LINE__, $function,
					"\$src -- requires $size bytes.");

				return(undef);
			}

			@elements = unpack('C4', $src);

			$dst = sprintf('%d.%d.%d.%d',
				$elements[0], $elements[1],
				$elements[2], $elements[3]);

			last;
		}

		if($af == 6) {
			my $size = 16;
			if(length($src) != $size) {
				kReg_Common_Error(__FILE__, __LINE__, $function,
					"\$src -- requires $size bytes.");

				return(undef);
			}

			@elements = unpack('n8', $src);

			my $abbr     = 0;
			my $compress = 0;
			my $cont     = 0;

			for(my $d = 1; $d < $#elements; $d ++) {
				if(!$abbr && !$elements[$d]) {
					$abbr ++;
					$compress ++;
				}

				if($elements[$d]) {
					$compress = 0;
					$cont     = 0;
				}

				if($compress) {
					unless($cont) {
						$dst .= ':';
						$cont ++;
					}

					next;
				}

				$dst .= sprintf(':%x', $elements[$d]);
			}

			$dst .= ':';

			unless(!$elements[0] && ($dst =~ /^::/)) {
				$dst = sprintf('%x%s', $elements[0], $dst);
			}

			unless(!$elements[$#elements] && ($dst =~ /::$/)) {
				$dst .= sprintf('%x', $elements[$#elements]);
			}

			last;
		}

		kReg_Common_Error(__FILE__, __LINE__, $function,
				  "unknown af -- $af");

		return(undef);
	}

	return($dst);
}



#----------------------------------------------------------------------#
# kInsert()                                                            #
#----------------------------------------------------------------------#
sub
kInsert($$;$$$)
{
	my ($base, $insert, $whence, $offset, $size) = @_;

	my $function = 'kInsert';

	my $_top_    = '';
	my $_middle_ = '';
	my $_bottom_ = '';

	my $_baselen_   = length($base);
	my $_insertlen_ = length($insert);

	unless(defined($whence)) {
		$whence = $_baselen_;
	}

	unless(defined($offset)) {
		$offset = 0;
	}

	unless(defined($size)) {
		$size = $_insertlen_ - $offset;
	}

	if(($whence < 0) || ($whence > $_baselen_)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$whence: invalid range -- $whence");
		return(undef);
	}

	if(($offset < 0) || ($offset > $_insertlen_)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$offset: invalid range -- $offset");
		return(undef);
	}

	if(($size   < 0) || ($size   > $_insertlen_)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$size: invalid range -- $size");
		return(undef);
	}

	if($offset + $size > $_insertlen_) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"\$offset + \$size: invalid range -- $offset + $size");
		return(undef);
	}

	if($whence) {
		$_top_ = substr($base, 0, $whence);
	}

	if($size) {
		$_middle_ = substr($insert, $offset, $size);
	}

	if($_baselen_ - $whence) {
		$_bottom_ = substr($base, $whence, $_baselen_ - $whence);
	}

	return($_top_. $_middle_. $_bottom_);
}



#----------------------------------------------------------------------#
# kInit_Common_Error()                                                 #
#----------------------------------------------------------------------#
sub
kInit_Common_Error()
{
	@strerror = ();

	return(undef);
}



#----------------------------------------------------------------------#
# kReg_Common_Error()                                                  #
#----------------------------------------------------------------------#
sub
kReg_Common_Error($$$$)
{
	my ($file, $line, $function, $string) = @_;

	my $basename = basename($file);
	printf("[%s][%s]\n",$function, $string);  # by hok
	push(
		@strerror,
		{
			'file'     => $basename,
			'line'     => $line,
			'function' => $function,
			'string'   => $string
		}
	);

	return(undef);
}



#----------------------------------------------------------------------#
# kDump_Common_Error()                                                 #
#----------------------------------------------------------------------#
sub
kDump_Common_Error()
{
	my $str = undef;

	foreach my $error (@strerror) {
		unless(defined($str)) {
			$str = '';
		}

		$str .= "$error->{'file'}: ";
		$str .= "$error->{'line'}: ";
		$str .= "kCommon::$error->{'function'}(): ";
		$str .= "$error->{'string'}";
		$str .= "\n";
	}

	kInit_Common_Error();

	return($str);
}



#----------------------------------------------------------------------#
# kLog_HTML()                                                          #
#----------------------------------------------------------------------#
sub
kLog_HTML($)
{
	my ($message) = @_;

	print("XXX: TBD\n");

	return(undef);
}



#----------------------------------------------------------------------#
# kModule_Initialize()                                                 #
#----------------------------------------------------------------------#
sub
kModule_Initialize(;$$)
{
	my ($path, $protocol) = @_;

	my $function = 'kModule_Initialize';

	unless(defined($path)) {
		$path = $DEFAULT_SOCKET_PATH;
	}

	unless(defined($protocol)) {
		$protocol = SOCK_STREAM;
	}

# by hok 
# 	my $prog     = $DEFAULT_SOCKIO_PATH;
# 	my $progname = basename($prog);

# 	kInit_Common_Error();
# 	if(-e $path) {
# 		kReg_Common_Error(__FILE__, __LINE__, $function,
# 			"make sure to terminate $progname and remove $path");

# 		my $strderror = kDump_Common_Error();

# 		if(defined($strderror)) {
# 			die "$strderror";
# 			# NOTREACHED
# 		}

# 		die '';
# 		# NOTREACHED
# 	}

	kInit_Common_Error();
# 	$SOCKETIO_PID = kBoot_SocketIO($prog, $path, $protocol);
# 	unless(defined($SOCKETIO_PID)) {
# 		kReg_Common_Error(__FILE__, __LINE__, $function,
# 			"kBoot_SocketIO: failure");

# 		my $strderror = kDump_Common_Error();

# 		if(defined($strderror)) {
# 			die "$strderror";
# 			# NOTREACHED
# 		}

# 		die '';
# 		# NOTREACHED
# 	}

	# XXX: should use defined()? have to know return value of new()
	kInit_Common_Error();

	unless(($SOCKFD =
		IO::Socket::UNIX->new('Type' => $protocol, 'Peer' => $path))) {

		kReg_Common_Error(__FILE__, __LINE__, $function,
			"$! -- Type: $protocol, Peer: $path");

		my $strderror = kDump_Common_Error();

		if(defined($strderror)) {
			die "$strderror";
			# NOTREACHED
		}

		die '';
		# NOTREACHED
	}
	printf("IO::Socket::UNIX->new[%s][%s]  OK\n",$protocol,$path);
	$SOCKFD->autoflush(1);

	return;
}



#----------------------------------------------------------------------#
# kModule_Terminate()                                                  #
#----------------------------------------------------------------------#
sub
kModule_Terminate(;$)
{
	my ($path) = @_;

	my $function = 'kModule_Terminate';

	unless(defined($path)) {
		$path = $DEFAULT_SOCKET_PATH;
	}

	close($SOCKFD);

	kInit_Common_Error();
	if($SOCKETIO_PID && !kill('TERM', $SOCKETIO_PID)) {
		kReg_Common_Error(__FILE__, __LINE__, $function,
			"kill: $SOCKETIO_PID: $!");

		my $strderror = kDump_Common_Error();

		if(defined($strderror)) {
			die "$strderror";
			# NOTREACHED
		}

		die '';
		# NOTREACHED
	}

	if(-e $path) {
##		unlink($path);
	}

	return;
}



#----------------------------------------------------------------------#
# kBoot_SocketIO()                                                     #
#----------------------------------------------------------------------#
sub
kBoot_SocketIO($$$)
{
	my ($prog, $path, $protocol) = @_;

	my $function = 'kBoot_SocketIO';

	local (*READHANDLE, *WRITEHANDLE);

	pipe(READHANDLE, WRITEHANDLE);

	my $pid = fork();

	unless(defined($pid)) {
		kReg_Common_Error(__FILE__, __LINE__, $function, "fork: $!");
		return(undef);
	}

	unless($pid) {
		# child process
		close(READHANDLE);

		unless(defined(open(STDOUT, ">&WRITEHANDLE"))) {
			print("exit: open: $!");
			exit(-1);
		}

		exec("$prog -p $path");
	}

	# parent process
	close(WRITEHANDLE);

	while(<READHANDLE>) {
		chomp;

		if($_ =~ /^([^:]+):\s*(.*)$/) {
			my $level   = $1;
			my $message = $2;

			if(($level eq 'pipe') &&
				($message =~ /^(\S+\s+)+ready$/)) {

				last;
			}

			if($level eq 'error') {
				kReg_Common_Error(__FILE__, __LINE__,
					$function, "$message");
				next;
			}

			if($level eq 'exit') {
				kReg_Common_Error(__FILE__, __LINE__,
					$function, "$message");
				close(READHANDLE);

				return(undef);
			}
		}
	}

	close(READHANDLE);

	return($pid);
}



# #----------------------------------------------------------------------#
# # sigchld()                                                            #
# #----------------------------------------------------------------------#
# sub
# sigchld()
# {
# 	waitpid($SOCKETIO_PID, 0);
# 
# 	return;
# }



#----------------------------------------------------------------------#
# BEGIN()                                                              #
#----------------------------------------------------------------------#
BEGIN
{
	$VERSION		= 1.00;
#	$DEFAULT_SOCKET_PATH	= "/tmp/koid.socket.$$";     by hok
	$DEFAULT_SOCKET_PATH	= "/tmp/koid-sip.socket";
	$DEFAULT_SOCKIO_PATH	= '/usr/local/koi-sip/bin/koid-sip';
	$SOCKETIO_PID		= 0;
	$SOCKFD			= 0;
	$SOCKIO_SEQ		= 0;
	@strerror		= ();

	%sockio_cmd		= (
		'CMD-CONNECT-REQ'	=> 0x0101,
		'CMD-CONNECT-ANS'	=> 0x8101,
		'CMD-SEND-REQ'		=> 0x0102,
		'CMD-SEND-ANS'		=> 0x8102,
		'CMD-READ-REQ'		=> 0x0103,
		'CMD-READ-ANS'		=> 0x8103,
		'CMD-CLOSE-REQ'		=> 0x0104,
		'CMD-CLOSE-ANS'		=> 0x8104,
		'CMD-LISTEN-REQ'	=> 0x0105,
		'CMD-LISTEN-ANS'	=> 0x8105,
		'CMD-CONNINFO-REQ'	=> 0x0106,
		'CMD-CONNINFO-ANS'	=> 0x8106,
		'CMD-DATAINFO-REQ'	=> 0x0107,
		'CMD-DATAINFO-ANS'	=> 0x8107,
		'CMD-CLEARBUFFER-REQ'	=> 0x0108,
		'CMD-CLEARBUFFER-ANS'	=> 0x8108,
		'CMD-TLSSETUP-REQ'	=> 0x0109,
		'CMD-TLSSETUP-ANS'	=> 0x8109,
		'CMD-TLSCLEAR-REQ'	=> 0x010A,
		'CMD-TLSCLEAR-ANS'	=> 0x810A,
		'CMD-PARSERATTACH-REQ'	=> 0x010B,
		'CMD-PARSERATTACH-ANS'	=> 0x810B,
	);

	%sockio_cmdlen = (
		'CMD-CONNECT-ANS'	=> 20,
		'CMD-SEND-ANS'		=> 20,
		'CMD-READ-ANS'		=>
			sub
			{
				my ($msg) = @_;

				if(length($msg) < 64) {
					return(64);
				}

				my $datalen = unpack("\@60 N \@*", $msg);

				return(64 + $datalen);
			},
		'CMD-CLOSE-ANS'		=> 8,
		'CMD-LISTEN-ANS'	=> 8,
		'CMD-CONNINFO-ANS'	=> 64,
		'CMD-DATAINFO-ANS'	=>
			sub {
				my ($msg) = @_;
				if(length($msg) < 20) {
					return(20);
				}

				my $datalen = unpack("\@16 N \@*", $msg);

				return(20 + $datalen);
			},
		'CMD-CLEARBUFFER-ANS'	=> 6,
		'CMD-TLSSETUP-ANS'	=> 6,
		'CMD-TLSCLEAR-ANS'	=> 6,
		'CMD-PARSERATTACH-ANS'	=> 6,
	);

	%sockio_proto		= (
		'TCP'	=> 1,
		'UDP'	=> 2,
		'TLS'	=> 3
	);

	%sockio_frame		= (
		'NULL'	=> 2,
		'DNS'	=> 3,
		'SIP'	=> 1
	);

	%sockio_af		= (
		'INET'	=> 4,
		'INET6'	=> 6
	);

	if(!defined($SIG{'CHLD'})) {
# 		$SIG{'CHLD'}	= \&sigchld;
		$SIG{'CHLD'}	= 'IGNORE';
	}

	kModule_Initialize();
}



#----------------------------------------------------------------------#
# END()                                                                #
#----------------------------------------------------------------------#
END
{
        kPacket_Close(0,0);
	kModule_Terminate();

	$SIG{'CHLD'} = 'DEFAULT';

	undef %sockio_af;
	undef %sockio_frame;
	undef %sockio_proto;
	undef %sockio_cmdlen;
	undef %sockio_cmd;
	undef @strerror;
	undef $SOCKIO_SEQ;
	undef $SOCKFD;
	undef $SOCKETIO_PID;
	undef $DEFAULT_SOCKIO_PATH;
	undef $DEFAULT_SOCKET_PATH;
	undef $VERSION;
}
1;
