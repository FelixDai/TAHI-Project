#!/usr/bin/perl 

# use strict;
use V6evalTool;

package IKEapi;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	     IKESetSaProf
	     IKECopySaProf
	     IKESetAutoResponse
	     IKESetResponder
	     IKESetNotify
	     IKEvRecv
	     IKEClearNegotiation
	     IKEStartPh1
	     IKEStartPh2
	     IKEGetSaInfo
	     IKEChgSaInfo
	     IKEInit
	     IKEEnd
	     VCppRegist
	     VCppApply
	     
	     PrintVal
	     PrintItem
	     MsgPrint
	     );

require IKhex;
require IKcntl;
require IKEsco;
require IKEsvc;
require IKErule;

# 
$IKESAEnable;
# 
@IKEUserAutoResponse;
$IKESACompleteResponse;
$IKENotifyResponse;

################################################
# MIP - IKE 
################################################
sub IKESetSaProf {
    my(@saProfile)=@_;
    my($i,$ret);

    # SA
    for($i=0;$i<=$#saProfile;$i++){
	if($ret=IKERegsitSAProf($saProfile[$i])){return $ret;}
    }
    return;
}
sub IKECopySaProf {
    my($said,$ext,$data)=@_;
    my($subsaid,$i,$prof,$newprof,$key,$val,@ids);

    if( !($prof=IKEGetSAProf($said)) ){
	LogPrint('ERR','1','',"IKECopySaProf SAID[$said] is not registed, do not continue.\n");
	return ('SAID invalid');
    }
    if($prof->{'PHASE'} ne 1){
	LogPrint('ERR','1','',"SAID[$said] is not phase1 profile.\n");
	return ('SAID invalid');
    }

    $subsaid=IKEGetSubSAProf($said);

    for $i (0..$#$subsaid){
	$prof=IKEGetSAProf($subsaid->[$i]);
	$newprof={};
	%$newprof=%$prof;
	$newprof->{'ISAKMP_SA_ID'}= $said . $ext;
	$newprof->{'ID'}=$newprof->{'ID'} . $ext;
	if( !IKERegsitSAProf($newprof,'NOCHECK') ){push(@ids,$newprof->{'ID'});}
    }
    $prof=IKEGetSAProf($said);
    $newprof={};
    %$newprof=%$prof;

    IKESALabelToVal(1,$data);
    while(($key,$val)=each(%$data)){
	$newprof->{$key}=$val;
    }
    $newprof->{'ID'}=$said . $ext;
    if(!IKERegsitSAProf($newprof,'NOCHECK')){push(@ids,$newprof->{'ID'});}
    return @ids;
}
# 
sub IKESetAutoResponse {
    my(@autoResponse)=@_;
    my($i,@response);

    # 
    for $i (0..$#autoResponse){
	if(!$autoResponse[$i]->{'Frame'} || !$autoResponse[$i]->{'Action'}){
	    return 'Parameter invalid';
	}
    }
    for $i (0..$#autoResponse){
	# 
	if($autoResponse[$i]->{'Mode'} =~ /callback/i){
	    push(@response,
		 {'Etype' =>['MSGREV'],
		  'Frame' =>$autoResponse[$i]->{'Frame'},
		  'Mode'=>'callback',
		  'Action'=>'IKEMatchFrameUserCB',
		  'Arg'=>$autoResponse[$i]});
	}
	elsif($autoResponse[$i]->{'Mode'} =~ /response/i){
	    $autoResponse[$i]->{'Etype'} = ['MSGREV'];
	    push(@response,$autoResponse[$i]);
	}
	else{
	    return 'Parameter invalid';
	}
    }
    @IKEUserAutoResponse=@response;
    return;
}

# 
sub IKESetResponder {
    my(@respondSpec)=@_;
    my(@said,$i);
    if($#respondSpec eq -1 || !$respondSpec[0]){
	$IKESAEnable='';
    }
    else{
	for $i (0..$#respondSpec){
	    if( !IKEGetSAProf( $respondSpec[$i]->{'SaID'} ) ){
		LogPrint('ERR','2','',"IKESetResponder SAID[%s] is not registed, but continue.\n",$respondSpec[$i]->{'SaID'});
#		return 'SAID invalid';
	    }
	    else{
		push(@said,{'ID'=>$respondSpec[$i]->{'SaID'},'DIR'=>'in'});
	    }
	}
	$IKESAEnable=\@said;
    }
    $IKESACompleteResponse={'Etype' =>['SACOMPLETE'],
			    'Frame' =>'','Cat'=>'','Mode'=>'callback',
			    'Action'=>'IKEMatchForSAComplete','Arg'=>\@respondSpec};
    return '';
}

