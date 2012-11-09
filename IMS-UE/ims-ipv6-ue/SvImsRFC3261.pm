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
# RFC3261 "SIP: Session Initiation Protocol" (Section ALL)
#
# ToDo
#  - 
#  - 4xx
#  - 
#
#=================================================================

## DEF.VAR
@IMS_RFC3261_SyntaxRules =
(
#=========================#
#  Rule (SYNTAX_RFC3261)  #
#=========================#

# SYNTAX Rule for RFC3261-7-1 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-7-1',
    'CA' => 'Message',
    'ET' => 'error',
    'OK' => 'The start-line, each message-header line, and the empty line MUST be terminated by a carriage-return line-feed sequence (CRLF).',
    'NG' => 'The start-line, each message-header line, and the empty line MUST be terminated by a carriage-return line-feed sequence (CRLF).',
    'EX' => sub {
	my $sip=CtFlGet('INET,#SIP,#TXT#',@_);
	return (!CtFlGet('INET,#SIP,#INVALID#',@_) && $sip && ($sip =~ /^(?:[^\r\n]+)$PtCRLF(?:[^\r\n]+$PtCRLF)+$PtCRLF(?:[^\r\n]+$PtCRLF?)*$/));
    },
},

# SYNTAX Rule for RFC3261-7-2 (Message)
# 
# 
# ChangeLog    : 20090304 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-7-2',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => \q{CtUtEQ(CtFlv('BD', @_), "")},
    'OK' => 'The empty line MUST be present even if the message-body is not.',
    'NG' => 'The empty line MUST be present even if the message-body is not.',
    'EX' => sub { 
	        # $my_cont = CtFlGet('INET,#SIP,#TXT#', @_);
		#  printf("ref=%s", $my_cont);
		#  if ($my_cont =~ /\r\n\r\n$/){
		#      return 'OK'; # Mach OK
		#  }else{
		#      return '';   # unMuch NG
		#  }
		  
          	if ( CtUtMch(CtFlGet('INET,#SIP,#TXT#', @_), '\r\n\r\n$', @_) ) {
                    return 'OK';  # Mach!!
		  }else{
		    return '';    # unMach!!
		  }
    },
},

# SYNTAX Rule for RFC3261-7.1-1 (Request-URI)
# 
# 
# ChangeLog    : 20090304 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-7.1-1',
    'CA' => 'Request',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) ne '')},
    'OK' => 'The Request-URI MUST NOT contain unescaped space or control characters.',
    'NG' => 'The Request-URI MUST NOT contain unescaped space or control characters.',
    'EX' => sub{
            #my (@sl_uri);
            #@sl_uri = split(/\s+/, CtFlv('SL,#TXT#', @_));
	    #PrintVal(CtFlv('SL,uri,#TXT#', @_));

	    $my_uri = CtFlv('SL,uri,#TXT#', @_);

	    if (!CtUtMch($my_uri, '[^\e]\s+', @_) && !CtUtMch($my_uri, '\c[', @_)){
	    #if (!($my_uri =~ /[^\e]\s+/) && !($my_uri =~  /\c[/)){
		return 'OK';  #OK
	    }else{
		return '';    #NG
	    }
        }
},

# SYNTAX Rule for RFC3261-7.1-2 (Request-URI)
# 
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-7.1-2',
    'CA' => 'Request',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) ne '')},
    'OK' => \\'The Request-URI(%s) MUST NOT be enclosed in \"<>\".', 
    'NG' => \\'The Request-URI(%s) MUST NOT be enclosed in \"<>\".', 
    'EX' => sub{
            my (@sl_uri);
            @sl_uri = split(/\s+/, CtFlv('SL,#TXT#', @_));
            return !CtUtMch($sl_uri[1], '^<.*$>', @_);
        }
},

# SYNTAX Rule for RFC3261-7.1-3 (SIP-Version)
# 
# 
{
    'TY' => 'SYNTAX', 
    'ID' => 'S.RFC3261-7.1-3',
    'CA' => 'Message',
    'ET' => 'error',
    # 
    'OK' => 'Applications sending SIP messages MUST include a SIP-Version of "SIP/2.0".',
    'NG' => 'Applications sending SIP messages MUST include a SIP-Version of "SIP/2.0".',
    'EX' => \q{CtUtEQ(CtFlv('SL,sip-version', @_),"SIP/2.0", @_)}
},

# SYNTAX Rule for RFC3261-7.1-4 (SIP-Version)
# 
# 
{
    'TY' => 'SYNTAX', 
    'ID' => 'S.RFC3261-7.1-4',
    'CA' => 'Message',
    'ET' => 'error',
    # 
    'OK' => 'Implementations MUST send upper-case.',
    'NG' => 'Implementations MUST send upper-case.',
    'EX' => \q{CtUtEq(CtFlv('SL,sip-version', @_),"SIP/2.0", @_)}
},

# SYNTAX Rule for RFC3261-7.3-1 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-7.3-1',
    'CA' => 'Header',
    'ET' => 'warning',
    'OK' => 'It is RECOMMENDED that header fields which are needed for proxy processing (Via, Route, Record-Route, Proxy-Require, Max-Forwards, and Proxy-Authorization, for example) appear towards the top of the message to facilitate rapid parsing.',
    'NG' => 'It is RECOMMENDED that header fields which are needed for proxy processing (Via, Route, Record-Route, Proxy-Require, Max-Forwards, and Proxy-Authorization, for example) appear towards the top of the message to facilitate rapid parsing.',
    'EX' =>\q{CtUtChkHdrOrd(['Via','Route','Record-Route','Proxy-Require','Max-Forwards','Proxy-Authorization'],@_)}
},


# SYNTAX Rule for RFC3261-7.3-3 (Authorization)
# suyama wrote(09/3/10)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-7.3-3',
    'CA' => 'Authorization',
    'ET' => 'error',
    'OK' => 'WWW-Authenticate, Authorization, Proxy-Authenticate or Proxy-Authorization MUST NOT be combined into a single header field row.',
    'NG' => 'WWW-Authenticate, Authorization, Proxy-Authenticate or Proxy-Authorization MUST NOT be combined into a single header field row.',
    'EX' => sub {
	my($auth,@field,$val);
	@auth = CtFlGet('INET,#SIP,HD,#Authorization,tag',@_[0],'T');
	@mech = CtFlGet('INET,#SIP,HD,#Authorization,credentials,credential,tag',@_[0],'T');
	@name = CtFlGet('INET,#SIP,HD,#Authorization,credentials,credential,digestresp,list,#UserName,tag',@_[0],'T');
	@realm = CtFlGet('INET,#SIP,HD,#Authorization,credentials,credential,digestresp,list,#Realm,tag',@_[0],'T');
	
	if($#auth < ($#mech || $#name || $#realm)){
	    return '';
	}
	return 'OK';
    }
},

# SYNTAX Rule for RFC3261-7.4-1 (Content-Type)
# If body is not empty, Content-Type header field includes media-type.
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3261-7.4-1',
        'CA' => 'Content-Type',
        'ET' => 'error',
        'PR' => \q{CtFlp('BD', CtRlCxPkt(@_))},
        'OK' => 'The Internet media type of the messaage body MUST be given by the Content-Type header field.',
        'NG' => 'The Internet media type of the messaage body MUST be given by the Content-Type header field.',
        'EX' => sub {
                        my ($value) = '';
                        my ($result) = '';

                        $value = CtFlv('HD,#Content-Type,#REST#',@_);
                        if($value ne ''){
                                return 'OK';
                        }
                        return '';
                },
},


# SYNTAX Rule for RFC3261-7.4-3 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-7.4-3',
    'CA' => 'Content-Encoding',
    'ET' => 'error',
    'OK' => 'If the body has not undergone any encoding such as compression, then Content-Encoding MUST be omitted.',
    'NG' => 'If the body has not undergone any encoding such as compression, then Content-Encoding MUST be omitted.',
    'EX' => sub {
                if(CtUtIsExistHdr('Content-Encoding', @_)){
                        return '';
                }
                return 'OK';
        },
},


# SYNTAX Rule for RFC3261-8.1-1 (Headers)
# 
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-1',
    'CA' => 'Header',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) ne ''},
    'OK' => 'SIP request MUST contain To, From, CSeq, Call-ID, Max-Forwards and Via header fields.', 
    'NG' => 'SIP request MUST contain To, From, CSeq, Call-ID, Max-Forwards and Via header fields.', 
    'EX' => sub {
	if ( (CtUtIsExistHdr('To',@_) 
	      && CtUtIsExistHdr('From',@_) 
	      && CtUtIsExistHdr('CSeq',@_) 
	      && CtUtIsExistHdr('Call-ID',@_)
	      && CtUtIsExistHdr('Max-Forwards',@_)
	      && CtUtIsExistHdr('Via',@_)) ne '0'){
	    return 'OK';
	}
    },
},

# SYNTAX Rule for RFC3261-8.1-2 (Request-Line)
#
#
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3261-8.1-2',
        'CA' => 'Request',
        'ET' => 'warning',
        'PR' => \q{(CtFlv('SL,method',@_) eq 'INVITE') || (CtFlv('SL,method',@_) eq 'OPTIONS') || (CtFlv('SL,method',@_) eq 'SUBSCRIBE')},
        'OK' => \\'The Initial Request-URI (%s) of the message SHOULD be set to the value of the URI (%s) in the To field.',
        'NG' => \\'The Initial Request-URI (%s) of the message SHOULD be set to the value of the URI (%s) in the To field.',
        'RT' => "warning",
        'EX' => \q{CtRlChkSipURI(CtFlv('SL,uri,#TXT#',@_),CtFlv('HD,#To,addr,uri,#TXT#',@_),@_)}
},

# SYNTAX Rule for RFC3261-8.1-7 (To)
# 
# 
#                
#               
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-7',
    'CA' => 'To',
    'ET' => 'error',
    'PR' => \q{((CtFlv('SL,method',@_) eq 'INVITE')
                || (CtFlv('SL,method',@_) eq 'REGISTER')
                || (CtFlv('SL,method',@_) eq 'OPTIONS')
                || (CtFlv('SL,method',@_) eq 'SUBSCRIBE')
                && CtUtIsExistHdr('To',@_))
            },
    'OK' => 'A request outside of a dialog MUST NOT contain a To tag.',
    'NG' => 'A request outside of a dialog MUST NOT contain a To tag.',
    'EX' => \q{CtUtTrue(CtFlv('HD,#To,params,list,#TagParam,#TXT#', CtRlCxPkt(@_)) eq '',@_)},
},

# SYNTAX Rule for RFC3261-8.1-9 (From)
# S.FROM-TAG_EXIST
# From-tag
{'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-8.1-9',
 'CA' => 'From',
 'ET' => 'error',
 'OK' => 'The From field MUST contain a new "tag" parameter chosen by the UAC.', 
 'NG' => 'The From field MUST contain a new "tag" parameter chosen by the UAC.', 
 'EX' =>\\q{INET,#SIP,HD,#From,params,list,tag-id}
},


# SYNTAX Rule for RFC3261-8.1-10 (Call-ID)
# Call-ID is the same for all requests and response in a dialog.
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3261-8.1-10',
        'CA' => 'Call-ID',
        'ET' => 'error',
        'OK' => 'The Call-ID header field MUST be the same for all requests and responses sent by either UA in a dialog.',
        'NG' => 'The Call-ID header field MUST be the same for all requests and responses sent by either UA in a dialog.',
        'EX' => \q{CtUtEq(CtFlv('HD,#Call-ID,call-id', @_), CtSvDlg(CtRlCxDlg(@_), 'CallID'), @_)},

},

# SYNTAX Rule for RFC3261-8.1-11 (Call-ID)
# written by suyama(09/3/16)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-11',
    'CA' => 'Call-ID',
    'ET' => 'warning',
    'OK' => 'The Call-ID header field SHOULD be the same in each registration from a UA.',
    'NG' => 'The Call-ID header field SHOULD be the same in each registration from a UA.',
    'EX' => sub {
            my ($hexST, $context) = @_;
            my ($result) = 'OK';
            my ($callids) = CtRlCxUsr(@_)->{'callids'};
            my ($curVal) = CtFlv('HD,#Call-ID,call-id', @_);
            foreach(@{$callids}) {
                if($curVal ne $_) {
                    $result = '';   # NG
                }
            }
            CtRlSetEvalResult($context, '1op', '', $result, $curVal);
            return $result;
        },
},

# SYNTAX Rule for RFC3261-8.1-14, RFC3261-12.2-11 (CSeq)
# 
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-14',
    'CA' => 'CSeq',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) ne ''},
    'OK' => \\'The CSeq method(%s) MUST match the method of Request-Line in the request(%s).',
    'NG' => \\'The CSeq method(%s) MUST match the method of Request-Line in the request(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,method',@_), CtFlv('SL,method',@_), @_)},
},


# SYNTAX Rule for RFC3261-8.1-15,  RFC3261-20.16-1 (CSeq)
# 
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-15',
    'CA' => 'CSeq',
    'ET' => 'error',
    'PR' => \q{CtUtIsExistHdr('CSeq', @_)},
    'OK' => \\'The sequence number value(%s) in the CSeq header field MUST be expressible as a 32-bit unsigned integer.', 
    'NG' => \\'The sequence number value(%s) in the CSeq header field MUST be expressible as a 32-bit unsigned integer.', 
    'EX' => \q{CtUtEle(CtFlv('HD,#CSeq,cseqnum', @_), 0, @_) && CtUtEg(CtFlv('HD,#CSeq,cseqnum', @_), 2**31, @_)}
},


# SYNTAX Rule for RFC3261-8.1-16 (CSeq)
# 
# 
# ChangeLog    : 20090305 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-16',
    'CA' => 'CSeq',
    'ET' => 'error',
    'PR' => \q{CtUtIsExistHdr('CSeq', @_)},
    'OK' => \\'The sequence number value(%s) in the CSeq header field MUST be less than 2**31.', 
    'NG' => \\'The sequence number value(%s) in the CSeq header field MUST be less than 2**31.', 
    'EX' => \q{CtUtEg(CtFlv('HD,#CSeq,cseqnum', @_), 2**31, @_)}
},



