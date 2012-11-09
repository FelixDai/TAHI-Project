#!/usr/bin/perl

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

use Config;
use CText;
unless($BYTECode){require PfTbl;}

# 
# 09/6/12 LoadProtectFile
# 09/4/16 config.txt
# 09/4/16 RTADVD
# 09/3/24 log 
# 09/2/ 3 config.txt
# 09/1/28 
# 08/8/19 koid 
# 08/4/07 IPv4
#  

#  ifconfig eth0 inet6 9001::1/64 remove
#  route delete -inet6 9001::1
#  route add    -inet6 default 9001::100

# 
#   P-CSCF
#   UE

# 
%RequireModule=('CText::PfSv'=>'','CText::PfTbl'=>'','CText::PfPkt'=>'');
%RequireModuleLocal=('PfSv'=>'','PfTbl'=>'','PfPkt'=>'');
%UseModule=('Inline'=>'','CText'=>'','Time::HiRes'=>'','IO::Socket'=>'','Digest::MD5'=>'','XML::TreePP'=>'',
	    'Digest::HMAC_SHA1'=>'','Digest::HMAC_MD5'=>'','Crypt::CBC'=>'', 'Crypt::OpenSSL::AES'=>'');

# 
$V6EVALnut='/usr/local/v6eval/etc/nut.def';
$V6EVALtn ='/usr/local/v6eval/etc/tn.def';
$KOInut   ='/usr/local/koi/etc/nut.def';
$KOItn    ='/usr/local/koi/etc/tn.def';
$KOIbin   ='/usr/local/koi/bin/koid';
$ConfigTxt='config.txt';

%CFGRequiredParams=('DNS'=>['address','prefixlen'],
		    'UEa1'=>['address','prefixlen'],
		    'P-CSCFa1'=>['address','prefixlen'],
		    'PF'=>['Router_Address','protocol'],
		   );
# 
%SETUPparam;
@SetupMsg;
$SetupMsg;

# 
CTSetup();

# 
sub SetupMsg {
    my($type,$frm,@args)=@_;
    $SetupMsg = 'ERR' if($type =~ /ERR/);
    push(@SetupMsg,sprintf('%3.3s|'.$frm, $type,@args));
}

# 
sub ShowMsg {
    my($msg);
    printf("\n===================================================\n");
    if(-1<$#SetupMsg){
        foreach $msg (@SetupMsg){
            printf(' '.$msg);
        }
    }
    printf("\n");
    printf($SetupMsg ? " Setup error. check ERR status\n" : " All setup completed.\n");
    printf("===================================================\n");
}

sub InputMsg {
    my($msg)=@_;
    my($lp_cnt,$ans);

    if($SETUPparam{'gui'}){return "y\n"}

    while ($lp_cnt <= 2) {
        if ($lp_cnt == 0) {print $msg}
        my $ans = <STDIN>;
        if ($ans eq "y\n") {
            last;
        }
        elsif ($ans eq "n\n") {
            exit;
        }
        print "Please input 'y' or 'n'. >";
        $lp_cnt++;
    }
    return $ans;
}
# 
sub ExitSetupTrap {
    $SIG{'INT'}=$SIG{'KILL'}=$SIG{'TERM'}=$SIG{'QUIT'}=$SIG{'HUP'}='';
    ShowMsg();
    exit;
}

# 
sub CTSetup {
    my($intf,$ad,$step,$arg,$key,$val,$target,$rastart);

    $ExitSignalTrapFlag='T';
    $SIG{'INT'}=$SIG{'KILL'}=$SIG{'TERM'}=$SIG{'QUIT'}=$SIG{'HUP'}='ExitSetupTrap';

    # 
    if($BYTECode){ProductCheck()}

    # 
    foreach $arg (@ARGV){
	if($arg =~ /(\S+)=(\S+)/){
	    $key=$1;
	    $val=$2;
	    $SETUPparam{$key}=$val;
	}
    }

    # 
    printf("### Check install modules ...\n");
    InstallCheck();

    # 
    if(-e 'log'){
	unless(-d 'log'){
	    printf("### log file exist. so can't create html output directory [./log]\n");
	    exit;
	}
    }
    else{
	printf("### create html output directory [./log]\n");
	$ret=CtUtShell("mkdir log");
    }

    $step=$SETUPparam{'step'};
    $ConfigTxt = $SETUPparam{'cfg'} || $ConfigTxt;
    unless(-e $ConfigTxt){
	printf("### config file [$ConfigTxt] no exist\n");
	exit;
    }

    # 
    printf("### Interface info getting ...\n");
    $ad=GetIFTbl();
    $ad->{'DRoute'} = GetDRTbl();
    CtTbCtiSet('SC,IF',$ad,'T');

    # 
    printf("### tn.def/nut.def $ConfigTxt loading ...\n");
    $intf = ConfigSetup();
    if($step =~ /check/){ShowMsg();exit;}

    # 
##    if($SetupMsg){ExitSetupTrap();}
    printf("### interface(%s) address setting ...\n",$intf);
    $target=InterfaceSetup($intf);
    printf("### target node (%s)\n",$target);
    if($step =~ /ip/){ShowMsg();exit;}

    # DNS
    printf("### DNS setup and starting ...\n");
    DNSSetup($intf);

    # RTADVD
    if( CtTbCfg('PF','ipautoconfig') =~ /ra/i ){
	# DHCP
	StopDHCPD();
	printf("### RA setup and starting ...\n");
	# 
	unless(IsMacAddress(CtTbCfg($target,'address'))){
	    SetupMsg('ERR',"If select ra(ipautoconfig),target node(%s) address must be specified mac address.",$target );
	}
	$rastart=RTADVDSetup($intf);
    }

    # DHCPD
    if( !CtTbCfg('PF','ipautoconfig') || CtTbCfg('PF','ipautoconfig') =~ /dhcp/i ){
	# RA
	StopRTADVD();
	printf("### DHCP setup and starting ...\n");
	DHCPDSetup($intf);
    }
    if( CtTbCfg('PF','ipautoconfig') =~ /manual/i ){
	# RA
	StopRTADVD();
	# DHCP
	StopDHCPD();
    }

    # if($rastart){CtUtShell('ping6 -c 2 '.MacToIP6(CtTbCfg($target,'address')))}

    # 
    ShowMsg();
}

