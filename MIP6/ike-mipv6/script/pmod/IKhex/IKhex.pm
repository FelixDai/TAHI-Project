#!/usr/bin/perl

# use strict;

#============================================
# 
#============================================

# 
%HXPKTPatternDB;

# 
sub HXRegistPktPattern {
    my($ptn)=@_;
    my($i);
    if(ref($ptn) eq 'HASH'){
	$HXPKTPatternDB{$ptn->{'##'}}=$ptn;
    }
    if(ref($ptn) eq 'ARRAY'){
	for $i (0..$#$ptn){$HXPKTPatternDB{$ptn->[$i]->{'##'}}=$ptn->[$i];}
    }
}

# HEX
sub HXPktHexDecode {
    my($hexStTemp,$hexString)=@_;
    my($field,$bitmask,$val,$bitdata,$bitpos,$size,$type,$name,$act,$F,$i,$NX,$SZ,$sub,$tmp,$subdata);

    if(!ref($hexStTemp)){$hexStTemp=$HXPKTPatternDB{$hexStTemp};}
    if(ref($hexStTemp) ne 'HASH'){return;}

    $F->{'##'}=$hexStTemp->{'##'};
    $F->{'#Name#'}=$hexStTemp->{'#Name#'};
    $field=$hexStTemp->{'field'};
    MsgPrint('DBG',"<==HXPktHexDecode start[%s]\n",$F->{'##'});
    # 
    for $i (0..$#$field){
	$size=(ref($field->[$i]->{'SZ'}) eq 'HASH')?$field->[$i]->{'SZ'}->{'Decode'}:$field->[$i]->{'SZ'};
	$type=$field->[$i]->{'TY'};
	$name=$field->[$i]->{'NM'};
	$act =$field->[$i]->{'AC'};
	$bitmask=$field->[$i]->{'MK'};

	# 
	if(ref($size) eq 'SCALAR'){
#	    $size = eval "sprintf(\"$$size\")";
	    $size = eval $$size;
	    MsgPrint('DBG',"Eval size=$size\n");
	}
	if(!$size && !$bitmask){next;}
	# 
	if(ref($type) eq 'SCALAR'){
#	    $type = eval "sprintf(\"$$type\")";
	    $type = eval $$type;
	    MsgPrint('DBG',"Eval type=$type\n");
	}

	# 
	if($bitmask){
	    if($bitdata eq ''){
		($bitdata,$hexString)=HXPktHexDecodeType($hexString,$type,$size);
		$bitpos=$size*8;
	    }
	    $val=PktGetBitData($bitdata,$bitpos,$bitmask);
	    $bitpos-=$bitmask;
	}
	else{
	    # 
# printf("A Size[%s] type[%s] data[%s]\n",$size,$type,$hexString);
	    ($val,$hexString)=HXPktHexDecodeType($hexString,$type,$size);
# printf("Size[%s] type[%s] data[%s]\n",$size,$type,$hexString);
	    $bitdata='';
	}
	$F->{$name}=$val;
	# 
	if($act){
	    eval $act;
	    MsgPrint('DBG',"NX=[$NX] SZ=[$SZ] $act\n");
	}
    }

    # 
    if($sub=$hexStTemp->{'sub'}){
	# 
	$subdata=($SZ ne '')?substr($hexString,0,$SZ*2):$hexString;
	($val,$tmp,$subdata)=HXPktDecodeBrother($sub->{'start'},$sub->{'pattern'},$subdata);
	if(-1<$#$val){
	    $F->{$sub->{'NM'}?$sub->{'NM'}:$sub->{'start'}}=$val;
	}
	$hexString=($SZ ne '')?substr($hexString,$SZ*2):$hexString;
    }

EXIT:
    return $F,$NX,$hexString;
}

sub HXPktDecodeBrother {
    my($hexStTemp,$nxtpattern,$hexString)=@_;
    my($val,@tree,$nxt,$name);

    MsgPrint('DBG',"<==HXPktDecodeBrother start[$hexStTemp] next[$nxtpattern]\n");
    # 
    if($hexStTemp){
	$name=$hexStTemp;
	if(!ref($hexStTemp)){$hexStTemp=$HXPKTPatternDB{$hexStTemp};}
	if(ref($hexStTemp) ne 'HASH'){return;}
	($val,$nxt,$hexString)=HXPktHexDecode($hexStTemp,$hexString);
	push(@tree,$val);
    }

    # 
    if($nxtpattern){
	while(1){
	    if(length($hexString)<=0){last;}
	    # 
	    if(!$nxt){$nxt=HXPktMatchPattern($nxtpattern,$hexString);}
	    # 
	    if(!grep{$_ eq $nxt} @$nxtpattern){last;}
	    MsgPrint('DBG',"*** HXPktDecodeBrother [$nxt] data[%s]\n",length($hexString));
	    $hexStTemp=$nxt;
	    ($val,$nxt,$hexString)=HXPktHexDecode($nxt,$hexString);
	    # 
	    push(@tree,$val);
	}
    }
    MsgPrint('DBG',"==>HXPktDecodeBrother\n");
    return \@tree,'',$hexString;
}

# 
sub HXPktMatchPattern {
    my($pattern,$hexString)=@_;
    my($i,$j,$field,$val,$tmp,$subHexStTemp,$hex,$size);
    if(ref($pattern) ne 'ARRAY'){$pattern=[$pattern];}
    for $i (0..$#$pattern){
	$hex=$hexString;
	if(!ref($pattern->[$i])){$subHexStTemp=$HXPKTPatternDB{$pattern->[$i]};}
	$field=$subHexStTemp->{'field'};
	for $j (0..$#$field){
	    $size=(ref($field->[$j]->{'SZ'}) eq 'HASH')?$field->[$j]->{'SZ'}->{'Decode'}:$field->[$j]->{'SZ'};
	    if( $field->[$j]->{'PT'} ne '' ){
		($val,$tmp)=HXPktHexDecodeType($hex,$field->[$j]->{'TY'},$size);
		if($field->[$j]->{'MK'}){
		    $val=PktGetBitData($val,$size*8,$field->[$j]->{'MK'});
		}
		if($val eq $field->[$j]->{PT}){
		    MsgPrint('DBG',"Match pattern[%s] PT==$val\n",$pattern->[$i]);
		    return $pattern->[$i];}
	    }
	    $hex=substr($hex,$size*2);
	}
	
    }
    return '';
}

sub HXPktHexDecodeType {
    my($hexString,$type,$len)=@_;
    my($val);
    if($type eq 'byte'){
	($val,$hexString)=PktDecodeByte($hexString,$len);
    }
    elsif($type eq 'uchar'){
	($val,$hexString)=PktDecodeUchar($hexString);
    }
    elsif($type eq 'short'){
	($val,$hexString)=PktDecodeShort($hexString);
    }
    elsif($type eq 'long'){
	($val,$hexString)=PktDecodeLong($hexString);
    }
    elsif($type eq 'float'){
	($val,$hexString)=PktDecodeFloat($hexString);
    }
    elsif($type eq 'double'){
	($val,$hexString)=PktDecodeDouble($hexString);
    }
    elsif($type eq 'hex'){
	($val,$hexString)=PktDecodeHex($hexString,$len);
    }
    elsif($type eq 'ipv4'){
	($val,$hexString)=PktDecodeIPv4($hexString,$len);
    }
    elsif($type eq 'ipv6'){
	($val,$hexString)=PktDecodeIPv6($hexString,$len);
    }
    else{
	MsgPrint('ERR',"Type illegale [$type]\n");
    }
#    MsgPrint('DBG3',"Val[%s:%x] Type[$type]\n",$val,$val);
    return $val,$hexString;
}
# 
sub PktDecodeUchar {
    my($data)=@_;
    my($val);
    ($val,$data)=unpack('a2a*',$data);
    return hex($val),$data;
}
sub PktDecodeShort {
    my($data)=@_;
    my($val);
    ($val,$data)=unpack('a4a*',$data);
    return hex($val),$data;
}
sub PktDecodeLong {
    my($data)=@_;
    my($val);
    ($val,$data)=unpack('a8a*',$data);
    return hex($val),$data;
}
sub PktDecodeFloat {
    my($data)=@_;
    my($i,@val,$val);
    for $i (0..3){$val[$i]=substr($data,$i*2,2);} # HEX
    $val=pack('H2H2H2H2',@val); # 
    return unpack('f',$val),substr($data,8); # 
}
sub PktDecodeDouble {
    my($data)=@_;
    my($i,@val,$val);
    for $i (0..7){$val[$i]=substr($data,$i*2,2);}
    $val=pack('H2H2H2H2H2H2H2H2',@val);
    return unpack('d',$val),substr($data,16);
}
sub PktDecodeByte {
    my($data,$size)=@_;
    my($val,$tmp);
    $size *=2;
    ($val,$tmp)=pack('H' . $size . 'a*',$data);
    $data=substr($data,$size);
    return $val,$data;
}
sub PktDecodeHex {
    my($data,$size)=@_;
    my($val);
    $size *=2;
    ($val,$data)=unpack('a' . $size . 'a*',$data);
    return $val,$data;
}
sub PktDecodeIPv4 {
    my($data,$len)=@_;
    my($val,$v1,$v2,$v3,$v4);
    ($v1,$v2,$v3,$v4,$data)=unpack('a2a2a2a2a*',$data);
    $val=sprintf('%s.%s.%s.%s', hex($v1),hex($v2),hex($v3),hex($v4));
    if($len && 4<$len){$data=substr($data,($len-4)*2);}
    return $val,$data;
}
sub PktDecodeIPv6 {
    my($data,$len)=@_;
    my($val,$v1,$i);
    for $i (0..7){
	($v1,$data)=unpack('a4a*',$data);
	$val .= $v1 . (($i eq 7)?'':':');
    }
    if($len && 16<$len){$data=substr($data,($len-16)*2);}
    return $val,$data;
}
# 
sub PktBinDecodeUchar {
    my($data)=@_;
    my($val);
    $val=vec($data,0,8);
    return $val,substr($data,1);
}
sub PktBinDecodeShort {
    my($data)=@_;
    my($val);
    $val=vec($data,0,16);
    return $val,substr($data,2);
}
sub PktBinDecodeLong {
    my($data)=@_;
    my($val);
    $val=vec($data,0,32);
    return $val,substr($data,4);
}

# bitpos:
# bitmask:
sub PktGetBitData {
    my($bitdata,$bitpos,$bitmask)=@_;
    my($val,$pat);
    $pat= ((2**$bitmask)-1) << ($bitpos-$bitmask);
    $val = $bitdata & $pat;
#    printf("bitdata[$bitdata],bitpos[$bitpos],bitmask[$bitmask] val[%s]\n",$val >> ($bitpos-$bitmask));
    return $val >> ($bitpos-$bitmask);
}
sub PktSetBitData {
}

sub PktHexEncodeType {
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
	$val=sprintf("%02x%02x%02x%02x",$tmp[0],$tmp[1],$tmp[2],$tmp[3]); # 
    }
    elsif($type eq 'double'){
	$val=pack('d',$data);
	@tmp=unpack('C8',$val);
	$val=sprintf("%02x%02x%02x%02x%02x%02x%02x%02x",$tmp[0],$tmp[1],$tmp[2],$tmp[3],$tmp[4],$tmp[5],$tmp[6],$tmp[7]);
    }
    elsif($type eq 'hex'){
	$val=substr($data,0,$len*2);
	if(length($data) < $len*2){$len=$len-length($data)/2-1;for $i (0..$len){$val .='00';}}
    }
    elsif($type eq 'ipv4'){
	$val=IPv4StrToHex($data);
	if(4<$len){for $i(0..$len-5){$val .='00';}} # 
    }
    elsif($type eq 'ipv6'){
	$val=IPv6StrToHex($data);
	if(16<$len){for $i(0..$len-17){$val .='00';}}  # 
    }
    else{
	MsgPrint('ERR',"Type illegale [$type]\n");
    }
#    MsgPrint('DBG3',"Val[%s] Type[$type]\n",$val);
    return $val;
}

