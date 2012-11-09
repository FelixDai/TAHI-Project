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

# use strict;
use XML::TreePP;

# 
# 09/4/ 3  CtSvRegUpdate 
# 09/3/ 2  CtSvRegUpdate 
# 09/2/ 3  CtSvRegUpdate registration
# 08/10/ 8 GenXMLStruct
#  unknown-param 

###############################################################################
#
# SIP Registration Control
#
###############################################################################

BEGIN {
	# Registration
	my ($regid) = 0;
	my ($conid) = 0;
	sub GenRegID { return "a" . ++$regid; }
	sub GenContactID { return "c" . ++$conid; }
}

#=============================================================================
# 
#=============================================================================

#---------------------------------------------------------------------------------
# 
#   
#     $regname
#     $registra
#     $node
#   
#     
#   
#---------------------------------------------------------------------------------
sub CtSvRegCreate {
	my ($regname, $regstra, $node) = @_;
	my ($registration);
	my ($profile, $uid, $impu);

	# 
	if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
	if (ref($node) ne 'HASH') {
		CtSvError('fatal', "node is not HASH");
		return;
	}

	# 
	$profile =  GetUserProfileHSS($regstra);

	# 
	foreach my $impi (keys(%$profile)) {
	##	print "IMPI: $impi\n";						# DEBUG
		my ($p) = $profile->{$impi};
		$impu = $p->{'PublicUserIdentity'};
		if (!$impu) { next; }
		foreach my $curImpu (@$impu) {
			if (!defined($registration->{$curImpu})) {
				# IMPU
	##			print "IMPU: $curImpu->{'URI'}\n";	# DEBUG
				my ($newReg);
				$newReg->{'RegID'}    = GenRegID();
				$newReg->{'AoR'}      = $curImpu->{'URI'};
				$newReg->{'RegState'} = 'init';
				$newReg->{'Contact'}  = undef;
				$registration->{$curImpu->{'URI'}} = $newReg;
			}
		}
	}
	CtSvRegSet($regname, $registration, $node);
}

