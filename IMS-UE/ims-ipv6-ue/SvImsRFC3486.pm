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

#=============================================================================
#
# RFC3486 " Compressing the SIP"
#
# ToDo
#  - RFC3486 
#
#=============================================================================

## DEF.VAR
@IMS_RFC3486_SyntaxRules =
(

#=========================#
#  Rule (SYNTAX_RFC3486)  #
#=========================#


# SYNTAX Rule for RFC3486-3-1 ()
# 
# 
# 


# SYNTAX Rule for RFC3486-4-1 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3486-4-1',
    'CA' => 'Sigcomp',
    'ET' => 'warning',
    'OK' => 'If the next-hop URI contains the parameter comp=sigcomp, the UE SHOULD compress the request using SigComp.',
    'NG' => 'If the next-hop URI contains the parameter comp=sigcomp, the UE SHOULD compress the request using SigComp.',
    'EX' => \q{CtIsSigcom(@_)},
},

### Not for use (090325)
# SYNTAX Rule for RFC3486-4-3 (Inoue)
# 
# 
#{
#    'TY' => 'SYNTAX',
#    'ID' => 'S.RFC3486-4-3',
#    'CA' => 'Sigcomp', 
#    'ET' => 'error',
#    'OK' => 'A client MUST NOT send a compressed request to a server if it does not know whether or not the server supports SigComp.',
#    'NG' => 'A client MUST NOT send a compressed request to a server if it does not know whether or not the server supports SigComp.',
#    'EX' => sub { 
#			if(CtIsSigcom(@_)){
#			    return '';
#			}
#
#			return 'OK';
#
#		},  
#},


# SYNTAX Rule for RFC3486-4-4 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3486-4-4',
    'CA' => 'Contact',
    'ET' => 'warning',
    'OK' => 'If UE would like to receive subsequent requests within the same dialog in the UAS->UAC direction compressed, UE SHOULD add the parameter comp=sigcomp to the URI in the Contact header field.',
    'NG' => 'If UE would like to receive subsequent requests within the same dialog in the UAS->UAC direction compressed, UE SHOULD add the parameter comp=sigcomp to the URI in the Contact header field.',
    'EX' => sub { 
		my ($tags, $vals);
		my ($params);

		$tags = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,tag', @_);
		$vals = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,other', @_);

		for($i=0; $i<=$#$tags; $i++){
			$params[$i] = "$tags->[$i]=$vals->[$i]";
			if($params[$i] eq 'comp=sigcomp'){
				return 'OK';
			}
		}
		return '';
	},
},


# SYNTAX Rule for RFC3486-4-6 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3486-4-6',
    'CA' => 'Contact',
    'ET' => 'warning',
    'PR' => \q{CtIsSigcom(@_) ne ''},
    'OK' => 'If UE sends a compressed request, UE SHOULD add the parameter comp=sigcomp to the URI in the Contact header field.',
    'NG' => 'If UE sends a compressed request, UE SHOULD add the parameter comp=sigcomp to the URI in the Contact header field.',
    'EX' => sub {
		my ($tags, $vals);
		my ($params);

		$tags = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,tag', @_);
		$vals = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,other', @_);

		for($i=0; $i<=$#$tags; $i++){
			$params[$i] = "$tags->[$i]=$vals->[$i]";
			if($params[$i] eq 'comp=sigcomp'){
				return 'OK';
			}
		}
		return '';
	},
},


# SYNTAX Rule for RFC3486-4-8 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3486-4-8',
    'CA' => 'Via',
    'ET' => 'warning',
    'PR' => \q{CtIsSigcom(@_) ne ''},
    'OK' => 'If UE sends a compressed request, UE SHOULD add the parameter comp=sigcomp to the topmost entry of the Via header field.',
    'NG' => 'If UE sends a compressed request, UE SHOULD add the parameter comp=sigcomp to the topmost entry of the Via header field.',
    'EX' => sub { 
		my ($params);

		$params = CtFlv('HD,#Via,records,#ViaParm,params,list,#ViaExtension,extension', @_);

		for($i=0; $i<=$#$params; $i++){
			if($params->[$i] eq 'comp=sigcomp'){
				return 'OK';
			}
		}
		return '';
	},
},


# SYNTAX Rule for RFC3486-4-9 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3486-4-9',
    'CA' => 'Via',
    'ET' => 'warning',
    'OK' => 'If UE would like to receive subsequent requests within the same dialog in the UAS->UAC direction compressed,  UE SHOULD add the parameter comp=sigcomp to the topmost entry of the Via header field.',
    'NG' => 'If UE would like to receive subsequent requests within the same dialog in the UAS->UAC direction compressed,  UE SHOULD add the parameter comp=sigcomp to the topmost entry of the Via header field.',
    'EX' => sub {
		my ($params);

		$params = CtFlv('HD,#Via,records,#ViaParm,params,list,#ViaExtension,extension', @_);

		for($i=0; $i<=$#$params; $i++){
			if($params->[$i] eq 'comp=sigcomp'){
				return 'OK';
			}
		}
		return '';
		},
},


# SYNTAX Rule for RFC3486-5-1 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3486-5-1',
    'CA' => 'Sigcomp',
    'ET' => 'warning',
    'OK' => 'If the topmost Via header field contains the parameter comp=sigcomp, the response SHOULD be compressed.',
    'NG' => 'If the topmost Via header field contains the parameter comp=sigcomp, the response SHOULD be compressed.',
    'EX' => \q{CtIsSigcom(@_)},
},


# SYNTAX Rule for RFC3486-5-5 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3486-5-5',
    'CA' => 'Contact',
    'ET' => 'warning',
    'OK' => 'UE SHOULD add comp=sigcomp to the Contact header field of the response if the URI of the next upstream hop in the route set contained the parameter comp=sigcomp.',
    'NG' => 'UE SHOULD add comp=sigcomp to the Contact header field of the response if the URI of the next upstream hop in the route set contained the parameter comp=sigcomp.',
    'EX' => sub { 
		my ($tags, $vals);
		my ($params);

		$tags = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,tag', @_);
		$vals = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,other', @_);

		for($i=0; $i<=$#$tags; $i++){
			$params[$i] = "$tags->[$i]=$vals->[$i]";
			if($params[$i] eq 'comp=sigcomp'){
				return 'OK';
			}
		}
		return '';
	},
},


);

1;

