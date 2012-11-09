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

require DiameterPkt;

# HSS 
sub HSSInitTBL {
    my ($nodeName, $template) = @_;
    my (%tbl);

    # 
    CtPkRegTempl(\@DIAMETERHexMap);


    # HSS 
    $tbl{'HSS'}={
	'address'  => CtTbCfg($nodeName, 'address'),
	'realm'    => CtTbCfg($nodeName, 'realm'),
	'hostname' => CtTbCfg($nodeName, 'hostname'),
	'vendorid' => CtTbCfg($nodeName, 'vendorid'),
	'product'  => CtTbCfg($nodeName, 'product'),
	'servername' => CtTbCfg($nodeName, 'servername'),
    };

    # Peer 
    $tbl{'Peer'};

    return \%tbl;
}

# User Data 
sub HSSGetUserData {
    my($public,$private,$appserver)=@_;
    unless($public){MsgPrint('ERR',"SAA : User data public user id empty\n");}
    unless($private){MsgPrint('ERR',"SAA : User data private user id empty\n");}
    $appserver = $appserver || 'sip:127.0.0.1:5065';
    return '<?xml version="1.0" encoding="UTF-8"?><IMSSubscription><PrivateID>'.$private.'</PrivateID><ServiceProfile><PublicIdentity><Identity>'.$public.'</Identity><Extension><IdentityType>0</IdentityType></Extension></PublicIdentity><InitialFilterCriteria><Priority>0</Priority><TriggerPoint><ConditionTypeCNF>1</ConditionTypeCNF><SPT><ConditionNegated>0</ConditionNegated><Group>0</Group><Method>PUBLISH</Method><Extension></Extension></SPT><SPT><ConditionNegated>0</ConditionNegated><Group>0</Group><Method>SUBSCRIBE</Method><Extension></Extension></SPT><SPT><ConditionNegated>0</ConditionNegated><Group>1</Group><SIPHeader><Header>Event</Header><Content>.*presence.*</Content></SIPHeader><Extension></Extension></SPT></TriggerPoint><ApplicationServer><ServerName>'.$appserver.'</ServerName><DefaultHandling>0</DefaultHandling></ApplicationServer></InitialFilterCriteria></ServiceProfile></IMSSubscription>';
    ;
}

# Diameter
sub HSSPktType {
    my($inet)=@_;
    return DiameterCommand(CtFlGet('INET,#DIAMETER,Command',$inet),CtFlGet('INET,#DIAMETER,Request',$inet));
}

# 
sub HSSAddPeer {
    my($node,$peer,$realm,$ip,$property)=@_;
    my($val);
    $val={'realm'=>$realm,'ip'=>$ip,%$property};
    CtTbSet('Peer,'.$peer,$val,$node);
##    PrintVal($node->{'TBL'});
}
sub HSSFindPeer {
    my($node,$peer,$realm)=@_;
    my($tbl);
    $tbl=$node->{'TBL'}->{'Peer'};
    return ($tbl->{$peer}->{'realm'} eq $realm) ? $tbl->{$peer} : '';
}

#============================================
# HSS 
#============================================
sub AddHSSAction {
    my($node,$func,$command,$conn,$id,$timeout,$name,$comment,$framename)=@_;
    return CtNDAddAct($node,$func,\&HSSMatchPacket,$command,$command,
		      {'Name'=>$name,'FrameName'=>$framename,'Comment'=>$comment},$conn,$id,$timeout);
}

