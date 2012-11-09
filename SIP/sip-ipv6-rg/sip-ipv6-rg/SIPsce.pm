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
# 09/11/13 12:51:29
#   PX
#  
#  
#      SIPfromUA11toREG,SIPfromUA12toREG,SIPfromREGtoUA11,SIPfromREGtoUA12
#      SIP_Setup_Reg_Info(
#      SIP_Setup_Reg_Info
#  
#      vSend 
#  
#      SD_Term_REGISTER 
#  
#      SIPfromUA11toREG,SIPfromUA12toREG,SIPfromREGtoUA11,SIPfromREGtoUA12
#  
#      
# 08/6/17 
#   GetSrcID:

#=================================
# 
#=================================

%RuleCategory = 
( 'Request'=>{'OD:'=>10},
  'Status'=>{'OD:'=>10},
  'Header'=>{             'OD:'=>30},
  'Body'=>{               'OD:'=>40},
  'Timer'=>{              'OD:'=>50},
  'UDP'=>{                'OD:'=>60},
  'TCP'=>{                'OD:'=>60},
  'TLS'=>{                'OD:'=>60},
  'RTP'=>{                'OD:'=>60},
  'SIP'=>{                'OD:'=>60},
  'Accept'=>{             'OD:'=>31},
  'Accept-Encoding'=>{    'OD:'=>31},
  'Accept-Language'=>{    'OD:'=>31},
  'Alert-Info'=>{         'OD:'=>31},
  'Allow'=>{              'OD:'=>31},
  'Authentication-Info'=>{'OD:'=>31},
  'Authorization'=>{      'OD:'=>31},
  'Call-ID'=>{            'OD:'=>31},
  'Call-Info'=>{          'OD:'=>31},
  'Contact'=>{            'OD:'=>31},
  'Content-Disposition'=>{'OD:'=>32},
  'Content-Encoding'=>{   'OD:'=>32},
  'Content-Language'=>{   'OD:'=>32},
  'Content-Length'=>{     'OD:'=>35},
  'Content-Type'=>{       'OD:'=>32},
  'CSeq'=>{               'OD:'=>31},
  'Date'=>{               'OD:'=>31},
  'Error-Info'=>{         'OD:'=>31},
  'Expires'=>{            'OD:'=>31},
  'Session-Expires'=>{    'OD:'=>31},
  'From'=>{               'OD:'=>31},
  'In-Reply-To'=>{        'OD:'=>31},
  'Max-Forwards'=>{       'OD:'=>31},
  'MIME-Version'=>{       'OD:'=>31},
  'Min-Expires'=>{        'OD:'=>31},
  'Min-SE'=>{             'OD:'=>31},
  'Organization'=>{       'OD:'=>31},
  'Priority'=>{           'OD:'=>31},
  'Proxy-Authenticate'=>{ 'OD:'=>31},
  'Proxy-Authorization'=>{'OD:'=>31},
  'Proxy-Require'=>{      'OD:'=>31},
  'Record-Route'=>{       'OD:'=>31},
  'Reply-To'=>{           'OD:'=>31},
  'Require'=>{            'OD:'=>31},
  'Retry-After'=>{        'OD:'=>31},
  'Route'=>{              'OD:'=>31},
  'Server'=>{             'OD:'=>31},
  'Subject'=>{            'OD:'=>31},
  'Supported'=>{          'OD:'=>31},
  'Timestamp'=>{          'OD:'=>31},
  'To'=>{                 'OD:'=>31},
  'Unsupported'=>{        'OD:'=>31},
  'Unsupported'=>{        'OD:'=>31},
  'User-Agent'=>{         'OD:'=>31},
  'Via'=>{                'OD:'=>31},
  'Warning'=>{            'OD:'=>31},
  'WWW-Authenticate'=>{   'OD:'=>31},
  'Privacy'=> {           'OD:'=>31},	# RFC3323
  'P-Preferred-Identity'=>{'OD:'=>31},	# RFC3325
  'P-Asserted-Identity'=>{'OD:'=>31},	# RFC3325
  'RSeq'=>{               'OD:'=>31},	# RFC3262
  'RAck'=>{               'OD:'=>31},	# RFC3262
  'Other'=>{'OD:'=>32},
  'a='=>{                 'OD:'=>41},
  'c='=>{                 'OD:'=>41},
  'm='=>{                 'OD:'=>41},
  'o='=>{                 'OD:'=>41},
  's='=>{                 'OD:'=>41},
  't='=>{                 'OD:'=>41},
  'v='=>{                 'OD:'=>41});

#=================================
# Config.txt
#=================================
## 2006.2.7 sawada  ['MT'=>'sip:]  =>  ['MT'=>'(?:sip|sips):] ##

