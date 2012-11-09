#!/usr/bin/perl
# @@ -- PKThex.pm --
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
# 09/3/13 Text(SIP)
# 09/1/27 bytecode
# 08/9/19 CtPkText AC
# 08/2/25 
#   #ARRAY#
# 08/2/25 CtPkDecFld
# 08/2/19 BGIntAdd
# 08/1/18  
#   #ARRAY#
# 07/11/21 SL
#          
# 07/10/15 CtPkText

# SIP

## DEF.VAR
# 
%HXPKTPatternDB;
## DEF.END

#============================================
# 
#============================================
sub CtPkRegTempl {
    my($ptn,$uncomp,$force)=@_;
    my($i,$fields,$field,$subfields,$subfield);
    if(ref($ptn) eq 'HASH'){
	if(defined($HXPKTPatternDB{$ptn->{'##'}}) && !$force){
	    MsgPrint('ERR',"HexPattrn[%s] redefined.\n",$ptn->{'##'});
	    CtScExit('Fail');
	}
	# 
	if(!$uncomp && $ptn->{'#TX#'}){
	    if($ptn->{'#TX#'}->{'MT'} && !ref($ptn->{'#TX#'}->{'MT'}) ){
		$ptn->{'#TX#'}->{'MT'}=qr/$ptn->{'#TX#'}->{'MT'}/;
	    }
	    if($ptn->{'#TX#'}->{'MM'}){
		$ptn->{'#TX#'}->{'MM'}=qr/$ptn->{'#TX#'}->{'MM'}/;
	    }
	    if($ptn->{'#TX#'}->{'SL'} && !ref($ptn->{'#TX#'}->{'SL'}) ){
		$ptn->{'#TX#'}->{'SL'}=qr/$ptn->{'#TX#'}->{'SL'}/;
	    }
	    $fields=$ptn->{'field'};
	    foreach $field (@$fields){
		if($field->{'DE'}->{'SL'} && !ref($field->{'DE'}->{'SL'}) ){ $field->{'DE'}->{'SL'}=qr/$field->{'DE'}->{'SL'}/;}
		if($field->{'DE'}->{'MT'} && !ref($field->{'DE'}->{'MT'}) ){ $field->{'DE'}->{'MT'}=qr/$field->{'DE'}->{'MT'}/;}
		if($field->{'#ARRAY#'}){
		    $subfields=$field->{'#ARRAY#'};
		    foreach $subfield (@$subfields){
			if($subfield->{'DE'}->{'SL'} && !ref($subfield->{'DE'}->{'SL'})){
			    $subfield->{'DE'}->{'SL'}=qr/$subfield->{'DE'}->{'SL'}/;
			}
		    }
		}
	    }
	}
	$HXPKTPatternDB{$ptn->{'##'}}=$ptn;
    }
    if(ref($ptn) eq 'ARRAY'){
	if($#$ptn<0){
	    MsgPrint('WAR',"packet define table empty\n");
	}
	for $i (0..$#$ptn){
	    CtPkRegTempl($ptn->[$i],$uncomp,$force);
	}
    }
}

#============================================
# 
#============================================
# HEX
#  
#       HEX
#  
#  
sub CtPkDecode {
    my($hexStTemp,$hexString,$CTX)=@_;
    my($NX,$SZ,$F,$V,$TS,$tmp);

    # 
    if(!ref($tmp=$hexStTemp)){$hexStTemp=$HXPKTPatternDB{$hexStTemp};}
    if(ref($hexStTemp) ne 'HASH'){MsgPrint('WAR',"Packet template[%s] not found\n",$tmp);return;}

    # 
    if($hexStTemp->{'#CONTEXT#'} eq 'TXT'){$hexString=pack('H*', $hexString);}
    if( $hexStTemp->{'#TX#'} ){
	# 
	($F,$NX,$hexString)=CtPkHexDecText($hexStTemp,$hexString,$CTX);
    }
    else{
	# 
	($F,$NX,$hexString)=CtPkDecBin($hexStTemp,$hexString,$CTX);
    }

    if($hexStTemp->{'#CONTEXT#'} eq 'TXT'){$hexString=unpack('H*', $hexString);}
    return $F,$NX,$hexString;
}

# 
sub CtPkDecFldSelect {
    my($fields,$hexString)=@_;
    my($i,$hexStTemp,$field,$expr,$V);
    $V=$hexString;
    foreach $field (@$fields){
	if(ref($field->{'MT'}) eq 'Regexp' && $hexString =~ /$field->{'MT'}/){
	    return $field;
	}
	elsif(ref($field->{'MT'}) eq 'SCALAR'){
	    $expr=$field->{'MT'};
	    if( eval $$expr ){return $field;}
	}
	elsif(ref($field->{'MT'}) eq 'CODE'){
	    $expr=$field->{'MT'};
	    if( $expr->(@_) ){return $field;}
	}
	elsif($field->{'ST'}){
	    $hexStTemp=$HXPKTPatternDB{$field->{'ST'}};
	    if( $hexStTemp->{'#TX#'}->{'MT'} && ($hexString =~ /$hexStTemp->{'#TX#'}->{'MT'}/) ){
		return $field;
	    }
	    elsif( $hexStTemp->{'#TX#'}->{'MM'} && ($hexString =~ /$hexStTemp->{'#TX#'}->{'MM'}/) ){
		return $field,'salvation';
	    }
	}
    }
    return '';
}

sub CtPkDecFld {
    my($fields,$HXpkt,$F,$CTX)=@_;
    my($bitmask,$hexSt,$subString,$val,$vals,$bitdata,$bitpos,$type,$name,$act,$sub,$templ,$rest,$match,$NX,$SZ,$V,$TS,$N);
    my($tmp,$tmp2,$count,$loopmax,$salvation,$ref,$expr,$field);

    foreach $field (@$fields){
	$name=$field->{'NM'};
## SIP-HEX
# 	if($field->{'DB'}){
# 	    printf("<=Field name=[%s] #CHOICE#?[%s] #ARRAY#?[%s] HXpkt=[%s]\n",$name,
# 		   $field->{'#CHOICE#'}?'#CHOICE#':'',$field->{'#ARRAY#'}?'#ARRAY#':'',$HXpkt);
# 	}
# 	MsgPrint('HEX',"<=Field name=[%s] ST=[%s] #CHOICE#?[%s] #ARRAY#?[%s] HXpkt=[%s%s]\n",$name,$field->{'ST'},
# 		 $field->{'#CHOICE#'}?'#CHOICE#':'',$field->{'#ARRAY#'}?'#ARRAY#':'',substr($HXpkt,0,20),substr($HXpkt,20)?'...':'') if(CtLgLevel('HEX'));

	if(!$HXpkt && !$bitdata){last;}
	if($field->{'#CHOICE#'}){
	    # 
	    if($field->{'DE'}->{'AC'}){
		$tmp=$field->{'DE'}->{'AC'};
		if(ref($tmp) eq 'SCALAR'){eval $$tmp;}
	    }
	    # 
	    if($ref=ref($field->{'DE'}->{'SL'})){
		if($ref eq 'Regexp'){
## SIP-HEX
##		    if($field->{'DB'}){printf(" CHOICE [%s]\n",$HXpkt);}
		    $HXpkt =~ /$field->{'DE'}->{'SL'}/;
		    $HXpkt=$1;
		    $subString=$';
## SIP-HEX
##		    if($field->{'DB'}){printf(" [%s]=>[%s]\n",$field->{'NM'},$HXpkt);}
		}
		elsif($ref eq 'SCALAR'){
		    printf("SL SCALAR 1\n");
		}
		elsif($ref eq 'CODE'){
		    printf("SL CODE 1\n");
		}
	    }
	    # 
	    ($hexSt,$salvation)=CtPkDecFldSelect($field->{'#CHOICE#'},$HXpkt,$CTX);
	    # 
	    if($hexSt){
		($tmp,$V,$SZ,$NX,$HXpkt)=CtPkDecFld([$hexSt],$HXpkt,undef,$CTX);
#		MsgPrint('HEX',"Choiced MT=[%s] ST=[%s]\n",$hexSt->{'MT'},$hexSt->{'ST'});
	    }
	    else{
		MsgPrint('WAR',"Unmatched #CHOICE# \$V[%s] [%s]\n",$V,$HXpkt);
#		PrintVal($field->{'#CHOICE#'});
		$DB::single=1;
	    }
	    # 
	    $F->{$name?$name:$V->{'#Name#'}}=$V;
	    if($field->{'DE'}->{'SL'}){$HXpkt=$subString;}
	}
	elsif($field->{'#ARRAY#'}){
	    # 
	    $expr=$field->{'#LOOPS#'};
	    if($expr){
		if(ref($expr) eq 'SCALAR'){$loopmax=eval $$expr;}
		unless($loopmax){next;}
	    }
	    else{$loopmax='';}

	    # 
	    if($tmp=$field->{'DE'}->{'AC'}){
		if(ref($tmp) eq 'SCALAR'){eval $$tmp;}
	    }
	    # 
	    if($tmp=$field->{'DE'}->{'SZ'}){
		if(ref($tmp) eq 'SCALAR'){$tmp=eval $$tmp;}
		$subString=substr($HXpkt,0,$tmp*2);
		$HXpkt=substr($HXpkt,$tmp*2);
	    }
	    # 
	    elsif($field->{'DE'}->{'SL'}){
## SIP-HEX
##		if($field->{'DB'}){printf(" ARRAY [%s]\n",$HXpkt);}
		$HXpkt =~ /$field->{'DE'}->{'SL'}/;
		$subString=$1;
		$HXpkt=$';
## SIP-HEX
##		if($field->{'DB'}){printf(" A[%s]=>[%s]\n",$field->{'NM'},$subString);}
	    }
	    else{
		$subString=$HXpkt;
		$HXpkt='';
	    }
	    # 
	    if($name){$F->{$name}->{'#TXT#'}=$subString;}
	    # 
	    $vals=[];$count=1;
	    while($subString && (!$loopmax || $count<=$loopmax)){
		$tmp2=$subString;
		($tmp,$V,$SZ,$NX,$subString)=CtPkDecFld($field->{'#ARRAY#'},$subString,undef,$CTX);
##		MsgPrint('HEX',"#ARRAY# type[%s] name[%s|%s] sub[%s]\n",$#{$field->{'#ARRAY#'}},
##			 $name,$V->{'#Name#'},substr($tmp2,0,20)) if(CtLgLevel('HEX'));
		# 
		unless($V){next;}
		$CTX->{'ArrayCount'}=$count++;
		if( $#{$field->{'#ARRAY#'}} eq 0 ){
		  push(@$vals,$V);
	        }
	        else{
		  push(@$vals,$tmp);
		}
	    }
	    # 
	    if($subString){$HXpkt = $subString . $HXpkt;}

	    # 
	    if($tmp=$field->{'DE'}->{'AC2'}){
		if(ref($tmp) eq 'SCALAR'){eval $$tmp;}
		elsif(ref($tmp) eq 'CODE'){$vals=$tmp->($vals);}
	    }

	    # 
	    $F->{$name?$name:$V->{'#Name#'}}=$vals;
##	    MsgPrint('HEX',"#ARRAY# set array name[%s]\n",$name?$name:$V->{'#Name#'});

	}
	else{
	    if( $field->{'ST'} ){
		($V,$N,$HXpkt)=CtPkDecode($field->{'ST'},$HXpkt,$CTX);
		# 
		$F->{$name?$name:$V->{'#Name#'}}=$V;    ### 
		$act='';
	    }
	    else{
		# 
		# 
		$templ=$field->{'DE'};
		
		# 
		$TS=$templ->{'SZ'};
		$type=$templ->{'TY'};
		$act =$templ->{'AC'};
		$bitmask=$templ->{'MK'};
		$match=$templ->{'MT'};
		$rest=$templ->{'RT'};
		# 
		if(ref($TS) eq 'SCALAR'){
		    $TS = eval $$TS;
#		    MsgPrint('HEX',"$name Eval size(%s)=$TS\n",${$templ->{'SZ'}});
		}
		elsif(ref($TS) eq 'CODE'){
		    $TS=$TS->($F,$V);
		}

		# 
		if(!$TS && !$bitmask && !$match && $type ne 'const'){goto SKIP;}
		
		# 
		if(ref($type) eq 'SCALAR'){
		    $type = eval $$type;
		}
		elsif(ref($type) eq 'CODE'){
		    $type=$type->($F,$V);
		}
		
		# 
		if($bitmask){
		    if($bitdata eq ''){
			# 
			($bitdata,$HXpkt)=CtPkDecType($HXpkt,$type,$TS);
			$bitpos=$TS*8;
		    }
		    # 
		    $V=CtPkBitData($bitdata,$bitpos,$bitmask);
		    $bitpos-=$bitmask;
		    if($bitpos<=0){$bitdata='';}
		}
		elsif($match){
		    if( $HXpkt =~ /$match/ ){
			$V=$1;
			$HXpkt=$';
		    }
		    else{
			$V='';
#			printf("Unmatch field MT [%s]\n",$HXpkt);
#			MsgPrint('HEX',"Unmatch field MT [%s]\n",$HXpkt);
		    }
		    # 
		    if($rest){
			# 
			$F->{'#REST#'} = $HXpkt;
			$F->{'#REST#'} =~ s/$PtCRLF$//;
		    }
		}
		elsif($type eq 'const'){
		    $V=$field->{'IV'};
		}
		else{
		    # 
		    ($V,$HXpkt)=CtPkDecType($HXpkt,$type,$TS);
		    $bitdata='';
		}
		# 
		$F->{$name}=$V;
##		printf("Name[%s] v[%s] act[%s]\n",$name,$V,$act);
	    }
	  SKIP:
	    # 
	    if($act){
		if(ref($act) eq 'SCALAR'){
		    eval $$act;
#		    MsgPrint('HEX',"NX=[$NX] SZ=[%s] $$act\n",length($HXpkt));
		}
		elsif(ref($act) eq 'CODE'){
		    $act->($F,$V);
		}
	    }
	}
    }
##    MsgPrint('HEX',"=>Field name=[%s] ST=[%s] NX=[%s] #CHOICE#?[%s] #ARRAY#?[%s] HXpkt=[%s...]\n",$name,$field->{'ST'},$NX,
##	     $field->{'#CHOICE#'}?'#CHOICE#':'',$field->{'#ARRAY#'}?'#ARRAY#':'',substr($HXpkt,0)) if(CtLgLevel('HEX'));
#    PrintVal($F);
    return $F,$V,$SZ,$NX,$HXpkt;
}

