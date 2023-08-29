#!/usr/bin/perl
#
# Copyright (C) 2013
# Chunghwa Telecommunication Labratories (CHT-TL)
# All rights reserved.
# 
# Redistribution and use of this software in source and binary
# forms, with or without modification, are permitted provided that
# the following conditions and disclaimer are agreed and accepted
# by the user:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with
#    the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project
#    which is related to this software (hereinafter referred to as
#    "project") nor the names of the contributors may be used to
#    endorse or promote products derived from this software without
#    specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written
#    notification to the copyrighters.
# 
# 5. The copyrighters, the project and the contributors may prohibit
#    the use of this software at any time.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# $CHT-TL: CPE6_config.pm, v 1.0 2013/06/10 weifen Exp $
#
################################################################

package CPE6;

use V6evalTool;

#use CPE6_config;

################################################################
# BEGIN                                                        #
################################################################
BEGIN {
        require Exporter;
        use vars qw(@ISA @EXPORT);
        our @ISA    = qw(Exporter);
        our @EXPORT = qw(
		     ignoreDAD
		     cpe6ExitError
		     cpe6ExitFail
		     cpe6ExitPass
		     cpe6ExitWarn
		     wait_for_ra
		     ra_options_exist
		     nut_DAD
		     check_prefix

		     create_def_file
		     cpe6_ping

		     create_def_file_3
		     cpe6_ping_3

		     check_ra_routeinfo_option
		     check_ra_changed_prefix_option
		     
		     $RA_CMP_SLL
		     $RA_CMP_TLL
		     $RA_CMP_PREFIX
		     $RA_CMP_REDIRECT
		     $RA_CMP_MTU
		     $RA_CMP_ROUTEINFO

		     $wait_DAD
		    );
}

################################################################
# END                                                          #
################################################################
END {

}


sub ignoreDAD($);
sub wait_for_ra($$$);
sub cpe6ExitError($);
sub cpe6ExitFail(;$);
sub cpe6ExitPass($);
sub cpe6ExitWarn($);
sub ra_options_exist($$);
sub wait_DAD($);
sub nut_DAD($);
sub create_def_file($$$$$);
sub cpe6_ping($$$$$);
sub create_def_file_3($$$$$$$$$$);
sub cpe6_ping_3($$$$$$$$$);

sub check_prefix($$);
sub check_ra_routeinfo_option();
sub check_ra_changed_prefix_option($);

# for compare_options($$$)
$RA_CMP_SLL             = 1 << 0;
$RA_CMP_TLL             = 1 << 1;
$RA_CMP_PREFIX          = 1 << 2;
$RA_CMP_REDIRECT        = 1 << 3;
$RA_CMP_MTU             = 1 << 4;
$RA_CMP_ROUTEINFO	= 1 << 5;

my %ra_option_defs = (
    $RA_CMP_SLL           => "Opt_ICMPv6_SLL",
    $RA_CMP_TLL           => "Opt_DHCPv6_TLL",
    $RA_CMP_PREFIX        => "Opt_ICMPv6_Prefix",
    $RA_CMP_REDIRECT      => "Opt_DHCPv6_Redirected",
    $RA_CMP_MTU           => "Opt_ICMPv6_MTU",
    $RA_CMP_ROUTEINFO     => "Opt_ICMPv6_RouteInfo"
);

$wait_DAD = $wait_addrconf_base + $RetransTimerSec * ($DupAddrDetectTransmits - 1);

#-------------------------------------------------------------#
# ignoreDAD()
#-------------------------------------------------------------#
sub ignoreDAD($)
{
	my ($Link) = @_;

	vRecv($Link, $MAX_RTR_SOLICITATION_DELAY +
		$TimeOut * $DupAddrDetectTransmits,
		0, 0);

	return;
}

#--------------------------------------------------------------#
# wait_for_ra($if, $timeout,$lifetime)                         #
#							       #
# Notes:                                                       #
#    Receive RA from NUT on LAN interface                      #
#                                                              #
#    SUCCESS: return (0, ra)                                   #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub wait_for_ra($$$)
{
    my ($if, $timeout,$lifetime) = @_;
    my %retra;

    if ($lifetime) {
      %retra = vRecv($if, $timeout, 0, 0, "ra_any");
    } else {
      %retra = vRecv($if, $timeout, 0, 0, "ra_rf_zero");
    }

    if ($retra{status} == 0) {
	vLogHTML('tn received the ra from nut<BR>');
	return (0, %retra);
    } elsif ($retra{status} == 1) {
	vLogHTML('<FONT COLOR="#FF0000">TN does not receive expected RA.</FONT><BR>');
	return (1, %retra);
    } elsif ($retra{status} == 2) {
	vLogHTML('<FONT COLOR="#FF0000">TN receives RA, but the RA format is incorrect.</FONT><BR>');
	return (1, %retra);
    } else {
	vLogHTML('<FONT COLOR="#FF0000">Error</FONT><BR>');
	return (1, %retra);;
    }
}

