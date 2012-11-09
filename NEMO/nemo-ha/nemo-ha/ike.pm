#!/usr/bin/perl -w
#
# Copyright (C) IPv6 Promotion Council,
# NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT),
# Yokogwa Electoric Corporation, YASKAWA INFORMATION SYSTEMS Corporation
# and NTT Advanced Technology Corporation(NTT-AT) All rights reserved.
# 
# Technology Corporation.
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
#
########################################################################

package ike;

use V6evalTool;
use config;

use IKEapi;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	initIKE
	runIKE
	finalizeIKE
	getSA
	IKEvRecv
	VCppApply
	VCppRegistMIP
	VCppRegistIPsec
	);

BEGIN {
	use constant TRUE                   => 1;
	use constant FALSE                  => 0;
	use constant SA_PERL_FILE           => './ipsec_sa.pl';
	use constant SA_ID_PH1              => 'phase1';
	use constant SA_ID_PH2_MH_TRANS     => 'phase2_mh_trans';
	use constant SA_ID_PH2_ICMP_TRANS   => 'phase2_icmp_trans';
	use constant SA_ID_PH2_MH_TUNNEL    => 'phase2_mh_tunnel';
	use constant SA_ID_PH2_ICMP_TUNNEL  => 'phase2_icmp_tunnel';
}

END {}

local (*OUTPUT);

# Callback mipv6 sub-routine map for
%mipv6CBMap = ();

# IKE Phase-1 ID_TYPE map
%idType = (
	'1' => 'TI_ID_FQDN',
	'2' => 'TI_ID_USER_FQDN',
	);

# Diffie-Hellman Group map
%DHGroup = (
	'1' => 'TI_ATTR_GRP_DESC_MODP768',
	'2' => 'TI_ATTR_GRP_DESC_MODP1024',
	);

%sa1 = ();
%sa2 = ();
%sa3 = ();
%sa4 = ();
%sa5 = ();
%sa6 = ();
%sa7 = ();
%sa8 = ();
%sa_handler = ();

