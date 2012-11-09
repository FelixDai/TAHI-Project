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

use Getopt::Long;
use File::Basename;



#------------------------------#
# global configurations        #
#------------------------------#
my $opt_all	= 0;
my $opt_logo	= 0;			# 1: basic
					# 2: fine grain
my $opt_compare	= 0;
my $opt_debug	= 0;
my $opt_index	= './INDEX';		# target file for autorun
my $opt_packet	= './config.def';	# target file for *.def
my $opt_config	= './config.pm';	# target file for *.seq

my %values      = (
	'IPV6_READY_LOGO_PHASE2' => '0',
	'FINE_GRAIN_SELECTORS'   => '0',

	'NEED_REBOOT'		=> '0',
	'REBOOT_TIMEOUT'	=> '300',
	'ROTATE_HOA'		=> '0',
	'NEED_ANYCAST'		=> '0',
	'NEED_ENABLE'		=> '0',
	'NEED_ROUTE'		=> '0',
	'NEED_IPSEC'		=> '0',
	'NEED_RA'		=> '0',

	'HAVE_HOME_LINK'	=> '1',
	'HAVE_FOREIGN_LINK'	=> '0',

	'HAVE_REAL_HOME'	=> '1',
	'HAVE_DHAAD'		=> '1',
	'HAVE_MPD'		=> '1',
	'HAVE_RR'		=> '1',

	'HAVE_IPSEC'		=> '1',

	'HAVE_IKE'		=> '0',
	'IKE_EVERY_SEQ'		=> '0',
	'USE_IKE_DELETE_PAYLOAD'=> '0',
	'USE_IKE_BA_K_BIT'	=> '0',

	'ISAKMP_ID_TYPE_MN'	=> '2',
	'ISAKMP_ID_MN'		=> 'user@aaa.com',
	'ISAKMP_ID_TYPE_HA'	=> '2',
	'ISAKMP_ID_HA'		=> 'user@bbb.com',

	'DH_GROUP'		=> '0',
	'USE_ISAKMP_DES'	=> '0',
	'USE_ISAKMP_MD5'	=> '0',
	'IPSEC_PSK'		=> 'IPsecPSK',

	'UNIQ_TRANS_SA'		=> '1',
	'GRAN_TRANS_SA_TYPE'	=> '0',
	'UNIQ_TUNNEL_SA'	=> '1',
	'GRAN_TUNNEL_SA_TYPE'	=> '0',

	'USE_SA1_SA2'		=> '1',

	'USE_SA1_DES_CBC'	=> '0',
	'USE_SA1_HMAC_MD5'	=> '0',
	'SA1_SPI'		=> '0x111',
	'SA1_ENC_KEY'		=> '"V6LC-111--12345678901234"',
	'SA1_HASH_KEY'		=> '"V6LC-111--1234567890"',

	'USE_SA2_DES_CBC'	=> '0',
	'USE_SA2_HMAC_MD5'	=> '0',
	'SA2_SPI'		=> '0x112',
	'SA2_ENC_KEY'		=> '"V6LC-112--12345678901234"',
	'SA2_HASH_KEY'		=> '"V6LC-112--1234567890"',

	'USE_SA3_SA4'		=> '1',

	'USE_SA3_DES_CBC'	=> '0',
	'USE_SA3_HMAC_MD5'	=> '0',
	'SA3_SPI'		=> '0x113',
	'SA3_ENC_KEY'		=> '"V6LC-113--12345678901234"',
	'SA3_HASH_KEY'		=> '"V6LC-113--1234567890"',

	'USE_SA4_DES_CBC'	=> '0',
	'USE_SA4_HMAC_MD5'	=> '0',
	'SA4_SPI'		=> '0x114',
	'SA4_ENC_KEY'		=> '"V6LC-114--12345678901234"',
	'SA4_HASH_KEY'		=> '"V6LC-114--1234567890"',

	'USE_SA5_SA6'		=> '1',

	'USE_SA5_DES_CBC'	=> '0',
	'USE_SA5_HMAC_MD5'	=> '0',
	'SA5_SPI'		=> '0x115',
	'SA5_ENC_KEY'		=> '"V6LC-115--12345678901234"',
	'SA5_HASH_KEY'		=> '"V6LC-115--1234567890"',

	'USE_SA6_DES_CBC'	=> '0',
	'USE_SA6_HMAC_MD5'	=> '0',
	'SA6_SPI'		=> '0x116',
	'SA6_ENC_KEY'		=> '"V6LC-116--12345678901234"',
	'SA6_HASH_KEY'		=> '"V6LC-116--1234567890"',

	'USE_SA7_SA8'		=> '0',

	'USE_SA7_DES_CBC'	=> '0',
	'USE_SA7_HMAC_MD5'	=> '0',
	'SA7_SPI'		=> '0x117',
	'SA7_ENC_KEY'		=> '"V6LC-117--12345678901234"',
	'SA7_HASH_KEY'		=> '"V6LC-117--1234567890"',

	'USE_SA8_DES_CBC'	=> '0',
	'USE_SA8_HMAC_MD5'	=> '0',
	'SA8_SPI'		=> '0x118',
	'SA8_ENC_KEY'		=> '"V6LC-118--12345678901234"',
	'SA8_HASH_KEY'		=> '"V6LC-118--1234567890"',
);



