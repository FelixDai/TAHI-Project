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
# RFC5049 "Applying Signaling Compression (SigComp) to the SIP"
#
# ToDo
#  - RFC5049 
#
#=============================================================================

## DEF.VAR
@IMS_RFC5049_SyntaxRules =
(

#=========================#
#  Rule (SYNTAX_RFC5049)  #
#=========================#


# SYNTAX Rule for RFC5049-3-1 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC5049-3-1',
    'CA' => '',                                           #
    'ET' => 'error',
#    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},     #
    'OK' => 'Any SigComp implementation that is used for the compression of SIP messages MUST conform to this document, as well as to.',
    'NG' => 'Any SigComp implementation that is used for the compression of SIP messages MUST conform to this document, as well as to.',
    'EX' => sub { },                                      #
},

# SYNTAX Rule for RFC5049-9.1-2 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC5049-9.1-2',
    'CA' => 'Sigcomp',
    'ET' => 'error',
    'OK' => 'URN MUST be persistent as long as the application stores compartment state related to other SIP/SigComp applications.',
    'NG' => 'URN MUST be persistent as long as the application stores compartment state related to other SIP/SigComp applications.',
    'EX' => sub {

	# get sigcomp id in the Via header.

		my($V_scid_orig, $V_scid_new);
		$V_scid_orig = CtRlCxUsr(@_)->{'scid'};
		$V_scid_orig =~ s/urn:uuid:(.+)/$1/;

		local($id);
		CtFlGet('INET,#SIP,HD,#Via#0,records,#ViaParm#0,params,list,#ViaExtension,extension`$V=~/sigcomp-id="(.+)"/i ? $id=$1:undef`', @_);
		$V_scid_new = $id;
		$V_scid_new =~ s/urn:uuid:(.+)/$1/;


	# get sigcomp id in Contact header

		my($C_scid_orig, $C_scid_new);
		$C_scid_new = CtFlv(q{HD,#Contact,c-params,addr,uri,params,list,#OtherParam,tag`$V eq 'sigcomp-id'`,other}, @_);
		$C_scid_new =~ s/urn:uuid:(.+)/$1/;

		$C_scid_orig = $SIGCOMPRemoteUuid;

		my($s_code);
		$s_code = CtFlv('SL,code', @_);

	# verify sigcomp ids

		if($V_scid_orig eq $V_scid_new){
			if(!CtUtIsExistHdr('Contact',@_)){
				return 'OK';
			}
			if($C_scid_orig eq $C_scid_new){
				if($C_scid_orig eq $V_scid_orig){
					return 'OK';
				}
			}
		}
		if($s_code){
			if(!CtUtIsExistHdr('Contact',@_)){
				return 'OK';
			}
			if($C_scid_orig eq $C_scid_new){
				if($C_scid_orig eq $V_scid_orig){
					return 'OK';
				}
			}
		}




		return '';
	},
},

# SYNTAX Rule for RFC5049-9.1-7 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC5049-9.1-7',
    'CA' => 'Contact',
    'ET' => 'error',
    'OK' => 'The SIP URI \'sigcomp-id\' parameter MUST contain a URN.',
    'NG' => 'The SIP URI \'sigcomp-id\' parameter MUST contain a URN.',
    'EX' => sub { 
		my ($tags, $vals);
		my ($params);

		$tags = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,tag', @_);
		$vals = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,other', @_);

		for($i=0; $i<=$#$tags; $i++){
			if($tags->[$i] eq 'sigcomp-id'){
				if($vals->[$i] =~ /urn/){
					return 'OK';
				}
			}
		}
	return '';
	},
},

# SYNTAX Rule for RFC5049-9.1-8 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC5049-9.1-8',
    'CA' => 'Via',
    'ET' => 'error',
    'OK' => 'The Via \'sigcomp-id\' parameter MUST contain a URN.',
    'NG' => 'The Via \'sigcomp-id\' parameter MUST contain a URN.',
    'EX' => sub {
		my ($params);

		$params = CtFlv('HD,#Via,records,#ViaParm,params,list,#ViaExtension,extension', @_);

		for($i=0; $i<=$#$params; $i++){
			if($params->[$i] =~ /sigcomp-id/){
				if($params->[$i] =~ /urn/){
					return 'OK';
				}
			}
		}
	return '';
	},
},

# SYNTAX Rule for RFC5049-9.1-9 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC5049-9.1-9',
    'CA' => 'Contact',
    'ET' => 'error',
    'PR' => sub{
		my ($tags, $vals);
		my ($params);
		$tags = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,tag', @_);
		$vals = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,other', @_);

		if("$tags=$vals" eq 'comp=sigcomp'){
			return 'OK';
		}

                for($i=0; $i<=$#$tags; $i++){
                        $params[$i] = "$tags->[$i]=$vals->[$i]";
                        if($params[$i] eq 'comp=sigcomp'){
                                return 'OK';
                        }
                }
                return '';
	},
    'OK' => 'A SIP/SigComp application placing its URI with the \'comp=sigcomp\' parameter in a header field MUST add a \'sigcomp-id\' parameter with its SIP/SigComp identifier to that URI.',
    'NG' => 'A SIP/SigComp application placing its URI with the \'comp=sigcomp\' parameter in a header field MUST add a \'sigcomp-id\' parameter with its SIP/SigComp identifier to that URI.',
    'EX' => sub {
		my ($tags, $vals);
		my ($params);

		$tags = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,tag', @_);
		$vals = CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,params,list,#OtherParam,other', @_);

		for($i=0; $i<=$#$tags; $i++){
			if($tags->[$i] eq 'sigcomp-id'){
				if($vals->[$i] =~ /urn/){
					return 'OK';
				}
			}
		}
	return '';
	},
},

# SYNTAX Rule for RFC5049-9.1-10 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC5049-9.1-10',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => sub{
		my ($params);

		$params = CtFlv('HD,#Via,records,#ViaParm,params,list,#ViaExtension,extension', @_);


		for($i = 0; $i<=($#$params + 1); $i++){
			if($params eq 'comp=sigcomp'){
				return 'OK';
			}
			if($params->[$i] eq 'comp=sigcomp'){
				return 'OK';
			}
		}
		return '';
	},
    'OK' => 'A SIP/SigComp application generating its own Via entry containing the \'comp=sigcomp\' parameter MUST add a \'sigcomp-id\' parameter with its SIP/SigComp identifier to that Via entry.',
    'NG' => 'A SIP/SigComp application generating its own Via entry containing the \'comp=sigcomp\' parameter MUST add a \'sigcomp-id\' parameter with its SIP/SigComp identifier to that Via entry.',
    'EX' => sub {
		my ($params);

		$params = CtFlv('HD,#Via,records,#ViaParm,params,list,#ViaExtension,extension', @_);

		for($i=0; $i<=$#$params; $i++){
			if($params->[$i] =~ /sigcomp-id/){
				if($params->[$i] =~ /urn/){
					return 'OK';
				}
			}
		}
	return '';
	},
},

);

1;

