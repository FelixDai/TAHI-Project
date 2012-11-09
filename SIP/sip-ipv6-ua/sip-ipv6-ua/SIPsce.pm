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

# 
# 08/6/17 
#   GetSrcID:

#=================================
# 
#=================================

%RuleCategory = 
( 'Request'=>{'OD:'=>10},
  'Status'=>{'OD:'=>10},
  'Header'=>{             'OD:'=>30},
  'Body'=>{               'OD:'=>40},
  'Timer'=>{              'OD:'=>50},
  'UDP'=>{                'OD:'=>60},
  'TCP'=>{                'OD:'=>60},
  'TLS'=>{                'OD:'=>60},
  'RTP'=>{                'OD:'=>60},
  'SIP'=>{                'OD:'=>60},
  'Accept'=>{             'OD:'=>31},
  'Accept-Encoding'=>{    'OD:'=>31},
  'Accept-Language'=>{    'OD:'=>31},
  'Alert-Info'=>{         'OD:'=>31},
  'Allow'=>{              'OD:'=>31},
  'Authentication-Info'=>{'OD:'=>31},
  'Authorization'=>{      'OD:'=>31},
  'Call-ID'=>{            'OD:'=>31},
  'Call-Info'=>{          'OD:'=>31},
  'Contact'=>{            'OD:'=>31},
  'Content-Disposition'=>{'OD:'=>32},
  'Content-Encoding'=>{   'OD:'=>32},
  'Content-Language'=>{   'OD:'=>32},
  'Content-Length'=>{     'OD:'=>35},
  'Content-Type'=>{       'OD:'=>32},
  'CSeq'=>{               'OD:'=>31},
  'Date'=>{               'OD:'=>31},
  'Error-Info'=>{         'OD:'=>31},
  'Expires'=>{            'OD:'=>31},
  'From'=>{               'OD:'=>31},
  'In-Reply-To'=>{        'OD:'=>31},
  'Max-Forwards'=>{       'OD:'=>31},
  'MIME-Version'=>{       'OD:'=>31},
  'Min-Expires'=>{        'OD:'=>31},
  'Organization'=>{       'OD:'=>31},
  'Priority'=>{           'OD:'=>31},
  'Proxy-Authenticate'=>{ 'OD:'=>31},
  'Proxy-Authorization'=>{'OD:'=>31},
  'Proxy-Require'=>{      'OD:'=>31},
  'Record-Route'=>{       'OD:'=>31},
  'Reply-To'=>{           'OD:'=>31},
  'Require'=>{            'OD:'=>31},
  'Retry-After'=>{        'OD:'=>31},
  'Route'=>{              'OD:'=>31},
  'Server'=>{             'OD:'=>31},
  'Subject'=>{            'OD:'=>31},
  'Supported'=>{          'OD:'=>31},
  'Timestamp'=>{          'OD:'=>31},
  'To'=>{                 'OD:'=>31},
  'Unsupported'=>{        'OD:'=>31},
  'Unsupported'=>{        'OD:'=>31},
  'User-Agent'=>{         'OD:'=>31},
  'Via'=>{                'OD:'=>31},
  'Warning'=>{            'OD:'=>31},
  'WWW-Authenticate'=>{   'OD:'=>31},
  'Privacy'=> {           'OD:'=>31},
  'P-Preferred-Identity'=>{'OD:'=>31},
  'P-Asserted-Identity'=>{'OD:'=>31},
  'a='=>{                 'OD:'=>41},
  'c='=>{                 'OD:'=>41},
  'm='=>{                 'OD:'=>41},
  'o='=>{                 'OD:'=>41},
  's='=>{                 'OD:'=>41},
  't='=>{                 'OD:'=>41},
  'v='=>{                 'OD:'=>41});

#=================================
# Config.txt
#=================================
sub SIPLoadConfig {
    my($filename);

    # 
    open(CONFIG_TXT, "config.txt");
    while (<CONFIG_TXT>) {
	if( /^\s*#/ ){
	    next;
	}
	if( /^(\S+)\s+(\S*)\s*$/ ){
	    $CNT_CONF{$1} = $2;
	}
    }
    close(CONFIG_TXT);
    @SIPrexDEBUG=split(',',$CNT_CONF{'LOG-LEVEL'});

    # 
    $filename=lc(sprintf("config.%s%s",$SIP_PL_IP,$SIP_PL_TARGET));
    if(-e $filename){
	MsgPrint('INF',"Load Package config file[$filename]\n");
	open(CONFIG_TXT, $filename);
	while (<CONFIG_TXT>) {
	    if( /^\s*#/ ){
		next;
	    }
	    if( /^(\S+)\s+(\S*)\s*$/ ){
		$CNT_CONF{$1} = $2;
	    }
	}
	close(CONFIG_TXT);
    }

    @SIPrexDEBUG=split(',',$CNT_CONF{'LOG-LEVEL'});  # ERR,WAR,INF,DBG
    if( $SIM_Support_HiRes && !grep{$_ eq 'TIME'} @SIPrexDEBUG ){$SIM_Support_HiRes='';}


### 20050427 usako add start ###
	if ($SIP_PL_TARGET eq 'PX') {
		SIPLoadConfigForPX();	### 20050418 usako add
	}
### 20050427 usako add start ###

}

#=================================
# SIP
#=================================
$SIP_SIPKEY_FILE = "SIPKEY";
@NumberedKey = ('top','cat','dog','my','eye','www','sky','air','ice','hot','sea','sun','com','mon','lan','red',
		'UA','JP','all','bob','tom','txt','you','box','man','pub','pen','ink','foo','cal','top',
		'one','two','six','fax','tel','key','min','max','big','cup');
$CNT_TN_NAME = 'atlanta';