# 
#   
#         
#         
sub PktHexEncode {
    my($hexSt)=@_;
    my($hexStTemp,$field,$i,$j,$val,$bitmask,$bitdata,$bitpos,$hexString,$sub,$name,$size,$F,$type,$tmp);

    if(!$hexSt->{'##'} || !($hexStTemp=$HXPKTPatternDB{$hexSt->{'##'}})){return;}
    $F=$hexSt;
#    PrintVal($hexStTemp);
    # 
    if( $field=$hexStTemp->{'field'} ){
	for $i (0..$#$field){
	    $bitmask=$field->[$i]->{'MK'};
	    $val=$hexSt->{$field->[$i]->{'NM'}};
	    if($bitmask){
		$tmp=(ref($field->[$i]->{'SZ'}) eq 'HASH')?$field->[$i]->{'SZ'}->{'Encode'}:$field->[$i]->{'SZ'};
		if($tmp ne 0){$size=$tmp;}
	    }
	    else{
		$size=(ref($field->[$i]->{'SZ'}) eq 'HASH')?$field->[$i]->{'SZ'}->{'Encode'}:$field->[$i]->{'SZ'};
	    }
	    if($val eq ''){
		if(!ref($size)){
#		    MsgPrint('DBG3',"Encode data(%s) dose not exist, so complement[%s] 00.\n",
#			     $field->[$i]->{'NM'},$size);
		    for $j (1..$size){$hexString .= '00';}
		}
		elsif(ref($size) eq 'SCALAR'){
		    $size=eval $$size;
		    for $j (1..$size){$hexString .= '00';}
		    MsgPrint('DBG',"Encode data(%s) dose not exist, 0 padding 00*%s.\n",
			     $field->[$i]->{'NM'},$size);
		}
		else{
		    MsgPrint('DBG',"Encode data(%s) dose not exist and Size nonfixed, so ignored.\n",
			     $field->[$i]->{'NM'});
		    exit;
		}
		next;
	    }
	    # 
	    if($bitmask){
		if($bitpos eq ''){
		    if(ref($size) eq 'SCALAR'){$size=eval $$size;}
		    $bitpos=$size*8;
		}
		$bitpos-=$bitmask;
		$bitdata=($val<<$bitpos) | $bitdata;
#		MsgPrint('DBG3',"val=$val bitpos=$bitpos bitmask=$bitmask bitdata=%0x\n",$bitdata);
#		printf("val=$val bitpos=$bitpos bitmask=$bitmask size=$size bitdata=%0x\n",$bitdata);
		if($bitpos eq 0){
		    $hexString .= sprintf('%0' . $size*2 . 'x',$bitdata);
#		    printf("%s", ' #### %0' . $size*2 . "x\n");
		    $bitpos='';
		    $bitdata=0;
		}
	    }
	    # 
	    else{
		$type=$field->[$i]->{'TY'};
		if(ref($type) eq 'SCALAR'){$type = eval $$type;}
		if(ref($size) eq 'SCALAR'){$size = eval $$size;}
		$val=PktHexEncodeType($val,$type,$size);
		$hexString .= $val;
		$bitpos='';
		$bitdata=0;
	    }
	}
    }
    # 
    if($sub=$hexStTemp->{'sub'}){
	$name=$sub->{'NM'}?$sub->{'NM'}:$sub->{'start'};
	$hexSt=$hexSt->{$name};
	for $i (0..$#$hexSt){
	    $hexString .= PktHexEncode($hexSt->[$i]);
	}
    }
#    PrintItem($hexString);
    return $hexString;
}

