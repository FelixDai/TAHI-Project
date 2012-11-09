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
# RFC3329 "Security Mechanism Agreement for SIP" (Section ALL)
#
# ToDo
#  - RFC3329 
#
#=================================================================

## DEF.VAR
@IMS_RFC3329_SyntaxRules =
(

#########################
### Rule (RFC3329) 
#########################
### Judgment rule for 'Security-Client'
###(Basis for a determination : RFC3329-2.3-2)
###   written by suyama (2007.12.11)
###   suya modified (2009.3.10)
### 
### 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3329-2.3-2',
	'CA' => 'Security-Client',
	'ET' => 'error',
	'OK' => 'A Client wishing to use the security agreement MUST add a Security-Client header field to a request.',
	'NG' => 'A Client wishing to use the security agreement MUST add a Security-Client header field to a request.',
	'EX' => \q{!CtUtEq(CtFlv('HD,#Security-Client,tag',@_),'',@_)},
},

### Judgment rule for 'Require'
###(Basis for a determination : RFC3329-2.3-4)
###   written by suyama (2007.12.11)
### 
### 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3329-2.3-4',
	'CA' => 'Header',
	'ET' => 'error',
	'OK' => 'The client MUST add both a Require and Proxy-Require header field with the value "sec-agree" to its request.',
	'NG' => 'The client MUST add both a Require and Proxy-Require header field with the value "sec-agree" to its request.',
        'EX' =>  sub {
                       my($req_parameter,$prreq_parameter,@req_field,@prreq_field,$val);
		       my $req_result = 0;
		       my $prreq_result = 0;
	               $req_parameter = CtFlv('HD,#Require,option',@_);
		       $prreq_parameter = CtFlv('HD,#Proxy-Require,option',@_);
		       if(ref($req_parameter)){
			   $req_parameter=[$req_parameter];
			   if($req_parameter =~ /^sec-agree$/m){
			       $req_result = 1;
			   }
		       }else{
			   @req_field = split(/,/, $req_parameter);  
			   foreach $val (@req_field){
			       if ($val =~ /^sec-agree$/m){
				   $req_result = 1;
			       }  
			   }
		       }
		       if(ref($prreq_parameter)){
			   $prreq_parameter=[$prreq_parameter];
			   if($prreq_parameter =~ /^sec-agree$/m){
			       $prreq_result = 1;
			   }
		       }else{
			   @prreq_field = split(/,/, $prreq_parameter);  
			   foreach $val2 (@prreq_field){
			       if ($val2 =~ /^sec-agree$/m){
				   $prreq_result = 1;
			       }  
			   }
		       }

		       if ($req_result==1){
			   if($prreq_result==1){

			       return "OK";
			   }
		       }
		       return "";
		   },
},

### Judgment rule for 'Security'
###(Basis for a determination : RFC3329-2.3-14)
###   written by suyama (2009.3.10)
### 
### 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3329-2.3-14',
	'CA' => 'Security',
	'ET' => 'error',
	'PR' => \q{(CtFlv('HD,#Security-Verify,tag',@_) ne '')},
	'OK' => 'All subsequent SIP requests SHOULD make use of the security mechanism initiated in the previous step.',
	'NG' => 'All subsequent SIP requests SHOULD make use of the security mechanism initiated in the previous step.',
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
#            PrintVal([$spi,$spils,$dstport,$portls,$srcport,$portpc]);
            if(($spi eq $spils) && ($dstport eq $portls) && ($srcport eq $portpc)){
                return 'OK'
	    }
        }
},