sub cpe6ExitError($) 
{
    my ($msg) = @_;
    vLogHTML("<FONT COLOR=\"#FF0000\">NG: <B>$msg</B> </FONT><BR>");
    vRemote('reboot.rmt','');
    vLogHTML('<B>FAIL</B><BR>');
    exit $V6evalTool::exitFail;
}

sub cpe6ExitFail(;$) 
{
    my ($msg) = @_;
    if(defined($msg)) {
      $msg = ": " . $msg;
    }
    else {
      $msg = "";
    }
    vLogHTML("<FONT COLOR=\"#FF0000\">NG$msg</FONT><BR>");

		vRemote('reboot.rmt','');
    vLogHTML('<B>FAIL</B><BR>');
    exit $V6evalTool::exitFail;
}


sub cpe6ExitPass($)
{
    my ($if) = @_;
    #======================================================================
    vLogHTML("<FONT SIZE=3>*** Target test finish ***<FONT><BR>");
    #======================================================================

    vRemote('reboot.rmt','');

    vLogHTML('<B>PASS</B><BR>');
    exit $V6evalTool::exitPass;
}

sub cpe6ExitWarn($) 
{
    my ($msg) = @_;
    vLogHTML("<FONT COLOR=\"#FF0000\">NG: <B>$msg</B> </FONT><BR>");
    vRemote('reboot.rmt','');
    vLogHTML('<B>WARN</B><BR>');
    exit $V6evalTool::exitWarn;
}

sub ra_options_exist($$)
{
    my ($frame, $optnum) = @_;
    my $notfound = 0;
    my $base = "Frame_Ether.Packet_IPv6.ICMPv6_RA";

    vLogHTML("Checking RA existing option...<BR>");

    foreach(keys %ra_option_defs) {
	if (0 != ($_ & $optnum)) {
		if (! defined($$frame{"$base"."."."$ra_option_defs{$_}"})) {
			vLogHTML("<B>$ra_option_defs{$_} not found</B><BR>");
			$notfound++;
		} 
		else {
			vLogHTML("<B>$ra_option_defs{$_} found</B><BR>");
		}
	}
    }
    return 1 if (0 != $notfound);
    return 0;
}

#--------------------------------------------------------------#
# nut_DAD($if)                                                 #
#							       #
# Notes:                                                       #
#    receive DAD NS message from NUT and return NS target addr #
#                                                              #
#    SUCCESS: return (0, target_addr)                          #
#    FAILURE: return (1, ???)                                  #
#--------------------------------------------------------------#
sub nut_DAD($)
{
    my $if = $_[0];
    my $nut_addr = "";
    my %ret_ns = vRecv($if, $wait_DAD, 0, 0, 'ns_nut_to_any');
    my $base = "Frame_Ether.Packet_IPv6.ICMPv6_NS";
    if(!defined($ret_ns{$base})) {
	vLogHTML('<FONT COLOR="#FF0000">TN does not receive DAD NS.</FONT><BR>');
	return (1, $nut_addr);
    }

    #get nut global address
    $nut_addr = $ret_ns{$base . "." . "TargetAddress"};
    return (0, $nut_addr);
}