sub IKESetNotify {
    my(@match)=@_;
    if($#match<0){
	$IKENotifyResponse='';
    }
    else{
	$IKENotifyResponse={'Etype' =>['MSGREV'],
			    'Frame' =>$IKERcvFRAMENAME,'Cat'=>'','Mode'=>'callback',
			    'Action'=>'IKEMatchFrameForNotify','Arg'=>\@match};
    }
}

sub IKEvRecv {
    my($intf,$timeout,$seektime,$count,@frames)=@_;
    my($i,$pkt);
    $pkt=IKEvRecvInter(\@frames,$timeout,$intf);
    return %$pkt;
}
sub IKEClearNegotiation {
    my($said,$stillMode)=@_;
    my($i,@delinst,$inst,$sainfo);
    if($said eq '*'){
	$inst=\@IKScenarioINST;
    }
    else{
	if(!ref($said)){$said=[$said];}
	$inst=IKEFindScenarioInstanceFromSAID($said,"TRUE");
	if($#$inst<0){
	    MsgPrint('WAR',"IKEClearNegotiation invlid said[%s]\n",$said->[0]);
	}
    }
    for $i (0..$#$inst){
	# 
	if($stillMode && $inst->[$i]->{'ST'} =~ 'complete$'){next;}
        # 
        if($inst->[$i]->{'ST'} =~ 'complete$'){
	    IKEInfoExchSend($inst->[$i]->{'ID'},'DL','',$inst->[$i]->{'Link'});
	}
	$sainfo={};
        %$sainfo=IKEGetSaInfo($inst->[$i]);
	if($sainfo->{PHASE}){push(@delinst,$sainfo);}
	IKEDisableScenarioInstance($inst->[$i],'notifyed','User cleaned');
    }
    return @delinst;
}
sub IKEStartPh1 {
    my($said,$intf,$timeout,@userFrame)=@_;

    my($context,$eventDispatch,$pkt,$event);
    if($timeout eq ''){$timeout=$IKEDefTimeout;}
    if($intf eq ''){$intf='Link0';}

    if( !IKEGetSAProf($said) ){
	LogPrint('ERR','1','',"IKEStartPh1 SAID[$said] is not registed, do not continue.\n");
	return ('ikeStatus'=>'StError');
    }

    # 
    if(IKEIs1stPH1Call($said)){
	# 
	#   
	$event = IKCreateEvent('START',{'Scenariokey' => ['phase1','initiator']});
	IKPushEvent($event);
    }

    # 
    $eventDispatch=IKEAddDefaultIKEEventDispatch(\@userFrame);

    # 
    $context={'UserFunc'=>IKEinitPh1,
	      'RequestSaID'=>[{'ID'=>$said,'DIR'=>'out'},@$IKESAEnable],
	      'EventDispatch'=>$eventDispatch,
	      'Interface'=>$intf,'Timeout'=>$timeout};

    # 
    $pkt=IKSequenceCntl($context);
    $pkt->{'SaExpired'}=IKEGetSaExpired();

    return %$pkt;
}