# 
sub InstallCheck {
    my(@errpkg,@loadpkg,$version,$name,$ret,$module);

    # Perl
    $version=eval(q{$Config{'version'}});
    $version =~ s/\.//g;
    if($version < 587){
	SetupMsg('ERR',"This Perl version done not fit for CT. ver[%s]<5.7.8\n",$Config{'version'});
    }
    # use package 
    foreach $name (keys(%UseModule)){
	printf("  check module %s ",$name);
	eval("use $name");
	if($@){
	    push(@errpkg,$name);
	    printf("NG\n");
	}
	else{
	    push(@loadpkg,$name);
	    printf("OK\n");
	}
    }
    # require module 
    unless($BYTECode){
	$module =  $SETUPparam{'ct'} ? \%RequireModuleLocal : \%RequireModule ;
	
	foreach $name (keys(%$module)){
	    printf("  check module %s ",$name);
	    eval("require $name");
	    if($@){
		push(@errpkg,$name);
		printf("NG\n");
	    }
	    else{
		push(@loadpkg,$name);
		printf("OK\n");
	    }
	}
	if(-1<$#errpkg){
	    SetupMsg('ERR',"Packages [@errpkg] not installed\n");
	    ExitSetupTrap();
	}
    }
    $ExitSignalTrapFlag='T';
    $SIG{'INT'}=$SIG{'KILL'}=$SIG{'TERM'}=$SIG{'QUIT'}=$SIG{'HUP'}='ExitSetupTrap';
    CtTbInit();
    SetupMsg('OK',"Packages [@loadpkg] load OK\n");
##    push(@IKLogLevel,'INIT');

    # v6eval 
    printf("  check module V6evalTool ");
    unless(-e 'packet.def'){
	SetupMsg('ERR',"packet.def no exist\n");
    }
    eval("use V6evalTool");
    if($@){
	SetupMsg('ERR',"V6evalTool can't loaded.no installed or invalid nut.def/tn.def\n");
	printf("NG\n");
    }
    else{
	printf("OK\n");
    }

    # koi 
    printf("  check module koid ");
    unless(-e $KOInut){
	SetupMsg('ERR',"$KOInut no exist\n");
    }
    unless(-e $KOItn){
	SetupMsg('ERR',"$KOItn no exist\n");
    }
    eval("push(\@INC,'/usr/local/koi/libdata');require kCommon");
    if($@){
	SetupMsg('ERR',"KOI can't loaded.no installed or invalid nut.def/tn.def\n");
	printf("NG\n");
    }
    if(!(-e $KOIbin)){
	SetupMsg('ERR',"koid not installed\n");
	printf("NG\n");
    }
    else{
	$ret=CtUtShell("which koid");
	if($ret !~ /koid/){
	    printf("!!! please set execute path [/usr/local/koi/bin]\n");
	}
	printf("OK\n");
    }

    # IPsec 
    printf("  check kernel ipsec support ");
    $ret=CtUtShell("sysctl -a | grep ipsec",15);
    if($ret =~ /net\.inet\.ipsec/ && $ret =~ /net\.inet6\.ipsec6/){
	SetupMsg('OK',"Kernel IPsec supported\n");
	printf("OK\n");
    }
    else{
	SetupMsg('ERR',"Kernel IPsec not supported\n");
	printf("NG\n");
    }

    # NULL 
    printf("  check setkey null algorithm ");
    CtUtShell("setkey -F;setkey -PF");
    $ret=CtUtShell("echo 'add 5001::2 5001::1 esp 12345 -m transport -u 3 -E null -A hmac-md5 0x00000000000000000000000000000000;'|setkey -c");
    if($ret){
	SetupMsg('WAR',"Setkey not supported null algorithm\n");
	printf("NG\n");
    }
    else{
	SetupMsg('OK',"Setkey support null algorithm\n");
	printf("OK\n");
    }
    CtUtShell("setkey -F;setkey -PF");
    
    # DHCPD 
    printf("  check dhcpd installed ");
    $ret=CtUtShell("which dhcpd");

    if($ret !~ /dhcpd/){
	SetupMsg('ERR',"dhcpd not installed or execute path invalid\n");
	printf("NG\n");
    }
    else{
	printf("OK\n");
    }
}

# 
sub ConfigSetup {
    my($intf,$class,$field);

    # V6evalTool tn.def / nut.def 
    $intf=Loadv6evalDef();

    # KOI tn.def / nut.def 
    LoadkoiDef($intf);

    # config.txt 
    LoadCfg();

    # 
    foreach $class (keys(%CFGRequiredParams)){
	foreach $field (@{$CFGRequiredParams{$class}}){
	    unless( CtTbCfg($class,$field) ){
		SetupMsg('ERR',"config [%s]:[%s] empty\n",$class,$field);
	    }
	}
    }

    return $intf;
}

# 
sub InterfaceSetup {
    my($intf)=@_;
    my($tmp,$node,$nodes,$ip,$prefix,$prot,$autoRouter,@vals,$target);
    
    # 
    $prot = uc(CtTbCfg('PF','protocol'));

    # 
    $target=$SETUPparam{'target'};

    # 
    if( $nodes=$SETUPparam{'node'} ){
	@vals=split(/,/,$nodes);
	$nodes=\@vals;
	$target='P-CSCFa1' unless($target);
    }
    else{
	# 
	$nodes=['P-CSCFa1','P-CSCFa2','DNS'];
	$target='UEa1' unless($target);
    }

    foreach $node (@$nodes){
	# MAC
	$ip=MacToIP6(CtTbCfg($node,'address'));
	$prefix=CtTbCfg($node,'prefixlen');

	if($prot eq 'INET6' && (!$ip || CtUtIPAdType($ip) ne 'ip6')){
	    SetupMsg('ERR',"config [%s]:address(%s) invalid\n",$node,$ip);
	}
	elsif($prot eq 'INET' && (!$ip || CtUtIPAdType($ip) ne 'ip4')){
	    SetupMsg('ERR',"config [%s]:address(%s) invalid\n",$node,$ip);
	}
	elsif(!$prefix){
	    SetupMsg('ERR',"config [%s]:prefixlen(%s) invalid\n",$node,$prefix);
	}
	else{
	    # 
	    SetIntAD($intf,$prot,$ip,$prefix);
	}
    }

    # 
    $autoRouter = CtTbCfg('PF','Auto_Router_Address');
    # 
    $ip = CtTbCfg('PF','Router_Address');
    # 
    $prefix = CtTbCfg('PF','Router_Prefix');

    # 
    $tmp = CtTbCfg('PF','interface');
    if($tmp && $tmp ne $intf){
	SetupMsg('WAR',"tn.def Link0(%s) not eqaul config [CI]:interface(%s)\n",$intf,$tmp);
    }

    # 
    if ( $autoRouter =~ /^(ON|YES)$/i )  {
	if($prot eq 'INET6' && (!$ip || CtUtIPAdType($ip) ne 'ip6')){
	    SetupMsg('ERR',"config [CI]:Router_Address(%s) v6 invalid\n",$ip);
	}
	elsif($prot eq 'INET' && (!$ip || CtUtIPAdType($ip) ne 'ip4')){
	    SetupMsg('ERR',"config [CI]:Router_Address(%s) v4 invalid\n",$ip);
	}
	elsif(!$prefix){
	    SetupMsg('ERR',"config [CI]:Router_Prefix(%s) invalid\n",$prefix);
	}
	else{
	    # 
	    SetIntAD($intf,$prot,$ip,$prefix);
	}
    }

    # 
    #   RA
    if( (CtTbCfg('PF','ipautoconfig') =~ /ra/i) || ($ip = CtTbCfg('PF','gateway')) ){
	if( CtTbCfg('PF','ipautoconfig') =~ /ra/i  ){
	    if($prot ne 'INET6'){
		SetupMsg('ERR',"ipautoconfig set ra, but protocol [%s]\n",$prot);
	    }
	    elsif( !IsMacAddress(CtTbCfg($target,'address')) ){
		SetupMsg('ERR',"ipautoconfig set ra, but $target address not mac\n");
	    }
	    else{
		$ip=MacToIP6(CtTbCfg($target,'address'));
	    }
	}
	if($prot eq 'INET6' && CtUtIPAdType($ip) ne 'ip6'){
	    SetupMsg('ERR',"config [CI]:Router_Address(%s) invalid\n",$ip);
	}
	elsif($prot eq 'INET' && CtUtIPAdType($ip) ne 'ip4'){
	    SetupMsg('ERR',"config [CI]:Router_Address(%s) invalid\n",$ip);
	}
	else{
	    SetIntDR($intf,$prot,$ip);
	}
    }
    return $target;
}