#--------------------------------------------------------------#
# create_ping_def_file($filename,                              # 
#       	       $from, $from_addr,                      #
#                      $to,   $to_addr)                        #
#							       #
# Notes:                                                       #
#    create neccessary definition packets file for ping        #
#    which include ns
#                                                              #
#    SUCCESS: return 0                                         #
#    FAILURE: return 1                                         #
#--------------------------------------------------------------#
sub create_def_file($$$$$)
{
    my ($filename, $from, $from_addr, $to, $to_addr) = @_;

    open(OUT, ">./$filename")|| return 2;

    print OUT "/* \n";
    print OUT "*** DO NOT EDIT THIS FILE ***\n";
    print OUT "*/\n";

    # _HETHER_xxxx
    print OUT "_HETHER_define(_HETHER_" . $from . "_to_" . $to . ",\n";
    print OUT "\t\t" . $from . "_MAC_ADDR, " . $to . "_MAC_ADDR)\n\n";

    print OUT "_HETHER_define(_HETHER_" . $to . "_to_" . $from . ",\n";
    print OUT "\t\t" . $to . "_MAC_ADDR, " . $from . "_MAC_ADDR)\n\n";

    # echo request
    print OUT "FEM_icmp6_echo_request (\n";
    print OUT "\tereq_". $from . "_to_" . $to . ",\n";
    print OUT "\t_HETHER_" . $from . "_to_" . $to . ",\n";
    print OUT "\t{\n";
    if ($from_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_SRC(v6($from_addr));\n";
    } else {
      print OUT "\t\t_SRC($from_addr);\n";
    }
    if ($to_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_DST(v6($to_addr));\n";
    } else {
      print OUT "\t\t_DST($to_addr);\n";
    }
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tpayload = data8;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    # echo reply
    print OUT "FEM_icmp6_echo_reply (\n";
    print OUT "\terep_". $to . "_to_" . $from . ",\n";
    print OUT "\t_HETHER_" . $to . "_to_" . $from . ",\n";
    print OUT "\t{\n";
    if ($to_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_SRC(v6($to_addr));\n";
    } else {
      print OUT "\t\t_SRC($to_addr);\n";
    }
    if ($from_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_DST(v6($from_addr));\n";
    } else {
      print OUT "\t\t_DST($from_addr);\n";
    }
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tpayload = data8;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    # ns
    print OUT "FEM_icmp6_ns(\n";
    print OUT "\tns_" . $to . "ga_to_any_" . $from . "ga,\n";
    print OUT "\t_HETHER_any,\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    if ($to_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_SRC(v6($to_addr));\n";
    } else {
      print OUT "\t\t_SRC($to_addr);\n";
    }
    print OUT "\t\t_DST(any);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    if ($from_addr =~ /LINKLOCAL/) {
      print OUT "\t\tTargetAddress = v6($from_addr);\n";
    } else {
      print OUT "\t\tTargetAddress = $from_addr;\n";
    }
    print OUT "\t\toption = any;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    print OUT "FEM_icmp6_ns(\n";
    print OUT "\tns_" . $to . "ga_to_any_" . $from . "lla,\n";
    print OUT "\t_HETHER_any,\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    if ($to_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_SRC(v6($to_addr));\n";
    } else {
      print OUT "\t\t_SRC($to_addr);\n";
    }
    print OUT "\t\t_DST(any);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
#    print OUT "\t\tTargetAddress = $from" . "_LINKLOCAL;\n";
#    print OUT "\t\tTargetAddress = v6(".$from."_LINKLOCAL);\n";
    print OUT "\t\tTargetAddress = v6(".$from."_LINKLOCAL".");\n";
    print OUT "\t\toption = any;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    print OUT "FEM_icmp6_ns(\n";
    print OUT "\tns_" . $to . "lla_to_any_" . $from . "lla,\n";
    print OUT "\t_HETHER_any,\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
#    print OUT "\t\t_SRC(NUT_LLOCAL_UCAST);\n";
    print OUT "\t\t_SRC(nutv6());\n";
    print OUT "\t\t_DST(any);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    if ($from_addr =~ /LINKLOCAL/) {
      print OUT "\t\tTargetAddress = v6($from_addr);\n";
    } else {
      print OUT "\t\tTargetAddress = $from_addr;\n";
    }
    print OUT "\t\toption = any;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    # na
    print OUT "FEM_icmp6_na(\n";
    print OUT "\tna_" . $from . "ga_to_" . $to . "ga,\n";
    print OUT "\t_HETHER_" . $from . "_to_" . $to . ",\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n";
    if ($from_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_SRC(v6($from_addr));\n";
    } else {
      print OUT "\t\t_SRC($from_addr);\n";
    }
    if ($to_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_DST(v6($to_addr));\n";
    } else {
      print OUT "\t\t_DST($to_addr);\n";
    }
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tRFlag = 1;\n";
    print OUT "\t\tSFlag = 1;\n";
    print OUT "\t\tOFlag = 1;\n";
    if ($from_addr =~ /LINKLOCAL/) {
      print OUT "\t\tTargetAddress = v6($from_addr);\n";
    } else {
      print OUT "\t\tTargetAddress = $from_addr;\n";
    }
    print OUT "\t\toption = opt_tll_" . lc($from) . ";\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    print OUT "FEM_icmp6_na(\n";
    print OUT "\tna_" . $from . "lla_to_" . $to . "ga_lla,\n";
    print OUT "\t_HETHER_" . $from . "_to_" . $to . ",\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    if ($from_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_SRC(v6($from_addr));\n";
    } else {
      print OUT "\t\t_SRC($from_addr);\n";
    }
    if ($to_addr =~ /LINKLOCAL/) {
      print OUT "\t\t_DST(v6($to_addr));\n";
    } else {
      print OUT "\t\t_DST($to_addr);\n";
    }
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tRFlag = 1;\n";
    print OUT "\t\tSFlag = 1;\n";
    print OUT "\t\tOFlag = 1;\n";