sub IKEStartPh2 {
    my($said,$handle,$intf,$timeout,@userFrame)=@_;

    my($context,$eventDispatch,$pkt,$event,$prof);
    if($timeout eq ''){$timeout=$IKEDefTimeout;}
    if($intf eq ''){$intf='Link0';}

    # 
    IKECheckTimeout();

    if( !($prof=IKEGetSAProf($said)) ){
	LogPrint('ERR','2','',"IKEStartPh2 SAID[$said] is not registed, do not continue.\n");
	return ('ikeStatus'=>'StError','SaExpired'=>IKEGetSaExpired());
    }
    if(!IKFindScenInstFromID($handle)){
	LogPrint('ERR','2','',"IKEStartPh2 handle(Parent-ID[%s],SAID[$said]) invalid\n",
		 $prof->{'ISAKMP_SA_ID'});
	return ('ikeStatus'=>'StError','SaExpired'=>IKEGetSaExpired());
    }
    if($prof->{'ISAKMP_SA_ID'} ne IKFindScenInstFromID($handle)->{'SaID1'}){
	LogPrint('ERR','2','',"IKEStartPh2 Parent-ID[%s] of SAID[$said] not equal PH1 handle[%s]\n",
		 $prof->{'ISAKMP_SA_ID'},IKFindScenInstFromID($handle)->{'SaID1'});
	return ('ikeStatus'=>'StError','SaExpired'=>IKEGetSaExpired());
    }

    # 
    #   
    if(IKEIs1stPH2Call($said)){
	# 
	#   
	#   
	$event = IKCreateEvent('START', {'Scenariokey' => ['phase2','initiator']} );
	IKPushEvent($event);
    }

    # 
    $eventDispatch=IKEAddDefaultIKEEventDispatch(\@userFrame);

    # 
    $context={UserFunc =>IKEinitPh2,
	      'RequestSaID'=>[{'ID'=>$said,'DIR'=>'out'}, @$IKESAEnable],'ParentInst'=>$handle,
              'EventDispatch'=>$eventDispatch,'Interface'=>$intf,'Timeout'=>$timeout};

    # 
    $pkt = IKSequenceCntl($context);
    $pkt->{'SaExpired'}=IKEGetSaExpired();
    
    return %$pkt;
}

sub IKEGetSaInfo {
    my($handle)=@_;
    my($ret,$resrTime1,$resrTime2,$inst);

    # 
    IKECheckTimeout();

    # 
    if(!ref($handle)){
	if(!($inst=IKFindScenInstFromID($handle))){
	    $inst=IKFindDestroyedScenInstFromID($handle);
	}
    }
    else{$inst=$handle;}
    if(!$inst){
	LogPrint('ERR','','',"IKEGetSaInfo instance[$handle] not exist.\n");
	return ;
    }
    # 
    if($inst->{'Phase'} eq 1){
	if($inst->{'ISAKMPStatus'} eq 'INVALID'){$resrTime1=0;}
	else{$resrTime1=$inst->{'ISAKMPStart'}+$inst->{'ISAKMPTimeout'}-time();}
	$ret={'PROFILE_ID'=>$inst->{'SaID1'},'SA_HANDLER'=>$inst->{'ID'},'PHASE'=>$inst->{'Phase'},
	      'LIFETIME'=>$resrTime1,'STATUS'=>$inst->{'ISAKMPStatus'} };
    }

    if($inst->{'Phase'} eq 2){
	if($inst->{'IPSecINStatus'} eq 'INVALID'){$resrTime1=0;}
	else{$resrTime1=$inst->{'IPSecINStart'}+$inst->{'IPSecINTimeout'}-time();}
	if($inst->{'IPSecOUTStatus'} eq 'INVALID'){$resrTime2=0;}
	else{$resrTime2=$inst->{'IPSecOUTStart'}+$inst->{'IPSecOUTTimeout'}-time();}
	$ret={'PROFILE_ID'=>$inst->{'SaID2'},'SA_HANDLER'=>$inst->{'ID'},'PHASE'=>$inst->{'Phase'},
	      'ISAKMP_SA_HANDLER'=>$inst->{'Phase1ID'},
	      'ESP_ALG'=>IKEDoiToLabel($inst->{'IPSecEncAlgo'},$IKEDefaultPH2SA{'ESP_ALG'}->{'VR'}),
	      'ATTR_AUTH'=>IKEDoiToLabel($inst->{'IPSecAuthAlgo'},$IKEDefaultPH2SA{'ATTR_AUTH'}->{'VR'}),
	      'IN_SPI'=>$inst->{'INSPI'},
	      'IN_ENC_KEY'=>$inst->{'IPSecINEncKey'},   'IN_AUTH_KEY'=>$inst->{'IPSecINHashKey'},
	      'IN_LIFETIME' =>$resrTime1,  'IN_STATUS'=>$inst->{'IPSecINStatus'},
	      'OUT_SPI'=>$inst->{'OUTSPI'},
	      'OUT_ENC_KEY'=>$inst->{'IPSecOUTEncKey'}, 'OUT_AUTH_KEY'=>$inst->{'IPSecOUTHashKey'},
	      'OUT_LIFETIME'=>$resrTime2,  'OUT_STATUS'=>$inst->{'IPSecOUTStatus'},};
    }
    return %$ret;
}