# 
sub CtPkHexDecText {
    my($hexStTemp,$hexString,$CTX)=@_;
    my($field,$restString,$sub,$templ,$NX,$SZ,$F,$V,$TS,$expr,$salvation);

    # 
    $F->{'##'}=$hexStTemp->{'##'};
    $F->{'#Name#'}=$hexStTemp->{'#Name#'};

    # 
    $field=$hexStTemp->{'field'};

## SIP-HEX
##    if($hexStTemp->{'DB'}){printf("<==CtPkHexDecText start[%s][%s]\n",$F->{'##'},$hexString);}

    # MT 
    if($hexStTemp->{'#TX#'}->{'MT'} && !( $hexString =~ /$hexStTemp->{'#TX#'}->{'MT'}/) ){
	if($hexStTemp->{'#TX#'}->{'MM'} && ($hexString =~ /$hexStTemp->{'#TX#'}->{'MM'}/) ){
	    $salvation='t';
	}
	else{
##	    MsgPrint('HEX',"==>CtPkHexDecText unmatch pattern[%s]\n",$F->{'##'}) if(CtLgLevel('HEX'));
	    return;
	}
    }

    # 
    if($salvation){
	MsgPrint('WAR',"Sip message mismatch BNF [%s]\n",$hexString);
	$hexString =~ /($hexStTemp->{'#TX#'}->{'MM'})/;
	$restString=$';
	$F->{'#EN#'} = $F->{'#TXT#'}=$1;
	$F->{'#EN#'} =~ s/$PtCRLF$//;
	$F->{'#EN#'} = "\r\n" . $F->{'#EN#'};
	$F->{'#INVALID#'}='SYNTAX ERROR';
	return $F,'',$restString;
    }

    # SL 
    if($hexStTemp->{'#TX#'}->{'SL'} ){
	$hexString =~ /$hexStTemp->{'#TX#'}->{'SL'}/;
	$hexString=$1;
	$restString=$';
	$F->{'#TXT#'}=$hexString;
	$F->{'#TXT#'} =~ s/^(?:\s)*//;   # 
## SIP-HEX
##	if($hexStTemp->{'DB'}){printf("[%s]\n",$hexString);}
    }

    # AC 
    if( $expr=$hexStTemp->{'#TX#'}->{'AC'} ){
	if($expr eq 'oneline'){
	    $hexString =~ s/[\r\n]+(\s*.)/$1/g;  # 
	}
	elsif(ref($expr) eq 'SCALAR'){
	    eval $$expr;
	}
    }
    # 
    unless($CTX->{'decode'}){$CTX->{'decode'}=$F;}
    ($F,$V,$SZ,$NX,$hexString)=CtPkDecFld($field,$hexString,$F,$CTX);
    ## 
    if($hexString =~ /[^\r\n\s]+/ && $expr eq 'oneline'){
	$F->{'#INVALID#'}='SYNTAX ERROR';
    }
##    MsgPrint('HEX',"CtPkHexDecText name[%s]\n",$F->{'#Name#'}) if(CtLgLevel('HEX'));
    $hexString= $hexStTemp->{'#TX#'}->{'SL'} ? $restString : $hexString;

    # 
    # if($sub=$hexStTemp->{'sub'}) ... 

##    MsgPrint('HEX',"==>CtPkHexDecText end[%s] (%s)\n",$F->{'##'},substr($hexString,0,10)) if(CtLgLevel('HEX'));
EXIT:
    return $F,$NX,$hexString;
}

# 
sub CtPkDecBin {
    my($hexStTemp,$hexString,$CTX)=@_;
    my($field,$sub,$tmp,$subdata,$NX,$SZ,$F,$V,$act);

    # 
    $F->{'##'}=$hexStTemp->{'##'};
    $F->{'#Name#'}=$hexStTemp->{'#Name#'};

    # 
    $field=$hexStTemp->{'field'};

##    MsgPrint('HEX',"<==CtPkDecBin start[%s]\n",$F->{'##'}) if(CtLgLevel('HEX'));
    # 
    ($F,$V,$SZ,$NX,$hexString)=CtPkDecFld($field,$hexString,$F,$CTX);
    $CTX->{'UP'}=$F;

    # 
    if($sub=$hexStTemp->{'sub'}){
	if($act=$sub->{'AC'}){
	    if(ref($act) eq 'SCALAR'){eval $$act;}
	    elsif(ref($act) eq 'CODE'){$act->($hexString,$V);}
	}
	# 
	$subdata=($SZ ne '')?substr($hexString,0,$SZ*2):$hexString;

	# 
	($V,$tmp,$subdata)=CtPkDecBrother($sub->{'start'},$sub->{'pattern'},$sub->{'match'},$subdata,$F,$V,$CTX);

	if(-1<$#$V){
	    $F->{$sub->{'NM'}?$sub->{'NM'}:$sub->{'start'}}=$V;
	}
	$hexString=($SZ ne '')?substr($hexString,$SZ*2):$subdata;
    }

EXIT:
    return $F,$NX,$hexString;
}

# 
sub CtPkDecBrother {
    my($hexStTemp,$nxtpattern,$match,$hexString,$F,$V,$CTX)=@_;
    my($val,@tree,$nxt);

##    MsgPrint('HEX',"<==PktDecodeBrother start[$hexStTemp] next[@$nxtpattern]\n") if(CtLgLevel('HEX'));

    # 
    if($hexStTemp){
	($val,$nxt,$hexString)=CtPkDecode($hexStTemp,$hexString,$CTX);
	push(@tree,$val);
    }

    # 
    if($nxtpattern){
	while(1){
	    if(length($hexString)<=0){last;}
	    # 
	    if(!$nxt){$nxt=CtPkMatchPtrn($nxtpattern,$hexString,$F,$V);}
	    # 
	    if(!grep{$_ eq $nxt} @$nxtpattern){last;}
##	    MsgPrint('HEX',"*** PktDecodeBrother [$nxt] rest data length[%s]\n",length($hexString)) if(CtLgLevel('HEX'));
	    ($val,$nxt,$hexString)=CtPkDecode($nxt,$hexString,$CTX);
	    # 
	    push(@tree,$val);
	}
    }
##    MsgPrint('HEX',"==>PktDecodeBrother rest data length[%s]\n",length($hexString)) if(CtLgLevel('HEX'));
    return \@tree,'',$hexString;
}

# 
sub CtPkMatchPtrn {
    my($patterns,$hexString,$F,$V)=@_;
    my($pattern,$fields,$field,$val,$tmp,$subHexStTemp,$HXpkt,$size,$templ,$pattn);
    if(ref($patterns) ne 'ARRAY'){$patterns=[$patterns];}

    # 
    foreach $pattern (@$patterns){
	$HXpkt=$hexString;
	# 
	if(!ref($pattern)){$subHexStTemp=$HXPKTPatternDB{$pattern};}
	# 
	$fields=$subHexStTemp->{'field'};

	# 
	foreach $field (@$fields){
	    # 
	    $templ=$field->{'DE'};
	    $size=$templ->{'SZ'};
	    $pattn=$templ->{'PT'};

	    # 
	    if($pattn eq '*'){
		return $pattern;
	    }
	    if($pattn eq '' || ref($pattn) eq 'REF'){
		if($pattn){
		    if($HXpkt =~ /$$$pattn/){
		        return $pattern;
		    }
	        }
		if(ref($size)){
		    if(ref($size) eq 'SCALAR'){$size=eval $$size;}
		    elsif(ref($size) eq 'CODE'){$size=$size->($F,$V);}
		}
	    }
	    elsif(ref($pattn) eq 'SCALAR'){
		if( eval $$pattn ){return $pattern;}
		if(ref($size)){
		    if(ref($size) eq 'SCALAR'){$size=eval $$size;}
		    elsif(ref($size) eq 'CODE'){$size=$size->($F,$V);}
		}
	    }
	    else{
		# 
		if(ref($size)){
		    if(ref($size) eq 'SCALAR'){$size=eval $$size;}
		    elsif(ref($size) eq 'CODE'){$size=$size->($F,$V);}
		}
		# 
		($val,$tmp)=CtPkDecType($HXpkt,$templ->{'TY'},$size);
		if($templ->{'MK'}){
		    $val=CtPkBitData($val,$size*8,$templ->{'MK'});
		}
		# 
		if($val eq $pattn){
##		    MsgPrint('HEX',"Match pattern[%s](%s) PT==$val\n",$pattern,$pattn) if(CtLgLevel('HEX'));
		    return $pattern;
		}
	    }
	    # 
	    $HXpkt=substr($HXpkt,$size*2);
	}
	
    }
    return '';
}