# DHCP
sub DHCPDSetup {
    my($intf)=@_;
    my($domainName,$dnsAddr,$sipName,$pcscfAdd,$ueAdd,$uePrefix,$netAddr,$confText,$leaseTime,$mode);

    $mode = (uc(CtTbCfg('PF','protocol')) eq 'INET') ? 'ip4' : 'ip6';
    if(-e '/var/db/dhcpd.leases'){
	CtUtShell("rm -f /var/db/dhcpd.leases");
    }
    if(-e '/var/db/dhcpd6.leases'){
	CtUtShell("rm -f /var/db/dhcpd6.leases");
    }
    CtUtShell("touch /var/db/dhcpd6.leases");
    CtUtShell("touch /var/db/dhcpd.leases");
    SetupMsg('OK',"/var/db/dhcpd6.leases dhcpd.leases created\n");

    # /etc/dhcpf.conf 
    unless($domainName = CtTbCfg('P-CSCFa1','domain')){SetupMsg('ERR',"config [P-CSCFa1]:domainkoid empty\n");}
    unless($dnsAddr    = MacToIP6(CtTbCfg('DNS','address'))){SetupMsg('ERR',"config [NDS]:address empty\n");}
    unless($sipName    = CtTbCfg('P-CSCFa1','hostname')){SetupMsg('ERR',"config [P-CSCFa1]:hostname empty\n");}
    unless($pcscfAdd   = MacToIP6(CtTbCfg('P-CSCFa1','address'))){SetupMsg('ERR',"config [P-CSCFa1]:address empty\n");}
    unless($ueAdd      = MacToIP6(CtTbCfg('UEa1','address'))){SetupMsg('ERR',"config [UEa1]:address empty\n");}
    unless($uePrefix   = CtTbCfg('UEa1','prefixlen')){SetupMsg('ERR',"config [UEa1]:prefixlen empty\n");}
    # 
    if(IsIPV4Address($ueAdd)){
	my($tmp);
	($netAddr,$uePrefix)  = CtUtV4MkToAddr($ueAdd, $uePrefix);
    }
    else{
	($netAddr)  = CtUtV6WtMkToVal($ueAdd.'/'.$uePrefix);
    }
    unless($domainName && $dnsAddr && $sipName && $pcscfAdd && $ueAdd && $uePrefix && $netAddr){ExitSetupTrap()}
    $leaseTime=CtTbCfg('DHCP','lease-time') || 10*60;
    
    # 
    StopDHCPD();

$confText = <<"EOS";
# dhcpd.conf
default-lease-time $leaseTime;
max-lease-time 3600;

option dhcp6.domain-search "$domainName";
option dhcp6.name-servers $dnsAddr;
option dhcp6.sip-servers-names "$sipName";
option dhcp6.sip-servers-addresses $pcscfAdd;

subnet6 $netAddr/$uePrefix {
	range6 $ueAdd $ueAdd;
	allow unknown-clients;
}

EOS
;

$confText4 = <<"EOS4";
# dhcpd.conf
default-lease-time $leaseTime;
max-lease-time 3600;

option domain-name "$domainName";
option domain-name-servers $dnsAddr;
# option sip-servers-names "$sipName";
# option sip-servers-addresses $pcscfAdd;

subnet $netAddr netmask $uePrefix {
	range $ueAdd $ueAdd;
	allow unknown-clients;
}

EOS4
;
    open(FP, ">/etc/dhcpd.conf");
    print FP ($mode eq 'ip4' ? $confText4 : $confText);
    close(FP);
    
    # 
    unless(StartDHCPD($intf,$mode)){
	SetupMsg('OK',"start DHCPD for $mode\n");
    }
}

# DHCPD 
sub StartDHCPD {
    my($intf,$mode)=@_;
    my($pid,$pids,$ret);
    if($mode eq 'ip4'){
	$ret=CtUtShell("dhcpd -4 $intf");
    }
    else{
	$ret=CtUtShell("dhcpd -6 $intf");
    }
    sleep(1);
    $pids=CtGetPID('dhcpd');
    if($#$pids<0){
	SetupMsg('ERR',"Can't start dhcpd %s\n",$ret);
	return 'NG';
    }
    return;
}

# DHCPD 
sub StopDHCPD {
    my($pid,$pids);
    $pids=CtGetPID('dhcpd');
    foreach $pid (@$pids){
	system("kill -9 $pid");
	sleep(1);
    }
}

