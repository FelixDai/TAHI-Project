#!/usr/bin/perl 

# use strict;

# 
$IKEEncryptMode=1;

# 
$IKEEncryptPhase1=0;

# 
$IKEEncryptPhase1Salvage=0;

#============================================
# 
#============================================

# 
@IKEScenario = 
(
 {TY => 'scenario',
  NM => "PH1.AG.Initiator",
  KY => ['initiator','phase1','aggressive'],
  ST => [{TY => 'state', NM => "PH1.AG.MSG1.send", EV =>'START',  AC => ['IKPh1AgInMsg1Send'], NX => 'PH1.AG.MSG2.recv'},
	 {TY => 'state', NM => "PH1.AG.MSG2.recv", EV =>'MSGREV', AC => ['IKPh1AgInMsg2Recv'], 
	  RRf=> ['PHASE1-INITIATOR-MSG2'],
	  RRl=> ['UDP_PH1_SOURCEADDR','UDP_PH1_DESTINATIONADDR','ID_PH1_TYPE_VALUE','ID_PH1_DATA_VALUE','HASH-DATA_VALUE'], 
	  NX => {'OK'=>'PH1.complete','COMMIT'=>'PH1.AG.MSG4.recv'}},
	 {TY => 'state', NM => "PH1.AG.MSG4.recv", EV => 'MSGREV', AC => 'IKPh1AgInMsg4Recv', NX => 'PH1.complete'},
	 ]},
 
 {TY => 'scenario',
  NM => "PH1.AG.Responder",
  KY => ['responder','phase1','aggressive'],
  ST => [{TY => 'state', NM => "PH1.AG.MSG1.recv", EV =>'MSGREV', AC => ['IKPh1AgRpMsg1Recv'], 
	  RRf=> ['PHASE1-RESPONDER-MSG1'],
	  RRl=> ['UDP_PH1_SOURCEADDR','UDP_PH1_DESTINATIONADDR','ID_PH1_TYPE_VALUE','ID_PH1_DATA_VALUE'], 
	  NX => 'PH1.AG.MSG3.recv'},
	 {TY => 'state', NM => "PH1.AG.MSG3.recv", EV =>'MSGREV', AC => ['IKPh1AgRpMsg3Recv'],
	  RRf=> ['PHASE1-RESPONDER-MSG3'],
	  RRl=> ['UDP_PH1_SOURCEADDR','UDP_PH1_DESTINATIONADDR','HASH-DATA_VALUE'], 
	  NX => {'OK'=>'PH1.complete','COMMIT'=>'PH1.AG.MSG4.recv'}},
	 {TY => 'state', NM => "PH1.AG.MSG4.recv", EV => 'MSGREV', AC => 'IKPh1AgInMsg4Recv', NX => 'PH1.complete'},
	 ]},
 
 {TY => 'scenario',
  NM => "PH2.QK.Initiator",
  KY => ['initiator','phase2','quick'],
  ST => [{TY => 'state', NM => "PH2.QK.MSG1.send", EV => 'START',  AC => 'IKPh2QkInMsg1Send', NX => 'PH2.QK.MSG2.recv'},
	 {TY => 'state', NM => "PH2.QK.MSG2.recv", EV => 'MSGREV', AC => 'IKPh2QkInMsg2Recv', 
	  RRf=> ['PHASE2-INITIATOR-MSG2'],
	  RRl=> ['UDP_PH2_SOURCEADDR','UDP_PH2_DESTINATIONADDR',
		 'ID_PH2_INI_DATA0_VALUE','ID_PH2_INI_DATA1_VALUE','ID_PH2_INI_TYPE0_VALUE','ID_PH2_INI_TYPE1_VALUE',
		 'HASH-DATA_VALUE'], 
	  NX => {'OK'=>'PH2.complete','COMMIT'=>'PH2.QK.MSG4.recv'}},
	 {TY => 'state', NM => "PH2.QK.MSG4.recv", EV => 'MSGREV', AC => 'IKPh2QkInMsg4Recv', NX => 'PH2.complete'},
	 ]},
 
 {TY => 'scenario',
  NM => "PH2.QK.Responder",
  KY => ['responder','phase2','quick'],
  ST => [{TY => 'state', NM => "PH2.QK.MSG1.recv", EV => 'MSGREV', AC => 'IKPh2QkRpMsg1Recv', 
	  RRf=> ['PHASE2-RESPONDER-MSG1'],
	  RRl=> ['UDP_PH2_SOURCEADDR','UDP_PH2_DESTINATIONADDR',
		 'ID_PH2_RES_DATA0_VALUE','ID_PH2_RES_DATA1_VALUE','ID_PH2_RES_TYPE0_VALUE','ID_PH2_RES_TYPE1_VALUE',
		 'HASH-DATA_VALUE','ID_PH2_RES_PORT0_VALUE','ID_PH2_PROTO0_VALUE'], 
	  NX => 'PH2.QK.MSG3.recv'},
	 {TY => 'state', NM => "PH2.QK.MSG3.recv", EV => 'MSGREV', AC => 'IKPh2QkRpMsg3Recv', 
	  RRf=> ['PHASE2-RESPONDER-MSG3'],
	  RRl=> ['UDP_PH2_SOURCEADDR','UDP_PH2_DESTINATIONADDR','HASH-DATA_VALUE'], 
	  NX => {'OK'=>'PH2.complete','COMMIT'=>'PH2.QK.MSG4.recv'}},
	 {TY => 'state', NM => "PH2.QK.MSG4.recv", EV => 'MSGREV', AC => 'IKPh2QkInMsg4Recv', NX => 'PH2.complete'},
	 ]},
 );

# 
@IKEEncFrameRecvState=("PH1.complete","PH1.AG.MSG3.recv","PH1.AG.MSG4.recv","PH2.QK.MSG2.recv","PH2.QK.MSG1.recv",
		       "PH2.QK.MSG3.recv","PH2.QK.MSG4.recv","PH2.complete");
%IKEEncFrameExchangeType=("PH1.complete"=>5,"PH1.AG.MSG3.recv"=>4,
			  "PH1.AG.MSG4.recv"=>4,"PH2.QK.MSG2.recv"=>32,
			  "PH2.QK.MSG1.recv"=>32,"PH2.QK.MSG3.recv"=>32,
			  "PH2.QK.MSG4.recv"=>32,"PH2.complete"=>32);

#============================================
# 
#   
#   
#============================================
#     
#       UserFunc       => 
#       RequestSaID    => 
#       ParentInst     => 
#       PacketResponse => 
#       Interface      => 
#       Timeout        => 
#       Event          => 
sub IKEScenarioMain {
    my($context)=@_;
    my($event,$inst,$state,$pkt,$etype);

    MsgPrint('DBG',"<=IKE IKEScenarioMain\n");

    # 
    $event=$context->{'Event'};

    # 
    if($event->{'Etype'} eq 'MSGREV'){

	# 
	if(!$event->{'Data'}->{'Frame'}){
	    $event->{'Data'}->{'Frame'} = IKEParse($event->{'Data'}->{'Packet'});
	}
	# 
	$etype=GFv("IK,HD,ExchangeType",$event->{Data}->{Frame});
    }
    
    # 
    $pkt=$event->{'Data'}->{'Packet'};
    if( $inst = IKEFindScenarioInstanceFromEvent($event,$context) ){

	# Infomation
	if($etype && $etype eq $IKEDoi{'TI_ETYPE_INFO'}){
	    IKActionScenatio('RRf',$event->{'Etype'},$event,$inst,$event->{'Data'}->{'Frame'},$context);
	    IKEInfoExchRecv($inst,$event,$context);
	}
	# Infomation,Aggresive,Quick
	elsif($etype && $etype ne $IKEDoi{'TI_ETYPE_AGG'} && $etype ne $IKEDoi{'TI_ETYPE_QUICK'} ){
	    IKActionScenatio('RRf',$event->{'Etype'},$event,$inst,$event->{'Data'}->{'Frame'},$context);
	    IKEUnknownRecv($inst,$event,$context);
	}
	else{
	    # 
	    $state=$inst->{'ST'};
	    $context->{'ScenarioInst'}=$inst;
	    # 
	    if(!IKActionScenatio('AC',$event->{'Etype'},$event,$inst,$event->{'Data'}->{'Frame'},$context)){
		if($state ne $inst->{'ST'} && ($inst->{'ST'} eq 'PH1.complete' || $inst->{'ST'} eq 'PH2.complete')){
		    $pkt->{'ikeStatus'}='StSAComplete';
		    $pkt->{'ikeResult'}={IKEGetSaInfo($inst)};

		    # SA
		    if($inst->{'Side'} eq 'responder'){
			$event = IKCreateEvent('SACOMPLETE', {'Packet' => $pkt} );
			IKPushEvent($event);
		    }
		    else{
			return $pkt;
		    }
		}
	    }
	}
    }
    else{
	IKEUnknownRecv('',$event,$context);
    }
    MsgPrint('DBG',"=>IKE IKEScenarioMain\n");
    return ;
}