# ISAKMP SA
sub IKEChgSaInfo {
    my($handle,%addrtbl)=@_;
    my($key,$val,$inst,$err);

    # 
    IKECheckTimeout();

    if(!ref($handle)){
	$inst=IKFindScenInstFromID($handle);
    }
    else{$inst=$handle;}
    if(!$inst){
	LogPrint('ERR','','',"IKEGetSaInfo instance not exist.\n");
	return 'instance not exist';
    }
    if($inst->{'Phase'} eq 2){
	LogPrint('WAR','','',"IKEGetSaInfo instance is IPSecSA.\n");
	return 'instance not phase1';
    }
    if($inst->{'ST'} ne 'PH1.complete'){
	LogPrint('WAR','','',"IKEGetSaInfo instance state not complete.\n");
	return 'instance state not complete';
    }
    while(($key,$val)=each(%addrtbl)){
	if(ref($key) eq 'HASH'){
	    LogPrint('WAR','','',"IKEGetSaInfo last argument is not assoc list.\n");
	    $err='not assoc list';
	    last;
	}
    }
    if($err){return $err;}
    while(($key,$val)=each(%addrtbl)){
	if($key eq 'TN_ETHER_ADDR') {$inst->{'TnEtherAddr'}=$val;}
	if($key eq 'TN_IP_ADDR')    {$inst->{'TnIPAddr'}=$val;}
	if($key eq 'NUT_ETHER_ADDR'){$inst->{'NutEtherAddr'}=$val;}
	if($key eq 'NUT_IP_ADDR')   {$inst->{'NutIPAddr'}=$val;}
    }
    return;
}
sub IKEInit {
    my($node,$loglevel,$crypymode)=@_;

    # 
    if($crypymode eq 'none'){$IKEEncryptMode=0;}

    # 
    $IKEScenarioModel=$node;

    # 
    IKESetLogLevel($loglevel);

    # 
    IKRegistScenario(\@IKEScenario);

    # 
    HXRegistPktPattern(\@IKEPacketHexMap);
    IKGetFrameTemplateAssocInit();

    # MAC
    IKRegistMacAddr();

    # 
    IKEWritePktDef(' ');

    # 
    IKRegistRuleSet(\@IKECommonRules);

    # 
    StartScenarioTime();

    return '';
}
sub IKEEnd {
    my($nodelete)=@_;
    # Delete 
    if(!$nodelete){ IKESendDLMsgInfoForALL(); }
    # 
    if(IKEIsLogLevel('SEQ')){IKSequenceLog();}
    # 
    if(IKEIsLogLevel('JDG')){
	IKJudgmentLog();
	# 
	SyntaxRuleResultStatistics();
    }
}

################################################
# MIP - IKE 
################################################
# IKE
sub IKEAddDefaultIKEEventDispatch {
    my($userEventDispatch,$args)=@_;
    my($i,@eventDispatch);

    if(!$userEventDispatch){$userEventDispatch=[];}
    elsif(ref($userEventDispatch) eq 'HASH'){$userEventDispatch=[$userEventDispatch];}

    for($i=0;$i<=$#$userEventDispatch;$i++){
	# 
	if(!ref($userEventDispatch->[$i])){
	    $userEventDispatch->[$i]={'Frame'=>$userEventDispatch->[$i],'Mode'=>'return','Etype'=>['MSGREV'],};
	}
	# 
	else{
	    $userEventDispatch->[$i]->{'Etype'} = ['MSGREV'];
	}
    }

    # IKESetNotify
    if($IKENotifyResponse){
	push(@eventDispatch,$IKENotifyResponse);
    }

    # 
    push(@eventDispatch,
	 {'Etype' =>['MSGREV','TIMEOUT','START','END'],
	  'Frame' =>$IKERcvFRAMENAME,'Cat'=>'IKE','Mode'=>'callback',
	  'Action'=>'IKEScenarioMain','Arg'=>$args});

    # IKESetResponder
    if($IKESACompleteResponse){
	push(@eventDispatch,$IKESACompleteResponse);
    }

    # SetAutoResponse
    if(-1<$#IKEUserAutoResponse){
	push(@eventDispatch,@IKEUserAutoResponse);
    }

    # API
    if(-1<$#$userEventDispatch){
	push(@eventDispatch,@$userEventDispatch);
    }

    return \@eventDispatch;

}
# IKEinitPh1
sub IKEIs1stPH1Call {
    my($said)=@_;
    my($key,$i);

    # 
    $key={'Phase'=>1,'SaID1'=>$said };
    for $i (0..$#IKScenarioINST){
	if(IsIncludeAssoc($IKScenarioINST[$i],$key)){
	    if($IKScenarioINST[$i]->{ST} ne 'PH1.complete'){return;}
	}
    }
    return 'T';
}

