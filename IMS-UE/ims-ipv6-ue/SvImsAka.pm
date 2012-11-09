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
# 09/2/ 9  AKA
# 09/1/27  bytecode
# 08/12/19 CtAKAGenVector
# 08/4/ 8 CtAKAKeyparams
#

# AKA 
#  $DIRRoot{'SC'}->{'AKA'}->{privateID}->{negoname}->{ID,{AKA=>{KEY,OP,AMF,XMAC,CK,IK}}}
#  $DIRRoot{'SC'}->{'SA'}->{in|out}->{spi}->{aka,negoname,dir,authAlgo,encAlgo,seqno,dstip,srcip}
#  $DIRRoot{'SC'}->{'SP'}->{policyID}->{spi,srcport,dstport,tarnsport}
#    policyID ::  srcport:dstport:transport

# 
# IK,CK

# 
$AKA_K   ='465b5ce8b199b49faa5f0a2ee238a6bc';
$AKA_OP  ='cdc202d5123e20f62b6d676ac72cb318';
$AKA_RAND='23553cbe9637a89d218ae64dae47bf35';
$AKA_AMF ='b9b9';
$AKA_SEQ ='000000000100';
# 
# OPC  cd63cb71954a9f4e48a5994e37a02baf
# F1   891f960919166343                  (MAC) =>
# F1*  23545d6f14117a49
# F2   a54211d5e3ba50bf                  (RES)
# F3   b40ba9a3c58b2a05bbf0d987b21bf8cb  (CK)
# F4   f769bcd751044604127672711c6d3441  (IK)
# F5   aa689c648370                      (AK)
# F5*  451e8beca43b
#

%AKADoi=(
	 'des-ede3-cbc' =>{'length'=>192, 'cbcBlock'=>8, 'cipher'=>'DES_EDE3'},  # des-ede3-cbc => 3des-cbc
#	 'des-cbc'      =>{'length'=>64,  'cbcBlock'=>8, 'cipher'=>'DES'},
	 'aes-cbc'      =>{'length'=>128, 'cbcBlock'=>16,'cipher'=>'Crypt::OpenSSL::AES'}, # aes-cbc => rijndael-cbc
#	 'rijndael-cbc' =>{'length'=>128, 'cbcBlock'=>16,'cipher'=>'Crypt::OpenSSL::AES'},
	 'hmac-md5-96'  =>{'length'=>96},
	 'hmac-sha-1-96'=>{'length'=>96},
	 'ipsec-3gpp'   =>9,
	 'null'         =>{'length'=>0,  'cbcBlock'=>4, 'cipher'=>'NULL'},
	 );

sub base64encode {
	my $str = shift;
	my $table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
	my $ret;

	# 2 : 0000_0000 1111_1100
	# 4 : 0000_0011 1111_0000
	# 6 : 0000_1111 1100_0000
	my ($i, $j, $x, $y);
	for($i=$x=0, $j=2; $i<length($str); $i++) {
		$x    = ($x<<8) + ord(substr($str,$i,1));
		$ret .= substr($table, ($x>>$j) & 0x3f, 1);

		if ($j != 6) { $j+=2; next; }
		# j==6
		$ret .= substr($table, $x & 0x3f, 1);
		$j    = 2;
	}
	if ($j != 2)    { $ret .= substr($table, ($x<<(8-$j)) & 0x3f, 1); }
	if ($j == 4)    { $ret .= '=='; }
	elsif ($j == 6) { $ret .= '=';  }

	return $ret;
}

sub base64decode {
	my $str  = shift;
	my @base64ary = (
			 0, 0, 0, 0,  0, 0, 0, 0,   0, 0, 0, 0,  0, 0, 0, 0,	# 0x00
			 0, 0, 0, 0,  0, 0, 0, 0,   0, 0, 0, 0,  0, 0, 0, 0,	# 0x10
			 0, 0, 0, 0,  0, 0, 0, 0,   0, 0, 0,62,  0, 0, 0,63,	# 0x20
			 52,53,54,55, 56,57,58,59,  60,61, 0, 0,  0, 0, 0, 0,	# 0x30
			 0, 0, 1, 2,  3, 4, 5, 6,   7, 8, 9,10, 11,12,13,14,	# 0x40
			 15,16,17,18, 19,20,21,22,  23,24,25, 0,  0, 0, 0, 0,	# 0x50
			 0,26,27,28, 29,30,31,32,  33,34,35,36, 37,38,39,40,	# 0x60
			 41,42,43,44, 45,46,47,48,  49,50,51, 0,  0, 0, 0, 0	# 0x70
			 );
	my $ret;
	my $buf;
	my $f;
	if (substr($str, -1) eq  '=') { $f=1; }
	if (substr($str, -2) eq '==') { $f=2; }
	for(my $i=0; $i<length($str); $i+=4) {
		$buf  = ($buf<<6) + @base64ary[ ord(substr($str,$i  ,1)) ];
		$buf  = ($buf<<6) + @base64ary[ ord(substr($str,$i+1,1)) ];
		$buf  = ($buf<<6) + @base64ary[ ord(substr($str,$i+2,1)) ];
		$buf  = ($buf<<6) + @base64ary[ ord(substr($str,$i+3,1)) ];
		$ret .= chr(($buf & 0xff0000)>>16) . chr(($buf & 0xff00)>>8) . chr($buf & 0xff);

	}
	if ($f>0) { chop($ret); }
	if ($f>1) { chop($ret); }
	return $ret;
}

