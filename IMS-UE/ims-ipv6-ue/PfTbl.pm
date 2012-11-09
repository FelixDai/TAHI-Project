#!/usr/bin/perl
# @@ -- LOG.pm --
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

# use strict;

# 
# 09/1/27  bytecode
# 08/12/19 MkSeqLineInfo 
#          kPacket_Close 
# 08/11/28 PrintVal 
#          STDOUT
# 08/9/19 CtCnFind  sigcomp
# 08/4/18 CtCnDump
# 08/4/16 CtCnClose 
#  kCommon::kPacket_Close

#============================================
# 
#============================================

# HTML
# 
#  
#
#  RULE:
#  GUI:GUI

## DEF.VAR
#
# @IKLogLevel=('ERR','WAR','ACT','TCP','PRMT','SSL','LAY');
@IKLogLevel=('ERR','WAR');

# @IKLogLevel=('ERR','WAR','RULE','AUTH','RAD','PKT','IO','ACT','GUI','HEX','PRMT','STATISTICS',
#              'SEQ','INIT','TCP','LAY','SSL','SSLAUTH');

# 
$PKTMAX=3;
# 
$DIFFTIMEFMT='6.2';

## DEF.END

sub CtLgLevel {
    my($level)=@_;
    return grep{$_ eq $level} @IKLogLevel;
}

sub CtLgSetLevel {
    my($level,$logtime)=@_;
    # 
    $LAST_MSG_TIME = ($logtime || CtTbCfg('DEBUG','logtime')) ? '' : [Time::HiRes::gettimeofday()];
    return unless($level);
    @IKLogLevel=(@IKLogLevel,split(',',$level));
}
sub CtLgAddLevel {
    my($level)=@_;
    push(@IKLogLevel,$level);
}

#============================================
# 
#============================================
# 
#   defpktdump: 
#   defpktdump: 
#   pktmaxsize: 
#   seqinfo:    
#   margePktRule: 
#   diffTime: 
sub CtLgRegSeq {
    my($defseq,$defpktdump,$pktmaxsize,$seqinfo,$margePktRule,$diffTime)=@_;
    CtTbCtiSet('SC,LOGTMP,SEQ',$defseq,'T');
    CtTbCtiSet('SC,LOGTMP,PKTDUMP',$defpktdump,'T');
    CtTbCtiSet('SC,LOGTMP,SEQINFO',$seqinfo,'T');
    CtTbCtiSet('SC,LOGTMP,MARGEPKTRULE',$margePktRule,'T');
    if($pktmaxsize){$PKTMAX=$pktmaxsize;}
    if($diffTime){$DIFFTIMEFMT=$diffTime;}
}