# IKEinitPh2
sub IKEIs1stPH2Call {
    my($said)=@_;
    my($key,$i);

    # 
    $key={'Phase'=>2,'SaID2'=>$said};
    for $i (0..$#IKScenarioINST){
	if(IsIncludeAssoc($IKScenarioINST[$i],$key)){
	    if($IKScenarioINST[$i]->{ST} ne 'PH2.complete'){return;}
	}
    }
    return 'T';
}
sub IKEvRecvInter {
    my($userFrame,$timeout,$intf)=@_;
    my($context,$eventDispatch,$pkt);
    if($timeout eq ''){$timeout=$IKEDefTimeout;}
    if($intf eq ''){$intf='Link0';}

    # 
    $eventDispatch=IKEAddDefaultIKEEventDispatch($userFrame);

    # 
    $context={'UserFunc'=>'IKEvRecv',
	      'RequestSaID'=>$IKESAEnable,
              'EventDispatch'=>$eventDispatch,
	      'Interface'=>$intf,
	      'Timeout'=>$timeout};

    # 
    $pkt=IKSequenceCntl($context);
    $pkt->{'SaExpired'}=IKEGetSaExpired();
    return $pkt;
}


# SetAutoResponse
sub IKEMatchFrameUserCB {
    my($context)=@_;
    my($autoResponse,$inst,$pkt,$ret,$arg);

    $autoResponse=$context->{'UserArgs'};
    $inst=$context->{'ScenarioInst'};
    $pkt=$context->{'RecvPkt'};
    
    $arg->{'RecvPkt'}=$pkt;
    $arg->{'RecvFrameName'}=$context->{'RecvFrameName'};
    $arg->{'UserArgs'}=$autoResponse->{'Arg'};
    $arg->{'Interface'}=$context->{Interface};
    if( $ret=IKFunctionCall($autoResponse->{'Action'},$arg) ){
	$pkt->{'ikeStatus'}='StCallBack';
	$pkt->{'ikeResult'}=$ret;
	$pkt->{'SaExpired'}=IKEGetSaExpired();
	return $pkt;
    }
    
    return;
}
sub IKEMatchForSAComplete {
    my($context)=@_;
    my($cond,$i,$inst,$pkt,$ret,$arg);
    $cond=$context->{'UserArgs'};
    $pkt=$context->{'RecvPkt'};
    $inst=$context->{'ScenarioInst'};

    if(!$cond->[$i]->{'SaID'} || 
       ($inst->{'ST'} ne 'PH1.complete' && $inst->{'ST'} ne 'PH2.complete')){return;}

    for $i (0..$#$cond){
	if($inst->{'SaID1'} eq $cond->[$i]->{'SaID'} || $inst->{'SaID2'} eq $cond->[$i]->{'SaID'}){
	    $arg={'SaInfo'=>{IKEGetSaInfo($inst->{'ID'})},
		  'UserArgs'=>$cond->[$i]->{'Arg'},'SaExpired'=>IKEGetSaExpired()};
	    if(!$cond->[$i]->{'Action'}){next;}
	    $ret=IKFunctionCall($cond->[$i]->{'Action'},$arg);
	    if($ret){
		$pkt->{'ikeResult'}=$ret;
		$pkt->{'ikeStatus'}='StCallBack';
		return $pkt;
	    }
	}
    }
    return;
}

1