# SA+SP
sub CtSACreate {
    my($dir,$akaID,$negoname,$policy,$name,$relation)=@_;
    my($sa,$policyID,$spi,$encAlgo,$iv);
    
    unless($encAlgo=($dir eq 'in' ? $policy->{'RtoL'}->{'encAlgo'}:$policy->{'LtoR'}->{'encAlgo'})){
	MsgPrint('ERR',"Encrypy algo empty\n");
	return;
    }
    if($dir eq 'out'){
	unless($policy->{$name}->{'spi'}){
	    $policy->{$name}->{'spi'}=CtMkSPI();
	}
	$iv = CtRandom( $AKADoi{$encAlgo}->{'cbcBlock'} );
    }
    $spi=$policy->{$name}->{'spi'};

    # 
    if($DIRRoot{'SC'}->{'SA'}->{$dir}->{$spi}){
	MsgPrint('AKA',"SA %s already registerd\n",$spi);
    }
    else{
	# SA
	$sa = {
	    'aka'       => $akaID,                         # 
	    'negoname'  => $negoname,                      # 
	    'dir'       => $dir,                           # [in|out]
	    'name'      => $name,                          # [ReqRtoL|ResRtoL|ReqLtoR|ResLtoR]
	    'authAlgo'  => $dir eq 'in' ? $policy->{'RtoL'}->{'authAlgo'}:$policy->{'LtoR'}->{'authAlgo'},
	    'encAlgo'   => $dir eq 'in' ? $policy->{'RtoL'}->{'encAlgo'} :$policy->{'LtoR'}->{'encAlgo'}, ##   $policy->{'IPSecEncAlgo'},
	    'dstip'     => $dir eq 'in' ? $policy->{'LocalIp'} : $policy->{'RemoteIp'},
	    'srcip'     => $dir eq 'in' ? $policy->{'RemoteIp'} : $policy->{'LocalIp'},
	    'proto'     => CtUtIPAdType($policy->{'LocalIp'}), # [ip6|ip4]
	    'spi'       => $spi,
	    'IV'        => $iv,                            # 
	    'seqno'     => $dir eq 'in' ? '' : 1,          # ESP
	    'spino'     => scalar( keys(%{$DIRRoot{'SC'}->{'SA'}->{'in'}})+keys(%{$DIRRoot{'SC'}->{'SA'}->{'out'}})+1 ), # setkey
	    'relation'  => $policy->{$relation}->{'spi'},  # 
	};
	$DIRRoot{'SC'}->{'SA'}->{$dir}->{$spi}=$sa;
	MsgPrint('AKA',"New SA create no[%s] spi[%s] relation[%s] alg[%s] ealg[%s]\n",
		 $sa->{'spino'},$sa->{'spi'},$sa->{'relation'},$sa->{'authAlgo'},$sa->{'encAlgo'});
    }
    # SP
    $policyID=CtMkPolicyID($policy->{$name}->{'srcport'},$policy->{$name}->{'dstport'},$policy->{'transport'});
    if($DIRRoot{'SC'}->{'SP'}->{$policyID}){
	MsgPrint('ERR',"SP %s already registerd\n",$policyID);
    }
    else{
	$DIRRoot{'SC'}->{'SP'}->{$policyID}={'spi'=>$spi,'dir'=>$dir,
					     'srcport'=>$policy->{$name}->{'srcport'},
					     'dstport'=>$policy->{$name}->{'dstport'},
					     'transport'=>$policy->{'transport'}};
	MsgPrint('AKA',"New SP policy[%s] spi[%s]\n",$policyID,$spi);
    }
    # 
}
sub CtSetSA {
    my($akaID,$negoname,$spi,$dir,$alg,$ealg,$srcip,$dstip,$srcport,$dstport,$transport,$relation)=@_;

    if($DIRRoot{'SC'}->{'SA'}->{$dir}->{$spi}){
	MsgPrint('ERR',"SA %s already registerd\n",$spi);
    }
    else{
	$DIRRoot{'SC'}->{'SA'}->{$dir}->{$spi}=
	{'aka'=>$akaID,'negoname'=>$negoname,
	 'spi'=>$spi,'dir'=>$dir,'authAlgo'=>$alg,'encAlgo'=>$ealg,
	 'srcip'=>$srcip,'dstip'=>$dstip,
	 'relation' => $relation,
	 'spino'=>scalar(keys(%{$DIRRoot{'SC'}->{'SA'}->{'in'}}))+scalar(keys(%{$DIRRoot{'SC'}->{'SA'}->{'out'}}))+1};
	$DIRRoot{'SC'}->{'SP'}->{CtMkPolicyID($srcport,$dstport,$transport)}={'spi'=>$spi,'dir'=>$dir,'srcport'=>$srcport,
									      'dstport'=>$dstport,'transport'=>$transport};
   	
    }
}
sub CtMkPolicyID {
    my($srcport,$dstport,$transport)=@_;
    return $srcport.':'.$dstport.':'.($transport || 'UDP');
}
sub CtFindSA {
    my($spi,$dir)=@_;
    return $DIRRoot{'SC'}->{'SA'}->{$dir}->{$spi};
}
sub CtFindSAfromSP {
    my($sp)=@_;
    unless($sp){return;}
    $sp=$DIRRoot{'SC'}->{'SP'}->{$sp} unless(ref($sp));
    return $sp->{'dir'} ? $DIRRoot{'SC'}->{'SA'}->{$sp->{'dir'}}->{$sp->{'spi'}} : '';
}
sub CtFindSP {
    my($policyID)=@_;
    return $DIRRoot{'SC'}->{'SP'}->{$policyID};
}
# 
#  nosetkey: setkey
sub CtFindSAIfromID {
    my($akaID,$negoname,$nosetkey)=@_;
    my($spis,$spi,@sas);
    $spis = $DIRRoot{'SC'}->{'SA'}->{'in'};
    foreach $spi (keys(%$spis)) {
	if( $spis->{$spi}->{'aka'} eq $akaID && $spis->{$spi}->{'negoname'} eq $negoname && (!$nosetkey || $spis->{$spi}->{'setkeyed'})){
	    push(@sas,$spis->{$spi});
	}
    }
    $spis = $DIRRoot{'SC'}->{'SA'}->{'out'};
    foreach $spi (keys(%$spis)) {
	if( $spis->{$spi}->{'aka'} eq $akaID && $spis->{$spi}->{'negoname'} eq $negoname && (!$nosetkey || $spis->{$spi}->{'setkeyed'})){
	    push(@sas,$spis->{$spi});
	}
    }
    return \@sas;
}
# SPI
sub CtFindPolicyIDfromSPI {
    my($spi,$dir)=@_;
    my($sps,$policyID,@policyID);
    $sps = $DIRRoot{'SC'}->{'SP'};
    foreach $policyID (keys(%$sps)) {
	if( $sps->{$policyID}->{'spi'} eq $spi && $sps->{$policyID}->{'dir'} eq $dir){
	    push(@policyID,$policyID);
	}
    }
    return \@policyID;
}
sub CtDeleteSAforID {
    my($akaID)=@_;
    my($spis,$spi);
    $spis = $DIRRoot{'SC'}->{'SA'}->{'in'};
    foreach $spi (keys(%$spis)) {
	if( $spis->{$spi}->{'aka'} eq $akaID){
	    $spis->{$spi}='';
	}
    }
    $spis = $DIRRoot{'SC'}->{'SA'}->{'out'};
    foreach $spi (keys(%$spis)) {
	if( $spis->{$spi}->{'aka'} eq $akaID){
	    $spis->{$spi}='';
	}
    }
}

