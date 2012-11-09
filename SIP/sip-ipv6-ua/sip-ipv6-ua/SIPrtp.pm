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


require SIP;

$SIG{INT}  = PrintfINT;
$SIG{KILL} = PrintfKILL;
$SIG{TERM} = PrintfTERM;
$SIG{QUIT} = PrintfQUIT;
$SIG{HUP}  = PrintfHUP;


sub PrintfINT { 
    # printf("\n\n===INT===\n\n\n");
    exit(1);
}
sub PrintfKILL { 
    # printf("\n\n===KILL===\n\n\n");
    exit(1);
}
sub PrintfTERM {
    # printf("\n\n===TERM===\n\n\n");
    exit(1);
}
sub PrintfQUIT {
    # printf("\n\n===QUIT===\n\n\n");
    exit(1);
}
sub PrintfHUP {
    # printf("\n\n===HUP===\n\n\n");
    exit(1);
}


#use strict;

sub RtpStart {
    my($flag)=@_;
    my($tmp_d_addr, $tmp_s_addr);
    my($d_addr, $d_port, $s_addr, $s_port);
    my($char_line_d, $char_meth_d, $char_line_s, $char_meth_s);
    my($pid);

    #printf("\n");
    #printf("========================== rtp part ===========================\n");
    #printf("flag = %d\n", $flag);


    if ($flag == 2) {
        $char_line_d = "RQ.Status-Line.code";
        $char_meth_d = "200";
        $char_line_s = "RQ.Request-Line.method";
        $char_meth_s = "INVITE";

        $tmp_d_addr = FVif('recv', '', '', 'BD.c=.val.param', $char_line_d, $char_meth_d);
        $tmp_s_addr = FVif('send', '', '', 'BD.c=.val.param', $char_line_s, $char_meth_s);

        @addr_d = split(/\s+/, $tmp_d_addr);
        @addr_s = split(/\s+/, $tmp_s_addr);

        $d_addr = $addr_d[2];
        $s_addr = $addr_s[2];

        $d_port = FVif('recv', '', '', 'BD.m=.val.media.port', $char_line_d, $char_meth_d);
        $s_port = FVif('send', '', '', 'BD.m=.val.media.port', $char_line_s, $char_meth_s);

    }else{
        if ($flag == 0) {
            $char_line_d = "RQ.Request-Line.method";
            $char_meth_d = "INVITE";
            $char_line_s = "RQ.Status-Line.code";
            $char_meth_s = "200";
        }
        if ($flag == 1) {
            $char_line_d = "RQ.Status-Line.code";
            $char_meth_d = "200";
            $char_line_s = "RQ.Request-Line.method";
            $char_meth_s = "INVITE";
        }
        if ($flag == 3) {
            $char_line_d = "RQ.Request-Line.method";
            $char_meth_d = "INVITE";
            $char_line_s = "RQ.Status-Line.code";
            $char_meth_s = "299";
        }
        if ($flag == 4) {
            $char_line_d = "RQ.Status-Line.code";
            $char_meth_d = "200";
            $char_line_s = "RQ.Request-Line.method";
            $char_meth_s = "ACK";
        }
        if ($flag == 5) {
            $char_line_d = "RQ.Request-Line.method";
            $char_meth_d = "INVITE";
            $char_line_s = "RQ.Status-Line.code";
            $char_meth_s = "180";
        }


        #printf("d_line = %s | d_meth = %s\n", $char_line_d, $char_meth_d);
        #printf("s_line = %s | s_meth = %s\n", $char_line_s, $char_meth_s);


        $tmp_d_addr = FVib('recv', '', '', 'BD.c=.val.param', $char_line_d, $char_meth_d);
        $tmp_s_addr = FVib('send', '', '', 'BD.c=.val.param', $char_line_s, $char_meth_s);

        @addr_d = split(/\s+/, $tmp_d_addr);
        @addr_s = split(/\s+/, $tmp_s_addr);

        $d_addr = $addr_d[2];
        $s_addr = $addr_s[2];


        $d_port = FVib('recv', '', '', 'BD.m=.val.media.port', $char_line_d, $char_meth_d);
        $s_port = FVib('send', '', '', 'BD.m=.val.media.port', $char_line_s, $char_meth_s);

    }


    #printf("d_addr = %s | d_port = %d\n", $d_addr, $d_port);
    #printf("s_addr = %s | s_port = %d\n", $s_addr, $s_port);

#    $cmd ="rtpsend hello8000.wav $d_addr $d_port $s_addr $s_port";
    $cmd ="rtpsend rtp.wav $d_addr $d_port $s_addr $s_port";
    printf("RTP : %s[%s] => %s[%s]\n",$s_addr,$s_port,$d_addr,$d_port);
    $ProEnd_f = 1;
    unless($pid_chd = fork){
        system($cmd);
        #printf("***** rtp finished *****\n");
        sleep(10000);
	exit(1);
    }
    #printf("******** PID_CHD = $pid_chd ********\n");
    #printf("===============================================================\n");
    return $pid_chd;
}

