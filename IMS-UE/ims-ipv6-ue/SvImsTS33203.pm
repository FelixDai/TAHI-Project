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
# TS33.203 
#
# ToDo
#
#=================================================================

# 

## DEF.VAR
@IMS_TS33203_SyntaxRules =
(

# 1
# 2
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-6.1-26',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The REGISTER request for authentication that includes the cause of failure SHALL be sent towards the Home Network.',
	'NG' => 'The REGISTER request for authentication that includes the cause of failure SHALL be sent towards the Home Network.',
	'EX' => sub{
	    if( CtRlCxUsr(@_)->{'register_num'} eq 1){
		return CtUtTrue(!CtFlv('HD,#Authorization,credentials,credential,digestresp,list,tag`$V eq auts`,auth',@_) &&
				!CtFlv('HD,#Authorization,credentials,credential,digestresp,list,response',@_),@_);
	    }
	    else{
		# 
		my $auth_response = CtUtAuthResponse('',@_);
		return CtUtTrue(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,tag`$V eq auts`,auth',@_) &&
				CtFlv('HD,#Authorization,credentials,credential,digestresp,list,response',@_) eq $auth_response,@_);
	    }
	},
},

# IPsec
#  ESP
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-6.2-3',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'ESP confidentiality SHALL be used in transport mode between UE and P-CSCF.',
	'NG' => 'ESP confidentiality SHALL be used in transport mode between UE and P-CSCF.',
	'EX' => \q{CtUtTrue(CtFlGet('INET,#ESP',@_) && 
			    ((CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'ealg') ne 'null' && CtFlGet('INET,#ESP,EncData',@_)) ||
			     !CtFlGet('INET,#ESP,EncData',@_)),@_)},
},

# IPsec
#  ESP
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-6.3-3',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'ESP integrity SHALL be used in transport mode between UE and P-CSCF.',
	'NG' => 'ESP integrity SHALL be used in transport mode between UE and P-CSCF.',
	'EX' => \q{CtUtTrue(CtFlGet('INET,#ESP',@_) && (CtFlGet('INET,#ESP,Authenticator',@_) =~ /[1-9a-f]/),@_)},
},

# Security-Client 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.2-1',
	'CA' => 'Security-Client',
	'ET' => 'error',
	'OK' => 'A Security-setup-line SHALL be included in REGISTER request in order to start the security mode set-up procedure.',
	'NG' => 'A Security-setup-line SHALL be included in REGISTER request in order to start the security mode set-up procedure.',
	'EX' => \q{CtUtTrue((CtFlv('HD,#Security-Client,mechanism,#Mechanism,name',@_) ne "")
			    && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "alg"`,generic',@_) ne "")
			    && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-c"`,generic',@_) ne "")
			    && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "spi-s"`,generic',@_) ne "")
			    && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-c"`,generic',@_) ne "")
			    && (CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_) ne ""),@_)},
},

# 'S.TS33203-6.2-3', 'S.TS33203-6.3-3' 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.2-8',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The integrity and confidentiality of the REGISTER request for authentication and all following SIP messages SHALL be protected.',
	'NG' => 'The integrity and confidentiality of the REGISTER request for authentication and all following SIP messages SHALL be protected.',
	'EX' => \q{CtUtTrue(CtFlGet('INET,#ESP',@_) && (CtFlGet('INET,#ESP,Authenticator',@_) =~ /[1-9a-f]/) &&
			    ((CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'ealg') ne 'null' && CtFlGet('INET,#ESP,EncData',@_)) ||
			     !CtFlGet('INET,#ESP,EncData',@_)),@_)},
},