#============================================
# 
#============================================
sub IKEMatchFrameForNotify {
    my($context)=@_;
    my($event,$inst,$state,$pkt,$etype,$cond,$i);

    printf("<=IKE IKEMatchFrameForNotify\n");
    MsgPrint('DBG',"<=IKE IKEMatchFrameForNotify\n");

    # 
    $event=$context->{'Event'};

    # 
    if($event->{'Etype'} ne 'MSGREV'){return;}

    # 
    if(!$event->{'Data'}->{'Frame'}){
	$event->{'Data'}->{'Frame'} = IKEParse($event->{'Data'}->{'Packet'});
    }
    # 
    $etype=GFv("IK,HD,ExchangeType",$event->{Data}->{Frame});
    
    # 
    if( !($inst = IKEFindScenarioInstanceFromEvent($event,$context)) ){
	MsgPrint('WAR',"IKE Notify can't find instance\n");
	return;
    }

    $cond=$context->{'UserArgs'};
    $pkt=$event->{'Data'}->{'Packet'};

    for $i (0..$#$cond){
	if(defined($cond->[$i]->{'ISAKMP_SA_HANDLER'})){
	    if($inst->{'Phase'} eq 1){
		if($inst->{'ID'} ne $cond->[$i]->{'ISAKMP_SA_HANDLER'}){next;}
	    }
	    else{
		if($inst->{'Phase1ID'} ne $cond->[$i]->{'ISAKMP_SA_HANDLER'}){next;}
	    }
	}
	if(defined($cond->[$i]->{'PHASE'})){
	    if($inst->{'Phase'} ne $cond->[$i]->{'PHASE'}){next;}
	}
	if(defined($cond->[$i]->{'TN_IP_ADDR'})){
	    if($pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'} ne $cond->[$i]->{'TN_IP_ADDR'}){next;}
	}
	if(defined($cond->[$i]->{'NUT_IP_ADDR'})){
	    if($pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'} ne $cond->[$i]->{'NUT_IP_ADDR'}){next;}
	}
	if(defined($cond->[$i]->{'TN_ETHER_ADDR'})){
	    if($pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'} ne $cond->[$i]->{'TN_ETHER_ADDR'}){next;}
	}
	if(defined($cond->[$i]->{'NUT_ETHER_ADDR'})){
	    if($pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'} ne $cond->[$i]->{'NUT_ETHER_ADDR'}){next;}
	}
	$pkt->{'ikeResult'}=$cond->[$i]->{'NOTIFY_ID'};
	$pkt->{'ikeStatus'}='StIKENotify';

	# 
	IKEGeneralRecv($inst,$event,$context);
	return $pkt;
    }
    return;
}

#============================================
# 
#============================================
sub IKPh1AgInMsg1Send {
    my($event,$inst,$context)=@_;
    my($said,$prof,$req,$payload,$hexSt,$hexString,$pub,$priv,$pkt,$val);

    MsgPrint('DBG',"<=IKPh1AgInMsg1Send\n");
	
    # 
    $inst->{'Phase'}=1;
    $inst->{'Side'}='initiator';
    $said=$context->{'RequestSaID'}->[0]->{'ID'};
    if( !($prof=IKEGetSAProf($said)) ){
	LogPrint('ERR',1,$said,"IKPh1AgInMsg1Send SAID[$said] is not registed, do not continue.\n");
	return ;
    }
    LogPrint('INF1',1,$said,"start");
    $inst->{'TnEtherAddr'} =$prof->{'TN_ETHER_ADDR'};
    $inst->{'TnIPAddr'}    =$prof->{'TN_IP_ADDR'};
    $inst->{'NutEtherAddr'}=$prof->{'NUT_ETHER_ADDR'};
    $inst->{'NutIPAddr'}   =$prof->{'NUT_IP_ADDR'};
    $inst->{'SaID1'}=$said;

    # IKE
    $req=IKENewPacket();
    
    # 
    $inst->{'InitiatorCookie'}=IKEMkCookie($prof->{TN_IP_ADDR}, 500, $prof->{NUT_IP_ADDR},500);
    $inst->{'ResponderCookie'}='0000000000000000';
    # ISAKMP
    IKEAddPayload($req,'Hdr_ISAKMP',{'InitiatorCookie'=>$inst->{'InitiatorCookie'},
				       'ResponderCookie'=>$inst->{'ResponderCookie'},
				       'ExchangeType'=>$prof->{'ETYPE'}});

    # 
    $payload=IKEAddPayload($req,'Pld_ISAKMP_SA_IPsec_IDonly');

    # 
    $payload=IKEAddPayload($payload,'Pld_ISAKMP_P_ISAKMP',
			   {'ProtocolID'=>$IKEDoi{'TI_PROTO_ISAKMP'},'ProposalNumber'=>1,'NumOfTransforms'=>1});

    # 
    $payload=IKEAddPayload($payload,'Pld_ISAKMP_T',{'TransformNumber'=>1,'TransformID'=>$IKEDoi{TI_ISAKMP_KEY_IKE}});

    # 
    if($prof->{'ATTR_AUTH_METHOD'} ne ''){
	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{TI_ISAKMP_AUTH_METHOD},
						 'Value'=>$prof->{'ATTR_AUTH_METHOD'}});
    }
    if($prof->{'ATTR_ENC_ALG'} ne ''){
	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{TI_ISAKMP_ENC_ALG},
						 'Value'=>$prof->{'ATTR_ENC_ALG'}});
    }
    if($prof->{'ATTR_HASH_ALG'} ne ''){
	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{TI_ISAKMP_HASH_ALG},
						 'Value'=>$prof->{'ATTR_HASH_ALG'}});
    }
    if($prof->{'ATTR_PH1_GRP_DESC'} ne ''){
	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{TI_ISAKMP_GRP_DESC},
						 'Value'=>$prof->{'ATTR_PH1_GRP_DESC'}});
    }

    # 
    $val=$prof->{'ATTR_PH1_SA_LD_TYPE'}?$prof->{'ATTR_PH1_SA_LD_TYPE'}:$IKEDoi{$IKEDefaultPH1SA{'ATTR_PH1_SA_LD_TYPE'}->{'VL'}};
    IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{TI_ISAKMP_SA_LD_TYPE},'Value'=>$val});

    $val=$prof->{'ATTR_PH1_SA_LD'}?$prof->{'ATTR_PH1_SA_LD'}:$IKEDefaultPH1SA{'ATTR_PH1_SA_LD'}->{'VL'};
    if(0xFFFF<$val){
	IKEAddPayload($payload,'Attr_ISAKMP_TLV',{'Type'=>$IKEDoi{TI_ISAKMP_SA_LD},'Length'=>4,'Value'=>$val});
    }
    else{
	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{TI_ISAKMP_SA_LD},'Value'=>$val});
    }

#     if($prof->{'ATTR_PH1_SA_LD_TYPE'} ne ''){
# 	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{TI_ISAKMP_SA_LD_TYPE},
# 						 'Value'=>$prof->{'ATTR_PH1_SA_LD_TYPE'}});
#     }
#     if($prof->{'ATTR_PH1_SA_LD'} ne ''){
# 	if(0xFFFF<$prof->{'ATTR_PH1_SA_LD'}){
# 	    IKEAddPayload($payload,'Attr_ISAKMP_TLV',{'Type'=>$IKEDoi{TI_ISAKMP_SA_LD},'Length'=>4,
# 						      'Value'=>$prof->{'ATTR_PH1_SA_LD'}});
# 	}
# 	else{
# 	    IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{TI_ISAKMP_SA_LD},'Value'=>$prof->{'ATTR_PH1_SA_LD'}});
# 	}
#     }


    # 
    ($pub,$priv)=IKEMkDH($prof->{'ATTR_PH1_GRP_DESC'});
    if(!$pub){return;}
    $inst->{'DHPublicKey'}=$pub;
    $inst->{'DHPrivateKey'}=$priv;

    # 
    IKEAddPayload($req,'Pld_ISAKMP_KE',{'KeyExchangeData'=>$pub});

    # NONCE
    $inst->{'PH1LocalNonce'}=IKEMkNonce();
    IKEAddPayload($req,'Pld_ISAKMP_NONCE',{'NonceData'=>$inst->{'PH1LocalNonce'}});
    
    # ID
    IKEAddPayload($req,IKEGetPayloadFromIDType($prof->{'TN_ID_TYPE'}),
		  {'IDtype'=>$prof->{'TN_ID_TYPE'},ProtocolID=>17,Port=>500,'ID'=>$prof->{'TN_ID'}});
    
    # 
    if( IKEComposePayload($req) ){ return $inst->{'ST'}; }

# HEX
# 	# 
# 	$hexSt=HXConvIKEStToHexSt($req->{'ID'}->[0]);
# 	$hexString=PktHexEncode($hexSt);
# 	$inst->{'IDPayload'}=substr($hexString,8);
# 	# 
# 	$hexSt=HXConvIKEStToHexSt($req->{'SA'}->[0]);
# 	$hexString=PktHexEncode($hexSt);
# 	$inst->{'SAPayload'}=substr($hexString,8);
	
    # 
    $pkt=IKESend($inst->{'TnEtherAddr'},$inst->{'TnIPAddr'},$inst->{'NutEtherAddr'},
		 $inst->{'NutIPAddr'}, $req,'IKE_SEND',$context->{Interface});
    
    # 
    $req=IKEParse($pkt);
    $hexString=HXConvSTToHex($req->{'IK'}->{'ID'}->[0]);
    $inst->{'IDPayload'}=substr($hexString,8);
    $hexString=HXConvSTToHex($req->{'IK'}->{'SA'}->[0]);
    $inst->{'SAPayload'}=substr($hexString,8);
    $inst->{'SendPktInfo'}=$req;
    
    # 
    $inst->{'PH1Msg1'}=IKAddCapture('',$pkt,'PH1','',$inst->{'ID'},1);
    return '';
}
# 
sub IKPh1AgInMsg2Recv {
    my($event,$inst,$context)=@_;
    my($req,$ans,$prof,$field,$hashDataA,$hashDataB,$hexString,$remoteID,$pkt,$encInfo);

    MsgPrint('DBG',"<=IKPh1AgInMsg2Recv\n");

    # 
    if(IKPh1AgInMsg2RecvCheck($event,$inst,$context)){
	LogPrint('ERR',$inst,'',"Receive invalid 2nd MSG.\n");
	return $inst->{'ST'};
    }

    # 
    $req=$event->{'Data'}->{'Frame'};
    $inst->{'PH1Msg2'}=IKAddCapture($req,$event->{'Data'}->{'Packet'},'PH1','',$inst->{'ID'},2);

    # 
    if( IKEIsValidAddress($inst,$event->{'Data'}->{'Packet'},$context->{'Interface'}) ){
	IKEPktComment('NG:AddressMismatch');
	LogPrint('ERR',$inst,'',"Receive IKE address invallid.\n");
	return $inst->{'ST'};
    }

    # 
    if( !($prof=IKEGetSAProf($inst->{'SaID1'})) ){
	IKEPktComment('NG:ProfileMismatch');
	LogPrint('ERR','1','',"IKPh1AgInMsg2Recv SAID[$inst->{'SaID1'}] is not registed, do not continue.\n");
	return $inst->{'ST'};
    }
    # 
    if( IKEIsExistPayload($req,{'SA'=>1,'SA,PR'=>1,'SA,PR,TR'=>1,'KE'=>1,'NC'=>1,'ID'=>1,'HA'=>1}) ){
	IKEPktComment('NG:PayloadInvalid');
	LogPrint('ERR',$inst,'',"Required Payload dose not exist.\n");
	return $inst->{'ST'};
    }

    # ID
    if(!GFv("IK,ID",$req)){
	IKEPktComment('NG:IDInvalid');
	LogPrint('ERR',$inst,'',"Phase1 msg2 not exist ID payload\n");
	return $inst->{'ST'};
    }

    # COMMIT BIT
    if(GFv("IK,HD,CFlag",$req)){$inst->{'CommitBit'}='TRUE';}
    
    # 
    $inst->{'ResponderCookie'}=GFv("IK,HD,ResponderCookie",$req);

    # 
    $field='IK,SA,PR,TR,ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_HASH_ALG'} . '`,Value';
    $inst->{PRFHashAlgo}=GFv($field,$req); # $IKEDoi{'TI_ATTR_HASH_ALG_SHA'};
    $field='IK,SA,PR,TR,ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_ENC_ALG'} . '`,Value';
    $inst->{IKEEncAlgo}=GFv($field,$req);  # $IKEDoi{'TI_ATTR_ENC_ALG_3DES'};
    $inst->{IKEEncLeng}='';

    # 
    if(!GFv("IK,KE",$req)){
	IKEPktComment('NG:KEInvalid');
	LogPrint('ERR',$inst,'',"Phase1 msg2 not exist KE payload\n");
	return $inst->{'ST'};
    }

    # 
    IKECalcSecParam($inst,$req,$prof);

    # 
    $hexString=HXConvSTToHex($req->{'IK'}->{'ID'}->[0]);
    $remoteID=substr($hexString,8);
    $hashDataA=IKEPrf($inst->{'PRFHashAlgo'},$inst->{'SKEYID'},$inst->{'DHRemotePublicKey'},
		      $inst->{'DHPublicKey'},$inst->{'ResponderCookie'},$inst->{'InitiatorCookie'},
		      $inst->{'SAPayload'},$remoteID);
    $inst->{'CalculateHASH'}=$hashDataA;
    $hashDataB=GFv("IK,HA,HashData",$req);
    if($hashDataA ne $hashDataB){
	IKEPktComment('NG:AuthInvalid');
	LogPrint('ERR',$inst,'',"Hash Authenticator illegal [%s:%s]\n",$hashDataA,$hashDataB);
	return $inst->{'ST'};
    }

    # 
    $hexString = $inst->{'DHPublicKey'} . $inst->{'DHRemotePublicKey'} . $inst->{'InitiatorCookie'} .
	$inst->{'ResponderCookie'} . $inst->{'SAPayload'} . $inst->{'IDPayload'};
    $hashDataA=IKEPrf($inst->{'PRFHashAlgo'},$inst->{'SKEYID'},$hexString);
    MsgPrint('DBG4',"Algo=[%s]\n",$inst->{'PRFHashAlgo'});
    MsgPrint('DBG4',"Key=[%s]\n",$inst->{'SKEYID'});
    MsgPrint('DBG4',"Data=[%s]\n",$hexString);
    MsgPrint('DBG4',"Digest=[%s]\n",$hashDataA);

