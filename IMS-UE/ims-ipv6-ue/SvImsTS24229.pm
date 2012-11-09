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

#=================================================================
#
# TS24.229 IP Multimedia Call Control Protocol based on SIP and SDP.
#
# ToDo
#  - TS24.229
#
#=================================================================

# 
# 09/5/29  S.TS24229-5.1-24,S.TS24229-5.1-28 
# 09/5/29  S.TS24229-5.1-88, S.TS24229-5.1-90  
# 09/5/29  S.TS24229-5.1-169 
# 08/12/19 CtFlv

## DEF.VAR
@IMS_TS24229_SyntaxRules =
(

#########################
### Rule (SYNTAX_TS24.229) 
#########################

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-9',
    'CA' => 'Security',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'Security-Client,  Security-Verify header field and both a Require and Proxy-Require header fields with the value "sec-agree"  SHALL not be included in any SIP messages if SIP digest without TLS is used.',
    'NG' => 'Security-Client,  Security-Verify header field and both a Require and Proxy-Require header fields with the value "sec-agree"  SHALL not be included in any SIP messages if SIP digest without TLS is used.',
    'EX' => sub{
	my @req_options = split(/,/, CtFlv('HD,#Require,option',@_));  
	my @pxreq_options = split(/,/, CtFlv('HD,#Proxy-Require,option',@_));
        return !CtUtIsExistHdr('Security-Client', @_) && 
            !CtUtIsExistHdr('Security-Verify', @_) && 
            (!grep{$_ =~ /sec-agree/i}(@req_options)) && 
            (!grep{$_ =~ /sec-agree/i}(@pxreq_options));
    }
},

### Judgment rule for "From"
### (Basis for a determination : TS24229-5.1-22,TS24229-5.1-86,TS24229-5.1-167)
###                         (
### written by suyama (2007.12.7)
### suyama modified(2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-31',
    'CA' => 'From',
    'ET' => 'error',
    'OK' => \\'From header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'NG' => \\'From header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'EX' => sub {
	my ($node,$uri,$rcv_from);
	$node = CtTbPrm('CI,target,TARGET');               #

	$uri = CtTbl('UC,UserProfile,PublicUserIdentity',$node);
	$rcv_from = CtFlv('HD,#From,addr,uri,#TXT#', @_);

	return CtUtEq($rcv_from,$uri,@_);
    },
},

### Judgment rule for "To"
### (Basis for a determination : TS24229-5.1-23,TS24229-5.1-87,TS24229-5.1-168)
###                         (
### written by suyama (2007.12.7)
### suyama modified(2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-32',
    'CA' => 'To',
    'ET' => 'error',
    'OK' => \\'To header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'NG' => \\'To header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'EX' => sub {
	my ($node,$uri,$rcv_from);
	$node = CtTbPrm('CI,target,TARGET');               #

	$uri = CtTbl('UC,UserProfile,PublicUserIdentity',$node);
	$rcv_to = CtFlv('HD,#To,addr,uri,#TXT#', @_);

	CtUtEq($rcv_to,$uri,@_);
    },
},

### 
###               
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-33',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'Contact header field SHALL be set to SIP URIs(%s) containing the IP address or FQDN of the UE in the hostport parameter or FQDN.',
    'NG' => \\'Contact header field SHALL be set to SIP URIs(%s) containing the IP address or FQDN of the UE in the hostport parameter or FQDN.',
    'EX' =>  sub {
	my($uris,$addr);
	$addr=CtFlv('HD,#Contact,c-params,#ContactParam,addr,#TXT#',@_);

	# 
	unless($uris=CtFlv('HD,#Contact,c-params,#ContactParam,addr,#Name#',@_)){
	    CtRlSetEvalResult(@_[1],'1op','','',$addr);
	    return;
	}
	$uris =[$uris] unless(ref($uris));
	if( grep{$_ ne 'NameAddr' && $_ ne 'AddrSpec'}(@$uris) ){
	    CtRlSetEvalResult(@_[1],'1op','','',$addr);
	    return;
	}
	unless($uris=CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#Name#',@_)){
	    CtRlSetEvalResult(@_[1],'1op','','',$addr);
	    return;
	}
	$uris =[$uris] unless(ref($uris));
	if( grep{!$_ || $_ eq 'AbsoluteUri'}(@$uris) ){
	    CtRlSetEvalResult(@_[1],'1op','','',$addr);
	    return;
	}
	CtRlSetEvalResult(@_[1],'1op','','OK',$addr);
	return 'OK';
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-37',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The sent-by field of the Via header field shall include the IP address or FQDN(%s) of the UE and the port number(%s) where the UE expects to receive the response to this request when UDPis used.',
    'NG' => \\'The sent-by field of the Via header field shall include the IP address or FQDN(%s) of the UE and the port number(%s) where the UE expects to receive the response to this request when UDPis used.',
    'EX' => sub{
	my($host,$sentby,$result);

	# sentby
	#   
	#   
	unless( $sentby = CtFlv('HD,#Via,records,#ViaParm,sentby,host',@_) ){
	    return;
	}
	$sentby = [$sentby] unless(ref($sentby));

        # 
	my $via_port = CtFlv('HD,#Via,records,#ViaParm,sentby,port', @_);
	$via_port = [$via_port] unless(ref($via_port));

        # 
	$result = (grep{!$_}(@$sentby,@$via_port)) ?  '' : 'OK';

	CtRlSetEvalResult(@_[1],'2op','',$result,$sentby,$via_port);
	return  $result;
    }
},


### Judgment rule for 'expires'
###(Basis for a determination : TS24229-5.1-30,TS24229-5.1-91)
###                        (
### written by suyama (2007.12.12)
### suyama modified (2009.2.16)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-40',
    'CA' => 'expires',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) eq 'REGISTER') &&
                   (CtFlv('HD,#Contact,c-params,#STAR,star',@_) ||
                    CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_) ||
                    CtFlv('HD,#Expires,seconds',@_))
	    },
    'OK' => \\'An Expires header field or the expires parameter within the Contact header field(%s) SHALL be set to the value of 600 000 seconds.',
    'NG' => \\'An Expires header field or the expires parameter within the Contact header field(%s) SHALL be set to the value of 600 000 seconds.',
    'EX' => sub{
	my($contact,$expires);

	$contact = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_);
	$expires = CtFlv('HD,#Expires,seconds',@_);
	if ($contact eq ''){
	    if (CtUtEq($expires,'600000',@_)){
		return 'OK';
	    }
	}else{
	    if (CtUtEq($contact,'600000',@_)){
		return 'OK';
	    }
	}
	return '';
    }
},
    

### Judgment rule for "Request-URI"
### (Basis for a determination : TS24229-5.1-31,TS24229-5.1-92,TS24229-5.1-172)
###                         (
### written by suyama (2007.12.7)
### suyama modified (2009.2.16)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-41',
    'CA' => 'Request-URI',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => \\'Request-URI(%s) SHALL be set to the SIP URI(%s) of the domain name of the home network.',
    'NG' => \\'Request-URI(%s) SHALL be set to the SIP URI(%s) of the domain name of the home network.',
    'EX' => sub {
	my ($node,$rcv_uri,$uri);
	
	$node = CtTbPrm('CI,target,TARGET');
	$rcv_uri = CtFlv('SL,uri,host', CtRlCxPkt(@_));
	$uri = CtTbl('UC,UserProfile,HomeNetwork',$node);
	
	CtUtEq($rcv_uri,$uri,@_);
    },  
},

### Judgment rule for 'Supported'
###(Basis for a determination : TS24229-5.1-37,TS24229-5.1-95)
###                        (
### written by suyama (2007.12.11)
### suyama modified(2009.2.16)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-42',
    'CA' => 'Supported',
    'ET' => 'error',
    'OK' => 'The option tag "path" SHALL be contained in the Supported header field.',
    'NG' => 'The option tag "path" SHALL be contained in the Supported header field.',
    'EX' =>  sub {
	my($parameter,@field,$val);
	$parameter = CtFlv('HD,#Supported,option',@_);
	@field = split(/,/, $parameter);  
	
	foreach $val (@field){
	    
	    if ($val =~ /^path$/m){
		return 'OK';       
	    }  
	}
    },
},


### Judgment rule for 'expires time'
###(Basis for a determination : TS24229-5.1-52,TS24229-5.1-104)
### written by suyama (2009.2.19)
### 
###               
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-61',
    'CA' => 'expires',
    'ET' => 'error',
    'PR' => \q{(CtFlv('HD,#Contact,c-params,#STAR,star',@_) eq '')
	    || (CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_) ne '0')
	    || (CtFlv('HD,#Expires,seconds',@_) ne '0')},
    'OK' => 'Another REGISTER request populating the Expires header field or the expires parameter with an expiration timer of at least the value received in the Min-Expires header field of 423(Interval Too Brief) response SHALL be sent.',
    'NG' => 'Another REGISTER request populating the Expires header field or the expires parameter with an expiration timer of at least the value received in the Min-Expires header field of 423(Interval Too Brief) response SHALL be sent.',
    'EX' => sub{
	my($contact, $expires, $min_time);
	
	$contact = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_);
	$expires = CtFlv('HD,#Expires,seconds',@_);
	$min_time = CtFlv('HD,#Min-Expires,seconds',CtUtLastSndMsg());
	
	if ($contact eq ''){
	    if ($expires > $min_time || $expires == $min_time){
		return 'OK';
	    }}else{
		if ($contact > $min_time || $contact == $min_time){
		    return 'OK';
		}
	    }
	return '';
    }
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-17,TS24229-5.1-81,TS24229-5.1-162)
###                            (
### written by suyama (2007.12.12)
### suyama modified(2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-69',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'NG' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#UserName,username',@_), 
                      CtTbl('UC,UserProfile,PrivateUserIdentity',CtTbPrm('CI,target,TARGET')),@_)},
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-18)
### written by suyama (2007.12.12)
### suyama modified(2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-70',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value of the domain name of the home network(%s).',
    'NG' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value of the domain name of the home network(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Realm,realm',@_),CtTbl('UC,UserProfile,HomeNetwork','UEa1'),@_)}
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-19,TS24229-5.1-83,TS24229-5.1-164)
###                       (
### written by suyama (2007.12.12)
### suyama modified(2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-71',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'NG' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'EX' => sub{
	my($node,$uri,$sipuri);

	$node = CtTbPrm('CI,target,TARGET');               #
	$uri = CtTbl('UC,UserProfile,HomeNetwork',$node); 
	$sipuri = "sip:$uri";

        #
#        $iv_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,tag`$V eq uri`,uri',@_);
	$cl_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,uri',@_);

	if (CtUtEq($cl_uri,$sipuri,@_)){
	    return 'OK';
        }
    }
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-20)
### written by suyama (2007.12.13)
### suyama modified(2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-72',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => 'The nonce directive in Authorization header field SHALL be empty.',
    'NG' => 'The nonce directive in Authorization header field SHALL be empty.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Nonce,nonce',@_),'',@_)}
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-21)
### written by suyama (2007.12.13)
### suyama modified(2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-73',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => 'The response directive in the Authorization header field SHALL be empty.',
    'NG' => 'The response directive in the Authorization header field SHALL be empty.',
    'EX' => sub{
	my($iv_rs,$cl_rs);
	
	#response

	$iv_rs = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#AuthParam,tag`$V eq response`,auth',@_);
	$cl_rs = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',@_);

	if (($iv_rs eq "\"\"") && ($cl_rs eq '')){
	    return 'OK';
	}
    }
},


### Judgment rule for 'Contact'
###(Basis for a determination : TS24229-5.1-27)
### written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-74',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => \q{(CtFindSAfromPkt(@_) ne '')
		   && (CtFlv('HD,#Contact,c-params,#STAR,star',@_) eq '')},
    'OK' => \\' The hostport parameter(%s) in Contact header field SHALL include the protected server port value(%s) if the REGISTER request is protected by a security association.',
    'NG' => \\' The hostport parameter(%s) in Contact header field SHALL include the protected server port value(%s) if the REGISTER request is protected by a security association.',
    'EX' => sub{
	my ($port,$rcv_port,$sa_nego);
	$rcv_port = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,port',@_);	
	if (CtUtEq($rcv_port,CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps'),@_)){
	    $result = 'OK';
	}else{
	    $result = ''; # NG
	}
    }
},

### Judgment rule for 'Via'
### (Basis for a determination : TS24229-5.1-29)
### (Basis for a determination : TS24229-5.1-29)
###  written by suyama (2007.12.12)
###  modified by orimo (2008.1.16)
###  modified by orimo (2008.1.28)
###  modified by suyama (2009.2.18)
### 
### 
###               UDP
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-75',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) eq 'REGISTER') 
		   && (CtFindSAfromPkt(@_) ne '')
		   && (CtFlGet('INET,#UDP',@_[0]) ne '')},
    'OK' => \\'The protected server port value(%s) SHALL be included in the sent-by field of the Via header field(%s) for the UDP.',
    'NG' => \\'The protected server port value(%s) SHALL be included in the sent-by field of the Via header field(%s) for the UDP.',
    'EX' => sub{
	my ($hexST,$node) = @_;
	my ($port,$via_port,$sa_nego,$result);
	
	$via_port = CtFlv('HD,#Via,records,#ViaParm,sentby,port', $hexST);	
	$port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps');
	if (CtUtEq($via_port,$port,@_)){
	    $result = 'OK';
	}else{
	    $result = ''; # NG
	}
    }
},


### Judgment rule for 'Security-Client'
###(Basis for a determination : TS24229-5.1-32
###                       (
### written by suyama (2007.12.12)
### suyama modified (2009.2.16)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-76',
    'CA' => 'Security-Client',
    'ET' => 'error',
    'OK' => 'The Security-Client header field SHALL be set to the security mechanism the UE supports, the IPsec layer algorithm the UE supports and the parameters needed for the security association set up.',
    'NG' => 'The Security-Client header field SHALL be set to the security mechanism the UE supports, the IPsec layer algorithm the UE supports and the parameters needed for the security association set up.',
    'EX' => sub{
	(CtFlv('HD,#Security-Client,mechanism,#Mechanism,name',@_) ne "")
	    && ((CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_)
		 eq "hmac-sha-1-96")
		|| (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_)
		    eq "hmac-md5-96"))
	    && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',@_) ne "")
	    && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',@_) ne "")
	    && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',@_) ne "")                          && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_) ne "")
            && ((CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic',@_) 
		 eq "des-ede3-cbc")
		|| (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic',@_) 
		    eq "aes-cbc")
		|| (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic',@_) 
		    eq "null")
		|| (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic',@_) 
		    eq ""))	
	}
},


### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-90',
    'CA' => 'Via',
    'ET' => 'error',
    'OK' => 'The IP address or FQDN of the UE and the protected server port value for the UDP SHALL be included in Via header field.',
    'NG' => 'The IP address or FQDN of the UE and the protected server port value for the UDP SHALL be included in Via header field.',
    
    'EX' => sub{
	my ($sentby);

	# sentby
	#   
	#   
	unless( $sentby = CtFlv('HD,#Via,records,#ViaParm,sentby,host',@_) ){
	    return;
	}
	$sentby = [$sentby] unless(ref($sentby));
	if(grep{!$_}(@$sentby)){ return }

	# UDP
	if( CtFlGet('INET,#UDP',@_[0]) ){    
	    my $port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps');
	    my $via_port = CtFlv('HD,#Via,records,#ViaParm,sentby,port', @_);
	    if(!$via_port){return}
	    $via_port =[$via_port] unless(ref($via_port));
	    return (grep{$_ ne $port}(@$via_port)) ? '' : 'OK';
	}
	return 'OK';
    }
},       

### 
### 
### 
###  'S.TS24229-5.1-69'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-93',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'NG' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#UserName,username',@_), 
                      CtTbl('UC,UserProfile,PrivateUserIdentity',CtTbPrm('CI,target,TARGET')),@_)},
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-94',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value of the domain name of the home network(%s).',
    'NG' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value of the domain name of the home network(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Realm,realm',@_),
                      CtTbl('UC,UserProfile,HomeNetwork',CtTbPrm('CI,target,TARGET')),@_)}
},

### 
### 
### 
###  'S.TS24229-5.1-71'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-95',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'NG' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'EX' => sub{
	my($node,$uri,$sipuri);

	$node = CtTbPrm('CI,target,TARGET');               #
	$uri = CtTbl('UC,UserProfile,HomeNetwork',$node); 
	$sipuri = "sip:$uri";

        #