#    print OUT "\t\tTargetAddress = $from" . "_LINKLOCAL" . ";\n";
    print OUT "\t\tTargetAddress = v6(".$from."_LINKLOCAL".");\n";
    print OUT "\t\toption = opt_tll_" . lc($from) . ";\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    print OUT "FEM_icmp6_na(\n";
    print OUT "\tna_" . $from . "lla_to_" . $to . "lla,\n";
    print OUT "\t_HETHER_" . $from . "_to_" . $to . ",\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
#    print OUT "\t\t_SRC($from"."_LINKLOCAL".");\n";
    print OUT "\t\t_SRC(v6(".$from."_LINKLOCAL"."));\n";
    print OUT "\t\t_DST(nutv6());\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tRFlag = 1;\n";
    print OUT "\t\tSFlag = 1;\n";
    print OUT "\t\tOFlag = 1;\n";
    if ($from_addr =~ /LINKLOCAL/) {
      print OUT "\t\tTargetAddress = v6($from_addr);\n";
    } else {
      print OUT "\t\tTargetAddress = $from_addr;\n";
    }
    print OUT "\t\toption = opt_tll_" . lc($from) . ";\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    close(OUT);

    return 0;
}

#--------------------------------------------------------------#
# cpe6_ping(#if,                                               #
#           $from, $from_addr,                                 #
#           $to,   $to_addr)                                   #
#							       #
# Notes:                                                       #
#    ping                                                      #
#                                                              #
#    SUCCESS: return 0                                         #
#    FAILURE: return 1                                         #
#--------------------------------------------------------------#
sub cpe6_ping($$$$$)
{
    my ($if, $from, $from_addr, $to, $to_addr) = @_;
    my $filename = "CPE6_test_pkt.def";
    my $cpp = "";
    
    create_def_file($filename, $from, $from_addr, $to, $to_addr);
    vCPP($cpp);

    my $send_frame1 = "ereq_".$from."_to_".$to;
    my $send_frame2 = "na_".$from."ga_to_".$to."ga";
    my $send_frame3 = "na_".$from."lla_to_".$to."ga_lla";
    my $send_frame4 = "na_".$from."lla_to_".$to."lla";
    my $recv_frame1 = "erep_".$to."_to_".$from;
    my $recv_frame2 = "ns_".$to."ga_to_any_".$from."ga";
    my $recv_frame3 = "ns_".$to."ga_to_any_".$from."lla";
    my $recv_frame4 = "ns_".$to."lla_to_any_".$from."lla";

    vLogHTML("<B>$from transmits an Echo Request to $to.<B><BR>");

    vSend($if, $send_frame1);
    my %ret = vRecv($if, 5, 0, 0, $recv_frame1, $recv_frame2, $recv_frame3,$recv_frame4);
    if ($ret{recvFrame} eq $recv_frame1){
	vLogHTML("<B>$from received an Echo Reply from $to.</B><BR>");	
	return 0;
    }elsif($ret{recvFrame} eq $recv_frame2){
	vSend($if, $send_frame2);
    }elsif($ret{recvFrame} eq $recv_frame3){
	vSend($if, $send_frame3);
    }elsif($ret{recvFrame} eq $recv_frame4){
	vSend($if, $send_frame4);
    }

    %ret = ();
    %ret = vRecv($if, 5, 0, 0, $recv_frame1);
    if($ret{recvFrame} eq $recv_frame1) {
	vLogHTML("<B>$from receives an Echo Reply from $to.</B><BR>");	
	return 0;
    }
    vLogHTML("<B><FONT COLOR=\"#FF0000\">$from could not receive any Echo Reply from $to.</FONT></B><BR>");
    return 1;
}