sub SIPLoadMagic {
    my($index)=@_;
    my($key,$num);
    # 
    if(!$index){
	open(IN,$SIP_SIPKEY_FILE);
	$index = <IN>;
	close(IN);
	$index++;
    }
    if($index eq 0){$index=1;}

    # 
    $num=$index;
    $key=@NumberedKey[$index % $#NumberedKey];
    return $key,$num;
}
sub SIPSaveMagic {
    my($index)=@_;
    #
    open(OUT, "> " . $SIP_SIPKEY_FILE);
    print OUT "$index\n";
    close(OUT);
}

#=================================
# SIP
#=================================
# addrType:IP6|IP4   protcol:UDP|TCP   judgmentRealMode:REAL|Nil
sub SIPInitializeScenario {
    my($otherNode,$ndpskip,$addrType,$protcol,$judgmentRealMode) = @_;
    my($ret);
    
    # Config.txt
    SIPLoadConfig();

    # 
    StartScenarioTime();

    # 
    SetupSIPParam();

    # 
    SipSeqDisplayInitilaize();

    # 
    $SIPJudgmentRealMode=$judgmentRealMode;

    # 
    SimulateTarget();

    # 
    CNT_Initilize();

    # 
    SipRuleDBInitilaize();

    # SIP
    SipParseInitilaize();

    # 
    SetNodeAddress($CVA_PX1_IPADDRESS,$CVA_RG_IPADDRESS,$CVA_PUA_IPADDRESS,$CVA_DNS_IPADDRESS,$CVA_ROUTER_PREFIX,$otherNode);

    # AAAA
    SetFQDNRecord();
    
    # DNS
    if(!$SIPLOGO && $SIP_PL_TARGET eq 'PX'){RegistDNS();}

    # 
    MakeFrameAttr();

    # 
    CreateDefNode();

    # NDP 
    if($SIPLOGO || $ndpskip || $SIP_PL_IP eq 4){return;}

    # 
    $ret=SQ_RA_Router();
    if($CVA_TUA_IPADDRESS eq ''){
	LOG_Err("ND AutoConfiguration sequence is invalid. ($ret)\n");
	ExitScenario('Fatal');
    }
    # 
    MakeFrameAttr($CVA_TUA_IPADDRESS);
    AddAAAA($CNT_TUA_HOSTNAME,$CVA_TUA_IPADDRESS);
    AddAAAA($CNT_CONF{'UA-HOSTNAME'},$CVA_TUA_IPADDRESS);

    # 
    if($SIP_ScenarioModel{'Regist'}){
	if(!SQ_Registra_Complete('','','','autoDNS')){
	    LOG_Err("Initial REGISTER sequecence does not complete. Sequence can't continue\n");
	    ExitScenario('Fatal');
	}
	else{
	    MsgPrint('INF',"REGISTER complete.\n");
	}
    }

    return $ret;
}

# 
sub SIPScenarioModel {
    if($SIP_PL_TARGET eq 'PX'){
	my($target,$topology)=@_;
	$NDTaget=$target;
	if(grep{$topology eq $_} ('UA-UA','UA-PX','PX-PX')){
	    $NDTopology=$topology;
	}
	else{
	    $NDTopology='UA-PX';
	}
    }
    if($SIP_PL_TARGET eq 'UA'){
	foreach (@_) {
	    if($_ =~ /^Caller$/i){$SIP_ScenarioModel{'Role'}='Caller';} #  Caller(
	    if($_ =~ /^Callee$/i){$SIP_ScenarioModel{'Role'}='Callee';}
	    if($_ =~ /^Register$/i){$SIP_ScenarioModel{'Role'}='Register';}
	    if($_ =~ /^2-Proxy$/i){$SIP_ScenarioModel{'Trapezoid'}='TWO';}
	    if($_ =~ /^1-Proxy$/i){$SIP_ScenarioModel{'Trapezoid'}='ONE';}
	    if($_ =~ /^Multi-Proxy$/i){$SIP_ScenarioModel{'Trapezoid'}='MULTIPUL';}
	    if($_ =~ /^NO-Proxy$/i){$SIP_ScenarioModel{'Trapezoid'}='NO';}
	    if($_ =~ /^Regist-Require$/i){$SIP_ScenarioModel{'Regist'}='T';}
	}
    }
}

# 
sub CreateDefNode {
    NDDefStart('REG');
    NDDefStart('PX1');
    NDDefStart('PX2');
    NDDefStart('UA1');
    NDDefStart('UA2');
    if( $SIP_ScenarioModel{'Role'} eq 'Register'){
	NDActive('REG');
    }
    else{
	NDActive('PX1');
    }
}

sub GetSrcID {
    my($src,$files,$file);
    if($SIP_PL_IP eq 6 && $SIP_PL_TARGET eq 'UA'){
	$files=['SIPtblUA6.pm','SIPruleUA.pm','SIPruleIG.pm','SIPseqUA6.pm'];
    }
    if($SIP_PL_IP eq 6 && $SIP_PL_TARGET eq 'PX'){
	$files=['SIPtblPX6.pm','SIPrulePX.pm','SIPrulePX2.pm','SIPrulePX3.pm','SIPruleIG.pm','SIPruleTTC.pm','SIPseqPX6.pm']
    }
    if($SIP_PL_IP eq 4 && $SIP_PL_TARGET eq 'UA'){
	$files=['SIPtblUA4.pm','SIPruleUA.pm','SIPruleIG.pm','SIPseqUA4.pm']
    }
    if($SIP_PL_IP eq 4 && $SIP_PL_TARGET eq 'PX'){
	$files=['SIPtblPX4.pm','SIPrulePX.pm','SIPrulePX2.pm','SIPrulePX3.pm','SIPruleIG.pm','SIPruleTTC.pm','SIPseqPX4.pm'];
    }
    push(@$files,$SIP_SEQ_FILE,'SIPrule.pm','SIPrule2.pm','SIPcntl.pm');
    foreach $file (@$files){
	if(!$file || !(-e $file)){
	    return "No file[$file]";
	}
	open(SRC,$file);
	while (<SRC>){$src .= $_;}
	close(SRC);
    }
    unless($src){return 'No file'}
    return md5_hex($src);
}
#=================================
# SIP
#=================================
sub SIPFinishScenario {
    my($total,$error,$warning);

    WaitUntilKeyPress("Finish Scenario normally.\nPress Enter Key and Next test(or Check log).");

    # 
    SIPReviveJudgment();

    # TAHI
    RecoverTahiPackets();

    # 
    LogSIPPktInfo();

    # 
    LogHTMLOutput();

    # 
    ($total,$error,$warning)=SyntaxRuleResultStatistics();
    
    # Config
    LogConfigInfo();

    # 
    if( $error ){
	ExitToV6evalTool($V6evalTool::exitFail);
    }
    if( $warning ){
	ExitToV6evalTool($V6evalTool::exitWarn);
    }
    ExitToV6evalTool($V6evalTool::exitPass);
}

#=================================
# SIP
#=================================
sub JudgeResult {
    if($SIP_PL_TARGET eq 'PX'){
	my($result,$ok,$ng,$exitMode)=@_;
	if($result ne 'OK' && $result ne "recv"){
	    if($exitMode eq 'Warn'){LOG_Warn($ng);}
	    else{LOG_Err($ng);}
#	    NDNodeDump();
	    ExitScenario($exitMode?$exitMode:'Fail');
	}else{
	    if($ok){LOG_OK($ok);}
	}
    }
    if($SIP_PL_TARGET eq 'UA'){ # 
	my($ok,$ng,$exitMode)=@_;
	if($result ne "OK"){
	    if($exitMode eq 'Warn'){LOG_Warn($ng);}
	    else{LOG_Err($ng);}
	    ExitScenario($exitMode?$exitMode:'Fail');
	}else{
	    if($ok){LOG_OK($ok);}
	}
    }
}

sub JudgeResultNG {
    my($ok,$ng,$exitMode)=@_;
    if($result eq "OK"){  # 
	if($exitMode eq 'Warn'){LOG_Warn($ng);}
	else{LOG_Err($ng);}
	ExitScenario($exitMode?$exitMode:'Fail');
    }else{
	LOG_OK($ok);
    }
}
# 
#   $mode:
sub SIP_Judgment {
    my($rule,$mode,$pktinfo,$addrule,$delrule,$evalTime)=@_;
    my($result,$ret,$item,$OK,%tmpContext);

    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }

    # 
    $rule = RuleModify($rule,$addrule,$delrule);

    $evalTime=$evalTime||$SIPJudgmentRealMode;
    # 
    if($evalTime eq 'REAL'){
	# 
	SIPAddJudgmentContext($pktinfo,$rule,$mode,SIPStoreSyntaxRuleEvalContext());
	# 
	$tmpContext{'EVAL-TIME'}=$evalTime;
	# 
	$result=EvalRule($rule,$pktinfo,\%tmpContext);
    }
    # 
    else{
	if(IsLogLevel('INF')){LogHTML("</TD></TR><TR><TD>Judgment</TD><TD>");}

	# 
	$result=EvalRule($rule,$pktinfo);

	# 
	OutputTAHIResultMessage($pktinfo);
    }

    # 
    foreach $item (@$result){
	if($item->{'RE:'} eq ''){
	    if($mode eq 'STOP' || $CNT_CONF{'FAILCONTINUE'} ne 'ON'){
		MsgPrint('WAR',"Rule Judgment is NG, scenario stop.\n");
		LOG_Warn("Rule Judgment is NG, scenario stop.\n");
		ExitScenario('Fail');
	    }
	    else{
		MsgPrint('WAR',"Rule Judgment is NG, but continue...\n");
	    }
	}
	if($item->{'EX:'}){
	    MsgPrint('INF',"Judgment after expression is[%s]\n",$item->{'EX:'});
	}
    }
    return $result;
}

