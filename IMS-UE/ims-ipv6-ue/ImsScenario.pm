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

# 
# 09/6/12  LoadProtectFile
# 09/6/ 3  SecurityVerify
# 09/3/10  
# 09/1/28  
# 08/12/22 CtScInitTBL S-CSCF ContactURI 
# 08/12/19 CtScCreateNodeTempl HSS
#          CtScRunScenario 
# 08/4/ 8  UC,UserProfile,Ki 
#

##############################################################################
#
# SIP Scenario Control
#
##############################################################################

## DEF.VAR
#=============================================================================
# Package
#=============================================================================

# BEGIN{$ENV{'V6EVAL_WITH_KOI'}='T';}
# HTML
END{if(CtTbCti('SC,ScenarioInfo,ShowHTML')){DisplayHTMLwithKonqueror($V6evalTool::LogFile)}}
use V6evalTool;
use IO::Socket;
use Digest::MD5 qw(md5_hex);
use Time::HiRes;

use CText;

if($BYTECode){
#=============================================================================
# 
#=============================================================================
    require CText::ct;
    
    $CTLDPKG='CText::';
    printf("Loaded system path ct ...\n");
}
else{
eval("require PfInet");
if(!$@){
#=============================================================================
# 
#=============================================================================
    require PfInet;
    require PfPkt;
    require PfSip;
    require PfSip2;
    require PfTbl;
    require PfCtl;
    require PfIo;
    require PfSv;
    
#=============================================================================
# Extension module
#=============================================================================
# require SIPkoi;     # KOI module
# require kCommon;      # KOI module
    
    
#=============================================================================
# SIP modeule
#=============================================================================
    require SvSip;
    require SvIms;
    require SvImsDlg;
    require SvImsReg;
    require SvImsAka;
    
    require SvImsEncode;
    require SvImsEncodeEmu;
    require SvImsSyntaxSet;
    require SvImsTS24229;
    require SvImsTS33203;
    require SvImsRFC2617;
    require SvImsRFC3261;
    require SvImsRFC3264;
    require SvImsRFC3265;
    require SvImsRFC3310;
    require SvImsRFC3327;
    require SvImsRFC3329;
    require SvImsRFC3455;
    require SvImsRFC3486;
    require SvImsRFC3680;
    require SvImsRFC4566;
    require SvImsRFC5049;
    printf("Loaded local path ct ...\n");
    $CTLDPKG='';
}
else{
#=============================================================================
# 
#=============================================================================
    require CText::PfInet;
    require CText::PfPkt;
    require CText::PfSip;
    require CText::PfSip2;
    require CText::PfTbl;
    require CText::PfCtl;
    require CText::PfIo;
    require CText::PfSv;
    
#=============================================================================
# SIP modeule
#=============================================================================
    require SvSip;
    require SvIms;
    require SvImsDlg;
    require SvImsReg;
    require SvImsAka;
    require SvImsEncode;
    require SvImsSyntaxSet;
    require SvImsTS24229;
    require SvImsTS33203;
    require SvImsRFC2617;
    require SvImsRFC3261;
    require SvImsRFC3264;
    require SvImsRFC3265;
    require SvImsRFC3310;
    require SvImsRFC3327;
    require SvImsRFC3329;
    require SvImsRFC3455;
    require SvImsRFC3486;
    require SvImsRFC3680;
    require SvImsRFC4566;
    require SvImsRFC5049;
    $CTLDPKG='CText::';
    printf("Loaded global path ct ...\n");
}
}

sub IMSCommonRuleList {
    my($commonName)=@_;
    return 
	\@IMS_EncodeRules,
	\@IMS_SyntaxRuleset,
	\@IMS_TS24229_SyntaxRules,
	\@IMS_TS33203_SyntaxRules,
        \@IMS_RFC2617_SyntaxRules,
	\@IMS_RFC3261_SyntaxRules,
	\@IMS_RFC3264_SyntaxRules,
	\@IMS_RFC3265_SyntaxRules,
	\@IMS_RFC3310_SyntaxRules,
	\@IMS_RFC3327_SyntaxRules,
	\@IMS_RFC3329_SyntaxRules,
	\@IMS_RFC3455_SyntaxRules,
	\@IMS_RFC3486_SyntaxRules,
	\@IMS_RFC3680_SyntaxRules,
	\@IMS_RFC4566_SyntaxRules,
	\@IMS_RFC5049_SyntaxRules;
}
## DEF.END

#-----------------------------------------------------------------------------
# 
#   
#     $nodeInf
#                node: 
#                nxtNode: 
#                logPos: HTML
#                regFlg: 0
#                        0
#                        1
#     $ruleset
#     $target
#     $dmpparam: tcpdump
#                
#                HASH
#                  interface: 
#                  outfile: 
#                  size: 1
#                  count: 
#                
#                  interface: config
#                  outfile: "
#                  size: 1500
#                  count: 10000
#   
#     
#       
#       
#   
#     
#       
#       
#       
#       
#       
#       
#-----------------------------------------------------------------------------
sub CtScIMSScenario {
    my ($nodeInf, $ruleset, $target, $dmpparam, $samode, $sigcomp) = @_;
    my ($nodeTemplate,$ret, $curNode,@tmp,@tmp2,$localmac,$rule,$no,$etcparams,@ruleset);

    # 
    if($BYTECode){ProductCheck()}

    if ($nodeInf eq '') {
        CtSvError('fatal', "nodeInf nothing");
        return -1;
    }
    if (ref($nodeInf) ne 'ARRAY') {
        CtSvError('fatal', "nodeInf is not ARRAY");
        return -1;
    }
    if ($ruleset && ref($ruleset) ne 'ARRAY') {
        CtSvError('fatal', "ruleset is not ARRAY");
        return -1;
    }
    $no=0;
    @ruleset=map{(!ref($_) && ($_ =~ /COMMON-RULES/)) ? IMSCommonRuleList($_):$_}(@$ruleset);
    foreach $rule (@ruleset){
	if($#$rule < 0){
	    CtSvError('fatal', "ruleset [".$no."] is empty");
	    return -1;
	}
	$no++;
    }
    if ($target eq '') {
        CtSvError('fatal', "target nothing");
        return -1;
    }
    # 
    $samode=SAmodeComplement($samode);

    # 
    $nodeTemplate = CtScCreateNodeTempl($nodeInf,$target,$samode);

    # 
    CtScInit({'NODE_TEMPLATE' => $nodeTemplate,
                  'logTemplate' => '',
                  'ruleSet' => \@ruleset,
                  'ruleCategory' => \%SipRuleCategory,
                  'target' => $target,
                  'tcpdump' => $dmpparam,
	          'samode'=>$samode,
	          'sigcomp'=>$sigcomp?'enable':''},
	     'noLog','noScenarioInfo');

    # 
    foreach $curNode (@$nodeInf) {
        # 
        if ($curNode->{'regFlg'}) {
            CtNDDef($curNode->{'node'}, '',$curNode->{'nxtNode'}, '', 'BG');
        }
    }

    # 
    $ret = CtScInitCI($nodeInf, $target);
    if ($ret) { return $ret }
    MsgPrint('INIT',"CtScInitCI OK\n");

    # 
    $ret = CtScInitUSR($nodeInf);
    if ($ret) { return $ret }

    # logPos
    map{push(@tmp, $_)if($_->{'logPos'})}(@$nodeInf);
    @tmp2 = sort CtLgSortPos @tmp;
    CtTbPrmSet('CI,nodeorder',\@tmp2);

    return 0;
}