# SYNTAX Rule for RFC3261-8.1-17 (Max-Forwards)
# 
# 
# ChangeLog    : 20090305 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-17',
    'CA' => 'Max-Forwards',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) ne '')},
    'OK' => 'A UAC MUST insert a Max-Forwards header field into each request it originates.',
    'NG' => 'A UAC MUST insert a Max-Forwards header field into each request it originates.',
    'EX' => \q{CtUtIsExistHdr('Max-Forwards', @_)}
},


# SYNTAX Rule for RFC3261-8.1-18 (Max-Forwards)
# 
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-18',
    'CA' => 'Max-Forwards',
    'ET' => 'warning',
    'PR' => \q{(CtFlv('SL,method',@_) ne '') && CtUtIsExistHdr('Max-Forwards', @_)},
    'OK' => 'The Max-Forwards header field value SHOULD be 70.',
    'NG' => 'The Max-Forwards header field value SHOULD be 70.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Max-Forwards,num', CtRlCxPkt(@_)), '70', @_)}
},


# SYNTAX Rule for RFC3261-8.1-19 (Via)
# 
# 
# ChangeLog    : 20090305 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-19',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) ne '')},
    'OK' => 'A UAC MUST insert a Via into that request.',
    'NG' => 'A UAC MUST insert a Via into that request.',
    'EX' => \q{CtUtIsExistHdr('Via', @_)}
},


# SYNTAX Rule for RFC3261-8.1-20 (Via)
# 
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-20',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{CtUtIsExistHdr('Via', @_)},
    'OK' => \\'The protocol name(%s) and protocol version(%s) in the Via header field MUST be SIP and 2.0.',
    'NG' => \\'The protocol name(%s) and protocol version(%s) in the Via header field MUST be SIP and 2.0.',
    'EX' => sub {
            my ($hexST, $context) = @_;
	    my ($protoname, $version, $tm, $op1, $op2);
            my ($result) = 'OK';

	    $protoname = CtFlv('HD,#Via,records,#ViaParm,protoname', CtRlCxPkt(@_));
	    if (ref($protoname) ne 'ARRAY'){
		$protoname = [$protoname];
	    }
	    foreach $tm (@$protoname){
		$op1 = $tm;
		if (!(CtUtEq($tm, 'SIP'))){
		    $result = '';  # NG
		    last;
		}
	    }

            $version = CtFlv('HD,#Via,records,#ViaParm,version', CtRlCxPkt(@_));
	    if (ref($version) ne 'ARRAY'){
		$version = [$version];
	    }
	    foreach $tm (@$version){
		$op2 = $tm;
		if (!(CtUtEq($tm, '2.0'))){
		    $result = '';  # NG
		    last;
		}
	    }
            CtRlSetEvalResult($context, '2op', '', $result, $op1, $op2);
            return ($result);
        },
},


# SYNTAX Rule for RFC3261-8.1-21 (Via)
# 
#               
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-21',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{CtUtIsExistHdr('Via', @_)},
    'OK' => "The Via header field value MUST contain a branch parameter.", 
    'NG' => "The Via header field value MUST contain a branch parameter.", 
    'EX' => sub {
	my ($via_branch);
	my ($cnt_viaprm) = 0;
	my ($cnt_branch) = 0;
	
	$via_branch = CtFlv('HD,#Via,records,#ViaParm',@_);
	if(ref($via_branch) ne 'ARRAY'){
	    $via_branch = [$via_branch];
	}
	foreach $cur (@$via_branch){
	    $cnt_viaprm ++;
	}

	$via_branch = CtFlv('HD,#Via,records,#ViaParm,params,list,branch',@_);
	if ( $via_branch eq ''){  return '';}

	if (ref($via_branch) ne 'ARRAY') {
	    $via_branch = [$via_branch];
	}
	foreach $cur (@$via_branch) {
	    $cnt_branch ++;
	}

	if ( $cnt_viaprm != $cnt_branch) {
	    return '';
	}
	return 'OK';
    }
},



# SYNTAX Rule for RFC3261-8.1-22 (Via)
# 
#               (branch
# 
#                
{

    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-22',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => sub {
            if (CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaBranch,branch', @_) eq '') {
                return ('');
            }
            # Excepting CANCEL
            if ('CANCEL' eq CtFlv('SL,method', @_)) {
                return ('');
            }
            # Excepting ACK for non-2xx
            if ('ACK' eq CtFlv('SL,method', @_)
                    && CtFlv('SL,code', CtRlCxUsr(@_)->{'pre_res'}) =~ /^[^2]/) {
                return ('');
            }
            if (CtFlv('SL,method',@_) ne '') {
                return ('OK');
            }
        },
    'OK' => 'The branch parameter value MUST be unique across space and time for all requests sent by the UA.', 
    'NG' => 'The branch parameter value MUST be unique across space and time for all requests sent by the UA.', 
    'EX' => sub {
            my ($branches) = CtRlCxUsr(@_)->{'branches'};
            my ($curVal) = CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaBranch,branch', @_);
            if ('ARRAY' eq ref($curVal)) {
                $curVal = @{$curVal}[0];
            }
            foreach(@{$branches}) {
                if($curVal eq $_) {
                    return ('');
                }
            }
            return ('OK');
        },
}, 


# SYNTAX Rule for RFC3261-8.1-23, RFC3261-20.42-1 (Via)
#                (*) RFC3261-20.42-1 is the doc_reference.
# 
#               
# 
# ChangeLog    : 20090305 orimo "Syntax message and EX part updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-23',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#Via,records,params,list,branch',@_) ne ''},
    'OK' => \\'The branch ID (%s) MUST always begin with the characters \"z9hG4bK\".', 
    'NG' => \\'The branch ID (%s) MUST always begin with the characters \"z9hG4bK\".', 
 #   'EX' => \q{CtUtMch(CtFlv('HD,#Via,records,params,list,branch',@_),'^z9hG4bK',@_)}
    'EX' => sub {
	    my ($tm, $tm1);

	    my ($via_branch);

	    $via_branch = CtFlv('HD,#Via,records,params,list,branch',@_);
            if ( $via_branch eq ''){  return '';}
	    
            if (ref($via_branch) ne 'ARRAY') {
		$via_branch = [$via_branch];
	    }
            foreach $tm (@$via_branch) {
		$tm1 = $tm;
		if (!CtUtMch($tm1,'^z9hG4bK',@_)){
		    return '';
		}
	    }
            return 'OK';
       },
},


# SYNTAX Rule for RFC3261-8.1-38 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-38',
    'CA' => 'Route',
    'ET' => 'warning',
    'OK' => 'If the request contains a Route header field, the request SHOULD be sent to the locations derived from its top most value.',
    'NG' => 'If the request contains a Route header field, the request SHOULD be sent to the locations derived from its top most value.',
    'EX' => \q{CtUtIPAdEq(CtFlGet('INET,#IP6,DstAddress', @_)||CtFlGet('INET,#IP4,DstAddress', @_), CtTbCfg('P-CSCFa1', 'address'))},
},

# SYNTAX Rule for RFC3261-13.2-19 (CSeq)
# CSeq number is the same as the CSeq number of the INVITE.
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3261-8.1-24',
        'CA' => 'Contact',
        'ET' => 'error',
        'OK' => 'The Contact header field MUST be present and contain exactly one SIP or SIPS URI in any request that can result in the establishment of a dialog.',
        'NG' => 'The Contact header field MUST be present and contain exactly one SIP or SIPS URI in any request that can result in the establishment of a dialog.',
        'EX' => sub {
                        my($check1, $check2, $check3);

                        $check1 = CtUtIsExistHdr("Contact", @_);
                        if ($check1 == 1) {
                                $check2 = CtFlUriMchScheme(CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#TXT#', @_), ['sip','sips']);
                                $check3 = $#$check2;
                        }

                        if ($check3 == 0) {
                                return ('OK');
                        }else{
                                return ('');
                        }

                },
},


# SYNTAX Rule for RFC3261-8.1-62 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-62',
    'CA' => 'Massege',
    'ET' => 'warning',
    'OK' => 'This new request SHOULD have the same value of the Call-ID, To, and From of the previous request, but the CSeq should contain a new sequence number that is one higher than the previous.',
    'NG' => 'This new request SHOULD have the same value of the Call-ID, To, and From of the previous request, but the CSeq should contain a new sequence number that is one higher than the previous.',
    # 'EX' => \q{PrintVal([CtRlCxDlg(@_),CtSvDlg(CtRlCxDlg(@_),'RemoteSeqNum')+1,CtFlv('HD,#CSeq,cseqnum', @_),
    #                     CtFlv('HD,#From,#REST#', @_),CtFlv('HD,#From,#REST#', CtUtLastSndMsg()),
    #                     CtFlv('HD,#To,#REST#', @_), CtFlv('HD,#To,#REST#', CtRlCxUsr(@_)->{'reg_ini'}),
    #                     CtFlv('HD,#Call-ID,#REST#', @_), CtFlv('HD,#Call-ID,#REST#', CtRlCxUsr(@_)->{'reg_ini'})])}
    'EX' => \q{((CtSvDlg(CtRlCxDlg(@_),'RemoteSeqNum')+1) eq CtFlv('HD,#CSeq,cseqnum', @_)) &&
        	   CtFlv('HD,#From,#REST#', @_) eq CtFlv('HD,#From,#REST#', CtUtLastSndMsg()) &&
        	   CtFlv('HD,#To,#REST#', @_) eq CtFlv('HD,#To,#REST#', CtRlCxUsr(@_)->{'reg_ini'}) &&
        	   CtFlv('HD,#Call-ID,#REST#', @_) eq CtFlv('HD,#Call-ID,#REST#', CtRlCxUsr(@_)->{'reg_ini'})}
},


### 090310 Inoue added
### Allow header
### check point : Allow header exist in 405 response
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-6',
    'CA' => 'Allow',
    'ET' => 'error',
    'OK' => 'The UAS MUST also add an Allow header field to the 405 (Method Not Allowed) response.',
    'NG' => 'The UAS MUST also add an Allow header field to the 405 (Method Not Allowed) response.',
    'EX' => \q{CtUtIsExistHdr('Allow',@_)},
},


# SYNTAX Rule for RFC3261-8.2-17 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-17',
    'CA' => 'Unsupported',
    'ET' => 'error',
    'OK' => 'The UAS MUST add an Unsupported header field, and list in it those options it does not understand amongst those in the Require header field of the request.',
    'NG' => 'The UAS MUST add an Unsupported header field, and list in it those options it does not understand amongst those in the Require header field of the request.',
    'EX' => 
	 sub {
		if(CtUtIsExistHdr('Unsupported',@_)){
			if(CtFlv('HD,#Unsupported,option', @_) eq 'foo'){
				return 'OK';
			}
		}
			return '';
	 },
 },


# SYNTAX Rule for RFC3261-8.2-18, RFC3261-9.1-6 (Headers)
#                 RFC3261-9.1-6
# 
#              Require
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-18',
    'CA' => 'Header',
    'ET' => 'error', 
    'PR' => sub{
            if (CtFlv('SL,method', @_) eq 'CANCEL') {
                return ('OK');
            }
            if (CtFlv('SL,method', @_) eq 'ACK'
                    && CtFlv('SL,code', CtRlCxUsr(@_)->{'pre_res'}) =~ /^[^2]/) {
                return ('OK');
            }
            return ('');    # 
        },
    'OK' => 'Require and Proxy-Require MUST NOT be used in a SIP CANCEL request, or in an ACK request sent for a non-2xx response.',
    'NG' => 'Require and Proxy-Require MUST NOT be used in a SIP CANCEL request, or in an ACK request sent for a non-2xx response.',
    'EX' => \q{!CtUtIsExistHdr('Require',@_) && !CtUtIsExistHdr('Proxy-Require',@_)},
},

# SYNTAX Rule for RFC3261-8.1-30 (Proxy-Require)
# written by suyama(09/3/10)
# 
#                Security-Client/Security-Verify
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.1-30',
    'CA' => 'Proxy-Require',
    'ET' => 'error',
    'PR' => \q{!CtUtEq(CtUtIsExistHdr('Security-Client',@_),0,@_)
		   || !CtUtEq(CtUtIsExistHdr('Security-Verify',@_),0,@_) 
		   || ((CtUtEq(CtUtIsExistHdr('Security-Verify',@_),0,@_) 
		       || CtUtEq(CtUtIsExistHdr('Security-Client',@_),0,@_)) 
		       && !CtUtEq(CtUtIsExistHdr('Proxy-Require',@_),0,@_))},
    'OK' => 'A UAC MUST insert a Proxy-Require header field into the request listing the option tag for that extension.',
    'NG' => 'A UAC MUST insert a Proxy-Require header field into the request listing the option tag for that extension.',
    'EX' => sub {
	my($sc_v,$sc_c,$param,@field,$val);

	$sc_v = CtUtIsExistHdr('Security-Client',@_);
	$sc_c = CtUtIsExistHdr('Security-Verify',@_);
	$param = CtFlv('HD,#Proxy-Require,option',@_);
	@field = split(/,/, $param);

	if(($sc_v || $sc_c) ne 0){
	    if (CtUtEq(CtUtIsExistHdr('Proxy-Require',@_),0,@_)){
		
		return '';

	    }else{
		
		foreach $val (@field){	
		    if ($val =~ /^sec-agree$/m){
			return 'OK';       
		    }
		}
	    }    
	}else{
	    
	    if($palam ne ''){
		return 'OK';
	    }
	    return '';
	}
}
},

### Inoue added 090403
# SYNTAX Rule for RFC3261-8.2-22 (Y.Inoue)
# 
# 