#    printf("hashData[%s]\n",$hashDataA);

    # 
    $ans=IKENewPacket();
    
    # ISAKMP
    IKEAddPayload($ans,'Hdr_ISAKMP',{'InitiatorCookie'=>$inst->{'InitiatorCookie'},
				     'ResponderCookie'=>$inst->{'ResponderCookie'},
				     'EFlag'=>$IKEEncryptPhase1?1:0,
				     'ExchangeType'=>$prof->{'ETYPE'},'CFlag'=>$IKEPh1CommitMode?1:0});
    # 
    IKEAddPayload($ans,'Pld_ISAKMP_HASH',{'HashData'=>$hashDataA});

    # 
    if( IKEComposePayload($ans) ){return $inst->{'ST'};}

    # 
    if($IKEEncryptPhase1){
	$encInfo=IKESetupEncInfo($inst,'send');
    }

    # 
    $pkt=IKESend($inst->{'TnEtherAddr'},$inst->{'TnIPAddr'},$inst->{'NutEtherAddr'},
		 $inst->{'NutIPAddr'}, $ans,'IKE_SEND',$context->{Interface}, $encInfo);
    # 
    $inst->{'SendPktInfo'}=$ans;

    # 
    if($IKEEncryptPhase1){
	$inst->{'IV'}=IKEGetIVEC($pkt);
    }

    # 
    $inst->{'PH1Msg3'}=IKAddCapture('',$pkt,'PH1','',$inst->{'ID'},3);
    
    # COMMIT BIT
    if($IKEPh1CommitMode){
	IKENotifySend($inst,'CONNECTED',$context);
    }

    # COMMIT BIT
    if($inst->{'CommitBit'}){
	return 'COMMIT';
    }
    else{
	# 
	$inst->{'ISAKMPTimeout'}=$prof->{'ATTR_PH1_SA_LD'} ? $prof->{'ATTR_PH1_SA_LD'} : $IKESATimeout;
	$inst->{'ISAKMPStart'}=time();
	$inst->{'ISAKMPStatus'}='VALID';
	$inst->{'Link'}=$context->{Interface};
	IKEPktComment('Complete ' . $inst->{'SaID1'});
	LogPrint('INF1',$inst,'',"complete");
	return '';
    }
}
sub IKPh1AgInMsg4Recv {
    my($event,$inst,$context)=@_;
    my($req,$prof);

    MsgPrint('DBG',"<=IKPh1AgInMsg4Recv\n");

    # 
    $req=$event->{'Data'}->{'Frame'};
    $inst->{'PH1Msg4'}=IKAddCapture($req,$event->{'Data'}->{'Packet'},'INF','Connected',$inst->{'ID'},4);

    # 
    $inst->{'IVE'}=IKEGetIVEC($event->{'Data'}->{'Packet'});

    # 
    if( IKEIsExistPayload($req,{'HA'=>1,'NO'=>1}) ){
	IKEPktComment('NG:PayloadInvalid');
	LogPrint('ERR',$inst,'',"Required Payload dose not exist.\n");
	return $inst->{'ST'};
    }

    # 
    
    # 
    if( !($prof=IKEGetSAProf($inst->{'SaID1'})) ){
	IKEPktComment('NG:ProfileMismatch');
	LogPrint('ERR','1','',"IKPh1AgInMsg4Recv SAID[$inst->{'SaID1'}] is not registed, do not continue.\n");
	return $inst->{'ST'};
    }

    # 
    $inst->{'ISAKMPTimeout'}=$prof->{'ATTR_PH1_SA_LD'} ? $prof->{'ATTR_PH1_SA_LD'} : $IKESATimeout;
    $inst->{'ISAKMPStart'}=time();
    $inst->{'ISAKMPStatus'}='VALID';
    $inst->{'Link'}=$context->{Interface};
    # IV
    $inst->{'IV'}=$inst->{'IVE'};
    IKEPktComment('Complete ' . $inst->{'SaID1'});
    LogPrint('INF1',$inst,'',"complete");
    
    return '';
}

#============================================
# 
#============================================
sub IKPh1AgRpMsg1Recv {
    my($event,$inst,$context)=@_;
    my($req,$ans,$pkt,$said,$hexString,$prof,$payload,$pub,$priv,$hashData,
       $prono,$transno,$trans,$idpayload,$lfType,$lfDura,$af);

    MsgPrint('DBG',"<=IKPh1AgRpMsg1Recv\n");

    # 
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $inst->{'PH1Msg1'}=IKAddCapture($req,$pkt,'PH1',GFv("IK,HD,CFlag",$req)?'Commit':'',$inst->{'ID'},1);

    # 
    $inst->{'InitiatorCookie'}=GFv("IK,HD,InitiatorCookie",$req);
    $inst->{'Phase'}=1;
    $inst->{'Side'}='responder';

    # 
    if( IKEIsExistPayload($req,{'SA'=>1,'SA,PR'=>1,'SA,PR,TR'=>{'Op'=>'over','Val'=>1},'KE'=>1,'NC'=>1,'ID'=>1}) ){
	IKEPktComment('NG:PayloadInvalid');
	LogPrint('ERR',$inst,'',"Required Payload dose not exist.\n");
	return $inst->{'ST'};
    }

    # 
    ($said,$prono,$transno)=IKEMatchSAPH1($req,$pkt,$context->{'Interface'},'in',$context->{'RequestSaID'});
    if(!$said){
	IKEPktComment('NG:ProfileMismatch');
	LogPrint('ERR',$inst,'',"Profile dose not match.\n");
	return $inst->{'ST'};
    }
    if( !($prof=IKEGetSAProf($said)) ){
	IKEPktComment('NG:NoProfile');
	LogPrint('ERR','1','',"IKPh1AgRpMsg1Recv SAID[$said] is not registed, do not continue.\n");
	return $inst->{'ST'};
    }

    # ISAKMP
    #   
    $lfType=GFv('IK,SA,PR,TR#' . $transno .',ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_SA_LD_TYPE'} . '`,Value',$req);
    $lfDura=GFv('IK,SA,PR,TR#' . $transno .',ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_SA_LD'} . '`,Value',$req);
    
    # 
    $inst->{'ISAKMPTimeout'}=$lfDura ? $lfDura : $IKESATimeout;
    $inst->{'TnEtherAddr'} =$prof->{'TN_ETHER_ADDR'};
    $inst->{'TnIPAddr'}    =$prof->{'TN_IP_ADDR'};
    $inst->{'NutEtherAddr'}=$prof->{'NUT_ETHER_ADDR'};
    $inst->{'NutIPAddr'}   =$prof->{'NUT_IP_ADDR'};
    $inst->{'SaID1'}=$said;

    LogPrint('INF1',1,$said,"start");

    # COMMIT BIT
    if(GFv("IK,HD,CFlag",$req)){$inst->{'CommitBit'}='TRUE';}

    # SA
    $hexString=HXConvSTToHex($req->{'IK'}->{'SA'}->[0]);
#    PrintVal($req->{'IK'}->{'SA'}->[0]);
    $inst->{'SAPayload'}=substr($hexString,8);