#        $iv_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,tag`$V eq uri`,uri',@_);
	$cl_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,uri',@_);
	if (CtUtEq($cl_uri,$sipuri,@_)){
	    return 'OK';
        }
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-96',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The nonce directive in Authorization header field SHALL be empty.',
    'NG' => 'The nonce directive in Authorization header field SHALL be empty.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Nonce,nonce',@_),'',@_)}
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-97',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The response directive in Authorization header field SHALL be empty.',
    'NG' => 'The response directive in Authorization header field SHALL be empty.',
    'EX' => sub{
	my($iv_rs,$cl_rs);
	#response
	$iv_rs = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#AuthParam,tag`$V eq response`,auth',@_);
	$cl_rs = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',@_);
	if (($iv_rs eq "\"\"") && ($cl_rs eq '')){return 'OK';}}
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-98',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The hostport parameter(%s) in Contact header field SHALL be set to an unprotected port(%s) where the UE expects to receive subsequent requests.',
    'NG' => \\'The hostport parameter(%s) in Contact header field SHALL be set to an unprotected port(%s) where the UE expects to receive subsequent requests.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,port',@_),CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET'),@_))},
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-99',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The sent-by field(%s) in Via header field SHALL be set to an unprotected port(%s) where the UE expects to receive subsequent requests.',
    'NG' => \\'The sent-by field(%s) in Via header field SHALL be set to an unprotected port(%s) where the UE expects to receive subsequent requests.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Via#0,records,#ViaParm#0,sentby,port',@_),CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET')),@_)},
},

### 
###               From,To
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-100',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The locally available public user identity, the private user identity, and the domain name to be used in the Request-URI SHALL be used in the registration by UE.',
    'NG' => 'The locally available public user identity, the private user identity, and the domain name to be used in the Request-URI SHALL be used in the registration by UE.',
    'EX' => sub{
	my $node = CtTbPrm('CI,target,TARGET');               #
        return CtTbl('UC,UserProfile,PublicUserIdentity',$node) eq CtFlv('HD,#From,addr,uri,#TXT#', @_) &&
            CtTbl('UC,UserProfile,PublicUserIdentity',$node) eq CtFlv('HD,#To,addr,uri,#TXT#',@_) &&
            CtTbl('UC,UserProfile,PrivateUserIdentity',$node) eq CtFlv("HD,#Authorization,credentials,credential,digestresp,list,username",@_) &&
            CtTbl('UC,UserProfile,HomeNetwork',$node) eq CtFlv('SL,uri,host', @_);
    }
},

### Judgment rule for "Request-URI"
### (Basis for a determination : TS24229-5.1-63)
###                        (
### written by suyama (2009.2.19)
### 
###               UE
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-123',
    'CA' => 'Request-URI',
    'ET' => 'error',
    'OK' => \\'Request URI(%s) SHALL be set to the resource to which the UE wants to be subscribed to(%s).',
    'NG' => \\'Request URI(%s) SHALL be set to the resource to which the UE wants to be subscribed to(%s).',
    'EX' => sub {
	my($rv_uri,$impu,$node);
	$node = CtTbPrm('CI,target,TARGET');
	
	$rv_uri = CtFlv('SL,uri,#TXT#', @_);
	$impu = CtTbl('UC,UserProfile,PublicUserIdentity',$node);

	CtUtEq($rv_uri,$impu,@_);
    }
},

### Judgment rule for "From"
### (Basis for a determination : TS24229-5.1-64)
###                        (
### written by suyama (2008.1.16)
### suyama modified(2009.2.18)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-124',
    'CA' => 'From',
    'ET' => 'error',
    'OK' => \\'From header field(%s) SHALL be set to a SIP URI that contains the public user identity(%s) used for subscription.',
    'NG' => \\'From header field(%s) SHALL be set to a SIP URI that contains the public user identity(%s) used for subscription.',
    'EX' => sub {
	my ($uri,$node);
	$node = CtTbPrm('CI,target,TARGET');
	$uri = CtFlv('HD,#From,addr,uri,#TXT#',@_);
	CtUtEq($uri,CtTbl('UC,UserProfile,PublicUserIdentity',$node),@_);
    },
},

### Judgment rule for "To"
### (Basis for a determination : TS24229-5.1-65)
###                        (
### written by suyama (2008.1.16)
### suyama modified(2009.2.18)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-125',
    'CA' => 'To',
    'ET' => 'error',
    'OK' => \\'To header field(%s) SHALL be set to a SIP URI that contains the public user identity(%s) used for subscription.',
    'NG' => \\'To header field(%s) SHALL be set to a SIP URI that contains the public user identity(%s) used for subscription.',
    'EX' => sub {
	my ($uri,$node);

	$node = CtTbPrm('CI,target,TARGET');
	$uri = CtFlv('HD,#To,addr,uri,#TXT#',@_);
	CtUtEq($uri,CtTbl('UC,UserProfile,PublicUserIdentity',$node),@_);

    },
},

### Judgment rule for 'Event'
###(Basis for a determination : TS24229-5.1-66)
###                       (
### written by suyama (2007.12.18)
### suyama modified(2009.2.18)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-126',
    'CA' => 'Event',
    'ET' => 'error',
    'OK' => \\'Event header field SHALL be set to the \"reg\" event package.',
    'NG' => \\'Event header field SHALL be set to the \"reg\" event package.',
    'EX' =>  sub {
	my($parameter,@field,$val);
	$parameter = CtFlv('HD,#Event,eventtype',@_);
	@field = split(/,/, $parameter);  
	
	foreach $val (@field){
	    
	    if ($val =~ /^reg$/m){
		return 'OK';       
	    }  
	}
    },
},

### Judgment rule for 'Expires'
###(Basis for a determination : TS24229-5.1-67)
###                       (
### written by suyama (2008.1.16)
### suyama modified(2009.2.18)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-127',
    'CA' => 'Expires',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) eq 'SUBSCRIBE')
		   && ((CtFlv('HD,#Contact,c-params,#STAR,star',@_) eq '')
		   || (CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_) ne '')
		   || (CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_) ne '0'))
	       },
		   'OK' => \\'Expires header field(%s) SHALL be set to 600 000 seconds as the value desired for the duration of the subscription.',
		   'NG' => \\'Expires header field(%s) SHALL be set to 600 000 seconds as the value desired for the duration of the subscription.',
		   'EX' => \q{(CtUtEq(CtFlv('HD,#Expires,seconds',@_),'600000',@_))
			      }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-129',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'Contact header field SHALL be set to IP address or FQDN(%s) as in the initial registration(%s).',
    'NG' => \\'Contact header field SHALL be set to IP address or FQDN(%s) as in the initial registration(%s).',
    'EX' => sub{
	my($reg_dlg,$reg_contact,$sub_contact);
	$reg_dlg = CtRlCxUsr(@_)->{'reg_dlg'};
	$reg_contact = CtSvDlg($reg_dlg,'RemoteTarget'); #
	$sub_contact = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#TXT#',@_); #
        if( $reg_contact =~ /^(.+):([0-9]+)$/ ){
            $reg_contact=$1;
        }
        if( $sub_contact =~ /^(.+):([0-9]+)$/ ){
            $sub_contact=$1;
        }
        return CtUtEq($sub_contact,$reg_contact,@_);       
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-130',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'Contact header field set to containthe protected server port(%s) value as in the initial registration(%s).',
    'NG' => \\'Contact header field set to containthe protected server port(%s) value as in the initial registration(%s).',
    'EX' => sub{
	my($reg_dlg,$reg_contact,$sub_contact);
	$reg_dlg = CtRlCxUsr(@_)->{'reg_dlg'};
	$reg_contact = CtSvDlg($reg_dlg,'RemoteTarget'); #
	$sub_contact = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#TXT#',@_); #
        if( $reg_contact =~ /^(.+):([0-9]+)$/ ){
            $reg_contact=$2;
        }
        if( $sub_contact =~ /^(.+):([0-9]+)$/ ){
            $sub_contact=$2;
        }
        return CtUtEq($sub_contact,$reg_contact,@_);       
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-131',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The port value in Contact header field SHALL be set to an unprotected port where the UE expects to receive subsequent mid-dialog requests.',
    'NG' => 'The port value in Contact header field SHALL be set to an unprotected port where the UE expects to receive subsequent mid-dialog requests.',
    'EX' => sub{
	my($reg_dlg,$reg_contact,$sub_contact);
	$reg_dlg = CtRlCxUsr(@_)->{'reg_dlg'};
	$reg_contact = CtSvDlg($reg_dlg,'RemoteTarget'); #
	$sub_contact = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#TXT#',@_); #
        if( $reg_contact =~ /^(.+):([0-9]+)$/ ){
            $reg_contact=$2;
        }
        if( $sub_contact =~ /^(.+):([0-9]+)$/ ){
            $sub_contact=$2;
        }
        return CtUtEq($sub_contact,$reg_contact,@_);       
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-132',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The port value in Contact header field SHALL be set the unprotected port value to the port value used in the initial REGISTER request.',
    'NG' => 'The port value in Contact header field SHALL be set the unprotected port value to the port value used in the initial REGISTER request.',
    'EX' => sub{
	my($reg_dlg,$reg_contact,$sub_contact);
	$reg_dlg = CtRlCxUsr(@_)->{'reg_dlg'};
	$reg_contact = CtSvDlg($reg_dlg,'RemoteTarget'); #
	$sub_contact = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#TXT#',@_); #
        if( $reg_contact =~ /^(.+):([0-9]+)$/ ){
            $reg_contact=$2;
        }
        if( $sub_contact =~ /^(.+):([0-9]+)$/ ){
            $sub_contact=$2;
        }
        return CtUtEq($sub_contact,$reg_contact,@_);       
    }
},

### Judgment rule for 'massege'
###(Basis for a determination : TS24229-5.1-70)
### written by suyama (2009.2.19)
### 
###               
###               
###               
###                     
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-133',
    'CA' => 'Message',
    'OD' => 'LAST',
    'ET' => 'error',
    'OK' => 'The information for the established dialog and the expiration time as indicated in the Expires header field of the received response SHALL be stored by UE.',
    'NG' => 'The information for the established dialog and the expiration time as indicated in the Expires header field of the received response SHALL be stored by UE.',
    'EX' => sub{
	my($pkt,$context)=@_;
        my($rules);
        $rules=['S.RFC3261-7.1-2',
                'S.RFC3261-8.1-1',
                'S.RFC3261-8.1-14',
                'S.RFC3261-8.1-15',
                'S.RFC3261-8.1-18',
                'S.RFC3261-8.1-20',
                'S.RFC3261-8.1-21',
                'S.RFC3261-8.1-23',
                'S.RFC3261-20.14-3',
                'S.RFC3265-3.1-4',
                'S.RFC3265-3.1-1',
                'S.RFC3265-3.3-5',
                CtSecurityScheme() eq 'aka' ? 'S.TS24229-5.1-355' : 'S.TS24229-5.1-357',
                CtSecurityScheme() eq 'aka' ? 'S.TS24229-5.1-356' : 'S.TS24229-5.1-358'];
        if(CtSecurityScheme() eq 'aka'){
            push(@$rules,'S.RFC3329-2.3-15','S.RFC3329-2.3-16');
        }
	return CtRlSyntaxResult($rules,$context);
    }
},

### Judgment rule for 'massege'
###(Basis for a determination : TS24229-5.1-71)
### written by suyama (2009.2.19)
### 
###               
###                     
### 
{
    'TY'=> 'SYNTAX', 
    'ID'=> 'S.TS24229-5.1-134', 
    'CA'=> 'Message', 
    'ET'=> 'error',
    'OK'=> \\'The subscription for a previously registered public user identity SHALL be automatically 
              refreshed either 600 seconds before the expiration time if the initial subscription was 
              for greater than 1200 seconds, or when half of the time has expired if the initial 
              subscription was for 1200 seconds or less.',
	      'NG'=> \\'The subscription for a previously registered public user identity SHALL be automatically 
              refreshed either 600 seconds before the expiration time if the initial subscription was 
              for greater than 1200 seconds, or when half of the time has expired if the initial 
              subscription was for 1200 seconds or less.',
	      'EX' => sub{
		  return 'OK';    
	      }
},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-75)
### written by suyama (2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-147',
    'CA' => 'Security',
    'ET' => 'error',
    'PR' => \q{(CtFlv('HD,#Contact,c-params,#STAR,star',@_) eq '')},
    'OK' => 'The reregistration SHALL be sent over the existing set of security associations that is associated with the related contact address.',
    'NG' => 'The reregistration SHALL be sent over the existing set of security associations that is associated with the related contact address.',
    'EX' => sub{
	my($pkt)=@_;
        my($sa_nego,$dstport,$srcport,$spi,$portpc,$portls,$spils);
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$srcport = CtFlGet('INET,#UDP,SrcPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};

	$reg_dlg = CtRlCxDlg(@_);
 	$last_ct = CtSvDlg($reg_dlg,'RemoteTarget'); #
	$rcv_ct = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#TXT#',@_); #
	$portpc = CtSecNego($sa_nego,'port_pc');
	$portls = CtSecNego($sa_nego,'port_ls');
	$spils = CtSecNego($sa_nego,'spi_ls');

        if(($spi eq $spils)
	    && ($dstport eq $portls)
	    && ($srcport eq $portpc)
	    && ($last_ct eq $rcv_ct)){
	    return 'OK'
	    }
    }

},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-79,TS24229-5.1-158)
### written by suyama (2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-153',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'The REGISTER request SHALL be protected using a security association established as a result of an earlier registration.',
    'NG' => 'The REGISTER request SHALL be protected using a security association established as a result of an earlier registration.',
    'EX' => sub{
	my($pkt)=@_;
        my($sa_nego,$dstport,$srcport,$spi,$portpc,$portls,$spils);
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$srcport = CtFlGet('INET,#UDP,SrcPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};
	$portpc = CtSecNego($sa_nego,'port_pc');
	$portls = CtSecNego($sa_nego,'port_ls');
	$spils = CtSecNego($sa_nego,'spi_ls');

        if(($spi eq $spils)
	    && ($dstport eq $portls)
	    && ($srcport eq $portpc)){
	    return 'OK'
	    };
    }
},

### 
### 
### 'S.TS24229-5.1-31'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-155',
    'CA' => 'From',
    'ET' => 'error',
    'OK' => \\'From header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'NG' => \\'From header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'EX' => sub {
	my ($node,$uri,$rcv_from);
	$node = CtTbPrm('CI,target,TARGET');               #

	$uri = CtTbl('UC,UserProfile,PublicUserIdentity',$node);
	$rcv_from = CtFlv('HD,#From,addr,uri,#TXT#', @_);

	CtUtEq($rcv_from,$uri,@_);
    },
},