#---------------------------------------------------------------------------------
# 
#   
#     $regname
#     $msg
#     $registra
#   
#     
#   
#        (1)REGISTER
#           
#        (2)NOTIFY
#           
#---------------------------------------------------------------------------------
sub CtSvRegUpdate {
	my ($regname, $msg, $registra, $node) = @_;
	my ($reg,$response);
	my ($aor, $uri, $impi, $expires, $cseq, $callid, $displayname, $unknown);
	my ($profile, $impus,$method,$contactCount,$no);
	my ($associated) = [];

	if (!$regname) {
		CtSvError('fatal', "no registration name specified");
		return;
	} else {
		# 
		$reg = CtSvRegGet($regname, $node);
		if ($reg eq '') {
			CtSvError('fatal', "cannot get registration dlgid[%s]",$regname);
			return;
		}
	}

	if ($msg) {
		################################################################
		# $msg
		################################################################

		#-----------------------------------
		# REGISTER
		#-----------------------------------
		$method = CtFlv('SL,method', $msg);
		if ($method ne 'REGISTER') {
			MsgPrint('WAR', "not REGISTER message\n");
			return;
		}

		#--------------------------------
		# 
		#--------------------------------

		# Public User Identity
		$aor = CtFlv('HD,#To,addr,uri,#TXT#', $msg);
		if ($aor eq '') {
			CtSvError('fatal', "cannot get AoR from To header");
			return;
		}

		# 
		#   ContactURI
		unless( $uri = CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg) ){return;} # 
		$uri =[$uri] unless(ref($uri));
		$contactCount = $#$uri;
		foreach $no (0..$contactCount){
		    unless($uri->[$no]){next;}
		    if ($uri->[$no] =~ /\]:\d+$/m){
			$uri->[$no] =~ s/\]:(\d+)$/\]/g;
		    }
		    else { 
			$uri->[$no] =~ s/:(\d+)$//g; 
		    } 
		}

		# Expires
		# Contact
		# 
		$expires = CtFlGet('INET,#SIP,HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires', $msg, 'T');
		$expires = [$expires] unless($expires);
		foreach $no (0..$contactCount){
		    if ($expires->[$no] eq '') {
			$expires->[$no] = CtFlv('HD,#Expires,seconds', $msg);
		    }
		}

		# Contact
		$displayname = CtFlGet('INET,#SIP,HD,#Contact,c-params,addr,display', $msg, 'T');
		$displayname = [$displayname] unless($displayname);

		# Contact
		$unknown = CtFlGet('INET,#SIP,HD,#Contact,c-params,addr,uri,params,#TXT#', $msg, 'T');
		$unknown = [$unknown] unless($unknown);

		# Private User Identity
		$impi = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,username', $msg);
		if ($impi eq '') {
			CtSvError('fatal', "cannot get private user identity");
			return;
		}
		# response
		if( $response = CtFlv('HD,#Authorization,credentials,credential,digestresp,list,response', $msg) ){
		    CtTbSet('UC,DigestAuth,response',$response,$node);
                    # SIPdigest
                    #   (nextnonce
                    if(CtSecurityScheme() eq 'sipdigest'){
                        CtTbSet('UC,DigestAuth,realm',
                                CtFlv('HD,#Authorization,credentials,credential,digestresp,list,realm', $msg));
                        CtTbSet('UC,DigestAuth,uri',
                                CtFlv('HD,#Authorization,credentials,credential,digestresp,list,uri', $msg));
                        CtTbSet('UC,DigestAuth,nc',
                                CtFlv('HD,#Authorization,credentials,credential,digestresp,list,nc', $msg));
                        CtTbSet('UC,DigestAuth,cnonce',
                                CtFlv('HD,#Authorization,credentials,credential,digestresp,list,cnonce', $msg));
                        CtTbSet('UC,DigestAuth,nextnonce',CtFlRandHexStr(32));
                        CtTbSet('UC,DigestAuth,rspauth',
                                CtUtAuthDigestMD5(CtTbl('UC,UserProfile,PrivateUserIdentity',CtTbPrm('CI,target,TARGET')),
                                                  CtTbl('UC,DigestAuth,realm'),
                                                  CtTbl('UC,DigestAuth,password',CtTbPrm('CI,target,TARGET')),
                                                  '', # 
                                                  CtTbl('UC,DigestAuth,uri'),
                                                  CtTbl('UC,DigestAuth,nonce'),
                                                  CtTbl('UC,DigestAuth,nc'),
                                                  CtTbl('UC,DigestAuth,cnonce'),
                                                  CtTbl('UC,DigestAuth,qop')
                                ));
                    }
		}


		# CSeq
		$cseq = CtFlv('HD,#CSeq,#REST#', $msg);

		# CallID
		$callid = CtFlv('HD,#Call-ID,call-id', $msg);

		#--------------------------------------
		# HSS
		#--------------------------------------
		$impus = GetIMPU($registra, $impi, $aor);
		if (!$impus) {
			CtSvError('fatal', "no impu found");
			return undef;
		}

		#-------------------------------------
		# IMPU
		#-------------------------------------
		foreach my $impu (@$impus) {
			my ($associated_uri);
			if ($impu) {
			    foreach $no (0..$contactCount){
				my ($param);

				# 
				if (defined($expires->[$no])) {	# 0
					$param->{'Expires'} = $expires->[$no];
				}
				if ($cseq) {
					$param->{'CSeq'} = $cseq
				}
				if ($callid) {
					$param->{'CallID'} = $callid
				}
				if ($displayname->[$no]) {
					$param->{'DisplayName'} = $displayname->[$no]
				}
				if ($unknown->[$no]) {
					$param->{'UnknownParam'} = $unknown->[$no]
				}

				if ($impu->{'URI'} eq $aor) {
					# To
					ExplicitRegisterContact($reg, $impu->{'URI'}, $uri->[$no], $param);
				} else {
					# 
					ImplicitRegisterContact($reg, $impu->{'URI'}, $uri->[$no], $param);
				}

				if ($expires->[$no] > 0) {	# XXX:de-REGISTER
					# 
					if ($impu->{'DisplayName'}) {
						$associated_uri->{'DisplayName'} = $impu->{'DisplayName'};
					}
					$associated_uri->{'URI'} = $impu->{'URI'};
					if ($impu->{'IsDefault'}) {
						# 
						unshift(@$associated, $associated_uri);
					} else {
						# 
						push(@$associated, $associated_uri);
					}
				}
			    }
			}
		}
	
		if (0)  {	# XXX:
			#--------------------------
			# RegState
			#--------------------------
			# 
			my ($active_reg) = 0;
			foreach $aor (keys(%$reg)) {				# key = AoR (Public User Identity)
				my ($r) = $reg->{$aor};
				my ($contact) = $r->{'Contact'};
				my ($active_contact) = 0;
	
				if ($r->{'RegState'} ne 'active') {
					next;
				}
				if ($contact) {
					foreach $uri (keys(%$contact)) {	# key = Contact URI
						if ($contact->{$uri}->{'ContactState'} eq 'active') {
							$active_contact++;
						}
					}
				}
				if ($active_contact == 0) {
					$r->{'RegState'} = 'terminated';
				} else {
					$active_reg++;
				}
			}
		#	if ($active_reg == 0) {
		#		MsgPrint('WAR', "no active registration left\n");
		#	}
		}

		#-----------------------------
		# 
		#-----------------------------
		if ( grep{$_>0}(@$expires) ) {	# XXX:de-REGISTER
		    # 
		    CtTbSet("UC,AssociatedURI", $associated, $registra);
		    # 
		    CtTbSet("UC,AssertedIdentity", $associated->[0], $node);
		}

	} else {
		######################################################
		# $msg
		######################################################
		# (1) ContactState
		# (2) RegState
		my ($active_reg) = 0;
		foreach $aor (keys(%$reg)) {				# key = AoR (Public User Identity)
			my ($r) = $reg->{$aor};
			my ($contact) = $r->{'Contact'};

			if ($r->{'RegState'} eq 'init') { next; }
			if ($contact) {
				# (1) ContactState
				foreach $uri (keys(%$contact)) {	# key = Contact URI
					if ($contact->{$uri}->{'ContactState'} eq 'terminated') {
						delete($contact->{$uri});
					}
				}
			}
			if ($r->{'RegState'} eq 'terminated') {
				# (2) RegState
			#	$r->{'RegID'}    = GenRegID();
				$r->{'RegState'} = 'init';
				$r->{'Contact'}  = undef;
			} else {
				$active_reg++;
			}
		}
	#	if ($active_reg == 0) {
	#		MsgPrint('WAR', "no active registration left\n");
	#	}
	}
}