#    PrintItem($hexString);exit;


    # 
    $inst->{'InitiatorCookie'}=GFv("IK,HD,InitiatorCookie",$req);
    
    # IKE
    $ans=IKENewPacket();

    # 
    $inst->{'ResponderCookie'}=IKEMkCookie($prof->{TN_IP_ADDR}, 500, $prof->{NUT_IP_ADDR},500);

    # ISAKMP
    IKEAddPayload($ans,'Hdr_ISAKMP',{'InitiatorCookie'=>$inst->{'InitiatorCookie'},
				     'ResponderCookie'=>$inst->{'ResponderCookie'},
				     'ExchangeType'=>$prof->{'ETYPE'},'CFlag'=>$IKEPh1CommitMode?1:0});

    # 
    $payload=IKEAddPayload($ans,'Pld_ISAKMP_SA_IPsec_IDonly');

    # 
    $payload=IKEAddPayload($payload,'Pld_ISAKMP_P_ISAKMP',
			   {'ProtocolID'=>$IKEDoi{'TI_PROTO_ISAKMP'},'ProposalNumber'=>1,'NumOfTransforms'=>1});

    # 
    $trans=GFv('IK,SA,PR#' . $prono .',TR#' . $transno,$req);
    $trans->{'NextPayload'}=0;

    # 
    IKEAddPayload($payload,'',$trans);

    # 
    ($pub,$priv)=IKEMkDH($prof->{'ATTR_PH1_GRP_DESC'});
    if(!$pub){return;}
    $inst->{'DHPublicKey'}=$pub;
    $inst->{'DHPrivateKey'}=$priv;

    # 
    IKEAddPayload($ans,'Pld_ISAKMP_KE',{'KeyExchangeData'=>$pub});

    # NONCE
    $inst->{'PH1LocalNonce'}=IKEMkNonce();
    IKEAddPayload($ans,'Pld_ISAKMP_NONCE',{'NonceData'=>$inst->{'PH1LocalNonce'}});
    
    # ID
    IKEAddPayload($ans,IKEGetPayloadFromIDType($prof->{'TN_ID_TYPE'}),
		  {'IDtype'=>$prof->{'TN_ID_TYPE'},ProtocolID=>17,Port=>500,'ID'=>$prof->{'TN_ID'}});
    
    # 
    $hexString=HXConvSTToHex($ans->{'ID'}->[0]);
    $idpayload=substr($hexString,8);

    # 
    $hexString=HXConvSTToHex($req->{'IK'}->{'ID'}->[0]);
    $inst->{'IDPayload'}=substr($hexString,8);

    # 
    $inst->{PRFHashAlgo}=$prof->{'ATTR_HASH_ALG'};
    $inst->{IKEEncAlgo}=$prof->{'ATTR_ENC_ALG'};
    $inst->{IKEEncLeng}='';

    # 
    IKECalcSecParam($inst,$req,$prof);

    # 
    $hexString= $inst->{'DHPublicKey'} . $inst->{'DHRemotePublicKey'} . $inst->{'ResponderCookie'} . 
	$inst->{'InitiatorCookie'} . $inst->{'SAPayload'} . $idpayload;
    $hashData=IKEPrf($inst->{'PRFHashAlgo'},$inst->{'SKEYID'},$hexString);
    MsgPrint('DBG4',"Algo=[%s]\n",$inst->{'PRFHashAlgo'});
    MsgPrint('DBG4',"Key=[%s]\n",$inst->{'SKEYID'});
    MsgPrint('DBG4',"Data=[%s]\n",$hexString);
    MsgPrint('DBG4',"Digest=[%s]\n",$hashData);

    # 
    IKEAddPayload($ans,'Pld_ISAKMP_HASH',{'HashData'=>$hashData});

    # 
    if( IKEComposePayload($ans) ){return $inst->{'ST'};}

    # 
    $pkt=IKESend($inst->{'TnEtherAddr'},$inst->{'TnIPAddr'},$inst->{'NutEtherAddr'},
		 $inst->{'NutIPAddr'}, $ans,'IKE_SEND',$context->{Interface});
    $inst->{'SendPktInfo'}=$ans;
    
    # 
    $inst->{'PH1Msg2'}=IKAddCapture('',$pkt,'PH1',$IKEPh1CommitMode?'commit':'',$inst->{'ID'},2);
    return '';
}
# 
sub IKPh1AgRpMsg3Recv {
    my($event,$inst,$context)=@_;
    my($req,$hashDataA,$hashDataB);

    MsgPrint('DBG',"<=IKPh1AgRpMsg3Recv\n");

    # 
    if($IKEEncryptPhase1Salvage && IKEIsCryptedFrame($event->{'Data'}->{'Packet'})){
	# 
	$inst->{'IVE'}=IKEGetIVEC($event->{'Data'}->{'Packet'});
	# IV
	$inst->{'IV'}=$inst->{'IVE'};
	# 
	$req=$event->{'Data'}->{'Frame'};
	$inst->{'PH1Msg3'}=IKAddCapture($req,$event->{'Data'}->{'Packet'},'PH1','',$inst->{'ID'},3);
	return;
    }

    # 
    if(IKPh1AgRpMsg3RecvCheck($event,$inst,$context)){
	LogPrint('ERR',$inst,'',"Receive invalid 3nd MSG.\n");
	return $inst->{'ST'};
    }

    # 
    $req=$event->{'Data'}->{'Frame'};
    $inst->{'PH1Msg3'}=IKAddCapture($req,$event->{'Data'}->{'Packet'},'PH1',GFv("IK,HD,CFlag",$req)?'Commit':'',$inst->{'ID'},3);

    # 
    if( IKEIsValidAddress($inst,$event->{'Data'}->{'Packet'},$context->{'Interface'}) ){
	IKEPktComment('NG:AddressMismatch');
	LogPrint('ERR',$inst,'',"Receive IKE address invallid.\n");
	return $inst->{'ST'};
    }

    # 
    $inst->{'IVE'}=IKEGetIVEC($event->{'Data'}->{'Packet'});

    # 
    $hashDataA=IKEPrf($inst->{'PRFHashAlgo'},$inst->{'SKEYID'},$inst->{'DHRemotePublicKey'},
		      $inst->{'DHPublicKey'},$inst->{'InitiatorCookie'},$inst->{'ResponderCookie'},
		      $inst->{'SAPayload'},$inst->{'IDPayload'});

    $inst->{'CalculateHASH'}=$hashDataA;
    $hashDataB=GFv("IK,HA,HashData",$req);
    if($hashDataA ne $hashDataB){
	IKEPktComment('NG:AuthInvalid');
	LogPrint('ERR',$inst,'',"Hash Authenticator illegal [%s:%s]\n",$hashDataA,$hashDataB);
	return $inst->{'ST'};
    }
    else{
	MsgPrint('DBG',"Hash Authenticator OK\n");
    }

    # COMMIT BIT
    if(GFv("IK,HD,CFlag",$req)){$inst->{'CommitBit'}='TRUE';}

    # COMMIT BIT
    if($IKEPh1CommitMode && IKENotifySend($inst,'CONNECTED',$context)){
	return $inst->{'ST'};
    }

    # COMMIT BIT
    if($inst->{'CommitBit'}){
	return 'COMMIT';
    }
    else{
	# 
	$inst->{'ISAKMPStart'}=time();
	$inst->{'ISAKMPStatus'}='VALID';
	$inst->{'Link'}=$context->{Interface};
	# IV
	$inst->{'IV'}=$inst->{'IVE'};

	IKEPktComment('Complete ' . $inst->{'SaID1'});
	LogPrint('INF1',$inst,'',"complete");
	return '';
    }
}