# RTADVD
# rtadvd -f -d msk0
#  rc.conf 
sub RTADVDSetup {
    my($intf)=@_;
    my($rtadvd_file,$current_time,$router_adr,$prefix_len,$confText,$forward);

    $forward = CtUtShell("sysctl net.inet6.ip6.forwarding");
#  net.inet6.ip6.forwarding=1
#  net.inet6.ip6.redirect=1
#  net.inet6.ip6.accept_rtadv=0 
#  net.inet6.ip6.auto_linklocal=1
#  net.inet6.icmp6.rediraccept=1
    if($forward !~ /\s+1\s*$/){
	SetupMsg('ERR',"diable IPv6 forwarding, so can't start rtadvd. Add ipv6_enable and ipv6_gateway_enable in rc.conf\n");
	return;
    }

    if(uc(CtTbCfg('PF','protocol')) eq 'INET'){
	SetupMsg('ERR',"[PF] protocol no IPv6, so can't start rtadvd\n");
	return;
    } 
    if( !($router_adr = CtTbCfg('PF','Router_Address')) || IsIPV4Address($router_adr)){
	SetupMsg('ERR',"[FP] Router_Address($router_adr) not IPv6, so can't start rtadvd\n");
	return;
    }

    # 
    StopRTADVD();

    # 
    $prefix_len = CtTbCfg('PF','Router_Prefix')||64;
    $current_time = localtime();
    ($router_adr)=CtUtV6WtMkToVal($router_adr.'/'.$prefix_len);

$confText = <<"EOS";
# Tester setting [Created at $current_time] ##############################
default:\\
        :chlim#64:raflags#0:rltime#9000:rtime#0:retrans#0:\
        :pinfoflags="la":vltime#2592000:pltime#604800:mtu#0:
$intf:\\
        :addr="$router_adr":prefixlen#$prefix_len:tc=default:
EOS
;

    open(FP, ">/etc/rtadvd.conf");
    print FP ($confText);
    close(FP);
    # 
    unless(StartRTADVD($intf)){
	SetupMsg('OK',"start RTADVD\n");
	return 'ok';
    }
    return;
}
# DHCPD 
sub StartRTADVD {
    my($intf)=@_;
    my($pid,$pids,$ret);
    $ret=CtUtShell("rtadvd $intf");
    sleep(1);
    $pids=CtGetPID('rtadvd');
    if($#$pids<0){
	SetupMsg('ERR',"Can't start rtadvd %s\n",$ret);
	return 'NG';
    }
    return;
}
# DHCPD 
sub StopRTADVD {
    my($pid,$pids);
    $pids=CtGetPID('rtadvd');
    foreach $pid (@$pids){
	system("kill -9 $pid");
	sleep(1);
    }
}

# DNS
sub DNSSetup {
    my($intf)=@_;
    my($conf, $zone, $prot);
    my(%domain, %address, %rev_addr);
    my($result_ver, $result_addr, %result_domain, $result_update);
    my($conf_txt, $rev_addr_txt, $rev_title);
    my($named_pid, $rev);
	$conf = "/etc/namedb/named.conf";
	$zone = "/etc/namedb/com.zone";
	$rev  = "/etc/namedb/f.f.f.f.1.0.5.0.e.f.f.3.ip6";

    $prot = uc(CtTbCfg('PF','protocol'));

    my(@UEa2);
	@UEa2 = split(/\@/, CtTbCfg('UEa2', 'contact-host'));

	%domain = ("P-CSCFa1"=>CtTbCfg('P-CSCFa1','hostname'),
			   "P-CSCFa2"=>CtTbCfg('P-CSCFa2','hostname'),
			   "I-CSCFa1"=>CtTbCfg('I-CSCFa1','hostname'),
			   "I-CSCFa2"=>CtTbCfg('I-CSCFa2','hostname'),
			   "S-CSCFa1"=>CtTbCfg('S-CSCFa1','hostname'),
			   "S-CSCFa2"=>CtTbCfg('S-CSCFa2','hostname'),
			   "UEa2"=>@UEa2[1],
			   "DNS"=>"dns.test.com"
			   );

	%address = ("P-CSCFa1"=>MacToIP6(CtTbCfg('P-CSCFa1','address')),
			    "P-CSCFa2"=>MacToIP6(CtTbCfg('P-CSCFa2','address')),
			    "I-CSCFa1"=>MacToIP6(CtTbCfg('I-CSCFa1','address')),
			    "I-CSCFa2"=>MacToIP6(CtTbCfg('I-CSCFa2','address')),
			    "S-CSCFa1"=>MacToIP6(CtTbCfg('S-CSCFa1','address')),
			    "S-CSCFa2"=>MacToIP6(CtTbCfg('S-CSCFa2','address')),
			    "UEa2"=>MacToIP6(CtTbCfg('UEa2','address')),
			    "DNS"=>MacToIP6(CtTbCfg('DNS','address')),
			    "Router_Address"=>CtTbCfg('PF','Router_Address'),
			    );

# BIND
	$result_ver = CheckVerDNS();
	
	if ($result_ver ne 'OK') {
		SetupMsg('ERR',"BIND version is not 9.x.x\n");
		return;
	}else{
		SetupMsg('OK',"BIND version is correct\n");
	}

# config
	$result_addr = CheckAddrDNS($prot,%address);

	if ($result_addr ne 'OK') {
		SetupMsg('ERR', "$ConfigTxt include address don't start with '3ffe:501:ffff'.\n");
		return;
	}else{
		SetupMsg('OK', "All of IP address start with '3ffe:501:ffff'\n");
	}

# 
	%result_domain = CheckDomainDNS(%domain);
	if ($result_domain{'com'} eq '') {
		SetupMsg('ERR', "$ConfigTxt include domain name don't end with '.com'\n");
		return;
	}else{
		SetupMsg('OK', "All of domain name end with .com\n");
	}


# 
	%rev_addr = CreateRevAddrDNS(%address);

# 
	if($prot eq 'INET6'){
		$rev_addr_txt = substr($rev_addr{'Router_Address'}, -23, 23);
	}else{
		$rev_addr_txt = substr($rev_addr{'Router_Address'},index($rev_addr{'Router_Address'},/\./,1) );
		$rev_addr_txt = substr($rev_addr_txt,index($rev_addr_txt,/\./,1) );
	}

# named.comf
	my ($result_flg) = 0;

	$conf_txt = CreateTXTforDNS($conf, \%address, \%domain, \%result_domain, $rev_addr_txt);
	if (length($conf_txt) == -1) {
		return;
	}

	$result_update = UpdateCfgDNS($conf, $conf_txt);

	if ($result_update ne 'OK') {
		SetupMsg('ERR', "Failed to set up DNS environment(named.conf)\n");
		print "Failed to set up DNS environment(named.conf)\n";
		$result_flg = -1;
	}

# com.zone
	$conf_txt = CreateTXTforDNS($zone, \%address, \%domain, \%result_domain);
	if (length($conf_txt) == -1) {
		return;
	}

	$result_update = UpdateCfgDNS($zone, $conf_txt);

	if ($result_update ne 'OK') {
		SetupMsg('ERR', "Failed to set up DNS environment(com.zone)\n");
		print "Failed to set up DNS environment(com.zone)\n";
		$result_flg = -2;
	}

# *.ipv6(
	if($prot eq 'INET6'){
		$rev_title = "/etc/namedb/".$rev_addr_txt.".ip6";
	}else{
		$rev_title = "/etc/namedb/".$rev_addr_txt.".ip4";
	}

	$conf_txt = CreateTXTforDNS($rev_title, \%rev_addr, \%domain, \%result_domain, $rev_addr_txt);
	if (length($conf_txt) == -1) {
		return;
	}

	$result_update = UpdateCfgDNS($rev_title, $conf_txt);

	if ($result_update ne 'OK') {
		SetupMsg('ERR', "Failed to set up DNS environment($rev_title)\n");
		print "Failed to set up DNS environment($rev_title)\n";
		$result_flg = -3;
	}	

# resolv.conf
	$conf_txt = "nameserver\t\t$address{'DNS'}\n";
	$result_update = UpdateCfgDNS("/etc/resolv.conf", $conf_txt);
	if ($result_update ne 'OK') {
		SetupMsg('ERR', "Failed to set up DNS environment(resolve.conf)\n");
		print "Failed to set up DNS environment(resolv.conf)\n";
		$result_flg = -4;
	}

	if ($result_flg == 0) {
		my $named_pids = CtGetPID('named');
		if ($named_pids ne '') {
			foreach $named_pid (@$named_pids) {
				my $kill = CtUtShell("kill -9 $named_pid",15);
				sleep(1);
#				print"pid = $named_pid\n";
			}
		}
		my $result_named = CtUtShell('named',15);
		SetupMsg('OK', "start BIND \n");
	}else{
		SetupMsg('ERR', "Can't start BIND \n");
		return;
	}

}