#=================================
# 
#=================================
sub SipRuleDBInitilaize {
    # 
    MsgPrint('INF',"Load SIP Common Rule DB.\n");
    RegistRuleSet(\@SIPCommonRules);
    MsgPrint('INF',"Load SIP Common Rule2 DB.\n");
    RegistRuleSet(\@SIPCommonRules2);
	MsgPrint('INF',"Load SIP Transport-dependent Rule DB.\n");
    RegistRuleSet(\@SIPUATransportDependentRules);

	MsgPrint('INF',"Load RFC3262 (100rel) Rule DB.\n");
    RegistRuleSet(\@SIPUAExtend100relRules);
	MsgPrint('INF',"Load RFC3311 (UPDATE) Rule DB.\n");
    RegistRuleSet(\@SIPUAExtendUpdateRules);
	MsgPrint('INF',"Load RFC3323/3325 (Privacy) Rule DB.\n");
	RegistRuleSet(\@SIPUAExtendPrivacyRules);

    if($SIP_PL_TARGET eq 'UA'){
	MsgPrint('INF',"Load UA Rule DB.\n");
	RegistRuleSet(\@SIPUARules);
    }

	if ($SIP_PL_TRNS eq 'UDP') {
		MsgPrint('INF',"Load SIP UDP-dependent Rule DB.\n");
		RegistRuleSet(\@SIPUAUDPDependentRules);
	} elsif ($SIP_PL_TRNS eq 'TCP') {
		MsgPrint('INF',"Load SIP TCP-dependent Rule DB.\n");
		RegistRuleSet(\@SIPUATCPDependentRules);
	} elsif ($SIP_PL_TRNS eq 'TLS') {
		MsgPrint('INF',"Load SIP TLS-dependent Rule DB.\n");
		RegistRuleSet(\@SIPUATLSDependentRules);
	}

#    if($CNT_CONF{"SPECIFICATION"} eq 'IG' || $CNT_CONF{"SPECIFICATION"} eq 'TTC'){
    if($CNT_CONF{"SPECIFICATION"} eq 'IG'){
	eval("use SIPruleIG");
	if(!$@){
	    MsgPrint('INF',"Load Implementation Guideline Rule DB.\n");
	    RegistRuleSet(\@ImplementGuidelineRules);
	}
	else{
	    MsgPrint('ERR',"Implementation Guideline Rule can't loaded.\n");
	}
    }
    if($CNT_CONF{"SPECIFICATION"} eq 'TTC'){
#	eval("use SIPruleIGTTC");
	eval("use SIPruleTTC");
	if(!$@){
	    MsgPrint('INF',"Load TTC Rule DB.\n");
#	    RegistRuleSet(\@IGandTTCRules);
	    RegistRuleSet(\@TTCRules);
	}
	else{
	    MsgPrint('ERR',"TTC Rule can't loaded.\n");
	}
    }

    if($SIP_PL_TARGET eq 'PX'){
	MsgPrint('INF',"Load Proxy Rule DB.\n");
	RegistRuleSet(\@SIPPXRules);
    }
    RuleStatistics();
}