#------------------------------#
# function prototypes          #
#------------------------------#
sub main($$);
sub dbg($$$);
sub usage($);
sub parse_arguments();
sub read_configuration($$);
sub parse_configuration();
sub copy_index(*$$$$$);
sub overwrite_config_pm($);
sub overwrite_config_def($);
sub overwrite_index($);



#------------------------------#
# global constants             #
#------------------------------#
my $true	= 1;
my $false	= 0;



#------------------------------#
# wrap perl world              #
#------------------------------#
my $strerror = '';

exit(main(\@ARGV, \%ENV));



#--------------------------------------------------------------#
# main()                                                       #
#--------------------------------------------------------------#
sub
main($$)
{
	my ($argv, $envp) = @_;

	my $prog = basename($0);

	dbg(__FILE__, __LINE__, "\$prog: $prog\n");

	unless(parse_arguments()) {
		usage($prog);
		# NOTREACHED
	}

	my $argc = $#$argv;

	dbg(__FILE__, __LINE__, "\$opt_all:\t$opt_all\n");
	dbg(__FILE__, __LINE__, "\$opt_compare:\t$opt_compare\n");
	dbg(__FILE__, __LINE__, "\$opt_debug:\t$opt_debug\n");
	dbg(__FILE__, __LINE__, "\$opt_index:\t$opt_index\n");
	dbg(__FILE__, __LINE__, "\$opt_packet:\t$opt_packet\n");
	dbg(__FILE__, __LINE__, "\$opt_config:\t$opt_config\n");
	dbg(__FILE__, __LINE__, "\$argc:\t$argc\n");

	if($argc) {
		usage($prog);
		# NOTREACHED
	}

	my $configuration = $$argv[0];

	dbg(__FILE__, __LINE__, "\$configuration: $configuration\n");

	my @keys	= sort(keys(%values));

	unless(read_configuration($configuration, \@keys)) {
		print(STDERR "$prog: $strerror\n");
		return(-1);
		# NOTREACHED
	}

	unless(parse_configuration()) {
		print(STDERR "$prog: $strerror\n");
		return(-1);
		# NOTREACHED
	}

	unless(overwrite_config_pm(\@keys)) {
		print(STDERR "$prog: $strerror\n");
		return(-1);
		# NOTREACHED
	}

	unless(overwrite_config_def(\@keys)) {
		print(STDERR "$prog: $strerror\n");
		return(-1);
		# NOTREACHED
	}

	unless(overwrite_index(\@keys)) {
		print(STDERR "$prog: $strerror\n");
		return(-1);
		# NOTREACHED
	}

	return(0);
	# NOTREACHED
}



#--------------------------------------------------------------#
# dbg()                                                        #
#--------------------------------------------------------------#
sub
dbg($$$)
{
	my ($path, $line, $string) = @_;

	if($opt_debug) {
		my $file = basename($path);
		print(STDERR "dbg[$$]: $file: $line: $string");
	}

	return;
}



#--------------------------------------------------------------#
# usage()                                                      #
#--------------------------------------------------------------#
sub
usage($)
{
	my ($prog) = @_;

	print(STDERR "usage: $prog ".
		"[-a|all] ".
		"[-d|debug] ".
		"[-i|index file] ".
		"[-l|logo level] ".
		"[-p|packet file] ".
		"[-s|script file] ".
		"file\n");
	print(STDERR "       $prog ".
		"<-c|compare> ".
		"file\n");

	exit(-1);
}



#--------------------------------------------------------------#
# parse_arguments()                                            #
#--------------------------------------------------------------#
sub
parse_arguments()
{
	$Getopt::Long::bundling = 1;

	unless(GetOptions(
		'a|all'		=> \$opt_all,
		'c|compare'	=> \$opt_compare,
		'd|debug+'	=> \$opt_debug,
		'i|index=s'	=> \$opt_index,
		'l|logo=s'	=> \$opt_logo,
		'p|packet=s'	=> \$opt_packet,
		's|script=s'	=> \$opt_config,
	)) {
		return($false);
	}

	return($true);
}