# BIND 
sub CheckVerDNS {
        my ($required_BIND, $required_BIND_version) = ('BIND', '9\.');
	my($ret,@suffix,$ver_str);
	$ret = CtUtShell('named -v',15);
	@suffix = split(/\s+/, $ret);
	if (@suffix[0] ne $required_BIND){ 
		print "ERROR : Required $required_BIND $required_BIND_version x or greater.\n";
		return;
	}
	if (@suffix[1] !~ /^$required_BIND_version/) {
		print "ERROR : Required $required_BIND $required_BIND_version x or greater.\n";
		return;
	}
	return 'OK';
}


# IPv6
# IPv4
sub CheckAddrDNS {
	my ($prot,%address) = @_;
	my ($comp_addr);
	my ($key, $value) = '';
	my ($i, $common_value) = '';

	if($prot eq 'INET'){return 'OK';}

	while (($key, $value) = each (%address)) {

		my @suffix = split(/:/, $value);
		for ($i=0;$i<=$#suffix;$i++){
			@suffix[$i] = substr('0000'.@suffix[$i],-4);
		}
		my @wk_list = (@suffix[0], @suffix[1], @suffix[2]);
		$comp_addr = join(":", @wk_list).":";

		if (length($common_value) < 1 ) {
			$common_value = $comp_addr;
			next;
		}

# 
# 
		if ($prot eq 'INET6' && $comp_addr ne '3ffe:0501:ffff:'){
			print "ERROR: Configured the address that doesn't start with '3ffe:501:ffff'. $key:[$value]\n";    
			return;
		}
	}
	return 'OK';

}

# 
# 
sub CheckDomainDNS {
	my (%domain) = @_;
	my (%zone_kind, @zone_kind);
	my ($router_addr, $prefix_addr);
	my ($key, $value) = '';
	my ($wk_zone, $wk_list, $update_flg, $upcnt, $rpos, $i);

	$router_addr = CtTbCfg('PF', 'Router_Address');
	my @suffix;
	my @wk_list;
	my $prefix_addr;
	if(CtUtIPAdType($router_addr) eq 'ip4'){
                @suffix = split(/\./, $router_addr);
                @wk_list = (@suffix[0], @suffix[1], @suffix[2]);
                $prefix_addr = join("\.", @wk_list)."\.";
	}else{
                @suffix = split(/:/, $router_addr);
                for ($i=0;$i<=$#suffix;$i++){
                        @suffix[$i] = substr('0000'.@suffix[$i],-4);
                }
                @wk_list = (@suffix[0], @suffix[1], @suffix[2]);
                $prefix_addr = join(":", @wk_list).":";
	}

	while (($key, $value) = each (%domain)) {

		$rpos = rindex($value, '.');

		if ($rpos == -1 ) {
			print "ERROR : [$key] is incorrect.\n";
			return 'NG';
		}
		$rpos = $rpos + 1;
		$wk_zone = substr($value, $rpos, (length($value)-$rpos));

		if ($#zone_kind < 0 ) { 
			$zone_kind{$wk_zone} = $prefix_addr;

		}
		else{
			$update_flg = 0;
			for ($upcnt=0;$upcnt<=$#zone_kind;$upcnt++){
				if (@zone_kind[$upcnt] eq $wk_zone){
					$update_flg = -1;
					last;
				}
			}
			if ($update_flg != -1) { 
				$zone_kind{$wk_zone} = $prefix_addr;
			}
		}
	}

	my $keycount = keys %zone_kind;
	my @kys = keys %zone_kind;
	if ($keycount != 1) {
		print "ERROR : All domain name should be finished with '.com'\n";
		return 'NG';
	}
	if (@kys[0] != 'com') {
		print "ERROR : All domain name should be finished with '.com'\n";
		return 'NG';
	}

	return %zone_kind;
}