#============================================
# HSS 
#============================================
sub HSSMatchPacket {
    my($msg,$connID,$ext,$node,$param)=@_;
    my($inetPkt,$conn,$type,$frameID,$comment);

    MsgPrint('PRMT',"HSSMatchPacket Enter\n");

    $conn=CtCnGet($connID);
    if($conn->{'ModuleName'} ne 'KOI'){return;}
    if($conn->{'local-port'} ne (CtTbCfg('HSS','port')||3868)){return '',$msg;}

    # 
    if(ref($msg)){
	$inetPkt=$msg;
    }
    else{
        my $timestamp = $ext->{'#TimeStamp#'};
	my $msgHex;
        # 
        $inetPkt = CtPkInetPacket($connID, '', 'in');
        # Diameter
	($msgHex) = CtPkDecode('DIAMETER',unpack('H*', $msg));
	# INET
        CtPkAddLayer3($inetPkt, $msgHex, $timestamp);
    }

    # Diameter
    unless(CtFlGet('INET,#DIAMETER',$inetPkt)){
	MsgPrint('PRMT',"HSSMatchPacket not Diameter NG\n");
	goto UNMATCH;
    }

    # Diameter
    $type=HSSPktType($inetPkt);

    if($param->{'PATTERN'}){
	my $msgtype=ref($param->{'PATTERN'})?$param->{'PATTERN'}:[$param->{'PATTERN'}];
	unless(grep{$type eq $_}(@$msgtype)){
	    MsgPrint('PRMT',"HSSMatchPacket Response [@$msgtype][%s] NG\n",$type);
	    goto UNMATCH;
	}
    }

    # 
    $frameID = CtNDGetFromAddr(CtFlGet('INET,#IPV4,SrcAddress',$inetPkt)||CtFlGet('INET,#IPV6,SrcAddress',$inetPkt));
    $frameID = $frameID ? ($frameID->{'ID'}.':'.$node->{'ID'}) : 'S-CSCFa1:'.$node->{'ID'};

    $comment=$param->{'ATTR'}->{'Comment'}?$param->{'ATTR'}->{'Comment'}:
	$DiameterCommandName{CtFlGet('INET,#DIAMETER,Command',$inetPkt)};
    HSSAddCapture($node,$inetPkt,'in',$connID,
		  $param->{'ATTR'}->{'Name'}?$param->{'ATTR'}->{'Name'}:$type,
		  $comment,$frameID);
    MsgPrint('PRMT',"HSSMatchPacket matched[%s] msg[%s]\n",$node->{'ID'},$type);
    return 'OK',$inetPkt,$node;

UNMATCH:
    MsgPrint('PRMT',"HSSMatchPacket unmatch[%s] msg[%s]\n",$node->{'ID'},$type);
    return '',$inetPkt;
}

#============================================
# HSS 
#============================================
sub HSSAddCapture {
    my($node,$inet,$dir,$connID,$name,$comment,$frameID)=@_;
    my($msg,$conn);

    $conn=CtCnGet($connID);

    # 
    $msg={'Type'=>'HSS','Direction'=>$dir,'Frame'=>$inet,'PktName'=>$name,
	  'FrameName'=>$frameID, 'Comment'=>$comment,'NodeID'=>$node->{'ID'}};
    push(@{$node->{'PKTS'}},$msg);
    $inet->{'#Direction#'} = $dir;

    # 
    $node->{$dir eq 'in' ? 'LASTRVPKT' : 'LASTSDPKT'}=$inet;
    $inet->{'#IDX#'}=$#{$node->{'PKTS'}};
    return $msg;
}

#=================================
# 
#=================================
sub CNNHssCreate {
    my($node,$proto,$property)=@_;
    my($inf,$params,$connID);

    $inf=CtTbAd('interface',$node);
    $params={'ModuleName'=>'KOI','interface'=>$inf,'protocol'=>$proto,
	     'transport'=>'TCP', 'direction'=>'client','Node'=>$node,%$property};
    $connID=CtCnMake($params);
    push(@{$node->{'CNL'}},$connID);
    $DIRRoot{'ACTCNN'}=$connID;
    return $connID;
}

# 
sub CtCnHSSRecvAny {
    my($node,$module)=@_;
    my($connID);
    if(CtTbCfg('DEBUG','simulate')){$module='SIM';}
    $connID=CtCnMake({'ModuleName'=>$module?$module:'KOI'});
    if($node){
		push(@{$node->{'CNL'}},$connID);
		$node->{'RECVCN'}=$connID;
		return $connID;
	}
}

sub HSSSend {
    my($connID,$inet,$name, $comment, $framename)=@_;
    my($msg,$conn,$node,$timestamp,$result,$sendConn);

    # 
    $conn=CtCnGet($connID);

    # 
    $node=$conn->{'Node'};

    # 
    ($msg)=CtPkEncode(CtFlGet('INET,#DIAMETER',$inet));
    if($result=CtIoSend($connID,pack('H*',$msg),\$sendConn,\$timestamp)){ return $result; }
    CtPkAddLayer3($inet,'',$timestamp);

    # 
    HSSAddCapture($node,$inet,'out',$conn, $name, $comment, $framename);

    return $result,$inet;
}

1