### 
### 
###  'S.TS24229-5.1-32'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-156',
    'CA' => 'To',
    'ET' => 'error',
    'OK' => \\'To header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'NG' => \\'To header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'EX' => sub {
	my ($node,$uri,$rcv_from);
	$node = CtTbPrm('CI,target,TARGET');               #

	$uri = CtTbl('UC,UserProfile,PublicUserIdentity',$node);
	$rcv_to = CtFlv('HD,#To,addr,uri,#TXT#', @_);

	CtUtEq($rcv_to,$uri,@_);
    },
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-157',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'Contact header field SHALL be set to IP address or FQDN.',
    'NG' => 'Contact header field SHALL be set to IP address or FQDN.',
    'EX' =>  sub {
	my($uris,$port,$rcv_port);

	# 
	unless($uris=CtFlv('HD,#Contact,c-params,#ContactParam,addr,#Name#',@_)){
	    return;
	}
	$uris =[$uris] unless(ref($uris));
	if( grep{$_ ne 'NameAddr' && $_ ne 'AddrSpec'}(@$uris) ){
	    return;
	}
	unless($uris=CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#Name#',@_)){
	    return;
	}
	$uris =[$uris] unless(ref($uris));
	if( grep{!$_ || $_ eq 'AbsoluteUri'}(@$uris) ){
	    return;
	}

	#
	unless( $rcv_port = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,port',@_) ){
	    return;
	}
	$rcv_port =[$rcv_port] unless(ref($rcv_port));
        if(CtSecurityScheme() eq 'sipdigest'){
            $port = CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET'));
        }
        else{
            $port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps');
        }
        if(grep{$_ ne $port}(@$rcv_port)){return}
        
        my($fqdn1,$fqdn2);
	my $ip = CtTbCfg(CtTbPrm('CI,target,TARGET'),'address');
	my $fqdn = CtTbCfg(CtTbPrm('CI,target,TARGET'),'contact-host');
	if( $fqdn =~ /^(.+)\@(.+)/ ){
            $fqdn1=$1;
            $fqdn2=$2;
        }

	my $userinfo = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,userinfo',@_);
	my $host = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,host',@_);
	    
        if($userinfo eq ''){
            return $host eq "[$ip]";
        }elsif($host eq "[$ip]" && $userinfo eq $fqdn1 ){
            return  'OK';
        }elsif($host !~ /\[/){
            return "sip:$userinfo\@$host" eq "sip:$fqdn1\@$fqdn2";
        }elsif($host =~ /\[/){
            return "sip:$userinfo\@$host" ne "sip:$fqdn1\@\[$ip\]";
        }
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-160',
    'CA' => 'Via',
    'ET' => 'error',
    'OK' => 'Via header field SHALL be set to IP address or  FQDN.',
    'NG' => 'Via header field SHALL be set to IP address or  FQDN.',
    'EX' => sub{
	my ($sentby);

	# sentby
	#   
	#   
	unless( $sentby = CtFlv('HD,#Via,records,#ViaParm,sentby,host',@_) ){
	    return;
	}
	$sentby = [$sentby] unless(ref($sentby));
	if(grep{!$_}(@$sentby)){ return }

	# UDP
	if( CtFlGet('INET,#UDP',@_[0]) ){    
            my $port;
            if(CtSecurityScheme() eq 'sipdigest'){
                $port = CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET'));
            }
            else{
                $port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps');
            }
	    my $via_port = CtFlv('HD,#Via,records,#ViaParm,sentby,port', @_);
	    if(!$via_port){return}
	    $via_port =[$via_port] unless(ref($via_port));
	    return (grep{$_ ne $port}(@$via_port)) ? '' : 'OK';
	}
	return 'OK';
    }
},       

### 
### 
###  'S.TS24229-5.1-40'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-161',
    'CA' => 'expires',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) eq 'REGISTER')
	    && (CtFlv('HD,#Contact,c-params,#STAR,star',@_) eq '')
            || (CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_) ne '0')
            || (CtFlv('HD,#Expires,seconds',@_) ne '0')
	    },
    'OK' => \\'An Expires header field or the expires parameter within the Contact header field(%s) SHALL be set to the value of 600 000 seconds.',
    'NG' => \\'An Expires header field or the expires parameter within the Contact header field(%s) SHALL be set to the value of 600 000 seconds.',
    'EX' => sub{
	my($contact,$expires);

	$contact = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_);
	$expires = CtFlv('HD,#Expires,seconds',@_);
	if ($contact eq ''){
	    if (CtUtEq($expires,'600000',@_)){
		return 'OK';
	    }
	}else{
	    if (CtUtEq($contact,'600000',@_)){
		return 'OK';
	    }
	}
	return '';
    }
},

### 
### 
###  'S.TS24229-5.1-41'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-162',
    'CA' => 'Request-URI',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => \\'Request-URI(%s) SHALL be set to the SIP URI(%s) of the domain name of the home network.',
    'NG' => \\'Request-URI(%s) SHALL be set to the SIP URI(%s) of the domain name of the home network.',
    'EX' => sub {
	my ($node,$rcv_uri,$uri);
	
	$node = CtTbPrm('CI,target,TARGET');
	$rcv_uri = CtFlv('SL,uri,host', CtRlCxPkt(@_));
	$uri = CtTbl('UC,UserProfile,HomeNetwork',$node);
	
	CtUtEq($rcv_uri,$uri,@_);
    },  
},

### 
### 
###  'S.TS24229-5.1-42'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-163',
    'CA' => 'Supported',
    'ET' => 'error',
    'OK' => 'The option tag "path" SHALL be contained in the Supported header field.',
    'NG' => 'The option tag "path" SHALL be contained in the Supported header field.',
    'EX' =>  sub {
	my($parameter,@field,$val);
	$parameter = CtFlv('HD,#Supported,option',@_);
	@field = split(/,/, $parameter);  
	
	foreach $val (@field){
	    
	    if ($val =~ /^path$/m){
		return 'OK';       
	    }  
	}
    },
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-171',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => \q{(CtFlv('HD,#Contact,c-params,#STAR,star',@_) eq '')
	    || (CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_) ne '0')
	    || (CtFlv('HD,#Expires,seconds',@_) ne '0')},
    'OK' => 'Another REGISTER request SHALL be sent the registration expiration interval value with an expiration time of at least the value received in Min-Expire header field of 423(Interval Too Brief) response.',
    'NG' => 'Another REGISTER request SHALL be sent the registration expiration interval value with an expiration time of at least the value received in Min-Expire header field of 423(Interval Too Brief) response.',
    'EX' => sub{
	my($contact, $expires, $min_time);
	
	$contact = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_);
	$expires = CtFlv('HD,#Expires,seconds',@_);
	$min_time = CtFlv('HD,#Min-Expires,seconds',CtUtLastSndMsg());
	
	if ($contact eq ''){
	    if ($expires > $min_time || $expires == $min_time){
		return 'OK';
	    }}else{
		if ($contact > $min_time || $contact == $min_time){
		    return 'OK';
		}
	    }
	return '';
    }
},

### Judgment rule for 'Message'
###(Basis for a determination : TS24229-5.1-110)
###  written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-177',
    'CA' => 'Massege',
    'ET' => 'error',
    'OK' => 'The process of all ongoing dialogs and transactions SHALL be stopped and silently discarded them locally.',
    'NG' => 'The process of all ongoing dialogs and transactions SHALL be stopped and silently discarded them locally.',
},

### 
### 
###  'S.TS24229-5.1-69'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-183',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'NG' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#UserName,username',@_), 
                      CtTbl('UC,UserProfile,PrivateUserIdentity',CtTbPrm('CI,target,TARGET')),@_)},
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-82,TS24229-5.1-163)
###                       (
### written by suyama (2007.12.12)
### suyama modified (2009.2.16) 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-184',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value as received in the realm directive in the WWW-Authenticate header field(%s).',
    'NG' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value as received in the realm directive in the WWW-Authenticate header field(%s).',
    'EX' => sub{
	my($fl_realm) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Realm,realm',@_);
	my($fl_res) = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,#Realm,realm',CtRlCxUsr(@_)->{'reg_nego'});

	if (CtUtEq($fl_realm,$fl_res,@_)){
	    return 'OK';
	}
	return '';
    }
},

### 
### 
###  'S.TS24229-5.1-71'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-185',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'NG' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'EX' => sub{
	my($node,$uri,$sipuri);

	$node = CtTbPrm('CI,target,TARGET');               #
	$uri = CtTbl('UC,UserProfile,HomeNetwork',$node); 
	$sipuri = "sip:$uri";

        #
#        $iv_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,tag`$V eq uri`,uri',@_);
	$cl_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,uri',@_);

	if (CtUtEq($cl_uri,$sipuri,@_)){
	    return 'OK';
        }
    }
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-84,TS24229-5.1-165)
###(Basis for a determination : TS24229-5.1-82,TS24229-5.1-161)
### written by suyama (2008.1.17)
### suyama modified (2009.2.16)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-186',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => \\'The nonce directive(%s) in Authorization header field SHALL be set to last received nonce value(%s).',
    'NG' => \\'The nonce directive(%s) in Authorization header field SHALL be set to last received nonce value(%s).',
    'EX' => sub{
	my($fl_nonce) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Nonce,nonce',@_);
	my($fl_res) = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,#Nonce,nonce',CtRlCxUsr(@_)->{'reg_nego'});

	#
	my($fl_mac) = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,#Nonce,nonce',CtUtLastSndMsg());
	my($auth_err) = CtRlCxUsr(@_)->{'reg_nego'};

	if ($auth_err ne ''){
	    if(CtUtEq($fl_nonce,$fl_mac,@_)){
		return 'OK';
	}else{
	    if(CtUtEq($fl_nonce,$fl_res,@_)){
		return 'OK';
	    }
	}
	return '';
	}
    }
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-85,TS24229-5.1-166)
###   written by suyama (2008.1.17)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-187',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => \\'The response directive(%s) in Authorization header field SHALL be set to the last calculated response value(%s).',
    'NG' => \\'The response directive(%s) in Authorization header field SHALL be set to the last calculated response value(%s).',
    'EX' => sub{
	my($fl_resp) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',@_);
	my($fl_res) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',CtRlCxUsr(@_)->{'reg_auth'});   
	if (CtUtEq($fl_resp,$fl_res,@_)){
	    return 'OK';
	}
	return '';
    }   
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-188',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'Contact header field(%s) SHALL be set to protected server port value(%s).',
    'NG' => \\'Contact header field(%s) SHALL be set to protected server port value(%s).',
    'EX' =>  sub {
	my($uris,$port,$rcv_port);

	#
	unless( $rcv_port = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,port',@_) ){
	    return;
	}
	$rcv_port =[$rcv_port] unless(ref($rcv_port));
	$port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps');
        my $result = (grep{$_ ne $port}(@$rcv_port)) ? '' : 'OK';

	CtRlSetEvalResult(@_[1],'2op','',$result,$rcv_port,$port);
        return $result;
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-189',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The protected server port value(%s) for the UDP SHALL be included in Via header field(%s).',
    'NG' => \\'The protected server port value(%s) for the UDP SHALL be included in Via header field(%s).',
    'EX' => sub{
	# Via
        my $port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps');
        my $via_port = CtFlv('HD,#Via,records,#ViaParm,sentby,port', @_);
        if(!$via_port){return}
        $via_port =[$via_port] unless(ref($via_port));
        my $result = (grep{$_ ne $port}(@$via_port)) ? '' : 'OK';
	CtRlSetEvalResult(@_[1],'2op','',$result,$via_port,$port);
        return $result;
    }
},

## Judgment rule for 'Security-Client'
###(Basis for a determination : TS24229-5.1-93,TS24229-5.1-146,TS24229-5.1-173
### suyama added (2009.2.16)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-190',
    'CA' => 'Security-Client',
    'ET' => 'error',
    'OK' => 'Security-Client header field SHALL be set to the security mechanism it supports, the IPsec layer algorithms for integrity and confidentiality protection it supports and the new parameter values needed for the setup of two new pairs of security associations.',
    'NG' => 'Security-Client header field SHALL be set to the security mechanism it supports, the IPsec layer algorithms for integrity and confidentiality protection it supports and the new parameter values needed for the setup of two new pairs of security associations.',
    'EX' => \q{(CtFlv('HD,#Security-Client,mechanism,#Mechanism,name',@_) ne "")
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_) ne "")
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',@_) ne
		       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',
			     CtRlCxUsr(@_)->{'reg_ini'}))		    
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',@_) ne
		       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',
			     CtRlCxUsr(@_)->{'reg_ini'}))
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',@_) ne 
		       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',
			     CtRlCxUsr(@_)->{'reg_ini'}))
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_) eq 
		       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',
			     CtRlCxUsr(@_)->{'reg_ini'}));
	   }

},	      

### Judgment rule for 'Security-Verify'
###(Basis for a determination : TS24229-5.1-94,TS24229-5.1-174
###                            (
### written by suyama (2007.12.12)
### suyama modified (2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-191',
    'CA' => 'Security-Verify',
    'ET' => 'error',
    'OK' => 'Security-Verify header field SHALL be set to the content of the Security-Server header field received in the 401 (Unauthorized) response of the last successful authentication.',
    'NG' => 'Security-Verify header field SHALL be set to the content of the Security-Server header field received in the 401 (Unauthorized) response of the last successful authentication.',
    'EX' =>  \q{(CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,name',@_),
			CtFlv('HD,#Security-Server,mechanism,#Mechanism,name',CtRlCxUsr(@_)->{'reg_nego'}))) 
		    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_),
			       CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',
				     CtRlCxUsr(@_)->{'reg_nego'})))
		    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic',@_),
			    CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic',
				  CtRlCxUsr(@_)->{'reg_nego'})))
		    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',@_),
			       CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',
				     CtRlCxUsr(@_)->{'reg_nego'})))		    
		    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',@_),
			       CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',
				     CtRlCxUsr(@_)->{'reg_nego'})))			  
		    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',@_),
			       CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',
				     CtRlCxUsr(@_)->{'reg_nego'})))
		    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_),
			       CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',
				     CtRlCxUsr(@_)->{'reg_nego'})));
	    },
},

### 
### 
### 
###  'S.TS24229-5.1-69'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-193',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'NG' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#UserName,username',@_), 
                      CtTbl('UC,UserProfile,PrivateUserIdentity',CtTbPrm('CI,target,TARGET')),@_)},
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-194',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value of the domain name of the home network(%s).',
    'NG' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value of the domain name of the home network(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Realm,realm',@_),
                      CtTbl('UC,UserProfile,HomeNetwork',CtTbPrm('CI,target,TARGET')),@_)}
},

### 
### 
### 
###  'S.TS24229-5.1-71'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-195',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'NG' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'EX' => sub{
	my($node,$uri,$sipuri);

	$node = CtTbPrm('CI,target,TARGET');               #
	$uri = CtTbl('UC,UserProfile,HomeNetwork',$node); 
	$sipuri = "sip:$uri";

        #
#        $iv_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,tag`$V eq uri`,uri',@_);
	$cl_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,uri',@_);
	if (CtUtEq($cl_uri,$sipuri,@_)){
	    return 'OK';
        }
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-196',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The nonce directive in Authorization header field SHALL be empty.',
    'NG' => 'The nonce directive in Authorization header field SHALL be empty.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Nonce,nonce',@_),'',@_)}
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-197',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The response directive in Authorization header field SHALL be empty.',
    'NG' => 'The response directive in Authorization header field SHALL be empty.',
    'EX' => sub{
	my($iv_rs,$cl_rs);
	#response
	$iv_rs = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#AuthParam,tag`$V eq response`,auth',@_);
	$cl_rs = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',@_);
	if (($iv_rs eq "\"\"") && ($cl_rs eq '')){return 'OK';}}
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-198',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The port value(%s) in Contact header field SHALL be set to an unprotected port(%s) where the UE expects to receive subsequent requests.',
    'NG' => \\'The port value(%s) in Contact header field SHALL be set to an unprotected port(%s) where the UE expects to receive subsequent requests.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,port',@_),CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET'),@_))},
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-199',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The port value(%s) in Via header field SHALL be set to an unprotected port(%s) where the UE expects to receive responses to the request.',
    'NG' => \\'The port value(%s) in Via header field SHALL be set to an unprotected port(%s) where the UE expects to receive responses to the request.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Via#0,records,#ViaParm#0,sentby,port',@_),CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET')),@_)},
},


### Judgment rule for 'Message'
###(Basis for a determination : TS24229-5.1-118)
###  written by suyama (2009.2.20)
### 
###               
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-219',
    'CA' => 'Massege',
    'ET' => 'error',
    'OK' => 'Authentication procedure SHALL be abandoned and a new REGISTER request SHALL be sent with a new Call-ID if the Security-Server header field is not present or it does not contain the parameters required for the setup of the set of security associations.',
    'NG' => 'Authentication procedure SHALL be abandoned and a new REGISTER request SHALL be sent with a new Call-ID if the Security-Server header field is not present or it does not contain the parameters required for the setup of the set of security associations.',
    'EX' => sub{
	my($last_ci,$ci);
	
	$last_ci = CtRlCxUsr(@_)->{'callids'};
	$ci = CtFlv('HD,#Call-ID,call-id',@_);

	foreach $result(@{$last_ci}){
	    if (!CtUtEq($result,$ci,@_)){

		return 'OK';
	    }
	}
    }
},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-120)
###  written by suyama (2009.2.25)
### 
###               Client/Verify
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-221',
    'CA' => 'Security',
    'ET' => 'error',
    'PR' => \q{((CtRlCxUsr(@_)->{'regflag'}) ne '')},
    'OK' => 'A temporary set of security associations SHALL be set up based on the static list and parameters it received in the 401 (Unauthorized) response and its capabilities sent in the Security-Client header field in the REGISTER request.',
    'NG' => 'A temporary set of security associations SHALL be set up based on the static list and parameters it received in the 401 (Unauthorized) response and its capabilities sent in the Security-Client header field in the REGISTER request.',
    'EX' => sub{
	my($pkt)=@_;
        my($dstport,$srcport,$spi,$portpc,$portls,$spils);

        #
	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$srcport = CtFlGet('INET,#UDP,SrcPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};
	$reg_ini = CtRlCxUsr(@_)->{'reg_ini'};
	$reg_nego = CtRlCxUsr(@_)->{'reg_nego'};

        #401
	$portpc = CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic', $reg_ini);
        $portls = CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic', $reg_nego);
	$spils = CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic', $reg_nego);

        if(($spi eq $spils)
	    && ($dstport eq $portls)
	    && ($srcport eq $portpc)){
	    return 'OK'
	    };
    }
},

