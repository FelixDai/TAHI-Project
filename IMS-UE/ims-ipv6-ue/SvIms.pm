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
# 09/10/19 
# 09/4/16  IMSServiceInitialize config.txt
# 09/2/ 9  
# 09/1/27  require [CText::]SIGCOMPpkt ct
# 09/1/ 7  kCommon 
#          V6evalTool
# 08/12/22 CtIoMtResPkt
# 08/12/19 CtIoMtReqPkt,CtIoMtResPkt diameter
#          CtIoKoiIniListen HSS
#          CtIoKoiListen 
#          CtLgRegistTempl HTML
# 08/11/28 AKA
# 08/10/ 3 CtIoSendMsg RAW||TAHI
#                      KOI
#  CtCnCreate IPSEC
# 08/9/19 SIGCOMP
#  IMSServiceInitialize:SIGCOMP,UUID
#  CtCreateUUID
#  CtIoSendMsg:SIGCOMP
#  CtIoInetPkt:SIGCOMP
# 08/5/13 CtCnRecvAny
#  
# 08/4/18 CtIoSendMsg
#  UDP
#  kCommon
# 08/4/17 CtAuthModeFrom401 
# 08/4/17 CtCnCreate noipsec
# 08/4/16 udpsockid 
# 08/4/15 CtAuthAcceptSet
#   Security-Server
# 08/4/ 8 IMSServiceInitialize
#   config.txt
# 08/3/17 IPv4
#   IMSServiceInitialize 
#   CtIoSendMsg 
#   CtAuthAcceptSet IPv4

# IMS
#   
#   
#      CtScIMSScenario
#        CtScInit
#          CtSvInit
#            
#            IMS
#              Setkey
#              
#              
#              TN.def  NUT.def 
#                
#              AKA
#              IPSEC 
#                Setkey
#                
#                TAHI
#              IPSEC setkey
#                
#          CtSvIO
#            TAHI
#        CtScInitCI
#        CtScInitUSR
#        CtTbPrmSet
#
#   
#      SipRunScenario
#        IMSSipRunScenario
#          
#          DHCP 
#          IPSec
#          SIP
#        CtScRun

# SIP 
#   CtIoMtReqPkt 
#     CtIoInetPkt (
#       KOI:
#       TAHI:
#         DoProtocolLayer (ESP
#         NewSessionTahiPacket (UDP
#     CtIoMtInetPktIp (IP
#     ESPDecryptPacket (ESP
#   CtIoMtResPkt

# 
# SIP 
#  CtIoSendMsg
#    KOI:
#      KOISend
#    KOI:
#    

# SAmode auto|auto-clear|manual 
#   auto
#   auto                   : 
#   auto-clear             : 
#   manual                 : 
#
# ipsec-mode
#   config.txt
#   config.txt
#   
sub SAmodeComplement {
    my($samode)=@_;
    if($samode =~ /^(?:auto-clear|auto)$/i){return lc($samode)}
    if($samode =~ /clear/i){return 'auto-clear'}
    if($samode =~ /manual/i){return 'manual'}
    if(!$samode){return 'auto'}
    if($samode =~ /off/i){
        CtSvError('fatal', "SAmode[%s] not implement yet.\n",$samode);
    }
    CtSvError('fatal', "SAmode[%s] invalid\n",$samode);
}

# DHCPD 
sub StartDHCPD {
    my($intf,$nocheck)=@_;
    my($pid,$pids,$ret);
    $ret=CtUtShell("dhcpd -q -6 $intf",20);
    sleep(1);
#     $pids=CtGetPID('dhcpd');
#     if($#$pids<0){
# 	SetupMsg('ERR',"Can't start dhcpd\n");
# 	return 'NG';
#     }
    return;
}

# DHCPD 
sub StopDHCPD {
    my($pid,$pids);
    $pids=CtGetPID('dhcpd');
    foreach $pid (@$pids){
        CtUtShell("kill -9 $pid",20);
        sleep(1);
    }
}

# Konqueror 
sub DisplayHTMLwithKonqueror {
    my ($file)=@_;
    my $cwd;
    my $process = CtUtShell('dcop konq\* | head -n 1');
    $process =~ s/[\r\n]//g;
    unless($process){return}
    eval("use Cwd");
    if($@){
        $cwd = CtUtShell('pwd');
        $cwd =~ s/[\r\n]//g;
    }
    else{
        $cwd = getcwd();
    }
    CtUtShell('dcop '.$process.' konqueror-mainwindow#1 newTab '.$cwd.'/'.$file);
}

# IMS
sub IMSServiceInitialize {
    my($param)=@_;
    my($localmac,$package,$ret,@keys,$key,$port,$no,$secretkey,$samode,$intf,$proto,$mod,$nodes,$node);

    # config.txt 
    $nodes=CtTbCti("SC,CFG");
    foreach $node (keys(%$nodes)){
        if($node=~ /(?:^[ISP]-CSCF|^UE)/i){
            my $mac = $nodes->{$node}->{'address'};
            if(IsMacAddress($mac)){
                if( uc(CtTbCfg('PF','protocol')) eq 'INET6' ){
                    my @addr=CtUtV6WtMkToVal(CtTbCfg('PF','Router_Address').'/'.(CtTbCfg('PF','Router_Prefix') || 64));
                    $nodes->{$node}->{'address'} = CtUtV6FromMac($nodes->{$node}->{'address'},@addr[0]);
                    MsgPrint('INIT',"Node[%s] address exchange, mac(%s) => EUI64(%s)\n",$node,$mac,$nodes->{$node}->{'address'});
                }
                else{
                    MsgPrint('ERR',"Invalid node[%s] address(%s) with protocol(%s)\n",$node,$mac,CtTbCfg('PF','protocol'));
                }
            }
        }
    }

    CtTbCfgSet('PF','sigcomp',$param->{'sigcomp'});

    # 
    if(CtTbCti('SC,ScenarioInfo,Ipsec') eq 'on'){CtTbCfgSet('PF','ipsec','enable')}
    if(CtTbCti('SC,ScenarioInfo,Ipsec') eq 'off'){CtTbCfgSet('PF','ipsec','disable')}
    if(CtTbCti('SC,ScenarioInfo,AuthScheme')){CtTbCfgSet('PF','auth-scheme',CtTbCti('SC,ScenarioInfo,AuthScheme'))}

    # 
    CtTbSwSet('auth-scheme',CtTbCfg('PF','auth-scheme') ? lc(CtTbCfg('PF','auth-scheme')) : 'aka');
    CtTbSwSet('ipsec',(CtTbCfg('PF','ipsec') =~ /disable/i || CtTbCfg('PF','auth-scheme') =~ /sipdigest/i) ? 'off' : 'on');
    CtTbSwSet('sigcomp',(CtTbCfg('PF','sigcomp') =~ /enable/i) ? 'on' : 'off');

    # SIGCOMP
    if( CtEnableSigcomp() ){
	my($stateHandler,$stack);
	eval("use osc");
	if($@){
	    CtSvError('fatal', "SIGCOMP enable. but osc can't use.");
	}
	unless($BYTECode){
	    eval("require ".$CTLDPKG."SIGCOMPpkt");
	    if($@){
		CtSvError('fatal', "SIGCOMP enable. but SIGCOMPpkt.pm can't load.");
	    }
	}
	eval('CtPkRegTempl(\@SIGCOMPHexMap)');
	if($@){
	    CtSvError('fatal', "RegistPktPattern SIGCOMPHexMap");
	}
	eval("use Data::UUID");
	if($@){
	    CtSvError('fatal', "SIGCOMP enable. but Data::UUID can't use.");
	}
	# SIGCOMP
	$stateHandler = new osc::StateHandler(8192,64,8192,2);
	$stateHandler->useSipDictionary();
	$stack = new osc::Stack($stateHandler);
	$stack->addCompressor(new osc::DeflateCompressor($stateHandler));
	CtTbCtiSet("SC,SIGCOMP,stack", $stack ,'T');
	CtTbCtiSet("SC,SIGCOMP,statehandler", $stateHandler ,'T');
    }

    # 
    #   
    $samode=SAmodeComplement(CtTbCfg('AKA','ipsec-mode') || CtTbCfg($param->{'target'},'ipsec-mode') || $param->{'samode'});
    #   
    CtTbCtiSet("SC,CFG,AKA,ipsec-mode", $samode,'T');
    #   
    if($samode =~ /auto/){
	CtTbCtiSet("SC,CFG,PF,modulename", 'KOI' ,'T');
    }
    else{
	CtTbCtiSet("SC,CFG,PF,modulename", 'TAHI' ,'T');
    }

    # AKA
    if($secretkey=(CtTbCfg($param->{'target'},'aka-sharedkey')||CtTbCfg('AKA','secretkey'))){
	if($secretkey =~ /^0x/i){
	    $secretkey = substr($secretkey,2);
	}
	else{
	    $secretkey = unpack('H*',$secretkey);
	}
	$secretkey = substr($secretkey.'00000000000000000000000000000000',0,32);
	CtTbCtiSet("SC,CFG,AKA,secretkey", $secretkey,'T');
    }
    if(CtLgLevel('INIT')){
	my($skey,$op,$amf,$rand,$randmode);
	($skey,$op,$amf,$rand,$randmode)=CtAKAKeyparams();
	MsgPrint('INIT',"Sharedkey:%s\n",$skey);
	MsgPrint('INIT'," op:%s  amf:%s  rand:%s\n",$op,$amf,$randmode eq 'fix' ? $rand:'random');
    }

    # 
    CtIfTbl();

    # TN.def  NUT.def 
    $intf=LoadTAHIDef();

    # 
    if (CtTbCfg('DEBUG', 'simulate') eq 'on'){
	if(CtTbCfg('AKA','ipsec-mode') eq 'manual'){
	    # 
	    foreach $package ('Digest::HMAC_SHA1','Digest::HMAC_MD5','Crypt::CBC', 'Crypt::OpenSSL::AES'){
		eval("use $package");
		if($@){
		    CtSvError('fatal', "$package can't use.");
		}
		else{
		    MsgPrint('INIT',"load %s\n",$package);
		}
	    }
##	    
	    foreach $package ('PfIpsec','PfIo2'){
		eval("require $CTLDPKG$package");
		if($@){
		    CtSvError('fatal', "$CTLDPKG$package can't require.");
		}
		else{
		    MsgPrint('INIT',"load %s\n",$package);
		}
	    }
	    # CtPkRegTempl(\@DHCPPacketHexMap);
	}
	else{
	    my ($spi_lc,$spi_ls,$spi_pc,$spi_ps,$localip,$peerip,
		$port_lc,$port_ls,$port_pc,$port_ps,$username,$alg,$ealg,$setkeyInfo);
	    # SA
	    $username= CtTbPrm('COCFG,IPSEC,username');
	    $alg     = CtTbPrm('COCFG,IPSEC,local-alg');
	    $ealg    = CtTbPrm('COCFG,IPSEC,local-ealg');
	    $spi_pc  = CtTbPrm('COCFG,IPSEC,remote-spi-c');
	    $spi_ps  = CtTbPrm('COCFG,IPSEC,remote-spi-s');
	    $spi_lc  = CtTbPrm('COCFG,IPSEC,local-spi-c');
	    $spi_ls  = CtTbPrm('COCFG,IPSEC,local-spi-s');
	    $port_pc = CtTbPrm('COCFG,IPSEC,remote-port-c');
	    $port_ps = CtTbPrm('COCFG,IPSEC,remote-port-s');
	    $port_lc = CtTbPrm('COCFG,IPSEC,local-port-c');
	    $port_ls = CtTbPrm('COCFG,IPSEC,local-port-s');
	    $peerip  = CtTbPrm('COCFG,IPSEC,remote-ip');
	    $localip = CtTbPrm('COCFG,IPSEC,local-ip');
	    CtSetSA($username,'',$spi_pc,'out',$alg,$ealg,$localip,$peerip,$port_ls,$port_pc,'UDP',$spi_ls);
	    CtSetSA($username,'',$spi_ps,'out',$alg,$ealg,$localip,$peerip,$port_lc,$port_ps,'UDP',$spi_ls);
	    CtSetSA($username,'',$spi_lc,'in', $alg,$ealg,$peerip,$localip,$port_ps,$port_lc,'UDP',$spi_ps);
	    CtSetSA($username,'',$spi_ls,'in', $alg,$ealg,$peerip,$localip,$port_pc,$port_ls,'UDP',$spi_ps);
	}
	return;
    }

    # DHCPD 
    if(CtTbCfg('DHCP','delete-lease') !~ /no/i){
	StopDHCPD();
	if(-e '/var/db/dhcpd6.leases'){
	    CtUtShell("rm -f /var/db/dhcpd6.leases",15);
	}
	CtUtShell("touch /var/db/dhcpd6.leases");
	StartDHCPD($intf);
    }

    # IPSEC 
    if(CtTbCfg('AKA','ipsec-mode') eq 'manual'){

	# Setkey

	# 
	foreach $package ('Digest::HMAC_SHA1','Digest::HMAC_MD5','Crypt::CBC', 'Crypt::OpenSSL::AES'){
	    eval("use $package");
	    if($@){
		CtSvError('fatal', "$package can't use.");
	    }
	    else{
		MsgPrint('INIT',"load %s\n",$package);
	    }
	}
##	
	unless($BYTECode){
	    foreach $package ('PfIpsec','PfIo2'){
		eval("require $CTLDPKG$package");
		if($@){
		    CtSvError('fatal', "$CTLDPKG$package can't require.");
		}
		else{
		    MsgPrint('INIT',"load %s\n",$package);
		}
	    }
	}
	# CtPkRegTempl(\@DHCPPacketHexMap);

	# TAHI
	unless($localmac=CtTbCti('SC,CFG,tn,link0,mac')){
	    CtSvError('fatal', "tn.def  undefine Link0 mac address");
	}
	$localmac =~ s/://g;
	$proto=CtTbCti("SC,CFG,PF,protocol") eq 'INET' ? 'ip4' : 'ip6';
# IPv4/IPv6, Fragment 
	CtTbCtiSet("SC,CFG,PF,moduleparam" ,
		  "(and ($proto) (or (eth dst $localmac)(eth dst 333300010002)(eth dst ffffffffffff)) (and (not (port dst 547))(not (port dst 53))) (or (proto $INETFLD{'PROTO.UDP'})(proto $INETFLD{'PROTO.ESP'})(proto $INETFLD{'PROTO.FRAGMENT'})))",'T');
	MsgPrint('INIT',"TAHI manual mode OK\n");
    }

    # IPSEC setkey
    elsif(CtTbCfg('AKA','ipsec-mode') =~ /auto/i){
	# KOI-SIP
	if(CtTbCfg('DEBUG','modulename') eq 'KOI-SIP'){
	    eval("require PfKoi");
	    if($@){
		CtSvError('fatal', "PfKoi can't require.");
	    }
	    else{
		MsgPrint('INIT',"load %s\n",$package);
	    }
	    kCommon::kModule_Initialize();
#	    kPacket_IFTblAdd('Link0', CtTbCfg('PF','interface'));
	    kCommon::kPacket_Clear(0, 0, 0, 0);
	}
	# KOI 
	else{
	    my($retry);
	    # tcpdump 
	    CtKillProcess('tcpdump');

	    # v6evaltool
	    local($SIG{'CHLD'});
	    $SIG{'CHLD'}='';
	    # kCommon
	    $mod = CtTbCfg('DEBUG','koi')?'kCommonDebug':'kCommon';
#	    eval("push(\@INC,'/usr/local/koi/libdata');require " . $mod);
#	    if($@){CtSvError('fatal',CtTbCfg('DEBUG','koi')?"This is koid debug mode. start koid on manual.": "$mod can't use.");}
	    push(@INC,'/usr/local/koi/libdata');
	    while($retry<3){
		eval("require " . $mod);
		if($@){$retry++}
		else{last;}
	    }
	    if(3 <= $retry){
		CtSvError('fatal',CtTbCfg('DEBUG','koi')?"This is koid debug mode. start koid on manual.": "$mod can't use.");
	    }
	    else{
		my($pid);
		MsgPrint('INIT',"load $mod\n");
		MsgPrint('INIT',"V6evalTool tcpdump stop and kCommon tcpdump restart...\n");
		# V6evalTool
		while($pid = shift @V6evalTool::TcpdumpPids){
		    kill('INT',$pid);
		}
		while($pid = shift @kCommon::TcpdumpPids){
		    kill('INT',$pid);
		}
		# V6evalTool
		$kCommon::LogFile=$V6evalTool::LogFile;
		kCommon::forkTcpdump();
	    }

	    # v6evaltool 
	    # v6evaltool
	    eval('sub kCommon::prOut($){}');
	    eval('close(kCommon::LOG)');           # 
	    eval('sub kCommon::prLog($;$){}');
	    if($@){CtSvError('fatal', "kCommon::prLog can't redefined\n");}
	    else{MsgPrint('INIT',"kCommon log file skip\n");}
	    eval('sub kCommon::prLogHTML($;$){}');
	}

	# setkey
	if( CtTbCfg('AKA','ipsec-mode') eq 'auto-clear' ){
	    CtSetkeyClear();
	}
	# setkey
	elsif( CtEnableIpsec() && CtTbCfg('AKA','ipsec-mode') eq 'auto' ){
	    my ($spi_lc,$spi_ls,$spi_pc,$spi_ps,$localip,$peerip,
		$port_lc,$port_ls,$port_pc,$port_ps,$username,$alg,$ealg,$setkeyInfo);

	    # setkey
	    unless( $setkeyInfo=CtSetkeyInfo() ){
		CtSvError('fatal', "setkey empty. REGISTER scenario retry\n");
	    }

	    unless(-e 'parameter.txt'){
		CtSvError('fatal', "SAmode[auto],but no parameter.txt\n");
	    }
	    # SA
	    $username= CtTbPrm('COCFG,IPSEC,username');
	    $alg     = CtTbPrm('COCFG,IPSEC,local-alg');
	    $ealg    = CtTbPrm('COCFG,IPSEC,local-ealg');
	    $spi_pc  = CtTbPrm('COCFG,IPSEC,remote-spi-c');
	    $spi_ps  = CtTbPrm('COCFG,IPSEC,remote-spi-s');
	    $spi_lc  = CtTbPrm('COCFG,IPSEC,local-spi-c');
	    $spi_ls  = CtTbPrm('COCFG,IPSEC,local-spi-s');
	    $port_pc = CtTbPrm('COCFG,IPSEC,remote-port-c');
	    $port_ps = CtTbPrm('COCFG,IPSEC,remote-port-s');
	    $port_lc = CtTbPrm('COCFG,IPSEC,local-port-c');
	    $port_ls = CtTbPrm('COCFG,IPSEC,local-port-s');
	    $peerip  = CtTbPrm('COCFG,IPSEC,remote-ip');
	    $localip = CtTbPrm('COCFG,IPSEC,local-ip');
	    CtSetSA($username,'',$spi_pc,'out',$alg,$ealg,$localip,$peerip,$port_ls,$port_pc,'UDP',$spi_ls);
	    CtSetSA($username,'',$spi_ps,'out',$alg,$ealg,$localip,$peerip,$port_lc,$port_ps,'UDP',$spi_ls);
	    CtSetSA($username,'',$spi_lc,'in', $alg,$ealg,$peerip,$localip,$port_ps,$port_lc,'UDP',$spi_ps);
	    CtSetSA($username,'',$spi_ls,'in', $alg,$ealg,$peerip,$localip,$port_pc,$port_ls,'UDP',$spi_ps);
	
	    # 
#	    if(!$setkeyInfo->{$spi_pc}){
#		CtSvError('fatal', "SAmode[auto],but spi[%s] no installed setkey\n",$spi_pc);
#	    }
	    if(!$setkeyInfo->{$spi_ps}){
		CtSvError('fatal', "SAmode[auto],but spi[%s] no installed setkey\n",$spi_ps);
	    }
#	    if(!$setkeyInfo->{$spi_lc}){
#		CtSvError('fatal', "SAmode[auto],but spi[%s] no installed setkey\n",$spi_lc);
#	    }
	    if(!$setkeyInfo->{$spi_ls}){
		CtSvError('fatal', "SAmode[auto],but spi[%s] no installed setkey\n",$spi_ls);
	    }
	}
    }
    else{
	CtSvError('fatal', "AKA mode[%s] invalid.\n",CtTbCfg('AKA','ipsec-mode'));
    }
}