# HEX
sub CtPkDecType {
    my($hexString,$type,$len)=@_;
    my($val);
    if($type eq 'byte'){
	($val,$hexString)=CtPkDecByte($hexString,$len);
    }
    elsif($type eq 'uchar'){
	($val,$hexString)=CtPkDecUchar($hexString);
    }
    elsif($type eq 'short'){
	($val,$hexString)=CtPkDecShort($hexString);
    }
    elsif($type eq 'long'){
	($val,$hexString)=CtPkDecLong($hexString);
    }
    elsif($type eq 'float'){
	($val,$hexString)=CtPkDecFloat($hexString);
    }
    elsif($type eq 'ieee-float'){
	($val,$hexString)=PktDecodeFloat($hexString,'IEEE');
    }
    elsif($type eq 'double'){
	($val,$hexString)=CtPkDecDouble($hexString);
    }
    elsif($type eq 'ieee-double'){
	($val,$hexString)=PktDecodeDouble($hexString,'IEEE');
    }
    elsif($type eq 'hex'){
	$len=length($hexString)/2 if($len eq 'REST');
	($val,$hexString)=CtPkDecHex($hexString,$len);
    }
    elsif($type eq 'ipv4'){
	($val,$hexString)=CtPkDecV4($hexString,$len);
    }
    elsif($type eq 'ipv6'){
	($val,$hexString)=CtPkDecV6($hexString,$len);
    }
    elsif($type eq 'mac'){
	($val,$hexString)=CtPkDecMac($hexString,$len);
    }
    elsif($type eq 'any'){
	$val=$hexString;$hexString='';
    }
    else{
	MsgPrint('ERR',"CtPkDecType Type illegale [$type]\n");
    }
##    MsgPrint('HEX',"Val[%s:%x] Type[$type]\n",$val,$val);
    return $val,$hexString;
}
# 
sub CtPkDecUchar {
    my($data)=@_;
    my($val);
    ($val,$data)=unpack('a2a*',$data);
    return hex($val),$data;
}
sub CtPkDecShort {
    my($data)=@_;
    my($val);
    ($val,$data)=unpack('a4a*',$data);
    return hex($val),$data;
}
sub CtPkDecLong {
    my($data)=@_;
    my($val);
    ($val,$data)=unpack('a8a*',$data);
    return hex($val),$data;
}
sub CtPkDecFloat {
    my($data,$ieee)=@_;
    my($i,@val,$val);
    for $i (0..3){@val[$i]=substr($data,$i*2,2);} # HEX
    $val=$ieee ? pack('H2H2H2H2',@val[3],@val[2],@val[1],@val[0]) : 
	pack('H2H2H2H2',@val); # 
    return unpack('f',$val),substr($data,8); # 
}
sub CtPkDecDouble {
    my($data,$ieee)=@_;
    my($i,@val,$val);
    for $i (0..7){@val[$i]=substr($data,$i*2,2);}
    $val=$ieee ? pack('H2H2H2H2H2H2H2H2',@val[7],@val[6],@val[5],@val[4],@val[3],@val[2],@val[1],@val[0]) :
	pack('H2H2H2H2H2H2H2H2',@val);
    return unpack('d',$val),substr($data,16);
}
sub CtPkDecByte {
    my($data,$size)=@_;
    my($val,$tmp);
    $size *=2;
    ($val,$tmp)=pack('H' . $size . 'a*',$data);
    $data=substr($data,$size);
    return $val,$data;
}
sub CtPkDecHex {
    my($data,$size)=@_;
    my($val);
    $size *=2;
    ($val,$data)=unpack('a' . $size . 'a*',$data);
    return $val,$data;
}
sub CtPkDecV4 {
    my($data,$len)=@_;
    my($val,$v1,$v2,$v3,$v4);
    ($v1,$v2,$v3,$v4,$data)=unpack('a2a2a2a2a*',$data);
    $val=sprintf('%s.%s.%s.%s', hex($v1),hex($v2),hex($v3),hex($v4));
    if($len && 4<$len){$data=substr($data,($len-4)*2);}
    return $val,$data;
}
sub CtPkDecV6 {
    my($data,$len)=@_;
    my($val,$v1,$i);
    for $i (0..7){
	($v1,$data)=unpack('a4a*',$data);
	$val .= $v1 . (($i eq 7)?'':':');
    }
    if($len && 16<$len){$data=substr($data,($len-16)*2);}
    return $val,$data;
}
sub CtPkDecMac {
    my($data,$len)=@_;
    my($val,$v1,$v2,$v3,$v4,$v5,$v6);
    ($v1,$v2,$v3,$v4,$v5,$v6,$data)=unpack('a2a2a2a2a2a2a*',$data);
    $val=sprintf('%02x:%02x:%02x:%02x:%02x:%02x', hex($v1),hex($v2),hex($v3),hex($v4),hex($v5),hex($v6));
    if($len && 6<$len){$data=substr($data,($len-6)*2);}
    return $val,$data;
}
# 
sub CtPkBinDecUcha {
    my($data)=@_;
    my($val);
    $val=vec($data,0,8);
    return $val,substr($data,1);
}
sub CtPkBinDecShort {
    my($data)=@_;
    my($val);
    $val=vec($data,0,16);
    return $val,substr($data,2);
}
sub CtPkBinDecLong {
    my($data)=@_;
    my($val);
    $val=vec($data,0,32);
    return $val,substr($data,4);
}
# 
sub CtPkBinDecType {
    my($data,$start,$type,$len)=@_;
    if($type eq 'uchar'){
	return unpack('U',substr($data,$start,1));
    }
    elsif($type eq 'short'){
	return unpack('n',substr($data,$start,2));
    }
    elsif($type eq 'long'){
	return unpack('N',substr($data,$start,4));
    }
    elsif($type eq 'hex'){
	if($len eq 'REST'){
	    return unpack('H*', substr($data,$start));
	}
	return unpack('H' . $len*2, substr($data,$start,$len));
    }
    else{
	MsgPrint('ERR',"CtPkBinDecType Illegal Type[$type]\n");
    }
}


# bitpos:
# bitmask:
sub CtPkBitData {
    my($bitdata,$bitpos,$bitmask)=@_;
    my($val,$pat);
    $pat= ((2**$bitmask)-1) << ($bitpos-$bitmask);
    $val = $bitdata & $pat;
#    printf("CtPkBitData bitdata[%x],bitpos[$bitpos],bitmask[$bitmask] val[%x] mask[%x] bitval[%x]\n",$bitdata,$val, $pat, $val >> ($bitpos-$bitmask));
    return $val >> ($bitpos-$bitmask);
}


#============================================
# 
#============================================
# 
#   
#         
#         
#   'AC'
sub CtPkEncode {
    my($hexSt,$notRecursive)=@_;
    my($hexStTemp,$j,$field,$T,$st,$name,$bitmask,$bitdata,$bitpos,$HXpkt,$sub,$subSt,$type,$templ,$F,$V,$S,$TS,$act);

    # HEXst
    if(!$hexSt->{'##'} || !($hexStTemp=$HXPKTPatternDB{$hexSt->{'##'}})){return;}

    # 
    if($V=$hexSt->{'#EN#'}){
	if(ref($V) eq 'SCALAR'){
	    return eval $$V;
	}
	elsif(ref($V) eq 'CODE'){
	    return $V->($hexSt);
	}
	elsif(ref($V) eq 'HASH'){
	    if($act=$V->{'AC'}){
		if(ref($act) eq 'SCALAR'){
		    return eval $$act;
		}
		elsif(ref($act) eq 'CODE'){
		    return $act->($hexSt,$V);
		}
	    }
	}
	else{
	    return $hexSt->{'#EN#'};
	}
    }

    # 
    if(!$notRecursive && ($sub=$hexStTemp->{'sub'})){
	$subSt=$hexSt->{ $sub->{'NM'}?$sub->{'NM'}:$sub->{'start'} };
	foreach $st (@$subSt){
	    $S .= CtPkEncode($st);
	}
    }

    # 
    $F=$hexSt;

    # HEX
    if( $T=$hexStTemp->{'field'} ){
	# 
	foreach $field (@$T){
	    $name=$field->{'NM'};
	    $templ=$field->{'EN'};
	    if($field->{'ST'}){
		$HXpkt .= CtPkEncode($hexSt->{ $HXPKTPatternDB{$field->{'ST'}}->{'#Name#'} });
	    }
	    elsif($field->{'#CHOICE#'}){
		unless($name){
		    grep{ref($hexSt->{$_}) eq 'HASH' ? $name=$_ :''} keys(%$hexSt);
		}
		unless($name){
		    MsgPrint('WAR',"Not impliment unnamed #CHOICE#\n");
		}
		$V = CtPkEncode($hexSt->{$name});
		if($act=$templ->{'AC'}){
		    if(ref($act) eq 'CODE'){$V=$act->($F,$name,$V);}
		    elsif(ref($act) eq 'SCALAR'){$V=eval $$act;}
		}
		$HXpkt .= $V;
	    }
	    elsif($field->{'#ARRAY#'}){
		my($tmp);
		# 
                #   'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}}, 
                #   '#ARRAY#'=>[{'#CHOICE#'=>[ ....
		# #ARRAY#
		#   'EN'=>{'TY'=>'str','ACL'=>\q{$V=substr($V,1)}}, 
		$V='';
		foreach $sub (@{$hexSt->{$name}}){
		    $V = CtPkEncode($sub);
		    if($act=$templ->{'ACL'}){
			if(ref($act) eq 'CODE'){$V=$act->($F,$name,$V);}
			elsif(ref($act) eq 'SCALAR'){$V=eval $$act;}
		    }
		    $tmp .= $V;
		}
		# $V
		$V=$tmp;
		if($act=$templ->{'AC'}){
		    if(ref($act) eq 'CODE'){$V=$act->($F,$name,$V);}
		    elsif(ref($act) eq 'SCALAR'){$V=eval $$act;}
		}
		$HXpkt .= $V;
	    }
	    else{
                #   'AC'
		if($act=$templ->{'AC'}){
		    if(ref($act) eq 'CODE'){$V=$act->($F,$name,$S);$hexSt->{$name}=$V;}
		    elsif(ref($act) eq 'SCALAR'){$V=eval $$act;$hexSt->{$name}=$V;}
		    elsif(ref($act) eq 'REF'){$V=$hexSt->{$name};$V=eval $$$act;}
		}
		else{
		    $V=$hexSt->{$name};
		}
		# 
		$bitmask=$templ->{'MK'};
		# 
		if($bitmask){
		    if($templ->{'SZ'} ne 0){$TS=$templ->{'SZ'};}
		}
		else{
		    $TS=$templ->{'SZ'};
		}
		if(ref($TS) eq 'SCALAR'){$TS=eval $$TS;}
		elsif(ref($TS) eq 'CODE'){$TS=$TS->($F,$V);}
		
		# 
		if(!$bitmask && $V eq ''){
		    for $j (1..$TS){$HXpkt .= '00';}
##		    MsgPrint('HEX',"Encode data(%s) dose not exist, 0 padding 00*%s.\n", $name,$TS) if(CtLgLevel('HEX'));
		    next;
		}
		# 
		if($bitmask){
##		    printf("bitmask[%s] bitpos[%s] TS[%s] bitdata[%s]\n",$bitmask,$bitpos,$TS,$bitdata);
		    if($bitpos eq ''){ $bitpos=$TS*8; }
		    $bitpos-=$bitmask;
		    $bitdata=($V<<$bitpos) | $bitdata;
		    if($bitpos eq 0){
			$HXpkt .= sprintf('%0' . $TS*2 . 'x',$bitdata);
			$bitpos='';
			$bitdata=0;
		    }
		}
		# 
		else{
		    $type=$templ->{'TY'};
		    if(ref($type) eq 'SCALAR'){$type = eval $$type;}
		    elsif(ref($type) eq 'CODE'){$type = $type->($F,$V);}
		    $V=CtPkHexEncType($V,$type,$TS);
		    unless($type){PrintVal($field);}
		    $HXpkt .= $V;
		    $bitpos='';
		    $bitdata=0;
		    if($TS eq 'REST' && $V){last;}
		}
	    }
	}
    }
#    PrintItem($HXpkt);
    return $HXpkt . $S;
}

