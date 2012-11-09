#!/usr/bin/perl
#
# Copyright (C) IPv6 Promotion Council,
# NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT),
# Yokogwa Electoric Corporation, YASKAWA INFORMATION SYSTEMS Corporation
# and NTT Advanced Technology Corporation(NTT-AT) All rights reserved.
# 
# Technology Corporation.
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

package mip6cnt;

# use strict;
use Exporter;
@mip6cnt::ISA = qw(Exporter);

@mip6cnt::EXPORT = qw(
		      $CNT_Link
		      $CNT_SeqNo
		      $CNT_HOTIndex
		      $CNT_COTIndex
		      $CNT_HOTToken
		      $CNT_COTToken
		      %CNT_AutoResponse
		      @CNT_InitFail
		      $CNT_IPSec_mode

		      CNT_Initilize
		      CNT_IPSec_Initilize
		      CNT_TEST_Start
		      CNT_OK
		      CNT_NG
		      CNT_SendAndRecv
		      CNT_Send
		      CNT_Recv
		      CNT_Wait
		      CNT_WaitRateLimit
		      CNT_Mode
		      CNT_IsSupport
		      CNT_ChkSupport
		      CNT_InitCheck
		      
		      SQ_NS
		      SQ_RR
		      SQ_HoTI
		      SQ_CoTI
		      SQ_BU
		      SQ_UnBU
		      SQ_UnBU_Home
		      SQ_Echo
		      SQ_Echo_RH
		      SQ_EchoHoa
		      SQ_EchoHoa_BE
		      SQ_WaitMatchFrame
		      SQ_WaitMatchFrameRecv
		      
		      SD_RA
		      SD_HoTI
		      SD_CoTI
		      SD_BU
		      SD_ICMP
		      RV_HoT
		      RV_CoT
		      RV_BA
		      
		      GetSND
		      GetREV
		      GetUnKnownInfoMsg
		      UnKnownMatchPacket
		      IsMatchPacket
		      IsExistOpt
		      SetHomeAddress
		      SetCoAAddress
		      GetHomeAddress
		      GetCoAAddress
		      
		      LOG_Err
		      LOG_Warn
		      LOG_OK
		      LOG_Msg
		      
		      SQ_Test

		      $Warnflg
		      $UnExpected_thru_test
		      
		      IsUnExpectedPackets
);

BEGIN { }
END { }
use V6evalTool;

# for Debug
# $V6evalTool::Trace = 1;


%CN_CONF = (
	    'EXEC_NORMAL'	   => 'ON',     # NORMAL
	    'EXEC_ABNORMAL'	   => 'ON',     # ABNORMAL
	    'TIMEOUT'              => 2,        # 
	    'RR_TIMEOUT'           => 3,        # 
	    'INITIALIZE'           => 'BOOT',   # Method of initialization at each test script
	    'BRR_SUPPORT'          => 'ON',     # CN support BRR
	    'IPSEC_SUPPORT'        => 'ON',     # CN support IPSec
	    'IPSEC_EALGO'          => '3DES-CBC',
	    'IPSEC_EKEY'           => 'CNMNTEST0123456789ABCDEF',
	    'IPSEC_AALGO'          => 'HMAC-SHA1',
	    'IPSEC_AKEY'           => 'CNMNTEST0123456789AB',
	    'ALTCOA_SUPPORT'       => 'ON',     # CN support ALT Careof Address option
	    'DEREG_COTNONCEINDEX'  => 'NOCOT' , # COT:DeRegistration CoT Nonce Index Default value / NOCOT:0
	    'WAIT_RATELIMIT'       => 1,        # Wait before sending packets which causes BE,ICMP Error
	    'CN_ADDR_CONF'         => 'AUTO'    # CN assign global unicast address manually
);

%CN_CONF_DISP = (
	    'EXEC_NORMAL'	   => 'ON',
	    'EXEC_ABNORMAL'	   => 'ON',
	    'TIMEOUT'              => 'ON',
	    'RR_TIMEOUT'           => 'ON',
	    'INITIALIZE'           => 'ON',
	    'BRR_SUPPORT'          => 'ON',
	    'IPSEC_SUPPORT'        => 'ON',
	    'IPSEC_EALGO'          => 'ON',
	    'IPSEC_EKEY'           => 'ON',
	    'IPSEC_AALGO'          => 'ON',
	    'IPSEC_AKEY'           => 'ON',
	    'ALTCOA_SUPPORT'       => 'OFF',
	    'DEREG_COTNONCEINDEX'  => 'OFF',
	    'WAIT_RATELIMIT'       => 'ON',
	    'CN_ADDR_CONF'         => 'ON'
);


# -------------------------------------------------------------------------
#    Configuration
# -------------------------------------------------------------------------

open(CONFIG_TXT, "config.txt") || die "***** Configuration Error :\n Cannot Open file config.txt.\n";
while (<CONFIG_TXT>) {
    if ($_ !~ /^#|^\s+/){
	chop;
	/^(\S+)\s+(\S+)/;
	if (defined($CN_CONF{$1})) {
	    $CN_CONF{$1} = uc($2);
	}
    }
}
close(CONFIG_TXT);

open(CONFIG_TXT, "_config_.txt") || die "***** Configuration Error :\n Cannot Open file _config_.txt.\n";
while (<CONFIG_TXT>) {
    if ($_ !~ /^#|^\s+/){
	chop;
	/^(\S+)\s+(\S+)/;
	if (defined($CN_CONF{$1})) {
	    $CN_CONF{$1} = $2;
	}
    }
}
close(CONFIG_TXT);

sub CNT_IsSupport {
    my ($support) = @_;
    my ($name);
    $name='EXEC_NORMAL'     if($support eq 'NORMAL');
    $name='EXEC_ABNORMAL'   if($support eq 'ABNORMAL');
    $name='BRR_SUPPORT'    if($support eq 'BRR');
    $name='IPSEC_SUPPORT'  if($support eq 'IPSec');
    $name='ALTCOA_SUPPORT' if($support eq 'ALTCoA');
    if ($name ne none && $CN_CONF{$name} !~ m/^ON$/ ){
	LOG_Warn("CONFIG Parameter : $name = $CN_CONF{$name}");
	LOG_Warn("Skipped.");
	exit $V6evalTool::exitIgnore;
    }
}

sub CNT_ChkSupport {
    my ($support) = @_;
    my ($name);
    $name='BRR_SUPPORT'    if($support eq 'BRR');
    $name='IPSEC_SUPPORT'  if($support eq 'IPSec');
    $name='ALTCOA_SUPPORT' if($support eq 'ALTCoA');
    if ( $CN_CONF{$name} =~ /^ON$/ ){
	return(1);
    }else{
	return(0);
    }
}

#$ -------------------------------------------------------------------------
#$    Global variable
#$ -------------------------------------------------------------------------

 #$ fixed number

#$ Autonomous response message
%CNT_AutoResponse
 = (
    'Ns_Cn_R0_G_G_G_Sll' 		=> 'Na_Cn_R0_G_G_G_Tll',
    'Ns_Cn_R0_G_G_G'                    => 'Na_Cn_R0_G_G_G_Tll',
    'Ns_Cn_R0_G_M_G_Sll'                => 'Na_Cn_R0_G_G_G_Tll',
    'Ns_Cn_R0_G_M_L_Sll'                => 'Na_Cn_R0_L_G_L_Tll',
    'Ns_Cn_R0_G_L_L_Sll'                => 'Na_Cn_R0_L_G_L_Tll',
    'Ns_Cn_R0_G_L_L'                    => 'Na_Cn_R0_L_G_L_Tll',
    'Ns_Cn_R0_L_G_G_Sll'                => 'Na_Cn_R0_G_L_G_Tll',
    'Ns_Cn_R0_L_G_G'                    => 'Na_Cn_R0_G_L_G_Tll',
    'Ns_Cn_R0_L_M_G_Sll'                => 'Na_Cn_R0_G_L_G_Tll',
    'Ns_Cn_R0_L_M_L_Sll'                => 'Na_Cn_R0_L_L_L_Tll',
    'Ns_Cn_R0_L_L_L_Sll'                => 'Na_Cn_R0_L_L_L_Tll',
    'Ns_Cn_R0_L_L_L'                    => 'Na_Cn_R0_L_L_L_Tll',
    );

#$ BU,BA Default Parameter Setup
$CNT_RR_REG_INDEX = '-DHOINDEX=$CNT_HOTIndex -DCOINDEX=$CNT_COTIndex ' . 
		    '-DHOKEYGENTOKEN=\\\\\"$CNT_HOTToken\\\\\" -DCOKEYGENTOKEN=\\\\\"$CNT_COTToken\\\\\" ' .
                    '-DBU_SEQNO=$CNT_SeqNo -DBA_SEQNO=$CNT_SeqNo ';

if( $CN_CONF{'DEREG_COTNONCEINDEX'} eq 'COT' ){
$CNT_RR_DEREG_INDEX = '-DHOINDEX=$CNT_HOTIndex -DCOINDEX=$CNT_COTIndex ' . 
		      '-DHOKEYGENTOKEN=\\\\\"$CNT_HOTToken\\\\\" -DCOKEYGENTOKEN=\\\\\"$CNT_COTToken\\\\\" ' .
                      '-DBU_SEQNO=$CNT_SeqNo -DBA_SEQNO=$CNT_SeqNo ';
}
else{
$CNT_RR_DEREG_INDEX = '-DHOINDEX=$CNT_HOTIndex -DCOINDEX=0 ' . 
		      '-DHOKEYGENTOKEN=\\\\\"$CNT_HOTToken\\\\\" -DCOKEYGENTOKEN=\\\\\"$CNT_COTToken\\\\\" ' .
                      '-DBU_SEQNO=$CNT_SeqNo -DBA_SEQNO=$CNT_SeqNo ';
}

#$ Sequence number Preservation File
$CNT_SQNO_FILE   = "SQNo";
$CNT_NODEID_FILE = "NDID";

#$ Timeout
$CNT_TimeOut = $CN_CONF{'TIMEOUT'};
$CNT_RRTimeOut = $CN_CONF{'RR_TIMEOUT'};

#$ Execution Parameter
$CNT_Link = 'Link0';

#$ Execution mode(MD_INIT: Test Preparation  MD_TEST:Test Execution)
$CNT_Mode = 'MD_INIT';

#$ Execution parameter and Execution result Substitution
$CNT_SeqNo=0;

#$ An execution result is substituted.
$CNT_HomeAddr='';
$CNT_CoAAddr ='';
$CNT_HOME_Prefix='3ffe:501:ffff:104';
$CNT_COA_Prefix ='3ffe:501:ffff:101';
$CNT_NUT_Prefix ='3ffe:501:ffff:100';
$CNT_HOME_NodeID=2;
$CNT_COA_NodeID=2;

$CNT_HOTIndex=0;
$CNT_COTIndex=0;
$CNT_HOTToken="";
$CNT_COTToken="";

#$ Frame management information
$CNT_SendFrame='';
$CNT_RecvFrame='';
$CNT_UnKnownFrame='';

# UnKnown but Replaced pakets in the INITIALIZATION mode
@CNT_InitFail=();

# In the sequence require IPSec, this value is set to 'ON' in the SEQ file
$CNT_IPSec_mode='OFF';
$CNT_SN_ESP=1;
$CNT_SPI_BASE=0x2000;


#$ -------------------------------------------------------------------------
#$    Function
#$ -------------------------------------------------------------------------