{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-22',
    'CA' => 'Accept',
    'ET' => 'error',
    'PR' => sub{
		if(CtUtIsExistHdr('Accept',@_)){
			return 'OK';
		}
		return '';
	},
    'OK' => 'The response MUST contain an Accept header field listing the types of all bodies it understands, in the event the request contained bodies of types not supported by the UAS.',
    'NG' => 'The response MUST contain an Accept header field listing the types of all bodies it understands, in the event the request contained bodies of types not supported by the UAS.',
    'EX' => sub {
		if(CtUtIsExistHdr('Accept',@_)){
			if((CtFlv('HD,#Accept,#INVALID#',@_)) eq ''){ 
				return 'OK';
			}
		}	
		return '';
	 },
},


### Inoue added 090403
# SYNTAX Rule for RFC3261-8.2-23 (Y.Inoue)
# 
# 

{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-23',
    'CA' => 'Accept-Encoding',
    'ET' => 'error',
    'PR' => sub{
		if(CtUtIsExistHdr('Accept-Encoding',@_)){
			return 'OK';
		}
		return '';
	},
    'OK' => 'If the request contained content encodings not understood by the UAS, the response MUST contain an Accept-Encoding header field listing the encodings understood by the UAS.',
    'NG' => 'If the request contained content encodings not understood by the UAS, the response MUST contain an Accept-Encoding header field listing the encodings understood by the UAS.',
    'EX' => sub {
		if(CtUtIsExistHdr('Accept-Encoding',@_)){
			if((CtFlv('HD,#Accept-Encoding,#INVALID#',@_)) eq ''){ 
				return 'OK';
			}
		}	
		return '';
	 },
},


### Inoue added 090403
# SYNTAX Rule for RFC3261-8.2-22 (Y.Inoue)
# 
# 

{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-24',
    'CA' => 'Accept-Language',
    'ET' => 'error',
    'PR' => sub{
		if(CtUtIsExistHdr('Accept-Language',@_)){
			return 'OK';
		}
		return '';
	},
    'OK' => 'The response MUST contain an Accept header field listing the types of all bodies it understands, in the event the request contained bodies of types not supported by the UAS.',
    'NG' => 'The response MUST contain an Accept header field listing the types of all bodies it understands, in the event the request contained bodies of types not supported by the UAS.',
    'EX' => sub {
		if(CtUtIsExistHdr('Accept-Language',@_)){
			if((CtFlv('HD,#Accept-Language,#INVALID#',@_)) eq ''){ 
				return 'OK';
			}
		}	
		return '';
	 },
},


# SYNTAX Rule for RFC3261-8.2-36 (From)
# 
#               
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-36',
    'CA' => 'From',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method', @_) eq '') 
                && CtUtIsExistHdr('From', @_) 
                && ((CtRlCxUsr(@_)->{'pre_req'} ne ''))
            },
    'OK' => \\'The From field(%s) of the response MUST equal the From header field(%s) of the request.',
    'NG' => \\'The From field(%s) of the response MUST equal the From header field(%s) of the request.',
    'EX' => \q{CtUtEq(CtFlv('HD,#From,#REST#', @_) ,CtFlv('HD,#From,#REST#', CtRlCxUsr(@_)->{'pre_req'}), @_)},
},


# SYNTAX Rule for RFC3261-8.2-37 (Call-ID)
# 
#               
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-37',
    'CA' => 'Call-ID',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method', @_) eq '') && CtUtIsExistHdr('Call-ID', @_) },
    'OK' => \\'The Call-ID header field(%s) of the response MUST equal the Call-ID header field(%s) of the request.',
    'NG' => \\'The Call-ID header field(%s) of the response MUST equal the Call-ID header field(%s) of the request.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Call-ID,#REST#', @_) ,CtFlv('HD,#Call-ID,#REST#', CtRlCxUsr(@_)->{'pre_req'}), @_)},
},


# SYNTAX Rule for RFC3261-8.2-38 (CSeq)
# 
#               
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-38',
    'CA' => 'CSeq',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method', @_) eq '') 
                && CtUtIsExistHdr('CSeq', @_) 
                && ((CtRlCxUsr(@_)->{'pre_req'} ne ''))
            },
    'OK' => \\'The CSeq header field(%s) of the response MUST equal the CSeq field(%s) of the request.',
    'NG' => \\'The CSeq header field(%s) of the response MUST equal the CSeq field(%s) of the request.',
    'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,#REST#', @_) ,CtFlv('HD,#CSeq,#REST#', CtRlCxUsr(@_)->{'pre_req'}), @_)},
},


# SYNTAX Rule for RFC3261-8.2-39 + RFC3261-8.2-40 (Via)
# 
#               
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-39',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method', @_) eq '') 
                && CtUtIsExistHdr('Via', @_) 
                && ((CtRlCxUsr(@_)->{'pre_req'} ne ''))
            },
               
    'OK' => \\'The Via header field values(%s) in the response MUST equal the Via header field values(%s) in the request and MUST maintain the same ordering.',
    'NG' => \\'The Via header field values(%s) in the response MUST equal the Via header field values(%s) in the request and MUST maintain the same ordering.',
    'EX' => \q{CtRlCmpVia(CtFlv('HD,#Via,records,#ViaParm,#TXT#', CtRlCxUsr(@_)->{'pre_req'}), @_)},
},


# SYNTAX Rule for RFC3261-8.2-41 (To)
# 
#               UAS
#               
# 
# ChangeLog    : 20090312 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-41',
    'CA' => 'To',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method', @_) eq '') 
                && CtUtIsExistHdr('To', @_) 
                && ((CtRlCxUsr(@_)->{'pre_req'} ne ''))
                && CtFlv('HD,#To,params,list,tag', CtRlCxUsr(@_)->{'pre_req'})
            },
    'OK' => \\'If a request contained a To tag in the request, the To header field(%s) in the response MUST equal that of the request(%s).',
    'NG' => \\'If a request contained a To tag in the request, the To header field(%s) in the response MUST equal that of the request(%s).', 
    'EX' => \q{CtUtEq(CtFlv('HD,#To,#REST#', @_) ,CtFlv('HD,#To,#REST#', CtRlCxUsr(@_)->{'pre_req'}), @_)},
},


# SYNTAX Rule for RFC3261-8.2-42 (To)
# 
#               UAS
#               
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-42',
    'CA' => 'To',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method', @_) eq '') 
                && CtUtIsExistHdr('To', @_) 
                && ((CtRlCxUsr(@_)->{'pre_req'} ne ''))
                && !CtFlv('HD,#To,params,list,tag', CtRlCxUsr(@_)->{'pre_req'})
            },
    'OK' => \\'If the To header field in the request did not contain a tag, the URI(%s) in the To header field in the response MUST equal the URI(%s) in the To header field.',
    'NG' => \\'If the To header field in the request did not contain a tag, the URI(%s) in the To header field in the response MUST equal the URI(%s) in the To header field.',
    'EX' => \q{CtUtEq(CtFlv('HD,#To,addr,#TXT#', @_) ,CtFlv('HD,#To,addr,#TXT#', CtRlCxUsr(@_)->{'pre_req'}), @_)},
},


# SYNTAX Rule for RFC3261-8.2-43 (To-tag)
# 
#               UAS
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-43',
    'CA' => 'To',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method', @_) eq '') 
                && CtUtIsExistHdr('To', @_) 
                && ((CtRlCxUsr(@_)->{'pre_req'} ne ''))
                && !CtFlv('HD,#To,params,list,tag', CtRlCxUsr(@_)->{'pre_req'})
                && (CtFlv('SL,code', @_) ne '100')
            },
    'OK' => 'If the To header field in the request did not contain a tag, the UAS MUST add a tag to the To header field in the response.',
    'NG' => 'If the To header field in the request did not contain a tag, the UAS MUST add a tag to the To header field in the response.',
    'EX' => sub {
            my ($hexST, $context) = @_;
            my ($result,$tag);
            if($tag=CtFlv('HD,#To,params,list,tag-id',@_)){
                $result = 'OK';
            }
            CtRlSetEvalResult($context, '1op', '', $result, $tag);
            return $result;
        },
},


# SYNTAX Rule for RFC3261-8.2-44 (To-tag)
# 
#               
# 
# ChangeLog    : 20090312 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-8.2-44',
    'CA' => 'To',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method', @_) eq '') 
                && (CtFlv('SL,code', @_) ne '100')
                && CtUtIsExistHdr('To', @_) 
                && CtFlv('HD,#To,params,list,tag-id',@_)
                && (CtSvDlg(CtRlCxDlg(@_), 'RemoteTag') ne '')
            },
    'OK' => 'The same tag MUST be used for all responses to that request, both final and provisional.',
    'NG' => 'The same tag MUST be used for all responses to that request, both final and provisional.',
    'EX' => \q{CtUtEq(CtFlv('HD,#To,params,list,tag-id',@_), CtSvDlg(CtRlCxDlg(@_), 'RemoteTag'), @_)},
},


# SYNTAX Rule for RFC3261-9.1-2 (Headers)
# 
#              
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-9.1-2',
    'CA' => 'Header',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'CANCEL'},
    'OK' => 'The Request-URI, Call-ID, To, the numeric part of CSeq, and From header fields in the CANCEL request MUST be identical to those in the request being cancelled, including tags.',
    'NG' => 'The Request-URI, Call-ID, To, the numeric part of CSeq, and From header fields in the CANCEL request MUST be identical to those in the request being cancelled, including tags.',
    'EX' => sub {
            my ($hexST, $context) = @_;
            my ($result) = 'OK';

            # INVITE
            my ($msg) = CtRlPKTGet(CtNDAct(),   # 
                            '',
                            'before',   # 
                            'top',      # 
                            'in',       # 
                            ['INET,#SIP,SL,method', "INVITE"]                               
                             );

            if ((CtFlv('SL,uri,#TXT#', $msg) ne CtFlv('SL,uri,#TXT#', @_))
                || (CtFlv('HD,#Call-ID,call-id', $msg) ne CtFlv('HD,#Call-ID,call-id', @_))
                || (CtFlv('HD,#To,addr,#TXT#', $msg) ne CtFlv('HD,#To,addr,#TXT#', @_))
                || (CtFlv('HD,#CSeq,cseqnum', $msg) ne CtFlv('HD,#CSeq,cseqnum', @_))
                || (CtFlv('HD,#From,addr,#TXT#', $msg) ne CtFlv('HD,#From,addr,#TXT#', @_))
                || (CtFlv('HD,#From,params,list,#TagParam,tag-id', $msg) ne CtFlv('HD,#From,params,list,#TagParam,tag-id', @_))
                )
            {
                $result = '';
            }
            
            return $result;
        }
},


# SYNTAX Rule for RFC3261-9.1-3 (Via)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-9.1-3',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'CANCEL'},
    'OK' => "A CANCEL constructed by a client MUST have only a single Via header field value matching the top Via value in the request being cancelled.", 
    'NG' => "A CANCEL constructed by a client MUST have only a single Via header field value matching the top Via value in the request being cancelled.", 
    'EX' => sub {
            my ($hexST, $context) = @_;
            my ($result) = '';  # NG

            my ($cseqnum)   = CtFlv('HD,#CSeq,cseqnum', @_);

            # 
            my ($msg) = CtRlPKTGet(CtNDAct(),   # 
                            '',
                            'before',   # 
                            'top',      # 
                            'in',       # 
                            ['INET,#SIP,HD,#CSeq,cseqnum', $cseqnum]                                
                             );
                             
            if (!CtUtEq(ref(CtFlv('HD,#Via', @_)), 'ARRAY', @_)
                && (CtFlv('HD,#Via,records,#ViaParm,#TXT#', $msg) eq CtFlv('HD,#Via,records,#ViaParm,#TXT#', @_))
                )
            {
                $result = 'OK';
            }
            
            return ($result);
        }
},


# SYNTAX Rule for RFC3261-9.1-4 (CSeq)
# 
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-9.1-4',
    'CA' => 'CSeq',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'CANCEL'},
    'OK' => \\'The CSeq method(%s) MUST have a value of CANCEL.',
    'NG' => \\'The CSeq method(%s) MUST have a value of CANCEL.',
    'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,method',@_), "CANCEL", @_)},
},


# SYNTAX Rule for RFC3261-9.1-5 (Route)
# 
# 
#               
# ChangeLog    : 20090306 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-9.1-5',
    'CA' => 'Route',
    'ET' => 'error',
    'PR' => sub {
            my ($hexST, $context) = @_;
            my ($result) = '';  # NG

            my ($cseqnum)   = CtFlv('HD,#CSeq,cseqnum', @_);

            # 
            my ($msg) = CtRlPKTGet(CtNDAct(),   # 
                            '',
                            'before',   # 
                            'top',      # 
                            'in',       # 
                            ['INET,#SIP,HD,#CSeq,cseqnum', $cseqnum]                                
                             );

            if ((CtFlv('SL,method',@_) eq 'CANCEL') 
                && CtUtIsExistHdr('Route', $msg)) {
                $result = 'OK';
            }
            return $result;
        },
    'OK' => 'If the request being cancelled contains a Route header field, the CANCEL request MUST include that Route header field\'s values.',   
    'NG' => 'If the request being cancelled contains a Route header field, the CANCEL request MUST include that Route header field\'s values.',   
    'EX' => sub {
            my ($hexST, $context) = @_;
            my ($result) = '';  # NG
            
            my ($cseqnum)   = CtFlv('HD,#CSeq,cseqnum', @_);

            # 
            my ($msg) = CtRlPKTGet(CtNDAct(),   # 
                            '',
                            'before',   # 
                            'top',      # 
                            'in',       # 
                            ['INET,#SIP,HD,#CSeq,cseqnum', $cseqnum]                                
                             );
            if (CtUtEq(CtFlv('HD,#Route,routes,#RouteParam,addr,#TXT#', $msg), 
                 CtFlv('HD,#Route,routes,#RouteParam,addr,#TXT#', @_))) {
                $result = 'OK';
            }

            return $result;
        }
},