# 
sub CreateRevAddrDNS {
	my (%address) = @_;
	my (%rev_addr);
	my ($addr_posi, $cln_count);
	my ($addr);
	my ($key, $value) = '';
	my ($i, $itm, $cln_str) = '';

	while ( ($key, $value) = each %address) {
		$_ = $value;
		$addr = '';

		if(CtUtIPAdType($value) eq 'ip6'){
			$addr_posi =index($value, '::');
			if ( $addr_posi != -1 ){
				if ($addr_posi != rindex($value, '::')) {
					print "ERROR:A wrong address is in $ConfigTxt\n";
					return;
				}
				$cln_count = tr/:/:/;
				if ($cln_count > 7){
					print "ERROR:A wrong address is in $ConfigTxt\n";
				}
				elsif ($cln_count < 7){
					$cln_str = ":0000" x (7-$cln_count+1);
					$cln_str = $cln_str.":";
					$value =~ s/::/$cln_str/;
				}
			}
			my @suffix = split(/:/, $value);
			for ($i=0;$i<=$#suffix;$i++){
				@suffix[$i] = substr('0000'.@suffix[$i],-4);
			}
				#    $wk= @suffix[0].@suffix[1].@suffix[2];
			my $wk= @suffix[0].@suffix[1].@suffix[2].@suffix[3].@suffix[4].@suffix[5].@suffix[6].@suffix[7];
			for ($itm=(length($wk)-1);$itm>=0;$itm--){
				if (length($addr) < 1) {
					$addr = substr($wk, $itm, 1);
				} else {
					$addr .= ".".substr($wk, $itm, 1);
				}
			}
			$rev_addr{$key} = $addr;
		}else{
			if ( $addr_posi != -1 ){
				$cln_count = tr/\./\./;
				if ($cln_count != 3){
					print "ERROR:A wrong address is in $ConfigTxt\n";
				}
			}
			my @suffix = split(/\./, $value);
			$rev_addr{$key} = @suffix[3].'.'.@suffix[2].'.'.@suffix[1].'.'.@suffix[0];
		}
	}
	return(%rev_addr);
}


# DNS 
sub CreateTXTforDNS {
	my($filename, $address, $domain, $result_domain, $rev_addr_txt) = @_;
	my($output_txt) = '';
	my($key, $value) = '';
	my($prefix_addr) = '';
#--- named.conf -----------
	my $current_time = localtime(time);
	if (index($filename, 'named.conf') != -1 ) {

		$output_txt = qq/\/\/ Tester setting [Created at $current_time] ##############################\n/.
						qq/options {\n/.
						qq/        directory       "\/etc\/namedb";\n/.
						qq/        pid-file        "\/var\/run\/named\/pid";\n/.
						qq/        dump-file       "\/var\/dump\/named_dump.db";\n/.
						qq/        statistics-file "\/var\/stats\/named.stats";\n/.
						qq/        allow-query {any;};\n/.
						qq/        listen-on-v6 {any;};\n/.
						qq/};\n/;

		$output_txt .= qq/\/\/ RFC 3152 \n/.
						qq/zone "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.IP6.ARPA" {\n/.
						qq/        type master;\n/.
						qq/        file "master\/localhost-v6.rev";\n/.
						qq/};\n/;

# forward file
		while ( ($key, $value) = each %$result_domain ) {

#        for ($zncnt=0;$zncnt<=$key_count;$zncnt++){
			$output_txt .= qq/zone "$key" {\n/.
							qq/        type master;\n/.
							qq/        file "$key.zone";\n/.
							qq/        allow-update {none;};\n/.
							qq/};\n/;   
		}

#reverse file
#--- for 'arpa'
		if(CtUtIPAdType(CtTbCfg('PF', 'Router_Address')) eq 'ip4'){
			$output_txt .= qq/zone "$rev_addr_txt\.in-addr.arpa" {\n/.  
							qq/        type master;\n/.
							qq/        file "$rev_addr_txt\.ip4";\n/.
							qq/};\n/;
		}else{
			$output_txt .= qq/zone "$rev_addr_txt\.ip6.arpa" {\n/.  
							qq/        type master;\n/.
							qq/        file "$rev_addr_txt\.ip6";\n/.
							qq/};\n/;
		}
	}

#--- com.zone -----------
	elsif (index($filename, '.zone') != -1 ) {

# Add strings to *.zone
		my ($zone_str, $zone_str_ex, $dom_ext) = '';

		while(($key, $value) = each %$domain) {
			if(CtUtIPAdType($$address{$key}) eq 'ip6'){
				$zone_str .= "$value"."."."\t\tIN\t\AAAA\t"."$$address{$key}\n";
			}else{
				$zone_str .= "$value"."."."\t\tIN\t\A\t"."$$address{$key}\n";
			}

			if (index($key, "P-CSCF") ne -1) {
				$dom_ext = CtTbCfg("$key", 'domain');
				$zone_str_ex .= qq/$dom_ext. IN NAPTR 50 50 "s" "SIP+D2U" "" _sip._udp.$dom_ext.\n/.
						qq/_sip._udp.$dom_ext. IN SRV 0 1 5060 $value.\n/;
			}
		}

		if (length($zone_str) < 1) {
			return;
		}
		if (length($zone_str_ex) < 1) {
			return;
		}
		
		$output_txt = qq/; Tester setting [Created at $current_time] ##########################\n/.
					qq/\$TTL  86400 \n\n/.
					qq/@      IN      SOA     dns.test.com. root.dns.test.com.(\n\n/.
					qq/       42      ; serial (d. adams)   \n\n/.
					qq/       3H      ; refresh             \n\n/.
					qq/       15M     ; retry               \n\n/.
					qq/       1W      ; expiry              \n\n/.
					qq/       1D )    ; minimum             \n\n/.
					qq/       IN      NS      dns.test.com. \n\n/.
					qq/$zone_str \n\n/.
					qq/$zone_str_ex \n/;

#print "3. [$output_txt]\n";
	}

#--- reverse file -----------
	elsif ((index($filename, '.ip6') != -1 ) || (index($filename, '.ip4') != -1 )) {
		my ($rev_str, $prfix_addr, $rev_addr) = '';

		$prefix_addr = ".".$rev_addr_txt;

		while(($key, $value) = each %$domain) {
			$rev_addr = "$$address{$key}";
			$rev_addr =~ /^(.*)$prefix_addr$/;
			$rev_str .= "$1\t\tIN\tPTR\t$value.\n";
		}

		$output_txt = qq/; Tester setting [Created at $current_time] #########################\n/.
						qq/\$TTL  86400 \n\n/.
						qq/@      IN      SOA     dns.test.com. root.dns.test.com.(\n\n/.
						qq/       42      ; serial (d. adams)   \n\n/.
						qq/       3H      ; refresh             \n\n/.
						qq/       15M     ; retry               \n\n/.
						qq/       1W      ; expiry              \n\n/.
						qq/       1D )    ; minimum             \n\n/.
						qq/       IN      NS      dns.test.com. \n\n/.
						qq/$rev_str \n/;
	}

	else {
		print "Error!! filename is $filename \n";
		return;
	}

#print "string [\n$output_txt\n]\n";
	return $output_txt;

}