# 
sub CtIfTbl {
    my($ad);
    $ad=GetIFTbl();
    $ad->{'DRoute'} = GetDRTbl();
    CtTbCtiSet('SC,IF',$ad,'T');
}

# IMS
sub IMSSipRunScenario {
    my($actNode)=@_;
    my($node,$id,$seq,$sim,$logID);

    # 
    CtNDMakeRelation();

    # DHCP

    # 
    if (CtTbCfg('DEBUG', 'simulate') eq 'on'){return;}

    # 
    foreach $node (@$actNode) {
	# IPSec
	if(CtTbCfg('AKA','ipsec-mode') =~ /auto/i){
	    if(CtTbCfg($node->{'ID'},'port-s') && CtTbCfg($node->{'ID'},'port-c')){
		MsgPrint('INIT',"Koi listen bind starting port[%s] and [%s]...\n",
			 CtTbCfg($node->{'ID'},'port-s'),CtTbCfg($node->{'ID'},'port-c'));
		if(CtEnableIpsec()){
		    CtIoKoiListen($node,'','','',CtTbCfg($node->{'ID'},'port-s'));
		    CtIoKoiListen($node,'','','',CtTbCfg($node->{'ID'},'port-c'));
		    MsgPrint('INIT',"Koi listen bind OK\n");
		}
		# 
		CtPkAddPort('SIP',CtTbCfg($node->{'ID'},'port-c'));
		CtPkAddPort('SIP',CtTbCfg($node->{'ID'},'port-s'));
	    }
	}
    }
# DHCP
#     if(CtTbCfg('AKA','ipsec-mode') eq 'manual' ){
# 	SEQ_DHCP();
# 	CtScStart('DHCP');
# 	MsgPrint('INIT',"DHCPv6 scenario enable\n");
#     }

}

# 
sub IMSSetupTargetAD {
    my($target,$inet)=@_;
    CtTbAdSet('local-mac',CtFlGet('INET,#EH,SrcMac',$inet),$target);
}

# 
sub IMSSetkeySetup {
    my($akaID,$negoname)=@_;
    my($sas,$spi,$aka,$sa);

    if(!CtEnableIpsec()){return;}

    # 
    $sas=CtFindSAIfromID($akaID,$negoname);

    # SA
    foreach $sa (@$sas){
	CtSetkey($sa,CtFindPolicyIDfromSPI($sa->{'spi'},$sa->{'dir'}),CtFindAKA($akaID,$negoname));
    }
}

# TN.def  NUT.def 
sub LoadTAHIDef {
    my($intf,$mac,$tmp,$tmp2,$localmac);
    open(TAHI_DEF, "/usr/local/v6eval/etc/nut.def");
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

    open(TAHI_DEF, "/usr/local/v6eval/etc/tn.def");
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
	$localmac=CtTbCti("SC,IF,$intf,mac");
	if(lc($localmac) ne lc($mac)){
	    MsgPrint('INIT',"tn.def Link0 mac[%s] not equal interface[%s] mac[%s]\n",$mac,$intf,$localmac);
	    CtTbCtiSet("SC,CFG,tn,link0" ,{'name'=>$intf,'mac'=>$localmac},'T');
	}
	# 
	CtTbCtiSet("SC,CFG,PF,interface" ,$intf,'T');
    }
    else{
	CtSvError('fatal', "NUT interface invalid");
    }
    return $intf;
}

# 
sub CtEnableIpsec {
    return CtTbSw('ipsec') eq 'on';
}
sub CtEnableSigcomp {
    return CtTbSw('sigcomp') eq 'on';
}
sub CtSecurityScheme {
    return CtTbSw('auth-scheme');
}

# HTML
sub LogHTML {
    my($msg)=@_;
    V6evalTool::prLogHTML($msg);
}


# 
#   RUN=>{MSG=>,TIME=>,Mode=>}
#   RULE=>{}

# HTML
sub ServiceLogOutput {
    my($result,$logMessage,$ruleAccount,$params)=@_;
    my($pkts,$pkt,$pkgMsg,$no,$startTime);

    # 
    CtLgRegistTempl();

    # 
    CtLgOutForPushed('RUN');

    # 
    $pkts=CtUtCapPktNumbering();
    MsgPrint('INIT',"CtUtCapPktNumbering pkt count[%s]\n",$#$pkts);

    # 
    $startTime=CtLgSeq($pkts);
    CtLgOutDirect(sprintf("<TR bgcolor=\"#FFFF99\"><TD><CENTER>Status</CENTER></TD><TD>%s<BR></TD></TR>\n",$logMessage));
    CtLgOutDirect(sprintf("<TR bgcolor=\"#FFFF99\"><TD><CENTER>Rule</CENTER></TD><TD>%s<BR></TD></TR>\n",$ruleAccount));

    # 
    if(CtLgLevel('EXCUTERULE')){
        CtLgOutDirect(sprintf("<TR bgcolor=\"#FFFF99\"><TD><CENTER>Execute</CENTER></TD><TD><pre>%s</pre></TD></TR>\n",CtRlExecuteRuleStats()));
    }

    # 
    # 
    CtLgJudgeAndPkt($pkts,$startTime,{'STOP-NODE'=>'ESP'});

    # 
    if(CtLgLevel('STATISTICS')){
	SyntaxRuleResultStatisticsOutput();
    }

    $no=1;
    foreach $pkt (@$pkts){
	if(!$pkt->{'MARK'} && $pkt->{'Frame'}){

	    $V6evalTool::pktrevlog .= '<HR><A NAME="FRAME'.sprintf('%0'.$PKTMAX.'d',$no).'"></A>';
	    $V6evalTool::pktrevlog .= '<A HREF="#SEQ'.sprintf('%0'.$PKTMAX.'d',$no).'">'.
		$pkt->{'PktName'}.' '.($pkt->{'Direction'} eq 'in' ? 'recv at ':'send at ').
		$pkt->{'Frame'}->{'#TimeStamp#'}.'</A>'."\n";
	    $V6evalTool::pktrevlog .= "<PRE STYLE=\"line-height:90%\">";
	    @$pkgMsg=();
	    CtPkText($pkt->{'Frame'},$pkgMsg,0,{'pkt'=>$pkt->{'Frame'},'STOP-NODE'=>'ESP'});
	    $V6evalTool::pktrevlog .= CtSvLogPacket($pkgMsg,$no,$pkt->{'Direction'},$pkt->{'PktName'},
						   $pkt->{'Frame'}->{'#TimeStamp#'},$startTime);
	    $V6evalTool::pktrevlog .= "</PRE>";
	}
	$no++;
    }

}

sub CtSvLogPacket {
    my($pkgMsg,$no,$dir,$pktName,$timeStamp,$startTime)=@_;
    my($field,$name,$bgcolor,$val,$result);

    foreach $field (@$pkgMsg){
	if($field->{'Node'}){
	    $result.=sprintf("%s<B>%s</B>\n",'  ' x $field->{'Level'},$field->{'Node'});
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
	    $result.=sprintf("%s%s : <font color=\"blue\">%s</font>\n",'  ' x $field->{'Level'}, $field->{'Field'},$val);
	}
    }
    return $result;
}

# 
sub CtAddMessagePath {
    my($id,$pathlist)=@_;
    CtTbPrmSet('MsgPath,'.$id,$pathlist);
}
# 
sub CtTraceMessagePath {
    my($id,$func,$start,$end)=@_;
    my($path,$val,$startno,$endno,$no);

    unless($path=CtTbPrm('MsgPath,'.$id)){return ;}
    # 
    if($start){
	for $no (0..$#$path){
	    if($start eq $path->[$no]){$startno=$no;last;}
	}
	if($startno eq ''){
	    MsgPrint('WAR',"CtTraceMessagePath(%s) start[%s] invalid\n",$id,$start);
	}
    }
    else{
	$startno=0;
    }
    if($end){
	for $no (0..$#$path){
	    if($end eq $path->[$no]){$endno=$no;last;}
	}
	if($endno eq ''){
	    MsgPrint('WAR',"CtTraceMessagePath end[%s] invalid\n",$end);
	}
    }
    else{
	$endno=$#$path;
    }

    # 
    if ($startno <= $endno) {
        for ($no = $startno; $no <= $endno; $no++) {
            if (ref($func) eq 'CODE' || ($func && !ref($func))) {
		$val = $func->($path->[$no], $val);
            }
        }
    } else {
        for ($no = $startno; $no >= $endno; $no--) {
            if (ref($func) eq 'CODE' || ($func && !ref($func))) {
		$val = $func->($path->[$no], $val);
            }
        }
    }
    return $val;
}

# REGISTER 
sub CtAuthAlgMatch {
    my($inet)=@_;
    my($scheme,$q,$alg,$ealg,$spic,$spis,$portc,$ports,$seucln,$seu,@algs);
    
    # 
    # algs=[{'q=',....},{q=}];
    
    $seucln=CtFlGet('INET,#SIP,HD,#Security-Client',$inet);
    unless($seucln){return 'NG';}

    unless(ref($seucln) eq 'ARRAY'){$seucln=[$seucln]};

    foreach $seu (@$seucln){
	$scheme=CtFlGet('mechanism,#Mechanism,name',$seu);
	$q=CtFlGet('mechanism,#Mechanism,params,tag`$V eq "q"`,generic',$seu);
	$alg=CtFlGet('mechanism,#Mechanism,params,tag`$V eq "alg"`,generic',$seu);
	$ealg=CtFlGet('mechanism,#Mechanism,params,tag`$V eq "ealg"`,generic',$seu);
	$spic=CtFlGet('mechanism,#Mechanism,params,tag`$V eq "spi-c"`,generic',$seu);
	$spis=CtFlGet('mechanism,#Mechanism,params,tag`$V eq "spi-s"`,generic',$seu);
	$portc=CtFlGet('mechanism,#Mechanism,params,tag`$V eq "port-c"`,generic',$seu);
	$ports=CtFlGet('mechanism,#Mechanism,params,tag`$V eq "port-s"`,generic',$seu);
	$alg  = $alg  || 'hmac-sha-1-96';
	$ealg = $ealg || 'null';  # 
	MsgPrint('AKA',"get [%s][%s][%s][%s][%s][%s][%s][%s]\n",$scheme,$q,$alg,$ealg,$spic,$spis,$portc,$ports);
	push(@algs,{'scheme'=>$scheme,'q'=>$q,'alg'=>$alg,'ealg'=>$ealg,'spic'=>$spic,'spis'=>$spis,'portc'=>$portc,'ports'=>$ports});
    }

    foreach $seu ( sort{$b->{'q'} <=> $a->{'q'}}(@algs) ){
	if( CtAKAParamCheck($seu->{'scheme'},$seu->{'alg'},$seu->{'ealg'},$seu->{'spic'},$seu->{'spis'},$seu->{'portc'},$seu->{'ports'}) ){
	    MsgPrint('AKA',"matched  [%s][%s][%s][%s][%s][%s][%s][%s]\n",
		   $seu->{'scheme'},$seu->{'alg'},$seu->{'ealg'},$seu->{'spic'},$seu->{'spis'},$seu->{'portc'},$seu->{'ports'});
	    return '',$seu->{'scheme'},$seu->{'alg'},$seu->{'ealg'},$seu->{'spic'},$seu->{'spis'},$seu->{'portc'},$seu->{'ports'};
	}
    }

    return 'NG';
}

# REGISTER 
#   renew: AKA
sub CtAuthAlgAgreement {
    my($node,$inet,$negoname,$remoteip,$localip,$portcL,$portsL,$spicL,$spisL,$sqn)=@_;
    my($username,$nonce,$scheme,$alg,$ealg,$spicR,$spisR,$portcR,$portsR,$auts);
    my($status,$aka,$policy);

    if(CtSecurityScheme() eq 'sipdigest'){
        # nonce
        CtTbSet('UC,DigestAuth,nonce',CtFlRandHexStr(32),$node);
        return;
    }
    
    if (CtFlGet('INET,#IP6', $inet)) {
	unless($remoteip){$remoteip=CtFlGet('INET,#IP6,SrcAddress',$inet)}
	unless($localip){$localip=CtFlGet('INET,#IP6,DstAddress',$inet)}
    }
    else{
	unless($remoteip){$remoteip=CtFlGet('INET,#IP4,SrcAddress',$inet)}
	unless($localip){$localip=CtFlGet('INET,#IP4,DstAddress',$inet)}
    }
    
    # Authorization
    $username=CtFlGet('INET,#SIP,HD,#Authorization,credentials,credential,digestresp,list,username',$inet);
    $auts=CtFlGet('INET,#SIP,HD,#Authorization,credentials,credential,digestresp,list,tag`$V eq "auts"`,auth',$inet);
    $auts =~ s/"([^"]*)"/$1/;
    
    if(!$username){
	MsgPrint(WAR,"REGISTER private id invalid\n");
	return 'NG';
    }
    if($auts){
	my($sqnMS,$mac,$macs);
	# AUTS 
	$auts = unpack('H*',base64decode($auts));
	
	# AUTS 
	($sqnMS,$mac)=CtAKADecodeAuts($username,substr($auts,0,12));
	$macs = substr($auts,12,16);
	# MAC-S
	if($mac ne $macs){
	    CtLgNG("AUTS mac-s invalid  $mac <=> $macs");
	    MsgPrint('WAR',"AUTS: mac-s invalid %s %s\n",$mac, $macs);
	}
	else{
	    MsgPrint('AKA',"AUTS: mac-s valid\n");
	}
	
	# 
	$sqn=SQNGetNext($sqnMS,1);
	MsgPrint('AKA',"AUTS: Sequence no update %s => %s\n",$sqnMS,$sqn);
    }

    if(CtEnableIpsec()){
	# 
	($status,$scheme,$alg,$ealg,$spicR,$spisR,$portcR,$portsR)=CtAuthAlgMatch($inet);
	if($status){
	    MsgPrint(ERR,"Security-Client algorithm match invalid\n");
	    return 'NG';
	}
	
	#printf("SA Create username[%s] localip[%s] remoteip[%s] scheme[%s] alg[%s] ealg[%s] spicR[%s] spisR[%s] portcR[%s] portsR[%s]\n",
	#	   $username,$localip,$remoteip, $scheme,$alg,$ealg,$spicR,$spisR,$portcR,$portsR);
	
	# 
	$portsL = $portsL || CtSecNego($negoname,'port_ls',$node);
	$portcL = $portcL || CtSecNego($negoname,'port_lc',$node);
	$spicL  = $spicL  || CtSecNego($negoname,'spi_lc',$node);
	$spisL  = $spisL  || CtSecNego($negoname,'spi_ls',$node);

	# AKA+IPsec
	($aka,$policy)=CtSASetup($username,$negoname,$remoteip,$localip,$alg,$ealg,$spicR,$spisR, $portcR,$portsR,
				 $spicL,$spisL,$portcL,$portsL,$sqn,$scheme,'UDP');

	# HTML 
	CtScAddCaptContext('','AKA',CtAKA($aka));

	# AKA,IPsec
	CtAuthAgreementSet($negoname,$node,$username,$scheme,$alg,$ealg,$spicR,$spisR,$policy->{'ResRtoL'}->{'spi'},$policy->{'ReqRtoL'}->{'spi'},
			   $portcR,$portsR,$portcL,$portsL);
    }
    else{
	unless(CtFindAKA($username,$negoname)){CtAKACreate($username,$negoname,$sqn)}
	CtTbPrmSet('IMPI',$username);
    }
    # nonce(base64
    $nonce = CtAKAGetAutnBase64($username,$negoname);
    CtTbSet('UC,DigestAuth,nonce',$nonce,$node);

    return ;
}