#============================================
# 
#============================================
sub IKPh2QkInMsg1Send {
    my($event,$inst,$context)=@_;
    my($said,$prof,$req,$inst1,$messageIDHex,$payload,$hexSt,$hexString,$pkt,$ipAddr,$maskAddr,$encInfo,$idType,$val);

    MsgPrint('DBG',"<=IKPh2QkInMsg1Send\n");

    # 
    $inst1=IKFindScenInstFromID($context->{'ParentInst'});
    if(!$inst1){
	IKEPktComment('NG:NoPhase1');
	LogPrint('ERR','2','',"Phase1 handle not bind to Phase2 handle.\n");
	return $inst->{'ST'};
    }
    $inst->{'Phase1ID'}=$context->{'ParentInst'};

    # 
    $inst->{'Phase'}=2;
    $inst->{'Side'}='initiator';
    $inst->{'InitiatorCookie'}=$inst1->{'InitiatorCookie'};
    $inst->{'ResponderCookie'}=$inst1->{'ResponderCookie'};
    $said=$context->{'RequestSaID'}->[0]->{'ID'};
    if( !($prof=IKEGetSAProf($said)) ){
	IKEPktComment('NG:NoProfile');
	LogPrint('ERR','2','',"IKPh2QkInMsg1Send SAID[$said] is not registed, do not continue.\n");
	return $inst->{'ST'};
    }
    $inst->{'SaID2'}=$said;
    LogPrint('INF1',$inst,'',"start");

    # 
    $messageIDHex=IKEMkMsgID();
    $inst->{'MessageID'}=hex($messageIDHex);
    # 
    
    # IKE
    $req=IKENewPacket();

    # ISAKMP
    IKEAddPayload($req,'Hdr_ISAKMP',{'InitiatorCookie'=>$inst->{'InitiatorCookie'}, 
				     'ResponderCookie'=>$inst->{'ResponderCookie'},
				     'EFlag'=>$IKEEncryptMode,
				     'ExchangeType'=>$prof->{'ETYPE'},'MessageID'=>$inst->{'MessageID'}});

    # 
    IKEAddPayload($req,'Pld_ISAKMP_HASH',{'HashData'=>''});

    # 
    $payload=IKEAddPayload($req,'Pld_ISAKMP_SA_IPsec_IDonly');

    # 
    $inst->{'INSPI'}=IKEMkSPI();

    # 
    $payload=IKEAddPayload($payload,'Pld_ISAKMP_P_ISAKMP',
			   {'ProtocolID'=>$prof->{'PROTO'},'ProposalNumber'=>1,'NumOfTransforms'=>1,
			    'SPI'=>$inst->{'INSPI'},'SPIsize'=>4});

    # 
    $payload=IKEAddPayload($payload,'Pld_ISAKMP_T',{'TransformNumber'=>1,'TransformID'=>$prof->{'ESP_ALG'}});

    # 

    # 
    $val=$prof->{'ATTR_PH2_SA_LD_TYPE'}?$prof->{'ATTR_PH2_SA_LD_TYPE'}:$IKEDoi{$IKEDefaultPH2SA{'ATTR_PH2_SA_LD_TYPE'}->{'VL'}};
    IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{'TI_IPSEC_SA_LD_TYPE'},'Value'=>$val});

    $val=$prof->{'ATTR_PH2_SA_LD'}?$prof->{'ATTR_PH2_SA_LD'}:$IKEDefaultPH2SA{'ATTR_PH2_SA_LD'}->{'VL'};
    if(0xFFFF<$val){
	IKEAddPayload($payload,'Attr_ISAKMP_TLV',{'Type'=>$IKEDoi{'TI_IPSEC_SA_LD'},'Length'=>4,'Value'=>$val});
    }
    else{
	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{'TI_IPSEC_SA_LD'}, 'Value'=>$val});
    }

    if($prof->{'ATTR_PH2_GRP_DESC'} ne ''){
	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{'TI_IPSEC_GRP_DESC'},
						 'Value'=>$prof->{'ATTR_PH2_GRP_DESC'}});
    }
    if($prof->{'ATTR_ENC_MODE'} ne ''){
	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{'TI_IPSEC_ENC_MODE'},
						 'Value'=>$prof->{'ATTR_ENC_MODE'}});
    }
    if($prof->{'ATTR_AUTH'} ne ''){
	IKEAddPayload($payload,'Attr_ISAKMP_TV',{'Type'=>$IKEDoi{'TI_IPSEC_AUTH'},
						 'Value'=>$prof->{'ATTR_AUTH'}});
    }

    # NONCE
    $inst->{'PH2LocalNonce'}=IKEMkNonce();
    IKEAddPayload($req,'Pld_ISAKMP_NONCE',{'NonceData'=>$inst->{'PH2LocalNonce'}});

    # ID
    $idType=IKEPh2IDtoType($prof->{'TN_ID_ADDR'});

    # ID
    if($idType eq 'TI_ID_IPV6_ADDR_SUBNET'){
	($ipAddr,$maskAddr)=IPv6WithMaskStrToVal($prof->{'TN_ID_ADDR'});
	IKEAddPayload($req,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'TN_ID_PORT'},'ID1'=>$ipAddr,'ID2'=>$maskAddr});
    }
    elsif($idType eq 'TI_ID_IPV6_ADDR_RANGE'){
	$prof->{'TN_ID_ADDR'} =~ /(.+)\|(.+)/;
	IKEAddPayload($req,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'TN_ID_PORT'},'ID1'=>$1,'ID2'=>$2});
    }
    elsif($idType eq 'TI_ID_IPV6_ADDR'){
	IKEAddPayload($req,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'TN_ID_PORT'},'ID'=>$prof->{'TN_ID_ADDR'}});
    }

    # ID
    $idType=IKEPh2IDtoType($prof->{'NUT_ID_ADDR'});

    # ID
    if($idType eq 'TI_ID_IPV6_ADDR_SUBNET'){
	($ipAddr,$maskAddr)=IPv6WithMaskStrToVal($prof->{'NUT_ID_ADDR'});
	IKEAddPayload($req,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'NUT_ID_PORT'},'ID1'=>$ipAddr,'ID2'=>$maskAddr});
    }
    elsif($idType eq 'TI_ID_IPV6_ADDR_RANGE'){
	$prof->{'NUT_ID_ADDR'} =~ /(.+)\|(.+)/;
	IKEAddPayload($req,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'NUT_ID_PORT'},'ID1'=>$1,'ID2'=>$2});
    }
    elsif($idType eq 'TI_ID_IPV6_ADDR'){
	IKEAddPayload($req,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'NUT_ID_PORT'},'ID'=>$prof->{'NUT_ID_ADDR'}});
    }

    # NextPayload
    IKEComposePayloadIN($req);

    # 
    $hexString=$messageIDHex;
    $hexSt=HXConvIKEStToHexSt($req->{'SA'}->[0]);
    $hexString .= PktHexEncode($hexSt);
    $hexSt=HXConvIKEStToHexSt($req->{'NC'}->[0]);
    $hexString .= PktHexEncode($hexSt);
    $hexSt=HXConvIKEStToHexSt($req->{'ID'}->[0]);
    $hexString .= PktHexEncode($hexSt);
    $hexSt=HXConvIKEStToHexSt($req->{'ID'}->[1]);
    $hexString .= PktHexEncode($hexSt);

    $req->{'HA'}->[0]->{'HashData'}=IKEPrf($inst1->{'PRFHashAlgo'},$inst1->{'SKEYID_a'},$hexString);

    if( IKEComposePayload($req) ){return $inst->{'ST'};}
	
    # 
    $encInfo=IKESetupEncInfo($inst,'send');

    # 
    IKENewIV2($inst1->{'IKEEncAlgo'},$inst1->{'PRFHashAlgo'},$inst1->{'IV'},$inst->{'MessageID'});

    # 
    $pkt=IKESend($inst1->{'TnEtherAddr'},$inst1->{'TnIPAddr'},$inst1->{'NutEtherAddr'},
		 $inst1->{'NutIPAddr'}, $req,'IKE_SEND',$context->{Interface},$encInfo);
    $inst->{'SendPktInfo'}=IKEParse($pkt);

    # IV
    $inst->{'IV'}=IKEGetIVEC($pkt);
    MsgPrint('DBG',"IV=%s\n",$inst->{'IV'});

    # 
    $inst->{'PH2Msg1'}=IKAddCapture('',$pkt,'PH2','',$inst->{'ID'},1);
    return '';
}
sub IKPh2QkInMsg2Recv {
    my($event,$inst,$context)=@_;
    my($req,$ans,$inst1,$hexSt,$hexString,$hashDataA,$hashDataB,$prof,$pkt,$id,
       $proto,$encKey,$hashKey,$spi,$pkt,$encInfo);

    MsgPrint('DBG',"<=IKPh2QkInMsg2Recv\n");

    # 
    if(IKPh2QkInMsg2RecvCheck($event,$inst,$context)){
	LogPrint('ERR',$inst,'',"Receive invalid 2nd MSG.\n");
	return $inst->{'ST'};
    }

    # 
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $inst->{'PH2Msg2'}=IKAddCapture($req,$pkt,'PH2',GFv("IK,HD,CFlag",$req)?'Commit':'',$inst->{'ID'},2);

    # 
    $inst1=IKFindScenInstFromID($inst->{'Phase1ID'});
    if(!$inst1){
	IKEPktComment('NG:NoPhase1');
	LogPrint('ERR','2','',"Phase1 handle not bind to Phase2 handle.\n");
	return $inst->{'ST'};
    }
    # 
    if( !($prof=IKEGetSAProf($inst->{'SaID2'})) ){
	IKEPktComment('NG:NoProfile');
	LogPrint('ERR','2','',"IKPh2QkInMsg2Recv SAID[%s] is not registed, do not continue.\n",$inst->{'SaID2'});
	return $inst->{'ST'};
    }

#    PrintVal($req);
    # 
    $hexString=sprintf("%08x",GFv("IK,HD,MessageID",$req)) . $inst->{'PH2LocalNonce'};
    $hexSt=HXConvIKEStToHexSt(GFv("IK,SA",$req));
    $hexString .= PktHexEncode($hexSt);
    $hexSt=HXConvIKEStToHexSt(GFv("IK,NC",$req));
    $hexString .= PktHexEncode($hexSt);
    if($id=GFv("IK,ID#0",$req)){
	$hexSt=HXConvIKEStToHexSt($id);
	$hexString .= PktHexEncode($hexSt);
    }
    if($id=GFv("IK,ID#1",$req)){
	$hexSt=HXConvIKEStToHexSt($id);
	$hexString .= PktHexEncode($hexSt);
    }
    $hashDataA=IKEPrf($inst1->{'PRFHashAlgo'},$inst1->{'SKEYID_a'},$hexString);
    $inst->{'CalculateHASH'}=$hashDataA;
    $hashDataB=GFv("IK,HA,HashData",$req);
    if($hashDataA ne $hashDataB){
	IKEPktComment('NG:AuthInvalid');
	LogPrint('ERR',$inst,'',"Hash Authenticator illegal [%s:%s]\n",$hashDataA,$hashDataB);
	return $inst->{'ST'};
    }
    
    # 
    $inst->{'OUTSPI'}=GFv('IK,SA,PR#0,SPI',$req);

    # 
    $inst->{'IPSecEncAlgo'}=$prof->{'ESP_ALG'};
    $inst->{'IPSecAuthAlgo'}=$prof->{'ATTR_AUTH'};
    # IVE
    $inst->{'IVE'}=IKEGetIVEC($pkt);

    # COMMIT BIT
    if(GFv("IK,HD,CFlag",$req)){$inst->{'CommitBit'}='TRUE';}

    # 
    $inst->{'PH2RemoteNonce'}=GFv("IK,NC,NonceData",$req);
    $proto=GFv("IK,SA,PR,ProtocolID",$req);

    # 
    ($encKey,$hashKey)=IKECalcIPsecEncKey($inst1->{'PRFHashAlgo'},$inst->{'IPSecEncAlgo'},$inst->{'IPSecAuthAlgo'},
					  '0'.$proto,$inst->{'INSPI'},$inst->{'PH2LocalNonce'},
					  $inst->{'PH2RemoteNonce'},$inst1->{'SKEYID_d'});
    # 
    $inst->{'IPSecINEncKey'}=$encKey;
    $inst->{'IPSecINHashKey'}=$hashKey;
    $inst->{'IPSecINTimeout'}=$prof->{'ATTR_PH2_SA_LD'}?$prof->{'ATTR_PH2_SA_LD'}:$IPSecSATimeout;

    # 
    ($encKey,$hashKey)=IKECalcIPsecEncKey($inst1->{'PRFHashAlgo'},$inst->{'IPSecEncAlgo'},$inst->{'IPSecAuthAlgo'},
					  '0'.$proto,$inst->{'OUTSPI'},$inst->{'PH2LocalNonce'},
					  $inst->{'PH2RemoteNonce'},$inst1->{'SKEYID_d'});
    $inst->{'IPSecOUTEncKey'}=$encKey;
    $inst->{'IPSecOUTHashKey'}=$hashKey;
    $inst->{'IPSecOUTTimeout'}=$prof->{'ATTR_PH2_SA_LD'}?$prof->{'ATTR_PH2_SA_LD'}:$IPSecSATimeout;

    # IKE
    $ans=IKENewPacket();

    # ISAKMP
    IKEAddPayload($ans,'Hdr_ISAKMP',{'InitiatorCookie'=>$inst->{'InitiatorCookie'},
				     'ResponderCookie'=>$inst->{'ResponderCookie'},
				     'EFlag'=>$IKEEncryptMode,'CFlag'=>$IKEPh2CommitMode?1:0,
				     'ExchangeType'=>$prof->{'ETYPE'},'MessageID'=>$inst->{'MessageID'}});

    # 
    $hexString= '00' . sprintf("%08x",GFv("IK,HD,MessageID",$req)) . $inst->{'PH2LocalNonce'};
    $hexString .= GFv("IK,NC,NonceData",$req);
    $hashDataA=IKEPrf($inst1->{'PRFHashAlgo'},$inst1->{'SKEYID_a'},$hexString);

    # 
    IKEAddPayload($ans,'Pld_ISAKMP_HASH',{'HashData'=>$hashDataA});
    
    if( IKEComposePayload($ans) ){return $inst->{'ST'};}

    # 
    $encInfo=IKESetupEncInfo($inst,'send');

    # 
    $pkt=IKESend($inst1->{'TnEtherAddr'},$inst1->{'TnIPAddr'},$inst1->{'NutEtherAddr'},
		 $inst1->{'NutIPAddr'}, $ans,'IKE_SEND',$context->{Interface},$encInfo);
    $inst->{'SendPktInfo'}=$ans;
    
    # IV
    $inst->{'IV'}=IKEGetIVEC($pkt);

    # 
    $inst->{'PH2Msg3'}=IKAddCapture('',$pkt,'PH2','',$inst->{'ID'},3);
    
    # COMMIT BIT
    if($IKEPh2CommitMode){
	IKENotifySend($inst,'CONNECTED',$context);
    }

    # 
    if($inst->{'CommitBit'}){
	return 'COMMIT';
    }
    else{
	# 
	$inst->{'IPSecINStart'}=time();
	$inst->{'IPSecOUTStart'}=time();
	$inst->{'IPSecINStatus'}='VALID';
	$inst->{'IPSecOUTStatus'}='VALID';
	$inst->{'Link'}=$context->{Interface};
	IKEPktComment('Complete ' . $inst->{'SaID2'});
	LogPrint('INF1',$inst,'',"complete");
	return '';
    }
}
sub IKPh2QkInMsg4Recv {
    my($event,$inst,$context)=@_;
    my($req,$pkt);

    MsgPrint('DBG',"<=IKPh2QkInMsg4Recv\n");

    # 
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $inst->{'PH2Msg4'}=IKAddCapture($req,$pkt,'PH2','Connected',$inst->{'ID'},4);

    # IVE
    $inst->{'IVE'}=IKEGetIVEC($pkt);

    # 
    if( IKEIsExistPayload($req,{'HA'=>1,'NO'=>1}) ){
	IKEPktComment('NG:PayloadInvalid');
	LogPrint('ERR',$inst,'',"Required Payload dose not exist.\n");
	return $inst->{'ST'};
    }

    # 

    # Notify
    if( GFv("IK,NO,NotifyMessageType",$req) ne $IKEDoi{'CONNECTED'} ){
	IKEPktComment('NG:NOInvalid');
	LogPrint('ERR',$inst,'',"Notify payload message type not equal CONNECTED(for Commit Bit).\n");
	return $inst->{'ST'};
    }

    # 
    $inst->{'IPSecINStart'}=time();
    $inst->{'IPSecOUTStart'}=time();
    $inst->{'IPSecINStatus'} ='VALID';
    $inst->{'IPSecOUTStatus'}='VALID';
    $inst->{'Link'}=$context->{Interface};
    IKEPktComment('Complete ' . $inst->{'SaID2'});
    LogPrint('INF1',$inst,'',"complete");

    return '';
}