#=================================
# 
#=================================
sub SipSeqDisplayInitilaize {
    if($SIP_PL_IP eq 6){
	%SIP_SEQ_ARROW_STR = (
			      'SIPtoPROXY'                => '|-----|---->|     |     |     |     |     |',
			      'SIPtoREG'                  => '|-----|-----|-----|-----|-----|---->|     |',
			      'SIPtoTERM'                 => '|-----|-----|---->|     |     |     |     |',
			      'SIPtoOTHER1'               => '|-----|-----|-----|---->|     |     |     |',
			      'SIPtoOTHER2'               => '|-----|-----|-----|-----|---->|     |     |',
			      'SIPfromPROXY'              => '|<----|-----|     |     |     |     |     |',
			      'SIPfromREG'                => '|<----|-----|-----|-----|-----|-----|     |',
			      'SIPfromTERM'               => '|<----|-----|-----|     |     |     |     |',
			      'SIPfromOTHER1'             => '|<----|-----|-----|-----|     |     |     |',
			      'SIPfromOTHER2'             => '|<----|-----|-----|-----|-----|     |     |',
			      'SIPtoDNS'                  => '|<====|=====|=====|=====|=====|=====|====>|',
			      'RTPany'                    => '|<====|=====|====>|     |     |     |     |',
			      'RTPtoOTHER1'               => '|<====|=====|=====|====>|     |     |     |',
			      'EchoRequestFromServ'       => '|<----|-----|     |     |     |     |     |',
			      'EchoReplyToServ'           => '|-----|---->|     |     |     |     |     |',
			      'ICMPErrorFromPROXY'        => '|<----|-----|     |     |     |     |     |',
			      'ICMPErrorFromOTHER1'       => '|<----|-----|-----|-----|     |     |     |',
			      'Ra_RouterToAllNode'        => '|<----|     |     |     |     |     |     |',
			      'Ns_RouterToAllNode'        => '|<----|     |     |     |     |     |     |',
			      'Ns_TermLtoRouterG'         => '|---->|     |     |     |     |     |     |',
			      'Ns_TermLtoRouterL'         => '|---->|     |     |     |     |     |     |',
			      'Ns_TermGtoRouterMultiL'    => '|---->|     |     |     |     |     |     |',
			      'Ns_TermGtoRouterMultiL_TL' => '|---->|     |     |     |     |     |     |',
			      'Ns_TermLtoRouterMultiM'    => '|---->|     |     |     |     |     |     |',
			      'Na_TermAtoRouterG'         => '|---->|     |     |     |     |     |     |',
			      'Na_TermAtoRouterGOpt'      => '|---->|     |     |     |     |     |     |',
			      'Na_RouterGToTermL'         => '|<----|     |     |     |     |     |     |',
			      'Na_RouterLToTermG'         => '|<----|     |     |     |     |     |     |',
			      'Na_RouterLToTermG_TL'      => '|<----|     |     |     |     |     |     |',
			      'Na_RouterLToTermL'         => '|<----|     |     |     |     |     |     |',

			      'RTPtoTERM-S'               => '|-----|-----|---->|     |     |     |     |',
			      'RTPtoTERM-E'               => '|- - -|- - -|- - >|     |     |     |     |',
			      'RTPfromTERM-S'             => '|<----|-----|-----|     |     |     |     |',
			      'RTPfromTERM-E'             => '|< - -|- - -|- - -|     |     |     |     |',
			      'TARGETtoR'                 => '|---->|     |     |     |     |     |     |',
			      'RtoTARGET'                 => '|<----|     |     |     |     |     |     |',
			      'TARGETtoPX2'               => '|-----|-----|-----|---->|     |     |     |',
			      'TARGETtoREG'               => '|-----|-----|-----|-----|-----|---->|     |',
			      'TARGETtoUA1'               => '|-----|-----|---->|     |     |     |     |',
			      'TARGETtoUA2'               => '|-----|-----|-----|-----|---->|     |     |',
			      'TARGETtoDNS'               => '|-----|-----|-----|-----|-----|-----|---->|',
			      'PX1toTARGET'               => '|<----|-----|     |     |     |     |     |',
			      'PX2toTARGET'               => '|<----|-----|-----|-----|     |     |     |',
			      'REGtoTARGET'               => '|<----|-----|-----|-----|-----|-----|     |',
			      'UA1toTARGET'               => '|<----|-----|-----|     |     |     |     |',
			      'UA2toTARGET'               => '|<----|-----|-----|-----|-----|     |     |',
			      'DNStoTARGET'               => '|<----|-----|-----|-----|-----|-----|-----|',

			      'Timer'                     => '|*****|*****|*****|*****|*****|*****|*****|',
			      );
    }
    if($SIP_PL_IP eq 4){
	%SIP_SEQ_ARROW_STR = (
			      'SIP4toPROXY'                => '|-----|---->|     |     |     |     |     |',
			      'SIP4toREG'                  => '|-----|-----|-----|-----|-----|---->|     |',
			      'SIP4toTERM'                 => '|-----|-----|---->|     |     |     |     |',
			      'SIP4toOTHER1'               => '|-----|-----|-----|---->|     |     |     |',
			      'SIP4toOTHER2'               => '|-----|-----|-----|-----|---->|     |     |',
			      'SIP4fromPROXY'              => '|<----|-----|     |     |     |     |     |',
			      'SIP4fromREG'                => '|<----|-----|-----|-----|-----|-----|     |',
			      'SIP4fromTERM'               => '|<----|-----|-----|     |     |     |     |',
			      'SIP4fromOTHER1'             => '|<----|-----|-----|-----|     |     |     |',
			      'SIP4fromOTHER2'             => '|<----|-----|-----|-----|-----|     |     |',
			      'SIP4toDNS'                  => '|<====|=====|=====|=====|=====|=====|====>|',
			      'RTP4any'                    => '|<====|=====|====>|     |     |     |     |',
			      'RTP4toOTHER1'               => '|<====|=====|=====|====>|     |     |     |',
			      'EchoRequest4FromServ'       => '|<----|-----|     |     |     |     |     |',
			      'EchoReply4ToServ'           => '|-----|---->|     |     |     |     |     |',
			      'ICMP4ErrorFromPROXY'        => '|<----|-----|     |     |     |     |     |',
			      'ICMP4ErrorFromOTHER1'       => '|<----|-----|-----|-----|     |     |     |',
			      'Timer'                      => '|*****|*****|*****|*****|*****|*****|*****|',
			      );
    }
    %SIP_FRM_COMMENT_STR = (
			    'Ns_TermLtoRouterG'         => '(L-G-L)',
			    'Ns_TermLtoRouterL'         => '(L-L-L)',
			    'Ns_TermGtoRouterMultiL'    => '(G-M-G)',
			    'Ns_TermGtoRouterMultiL_TL' => '(G-M-L)',
			    'Ns_TermLtoRouterMultiM'    => '(L-M-L)',
			    'Na_TermAtoRouterG'         => '(any-L-G)',
			    'Na_TermAtoRouterGOpt'      => '(any-L-G)',
			    'Na_RouterGToTermL'         => '(G-L-L)',
			    'Na_RouterLToTermG'         => '(L-G-G)',
			    'Na_RouterLToTermG_TL'      => '(L-G-L)',
			    'Na_RouterLToTermL'         => '(L-L-L)',
			    );
}


