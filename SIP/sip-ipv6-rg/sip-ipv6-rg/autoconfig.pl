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

#

#**********************************************************************************
# Program: autoconfig.pl [Argument:Platform flag ('UA' or 'PX')]
#                        [Return :(none)]
# Description: Configure settings for the conformance test of SIP Ipv6 Ready Logo.
# Date       : Feb.21, 2007    Ver. 1.0.0    :
#**********************************************************************************

# 08/6/18 rndc : add key, rndc.conf and named.conf
# 08/6/11 add koid version check


#--------------------------------------------------------------
# Get a platform-flg from make-file
#--------------------------------------------------------------
$PLATFORM_FLG = $ARGV[0];        # Argument from make-file

#>>> TEST >>>>>>>>>>>>>>>>>>  
#   $PLATFORM_FLG = 'PX';        # Argument from make-file
#   print "test:platform[$PLATFORM_FLG]\n";
#<<<<<<<<<<<<<<<<<<<<<<<<<<<


if ($PLATFORM_FLG ne 'UA' and $PLATFORM_FLG ne 'PX') {
    print "ERROR: Failed to get a platform flag from a make-file.\n";
    exit;
} 

#--------------------------------------------------------------
# Initialization (UA)
#--------------------------------------------------------------

#-- Values for checking config.txt(UA). (Refferd to 2.) 
my (%config_setting_UA, %config_setting_PX);
%config_setting_UA = ("REG-ADDRESS"=>"", 
                   "REG-HOSTNAME"=>"",
                   "PUA-ADDRESS"=>"",
                   "PUA-HOSTNAME"=>"",
                   "PUA-HOSTNAME-FOR-1PX"=>"",
                   "PUA-CONTACT-HOSTNAME"=>"",
                   "PUA-CONTACT-HOSTNAME-FOR-1PX"=>"",
                   "ROUTER-PREFIX-ADDRESS"=>"",
                   "DNS_ADDRESS"=>"",
                   "PX1-ADDRESS"=>"",
                   "PX1-HOSTNAME"=>"",
                   "PX2-ADDRESS"=>"",
                   "PX2-HOSTNAME"=>"",
                   "OT1-ADDRESS"=>"",
                   "UA-ADDRESS"=>"",
                   "UA-CONTACT-HOSTNAME"=>"" );

#-- Values for checking config.txt(Server). (Refferd to 2.) 
%config_setting_PX = ("target,uri"=>"",
                      "target,address"=>"", 
                      "target,prefix"=>"", 
                      "target.user1,contact-uri"=>"", 
                      "target.user1,address"=>"", 
                      "target.user2,contact-uri"=>"", 
                      "target.user2,address"=>"",
                      "target.user3,contact-uri"=>"", 
                      "target.user3,address"=>"",
                      "target.user4,contact-uri"=>"", 
                      "target.user4,address"=>"",
                      "proxy,uri"=>"",
                      "proxy,address"=>"",
                      "proxy2,uri"=>"",
		      "proxy2,address"=>"",
                      "proxy.user1,contact-uri"=>"", 
                      "proxy.user1,address"=>"",
#                      "registrar,uri"=>"",
#                      "registrar,address"=>"",
                      "dns,address"=>"",); 

my $RNDCKey = <<RNDCkey;
key "rndc-key" {
	algorithm hmac-md5;
	secret "uS7EMlBMHzlD8p3b/z7uIQ==";
};
controls {
	inet 127.0.0.1 port 953
		allow { 127.0.0.1; } keys { "rndc-key"; };
};
RNDCkey

my $RNDCconf = <<RNDCconf;
key "rndc-key" {
	algorithm hmac-md5;
	secret "uS7EMlBMHzlD8p3b/z7uIQ==";
};
options {
	default-key "rndc-key";
	default-server 127.0.0.1;
	default-port 953;
};
RNDCconf

#-------------------------------------------------------------
#--- 1. Check version of OS, BIND, and Perl
#-------------------------------------------------------------
print "----- Check version of OS, BIND, and Perl----\n"; 

$result = Check_Version();
if ($result ne 'OK') {exit;}

#-------------------------------------------------------------
#-- 2. Configuration of IPv6 functions on OS -----
#-------------------------------------------------------------
print "----- Setting IPv6 funcion of OS ------------\n";
$result = EXEC_sysctl();
if ($result ne 'OK') {exit;}

#-------------------------------------------------------------
#--- 3.Read "config.txt" and 
#    4.Check grammatical mistakes in "config.txt" ----
#-------------------------------------------------------------
print "----- Read config.txt and Check necessary values--\n"; 
%config_setting;
%config_setting = GetConfigValue($PLATFORM_FLG, "config.txt");
$n= keys(%config_setting);
if ($n < 1) {exit;}

# check if the value starts with '3ffe:501:ffff' or not -----
while ( ($key, $value) = each %config_setting) {

    #--- UA ---------
    if ($PLATFORM_FLG eq 'UA'){
        if (index($key, 'ADDRESS') == -1) {next;}
        if ($key eq 'UA-ADDRESS' and length($value) < 1) { next;}
    #--- Server -----
    } else {
        if (index($key, 'address') == -1) {next;}
    }
    
    my @suffix = split(/:/, $value);
    for ($i=0;$i<=$#suffix;$i++){
        $suffix[$i] = substr("0000$suffix[$i]",-4);
    }
    my @wk_list = ($suffix[0], $suffix[1], $suffix[2]);
    my $comp_adr = join(":", @wk_list).":";
    if (length($common_value) < 1 ) {
        $common_value = $comp_adr;
        next;
    }
    
    #--- Specification for Ready Logo ------------------------- 
    if ($comp_adr ne $common_value) {
        print "ERROR: Configured the non-specified address for Ready Logo\n$key:[$value]or the other address:[$common_value] \n";    
        exit;
    }
    if ($common_value ne '3ffe:0501:ffff:'){
        print "ERROR: Configured the address that doesn't start with '3ffe:501:ffff'. $key:[$value]\n";    
        exit;
    }
    #--- End of Specification for Reeady Logio ----------------
}

#-------------------------------------------------------------
#--- 5a.Read each "nut.def" and "tn.def" of v6eval and koi-sip.
#      (Check link name, interface name, and MAC address.)
#-------------------------------------------------------------
print "----- Read nut.def and tn.def ---------------\n";
$param_Link0 = "Link0";
$location_v6eval="/usr/local/v6eval/etc/";

my @result = GetIFNAME_MACAddress($location_v6eval."nut.def", 
                                  $location_v6eval."tn.def", 
                                  $param_Link0);

