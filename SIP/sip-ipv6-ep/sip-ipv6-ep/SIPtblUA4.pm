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


#use strict;

#=================================
# 
#=================================
%CNT_CONF = (
	     'INITIALIZE'           => 'SIP',    #  BOOT | SIP
	     'FAILCONTINUE'         => 'ON',     #  ON | OFF
	     'SPECIFICATION'        => 'RFC',    #  RFC | IG
	     'ROUTER-PREFIX-ADDRESS'=> '',
	     'DNS-ADDRESS'          => '192.168.0.4',
	     'DNS-TTL'              => 30,
	     'UA-ADDRESS'           => '192.168.0.100',
	     'UA-USER'              => 'NUT',
	     'UA-HOSTNAME'          => 'under.test.com',
	     'UA-CONTACT-HOSTNAME'  => 'node.under.test.com',
	     'UA-PORT'              => (($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
	     'REG-ADDRESS'          => '192.168.0.1',
	     'REG-HOSTNAME'         => 'reg.under.test.com',
	     'PX1-ADDRESS'          => '192.168.0.1',
	     'PX1-HOSTNAME'         => 'ss.under.test.com',
	     'PUA-ADDRESS'          => '192.168.0.3',
	     'PUA-USER'             => 'UA1',
	     'PUA-HOSTNAME'         => 'atlanta.example.com',
	     'PUA-CONTACT-HOSTNAME' => 'client.atlanta.example.com',
	     'AUTH-USERNAME'        => 'NUT',
	     'AUTH-PASSWD'          => 'nutsip',
	     'AUTH-REALM-RG'        => 'reg.under.test.com', 
	     'AUTH-REALM-PX1'       => 'under.test.com', 
	     'AUTH-REALM-PX2'       => 'atlanta.example.com',
	     'AUTH-SUPPORT'         => 'T',
	     'AUTH-SUPPORT-AFTER-DIALOG'         => 'T',
	     'HOLD-MEDIA'           => 1,        
	     'TIMER-T1'             => 0.5,
	     'TIMER-T2'             => 4,
	     'TIMER-MAGIN'          => 0.2,
	     'MAX-FORWARDS'         => 70,
	     'EXPIRES'              => 3600,
	     'TIME-STAMP'           => 1000,
	     'PX2-ADDRESS'          => '192.168.0.2',
	     'PX2-HOSTNAME'         => 'ss1.atlanta.example.com',
	     'OT1-ADDRESS'          => '192.168.0.4',
	     'LOG-LEVEL'            => 'ERR,WAR',
	     'SIMULATE-Tagret'      => 'T',
	     'STATISTICS-OUTPUT'    => '',
	     'RULE-INFO-DETAIL'     => '',
);

#=================================
# 
#=================================
# 
%SIP_ScenarioModel = (
	     'Role'                 => 'IPv4 for UA',    #  Caller(
	     'Trapezoid'            => 'NO',  #  NO | ONE / TWO / MULTIPUL
	     'Regist'               => '',    #  Register T(required) | nil
);

#=================================
# 
#=================================

# 
#   
#   
#   
#                        SIP_TERM_GLOBAL(
#   
#                        
#   
#        
#        
#                

%SIPNodeTempl=
(
 'PX1'=>{'AD'=>'192.168.0.1','RFRAME'=>'SIP4toPROXY', 'SFRAME'=>'SIP4fromPROXY', 'ADNAME'=>'PSEUDO_SIP4_PROXY'},
 'PX2'=>{'AD'=>'192.168.0.2','RFRAME'=>'SIP4toPROXY2','SFRAME'=>'SIP4fromPROXY2','ADNAME'=>'PSEUDO_SIP4_PROXY2'},
 'UA1'=>{'AD'=>'192.168.0.3','RFRAME'=>'SIP4toTERM',  'SFRAME'=>'SIP4fromTERM',  'ADNAME'=>'PSEUDO_SIP4_TERM'},
 'UA2'=>{'AD'=>'192.168.0.4','RFRAME'=>'SIP4toTERM2', 'SFRAME'=>'SIP4fromTERM2', 'ADNAME'=>'PSEUDO_SIP4_TERM2'},
 'REG'=>{'AD'=>'192.168.0.4','RFRAME'=>'SIP4toREG',   'SFRAME'=>'SIP4fromREG',   'ADNAME'=>'PSEUDO_REGISTRA4'},
 'DNS'=>{'AD'=>'192.168.0.4','RFRAME'=>'SIP4toDNS',   'SFRAME'=>'SIP4fromDNS_A1', 'ADNAME'=>'PSEUDO_DNS4'},
 );

%SIPFrameTempl=
(
 'SIP4toPROXY'     =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'PX1'},
 'SIP4fromPROXY'   =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'PX1'},
 'SIP4toREG'       =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'REG'},
 'SIP4fromREG'     =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'REG'},
 'SIP4toTERM'      =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'UA1'},
 'SIP4fromTERM'    =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA1'},
 'SIP4toOTHER1'    =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'OH1'},
 'SIP4fromOTHER1'  =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'OH1'},
 'SIP4toPROXY2'    =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'PX2'},
 'SIP4fromPROXY2'  =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'PX2'},
 'SIP4toTERM2'     =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'UA2'},
 'SIP4fromTERM2'   =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA2'},
 'SIP4toDNS'       =>{'Module'=>'TAHI'},
 'SIP4fromDNS_A1'  =>{'Module'=>'TAHI'},
 'SIP4fromDNS_NONE'=>{'Module'=>'TAHI'},
 'SIP4fromDNS_SRV' =>{'Module'=>'TAHI'},
 'SIP4fromDNS_SOA'  =>{'Module'=>'TAHI'},
 'EchoRequest4FromServ'=>{'Module'=>'TAHI','Trans'=>'ICMP'},
 'EchoReply4ToServ'    =>{'Module'=>'TAHI','Trans'=>'ICMP'},
 'ICMP4ErrorFromPROXY'  =>{'Module'=>'TAHI','Trans'=>'ICMP'},
 'ICMP4ErrorFromOTHER1'  =>{'Module'=>'TAHI','Trans'=>'ICMP'},
 );