# SYNTAX Rule for RFC3261-9.1-11 (CANCEL)
# 
#               
#               
# 
# ChangeLog    : 20090306 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-9.1-11',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'CANCEL'},
    'OK' => \\'The destination address, port, and transport(%s) for the CANCEL MUST be identical to those(%s) used to send the original request.',
    'NG' => \\'The destination address, port, and transport(%s) for the CANCEL MUST be identical to those(%s) used to send the original request.',
    'EX' => sub {
            my ($hexST, $context) = @_;
            my ($result) = 'OK';
            my ($ipaddr1, $port1, $transport1);
            my ($ipaddr2, $port2, $transport2);

            my ($cseqnum)   = CtFlv('HD,#CSeq,cseqnum', @_);

            # 
            my ($msg) = CtRlPKTGet(CtNDAct(),   # 
                            '',
                            'before',   # 
                            'top',      # 
                            'in',       # 
                            ['INET,#SIP,HD,#CSeq,cseqnum', $cseqnum]                                
                             );
            # IPv4 is OUT OF SCOPE at Logo.
            if (CtTbPrm('CI,protocol') eq 'INET') {
                # IP address
                $ipaddr1 = CtFlGet('INET,#IP4,DstAddress', $hexST);
                $ipaddr2 = CtFlGet('INET,#IP4,DstAddress', $msg);
                if (!CtUtV4Eq($ipaddr1, $ipaddr2)) {
                    $result = '';   # NG
                    goto JUMP;
                }
                
                # transport
            #  $transport1 = CtFlGet('INET,#IP4,Protocol', $hexST);
            #  $transport2 = CtFlGet('INET,#IP4,Protocol', $msg);
                if (CtFlGet('INET,#UDP', $hexST) ne ''){
                    $transport1 = 'UDP';
                }elsif (CtFlGet('INET,#TCP', $hexST) ne '' ) {
                    $transport1 = 'TCP';
                }else{
                    $result =  ''; # NG
                }
                if (CtFlGet('INET,#UDP', $msg) ne ''){
                    $transport2 = 'UDP';
                }elsif (CtFlGet('INET,#TCP', $msg) ne '' ) {
                    $transport2 = 'TCP';
                }else{
                    $result =  ''; # NG
                }

                if ($transport1 ne $transport2) {
                    $result =  '';  # NG
                    goto JUMP;
                }
                
                # port
            #  if ($transport1 eq '17') {
                if ($transport1 eq 'UDP') {
                    # UDP
                    $port1 = CtFlGet('INET,#UDP,DstPort', $hexST);
                    $port2 = CtFlGet('INET,#UDP,DstPort', $msg);
                    if ($port1 ne $port2) {
                        $result =  '';  # NG
                        goto JUMP;
                    }
            #  } elsif ($transport1 eq '6') {
                } elsif ($transport1 eq 'TCP') {
                    # TCP
                    $port1 = CtFlGet('INET,#TCP,DstPort', $hexST);
                    $port2 = CtFlGet('INET,#TCP,DstPort', $msg);
                    if ($port1 ne $port2) {
                        $result =  '';  # NG
                        goto JUMP;
                    }
                } else {
                    $result =  '';  # NG
                    goto JUMP;
                }

            # IPv6 is necessary.
            } elsif (CtTbPrm('CI,protocol') eq 'INET6') {
                    # IP address
                $ipaddr1 = CtFlGet('INET,#IP6,DstAddress', $hexST);
                $ipaddr2 = CtFlGet('INET,#IP6,DstAddress', $msg);

                if (!CtUtV6Eq($ipaddr1, $ipaddr2)) {
                    $result = '';   # NG
                    goto JUMP;
                }

                # transport
            #  $transport1 = CtFlGet('INET,#IP6,NextPayload', $hexST);
            #  $transport2 = CtFlGet('INET,#IP6,NextPayload', $msg);
                if (CtFlGet('INET,#UDP', $hexST) ne ''){
                    $transport1 = 'UDP';
                }elsif (CtFlGet('INET,#TCP', $hexST) ne '' ) {
                    $transport1 = 'TCP';
                }else{
                    $result = ''; # NG
                }
                if (CtFlGet('INET,#UDP', $msg) ne ''){
                    $transport2 = 'UDP';
                }elsif (CtFlGet('INET,#TCP', $msg) ne '' ) {
                    $transport2 = 'TCP';
                }else{
                    $result = ''; # NG
                }
#PrintFA($msg);
#PrintFA($hexST);
#printf("tra1=%s tra2=%s\n", $transport1, $transport2);

                if ($transport1 ne $transport2) {
                    $result = '';   # NG
                    goto JUMP;
                }

                # port
            ##  if ($transport1 eq '17') {
                if ($transport1 eq 'UDP') {
                    # UDP
                    $port1 = CtFlGet('INET,#UDP,DstPort', $hexST);
                    $port2 = CtFlGet('INET,#UDP,DstPort', $msg);
#printf("prot1=%s port2=%s\n",$port1,$port2);
                    if ($port1 ne $port2) {
                        $result = '';   # NG
                        goto JUMP;
                    }
            #  } elsif ($transport1 eq '6') {
                } elsif ($transport1 eq 'TCP') {
                    # TCP
                    $port1 = CtFlGet('INET,#TCP,DstPort', $hexST);
                    $port2 = CtFlGet('INET,#TCP,DstPort', $msg);
                    if ($port1 ne $port2) {
                        $result = '';   # NG
                        goto JUMP;
                    }
                } else {
                    $result = '';   # NG
                    goto JUMP;
                }
            } else {
                $result = '';   # NG
                goto JUMP;
            }
JUMP:
        #  if ($transport1 eq '17') {$transport1 = 'UDP'}
        #  elsif ($transport1 eq '6') {$transport1 = 'TCP'}
        #  if ($transport2 eq '17') {$transport2 = 'UDP'}
        #  elsif ($transport2 eq '6') {$transport2 = 'TCP'}
            my ($op1) = $ipaddr1.' / '.$port1.' / '.$transport1;
            my ($op2) = $ipaddr2.' / '.$port2.' / '.$transport2;
            CtRlSetEvalResult($context, '2op', '', $result, $op1, $op2);

            return $result;
        },
},

# SYNTAX Rule for RFC3261-9.2-2 (Status-Line)
# 
# 
# ChangeLog    : 20090306 orimo "Syntax message updated"
{
 'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-9.2-2',
 'CA' => 'Message',
 'ET' => 'warning',
 'OK' => 'The Status-Code in the Status-Line SHOULD be a \"487(Request Terminated)\".',
 'NG' => 'The Status-Code in the Status-Line SHOULD be a \"487(Request Terminated)\".',
 'EX' =>  \q{(CtFlv('SL,code', @_) eq '487')},
},


# SYNTAX Rule for RFC3261-9.2-3 (To-tag)
# 
# 
{
 'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-9.2-3',
 'CA' => 'To',
 'ET' => 'warning',
 'OK' => \\'The To tag(%s) of the response to the CANCEL and To tag(%s) in the response to the original request SHOULD be the same. ',
 'NG' => \\'The To tag(%s) of the response to the CANCEL and To tag(%s) in the response to the original request SHOULD be the same. ',
 'EX' => sub{
             my ($hexST, $context) = @_;
         my ($to_tag1, $to_tag2);
         my ($result) = 'OK';
         
         my ($cseqnum)  = CtFlv('HD,#CSeq,cseqnum', $hexST);
         
         # 
         my ($msg) = CtRlPKTGet(CtNDAct(),  # 
                    '',
                    'before',   # 
                    'top',  # 
                    'in',   # 
                    ['INET,#SIP,HD,#CSeq,cseqnum', $cseqnum] 
                    );
         # To-tag
         $to_tag1 = CtFlv('HD,#To,params,list,tag-id',$hexST);
         $to_tag2 = CtFlv('HD,#To,params,list,tag-id',$msg);
         if (!(CtUtEq($to_tag1, $to_tag2))){
         $result = ''; # NG
         }

         CtRlSetEvalResult($context, '2op', '', $result, $to_tag1, $to_tag2);
         return $result;
     },
},

# SYNTAX Rule for RFC3261-9.2-6
# 481
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3261-9.2-1',
        'CA' => 'Message',
        'ET' => 'warning',
        'OK' => 'The UAS SHOULD respond to the CANCEL with a 481 (Call Leg/Transaction Does Not Exist',
        'NG' => 'The UAS SHOULD respond to the CANCEL with a 481 (Call Leg/Transaction Does Not Exist',
        'EX' => '',
},


# SYNTAX Rule for RFC3261-10.2-4 (Request-URI)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-10.2-4',
    'CA' => 'Request',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => 'The "userinfo" and "@" components of the SIP URI MUST NOT be present.',
    'NG' => 'The "userinfo" and "@" components of the SIP URI MUST NOT be present.',
    'EX' => sub { return CtUtTrue( !CtFlv('SL,uri,userinfo', CtRlCxPkt(@_)) && (CtFlv('SL,uri,#TXT#', CtRlCxPkt(@_)) !~ /\@/),@_ ); },
},

# SYNTAX Rule for RFC3261-10.2-5 (To)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-10.2-5',
    'CA' => 'To',
    'ET' => 'error',
#    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => 'An address-of-record field included in To header field MUST be a SIP URI or SIPS URI.',
    'NG' => 'An address-of-record field included in To header field MUST be a SIP URI or SIPS URI.',
    'EX' => \q{CtFlUriMchScheme(CtFlv('HD,#To,addr,uri,#TXT#',@_),['sip','sips'])?'T':''}
},


# SYNTAX Rule for RFC3261-10.2-6 (Call-ID)
# 
#               
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-10.2-6',
    'CA' => 'Call-ID',
    'ET' => 'warning',
    'PR' => \q{(CtFlv('SL,method',@_) eq 'REGISTER') 
            && (CtTbl('DLG,dlg0,CallID') ne '')},
    'OK' => \\'All registrations from a UAC SHOULD use the same Call-ID header field value (%s) for registrations sent to a particular registrar.',
    'NG' => \\'All registrations from a UAC SHOULD use the same Call-ID header field value (%s) for registrations sent to a particular registrar.',
    'EX' => sub {
            my ($hexST, $context) = @_;
            my ($result) = 'OK';
            my ($callids) = CtRlCxUsr(@_)->{'callids'};
            my ($curVal) = CtFlv('HD,#Call-ID,call-id', @_);
            foreach(@{$callids}) {
                if($curVal ne $_) {
                    $result = '';   # NG
                }
            }
            CtRlSetEvalResult($context, '1op', '', $result, $curVal);
            return $result;
        },
},


# SYNTAX Rule for RFC3261-10.2-7 (CSeq)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-10.2-7',
    'CA' => 'CSeq',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,method',@_) eq 'REGISTER') && (CtSvDlg(CtRlCxDlg(@_), 'RemoteSeqNum'))},
    'OK' => \\'A UA MUST increment the CSeq value(%s) by one for each REGISTER request(%s) with the same Call-ID.',
    'NG' => \\'A UA MUST increment the CSeq value(%s) by one for each REGISTER request(%s) with the same Call-ID.',
    'EX' => \q{CtUtEq(CtSvDlg(CtRlCxDlg(@_), 'RemoteSeqNum')+1, CtFlv('HD,#CSeq,cseqnum', @_), @_)},
},


# SYNTAX Rule for RFC3261-10.2-9 (Contact)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-10.2-9',
    'CA' => 'Contact',
    'ET' => 'warning',
    'PR' => \q{(CtFlv('SL,method',@_) eq 'REGISTER') && CtUtIsExistHdr('Contact', @_)},
    'OK' => 'UACs SHOULD NOT use the "action" parameter.',
    'NG' => 'UACs SHOULD NOT use the "action" parameter.',
    'EX' => \q{CtUtIsNonMember('action', CtFlv('HD,#Contact,c-params,h-params,list,#GenericParam,tag', CtRlCxPkt(@_)), @_)},
},

# SYNTAX Rule for RFC3261-10.2-15 ()
# 
#                
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-10.2-15',
    'CA' => 'Call-ID',
    'ET' => 'warning',
    'OK' => \\'A UA(%s) SHOULD use the same Call-ID(%s) for all registrations during a single boot cycle.',
    'NG' => \\'A UA(%s) SHOULD use the same Call-ID(%s) for all registrations during a single boot cycle.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Call-ID,call-id', @_),CtFlv('HD,#Call-ID,call-id',CtRlCxUsr(@_)->{'reg_ini'}),@_)}
},

# SYNTAX Rule for RFC3261-10.2-16 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-10.2-16',
    'CA' => 'Message',
    'ET' => 'warning',
    'OK' => \\'Registration refreshes SHOULD be sent to the same network address(%s) as the original registration(%s).',
    'NG' => \\'Registration refreshes SHOULD be sent to the same network address(%s) as the original registration(%s).',
    'EX' => \q{CtUtEq(CtFlv('SL,uri,host',@_) . CtFlv('SL,uri,port',@_),
		   (CtFlv('SL,uri,host',CtRlCxUsr(@_)->{'reg_ini'}) . CtFlv('SL,uri,port',CtRlCxUsr(@_)->{'reg_ini'})),@_)},
},

# SYNTAX Rule for RFC3261-10.2-18 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-10.2-18',
    'CA' => 'Massege',
    'ET' => 'warning',
    'OK' => 'The UAC SHOULD NOT immediately re-attempt a registration to the same registrar.',
    'NG' => 'The UAC SHOULD NOT immediately re-attempt a registration to the same registrar.',
},

# SYNTAX Rule for RFC3261-10.3-2 (Record-Route)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-10.3-2',
    'CA' => 'Record-Route',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'REGISTER'},
    'OK' => 'The UA MUST NOT include the Record-Route header field in a REGISTER request. ',
    'NG' => 'The UA MUST NOT include the Record-Route header field in a REGISTER request. ',
    'EX' => \q{CtUtEq(CtFlv('HD,#Record-Route,tag',@_),"",@_)},
},