if ($#result < 1) {exit;}

$IF_NAME = $result[0];          # interface name
$NUT_MAC_ADR =  $result[1];     # MAC address (nut)

#-------------------------------------------------------------
#--- 5b.koid vesion 
#-------------------------------------------------------------
($msg) = GetProcessResult("koid -V",'T');
if(!$msg || $msg !~ /version:\s*([1-9\.]+)/m){
    print "ERROR: koid program no installed or old vesion.\n";    
    exit;
}
print "----- koid version [$1] -----\n";    

#----------------------------------------------------------
# 6.Configure neccesary address by using ifconfig
#----------------------------------------------------------
print "----- Configure necessary address -----------\n";

$result = Set_ifconfig($IF_NAME);
if ($result eq '') {exit;}


#----------------------------------------------------------
# 7.reflect to "rtadvd.conf"
#   (prefix is from "config.txt")
#   (interface name is from "nut.def"/"tn.def")
#----------------------------------------------------------
print "----- Create a rtadvd.conf ------------------\n";

$rtadvd_file = "/etc/rtadvd.conf";

# Create file contents (UA) 
if ($PLATFORM_FLG eq 'UA') {
    $get_text = CREATE_text_rtadvd($rtadvd_file, $IF_NAME, $config_setting{"ROUTER-PREFIX-ADDRESS"});
# Create file contents (Server) 
} else {
    $get_text = CREATE_text_rtadvd($rtadvd_file, $IF_NAME, $config_setting{"target,prefix"});
}

if (length($get_text) < 1) { exit;}

# Edit contents and update a file 
$get_result = UPDATE_file($rtadvd_file, $get_text);
if ($get_result ne "OK") { exit; }


#----------------------------------------------------------
# 8.Run rtadvd 
#----------------------------------------------------------
print "----- Run rtadvd ----------------------------\n";

# End running rtadvd if existing.
KillProcess('rtadvd',15);

# Run rtadvd (static mode)
system ("rtadvd -s $IF_NAME\n");

#----------------------------------------------------------
# 9.Configuration of BIND (named.conf, *.zone)
#----------------------------------------------------------
print "----- Configuration of BIND -----------------\n";

$rndc_conf = "/etc/namedb/rndc.conf";
$named_conf = "/etc/namedb/named.conf";
$com_zone = "/etc/namedb/com.zone";

# Check zone domain (UA)
%zone_kind = ChkZONE_domain(\%config_setting);

$elmt_cnt = keys %zone_kind;
if ($elmt_cnt != 1) { exit;}    #Error if nothing

# Make reverse domains
my %reverse_adrs;

#--- UA ---------
if ($PLATFORM_FLG eq 'UA') {
    while ( ($key, $value) = each %config_setting) {
        if (index($key, 'ADDRESS') == -1) {next;}
        if ($key eq 'UA-ADDRESS' and length($value) < 1) { next;}
    
        my $wk_revadr = Make_ReverseAddress($config_setting{$key});
        if (length($wk_revadr) < 1) {exit}
        $reverse_adrs{$key} = $wk_revadr;
#print "UA key [$key]\t value [$value]\t reverse [$wk_revadr] \n";
    }   
#--- Server -----
} else {

    while ( ($key, $value) = each %config_setting) {
        if (($key eq 'target.user1,address') or ($key eq 'target.user2,address') or 
            ($key eq 'target.user3,address') or ($key eq 'target.user4,address') or 
            ($key eq 'proxy,address') or ($key eq 'proxy.user1,address') or 
            ($key eq 'dns,address') or ($key eq 'target,prefix')
	    or ($key eq 'proxy2,address')
){ 
        } else {next;}
        
        my $wk_revadr = Make_ReverseAddress($config_setting{$key});
        if (length($wk_revadr) < 1) {exit}
        $reverse_adrs{$key} = $wk_revadr;
#print "key [$key]\t value [$value]\t reverse [$wk_revadr] \n";
    }
}

#-- rndc.conf ----
$get_result = UPDATE_file($rndc_conf, $RNDCconf);
if ($get_result ne "OK") { exit;}

#-- named.conf ----
$get_text = CREATE_text_BIND ($named_conf, \%reverse_adrs, \%zone_kind, \%config_setting);
if (length(get_text) == -1) { exit; }
$get_text .= $RNDCKey;

$get_result = UPDATE_file($named_conf, $get_text);
if ($get_result ne "OK") { exit;}

#--- com.zone ----
$get_text = CREATE_text_BIND ($com_zone, \%reverse_adrs, \%zone_kind, \%config_setting);
if (length(get_text) == -1) { exit;}

$get_result = UPDATE_file($com_zone, $get_text);
if ($get_result ne "OK") { exit; }

#--- *.ip6 (reverse file) -----
if ($PLATFORM_FLG eq 'UA') {
    $rev_adr = substr($reverse_adrs{'ROUTER-PREFIX-ADDRESS'}, -23, 23);
} else {
    $rev_adr = substr($reverse_adrs{'target,prefix'}, -23, 23);
}
$com_rev = "/etc/namedb/".$rev_adr.".ip6";
$get_text = CREATE_text_BIND ($com_rev, \%reverse_adrs, \%zone_kind, \%config_setting);
if (length(get_text) == -1) { exit;}

$get_result = UPDATE_file($com_rev, $get_text);
if ($get_result ne "OK") { exit; }

#--- resolv.conf -----
if ($PLATFORM_FLG eq 'UA') {
    $get_text = "nameserver\t\t$config_setting{'DNS_ADDRESS'}\n";
}else {
    $get_text = "nameserver\t\t$config_setting{'dns,address'}\n";
}
$get_result = UPDATE_file("/etc/resolv.conf", $get_text);
if ($get_result ne "OK") { exit; }


#----------------------------------------------------------
# 10.Run BIND (named) 
# 11.reflect to the configration of BIND (rndc)
#----------------------------------------------------------
print "----- Run BIND (named) ----------------------\n";
#print "----- reflect to the configration of BIND----\n";

($comment) = GetProcessResult('pgrep named');
    if (length($comment) < 1) {
        system ("named");
    } else {
        system ("rndc -c /etc/namedb/rndc.conf reload");
    }
#----------------------------------------------------------
#12. See if the tester address is user-fixed or auto-created
#    from config.txt
#----------------------------------------------------------

if ($PLATFORM_FLG eq 'UA') { 
print "----- Check 'UA-ADDRESS' (manual or auto) ---\n";
    my $Auto_UA_ADDRESS;

    if (length($config_setting{'UA-ADDRESS'}) < 1 ) {
        my $prefix_for_GetUAAdr = $config_setting{'ROUTER-PREFIX-ADDRESS'};
        $prefix_for_GetUAAdr = substr($prefix_for_GetUAAdr, 0, length($prefix_for_GetUAAdr)-1 );
        $Auto_UA_ADDRESS = GenerateIPv6FromMac($NUT_MAC_ADR,$prefix_for_GetUAAdr);
        if (length($Auto_UA_ADDRESS) < 1 ) {
            print "ERROR: Failed to auto-create the user address.\n";
            exit;
        }
#        print "ua address [$Auto_UA_ADDRESS]\n";
        $config_setting{'UA-ADDRESS'} = $Auto_UA_ADDRESS; 
    }
}

#----------------------------------------------------------
#:13.Connection check with ping
#----------------------------------------------------------
print "----- Check the connection  -----------------\n";
@ping6_flg = ();
if ($PLATFORM_FLG eq 'UA') { 
    my $cmd = "ping6 -c 3 ".$config_setting{'UA-ADDRESS'};
    ($comment) = GetProcessResult($cmd);

    if (index($comment, " 0.0% packet loss") == -1) {
        push(@ping6_flg,"[NG]: failed ping6 from the other UA(".$config_setting{'UA-ADDRESS'}.").\n");
    }else {
        push(@ping6_flg,"[OK]: ping6 to the other UA(".$config_setting{'UA-ADDRESS'}.") successful.\n");
    }
} else {
    while (($key, $value) = each %config_setting){
        if (($key eq 'target,address') or ($key eq 'target.user1,address') or 
            ($key eq 'target.user2,address') or ($key eq 'target.user3,address') or
            ($key eq 'target.user4,address') or ($key eq 'proxy,address') or 
            ($key eq 'proxy.user1,address') or ($key eq 'registrar,address')
	    or ($key eq 'proxy2,address')
) {
        } else {next;}
        my $cmd = "ping6 -c 3 ".$value;
        ($comment) = GetProcessResult($cmd);
        if (index($comment, " 0.0% packet loss") == -1) {
            push(@ping6_flg,"[NG]: failed ping6 to $key [$value].\n");
        }else {
            push(@ping6_flg,"[OK]: ping6 to $key [$value] successful.\n");
        }
    }

}

#----------------------------------------------------------
#:13'.rtpsend check
#----------------------------------------------------------
if ($PLATFORM_FLG eq 'UA') { 
    ($comment) = GetProcessResult("which rtpsend",'T');
    if ($comment) {
        push(@ping6_flg,"[OK]: rtpsend(oRTP:src/tests) command installed.\n");
    }else {
        push(@ping6_flg,"[NG]: rtpsend(oRTP:src/tests) command not installed.\n");
    }
}

#----------------------------------------------------------
#14.DNS check with dig
#----------------------------------------------------------
print "----- Check DNS configuration  --------------\n";

my $dig_ANSWER='ANSWER: '; 

for ($i=0; $i<=$#dig_chk;$i++){
    $cmd = "dig $dig_chk[$i][0] $dig_chk[$i][1]"; 
    ($comment) = GetProcessResult($cmd);
    
    # check returned-strings
    $idx = index($comment, $dig_ANSWER);
    if ($idx != -1){ 
        $ans = substr($comment, ($idx + length($dig_ANSWER)),1);
        if ($ans != '0'){ $dig_chk[$i][2] = 'OK';}
        else{ $dig_chk[$i][2] = 'NG';}
    }
    else{ $dig_chk[$i][2] = 'NG';}
}
#print "14.check DNS \t[$cmd]\n";
#exit;   #test<<<<<<


#----------------------------------------------------------
#15.Display the result of 11 and 12
#----------------------------------------------------------
print "----- Results of checking Connection and DNS are ...\n";

for ($i=0;$i<=$#ping6_flg;$i++) {
    print "$ping6_flg[$i]";
}

for ($i=0; $i<=$#dig_chk;$i++){
    print "[$dig_chk[$i][2]]:$dig_chk[$i][0]  $dig_chk[$i][1] \n";
}

print "\nAuto-configuration was completed.\n";

#===========================================================
# sub Check_Version :Arg(none)
#===========================================================
sub Check_Version {

    #-- OS ----------------
    ($required_OS, $required_OS_version) = ('FreeBSD', '6.0');
        my $ret = `uname -v`;

    my @suffix = split(/\s+/, $ret);
    if ($suffix[0] ne $required_OS){ 
        print "ERROR : Required OS $required_OS $required_OS_version -RELEASE or greater.\n";
        exit;
    }
    $ver_str = substr($suffix[1], 0, length($required_OS_version));
    if($ver_str < $required_OS_version) {
        print "WARNING : Required OS $required_OS $required_OS_version -RELEASE or greater.\n";
        }
    
    #-- BIND --------------
    ($required_BIND, $required_BIND_version) = ('BIND', '9.');
    $ret = `named -v`;
    @suffix = split(/\s+/, $ret);
    if ($suffix[0] ne $required_BIND){ 
        print "ERROR : Required $required_BIND $required_BIND_version x or greater.\n";
        return;
    }
    $ver_str = substr($suffix[1], 0, length($required_BIND_version));
    if ($ver_str ne $required_BIND_version) {
        print "ERROR : Required $required_BIND $required_BIND_version x or greater.\n";
        return;
    }

    #-- Perl --------------
    ($required_Perl_version) = ('5.8.5');
    use Config;
    if ($Config{'version'} ne $required_Perl_version){
        print "WARNING : Required Perl $required_Perl_version.\n";
    }
    return "OK";
}

#===========================================================
# sub EXEC_sysctl :Arg(none)
#===========================================================
sub EXEC_sysctl {

    #-- Initial setting for IPv6 functions on OS ---
    my @sysctl_values = ( 'net.inet6.ip6.forwarding=1', 
                  'net.inet6.ip6.redirect=1', 
                  'net.inet6.ip6.accept_rtadv=0', 
                  'net.inet6.ip6.auto_linklocal=1', 
                  'net.inet6.icmp6.rediraccept=1' );

    #-- Execute sysctl ---
    for ($i=0; $i<=$#sysctl_values; $i++) {
            system "sysctl $sysctl_values[$i]\n";
    }
    return 'OK';
}

#===========================================================
# sub GetConfigValue :Arg([0]:'UA' or 'PX', [1]:'config.txt')
#===========================================================
sub GetConfigValue {

    my ($argPlatform, $argFileName) = @_;
    my %config_setting;

    #--- See whether the platform is UA or server
    if    ($argPlatform eq 'UA') { %config_setting = %config_setting_UA;}
    elsif ($argPlatform eq 'PX') { %config_setting = %config_setting_PX;}
    else { 
        print "ERROR :Failed to get a platform type.\n";
        return;
    }

    #--- Read a file ---
    if (! -e $argFileName ){    
              print "ERROR: No such file[$argFileName] \n";
         return;
    }

    #--- Read a file ---
    LoadConfig($argFileName);
    while ( ($key, $value) = each %config_setting) {
    
        #--- UA ---------
        if ($argPlatform eq 'UA') {
                $x=GetCTInfo('CFG,'.$key );
                if (length($x) < 1) {
                        if ($key eq 'UA-ADDRESS'  ) { next;}
                       print "ERROR[$key]: no value\n";
                return;
                   }
    
            if (index($key, 'ADDRESS') ==-1 ){
            }    
                elsif (IPAddressType($x) ne 'ip6') {
                print "ERROR[$key]: [$x] is NOT IPv6 address. \n";
                   return;
                }
               #print "key:[$key] value[$x]\n";
            $config_setting{$key} = $x;
        }
        
        #--- Server -----
        else {
            my @separated_key = split(/,/, $key);
            if ((length($separated_key[0]) < 1) or (length($separated_key[1]) < 1) ){
                print "ERROR :Failed to edit group or tag name.\n";
                return;
            }
                $x=GetCTInfo('CFG,'.$separated_key[0].','.$separated_key[1]);
                if (length($x) < 1) {
                    print "ERROR: [$separated_key[0]] $separated_key[1] is no value\n";
                    return;
                }
            if (index($key, 'uri') != -1) {
                if (index($x, 'sip:') !=0 ) {
                    print "ERROR: [$separated_key[0]] $separated_key[1] needs to put 'sip:' in front of [$x].\n";
                       return;
                }
                $x = substr($x, ((length($x)-4)*(-1)));
                if (index($x, '@') != -1 ) {
                   $at_posi = index($x, '@');
                   $x = substr($x, ((length($x) - ($at_posi+1))*(-1))); 
                }
                $config_setting{$key} = $x;
            } else { 
                   $config_setting{$key} = $x;
            }
        }
#print "[$key]:\t[$config_setting{$key}]\n";
    }
    return %config_setting;
}


#===========================================================
# sub LoadConfig :Arg([0]:file name)
#                : Load a configuration file.
#===========================================================
sub LoadConfig {
    my($name)=@_;
    my($class,$type);

    $name = 'config.txt' unless($name);

    $type=IsConfigType($name);

    # Load common parameter
    open(CONFIG_TXT, $name);
    if($type eq 'new'){
        while (<CONFIG_TXT>) {
            # comment line
            if( /^\s*#/ ){next;}
            # class lines
            if( /^\[(.+)\]\s*$/ ){
                $class=$1;next;
            }
            # parameter line
            if( /^(\S+)\s+(\S*)\s*$/ ){
                SetCTInfo("CFG,$class,$1" ,$2);
            }
            elsif( /^(\S+)\s+(.+)$/ ){
                SetCTInfo("CFG,$class,$1" ,$2);
            }
        }
    }
    else{
        while (<CONFIG_TXT>) {
            # comment line
            if( /^\s*#/ ){next;}
            # parameter line
            if( /^(\S+)\.(\S+)\s+(\S*)\s*$/ ){
                SetCTInfo("CFG,$1,$2" ,$3);
            }
            elsif( /^(\S+)\s+(\S*)\s*$/ ){
                SetCTInfo("CFG,$1" ,$2);
            }
        }
    }
    close(CONFIG_TXT);
}

#===========================================================
# sub IsConfigType :Arg([0]:file name)
#===========================================================
sub IsConfigType {
    my($name)=@_;
    # Load common parameters
    open(CONFIG_TXT, $name);
    while (<CONFIG_TXT>) {
        # class line
        if( /^\[(.+)\]\s*$/ ){ return 'new';}
    }
    close(CONFIG_TXT);
    return 'old';
}

#===========================================================
# sub SetCTInfo :Arg([0]:keywords [1]:   )
#===========================================================
sub SetCTInfo {
    my($field,$val)=@_;
    my(@index,$hexSt,$i);
    $hexSt=\%TBLRoot;
    @index=split(/\,/,$field);
    for $i (0..$#index-1){
        if(ref($hexSt->{$index[$i]}) ne 'HASH'){
            $hexSt->{$index[$i]}={};
            $hexSt=$hexSt->{$index[$i]};
        }
        else{
            $hexSt=$hexSt->{$index[$i]};
        }
    }
    $hexSt->{$index[$#index]}=$val;
    return;
}

#===========================================================
# sub GetCTInfo :Arg([0]:keywords   )
#===========================================================
sub GetCTInfo{
    my($field)=@_;
    my(@index,$hexSt,$i);
    $hexSt=\%TBLRoot;
    @index=split(/\,/,$field);
    for $i (0..$#index-1){
    
        $hexSt=$hexSt->{$index[$i]};
    }
    return $hexSt->{$index[$#index]};
    return;
}

#===========================================================
# sub PrintItem
#===========================================================
sub PrintItem {
    my($val,@stack)=@_;
    @stack=caller(1);
    printf("-----PrintItem(%s)----------\n",$stack[3]);
    printf("   [%s] ref:[%s]",$val,ref($val));
    if(ref($val) eq 'SCALAR'){
        printf("  *ref[%s]",$$val);
    }
    printf("\n");
}

#===========================================================
# sub IPAddressType
#===========================================================
sub IPAddressType {
    my($msg)=@_;
    my($hex4);
    $hex4='[0-9a-fA-F]{1,4}(?::[0-9a-fA-F]{1,4})*';
    if($msg =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/){return 'ip4';
}
    if($msg =~ /^(?:$hex4(?:::)(?:$hex4)?|::(?:$hex4)?|$hex4)$/){return 'ip6';}
    if($msg =~ /^\[(?:$hex4(?:::)(?:$hex4)?|::(?:$hex4)?|$hex4)\]$/){return 'ip6
';}
    return '';
}

#===========================================================
# sub GetIFNAME_MACAddress :Arg([0]:nut.def, [1]:tn.def, [2]:keywaord('Link0') )
#===========================================================
sub GetIFNAME_MACAddress {

    my($nutdef, $tndef, $comp_str) = @_;
    my @rtn_val;

    %DEF_FILE = ($nutdef => "", $tndef  => "" );

    #--- Check: existance of the 2 files. (if not, end the application.)
    while ( ($key, $value) = each %DEF_FILE) {

        @target_lines = Get_Line($key, $comp_str);
        if ($#target_lines < 0 ) {
             print "ERROR:Not configured Link0 in [$key].\n";    
            return;
        }
        elsif ($#target_lines != 0 ) {
                print "ERROR: Other than one [$comp_str] is configured in [$key] \n";
                return;
        }
        $DEF_FILE{$key}=@target_lines[0];
    }

    #-- Check: nut.def (v6eval and koi-sip) and tn.def
    @suffix1 = split(/\s+/, $DEF_FILE{$nutdef});    # nut.def
    @suffix2 = split(/\s+/, $DEF_FILE{$tndef});     # tn.def
    if (($#suffix1 != 2) or ($#suffix2 != 2) ) {
        print "Error: 3 items (Link0, interface name and MAC address) MUST be configured in [nut.def] and [tn.def].\n";
        return;
    }
    $suffix[0] = \@suffix1;
    $suffix[1] = \@suffix2;

    for ($i=0;$i<=2;$i++){
        # Check MAC address
            if ($i == 2 ){
            for ($mcnt=0;$mcnt<2;$mcnt++){
            $get_result = IsMACAddress($suffix[$mcnt]->[$i]);
            if ($get_result ne "OK") {
                    print "ERROR: [$suffix[$mcnt]->[$i]] is incorrect address. (nut.def / tn.def) \n";
                return;
                }
            }
            if ( $suffix[0]->[$i] eq $suffix[1]->[$i]) {
                print "ERROR : Configured the same MAC addresses in nut.def and tn.def : [$suffix[0]->[$i]] [$suffix[1]->[$i]]\n";
                    return;
            }
            } else {
        
            if ( $suffix[0]->[$i] ne $suffix[1]->[$i]) {
                print "ERROR : Configured the different value in nut.def and tn.def : [$suffix[0]->[$i]] [$suffix[1]->[$i]]\n";
                    return;
            }
        }
    }
    if ((length($suffix[0]->[1]) < 1) or (length($suffix[0]->[2]) < 1) ){
        print "ERROR :Failed to get a interface name and MAC address from 'nut.def'.\n";
        return;
    }

    @rtn_val = ($suffix[0]->[1], $suffix[0]->[2]);    # interface name and NUT MAC address
    return @rtn_val;
}


#===========================================================
# sub Set_ifconfig :Arg([0]:interface name)
#===========================================================
sub Set_ifconfig {
    
    my ($argIF_NAME) = @_;
    my $wk_adr, $DELETE_ADDRESS;
    
    # 1. Check that the interface name is configured in ifconfig.
    ($result)=GetProcessResult("ifconfig $argIF_NAME");
    if ($result eq ''){ exit; }

    # 2. Check that the interface name is active.
    if (index($result, 'status: active') == -1) {
        print "ERROR: interface configuration is not active.\n";
        return ;    
    }
    
    # 3. delete unnecessary addresses from ifconfig. *** Added on 2007-03-08
    my @suffix = split(/\n/, $result);

    foreach (@suffix) {

	## pick up IPv6 address part from ifconfig ## 
        if (index($_, 'inet6 ') == -1 ) {next;}

        my $del_flg = 1;
	my @addr_esc = split(/ /, $_);

	if ($addr_esc[1] =~ /^f/) {
#		print "escape in\n";
		$del_flg = 0;
	}

        while ( ($key, $value) = each (%config_setting)) {
            if (length($value) < 1) {next;}

            if ($PLATFORM_FLG eq 'PX')  {
                # Modified on 2007-03-09
                if (($key eq 'target.user1,address') or ($key eq 'target.user2,address') or 
                    ($key eq 'target.user3,address') or ($key eq 'target.user4,address') or 
                    ($key eq 'proxy,address') or ($key eq 'proxy.user1,address') or 
                    ($key eq 'dns,address') or ($key eq 'target,prefix')
		    or ($key eq 'proxy2,address')
){

                    if ($key eq 'target,prefix') {
                        $DELETE_ADDRESS = $value."1";
                    } else {
                        $DELETE_ADDRESS = $value;
                    }
                    if (index($_, 'inet6 '.$DELETE_ADDRESS) != -1 ) {
#                        $del_flg = 0;
                        next;
                    }
                } else { next; }
            } else {
                if (($key eq 'REG-ADDRESS') or ($key eq 'PUA-ADDRESS') or 
                    ($key eq 'DNS_ADDRESS') or ($key eq 'PX1-ADDRESS') or 
                    ($key eq 'PX2-ADDRESS') or ($key eq 'ROUTER-PREFIX-ADDRESS')
		    or ($key eq 'OT1-ADDRESS')){
                
                    if ($key eq 'ROUTER-PREFIX-ADDRESS') {
                        $DELETE_ADDRESS = $value."1";
                    } else {
                        $DELETE_ADDRESS = $value;
                    }
                    if (index($_, 'inet6 '.$DELETE_ADDRESS) != -1 ) {
#                        $del_flg = 0;
                        next;
                    }
                } else { next; }
            }
        }
        if ($del_flg == 1) {
            $wk_adr =$_;
            $wk_adr =~ /^\s+inet6 (\S*).*$/;
            $ret = system ("`ifconfig $IF_NAME inet6 $1 delete\n`");
        }
    }
    
    # 4. Configure necessary addresses.
    $ifconfig_adr = GetIFIPv6($argIF_NAME);

    if ($PLATFORM_FLG eq 'UA') {
        my $UPDATE_ADDRESS = $config_setting{'ROUTER-PREFIX-ADDRESS'}."1";
        $ret = system ("`ifconfig $IF_NAME inet6 $UPDATE_ADDRESS\n`");
    }else{
        my $UPDATE_ADDRESS = $config_setting{'target,prefix'}."1";
        $ret = system ("`ifconfig $IF_NAME inet6 $UPDATE_ADDRESS\n`");
    }

#    my $ROUTER_ADDRESS;
    while ( ($key, $value) = each %config_setting) {
        
        my $UPDATE_ADDRESS;
        #--- UA ------ 
        if ($PLATFORM_FLG eq 'UA') {
            if (($key eq 'REG-ADDRESS') or ($key eq 'PUA-ADDRESS') or 
                ($key eq 'DNS_ADDRESS') or ($key eq 'PX1-ADDRESS') or 
#                ($key eq 'PX2-ADDRESS') or ($key eq 'ROUTER-PREFIX-ADDRESS')){
                ($key eq 'PX2-ADDRESS') or ($key eq 'OT1-ADDRESS')){
                
                if ($key eq 'ROUTER-PREFIX-ADDRESS') {
                    $UPDATE_ADDRESS = $value."1";
                } else {
                    $UPDATE_ADDRESS = $value;
                }
            } else { next; }
        }
        
        #--- Server -- 
        else {
            if (($key eq 'target.user1,address') or ($key eq 'target.user2,address') or 
                ($key eq 'target.user3,address') or ($key eq 'target.user4,address') or 
                ($key eq 'proxy,address') or ($key eq 'proxy.user1,address') or 
#                ($key eq 'dns,address') or ($key eq 'target,prefix')){
                ($key eq 'dns,address') or ($key eq 'proxy2,address')){

                if ($key eq 'target,prefix') {
                    $UPDATE_ADDRESS = $value."1";
                } else {
                    $UPDATE_ADDRESS = $value;
                }
            } else { next; }
        } 

        #--- Common (UA/Server) -------- 
        if ($#$ifconfig_adr < 0) {
            $ret = system ("`ifconfig $IF_NAME inet6 $UPDATE_ADDRESS\n`");
            next;
        }
        my $update_flg = 1;
            foreach (@$ifconfig_adr){
            if ($UPDATE_ADDRESS eq $_) { 
                $update_flg = 0;
                last; 
            }
        }
        if ($update_flg == 1) {
            $ret = system ("`ifconfig $IF_NAME inet6 $UPDATE_ADDRESS\n`");
        }
    }
    return "OK";
}

#===========================================================
# sub IsMACAddress Arg(compared address)
#===========================================================

sub IsMACAddress {
    my($msg)=@_;
    if($msg =~ /^[0-9a-fA-F]{1,2}\:[0-9a-fA-F]{1,2}\:[0-9a-fA-F]{1,2}\:[0-9a-fA-F]{1,2}\:[0-9a-fA-F]{1,2}\:[0-9a-fA-F]{1,2}$/){return 'OK';}
    return ;
}


#===========================================================
# sub UPDATE_file Arg:([0]:filename, [1]:file contents) 
#===========================================================
sub UPDATE_file {

    my($my_filename, $my_text) = @_;
    
    if ( -e $my_filename ){
        #--- Read -.conf file ----
        open(IN, $my_filename ) || die "Error: $my_filename $!\n";
        @CONF_FILE = <IN>;        #Read lines
        close(IN);

        # When back-up file exists => ask if overwrite or not 
        my $ans;
        if ( -e $my_filename.".bak" ){
            $lp_cnt =0;
            while ($lp_cnt <= 2) {
                if ($lp_cnt == 0) {
                    print "A backup file of [$my_filename] has already existed.\n";
                    print "Are you sure you want to overwrite that WITHOUT making any backup file? (y/n)\n>";
                }
                $ans = <STDIN>;
                if ($ans eq "y\n") {last;}
                elsif ($ans eq "n\n") {
                    exit;
                }
                print "Please input 'y' or 'n'. >";
                $lp_cnt++;
            }
            if (($ans ne "y\n") and ($lp_cnt > 2)){
                print "\nERROR:Repeated wrong input.\n";
                return;
            }
        }
        
        #--- Back up the existing -.conf file
        $ret = rename $my_filename, ($my_filename.".bak") ;
        if ( $ret != 1) {
            print "ERROR: Can't rename $my_filename.\n";
            return;            
        } 

        #--- Create string and make a file ------
            $get_result = CREATE_file($my_filename, $my_text);
#print "IN update [$my_text] \n";
            if ($get_result ne "OK") {
                print "ERROR: Failed to create $my_filename\n";
                return;
            }

    } else {

        #--- Create string and make a file ------
            $get_result = CREATE_file($my_filename, $my_text);
#print "IN update [$my_text] \n";
        if ($get_result ne "OK") {
            print "ERROR: Failed to create $my_filename\n";
            return;
        }
    }
    
    return "OK";
}

#===========================================================
# sub CREATE_text_rtadvd    Arg:([0]:filename,      [1]:interface name,
#                                [2]:router address,[3]:%cf_setting    )
#===========================================================
sub CREATE_text_rtadvd {

    my ($my_filename, $my_ifname, $my_router_adr, %cf_setting) = @_;
    my @new_str;

    #--- rtadvd.conf -----------
    my $current_time = localtime(time);
    if (index($my_filename, 'rtadvd.conf') != -1 ) {

#        ($my_filename, $my_ifname, $my_router_adr) = @_;
    
        $new_str = qq/# Tester setting [Created at $current_time] ##############################\n/.
                   qq/default:\\\n/.
                   qq/        :chlim#64:raflags#0:rltime#1800:rtime#0:retrans#0:\\\n/.
                   qq/        :pinfoflags="la":vltime#2592000:pltime#604800:mtu#0:\n/.
                   qq/\n/.
                   qq/$my_ifname:\\\n/.
                   qq/        :addr=\"$my_router_adr\":prefixlen#64:tc=default:\n/;  #"
    }
    return $new_str;

}
#===========================================================
# sub CREATE_text_BIND  Arg:([0]:filename, [1]reverse address, [2]zone_kind, [3]:%cf_setting )
#===========================================================
sub CREATE_text_BIND {

    my ($my_filename, $reverse_adr, $my_zone_kind, $cf_setting) = @_;
    my @comzone_string, @new_str;

    my $rev_adr;
    if ($PLATFORM_FLG eq 'UA' ) { 
        $rev_adr = substr($reverse_adr->{'ROUTER-PREFIX-ADDRESS'}, -23, 23);
    } else {
        $rev_adr = substr($reverse_adr->{'target,prefix'}, -23, 23);
    }

    #--- named.conf -----------
    my $current_time = localtime(time);
    if (index($my_filename, 'named.conf') != -1 ) {

        $new_str = qq/\/\/ Tester setting [Created at $current_time] ##############################\n/.
                   qq/options {\n/.
                   qq/        directory       "\/etc\/namedb";\n/.
                   qq/        pid-file        "\/var\/run\/named\/pid";\n/.
                   qq/        dump-file       "\/var\/dump\/named_dump.db";\n/.
                   qq/        statistics-file "\/var\/stats\/named.stats";\n/.
                   qq/        allow-query {any;};\n/.
                   qq/        listen-on-v6 {any;};\n/.
                   qq/};\n/;

    $new_str .= qq/\/\/ RFC 3152 \n/.
                    qq/zone "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.IP6.ARPA" {\n/.
                    qq/        type master;\n/.
                    qq/        file "master\/localhost-v6.rev";\n/.
                    qq/};\n/;

        # forward file
        while ( ($key, $value) = each %$my_zone_kind ) {
#        for ($zncnt=0;$zncnt<=$key_count;$zncnt++){
            $new_str .= qq/zone "$key" {\n/.
                        qq/        type master;\n/.
                        qq/        file "$key.zone";\n/.
                        qq/        allow-update {none;};\n/.
                        qq/};\n/;   
        }
        
        #reverse file
#        for ($rvcnt=0;$rvcnt<=$#reverse_adr;$rvcnt++){
            #--- for 'arpa'
            $new_str .= qq/zone "$rev_adr.arpa" {\n/.  
                        qq/        type master;\n/.
                        qq/        file "$rev_adr.ip6";\n/.
                        qq/};\n/;   
            #--- for 'int'
            $new_str .=  qq/zone "$rev_adr.int" {\n/.  
                        qq/        type master;\n/.
                        qq/        file "$rev_adr.ip6";\n/.
                        qq/};\n/;   
#        }
        
    }

    #--- com.zone -----------
    elsif (index($my_filename, '.zone') != -1 ) {

        # Add strings to *.zone

        $comzone_string = Add_ZONE_address($cf_setting);
        if (length($comzone_string) < 1) {exit;}

        $new_str = qq/; Tester setting [Created at $current_time] ##########################\n/.
                   qq/\$TTL  86400 \n\n/.
                   qq/@      IN      SOA     dns.test.com. root.dns.test.com.(\n\n/.
                   qq/       42      ; serial (d. adams)   \n\n/.
                   qq/       3H      ; refresh             \n\n/.
                   qq/       15M     ; retry               \n\n/.
                   qq/       1W      ; expiry              \n\n/.
                   qq/       1D )    ; minimum             \n\n/.
                   qq/       IN      NS      dns.test.com. \n\n/.
                   qq/$comzone_string \n/;

#print "3. [$new_str]\n";
    }

    #--- reverse file -----------
    elsif (index($my_filename, '.ip6') != -1 ) {

        my $x, $idx, $rev_string, $rev_adr;

        $common_rev = ".".$rev_adr;
        
        if ($PLATFORM_FLG eq 'UA' ) { 

                $wk = $reverse_adr->{'DNS_ADDRESS'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string = "$1\t\tIN\tPTR\tdns.test.com\n\n";

                $wk = $reverse_adr->{'REG-ADDRESS'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'REG-HOSTNAME'}\n\n";
            
                $wk = $reverse_adr->{'PX1-ADDRESS'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'PX1-HOSTNAME'}\n\n";

                $wk = $reverse_adr->{'PX2-ADDRESS'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'PX2-HOSTNAME'}\n\n";

                $wk = $reverse_adr->{'PUA-ADDRESS'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'PUA-CONTACT-HOSTNAME'}\n\n";
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'PUA-CONTACT-HOSTNAME-FOR-1PX'}\n\n";

        } else {
                $wk = $reverse_adr->{'dns,address'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string = "$1\t\tIN\tPTR\tdns.test.com\n\n";

                $wk = $reverse_adr->{'target.user1,address'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'target.user1,contact-uri'}\n\n";
            
                $wk = $reverse_adr->{'target.user2,address'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'target.user2,contact-uri'}\n\n";
            
                $wk = $reverse_adr->{'target.user3,address'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'target.user3,contact-uri'}\n\n";
            
                $wk = $reverse_adr->{'target.user4,address'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'target.user4,contact-uri'}\n\n";
            
                $wk = $reverse_adr->{'proxy,address'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'proxy,uri'}\n\n";

                $wk = $reverse_adr->{'proxy2,address'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'proxy,uri'}\n\n";
            
                $wk = $reverse_adr->{'proxy.user1,address'};
                $wk =~ /^(.*)$common_rev$/;
                $rev_string .= "$1\t\tIN\tPTR\t$cf_setting->{'proxy.user1,contact-uri'}\n\n";
            
         }
        
        $new_str = qq/; Tester setting [Created at $current_time] #########################\n/.
                   qq/\$TTL  86400 \n\n/.
                   qq/@      IN      SOA     dns.test.com. root.dns.test.com.(\n\n/.
                   qq/       42      ; serial (d. adams)   \n\n/.
                   qq/       3H      ; refresh             \n\n/.
                   qq/       15M     ; retry               \n\n/.
                   qq/       1W      ; expiry              \n\n/.
                   qq/       1D )    ; minimum             \n\n/.
                   qq/       IN      NS      test.com.    \n\n/.
                   qq/$rev_string \n/;
    }
    else {
    
    }
       
#print "string [\n$new_str\n]\n";
    return $new_str;

}

#===========================================================
# sub Make_ReverseAddress Arg:([0]:forward address)
#===========================================================
sub Make_ReverseAddress {

#    $_ = '3ffe:501::1';
    my ($fwd_address) = @_;
    my $rev_adr;
    
    $_ = $fwd_address;
    
    # change value to 4-bit value(0000:0000:0000)
    $prefix_adr='';

    $abbr_pos =index($fwd_address, '::');
    if ( $abbr_pos != -1 ){

        if ($abbr_pos != rindex($fwd_address, '::')) {
            print "ERROR:A wrong address is in config.txt\n";
            exit;
        }
     
        $cln_cnt = tr/:/:/;
        if ($cln_cnt > 7){
            print "ERROR:A wrong address is in config.txt\n";
        }
        elsif ($cln_cnt < 7){
            $cln_str = ":0000" x (7-$cln_cnt+1);
            $cln_str = $cln_str.":";
#print "$fwd_address: cnt [$cln_cnt] str[$cln_str] \n";
            $fwd_address =~ s/::/$cln_str/;
        }
    }

    @suffix = split(/:/, $fwd_address);

    for ($i=0;$i<=$#suffix;$i++){
        $suffix[$i] = substr("0000$suffix[$i]",-4);
    }

#    $wk= $suffix[0].$suffix[1].$suffix[2];
    $wk= $suffix[0].$suffix[1].$suffix[2].$suffix[3].$suffix[4].$suffix[5].$suffix[6].$suffix[7];
    for ($itm=(length($wk)-1);$itm>=0;$itm--){
        if (length($rev_adr) < 1) {
            $rev_adr = substr($wk, $itm, 1);
        } else {
            $rev_adr .= ".".substr($wk, $itm, 1);
        }
    }

#    $rev_adr .= ".ip6";        # reverse address
    return $rev_adr;
}

#===========================================================
# sub CREATE_file Arg:([0]:filename, [1]:strings)
#===========================================================
sub CREATE_file {

    my ($my_filename, @my_text) = @_;
#print "IN create [@my_text] \n";
    if( ! open(OUT, "> ".$my_filename ) ){ return "open error";}
    print OUT @my_text; 
    close(OUT);
    
    return "OK";
}


#===========================================================
# sub ChkZONE_domain_PX Arg:([0]:%config_setting)
#===========================================================
sub ChkZONE_domain {

    my ($cf_setting) = @_;
    my %zone_kind, $prefix_adr;
    
    if ($PLATFORM_FLG eq 'UA') {
        $prefix_adr = $cf_setting->{'ROUTER-PREFIX-ADDRESS'};
    }else {
        $prefix_adr = $cf_setting->{'target,prefix'};
    }

    while ( ($key, $value) = each %$cf_setting) {
    
        if ($PLATFORM_FLG eq 'UA') {
            if (index($key, 'HOSTNAME') == -1 ) { next;}
        }else {
            if (($key ne 'target.user1,contact-uri') and ($key ne 'target.user2,contact-uri') and 
                ($key ne 'target.user3,contact-uri') and ($key ne 'target.user4,contact-uri') and 
                ($key ne 'proxy,uri') and ($key ne 'proxy.user1,contact-uri')
		and ($key ne 'proxy2.uri')
 ) { next;}
        }
        $rpos = rindex($value, '.');
        if ($rpos == -1 ) {
            print "ERROR : [$key] is incorrect.\n";
            return;
        }
        $rpos = $rpos + 1;
        $wk_zone = substr($value, $rpos, (length($value)-$rpos));
        
        if ($#zone_kind < 0 ) { 
            $zone_kind{$wk_zone} = $prefix_adr;
        }
        else{
            $update_flg = 0;
            for ($upcnt=0;$upcnt<=$#zone_kind;$upcnt++){
                if ($zone_kind[$upcnt] eq $wk_zone){
                    $update_flg = -1;
                    last;
                }
            }
            if ($update_flg != -1) { 
#                $zone_kind{$wk_zone} = $value;
                $zone_kind{$wk_zone} = $prefix_adr;
            }
            #@zone_kind = (@zone_kind, $wk_zone);}
        }
    }

    #--- spec for Ready Logo: ONLY '.com' is available.-----------------------------
    $keycount = keys %zone_kind;
    @kys = keys %zone_kind;
    if ($keycount != 1) {
        print "ERROR : All domain name should be finished with '.com'\n";
        return;
    }
    if ($kys[0] != 'com') {
        print "ERROR : All domain name should be finished with '.com'\n";
        return;
    }
    #-------------------------------------------------------------------------------
    
    return %zone_kind;
    
}

#===========================================================
# sub Add_ZONE_address Arg:([0]:%config_setting)
#===========================================================
sub Add_ZONE_address{
    my ($cf_setting) = @_;
    my $string_comzone, $NAPTR_str, $px1, $px2, $PX1_adr, $PX2_adr;

     $dig_chk = ();    # Initialization
    # Add strings to *.zone
    if ($PLATFORM_FLG eq 'UA' ) { 
        $string_comzone = "dns.test.com.\t\tIN\tAAAA\t$cf_setting->{'DNS_ADDRESS'}\n\n".
                          "$cf_setting->{'REG-HOSTNAME'}.\t\tIN\tAAAA\t$cf_setting->{'REG-ADDRESS'}\n\n".
                          "$cf_setting->{'PX1-HOSTNAME'}.\t\tIN\tAAAA\t$cf_setting->{'PX1-ADDRESS'}\n\n".
                          "$cf_setting->{'PX2-HOSTNAME'}.\t\tIN\tAAAA\t$cf_setting->{'PX2-ADDRESS'}\n\n".
                          "$cf_setting->{'PUA-CONTACT-HOSTNAME'}.\t\tIN\tAAAA\t$cf_setting->{'PUA-ADDRESS'}\n\n".
                          "$cf_setting->{'PUA-CONTACT-HOSTNAME-FOR-1PX'}.\t\tIN\tAAAA\t$cf_setting->{'PUA-ADDRESS'}\n\n";

        if (index($cf_setting->{'PX1-HOSTNAME'}, ".") == -1){
            print "ERROR: Failed to edit value from PX1-HOSTNAME.($cf_setting->{'PX1-HOSTNAME'})\n";
            return ;
        }
        my $st_posi = (index($cf_setting->{'PX1-HOSTNAME'}, ".") + 1);
    
        $px1 = substr($cf_setting->{'PX1-HOSTNAME'}, $st_posi, (length($cf_setting->{'PX1-HOSTNAME'}) - $st_posi));
        $PX1_adr = $cf_setting->{'PX1-HOSTNAME'};
    
        $st_posi = (index($cf_setting->{'PX2-HOSTNAME'}, ".") + 1);
        $px2 = substr($cf_setting->{'PX2-HOSTNAME'}, $st_posi, (length($cf_setting->{'PX2-HOSTNAME'}) - $st_posi));
        $PX2_adr = $cf_setting->{'PX2-HOSTNAME'};

        $string_comzone .= qq/$px1. IN NAPTR 50 50 "s" "SIP+D2U" "" _sip._udp.$px1.\n/.
                           qq/_sip._udp.$px1. IN SRV 0 1 5060 $PX1_adr.\n/.
                           qq/$px2. IN NAPTR 50 50 "s" "SIP+D2U" "" _sip._udp.$px2.\n/.
                           qq/_sip._udp.$px2. IN SRV 0 1 5060 $PX2_adr.\n/;

        # for checking with 'dig' --- added  
        $dig_chk[0][0] = 'dns.test.com';
        $dig_chk[1][0] = $cf_setting->{'REG-HOSTNAME'};
        $dig_chk[2][0] = $cf_setting->{'PX1-HOSTNAME'};
        $dig_chk[3][0] = $cf_setting->{'PX2-HOSTNAME'};
        $dig_chk[4][0] = $cf_setting->{'PUA-CONTACT-HOSTNAME'};
        $dig_chk[5][0] = $cf_setting->{'PUA-CONTACT-HOSTNAME-FOR-1PX'};

        $dig_chk[0][1] = 'AAAA';
        $dig_chk[1][1] = 'AAAA';
        $dig_chk[2][1] = 'AAAA';
        $dig_chk[3][1] = 'AAAA';
        $dig_chk[4][1] = 'AAAA';
        $dig_chk[5][1] = 'AAAA';

        $dig_chk[6][0] = $px1;             $dig_chk[6][1] = 'NAPTR';
        $dig_chk[7][0] = "_sip._udp.".$px1; $dig_chk[7][1] = 'SRV';
        $dig_chk[8][0] = $px2;             $dig_chk[8][1] = 'NAPTR';
        $dig_chk[9][0] = "_sip._udp.".$px2; $dig_chk[9][1] = 'SRV';
    }
    #--- server ----- 
    else {
        $string_comzone = "dns.test.com.\t\tIN\tAAAA\t$cf_setting->{'dns,address'}\n\n".
                          "$cf_setting->{'target.user1,contact-uri'}.\t\tIN\tAAAA\t$cf_setting->{'target.user1,address'}\n\n".
                          "$cf_setting->{'target.user2,contact-uri'}.\t\tIN\tAAAA\t$cf_setting->{'target.user2,address'}\n\n".
                          "$cf_setting->{'target.user3,contact-uri'}.\t\tIN\tAAAA\t$cf_setting->{'target.user3,address'}\n\n".
                          "$cf_setting->{'target.user4,contact-uri'}.\t\tIN\tAAAA\t$cf_setting->{'target.user4,address'}\n\n".
                          "$cf_setting->{'proxy,uri'}.\t\tIN\tAAAA\t$cf_setting->{'proxy,address'}\n\n".
                          "$cf_setting->{'proxy.user1,contact-uri'}.\t\tIN\tAAAA\t$cf_setting->{'proxy.user1,address'}\n\n";
        if (index($cf_setting->{'proxy,uri'}, ".") == -1){
            print "ERROR: Failed to edit value from '[proxy] uri'.($cf_setting->{'proxy,uri'})\n";
            return ;
        }
        my $st_posi = (index($cf_setting->{'proxy,uri'}, ".") + 1);
    
        $px1 = substr($cf_setting->{'proxy,uri'}, $st_posi, (length($cf_setting->{'proxy,uri'}) - $st_posi));
        $PX1_adr = $cf_setting->{'proxy,uri'};
    
        $string_comzone .= qq/$px1. IN NAPTR 50 50 "s" "SIP+D2U" "" _sip._udp.$px1.\n/.
                           qq/_sip._udp.$px1. IN SRV 0 1 5060 $PX1_adr.\n/;


        # for checking with 'dig' --- added  
        $dig_chk[0][0] = 'dns.test.com';
        $dig_chk[1][0] = $cf_setting->{'target.user1,contact-uri'};
        $dig_chk[2][0] = $cf_setting->{'target.user2,contact-uri'};
        $dig_chk[3][0] = $cf_setting->{'target.user3,contact-uri'};
        $dig_chk[4][0] = $cf_setting->{'target.user4,contact-uri'};
        $dig_chk[5][0] = $cf_setting->{'proxy,uri'};
        $dig_chk[6][0] = $cf_setting->{'proxy.user1,contact-uri'};

        $dig_chk[0][1] = 'AAAA';
        $dig_chk[1][1] = 'AAAA';
        $dig_chk[2][1] = 'AAAA';
        $dig_chk[3][1] = 'AAAA';
        $dig_chk[4][1] = 'AAAA';
        $dig_chk[5][1] = 'AAAA';
        $dig_chk[6][1] = 'AAAA';

        $dig_chk[7][0] = $px1;        $dig_chk[7][1] = 'NAPTR';
        $dig_chk[8][0] = "_sip._udp.".$px1;    $dig_chk[8][1] = 'SRV';
    }
    return $string_comzone;
        
}


#===========================================================
# sub GetProcessResult Arg:([0]:command)
#===========================================================
sub GetProcessResult {
    my($command,$stderr,$timeout)=@_;
    my($result,$pipe);
    local($status);

    $timeout = $timeout || 5;
    eval{
	local $SIG{'ALRM'}= sub {$status='TIME-OUT';die};
	alarm( $timeout );
	eval {
#	    if(CtLgLevel('INIT')){printf("INIT: cmd [%s] => ",$command);}
#	    $result = `$command`;
	    $pipe = $stderr ? ' 2>&1 |' : ' |' ;
	    unless( open(STATUS,  $command . $pipe) ){
		printf("Error:cannot exec [%s]\n",$command);
		return ;
	    }
	    while (<STATUS>){$result .= $_;}
	    close(STATUS);
#	    if(CtLgLevel('INIT')){printf("[%s]\n",substr($result,0,20));}
	};
	alarm(0);
    };
    alarm(0);
    if($status || $@){
	$status = $status ? $status :(ref($@) ? 'TIME-OUT' : $@);
    }
    return $result,$status;
}
sub KillProcess {
    my($procname,$signal)=@_;
    my($pids,$pid);
    $signal=9 unless($signal);
    $pids=GetPID($procname);
    foreach $pid (@$pids){UtShell("kill -$signal $pid")}
}
sub GetPID {
    my($procname)=@_;
    my($ans,@matchs,$line,@pid);
    $ans=UtShell("ps ax",20);

    if( @matchs = $ans =~ /^(.+$procname.*)$/mg ){
	foreach $line (@matchs){
##	    printf("match pid [$line]\n");
	    $line =~ /([0-9]+)/;
	    push(@pid,$1);
	}
	return \@pid;
    }
    return;
}
sub UtShell {
    my($command,$timeout)=@_;
    my($result,$count,$state);
    local($SIG{'CHLD'});
    $SIG{'CHLD'}='';
    printf("  %s\n",$command);
    ($result,$state)=GetProcessResult($command,'T',$timeout);
    while($state && $count<3){
	($result,$state)=GetProcessResult($command,'T',$timeout);
    }
    if(3<=$count){
	printf("ERROR:Can't do cmd[%s] %s\n",$command,$state );
    }
    return $result;
}
#===========================================================
# sub Get_Line Arg([0]:file name, [1]:keyword)
#===========================================================
sub Get_Line {
    my($my_filename, $my_keyword) = @_;
    my @Link0_lines;
    if (! -e $my_filename ){
        print "$key: Not exist [$my_filename]\n";
        return ;
    }
    
    # Open a file

    open(IN, $my_filename ) || die "Error: $my_filename $!\n";
    my @def_data = <IN>;        #Read lines
    close(IN);

    # search "Link0"
    foreach (@def_data){
        
        my @suffix = ();
        @suffix = split(/\s+/, $_);
        if ($#suffix < 1) { next; }
        if ($suffix[0] ne $my_keyword){ next;}
    
    # Link 0 line
        chomp ($_);
        @Link0_lines = (@Link0_lines,$_);
    }
    return @Link0_lines;
}

#===========================================================
# sub GetIFIPv6 Arg([0]:inferface name)
#===========================================================    
sub GetIFIPv6 {
    my($inf)=@_;
    my(@ip,$result);

    ($result)=GetProcessResult("ifconfig $inf");
    if( @ip=$result =~ /^\s+inet6 ([0-9a-fA-F:]+)/gm ){

    return \@ip;
    }
    return '';
}

#========================================================s
# sub GenerateIPv6FromMac Arg([0]:MAC address, [1]:prefix)
#===========================================================    
sub GenerateIPv6FromMac {
    my ($mac,$prefix) = @_;
    my (@hex,@oct,$first,$colon);
    $colon=$prefix; $colon =~ s/[^:]//g;
    if(4<length($colon)){$prefix=substr($prefix,0,length($prefix)-1);}
    @hex=split(/:/,$mac);
    @oct=map(hex,@hex);
    $first=shift @oct; $first=($first & 0x02) ? ($first & 0xfd):($first | 2);
    return sprintf("%s%02x%02x:%02xff:fe%02x:%02x%02x", $prefix,$first,shift @oct,shift @oct,@oct);
#   return sprintf("%s%02x%02x:%02xff:fe%02x:%02x%02x", $prefix,(shift @oct)|0x02,shift @oct,shift @oct,@oct);
}