# 
#   
sub CtFindReverseSPfromSP {
    my($policyID)=@_;
    my($sa);
    unless($sa=CtFindSAfromSP($policyID)){return}
#    printf("CtFindReverseSPfromSP [%s]=>[%s] dir(%s)\n",$policyID,$sa->{'relation'},$sa->{'dir'});

    return CtFindPolicyIDfromSPI($sa->{'relation'},$sa->{'dir'} eq 'in' ? 'out':'in')->[0];
}

# 
sub CtAKAKeyparams {
    my($skey,$op,$amf,$rand);
    $op   = CtTbCfg('AKA','op')            || $AKA_OP;
    $amf  = CtTbCfg('AKA','amf')           || $AKA_AMF;
    $skey = CtTbCfg('AKA','secretkey')     || $AKA_K;
    if(length($amf) ne 4){$amf = substr($amf.'0000',0,4);}
    if(length($op) ne 32){$op = substr($op.'00000000000000000000000000000000',0,32)}

    # 
    $rand = CtTbCfg('AKA','rand-mode') eq 'fix' ? $AKA_RAND : CtRandom(16);
    MsgPrint('AKA',"Sharedkey:%s\n",$skey);
    MsgPrint('AKA'," op:%s  amf:%s  rand:%s\n",$op,$amf,$rand);
    return $skey,$op,$amf,$rand,CtTbCfg('AKA','rand-mode');
}

# milenage 
sub CtAKAGenVector {
    my($sqn,$secretkey)=@_;
    my($op,$amf,$skey,$rand,$mac,$xres,$ck,$ik,$ak,$opc);

    # milenage 
    ($skey,$op,$amf,$rand)=CtAKAKeyparams();

    $sqn  = $sqn || CtTbCfg('AKA','seqno') || $AKA_SEQ;
    $secretkey = $secretkey || $skey;

    MilenageF1($op, $secretkey, $rand, $sqn, $amf, $mac);
    MilenageF2345($op, $secretkey, $rand, $xres, $ck, $ik, $ak);
    ComputeOPc($op, $secretkey,$opc);
    return $op,$amf,$secretkey,$rand,$mac,$xres,$ck,$ik,$ak,$opc,$sqn;
}

# AKA+IPsec
sub CtAKACreate {
    my($id,$negoname,$sqn)=@_;
    my($aka,$op,$amf,$skey,$rand,$mac,$xres,$ck,$ik,$ak,$opc);

    # milenage 
    ($op,$amf,$skey,$rand,$mac,$xres,$ck,$ik,$ak,$opc,$sqn)=CtAKAGenVector($sqn);

    $aka=
    {'ID'=>$id,  # 
     # AKA 
     'AKA'=>{
	 'KEY' => $skey,
	 'OP'  => $op,
	 'AMF' => $amf,
	 'RAND'=> $rand,
	 'SQN' => $sqn,
	 'MAC' => $mac,      # F1
	 'XRES'=> $xres,     # F2  
	 'CK'  => $ck,       # F3  
	 'IK'  => $ik,       # F4  
	 'AK'  => $ak,       # F5
	 'OPC' => $opc,      # 
     }};
    CtRegistAKA($id,$negoname,$aka);
    return $aka;
}
# AKA+IPsec
sub CtAKACreateByAUTN {
    my($id,$negoname,$rand,$sqn,$amf)=@_;
    my($aka,$op,$skey,$xres,$ck,$ik,$ak,$tmp,$mac,$xsqn,$opc);

    ($skey,$op)=CtAKAKeyparams();

    MilenageF2345($op, $skey, $rand, $xres, $ck, $ik, $ak);

    unless( CtTbCfg('AKA','akmode') =~ /off/i ){
	MilenageXOR($sqn,$ak,$xsqn);
	$sqn = $xsqn;
    }
    MilenageF1($op, $skey, $rand, $sqn, $amf, $mac);
    ComputeOPc($op, $skey,$opc);

    $aka=
    {'ID'=>$id,  # 
     'AKA'=>{
	 'KEY' => $skey,
	 'OP'  => $op,
	 'AMF' => $amf,
	 'RAND'=> $rand,
	 'SQN' => $sqn,
	 'MAC' => $mac,      # F1
	 'XRES'=> $xres,     # F2  
	 'CK'  => $ck,       # F3  
	 'IK'  => $ik,       # F4  
	 'AK'  => $ak,       # F5
	 'OPC' => $opc,      # 
     }};
    CtRegistAKA($id,$negoname,$aka);
    return $aka;
}
# akaID 
sub CtAKADelete {
    my($akaID,$all)=@_;
    if($all){
	CtDeleteSAforID($akaID);
	if(CtTbCfg('AKA','ipsec-mode') =~ /auto/i){CtSetkeyClear()};
    }
    else{
	$DIRRoot{'SC'}->{'AKA'}->{$akaID}='';
    }
}
sub CtRegistAKA {
    my($akaID,$negoname,$aka)=@_;
    MsgPrint('AKA', "New AKA(%s) ck:[%s] ik:[%s] create\n",$akaID,$aka->{'AKA'}->{'CK'},$aka->{'AKA'}->{'IK'});
    return $DIRRoot{'SC'}->{'AKA'}->{$akaID}->{$negoname||'SA0'}=$aka;
}
sub CtFindAKA {
    my($akaID,$negoname)=@_;
    return $DIRRoot{'SC'}->{'AKA'}->{$akaID}->{$negoname||'SA0'};
}