# HEX
sub CtPkHexEncType {
    my($data,$type,$len)=@_;
    my($val,$i,$len2,@tmp);
    if($type eq 'byte'){
	$val=unpack('H' . $len*2,$data);
	$len=$len*2-length($val);
	for $i(1..$len){$val .='0';}
    }
    elsif($type eq 'uchar'){
	$val=sprintf("%02x",$data);
	$val=substr($val,0,2);
    }
    elsif($type eq 'short'){
	$val=sprintf("%04x",$data);
	$val=substr($val,0,4);
    }
    elsif($type eq 'long'){
	$val=sprintf("%08x",$data);
	$val=substr($val,0,8);
    }
    # float
    #  6.0 => 0x40,0xC0,0x00,0x00
    elsif($type eq 'float'){ 
	$val=pack('f',$data);   # 
	@tmp=unpack('C4',$val); # 
	$val=sprintf("%02x%02x%02x%02x",@tmp[0],@tmp[1],@tmp[2],@tmp[3]); # 
    }
    elsif($type eq 'ieee-float'){ 
	$val=pack('f',$data);   # 
	@tmp=unpack('C4',$val); # 
	$val=sprintf("%02x%02x%02x%02x",@tmp[3],@tmp[2],@tmp[1],@tmp[0]); # 
    }
    elsif($type eq 'double'){
	$val=pack('d',$data);
	@tmp=unpack('C8',$val);
	$val=sprintf("%02x%02x%02x%02x%02x%02x%02x%02x",@tmp[0],@tmp[1],@tmp[2],@tmp[3],@tmp[4],@tmp[5],@tmp[6],@tmp[7]);
    }
    elsif($type eq 'ieee-double'){
	$val=pack('d',$data);
	@tmp=unpack('C8',$val);
	$val=sprintf("%02x%02x%02x%02x%02x%02x%02x%02x",@tmp[7],@tmp[6],@tmp[5],@tmp[4],@tmp[3],@tmp[2],@tmp[1],@tmp[0]);
    }
    elsif($type eq 'hex'){
	$len=length($data)/2 if($len eq 'REST');
	$val=substr($data,0,$len*2);
	if( length($val) % 2 ){ $val = '0' . $val;}
	if(length($val) < $len*2){$len=$len-length($val)/2;for $i (1..$len){$val .='00';}}
    }
    elsif($type eq 'ipv4'){
	$val=CtUtV4StrToHex($data);
	if(4<$len){for $i(0..$len-5){$val .='00';}} # 
    }
    elsif($type eq 'ipv6'){
	$val=CtUtV6StrToHex($data);
	if(16<$len){for $i(0..$len-17){$val .='00';}}  # 
    }
    elsif($type eq 'mac'){
	@tmp=split(/:/,$data);
	for $i(0..5){$val .=@tmp[$i];}
    } 
    elsif($type eq 'dnsnames'){  # DNS 
	$val=DNSEncodeName($data);
    }
    elsif($type eq 'str+sp'){
	$val = $data . ' ';
    }
    elsif($type eq 'str'){
	$val = $data;
    }
    elsif($type eq 'comma+str'){
        $val = ',' . $data;
    }
    elsif($type eq 'comma+str+sp'){
        $val = ',' . $data . ' ';
    }
    else{
	MsgPrint('ERR',"CtPkHexEncType Type illegale [$type]\n");
    }
#    MsgPrint('HEX',"Val[%s] Type[$type]\n",$val);
    return $val;
}

# 
# HEX
# sub HXCheckHexDataLeng {
#     my($hexData,$ptn)=@_;
#     my($hexLeng,$len,$hexStTemp);
#     $hexLeng=length($hexData)/2;

#     $hexStTemp=$HXPKTPatternDB{$ptn};
#     if(defined($hexStTemp->{'#Length#'})){
# 	$len=$hexStTemp->{'#Length#'};
# 	if(!ref($len)){
# ##	    printf("lengnth %s <= %s\n",$len,$hexLeng);
# 	    return $len<=$hexLeng;
# 	}
# 	elsif(ref($len) eq 'CODE'){
# 	    $len = $len->(@_);
# ##	    printf("Code lengnth %s <= %s\n",$len,$hexLeng);
# 	    return $len<=$hexLeng;
# 	}
# 	elsif(ref($len) eq 'SCALAR'){
# 	    $len = eval $$len;
# 	    return $len<=$hexLeng;
# 	}
#     }
#     else{
# 	return 'OK';
#     }
# }

#============================================
# 
#============================================
sub CtPkText {
    my($hexSt,$msgs,$level,$CX)=@_;
    my($hexStTemp,$field,$V,$st,$sub,$subSt,$expr,$val);

    # HEXst
    if(!$hexSt->{'##'} || !($hexStTemp=$HXPKTPatternDB{$hexSt->{'##'}})){return;}

    # 
    if($hexSt->{'#TXT#'} && $hexStTemp->{'#TX#'}->{'LOG'}){
	$V=$hexSt->{'#TXT#'};
	if($expr=$hexStTemp->{'#TX#'}->{'LOG'}->{'AC'}){
	    if(ref($expr) eq 'SCALAR'){$V = eval $$expr;}
	    elsif(ref($expr) eq 'CODE'){$V = $expr->($V,$hexSt);}
	    elsif(ref($expr) eq 'HASH'){$V = $expr->{$V};}
	}
	push(@$msgs,{'Field'=>$field->{'NM'},'Value'=>$V,'Level'=>$level});
	return $msgs;
    }

    # HEX
    if( $hexStTemp->{'field'} ){
	# 
	foreach $field (@{$hexStTemp->{'field'}}){
	    $V=$hexSt->{$field->{'NM'}};
	    # 
	    if($field->{'TXT'}){
		$expr=$field->{'TXT'}->{'AC'};
		if(ref($expr) eq 'SCALAR'){$V = eval $$expr;}
		elsif(ref($expr) eq 'CODE'){$V = $expr->($V,$field->{'NM'},$hexSt,$msgs,$level);}
		elsif(ref($expr) eq 'HASH'){$V = $expr->{$V};}
		if(ref($V) eq 'HASH'){CtPkText($V,$msgs,$level+1,$CX); next;}
#		elsif(ref($V) eq 'ARRAY'){foreach $val (@$V){CtPkText($val,$msgs,$level+1,$CX);} next;}
	    }
	    if(ref($V) eq 'ARRAY'){
		foreach $val (@$V){
		    if(ref($val) eq 'HASH'){
			CtPkText($val,$msgs,$level+1,$CX); 
		    }
		    else{
			push(@$msgs,{'Field'=>$field->{'NM'},'Value'=>$val,'Level'=>$level});
		    }
		}
	    }
	    else{
		push(@$msgs,{'Field'=>$field->{'NM'},'Value'=>$V,'Level'=>$level});
	    }
##	    printf("%s%s:%s\n",'  ' x $level,$field->{'NM'},$V);
	}
    }
    # 
    if($sub=$hexStTemp->{'sub'}){
	$subSt=$hexSt->{ $sub->{'NM'}?$sub->{'NM'}:$sub->{'start'} };
	foreach $st (@$subSt){
##	    printf("%s%s\n",'--' x $level,$st->{'##'});
	    if($CX->{'SKIP'} && grep{$st->{'#Name#'} eq $_} @{$CX->{'SKIP'}}){next;}
	    push(@$msgs,{'Node'=>$st->{'##'},'Level'=>$level});
	    CtPkText($st,$msgs,$level+1,$CX);
	    if($CX->{'STOP-NODE'} && $CX->{'STOP-NODE'} eq $st->{'#Name#'}){last;}
	}
    }
    return $msgs;
}

#============================================
# 
#   /IP4/PPPoP:data/DHCP4:requst
#   /IP4/UDP/DNS:Query:A,AAAA
#============================================

