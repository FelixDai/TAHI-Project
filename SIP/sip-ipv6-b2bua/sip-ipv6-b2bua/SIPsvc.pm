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
#   LogHTMLOutput:
#   OutputSIPFrame,LogSIPPktInfo: 
#   LogSIPPktInfo:
#   END:HTML
#   LogConfigInfo:HTML

#=================================
# 
#=================================

# 
%DefPseudoNodeDB = ();

# 
%DefRuleSetDB = ();

# 
%DefVarDB = ();

# 
%SYNTAXRuleResult;

# SOCKID/TLSSESSION 
%SOCKidINDEX;
%TLSsessionINDEX;

#=================================
# TAHI
#=================================
@SIP_TAHI_RESULT;

#=================================
# SIP
#=================================
@SIPPktInfo = ();
$SIPPktInfoLast;

#=================================
# RTP
#=================================
@RTPPktInfo = ();
$RTPPktInfoLast;

#=================================
# DNS
#=================================
@DNSPktInfo = ();

#=================================
# ICMP
#=================================
@ICMPPktInfo = ();

#=================================
# ND
#=================================
@NDPktInfo = ();

#=================================
# Timer
#=================================
@TIMERInfo = ();

#=================================
# DNS AAAA 
#=================================
sub FindAAAA {
    my($fqdn)=@_;
    my($aaaa);

    if(substr($fqdn,length($fqdn)-1,1) ne '.'){$fqdn = $fqdn . '.';}
    grep{($_->{FQDN} eq $fqdn)?$aaaa=($SIP_PL_IP eq 4 ? $_->{'IPV4'} : $_->{'IPV6'}):''} @SIP_AAAA_RECORD;
    if($aaaa){
	MsgPrint('SEQ',"DNS AAAA[%s] record found for FQDN[%s]\n",$aaaa,$fqdn);
    }
    else{
	MsgPrint('WAR',"DNS AAAA record not found for FQDN[%s]\n",$fqdn);
    }
    return $aaaa;
}
sub FindAAAARecord {
    my($fqdn)=@_;
    my($i);

    if(substr($fqdn,length($fqdn)-1,1) ne '.'){$fqdn = $fqdn . '.';}
    for($i=0;$i<=$#SIP_AAAA_RECORD;$i++){
	if( $SIP_AAAA_RECORD[$i]{'FQDN'} eq $fqdn ){return $SIP_AAAA_RECORD[$i];}
    }
    return '';
}
# 
#   xxx.yyy.zzz  =~  XXX.xxx.yyy.zzz(DB) 
#   xxx.yyy.zzz  eq  xxx.yyy.zzz(DB) 
sub FindSRVRecord {
    my($fqdn)=@_;
    my($i);

    # 
    if(substr($fqdn,length($fqdn)-1,1) ne '.'){$fqdn = $fqdn . '.';}

    # xxx.yyy.zzz  =~  XXX.xxx.yyy.zzz(DB) 
    for($i=0;$i<=$#SIP_AAAA_RECORD;$i++){
	if( $SIP_AAAA_RECORD[$i]{'FQDN'} =~ /^[^\.]+\.$fqdn$/ ){return $SIP_AAAA_RECORD[$i];}
    }
    # 
    for($i=0;$i<=$#SIP_AAAA_RECORD;$i++){
	if( $SIP_AAAA_RECORD[$i]{'FQDN'} eq $fqdn ){return $SIP_AAAA_RECORD[$i];}
    }
    return '';
}

sub AddAAAA {
    my($fqdn,$addr)=@_;
    my($i,$type);

    $type=($SIP_PL_IP eq 4 ? 'IPV4' : 'IPV6');
    if(substr($fqdn,length($fqdn)-1,1) ne '.'){$fqdn = $fqdn . '.';}
    for($i=0;$i<=$#SIP_AAAA_RECORD;$i++){
	if( $SIP_AAAA_RECORD[$i]{FQDN} eq $fqdn ){
	    $SIP_AAAA_RECORD[$i]{$type} = $addr;
	    MsgPrint('SEQ',"DNS record FQDN[%s] AAAA[%s] registed\n",$fqdn,$addr);
	    return;
	}
    }
    $SIP_AAAA_RECORD[$i]{FQDN}=$fqdn;
    $SIP_AAAA_RECORD[$i]{$type}=$addr;
    MsgPrint('SEQ',"DNS record FQDN[%s] AAAA[%s] added\n",$fqdn,$addr);
}

#============================================
# 
#============================================

# 
sub RegistRuleSet {
    my($rules)=@_;
    my($i);

    # 

#    MsgPrint('RULE', "RegistRuleSet type:[%s]\n",ref($rules));
    if(ref($rules) eq 'ARRAY'){
	for($i=0;$i<=$#$rules;$i++){
	    if( ref($$rules[$i]) eq 'HASH' ){
		MsgPrint('RULE2',"Regist RuleSet TY:[%s] ID:[%s]\n",$$rules[$i]{'TY:'},$$rules[$i]{'ID:'});
		if($DefRuleSetDB{$$rules[$i]{'ID:'}}){
		    if($DefRuleSetDB{$$rules[$i]{'ID:'}}->{'SP:'} eq $$rules[$i]->{'SP:'}){
			MsgPrint('WAR',"Regist RuleSet TY:[%s] ID:[%s] SP:[%s] is redefined\n",
				 $$rules[$i]{'TY:'},$$rules[$i]{'ID:'},$$rules[$i]{'SP:'});
		    }
		    else{
			MsgPrint('RULE',"Regist RuleSet TY:[%s] ID:[%s] SP:[%s] is overrided\n",
				 $$rules[$i]{'TY:'},$$rules[$i]{'ID:'},$$rules[$i]{'SP:'});
		    }
		}
		$DefRuleSetDB{$$rules[$i]{'ID:'}}=$$rules[$i];
		if($$rules[$i]{'TY:'} eq 'RULESET'){
		    RegistRuleSet($$rules[$i]{'RR:'});
		}
	    }
	}
    }
    elsif(ref($rules) eq 'HASH' && $$rules{'TY:'}){
	MsgPrint('RULE2',"Regist RuleSet TY:[%s] ID:[%s]\n",$$rules{'TY:'},$$rules{'ID:'});
	$DefRuleSetDB{$$rules{'ID:'}}=$rules;
	if($$rules{'TY:'} eq 'RULESET'){
	    RegistRuleSet($$rules{'RR:'});
	}
    }
    else{
	MsgPrint('ERR',"Regist RuleSet invalid parameter\n");
    }
}

# 
sub RuleStatistics {
    my($decode,$encode,$syntax,$noninpliment,$decodeNoRef,$encodeNoRef,$syntaxNoRef,$timerNoRef,
       $ruleset,$i,$val,$key,$subval,$timer,$timingset,$rr,@noRef);

    # 
    while(($key,$val)=each(%DefRuleSetDB)){
	$val->{'RF:'}=0;
    }

    # 
    while(($key,$val)=each(%DefRuleSetDB)){
	if($val->{'TY:'} eq 'RULESET' || $val->{'TY:'} eq 'TIMINGSET'){
	    $rr=$val->{'RR:'};
	    for($i=0;$i<=$#$rr;$i++){
		if(!$DefRuleSetDB{$rr->[$i]}){
		    MsgPrint('WAR',"Ruleset(%s) refer non-exist rule(%s)\n",$val->{'ID:'},$rr->[$i]);
		}
		else{
		    $DefRuleSetDB{$rr->[$i]}->{'RF:'}++;
		}
	    }
	}
	if($val->{'TY:'} eq 'TIMINGSET'){
	    $rr=$val->{'TM:'};
	    for($i=0;$i<=$#$rr;$i++){
		if(!$DefRuleSetDB{$rr->[$i]}){
		    MsgPrint('WAR',"Ruleset(%s) refer non-exist rule(%s)\n",$val->{'ID:'},$rr->[$i]);
		}
		else{
		    $DefRuleSetDB{$rr->[$i]}->{'RF:'}++;
		}
	    }
	}
    }

    # 
    while(($key,$val)=each(%DefRuleSetDB)){
	if($val->{'TY:'} eq 'DECODE'){
	    $decode++;
	    if(!$val->{'RF:'}){$decodeNoRef++;push(@noRef,$val->{'ID:'});}
	}
	if($val->{'TY:'} eq 'ENCODE'){
	    $encode++;
	    if(!$val->{'RF:'}){$encodeNoRef++;push(@noRef,$val->{'ID:'});}
	}
	if($val->{'TY:'} eq 'SYNTAX'){
	    $syntax++;
	    if(!$val->{'EX:'}){$noninpliment++;}
	    if(!$val->{'RF:'}){$syntaxNoRef++;push(@noRef,$val->{'ID:'});}
	}
	if($val->{'TY:'} eq 'RULESET'){
	    $ruleset++;
	}
	if($val->{'TY:'} eq 'TIMER'){
	    $timer++;
	    if(!$val->{'RF:'}){$timerNoRef++;push(@noRef,$val->{'ID:'});}
	}
	if($val->{'TY:'} eq 'TIMINGSET'){
	    $timingset++;
	}
    }
    
    MsgPrint('RULE',"Registed Decode[%s/%s] Encode[%s/%s] Syntax[%s/%s](Noninpliment:%s) RuleSet[%s] Timer[%s/%s] TimingSet[%s] total[%s]\n",
	     $decode-$decodeNoRef,$decode,$encode-$encodeNoRef,$encode,$syntax-$syntaxNoRef,$syntax,
	     $noninpliment,$ruleset,$timer-$timerNoRef,$timer,$timingset,
	     $decode+$encode+$syntax+$ruleset+$timer+$timingset);

    if($CNT_CONF{'RULE-INFO-DETAIL'}){
	print("########  Non refference rules  ########\n");
	PrintVal(\@noRef);
	print("########################################\n");
    }
    return \@noRef;
}

sub DumpDefRuleSetDB {
    my($i,$val,$key,$subval);
    while(($key,$val)=each(%DefRuleSetDB)){
	printf "DUMP: RuleSet TY:[%s] ID:[$key] \n",$val->{'TY:'};
	if($val->{'TY:'} eq 'DECODE'){
	    $subval=$val->{'VA:'};
	    for($i=0;$i<=$#$subval;$i+=2){
		printf "       VA:[%s][%s][%s] \n",$i/2,$$subval[$i],$$subval[$i+1];
	    }
	}
    }
}

# 
sub DumpBindVars {
    my($val,$key,$params,$i,$j);
    print("-----DumpBindVars----------\n");
    while(($key,$val)=each(%DefVarDB)){
	if(ref($val) eq 'ARRAY'){
	    for($i=0;$i<=$#$val;$i++){
		if(ref($val->[$i]) eq 'ARRAY'){
		    $params=$val->[$i];
		    printf 'BIND: var $%s[%s] = array:',$key,$i;
		    for($j=0;$j<=$#$params;$j++){
			printf "[%s] ",$params->[$j];
		    }
		    printf("\n");
		}
		else{
		    printf('BIND: var $%s[%s] = [%s]%s',$key,$i,$val->[$i],"\n");
		}
	    }
	}
	else{
	    printf('BIND: var $%s = [%s]%s',$key,$val,"\n");
	}
    }
}

#
sub DumpResults {
    my ($result)=@_;
    my($item);
    foreach $item (@$result){
	printf("DUMP: Result rule ID[%s] result[%s]\n",$item->{'ID:'},$item->{'RE:'});
    }
}

sub GetKeyVal {
    my($data,$id)=@_;
    my($key,$val,$i);
    if(ref($data) eq 'ARRAY'){
	for($i=0;$i<=$#$data;$i++){
	    while(($key,$val)=each(%{$data->[$i]})){
		if($key eq $id){return $val;}
	    }
	}
    }
    else{
	while(($key,$val)=each(%$data)){
	    if($key eq $id){return $val;}
	}
    }
    return '';
}

# 
sub FindRuleFromID ($){
    my $ruleid=shift;
    if(ref($ruleid) eq 'HASH'){
	return $ruleid->{'ID:'},$ruleid;
    }
    else{
	return $ruleid,$DefRuleSetDB{$ruleid};
    }
}