# IPSec
sub CtIPSecPolicy {
    my($remoteip,$localip,$alg,$ealg,$spicR,$spisR,$portcR,$portsR,$spicL,$spisL,$portcL,$portsL,$transport)=@_;
    my(%policy);
    
    $policy{'LocalIp'}  = $localip  if($localip);
    $policy{'RemoteIp'} = $remoteip if($remoteip);
    $policy{'transport'} = $transport;
    if($alg){
	if($AKADoi{$alg}){
#	    $policy{'IPSecAuthAlgo'} = $alg;
	    $policy{'RtoL'}->{'authAlgo'} = $alg;
	    $policy{'LtoR'}->{'authAlgo'} = $alg;
	}
	else{
	    MsgPrint(ERR,"Unsopported auth Algorithm [%s]\n",$alg);
	}
    }
    if($ealg){
	if($AKADoi{$ealg}){
#	    $policy{'IPSecEncAlgo'} = $ealg;
	    $policy{'RtoL'}->{'encAlgo'} = $ealg;
	    $policy{'LtoR'}->{'encAlgo'} = $ealg;
	}
	else{
	    MsgPrint(ERR,"Unsopported encrypt Altgorithm [%s]\n",$ealg);
	}
    }
    $policy{'ResLtoR'}->{'spi'} = $spicR if($spicR);
    $policy{'ReqLtoR'}->{'spi'} = $spisR if($spisR);
    $policy{'ResRtoL'}->{'spi'} = $spicL if($spicL);
    $policy{'ReqRtoL'}->{'spi'} = $spisL if($spisL);
    if($portcR){
	$policy{'ResLtoR'}->{'dstport'}=$portcR;
	$policy{'ReqRtoL'}->{'srcport'}=$portcR;
    }
    if($portsR){
	$policy{'ReqLtoR'}->{'dstport'}=$portsR;
	$policy{'ResRtoL'}->{'srcport'}=$portsR;
    }
    if($portcL){
	$policy{'ResRtoL'}->{'dstport'}=$portcL;
	$policy{'ReqLtoR'}->{'srcport'}=$portcL;
    }
    if($portsL){
	$policy{'ReqRtoL'}->{'dstport'}=$portsL;
	$policy{'ResLtoR'}->{'srcport'}=$portsL;
    }
    return \%policy;
}

# AKA+IPsec
sub CtSASetup {
    my($akaID,$negoname,$remoteip,$localip,$alg,$ealg,$spicR,$spisR,$portcR,$portsR,$spicL,$spisL,$portcL,$portsL,$sqn,$scheme,$transport)=@_;
    my($aka,$policy);

    unless($akaID){
	MsgPrint('ERR',"Private ID invalid\n");
	return;
    }
    $aka = ref($akaID)?$akaID:CtFindAKA($akaID,$negoname);
    unless($aka){
	# milenage 
	$aka=CtAKACreate($akaID,$negoname,$sqn);
    }

    # 
    $policy=CtIPSecPolicy($remoteip,$localip,$alg,$ealg,
			  $spicR,$spisR,$portcR,$portsR,
			  $spicL||CtMkSPI(),$spisL||CtMkSPI(),$portcL,$portsL,$transport);

    # SA+SP
    if($transport eq 'UDP'){
	CtSACreate('out',$akaID,$negoname,$policy,'ReqLtoR','ReqRtoL');
	CtSACreate('in', $akaID,$negoname,$policy,'ReqRtoL','ReqLtoR');
    }
    else{
	CtSACreate('out',$akaID,$negoname,$policy,'ReqLtoR','ResRtoL');
	CtSACreate('out',$akaID,$negoname,$policy,'ResLtoR','ReqRtoL');  # 
	CtSACreate('in', $akaID,$negoname,$policy,'ReqRtoL','ResLtoR');
	CtSACreate('in', $akaID,$negoname,$policy,'ResRtoL','ReqLtoR');  # 
    }

    # 
    CtAKACoConfig($aka,$localip,$remoteip,$portcL,$portsL,$portcR,$portsR,$alg,$ealg,$scheme,
		  $policy->{'ResLtoR'}->{'spi'},$policy->{'ReqLtoR'}->{'spi'},$policy->{'ResRtoL'}->{'spi'},$policy->{'ReqRtoL'}->{'spi'});

    return $aka,$policy;
}
# AKA+IPsec
sub CtSASetupByAUTN {
    my($akaID,$negoname,$rand,$sqn,$amf,$remoteip,$localip,$alg,$ealg,$spicR,$spisR,$portcR,$portsR,$portcL,$portsL,$spicL,$spisL,$scheme,$transport)=@_;
    my($aka,$policy);

    unless($akaID){
	MsgPrint('ERR',"Private ID invalid\n");
	return;
    }
    $aka = ref($akaID)?$akaID:CtFindAKA($akaID,$negoname);
    unless($aka){
	# milenage 
	$aka=CtAKACreateByAUTN($akaID,$negoname,$rand,$sqn,$amf);
    }

    # 
    $policy=CtIPSecPolicy($remoteip,$localip,$alg,$ealg,
			  $spicR,$spisR,$portcR,$portsR,
			  $spicL,$spisL,$portcL,$portsL,$transport);

    # SA+SP
    if($transport eq 'UDP'){
	CtSACreate('out',$akaID,$negoname,$policy,'ReqLtoR','ReqRtoL');
	CtSACreate('in', $akaID,$negoname,$policy,'ReqRtoL','ReqLtoR');
    }
    else{
	CtSACreate('out',$akaID,$negoname,$policy,'ReqLtoR','ResRtoL');
	CtSACreate('out',$akaID,$negoname,$policy,'ResLtoR','ReqRtoL');  # 
	CtSACreate('in', $akaID,$negoname,$policy,'ReqRtoL','ResLtoR');
	CtSACreate('in', $akaID,$negoname,$policy,'ResRtoL','ReqLtoR');  # 
    }

    # 
    CtAKACoConfig($aka,$localip,$remoteip,$portcL,$portsL,$portcR,$portsR,$alg,$ealg,$scheme,
		  $policy->{'ResLtoR'}->{'spi'},$policy->{'ReqLtoR'}->{'spi'},$policy->{'ResRtoL'}->{'spi'},$policy->{'ReqRtoL'}->{'spi'});

    return $aka,$policy;
}