# 
sub UpdateCfgDNS {
	my ($filename, $txt) = @_;
	my ($ans, $ret, $get_result, $lp_cnt);
	if ( -e $filename ){
#--- Read -.conf file ----
		open(IN, $filename ) || die "Error: $filename $!\n";
		my @CONF_FILE = <IN>;        #Read lines
		close(IN);
# When back-up file exists => ask if overwrite or not 
		$ans;
		if ( -e $filename.".bak" ){
			$ans = InputMsg( "A backup file of [$filename] has already existed.\n".
					  "Are you sure you want to overwrite that WITHOUT making any backup file? (y/n)\n>" );
			if ($ans eq "n\n") {exit}
		}

#--- Back up the existing -.conf file
		 $ret = rename $filename, ($filename.".bak") ;
		if ( $ret != 1) {
			print "ERROR: Can't rename $filename.\n";
			return;            
		} 

#--- Create string and make a file ------
		 $get_result = CREATE_file($filename, $txt);
#print "IN update [$txt] \n";
		if ($get_result ne "OK") {
			print "ERROR: Failed to create $filename\n";
			return;
		}

    }else{

#--- Create string and make a file ------
		$get_result = CREATE_file($filename, $txt);
#print "IN update [$txt] \n";
		if ($get_result ne "OK") {
			print "ERROR: Failed to create $filename\n";
			return;
		}
	}
	return "OK";
}

# CREATE_file Arg:([0]:filename, [1]:strings)
sub CREATE_file {

    my ($my_filename, @my_text) = @_;
#print "IN create [@my_text] \n";
    if( ! open(OUT, "> ".$my_filename ) ){ return "open error";}
    print OUT @my_text; 
    close(OUT);
    
    return "OK";
}