#=================================
# 
#=================================
sub SetupSIPParam {
    my($index)=@_;
    my($puaContactRedirect);
    my($key,$num)=SIPLoadMagic($index);

    $CNT_VIA_TRNS=sprintf("%s/%s/%s",($SIP_PL_TRNS eq "TLS")?"SIPS":"SIP",2.0,$SIP_PL_TRNS);

# 
# URI
    $CNT_TUA_CONTACT_URI=sprintf("%s:%s\@%s:%s",
  				 ($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},
				 $CNT_CONF{'UA-CONTACT-HOSTNAME'},$CNT_CONF{'UA-PORT'});
    $CNT_TUA_HOSTNAME=$CNT_CONF{'UA-CONTACT-HOSTNAME'};
    $CVA_TUA_O_VERSION="";
# header component at the end of Contact
    $CVA_TUA_CONTACT_HEADER = "";
# IP
    $CVA_TUA_IPADDRESS=$CNT_CONF{'UA-ADDRESS'};
    $CVA_TUA_URI=sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},$CNT_CONF{'UA-HOSTNAME'});
# 
    $CNT_TUA_PORT=$CNT_CONF{'UA-PORT'};
    $CNT_TUA_HOSTPORT=$CNT_TUA_HOSTNAME . ':' . $CNT_TUA_PORT;
    $CNT_PORT_DEFAULT_RTP='49172';
    $CNT_PORT_CHANGE_RTP='49172';
    