#---------------------------------------------------------------------------------
# RegInfo XML
#   
#     $dlgName
#     $node
#   
#     
#   
#---------------------------------------------------------------------------------
sub CtSvRegGenRegInfoXML {
	my ($dlgName, $node, $noUpdate) = @_;
	my ($ri, $reg);
	my ($riX, $regX,$dlg);

	$dlg = CtSvDlgGet($dlgName, $node);
	if (!$dlg) {
		CtSvError('fatal', "cannot get dialog($dlgName)");
		return;
	}

	$ri = $dlg->{'RegInfo'};
	$reg = $dlg->{'RegInfo'}->{'registration'};

	#-----------------------------------------
	# Contact
	#----------------------------------------
	# XXX: 
	#----------------------------------------
	unless($noUpdate){
		my ($active_reg) = 0;

		# 
		# 
		foreach my $aor (keys(%$reg)) {	# key = AoR (Public User Identity)
			my ($r) = $reg->{$aor};
			my ($contact) = $r->{'Contact'};
			my ($active_contact) = 0;

			if ($r->{'RegState'} ne 'active') {
				next;
			}
			if ($contact) {
				foreach my $uri (keys(%$contact)) {	# key = ContactURI
					# Contact
					UpdateContact($contact->{$uri});
					if ($contact->{$uri}->{'ContactState'} eq 'active') {
						$active_contact++;
					}
				}
			}
			if ($active_contact == 0) {
				$r->{'RegState'} = 'terminated';
			} else {
				$active_reg++;
			}
		}
		if ($active_reg == 0) {
			MsgPrint('War', "no active registration\n");
		}
	}

	#-----------------------------------------
	# RegInfo XML
	#----------------------------------------

	# 
	$regX = GenXMLStruct($reg);

	# RegInfo
	$riX = {
		'reginfo' => {
			'_xmlns'       => 'urn:ietf:params:xml:ns:reginfo',
			'_version'     => $ri->{'_version'},
			'_state'       => $ri->{'_state'},	# full|partial
			'registration' => $regX,
		},
	};

	# version
	$ri->{'_version'} += 1;

	# XML
	{
		my $tpp = XML::TreePP->new(indent => 4, attr_prefix => '_');
		# $tpp->set(xml_decl=>''); # encoding="utf-8"
		my $msg=$tpp->write($riX);
		$msg =~ s/\x0A/\x0D\x0A/g;

		return $msg;
	}
}


#=============================================================================
# Registration
#=============================================================================

#-----------------------------------------------------------------------------
# Registration
#   
#     $regname
#     $node
#     $opt
#   
#     Registration
#   
#     
#-----------------------------------------------------------------------------
sub CtSvRegGet {
	my ($regname, $node, $opt) = @_;
	my($val,@val);
	if ($regname eq '') {
		CtSvError('fatal', "regname nothing");
		return;
	}

	# 
	if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
	if (ref($node) ne 'HASH') {
		CtSvError('fatal', "node is not HASH");
		return;
	}
	$val = CtTbl("REG,$regname", $node);
	if($opt){
	    if(ref($val) eq 'HASH'){
		if($opt eq 'keys'){
		    @val = keys(%$val);
		    return \@val;
		}
		if($opt eq 'vals'){
		    @val = vals(%$val);
		    return \@val;
		}
		MsgPrint('WAR',"Unknown option [%s]\n",$opt);
	    }
	    return !ref($val) ? [$val] : $val;
	}
	return $val;
}

#-----------------------------------------------------------------------------
# Registration
#   
#     $regname
#     $node
#   
#     
#   
#     Registration
#-----------------------------------------------------------------------------
sub CtSvRegSet {
	my ($regname, $registration, $node) = @_;
	my ($oldReg);

	if ($regname eq '') {
		CtSvError('fatal', "regname nothing");
		return;
	}

	# 
	if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
	if (ref($node) ne 'HASH') {
		CtSvError('fatal', "node is not HASH");
		return;
	}

#	$oldReg = CtSvRegGet($regname, $node);
#	if (!$oldReg) {
#		CtLgPrint('WAR', "Overwrite registration info: registration name [%s]\n", $regname);
#	}

	CtTbSet("REG,$regname", $registration, $node);
}

#-----------------------------------------------------------------------------
# Registration
#   
#     $regname
#     $impu
#     $contact
#               
#     $field
#               
#               
#     $node
#               
#   
#     
#   
#     Registration
#     Registration
#		'REG' => {									# 
#			'RegName' => {							# hashkey:Registration
#				'IMPU' => {							# hashkey:PublicUserIdentity(AoR)
#					'RegID'    => '',				# XXX: $contact
#					'RegState' => '',
#					'AoR'      => '',				# =hashkey
#					'Contact' => {
#						'CONTACTURI' => {			# hashkey:ContactURI
#							'ContactID'    => '',	# XXX: $contact
#							'ContactState' => '',
#							'Event'        => '',
#							'ExpireTime'   => '',
#							'RetryAfter'   => '',
#							'RegistTime'   => '',
#							'Q'            => '',
#							'CallID'       => '',
#							'CSeq'         => '',
#							'ContactURI'   => '',	# =hashkey
#							'DisplayName'  => '',
#							'UnknownParam' => '',
#						},
#					},
#				},
#			},
#  
#    Event
#    RegState
#-----------------------------------------------------------------------------
sub CtSvReg {
	my ($regname, $impu, $contact, $field, $node, $opt) = @_;
	my ($reg, $ret);

	if (!$impu) {
		# impu
		CtSvError('fatal', "impu is not specified");
	}
	$reg = CtSvRegGet($regname, $node);
	if ($reg) {
		if ($contact) {
			# impu
			#   CONTACTURI
			if ($field) {
				$ret = $reg->{$impu}->{'Contact'}->{$contact}->{$field};
			} else {
				# field
				$ret = $reg->{$impu}->{'Contact'}->{$contact};
			}
		} else {
			# impu
			#   IMPU
			if ($field) {
				$ret = $reg->{$impu}->{$field};
			} else {
				# field
				$ret = $reg->{$impu};
			}
		}
		# 
		if($opt){
		    if(ref($ret) eq 'HASH'){
			my @val;
			if($opt eq 'keys'){
			    @val = keys(%$ret);
			    return \@val;
			}
			if($opt eq 'keys'){
			    @val = keys(%$ret);
			    return \@val;
			}
			MsgPrint('WAR',"Unknown option [%s]\n",$opt);
		    }
		    return !ref($ret) ? [$ret] : $ret;
		}
		return $ret;
	} else {
		CtSvError('fatal', "cannot get registration($regname)");
		return '';
	}
}