#-----------------------------------------------------------------------------
# 
#   
#     $nodeName
#   
#     
#       
#       
#   
#     
#       
#       
#       
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# 
#   
#     
#   
#     
#       
#       
#   
#     
#       
#       
#       
#       
#-----------------------------------------------------------------------------
sub CtScRunDispatch {
    my ($actNode);
    my ($node, $ret, $nodeLst, $nodeSetIfLst, $localIp, @targetIp, $target, $cur);

    # 
    $actNode = CtNDGet({'BACK' => ''});
    if ($#$actNode < 0) {
        CtSvError('fatal', "actNode nothing");
        return -1;
    }

    # 
    $nodeLst = CtTbND();
    $target = CtTbPrm('CI,target');
    if (ref($target) ne 'ARRAY') { $target = [$target]; }
    foreach $cur (@$target) {
        push(@targetIp, CtTbAd('local-ip', $cur));
    }
    foreach $cur (values(%$nodeLst)) {
        $localIp = CtTbAd('local-ip', $cur);
        if ($localIp eq '') {
            next;
        }
        # 
        if (! grep { $localIp eq $_ } @targetIp ) {
            push(@$nodeSetIfLst, $cur);
        }
    }
    $ret = CtIoInitConn($nodeSetIfLst);
    if ($ret) { return $ret; }

    # 
    foreach $node (@$actNode) {
        CtScStart($node);
    }

    # 
    CtScRun();

    return 0;
}

sub CtScRunScenario {
    my ($actNode)=@_;
    my ($node, $ret, $nodeLst, $nodeSetIfLst, $localIp, @targetIp, $target, $cur);

    # 
    if($actNode){
	unless(ref($actNode) eq 'ARRAY'){$actNode=[$actNode]}
    }
    else{
	$actNode = CtNDGet({'BACK' => ''});
    }
    if ($#$actNode < 0) {
        CtSvError('fatal', "actNode nothing");
        return -1;
    }

    # 
    $nodeLst = CtTbND();
    $target = CtTbPrm('CI,target');
    if (ref($target) ne 'ARRAY') { $target = [$target]; }
    foreach $cur (@$target) {
        push(@targetIp, CtTbAd('local-ip', $cur));
    }

    foreach $cur (values(%$nodeLst)) {
        $localIp = CtTbAd('local-ip', $cur);
        if ($localIp eq '') {
            next;
        }
        # 
        if (! grep { $localIp eq $_ } @targetIp ) {
            push(@$nodeSetIfLst, $cur);
        }
    }
    $ret = CtIoInitConn($nodeSetIfLst);
    if ($ret) { return $ret; }

    # 
    foreach $node (@$actNode) {
        CtScStart($node);
    }

    # IMS
    IMSSipRunScenario($actNode);

    # 
    CtMsgDisplay('Scenario ' . CtTbCti('SC,ScenarioInfo,File') . ' starting ...');

    # 
    CtScRun();

    return 0;
}