# 
sub HXConvHexToST {
    my($hexString)=@_;
    my($hexSt,$nxt,$data,$name,$ikeSt);
    ($hexSt,$nxt,$data)=HXPktHexDecode('Udp_ISAKMP',$hexString);
    ($ikeSt,$name)=HXConvHexStToIKESt($hexSt);
    if($ikeSt){
	$ikeSt={'##'=>'Udp_ISAKMP','###'=>'ISAKMP','IK'=>$ikeSt};
    }
    return $ikeSt;
}

# 
sub HXConvHexStToIKESt {
    my($hexSt)=@_;
    my($ikeTemp,$ikeSt,$hexStTemp,$field,$tempName,$sub,$name,$val,$subname,@subnames,%index,$i);

    $tempName=$hexSt->{'##'};
    if(!$tempName || !($hexStTemp=$HXPKTPatternDB{$tempName})){return;}
    # 
    if(!($ikeTemp=$IKEFrameFieldMapAssoc{$tempName}) ){return;}

    # 
    $ikeSt={'##'=>$tempName,'###'=>$ikeTemp->{'#Name#'}};
    
    # 
    if( $field=$hexStTemp->{'field'} ){
	for $i (0..$#$field){
	    # 
	    $val=$hexSt->{$field->[$i]->{'NM'}};
	    # 
	    $name=$ikeTemp->{$field->[$i]->{'NM'}};
	    if(!ref($name)){
		if($name ne $field->[$i]->{'NM'}){
		    MsgPrint('ERR',"HexStToIKE Temp[%s] Field(%s) invalid\n",$tempName,$field->[$i]->{'NM'});}
	    }
	    else{
		if($name->{'#Name#'} ne $field->[$i]->{'NM'}){
		    MsgPrint('ERR',"HexStToIKE Temp[%s] Field(%s) invalid\n",$tempName,$field->[$i]->{'NM'});}
	    }
	    $ikeSt->{$field->[$i]->{'NM'}}=$val;
	}
    }

    # 
    if($sub=$hexStTemp->{'sub'}){
	$name=$sub->{'NM'}?$sub->{'NM'}:$sub->{'start'};
	$hexSt=$hexSt->{$name};
	for $i (0..$#$hexSt){
	    ($val,$subname)= HXConvHexStToIKESt($hexSt->[$i]);
	    if($subname){
		$index{$subname}= ($index{$subname} eq '')?0:$index{$subname}+1;
		push(@subnames,$subname . "#$index{$subname}");
		push(@{$ikeSt->{$subname}},$val);
	    }
	}
	$ikeSt->{'++'}=\@subnames;
    }

    return $ikeSt,$ikeTemp->{'#Name#'};
}

