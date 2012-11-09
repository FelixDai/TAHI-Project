#!/usr/bin/perl
# @@ -- SceSvc.pm --
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

# 
# 09/2/ 9  CtScAddCapt 
# 09/1/27  bytecode
# 08/11/28 
#          CtScAddCaptContext:
#          CtLgJudgeAndPkt:HTLM
#          CtContextToText:perl
# 07/10/31
#   config.txt 

#=================================
# 
#=================================

## DEF.VAR
# use strict;
use Config;

# 
$|=1;
$SIG{'INT'}=$SIG{'KILL'}=$SIG{'TERM'}=$SIG{'QUIT'}=$SIG{'HUP'}='CtScExitSignalTrap';

# 
$ScenarioTimeOut=20;

# 
@MakerPackets;

# 
@UNKnownPackets;
## DEF.END

#=================================
# 
#=================================
# 
#   XXX  [aa,bb,cc] 
sub CtUtLoadCfg {
    my($class,$type,$item,$val,$vals,$no,$config);
    
    $config=CtTbCti('SC,ScenarioInfo,Config')||'config.txt';

    $type=CtUtIsCfgType($config);

    # 
    unless( open(CONFIG_TXT, $config) ){
	CtSvError('fatal', "can't load config[%s]\n",$config);
    }
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
		    $vals=[];
		    @$vals = split(/,/, $val);
		    foreach $no (0..$#$vals){
			$vals->[$no] =~ s/^\s*(\S+)\s*$/$1/;
		    }
		    CtTbCtiSet("SC,CFG,$class,$item" ,$vals,'T');
		}
		else{
		    CtTbCtiSet("SC,CFG,$class,$item" ,$val,'T');
		}
	    }
	    elsif( /^(\S+)\s+(.+)$/ ){
		$item=$1;$val=$2;
		if($val =~ /^\[.+\]$/){
		    $val =~ s/^\[(.+)\]$/$1/;
		    $vals=[];
		    @$vals = split(/,/, $val);
		    foreach $no (0..$#$vals){
			$vals->[$no] =~ s/^\s*(\S+)\s*$/$1/;
		    }
		    CtTbCtiSet("SC,CFG,$class,$item" ,$vals,'T');
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
    return $config;
}
sub CtUtIsCfgType {
    my($config)=@_;

    # 
    open(CONFIG_TXT, $config||"config.txt");
    while (<CONFIG_TXT>) {
	# 
        if( /^\[(.+)\]\s*$/ ){ return 'new';}
    }
    close(CONFIG_TXT);
    return 'old';
}
# 
sub CtUtLoadModCfg {
    my($class);
    
    # 
    open(CONFIG_TXT, "module.txt");
    while (<CONFIG_TXT>) {
	# 
	if( /^\s*#/ ){next;}
        # 
        if( /^\[(.+)\]\s*$/ ){
	    $class=$1;next;
	}
        # 
        if( /^(\S+)\s+(\S*)\s*$/ ){
	    CtTbCtiSet("SC,MOD,$class,$1" ,$2,'T');
	}
    }
    close(CONFIG_TXT);
}
# 
sub CtUtLoadExtCfg {
    my ($fname, $section) = @_;
    my ($line, $key, $val);

    if ($fname eq '') {
        return;
    }
    if (!(-e $fname)) {
        return;
    }

    if ($section eq '') {
        $section = $fname;
        $section =~ s/^.+\///;
    }

    # 
    open(EXT_FILE, "$fname");
    while ($line = <EXT_FILE>) {
        # 
        if ($line =~ /^\s*#/) { next; }
        # 
        if ($line =~ /^\s*(\S+)\s*=\s*(.*)$/) {
            $key = $1;
            $val = $2;
            # 
            if ($val =~ /^"/) {
                $val =~ /^"(.*)"/;
                $val = $1;
            }
            # 
            elsif ($val =~ /^'/) {
                $val =~ /^'(.*)'/;
                $val = $1;
            }
            else {
                # 
                $val =~ s/#(.*)$//;
                $val =~ s/\s*$//;
            }
            CtTbCtiSet("SC,EXT,$section,$key", $val, 'T');
        }
    }
    close(EXT_FILE);
}

# 
sub CtUtIsFunc {
    my $funcname = shift;
    return defined(&$funcname)
}

#=================================
# 
#=================================
sub CtUtCheckVersion {
    my($version);
    $version=$Config{'version'};
    $version =~ s/\.//g;
    if($version < 587){
	printf("ERR       | This Perl system done not fit for CT.  Version[%s] Usethreads[%s] Usemultiplicity[%s]\n",
	       $Config{'version'},$Config{'usethreads'},$Config{'usemultiplicity'});
	die $@;
    }
    else{
	printf("Perl system:  Version[%s]  Usethreads[%s]  Usemultiplicity[%s]\n",
	       $Config{'version'},$Config{'usethreads'},$Config{'usemultiplicity'});
    }
}

# nonIO:IO
# capNode:
sub CtScInit {
    my($param,$noLog,$noScenarioInfo)=@_;
    my($config,$args);

    # 
    CtUtCheckVersion();
    MsgPrint('INIT',"CtUtCheckVersion OK\n");

    # 
    CtTbInit();
    MsgPrint('INIT',"CtTbInit OK\n");

    # 
    CtScSetExcep('CtScExit');
    MsgPrint('INIT',"CtScSetExcep OK\n");

    # 
    unless($noScenarioInfo){
	CtScLoadScCfg();
	MsgPrint('INIT',"CtScLoadScCfg OK\n");
    }

    # 
    CtUtSetupCommandArg();

    # 
    $config=CtUtLoadCfg();

    # 
    CtUtLoadModCfg();

    # 
    if(CtTbCti('SC,ScenarioInfo,SimulateFile')){CtTbCfgSet('DEBUG','simulate','on')}
    if(CtTbCti('SC,ScenarioInfo,SimulateContinue')){CtTbCfgSet('DEBUG','sim-continue','on')}

    # 
    CtLgSetLevel(CtTbCfg('DEBUG','log'));
    CtLgSetLevel(CtTbCti('SC,ScenarioInfo,Loglevel'));
    MsgPrint('INIT',"Load config[%s] OK\n",$config);

    # GUI
    if(CtTbCti('SC,ScenarioInfo,Gui')){
        if(CtGuiLoad()){
            MsgPrint('INIT',"Can' load Gtk2 package\n");exit;
        }
        MsgPrint('INIT',"Load Gtk2 OK\n");
    }

    # 
    CtPkRegTempl(\@INETPacketHexMap);

    # 
    CtTbMakeUsrDB();

    # 
    CtTbMakeNSDB();

    # CT
    if( CtSvInit($param) ){CtScExit('InitFail','','Initialize Scenario Error');}
    MsgPrint('INIT',"CtSvInit OK\n");
    
    # 
    if( CtSvIO($param) ){CtScExit('InitFail','','Initialize IO Error');}
    MsgPrint('INIT',"CtSvIO OK\n");

    # 
    unless($noLog){LOGOutputSetup();}
}

# 
sub CtTbInit {
    %DIRRoot=('SC'=>{'CFG'=>'','USR'=>{},'NS'=>{},'PARAM'=>{'RecvTimeout'=>$ScenarioTimeOut},
		     'StartTime'=>[Time::HiRes::gettimeofday()],'ScenarioInfo'=>''},
	      'ND'=>'',
	      'ACTND'=>'',   # 
	      'LASTPKT'=>'', # 
	      );
    @MakerPackets=();
    @UNKnownPackets=();
    %ScenarioList=();
    %CategoryList=();
    $ConnectionID='';
    %LOGList=();       # 
    @NDNodeTbl=();
    @NDNodeEvent=();
    %CBSetTimer=();
    %HXPKTPatternDB=();
    %RuleDB=();
    %StatisticsRule=();
    %RuleCategoryDB=();
    @JUDGEMENTLog=();
}

# 
#   
#     
#   
sub CtSvError {
    my($status,$msg,@args)=@_;
    my($node,$func,@stack);
    
    $msg=sprintf($msg,@args);

    unless($node=$DIRRoot{'ACTND'}){
	MsgPrint('ERR',"Internal Error status(%s) %s.\n",$status,$msg);
	CtScExit($status,'',$msg);
    }
    # 
    if($func=$node->{'EXCEPTION'}){
	$func->($status,$node,$msg);
    }
    # 
    elsif($func=$node->{'TL'}->{$node->{'ST'}}->{'EXCEPTION'}){
	$func->($status,$node,$msg);
    }
    # 
    elsif($func=$DIRRoot{'EXCEPTION'}){
	@stack=caller(1);
	MsgPrint('ERR',"Internal Error(%s) status(%s) %s\n",@stack[3],$status,$msg);
	$func->($status,$node,$msg);
    }
    else{
	@stack=caller(1);
	# 
	MsgPrint('ERR',"Internal Error(%s) status(%s) %s\n",@stack[3],$status,$msg);
    }
}

# 
# 
sub CtScSetExcep {
    my($func)=@_;
    $DIRRoot{'EXCEPTION'}=$func;
}

# 
#  1) CtScEnd
#  2) CtScExit
#  3) CtScExitSignalTrap   <= terminate,interupt 
#      CtUtExitStatusCode
sub CtScExit {
    my($status,$node,$msg)=@_;
    $status='Pass' unless($status);
    CtLgNG($msg) if($status =~ /fatal/i);
    $ExitSignalTrapResult=$status;

    # 
    if($COMPRESSMODE){CtScExitSignalTrap();}
    # 
    exit;
}
sub CtScEnd {
    CtScExit(@_);
}

## DEF.VAR
$ExitSignalTrapFlag;
$ExitSignalTrapResult;
%EXITCode=('Fatal'=>64,'Ignore'=>1,'InitFail'=>33,'Pass'=>0,'Warn'=>3,'Fail'=>32);
## DEF.END

# 
#   
#   
#   
# ExitSignalTrapResult
#   <<
#   Total=>[Pass|Warn|Fatal|Fail|Ignore] Scenario=>[Pass|Warn|Fail] CtRlJudge=>[Pass|Warn|Fail]
#     Total     Pass:
#     Scenario  Pass:
#     CtRlJudge  Pass:


# 
# CtScExit
# Control-C
# 
sub CtUtExitStatusCode {
    my($result,$extmsg)=@_;

    my($total,$error,$warning,$logMessage,$totalJudgement,$senarioJudgement,$syntaxJudgement,$ruleAccount);

    # 
    $result='Fatal' unless($result);

    # 
    ($total,$error,$warning)=CtRlSyntaxResultStats();
    $ruleAccount=sprintf('Evaled Rule count[%d] Error[%d] Warning[%d]',$total,$error,$warning);

    # 
    if($result eq 'Pass' || $result eq 'Warn' || $result eq 'Fail'){
    # 
	($total,$error,$warning)=CtRlSyntaxResultStats();
	$syntaxJudgement=$error?'Fail':($warning?'Warn':'Pass');
	$senarioJudgement=$result;
	if($syntaxJudgement eq 'Pass' && $senarioJudgement eq 'Pass'){$totalJudgement='Pass';}
	elsif($syntaxJudgement eq 'Fail' || $senarioJudgement eq 'Fail'){$totalJudgement='Fail';}
	else{$totalJudgement='Warn';}
	$logMessage=$senarioJudgement eq 'Fail' ? 'abnormal end' : 'normal end';
	if($senarioJudgement eq 'Pass'){$result=$syntaxJudgement;}
    }
    else{
	if($result ne 'InitFail' && $result ne 'Ignore' && $result ne 'Fatal'){$result='Fatal';}
	$totalJudgement='Fail';
	$senarioJudgement='Fail';
	$syntaxJudgement='Fail';
	$logMessage='Abnormal End';
    }
    $logMessage = "Scenario status:$logMessage   Test result:$totalJudgement (Sequence:$senarioJudgement Syntax:$syntaxJudgement$extmsg)";
    if(defined(&jcode::convert)){jcode::convert(\$logMessage,"euc");}
    elsif(defined(&Jcode::convert)){Jcode::convert(\$logMessage,"euc");}
    if(defined(&jcode::convert)){jcode::convert(\$ruleAccount,"euc");}
    elsif(defined(&Jcode::convert)){Jcode::convert(\$ruleAccount,"euc");}
    return $result,$logMessage,$ruleAccount;
}
sub CtScExitSignalTrap {
    my($logMessage,$result,$ruleAccount,$params);

    MsgPrint('INIT',"CtScExitSignalTrap Enter TrapFlag[%s]\n",$ExitSignalTrapFlag);

    # 
    if($ExitSignalTrapFlag){exit $EXITCode{$ExitSignalTrapResult};}
    $ExitSignalTrapFlag=1;

    if(CtUtIsFunc('ServiceExitSignalTrap')){
	$result=ServiceExitSignalTrap();
	exit $EXITCode{$result};
    }

    # KOI 
    if(CtUtIsFunc("kModule_Exit")){kModule_Exit();MsgPrint('INIT',"CtScExitSignalTrap kModule_Exit OK\n");}

    # 
    if(CtUtIsFunc("CtSvEnd")){$params=CtSvEnd($ExitSignalTrapResult);MsgPrint('INIT',"CtScExitSignalTrap CtSvEnd OK\n");}

    # 
    if(CtUtIsFunc("ServiceExitStatusCode")){
	($result,$logMessage,$ruleAccount)=ServiceExitStatusCode($ExitSignalTrapResult);
    }
    else{
	($result,$logMessage,$ruleAccount)=CtUtExitStatusCode($ExitSignalTrapResult);
    }

    # HTML 
    if(CtUtIsFunc("ServiceLogOutput")){
	ServiceLogOutput($result,$logMessage,$ruleAccount,$params);
    }
    else{
	unless(CtTbCti('SC,ScenarioInfo,Output')){exit $EXITCode{'InitFail'};}

	# 
	LOGOutputMain($logMessage,$ruleAccount,$params);
	
	# 
	CtLgOutDirect("</TABLE></BODY>\n</HTML>");
	close(HTMLLOG);
    }

    MsgPrint('INIT',"CtScExitSignalTrap LOGOutputMain OK\n");
    # TCP
    if(CtUtIsFunc("TCPTerminateAction")){
	TCPTerminateAction();
    }

    $ExitSignalTrapResult=$result;
    MsgPrint('INIT',"CtScExitSignalTrap Exit[%s]\n",$result);
    exit $EXITCode{$result};
}

#=================================
# 
#=================================
# 
sub CtUtGetMac {
    my($intf)=@_;
    my($id,$mac,$info,$root,$result);
    $result=CtUtShell("ifconfig ".$intf);
    if( $result =~ /^\s+ether ([0-9a-fA-F:]+)\s*$/m ){
	$mac=$1;
    }
    return $mac;
}
sub GetIFTbl {
    my(%inf,$result,$inf,%info,$v6,$v4,$mac,$ip);
    $result=CtUtShell("ifconfig");
    %inf = $result =~ /^(\S+):.+\n((?:\s.+\n)+)/gm;
    foreach $inf (keys(%inf)){
	$result = $inf{$inf};
	$v6={};
	$v4={};$mac='';
	%$v6 = $result =~ /^\s+inet6 ([0-9a-fA-F:]+)(?:%.+)? prefixlen ([0-9]+)/gm;
	%$v4 = $result =~ /^\s+inet ([0-9\.]+) netmask 0x([0-9a-fA-F]+)/gm;
	if( $result =~ /^\s+ether ([0-9a-fA-F:]+)\s*$/m ) {$mac=$1;}
	foreach $ip (keys(%$v6)){
	    $info{$inf}->{'ipv6'}->{CtUtV6StrToHex($ip)}={'mask'=>$v6->{$ip}};
	}
	foreach $ip (keys(%$v4)){
	    $info{$inf}->{'ipv4'}->{CtUtV4StrToHex($ip)}={'mask'=>CtUtHexToBitlen($v4->{$ip})};
	}
	if($mac){$info{$inf}->{'mac'}=$mac;}
    }
    return \%info;
}
# 
sub GetDRTbl {
    my(%inf,$result,$mode,%info,$v6,$v4,$mac,$ip);
    $result=CtUtShell("netstat -rn");
    %inf = $result =~ /^((?:(?:Internet)|(?:Internet6))):\n((?:\S.+\n)+)/gm;

    foreach $mode (keys(%inf)){
	$result = $inf{$mode};
	if($mode eq 'Internet'){
	    $v4={};
	    %$v4 = $result =~ /^default\s+([0-9\.]+)\s.+\s([0-9a-zA-Z]+)\n/gm;
	    foreach $ip (keys(%$v4)){
		$info{'ipv4'}->{CtUtV4StrToHex($ip)}={'inf'=>$v4->{$ip}};
	    }
	}
	if($mode eq 'Internet6'){
	    $v6={};
	    %$v6 = $result =~ /^default\s+([0-9a-fA-F:]+)\s.+\s(?!lo0)([0-9a-zA-Z]+)\n/gm;
#	    %$v6 = $result =~ /^::(?:\/[0-9]+)?\s+([0-9a-fA-F:]+)\s.+\s(?!lo0)([0-9a-zA-Z]+)\n/gm;
	    foreach $ip (keys(%$v6)){
		$info{'ipv6'}->{CtUtV6StrToHex($ip)}={'inf'=>$v6->{$ip}};
	    }
	}
    }
    return \%info;
}
# 
# route add    -inet6 default 9001::100
# route change -inet6 default 9001::100
# route delete -inet6 default
# route add -inet default 192.168.1.1
# route delete -inet default
sub SetDRoute {
    my($route,$mode,$prefix,$intf,$op)=@_;
    my($ret,$result);
    $op='add' unless $op;
    if($mode eq 'ipv6'){
	$prefix = $prefix || 64;
#	$result=CtUtShell("route add -ifp $intf -inet6 -prefixlen $prefix default $route");
	$result=CtUtShell("route $op -inet6 default $route");
	if( $result =~ /^add net default: gateway [0-9a-fA-F:]+: (.+)\n/gm ){
	    $ret=$1;
	}
    }
    elsif($mode eq 'ipv4'){
	$prefix = $prefix || 24; 
	$result=CtUtShell("route $op -inet default $route");
	if( $result =~ /^add net default: gateway [0-9\.]+:(.+)\n/gm ){
	    $ret=$1;
	}
    }
    else{
	$ret='mode invalid';
    }
    return $ret;
}

sub GetIFIPv6 {
    my($intf)=@_;
    my($result,%ad,@keys,$key,@addr);
    $result=CtUtShell("ifconfig ".$intf." inet6");
    %ad = $result =~ /^\s+inet6 ([0-9a-fA-F:]+)(?:%.+)? prefixlen ([0-9]+)/gm;
    @keys=keys(%ad);
    foreach $key (@keys){
	push(@addr,{'ip'=>$key,'mask'=>$ad{$key}});
    }
    return \@addr;
}
sub SetIFIPv6 {
    my($op,$intf,$addr,$mask)=@_;
    my($result,$changed);
    if($op eq 'add'){
	$result=CtUtShell("ifconfig ".$intf." inet6 ".$addr."/".$mask." add");
	MsgPrint('INIT',"IF %s\n","ifconfig ".$intf." inet6 ".$addr."/".$mask." add");
	$changed='T';
	sleep(1);
    }
    elsif($op eq 'del'){
	$result=CtUtShell("ifconfig ".$intf." inet6 ".$addr."/".$mask." remove");
	MsgPrint('INIT',"IF %s\n","ifconfig ".$intf." inet6 ".$addr."/".$mask." remove");
	$changed='T';
	sleep(1);
    }
    elsif($op eq 'set'){
	my($curr,$ad);
	if(ref($addr) ne 'ARRAY'){$addr=[{'ip'=>$addr,'mask'=>$mask}];}
	$curr=GetIFIPv6($intf);
	foreach $ad (@$curr){
	    if(grep{CtUtV6Eq($_->{'ip'},$ad->{'ip'})}(@$addr)){next;}
	    CtUtShell("ifconfig ".$intf." inet6 ".$ad->{'ip'}."/".$ad->{'mask'}." remove");
	    $changed='T';
	    sleep(2);
	}
	foreach $ad (@$addr){
	    if(grep{CtUtV6Eq($_->{'ip'},$ad->{'ip'})}(@$curr)){next;}
	    CtUtShell("ifconfig ".$intf." inet6 ".$ad->{'ip'}."/".$ad->{'mask'}." add");
	    $changed='T';
	    sleep(2);
	}
    }
    return $changed;
}
sub GetIFIPv4 {
    my($intf)=@_;
    my($result,%ad,@keys,$key,@addr,$masklen);
    $result=CtUtShell("ifconfig ".$intf." inet");
    %ad = $result =~ /^\s+inet ([0-9\.]+) netmask 0x([0-9a-fA-F]+)/gm;
    @keys=keys(%ad);
    foreach $key (@keys){
	$masklen=hex($ad{$key});
# 	$netmask=sprintf("%s.%s.%s.%s",
# 			 hex(substr($ad{$key},0,2)),hex(substr($ad{$key},2,2)),
# 			 hex(substr($ad{$key},4,2)),hex(substr($ad{$key},6,2)));
	push(@addr,{'ip'=>$key,'mask'=>$masklen});
    }
    return \@addr;
}
sub SetIFIPv4 {
    my($op,$intf,$addr,$mask)=@_;
    my($result,$addrs,$changed);
    if($op eq 'add'){
	$result=CtUtShell("ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($mask)." ".$addr." add");
	MsgPrint('INIT',"IF %s\n","ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($mask)." ".$addr." add");
	$changed='T';
	sleep(1);
    }
    elsif($op eq 'del'){
	if($addr eq '*'){
	    $addrs=GetIFIPv4($intf);
	    foreach $addr (@$addrs){
		CtUtShell("ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($addr->{'mask'})." ".$addr->{'ip'}." remove");
		$changed='T';
		MsgPrint('INIT',"IF %s\n","ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($addr->{'mask'})." ".$addr->{'ip'}." remove");
		sleep(2);
	    }
	}
	else{
	    $result=CtUtShell("ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($mask)." ".$addr." remove");
	    $changed='T';
	    MsgPrint('INIT',"IF %s\n","ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($mask)." ".$addr." remove");
	    sleep(2);
	}
    }
    elsif($op eq 'set'){
	my($curr,$ad);
	if(ref($addr) ne 'ARRAY'){$addr=[{'ip'=>$addr,'mask'=>$mask}];}
	$curr=GetIFIPv4($intf);
	foreach $ad (@$curr){
	    if(grep{CtUtV4Eq($_->{'ip'},$ad->{'ip'})}(@$addr)){next;}
	    CtUtShell("ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($ad->{'mask'})." ".$ad->{'ip'}." remove");
	    $changed='T';
	    MsgPrint('INIT',"IF %s\n","ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($ad->{'mask'})." ".$ad->{'ip'}." remove");
	    sleep(2);
	}
	foreach $ad (@$addr){
	    if(grep{CtUtV4Eq($_->{'ip'},$ad->{'ip'})}(@$curr)){next;}
	    CtUtShell("ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($ad->{'mask'})." ".$ad->{'ip'}." add");
	    $changed='T';
	    MsgPrint('INIT',"IF %s\n","ifconfig ".$intf." inet netmask ".IPv4MaskLengToMaskStr($ad->{'mask'})." ".$ad->{'ip'}." add");
	    sleep(2);
	}
    }
    return $changed;
}
sub IPv4HexToMaskLeng{
    my($mask)=@_;
    my($i,$len);
    $mask = hex($mask);
    foreach $i (0..32){
	if($mask & 0x80000000){
	    $len++;
	}
	$mask = $mask << 1;
    }
    return $len;
}
sub IPv4MaskLengToHex{
    my($masklen)=@_;
    my($mask,$i);
    $mask=0;
    foreach $i (0..$masklen-1){
	$mask *= 2;
	$mask ++;
    }
    foreach $i (0..31-$masklen){
	$mask *= 2;
    }
    return sprintf("%x",$mask);
}
sub IPv4MaskLengToHex{
    my($masklen)=@_;
    my($mask,$i);
    $mask=0;
    foreach $i (0..$masklen-1){
	$mask *= 2;
	$mask ++;
    }
    foreach $i (0..31-$masklen){
	$mask *= 2;
    }
    return sprintf("%x",$mask);
}
sub IPv4MaskLengToMaskStr{
    my($masklen)=@_;
    my($mask,$i);
    foreach $i (0..3){
	if(8<=$masklen){
	    $mask .= '.255';
	}
	elsif(0<$masklen){
	    $mask .= '.'.((2**$masklen-1)<<(8-$masklen));
	}
	else{
	    $mask .= '.0';
	}
	$masklen -= 8;
    }
    return substr($mask,1);
}

# 
sub CtKillProcess {
    my($procname)=@_;
    my($pids,$pid);

    $pids=CtGetPID($procname);
    foreach $pid (@$pids){CtUtShell("kill -9 $pid")}
}
# pid 
sub CtGetPID {
    my($procname)=@_;
    my($ans,@matchs,$line,@pid);
    $ans=CtUtShell("ps ax",20);

    if( @matchs = $ans =~ /^(.+$procname.*)$/mg ){
	foreach $line (@matchs){
##	    printf("match pid [$line]\n");
	    $line =~ /([0-9]+)/;
	    push(@pid,$1);
	}
	MsgPrint('INIT',"%s [@pid]\n",$procname);
	return \@pid;
    }
    return;
}

sub CtUtShell {
    my($command,$timeout)=@_;
    my($result,$count,$state);
    local($SIG{'CHLD'});
    $SIG{'CHLD'}='';
    ($result,$state)=CtUtShellResult($command,'T',$timeout);
    while($state && $count<3){
	if(CtLgLevel('INIT')){printf(" cmd retry ...[%s]\n",++$count);}
	($result,$state)=CtUtShellResult($command,'T',$timeout);
    }
    if(3<=$count){
	CtSvError('fatal', "Can't do cmd[%s] %s\n",$command,$state );
    }
    return $result;
}

# 
sub CtUtShellResult {
    my($command,$stderr,$timeout)=@_;
    my($result,$pipe);
    local($status);

    $timeout = $timeout || 5;
    eval{
	local $SIG{'ALRM'}= sub {$status='TIME-OUT';die};
	alarm( $timeout );
	eval {
	    if(CtLgLevel('INIT')){printf("INIT: cmd [%s] => ",$command);}
	    # $stderr
#	    $result = `$command`;
	    $pipe = $stderr ? ' 2>&1 |' : ' |' ;
	    unless( open(STATUS,  $command . $pipe) ){
		MsgPrint(ERR,"Can't exec [%s]\n",$command);
		return ;
	    }
	    while (<STATUS>){$result .= $_;}
	    close(STATUS);
	    if(CtLgLevel('INIT')){printf("[%s]\n",substr($result,0,20));}
	};
	alarm(0);
    };
    alarm(0);
    if($status || $@){
	$status = $status ? $status :(ref($@) ? 'TIME-OUT' : $@);
    }
    return $result,$status;
}


#============================================
# 
#============================================
sub CtTbMakeUsrDB {
}


#============================================
# 
#============================================
sub CtTbMakeNSDB {
}


#============================================
# 
#============================================

#  
#    
# 
sub CtUtSetupCommandArg {
    my($key,$val,$arg);
    my($alias);

    $alias={'sim'=>'SimulateFile','cfg'=>'Config','debug'=>'Loglevel','show'=>'ShowHTML','gui'=>'Gui',
            'id'=>'ID','simcont'=>'SimulateContinue','ipsec'=>'Ipsec','auth'=>'AuthScheme'};

    # v6evaltool
    foreach $arg (@ARGV){
	if($arg =~ /(\S+)=(\S+)/){
	    $key=$1;
	    $val=$2;
	    if($alias->{$key}){
		CtTbCtiSet('SC,ScenarioInfo,'.$alias->{$key},$val,'T');
	    }
	}
    }
    CtTbCtiSet('SC,ScenarioInfo,File',$0,'T');
}

# 
sub CtScLoadScCfg {
    my($logID,$logDir,$seq,$sim,$config);
    my($title,$cat,$info,$catinfo,$seq,$logIDPath,$id,$catdir,$datedir);

    # 
    # ($id,$logID)=CtUtSetupCommandArg();

    unless($logDir){$logDir='log';}
    $logIDPath=$logID?($logID . '/'):'';
    
    # 
    ($title,$info,$cat,$catinfo)=CtScReadInfo($id);
    CtTbCtiSet('SC,ScenarioInfo,Title',$title,'T');
    CtTbCtiSet('SC,ScenarioInfo,Info',$info,'T');
    CtTbCtiSet('SC,ScenarioInfo,Category',$cat,'T');
    CtTbCtiSet('SC,ScenarioInfo,OutputPath',$logDir . '/' . $logIDPath . $id,'T');
    CtTbCtiSet('SC,ScenarioInfo,Output',$logDir . '/' . $logIDPath . $id . '.html','T');
    CtTbCtiSet('SC,ScenarioInfo,CompressMode',$COMPRESSMODE,'T');
    CtTbCtiSet('SC,ScenarioInfo,CTVersion',$CTVERSION,'T');
    CtTbCtiSet('SC,ScenarioInfo,ScenarioVersion',$SCENARIOVERSION,'T');
    MsgPrint('INIT',"HTML outfile[%s]\n",$logDir . '/' . $logIDPath . $id . '.html');

    # 
    if(!(-e $logDir)){
	if(!mkdir($logDir,0777)){printf("ERROR : Can't create log directory.\n");exit 1;}
    }
    # 
    if($logID && $logID =~ /^(.+)\/(.+)$/){
	$catdir=$1;
	$datedir=$2;
	if(!(-e $logDir . '/' . $catdir) && !mkdir($logDir . '/' . $catdir,0777)){
	    printf("ERROR : Can't create log sub[%s] directory.\n",$logDir . '/' . $catdir);
	    exit 1;
	}
	CtTbCtiSet('SC,ScenarioInfo,CategoryDir',$catdir,'T');
	CtTbCtiSet('SC,ScenarioInfo,DateDir',$datedir,'T');
    }
    else{
	CtTbCtiSet('SC,ScenarioInfo,DateDir',$logID,'T');
    }
    # 
    if($logID && !(-e $logDir . '/' . $logID)){
	if(!mkdir($logDir . '/' . $logID,0777)){
	    printf("ERROR : Can't create log sub[%s] directory.\n",$logDir . '/' . $logID);
	    exit 1;
	}
    }
}

## DEF.VAR
# 
$ScenarioListFile="scenario.lst";
%ScenarioList;
%CategoryList;
## DEF.END

# 
sub CtScReadInfo {
    my ($id)=@_;
    my (%opt,$cmd,$rc);

    if( !open( SCENARIOLIST, $ScenarioListFile ) ){
	MsgPrint( 'WAR',"Error : Scenario file[%s] open fail.\n", $ScenarioListFile);
	return;
    }
    while(<SCENARIOLIST>){
	if( /^\s*#.*$/ ){next;}
	elsif( /^Category\s+(\S+)\s+(\S+)\s+(.*)$/i ){
	    $CategoryList{$1}={'Title'=>$2,'Info'=>$3};
	}
	elsif( /^Scenario\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(.*)$/i ){
	    $ScenarioList{$2}={'Category'=>$1,'File'=>$3,'Title'=>$4,'Info'=>$5};
	}
    }
    close(SCENARIOLIST);
    if(!$ScenarioList{$id}){
	MsgPrint( 'WAR',"Error : Scenario ID[%s] mismatch in scenario.lst .\n",$id );
	return;
    }
    return $ScenarioList{$id}->{'Title'},$ScenarioList{$id}->{'Info'},
	$CategoryList{$ScenarioList{$id}->{'Category'}}->{'Title'},$CategoryList{$ScenarioList{$id}->{'Category'}}->{'Info'};
}

# 
sub CtUtLoadSimData {
    my($simpath)=@_;
    eval 'require SIMTarget;';
    if($@){MsgPrint('ERR'," Can't load SIMTarget.pm\n");}
    unless($simpath){
	$0 =~ s/^\.\///i;
	$0 =~ /([^\/]+)\.seq$/;
	$simpath = 'sim/SIM_' . $1. '.pm';
	unless(-e $simpath){$simpath = 'SIM_' . $1. '.pm'}
    }
    if($simpath !~ /^\//){
        $simpath = './' . $simpath;
    }
    eval "require '" . $simpath . "'";
    if($@){
        MsgPrint('ERR'," Can't load Simulate file [%s]\n",$simpath);
        exit;
    }
    
    # 
    $SIG{'INT'}='';
}

#=================================
# GUI
#=================================
sub CtGuiLoad {
    eval("use Gtk2;use Glib qw(TRUE FALSE);");
    if($@){
        return 'NG';
    }
    Gtk2->init();
    return;
}

# type:   info|warning|question|error|other
# button: none|ok|close|cancel|yes-no|ok-cancel
sub CtGuiMessageBox {
    my($type,$button,$message,@args)=@_;
    $type = $type || 'other';
    $button = $button || 'ok';
    my $flag = 'modal'; # 'destroy-with-parent',
    my $dialog = Gtk2::MessageDialog->new (undef,$flag,$type,$button,$message,@args);
    $dialog->set_keep_above(TRUE);
    my $response = $dialog->run;
    $dialog->destroy;
    CtGuiEventLoop();
    return $response;
}

# 
sub CtGuiEventLoop {
    my($time)=@_;
    my($startTime,$diff);

    $time = $time || 1.0;
    $startTime = [Time::HiRes::gettimeofday()];
    do{
	Gtk2->main_iteration_do('');
	$diff=Time::HiRes::tv_interval($startTime, [Time::HiRes::gettimeofday()]);
    }while($diff<$time);
}

#=================================
# 
#=================================
sub CtIsReceived {
    return (@_[0] eq 'recv' || @_[0] eq 'OK');
}
sub CtIsUnReceived {
    return (@_[0] eq 'recv' || @_[0] eq 'OK') ? '' : 'OK';
}
sub CtRlJudgeSeq {
    my($result,$ok,$ng,$exitMode,$noExit)=@_;
    if($result eq 'recv' || $result eq 'OK'){
	CtLgOK($ok) if($ok);
    }
    elsif($result eq 'recv'){
	return;
    }
    else{
	if($exitMode eq 'Warn') {
		CtLgWarn($ng);
		MsgPrint('WAR', "$ng\n");
	}
	else {
		CtLgNG($ng);
		MsgPrint('ERR', "$ng\n");
	}
	CtScExit('Fail') unless($noExit);
    }
}

# 
sub CtRlJudge {
    my($rule,$hexSt,$sceInfo,$addrule,$delrule,$node,$mode)=@_;
    return CtRlJudgeIn($rule,$hexSt,$sceInfo,$addrule,$delrule,$node,$mode);
}
sub CtRlJudgeIn {
    my($rule,$hexSt,$sceInfo,$addrule,$delrule,$node,$mode)=@_;
    my($context,$result,$ret,$item,$OK);

    unless($hexSt){$hexSt=$DIRRoot{'LASTPKT'};}
    unless($node){$node=$DIRRoot{'ACTND'};}

    if(CtLgLevel('RULE')){CtLgAdd('RULE','<pre>');}

    # 
    $rule = CtRlModify($rule,$addrule,$delrule);

    # 
    $context={'RULE-RESULT'=>[],'RULE-SKIP'=>[],'Node'=>$node};
    if($sceInfo){$context={%$context,%$sceInfo}};

    # 
    $result=CtRlEval($rule,$hexSt,$context);

    if(CtLgLevel('RULE')){CtLgAdd('RULE','</pre>');LOGMarge('RULE','RUN');}
    if(CtLgLevel('EXCUTERULE')){CtRlAddExecuteRule($rule,$hexSt,$context);}

    # 
    # PrintVal($context->{'RULE-RESULT'});

    # 
    foreach $item (@$result){
	if($item->{'RE'} eq ''){
	    if($mode eq 'STOP'){
		MsgPrint('WAR',"Rule CtRlJudge is NG, scenario stop.\n");
		CtLgWarn("Rule CtRlJudge is NG, scenario stop.\n");
		CtScExit('Fail');
	    }
	    else{
		MsgPrint('WAR',"Rule CtRlJudge is NG, but continue...\n");
	    }
	}
    }
    return $result, $context->{'RULE-RESULT'};
}
sub CtLgJudgeMsg {
    if(CtLgLevel('RULE')){CtLgAdd('RULE','<pre>');}
    CtRlAddJudgeLogNoEval(@_);
    CtRlAddExecuteJudgeMsg(@_[0]);
    if(CtLgLevel('RULE')){CtLgAdd('RULE','</pre>');LOGMarge('RULE','RUN');}
}


#=================================
# 
#=================================
# 

#=================================
# 
#=================================
# 
sub CtRlPKTRange {
    my($cap,$rangeType,$start,$end)=@_;
    my($count);
    if(!$rangeType || $rangeType eq 'INDEX'){
	if( ($count=$#$cap)<0 ){return '';}
	if($start eq 'top' || $start eq ''){$start=0;}
	elsif($start eq 'last')            {$start=$count;}
	elsif($start eq 'before')          {if($count eq 0){return '';} $start=$count-1;}
	if($end eq 'top')                  {$end=0;}
	elsif($end eq 'last' || $end eq ''){$end=$count;}
	elsif($end eq 'before')            {if($count eq 0){return '';} $end=$count-1;}
    }
    elsif($rangeType eq 'TS'){
	$start=0 unless($start);
	$end=time() unless($end);
    }
    return $start,$end;
}

# 
sub CtRlPKTMatch {
    my($cap,$index,$match)=@_;
    my($field,$val,$item,$P,$hexSt,$val2,$i);
    $hexSt=$cap->{'Frame'};
    if(ref($match) eq 'ARRAY'){
	for($i=0;$i<=$#$match;$i+=2){
	    $val=CtFlGet($match->[$i],$hexSt);
##	    printf("--------[%s:%s][%s]-------\n",$match->[$i],$val,$match->[$i+1]);
#	    PrintVal($val);
	    # 
	    if(ref($val) eq 'ARRAY'){
		if(!ref($match->[$i+1])){
		    if(!grep{$match->[$i+1] eq $_} @$val){return;}
		}
		else{
		    foreach $val2 (@{$match->[$i+1]}){
			if(!grep{$val2 eq $_} @$val){return;}
		    }
		}
	    }
	    else{
		# 
		if(ref($match->[$i+1])){
		    if(!grep{$val eq $_} @{$match->[$i+1]}){return;}
		}
		elsif($val ne $match->[$i+1]){return;}
	    }
	}
	return $hexSt;
    }
    elsif(ref($match) eq 'SCALAR'){
	@_=($P=$hexSt,@_);
	if( eval $$match ){return $hexSt;}
    }
    elsif(!ref($match)){ # 
	if($match =~ /(.+?):(.+)/){
	    $field=$1;$val=$2;
	    if($cap->{$field} eq $val){return $hexSt;}
	}
    }
    elsif(ref($match) eq 'CODE'){
	if( &$match($hexSt,$cap,$index) ){return $hexSt;}
    }
}

# 
#   
#     
#     
#     
#     
#     
#     
#        [
#        
sub CtRlPKTGet {
    my($capType,$rangeType,$start,$end,$dir,$match)=@_;
    my($cap,$i,$hexSt);

    # 
    $cap=CtScCaptBuffer($capType);
    return if( $#$cap<0 );

    # 
    ($start,$end)=CtRlPKTRange($cap,$rangeType,$start,$end);

    # 
    if(!$rangeType || $rangeType eq 'INDEX'){
	# 
	if($start<=$end){
	    for($i=$start;$i<=$end;$i++){
		if($dir){
		    if($dir eq 'in'  && $cap->[$i]->{'Direction'} ne 'in'){next;}
		    if($dir eq 'out' && $cap->[$i]->{'Direction'} ne 'out'){next;}
		}
		if($hexSt=CtRlPKTMatch($cap->[$i],$i,$match)){return $hexSt;}
	    }
	}
	else{
	    for($i=$start;$end<=$i;$i--){
		if($dir){
		    if($dir eq 'in'  && $cap->[$i]->{'Direction'} ne 'in'){next;}
		    if($dir eq 'out' && $cap->[$i]->{'Direction'} ne 'out'){next;}
		}
		if($hexSt=CtRlPKTMatch($cap->[$i],$i,$match)){return $hexSt;}
	    }
	}
    }
    # 
    elsif($rangeType eq 'TS'){
	for($i=0;$i<=$#$cap;$i++){
	    if($cap->[$i]->{'Frame'}->{'#TimeStamp#'}<$start){next;}
	    if($end<$cap->[$i]->{'Frame'}->{'#TimeStamp#'}){next;}
	    if($dir){
		if($dir eq 'in'  && $cap->[$i]->{'Direction'} ne 'in'){next;}
		if($dir eq 'out' && $cap->[$i]->{'Direction'} ne 'out'){next;}
	    }
	    if($hexSt=CtRlPKTMatch($cap->[$i],$i,$match)){return $hexSt;}
	}	
    }
    return;
}

# 

# 

# 

# 

# 

# 
sub CtLgMarker1 {
    my($name,$comment)=@_;
    push(@MakerPackets,{'MARK'=>T,'Frame'=>{'#TimeStamp#'=>CtUtGetTimeStamp()},'PktName'=>$name,'FrameName'=>'MARK1','Comment'=>$comment});
}
sub CtLgMarker2 {
    my($name,$comment)=@_;
    push(@MakerPackets,{'MARK'=>T,'Frame'=>{'#TimeStamp#'=>CtUtGetTimeStamp()},'PktName'=>$name,'FrameName'=>'MARK2','Comment'=>$comment});
}
sub CtLgMarker3 {
    my($name,$comment)=@_;
    push(@MakerPackets,{'MARK'=>T,'Frame'=>{'#TimeStamp#'=>CtUtGetTimeStamp()},'PktName'=>$name,'FrameName'=>'MARK3','Comment'=>$comment});
}

#============================================
# 
#============================================
sub CtScAddCapt {
    my($node,$inetSt,$dir,$connID,$type,$name,$comment,$frameID,$etc)=@_;
    my($msg,$conn);

    $conn=CtCnGet($connID);

    # 
    $msg={'Type'=>$type,'Direction'=>$dir,'Frame'=>$inetSt,'Time'=>$inetSt->{'#TimeStamp#'},
	  'PktName'=>$name,'Comment'=>$comment,'NodeID'=>$node->{'ID'},'FrameName'=>$frameID,
	  'Session'=>$conn->{'status'},'ConnID'=>$connID,%$etc};
    push(@{$node->{'PKTS'}},$msg);
    $inetSt->{'#Direction#'} = $dir;

    # 
    $node->{$dir eq 'in' ? 'LASTRVPKT' : 'LASTSDPKT'}=$inetSt;
    $inetSt->{'#IDX#'}=$#{$node->{'PKTS'}};
    return $msg;
}
# 
# 
#   
sub CtScAddCaptContext {
    my($node,$title,$context)=@_;
    my($cap);
    if($node && !ref($node)){
	$node=CtNDFromName($node);
    }
    else{
	$node = $node || CtNDFromName(CtNDAct());
    }
    $cap=$node->{'PKTS'};
    unless($cap->[$#$cap]->{'Context'}){
	$cap->[$#$cap]->{'Context'}=[];
    }
    push(@{$cap->[$#$cap]->{'Context'}},{'title'=>$title,'context'=>$context});
}
# perl
sub CtContextToText {
    my($cntx)=@_;
    my($txt);
    if(ref($cntx)){
	tie *STDOUT, "STDTRAP";
	PrintVal($cntx,'','#NOTITLE#',1);
	while(<STDOUT>){$txt = $_ . $txt};
	untie *STDOUT;
	$txt =~ s/\n/\r\n/g;
    }
    else{
	$txt = ' ' . $cntx;
	$txt =~ s/\n/\r\n /g;
    }
    return $txt;
}

#============================================
# 
#============================================
sub CtScAddUnknownCapt {
    my($inetSt,$dir,$connID,$name,$comment,$frameID)=@_;
    my($timeStamp,$msg);

    $timeStamp=$inetSt->{'#TimeStamp#'}?$inetSt->{'#TimeStamp#'}:CtUtGetTimeStamp();
    # 
    $msg={'Type'=>'UN','Direction'=>$dir,'Frame'=>$inetSt,'Time'=>$timeStamp,'PktName'=>$name,'FrameName'=>$frameID,
	  'ConnID'=>$connID,'Comment'=>$comment};
    push(@UNKnownPackets,$msg);
    $inetSt->{'#IDX#'}=$#UNKnownPackets;
}

sub CtScCaptBuffer ($){
    my($node)=@_;
    if($node eq 'UN'){return \@UNKnownPackets;}
    if($node){return CtNDPkts($node);}
    return CtUtCapPktNumbering();
}
# 
sub SetPktComment {
    my($hexSt,$comment,$level)=@_;
    my($cap,$msg);
    if( $cap=CtRlPKTCapinfo($hexSt) ){
	if($comment){
	    $cap->{'Comment'}='<font color="' . $LOG_COLOR{$level} . '">' . CtLgCnvHTML($comment) . '</font>';
	}
	else{
	    if($cap->{'Comment'} =~ /$\<font color/){
		$msg='<font color="' . $LOG_COLOR{$level} . '">';
		$cap->{'Comment'} =~ s/$\<font color=\".+\"\>/$msg/;
	    }
	    else{
		$cap->{'Comment'}='<font color="' . $LOG_COLOR{$level} . '">' . $cap->{'Comment'} . '</font>';
	    }
	}
    }
}
# 
sub CtScSetPktName {
    my($hexSt,$pktname)=@_;
    my($cap);
    if( $cap=CtRlPKTCapinfo($hexSt) ){$cap->{'PktName'} = $pktname;}    
}
# 
sub CtScSetPktFrName {
    my($hexSt,$name)=@_;
    my($cap);
    if( $cap=CtRlPKTCapinfo($hexSt) ){$cap->{'FrameName'} = $name;}    
}

# 
sub CtScGeneratePktName {
    my($hexSt)=@_;
    my($node,$dir,$peer,$addr);
    if($hexSt->{'NodeID'}){
	$node=CtNDFromName($hexSt->{'NodeID'});
    }
    else{
	# 
	$addr=CtFlGet('INET,#IP4,DstAddress',$hexSt->{'Frame'}) || CtFlGet('INET,#IP6,DstAddress',$hexSt->{'Frame'});
	$node=CtNDGetFromAddr($addr);
    }
    $dir=$hexSt->{'Direction'};
    $peer=$node->{'REL'}->{'LINK'};
    return $dir eq 'in' ? ($peer . ':' . $node->{'ID'}) : ($node->{'ID'} . ':' . $peer) ;
}

#============================================
# 
#============================================
sub CtUtGetTimeStamp {
    my(@tim,$startTime);
    @tim=Time::HiRes::gettimeofday();
    return @tim[0] . sprintf(".%06d",@tim[1]);
}

# 

# EtherReal

# EtherReal
#   TCPdump => [{'interface'=>'eth0','outfile'=>XXXX,'size'=>1500,'count'=>5000},{'interface'=>'eth1'}]

# 

# 

# 

# 
sub CtRlPKTCapinfo ($){
    my($hexSt)=@_;
    my($caps,$cap,$pkt);
    $caps=NDAllPktsInfo();
    push(@$caps,\@UNKnownPackets);
    foreach $cap (@$caps){
	foreach $pkt (@$cap){
	    if($pkt->{'Frame'} eq $hexSt){return $pkt;}
	}
    }
    return;
}

# 
sub CtUtCapPktNumbering {
    my(@pkts,$pkt,$index);

    # 
    @pkts=sort{$a->{'Frame'}->{'#TimeStamp#'} <=> $b->{'Frame'}->{'#TimeStamp#'}}(@UNKnownPackets,@{CtNDPkts()},@MakerPackets);

    # 
    foreach $pkt (@pkts){
	$pkt->{'Frame'}->{'#ID#'}=++$index;
    }
    return \@pkts;
}
# 
sub CtLgSeqMarker {
    my($maker,$name,$comment)=@_;
    my($time);
    $time=CtUtGetTimeStamp();
    push(@MakerPackets,{'MARK'=>T,'Time'=>$time,'Frame'=>{'#TimeStamp#'=>$time},'PktName'=>$name,'FrameName'=>$maker,'Comment'=>$comment});
}

# 
sub CtLgJudgeAndPkt {
    my($pkts,$startTime,$ctx)=@_;
    my($i,$msg,$j,@sortMsg,$category,$total,$error,$warning,$pkgMsg,$skip,$params);

    $params=CtTbCti('SC,LOGTMP,PKTDUMP');
    for $i (0..$#$pkts+10){

	# 
	if(!$pkts->[$i]->{'MARK'} && $pkts->[$i]->{'Frame'}){
	    @$pkgMsg=();
	    $skip=$params->{'SKIP'}->{$pkts->[$i]->{'Type'}};
	    CtPkText($pkts->[$i]->{'Frame'},$pkgMsg,0,{'pkt'=>$pkts->[$i]->{'Frame'},'SKIP'=>$skip,%$ctx});
	    CtLgPkt($pkgMsg,$i+1,$pkts->[$i]->{'Direction'},$pkts->[$i]->{'PktName'},$pkts->[$i]->{'Frame'}->{'#TimeStamp#'},$startTime);
	}

	# 
	if($pkts->[$i]->{'Context'}){
	    my $cntx,$val;
	    foreach $cntx (@{$pkts->[$i]->{'Context'}}){
		$val=CtContextToText($cntx->{'context'});
		CtLgOutDirect(sprintf("</TD></TR>\n<TR bgcolor=\"#FDD8D8\"><TD><CENTER>%s</CENTER></TD><TD><pre>%s</pre></TD></TR>\n",
				      $cntx->{'title'},$val));
	    }
	}

	# 
	$msg=[];
	map{push(@$msg,$_) if($_->{'PKT'}->{'#ID#'} eq $i+1)} @JUDGEMENTLog;

	if(-1<$#$msg){
	    # 
##	    CtLgOutDirect(sprintf('<TR><TD> <A HREF="#SEQ%03d">Judge%03d</A> : <A HREF="#PKT%03d">%s</A> </TD><TD><A NAME="JUDGE%03d"></A>%s',
	    CtLgOutDirect(sprintf('<TR><TD> <A HREF="#SEQ%0'.$PKTMAX.'d">Judge%0'.$PKTMAX.'d</A> : <A HREF="#PKT%0'.$PKTMAX.'d">%s</A> </TD><TD><A NAME="JUDGE%0'.$PKTMAX.'d"></A>%s',
				 $i+1,$i+1,$i+1,$pkts->[$i]->{'PktName'},$i+1,"\n"));

	    # 
	    $category=CtRlFindCatListFromID($msg->[0]->{'ID'});

	    # 
	    @sortMsg = sort {
		my($od1,$od2);
		$od1=int($category->{CtRlCategory($a->{'ID'})}->{'OD'});
		$od2=int($category->{CtRlCategory($b->{'ID'})}->{'OD'});
		if( $od1 < $od2 ){return -1;}
		if( $od1 > $od2 ){return 1;}
		return 0;} @$msg;
	    for $j (0..$#sortMsg){
		if(@sortMsg[$j]->{'MSG'}){CtLgOutDirect(@sortMsg[$j]->{'MSG'} . "\n");}
	    }

	    # 
	    ($total,$error,$warning)=CtRlAccSyntaxLog($msg);
	    CtLgOutDirect(sprintf("</TD></TR>\n<TR bgcolor=\"#DCDCDC\"><TD><CENTER>Total</CENTER></TD><TD>Evaled Rule count[%d] Error[%d] Warning[%d]<BR></TD></TR>\n",$total,$error,$warning));
	}
    }
    $msg=[];
    map{push(@$msg,$_) if(!($_->{'PKT'}) || $_->{'PKT'}->{'#ID#'} eq '')} @JUDGEMENTLog;
    if(-1<$#$msg){
	# 
	CtLgOutDirect('<TR><TD> Judge : sequence</TD><TD>');
	
	# 
	$category=CtRlFindCatListFromID($msg->[0]->{'ID'});
	
	# 
	@sortMsg = sort {
	    my($od1,$od2);
	    $od1=int($category->{CtRlCategory($a->{'ID'})}->{'OD'});
	    $od2=int($category->{CtRlCategory($b->{'ID'})}->{'OD'});
	    if( $od1 < $od2 ){return -1;}
	    if( $od1 > $od2 ){return 1;}
	    return 0;} @$msg;
	for $j (0..$#sortMsg){
	    if(@sortMsg[$j]->{'MSG'}){CtLgOutDirect(@sortMsg[$j]->{'MSG'});}
	}
	# 
	($total,$error,$warning)=CtRlAccSyntaxLog($msg);
	CtLgOutDirect(sprintf("</TD></TR>\n<TR bgcolor=\"#DCDCDC\"><TD><CENTER>Total</CENTER></TD><TD>Evaled Rule count[%d] Error[%d] Warning[%d]<BR></TD></TR>\n",$total,$error,$warning));
    }
    CtRlClearSyntaxLog();
}

# 
sub CtLgJudge{
    my($pkts)=@_;
    my($i,$msg,$j,@sortMsg,$category,$total,$error,$warning);

    for $i (0..$#$pkts+10){
	$msg=[];
	map{push(@$msg,$_) if($_->{'PKT'}->{'#ID#'} eq $i+1)} @JUDGEMENTLog;

	if(-1<$#$msg){
	    # 
##	    CtLgOutDirect(sprintf('<TR><TD> <A HREF="#SEQ%03d">Judge%03d</A> : <A HREF="#PKT%03d">%s</A> </TD><TD><A NAME="JUDGE%03d"></A>%s',
	    CtLgOutDirect(sprintf('<TR><TD> <A HREF="#SEQ%0'.$PKTMAX.'d">Judge%0'.$PKTMAX.'d</A> : <A HREF="#PKT%0'.$PKTMAX.'d">%s</A> </TD><TD><A NAME="JUDGE%0'.$PKTMAX.'d"></A>%s',
				 $i+1,$i+1,$i+1,$pkts->[$i]->{'PktName'},$i+1,"\n"));

	    # 
	    $category=CtRlFindCatListFromID($msg->[0]->{'ID'});

	    # 
	    @sortMsg = sort {
		my($od1,$od2);
		$od1=int($category->{CtRlCategory($a->{'ID'})}->{'OD'});
		$od2=int($category->{CtRlCategory($b->{'ID'})}->{'OD'});
		if( $od1 < $od2 ){return -1;}
		if( $od1 > $od2 ){return 1;}
		return 0;} @$msg;
	    for $j (0..$#sortMsg){
		if(@sortMsg[$j]->{'MSG'}){CtLgOutDirect(@sortMsg[$j]->{'MSG'} . "\n");}
	    }

	    # 
	    ($total,$error,$warning)=CtRlAccSyntaxLog($msg);
	    CtLgOutDirect(sprintf("</TD></TR>\n<TR bgcolor=\"#DCDCDC\"><TD><CENTER>Total</CENTER></TD><TD>Evaled Rule count[%d] Error[%d] Warning[%d]<BR></TD></TR>\n",$total,$error,$warning));
	}
    }
    $msg=[];
    map{push(@$msg,$_) if(!($_->{'PKT'}) || $_->{'PKT'}->{'#ID#'} eq '')} @JUDGEMENTLog;
    if(-1<$#$msg){
	# 
	CtLgOutDirect('<TR><TD> Judge : sequence</TD><TD>');
	
	# 
	$category=CtRlFindCatListFromID($msg->[0]->{'ID'});
	
	# 
	@sortMsg = sort {
	    my($od1,$od2);
	    $od1=int($category->{CtRlCategory($a->{'ID'})}->{'OD'});
	    $od2=int($category->{CtRlCategory($b->{'ID'})}->{'OD'});
	    if( $od1 < $od2 ){return -1;}
	    if( $od1 > $od2 ){return 1;}
	    return 0;} @$msg;
	for $j (0..$#sortMsg){
	    if(@sortMsg[$j]->{'MSG'}){CtLgOutDirect(@sortMsg[$j]->{'MSG'});}
	}
	# 
	($total,$error,$warning)=CtRlAccSyntaxLog($msg);
	CtLgOutDirect(sprintf("</TD></TR>\n<TR bgcolor=\"#DCDCDC\"><TD><CENTER>Total</CENTER></TD><TD>Evaled Rule count[%d] Error[%d] Warning[%d]<BR></TD></TR>\n",$total,$error,$warning));
    }
    CtRlClearSyntaxLog();
}

sub CtUtLogPkts {
    my($pkts,$startTime)=@_;
    my($pkgMsg,$no,$pkt,$skip,$params);

    $params=CtTbCti('SC,LOGTMP,PKTDUMP');
    $no=1;
    foreach $pkt (@$pkts){
	unless($pkt->{'MARK'}){
	    @$pkgMsg=();
	    $skip=$params->{'SKIP'}->{$pkt->{'Type'}};
	    CtPkText($pkt->{'Frame'},$pkgMsg,0,{'pkt'=>$pkt->{'Frame'},'SKIP'=>$skip});
	    CtLgPkt($pkgMsg,$no,$pkt->{'Direction'},$pkt->{'PktName'},$pkt->{'Frame'}->{'#TimeStamp#'},$startTime);
	}
	$no++;
    }
}

sub CtLgPkt {
    my($pkgMsg,$no,$dir,$pktName,$timeStamp,$startTime)=@_;
    my($field,$msg,$name,$bgcolor,$val,$result);

    $bgcolor= $dir eq 'in' ? ' bgcolor="#F0F0D0"':'';
##    $name=sprintf("<CENTER><A HREF=\"#SEQ%03d\">%s</A>%s:<A HREF=\"#JUDGE%03d\"><font color=\"red\">%03d</font></A></CENTER>", 
    $name=sprintf('<CENTER><A HREF="#SEQ%0'.$PKTMAX.'d">%s</A>%s:<A HREF="#JUDGE%0'.$PKTMAX.'d"><font color="red">%0'.$PKTMAX.'d</font></A></CENTER>', 
		  $no,CtLgCnvHTML($dir eq 'in' ? '<<<':'>>>'), $pktName, $no, $no);
#    CtLgOutDirect('</TD></TR><TR'.$bgcolor.'><TD>'.$name.'</TD><TD><A NAME="PKT'. sprintf("%02d",$no) .'"></A>');
    CtLgOutDirect('<TR'.$bgcolor.'><TD>'.$name.'</TD><TD><A NAME="PKT'. sprintf('%0'.$PKTMAX.'d',$no) .'"></A>');
    CtLgOutDirect(sprintf("<pre>TimeStamp:%s (%s)\n\n",$timeStamp,$timeStamp-$startTime));

    foreach $field (@$pkgMsg){
	if($field->{'Node'}){
#	    $msg = sprintf("%s<font color=\"red\">%s</font>\n",'  ' x $field->{'Level'},$field->{'Node'});
	    $msg = sprintf("%s<B>%s</B>\n",'  ' x $field->{'Level'},$field->{'Node'});
	    $result.=CtLgOutDirect($msg);
	}
	# 
	elsif($field->{'Value'} ne ''){
	    # HTML
	    $val=$field->{'Value'};
	    if(ref($val)){
		$val=$$val;
	    }
	    else{
		$val=CtLgCnvHTML($val);
	    }
	    $msg = sprintf("%s%s : <font color=\"blue\">%s</font>\n",'  ' x $field->{'Level'}, $field->{'Field'},$val);
	    $result.=CtLgOutDirect($msg);
	}
    }
#    CtLgOutDirect('</pre>');
    CtLgOutDirect('</pre></TD></TR>');
    return $result;
}


#=================================
# 
#=================================
END {
    MsgPrint('INIT',"END block exit code[%s]\n",$?);
    CtScExitSignalTrap();
}


1;