#============================================
# 
#============================================
sub IKPh2QkRpMsg1Recv {
    my($event,$inst,$context)=@_;
    my($req,$ans,$pkt,$inst1,$hexString,$hexSt,$hashDataA,$hashDataB,
       $messageIDHex,$prono,$transno,$trans,$said,$id,$prof,$payload,$ipAddr,$maskAddr,
       $proto,$spi,$encKey,$hashKey,$encInfo,$idType,$lfDura);

    MsgPrint('DBG',"<=IKPh2QkRpMsg1Recv\n");

    # 
    if(IKPh2QkRpMsg1RecvCheck($event,$inst,$context)){
	LogPrint('ERR',$inst,'',"Receive invalid 1st MSG.\n");
	return $inst->{'ST'};
    }

    # 
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $inst->{'PH2Msg1'}=IKAddCapture($req,$pkt,'PH2',GFv("IK,HD,CFlag",$req)?'Commit':'',$inst->{'ID'},1);

    # 
    $inst1=IKFindScenInstFromID($inst->{'Phase1ID'});
    if(!$inst1){
	IKEPktComment('NG:NoPhase1');
	LogPrint('ERR','2','',"Phase1 handle not bind to Phase2 handle.\n");
	return $inst->{'ST'};
    }

    # 
    if( IKEIsExistPayload($req,{'SA'=>1,'SA,PR'=>{'Op'=>'over','Val'=>1},
				'SA,PR,TR'=>{'Op'=>'over','Val'=>1},'HA'=>1,'NC'=>1,'ID'=>2}) ){
	IKEPktComment('NG:PayloadInvalid');
	LogPrint('ERR',$inst,'',"Required Payload dose not exist.\n");
	return $inst->{'ST'};
    }

    # PFS
    if( GFv('IK,SA,PR,TR,ATT,Type`$v eq ' . $IKEDoi{'TI_IPSEC_GRP_DESC'} . '`,Value',$req) ){
	IKEPktComment('NG:NotSupportPFS');
	LogPrint('ERR',$inst,'',"PFS not yet suppored.\n");
	return $inst->{'ST'};
    }

    # 
    ($said,$prono,$transno)=IKEMatchSAPH2($req,$pkt,$inst1->{'SaID1'},'in',$context->{'RequestSaID'});

    if( !$said ){
	IKEPktComment('NG:NoMatchProposal');
	LogPrint('ERR',$inst,'',"Profile dose not match.\n");
	return $inst->{'ST'};
    }
    if( !($prof=IKEGetSAProf($said)) ){
	IKEPktComment('NG:NoProfile');
	LogPrint('ERR','1','',"IKPh2QkRpMsg1Recv SAID[$said] is not registed, do not continue.\n");
	return $inst->{'ST'};
    }

    $inst->{'SaID2'}=$said;
    $inst->{'InitiatorCookie'}=$inst1->{'InitiatorCookie'};
    $inst->{'ResponderCookie'}=$inst1->{'ResponderCookie'};
    $inst->{'Phase'}=2;
    $inst->{'Side'}='responder';

    # IPSec
    #   
    $lfDura=GFv('IK,SA,PR,TR#' . $transno .',ATT,Type`$v eq ' . $IKEDoi{'TI_IPSEC_SA_LD'} . '`,Value',$req);
    # 
    $lfDura = $lfDura ? $lfDura : $IPSecSATimeout;

    $inst->{'IPSecOUTTimeout'}=$lfDura;
    $inst->{'IPSecINTimeout'}=$lfDura;
    LogPrint('INF1',$inst,'',"start");

    # 
    $hexString=sprintf("%08x",GFv("IK,HD,MessageID",$req));
    $hexSt=HXConvIKEStToHexSt(GFv("IK,SA",$req));
    $hexString .= PktHexEncode($hexSt);
    $hexSt=HXConvIKEStToHexSt(GFv("IK,NC",$req));
    $hexString .= PktHexEncode($hexSt);
    if($id=GFv("IK,ID#0",$req)){
	$hexSt=HXConvIKEStToHexSt($id);
	$hexString .= PktHexEncode($hexSt);
    }
    if($id=GFv("IK,ID#1",$req)){
	$hexSt=HXConvIKEStToHexSt($id);
	$hexString .= PktHexEncode($hexSt);
    }

    $hashDataA=IKEPrf($inst1->{'PRFHashAlgo'},$inst1->{'SKEYID_a'},$hexString);
    $inst->{'CalculateHASH'}=$hashDataA;
    $hashDataB=GFv("IK,HA,HashData",$req);
    if($hashDataA ne $hashDataB){
	IKEPktComment('NG:AuthInvalid');
	LogPrint('ERR',$inst,'',"Hash Authenticator illegal [%s:%s]\n",$hashDataA,$hashDataB);
	return $inst->{'ST'};
    }

    # 
    $inst->{'MessageID'}=GFv("IK,HD,MessageID",$req);

    # 
    $inst->{'OUTSPI'}=GFv('IK,SA,PR#' . $prono . ',SPI',$req);
    # 
    $inst->{'INSPI'}=IKEMkSPI();

    # COMMIT BIT
    if(GFv("IK,HD,CFlag",$req)){$inst->{'CommitBit'}='TRUE';}

    # 
    $inst->{'IPSecEncAlgo'}=$prof->{'ESP_ALG'};
    $inst->{'IPSecAuthAlgo'}=$prof->{'ATTR_AUTH'};
    $proto=GFv("IK,SA,PR,ProtocolID",$req);
    # IVE
    $inst->{'IVE'}=IKEGetIVEC($pkt);

    # NONCE
    $inst->{'PH2LocalNonce'}=IKEMkNonce();
    $inst->{'PH2RemoteNonce'}=GFv("IK,NC,NonceData",$req);

    # IPSec SA
    # 
    ($encKey,$hashKey)=IKECalcIPsecEncKey($inst1->{'PRFHashAlgo'},$inst->{'IPSecEncAlgo'},$inst->{'IPSecAuthAlgo'},
					  '0'.$proto,$inst->{'INSPI'},$inst->{'PH2RemoteNonce'},
					  $inst->{'PH2LocalNonce'},$inst1->{'SKEYID_d'});
    $inst->{'IPSecINEncKey'}=$encKey;
    $inst->{'IPSecINHashKey'}=$hashKey;
    # 
    ($encKey,$hashKey)=IKECalcIPsecEncKey($inst1->{'PRFHashAlgo'},$inst->{'IPSecEncAlgo'},$inst->{'IPSecAuthAlgo'},
					  '0'.$proto,$inst->{'OUTSPI'},$inst->{'PH2RemoteNonce'},
					  $inst->{'PH2LocalNonce'},$inst1->{'SKEYID_d'});
    $inst->{'IPSecOUTEncKey'}=$encKey;
    $inst->{'IPSecOUTHashKey'}=$hashKey;


    # IKE
    $ans=IKENewPacket();

    # ISAKMP
    IKEAddPayload($ans,'Hdr_ISAKMP',{'InitiatorCookie'=>$inst->{'InitiatorCookie'},
				     'ResponderCookie'=>$inst->{'ResponderCookie'},
				     'EFlag'=>$IKEEncryptMode,'CFlag'=>$IKEPh2CommitMode?1:0,
				     'ExchangeType'=>$prof->{'ETYPE'},'MessageID'=>$inst->{'MessageID'}});

    # 
    IKEAddPayload($ans,'Pld_ISAKMP_HASH',{'HashData'=>''});

    # 
    $payload=IKEAddPayload($ans,'Pld_ISAKMP_SA_IPsec_IDonly');

    # 
    $payload=IKEAddPayload($payload,'Pld_ISAKMP_P_ISAKMP',
			   {'ProtocolID'=>$prof->{'PROTO'},
			    'ProposalNumber'=>GFv('IK,SA,PR#' . $prono . ',ProposalNumber',$req),
			    'NumOfTransforms'=>1,
			    'SPI'=>$inst->{'INSPI'},'SPIsize'=>4});

    # 
    $trans=GFv('IK,SA,PR#' . $prono .',TR#' . $transno,$req);
    $trans->{'NextPayload'}=0;
    # 
    IKEAddPayload($payload,'',$trans);

    # NONCE
    IKEAddPayload($ans,'Pld_ISAKMP_NONCE',{'NonceData'=>$inst->{'PH2LocalNonce'}});

    # ID
    $idType=IKEPh2IDtoType($prof->{'NUT_ID_ADDR'});

    # ID
    if($idType eq 'TI_ID_IPV6_ADDR_SUBNET'){
	($ipAddr,$maskAddr)=IPv6WithMaskStrToVal($prof->{'NUT_ID_ADDR'});
	IKEAddPayload($ans,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'NUT_ID_PORT'},'ID1'=>$ipAddr,'ID2'=>$maskAddr});
    }
    elsif($idType eq 'TI_ID_IPV6_ADDR_RANGE'){
	$prof->{'NUT_ID_ADDR'} =~ /(.+)\|(.+)/;
	IKEAddPayload($ans,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'NUT_ID_PORT'},'ID1'=>$1,'ID2'=>$2});
    }
    elsif($idType eq 'TI_ID_IPV6_ADDR'){
	IKEAddPayload($ans,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'NUT_ID_PORT'},'ID'=>$prof->{'NUT_ID_ADDR'}});
    }

    # ID
    $idType=IKEPh2IDtoType($prof->{'TN_ID_ADDR'});

    # ID
    if($idType eq 'TI_ID_IPV6_ADDR_SUBNET'){
	($ipAddr,$maskAddr)=IPv6WithMaskStrToVal($prof->{'TN_ID_ADDR'});
	IKEAddPayload($ans,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'TN_ID_PORT'},'ID1'=>$ipAddr,'ID2'=>$maskAddr});
    }
    elsif($idType eq 'TI_ID_IPV6_ADDR_RANGE'){
	$prof->{'TN_ID_ADDR'} =~ /(.+)\|(.+)/;
	IKEAddPayload($ans,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'TN_ID_PORT'},'ID1'=>$1,'ID2'=>$2});
    }
    elsif($idType eq 'TI_ID_IPV6_ADDR'){
	IKEAddPayload($ans,IKEGetPayloadFromIDType($IKEDoi{$idType}),
		      {'IDtype'=>$IKEDoi{$idType},'ProtocolID'=>$prof->{'ID_PROTO'},
		       'Port'=>$prof->{'TN_ID_PORT'},'ID'=>$prof->{'TN_ID_ADDR'}});
    }

    # NextPayload
    IKEComposePayloadIN($ans);

    # 
    $hexString=sprintf("%08x",$inst->{'MessageID'});
    $hexString .= $inst->{'PH2RemoteNonce'};
    $hexSt=HXConvIKEStToHexSt($ans->{'SA'}->[0]);
    $hexString .= PktHexEncode($hexSt);
    $hexSt=HXConvIKEStToHexSt($ans->{'NC'}->[0]);
    $hexString .= PktHexEncode($hexSt);
    $hexSt=HXConvIKEStToHexSt($ans->{'ID'}->[0]);
    $hexString .= PktHexEncode($hexSt);
    $hexSt=HXConvIKEStToHexSt($ans->{'ID'}->[1]);
    $hexString .= PktHexEncode($hexSt);
    $ans->{'HA'}->[0]->{'HashData'}=IKEPrf($inst1->{'PRFHashAlgo'},$inst1->{'SKEYID_a'},$hexString);
    MsgPrint('DBG4',"Algo=[%s]\n",$inst1->{'PRFHashAlgo'});
    MsgPrint('DBG4',"Key=[%s]\n",$inst1->{'SKEYID_a'});
    MsgPrint('DBG4',"Data=[%s]\n",$hexString);
    MsgPrint('DBG4',"Digest=[%s]\n",$ans->{'HA'}->[0]->{'HashData'});

    if( IKEComposePayload($ans) ){return $inst->{'ST'};}

    # 
    $encInfo=IKESetupEncInfo($inst,'send');

    # 
    $pkt=IKESend($inst1->{'TnEtherAddr'},$inst1->{'TnIPAddr'},$inst1->{'NutEtherAddr'},
		 $inst1->{'NutIPAddr'}, $ans,'IKE_SEND',$context->{Interface},$encInfo);
    $inst->{'SendPktInfo'}=$ans;

    # IV
    $inst->{'IV'}=IKEGetIVEC($pkt);

    # 
    $inst->{'PH2Msg2'}=IKAddCapture('',$pkt,'PH2',$IKEPh2CommitMode?'commit':'',$inst->{'ID'},2);
    return '';
}
sub IKPh2QkRpMsg3Recv {
    my($event,$inst,$context)=@_;
    my($req,$inst1,$hexString,$hashDataA,$hashDataB,$prof,$pkt);

    MsgPrint('DBG',"<=IKPh2QkRpMsg3Recv\n");

    # 
    if(IKPh2QkRpMsg3RecvCheck($event,$inst,$context)){
	LogPrint('ERR',$inst,'',"Receive invalid 3rd MSG.\n");
	return $inst->{'ST'};
    }

    # 
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $inst->{'PH2Msg3'}=IKAddCapture($req,$pkt,'PH2',GFv("IK,HD,CFlag",$req)?'Commit':'',$inst->{'ID'},3);

    # 
    $inst1=IKFindScenInstFromID($inst->{'Phase1ID'});
    if(!$inst1){
	IKEPktComment('NG:NoPhase1');
	LogPrint('ERR','2','',"Phase1 handle not bind to Phase2 handle.\n");
	return $inst->{'ST'};

    }

    # 
    $hexString= '00' . sprintf("%08x",GFv("IK,HD,MessageID",$req));
    $hexString .= $inst->{'PH2RemoteNonce'} . $inst->{'PH2LocalNonce'};
    $hashDataA=IKEPrf($inst1->{'PRFHashAlgo'},$inst1->{'SKEYID_a'},$hexString);
    $inst->{'CalculateHASH'}=$hashDataA;
    $hashDataB=GFv("IK,HA,HashData",$req);
    if($hashDataA ne $hashDataB){
	IKEPktComment('NG:AuthInvalid');
	LogPrint('ERR',$inst,'',"Hash Authenticator illegal [%s:%s]\n",$hashDataA,$hashDataB);
	return $inst->{'ST'};
    }
    else{
	MsgPrint('DBG',"Hash Authenticator OK\n");
    }

    if( !($prof=IKEGetSAProf($inst->{'SaID2'})) ){
	IKEPktComment('NG:NoProfile');
	LogPrint('ERR','1','',"IKPh2QkRpMsg3Recv SAID[%s] is not registed, do not continue.\n",$inst->{'SaID2'});
	return $inst->{'ST'};
    }

    # COMMIT BIT
    if(GFv("IK,HD,CFlag",$req)){$inst->{'CommitBit'}='TRUE';}

    # IVE
    $inst->{'IVE'}=IKEGetIVEC($pkt);
    
    # COMMIT BIT
    if($IKEPh2CommitMode && IKENotifySend($inst,'CONNECTED',$context)){
	return $inst->{'ST'};
    }

    if($inst->{'CommitBit'}){
	return 'COMMIT';
    }
    else{
	# 
	$inst->{'IPSecINStart'}=time();
	$inst->{'IPSecOUTStart'}=time();
	$inst->{'IPSecINStatus'} ='VALID';
	$inst->{'IPSecOUTStatus'}='VALID';
	$inst->{'Link'}=$context->{Interface};
	IKEPktComment('Complete ' . $inst->{'SaID2'});
	LogPrint('INF1',$inst,'',"complete");
	return '';
    }
}