#============================================
# 
#============================================
# 
sub CtFlGet {
    my($field,$hexSt,$mode)=@_;
    my($context,$val,$status);
    $context->{'pkt'}=$hexSt;
    $context->{'field'}=$field;
    # 
    ($val,$status,$field)=CtFlAcvl($hexSt,$field,'',0,$context);
    if($mode eq 'T'){
	return $status?'':$val;
    }
    return $status?'':((!ref($val)||ref($val) eq 'HASH')?$val:(ref($val) eq 'ARRAY' ? ($#$val<1?$val->[0]:$val):$val));
}
# 
sub CtFlSet {
    my($field,$hexSt,$mode,$val)=@_;
    my($context,$ret,$status,$access,$point,$index,@index,$i);
    my($P,$I,$NV,$FV);  # $P:
    $context->{'pkt'}=$hexSt;
    $context->{'field'}=$field;

    # 
    if($mode eq 'SET'){
	@index=split(/\,/,$field);
	for $i (0..$#index-1){
	    if(ref($hexSt->{@index[$i]}) ne 'HASH'){
		$hexSt->{@index[$i]}={};
		$hexSt=$hexSt->{@index[$i]};
	    }
	    else{
		$hexSt=$hexSt->{@index[$i]};
	    }
	}
	$hexSt->{@index[$#index]}=$val;
	return;
    }

    # 
    ($FV,$status,$field)=CtFlAcvl($hexSt,$field,'',0,$context);

    if(!$status && ($point=$context->{'POINT'})){
	$index=$context->{'INDEX'};
	if($mode eq 'Set'){   # 
	    if(ref($point) eq 'HASH'){$point->{$index}=$val;}
	    elsif(ref($point) eq 'ARRAY'){$point->[$index]=$val;}
	    else{MsgPrint('ERR',"CtFlSet(%s) point type not array or hash\n",$field);}
	}
	if($mode eq 'EncSet'){ # 
	    if(ref($point) eq 'HASH'){
		if(ref($point->{$index}) eq 'ARRAY'){
		    $point->{'#EN#'}=$val;
		}
		elsif(ref($point->{$index}) eq 'HASH'){
		    $point->{$index}->{'#EN#'}=$val;
		}
		else{
		    $point->{$index}=$val;
		}
	    }
	    elsif(ref($point) eq 'ARRAY'){
		if(ref($point->[$index]) eq 'HASH'){
		    $point->[$index]->{'#EN#'}=$val;
		}
		else{
		    $point->[$index]=$val;
		}
	    }
	    else{MsgPrint('ERR',"CtFlSet(%s) point type not array or hash\n",$field);}
	}
	elsif($mode eq 'Add'){ # 
	    if(ref($point) eq 'ARRAY'){unshift(@$point,$val);}
	    else{MsgPrint('ERR',"CtFlSet(%s) point type not array\n",$field);}
	}
	elsif($mode eq 'Append'){ # 
	    if(ref($point) eq 'ARRAY'){push(@$point,$val);}
	    else{MsgPrint('ERR',"CtFlSet(%s) point type not array\n",$field);}
	}
	elsif($mode eq 'Del'){ # 
	    if(ref($point) eq 'HASH'){delete($point->{$index});}
	    elsif(ref($point) eq 'ARRAY'){splice(@$point,$index,1);}
	    else{MsgPrint('ERR',"CtFlSet(%s) point type not array or hash\n",$field);}
	}
	elsif($mode eq 'Ins'){ # 
	    if(ref($point) eq 'ARRAY'){splice(@$point,$index,0,$val);}
	    else{MsgPrint('ERR',"CtFlSet(%s) point type not array or hash\n",$field);}
	}
	elsif(ref($mode) eq 'SCALAR'){
	    $P=$point;$I=$index;$NV=$val;
	    eval $$mode;
	}
    }
    else{
	MsgPrint('WAR',"CtFlSet invalid parameter. Status[%s] Point[%s] Field[%s]\n",$status,$point,$context->{'field'});
    }
}
# 
sub CtFlDel {
    my($field,$hexSt)=@_;
    my($context,$status,$point,$index,$fv);
    $context->{'pkt'}=$hexSt;
    $context->{'field'}=$field;
    # 
    ($fv,$status,$field)=CtFlAcvl($hexSt,$field,'',0,$context);

    if(!$status && ($point=$context->{'POINT'})){
	$index=$context->{'INDEX'};
	if(ref($point) eq 'HASH'){
	    delete($point->{$index});
	}
	elsif(ref($point) eq 'ARRAY'){
	    splice(@$point,$index,1);
	}
    }
}
# ``
sub CtFlEval {
    my($field,$hexSt)=@_;
    my($context,$val,$status);
    $context->{'pkt'}=$hexSt;
    $context->{'field'}=$field;
    ($val,$status,$field)=CtFlAcvl($hexSt,$field,'eval',0,$context);
    return $status?'':((!ref($val)||ref($val) eq 'HASH')?$val:($#$val<1?$val->[0]:$val));
}
# 
sub CtFlGetTempl {
    my($tempName,$fieldName)=@_;
    my($hexStTemp,$field,$fields);
    if(!($hexStTemp=$HXPKTPatternDB{$tempName})){return;}
    $fields=$hexStTemp->{'field'};
    foreach $field (@$fields){
	if($field->{'NM'} eq $fieldName){ return $field;}
    }
    return;
}
# 
sub CtFlEncode {
    my($field,$hexSt,$notRecursive)=@_;
    my($context,$status,$point,$index,$val,$templ);
    $context->{'pkt'}=$hexSt;
    $context->{'field'}=$field;

    # 
    ($val,$status,$field)=CtFlAcvl($hexSt,$field,'',0,$context);
    if(!$status && ($point=$context->{'POINT'})){
	$index=$context->{'INDEX'};
	if(ref($point) eq 'HASH'){
	    # 
	    if(!($templ=CtFlGetTempl($point->{'##'},$index))){
		MsgPrint('ERR',"CtFlEncode(%s) can't find template\n",$point->{'##'});
		return;
	    }
	    $val=(ref($val) eq 'ARRAY')?$val->[0]:$val;
	    $val=CtPkHexEncType($val,$templ->{'EN'}->{'TY'},$templ->{'EN'}->{'SZ'});
	}
	elsif(ref($point) eq 'ARRAY'){
	    $val=CtPkEncode($val,$notRecursive);
	}
	else{
	    MsgPrint('ERR',"CtFlEncode(%s) point type not array or hash\n",$field);
	    return;
	}
    }
    return $val;
}

## DEF.VAR
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
#   POINT: 
#   INDEX: 
# 
# 
#$PTN_FIELD_EXPR='^\s*([\w#]+)\s*`([^`]+)`(.*)$';
#$PTN_FIELD     ='^\s*([\w#]+)\s*(?:([,}].+)$|$)';
$PTN_FIELD_EXPR='^\s*([\w#=-]+)\s*`([^`]+)`(.*)$';	#=-
$PTN_FIELD     ='^\s*([\w#=-]+)\s*(?:([,}].+)$|$)';	#=-
$PTN_COMMA     ='^\s*,(.+)$';
$PTN_OR_BRACES ='^\s*(?:{\|)(.+)$';
$PTN_SL_BRACES ='^\s*(?:{!)(.+)$';
$PTN_LT_BRACES ='^\s*(?:{)(.+)$';
$PTN_RT_BRACES ='^\s*(?:})(.*)$';
$PTN_INDEX     ='(?:[0-9]+)';
#$PTN_SUBTAG    ='(?:([a-zA-Z][a-zA-Z_-]+)([0-9]*))';
$PTN_SUBTAG    ='(?:([a-zA-Z][a-zA-Z_=-]+)([0-9]*))';	#=
#$PTN_TAG       ='^([^#]+)#((?:(?:[0-9]+)|(?:[a-zA-Z][a-zA-Z_-]+[0-9]*)|[NOD]))$';
$PTN_TAG       ='^([^#]+)#((?:(?:[0-9]+)|(?:[a-zA-Z][a-zA-Z_=-]*[0-9]*)|[NOD]))$';	#=
## $PTN_ARRAY_TAG ='#((?:[a-zA-Z][a-zA-Z_-]+))((?:(?:#[NOD])|(?:[0-9]*)))(.*)$';
#$PTN_ARRAY_TAG ='^#((?:[a-zA-Z][0-9a-zA-Z_-]+))(?:(?:((?:#(?:[NOD]|[0-9]*)))(.*))|(.*))$';
$PTN_ARRAY_TAG ='^#((?:[a-zA-Z][0-9a-zA-Z_=-]+))(?:(?:((?:#(?:[NOD]|[0-9]*)))(.*))|(.*))$';	#=
## DEF.END


# 
sub CtFlAcvl {
    my($hexSt,$field,$mode,$level,$context)=@_;
    my($val,$nextField,$status,$match,$tag,$expr,$index,$subSt,$subTag,$subIndex,$idx,$newSt);
    my($P,$F,$V);

##    printf("<==CtFlAcvl hexSt[%s] field=$field level=$level mode=$mode INDEX[%s]\n",ref($hexSt),$context->{'INDEX'});

    while($field){
	# 
	if( $field =~ /$PTN_FIELD_EXPR/ ){
	    $tag=$1;$expr=$2;$nextField=$3;
##	    printf("[PTN_FIELD_EXPR] tag[$1] expr[$2] next[$3] hexSt[%s]\n",ref($hexSt));
	    # 
            if(ref($hexSt) eq 'ARRAY'){
		return CtFlAcvlar($hexSt,$field,$mode,$level,$context);
	    }
	    else{
		# 
		if($tag =~ /$PTN_TAG/){$tag=$1;$index=$2;}
		# 
		if(!exists($hexSt->{$tag})){
		    MsgPrint(WAR,"FieldEx($field) Item($tag) not exist\n");
		    if  ($mode eq 'and'){return '','Field not exist';}
		    elsif($mode eq 'or'){return CtFlAcvl($hexSt,$nextField,$mode,$level+1,$context);}
		    else                {return '','Field not exist';}
		}
		# 
#		$context->{'POINT'}=$hexSt;
#		$context->{'INDEX'}=$tag;

		# 
		$V=$hexSt->{$tag};
		# 
		if($index ne ''){
		    if   ($index eq 'N'){$V=($#$V eq '')?0:$#$V+1;}
		    elsif(ref($V) eq 'ARRAY'){
			# 
#			$context->{'POINT'}=$V;
#			$context->{'INDEX'}=$index;
			if($index =~ /^$PTN_INDEX$/){$V=$V->[$index];}
			elsif($index =~ /^$PTN_SUBTAG$/){
			    $subTag=$1;
			    $subIndex=$2;
			    if($subIndex eq ''){
				@$newSt=();
				foreach $subSt (@$V){
				    if($subSt->{'#Name#'} eq $subTag){push(@$newSt,$subSt);}
				}
				$V=$newSt;
#				$context->{'INDEX'}='';
			    }
			    else{
				$idx=-1;
				foreach $subSt (@$V){
				    $idx++;
				    if($subSt->{'#Name#'} eq $subTag){
					if(!$subIndex){$V=$subSt;last;}
					$subIndex--;
				    }
				}
			    }
			}
		    }
		    elsif($index eq 'D'){ # 
##			printf("Field=[$field] Tag=[$tag] v=[$V] contect:field[%s] level[$level]\n",$context->{'field'});
			if(ref($V)){PrintVal($V);}
		    }
		}
		$P=$context->{'pkt'};$F=$context->{'field'};
		$val=eval $expr;
##		printf("eval expr[$expr] v=[$V] outout=[$val] mode[$mode] nextField[$nextField] INDEX[%s]\n",$context->{'INDEX'});
		if($val){$context->{'INDEX'}=$context->{'LOOPNO'};}
		# AND
                if($mode eq 'and'){
		    if($val) {return CtFlAcvl($hexSt,$nextField,$mode,$level+1,$context);}
		    else     {return '','Eval false';}
		}
		# OR
		elsif($mode eq 'or'){
		    if(!$val){return CtFlAcvl($hexSt,$nextField,$mode,$level+1,$context);}
		    else     {return $hexSt;}
		}
		# EVAL
		elsif($mode eq 'eval'){
		    return $val;
		}
		# 
		else{
		    if($val) {return CtFlAcvl($hexSt,$nextField,$mode,$level+1,$context);}
		    else     {return '','Eval false';}
		}
	    }
	}
	# 
	elsif( $field =~ /$PTN_FIELD/ ){
	    $tag=$1; $nextField=$2;
##	    printf("[PTN_FIELD][$1][$2] array(%s)\n", ref($hexSt));
	    # 
            if(ref($hexSt) eq 'ARRAY'){
		return CtFlAcvlar($hexSt,$field,$mode,$level,$context);
	    }
	    else{
		# 
####		printf("[PTN_FIELD] tag[$tag] index[$index]\n");
		if($tag =~ /$PTN_TAG/){$tag=$1;$index=$2;}
####		printf("[PTN_FIELD] tag[$tag] index[$index]\n");
####		# 
		if(!exists($hexSt->{$tag})){
##		    MsgPrint('HEX',"Field($field) Item($tag) not exist\n") if(CtLgLevel('HEX'));
		    return '','Field not exist';
		}
		# 
		if($index ne ''){
		    $V=$hexSt->{$tag};
		    if   ($index eq 'N'){return ($#$V eq '')?0:$#$V+1;}
		    elsif($index eq 'D'){
##			printf("Field=[$field] Tag=[$tag] v=[$V] contect:field[%s] level[$level]\n",$context->{'field'});
			if(ref($V)){PrintVal($V);}
		    }
		    else{
			if(ref($V) eq 'ARRAY'){
			    if($index =~ /^$PTN_INDEX$/){
				# 
				$context->{'POINT'}=$V;
				$context->{'INDEX'}=$index;
				return CtFlAcvl($V->[$index],$nextField,$mode,$level+1,$context);
			    }
			    elsif($index =~ /^$PTN_SUBTAG$/){
				$subTag=$1;
				$subIndex=$2;
				if($subIndex eq ''){
				    @$newSt=();
				    foreach $subSt (@$V){
					if($subSt->{'#Name#'} eq $subTag){push(@$newSt,$subSt);}
				    }
				    # 
				    $context->{'POINT'}=$newSt;
				    $context->{'INDEX'}='';
				    return CtFlAcvl($newSt,$nextField,$mode,$level+1,$context);
				}
				else{
##				    printf("[PTN_FIELD] subTag[$subTag] subIndex[$subIndex]\n");
				    $idx=-1;
				    foreach $subSt (@$V){
					$idx++;
					if($subSt->{'#Name#'} eq $subTag){
					    if(!$subIndex){
						# 
						$context->{'POINT'}=$V;
						$context->{'INDEX'}=$idx;
						return CtFlAcvl($subSt,$nextField,$mode,$level+1,$context);
					    }
					    $subIndex--;
					}
				    }
				}
			    }
			}
			MsgPrint(WAR,"Array #$index is not exist\n");
			return '','Field not exist';
		    }
	        }
		# 
		$context->{'POINT'}=$hexSt;
		$context->{'INDEX'}=$tag;
		return CtFlAcvl($hexSt->{$tag},$nextField,$mode,$level+1,$context);
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
            if(ref($hexSt) eq 'ARRAY'){
		($val,$status,$match)=CtFlAcvlar($hexSt,$nextField,'or',$level,$context);
	    }
	    else{
		($val,$status)=CtFlAcvl($hexSt,$nextField,'or',$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=CtFlEndBraces($nextField);
		return CtFlAcvl($match,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return $val,$status,$match;
	    }
 	}
 	# {!
        elsif( $field =~ /$PTN_SL_BRACES/ ){
	    $nextField=$1;
# 	    printf("[{!][$1]\n");
            if(ref($hexSt) eq 'ARRAY'){
		($val,$status,$match)=CtFlAcvlar($hexSt,$nextField,$mode,$level,$context);
	    }
	    else{
		($val,$status)=CtFlAcvl($hexSt,$nextField,$mode,$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=CtFlEndBraces($nextField);
		return CtFlAcvl($hexSt,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return $val,$status,$match;
	    }
 	}
 	# {
        elsif( $field =~ /$PTN_LT_BRACES/ ){
	    $nextField=$1;
	    # 
            if(ref($hexSt) eq 'ARRAY'){
		($val,$status,$match)=CtFlAcvlar($hexSt,$nextField,'and',$level,$context);
	    }
	    else{
		($val,$status)=CtFlAcvl($hexSt,$nextField,'and',$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=CtFlEndBraces($nextField);
		return CtFlAcvl($match,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return $val,$status,$match;
	    }
 	}
        # }
        elsif( $field =~ /$PTN_RT_BRACES/ ){
	    # OR
	    if($mode eq 'or'){return '','OR false';}
	    return $hexSt;
        }
        else{
            MsgPrint('ERR',"Access Field Spec is illegal[$field]\n");
            return '','Illegal format';
        }
    }
    # OR
    if($mode eq 'or'){return '','OR false';}
    return $hexSt;
}
sub CtFlAcvlar {
    my($hexSt,$field,$mode,$level,$context)=@_;
    my(@result,@match,$i,$val,$status,$elem,$index,$idx,$subindex,$tag,$count,$no);
    
##    printf("ARRAY loop [$field]\n");
    $context->{'POINT'}=$hexSt;
    # 
    if($field =~ /^#Name#$/i){goto SKIP;}
    if($field =~ /$PTN_ARRAY_TAG/){  
	$tag=$1;
	if($2){$index=$2;$field=$3;}
	else{$field=$4;}
##	printf("  ARRAY tag[$tag] index[$index] field[$field]\n");
	if($index =~ /#([NOD])/){
	   $subindex=$1;
	   if($subindex eq 'N'){
	       foreach $elem (@$hexSt){if($elem->{'#Name#'} eq $tag){$count++;}}
	       return $count;
	   }
           # 
	   #   INET,#TCP#O 
	   elsif($subindex eq 'O'){
	       foreach $elem (@$hexSt){
		   if($elem->{'#Name#'} eq $tag){
		       $context->{'POINT'}=$elem->{$tag};
		       return $elem->{$tag};
		   }
	       }
	   }
	}
	elsif($index ne ''){
	    $idx=substr($index,1);$no=0;
	    # 
	    foreach $elem (@$hexSt){
		if($elem->{'#Name#'} eq $tag){
		    if(!$idx){
			# 
			$context->{'INDEX'}=$no;
			return CtFlAcvl($elem,$field,$mode,$level+1,$context);
		    }
		    else{$idx--;}
		}
		$no++;
	    }
	}
	else{
	    $no=0;
	    # 
	    foreach $elem (@$hexSt){
		if($elem->{'#Name#'} eq $tag){
##		    printf("Tag[%s] elem[%s] field[%s]\n",$tag,$elem->{$tag},$field);
		    # 
		    $context->{'INDEX'}=$no;
# #Name#
		    ($val,$status)=CtFlAcvl(ref($elem->{$tag}) eq 'ARRAY'?$elem->{$tag}:$elem,$field,$mode,$level+1,$context);
		    if(!$status){
			# 
			if(ref($val) eq 'ARRAY'){push(@result,@$val);}
			else {push(@result,$val);}
			push(@match,$elem);
		    }
		}
		$no++;
	    }
	}
	return \@result,$#result<0,\@match;
    }
SKIP:
    # 
    $no=0;
    foreach $elem (@$hexSt){
	# 
	if(!$elem){$no++;next;}
	# 
	$context->{'LOOPNO'}=$no;
	# 
	($val,$status)=CtFlAcvl($elem,$field,$mode,$level+1,$context);
	if(!$status){
	    # 
	    if(ref($val) eq 'ARRAY'){push(@result,@$val);}
	    else {push(@result,$val);}
	    push(@match,$elem);
	}
	$no++;
    }
    return \@result,$#result<0,\@match;
}

sub CtFlReduceAR {
    my($hexSt,$field,$mode,$level,$context)=@_;
    my(@match,$i,$val,$status);
    
    # 
    for($i=0;$i<=$#$hexSt;$i++){
	# 
	if(!$hexSt->[$i]){next;}
	# 
	($val,$status)=CtFlReduce($hexSt->[$i],$field,$mode,$level+1,$context);
	if(!$status){
	    # 
	    push(@match,$val);
	}
    }
    return \@match,$#match<0;
}

# 
sub CtFlReduce {
    my($hexSt,$field,$mode,$level,$context)=@_;
    my($key,$val,$newdata,$tag,$expr,$nextField,$status,$index,$v);
    
    while($field){
	# 
	if( $field =~ /$PTN_FIELD_EXPR/ ){
	    $tag=$1;$expr=$2;$nextField=$3;
	    # 
            if(ref($hexSt) eq 'ARRAY'){
		return CtFlReduceAR($hexSt,$field,$mode,$level,$context);
	    }
	    # 
	    if($tag =~ /$PTN_TAG/){$tag=$1;$index=$2;}

	    # 
	    $v=$hexSt->{$tag};
	    # 
	    if($index ne '' && ref($v) eq 'ARRAY'){$v=$v->[$index];}
	    $val=eval $expr;

	    # AND
	    if(!$mode || $mode eq 'and'){
		if($val) {return CtFlAcvl($hexSt,$nextField,$mode,$level+1,$context);}
		else     {return '','eval false'}
	    }
	    elsif($mode eq 'or'){
		if($val) {return $hexSt;}
		else     {return CtFlAcvl($hexSt,$nextField,$mode,$level+1,$context);}
	    }
	}
	# 
	elsif( $field =~ /$PTN_FIELD/ ){
	    $tag=$1;
	    $nextField=$2;
	    # 
            if(ref($hexSt) eq 'ARRAY'){
		return CtFlReduceAR($hexSt,$field,$mode,$level,$context);
	    }
	    # 
	    if($tag =~ /$PTN_TAG/){$tag=$1;$index=$2;}

	    # 
	    while(($key,$val)=each(%$hexSt)){
		if($key ne $tag){$newdata->{$key}=$val;}
	    }
	    # 
	    if(!grep{$_ eq $tag} keys(%$hexSt)){
		MsgPrint(WAR,"CtFlReduce Field($field) Item($tag) not exist\n");
		if(!$mode)        {return $newdata;}
		if($mode eq 'and'){return '','key not exist';}
		if($mode eq 'or') {return '','key not exist';}
	    }
	    # 
	    if($index ne ''){
		$v=$hexSt->{$tag};
		if(ref($v) eq 'ARRAY'){
		    ($val,$status)=CtFlReduce($v->[$index],$nextField,$mode,$level+1,$context);
		    # 
		    $newdata->{$tag}->[0]=(!$status)?$val:'';
		}
	    }
	    elsif($hexSt->{$tag}){
		($val,$status)=(ref($hexSt) eq 'ARRAY')?
		    CtFlReduceAR($hexSt,$field,$mode,$level,$context):
		    CtFlReduce($hexSt->{$tag},$nextField,$mode,$level+1,$context);
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
            if(ref($hexSt) eq 'ARRAY'){
		($val,$status)=CtFlReduceAR($hexSt,$nextField,$mode,$level,$context);
	    }
	    else{
		($val,$status)=CtFlAcvl($hexSt,$nextField,$mode,$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=CtFlEndBraces($nextField);
		return CtFlReduce($hexSt,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return $val,$status;
	    }
 	}
 	# {
        elsif( $field =~ /$PTN_LT_BRACES/ ){
	    $nextField=$1;
	    # 
            if(ref($hexSt) eq 'ARRAY'){
		($val,$status)=CtFlReduceAR($hexSt,$nextField,'and',$level,$context);
	    }
	    else{
		($val,$status)=CtFlReduce($hexSt,$nextField,'and',$level+1,$context);
	    }
	    if(!$status){
		# 
		$nextField=CtFlEndBraces($nextField);
		return CtFlAcvl($val,$nextField,$mode,$level+1,$context);
	    }
	    else{
		return '','false {';
	    }
 	}
        # }
        elsif( $field =~ /$PTN_RT_BRACES/ ){
	    # OR
	    if($mode eq 'or'){return '','OR false';}
	    return $hexSt;
        }
        else{
            MsgPrint('ERR',"Access Field Spec is illegal[$field]\n");
            return '','Illegal format';
        }
    }
    return $hexSt;
}

# 
sub CtFlEndBraces {
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
	    $field=CtFlEndBraces($1);
 	}
 	# {!
        elsif( $field =~ /$PTN_SL_BRACES/ ){
	    $field=CtFlEndBraces($1);
 	}
 	# {
        elsif( $field =~ /$PTN_LT_BRACES/ ){
	    $field=CtFlEndBraces($1);
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
# IKR
#  $name
sub CtPkAddHex {
    my($upper,$name,$data)=@_;
    my($hexStTemp,$hexSt,$key,$value,$item,$exp);
    
    if(!$name){
	$name=$data->{'#Name#'};
	$hexSt={%$data};
    }
    else{
	if(!($hexStTemp=$HXPKTPatternDB{$name})){
	    MsgPrint('WAR',"Templete name[$name] is illegal\n");
	    return '';
	}
	# 
	while(($key,$value)=each(%$hexStTemp)){
	    if($key =~ '^#'){$hexSt->{$key}=$value;}
	}
	foreach $item (@{$hexStTemp->{'field'}}){
	    if($item->{'NM'}){
		if($data->{$item->{'NM'}} ne ''){
		    $hexSt->{$item->{'NM'}}=$data->{$item->{'NM'}};
		}
		else{
		    $exp=$item->{'IV'};
		    if(ref($exp) eq 'SCALAR'){
			$hexSt->{$item->{'NM'}}=eval $$exp;
		    }
		    elsif(ref($exp) eq 'CODE'){
			$hexSt->{$item->{'NM'}}=$exp->($hexSt);
		    }
		    else{
			$hexSt->{$item->{'NM'}}=$exp;
		    }
		}
#		$hexSt->{$item->{'NM'}}=($data->{$item->{'NM'}} ne '') ? $data->{$item->{'NM'}}:$item->{'IV'};
	    }
	}
	$name=$hexStTemp->{'#Name#'};
    }
    # 
    if( ref($upper) eq 'ARRAY' ){push(@{$upper},$hexSt);}
    elsif($upper){
	if($hexStTemp=$HXPKTPatternDB{$upper->{'##'}}){
	    if($hexStTemp->{'sub'}){
		push(@{$upper->{$hexStTemp->{'sub'}->{'NM'}}},$hexSt);
	    }
	    else{
		push(@{$upper->{$name}},$hexSt);
	    }
	}
	else{
	    push(@{$upper->{$name}},$hexSt);
	}
    }
    return $hexSt;
}

#============================================
# 
#============================================
sub CtPkEncLength {
    my($hexSt,$notRecursive)=@_;
    my($hexStTemp,$field,$fields,$st,$sub,$size,$totalSize,$templ,$F,$V);

    unless($hexSt){return 0;}

    # 
    if(ref($hexSt) eq 'ARRAY'){
	foreach $sub (@$hexSt){
	    $totalSize += CtPkEncLength($sub,$notRecursive);
	}
	return $totalSize;
    }

    # HEXst
    if(!($hexStTemp=$HXPKTPatternDB{$hexSt->{'##'}})){
#	MsgPrint('WAR',"Can't find template[%s]\n",$hexSt->{'##'});
	return 0;
    }

    # 
    $F=$hexSt;

    # HEX
    if( $fields=$hexStTemp->{'field'} ){
	# 
	foreach $field (@$fields){
	    $templ=$field->{'EN'};

	    # 
	    $V=$hexSt->{$field->{'NM'}};

	    # 
	    $size=$templ->{'SZ'};
	    if(ref($size) eq 'SCALAR'){$size=eval $$size;}
	    elsif(ref($size) eq 'CODE'){$size=$size->($F,$V);}
	    $totalSize += $size;
	}
    }
    # 
    if(!$notRecursive && ($sub=$hexStTemp->{'sub'})){
	$hexSt=$hexSt->{ $sub->{'NM'}?$sub->{'NM'}:$sub->{'start'} };
	foreach $st (@$hexSt){
	    $totalSize += CtPkEncLength($st);
	}
    }
    return $totalSize;
}


#============================================
# 
#============================================
# 
sub CtUtBinChkSum {
   my $phpkt = shift;
   $phpkt      .= "\x00" if length($phpkt) % 2;
   my $len      = length $phpkt;
   my $nshort   = $len / 2;
   my $checksum = 0;
   $checksum   += $_ for unpack("S$nshort", $phpkt);
   $checksum   += unpack('C', substr($phpkt, $len - 1, 1)) if $len % 2;
   $checksum    = ($checksum >> 16) + ($checksum & 0xffff);
   return unpack('n', pack('S', ~(($checksum >> 16) + $checksum) & 0xffff));
}
sub CtUtHexChkSum {
   my $phpkt = shift;
   return CtUtBinChkSum(pack('H*',$phpkt));
}

# IP4
sub CtUtIp4ChkSum {
    my($ipSt)=@_;
    my($hexString);
    $ipSt->{'Checksum'}=0;
    $hexString=CtPkEncode($ipSt);
    return CtUtHexChkSum($hexString);
}

sub CtUtIcmpChkSum {
    my($ipSt,$icmpSt)=@_;
    my($hexString);

    if(!$ipSt || $ipSt->{'Version'} eq 4){
	return CtUtIp4ChkSum($icmpSt);
    }
    # V6
    elsif($ipSt->{'Version'} eq 6){
	$hexString=
	    CtFlEncode('SrcAddress',$ipSt) .
	    CtFlEncode('DstAddress',$ipSt) .
	    '0000' .
	    CtFlEncode('PayloadLength',$ipSt) .
	    '000000' .
	    CtFlEncode('NextPayload',$ipSt) ;
    }
    # ICMP
    $icmpSt->{'Checksum'}=0;
    $hexString .=CtPkEncode($icmpSt);

    return CtUtHexChkSum($hexString);
}

sub CtUtUDPChkSum {
    my($ipSt,$udpSt,$data)=@_;
    my($hexString);

    # 
    if($ipSt->{'Version'} eq 4){
	$hexString=
	    CtFlEncode('SrcAddress',$ipSt) .
	    CtFlEncode('DstAddress',$ipSt) .
	    '00' .
	    CtFlEncode('Protocol',$ipSt) .
	    CtFlEncode('Length',$udpSt) ;
    }
    elsif($ipSt->{'Version'} eq 6){
	$hexString=
	    CtFlEncode('SrcAddress',$ipSt) .
	    CtFlEncode('DstAddress',$ipSt) .
	    '0000' .
	    CtFlEncode('PayloadLength',$ipSt) .
	    '000000' .
	    CtFlEncode('NextPayload',$ipSt) ;
    }
    # UDP
    $hexString .=
	CtFlEncode('SrcPort',$udpSt) .
	CtFlEncode('DstPort',$udpSt) .
	CtFlEncode('Length',$udpSt) .
	'0000';

    # UDP
    $hexString .= $data;
    return CtUtHexChkSum($hexString);
}

sub CtUtTCPChkSum {
    my($ipSt,$tcpSt,$data)=@_;
    my($hexString,$hextmp);

    # 
    if($ipSt->{'Version'} eq 4){
	$hexString=
	    CtFlEncode('SrcAddress',$ipSt) .
	    CtFlEncode('DstAddress',$ipSt) .
	    '00' .
	    CtFlEncode('Protocol',$ipSt) .
	    sprintf("%04x",CtFlEncode('HeaderLength',$tcpSt)*4+length($data)/2) ;
    }
    elsif($ipSt->{'Version'} eq 6){
	$hexString=
	    CtFlEncode('SrcAddress',$ipSt) .
	    CtFlEncode('DstAddress',$ipSt) .
	    '0000' .
	    CtFlEncode('PayloadLength',$ipSt) .
	    '000000' .
	    CtFlEncode('NextPayload',$ipSt) ;
    }
    # TCP
    $hextmp = CtPkEncode($tcpSt);
    $hexString .= substr($hextmp,0,32) . '0000'  . substr($hextmp,36);

    # 
    $hexString .= $data;
    return CtUtHexChkSum($hexString);
}

# 192.168.0.1 9001::1  [9001::2]
sub CtUtIp {
    my($msg)=@_;
    my($hex4);
    $hex4='[0-9a-fA-F]{1,4}(?::[0-9a-fA-F]{1,4})*';
    if($msg =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/){return 'OK';}
    if($msg =~ /^(?:$hex4(?:::)(?:$hex4)?|::(?:$hex4)?|$hex4)$/){return 'OK';}
    if($msg =~ /^\[(?:$hex4(?:::)(?:$hex4)?|::(?:$hex4)?|$hex4)\]$/){return 'OK';}
    return ;
}

sub CtUtIPAdType {
    my($msg)=@_;
    my($hex4);
    $hex4='[0-9a-fA-F]{1,4}(?::[0-9a-fA-F]{1,4})*';
    if($msg =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/){return 'ip4';}
    if($msg =~ /^(?:$hex4(?:::)(?:$hex4)?|::(?:$hex4)?|$hex4)$/){return 'ip6';}
    if($msg =~ /^\[(?:$hex4(?:::)(?:$hex4)?|::(?:$hex4)?|$hex4)\]$/){return 'ip6';}
    return '';
}
sub CtUtIPAdEq {
    my($addr1,$addr2)=@_;
    return CtUtIPAdType($addr1) eq 'ip4' ? CtUtV4Eq(@_) : CtUtV6Eq(@_);
}

sub IsMacAddress {
    my($msg)=@_;
    if(lc($msg) =~ /^[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]$/){return 'OK';}
    return ;
}

# 192.168.0.1
sub IsIPV4Address {
    my($msg)=@_;
    if($msg =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/){return 'OK';}
    return ;
}
sub IsIPV6Address {
    my($msg)=@_;
    my($hex4);
    $hex4='[0-9a-fA-F]{1,4}(?::[0-9a-fA-F]{1,4})*';
    if($msg =~ /^(?:$hex4(?:::)(?:$hex4)?|::(?:$hex4)?|$hex4)$/){return 'ip6';}
    return ;
}

# 
#   ex) CtUtV6FromMac('00:04:76:F8:55:DD','fe80::')
sub CtUtV6FromMac {
    my ($mac,$prefix) = @_;
    my (@hex,@oct,$first,@ip6);
    @hex=split(/:/,$mac);
    @oct=map(hex,@hex);
    $first=shift @oct; $first=($first & 0x02) ? ($first & 0xfd):($first | 2);
    # 
    @ip6=CtUtV6StrToVal(sprintf("%s%02x%02x:%02xff:fe%02x:%02x%02x", $prefix,$first,shift @oct,shift @oct,@oct));
    return CtUtV6ValToStr(\@ip6);
#    return sprintf("%s%02x%02x:%02xff:fe%02x:%02x%02x", $prefix,(shift @oct)|0x02,shift @oct,shift @oct,@oct);
}

# 
sub CtUtV6MultiCast {
    my($type,$targetip)=@_;

    # 
    if($type eq 'all-node-link-local'){
        return 'ff02::1','33:33:00:00:00:01';
    }
    # 
    if($type eq 'all-router-link-local'){
        return 'ff02::2','33:33:00:00:00:02';
    }
    # 
    if($type eq 'solicit-node-link-local'){
        my @valAddr = CtUtV6StrToVal($targetip);
        return sprintf("ff02::1:%04x:%04x",$valAddr[6] | 0xff00 ,$valAddr[7]),
        sprintf("33:33:ff:%02x:%02x:%02x",($valAddr[6]&0xff) ,($valAddr[7]&0xff00)>>8,$valAddr[7]&0xff);
    }
}
# 
sub CtUtV6Prefix {
    my($ipaddr,$prefixlen)=@_;
    my($prefix)=CtUtV6WtMkToVal($ipaddr.'/'.$prefixlen);
    return $prefix;
}
# IPv6
sub CtUtV6StrToVal {
    my($strAddr)=@_;
    my(@addrs,@addrVal,$i,$left,$right,$index);

    # 
    $strAddr =~ s/^\[(.+)\]$/$1/;
    $index=0;
    for($i=0;$i<8;$i++){ @addrVal[$i]=0; }

    # ::
    @addrs=split(/::/,$strAddr);

    $left=@addrs[0];
    $right=@addrs[1];

    # 
    if($left){
	@addrs=split(/:/,$left);
	for($i=0;$i<=$#addrs;$i++){
	    @addrVal[$index]=hex(lc(@addrs[$i]));
	    $index++;
#	    PrintItem("@addrs[$i] = " . hex(@addrs[$i]));
	}
    }

    # 
    if($right){
	@addrs=split(/:/,$right);
	$index=7;
	for($i=$#addrs;0<=$i;$i--){
	    @addrVal[$index]=hex(lc(@addrs[$i]));
	    $index--;
	}
    }
#    for($i=0;$i<8;$i++){PrintItem("$i = @addrVal[$i]");}

    return @addrVal;
}
# 
sub CtUtV6WtMkToVal {
    my($strAddr,$omit)=@_;
    my($addr,$masklen,$idx,$mask,@valAddr,@valMask,$i);
    if( $strAddr =~ /(.+)\/([0-9]*)$/ ){
	$addr=$1;
	$masklen=$2;
	if(128<$masklen){$masklen=128;}
	$idx=8;
	while(0<$masklen-16){
	    $mask .= ':ffff';
	    $idx--;
	    $masklen-=16;
	}
	if(0<$masklen){
	    $mask .= ':' . sprintf("%04x",(((2 ** $masklen)-1) << (16-$masklen)));
	    $idx--;
	}
	while(0<$idx){
	    $mask .= ':0';
	    $idx--;
	}
	$mask = substr($mask,1);
	@valAddr=CtUtV6StrToVal($addr);
	@valMask=CtUtV6StrToVal($mask);
	for $i (0..7){@valAddr[$i]=@valAddr[$i] & @valMask[$i];}
	$addr=CtUtV6ValToStr(\@valAddr);
	if($omit){$mask=CtUtV6ValToStr(\@valMask);}
    }
    else{
	$addr=$strAddr;
	$mask='';
    }
    return $addr,$mask;
}
sub CtUtV6StrToHex {
    my($strAddr)=@_;
    my($i,@val,$hex);
    if(ref($strAddr) || !$strAddr){return;}
    @val=CtUtV6StrToVal($strAddr);
    for $i (0..7){
	$hex .= sprintf("%04x",@val[$i]);
    }
    return $hex;
}
sub CtUtV6ValToStr {
    my($valAddr)=@_;
    my($i,$hex,$last);
    for($i=7;0<=$i;$i--){
	if($valAddr->[$i]){last;}
    }
    $last=$i;
    for $i (0..$last){
	$hex .= sprintf("%x%s",$valAddr->[$i],($i eq $last)?'':':');
    }
    if($last ne 7){$hex .= '::';}
    return $hex;
}
sub CtUtV6ToFullStr {
    my($strAddr)=@_;
    my($i,@val,$hex);
    if(ref($strAddr) || !$strAddr){return;}
    @val=CtUtV6StrToVal($strAddr);
    for $i (0..6){
	$hex .= sprintf("%04x:",@val[$i]);
    }
    $hex .= sprintf("%04x",@val[7]);
    return $hex;
}
sub CtUtV6Eq {
    my($addr1,$addr2)=@_;
    my($i,@val1,@val2);
    @val1=CtUtV6StrToVal($addr1);
    @val2=CtUtV6StrToVal($addr2);
    for $i (0..7){
	if(@val1[$i] ne @val2[$i]){return;}
    }
    return 'OK';
}
sub CtUtV4Eq {
    my($addr1,$addr2)=@_;
    $addr1=CtUtV4StrToHex($addr1);$addr2=CtUtV4StrToHex($addr2);
    return $addr1 && $addr1 eq $addr2;
}
sub CtUtV4StrToHex {
    my($strAddr)=@_;
    my(@val,$i,$hex);
    unless($strAddr){return;}
    @val=split(/\./,$strAddr);
#    PrintVal(\@val);
    for $i (0..3){
	$hex .= sprintf("%02x",@val[$i]);
    }
    return $hex;
}
sub CtUtV4StrToVal {
    my($strAddr)=@_;
    my(@val,$i,$hex);
    @val=split(/\./,$strAddr);
    for $i (0..3){
	$hex = $hex * 256 + @val[$i];
    }
    return $hex;
}
sub CtUtV4AdAddr {
    my($strAddr,$add)=@_;
    my(@val);
    @val=split(/\./,$strAddr);
    @val[3] = (@val[3] + $add) % 255;
    return @val[0] . '.' . @val[1] . '.' . @val[2] . '.' . @val[3];
}
# 255.255.255.0 => 24
sub CtUtV4MkToVal {
    my($v4addr)=@_;
    my(@ipaddr,$count,$val,$i);
    @ipaddr = split(/\./, $v4addr);
    foreach $val (@ipaddr){
	for $i (0..7){
	    if($val){$count++;}
	    else{goto EXIT;};
	    $val=($val << 1) & 0xFF;
	}
    }
EXIT:
    return $count;
}
# 192.168.0.1/24 => [192.168.0.1, 255.255.255.0]
sub CtUtV4WtMkToVal {
    my($strAddr,$omit)=@_;
    $strAddr =~ //;
    if( $strAddr =~ /(.+)\/([0-9]*)$/ ){
	return CtUtV4MkToAddr($1,$2);
    }
    else{
	return $strAddr,'';
    }
}
# 
sub CtUtV4MkToAddr {
    my($v4addr,$mask,$fil)=@_;
    my(@maskaddr,@ipaddr,$i);
    
    @ipaddr = split(/\./, $v4addr);
    for $i (0..3){
	if( 8 <= $mask ){
	    @maskaddr[$i]=0xFF;
	    $mask-=8;
	    @ipaddr[$i] = @maskaddr[$i] & @ipaddr[$i];
	}
	else{
	    @maskaddr[$i]=0x100 - (2 ** (8-$mask));
	    if($fil){
		@ipaddr[$i] = (@maskaddr[$i] & @ipaddr[$i]) + (2**(8-$mask)-1);
	    }
	    else{
		@ipaddr[$i] = @maskaddr[$i] & @ipaddr[$i];
	    }
	    $mask=0;
	}
    }
#    printf("mask[%d] [%x.%x.%x.%x]\n",$mask,@maskaddr[0],@maskaddr[1],@maskaddr[2],@maskaddr[3]);
    return "@ipaddr[0].@ipaddr[1].@ipaddr[2].@ipaddr[3]",
           "@maskaddr[0].@maskaddr[1].@maskaddr[2].@maskaddr[3]";
}

# IP
#  0                     0         0
#  10.0.0.0      255.0.0.0         8.10
#  10.0.0.0      255.255.255.0     24.10.0.0
#  10.17.0.0     255.255.0.0       16.10.17
#  10.27.129.0   255.255.255.0     24.10.27.129
#  10.229.0.128  255.255.255.128   25.10.229.0.128
#  10.198.122.47 255.255.255.255   32.10.129.122.47
sub CtUtV4MkDescriptor {
    my($addr,$mask)=@_;
    my($masklen,$part,@addr,$desc,$no);
    @addr=split(/\./,$addr);
    $masklen=CtUtV4MkToVal($mask) || '0';
    $part=($masklen+7)/8;
    $desc=$masklen;
    foreach $no (1..$part){
	$desc .= '.' . @addr[$no-1];
    }
    return $desc;
}
sub CtUtV4MkDescriptorToHex {
    my($desc)=@_;
    my($val,@vals);
    @vals=split(/\./,$desc);
    map{$val.=sprintf('%02x',$_)}(@vals);
    return $val;
}

# 48 -> ffff:ffff:ffff:0000:0000:0000:0000:0000
sub CtUtV6MkToAddr {
    my($maskbit,$omit)=@_;
    my($maskAddr,$i,$sub);
#    if(!$maskbit && $omit){return '0::';}
    if(!$maskbit && $omit){return '::';}
    for $i (0..7){
	if(16 <= $maskbit){$sub=0xffff;}
	elsif(0<$maskbit){$sub=(2**$maskbit-1)<<(16-$maskbit);}
	else{$sub=0;}
	if(!$sub && $omit){
	    return $maskAddr . '::';
	}
	$maskAddr .= sprintf("%s%04x",$maskAddr?':':'',$sub);
	$maskbit-=16;
    }
    return $maskAddr;
}

# '01:02:03:04:05:06',3 => '010203040506000000'
sub CtUtMacToHex {
    my($strAddr,$len)=@_;
    my(@tmp,$i,$val);
    @tmp=split(/:/,$strAddr);
    for $i(0..5){$val .=@tmp[$i];}
    if($len){$len*=2;$val.=sprintf(sprintf("%%0%d.%ds",$len,$len),0)}
    return $val;
}

# fffff000 => 20
sub CtUtHexToBitlen {
    my($hexs)=@_;
    my($val,$hex,$no);
    while($hexs){
	$hex =hex(substr($hexs,0,2));
	$hexs=substr($hexs,2);
	foreach $no (1..8){
	    if( 0x100 & ($hex<<$no) ){$val++;}
	    else{ return $val;}
	}
    }
    return $val;
}

# 20 => fffff000
sub CtUtBitlenToHex {
    my($bitlen,$totalbyte)=@_;
    my($no,$val);
    foreach $no (1..$totalbyte){
	$val .= sprintf('%02x',256-2**(8-(7<$bitlen?8:$bitlen)));
	$bitlen -= 8;
	if($bitlen<0){$bitlen=0;}
    }
    return $val;
}
# fffff000 => 255.255.240.0
# 3ffe0501ffff02000000000000000010 => 3ffe:0501:ffff:0200:0000:0000:0000:0010
sub CtUtHexToIP {
    my($hexs,$mode)=@_;
    my($val);
    if($mode eq 'v4'){
	while($hexs){
	    $val .= hex(substr($hexs,0,2));
	    $hexs=substr($hexs,2);
	    if($hexs){$val .= '.'}
	}
    }
    else{
	while($hexs){
	    $val .= substr($hexs,0,4);
	    $hexs=substr($hexs,4);
	    if($hexs){$val .= ':'}
	}
    }
    return $val;
}

# BigInt
#   BGIntAdd('1f',1,4) => 00000020
sub BGIntAdd {
    my($hexStr,$inc,$len)=@_;
    my($val,$i);
    if($hexStr !~ /^0x/i){
	$hexStr = '0x'.$hexStr;
    }
    $val=Math::BigInt->new($hexStr) + $inc;
    $val=substr($val->as_hex(),2);
    if($len){
	$val=substr($val,0,$len*2);
	if( length($val) % 2 ){ $val = '0' . $val;}
	if(length($val) < $len*2){$len=$len-length($val)/2;for $i (1..$len){$val = '00' . $val;}}
    }
    return $val;
}

# Network order
sub CtUthtons
{
    my ($in) = @_;
    return(unpack('n*', pack('S*', $in)));
}
sub CtUthtonl
{
    my ($in) = @_;
    return(unpack('N*', pack('L*', $in)));
}
sub CtUtntohl
{
    my ($in) = @_;
    return(unpack('L*', pack('N*', $in)));
}
sub CtUtntohs
{
    my ($in) = @_;
    return(unpack('S*', pack('n*', $in)));
}

#============================================
# 
#============================================
sub PrintFA {
    my($hexSt)=@_;
    %PRINTPkt=();
    # 
    CtFlPrCollect($hexSt);
    # 
    CtFlPrTagVal();
}
# 
sub CtFlPrTagVal {
    my(@keys,$i,$j,$vals);

    @keys=sort keys(%PRINTPkt);
    for $i (0..$#keys){
	if( @keys[$i] =~ /\.id$/ ){next;}
	printf("[%s]\n",@keys[$i]);
	$vals=$PRINTPkt{@keys[$i]};
	for $j (0..$#$vals){
	    printf("   (%02d) %s\n",$j+1,$vals->[$j]);
	}
    }
}
# 
sub CtFlPrCollect {
    my($hexSt,$tag,$uptag)=@_;
    my(@keys,$i,$name);
    
    if(ref($hexSt) eq 'ARRAY'){
	for $i (0..$#$hexSt){
	    $name=$hexSt->[$i]->{'#Name#'};
	    if($uptag ne $name){
		CtFlPrCollect($hexSt->[$i],$tag.',#'.$name,$name);
	    }
	    else{
		CtFlPrCollect($hexSt->[$i],$tag,$uptag);
	    }
	}
    }
    else{
	@keys=keys(%$hexSt);
	for $i (0..$#keys){
	    if(@keys[$i] =~ /^\#/){next;}
	    if($tag){
		$name=$tag . ',' . @keys[$i];
	    }
	    else{
		$name=@keys[$i];
	    }
	    if( !ref($hexSt->{@keys[$i]}) ){
		push(@{$PRINTPkt{$name}},$hexSt->{@keys[$i]});
	    }
	    else{
		CtFlPrCollect($hexSt->{@keys[$i]},$name,@keys[$i]);
	    }
	}
    }
}

sub CtUtHashCopy {
    my($val,$level)=@_;
    my(%hash,@array);
    my(@keys,$key);
    if($level eq 0){return $val;}
    if($level ne ''){$level--;}
    if(ref($val) eq 'HASH'){
	@keys=keys(%$val);
	foreach $key (@keys){
	    $hash{$key}=CtUtHashCopy($val->{$key},$level);
	}
	return \%hash;
    }
    if(ref($val) eq 'ARRAY'){
	@array=map{CtUtHashCopy($_,$level)} @$val;
	return \@array;
    }
    return $val;
}

1;