# 
sub CtAKACoConfig{
    my($aka,$localip,$remoteip,$portcL,$portsL,$portcR,$portsR,$alg,$ealg,$scheme,
       $remoteSpiC,$remoteSpiS,$localSpiC,$localSpiS)=@_;
    $DIRRoot{'SC'}->{'PARAM'}->{'COCFG'}->{'IPSEC'}=
	{'username'=>$aka->{'ID'},'ik'=>CtAKAik($aka),'ck'=>CtAKAck($aka),
	 'remote-ip'=>$remoteip,'remote-port-c'=>$portcR,'remote-port-s'=>$portsR,
	 'local-ip' =>$localip, 'local-port-c' =>$portcL,'local-port-s'=>$portsL,
	 'remote-spi-c'=>$remoteSpiC, 'remote-spi-s'=>$remoteSpiS,
	 'local-spi-c'=>$localSpiC, 'local-spi-s'=>$localSpiS,
	 'remote-alg'=>$alg,  'remote-ealg'=>$ealg,
	 'local-alg'=>$alg,   'local-ealg'=>$ealg, 'mech'=>$scheme};
}

sub CtAKAParamCheck {
    my($scheme,$alg,$ealg,$spic,$spis,$portc,$ports)=@_;
    if(!$scheme || !$AKADoi{$scheme}){MsgPrint('ERR',"AKA scheme invalid\n");return;}
    if(!$alg || !$AKADoi{$alg}){MsgPrint('ERR',"Auth Algorithm[%s] invalid\n",$alg);return;}
    if(!$ealg || !$AKADoi{$ealg}){MsgPrint('ERR',"Encrypt Algorithm[%s] invalid\n",$ealg);return;}
    unless($spic){MsgPrint('ERR',"SPI c invalid\n");return;}
    unless($spis){MsgPrint('ERR',"SPI s invalid\n");return;}
    unless($portc){MsgPrint('ERR',"PORT c invalid\n");return;}
    unless($ports){MsgPrint('ERR',"PORT s invalid\n");return;}
    return 'OK';
}