# AKA,IPsec
sub CtAuthAgreementSet {
    my($negoname,$node,$username, $scheme, $alg,$ealg, $spi_pc, $spi_ps, $spi_lc, $spi_ls, $port_pc, $port_ps, $port_lc, $port_ls)=@_;
    CtTbPrmSet('IMPI',$username);

    CtSetSecNego($negoname,'mech',$scheme,$node);
    CtSetSecNego($negoname,'alg',$alg,$node);
    CtSetSecNego($negoname,'ealg',$ealg,$node);
    CtSetSecNego($negoname,'spi_pc',$spi_pc,$node);
    CtSetSecNego($negoname,'spi_ps',$spi_ps,$node);
    CtSetSecNego($negoname,'spi_lc',$spi_lc,$node);
    CtSetSecNego($negoname,'spi_ls',$spi_ls,$node);
    CtSetSecNego($negoname,'port_pc',$port_pc,$node);
    CtSetSecNego($negoname,'port_ps',$port_ps,$node);
    CtSetSecNego($negoname,'port_lc',$port_lc,$node);
    CtSetSecNego($negoname,'port_ls',$port_ls,$node);

    CtPkAddPort('SIP',$port_pc);
    CtPkAddPort('SIP',$port_ps);
    CtPkAddPort('SIP',$port_lc);
    CtPkAddPort('SIP',$port_ls);
}
# 
#    mech
#    q
#    alg
#    ealg
#    spi_lc
#    spi_ls
#    port_lc
#    port_ls
#    spi_pc
#    spi_ps
#    port_pc
#    port_ps
sub CtMkSecNego {
    my($node,@sas)=@_;
    my($sa);
    unless($node){$node=$DIRRoot{'ACTND'};}
    unless(ref($node)){$node=CtNDFromName($node);}
    foreach $sa (@sas){
	$node->{'TBL'}->{'UC'}->{'SecurityAgreement'}->{$sa->{'name'}}=$sa;
    }
}

sub CtSetSecNego {
    my($name,$key,$val,$node)=@_;
    unless($node){$node=$DIRRoot{'ACTND'};}
    unless(ref($node)){$node=CtNDFromName($node);}
    $node->{'TBL'}->{'UC'}->{'SecurityAgreement'}->{($name||'SA0')}->{$key}=$val;
}

sub CtSecNego {
    my($name,$key,$node)=@_;
    unless($node){$node=$DIRRoot{'ACTND'};}
    unless(ref($node)){$node=CtNDFromName($node);}
    return $key ? $node->{'TBL'}->{'UC'}->{'SecurityAgreement'}->{($name||'SA0')}->{$key}:
	$node->{'TBL'}->{'UC'}->{'SecurityAgreement'}->{($name||'SA0')};
}


# 401 
#   AKA
#   
#   IPSEC
sub CtAuthModeFrom401 {
    my($inet)=@_;
    my($alg,$nonce,$authmode,$encmode);
    
    $alg = CtFlGet('INET,#SIP,HD,#WWW-Authenticate,challenge,credentials,digestresp,list,algorithm',$inet);
    $nonce = CtFlGet('INET,#SIP,HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',$inet);
    $authmode = ($nonce && ($alg =~ /AKAv1-MD5/i)) ? 'AKA' : 'MD5';
    $encmode = CtFlGet('INET,#SIP,HD,#Security-Server',$inet) ? 'T' :'';
    return $authmode,$encmode;
}