### Judgment rule for 'Header'
###(Basis for a determination : RFC3329-2.3-15)
###   written by murata (2008.1.9)
### suyama modified(2009.2.26)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3329-2.3-15',
    'CA' => 'Security-Verify',
    'ET' => 'error',
    'OK' => 'A subsequent SIP requests MUST contain a Security-Verify header field that mirrors the server\'s list received previously in the Security- Server header field.',
    'NG' => 'A subsequent SIP requests MUST contain a Security-Verify header field that mirrors the server\'s list received previously in the Security- Server header field.',
    'EX' =>  sub{
	my($sa_nego,$sa_mech,$sa_alg,$sa_ealg,$sa_portls,$sa_portlc,$sa_spilc,$sa_spils);
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
        
        $sa_mech = CtSecNego($sa_nego,'mech');
        $sa_alg = CtSecNego($sa_nego,'alg');
        $sa_ealg = CtSecNego($sa_nego,'ealg');
        $sa_portls = CtSecNego($sa_nego,'port_ls');
        $sa_portlc = CtSecNego($sa_nego,'port_lc');
        $sa_spils = CtSecNego($sa_nego,'spi_ls');
        $sa_spilc = CtSecNego($sa_nego,'spi_lc');
        $rcv_ealg = CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "ealg"`,generic',@_);
        
	if($rcv_ealg eq ''){
	    $rcv_ealg = 'null'
        }
        
        # PrintVal([
        #     CtFlv('HD,#Security-Verify,mechanism,#Mechanism,name',@_),$sa_mech,
	#     CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_),$sa_alg,
	#     CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',@_), $sa_spilc,
        #     CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',@_), $sa_spils,
	#     CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',@_), $sa_portlc,
	#     CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_), $sa_portls,
        #     $rcv_ealg,$sa_ealg]);
	if (CtFlv('HD,#Security-Verify,mechanism,#Mechanism,name',@_) eq $sa_mech &&
	    CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_) eq $sa_alg &&
	    CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',@_) eq $sa_spilc &&
            CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',@_) eq $sa_spils && 
	    CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',@_) eq $sa_portlc &&
	    CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_) eq $sa_portls && 
	    $rcv_ealg eq $sa_ealg){
	    return 'OK';
	}
	return '';
    }
},

### Judgment rule for 'Proxy-Require'
###(Basis for a determination : RFC3329-2.3-16)
###   written by murata (2008.1.9)
### suyama modified(2009.3.16)
### 
### 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3329-2.3-16',
    'CA' => 'Header',
    'ET' => 'error',
    'OK' => 'A subsequent SIP requests MUST also have both a Require and Proxy-Require header fields with the value "sec-agree".',
    'NG' => 'A subsequent SIP requests MUST also have both a Require and Proxy-Require header fields with the value "sec-agree".',
    'EX' =>  sub {
	my($parameter,@field,$val,$result);
	
	$result = ''; # NG
	$parameter = CtFlv('HD,#Require,option',@_);
	@field = split(/,/, $parameter);  
	
	foreach $val (@field){
	    if ($val =~ /^sec-agree$/m){
		$result = 'OK';       
	    }  
	}
	if (!$result){return $result;}
	
	$result = ''; # NG
	$parameter = CtFlv('HD,#Proxy-Require,option',@_);
	@field = split(/,/, $parameter);  
	
	foreach $val (@field){
	    if ($val =~ /^sec-agree$/m){
		$result = 'OK';       
	    }  
	}
	
	return $result;
    },
},

### Judgment rule for 'Security'
###(Basis for a determination : RFC3329-5-1)
###   written by murata (2008.1.9)
### 
### 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3329-5-1',
	'CA' => 'Security',
	'ET' => 'error',
	'PR' => \q{CtUtEq(CtFlGet('INET,#UDP,SrcPort',CtUtLastSndMsg()),CtTbCfg(CtTbPrm('CI,target,TARGET'),'sip-port'),@_)},
	'OK' => 'All client MUST select HTTP Digest,TLS,IPsec, or any stronger method for the protection of the second request.',
	'NG' => 'All client MUST select HTTP Digest,TLS,IPsec, or any stronger method for the protection of the second request.',
        'EX' => sub{

	my($pkt)=@_;
        my($sa_nego,$dstport,$srcport,$spi,$portpc,$portls,$spils);
	$sa_nego = CtRlCxUsr(@_)->{'security_nego'};       #SA
	$dstport = CtFlGet('INET,#UDP,DstPort',$pkt);
	$srcport = CtFlGet('INET,#UDP,SrcPort',$pkt);
	$spi = CtFindSAfromPkt(@_)->{spi};
	$last_sa = CtUtLastSndMsg();

	$portpc = CtSecNego($sa_nego,'port_pc');
	$portls = CtSecNego($sa_nego,'port_ls');
	$spils = CtSecNego($sa_nego,'spi_ls');

        if(($spi eq $spils)
	    && ($dstport eq $portls)
	    && ($srcport eq $portpc)){
	    return 'OK'
	    }
    }
},

);

1;











