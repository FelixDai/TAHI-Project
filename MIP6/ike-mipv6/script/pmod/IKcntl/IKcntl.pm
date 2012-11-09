#!/usr/bin/perl 

# use strict;
use V6evalTool;

#============================================
# 
#============================================
eval("use Time::HiRes");
if(!$@){$IK_Support_HiRes='OK';}

# 
%IKScenarioDB;

# 
%IKScenarioINSTID;
@IKScenarioINST;
@IKScenarioINSTDisable;

# 
%IKRuleDB;
%IKStatisticsRule;

# 
@IKLogLevel=('ERR','WAR','INF1','SEQ','JDG');

# 
#@IKDBGLogLevel=('ERR','WAR','INF1','INF2','DBG','DBG2','DBG3','DBG4','DBG5');
#  DBG :General
#  DBG2:Eval & Rule
#  DBG3:Encode & Decode
#  DBG4:Auth
#  DBG5:Parser
#  DBG6:Profile match
#  DBG7:Rule Statistics
#%IKDBGLogLevel=('ERR'=>1,'WAR'=>1,'DBG'=>1);
%IKDBGLogLevel=('ERR'=>1,'WAR'=>1);

@IK_HTMLLog;

# VCPP
$VCCLastStr;
%VCCIDList;

# 
$IKUniqueNumb = 1000;

# 
$IKEDefTimeout = 5;

# 
%IKTimerDB;
$IKTimerUniqueNumb = 1;

# 
@IKMsgCapture;
# 
$IKMsgCaptureLastTime;

# TN.NUT.def MAC
$IKMacAddrInfo;

# 
$IKERcvFRAMENAME='IKE_RECV';

# TAHI
$TAHIPlatformMode;

# 
$IKE_MSG_FILE    = "IKE-message";

#============================================
# 
#============================================
sub IKRegistScenario {
    my($scenarios)=@_;
    my($i);

    if(ref($scenarios) eq 'ARRAY'){
	for($i=0;$i<=$#$scenarios;$i++){
	    if( $scenarios->[$i]->{TY} eq 'scenario' ){
		$IKScenarioDB{$scenarios->[$i]->{NM}} = $scenarios->[$i];
	    }
	}
    }
    if(ref($scenarios) eq 'HASH' && $scenarios->{'TY'} eq 'scenario'){
	$IKScenarioDB{$scenarios->{'NM'}} = $scenarios;
    }
}
sub IKFindScenarioFromKey {
    my($keys)=@_;
    my(@key,$i);
    @key=keys(%IKScenarioDB);
    for $i (0..$#key){
	if( IKIsIncludeMember($keys,$IKScenarioDB{$key[$i]}->{KY}) ){return $key[$i];}
    }
    return '';
}
sub IKCreateScenarioInst {
    my($name)=@_;
    my($inst,$sce);
    if(!($sce=$IKScenarioDB{$name})){
	MsgPrint('ERR',"Not exist scenario[$name]\n");
	return '';
    }
    $inst={'TY'=>'sceinst','SN'=>$name,'ST'=>$sce->{'ST'}->[0]->{'NM'},ID=>IKGetNewNo()};
    return $inst;
}
# 
sub IKIsIncludeMember {
    my($dataA,$dataB)=@_;
    my($i,$key,$val);
    if(ref($dataA) ne ref($dataB)){return '';}
    if(ref($dataA) eq 'ARRAY'){
	for($i=0;$i<=$#$dataA;$i++){
	    if( !grep{$_ eq $$dataA[$i]} @$dataB ){ return '';}
	}
	return 'T';
    }
    if(ref($dataA) eq 'HASH'){
	while(($key,$val)=each(%$dataA)){
	    if($dataB->{$key} ne $val){return '';}
	}
	return 'T';
    }
    return ($dataA eq $dataB);
}

#============================================
# 
#============================================
sub IKAddScenInst {
    my($inst)=@_;
    push(@IKScenarioINST,$inst);
    $IKScenarioINSTID{$inst->{'ID'}}=$inst;
}
sub IKFindScenInst {
    my($key)=@_;
    my($i);
    for $i (0..$#IKScenarioINST){
	if(IsIncludeAssoc($IKScenarioINST[$i],$key)){
	    return $IKScenarioINST[$i];
	}
    }
    return '';
}
sub IKFindScenInstFromID {
    my($key)=@_;
    return $IKScenarioINSTID{$key};
#     my($i);
#     for $i (0..$#IKScenarioINST){
# 	if($IKScenarioINST[$i]->{'ID'} eq $key){
# 	    return $IKScenarioINST[$i];
# 	}
#     }
#     return '';
}
sub IKDestroyedScenInst {
    my($id)=@_;
    my($inst,$i);
    for $i (0..$#IKScenarioINST){
	if($IKScenarioINST[$i]->{'ID'} eq $id){
	    $inst=$IKScenarioINST[$i];
	    push(@IKScenarioINSTDisable,$inst);
	    delete($IKScenarioINSTID{$inst->{ID}});
	    splice(@IKScenarioINST,$i,1);
	    last;
	}
    }
    return $inst;
}
sub IKFindDestroyedScenInstFromID {
    my($key)=@_;
    my($i);
    for $i (0..$#IKScenarioINSTDisable){
	if($IKScenarioINSTDisable[$i]->{'ID'} eq $key){
	    return $IKScenarioINSTDisable[$i];
	}
    }
    return '';
}

#============================================
# 
#============================================
# 
sub IKActionScenatio {
    my($slot,$eventType,$event,$inst,$pktinfo,$context)=@_;
    my($actbl,$stateTbl,$i,$ret,$evalResult,%tmpContext,$tmp);

    # 
    $actbl=$inst->{'SS'};
    if( !$actbl ){
	if( !($actbl=$IKScenarioDB{$inst->{'SN'}}) ){
	    PrintVal($inst);
	    MsgPrint('ERR',"Scenatio Action can't find scenario table(%s)\n",$inst->{'SN'});
	    return "Can't find scenario table";
	}
	$inst->{'SS'}=$actbl;
    }
    $stateTbl=$actbl->{'ST'};

    for $i (0..$#$stateTbl){
	# 
	if($stateTbl->[$i]->{'NM'} eq $inst->{'ST'} && 
	   $stateTbl->[$i]->{'EV'} eq $eventType && $stateTbl->[$i]->{$slot}){

	    # AC
	    if($slot eq 'AC'){
		%tmpContext=%$context;
		# 
		if($stateTbl->[$i]->{'RRf'}){
		    MsgPrint('DBG',"<==%s %s %s::%s current(%s)\n",'Rule',
			     $inst->{'Side'},$actbl->{'NM'},$stateTbl->[$i]->{'NM'});
		    $tmpContext{'EVAL-RESULT'}='SKIP';
		    $tmp=IKEvalExpression($stateTbl->[$i]->{'RRf'},$pktinfo,$inst,\%tmpContext);
		    MsgPrint('DBG',"==>%s %s state(%s), act return(%s)\n",'Rule',
			     $inst->{'Side'},$inst->{'ST'},$tmp );
		}
		# 
		MsgPrint('DBG',"<==%s %s %s::%s current(%s)\n",'Sequence',
			 $inst->{'Side'},$actbl->{'NM'},$stateTbl->[$i]->{'NM'});
		$evalResult=$context->{'EVAL-RESULT'};
		$context->{'EVAL-RESULT'}='SKIP';
		$ret=IKEvalExpression($stateTbl->[$i]->{'AC'},$event,$inst,$context);
		MsgPrint('DBG',"==>%s %s state(%s), act return(%s)\n",'Sequence',
			 $inst->{'Side'},$inst->{'ST'},$ret );
		# 
		if(!$ret && $stateTbl->[$i]->{'RRl'} && $context->{'EVAL-RESULT'} ne 'SKIP'){
		    MsgPrint('DBG',"<==%s %s %s::%s current(%s)\n",'Rule',
			     $inst->{'Side'},$actbl->{'NM'},$stateTbl->[$i]->{'NM'});
		    $tmpContext{'EVAL-RESULT'}='SKIP';
		    $tmp=IKEvalExpression($stateTbl->[$i]->{'RRl'},$pktinfo,$inst,\%tmpContext);
		    MsgPrint('DBG',"==>%s %s state(%s), act return(%s)\n",'Rule',
			     $inst->{'Side'},$inst->{'ST'},$tmp );
		}
		# 
		if($context->{'EVAL-RESULT'} ne 'SKIP'){
		    IKProceedNextState($inst,$ret,$stateTbl->[$i],$event,$context);
		}
		$context->{'EVAL-RESULT'}=$evalResult;
	    }
	    else{
		MsgPrint('DBG',"<==%s %s %s::%s current(%s)\n",'Rule',
			 $inst->{'Side'},$actbl->{'NM'},$stateTbl->[$i]->{'NM'});
		$context->{'EVAL-RESULT'}='SKIP';
		$ret=IKEvalExpression($stateTbl->[$i]->{$slot},$pktinfo,$inst,$context);
		MsgPrint('DBG',"==>%s %s state(%s), act return(%s)\n",'Rule',
			 $inst->{'Side'},$inst->{'ST'},$ret );
	    }
	    return '';
	}
    }
    if($slot eq 'AC'){
	MsgPrint('WAR',"Can't find state-action. Tbl[%s] HandleState[%s] Event[%s]\n",
		 $inst->{'SN'},$inst->{'ST'},$eventType);
    }
    return "Can't find state-action";
}

# 
sub IKProceedNextState {
    my($inst,$next,$stateTbl,$event,$context)=@_;
    if(!$next){
	if($stateTbl->{'NX'}){
	    if(ref($stateTbl->{'NX'}) eq 'HASH'){
		$inst->{'ST'}=$stateTbl->{'NX'}->{'OK'};
	    }
	    elsif(ref($stateTbl->{'NX'})){
		$inst->{'ST'}=IKEvalExpression($stateTbl->{'NX'},$event,$inst,$context);
	    }
	    else{
		$inst->{'ST'}=$stateTbl->{'NX'};
	    }
	}
	else{
	    MspPrint('ERR',"StateTbl can't find Next state[%s]\n",$stateTbl->{'NM'});
	}
    }
    else{
	if(ref($stateTbl->{'NX'}) eq 'HASH'){
	    $inst->{'ST'}=$stateTbl->{'NX'}->{$next};
	}
	else{
	    $inst->{'ST'}=$next;
	}
    }
}

#============================================
# 
#============================================
sub IKCreateEvent {
    my($type,$args)=@_;
    my($event);

    $event->{'TY'}='event';
    $event->{'Etype'}=$type;
    $event->{'Data'}=$args;
    return $event;
}
sub IKPushEvent {
    my($event)=@_;
    MsgPrint('DBG',"Add Event [$event->{Etype}]\n");
    push(@IKEventQueue,$event);
}
sub IKGetEvent {
    return shift(@IKEventQueue);
}

#============================================
# 
#============================================
sub IKSequenceCntl {
    my($context)=@_;
    my($event,$status,$reason,$endtime,$frames,$pkt,$link,$tim,@unexpect);

    # 2006/02/23 support unexpect packet @unexpect
    # t.matsuura

    # 
    $endtime = time()+$context->{Timeout};
    $link=$context->{Interface};

    # 

    while(1){

	# 
	while($event=IKGetEvent()){

	    # 
	    $status=IKEventDispatch($context,$event);
	    # 
	    #   
	    #   
	    #   
	    #   
	    #   

	    # 2006/02/23 support unexpect packet
	    if($status){
		$status->{'SaUnexpect'}= \@unexpect ;
		return $status;
	    }
	}

	# 
	#  2006/02/23 support unexpect packet
	if( $endtime < time() ){
	    return {'status'=>1,'ikeStatus'=>'StTimeOut','SaUnexpect'=>\@unexpect};
	}

	# 
	$frames=IKCollectFrames($context->{EventDispatch});

	# VCPP
	#  IKE
	VCppApply();

	# 
	$pkt = {};
	%$pkt=IKERecv($link,@$frames);
#	%$pkt=vRecv3($link, 1, 0, 1, @$frames);
	MsgPrint('DBG',"vRecv Status[%s] rest time[%s]\n",$pkt->{status},$endtime-time());

	# 
	if($pkt->{status}==0){
	    # 
	    $event=IKCreateEvent('MSGREV',{'Packet'=>$pkt});
	    IKPushEvent($event);
#	    PrintVal($pkt);
	}
	elsif($pkt->{status}==2){
	    if($pkt->{'Frame_Ether.Packet_IPv6'}){
		if($pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_ISAKMP.ISAKMP_Encryption'}){
		    # 
		    if($IKEEncryptPhase1Salvage){
			$pkt->{'status'}=0;
			$pkt->{'recvFrame'}=$IKERcvFRAMENAME;
			$event=IKCreateEvent('MSGREV',{'Packet'=>$pkt});
			IKPushEvent($event);
		    }
		    else{
			MsgPrint('WAR',"ISAKMP Encrypted message received. But can't decryped or uninterested frame.\n");
		    }
		}
		elsif($pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_ISAKMP'}){
		    MsgPrint('WAR',"ISAKMP message received. But uninterested frame, so ignored.\n");
		}
		else{
		    MsgPrint('WAR',"vRecv unknown[%s]\n",$pkt->{'Frame_Ether.Packet_IPv6'});

		    #  2006/02/23 support unexpect packet
		    push( @unexpect, $pkt );
		}
	    }
	}
	elsif($pkt->{status}!=1){
	    MsgPrint('WAR',"vRecv Error[%s]\n",$pkt->{status});
	    $pkt->{ikeStatus}='StError';

	    #  2006/02/23 support unexpect packet
	    $pkt->{'SaUnexpect'}=\@unexpect;
	    return $pkt;
	}

	# 
#	IKCheckTimeout();  # 
	IKECheckTimeout();
    }
}