#------------------------------#
# initIKE
#------------------------------#
sub initIKE($$$$$$$$) {
	my ($home_agent, $mobile_node, $mobile_node_ether, $mobile_node_coa, $nd_mcast, $nd_ucast, $nd_mcast_hoa, $ref_exit) = @_;

	$mipv6CBMap{'exitFatal'} = $ref_exit;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>IKE INITIALIZATION'.
			 '</B></U></FONT><BR>');

	my $rx_ether = ($HAVE_HOME_LINK) ? "00:00:00:00:a0:a0" : "00:00:00:00:a1:a1";

	my @SaProf=(
		{ # for phase-1
			'ID'=>&SA_ID_PH1,'PHASE'=>1,

			#'TN_IP_ADDR'=> "$mobile_node",
			'TN_IP_ADDR'=> "$mobile_node_coa",

			#'TN_ETHER_ADDR'=> "$mobile_node_ether",
			'TN_ETHER_ADDR'=> "$rx_ether",

			'NUT_IP_ADDR'=> "$home_agent",
			#'TN_ID_TYPE'=>'TI_ID_USER_FQDN',
			'TN_ID_TYPE'=>$idType{$ISAKMP_ID_TYPE_MN},
			'TN_ID'=>$ISAKMP_ID_MN,
			#'NUT_ID_TYPE'=>'TI_ID_USER_FQDN',
			'NUT_ID_TYPE'=>$idType{$ISAKMP_ID_TYPE_HA},
			'NUT_ID'=>$ISAKMP_ID_HA,
			'ATTR_ENC_ALG'=> selectISAKMPEncryptionAlgorithm($USE_ISAKMP_DES),
			'ATTR_HASH_ALG'=> selectISAKMPHashAlgorithm($USE_ISAKMP_MD5),
			'ATTR_PH1_GRP_DESC'=>$DHGroup{$DH_GROUP},
			'PSK'=>"$IPSEC_PSK"
		},
		{ # for SA1 and SA2
			'ID'=>&SA_ID_PH2_MH_TRANS,'PHASE'=>2,
			'ISAKMP_SA_ID'=>&SA_ID_PH1,
			'ID_PROTO'=> ($UNIQ_TRANS_SA) ? '135': '0',
			'ATTR_ENC_MODE'=>'TI_ATTR_ENC_MODE_TRNS',
			'ESP_ALG'=> selectIPsecEncryptionAlgorithm($USE_SA1_DES_CBC),
			'ATTR_AUTH'=> selectAuthenticationAlgorithm($USE_SA1_HMAC_MD5),
			'TN_ID_ADDR'=>"$mobile_node", 'NUT_ID_ADDR'=>"$home_agent"
		},
		{ # for SA5 and SA6
			'ID'=>&SA_ID_PH2_ICMP_TRANS,'PHASE'=>2,
			'ISAKMP_SA_ID'=>&SA_ID_PH1,
			'ID_PROTO'=> '58',
			'ATTR_ENC_MODE'=>'TI_ATTR_ENC_MODE_TRNS',
			'ESP_ALG'=> selectIPsecEncryptionAlgorithm($USE_SA5_DES_CBC),
			'ATTR_AUTH'=> selectAuthenticationAlgorithm($USE_SA5_HMAC_MD5),
			'TN_ID_ADDR'=>"$mobile_node", 'NUT_ID_ADDR'=>"$home_agent"
		},
		{ # for SA3 and SA4
			'ID'=>&SA_ID_PH2_MH_TUNNEL,'PHASE'=>2,
			'ISAKMP_SA_ID'=>&SA_ID_PH1,
			'ID_PROTO'=> ($UNIQ_TUNNEL_SA) ? '135': '0',
			'ATTR_ENC_MODE'=>'TI_ATTR_ENC_MODE_TUNNEL',
			'ESP_ALG'=> selectIPsecEncryptionAlgorithm($USE_SA3_DES_CBC),
			'ATTR_AUTH'=> selectAuthenticationAlgorithm($USE_SA3_HMAC_MD5),
			'TN_ID_ADDR'=>"$mobile_node", 'NUT_ID_ADDR'=>'::/0'
		},
		{ # for SA7 and SA8
			'ID'=>&SA_ID_PH2_ICMP_TUNNEL,'PHASE'=>2,
			'ISAKMP_SA_ID'=>&SA_ID_PH1,
			'ID_PROTO'=> '0',
			'ATTR_ENC_MODE'=>'TI_ATTR_ENC_MODE_TUNNEL',
			'ESP_ALG'=> selectIPsecEncryptionAlgorithm($USE_SA7_DES_CBC),
			'ATTR_AUTH'=> selectAuthenticationAlgorithm($USE_SA7_HMAC_MD5),
			'TN_ID_ADDR'=>"$mobile_node", 'NUT_ID_ADDR'=>'::/0'
		}
	);

	IKESetSaProf(@SaProf);


 	my @ARlist;
 	while (my ($recv, $send) = each(%$nd_mcast)) {
 		push @ARlist, { Frame=>$recv, Mode=>'response', Action=>$send };
 	}
 	while (my ($recv, $send) = each(%$nd_ucast)) {
 		push @ARlist, { Frame=>$recv, Mode=>'response', Action=>$send };
 	}
 	while (my ($recv, $send) = each(%$nd_mcast_hoa)) {
 		push @ARlist, { Frame=>$recv, Mode=>'response', Action=>$send };
 	}
 	IKESetAutoResponse(@ARlist);

	# define Callback on re-key
	my @SaCBList;
	if ($HAVE_IPSEC && $HAVE_IKE) {
		push(@SaCBList, { SaID =>&SA_ID_PH1 });
	}
	if ($HAVE_IPSEC && $HAVE_IKE && $USE_SA1_SA2) {
		push(@SaCBList, { SaID =>&SA_ID_PH2_MH_TRANS, Action => \&updateSA});
	}
	if ($HAVE_IPSEC && $HAVE_IKE && $USE_SA5_SA6 && $UNIQ_TRANS_SA) {
		push(@SaCBList, { SaID =>&SA_ID_PH2_ICMP_TRANS, Action => \&updateSA});
	}
	if ($HAVE_IPSEC && $HAVE_IKE && $USE_SA3_SA4) {
		push(@SaCBList, { SaID =>&SA_ID_PH2_MH_TUNNEL, Action => \&updateSA});
	}
	if ($HAVE_IPSEC && $HAVE_IKE && $USE_SA7_SA8 && $UNIQ_TUNNEL_SA) {
		push(@SaCBList, { SaID =>&SA_ID_PH2_ICMP_TUNNEL, Action => \&updateSA});
	}

	IKESetResponder(@SaCBList);

	return(&TRUE);
}