sub check_prefix($$)
{
    my ($frame, $cmp_prefix) = @_;
    my $prefix = $$frame{"Frame_Ether\.Frame_Ether\.Packet_IPv6\.ICMPv6_RA\.Opt_ICMPv6_Prefix\.Prefix"};

    vLogHTML("<B><FONT COLOR=\"#FF0000\">Prefix: $prefix.</FONT></B><BR>");

    return (0, $prefix) if ($prefix =~ /$cmp_prefix/);

    return (1, "");
}

#--------------------------------------------------------------#
# cpe6_ping_thr_router(#if_in, $if_out                         #
#           $from, $to, $router,                               #
#           $from_addr, $to_addr)                              #
#							       #
# Notes:                                                       #
#    ping                                                      #
#                                                              #
#    SUCCESS: return 0                                         #
#    FAILURE: return 1                                         #
#--------------------------------------------------------------#
sub cpe6_ping_3($$$$$$$$$)
{
    my ($if_in, $if_out, $from, $to, $router, $from_prefix,$from_addr,$to_prefix,$to_addr) = @_;
    my $filename = "CPE6_test_pkt.def";
    my $cpp = "";
    my %ret;
    
    create_def_file_3($filename, $if_in, $if_out, $from, $to, $router, $from_prefix,$from_addr,$to_prefix,$to_addr);
    vCPP($cpp);

    my $send_frame1 = "ereq_".$from."_to_".$router;
    my $send_frame2 = "na_".$to."lla_ga_to_".$router."lla";
    my $send_frame3 = "na_".$to."lla_lla_to_".$router."lla";
    my $send_frame4 = "erep_".$to."_to_".$router;
    my $send_frame5 = "na_".$from."lla_ga_to_".$router."lla";
    my $send_frame6 = "na_".$from."lla_lla_to_".$router."lla";

    my $recv_frame1 = "ereq_".$router."_to_".$to;
    my $recv_frame2 = "ns_".$router."lla_to_any_".$to."ga";
    my $recv_frame3 = "ns_".$router."lla_to_any_".$to."lla";
    my $recv_frame4 = "erep_".$router."_to_".$from;
    my $recv_frame5 = "ns_".$router."lla_to_any_".$from."ga";
    my $recv_frame6 = "ns_".$router."lla_to_any_".$from."lla";

    vLogHTML("<B>$from transmits an Echo Request to $to.<B><BR>");

    #send Echo Request TN3->TN2
    vSend($if_in, $send_frame1);
    %ret = vRecv($if_out, 5, 0, 0, $recv_frame1, $recv_frame2, $recv_frame3);
    if ($ret{recvFrame} eq $recv_frame1){
	vLogHTML("<B>$to received an Echo Request from $from.</B><BR>");	
#	return 0;
    }elsif($ret{recvFrame} eq $recv_frame2){
	vSend($if_out, $send_frame2);
    }elsif($ret{recvFrame} eq $recv_frame3){
	vSend($if_out, $send_frame3);
    }
    if (($ret{recvFrame} eq $recv_frame2) || ($ret{recvFrame} eq $recv_frame3)) {
      %ret = ();
      %ret = vRecv($if_out, 5, 0, 0, $recv_frame1);
      if($ret{recvFrame} eq $recv_frame1) {
	  vLogHTML("<B>$to receives an Echo Request from $from.</B><BR>");	
      } else {
	  vLogHTML("<B><FONT COLOR=\"#FF0000\">$to could not receive any Echo Request from $from.</FONT></B><BR>");
	  return 1;
      }
    }

    if ($ret{status} != 0) {
      vLogHTML("<B>$from does not receive echo request and NS.<B><BR>");
      return 1;
    }
    vLogHTML("<B>$to transmits an Echo Reply to $from.<B><BR>");
    #send Echo Reply TN2->TN3
    vSend($if_out, $send_frame4);
    %ret = vRecv($if_in, 5, 0, 0, $recv_frame4, $recv_frame5, $recv_frame6);
    if ($ret{recvFrame} eq $recv_frame4){
	vLogHTML("<B>$from received an Echo Reply from $to.</B><BR>");	
	return 0;
    }elsif($ret{recvFrame} eq $recv_frame5){
	vSend($if_in, $send_frame5);
    }elsif($ret{recvFrame} eq $recv_frame6){
	vSend($if_in, $send_frame6);
    }
    %ret = ();
    %ret = vRecv($if_in, 5, 0, 0, $recv_frame4);
    if($ret{recvFrame} eq $recv_frame4) {
	vLogHTML("<B>$from receives an Echo Reply from $to.</B><BR>");	
    } else {
	vLogHTML("<B><FONT COLOR=\"#FF0000\">$from could not receive any Echo Reply from $to.</FONT></B><BR>");
	return 1;
    }
    return 0;
}