# 
#   
#         
sub IKEventDispatch {
    my($context,$event)=@_;
    my($eventDispatch,$pkt,$i,$frame,$ret,$matched);

    # 
    $eventDispatch=$context->{'EventDispatch'};

    # 
    if($event->{'Etype'} eq 'MSGREV'){
	if(!($pkt=$event->{Data}->{'Packet'})){
	    MsgPrint('WAR',"Event is MSG, but not exist packet\n");
	    return;
	}
    }

    # 
    for($i=0;$i<=$#$eventDispatch;$i++){
	#   
	if((grep{$_ eq $event->{'Etype'}} @{$$eventDispatch[$i]->{'Etype'}}) || $$eventDispatch[$i]->{'Etype'} eq '*'){
	    $matched='TRUE';
	    # IKE
	    if($event->{'Etype'} eq 'MSGREV'){
		# 
		if($$eventDispatch[$i]->{Frame} ne $pkt->{'recvFrame'} ){
		    MsgPrint('DBG',"EventDispatch Skip RecvFrame[%s] != MatchFrame[%s]\n",
			     $$eventDispatch[$i]->{Frame},$pkt->{'recvFrame'});
		    next;
		}
		MsgPrint('DBG',"EventDispatch Frame[%s] mode[%s]\n",$pkt->{'recvFrame'},$$eventDispatch[$i]->{'Mode'});
		# 
		if($$eventDispatch[$i]->{'Mode'} eq 'return'){
		    $pkt->{'ikeStatus'}='StUserFrame';
		    return $pkt;
		}
		# 
		if($$eventDispatch[$i]->{'Mode'} eq 'response'){
		    if(ref($$eventDispatch[$i]->{'Action'})){
			$frame=IKEvalExpression($$eventDispatch[$i]->{Action},$pkt,$context->{'ScenarioInst'},$context);
		    }
		    else{
			$frame=$$eventDispatch[$i]->{'Action'};
		    }
		    VCppApply();
		    vSend($context->{'Interface'},$frame);
		    return ;
		}
		# 
		if($$eventDispatch[$i]->{'Mode'} eq 'callback'){
		    $context->{RecvPkt}=$event->{'Data'}->{'Packet'};
		    $context->{RecvFrameName}=$event->{'Data'}->{'Packet'}->{'recvFrame'};
		    $context->{UserArgs}=$$eventDispatch[$i]->{'Arg'};
		    $context->{Event}=$event;
		    if( $ret=IKFunctionCall($$eventDispatch[$i]->{'Action'},$context) ){
			return $ret;
		    }
		}
	    }
	    # 
	    else{
		$context->{RecvPkt}=$event->{'Data'}->{'Packet'};
		$context->{RecvFrameName}=$event->{'Data'}->{'Packet'}->{'recvFrame'};
		$context->{UserArgs}=$$eventDispatch[$i]->{'Arg'};
		$context->{Event}=$event;
		if( $ret=IKFunctionCall($$eventDispatch[$i]->{'Action'},$context) ){
		    return $ret;
		}
	    }
	}
    }
    if(!$matched){
	MsgPrint('WAR',"EventDispatch event destroy Etype[%s]\n",$event->{'Etype'});
    }
    return '';
}
# 
sub IKCollectFrames {
    my($eventDispatch)=@_;
    my(@frames,$i,$encFrame);
    for $i (0..$#$eventDispatch){
	if($eventDispatch->[$i]->{'Cat'} eq 'IKE'){next;}
	if($eventDispatch->[$i]->{Frame}){push(@frames,$eventDispatch->[$i]->{Frame});}
    }
    for $i (0..$#$eventDispatch){
	if($eventDispatch->[$i]->{'Cat'} ne 'IKE'){next;}
	if($eventDispatch->[$i]->{Frame}){push(@frames,$eventDispatch->[$i]->{Frame});}
    }
    if( $encFrame=IKEEncryptRecvFrames() ){
	push(@frames,@$encFrame);
    }
    return \@frames;
}

#============================================
# 
#============================================

# 
sub IKRegistRuleSet {
    my($rules)=@_;
    my($i);

#    MsgPrint('DBG', "RegistRuleSet type:[%s]\n",ref($rules));
    if(ref($rules) eq 'ARRAY'){
	for($i=0;$i<=$#$rules;$i++){
	    if( ref($$rules[$i]) eq 'HASH' ){
		MsgPrint('DBG',"Regist RuleSet TY:[%s] ID:[%s]\n",$$rules[$i]{'TY'},$$rules[$i]{'ID'});
		if($IKRuleDB{$$rules[$i]{'ID'}}){
		    MsgPrint('WAR',"Regist RuleSet TY:[%s] ID:[%s] SP:[%s] is overrided\n",
			     $$rules[$i]{'TY'},$$rules[$i]{'ID'},$$rules[$i]{'SP'});
		}
		$IKRuleDB{$$rules[$i]{'ID'}}=$$rules[$i];
	    }
	}
    }
    elsif(ref($rules) eq 'HASH' && $$rules{'TY'}){
#	MsgPrint('DBG2',"Regist RuleSet TY:[%s] ID:[%s]\n",$$rules{'TY'},$$rules{'ID'});
	$IKRuleDB{$$rules{'ID'}}=$rules;
    }
    else{
	MsgPrint('ERR',"Regist RuleSet invalid parameter\n");
    }
}

# 
sub IKRuleStatistics {
    # 
    # 
    # 
}
# 
sub IKRuleTreeDisp {
    my($ruleName,$indent)=@_;
    my($rule,$i,$relues,$sp);
    if(!ref($ruleName)){$rule=IKFindRuleFromID($ruleName);}
    if(!ref($rule)){return;}
    $sp=sprintf( sprintf("%%%ds",$indent), " " );
    printf("%s%s:%s\n",$sp,ref($rule->{'EX'}) eq 'ARRAY'?'RS':'RR',$rule->{'ID'});
    if(ref($rule->{'EX'}) eq 'ARRAY'){
	$indent+=2;
	$relues=$rule->{'EX'};
	for $i (0..$#$relues){
	    IKRuleTreeDisp($relues->[$i],$indent);
	}
    }
}

# 
sub IKFindRuleFromID ($){
    my $ruleid=shift;
    if(ref($ruleid) eq 'HASH'){
	return $ruleid->{'ID'},$ruleid;
    }
    else{
	return $ruleid,$IKRuleDB{$ruleid};
    }
}

# 
sub IKRuleModify {
    my($rule,$addrule,$delrule)=@_;
    my(%newrule,$tmp);

    if(!$addrule && !$delrule){return $rule;}

    # 
    ($rule,$tmp) = IKFindRuleFromID($rule);
    if(!$rule || $rule->{'TY'} ne 'RULESET'){
	MsgPrint('ERR',"Modify Rule invalid base ruleset\n");
	return $rule;
    }

    # 
    %newrule=(%$rule,'AD'=>$addrule,'DL'=>$delrule);
    return \%newrule;
}

#============================================
# 
#============================================

# 
sub IKEvalRule {
    my($ruleID,$pktinfo,$inst,$context)=@_;
    my($ruleObj,$val,@stack,%tmpContext);

#    MsgPrint('DBG2',"<==IKEvalRule EVALResult[$context->{'EVAL-RESULT'}] ORDER[$context->{'ORDER'}]\n");
    # 
    if($context eq ''){$context=\%tmpContext;$context->{'RULE-RESULT'}=[];}

    # 
    if(!ref($ruleID)){
	# 
	($ruleID,$ruleObj)=IKFindRuleFromID($ruleID);
	if(!$ruleObj){
	    @stack=caller(1);
	    MsgPrint('ERR',"Rule ID:[%s] done not exist in Rule DB called[%s]\n",$ruleID,$stack[3]);
	    return 'Illegal rule';
	}
    }
    # 
    elsif( (ref($ruleID) eq 'HASH') && $ruleID->{'TY'} && $ruleID->{'ID'} ){
	$ruleObj = $ruleID;
	$ruleID = $ruleObj->{'ID'};
    }
    else{
	MsgPrint('ERR',"Rule illegal data type[%s] called[%s]\n",$ruleID,$stack[3]);
	PrintVal($ruleID);
	return 'Illegal rule';
    }

    # 
    if(($context->{'ORDER'} && $ruleObj->{'OD'} && $context->{'ORDER'} ne $ruleObj->{'OD'}) ||
       ($context->{'DEL-RULE'} && grep{$_ eq $ruleID} @$context->{'DEL-RULE'})){
#	MsgPrint('DBG2',"==>IKEvalRule rule(order:$ruleObj->{'OD'}) skiped\n");
	return '';
    }

    # 
    if($ruleObj->{'TY'} eq 'PROGN'){
	$val=IKEvalRuleProgn($ruleObj,$pktinfo,$inst,$context);
    }
    else{
	@stack=caller(1);
	MsgPrint('ERR', "Can't eval[%s], unknown rule type called[%s]\n",$ruleID,$stack[3]);
    }
#     if(IsLogLevel('DBG')){
# 	DumpRuleResult($context->{'RULE-RESULT'});
#     }
    return $val;
}