# 2ed REGISTER
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.2-9',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The REGISTER request for authentication SHALL include the integrity and encryption algorithms list, SPI_P, and Port_P received in 401(Unauthorized) response, and SPI_U, Port_U sent in the initial REGISTER request.',
	'NG' => 'The REGISTER request for authentication SHALL include the integrity and encryption algorithms list, SPI_P, and Port_P received in 401(Unauthorized) response, and SPI_U, Port_U sent in the initial REGISTER request.',
	'EX' => sub {
            my ($hexST, $context) = @_;
	    my($sc,$sv,$ss401,$scReg,$param,$fld);
	    $sc = CtFlv('HD,#Security-Client,mechanism,#Mechanism,params',@_);
	    $sv = CtFlv('HD,#Security-Verify,mechanism,#Mechanism,params',@_);
	    $scReg = CtFlv('HD,#Security-Client,mechanism,#Mechanism,params',CtRlCxUsr(@_)->{'reg_ini'});
	    $ss401 = CtFlv('HD,#Security-Server,mechanism,#Mechanism,params',CtRlCxUsr(@_)->{'reg_nego'});
	    foreach $param ('alg','port-c','port-s','spi-c','spi-s'){
		$fld = '#GenericParam,tag`$V eq "'.$param.'"`,generic';
		if( CtFlGet($fld,$sc) ne CtFlGet($fld,$scReg)){
		    CtRlSetEvalResult($context, '1op');
		    return;
		}
	    }
	    foreach $param ('alg','port-c','port-s','spi-c','spi-s'){
		$fld = '#GenericParam,tag`$V eq "'.$param.'"`,generic';
		if( CtFlGet($fld,$sv) ne CtFlGet($fld,$ss401)){
		    CtRlSetEvalResult($context, '1op');
		    return;
		}
	    }
	    CtRlSetEvalResult($context, '1op','','OK');
	    return 'OK';
	}
},

# 
# 
#  'S.TS33203-7.3-5','S.TS33203-7.3-8','S.TS33203-7.4-1','S.TS33203-7.4-3','S.TS33203-7.4-12','S.TS33203-7.4-14','S.TS33203-7.4-18'
#  
#

# UR-RG-B-19 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.3-5',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The REGISTER request which may pass through an already established SA and indicate a network authentication failure SHALL be sent to the P-CSCF.',
	'NG' => 'The REGISTER request which may pass through an already established SA and indicate a network authentication failure SHALL be sent to the P-CSCF.',
	'EX' => sub {
            my ($hexST, $context) = @_;
	    my($sa,$result);
	    if(($sa=CtFindSAfromPkt($hexST)) &&
	       $sa->{'spi'} eq CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'spi_ls')){
		$result = 'OK';
	    }
	    CtRlSetEvalResult($context, '1op','',$result);
	    return $result;
	}
},

# 
# 'S.TS33203-7.4-3','S.TS33203-7.4-14'

{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.3-8',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The first message in this registration SHOULD be protected with an SA created by a previous successful authentication if one exists.',
	'NG' => 'The first message in this registration SHOULD be protected with an SA created by a previous successful authentication if one exists.',
	'EX' => sub {
            my ($hexST, $context) = @_;
	    my($sa,$result);
	    if(($sa=CtFindSAfromPkt($hexST)) &&
	       $sa->{'spi'} eq CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'spi_ls')){
		$result = 'OK';
	    }
	    CtRlSetEvalResult($context, '1op','',$result);
	    return $result;
	}
},

# UR-RG-B-17(ACK:19) 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.4-1',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The previous security associations SHALL be replaced the new security associations.',
	'NG' => 'The previous security associations SHALL be replaced the new security associations.',
	'EX' => sub {
            my ($hexST, $context) = @_;
	    my($sa,$result);
	    if(($sa=CtFindSAfromPkt($hexST)) &&
	       $sa->{'spi'} eq CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'spi_ls')){
		$result = 'OK';
	    }
	    CtRlSetEvalResult($context, '1op','',$result);
	    return $result;
	}
},

# UR-RG-B-17(REGISTER:14) 
# suya modified (09/3/24)
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.4-2',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The sever ports of UE and P-CSCF SHALL not be changed, while the protected client ports of UE and P-CSCF SHALL change.',
	'NG' => 'The sever ports of UE and P-CSCF SHALL not be changed, while the protected client ports of UE and P-CSCF SHALL change.',