#============================================
# 
#============================================
# 
sub FVal {
    my($field,$pktinfo)=@_;
    if($pktinfo eq ''){$pktinfo=$SIPPktInfoLast;}
    my($vals,$count,$val);
    if(!ref($pktinfo)){
	if( !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    ($vals,$count,$val)=GetSIPField($field,$pktinfo);
#    PrintItem($val);
#    LOG_OK($val);
    return $val;
}
sub FVals {
    my($field,$pktinfo)=@_;
    if($pktinfo eq ''){$pktinfo=$SIPPktInfoLast;}
    my($vals,$count,$val);
    if(!ref($pktinfo)){
	if( !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    ($vals,$count,$val)=GetSIPField($field,$pktinfo);
#    PrintVal($vals);
    return $vals;
}
sub IsStatusReceived {
    my($status)=@_;
    my($vals,$i,$msg);

    shift;
    $vals=FVsib('recv','','','RQ.Status-Line.code',@_);

    for($i=0;$i<=$#$vals;$i++){
	if(ref($status) eq 'ARRAY'){
	    for($i=0;$i<=$#$status;$i++){
		if($vals->[$i] && $vals->[$i]=~/^$status->[$i]/){return 'OK';}
	    }
	}
	else{
	    if($vals->[$i] && $vals->[$i]=~/^$status/){return 'OK';}
	}
    }
    return 'NG';
}
sub IsStatusNotReceived {
    return (IsStatusReceived(@_) eq 'OK')?'NG':'OK';
}
sub MsgDisplay {
    my($msg)=@_;
    my(@txt);
    @txt=split(/\n/,$msg);
    print "\n################################################################################\n";
    print "#                                                                              #\n";
    map{printf("# %-76s #\n",$_);} @txt;
    print "#                                                                              #\n";
    print "################################################################################\n";
}
sub WaitUntilKeyPressAndHangup {
    my($link)=@_;
    if($link eq ''){$link=$SIP_Link;}
    MsgDisplay("Proxy $SIP_ScenarioModel{'Trapezoid'} Mode.\n   Press Enter Key and Hang up.");
    if(<STDIN>){;}
    vCLEAR($link);
}
sub WaitUntilKeyPressAndTelephone {
    my($link)=@_;
    if($link eq ''){$link=$SIP_Link;}
    MsgDisplay("Proxy $SIP_ScenarioModel{'Trapezoid'} Mode.\n   Press Enter Key and make a call.");
    if(<STDIN>){;}
    vCLEAR($link);
}
sub WaitUntilKeyPress {
    my($msg,$link,$nonClear)=@_;
    if($link eq ''){$link=$SIP_Link;}
    MsgDisplay("Proxy $SIP_ScenarioModel{'Trapezoid'} Mode.\n   $msg");
    if(<STDIN>){;}
    if(!$nonClear){vCLEAR($link);}
}

#=================================
# 
#=================================
sub OpViaMachLines{
    my($via,$lines,$rule,$pktinfo,$context)=@_;
    my($val1,@val2,$viaLines,$val2,$count,$i);

    $viaLines=FVs('HD.Via.val.via.txt','',$pktinfo);
    $val1=FVs('HD.Via.val.via','',$pktinfo);
    @val2=map{SIPMakeStruct("SIP/2.0/$SIP_PL_TRNS " . $_,\%STVia)} @$via;
    ($val2,$count)=GetSIPField('via',\@val2);
#    PrintVal($via);
#    PrintVal($viaLines);
#    PrintVal(\@$val1);
#    PrintVal(\@$val2);

    @sipvia=map{"SIP/2.0/$SIP_PL_TRNS " . $_} @$via;

    $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'via','ARG1:'=>$viaLines,'ARG2:'=>\@sipvia};

    if($#$val1+1<$lines){return '';}
    if($#$val2+1<$lines){return '';}
    for($i=0;$i<$lines;$i++){
	if(!OpViaMachLine($val1->[$i],$val2->[$i],$i)){return '';}
    }
    return 'MATCH';
}

# sendby,branch=,received=
sub OpViaMachLine{
    my($val1,$val2,$receivedComp)=@_;
    my($param1,$param2,$count1,$count2,$i);

	# sent-protocol
	($param1,$count1)=GetSIPField('proto.trans',$val1);
	($param2,$count2)=GetSIPField('proto.trans',$val2);
	if($param1 ne $param2){return '';}

    # sendby
    if(!FFCompareHostPort('loose',$val1->{sendby},$val2->{sendby})){return '';}
    
    # branch=
    ($param1,$count1)=GetSIPField('param.branch=',$val1);
    ($param2,$count2)=GetSIPField('param.branch=',$val2);
    if($count1 ne $count2){return '';}
    for($i=0;$i<=$#$param1;$i++){
	if($param1->[$i] ne $param2->[$i]){return '';}
    }

    # received=
    if($receivedComp){
	($param1,$count1)=GetSIPField('param.received=',$val1);
	($param2,$count2)=GetSIPField('param.received=',$val2);
	if($count1 ne $count2){return '';}
	for($i=0;$i<=$#$param1;$i++){
	    if($param1->[$i] ne $param2->[$i]){return '';}
	}
    }

    return 'MATCH';
}
sub OpCalcAuthorizationResponse {
    my($tag,$msg,$mode,$rule,$pktinfo,$context)=@_;
    my($val,$authUsr,$authRealm,$authUri,$authNonce,$authNc,$authCnonce,$authQop,$field);
    if($tag eq 'Authorization'){
	$field='HD.Authorization.val.digest';
    }
    if($tag eq 'Proxy-Authorization'){
	$field='HD.Proxy-Authorization.val.digest';
    }
    shift @_; shift @_; shift @_;
    $val = FV("$field.username",@_);
    if( $val =~ /\"(.*)\"/ ){	$authUsr   = $1;}
    $val = FV("$field.realm",@_);
    if( $val =~ /\"(.*)\"/ ){   $authRealm = $1;}
    $val = FV("$field.uri",@_);
    if( $val =~ /\"(.*)\"/ ){   $authUri   = $1;}
    $val = FV("$field.nonce",@_);
    if( $val =~ /\"(.*)\"/ ){   $authNonce = $1;}

    if($mode eq 'noauth'){
	$val = CalcMD5Response_NoQop($authUsr,$authRealm,$CNT_AUTH_PASSWD,$authUri,$msg,$authNonce);
	MsgPrint('INF',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,$CNT_AUTH_PASSWD,$authNonce,$msg,$val);
    }
    else{
	$val = FV("$field.cnonce",@_);
	if( $val =~ /\"(.*)\"/){    $authCnonce= $1;}
	$authNc    =FV("$field.nc",@_);
	$authQop   =FV("$field.qop",@_);

	$val = CalcMD5Response_NoQop($authUsr,$authRealm,$CNT_AUTH_PASSWD,$authUri,$msg,$authNonce);
	MsgPrint('INF',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,$CNT_AUTH_PASSWD,$authNonce,$msg,$val);

	$val = CalcMD5Response($authUsr,$authRealm,$CNT_AUTH_PASSWD,$authUri,$msg,$authNonce,
			   $authNc,$authCnonce,$authQop);
	MsgPrint('INF',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Nc[%s] Cnonce[%s] Qop[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,$CNT_AUTH_PASSWD,$authNonce,$authNc,$authCnonce,$authQop,$msg,$val);
    }
    return ("\"$val\"");
}
sub OpCalcAuthorizationResponse2 {
    my($tag,$msg,$field2,$fieldval2,$mode,$rule,$pktinfo,$context)=@_;
    my($val,$authUsr,$authRealm,$authUri,$authNonce,$authNc,$authCnonce,$authQop,$field);
    if($tag eq 'Authorization'){
	$field='HD.Authorization.val.digest';
    }
    if($tag eq 'Proxy-Authorization'){
	$field='HD.Proxy-Authorization.val.digest';
    }
    shift @_; shift @_;shift @_;shift @_;shift @_;
    $val = FVm("$field.username",$field2,$fieldval2,@_);
    if( $val =~ /\"(.*)\"/ ){	$authUsr   = $1;}
    $val = FVm("$field.realm",$field2,$fieldval2,@_);
    if( $val =~ /\"(.*)\"/ ){   $authRealm = $1;}
    $val = FVm("$field.uri",$field2,$fieldval2,@_);
    if( $val =~ /\"(.*)\"/ ){   $authUri   = $1;}
    $val = FVm("$field.nonce",$field2,$fieldval2,@_);
    if( $val =~ /\"(.*)\"/ ){   $authNonce = $1;}

    if($mode eq 'noauth'){
	$val = CalcMD5Response_NoQop($authUsr,$authRealm,$CNT_AUTH_PASSWD,$authUri,$msg,$authNonce);
	MsgPrint('INF',"Calc MD5 (no auth) Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,$CNT_AUTH_PASSWD,$authNonce,$msg,$val);
    }else{
	$val = FVm("$field.cnonce",$field2,$fieldval2,@_);
        if( $val =~ /\"(.*)\"/){    $authCnonce= $1;}
	$authNc    =FVm("$field.nc",$field2,$fieldval2,@_);
	$authQop   =FVm("$field.qop",$field2,$fieldval2,@_);
	$val = CalcMD5Response($authUsr,$authRealm,$CNT_AUTH_PASSWD,$authUri,$msg,$authNonce,
			       $authNc,$authCnonce,$authQop);
	MsgPrint('INF',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Nc[%s] Cnonce[%s] Qop[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,$CNT_AUTH_PASSWD,$authNonce,$authNc,$authCnonce,$authQop,$msg,$val);
    }
    return ("\"$val\"");
}

sub OpCalcAuthorizationResponse3 {
    my($tag,$msg,$authUsr,$authUri,$authNc,$authCnonce,$mode,$rule,$pktinfo,$context)=@_;
    my($val,$authRealm,$authNonce,$authQop,$field);
    if($tag eq 'Proxy-Authenticate'){
	$field='HD.Proxy-Authenticate.val.digest';
    }
    if($tag eq 'WWW-Authenticate'){
	$field='HD.WWW-Authenticate.val.digest';
    }
    shift @_; shift @_; shift @_;shift @_; shift @_; shift @_;shift @_;

    # 
    $val = FV("$field.realm",@_);
    if( $val =~ /\"(.*)\"/ ){   $authRealm = $1;}
    $val = FV("$field.nonce",@_);
    if( $val =~ /\"(.*)\"/ ){   $authNonce = $1;}
    if( $authUsr    =~ /\"(.*)\"/ ){ $authUsr = $1;}
    if( $authCnonce =~ /\"(.*)\"/ ){ $authCnonce = $1;}
    if($mode eq 'noauth'){
	$val = CalcMD5Response_NoQop($authUsr,$authRealm,$CNT_AUTH_PASSWD,$authUri,$msg,$authNonce);
	MsgPrint('INF',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,$CNT_AUTH_PASSWD,$authNonce,$msg,$val);
    }
    else{
	$authQop = FV("$field.qop",@_);
	if( $authQop    =~ /\"(.*)\"/ ){ $authQop = $1;}
	$val = CalcMD5Response($authUsr,$authRealm,$CNT_AUTH_PASSWD,$authUri,$msg,$authNonce,
			   $authNc,$authCnonce,$authQop);
	MsgPrint('INF',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Nc[%s] Cnonce[%s] Qop[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,$CNT_AUTH_PASSWD,$authNonce,$authNc,$authCnonce,$authQop,$msg,$val);
    }
    return ("\"$val\"");
}

sub CalcAuthorizationInfoDigest {
    my($tag,$msg,$rule,$pktinfo,$context)=@_;
    my($val,$authUsr,$authRealm,$authUri,$authNonce,$authNc,$authCnonce,$authQop,$field);
    if($tag eq 'Authorization'){
	$field='HD.Authorization.val.digest';
    }
    if($tag eq 'Proxy-Authorization'){
	$field='HD.Proxy-Authorization.val.digest';
    }
    shift @_;shift @_;
    $val = FV("$field.username",@_);
    if( $val =~ /\"(.*)\"/ ){	$authUsr   = $1;}
    $val = FV("$field.realm",@_);
    if( $val =~ /\"(.*)\"/ ){   $authRealm = $1;}
    $val = FV("$field.uri",@_);
    if( $val =~ /\"(.*)\"/ ){   $authUri   = $1;}
    $val = FV("$field.nonce",@_);
    if( $val =~ /\"(.*)\"/ ){   $authNonce = $1;}
    $val = FV("$field.cnonce",@_);
    if( $val =~ /\"(.*)\"/){    $authCnonce= $1;}
    $authNc    =FV("$field.nc",@_);
    $authQop   =FV("$field.qop",@_);

    $val = CalcMD5Response($authUsr,$authRealm,$CNT_AUTH_PASSWD,$authUri,$msg,$authNonce,
			   $authNc,$authCnonce,$authQop,'AUTH-INFO');
    MsgPrint('INF',"Calc MD5(Auth-Info) Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Nc[%s] Cnonce[%s] Qop[%s] Msg[%s] => [%s]\n",
	     $authUsr,$authRealm,$authUri,$CNT_AUTH_PASSWD,$authNonce,$authNc,$authCnonce,$authQop,$msg,$val);

    return ("\"$val\"");
}

sub CalcMD5Response{
    my( $usr, $realm, $pw, $uri, $method, $nonce, $nc, $cnonce, $qop, $mode ) = @_;
    my( $a1,$a2,$ha1,$ha2,$conc,$res );
    
    # A1
    $a1 = join( ":", ($usr,$realm,$pw ) );
    $ha1 = md5_hex( $a1 );

    # A2
    if( $qop eq "auth" ){
	if($mode eq 'AUTH-INFO'){
	    $a2 = ":" . $uri;
	}
	else{
	    $a2 = join( ":", ($method,$uri) );
	}
    }
    else{
	MsgPrint('ERR',"Unsupported qop=[%s], so cannot calc digest.\n",$qop);
	$a2 = join( ":", ($method,$uri) );
    }
    $ha2 = md5_hex( $a2 );

    # 
    $conc = join( ":", ( $ha1, $nonce, $nc, $cnonce, $qop, $ha2 ) );
    $res = md5_hex( $conc );

    return( $res );
}

sub CalcMD5Response_NoQop{
    my( $usr, $realm, $pw, $uri, $method, $nonce, $mode ) = @_;
    my( $a1,$a2,$ha1,$ha2,$conc,$res );
    # A1
    $a1 = join( ":", ($usr,$realm,$pw ) );
    $ha1 = md5_hex( $a1 );

    $a2 = join( ":", ($method,$uri) );

    $ha2 = md5_hex( $a2 );

    # 
    $conc = join( ":", ( $ha1, $nonce, $ha2 ) );
    $res = md5_hex( $conc );

    return( $res );
}


sub SIPInitialAuthUse{
    my( $finish ) = @_;

    if($CNT_CONF{'AUTH-SUPPORT'} ne 'T'){
        if($finish eq 'Ignore'){
	    MsgDisplay("AUTH-SUPPORT doesn\'t equal \'T\'.\nThis is \'Authentication\' TEST, you can\'t perform this test. ");
            ExitToV6evalTool($V6evalTool::exitIgnore);
	}

	DeleteRuleFromAllRuleSet('^S.AUTH*');
	DeleteRuleFromAllRuleSet('^S.P-AUTH*');
    }
}

sub SIPCheckIG{
	if ($CNT_CONF{'SPECIFICATION'} ne 'IG') { 
		MsgDisplay("This test dependes on \'IG\' (Implementation Guideline).\nSo, you can\'t perform this test.\nIf you try, you have to set \'SPECIFICATION\' parameter to \'IG\' on config.txt.");
		ExitToV6evalTool($V6evalTool::exitIgnore);
	}
}

sub SIPCheckTTC{
	if ($CNT_CONF{'SPECIFICATION'} ne 'TTC') { 
		MsgDisplay("This test dependes on \'TTC\' specifications.\nSo, you can\'t perform this test.\nIf you try, you have to set \'SPECIFICATION\' parameter to \'TTC\' on config.txt.");
		ExitToV6evalTool($V6evalTool::exitIgnore);
	}
}

sub SIPCheckUDP{
    if ($SIP_PL_TRNS ne 'UDP') { 
        MsgDisplay("This test dependes on \'UDP\' as transport layer protocol.\nSo, you can\'t perform this test.\nIf you try, you have to use UDP.");
        ExitToV6evalTool($V6evalTool::exitIgnore);
    }
} 

sub SIPCheckTCP{
    if ($SIP_PL_TRNS ne 'TCP') { 
        MsgDisplay("This test dependes on \'TCP\' as transport layer protocol.\nSo, you can\'t perform this test.\nIf you try, you have to use TCP.");
        ExitToV6evalTool($V6evalTool::exitIgnore);
    }
} 

sub SIPCheckTLS{
    if ($SIP_PL_TRNS ne 'TLS') { 
        MsgDisplay("This test dependes on \'TLS\' as transport layer protocol.\nSo, you can\'t perform this test.\nIf you try, you have to use TLS.");
        ExitToV6evalTool($V6evalTool::exitIgnore);
    }
} 

sub SIPCheckIPv6 {
	if ($SIP_PL_IP ne '6') {
        MsgDisplay("This test dependes on \'IPv6\' as network layer protocol.\nSo, you can\'t perform this test.\nIf you try, you have to use IPv6.");
        ExitToV6evalTool($V6evalTool::exitIgnore);
	}
}

sub SIPCheckIPv4 {
	if ($SIP_PL_IP ne '4') {
        MsgDisplay("This test dependes on \'IPv4\' as network layer protocol.\nSo, you can\'t perform this test.\nIf you try, you have to use IPv4.");
        ExitToV6evalTool($V6evalTool::exitIgnore);
	}
}

#### for SIPLOGO #####
# 20070221 Inoue add 

sub SIPCheckPktAfter {
	my($pkt) = @_;
	my($context);
        my($d_port, $d_addr_ok, $s_addr_ng, $s_time, $e_time);
        my($wait_d_port, $wait_d_addr, $wait_s_addr, $wait_p_time);

        $d_addr = $CVA_PUA_IPADDRESS;
        $d_port_ok = $CNT_PORT_CHANGE_RTP;
        $d_port_ng = $CNT_PORT_DEFAULT_RTP;
        $s_addr = $CVA_TUA_IPADDRESS;
        $s_time = $CNT_CONF{'START_CHECK_TIME'};
        $e_time = $CNT_CONF{'END_CHECK_TIME'};

        $wait_d_port
            = $pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.DestinationPort'};
        $wait_d_addr
            = $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
        $wait_s_addr
            = $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
        $wait_p_time
            = $pkt->{'recvTime1'};

#        $context = {'RESULT-DETAIL:'
#            => {'ARG1:' => $wait_d_port, 'ARG2:' => $d_port_ok}};
         $context = {'RESULT-DETAIL:'
             => {'ARG1:' => "$wait_d_port", 'ARG2:' => "$d_port_ok"}};

#printf("da = $d_addr sa = $s_addr \n");
printf("dp_ok = $d_port_ok  dp_ng = $d_port_ng\n");
printf("wda = $wait_d_addr  wdp = $wait_d_port  sda = $wait_s_addr \n");
#printf("p-time = $wait_p_time \n");
#printf("s_time = $s_time  e_time = $e_time\n");

#PrintVal($pkt);
#exit;

  if(($wait_p_time > $s_time) && ($wait_p_time < $e_time)){

    if($d_addr == $wait_d_addr){
      if($s_addr == $wait_s_addr){
        if($d_port_ok == $wait_d_port){
          SIPAddJudgmentResult('OK', 'S.RTP_DIST_PORT_CHECK', $pkt, $context);
#          PV(SIPAddJudgmentResult('OK', 'S.RTP_DIST_PORT_CHECK', $pkt, $context));
#         SIPAddJudgmentResult('OK:', 'S.RTP_DIST_PORT_CHECK');
          print "GOOD!!!\n";
          return '1';
        }elsif($d_port_ng == $wait_d_port){
          SIPAddJudgmentResult('', 'S.RTP_DIST_PORT_CHECK', $pkt, $context);
#          PV(SIPAddJudgmentResult('', 'S.RTP_DIST_PORT_CHECK', $pkt, $context));
#         SIPAddJudgmentResult('NG:', 'S.RTP_DIST_PORT_CHECK');
          print "NG!!!\n";
          return '2';
        }else{
          return '';
        }
      }
    }
  }
}

sub SIPCheckPktAfter2 {
	my($pkt) = @_;
	my($match);
        my($d_port, $d_addr, $s_addr);
        my($wait_d_port, $wait_d_addr, $wait_s_addr);

        $d_addr = $CVA_PUA_IPADDRESS;
        $d_port = $CNT_PORT_DEFAULT_RTP;
        $s_addr = $CVA_TUA_IPADDRESS;

        $wait_d_port
            = $pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.DestinationPort'};
        $wait_d_addr
            = $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
        $wait_s_addr
            = $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};

printf("da = $d_addr  dp = $d_port  sa = $s_addr \n");
printf("wda = $wait_d_addr  wdp = $wait_d_port  sda = $wait_s_addr \n");


print "#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#\n";
#PrintVal($pkt);
#exit;
    if($d_addr == $wait_d_addr){
      if($d_port == $wait_d_port){
        if($s_addr == $wait_s_addr){
          print "HIT!!!\n";
          return '';
        }
      }
    }
}

1