# -------------------------------------------------------------------
# V6evalTool tn.def/nut.def 
sub Loadv6evalDef {
    my($intf,$mac,$tmp,$tmp2,$localmac);

    if( !open(TAHI_DEF, $V6EVALnut) ){
	SetupMsg('ERR',"$V6EVALnut no exist.\n");
    }
    while (<TAHI_DEF>) {
	# 
	if( /^\s*#/ ){next;}
        # 
        if( /^((?i:link\S+))\s+(\S+)\s+(\S+)\s*$/ ){
	    CtTbCtiSet('SC,CFG,nut,'.lc($1) ,{'name'=>$2,'mac'=>$3},'T');
	    $tmp=$2;if($1 =~ /link0$/i){$intf=$tmp;}
	}
        elsif( /^(\S+)\s+(.+?)\s+$/ ){
	    CtTbCtiSet('SC,CFG,nut,'.lc($1) ,$2,'T');
	}
	elsif( /^(\S+)\s+(.*)\s*$/ ){
	    CtTbCtiSet('SC,CFG,nut,'.lc($1) ,$2,'T');
	}
    }
    close(TAHI_DEF);

    if( !open(TAHI_DEF, $V6EVALtn) ){
	SetupMsg('ERR',"$V6EVALtn no exist.\n");
    }
    while (<TAHI_DEF>) {
	# 
	if( /^\s*#/ ){next;}
        # 
        if( /^((?i:link\S+))\s+(\S+)\s+(\S+)\s*$/ ){
	    CtTbCtiSet('SC,CFG,tn,'.lc($1) ,{'name'=>$2,'mac'=>$3},'T');
	    $tmp=$3;if($1 =~ /link0$/i){$mac=$tmp;}
	}
        elsif( /^(\S+)\s+(.+?)\s+$/ ){
	    CtTbCtiSet('SC,CFG,tn,'.lc($1) ,$2,'T');
	}
	elsif( /^(\S+)\s+(.*)\s*$/ ){
	    CtTbCtiSet('SC,CFG,tn,'.lc($1) ,$2,'T');
	}
    }
    close(TAHI_DEF);

    if($intf){
	unless( CtTbCti("SC,IF,$intf") ){
	    SetupMsg('ERR',"tn.def Link0 [%s] is invalid interface\n",$intf);
	    return '';
	}

	$localmac=CtTbCti("SC,IF,$intf,mac");
	if(lc($localmac) ne lc($mac)){
	    SetupMsg('OK',"tn.def Link0 mac[%s] not equal interface[%s] mac[%s]\n",$mac,$intf,$localmac);
	    CtTbCtiSet("SC,CFG,tn,link0" ,{'name'=>$intf,'mac'=>$localmac},'T');
	}
	# 
	CtTbCtiSet("SC,CFG,PF,interface" ,$intf,'T');
	SetupMsg('OK', "nut.def link0 interface [%s]\n",$intf);
    }
    else{
	SetupMsg('ERR', "nut.def link0 interface invalid\n");
    }
    return $intf;
}
# KOI tn.def/nut.def 
sub LoadkoiDef {
    my($v6evalintf)=@_;
    my($intf,$tmp);

    if( !open(TAHI_DEF, $KOInut) ){
	SetupMsg('ERR',"$KOInut no exist.\n");
    }
    while (<TAHI_DEF>) {
	# 
	if( /^\s*#/ ){next;}
        # 
        if( /^((?i:link\S+))\s+(\S+)\s*$/ ){
	    $tmp=$2;if($1 =~ /link0$/i){$intf=$tmp;}
	}
    }
    close(TAHI_DEF);
    if(!$intf){
	SetupMsg('ERR',"$KOInut Link0 interface not defined\n");
    }
    elsif($v6evalintf ne $intf){
	SetupMsg('ERR',"$KOInut Link0 interface(%s) not equal $V6EVALnut Link0 interface(%s)\n",$intf,$v6evalintf);
    }

    $intf='';
    if( !open(TAHI_DEF, $KOItn) ){
	SetupMsg('ERR',"$KOItn no exist.\n");
    }
    while (<TAHI_DEF>) {
	# 
	if( /^\s*#/ ){next;}
        # 
        if( /^((?i:link\S+))\s+(\S+)\s*$/ ){
	    $tmp=$2;if($1 =~ /link0$/i){$intf=$tmp;}
	}
    }
    close(TAHI_DEF);
    if(!$intf){
	SetupMsg('ERR',"$KOItn Link0 interface not defined\n");
    }
    elsif($v6evalintf ne $intf){
	SetupMsg('ERR',"$KOItn Link0 interface(%s) not equal $V6EVALtn Link0 interface(%s)\n",$intf,$v6evalintf);
    }
}

# config.txt 
sub LoadCfg {
    my($class,$type,$item,$val,@vals,$no);
    
    unless( $type=IsCfgType() ){
	SetupMsg('ERR',"$ConfigTxt no exist.\n");
	return;
    }

    # 
    open(CONFIG_TXT, $ConfigTxt);
    if($type eq 'new'){
	while (<CONFIG_TXT>) {
	    # 
	    if( /^\s*#/ ){next;}
	    # 
            if( /^\[(.+)\]\s*$/ ){
		$class=$1;next;
	    }
            # 
            if( /^(\S+)\s+(\S*)\s*$/ ){
		$item=$1;$val=$2;
		if($val =~ /^\[.+\]$/){
		    $val =~ s/^\[(.+)\]$/$1/;
		    @vals = split(/,/, $val);
		    foreach $no (0..$#vals){
			@vals[$no] =~ s/^\s*(\S+)\s*$/$1/;
		    }
		    CtTbCtiSet("SC,CFG,$class,$item" ,\@vals,'T');
		}
		else{
		    CtTbCtiSet("SC,CFG,$class,$item" ,$val,'T');
		}
	    }
	    elsif( /^(\S+)\s+(.+)$/ ){
		$item=$1;$val=$2;
		if($val =~ /^\[.+\]$/){
		    $val =~ s/^\[(.+)\]$/$1/;
		    @vals = split(/,/, $val);
		    foreach $no (0..$#vals){
			@vals[$no] =~ s/^\s*(\S+)\s*$/$1/;
		    }
		    CtTbCtiSet("SC,CFG,$class,$item" ,\@vals,'T');
		}
		else{
		    CtTbCtiSet("SC,CFG,$class,$item" ,$val,'T');
		}
	    }
	}
    }
    else{
	while (<CONFIG_TXT>) {
	    # 
	    if( /^\s*#/ ){next;}
            # 
            if( /^(\S+)\.(\S+)\s+(\S*)\s*$/ ){
		CtTbCtiSet("SC,CFG,$1,$2" ,$3,'T');
	    }
            elsif( /^(\S+)\.(\S+)\s+(.+)$/ ){
		CtTbCtiSet("SC,CFG,$1,$2" ,$3,'T');
	    }
            elsif( /^(\S+)\s+(\S*)\s*$/ ){
		CtTbCtiSet("SC,CFG,$1" ,$2,'T');
	    }
            elsif( /^(\S+)\s+(.+)$/ ){
		CtTbCtiSet("SC,CFG,$1" ,$2,'T');
	    }
	}
    }
    close(CONFIG_TXT);
}
sub IsCfgType {
    # 
    if( !open(CONFIG_TXT, $ConfigTxt) ){return;}
    while (<CONFIG_TXT>) {
	# 
        if( /^\[(.+)\]\s*$/ ){ return 'new';}
    }
    close(CONFIG_TXT);
    return 'old';
}

# 
sub SetIntAD {
    my($intf,$prot,$ad,$prefix)=@_;
    my($inftbl,$ip);

    $inftbl=$DIRRoot{'SC'}->{'IF'};

    if($prot eq 'INET'){
	$prot = 'ipv4';
	$ip=CtUtV4StrToHex($ad);
    }
    else{
	$prot = 'ipv6';
	$ip=CtUtV6StrToHex($ad);
    }
    # 
    if($inftbl->{$intf}->{$prot}->{$ip} && $inftbl->{$intf}->{$prot}->{$ip}->{'mask'} eq $prefix){
	SetupMsg('OK', "Interface[%s] already set address[%s/%d]\n",$intf,$ad,$prefix);
    }
    else{
	SetupMsg('OK', "Interface[%s] setup address[%s/%d]\n",$intf,$ad,$prefix);
	# 
	if($inftbl->{$intf}->{$prot}->{$ip}){
	    if($prot eq 'ipv6'){
		SetIFIPv6('del',$intf,CtUtHexToIP($ip,'v6'),$inftbl->{$intf}->{$prot}->{$ip}->{'mask'});
	    }
	    else{
		SetIFIPv4('del',$intf,CtUtHexToIP($ip,'v4'),$inftbl->{$intf}->{$prot}->{$ip}->{'mask'});
	    }
	}
	# 
	if($prot eq 'ipv6'){
	    SetIFIPv6('add',$intf,CtUtHexToIP($ip,'v6'),$prefix);
	}
	else{
	    SetIFIPv4('add',$intf,CtUtHexToIP($ip,'v4'),$prefix);
	}
	# 
	$inftbl->{$intf}->{$prot}->{$ip}->{'mask'}=$prefix;
    }
}

sub SetIntDR {
    my($intf,$prot,$ad,$prefix)=@_;
    my($inftbl,$ip,$ret,$op,@proto);

    $inftbl=$DIRRoot{'SC'}->{'IF'};

    if($prot eq 'INET'){
	$prot = 'ipv4';
	$ip=CtUtV4StrToHex($ad);
    }
    else{
	$prot = 'ipv6';
	$ip=CtUtV6StrToHex($ad);
    }
    if($inftbl->{'DRoute'}){
	@proto=keys(%{$inftbl->{'DRoute'}});
    }

    # 
    if(grep{$_ eq $prot}(@proto) && $inftbl->{'DRoute'}->{$prot}->{$ip}){
	SetupMsg('OK',"Interface[%s] already set default route[%s]\n",$intf,$ad);
    }
    else{
	$op=((grep{$_ eq $prot}(@proto))?'change':'add');
	# 
	if($prot eq 'ipv6'){
	    printf("#### route $op -inet6 default %s\n",CtUtHexToIP($ip,'v6'));
	    $ret=SetDRoute(CtUtHexToIP($ip,'v6'),$prot,'','',$op);
	}
	else{
	    printf("#### route $op -inet default %s\n",CtUtHexToIP($ip,'v4'));
	    $ret=SetDRoute(CtUtHexToIP($ip,'v4'),$prot,'','',$op);
	}
	if($ret){
	    SetupMsg('ERR',"Set default route(%s) invalid. [%s].delete %s by manual\n",$ad,$ret,$ad);
	}
	else{
	    SetupMsg('OK',"Interface[%s] $op default route[%s]\n",$intf,$ad);
	    # 
	    $inftbl->{'DRoute'}->{$prot}->{$ip}={'inf'=>$intf};
	}
    }
}

# IPv
sub MacToIP6 {
    my($mac)=@_;
    my(@temp);
    if(!IsMacAddress($mac) || uc(CtTbCfg('PF','protocol')) ne 'INET6' ){return $mac}
    my @addr=CtUtV6WtMkToVal(CtTbCfg('PF','Router_Address').'/'.(CtTbCfg('PF','Router_Prefix') || 64));
    return CtUtV6FromMac($mac,@addr[0]);
}