# $nodeIntv(
#   
# sub CtSvEnd {
#     my($titleline,$secondline,$linedb,$seq);
#     ($titleline,$secondline,$linedb)=MkSeqLine(['SSLC','PEER'],'PEER',6);
#     $seq={
# 	'HD'=>[ {'fmt'=>"                         $titleline\n",'arg'=>''}
# 		,{'fmt'=>"                           $secondline\n",'arg'=>''}],
# 	'FT'=>[ {'fmt'=>'','arg'=>''}],
# 	'LINE'=>{'fmt'=>"%s%-14.14s%s%s %s",'arg'=>[\q{($PKT->{Type} eq 'UN')?'<font color="orange">':''},\q{$NM},
# 						    \q{($PKT->{Type} eq 'UN')?'</font>':''},\q{$LINE},\q{$PKT->{Comment}}]},
# 	'LINEDB'=>$linedb,};
#     CtLgRegSeq($seq);
# }
sub MkSeqLineInfo {
    my($nodes,$order,$target,$nodeIntv,$sameIntv)=@_;
    my(@nodeorder,$name,$nd,$names,$intv,$nofirst,$same);

    # 
    foreach $name (@$order){
	@$names=();

	# 
	foreach $nd (@$nodes){
	    if($nd =~ /^$name[0-9]*$/){
		push(@$names,$nd);
	    }
	}
	if($#$names<0){next;} 

	# 
	$intv=($#$names eq 0) ? $nodeIntv : $sameIntv->{$name};
	$same=($#$names) * ($sameIntv->{$name}+1);

	# 
	map{ push(@nodeorder,{'ND'=>$_,'INTV'=>$intv}) } sort @$names;

	# 
	@nodeorder[$#nodeorder]->{'INTV'}=$nodeIntv;
	if($nofirst){
	    @nodeorder[$#nodeorder]->{'CENT'}='@'.'|' x ($nodeIntv + $same);
	}
	else{
	    if($same){
		@nodeorder[$#nodeorder]->{'CENT'}='@'.'|' x $same . ' ' x ($nodeIntv/2) ;
	    }
	    else{
		@nodeorder[$#nodeorder]->{'CENT'}='@'.'|' x 5 . ' ' x ($nodeIntv/2-1) ;
	    }
	}
	$nofirst='T';
    }
    return \@nodeorder;
}

#  
sub MkSeqLineUnit {
    my($nodeorder,$start,$end,$barAttr)=@_;
    my($ln,$line,$nofirst,$nd,$last,$name,@name,$bar);

    if($#$nodeorder<0){return;}
    $last=$nodeorder->[$#$nodeorder]->{'ND'};
    $bar='-';
    if($start eq 'NODENAME'){
	foreach $nd (@$nodeorder){
	    if($nd->{'CENT'}){
# 
#		$nd->{'ND'} =~ /^(.+?)[0-9]*$/;
#		$name=$1;
#		push(@name,$name);
		$line .= $nd->{'CENT'};
		push(@name,$nd->{'ND'});
	    }
	}
##	printf("%s\n",$line);
	$line=FormatLine($line,@name);
	return $line;
    }

    foreach $nd (@$nodeorder){
	$name=$nd->{'ND'};
	if($nd->{'ND'} eq $start){
	    if($nofirst){ $line .= $ln ? $bar : ' ';  }
	    if($barAttr->{$name}){$bar = $barAttr->{$name};}
	    $ln = !$ln;
	    $line .= '|' . ($last eq $nd->{'ND'} ? '' : (($ln ? $bar x ($nd->{'INTV'}-1) : ' ' x ($nd->{'INTV'}-1))));
	}
	elsif($nd->{'ND'} eq $end){
	    if($nofirst){ $line .= $ln ? '>' : ' ';  }
	    if($barAttr->{$name}){$bar = $barAttr->{$name};}
	    $ln = !$ln;
	    $line .= '|' . ($last eq $nd->{'ND'} ? '' : (($ln ? '<' . ($bar x ($nd->{'INTV'}-2)) : ' ' x ($nd->{'INTV'}-1))));
	}
	else{
	    if($nofirst){ $line .= $ln ? $bar : ' ';  }
	    if($barAttr->{$name}){$bar = $barAttr->{$name};}
	    $line .= '|' . ($last eq $nd->{'ND'} ? '' : (($ln ? $bar x ($nd->{'INTV'}-1) : ' ' x ($nd->{'INTV'}-1))));
	}
	$nofirst='T';
    }
    return $line;
}

# 
sub MkSeqLine {
    my($order,$target,$nodeIntv,$sameIntv)=@_;
    my(@nodes,$nodeorder,$line,@linedb,$titleline,$secondline,$nd);

    foreach $nd (@NDNodeTbl){push(@nodes,$nd->{'ID'});}

    # 
    $nodeorder = MkSeqLineInfo(\@nodes,$order,$target,$nodeIntv,$sameIntv);

    # 
    $titleline=MkSeqLineUnit($nodeorder,'NODENAME');
##    printf("%s\n",$titleline);
    $secondline=MkSeqLineUnit($nodeorder);
##    printf("%s\n",$secondline);
    foreach $nd (@$nodeorder){
	if($nd->{'ND'} eq $target){next;}
	$line=MkSeqLineUnit($nodeorder,$nd->{'ND'},$target);
##	printf("%s\n",$line);
	push(@linedb,{'pat'=>'^'.$nd->{'ND'}.':'.$target.'$','marker'=>$line});
	$line=MkSeqLineUnit($nodeorder,$target,$nd->{'ND'});
##	printf("%s\n",$line);
	push(@linedb,{'pat'=>'^'.$target.':'.$nd->{'ND'}.'$','marker'=>$line});
    }
    return $titleline,$secondline,\@linedb;
}

#============================================
# 
#============================================
#   
# 	'HD'=>[{'fmt'=>'','arg'=>''},{'fmt'=>'','arg'=>''}],
# 	'FT'=>[{'fmt'=>'','arg'=>''},{'fmt'=>'','arg'=>''}],
# 	'LINE'=>{'fmt'=>'','arg'=>''},
# 	'LINEDB'=>[{'pat'=>'','marker'=>''},{'pat'=>'','marker'=>''}],
#     };
sub CtLgSeq {
    my($pkts,$nojudgecheck)=@_;
    my($defseq,$line,@args,$arg,$val,%context,$fmt,$msg,$marker,$startTime,$diffTime);

    # 
    my($NO,$TS,$FR,$NM,$PKT,$ND,$LINE,$LINEDB,$CMT,$CNN,$TRANS);

    # 
    $defseq=CtTbCti('SC,LOGTMP,SEQ');
    $LINEDB=CtTbCti('SC,LOGTMP,SEQ,LINEDB');
    
    CtLgOutDirect('<TR bgcolor="#AAEEEE"><TD><CENTER>Sequence</CENTER></TD><TD><A NAME="SequenceSummary"></A>');
    CtLgOutDirect('<pre>');

    # 
    foreach $line (@{$defseq->{'HD'}}){
	# 
	@args=();
	foreach $arg (@{$line->{'arg'}}){
	    if(ref($arg) eq 'SCALAR'){$val = eval $$arg;}
	    else{$val = $arg;}
	    push(@args,$val);
	}	    
	# 
	if( $fmt=$line->{'fmt'} ){
	    if(ref($fmt) eq 'SCALAR'){
		$fmt = eval( $$fmt );
		if($@){MsgPrint('ERR',"Eval SCALER failed[%s]\n",$@);}
	    }
	}
	# 
	$msg=sprintf($fmt,@args);
	CtLgOutDirect($msg);
    }

    # 
    $NO=1;
    foreach $PKT (@$pkts){

	# 
	$TS=$PKT->{'Frame'}->{'#TimeStamp#'};
	$DIR=$PKT->{'Direction'};
	$FR =$PKT->{'FrameName'} ? $PKT->{'FrameName'} : CtScGeneratePktName($PKT);  ## 
	$ND =$PKT->{'NodeID'};
	$NM =$PKT->{'PktName'};
	$CMT=$PKT->{'Comment'};
	$CNN=CtCnGet($PKT->{'ConnID'},'ALL');
	$TRANS=$PKT->{'Frame'}->{'INET'}->[CtPkL2x($PKT->{'Frame'})]->{'#Name#'};
	$LINE='';

	# 
	foreach $marker (@$LINEDB){
	    if(ref($marker->{'pat'}) && (eval $$marker->{'pat'})){
		$LINE=$marker->{'marker'};
		last;
	    }
	    elsif($FR =~ /$marker->{'pat'}/ ){
		$LINE=$marker->{'marker'};
		last;
	    }
	}

	$startTime=$TS unless($startTime);
	$diffTime=$TS-$startTime;

	# 
	@args=();
	foreach $arg (@{$defseq->{'LINE'}->{'arg'}}){
	    if(ref($arg) eq 'SCALAR'){$val = eval $$arg;}
	    else{$val = $arg;}
	    push(@args,$val);
	}

	# 
	$fmt=$defseq->{'LINE'}->{'fmt'};
	if(ref($fmt) eq 'SCALAR'){
	    $fmt = eval( $$fmt );
	    if($@){MsgPrint('ERR',"Eval SCALER failed[%s]\n",$@);}
	}

	# 
	$msg=sprintf($fmt,@args);

	# 
	if($PKT->{'MARK'}){
	    $msg = sprintf('[<A NAME="SEQ%0'.$PKTMAX.'d"></A>%0'.$PKTMAX.'d</A>:%'.$DIFFTIMEFMT.'f] %s'."\n", 
			   $NO,$NO,$diffTime,$msg);
	}
	elsif($DIR eq 'in'){
	    # 
	    if( $nojudgecheck || (grep{$_->{'PKT'}->{'#ID#'} eq $NO} @JUDGEMENTLog) ){
		$msg = sprintf('[<A NAME="SEQ%0'.$PKTMAX.'d"></A><A HREF="#PKT%0'.$PKTMAX.'d">%0'.$PKTMAX.'d</A>:<A HREF="#JUDGE%0'.$PKTMAX.'d">%'.$DIFFTIMEFMT.'f</A>] %s'."\n",
			       $NO,$NO,$NO,$NO,$diffTime,$msg);
	    }
	    else{
		$msg = sprintf('[<A NAME="SEQ%0'.$PKTMAX.'d"></A><A HREF="#PKT%0'.$PKTMAX.'d">%0'.$PKTMAX.'d</A>:%'.$DIFFTIMEFMT.'f] %s'."\n", 
			       $NO,$NO,$NO,$diffTime,$msg);
	    }
	}
	else{
	    $msg = sprintf('[<A NAME="SEQ%0'.$PKTMAX.'d"></A><A HREF="#PKT%0'.$PKTMAX.'d">%0'.$PKTMAX.'d</A>:%'.$DIFFTIMEFMT.'f] %s'."\n", 
			   $NO,$NO,$NO,$diffTime,$msg);
	}
	CtLgOutDirect($msg);
	$NO++;
    }

    # 
    foreach $line (@{$defseq->{'FT'}}){
	# 
	@args=();
	foreach $arg (@{$line->{'arg'}}){
	    if(ref($arg) eq 'SCALAR'){$val = eval $$arg;}
	    else{$val = $arg;}
	    push(@args,$val);
	}	    
	# 
	if( $fmt=$line->{'fmt'} ){
	    if(ref($fmt) eq 'SCALAR'){
		$fmt = eval( $$fmt );
		if($@){MsgPrint('ERR',"Eval SCALER failed[%s]\n",$@);}
	    }
	}
	# 
	$msg=sprintf($fmt,@args);
	CtLgOutDirect($msg);
    }

#    CtLgOutDirect('</pre>');
    CtLgOutDirect('</pre></TD></TR>');
    return $startTime;
}


#============================================
# 
#============================================
## DEF.VAR
# 
%LOG_COLOR = ('ERR'=>'red','WAR'=>'green','OK'=>'blue','INF1'=>'blue','INF2'=>'blue','DBG'=>'black','SEQ'=>'black','JDG'=>'black');
# 
%LOGList;
## DEF.END
# 
sub CtLgAdd {
    my($type,$msg,$mode)=@_;
    push(@{$LOGList{$type}},{'MSG'=>$msg,'TIME'=>time(),'Mode'=>$mode});
}
sub LOGMarge {
    my($from,$to,$mode)=@_;
    CtLgAdd($to,$LOGList{$from},$mode);
    $LOGList{$from}=[];
}
#   ":&quot; &:&amp; <:&lt; >:&gt;
sub CtLgCnvHTML {
    my($msg)=@_;
    my(@val);
    return if($msg eq '');

    if(ref($msg) eq 'ARRAY'){
	@val=map{CtLgCnvHTML($_)} @$msg;
	return \@val;
    }

    # HTML
    $msg =~ s/&/&amp;/g;
    $msg =~ s/"/&quot;/g;
    $msg =~ s/</&lt;/g;
    $msg =~ s/>/&gt;/g;
    return $msg;
}

# 
sub CtLgMsg {
    my($level,$msg,$frm,@args)=@_;
    $msg =~ s/\n//;
    $msg = CtLgCnvHTML($msg);
    $msg='<font color="' . $LOG_COLOR{$level} . '">' . $msg . '</font><BR>';
    if($frm){$msg=sprintf($frm,@args,$msg);}
    CtLgAdd('RUN',$msg);
}
# 
sub CtLgWarn {
    my($msg,@args)=@_;
    my($id);
    # 
    if($DIRRoot{'ACTND'}->{'ID'}){$id='<font color="black">' . $DIRRoot{'ACTND'}->{'ID'} . ':</font>';}
    if(@args){$msg=sprintf($msg,@args);}
    if(CtLgLevel('FLOW')){FlowPrint('<=',$msg);}
    CtLgMsg('WAR','warning '.$msg,$id?"%s%s":'',$id);
}
sub CtLgNG {
    my($msg,@args)=@_;
    my($id);
    # 
    if($DIRRoot{'ACTND'}->{'ID'}){$id='<font color="black">' . $DIRRoot{'ACTND'}->{'ID'} . ':</font>';}
    if(@args){$msg=sprintf($msg,@args);}
    if(CtLgLevel('FLOW')){FlowPrint('<=',$msg);}
    CtLgMsg('ERR','error '.$msg,$id?"%s%s":'',$id);
}
sub CtLgOK {
    my($msg,@args)=@_;
    my($id);
    # 
    if($DIRRoot{'ACTND'}->{'ID'}){$id='<font color="black">' . $DIRRoot{'ACTND'}->{'ID'} . ':</font>';}
    if(@args){$msg=sprintf($msg,@args);}
    CtLgMsg('OK',$msg,$id?"%s%s":'',$id);
}
# 
sub CtLgPrint {
    my($level,$msg,@args)=@_;
    my($id);

    # 
    if($DIRRoot{'ACTND'}->{'ID'}){$id='<font color="black">' . $DIRRoot{'ACTND'}->{'ID'} . ':</font>';}
    if(@args){$msg=sprintf($msg,@args);}
    # 
    CtLgMsg($level,$msg,$id?"%s%s":'',$id);
    # 
    MsgPrint($level,$msg,@args);
    return '';
}

#============================================
# 
#============================================
# 
sub CtLgOutDirect {
    my($msg,@args) = @_;
    # 
    if(@args){$msg=sprintf($msg,@args);}
    # 2
    if(defined(&jcode::convert)){jcode::convert(\$msg,"euc");}
    elsif(defined(&Jcode::convert)){Jcode::convert(\$msg,"euc");}
#    else{MsgPrint('WAR',"Jcode convert module not exit\n");}
    LogHTML($msg);
    return $msg;
}
# HTML
sub LOGOutHTMLDirect {
    my($msg,@args) = @_;
    # 
    if(@args){$msg=sprintf($msg,@args);}
    $msg=CtLgCnvHTML($msg);
    # 2
    if(defined(&jcode::convert)){jcode::convert(\$msg,"euc");}
    elsif(defined(&Jcode::convert)){Jcode::convert(\$msg,"euc");}
#    else{MsgPrint('WAR',"Jcode convert module not exit\n");}
    print HTMLLOG $msg;
}
# 
sub CtLgOutForPushed {
    my($type) = @_;
    my($sec,$min,$hour,$mday,$mon,$year,$wday,$tim,$log,$logs,$msg,$m);
    $logs=$LOGList{$type};
    foreach $log (@$logs){
	$msg=$log->{'MSG'};
	# 2
	if(defined(&jcode::convert)){jcode::convert(\$msg,"euc");}
	elsif(defined(&Jcode::convert)){Jcode::convert(\$msg,"euc");}
#	else{MsgPrint('WAR',"Jcode convert module not exit\n");}
	# 
	if($log->{'Mode'} eq 'plane'){
	    if(ref($msg) eq 'ARRAY'){
		foreach $m (@$msg){LogHTML($m->{'MSG'});}
	    }
	    else{
		LogHTML($msg);
	    }
	}
	else{
	    if(!$log->{'TIME'}){$tim='<BR>';}
	    else{
		($sec,$min,$hour,$mday,$mon,$year,$wday)=localtime($log->{'TIME'});
		$tim=sprintf("%02d:%02d:%02d",$hour,$min,$sec);
	    }
	    if(ref($msg) eq 'ARRAY'){
		LogHTML("<TR><TD>$tim</TD><TD>\n");
		foreach $m (@$msg){LogHTML($m->{'MSG'});}
		LogHTML("</TD></TR>\n");
	    }
	    else{
		LogHTML("<TR><TD>$tim</TD><TD>$msg</TD></TR>\n");
	    }
	}
    }
    undef(@{$LOGList{$type}});
}

sub CtUtGetTimeStamp {
    my(@tim,$startTime);
    @tim=Time::HiRes::gettimeofday();
    return @tim[0] . sprintf(".%06d",@tim[1]);
}

#============================================
# PrintVal
#============================================
sub TextVal {
    my($val,$indent,$limit)=@_;
    my(@text,$text);
    TextVL($val,$indent,$limit,\@text);
    map{$text .= $_ . "\r\n"} @text;
    return $text;
}
sub TextVL {
    my($val,$indent,$limit,$text)=@_;
    my($i,$key,$v,@keys,$idx);

    unless($limit eq ''){
	if( --$limit < 0 ){return $text;}
    }
    if(ref($val) eq 'ARRAY'){
	if($#$val<0){
	    push(@$text,sprintf( sprintf("%%%ds",$indent), " " ) . "Array element Nothing");
	}
	for($i=0;$i<=$#$val;$i++){
	    $idx = sprintf( sprintf("%%%ds",$indent), " " );
	    if(!ref($val->[$i])){
		push(@$text,$idx . sprintf("No[%s] %s",$i,($val->[$i] eq '')?Nil:$val->[$i]) );
	    }
	    else{
		push(@$text,$idx . sprintf("No[%s] ",$i) );
		TextVL($val->[$i],$indent+3,$limit,$text);
	    }
	}
    }
    elsif(ref($val) eq 'HASH'){
	@keys=sort(keys(%$val));
	for $i (0..$#keys){
	    $key=@keys[$i];
	    $v=$val->{$key};
	    $idx = sprintf( sprintf("%%%ds",$indent), " " );
	    if(!ref($v)){
		push(@$text,$idx . sprintf("$key: %s",($v eq '')?Nil:$v));
	    }
	    else{
		push(@$text,$idx . "$key" . ': ');
		TextVL($v,$indent+3,$limit,$text);
	    }
	}
    }
    elsif(ref($val) eq 'SCALAR'){
	push(@$text,sprintf( sprintf("%%%ds",$indent), " " ) . sprintf("%s ",$val));
	TextVL($$val,$indent+3,$limit,$text);
    }
    elsif(ref($val) eq 'Math::Pari'){
	push(@$text,sprintf( sprintf("%%%ds",$indent), " " ) . sprintf( "Pari:: %s", Math::Pari::pari2pv($val) ));
    }
    else{
	push(@$text,sprintf( sprintf("%%%ds",$indent), " " ) . sprintf( "%s", ($val eq '')?'Nil':$val ));
    }
    return $text;
}


#============================================
# 
#============================================
# 
sub MsgPrint {
    my($level,$frm,@args)=@_;
    my($diff,$indent,@stack,$i,$function,$tn);
    if(!grep{$_ eq $level} @IKLogLevel){return}

    @stack=caller(1);$function=@stack[3];if($function eq 'main::CtSvError'){@stack=caller(2);$function=@stack[3];}
    $indent=1;$i=1;
#    while(@stack=caller($i++)){if(@stack[3] eq 'main::CtFlGet'){$indent=1;}elsif(!@stack[6]){$indent++;}}
    while(@stack=caller($i++)){if(!@stack[6]){$indent++;}}
    $indent=' ' x ($indent-2);
    if($function){$function = '<'.$function.'> ';}
    if($level eq 'LAY'){$indent=' ';$function='';}

    if($LAST_MSG_TIME){
	$diff=Time::HiRes::tv_interval($LAST_MSG_TIME, $tn=[Time::HiRes::gettimeofday()])*1000;
	printf($level . '[%6.1f]:' . $indent . $function . $frm, $diff, @args);   ## 
	$LAST_MSG_TIME=$tn;
#       printf($level . '[%6.1f]:' . $indent . $frm, $diff*1000, @args);
    }
    else{
	my(@hitim,@tim);
	@hitim=Time::HiRes::gettimeofday();
	@tim=localtime(@hitim[0]);
	printf($level . '['.@tim[2].':'.@tim[1].':'.@tim[0].'.%02d]:' . $indent . $function . $frm, 
	       @hitim[1]/10000, @args);
    }
}
sub FlowPrint {
    my($mark,$frm,@args)=@_;
    my($diff,$tn,$msg);

    unless($FLOW_LAST_MSG_TIME){
	$FLOW_LAST_MSG_TIME=[Time::HiRes::gettimeofday()];
    }
    $diff=Time::HiRes::tv_interval($FLOW_LAST_MSG_TIME);
    $msg=sprintf('[%6.1f]: ' . $mark . ' ' . $frm, $diff, @args); $msg =~ s/[\r\n]/ /mg;
    printf($msg."\n");
}
sub MsgIndentPrint {
    my($val,$indent)=@_;
    if(!(grep{$_ eq 'DBG2'} @IKLogLevel)){return;}
    if($indent>0){
	printf( sprintf("%%%ds",$indent), " " );
    }
    print "$val";
}
sub PrintVal {
    my($val,$limit,$title,$indent)=@_;
    my(@stack);
    if( $indent eq ''){$indent=3;}
    @stack=caller(1);
    if($title ne '#NOTITLE#'){
	printf("-----PrintVal(%s / %s)----------\n",$title,@stack[3]);
    }
    PrintVL($val,$indent,$limit);
}
# 
sub PrintValEx {
    my($val,$limit,$title,$indent)=@_;
    my(@stack);
    local(%printed); # 
    if( $indent eq ''){$indent=3;}
    @stack=caller(1);
    printf("-----PrintVal(%s / %s)----------\n",$title,@stack[3]);
    PrintVL($val,$indent,$limit,'structMode');
}
sub PrintVL {
    my($val,$indent,$limit,$structMode)=@_;
    my($i,$key,$v,@keys,$class);

    unless($limit eq ''){
	if( --$limit < 0 ){return;}
    }
    if(ref($val) eq 'ARRAY'){
ARRAY:
	if($#$val<0){
	    printf( sprintf('%%%ds',$indent), " " );
	    printf("Array element Nothing\n");
	}
	for($i=0;$i<=$#$val;$i++){
	    printf( sprintf('%%%ds',$indent), " " );
	    if(!ref($val->[$i])){
		printf("No[%s] = %s\n",$i,($val->[$i] eq '')?Nil:$val->[$i]);
	    }
	    else{
		printf("No[%s] =\n",$i);
		PrintVL($val->[$i],$indent+3,$limit,$structMode);
	    }
	}
    }
    elsif(ref($val) eq 'HASH'){
HASH:
	@keys=sort(keys(%$val));
	for $i (0..$#keys){
	    $key=@keys[$i];
	    $v=$val->{$key};
	    printf( sprintf('%%%ds',$indent), " " );
	    if(!ref($v)){
#		printf($class.$key.': = %s(%x)' ."\n",($v eq '')?Nil:$v,($v eq '')?Nil:$v);
		printf($class.$key.': = %s' ."\n",($v eq '')?Nil:$v);
	    }
	    else{
		printf($class.$key.': =' ."\n",$key);
		PrintVL($v,$indent+3,$limit,$structMode);
	    }
	}
    }
    elsif(ref($val) eq 'SCALAR'){
	printf( sprintf("%%%ds",$indent), " " );
	printf("%s = \n",$val);
	PrintVL($$val,$indent+3,$limit,$structMode);
    }
    elsif(ref($val) eq 'Math::Pari'){
 	printf( sprintf("%%%ds",$indent), " " );
 	printf( "Pari:: %s\n", Math::Pari::pari2pv($val) );
    }
    elsif($structMode && ref($val) =~ /[^:]+::[^:]+/){
	if($val =~ /=HASH\(0x.+\)/){
	    if($printed{$val}){
		goto ATOM;
	    }
	    else{
#		printf( sprintf("%%%ds",$indent), " " );
#		printf('<' . ref($val) . ">\n");
		$printed{$val}='T';
		$class='<'.ref($val).'>';
		goto HASH;
	    }
	}
	elsif($val =~ /=ARRAY\(0x.+\)/){
	    if($printed{$val}){
		goto ATOM;
	    }
	    else{
#		printf( sprintf("%%%ds",$indent), " " );
#		printf('<' . ref($val) . ">\n");
		$printed{$val}='T';
		goto ARRAY;
	    }
	}
	goto ATOM;
    }
    else{
ATOM:
	printf( sprintf("%%%ds",$indent), " " );
	printf( "%s\n", ($val eq '')?'Nil':$val );
    }
}
sub PrintItem {
    my($val,@stack)=@_;
    @stack=caller(1);
    printf("-----PrintItem(%s)----------\n",@stack[3]);
    printf("   [%s] ref:[%s]",$val,ref($val));
    if(ref($val) eq 'SCALAR'){
	printf("  *ref[%s]",$$val);
    }
    printf("\n");
}

sub BT {
    my($i,@stack);
    while(@stack=caller($i++)){} $i-=2;
    while(-1<$i && (@stack=caller($i--))){
	printf("BT: %s\n",@stack[3]);
    }
}
sub HEX {
    my($title,$data,$indent)=@_;
    my(@stack);
    @stack=caller(1);
    unless($indent){$indent=2;}
    $indent=' ' x $indent;
    printf("======== %s(%s) [%s] =========\n",$title,length($data)/2,@stack[3]);
    while($data){
	printf("%s%s\n",$indent,substr($data,0,32));
	$data=substr($data,32);
    }
}

# Bignum
sub BNUM {
    my($val)=@_;
    my($mod,$base,$i,$msg,$hexstr);

    $base = 0x10000;
    $base = PARI $base;
    while($base<=$val){
	$mod=int($val) % $base;
	$val=$val / $base;
	$msg = sprintf("%04x%s",$mod,$msg);
    }
    $mod=int($val) % $base;
    if($mod){$msg=sprintf("%04x%s",$mod,$msg);}
    for($i=0;$i<length($msg);$i+=8){
	if($i && !($i % 64)){$hexstr .= "\n";}
	$hexstr .= substr($msg,$i,8) . ' ';
    }
    $hexstr .= substr($msg,$i);
    return $hexstr,$msg;
}

sub BNHEX {
    my($title,$data,$indent)=@_;
    my(@stack);
    @stack=caller(1);
    unless($indent){$indent=2;}
    $indent=' ' x $indent;
    ($data,$data)=BNUM($data);
    printf("======== %s(%s) [%s] =========\n",$title,length($data)/2,@stack[3]);
    while($data){
	printf("%s%s\n",$indent,substr($data,0,32));
	$data=substr($data,32);
    }
}

sub PV {
    my($val,$title,$indent)=@_;
    my(@stack);
    if( $indent eq ''){$indent=3;}
    @stack=caller(1);
    printf("-----Call Stack----------\n");
    PrintVL(\@stack,$indent);
    printf("-----PrintVal(%s / %s)----------\n",$title,@stack[3]);
    PrintVL($val,$indent);
    exit;
}

# 
sub FormatLine {
    my $format=shift;
    $^A = "";
    formline($format,@_);
    return $^A;
}

# 
sub ARtoStr {
    my($array,$del)=@_;
    my($str);
    if(ref($array) ne 'ARRAY'){return $array;}
    $del=',' unless($del);
    map{$str .= ($str?$del:'') . $_;}(@$array);
    return $str;
}


# @@ -- TBL.pm --
# Copyright (C) NTT Advanced Technology 2007

# use strict;

#=================================
# 
#=================================

## DEF.VAR
%DIRRoot;
## DEF.END

# 
sub CtTbCti {
    my($field)=@_;
    return CtFlGet($field,\%DIRRoot);
}
sub CtTbCtiSet {
    my($field,$val,$force)=@_;
    CtFlSet($field,\%DIRRoot,$force?'SET':'Set',$val);
}

# 
sub CtTbSc {
    my($field)=@_;
    return CtFlGet($field,$DIRRoot{'SC'});
}
sub CtTbScSet {
    my($field,$val)=@_;
    CtFlSet($field,$DIRRoot{'SC'},'SET',$val);
}

# 
sub CtTbND {
    my($field,$node)=@_;
    unless($field || $node){return $DIRRoot{'ND'};}
    unless($node){$node=$DIRRoot{'ACTND'};}
    unless(ref($node)){$node=CtNDFromName($node);}
    return CtFlGet($field,$node);
}

# 
sub CtTbCfg {
    my($record,$field)=@_;
    return CtFlGet($field,$DIRRoot{'SC'}->{'CFG'}->{$record});
}
sub CtTbCfgSet {
    my($record,$field,$val)=@_;
    if($field){
	CtFlSet('CFG,' . $record . ',' . $field,$DIRRoot{'SC'},'SET',$val);
    }
    elsif(ref($val)){
	CtFlSet('CFG,' . $record,$DIRRoot{'SC'},'SET',$val);
    }
}
sub CtTbExt {
    my ($record, $field) = @_;
    return CtFlGet($field, $DIRRoot{'SC'}->{'EXT'}->{$record});
}

# 
sub CtTbUsr {
    my($user,$field)=@_;
    return CtFlGet($field,$DIRRoot{'SC'}->{'USR'}->{$user});
}
sub CtTbUsrSet {
    my($user,$field,$val)=@_;
    CtFlSet('USR,' . $user . ',' . $field,$DIRRoot{'SC'},'SET',$val);
}

# 
sub CtTbPrm {
    my($field)=@_;
    return CtFlGet($field,$DIRRoot{'SC'}->{'PARAM'});
}
sub CtTbPrmSet {
    my($field,$val)=@_;
    CtFlSet($field,$DIRRoot{'SC'}->{'PARAM'},'SET',$val);
}

# 
sub CtTbSw {
    my($sw)=@_;
    return $DIRRoot{'SC'}->{'SW'}->{$sw};
}
sub CtTbSwSet {
    my($sw,$val)=@_;
    $DIRRoot{'SC'}->{'SW'}->{$sw}=lc($val);
}

# 
sub CtTbSwFunc {
    my($sw)=@_;
    return q{CtTbCti('SC,SW,}.$sw.q{')};
}

# 
sub NS {
    my($field,$space)=@_;
    unless($space){$space='NS';}
    if(ref($field) eq 'ARRAY'){$field=$field->[0];}
    return $DIRRoot{'SC'}->{$space}->{$field};
}
sub SetNS {
    my($field,$val,$single,$space)=@_;
    unless($space){$space='NS';}
    $DIRRoot{'SC'}->{$space}->{$field}=$val;
    unless($single){$DIRRoot{'SC'}->{$space}->{$val}=$field;}
    if(!($field =~ /\.$/) && !CtUtIp($field)){
	$field .= '.';
	$DIRRoot{'SC'}->{$space}->{$field}=$val;
	unless($single){$DIRRoot{'SC'}->{$space}->{$val}=$field;}
    }
}

# 
sub CtTbl {
    my($field,$node)=@_;
    # 
    if($node eq 'ALL'){
        my %val,$nd;
        unless($field){return};
        foreach $nd (keys(%{$DIRRoot{'ND'}})){
            $val{$nd}=CtFlGet($field,$DIRRoot{'ND'}->{$nd}->{'TBL'});
        }
        return \%val;
    }
    else{
        unless($node){$node=$DIRRoot{'ACTND'};}
        unless(ref($node)){$node=CtNDFromName($node);}
        return $field ? CtFlGet($field,$node->{'TBL'}) : $node->{'TBL'};
    }
}
# 
sub CtTbSet {
    my($field,$val,$node)=@_;
    unless($node){$node=$DIRRoot{'ACTND'};}
    unless(ref($node)){$node=CtNDFromName($node);}
    CtFlSet("TBL,$field",$node,'SET',$val);
}

# 
sub CtTbAd {
    my($field,$node)=@_;
    unless($node){$node=$DIRRoot{'ACTND'};}
    unless(ref($node)){$node=CtNDFromName($node);}
    return CtFlGet($field,$node->{'AD'});
}
sub CtTbAdSet {
    my($field,$val,$node)=@_;
    unless($node){$node=$DIRRoot{'ACTND'};}
    unless(ref($node)){$node=CtNDFromName($node);}
    CtFlSet("AD,$field",$node,'SET',$val);
}

# 
sub LASTPKT(){
    return $DIRRoot{'LASTPKT'};
}

# 
sub CtNDAct(){
    return $DIRRoot{'ACTND'}->{'ID'};
}

# 
sub ActCN(){
    my($node)=@_;
    unless($node){$node=$DIRRoot{'ACTND'};}
    return $node->{'CNL'}->[0]?$node->{'CNL'}->[0]:$DIRRoot{'ACTCNN'};
}

# 
sub CtNDFromName {
    my($name)=@_;
    return $DIRRoot{'ND'}->{$name};
}
# 
sub CtNDTarget {
    return CtTbPrm('CI,target,TARGET');
}
# 
sub CtNDGetFromAddr {
    my($addr)=@_;
    my($node,@nodes,$ip4);
    $ip4=IsIPV4Address($addr);
    @nodes=keys(%{$DIRRoot{'ND'}});
    foreach $node (@nodes){
	$node=$DIRRoot{'ND'}->{$node};
	if($ip4){
	    if(CtUtV4Eq($node->{'AD'}->{'local-ip'},$addr)){return $node;}
	}
	else{
	    if(CtUtV6Eq($node->{'AD'}->{'local-ip'},$addr)){return $node;}
	}
    }
    return '';
}

# node *:
# node target:
#  ex) PrintTbl('UC',CtTbPrm('CI,target,TARGET'));
sub PrintTbl {
    my($field,$node)=@_;
    my($val,$aux);
    if($node){
        if($node =~ /target/i){
            $node=CtTbPrm('CI,target,TARGET')
        }
        if($node eq '*'){
            $node=CtNDAct();
        }
        $val=CtTbl($field,$node);
        unless(ref($node)){$node=CtNDFromName($node);}
        $aux=' [' .$node->{'ID'} . ']';
    }
    else{
        $val=CtFlGet($field,\%DIRRoot);
    }
    printf(" --- $field$aux---\n");
    printf(TextVal($val,2));
}

#=================================
# 
#=================================


#=================================
# Lisp
#=================================
$LpCR              = q{\x0D};             #2006/01/18
$LpLF              = q{\x0A};             #2006/01/18
$LpCRLF            = qq{$LpCR$LpLF};
$LpDQUOTE          = q{\x22};             #2006/01/18
$LpHTAB            = q{\x09};             #2006/01/18
$LpSP              = q{\x20};             #2006/01/18
$LpWSP             = qq{(?:$LpSP|$LpHTAB)};
$LpDigit           = q{[0-9]};
$LpHex             = qq{(?:$LpDigit|[A-Fa-f])};
$LpUpalpha         = q{[A-Z]};
$LpLowalpha        = q{[a-z]};
$LpAlpha           = qq{(?:$LpLowalpha|$LpUpalpha)};
$LpAlphanum        = qq{(?:$LpAlpha|$LpDigit)};
$LpToken           = qq{(?:$LpAlphanum|[#"/:\\\-\\\.!%\\\*_\\\+`'~])+};

sub CtParseLisp {
    my($txt,$parenthese)=@_;
    my(@items,$item);

    $txt =~ s/^\s*(.*?)\s*$/$1/;

    while($txt){
	if($txt =~ /^(\s*\()/){
	    ($item,$txt)=CtParseLisp($','parenthese');
	    if($item){
		push(@items,$item);
	    }
	}
	elsif($txt =~ /^(\s*\))/){
	    if(!$parenthese){
		printf("### parentheses miss balance\n");
		return;
	    }
	    if(0<=$#items){
		$item={'op'=>shift @items,'args'=>\@items};
	    }
	    return $item,$';
	}
	elsif($txt =~ /^\s*($LpToken)/){
	    push(@items,$1);
	    $txt = $';
	}
	elsif($txt =~ /^\s+$/){
	    last;
	}
    }
    if($parenthese && 0<=$#items){
	printf("### parentheses miss balance\n");
	return;
    }
    return \@items;
}

# @@ -- Connect.pm --
# Copyright (C) NTT Advanced Technology 2007

# use strict;

#============================================
#    
#============================================
sub FindConnectionFromSocket{
    my($socketID)=@_;
    my(@ids,$id);

    @ids=keys(%{$DIRRoot{'SC'}->{'CNN'}});
    foreach $id (@ids){
	if($DIRRoot{'SC'}->{'CNN'}->{$id}->{'SocketID'} eq $socketID){ return $id; }
    }
    return '';
}

#============================================
#    PCAP 
#============================================


#============================================
#    Perl-C 
#============================================
## DEF.VAR
%ConnectionList;
$ConnectionID;
## DEF.END
sub CtCnMake 
{
    my($property,$class)=@_;
    my($id);
    $ConnectionID++;
    $id='CONN:' . $ConnectionID;
    $DIRRoot{'SC'}->{'CNN'}->{$id}={'status'=>'new','transport'=>'UDP',%$property,'ID'=>$id};
    # 
    if($class){push(@{$DIRRoot{'SC'}->{$class}},$id);}
##    printf("CtCnMake [%s]\n",$id);# BT();
    return $id;
}
sub CtCnClose
{
    my($connID)=@_;
    my($conn);

    if(CtUtIsFunc('TCPClose')){
	TCPClose($connID,'Reset');
    }
    $conn=CtCnGet($connID);
    if($conn->{'ModuleName'} ne 'KOI' && $conn->{'transport'} ne 'TCP'){return;}

    $DIRRoot{'SC'}->{'CNN:Closed'}->{$connID}=$DIRRoot{'SC'}->{'CNN'}->{$connID};
    $DIRRoot{'SC'}->{'CNN'}->{$connID}='';
    if($conn->{'SocketID'}){
#	printf("CtCnClose [%s]\n",$connID);
	kCommon::kPacket_Close($conn->{'SocketID'},0);
    }
#    $ConnectionList{$connID}->{'status'}='new';
#    $ConnectionList{$connID}->{'SocketID'}='';
}
sub CtCnGet
{
    my($connID,$all)=@_;
    if(ref($connID)){return $connID;}
    return $all ? ($DIRRoot{'SC'}->{'CNN'}->{$connID} || $DIRRoot{'SC'}->{'CNN:Closed'}->{$connID}) : $DIRRoot{'SC'}->{'CNN'}->{$connID};
}
sub CtCnDump
{
    my($connID)=@_;
    my($conn);
    $conn=CtCnGet($connID);
    printf("#CNN# ID:%s module:%s Dir[%s] IP[%s][%s] Port[%s][%s] SPI[%s]\n",
	   $conn->{'SocketID'}, $conn->{'ModuleName'}, $conn->{'direction'},
	   $conn->{'local-ip'}, $conn->{'peer-ip'},
	   $conn->{'local-port'},$conn->{'peer-port'},
	   $conn->{'policyID'});
}
sub CNNSet
{
    my($connectID,$prop)=@_;
    my(@keys,$key);
    @keys=keys(%$prop);
    foreach $key (@keys){
	$DIRRoot{'SC'}->{'CNN'}->{$connectID}->{$key}=$prop->{$key};
    }
}

sub CtCnFind
{
    my($property,$module)=@_;
    my($id,@conn,$conn);

    @conn=keys(%{$DIRRoot{'SC'}->{'CNN'}});
    foreach $id (@conn){
	$conn=$DIRRoot{'SC'}->{'CNN'}->{$id};
	if($conn->{'SocketID'} eq '' || $conn->{'ModuleName'} ne $module){next;}
	if($conn->{'peer-port'} eq $property->{'peer-port'} &&
	   $conn->{'transport'} eq $property->{'transport'} &&
	   $conn->{'sigcomp'} eq $property->{'sigcomp'} &&
	   (!$property->{'local-port'} ||  $conn->{'local-port'} eq $property->{'local-port'}) ){
	    if($property->{'protocol'} eq 'INET6'){
		if(CtUtV6Eq($conn->{'peer-ip'},$property->{'peer-ip'}) &&
		   (!$property->{'local-ip'} ||  CtUtV6Eq($conn->{'local-ip'},$property->{'local-ip'}))){
		    return $conn->{'ID'};
		}
	    }
	    else{
		if(CtUtV4Eq($conn->{'peer-ip'},$property->{'peer-ip'}) &&
		   (!$property->{'local-ip'} ||  CtUtV4Eq($conn->{'local-ip'},$property->{'local-ip'}))){
		    return $conn->{'ID'};
		}
	    }
	}
    }
    return;
}

#============================================
#    
#============================================

# 
#   LayerType           : TCP | SSL | SIP
#   ProtocolLayer       : 
#   ProtocolLayerEx     : 
#   FindConnection      : 
#   ExtractValidPackect : 
#   PktEventName        : 
#   State               : 
#   RecvData            : 
sub CreateLayerTbl {
    my($layerType,$layerFunc,$layerFuncEx,$connFindFunc,$validPktFunc,$pktnameFunc,$state,$params)=@_;
    return {'LayerType'=>$layerType,
	    'ProtocolLayer'=>$layerFunc,'ProtocolLayerEx'=>$layerFuncEx,
	    'FindConnection'=>$connFindFunc,'PktEventName'=>$pktnameFunc,'ExtractValidPackect'=>$validPktFunc,
	    'State'=>$state,'RecvData'=>'',%$params};
}

# 
sub CNNBindLayer {
    my($conn,$tbl,$id)=@_;
    my($no,$layer);
    $conn=CtCnGet($conn);

    # 
    if($conn->{'Layer'}->{$id}){
	$layer=$conn->{'Layer'}->{'Order'};
	for $no (0..$#$layer){
	    if($layer->[$no] eq $conn->{'Layer'}->{$id}){
		$layer->[$no] = $tbl;
		last;
	    }
	}
    }
    # 
    else{
	push(@{$conn->{'Layer'}->{'Order'}},$tbl);
    }
    $conn->{'Layer'}->{$id}=$tbl;
}

sub CNNLayer {
    my($conn,$id)=@_;
    return CtCnGet($conn)->{'Layer'}->{$id};
}

sub CNNTransport {
    my($conn)=@_;
    $conn=CtCnGet($conn);
    return $conn->{'transport'};
}

sub CNNLayerLevel {
    my($conn,$id)=@_;
    my($layer,$no);
    $conn=CtCnGet($conn);
    if($conn->{'Layer'}->{$id}){
	$layer=$conn->{'Layer'}->{'Order'};
	for $no (0..$#$layer){
	    if($layer->[$no] eq $conn->{'Layer'}->{$id}){
		return ($#$layer - $no)*2 + 2;
	    }
	}
	
    }
    return 1;
}


# STDOUT 
package STDTRAP;
sub TIEHANDLE {
    my $class = shift;
    bless [], $class;
}
sub PRINT {
    my $self = shift;
    push @$self, join '', @_;
}
sub PRINTF {
    my $self = shift;
    my $fmt = shift;
    push @$self, sprintf $fmt, @_;
}
sub READLINE {
    my $self = shift;
    pop @$self;
}

package main;
1;