#=============================================================================
# 
#=============================================================================
# 
#
#     Function					ContactState			Event
# (1) CtSvRegRegisterContact	(Init) -> Active		registered
# (2) CtSvRegCreateContact		(Init) -> Active		created
# (3) CtSvRegRefreshContact		Active -> Active		refreshed
# (4) CtSvRegShortenContact		Active -> Active		shortened
# (5) CtSvRegExpireContact		Active -> Terminated	expired
# (6) CtSvRegDeactivateContact	Active -> Terminated	deactivated
# (7) CtSvRegRejectContact		Active -> Terminated	rejected
# (8) CtSvRegProbateContact		Active -> Terminated	probation
# (9) CtSvRegUnregisterContact	Active -> Terminated	unregistered
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# 
#-----------------------------------------------------------------------------
#   
#     $regname
#     $aor
#     $contact
#     $expires
#     $node
#   
#     
#   
#     
#     
#     
#-----------------------------------------------------------------------------
sub CtSvRegRegisterContact {
	my ($regname, $aor, $contact, $expires, $node) = @_;
	my ($reg, $param);

	# 
	if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
	if (ref($node) ne 'HASH') {
		CtSvError('fatal', "node is not HASH");
		return;
	}

	# 
	if (!$regname) {
		CtSvError('fatal', "regname is not specified");
		return;
	} else {
		$reg = CtSvRegGet($regname, $node);
		if (!$reg) {
			CtSvError('fatal', "cannot get registration");
			return;
		}
	}

	# expires
	if (!defined($expires)) {
		CtSvError('fatal', "expires is not specified");
		return;
	} else {
		$param->{'Expires'} = $expires;
	}
	ExplicitRegisterContact($reg, $aor, $contact, $param);
}

#-----------------------------------------------------------------------------
# 
#-----------------------------------------------------------------------------
#   
#     $regname
#     $aor
#     $contact
#     $expires
#     $node
#   
#     
#   
#     
#     
#     
#-----------------------------------------------------------------------------
sub CtSvRegCreateContact {
	my ($regname, $aor, $contact, $expires, $node) = @_;
	my ($reg, $param);
	my ($default_expires) = 60000;

	# 
	if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
	if (ref($node) ne 'HASH') {
		CtSvError('fatal', "node is not HASH");
		return;
	}

	# 
	if (!$regname) {
		CtSvError('fatal', "regname is not specified");
		return;
	} else {
		$reg = CtSvRegGet($regname, $node);
		if (!$reg) {
			CtSvError('fatal', "cannot get registration");
			return;
		}
	}

	# expires
	if (!defined($expires)) {
		CtSvError('fatal', "expires is not specified");
		return;
	} else {
		$param->{'Expires'} = $default_expires;
	}
	ImplicitRegisterContact($reg, $aor, $contact, $param);
}

#-----------------------------------------------------------------------------
# 
#-----------------------------------------------------------------------------
#   
#     $regname
#     $aor
#     $contact
#     $expires
#     $node
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtSvRegRefreshContact {
	my ($regname, $aor, $contact, $expires, $node) = @_;
	my ($param);
	$param->{'Expires'} = $expires;
	ManipurateContact($regname, $aor, $contact, $param, 'refresh', $node);
}
sub CtSvRegShortenContact {
	my ($regname, $aor, $contact, $expires, $node) = @_;
	my ($param);
	$param->{'Expires'} = $expires;
	ManipurateContact($regname, $aor, $contact, $param, 'shorten', $node);
}
sub CtSvRegUnregisterContact {
	my ($regname, $aor, $contact, $node) = @_;
	ManipurateContact($regname, $aor, $contact, '', 'unregister', $node);
}
sub CtSvRegExpireContact {
	my ($regname, $aor, $contact, $node) = @_;
	ManipurateContact($regname, $aor, $contact, '', 'expire', $node);
}
sub CtSvRegDeactivateContact {
	my ($regname, $aor, $contact, $node) = @_;
	ManipurateContact($regname, $aor, $contact, '', 'deactivate', $node);
}
sub CtSvRegRejectContact {
	my ($regname, $aor, $contact, $node) = @_;
	ManipurateContact($regname, $aor, $contact, '', 'reject', $node);
}
sub CtSvRegProbateContact {
	my ($regname, $aor, $contact, $retry_after, $node) = @_;
	my ($param);
	$param->{'RetryAfter'} = $retry_after;
	ManipurateContact($regname, $aor, $contact, $param, 'probate', $node);
}




###################################################################################
# 
###################################################################################