#--------------------------------------------------------------#
# read_configuration()                                         #
#--------------------------------------------------------------#
sub
read_configuration($$)
{
	my ($file, $keys) = @_;

	my $diff	= $false;

	local(*INPUT);

	unless(open(INPUT, $file)) {
		$strerror = "open: $file: $!";
		return($false);
	}

	for(my $number = 1; <INPUT>; $number ++) {
		chomp;

		my $line = $_;

		if($line =~ /^([^#]*)#.*$/) {
			$line = $1;
		}

		if($line =~ /^\s*$/) {
			next;
		}

		if($line =~ /^\s*(\S+)\s+(\S+)\s*$/) {
			my $bool	= $false;
			my $key		= $1;
			my $value	= $2;

			foreach my $valid (@$keys) {
				if($key eq $valid) {
					$bool = $true;
					last;
				}
			}

			if($bool) {
				my $default = $values{$key};
				$values{$key} = $value;

				dbg(__FILE__, __LINE__,
					"$key:\t$default\t-> $value\n");

				if($opt_compare && ($value ne $default)) {
					print("$file: $number: ".
						"$key:\t$default\t-> $value\n");

					$diff	= $true;
				}

				next;
			}

			$strerror = "read_configuration: $file: $number: ".
				"unknown keyword -- $key";

			return($false);
		}

		$strerror = "read_configuration: $file: $number: syntax error";
		return($false);
	}

	close(INPUT);

	return(($opt_compare && $diff)? $false: $true);
}



#--------------------------------------------------------------#
# parse_configuration()                                        #
#--------------------------------------------------------------#
sub
parse_configuration()
{

	# Fix Configure
	if($opt_logo eq '1') {
		$values{'IPV6_READY_LOGO_PHASE2'} = 1;
		$values{'FINE_GRAIN_SELECTORS'} = 0;
	}
	elsif($opt_logo eq '2') {
		$values{'IPV6_READY_LOGO_PHASE2'} = 1;
		$values{'FINE_GRAIN_SELECTORS'} = 1;
	}

	if($values{'IPV6_READY_LOGO_PHASE2'} ne '0') {

		# BASIC
		if ($values{'ROTATE_HOA'} ne '0'){
			$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
				'ROTATE_HOA must be zero value.';
			return($false);
		}
		if ($values{'HAVE_IPSEC'} eq '0'){
			$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
				'HAVE_IPSEC must be non-zero value.';
			return($false);
		}
		if ($values{'HAVE_IKE'} ne '0'){
			$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
				'HAVE_IKE must be zero value.';
			return($false);
		}
		if ($values{'UNIQ_TRANS_SA'} eq '0'){
			$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
				'UNIQ_TRANS_SA must be non-zero value.';
			return($false);
		}
		if ($values{'USE_SA1_SA2'} eq '0'){
			$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
				'USE_SA1_SA2 must be non-zero value.';
			return($false);
		}
		if ($values{'USE_SA7_SA8'} ne '0'){
			$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
				'USE_SA7_SA8 must be zero value.';
			return($false);
		}

		# Advanced Real Home Link - "HAVE_REAL_HOME"
		if ($values{'HAVE_REAL_HOME'} ne '0'){
			if ($values{'HAVE_HOME_LINK'} eq '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'HAVE_HOME_LINK must be non-zero value w/ HAVE_REAL_HOME.';
				return($false);
			}
		}

		# Advanced DHAAD - "HAVE_DHAAD"

		# Advanced MPD - "HAVE_MPD"
		if ($values{'HAVE_MPD'} ne '0'){
			if ($values{'USE_SA5_SA6'} eq '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'USE_SA5_SA6 must be non-zero value w/ HAVE_MPD.';
				return($false);
			}
		}
		else {
			if ($values{'USE_SA5_SA6'} ne '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'USE_SA5_SA6 must be zero value w/o HAVE_MPD.';
				return($false);
			}
		}

		# Advanced RR - "HAVE_RR"
		if ($values{'HAVE_RR'} ne '0'){
			if ($values{'UNIQ_TUNNEL_SA'} eq '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'UNIQ_TUNNEL_SA must be non-zero value w/ HAVE_RR.';
				return($false);
			}
			if ($values{'USE_SA3_SA4'} eq '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'USE_SA3_SA4 must be non-zero value w/ HAVE_RR.';
				return($false);
			}
		}
		else {
			if ($values{'USE_SA3_SA4'} ne '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'USE_SA3_SA4 must be zero value w/o HAVE_RR.';
				return($false);
			}
		}

		# Advanced FINE-GRAIN SELECTORS
		if ($values{'FINE_GRAIN_SELECTORS'} eq '0'){
			if ($values{'GRAN_TRANS_SA_TYPE'} ne '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'GRAN_TRANS_SA_TYPE must be zero value with "Basic" fucntion.';
				return($false);
			}
			if ($values{'GRAN_TUNNEL_SA_TYPE'} ne '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'GRAN_TUNNEL_SA_TYPE must be zero value with "Basic" fucntion.';
				return($false);
			}
		}
		else {
			if ($values{'GRAN_TRANS_SA_TYPE'} eq '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'GRAN_TRANS_SA_TYPE must be non-zero value with "Fine-Grain Selectors" function.';
				return($false);
			}
			if ($values{'GRAN_TUNNEL_SA_TYPE'} eq '0'){
				$strerror = 'parse_configuration [IPV6_READY_LOGO]: '.
					'GRAN_TUNNEL_SA_TYPE must be non-zero value with "Fine-Grain Selectors" function.';
				return($false);
			}
		}
	}

#
# 			NG	OK	OK	OK
# HAVE_HOME_LINK	0	1	0	1
# HAVE_FOREIGN_LINK	0	0	1	1
#

	if(($values{'HAVE_HOME_LINK'} eq '0') &&
		($values{'HAVE_FOREIGN_LINK'} eq '0')) {

		$strerror = 'parse_configuration: '.
			'at least HAVE_HOME_LINK or HAVE_FOREIGN_LINK must be '.
			'specified by non-zero value. Please check config.txt';

		return($false);
	}

#
# 				OK	NG	OK	OK
# NEED_REBOOT			1	0	0	0
# IKE_EVERY_SEQ			*	0	1	1
# USE_IKE_DELETE_PAYLOAD	*	*	0	1
#

	if($values{'HAVE_IKE'} ne '0'){
		if(($values{'NEED_REBOOT'} eq '0') &&
		   ($values{'IKE_EVERY_SEQ'} eq '0')) {

			$strerror = 'parse_configuration [IKE]: '.
				'When NEED_REBOOT is zero, IKE_EVERY_SEQ must be non-zero. '.
				'When IKE_EVERY_SEQ is non-zero, USE_IKE_DELETE_PAYLOAD should be non-zero. '.
				'Please check config.txt';

			return($false);
		}
	}

	if($values{'HAVE_IPSEC'} ne '0') {
		my @SA = ();

		if ($values{'USE_SA1_SA2'} ne '0') {
			push @SA, 'SA1', 'SA2';
		}
		if ($values{'USE_SA3_SA4'} ne '0') {
			push @SA, 'SA3', 'SA4';
		}
		if (($values{'UNIQ_TRANS_SA'} ne '0') &&
		    ($values{'USE_SA5_SA6'} ne '0')) {
			push @SA, 'SA5', 'SA6';
		}
		if (($values{'UNIQ_TUNNEL_SA'} ne '0') &&
		    ($values{'USE_SA7_SA8'} ne '0')) {
			push @SA, 'SA7', 'SA8';
		}

		if (@SA == 0) {
			$strerror = 'parse_configuration [IPSEC]: '.
				'can\'t find valid SA (USE_SAx_SAx).';

			return($false);
		}

		foreach my $key (sort(@SA)) {
			my $USE_SAX_DES_CBC
				= $values{'USE_'. $key. '_DES_CBC'};
			my $SAX_ENC_KEY	
				= $values{$key. '_ENC_KEY'};
			my $USE_SAX_HMAC_MD5
				= $values{'USE_'. $key. '_HMAC_MD5'};
			my $SAX_HASH_KEY
				= $values{$key. '_HASH_KEY'};

			if(($USE_SAX_DES_CBC eq '0')?
				(length($SAX_ENC_KEY) != 26):
				(length($SAX_ENC_KEY) != 10)) {

				$strerror = 'parse_configuration [IPSEC]: '.
					'invalid key length -- '.
					$key. '_ENC_KEY '. $SAX_ENC_KEY;

				return($false);
			}

			if(($USE_SAX_HMAC_MD5 eq '0')?
				(length($SAX_HASH_KEY) != 22):
				(length($SAX_HASH_KEY) != 18)) {

				$strerror = 'parse_configuration [IPSEC]: '.
					'invalid key length -- '.
					$key. '_HASH_KEY '. $SAX_HASH_KEY;

				return($false);
			}
		}
	}

	return($true);
}



#--------------------------------------------------------------#
# copy_index()                                                 #
#--------------------------------------------------------------#
sub
copy_index(*$$$$$)
{
        local (*OUTPUT)	= $_[0];
        my ($src)	= $_[1];
        my ($bool)	= $_[2];
        my ($logo)	= $_[3];
        my ($fine)	= $_[4];
        my ($links)	= $_[5];

	if($opt_logo && !$logo) {
		return($true);
	}

	if($values{'FINE_GRAIN_SELECTORS'} && !$fine) {
		return($true);
	}

	local(*INPUT);

	unless(open(INPUT, $src)) {
		$strerror = "open: $src: $!";
		return($false);
	}

	while(<INPUT>) {
		chomp;

		if(($_ =~ /^#/) || ($_ =~ /^\s*$/)) {
			next;
		}

		if($_ =~ /^&/) {
			print OUTPUT $_. "\n";
			next;
		}

		if($bool || $opt_all) {
			print OUTPUT $_. $links. "\n";
			next;
		}

		print OUTPUT '&#'. $_. "\n";
        }

	close(INPUT);

	return($true);
}



#--------------------------------------------------------------#
# overwrite_config_pm()                                        #
#--------------------------------------------------------------#
sub
overwrite_config_pm($)
{
	my ($keys) = @_;

	local(*OUTPUT);

	unless(open(OUTPUT, "> $opt_config")) {
		$strerror = "open: $opt_config: $!";
		return($false);
	}

	print(OUTPUT "#!/usr/bin/perl\n");
	print(OUTPUT "\n");
	print(OUTPUT "package config;\n");
	print(OUTPUT "\n");
	print(OUTPUT "use Exporter;\n");
	print(OUTPUT "\n");
	print(OUTPUT "BEGIN {}\n");
	print(OUTPUT "END   {}\n");
	print(OUTPUT "\n");
	print(OUTPUT "\@ISA = qw(Exporter);\n");
	print(OUTPUT "\n");
	print(OUTPUT "\@EXPORT = qw(\n");

	foreach my $key (@$keys) {
		print(OUTPUT "\t\$$key\n");
	}

	print(OUTPUT ");\n");
	print(OUTPUT "\n");

	foreach my $key (@$keys) {
		print(OUTPUT "\$$key\t= $values{$key};\n");
	}

	print(OUTPUT "\n");
	print(OUTPUT "1;\n");

	close(OUTPUT);

	if(chmod(0755, $opt_config) != 1) {
		$strerror = "chmod: $opt_config: $!";
		return($false);
	}

	return($true);
}



#--------------------------------------------------------------#
# overwrite_config_def()                                       #
#--------------------------------------------------------------#
sub
overwrite_config_def($)
{
	my ($keys) = @_;

	local(*OUTPUT);

	unless(open(OUTPUT, "> $opt_packet")) {
		$strerror = "open: $opt_packet: $!";
		return($false);
	}

	print(OUTPUT "#ifndef HAVE_CONFIG_DEF\n");
	print(OUTPUT "#define HAVE_CONFIG_DEF\n");

	foreach my $key (@$keys) {
		print(OUTPUT "\n");
		print(OUTPUT "#ifndef $key\n");
		print(OUTPUT "#define $key\t$values{$key}\n");
		print(OUTPUT "#endif\t// $key\n");
	}

	print(OUTPUT "#endif\t// HAVE_CONFIG_DEF\n");

	close(OUTPUT);

	return($true);
}



#--------------------------------------------------------------#
# overwrite_index()                                            #
#--------------------------------------------------------------#
sub
overwrite_index($)
{
	my ($keys) = @_;

	local(*OUTPUT);

	my @indexes	=  ();

	unless(open(OUTPUT, "> $opt_index")) {
		$strerror = "open: $opt_index: $!";
		return($false);
	}

	################################################################
	print(OUTPUT "#\n");
	print(OUTPUT '# $Name: MIPv6_4_0_7 $'. "\n");
	print(OUTPUT "#\n");
	print(OUTPUT "\n");



	################################################################
	print(OUTPUT
		'&print:<B><FONT SIZE="+1">0. Initialization'.
			"</FONT></B>\n");

	@indexes	= (
		'./INDEX_HA_0_0_0'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			$true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	################################################################
	print(OUTPUT '&print:<B><FONT SIZE="+1">'.
		"1. Processing Mobility Headers</FONT></B>\n");

	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_1_1_3',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_1_1_1',
		'./INDEX_HA_1_1_5'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_1_1_2',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  (($values{'USE_SA1_SA2'} ne '0') ||
			   (($values{'UNIQ_TRANS_SA'} ne '0') &&
			    ($values{'USE_SA5_SA6'} ne '0')))))? $false: $true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_1_1_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  (($values{'USE_SA1_SA2'} ne '0') ||
			   (($values{'UNIQ_TRANS_SA'} ne '0') &&
			    ($values{'USE_SA5_SA6'} ne '0')))))? $false: $true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_1_1_4',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ($values{'USE_SA1_SA2'} ne '0')))? $false: $true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_1_1_7'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ($values{'USE_SA1_SA2'} ne '0')))? $false: $true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_1_1_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_1_1_9'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  (($values{'USE_SA1_SA2'} ne '0') ||
			   (($values{'UNIQ_TRANS_SA'} ne '0') &&
			    ($values{'USE_SA5_SA6'} ne '0')))))? $false: $true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_1_1_10'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ($values{'USE_SA1_SA2'} ne '0')))? $false: $true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	################################################################
	print(OUTPUT '&print:<B><FONT SIZE="+1">'.
		"2. Primary Care-of Address Registration</FONT></B>\n");

	print(OUTPUT "&print:<B>2.1. Valid Registration</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_1_1',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_1_2',
		'./INDEX_HA_2_1_14',
		'./INDEX_HA_2_1_3',
		'./INDEX_HA_2_1_4',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_1_9'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'INDEX_HA_2_1_10',
		'INDEX_HA_2_1_11'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} ne '0') &&
			 ($values{'HAVE_IPSEC'}     ne '0') &&
			 ($values{'HAVE_IKE'}       ne '0'))?  $true: $false,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_1_5',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')? $false: $true,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_1_6',
		'./INDEX_HA_2_1_15',
		'./INDEX_HA_2_1_7',
		'./INDEX_HA_2_1_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')? $false: $true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'INDEX_HA_2_1_12',
		'INDEX_HA_2_1_13'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} ne '0') &&
			 ($values{'HAVE_IPSEC'}        ne '0') &&
			 ($values{'HAVE_IKE'}          ne '0'))?  $true: $false,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>2.2. Invalid Registration</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_2_3'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} ne '0') &&
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ($values{'USE_SA1_SA2'} ne '0')))?	$true:	$false,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_2_7',
		'./INDEX_HA_2_2_13'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_2_9',
		'./INDEX_HA_2_2_10'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_2_1',
		'./INDEX_HA_2_2_2'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  (($values{'USE_SA1_SA2'} ne '0') ||
			   (($values{'UNIQ_TRANS_SA'} ne '0') &&
			    ($values{'USE_SA5_SA6'} ne '0')))))? $false: $true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_2_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} ne '0') &&
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ($values{'USE_SA1_SA2'} ne '0')))?	$true:	$false,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_2_8',
		'./INDEX_HA_2_2_14'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_2_11',
		'./INDEX_HA_2_2_12'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_2_4',
		'./INDEX_HA_2_2_5'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  (($values{'USE_SA1_SA2'} ne '0') ||
			   (($values{'UNIQ_TRANS_SA'} ne '0') &&
			    ($values{'USE_SA5_SA6'} ne '0')))))? $false: $true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>2.3. Proxy DAD Succeeded</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_3_1',
		'./INDEX_HA_2_3_2',
		'./INDEX_HA_2_3_3'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>2.4. Proxy DAD Failed</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_4_1',
		'./INDEX_HA_2_4_4',
		'./INDEX_HA_2_4_2',
		'./INDEX_HA_2_4_5',
		'./INDEX_HA_2_4_3',
		'./INDEX_HA_2_4_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>2.5. Valid Sequence Number</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_5_1',
		'./INDEX_HA_2_5_5',
		'./INDEX_HA_2_5_2'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_5_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_7_1'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_7_5'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_7_2'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_7_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_5_3',
		'./INDEX_HA_2_5_7',
		'./INDEX_HA_2_5_4'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_5_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_7_3'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_7_7'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_7_4'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_7_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>2.6. Invalid Sequence Number</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_6_1',
		'./INDEX_HA_2_6_4',
		'./INDEX_HA_2_6_2'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_6_5'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_6_3'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_6_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_1'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_4'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_2'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_5',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_3',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_2_6_7',
		'./INDEX_HA_2_6_10',
		'./INDEX_HA_2_6_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_6_11'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_6_9'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_6_12'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_7'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_10'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_11'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_9'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_2_8_12'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$false,
			$false,
			2)) {

			return($false);
		}
	}



	################################################################
	print(OUTPUT '&print:<B><FONT SIZE="+1">'.
		"3. Primary Care-of Address De-Registration</FONT></B>\n");
	print(OUTPUT "&print:<B>3.1. Valid De-Registration</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_3_1_1',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_1_6',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_1_2',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_1_7'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_1_3',
		'./INDEX_HA_3_1_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_1_4',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_1_9'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_1_5',
		'./INDEX_HA_3_1_10'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_3_1_11',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_1_12'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>3.2. Invalid De-Registration ".
		"(Not home agent for this mobile node)</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_3_2_1',
		'./INDEX_HA_3_2_6',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_2_2',
		'./INDEX_HA_3_2_7'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_2_3',
		'./INDEX_HA_3_2_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_2_4',
		'./INDEX_HA_3_2_9'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_2_5',
		'./INDEX_HA_3_2_10'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_3_2_11',
		'./INDEX_HA_3_2_12'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>3.3. Invalid De-Registration ".
		"(Sequence number out of window)</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_3_3_1',
		'./INDEX_HA_3_3_2'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_3_5',
		'./INDEX_HA_3_3_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_3_3',
		'./INDEX_HA_3_3_4'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_3_3_7',
		'./INDEX_HA_3_3_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	################################################################
	print(OUTPUT '&print:<B><FONT SIZE="+1">'.
		"4. Intercepting Packets for a Mobile Node</FONT></B>\n");
	print(OUTPUT "&print:<B>4.1. Sending Multicast NA</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_4_1_1',
		'./INDEX_HA_4_1_2'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>4.2. Proxy ND</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_4_2_1',
		'./INDEX_HA_4_2_2',
		'./INDEX_HA_4_2_13',
		'./INDEX_HA_4_2_3',

		'./INDEX_HA_4_2_4',
		'./INDEX_HA_4_2_5',
		'./INDEX_HA_4_2_14',
		'./INDEX_HA_4_2_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_4_2_7',
		'./INDEX_HA_4_2_8',
		'./INDEX_HA_4_2_15'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_4_2_9'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>4.3. Stop Proxy ND after De-Registration".
		"</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_4_4_1',
		'./INDEX_HA_4_4_2',
		'./INDEX_HA_4_4_13',
		'./INDEX_HA_4_4_3',

		'./INDEX_HA_4_4_4',
		'./INDEX_HA_4_4_5',
		'./INDEX_HA_4_4_14',
		'./INDEX_HA_4_4_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_4_4_7',
		'./INDEX_HA_4_4_8',
		'./INDEX_HA_4_4_15'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_4_4_9'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>4.4. Receiving invalid NS ".
		"(the target address has a different address scope.)</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_4_2_10',
		'./INDEX_HA_4_2_11',
		'./INDEX_HA_4_2_16'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$false,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_4_2_12'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>4.5. Receiving invalid NS ".
		"(invalid target)</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_4_3_1',
		'./INDEX_HA_4_3_2',
		'./INDEX_HA_4_3_13',
		'./INDEX_HA_4_3_3',

		'./INDEX_HA_4_3_10',
		'./INDEX_HA_4_3_11',
		'./INDEX_HA_4_3_16',
		'./INDEX_HA_4_3_12',

		'./INDEX_HA_4_3_4',
		'./INDEX_HA_4_3_5',
		'./INDEX_HA_4_3_14',
		'./INDEX_HA_4_3_6',

		'./INDEX_HA_4_3_7',
		'./INDEX_HA_4_3_8',
		'./INDEX_HA_4_3_15',
		'./INDEX_HA_4_3_9'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	################################################################
	print(OUTPUT '&print:<B><FONT SIZE="+1">'.
		"5. Processing Intercepted Packets</FONT></B>\n");
	print(OUTPUT "&print:<B>5.1. Tunneling Intercepted Packets</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_5_1_1',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_5_1_4'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_5_1_5',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_5_1_6'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>".
		"5.2. Tunneling Intercepted Packets - error handling</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_5_1_2',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 ($values{'HAVE_REAL_HOME'} eq '0'))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}

	@indexes	= (
		'./INDEX_HA_5_1_3'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ((($values{'UNIQ_TUNNEL_SA'} ne '0') &&
			    ($values{'USE_SA7_SA8'} ne '0')) ||
			   (($values{'UNIQ_TUNNEL_SA'} eq '0') &&
			    ($values{'USE_SA3_SA4'} ne '0')))))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_5_1_7'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ((($values{'UNIQ_TUNNEL_SA'} ne '0') &&
			    ($values{'USE_SA7_SA8'} ne '0')) ||
			   (($values{'UNIQ_TUNNEL_SA'} eq '0') &&
			    ($values{'USE_SA3_SA4'} ne '0')))))?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	################################################################
	print(OUTPUT '&print:<B><FONT SIZE="+1">'.
		"6. Handling Reverse Tunneled Packets</FONT></B>\n");
	print(OUTPUT "&print:<B>6.1. Valid Reverse Tunneling</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_6_1_1',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_6_1_2'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_HOME_LINK'} eq '0')?	$false:	$true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_6_1_3',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_6_1_4'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	$false:	$true,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>6.2. Invalid Reverse Tunneling</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_6_2_1'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ((($values{'UNIQ_TUNNEL_SA'} eq '0') &&
			    ($values{'USE_SA3_SA4'} ne '0')) ||
			   (($values{'UNIQ_TUNNEL_SA'} ne '0') &&
			    ($values{'USE_SA7_SA8'} ne '0')))))? $false: $true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_6_2_2'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ((($values{'UNIQ_TUNNEL_SA'} eq '0') &&
			    ($values{'USE_SA3_SA4'} ne '0')) ||
			   (($values{'UNIQ_TUNNEL_SA'} ne '0') &&
			    ($values{'USE_SA7_SA8'} ne '0')))))? $false: $true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	################################################################
	print(OUTPUT '&print:<B><FONT SIZE="+1">'.
		"7. Protecting Return Routability Packets</FONT></B>\n");
	print(OUTPUT "&print:<B>7.1. Receiving Valid RR Messages</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_6_3_1',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_RR'} eq '0'))? $false: $true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_6_3_2',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_RR'} eq '0'))? $false: $true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_6_3_3',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_RR'} eq '0'))? $false: $true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_6_3_4'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_RR'} eq '0'))? $false: $true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_6_3_5',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
				($values{'HAVE_RR'} eq '0'))? $false: $true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_6_3_6',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
				($values{'HAVE_RR'} eq '0'))? $false: $true,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_6_3_7',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
				($values{'HAVE_RR'} eq '0'))? $false: $true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_6_3_8'
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
				($values{'HAVE_RR'} eq '0'))? $false: $true,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>7.2. Receiving Invalid RR Messages</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_6_3_9',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} ne '0') &&
			 ($values{'HAVE_RR'} ne '0') &&
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ($values{'USE_SA3_SA4'} ne '0')))? $true: $false,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_6_3_10',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} ne '0') &&
			 ($values{'HAVE_RR'} ne '0') &&
			 (($values{'HAVE_IPSEC'} ne '0') &&
			  ($values{'USE_SA3_SA4'} ne '0')))? $true: $false,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	################################################################
	print(OUTPUT '&print:<B><FONT SIZE="+1">'.
		"8. Dynamic Home Agent Address Discovery</FONT></B>\n");
	print(OUTPUT '&print:<B>'.
		"8.1. Receiving Home Agent Address Discovery Request</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_7_1_1',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_DHAAD'} eq '0'))? $false: $true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_7_1_3',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_DHAAD'} eq '0'))? $false: $true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_7_1_2',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
				($values{'HAVE_DHAAD'} eq '0'))? $false: $true,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_7_1_4',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
				($values{'HAVE_DHAAD'} eq '0'))? $false: $true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	print(OUTPUT '&print:<B>'.
		"8.2. Receiving Router Advertisement Messages</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_7_2_1',
		'./INDEX_HA_7_2_9',
		'./INDEX_HA_7_2_2',
		'./INDEX_HA_7_3_1',
		'./INDEX_HA_7_3_2',
		'./INDEX_HA_7_4_1',
		'./INDEX_HA_7_4_2',
		'./INDEX_HA_7_2_10',
		'./INDEX_HA_7_2_11',
		'./INDEX_HA_7_2_12',
		'./INDEX_HA_7_2_13',
		'./INDEX_HA_7_2_15',
		'./INDEX_HA_7_2_3',
		'./INDEX_HA_7_2_4',
		'./INDEX_HA_7_2_5',
		'./INDEX_HA_7_2_6',
		'./INDEX_HA_7_2_7',
		'./INDEX_HA_7_2_8',
		'./INDEX_HA_7_2_14',
		'./INDEX_HA_7_5_1',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_DHAAD'} eq '0'))? $false: $true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	################################################################
	print(OUTPUT '&print:<B><FONT SIZE="+1">'.
		"9. Mobile Prefix Discovery</FONT></B>\n");
	print(OUTPUT '&print:<B>'.
		"9.1. Receiving Mobile Prefix Solicitation</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_8_1_1',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_MPD'} eq '0'))? $false: $true,
			$true,
			$true,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_8_1_15',
		'./INDEX_HA_8_1_7',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_MPD'} eq '0'))? $false: $true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_8_1_2',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
				($values{'HAVE_MPD'} eq '0'))? $false: $true,
			$true,
			$true,
			2)) {

			return($false);
		}
	}



	@indexes	= (
		'./INDEX_HA_8_1_16',
		'./INDEX_HA_8_1_8',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
				($values{'HAVE_MPD'} eq '0'))? $false: $true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	print(OUTPUT '&print:<B>'.
		"9.2. Receiving Invalid Mobile Prefix Solicitation</B>\n");
	print(OUTPUT "&print:<B>(1) Real Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_8_1_3',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_HOME_LINK'} eq '0') ||
				($values{'HAVE_MPD'} eq '0'))? $false: $true,
			$true,
			$false,
			($values{'HAVE_FOREIGN_LINK'} eq '0')?	1:	2)) {

			return($false);
		}
	}



	print(OUTPUT "&print:<B>(2) Virtual Home Link</B>\n");

	@indexes	= (
		'./INDEX_HA_8_1_4',
	);

	foreach my $index (@indexes) {
		unless(copy_index(*OUTPUT, $index,
			(($values{'HAVE_FOREIGN_LINK'} eq '0') ||
				($values{'HAVE_MPD'} eq '0'))? $false: $true,
			$true,
			$false,
			2)) {

			return($false);
		}
	}



	close(OUTPUT);

	return($true);
}