sub CtAKA {
    my($akaID,$negoname)=@_;
    my($aka);
    $aka = ref($akaID)?$akaID:CtFindAKA($akaID,$negoname);
    unless($aka){
	MsgPrint('ERR',"Private ID[%s] invalid\n",$akaID);
	return;
    }
    return $aka->{'AKA'};
}
sub CtAKAck {
    my($akaID,$negoname)=@_;
    my($aka);
    $aka = ref($akaID)?$akaID:CtFindAKA($akaID,$negoname);
    unless($aka){
	MsgPrint('ERR',"Private ID[%s] invalid\n",$akaID);
	return;
    }
    return $aka->{'AKA'}->{'CK'};
}
sub CtAKAik {
    my($akaID,$negoname)=@_;
    my($aka);
    $aka = ref($akaID)?$akaID:CtFindAKA($akaID,$negoname);
    unless($aka){
	MsgPrint('ERR',"Private ID[%s] invalid\n",$akaID);
	return;
    }
    return $aka->{'AKA'}->{'IK'};
}
sub CtAKAsqn {
    my($akaID,$negoname)=@_;
    my($aka);
    $aka = ref($akaID)?$akaID:CtFindAKA($akaID,$negoname);
    unless($aka){
	MsgPrint('ERR',"Private ID[%s] invalid\n",$akaID);
	return;
    }
    return $aka->{'AKA'}->{'SQN'};
}
sub CtAKAmac {
    my($akaID,$negoname)=@_;
    my($aka);
    $aka = ref($akaID)?$akaID:CtFindAKA($akaID,$negoname);
    unless($aka){
	MsgPrint('ERR',"Private ID[%s] invalid\n",$akaID);
	return;
    }
    return $aka->{'AKA'}->{'MAC'};
}
sub CtAKAxres {
    my($akaID,$base64,$negoname)=@_;
    my($aka);
    $aka = ref($akaID)?$akaID:CtFindAKA($akaID,$negoname);
    unless($aka){
	MsgPrint('ERR',"Private ID[%s] negoname[%s] invalid\n",$akaID,$negoname);
	return;
    }
    if($base64){
	return base64encode( pack('H*',$aka->{'AKA'}->{'XRES'}) );
    }
    return $aka->{'AKA'}->{'XRES'};
}
sub CtAKADecodeXres {
    my($response)=@_;
    $response =~ s/"([^"]*)"/$1/;
    return unpack('H*',base64decode($response));
}
sub CtAKAGetAutn {
    my($akaID,$negoname)=@_;
    my($aka,$sqn);
    $aka = ref($akaID) ? $akaID : CtFindAKA($akaID,$negoname);
    unless($aka){
	MsgPrint('ERR',"Private ID[%s] invalid\n",$akaID);
	return;
    }
    if( CtTbCfg('AKA','akmode') =~ /off/i ){
	$sqn=$aka->{'AKA'}->{'SQN'};
    }
    else{
	MilenageXOR($aka->{'AKA'}->{'SQN'},$aka->{'AKA'}->{'AK'},$sqn);
    }
    return $aka->{'AKA'}->{'RAND'},$sqn.$aka->{'AKA'}->{'AMF'}.$aka->{'AKA'}->{'MAC'};
}
sub CtAKAGetAuts {
    my($akaID,$sqn,$negoname)=@_;
    my($aka,$ak,$xsqn,$macs);

    $aka = ref($akaID)? $akaID : CtFindAKA($akaID,$negoname);
    unless($aka){
	MsgPrint('ERR',"Private ID[%s] invalid\n",$akaID);
	return;
    }
    MilenageF1star($aka->{'AKA'}->{'OP'},$aka->{'AKA'}->{'KEY'},$aka->{'AKA'}->{'RAND'},$sqn,$aka->{'AKA'}->{'AMF'},$macs);

    MilenageF5star($aka->{'AKA'}->{'OP'},$aka->{'AKA'}->{'KEY'},$aka->{'AKA'}->{'RAND'},$ak);
    unless( CtTbCfg('AKA','akmode') =~ /off/i ){
	MilenageXOR($sqn,$ak,$xsqn);
	$sqn=$xsqn;
    }
    return $sqn.$macs
}
sub CtAKADecodeAutn {
    my($nonce)=@_;
    my($rand,$sqn,$amf,$mac);

    $nonce = unpack('H*',base64decode($nonce));
    $rand = substr($nonce,0,32);
    $sqn = substr($nonce,32,12);
    $amf = substr($nonce,44,4);
    $mac = substr($nonce,48,16);
    return $rand,$sqn,$amf,$mac;
}
# AUTS 
sub CtAKADecodeAuts {
    my($akaID,$auts,$negoname)=@_;
    my($aka,$ak,$sqn,$mac);

    $aka = ref($akaID)?$akaID:CtFindAKA($akaID,$negoname);
    unless($aka){
	MsgPrint('ERR',"Private ID[%s] invalid\n",$akaID);
	return;
    }
    MilenageF5star($aka->{'AKA'}->{'OP'},$aka->{'AKA'}->{'KEY'},$aka->{'AKA'}->{'RAND'},$ak);
    if( CtTbCfg('AKA','akmode') =~ /off/i ){
	$sqn = $auts;
    }
    else{
	MilenageXOR($auts,$ak,$sqn);
    }
    MilenageF1star($aka->{'AKA'}->{'OP'},$aka->{'AKA'}->{'KEY'},$aka->{'AKA'}->{'RAND'},$sqn,$aka->{'AKA'}->{'AMF'},$mac);
    return $sqn,$mac;
}

#  RAND + AUTN(SQN + AMF + MAC) 
sub CtAKAGetAutnBase64 {
    my($akaID,$negoname)=@_;
    my($rand,$autn);
    ($rand,$autn)=CtAKAGetAutn($akaID,$negoname);
    return base64encode( pack('H*',$rand.$autn) );
}

# 
sub CtSetkeyClear {
    my($cmd,$result);
    $cmd ='setkey -FP';  # SPD 
    MsgPrint('AKA',"%s\n",$cmd);
    $result=CtUtShell($cmd);
    sleep(1);
    $cmd ='setkey -F';   # SAD 
    MsgPrint('AKA',"%s\n",$cmd);
    $result=CtUtShell($cmd);
    sleep(1);
}