#------------------------------#
# runIKE                       #
#------------------------------#
sub runIKE($$)
{
	my ($link, $nd_mcast_hoa) = @_;

#	if ($NEED_REBOOT || $ROTATE_HOA || ($HAVE_IKE && $IKE_EVERY_SEQ)) {
#		print "\nrun iked.\nand press return.\n";
#		<STDIN>;
#	}

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>IKE NEGOTIATION'.
			 '</B></U></FONT><BR>');

	# INITIATOR Phase-1
	vClear($link);
	my $ike_timeout = 5;
	%ret=IKEStartPh1(&SA_ID_PH1, $link, $ike_timeout, @$nd_mcast_hoa);

	if ($ret{ikeStatus} ne 'StSAComplete') {
		vLogHTML('<FONT COLOR="#FF0000">ike.pm: '.
				 'Couldn\'t establish ISAKMP-SA.</FONT><BR>');
		return(&FALSE);
	}

	$p1handle=$ret{'ikeResult'}->{'SA_HANDLER'};
	$sa_handler{&SA_ID_PH1} = $ret{'ikeResult'}->{SA_HANDLER};

	# INITIATOR Phase-2
	# transport mode
	if ($HAVE_IKE && $USE_SA1_SA2) {
		%ret=IKEStartPh2(&SA_ID_PH2_MH_TRANS,$p1handle,
						 $link, $ike_timeout, @$nd_mcast_hoa);
		if ($ret{ikeStatus} eq 'StSAComplete') {
			$sa_handler{&SA_ID_PH2_MH_TRANS} = $ret{'ikeResult'}->{SA_HANDLER};
		} else {
			vLogHTML('<FONT COLOR="#FF0000">ike.pm: '.
					 'Couldn\'t establish IPsec-SA for Mobile Header transport-mode</FONT><BR>');
			return(&FALSE);
		}

		vLogHTML("HAVE_IKE:$HAVE_IKE<br>");
		vLogHTML("UNIQ_TRANS_SA:$UNIQ_TRANS_SA<br>");
		vLogHTML("USE_SA5_SA6:$USE_SA5_SA6<br>");
		if ($HAVE_IKE && $UNIQ_TRANS_SA && $USE_SA5_SA6) {
			%ret=IKEStartPh2(&SA_ID_PH2_ICMP_TRANS,$p1handle,
							 $link, $ike_timeout, @$nd_mcast_hoa);
			if ($ret{ikeStatus} eq 'StSAComplete') {
				$sa_handler{&SA_ID_PH2_ICMP_TRANS} = $ret{'ikeResult'}->{SA_HANDLER};
			} else {
				vLogHTML('<FONT COLOR="#FF0000">ike.pm: '.
						 'Couldn\'t establish IPsec-SA for ICMPv6 transport-mode</FONT><BR>');
				return(&FALSE);
			}
		}
	}

	# tunnel mode
	if ($HAVE_IKE && $USE_SA3_SA4) {
		%ret=IKEStartPh2(&SA_ID_PH2_MH_TUNNEL,$p1handle,
						 $link, $ike_timeout, @$nd_mcast_hoa);
		if ($ret{ikeStatus} eq 'StSAComplete') {
			$sa_handler{&SA_ID_PH2_MH_TUNNEL} = $ret{'ikeResult'}->{SA_HANDLER};
		} else {
			vLogHTML('<FONT COLOR="#FF0000">ike.pm: '.
					 'Couldn\'t establish IPsec-SA for Mobile Header tunnel-mode</FONT><BR>');
			return(&FALSE);
		}

		vLogHTML("HAVE_IKE:$HAVE_IKE<br>");
		vLogHTML("UNIQ_TUNNEL_SA:$UNIQ_TUNNEL_SA<br>");
		vLogHTML("USE_SA7_SA8:$USE_SA7_SA8<br>");
		if ($HAVE_IKE && $UNIQ_TUNNEL_SA && $USE_SA7_SA8) {
			%ret=IKEStartPh2(&SA_ID_PH2_ICMP_TUNNEL,$p1handle,
							 $link, $ike_timeout, @$nd_mcast_hoa);
			if ($ret{ikeStatus} eq 'StSAComplete') {
				$sa_handler{&SA_ID_PH2_ICMP_TUNNEL} = $ret{'ikeResult'}->{SA_HANDLER};
			} else {
				vLogHTML('<FONT COLOR="#FF0000">ike.pm: '.
						 'Couldn\'t establish IPsec-SA for ICMPv6 tunnel-mode</FONT><BR>');
				return(&FALSE);
			}
		}
	}

	foreach my $key (keys(%sa_handler)) {
		print "$key => $sa_handler{$key}\n";
	}

	#if (!(-e &SA_PERL_FILE)) {
	overwriteSA($ret{'ikeResult'});
	#}
	#showSA();
	return(&TRUE);
}