# SYNTAX Rule for RFC3261-11-1 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-11-1',
    'CA' => 'Allow',
    'ET' => 'error',
    'OK' => 'All UAs MUST support the OPTIONS method.',
    'NG' => 'All UAs MUST support the OPTIONS method.',
    'EX' => sub {
                my ($Allow);
                $Allow = CtFlv('HD,#Allow,methods,list,#Method,method', @_);

                if(grep{$_ eq 'OPTIONS'}(@$Allow)){
                        return 'OK';
                }
        return '';
        },
},



# SYNTAX Rule for RFC3261-11.1-1 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-11.1-1',
    'CA' => 'Accept',
    'ET' => 'warning',
    'OK' => 'An Accept header field SHOULD be included to indicate the type of message body the UAC wishes to receive in the response.',
    'NG' => 'An Accept header field SHOULD be included to indicate the type of message body the UAC wishes to receive in the response.',
    'EX' =>
        sub{
                if(CtUtIsExistHdr('Accept',@_)){
                        if(CtFlv('HD,#Accept,range', @_) ne ''){
                                return 'OK';
                        }
                }
                return '';
        },

},


# SYNTAX Rule for RFC3261-11.2-2 (headers)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-11.2-2',
    'CA' => 'Header',
    'ET' => 'error',
    'PR' => \q{(CtFlv('SL,code', @_) eq '200')},
    'OK' => 'Allow,Accept,Accept-Encoding,Accept-Language,and Supported header fields SHOULD be present in a 200(OK) response to an OPTIONS request.', 
    'NG' => 'Allow,Accept,Accept-Encoding,Accept-Language,and Supported header fields SHOULD be present in a 200(OK) response to an OPTIONS request.', 
    'EX' =>\q{CtUtIsExistHdr('Allow',@_) 
                && CtUtIsExistHdr('Accept',@_) 
                && CtUtIsExistHdr('Accept-Encoding',@_)
                && CtUtIsExistHdr('Accept-Language',@_)
                && CtUtIsExistHdr('Supported',@_)
            },
},


#--------------------------------------------------------------------------------------------
# Bodies:
# If the types include one that can describe media capabilities, the UAS SHOULD
# include a body in the response for that purpose. [RFC3261-11.2-4]
#
# 
# 11.2 Processing of OPTIONS Request
#  A message body MAY be sent, the type of which is determined by the
#  Accept header field in the OPTIONS request (application/sdp is the
#  default if the Accept header field is not present).  If the types
#  include one that can describe media capabilities, the UAS SHOULD
#  include a body in the response for that purpose.  Details on the
#  construction of such a body in the case of application/sdp are
#  described in [13].
#--------------------------------------------------------------------------------------------
# 
# 
# 
# XXX:
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3261-11.2-4',
	'CA' => 'Body',	
	'ET' => 'warning',
#	'PR' => \q{ CtFlv('SL,method',CtRlCxUsr(@_)->{'pre_req'}) eq 'OPTIONS' },	# 
	'OK' => 'If the types include one that can describe media capabilities, the UAS SHOULD include a body in the response for that purpose.',
	'NG' => 'If the types include one that can describe media capabilities, the UAS SHOULD include a body in the response for that purpose.',
	'EX' => [
		sub {
			my ($msg) = CtRlCxPkt(@_);  # 
			my ($pre_req);
			my ($types);

			$pre_req = CtRlCxUsr(@_)->{'pre_req'};	# 
			if (!$pre_req) {
				CtSvError('fatal', "pre_req is not specified(S.RFC3261-11.1-5)");
				return '';
			}
			if (CtFlv('SL,method',$pre_req) ne 'OPTIONS') {
				CtSvError('fatal', "pre_req is not OPTIONS(S.RFC3261-11.1-5)");
				return '';
			}
			$types = CtFlv('HD,#Accept,range',$pre_req);
			if (!$types) {
				# XXX:Accept
				$types = 'application/sdp';
			}
			if ($types =~ /application\/sdp/i ) {
				# XXX: application/sdp
				# 
				if (!CtFlp('BD', $msg)) {
					return '';	# NG
				}
			} else {
				# XXX:application/sdp
			#	MsgPrint('WAR', "pre_req has unsupported Accept header value[$types](S.RFC3261-11.1-5)\n");
				CtSvError('fatal', "pre_req(OPTIONS) has unsupported Accept header value[$types](S.RFC3261-11.1-5)");
			}
			return 'OK';
	},
	],
},

# SYNTAX Rule for RFC3261-12-2 (Record-Route)
# Record-Route
{'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-12.1-2',
 'CA' => 'Record-Route',
 'ET' => 'error',
 'PR' => \q{CtUtIsExistHdr('Record-Route',CtRlCxUsr(@_)->{'pre_req'})},
 'OK' => 'When a UAS responds to a request with a response that establishes a dialog, the UAS MUST copy all Record-Route header field values from the request into the response.',
 'NG' => 'When a UAS responds to a request with a response that establishes a dialog, the UAS MUST copy all Record-Route header field values from the request into the response.',
 'EX' => \q{ CtUtEq(CtFlv('HD,#Record-Route,routes,addr,#TXT#',@_), CtFlv('HD,#Record-Route,routes,addr,#TXT#', CtRlCxUsr(@_)->{'pre_req'}), @_) },
},


# SYNTAX Rule for RFC3261-12-2 (Record-Route)
# Record-Route
{'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-12.1-3',
 'CA' => 'Record-Route',
 'ET' => 'error',
 'PR' => \q{CtUtIsExistHdr('Record-Route',CtRlCxUsr(@_)->{'pre_req'})},
 'OK' => 'MUST maintain the order of Record-Route values from the request.',
 'NG' => 'MUST maintain the order of Record-Route values from the request.',
 'EX' => \q{ CtUtEq(CtFlv('HD,#Record-Route,routes,addr,#TXT#',@_), CtFlv('HD,#Record-Route,routes,addr,#TXT#', CtRlCxUsr(@_)->{'pre_req'}), @_) },
},


# SYNTAX Rule for RFC3261-12-4 (Headers)
# 
# 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3261-12.1-4',
	'CA' => 'Contact',
	'ET' => 'error',
#	'PR' => \q{CtFlv('SL,method',@_) ne ''},
	'OK' => "The UAS MUST add a Contact header field to the response. ", 
	'NG' => "The UAS MUST add a Contact header field to the response. ", 
	'EX' =>\q{CtUtIsExistHdr('Contact',@_)},
},

# SYNTAX Rule for RFC3261-12.1-5 (Contact)
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.1-5',
    'CA' => 'Contact',
    'ET' => 'error',
    'OK' => 'The URI provided in the Contact header field MUST be a SIP or SIPS URI.',
    'NG' => 'The URI provided in the Contact header field MUST be a SIP or SIPS URI.',
    'EX' => \q{CtFlUriMchScheme(CtFlv('HD,#Contact,c-params,#ContactParam,addr,uri,#TXT#', @_),['sip','sips'])?'T':''}
},


# SYNTAX Rule for RFC3261-12.2-1 (To)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-1',
    'CA' => 'To',
    'ET' => 'error',
    'OK' => \\'The URI(%s) in the To field of the request MUST be set to the remote URI from the dialog state(%s).',
    'NG' => \\'The URI(%s) in the To field of the request MUST be set to the remote URI from the dialog state(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#To,addr,uri,#TXT#',@_),CtSvDlg(CtRlCxDlg(@_),'LocalURI,AoR'),@_)} 
},

# SYNTAX Rule for RFC3261-12.2-2 (To)
# written by suyama (09/3/13)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-2',
    'CA' => 'To',
    'ET' => 'error',
    'OK' => \\'The tag(%s) in the To header field of the request MUST be set to the remote tag of the dialog ID(%s).',
    'NG' => \\'The tag(%s) in the To header field of the request MUST be set to the remote tag of the dialog ID(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#To,params,list,#TagParam,tag-id',@_),CtSvDlg(CtRlCxDlg(@_),'LocalTag'),@_)}, 
},


# SYNTAX Rule for RFC3261-12.2-3 (From)
# written by suyama (09/3/13)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-3',
    'CA' => 'From',
    'ET' => 'error',
    'OK' => \\'The From URI(%s) of the request MUST be set to the local URI from the dialog state(%s).',
    'NG' => \\'The From URI(%s) of the request MUST be set to the local URI from the dialog state(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#From,addr,uri,#TXT#',@_),CtSvDlg(CtRlCxDlg(@_),'RemoteURI,AoR'),@_)} 
},

# SYNTAX Rule for RFC3261-12.2-4 (From)
# written by suyama (09/3/13)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-4',
    'CA' => 'From',
    'From' => 'error',
    'OK' => \\'The tag(%s) in the From header field of the request MUST be set to the local tag of the dialog ID(%s).',
    'NG' => \\'The tag(%s) in the From header field of the request MUST be set to the local tag of the dialog ID(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#From,params,list,#TagParam,tag-id',@_),CtSvDlg(CtRlCxDlg(@_),'RemoteTag'),@_)}, 
},

# SYNTAX Rule for RFC3261-12.2-6 (Call-ID)
# written by suyama (09/3/13)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-6',
    'CA' => 'Call-ID',
    'ET' => 'error',
    'OK' => \\'The Call-ID(%s) of the request MUST be set to the Call-ID of the dialog(%s).',
    'NG' => \\'The Call-ID(%s) of the request MUST be set to the Call-ID of the dialog(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Call-ID,call-id',@_),CtSvDlg(CtRlCxDlg(@_),'CallID'),@_)}, 
},

#  SYNTAX Rule for RFC3261-12.2-7 (Cseq)
# written by suyama (09/3/13)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-7',
    'CA' => 'CSeq',
    'PR' => \q{(CtSvDlg(CtRlCxDlg(@_), 'RemoteSeqNum') ne '')},
    'ET' => 'error',
    'OK' => 'Requests within a dialog MUST contain strictly monotonically increasing and contiguous CSeq sequence numbers in each direction.',
    'NG' => 'Requests within a dialog MUST contain strictly monotonically increasing and contiguous CSeq sequence numbers in each direction.',
    'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,cseqnum', @_), CtSvDlg(CtRlCxDlg(@_), 'RemoteSeqNum')+1, @_)},
},

# SYNTAX Rule for RFC3261-12.2-8 (Cseq)
# written by suyama (09/3/13)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-8',
    'CA' => 'CSeq',
    'PR' => \q{(CtSvDlg(CtRlCxDlg(@_), 'RemoteSeqNum') ne '')},
    'ET' => 'error',
    'OK' => 'The value of the local sequence number MUST be incremented by one if the local sequence number is not empty.',
    'NG' => 'The value of the local sequence number MUST be incremented by one if the local sequence number is not empty.',
    'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,cseqnum', @_), CtSvDlg(CtRlCxDlg(@_), 'RemoteSeqNum')+1, @_)},
},

# SYNTAX Rule for RFC3261-12.2-9 (Cseq)
# written by suyama (09/3/13)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-9',
    'CA' => 'CSeq',
    'PR' => \q{(CtSvDlg(CtRlCxDlg(@_), 'RemoteSeqNum') ne '')},
    'ET' => 'error',
    'OK' => \\'The value of the local sequence number(%s) that be incremented by one MUST be placed into the CSeq header(%s) field if the local sequence number is not empty.',
    'NG' => \\'The value of the local sequence number(%s) that be incremented by one MUST be placed into the CSeq header(%s) field if the local sequence number is not empty.',
    'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,cseqnum', @_), CtSvDlg(CtRlCxDlg(@_), 'RemoteSeqNum')+1, @_)},
},

 # SYNTAX Rule for RFC3261-10.2-13 (Expires)
 # written by suyama (09/3/18)
 # 
 # 
 {
     'TY' => 'SYNTAX',
     'ID' => 'S.RFC3261-10.2-13',
     'CA' => 'Expires',
     'ET' => 'error',
     'PR' => \q{(CtFlv('HD,#Contact,c-params,#STAR,star',@_) ne '')},
     'OK' => 'The REGISTER-specific Contact header field value of "*" applies to all registrations, but it MUST NOT be used unless the Expires header field is present with a value of "0".',
     'NG' => 'The REGISTER-specific Contact header field value of "*" applies to all registrations, but it MUST NOT be used unless the Expires header field is present with a value of "0".',
     'EX' => \q{CtUtEq(CtFlv('HD,#Expires,seconds',@_),0,@_)},
 },

# SYNTAX Rule for RFC3261-12.2-14 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-14',
    'CA' => 'Request-URI',
    'ET' => 'error',
    'PR' => \q{my $dlg = CtRlCxDlg(@_); my @route = reverse(@{CtSvDlg($dlg,'RouteSet')}); CtFlv('HD,#Route,routes,#RouteParam#0,addr,uri,params,list,#LrParam,tag',@_) && CtSvDlg($dlg,'RouteSet') && (ref(CtSvDlg($dlg,'RouteSet')) ? (@route->[0] =~ /;lr/i) : (CtSvDlg($dlg,'RouteSet') =~ /;lr/i))},
    'OK' => 'The UAC MUST place the remote target URI into the Request-URI if the route set is not empty and the first URI in the route set contains the lr parameter.',
    'NG' => 'The UAC MUST place the remote target URI into the Request-URI if the route set is not empty and the first URI in the route set contains the lr parameter.',
    'EX' => sub { my $uri=quotemeta(CtSvDlg(CtRlCxDlg(@_),'LocalURI,Contact'));return (CtFlv('SL,#TXT#', @_) =~ /$uri/);}
},

# SYNTAX Rule for RFC3261-12.2-15 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-15',
    'CA' => 'Route',
    'ET' => 'error',
    'PR' => \q{my $dlg = CtRlCxDlg(@_); my @route = reverse(@{CtSvDlg($dlg,'RouteSet')}); CtFlv('HD,#Route,routes,#RouteParam#0,addr,uri,params,list,#LrParam,tag',@_) && CtSvDlg($dlg,'RouteSet') && (ref(CtSvDlg($dlg,'RouteSet')) ? (@route->[0] =~ /;lr/i) : (CtSvDlg($dlg,'RouteSet') =~ /;lr/i))},