# 
sub HXConvSTToHex {
    my($ikeSt)=@_;
    my($hexSt,$hexString);
    $hexSt=HXConvIKEStToHexSt($ikeSt);
    if(!$hexSt){
	MsgPrint('ERR',"Can't convert to Hex struct.\n" );
#	PrintVal($ikeSt);
	return '';
    }
    $hexString=PktHexEncode($hexSt);
    return $hexString;
}

# 
sub HXConvIKEStToHexSt {
    my($ikeSt)=@_;
    my($tempName,$hexSt,$hexStTemp,$field,$suborder,$subname,$tag,$index,$i,$val);
    
    # 
    $tempName=$ikeSt->{'##'};
    $hexStTemp=$HXPKTPatternDB{$tempName};
    if(!$tempName || !($hexStTemp=$HXPKTPatternDB{$tempName})){
	MsgPrint('WAR',"StToHex Tempname[$tempName] not exist\n");
	return;
    }

    $hexSt={'##'=>$tempName,'#Name#'=>$hexStTemp->{'#Name#'}};

    # 
    while(($key,$val)=each(%$ikeSt)){
	$field=$hexStTemp->{'field'};
	if(grep{$_->{'NM'} eq $key} @$field){
	    $hexSt->{$key}=$val;
	}
	elsif($key eq '++'){
	    $suborder=$val;
	}
    }
    if($suborder){
	$subname=$hexStTemp->{'sub'}->{'NM'}?$hexStTemp->{'sub'}->{'NM'}:$hexStTemp->{'sub'}->{'start'};
	for $i (0..$#$suborder){
	    if($suborder->[$i] =~ /^(.+)\#([0-9]+)$/){
		$tag=$1;
		$index=$2;
	    }
	    else{$tag=$suborder->[$i];$index=0;}
	    if($ikeSt->{$tag}){
		$val=HXConvIKEStToHexSt($ikeSt->{$tag}->[$index]);
		push(@{$hexSt->{$subname}},$val);
	    }
	}
    }
    
    return $hexSt;
}