### Judgment rule for 'Security'		
###(Basis for a determination : TS24229-5.1-121)
###  written by suyama (2009.2.5)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-222',
    'CA' => 'Security',
    'ET' => 'error',
    'PR' => \q{((CtRlCxUsr(@_)->{'regflag'}) ne '')},
    'OK' => 'The temporary set of security associations SHALL be set up using the most preferred mechanism and algorithm returned by the P-CSCF and supported by the UE and using IK and CK as the shared key.',
    'NG' => 'The temporary set of security associations SHALL be set up using the most preferred mechanism and algorithm returned by the P-CSCF and supported by the UE and using IK and CK as the shared key.',
    'EX' => sub{
	my($pkt)=@_;
        my($sa_nego,$rcv_alg,$rcv_mech,$mech,$alg);

	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$rcv_mech = CtFlv('HD,#Security-Client,mechanism,#Mechanism,name', @_);
	$rcv_alg = CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic', @_);
	$mech = CtSecNego($sa_nego,'mech');
	$alg = CtSecNego($sa_nego,'alg');

        if(($rcv_mech eq $mech)
	    && ($rcv_alg eq $alg)){
	    return 'OK'
	    };
    }
},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-122)
###  written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-223',
    'CA' => 'Security',
    'ET' => 'error',
    'PR' => \q{((CtRlCxUsr(@_)->{'regflag'}) ne '')},
    'OK' => 'The parameters received in the Security-Server header field SHALL be used to setup the temporary set of security associations.',
    'NG' => 'The parameters received in the Security-Server header field SHALL be used to setup the temporary set of security associations.',
    'EX' => sub{
	my($pkt)=@_;
        my($dstport,$spi,$portpc,$spils);

	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};
	$reg_nego = CtRlCxUsr(@_)->{'reg_nego'};

        $portls = CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic', $reg_nego);
	$spils = CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic', $reg_nego);

        if(($spi eq $spils)
	    && ($dstport eq $portls)){
	    return 'OK'
	    };
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-225',
    'CA' => 'Security',
    'ET' => 'error',
    'PR' => \q{((CtRlCxUsr(@_)->{'regflag'}) ne '')},
    'OK' => 'REGISTER request SHALL be sent using the temporary set of security associations to protect the message to  the protected server port indicated in the response.',
    'NG' => 'REGISTER request SHALL be sent using the temporary set of security associations to protect the message to  the protected server port indicated in the response.',
    'EX' => sub{
	my($pkt)=@_;
        my($sa_nego,$dstport,$srcport,$spi,$portpc,$portls,$spils);
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$srcport = CtFlGet('INET,#UDP,SrcPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};
	$portpc = CtSecNego($sa_nego,'port_pc');
	$portls = CtSecNego($sa_nego,'port_ls');
	$spils = CtSecNego($sa_nego,'spi_ls');
        if(($spi eq $spils)
	    && ($dstport eq $portls)
	    && ($srcport eq $portpc)){
	    return 'OK'
	    };
    }
},

### 
###               
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-226',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OD' => 'LAST',
    'OK' => 'The UE SHALL include an Authorization header as defined for the initial REGISTER request that was challenged with the received 401 (Unauthorized) response.',
    'NG' => 'The UE SHALL include an Authorization header as defined for the initial REGISTER request that was challenged with the received 401 (Unauthorized) response.',
    'EX' => sub{
	my ($hexST, $context) = @_;
	my $result = 'OK'; 

        # 
        $result = '' unless(CtUtIsExistHdr('Authorization', @_));

	#
	# 1:
	$result = '' if(CtRlSyntaxResult(SvRl226_257_RuleSet(CtRlCxUsr(@_)->{'regflag'}),$context) ne 'OK');
	return ($result);},
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-227',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The \"realm\" header field parameter(%s) in Authorization header field SHALL be set to the value(%s) as received in the \"realm\" header field in the WWW Authenticate header field.',
    'NG' => \\'The \"realm\" header field parameter(%s) in Authorization header field SHALL be set to the value(%s) as received in the \"realm\" header field in the WWW Authenticate header field.',
    'EX' => sub{
	# realm
	my $domain = CtTbl('UC,UserProfile,HomeNetwork',CtTbPrm('CI,target,TARGET'));
	my $realm = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,realm',@_);
        return CtUtEq($realm,$domain,@_);
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-228',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The \"username\" header field parameter(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'NG' => \\'The \"username\" header field parameter(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'EX' => sub{
	# username
	my $id = CtTbl('UC,UserProfile,PrivateUserIdentity',CtTbPrm('CI,target,TARGET'));
	my $name = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,username',@_);
	return CtUtEq($name,$id,@_);
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-229',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The \"response\" header field parameter(%s) in Authorization header field SHALL be set to the RES parameter(%s).',
    'NG' => \\'The \"response\" header field parameter(%s) in Authorization header field SHALL be set to the RES parameter(%s).',
    'EX' => sub{
	my $id = CtTbl('UC,UserProfile,PrivateUserIdentity',CtTbPrm('CI,target,TARGET'));

	# 
	my $auth_response = CtUtAuthResponse(pack('H*',CtAKAxres($id,'',CtRlCxUsr(@_)->{'security_nego'})),@_);

        # Authorization
	my $response = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,response',@_);

	# response
        return CtUtEq($response,$auth_response,@_);
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-230',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The "uri" header field parameter in Authorization header field SHALL be set to the SIP URI of the domain name of the home network.',
    'NG' => 'The "uri" header field parameter in Authorization header field SHALL be set to the SIP URI of the domain name of the home network.',
    'EX' => sub{
	# uri
	my $id = 'sip:'.CtTbl('UC,UserProfile,HomeNetwork',CtTbPrm('CI,target,TARGET'));
	my $uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,uri',@_);
	return CtUtEq($uri,$id,@_);
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-231',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The algorithm header field parameter(%s) in Authorization header field SHALL be set to the value(%s) received in the 401 (Unauthorized) response.',
    'NG' => \\'The algorithm header field parameter(%s) in Authorization header field SHALL be set to the value(%s) received in the 401 (Unauthorized) response.',
    'EX' => sub{
	# algorithm
	my $algorithm = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,algorithm',@_);
	my $id = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,algorithm',CtRlCxUsr(@_)->{'reg_nego'});
	return CtUtEq($algorithm,$id,@_);
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-232',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The nonce header field parameter in Authorization header field SHALL be set to the value received in the 401(Unauthorized) response.',
    'NG' => 'The nonce header field parameter in Authorization header field SHALL be set to the value received in the 401(Unauthorized) response.',
    'EX' => sub{
	# nonce
	my $nonce = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,nonce',@_);
	my $id = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,nonce',CtRlCxUsr(@_)->{'reg_nego'});
	return CtUtEq($nonce,$id,@_);
    }
},

###(Basis for a determination : TS24229-5.1-126 (
### written by suyama (2007.12.12)
### suyama modified (2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-233',
    'CA' => 'Security-Client',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => 'Security-Client header field that is idential to the Security-Client header field that was included in the previous REGISTER request SHALL be inserted into the request.',
    'NG' => 'Security-Client header field that is idential to the Security-Client header field that was included in the previous REGISTER request SHALL be inserted into the request.',
    'EX' => sub{
 	my($reg_ini) = CtRlCxUsr(@_)->{'reg_ini'};
   
	if((CtUtEq(CtFlv('HD,#Security-Client,mechanism,#Mechanism,name', @_), 
		   CtFlv('HD,#Security-Client,mechanism,#Mechanism,name', $reg_ini),@_) &&  
	    CtUtEq(CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic', @_), 
		   CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic', 
			 $reg_ini),@_) && 
	    CtUtEq(CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic', @_), 
		   CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic', 
			 $reg_ini),@_) && 
	    CtUtEq(CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic', @_), 
		   CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic', 
			 $reg_ini),@_) && 
	    CtUtEq(CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic', @_), 
		   CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic', 
			 $reg_ini),@_) &&
	    CtUtEq(CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic', @_), 
		   CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic', 
			 $reg_ini),@_) &&
	    CtUtEq(CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic', @_), 
		   CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic', 
			 $reg_ini),@_))){   
	    return 'OK';
	}
	   return '';
    }
},

### Judgment rule for 'Security-Verify'
###(Basis for a determination : TS24229-5.1-127
###                            (
### suyama added (2009.2.3)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-234',
    'CA' => 'Security-Verify',
    'ET' => 'error',
    'OK' => 'Security-Verify header field SHALL be mirrored the content of the Security-Server header field received in the 401 (Unauthorized) response.',
    'NG' => 'Security-Verify header field SHALL be mirrored the content of the Security-Server header field received in the 401 (Unauthorized) response.',
    'EX' => sub{
 	my($reg_ini) = CtRlCxUsr(@_)->{'reg_nego'};
   
	if((CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,name', @_), 
		   CtFlv('HD,#Security-Server,mechanism,#Mechanism,name', $reg_nego),@_) &&  
	    CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic', @_), 
		   CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic', 
			 $reg_nego),@_) && 
	    CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic', @_), 
		   CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic', 
			 $reg_nego),@_) && 
	    CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic', @_), 
		   CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic', 
			 $reg_nego),@_) && 
	    CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic', @_), 
		   CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic', 
			 $reg_nego),@_) &&
	    CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic', @_), 
		   CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic', 
			 $reg_nego),@_) &&
	    CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic', @_), 
		   CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic', 
			 $reg_nego),@_))){   
	    return 'OK';
	}
	   return '';
    }
},

### Judgment rule for 'Call-ID'
###(Basis for a determination : TS24229-5.1-128)
###                       (
### written by suyama (2007.12.13)
### suyama modified (2009.2.16)
### 
### 401
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-235',
    'CA' => 'Call-ID',
    'ET' => 'error',
    'PR' => \q{(CtFlv('HD,#Call-ID,call-id',@_) ne '')},
    'OK' => \\'Call-ID(%s) of the security association protected REGISTER request which carries the authentication challenge response SHALL be set to the same value as the Call-ID(%s) of the 401 (Unauthorized) response.',
    'NG' => \\'Call-ID(%s) of the security association protected REGISTER request which carries the authentication challenge response SHALL be set to the same value as the Call-ID(%s) of the 401 (Unauthorized) response.',
    'EX' => sub{
	        my($msg,$Call_ID,$Last_CallID);
		$Call_ID = CtFlv('HD,#Call-ID,call-id',@_);
		$Last_CallID = CtFlv('HD,#Call-ID,call-id',CtUtLastSndMsg());

		CtUtEq($Call_ID,$Last_CallID,@_);
    }
},

### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-237',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'The newly established set of security associations SHALL be used for further messages sent towards the P-CSCF as appropriate.',
    'NG' => 'The newly established set of security associations SHALL be used for further messages sent towards the P-CSCF as appropriate.',
    'EX' => sub{
	my($pkt)=@_;
        my($sa_nego,$dstport,$srcport,$spi,$portpc,$portls,$spils);
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$srcport = CtFlGet('INET,#UDP,SrcPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};

	$portpc = CtSecNego($sa_nego,'port_pc');
	$portls = CtSecNego($sa_nego,'port_ls');
	$spils = CtSecNego($sa_nego,'spi_ls');
	
        if(($spi eq $spils)
	    && ($dstport eq $portls)
	    && ($srcport eq $portpc)){
	    return 'OK'
	    };
    }
},

### Judgment rule for 'Security'
###(Basis for a determination :TS24229-5.1-131)
### written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-240',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => \\'The old set of security associations SHALL be deleted after all SIP transactions that use the old set of security associations are completed.',
    'NG' => \\'The old set of security associations SHALL be deleted after all SIP transactions that use the old set of security associations are completed.',
},

### Judgment rule for 'Message'
###(Basis for a determination :TS24229-5.1-133)
### written by suyama (2009.2.25)
### 
###               
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-243',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => \\'The registration SHALL be considered to have failed if 403 (Forbidden) response is received.',
    'NG' => \\'The registration SHALL be considered to have failed if 403 (Forbidden) response is received.',
    'EX' =>\q{(CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',@_),'',@_))
	      && (CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Nonce,nonce',@_),'',@_))
	  }	
},

### Judgment rule for 'Message'
###(Basis for a determination :TS24229-5.1-134)
### written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-244',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => \\'The temporary set of security associations SHALL be deleted and the old set of security associations SHALL be used.',
    'NG' => \\'The temporary set of security associations SHALL be deleted and the old set of security associations SHALL be used.',
    'EX' => sub{
	my($pkt)=@_;
        my($sa_nego,$dstport,$srcport,$spi,$portpc,$portls,$spils);
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$dstport = CtFlGet('INET,#UDP,DstPort',CtRlCxUsr(@_)->{'security_old'});
	$srcport = CtFlGet('INET,#UDP,SrcPort',CtRlCxUsr(@_)->{'security_old'});

	$portls = CtFlGet('INET,#UDP,DstPort',$pkt);
	$portpc = CtFlGet('INET,#UDP,SrcPort',$pkt);
	#$portpc = CtSecNego($sa_nego,'port_pc');
	#$portls = CtSecNego($sa_nego,'port_ls');
	
        if(($dstport eq $portls)
	    && ($srcport eq $portpc)){
	    return 'OK'
	    };
    }
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-142)
### written by suyama (2009.2.20)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-247',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => 'No AUTS directive and an empty response directive SHALL be contained in the subsequent REGISTER request.',
    'NG' => 'No AUTS directive and an empty response directive SHALL be contained in the subsequent REGISTER request.',
    'EX' =>  sub {
	my($rcv_auth) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',@_);
	my($auts) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,tag`$V eq auts`,auth',@_);

	if ((CtUtEq($auts,'',@_) && CtUtEq($rcv_auth,'',@_))){
	    return 'OK';
	}
    }
},

### Judgment rule for 'Authorization'
###(Basis for a determination : TS24229-5.1-143)
### written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-248',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => 'The AUTS directive SHALL be contained in the subsequent REGISTER request.',
    'NG' => 'The AUTS directive SHALL be contained in the subsequent REGISTER request.',
    'EX' =>  sub {
	my($auts) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,tag`$V eq auts`,auth',@_);

	if (!CtUtEq($auts,'',@_)){
	    return 'OK';
	}
    }
},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-145)
### written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-250',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'The REGISTER request SHALL be sent using an existing set of security associations.',
    'NG' => 'The REGISTER request SHALL be sent using an existing set of security associations.',
    'EX' => sub{
	my($pkt)=@_;
        my($sa_nego,$dstport,$srcport,$spi,$portpc,$portls,$spils);
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$srcport = CtFlGet('INET,#UDP,SrcPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};

	$portpc = CtSecNego($sa_nego,'port_pc');
	$portls = CtSecNego($sa_nego,'port_ls');
	$spils = CtSecNego($sa_nego,'spi_ls');

        if(($spi eq $spils)
	    && ($dstport eq $portls)
	    && ($srcport eq $portpc)){
	    return 'OK'
	    };
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-251',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The UE shall populate a new Security-Client header field within the REGISTER request and associated contact address, set to specify the security mechanism it supports, the IPsec layer algorithms for integrity and onfidentiality protection it supports and the parameters needed for the new security association setup.',
    'NG' => 'The UE shall populate a new Security-Client header field within the REGISTER request and associated contact address, set to specify the security mechanism it supports, the IPsec layer algorithms for integrity and onfidentiality protection it supports and the parameters needed for the new security association setup.',
    'EX' => \q{(CtFlv('HD,#Security-Client,mechanism,#Mechanism,name',@_) ne "")
        	   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_) ne "")
        	   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',@_) ne
        	       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',
        		     CtRlCxUsr(@_)->{'reg_ini'}))		    
        	   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',@_) ne
        	       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',
        		     CtRlCxUsr(@_)->{'reg_ini'}))
        	   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',@_) ne 
        	       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',
        		     CtRlCxUsr(@_)->{'reg_ini'}))
        	   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_) eq 
        	       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',
        		     CtRlCxUsr(@_)->{'reg_ini'}))
                   && CtFlv('HD,#Contact,c-params,addr,uri,host',@_) eq CtFlv('HD,#Contact,c-params,addr,uri,host',CtRlCxUsr(@_)->{'reg_ini'})
    }
},
#                   

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-147)
### written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-252',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'A temporary set of security associations SHALL not be created.',
    'NG' => 'A temporary set of security associations SHALL not be created.',
    'EX' => sub{
	my($pkt)=@_;
        my($dstport,$srcport,$spi,$portpc,$portls,$spils);
	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$srcport = CtFlGet('INET,#UDP,SrcPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};
	$reg_ini = CtRlCxUsr(@_)->{'reg_ini'};
	$reg_nego = CtRlCxUsr(@_)->{'reg_nego'};

	$portpc = CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic', $reg_ini);
        $portls = CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic', $reg_nego);
	$spils = CtFlv('HD,#Security-Server,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic', $reg_nego);

        if(($spi eq $spils)
	    && ($dstport eq $portls)
	    && ($srcport eq $portpc)){
	    return 'OK'
	    };
    }
},


### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-256',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'Another REGISTER request SHALL be sent containing an Authorization header field.',
    'NG' => 'Another REGISTER request SHALL be sent containing an Authorization header field.',
    'EX' => \q{CtUtIsExistHdr('Authorization', @_)},
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-257',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OD' => 'LAST',
    'OK' => \\'Authorization header fields are populated as defined for the initial registration, with the addition that the header field SHALL be populated a challenge response(%s) calculated(%s) as indicated in RFC 2617(MD5/qop=auth), i.e. \"cnonce\", \"qop\", and \"nonce-count\" header field parameters.',
    'NG' => \\'Authorization header fields are populated as defined for the initial registration, with the addition that the header field SHALL be populated a challenge response(%s) calculated(%s) as indicated in RFC 2617(MD5/qop=auth), i.e. \"cnonce\", \"qop\", and \"nonce-count\" header field parameters.',
    'EX' => sub{
	my ($hexST, $context) = @_;
	my $username = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,username',@_);
	my $realm = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,realm',@_);
	my $nonce = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,nonce',@_);
	my $uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,uri',@_);
	my $qop = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,qop',@_);
	my $nc = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,nc',@_);
	my $cnonce = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,cnonce',@_);
	my $response = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,response',@_);

	my $username0 = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,username',CtRlCxUsr(@_)->{'reg_ini'});
	my $realm0 = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,realm',CtRlCxUsr(@_)->{'reg_ini'});
	my $uri0 = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,uri',CtRlCxUsr(@_)->{'reg_ini'});

	my $result = 'OK'; 

        # 
        $result = '' unless(CtUtIsExistHdr('Authorization', @_));
 
        # 
        my $response0 = CtUtAuthDigestMD5($username,
                                          $realm,
                                          CtTbl('UC,DigestAuth,password',CtTbPrm('CI,target,TARGET')),
                                          'REGISTER',
                                          $uri,
                                          $nonce,
                                          $nc,
                                          $cnonce,
                                          $qop);

        # 1:
	$result = '' if(CtRlSyntaxResult(SvRl226_257_RuleSet(CtRlCxUsr(@_)->{'regflag'}),$context) ne 'OK');
        $result = $result && ($username0 eq $username) && ($realm0 eq $realm) && ($uri0 eq $uri) && 
            (lc($response) eq lc($response0)) && $nonce && $cnonce && $qop && $nc;
        CtRlSetEvalResult($context,'2op','',$result,$response,$response0);
        return $result;
        return $result && ($username0 eq $username) && ($realm0 eq $realm) && ($uri0 eq $uri) &&  $nonce && $cnonce && $qop && $nc;
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-258',
    'CA' => 'Call-ID',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'Call-ID(%s) of REGISTER request which carries the authentication challenge response SHALL be set to the same value as the Call-ID(%s) of the 401 (Unauthorized) response which carried the challenge.',
    'NG' => \\'Call-ID(%s) of REGISTER request which carries the authentication challenge response SHALL be set to the same value as the Call-ID(%s) of the 401 (Unauthorized) response which carried the challenge.',
    'EX' => sub{
        my($msg,$Call_ID,$Last_CallID);
        $Call_ID = CtFlv('HD,#Call-ID,call-id',@_);
        $Last_CallID = CtFlv('HD,#Call-ID,call-id',CtUtLastSndMsg());
        CtUtEq($Call_ID,$Last_CallID,@_);
    }
},

### 
###               Require
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-259',
    'CA' => 'Security',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The REGISTER request SHALL not include Security-Client,  Security-Verify header field and both a Require and Proxy-Require header fields with the value "sec-agree"  if SIP digest without TLS is used.',
    'NG' => 'The REGISTER request SHALL not include Security-Client,  Security-Verify header field and both a Require and Proxy-Require header fields with the value "sec-agree"  if SIP digest without TLS is used.',
    'EX' => sub{
	my @req_options = split(/,/, CtFlv('HD,#Require,option',@_));  
	my @pxreq_options = split(/,/, CtFlv('HD,#Proxy-Require,option',@_));
        return !CtUtIsExistHdr('Security-Client', @_) && 
            !CtUtIsExistHdr('Security-Verify', @_) && 
            (!grep{$_ =~ /sec-agree/i}(@req_options)) && 
            (!grep{$_ =~ /sec-agree/i}(@pxreq_options));
    }
},

### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-260',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'UE SHALL authenticate the S-CSCF using the "rspauth" Authentication-Info header field parameter as described in RFC 2617, if the "algorithm" Authentication-Info header field parameter is "MD5" in 200 (OK) response.',
    'NG' => 'UE SHALL authenticate the S-CSCF using the "rspauth" Authentication-Info header field parameter as described in RFC 2617, if the "algorithm" Authentication-Info header field parameter is "MD5" in 200 (OK) response.',
    'EX' => '',
},

### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-261',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The registration SHALL be considered to have failed if 403 (Forbidden) response is received.',
    'NG' => 'The registration SHALL be considered to have failed if 403 (Forbidden) response is received.',
    'EX' => '',
},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-148)
### written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-273',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'The REGISTER request SHALL be only sent to two consecutive invalid challenges and SHALL not be automatically sent authentication after two consecutive failed attempts to authenticate.',
    'NG' => 'The REGISTER request SHALL be only sent to two consecutive invalid challenges and SHALL not be automatically sent authentication after two consecutive failed attempts to authenticate.',
},

### Judgment rule for 'Message'
###(Basis for a determination : TS24229-5.1-140)
### written by suyama (2009.2.19)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-278',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'The UE SHALL use the expiry attribute within the <contact> sub-element that the UE registered to adjust the expiration time for that public user identity.',
    'NG' => 'The UE SHALL use the expiry attribute within the <contact> sub-element that the UE registered to adjust the expiration time for that public user identity.',
},

### 
### 
### 'S.TS24229-5.1-153'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-290',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'The REGISTER request SHALL be protected using a security association established as a result of an earlier registration.',
    'NG' => 'The REGISTER request SHALL be protected using a security association established as a result of an earlier registration.',
    'EX' => sub{
	my($pkt)=@_;
        my($sa_nego,$dstport,$srcport,$spi,$portpc,$portls,$spils);
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$srcport = CtFlGet('INET,#UDP,SrcPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};
	$portpc = CtSecNego($sa_nego,'port_pc');
	$portls = CtSecNego($sa_nego,'port_ls');
	$spils = CtSecNego($sa_nego,'spi_ls');

        if(($spi eq $spils)
	    && ($dstport eq $portls)
	    && ($srcport eq $portpc)){
	    return 'OK'
	    };
    }
},

### Judgment rule for 'Message'
###(Basis for a determination : TS24229-5.1-160)
### written by suyama (2009.2.25)
### 
###               
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-292',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'All dialogs related to the public user identity that is going to be deregistered or to one of the implicitly registered public user identities SHALL be released prior to sending a REGISTER request for deregistration.',
    'NG' => 'All dialogs related to the public user identity that is going to be deregistered or to one of the implicitly registered public user identities SHALL be released prior to sending a REGISTER request for deregistration.',
    'EX' => \q{(CtFlv('SL,method',@_) eq 'BYE')}
},

### Judgment rule for 'Message'
###(Basis for a determination : TS24229-5.1-161)
### written by suyama (2009.2.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-293',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'The dialog SHALL not be released if the dialog that was established by the UE subscribing to the reg event package used the public user identity and the dialog is the only remaining dialog used for subscription to reg event package.',
    'NG' => 'The dialog SHALL not be released if the dialog that was established by the UE subscribing to the reg event package used the public user identity and the dialog is the only remaining dialog used for subscription to reg event package.',
},
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-294',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'The dialog SHALL not be released if the dialog that was established by the UE subscribing to the reg event package used the public user identity and the dialog is the only remaining dialog used for subscription to reg event package.',
    'NG' => 'The dialog SHALL not be released if the dialog that was established by the UE subscribing to the reg event package used the public user identity and the dialog is the only remaining dialog used for subscription to reg event package.',
},
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-295',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'The dialog SHALL not be released if the dialog that was established by the UE subscribing to the reg event package used the public user identity and the dialog is the only remaining dialog used for subscription to reg event package.',
    'NG' => 'The dialog SHALL not be released if the dialog that was established by the UE subscribing to the reg event package used the public user identity and the dialog is the only remaining dialog used for subscription to reg event package.',
},

### 
### 
### 'S.TS24229-5.1-31'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-296',
    'CA' => 'From',
    'ET' => 'error',
    'OK' => \\'From header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'NG' => \\'From header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'EX' => sub {
	my ($node,$uri,$rcv_from);
	$node = CtTbPrm('CI,target,TARGET');               #

	$uri = CtTbl('UC,UserProfile,PublicUserIdentity',$node);
	$rcv_from = CtFlv('HD,#From,addr,uri,#TXT#', @_);

	CtUtEq($rcv_from,$uri,@_);
    },
},

### 
### 
###  'S.TS24229-5.1-32'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-297',
    'CA' => 'To',
    'ET' => 'error',
    'OK' => \\'To header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'NG' => \\'To header field(%s) SHALL be set to the SIP URI(%s) that contains the public user identity to be registered or deregistered.',
    'EX' => sub {
	my ($node,$uri,$rcv_from);
	$node = CtTbPrm('CI,target,TARGET');               #

	$uri = CtTbl('UC,UserProfile,PublicUserIdentity',$node);
	$rcv_to = CtFlv('HD,#To,addr,uri,#TXT#', @_);

	CtUtEq($rcv_to,$uri,@_);
    },
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-298',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'SIP URI(s) that contain(s) in the hostport parameter the IP address of the UE or FQDN SHALL be included in Contact header field.',
    'NG' => 'SIP URI(s) that contain(s) in the hostport parameter the IP address of the UE or FQDN SHALL be included in Contact header field.',
    'EX' =>  sub {
	my($uris,$rcv_port,$port);
	# 
#	if( CtFlv('HD,#Contact,c-params,#STAR,star',@_) ){return 'OK'}
	unless($uris=CtFlv('HD,#Contact,c-params,#ContactParam,addr,#Name#',@_)){
	    return;
	}
	$uris =[$uris] unless(ref($uris));
	if( grep{$_ ne 'NameAddr' && $_ ne 'AddrSpec'}(@$uris) ){
	    return;
	}
	unless($uris=CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#Name#',@_)){
	    return;
	}
	$uris =[$uris] unless(ref($uris));
	if( grep{!$_ || $_ eq 'AbsoluteUri'}(@$uris) ){
	    return;
	}
        return 'OK';
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-300',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The IP address or FQDN of the UE SHALL be included in Via header field.',
    'NG' => 'The IP address or FQDN of the UE SHALL be included in Via header field.',
    'EX' => sub{
	my ($sentby);

	# sentby
	#   
	#   
	unless( $sentby = CtFlv('HD,#Via,records,#ViaParm,sentby,host',@_) ){
	    return;
	}
	$sentby = [$sentby] unless(ref($sentby));
	if(grep{!$_}(@$sentby)){ return }
	return 'OK';
    }
},

### Judgment rule for 'expires'
###(Basis for a determination : TS24229-5.1-171)
###                       (
### written by suyama (2008.1.17)
### suyama modified(2009.2.17)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-301',
    'CA' => 'expires',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) eq 'REGISTER')},
    'OK' => \\'Expires Header or the expires parameter(%s) of the Contact header field SHALL be set to the value of zero.',
    'NG' => \\'Expires Header or the expires parameter(%s) of the Contact header field SHALL be set to the value of zero.',
    'EX' => sub{
	my($contact, $expires) = '';

	$contact = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,host',@_);
	if (CtUtEq($contact,'',@_)) {
	    $contact = CtFlv('HD,#Contact,c-params,#STAR,star',@_);
	}

	if (!CtUtEq($contact,'*',@_)) {
	    $expires = CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires',@_);
	}
	if (CtUtEq($expires,'',@_)) {
	    $expires = CtFlv('HD,#Expires,seconds',@_);
	}

	if (CtUtEq($expires,0,@_)) {
	    return 'OK';
	}
	return;
    }
},

### 
### 
###  'S.TS24229-5.1-41'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-302',
    'CA' => 'Request-URI',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => \\'Request-URI(%s) SHALL be set to the SIP URI(%s) of the domain name of the home network.',
    'NG' => \\'Request-URI(%s) SHALL be set to the SIP URI(%s) of the domain name of the home network.',
    'EX' => sub {
	my ($node,$rcv_uri,$uri);
	
	$node = CtTbPrm('CI,target,TARGET');
	$rcv_uri = CtFlv('SL,uri,host', CtRlCxPkt(@_));
	$uri = CtTbl('UC,UserProfile,HomeNetwork',$node);
	
	CtUtEq($rcv_uri,$uri,@_);
    },  
},

### 
### 
###  'S.TS24229-5.1-190'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-320',
    'CA' => 'Security-Client',
    'ET' => 'error',
    'OK' => 'Security-Client header field SHALL be set to the security mechanism it supports, the IPsec layer algorithms for integrity and confidentiality protection it supports and the new parameter values needed for the setup of two new pairs of security associations.',
    'NG' => 'Security-Client header field SHALL be set to the security mechanism it supports, the IPsec layer algorithms for integrity and confidentiality protection it supports and the new parameter values needed for the setup of two new pairs of security associations.',
    'EX' => \q{(CtFlv('HD,#Security-Client,mechanism,#Mechanism,name',@_) ne "")
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_) ne "")
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',@_) ne
		       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',
			     CtRlCxUsr(@_)->{'reg_ini'}))		    
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',@_) ne
		       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',
			     CtRlCxUsr(@_)->{'reg_ini'}))
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',@_) ne 
		       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',
			     CtRlCxUsr(@_)->{'reg_ini'}))
		   && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_) eq 
		       CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',
			     CtRlCxUsr(@_)->{'reg_ini'}));
	   }

},	      

### Judgment rule for 'Security-Verify'
###(Basis for a determination : TS24229-5.1-174)
###   written by suyama (2008.1.17)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-322',
    'CA' => 'Security-Verify',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => 'The Security-Verify header field SHALL be set to last recieved 401 (Unauthorized)response value.',
    'NG' => 'The Security-Verify header field SHALL be set to last recieved 401 (Unauthorized)response value.',
    'EX' =>  \q{(CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,name',@_),CtSecNego('','mech','P-CSCFa1'),@_))	 
        	    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_),
        		       CtSecNego('','alg','P-CSCFa1'),@_))
        	    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic',@_)||'null',
        		       CtSecNego('','ealg','P-CSCFa1')||'null',@_))
        	    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',@_),
        		       CtSecNego('','spi_lc','P-CSCFa1'),@_))
        	    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',@_),
        		       CtSecNego('','spi_ls','P-CSCFa1'),@_))
        	    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',@_),
        		       CtSecNego('','port_lc','P-CSCFa1'),@_))
        	    && (CtUtEq(CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_),
        		       CtSecNego('','port_ls','P-CSCFa1'),@_))
        	}
},