#-------------------------------------------------------------
# IMPU
#
# 
#-------------------------------------------------------------
sub GetIMPU {
	my ($registra, $private, $public) = @_;
	my ($profile); 

	if (!$registra) {
		CtSvError('fatal', "no registra node specified");
		return undef;
	}
	if (!$private) {
		CtSvError('fatal', "no private user id specified");
		return undef;
	}
	if (!$public) {
		CtSvError('fatal', "no public user id specified");
		return undef;
	}
	$profile = GetUserProfileHSS($registra, $private, $public);
	if (!$profile) {
		CtSvError('fatal', "no profile found");
		return undef;
	}
	return $profile->{'PublicUserIdentity'};
}

#-------------------------------------------------------------
# 
#-------------------------------------------------------------
# ExplicitRegisterContact($reg, $aor, $uri,{ Expires => 4000 });}
#
sub ExplicitRegisterContact {
	my ($reg, $aor, $uri, $param) = @_;
	my ($default_expires) = 60000;

	if ($uri eq '*') {
		# ContactURI
		if ($param->{'Expires'} == 0) {
			if ($reg->{$aor}) { # hashkey:PublicUserID(AoR)
				my ($r) = $reg->{$aor};
				my ($contact) = $r->{'Contact'};
				if  ($contact) {
					foreach my $c (keys(%$contact)) {   # key = ContactURI
						UpdateContact($contact->{$c}, $param);
					}
				}
			}
		} else {
			# Waringi?
		#	print "invalid expires for '*' deregistration";
		}
	} else {
		if (!exists($param->{'Expires'})) {					# 0
			$param->{'Expires'} = $default_expires;
		}
		if ($reg->{$aor}) {									# hashkey:PublicUserID(AoR)
			my ($r) = $reg->{$aor};
			if ($r->{'Contact'} && $r->{'Contact'}->{$uri}) {
				# 
				my ($c) = $r->{'Contact'}->{$uri};
				UpdateContact($c, $param);
			} elsif ($param->{'Expires'} != 0) {
				# Contact
		#		print "register new contact $uri\n";				# XXX:DEBUG
				$param->{'Event'} = 'registered';
				$r->{'Contact'}->{$uri} = NewContact($uri, $param);
				$r->{'RegState'} = 'active';
			}
		} else {
			# Warning?
		#	print "no registration exists for $aor\n";
		}
	}
}

#-------------------------------------------------------------
# 
#-------------------------------------------------------------
# ImplicitRegisterContact($reg, $aor, $uri, { Expires => 4000 });
#
sub ImplicitRegisterContact {
	my ($reg, $aor, $uri, $param) = @_;
	my ($default_expires) = 60000;

	if ($uri eq '*') {
		# ContactURI
		if ($param->{'Expires'} == 0) {
			if ($reg->{$aor}) { # hashkey:PublicUserID(AoR)
				my ($r) = $reg->{$aor};
				my ($contact) = $r->{'Contact'};
				if  ($contact) {
					foreach my $c (keys(%$contact)) {   # key = ContactURI
						UpdateContact($contact->{$c}, $param);
					}
				}
			}
		} else {
			# Warning?
		#	print "invalid expires for '*' deregistration";
		}
	} else {
		if (!exists($param->{'Expires'})) {					# 0
			$param->{'Expires'} = $default_expires;
		}
		if ($reg->{$aor}) {	# hashkey:PublicUserID(AoR)
			my ($r) = $reg->{$aor};
			if ($r->{'Contact'} && $r->{'Contact'}->{$uri}) {
				# 
				my ($c) = $r->{'Contact'}->{$uri};
				UpdateContact($c, $param);
			} elsif ($param->{'Expires'} != 0) {
				# Contact
		#		print "create new contact $uri\n";				# XXX:DEBUG
				$param->{'Event'} = 'created';
				$r->{'Contact'}->{$uri} = NewContact($uri, $param);
				$r->{'RegState'} = 'active';
			}
		} else {
			# Warning?
		#	print "no registration exists for $aor\n";
		}
	}
}