#$ SendAnsRecv　: The function of transmission and reception
#$  Argument
#$    The associative list of transmission and reception, Timeout, The associative list which answers independently, Interface
sub CNT_SendAndRecv {
    my ($frames,$unknown,$timeout,$autoResponse,$link,$clear_flag) = @_;
    my ($startTime,@recvFrames,@unknown,$cpp,$status,%ret,$dup,$tmp,$n,$i,$fr);
    my ( $spi_base, $transport_spi_mnhoa_to_cn, $transport_spi_cn_to_mnhoa );

    if( $#_ < 5 ){
	$clear_flag = 1;
    }
    @recvFrames=();
    $status='OK';
    %ret=();
    
    #$ Elimination of a message buffer
    if( $clear_flag eq 1 ){
	vClear($link);
    }
    $CNT_SendFrame='';
    $CNT_RecvFrame='';
    $CNT_UnKnownFrame='';

    if( $CNT_IPSec_mode eq 'ON' ){
	$spi_base            = $CNT_SPI_BASE;
	$transport_spi_mnhoa_to_cn = $spi_base +1;
	$transport_spi_cn_to_mnhoa = $spi_base +2;
    }
    
    #$ If there is a frame which should be transmitted A setup of the pre-process character sequence which changes the packet of the frame
    for($i=0; $i<=$#$frames; $i++){
	if( ($$frames[$i]{'Status'} eq '') && $$frames[$i]{'Send'}){
	    #$ Registration of a pre-process format character sequence
	    $cpp= eval "sprintf \"$$frames[$i]{'SendModf'} -DHOME_ADDR=$CNT_HomeAddr -DCAREOF_ADDR=$CNT_CoAAddr\"";
	    if( $CNT_IPSec_mode eq 'ON' ){
		$cpp .= " -DHAVE_IPSEC -DSEQ_ESP=$CNT_SN_ESP";
		$cpp .= " -DTRANSPORT_SPI_MNHOA_TO_CN=$transport_spi_mnhoa_to_cn -DTRANSPORT_SPI_CN_TO_MNHOA=$transport_spi_cn_to_mnhoa";
	    }
	    # $cpp= eval "sprintf \"$$frames[$i]{'SendModf'}\"";
	    # print "send vCPP=" ,$cpp, "\n";
	    vCPP( $cpp );
	    
	    #$ Frame transmission
	    $dup = {};
	    %$dup = vSend($link, $$frames[$i]{'Send'} );
	    if( $dup->{status} != 0 ){
		LOG_Err("status=$dup->{status}");
		exit $V6evalTool::exitFail;
	    }
	    
	    #$ A setup of a state
	    if( $dup->{status} == 0 ){
		$$frames[$i]{'Status'}='Send';
		$$frames[$i]{'SendFrame'}=$dup;
		$CNT_SendFrame=$dup;
	    }
	}
    }

    #$ A pre-process format character sequence is released.
    vCPP( "" );

    #$ The frame list for reception is created.
    for($cpp='',$i=0; $i<=$#$frames; $i++){
	if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
	    $tmp = $$frames[$i]{'Recv'};
	    for($n=0;$n<=$#$tmp;$n++){
		push( @recvFrames,$$tmp[$n]);
	    }
	}
	else {
	    push( @recvFrames,$$frames[$i]{'Recv'});
	}
	#$ Creation of a receiving pre-process format character sequence
	if($$frames[$i]{'RecvModf'} ne ''){
	    $cpp= $cpp . " " . $$frames[$i]{'RecvModf'};
	}
    }

    #$ Registration of a receiving pre-process format character sequence
    $cpp= eval "sprintf \"$cpp -DHOME_ADDR=$CNT_HomeAddr -DCAREOF_ADDR=$CNT_CoAAddr\"";
    if( $CNT_IPSec_mode eq 'ON' ){
	$cpp .= " -DHAVE_IPSEC -DSEQ_ESP=$CNT_SN_ESP";
	$cpp .= " -DTRANSPORT_SPI_MNHOA_TO_CN=$transport_spi_mnhoa_to_cn -DTRANSPORT_SPI_CN_TO_MNHOA=$transport_spi_cn_to_mnhoa";
    }
    # $cpp= eval "sprintf \"$cpp\"";
    # print "recv vCPP=" ,$cpp, "\n";
    vCPP( $cpp );

#    print "Recv CCP => $cpp\n";
#    print "recvFrames => @recvFrames\n";

    #$ Start time is saved.
    $startTime=time();

    #$ It repeats to a timeout.
    while(time() < $startTime+$timeout){
	my $recv = '';
	my $send = '';

	#$ The duplicate of the associative arrangement to receive is prepared.
	$dup = {};

	#$ Frame reception
	%$dup = vRecv($link, 1, 0, 1, sort(keys(%$autoResponse)), sort(@recvFrames) );

	#$ Unknown packet receiving 
	if( $dup->{status}==2 && $dup->{'Frame_Ether.Packet_IPv6'} ){
	    
	    #
	    # 2006/11/15
	    # 4.0.2 detection of unexpected packets and mark  
	    #
	    if( !$UnExpected_thru_test ) {

		if( IsMatchPacket('MH',$dup) ){
		    #
		    # mark
		    $UnExpected_thru_test = 1;
		}
	    }

	    push( @$unknown,AddUnKnownInfo($dup,\@recvFrames) );
	    goto NEXT;
	}

	#$ It skips except normal
	if( $dup->{status}!=0 ){
	    goto NEXT;
	}

	#$ In the case of the frame which answers autonomously, an autonomous response is returned.
	while(($recv, $send) = each(%$autoResponse)) {
	    if( ($dup->{'recvFrame'} eq $recv) && ($send ne 'ignore') ) {
		%ret = vSend($link, $send);
		if( $ret{status} != 0 ){
		    LOG_Err("status=$ret{status}");
		    exit $V6evalTool::exitFail;
		}
		goto NEXT;
	    }
	}

	#$ In the case of a receiving frame, a receiving frame is saved to an associative list, and it builds a flag finishing reception
	for($i=0; $i<=$#$frames; $i++){
	    if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
		$tmp = $$frames[$i]{'Recv'};
		for($n=0;$n<=$#$tmp;$n++){
		    if($dup->{'recvFrame'} eq $$tmp[$n]) {
			#$ A return value is set up.
			$$frames[$i]{'Status'}='Recv';
			$$frames[$i]{'RecvFrame'}=$dup;
			$CNT_RecvFrame=$dup;
		    }
		}
	    }
	    else {
		if($dup->{'recvFrame'} eq $$frames[$i]{'Recv'}) {
		    #$ A return value is set up.
		    $$frames[$i]{'Status'}='Recv';
		    $$frames[$i]{'RecvFrame'}=$dup;
		    $CNT_RecvFrame=$dup;
#		    print "Set RecvFrame $i==$dup->{'recvFrame'}\n";
		}
	    }
	}

	#$ It repeats until it receives all the frames that should be received.
	for($i=0; $i<=$#$frames; $i++){
	    if($$frames[$i]{'Status'} ne 'Recv') {
		goto NEXT;
	    }
	}
	last;
      NEXT:
    }

    #$ The whole status is decided.
    #$   All Recv -> OK  unknown packet -> UnKnown  Others -> Timeout
    for($i=0; $i<=$#$frames; $i++){
	if($$frames[$i]{'Status'} ne 'Recv'){
	    if( $$unknown[0] ){
		$status='UnKnown';
		$CNT_UnKnownFrame=$unknown;
	    }
	    else {
		$status='TimeOut';
	    }
	    last;
	}
    }
  EXIT:
    print "CNT_SendAndRecv Status=$status\n";
    return($status);
}

#$ CNT_SendAndRecv_Continue : The function of transmission and reception
#$  Argument
#$    The associative list of transmission and reception, An unknown frame, The number transmitted continuously, Timeout, The associative list which answers independently, Interface. 
#$    It waits for reception of the same number as the transmitted number, after transmitting continuously a number of transmitting frames specified by "the number transmitted continuously." 
#$    This is repeated till timeout time. 
#$    During this period, if the packet specified by Mode=Break is received, It will return.
sub CNT_SendAndRecv_Continue {
    my ($frames,$unknown,$sendCount,$timeout,$autoResponse,$link) = @_;
    my ($startTime,@recvFrames,$cpp,$status,%ret,$tmp,$n,$i);
    my ($recv,$send,$recvCount,$recvCpp);
    @recvFrames=();
    $status='OK';
    %ret=();
    
    #$ Elimination of a message buffer
    vClear($link);
    $CNT_SendFrame='';
    $CNT_RecvFrame='';
    $CNT_UnKnownFrame='';

    #$ The frame list for reception is created.
    for($cpp='',$i=0; $i<=$#$frames; $i++){
	if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
	    $tmp = $$frames[$i]{'Recv'};
	    for($n=0;$n<=$#$tmp;$n++){
		push( @recvFrames,$$tmp[$n]);
	    }
	}
	else {
	    push( @recvFrames,$$frames[$i]{'Recv'});
	}
	#$ Creation of a receiving pre-process format character sequence
	if($$frames[$i]{'RecvModf'} ne ''){
	    $cpp= $cpp . " " . $$frames[$i]{'RecvModf'};
	}
    }
    #$ Registration of a receiving pre-process format character sequence
    $recvCpp= eval "sprintf \"$cpp -DHOME_ADDR=$CNT_HomeAddr -DCAREOF_ADDR=$CNT_CoAAddr\"";

    #$ Start time is saved.
    $startTime=time();

    #$ It repeats until it becomes a timeout
    while(time() < $startTime+$timeout){
    
	#$ If there is a frame which should be transmitted, define the strings for pre-processing to change the packets
	for($i=0; $i<=$#$frames; $i++){
	    if( $$frames[$i]{'Send'} ){
		
		#$ Registration of a pre-procesing format character sequence
		$cpp= eval "sprintf \"$$frames[$i]{'SendModf'} -DHOME_ADDR=$CNT_HomeAddr -DCAREOF_ADDR=$CNT_CoAAddr\"";
		# $cpp= eval "sprintf \"$$frames[$i]{'SendModf'}\"";
		# print "send vCPP=" ,$cpp, "\n";
		vCPP( $cpp );
		
		#$ A frame is transmitted continuously
		for($n=0; $n<$sendCount; $n++){
		    %ret = vSend($link, $$frames[$i]{'Send'} );
		    if( $ret{status} != 0 ){
			LOG_Err("status=$ret{status}");
			exit $V6evalTool::exitFail;
		    }
		}
	    }
	}
	
	#$ It changes to the pre-process format for reception
	vCPP( $recvCpp );
	
	#$ Reception for frame continuation transmission
	for($recvCount=0; $recvCount<$sendCount && time()<$startTime+$timeout ;){
	    $recv = '';
	    $send = '';
	    
	    #$ Frame reception
	    %ret = vRecv($link, 1, 0, 1, sort(keys(%$autoResponse)), sort(@recvFrames) );
	    
	    #$ It skips except normal
	    if( $ret{status}!=0 ){
		goto NEXT;
	    }
	    
	    #$ In the case of an autonomous response frame, an autonomous response is returned
	    while(($recv, $send) = each(%$autoResponse)) {
		if( $ret{'recvFrame'} eq $recv ){
		    if( $send ne 'ignore' ) {
			%ret = vSend($link, $send);
			if( $ret{status} != 0 ){
			    LOG_Err("status=$ret{status}");
			    exit $V6evalTool::exitFail;
			}
		    }
		    goto NEXT;
		}
	    }
	    
	    #$ In the case of a receiving frame, A receiving frame is saved to an associative list. A flag "finishing reception" is built.
	    for($i=0; $i<=$#$frames; $i++){
		if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
		    $tmp = $$frames[$i]{'Recv'};
		    for($n=0;$n<=$#$tmp;$n++){
			if($ret{'recvFrame'} eq $$tmp[$n]) {
			    # If an end frame is received, it will escape from the whole loop
			    if($$frames[$i]{'Mode'} eq 'Break'){
				$$frames[$i]{'Status'}='Recv';
				$$frames[$i]{'RecvFrame'}=\%ret;
				$CNT_RecvFrame=\%ret;
				goto EXIT;
			    }
			    else{
				$recvCount++;
			    }
			}
		    }
		}
		else {
		    if($ret{'recvFrame'} eq $$frames[$i]{'Recv'}) {
			# If an end frame is received, it will escape from the whole loop
			if($$frames[$i]{'Mode'} eq 'Break'){
			    $$frames[$i]{'Status'}='Recv';
			    $$frames[$i]{'RecvFrame'}=\%ret;
			    $CNT_RecvFrame=\%ret;
			    goto EXIT;
			}
			else{
			    $recvCount++;
			}
		    }
		}
	    }
	  NEXT:
	}
    }

    $status='TimeOut';
  EXIT:
    print "CNT_SendAndRecv_Continue Status=$status\n";
    return($status);
}