#	'EX' => \q{CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',@_) eq
#	    CtFlv('HD,#Security-Client,mechanism,#Mechanism,params,#GenericParam,tag`$V eq "port-s"`,generic',CtRlCxUsr(@_)->{'reg_ini'})}
#},
	'EX' => \q{CtFlGet('INET,#UDP,DstPort',@_) eq CtSecNego('','port_ls') && CtFlGet('INET,#UDP,SrcPort',@_) ne CtSecNego('','port_pc')}
},


# 'S.TS33203-7.3-8'
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.4-3',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The first message in this registration SHOULD be protected with an SA created by a previous successful authentication if one exists.',
	'NG' => 'The first message in this registration SHOULD be protected with an SA created by a previous successful authentication if one exists.',
	'EX' => sub {
            my ($hexST, $context) = @_;
	    my($sa,$result);
	    if(($sa=CtFindSAfromPkt($hexST)) &&
	       $sa->{'spi'} eq CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'spi_ls')){
		$result = 'OK';
	    }
	    CtRlSetEvalResult($context, '1op','',$result);
	    return $result;
	}
},

# 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.4-9',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'An unprotected REGISTER request SHOULD be sent when the security associations no longer active at the P CSCF.',
	'NG' => 'An unprotected REGISTER request SHOULD be sent when the security associations no longer active at the P CSCF.',
	'EX' => \q{ ((CtFlGet('INET,#UDP,DstPort',@_) || CtFlGet('INET,#TCP,DstPort',@_)) eq CtTbAd('local-port')) &&
			!CtFlv('HD,#Security-Verify',@_) && 
			!CtFlv('HD,#Authorization,credentials,credential,digestresp,list,nonce', @_) &&
			!CtFlv('HD,#Authorization,credentials,credential,digestresp,list,response', @_) },
},

# 'S.TS33203-7.3-8'
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.4-12',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'A particular security association SHALL protecte the certain messages in the authentication.',
	'NG' => 'A particular security association SHALL protecte the certain messages in the authentication.',
	'EX' => sub {
            my ($hexST, $context) = @_;
	    my($sa,$result);
	    if(($sa=CtFindSAfromPkt($hexST)) &&
	       $sa->{'spi'} eq CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'spi_ls')){
		$result = 'OK';
	    }
	    CtRlSetEvalResult($context, '1op','',$result);
	    return $result;
	}
},

# 'S.TS33203-7.3-8'
{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.4-14',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The first message in this registration SHOULD be protected with an SA created by a previous successful authentication if one exists.',
	'NG' => 'The first message in this registration SHOULD be protected with an SA created by a previous successful authentication if one exists.',
	'EX' => sub {
            my ($hexST, $context) = @_;
	    my($sa,$result);
	    if(($sa=CtFindSAfromPkt($hexST)) &&
	       $sa->{'spi'} eq CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'spi_ls')){
		$result = 'OK';
	    }
	    CtRlSetEvalResult($context, '1op','',$result);
	    return $result;
	}
},

{
	'TY' => 'SYNTAX',
	'ID' => 'S.TS33203-7.4-18',
	'CA' => 'Security',
	'ET' => 'error',
	'OK' => 'The REGISTER request for authentication to the P-CSCF SHALL be protected with the new outbound SA.',
	'NG' => 'The REGISTER request for authentication to the P-CSCF SHALL be protected with the new outbound SA.',
	'EX' => sub {
            my ($hexST, $context) = @_;
	    my($sa,$result);
	    if(($sa=CtFindSAfromPkt($hexST)) &&
	       $sa->{'spi'} eq CtSecNego(CtRlCxUsr(@_)->{'security_nego'},'spi_ls')){
		$result = 'OK';
	    }
	    CtRlSetEvalResult($context, '1op','',$result);
	    return $result;
	}
},

);

1;