#------------------------------#
# finalizeIKE                  #
#------------------------------#
sub finalizeIKE {
    my ($nodelete) = @_;

	if ($USE_IKE_DELETE_PAYLOAD) {
		IKEapi::IKEEnd(0);
		if (-e &SA_PERL_FILE) {
			unlink(&SA_PERL_FILE);
		}
	}
	else {
		IKEapi::IKEEnd(1);
	}
}

#---------------------------------#
# selectISAKMPEncryptionAlgorithm #
#---------------------------------#
sub selectISAKMPEncryptionAlgorithm {
	my ($use_des) = @_;
	return ($use_des_des) ? 'TI_ATTR_ENC_ALG_DES' : 'TI_ATTR_ENC_ALG_3DES';
}

#--------------------------------#
# selectISAKMPHashAlgorithm      #
#--------------------------------#
sub selectISAKMPHashAlgorithm {
	my ($use_md5) = @_;
	return ($use_md5) ? 'TI_ATTR_HASH_ALG_MD5' : 'TI_ATTR_HASH_ALG_SHA';
}


#--------------------------------#
# selectIPsecEncryptionAlgorithm #
#--------------------------------#
sub selectIPsecEncryptionAlgorithm {
	my ($use_des_cbc) = @_;
	return ($use_des_cbc) ? 'TI_ESP_ALG_DES' : 'TI_ESP_ALG_3DES';
}


#--------------------------------#
# selectAuthenticationAlgorithm  #
#--------------------------------#
sub selectAuthenticationAlgorithm {
	my ($use_hmac_md5) = @_;
	return ($use_hmac_md5) ? 'TI_ATTR_AUTH_HMAC_MD5' : 'TI_ATTR_AUTH_HMAC_SHA';
}


#----------------------------------------------------------------------
# Write SA