### Judgment rule for 'Message'
###(Basis for a determination : TS24229-5.1-177)
###   written by suyama (2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-310',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'All registration details relating to the public user identity SHALL be removed when UE received the 200 (OK) response to the REGISTER request.',
    'NG' => 'All registration details relating to the public user identity SHALL be removed when UE received the 200 (OK) response to the REGISTER request.',
},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-178)
###   written by suyama (2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-311',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'The security associations SHALL be deleted by UE if there are no more public user identities registered.',
    'NG' => 'The security associations SHALL be deleted by UE if there are no more public user identities registered.',
},

### Judgment rule for 'Message'
###(Basis for a determination : TS24229-5.1-180)
###   written by suyama (2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-312',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'The subscription to the reg event package SHALL be considered cancelled if all public user identities are deregistered and the security association is removed.',
    'NG' => 'The subscription to the reg event package SHALL be considered cancelled if all public user identities are deregistered and the security association is removed.',
},

### 
### 
###  'S.TS24229-5.1-69'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-313',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'NG' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#UserName,username',@_), 
                      CtTbl('UC,UserProfile,PrivateUserIdentity',CtTbPrm('CI,target,TARGET')),@_)},
},

### 
### 
###  'S.TS24229-5.1-184'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-314',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value as received in the realm directive in the WWW-Authenticate header field(%s).',
    'NG' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value as received in the realm directive in the WWW-Authenticate header field(%s).',
    'EX' => sub{
	my($fl_realm) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Realm,realm',@_);
	my($fl_res) = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,#Realm,realm',CtRlCxUsr(@_)->{'reg_nego'});

	if (CtUtEq($fl_realm,$fl_res,@_)){
	    return 'OK';
	}
	return '';
    }
},

### 
### 
### 
###  'S.TS24229-5.1-71'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-315',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'NG' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'EX' => sub{
	my($node,$uri,$sipuri);

	$node = CtTbPrm('CI,target,TARGET');               #
	$uri = CtTbl('UC,UserProfile,HomeNetwork',$node); 
	$sipuri = "sip:$uri";

        #
#        $iv_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,tag`$V eq uri`,uri',@_);
	$cl_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,uri',@_);
	if (CtUtEq($cl_uri,$sipuri,@_)){
	    return 'OK';
        }
    }
},

### 
### 
###  'S.TS24229-5.1-186'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-316',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => \\'The nonce directive(%s) in Authorization header field SHALL be set to last received nonce value(%s).',
    'NG' => \\'The nonce directive(%s) in Authorization header field SHALL be set to last received nonce value(%s).',
    'EX' => sub{
	my($fl_nonce) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Nonce,nonce',@_);
	my($fl_res) = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,#Nonce,nonce',CtRlCxUsr(@_)->{'reg_nego'});

	#
	my($fl_mac) = CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,#Nonce,nonce',CtUtLastSndMsg());
	my($auth_err) = CtRlCxUsr(@_)->{'reg_nego'};

	if ($auth_err ne ''){
	    if(CtUtEq($fl_nonce,$fl_mac,@_)){
		return 'OK';
	}else{
	    if(CtUtEq($fl_nonce,$fl_res,@_)){
		return 'OK';
	    }
	}
	return '';
	}
    }
},

### 
### 
###  'S.TS24229-5.1-187'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-317',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => \\'The response directive(%s) in Authorization header field SHALL be set to the last calculated response value(%s).',
    'NG' => \\'The response directive(%s) in Authorization header field SHALL be set to the last calculated response value(%s).',
    'EX' => sub{
	my($fl_resp) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',@_);
	my($fl_res) = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',CtRlCxUsr(@_)->{'reg_auth'});   
	if (CtUtEq($fl_resp,$fl_res,@_)){
	    return 'OK';
	}
	return '';
    }   
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-318',
    'CA' => 'Contact',
    'ET' => 'error',
    'OK' => \\'Contact header field(%s) SHALL be set to the protected server port value(%s) bound to the security association.',
    'NG' => \\'Contact header field(%s) SHALL be set to the protected server port value(%s) bound to the security association.',
    'EX' =>  sub {
        my $rcv_port;
	#
	unless( $rcv_port = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,port',@_) ){
	    return;
	}
	$rcv_port =[$rcv_port] unless(ref($rcv_port));
	my $port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps');
	my $result = (grep{$_ ne $port}(@$rcv_port)) ? '' : 'OK';
	CtRlSetEvalResult(@_[1],'2op','',$result,$rcv_port,$port);
        return $result;
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-319',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The protected server port value for the UDP SHALL be included in Via header field.',
    'NG' => 'The protected server port value for the UDP SHALL be included in Via header field.',
    'EX' => sub{
	# UDP
	if( CtFlGet('INET,#UDP',@_[0]) ){    
	    my $port = CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'port_ps');
	    my $via_port = CtFlv('HD,#Via,records,#ViaParm,sentby,port', @_);
	    if(!$via_port){return}
	    $via_port =[$via_port] unless(ref($via_port));
	    return (grep{$_ ne $port}(@$via_port)) ? '' : 'OK';
	}
	return 'OK';
    }
},

### 
### 
### 
###  'S.TS24229-5.1-69'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-323',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'NG' => \\'The username directive(%s) in Authorization header field SHALL be set to the value of the private user identity(%s).',
    'EX' => \q{CtUtEq(CtFlv("HD,#Authorization,credentials,credential,digestresp,list,username",@_),
                      CtTbl('UC,UserProfile,PrivateUserIdentity',CtTbPrm('CI,target,TARGET')),@_)},
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-324',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value of the domain name of the home network(%s).',
    'NG' => \\'The realm directive(%s) in Authorization header field SHALL be set to the value of the domain name of the home network(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Realm,realm',@_),
                      CtTbl('UC,UserProfile,HomeNetwork',CtTbPrm('CI,target,TARGET')),@_)}
},

### 
### 
### 
###  'S.TS24229-5.1-71'
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-325',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'NG' => \\'The uri directive(%s) in Authorization header field SHALL be set to the SIP URI of the domain name of the home network(%s).',
    'EX' => sub{
	my($node,$uri,$sipuri);

	$node = CtTbPrm('CI,target,TARGET');               #
	$uri = CtTbl('UC,UserProfile,HomeNetwork',$node); 
	$sipuri = "sip:$uri";

        #
#        $iv_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,tag`$V eq uri`,uri',@_);
	$cl_uri = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,uri',@_);
	if (CtUtEq($cl_uri,$sipuri,@_)){
	    return 'OK';
        }
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-326',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The nonce directive in Authorization header field SHALL be empty.',
    'NG' => 'The nonce directive in Authorization header field SHALL be empty.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Nonce,nonce',@_),'',@_)}
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-327',
    'CA' => 'Authorization',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The response directive in Authorization header field SHALL be empty.',
    'NG' => 'The response directive in Authorization header field SHALL be empty.',
    'EX' => sub{
	my($iv_rs,$cl_rs);
	#response
	$iv_rs = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#AuthParam,tag`$V eq response`,auth',@_);
	$cl_rs = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',@_);
	if (($iv_rs eq "\"\"") && ($cl_rs eq '')){return 'OK';}}
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-328',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The port value in Contact header field SHALL be set to the associated unprotected port value (where the UE was expecting to receive mid-dialog requests).',
    'NG' => 'The port value in Contact header field SHALL be set to the associated unprotected port value (where the UE was expecting to receive mid-dialog requests).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,port',@_),CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET'),@_))},
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-329',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The port value in Via header field SHALL be set to an unprotected port where the UE expects to receive responses to the request.',
    'NG' => 'The port value in Via header field SHALL be set to an unprotected port where the UE expects to receive responses to the request.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Via#0,records,#ViaParm#0,sentby,port',@_),CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET')),@_)},
},

### Judgment rule for 'Message'
###(Basis for a determination : TS24229-5.1-183)
###   written by suyama (2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-343',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'All dialogs related to those public user identities SHALL be relaesed when the event attribute is set to"rejected".',
    'NG' => 'All dialogs related to those public user identities SHALL be relaesed when the event attribute is set to"rejected".',
},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-184)
###   written by suyama (2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-344',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'The UE SHALL delete the security associations towards the P-CSCF if all <registration> element(s) have their state attribute set to "terminated".',
    'NG' => 'The UE SHALL delete the security associations towards the P-CSCF if all <registration> element(s) have their state attribute set to "terminated".',
    'EX' => sub{
	$sa = CtFindSAfromPkt(@_);
	if ($sa eq ''){
	    return 'OK'
	    }
	return '';
    } 
},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-185)
###   written by suyama (2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-345',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'The UE SHALL delete the security associations towards the P-CSCF if each <registration> element that was registered by this UE has either the state attribute set to "terminated", or the state attribute set to "active" and the state attribute within the <contact> element belonging to this UE set to "terminated".',
    'NG' => 'The UE SHALL delete the security associations towards the P-CSCF if each <registration> element that was registered by this UE has either the state attribute set to "terminated", or the state attribute set to "active" and the state attribute within the <contact> element belonging to this UE set to "terminated".',
    'EX' => sub{return !CtFindSAfromPkt(@_) ? 'OK' : ''},
},

### Judgment rule for 'Security'
###(Basis for a determination : TS24229-5.1-186)
###   written by suyama (2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-346',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'The UE SHALL delete these security associations towards the P-CSCF after the server transaction pertaining to the received NOTIFY request terminates.',
    'NG' => 'The UE SHALL delete these security associations towards the P-CSCF after the server transaction pertaining to the received NOTIFY request terminates.',
    'EX' => sub{
	$sa = CtFindSAfromPkt(@_);
	if ($sa eq ''){
	    return 'OK'
	    }
	return '';
    }
},

### Judgment rule for 'Retry-After'
###(Basis for a determination : TS24229-5.1-194)
### written by suyama (09/2/16 suyama)
### 
### 
{
    'TY'=> 'SYNTAX', 
    'ID'=> 'S.TS24229-5.1-354', 
    'CA'=> 'Message', 
    'ET'=> 'error',
    'OK'=> \\'The request SHALL not be automatically sent until after the period indicated by the Retry-After header field.',
    'NG'=> \\'The request SHALL not be automatically sent until after the period indicated by the Retry-After header field.'
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-355',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#GenericParam,tag',@_) ne 'gruu'},
    'OK' => \\'UE SHALL populate the Contact header field of the request with the protected server port(%s) and the respective contact address(%s) if the UE has not obtained a GRUU and IMS AKA is being used.',
    'NG' => \\'UE SHALL populate the Contact header field of the request with the protected server port(%s) and the respective contact address(%s) if the UE has not obtained a GRUU and IMS AKA is being used.',
    'EX' => sub{
	my($port,$rv_port,$sa_nego,$contactParam);
        $contactParam=CtFlv('HD,#Contact,c-params,#ContactParam,addr', @_);
        unless($contactParam){return}
        
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$port = CtSecNego($sa_nego,'port_ps');

        my $result = (($contactParam->{'uri'}->{'userinfo'}.'@'.$contactParam->{'uri'}->{'host'} eq
                       CtTbl('UC,SecContactURI', CtTbPrm('CI,target,TARGET'))->{'host'}) &&
                      ($port eq $contactParam->{'uri'}->{'port'}));
        CtRlSetEvalResult(@_[1],'2op','',$result,$port.':'.$contactParam->{'uri'}->{'port'},
                          $contactParam->{'uri'}->{'userinfo'}.'@'.$contactParam->{'uri'}->{'host'}.':'.
                          CtTbl('UC,SecContactURI', CtTbPrm('CI,target,TARGET'))->{'host'});
        return $result;
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-356',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{((CtFlv('SL,method',@_[0]) ne 'REGISTER') 
                && CtFindSAfromPkt(@_)		  
                && CtFlGet('INET,#UDP',@_[0]))}, 
	'OK' => 'The protected server port and the respective contact address SHALL be included in the Via header entry relating to the UE if the has not obtained a GRUU and IMS AKA is being used.',
	'NG' => 'The protected server port and the respective contact address SHALL be included in the Via header entry relating to the UE if the has not obtained a GRUU and IMS AKA is being used.',
	'EX' => sub{
	    my ($hexST, $context) = @_;
	    my ($port,$via_port);
	    my ($result) = 'OK';
            # sentby
            #   
            #   
            unless( $sentby = CtFlv('HD,#Via#0,records,#ViaParm#0,sentby,host',@_) ){
                return;
            }
            if(CtUtIp($sentby)){
                if (CtTbPrm('CI,protocol') eq 'INET6') {
                    $sentby =~ s/\[(.+)\]/$1/;
                    if (!CtUtV6Eq($sentby, CtTbAd('local-ip', CtTbPrm('CI,target,TARGET')))) {
                        return '';
                    }
                }
                else {
                    if (!CtUtV4Eq($sentby, CtTbAd('local-ip', CtTbPrm('CI,target,TARGET')))) {
                        return '';
                    }
                }
            }
            else{
                my $fqdn = CtTbCfg(CtTbPrm('CI,target,TARGET'),'contact-host');
                my ($name,$host)=split('@',$fqdn);
                if($host ne $sentby){return}
            }

	    $sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	    $via_port = CtFlv('HD,#Via#0,records,#ViaParm#0,sentby,port', $hexST);
	    $port = CtSecNego($sa_nego,'port_ps');
            return $via_port eq $port;
	}
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-357',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#GenericParam,tag',@_) ne 'gruu'},
    'OK' => 'UE SHALL populate the Contact header field of the request with  the port value of an unprotected port and the contact address where the UE expects to receive subsequent mid-dialog requests if the UE has not obtained a GRUU and SIP digest without TLS is being used.',
    'NG' => 'UE SHALL populate the Contact header field of the request with  the port value of an unprotected port and the contact address where the UE expects to receive subsequent mid-dialog requests if the UE has not obtained a GRUU and SIP digest without TLS is being used.',
    'EX' => sub{
	my($port,$contactParam);
        $contactParam=CtFlv('HD,#Contact,c-params,#ContactParam,addr', @_);
        unless($contactParam){return}
        
	$port = CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET'));
	
	if (CtUtEq($contactParam->{'uri'}->{'userinfo'}.'@'.$contactParam->{'uri'}->{'host'},
                   CtTbl('UC,SecContactURI', CtTbPrm('CI,target,TARGET'))->{'host'},@_) &&
            CtUtEq($port,$contactParam->{'uri'}->{'port'},@_)){
	    return 'OK';
	}else{
	    return ''; #NG	               
	}
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-358',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{((CtFlv('SL,method',@_[0]) ne 'REGISTER') && CtFlGet('INET,#UDP',@_[0]))}, 
	'OK' => 'UE SHALL populate the Via header field of the request with the port value of an unprotected port and the respective contact address where the UE expects to receive responses to the request if the has not obtained a GRUU and IMS AKA is being used.',
	'NG' => 'UE SHALL populate the Via header field of the request with the port value of an unprotected port and the respective contact address where the UE expects to receive responses to the request if the has not obtained a GRUU and IMS AKA is being used.',
	'EX' => sub{
	    my ($hexST, $context) = @_;
	    my ($port,$via_port);
	    my ($result) = 'OK';
            # sentby
            #   
            #   
            unless( $sentby = CtFlv('HD,#Via#0,records,#ViaParm#0,sentby,host',@_) ){
                return;
            }
            if(CtUtIp($sentby)){
                if (CtTbPrm('CI,protocol') eq 'INET6') {
                    $sentby =~ s/\[(.+)\]/$1/;
                    if (!CtUtV6Eq($sentby, CtTbAd('local-ip', CtTbPrm('CI,target,TARGET')))) {
                        return '';
                    }
                }
                else {
                    if (!CtUtV4Eq($sentby, CtTbAd('local-ip', CtTbPrm('CI,target,TARGET')))) {
                        return '';
                    }
                }
            }
            else{
                my $fqdn = CtTbCfg(CtTbPrm('CI,target,TARGET'),'contact-host');
                my ($name,$host)=split('@',$fqdn);
                if($host ne $sentby){return}
            }

	    $via_port = CtFlv('HD,#Via#0,records,#ViaParm#0,sentby,port', $hexST);
            $port = CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET'));
            return $via_port eq $port;
	}
},