# 
sub HXConvHexStToTAHI {
    my($hexSt)=@_;
    my($tahiSt);
    $tahiSt={'recvFrame'=>$IKERcvFRAMENAME,'recvTime1'=>Time::HiRes::gettimeofday(),'status'=>0};
    HXAddTAHIHrader($hexSt,'Frame_Ether.Packet_IPv6.Upp_UDP',1,$tahiSt);
    return $tahiSt;
}

sub HXAddTAHIHrader {
    my($hexSt,$tag,$index,$tahiSt)=@_;
    my(@keys,$i,$j,$val,%tags,$id,$num);
    
    $tag .= '.' . $hexSt->{'##'}  . (($index eq 1)?'':$index);
    @keys=keys(%$hexSt);
    for $i (0..$#keys){
	$val=$hexSt->{$keys[$i]};
	if($keys[$i] eq '##' || $keys[$i] eq '###' || $keys[$i] eq '#Name#'){
	    next;
	}
	if(ref($val) eq 'ARRAY'){
	    for $j (0..$#$val){
		$tags{$val->[$j]->{'##'}}++;
		HXAddTAHIHrader($val->[$j],$tag,$tags{$val->[$j]->{'##'}},$tahiSt);
	    }
	    while(($id,$num)=each(%tags)){
		$tahiSt->{$tag . '.' . $id . '#'}=$num;
	    }
	}
	else{
	    $tahiSt->{$tag . '.' . $keys[$i]}=$val
	}
    }
    return $tahiSt;
}
# HEX
sub HXCheckHexDataLeng {
    my($hexData,$ptn)=@_;
    my($hexLeng,$len,$hexStTemp);
    $hexLeng=length($hexData)/2;

    $hexStTemp=$HXPKTPatternDB{$ptn};
    if(defined($hexStTemp->{'#Length#'})){
	$len=$hexStTemp->{'#Length#'};
	if(!ref($len)){
#	    printf("lengnth %s <= %s\n",$len,$hexLeng);
	    return $len<=$hexLeng;
	}
	elsif(ref($len) eq 'CODE'){
	    $len = $len->(@_);
#	    printf("Code lengnth %s <= %s\n",$len,$hexLeng);
	    return $len<=$hexLeng;
	}
	elsif(ref($len) eq 'SCALAR'){
	    $len = eval $$len;
	    return $len<=$hexLeng;
	}
    }
    else{
	return 'OK';
    }
}