#------------------------------#
# overwriteSA                  #
#------------------------------#
sub overwriteSA {

	my $file_exp = "> ".&SA_PERL_FILE;
	unless (open(OUTPUT, $file_exp)) {
		vLogHTML("<FONT COLOR=\"#FF0000\">can't open: ".&SA_PERL_FILE.": $!".
				 '</FONT><BR>');

		return(&FALSE);
	}

	print(OUTPUT "#!/usr/bin/perl\n\n");
	print(OUTPUT "package ike;\n\n");

# 	if ($sa_handler{&SA_ID_PH1}) {
# 		my %sa = IKEGetSaInfo($sa_handler{&SA_ID_PH1});
# 		print(OUTPUT_ISAKMP "\%isakmp_sa = (\n");
# 		foreach my $key (sort(keys(%sa))) {
# 			print(OUTPUT_ISAKMP "'$key' => '$sa{$key}',\n"
# 		}
# 		print(OUTPUT_ISAKMP ");\n\n");
# 	}

	if ($sa_handler{&SA_ID_PH2_MH_TRANS}) {
		my %sa = IKEGetSaInfo($sa_handler{&SA_ID_PH2_MH_TRANS});
		printSA(\%sa, 1, 'OUT');
		printSA(\%sa, 2, 'IN');
	}
	if ($sa_handler{&SA_ID_PH2_ICMP_TRANS}) {
		my %sa = IKEGetSaInfo($sa_handler{&SA_ID_PH2_ICMP_TRANS});
		printSA(\%sa, 5, 'OUT');
		printSA(\%sa, 6, 'IN');
	}
	if ($sa_handler{&SA_ID_PH2_MH_TUNNEL}) {
		my %sa = IKEGetSaInfo($sa_handler{&SA_ID_PH2_MH_TUNNEL});
		printSA(\%sa, 3, 'OUT');
		printSA(\%sa, 4, 'IN');
	}
	if ($sa_handler{&SA_ID_PH2_ICMP_TUNNEL}) {
		my %sa = IKEGetSaInfo($sa_handler{&SA_ID_PH2_ICMP_TUNNEL});
		printSA(\%sa, 7, 'OUT');
		printSA(\%sa, 8, 'IN');
	}

	## output SA_HANDLER
	print (OUTPUT "\%sa_handler = (\n");
	foreach my $key (sort(keys(%sa_handler))) {
		print (OUTPUT "'$key' => '$sa_handler{$key}',\n");
	}
	print (OUTPUT ");\n");

	close(OUTPUT);

	if (chmod(0755, &SA_PERL_FILE) != 1) {
		return (&FALSE);
	}
	return(&TRUE);
}


#------------------------------#
# printSA                     #
#------------------------------#
sub printSA {
	my ($sa, $sa_number, $inout) = @_;

	print(OUTPUT "\%sa$sa_number = (\n");
	my $said = "sa$sa_number";

	if ($inout eq 'OUT') {
		print(OUTPUT "'SPI' => '$sa->{OUT_SPI}',\n");
		print(OUTPUT "'HASH_KEY' => '$sa->{OUT_AUTH_KEY}',\n");
		print(OUTPUT "'ENC_KEY' => '$sa->{OUT_ENC_KEY}',\n");
		print(OUTPUT "'LIFETIME' => '$sa->{OUT_LIFETIME}',\n");
		${$said}{'SPI'} = "$sa->{OUT_SPI}";
		${$said}{'HASH_KEY'} = "$sa->{OUT_AUTH_KEY}";
		${$said}{'ENC_KEY'} = "$sa->{OUT_ENC_KEY}";
		${$said}{'LIFETIME'} = "$sa->{OUT_LIFETIME}";
	}
	else {
		print(OUTPUT "'SPI' => '$sa->{IN_SPI}',\n");
		print(OUTPUT "'HASH_KEY' => '$sa->{IN_AUTH_KEY}',\n");
		print(OUTPUT "'ENC_KEY' => '$sa->{IN_ENC_KEY}',\n");
		print(OUTPUT "'LIFETIME' => '$sa->{IN_LIFETIME}',\n");
		${$said}{'SPI'} = "$sa->{IN_SPI}";
		${$said}{'HASH_KEY'} = "$sa->{IN_AUTH_KEY}";
		${$said}{'ENC_KEY'} = "$sa->{IN_ENC_KEY}";
		${$said}{'LIFETIME'} = "$sa->{IN_LIFETIME}";
	}

	print(OUTPUT "'PROFILE_ID' => '$sa->{PROFILE_ID}',\n");
	print(OUTPUT "'ATTR_AUTH' => '$sa->{ATTR_AUTH}',\n");
	print(OUTPUT "'ESP_ALG' => '$sa->{ESP_ALG}',\n");
	print(OUTPUT "'SA_HANDLER' => '$sa->{SA_HANDLER}',\n");
	print(OUTPUT "'ISAKMP_SA_HANDLER' => '$sa->{ISAKMP_SA_HANDLER}',\n");
	print(OUTPUT ");\n\n");
	${$said}{'PROFILE_ID'} = "$sa->{PROFILE_ID}";
	${$said}{'ATTR_AUTH'} = "$sa->{ATTR_AUTH}";
	${$said}{'ESP_ALG'} = "$sa->{ESP_ALG}";
	${$said}{'SA_HANDLER'} = "$sa->{SA_HANDLER}";
	${$said}{'ISAKMP_SA_HANDLER'} = "$sa->{ISAKMP_SA_HANDLER}";
}