# 
#   
sub DeleteRuleFromAllRuleSet {
    my($matchRuleName)=@_;
    my($val,$key,$rules,$tmp);
    while(($key,$val)=each(%DefRuleSetDB)){
	if($val->{'TY:'} eq 'RULESET'){
	    $rules=$val->{'RR:'};
	    $tmp=();
	    @$tmp = grep{($_ =~ /$matchRuleName/)?
			     (MsgPrint('RULE',"Delete rule[%s] in RuleSet[%s]\n",$_,$val->{'ID:'}) eq 'T'):'T'} @$rules;
	    if($#$tmp ne $#$rules){
		MsgPrint('RULE',"   RuleSet[%s] delete %d rules\n",$val->{'ID:'}, $#$rules-$#$tmp);
	    }
	    $val->{'RR:'} = $tmp;
	}
	if($val->{'TY:'} eq 'TIMINGSET'){
	    $rules=$val->{'RR:'};
	    $tmp=();
	    @$tmp = grep{($_ =~ /$matchRuleName/)?
			     (MsgPrint('RULE',"Delete rule[%s] in TimingSet[%s]\n",$_,$val->{'ID:'}) eq 'T'):'T'} @$rules;
	    if($#$tmp ne $#$rules){
		MsgPrint('RULE',"   TimingSet[%s] delete %d rules\n",$val->{'ID:'}, $#$rules-$#$tmp);
	    }
	    $val->{'RR:'} = $tmp;
	}
    }
}

#============================================
# 
#============================================
sub IsRule ($) {
    my($rule)=@_;
    return (ref($rule) eq 'HASH') && $rule->{'TY:'} && $rule->{'ID:'};
}

sub IsMemberInArray ($$) {
    my($val,$items)=@_;
    foreach (@$items){if($_ eq $val){ return 'T';}}
    return '';
}

sub IsArraySameMember ($$) {
    my($val1,$val2)=@_;
    my($i,$j);
    if($#$val1 ne $#$val2){return '';}
    for($i=0;$i<=$#$val1;$i++){
	for($j=0;$j<=$#$val2;$j++){
	    if($val1->[$i] eq $val2->[$j]){goto NEXT;}
	    if(ref($val1->[$i]) eq 'ARRAY' && ref($val2->[$j]) eq 'ARRAY'){
		if(IsArraySameMember($val1->[$i],$val2->[$j])){goto NEXT;}
	    }
	}
	return '';
      NEXT:
	next;
    }
    return 'T';
}
sub IsArrayEqual ($$) {
    my($val1,$val2)=@_;
    my($i);
    if($#$val1 ne $#$val2){return '';}
    for($i=0;$i<=$#$val1;$i++){
	if(ref($val1->[$i]) eq 'ARRAY' && ref($val2->[$i]) eq 'ARRAY'){
	    if(!IsArrayEqual($val1->[$i],$val2->[$i])){return '';}
	}
	elsif($val1->[$i] ne $val2->[$i]){return '';}
    }
    return 'T';
}
sub IsArraySameValue ($$) {
    my($val1,$val2)=@_;
    my($i);
    for($i=0;$i<=$#$val1;$i++){
	if($val1->[$i] ne $val2 &&
	   !(ref($val1->[$i]) eq 'ARRAY' && ref($val2) eq 'ARRAY' && IsArrayEqual($val1->[$i],$val2))){return '';}
    }
    return 'T';
}

# 
sub IsFunction {
    my $funcname = shift;
    return defined(&$funcname)
}

# 
#   
sub EvalExpression {
    my($expr);
    $expr=shift @_;
    my($rule,$pktinfo,$context)=@_;
    my($val,$count);

    # 
    $context->{'RESULT-DETAIL:'}='';

    # 
    if(ref($expr) eq 'CODE'){
	$val=$expr->(@_);
    }
    # 
    elsif(ref($expr) eq 'SCALAR'){
	$val=eval $$expr;
	if($@){
	    MsgPrint('ERR',"Eval exp[%s] failed[%s]\n",$$expr,$@);
	}
	else{
	    MsgPrint('RULE',"Eval exp[%s]=>[%s]\n",$$expr,$val);
	}
    }
    # 
    elsif(ref($expr) eq 'REF'){
	($val,$count)=GetSIPField($$$expr,$pktinfo);
	$val=(ref($val) eq 'ARRAY')?$val->[0]:$val;
	if(!ref($val)){ $val =~ s/^\s*//; }
	$context->{'RESULT-DETAIL:'}={'TY:'=>'FV','ARG1:'=>$val};
    }
    # 
    elsif(ref($expr) eq 'HASH'){
	$val=EvalRule($expr);
    }
    # 
    else{
	$rule = FindRuleFromID($expr);
	$val = $rule ? EvalRule($rule) : $expr;
    }
    return $val;
}

# 
sub EvalDecodeRule {
    my($rule,$pktinfo,$context)=@_;
    my($i,$bindlist,$varName,$countName,$result,$count,$vals,$val);

    # 
    $bindlist=$rule->{'VA:'};
#    $countName=$rule->{'GN:'};

    # 
    for($i=0;$i<=$#$bindlist;$i+=2){
	$varName=$$bindlist[$i+1];

	# 
	if(!ref($$bindlist[$i])){
	    ($vals,$count,$val)=GetSIPField($$bindlist[$i],$pktinfo);
	}
	else {
	    $vals=EvalExpression($$bindlist[$i],@_);
	    $count=(ref($vals) eq 'ARRAY')?$#$vals:1;
	}

	# 
	if(!$rule->{'MD:'}){
	    # 
	    if($count eq 1 && ref($vals) eq 'ARRAY'){
		$$varName=$vals->[0];
	    }
	    elsif($count eq 0){
		$$varName='';
	    }
	    else{
		$$varName=$vals;
	    }
	}
	# 
	elsif($rule->{'MD:'} eq 'append'){
	    if(ref($vals) eq 'ARRAY'){
		push(@$$varName,@$vals);
	    }
	    else{
		push(@$$varName,$vals);
	    }
	}
	# 
	elsif($rule->{'MD:'} eq 'first'){
	    if(ref($vals) eq 'ARRAY'){
		$$varName=$vals->[0];
	    }
	    elsif($count eq 0){
		$$varName='';
	    }
	    else{
		$$varName=$vals;
	    }
	}
	elsif($rule->{'MD:'} eq 'array'){
            @$varName=@$vals;
	}
	elsif($rule->{'MD:'} eq 'set'){
	    eval($varName . '=$vals');
	}

	# 
#	if($countName){$$countName=$count;}

	if(0<$count){$result='match';}

	# 
	$DefVarDB{$varName}=$$varName;
#	if($countName){$DefVarDB{$countName}=$$countName;}

	# 
        # AddContextVar($context,$varName,$$varName);
    }

SKIP:
    # 
    if($rule->{'EX:'}){
	$result = EvalExpression($rule->{'EX:'},$rule,$pktinfo,$result);
    }
    return $result;
}

# 
#   
#   
sub EvalEncodeRule {
    my($rule,$pktinfo,$context)=@_;
    my($msg,@args,$ruleargs,$frm,$val,$count,$i,$result);

    # 
    if($rule->{'PR:'} && ref($rule->{'PR:'})){
	$result = EvalExpression($rule->{'PR:'},$rule,$pktinfo,$context);
	if($result eq ''){
	    MsgPrint('RULE', "Eval EncodeRule(%s) skiped for Precondition is FALSE\n",$rule->{'ID:'});
	    return '';
	}
    }

    # 
    $ruleargs = $rule->{'AR:'};
    for($i=0;$i<=$#$ruleargs;$i++){
	$val=EvalExpression($ruleargs->[$i],$rule,$pktinfo,$context);
	push(@args,$val);
    }
    
    # 
    if( $frm=$rule->{'FM:'} ){
	if(ref($frm) eq 'SCALAR'){
	    $frm = eval( $$frm );
	    if($@){MsgPrint('ERR',"Eval SCALER failed[%s]\n",$@);}
	}

	# 
	$msg=sprintf($frm,@args);
	$context->{'ENCODE-SIZE:'}=$context->{'ENCODE-SIZE:'}+length($msg)+2; # CRLF
    }
    # 
    if($rule->{'EX:'}){
	$context->{'ENCODE-MSG:'}=$msg;
	$msg = EvalExpression($rule->{'EX:'},$rule,$pktinfo,$context);
    }

    # 
    return $msg;
}

# 
sub EvalSyntaxRule {
    my($rule,$pktinfo,$context)=@_;
    my($result,$startTime,$diff);

    # 
    if($context->{'EVAL-TIME'} && $rule->{'ET:'} ne $context->{'EVAL-TIME'}){return 1;}

    if($SIM_Support_HiRes){$startTime=[Time::HiRes::gettimeofday()];}

    # 
    if($rule->{'PR:'} && ref($rule->{'PR:'})){
	$result = EvalExpression($rule->{'PR:'},$rule,$pktinfo,$context);
	if($result eq ''){
	    return 'SKIP';
	}
    }

    # 
    if($rule->{'EX:'}){
	$result = EvalExpression($rule->{'EX:'},$rule,$pktinfo,$context);
    }

    # TAHI 
    $result=MakeTAHIResultMessage($result,$rule,$pktinfo,$context);

    # 
    $result = ($result?$result:($rule->{'RT:'} eq 'warning'?'WARNING':''));

    # 
    if(!($context->{'EVAL-TIME'} eq 'REAL' && $rule->{'ET:'} eq 'REAL')){
	if($SIM_Support_HiRes){$diff=Time::HiRes::tv_interval($startTime, [Time::HiRes::gettimeofday()])}
	AccountSyntaxRuleResult($rule->{'ID:'},$result,$diff);
    }
    return $result;
}

#=================================
# 
#=================================
@SIPJudgmentContext = ();
$SIPJudgmentRealMode;

sub SIPAddJudgmentContext {
    my($pktinfo,$rule,$mode,$callContext)=@_;
    my($context);

    $context={'PKT'=>$pktinfo,'RULE'=>$rule,'MODE'=>$mode,'CAPTURE'=>$#SIPPktInfo,'CALL'=>$callContext};
    push(@SIPJudgmentContext,$context);
}

# 
sub SIPReviveJudgment {
    my(@pktInfo,$context,$i,$pktno);

    if(!$SIPJudgmentRealMode){return;}

    # 
    @pktInfo=@SIPPktInfo;
    $SIPJudgmentRealMode='';
    $pktno=0;
    # 
    NDBackupPktInfo();

    foreach $context (@SIPJudgmentContext){
	
	# 
	for $i ($pktno..$context->{'CAPTURE'}){
	    if($pktInfo[$i]){LogHTML($pktInfo[$i]);}
	}
	$pktno=$context->{'CAPTURE'}+1;
	
	# 
	@SIPPktInfo=();
	for $i (0..$context->{'CAPTURE'}){push(@SIPPktInfo,$pktInfo[$i]);}
	$SIPPktInfoLast=$context->{'PKT'};

	# 
	SIPLoadSyntaxRuleEvalContext($context->{'CALL'});

	# 
	SIP_Judgment($context->{'RULE'},$context->{'MODE'},$context->{'PKT'});
    }
    # 
    for $i ($pktno..$#pktInfo){
	if($pktInfo[$i]){LogHTML($pktInfo[$i]);}
    }

    @SIPPktInfo=@pktInfo;
}

# 
sub SIPStoreSyntaxRuleEvalContext {
    my($callTbl)=@_;
    my($key,$val,%dupCallTbl,%context,$node,$other);

    # 
    if(!$SEQCurrentActNode){
	# 
	return SIPStoreContextValue();
    }
    # 
    else{
	# 
	$node=$SEQCurrentActNode;
	$other=NDGetOtherNode($node);
	$context{'ACTIVE'}=
	{'ND'=>$node->{'ID'}, 'ST'=>$node->{'ST'}, 'PKTS'=>$#{$node->{'PKTS'}},
	 'LastRecvPkt'=>$node->{'LastRecvPkt'}, 'LastSendPkt'=>$node->{'LastSendPkt'},
	 'CALL'=>SIPStoreContextValue($node->{'CALL'})};
	$context{'DEACTIVE'}=
	{'ND'=>$other->{'ID'}, 'ST'=>$other->{'ST'}, 'PKTS'=>$#{$other->{'PKTS'}},
	 'LastRecvPkt'=>$other->{'LastRecvPkt'}, 'LastSendPkt'=>$other->{'LastSendPkt'},
	 'CALL'=>SIPStoreContextValue($other->{'CALL'})};
	return \%context;
    }
}

# 
sub SIPLoadSyntaxRuleEvalContext {
    my($context)=@_;
    my($i,$node);
    # 
    if(!$SEQCurrentActNode){
	# 
	SIPLoadContextValue($context);
    }
    # 
    else{
	# 
	$node=$SIPNodeTbl{$context->{'ACTIVE'}->{'ND'}};
	$node->{'ST'}=$context->{'ACTIVE'}->{'ST'};
	$node->{'LastRecvPkt'}=$context->{'ACTIVE'}->{'LastRecvPkt'};
	$node->{'LastSendPkt'}=$context->{'ACTIVE'}->{'LastSendPkt'};
	# 
	$node->{'PKTS'}=[];
	for $i (0..$context->{'ACTIVE'}->{'PKTS'}){
	    push(@{$node->{'PKTS'}},$node->{'PKTS.BAK'}->[$i]);
	}
	# 
	$node->{'CALL'}=$context->{'ACTIVE'}->{'CALL'};
	$SEQCurrentActNode=$node;

	# 
	$node=$SIPNodeTbl{$context->{'DEACTIVE'}->{'ND'}};
	$node->{'ST'}=$context->{'DEACTIVE'}->{'ST'};
	$node->{'LastRecvPkt'}=$context->{'DEACTIVE'}->{'LastRecvPkt'};
	$node->{'LastSendPkt'}=$context->{'DEACTIVE'}->{'LastSendPkt'};
	# 
	$node->{'PKTS'}=[];
	for $i (0..$context->{'DEACTIVE'}->{'PKTS'}){
	    push(@{$node->{'PKTS'}},$node->{'PKTS.BAK'}->[$i]);
	}
	# 
	$node->{'CALL'}=$context->{'DEACTIVE'}->{'CALL'};

	# 
	SIPLoadNodeCallTbl($SEQCurrentActNode->{'CALL'});
    }
}


# 
sub EvalMsgRule {
    my($rule,$pktinfo,$context)=@_;
    my($msg);

    $msg=EvalMsg(@_);

    # TAHI
    if($rule->{'MD:'} eq 'OK'){
	LOG_Msg($msg);
    }
    elsif($rule->{'MD:'} eq 'NG'){
	LOG_Err($msg);
    }
    else{
	LOG_Warn($msg);
    }

    # 
    return $rule->{'RE:'};
}

# 
sub EvalMsg {
    my($rule,$pktinfo,$context)=@_;
    my($msg,@args,$ruleargs,$i);

    # 
    $ruleargs = $rule->{'AR:'};
    for($i=0;$i<=$#$ruleargs;$i++){
	push(@args,EvalExpression($ruleargs->[$i],$rule,$pktinfo,\@args));
    }
    
    # 
    $msg=sprintf($rule->{'FM:'},@args);

    # 
    return $msg;
}

# 
sub EvalRuleSet {
    my($rule,$pktinfo,$context)=@_;
    my(@result,$i,$ruleObj,$ruleID,$rules,$delrules,$ret,$od,$level,$msg,$color,$result);

    # 
    if($rule->{'PR:'} && ref($rule->{'PR:'})){
	$result = EvalExpression($rule->{'PR:'},$rule,$pktinfo,$context);
	if($result eq ''){
	    MsgPrint('RULE', "Eval RuleSet(%s) skiped for Precondition is FALSE\n",$rule->{'ID:'});
	    return;
	}
    }

    # 
    $delrules=$context->{'DEL-RULE:'};
    $level=$context->{'NEST-LEVEL:'};
    if($level eq ''){$level=1;}

    # 
    if($rule->{'DL:'}){
	if($delrules){push(@$delrules,@{$rule->{'DL:'}})}
	else{$delrules=$rule->{'DL:'};}
    }

    # 
    if(IsLogLevel('INF')){
	$color=substr($rule->{'ID:'},0,1);$color=($color eq 'D')?'8FBC8F':(($color eq 'E')?'9932CC':'FF8C00');
	$msg=sprintf("<B><font color=\"#%s\"> %${level}.${level}s-- %s %${level}.${level}s-- </font></B><br>",
		     $color,'<<<<<<<<<<<<<<<<<<<<',$rule->{'ID:'},'<<<<<<<<<<<<<<<<<<<<');
	LogHTML($msg);
#	LogHTML('<B><font color="#FF8C00"> ----- ' . $rule->{'ID:'} . ' ----- </font></B><br>');
    }
    # 
    foreach $od ('FIRST','','LAST') {
	# 
	if($rule->{'RR:'}){
	    $rules=$rule->{'RR:'};
	    for($i=0;$i<=$#$rules;$i++){
		# 
		($ruleID,$ruleObj)=FindRuleFromID($rules->[$i]);
		# 
		if($ruleObj && $ruleObj->{'OD:'} eq $od && (!$delrules || !IsMemberInArray($ruleID,$delrules))){
		    # 
		    $context->{'RESULT:'}=\@result;
		    $context->{'DEL-RULE:'}=$delrules;
		    $context->{'NEST-LEVEL:'}=$level+1;
		    $ret=EvalRule($ruleObj,$pktinfo,$context);
#		    $ret=EvalRule($ruleObj,$pktinfo,{'RESULT:'=>\@result,'DEL-RULE:'=>$delrules,'NEST-LEVEL:'=>$level+1});
		    # 
		    push(@result,{'ID:'=>$ruleID,'RE:'=>$ret});
		    # 
		    if($rule->{'MD:'} eq 'AND' && !$ret){
			MsgPrint('WAR', "Eval Ruleset in AND mode, rule ID[%s] is NG, so SKIP\n",$ruleID);
			goto SKIP;
		    }
		}
		elsif(!$ruleObj){
		    MsgPrint('ERR', "Rule ID[%s](%s) is unknown rule\n",$ruleID,$rule);
		}
	    }
	}
	
	# 
	if($rule->{'AD:'}){
	    $rules=$rule->{'AD:'};
	    for($i=0;$i<=$#$rules;$i++){
		# 
		($ruleID,$ruleObj)=FindRuleFromID($rules->[$i]);
		# 
		if($ruleObj && $ruleObj->{'OD:'} eq $od && (!$delrules || !IsMemberInArray($ruleID,$delrules))){
		    # 
		    $context->{'RESULT:'}=\@result;
		    $context->{'DEL-RULE:'}=$delrules;
		    $ret=EvalRule($ruleObj,$pktinfo,$context);
#		    $ret=EvalRule($ruleObj,$pktinfo,{'RESULT:'=>\@result,'DEL-RULE:'=>$delrules});
		    # 
		    push(@result,{'ID:'=>$ruleID,'RE:'=>$ret});
		    # 
		    if($rule->{'MD:'} eq 'AND' && !$ret){
			MsgPrint('RULE', "Eval Ruleset in AND mode, rule ID[%s] is NG, so SKIP\n",$ruleID);
			goto SKIP;
		    }
		}
		elsif(!$ruleObj){
		    MsgPrint('ERR', "Rule ID[%s] is unknown rule\n",$ruleID);
		}
	    }
	}
    }
SKIP:
    # 
    if($rule->{'EX:'}){
	$ret = EvalExpression($rule->{'EX:'},$rule,$pktinfo,{'RESULT:'=>\@result,'DEL-RULE:'=>$delrules});
	push(@result,{'EX:'=>$ret});
    }

    if(IsLogLevel('INF')){
	$msg=sprintf("<B><font color=\"#%s\"> --%${level}.${level}s %s --%${level}.${level}s </font></B><br>",
		     $color,'>>>>>>>>>>>>>>>>>>>>',$rule->{'ID:'},'>>>>>>>>>>>>>>>>>>>>');
	LogHTML($msg);
    }
    # 
    return \@result;
}

# 
sub EvalTimerRule {
    my($rule,$pktinfo,$context)=@_;
    my($result);

    # 
    $result=EvalExpression($rule->{'PR:'},$rule,$pktinfo,$context);
    if(!$result){return ;}
    # 
    SetTimerRuleVariable($rule->{'TM:'},$rule->{'CT:'},$PKT_INDEX);
    # 
    EvalExpression($rule->{'EX:'},$rule,$pktinfo);
    # 
    SaveTimerRuleVariable($rule->{'TM:'},$pktinfo);
}

sub InitTimerRuleVariable {
    my($name)=@_;
    my($varName);

    # 
    $varName= $name . "_TIMER"; $$varName=''; $DefVarDB{$varName}=$$varName;
    $varName= $name . "_START"; $$varName=''; $DefVarDB{$varName}=$$varName;
    $varName= $name . "_LAST";  $$varName=''; $DefVarDB{$varName}=$$varName;
    $varName= $name . "_COUNT"; $$varName=0;  $DefVarDB{$varName}=$$varName;
    $varName= $name . "_DIFF";  $$varName=''; $DefVarDB{$varName}=$$varName;
    $varName= $name . "_BEFORE";$$varName=''; $DefVarDB{$varName}=$$varName;
}

sub SetTimerRuleVariable {
    my($name,,$countMode,$index)=@_;
    my($varName,$tmp,$pktinfo);

    if(!ref($index)){$pktinfo=@SIPPktInfo[$index];}
    elsif(ref($index) eq 'HASH'){$pktinfo=$index;}
    else{return '';}

    # 
    $varName= $name . "_START";
    if(!$$varName){$$varName = $pktinfo->{timestamp};}

    # 
    $varName= $name . "_LAST";
    $$varName = $pktinfo->{timestamp};

    # 
    if($countMode ne 'NON-PROCEED'){
	$varName= $name . "_COUNT";
	$$varName = $$varName + 1;
    }

    if($$varName eq 1){
	# 
	$varName= $name . "_DIFF";
	$$varName=0;
	$varName= $name . "_BEFORE";
	$$varName=$index;
    }
    else{
	# 2
	$varName= $name . "_BEFORE";
	$tmp=$pktinfo->{timestamp}-@SIPPktInfo[$$varName]->{timestamp};
	$varName= $name . "_DIFF";
	$$varName=$tmp;
	$varName= $name . "_BEFORE";
	$$varName=$index;
    }
}
sub SaveTimerRuleVariable {
    my($name,$index)=@_;
    my($pktinfo,$varName);

    if(!ref($index)){$pktinfo=@SIPPktInfo[$index];}
    elsif(ref($index) eq 'HASH'){$pktinfo=$index;}
    else{return '';}
    $varName= $name . "_TIMER"; $pktinfo->{$varName}=$$varName;
    $varName= $name . "_START"; $pktinfo->{$varName}=$$varName;
    $varName= $name . "_LAST"; $pktinfo->{$varName}=$$varName;
    $varName= $name . "_COUNT"; $pktinfo->{$varName}=$$varName;
    $varName= $name . "_DIFF";  $pktinfo->{$varName}=$$varName;
    $varName= $name . "_BEFORE";$pktinfo->{$varName}=$$varName;
}

# 
sub EvalTimingSet {
    my($rule,$pktinfo,$context)=@_;
    my($timerRule,$syntaxRule,@result,$i,$j,$ruleID,$ruleObj,$msg,$ret,$errCount);

    $timerRule   = $rule->{'TM:'};
    $syntaxRule = $rule->{'RR:'};

    # 
    for($j=0;$j<=$#$timerRule;$j++){
	# 
	($ruleID,$ruleObj)=FindRuleFromID($timerRule->[$j]);
	if($ruleObj){
	    # 
	    InitTimerRuleVariable($ruleObj->{'TM:'});
	}
	else{
	    MsgPrint('ERR', "Rule ID[%s](%s) is unknown rule\n",$ruleID,$rule);
	}
    }

    # SIP
    SIPPktInfoParse();

    # 
    for($i=0;$i<=$#SIPPktInfo;$i++){
	
	# 
	$PKT_TIMESTAMP=@SIPPktInfo[$i]->{timestamp};
	$PKT_INDEX=$i;

	# 
	for($j=0;$j<=$#$timerRule;$j++){
	    # 
	    $ret=EvalRule($timerRule->[$j],@SIPPktInfo[$i]);
	}

	# 
	for($j=0;$j<=$#$syntaxRule;$j++){

	    # 
	    ($ruleID,$ruleObj)=FindRuleFromID($syntaxRule->[$j]);
	    if($ruleObj){
		# 
		if($ruleObj->{'OD:'} eq 'LAST'){next;}
		# 
		$ret=EvalRule($ruleObj,@SIPPktInfo[$i]);
		# 
		push(@result,{'RE:' => $ret,'RR:' => $ruleID,'PK:' => $i});
	    }
	    else{
		MsgPrint('ERR', "Invalid Rule ID[%s](%s) is unknown rule\n",$ruleID,$rule);
	    }
	}
    }

    # 
    for($j=0;$j<=$#$syntaxRule;$j++){
	
	# 
	($ruleID,$ruleObj)=FindRuleFromID($syntaxRule->[$j]);
	if($ruleObj){
	    # 
	    if($ruleObj->{'OD:'} ne 'LAST'){next;}
	    # 
	    $ret=EvalRule($syntaxRule->[$j],'');
	    # 
	    push(@result,{'RE:' => $ret,'RR:' => $ruleID,'PK:' => $i});
	}
    }

    return \@result;
}

# 
sub EvalRule {
    my($ruleid,$pktinfo,$context)=@_;
    my($rule,$val,$i,@stack,%tmpContext);

    # 
    if($context eq ''){$context=\%tmpContext;}

    # 
    if(!ref($ruleid)){
	($rule,$rule) = FindRuleFromID($ruleid);
	if(!$rule){
	    @stack=caller(1);
	    MsgPrint('ERR',"Rule ID:[%s] done not exist in Rule DB called[%s]\n",$ruleid,$stack[3]);
	    return '';
	}
    }
    elsif( (ref($ruleid) eq 'HASH') && $ruleid->{'TY:'} ){
	$rule = $ruleid;
    }

    elsif( ref($ruleid) eq 'ARRAY' ){
	for($i=0; $i<=$#$ruleid; $i++ ){
	    $val=EvalRule($ruleid->[$i],$pktinfo,$context);
	}
	return $val;
    }

    # 
    if(   $rule->{'TY:'} eq 'DECODE'){
	$val=EvalDecodeRule($rule,$pktinfo,$context);
	MsgPrint('RULE', "Eval DecodeRule(%s) result[%s]\n",$rule->{'ID:'},$val);
    }
    elsif($rule->{'TY:'} eq 'ENCODE'){
	$val=EvalEncodeRule($rule,$pktinfo,$context);
	MsgPrint('RULE', "Eval EncodeRule(%s) result[%s]\n",$rule->{'ID:'},$val);
    }
    elsif($rule->{'TY:'} eq 'SYNTAX'){
	$val=EvalSyntaxRule($rule,$pktinfo,$context);
	MsgPrint('RULE', "Eval SyntaxRule(%s) result[%s]\n",$rule->{'ID:'},$val);
    }
    elsif($rule->{'TY:'} eq 'RULESET'){
	MsgPrint('RULE', "Eval Ruleset(%s)\n",$rule->{'ID:'});
	$val=EvalRuleSet($rule,$pktinfo,$context);
    }
    elsif($rule->{'TY:'} eq 'TIMER'){
	$val=EvalTimerRule($rule,$pktinfo,$context);
    }
    elsif($rule->{'TY:'} eq 'TIMINGSET'){
	$val=EvalTimingSet($rule,$pktinfo,$context);
    }
    elsif($rule->{'TY:'} eq 'MSG'){
	$val=EvalMsg($rule,$pktinfo,$context);
    }
    else{
	@stack=caller(1);
	MsgPrint('ERR', "Can't eval, unknown rule called[%s]\n",$stack[3]);
    }
    return $val;
}

# 
sub RuleModify {
    my($rule,$addrule,$delrule)=@_;
    my(%newrule);

    if(!$addrule && !$delrule){return $rule;}

    # 
    ($rule,$rule) = FindRuleFromID($rule);
    if(!$rule || $rule->{'TY:'} ne 'RULESET'){
	MsgPrint('ERR',"Modify Rule invalid base ruleset\n");
	return $rule;
    }

    # 
    %newrule=(%$rule,'AD:'=>$addrule,'DL:'=>$delrule);
    return \%newrule;
}



# HATI 
#sub V6evalTool::prLog($;$){my($message,$level)=@_;$level=0 unless defined($level);push(@SIP_HTMLLog2,"$message\n") if($level<=$V6evalTool::LogLevel);};
#sub V6evalTool::vLogHTML($){my($message) = @_;
#    if($V6evalTool::vLogStat==$V6evalTool::vLogStatCloseRow){print LOG "<TR><TD><BR></TD><TD>\n";
#							     V6evalTool::vLogStat=$V6evalTool::vLogStatOpenRow;};
#    V6evalTool::prLogHTML($message);}

# 
sub LogHTML {
    my($msg)=@_;
    push(@SIP_HTMLLog,$msg);
#    PrintItem($msg);
#    vLogHTML($msg);
}
sub LogHTMLOutput {
    my(@html,@sorthtml,$unit,$val);

    if($CNT_CONF{'SIMULATE-MODE'}){
	map{ref($_)?OutputSIPFrame($_):vLogHTML($_);} @SIP_HTMLLog;
    }
    else{
	foreach $val (@SIP_HTMLLog){
	    if(ref($val) && $val->{'TAHI-NO'} ne ''){
		if($unit){push(@html,$unit)}
		$unit=[$val];
	    }
	    else{
		push(@$unit,$val);
	    }
	}
	if($unit){push(@html,$unit)}
	@sorthtml=sort{$a->[0]->{'TAHI-NO'} <=> $b->[0]->{'TAHI-NO'}}(@html);
	foreach $unit (@sorthtml){
	    foreach $val (@$unit){
		if(ref($val)){OutputSIPFrame($val)}
		else{vLogHTML($val)}
	    }
	}
    }

#    map{ref($_)?OutputSIPFrame($_):vLogHTML($_);} @SIP_HTMLLog;
    undef(@SIP_HTMLLog);
#    map{ref($_)?OutputSIPFrame($_):vLogHTML($_);} @SIP_HTMLLog2;
#    undef(@SIP_HTMLLog2);
}
sub LOG_Err {
    my ($msg) = @_;
#    vLogHTML('</TD></TR><TR><TD></TD><TD>');
    vLogHTML('<font color="red">' . $msg . '</font><BR>');
}
sub LOG_Warn {
    my ($msg) = @_;
    vLogHTML('<font color="green">' . $msg . '</font><BR>');
    if($SIP_RESULT != 2){
	$SIP_RESULT = 1;
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
# SIP
#   ":&quot; &:&amp; <:&lt; >:&gt;
sub OutputSIPFrame {
    my($pktinfo)=@_;
    my(@txt,$i,$color,$dir,$name);
    $color=($pktinfo->{dir} eq 'send'?'darkgoldenrod':'darkslategray');
    if($pktinfo->{dir} eq 'recv'){
	$name=GetNodeNameFromFrame($pktinfo->{'pkt'}->{'recvFrame'},'recv');
	$dir=$name ? '&gt;' . $name : '&gt;&gt;&gt;&gt;';
    }
    else{
	$dir='&lt;&lt;&lt;&lt;';
    }
    vLogHTML(sprintf("</TD></TR><TR><TD><A HREF=\"#SequenceSummary\">%04d</A>: <A HREF=\"#%s\">%s</A></TD><TD><A NAME=\"SIP-%04d\"></A>",
		     $pktinfo->{'index-no'}+1,
		     $SIPLOGO ? "vRecvPKT$pktinfo->{'TAHI-NO'}":
		     ($pktinfo->{dir} eq 'send'?"vSendPKT$pktinfo->{'TAHI-NO'}":"vRecvPKT$pktinfo->{'TAHI-NO'}"),
		     $dir,
		     $pktinfo->{'index-no'}+1));

    @txt=split(/\r\n/,$pktinfo->{frame_txt});
    vLogHTML("<font color=\"$color\">");
    for($i=0;$i<=$#txt;$i++){
	$txt[$i] =~ s/&/&amp;/g;
	$txt[$i] =~ s/"/&quot;/g;
	$txt[$i] =~ s/</&lt;/g;
	$txt[$i] =~ s/>/&gt;/g;
	vLogHTML(" $txt[$i]<BR>");

#   
#	if($txt[$i] =~ /($PtTAGS)$PtHCOLON/){
#	    LogHTML(sprintf("<A NAME=\"PKT%s:%s\"></A><font color=\"gray\">%s</font><BR>",$1,$#SIPPktInfo,$txt[$i]));
#	}
#	else{
#	    LogHTML(sprintf("<font color=\"gray\">%s</font><BR>",$txt[$i]));
#	}
# </TD></TR><TR><TD>Recv SIP</TD><TD>
    }
#    LogHTML('</pre>');
    vLogHTML('</font>');
}

# 
sub ExitScenario {
    my($mode)=@_;
    my($total,$error,$warning);

    ## Inoue add 20070612 ##

    if($SIPLOGO eq 'T') {
	RtpStop();
    }

    ####

    WaitUntilKeyPress("Finish Scenario in the error.\nPress Enter Key and Next test(or Check log).");

    # 
    SIPReviveJudgment();

    # TAHI
    RecoverTahiPackets();

    # 
    LogSIPPktInfo();

    # 
    LogHTMLOutput();

    if($mode eq 'Fatal'){ExitToV6evalTool($V6evalTool::exitFatal);}
    if($mode eq 'Ignore'){ExitToV6evalTool($V6evalTool::exitIgnore);}
    if($mode eq 'InitFail'){ExitToV6evalTool($V6evalTool::exitInitFail);}
    if($mode eq 'Pass'){ExitToV6evalTool($V6evalTool::exitPass);}

    ($total,$error,$warning)=SyntaxRuleResultStatistics();

    # Config
    LogConfigInfo();

    if( $error ){
	ExitToV6evalTool($V6evalTool::exitFail);
    }

    if($mode eq 'Warn'){ExitToV6evalTool($V6evalTool::exitWarn);}
    if($mode eq 'Fail'){ExitToV6evalTool($V6evalTool::exitFail);}

    ExitToV6evalTool($V6evalTool::exitFatal);
}

# 
sub StartScenarioTime {
    if($SIM_Support_HiRes){$SIP_ScenarioStartTime=[Time::HiRes::gettimeofday()];}
}

# 
sub SyntaxRuleResultStatistics {
    my($msg,$key,$val,$spec,$fileName,$totalRuleTime,$diff,$sec,$min,$hour,$mday,$mon,$year,$wday);

    if($SIM_Support_HiRes){
	$diff=Time::HiRes::tv_interval($SIP_ScenarioStartTime, [Time::HiRes::gettimeofday()]);
    }

    if(IsLogLevel('INF') || $SIM_Support_HiRes){
	vLogHTML('</TD></TR><TR><TD>Result Statistics</TD><TD>');
	$msg = sprintf("Check Total Count[%d] Error[%d] Warning[%d]",
		       $SYNTAXRuleResult{total},$SYNTAXRuleResult{error},$SYNTAXRuleResult{warning});
	vLogHTML('<font color="blue">' . $msg . '</font><BR>');
	
	if($SIM_Support_HiRes){
	    vLogHTML("<pre>    err/war/total    ave   ID\n");
	    foreach $key (sort {$SYNTAXRuleResult{$b}{total} <=> $SYNTAXRuleResult{$a}{total}} keys(%SYNTAXRuleResult)){
		if($key ne 'total' && $key ne 'error' && $key ne 'warning'){
		    if( !($spec=$DefRuleSetDB{$key}->{'SP:'}) ){$spec='RFC';}
		    $msg = sprintf("    %03d/%03d/%03d : %6.1f : [%3.3s]%s\n",
				   $SYNTAXRuleResult{$key}{error},$SYNTAXRuleResult{$key}{warning},$SYNTAXRuleResult{$key}{total},
				   $SYNTAXRuleResult{$key}{time}*1000/$SYNTAXRuleResult{$key}{total},$spec,$key);
		    $totalRuleTime += $SYNTAXRuleResult{$key}{time};
		    vLogHTML($msg);
		}
	    }
	}
	else{
	    vLogHTML("<pre>    err/war/total     ID\n");
	    foreach $key (sort {$SYNTAXRuleResult{$b}{total} <=> $SYNTAXRuleResult{$a}{total}} keys(%SYNTAXRuleResult)){
		if($key ne 'total' && $key ne 'error' && $key ne 'warning'){
		    if( !($spec=$DefRuleSetDB{$key}->{'SP:'}) ){$spec='RFC';}
		    $msg = sprintf("    %03d/%03d/%03d : [%3.3s]%s\n",
				   $SYNTAXRuleResult{$key}{error},$SYNTAXRuleResult{$key}{warning},$SYNTAXRuleResult{$key}{total},
				   $spec,$key);
		    vLogHTML($msg);
		}
	    }
	}
	# 
	if($SIM_Support_HiRes){
	    $msg = sprintf("\n    Scenario Run Time [%.2f]sec   Rules Execute Time [%.2f]sec",$diff,$totalRuleTime);
	    vLogHTML($msg);
	}

	vLogHTML('</pre>');
    }
    else{
	vLogHTML(sprintf("</TD></TR><TR><TD>Total</TD><TD><font color=\"#FF6699\">Check Rules[%s]  Errors[%s]  Warnings[%s]</font>",
			 $SYNTAXRuleResult{total},$SYNTAXRuleResult{error},$SYNTAXRuleResult{warning}));
    }

    # 
    if($CNT_CONF{'STATISTICS-OUTPUT'}){
#	$ENV{TZ}="JST-9";
	($sec,$min,$hour,$mday,$mon,$year,$wday)=localtime(time());
	$fileName = $SIP_SEQ_FILE;
	$fileName =~ s/(?:.*\/)*//;
	$fileName =~ s/\.seq//i;
	if( open (FILEOUT, ">$fileName.sta") ){
	    printf(FILEOUT "Result Statistics %04d/%02d/%02d %02d:%02d:%02d  [%s]  ",
		   $year+1900,$mon+1,$mday,$hour,$min,$sec,$SIP_SEQ_FILE);
	    printf(FILEOUT "Check Total Count[%d] Error[%d] Warning[%d]\n",
	           $SYNTAXRuleResult{total},$SYNTAXRuleResult{error},$SYNTAXRuleResult{warning});
	    printf(FILEOUT "    err/war/total time(ms)   ID\n");
	    foreach $key (sort {$SYNTAXRuleResult{$b}{total} <=> $SYNTAXRuleResult{$a}{total}} keys(%SYNTAXRuleResult)){
		if($key ne 'total' && $key ne 'error' && $key ne 'warning'){
		    if( !($spec=$DefRuleSetDB{$key}->{'SP:'}) ){$spec='RFC';}
		    printf(FILEOUT  "    %03d/%03d/%03d : %6.1f : [%3.3s]%s\n",
			   $SYNTAXRuleResult{$key}{error},$SYNTAXRuleResult{$key}{warning},$SYNTAXRuleResult{$key}{total},
			   $SIM_Support_HiRes?$SYNTAXRuleResult{$key}{time}*1000/$SYNTAXRuleResult{$key}{total}:0,
			   $spec,$key);
		}
	    }
	    if($SIM_Support_HiRes){
		printf(FILEOUT "\n    Scenario Run Time [%.2f]sec   Rules Execute Time [%.2f]sec",$diff,$totalRuleTime);
	    }
	    close (FILEOUT);
	    MsgPrint('RULE',"Output Statistics file $fileName.sta\n");
	}
	else{
	    MsgPrint('ERR',"Can't open Statistics file $fileName.sta\n");
	}
    }

    return ($SYNTAXRuleResult{total},$SYNTAXRuleResult{error},$SYNTAXRuleResult{warning});
}
# 
sub AccountSyntaxRuleResult {
    my($ruleID,$result,$time)=@_;
    $SYNTAXRuleResult{total}++;
    $SYNTAXRuleResult{$ruleID}{total}++;
    $SYNTAXRuleResult{$ruleID}{time} += $time;
    if($result eq 'WARNING'){
	$SYNTAXRuleResult{warning}++;
	$SYNTAXRuleResult{$ruleID}{warning}++;
    }
    elsif($result eq ''){
	$SYNTAXRuleResult{error}++;
	$SYNTAXRuleResult{$ruleID}{error}++;
    }
    else{
	$SYNTAXRuleResult{$ruleID}{ok}++;
    }
}

# 
# result: OK | ''
sub SIPAddJudgmentResult {
    my($result,$ruleID,$pktinfo,$context)=@_;
    my($rule);

    ($rule,$rule)=FindRuleFromID($ruleID);

    # TAHI 
    MakeTAHIResultMessage($result,$rule,$pktinfo,$context);

    # Output HTML
    OutputTAHIResultMessage();

    # 
    $result = ($result?$result:($rule->{'RT:'} eq 'warning'?'WARNING':''));

    # 
    AccountSyntaxRuleResult($ruleID,$result);
}


# TAHI 
sub MakeTAHIResultMessage {
    my ($result,$rule,$pktinfo,$context)=@_;
    my($msg,$fmt,$msgType,$ruleID,$detail,$v1,$v2,$v3,$v4);
    shift @_;

    # 
#    PrintVal($context);
    if($context->{'RESULT-DETAIL:'}){
	$v1=ConvertHTMLMessage($context->{'RESULT-DETAIL:'}->{'ARG1:'});
	$v2=ConvertHTMLMessage($context->{'RESULT-DETAIL:'}->{'ARG2:'});
	$v3=ConvertHTMLMessage($context->{'RESULT-DETAIL:'}->{'ARG3:'});
	$v4=ConvertHTMLMessage($context->{'RESULT-DETAIL:'}->{'ARG4:'});
    }

    # Judgment
    # 
    if(!$rule->{'LG:'}){
	$msg=$result?$rule->{'OK:'}:$rule->{'NG:'};
	$msgType=$result?'OK':(($rule->{'RT:'} eq 'warning')?'WAR':'ERR');
    }
    # 
    elsif($rule->{'LG:'} eq 'VALID'){
	if(!$result){return '';}
	$msg=$rule->{'OK:'};
	$msgType='OK';
    }
    # 
    elsif($rule->{'LG:'} eq 'INVALID'){
	if(!$result){return 'OK';}
	$msg=$rule->{'NG:'};
	$msgType=($rule->{'RT:'} eq 'warning')?'WAR':'ERR';
	$result='';
    }
    # 
    elsif($rule->{'LG:'} eq 'NOT'){
	$msg=$result?$rule->{'NG:'}:$rule->{'OK:'};
	$msgType=$result?(($rule->{'RT:'} eq 'warning')?'WAR':'ERR'):'OK';
	$result=!$result;
    }
    # 
    if($rule->{'ET:'} eq 'REAL' && $context->{'EVAL-TIME'} eq 'REAL'){return $result;}
    
    if(ref($msg) eq 'HASH'){
	$msg=EvalMsg($msg);
    }
    elsif(ref($msg) eq 'SCALAR'){
	$msg=eval $$msg;
    }
    elsif(ref($msg) eq 'REF'){
	$fmt = sprintf("sprintf(\"$$$msg\")",
		       ref($v1)?'<font color=\"mediumpurple\">@$v1</font>':'<font color=\"mediumpurple\">$v1</font>',
#		       ref($v2)?'<font color=\"navy\">@$v2</font>':'<font color=\"navy\">$v2</font>',
		       ref($v2)?'<font color=\"mediumpurple\">@$v2</font>':'<font color=\"mediumpurple\">$v2</font>',
		       ref($v3)?'<font color=\"mediumpurple\">@$v3</font>':'<font color=\"mediumpurple\">$v3</font>',
		       ref($v4)?'<font color=\"mediumpurple\">@$v4</font>':'<font color=\"mediumpurple\">$v4</font>');
#	PrintItem($fmt);
	$msg = eval $fmt;
#	$msg=eval "sprintf(\"$$$msg\",\"$v1\")";
    }

    # 
    if(IsLogLevel('INF') && $context->{'RESULT-DETAIL:'}){
	if($context->{'RESULT-DETAIL:'}->{'TY:'} eq '2op'){
	    $detail=sprintf('<font color="%s"> (%s [%s] [%s])</font>', 'gray',$context->{'RESULT-DETAIL:'}->{'OP:'},$v1,$v2);
	}
	else{
	    $detail=sprintf('<font color="%s"> (%s %s [%s])</font>','gray',
			    $context->{'RESULT-DETAIL:'}->{'TY:'},$context->{'RESULT-DETAIL:'}->{'OP:'},$v1);
	}
    }

    # 
#    $ruleID=IsLogLevel('INF')?$rule->{'ID:'}:sprintf("<A HREF=\"#PKT%s:%s\">%s</A>",$rule->{'CA:'},$#SIPPktInfo,$rule->{'CA:'});
    $ruleID=IsLogLevel('INF')?$rule->{'ID:'}:$rule->{'CA:'};

    # Judgment
#    $msg=JudgmentHTMLMessage($rule,$ruleID,$msgType,$msg,$detail);
### 20060209 maeda update
#    $msg = sprintf('<B><font color="%s">%s: </font></B><B><font color="%s">%s</font></B>%s<BR>',
#		   $rule->{'EX:'}?(($rule->{'SP:'} eq 'IG')?'#9933C':'#00CCFF'):'pink',$ruleID,
#		   $msgType eq 'OK'?'black':($msgType eq 'WAR'?'green':'red'),$msg,$detail);
    $msg = sprintf('<B><font color="%s">%s: </font></B><B><font color="%s">%s</font></B>%s<BR>',
		   $rule->{'EX:'}?(($rule->{'SP:'} eq 'IG')?'#9933C':(($rule->{'SP:'} eq 'TTC')?'#FF6600':'#00CCFF')):'pink',$ruleID,
		   $msgType eq 'OK'?'black':($msgType eq 'WAR'?'green':'red'),$msg,$detail);
    
    # HATI
    if(IsLogLevel('INF')){
	LogHTML($msg);
    }
    else{
	push(@SIP_TAHI_RESULT,[$ruleID,$msg,$msgType]);
    }
    return $result;
}
# Config
sub LogConfigInfo {
    my($msg,$key,$val,$comment);

    $comment=!IsLogLevel('INF');
#    if(!IsLogLevel('INF')){return;}

    vLogHTML(($comment?"\n<!-- ":'').'</TD></TR><TR><TD>Config Info</TD><TD>');
	
    vLogHTML(sprintf("<pre> Platform [%s]\n\n",$SIP_PLATFORM));

    vLogHTML("          config label                       value\n");
    while(($key,$val)=each(%CNT_CONF)){
	$msg = sprintf("    %-30.30s : %s\n",$key,$val);
	vLogHTML($msg);
    }

    vLogHTML("\n\n             FQDN                       AAAA record\n");
    foreach $val (@SIP_AAAA_RECORD){
	$msg = sprintf("    %-30.30s : %s\n",$val->{'FQDN'},$SIP_PL_IP eq 6 ? $val->{'IPV6'}:$val->{'IPV4'});
	vLogHTML($msg);
    }

    vLogHTML('</pre>'.($comment?" -->\n":''));
}

# Judgment
sub JudgmentHTMLMessage {
    my($rule,$ruleID,$msgType,$msg,$detail)=@_;

    # HTML
    $msg =~ s/&/&amp;/g;
    $msg =~ s/"/&quot;/g;
    $msg =~ s/</&lt;/g;
    $msg =~ s/>/&gt;/g;
    # 
### 20060209 maeda update
#    return sprintf('<B><font color="%s">%s: </font></B><B><font color="%s">%s</font></B>%s<BR>',
#		 $rule->{'EX:'}?(($rule->{'SP:'} eq 'IG')?'#9933C':'#00CCFF'):'pink',$ruleID,
#		 $msgType eq 'OK'?'black':($msgType eq 'WAR'?'green':'red'),$msg,$detail);
    return sprintf('<B><font color="%s">%s: </font></B><B><font color="%s">%s</font></B>%s<BR>',
		 $rule->{'EX:'}?(($rule->{'SP:'} eq 'IG')?'#9933C':(($rule->{'SP:'} eq 'TTC')?'#FF6600':'#00CCFF')):'pink',$ruleID,
		 $msgType eq 'OK'?'black':($msgType eq 'WAR'?'green':'red'),$msg,$detail);
}
sub ConvertHTMLMessage {
    my($msg)=@_;

    # HTML
    $msg =~ s/&/&amp;/g;
    $msg =~ s/"/&quot;/g;
    $msg =~ s/</&lt;/g;
    $msg =~ s/>/&gt;/g;
    return $msg;
}

# OutputTAHIResultMessage
sub PktInfoOrder {
    my($pktinfo)=@_;
    my($od1,$od2,$i,$hdr);
    $od1=int($RuleCategory{$a->[0]}->{'OD:'});
    $od2=int($RuleCategory{$b->[0]}->{'OD:'});
    printf("[$a->[0]:$od1  $b->[0]:$od2](%s)\n",$od1<=>$od2);
    if( $od1 < $od2 ){return -1;}
    if( $od1 > $od2 ){return 1;}
    if( 30<$od1 && $od1<40){
	$hdr=$pktinfo->{header};
	for($i=0;$i<=$#$hdr;$i++){
	    if( $hdr->[$i]->{id} eq $a->[0] ){return -1;}
	    if( $hdr->[$i]->{id} eq $b->[0] ){return 1;}
	}
	return $a->[0] cmp $b->[0];
    }
    if( 40<$od1 && $od1<50){
	$hdr=$pktinfo->{body};
	for($i=0;$i<=$#$hdr;$i++){
	    if( $hdr->[$i]->{id} eq $a->[0] ){return -1;}
	    if( $hdr->[$i]->{id} eq $b->[0] ){return 1;}
	}
	return $a->[0] cmp $b->[0];
    }
    return 0;
}
# 
sub OutputTAHIResultMessage {
    my($pktinfo)=@_;
    my(@sortMsg,$i,%result);
    if($#SIP_TAHI_RESULT eq -1){return;}

    LogHTML("</TD></TR><TR><TD>Judgment</TD><TD>");

    # pktinfo
    @sortMsg = sort {
	my($od1,$od2,$i,$hdr);
	$od1=int($RuleCategory{$a->[0]}->{'OD:'});
	$od2=int($RuleCategory{$b->[0]}->{'OD:'});
	if( $od1 < $od2 ){return -1;}
	if( $od1 > $od2 ){return 1;}
	if( 30<$od1 && $od1<40){
	    $hdr=$pktinfo->{header};
	    for($i=0;$i<=$#$hdr;$i++){
		if( $hdr->[$i]->{tag} eq $a->[0] ){return -1;}
		if( $hdr->[$i]->{tag} eq $b->[0] ){return 1;}
	    }
	    return $a->[0] cmp $b->[0];
	}
	if( 40<$od1 && $od1<50){
	    $hdr=$pktinfo->{body};
	    for($i=0;$i<=$#$hdr;$i++){
		if( $hdr->[$i]->{tag} eq $a->[0] ){return -1;}
		if( $hdr->[$i]->{tag} eq $b->[0] ){return 1;}
	    }
	    return $a->[0] cmp $b->[0];
	}
	return 0;} @SIP_TAHI_RESULT;
#    @sortMsg = sort {$a->[0] cmp $b->[0]} @SIP_TAHI_RESULT;

    # HATI
    $result{ERR}=0;$result{WAR}=0;$result{OK}=0;
    for($i=0;$i<=$#sortMsg;$i++){
	LogHTML($sortMsg[$i]->[1]);
	$result{$sortMsg[$i]->[2]}++;
    }

    LogHTML("</TD></TR><TR><TD></TD><TD>");
    LogHTML(sprintf("<font color=\"#FF6699\">Check Rules[%s]  Errors[%s]  Warnings[%s]</font>",$#sortMsg+1,$result{ERR},$result{WAR}));

    # 
    undef @SIP_TAHI_RESULT;
}

#============================================
# 
#============================================
# 
sub MargeSipMsg {
    my($rule,$pktinfo,$context)=@_;
    my($rr,$msg,$i,$command,@header,@body,@follow,$cm,$hd,$bd,$msgList,$part);

    # 
    $msgList= $context->{'RESULT:'};

    # 
    for($i=0;$i<=$#$msgList;$i++){
	# 
	if($$msgList[$i]->{'RE:'} eq ''){next;}
	#
	$rr=$DefRuleSetDB{$$msgList[$i]->{'ID:'}};
	if($rr->{'TY:'} eq 'RULESET'){
	    ($cm,$hd,$bd)=MargeSipMsg2($$msgList[$i]->{'RE:'});
	    if($cm){$command=$cm;}
	    if($hd){push(@header,@$hd);}
	    if($bd){push(@body,@$bd);}
	}
	elsif($rr->{'TY:'} eq 'ENCODE'){
	    $part=$rr->{'PT:'};
	    MsgPrint('RULE2',"  ID[%s] PT[%s] msg[%s]\n",$$msgList[$i]->{'ID:'},$part,$$msgList[$i]->{'RE:'});

	    #
	    if($part eq 'RQ'){
		$command=$$msgList[$i]->{'RE:'};
	    }
	    elsif($part eq 'HD'){
#		push(@header,$$msgList[$i]->{'RE:'});
        if($rr->{'NX:'}){
            push(@follow,{'RE:'=>$$msgList[$i]->{'RE:'},'NX:'=>$rr->{'NX:'}});
        }       
        else{   
            push(@header,$$msgList[$i]->{'RE:'});
        }		
	    }
	    elsif($part eq 'BD'){
		push(@body,$$msgList[$i]->{'RE:'});
	    }
	}
    }

    # 
    foreach $msg (@follow){
    for $i (0..$#header){
        if($header[$i] =~ /^(?:$msg->{'NX:'}):/){
        splice(@header,$i+1,0,$msg->{'RE:'});
        last;
        }
    }
    }

    #
    if($command){
	$msg = $command . "\r\n";
    }
    $msg .= join("\r\n",@header) . "\r\n\r\n";
    if(-1<$#body){
	$msg .= join("\r\n",@body) . "\r\n";
    }
    MsgPrint('RULE',"Margemsg size[%s]\n",length($msg));

    return $msg;
}
sub MargeSipMsg2 {
    my($msgList)=@_;
    my($rr,$i,$command,@header,@body,$cm,$hd,$bd,$part);

#    PrintVal($msgList);
    # 
    for($i=0;$i<=$#$msgList;$i++){
	#
	$rr=$DefRuleSetDB{$$msgList[$i]->{'ID:'}};
	if($rr->{'TY:'} eq 'RULESET'){
	    ($cm,$hd,$bd)=MargeSipMsg2($$msgList[$i]->{'RE:'});
	    if($cm){$command=$cm;}
	    if($hd){push(@header,@$hd);}
	    if($bd){push(@body,@$bd);}
	}
	elsif($rr->{'TY:'} eq 'ENCODE'){
	    $part=$rr->{'PT:'};
	    MsgPrint('RULE2',"  ID[%s] PT[%s] msg[%s]\n",$$msgList[$i]->{'ID:'},$part,$$msgList[$i]->{'RE:'});

	    #
	    if($part eq 'RQ'){
		$command=$$msgList[$i]->{'RE:'};
	    }
	    elsif($part eq 'HD'){
		push(@header,$$msgList[$i]->{'RE:'});
	    }
	    elsif($part eq 'BD'){
		push(@body,$$msgList[$i]->{'RE:'});
	    }
	}
    }
    return($command,-1<$#header?\@header:'',-1<$#body?\@body:'');
}

# 
sub MargeSipMsgAndSend {
    my($rule,$pktinfo,$context)=@_;
    my($msg,$msgList);

    # 
    $msgList= $context->{'RESULT:'};

    $msg=MargeSipMsg($msgList);
    if($msg){
	# 

	# SIP
    }
}
# 
sub FVcount {
    my($val)=@_;
    if(!ref($val)){ return (($val eq '')?0:1); }
    elsif( ref($val) eq 'ARRAY'){return $#$val+1;}
    elsif(ref($val) eq 'REF'){return FVcount($$val);}
    return 1;
}

# 
sub FV {
    my($field,$rule,$pktinfo)=@_;
    my($vals,$count,$val);
    if(!ref($pktinfo)){
	if( !$pktinfo || !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    ($vals,$count,$val)=GetSIPField($field,$pktinfo);
    if(!ref($val)){$val =~ s/^\s*//;}
#    PrintItem($val);
    return $val;
}
# 
sub FVn {
    my($field,$index,$rule,$pktinfo)=@_;
    my($vals,$count,$val);
    if(!ref($pktinfo)){
	if( !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    ($vals,$count,$val)=GetSIPField($field,$pktinfo,$index);
#    PrintVal($vals);
    return $vals;
}
# 
sub FVs {
    my($field,$rule,$pktinfo)=@_;
    my($vals,$count,$val);
    if(!ref($pktinfo)){
	if( !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    ($vals,$count,$val)=GetSIPField($field,$pktinfo);
#    PrintVal($vals);
    return $vals;
}
# 
sub FVsn {
    my($field,$index,$rule,$pktinfo)=@_;
    my($vals,$count,$val);
    if(!ref($pktinfo)){
	if( !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    ($vals,$count,$val)=GetSIPField($field,$pktinfo);
#    PrintVal($vals);
    return $vals?$vals->[$index]:'';
}
# 
sub FVm {
    my($field,$field2,$fieldval2,$rule,$pktinfo)=@_;
    my(@tags,$vals,$val,$count,$i,$info,$partinfo);

    @tags=split(/\./,$field2);
    if($tags[0] eq 'HD'){
	($pktinfo,$partinfo)=SipParsePart($pktinfo,$tags[1]);
    }
    elsif($tags[0] eq 'BD'){
	($pktinfo,$partinfo)=SipParsePart($pktinfo,$tags[1]);
    }
    shift @tags;shift @tags;
    $field2=join('.',@tags);

    if(ref($partinfo) eq 'ARRAY'){
	for($i=0;$i<=$#$partinfo;$i++){
	    ($vals,$count,$val)=GetSIPField($field2,$partinfo->[$i]);
#	    PrintVal($field2);
#	    PrintVal($partinfo->[$i]);
#	    PrintVal($vals);
#	    PrintVal($fieldval2);
	    # 
	    if(ref($fieldval2) eq 'SCALAR'){
		if( eval($$fieldval2) ne '' ){
		    $info = $partinfo->[$i];
		    goto MATCH;
		}
	    }
	    elsif(ref($vals) eq 'ARRAY'){
		if( grep{$_ eq $fieldval2} @$vals ){
		    $info = $partinfo->[$i];
		    goto MATCH;
		}
	    }
	    else{
		if($vals eq $fieldval2){
		    $info = $partinfo->[$i];
		    goto MATCH;
		}
	    }
	}
    }
    else{
	($vals,$count,$val)=GetSIPField($field2,$partinfo);
	if(ref($fieldval2) eq 'SCALAR'){
	    if( eval($$fieldval2) ne '' ){
		$info = $partinfo;
		goto MATCH;
	    }
	}
	elsif(ref($vals) eq 'ARRAY'){
	    if( grep{$_ eq $fieldval2} @$vals ){
		$info = $partinfo;
		goto MATCH;
	    }
	}
	else{
	    if($vals eq $fieldval2){
		$info = $partinfo;
		goto MATCH;
	    }
	}
    }
    return '';
MATCH:
    @tags=split(/\./,$field);
    shift @tags;shift @tags;
    $field=join('.',@tags);
    ($vals,$count,$val)=GetSIPField($field,$info);
# PrintVal($count<=1?$val:$vals);
    return $count<=1?$val:$vals;
}
# 
sub FVma {
    my($field,$field2,$fieldval2,$rule,$pktinfo)=@_;
    my(@tags,$vals,$val,$count,$i,$partinfo,@result);

    @tags=split(/\./,$field2);
    if($tags[0] eq 'HD'){
	($pktinfo,$partinfo)=SipParsePart($pktinfo,$tags[1]);
    }
    elsif($tags[0] eq 'BD'){
	($pktinfo,$partinfo)=SipParsePart($pktinfo,$tags[1]);
    }
    shift @tags;shift @tags;
    $field2=join('.',@tags);

    @tags=split(/\./,$field);
    shift @tags;shift @tags;
    $field=join('.',@tags);

    if(ref($partinfo) eq 'ARRAY'){
	for($i=0;$i<=$#$partinfo;$i++){
	    ($vals,$count,$val)=GetSIPField($field2,$partinfo->[$i]);
#	    PrintVal($vals);
#	    PrintVal($fieldval2);
	    # 
	    if(ref($fieldval2) eq 'SCALAR'){
		if( eval($$fieldval2) eq '' ){next;}
	    }
	    elsif(ref($vals) eq 'ARRAY'){
		if( !grep{$_ eq $fieldval2} @$vals ){next;}
	    }
	    elsif($vals ne $fieldval2){next;}
	    
	    ($vals,$count,$val)=GetSIPField($field,$partinfo->[$i]);
	    if(0<$count){push(@result,1<$count?$vals:$val);}
	}
	return(-1<$#result?\@result:'');
    }
    else{
	($vals,$count,$val)=GetSIPField($field2,$partinfo);
	if( (ref($fieldval2) eq 'SCALAR' && eval($$fieldval2) ne '')   ||
            (ref($vals) eq 'ARRAY' && (grep{$_ eq $fieldval2} @$vals)) || $vals eq $fieldval2 ){
	    ($vals,$count,$val)=GetSIPField($field,$partinfo);
	    if(0<$count){push(@result,1<$count?$vals:$val);return \@result;}
	}
	return '';
    }
}

# 
sub FVi {
    my($index,$field)=@_;
    my($vals,$count,$val);
    if($field eq 'DIRECTION'){
	return @SIPPktInfo[$index]->{dir};
    }
    elsif($index eq ''){
	return '';
    }
    else{
	($vals,$count,$val)=GetSIPField($field,@SIPPktInfo[$index]);
    }
    return $val;
}
# SIP
#   
#   
#   
#   
sub FVib {
    my($dir,$start,$end,$field)=@_;
    return FVibx(0,@_);
}
sub FVif {
    my($dir,$start,$end,$field)=@_;

    return FVifx(0,@_);
}
# SIP
#   
#   
#   
#   
#   
sub FVibx {
    my($index,$dir,$start,$end,$field)=@_;
    my($vals,$count,$val,$cond,$i,$j,$expr);

    if($index eq '') {$index = 0;}
    if($end eq '')   {$end = 0;}
    if($start eq '') {$start = $#SIPPktInfo;}
    elsif($start < 0){$start = $#SIPPktInfo+$start;}

    shift;shift;shift;shift;shift;
    $cond = \@_;

    for($i=$start;$end<=$i;$i--){
	if($dir && @SIPPktInfo[$i]->{dir} ne $dir ){next;}
	# 
	for($j=0;$j<=$#$cond;$j+=2){
	    ($vals,$count,$val)=GetSIPField($cond->[$j],@SIPPktInfo[$i]);
	    if(ref($cond->[$j+1]) eq 'SCALAR'){
		$expr=$cond->[$j+1];
		if( eval($$expr) eq '' ){goto NEXT;}
	    }
	    else{
		if($val ne $cond->[$j+1]){goto NEXT;}
	    }
	}
	# 
	if($index){$index--;goto NEXT;}
	# 
	if($field){
	    ($vals,$count,$val)=GetSIPField($field,@SIPPktInfo[$i]);
	    return 1<$count?$vals:$val;
	}
	else{
	    return $i;
	}
      NEXT:
	next;  # 
    }
    return '';
}
sub FVifx {
    my($index,$dir,$start,$end,$field)=@_;
    my($vals,$count,$val,$cond,$i,$j,$expr);

    if($index eq ''){$index = 0;}
    if($end eq '')  {$end = $#SIPPktInfo;}
    elsif($end < 0) {$end = $#SIPPktInfo+$end;}
    if($start eq ''){$start = 0;}

    shift;shift;shift;shift;shift;
    $cond = \@_;
    for($i=$start;$i<=$end;$i++){
	if($dir && @SIPPktInfo[$i]->{dir} ne $dir ){next;}
	for($j=0;$j<=$#$cond;$j+=2){
	    ($vals,$count,$val)=GetSIPField($cond->[$j],@SIPPktInfo[$i]);
	    if(ref($cond->[$j+1]) eq 'SCALAR'){
		$expr=$cond->[$j+1];
		if( eval($$expr) eq '' ){goto NEXT;}
	    }
	    else{
		if($val ne $cond->[$j+1]){goto NEXT;}
	    }
	}
	# 
	if($index){$index--;goto NEXT;}
	# 
	if($field){
	    ($vals,$count,$val)=GetSIPField($field,@SIPPktInfo[$i]);
	    return 1<$count?$vals:$val;
	}
	else{
	    return $i;
	}
      NEXT:
	next;
    }
    return '';
}
# SIP
sub FVibc {
    my($dir,$start,$end)=@_;
    my($vals,$count,$val,$cond,$i,$j,$total,$expr);

    if($end eq '')  {$end = 0;}
    if($start eq ''){$start = $#SIPPktInfo;}

    shift;shift;shift;
    $cond = \@_;
    $total=0;
#    PrintItem("start=$start");
#    PrintItem("end=$end");
    for($i=$start;$end<=$i;$i--){
	if($dir && @SIPPktInfo[$i]->{dir} ne $dir ){next;}
	for($j=0;$j<=$#$cond;$j+=2){
	    ($vals,$count,$val)=GetSIPField($cond->[$j],@SIPPktInfo[$i]);
#	    PrintVal($vals);
	    if(ref($cond->[$j+1]) eq 'SCALAR'){
		$expr=$cond->[$j+1];
#		PrintItem("expr=$$expr");
#		PrintItem("T1_START=$T1_START");
		if( eval($$expr) eq ''){goto NEXT;}
	    }
	    else{
		if($val ne $cond->[$j+1]){goto NEXT;}
	    }
	}
	$total++;
      NEXT:
	next;
    }
    return $total;
}
# SIP
sub FVifc {
    my($dir,$start,$end)=@_;
    my($vals,$count,$val,$cond,$i,$j,$total,$expr);

    if($end eq '')  {$end = $#SIPPktInfo;}
    if($start eq ''){$start = 0;}

    shift;shift;shift;
    $cond = \@_;
    $total=0;
#    PrintItem("start=$start");
#    PrintItem("end=$end");
    for($i=$start;$i<=$end;$i++){
	if($dir && @SIPPktInfo[$i]->{dir} ne $dir ){next;}
	for($j=0;$j<=$#$cond;$j+=2){
	    ($vals,$count,$val)=GetSIPField($cond->[$j],@SIPPktInfo[$i]);
	    if(ref($cond->[$j+1]) eq 'SCALAR'){
		$expr=$cond->[$j+1];
#		PrintItem("expr=$$expr");
#		PrintItem("T1_START=$T1_START");
		if( eval($$expr) eq '' ){goto NEXT;}
#		PrintItem("eval TRUE");
	    }
	    else{
#		PrintItem("cond=$cond->[$j+1]");
		if($val ne $cond->[$j+1]){goto NEXT;}
	    }
	}
	$total++;
      NEXT:
	next;
    }
    return $total;
}

# SIP
#   
sub FVsib {
    my($dir,$start,$end,$field,$conds,$nulval,$rule,$pktinfo)=@_;

    if($end eq '')   {$end = 0;}
    if($start eq '') {$start = $#SIPPktInfo;}
    elsif($start < 0){$start = $#SIPPktInfo+$start;}

    my($i,$j,$vals,$count,$val,@fvals);

    # 
    for($i=$start;$end<=$i;$i--){
	if(@SIPPktInfo[$i]->{dir} ne $dir){next;}
	# 
	if($conds){
	    for($j=0;$j<=$#$conds;$j+=2){
		($vals,$count,$val)=GetSIPField($conds->[$j],@SIPPktInfo[$i]);
		if($conds->[$j+1] ne $val){ goto NEXT; }
	    }
	}
	($vals,$count,$val)=GetSIPField($field,@SIPPktInfo[$i]);
	if($nulval || $val){push(@fvals,$vals);}
      NEXT:
	next;
    }
    return (-1<$#fvals)?\@fvals:'';
}
# 
sub FVSeparete {
    my($field,$delim,$rule,$pktinfo)=@_;
    my($vals,$count,$val,@spl);
    ($vals,$count,$val)=GetSIPField($field,$pktinfo);
    if($delim eq ' '){
	@spl = split(" ",$val);
    }
    else{
	@spl = split(/$delim/,$val);
    }
    return \@spl;
}

# Content-Length
sub FFCalcConteLength {
    my($rule,$pktinfo,$context)=@_;
    my($count,$i,$msgList,$part);

    # 
    $msgList= $context->{'RESULT:'};

    $count=0;
    # 
    for($i=0;$i<=$#$msgList;$i++){
	#
	$part=$DefRuleSetDB{$$msgList[$i]->{'ID:'}}->{'PT:'};

	#
	if($part eq 'BD'){
	    $count += length($$msgList[$i]->{'RE:'});
	}
    }

    return $count?($count + 2):0; # MargeSipMsg
}

# 
sub FFIsExistHeader {
    my($tag,$rule,$pktinfo)=@_;
    my($result,$i,$j,$count);

    if(!ref($pktinfo)){
	if( !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    SipParsePart($pktinfo,'HEADER');
    if(ref($tag) eq 'ARRAY'){
	for($i=0;$i<=$#$tag;$i++){
	    for($j=0;$j<=$#{$pktinfo->{header}};$j++){
		if($tag->[$i] eq $pktinfo->{header}->[$j]{tag}){$count++;}
	    }
	}
    }
    else{
	for($j=0;$j<=$#{$pktinfo->{header}};$j++){
	    if($tag eq $pktinfo->{header}->[$j]{tag}){$count++;}
	}
    }
    if($count){return $count;}

    SipParsePart($pktinfo,'BODY');
    if(ref($tag) eq 'ARRAY'){
	for($i=0;$i<=$#$tag;$i++){
	    for($j=0;$j<=$#{$pktinfo->{body}};$j++){
		if($tag->[$i] eq $pktinfo->{body}->[$j]{tag}){$count++;}
	    }
	}
    }
    else{
	for($j=0;$j<=$#{$pktinfo->{body}};$j++){
	    if($tag eq $pktinfo->{body}->[$j]{tag}){$count++;}
	}
    }
    return $count;
}

# 
sub FFIsMatchStr {
    my($str,$val,$allmode,$nocase,$rule,$pktinfo,$context)=@_;
    my($count,$result);
    if(ref($val) eq 'REF'){
	($val,$count)=GetSIPField($$$val,$pktinfo);
    }

# PrintItem($str);
    $context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>'=~','ARG1:'=>$val};
    if(ref($val) eq 'ARRAY'){
	if($nocase){
	    $result=grep{($_ =~ /$str/i)?1:($allmode?return '':'')} @$val;  # grep
	}
	else{
	    $result=grep{($_ =~ /$str/)?1:($allmode?return '':'')} @$val;  # grep
	}
#	PrintItem($result);
	return $result?$result:'';
    }
    else {
	if($nocase){
	    return $val =~ /$str/i;
	}
	else{
	    return $val =~ /$str/;
	}
    }
}

# 
sub FFIsExistStr {
    my($str,$val,$allmode,$rule,$pktinfo)=@_;
    my($count,$result);
    if(ref($val) eq 'REF'){
	($val,$count)=GetSIPField($$$val,$pktinfo);
    }
    if(ref($val) eq 'ARRAY'){
	$result=grep{($_ eq $str)?1:($allmode?return '':'')} @$val;  # grep
	return $result?$result:'';
    }
    else {
	return $val eq $str;
    }
}

sub ExpandArray {
    my($group)=@_;
    my($i,@vals);
    for($i=0;$i<=$#$group;$i++){
	if(ref($group->[$i]) eq 'ARRAY'){
	    push(@vals,@{ExpandArray($group->[$i])});
	}
	else{
	    push(@vals,$group->[$i]);
	}
    }
    return \@vals;
}

# 
sub FFIsMember {
    my($val,$group,$op,$rule,$pktinfo)=@_;
    if(!$op){$op='eq';}
    my($vals,$count,$result,$i);

    # 
    $group = ExpandArray($group);
#    PrintVal($group);
    if(ref($val) eq 'REF'){
	($vals,$count,$val)=GetSIPField($$$val,$pktinfo);
    }
#    PrintVal($val);
    if(ref($val) eq 'ARRAY'){
	for($i=0;$i<=$#$val;$i++){
	    $result=grep{($op eq 'EQ')?(lc($_) eq lc($val->[$i])):($_ eq $val->[$i])} @$group;
	    if(!$result){return '';}
	}
    }
    else{
	$result=grep{($op eq 'EQ')?(lc($_) eq lc($val)):($_ eq $val)} @$group;
    }
#    PrintVal($result);
    return $result?$result:'';
}

# 
sub FFGetMatchStr {
    my($str,$val,$rule,$pktinfo)=@_;
    my($result,$item);
    if(!ref($pktinfo)){
	if( !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    if(ref($val) eq 'REF'){
	$val=GetSIPField($$$val,$pktinfo);
    }
    if(ref($val) eq 'ARRAY'){
	foreach $item (@$val){
#	    PrintItem($item);
	    if($item =~ /$str/){return $1;}
	}
    }
    else {
#	PrintItem($val);
	if( $val =~ /$str/ ){return $1;}
    }
    return '';
}

# 
sub FFGetIndexValSeparateDelimiter {
    my($val,$index,$delim,$rule,$pktinfo)=@_;
    my($vals,$count,@spl);
    if(ref($val) eq 'REF'){
	($vals,$count,$val)=GetSIPField($$$val,$pktinfo);
    }
    @spl = split(/$delim/,$val);
    return $spl[$index];
}

# 
sub FFGetIndexValsSeparateDelimiter {
    my($val,$index,$delim,$rule,$pktinfo)=@_;
    my($vals,$count,@spl,$i,@ret);
    if(ref($val) eq 'REF'){
	($vals,$count,$val)=GetSIPField($$$val,$pktinfo);
    }
    for($i=0;$i<=$#$vals;$i++){
	@spl = split(/$delim/,$vals->[$i]);
	push(@ret,$spl[$index]);
    }
    return \@ret;
}

# 
sub FFGetIndexCountSeparateDelimiter {
    my($val,$delim,$rule,$pktinfo)=@_;
    my($vals,$count,@spl);
    if(ref($val) eq 'REF'){
	($vals,$count,$val)=GetSIPField($$$val,$pktinfo);
    }
    @spl = split(/$delim/,$val);
    return $#spl;
}

# 
sub FFop {
    my($ope,$val1,$val2,$rule,$pktinfo,$context)=@_;
    my($count1,$count2,$i,@args);

    if(ref($ope) eq 'ARRAY'){@args=@$ope;shift @args;$ope=$ope->[0];}

    if(ref($val1) eq 'REF'){
	($val1,$count1)=GetSIPField($$$val1,$pktinfo);
    }
    if(ref($val1) eq 'ARRAY'){
	$count1=$#$val1 + 1;
	if($count1<=1){$val1=$val1->[0];}
    }
    else{
	$count1=1;
    }
    if($count1 == 1){$val1 =~ s/^\s*//;}

    # 
    if($ope eq '<>' || $ope eq '<=>' ){
	$context->{'RESULT-DETAIL:'}={'TY:'=>'1op','OP:'=>$ope,'ARG1:'=>$val1};
    }
    else{
	if(ref($val2) eq 'REF'){
	    ($val2,$count2)=GetSIPField($$$val2,$pktinfo);
	}
	if(ref($val2) eq 'ARRAY'){
	    $count2=$#$val2 + 1;
	if($count2<=1){$val2=$val2->[0];}
	}
	else{
	    $count2=1;
	}
	if($count2 == 1){$val2 =~ s/^\s*//;}
	$context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>$ope,'ARG1:'=>$val1,'ARG2:'=>$val2};
	if($count1<1 || $count2<1){return '';}
    }

    if(ref($ope) eq 'CODE'){
	shift @_;shift @_;shift @_;
	return $ope->($val1,$val2,@_);
    }
    # 
    elsif($ope eq 'eq'){
	if($count1 ne $count2){return '';}
	if($count1<=1){
	    return ($val1 eq $val2);
	}
	else {
	    for($i=0;$i<$count1;$i++){
		if($val1->[$i] ne $val2->[$i]){return '';}
	    }
	}
	return 1;
    }
    elsif($ope eq 'ne'){
	if($count1 ne $count2){return '';}
	if($count1<=1){
	    return ($val1 ne $val2);
	}
	else {
	    for($i=0;$i<$count1;$i++){
		if($val1->[$i] eq $val2->[$i]){return '';}
	    }
	}
	return 1;
    }
    # 
    elsif($ope eq '<' || $ope eq '>' || $ope eq '<=' || $ope eq '>='){
	if($count1<=1){
	    return eval( sprintf("%s %s %s",$val1,$ope,$val2) );
	}
	else {
	    for($i=0;$i<$count1;$i++){
		if( eval(sprintf("%s %s %s",$val1->[$i],$ope,$val2->[$i])) ){return '';}
	    }
	}
	return 1;
    }
    elsif($ope eq '=='){
	if($count1<=1){
	    if($val1 eq '' || $val2 eq ''){return '';}
	    return $val1 == $val2;
	}
	else {
	    for($i=0;$i<$count1;$i++){
		if($val1->[$i] eq '' || $val2->[$i] eq '' || $val1->[$i] != $val2->[$i]){return '';}
	    }
	}
	return 1;
    }
    elsif($ope eq 'EQ'){
	if($count1 ne $count2){return '';}
	if($count1<=1){
	    return (lc($val1) eq lc($val2));
	}
	else {
	    for($i=0;$i<$count1;$i++){
		if(lc($val1->[$i]) ne lc($val2->[$i])){return '';}
	    }
	}
	return 1;
    }
    elsif($ope eq 'ptn'){
	# 
	$val1=SIPMakeStruct($val1,$args[0]);
	$val2=SIPMakeStruct($val2,$args[0]);
	return SIPParseEqual($val1,$val2,$args[1]);
    }
    elsif($ope eq '<=>'){
#	PrintVal($val1);
#	PrintVal($val2);
	if($count1<=1){
	    return ($val2->[0] <= $val1 && $val1 <= $val2->[1]);
	}
	else {
	    for($i=0;$i<$count1;$i++){
		if(!($val2->[0] <= $val1->[$i] && $val1->[$i] <= $val2->[1])){return '';}
	    }
	}
	return 1;
    }
    elsif($ope eq '<>'){
	if($count1<=1){
	    return ($val2->[0] < $val1 && $val1 < $val2->[1]);
	}
	else {
	    for($i=0;$i<$count1;$i++){
		if(!($val2->[0] < $val1->[$i] && $val1->[$i] < $val2->[1])){return '';}
	    }
	}
	return 1;
    }
}

# 
# 
sub FFIsExistParamValue {
    my($field,$name,$val,$rule,$pktinfo)=@_;
    my($count,$i);
    if(ref($field) eq 'REF'){
	($field,$count)=GetSIPField($$$field,$pktinfo);
    }
    if(ref($field) eq 'ARRAY'){
	for($i=0;$i<=$#$field;$i++){
	    if( $field->[$i]->{$name} eq $val){ 
		return $field->[$i]->{val};
	    }
	}
    }
    else {
	if($field->{$name} eq $val){return $field->{val};}
    }
    return '';
}
# 
# 
sub FFIsExistParamValue2 {
    my($field,$name,$val,$name2,$rule,$pktinfo)=@_;
    my($count,$i);
    if(ref($field) eq 'REF'){
	($field,$count)=GetSIPField($$$field,$pktinfo);
    }
    if(ref($field) eq 'ARRAY'){
	for($i=0;$i<=$#$field;$i++){
	    if( $field->[$i]->{$name} eq $val){ 
		return $field->[$i]->{$name2};
	    }
	}
    }
    else {
	if($field->{$name} eq $val){return $field->{$name2};}
    }
    return '';
}

# 
sub FFHaveDuplicateElement {
    my($val)=@_;
    my(%seen,$ret);
    $ret=grep{$seen{$_}++} @$val;
    return $ret;
}

# 
sub FFIsBindVal {
    my($val)=@_;
    if(ref($val) eq 'ARRAY'){
	return -1<$#$val;
    }
    else {
	return $val;
    }
}

sub FFStripDQuot {
    my($val)=@_;
    $val =~ s/^"(.*)"$/$1/;
    return $val;
}
#sub FFCompareURI 
# 
#   
#   
#                   strict(
#                   ignore-userinfo(userinfo
#                   loose(
#   
sub FFCompareAddress {
    my ($part,$mode,$A_URI,$B_URI,$rule,$pktinfo,$context) = @_;
    my ($i);

    # 
    if(ref($A_URI) eq 'ARRAY' && ref($B_URI)){$A_URI=$A_URI->[0];}
    if(ref($B_URI) eq 'ARRAY' && ref($A_URI)){$B_URI=$B_URI->[0];}

    $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'URI',
				  'ARG1:'=>(ref($A_URI) eq 'HASH'?$A_URI->{txt}:$A_URI),
				  'ARG2:'=>(ref($B_URI) eq 'HASH'?$B_URI->{txt}:$B_URI)};

    if(ref($A_URI) eq 'ARRAY' && ref($B_URI) eq 'ARRAY'){
	if($#$A_URI ne $#$B_URI){return '';}
	for($i=0;$i<=$#$A_URI;$i++){
	    if($part eq 'HostPort'){
		if(!FFCompareHostPort($mode,$A_URI->[$i],$B_URI->[$i])){return '';}
	    }
	    else{
		if(!FFCompareUserInfoHostPort($mode,$A_URI->[$i],$B_URI->[$i])){return '';}
	    }
	}
	return 'match';
    }
    else{
	if($part eq 'HostPort'){
	    return FFCompareHostPort($mode,$A_URI,$B_URI);
	}
	else{
	    return FFCompareUserInfoHostPort($mode,$A_URI,$B_URI);
	}
    }
}

#  userinfo@hostport
#  1) 
#  2) 
#  3) 
#  4) userinfo(sip:)
#  5) port
#       mode:strict
#       mode:stricti
#  6) host
#       
sub FFCompareUserInfoHostPort {
    my ($mode,$A_URI,$B_URI) = @_;

    # 
    if(!ref($A_URI)){$A_URI=SIPMakeStruct($A_URI,\%STTo);$A_URI=$A_URI->{ad};}
    if(!ref($B_URI)){$B_URI=SIPMakeStruct($B_URI,\%STTo);$B_URI=$B_URI->{ad};}

    # 
    if( $A_URI->{ad}->{txt} eq $B_URI->{ad}->{txt} ){return 'match';}
    if($mode eq 'very-strict'){return '';}

    # userinfo
    if($mode eq 'ignore-userinfo'){
	if( $A_URI->{ad}->{userinfo} && $B_URI->{ad}->{userinfo} && 
	    ($A_URI->{ad}->{userinfo} ne $B_URI->{ad}->{userinfo}) ){return '';}
    }
    else{
	# 
	if( $A_URI->{ad}->{id} ne $B_URI->{ad}->{id} ){return '';}

	# userinfo
	if( $A_URI->{ad}->{userinfo} ne $B_URI->{ad}->{userinfo} ){return '';}
    }

    return FFCompareHostPort($mode,$A_URI->{ad}->{hostport},$B_URI->{ad}->{hostport});
}

#  hostport
#  1) 
#  2) port
#       mode:strict
#       mode:strict
#  3) host
#       
sub FFCompareHostPort {
    my ($mode,$A_URI,$B_URI) = @_;
    my ($a_host,$a_port,$b_host,$b_port,$host);

    # 
    if(!ref($A_URI)){$A_URI=SIPMakeStruct($A_URI,\%STHostport);}
    if(!ref($B_URI)){$B_URI=SIPMakeStruct($B_URI,\%STHostport);}

    # 
    if( $A_URI->{txt} eq $B_URI->{txt} ){return 'match';}
    elsif($mode eq 'very-strict'){return '';}

    # port
    if( $mode ne 'strict-without-port' && $A_URI->{port} ne $B_URI->{port} ){
	if($mode eq 'strict'){
	    return '';
	}
	else{
	    $a_port=$A_URI->{port}?$A_URI->{port}:(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
	    $b_port=$B_URI->{port}?$B_URI->{port}:(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
	    if( $a_port ne $b_port ){return '';};
	}
    }

    # host
    if( $A_URI->{host} eq $B_URI->{host} ){return 'match';}
    elsif($mode eq 'strict' || $mode eq 'name-strict' || $mode eq 'strict-without-port'){return '';}

    # AAAA
    $a_host=$A_URI->{host};
    if($a_host =~ /^\[(.+)\]$/){
	$a_host=$1;
    }
    elsif( $host = FindAAAA($a_host) ){
	$a_host=$host;
    }
    $b_host=$B_URI->{host};
    if($b_host =~ /^\[(.+)\]$/){
	$b_host=$1;
    }
    elsif( $host = FindAAAA($b_host) ){
	$b_host=$host;
    }
#    PrintItem($a_host);
#    PrintItem($b_host);
    # 
    if(lc($a_host) eq lc($b_host)){
       return('match');
   }

    return CompareFullADDRESS($a_host,$b_host);

}

sub FFCompareFullADDRESS {
    my ($A_ADDRESS,$B_ADDRESS,$rule,$pktinfo,$context) = @_;
    my($count1);

    if(ref($A_ADDRESS) eq 'ARRAY'){
	$count1=$#$A_ADDRESS + 1;
	if($count1<=1){$A_ADDRESS=$A_ADDRESS->[0];}
    }
    if(ref($B_ADDRESS) eq 'ARRAY'){
	$count1=$#$B_ADDRESS + 1;
	if($count1<=1){$B_ADDRESS=$B_ADDRESS->[0];}
    }

#    PrintItem($A_ADDRESS);

    $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'IPADDR', 'ARG1:'=>$A_ADDRESS, 'ARG2:'=>$B_ADDRESS};
    return CompareFullADDRESS($A_ADDRESS,$B_ADDRESS);
}

sub CompareFullADDRESS {
    my ($A_ADDRESS,$B_ADDRESS) = @_;
    my(@a_full_address,@b_full_address,$iii,$size);

#    PrintItem($A_ADDRESS);
#    PrintItem($B_ADDRESS);

    if($SIP_PL_IP eq 6){
	@a_full_address=IPv6StrToVal($A_ADDRESS);
	@b_full_address=IPv6StrToVal($B_ADDRESS);
	$size=8;
    }
    else{
	@a_full_address=split(/\./,$A_ADDRESS);
	@b_full_address=split(/\./,$B_ADDRESS);
	$size=4;
    }
    for($iii=0;$iii<$size;$iii++){
	if($a_full_address[$iii] ne $b_full_address[$iii]){return '';}
    }
    return 'match';
}

# Via
sub FFBranchUniqueAndSave {
    my ($param) = @_;
    my ($i,$notUnique);
    if(ref($param) eq 'ARRAY'){
	for($i=0;$i<=$#$param;$i++){
	    if( !FFBranchUniqueAndSave($param->[$i]) ){$notUnique='T';}
	}
	return !$notUnique;
    }
    else{
	if( grep {$_ eq $param} @CVA_TUA_BRANCH_HISTORY ){return '';}
	else{
	    push(@CVA_TUA_BRANCH_HISTORY,$param);
	    # 
	    if(!$DefVarDB{CVA_TUA_BRANCH_HISTORY}){$DefVarDB{CVA_TUA_BRANCH_HISTORY}=\@CVA_TUA_BRANCH_HISTORY;}
	    return 1;
	}
    }
}
# 
sub FFParseValid {
    my ($tag,$rule,$pktinfo)=@_;
    my($partInfo);
    ($pktinfo,$partInfo)=SipParsePart($pktinfo,$tag);

    if(ref($partInfo) eq 'ARRAY'){
	if( grep {$_->{parse}} @$partInfo ){return '';}
	return $partInfo;
    }
    else {
	return !$partInfo->{parse};
    }
}

# 
sub JoinKeyValue {
    my($fmt,$val,$key)=@_;
    my($msg,$i);
    if(ref($val) eq 'ARRAY'){
	for($i=0;$i<=$#$val;$i++){
	    if(ref($val->[$i]) eq 'HASH'){
		$msg .= sprintf($fmt,$val->[$i]->{$key});
	    }
	    else {
		$msg .= sprintf($fmt,$val->[$i]);
	    }
	}
    }
    elsif ($val){
	$msg= sprintf($fmt,$val);
    }
    return $msg;
}


# 
#   
#         
#   
#                         ['recv','RQ.Request-Line.method','INVITE'],0.5,['recv','RQ.Status-Line.code','180'],0.5);
sub FFMatchFrameOrder {
    my($start,$end,$interval)=@_;
    my($i,$j,$m,$startTime,$seqNo,$seqLast,$seqCount,$beforeTime,$diffTime,$dir,@cond,$unitMode,@result);
    if($start eq ''){$start =0;}
    if($end eq ''){$end = $#SIPPktInfo;}
    shift;shift;shift;

    $seqNo=0;
    $seqCount=0;
    # 
    # 
    if(($#_%2) ne 0){
	$seqLast=$#_-1;
    }
    else{
	$unitMode = 'lastCount';
	$seqLast=$#_;
    }
    if($seqLast<0){
	MsgPrint('ERR',"FFMatchFrameOrder Sequence order param illegal\n");
	return 0;
    }
    if($#SIPPktInfo<1 || ($end-$start+1)<$seqLast/2){
	MsgPrint('ERR',"FFMatchFrameOrder Capture packet(%s) is not enough\n",$end-$start);
	return 0;
    }
    $startTime=@SIPPktInfo[$start]->{timestamp};

    # 
    for($i=$start;$i<=$end;$i++){
	# 
	if($interval && $interval<@SIPPktInfo[$i]->{timestamp}-$startTime){last;}

	# 
	$dir =@_[$seqNo]->[0];
	undef @cond;
	for($j=1;$j<=$#{$_[$seqNo]};$j++){push(@cond,@{$_[$seqNo]}[$j]);}

	# 
        #   
	if( FVib($dir,$i,$i,'',@cond) eq '' ){
	    for($m=0;$m<=$#_;$m+=2){
		$dir =@_[$m]->[0];
		undef @cond;
		for($j=1;$j<=$#{$_[$m]};$j++){push(@cond,@{$_[$m]}[$j]);}
		if( FVib($dir,$i,$i,'',@cond) ){
		    MsgPrint('RULE',"FFMatchFrameOrder group pkt[%s] occuard in unit pattern\n",$i);
		    $seqNo=0;
		    $diffTime=0;
		    $unitMode='';
		    if($seqCount){
			return $seqCount,\@result;
		    }
		    undef @result;
		}
	    }
	    next;
	}

	# 
	if($diffTime && $diffTime<@SIPPktInfo[$i]->{timestamp}-$beforeTime){
	    # 
	    last;
	}

	# 
	$beforeTime=@SIPPktInfo[$i]->{timestamp};

	# 
	if($seqNo eq 0){
	    push(@result,$i);
	    if($unitMode eq 'firstCount'){
		$seqCount++;
	    }
	}

	# 
	if($seqNo eq $seqLast){
	    push(@result,$i);
	    $seqNo=0;
	    if($unitMode eq 'lastCount'){
		$seqCount++;
		$diffTime='';
	    }
	    else{
		$diffTime=@_[$seqNo+1];
		$unitMode = 'firstCount';
	    }
	}
	else{
	    # 
	    $seqNo+=2;
	}
    }
  EXIT:
    if($seqNo eq 0 && $unitMode eq 'firstCount'){$seqCount++;}
    return $seqCount,\@result;
}
# 
# 
# 
# FFIsExitFrameBetweenFrames('','',['recv','RQ.Request-Line.method','INVITE'],
#                                  ['recv','RQ.Status-Line.code','180'],
#                                  [['recv','RQ.Request-Line.method','ACK'],['recv','RQ.Request-Line.method','BYE']],100);
sub FFmustExitFrameBetweenFrames {
    my($start,$end,$startFrame,$endFrame,$matchFrame,$interval)=@_;
    my($i,$j,$m,$startTime,$dir,@cond,$startNo,$endNo,$match);
    
    if($start eq ''){$start =0;}
    if($end eq ''){$end = $#SIPPktInfo;}
    $startTime=@SIPPktInfo[$start]->{timestamp};

RETRY:
    # 
    for($i=$start;$i<=$end;$i++){
	# 
	if($interval && $interval<@SIPPktInfo[$i]->{timestamp}-$startTime){last;}

	#
	if($startNo eq ''){
	    $dir =$startFrame->[0];
	    undef @cond;
	    for($j=1;$j<=$#$startFrame;$j++){push(@cond,$startFrame->[$j]);}
	    $startNo=FVib($dir,$i,$i,'',@cond);
	    if($startNo ne ''){next;}
	}
	#
	if($startNo ne ''){
	    $dir =$endFrame->[0];
	    undef @cond;
	    for($j=1;$j<=$#$endFrame;$j++){push(@cond,$endFrame->[$j]);}
	    $endNo=FVib($dir,$i,$i,'',@cond);
	}
	if($endNo ne ''){last;}
    }
    if($startNo eq '' || $endNo eq ''){return $match;}

    for($i=$startNo;$i<=$endNo;$i++){
	for($j=0;$j<=$#$matchFrame;$j++){
	    $dir =$matchFrame->[$j]->[0];
	    undef @cond;
	    for($m=1;$m<=$#{$matchFrame->[$j]};$m++){push(@cond,@{$matchFrame->[$j]}[$m]);}
	    if(FVib($dir,$i,$i,'',@cond) ne ''){
		$start=$endNo;
		$startNo='';$endNo='';
		$match='OK';
		goto RETRY;
	    }
	}
    }
    return '';
}
# 
sub FFmustNotExitFrameBetweenFrames {
    my($start,$end,$startFrame,$endFrame,$matchFrame,$interval)=@_;
    my($i,$j,$m,$startTime,$dir,@cond,$startNo,$endNo,$match);
    
    if($start eq ''){$start =0;}
    if($end eq ''){$end = $#SIPPktInfo;}

    $startTime=@SIPPktInfo[$start]->{timestamp};

RETRY:
    # 
    for($i=$start;$i<=$end;$i++){
	# 
	if($interval && $interval<@SIPPktInfo[$i]->{timestamp}-$startTime){last;}

	#
	if($startNo eq ''){
	    $dir =$startFrame->[0];
	    undef @cond;
	    for($j=1;$j<=$#$startFrame;$j++){push(@cond,$startFrame->[$j]);}
	    $startNo=FVib($dir,$i,$i,'',@cond);
	    if($startNo ne ''){next;}
	}
	#
	if($startNo ne ''){
	    $dir =$endFrame->[0];
	    undef @cond;
	    for($j=1;$j<=$#$endFrame;$j++){push(@cond,$endFrame->[$j]);}
	    $endNo=FVib($dir,$i,$i,'',@cond);
	}
	if($endNo ne ''){last;}
    }
    if($startNo eq '' || $endNo eq ''){return $match;}

    for($i=$startNo;$i<=$endNo;$i++){
	for($j=0;$j<=$#$matchFrame;$j++){
	    $dir =$matchFrame->[$j]->[0];
	    undef @cond;
	    for($m=1;$m<=$#{$matchFrame->[$j]};$m++){push(@cond,@{$matchFrame->[$j]}[$m]);}
	    if(FVib($dir,$i,$i,'',@cond) ne ''){
		return '';
	    }
	}
    }
    $start=$endNo;
    $startNo='';$endNo='';
    $match='OK';
    goto RETRY;
}
# 
#   
sub MakeMaxSizeString {
    my($size,$fmt,$args,$valfmt)=@_;
    my($len,$i,$msg,$tmp);
    $len=$size-length(sprintf($fmt,@$args));
    for($i=0;$i<$len;$i++){
	$tmp = $tmp . pack('c',$i%10+0x30);
    }
    return $valfmt?sprintf($valfmt,$tmp):$tmp;
}

#============================================
# SIP
#============================================
sub StoreSIPPktInfo {
    my($pktinfo,$dir) = @_;
    if($dir){$pktinfo->{dir}=$dir;}
    elsif(!$pktinfo->{dir}){$pktinfo->{dir}='recv';}
    $pktinfo->{'pkt-type'}='SIP';
    $pktinfo->{'TAHI-NO'}=($pktinfo->{dir} eq 'send'? $V6evalTool::vSendPKT : $V6evalTool::vRecvPKT)-1;
    # 
    push(@SIPPktInfo,$pktinfo);
    if($SIP_PL_TARGET eq 'PX'){
	# 
	NDStorePktInfo($pktinfo);
    }
    # 
    if(!$SIPJudgmentRealMode){LogHTML($pktinfo);}
    # 
    if($pktinfo->{dir} ne 'send'){ $SIPPktInfoLast=$pktinfo; }
}
sub SIPPktInfoParse {
    my($i,$pktinfo,$partinfo,@stack);

    for($i=0;$i<=$#SIPPktInfo;$i++){
	if(!@SIPPktInfo[$i]->{command}){
	    ($pktinfo,$partinfo)=SipParsePart(@SIPPktInfo[$i]->{frame_txt},"COMMAND");
	    $pktinfo->{pkt}=@SIPPktInfo[$i]->{pkt};
	    $pktinfo->{timestamp}=@SIPPktInfo[$i]->{timestamp};
	    $pktinfo->{dir}=@SIPPktInfo[$i]->{dir};
	    $pktinfo->{'pkt-type'}=@SIPPktInfo[$i]->{'pkt-type'};
	    $pktinfo->{'index-no'}=@SIPPktInfo[$i]->{'index-no'};
	    @SIPPktInfo[$i]=$pktinfo;
	}
    }
    # 
    @SIPPktInfo = sort{$a->{timestamp} <=> $b->{timestamp}} @SIPPktInfo;
}
sub StoreRTPPktInfo {
    my($pktinfo,$dir,$tahino) = @_;
    if($dir){$pktinfo->{dir}=$dir;}
    elsif(!$pktinfo->{dir}){$pktinfo->{dir}='recv';}
    $pktinfo->{'pkt-type'}='RTP';
    $pktinfo->{'TAHI-NO'}=$tahino ? $tahino : (($pktinfo->{dir} eq 'send'? $V6evalTool::vSendPKT : $V6evalTool::vRecvPKT)-1);
    push(@RTPPktInfo,$pktinfo);
    # 
    if($pktinfo->{dir} ne 'send'){ $RTPPktInfoLast=$pktinfo; }
}
sub StoreDNSPktInfo {
    my($pktinfo,$dir) = @_;
    if($dir){$pktinfo->{dir}=$dir;}
    elsif(!$pktinfo->{dir}){$pktinfo->{dir}='recv';}
    $pktinfo->{'TAHI-NO'}=($pktinfo->{dir} eq 'send'? $V6evalTool::vSendPKT : $V6evalTool::vRecvPKT)-1;
    $pktinfo->{'pkt-type'}='DNS';
    push(@DNSPktInfo,$pktinfo);
}
sub StoreICMPPktInfo {
    my($pktinfo,$dir) = @_;
    if($dir){$pktinfo->{dir}=$dir;}
    elsif(!$pktinfo->{dir}){$pktinfo->{dir}='recv';}
    $pktinfo->{'TAHI-NO'}=($pktinfo->{dir} eq 'send'? $V6evalTool::vSendPKT : $V6evalTool::vRecvPKT)-1;
    $pktinfo->{'pkt-type'}='ICMP';
    push(@ICMPPktInfo,$pktinfo);
}
sub StoreNDPktInfo {
    my($pktinfo,$dir) = @_;
    if($dir){$pktinfo->{dir}=$dir;}
    elsif(!$pktinfo->{dir}){$pktinfo->{dir}='recv';}
    $pktinfo->{'TAHI-NO'}=($pktinfo->{dir} eq 'send'? $V6evalTool::vSendPKT : $V6evalTool::vRecvPKT)-1;
    $pktinfo->{'pkt-type'}='ND';
    push(@NDPktInfo,$pktinfo);
}
sub StoreTIMERInfo {
    my($delta,$comment,$pktinfo) = @_;
    my($info,$vals,$count,$val);
    if(!$pktinfo){
	if(2<=$#_){return;} # 
	$pktinfo=$SIPPktInfoLast;
	if(!$pktinfo){return;}
    }
    ($vals,$count,$val)=GetSIPField('TS',$pktinfo);
    $info->{'timestamp'}=$val+$delta;
    $info->{'pkt-type'}='TM';
    $info->{'comment'}=$comment;
    push(@TIMERInfo,$info);
}

# 
#   
sub MakeCapture {
    my($msg,$dir,$interval)=@_;
    my($pktinfo,$partinfo);
    if(!ref($msg)){
	($pktinfo,$partinfo)=SipParsePart($msg,'COMMAND');
    }
    else{$pktinfo=$msg;}
    if($DBG_StartTime eq ''){$DBG_StartTime=100;}
    else{$DBG_StartTime += $interval;}
    $pktinfo->{timestamp}=$DBG_StartTime;
    $pktinfo->{dir}=$dir;
    StoreSIPPktInfo($pktinfo);
    return $pktinfo;
}
sub DumpSIPPktInfo {
    my($frames)=@_;
    if($frames eq ''){$frames=\@SIPPktInfo};

    my($i,$method,$pktinfo,$partinfo,$startTime,$diffTime,$val,$key);
    SIPPktInfoParse();
    printf("-----Dump SIP Pktinfo----------\n");
    for($i=0;$i<=$#$frames;$i++){
	if($i eq 0){$startTime = $frames->[$i]->{timestamp};}
	$diffTime=$frames->[$i]->{timestamp}-$startTime;
	if($frames->[$i]->{'pkt-type'} eq 'SIP'){
	    $method=($frames->[$i]->{command}->{tag} eq 'Request-Line')?
		$frames->[$i]->{command}->{'Request-Line'}->{method}:
		"$frames->[$i]->{command}->{'Status-Line'}->{code} $frames->[$i]->{command}->{'Status-Line'}->{reason}";
	}
	else{
	    $method=$frames->[$i]->{'pkt-type'};
	}
	printf("[%02d:%5.2f] %s|%s \n",$i,$diffTime,($frames->[$i]->{dir} eq 'send'?'==>':'<=='),$method);
	while(($key,$val) = each(%{$frames->[$i]})){
	    if($key =~ /_TIMER/){printf("    [%s] %s\n",$key,$val);}
	    if($key =~ /_START/){printf("    [%s] %s\n",$key,$val);}
	    if($key =~ /_LAST/){printf("    [%s] %s\n",$key,$val);}
	    if($key =~ /_COUNT/){printf("    [%s] %s\n",$key,$val);}
	    if($key =~ /_DIFF/) {printf("    [%s] %s\n",$key,$val);}
	    if($key =~ /_BEFORE/){printf("    [%s] %s\n",$key,$val);}
	}
    }
}
# 
sub NDPKT {
    my($mypkt,$node,$searchDir,$dir,@cond)=@_;
    my($i,$j,$vals,$count,$val,$expr,$pkts);

    shift;shift;shift;shift;
    # 
    if(!$node || $node eq 'OTHER'){
	$node=NDGetOtherNode();
    }
    if($node eq 'MY'){
	$node=$SEQCurrentActNode;
    }
    elsif(!ref($node)){
	$node=$SIPNodeTbl{$node};
    }
    if(!$node){return '';}

    # 
    if(!$dir){$dir='send';}
    if(!$mypkt && !$searchDir){
	if($dir eq 'send'){return $node->{'LastSendPkt'};}
	else{return $node->{'LastSendPkt'};}
    }

    # 
    #   
    if($mypkt){
	if($val=FV('RQ.Request-Line.method','',$mypkt)){
	    @cond=('RQ.Request-Line.method',$val,@cond);
	}
	elsif($val=FV('RQ.Status-Line.code','',$mypkt)){
	    @cond=('RQ.Status-Line.code',$val,@cond);
	}
    }

    # 
    if($searchDir eq 'FIRST'){
	$pkts=$node->{'PKTS'};
	for($i=0;$i<=$#$pkts;$i++){
	    if( $pkts->[$i]->{dir} ne $dir ){next;}
	    for($j=0;$j<=$#cond;$j+=2){
		($vals,$count,$val)=GetSIPField(@cond[$j],$pkts->[$i]);
		$expr=@cond[$j+1];
		if(ref($expr) eq 'ARRAY'){
		    if( !grep{$_ eq $val} @$expr ){goto SKIP;}
		}
		elsif(ref($expr) eq 'SCALAR'){
		    if( eval($$expr) eq '' ){goto SKIP;}
		}
		elsif(ref($expr) eq 'REF'){ # 
		    if( $val !~ /$$$expr/ ){goto SKIP;}
		}
		else{
		    if($expr ne $val){goto SKIP;}
		}
	    }
	    return $pkts->[$i];
	  SKIP:
	    next;
	}
    }
    # 
    else {
	$pkts=$node->{'PKTS'};
	for($i=$#$pkts;0<=$i;$i--){
	    if( $pkts->[$i]->{dir} ne $dir ){next;}
	    for($j=0;$j<=$#cond;$j+=2){
		($vals,$count,$val)=GetSIPField(@cond[$j],$pkts->[$i]);
		$expr=@cond[$j+1];
		if(ref($expr) eq 'ARRAY'){
		    if( !grep{$_ eq $val} @$expr ){goto SKIP2;}
		}
		elsif(ref($expr) eq 'SCALAR'){
		    if( eval($$expr) eq '' ){goto SKIP2;}
		}
		elsif(ref($expr) eq 'REF'){ # 
		    if( $val !~ /$$$expr/ ){goto SKIP2;}
		}
		else{
		    if($expr ne $val){goto SKIP2;}
		}
	    }
	    return $pkts->[$i];
	  SKIP2:
	    next;
	}
    }
    return '';
}

#============================================
# ICMP
#============================================
sub ICMPFVib {
    my($dir,$start,$end,$field)=@_;
    my($cond,$i,$j);

    if($end eq '')   {$end = 0;}
    if($start eq '') {$start = $#ICMPPktInfo;}
    elsif($start < 0){$start = $#ICMPPktInfo+$start;}

    shift;shift;shift;shift;
    $cond = \@_;

    for($i=$start;$end<=$i;$i--){
	if($dir && @ICMPPktInfo[$i]->{dir} ne $dir ){next;}
	# 
	for($j=0;$j<=$#$cond;$j+=2){
	    if($cond->[$j] =~ /^Frame_/){
		if(@ICMPPktInfo[$i]->{pkt}->{$cond->[$j]} ne $cond->[$j+1]){goto NEXT;}
	    }
	    else{
		if(@ICMPPktInfo[$i]->{$cond->[$j]} ne $cond->[$j+1]){goto NEXT;}
	    }
	}
	# 
	if($field =~ /^Frame_/){
	    return @ICMPPktInfo[$i]->{pkt}->{$field};
	}
	return $field?@ICMPPktInfo[$i]->{$field}:$i;
      NEXT:
	next;
    }
    return '';
}

sub ICMPFVif {
    my($dir,$start,$end,$field)=@_;
    my($cond,$i,$j);

    if($end eq '') {$end = $#ICMPPktInfo;}
    elsif($end < 0){$start = $#ICMPPktInfo+$end;}
    if($start eq '') {$start = 0;}

    shift;shift;shift;shift;
    $cond = \@_;

    for($i=$start;$i<=$end;$i++){
	if($dir && @ICMPPktInfo[$i]->{dir} ne $dir ){next;}
	# 
	for($j=0;$j<=$#$cond;$j+=2){
	    if($cond->[$j] =~ /^Frame_/){
		if(@ICMPPktInfo[$i]->{pkt}->{$cond->[$j]} ne $cond->[$j+1]){goto NEXT;}
	    }
	    else{
		if(@ICMPPktInfo[$i]->{$cond->[$j]} ne $cond->[$j+1]){goto NEXT;}
	    }
	}
	# 
	if($field =~ /^Frame_/){
	    return @ICMPPktInfo[$i]->{pkt}->{$field};
	}
	return $field?@ICMPPktInfo[$i]->{$field}:$i;
      NEXT:
	next;
    }
    return '';
}
#============================================
# RTP
#============================================
sub RTPFVib {
    my($dir,$start,$end,$field)=@_;
    my($cond,$i,$j);

    if($end eq '')   {$end = 0;}
    if($start eq '') {$start = $#RTPPktInfo;}
    elsif($start < 0){$start = $#RTPPktInfo+$start;}

    shift;shift;shift;shift;
    $cond = \@_;

    for($i=$start;$end<=$i;$i--){
	if($dir && @RTPPktInfo[$i]->{dir} ne $dir ){next;}
	# 
	for($j=0;$j<=$#$cond;$j+=2){
	    if($cond->[$j] =~ /^Frame_/){
		if(@RTPPktInfo[$i]->{pkt}->{$cond->[$j]} ne $cond->[$j+1]){goto NEXT;}
	    }
	    else{
		if(@RTPPktInfo[$i]->{$cond->[$j]} ne $cond->[$j+1]){goto NEXT;}
	    }
	}
	# 
	if($field =~ /^Frame_/){
	    return @RTPPktInfo[$i]->{pkt}->{$field};
	}
	return $field?@RTPPktInfo[$i]->{$field}:$i;
      NEXT:
	next;
    }
    return '';
}
sub RTPFVif {
    my($dir,$start,$end,$field)=@_;
    my($cond,$i,$j);

    if($end eq '') {$end = $#RTPPktInfo;}
    elsif($end < 0){$start = $#RTPPktInfo+$end;}
    if($start eq '') {$start = 0;}

    shift;shift;shift;shift;
    $cond = \@_;

    for($i=$start;$i<=$end;$i++){
	if($dir && @RTPPktInfo[$i]->{dir} ne $dir ){next;}
	# 
	for($j=0;$j<=$#$cond;$j+=2){
	    if($cond->[$j] =~ /^Frame_/){
		if(@RTPPktInfo[$i]->{pkt}->{$cond->[$j]} ne $cond->[$j+1]){goto NEXT;}
	    }
	    else{
		if(@RTPPktInfo[$i]->{$cond->[$j]} ne $cond->[$j+1]){goto NEXT;}
	    }
	}
	# 
	if($field =~ /^Frame_/){
	    return @RTPPktInfo[$i]->{pkt}->{$field};
	}
	return $field?@RTPPktInfo[$i]->{$field}:$i;
      NEXT:
	next;
    }
    return '';
}


sub LogSIPPktInfo {
    my($i,$startTime,$diffTime,$name,$comment,$msg,@frames,$dir,$type,$pkt,$method,$code,$index,$conn,$info,$tlssession);
    
    SIPPktInfoParse();

    # 
    @frames=sort{$a->{timestamp} <=> $b->{timestamp}} (@SIPPktInfo,@RTPPktInfo,@DNSPktInfo,@ICMPPktInfo,@NDPktInfo,@TIMERInfo);
#    map{printf("Time:%s Dir:%s Name:%s\n",$_->{'timestamp'},$_->{'dir'},$_->{command}->{'Request-Line'}->{method});} @frames;

    vLogHTML('</TD></TR><TR bgcolor="#AAEEEE"><TD>Sequence</TD><TD><A NAME="SequenceSummary"></A><B>');
    vLogHTML("<pre>");

    vLogHTML("                        NUT    R    PX1   UA1   OT1   OT2   REG   DNS\n");
    vLogHTML(" No     time             |     |     |     |     |     |     |     | \n");

    for($i=0;$i<=$#frames;$i++){
	# 
	if($i eq 0){$startTime = @frames[$i]->{timestamp};}

	# 
	$diffTime=@frames[$i]->{timestamp}-$startTime;
	@frames[$i]->{'index-no'}=$i;

	$dir=@frames[$i]->{'dir'};
	$type=@frames[$i]->{'pkt-type'};
	if($type eq 'TM'){
	    $pkt='Timer';
	}
	else{
	    $pkt=$dir eq 'recv' ? @frames[$i]->{'pkt'}->{'recvFrame'}:@frames[$i]->{'pkt'}->{'sendFrame'};
	}
	# 
	$name='     ';
	if($type eq 'SIP'){
	    if(@frames[$i]->{command}->{tag} eq 'Request-Line'){
		$name=@frames[$i]->{command}->{'Request-Line'}->{method};
		$comment="@frames[$i]->{command}->{'Request-Line'}->{method} @frames[$i]->{command}->{'Request-Line'}->{uri}->{txt}";
		if($pkt eq 'SIPtoPROXY' && $name eq 'REGISTER' && $CNT_CONF{'REG-ADDRESS'} eq $CNT_CONF{'PX1-ADDRESS'}){$pkt='SIPtoREG';}
		if($pkt eq 'SIP4toPROXY' && $name eq 'REGISTER' && $CNT_CONF{'REG-ADDRESS'} eq $CNT_CONF{'PX1-ADDRESS'}){$pkt='SIP4toREG';}
	    }
	    else{
		$method=FVal('HD.CSeq.val.method',@frames[$i]);
		$name=@frames[$i]->{command}->{'Status-Line'}->{code};
		$comment="@frames[$i]->{command}->{'Status-Line'}->{code} @frames[$i]->{command}->{'Status-Line'}->{reason} ($method)";
	    }
	}
	elsif($type eq 'RTP'){
	    $comment=' RTP' . @frames[$i]->{'name'};
	}
	elsif($type eq 'DNS'){
	    $comment=" DNS(@frames[$i]->{'answer-mode'}) Q:@frames[$i]->{query}  A:@frames[$i]->{answer}";
	}
	elsif($type eq 'ND'){
	    if(@frames[$i]->{'name'}){
		$comment=' ' . @frames[$i]->{'name'};
		$comment = $comment . ' ' . ($SIPLOGO ? '' : $SIP_FRM_COMMENT_STR{$pkt}) ;
	    }
	    else{
		$comment=($pkt eq Ra_RouterToAllNode)?' RA':
		    (($pkt eq Ns_RouterToAllNode   || $pkt eq Ns_TermLtoRouterG || 
		      $pkt eq Ns_TermLtoRouterL || $pkt eq Ns_TermGtoRouterMultiL || $pkt eq Ns_TermGtoRouterMultiL_TL ||
		      $pkt eq Ns_TermLtoRouterMultiM)?' NS':
		     (($pkt eq Na_TermAtoRouterG || $pkt eq Na_TermAtoRouterGOpt ||
		       $pkt eq Na_RouterGToTermL || $pkt eq Na_RouterLToTermG || $pkt eq Na_RouterLToTermG_TL ||
		       $pkt eq Na_RouterLToTermL  || $pkt eq Na_RouterLToTermL)?' NA':
		      ' ND'));
		$comment = $comment . ' ' . $SIP_FRM_COMMENT_STR{$pkt} ;
	    }
	}
	elsif($type eq 'ICMP'){
	    if(@frames[$i]->{'name'}){$comment=' '.@frames[$i]->{'name'};}
	    elsif($pkt eq 'EchoRequestFromServ' || $pkt eq 'EchoRequest4FromServ'){$comment=' Echo Request';}
	    elsif($pkt eq 'EchoReplyToServ' || $pkt eq 'EchoReply4ToServ') {$comment=' Echo Reply';}
	    elsif($pkt eq 'ICMPErrorFromPROXY' || $pkt eq 'ICMPErrorFromOTHER1') {
		$code=@frames[$i]->{'pkt'}->{'Frame_Ether.Packet_IPv6.ICMPv6_DestinationUnreachable.Type'};
		$comment=($code eq 1)?' ICMP Unreachable':' ICMP Time Exceed';
	    }
	    elsif($pkt eq 'ICMP4ErrorFromPROXY' || $pkt eq 'ICMP4ErrorFromOTHER1') {
		$code=@frames[$i]->{'pkt'}->{'Frame_Ether.Packet_IPv4.ICMPv4_ANY.Type'};
		$comment=($code eq 1)?' ICMP Unreachable':' ICMP Time Exceed';
	    }
	    else{
		$comment='ICMP';
	    }
	}
	elsif($type eq 'TM'){
	    $comment=' ' . @frames[$i]->{'comment'};
	}

	# 
	unless($SIP_SEQ_ARROW_STR{$pkt}){
	    MsgPrint('WAR',"Unknown named packet(%s:%s:%s) skiped.\n",$type,$comment,$pkt);
	    next;
	}

	# 
	$conn = $frames[$i]->{'pkt'}->{'Connection'}->{'Trans'};
	if(!$conn){$conn='    ';}
	elsif($conn eq 'TCP'){
	    $conn=sprintf("T %02d",GetSOCKidToIndex($frames[$i]->{'pkt'}->{'Connection'}->{'SocketID'}));
	}
	elsif($conn eq 'TLS'){
	    $info=kPacket_ConnectInfo($frames[$i]->{'pkt'}->{'Connection'}->{'SocketID'});
	    $tlssession=GetTLSsessionToIndex($info->{'TLSsession'});
	    $conn=sprintf("S%01d%02d",$tlssession,GetSOCKidToIndex($frames[$i]->{'pkt'}->{'Connection'}->{'SocketID'}));
	}
	elsif($conn eq 'UDP'){
	    $conn='U   ';
	}
	# 
	$index=$type eq 'SIP' ? sprintf("SIP-%04d",$i+1):
	    sprintf("%s%s",$dir eq 'recv'?'vRecvPKT':'vSendPKT',@frames[$i]->{'TAHI-NO'});
	$msg = sprintf("[<A NAME=\"SEQ-%04d\"></A><A HREF=\"#%s\">%04d</A>:%6.2f|%4.4s] %-5.5s %s %s\n",
		       @frames[$i]->{'TAHI-NO'},$index,$i+1,$diffTime,$conn,$name,$SIP_SEQ_ARROW_STR{$pkt},$comment);
	vLogHTML($msg);
    }
    vLogHTML('</pre></B>');
}

# TAHI
sub SIPRegistCheckPacketAfter {
    my($func)=@_;
    $SIPCheckPacketAfter=$func;
}

# TAHI
sub RecoverTahiPackets {
  m($pkt,$link,$recvFrames,$count);
  my($frameName,$type,$srcAddr,$dstAddr,$srcPort,$dstPort,$srcMac,$dstMac,$inet,$msg,$msg2,$timeStamp);
  my(@nodes,$nd,$fname,$pktinfo,$ndp,$icmp,$timeout,$name,$code);
  my($mode,$query,$answer,%rtp,$contCheck);

  if(!$SIPLOGO){return;}
  $link='Link0';
  $recvFrames=['SIPtoDNS','SIP4toDNS','SIPany','SIP4any','RTPany','RTP4any'];

  while(1){
      
      # TAHI
      $pkt = {};
      %$pkt = V6evalTool::vRecv2SIP($link, 1, 0, 1, @$recvFrames );    
      
      # 
      if( $pkt->{'status'} && $pkt->{'status'} ne 2 ){
	  printf("TAHI recived packets all recovery[%s][%s]\n",$count,$pkt->{'status'});
	  last;
      }
      # 
      $srcMac=$pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'};
      $dstMac=$pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'};
      $srcAddr=$pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'};
      $dstAddr=$pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'};
      $srcPort=$pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.SourcePort'};
      $dstPort=$pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.DestinationPort'};
      $ndp=$pkt->{'Frame_Ether.Packet_IPv6.ICMPv6_NS.Type'} ||
	  $pkt->{'Frame_Ether.Packet_IPv6.ICMPv6_NA.Type'} ||
	  $pkt->{'Frame_Ether.Packet_IPv6.ICMPv6_RA.Type'} ||
	  $pkt->{'Frame_Ether.Packet_IPv6.ICMPv6_RS.Type'};
      $icmp=$pkt->{'Frame_Ether.Packet_IPv6.ICMPv6_DestinationUnreachable.Type'} ||
	  $pkt->{'Frame_Ether.Packet_IPv6.ICMPv6_EchoReply.Type'} ||
	  $pkt->{'Frame_Ether.Packet_IPv6.ICMPv6_EchoRequest.Type'} ;
      $inet=$pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP'}?'UDP':'';
      $timeStamp=$pkt->{'recvTime1'} || $pkt->{'sendTime1'};
      $fname=$pkt->{'recvFrame'} || $pkt->{'sendFrame'};
      $msg=$pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_SIP.message'};

      MsgPrint('HTML',"FNAME[%s] ICMP[%s] NDP[%s] addr[%s][%s] port[%s:%s]\n",
	       $fname,$icmp,$ndp,$srcAddr,$dstAddr,$srcPort,$dstPort);

      # DNS
      if($fname =~ /DNS/ || $srcPort eq 53 || $dstPort eq 53){
	  # 
	  ($fname,$dir)=GetLineNameFromAddr($srcAddr,$dstAddr);
	  $mode=$pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DNS.QR'} ? 'reply' : 'query';
	  if($dir){
	      $pkt->{'recvFrame'}=$dir eq 'send' ? 'DNStoTARGET' : 'TARGETtoDNS';
	  }
	  else{
	      $pkt->{'recvFrame'}=$mode eq 'reply' ? 'DNStoTARGET' : 'TARGETtoDNS';
	  }
	  $query=$pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DNS.DNS_Question.DNS_QuestionEntry.Name'};
	  if($mode eq 'reply'){
	      $answer=$pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_DNS.DNS_Answer.DNS_RR_AAAA.Address'};
	      unless($answer){$answer='No Host';}
	  }
	  else{
	      $answer='';
	  }
	  StoreDNSPktInfo({'pkt'=>$pkt,'timestamp'=>$timeStamp,'dir'=>'recv','answer-mode'=>$mode,'query'=>$query,'answer'=>$answer});
	  MsgPrint('HTML',"  DNS[%s] answer[%s]\n", $pkt->{'recvFrame'},$answer);
      }
      # SIP
      #   SIP
      #   
      elsif($fname =~ /SIP/ || $msg || $srcPort eq 5060 || $srcPort eq 5061 || $dstPort eq 5060 || $dstPort eq 5061){
	  unless($msg){
	      MsgPrint('ERR',"RecoverTahiPackets similar SIP[%s]. but empty sip message\n",$fname);
##	      PrintVal($pkt);
	      next;
	  }
	  # 
	  MsgPrint('HTML',"  SIP\n");
	  foreach $pktinfo (@SIPPktInfo){
	      $msg =~ s/[\n\r]//g;
	      $msg2 = $pktinfo->{'frame_txt'};
	      $msg2 =~ s/[\n\r]//g;
	      if($msg eq $msg2 && !$pktinfo->{'tahino-seted'}){
		  # TAHI
		  $pktinfo->{'TAHI-NO'}=($pkt->{'sendFrameIndex'} || $pkt->{'recvFrameIndex'});
		  $pktinfo->{'tahino-seted'}='T';
		  MsgPrint('HTML',"  matched sip(%s) TAHI[%s] <=> KOI[%s]\n",
			   $pktinfo->{dir},$pkt->{'sendFrameIndex'}||$pkt->{'recvFrameIndex'},$pktinfo->{'TAHI-NO'});
		  last;
	      }
	  }
      }
      elsif($ndp || $fname =~ /Ns/ || $fname =~ /Na/ || $fname =~ /Ra/){
	  if($ndp eq 133){$name='RS';}
	  if($ndp eq 134){$name='RA';}
	  if($ndp eq 135){$name='NS';}
	  if($ndp eq 136){$name='NA';}
	  ($fname,$dir)=GetLineNameFromAddr($srcAddr,$dstAddr);
	  $pkt->{'recvFrame'} = $dir eq 'send' ? 'RtoTARGET' : 'TARGETtoR';
	  # 
	  StoreNDPktInfo({'pkt'=>$pkt,'timestamp'=>$timeStamp,'dir'=>'recv','name'=>$name});
	  MsgPrint('HTML',"  NDP(%s) [%s][%s]\n",$name,$fname,$dir);
      }
      elsif($fname =~ /ICMP/ || $icmp){
	  # 
	  ($fname,$dir)=GetLineNameFromAddr($srcAddr,$dstAddr);
	  $pkt->{'recvFrame'} = $fname ? $fname : 'ICMPErrorFromPROXY';
	  if($icmp eq 1){
	      $name='Unreachable';
	      $code=$pkt->{'Frame_Ether.Packet_IPv6.ICMPv6_DestinationUnreachable.Code'};
	      $name .= '(' . ($code eq 0 ? 'no route':($code eq 1 ? 'prohibited':($code eq 3 ? 'address':'port'))) . ')';
	  }
	  if($icmp eq 128){$name='Echo Request';}
	  if($icmp eq 129){$name='Echo Reply';}
	  StoreICMPPktInfo({'pkt'=>$pkt,'timestamp'=>$timeStamp,'dir'=>'recv','name'=>$name});
	  MsgPrint('HTML',"  ICMP(%s) [%s][%s]\n",$name,$pkt->{'recvFrame'},$dir);
      }
      # RTP
      #  RTP
      elsif($fname =~ /RTP/ || $inet eq 'UDP'){
	  ($fname,$dir)=GetLineNameFromAddr($srcAddr,$dstAddr);
	  # 
	  if($fname){
	      if(!$rtp{$dir}->{'lasttime'} || ($SIP_RTP_RECOGNIZE_TIME < $timeStamp - $rtp{$dir}->{'lasttime'})){
		  # 
		  if($rtp{$dir}->{'lastpkt'}){
		      $rtp{$dir}->{'lastpkt'}->{'recvFrame'} =  $dir eq 'send' ? 'RTPfromTERM-E' : 'RTPtoTERM-E';
		      StoreRTPPktInfo({'pkt'=>$rtp{$dir}->{'lastpkt'},'timestamp'=>$rtp{$dir}->{'lasttime'},
				       'dir'=>'recv','name'=>'(end)'},'',
				      $rtp{$dir}->{'lastpkt'}->{'recvFrameIndex'});
		      MsgPrint('HTML',"  RTP(end) [%s][%s]\n",$rtp{$dir}->{'lastpkt'}->{'recvFrame'},$dir);
		  }
		  # 
		  $pkt->{'recvFrame'} = $dir eq 'send' ? 'RTPfromTERM-S' : 'RTPtoTERM-S';
		  StoreRTPPktInfo({'pkt'=>$pkt,'timestamp'=>$timeStamp,'dir'=>'recv','name'=>'(start)'});
		  MsgPrint('HTML',"  RTP(start) [%s][%s]\n",$pkt->{'recvFrame'},$dir);
	      }
	      else{
##		  printf("RTP XXXXXXX[%s] [%s][%s]\n",$timeStamp,$fname,$dir);
	      }
	      $rtp{$dir}->{'lastpkt'}=$pkt;
	      $rtp{$dir}->{'lasttime'}=$timeStamp;
	  }
	  else{
	      MsgPrint('WAR',"Unknown RTP received. [%s]=>[%s]\n",$srcAddr,$dstAddr);
	  }
      }
      else{
	  MsgPrint('WAR',"Unknown packet(%s) received. [%s]=>[%s]\n",$fname,$srcAddr,$dstAddr);
      }

      if(!$contCheck && $SIPCheckPacketAfter && IsFunction($SIPCheckPacketAfter)){
	  $contCheck=$SIPCheckPacketAfter->($pkt);
      }

      $count++;
  }
  # 
  if($rtp{'recv'}->{'lastpkt'}){
      $dir='recv';
      $rtp{$dir}->{'lastpkt'}->{'recvFrame'} =  'RTPtoTERM-E';
      StoreRTPPktInfo({'pkt'=>$rtp{$dir}->{'lastpkt'},'timestamp'=>$rtp{$dir}->{'lasttime'},'dir'=>'recv','name'=>'(end)'},'',
		      $rtp{$dir}->{'lastpkt'}->{'recvFrameIndex'});
  }
  if($rtp{'send'}->{'lastpkt'}){
      $dir='send';
      $rtp{$dir}->{'lastpkt'}->{'recvFrame'} =  'RTPfromTERM-E';
      StoreRTPPktInfo({'pkt'=>$rtp{$dir}->{'lastpkt'},'timestamp'=>$rtp{$dir}->{'lasttime'},'dir'=>'recv','name'=>'(end)'},'',
		      $rtp{$dir}->{'lastpkt'}->{'recvFrameIndex'});
  }
}

# 
sub GetLineNameFromAddr {
    my($srcAddr,$dstAddr)=@_;
    my(@nodes,$nd,$from,$to,$dir,$linklocal);

    @nodes=keys(%SIPNodeTbl);

    foreach $nd (@nodes){
	if($SIP_PL_IP eq 4){
	    if(IPv4EQ($SIPNodeTbl{$nd}->{'AD'},$srcAddr)){
		$from=$nd;
	    }
	    if(IPv4EQ($SIPNodeTbl{$nd}->{'AD'},$dstAddr)){
		$to=$nd;
	    }
	}
	else{
	    if(IPv6EQ($SIPNodeTbl{$nd}->{'AD'},$srcAddr)){
		$from=$nd;
	    }
	    if(IPv6EQ($SIPNodeTbl{$nd}->{'AD'},$dstAddr)){
		$to=$nd;
	    }
	}
    }
    if($from){
	$dir = 'send';
	return $from . 'to' . 'TARGET', $dir;
    }
    if($to){
	$dir = 'recv';
	return 'TARGET' . 'to' . $to, $dir;
    }
    if($SIP_PL_IP eq 6){
	$linklocal=GenerateIPv6FromMac($V6evalTool::NutDef{'Link0_addr'},'fe80::');
	if(IPv6EQ($linklocal,$dstAddr)){
	    $dir = 'send';
	    return 'UA1' . 'to' . 'TARGET', $dir;
	}
	if(IPv6EQ($linklocal,$srcAddr)){
	    $dir = 'recv';
	    return 'TARGET' . 'to' . 'UA1', $dir;
	}
	$linklocal=GenerateIPv6FromMac($V6evalTool::TnDef{'Link0_addr'},'fe80::');
	if(IPv6EQ($linklocal,$dstAddr)){
	    $dir = 'recv';
	    return 'TARGET' . 'to' . 'UA1', $dir;
	}
	if(IPv6EQ($linklocal,$srcAddr)){
	    $dir = 'send';
	    return 'UA1' . 'to' . 'TARGET', $dir;
	}
	if(IPv6EQ($CVA_TUA_IPADDRESS,$srcAddr)){
	    $dir = 'recv';
	    return 'CVA_TUA_IPADDRESS' . 'to' . 'UA1', $dir;
	}
	if(IPv6EQ($CVA_TUA_IPADDRESS,$dstAddr)){
	    $dir = 'send';
	    return 'UA1' . 'to' . 'TARGET', $dir;
	}
    }
    MsgPrint('WAR',"Unknown packet recive [%s]=>[%s]\n",$srcAddr,$dstAddr);
    return '';
}

# SIP
sub GetSIPPktInfoIndex {
    my($index) = @_;
    my($i);
    # 
    if($index eq ''){
	return $SIPPktInfoLast;
    }
    elsif($index eq 'FIRST'){
	for($i=0;$i<=$#SIPPktInfo;$i++){
	    if( @SIPPktInfo[$i]->{dir} eq 'send' ){next;}
	    return @SIPPktInfo[$i];
	}
	return '';
    }
    # 
    elsif($index eq 'LAST'){
	return $SIPPktInfoLast;
    }
    elsif($index =~ /^[0-9]+$/){
	return @SIPPktInfo[$index];
    }
    # 
    else {
	for($i=$#SIPPktInfo;0<=$i;$i--){
	    if( @SIPPktInfo[$i]->{dir} eq 'send' ){next;}
	    if($index eq 'REQUEST'){
		if( @SIPPktInfo[$i]->{command}->{tag} eq 'Request-Line' ){return @SIPPktInfo[$i];}
	    }
	    elsif($index eq 'STATUS'){
		if( @SIPPktInfo[$i]->{command}->{tag} eq 'Status-Line' ){return @SIPPktInfo[$i];}
	    }
	    else{
		if( @SIPPktInfo[$i]->{command}->{@SIPPktInfo[$i]->{command}->{tag}}->{method} eq $index )
		{return @SIPPktInfo[$i];}
	    }
	}
    }
}

sub GetSOCKidToIndex {
    my($sockid)=@_;
    my(@keys,$index);
    if( $SOCKidINDEX{$sockid} ) {return $SOCKidINDEX{$sockid};}
    @keys=keys(%SOCKidINDEX);
    $index=$#keys+2;
    $SOCKidINDEX{$sockid}=$index;
    return $index;
}
# TLS ID
sub GetTLSsessionToIndex {
    my($tlssession)=@_;
    my(@keys,$index);
    if( $TLSsessionINDEX{$tlssession} ) {return $TLSsessionINDEX{$tlssession};}
    @keys=keys(%TLSsessionINDEX);
    $index=$#keys+2;
    $TLSsessionINDEX{$tlssession}=$index;
    return $index;
}

# 
#   
#        
sub PKT {
    my($searchDir,$dir)=@_;
    my($i,$j,$vals,$count,$val,$expr);

    shift;shift;
    if($searchDir eq 'LAST'){
	for($i=$#SIPPktInfo;0<=$i;$i--){
	    if( @SIPPktInfo[$i]->{dir} ne $dir ){next;}
	    for($j=0;$j<=$#_;$j+=2){
		($vals,$count,$val)=GetSIPField(@_[$j],@SIPPktInfo[$i]);
		$expr=@_[$j+1];
		if(ref($expr) eq 'ARRAY'){
		    if( !grep{$_ eq $val} @$expr ){goto SKIP;}
		}
		elsif(ref($expr) eq 'SCALAR'){
		    if( eval($$expr) eq '' ){goto SKIP;}
		}
		elsif(ref($expr) eq 'REF'){ # 
		    if( $val !~ /$$$expr/ ){goto SKIP;}
		}
		else{
		    if($expr ne $val){goto SKIP;}
		}
	    }
	    return @SIPPktInfo[$i];
	  SKIP:
	    next;
	}
    }
    else{
	for($i=0;$i<=$#SIPPktInfo;$i++){
	    if( @SIPPktInfo[$i]->{dir} ne $dir ){next;}
	    for($j=0;$j<=$#_;$j+=2){
		($vals,$count,$val)=GetSIPField(@_[$j],@SIPPktInfo[$i]);
		$expr=@_[$j+1];
		if(ref($expr) eq 'ARRAY'){
		    if( !grep{$_ eq $val} @$expr ){goto SKIP;}
		}
		elsif(ref($expr) eq 'SCALAR'){
		    if( eval($$expr) eq '' ){goto SKIP;}
		}
		elsif(ref($expr) eq 'REF'){ # 
		    if( $val !~ /$$$expr/ ){goto SKIP;}
		}
		else{
		    if($expr ne $val){goto SKIP;}
		}
	    }
	    return @SIPPktInfo[$i];
	  SKIP:
	    next;
	}
    }
    return '';
}

#============================================
# 
#============================================


# HEX
sub SD_BinHEX {
    my($hexmsg,$link,$frame)=@_;
    my($msg,$result);
    if( $frame eq '' ){ $frame='SIPfromTERM'; }
    if( $link eq ''){ $link=$SIP_Link; }

    # HEX
    $msg=pack("H*",$hexmsg);

    # 
    $result = SD_SIP($msg,$frame,'',$link);
    MsgPrint('SEQ',"SD_BinHEX result[$result]\n");
    return $result;
}

sub TimeInterval {
    my($timeout,$waitMode)=@_;
    # 
    if($SIP_TimeIntervalStart eq ''){
	$SIP_TimeIntervalStart=time();
	if($waitMode eq 'waiting'){goto WAIT;}
	return 'OK';
    }
    if( (time()-$SIP_TimeIntervalStart)<$timeout ){
	if($waitMode eq 'waiting'){goto WAIT;}
	return 'OK';
    }
    return '';
WAIT:
    while((time()-$SIP_TimeIntervalStart)<$timeout){
	sleep(1);
    }
    return '';
}

sub SimulateTarget {
    my($seqfile) = @_;
    my($msg,$simmode);

    if($V6evalTool::CommandLine =~ /^(\S+?) -pkt/){
	$SIP_SEQ_FILE=$1;
	MsgPrint('SEQ',"Sequence file[%s] start\n",$SIP_SEQ_FILE);
    }
    if($CNT_CONF{'SIMULATE-Tagret'}){
	if(!$seqfile && $V6evalTool::TestTitle =~ /SimulateUA\s+(.+)$/ ){
	    $simmode='UA';
	    $seqfile = $1;
	}
	if(!$seqfile && $V6evalTool::TestTitle =~ /SimulatePX\s+(.+)$/ ){
	    $simmode='PX';
	    $seqfile = $1;
	}
	if($seqfile){
	    $msg = sprintf("SIP tagert simulation mode. Simulation file[%s.pm]",$seqfile);
	    vLogHTML('<font color="red">' . $msg . '</font><BR>');
	    MsgPrint('SEQ',$msg . "\n");
#	    eval( "require \"$seqfile.pm\"");
#	    if($@){MsgPrint('ERR',"$seqfile.pm load error.(File not exist or syntax error)\n");ExitToV6evalTool($V6evalTool::exitFatal);}
	    eval( "require SIMTarget");
	    if($@){MsgPrint('ERR',"SIMTarget.pm load error.\n");ExitToV6evalTool($V6evalTool::exitFatal);}
	    SIMFileLoad($seqfile);
	    if($simmode eq 'PX'){
		$SIM_NONAUTO_REGISTER='T';
	    }
	    $CNT_CONF{'SIMULATE-MODE'}='ON';
	}
    }
}

sub ExitToV6evalTool {
    my($code)=@_;
    $ExitToV6evalTool=$code;
    printf("#############  ExitToV6evalTool [%s]\n",$ExitToV6evalTool);
    exit $code;
}

END {
    printf("#############  END block [%s]\n",$ExitToV6evalTool);

    $ExitToV6evalTool = $V6evalTool::exitInitFail if($ExitToV6evalTool eq '');
    $code = 'FATAL'    if($ExitToV6evalTool eq $V6evalTool::exitFatal);
    $code = 'FAIL'     if($ExitToV6evalTool eq $V6evalTool::exitFail);
    $code = 'INITFAIL' if($ExitToV6evalTool eq $V6evalTool::exitInitFail);
    $code = 'IGNORE'   if($ExitToV6evalTool eq $V6evalTool::exitIgnore);
    $code = 'PASS'     if($ExitToV6evalTool eq $V6evalTool::exitPass);
    $code = 'WARN'     if($ExitToV6evalTool eq $V6evalTool::exitWarn);
    vLogHTML('<TR><TD>Result</TD><TD>' . $code . '</TD></TR>');

    exit $ExitToV6evalTool;
}

1