# PROGN
sub IKEvalRuleProgn {
    my($rule,$pktinfo,$inst,$context)=@_;
    my($result,@delrules,@rules,$expr,$od,$msg,$color,$startTime,$diff,$bool,$msg,$msgType,
       @order,$order,$ruleorder,$lastResult,$lastEval,%cntx,$evaled,$level,$type,$ruleObj,$tmp);

    # 
    if($IK_Support_HiRes){$startTime=[Time::HiRes::gettimeofday()];}
    $bool=$rule->{'MD'};
    $ruleorder=$rule->{'OD'}?$rule->{'OD'}:'MAIN';
    $level=$context->{'NEST-LEVEL'};

    # 
    @delrules=@{$context->{'DEL-RULE'}};

    # 
    if($rule->{'DL'}){
	push(@delrules,@{$rule->{'DL'}});
    }

    # 
    if(IsLogLevel('DBG')){
	$color='FF8C00';
	$msg=sprintf("<B><font color=\"#%s\"> %${level}.${level}s-- %s %${level}.${level}s-- </font></B><br>",
		     $color,'<<<<<<<<<<<<<<<<<<<<',$rule->{'ID'},'<<<<<<<<<<<<<<<<<<<<');
	vLogHTML($msg);
    }

    # 
    %cntx=%$context;
    $order=$context->{'ORDER'};
#    MsgPrint('DBG2',"<==Rule($rule->{'ID'}) order[$order] EVALResult[$context->{'EVAL-RESULT'}]\n");

    # 
    $cntx{'RULEID'}=$rule->{'ID'};
    $cntx{'DEL-RULE'}=(-1<$#delrules)?\@delrules:'';
    $cntx{'NEST-LEVEL'}=$level+1;
    if($inst){$cntx{'ScenarioInst'}=$inst;}

    # 
    if($rule->{'PR'} && ref($rule->{'PR'})){
#	MsgPrint('DBG2',"Pre condition\n");
	$cntx{'ORDER'}='';
	$cntx{'RULE-BOOL'}='';
	$result = IKEvalExpression($rule->{'PR'},$pktinfo,$cntx{'ScenarioInst'},\%cntx);
	if($result){
#	    MsgPrint('DBG2', "Eval SyntaxRule(%s) skiped for Precondition is FALSE\n",$rule->{'ID'});
	    $result='Precondition false';
	    goto EXIT;
	}
    }

    # 
    $cntx{'RULE-BOOL'}=$bool;

    # 
    if($rule->{'EX'}){
	push(@rules,ref($rule->{'EX'}) eq 'ARRAY'?@{$rule->{'EX'}}:$rule->{'EX'});
    }
    if($rule->{'AD'}){
	push(@rules,ref($rule->{'AD'}) eq 'ARRAY'?@{$rule->{'AD'}}:$rule->{'AD'});
    }
    if($#rules eq -1){goto EXIT;}
    elsif($#rules eq 0){$expr=$rules[0];}
    else{$expr=\@rules;}
    $type=ref($expr);

    # 
    if(!$order){
	#   
	#     
	#     
	if($rule->{'OD'}){
	    push(@order,$ruleorder);
	}
	else{
	    @order=('FIRST','MAIN','LAST');
	}
    }
    elsif($rule->{'OD'}){
	if($ruleorder eq $order){push(@order,$ruleorder);}
    }
    else{
	push(@order,$order);
    }
    # 
    foreach $od (@order) {

	# 
	if(!$type){
	    # 
	    ($tmp,$ruleObj)=IKFindRuleFromID($expr);
	    if($ruleObj){$expr=$ruleObj;$type='HASH';}
	}
	if($type ne 'ARRAY' && $type ne 'HASH' && $od ne $ruleorder){
	    next;
	}

#	MsgPrint('DBG2'," order:($od) condition\n");
	$cntx{'ORDER'}=$od;
	$cntx{'EVAL-RESULT'}='SKIP';
	$result = IKEvalExpression($expr,$pktinfo,$cntx{'ScenarioInst'},\%cntx);
	if($cntx{'EVAL-RESULT'} ne 'SKIP'){
	    $evaled='T';
	    $lastResult=$result;
	    $lastEval=$cntx{'EVAL-RESULT'};
	    if($result && $bool eq 'AND'){goto DONE;}
	}
    }
    
  DONE:
    # 
    if($evaled){
	$cntx{'EVAL-RESULT'}=$lastEval;
	# 
	($msg,$msgType)=IKMkResultMessage($lastResult,$rule,$pktinfo,\%cntx);

	# 
	if($IK_Support_HiRes){$diff=Time::HiRes::tv_interval($startTime, [Time::HiRes::gettimeofday()])}

	# 
	IKAccountSyntaxRuleResult($rule,$lastResult,$diff);

	# 
	$context->{'EVAL-RESULT'}=$cntx{'EVAL-RESULT'};
	push(@{$cntx{'RULE-RESULT'}},{'ID'=>$rule->{'ID'},'MSG'=>$msg,'MSG-TYPE'=>$msgType,'RE'=>$cntx{'EVAL-RESULT'}});
	$context->{'RULE-RESULT'}=$cntx{'RULE-RESULT'};

	# HTML
	if($msg){LogHTML($msg,$rule->{'CA'},$cntx{'Event'}->{'Data'}->{'Packet'} || $cntx{'RecvPkt'});}
    }

EXIT:
    if(IsLogLevel('DBG')){
	$msg=sprintf("<B><font color=\"#%s\"> --%${level}.${level}s %s --%${level}.${level}s </font></B><br>",
		     $color,'>>>>>>>>>>>>>>>>>>>>',$rule->{'ID'},'>>>>>>>>>>>>>>>>>>>>');
	vLogHTML($msg);
    }
#    MsgPrint('DBG2',"==>Rule($rule->{'ID'})  Status[$lastResult] EVALResult[%s] ret[$lastResult]\n",$context->{'EVAL-RESULT'});
    return $lastResult;
}

# 
#   
#   
#      
#   
#      
#        
#      
#      
sub IKEvalExpression {
    my($expr,$pktinfo,$inst,$context)=@_;
    my($rule,$val,$ruleObj,@args,$expr2);
    shift @_;

#    MsgPrint('DBG2',"<==EvalExpression EVALResult[$context->{'EVAL-RESULT'}]\n");
    if(ref($expr) eq 'ARRAY'){
#	MsgPrint('DBG2'," EvalExpr ARRAY\n");
	$val=IKEvalRuleArray($expr,@_);
    }
    elsif(ref($expr) eq 'SCALAR'){
	# perl 5.8
#	@args=@_; $expr2=$$expr; $expr2 =~ s/\@_/\@args/; $val=eval $expr2;
	# perl 5.0
	$val=eval $$expr;
	if($@){
	    MsgPrint('ERR'," Eval exp[%s] failed[%s]\n",$$expr,$@);
	    $val='Eval Error';
	}
	else{
#	    MsgPrint('DBG2'," Eval exp[%s]=>[%s]\n",$$expr,$val);
	    if($context->{'EVAL-RESULT'} eq 'SKIP'){$context->{'EVAL-RESULT'}=$val};
	    $val=!$val;
	}
    }
    elsif(ref($expr) eq 'CODE'){
#	MsgPrint('DBG2'," EvalExpr CODE\n");
	$val=$expr->(@_);
	if($context->{'EVAL-RESULT'} eq 'SKIP'){$context->{'EVAL-RESULT'}=$val};
    }
    elsif(ref($expr) eq 'HASH'){
#	MsgPrint('DBG2'," EvalExpr HASH\n");
	$val=IKEvalRule($expr,@_);
    }
    elsif(!ref($expr)){
#	MsgPrint('DBG2'," EvalExpr STR($expr)\n");
	# 
	($rule,$ruleObj)=IKFindRuleFromID($expr);
	# 
	if($ruleObj){
	    $val = IKEvalRule($rule,@_);
	}
	# 
	else{
	    MsgPrint("DBG"," funcall $rule(\@_)\n");
	    $val = eval '&$rule';  # perl 5.0
#	    $val = $rule->(@_);    # perl 5.8
	    if($@){
		MsgPrint("WAR","Function($rule) is internal error\n");
		MsgPrint("ERR","$@");
		$val='Funcall Error';
	    }
	    else{
		if($context->{'EVAL-RESULT'} eq 'SKIP'){$context->{'EVAL-RESULT'}=$val};
	    }
	}
    }
    elsif(ref($expr) eq 'REF'){
	MsgPrint('WAR',"EvalExpr REF\n");
	$val='';
    }
    else{
	MsgPrint('ERR',"Eval exp[%s] illeagl type[%s]\n",$expr,ref($expr));
	$val='illegal type';
    }
#    MsgPrint('DBG2',"==>EvalExpression EVALResult[$context->{'EVAL-RESULT'}]\n");
    return $val;
}

# 
#   
sub IKFunctionCall {
    my($func,$context)=@_;
    my($result);
    shift @_;

    if(ref($func) eq 'CODE'){
	$result=$func->(@_);
    }
    if(ref($func) eq ''){
	$result=$func->(@_);
    }
    return $result;
}

# IKEvalExpression
sub IKSetEvalResult {
    my($context,$optype,$op,$output,$arg1,$arg2,$arg3)=@_;
    $context->{'EVAL-RESULT'}={'OP-TYPR'=>$optype,'OP'=>$op,'OUTPUT'=>$output,'ARG1'=>$arg1,'ARG2'=>$arg2,'ARG3'=>$arg3,};
}

# 
#   
#   
#      
#      RULE-BOOL'
#   
sub IKEvalRuleArray {
    my($expr,$pktinfo,$inst,$context)=@_;
    my($i,$status,$ok,$bool,$lastResult,$evaled,$allng);
    shift @_;

    # 
    $lastResult=$context->{'EVAL-RESULT'};
    $bool=$context->{'RULE-BOOL'};

    for($i=0;$i<=$#$expr;$i++){
	$context->{'EVAL-RESULT'}='SKIP';
	# 
	$status=IKEvalExpression($expr->[$i],@_);
	# 
	if($context->{'EVAL-RESULT'} eq 'SKIP'){next;}
	$evaled='T';
	# AND
	if($bool eq 'AND'){
	    if($status){$ok=$status;last;}
	}
	# OR
	else{
	    if(!$allng && $status){$ok=$status;}
	    else{$allng='No';$ok='';}
	}
    }

    if(!$evaled){$context->{'EVAL-RESULT'}=$lastResult;}
    return $ok;
}

# TAHI 
sub IKMkResultMessage {
    my ($result,$rule,$pktinfo,$context)=@_;
    my($msg,$fmt,$msgType,$ruleID,$detail,$v1,$v2,$v3);
    shift @_;
    shift @_;

    # 
    if(!$result && $rule->{'OK'}){
	$msg=$rule->{'OK'};
	$msgType='OK';
    }
    # 
    if($result && $rule->{'NG'}){
	$msg=$rule->{'NG'};
	$msgType=($rule->{'ET'} eq 'error')?'ERR':'WAR';
    }
    if(!$msg){
	if(!$msgType){$msgType=$result?'ERR':'OK';}
	return $msg,$msgType;
    }

    # 
    if($context->{'EVAL-RESULT'}){
	$v1=ConvertHTMLMessage($context->{'EVAL-RESULT'}->{'ARG1'});
	$v2=ConvertHTMLMessage($context->{'EVAL-RESULT'}->{'ARG2'});
	$v3=ConvertHTMLMessage($context->{'EVAL-RESULT'}->{'ARG3'});
    }
    if(ref($msg) eq 'SCALAR'){
	$msg=eval $$msg;
    }
    elsif(ref($msg) eq 'REF'){
	$fmt = sprintf("sprintf(\"$$$msg\")",
		       ref($v1)?'<font color=\"mediumpurple\">@$v1</font>':'<font color=\"mediumpurple\">$v1</font>',
		       ref($v2)?'<font color=\"mediumpurple\">@$v2</font>':'<font color=\"mediumpurple\">$v2</font>',
		       ref($v3)?'<font color=\"mediumpurple\">@$v3</font>':'<font color=\"mediumpurple\">$v3</font>');
#	PrintItem($fmt);
	$msg = eval $fmt;
#	MsgPrint('DBG2',$msg . "\n");
#	$msg=eval "sprintf(\"$$$msg\",\"$v1\")";
    }

    # 
    if(IsLogLevel('DBG') && $context->{'EVAL-RESULT'}){
	if($context->{'EVAL-RESULT'}->{'OP-TYPE'} eq '2op'){
	    $detail=sprintf('<font color="%s"> (%s [%s] [%s])</font>', 'gray',$context->{'EVAL-RESULT'}->{'OP'},$v1,$v2);
	}
	else{
	    $detail=sprintf('<font color="%s"> (%s %s [%s])</font>','gray',
			    $context->{'EVAL-DETAIL'}->{'OP-TYPE'},$context->{'EVAL-RESULT'}->{'OP'},$v1);
	}
    }

    # 
#    $ruleID=IsLogLevel('INF')?$rule->{'ID:'}:sprintf("<A HREF=\"#PKT%s:%s\">%s</A>",$rule->{'CA:'},$#SIPPktInfo,$rule->{'CA:'});
    $ruleID=IsLogLevel('DBG')?$rule->{'ID'}:$rule->{'CA'};

    # Judgment
    $msg = sprintf('<B><font color="%s">%s: </font></B><B><font color="%s">%s</font></B>%s<BR>',
		   ($rule->{'SP'} eq 'IG')?'#9933C':'#00CCFF',$ruleID,
		   $msgType eq 'OK'?'black':($msgType eq 'WAR'?'green':'red'),$msg,$detail);
    
    return $msg,$msgType;
}



# 
sub IKE_Judgment {
    my($rule,$mode,$pktinfo,$addrule,$delrule)=@_;
    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }

    my($result,$ret,$item,$OK);

    if(IsLogLevel('DBG')){vLogHTML("</TD></TR><TR><TD>Judgment</TD><TD>");}

    # 
    $rule = IKRuleModify($rule,$addrule,$delrule);

    # 
    $result=IKEvalRule($rule,$pktinfo);

    # 
    OutputTAHIResultMessage($pktinfo);

    # 
    foreach $item (@$result){
	if($item->{'RE'} eq ''){
	    if($mode eq 'STOP'){
		MsgPrint('WAR',"Rule Judgment is NG, scenario stop.\n");
		LOG_Warn("Rule Judgment is NG, scenario stop.\n");
		ExitScenario('Fail');
	    }
	    else{
		MsgPrint('WAR',"Rule Judgment is NG, but continue...\n");
	    }
	}
    }
    return $result;
}

#============================================
# 
#============================================
sub IKAccountSyntaxRuleResult {
    my($rule,$result,$time)=@_;
    my($ruleID);
    $ruleID=$rule->{ID};
    $IKStatisticsRule{total}++;
    $IKStatisticsRule{$ruleID}{total}++;
    $IKStatisticsRule{$ruleID}{time} += $time;
    if($result){
	if($ruleID->{'ET'} eq 'warning'){
	    $IKStatisticsRule{warning}++;
	    $IKStatisticsRule{$ruleID}{warning}++;
	}
	else{
	    $IKStatisticsRule{error}++;
	    $IKStatisticsRule{$ruleID}{error}++;
	}
    }
    else{
	$IKStatisticsRule{$ruleID}{ok}++;
    }
}
# 
sub StartScenarioTime {
    if($IK_Support_HiRes){$IKScenarioStartTime=[Time::HiRes::gettimeofday()];}
}
# 
sub SyntaxRuleResultStatistics {
    my($msg,$key,$val,$spec,$fileName,$totalRuleTime,$diff,$sec,$min,$hour,$mday,$mon,$year,$wday);

    if($IK_Support_HiRes){
	$diff=Time::HiRes::tv_interval($IKScenarioStartTime, [Time::HiRes::gettimeofday()]);
    }

    if(IsLogLevel('DBG7')){
	vLogHTML('</TD></TR><TR><TD>Result Statistics</TD><TD>');
	$msg = sprintf("Check Total Count[%d] Error[%d] Warning[%d]",
		       $IKStatisticsRule{total},$IKStatisticsRule{error},$IKStatisticsRule{warning});
	vLogHTML('<font color="blue">' . $msg . '</font><BR>');
	
	if($IK_Support_HiRes){
	    vLogHTML("<pre>    err/war/total    ave   ID\n");
	    foreach $key (sort {$IKStatisticsRule{$b}{total} <=> $IKStatisticsRule{$a}{total}} keys(%IKStatisticsRule)){
		if($key ne 'total' && $key ne 'error' && $key ne 'warning'){
		    if( !($spec=$DefRuleSetDB{$key}->{'SP:'}) ){$spec='RFC';}
		    $msg = sprintf("    %03d/%03d/%03d : %6.1f : [%3.3s]%s\n",
				   $IKStatisticsRule{$key}{error},$IKStatisticsRule{$key}{warning},$IKStatisticsRule{$key}{total},
				   $IKStatisticsRule{$key}{time}*1000/$IKStatisticsRule{$key}{total},$spec,$key);
		    $totalRuleTime += $IKStatisticsRule{$key}{time};
		    vLogHTML($msg);
		}
	    }
	}
	else{
	    vLogHTML("<pre>    err/war/total     ID\n");
	    foreach $key (sort {$IKStatisticsRule{$b}{total} <=> $IKStatisticsRule{$a}{total}} keys(%IKStatisticsRule)){
		if($key ne 'total' && $key ne 'error' && $key ne 'warning'){
		    if( !($spec=$DefRuleSetDB{$key}->{'SP:'}) ){$spec='RFC';}
		    $msg = sprintf("    %03d/%03d/%03d : [%3.3s]%s\n",
				   $IKStatisticsRule{$key}{error},$IKStatisticsRule{$key}{warning},$IKStatisticsRule{$key}{total},
				   $spec,$key);
		    vLogHTML($msg);
		}
	    }
	}
	# 
	if($IK_Support_HiRes){
	    $msg = sprintf("\n    Scenario Run Time [%.2f]sec   Rules Execute Time [%.2f]sec",$diff,$totalRuleTime);
	    vLogHTML($msg);
	}

	vLogHTML('</pre>');
    }
    else{
	vLogHTML(sprintf("</TD></TR><TR><TD>Total</TD><TD><font color=\"#FF6699\">Judgements[%d]  Errors[%d]  Warnings[%d]</font>",
			 $IKStatisticsRule{total},$IKStatisticsRule{error},$IKStatisticsRule{warning}));
    }

    # 
    return ($IKStatisticsRule{total},$IKStatisticsRule{error},$IKStatisticsRule{warning});
}
sub DumpRuleResult {
    my($result)=@_;
    my($i);
    for $i (0..$#$result){
#	MsgPrint('DBG',"Rule[%s] (%s)%s  [%s]\n",
#		 $result->[$i]->{'ID'},$result->[$i]->{'MSG-TYPE'},$result->[$i]->{'MSG'},$result->[$i]->{'RE'});
	MsgPrint('DBG2',"Rule[%s] result<%s> arg1[%s] arg2[%s] arg3[%s]\n",
		 $result->[$i]->{'ID'},$result->[$i]->{'MSG-TYPE'},
		 $result->[$i]->{'RE'}->{'ARG1'} eq ''?'Nil':$result->[$i]->{'RE'}->{'ARG1'} ,
		 $result->[$i]->{'RE'}->{'ARG2'} eq ''?'Nil':$result->[$i]->{'RE'}->{'ARG2'} ,
		 $result->[$i]->{'RE'}->{'ARG3'} eq ''?'Nil':$result->[$i]->{'RE'}->{'ARG3'} );
	if($result->[$i]->{'MSG'}){printf("##HTML##  %s\n",$result->[$i]->{'MSG'});}
    }
}

#============================================
# 
#============================================
$IKETahiINDEX='^(.+?)([0-9]*)$';
# Tahi
sub IKTahiIndexTag ($$){
    my($tagName,$orderName)=@_;
    my($i);
    if($orderName){
	for $i (0..$#$orderName){
	    if($orderName->[$i] eq $tagName){
		$tagName =~ /^(.+?)([0-9]*)$/o;
		return $1,$i;
	    }
	}
    }
    $tagName =~ /^(.+?)([0-9]*)$/o;
#    printf("[$1][$2]\n");
    return $1,$2?$2-1:'0';
}
sub IKPKTIndexTag {
    my($tagName)=@_;
    $tagName =~ /^(.+?)#([0-9]*)$/;
#    printf("[$1][$2]\n");
    return $1,$2?$2:'0';
}

# TAHI
sub IKGetFrameTemplateAssocInit {
    my($tag)=@_;
    my($i);
    for($i=0;$i<=$#IKEFrameFieldMap;$i++){
	$IKEFrameFieldMapAssoc{$IKEFrameFieldMap[$i]->{'##'}}=$IKEFrameFieldMap[$i];
    }
}

# TAHI
sub IKGetFrameTemplate {
    my($tag)=@_;
    my($i);
    for($i=0;$i<=$#IKEFrameFieldMap;$i++){
	if($IKEFrameFieldMap[$i]->{'##'} eq $tag){
	    return $IKEFrameFieldMap[$i];
	}
    }
}

# Tahi
#   ##
sub IKDecodeFieldTree ($$$$) {
    my($field,$val,$tempName,$struct)=@_;
    my($temp,$subtemp,$tag,$tagn,$index,$vals,$subStruct,$subName,$ord,$ordName,$fieldName,$skip,$i,$tmp,$startpos,$endpos);

    $endpos=$#$field;
    # 
    if(!($temp=$IKEFrameFieldMapAssoc{$tempName}) ){
	return $struct;
    }

    # 
    $tag=$field->[0];
    $startpos=1;

    # 
    if( $temp->{$tag} eq '---' ){
	$skip=$IKEFrameFieldMapAssoc{$tag};
	# 
	if($skip=$skip->{'#Skip#'}){
	    # 
	    $tag=$field->[$startpos+1];
	    $startpos+=2;
	}
	$tag=$field->[$startpos];
	$startpos++;
    }
NOTFIND:
    # 
    if( !($startpos > $endpos && $temp->{$tag}) ){
	($tag,$index)=IKTahiIndexTag($tag,$struct?$struct->{'+++'}:'');
    }
    
    # 
    if(!$temp->{$tag}){
	return $struct;
    }

    # 
    if( $temp->{$tag} ne '@@@' ){
	# TAHI
	if($startpos > $endpos){
	    # 
	    if(ref($temp->{$tag})){
		$fieldName=$temp->{$tag}->{'#Name#'};
		if($temp->{$tag}->{'TY'}){$val=IKEConvVal($temp->{$tag}->{'TY'},$val);}
	    }
	    else{
		$fieldName=$temp->{$tag};
	    }
	    # 
	    if($struct && $struct->{'##'}){
		$struct->{$fieldName}=$val;
	    }
	    else{
		$struct={'##'=>$tempName,'###'=>$temp->{'#Name#'},$fieldName=>$val};
	    }
	}
	return $struct;
    }
    
    # 
    if(!($subtemp=$IKEFrameFieldMapAssoc{$tag}) ){
	return $struct;
    }
    $subName=$subtemp->{'#Name#'};
    
    # 
    if( $struct && $struct->{$subName} ){
	$vals=$struct->{$subName};
	if(0<$index || !$vals->[$index] || $vals->[$index]->{'##'} eq $tag){
	    $subStruct=$vals->[$index];
	}
	else{
## 
	    for($i=0;$i<=$#$vals;$i++){
		if($vals->[$i]->{'##'} eq $tag){
		    $subStruct=$vals->[$i];
		    last;
		}
	    }
	    $index=$i;
	    if(!$subStruct){$vals='';}
	}
    }
    # 
    if($startpos > $endpos){
 	($ord,$ordName)=IKFieldOrder($subtemp,$val);
 	if( $ord ){
	    if($subStruct){$subStruct->{'++'}=$ord;$subStruct->{'+++'}=$ordName;}
	    else{$subStruct={'##'=>$tag,'###'=>$subName,'++'=>$ord,'+++'=>$ordName};}
	}
    }
    # 
    else{
	$subStruct=IKDecodeFieldTree([splice(@$field,$startpos,$endpos)],$val,$tag,$subStruct);
    }
    if($subStruct){
	if($vals){
	    $vals->[$index]=$subStruct;
	}
	elsif($struct){
	    $struct->{$subName}->[$index]=$subStruct;
	}
	else{
	    $vals->[$index]=$subStruct;
	    $struct={'##'=>$tempName,'###'=>$temp->{'#Name#'},$subName=>$vals};
	}
    }
    return $struct;
}
# 
sub IKEConvVal {
    my($convType,$val)=@_;
    if($convType eq 'hex'){return hex($val);}
    return $val;
}
# TAHI
sub IKFieldOrder {
    my($temp,$tags)=@_;
    my(@order,@orderName,$i,$j,$tag,$name,$subtemp,$index,@tmp,$no);
    if(!ref($temp)){$temp=$IKEFrameFieldMapAssoc{$temp};}
    if(!ref($tags)){@tmp=split(' ',$tags);$tags=\@tmp;}

    for($no=0,$i=0;$i<=$#$tags;$i++){
#	($tag,$index)=IKTahiIndexTag($tags->[$i],'');   # 
	$tags->[$i] =~ /^(.+?)([0-9]*)$/o; $tag=$1; $index=$2?$2-1:'0';

	if( !$temp->{$tag} ){next;}
	if( $temp->{$tag} ne '@@@'){
	    next;
#	    $name=ref($temp->{$tag})?$temp->{$tag}->{'#Name#'}:$temp->{$tag};  
#	    if(!$index){$index='';};
	}
	else{
	    if(!($subtemp=$IKEFrameFieldMapAssoc{$tag}) ){next;}
	    push(@orderName,$tags->[$i]);
	    $name=$subtemp->{'#Name#'};
	    if(!$index){$index=0;}
	}
	if($name eq 'ATT'){
	    push(@order,"$name#$no");
	    $no++;
	}
	else{
	    if(!$index){
		for($j=0;$j<=$#order;$j++){
		    if( $order[$j] =~ /$name#[0-9]+/ ){$index++;}
		}
            }
	    push(@order,($index ne '')?"$name#$index":$name);
        }
    }
#PrintVal(\@orderName);
#PrintVal(\@order);
    return (-1<$#order?\@order:'',-1<$#orderName?\@orderName:'');
}

# 
sub IKMatchFieldTree {
    my($base,$sub,$result)=@_;
    my($val,@subbase,$i);

    # 
    if(ref($base) eq 'ARRAY'){
	for($i=0;$i<=$#$base;$i++){
	    $result=IKMatchFieldTree($base->[$i],$sub,$result);
	}
    }
    elsif(ref($base) eq 'HASH'){
	# 
	if($base->{'###'} eq $sub->{'###'}){
	    $val=IKCompTree($base,$sub);
	    push(@$result,$val);
	}
	else{
	    @subbase=values(%$base);
	    for($i=0;$i<=$#subbase;$i++){
		$result=IKMatchFieldTree($subbase[$i],$sub,$result);
	    }
	}
    }
    return $result;
}

# 
sub IKEncodeVcpp {
    my($frame,$index,$cpp)=@_;
    my($temp,$exp,$order,$i,$sub,$tag,$subcpp,$expr,@args);

    # 
    if(!($temp=$IKEFrameFieldMapAssoc{$frame->{'##'}}) ){
	return $cpp;
    }
#    MsgPrint('DBG3',"tag[%s]==>$cpp\n",$frame->{'##'});

    if($exp=$temp->{'#CPP#'}){
	if(ref($exp) eq 'SCALAR'){
	    # perl 5.8 
#	    @args=@_; $expr=$$exp; $expr =~ s/\@_/\@args/; $cpp .=eval $expr;
	    # perl 5.0 
	    $cpp .=eval $$exp;
	}
	elsif(ref($exp) eq 'REF'){
	    $cpp .=eval "sprintf(\"$$$exp\")";
	}
	elsif(ref($exp) eq 'CODE'){
	    $cpp .=$exp->($frame,$index);
	}
	else{
	    $cpp .=$exp . "\n";
	}
    }
    
    if(!($order=$frame->{'++'})){return $cpp;}

    for $i (0..$#$order){
	($tag,$index)=IKPKTIndexTag($order->[$i]);
	if(!($sub=$frame->{$tag}->[$index])){
	    MsgPrint('WAR',"Order mismatch [$tag:$index]\n");
	    next;
	}
	$subcpp .= IKEncodeVcpp($sub,$index,'');
    }
    return $cpp . $subcpp;
}

sub IKEncodeVCPP2 {
    my($frame,$name)=@_;
    my(@cpp,@index);
    IKEncodeVcpp2($frame,\@cpp,$name,\@index);
    return \@cpp;
}
# 
sub IKEncodeVcpp2 {
    my($frame,$cpp,$name,$idx)=@_;
    my($temp,$i,$j,@keys,$val,$dx,@index,$subtemp,$indexadd);
    # 
    if(!($temp=$IKEFrameFieldMapAssoc{$frame->{'##'}}) ){
	return '';
    }
    $dx=$#$idx+1;
    @keys=keys(%$frame);
    for $i (0..$#keys){
	if($keys[$i] ne '##' && $keys[$i] ne '###' && $keys[$i] ne '++'){
	    $val=$frame->{$keys[$i]};
	    if(!ref($val)){
		push(@$cpp,IKEvalValToVcpp($val,$temp->{$keys[$i]},$name,$idx));
	    }
	    elsif(ref($val) eq 'ARRAY'){
		# 
		$indexadd=IKIsMultiField($temp,$keys[$i]);
#		$indexadd=(($subtemp=$IKEFrameFieldMapAssoc{$val->[0]->{'##'}}) && $subtemp->{'#Multi#'});
#		if($indexadd){PrintVal($subtemp);printf("[%s:%s]\n",$frame->{'##'},$keys[$i])}
		@index=@$idx;
		for($j=0;$j<=$#$val;$j++){
#		    if($indexadd){$index[$dx]=$j?$j+1:'';}
		    if($indexadd){$index[$dx]=$j+1;}
		    IKEncodeVcpp2($val->[$j],$cpp,$name,\@index);
		}
	    }
	    elsif(ref($val) eq 'HASH'){
		IKEncodeVcpp2($val,$cpp,$name,$idx);
	    }
	}
    }
}
# VCPP
sub IKEvalValToVcpp {
    my($val,$temp,$name,$index)=@_;
    my($label,$value);

    if(!ref($temp) || !$temp->{'CPP'}){
#	printf("item=>$temp, val=>$val\n");
	return;
    }
    $label=$temp->{'CPP'}->{'LA'};
    $value=$temp->{'CPP'}->{'VA'};
    if(ref($label) eq 'SCALAR'){
	$label=eval $$label;
    }
    elsif(ref($label) eq 'REF'){
	$label=eval "sprintf(\"$$$label\")";
    }
    elsif(ref($label) eq 'CODE'){
	$label=$value->($value,$name,$index);
    }
    if(ref($value) eq 'SCALAR'){
	$value=eval $$value;
    }
    elsif(ref($value) eq 'REF'){
	$value=eval "sprintf(\"$$$value\")";
    }
    elsif(ref($value) eq 'CODE'){
	$label=$value->($name,$index);
    }
    else{
	$value=sprintf($value,$val);
    }
#    printf("item=>$temp->{'#Name#'} cpp=>". ' -D' . $label . '=' . $value . "\n");
#    PrintVal($index);
    return ' -D' . $label . '=' . $value;
}
# 
sub IKIsMultiField {
    my($temp,$accessID)=@_;
    my($key,$subtemp);
    foreach $key (keys(%$temp)){
	if($temp->{$key} eq '@@@'){
	    $subtemp=$IKEFrameFieldMapAssoc{$key};
	    if($subtemp->{'#Name#'} eq $accessID){
		return $subtemp->{'#Multi#'};
	    }
	}
    }
    return '';
}
# 
sub CPIdx {
    my($label,$index)=@_;
    return $label . join("",@$index);
}


#============================================
# 
#============================================
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
$PTN_FIELD_EXPR='^\s*([\w#]+)\s*`([^`]+)`(.*)$';
$PTN_FIELD     ='^\s*([\w#]+)\s*(?:([,}].+)$|$)';
$PTN_COMMA     ='^\s*,(.+)$';
$PTN_OR_BRACES ='^\s*(?:{\|)(.+)$';
$PTN_SL_BRACES ='^\s*(?:{!)(.+)$';
$PTN_LT_BRACES ='^\s*(?:{)(.+)$';
$PTN_RT_BRACES ='^\s*(?:})(.*)$';
$PTN_TAG       ='^([^#]+)#((?:(?:[0-9]+)|[NOD]))$';

# 
sub IKFieldVL {
    my($data,$field,$mode,$level,$context)=@_;
    my($v,$val,$nextField,$status,$match,$tag,$expr,$index);
    my($P,$F);

#    PrintVal($data,"field=$field level=$level mode=$mode",$level+1,$mode);

    while($field){
	# 
	if( $field =~ /$PTN_FIELD_EXPR/ ){
	    $tag=$1;$expr=$2;$nextField=$3;
	    # 
            if(ref($data) eq 'ARRAY'){
		return IKFieldVLAR($data,$field,$mode,$level,$context);
	    }
	    else{
		# 
		if($tag =~ /$PTN_TAG/){$tag=$1;$index=$2;}
		# 
		if(!grep{$_ eq $tag} keys(%$data)){
		    MsgPrint(WAR,"Field($field) Item($tag) not exist\n");
		    if  ($mode eq 'and'){return '','Field not exist';}
		    elsif($mode eq 'or'){return IKFieldVL($data,$nextField,$mode,$level+1,$context);}
		    else                {return '','Field not exist';}
		}

		# 
		$v=$data->{$tag};
		if($index ne ''){
		    if   ($index eq 'N'){$v=($#$v eq '')?0:$#$v+1;}
		    elsif($index eq 'O'){$v=$v->{'++'};}
		    elsif(ref($v) eq 'ARRAY'){$v=$v->[$index];}
		    elsif($index eq 'D'){ # 
			printf("Field=[$field] Tag=[$tag] v=[$v] contect:field[%s] level[$level]\n",$context->{'field'});
			if(ref($v)){PrintVal($v);}
		    }
		}
		$P=$context->{pkt};$F=$context->{'field'};
		$val=eval $expr;
#		printf("eval expr[$expr] v=[$v] outout=[$val]\n");
		# AND
                if($mode eq 'and'){
		    if($val) {return IKFieldVL($data,$nextField,$mode,$level+1,$context);}
		    else     {return '','Eval false';}
		}
		# OR
		elsif($mode eq 'or'){
		    if(!$val){return IKFieldVL($data,$nextField,$mode,$level+1,$context);}
		    else     {return $data;}
		}
		# EVAL
		elsif($mode eq 'eval'){
		    return $val;
		}
		# 
		else{
		    if($val) {return IKFieldVL($data,$nextField,$mode,$level+1,$context);}
		    else     {return '','Eval false';}
		}
	    }
	}
	# 
	elsif( $field =~ /$PTN_FIELD/ ){
	    $tag=$1; $nextField=$2;
	    # 
            if(ref($data) eq 'ARRAY'){
		return IKFieldVLAR($data,$field,$mode,$level,$context);
	    }
	    else{
		# 
		if($tag =~ /$PTN_TAG/){$tag=$1;$index=$2;}
		# 
		if(!grep{$_ eq $tag} keys(%$data)){
		    MsgPrint(WAR,"Field($field) Item($tag) not exist\n");
		    return '','Field not exist';
		}
		# 
		if($index ne ''){
		    $v=$data->{$tag};
		    if   ($index eq 'N'){return ($#$v eq '')?0:$#$v+1;}
		    elsif($index eq 'O'){return ref($v) eq 'HASH' ? $v->{'++'} : '';}
		    elsif($index eq 'D'){
			printf("Field=[$field] Tag=[$tag] v=[$v] contect:field[%s] level[$level]\n",$context->{'field'});
			if(ref($v)){PrintVal($v);}
		    }
		    else{
			if(ref($v) eq 'ARRAY'){
			    return IKFieldVL($v->[$index],$nextField,$mode,$level+1,$context);
			}
			MsgPrint(WAR,"Array #$index is not exist\n");
			return '','Field not exist';
		    }
	        }
		return IKFieldVL($data->{$tag},$nextField,$mode,$level+1,$context);
            }
	}
	# 
	elsif( $field =~ /$PTN_COMMA/ ){
#	    printf("[,][$1] skiped\n");
	    $field=$1;
	}
 	# {|
        elsif( $field =~ /$PTN_OR_BRACES/ ){
	    $nextField=$1;
# 	    printf("[{{|][$1]\n");
	    # 
            if(ref($data) eq 'ARRAY'){
		($val,$status,$match)=IKFieldVLAR($data,$nextField,'or',$level,$context);
	    }
	    else{
		($val,$status)=IKFieldVL($data,$nextField,'or',$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=IKFieldEndBraces($nextField);
		return IKFieldVL($match,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return $val,$status,$match;
	    }
 	}
 	# {!
        elsif( $field =~ /$PTN_SL_BRACES/ ){
	    $nextField=$1;
# 	    printf("[{!][$1]\n");
            if(ref($data) eq 'ARRAY'){
		($val,$status,$match)=IKFieldVLAR($data,$nextField,$mode,$level,$context);
	    }
	    else{
		($val,$status)=IKFieldVL($data,$nextField,$mode,$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=IKFieldEndBraces($nextField);
		return IKFieldVL($data,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return $val,$status,$match;
	    }
 	}
 	# {
        elsif( $field =~ /$PTN_LT_BRACES/ ){
	    $nextField=$1;
	    # 
            if(ref($data) eq 'ARRAY'){
		($val,$status,$match)=IKFieldVLAR($data,$nextField,'and',$level,$context);
	    }
	    else{
		($val,$status)=IKFieldVL($data,$nextField,'and',$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=IKFieldEndBraces($nextField);
		return IKFieldVL($match,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return $val,$status,$match;
	    }
 	}
        # }
        elsif( $field =~ /$PTN_RT_BRACES/ ){
	    # OR
	    if($mode eq 'or'){return '','OR false';}
	    return $data;
        }
        else{
            MsgPrint('ERR',"Access Field Spec is illegal[$field]\n");
            return '','Illegal format';
        }
    }
    # OR
    if($mode eq 'or'){return '','OR false';}
    return $data;
}
sub IKFieldVLAR {
    my($data,$field,$mode,$level,$context)=@_;
    my(@result,@match,$i,$val,$status);
    
#    printf("ARRAY loop\n");
    # 
    for($i=0;$i<=$#$data;$i++){
	# 
	if(!$data->[$i]){next;}
	# 
	($val,$status)=IKFieldVL($data->[$i],$field,$mode,$level+1,$context);
	if(!$status){
	    # 
	    if(ref($val) eq 'ARRAY'){push(@result,@$val);}
	    else {push(@result,$val);}
	    push(@match,$data->[$i]);
	}
    }
    return \@result,$#result<0,\@match;
}

sub IKFieldReduceAR {
    my($data,$field,$mode,$level,$context)=@_;
    my(@match,$i,$val,$status);
    
    # 
    for($i=0;$i<=$#$data;$i++){
	# 
	if(!$data->[$i]){next;}
	# 
	($val,$status)=IKFieldReduce($data->[$i],$field,$mode,$level+1,$context);
	if(!$status){
	    # 
	    push(@match,$val);
	}
    }
    return \@match,$#match<0;
}

# 
sub IKFieldReduce {
    my($data,$field,$mode,$level,$context)=@_;
    my($key,$val,$newdata,$tag,$expr,$nextField,$status,$index,$v);
    
    while($field){
	# 
	if( $field =~ /$PTN_FIELD_EXPR/ ){
	    $tag=$1;$expr=$2;$nextField=$3;
	    # 
            if(ref($data) eq 'ARRAY'){
		return IKFieldReduceAR($data,$field,$mode,$level,$context);
	    }
	    # 
	    if($tag =~ /$PTN_TAG/){$tag=$1;$index=$2;}

	    # 
	    $v=$data->{$tag};
	    # 
	    if($index ne '' && ref($v) eq 'ARRAY'){$v=$v->[$index];}
	    $val=eval $expr;

	    # AND
	    if(!$mode || $mode eq 'and'){
		if($val) {return IKFieldVL($data,$nextField,$mode,$level+1,$context);}
		else     {return '','eval false'}
	    }
	    elsif($mode eq 'or'){
		if($val) {return $data;}
		else     {return IKFieldVL($data,$nextField,$mode,$level+1,$context);}
	    }
	}
	# 
	elsif( $field =~ /$PTN_FIELD/ ){
	    $tag=$1;
	    $nextField=$2;
	    # 
            if(ref($data) eq 'ARRAY'){
		return IKFieldReduceAR($data,$field,$mode,$level,$context);
	    }
	    # 
	    if($tag =~ /$PTN_TAG/){$tag=$1;$index=$2;}

	    # 
	    while(($key,$val)=each(%$data)){
		if($key ne $tag){$newdata->{$key}=$val;}
	    }
	    # 
	    if(!grep{$_ eq $tag} keys(%$data)){
		MsgPrint(WAR,"IKFieldReduce Field($field) Item($tag) not exist\n");
		if(!$mode)        {return $newdata;}
		if($mode eq 'and'){return '','key not exist';}
		if($mode eq 'or') {return '','key not exist';}
	    }
	    # 
	    if($index ne ''){
		$v=$data->{$tag};
		if(ref($v) eq 'ARRAY'){
		    ($val,$status)=IKFieldReduce($v->[$index],$nextField,$mode,$level+1,$context);
		    # 
		    $newdata->{$tag}->[0]=(!$status)?$val:'';
		}
	    }
	    elsif($data->{$tag}){
		($val,$status)=(ref($data) eq 'ARRAY')?
		    IKFieldReduceAR($data,$field,$mode,$level,$context):
		    IKFieldReduce($data->{$tag},$nextField,$mode,$level+1,$context);
		# 
		$newdata->{$tag}=(!$status)?$val:'';
	    }
	    else{
		$newdata->{$tag}='';
		$status = 'empty';
	    }
	    # AND OR 
	    return $newdata,$mode && $status;
	}
	# 
	elsif( $field =~ /$PTN_COMMA/ ){
	    $field=$1;
	}
 	# {|
        elsif( $field =~ /$PTN_OR_BRACES/ ){
	    $nextField=$1;
 	}
 	# {!
        elsif( $field =~ /$PTN_SL_BRACES/ ){
	    $nextField=$1;
# 	    printf("[{!][$1]\n");
            if(ref($data) eq 'ARRAY'){
		($val,$status)=IKFieldReduceAR($data,$nextField,$mode,$level,$context);
	    }
	    else{
		($val,$status)=IKFieldVL($data,$nextField,$mode,$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=IKFieldEndBraces($nextField);
		return IKFieldReduce($data,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return $val,$status;
	    }
 	}
 	# {
        elsif( $field =~ /$PTN_LT_BRACES/ ){
	    $nextField=$1;
	    # 
            if(ref($data) eq 'ARRAY'){
		($val,$status)=IKFieldReduceAR($data,$nextField,'and',$level,$context);
	    }
	    else{
		($val,$status)=IKFieldReduce($data,$nextField,'and',$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=IKFieldEndBraces($nextField);
		return IKFieldVL($val,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return '','false {';
	    }
 	}
        # }
        elsif( $field =~ /$PTN_RT_BRACES/ ){
	    # OR
	    if($mode eq 'or'){return '','OR false';}
	    return $data;
        }
        else{
            MsgPrint('ERR',"Access Field Spec is illegal[$field]\n");
            return '','Illegal format';
        }
    }
    return $data;
}

# 
sub IKFieldEndBraces {
    my($field)=@_;
    while($field){
	# 
	if( $field =~ /$PTN_FIELD_EXPR/ ){
	    $field=$3;
	}
	# 
	elsif( $field =~ /$PTN_FIELD/ ){
	    $field=$2;
	}
	# 
	elsif( $field =~ /$PTN_COMMA/ ){
	    $field=$1;
	}
 	# {|
        elsif( $field =~ /$PTN_OR_BRACES/ ){
	    $field=IKFieldEndBraces($1);
 	}
 	# {!
        elsif( $field =~ /$PTN_SL_BRACES/ ){
	    $field=IKFieldEndBraces($1);
 	}
 	# {
        elsif( $field =~ /$PTN_LT_BRACES/ ){
	    $field=IKFieldEndBraces($1);
 	}
        # }
        elsif( $field =~ /$PTN_RT_BRACES/ ){
	    return $1;
        }
        elsif( $field =~ /^\s*$/ ){
	    return;
	}
        else{
            MsgPrint('ERR',"Access Field Spec is illegal[$field]\n");
            return;
        }
    }
}

#============================================
# 
#============================================
# 
sub Cp1 {
    my($op,$v1,$v2,$pktinfo,$inst,$context)=@_;
    my($result,$i);

    # 
    if($op eq '<>'){
	$result = $v2->[0]<$v1 && $v1<$v2->[1];
	IKSetEvalResult($context,'1op',$op,$result,$v1,$v2->[0],$v2->[1]);
	return $result;
    }
    # 
    elsif($op eq '<=>'){
	$result = $v2->[0]<=$v1 && $v1<=$v2->[1];
	IKSetEvalResult($context,'1op',$op,$result,$v1,$v2->[0],$v2->[1]);
	return $result;
    }
    # 
    elsif($op eq '<<<'){
	$result='T';
	if(ref($v1) eq 'ARRAY'){
	    for($i=0;$i<$#$v1;$i++){
		if($v2 && $v1->[$i]+$v2 ne $v1->[$i+1]){
		    $result='';
		    last;
		}
		elsif(!$v2 && $v1->[$i] >= $v1->[$i+1]){
		    $result='';
		    last;
		}
	    }
	}
	IKSetEvalResult($context,'1op',$op,$result,$v1,$v1->[$i],$v1->[$i+1]);
	return $result;
    }
    # 
    elsif($op eq '==='){
	$result='T';
	if(ref($v1) eq 'ARRAY'){
	    for($i=0;$i<$#$v1;$i++){
		if($v1->[$i] ne $v1->[$i+1]){
		    $result='';
		    last;
		}
	    }
	}
	IKSetEvalResult($context,'1op',$op,$result,$v1,$v1->[$i],$v1->[$i+1]);
	return $result;
    }
    return;
}
# 
sub Cp2 {
    my($op,$v1,$v2,$pktinfo,$inst,$context)=@_;
    my($result);
    if($op eq 'IP6'){
	$result = (IPv6StrToHex($v1) eq IPv6StrToHex($v2));
	IKSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq 'IP4'){
	$result = IPv4StrToHex($v1) eq IPv4StrToHex($v2);
	IKSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '<'){
	$result = $v1 < $v2;
	IKSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '<='){
	$result = $v1 <= $v2;
	IKSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '>'){
	$result = $v1 > $v2;
	IKSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    elsif($op eq '>='){
	$result = $v1 >= $v2;
	IKSetEvalResult($context,'2op',$op,$result,$v1,$v2);
	return $result;
    }
    return '';
}
# 
sub Eq {
    my($v1,$v2,$pktinfo,$inst,$context)=@_;
    my($result);
    shift;shift;
    if($v1 eq $v2){
	IKSetEvalResult($context,'2op','eq',$result,$v1,$v2);
	return 'T';
    }
    if(ref($v1) || ref($v2)){
	$result=IsCompMember('eq',$v1,$v2);
    }
    IKSetEvalResult($context,'2op','eq',$result,$v1,$v2);
    return $result;
}
# 
sub EQ {
    my($v1,$v2,$pktinfo,$inst,$context)=@_;
    my($result);
    shift;shift;
    if(!ref($v1) && !ref($v2) && lc($v1) eq lc($v2)){
	IKSetEvalResult($context,'2op','EQ',$result,$v1,$v2);
	return 'T';
    }
    if(ref($v1) || ref($v2)){
	$result=IsCompMember('EQ',$v1,$v2);
    }
    IKSetEvalResult($context,'2op','EQ',$result,$v1,$v2);
    return $result;
}
# 
sub Eg {
    my($v1,$v2,$pktinfo,$inst,$context)=@_;
    shift;shift;
    $v1 = SumElement($v1);
    $v2 = SumElement($v2);
    return Cp2('<',$v1,$v2,$pktinfo,$inst,$context);
}
# 
sub Ege {
    my($v1,$v2,$pktinfo,$inst,$context)=@_;
    shift;shift;
    $v1 = SumElement($v1);
    $v2 = SumElement($v2);
    return Cp2('<=',$v1,$v2,$pktinfo,$inst,$context);
}
# 
sub El {
    my($v1,$v2,$pktinfo,$inst,$context)=@_;
    shift;shift;
    $v1 = SumElement($v1);
    $v2 = SumElement($v2);
    return Cp2('>',$v1,$v2,$pktinfo,$inst,$context);
}
# 
sub Ele {
    my($v1,$v2,$pktinfo,$inst,$context)=@_;
    shift;shift;
    $v1 = SumElement($v1);
    $v2 = SumElement($v2);
    return Cp2('>=',$v1,$v2,$pktinfo,$inst,$context);
}
# 
sub Mch {
}
# 
sub MCH {
}
# 
sub SumElement {
    my($dat)=@_;
    my($sum,@dat,$i);
    if(!ref($dat)){
	if( $dat =~ /^[0-9\-]+$/ ){
	}
	elsif( $dat =~ /^[0-9a-fA-F\-]+$/ ){
	    $dat=hex($dat);
	}
	return $dat;
    }
    elsif(ref($dat) eq 'ARRAY'){
	for $i (0..$#$dat){
	    $sum += SumElement($dat->[$i]);
	}
	return $sum;
    }
    elsif(ref($dat) eq 'HASH'){
	@dat = values(%$dat);
	return SumElement(\@dat);
    }
    return 0;
}
# 
sub TotalElement {
    my($dat)=@_;
    if($dat eq ''){return 0;}
    if(ref($dat) eq 'ARRAY'){return $#$dat+1;}
    return 1;
}
sub IsInclude {
    my($op,$v1,$v2,$pktinfo,$inst,$context)=@_;
    my($result);
    shift;shift;shift;
    if($v1 eq $v2 || (ref($v2) eq 'ARRAY' && grep{ IsCompMember($op,$v1,$_) } @$v2)){
	IKSetEvalResult($context,'2op','include','T',$v1,$v2);
	return 'T';
    }
    IKSetEvalResult($context,'2op','include',$result,$v1,$v2);
    return ;
}
# 
# 
sub IsCompMember {
    my($op,$v1,$v2,$inc)=@_;
    my($i,$j,@v1key,@v2key);
    if(ref($v1) eq 'ARRAY' || ref($v2) eq 'ARRAY'){
	if(ref($v1) ne 'ARRAY'){$v1=[$v1];}
	if(ref($v2) ne 'ARRAY'){$v2=[$v2];}
	if($#$v1 ne $#$v2){return;}
	if($inc){
	    for($i=0;$i<=$#$v1;$i++){
		for($j=0;$j<=$#$v1;$j++){
		    if(IsCompMember($op,$v1->[$i],$v2->[$j],$inc)){goto MATCH1;}
		}
		return;
	      MATCH1:
	    }
	    for($i=0;$i<=$#$v1;$i++){
		for($j=0;$j<=$#$v1;$j++){
		    if(IsCompMember($op,$v1->[$j],$v2->[$i],$inc)){goto MATCH2;}
		}
		return;
	      MATCH2:
	    }
	    return 'T';
	}
	else{
	    # 
	    for($i=0;$i<=$#$v1;$i++){
		if(!IsCompMember($op,$v1->[$i],$v2->[$i],$inc)){return;}
	    }
	}
	return 'T';
    }
    elsif(ref($v1) ne ref($v2)){return;}
    elsif(ref($v1) eq 'HASH'){
	@v1key=sort keys(%$v1);
	@v2key=sort keys(%$v2);
	if($#v1key ne $#v2key){return;}
	if(!IsCompMember($op,\@v1key,\@v2key,$inc)){return;}
	for($i=0;$i<=$#v1key;$i++){
	    if(!IsCompMember($op,$v1->{$v1key[$i]},$v2->{$v1key[$i]},$inc)){return;}
	}
	return 'T';
    }
    elsif(!ref($v1)){
	if($op eq 'eq'){return $v1 eq $v2;}
	if($op eq 'EQ'){return lc($v1) eq lc($v2);}
	return eval "($v1) $op ($v2)";
    }
    else{return $v1 eq $v2;}
}
# 
sub IsMember {
    my($v1,$v2,$pktinfo,$inst,$context)=@_;
    my($result,$i,$v3);
    shift;shift;

    if(!$v1 || $v1 eq $v2){$result='T';}
    elsif(ref($v1) eq 'ARRAY'){
	for $i (0..$#$v1){
	    if(!ref($v2)){$result=$v1->[$i] eq $v2;}
	    elsif(ref($v2) eq 'ARRAY'){$result=grep{$_ eq $v1->[$i]} @$v2;}
	    else{$result='';}
	    if(!$result){$v3=$v1;$v1=$v1->[$i];last;}
	}
    }
    elsif(ref($v2) eq 'ARRAY'){
	$result=grep{$_ eq $v1} @$v2;
    }
    if($context){IKSetEvalResult($context,'2op','include',$result,$v1,$v2,$v3);}
    return $result;
}
sub IsNonMember {
    my($v1,$v2,$pktinfo,$inst,$context)=@_;
    my($result,$i);
    shift;shift;
    if($v1 eq $v2){$result='';}
    elsif(ref($v1) eq 'ARRAY'){
	for $i (0..$#$v1){
	    if(!ref($v2)){$result=$v1->[$i] ne $v2;}
	    elsif(ref($v2) eq 'ARRAY'){$result=!grep{$_ eq $v1->[$i]} @$v2;}
	    else{$result='OK';}
	    if(!$result){last;}
	}
    }
    elsif(ref($v2) eq 'ARRAY'){
	$result=!grep{$_ eq $v1} @$v2;
    }
    else{
	$result=(ref($v1) eq ref($v2)) && ($v1 ne $v2);
    }
    IKSetEvalResult($context,'2op','include',$result,$v1,$v2);
    return $result;
}

# 
sub IsIncludeAssoc {
    my($v1,$v2)=@_;
    my(@v2key,$i);
    @v2key=keys(%$v2);
    for($i=0;$i<=$#v2key;$i++){
	if(!IsCompMember('eq',$v1->{$v2key[$i]},$v2->{$v2key[$i]})){return;}
    }
    return 'T';
}

sub IKCompTree {
    my($base,$sub)=@_;
    my(@keys,$i,$j,$subbase,$expr);

    if(ref($base) ne ref($sub)){return;}

    # 
    if(ref($base) eq 'ARRAY'){
	for($i=0;$i<=$#$sub;$i++){
	    $expr=$sub->[$i];
	    for($j=0;$j<=$#$base;$j++){
		if( $base->[$j] eq $expr ){goto MATCH;}
		elsif(ref($expr) eq 'HASH')  {if( IKCompTree($base->[$j],$expr) ){goto MATCH;}}
		elsif(ref($expr) eq 'ARRAY') {if( IKCompTree($base->[$j],$expr) ){goto MATCH;}}
		elsif(ref($expr) eq 'CODE')  {if( $expr->($base->[$j]) ){goto MATCH;}}
		elsif(ref($expr) eq 'SCALAR'){if( $base->[$j] =~ $$expr ){goto MATCH;}}
		elsif(ref($expr) eq 'REF')   {if( eval $$$expr ){goto MATCH;}}
	    }
	    return;
	  MATCH:
	}
	return TRUE;
    }

    # 
    @keys=keys(%$sub);
    for($i=0;$i<=$#keys;$i++){
	$expr=$sub->{$keys[$i]};
	if(!ref($expr))              {if( $base->{$keys[$i]} ne $expr ){return;}}
	elsif(ref($expr) eq 'HASH')  {if( !IKCompTree($base->{$keys[$i]},$expr) ){return;}}
	elsif(ref($expr) eq 'ARRAY') {if( !IKCompTree($base->{$keys[$i]},$expr) ){return;}}
	elsif(ref($expr) eq 'CODE')  {if( !$expr->($base->{$keys[$i]}) ){return;}}
	elsif(ref($expr) eq 'SCALAR'){if( !($base->{$keys[$i]} =~ $$expr) ){return;}}
	elsif(ref($expr) eq 'REF')   {if( !(eval $$$expr) ){return;}}
	else{return ;}
    }
    return TRUE;
}

# 
sub IsElementUnique {
    my($val,$except)=@_;
    my(%elem,$i);
#    PrintVal($val);
    if(ref($val) ne 'ARRAY'){return 'T';}
    for $i (0..$#$val){
	if(defined($except)){
	    if($val->[$i] eq $except){next;}
	    if(ref($except) eq 'ARRAY' && grep{$_ eq $val->[$i]}@$except){next;}
	}
	if($elem{$val->[$i]}){return;}
	$elem{$val->[$i]}='T';
    }
    return 'T';
}
#============================================
# 
#============================================
sub IKStartTimer {
    my($timeout,$inst)=@_;
    my($tim);
    $tim->{'TimerID'}=$IKTimerUniqueNumb++;
    $tim->{'Timeout'}=$timeout;
    $tim->{'EndTime'}=time()+$timeout;
    $IKTimerDB{$tim->{'TimerID'}}=$tim;
}
sub IKStopTimer {
    my($timerid)=@_;
    $IKTimerDB{$timerid}='';
}
sub IKCheckTimeout {
    my(@timerid,$ctime,$id,$event);
    @timerid=keys(%IKTimerDB);
    if(-1<$#timerid){
	$ctime=time();
	foreach $id (@timerid){
	    if($IKTimerDB{$id}->{'EndTime'}<$ctime){
		$event=IKCreateEvent(TIMEOUT,$IKTimerDB{$id});
		IKPushEvent($event);
		IKStopTimer($id);
	    }
	}
    }
}

#============================================
# 
#============================================
# Expire
sub IKAddCapture {
    my($frame,$pkt,$name,$comment,$seqNo,$msgNo)=@_;
    my($msg,$time,$dir);
    if($pkt){
	if($pkt->{recvTime1}){
	    $time=$pkt->{recvTime1};
	    $dir='in';
	}
	elsif($pkt->{sentTime1}){
	    $time=$pkt->{sentTime1};
	    $dir='out';
	}
	else{
	    MsgPrint('WAR',"TAHI Packet data illegal(timestamp)\n");
	    return;
	}
	if($IKMsgCaptureLastTime<$time){$IKMsgCaptureLastTime=$time;}
    }
    else{
	$time=time();
	if($time<=$IKMsgCaptureLastTime){
	    $IKMsgCaptureLastTime+=0.0001;
	    $time=$IKMsgCaptureLastTime;
	}
    }
    # 
    $msg={'Type'=>'IKE','Direction'=>$dir,'Pkt'=>$pkt,'Frame'=>$frame,'Time'=>$time,
	  'PktName'=>$name,'SequenceNo'=>$seqNo,'MsgnoInSequence'=>$msgNo,'Comment'=>$comment};
    push(@IKMsgCapture,$msg);
    return $#IKMsgCapture;
}
sub IKAddCmtCapture {
    my($msg)=@_;
    $IKMsgCapture[$#IKMsgCapture]->{'Comment'}=$msg;
}
# 
sub IKArrangeCapture {
    my($i,$j,@tnaddr,$tnaddr,@nutaddr,$nutaddr,%seq,$idx);

    # 
    @IKMsgCapture = sort{$a->{'Time'} <=> $b->{'Time'}} @IKMsgCapture;
    
    # 
    for $i (0..$#IKMsgCapture){
	if($IKMsgCapture[$i]->{Direction} eq 'in'){
	    $nutaddr=$IKMsgCapture[$i]->{'Pkt'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
	    $tnaddr=$IKMsgCapture[$i]->{'Pkt'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
	}
	elsif($IKMsgCapture[$i]->{Direction} eq 'out'){
	    $nutaddr=$IKMsgCapture[$i]->{'Pkt'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
	    $tnaddr=$IKMsgCapture[$i]->{'Pkt'}->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
	}
	if($nutaddr){
	    for $j (0..$#nutaddr){
		if($nutaddr[$j] eq $nutaddr){
		    $IKMsgCapture[$i]->{'NUTNode'}=(2<$j)?2:$j;
		    goto NEXT1;
		}
	    }
	    push(@nutaddr,$nutaddr);
	    $IKMsgCapture[$i]->{'NUTNode'}=(2<$#nutaddr)?2:$#nutaddr;
	}
      NEXT1:
	if($tnaddr){
	    for $j (0..$#tnaddr){
		if($tnaddr[$j] eq $tnaddr){
		    $IKMsgCapture[$i]->{'TNNode'}=(2<$j)?2:$j;
		    goto NEXT2;
		}
	    }
	    push(@tnaddr,$tnaddr);
	    $IKMsgCapture[$i]->{'TNNode'}=(2<$#tnaddr)?2:$#tnaddr;
	}
      NEXT2:
    }
    # 
    $idx=0;
    for $i (0..$#IKMsgCapture){
	if(!defined($seq{$IKMsgCapture[$i]->{'SequenceNo'}})){
	    $seq{$IKMsgCapture[$i]->{'SequenceNo'}}=$idx;
	    $idx++;
	}
    }
    for $i (0..$#IKMsgCapture){
	$IKMsgCapture[$i]->{'SequenceNo'}=$seq{$IKMsgCapture[$i]->{'SequenceNo'}};
    }

    return \@IKMsgCapture;
}
sub IKEGetFrameNoFromTimestamp {
    my($timeStamp)=@_;
    my($i);
    for $i (0..$#IKMsgCapture){
	if($IKMsgCapture[$i]->{'Time'} eq $timeStamp){return $i;}
    }
    return $i;
}
#============================================
# 
#============================================
sub IKGetNewNo {
    return $IKUniqueNumb++;
}
#============================================
# MAC
#============================================
sub IKRegistMacAddr {
    my($key,$val,@no,$no);
    $no=();
    while(($key,$val)=each(%V6evalTool::TnDef)){
	if( $key =~ /^Link([0-9]+)_addr/i ){
	    $IKMacAddrInfo->{$val} = {'Addr'=>$val,'Link'=>"Link$1",'Side'=>'TN'};
	    push(@no,{'ID'=>$1,'Val'=>$IKMacAddrInfo->{$val}});
	}
    }
    if($#no eq 0){
	@no = sort {$a->{ID} <=> $b->{ID}} @no;
	$IKMacAddrInfo->{'tnether()'}=$no[0]->{'Val'};
	$IKMacAddrInfo->{'tnether'}=$no[0]->{'Val'};
    }

    @no=();
    while(($key,$val)=each(%V6evalTool::NutDef)){
	if( $key =~ /Link([0-9]+)_addr/i ){
	    $IKMacAddrInfo->{$val} = {'Addr'=>$val,'Link'=>"Link$1",'Side'=>'NUT'};
	    push(@no,{'ID'=>$1,'Val'=>$IKMacAddrInfo->{$val}});
	}
    }
    if($#no eq 0){
	@no = sort {$a->{ID} <=> $b->{ID}} @no;
	$IKMacAddrInfo->{'nutether()'}=$no[0]->{'Val'};
	$IKMacAddrInfo->{'nutether'}=$no[0]->{'Val'};
    }
}
sub IKIsLocalMac {
    my($mac)=@_;
    return $IKMacAddrInfo->{$mac}->{'Side'} eq 'TN';
}
sub IKIsRemoteMac {
    my($mac)=@_;
    return $IKMacAddrInfo->{$mac}->{'Side'} eq 'NUT';
}
sub IKGetMacAddress {
    my($mac,$link)=@_;
    my(@keys,$i,$cond);
    if($mac =~ /^[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+$/){
	return $mac;
    }
    if($mac =~ /^tnether/i){
	if($IKMacAddrInfo->{$mac}){return $IKMacAddrInfo->{$mac}->{'Addr'};}
	@keys=keys(%$IKMacAddrInfo);
	$cond={'Link'=>$link?$link:'Link0','Side'=>'TN'};
	for $i (0..$#keys){
	    if(IsIncludeAssoc($IKMacAddrInfo->{$keys[$i]},$cond)){
		return $IKMacAddrInfo->{$keys[$i]}->{'Addr'};
	    }
	}
    }
    if($mac =~ /^nutether/i){
	if($IKMacAddrInfo->{$mac}){return $IKMacAddrInfo->{$mac}->{'Addr'};}
	@keys=keys(%$IKMacAddrInfo);
	$cond={'Link'=>$link?$link:'Link0','Side'=>'NUT'};
	for $i (0..$#keys){
	    if(IsIncludeAssoc($IKMacAddrInfo->{$keys[$i]},$cond)){
		return $IKMacAddrInfo->{$keys[$i]}->{'Addr'};
	    }
	}
    }
    return;
}

#============================================
# VCPP
#============================================
sub VCppRegist {
    my($id,$str,$evalFlag)=@_;
    $VCCIDList{$id} = {'Str'=>$str,'Eval'=>$evalFlag};
}
sub VCppApply {
    my($tmpCPP,$id,$xor,$forceApply)=@_;
    my($vcpp,$msg,$i,$ids,@keys);

    if($id && !ref($id)){$ids=[$id];}
    elsif(ref($id) eq 'ARRAY'){$ids=$id;}

    # ID
    @keys=keys(%VCCIDList);
    for $i (0..$#keys){
	if(!$id || !((grep{$_ eq $keys[$i]} @$ids) xor !$xor)){
	    if($VCCIDList{$keys[$i]}->{'Eval'}){
#		PrintItem("sprintf(\"$VCCIDList{$keys[$i]}->{'Str'}\")");
		$msg=eval "sprintf(\"$VCCIDList{$keys[$i]}->{'Str'}\")";
#		PrintItem($msg);
	    }
	    else{
		$msg=$VCCIDList{$keys[$i]}->{'Str'};
	    }
	    $vcpp .= ' ' . $msg;
	}
    }
    if($tmpCPP){
	$vcpp .= ' ' . $tmpCPP;
    }
    if($forceApply || $VCCLastStr ne $vcpp){
#	MsgPrint('DBG',"VCPP=[$vcpp]\n");
#	$vcpp='-DOTHER_SRC_ADDR=v6\(\"9001::3\"\)';
	MsgPrint('DBG',"VCPP=[$vcpp]\n");
	$vcpp .= ' -DUSE_IKESUB_DEF';
	vCPP($vcpp);
	$VCCLastStr=$vcpp;
    }
}

#============================================
# TAHI
#============================================
sub IKESetupNode {
    my($src,$dst)=@_;
    my($cpp);
    $cpp=sprintf("-DIKE_SEND_SRC_ADDR=v6\\\(\\\"%s\\\"\\\) -DIKE_SEND_DST_ADDR=v6\\\(\\\"%s\\\"\\\)",$src,$dst);
    VCppRegist('IKE',$cpp);
}

# 
sub IKERecv {
    my($link,@frames)=@_;
    my($pkt,$msg,$val,$nxt,$data);
    
    $pkt = {};
    %$pkt = vRecv3($link, 1, 0, 1, @frames );
    $pkt->{'vRecvPKT'}=$V6evalTool::vRecvPKT;
    # IKE_RECV[0-9]
    if($pkt->{'recvFrame'} =~ /$IKERcvFRAMENAME[0-9]*/){
	$pkt->{'recvFrame'}=$IKERcvFRAMENAME;
    }
    if($TAHIPlatformMode){
	# HEX
	if($pkt->{status}==0 && ($msg=$pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_SIP.message'})){
	    # 
	    $msg =~ s/\n//g;
	    ($val,$nxt,$data)=HXPktHexDecode('Udp_ISAKMP',$msg);
	    $pkt=HXConvHexStToTAHI($val);
	}
    }
    return %$pkt;
}

# HEX
sub IKEWriteHexMsg {
    my($msg) = @_;
#    print "$IKE_MSG_FILE $msg\n";
    open(OUT, "> " . $IKE_MSG_FILE);
    print OUT "$msg";
    close(OUT);
}

sub IKESend {
    my($srcmac,$srcip,$dstmac,$dstip,$data,$frame,$link,$enc)=@_;
    my($msg,$hexmsg,$vcpp,%pkt);
    if(!$link){$link='Link0';}
    if(!$data){return;}

    # HEX
    if($TAHIPlatformMode){
	# 
	$hexmsg=HXConvSTToHex($data);
	$msg=pack("H*",$hexmsg);
	# 
	VCppApply();
	# HEX
	IKEWriteHexMsg($msg);
	%pkt=vSend($link,'IKE_SEND_HEX');
    }
    else{
	# 
	IKEEncode($srcmac,$srcip,$dstmac,$dstip,$data,$enc);
	%pkt=vSend3($link,$frame);
	$pkt{'vSendPKT'}=$V6evalTool::vSendPKT;
    }
    return \%pkt;
}

#============================================
# 
#============================================
%IKE_LOG_COLOR = ('ERR'=>'red','WAR'=>'green','INF1'=>'blue','INF2'=>'blue','DBG'=>'black','SEQ'=>'black','JDG'=>'black');
# 
sub LogHTML {
    my($msg,$category,$pkt)=@_;
    my($index);
    $index=$pkt->{recvTime1}?$pkt->{recvTime1}:($pkt->{sentTime1}?$pkt->{sentTime1}:time());
    push(@IK_HTMLLog,{'Index'=>$index,'Msg'=>$msg,'Category'=>$category});
}
# LogHTML
sub LogHTMLOutput {
    map{ref($_)?OutputIKEFrame($_):vLogHTML($_);} @IK_HTMLLog;
    undef(@IK_HTMLLog);
}
sub LOG_Err {
    my ($msg) = @_;
#    vLogHTML('</TD></TR><TR><TD></TD><TD>');
    vLogHTML('<font color="red">' . $msg . '</font><BR>');
}
sub LOG_Warn {
    my ($msg) = @_;
    vLogHTML('<font color="green">' . $msg . '</font><BR>');
    if($CNT_RESULT != 2){
	$CNT_RESULT = 1;
    }
}
sub LOG_OK {
    my ($msg) = @_;
#    vLogHTML('</TD></TR><TR><TD></TD><TD>');
    vLogHTML('<font color="blue">' . $msg . '</font><BR>');
}
sub LOG_Msg {
    my ($msg) = @_;
    vLogHTML('<B><font color="black">' . $msg . '</font></B><BR>');
}
# TAHI
sub MsgTahiPrint {
    my($level,$phase,$said,$frm,@args)=@_;
    my($msg);
    if(!grep{$_ eq $level} @IKLogLevel){return;}
    # SAID
    if(ref($phase) eq 'HASH'){
	if(defined($phase->{'SaID'})){$said=$phase->{'SaID'};}
	elsif(defined($phase->{'SaID1'})){$said=$phase->{'SaID1'};}
	elsif(defined($phase->{'SaID2'})){$said=$phase->{'SaID2'};}
	if(defined($phase->{'Phase'})){$phase=$phase->{'Phase'};}
	else{$phase='';}
    }
    if(ref($said) eq 'ARRAY'){$said=$said->[0];}
    $phase=$IKEsadesc{$phase}?$IKEsadesc{$phase}:$phase;
    if($phase || $said){
	$msg=sprintf("IKE:Phase%s(%s)%s " . $frm,$phase,$said,$level eq 'ERR'?' error':'',@args);
    }
    else{
	$msg=sprintf("IKE:%s " . $frm,$level eq 'ERR'?' error':'',@args);
    }
    $msg =~ s/\n//;
    $msg = ConvertHTMLMessage($msg);
    vLogHTML('<B><font color="' . $IKE_LOG_COLOR{$level} . '">' . $msg . '</font></B><BR>');
}
# TAHI
sub LogPrint {
    my($level,$phase,$said,$frm,@args)=@_;

    # TAHI
    MsgTahiPrint(@_);

    # 
    MsgPrint($level,$frm,@args);
    return '';
}
# 
sub MsgPrint {
    my($level,$frm,@args)=@_;
    my($diff,$indent,@stack,$i);

    # 
    if(!$IKDBGLogLevel{$level}){return '';}
    $indent=1;$i=1;
    while(@stack=caller($i++)){if(!$stack[6]){$indent++;}}
    $indent=sprintf( sprintf("%%%ds",$indent-2), " " );
    if($IK_Support_HiRes){
	$diff=($IKE_LAST_MSG_TIME?
	       Time::HiRes::tv_interval($IKE_LAST_MSG_TIME, [Time::HiRes::gettimeofday()]):0);
#	printf($level . "[%6.1f]: " . $frm,$diff*1000,@args);
	printf($level . "[%6.1f]:$indent" . $frm,$diff*1000,@args);
	$IKE_LAST_MSG_TIME=[Time::HiRes::gettimeofday()];
    }
    else{
#	printf($level . ": " . $frm,@args);
	printf($level . ":$indent" . $frm,@args);
    }
    return '';
}
sub MsgIndentPrint {
    my($val,$indent)=@_;
    if(!$IKDBGLogLevel{'DBG'}){return;}
    if($indent>0){
	printf( sprintf("%%%ds",$indent), " " );
    }
    print "$val";
}

sub IsLogLevel {
    my($level)=@_;
    return $IKDBGLogLevel{$level};
}
#   ":&quot; &:&amp; <:&lt; >:&gt;
sub ConvertHTMLMessage {
    my($msg)=@_;

    # HTML
    $msg =~ s/&/&amp;/g;
    $msg =~ s/"/&quot;/g;
    $msg =~ s/</&lt;/g;
    $msg =~ s/>/&gt;/g;
    return $msg;
}

sub PrintVal {
    my($val,$title,$indent)=@_;
    my(@stack);
    if( $indent eq ''){$indent=3;}
    @stack=caller(1);
    printf("-----PrintVal(%s / %s)----------\n",$title,$stack[3]);
    PrintVL($val,$indent);
    return $val;
}
sub PrintVL {
    my($val,$indent,$omit)=@_;
    my($i,$key,$v,@keys);

    if(ref($val) eq 'ARRAY'){
	if($#$val<0){
	    printf( sprintf("%%%ds",$indent), " " );
	    printf("Array element Nothing\n");
	}
	for($i=0;$i<=$#$val;$i++){
	    printf( sprintf("%%%ds",$indent), " " );
	    if(!ref($val->[$i])){
		printf("No[%s] = %s\n",$i,($val->[$i] eq '')?Nil:$val->[$i]);
	    }
	    else{
		printf("No[%s] =\n",$i);
		PrintVL($val->[$i],$indent+3);
	    }
	}
    }
    elsif(ref($val) eq 'HASH'){
	@keys=sort(keys(%$val));
	for $i (0..$#keys){
	    $key=$keys[$i];
	    if($omit){
		if($omit eq $key || (ref($omit) eq 'ARRAY' && grep{$_ eq $key} @$omit)){next;}
	    }
	    $v=$val->{$key};
	    printf( sprintf("%%%ds",$indent), " " );
	    if(!ref($v)){
		printf("$key: = %s\n",($v eq '')?Nil:$v);
	    }
	    else{
		printf("$key: =\n",$key);
		PrintVL($v,$indent+3);
	    }
	}
    }
    elsif(ref($val) eq 'SCALAR'){
	printf( sprintf("%%%ds",$indent), " " );
	printf("%s = \n",$val);
	PrintVL($$val,$indent+3);
    }
    elsif(ref($val) eq 'Math::Pari'){
 	printf( sprintf("%%%ds",$indent), " " );
 	printf( "Pari:: %s\n", Math::Pari::pari2pv($val) );
    }
    else{
	printf( sprintf("%%%ds",$indent), " " );
	printf( "%s\n", ($val eq '')?'Nil':$val );
    }
}
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

1