#--------------------------------------------------------------#
# create_ping_def_file_3($filename, $if_in, $if_out, $from,    # 
#       	       $to, $router, $from_addr, $to_addr)     #
#							       #
# Notes:                                                       #
#    create neccessary definition packets file for ping        #
#    which include ns
#                                                              #
#    SUCCESS: return 0                                         #
#    FAILURE: return 1                                         #
#--------------------------------------------------------------#
sub create_def_file_3($$$$$$$$$$)
{
    my ($filename, $if_in, $if_out, $from, $to, $router, $from_prefix,$from_addr,$to_prefix,$to_addr) = @_;

    open(OUT, ">./$filename")|| return 2;

    print OUT "/* \n";
    print OUT "*** DO NOT EDIT THIS FILE ***\n";
    print OUT "*/\n";

    print OUT "#define FROM_ADDR v6merge(\"$from_prefix\",64,v6($from_addr))\n";
    print OUT "#define TO_ADDR v6merge(\"$to_prefix\",64,v6($to_addr))\n";
    # _HETHER_xxxx
    print OUT "_HETHER_define(_HETHER_" . $from . "_to_" . $router . ",\n";
    print OUT "\t\t" . $from . "_MAC_ADDR, " . $router . "_MAC_ADDR)\n\n";

    print OUT "_HETHER_define(_HETHER_" . $to . "_to_" . $router . ",\n";
    print OUT "\t\t" . $to . "_MAC_ADDR, " . $router . "_MAC_ADDR)\n\n";

    print OUT "_HETHER_define(_HETHER_" . $router . "_to_" . $from . ",\n";
    print OUT "\t\t" . $router . "_MAC_ADDR, " . $from . "_MAC_ADDR)\n\n";

    print OUT "_HETHER_define(_HETHER_" . $router . "_to_" . $to . ",\n";
    print OUT "\t\t" . $router . "_MAC_ADDR, " . $to . "_MAC_ADDR)\n\n";

    # echo request 1
    print OUT "FEM_icmp6_echo_request (\n";
    print OUT "\tereq_". $from . "_to_" . $router . ",\n";
    print OUT "\t_HETHER_" . $from . "_to_" . $router . ",\n";
    print OUT "\t{\n";
    print OUT "\t\t_SRC(FROM_ADDR);\n";
    print OUT "\t\t_DST(TO_ADDR);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tpayload = data8;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    # echo request 1
    print OUT "FEM_icmp6_echo_request (\n";
    print OUT "\tereq_". $router . "_to_" . $to . ",\n";
    print OUT "\t_HETHER_" . $router . "_to_" . $to . ",\n";
    print OUT "\t{\n";
    print OUT "\t\t_SRC(FROM_ADDR);\n";
    print OUT "\t\t_DST(TO_ADDR);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tpayload = data8;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    # echo reply 1
    print OUT "FEM_icmp6_echo_reply (\n";
    print OUT "\terep_". $to . "_to_" . $router . ",\n";
    print OUT "\t_HETHER_" . $to . "_to_" . $router . ",\n";
    print OUT "\t{\n";
    print OUT "\t\t_SRC(TO_ADDR);\n";
    print OUT "\t\t_DST(FROM_ADDR);\n";    
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tpayload = data8;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    # echo reply 2
    print OUT "FEM_icmp6_echo_reply (\n";
    print OUT "\terep_". $router . "_to_" . $from . ",\n";
    print OUT "\t_HETHER_" . $router . "_to_" . $from . ",\n";
    print OUT "\t{\n";
    print OUT "\t\t_SRC(TO_ADDR);\n";
    print OUT "\t\t_DST(FROM_ADDR);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tpayload = data8;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    # ns
    print OUT "FEM_icmp6_ns(\n";
    print OUT "\tns_" . $router . "lla_to_any_" . $to . "ga,\n";
    print OUT "\t_HETHER_any,\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    #print OUT "\t\t_SRC(oneof(nutv6(\"Link0\"),nutv6(\"Link1\"));\n";
    print OUT "\t\t_SRC(any);\n";
    print OUT "\t\t_DST(any);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tTargetAddress = TO_ADDR;\n";
    print OUT "\t\toption = any;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    print OUT "FEM_icmp6_ns(\n";
    print OUT "\tns_" . $router . "lla_to_any_" . $to . "lla,\n";
    print OUT "\t_HETHER_any,\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    #print OUT "\t\t_SRC(oneof(nutv6(\"Link0\"),nutv6(\"Link1\"));\n";
    print OUT "\t\t_SRC(any);\n";
    print OUT "\t\t_DST(any);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tTargetAddress = v6($to" . "_LINKLOCAL);\n";
    print OUT "\t\toption = any;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    # na
    print OUT "FEM_icmp6_na(\n";
    print OUT "\tna_" . $to . "lla_ga_to_" . $router . "lla,\n";
    print OUT "\t_HETHER_" . $to . "_to_" . $router . ",\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    print OUT "\t\t_SRC(v6($to" . "_LINKLOCAL));\n";
    print OUT "\t\t_DST(" . lc($router) . "v6(\"$if_out\"));\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tRFlag = 1;\n";
    print OUT "\t\tSFlag = 1;\n";
    print OUT "\t\tOFlag = 1;\n";
    print OUT "\t\tTargetAddress = TO_ADDR;\n";
    print OUT "\t\toption = opt_tll_" . lc($to) . ";\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    print OUT "FEM_icmp6_na(\n";
    print OUT "\tna_" . $to . "lla_lla_to_" . $router . "lla,\n";
    print OUT "\t_HETHER_" . $to . "_to_" . $router . ",\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    print OUT "\t\t_SRC(v6($to" . "_LINKLOCAL));\n";
    print OUT "\t\t_DST(" . lc($router) . "v6(\"$if_out\"));\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tRFlag = 1;\n";
    print OUT "\t\tSFlag = 1;\n";
    print OUT "\t\tOFlag = 1;\n";
    print OUT "\t\tTargetAddress = v6($to" . "_LINKLOCAL);\n";
    print OUT "\t\toption = opt_tll_" . lc($to) . ";\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

#############################################
    # ns
    print OUT "FEM_icmp6_ns(\n";
    print OUT "\tns_" . $router . "lla_to_any_" . $from . "ga,\n";
    print OUT "\t_HETHER_any,\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    #print OUT "\t\t_SRC(oneof(nutv6(\"Link0\"),nutv6(\"Link1\"));\n";
    print OUT "\t\t_SRC(any);\n";
    print OUT "\t\t_DST(any);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tTargetAddress = FROM_ADDR;\n";
    print OUT "\t\toption = any;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    print OUT "FEM_icmp6_ns(\n";
    print OUT "\tns_" . $router . "lla_to_any_" . $from . "lla,\n";
    print OUT "\t_HETHER_any,\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    #print OUT "\t\t_SRC(oneof(nutv6(\"Link0\"),nutv6(\"Link1\"));\n";
    print OUT "\t\t_SRC(any);\n";
    print OUT "\t\t_DST(any);\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tTargetAddress = v6($from" . "_LINKLOCAL);\n";
    print OUT "\t\toption = any;\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    # na
    print OUT "FEM_icmp6_na(\n";
    print OUT "\tna_" . $from . "lla_ga_to_" . $router . "lla,\n";
    print OUT "\t_HETHER_" . $from . "_to_" . $router . ",\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    #print OUT "\t\t_SRC($from_addr);\n";
    print OUT "\t\t_SRC(v6($from" . "_LINKLOCAL));\n";
    print OUT "\t\t_DST(" . lc($router) . "v6(\"$if_in\"));\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tRFlag = 1;\n";
    print OUT "\t\tSFlag = 1;\n";
    print OUT "\t\tOFlag = 1;\n";
    print OUT "\t\tTargetAddress = FROM_ADDR;\n";
    print OUT "\t\toption = opt_tll_" . lc($from) . ";\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    print OUT "FEM_icmp6_na(\n";
    print OUT "\tna_" . $from . "lla_lla_to_" . $router . "lla,\n";
    print OUT "\t_HETHER_" . $from . "_to_" . $router . ",\n";
    print OUT "\t{\n";
    print OUT "\t\tHopLimit = 255;\n"; 
    print OUT "\t\t_SRC(v6($from" . "_LINKLOCAL));\n";
    print OUT "\t\t_DST(" . lc($router) . "v6(\"$if_in\"));\n";
    print OUT "\t},\n";
    print OUT "\t{\n";
    print OUT "\t\tRFlag = 1;\n";
    print OUT "\t\tSFlag = 1;\n";
    print OUT "\t\tOFlag = 1;\n";
    print OUT "\t\tTargetAddress = v6($from" . "_LINKLOCAL);\n";
    print OUT "\t\toption = opt_tll_" . lc($from) . ";\n";
    print OUT "\t}\n";
    print OUT ")\n\n";

    close(OUT);

    return 0;
}

#--------------------------------------------------------------#
# check_ra_routeinfo_option(   )                               #
#                                                              #
# Notes : If the option in RA passively received does not      #
# contain correct option, we give it second chance by checking # 
# RA actively received(get RA by sending RS).                  #
#--------------------------------------------------------------#
sub check_ra_routeinfo_option()
{
	my $IF1 = "Link1";
	my $loop = 1;
	my $found_ra = 0;
	my $retra;
	my %ra;
	vLogHTML('Wait for RA passively<BR>');
	while (($loop < 15) && ($found_ra == 0)) {
	    ($retra, %ra) = wait_for_ra($IF1, 2, 0);
	    if ($retra == 0) {
	      vLogHTML('Checking the passively received RA<BR>');

	      # get correct RA to verify. (The router lifetime of RA must be 0)
	      $router_lifetime = $ra{"Frame_Ether.Packet_IPv6.ICMPv6_RA.LifeTime"};
	      if (ra_options_exist(\%ra, $RA_CMP_ROUTEINFO) == 0) {
		# verify the prefix
		my $count = 1;
		my $base = "Frame_Ether.Packet_IPv6.ICMPv6_RA.Opt_ICMPv6_RouteInfo";
		my $routeinfo_opt_num = $ra{$base."#"};
		my $prefix_opt = $base.".Prefix";
		my $tn2_prefix;
		while (($count <= $routeinfo_opt_num) && ($found_ra == 0)){
		    $tn2_prefix = $ra{$prefix_opt};
		    if ($tn2_prefix =~ /3ffe:501:ffff:111/ ) {
			vLogHTML("<B>RA includes the correct prefix: $tn2_prefix</B></BR>");
			$found_ra = 1;
		    }
		    $count++;
		    $prefix_opt = $base.$count."Prefix";
		}
	      }
	    }
	    $loop++;
	}
	if ($found_ra == 1) {
	  return 0;
	} else {
	  cpe6ExitError("<B><FONT COLOR=\"#FF0000\">RA does not include the correct Prefix: $tn2_prefix.</FONT></B><BR>");
	  return 1;
	}
}

#--------------------------------------------------------------#
# check_ra_changed_prefix_option($ra)                          #
#                                                              #
# Notes : If the option in RA passively received does not      #
# contain correct option, we give it second chance by checking # 
# RA actively received(get RA by sending RS).                  #
#--------------------------------------------------------------#
sub check_ra_changed_prefix_option($)
{
	my ($ra) = @_;
	my $count = 1;
	my $base = "Frame_Ether.Packet_IPv6.ICMPv6_RA.Opt_ICMPv6_Prefix";
	my $prefix_opt_num = $$ra{$base."#"};
	my $prefix_opt = $base;
	my $tn2_prefix1;
	my $PreferredLifetime;
	while ($count <= $prefix_opt_num){
	    $tn2_prefix1= $$ra{$prefix_opt."."."Prefix"};
	    $PreferredLifetime = $$ra{$prefix_opt."."."PreferredLifetime"};
	    if ($tn2_prefix1 =~ /3ffe:501:ffff:111/){
		vLogHTML("<B>RA includes the correct prefix: $tn2_prefix1</B></BR>");
		if ($PreferredLifetime == 0) {
		  vLogHTML("<B>RA includes the correct Preferred Lifetime: $PreferredLifetime</B></BR>");
		  return 0;
		} 
	    }
	    $count++;
	    $prefix_opt = $base.$count;
	}
	cpe6ExitError("<B><FONT COLOR=\"#FF0000\">RA does not include correct Prefix (must be 3ffe:501:ffff:111) or preferred lifetime(must be 0).</FONT></B><BR>");
	return 1;
}

return 1;