#============================================
# 
#============================================
# IPv6
sub IPv6StrToVal {
    my($strAddr)=@_;
    my(@addrs,@addrVal,$i,$left,$right,$index);
    $index=0;
    for($i=0;$i<8;$i++){ $addrVal[$i]=0; }

    # ::
    @addrs=split(/::/,$strAddr);

    $left=$addrs[0];
    $right=$addrs[1];

    # 
    if($left){
	@addrs=split(/:/,$left);
	for($i=0;$i<=$#addrs;$i++){
	    $addrVal[$index]=hex(lc($addrs[$i]));
	    $index++;
#	    PrintItem("$addrs[$i] = " . hex($addrs[$i]));
	}
    }

    # 
    if($right){
	@addrs=split(/:/,$right);
	$index=7;
	for($i=$#addrs;0<=$i;$i--){
	    $addrVal[$index]=hex(lc($addrs[$i]));
	    $index--;
	}
    }
#    for($i=0;$i<8;$i++){PrintItem("$i = $addrVal[$i]");}

    return @addrVal;
}
# 
sub IPv6WithMaskStrToVal {
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
	@valAddr=IPv6StrToVal($addr);
	@valMask=IPv6StrToVal($mask);
	for $i (0..7){$valAddr[$i]=$valAddr[$i] & $valMask[$i];}
	$addr=IPv6ValToStr(\@valAddr);
	if($omit){$mask=IPv6ValToStr(\@valMask);}
    }
    else{
	$addr=$strAddr;
	$mask='';
    }
    return $addr,$mask;
}
sub IPv6StrToHex {
    my($strAddr)=@_;
    my($i,@val,$hex);
    if(ref($strAddr) || !$strAddr){return;}
    @val=IPv6StrToVal($strAddr);
    for $i (0..7){
	$hex .= sprintf("%04x",$val[$i]);
    }
    return $hex;
}
sub IPv6ValToStr {
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
sub IPv6EQ {
    my($addr1,$addr2)=@_;
    my($i,@val1,@val2);
    @val1=IPv6StrToVal($addr1);
    @val2=IPv6StrToVal($addr2);
    for $i (0..7){
	if($val1[$i] ne $val2[$i]){return;}
    }
    return 'OK';
}
sub IPv4StrToHex {
    my($strAddr)=@_;
    my(@val,$i,$hex);
    @val=split(/\./,$strAddr);
#    PrintVal(\@val);
    for $i (0..3){
	$hex .= sprintf("%02x",$val[$i]);
    }
    return $hex;
}
# 
sub IPv4MaskToAddress {
    my($v4addr,$mask)=@_;
    my(@maskaddr,@ipaddr,$i);
    
    @ipaddr = split(/\./, $v4addr);
    for $i (0..3){
	if( 8 <= $mask ){
	    $maskaddr[$i]=0xFF;
	    $mask-=8;
	    $ipaddr[$i] = $maskaddr[$i] & $ipaddr[$i];
	}
	else{
	    $maskaddr[$i]=0x100 - (2 ** (8-$mask));
	    $ipaddr[$i] = ($maskaddr[$i] & $ipaddr[$i]) + (2**(8-$mask)-1);
	    $mask=0;
	}
    }
    printf("[%x.%x.%x.%x]\n",$maskaddr[0],$maskaddr[1],$maskaddr[2],$maskaddr[3]);
    return "$ipaddr[0].$ipaddr[1].$ipaddr[2].$ipaddr[3]",
           "$maskaddr[0].$maskaddr[1].$maskaddr[2].$maskaddr[3]";
}
sub IPv6BitMaskToAddress {
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

1