# COMMIT bit 
sub IKENotifySend
{
    my($inst,$msgType,$context)=@_;
    my($ans,$prof,$phase,$inst1,$hexString,$hashDataA,$encInfo,$pkt);

    $phase=$inst->{'Phase'};

    # 
    if( !($prof=IKEGetSAProf($inst->{($phase eq 1)?'SaID1':'SaID2'})) ){
	IKEPktComment('NG:NoProfile');
	LogPrint('ERR',$phase,'',"IKENotifySend SAID[%s] is not registed, do not continue.\n",$inst->{($phase eq 1)?'SaID1':'SaID2'});
	return 'NG';
    }

    # IKE
    $ans=IKENewPacket();

    # ISAKMP
    if($phase eq 1){
	IKEAddPayload($ans,'Hdr_ISAKMP',{'InitiatorCookie'=>$inst->{'InitiatorCookie'},
					 'ResponderCookie'=>$inst->{'ResponderCookie'},
					 'EFlag'=>$IKEEncryptMode,
					 'ExchangeType'=>$prof->{'ETYPE'}});
	# 
	IKEAddPayload($ans,'Pld_ISAKMP_HASH',{'HashData'=>$hashDataA});
    
	# Nontify
	IKEAddPayload($ans,'Pld_ISAKMP_N_IPsec_ANY',
		      {'PayloadLength'=>16,'ProtocolID'=>$IKEDoi{'TI_PROTO_ISAKMP'},
		       'SPIsize'=>0,'NotifyMessageType'=>$IKEDoi{$msgType}});
		      
	# 
	$hexString= '00000000' . HXConvSTToHex($ans->{'NO'}->[0]);
	$inst1=$inst;
    }
    else{
	IKEAddPayload($ans,'Hdr_ISAKMP',{'InitiatorCookie'=>$inst->{'InitiatorCookie'},
					 'ResponderCookie'=>$inst->{'ResponderCookie'},
					 'EFlag'=>$IKEEncryptMode,
					 'ExchangeType'=>$prof->{'ETYPE'},'MessageID'=>$inst->{'MessageID'}});
	
	# 
	IKEAddPayload($ans,'Pld_ISAKMP_HASH',{'HashData'=>$hashDataA});
    
	# Nontify
	IKEAddPayload($ans,'Pld_ISAKMP_N_IPsec_ANY',
		      {'PayloadLength'=>16,'ProtocolID'=>$IKEDoi{'TI_PROTO_IPSEC_ESP'},
		       'SPIsize'=>4,'SPI'=>sprintf("%08x",$inst->{'INSPI'}),
		       'NotifyMessageType'=>$IKEDoi{$msgType}});
	
	# 
	$hexString= sprintf("%08x",$inst->{'MessageID'}) . HXConvSTToHex($ans->{'NO'}->[0]);
	$inst1=IKFindScenInstFromID($inst->{'Phase1ID'});
    }
    
    # 
    $ans->{'HA'}->[0]->{'HashData'}=IKEPrf($inst1->{'PRFHashAlgo'},$inst1->{'SKEYID_a'},$hexString);

    if( IKEComposePayload($ans) ){return 'NG';}
#    PrintVal($ans);

    # 
    $encInfo=IKESetupEncInfo($inst,'send');
    
    # 
    $pkt=IKESend($inst1->{'TnEtherAddr'},$inst1->{'TnIPAddr'},$inst1->{'NutEtherAddr'},
		 $inst1->{'NutIPAddr'}, $ans,'IKE_SEND',$context->{Interface},$encInfo);
    $inst->{'SendPktInfo'}=$ans;
    
    # IV
    $inst->{'IV'}=IKEGetIVEC($pkt);

    # 
    $inst->{'PH2Msg4'}=IKAddCapture('',$pkt,($phase eq 1)?'PH1':'PH2','',$inst->{'ID'},4);
    return '';
}

#============================================
# Informational Exchange
#============================================
sub IKEInfoExchRecv {
    my($inst,$event,$context)=@_;
    my($comment,$proto);

    MsgPrint('DBG',"<=IKEInfoExchRecv\n");

    # 
    if( GFv("IK,NO",$event->{Data}->{Frame}) ){
	$comment=$IKENotifyName{GFv("IK,NO,NotifyMessageType",$event->{Data}->{Frame})};
    }
    elsif( GFv("IK,DL",$event->{Data}->{Frame}) ){
	# 
	if($inst){IKEDisableScenarioInstanceRelation($inst,'','INFO Destroy playload');}
	$proto=GFv("IK,DL,ProtocolID",$event->{Data}->{Frame});
	$comment='Delete ' . ($proto eq $IKEDoi{'TI_PROTO_ISAKMP'}?'ISAKMP':
			      ($proto eq $IKEDoi{'TI_PROTO_IPSEC_ESP'}?'IPREC(ESP)':'IPREC(AH)'));
    }
    else{
	$comment='Unknown payload';
    }
    IKAddCapture($event->{'Data'}->{'Frame'},$event->{'Data'}->{'Packet'},'INF',$comment,$inst->{'ID'},'n');

    MsgPrint('DBG',"=>IKEInfoExchRecv\n");
    return ;
}
sub IKEInfoExchSend {
    my($inst,$type,$msg,$context)=@_;
    my($inst1,$ans,$hexString,$hexSt,$payload,$messageID,$pkt,$prof,$encInfo);

    MsgPrint('DBG',"<=IKEInfoExchSend\n");
    if( !ref($inst) ){if( !($inst=IKFindScenInstFromID($inst)) ){MsgPrint('WAR',"Handler not exit\n");return;}}
    
    if( !($messageID=$inst->{'MessageID'}) ){
	$messageID=hex(IKEMkMsgID());
    }
    if( !($inst1=IKEGetPhase1Inst($inst)) ){
	MsgPrint('WAR',"PH1 Handler not exit\n");return;	
    }

    # 
    $ans=IKENewPacket();
    
    # ISAKMP
    IKEAddPayload($ans,'Hdr_ISAKMP',{'InitiatorCookie'=>$inst->{'InitiatorCookie'},
				     'ResponderCookie'=>$inst->{'ResponderCookie'},
				     'EFlag'=>$IKEEncryptMode,
				     'ExchangeType'=>$IKEDoi{'TI_ETYPE_INFO'},'MessageID'=>$messageID});

    # 
    IKEAddPayload($ans,'Pld_ISAKMP_HASH',{'HashData'=>''});

    if($type eq 'NO'){
	# Notification
	if($inst->{Phase} eq 1){
	    if($msg eq 'INITIAL_CONTACT'){
		# 
	    }
	    IKEAddPayload($ans,'Pld_ISAKMP_N_IPsec_ANY',{'ProtocolID'=>$IKEDoi{'TI_PROTO_ISAKMP'},
					       'SPIsize'=>0,'NotifyMessageType'=>$IKEDoi{$msg}});
	}
	else{
	    IKEAddPayload($ans,'Pld_ISAKMP_N_IPsec_ANY',{'ProtocolID'=>$IKEDoi{'TI_PROTO_IPSEC_ESP'},
					       'SPIsize'=>4,'SPI'=>sprintf("%08x",$inst->{'OUTSPI'}),
					       'NotifyMessageType'=>$IKEDoi{$msg}});
	}
    }
    else{
	if($inst->{Phase} eq 1){
	    # Delete
	    IKEAddPayload($ans,'Pld_ISAKMP_D',{'ProtocolID'=>$IKEDoi{'TI_PROTO_ISAKMP'},'SPIsize'=>16,'NumberOfSPI'=>1,
					       'SPI'=>$inst->{'InitiatorCookie'} . $inst->{'ResponderCookie'}});
	    $msg='Delete ISAKMP SA';
	}
	else{
	    $prof=IKEGetSAProf($inst->{'SaID2'});
	    # Delete
	    IKEAddPayload($ans,'Pld_ISAKMP_D',{'ProtocolID'=>$IKEDoi{'TI_PROTO_IPSEC_ESP'},'NumberOfSPI'=>1,
					       'SPIsize'=>4,'SPI'=>sprintf("%08x",$inst->{'INSPI'})});
	    $msg='Delete IPSec SA';
	}
    }

    # NextPayload
    IKEComposePayloadIN($ans);

    # 
    $hexString=sprintf("%08x",$messageID);
    if($type eq 'NO'){
	$hexSt=HXConvIKEStToHexSt($ans->{'NO'}->[0]);
	$hexString .= PktHexEncode($hexSt);
    }
    else{
	$hexSt=HXConvIKEStToHexSt($ans->{'DL'}->[0]);
	$hexString .= PktHexEncode($hexSt);
    }

    $ans->{'HA'}->[0]->{'HashData'}=IKEPrf($inst1->{'PRFHashAlgo'},$inst1->{'SKEYID_a'},$hexString);
    MsgPrint('DBG4',"Algo=[%s]\n",$inst1->{'PRFHashAlgo'});
    MsgPrint('DBG4',"Key=[%s]\n",$inst1->{'SKEYID_a'});
    MsgPrint('DBG4',"Data=[%s]\n",$hexString);
    MsgPrint('DBG4',"Digest=[%s]\n",$ans->{'HA'}->[0]->{'HashData'});
    # 
    if( IKEComposePayload($ans) ){ return $inst->{'ST'}; }

    # 
    $encInfo=IKESetupEncInfo($inst,'send','INFO');

    # 
    $pkt=IKESend($inst1->{'TnEtherAddr'},$inst1->{'TnIPAddr'},$inst1->{'NutEtherAddr'},
		 $inst1->{'NutIPAddr'}, $ans,'IKE_SEND',$context->{'Interface'},$encInfo);
    $inst->{'SendPktInfo'}=$ans;
    
    # 
    IKAddCapture('',$pkt,'INF',$msg,$inst->{'ID'},0);
    MsgPrint('DBG',"=>IKEInfoExchSend\n");
    return '';
}