# 
# URI
    $CNT_PUA_CONTACT_URI=sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'PUA-CONTACT-HOSTNAME'});
    $CNT_PUA_PORT=(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
    $CNT_PUA_HOSTPORT=$CNT_CONF{'PUA-CONTACT-HOSTNAME'} . ':' . $CNT_PUA_PORT;


# IP
    $CVA_PUA_URI=sprintf('%s:%s@%s',($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'PUA-HOSTNAME'});
    $CVA_PUA_IPADDRESS=$CNT_CONF{'PUA-ADDRESS'};

# 
    $CNT_PX1_HOSTNAME=$CNT_CONF{'PX1-HOSTNAME'};
    $CNT_PX1_PORT=(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
    $CNT_PX1_HOSTPORT=$CNT_CONF{'PX1-HOSTNAME'} . ':' . $CNT_PX1_PORT;
    $CVA_PX1_IPADDRESS=$CNT_CONF{'PX1-ADDRESS'};

    $CNT_PX2_HOSTNAME=$CNT_CONF{'PX2-HOSTNAME'};
    $CNT_PX2_PORT=(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
    $CNT_PX2_HOSTPORT=$CNT_CONF{'PX2-HOSTNAME'} . ':' . $CNT_PX2_PORT;
    $CVA_PX2_IPADDRESS=$CNT_CONF{'PX2-ADDRESS'};

#    $CNT_PUA_SDP_FMT=0;
    $CNT_PUA_SDP_O_SESSION=time()+2208988800;
    $CNT_PUA_SDP_O_VERSION=$CNT_PUA_SDP_O_SESSION-1;

# 
    $CNT_RG_URI=$CNT_CONF{'REG-HOSTNAME'}.':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
# IP
    $CVA_RG_IPADDRESS=$CNT_CONF{'REG-ADDRESS'};
# 
    $CNT_RG_FRAME=($CVA_RG_IPADDRESS eq $CVA_PX1_IPADDRESS) ? 'SIP4toPROXY' : 'SIP4toREG';
    $SIPNodeTempl{'REG'}->{'RFRAME'}=$CNT_RG_FRAME;

# 
    $CVA_ROUTER_PREFIX=$CNT_CONF{'ROUTER-PREFIX-ADDRESS'};

# 
    $CNT_AUTH_NONCE ='"1cec4341ae6cbe5a359ea9c8e88df84f"';
    $CNT_AUTH_NONCE2='"84f1c1ae6cbe5ua9c8e88dfa3ecm3459"';
    $CNT_AUTH_NEXTNONCE_COUNTER=1;
    @CNT_AUTH_NEXTNONCE =($CNT_AUTH_NONCE                     ,'"1cec4341ae6cbe5a359ea9c8e88df841"',
			  '"1cec4341ae6cbe5a359ea9c8e88df842"','"1cec4341ae6cbe5a359ea9c8e88df843"',
			  '"1cec4341ae6cbe5a359ea9c8e88df844"','"1cec4341ae6cbe5a359ea9c8e88df845"');
    $CNT_AUTH_REALM_RG ="\"$CNT_CONF{'AUTH-REALM-RG'}\"";
    $CNT_AUTH_REALM ="\"$CNT_CONF{'AUTH-REALM-PX1'}\"";
    $CNT_AUTH_REALM2="\"$CNT_CONF{'AUTH-REALM-PX2'}\"";
    $CNT_AUTH_USRNAME="\"$CNT_CONF{'AUTH-USERNAME'}\"";
    $CNT_AUTH_PASSWD="$CNT_CONF{'AUTH-PASSWD'}";

# 
    $CNT_HOLD_MEDIA=$CNT_CONF{'HOLD-MEDIA'};
    
# 
# 
    $CVA_CALLID = '123' . $num . '@' . $key . '.example.com';
    $CVA_REMOTE_TAG=''; 
    $CVA_REMOTE_CSEQ_NUM='';
    $CVA_LOCAL_TAG = '100'. $num;
    $CVA_LOCAL_CSEQ_NUM=$num;
    
# 
# 
    $CVA_TUA_CURRENT_BRANCH;
# 
    @CVA_TUA_BRANCH_HISTORY;
# 
# PX1,PX2,*****,PUA
    @CVA_PUA_BRANCH_ALL;

# 
    $CVA_PUA_URI_REDIRECT=sprintf('%s:%s@%s',($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'}, 'chicago.example.com');
    $CVA_PUA_IPADDRESS_REDIRECT='3ffe:501:ffff:3::3';
    $puaContactRedirect=sprintf('%s:%s@%s',
					  ($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},'client.chicago.example.com');

    $CVA_PUA_URI_REDIRECT2=sprintf('%s:%s@chicago2.example.com',($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'});

# 

    @CNT_TUA_ONEPX_ROUTESET=sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip");
	@CNT_PUA_ONEPX_ROUTESET=sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip");
    @CNT_PUA_TWOPX_ROUTESET=(sprintf("%s:$CNT_PX2_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip"),
							 sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip"));
    @CNT_PUA_TWOPX_ROUTESET_REDIRECT=(sprintf("%s:ss2.chicago.example.com;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip"),
									  sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip"));


# 
    @CVA_UNSUPPORTED_LIST_REQUIRE=('nothingSupportsThis', 'nothingSupportsThisEither');
    @CVA_UNSUPPORTED_LIST_P_REQUIRE=("noProxiesSupportThis", "norDoAnyProxiesSupportThis");

# Via
    $CVA_COUNT_BRANCH=100+$num;
    SetupViaParam($CVA_COUNT_BRANCH);

# 
    $CVA_TIME_STAMP = $CNT_CONF{'TIME-STAMP'};

    $CVA_AUTH_SUPPORT_AFTER_DIALOG = $CNT_CONF{'AUTH-SUPPORT-AFTER-DIALOG'};

# 
     $CVA_DNS_IPADDRESS=$CNT_CONF{'DNS-ADDRESS'};
# AAAA 
    @SIP_AAAA_RECORD =
	( {'FQDN'=>"$CNT_CONF{'PX1-HOSTNAME'}.",            'IPV4'=>$CVA_PX1_IPADDRESS, '2RECORD'=>'YES'}, # 
	  {'FQDN'=>"$CNT_CONF{'PUA-HOSTNAME'}.",            'IPV4'=>$CVA_PUA_IPADDRESS},
	  {'FQDN'=>"$CNT_CONF{'PUA-HOSTNAME-FOR-1PX'}.",            'IPV4'=>$CVA_PUA_IPADDRESS},  ## 2006.8.31 sawada add ##
	  {'FQDN'=>"$CNT_CONF{'PUA-CONTACT-HOSTNAME'}.",    'IPV4'=>$CVA_PUA_IPADDRESS},
	  {'FQDN'=>"$CNT_CONF{'PUA-CONTACT-HOSTNAME-FOR-1PX'}.",    'IPV4'=>$CVA_PUA_IPADDRESS},  ## 2006.8.1 sawada add ##
	  {'FQDN'=>"$puaContactRedirect.",                  'IPV4'=>$CVA_PUA_IPADDRESS_REDIRECT},
	  {'FQDN'=>"$CNT_CONF{'UA-HOSTNAME'}.",             'IPV4'=>''},
	  {'FQDN'=>"$CNT_CONF{'REG-HOSTNAME'}.",            'IPV4'=>$CVA_RG_IPADDRESS},
	  );
# 
    $SIP_OTHER_AAAA=$CNT_CONF{'OT1-ADDRESS'};
# DNS
    $SIP_DNS_ANSWER_MODE='AAAA1';
# DNS
    $SIP_DNS_TTL=$CNT_CONF{'DNS-TTL'};

    SIPSaveMagic($num);
}

# Via
sub SetupViaParam {
    my($num)=@_;

    if($CNT_VIA_INIT_SEED eq ''){$CNT_VIA_INIT_SEED=$num;}
    if($num eq ''){$CNT_VIA_INIT_SEED++;$num=$CNT_VIA_INIT_SEED;}

# 
    $CVA_PUA_BRANCH_HISTORY=sprintf("z9hG4bKPUA%s",$num);
    $CVA_PX1_BRANCH_HISTORY=sprintf("z9hG4bKPONE%s",$num);
    $CVA_PX2_BRANCH_HISTORY=sprintf("z9hG4bKPTWO%s",$num);

# 
    @CNT_TWOPX_SEND_VIAS_REDIRECT= ("$CNT_PX1_HOSTPORT;branch=$CVA_PX1_BRANCH_HISTORY",
               sprintf("ss2.chicago.example.com:%s;branch=$CVA_PX2_BRANCH_HISTORY;received=$CVA_PX2_IPADDRESS",($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			   sprintf("client.chicago.example.com:%s;branch=$CVA_PUA_BRANCH_HISTORY;received=$CVA_PUA_IPADDRESS_REDIRECT",(($SIP_PL_TRNS eq "TLS")?"5061":"5060")));
# 
    @CNT_NOPX_SEND_VIAS = ("$CNT_PUA_HOSTPORT;branch=$CVA_PUA_BRANCH_HISTORY");
    @CNT_ONEPX_SEND_VIAS= ("$CNT_PX1_HOSTPORT;branch=$CVA_PX1_BRANCH_HISTORY",
			   "$CNT_PUA_HOSTPORT;branch=$CVA_PUA_BRANCH_HISTORY;received=$CVA_PUA_IPADDRESS");

    @CNT_TWOPX_SEND_VIAS= ("$CNT_PX1_HOSTPORT;branch=$CVA_PX1_BRANCH_HISTORY",
                           "$CNT_PX2_HOSTPORT;branch=$CVA_PX2_BRANCH_HISTORY;received=$CVA_PX2_IPADDRESS",
			   "$CNT_PUA_HOSTPORT;branch=$CVA_PUA_BRANCH_HISTORY;received=$CVA_PUA_IPADDRESS");

# 
    @CVA_PUA_BRANCH_ALL=("$CVA_PX1_BRANCH_HISTORY",
                         "$CVA_PX2_BRANCH_HISTORY",
                         "$CVA_PUA_BRANCH_HISTORY",
                         'z9hG4bK2dummy1',
                         'z9hG4bK2dummy2',
                         'z9hG4bK2dummy3',
                         'z9hG4bK2dummy4');

}

# Nonce 
sub SIP_UPDATENonce {
    $CNT_AUTH_NONCE=$CNT_AUTH_NEXTNONCE[$CNT_AUTH_NEXTNONCE_COUNTER];
    $CNT_AUTH_NEXTNONCE_COUNTER++;
    if($#CNT_AUTH_NEXTNONCE<=$CNT_AUTH_NEXTNONCE_COUNTER){$CNT_AUTH_NEXTNONCE_COUNTER=0;}
}

%CONTEXT_VARS = 
    ('VALUE'=>['CNT_AUTH_NEXTNONCE_COUNTER',
	       'CNT_AUTH_NONCE',
	       'CNT_AUTH_NONCE2',
	       'CNT_AUTH_PASSWD',
	       'CNT_AUTH_REALM',
	       'CNT_AUTH_REALM2',
	       'CNT_AUTH_REALM_RG',
	       'CNT_AUTH_USRNAME',
	       'SIP_DNS_ANSWER_MODE',
	       'SIP_DNS_TTL',
	       'CNT_HOLD_MEDIA',
	       'SIP_OTHER_AAAA',
	       'CNT_PORT_CHANGE_RTP',
	       'CNT_PORT_DEFAULT_RTP',
	       'CNT_PUA_CONTACT_URI',
	       'CNT_PUA_HOSTPORT',
	       'CNT_PUA_PORT',
	       'CNT_PUA_SDP_O_SESSION',
	       'CNT_PUA_SDP_O_VERSION',
	       'CNT_PX1_HOSTNAME',
	       'CNT_PX1_HOSTPORT',
	       'CNT_PX1_PORT',
	       'CNT_PX2_HOSTNAME',
	       'CNT_PX2_HOSTPORT',
	       'CNT_PX2_PORT',
	       'CNT_RG_FRAME',
	       'CNT_RG_URI',
	       'CNT_TUA_CONTACT_URI',
	       'CNT_TUA_HOSTNAME',
	       'CNT_TUA_HOSTPORT',
	       'CNT_TUA_PORT',
	       'CNT_VIA_INIT_SEED',
	       'CVA_AUTH_SUPPORT_AFTER_DIALOG',
	       'CVA_CALLID',
	       'CVA_COUNT_BRANCH',
	       'CVA_DNS_IPADDRESS',
	       'CVA_LOCAL_CSEQ_NUM',
	       'CVA_LOCAL_TAG',
	       'CVA_PUA_BRANCH_HISTORY',
	       'CVA_PUA_IPADDRESS',
	       'CVA_PUA_IPADDRESS_REDIRECT',
	       'CVA_PUA_URI',
	       'CVA_PUA_URI_REDIRECT',
	       'CVA_PUA_URI_REDIRECT2',
	       'CVA_PX1_BRANCH_HISTORY',
	       'CVA_PX1_IPADDRESS',
	       'CVA_PX2_BRANCH_HISTORY',
	       'CVA_PX2_IPADDRESS',
	       'CVA_REMOTE_CSEQ_NUM',
	       'CVA_REMOTE_TAG',
	       'CVA_RG_IPADDRESS',
	       'CVA_ROUTER_PREFIX',
	       'CVA_TIME_STAMP',
	       'CVA_TUA_CONTACT_HEADER',
	       'CVA_TUA_CURRENT_BRANCH',
	       'CVA_TUA_IPADDRESS',
	       'CVA_TUA_O_VERSION',
	       'CVA_TUA_URI'],
     'ARRAY'=>['CNT_AUTH_NEXTNONCE',
	       'CNT_NOPX_SEND_VIAS',
	       'CNT_ONEPX_SEND_VIAS',
	       'CNT_PUA_ONEPX_ROUTESET',
	       'CNT_PUA_TWOPX_ROUTESET',
	       'CNT_PUA_TWOPX_ROUTESET_REDIRECT',
	       'CNT_TUA_ONEPX_ROUTESET',
	       'CNT_TWOPX_SEND_VIAS',
	       'CNT_TWOPX_SEND_VIAS_REDIRECT',
	       'CVA_PUA_BRANCH_ALL',
	       'CVA_TUA_BRANCH_HISTORY',
	       'CVA_UNSUPPORTED_LIST_P_REQUIRE',
	       'CVA_UNSUPPORTED_LIST_REQUIRE'],
     );


# 
sub SIPStoreContextValue {
    my(%context,$name,$dup);
    foreach $name (@{$CONTEXT_VARS{'VALUE'}}){
	$context{$name}=$$name;
    }
    foreach $name (@{$CONTEXT_VARS{'ARRAY'}}){
	$dup=[];
	@$dup=@$name;
	$context{$name}=$dup;
    }
    return \%context;
}
# 
sub SIPLoadContextValue {
    my($context)=@_;
    my($name);
    foreach $name (@{$CONTEXT_VARS{'VALUE'}}){
	$$name=$context->{$name};
    }
    foreach $name (@{$CONTEXT_VARS{'ARRAY'}}){
	@$name=@{$context->{$name}};
    }
}

1
#    $CNT_VIA_TRNS=sprintf("%s/%s/%s",($SIP_PL_TRNS eq "TLS")?"SIPS":"SIP",2.0,$SIP_PL_TRNS);