#-------------------------------------------------------------
# 
#-------------------------------------------------------------
sub ManipurateContact {
	my ($regname, $aor, $contact_uri, $param, $action, $node) = @_;
	my ($reg);
	my ($expires);

	# contact-uri
	if ($contact_uri =~ /\]:\d+$/m){
	    $contact_uri =~ s/\]:(\d+)$/\]/g;
	}
	else { 
	    $contact_uri =~ s/:(\d+)$//g; 
	} 

	# 
	if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
	if (ref($node) ne 'HASH') {
		CtSvError('fatal', "node is not HASH");
		return;
	}

	#-------------------------------------------------
	# 
	#-------------------------------------------------
	if (!$regname) {
		CtSvError('fatal', "no regname specified");
		return;
	} else {
		$reg = CtSvRegGet($regname, $node);
		if (!$reg) {
			CtSvError('fatal', "cannot get registration");
			return;
		}
	}
	if (!$aor) {		# Public User Identity
		CtSvError('fatal', "no aor specified");
		return;
	}
	if (!$contact_uri) {
		CtSvError('fatal', "no contact uri specified");
		return;
	}
	if ($param) {
		if (!$param->{'Expires'}) {
			$expires = $param->{'Expires'};	# XXX
		}
	}
	if (!$action) {
		CtSvError('fatal', "no action specified");
		return;
	}

	#-------------------------------------------------
	# Contact
	#-------------------------------------------------
	# action
	# UpdateContact()
	#-------------------------------------------------
	if ($reg->{$aor}) {
		my ($r) = $reg->{$aor};
		if ($r->{'Contact'} && $r->{'Contact'}->{$contact_uri}) { # if Contact URI exists
			my ($c) = $r->{'Contact'}->{$contact_uri};
			my ($p);
			if ($action eq 'expire') {
				$p = { 'Event' => 'expired' };
			} elsif ($action eq 'refresh') {
				if ($param->{'Expires'}) {
					$p = { 'Event' => 'refreshed', 'Expires' => $param->{'Expires'} };
				} else {
					CtSvError('fatal', "no expire specified");
					return;
				}
			} elsif ($action eq 'shorten') {
				if ($param->{'Expires'}) {
					$p = { 'Event' => 'shortened', 'Expires' => $param->{'Expires'} };
				} else {
					# shorten
					CtSvError('fatal', "no expire specified");
					return;
				}
			} elsif ($action eq 'deactivate') {
				$p = { 'Event' => 'deactivated' };
			} elsif ($action eq 'reject') {
				$p = { 'Event' => 'rejected' };
			} elsif ($action eq 'probate') {
				if ($param->{'RetryAfter'}) {
					$p = { 'Event' => 'probation', 'RetryAfter' => $param->{'RetryAfter'} };
				} else {
					# probate
					CtSvError('fatal', "no retry after specified");
					return;
				}
			} elsif ($action eq 'unregister') {
				$p = { 'Event' => 'unregistered' };
			} else {
				CtSvError('fatal', "unknown action specified($action)");
				return;
			}
			# print "call UpdateContact with Event=$p->{'Event'}\n";
			UpdateContact($c, $p);
		} else {
			CtSvError('fatal', "no contact exists");
		}
	} else {
		CtSvError('fatal', "no aor exists");
	}

	#-------------------------------------------------
	# RegState
	#-------------------------------------------------
	# 
	# 
	#-------------------------------------------------
	foreach $aor (keys(%$reg)) {	# key = AoR (Public User Identity)
		my ($r) = $reg->{$aor};
		my ($contact) = $r->{'Contact'};
		my ($active_contact) = 0;

		if ($r->{'RegState'} ne 'active') { next; }
		if ($contact) {
			foreach my $uri (keys(%$contact)) {	# key = Contact URI
				if ($contact->{$uri}->{'ContactState'} eq 'active') {
					$active_contact++;
				}
			}
		}
		if ($active_contact == 0) {
			$r->{'RegState'} = 'terminated';
		}
	}
}

#---------------------------------------------------------
# 
#---------------------------------------------------------
# Ex1: Minimum Usage
#   NewContact($contact_uri)
# Ex2: New Registration
#   NewContact($contact_uri, { EVENT => 'registered', Expires => 6000 })
#   NewContact($contact_uri, { EVENT => 'created', Expires => 6000 })
#
sub NewContact {
	my ($contact_uri, $p) = @_;
	my ($default_expires) = 60000;
	my ($newC);
	if ($contact_uri) {										# ContactURI
		# ContactURI
		$newC->{'ContactURI'} = $contact_uri;
	} else {
		# ContactURI
		CtSvError('fatal', "no contact uri specified");
		return undef;
	}

	# ContactID
	$newC->{'ContactID'} = GenContactID();					# ContactID

	if ($p->{'RegistTime'}) {								# RegistTime
		# RegistTime
		$newC->{'RegistTime'} = $p->{'RegistTime'};
	} else {
		# 
		$newC->{'RegistTime'} = time();
	}

	if ($p->{'ContactState'}) {								# ContactState
		# ContactState
		$newC->{'ContactState'} = $p->{'ContactState'};
	} else {
		# 
		$newC->{'ContactState'} = 'active'
	}

	if ($p->{'Event'}) {									# Event
		# Event
		$newC->{'Event'} = $p->{'Event'};
	} else {
		# 
		$newC->{'Event'} = 'created';
	}

	if ($p->{'Expires'}) {									# ExpireTime
		# Expires
		$newC->{'ExpireTime'} = time() + $p->{'Expires'};
	} elsif ($p->{'ExpireTime'}) {
		# ExpireTime
		$newC->{'ExpireTime'} = $p->{'ExpireTime'};
	} else {
		# 
		$newC->{'ExpireTime'} = time() + $default_expires;
	}

	#--------------------------------------------------------
	# 
	#--------------------------------------------------------
	if ($p->{'RetryAfter'}) {								# RetryAfter
		$newC->{'RetryAfter'} = $p->{'RetryAfter'};
	}
	if ($p->{'Q'}) {										# Q
		$newC->{'Q'} = $p->{'Q'};
	}
	if ($p->{'CallID'}) {									# CallID
		$newC->{'CallID'} = $p->{'CallID'};
	}
	if ($p->{'CSeq'}) {										# CSeq
		$newC->{'CSeq'} = $p->{'CSeq'};
	}
	if ($p->{'DisplayName'}) {								# DisplayName
		$newC->{'DisplayName'} = $p->{'DisplayName'};
	}
	if ($p->{'UnknownParam'}) {								# UnknownParam
		$newC->{'UnknownParam'} = $p->{'UnknownParam'};
	}

	return $newC;
}