#-----------------------------------------------------------------------------
# 
#   
#     $exitCode
#                
#   
#     
#   
#     
#       
#       
#-----------------------------------------------------------------------------
sub CtScFin {
    my ($exitCode) = @_;

##  SEQ_Recv(CtNDAct(), \&TCPDefaultMatchPacket);

    # 
    CtScEnd($exitCode);
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#  
#     $node
#     $func
#     $rule
#     $id
#            
#              => 
#     $excpt:
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtScAddImmediateAct {
    my ($node, $func, $rule, $id, $excpt) = @_;

    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    # 
    if ($id eq '') { $id = 'ST:' . $node->{'TLNO'}; }

    # 
    CtNDAddActEx($node, $id, $func, $rule, 'send', '', '', $excpt);

    return $id;
}


#-----------------------------------------------------------------------------
# 
#  
#     $node
#     $func
#     $rule
#     $id
#            
#              => 
#     $excpt:
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtScAddTimerAct {
    my ($node, $func, $rule, $id, $excpt) = @_;

    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    # 
    if ($id eq '') { $id = 'ST:' . $node->{'TLNO'}; }

    # 
    CtNDAddActEx($node, $id, $func, $rule, 'timer', '', '', $excpt);

    return $id;
}


#-----------------------------------------------------------------------------
# SIP
#  
#     $node
#     $func
#     $condition
#                 
#       
#         
#              ['SL,method', 'INVITE']
#         
#              [['SL,code', '200'], ['HD,#CSeq,method', 'INVITE']]
#         
#                
#                
#              [ ['SL,method', 'REGISTER'],
#                ['HD,#To,addr,uri,userinfo', '05022222222', 'UA2'],
#                ['HD,#To,addr,uri,userinfo', '05033333333', 'UA3'] ]
#     $target
#              
#     $rule
#     $id
#            
#              => 
#     $timeout
#               
#     $excpt:
#   
#     
#   
#     
#     
#-----------------------------------------------------------------------------

sub CtScAddRcvAct {
    my ($node, $func, $match, $args, $rule, $id, $tmo, $excpt) = @_;

    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    # 
    if ($id eq '') { $id = 'ST:' . $node->{'TLNO'}; }

    # 
    if ($tmo eq '') {
        $tmo = CtTbUsr($node->{'ID'}, 'timer-t1');
        if ($tmo eq '') {
            CtSvError('fatal', "timer-t1(ID:$node->{'ID'}) nothing");
            return '';
        }
        $tmo *= 64;
    }

    # 
    $args->{'MATCH'} = $match;
    CtNDAddActEx($node, $id, $func, $rule, 'recv', $tmo, $args, $excpt);

    return $id;
}


sub CtScAddRcvMsgAct {
    my ($node, $func, $method, $rule, $id, $tmo, $excpt) = @_;
    return CtScAddRcvAct($node, $func, \&CtIoMtMsgPkt,{'expr' => $method}, $rule, $id, $tmo, $excpt);
}

#-----------------------------------------------------------------------------
# SIP
#  
#     $node
#     $func
#     $method
#     $rule
#     $id
#            
#              => 
#     $timeout
#               
#     $excpt:
#   
#     
#   
#     
#     
#-----------------------------------------------------------------------------
sub CtScAddRcvReqAct {
    my ($node, $func, $method, $rule, $id, $tmo, $excpt) = @_;

    return CtScAddRcvAct($node, $func, \&CtIoMtReqPkt,{'method' => $method}, $rule, $id, $tmo, $excpt);
}


#-----------------------------------------------------------------------------
# SIP
#  
#     $node
#     $func
#     $code
#     $method
#     $seqnum
#     $rule
#     $id
#            
#              => 
#     $timeout
#               
#     $excpt:
#   
#     
#   
#     
#     
#-----------------------------------------------------------------------------
sub CtScAddRcvResAct {
    my ($node, $func, $code, $method, $seqnum, $rule, $id, $tmo, $excpt) = @_;

    return CtScAddRcvAct($node, $func, \&CtIoMtResPkt,
			 {'code' => $code, 'method' => $method, 'seqnum' => $seqnum},
			 $rule, $id, $tmo, $excpt);
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $nodeInf:
#     $target:
#   
#     
#   
#     
#     (ADINIT
#      
#-----------------------------------------------------------------------------
sub CtScCreateNodeTempl {
    my ($nodeInf,$target,$samode) = @_;
    my (%NODE_TEMPLATE);
    my (%tmp, $curNode);

    foreach $curNode (@$nodeInf) {
        if ($curNode->{'node'} ne 'DHCP' && $curNode->{'node'} ne 'DNS' && $curNode->{'node'} ne 'HSS') {
            %tmp = (
                $curNode->{'node'} => {
                    'NODETYPE' => '',
                    'TBLINIT' => CtScInitTBL,
                    'ADINIT' => CtScInitAD,
                    'TARGET' => $target,
		    'SAmode' => (!$curNode->{'regFlg'} ? $samode : 'none'),   # manual|auto|auto-clear|none
                },
            );
        }
        %NODE_TEMPLATE = (%NODE_TEMPLATE, %tmp);
    }

    # DHCP/DNS
    %tmp = (
	    'HSS' => {
		'ADINIT' => {
		    'type'       => "HSS",
		    'protocol'   => 'INET',
		    'transport'  => 'TCP',
		    'local-ip'   => \q{CtTbCfg('HSS','address')},
		    'prefixlen'  => \q{CtTbCfg('HSS','prefixlen')},
		    'peer-port'  => '',
		    'local-port' => \q{CtTbCfg('HSS','port') || 3868},
		    'local-mac'  => \q{CtUtGetMac(CtTbCfg('model','interface'))},
		    'interface'  => \q{CtTbCfg('PF', 'interface')},
		    'ModuleName' => "KOI",
		    'msg-protocol'=>'Diameter',
		},
		'TBLINIT' => 'HSSInitTBL',
	    },
	    'DHCP' => {
		'ADINIT' => {
		    'type'       => "DHCP",
		    'protocol'   => 'INET',
		    'transport'  => 'UDP',
		    'peer-port'  => 67,
		    'local-port' => 68,
		    'local-mac'  => \q{CtUtGetMac(CtTbCfg('model','interface'))},
		    'interface'  => \q{CtTbCfg('model','interface')},
		    'ModuleName' => "TAHI",
		},
		'TBLINIT' => {
		    'local-ip4'  => \q{CtTbCfg('DHCP','IP4')},
		    'local-ip6'  => \q{CtTbCfg('DHCP','IP6')},
		    'router4'    => \q{CtTbCfg('DHCP','Router4')},
		    'router6'    => \q{CtTbCfg('DHCP','Router6')},
		    'dns4'       => \q{CtTbCfg('DHCP','DNS4')},
		    'dns6'       => \q{CtTbCfg('DHCP','DNS6')},
		    'targetip4'  => \q{CtTbCfg('DHCP','TargetIP4')},
		    'targetmask' => \q{CtTbCfg('DHCP','TargetMask')},
		    'prefix'     => \q{CtTbCfg('DHCP','Prefix')},
		    'leasetime'  => \q{CtTbCfg('DHCP','LeaseTime')},
		    'staticroute'=> \q{CtTbCfg('DHCP','StaticRoute')},
		    'dnssearch'  => \q{CtTbCfg('DHCP','DNSSearchList')},
		    'sntp6'      => \q{CtTbCfg('DHCP','SNTP6')},
		    'recfg'      => \q{CtTbCfg('DHCP','RecfgType')},
		    'contractno' => \q{CtTbCfg('DHCP','ContractNo')},
		    'additionalno'=> \q{CtTbCfg('DHCP','AdditionalNo')},
		    'registerdomain'=> \q{CtTbCfg('DHCP','RegisterDomain')},
		    'secretID'   => \q{CtTbCfg('DHCP','SecretID')},
		    'sharedkey'  => \q{CtTbCfg('DHCP','SharedKey')},
		},
	    }
    );
    %NODE_TEMPLATE = (%NODE_TEMPLATE, %tmp);
    return \%NODE_TEMPLATE;
}


#-----------------------------------------------------------------------------
# TBL
#   
#     $nodeName
#   
#     TBL
#   
#     TBL
#-----------------------------------------------------------------------------
sub CtScInitTBL {
    my ($nodeName, $template) = @_;
    my ($TBL,$ealg,$alg);
    my ($target, $trans, $prot, $aor, $contact, $disp, $fqdn, $domain, $usr, $pass);
    $target = $template->{'TARGET'};		# 

    # 
    $trans = CtTbCfg('PF', 'transport');
    if ($trans eq 'TLS') {
        $prot = 'sips:';
    }
    else {
        $prot = 'sip:';
    }
    # AoR URI
    $aor = CtTbCfg($nodeName, 'aor-uri');
    # Contact URI
    $contact = CtTbCfg($nodeName, 'contact-uri');
    # display name
    $disp = CtTbCfg($nodeName, 'display-name');
    # 
    $domain = CtTbCfg($nodeName, 'domain');
    if ($domain eq '' && $aor ne '') {
        $domain = $aor;
        $domain =~ s/^.*\@//;
        # 
        if ($domain =~ /^(\[[:0-9a-fA-F]+\])/) {
            $domain = $1;
        }
        else {
            $domain =~ s/[>:;].*$//;
        }
    }
    # 
    $usr = CtTbCfg($nodeName, 'auth-user');

    # 
    $pass = CtTbCfg('SIPDigest', 'secret-key') || '123456789';

    # 
    $TBL->{'DLG'} = [];

    # SDP
    $TBL->{'SDP'} = [];

    # 
    $TBL->{'TR'} = [];

    # Request URI
    if ($aor ne '') {
		# 
        $TBL->{'UC'}->{'URI'}->{'RequestURI'} = "$prot$aor";
    }
    else {
        $TBL->{'UC'}->{'URI'}->{'RequestURI'} = '';
    }

    # Contact URI
    if ($contact ne '') {
		# 
        $TBL->{'UC'}->{'URI'}->{'ContactURI'} = "$prot$contact";
    }
    else {
        $TBL->{'UC'}->{'URI'}->{'ContactURI'} = '';
    }

    # FQDN
    if ($contact ne '') {
		# 
        $fqdn = $contact;
        $fqdn =~ s/^.*\@//;
        # 
        if ($fqdn =~ /^(\[[:0-9a-fA-F]+\])/) {
            $fqdn = $1;
        }
        else {
            $fqdn =~ s/[>:;].*$//;
        }
    }
    elsif ($aor ne '') {
		# 
        $fqdn = $aor;
        $fqdn =~ s/^.*\@//;
        # 
        if ($fqdn =~ /^(\[[:0-9a-fA-F]+\])/) {
            $fqdn = $1;
        }
        else {
            $fqdn =~ s/[>:;].*$//;
        }
    }
    else {
        $fqdn = '';
    }
    $TBL->{'UC'}->{'URI'}->{'FQDN'} = $fqdn;


    # 
    $TBL->{'UC'}->{'URI'}->{'domain'} = $domain;

    # algorithm
    $TBL->{'UC'}->{'DigestAuth'}->{'algorithm'} = 'MD5';

    # domain
    $TBL->{'UC'}->{'DigestAuth'}->{'domain'} = "$prot$aor";

    # cnonce
    $TBL->{'UC'}->{'DigestAuth'}->{'cnonce'} = CtFlRandHexStr(8);

    # nc
    $TBL->{'UC'}->{'DigestAuth'}->{'nc'} = '00000001';

    # nextnonce
    $TBL->{'UC'}->{'DigestAuth'}->{'nextnonce'} = CtFlRandHexStr(32);

    # nonce
    $TBL->{'UC'}->{'DigestAuth'}->{'nonce'} = CtFlRandHexStr(32);

    # opaque
    $TBL->{'UC'}->{'DigestAuth'}->{'opaque'} = '';

    # qop
    $TBL->{'UC'}->{'DigestAuth'}->{'qop'} = 'auth';

    # realm
    $TBL->{'UC'}->{'DigestAuth'}->{'realm'} = $domain;

    # response
    $TBL->{'UC'}->{'DigestAuth'}->{'response'} = '';

    # rspauth
    $TBL->{'UC'}->{'DigestAuth'}->{'rspauth'} = '';

    # stale
    $TBL->{'UC'}->{'DigestAuth'}->{'stale'} = 'FALSE';

    # uri
    $TBL->{'UC'}->{'DigestAuth'}->{'uri'} = '';

    # 
    if ($usr ne '') {
        $TBL->{'UC'}->{'DigestAuth'}->{'username'} = $usr; # 
    }
    else {
        $TBL->{'UC'}->{'DigestAuth'}->{'username'} = '';
    }

    # 
    if ($pass ne '') {
        $TBL->{'UC'}->{'DigestAuth'}->{'password'} = $pass;
    }
    else {
        $TBL->{'UC'}->{'DigestAuth'}->{'password'} = '';
    }

    # Require
    $TBL->{'UC'}->{'Require'} = '';

    # Proxy-Require
    $TBL->{'UC'}->{'Proxy-Require'} = '';

    # Allow
    $TBL->{'UC'}->{'Allow'} = '';

    # Supported
    $TBL->{'UC'}->{'Supported'} = '';

    # Session-Expires
    $TBL->{'UC'}->{'Timer'}->{'Session-Expires'} = '';

    # Min-SE
    $TBL->{'UC'}->{'Timer'}->{'Min-SE'} = '';

    # refresher
    $TBL->{'UC'}->{'Timer'}->{'refresher'} = '';

    # 
    $TBL->{'UC'}->{'Timer'}->{'refreshFlg'} = '';
    
    # 
    $TBL->{'UC'}->{'SDP'} = '';


    #----------------------------------
    # 
    #----------------------------------
    
    my ($sipPort, $secPort, $hostName);
    my ($nodeType);
    
    # 
    if ($nodeName =~ /^UE/) {
	$nodeType = 'U';
    } elsif ($nodeName =~ /^P-CSCF/) {
	$nodeType = 'P';
    } elsif ($nodeName =~ /^I-CSCF/) {
	$nodeType = 'I';
    } elsif ($nodeName =~ /^S-CSCF/) {
	$nodeType = 'S';
    } else {
	$nodeType = 'O';
    }
    $TBL->{'UC'}->{'NodeType'} = $nodeType;
    
    if ($nodeType eq 'U') {
	#-------------------------------------------------------
	# UserProfile
	#-------------------------------------------------------
	#	'UserProfile' => {					# 
	#		'PublicUserIdentity' => '',		# 
	#		'PrivateUserIdentity' => '',	# 
	#										# 
	#		'HomeNetwork' => '',			# HomeNetworkDomainName
	#										# 
	#		'Ki' => '',						# 
	#	},
	my ($impu, $impi, $homenet);
	my ($registra);
	
	$impu = CtTbCfg($nodeName, 'public-user-id');
	if ($impu) {
	    $TBL->{'UC'}->{'UserProfile'}->{'PublicUserIdentity'} = $impu;
	}
	$impi = CtTbCfg($nodeName, 'private-user-id');
	if ($impi) {
	    $TBL->{'UC'}->{'UserProfile'}->{'PrivateUserIdentity'} = $impi;
	}
	$homenet = CtTbCfg($nodeName, 'domain');	# XXX:domain
	if ($homenet) {
	    $TBL->{'UC'}->{'UserProfile'}->{'HomeNetwork'} = $homenet;
	}
	
	$registra = CtTbCfg($nodeName, 'registra');
	if ($registra) {
	    $TBL->{'UC'}->{'Registra'} = $registra;
	}
    }
    
    $sipPort = CtTbCfg($nodeName, 'sip-port');
    if($sipPort ne 5060){CtPkAddPort('SIP',$sipPort)}
    $secPort = CtTbCfg($nodeName, 'port-s');
    $hostName = CtTbCfg($nodeName, 'hostname');

    if (!$hostName) {
	# hostname
	$hostName = CtTbCfg($nodeName, 'address');
	if ($hostName =~ /^[a-fA-F0-9:]+$/) {
	    # V6
	    $hostName = "[" . $hostName . "]";
	}
    }
    $TBL->{'UC'}->{'HostName'} = $hostName;
    # XXX: 
#	if (!$fqdn) {
#		$TBL->{'UC'}->{'URI'}->{'FQDN'} = $hostName;
#	#	MsgPrint('WAR', "FQDN = $hostName\n");	# XXX:DEBUG
#	}
    
    #-------------------------------------------------------
    # ContactURI
    #-------------------------------------------------------
    {
	my ($contactHost);
	
	# contact-host
    	$contactHost = CtTbCfg($nodeName, 'contact-host');
	if ($contactHost eq '') {
	    # contact-host
	    $contactHost = $hostName;
	}
	if ($nodeType eq 'U') {
	    # XXX: UE
	    #      
	    if ($secPort) {
		$TBL->{'UC'}->{'SecContactURI'} = NewURI($contactHost, $secPort, '');;
	    }
	    $TBL->{'UC'}->{'ContactURI'} = NewURI($contactHost, $sipPort, '');;
	}
	if ($nodeType eq 'S') {
	    $TBL->{'UC'}->{'ContactURI'} = NewURI($contactHost, $sipPort, '');;
	} else {
	    $TBL->{'UC'}->{'ContactURI'} = NewURI($contactHost, $sipPort, '');;
	}
    }
    
    #-------------------------------------------------------
    # AddRecordRoute
    #-------------------------------------------------------
    {
	my ($add_rr);
       	$add_rr = CtTbCfg($nodeName, 'add-rec-route');
	if ($add_rr =~ /TRUE|YES/i) {
	    $TBL->{'UC'}->{'AddRecRoute'} = 1;
	} else {
	    $TBL->{'UC'}->{'AddRecRoute'} = 0;
	}
    }
    
    #-------------------------------------------------------
    # SecurityAgreement
    #-------------------------------------------------------
    #	'SecurityAgreement' => {	# IPSec
    #					# 
    #		'mech'   => '',	
    #		'q'      => '',
    #		'alg'    => '',
    #		'ealg'   => '',
    #		'spi_lc'  => '',        
    #		'spi_ls'  => '',
    #		'port_lc' => '',
    #		'port_ls' => '',
    #		'spi_pc'  => '',        
    #		'spi_ps'  => '',
    #		'port_pc' => '',
    #		'port_ps' => '',
    #	},
    if (($nodeType eq 'U') or ($nodeType eq 'P')){
	my ($spi_lc,$spi_ls,$spi_pc,$spi_ps,
	    $port_lc,$port_ls,$port_pc,$port_ps,$sa);
	#-------------------------------------------------------
	# 
	#-------------------------------------------------------
	if($template->{'SAmode'} eq 'auto' && CtTbPrm('COCFG,IPSEC,local-alg')) {
	    $sa={
		'mech'   => CtTbPrm('COCFG,IPSEC,mech'),
		'alg'    => CtTbPrm('COCFG,IPSEC,local-alg'),
		'ealg'   => CtTbPrm('COCFG,IPSEC,local-ealg'),
		'spi_pc' => CtTbPrm('COCFG,IPSEC,remote-spi-c'),
		'spi_ps' => CtTbPrm('COCFG,IPSEC,remote-spi-s'),
		'spi_lc' => CtTbPrm('COCFG,IPSEC,local-spi-c'),
		'spi_ls' => CtTbPrm('COCFG,IPSEC,local-spi-s'),
		'port_pc'=> CtTbPrm('COCFG,IPSEC,remote-port-c'),
		'port_ps'=> CtTbPrm('COCFG,IPSEC,remote-port-s'),
		'port_lc'=> CtTbPrm('COCFG,IPSEC,local-port-c'),
		'port_ls'=> CtTbPrm('COCFG,IPSEC,local-port-s'),
	    };
	    $TBL->{'UC'}->{'SecurityVerify'}=CtMkSecurityVerify($sa);
	}
	else{
	    $sa->{'mech'} = 'ipsec-3gpp';
	}
	
	$spi_lc = CtTbCfg($nodeName, 'spi-c');
	if ($spi_lc) {
	    $sa->{'spi_lc'} = $spi_lc;
	}
	$spi_ls = CtTbCfg($nodeName, 'spi-s');
	if ($spi_ls) {
	    $sa->{'spi_ls'} = $spi_ls;
	}
	if( $port_lc = CtTbCfg($nodeName, 'port-c') ){
	    $sa->{'port_lc'} = $port_lc;
	}
	if( $port_ls = CtTbCfg($nodeName, 'port-s') ){
	    $sa->{'port_ls'} = $port_ls;
	}
	if( $template->{'SAmode'} ne 'auto' && ($alg = CtTbCfg($nodeName, 'alg')) ){
	    $sa->{'alg'} = $alg;
	}
	if( $template->{'SAmode'} ne 'auto' && ($ealg = CtTbCfg($nodeName, 'ealg')) ){
	    $sa->{'ealg'} = $ealg;
	}
	if($template->{'SAmode'} eq 'auto' && !$sa->{'port_pc'}){
	    $sa->{'port_pc'} = CtTbCfg($target, 'port-c');
	}
	if($template->{'SAmode'} eq 'auto' && !$sa->{'port_ps'}){
	    $sa->{'port_ps'} = CtTbCfg($target, 'port-s');
	}
	if($template->{'SAmode'} eq 'auto' && 
	   !( $sa->{'port_ps'} &&
	      $sa->{'port_pc'} &&
	      $sa->{'port_ls'} &&
	      $sa->{'port_lc'} )){
	    CtSvError('fatal', "SA continue mode, but no port info\n");
	}
	$TBL->{'UC'}->{'SecurityAgreement'}={'SA0'=>$sa};
    }
    
    #-------------------------------------------------------
    # AccessNetworkInfo
    #-------------------------------------------------------
    #	'AccessNetworkInfo' => {			# 
    #		'AccessType' => "3GPP-UTRAN-TDD",
    #		'AccessInfo' => "utran-cell-id-3gpp=234151D0FCE11",
    #	},
    if ($nodeType eq 'U') {
	my ($type, $info);
	
       	$type = CtTbCfg($nodeName, 'net-info');
	if ($type) {
	    $TBL->{'UC'}->{'AccessNetworkInfo'}->{'AccessType'} = $type;
	    if ($type eq '3GPP-UTRAN-TDD') {
		$info = CtTbCfg($nodeName, 'utran-param');
		if ($info) {
		    $info = 'utran-cell-id-3gpp=' . $info;	# XXX
		    $TBL->{'UC'}->{'AccessNetworkInfo'}->{'AccessInfo'} = $info;
		}
	    } else {
		# XXX:
	    }
	}
    }
    
    if ($nodeType eq 'U') {
	#-------------------------
	# PrefferedIdentity(U
	#-------------------------
	$TBL->{'UC'}->{'PreferredIdentity'} = '';
    }
    if ($nodeType eq 'P') {
	my ($path);
	#-------------------------
	# AssertedIdentity(P
	#-------------------------
	$TBL->{'UC'}->{'AssertedIdentity'} = '';
	#-------------------------
	# Path(P
	#-------------------------
	$path = CtTbCfg($nodeName, 'path');
	if ($path) {
	    $TBL->{'UC'}->{'Path'} = $path;
	} else {
	    # 
	    $path = NewURI('term@'. $hostName, $sipPort, 'lr');
	    $TBL->{'UC'}->{'Path'} = StrURI($path);
	}
    }
    if ($nodeType eq 'S') {
	my ($svc_route);
	#-------------------------
	# AssociatedURI(S
	#-------------------------
	$TBL->{'UC'}->{'AssociatedURI'} = '';
	#-------------------------
	# ServiceRoute(S
	#-------------------------
	$svc_route = CtTbCfg($nodeName, 'service-route');
	if ($svc_route) {
	    $TBL->{'UC'}->{'ServiceRoute'} = $svc_route;
	} else {
	    # 
	    $svc_route = NewURI('orig@' . $hostName, $sipPort, 'lr');
	    $TBL->{'UC'}->{'ServiceRoute'}->[0] = StrURI($svc_route);
	}
	
	#-------------------------------------------------------
	# UserProfileHSS
	#-------------------------------------------------------
	{
	    my ($cfg) = CtTbSc('CFG');
	    my ($prof);
	    my ($n) = 0;
	    foreach my $key (keys(%$cfg)) {
		if ($key =~ /^(UE[a-zA-Z0-9]+):(Profile[0-9]+)$/) {
		    my ($ue) =  $1;
		    #	my ($profName) = $2;
		    my ($registra) = CtTbCfg($ue, 'registra');
		    if (!$registra) {
			MsgPrint('WAR', "registra is not defined in [$ue]\n");
			next;
		    }
		    if ($registra eq $nodeName) {
			# 
			my ($impu, $impi, $dname, $default);

			# PrivateUserIdentity
			$impi = CtTbCfg($ue, 'private-user-id');
			if (!$impi) {
			    MsgPrint('WAR', "cannot get private-user-id for $registra from [$ue]\n");
			    next;
			}
			$impu = $cfg->{$key}->{'public-user-id'};
			if (!$impu) {
			    MsgPrint('WAR', "public-user-id is not defined in $key\n");
			    next;
			}
			$dname = $cfg->{$key}->{'display-name'};
			$default = $cfg->{$key}->{'default'};

			# UserProfileHSS
			$prof->{$impi}->{'PrivateUserIdentity'} = $impi;
			$prof->{$impi}->{'PublicUserIdentity'} ->[$n]->{'URI'} = $impu;
			if ($dname) {
			    $prof->{$impi}->{'PublicUserIdentity'} ->[$n]->{'DisplayName'} = $dname;
			} else {
			    $prof->{$impi}->{'PublicUserIdentity'} ->[$n]->{'DisplayName'} = '';
			}
			if ($default && ($default =~ /YES|TRUE/)) {
			    $prof->{$impi}->{'PublicUserIdentity'} ->[$n]->{'IsDefault'} = 1;
			} else {
			    $prof->{$impi}->{'PublicUserIdentity'} ->[$n]->{'IsDefault'} = 0;
			}
			$n++;
		    }
		}
	    }
	    if ($n > 0) {
		# [UEa1:Profile1]
		$TBL->{'UC'}->{'UserProfileHSS'} = $prof;
		#			DumpValue($prof);	# XXX:DEBUG
	    } else {
		# [UEa1:Profile1]
		my ($ue) = $target;							# XXX: 
		my ($registra);

		# 
		# 
		if ($ue =~ /^UE/) {
		    $registra = CtTbCfg($ue, 'registra');
		    if (!$registra) {
			MsgPrint('WAR', "registra is not defined in [$ue]\n");
		    } elsif ($registra eq $nodeName) {
			# 
			my ($impu, $impi);
			$impu = CtTbCfg($ue, 'public-user-id');
			$impi = CtTbCfg($ue, 'private-user-id');
			if ($impi && $impu) {
			    my ($profHSS);
			    $profHSS->{$impi}->{'PrivateUserIdentity'} = $impi;
			    $profHSS->{$impi}->{'PublicUserIdentity'}->[0]->{'URI'} = $impu;
			    $profHSS->{$impi}->{'PublicUserIdentity'}->[0]->{'DisplayName'} = '';
			    $profHSS->{$impi}->{'PublicUserIdentity'}->[0]->{'IsDefault'} = 0;
			    $TBL->{'UC'}->{'UserProfileHSS'} = $profHSS;
			}
		    }
		}
	    }
	}
    }

    #-------------------------------------------------------
    # RecRouteURI, SecRecRouteURI, Via, SecVia
    #-------------------------------------------------------
    {
	my ($secHostName);
	my ($tpProto);
	
	if ($nodeType eq 'P') {
	    $secHostName = CtTbCfg($nodeName, 'sec-hostname');
	    if (!$secHostName) {
		# sec-hostname
		$secHostName = $hostName;
	    }
	    $TBL->{'UC'}->{'SecHostName'} = $secHostName;
	}

	# 
	#   [PF]
	#   transport	UDP
	# 
	$tpProto = CtTbCfg('PF', 'transport');
	if (!$tpProto) {
	    $tpProto = 'UDP';
	}

	#--------------------------------
	# RecRouteURI
	# SecRecRouteURI(P
	#--------------------------------
	if ($nodeType ne 'U') {
	    if ($TBL->{'UC'}->{'AddRecRoute'}) {
		# AddRecRoute
		$TBL->{'UC'}->{'RecRouteURI'} = NewURI($hostName, $sipPort, 'lr');
		if ($nodeType eq 'P') {
#					$TBL->{'UC'}->{'SecRouteURI'} = NewURI($secHostName, $secPort, 'lr');
		    if(CtEnableIpsec()){
			$TBL->{'UC'}->{'SecRouteURI'} = NewURI($secHostName, $secPort, 'lr');
		    }else{
			$TBL->{'UC'}->{'SecRouteURI'} = NewURI($secHostName, '', 'lr');
		    }
		}
	    }
	}

	#--------------------------------
	# Via
	# SecVia(P,U
	#--------------------------------
	$TBL->{'UC'}->{'Via'} = NewVia($tpProto, $hostName, $sipPort);
	if ($nodeType eq 'P') {
	    $TBL->{'UC'}->{'SecVia'} = NewVia($tpProto, $secHostName, $secPort);
	} elsif ($nodeType eq 'U') {
	    $TBL->{'UC'}->{'SecVia'} = NewVia($tpProto, $hostName, $secPort);
	}
    }

    #------------------------------------
    # Restore Table Values From parameter.txt
    #------------------------------------
    {
	# Restore UC,DefaultRouteSet
	my ($drs);
	$drs = CtTbPrm("COCFG,$nodeName,DefaultRouteSet");
	if ($drs) {
	    $TBL->{'UC'}->{'DefaultRouteSet'} = $drs;
	}

	# Restore UC,SecurityVerify
	my ($sv);
	$sv = CtTbPrm("COCFG,$nodeName,SecurityVerify");

	if ($sv) {
	    $TBL->{'UC'}->{'SecurityVerify'} = $sv;
	}
    }

    return $TBL;
}


#-----------------------------------------------------------------------------
# AD
#   
#     $nodeName
#   
#     AD
#   
#     AD
#-----------------------------------------------------------------------------
sub CtScInitAD {
    my ($nodeName) = @_;
    my ($AD, $protocol, $transport, $interface, $modulename, $mac);

    # 
    $AD->{'type'} = 'SIP';

    # 
    $protocol = CtTbCfg($nodeName, 'protocol');
    if ($protocol eq '') {
        $protocol = CtTbCfg('PF', 'protocol');
    }
    $AD->{'protocol'} = $protocol;

    # 
    $transport = CtTbCfg($nodeName, 'transport');
    if ($transport eq '') {
        $transport = CtTbCfg('PF', 'transport');
    }
    $AD->{'transport'} = $transport;

    # 
    $AD->{'peer-mac'} = '';

    # 
    $AD->{'peer-ip'} = '';

    # 
    $AD->{'peer-port'} = '';

    # 
    $AD->{'local-ip'} = CtTbCfg($nodeName, 'address');

    # 
    $AD->{'local-port'} = CtTbCfg($nodeName, 'sip-port');

    # 
    $AD->{'prefixlen'} = CtTbCfg($nodeName, 'prefixlen');

    # 
    $AD->{'router'} = CtTbCfg($nodeName, 'router');

    # 
    $interface = CtTbCfg($nodeName, 'interface');
    if ($interface eq '') {
        $interface = CtTbCfg('PF', 'interface');
    }
    $AD->{'interface'} = $interface;

    # 
    if (CtTbCfg('DEBUG', 'simulate') eq 'on') {
        $modulename = 'SIM';
    }
    else {
        $modulename = CtTbCfg($nodeName, 'modulename');
    }
    if ($modulename eq '') {
        $modulename = CtTbCfg('PF', 'modulename');
    }
    $AD->{'ModuleName'} = $modulename;

    # 
    $mac = CtTbCfg($nodeName, 'mac');
    if ($mac eq '') {
        if ($modulename ne 'SIM' && $modulename ne 'PCAP') {
#            $mac = CtUtGetMac($interface);
            $mac = CtTbCti("SC,CFG,tn,link0,mac");
        }
    }
    $AD->{'local-mac'} = $mac;

    return $AD;
}


#-----------------------------------------------------------------------------
# 
#   
#     $nodeInf:
#     $target: 
#   
#     
#       
#       
#   
#     
#-----------------------------------------------------------------------------
sub CtScInitCI {
    my ($nodeInf, $target) = @_;
    my ($prot, $trans, $ifName, $module, $gateway, $routerFlg, $routerIp, $routerPrefix, @targetNode, $cur, $curNode);
    my ($simfile);

    # 
    if (CtTbCfg('DEBUG', 'simulate') =~ /on/i) {
        # 
        $module = 'SIM'; # IO
        $simfile = CtTbCti('SC,ScenarioInfo,SimulateFile') || CtTbCfg('DEBUG', 'file');
        # 
        CtUtLoadSimData($simfile);
	# file
    }
    else {
        $module = CtTbCfg('PF', 'modulename');
        if ($module eq '') {
            CtSvError('fatal', "config.txt:[PF]:modulename nothing");
            return -114;
        }
    }
    CtTbPrmSet('CI,ModuleName', $module);

    # 
    $prot = CtTbCfg('PF', 'protocol');
    if ($prot eq '' && $module ne 'PCAP') {
        CtSvError('fatal', "config.txt:[PF]:protocol nothing");
        return -111;
    }
    if ($prot ne 'INET' && $prot ne 'INET6' && $module ne 'PCAP') {
        CtSvError('fatal', "config.txt:[PF]:protocol invalid($prot)");
        return -111;
    }
    CtTbPrmSet('CI,protocol', $prot);

    # 
    $trans = CtTbCfg('PF', 'transport');
    if ($trans eq '' && $module ne 'PCAP') {
        CtSvError('fatal', "config.txt:[PF]:transport nothing");
        return -112;
    }
    if ($trans ne 'UDP' && $trans ne 'TCP' && $trans ne 'TLS' && $module ne 'PCAP') {
        CtSvError('fatal', "config.txt:[PF]:transport invalid($trans)");
        return -112;
    }
    CtTbPrmSet('CI,transport', $trans);

    # 
    $ifName = CtTbCfg('PF', 'interface');
    if ($ifName eq '' && $module ne 'PCAP') {
        CtSvError('fatal', "config.txt:[PF]:interface nothing");
        return -113;
    }
    CtTbPrmSet('CI,interface', $ifName);

    # 
    $gateway = CtTbCfg('PF', 'gateway');
    CtTbPrmSet('CI,gateway', $gateway);

    # 
    $routerFlg = CtTbCfg('PF', 'Auto_Router_Address');
    CtTbPrmSet('CI,Auto_Router_Address', $routerFlg);

    # 
    $routerIp = CtTbCfg('PF', 'Router_Address');
    CtTbPrmSet('CI,Router_Address', $routerIp);

    # 
    $routerPrefix = CtTbCfg('PF', 'Router_Prefix');
    CtTbPrmSet('CI,Router_Prefix', $routerPrefix);

    # 
    if (ref($target) ne 'ARRAY') { $target = [$target]; }
    foreach $cur (@$target) {
        $curNode = CtNDFromName($cur);
        if ($curNode eq '') {
            CtSvError('fatal', "target($cur) node not define");
            return -115;
        }
        push(@targetNode, $curNode);
    }
    CtTbPrmSet('CI,target', \@targetNode);
    return 0;
}


#-----------------------------------------------------------------------------
# 
#   
#     $nodeInf:
#   
#     
#       
#       
#   
#     
#-----------------------------------------------------------------------------
sub CtScInitUSR {
    my ($nodeInf) = @_;
    my ($curNode, $timerT1, $timerT2, $expire, $rtpPort);

    foreach $curNode (@$nodeInf) {
        # DHCP/DNS
        if ($curNode->{'node'} eq 'DHCP' || $curNode->{'node'} eq 'DNS') {
            next;
        }

        # IP
        CtTbUsrSet($curNode->{'node'}, 'address',
               CtTbCfg($curNode->{'node'}, 'address'));

        # 
        CtTbUsrSet($curNode->{'node'}, 'prefixlen',
               CtTbCfg($curNode->{'node'}, 'prefixlen'));

        # 
        CtTbUsrSet($curNode->{'node'}, 'router',
               CtTbCfg($curNode->{'node'}, 'router'));

        # SIP
        CtTbUsrSet($curNode->{'node'}, 'sip-port',
               CtTbCfg($curNode->{'node'}, 'sip-port'));

        # AoR URI
        CtTbUsrSet($curNode->{'node'}, 'aor-uri',
               CtTbCfg($curNode->{'node'}, 'aor-uri'));

        # Contact URI
        CtTbUsrSet($curNode->{'node'}, 'contact-uri',
               CtTbCfg($curNode->{'node'}, 'contact-uri'));

        # display name
        CtTbUsrSet($curNode->{'node'}, 'display-name',
               CtTbCfg($curNode->{'node'}, 'display-name'));

        # 
        CtTbUsrSet($curNode->{'node'}, 'auth-user',
               CtTbCfg($curNode->{'node'}, 'auth-user'));

        # 
#        CtTbUsrSet($curNode->{'node'}, 'auth-password',
#               CtTbCfg($curNode->{'node'}, 'auth-password'));

        # T1
        $timerT1 = CtTbCfg($curNode->{'node'}, 'timer-t1');
        if ($timerT1 eq '') { $timerT1 = 0.5; } # 
        CtTbUsrSet($curNode->{'node'}, 'timer-t1', $timerT1);

        # T2
        $timerT2 = CtTbCfg($curNode->{'node'}, 'timer-t2');
        if ($timerT2 eq '') { $timerT2 = 4; } # 
        CtTbUsrSet($curNode->{'node'}, 'timer-t2', $timerT2);

        # Expires
        $expire = CtTbCfg($curNode->{'node'}, 'Expires');
        if ($expire eq '') { $expire = 3600; } # 
        CtTbUsrSet($curNode->{'node'}, 'Expires', $expire);

        # Min-Expires
        CtTbUsrSet($curNode->{'node'}, 'Min-Expires',
               CtTbCfg($curNode->{'node'}, 'Min-Expires'));

        # Timestamp
        CtTbUsrSet($curNode->{'node'}, 'Timestamp',
               CtTbCfg($curNode->{'node'}, 'Timestamp'));

        # Supported
        CtTbUsrSet($curNode->{'node'}, 'Supported',
               CtTbCfg($curNode->{'node'}, 'Supported'));

        # Session-Expires
        CtTbUsrSet($curNode->{'node'}, 'Session-Expires',
               CtTbCfg($curNode->{'node'}, 'Session-Expires'));

        # Min-SE
        CtTbUsrSet($curNode->{'node'}, 'Min-SE',
               CtTbCfg($curNode->{'node'}, 'Min-SE'));

        # refresher
        CtTbUsrSet($curNode->{'node'}, 'refresher',
               CtTbCfg($curNode->{'node'}, 'refresher'));

        # Retry-After
        CtTbUsrSet($curNode->{'node'}, 'Retry-After',
               CtTbCfg($curNode->{'node'}, 'Retry-After'));

        # RTP
        $rtpPort = CtTbCfg($curNode->{'node'}, 'rtp-port');
        if ($rtpPort eq '') { $rtpPort = 49172; } # 
        CtTbUsrSet($curNode->{'node'}, 'rtp-port', $rtpPort);
    }
    # spi 
    if(!$DIRRoot{'SC'}->{'SA'} || !$DIRRoot{'SC'}->{'SA'}->{'in'}){
	CtTbScSet('SA',{'in'=>{},'out'=>{}});
    }
    return 0;
}

sub DispStatus {
    my($indicator,$sound,$msg)=@_;
    MsgPrint('GUI',$msg);
}


1;