### 
###               Require
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-363',
    'CA' => 'Security',
    'ET' => 'error',
    'OK' => 'Security-Client,  Security-Verify header field and both a Require and Proxy-Require header fields with the value "sec-agree"  SHALL not be included in any SIP messages if SIP digest without TLS is used.',
    'NG' => 'Security-Client,  Security-Verify header field and both a Require and Proxy-Require header fields with the value "sec-agree"  SHALL not be included in any SIP messages if SIP digest without TLS is used.',
    'EX' => sub{
	my @req_options = split(/,/, CtFlv('HD,#Require,option',@_));  
	my @pxreq_options = split(/,/, CtFlv('HD,#Proxy-Require,option',@_));
        return !CtUtIsExistHdr('Security-Client', @_) && 
            !CtUtIsExistHdr('Security-Verify', @_) && 
            (!grep{$_ =~ /sec-agree/i}(@req_options)) && 
            (!grep{$_ =~ /sec-agree/i}(@pxreq_options));
    }
},

# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-367',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The UE SHALL discard any SIP request that is not protected by the security association and is received from the P-CSCF outside of the registration and authentication procedures.',
    'NG' => \\'The UE SHALL discard any SIP request that is not protected by the security association and is received from the P-CSCF outside of the registration and authentication procedures.',
    'EX' => '',
},


### Judgment rule for 'P-Preferred-Identity'
###(Basis for a determination : TS24229-5.1-204)
###                       (
### written by Inoue (2009.2.19)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-378',
    'CA' => 'P-Preferred-Identity',
    'ET' => 'error',
    'PR' => \q{(CtUtIsExistHdr('P-Preferred-Identity',@_) ne 0)},
    'OK' => \\'The P-Preferred-Identity header field(%s) SHALL be used as the public user identity for the request if a P-Preferred-Identity was included(%s).',
    'NG' => \\'The P-Preferred-Identity header field(%s) SHALL be used as the public user identity for the request if a P-Preferred-Identity was included(%s).',
    'EX' => sub{
        	my($rv_uri,$impu);
		$rv_uri = CtFlv('HD,#P-Preferred-Identity,ids,addr,uri,#TXT#',@_);
		$impu = CtFlv('HD,#From,addr,uri,#TXT#',@_);
		#

		CtUtEq($rv_uri,$impu,@_);
	    }
},

### Judgment rule for 'P-Preferred-Identity'
###(Basis for a determination : TS24229-5.1-205)
###                       (
### written by Inoue (2009.2.19)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-379',
    'CA' => 'P-Preferred-Identity',
    'ET' => 'error',
    'PR' => \q{(CtUtIsExistHdr('P-Preferred-Identity',@_) eq 0)},
    'OK' => \\'The default public user identity(%s) for the security association SHALL be used as the public user identity(%s) for the request if no P-Preferred-Identity was included.',
    'NG' => \\'The default public user identity(%s) for the security association SHALL be used as the public user identity(%s) for the request if no P-Preferred-Identity was included.',
    'EX' => sub{
	my($df_uri,$impu);
	$df_uri = CtTbCfg(CtTbPrm('CI,target,TARGET'),'public-user-id');
	#P-Associated-URI
	
	$impu = CtFlv('HD,#From,addr,uri,#TXT#',@_);
	#
	
	CtUtEq($df_uri,$impu,@_);
    }
},

### 
### 
### 
###           Contact
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-386',
    'CA' => 'Contact',
    'ET' => 'error',
    'OK' => \\'The UE SHOULD insert the previously used Contact header field(%s) in Contact header field(%s).',
    'NG' => \\'The UE SHOULD insert the previously used Contact header field(%s) in Contact header field(%s).',
    'EX' => sub{
	my $dlg = CtRlCxDlg(@_);
	my $reg_contact = CtSvDlg($dlg,'RemoteTarget'); #
	my $sub_contact = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#TXT#',@_); #
        return CtUtEq($sub_contact,$reg_contact,@_);       
    }
},

### Judgment rule for 'P-Access-Network-Info'
###(Basis for a determination : TS24229-5.1-221)
### written by Inoue (2009.3.13)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-396',
    'CA' => 'P-Access-Network-Info',
    'ET' => 'error',
    'OK' => 'UE SHALL insert a P-Access-Network-Info header into any request for a dialog, any subsequent request (except ACK requests and CANCEL requests) or response (except CANCEL resopnses) within a dialog or any request for a standalone method.',
    'NG' => 'UE SHALL insert a P-Access-Network-Info header into any request for a dialog, any subsequent request (except ACK requests and CANCEL requests) or response (except CANCEL resopnses) within a dialog or any request for a standalone method.',
    'EX' => \q{CtUtIsExistHdr('P-Access-Network-Info', @_)},
},


### Judgment rule for 'Route'
###(Basis for a determination : TS24229-5.1-223)
###                       (
### written by orimo (2008.1.17)
### suya modified. (2009.2.12)
### 
### 
### TS24229-5.1-218
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-398',
    'CA' => 'Route',
    'ET' => 'error',
    'OK' => \\'A proper preloaded Route header value(%s) SHALL be built in Route header(%s) for all new dialogs and standalone transactions.',
    'NG' => \\'A proper preloaded Route header value(%s) SHALL be built in Route header(%s) for all new dialogs and standalone transactions.',
    'EX' => sub{
	my ($sr,$scscf,$node,$sr1,$sr2);
        $node = CtRlCxUsr(@_)->{'scscf'} || 'S-CSCFa1';
	$sr1 = CtSvGenRecRoute('InvitePath', 'UEa1', 'P-CSCFa1', 0, 1);
	$sr2 = CtTbl('UC,ServiceRoute', $node);
	if (ref($sr2) eq 'ARRAY') {
	    $sr2 = join(',', @$sr2);
	}
	$sr = join(',', $sr1, $sr2);
	$rvPk = CtFlv('HD,#Route,#REST#', @_);
	
	if ( ref($rvPk) eq 'ARRAY'){
	    $rvPk = join(',', @$rvPk);
	    $rvPk =~ s/ //g;
	}

	return CtUtEq($sr, $rvPk,@_);
    }
},
    
### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-400',
    'CA' => 'Route',
    'ET' => 'error',
    'OK' => 'A list of Route header values made out of the P-CSCF URI  containing the IP address or the FQDN learnt through the P-CSCF discovery procedure SHALL be built in Route header.',
    'NG' => 'A list of Route header values made out of the P-CSCF URI  containing the IP address or the FQDN learnt through the P-CSCF discovery procedure SHALL be built in Route header.',
    'EX' => sub{
	my ($scscf,$node,$sr1,$rvPk);
        $node = CtRlCxUsr(@_)->{'scscf'} || 'S-CSCFa1';
	$sr1 = CtSvGenRecRoute('InvitePath', 'UEa1', 'P-CSCFa1', 0, 1, 'noStr');
        $rvPk = CtFlv('HD,#Route,routes,#RouteParam,addr,uri,host', @_);

	if ( $sr1 && $rvPk ){
            $sr1 = [$sr1] unless(ref($sr1));
            $rvPk = [$rvPk] unless(ref($rvPk));
            my $host = $rvPk->[0];
            $host =~ s/^\[(.+)\]$/$1/;
            my $t1 = CtUtIPAdType($sr1->[0]->{'rr'}->{'host'});
            my $t2 = CtUtIPAdType($host);
            if(!$t1 || !$t2 || $t1 ne $t2){return $sr1->[0]->{'rr'}->{'host'} eq $host}
            return CtUtV6Eq($sr1->[0]->{'rr'}->{'host'}, $host);
	}
	return '';  # NG
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-402',
    'CA' => 'Route',
    'ET' => 'error',
    'OK' => 'A list of Route header values made out of the P-CSCF port  containing the protected server port learned during the registration procedure SHALL be built in Route header.',
    'NG' => 'A list of Route header values made out of the P-CSCF port  containing the protected server port learned during the registration procedure SHALL be built in Route header.',
    'EX' => sub{
	my ($scscf,$node,$sr1,$rvPk);
        $node = CtRlCxUsr(@_)->{'scscf'} || 'S-CSCFa1';
	$sr1 = CtSvGenRecRoute('InvitePath', 'UEa1', 'P-CSCFa1', 0, 1, 'noStr');
        $rvPk = CtFlv('HD,#Route,routes,#RouteParam,addr,uri,port', @_);

	if ( $sr1 && $rvPk ){
            $sr1 = [$sr1] unless(ref($sr1));
            $rvPk = [$rvPk] unless(ref($rvPk));
            if( CtUtEq($sr1->[0]->{'rr'}->{'port'}, $rvPk->[0]) ){
                return 'OK';
            }
	}
	return '';  # NG
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-403',
    'CA' => 'Route',
    'ET' => 'error',
    'OK' => 'A list of Route header values made out of the P-CSCF port  containing the unprotected server port learned during the registration procedure SHALL be built in Route header.',
    'NG' => 'A list of Route header values made out of the P-CSCF port  containing the unprotected server port learned during the registration procedure SHALL be built in Route header.',
    'EX' => sub{
	my ($scscf,$node,$sr1,$rvPk);
        $node = CtRlCxUsr(@_)->{'scscf'} || 'S-CSCFa1';
	$sr1 = CtSvGenRecRoute('InvitePath', 'UEa1', 'P-CSCFa1', 0, 1, 'noStr');
        $rvPk = CtFlv('HD,#Route,routes,#RouteParam,addr,uri,port', @_);

	if ( $sr1 && $rvPk ){
            $sr1 = [$sr1] unless(ref($sr1));
            $rvPk = [$rvPk] unless(ref($rvPk));
            if( CtUtEq($sr1->[0]->{'rr'}->{'port'}, $rvPk->[0]) ){
                return 'OK';
            }
	}
	return '';  # NG
    }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-404',
    'CA' => 'Route',
    'ET' => 'error',
    'OK' => 'A list of Route header values made out of the values received in the Service-Route header field saved from the 200 (OK) response to the last registration or re-registration of the public user identity with associated contact address SHALL be built in Route header.',
    'NG' => 'A list of Route header values made out of the values received in the Service-Route header field saved from the 200 (OK) response to the last registration or re-registration of the public user identity with associated contact address SHALL be built in Route header.',
    'EX' => sub{
	my ($sr,$scscf,$node,$sr2);
	$node = CtRlCxUsr(@_)->{'scscf'} || 'S-CSCFa1';
	$sr2 = CtTbl('UC,ServiceRoute', $node);
	if (ref($sr2) eq 'ARRAY') {
	    $sr2 = join(',', @$sr2);
	}

	$rvPk = CtFlv('HD,#Route,#REST#', @_);
	if ( ref($rvPk) eq 'ARRAY'){
	    $rvPk = join(',', @$rvPk);
	    $rvPk =~ s/ //g;
	}
	if ( $rvPk =~ /$sr2$/ ){
	    return 'OK';
	}
	return '';  # NG
    }
},

### Judgment rule for 'P-Access-Network-Info'
###(Basis for a determination : TS24229-5.1-229)
### written by Inoue (2009.3.13)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-418',
    'CA' => 'P-Access-Network-Info',
    'ET' => 'error',
    'OK' => 'UE SHALL insert a P-Access-Network-Info header into any response for a dialog, any subsequent request (except ACK requests and CANCEL requests) or response (except CANCEL resopnses) within a dialog or any request for a standalone method.',
    'NG' => 'UE SHALL insert a P-Access-Network-Info header into any response for a dialog, any subsequent request (except ACK requests and CANCEL requests) or response (except CANCEL resopnses) within a dialog or any request for a standalone method.',
    'EX' => \q{CtUtIsExistHdr('P-Access-Network-Info', @_)},
},

### 
# 504
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-424',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The UE SHALL initiate restoration procedures by performing an initial registration.',
    'NG' => 'The UE SHALL initiate restoration procedures by performing an initial registration.',
    'EX' => '',
},

# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-426',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The UE SHALL discard any SIP request that is not protected by the security association and is received from the P-CSCF outside of the registration and authentication procedures.',
    'NG' => \\'The UE SHALL discard any SIP request that is not protected by the security association and is received from the P-CSCF outside of the registration and authentication procedures.',
    'EX' => '',
},


### Judgment rule for 'Contact'
###(Basis for a determination : TS24229-5.1-243)
###                       (
###   written by Inoue (2008.1.21)
### 
### GRUU
#{
#    'TY' => 'SYNTAX',
#    'ID' => 'S.TS24229-5.1-248',
#    'CA' => 'Contact',
#    'ET' => 'error',
#    'PR' => \q{CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,host',@_) ne '*'},
#    'OK' => 'If the UE did not insert a GRUU in the Contact header, then the UE shall include the protected server port in the address in the Contact header.',
#    'NG' => 'If the UE did not insert a GRUU in the Contact header, then the UE shall include the protected server port in the address in the Contact header.',
#    'EX' =>  sub {
#    }
#},

### Judgment rule for 'Contact'
###(Basis for a determination : TS24229-5.1-248)
###                       (
### written by Inoue (2008.1.21)
### suyama modified (2009.2.18)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-444',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#GenericParam,tag',@_) ne 'gruu'},
    'OK' =>\\'The protected server port(%s) SHALL be included in the address in the Contact header field(%s) if UE did not insert a GRUU and IMS AKA is being used.',
    'NG' =>\\'The protected server port(%s) SHALL be included in the address in the Contact header field(%s) if UE did not insert a GRUU and IMS AKA is being used.',
    'EX' => sub{
	          my($port,$scport);
		     $port = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,port',@_);
		     $scport = CtSecNego('','port_ps');
		     if ($port && CtUtEq($scport,$port,@_)){
			 return 'OK';
		     }else{
			 return ''; #NG	               
		     }
		 }
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-445',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#GenericParam,tag',@_) ne 'gruu'},
    'OK' => \\'The port value of an unprotected port(%s) where the UE expects to receive subsequent mid-dialog requests SHALL be included in the address(%s) in the Contact header field if UE did not insert a GRUU and SIP digest without TLS is being used.',
    'NG' => \\'The port value of an unprotected port(%s) where the UE expects to receive subsequent mid-dialog requests SHALL be included in the address(%s) in the Contact header field if UE did not insert a GRUU and SIP digest without TLS is being used.',
    'EX' => sub{
        my($port,$scport);
        $port = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,port',@_);
        $scport = CtSecurityScheme() eq 'sipdigest' ?
            CtTbl('UC,ContactURI,port', CtTbPrm('CI,target,TARGET')):
            CtTbl('UC,SecContactURI,port', CtTbPrm('CI,target,TARGET'));
        return ($port && CtUtEq($scport,$port,@_));
    }
},

### Judgment rule for 'P-Access-Network-Info'
###(Basis for a determination : TS24229-5.1-249)
### written by Inoue (2009.4.6)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-447',
    'CA' => 'P-Access-Network-Info',
    'ET' => 'error',
    'OK' => 'UE SHALL insert a P-Access-Network-Info header into any response to a request for dialog, any subsequent request (except CANCEL requests) or response (except CANCEL resopnses) within a dialog or any response for a standalone method.',
    'NG' => 'UE SHALL insert a P-Access-Network-Info header into any response to a request for dialog, any subsequent request (except CANCEL requests) or response (except CANCEL resopnses) within a dialog or any response for a standalone method.',
    'EX' => \q{CtUtIsExistHdr('P-Access-Network-Info', @_)},
},

### 
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-454',
    'CA' => 'Accept',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The UE SHALL include the Accept header field with "application/sdp", the MIME type associated with the 3GPP IM CN subsystem XML body and any other MIME type the UE is willing and capable to accept, when generating an initial INVITE request',
    'NG' => 'The UE SHALL include the Accept header field with "application/sdp", the MIME type associated with the 3GPP IM CN subsystem XML body and any other MIME type the UE is willing and capable to accept, when generating an initial INVITE request',
    'EX' => sub{my $range=CtFlv('HD,#Accept,range', @_);return $range=~/application\/sdp/i && $range=~/application\/3gpp-ims\+xml/i},
},

# ACK
# UE-SE-B-10
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-468',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The UE SHALL acknowledge the response with an ACK request.',
    'NG' => \\'The UE SHALL acknowledge the response with an ACK request.',
    'EX' => '',
},