#---------------------------------------------------------
# 
#---------------------------------------------------------
#
#                                +------+
#                                |      | refreshed
#                                |      | shortened
#                                V      |
#   +------------+            +------------+            +------------+
#   |            |            |            |            |            |
#   |   (Init)   |----------->|   Active   |----------->| Terminated |
#   |            |            |            |            |            |
#   +------------+ registered +------------+ expired    +------------+
#                  created                   deactivated
#                                            probation
#                                            unregistered
#                                            rejected
#
#                     Figure 2: Contact State Machine
#
# Ex1:	Just Check Expire Time
#	UpdateContact($contact);
# Ex2:  Refresh (re-REGISTER)
#	UpdateContact($contact, { Expires => 60000 });
# Ex4:	Shorten
#	UpdateContact($contact, { Event => 'shortend', Expires => 30 });
# Ex4:	Expire
#	UpdateContact($contact, { Event => 'expired' });
# Ex5:	Deactivate
#	UpdateContact($contact, { Event => 'deactivated' });
# Ex6:	Reject
#	UpdateContact($contact, { Event => 'rejected' });
# Ex7:	Probate
#	UpdateContact($contact, { Event => 'probation', RetryAfter => 600 });
# Ex8: 	Deregister
#	UpdateContact($contact, { Event => 'unregistered' });
#	UpdateContact($contact, { Expires => 0 });
#
sub UpdateContact {
	my ($contact, $p) = @_;
	my ($default_expires) = 60000;
	my ($event, $state) = ('','');

	if (!$contact) {
		CtSvError('fatal', "no contact specified");
		return undef;
	}

	if (!$p) {		# 
		if ($contact->{'ExpireTime'} <= time()) {
			if ($contact->{'ContactState'} eq 'active') {
				$contact->{'Event'} = 'expired';
				$contact->{'ContactState'} = 'terminated';
			}
		}
		return $contact;
	}

	if (exists($p->{'Expires'})) {
		# Expires
		my ($new_expiretime) = time() + $p->{'Expires'};	# 
		if ($p->{'Expires'} == 0) {
			# Expires
			$event = 'unregistered';
			$state = 'terminated';
		} elsif ($new_expiretime >= $contact->{'ExpireTime'}) {
			# ExpireTime
			$event = 'refreshed';
			$state = 'active';
		} elsif ($new_expiretime < $contact->{'ExpireTime'}) {
			# ExpireTime
		#	if ($p->{'Event'} && ($p->{'Event'} eq 'shortened')) {
				$event = 'shortened';
				$state = 'active';
		#	}
		}
		$contact->{'ExpireTime'} = $new_expiretime;
	} else {
		# Expires
		if ($p->{'Event'} && ( ($p->{'Event'} eq 'expired') or
							   ($p->{'Event'} eq 'deactivated') or
							   ($p->{'Event'} eq 'rejected') or
							   ($p->{'Event'} eq 'probation') or
							   ($p->{'Event'} eq 'unregistered') )) {
				# terminated
				# 
		} else {
			my ($new_expiretime) = time() + $default_expires;
			if ($new_expiretime > $contact->{'ExpireTime'}) {
				$contact->{'ExpireTime'} = time() + $p->{'Expires'};	# Expiration Time
				$event = 'refreshed';
				$state = 'active';
			} elsif ($new_expiretime < $contact->{'ExpireTime'}) {
				#  shorten expires only when explicitly specfied 'shortened' event
				if ($p->{'Event'} && ($p->{'Event'} eq 'shortened')) {
					$event = 'shortened';
					$state = 'active';
				}
			} else {
				$event = '';
				$state = '';
			}
		}
	}

	if ($p->{'Event'}) {
		# 
		if ($p->{'Event'} eq 'expired') {
			$event = 'expired';
			$state = 'terminated';
		} elsif ($p->{'Event'} eq 'deactivated') {
			$event = 'deactivated';
			$state = 'terminated';
		} elsif ($p->{'Event'} eq 'rejected') {
			$event = 'rejected';
			$state = 'terminated';
		} elsif ($p->{'Event'} eq 'probation') {
			$event = 'probation';
			$state = 'terminated';
		} elsif ($p->{'Event'} eq 'unregistered') {
			$event = 'unregistered';
			$state = 'terminated';
		}
	}

	if ($event) {
		if ($p->{'Event'}) {
			if ($event ne $p->{'Event'}) {
				# param
			}
		}
		$contact->{'Event'} = $event;
	}
	if ($state) {
		if ($p->{'ContactState'}) {
			if ($state ne $p->{'ContactState'}) {
				# param
			}
		}
		if ($contact->{'ContactState'} eq 'active') {
			if ($state eq 'terminated') {
				# active
				$contact->{'ContactState'} = 'terminated';
			}
		} elsif ($contact->{'ContactState'} eq 'terminated') {
			if ($state eq 'active') {
				# XXX:terminated
			}
		} else {
			# ContactState
			CtSvError('fatal', "unknown ContactState($contact->{'ContactState'})");
			return undef;
		}
	}

	if ($event eq 'probation') {
		if ($p->{'RetryAfter'}) {
			$contact->{'RetryAfter'} = $p->{'RetryAfter'};	# Retry After
		} else {
			CtSvError('fatal', "RetryAfter is not specified");
			return undef;
		}
	}

	# RegistTime
	if ($p->{'RegistTime'}) {
		$contact->{'RegistTime'} = $p->{'RegistTime'};
	} elsif ($p->{'DirationRegistered'}) {
		$contact->{'RegistTime'} = time() - $p->{'DurationRegistered'};	
	} else {
		# XXX:
		$contact->{'RegistTime'} = time();
	}

	# 
	if ($p->{'Q'}) {
		$contact->{'Q'} = $p->{'Q'};						# Q
	}
	if ($p->{'CallID'}) {
		$contact->{'CallID'} = $p->{'CallID'};				# CallID
	}
	if ($p->{'CSeq'}) {
		$contact->{'CSeq'} = $p->{'CSeq'};					# CSeq
	}
	if ($p->{'DisplayName'}) {
		$contact->{'DisplayName'} = $p->{'DisplayName'};	# DisplayName
	}
	if ($p->{'UnknownParam'}) {
		$contact->{'UnknownParam'} = $p->{'UnknownParam'};	# UnknownParam
	}
	return $contact;
}