#------------------------------#
# updateSA                     #
#------------------------------#
sub updateSA {
	my ($arg) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>RE-KEY'.
			 '</B></U></FONT><BR>');

	print "re-key\n";

	my $file_exp = ">> ".&SA_PERL_FILE;
	unless (open(OUTPUT, $file_exp)) {
		vLogHTML("<FONT COLOR=\"#FF0000\">can't open: ".&SA_PERL_FILE.": $!".
				 '</FONT><BR>');

		return(&FALSE);
	}

	if ($arg->{'SaInfo'}->{'PROFILE_ID'} eq &SA_ID_PH2_MH_TRANS) {
		$sa_handler{&SA_ID_PH2_MH_TUNNEL} = $arg->{'SaInfo'}->{'SA_HANDLER'};
		my %sa = IKEGetSaInfo($sa_handler{&SA_ID_PH2_MH_TRANS});
		printSA(\%sa, 1, 'OUT');
		printSA(\%sa, 2, 'IN');
	}
	elsif ($arg->{'SaInfo'}->{'PROFILE_ID'} eq &SA_ID_PH2_ICMP_TRANS) {
		$sa_handler{&SA_ID_PH2_MH_TUNNEL} = $arg->{'SaInfo'}->{'SA_HANDLER'};
		my %sa = IKEGetSaInfo($sa_handler{&SA_ID_PH2_ICMP_TRANS});
		printSA(\%sa, 5, 'OUT');
		printSA(\%sa, 6, 'IN');
	}
	elsif ($arg->{'SaInfo'}->{'PROFILE_ID'} eq &SA_ID_PH2_MH_TUNNEL) {
		$sa_handler{&SA_ID_PH2_MH_TUNNEL} = $arg->{'SaInfo'}->{'SA_HANDLER'};
		my %sa = IKEGetSaInfo($sa_handler{&SA_ID_PH2_MH_TUNNEL});
		printSA(\%sa, 3, 'OUT');
		printSA(\%sa, 4, 'IN');
	}
	elsif ($arg->{'SaInfo'}->{'PROFILE_ID'} eq &SA_ID_PH2_ICMP_TUNNEL) {
		$sa_handler{&SA_ID_PH2_MH_TUNNEL} = $arg->{'SaInfo'}->{'SA_HANDLER'};
		my %sa = IKEGetSaInfo($sa_handler{&SA_ID_PH2_ICMP_TUNNEL});
		printSA(\%sa, 7, 'OUT');
		printSA(\%sa, 8, 'IN');
	}

	close(OUTPUT);
}


#----------------------------------------------------------------------
# Get SA