#    'PR' => \q{my $dlg = CtRlCxDlg(@_); CtFlv('HD,#Route,routes,#RouteParam#0,addr,uri,params,list,#LrParam,tag',@_) && CtSvDlg($dlg,'RouteSet') && (ref(CtSvDlg($dlg,'RouteSet')) ? (CtSvDlg($dlg,'RouteSet')->[0] =~ /;lr/i) : (CtSvDlg($dlg,'RouteSet') =~ /;lr/i))},
    'OK' => 'The UAC MUST include a Route header field containing the route set values in order including all parameters if the route set is not empty, and the first URI in the route set contains the lr parameter.',
    'NG' => 'The UAC MUST include a Route header field containing the route set values in order including all parameters if the route set is not empty, and the first URI in the route set contains the lr parameter.',
    'EX' => sub { 
	my($route,$rcv_route);

	$dlg = CtRlCxDlg(@_);
	$routeset = CtSvDlg($dlg,'RouteSet');
	@route = reverse(@{$routeset});
	
	$route = quotemeta(join(',',@route)); 
	$rcv_pkt = CtFlv('HD,#Route,#REST#', @_);
	$rcv_pkt=~ s/(\s+)//g;
	
	return $rcv_pkt =~ /$route/i;
    }
    
#    'EX' => sub { my $route = join(',',@{CtSvDlg(CtRlCxDlg(@_),'RouteSet')}); return CtFlv('HD,#Route,#TXT#', @_) =~ /$route/i; },
},

# SYNTAX Rule for RFC3261-12.2-23 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-12.2-23',
    'CA' => 'Massege',
    'ET' => 'warning',
    'OK' => 'The UAC SHOULD terminate the dialog.',
    'NG' => 'The UAC SHOULD terminate the dialog.',
    'EX' => \q{CtFlv('HD,#Call-ID,call-id', @_) ne CtFlv('HD,#Call-ID,call-id', CtRlCxUsr(@_)->{'pre_req'})}
},

# SYNTAX Rule for RFC3261-13.1-1 (Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-13.1-1',
    'CA' => 'Allow',
    'ET' => 'error',
    'OK' => 'A UA that supports INVITE MUST also support ACK, CANCEL and BYE.',
    'NG' => 'A UA that supports INVITE MUST also support ACK, CANCEL and BYE.',
    'EX' => sub {
                my ($Allow);
                my ($a_tag);
                $Allow = CtFlv('HD,#Allow,methods,list,#Method,method', @_);
                @$a_tag = ("BYE", "ACK", "CANCEL");

                if(grep{$_ eq 'INVITE'}(@$Allow)){
                        if(CtUtCompTree($Allow, $a_tag)){
                                return 'OK';
                        }
                }

        return '';

        },
},



# SYNTAX Rule for RFC3261-13.2-1 (Allow)
# Allow header should exist in INVITE message.
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3261-13.2-1',
        'CA' => 'Allow',
        'ET' => 'warning',
        'OK' => 'An Allow header field SHOULD be present in the INVITE.',
        'NG' => 'An Allow header field SHOULD be present in the INVITE.',
        'EX' => \q{CtUtIsExistHdr("Allow",@_)},
},


# SYNTAX Rule for RFC3261-13.2-3 (Supported)
# Supported header should exist in INVITE message.
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3261-13.2-3',
        'CA' => 'Supported',
        'ET' => 'warning',
        'OK' => 'A Supported header field SHOULD be present in the INVITE.',
        'NG' => 'A Supported header field SHOULD be present in the INVITE.',
        'EX' => \q{CtUtIsExistHdr("Supported",@_)},
},


#--------------------------------------------------------------------------------------------
# If the initial offer is in an INVITE, the answer MUST be in a reliable non-failure message 
# from UAS back to UAC which is correlated to that INVITE. [RFC3261-13.2-6][RFC3261-13.3-11]
#--------------------------------------------------------------------------------------------
# 
# 
# 
# 
#    
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3261-13.2-6',
	'CA' => 'Body',
	'ET' => 'error',
#	'PR' => [
#		sub {
#				my ($code);
#				if (CtFlv('SL,method',CtRlCxUsr(@_)->{'pre_req'}) ne 'INVITE') {
#					# 
#					return 0;
#				}
#				$code = CtFlv('SL,code' CtRlCxPkt(@_));
#			#	if ( ($code <= 100) or ($code >= 300) ) {
#			#		#
#				if ( ($code < 200) or ($code >= 300) ) {
#					#
#					return 0;
#				}
#				return 1;
#		},
#	],
	'OK' => 'The answer MUST be in a reliable non-failure message from UAS back to UAC which is correlated to that INVITE if the initial offer is in an INVITE.',
	'NG' => 'The answer MUST be in a reliable non-failure message from UAS back to UAC which is correlated to that INVITE if the initial offer is in an INVITE.',
	'EX' => [
		sub {
			my ($msg) = CtRlCxPkt(@_);  # 
			my ($pre_req);

			$pre_req = CtRlCxUsr(@_)->{'pre_req'};	# 
			if (!$pre_req) {
				CtSvError('fatal', "pre_req is not specified(S.RFC3261-13.2-6)");
				return '';
			}
			if (CtFlv('SL,method',$pre_req) ne 'INVITE') {
				MsgPrint('WAR', "pre_req is not INVITE(S.RFC3261-13.2-6)\n");
			}

			# 
			if (CtFlp('BD', $pre_req) && CtFlp('BD', $msg)) {
			    return 'ON';
			}
			return '';	# NG
		}
	],
},

# SYNTAX Rule for RFC3261-13.2-12 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-13.2-12',
    'CA' => 'Body',
    'ET' => 'error',
    'PR' => '',     #
    'OK' => 'The Session Description Protocol MUST be supported by all user agents as a means to describe sessions.',
    'NG' => 'The Session Description Protocol MUST be supported by all user agents as a means to describe sessions.',
    'EX' => \q{CtFlp('BD', CtRlCxPkt(@_))},
},



# SYNTAX Rule for RFC3261-13.2-18
# ACK
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3261-13.2-18',
        'CA' => 'Message',
        'ET' => 'error',
        'OK' => 'The UAC core MUST generate an ACK request for each 2xx received from the transaction layer.',
        'NG' => 'The UAC core MUST generate an ACK request for each 2xx received from the transaction layer.',
        'EX' => '',
},

# SYNTAX Rule for RFC3261-13.2-19 (CSeq)
# CSeq number is the same as the CSeq number of the INVITE.
{
        'TY' => 'SYNTAX',
        'ID' => 'S.RFC3261-13.2-19',
        'CA' => 'CSeq',
        'ET' => 'error',
        'OK' => \\'The sequence number(%s) of the CSeq header field MUST be the same as the INVITE(%s) being acknowledged.',
        'NG' => \\'The sequence number(%s) of the CSeq header field MUST be the same as the INVITE(%s) being acknowledged.',
        'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,cseqnum', CtRlCxPkt(@_)), CtFlv('HD,#CSeq,cseqnum', CtRlCxUsr(@_)->{'pre_req'}), @_)},
},

# SYNTAX Rule for RFC3261-13.2-20 (CSeq)
# 
# 
# ChangeLog    : 20090305 kenzo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-13.2-20',
    'CA' => 'CSeq',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'ACK'},
    'OK' => \\'The CSeq method(%s) MUST be ACK.',
    'NG' => \\'The CSeq method(%s) MUST be ACK.',
    'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,method',@_), 'ACK', @_)},
},


# SYNTAX Rule for RFC3261-13.3-9 (Warning)
# 
# 
# ChangeLog    : 20090309 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-13.3-9',
    'CA' => 'Warning',
    'ET' => 'warning',
    'PR' => \q{(CtFlv('SL,code', @_) eq '488')}, 
    'OK' => '488 response SHOULD include a Warning header field value explaining why the offer was rejected.',
    'NG' => '488 response SHOULD include a Warning header field value explaining why the offer was rejected.',
    'EX' =>  \q{CtUtTrue(CtUtIsExistHdr('Warning',@_)) &&
		   CtUtTrue(CtFlv('HD,#Warning,code', @_)) &&
		   CtUtTrue(CtFlv('HD,#Warning,text', @_)) },
},


# SYNTAX Rule for RFC3261-13-36 (Headers)
# 
# 
{
	'TY' => 'SYNTAX',
	'ID' => 'S.RFC3261-13.3-10',
	'CA' => 'Header',
	'ET' => 'warning',
#	'PR' => \q{CtFlv('SL,method',@_) ne ''},
	'OK' => "A 2xx response to an INVITE SHOULD contain the Allow header field and the Supported header field.", 
	'NG' => "A 2xx response to an INVITE SHOULD contain the Allow header field and the Supported header field.", 
	'EX' =>\q{CtUtIsExistHdr('Allow',@_) && CtUtIsExistHdr('Supported',@_) 
			},
},

# SYNTAX Rule for RFC3261-17.1-1 (Status-code)
# 
#                Thus TUs should respond immediately to non-INVITE request.
#                Status-Line 
# 
# ChangeLog    : 20090306 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-17.1-1',
    'CA' => 'Message',
    'ET' => 'warning',
    'PR' => \q{(CtFlv('SL,method', @_) eq '')}, 
    'OK' => 'TUs SHOULD respond immediately to non-INVITE requests.',
    'NG' => 'TUs SHOULD respond immediately to non-INVITE requests.',
    'EX' =>  \q{(CtFlv('SL,code', @_) eq '200')},
},

### ACK
### S.RFC3261-17.1-16
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-17.1-16',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'The client transaction MUST NOT generate an ACK.',
    'NG' => 'The client transaction MUST NOT generate an ACK.',
    'EX' => '',
},


# SYNTAX Rule for RFC3261-17.1-17 (Message)
# 
#                Thus TUs should respond immediately to non-INVITE request.
#                Status-Line 
# 
# ChangeLog    : 20090310 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-17.1-17',
    'CA' => 'Message',
    'ET' => 'warning',
    'PR' => \q{(CtFlv('SL,method', @_) ne '')}, 
    'OK' => 'In the "Proceeding" state, the client transaction SHOULD NOT retransmit the request any longer.',
    'NG' => 'In the "Proceeding" state, the client transaction SHOULD NOT retransmit the request any longer.',
    'EX' =>  \q{!(CtFlv('SL,method', @_) eq 'INVITE')},
},


# SYNTAX Rule for RFC3261-17.1-23 (Message)
# 
#               
# 
# ChangeLog    : 20090310 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-17.1-23',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'ACK'},
    'OK' => \\'The ACK MUST be sent(%s) to the same address, port, and transport to which the original request was sent(%s).',
    'NG' => \\'The ACK MUST be sent(%s) to the same address, port, and transport to which the original request was sent(%s).',
    'EX' => sub {
            my ($hexST, $context) = @_;
	    my ($org_req, $context2) = CtRlCxUsr(@_)->{'pre_req'};	# 
	      if (!$org_req) {
		  CtSvError('fatal', "pre_req is not specified.");
		  return '';
	      }
            my ($result) = 'OK';
            my ($ipaddr1, $port1, $transport1);
            my ($ipaddr2, $port2, $transport2);

            my ($cseqnum)   = CtFlv('HD,#CSeq,cseqnum', @_);


            # IPv4 is OUT OF SCOPE at Logo.
            if (CtTbPrm('CI,protocol') eq 'INET') {
                # IP address
                $ipaddr1 = CtFlGet('INET,#IP4,DstAddress', $hexST);
                $ipaddr2 = CtFlGet('INET,#IP4,DstAddress', $org_req);
                if (!CtUtV4Eq($ipaddr1, $ipaddr2)) {
                    $result = '';   # NG
                    goto JUMP;
                }
                
                # transport
                 if (CtFlGet('INET,#UDP', $hexST) ne ''){
                    $transport1 = 'UDP';
                }elsif (CtFlGet('INET,#TCP', $hexST) ne '' ) {
                    $transport1 = 'TCP';
                }else{
                    $result =  ''; # NG
                }
                if (CtFlGet('INET,#UDP', $org_req) ne ''){
                    $transport2 = 'UDP';
                }elsif (CtFlGet('INET,#TCP', $org_req) ne '' ) {
                    $transport2 = 'TCP';
                }else{
                    $result =  ''; # NG
                }

                if ($transport1 ne $transport2) {
                    $result =  '';  # NG
                    goto JUMP;
                }
                
                # port
                 if ($transport1 eq 'UDP') {
                    # UDP
                    $port1 = CtFlGet('INET,#UDP,DstPort', $hexST);
                    $port2 = CtFlGet('INET,#UDP,DstPort', $org_req);
                    if ($port1 ne $port2) {
                        $result =  '';  # NG
                        goto JUMP;
                    }
                 } elsif ($transport1 eq 'TCP') {
                    # TCP
                    $port1 = CtFlGet('INET,#TCP,DstPort', $hexST);
                    $port2 = CtFlGet('INET,#TCP,DstPort', $org_req);
                    if ($port1 ne $port2) {
                        $result =  '';  # NG
                        goto JUMP;
                    }
                } else {
                    $result =  '';  # NG
                    goto JUMP;
                }

            # IPv6 is necessary.
            } elsif (CtTbPrm('CI,protocol') eq 'INET6') {
		# IP address
                $ipaddr1 = CtFlGet('INET,#IP6,DstAddress', $hexST);
                $ipaddr2 = CtFlGet('INET,#IP6,DstAddress', $org_req);

                if (!CtUtV6Eq($ipaddr1, $ipaddr2)) {
                    $result = '';   # NG
                    goto JUMP;
                }

                # transport
                if (CtFlGet('INET,#UDP', $hexST) ne ''){
                    $transport1 = 'UDP';
                }elsif (CtFlGet('INET,#TCP', $hexST) ne '' ) {
                    $transport1 = 'TCP';
                }else{
                    $result = ''; # NG
                }
                if (CtFlGet('INET,#UDP', $org_req) ne ''){
                    $transport2 = 'UDP';
                }elsif (CtFlGet('INET,#TCP', $org_req) ne '' ) {
                    $transport2 = 'TCP';
                }else{
                    $result = ''; # NG
                }

                if ($transport1 ne $transport2) {
                    $result = '';   # NG
                    goto JUMP;
                }

                # port
                if ($transport1 eq 'UDP') {
                    # UDP
                    $port1 = CtFlGet('INET,#UDP,DstPort', $hexST);
                    $port2 = CtFlGet('INET,#UDP,DstPort', $org_req);

                    if ($port1 ne $port2) {
                        $result = '';   # NG
                        goto JUMP;
                    }
            #  } elsif ($transport1 eq '6') {
                } elsif ($transport1 eq 'TCP') {
                    # TCP
                    $port1 = CtFlGet('INET,#TCP,DstPort', $hexST);
                    $port2 = CtFlGet('INET,#TCP,DstPort', $org_req);
                    if ($port1 ne $port2) {
                        $result = '';   # NG
                        goto JUMP;
                    }
                } else {
                    $result = '';   # NG
                    goto JUMP;
                }
            } else {
                $result = '';   # NG
                goto JUMP;
            }
JUMP:
            my ($op1) = $ipaddr1.' / '.$port1.' / '.$transport1;
            my ($op2) = $ipaddr2.' / '.$port2.' / '.$transport2;
            CtRlSetEvalResult($context, '2op', '', $result, $op1, $op2);

            return $result;
        },
},