%NEWCFGtoOLDCFG=
(
 'target'=>{
     'uri'=>{'NM'=>'REG-HOSTNAME','MT'=>'(?:sip|sips):(\S+)','AS'=>'uri.hostname'},
     'prefix'=>{'NM'=>'ROUTER-PREFIX-ADDRESS', 'ND'=>{'PX'=>'RT','UA'=>'RT','NM'=>'PREFIX'}},
     'address'=>{'NM'=>'UA-ADDRESS','ND'=>{'PX'=>'PX1','UA'=>'UA11','NM'=>'AD'}}},

 'target.user1'=>{
     'aor-uri'=>[{'NM'=>'UA-USER','MT'=>'(?:sip|sips):(\S+)@\S+','AS'=>'aor.user'},{'NM'=>'UA-HOSTNAME','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'aor.hostname'}],
     'address'=>{'NM'=>'UA-ADDRESS','ND'=>{'PX'=>'UA11','NM'=>'AD'}},
     'contact-uri'=>{'NM'=>'UA-CONTACT-HOSTNAME','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'contact.hostname'},
     'authorization_user'=>'AUTH-USERNAME','authorization_password'=>'AUTH-PASSWD',
     'authorization_realm'=>'AUTH-REALM-PX',},
 'target.user2'=>{
     'aor-uri'=>[{'NM'=>'UA-USER2','MT'=>'(?:sip|sips):(\S+)@\S+','AS'=>'aor.user'},{'NM'=>'UA-HOSTNAME2','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'aor.hostname'}],
     'address'=>{'NM'=>'UA-ADDRESS2','ND'=>{'PX'=>'UA12','NM'=>'AD'}},
     'contact-uri'=>{'NM'=>'UA-CONTACT-HOSTNAME2','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'contact.hostname'},
     'authorization_user'=>'AUTH-USERNAME2','authorization_password'=>'AUTH-PASSWD2',
     'authorization_realm'=>'AUTH-REALM-PX2',},

 'target.user3'=>{
     'aor-uri'=>[{'NM'=>'UA-USER3','MT'=>'(?:sip|sips):(\S+)@\S+','AS'=>'aor.user'},{'NM'=>'UA-HOSTNAME3','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'aor.hostname'}],
     'address'=>{'NM'=>'UA-ADDRESS3','ND'=>{'PX'=>'UA13','NM'=>'AD'}},
     'contact-uri'=>{'NM'=>'UA-CONTACT-HOSTNAME3','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'contact.hostname'},
     'authorization_user'=>'AUTH-USERNAME3','authorization_password'=>'AUTH-PASSWD3',
     'authorization_realm'=>'AUTH-REALM-PX3',},
 'target.user4'=>{
     'aor-uri'=>[{'NM'=>'UA-USER4','MT'=>'(?:sip|sips):(\S+)@\S+','AS'=>'aor.user'},{'NM'=>'UA-HOSTNAME4','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'aor.hostname'}],
     'address'=>{'NM'=>'UA-ADDRESS4','ND'=>{'PX'=>'UA14','NM'=>'AD'}},
     'contact-uri'=>{'NM'=>'UA-CONTACT-HOSTNAME4','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'contact.hostname'},
     'authorization_user'=>'AUTH-USERNAME4','authorization_password'=>'AUTH-PASSWD4',
     'authorization_realm'=>'AUTH-REALM-PX4',},

 'proxy'=>{
     'uri'=>{'NM'=>'PX1-HOSTNAME','MT'=>'(?:sip|sips):(\S+)','AS'=>'uri.hostname'},
     'address'=>{'NM'=>'PX1-ADDRESS','ND'=>{'PX'=>'PX2','UA'=>'PX1','NM'=>'AD'}}},
 'proxy.user1'=>{
     'aor-uri'=>[{'NM'=>'PUA-USER','MT'=>'(?:sip|sips):(\S+)@\S+','AS'=>'aor.user'},{'NM'=>'PUA-HOSTNAME','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'aor.hostname'}],
     'address'=>{'NM'=>'PUA2-ADDRESS','ND'=>{'PX'=>'UA21','UA'=>'UA12','NM'=>'AD'}},
     'contact-uri'=>{'NM'=>'PUA-CONTACT-HOSTNAME','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'contact.hostname'}},

 'proxy2'=>{
     'uri'=>{'NM'=>'PX3-HOSTNAME','MT'=>'(?:sip|sips):(\S+)','AS'=>'uri.hostname'},
     'address'=>{'NM'=>'PX3-ADDRESS','ND'=>{'PX'=>'PX3','UA'=>'PX2','NM'=>'AD'}}},
 'proxy2.user1'=>{
     'aor-uri'=>[{'NM'=>'PUA-USER','MT'=>'(?:sip|sips):(\S+)@\S+','AS'=>'aor.user'},{'NM'=>'PUA-HOSTNAME','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'aor.hostname'}],
     'address'=>{'NM'=>'PUA3-ADDRESS','ND'=>{'PX'=>'UA31','UA'=>'UA22','NM'=>'AD'}},
     'contact-uri'=>{'NM'=>'PUA-CONTACT-HOSTNAME','MT'=>'(?:sip|sips):\S+@(\S+)','AS'=>'contact.hostname'}},

 'registrar'=>{
     'uri'=>{'NM'=>'REG-HOSTNAME','MT'=>'(?:sip|sips):(\S+)'},
     'address'=>{'NM'=>'REG-ADDRESS','ND'=>{'UA'=>'PX1','NM'=>'AD'}},
     'authorization_realm'=>'AUTH-REALM-RG'},
 'dns'=>{
     'address'=>{'NM'=>'DNS-ADDRESS','ND'=>{'PX'=>'DNS','UA'=>'DNS','NM'=>'AD'}},},
 'others'=>{
     'specification'=>'SPECIFICATION',
     'UA-PORT'=>'UA-PORT',
     'TIMER-T1'=>'TIMER-T1',
     'TIMER-T2'=>'TIMER-T2',
     'TIMER-MAGIN'=>'TIMER-MAGIN',
     'HOLD-MEDIA'=>'HOLD-MEDIA',
     'MAX-FORWARDS'=>'MAX-FORWARDS',
     'EXPIRES'=>'EXPIRES',
     'TIME-STAMP'=>'TIME-STAMP',
     'DNS-TTL'=>'DNS-TTL',
     'use_authorization'=>{'NM'=>'AUTH-SUPPORT','EX'=>\q{(lc($v) eq 'yes' ? 'T': 'F')}},
     'use_dns'=>{'NM'=>'DNS-RESOLV','EX'=>\q{uc($v)}},
     'supported_extension'=>{'NM'=>'PX-SUPPORTED','EX'=>\q{(lc($v) eq 'none' ? '': $v)}},
     'expires'=>{'NM'=>'EXPIRES','EX'=>\q{(lc($v) ne 'default' ? $v : $CNT_CONF{'EXPIRES'})}},
     'LOG-LEVEL'=>'LOG-LEVEL',}
 );

# 
sub SIPConfigToOLDConfig {
    my(@keys,$key,@fields,$field,$v,$cnv,$ptn,%conf);

    @keys=keys(%CFGData);
    foreach $key (@keys){
	@fields=keys(%{$CFGData{$key}});
	foreach $field (@fields){
	    $v=$CFGData{$key}->{$field};
	    if( !($cnv=$NEWCFGtoOLDCFG{$key}->{$field}) ){next;}
	    if(ref($cnv) eq 'HASH'){
		SIPConfigToOLDConfigSetVal($cnv,$v,$CFGData{$key},\%conf);
	    }
	    elsif(ref($cnv) eq 'ARRAY'){
		foreach $ptn (@{$cnv}){
		    SIPConfigToOLDConfigSetVal($ptn,$v,$CFGData{$key},\%conf);
		}
	    }
	    else{
		$conf{$cnv}=$v;
	    }
	}
    }

    if ($NDTopology eq "UA-UA"){
	$conf{'PUA-USER'} = $conf{'UA-USER2'};
	$conf{'PUA-HOSTNAME'} = $conf{'UA-HOSTNAME2'};
	$conf{'PUA2-ADDRESS'} = $conf{'PUA-ADDRESS2'};
	$conf{'PUA-CONTACT-HOSTNAME'} = $conf{'UA-CONTACT-HOSTNAME2'};
    }

    # 
    %CNT_CONF=(%CNT_CONF,%conf);

    # @SIPrexDEBUG=('ERR','WAR','RULE','RULE2','PKT','ACT','HEX','SEQ');
    # HEX:
    @SIPrexDEBUG=split(',',$CNT_CONF{'LOG-LEVEL'});
# 
    $CVA_ROUTER_PREFIX=$CNT_CONF{'ROUTER-PREFIX-ADDRESS'};
    if( $SIM_Support_HiRes && !grep{$_ eq 'TIME'} @SIPrexDEBUG ){$SIM_Support_HiRes='';}
# 
    if($NDTopology eq 'UA-PX'){
	$SIPNodeTempl{'UA11'}->{'OTHER'}='PX1';
	$SIPNodeTempl{'PX1'}->{'OTHER'}='UA11';
    }
    if($NDTopology eq 'UA-UA'){
	$SIPNodeTempl{'UA11'}->{'OTHER'}='UA12';
	$SIPNodeTempl{'UA12'}->{'OTHER'}='UA11';
	$SIPNodeTempl{'UA13'}->{'OTHER'}='UA11';
	$SIPNodeTempl{'UA14'}->{'OTHER'}='UA11';
    }

##    SIPConfigDump();
}

sub SIPConfigDump {
    my($tag,@tags,$field,@fields);
    @tags=sort(keys(%CFGData));
    printf("----------------------------------------------\n");
    foreach $tag (@tags){
	@fields=sort(keys(%{$CFGData{$tag}}));
	printf("%-15.15s|%-23.23s|\n",$tag,' ');
	foreach $field (@fields){
	    printf("%-15.15s|%-23.23s|%-35.35s\n",' ',$field,$CFGData{$tag}->{$field});
	}
    }
    PrintVal(\%CNT_CONF);
}

# 
#   MT:
#   NM:
#   AS:
sub SIPConfigToOLDConfigSetVal{
    my($pattern,$v,$newCfg,$oldCfg)=@_;

    # 
    if($pattern->{'MT'}){
	$v =~ /$pattern->{'MT'}/;
	$v=$1;
    }
    elsif($pattern->{'EX'}){
	$v=eval ${$pattern->{'EX'}};
    }
#
    $oldCfg->{$pattern->{'NM'}}=$v;
#
    if($pattern->{'ND'}){
	$SIPNodeTempl{$pattern->{'ND'}->{$SIP_PL_TARGET}}->{$pattern->{'ND'}->{'NM'}}=$v;
    }
#
    if($pattern->{'AS'}){
	$newCfg->{$pattern->{'AS'}}=$v;
    }
}


#=================================
# Node
#=================================
%NDSipParamList=
(
 'UA11'=>{
     'DLOG.CallID'=>sub{my($key,$num)=SIPLoadMagic();return '11' . $num . '@' . $key . '.example.com';},
     'DLOG.LocalTag'=>sub{my($key,$num)=SIPLoadMagic();return '11'. $num;},
     'DLOG.RemoteTag'=>'',
     'DLOG.State'=>'',
     'DLOG.SecureFlag'=>'',
     'DLOG.LocalCSeqNum'=>'',
     'DLOG.RemoteCSeqNum'=>'',
     'DLOG.RouteSet'=>{'UA-PX'=>\q{['sip:'.NDCFG('uri.hostname','PX1'),'sip:'.NDCFG('uri.hostname','PX2').';lr']},
		  'UA-UA'=>\q{['sip:'.NDCFG('uri.hostname','PX1')]}},
     'TRNS.LocalRSeqNum'=>'',
     'TRNS.RemoteRSeqNum'=>'',
     'AuthPasswd'=>\q{NDCFG('authorization_password','UA11')},
     'AuthRealm'=>\q{'"'.NDCFG('authorization_realm','UA11').'"'},
     'AuthUserName'=>\q{'"'.NDCFG('authorization_user','UA11').'"'},
     'LocalContactURI'=>\q{NDCFG('contact-uri','UA11')},
     'HostPort'=>\q{NDCFG('contact.hostname','UA11').':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
     'SIPPort'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
     'SDP_o_Session'=>\q{time()+2208988800},
     'SDP_o_Version'=>\q{NINF('SDP_o_Session','UA11')-1},
     'DisplayName'=>\q{NDCFG('aor.user','UA11')},
     'IPaddr'=>\q{NDCFG('address','UA11')},
     'LocalAoRURI'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA11'),NDCFG('aor.hostname','UA11'))},
     'RemoteContactURI'=>'',
     'RemoteAoRURI'=>{'UA-PX'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA21'),NDCFG('aor.hostname','UA21'))},
	              'UA-UA'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA12'),NDCFG('aor.hostname','UA12'))}},
     'RTPPort'=>'49172',
     'RemotePeer'=> {'UA-PX'=>'UA21','UA-UA'=>'UA12'},
     'Forward'=>{'UA-PX'=>'PX2', 'UA-UA'=>'UA12'},
 },
 'UA12'=>{
     'DLOG.CallID'=>sub{my($key,$num)=SIPLoadMagic();return '12' . $num . '@' . $key . '.example.com';},
     'DLOG.LocalTag'=>sub{my($key,$num)=SIPLoadMagic();return '12'. $num;},
     'DLOG.RemoteTag'=>'',
     'DLOG.State'=>'',
     'DLOG.SecureFlag'=>'',
     'DLOG.LocalCSeqNum'=>'',
     'DLOG.RemoteCSeqNum'=>'',
     'DLOG.RouteSet'=>\q{['sip:'.NDCFG('uri.hostname','PX1')]},
     'TRNS.LocalRSeqNum'=>'',
     'TRNS.RemoteRSeqNum'=>'',
     'AuthPasswd'=>\q{NDCFG('authorization_password','UA12')},
     'AuthRealm'=>\q{'"'.NDCFG('authorization_realm','UA12').'"'},
     'AuthUserName'=>\q{'"'.NDCFG('authorization_user','UA12').'"'},
     'LocalContactURI'=>\q{NDCFG('contact-uri','UA12')},
     'HostPort'=>\q{NDCFG('contact.hostname','UA12').':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
     'SIPPort'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
     'IPaddr'=>\q{NDCFG('address','UA12')},
     'SDP_o_Session'=>\q{time()+2208988800},
     'SDP_o_Version'=>\q{NINF('SDP_o_Session','UA12')-1},
     'DisplayName'=>\q{NDCFG('aor.user','UA12')},
     'LocalAoRURI'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA12'),NDCFG('aor.hostname','UA12'))},
     'RemoteContactURI'=>'',
     'RemoteAoRURI'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA11'),NDCFG('aor.hostname','UA11'))},
     'RTPPort'=>'49172',
     'RemotePeer'=> {'UA-UA'=>'UA11'},
     'Forward'=>{'UA-UA'=>'UA11'},
 },
 'UA13'=>{
     'DLOG.CallID'=>sub{my($key,$num)=SIPLoadMagic();return '13' . $num . '@' . $key . '.example.com';},
     'DLOG.LocalTag'=>sub{my($key,$num)=SIPLoadMagic();return '13'. $num;},
     'DLOG.RemoteTag'=>'',
     'DLOG.State'=>'',
     'DLOG.SecureFlag'=>'',
     'DLOG.LocalCSeqNum'=>'',
     'DLOG.RemoteCSeqNum'=>'',
     'DLOG.RouteSet'=>\q{['sip:'.NDCFG('uri.hostname','PX1')]},
     'TRNS.LocalRSeqNum'=>'',
     'TRNS.RemoteRSeqNum'=>'',
     'AuthPasswd'=>\q{NDCFG('authorization_password','UA13')},
     'AuthRealm'=>\q{'"'.NDCFG('authorization_realm','UA13').'"'},
     'AuthUserName'=>\q{'"'.NDCFG('authorization_user','UA13').'"'},
     'LocalContactURI'=>\q{NDCFG('contact-uri','UA13')},
     'HostPort'=>\q{NDCFG('contact.hostname','UA13').':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
     'SIPPort'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
     'IPaddr'=>\q{NDCFG('address','UA13')},
     'SDP_o_Session'=>\q{time()+2208988800},
     'SDP_o_Version'=>\q{NINF('SDP_o_Session','UA13')-1},
     'DisplayName'=>\q{NDCFG('aor.user','UA13')},
     'LocalAoRURI'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA13'),NDCFG('aor.hostname','UA13'))},
     'RemoteContactURI'=>'',
     'RemoteAoRURI'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA11'),NDCFG('aor.hostname','UA11'))},
     'RTPPort'=>'49172',
     'RemotePeer'=> {'UA-UA'=>'UA11'},
     'Forward'=>{'UA-UA'=>'UA11'},
 },
 'UA14'=>{
     'DLOG.CallID'=>sub{my($key,$num)=SIPLoadMagic();return '14' . $num . '@' . $key . '.example.com';},
     'DLOG.LocalTag'=>sub{my($key,$num)=SIPLoadMagic();return '14'. $num;},
     'DLOG.RemoteTag'=>'',
     'DLOG.State'=>'',
     'DLOG.SecureFlag'=>'',
     'DLOG.LocalCSeqNum'=>'',
     'DLOG.RemoteCSeqNum'=>'',
     'DLOG.RouteSet'=>\q{['sip:'.NDCFG('uri.hostname','PX1')]},
     'TRNS.LocalRSeqNum'=>'',
     'TRNS.RemoteRSeqNum'=>'',
     'AuthPasswd'=>\q{NDCFG('authorization_password','UA14')},
     'AuthRealm'=>\q{'"'.NDCFG('authorization_realm','UA14').'"'},
     'AuthUserName'=>\q{'"'.NDCFG('authorization_user','UA14').'"'},
     'LocalContactURI'=>\q{NDCFG('contact-uri','UA14')},
     'HostPort'=>\q{NDCFG('contact.hostname','UA14').':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
     'SIPPort'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
     'IPaddr'=>\q{NDCFG('address','UA14')},
     'SDP_o_Session'=>\q{time()+2208988800},
     'SDP_o_Version'=>\q{NINF('SDP_o_Session','UA14')-1},
     'DisplayName'=>\q{NDCFG('aor.user','UA14')},
     'LocalAoRURI'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA14'),NDCFG('aor.hostname','UA14'))},
     'RemoteContactURI'=>'',
     'RemoteAoRURI'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA11'),NDCFG('aor.hostname','UA11'))},
     'RTPPort'=>'49172',
     'RemotePeer'=> {'UA-UA'=>'UA11'},
     'Forward'=>{'UA-UA'=>'UA11'},
 },
 'UA21'=>{
     'DLOG.CallID'=>sub{my($key,$num)=SIPLoadMagic();return '21' . $num . '@' . $key . '.example.com';},
     'DLOG.LocalTag'=>sub{my($key,$num)=SIPLoadMagic();return '21'. $num;},
     'DLOG.RemoteTag'=>'',
     'DLOG.State'=>'',
     'DLOG.SecureFlag'=>'',
     'DLOG.LocalCSeqNum'=>'',
     'DLOG.RemoteCSeqNum'=>'',
     'DLOG.RouteSet'=>\q{['sip:'.NDCFG('uri.hostname','PX2').';lr','sip:'.NDCFG('uri.hostname','PX1')]},
     'TRNS.LocalRSeqNum'=>'',
     'TRNS.RemoteRSeqNum'=>'',
     'AuthPasswd'=>\q{NDCFG('authorization_password','UA21')},
     'AuthRealm'=>\q{'"'.NDCFG('authorization_realm','UA21').'"'},
     'AuthUserName'=>\q{'"'.NDCFG('authorization_user','UA21').'"'},
     'LocalContactURI'=>\q{NDCFG('contact-uri','UA21')},
     'HostPort'=>\q{NDCFG('contact.hostname','UA21').':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
     'SIPPort'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
     'SDP_o_Session'=>\q{time()+2208988800},
     'SDP_o_Version'=>\q{NINF('SDP_o_Session','UA21')-1},
     'DisplayName'=>\q{NDCFG('aor.user','UA21')},
     'IPaddr'=>\q{NDCFG('address','UA21')},
     'LocalAoRURI'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA21'),NDCFG('aor.hostname','UA21'))},
     'RemoteContactURI'=>'',
     'RemoteAoRURI'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA21'),NDCFG('aor.hostname','UA21'))},
     'RTPPort'=>'49172',
     'RemotePeer'=> {'UA-PX'=>'UA11'},
     'Forward'=>{'UA-PX'=>'UA11'},
 },
 'PX1'=>{
     'DLOG.CallID'=>sub{my($key,$num)=SIPLoadMagic();return '123' . $num . '@' . $key . '.example.com';},
     'DLOG.LocalTag'=>sub{my($key,$num)=SIPLoadMagic();return '100'. $num;},
     'DLOG.RemoteTag'=>'',
     'DLOG.State'=>'',
     'DLOG.SecureFlag'=>'',
     'DLOG.LocalCSeqNum'=>'',
     'DLOG.RemoteCSeqNum'=>'',
     'TRNS.LocalRSeqNum'=>'',
     'TRNS.RemoteRSeqNum'=>'',
     'AuthRealm'=>\q{'"'.NDCFG('authorization_realm','PX1').'"'},
     'HostPort'=>\q{NDCFG('uri.hostname','PX1').':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
     'SIPPort'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
     'IPaddr'=>\q{NDCFG('address','PX1')},
     'Uri'=>\q{NDCFG('uri','PX1')},
     'RemotePeer'=> {'UA-PX'=>'UA21'},
     'LocalPeer'=> {'UA-PX'=>'UA11'},
     'Forward'=>'',
 },
 'PX2'=>{
     'DLOG.CallID'=>sub{my($key,$num)=SIPLoadMagic();return '123' . $num . '@' . $key . '.example.com';},
     'DLOG.LocalTag'=>sub{my($key,$num)=SIPLoadMagic();return '100'. $num;},
     'DLOG.RemoteTag'=>'',
     'DLOG.State'=>'',
     'DLOG.SecureFlag'=>'',
     'DLOG.LocalCSeqNum'=>'',
     'DLOG.RemoteCSeqNum'=>'',
     'TRNS.LocalRSeqNum'=>'',
     'TRNS.RemoteRSeqNum'=>'',
     'AuthRealm'=>\q{'"'.NDCFG('authorization_realm','PX2').'"'},
     'HostPort'=>\q{NDCFG('uri.hostname','PX2').':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
     'SIPPort'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
     'IPaddr'=>\q{NDCFG('address','PX2')},
     'Uri'=>\q{NDCFG('uri','PX2')},
     'RemotePeer'=> {'UA-PX'=>'UA11','UA-UA'=>'UA11'},
     'LocalPeer'=> {'UA-PX'=>'UA21','UA-UA'=>'UA12'},
     'Forward'=>{'UA-PX'=>'UA11', 'UA-UA'=>'UA12'},
 },
);

#=================================
# SIP
#=================================
$SIP_SIPKEY_FILE = "SIPKEY";
@NumberedKey = ('top','cat','dog','my','eye','www','sky','air','ice','hot','sea','sun','com','mon','lan','red',
		'UA','JP','all','bob','tom','txt','you','box','man','pub','pen','ink','foo','cal','top',
		'one','two','six','fax','tel','key','min','max','big','cup');
$CNT_TN_NAME = 'atlanta';

sub SIPLoadMagic {
    my($index)=@_;
    my($key,$num);
    # 
    if(!$index){
	open(IN,$SIP_SIPKEY_FILE);
	$index = <IN>;
	close(IN);
	$index++;
    }
    if($index eq 0){$index=1;}

    # 
    $num=$index;
    $key=@NumberedKey[$index % $#NumberedKey];
    return $key,$num;
}
sub SIPSaveMagic {
    my($index)=@_;
    #
    open(OUT, "> " . $SIP_SIPKEY_FILE);
    print OUT "$index\n";
    close(OUT);
}

#=================================
# SIP
#=================================
# addrType:IP6|IP4   protcol:UDP|TCP   judgmentRealMode:REAL|Nil
sub SIPInitializeScenario {
    my($otherNode,$ndpskip,$addrType,$protcol,$judgmentRealMode) = @_;
    my($ret);

    # Config.txt
    SIPConfigToOLDConfig();

    # 
    StartScenarioTime();

    # 
    SetupSIPParam();

    # 
    SipSeqDisplayInitilaize();

    # 
    $SIPJudgmentRealMode=$judgmentRealMode;

    # 
    SimulateTarget();

    # 
    SipPktCntlInitilize();

    # 
    SipRuleDBInitilaize();

    # SIP
    SipParseInitilaize();

    # 
    SetupNodeVCPP($CVA_PX1_IPADDRESS,$CVA_RG_IPADDRESS,$CVA_PUA_IPADDRESS,$CVA_DNS_IPADDRESS,$CVA_ROUTER_PREFIX,$otherNode);

    # 
    if($NDTopology eq 'UA-PX'){NDDefEnd(NDDefStart('PX1'));NDDefEnd(NDDefStart('UA21'));}
    if($NDTopology eq 'UA-UA'){NDDefEnd(NDDefStart('PX1'));NDDefEnd(NDDefStart('PX2'));}

    # AAAA
    SetFQDNRecord();
    
    # DNS
    if($SIP_PL_TARGET eq 'PX'){RegistDNS();}

    # 
    MakeFrameAttr();

    # NDP 
    if($ndpskip || $SIP_PL_IP eq 4){return;}

    # 
    $ret=SQ_RA_Router();
    if(NINF('IPaddr','Target') eq ''){
	LOG_Err("ND AutoConfiguration sequence is invalid. ($ret)\n");
	ExitScenario('Fatal');
    }

    # 
    if($SIP_ScenarioModel{'Regist'}){
	if(!SQ_Registra_Complete('','','autoDNS')){
	    LOG_Err("Initial REGISTER sequecence does not complete. Sequence can't continue\n");
	    ExitScenario('Fatal');
	}
	else{
	    MsgPrint('SEQ',"REGISTER complete.\n");
	}
    }

    return $ret;
}

# 
sub SIPScenarioModel {
    if($SIP_PL_TARGET eq 'PX'){
	my($target,$topology,$totaltime)=@_;
	$NDTaget=$target;
	if(grep{$topology eq $_} ('UA-UA','UA-PX','PX-PX')){
	    $NDTopology=$topology;
	}
	else{
	    $NDTopology='UA-PX';
	}
	# 
	$TotalScenarioTime = $totaltime if($totaltime);
    }
    if($SIP_PL_TARGET eq 'UA'){
	foreach (@_) {
	    if($_ =~ /^Caller$/i){$SIP_ScenarioModel{'Role'}='Caller';} #  Caller(
	    if($_ =~ /^Callee$/i){$SIP_ScenarioModel{'Role'}='Callee';}
	    if($_ =~ /^Register$/i){$SIP_ScenarioModel{'Role'}='Register';}
	    if($_ =~ /^2-Proxy$/i){$SIP_ScenarioModel{'Trapezoid'}='TWO';}
	    if($_ =~ /^1-Proxy$/i){$SIP_ScenarioModel{'Trapezoid'}='ONE';}
	    if($_ =~ /^Multi-Proxy$/i){$SIP_ScenarioModel{'Trapezoid'}='MULTIPUL';}
	    if($_ =~ /^NO-Proxy$/i){$SIP_ScenarioModel{'Trapezoid'}='NO';}
	    if($_ =~ /^Regist-Require$/i){$SIP_ScenarioModel{'Regist'}='T';}
	}
    }
}

sub GetSrcID {
    my($src,$files,$file);
    if($SIP_PL_IP eq 6 && $SIP_PL_TARGET eq 'UA'){
	$files=['SIPtblUA6.pm','SIPruleUA.pm','SIPruleIG.pm','SIPseqUA6.pm'];
    }
    if($SIP_PL_IP eq 6 && $SIP_PL_TARGET eq 'PX'){
	$files=['SIPtblPX6.pm','SIPrulePX.pm','SIPrulePX2.pm','SIPrulePX3.pm','SIPruleIG.pm','SIPruleTTC.pm','SIPseqPX6.pm']
    }
    if($SIP_PL_IP eq 4 && $SIP_PL_TARGET eq 'UA'){
	$files=['SIPtblUA4.pm','SIPruleUA.pm','SIPruleIG.pm','SIPseqUA4.pm']
    }
    if($SIP_PL_IP eq 4 && $SIP_PL_TARGET eq 'PX'){
	$files=['SIPtblPX4.pm','SIPrulePX.pm','SIPrulePX2.pm','SIPrulePX3.pm','SIPruleIG.pm','SIPruleTTC.pm','SIPseqPX4.pm'];
    }
    push(@$files,$SIP_SEQ_FILE,'SIPrule.pm','SIPrule2.pm','SIPcntl.pm');
    foreach $file (@$files){
	if(!$file || !(-e $file)){
	    return "No file[$file]";
	}
	open(SRC,$file);
	while (<SRC>){$src .= $_;}
	close(SRC);
    }
    unless($src){return 'No file'}
    return md5_hex($src);
}
#=================================
# SIP
#=================================
sub SIPFinishScenario {
    my($total,$error,$warning);

    WaitUntilKeyPress("Finish Scenario normally.\nPress Enter Key and Next test(or Check log).");

    # 
    SIPReviveJudgment();

    # TAHI
    RecoverTahiPackets();

    # 
    LogSIPPktInfo();

    # 
    LogHTMLOutput();

    # 
    ($total,$error,$warning)=SyntaxRuleResultStatistics();
    
    # Config
    LogConfigInfo();

    # 
    if( $error ){
	ExitToV6evalTool($V6evalTool::exitFail);
    }
    if( $warning ){
	ExitToV6evalTool($V6evalTool::exitWarn);
    }
    ExitToV6evalTool($V6evalTool::exitPass);
}

#=================================
# SIP
#=================================
sub JudgeResult {
    if($SIP_PL_TARGET eq 'PX'){
	my($result,$ok,$ng,$exitMode)=@_;
	if($result ne 'OK' && $result ne "recv"){
	    if($exitMode eq 'Warn'){LOG_Warn($ng);}
	    else{LOG_Err($ng);}
#	    NDNodeDump();
	    ExitScenario($exitMode?$exitMode:'Fail');
	}else{
	    if($ok){LOG_OK($ok);}
	}
    }
    if($SIP_PL_TARGET eq 'UA'){ # 
	my($ok,$ng,$exitMode)=@_;
	if($result ne "OK"){
	    if($exitMode eq 'Warn'){LOG_Warn($ng);}
	    else{LOG_Err($ng);}
	    ExitScenario($exitMode?$exitMode:'Fail');
	}else{
	    if($ok){LOG_OK($ok);}
	}
    }
}

sub JudgeResultNG {
    my($ok,$ng,$exitMode)=@_;
    if($result eq "OK"){  # 
	if($exitMode eq 'Warn'){LOG_Warn($ng);}
	else{LOG_Err($ng);}
	ExitScenario($exitMode?$exitMode:'Fail');
    }else{
	LOG_OK($ok);
    }
}
# 
#   $mode:
sub SIP_Judgment {
    my($rule,$mode,$pktinfo,$addrule,$delrule,$user,$evalTime)=@_;
    my($result,$ret,$item,$OK,%tmpContext);

    if( $pktinfo eq '' ){ $pktinfo=$SIPPktInfoLast; }

    # 
    $rule = RuleModify($rule,$addrule,$delrule);

    $evalTime=$evalTime||$SIPJudgmentRealMode;
    # 
    if($evalTime eq 'REAL'){
	# 
	SIPAddJudgmentContext($pktinfo,$rule,$mode,SIPStoreSyntaxRuleEvalContext());
	# 
	$tmpContext{'EVAL-TIME'}=$evalTime;
	# 
	$result=EvalRule($rule,$pktinfo,\%tmpContext);
    }
    # 
    else{
	if(IsLogLevel('INF')){LogHTML("</TD></TR><TR><TD>Judgment</TD><TD>");}

	# 
	$tmpContext{'USER'}=$user;

	# 
	$result=EvalRule($rule,$pktinfo,\%tmpContext);

	# 
	OutputTAHIResultMessage($pktinfo);
    }

    # 
    foreach $item (@$result){
	if($item->{'RE:'} eq ''){
	    if($mode eq 'STOP' || $CNT_CONF{'FAILCONTINUE'} ne 'ON'){
		MsgPrint('WAR',"Rule Judgment is NG, scenario stop.\n");
		LOG_Warn("Rule Judgment is NG, scenario stop.\n");
		ExitScenario('Fail');
	    }
	    else{
		MsgPrint('WAR',"Rule Judgment is NG, but continue...\n");
	    }
	}
	if($item->{'EX:'}){
	    MsgPrint('RULE',"Judgment after expression is[%s]\n",$item->{'EX:'});
	}
    }
    return $result;
}

#=================================
# 
#=================================
sub SipRuleDBInitilaize {
    # 
    MsgPrint('RULE',"Load SIP Common Rule DB.\n");
    RegistRuleSet(\@SIPCommonRules);
    MsgPrint('RULE',"Load SIP Common Rule2 DB.\n");
    RegistRuleSet(\@SIPCommonRules2);
    if($SIP_PL_TARGET eq 'UA'){
	MsgPrint('RULE',"Load UA Rule DB.\n");
	RegistRuleSet(\@SIPUARules);
    }

    if($CNT_CONF{SPECIFICATION} eq 'IG'){
	eval("use SIPruleIG");
	if(!$@){
	    MsgPrint('RULE',"Load Implement Gulide Rule DB.\n");
	    RegistRuleSet(\@ImplementGuidelineRules);
	}
	else{
	    MsgPrint('ERR',"Implement Gulide Rule can't loaded.\n");
	}
    }

    if($SIP_PL_TARGET eq 'PX'){
	MsgPrint('RULE',"Load Proxy Rule DB.\n");
	RegistRuleSet(\@SIPPXRules);
	MsgPrint('RULE',"Load Proxy Rule DB.\n");
	RegistRuleSet(\@SIPPXRules2);
	MsgPrint('RULE',"Load Proxy Rule DB.\n");
	RegistRuleSet(\@SIPPXRules3);
	MsgPrint('RULE',"Load Proxy Rule DB.\n");
	RegistRuleSet(\@SIPPXRules100rel);
	MsgPrint('RULE',"Load Proxy Rule DB.\n");
	RegistRuleSet(\@SIPPXRulesUPDATE);
	MsgPrint('RULE',"Load Proxy Rule DB.\n");
	RegistRuleSet(\@SIPPXRulesPrivacy);
    }

    if($CNT_CONF{SPECIFICATION} eq 'TTC'){
#	eval("use SIPruleIGTTC");
	eval("use SIPruleTTC");
	if(!$@){
	    MsgPrint('RULE',"Load TTC Rule DB.\n");
#	    RegistRuleSet(\@IGandTTCRules);
	    RegistRuleSet(\@SIPPXRulesTTC);
	}
	else{
	    MsgPrint('ERR',"TTC Rule can't loaded.\n");
	}
    }

    RuleStatistics();
}

#=================================
# 
#=================================
sub SipSeqDisplayInitilaize {
    if($SIP_PL_IP eq 6){
	%SIP_SEQ_ARROW_STR = (
			      'SIPfromUA11toREG'          => '|    |----|----|----|----|----|--->|    |',
			      'SIPfromREGtoUA11'          => '|    |<---|----|----|----|----|----|    |',
			      'SIPfromUA12toREG'          => '|    |    |----|----|----|----|--->|    |',
			      'SIPfromREGtoUA12'          => '|    |    |<---|----|----|----|----|    |',
			      'SIPfromUA13toREG'          => '|    |    |    |----|----|----|--->|    |',
			      'SIPfromREGtoUA13'          => '|    |    |    |<---|----|----|----|    |',
			      'SIPfromUA14toREG'          => '|    |    |    |    |----|----|--->|    |',
			      'SIPfromREGtoUA14'          => '|    |    |    |    |<---|----|----|    |',

			      'SIPtoUA11'                 => '|--->|    |    |    |    |    |    |    |',
			      'SIPtoUA12'                 => '|----|--->|    |    |    |    |    |    |',
			      'SIPtoUA13'                 => '|----|----|--->|    |    |    |    |    |',
			      'SIPtoUA14'                 => '|----|----|----|--->|    |    |    |    |',
			      'SIPtoPX2'                  => '|----|----|----|----|--->|    |    |    |',
			      'SIPtoPX3'                  => '|----|----|----|----|----|--->|    |    |',
			      'SIPtoPX4'                  => '|----|----|----|----|----|----|--->|    |',
			      'SIPfromUA11'               => '|<---|    |    |    |    |    |    |    |',
			      'SIPfromUA12'               => '|<---|----|    |    |    |    |    |    |',
			      'SIPfromUA13'               => '|<---|----|----|    |    |    |    |    |',
			      'SIPfromUA14'               => '|<---|----|----|----|    |    |    |    |',
			      'SIPfromPX2'                => '|<---|----|----|----|----|    |    |    |',
			      'SIPfromPX3'                => '|<---|----|----|----|----|----|    |    |',
			      'SIPfromPX4'                => '|<---|----|----|----|----|----|----|    |',
			      'SIPtoAny'                  => '|--->|----|--->|    |    |    |    |    |',
			      'SIPtoDNS'                  => '|----|----|----|----|----|----|----|--->|',
			      'SIPfromDNS'                => '|<---|----|----|----|----|----|----|----|',
			      'EchoRequestFromServ'       => '|<---|    |    |    |    |    |    |    |',
			      'EchoReplyToServ'           => '|--->|    |    |    |    |    |    |    |',
			      'ICMPErrorFromUA11'         => '|<---|    |    |    |    |    |    |    |',
			      'ICMPErrorFromUA12'         => '|<---|----|    |    |    |    |    |    |',
			      'ICMPErrortoUA11'           => '|--->|    |    |    |    |    |    |    |',
			      'ICMPErrortoUA12'           => '|----|--->|    |    |    |    |    |    |',
			      'Timer'                     => '|****|****|****|****|****|****|****|****|',
			      'PX1toUA11'                 => '|--->|    |    |    |    |    |    |    |',
			      'PX1toUA12'                 => '|----|--->|    |    |    |    |    |    |',
			      'PX1toUA13'                 => '|----|----|--->|    |    |    |    |    |',
			      'PX1toUA14'                 => '|----|----|----|--->|    |    |    |    |',
			      'PX1toPX2'                  => '|----|----|----|----|--->|    |    |    |',
			      'PX1toPX3'                  => '|----|----|----|----|----|--->|    |    |',
			      'UA11toPX1'                 => '|<---|    |    |    |    |    |    |    |',
			      'UA12toPX1'                 => '|<---|----|    |    |    |    |    |    |',
			      'UA13toPX1'                 => '|<---|----|----|    |    |    |    |    |',
			      'UA14toPX1'                 => '|<---|----|----|----|    |    |    |    |',
			      'PX2toPX1'                  => '|<---|----|----|----|----|    |    |    |',
			      'PX3toPX1'                  => '|<---|----|----|----|----|----|    |    |',
			      );
    }
    if($SIP_PL_IP eq 4){
	%SIP_SEQ_ARROW_STR = (
			      'SIP4toUA11'                => '|--->|    |    |    |    |    |    |    |',
			      'SIP4toUA12'                => '|----|--->|    |    |    |    |    |    |',
			      'SIP4toUA13'                => '|----|----|--->|    |    |    |    |    |',
			      'SIP4toUA14'                => '|----|----|----|--->|    |    |    |    |',
			      'SIP4toPX2'                 => '|----|----|----|----|--->|    |    |    |',
			      'SIP4toPX3'                 => '|----|----|----|----|----|--->|    |    |',
			      'SIP4toPX4'                 => '|----|----|----|----|----|----|--->|    |',
			      'SIP4fromUA11'              => '|<---|    |    |    |    |    |    |    |',
			      'SIP4fromUA12'              => '|<---|----|    |    |    |    |    |    |',
			      'SIP4fromUA13'              => '|<---|----|----|    |    |    |    |    |',
			      'SIP4fromUA14'              => '|<---|----|----|----|    |    |    |    |',
			      'SIP4fromPX2'               => '|<---|----|----|----|----|    |    |    |',
			      'SIP4fromPX3'               => '|<---|----|----|----|----|----|    |    |',
			      'SIP4fromPX4'               => '|<---|----|----|----|----|----|----|    |',
			      'SIP4toAny'                 => '|--->|----|--->|    |    |    |    |    |',
			      'SIP4toDNS'                 => '|<===|====|====|====|====|====|====|===>|',
			      'EchoRequest4FromServ'      => '|<---|    |    |    |    |    |    |    |',
			      'EchoReply4ToServ'          => '|--->|    |    |    |    |    |    |    |',
			      'ICMP4ErrorFromUA11'        => '|<---|    |    |    |    |    |    |    |',
			      'ICMP4ErrorFromUA12'        => '|<---|----|    |    |    |    |    |    |',
			      'Timer'                     => '|****|****|****|****|****|****|****|****|',
			      );
    }
    %SIP_FRM_COMMENT_STR = (
			    'Ns_TermLtoRouterG'         => '(L-G-L)',
			    'Ns_TermLtoRouterL'         => '(L-L-L)',
			    'Ns_TermGtoRouterMultiL'    => '(G-M-G)',
			    'Ns_TermGtoRouterMultiL_TL' => '(G-M-L)',
			    'Ns_TermLtoRouterMultiM'    => '(L-M-L)',
			    'Na_TermAtoRouterG'         => '(any-L-G)',
			    'Na_TermAtoRouterGOpt'      => '(any-L-G)',
			    'Na_RouterGToTermL'         => '(G-L-L)',
			    'Na_RouterLToTermG'         => '(L-G-G)',
			    'Na_RouterLToTermG_TL'      => '(L-G-L)',
			    'Na_RouterLToTermL'         => '(L-L-L)',
			    );
}


#============================================
# 
#============================================
# 
sub FVal {
    my($field,$pktinfo)=@_;
    if($pktinfo eq ''){$pktinfo=$SIPPktInfoLast;}
    my($vals,$count,$val);
    if(!ref($pktinfo)){
	if( !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    ($vals,$count,$val)=GetSIPField($field,$pktinfo);
#    PrintItem($val);
#    LOG_OK($val);
    return $val;
}
sub FVals {
    my($field,$pktinfo)=@_;
    if($pktinfo eq ''){$pktinfo=$SIPPktInfoLast;}
    my($vals,$count,$val);
    if(!ref($pktinfo)){
	if( !($pktinfo=GetSIPPktInfoIndex($pktinfo)) ){ return ''; }
    }
    ($vals,$count,$val)=GetSIPField($field,$pktinfo);
#    PrintVal($vals);
    return $vals;
}
sub IsStatusReceived {
    my($status)=@_;
    my($vals,$i,$msg);

    shift;
    $vals=FVsib('recv','','','RQ.Status-Line.code',@_);

    for($i=0;$i<=$#$vals;$i++){
	if(ref($status) eq 'ARRAY'){
	    for($i=0;$i<=$#$status;$i++){
		if($vals->[$i] && $vals->[$i]=~/^$status->[$i]/){return 'OK';}
	    }
	}
	else{
	    if($vals->[$i] && $vals->[$i]=~/^$status/){return 'OK';}
	}
    }
    return 'NG';
}
sub IsStatusNotReceived {
    return (IsStatusReceived(@_) eq 'OK')?'NG':'OK';
}
sub MsgDisplay {
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
    my($link)=@_;
    if($link eq ''){$link=$SIP_Link;}
    MsgDisplay("Proxy $SIP_ScenarioModel{'Trapezoid'} Mode.\n   Press Enter Key and Hang up.");
    if(<STDIN>){;}
    vCLEAR($link);
}
sub WaitUntilKeyPressAndTelephone {
    my($link)=@_;
    if($link eq ''){$link=$SIP_Link;}
    MsgDisplay("Proxy $SIP_ScenarioModel{'Trapezoid'} Mode.\n   Press Enter Key and telephone.");
    if(<STDIN>){;}
    vCLEAR($link);
}
sub WaitUntilKeyPress {
    my($msg,$link,$nonClear)=@_;
    if($link eq ''){$link=$SIP_Link;}
    MsgDisplay("Proxy $SIP_ScenarioModel{'Trapezoid'} Mode.\n   $msg");
    if(<STDIN>){;}
    if(!$nonClear){vCLEAR($link);}
}

#=================================
# 
#=================================
sub OpViaMachLines{
    my($via,$lines,$rule,$pktinfo,$context)=@_;
    my($val1,@val2,$viaLines,$val2,$count,$i);

    $viaLines=FVs('HD.Via.val.via.txt','',$pktinfo);
    $val1=FVs('HD.Via.val.via','',$pktinfo);
    @val2=map{SIPMakeStruct("SIP/2.0/$SIP_PL_TRNS " . $_,\%STVia)} @$via;
    ($val2,$count)=GetSIPField('via',\@val2);
#    PrintVal($via);
#    PrintVal($viaLines);
#    PrintVal(\@$val1);
#    PrintVal(\@$val2);
	
	@sipvia=map{"SIP/2.0/$SIP_PL_TRNS " . $_} @$via;

    $context->{'RESULT-DETAIL:'}={'TY:'=>'2op','OP:'=>'via','ARG1:'=>$viaLines,'ARG2:'=>\@sipvia};

    if($#$val1+1<$lines){return '';}
    if($#$val2+1<$lines){return '';}
    for($i=0;$i<$lines;$i++){
	if(!OpViaMachLine($val1->[$i],$val2->[$i],$i)){return '';}
    }
    return 'MATCH';
}

# sendby,branch=,received=
sub OpViaMachLine{
    my($val1,$val2,$receivedComp)=@_;
    my($param1,$param2,$count1,$count2,$i);

    # sent-protocol
	($param1,$count1)=GetSIPField('proto.trans',$val1);
	($param2,$count2)=GetSIPField('proto.trans',$val2);
	if($param1 ne $param2){return '';}

    # sendby
    if(!FFCompareHostPort('loose',$val1->{sendby},$val2->{sendby})){return '';}
    
    # branch=
    ($param1,$count1)=GetSIPField('param.branch=',$val1);
    ($param2,$count2)=GetSIPField('param.branch=',$val2);
    if($count1 ne $count2){return '';}
    for($i=0;$i<=$#$param1;$i++){
	if($param1->[$i] ne $param2->[$i]){return '';}
    }

    # received=
    if($receivedComp){
	($param1,$count1)=GetSIPField('param.received=',$val1);
	($param2,$count2)=GetSIPField('param.received=',$val2);
	if($count1 ne $count2){return '';}
	for($i=0;$i<=$#$param1;$i++){
	    if($param1->[$i] ne $param2->[$i]){return '';}
	}
    }

    return 'MATCH';
}
sub OpCalcAuthorizationResponse {
    my($tag,$msg,$mode,$rule,$pktinfo,$context)=@_;
    my($val,$authUsr,$authRealm,$authUri,$authNonce,$authNc,$authCnonce,$authQop,$field);
    if($tag eq 'Authorization'){
	$field='HD.Authorization.val.digest';
    }
    if($tag eq 'Proxy-Authorization'){
	$field='HD.Proxy-Authorization.val.digest';
    }
    shift @_; shift @_; shift @_;
    $val = FV("$field.username",@_);
    if( $val =~ /\"(.*)\"/ ){	$authUsr   = $1;}
    $val = FV("$field.realm",@_);
    if( $val =~ /\"(.*)\"/ ){   $authRealm = $1;}
    $val = FV("$field.uri",@_);
    if( $val =~ /\"(.*)\"/ ){   $authUri   = $1;}
    $val = FV("$field.nonce",@_);
    if( $val =~ /\"(.*)\"/ ){   $authNonce = $1;}

    if($mode eq 'noauth'){
	$val = CalcMD5Response_NoQop($authUsr,$authRealm,NINF('AuthPasswd'),$authUri,$msg,$authNonce);
	MsgPrint('RULE',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,NINF('AuthPasswd'),$authNonce,$msg,$val);
    }
    else{
	$val = FV("$field.cnonce",@_);
	if( $val =~ /\"(.*)\"/){    $authCnonce= $1;}
	$authNc    =FV("$field.nc",@_);
	$authQop   =FV("$field.qop",@_);

	$val = CalcMD5Response_NoQop($authUsr,$authRealm,NINF('AuthPasswd'),$authUri,$msg,$authNonce);
	MsgPrint('RULE',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,NINF('AuthPasswd'),$authNonce,$msg,$val);

	$val = CalcMD5Response($authUsr,$authRealm,NINF('AuthPasswd'),$authUri,$msg,$authNonce,
			   $authNc,$authCnonce,$authQop);
	MsgPrint('RULE',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Nc[%s] Cnonce[%s] Qop[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,NINF('AuthPasswd'),$authNonce,$authNc,$authCnonce,$authQop,$msg,$val);
    }
    return ("\"$val\"");
}
sub OpCalcAuthorizationResponse2 {
    my($tag,$msg,$field2,$fieldval2,$mode,$rule,$pktinfo,$context)=@_;
    my($val,$authUsr,$authRealm,$authUri,$authNonce,$authNc,$authCnonce,$authQop,$field);
    if($tag eq 'Authorization'){
	$field='HD.Authorization.val.digest';
    }
    if($tag eq 'Proxy-Authorization'){
	$field='HD.Proxy-Authorization.val.digest';
    }
    shift @_; shift @_;shift @_;shift @_;shift @_;
    $val = FVm("$field.username",$field2,$fieldval2,@_);
    if( $val =~ /\"(.*)\"/ ){	$authUsr   = $1;}
    $val = FVm("$field.realm",$field2,$fieldval2,@_);
    if( $val =~ /\"(.*)\"/ ){   $authRealm = $1;}
    $val = FVm("$field.uri",$field2,$fieldval2,@_);
    if( $val =~ /\"(.*)\"/ ){   $authUri   = $1;}
    $val = FVm("$field.nonce",$field2,$fieldval2,@_);
    if( $val =~ /\"(.*)\"/ ){   $authNonce = $1;}

    if($mode eq 'noauth'){
	$val = CalcMD5Response_NoQop($authUsr,$authRealm,NINF('AuthPasswd'),$authUri,$msg,$authNonce);
	MsgPrint('RULE',"Calc MD5 (no auth) Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,NINF('AuthPasswd'),$authNonce,$msg,$val);
    }else{
	$val = FVm("$field.cnonce",$field2,$fieldval2,@_);
        if( $val =~ /\"(.*)\"/){    $authCnonce= $1;}
	$authNc    =FVm("$field.nc",$field2,$fieldval2,@_);
	$authQop   =FVm("$field.qop",$field2,$fieldval2,@_);
	$val = CalcMD5Response($authUsr,$authRealm,NINF('AuthPasswd'),$authUri,$msg,$authNonce,
			       $authNc,$authCnonce,$authQop);
	MsgPrint('RULE',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Nc[%s] Cnonce[%s] Qop[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,NINF('AuthPasswd'),$authNonce,$authNc,$authCnonce,$authQop,$msg,$val);
    }
    return ("\"$val\"");
}

sub OpCalcAuthorizationResponse3 {
    my($tag,$msg,$authUsr,$authUri,$authNc,$authCnonce,$mode,$rule,$pktinfo,$context)=@_;
    my($val,$authRealm,$authNonce,$authQop,$field);
    if($tag eq 'Proxy-Authenticate'){
	$field='HD.Proxy-Authenticate.val.digest';
    }
    if($tag eq 'WWW-Authenticate'){
	$field='HD.WWW-Authenticate.val.digest';
    }
    shift @_; shift @_; shift @_;shift @_; shift @_; shift @_;shift @_;

    # 
    $val = FV("$field.realm",@_);
    if( $val =~ /\"(.*)\"/ ){   $authRealm = $1;}
    $val = FV("$field.nonce",@_);
    if( $val =~ /\"(.*)\"/ ){   $authNonce = $1;}
    if( $authUsr    =~ /\"(.*)\"/ ){ $authUsr = $1;}
    if( $authCnonce =~ /\"(.*)\"/ ){ $authCnonce = $1;}
    if($mode eq 'noauth'){
	$val = CalcMD5Response_NoQop($authUsr,$authRealm,NINF('AuthPasswd'),$authUri,$msg,$authNonce);
	MsgPrint('RULE',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,NINF('AuthPasswd'),$authNonce,$msg,$val);
    }
    else{
	$authQop = FV("$field.qop",@_);
	if( $authQop    =~ /\"(.*)\"/ ){ $authQop = $1;}
	$val = CalcMD5Response($authUsr,$authRealm,NINF('AuthPasswd'),$authUri,$msg,$authNonce,
			   $authNc,$authCnonce,$authQop);
	MsgPrint('RULE',"Calc MD5 Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Nc[%s] Cnonce[%s] Qop[%s] Msg[%s] => [%s]\n",
		 $authUsr,$authRealm,$authUri,NINF('AuthPasswd'),$authNonce,$authNc,$authCnonce,$authQop,$msg,$val);
    }
    return ("\"$val\"");
}

sub CalcAuthorizationInfoDigest {
    my($tag,$msg,$rule,$pktinfo,$context)=@_;
    my($val,$authUsr,$authRealm,$authUri,$authNonce,$authNc,$authCnonce,$authQop,$field);
    if($tag eq 'Authorization'){
	$field='HD.Authorization.val.digest';
    }
    if($tag eq 'Proxy-Authorization'){
	$field='HD.Proxy-Authorization.val.digest';
    }
    shift @_;shift @_;
    $val = FV("$field.username",@_);
    if( $val =~ /\"(.*)\"/ ){	$authUsr   = $1;}
    $val = FV("$field.realm",@_);
    if( $val =~ /\"(.*)\"/ ){   $authRealm = $1;}
    $val = FV("$field.uri",@_);
    if( $val =~ /\"(.*)\"/ ){   $authUri   = $1;}
    $val = FV("$field.nonce",@_);
    if( $val =~ /\"(.*)\"/ ){   $authNonce = $1;}
    $val = FV("$field.cnonce",@_);
    if( $val =~ /\"(.*)\"/){    $authCnonce= $1;}
    $authNc    =FV("$field.nc",@_);
    $authQop   =FV("$field.qop",@_);

    $val = CalcMD5Response($authUsr,$authRealm,NINF('AuthPasswd'),$authUri,$msg,$authNonce,
			   $authNc,$authCnonce,$authQop,'AUTH-INFO');
    MsgPrint('RULE',"Calc MD5(Auth-Info) Usr[%s] Realm[%s] Uri[%s] Passwd[%s] Nonce[%s] Nc[%s] Cnonce[%s] Qop[%s] Msg[%s] => [%s]\n",
	     $authUsr,$authRealm,$authUri,NINF('AuthPasswd'),$authNonce,$authNc,$authCnonce,$authQop,$msg,$val);

    return ("\"$val\"");
}

sub CalcMD5Response{
    my( $usr, $realm, $pw, $uri, $method, $nonce, $nc, $cnonce, $qop, $mode ) = @_;
    my( $a1,$a2,$ha1,$ha2,$conc,$res );
    
    # A1
    $a1 = join( ":", ($usr,$realm,$pw ) );
    $ha1 = md5_hex( $a1 );

    # A2
    if( $qop eq "auth" ){
	if($mode eq 'AUTH-INFO'){
	    $a2 = ":" . $uri;
	}
	else{
	    $a2 = join( ":", ($method,$uri) );
	}
    }
    else{
	MsgPrint('ERR',"Unsupported qop=[%s], so cannot calc digest.\n",$qop);
	$a2 = join( ":", ($method,$uri) );
    }
    $ha2 = md5_hex( $a2 );

    # 
    $conc = join( ":", ( $ha1, $nonce, $nc, $cnonce, $qop, $ha2 ) );
    $res = md5_hex( $conc );

    return( $res );
}

sub CalcMD5Response_NoQop{
    my( $usr, $realm, $pw, $uri, $method, $nonce, $mode ) = @_;
    my( $a1,$a2,$ha1,$ha2,$conc,$res );
    # A1
    $a1 = join( ":", ($usr,$realm,$pw ) );
    $ha1 = md5_hex( $a1 );

    $a2 = join( ":", ($method,$uri) );

    $ha2 = md5_hex( $a2 );

    # 
    $conc = join( ":", ( $ha1, $nonce, $ha2 ) );
    $res = md5_hex( $conc );

    return( $res );
}


## 2006.7.25 sawada add ##
sub SIPInitialAuthUse{
    my( $finish ) = @_;

    if($CNT_CONF{'AUTH-SUPPORT'} ne 'T'){
        if($finish eq 'Ignore'){
	    MsgDisplay("use_authorization doesn\'t equal \'yes\'.\nThis is \'Authentication\' TEST, you can\'t do. ");
            ExitToV6evalTool($V6evalTool::exitIgnore);
	}

	DeleteRuleFromAllRuleSet('^S.AUTH*');
	DeleteRuleFromAllRuleSet('^S.P-AUTH*');
    }
}
####
#sub SIPInitialAuthUse{
#    my( $finish ) = @_;
#
#    if($CNT_CONF{'AUTH-SUPPORT'} ne 'T'){
#        if($finish eq 'Ignore'){
#	    MsgDisplay("AUTH-SUPPORT doesn\'t equal \'T\'.\nThis is \'Authentication\' TEST, you can\'t do. ");
#            ExitToV6evalTool($V6evalTool::exitIgnore);
#	}
#
#	DeleteRuleFromAllRuleSet('^S.AUTH*');
#	DeleteRuleFromAllRuleSet('^S.P-AUTH*');
#    }
#}


##20070227 Inoue

sub SIPOpenPort{
	my ($port) = @_;
	my ($portID);

$portID = kPacket_StartRecv($SIP_PL_TRNS,'SIP',$SIP_PL_IP eq 6 ? 'INET6':'INET','',$port,$link);
}


sub SIP_SetUp_Reg_Info{
	my($node, $nextnode) = @_;

	$SIPFrameTempl{'SIPfromUA11toREG'}->{'DstAddr'}=$CFGData{'registrar'}->{'address'};
	$SIPFrameTempl{'SIPfromUA11toREG'}->{'DstPort'}=$CFGData{'registrar'}->{'port'}||5060;
	$SIPFrameTempl{'SIPfromREGtoUA11'}->{'SrcAddr'}=$CFGData{'registrar'}->{'address'};
	$SIPFrameTempl{'SIPfromUA12toREG'}->{'DstAddr'}=$CFGData{'registrar'}->{'address'};
	$SIPFrameTempl{'SIPfromUA12toREG'}->{'DstPort'}=$CFGData{'registrar'}->{'port'}||5060;
	$SIPFrameTempl{'SIPfromREGtoUA12'}->{'SrcAddr'}=$CFGData{'registrar'}->{'address'};

	$SIPFrameTempl{'SIPfromUA13toREG'}->{'DstAddr'}=$CFGData{'registrar'}->{'address'};
	$SIPFrameTempl{'SIPfromUA13toREG'}->{'DstPort'}=$CFGData{'registrar'}->{'port'}||5060;
	$SIPFrameTempl{'SIPfromREGtoUA13'}->{'SrcAddr'}=$CFGData{'registrar'}->{'address'};
	$SIPFrameTempl{'SIPfromUA14toREG'}->{'DstAddr'}=$CFGData{'registrar'}->{'address'};
	$SIPFrameTempl{'SIPfromUA14toREG'}->{'DstPort'}=$CFGData{'registrar'}->{'port'}||5060;
	$SIPFrameTempl{'SIPfromREGtoUA14'}->{'SrcAddr'}=$CFGData{'registrar'}->{'address'};

        $func = sub {
	    my ($result, $frame) = @_;
	    
	    WaitUntilKeyPress("Press Enter Key and start Registration.");
	    
	    # send REGISTER
	    LOG_OK("$node Send REGISTER");
	    SD_Term_REGISTER('','','','','SIPfrom'.$node.'toREG');
	    return 'NEXT';
	};
	NDReqAction($node, $func, 'START');


	$func = sub {
		my ($result, $frame) = @_;

		# 401
		JudgeResult($result, "Receive 401", "Can't receive 401");
		SIP_Judgment('SS.STATUS.REGISTER-401.TM');

		# send REGISTER with auth
		LOG_OK("send REGISTER with Authorization");
		SD_Term_REGISTER('ES.REQUEST.REGISTER-AUTH.TM','','','','SIPfrom'.$node.'toREG');
		return 'NEXT';
	};
	if( NDCFG('use_authorization') eq 'yes'){
	    NDStatusAction($node, $func, "401", ['D.WWW-Authenticate.NONCE', 'D.WWW-Authenticate.OPAQUE'],'','',
			   'SIPfromREGto'.$node);
	}

	$func = sub {
		my ($result, $frame) = @_;
		# 200
		JudgeResult($result,"Receive 200", "Can't receive 200");
		SIP_Judgment('SS.STATUS.REGISTER-200.TM');

		if($nextnode ne ''){
#			print "start UA12 \n";
#			print "next = $nextnode \n";
			SEQ_Start("$nextnode");
			return 'WAIT';
		}
		else{
			return 'NEXT';
		}
	};
	NDStatusAction($node, $func, "200",'','','','SIPfromREGto'.$node);
}

1