#------------------------------#
# getSA                        #
#------------------------------#
sub getSA {
	my (@salist) = @_;

	my $cpp = '';
	return $cpp if (!$HAVE_IPSEC || !$HAVE_IKE);

	if (!(-e &SA_PERL_FILE)) {
		vLogHTML('<FONT COLOR="#FF0000">ike.pm: '.
				 'had no IPsec-SA. please check config.txt.</FONT><BR>');
		exitFatal();
	}
#	require &SA_PERL_FILE;

	my %values = (
		'1' => &FALSE,
		'3' => &FALSE,
		'5' => &FALSE,
		'7' => &FALSE,
		);

	# process only $num is 1, 3, 5 and 7, so 2, 4, 6 and 8 is ignored.
	foreach my $num (@salist) {
		if ($num eq 1) {
			$values{'1'} = &TRUE;
		}
		elsif ($num eq 3) {
			$values{'3'} = &TRUE;
		}
		elsif ($num eq 5) {
			if ($UNIQ_TRANS_SA && $USE_SA5_SA6) {
				$values{'5'} = &TRUE;
			}
			else {
				$values{'1'} = &TRUE;
			}
		}
		elsif ($num eq 7) {
			if ($UNIQ_TUNNEL_SA && $USE_SA7_SA8) {
				$values{'7'} = &TRUE;
			}
			else {
				$values{'3'} = &TRUE;
			}
		}
		else {
			next;
		}
	}

	foreach my $key (keys(%values)) {
		next if (!$values{"$key"});

		if ($key eq 1) {
			$cpp .= getSA12();
		}
		elsif ($key eq 3) {
			$cpp .= getSA34();
		}
		elsif ($key eq 5) {
			$cpp .= getSA56();
		}
		else {
			$cpp .= getSA78();
		}
	}

	return $cpp;
}

sub getSA12 {
	my $cpp = ' ';

	# print "\nSA1\n";
	# print "OUT:$sa1{'SPI'}\n";
	# print "$sa1{'HASH_KEY'}\n";
	# print "$sa1{'ENC_KEY'}\n";
	# print "SA2\n";
	# print "IN:$sa2{'SPI'}\n";
	# print "$sa2{'HASH_KEY'}\n";
	# print "$sa2{'ENC_KEY'}\n";

	$cpp .= "-DSA1_SPI=$sa1{'SPI'} ";
	$cpp .= "-DSA1_HASH_KEY=\\\"$sa1{'HASH_KEY'}\\\" ";
	$cpp .= "-DSA1_ENC_KEY=\\\"$sa1{'ENC_KEY'}\\\" ";
	$cpp .= "-DSA2_SPI=$sa2{'SPI'} ";
	$cpp .= "-DSA2_HASH_KEY=\\\"$sa2{'HASH_KEY'}\\\" ";
	$cpp .= "-DSA2_ENC_KEY=\\\"$sa2{'ENC_KEY'}\\\" ";

	return $cpp;
}

sub getSA34 {
	my $cpp = ' ';

	# print "\nSA3\n";
	# print "OUT:$sa3{'SPI'}\n";
	# print "$sa3{'HASH_KEY'}\n";
	# print "$sa3{'ENC_KEY'}\n";
	# print "SA4\n";
	# print "IN:$sa4{'SPI'}\n";
	# print "$sa4{'HASH_KEY'}\n";
	# print "$sa4{'ENC_KEY'}\n";

	$cpp .= "-DSA3_SPI=$sa3{'SPI'} ";
	$cpp .= "-DSA3_HASH_KEY=\\\"$sa3{'HASH_KEY'}\\\" ";
	$cpp .= "-DSA3_ENC_KEY=\\\"$sa3{'ENC_KEY'}\\\" ";
	$cpp .= "-DSA4_SPI=$sa4{'SPI'} ";
	$cpp .= "-DSA4_HASH_KEY=\\\"$sa4{'HASH_KEY'}\\\" ";
	$cpp .= "-DSA4_ENC_KEY=\\\"$sa4{'ENC_KEY'}\\\" ";

	return $cpp;
}

sub getSA56 {
	my $cpp = ' ';

	# print "\nSA5\n";
	# print "OUT:$sa5{'SPI'}\n";
	# print "$sa5{'HASH_KEY'}\n";
	# print "$sa5{'ENC_KEY'}\n";
	# print "SA6\n";
	# print "IN:$sa6{'SPI'}\n";
	# print "$sa6{'HASH_KEY'}\n";
	# print "$sa6{'ENC_KEY'}\n";

	$cpp .= "-DSA5_SPI=$sa5{'SPI'} ";
	$cpp .= "-DSA5_HASH_KEY=\\\"$sa5{'HASH_KEY'}\\\" ";
	$cpp .= "-DSA5_ENC_KEY=\\\"$sa5{'ENC_KEY'}\\\" ";
	$cpp .= "-DSA6_SPI=$sa6{'SPI'} ";
	$cpp .= "-DSA6_HASH_KEY=\\\"$sa6{'HASH_KEY'}\\\" ";
	$cpp .= "-DSA6_ENC_KEY=\\\"$sa6{'ENC_KEY'}\\\" ";

	return $cpp;
}