# BYE
# UE-SE-B-10
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-5.1-469',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'The UE SHALL send a BYE request to this dialog in order to terminate it.',
    'NG' => \\'The UE SHALL send a BYE request to this dialog in order to terminate it.',
    'EX' => '',
},

### Judgment rule for 'Retry-After'
###(Basis for a determination : TS24229-5.1-269)
### written by suyama (09/4/3 suyama)
### 
### 
{
    'TY'=> 'SYNTAX', 
    'ID'=> 'S.TS24229-5.1-474', 
    'CA'=> 'Message', 
    'ET'=> 'error',
    'OK'=> \\'The request SHALL not be sent until after the period indicated by the Retry-After header field when UE received a 503(Service Unavailable) response to an initial INVITE request containing a Retry-After header field.',
    'NG'=> \\'The request SHALL not be sent until after the period indicated by the Retry-After header field when UE received a 503(Service Unavailable) response to an initial INVITE request containing a Retry-After header field.',
},

## SDP Payload
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-6.1-3',
    'CA' => 'Body',
    'ET' => 'error',
    'PR' => '',
    'OK' => \\'Only SDP payload SHALL be contained in SIP message when the SDP payload must be included in the message.',
    'NG' => \\'Only SDP payload SHALL be contained in SIP message when the SDP payload must be included in the message.',
    'EX' => \q{CtFlp('BD', CtRlCxPkt(@_))},
},


#--------------------------------------------------------------------------------------------
# * b line
#      For "video" and "audio" media types that utilize the RTP/RTCP, 
#      the UE SHALL specify the proposed bandwidth for each media stream utilizing 
#      the "b=" media descriptor and the "AS" bandwidth modifier in the SDP.[TS24229-6.1-3]
#--------------------------------------------------------------------------------------------
# XXX: 
# XXX: 
### 20090205 ID name changed befor 6.1-3 after 6.1-4

{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-6.1-7',
    'CA' => 'b=',
    'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
    'OK' => \\'The proposed bandwidth for each media stream utilizing the \"b=\" media descriptor and the \"AS\" bandwidth modifier in the SDP SHALL be specified for \"video\" and \"audio\" media types that utilize the RTP/RTCP.',
    'NG' => \\'The proposed bandwidth for each media stream utilizing the \"b=\" media descriptor and the \"AS\" bandwidth modifier in the SDP SHALL be specified for \"video\" and \"audio\" media types that utilize the RTP/RTCP.',
    'EX' => [
	     sub {
		 my ($msg) = CtRlCxPkt(@_);  # 
		 my ($mediaNum, $media, $proto, $bwtype, $bandwidth);

		 # XXX:Session Description
		 #	$bwtype = CtFlv('BD,#b=,bandwith-field,bwtype', $msg);
		 #	$bandwidth = CtFlv('BD,#b=,bandwith-field,bandwidth', $msg);

		 $mediaNum = CtFlv('BD,#m=,media-part#N', $msg);
		 if ($mediaNum > 0) {
		     # Media Description
		     --$mediaNum;
		     for my $i (0..$mediaNum) {
			 # m=<media> <port> <proto> <fmt> ...
			 $media = CtFlv("BD,#m=,media-part#$i,media-field,media", $msg);
			 if ($media eq 'audio' or $media eq 'video') {
			     # video
			     $proto = CtFlv("BD,#m=,media-part#$i,media-field,proto", $msg);
			     if ($proto =~ /RTP/) {	# XXX:
				 # RTP
				 # b=<bwtype>:<bandwidth>
				 $bwtype = CtFlv("BD,#m=,media-part#$i,descriptions,#b=,bandwith-field,bwtype", $msg);
				 if ($bwtype eq '') { return '';	} # NG
				 if ($bwtype ne 'AS') { return ''; } # NG
				 $bandwidth = CtFlv("BD,#m=,media-part#$i,descriptions,#b=,bandwith-field,bandwidth", $msg);
				 if ($bandwidth eq '') { return '';	} # NG
			     }
			 }
		     }
		 }
		 return 'OK';
	     },
	     ],
},


#-----------------------------------------------------------------------------
# An INVITE request generated by a UE SHALL contain a SDP offer and at least 
# one media description.[TS24229-6.1-15]
#-----------------------------------------------------------------------------
### 20090205 ID name changed befor 6.1-15 after 6.1-16

{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-6.1-26',
    'CA' => 'Body',								# XXX:Body?? -> Body
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',CtRlCxPkt(@_)) eq 'INVITE')},	# XXX:INVITE
    'OK' => \\'A SDP offer and at least one media description SHALL be contained in an INVITE request generated by a UE.',
    'NG' => \\'A SDP offer and at least one media description SHALL be contained in an INVITE request generated by a UE.',
    'EX' => [
	     sub {
		 my ($msg) = CtRlCxPkt(@_);	# 

		 #	if (!CtFlv('BD,#v=', $msg)) {
		 if (!CtFlp('BD', $msg)) {		# Body
		     return '';	# NG
		 }
		 if (CtFlv('BD,#m=,media-part#N', $msg) > 0) {
		     # Media Description
		     return 'OK';
		 } else {
		     return '';	# NG
		 }
	     },
	     ],
},


#--------------------------------------------------------------------------------------------
# Bodies:
#  Hence, the UE SHALL not encrypt the SDP payloads. [TS24229-6.1-1]
#--------------------------------------------------------------------------------------------
# 
# 
# XXX:
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-6.1-1',
    'CA' => 'Body',	
    'ET' => 'error',
    'OK' => \\'The SDP payloads SHALL not be encrypted.',
    'NG' => \\'The SDP payloads SHALL not be encrypted.',
    'EX' => [
	     sub {
		 my ($msg) = CtRlCxPkt(@_);  # 
		 my ($type, $subtype);		# m-type, m-subtype

		 # Content-Type
		 # Content-Type:type/subtype;param
		 $type = CtFlv('HD,#Content-Type,type', $msg);
		 if (!$type or $type ne 'application') {
		     # type
		     return '';	# NG
		 }
		 $subtype = CtFlv('HD,#Content-Type,subtype', $msg);
		 if (!$subtype or $subtype ne 'sdp') {
		     # subtype
		     return '';	# NG
		 }

		 # 
		 # 
		 ##	if (!CtFlv('BD,#v=', $msg)) {
		 ##		return '';	# NG
		 ##	}

		 return 'OK';
	     },
	     ],
},

#--------------------------------------------------------------------------------------------
# Bodies:
#   During session establishment procedure, SIP messages SHALL only contain SDP payload if that 
#   is intended to modify the session description, or when the SDP payload must be included in 
#   the message because of SIP rules described in RFC 3261[26]. [TS24229-6.1-2]
#--------------------------------------------------------------------------------------------
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
# 20090205 change status from BASIC to NOT REQUIRED

{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-6.1-2',
    'CA' => 'Body',
    'ET' => 'error',
#	'PR' => \q{ CtFlp('BD', CtRlCxPkt(@_)) },	# XXX:Body
    'OK' => \\'During session establishment procedure, SIP messages SHALL only contain SDP payload if that is intended to modify the session description, or when the SDP payload must be included in the message because of SIP rules described in RFC 3261[26].',
    'NG' => \\'During session establishment procedure, SIP messages SHALL only contain SDP payload if that is intended to modify the session description, or when the SDP payload must be included in the message because of SIP rules described in RFC 3261[26].',
    'EX' => [
	     sub {
		 my ($msg) = CtRlCxPkt(@_);					# 
		 my ($no_sdp) = CtRlCxUsr(@_)->{'no_sdp'};	# 
		 my ($type, $subtype);

		 # Content-Type
		 # Content-Type:type/subtype;param
		 $type = CtFlv('HD,#Content-Type,type', $msg);
		 $subtype = CtFlv('HD,#Content-Type,subtype', $msg);
		 if ( ($type and $type eq 'application') &&
		      ($subtype and $subtype eq 'sdp') ) {
		     # type
		     # subtype
		     if ($no_sdp) {
			 # 
			 return '';	# NG
		     } else {
			 # 
		     }
		 } else {
		     if (!$no_sdp) {
			 # 
			 return '';	# NG
		     } else {
			 # 
			 # 
			 return 'OK';
		     }
		 }

		 if (CtFlp('BD', $msg)) {
		     # 
		     if ($no_sdp) {
			 # 
			 # 
			 #    
			 return '';	# NG
		     }
		 } else {
		     if (!$no_sdp) {
			 # 
			 return '';	# NG
		     }
		 }

		 return 'OK';
	     },
	     ],
},

### Judgment rule for 'Message'
###(Basis for a determination : TS24229-6.1-33)
### written by orimo (2009.3.16)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-6.1-43',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'By the terminating UE, one codec per payload SHALL be selected exactly and only the selected codec for the related media stream SHALL be indicated upon sending a SDP answer to an SDP offer.',
    'NG' => 'By the terminating UE, one codec per payload SHALL be selected exactly and only the selected codec for the related media stream SHALL be indicated upon sending a SDP answer to an SDP offer.',
    'EX' => sub{

	my ($body, @lines);
	my ($a_cnt, $m_cnt, $m_flg);
	my ($retult)= 'OK';

        # pre
	my (@pre_aline);
	$m_cnt =0;
	$a_cnt= 0;
	$m_flg = 0;
	$body = CtFlp('BD', CtRlCxUsr(@_)->{'pre_req'});    # Pre_req
	@lines = split(/[\r\n]+/, $body);

	foreach my $line (@lines) {
	    if ($line =~ /^([a-z])=(.*$)/) {	# type=value
		my ($type) = $1;	        # 
		my ($content) = $2;             # Content
		
		if ($m_flg == 0){
		    if ($type eq 'm') {			# m
			$m_flg = 1;
			$m_cnt++;
			$pre_aline[$m_cnt][$a_cnt] = $m_cnt;   # 
			next;
		    }else{
			next;
		    }
		}else{                                 # a
		    if ($type eq 'a'){
			$a_cnt++;
			$pre_aline[$m_cnt][$a_cnt] = $content;  # 
			next;
		    }else{
			if ($type eq 'm'){
			    if ($a_cnt == 0){
				return '';
			    }else{
				$m_cnt++;
				next;
			    }
			}else{
			    next;
			}
		    }
		}
	    } #if
	 } #foreach
	 
        # 
	$m_cnt =0;
	$a_cnt= 0;
	$m_flg = 0;
        my ($i) = 1;
	$body = CtFlp('BD', CtRlCxPkt(@_));	# 
	@lines = split(/[\r\n]+/, $body);

	foreach my $line (@lines) {
	    if ($line =~ /^([a-z])=(.*$)/) {	# type=value
		my ($type) = $1;	        # 
		my ($content) = $2;             # Content
		
		if ($m_flg == 0){
		    if ($type eq 'm') {			# m
			$m_cnt++;
			$m_flg = 1;
			next;
		    }else{
			next;
		    }
		}else{                                 # a
		    if ($type eq 'a'){
			$a_cnt++;
			$result = '';          # NG
			# JUDGE
		        # 1 a line per 1 m line (m line
			while (($pre_aline[$m_cnt][$i])){
			    if (CtUtEq($pre_aline[$m_cnt][$i], $content)){
				$result = 'OK';       # a line matched!
			    }
			    $i++;
			}
			next;
		    }else{
			if ($type eq 'm'){
			    if ($a_cnt != 1){         # a line
				return '';
			    }else{
				$m_cnt++;
				next;
			    }
			}else{
			    next;
			}
		    }
		}
	    } #if
	 } #foreach
			
	 if ($a_cnt != 1){
	     return '';
	 }else{
	     return $result;
	 }
    },

},
## 'S.TS24229-6.1-33'


### Judgment rule for 'Warning'
###(Basis for a determination : TS24229-6.1-37)
### written by orimo (2009.3.16)
### 
#                 Warning
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-6.1-47',
    'CA' => 'Warning',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq ''},
    'OK' => '488 response with 301 Warning header indicating "incompatible network address format" SHALL be sent upon receiving an initial INVITE request that includes the SDP offer containing an IP address type that is not supported by the UE.',
    'NG' => '488 response with 301 Warning header indicating "incompatible network address format" SHALL be sent upon receiving an initial INVITE request that includes the SDP offer containing an IP address type that is not supported by the UE.',
    'EX' => \q{CtUtEq(CtFlv('SL,code', @_),'488') &&
                     CtUtIsExistHdr('Warning', @_) &&
		     CtUtEq(CtFlv('HD,#Warning,code', @_),'301') &&
		     CtUtTrue(CtFlv('HD,#Warning,text', @_)) 
		     },
},
## 'S.TS24229-6.1-37'


### Judgment rule for 'Warning'
###(Basis for a determination : TS24229-8.1-6)
### written by y.inoue (2009.3.25)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-8.1-6',
    'CA' => 'SigComp',
    'ET' => 'error',
    'OK' => 'UE SHALL finish the compertment when the UE is deregisterd.',
    'NG' => 'UE SHALL finish the compertment when the UE is deregisterd.',
},

### Judgment rule for 'Warning'
###(Basis for a determination : TS24229-8.1-11)
### written by y.inoue (2009.3.24)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.TS24229-8.1-11',
    'CA' => 'P-Access-Network-Info',
    'ET' => 'error',
    'PR' => sub {
		my ($inf);
		$inf = CtFlv('HD,#P-Access-Network-Info,type', @_);

        return (grep{$inf eq $_}('3GPP-GERAN','3GPP-UTRAN-FDD','3GPP-UTRAN-TDD','3GPP2-1X',
                                '3GPP2-1X-HRPD','IEEE-802.11','IEEE-802.11a','IEEE-802.11b','IEEE-802.11g',
                                '3GPP-E-UTRAN-FDD', '3GPP-E-UTRAN-TDD','3GPP2-UMB','IEEE-802.11n')) ? 'OK' : ''
		},
    'OK' => 'UE SHOULD compress the requests and responses if UE generates these containning a P-Access-Network-Info header with a value of "3GPP-GERAN","3GPP-UTRAN-FDD", "3GPP-UTRAN-TDD", "3GPP-E-UTRAN-FDD", "3GPP-E-UTRAN-TDD", "3GPP2-1X", "3GPP2-1X-HRPD", "3GPP2-UMB", "IEEE-802.11", "IEEE-802.11a", "IEEE-802.11b" or "IEEE-802.11g", or "IEEE-802.11n"',
    'NG' => 'UE SHOULD compress the requests and responses if UE generates these containning a P-Access-Network-Info header with a value of "3GPP-GERAN","3GPP-UTRAN-FDD", "3GPP-UTRAN-TDD", "3GPP-E-UTRAN-FDD", "3GPP-E-UTRAN-TDD", "3GPP2-1X", "3GPP2-1X-HRPD", "3GPP2-UMB", "IEEE-802.11", "IEEE-802.11a", "IEEE-802.11b" or "IEEE-802.11g", or "IEEE-802.11n"',
    'EX' => \q{CtIsSigcom(@_)},
},

);
## DEF.END

## 226(AKA),257(DIP) 
sub SvRl226_257_RuleSet {
    my($regflag)=@_; # 1:
    my($rules);
    if($regflag eq 1){
        $rules=['S.TS24229-5.1-31','S.TS24229-5.1-32','S.TS24229-5.1-33',
                'S.TS24229-5.1-37','S.TS24229-5.1-40','S.TS24229-5.1-41','S.TS24229-5.1-42'];
        if(CtSecurityScheme() eq 'aka'){
            push(@$rules,'S.TS24229-5.1-75','S.TS24229-5.1-74');
        }
        else{
            push(@$rules,'S.TS24229-5.1-99','S.TS24229-5.1-98');
        }
    }
    if($regflag eq 2){
        $rules=['S.TS24229-5.1-31','S.TS24229-5.1-32','S.TS24229-5.1-40',
                'S.TS24229-5.1-41','S.TS24229-5.1-42','S.TS24229-5.1-157','S.TS24229-5.1-160'];
        if(CtSecurityScheme() eq 'aka'){
            push(@$rules,'S.TS24229-5.1-75','S.TS24229-5.1-74');
        }
        else{
            push(@$rules,'S.TS24229-5.1-99','S.TS24229-5.1-98');
        }
    }
    if($regflag eq 3){
        $rules=['S.TS24229-5.1-31','S.TS24229-5.1-32','S.TS24229-5.1-41',
                'S.TS24229-5.1-298','S.TS24229-5.1-301'];
    }

    return $rules;
}

1;