sub RtpStop {
    ($RtpEnd_f)=CtUtShellResult("pgrep rtpsend",'T');
    if($RtpEnd_f ne ""){
        system("killall rtpsend");
        #printf("rtp stoped\n");
    }
}


sub RtpPortOpen{

#    kPacket_StartRecv($SIP_PL_TRNS,'SIP',$SIP_PL_IP eq 6 ? 'INET6':'INET','3ffe:501:ffff:1::1',$CNT_PORT_DEFAULT_RTP,$link);
    $rtp_port_id = kPacket_StartRecv($SIP_PL_TRNS,'SIP',$SIP_PL_IP eq 6 ? 'INET6':'INET','',$CNT_PORT_DEFAULT_RTP,$link);

    return $rtp_port_id;

}

sub RtpPortOpen2{
    $rtp_port_id = kPacket_StartRecv($SIP_PL_TRNS,'SIP',$SIP_PL_IP eq 6 ? 'INET6':'INET','',$CNT_PORT_CHANGE_RTP,$link);
}


sub RtpPortClose{

    my($sockid) = @_;

    my($sec) = 1;

    kPacket_Close($sockid, $sec);

}

sub ProcessEnd {

    my($target_pid) = @_;
    $ProEnd_f = 0;

    #printf("\n *** pid = $target_pid ***\n\n");
    kill '9', $target_pid;

}

sub CtUtShellResult {
    my($command,$stderr,$timeout)=@_;
    my($result,$pipe);
    local($status);

    $timeout = $timeout || 5;
#    eval{
	local $SIG{'ALRM'}= sub {$status='TIME-OUT';die};
	alarm( $timeout );
	eval {
	    # $stderr
#	    $result = `$command`;
	    $pipe = $stderr ? ' 2>&1 |' : ' |' ;
	    unless( open(STATUS,  $command . $pipe) ){
		MsgPrint('ERR',"Can't exec [%s]\n",$command);
		return ;
	    }
	    while (<STATUS>){$result .= $_}
	    close(STATUS);
	};
	alarm(0);
#    };
    alarm(0);
    if($status || $@){
	$status = $status ? $status :(ref($@) ? 'TIME-OUT' : $@);
	$result='';

    }
    return $result,$status;
}

##############################
#  RTP rule set
##############################

@RTPcommonRules =
(

{ 'TY:' => 'SYNTAX', 'ID:' => 'S.RTP_DIST_PORT_CHECK', 'CA:' => 'RTP',
  'OK:' => \\'The distination port of RTP packet(%s) MUST be correct port(%s)',
  'NG:' => \\'The distination port of RTP packet(%s) MUST be correct port(%s)',
  'EX:' => '',
},
);

END{

    if($ProEnd_f == 1){
        # print "====== ILLEGAL END PHASE START   ======\n";

        ($RtpEnd_f)=CtUtShellResult("pgrep rtpsend",'T');
        if($RtpEnd_f ne ""){
            #printf("RtpStop pid = $RtpEnd_f\n");
            RtpStop();
        }
        if($pid_rtp ne ""){
            #printf("route A\n");
            ProcessEnd($pid_rtp);
        }else{
            #printf("route B\n");
            ProcessEnd($pid_chd);
        }
        # print "====== ILLEGAL END PHASE FINISHED =======\n";
    }else{
#       print "====== END PHASE SKIPPED ========\n";
    }

}

1;