#============================================
# 
#============================================
sub IKEUnknownRecv {
    my($inst,$event,$context)=@_;
    my($icookie,$rcookie,$frame,$comment,$proto,$etype);

    # 
    $icookie=GFv("IK,HD,InitiatorCookie",$event->{Data}->{Frame});
    $rcookie=GFv("IK,HD,ResponderCookie",$event->{Data}->{Frame});

    # 
    if(!$inst){
	$inst=IKEFindDisableScenarioInstanceFromCookie($icookie,$rcookie);
    }
    
    # 
    $etype=GFv("IK,HD,ExchangeType",$event->{Data}->{Frame});
    
    if($etype eq $IKEDoi{'TI_ETYPE_INFO'}){
	IKEInfoExchRecv($inst,$event,$context);
	return;
    }
    elsif($etype eq $IKEDoi{'TI_ETYPE_AGG'} || $etype eq $IKEDoi{'TI_ETYPE_QUICK'}){
	$frame='PH' . ($etype eq $IKEDoi{'TI_ETYPE_AGG'}?1:2);
	$comment=$inst ? 'Already deleted SA' : 'Unknown Cookie message';
    }
    else{
	$frame='PH1';
	$comment="Unsupport Exchange Type[$IKEEtypeName{$etype}]";
    }
    IKAddCapture($event->{'Data'}->{'Frame'},$event->{'Data'}->{'Packet'},$frame,$comment,$inst->{'ID'},0);
}

# 
sub IKEGeneralRecv {
    my($inst,$event,$context)=@_;
    my($icookie,$rcookie,$frame,$comment,$proto,$etype);

    # 
    $icookie=GFv("IK,HD,InitiatorCookie",$event->{Data}->{Frame});
    $rcookie=GFv("IK,HD,ResponderCookie",$event->{Data}->{Frame});

    # 
    if(!$inst){
	$inst=IKEFindDisableScenarioInstanceFromCookie($icookie,$rcookie);
    }
    
    # 
    $etype=GFv("IK,HD,ExchangeType",$event->{Data}->{Frame});
    # 
    if($etype eq $IKEDoi{'TI_ETYPE_INFO'}){
	if( GFv("IK,NO",$event->{Data}->{Frame}) ){
	    $comment=$IKENotifyName{GFv("IK,NO,NotifyMessageType",$event->{Data}->{Frame})};
	}
	elsif( GFv("IK,DL",$event->{Data}->{Frame}) ){
	    $proto=GFv("IK,DL,ProtocolID",$event->{Data}->{Frame});
	    $comment='Delete ' . ($proto eq $IKEDoi{'TI_PROTO_ISAKMP'}?'ISAKMP':
				  ($proto eq $IKEDoi{'TI_PROTO_IPSEC_ESP'}?'IPREC(ESP)':'IPREC(AH)'));
	}
	else{
	    $comment='Unknown payload';
	}
	$frame='INF';
    }
    elsif($etype eq $IKEDoi{'TI_ETYPE_AGG'} || $etype eq $IKEDoi{'TI_ETYPE_QUICK'}){
	$frame='PH' . ($etype eq $IKEDoi{'TI_ETYPE_AGG'}?1:2);
	$comment=$inst ? '' : 'Unknown Cookie message';
    }
    else{
	$frame='PH1';
	$comment="Unsupport Exchange Type[$IKEEtypeName{$etype}]";
    }
    # 
    IKAddCapture($event->{'Data'}->{'Frame'},$event->{'Data'}->{'Packet'},$frame,$comment,$inst->{'ID'},0);
}

#============================================
# 
#============================================
# 
sub IKPh1AgInMsg2RecvCheck {
    my($event,$inst,$context)=@_;
    my($req,$pkt,$intf);
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $intf=$context->{'Interface'};

#  
    if( $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'} ne $inst->{'NutIPAddr'} || 
        $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'} ne $inst->{'TnIPAddr'} || 
        $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'} ne IKGetMacAddress($inst->{'NutEtherAddr'},$intf) || 
        $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'} ne IKGetMacAddress($inst->{'TnEtherAddr'},$intf) ){
	LogPrint('ERR',$inst,'',"Address field mismatch");
	return 'Address NG';
    } 

#  SA, KE, Nr
    if( IKEIsExistPayload($req,{'SA'=>1,'KE'=>1,'NC'=>1}) ){
	LogPrint('ERR',$inst,'',"SA or KE or Nr payload empty");
	return 'payload NG';
    }
#  SA
    if( IKEIsExistPayload($req,{'SA,PR'=>1,'SA,PR,TR'=>1}) ){
	LogPrint('ERR',$inst,'',"Proposal palyload exist many");
	return 'many proposal';
    }
#  Ph1 1st Msg 
    return ;
}

# 
sub IKPh1AgRpMsg3RecvCheck {
    my($event,$inst,$context)=@_;
    my($req,$pkt,$intf);
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $intf=$context->{'Interface'};

#  
    if( $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'} ne $inst->{'NutIPAddr'} || 
        $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'} ne $inst->{'TnIPAddr'} || 
        $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'} ne IKGetMacAddress($inst->{'NutEtherAddr'},$intf) || 
        $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'} ne IKGetMacAddress($inst->{'TnEtherAddr'},$intf) ){
	LogPrint('ERR',$inst,'',"Address field mismatch");
	return 'Address NG';
    } 
    return;
}

# 
sub IKPh2QkRpMsg1RecvCheck {
    my($event,$inst,$context)=@_;
    my($req,$pkt,$intf);
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $intf=$context->{'Interface'};

    # 
    if(ref($inst->{'Phase1ID'}) ne 'HASH'){$inst=IKFindScenInstFromID($inst->{'Phase1ID'});}

#  
    if( $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'} ne $inst->{'NutIPAddr'} || 
        $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'} ne $inst->{'TnIPAddr'} || 
        $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'} ne IKGetMacAddress($inst->{'NutEtherAddr'},$intf) || 
        $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'} ne IKGetMacAddress($inst->{'TnEtherAddr'},$intf) ){
	LogPrint('ERR',$inst,'',"Address field mismatch");
	return 'Address NG';
    } 
    return;
}
# 
sub IKPh2QkInMsg2RecvCheck {
    my($event,$inst,$context)=@_;
    my($req,$pkt,$intf);
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $intf=$context->{'Interface'};

    # 
    if(ref($inst->{'Phase1ID'}) ne 'HASH'){$inst=IKFindScenInstFromID($inst->{'Phase1ID'});}

#  
    if( $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'} ne $inst->{'NutIPAddr'} || 
        $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'} ne $inst->{'TnIPAddr'} || 
        $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'} ne IKGetMacAddress($inst->{'NutEtherAddr'},$intf) || 
        $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'} ne IKGetMacAddress($inst->{'TnEtherAddr'},$intf) ){
	LogPrint('ERR',$inst,'',"Address field mismatch");
	return 'Address NG';
    } 

#  SA, Nr, IDci, IDcr
    if( IKEIsExistPayload($req,{'SA'=>1,'NC'=>1,'ID'=>2} ) ){
	LogPrint('ERR',$inst,'',"SA or Nr or ID payload empty");
	return 'payload NG';
    }
#  SPI
    if(GFv('IK,SA,PR#0,SPIsize',$req) ne 4){
	LogPrint('ERR',$inst,'',"SPI size not 32bit");
	return 'SPI size NG';
    }
#  SA
    if( IKEIsExistPayload($req,{'SA,PR'=>1,'SA,PR,TR'=>1}) ){
	LogPrint('ERR',$inst,'',"Proposal palyload exist many");
	return 'many proposal';
    }
#  Ph1 1st Msg 
    return;
}

# 
sub IKPh2QkRpMsg3RecvCheck {
    my($event,$inst,$context)=@_;
    my($req,$pkt,$intf);
    $req=$event->{'Data'}->{'Frame'};
    $pkt=$event->{'Data'}->{'Packet'};
    $intf=$context->{'Interface'};

    # 
    if(ref($inst->{'Phase1ID'}) ne 'HASH'){$inst=IKFindScenInstFromID($inst->{'Phase1ID'});}

#  
    if( $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'} ne $inst->{'NutIPAddr'} || 
        $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'} ne $inst->{'TnIPAddr'} || 
        $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'} ne IKGetMacAddress($inst->{'NutEtherAddr'},$intf) || 
        $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'} ne IKGetMacAddress($inst->{'TnEtherAddr'},$intf) ){
	LogPrint('ERR',$inst,'',"Address field mismatch");
	return 'Address NG';
    } 
    return;
}

#============================================
# 
#============================================
sub IKESetScenarioMode
{
    my($ph1Commit,$ph2Commit)=@_;
    $IKEPh1CommitMode=$ph1Commit;
    $IKEPh2CommitMode=$ph2Commit;
}

1