sub getSA78 {
	my $cpp = ' ';

	# print "\nSA7\n";
	# print "OUT:$sa7{'SPI'}\n";
	# print "$sa7{'HASH_KEY'}\n";
	# print "$sa7{'ENC_KEY'}\n";
	# print "SA8\n";
	# print "IN:$sa8{'SPI'}\n";
	# print "$sa8{'HASH_KEY'}\n";
	# print "$sa8{'ENC_KEY'}\n";

	$cpp .= "-DSA7_SPI=$sa7{'SPI'} ";
	$cpp .= "-DSA7_HASH_KEY=\\\"$sa7{'HASH_KEY'}\\\" ";
	$cpp .= "-DSA7_ENC_KEY=\\\"$sa7{'ENC_KEY'}\\\" ";
	$cpp .= "-DSA8_SPI=$sa8{'SPI'} ";
	$cpp .= "-DSA8_HASH_KEY=\\\"$sa8{'HASH_KEY'}\\\" ";
	$cpp .= "-DSA8_ENC_KEY=\\\"$sa8{'ENC_KEY'}\\\" ";

	return $cpp;
}


#------------------------------#
# showSA                       #
#------------------------------#
sub showSA {
	unless ($HAVE_IPSEC && $HAVE_IKE) {
		return;
	}

	my %sa = IKEGetSaInfo(1000);
	print "\n$sa{'PROFILE_ID'}\n";
	foreach my $key (keys(%sa)) {
		print "$key\t=> $sa{$key}\n";
	}


	if ($USE_SA1_SA2) {
		%sa = IKEGetSaInfo(1001);
		print "\n$sa{'PROFILE_ID'}\n";
		foreach my $key (keys(%sa)) {
			print "$key\t=> $sa{$key}\n";
		}
	}

	if ($USE_SA3_SA4) {
		%sa = IKEGetSaInfo(1002);
		print "\n$sa{'PROFILE_ID'}\n";
		foreach my $key (keys(%sa)) {
			print "$key\t=> $sa{$key}\n";
		}
	}

	if ($UNIQ_TRANS_SA && $USE_SA5_SA6) {
		%sa = IKEGetSaInfo(1003);
		print "\n$sa{'PROFILE_ID'}\n";
		foreach my $key (keys(%sa)) {
			print "$key\t=> $sa{$key}\n";
		}
	}

	if ($UNIQ_TUNNEL_SA && $USE_SA7_SA8) {
		%sa = IKEGetSaInfo(1004);
		print "\n$sa{'PROFILE_ID'}\n";
		foreach my $key (keys(%sa)) {
			print "$key\t=> $sa{$key}\n";
		}
	}
}

#----------------------------------------------------------------------
# IKEapi Wrapper

#------------------------------#
# IKEvRecv                     #
#------------------------------#
sub IKEvRecv {
    my ($intf, $timeout,$seektime, $count, @frames) = @_;

	return IKEapi::IKEvRecv($intf, $timeout, $seektime, $count, @frames);
}

#------------------------------#
# VCppApply                    #
#------------------------------#
sub VCppApply {
	IKEapi::VCppApply(@_);
}

#------------------------------#
# VCppRegistMIP                #
#------------------------------#
sub VCppRegistMIP {
	my ($cpp) = @_;
	IKEapi::VCppRegist("mip", $cpp, 1);
}

#------------------------------#
# VCppRegistIPsec              #
#------------------------------#
sub VCppRegistIPsec {
	my ($cpp) = @_;
	IKEapi::VCppRegist("ipsec", $cpp, 0);
}


#------------------------------#
# exitFatal                    #
#------------------------------#
sub exitFatal {
	$mipv6CBMap{'exitFatal'}->();
}

1;