### ACK
### S.RFC3261-17.1-25
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-17.1-25',
    'CA' => 'Message',
    'ET' => 'error',
    'PR' => '',
    'OK' => 'Any retransmissions of the final response that are received while in the "Completed" state MUST cause the ACK to be re-passed to the transport layer for retransmission.',
    'NG' => 'Any retransmissions of the final response that are received while in the "Completed" state MUST cause the ACK to be re-passed to the transport layer for retransmission.',
    'EX' => '',
},


# SYNTAX Rule for RFC3261-17.1-32 (Headers)
# 
# 
# ChangeLog    : 20090310 orimo "Syntax message updated"
#
  {
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-17.1-32',
    'CA' => 'Header',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'ACK'},
    'OK' => \\'The ACK request constructed by the client transaction MUST contain values for the Call-ID, From, and Request-URI(%s) that are equal to the values of those header fields in the request(%s) passed to the transport by the client transaction.',

    'NG' => \\'The ACK request constructed by the client transaction MUST contain values for the Call-ID, From, and Request-URI(%s) that are equal to the values of those header fields in the request(%s) passed to the transport by the client transaction.', 
    'EX' => sub{
            my ($hexST, $context) = @_;
            my ($callid1, $callid2, $from_uri1, $from_uri2, $from_tag1, $from_tag2, $uri1, $uri2);
            my ($op1, $op2);
            my ($result) = 'OK';

            my ($cseqnum)   = CtFlv('HD,#CSeq,cseqnum', $hexST);

            # 
            my ($msg) = CtRlPKTGet(CtNDAct(),   # 
                            '',
                            'before',   # 
                            'top',      # 
                            'in',       # 
                            ['INET,#SIP,HD,#CSeq,cseqnum', $cseqnum, 'INET,#SIP,HD,#CSeq,method', 'INVITE']                             
                             );

            # Call-ID
            $callid1 =  CtFlv('HD,#Call-ID,call-id',$hexST);
            $callid2 =  CtFlv('HD,#Call-ID,call-id',$msg);
            if (!(CtUtEq($callid1, $callid2))){
                $result = ''; # NG
            }

            # From-URI
            $from_uri1 = CtFlv('HD,#From,addr,#TXT#',$hexST);
            $from_uri2 = CtFlv('HD,#From,addr,#TXT#',$msg);
            if (!(CtUtEq($from_uri1, $from_uri2))){
                $result = ''; # NG
            }

            # From-tag
            $from_tag1 = CtFlv('HD,#From,params,list,tag-id',$hexST);
            $from_tag2 = CtFlv('HD,#From,params,list,tag-id',$msg);
            if (!(CtUtEq($from_tag1, $from_tag2))){
                $result = ''; # NG
            }

            # Request-URI
            $uri1 = CtFlv('SL,uri,#TXT#',$hexST);
            $uri2 = CtFlv('SL,uri,#TXT#',$msg);
            if (!(CtUtEq($uri1, $uri2))){
                $result = ''; # NG
            }

            $op1 = join('/', $callid1, $from_uri1, $from_tag1, $uri1);
            $op2 = join('/', $callid2, $from_uri2, $from_tag2, $uri2);
            CtRlSetEvalResult($context, '2op', '', $result, $op1, $op2);
            return $result;
            }
}, # end - S.RFC3261-17.1-32


# SYNTAX Rule for RFC3261-17.1-33 (To)
# 
# 
# ChangeLog    : 20090310 orimo "Syntax message updated"
#
{'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-17.1-33',
 'CA' => 'To',
 'ET' => 'error',
 'OK' => \\'The To header field(%s) in the ACK MUST equal the To header field(%s) in the response being acknowledged.', 
 'NG' => \\'The To header field(%s) in the ACK MUST equal the To header field(%s) in the response being acknowledged.', 
 'EX' => sub{
            # Use 'pre_res'of scenario.
            my ($hexST, $context) = @_;
            my ($to_uri1, $to_uri2, $tp_tag1, $tp_tag2);
            my ($op1, $op2);
            my ($result) = 'OK';

            # To-URI
            $to_uri1 = CtFlv('HD,#To,addr,#TXT#', $hexST);
            $to_uri2 = CtFlv('HD,#To,addr,#TXT#', CtRlCxUsr(@_)->{'pre_res'});
            if (!(CtUtEq($to_uri1, $to_uri2))){
                $result = ''; # NG
            }

            # To-tag
            $to_tag1 = CtFlv('HD,#To,params,list,tag-id',$hexST);
            $to_tag2 = CtFlv('HD,#To,params,list,tag-id',CtRlCxUsr(@_)->{'pre_res'});
            if (!(CtUtEq($to_tag1, $to_tag2))){
                $result = ''; # NG
            }

            $op1 = join('/', $to_uri1, $to_tag1);
            $op2 = join('/', $to_uri2, $to_tag2);
            CtRlSetEvalResult($context, '2op', '', $result, $op1, $op2);
            return $result;
            }
}, # end - S.RFC3261-17.1-33


# SYNTAX Rule for RFC3261-17.1-34 (Via)
# 
# 
# ChangeLog    : 20090310 orimo "Syntax message updated"
{'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-17.1-34',
 'CA' => 'Via',
 'ET' => 'error',
 'PR' => \q{CtFlv('SL,method',@_) eq 'ACK'},
 'OK' => 'The ACK MUST contain a single Via header field.',
 'NG' => 'The ACK MUST contain a single Via header field.',
 'EX' => \q{ !CtUtEq(ref(CtFlv('HD,#Via,records', @_)), 'ARRAY', @_)},    
}, # end - S.RFC3261-17.1-34


# SYNTAX Rule for RFC3261-17.1-35 (Via)
# 
#               
# 
# ChangeLog    : 20090310 orimo "Syntax message updated"
{'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-17.1-35',
 'CA' => 'Via',
 'ET' => 'error',
 'PR' => \q{ (CtFlv('SL,method',@_) eq 'ACK')},
 'OK' => 'The single Via header field MUST be equal to the top Via header field of the original request.',
 'NG' => 'The single Via header field MUST be equal to the top Via header field of the original request.',
  'EX' => \q{ (CtUtEq(CtFlv('HD,#Via,records,#ViaParm,#TXT#', CtRlCxPkt(@_)) , CtFlv('HD,#Via,records,#ViaParm,#TXT#', CtRlCxUsr(@_)->{'pre_req'}), @_ )  &&  !CtUtEq(ref(CtFlv('HD,#Via', @_)), 'ARRAY', @_))},
}, # end - S.RFC3261-17.1-35


# SYNTAX Rule for RFC3261-17.1-36 (CSeq)
# 
#              
# 
# ChangeLog    : 20090310 orimo "Syntax message updated"
{'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-17.1-36',
 'CA' => 'CSeq',
 'ET' => 'error',
 'PR' => \q{CtFlv('SL,method',@_) eq 'ACK'},
 'OK' => \\'The CSeq header field in the ACK(%s) MUST contain the same value for the sequence number as was present in the original request(%s).', 
 'NG' => \\'The CSeq header field in the ACK(%s) MUST contain the same value for the sequence number as was present in the original request(%s).', 
 'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,cseqnum',CtRlCxPkt(@_)), CtFlv('HD,#CSeq,cseqnum',CtRlCxUsr(@_)->{'pre_req'}), @_)}, }, # end - S.RFC3261-17.1-36


# SYNTAX Rule for RFC3261-17.1-37 (CSeq)
# 
# 
# ChangeLog    : 20090311 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-17.1-37',
    'CA' => 'CSeq',
    'ET' => 'error',
    'PR' => \q{CtFlv('SL,method',@_) eq 'ACK'},
    'OK' => 'The method parameter MUST be equal to \"ACK\".',
    'NG' => 'The method parameter MUST be equal to \"ACK\".',
    'EX' => \q{CtUtEq(CtFlv('HD,#CSeq,method',@_), "ACK", @_)},
},


# SYNTAX Rule for RFC3261-17.1-38 (Route)
# 
# 
# NOTE
# ChangeLog    : 20090311 orimo "Syntax message updated"

{'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-17.1-38',
 'CA' => 'Route',
 'ET' => 'error',
 'PR' => \q{ (CtFlv('SL,method',@_) eq 'ACK') && CtUtIsExistHdr('Route', CtRlCxUsr(@_)->{'pre_req'}) },
 'OK' => 'The Route header fields MUST appear in the ACK if the INVITE request whose response is being acknowledged had Route header fields.', 
 'NG' => 'The Route header fields MUST appear in the ACK if the INVITE request whose response is being acknowledged had Route header fields.', 
 'EX' => \q{CtUtEq( CtFlv('HD,#Route,#REST#', CtRlCxPkt(@_)), CtFlv('HD,#Route,#REST#', CtRlCxUsr(@_)->{'pre_req'}), @_)},
 }, # end - S.RFC3261-17.1-38


# SYNTAX Rule for RFC3261-17.1-39 (Body)
# 
# 
# ChangeLog    : 20090305 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-17.1-39',
    'CA' => 'body',
    'ET' => 'warning',
    'PR' => \q{CtFlv('SL,method',@_) eq 'ACK'},
    'OK' => 'Placement of bodies in ACK for non-2xx is NOT RECOMMENDED.', 
    'NG' => 'Placement of bodies in ACK for non-2xx is NOT RECOMMENDED.', 
    'EX' => \q{!CtFlp('BD', CtRlCxPkt(@_))}
},


# SYNTAX Rule for RFC3261-18.1-7 (Via)
# written by suyama (09/3/10) 
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-18.1-7',
    'CA' => 'Via',
    'ET' => 'error',
    'OK' => 'The client transport MUST insert a value of the "sent-by" field into the Via header field.',
    'NG' => 'The client transport MUST insert a value of the "sent-by" field into the Via header field.',
    'EX' => \q{CtFlv('HD,#Via,records,#ViaParm,sentby,host',@_)}
}, 


# SYNTAX Rule for RFC3261-18.1-8 (Via)
# written by suyama (09/3/13)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-18.1-8',
    'CA' => 'Via',
    'ET' => 'warning',
    'OK' => 'The usage of an FQDN in sent-by field is RECOMMENDED.',
    'NG' => 'The usage of an FQDN in sent-by field is RECOMMENDED.',
    'EX' => sub { my $host = CtFlv('HD,#Via,records,#ViaParm,sentby,host',@_);
		  return $host && !CtUtIp($host);}
},    

# SYNTAX Rule for RFC3261-18.2-5 (Via)
# 
# 
# ChangeLog    : 20090306 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-18.2-5',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => sub {
            my ($sentby);
            $sentby = CtFlv('HD,#Via#0,records,#ViaParm#0,sentby,host', CtRlCxPkt(@_));
            if ($sentby eq '') {
                return '';
            }
            if (CtUtIp($sentby)) {
                if (CtTbPrm('CI,protocol') eq 'INET6') {
                    $sentby =~ s/\[(.+)\]/$1/;
                    if (CtUtV6Eq($sentby, CtTbAd('local-ip', $DIRRoot{'ACTND'}))) {
                        return '';
                    }
                }
                else {
                    if (CtUtV4Eq($sentby, CtTbAd('local-ip', $DIRRoot{'ACTND'}))) {
                        return '';
                    }
                }
            }
            return 'OK';
        },
    'OK' => 'If the host portion of the "sent-by" parameter contains a domain name, or if it contains an IP address that differs from the packet source address, the server MUST add a "received" parameter to that Via header field value.',
    'NG' => 'If the host portion of the "sent-by" parameter contains a domain name, or if it contains an IP address that differs from the packet source address, the server MUST add a "received" parameter to that Via header field value.',
    'EX' => sub{
	# [] 
	#PrintVal(CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaExtension,extension', CtRlCxPkt(@_)));
	# [] 
	#PrintVal(CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaReceived,tag', CtRlCxPkt(@_)));

#	if(CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaExtension,extension', CtRlCxPkt(@_)) || 
#          CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaReceived,tag', CtRlCxPkt(@_) )){
	if( CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaReceived,tag', CtRlCxPkt(@_) )){
	    return 'OK';
	}else{
	    return '';
	}
    },
},


# SYNTAX Rule for RFC3261-18.2-6 (Via)
# 
# 
# ChangeLog    : 20090306 orimo "Syntax message, PR and EX part updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-18.2-6',
    'CA' => 'Via',
    'ET' => 'error',