# setkey
sub CtSetkeyInfo {
    my($val,%inf,@inf,$inf,$srcip,$dstip,$spi,$label);
    $val=CtUtShell("setkey -D");
    if($val =~ /not\s*supported/i){
	CtSvError('fatal', "IPsec no installed");
    }
    elsif(!$val || $val =~ /No (?:SAD|SPD) entries/i){
	return ;
    }
    @inf = $val =~ /^(\S.+\S)\s*\n((?:\s.+\n)+)/gm;
    foreach $inf (@inf){
	if( $inf =~ /^(\S+)\s+(\S+)$/ ){
	    $srcip = $1;
	    $dstip = $2;
	}
	elsif( $inf =~ /spi=([0-9]+)\(0x\S+\s+reqid=([0-9]+)\(0x/ ){
	    $spi=$1;
	    $label=$2;
	    $inf{$spi}={'src'=>$srcip,'dst'=>$dstip,'label'=>$label};
	}
    }
    return \%inf;
}

# 
sub CtSetkey {
    my($sa,$policyIDs,$aka)=@_;
    my($sp,$policyID,$prefix,$result,$authKey,$encKey,$dstport,$srcport,$setkeyed,$transport,
       $dir,$ck,$ik,$dstip,$srcip,$alg,$ealg,$label);

    # SA
    if(!$sa->{'setkeyed'}){
	$ck     = CtAKAck($aka);
	$ik     = CtAKAik($aka);
	$dstip  = $sa->{'dstip'};
	$srcip  = $sa->{'srcip'};
	$alg    = $sa->{'authAlgo'};
	$ealg   = $sa->{'encAlgo'};
	$prefix = $sa->{'proto'} eq 'ip4' ? 32 : 128;
	$label  = $sa->{'spino'};
	$dir    = $sa->{'dir'};
	($result,$authKey,$encKey,$setkeyed)=CtSetkeySA($sa->{'spi'},$dir,$ck,$ik,$dstip,$srcip,$alg,$ealg,$label);
	$sa->{'authKey'}=$authKey;
	$sa->{'encKey'}=$encKey;
	$sa->{'setkeyed'}=$setkeyed;  # setkey 
    }
    # SP
    $policyIDs = [$policyIDs] unless(ref($policyIDs));
    foreach $policyID (@$policyIDs){
	$sp = CtFindSP($policyID);
	if(!$sp->{'setkeyed'}){
	    $dstip  = $sa->{'dstip'};
	    $srcip  = $sa->{'srcip'};
	    $prefix = $sa->{'proto'} eq 'ip4' ? 32 : 128;
	    $label  = $sa->{'spino'};
	    $dir    = $sa->{'dir'};
	    $dstport = $sp->{'dstport'};
	    $srcport = $sp->{'srcport'};
	    $transport = lc($sp->{'transport'});
	    ($result,$setkeyed)=CtSetkeySP($dir,$dstip,$srcip,$dstport,$srcport,$transport,$prefix,$label);
	    $sp->{'setkeyed'}=$setkeyed;  # setkey 
	}
    }
}

sub CtSetkeySA {
    my($spi,$dir,$ck,$ik,$dstip,$srcip,$alg,$ealg,$label)=@_;
    my($spd,$cmd,$result,$setkeyed);

    # 
    if($ealg =~ /des-ede3-cbc/){
	$ck= $ck . substr($ck,0,16);  # KEY : 24 byte
	$ealg='3des-cbc';
    }
    elsif($ealg =~ /aes-cbc/i){
	$ealg='rijndael-cbc';         # KEY : 16 byte
    }
    else{
	$ck='';
	$ealg='null';
    }
    if($alg =~ /hmac-md5-96/i){
	$alg='hmac-md5';              # KEY : 16 byte
    }
    elsif($alg =~ /hmac-sha-1-96/i){
	$ik= $ik . '00000000';        # KEY : 24 byte
	$alg='hmac-sha1';
    }
    else{
	MsgPrint('ERR',"Unsupported alg[%s]\n",$alg);
    }

    if(CtTbCfg('AKA','ipsec-mode') =~ /auto/i && CtTbCfg('DEBUG','simulate') ne 'on'){
	if($ck){ $ck = '0x'.$ck; }
	if($ik){ $ik = '0x'.$ik; }
	if( $dir eq 'in' ){
	    $spd = "add $srcip $dstip esp $spi -m transport -u $label -E $ealg $ck -A $alg $ik;"
	}
	else{
	    $spd = "add $srcip $dstip esp $spi -m transport -u $label -E $ealg $ck -A  $alg $ik;";
	}
	$cmd = "echo '" . $spd . "'|setkey -c";
	MsgPrint('AKA',"%s\n",$cmd);
	
	$result=CtUtShell($cmd);
	if($result){
	    MsgPrint('ERR',"Setkey error:%s",$result);
	}
	else{
	    $setkeyed='setkeyed';
	}
	Time::HiRes::sleep(0.2);
    }
    return $result,$ik,$ck,$setkeyed;
}

sub CtSetkeySP {
    my($dir,$dstip,$srcip,$dstport,$srcport,$transport,$prefix,$label)=@_;
    my($spd,$cmd,$result,$setkeyed);

    if(CtTbCfg('AKA','ipsec-mode') =~ /auto/i && CtTbCfg('DEBUG','simulate') ne 'on'){
	if( $dir eq 'in' ){
	    $spd = "spdadd $srcip/$prefix"."[$srcport] $dstip/$prefix"."[$dstport] $transport -P in ipsec esp/transport//unique:$label;";
	}
	else{
	    $spd = "spdadd $srcip/$prefix"."[$srcport] $dstip/$prefix"."[$dstport] $transport -P out ipsec esp/transport//unique:$label;";
	}
	$cmd = "echo '" . $spd . "'|setkey -c";
	MsgPrint('AKA',"%s\n",$cmd);
	
	$result=CtUtShell($cmd);
	if($result){
	    MsgPrint('ERR',"Setkey error:%s",$result);
	}
	else{
	    $setkeyed='setkeyed';
	}
	Time::HiRes::sleep(0.2);
    }
    
    return $result,$setkeyed;
}


#============================================
# 
#============================================
sub CtRandom {
    my($size)=@_;
    my($hex,$seed,@tim);
    @tim = Time::HiRes::gettimeofday();
    $seed = @tim[1] & 0xFF;
    while(length($hex)<$size*2){
	$hex .= sprintf("%x",int(rand $seed));
	@tim = Time::HiRes::gettimeofday();
	$seed += @tim[1];
	$seed = $seed & 0xFFFF;
    }
    return substr($hex,0,$size*2);
}

# SPI
sub CtMkSPI {
    return hex( CtRandom(4) );
}

# 
sub CtBin2Long {
    my($b)=@_;
    my($result,$i);
    $result = 0;
    for ($i = 0; $i <= $#$b; $i++){
	$result <<= 8;
	$result |= ($b->[$i] & 255);
    }
    return $result & 0xffffffff;
}

# 48
# seq : 
# ind : 
# indLen : 
sub SQNGenerate {
    my($seq, $ind, $indLen)=@_;
    return substr( sprintf("%012x",($seq << $indLen) + $ind) . '0000000000',0,12);
}

# 
sub SQNReGenerate {
    my($seq, $ind, $octetLenSeq, $octetLenInd, $amod8)=@_;
    my($k,$i,@x);
    $k=5;
    for ($i = $octetLenInd - 1; $i >= 0; $i--){
	@x[$k] = $ind->[$i];
	$k--;
    }
    
    for ($i = $octetLenSeq - 1; $i >= 0; $i--){
	if ($i eq $octetLenSeq - 1 && $amod8){
	    @x[$k+1] = (@x[$k+1] + $seq->[$i]) & 0xff ;
	}
	else{
	    @x[$k] = $seq->[$i];
	    $k--;
	}
    }
    return \@x;
}

sub SQNincSeq{
    my($seq, $octetLenSeq, $amod8)=@_;
    my($i,$increment);

    $i = $octetLenSeq - 1;
    $increment = 1;
    
    while ($i >= 0){
	if ($i == $octetLenSeq - 1 && ($amod8 != 0)){
	    $increment = SQNGetPower(2, $amod8);
	}
	else{
	    $increment = 1;
	}
	if ($seq->[$i] == ((256 - $increment) & 0xff) ){
	    $seq->[$i] = 0;
	    $i--;
	}
	else{
	    $seq->[$i] += $increment;
	    last;
	}
    }
    return $seq;
}    

sub SQNGetPower {
    my($a, $b) = @_;
    my($res,$i);
    $res = 1;
    for ( $i = 0; $i < $b; $i++){
	$res *= $a; 
    }
    return $res;
}

sub SQNincInd {
    my($ind, $octetLenInd, $amod8) =@_;
    my($i);

    $i = $octetLenInd - 1;
		
    while ($i >= 0){
	if ($i == 0 && ($amod8 != 0 && $ind->[$i] == ((SQNGetPower(2, $amod8) - 1) & 0xff))){
	    $ind->[$i]=0;
	    last;
	}
	elsif ($ind->[$i] == 255){
	    $ind->[$i] = 0;
	    $i--;
	}
	else{
	    $ind->[$i]++;
	    last;
	}
    }
    return $ind;
}

sub SQNGetNext {
    my($sqn, $amod)=@_;
    my($startFlag,@ind,@seq,@dat,$i,$octetLenInd,$octetLenSeq,$amod8,$k,$i,$j,$val);

    @dat=map{hex($_)}(unpack('a2'x(length($sqn)/2),$sqn));

    $startFlag = grep{$_}(@dat);
    $octetLenInd = 0;
    $octetLenSeq = 0;
    $amod8 = $amod % 8;
    
    $octetLenInd = int($amod / 8);
    if ($amod8){
	$octetLenInd++;
    }
    
    $octetLenSeq = int((48 - $amod) / 8);
    if ($amod8){
	$octetLenSeq++;
    }
    
    $k = $octetLenInd - 1;

    for ($i = $#dat; $i > $#dat - $octetLenInd; $i--){
	@ind[$k] = @dat[$i];
	$k--;
    }
    
    if ($amod8){
	@ind[$k+1] = (@ind[$k+1] & (SQNGetPower(2, $amod8) - 1)) & 0xff;
	@dat[$i+1] = (@dat[$i+1] - @ind[$k+1]) & 0xff;
	$i++;
    }
    
    $k = $octetLenSeq - 1;
    for ($j = $i; $j >= 0; $j--){
	@seq[$k] = @dat[$j];
	$k--;
    }
    
    if (!$startFlag){
	SQNincSeq(\@seq, $octetLenSeq, $amod8);	
    }
    else{
	SQNincInd(\@ind, $octetLenInd, $amod8);
	SQNincSeq(\@seq, $octetLenSeq, $amod8);
    }
    
    $sqn = SQNReGenerate( \@seq, \@ind, $octetLenSeq, $octetLenInd, $amod8);
    map{$val.=sprintf('%02x',$_)}(@$sqn);
    return $val;
}

# 
#  sqnMS: UE
#  sqnHE: HE
#  indLen: 
#  delta: 
#  L: 
sub SQNinRange {
    my($sqnMS, $sqnHE, $indLen, $delta, $L)=@_;
    my($sqnMSLong,$sqnHELong,$seqMS,$seqHE,%mask,$i,$index,$mask,@tmp1,@tmp2);
    
    unless(ref($sqnMS)){
	@tmp1=map{hex($_)}(unpack('a2'x(length($sqnMS)/2),$sqnMS));
	$sqnMS=\@tmp1;
    }
    unless(ref($sqnHE)){
	@tmp2=map{hex($_)}(unpack('a2'x(length($sqnHE)/2),$sqnHE));
	$sqnHE=\@tmp2;
    }
    $sqnMSLong = CtBin2Long($sqnMS);
    $sqnHELong = CtBin2Long($sqnHE);

    $seqMS = $sqnMSLong >> $indLen;
    $seqHE = $sqnHELong >> $indLen;
	    	
    $mask = 0;
    for ($i=0; $i<$indLen; $i++){
	$mask <<= 1;
	$mask |= 1;
    }

    $index = $mask & $sqnHELong;
    
    # C.2.1 from TS 33.102
    if ($seqHE - $seqMS > $delta){
	return ;
    }
    
    # C.2.2 from TS 33.102
    if ($seqMS - $seqHE > $L){
	return ;
    }
    if ($seqHE <= $seqMS){
	return ;
    }

    return 'true';
}


1;