#$ Transmitting processing
#$  Argument
#$    The associative list of transmission and reception, Interface
sub CNT_Send($$) {
    my ($frames,$link) = @_;
    my ($cpp, $status,$dup,$i);
    $status='OK';
    my ( $spi_base, $transport_spi_mnhoa_to_cn, $transport_spi_cn_to_mnhoa );
    
    $CNT_SendFrame='';

    if( $CNT_IPSec_mode eq 'ON' ){
	$spi_base            = $CNT_SPI_BASE;
	$transport_spi_mnhoa_to_cn = $spi_base +1;
	$transport_spi_cn_to_mnhoa = $spi_base +2;
    }

    #$ If there is a frame which should be transmitted, define the strings for pre-processing to change the packets
    for($i=0; $i<=$#$frames; $i++){
	if( ($$frames[$i]{'Status'} eq '') &&  $$frames[$i]{'Send'}){
	    
	    #$ Registration of a pre-process format character sequence
	    $cpp= eval "sprintf \"$$frames[$i]{'SendModf'} -DHOME_ADDR=$CNT_HomeAddr -DCAREOF_ADDR=$CNT_CoAAddr\"";
	    if( $CNT_IPSec_mode eq 'ON' ){
		$cpp .= " -DHAVE_IPSEC  -DSEQ_ESP=$CNT_SN_ESP";
		$cpp .= " -DTRANSPORT_SPI_MNHOA_TO_CN=$transport_spi_mnhoa_to_cn -DTRANSPORT_SPI_CN_TO_MNHOA=$transport_spi_cn_to_mnhoa";
	    }
	    vCPP( $cpp );
	    
	    #$ Frame transmission
	    $dup = {};
	    %$dup = vSend($link, $$frames[$i]{'Send'} );
	    if( $dup->{status} != 0 ){
		LOG_Err("status=$dup->{status}");
		exit $V6evalTool::exitFail;
	    }
	    
	    #$ State setup
	    if( $dup->{status} == 0 ){
		$$frames[$i]{'Status'}='Send';
		$$frames[$i]{'SendFrame'}=$dup;
		$CNT_SendFrame=$dup;
	    }
	}
    }
    
    #$ Registration of a pre-process format character sequence
    vCPP( "" );

    #$ Return Status
    for($i=0; $i<=$#$frames; $i++){
	if($$frames[$i]{'Status'} ne 'Send'){
	    $status='NG';
	}
    }

    return $status;
}

#$ Recv Receiving function
#$  Argument
#$    Associative list of reception, Timeout, Associative list of independence responses、Interface
sub CNT_Recv {
    my ($frames,$unknown,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 4 ){ $link=$CNT_Link; }
    if( $#_ < 3 ){ $autoResponse=\%CNT_AutoResponse; }
    my ($startTime,@recvFrames,$status,%ret,$dup,$tmp,$n,$i,$cpp);
    my ( $spi_base, $transport_spi_mnhoa_to_cn, $transport_spi_cn_to_mnhoa );    
    @recvFrames=();$status='OK';%ret=(),$cpp='';
    
    $CNT_RecvFrame='';
    $CNT_UnKnownFrame='';

    if( $CNT_IPSec_mode eq 'ON' ){
	$spi_base            = $CNT_SPI_BASE;
	$transport_spi_mnhoa_to_cn = $spi_base +1;
	$transport_spi_cn_to_mnhoa = $spi_base +2;
    }

    #$ Creation of the frame list for reception
    for($cpp='',$i=0; $i<=$#$frames; $i++){
	if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
	    $tmp = $$frames[$i]{'Recv'};
	    for($n=0;$n<=$#$tmp;$n++){
		push( @recvFrames,$$tmp[$n]);
	    }
	}
	else {
	    push( @recvFrames,$$frames[$i]{'Recv'});
	}
	#$ Creation of a receiving pre-process format character sequence
	if($$frames[$i]{'RecvModf'} ne ''){
	    $cpp= $cpp . " " . $$frames[$i]{'RecvModf'};
	}
    }
    #$ Registration of a pre-process format character sequence for reception
    $cpp= eval "sprintf \"$cpp -DHOME_ADDR=$CNT_HomeAddr -DCAREOF_ADDR=$CNT_CoAAddr\"";
    if( $CNT_IPSec_mode eq 'ON' ){
	$cpp .= " -DHAVE_IPSEC -DSEQ_ESP=$CNT_SN_ESP";
	$cpp .= " -DTRANSPORT_SPI_MNHOA_TO_CN=$transport_spi_mnhoa_to_cn -DTRANSPORT_SPI_CN_TO_MNHOA=$transport_spi_cn_to_mnhoa";
    }
    vCPP( $cpp );

    #$ Start time is saved
    $startTime=time();

    #$ It repeats to a timeout
    while(time() < $startTime+$timeout){
	my $recv = '';
	my $send = '';

	#$ The duplicate of the associative arrangement to receive is prepared
	$dup = {};

	#$ Frame reception
	%$dup = vRecv($link, 1, 0, 1, sort(keys(%$autoResponse)), sort(@recvFrames) );

	#$ Unknown packet is received 
	if( $dup->{status}==2 && $dup->{'Frame_Ether.Packet_IPv6'} ){
	    push( @$unknown,AddUnKnownInfo($dup,\@recvFrames) );
	    goto NEXT;
	}

	#$ It skips except normal
	if( $dup->{status}!=0 ){
	    goto NEXT;
	}

	#$ In the case of an autonomous response frame, an autonomous response is returned
	while(($recv, $send) = each(%$autoResponse)) {
	    if( ($dup->{'recvFrame'} eq $recv) && ($send ne 'ignore') ) {
		%ret = vSend($link, $send);
		if( $ret{status} != 0 ){
		    LOG_Err("status=$ret{status}");
		    exit $V6evalTool::exitFail;
		}
		goto NEXT;
	    }
	}
	
	#$ In the case of a receiving frame, A receiving frame is saved to an associative list. A flag "finishing reception" is built
	for($i=0; $i<=$#$frames; $i++){
	    if( ref($$frames[$i]{'Recv'}) eq 'ARRAY'){
		$tmp = $$frames[$i]{'Recv'};
		for($n=0;$n<=$#$tmp;$n++){
		    if($dup->{'recvFrame'} eq $$tmp[$n]) {
			#$ Return value setup
			$$frames[$i]{'Status'}='Recv';
			$$frames[$i]{'RecvFrame'}=$dup;
			$CNT_RecvFrame=$dup;
		    }
		}
	    }
	    else {
		if($dup->{'recvFrame'} eq $$frames[$i]{'Recv'}) {
		    #$ Return value setup
		    $$frames[$i]{'Status'}='Recv';
		    $$frames[$i]{'RecvFrame'}=$dup;
		    $CNT_RecvFrame=$dup;
		}
	    }
	}
	
	#$ It will escape, if all the frames that should be received are received
	for($i=0; $i<=$#$frames; $i++){
	    if($$frames[$i]{'Status'} ne 'Recv') {
		goto NEXT;
	    }
	}
	last;
      NEXT:
    }

    #$ The whole status is decided
    #$   All Recv -> OK  unknown packet -> UnKnown  Others -> Timeout
    for($i=0; $i<=$#$frames; $i++){
	if($$frames[$i]{'Status'} ne 'Recv'){
	    if( $$unknown[0] ){
		$CNT_UnKnownFrame=$unknown;
		$status='UnKnown';
	    }
	    else {
		$status='TimeOut';
	    }
	    last;
	}
    }
  EXIT:
    return($status);
}