#---------------------------------------------------------------------------
# XML
#---------------------------------------------------------------------------
# 
#---------------------------------------------------------------------------
# 
#
# 
# 
#
# reginfo
#   _version                    0
#   _state                      full|partial
#   registration[]
#     _aor                      URI(
#      _id                      
#      _state                   init|active|terminated
#      contact[]
#        _id                    
#        _state                 active|terminated
#        _event                 registered|created|refreshed|shortened|expired|deactivated|probation|unregistered|rejected
#        _expires               shortened
#        _retry-after           probation
#        _duration-registered   register
#        _q                     register
#        _callid                
#        _cseq                  
#        uri                    REGISTER
#        display-name           REGISTER
#        unknown-param          REGISTER
#---------------------------------------------------------------------------
sub GenXMLStruct {
	my ($reg, $opt) = @_;
	my ($addExpires, $addDuration, $addCallID, $addCSeq) = (0,0,0,0);	# XXX:
	my (@regX) = ();

	foreach my $aor (keys(%$reg)) {					# key = AoR (Public User Identity)
		my ($xR);
		my ($r) = $reg->{$aor};
		my ($contact) = $r->{'Contact'};
		if ($r->{'RegState'} eq 'init') {
			next;
		}
		$xR->{'_id'}    = $r->{'RegID'};			# id
		$xR->{'_aor'}   = $r->{'AoR'};				# aor (Public User Identity)
		$xR->{'_state'} = $r->{'RegState'};			# state (init|active|terminated)

		if ($contact) {
			my ($i) = 0;
			foreach my $uri (keys(%$contact)) {	# key = Contact URI
				my ($c, $xC);
				$c = $contact->{$uri};

				$xC->{'_id'}    = $c->{'ContactID'};					# id
				$xC->{'_state'} = $c->{'ContactState'};					# state (active|terminated)
				$xC->{'_event'} = $c->{'Event'};						# event
				if (($c->{'Event'} eq 'shortened') or $addExpires) {	# expires
					$xC->{'_expires'} = $c->{'ExpireTime'} - time();
					# if ($xC->{'_expires'} < 0) {
					# 	$xC->{'_expires'} = 0;
					# }
				}
				if ($c->{'Event'} eq 'probation') {						# retry-after
					$xC->{'_retry-after'} = $c->{'RetryAfter'};
				}
				if ($addDuration) {										# duration-registered
					$xC->{'_duration-registered'} = time() - $c->{'RegistTime'};
				}
				if ($c->{'_q'}) {										# q
					$xC->{'_q'} = $c->{'Q'};
				}
				if ($addCallID and $c->{'CallID'}) {					# callid
					$xC->{'_callid'} = $c->{'CallID'};
				}
				if ($addCSeq and $c->{'CSeq'}) {						# cseq
					$xC->{'_cseq'} = $c->{'CSeq'};
				}
				# $xC->{'uri'}    = $uri;									# uri
				$xC->{'uri'}    = $c->{'ContactURI'};
				if ($c->{'DisplayName'}) {								# display-name
					$xC->{'display-name'} = $c->{'DisplayName'};
				}
#				if ($c->{'UnknownParam'}) {								# unknown-param
#					$xC->{'unknown-param'} = $c->{'UnknownParam'};
#				}

			#	push($xR->{'contact'}), $xC);
				$xR->{'contact'}->[$i] = $xC;
				$i++;
			}
		}
		push(@regX, $xR);
	}
	return  \@regX;
}

#---------------------------------------------------------
# 
#---------------------------------------------------------
#
#	'UserProfileHSS' => {
#		'user1_private@home1.net' => {  # hashkey:PrivateUserIdentity
#			'PrivateUserIdentity' => 'user1_private@home1.net',
#			'PublicUserIdentity' => [	# SIP URI | tel URI
#				{
#					'URI' => 'sip:user1_public1@home1.net',
#					'DisplayName' => 'John Doe',
#					'IsDefault'   => 1,
#				},
#				{
#					'URI' => 'sip:user1_public2@home1.net',
#					'DisplayName' => '',
#					'IsDefault'   => 0,
#				},
#			],
#			'Ki' => 'XXXXXX',   		# Shared Key
#		},
#	}
#
sub GetUserProfileHSS {
	my ($registra, $private, $public) = @_;
	my ($profile);

	$profile = CtTbl('UC,UserProfileHSS', $registra);	# XXX
	if (!$profile) {
		CtSvError('fatal', "can not get profile from $registra");
		return undef;
	}

	if ($private) {
		# $private
		if ($public) {
			# $public
			my ($impus) = $profile->{$private}->{'PublicUserIdentity'};
			my ($found) = 0;
			foreach my $impu (@$impus) {
				if ($impu->{'URI'} eq $public) {
					$found = 1;
				}
			}
			if (!$found) {
				CtSvError('fatal', "public usesr idenity($public) does not exist in profile");
				return undef;
			}
		}
		return $profile->{$private};
	} else {
		# $private
		return $profile;
	}
}

1;