#    'PR' => \q{CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaExtension,extension', CtRlCxPkt(@_)) || 
#               CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaReceived,tag', CtRlCxPkt(@_) )},
    'PR' => \q{CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaReceived,tag', CtRlCxPkt(@_) )},
    'OK' => 'The "received" parameter MUST contain the source address from which the packet was received.',
    'NG' => 'The "received" parameter MUST contain the source address from which the packet was received.',
    'EX' => sub {
            my ($received, $ip);

#            $received = CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaExtension,extension', CtRlCxPkt(@_));
#	    if ($received ne ''){
#		$received =~ s/received=//;
#		$received =~ s/\[|\]|\s+//g;
#	    }else{
		$received = CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaReceived,addr,ip', CtRlCxPkt(@_));
		if ($received eq ''){
		    return ''; #NG
		}
#	    }
	    $ip = CtTbAd('local-ip', $DIRRoot{'ACTND'});
	    CtRlSetEvalResult($_[1], '2op', 'EQ', '', $received, $ip);
	    if (CtUtIp($received)) {
		if (CtTbPrm('CI,protocol') eq 'INET6') {
		    return CtUtV6Eq($received, $ip);
		}
		else {
		    return CtUtV4Eq($received, $ip);
		}
	    }
	    return 'OK';
       },
},


# SYNTAX Rule for RFC3261-18.2-13 (Via)
# 
#                using the port indicated in the "sent-by" value, or using port 5060 
#                if none is specified explicitly.
# 
# ChangeLog    : 20090306 orimo "New"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-18.2-13',
    'CA' => 'Via',
    'ET' => 'error',
    'PR' => \q{CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaReceived,tag', CtRlCxPkt(@_)) && (CtFlGet('INET,#UDP', CtRlCxPkt(@_)) ne '') },
    'OK' => \\'The response(%s) MUST be sent to the address in the \"received\" parameter(%s)\, using the port indicated in the \"sent-by\" value, or using port 5060 if none is specified explicitly.',
    'NG' => \\'The response(%s) MUST be sent to the address in the \"received\" parameter(%s)\, using the port indicated in the \"sent-by\" value, or using port 5060 if none is specified explicitly.',
   'EX' => sub {
            my ($hexST, $context) = @_;
            my ($result) = 'OK';
            my ($ipaddr1, $port1);
            my ($received, $r_port);

		$received = CtFlv('HD,#Via#0,records,#ViaParm#0,params,list,#ViaReceived,addr,ip', $hexST);
		if ($received eq ''){
		    return ''; #NG
		}

	    # sent-by
	    $r_port = CtFlv('HD,#Via#0,records,#ViaParm#0,sentby,port', $hexST);
	    if ($r_port eq ''){$r_port = '5060';}


            # IPv4 is OUT OF SCOPE at Logo.
            if (CtTbPrm('CI,protocol') eq 'INET') {
                # IP address
                $ipaddr1 = CtFlGet('INET,#IP4,DstAddress', $hexST);
                if (!CtUtV4Eq($ipaddr1, $received)) {
                    $result = '';   # NG
                    goto JUMP;
                }
                
		# port
		# UDP
		$port1 = CtFlGet('INET,#UDP,DstPort', $hexST);
		if ($port1 ne $r_port) {
		    $result =  '';  # NG
		    goto JUMP;
		}

            # IPv6 is necessary.
            } elsif (CtTbPrm('CI,protocol') eq 'INET6') {
		# IP address
                $ipaddr1 = CtFlGet('INET,#IP6,DstAddress', $hexST);
                 if (!CtUtV6Eq($ipaddr1, $received)) {
                    $result = '';   # NG
                    goto JUMP;
                }

                # port
		# UDP
		$port1 = CtFlGet('INET,#UDP,DstPort', $hexST);
		if ($port1 ne $r_port) {
		    $result = '';   # NG
		    goto JUMP;
		}
	    }

JUMP:
            my ($op1) = $ipaddr1.' / '.$port1;
            my ($op2) = $received.' / '.$r_port;
            CtRlSetEvalResult($context, '2op', '', $result, $op1, $op2);

            return $result;
        },
},


# SYNTAX Rule for RFC3261-20-13 (Headers)
# 
# 
{'TY' => 'SYNTAX',
 'ID' => 'S.RFC3261-20-13',
 'CA' => 'Header',
 'ET' => 'error',
 'OK' => \\"If Contact, From and To header fields contain URI with a comma, question mark or semicolon, the URI MUST be enclosed in angle brackets (< and >). (%s)", 
 'NG' => \\"If Contact, From and To header fields contain URI with a comma, question mark or semicolon, the URI MUST be enclosed in angle brackets (< and >). (%s)", 
 'EX' => sub{my($ad,@hdrlist,$i,$field);
         if(CtUtIsExistHdr("Contact",@_)){
         @hdrlist = ("From","To","Contact");
         foreach $i (@hdrlist){
             CtUtIsExistHdr($i,@_);  ## for %s
             $field = "HD\,#" . $i . "\,addr\,#TXT#";
	     if ($i eq 'Contact') {
		 $field = "HD\,#" . $i . "\,c\-params\,addr\,#TXT#";
	     }
             $ad=CtFlv($field,@_); 
	     if(CtUtEq(ref($ad), 'ARRAY', @_)) {
		 return '';
	     }
             if($ad =~ /[;\?\,]/){
             $ad =~ s/^ *//;
             $ad =~ s/ *$//;
             if( !(($ad =~ /^</)&&($ad =~ />$/)) ){
                 return '';}  #NG
             }
         }
         return 'OK';
         }else{      
         @hdrlist = ("From","To");
         foreach $i (@hdrlist){
             CtUtIsExistHdr($i,@_);  ## for %s
             $field = "HD\,#" . $i . "\,addr\,#TXT#";
             $ad=CtFlv($field,@_); 
	     if(CtUtEq(ref($ad), 'ARRAY', @_)) {
		 return '';
	     }
             if($ad =~ /[;\?\,]/){
             $ad =~ s/^ *//;
             $ad =~ s/ *$//;
             if( !(($ad =~ /^</)&&($ad =~ />$/)) ){
                 return '';}  #NG
             }
         }
         return 'OK';
         }
     }
},

# SYNTAX Rule for RFC3261-20.10-1 (Contact)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-20.10-1',
    'CA' => 'Contact',
    'ET' => 'error',
    'OK' => 'Even if the "display-name" is empty, the "name-addr" form MUST be used if the "addr-spec" contains a comma, semicolon, or question mark.',
    'NG' => 'Even if the "display-name" is empty, the "name-addr" form MUST be used if the "addr-spec" contains a comma, semicolon, or question mark.',
    'EX' => sub {
	my($urls,$url,$err);
	# 
	$urls = CtFlGet('INET,#SIP,HD,#Contact,c-params,addr',@_[0],'T');
	foreach $url (@$urls){
	    $err ||= ($url->{'#TXT#'} =~ /[;?,]/ && $url->{'#Name#'} ne 'NameAddr');
	}
	$err ||= CtFlGet('INET,#SIP,HD,#Contact,#INVALID#',@_);
	return !$err;}
},

# SYNTAX Rule for RFC3261-20.14-1 (Content-Length)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-20.14-1',
    'CA' => 'Content-Length',
    'ET' => 'warning', 
    'OK' => \\'Applications SHOULD use this field to indicate the size of the message-body(%s) to be transferred(%s).',
    'NG' => \\'Applications SHOULD use this field to indicate the size of the message-body(%s) to be transferred(%s).',
    'EX' => \q{CtUtEq(CtFlv('HD,#Content-Length',@_) ? CtFlv('HD,#Content-Length,Length', @_) : 0,length(CtFlp('BD', @_)),@_)}
},


# SYNTAX Rule for RFC3261-20.14-3 (Content-Length)
# 
# 
# ChangeLog    : 20090305 orimo "Syntax message updated"
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-20.14-3',
    'CA' => 'Content-Length',
    'ET' => 'error',
    'PR' => \q{!CtFlp('BD', CtRlCxPkt(@_)) && CtUtIsExistHdr('Content-Length', @_)},
    'OK' => 'If no body is present in a message, then the Content-Length header value MUST be set to zero.', 
    'NG' => 'If no body is present in a message, then the Content-Length header value MUST be set to zero.', 
    'EX' => \q{CtFlv('HD,#Content-Length,Length', CtRlCxPkt(@_)) eq '0'}
},


# SYNTAX Rule for RFC3261-20.15-1 (Content-Type)
# If body is not empty, Content-Type header exist.
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-20.15-1',
    'CA' => 'Content-Type',
    'ET' => 'error',
    'PR' => \q{CtFlp('BD',CtRlCxPkt(@_))},
    'OK' => 'The Content-Type header field MUST be present if the body is not empty.',
    'NG' => 'The Content-Type header field MUST be present if the body is not empty.',
    'EX' => \q{CtUtIsExistHdr("Content-Type",@_)},
},

# SYNTAX Rule for RFC3261-20.20-2 ()
# 
# 
#        
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-20.20-2',
    'CA' => 'From',
    'ET' => 'error',
    'OK' => 'Even if the "display-name" is empty, the "name-addr" form MUST be used if the "addr-spec" contains a comma, question mark, or semicolon.',
    'NG' => 'Even if the "display-name" is empty, the "name-addr" form MUST be used if the "addr-spec" contains a comma, question mark, or semicolon.',
    'EX' => sub {return !(CtFlv('HD,#From,#INVALID#',@_) || 
			  (CtFlv('HD,#From,addr,#TXT#',@_) =~ /[,?]/ && CtFlv('HD,#From,addr,##',@_) eq 'SIP:AddrSpec'));}
},

# SYNTAX Rule for RFC3261-21.4-1 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-21.4-1',
    'CA' => 'message',
    'ET' => 'warning',
    'OK' => 'The client SHOULD NOT retry the same request without modification.',
    'NG' => 'The client SHOULD NOT retry the same request without modification.',
    'EX' => sub{
	my($pkt,$last_pkt);
	$pkt = CtFlGet('INET,#SIP,#TXT#',@_);
	$last_pkt = CtFlGet('INET,#SIP,#TXT#',CtRlCxUsr(@_)->{'pre_req'});

	#423
	if ($pkt eq $last_pkt && 
	    CtFlv('SL,code',CtUtLastSndMsg()) eq '423'){
	    return OK;
	}else{
	    return !CtUtEq($pkt,$last_pkt);
	}	
    }
},

# SYNTAX Rule for RFC3261-21.4-3 ()
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-21.4-3',
    'CA' => 'message',
    'ET' => 'error',
    'OK' => 'The request SHOULD NOT be repeated, when the UA received 403 Forbidden response.',
    'NG' => 'The request SHOULD NOT be repeated, when the UA received 403 Forbidden response.',
},

###Inoue added 090403
# SYNTAX Rule for RFC3261-21.4-8 (Y.Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-21.4-8',
    'CA' => 'Header',
    'ET' => 'error',
    'OK' => 'The server MUST return a list of acceptable formats using the Accept, Accept-Encoding, or Accept-Language header field, depending on the specific problem with the content.',
    'NG' => 'The server MUST return a list of acceptable formats using the Accept, Accept-Encoding, or Accept-Language header field, depending on the specific problem with the content.',
    'EX' => sub { 
		if(CtUtIsExistHdr('Accept',@_)){
			return 'OK';
		}

		if(CtUtIsExistHdr('Accept-Encoding',@_)){
			return 'OK';
		}

		if(CtUtIsExistHdr('Accept-Language',@_)){
			return 'OK';
		}

		return '';
	},
},




###Inoue added 090311
# SYNTAX Rule for RFC3261-21.4-9 (Y.Inoue)
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-21.4-9',
    'CA' => 'Unsupported',
    'ET' => 'error',
    'OK' => 'The server MUST include a list of the unsupported extensions in an Unsupported header field in the response.',
    'NG' => 'The server MUST include a list of the unsupported extensions in an Unsupported header field in the response.',
    'EX' =>
	 sub {
		if(CtUtIsExistHdr('Unsupported',@_)){
			if(CtFlv('HD,#Unsupported,option', @_) eq 'foo'){
				return 'OK';
			}
		}
			return '';
	 },

},

# 
#                
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-22.1-11',
    'CA' => 'message',
    'ET' => 'error',
    'OK' => \\'To verify that UAC Must not re-attempt requests(%s) with the credentials(%s) that have just been rejected.',
    'NG' => \\'To verify that UAC Must not re-attempt requests(%s) with the credentials(%s) that have just been rejected.',
    'EX' => sub {
        # 
        my $res1= CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',
                       CtRlPKTGet(CtNDAct(),   # 
                                  '',
                                  'before',   # 
                                  'top',      # 
                                  'in',       # 
                                  ['INET,#SIP,SL,method', "REGISTER"]));
        # 
        my $res2= CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#Dresponse,response',@_);
        return CtUtCp2('!',$res2,$res1,@_);
    },
},

# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-22.4-20',
    'CA' => 'message',
    'ET' => 'error',
    'PR' => \q{CtUtIsExistHdr('Authorization', @_)},
    'OK' => "The 'uri' parameter of the Authorization header field MUST be enclosed in quotation marks.",
    'NG' => "The 'uri' parameter of the Authorization header field MUST be enclosed in quotation marks.",
    'EX' => \q{CtFlv('HD,#Authorization,credentials,credential,digestresp,list,#DigestUri,#TXT#', @_) =~ /uri\s*=\s*".+"/},
},
# 
# 
{
    'TY' => 'SYNTAX',
    'ID' => 'S.RFC3261-22.4-23',
    'CA' => 'message',
    'ET' => 'error',
    'PR' => \q{CtUtIsExistHdr('Authorization', @_)},
    'OK' => 'If a client receives a "qop" parameter in a challenge header field, it  MUST send the "qop" parameter in any resulting authorization header field.',
    'NG' => 'If a client receives a "qop" parameter in a challenge header field, it  MUST send the "qop" parameter in any resulting authorization header field.',
    'EX' => \q{CtUtEq(CtFlv('HD,#Authorization,credentials,credential,digestresp,list,qop', @_),
                      CtFlv('HD,#WWW-Authenticate,challenge,credentials,digestresp,list,qop', CtUtLastSndMsg()),@_)},
},

);

1;