# UE
sub CtAuthAcceptSet {
    my ($node,$inet,$username,$negoname,$remoteip,$localip,$portcL,$portsL,$spicL,$spisL) = @_;
    my ($nonce,$auts,$rand,$sqn,$amf,$mac,$scheme,$aka,$sqnMS,$msg,
	$alg,$ealg,$spicR,$spisR,$portcR,$portsR,$connReq,$policy);
    
    if(CtSecurityScheme() eq 'sipdigest'){
        # cnonce
        CtTbSet('UC,DigestAuth,cnonce',CtFlRandHexStr(8),$node);
	CtTbSet('UC,DigestAuth,realm',
                CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,realm',$inet));
	CtTbSet('UC,DigestAuth,nonce',
                CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',$inet));
	CtTbSet('UC,DigestAuth,qop',
                CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop',$inet));
	return 'SIPDIGEST','',$aka,$sqnMS;
    }
    
    if (CtFlGet('INET,#IP6', $inet)) {
	$remoteip = $remoteip || CtFlGet('INET,#IP6,SrcAddress',$inet);
	$localip  = $localip  || CtFlGet('INET,#IP6,DstAddress',$inet);
    }
    else{
	$remoteip = $remoteip || CtFlGet('INET,#IP4,SrcAddress',$inet);
	$localip  = $localip  || CtFlGet('INET,#IP4,DstAddress',$inet);
    }
    $portsL   = $portsL   || CtSecNego($negoname,'port_ls',$node);
    $portcL   = $portcL   || CtSecNego($negoname,'port_lc',$node);
    $spicL    = $spicL    || CtSecNego($negoname,'spi_lc',$node) || CtMkSPI();
    $spisL    = $spisL    || CtSecNego($negoname,'spi_ls',$node) || CtMkSPI();

    # WWW-Authenticate
    $nonce = CtFlGet('INET,#SIP,HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',$inet);

    # WWW-Authenticate
    if(!$nonce){
	MsgPrint('WAR',"WWW-Authenticate empty\n");
	return 'AUTH-EMPTY';
    }

    ($rand,$sqn,$amf,$mac)=CtAKADecodeAutn($nonce);
#    printf("rand[%s],sqn[%s],amf[%s],mac[%s]\n",$rand,$sqn,$amf,$mac);

    if(CtEnableIpsec()){
	# Security-Server
	if(!CtFlGet('INET,#SIP,HD,#Security-Server',$inet)){
	    MsgPrint('WAR',"Security-Server empty\n");
	    return 'AUTH-EMPTY';
	}
    
	# Security-Server
	$scheme=CtFlGet('INET,#SIP,HD,#Security-Server,mechanism,#Mechanism,name',$inet);
	$alg=CtFlGet('INET,#SIP,HD,#Security-Server,mechanism,#Mechanism,params,tag`$V eq alg`,generic',$inet) || 'hmac-sha-1-96';
	$ealg=CtFlGet('INET,#SIP,HD,#Security-Server,mechanism,#Mechanism,params,tag`$V eq ealg`,generic',$inet) || 'null';
	$spicR=CtFlGet('INET,#SIP,HD,#Security-Server,mechanism,#Mechanism,params,tag`$V eq "spi-c"`,generic',$inet);
	$spisR=CtFlGet('INET,#SIP,HD,#Security-Server,mechanism,#Mechanism,params,tag`$V eq "spi-s"`,generic',$inet);
	$portcR=CtFlGet('INET,#SIP,HD,#Security-Server,mechanism,#Mechanism,params,tag`$V eq "port-c"`,generic',$inet);
	$portsR=CtFlGet('INET,#SIP,HD,#Security-Server,mechanism,#Mechanism,params,tag`$V eq "port-s"`,generic',$inet);
	
#    printf("username[%s] localip[%s] remoteip[%s] scheme[%s] alg[%s] ealg[%s] spicR[%s] spisR[%s] portcR[%s] portsR[%s]\n",
#	   $username,$localip,$remoteip,$scheme,$alg,$ealg,$spicR,$spisR,$portcR,$portsR);
	
	# AKA+IPsec
	($aka,$policy)=CtSASetupByAUTN($username,$negoname,$rand,$sqn,$amf,$remoteip,$localip,$alg,$ealg,
			     $spicR,$spisR,$portcR,$portsR,
			     $portcL,$portsL,$spicL,$spisL,$scheme,'UDP');

	# AKA,IPsec
	CtAuthAgreementSet($negoname,$node,$username,$scheme,$alg,$ealg,$spicR,$spisR,$spicL,$spisL,
			   $portcR,$portsR,$portcL,$portsL,$nonce);

	# HTML 
	CtScAddCaptContext('','AKA',CtAKA($aka));

	# 
	IMSSetkeySetup($username,$negoname);
	sleep(2);
    }
    else{
	$aka=CtFindAKA($username,$negoname) || CtAKACreateByAUTN($username,$negoname,$rand,$sqn,$amf);
	CtTbPrmSet('IMPI',$username);
    }

    # MAC
    $sqn=CtAKAsqn($aka);
    if(CtAKAmac($aka) ne $mac ){
	MsgPrint('ERR',"AKA mac[%s] and xmac[%s] not equal\n",$mac,CtAKAmac($aka));
	return 'AUTH-NG';
    }
    MsgPrint('AKA',"AKA mac ok. SQN[%s] autsmode[%s]\n",$sqn,CtTbCfg('AKA','auts'));
    
    # AUTS
    if(CtTbCfg('AKA','auts') =~ /on/i){
	
	# 
	$sqnMS=CtTbCfg('AKA','auts-seq')||'00000000FFFF';
	
	# 
	if( !SQNinRange($sqnMS,$sqn,1,10,32) ){
	    
# 	    # AUTS
# 	    $auts = CtAKAGetAuts($username,$sqnMS);
# 	    $auts = base64encode( pack('H*',$auts) );
	    
# 	    # REGISTER(auts)
# 	    $msg=sprintf($SIPregAuts,$username,$auts,$alg,$ealg,$spicL,$spisL,$portcL,$portsL);
	    
# 	    # 
# 	    CtIoSendMsg($conn, '', '','', 'dlg0','','',$msg);
# 	    printf("### send REGISTER(auts)\n");
	    
	    # AKA
	    CtAKADelete($username,'all');
	    
	    printf("AUTS: seq no range invalid [%s<%s]\n",$sqnMS,$sqn);
	    return 'AUTS','',$aka,$sqnMS;
	}
	else{
	    printf("AUTS: seq no range OK [%s<%s]\n",$sqnMS,$sqn);
	}
    }

    # ESP
    $connReq = CtCnCreate('','',$portcL,$portsR,$spisR);

    return '',$connReq,$aka;
}

sub CtFindReversePolicy {
    my($inet)=@_;
    my($srcport,$dstport,$transport);

    $transport = CtFlGet('INET,#UDP',$inet) ? 'UDP' : (CtFlGet('INET,#TCP',$inet) ? 'TCP' : 'UDP');
    if( $transport eq 'UDP' ){
	$dstport=CtFlGet('INET,#UDP,DstPort',$inet);
	$srcport=CtFlGet('INET,#UDP,SrcPort',$inet);
    }
    else{
	$dstport=CtFlGet('INET,#TCP,DstPort',$inet);
	$srcport=CtFlGet('INET,#TCP,SrcPort',$inet);
    }
    return CtFindReverseSPfromSP(CtMkPolicyID($srcport,$dstport,$transport));
}

# 
sub CtFindSAfromPkt {
    my($inet)=@_;
    my($srcport,$dstport,$transport);

    $transport = CtFlGet('INET,#UDP',$inet) ? 'UDP' : (CtFlGet('INET,#TCP',$inet) ? 'TCP' : 'UDP');
    if( $transport eq 'UDP' ){
	$dstport=CtFlGet('INET,#UDP,DstPort',$inet);
	$srcport=CtFlGet('INET,#UDP,SrcPort',$inet);
    }
    else{
	$dstport=CtFlGet('INET,#TCP,DstPort',$inet);
	$srcport=CtFlGet('INET,#TCP,SrcPort',$inet);
    }
    return CtFindSAfromSP(CtMkPolicyID($srcport,$dstport,$transport));
}


# CUI 
sub CtMsgDisplay {
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
    if(CtTbCti('SC,ScenarioInfo,Gui')){
        CtGuiMessageBox('','ok',"Press Enter Key and Hang up.");
    }
    else{
        CtMsgDisplay("Press Enter Key and Hang up.");
        if(CtTbCfg('DEBUG', 'sim-continue') || <STDIN>){;}
    }
}
sub WaitUntilKeyPressAndTelephone {
    if(CtTbCti('SC,ScenarioInfo,Gui')){
        CtGuiMessageBox('','ok',"Press Enter Key and make a call.");
    }
    else{
        CtMsgDisplay("Press Enter Key and make a call.");
        if(CtTbCfg('DEBUG', 'sim-continue') || <STDIN>){;}
    }
}
sub WaitUntilKeyPress {
    my($msg)=@_;
    if(CtTbCti('SC,ScenarioInfo,Gui')){
        CtGuiMessageBox('','ok',$msg);
    }
    else{
        CtMsgDisplay("$msg");
        if(CtTbCfg('DEBUG', 'sim-continue') || <STDIN>){;}
    }
}
sub WaitUntilKeyPress2 {
    my($msg,$node)=@_;
    CtScAddImmediateAct($node,sub{WaitUntilKeyPress($msg);return 'NEXT';});
}

# @@ -- SipPf.pm --

# use strict;

##############################################################################
#
# SIP Platform Control
#
##############################################################################

#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $param
#   
#     
#   
#     SIP
#     CtScInit()
#     CT
#     
#       
#       
#       
#       
#-----------------------------------------------------------------------------
sub CtSvInit {
    my ($param) = @_;
    my ($idx, $cur, $dmpParam, $interface,@keys,$key);

    if ($param->{'NODE_TEMPLATE'} eq '') {
        CtSvError('fatal', "NodeTemplate nothing");
        return;
    }
    if ($param->{'ruleSet'} eq '') {
        CtSvError('fatal', "ruleSet nothing");
        return;
    }
    if ($param->{'ruleCategory'} eq '') {
        CtSvError('fatal', "ruleCategory nothing");
        return;
    }

    # 
    CtUtLoadCOCfg("parameter.txt");

    # 
    CtNDRegTempl($param->{'NODE_TEMPLATE'});

    # 
    CtPkRegTempl(\@SIPPacketHexMap);

    # 
    for $idx (0..$#{$param->{'ruleSet'}}) {
        CtRlRegRuleSet($param->{'ruleSet'}[$idx], 'SIP', $param->{'ruleCategory'});
    }

    # 
    CtLgSetLevel('FLOW', 1);

    # IMS
    IMSServiceInitialize($param);

    return '';
}


#-----------------------------------------------------------------------------
# 
#   
#     
#   
#     
#   
#     SIP
#     
#     SIP
#-----------------------------------------------------------------------------
sub CtSvEnd {

    # 
    CtUtSaveCOCfg("parameter.txt");
}


#-----------------------------------------------------------------------------
# 
#   
#     $param
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtSvIO {
    my ($param) = @_;
    my ($ioModule);
    my ($ret, $pcapid, $filename, $filter, $optimize, $netmask, $mac, $intf, $info,$cond,@ports,$port);

    # 
    if (CtTbCfg('DEBUG', 'simulate') eq 'on') {
        # 
        $ioModule = 'SIM'; # IO
    }
    else {
        $ioModule = CtTbCfg('PF', 'modulename');
        if ($ioModule eq '') {
            CtSvError('fatal', "config.txt:[PF]:modulename nothing");
            return '';
        }
    }

    # 
    # KOI
    if ($ioModule eq 'KOI') {
        kCommon::kPacket_Clear(0, 0, 0, 0);
    }
    # 
    elsif ($ioModule eq 'SIM') {
        return '';
    }
    elsif ($ioModule eq 'TAHI') {
	PKTbufInitialize('/tmp/'.CtTbCfg('nut','link0,name'),CtTbCfg('PF', 'moduleparam'));
	# ICMP destination-unreachable
	vCapture('Link0');
	vClear('Link0');
	MsgPrint('INIT',"PKTbuf Link0 filter[%s] start\n",CtTbCfg('PF', 'moduleparam'));
    }
    # RAW
    elsif ($ioModule eq 'RAW') {
	$intf= CtTbCfg('PF','interface') || 'eth0';
	$mac=CtUtGetMac($intf);
	
	# ICMP destination-unreachable
	$info="/sbin/iptables -F";
	system($info);MsgPrint('INIT',$info."\n");
	$info="/sbin/iptables -A OUTPUT -o " . $intf . " -p icmp --icmp-type destination-unreachable -j DROP";
	system($info);MsgPrint('INIT',$info."\n");
	$info="/sbin/iptables -A OUTPUT -o " . $intf . " -p tcp --tcp-flags RST RST -j DROP";
	system($info);MsgPrint('INIT',$info."\n");
	
	# PKTCAP 
	if(CAPInitialize("/tmp/_PKTCAP")){CtScExit('InitFail');}
	
	# PKTCAP 
	CAPClear();
	
	# PKTCAP WAN
	$filter='(icmp6 or icmp or esp or arp or udp port 68 or udp port 67 or udp port 123 or udp port 546 or udp port 547 or udp port 53 or udp port 500 or udp port 5060 or tcp port 5060) and (ether dst ' . $mac . ' or ((ether broadcast or ether multicast) and (not ether src ' . $mac . ')))';
	
	CAPStartCapture($intf,$filter);
	MsgPrint('INIT',"PKTCAP filter:%s\n",$filter);
    }
    # PCAP
    elsif ($ioModule eq 'PCAP') {
        $filename = CtTbCfg('PCAP', 'filename');
        if ($filename eq '') {
            CtSvError('fatal', 'PCAP initialize error: nothing file name');
            return '';
        }
        $filter = CtTbCfg('PCAP', 'filter');
        $optimize = CtTbCfg('PCAP', 'optimize');
        $netmask = CtTbCfg('PCAP', 'netmask');
        ($ret, $pcapid) = OpenPcapDmpData($filename, $filter, $optimize, $netmask);
        if ($ret) {
            CtSvError('fatal', "PCAP initialize error: $ret");
            return '';
        }
        CtTbPrmSet('CI,PCAP_ID', $pcapid);
    }
    # PCAP2
    elsif ($ioModule eq 'PCAP2') {
	unless(CtUtIsFunc('Net::Pcap::open_offline')){
	    eval "use Net::Pcap";
	}
	$mac = CtTbCfg('PCAP', 'target');
        if ($mac eq '') {
            CtSvError('fatal', 'PCAP PCAP initialize error: nothing target mac address');
            return '';
        }
        $filename = CtTbCfg('PCAP', 'filename');
        if ($filename eq '') {
            CtSvError('fatal', 'PCAP initialize error: nothing file name');
            return '';
        }
	if(CtTbCfg('PCAP', 'sip-port')){
	    $filter = 'udp port 5060 or tcp port 5060';
	    @ports=split(',',CtTbCfg('PCAP', 'sip-port'));
	    foreach $port (@ports){
		$filter .= " or udp port $port or tcp port $port";
		CtPkAddPort('SIP', $port);
	    }
	    $filter = '('.$filter.')';
	}
	else{
	    $filter = '(udp port 5060 or tcp port 5060)';
	}
	$cond={'ValidFrame'=>'CtPkSIPEextractPkt','NoRetarnsFrame'=>'T',
#	       'Match'=>sub{($inet)=@_;
#			    return ((CtFlGet('INET,#UDP,SrcPort',$inet)||CtFlGet('INET,#TCP,SrcPort',$inet)) eq 5060 ||
#				    (CtFlGet('INET,#UDP,DstPort',$inet)||CtFlGet('INET,#TCP,DstPort',$inet)) eq 5060);}
	   };
	unless( OpenPcapConn(1,$filename,$filter,$mac,'2way',$cond,$cond,CtTbCfg('PCAP', 'startpos'),CtTbCfg('PCAP', 'startpos')) ){
            CtSvError('fatal', "PCAP initialize error");
            return '';
        }
    }
    # 
    else {
        CtSvError('fatal', "$ioModule is not supported in this version");
        return '';
    }

    return '';
}


#-----------------------------------------------------------------------------
# 
#   
#     $node
#   
#     
#   
#     config
#-----------------------------------------------------------------------------
sub CtCnRecvAny {
    my ($param) = @_;
    my ($conn, $connInf, $module, $SocketID, $fragment);

    # 
    if (CtTbCfg('DEBUG', 'simulate') eq 'on') {
        # 
        $module = 'SIM'; # IO
    }
    else {
        $module = CtTbCfg('PF', 'modulename');
        if ($module eq '') {
            CtSvError('fatal', "modulename nothing");
            return '';
        }
    }

    if ($module eq 'PCAP') {
        $SocketID = CtTbPrm('CI,PCAP_ID');
    }
    elsif ($module eq 'PCAP2') {
        $SocketID = GetPcapConn(1);
    }
    else {
        $SocketID = 0;
    }
    # 
    $fragment = lc(CtTbCfg('PF', 'fragment')) eq 'no' ? '' : 'T';

    $connInf = {
                   'type' => 'SIP',
                   'protocol' => '',
                   'transport' => '',
                   'peer-mac' => '',
                   'peer-ip' => '',
                   'peer-port' => '',
                   'local-mac' => '',
                   'local-ip' => '',
                   'local-port' => '',
                   'interface' => '',
                   'ModuleName' => $module,
                   'VirtualioID' => '',
                   'status' => 'new',
                   'direction' => 'server',
                   'SocketID' => $SocketID,
                   'transport-param' => '',
                   'Node' => '',
		   'FragmentEnable' => $fragment,
                   %$param,
               };

    # 
    $conn = CtCnMake($connInf);

    return $conn;
}


#-----------------------------------------------------------------------------
# 
#   
#     $node
#     $target: 
#      
#        
#   
#     
#   
#     config
#-----------------------------------------------------------------------------
sub CtCnCreate {
    my ($node, $target,$loaclport,$remoteport,$negoname,$policyID,$noipsec,$compartmentID) = @_;
    my ($conn, $connInf, $moduleName, $targetNode, $targetIp, $targetPort,$transport);

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    # 
    if ($target ne '') {
        $targetNode = CtNDFromName($target);
    }
    else {
        $targetNode = CtTbPrm('CI,target');
        if (ref($targetNode) eq 'ARRAY') { $targetNode = $targetNode->[0]; }
    }
    if ($targetNode eq '') {
        CtSvError('fatal', "targetNode nothing");
        return '';
    }
    # 
    $targetIp = CtTbAd('local-ip', $targetNode);
    if ($targetIp eq '') {
        CtSvError('fatal', "target($targetNode->{'ID'}) address nothing");
        return '';
    }
    # IPsec 
    $noipsec = $noipsec || !CtEnableIpsec();

    # 
    if(!$noipsec && !$loaclport && !$remoteport){
	$loaclport = CtSecNego($negoname,'port_lc',$node);
	$targetPort = CtSecNego($negoname,'port_ps',$node);
	$policyID = $policyID || CtMkPolicyID($loaclport,$targetPort);
	if (!$loaclport || !$targetPort) {
	    CtSvError('fatal', "AKA sip-port[%s][%s] nothing\n",$loaclport,$targetPort);
	    return '';
	}
    }
    else{
	$targetPort = $remoteport || CtTbAd('local-port', $targetNode);
	if ($targetPort eq '') {
	    CtSvError('fatal', "target($targetNode->{'ID'}) sip-port nothing");
	    return '';
	}
	$loaclport = $loaclport || CtTbAd('local-port', $node) || 5060;
    }

    # 
    $moduleName = CtTbPrm('CI,ModuleName');
    if ($moduleName eq '') {
        CtSvError('fatal', "moduleName nothing");
        return '';
    }

    if(CtTbCfg('AKA','ipsec-mode') eq 'manual'){
	$moduleName='TAHI';
    }

    if(CtTbCfg('DEBUG','simulate')){
	$moduleName='SIM';
    }

    $transport=($moduleName eq 'RAW' && CtTbAd('transport', $node) eq 'TLS') ? 'TCP' : CtTbAd('transport', $node);

    # 
    if(!$noipsec && !$policyID && CtTbCfg('AKA','ipsec-mode') eq 'manual'){
	$policyID = CtMkPolicyID(CtSecNego($negoname,'port_lc',$node),CtSecNego($negoname,'port_ps',$node));
    }

    $connInf = {
	'type' => 'SIP',
	'protocol' => CtTbAd('protocol', $node),
	'transport' => $transport,
	'peer-mac' => CtTbAd('local-mac', $targetNode),
	'peer-ip' => $targetIp,
	'peer-port' => $targetPort,
	'local-mac' => CtTbAd('local-mac', $node),
	'local-ip' => CtTbAd('local-ip', $node),
	'local-port' => $loaclport,
	'interface' => CtTbAd('interface', $node),
	'ModuleName' => $moduleName,
	'VirtualioID' => '',
	'status' => 'new',
	'direction' => 'client',
	'SocketID' => '',
	'transport-param' => '',
	'policyID' => $policyID,
	'Node' => $node,
	'target' => $targetNode,
	'sigcomp' => $compartmentID,
    };

    # 
    if($moduleName eq 'RAW' && $transport eq 'TCP'){
	CNNBindLayer($connInf,TCPCreateTbl('automode'),'TCP');
	CNNBindLayer($connInf,SSLCreateTbl('client','TLS'),'SSL') if(CtTbAd('transport', $node) eq 'TLS');
	CNNBindLayer($connInf,SIPCreateTbl(),'SIP');
    }

    if($moduleName eq 'PCAP2'){
	$connInf->{'SocketID'}=GetPcapConn(1);
    }

    # 
    if($moduleName eq 'KOI'){
	$conn = CtCnFind($connInf,'KOI');
    }
    $conn = $conn || CtCnMake($connInf,$moduleName eq 'RAW'?$transport:'');

    # 
    push(@{$node->{'CNL'}}, $conn);

    # 
    $DIRRoot{'ACTCNN'} = $conn;
    return $conn;
}


#-----------------------------------------------------------------------------
# 
#   
#     $pkt
#     $conn
#     $param
#   
#     
#   
#     
#-----------------------------------------------------------------------------



# @@ -- SipIo.pm --

# use strict;


##############################################################################
#
# SIP Connection Control
#
##############################################################################

#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $node
#   
#     
#       
#       
#   
#     
#-----------------------------------------------------------------------------
sub CtIoInitConn {
    my ($node) = @_;
    my ($ioModule, $ret,$transport);

    if ($node eq '') {
        CtSvError('fatal', "node nothing");
        return -1;
    }

    $ioModule = CtTbPrm('CI,ModuleName');
    if ($ioModule eq '') {
        CtSvError('fatal', "ModuleName nothing");
        return -100;
    }

    # 
    $ret = 0;
    # KOI
    if ($ioModule eq 'KOI') {
	# 
	CtCheckInterface($node,'T');
	# 
        $ret = CtIoKoiIniListen($node);
    }
    # 
    elsif ($ioModule eq 'SIM') {
        $ret = 0;
    }
    # PCAP/PCAP2
    elsif ($ioModule =~ /PCAP/) {
        $ret = 0;
    }
    elsif ($ioModule eq 'RAW') {
	$transport=CtTbCfg('PF', 'transport');
	# 
	if($transport eq 'TCP' || $transport eq 'TLS'){
	    SipTcpIniListen($node,$transport);
	}
        $ret = 0;
    }
    elsif ($ioModule eq 'TAHI') {
	# 
	CtCheckInterface($node,'T');
        $ret = 0;
    }
    # 
    else {
        CtSvError('fatal', "$ioModule is not supported in this version");
        $ret = 1;
    }

    return $ret;
}


#=============================================================================
# 
#=============================================================================

# SIGCOMP 
sub CtSigcompCompress {
    my($msg,$id)=@_;
    my $scMsg = CtTbSc('SIGCOMP')->{'stack'}->compressMessage($msg, length($msg), $id);
    my $compression=($scMsg->getDatagramLength() * 100) / length($msg);
    return $scMsg->getDatagramMessage(),$compression;
}
sub CtSigcompUnCompress {
    my($msg)=@_;
    my($plane,$stateChanges,$length,$err,$tmpid);

    unless($length=CtTbSc('SIGCOMP')->{'stack'}->uncompressMessage($msg,length($msg),$plane,8192,$stateChanges)){
	my $nack = CtTbSc('SIGCOMP')->{'stack'}->getNack();
	# my $nackMessage = $nack->getDatagramMessage();
	# $nackMessage->dump();
	MsgPrint('ERR',"Sigcomp NACK(%s) ID(%s)\n",$err,$tmpid);
	# 
	return;
    }
    return $plane,$stateChanges;
}

sub CtIsSigcom {
    my($inet)=@_;
    return CtFlGet('INET,#SIGCOMP',$inet);
}

sub CtAcceptCompartment {
    my($inet,$id,$conn,$noAccept)=@_;
    my($stateChanges,$err,$tmpid);
    unless( $stateChanges=CtFlGet('INET,#SIGCOMP',$inet)->{'#SC#'} ){
	MsgPrint('WAR',"Sigcomp message change-state empty\n");
	return;
    }
    $tmpid = $id;
    unless($noAccept){
	CtTbSc('SIGCOMP')->{'stack'}->provideCompartmentId($stateChanges, $id);
    }
    if($conn){
	CtCnGet($conn)->{'sigcomp'} = $tmpid;
    }
}

sub CtCreateUUID {
    my($uri)=@_;
    my($ug);
    $ug = new Data::UUID;
    return $ug->create_from_name_str('NameSpace_URL', $uri || 'www.ims.com');
}

#-----------------------------------------------------------------------------
# SIP
#   
#     $conn
#     $rule
#     $addrule
#     $delrule
#     $dialogid:
#     $msg:SIP
#     $param
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
sub CtIoSendMsg {
    my ($conn, $rule, $addrule, $delrule, $dialogid, $msg, $param, $sendmsg) = @_;
    my ($inetPkt, $sndConn, $timestamp,$scmsg,$spino,$comprssion);
    my ($ret, $node, %context);
    my ($connInf, $ioModule, $msgHex, $targetNode,$sp);

    # 
    if ($msg eq '') {
        $msg = CtUtLastRcvMsg();
    }

    # 
    $context{'usr_dlg'} = $dialogid;
    $context{'usr_pkt'} = $msg;
    $context{'usr_param'} = $param;

    # 
    $connInf = CtCnGet($conn);

    # 
    $node = $connInf->{'Node'};
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return -1, '', '', '';
    }

    # 
    $targetNode = $connInf->{'target'};

    if($rule){
	# 
	$rule = CtRlModify($rule, $addrule, $delrule);
	if ($rule eq '') {
	    CtSvError('fatal', "error rule modify");
	    return -2, '', '', '';
	}
	
	# 
	$ret = CtRlEval($rule, $msg, \%context);
	if ($ret eq '') {
	    CtSvError('fatal', "error encode rule");
	    return -3, '', '', '';
	}
	
	# 
	($ret, $msg) = CtRlGetEvalResult($rule, \%context);
	if ($msg eq '') {
	    CtSvError('fatal', "error get message");
	    return -4, '', '', '';
	}
    }
    else{
	$msg=$sendmsg;
    }

    # SIGCOMP 
    if($connInf->{'sigcomp'}){
	($scmsg,$comprssion) = CtSigcompCompress($msg,$connInf->{'sigcomp'});
    }

    # 
    $ioModule = CtTbAd('ModuleName', $node);

    # KOI
    if ($ioModule eq 'KOI') {
        if ($connInf->{'transport'} eq 'UDP') {
	    if($connInf->{'policyID'}){
		# SPI
		if( ( $sp=CtFindSP( $connInf->{'policyID'} ) ) ){
##		    printf("UDP spi port setup[%s:%s] => [%s:%s]\n",$connInf->{'local-port'},$connInf->{'peer-port'},$sp->{'srcport'},$sp->{'dstport'});
		    $connInf->{'peer-port'}  = $sp->{'dstport'};
		    $connInf->{'local-port'} = $sp->{'srcport'};
		    $spino=CtFindSAfromSP($sp)->{'spino'};
		}
		else{
		    MsgPrint('WAR',"KOI Reverse SP[%s] unknown\n",$connInf->{'policyID'});
		}
	    }
	    else{
		# UDP
		# UDP
		#   
		#     5060
##		printf("UDP[%s] normal port setup[%s:%s] => [%s:%s]\n",
##		       $connInf->{'SocketID'},$connInf->{'local-port'},$connInf->{'peer-port'},$connInf->{'local-port'},CtTbAd('local-port', $targetNode));
		$connInf->{'peer-port'} = CtTbAd('local-port', $targetNode);
##		$connInf->{'local-port'} = '';
	    }
	    $connInf->{'status'} = 'new';
	    $connInf->{'direction'} = 'client';
        }
##	printf("KOI send SP[%s] sock[%s]\n",$connInf->{'policyID'},$connInf->{'SocketID'});
        # 
        $ret = KOISend($conn, $scmsg || $msg, \$sndConn, \$timestamp);
        if ($ret) {
            CtSvError('fatal', $ret);
            return -5, '', '', '';
        }
        # 
        $inetPkt = CtPkInetPacket($sndConn);

        # SIP
        ($msgHex) = CtPkDecode('SIP', unpack('H*', $msg));
	if($scmsg){
	    ($scmsg)=CtPkDecode('SIGCOMP',unpack('H*', $scmsg));
	    $scmsg->{'#COMPID#'} = $connInf->{'sigcomp'};
	    $scmsg->{'#SC#'} = '';
	    $scmsg->{'#COMPRESSION#'} = $comprssion;
	}
        CtPkAddLayer3($inetPkt, $scmsg ? [$scmsg,$msgHex] : $msgHex,  $timestamp);
##	printf("after ID[%s] sock[%s]\n",$sndConn,CtCnGet($sndConn)->{'SocketID'});
	# UDP
	# 
    }
    # 
    elsif ($ioModule eq 'SIM') {
	if($connInf->{'policyID'}){
	    # SPI
	    if( ( $sp=CtFindSP( $connInf->{'policyID'} ) ) ){
		$connInf->{'peer-port'}  = $sp->{'dstport'};
		$connInf->{'local-port'} = $sp->{'srcport'};
		$spino=CtFindSAfromSP($sp)->{'spino'};
	    }
	    else{
		MsgPrint('WAR',"SIM Reverse SP[%s] unknown\n",$connInf->{'policyID'});
	    }
	}
	else{
	    $connInf->{'peer-port'} = CtTbAd('local-port', $targetNode);
	}
	$connInf->{'status'} = 'new';
	$connInf->{'direction'} = 'client';
        # 
        $ret = CtIoSend($conn, $msg, \$sndConn, \$timestamp);
        if ($ret) {
            CtSvError('fatal', $ret);
            return -5, '', '', '';
        }

        # 
        $inetPkt = CtPkInetPacket($sndConn, $msg);
        # SIP
        ($msgHex) = CtPkDecode('SIP', unpack('H*', $msg));
        CtPkAddLayer3($inetPkt, $msgHex, $timestamp);
    }
    elsif ($ioModule eq 'RAW' || $ioModule eq 'TAHI') { # (
	my($sip,$unpackmsg);

	# UDP
	if($connInf->{'transport'} eq 'UDP' && !$connInf->{'policyID'}){
	    $connInf->{'peer-port'} = CtTbAd('local-port', $targetNode);
	    $connInf->{'local-port'} = $connInf->{'local-port'} || 5060;  # 5060
	}
#	printf("port[%s:%s] sp[%s] sock[%s]\n",$connInf->{'local-port'},$connInf->{'peer-port'},$connInf->{'policyID'},$connInf->{'SocketID'});
	# RAW
	if($ioModule eq 'RAW' && !$connInf->{'SocketID'}){
	    $connInf->{'SocketID'}=OpenRawPacket($connInf->{'interface'},$connInf->{'protocol'},
						 $connInf->{'local-mac'},$connInf->{'peer-mac'});
	}

	# 
	$unpackmsg=unpack('H*',$msg);
	($sip)=CtPkDecode('SIP',$unpackmsg);
	$sip->{'#EN#'}=$unpackmsg;
	$sip->{'#TXT#'}=$msg;

	# SSL 
	if(CNNLayer($connInf,'SSL')){
	    my($arg,$user);
	    ($ret,$arg,$user)=SSLSend($conn,$unpackmsg,$sip,'','proceed');
	    if(IsLayerSended($ret)){
		$inetPkt=$arg->[0];
		$ret='';
	    }
	    elsif(IsLayerError($ret)){
		$ret='ERROR';
	    }
	    else{
		PrintVal($ret);
		$ret='';
	    }
	}
	# TCP 
	elsif(CNNLayer($connInf,'TCP')){
	    my($arg,$user);
	    ($ret,$arg,$user)=TCPSend($conn,$unpackmsg,$sip,'','proceed');
	    if(IsLayerSended($ret)){
		$inetPkt=$arg->[0];
		$ret='';
	    }
	    elsif(IsLayerError($ret)){
		$ret='ERROR';
	    }
	    else{
		PrintVal($ret);
		$ret='';
	    }
	}
	# UDP 
	else{
	    if($connInf->{'policyID'}){
		my($payload,$sp);
		# SPI
		$sp=CtFindSP($connInf->{'policyID'});
		$spino=CtFindSAfromSP($sp)->{'spino'};
		$inetPkt=CtPkInetPacket($conn,'','',{'Flag'=>4,'ID'=>0},{'SrcPort'=>$sp->{'srcport'},'DstPort'=>$sp->{'dstport'}});
		CtPkAddLayer3($inetPkt,$sip);
		CtPkSetup($inetPkt);
		# UDP
		$payload=CtPkEncode(CtFlGet('INET,#UDP',$inetPkt)).CtPkEncode(CtFlGet('INET,#SIP',$inetPkt));

		# ESP
		$inetPkt=ESPTransportPayload($conn,CtFindSAfromSP($connInf->{'policyID'}),$INETFLD{'PROTO.UDP'},$payload);
		CtPkSetup($inetPkt);
###		$ret=CtIoSend($conn,CtPkEncode($inetPkt),\$sndConn,\$timestamp);
		($ret)=CtIoSendFragment($conn,$inetPkt,\$sndConn,\$timestamp);
		push(@{$inetPkt->{'INET'}},$sip);
	    }
	    else{
		$inetPkt=CtPkInetPacket($conn,'','',{'Flag'=>4,'ID'=>0});
		CtPkAddLayer3($inetPkt,$sip);
		CtPkSetup($inetPkt);
###		$ret=CtIoSend($conn,CtPkEncode($inetPkt),\$sndConn,\$timestamp);
		($ret)=CtIoSendFragment($conn,$inetPkt,\$sndConn,\$timestamp);
	    }
	    CtPkAddLayer3($inetPkt,'',$timestamp);
	}
        if ($ret) {
            CtSvError('fatal', $ret);
            return -5, '', '', '';
        }
    }
    elsif ($ioModule eq 'PCAP2') {
	my($unpackmsg);
	$ret=CtIoSend($conn,'',\$sndConn,\$timestamp,\$msg);
        if ($ret ne '') {
	    MsgPrint('ERR',"PCAP2 send data empty\n");
            return -5, '', '', '';
        }
	$unpackmsg=unpack('H*',$msg);
	($inetPkt)=CtPkDecode('INET',$unpackmsg);
	CtPkAddLayer3($inetPkt,'',$timestamp);
    }
    # 
    else {
        CtSvError('fatal', "$ioModule is not supported in this version");
        return -100, '', '', '';
    }

    # 
    CtTbAdSet('peer-ip', $connInf->{'peer-ip'}||CtIoPktSrcAd($inetPkt), $node);
    CtTbAdSet('peer-port', $connInf->{'peer-port'}||CtIoPktSrcPort($inetPkt), $node);
    $inetPkt->{'#peer-id#'} = $targetNode->{'ID'};

    # 
    CtIoAddCapt($inetPkt, $node, $sndConn, $node->{'ID'}, $targetNode->{'ID'},$spino ne ''?{'SANO'=>'sa'.$spino}:'');

    if(CtLgLevel('FLOW')){FlowPrint('=>',"%26.26s  (%s)",$msg,ref($rule)?$rule->{'ID'}:$rule)}

    return 0, $inetPkt, $sndConn, $timestamp;
}

#=============================================================================
# 
#=============================================================================
#-----------------------------------------------------------------------------
# 
#   
#     $msg:
#     $conn:
#     $ext:
#     $node:
#     $param:
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
#     
#-----------------------------------------------------------------------------
sub CtIoMtPkt {
    my ($msg, $conn, $ext, $node, $matchfunc, $param) = @_;
    my ($inetPkt, $connInf, $targetNode, $peerTarget, $ret, $user, $payload);
    my ($expMethod, $pktMethod, $espPkt, $spi, $spino, $reverse);

    if ($msg eq '') {
        CtSvError('fatal', "msg nothing");
        return '', '', '', '', '';
    }
    if ($conn eq '') {
        CtSvError('fatal', "conn nothing");
        return '', '', '', '', '';
    }
    if ($node eq '') {
        CtSvError('fatal', "node nothing");
        return '', '', '', '', '';
    }
    if ($param eq '') {
        CtSvError('fatal', "param nothing");
        return '', '', '', '', '';
    }

    # HSS 
    if(CtCnGet($conn)->{'local-port'} eq (CtTbCfg('HSS','port')||3868)){return '',$msg;}

    # 
    if (ref($msg)) {
	$inetPkt = $msg;
    }
    else {
	# 
	($ret,$inetPkt,$node,$user,$conn) = CtIoInetPkt($msg, $conn, $ext, $node, $param);
	if ($ret) {
	    MsgPrint('PRMT',"unmatch CtIoInetPkt NG [%s]\n",$ret);
	    return $ret eq 'PASS' ? 'PASS':'', $inetPkt, $node, $user, $conn;
	}
    }

    # 
    $connInf = CtCnGet($conn);

    # 
    $targetNode = CtTbPrm('CI,target');

    # IP
    ($ret, $peerTarget) = CtIoMtInetPktIp($inetPkt, $node, $targetNode);
    if ($ret) {
	MsgPrint('PRMT',"unmatch CtIoMtInetPktIp NG %s. expect method(%s)\n",$ret,$param->{'method'});
        return '', $inetPkt, '', '', $conn;
    }

    # 
    if(CtFlGet('INET,#ESP', $inetPkt)) {
	if(CtTbCfg('AKA','ipsec-mode') ne 'manual'){
	    MsgPrint('PRMT', "Unexpected ESP packet\n");
	    return '', $inetPkt, '', '', $conn;
	}
	MsgPrint('PRMT', "ESP packet\n");

	# 
	unless( $espPkt=ESPDecryptPacket($inetPkt,$conn) ){
	    return '', $inetPkt, '', '', $conn;
	}
	# UDP
	if( $payload=CtFlGet('INET,#UDP,#PAYLOAD#',$espPkt) ){
	    ($payload)=CtPkDecode('SIP',$payload);
	    push(@{$espPkt->{'INET'}},$payload);
	    # 
	    $connInf->{'transport'} = 'UDP';
	    $connInf->{'peer-port'}  = CtFlGet('INET,#UDP,SrcPort',$espPkt);
	    $connInf->{'local-port'} = CtFlGet('INET,#UDP,DstPort',$espPkt);
	    $connInf->{'policyID'}=CtMkPolicyID($connInf->{'peer-port'},$connInf->{'local-port'},$connInf->{'transport'});
	    MsgPrint('PRMT',"ESP(UDP:SIP) decrypt OK\n");
	}
	else{
	    MsgPrint('PRMT',"ESP non UDP\n");
	}
	$inetPkt=$espPkt;
    }
    elsif(!$connInf->{'policyID'}){
	my($policy);
	if(CtFlGet('INET,#UDP',$inetPkt)){
	    $policy=CtMkPolicyID(CtFlGet('INET,#UDP,SrcPort',$inetPkt),CtFlGet('INET,#UDP,DstPort',$inetPkt),'UDP');
	}
	elsif(CtFlGet('INET,#TCP',$inetPkt)){
	    $policy=CtMkPolicyID(CtFlGet('INET,#TCP,SrcPort',$inetPkt),CtFlGet('INET,#TCP,DstPort',$inetPkt),'TCP');
	}
	if(CtFindSP($policy)){$connInf->{'policyID'}=$policy}
    }
    # SA
    if( ($spino=CtFindSAfromSP($connInf->{'policyID'})) && $spino->{'spino'} ne ''){
	$spino={'SANO'=>'sa'.$spino->{'spino'}};
    }

    # 
    $reverse = CtFindReversePolicy($inetPkt);
    $connInf->{'policyID'} = $reverse;
    MsgPrint('PRMT',"SP reverse setup %s => [%s]\n",$connInf->{'policyID'},$reverse);

    # 
    unless (CtFlGet('INET,#SIP', $inetPkt)) {
        MsgPrint('PRMT', "not SIP packet\n");
        return '', $inetPkt, '', '', $conn;
    }

    # 
    $connInf->{'Node'} = $node;

    # 
    $connInf->{'target'} = $peerTarget;
    CtTbAdSet('peer-ip', $connInf->{'peer-ip'}||CtIoPktSrcAd($inetPkt), $node);
    CtTbAdSet('peer-port', $connInf->{'peer-port'}||CtIoPktSrcPort($inetPkt), $node);
    $inetPkt->{'#peer-id#'} = $peerTarget->{'ID'};

    # 
    if ( $matchfunc->($inetPkt,$param,$node) ){
        CtIoAddCapt($inetPkt, $node, $conn, $peerTarget->{'ID'}, $node->{'ID'},$spino);
        return 'PASS', $inetPkt, $node, '', $conn;
    }

    # 
    CtIoAddCapt($inetPkt, $node, $conn, $peerTarget->{'ID'}, $node->{'ID'},$spino);

    if(CtLgLevel('FLOW')){FlowPrint('<=',"%26.26s",CtFlGet('INET,#SIP,#TXT#', $inetPkt));}
    return 'OK', $inetPkt, $node, '', $conn;
}


#-----------------------------------------------------------------------------
# 
#   
#     $msg:
#     $conn:
#     $ext:
#     $node:
#     $param:
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
#     
#-----------------------------------------------------------------------------
sub CtIoMtReqPkt {
    my ($msg, $conn, $ext, $node, $param) = @_;
    my($matchfunc);

    $matchfunc = sub {
	my($inetPkt,$param,$node)=@_;
	my($pktMethod,$expMethod);
	# 
	$pktMethod = CtFlv('SL,method', $inetPkt);
	$expMethod = $param->{'method'};
	
	# 
	if ($pktMethod !~ /$expMethod/){
	    unless($pktMethod){$pktMethod=CtFlv('SL,code', $inetPkt)}
	    MsgPrint('PRMT',
		     "CtIoMtReqPkt unmatch method:pkt[%s]<>exp[%s]\n",
		     $pktMethod, $expMethod);
	    return 'no match';
	}
	MsgPrint('PRMT',"matched method[%s] node[%s]\n",$pktMethod,$node->{'ID'});
	return ;
    };
    return CtIoMtPkt($msg, $conn, $ext, $node, $matchfunc, $param);
}


#-----------------------------------------------------------------------------
# 
#   
#     $msg:
#     $conn:
#     $ext:
#     $node:
#     $param:
#            
#              code:
#              method:
#              seqnum:
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
#     
#-----------------------------------------------------------------------------
sub CtIoMtResPkt {
    my ($msg, $conn, $ext, $node, $param) = @_;
    my($matchfunc);
    $matchfunc = sub {
	my($inetPkt,$param,$node)=@_;
	my ($pktCode, $pktMethod, $pktSeqNum);
	my ($expCode, $expMethod, $expSeqNum);

	# 
	$pktCode = CtFlv('SL,code', $inetPkt);
	$pktMethod = CtFlv('HD,#CSeq,method', $inetPkt);
	$pktSeqNum = CtFlv('HD,#CSeq,cseqnum', $inetPkt);
	$expCode = $param->{'code'};
	$expMethod = $param->{'method'};
	$expSeqNum = $param->{'seqnum'};
	
	# 
	if ($pktCode !~ /$expCode/) {
	    unless($pktCode){$pktCode=CtFlv('SL,method', $inetPkt)}
	    MsgPrint('PRMT',
		     "CtIoMtResPkt unmatch status code:pkt[%s]<>exp[%s]\n",
		     $pktCode, $expCode);
	    return 'no match';
	}
	
	if ($pktMethod !~ /$expMethod/) {
	    MsgPrint('PRMT',
		     "CtIoMtResPkt unmatch CSeq method:pkt[%s]<>exp[%s]\n",
                 $pktMethod, $expMethod);
	    return 'no match';
	}
	if ($expSeqNum) {
	    if ($pktSeqNum !~ /$expSeqNum/) {
		MsgPrint('PRMT',
			 "CtIoMtResPkt unmatch CSeq number:pkt[%s]<>exp[%s]\n",
			 $pktSeqNum, $expSeqNum);
		return 'no match';
	    }
	}
	MsgPrint('PRMT',"matched status code[%s] method[%s] cseqnum[%s] node[%s]\n",$pktCode,$pktMethod,$pktSeqNum,$node->{'ID'});
	return;
    };
    return CtIoMtPkt($msg, $conn, $ext, $node, $matchfunc, $param);
}


# 
# 
#         
#              ['SL,method', 'INVITE']
#         
#              ['SL,code', '200', 'HD,#CSeq,method', 'INVITE']
#         
#              [ ['HD,#To,addr,uri,userinfo', '05022222222'],['HD,#To,addr,uri,userinfo', '05033333333'] ]
#         
#              [ ['SL,method', 'REGISTER'],
#                [ ['HD,#To,addr,uri,userinfo', '05022222222', 'UA2'],
#                  ['HD,#To,addr,uri,userinfo', '05033333333', 'UA3'] ] ]
sub CtMtPkt {
    my($inetPkt,$param)=@_;
    return CtMtPktIn($inetPkt,$param->{'expr'});
}
sub CtMtPktIn {
    my($inetPkt,$condition)=@_;
    my($val);
    if(ref($condition) eq 'ARRAY'){
	if(ref($condition->[0]) eq 'ARRAY'){
	    # OR
	    foreach $item (@$condition){
		if( !CtMtPktIn($inetPkt,$item) ){return;}
	    }
	    return 'no match';
	}
	else{
	    # AND
	    while(-1<$#$condition){
		$expr=shift(@$condition);
		$val=shift(@$condition);
		unless(CtFlGet($expr,$inetPkt) =~ /$val/){return 'no match'}
	    }
	    return;
	}
    }
    MsgPrint('ERR',"Match pattern(%s) invalid\n",$condition);
    # 
    return 'no match';
}
# 
sub CtIoMtMsgPkt {
    my ($msg, $conn, $ext, $node, $param) = @_;
    return CtIoMtPkt($msg, $conn, $ext, $node, \&CtMtPkt, $param);
}


#=============================================================================
# IO
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $msg:
#     $conn:
#     $ext:
#     $node:
#     $param:
#   
#     
#                
#                
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtIoInetPkt {
    my ($msg, $conn, $ext, $node, $param) = @_;
    my ($inetPkt, $msgHex, $timestamp, $scmsg,$sc);
    my ($ioModule, $connInf, $targetNode,$user);

    # 
    $ioModule = CtTbAd('ModuleName', $node);

    # KOI
    if ($ioModule eq 'KOI') {
        # KOI
        if ($ext eq '') {
            CtSvError('fatal', "ext nothing");
            return 'NG',$msg,$conn,$user,$conn;
        }
        $timestamp = $ext->{'#TimeStamp#'};

	# SIGCOMP 
	if(CtEnableSigcomp()){
	    # SIGCOMP 
	    if( (hex(unpack('H*',substr($msg,0,1))) & 0xF8) eq 0xF8 ){
		$scmsg=unpack('H*',$msg);
		($msg,$sc) = CtSigcompUnCompress($msg);
		unless($msg){
		    # 
		    return 'NG', '',$node,$user,$conn;
		}
	    }
	}

        # 
        $inetPkt = CtPkInetPacket($conn, '', 'in');
        # SIP
        ($msgHex) = CtPkDecode('SIP', unpack('H*', $msg));
	if($scmsg){
	    ($scmsg)=CtPkDecode('SIGCOMP',$scmsg);
	    $scmsg->{'#SC#'}=$sc;
	    $scmsg->{'#COMPID#'}='';
	}
        CtPkAddLayer3($inetPkt, $scmsg ? [$scmsg,$msgHex] : $msgHex, $timestamp);
    }
    # 
    elsif ($ioModule eq 'SIM') {
        # 
        $connInf = CtCnGet($conn);

	# 
	if($connInf->{'context'} eq 'binary'){goto 'RAWMODE'}

        if ($connInf->{'peer-ip'} eq '') {
            # 
            $targetNode = CtTbPrm('CI,target');
            if (ref($targetNode) eq 'ARRAY') { $targetNode = $targetNode->[0]; }
            # peer-ip,peer-port
            $connInf->{'peer-ip'} = $connInf->{'peer-ip'} || CtTbAd('local-ip', $targetNode);
            $connInf->{'peer-port'} = $connInf->{'peer-port'} || CtTbAd('local-port', $targetNode);
        }

        # 
        $timestamp = $ext->{'#TimeStamp#'};
        # 
        $inetPkt = CtPkInetPacket($conn, $msg, 'in');
        # SIP
        ($msgHex) = CtPkDecode('SIP', unpack('H*', $msg));
        CtPkAddLayer3($inetPkt, $msgHex, $timestamp);
    }
    # PCAP/PCAP2
    elsif ($ioModule =~ /PCAP/) {
        ($inetPkt) = CtPkDecode('INET', $msg);
        $inetPkt->{'#PKT#'} = unpack('H*', $msg);
        # inetPkt
        $inetPkt = {%$inetPkt, %$ext};
    }
    elsif ($ioModule eq 'RAW' || $ioModule eq 'TAHI') {
	my($capmsg,$ret);
RAWMODE:
	# 
	($ret,$msg,$inetPkt,$node,$conn,$user,$capmsg)=DoProtocolLayer(@_);

	if($ret eq 'RECVED'){ # TCP
	    $inetPkt = {%$inetPkt, %$ext};
	}
	elsif($ret eq 'UNMATCH'){
	    unless($inetPkt){
		($inetPkt) = CtPkDecode('INET', $msg);
		$inetPkt->{'#PKT#'} = $msg;
		$inetPkt = {%$inetPkt, %$ext};
	    }
	    # UDP
	    if(CtFlGet('INET,#UDP',$inetPkt) && CtFlGet('INET,#SIP',$inetPkt)){
		$conn=NewSessionTahiPacket($conn,$inetPkt);
	    }
	    elsif(CtFlGet('INET,#ESP',$inetPkt)){
		$conn=NewSessionTahiPacket($conn,$inetPkt);
	    }
	}
	else{
	    return $ret?$ret:'NG',$inetPkt,$node,$user,$conn;
	}
    }
    else {
        # 
        CtSvError('fatal', "$ioModule is not supported in this version");
        return 'NG', $msg,$node,$user,$conn;
    }

    return '', $inetPkt,$node,$user,$conn;
}


#-----------------------------------------------------------------------------
# 
#   
#     $inetPkt:
#     $node:
#     $targetNode:
#   
#     
#       
#       
#     
#   
#     
#     
#-----------------------------------------------------------------------------
sub CtIoMtInetPktIp {
    my ($inetPkt, $node, $targetNode) = @_;
    my ($pktDstIp, $pktSrcIp, $nodeIp, $targetIp, $peerNode, $cur);

    # 
    $nodeIp = CtTbAd('local-ip', $node);

    $peerNode = '';
    if (ref($targetNode) ne 'ARRAY') { $targetNode = [$targetNode]; }

    # 
    if (CtFlGet('INET,#IP6', $inetPkt)) {
        # 
        $pktDstIp = CtFlGet('INET,#IP6,DstAddress', $inetPkt);
        unless ( CtUtV6Eq($nodeIp, $pktDstIp) ) {
            return "not match IP address: node[$nodeIp] <> packet[$pktDstIp]\n", '';
        }

        # 
        $pktSrcIp = CtFlGet('INET,#IP6,SrcAddress', $inetPkt);
        foreach $cur (@$targetNode) {
            $targetIp = CtTbAd('local-ip', $cur);
            if ( CtUtV6Eq($targetIp, $pktSrcIp) ) {
                $peerNode = $cur;
                last;
            }
        }
    }
    # 
    else {
        # 
        $pktDstIp = CtFlGet('INET,#IP4,DstAddress', $inetPkt);
        unless ( CtUtV4Eq($nodeIp, $pktDstIp) ) {
            return "not match IP address: node[$nodeIp] <> packet[$pktDstIp]\n", '';
        }

        # 
        $pktSrcIp = CtFlGet('INET,#IP4,SrcAddress', $inetPkt);
        foreach $cur (@$targetNode) {
            $targetIp = CtTbAd('local-ip', $cur);
            if ( CtUtV4Eq($targetIp, $pktSrcIp) ) {
                $peerNode = $cur;
                last;
            }
        }
    }

    # 
    if ($peerNode eq '') {
        return "not match target IP address[$pktSrcIp]\n", '';
    }

    return '', $peerNode;
}


#-----------------------------------------------------------------------------
# 
#   
#     $pkt:
#     $node:
#     $conn:
#     $sndNodeID:
#     $rcvNodeID:
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtIoAddCapt {
    my ($pkt, $node, $conn, $sndNodeID, $rcvNodeID,$etc) = @_;
    my ($dir, $pktMethod, $pktComment, $pktLine);

    # 
    if ($node->{'ID'} eq $sndNodeID) {
        $dir = 'out';
    }
    else {
        $dir = 'in';
    }

    # 
    $pktMethod = CtFlv('SL,method', $pkt);
    # 
    if ($pktMethod ne '') {
        # 
        $pktComment = CtFlv('SL,#TXT#', $pkt);
        $pktComment =~ s/\r\n//;
    }
    # 
    else {
        $pktMethod = CtFlv('SL,code', $pkt);
        # 
        $pktComment = CtFlv('HD,#CSeq,#TXT#', $pkt);
        $pktComment =~ s/\r\n//;
    }
    # 
    unless($sndNodeID && $rcvNodeID){MsgPrint('WAR',"Capture Frame name invalid [%s:%s]\n",$sndNodeID,$rcvNodeID);}
    $pktLine = "$sndNodeID:$rcvNodeID";

    # 
    CtScAddCapt($node, $pkt, $dir, $conn, 'SIP', $pktMethod, $pktComment, $pktLine,$etc);

    return $pkt;
}

# TCP/SSL 

# 
sub CtCheckInterface {
    my ($node,$senarioNodeOnly) = @_;
    my ($ifName, $prot, $ip, $prefix);
    my ($curNode,$autoRouter);

    # 
    foreach $curNode (@$node) {
	if( $senarioNodeOnly && $curNode->{'BACK'} ){next;}
        # 
        $ifName = CtTbAd('interface', $curNode);
        if ($ifName eq '') {
            MsgPrint('WAR', "config.txt:[%s]:interface nothing\n", $curNode->{'ID'});
            next;
        }

        # 
        $prot = CtTbAd('protocol', $curNode);
        if ($prot eq '') {
            MsgPrint('WAR', "config.txt:[%s]:protocol nothing\n", $curNode->{'ID'});
            next;
        }
        if ($prot ne 'INET' && $prot ne 'INET6') {
            MsgPrint('WAR', "config.txt:[%s]:protocol invalid(%s)\n",
                     $curNode->{'ID'}, $prot);
            next;
        }

        # 
        $ip = CtTbAd('local-ip', $curNode);
        if ($ip eq '') {
            MsgPrint('WAR', "config.txt:[%s]:address nothing\n", $curNode->{'ID'});
            next;
        }

        # 
        unless( ($prefix = CtTbAd('prefixlen', $curNode)) ){
	    $prefix = $prot eq 'INET' ? 24 : 64;
        }

	# 
	CtSetIntAD($ifName,$prot,$ip,$prefix);
    }

    # 
    $autoRouter = CtTbPrm('CI,Auto_Router_Address');
    # 
    $ip = CtTbPrm('CI,Router_Address');
    # 
    $prefix = CtTbPrm('CI,Router_Prefix');
    # 
    $prot = CtTbPrm('CI,protocol');
    # 
    $ifName = CtTbPrm('CI,interface');
    # 
    if ( ($autoRouter =~ /^(ON|YES)$/i) && $ip) {
	# 
	CtSetIntAD($ifName,$prot,$ip,$prefix);
    }

    # 
    $ip = CtTbPrm('CI,gateway');
    # 
    $prot = CtTbPrm('CI,protocol');
    if($ip && $prot){
	CtSetIntDR($ifName,$prot,$ip);
    }

    return 0;
}

# 
sub CtSetIntAD {
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
    unless($inftbl->{$intf}->{$prot}->{$ip} && $inftbl->{$intf}->{$prot}->{$ip}->{'mask'} eq $prefix){
	MsgPrint('WAR', "Interface[%s] no setup address[%s/%d]\n",$intf,$ad,$prefix);
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

# 
sub CtSetIntDR {
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
    unless((grep{$_ eq $prot}(@proto)) && $inftbl->{'DRoute'}->{$prot}->{$ip}){
	$op=((grep{$_ eq $prot}(@proto))?'change':'add');
	MsgPrint('WAR', "Interface[%s] no setup default route[%s],$op\n",$intf,$ad);
	# 
	if($prot eq 'ipv6'){
	    $ret=SetDRoute(CtUtHexToIP($ip,'v6'),$prot,'','',$op);
	}
	else{
	    $ret=SetDRoute(CtUtHexToIP($ip,'v4'),$prot,'','',$op);
	}
	if($ret){
	    MsgPrint('ERR',"Set default route invalid. [%s]\n",$ret);
	}
	else{
	    # 
	    $inftbl->{'DRoute'}->{$prot}->{$ip}={'inf'=>$intf};
	}
    }
}

#=============================================================================
# KOI
#=============================================================================

#-----------------------------------------------------------------------------
# KOI
#   
#     $node
#   
#     
#       
#       
#   
#     
#-----------------------------------------------------------------------------
sub CtIoKoiIniListen {
    my ($node) = @_;
    my ($curNode,$flg,$ret);

    if (ref($node) ne 'ARRAY') {
        CtSvError('fatal', "node is not ARRAY");
        return -200;
    }

    # 
    #$ret = CtIoKoiSetupInterface($node);
    #if ($ret) { return $ret; }

   # 
    foreach $curNode (@$node) {
	if(!$curNode->{'BACK'}){
	    # HSS
	    if( $curNode->{'ID'} eq 'HSS' ){
		my $path = CtTbCfg('PF','diameterpath') || '/usr/local/koi/libdata/kParserDiameter.o';
		unless(-e $path){
		    MsgPrint('ERR',"Diameter Parser module(%s) no exist\n",$path);
		    exit;
		}
		kCommon::kPacket_ParserDetach('Diameter',100);
		kCommon::kPacket_ParserAttach('Diameter',100,'kParserDiameter',$path,'');
		MsgPrint('INIT',"Diameter Parser module(%s) loaded\n",$path);
	    }
	    if(CtIoKoiListen($curNode)){$flg='T';}
	}
    }
    unless ($flg) {
        CtSvError('fatal', "nothing receive connection");
        return -201;
    }
    return ;
}
sub CtIoKoiListen {
    my ($node,$intf,$porotocol,$localip,$localport,$transport) = @_;
    my ($connInf,$prot, $trans, $ip, $port, $ifName);
    my ($tcpPortLst, $curPort, $flg, $udpBindLst, $curAddr,$ret,$conn,$frameid);

    #  bind 
    unless($udpBindLst=CtTbPrm('koi,udpbind')){
	$udpBindLst=[];
	CtTbPrmSet('koi,udpbind',$udpBindLst);
    }
    unless($udpBindLst=CtTbPrm('koi,tcpbind')){
	$tcpPortLst=[];
	CtTbPrmSet('koi,tcpbind',$tcpPortLst);
    }

    # 
    unless( $prot = $porotocol || CtTbAd('protocol', $node) ){return;}

    # 
    unless( $trans = $transport || CtTbAd('transport', $node) ){return;}
    # 
    unless( $ip = $localip || CtTbAd('local-ip', $node) ){return;}
    # 
    unless( $port = $localport || CtTbAd('local-port', $node) ){return;}
    # 
    $frameid = CtTbAd('msg-protocol', $node) || 'SIP';

    # 
    unless( $ifName = $intf || CtTbAd('interface', $node) ){return;}
    
    # TCP
    if ($trans eq 'TCP' || $trans eq 'TLS') {
	# 
	$flg = '';
	foreach $curPort (@$tcpPortLst) {
	    if ($curPort == $port) {
		$flg = 'ON';
		last;
	    }
	}
	if ($flg) {return;}
	push(@$tcpPortLst, $port);
    }
    else {
	# 
	$flg = '';
	if ($prot eq 'INET6') {
	    foreach $curAddr (@$udpBindLst) {
		if ( CtUtV6Eq($curAddr->{'ip'}, $ip) && $curAddr->{'port'} == $port) {
		    $flg = 'ON';
		    last;
		}
	    }
	}
	else {
	    foreach $curAddr (@$udpBindLst) {
		if ( CtUtV4Eq($curAddr->{'ip'}, $ip) && $curAddr->{'port'} == $port) {
		    $flg = 'ON';
		    last;
		}
	    }
	}
	if ($flg) {return;}
	push(@$udpBindLst, {'ip' => $ip, 'port' => $port});
    }
    
    MsgPrint('INIT',"Koi listen bind starting [%s][%s][%s][%s][%s][%s]\n",$ifName,$prot,$ip,$port,$trans,$frameid);

    # 
    $connInf = {
	'type' => 'SIP',
	'protocol' => $prot,
	'transport' => $trans,
	'peer-mac' => '',
	'peer-ip' => '',
	'peer-port' => '',
	'local-mac' => '',
	'local-ip' => $ip,
	'local-port' => $port,
	'interface' => $ifName,
	'ModuleName' => 'KOI',
	'VirtualioID' => '',
	'status' => 'new',
	'direction' => 'server',
	'SocketID' => '',
	'transport-param' => '',
	'msg-protocol' => $frameid,
	'Node' => $node,
    };
    $conn = CtCnMake($connInf);
    
    # KOI
    $ret = KOIRecvStart($conn);
    if ($ret) {
	CtSvError('fatal', "Can't listen: " .
		     "type[$connInf->{'type'}] " .
		     "protocol[$connInf->{'protocol'}] " .
		     "msg-protocol[$connInf->{'msg-protocol'}] " .
		     "transport[$connInf->{'transport'}] " .
		     "peer-mac[$connInf->{'peer-mac'}] " .
		     "peer-ip[$connInf->{'peer-ip'}] " .
		     "peer-port[$connInf->{'peer-port'}] " .
		     "local-mac[$connInf->{'local-mac'}] " .
		     "local-ip[$connInf->{'local-ip'}] " .
		     "local-port[$connInf->{'local-port'}] " .
		     "interface[$connInf->{'interface'}] " .
		     "ModuleName[$connInf->{'ModuleName'}] " .
		     "VirtualioID[$connInf->{'VirtualioID'}] " .
		     "status[$connInf->{'status'}] " .
		     "direction[$connInf->{'direction'}] " .
		     "SocketID[$connInf->{'SocketID'}] " .
		     "transport-param[$connInf->{'transport-param'}] " .
		     "Node ID[$connInf->{'Node'}->{'ID'}]");
    }

    return $conn;
}


#-----------------------------------------------------------------------------
# 
#   
#     $node
#   
#     
#       
#       
#   
#     
#     
#     
#-----------------------------------------------------------------------------
sub CtIoKoiSetupInterface {
    my ($node) = @_;
    my (@ifInf);
    my ($ret, $curIfInf);

    # 
    ($ret, @ifInf) = CtIoKoiCreateIfInf($node,'T');
    if ($ret) { return $ret; }

    # 
    foreach $curIfInf (@ifInf) {
        $ret = CtIoKoiSetupIfAddress($curIfInf);
        if ($ret) { return $ret; }
    }

    # 
    $ret = CtIoKoiSetupRouter();
    if ($ret) { return $ret; }

    # 
    $ret = CtIoKoiSetupDefaultGateway();
    if ($ret) { return $ret; }

    return 0;
}


#-----------------------------------------------------------------------------
# KOI
#   
#     $node
#   
#     
#       
#         
#         
#     
#       
#   
#     KOI
#-----------------------------------------------------------------------------
sub CtIoKoiCreateIfInf {
    my ($node,$senarioNodeOnly) = @_;
    my (@ifInf, $ret);
    my ($ifName, $prot, $ip, $port, $prefix, $router);
    my ($curNode, $idx, $flg, $curAddress);

    foreach $curNode (@$node) {
	if( $senarioNodeOnly && $curNode->{'BACK'} ){next;}
        # 
        $ifName = CtTbAd('interface', $curNode);
        if ($ifName eq '') {
            MsgPrint('WAR', "config.txt:[%s]:interface nothing\n", $curNode->{'ID'});
            next;
        }

        # 
        $prot = CtTbAd('protocol', $curNode);
        if ($prot eq '') {
            MsgPrint('WAR', "config.txt:[%s]:protocol nothing\n", $curNode->{'ID'});
            next;
        }
        if ($prot ne 'INET' && $prot ne 'INET6') {
            MsgPrint('WAR', "config.txt:[%s]:protocol invalid(%s)\n",
                     $curNode->{'ID'}, $prot);
            next;
        }

        # 
        $ip = CtTbAd('local-ip', $curNode);
        if ($ip eq '') {
            MsgPrint('WAR', "config.txt:[%s]:address nothing\n", $curNode->{'ID'});
            next;
        }

        # 
        $port = CtTbAd('local-port', $curNode);

        # 
        $prefix = CtTbAd('prefixlen', $curNode);
        if ($prefix eq '') {
            if ($prot eq 'INET') {
                $prefix = 24;
            }
            else {
                $prefix = 64;
            }
        }

        # 
        $router = CtTbAd('router', $curNode);

        # 
        for ($idx = 0, $flg = 0; $idx <= $#ifInf; ++$idx) {
            if ($ifInf[$idx]->{'interface'} eq $ifName) {
                $flg = 1;
                last;
            }
        }
        # 
        if ($flg == 0) {
            if ($prot eq 'INET') {
                push(@ifInf, {'interface' => $ifName,
                              'IPv4' => [{'local-ip' => $ip,
                                          'local-port' => $port,
                                          'prefixlen' => $prefix,
                                          'router' => $router}],
                              'IPv6' => []});
            }
            else {
                push(@ifInf, {'interface' => $ifName,
                              'IPv4' => [],
                              'IPv6' => [{'local-ip' => $ip,
                                          'local-port' => $port,
                                          'prefixlen' => $prefix,
                                          'router' => $router}]});
            }
        }
        else {
            if ($prot eq 'INET') {
                # 
                foreach $curAddress (@{$ifInf[$idx]->{'IPv4'}}) {
                    $ret = CtUtV4Eq($curAddress->{'local-ip'}, $ip);
                    if ($ret) {
                        MsgPrint('WAR', "duplicate address: ip[%s]\n", $ip);
                        last;
                    }
                }
                if (!($ret)) {
                    # 
                    push(@{$ifInf[$idx]->{'IPv4'}},
                         {'local-ip' => $ip,
                          'local-port' => $port,
                          'prefixlen' => $prefix,
                          'router' => $router});
                }
            }
            else {
                # 
                foreach $curAddress (@{$ifInf[$idx]->{'IPv6'}}) {
                    $ret = CtUtV6Eq($curAddress->{'local-ip'}, $ip);
                    if ($ret eq 'OK') {
                        MsgPrint('WAR', "duplicate address: ip[%s]\n", $ip);
                        last;
                    }
                }
                if ($ret ne 'OK') {
                    # 
                    push(@{$ifInf[$idx]->{'IPv6'}},
                         {'local-ip' => $ip,
                          'local-port' => $port,
                          'prefixlen' => $prefix,
                          'router' => $router});
                }
            }
        }
    }

    return 0, @ifInf;
}


#-----------------------------------------------------------------------------
# 
#   
#     $ifInf
#   
#     
#       
#       
#   
#     
#     (
#-----------------------------------------------------------------------------
sub CtIoKoiSetupIfAddress {
    my ($ifInf) = @_;
    my ($ret, $cur, $addr, $ad, @ip6,@ip4);

    foreach $cur (@{$ifInf->{'IPv6'}}) {
	push(@ip6,{'ip'=>$cur->{'local-ip'},'mask'=>$cur->{'prefixlen'}});
	MsgPrint('INIT',"Set interface[%s] v6 address[%s/%s]\n",$ifInf->{'interface'},$cur->{'local-ip'},$cur->{'prefixlen'});
    }
    if(-1<$#ip6){
	$ret=SetIFIPv6('set',$ifInf->{'interface'},\@ip6,'');
    }
    foreach $cur (@{$ifInf->{'IPv4'}}) {
	push(@ip4,{'ip'=>$cur->{'local-ip'},'mask'=>$cur->{'prefixlen'}});
	MsgPrint('INIT',"Set interface[%s] v4 address[%s/%s]\n",$ifInf->{'interface'},$cur->{'local-ip'},$cur->{'prefixlen'});
    }
    if(-1<$#ip4){
	$ret=SetIFIPv4('set',$ifInf->{'interface'},\@ip4,'');
    }

    # 
    unless($ret){return;}

    # 
    if(-1<$#ip6){
	$addr=GetIFIPv6($ifInf->{'interface'});
	if($#$addr ne $#ip6){
            CtSvError('fatal',"CtUtSetIP6 error intf[%s]\n",$ifInf->{'interface'} );
            return -406;
	}
	foreach $ad (@ip6){
	    if(!grep{CtUtV6Eq($_->{'ip'},$ad->{'ip'})}(@$addr)){
		CtSvError('fatal',"CtUtSetIP6 can't set [%s/%s] intf[%s]\n",$ad->{'ip'},$ad->{'mask'},$ifInf->{'interface'} );
		return -406;
	    }
	}
    }
    if(-1<$#ip4){
	$addr=GetIFIPv4($ifInf->{'interface'});
	if($#$addr ne $#ip4){
            CtSvError('fatal',"SetIFInfo4 error intf[%s]\n",$ifInf->{'interface'} );
            return -406;
	}
	foreach $ad (@ip4){
	    if(!grep{CtUtV4Eq($_->{'ip'},$ad->{'ip'})}(@$addr)){
		CtSvError('fatal',"SetIFInfo4 can't set [%s/%s] intf[%s]\n",$ad->{'ip'},$ad->{'mask'},$ifInf->{'interface'} );
		return -406;
	    }
	}
    }
    return 0;
}


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
#     (
#-----------------------------------------------------------------------------
sub CtIoKoiSetupRouter {
    my ($autoRouter, $routerIp, $routerPrefix, $prot, $interface);
    my ($ret, $id, $mac, $ipinf, $rt, $cur);

    # 
    $autoRouter = CtTbPrm('CI,Auto_Router_Address');
    # 
    $routerIp = CtTbPrm('CI,Router_Address');
    # 
    $routerPrefix = CtTbPrm('CI,Router_Prefix');
    # 
    $prot = CtTbPrm('CI,protocol');
    # 
    $interface = CtTbPrm('CI,interface');

    # 
    if ($autoRouter !~ /^(ON|YES)$/i || $routerIp eq '') {
        return 0;
    }

    # 
    if ($prot eq 'INET6') {
        $ipinf = GetIFIPv6($interface);
        if ($#$ipinf < 0) {
            CtSvError('fatal', "CtUtGetIP6 error: ret[$ret] id[$interface]");
            return -516;
        }
        foreach $cur (@$ipinf) {
            if ( CtUtV6Eq($cur->{'ip'}, $routerIp)  ) {
                # 
                return 0;
            }
        }
    }
    else {
        $ipinf = GetIFIPv4($interface);
        if ($#$ipinf < 0) {
            CtSvError('fatal', "CtUtGetIP4 error: ret[$ret] id[$interface]");
            return -514;
        }
        if (ref($ipinf) ne 'ARRAY') { $ipinf = [$ipinf]; }
        foreach $cur (@$ipinf) {
            if ( CtUtV4Eq($cur->{'ip'}, $routerIp)  ) {
                # 
                return 0;
            }
        }
    }

    if ($prot eq 'INET6') {
        if ($routerPrefix eq '' || $routerPrefix < 0 || $routerPrefix > 64) {
            MsgPrint('WAR', "error range prefix[%d] -> 64\n", $routerPrefix);
            $routerPrefix = 64;
        }
        if( SetIFIPv6('add', $interface, $routerIp, $routerPrefix)) {
	    # IPv6
	    # 
	    sleep(2);
	}
    }
    else {
        if ($routerPrefix eq '' || $routerPrefix < 0 || $routerPrefix > 32) {
            MsgPrint('WAR', "error range prefix[%d] -> 24\n", $routerPrefix);
            $routerPrefix = 24;
        }
        SetIFIPv4('add', $interface, $routerIp, $routerPrefix);
    }

    return 0;
}


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
#-----------------------------------------------------------------------------
sub CtIoKoiSetupDefaultGateway {
    my ($gateway, $prot, $interface, $router,$ret);

    # 
    $gateway = CtTbPrm('CI,gateway');
    if ($gateway eq '') {
        return 0;
    }
    # 
    $prot = CtTbPrm('CI,protocol');
    # 
    $interface = CtTbPrm('CI,interface');

    if ($prot eq 'INET6') {
        $ret = GetDefGateway6($interface, $router);
        if ($router ne $gateway) {
            $ret = SetDefGateway6('add', $interface, $gateway);
            if ($ret != 0) {
                CtSvError('fatal',
                             "SetDefGateway6 error: ret[$ret] " .
                             "mode[add] " .
                             "ifname[$interface] " .
                             "ip[$gateway]");
                return -606;
            }
        }
    }
    else {
        $ret = GetDefGateway($interface, $router);
        if ($router ne $gateway) {
            $ret = SetDefGateway('add', $interface, $gateway);
            if ($ret != 0) {
                CtSvError('fatal',
                             "SetDefGateway error: ret[$ret] " .
                             "mode[add] " .
                             "ifname[$interface] " .
                             "ip[$gateway]");
                return -604;
            }
        }
    }

    return 0;
}


# 
sub CtIoPktSrcAd {
    my($inet)=@_;
    my($val);
    $val = $INETTypeNameID{CtFlGet('INET,#EH,Type',$inet)};
    return $val eq 'IPV4' ? CtFlGet('INET,#IP4,SrcAddress',$inet):
	($val eq 'IPV6' ? CtFlGet('INET,#IP6,SrcAddress',$inet):'');
}
sub CtIoPktSrcPort {
    my($inet)=@_;
    return CtFlGet('INET,#UDP',$inet) ? CtFlGet('INET,#UDP,SrcPort',$inet) :
	(CtFlGet('INET,#TCP',$inet) ? CtFlGet('INET,#TCP,SrcPort',$inet) : '');
}

sub UnknownPacket {};

# @@ -- SipLog.pm --

# use strict;

##############################################################################
#
# SIP Log Output Control
#
##############################################################################

## DEF.VAR
#=============================================================================
# 
#=============================================================================

%SipRuleCategory =
(
    'Message'				=> {'0D' => 9000},

    # 
    'Request'               => {'OD' => 10000},
    'Status'                => {'OD' => 10000},

    # 
    'Header'                => {'OD' => 30000},
    'Accept'                => {'OD' => 30101},
    'Accept-Encoding'       => {'OD' => 30102},
    'Accept-Language'       => {'OD' => 30103},
    'Alert-Info'            => {'OD' => 30104},
    'Allow'                 => {'OD' => 30105},
    'Authentication-Info'   => {'OD' => 30106},
    'Authorization'         => {'OD' => 30107},
    'Call-ID'               => {'OD' => 30301},
    'Call-Info'             => {'OD' => 30302},
    'Contact'               => {'OD' => 30303},
    'Content-Disposition'   => {'OD' => 30304},
    'Content-Encoding'      => {'OD' => 30305},
    'Content-Language'      => {'OD' => 30306},
    'Content-Length'        => {'OD' => 30307},
    'Content-Type'          => {'OD' => 30308},
    'CSeq'                  => {'OD' => 30309},
    'Date'                  => {'OD' => 30401},
    'Error-Info'            => {'OD' => 30501},
    'Expires'               => {'OD' => 30502},
    'From'                  => {'OD' => 30601},
    'History-Info'          => {'OD' => 30801},
    'In-Reply-To'           => {'OD' => 30901},
    'MIME-Version'          => {'OD' => 31301},
    'Max-Forwards'          => {'OD' => 31302},
    'Min-Expires'           => {'OD' => 31303},
    'Min-SE'                => {'OD' => 31304},
    'Organization'          => {'OD' => 31501},
    'P-Access-Network-Info' => {'OD' => 31601},
    'P-Asserted-Identity'   => {'OD' => 31602},
    'P-Associated-URI'      => {'OD' => 31603},
    'P-Called-Party-ID'     => {'OD' => 31604},
    'P-Charging-Function-Addresses' => {'OD' => 31605},
    'P-Charging-Vector'     => {'OD' => 31606},
    'P-Preferred-Identity'  => {'OD' => 31607},
    'P-Visited-Network-ID'  => {'OD' => 31608},
    'Path'                  => {'OD' => 31609},
    'Priority'              => {'OD' => 31610},
    'Privacy'               => {'OD' => 31611},
    'Proxy-Authenticate'    => {'OD' => 31612},
    'Proxy-Authorization'   => {'OD' => 31613},
    'Proxy-Require'         => {'OD' => 31614},
    'RAck'                  => {'OD' => 31801},
    'RSeq'                  => {'OD' => 31802},
    'Record-Route'          => {'OD' => 31803},
    'Reply-To'              => {'OD' => 31804},
    'Require'               => {'OD' => 31805},
    'Retry-After'           => {'OD' => 31806},
    'Route'                 => {'OD' => 31807},
    'Security-Client'       => {'OD' => 31901},
    'Security-Server'       => {'OD' => 31902},
    'Security-Verify'       => {'OD' => 31903},
    'Server'                => {'OD' => 31904},
    'Service-Route'         => {'OD' => 31905},
    'Session-Expires'       => {'OD' => 31906},
    'Subject'               => {'OD' => 31907},
    'Supported'             => {'OD' => 31908},
    'Timestamp'             => {'OD' => 32001},
    'To'                    => {'OD' => 32002},
    'Unsupported'           => {'OD' => 32101},
    'User-Agent'            => {'OD' => 32102},
    'Via'                   => {'OD' => 32201},
    'WWW-Authenticate'      => {'OD' => 32301},
    'Warning'               => {'OD' => 32302},
    'Other'                 => {'OD' => 39999},

    # 
    'Body'                  => {'OD' => 50000},
    'a='                    => {'OD' => 50101},
    'b='                    => {'OD' => 50201},
    'c='                    => {'OD' => 50301},
    'e='                    => {'OD' => 50501},
    'i='                    => {'OD' => 50901},
    'k='                    => {'OD' => 51101},
    'm='                    => {'OD' => 51301},
    'o='                    => {'OD' => 51501},
    'p='                    => {'OD' => 51601},
    'r='                    => {'OD' => 51801},
    's='                    => {'OD' => 51901},
    't='                    => {'OD' => 52001},
    'u='                    => {'OD' => 52101},
    'v='                    => {'OD' => 52201},
    'z='                    => {'OD' => 52601},

    # 
    'Timer'                 => {'OD' => 70000},

    # 
    'SIP'                   => {'OD' => 90000},
    'UDP'                   => {'OD' => 90100},
    'TCP'                   => {'OD' => 90100},
    'TLS'                   => {'OD' => 90100},
    'IP'                    => {'OD' => 90200},
    'RTP'                   => {'OD' => 90500},

	'Other'					=> {'OD' => 97000},
);
## DEF.END


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $nodeInf
#                node: 
#                logPos: HTML
#     $dhcpNode
#   
#     
#   
#     HTML
#-----------------------------------------------------------------------------
sub CtLgRegistTempl {
    my($target,@nodes,$titleline,$secondline,$linedb,$logTemplate);

    # 
    $target=CtTbPrm('CI,target');
    @nodes=map{$_->{'node'}}(@{CtTbPrm('CI,nodeorder')});

    ($titleline,$secondline,$linedb)=MkSeqLine(\@nodes,$target->{'ID'},8);

    $logTemplate={
 	'HD'=>[ {'fmt'=>"                             $titleline\n",'arg'=>''}
 		,{'fmt'=>"                                $secondline\n",'arg'=>''}],
 	'FT'=>[ {'fmt'=>'','arg'=>''}],
 	'LINE'=>{'fmt'=>"%s%-14.14s%s|%s%s %s",'arg'=>[\q{($PKT->{Type} eq 'UN')?'<font color="orange">':''},\q{$NM},
						       \q{($PKT->{Type} eq 'UN')?'</font>':''},
						       \q{$PKT->{'SANO'}?$PKT->{'SANO'}:' * '},
						       \q{$LINE},\q{$PKT->{Comment}}]},
 	'LINEDB'=>$linedb,};
    CtLgRegSeq($logTemplate,
                 {'SKIP' => {'SIP'  => ['EH', 'IP4', 'IP6', 'UDP', 'TCP'],
			     'DHCP' => ['EH', 'IP4', 'IP6', 'UDP', 'TCP'],
			     'HSS'  => ['EH', 'IP4', 'IP6', 'UDP', 'TCP'],
			 }},
                 '','','','7.2');
}

#-----------------------------------------------------------------------------
# 
#   
#     
#   
#     
#   
#     logPos
#-----------------------------------------------------------------------------
sub CtLgSortPos {
    if ($a->{'logPos'} == $b->{'logPos'}) {
        return 0;
    }
    elsif ($a->{'logPos'} > $b->{'logPos'}) {
        return 1;
    }
    return -1;
}



1;