#$ Wait : The function of transmission and reception
#$  Argument
#$    Associative list of reception, Timeout, The associative list of independence responses, Interface
sub CNT_Wait {
    my ($timeout,$autoResponse,$link) = @_;
    if( $#_ < 2 ){ $link=$CNT_Link; }
    if( $#_ < 1 ){ $autoResponse=\%CNT_AutoResponse; }

    my ($startTime,$status,%ret,$dup,$count);
    
    $status='OK';%ret=();
    $count=0;
    LOG_Msg("Wait $timeout sec.");

    #$ Elimination of a message buffer
    vClear($link);

    #$ Start time is saved
    $startTime=time();

    #$ It repeats to a timeout
    while(time() < $startTime+$timeout){
	my $recv = '';
	my $send = '';

	#$ The duplicate of the associative arrangement to receive is prepared
	$dup = {};
	#$ Frame reception
	%$dup = vRecv($link, 1, 0, 0, sort(keys(%$autoResponse)) );

	#$ In the case of an autonomous response frame, an autonomous response is returned
	while(($recv, $send) = each(%$autoResponse)) {
	    if( ($dup->{'recvFrame'} eq $recv) && ($send ne 'ignore') ) {
		%ret = vSend($link, $send);
		if( $ret{status} != 0 ){
		    LOG_Err("status=$ret{status}");
		    exit $V6evalTool::exitFail;
		}
		last;   #$ Escape from a while loop
	    }
	}
	$count++;
	print(".") if(($count % 10) == 0);
    }
    return($status);
}

sub CNT_WaitRateLimit(){
    my $wait_time = $CN_CONF{'WAIT_RATELIMIT'};
    CNT_Wait($wait_time);
}

#$ Information acquisition of an unknown packet
#$   The difference with the packet to expect is returned
#$    (({UnKnown}unknown packet {Info}[({Frame}The name of the packet to expect:{UnMatch}NG list) ({Frame}The name of the packet to expect:{UnMatch}NG list)..])
#$    (({UnKnown}unknown packet {Info}[({Frame}The name of the packet to expect:{UnMatch}NG list) ({Frame}The name of the packet to expect:{UnMatch}NG list)..])
sub AddUnKnownInfo()
{
    my ($unknown,$recvFrames) = @_;
    my ($i,$n,%unMatchInfo,%info,$info,@infos,@fileds);

    for($i=0; $i<=$#$recvFrames; $i++){

#	print("UnKnownFrameInfo==$$recvFrames[$i] $V6evalTool::fCnt\n");

	for($n=1;$n<=$V6evalTool::fCnt;$n++){

	    if( $V6evalTool::pktrevers[$n] =~ /^=+$$recvFrames[$i]=+$/mg){
		@fileds=();
		%info={};
#		while( $V6evalTool::pktrevers[$n] =~ /^ng compare .*$$recvFrames[$i].(\w+) received.*$/mg){
		while( $V6evalTool::pktrevers[$n] =~ /^ng compare .*\.(\w+) received.*$/mg){
		    push( @fileds, $1 );
		}
		
		$V6evalTool::pktrevers[$n] =~ /^=+$$recvFrames[$i]=+$/mg;
		while( $V6evalTool::pktrevers[$n] =~ /^ng meta .*\.(\w+) != .*$/mg){
		    print "$$recvFrames[$i] $1\n";
		    push( @fileds, $1 );
		}
		%info = (Frame => $$recvFrames[$i], UnMatch => \@fileds);
		push( @infos, \%info );
	    }

	}
    }
    if(0){
	for($n=0; $n<=$#infos; $n++){
	    print "UnKnownFrameInfo Frame=>",$infos[$n]->{Frame};
	    $info = $infos[$n]->{UnMatch};
	    for($i=0; $i<=$#$info; $i++){
		print " " , $$info[$i];
	    }
	    print "\n";
	}
    }
    %unMatchInfo = (UnKnown => $unknown, Info => \@infos);
    return(\%unMatchInfo);
}

#$ Dumping of an unknown packet (for debugging)
sub Dump_UnKnownInfo {
    my ($unknown) = @_;
    my ($i,$n,$m,$infos,$info);

    for($i=0; $i<=$#$unknown; $i++){
	print "UnKnown Pkt=>" , $$unknown[$n]->{UnKnown},"\n";
	$infos=$$unknown[0]->{Info};
	for($n=0; $n<=$#$infos; $n++){
	    print "Match Frame =",$$infos[$n]->{Frame};
	    $info = $$infos[$n]->{UnMatch};
	    for($m=0; $m<=$#$info; $m++){
		print " " . $$info[$m];
	    }
	    print "\n";
	}
    }
}

#$ The unknown packet list acquired by the sequence performed immediately before is acquired
sub GetUnKnownInfo {
    my ($frameName, $unknown) = @_;
    if( $#_ < 1 ){ $unknown=$CNT_UnKnownFrame; }
    my ($i,$n,$infos,$info);

    for($i=0; $i<=$#$unknown; $i++){
	$infos=$$unknown[$i]->{Info};
	for($n=0; $n<=$#$infos; $n++){
#	    print "fr=" ,$frameName, "  Un=" ,$$infos[$n]->{Frame},"\n";
	    if( $frameName eq $$infos[$n]->{Frame} ){
		$info = $$infos[$n]->{UnMatch};
#		print "UnMatch=@$info\n";
		return @$info;
	    }
	}
    }
}

#$ "The field inharmonious information it was considered that was an unknown packet" is acquired by the sequence performed immediately before
sub GetUnKnownInfoMsg {
    my ($pkt) = @_;
    if( $#_ < 0 ){ $pkt=$CNT_RecvFrame; }
    my $unknown=$CNT_UnKnownFrame;

    my ($i,$infos,$info);
    for($i=0; $i<=$#$unknown; $i++){
	if( $$unknown[$i]->{UnKnown} eq $pkt ){
	    $infos=$$unknown[$i]->{Info};
	    if( $infos && $$infos[0]->{UnMatch} ){
		$info = $$infos[0]->{UnMatch};
		return( "Unexpented fields value @$info" );
	    }
	}
    }
    return("Receive Unexpented Packet");
}

#$ In the unknown packet list acquired by the sequence performed immediately before, it investigates "there are some which are in agreement with the packet of the kind specified by Argument."
sub UnKnownMatchPacket {
    my ($frameName,$unknown) = @_;
    if( $#_ < 1 ){ $unknown=$CNT_UnKnownFrame; }
    my ($n,$frame);

    for($n=0; $n<=$#$unknown; $n++){
	print "UnKnown Pkt=>" , $$unknown[$n]->{UnKnown},"\n";
	$frame=IsMatchPacket($frameName,$$unknown[$n]->{UnKnown});
	return $frame if($frame);
    }
    return '';
}

#$ In the unknown packet list acquired by the sequence performed immediately before, it investigates "there are some which are in agreement with the packet specified by Argument." 
#$ This packet is made into receiving packet information when found. 
#$ Status serves as "Replace."
sub ReplaceUnKnownToRecvFrame {
    my ($frameName,$unknown) = @_;
    if( $#_ < 1 ){ $unknown=$CNT_UnKnownFrame; }
    my ($frame);

    $frame = UnKnownMatchPacket($frameName,$unknown);
    if( $frame ){
	$CNT_RecvFrame=$frame;
	return 'Replace';
    }
    return 'UnKnown';
}


#$ The field value of a receiving packet is acquired
sub GetREV {
    my ($pktName,$fieldName,$frame) = @_;
    if( $#_ < 2 ){ $frame=$CNT_RecvFrame; }
    my ($val,$field);
    $val='';
    $field=GetFieldName($pktName,$fieldName);
    if($frame ne '' && $field ne ''){
	$val = $$frame{$field},
    }
    print "######### Packe Name($pktName) Field Value($fieldName) is NULL\n" if($val eq '');
    return($val);
}

#$ The field value of a transmitting packet is acquired
sub GetSND {
    my ($pktName,$fieldName,$frame) = @_;
    if( $#_ < 2 ){ $frame=$CNT_SendFrame; }
    my ($val,$field);
    $val='';
    $field=GetFieldName($pktName,$fieldName);
    if($frame ne '' && $field ne ''){
	$val = $$frame{$field},
    }
    print "######### Packe Name($pktName) Field Value($fieldName) is NULL\n" if($val eq '');
    return($val);
}

#$ The field value of a packet is acquired
sub GetFieldName {
    my ($pktName,$fieldName) = @_;
    my $base='';
    if($pktName eq 'IPv6'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_IPv6';
    }
    if($pktName eq 'EchoRequest'){
	$base = 'Frame_Ether.Packet_IPv6.ICMPv6_EchoRequest';
    }
    if($pktName eq 'EchoReply'){
	if( $CNT_IPSec_mode eq 'ON' ){
	  $base = 'Frame_Ether.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.ICMPv6_EchoReply';
	}else{
	  $base = 'Frame_Ether.Packet_IPv6.ICMPv6_EchoReply';
        }
    }
    if($pktName eq 'RA'){
	$base = 'Frame_Ether.Packet_IPv6.ICMPv6_RA';
    }
    if($pktName eq 'NS'){
	$base = 'Frame_Ether.Packet_IPv6.ICMPv6_NS';
    }
    if($pktName eq 'NA'){
	$base = 'Frame_Ether.Packet_IPv6.ICMPv6_NA';
    }
    if($pktName eq 'ICMPErr'){
	$base = 'Frame_Ether.Packet_IPv6.ICMPv6_ParameterProblem';
    }
    if($pktName eq 'DH'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_Destination';
    }
    if($pktName eq 'DHhoa'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_Destination.Opt_HomeAddress';
    }
    if($pktName eq 'RH'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_Routing';
    }
    if($pktName eq 'HoTI'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_HoTI';
    }
    if($pktName eq 'HoT'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_HoT';
    }
    if($pktName eq 'CoTI'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_CoTI';
    }
    if($pktName eq 'CoT'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_CoT';
    }
    if($pktName eq 'BU'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_BU';
    }
    if($pktName eq 'BUauth'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_BU.Opt_MH_BindingAuthData';
    }
    if($pktName eq 'BUnonce'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_BU.Opt_MH_NonceIndices';
    }
    if($pktName eq 'BA'){
	if( $CNT_IPSec_mode eq 'ON' ){
	    $base = 'Frame_Ether.Packet_IPv6.Hdr_ESP.Decrypted.ESPPayload.Hdr_MH_BA';
	}else{
	    $base = 'Frame_Ether.Packet_IPv6.Hdr_MH_BA';
	}
    }
    if($pktName eq 'BAauth'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_BA.Opt_MH_BindingAuthData';
    }
    if($pktName eq 'BApad'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_BA.Opt_MH_PadN';
    }
    if($pktName eq 'BE'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_BE';
    }
    if($pktName eq 'BRR'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_BRR';
    }
    if($pktName eq 'MH'){
	$base = 'Frame_Ether.Packet_IPv6.Hdr_MH_ANY';
    }
    if( $CNT_IPSec_mode eq 'ON' ){
	if($pktName eq 'ESP'){
	    $base = 'Frame_Ether.Packet_IPv6.Hdr_ESP';
	}
    }
    if($base eq ''){
	print "!!!!! Error Packet Name[$pktName]\n";
    }
    return("$base.$fieldName");
}

# In the packet (default) which received, it investigates "Exists the option specified by Argument"
sub IsExistOpt {
    my ($optName,$frame) = @_;
    if( $#_ < 1 ){ $frame=$CNT_RecvFrame; }
    if($optName eq 'Auth'){
	return (GetREV('BAauth','Type',$frame) eq 5);
    }
    if($optName eq 'RH'){
	return (GetREV('IPv6','NextHeader',$frame) eq 43 && GetREV('RH','RoutingType',$frame) eq 2);
	
    }
    return '';
}

#$ Investigates "the packet (default) which received is in agreement with the packet specified by Argument."
sub IsMatchPacket {
    my ($frameName,$frame) = @_;
    if( $#_ < 1 ){ $frame=$CNT_RecvFrame; }

    if($frameName eq 'BAwithRH'){
	if (IsExistOpt('RH',$frame) && GetREV('RH','NextHeader',$frame) eq 135 &&
	    GetREV('BA','Type',$frame) eq 6){
	    return $frame;
	}
    }
    if($frameName eq 'BAnonRH'){
	if ( GetREV('IPv6','NextHeader',$frame) eq 135 && GetREV('BA','Type',$frame) eq 6){
	    return $frame;
	}
    }
    if($frameName eq 'BA'){
	#print "IsExistOpt=" , IsExistOpt(RH,$frame), "\n";
	#print "RH,NextHeader=" , GetREV(RH,NextHeader,$frame), "\n";
	#print "IPv6,NextHeader=" , GetREV(IPv6,NextHeader,$frame), "\n";
	#print "MH,Type=" , GetREV(BA,Type,$frame), "\n";
	if (((IsExistOpt('RH',$frame) && GetREV('RH','NextHeader',$frame) eq 135) ||
	     (GetREV('IPv6','NextHeader',$frame) eq 135)) && GetREV('BA','Type',$frame) eq 6 ){
	    return $frame;
	}
    }

    #
    # detecting MH packets
    #
    if($frameName eq 'MH'){
	if ( (GetREV('IPv6','NextHeader',$frame) eq 135) ||
	     (GetREV('RH','NextHeader',$frame) eq 135)){
	    return $frame;
	}
    }

    if($frameName eq 'HoT'){
	if ( GetREV('IPv6','NextHeader',$frame) eq 135 && GetREV('HoT','Type',$frame) eq 3){
	    return $frame;
	}
    }
    if($frameName eq 'CoT'){
	if ( GetREV('IPv6','NextHeader',$frame) eq 135 && GetREV('CoT','Type',$frame) eq 4){
	    return $frame;
	}
    }
    if($frameName eq 'BE'){
	if ( GetREV('IPv6','NextHeader',$frame) eq 135 && GetREV('BE','Type',$frame) eq 7){
	    return $frame;
	}
    }
    if($frameName eq 'BRR'){
	if (IsExistOpt('RH',$frame)){
	    if( GetREV('RH','NextHeader',$frame) eq 135 && GetREV('BRR','Type',$frame) eq 0 ){
		return $frame;
	    }
	}
	else {
	    if ( GetREV('IPv6','NextHeader',$frame) eq 135 && GetREV('BRR','Type',$frame) eq 0){
		return $frame;
	    }
	}
    }
    if($frameName eq 'EchoReply'){
	if ( (GetREV('IPv6','NextHeader',$frame) eq 58 && GetREV('EchoReply','Type',$frame) eq 129) ||
	     (GetREV('IPv6','NextHeader',$frame) eq 43 && GetREV('EchoReply','Type',$frame) eq 129) ){
	    return $frame;
	}
    }
    if($frameName eq 'ICMPErr'){
	if ( (GetREV('IPv6','NextHeader',$frame) eq 58 && GetREV('ICMPv6_ParameterProblem','Type',$frame) eq 4) ){
	    return $frame;
	}
    }
    return '';
}


#$ Initialization
#$  Argument
#$    Interface
sub CNT_Initilize {
    my ($remote,$link) = @_;
    my $ret;
    if( $#_ < 1 ){ $link=$CNT_Link; }
    else {$CNT_Link=$link;}
            
    if( $V6evalTool::NutDef{'Type'} eq 'host' ){
        vLogHTML('This test is for the host');
        print "# Type=host.\n";
        if( $V6evalTool::NutDef{'System'} eq 'manual' ){
            print "# System=manual.\n";
            if( $CN_CONF{'CN_ADDR_CONF'} eq 'AUTO' ){
                print "# CN address=AUTO.\n";
            }elsif( $CN_CONF{'CN_ADDR_CONF'} ne 'AUTO' ){
                print "# CN address !=AUTO(CN_ADDR_CONF=3ffe:501:ffff:100::50).\n";
                print "# Set your IP address is 3ffe:501:ffff:100::50.\n";
            }
        }elsif( $V6evalTool::NutDef{'System'} ne 'manual' ){
            print "# System=kame-freebsd.\n";
            if( $CN_CONF{'CN_ADDR_CONF'} eq 'AUTO' ){
                print "# CN address=AUTO.\n";
            }elsif( $CN_CONF{'CN_ADDR_CONF'} ne 'AUTO' ){
                print "# CN address !=AUTO(CN_ADDR_CONF=3ffe:501:ffff:100::50).\n";
                print "# Set your IP address is 3ffe:501:ffff:100::50.\n";
            }
	}
    }elsif( $V6evalTool::NutDef{'Type'} ne 'host' ){
        vLogHTML('This test is except for the host');
        print "# Type=router.\n";
        if( $V6evalTool::NutDef{'System'} eq 'manual' ){
	    print "# System=manual.\n";
	    if( $CN_CONF{'CN_ADDR_CONF'} eq 'AUTO' ){
		print "# CN address=AUTO.\n";
		print "# Set your IP address is 3ffe:501:ffff:100::<Nut Def.Link0_addr>.\n";
		print "# Set your IP address is 3ffe:501:ffff:200::<Nut Def.Link0_addr> for CN-2-4-2.\n";
        	print "# Set your default gateway to 3ffe:501:ffff:100::1.\n";
	    }elsif( $CN_CONF{'CN_ADDR_CONF'} ne 'AUTO' ){
		print "# CN address !=AUTO(CN_ADDR_CONF=3ffe:501:ffff:100::50).\n";
		print "# Set your IP address is 3ffe:501:ffff:100::50.\n";
		print "# Set your IP address is 3ffe:501:ffff:200::50 for CN-2-4-2.\n";
		print "# Set your default gateway to 3ffe:501:ffff:100::1.\n";
	    }
        }elsif( $V6evalTool::NutDef{'System'} ne 'manual' ){
	    if( $CN_CONF{'CN_ADDR_CONF'} eq 'AUTO' ){
		print "# CN address=AUTO.\n";
		print "# Set your IP address is 3ffe:501:ffff:100::<Nut Def.Link0_addr>.\n";
		print "# Set your IP address is 3ffe:501:ffff:200::<Nut Def.Link0_addr> for CN-2-4-2.\n";
		print "# When System is kame-freebsd, default gateway can setup with a remote command.\n";
	    }elsif( $CN_CONF{'CN_ADDR_CONF'} ne 'AUTO' ){
		print "# CN address !=AUTO(CN_ADDR_CONF=3ffe:501:ffff:100::50).\n";
		print "# Set your IP address is 3ffe:501:ffff:100::50.\n";
		print "# Set your IP address is 3ffe:501:ffff:200::50 for CN-2-4-2.\n";
                print "# When System is kame-freebsd, default gateway can setup with a remote command.\n";
            }
	    print "# System=kame-freebsd.\n";
        }
    }

    if( $CN_CONF{'INITIALIZE'} eq 'BOOT' && $V6evalTool::NutDef{'System'} eq 'manual' ){
	print "# Clear BCE and all IPSec configuration.\n";
	print "# If NUT configuration is done, press enter key.\n";
	<STDIN>;
    }elsif($CN_CONF{'INITIALIZE'} eq 'BOOT' && $V6evalTool::NutDef{'System'} ne 'manual' ){
	if(vRemote('reboot.rmt', '')) {
	    vLogHTML('<FONT COLOR="#FF0000">reboot.rmt: Can\'t reboot</FONT><BR>');
	    exit($V6evalTool::exitFatal);
	}
	
	if(vRemote('mip6EnableCN.rmt', '')) {
	    vLogHTML('<FONT COLOR="#FF0000">mip6EnableCN.rmt: Can\'t enable CN function</FONT><BR>');
	    exit($V6evalTool::exitFatal);
	}

	if( $CNT_IPSec_mode eq 'ON' ){
	    if(vRemote('ipsecEnable.rmt', '')) {
		vLogHTML('<FONT COLOR="#FF0000">ipsecEnable.rmt: Can\'t enable IPsec function</FONT><BR>');
		exit($V6evalTool::exitInitFail);
	    }
	    if(vRemote('ipsecClearAll.rmt', '')) {
		vLogHTML('<FONT COLOR="#FF0000">ipsecClearAll.rmt: Can\'t clear IPsec configuration</FONT><BR>');
		exit($V6evalTool::exitInitFail);
	    }
	}
    }
    if( $V6evalTool::NutDef{'Type'} ne 'host' && $V6evalTool::NutDef{'System'} ne 'manual' ){
            $ret = vRemote('route.rmt', 'cmd=add', 'prefix=default',
                           "gateway=fe80::1", "if=$V6evalTool::NutDef{'Link0_device'}");
            if($ret ne 0 ){
		vLogHTML('<FONT COLOR="#FF0000">route.rmt: Can\'t configure route</FONT><BR>');
		exit($V6evalTool::exitFatal);
            }
    }
    $ret = vCapture($link);
    if( $ret ne 0 ){
	LOG_Err("status=$ret");
	exit($V6evalTool::exitFatal);
    }
    CNT_Mode('INIT');
    CNT_AddressInit();
    CNT_SeqNoInit();
    foreach $i ( sort keys %CN_CONF ){
	if( $CN_CONF_DISP{$i} eq 'ON' ){ LOG_Msg( "$i\t:\t\t$CN_CONF{$i}" ); }
    }
}

sub CNT_IPSec_Initilize {
    if( $CNT_IPSec_mode eq 'ON' ){
	my ($upper) = @_;
	if( $#_ < 0 ){
	    $upper='ipv6-icmp';
	}

	# Get NUT Address and Set Parameters for IPSec
        my @hex;
	my $link_name = $CNT_Link . "_addr";
        my @str=split(/:/,$V6evalTool::NutDef{$link_name});
        foreach(@str) {
	    push @hex,hex($_);
        };
        @hex[0] ^= 0x02;
        my $cn_addr = sprintf( "%s:%02x%02x:%02xff:fe%02x:%02x%02x",$CNT_NUT_Prefix,@hex );
	my $mobile_node_hoa     = GetHomeAddress();
	my $transport_protocol	= 'esp';
	my $transport_algorithm = '3des-cbc';
	my $transport_aalgorithm = 'hmac-sha1';
	my $transport_secret	= "$CN_CONF{'IPSEC_EKEY'}";
	my $transport_asecret	= "$CN_CONF{'IPSEC_AKEY'}";
	my $spi_base            = $CNT_SPI_BASE;
	my $transport_spi_mnhoa_to_cn = $spi_base +1;
	my $transport_spi_cn_to_mnhoa = $spi_base +2;
	if( $CN_CONF{'CN_ADDR_CONF'} ne 'AUTO' ){
	    $cn_addr = $CN_CONF{'CN_ADDR_CONF'};
	}
	if( $CN_CONF{'IPSEC_EALGO'} eq 'DES-CBC' ){
	    $transport_algorithm	= 'des-cbc';
	}
	if( $CN_CONF{'IPSEC_AALGO'} eq 'HMAC-MD5' ){
	    $transport_aalgorithm	= 'hmac-md5';
	}

	if( $V6evalTool::NutDef{'System'} eq 'manual' ){
	    print "\n# Configure SAD and SPD as followings:\n";

	    my %letter_trans;
	    $letter_trans{'135'}="Mobility Header";
	    $letter_trans{'ipv6-icmp'}="ICMP             ";

	#----------------------------------#
	# SAD: MN_HoA -> CN transport mode #
	#----------------------------------#

	    printf( "\tspi = 0x%08x\n", $transport_spi_mnhoa_to_cn );
	    print "\tsrc(MN HoA) = $mobile_node_hoa";
	    print "\tdst(CN) = $cn_addr\n";
	    print "\tprotocol = $letter_trans{$upper}";
	    print "\tmode = ESP transport\n";
	    print "\talgorithm = $transport_algorithm";
	    print "\t\tkey = $transport_secret\n";
	    print "\tauth_algorithm = $transport_aalgorithm";
	    print "\tauth_key = $transport_asecret\n";

	#----------------------------------#
	# SAD: CN -> MN_HoA transport mode #
	#----------------------------------#
	    print "\n";
	    printf( "\tspi = 0x%08x\n", $transport_spi_cn_to_mnhoa );
	    print "\tsrc(CN) = $cn_addr";
	    print "\tdst(MN HoA) = $mobile_node_hoa\n";
	    print "\tprotocol = $letter_trans{$upper}";
	    print "\tmode = ESP transport\n";
	    print "\talgorithm = $transport_algorithm";
	    print "\t\tkey = $transport_secret\n";
	    print "\tauth_algorithm = $transport_aalgorithm";
	    print "\tauth_key = $transport_asecret\n";

	    print "# If NUT configuration is done, press enter key.\n";
	    <STDIN>;
	    return(0);

        }

	if(vRemote('ipsecClearAll.rmt', '')) {
	    vLogHTML('<FONT COLOR="#FF0000">ipsecClearAll.rmt: Can\'t clear IPsec configuration</FONT><BR>');
	    exit($V6evalTool::exitInitFail);
	}

	#----------------------------------#
	# SAD: MN_HoA -> CN transport mode #
	#----------------------------------#
	if(vRemote(
		'ipsecSetSAD.rmt',
		"src=$mobile_node_hoa",
		"dst=$cn_addr",
		"protocol=$transport_protocol",
		"spi=$transport_spi_mnhoa_to_cn",
		'mode=transport',
		"ealgo=$transport_algorithm",
		"ealgokey=$transport_secret",
		"eauth=$transport_aalgorithm",
		"eauthkey=$transport_asecret",
		"unique=$transport_spi_mnhoa_to_cn",
		'nodump'
	)) {
		vLogHTML('<FONT COLOR="#FF0000">ipsecSetSAD.rmt: Can\'t configure SA</FONT><BR>');
		exit($V6evalTool::exitInitFail);
	}

	#----------------------------------#
	# SAD: CN -> MN_HoA transport mode #
	#----------------------------------#
	if(vRemote(
		'ipsecSetSAD.rmt',
		"src=$cn_addr",
		"dst=$mobile_node_hoa",
		"protocol=$transport_protocol",
		"spi=$transport_spi_cn_to_mnhoa",
		'mode=transport',
		"ealgo=$transport_algorithm",
		"ealgokey=$transport_secret",
		"eauth=$transport_aalgorithm",
		"eauthkey=$transport_asecret",
		"unique=$transport_spi_cn_to_mnhoa",
		'nodump'
	)) {
		vLogHTML('<FONT COLOR="#FF0000">ipsecSetSAD.rmt: Can\'t configure SA</FONT><BR>');
		exit($V6evalTool::exitInitFail);
	}

	#----------------------------------#
	# SPD: MN_HoA -> CN transport mode #
	#----------------------------------#
	if(vRemote(
		'ipsecSetSPD.rmt',
		"src=$mobile_node_hoa",
		"dst=$cn_addr",
		"upperspec=$upper",
		'direction=in',
		'policy=ipsec',
		"protocol=$transport_protocol",
		'mode=transport',
		'level=unique',
		"unique=$transport_spi_mnhoa_to_cn",
		'ommit',
		'nodump'
	)) {
		vLogHTML('<FONT COLOR="#FF0000">ipsecSetSPD.rmt: Can\'t configure SPD</FONT><BR>');
		exit($V6evalTool::exitInitFail);
	}

	#----------------------------------#
	# SPD: CN -> MN_HoA transport mode #
	#----------------------------------#
	if(vRemote(
		'ipsecSetSPD.rmt',
		"src=$cn_addr",
		"dst=$mobile_node_hoa",
		"upperspec=$upper",
		'direction=out',
		'policy=ipsec',
		"protocol=$transport_protocol",
		'mode=transport',
		'level=unique',
		"unique=$transport_spi_cn_to_mnhoa",
		'ommit',
		'nodump'
	)) {
		vLogHTML('<FONT COLOR="#FF0000">ipsecSetSPD.rmt: Can\'t configure SPD</FONT><BR>');
		exit($V6evalTool::exitInitFail);
	}
	return(0);
    }
    return(0);
}

sub CNT_TEST_Start {
    vLogHTML('<font color=red size="5"><u><b>TEST PROCEDURE</b></u></font><br>');
#    vLogHTML('</td></tr><tr><td><br></td><td><font color=red size="5"><u><b>TEST PROCEDURE</b></u></font>');
    $CNT_Mode='MD_TEST';
}

#$ Change in execution mode
sub CNT_Mode {
    my ($mode) = @_;
    if($mode eq 'INIT'){
	$CNT_Mode = 'MD_INIT';
	vLogHTML('<font color=red size="5"><u><b>INITIALIZATION</b></u></font><br>');
    }
    if($mode eq 'TEST'){
	$CNT_Mode = 'MD_TEST';
	vLogHTML('<font color=red size="5"><u><b>TEST PROCEDURE</b></u></font><br>');
    }
}

sub CNT_OK () {
    $CNT_Mode = 'MD_INIT';
    exit $V6evalTool::exitPass;
}

sub CNT_NG () {
    $CNT_Mode = 'MD_INIT';
    exit $V6evalTool::exitFail;
}

#$ Judgment of status
#$ In the case of initialization mode, if status is not OK, it will end in an error (exitFail).
sub CheckStatus ($) {
    my ($status) = @_;
    if($status ne 'OK' && $CNT_Mode eq 'MD_INIT' ){
	LOG_Err("NG $status");
	$CNT_Mode = 'MD_INIT';
	exit $V6evalTool::exitInitFail;
    }
}

#$ Initialization of a sequence number
sub CNT_SeqNoInit {
    if(-e $CNT_SQNO_FILE){
	open(IN,$CNT_SQNO_FILE);
	$CNT_SeqNo = <IN>;
	close(IN);
	$CNT_SeqNo = $CNT_SeqNo % 65536;
    }
    else {
	$CNT_SeqNo=0;
    }
}
#$ Renewal of a sequence number
sub CNT_SeqNoInc {
    $CNT_SeqNo = ($CNT_SeqNo+1) % 65536;
    open(OUT, "> " . $CNT_SQNO_FILE);
    print OUT "$CNT_SeqNo\n";
    close(OUT);
    if( $CNT_IPSec_mode eq 'ON'){
	$CNT_SN_ESP ++;
    }
}

#$ The initial value of Interface ID
sub CNT_AddressInit {
    my $id;
    if(-e $CNT_NODEID_FILE){
	open(IN,$CNT_NODEID_FILE);
	$id = <IN>;
	close(IN);
	$id = $id % 65536;
	$id = 1 if($id<=0);
    }
    else {
	$id=1;
    }
    $CNT_HOME_NodeID=$id;
    $CNT_COA_NodeID=$id;
    CNT_AddressInc();
    LOG_Msg( sprintf("HomeAddr=%s::%s  CareOfAddr=%s::%s\n",$CNT_HOME_Prefix,$CNT_HOME_NodeID,$CNT_COA_Prefix,$CNT_COA_NodeID) );
}

#$ Prefix of a Home address and Interface ID is set up
sub SetHomeAddress {
    my ($prefix,$nodeID) = @_;
    my $before = $CNT_HOME_Prefix;
    $CNT_HOME_Prefix = $prefix if($prefix);
    if($nodeID){
	CNT_AddressUpdate($nodeID);
	$CNT_HOME_NodeID = $nodeID;
    }
    SetAddress();
    return $before;
}
sub GetHomeAddress {
    my ($prefix,$nodeID) = @_;
    if( 1<= $#_ ){ $$nodeID=$CNT_HOME_NodeID; }
    if( 0<= $#_ ){ $$prefix=$CNT_HOME_Prefix; }
    return sprintf("%s::%s",$CNT_HOME_Prefix,$CNT_HOME_NodeID);
}

#$ Prefix of a Care-of address and InterfaceID is set up
sub SetCoAAddress {
    my ($prefix,$nodeID) = @_;
    my $before = $CNT_COA_Prefix;
    $CNT_COA_Prefix = $prefix if($prefix);
    if($nodeID){
	CNT_AddressUpdate($nodeID);
	$CNT_COA_NodeID = $nodeID;
    }

    SetAddress();
    return $before;
}
sub GetCoAAddress {
    my ($prefix,$nodeID) = @_;
    if( 1<= $#_ ){ $$nodeID=$CNT_COA_NodeID; }
    if( 0<= $#_ ){ $$prefix=$CNT_COA_Prefix; }
    return sprintf("%s::%s",$CNT_COA_Prefix,$CNT_COA_NodeID);
}


#$ A Home address and a CoA address consist of prefix and Interface ID
sub SetAddress {
    $CNT_HOME_NodeID = ($CNT_HOME_NodeID) % 65536;
    $CNT_HOME_NodeID = 2 if($CNT_HOME_NodeID<=1);
    $CNT_COA_NodeID  = ($CNT_COA_NodeID) % 65536;
    $CNT_COA_NodeID  = 2 if($CNT_COA_NodeID<=1);
    $CNT_HomeAddr=sprintf('v6\\\\\(\\\\\"%s::%s\\\\\"\\\\\)',$CNT_HOME_Prefix,$CNT_HOME_NodeID);
    $CNT_CoAAddr=sprintf('v6\\\\\(\\\\\"%s::%s\\\\\"\\\\\)',$CNT_COA_Prefix,$CNT_COA_NodeID);
}

#$ A Home address and a CoA address are updated
sub CNT_AddressInc {
    $CNT_HOME_NodeID++;
    $CNT_COA_NodeID++;

    SetAddress();

    open(OUT, "> " . $CNT_NODEID_FILE);
    if($CNT_HOME_NodeID<$CNT_COA_NodeID){
	print OUT "$CNT_COA_NodeID\n";
    }
    else{
	print OUT "$CNT_HOME_NodeID\n";
    }
    close(OUT);
}

sub CNT_AddressUpdate {
    my ($nodeID) = @_;

    if($CNT_HOME_NodeID<$nodeID || $CNT_COA_NodeID<$nodeID){
	$nodeID = ($nodeID) % 65536;
	open(OUT, "> " . $CNT_NODEID_FILE);
	print OUT "$nodeID\n";
	close(OUT);
    }
}

## Store the UnKnown Packets in INITIALIZATION mode
## 
sub ReplaceUnKnownAndStoreInitFail {
    my ($frameName,$unknown) = @_;
    my $ret = ReplaceUnKnownToRecvFrame($frameName,$unknown);
    my $fail_id;
    if( $ret eq 'Replace' ){
	LOG_Err( $frameName . " : NG $ret");
	push ( @CNT_InitFail, "$frameName : ".GetUnKnownInfoMsg() );
    }
    return($ret);
}

## Check the UnKnown Packets in INITIALIZATION mode
## If exist, print warning message and return 'Warn'. If not, return 'OK'.
sub CNT_InitCheck {
    my ($ret) = 'OK';
    if( $#CNT_InitFail != -1 ){
	foreach( @CNT_InitFail ){
	    LOG_Err( "In INITIALIZATION : $_" );
	}
	$ret = 'Warn';
        return ( $ret );
    }
    return ( $ret );
}


#$ RA Transmit
#$   Argument  Transmitting frame, The format for parameter change, Interface
sub SD_RA {
    my ($sendFrame,$sendModf,$link) = @_;
    if( $#_ < 2 ){ $link=$CNT_Link; }
    if( $#_ < 0 ){ $sendFrame='Ra_R0_AllNd'; }

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= '';
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= '';
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission
    $ret = CNT_Send(\@frames,$link);

    CheckStatus($ret);

    #$ DAD timeout
    CNT_Wait(3);

    return($ret);
}


#$ NS transmission, NA reception
#$   Argument  Transmitting frame, Transmitting parameter, Receiving frame, Receiving parameter, Timeout, Autonomous frame list, Interface
sub SQ_NS {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
#    if( $#_ < 2 ){ $recvFrame=['Na_Cn_R0sllGlobal','Na_Cn_R0sllGlobal_opt']; }
    if( $#_ < 2 ){ $recvFrame='Na_Cn_R0sllGlobal_opt'; }
    if( $#_ < 0 ){ $sendFrame='Ns_R0_AllNd'; }

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);

    CheckStatus($ret);
    return($ret);
}

#$ Echo request Transmission,  Echo reply Reception
#$   Argument  Transmitting frame, Transmitting parameter, Receiving frame, Receiving parameter, Timeout, Autonomous frame list, Interface
sub SQ_Echo {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ $recvFrame='EchoReply_Home'; }
    if( $#_ < 0 ){ $sendFrame='EchoRequest_Home'; }

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);

#    CheckStatus($ret);
    if($ret eq 'UnKnown' && $CNT_Mode eq 'MD_INIT' ){
	$ret = ReplaceUnKnownAndStoreInitFail('EchoReply',\@unknown);
    }

    if($ret eq 'UnKnown'){
	$ret = ReplaceUnKnownToRecvFrame('EchoReply',\@unknown);
    }

    return($ret);
}

#$ Echo request Transmission,  Echo reply Reception
#$   Argument  Transmitting frame, Transmitting parameter, Receiving frame, Receiving parameter, Timeout, Autonomous frame list, Interface
sub SQ_Echo_RH {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ if($CNT_Mode eq 'MD_INIT'){$recvFrame='EchoReplyRh_Forein';}
		   else{$recvFrame='EchoReplyRhAny_Forein';} }
    if( $#_ < 0 ){ $sendFrame='EchoRequest_Home'; }

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);

#    CheckStatus($ret);
    if($ret eq 'UnKnown' && $CNT_Mode eq 'MD_INIT' ){
	$ret = ReplaceUnKnownAndStoreInitFail('EchoReply',\@unknown);
    }

    if($ret eq 'UnKnown'){
	$ret = ReplaceUnKnownToRecvFrame('EchoReply',\@unknown);
    }
    return($ret);
}

#$ Echo request Transmission,  Echo reply Reception
#$   Argument  Transmitting frame, Transmitting parameter, Receiving frame, Receiving parameter, Timeout, Autonomous frame list, Interface
sub SQ_EchoHoa {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ if($CNT_Mode eq 'MD_INIT'){$recvFrame='EchoReplyRh_Forein';}
		   else{$recvFrame='EchoReplyRhAny_Forein';} }
    if( $#_ < 0 ){ $sendFrame='EchoRequestHoa_Forein'; }

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);

#    CheckStatus($ret);
    if($ret eq 'UnKnown' && $CNT_Mode eq 'MD_INIT' ){
	$ret = ReplaceUnKnownAndStoreInitFail('EchoReply',\@unknown);
    }

    if($ret eq 'UnKnown'){
	$ret = ReplaceUnKnownToRecvFrame('EchoReply',\@unknown);
    }
    return($ret);
}
#$ Echo request Transmission,  BE Reception
#$   Argument  Transmitting frame, Transmitting parameter, Receiving frame, Receiving parameter, Timeout, Autonomous frame list, Interface
sub SQ_EchoHoa_BE {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ if($CNT_Mode eq 'MD_INIT'){$recvFrame='BeNoBinding';}else{$recvFrame='BeAny';} }
    if( $#_ < 0 ){ $sendFrame='EchoRequestHoa_Forein'; }

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);

#    CheckStatus($ret);
    if($ret eq 'UnKnown' && $CNT_Mode eq 'MD_INIT' ){
	$ret = ReplaceUnKnownAndStoreInitFail('BE',\@unknown);
    }

    if($ret eq 'UnKnown'){
	$ret = ReplaceUnKnownToRecvFrame('BE',\@unknown);
    }
    return($ret);
}

sub SQ_WaitMatchFrame {
    my ($matchFrameType,$sendCount,$waitTime,
	$sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 9 ){ $link=$CNT_Link; }
    if( $#_ < 8 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 7 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ $waitTime=4; }
    if( $#_ < 1 ){ $sendCount=10; }

    my($n,$ret,@frames,@unknown);
    @frames=();

    for($n=0;$n<$sendCount;$n++){
	$frames[0]{'Send'}= $sendFrame;
	$frames[0]{'Recv'}= $recvFrame;
	$frames[0]{'SendModf'}= $sendModf;
	$frames[0]{'RecvModf'}= $recvModf;
	$frames[0]{'Status'}= '';
	$frames[0]{'SendFrame'}= '';
	$frames[0]{'RecvFrame'}= '';
	#$ Frame transmission and reception
	$ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);
	#$ 
	if( IsMatchPacket($matchFrameType) ){
	    return('OK');
	}
	CNT_Wait($waitTime);
    }
    $ret='TimeOut';
    CheckStatus($ret);
    return($ret);
}

sub SQ_WaitMatchFrameRecv {
    my ($OKmatchFrameType,$NGmatchFrameType,$sendCount,$waitTime,
	$sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 10 ){ $link=$CNT_Link; }
    if( $#_ < 9 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 8 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 3 ){ $waitTime=4; }
    if( $#_ < 2 ){ $sendCount=10; }

    my($n,$ret,@frames,@unknown,$mode_org);
    @frames=();
    $mode_org=$CNT_Mode;

    for($n=0;$n<$sendCount;$n++){
	$frames[0]{'Send'}= $sendFrame;
	$frames[0]{'Recv'}= [$recvFrame,$OKmatchFrameType];
	$frames[0]{'SendModf'}= $sendModf;
	$frames[0]{'RecvModf'}= $recvModf;
	$frames[0]{'Status'}= '';
	$frames[0]{'SendFrame'}= '';
	$frames[0]{'RecvFrame'}= '';
	#$ Frame transmission and reception
	$ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link,0);
	if( $ret eq 'OK' ){
	    if( $CNT_RecvFrame->{'recvFrame'} eq $OKmatchFrameType ){
		return( $ret );
	    }
	}
	if( UnKnownMatchPacket($NGmatchFrameType) ){
	    LOG_Err("Unexpected $NGmatchFrameType");
	    CheckStatus($ret);
	    return('TimeOut');
	}
	$CNT_Mode='MD_TEST';
	$ret = RV_BA( $OKmatchFrameType, "", $waitTime, $autoResponse, $link );
	$CNT_Mode=$mode_org;
	if( $ret eq 'OK' ){
	    return( $ret );
	}elsif( $ret eq 'UnKnown' ){
	    if( UnKnownMatchPacket($OKmatchFrameType) ){
		LOG_Msg("Unexpected $OKmatchFrameType");
	    }
	}
    }
    $ret='TimeOut';
    CheckStatus($ret);
    return($ret);
}

#$ A number of EchoRequest(s) specified by sendCount are transmitted continuously. Then, the packet specified by breakFrame is Reception(ed). It will return, if it does so. 
#$ In not carrying out Reception by breakFrame, it repeats to timeout.
sub SQ_EchoHoa_Continue {
    my ($breakFrame,$breakModf,$sendCount,$timeout,
	$sendFrame,$sendModf,$recvFrame,$recvModf,$autoResponse,$link) = @_;
    if( $#_ < 8 ){ $link=$CNT_Link; }
    if( $#_ < 7 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 6 ){ if($CNT_Mode eq 'MD_INIT'){$recvFrame='EchoReplyRh_Forein';}
		   else{$recvFrame='EchoReplyRhAny_Forein';} }
    if( $#_ < 4 ){ $sendFrame='EchoRequestHoa_Forein'; }
    if( $#_ < 3 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ $sendCount=100; }

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Mode'}= '';
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';
    $frames[1]{'Send'}= '';
    $frames[1]{'Recv'}= $breakFrame;
    $frames[1]{'SendModf'}= '';
    $frames[1]{'RecvModf'}= $breakModf;
    $frames[1]{'Mode'}= 'Break';
    $frames[1]{'Status'}= '';
    $frames[1]{'SendFrame'}= '';
    $frames[1]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv_Continue(\@frames,\@unknown,$sendCount,$timeout,$autoResponse,$link);

    CheckStatus($ret);
    return($ret);
}
#$ HoTI Transmission,  HoT Reception
#$   Argument  Transmitting frame, Transmitting parameter, Receiving frame, Receiving parameter, Timeout, Autonomous frame list, Interface
sub SQ_HoTI {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    my $fr;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ $recvFrame='HoT_Home'; }
    if( $#_ < 0 ){ $sendFrame='HoTI_Home'; }

    my ($ret,$fr,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);
    if($ret eq 'OK'){
	$fr = $frames[0]{'RecvFrame'};
	$CNT_HOTIndex= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_HoT.Index"};
	$CNT_HOTToken= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_HoT.KeygenToken"};
	print "$fr,CNT_HOTIndex=>$CNT_HOTIndex,CNT_HOTToken=>$CNT_HOTToken\n";
    }

#    CheckStatus($ret);
    if($ret eq 'UnKnown' && $CNT_Mode eq 'MD_INIT' ){
	$ret = ReplaceUnKnownAndStoreInitFail('HoT',\@unknown);
	if( $ret eq 'Replace' ){ 
	    $fr = $frames[0]{'RecvFrame'};
	    $CNT_HOTIndex= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_HoT.Index"};
	    $CNT_HOTToken= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_HoT.KeygenToken"};
	    print "$fr,CNT_HOTIndex=>$CNT_HOTIndex,CNT_HOTToken=>$CNT_HOTToken\n";
	}
    }

    #$ In the case of test mode, the packet which was alike with HoT in the unknown frame which performed Reception is searched
    if($ret eq 'UnKnown'){
#	Dump_UnKnownInfo(\@unknown);
	$ret = ReplaceUnKnownToRecvFrame('HoT',\@unknown);
    }
    return($ret);
}


#$ CoTI Transmission,  CoT Reception
#$   Argument  Transmitting frame, Transmitting parameter, Receiving frame, Receiving parameter, Timeout, Autonomous frame list, Interface
sub SQ_CoTI {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    my $fr;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ $recvFrame='CoT_Forein'; }
    if( $#_ < 0 ){ $sendFrame='CoTI_Forein'; }

    my ($ret,$fr,@unknown,@frames);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);
    if($ret eq 'OK'){
	$fr = $frames[0]{'RecvFrame'};
	$CNT_COTIndex= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_CoT.Index"};
	$CNT_COTToken= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_CoT.KeygenToken"};
	print "$fr,CNT_COTIndex=>$CNT_COTIndex,CNT_COTToken=>$CNT_COTToken\n";
    }

#    CheckStatus($ret);
    if($ret eq 'UnKnown' && $CNT_Mode eq 'MD_INIT' ){
	$ret = ReplaceUnKnownAndStoreInitFail('CoT',\@unknown);
	if( $ret eq 'Replace' ){ 
	    $fr = $frames[0]{'RecvFrame'};
	    $CNT_COTIndex= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_CoT.Index"};
	    $CNT_COTToken= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_CoT.KeygenToken"};
	    print "$fr,CNT_COTIndex=>$CNT_COTIndex,CNT_COTToken=>$CNT_COTToken\n";
	}
    }

    #$ In the case of test mode, the packet which was alike with CoT in the unknown frame which performed Reception is searched
    if($ret eq 'UnKnown'){
#	Dump_UnKnownInfo(\@unknown);
	$ret = ReplaceUnKnownToRecvFrame('CoT',\@unknown);
    }
    return($ret);
}

#$ CoTI,HoTI Transmission,  CoT,HoT Reception
#$   Argument  HoTI Transmitting frame, HoTI format for parameter change, HoT Receiving frame, 
#$        CoTITransmitting frame, CoTI format for parameter change, CoTReceiving frame, Timeout, Autonomous frame list, Interface
sub SQ_RR {
    my ($hotiFrame,$hotiModf,$hotFrame,$hotModf,$cotiFrame,$cotiModf,$cotFrame,$cotModf,
	$timeout,$autoResponse,$link) = @_;
    if( $#_ < 10 ){ $link=$CNT_Link; }
    if( $#_ < 9 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 8 ){ $timeout=$CNT_RRTimeOut; }
    if( $#_ < 6 ){ $cotFrame ='CoT_Forein'; }
    if( $#_ < 4 ){ $cotiFrame='CoTI_Forein'; }
    if( $#_ < 2 ){ $hotFrame ='HoT_Home'; }
    if( $#_ < 0 ){ $hotiFrame='HoTI_Home'; }

    my ($ret,$fr,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $hotiFrame;
    $frames[0]{'Recv'}= $hotFrame;
    $frames[0]{'SendModf'}= $hotiModf;
    $frames[0]{'RecvModf'}= $hotModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';
    $frames[1]{'Send'}= $cotiFrame;
    $frames[1]{'Recv'}= $cotFrame;
    $frames[1]{'SendModf'}= $cotiModf;
    $frames[1]{'RecvModf'}= $cotModf;
    $frames[1]{'Status'}= '';
    $frames[1]{'SendFrame'}= '';
    $frames[1]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);
    if($ret eq 'OK'){
	$fr = $frames[0]{'RecvFrame'};
	$CNT_HOTIndex= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_HoT.Index"};
	$CNT_HOTToken= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_HoT.KeygenToken"};
	print "$fr,CNT_HOTIndex=>$CNT_HOTIndex,CNT_HOTToken=>$CNT_HOTToken\n";
	$fr = $frames[1]{'RecvFrame'};
	$CNT_COTIndex= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_CoT.Index"};
	$CNT_COTToken= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_CoT.KeygenToken"};
	print "$fr,CNT_COTIndex=>$CNT_COTIndex,CNT_COTToken=>$CNT_COTToken\n";
    }

    CheckStatus($ret);
    return($ret);
}

#$ Registration from the Forein Link
#$ BU Transmission,  BA Reception
#$   Argument  Transmitting frame, Transmitting parameter, Receiving frame, Receiving parameter, Timeout, Autonomous frame list, Interface
sub SQ_BU {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    my $fr;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ if($CNT_Mode eq 'MD_INIT'){$recvFrame='BaRegRh_Forein';}else{$recvFrame='BaRegRhAny_Forein';} }
    if( $#_ < 0 ){ $sendFrame='BuRegHoa_Forein'; }

    $sendModf = $CNT_RR_REG_INDEX . $sendModf;
    $recvModf = $CNT_RR_REG_INDEX . $recvModf;

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);

    #$ Renewal of a sequence number
    if($ret eq 'OK'){
	CNT_SeqNoInc();
    }

#    CheckStatus($ret);
    if($ret eq 'UnKnown' && $CNT_Mode eq 'MD_INIT' ){
	$ret = ReplaceUnKnownAndStoreInitFail('BA',\@unknown);
	if( $ret eq 'Replace' ){ 
	    CNT_SeqNoInc();
	}
    }

    #$ In the case of test mode, the packet which was alike with BA in the unknown frame which performed Reception is searched
    if($ret eq 'UnKnown'){
	$ret = ReplaceUnKnownToRecvFrame('BA',\@unknown);
    }
    return($ret);
}

#$ De-Registration from Forein Link
sub SQ_UnBU {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    my $fr;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ if($CNT_Mode eq 'MD_INIT'){$recvFrame='BaDeregRh_Forein';}else{$recvFrame='BaDeRegRhAny_Forein';} }
#    if( $#_ < 2 ){ $recvFrame='BaDeregRh_Forein'; }
#    if( $#_ < 0 ){ $sendFrame='BuDereg_Forein'; }
    if( $#_ < 0 ){ $sendFrame='BuDeregHoaAlt_Forein'; }

    $sendModf = $CNT_RR_DEREG_INDEX . "-DBU_LIFETIME=0 " . $sendModf;
    $recvModf = $CNT_RR_DEREG_INDEX . "-DBU_LIFETIME=0 " . $recvModf;

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);

    #$ Renewal of a sequence number
    if($ret eq 'OK'){
	CNT_SeqNoInc();
    }

#    CheckStatus($ret);
    if($ret eq 'UnKnown' && $CNT_Mode eq 'MD_INIT' ){
	$ret = ReplaceUnKnownAndStoreInitFail('BA',\@unknown);
	if( $ret eq 'Replace' ){ 
	    CNT_SeqNoInc();
	}
    }

    #$ In the case of test mode, the packet which was alike with BA in the unknown frame which performed Reception is searched
    if($ret eq 'UnKnown'){
	$ret = ReplaceUnKnownToRecvFrame('BA',\@unknown);
    }
    return($ret);
}

#$ De-Registration from Home Link
sub SQ_UnBU_Home {
    my ($sendFrame,$sendModf,$recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    my $fr;
    if( $#_ < 6 ){ $link=$CNT_Link; }
    if( $#_ < 5 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 4 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 2 ){ if($CNT_Mode eq 'MD_INIT'){$recvFrame='BaDereg_Home';}else{$recvFrame='BaDeregAny_Home';} }
    if( $#_ < 0 ){ $sendFrame='BuDereg_Home'; }

    $sendModf = $CNT_RR_DEREG_INDEX . $sendModf;
    $recvModf = $CNT_RR_DEREG_INDEX . $recvModf;

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);

    #$ Renewal of a sequence number
    if($ret eq 'OK'){
	CNT_SeqNoInc();
    }

#    CheckStatus($ret);
    if($ret eq 'UnKnown' && $CNT_Mode eq 'MD_INIT' ){
	$ret = ReplaceUnKnownAndStoreInitFail('BA',\@unknown);
	if( $ret eq 'Replace' ){ 
	    CNT_SeqNoInc();
	}
    }

    #$ In the case of test mode, the packet which was alike with BA in the unknown frame which performed Reception is searched
    if($ret eq 'UnKnown'){
	$ret = ReplaceUnKnownToRecvFrame('BA',\@unknown);
    }
    return($ret);
}

#$ HoTI Transmission
#$   Argument  Transmitting frame,  format for parameter change, Interface
sub SD_HoTI {
    my ($sendFrame,$sendModf,$link) = @_;
    if( $#_ < 2 ){ $link=$CNT_Link; }
    if( $#_ < 0 ){ $sendFrame='HoTI_Home'; }

    my ($ret,@frames);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= '';
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= '';
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame Transmission
    $ret = CNT_Send(\@frames,$link);

    CheckStatus($ret);
    return($ret);
}

#$ CoTI Transmission
#$   Argument  Transmitting frame,  format for parameter change, Interface
sub SD_CoTI {
    my ($sendFrame,$sendModf,$link) = @_;
    if( $#_ < 2 ){ $link=$CNT_Link; }
    if( $#_ < 0 ){ $sendFrame='CoTI_Forein'; }

    my ($ret,@frames);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= '';
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= '';
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame Transmission
    $ret = CNT_Send(\@frames,$link);

    CheckStatus($ret);
    return($ret);
}

#$ HoTI Transmission
#$   Argument  Transmitting frame,  format for parameter change, Interface
sub SD_BU {
    my ($sendFrame,$sendModf,$link) = @_;
    if( $#_ < 2 ){ $link=$CNT_Link; }
    if( $#_ < 0 ){ $sendFrame='BuRegHoa_Forein'; }

    $sendModf=$CNT_RR_REG_INDEX . $sendModf;
    my ($ret,@frames);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= '';
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= '';
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame Transmission
    $ret = CNT_Send(\@frames,$link);

    CheckStatus($ret);
    return($ret);
}

#$ The arbitrary ICMP packets specified by Argument are transmitted
#$   Argument  Transmitting frame, Transmitting parameter, Interface
sub SD_ICMP {
    my ($sendFrame,$sendModf,$link) = @_;
    if( $#_ < 2 ){ $link=$CNT_Link; }

    my ($ret,@frames);
    @frames=();
    $frames[0]{'Send'}= $sendFrame;
    $frames[0]{'Recv'}= '';
    $frames[0]{'SendModf'}= $sendModf;
    $frames[0]{'RecvModf'}= '';
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame Transmission
    $ret = CNT_Send(\@frames,$link);

    CheckStatus($ret);
    return($ret);
}

#$ HoT Reception
#$   Argument  Receiving frame,  format for parameter change, Timeout, Autonomous frame list, Interface
sub RV_HoT {
    my ($recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    my $fr;
    if( $#_ < 4 ){ $link=$CNT_Link; }
    if( $#_ < 3 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 2 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 0 ){ $recvFrame='HoT_Home'; }

    my ($ret,$fr,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= '';
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= '';
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);
    if($ret eq 'OK'){
	$fr = $frames[0]{'RecvFrame'};
	$CNT_HOTIndex= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_HoT.Index"};
	$CNT_HOTToken= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_HoT.KeygenToken"};
#	print "$fr,CNT_HOTIndex=>$CNT_HOTIndex,CNT_HOTToken=>$CNT_HOTToken\n";
    }

    CheckStatus($ret);
    return($ret);
}
#$ CoT Reception
#$   Argument  Receiving frame,  format for parameter change, Timeout, Autonomous frame list, Interface
sub RV_CoT {
    my ($recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    my $fr;
    if( $#_ < 4 ){ $link=$CNT_Link; }
    if( $#_ < 3 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 2 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 0 ){ $recvFrame='CoT_Forein'; }

    my ($ret,$fr,@frames,@unknown);
    my @frames=();
    $frames[0]{'Send'}= '';
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= '';
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame transmission and reception
    $ret = CNT_SendAndRecv(\@frames,\@unknown,$timeout,$autoResponse,$link);
    if($ret eq 'OK'){
	$fr = $frames[0]{'RecvFrame'};
	$CNT_COTIndex= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_CoT.Index"};
	$CNT_COTToken= $$fr{"Frame_Ether.Packet_IPv6.Hdr_MH_CoT.KeygenToken"};
#	print "$fr,CNT_COTIndex=>$CNT_COTIndex,CNT_COTToken=>$CNT_COTToken\n";
    }

    CheckStatus($ret);
    return($ret);
}

#$ BA Reception
#$   Argument  Receiving frame,  format for parameter change, Timeout, Autonomous frame list, Interface
sub RV_BA {
    my ($recvFrame,$recvModf,$timeout,$autoResponse,$link) = @_;
    if( $#_ < 4 ){ $link=$CNT_Link; }
    if( $#_ < 3 ){ $autoResponse=\%CNT_AutoResponse; }
    if( $#_ < 2 ){ $timeout=$CNT_TimeOut; }
    if( $#_ < 0 ){ $recvFrame='BaRegRhAny_Forein'; }

    $recvModf=$CNT_RR_REG_INDEX . $recvModf;

    my ($ret,@frames,@unknown);
    @frames=();
    $frames[0]{'Send'}= '';
    $frames[0]{'Recv'}= $recvFrame;
    $frames[0]{'SendModf'}= '';
    $frames[0]{'RecvModf'}= $recvModf;
    $frames[0]{'Status'}= '';
    $frames[0]{'SendFrame'}= '';
    $frames[0]{'RecvFrame'}= '';

    #$ Frame Transmission
    $ret = CNT_Recv(\@frames,\@unknown,$timeout,$autoResponse,$link);

    #$ Renewal of a sequence number
    if($ret eq 'OK'){
	CNT_SeqNoInc();
    }

    CheckStatus($ret);
    return($ret);
}

sub LOG_Err {
    my ($msg) = @_;
    vLogHTML('<font color="red">' . $msg . '</font><BR>');
}

sub LOG_Warn {
    my ($msg) = @_;
    vLogHTML('<font color="green">' . $msg . '</font><BR>');
}

sub LOG_OK {
    my ($msg) = @_;
    vLogHTML('<font color="black">' . $msg . '</font><BR>');
}

sub LOG_Msg {
    my ($msg) = @_;
    vLogHTML('<font color="cyan">' . $msg . '</font><BR>');
}

#
# 2006/11/15
# 4.0.2 check and return finale result
#       if there is unexpected packets thru the test
#       return WARN, or return PASS
#
sub IsUnExpectedPackets {

    if ( $UnExpected_thru_test ) {
	return $V6evalTool::exitWarn;
    } else {
	return $V6evalTool::exitPass;
    }
}

1;
