#! /usr/bin/perl -w
#
# $Copyright$
#
# $TAHI: vel/interop_ph2_ipsec/make_scenario.pl,v 1.1 2007/03/06 10:58:50 doo Exp $

use POSIX qw(strftime);

BEGIN {
	use constant TRUE => 1;
	use constant FALSE => 0;
	use constant DEBUG => &FALSE # &TRUE; # 
}

END { }

my $configFile = './config.txt';
my @commandFiles = ('./command.FreeBSD.txt',
		    './command.NetBSD.txt',
		    './command.KAME.txt',
		    './command.Linux.txt',
		    './command.USAGI.txt',
		   );
my $destinationDir = strftime "%Y%m%d%H%M%S", localtime;

## YOUR DEVICE
my %logoMap =
	(
	 'ID' => 'LOGO',
	 'LOGO_TYPE' => '',
	 'LOGO_NAME' => '',
	 'LOGO_IF1' => '',
	 'LOGO_IF1_MAC' => '',
	 'LOGO_IF2' => '',
	 'LOGO_IF2_MAC' => '',

	 'LOGO_IF1_EUI-64' => '',
	 'LOGO_IF1_LLA' => '',
	 'LOGO_IF1_PREFIX1_GA' => '',
	 'LOGO_IF1_PREFIX2_GA' => '',
	 'LOGO_IF1_PREFIX3_GA' => '',
	 'LOGO_IF2_EUI-64' => '',
	 'LOGO_IF2_LLA' => '',
	 'LOGO_IF2_PREFIX2_GA' => '',
	 'LOGO_IF2_PREFIX3_GA' => '',
	);

## TARGET-1
my %tar1Map =
	(
	 'ID' => 'TAR1',
	 'TAR1_ENABLE' => '',
	 'TAR1_NAME' => '',
	 'TAR1_TYPE' => '',
	 'TAR1_TEST_MODE' => '',

	 'TAR1_IF1' => '',
	 'TAR1_IF1_MAC' => '',
	 'TAR1_IF2' => '',
	 'TAR1_IF2_MAC' => '',
	 'TAR1_IFTG' => '',
	 'TAR1_IFTG_V4_ADDR' => '',

	 'TAR1_IF1_EUI-64' => '',
	 'TAR1_IF1_LLA' => '',
	 'TAR1_IF1_PREFIX1_GA' => '',
	 'TAR1_IF1_PREFIX2_GA' => '',
	 'TAR1_IF1_PREFIX3_GA' => '',
	 'TAR1_IF1_PREFIX4_GA' => '',
	 'TAR1_IF2_EUI-64' => '',
	 'TAR1_IF2_LLA' => '',
	 'TAR1_IF2_PREFIX1_GA' => '',
	 'TAR1_IF2_PREFIX2_GA' => '',
	 'TAR1_IF2_PREFIX3_GA' => '',
	 'TAR1_IF2_PREFIX4_GA' => '',
	);
my %tar1CommandMap;

## TARGET-2
my %tar2Map =
	(
	 'ID' => 'TAR2',
	 'TAR2_ENABLE' => '',
	 'TAR2_NAME' => '',
	 'TAR2_TYPE' => '',
	 'TAR2_TEST_MODE' => '',

	 'TAR2_IF1' => '',
	 'TAR2_IF1_MAC' => '',
	 'TAR2_IF2' => '',
	 'TAR2_IF2_MAC' => '',
	 'TAR2_IFTG' => '',
	 'TAR2_IFTG_V4_ADDR' => '',

	 'TAR2_IF1_EUI-64' => '',
	 'TAR2_IF1_LLA' => '',
	 'TAR2_IF1_PREFIX1_GA' => '',
	 'TAR2_IF1_PREFIX2_GA' => '',
	 'TAR2_IF1_PREFIX3_GA' => '',
	 'TAR2_IF1_PREFIX4_GA' => '',
	 'TAR2_IF2_EUI-64' => '',
	 'TAR2_IF2_LLA' => '',
	 'TAR2_IF2_PREFIX1_GA' => '',
	 'TAR2_IF2_PREFIX2_GA' => '',
	 'TAR2_IF2_PREFIX3_GA' => '',
	 'TAR2_IF2_PREFIX4_GA' => '',
	);
my %tar2CommandMap;

## TARGET-3
my %tar3Map =
	(
	 'ID' => 'TAR3',
	 'TAR3_ENABLE' => '',
	 'TAR3_NAME' => '',
	 'TAR3_TYPE' => '',
	 'TAR3_TEST_MODE' => '',

	 'TAR3_IF1' => '',
	 'TAR3_IF1_MAC' => '',
	 'TAR3_IF2' => '',
	 'TAR3_IF2_MAC' => '',
	 'TAR3_IFTG' => '',
	 'TAR3_IFTG_V4_ADDR' => '',

	 'TAR3_IF1_EUI-64' => '',
	 'TAR3_IF1_LLA' => '',
	 'TAR3_IF1_PREFIX1_GA' => '',
	 'TAR3_IF1_PREFIX2_GA' => '',
	 'TAR3_IF1_PREFIX3_GA' => '',
	 'TAR3_IF1_PREFIX4_GA' => '',
	 'TAR3_IF2_EUI-64' => '',
	 'TAR3_IF2_LLA' => '',
	 'TAR3_IF2_PREFIX1_GA' => '',
	 'TAR3_IF2_PREFIX2_GA' => '',
	 'TAR3_IF2_PREFIX3_GA' => '',
	 'TAR3_IF2_PREFIX4_GA' => '',
	);
my %tar3CommandMap;

## TARGET-4
my %tar4Map =
	(
	 'ID' => 'TAR4',
	 'TAR4_ENABLE' => '',
	 'TAR4_NAME' => '',
	 'TAR4_TYPE' => '',
	 'TAR4_TEST_MODE' => '',

	 'TAR4_IF1' => '',
	 'TAR4_IF1_MAC' => '',
	 'TAR4_IF2' => '',
	 'TAR4_IF2_MAC' => '',
	 'TAR4_IFTG' => '',
	 'TAR4_IFTG_V4_ADDR' => '',

	 'TAR4_IF1_EUI-64' => '',
	 'TAR4_IF1_LLA' => '',
	 'TAR4_IF1_PREFIX1_GA' => '',
	 'TAR4_IF1_PREFIX2_GA' => '',
	 'TAR4_IF1_PREFIX3_GA' => '',
	 'TAR4_IF1_PREFIX4_GA' => '',
	 'TAR4_IF2_EUI-64' => '',
	 'TAR4_IF2_LLA' => '',
	 'TAR4_IF2_PREFIX1_GA' => '',
	 'TAR4_IF2_PREFIX2_GA' => '',
	 'TAR4_IF2_PREFIX3_GA' => '',
	 'TAR4_IF2_PREFIX4_GA' => '',
	);
my %tar4CommandMap;

# ref1
my %ref1Map =
	(
	 'ID' => 'REF1',
	 'REF1_ENABLE' => '',
	 'REF1_NAME' => '',
	 'REF1_IF1' => '',
	 'REF1_IF1_MAC' => '',
	 'REF1_IFTG' => '',
	 'REF1_IFTG_V4_ADDR' => '',

	 'REF1_IF1_EUI-64' => '',
	 'REF1_IF1_LLA' => '',
	 'REF1_IF1_PREFIX1_GA' => '',
	 'REF1_IF1_PREFIX2_GA' => '',
	 'REF1_IF1_PREFIX3_GA' => '',
	);
my %ref1CommandMap;

# ref2
my %ref2Map =
	(
	 'ID' => 'REF2',
	 'REF2_ENABLE' => '',
	 'REF2_NAME' => '',
	 'REF2_IF1' => '',
	 'REF2_IF1_MAC' => '',
	 'REF2_IF2' => '',
	 'REF2_IF2_MAC' => '',
	 'REF2_IFTG' => '',
	 'REF2_IFTG_V4_ADDR' => '',

	 'REF2_IF1_EUI-64' => '',
	 'REF2_IF1_LLA' => '',
	 'REF2_IF1_PREFIX1_GA' => '',
	 'REF2_IF1_PREFIX2_GA' => '',
	 'REF2_IF1_PREFIX3_GA' => '',
	 'REF2_IF2_EUI-64' => '',
	 'REF2_IF2_LLA' => '',
	 'REF2_IF2_PREFIX1_GA' => '',
	 'REF2_IF2_PREFIX2_GA' => '',
	 'REF2_IF2_PREFIX3_GA' => '',
	);
my %ref2CommandMap;

# ref3
my %ref3Map =
	(
	 'ID' => 'REF3',
	 'REF3_ENABLE' => '',
	 'REF3_NAME' => '',
	 'REF3_IF1' => '',
	 'REF3_IF1_MAC' => '',
	 'REF3_IFTG' => '',
	 'REF3_IFTG_V4_ADDR' => '',

	 'REF3_IF1_EUI-64' => '',
	 'REF3_IF1_LLA' => '',
	 'REF3_IF1_PREFIX1_GA' => '',
	 'REF3_IF1_PREFIX2_GA' => '',
	 'REF3_IF1_PREFIX3_GA' => '',
	 'REF3_IF1_PREFIX4_GA' => '',
	);
my %ref3CommandMap;

my %dumperMap =
	(
	 'ID' => 'DUMPER',
	 'DUMPER_NAME' => '',
	 'DUMPER_IF1' => '',
	 'DUMPER_IF2' => '',
	 'DUMPER_IF3' => '',
	 'DUMPER_IF4' => '',
	 'DUMPER_IFTG' => '',
	 'DUMPER_IFTG_V4_ADDR' => '',
	);
my %dumperCommandMap;

##
my %nodeMap =
	(
	 'TAR1' => \%tar1Map,
	 'TAR2' => \%tar2Map,
	 'TAR3' => \%tar3Map,
	 'TAR4' => \%tar4Map,
	 'LOGO'  => \%logoMap,
	 'DUMPER' => \%dumperMap,
	 'REF1' => \%ref1Map,
	 'REF2' => \%ref2Map,
	 'REF3' => \%ref3Map,
	);

my %nodeCommandMap =
	(
	 'TAR1' => \%tar1CommandMap,
	 'TAR2' => \%tar2CommandMap,
	 'TAR3' => \%tar3CommandMap,
	 'TAR4' => \%tar4CommandMap,
	 'DUMPER' => \%dumperCommandMap,
	 'REF1' => \%ref1CommandMap,
	 'REF2' => \%ref2CommandMap,
	 'REF3' => \%ref3CommandMap,
	);

##
my %miscMap =
	(
	 'PREFIX1' => '',
	 'PREFIX2' => '',
	 'PREFIX3' => '',
	 'PREFIX4' => '',
	 'BASENAME' => 'tg mgr',
	);

##
my %ipsecconfMap =
	(
	 'COPY_FILE_5.1.1.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.1.2.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.1.3.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.1.4.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.1.5.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.1.6.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.1.7.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.1.8.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.1.9.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.1.10.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.2.1.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.2.2.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.2.3.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.2.4.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.2.5.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.2.6.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.2.7.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.2.8.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.2.9.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.2.10.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.1.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.1.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.2.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.2.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.3.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.3.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.4.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.4.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.5.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.5.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.6.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.6.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.7.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.7.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.8.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.8.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.9.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.9.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.3.10.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.3.10.TGT_SGW1.ipsec.conf' => '',
	 'COPY_FILE_5.4.1.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.4.2.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.4.3.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.4.4.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.4.5.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.4.6.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.4.7.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.4.8.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.4.9.TGT_HOST1.ipsec.conf' => '',
	 'COPY_FILE_5.4.10.TGT_HOST1.ipsec.conf' => '',
	);

# Print Information Map includes Topology and NUT IPSec Config
my %informationMap =
	(
	 'PRINT_FILE_5.1.en.en.topology' => '',
	 'PRINT_FILE_5.2.sgw.sgw.topology' => '',
	 'PRINT_FILE_5.3.en.sgw.topology' => '',
	 'PRINT_FILE_5.3.sgw.en.topology' => '',
	 'PRINT_FILE_5.4.en.en.topology' => '',
	 'PRINT_FILE_5.1.1.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.1.2.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.1.3.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.1.4.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.1.5.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.1.6.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.1.7.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.1.8.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.1.9.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.1.10.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.1.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.2.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.3.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.4.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.5.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.6.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.7.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.8.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.9.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.2.10.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.1.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.1.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.2.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.2.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.3.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.3.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.4.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.4.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.5.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.5.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.6.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.6.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.7.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.7.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.8.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.8.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.9.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.9.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.10.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.3.10.TGT_SGW1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.1.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.2.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.3.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.4.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.5.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.6.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.7.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.8.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.9.TGT_HOST1.ipsec.conf' => '',
	 'PRINT_FILE_5.4.10.TGT_HOST1.ipsec.conf' => '',
	);

sub main();

sub configure();
sub registToNodeMap($);
sub generateAddress($);
sub mac2eui64($);
sub allocateTargetMap($);

sub makeScenario();
sub makeENScenario($$$);
sub makeSGWScenario($$$);
sub makeEnvironment();
sub makeCollectionScript();
sub makeTestScript();
sub makeDirectory($);

sub readCommand();
sub readConfiguration();
sub readPrefixFiles($);
sub readDirectory($);

sub replaceScript($$);
sub replaceNodeName($$);
sub replaceCommand();
sub replaceKeyword();
sub replaceMisc();
sub replaceIPsecConf();

main();
exit 0;
# UNREACHABLE

sub main() {
	readConfiguration();
	readCommand();
	configure();
	makeScenario();
	makeTestScript();
	makeEnvironment();
	makeCollectionScript();
}

# 
sub readConfiguration() {
	local (*INPUT);
	unless (open(INPUT, $configFile)) {
		print STDERR "open: $configFile: $!";
		return (&FALSE);
	}

	for (my $number = 1; <INPUT>; $number ++) {
		chomp;
		my $line = $_;

		# processing empty line
		if($line =~ /^\s*$/) {
			next;
		}

		# processing comment
		if($line =~ /^([^#]*)#.*$/) {
			$line = $1;
		}

		registToNodeMap($line);
	}
	close(INPUT);

	my $sep = $";
	$" = '';
	foreach my $key (keys(%ipsecconfMap)) {
		$key =~ /COPY_FILE_(\S+)/;
		my $file = $1;

		open(INPUT, $file) || die "can't open $file: $!";

		my $TEST_TAR_NAME="";
		if (($file =~ m/^5.1/) || ($file =~ m/^5.4/)) {
			$TEST_TAR_NAME="TEST-TAR-EN";
		} elsif ($file =~ m/^5.2/) {
			$TEST_TAR_NAME="TEST-TAR-SGW";
		} elsif (($file =~ m/^5.3/) && ($file =~ m/TGT_HOST1/)) {
			$TEST_TAR_NAME="TEST-TAR-SGW";
		} elsif (($file =~ m/^5.3/) && ($file =~ m/TGT_SGW1/)) {
			$TEST_TAR_NAME="TEST-TAR-EN";
		}
#		print "file=$file, Test_Tar_Name=$TEST_TAR_NAME\n";
		my @cotents = ();
		my $first_line = 1;
		foreach (<INPUT>) {
			if (/^([^#]*)#.*$/) {
				next;
			}
			chomp;
			s/([";])/\\$1/g;
			if (m/-P(\s+)/) {
				if (m/-P(\s+)in(\s+)/) {
					s/(\s+)in(\s+)/$1out$2/;
				} elsif (m/-P(\s+)out(\s+)/) {
					s/(\s+)out(\s+)/$1in$2/;
				}
			}
#			print "test1=$_\n";
			if (m/-E(\s+)null/) {
				my $null_encrypt_str=$TEST_TAR_NAME."_CMD_ENCRYPTION_ALGORITHM_NULL";
				s/-E(\s+)null/-E$1$null_encrypt_str/;
			}
#			print "test2=$_\n";
			if (m/-E(\s+)/) {
				s/-E(\s+)/\\-E\\$1/;
			}
#			print "test3=$_\n";
			if (m/-A(\s+)null/) {
				my $null_auth_str=$TEST_TAR_NAME."_CMD_AUTHENTICATION_ALGORITHM_NULL";
				s/-A(\s+)null/-A$1$null_auth_str/;
			}
#			print "test4=$_\n";

			my $line = ($first_line) ? '' : '    ';
			$line .= "execute \"/bin/sh -c echo $_";
			$line .= ($first_line) ? " > " : " >> ";
			$line .= "/tmp/ipsec.conf\";\n";
			$first_line = 0;
			push(@contents, $line);
		}

		$ipsecconfMap{$key} = "@contents";
		@contents = ();
		close(INPUT);
	}
	$" = $sep;
	
	$sep = $";
	$" = '';
	foreach my $key (keys(%informationMap)) {
		$key =~ /PRINT_FILE_(\S+)/;
		my $file = $1;

		open(INPUT, $file) || die "can't open $file: $!";

		my @cotents = ();
		$first_line = 1;
		foreach (<INPUT>) {
			chomp;
			s/([";])/\\$1/g;
			my $line = ($first_line) ? '' : '    ';
			$line .= "print \"$_\";\n";
			$first_line = 0;
			push(@contents, $line);
		}

		$informationMap{$key} = "@contents";
		@contents = ();
		close(INPUT);
	}
	$" = $sep;
}

# 
sub registToNodeMap($) {
	my ($line) = @_;

	unless ($line =~ /^\s*(\S+)\s+(\S+)\s*$/) {
		return (&FALSE);
	}

	my $key		= $1;
	my $value	= $2;

	my $target;
	if ($key =~ /([A-Z0-9\-]+)_.*/) {
		$target = $1;
	} else {
		unless (exists $miscMap{$key}) {
			print STDERR "misc map doesn't have key: $key :$!";
			return (&FALSE);
		}

		$miscMap{$key} = $value;
		return (&TRUE);
	}

	unless (exists $nodeMap{$target}->{$key}) {
		print STDERR "target map doesn't have key: $key :$!";
		return (&FALSE);
	}

	if ($value eq 'YES') {
		$value = &TRUE;
	}
	elsif ($value eq 'NO') {
		$value = &FALSE;
	}

	$nodeMap{$target}->{$key} = $value;
	if ($key =~ /\w*NAME/ && $target ne 'LOGO') {
		$nodeCommandMap{$target}->{$key} = $value;
	}


	return (&TRUE)
}

# 
sub configure() {
	foreach my $node (keys(%nodeMap)) {
		if ($node eq 'DUMPER') {
			next;
		}

		generateAddress($node);
	}
}

# 
sub generateAddress($) {
	my ($node) = @_;

	my @ifList = ('IF1', 'IF2', 'IF3',);
	my %scopeMap = ('LLA' => 'fe80::',
			'PREFIX1_GA' => $miscMap{'PREFIX1'}.':',
			'PREFIX2_GA' => $miscMap{'PREFIX2'}.':',
			'PREFIX3_GA' => $miscMap{'PREFIX3'}.':',
			'PREFIX4_GA' => $miscMap{'PREFIX4'}.':',
		       );

	foreach my $if (@ifList) {
		# generate EUI-64
		my $eui64 = $node.'_'.$if.'_EUI-64';
		my $mac = $node.'_'.$if.'_MAC';

		unless (exists $nodeMap{$node}->{$mac}) {
			next;
		}
		unless (exists $nodeMap{$node}->{$eui64}) {
			next;
		}

		$nodeMap{$node}->{$eui64} = mac2eui64($nodeMap{$node}->{$mac});

		# generate LLA and GA
		foreach my $scope (keys(%scopeMap)) {
			my $address = $node.'_'.$if.'_'.$scope;

			unless (exists $nodeMap{$node}->{$address}) {
				next;
			}

			$nodeMap{$node}->{$address} = $scopeMap{$scope}.$nodeMap{$node}->{$eui64};
		}

		# generate static GA address
		{
			my $address = $node.'_'.$if.'_'.'PREFIX1_GA_F';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX1'}.'::f';
			$address = $node.'_'.$if.'_'.'PREFIX2_GA_F';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX2'}.'::f';
			$address = $node.'_'.$if.'_'.'PREFIX2_GA_E';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX2'}.'::e';
			$address = $node.'_'.$if.'_'.'PREFIX3_GA_E';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX3'}.'::e';
			$address = $node.'_'.$if.'_'.'PREFIX3_GA_D';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX3'}.'::d';
			$address = $node.'_'.$if.'_'.'PREFIX4_GA_D';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX4'}.'::d';
			$address = $node.'_'.$if.'_'.'PREFIX1_GA_2';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX1'}.'::2';
			$address = $node.'_'.$if.'_'.'PREFIX2_GA_2';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX2'}.'::2';
			$address = $node.'_'.$if.'_'.'PREFIX3_GA_2';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX3'}.'::2';
			$address = $node.'_'.$if.'_'.'PREFIX4_GA_2';
			$nodeMap{$node}->{$address} = $miscMap{'PREFIX4'}.'::2';
		}
	}
}

# 
sub mac2eui64($) {
	my ($mac) = @_;

	my @bytesList = split(/:/, $mac);

	my $result = sprintf "%02x", hex(shift(@bytesList)) | 0x2;

	my $i = 0;
	foreach my $bytes (@bytesList) {
		my $delim = ($i == 2) ? 'ff:fe' : '';
		$delim .= (($i++ % 2) == 0) ? '' : ':';
		$result = join($delim, $result, $bytes)
	}
	return $result;
}

# 
sub readCommand() {
	foreach my $node (keys(%nodeCommandMap)) {
		my $commandFile = "./command.$nodeCommandMap{$node}->{$node.'_NAME'}.txt";

		local (*INPUT);
		unless (open(INPUT, $commandFile)) {
			print STDERR "open $commandFile: $!";
			return (&FALSE);
		}

		for (my $number=1; <INPUT>; $number ++) {
			chomp;
			my $line = $_;

			# processing comment
			if ($line =~ /^#/) {
				next;
			}
			# processing empty line
			if ($line =~ /^\s*$/) {
				next;
			}

			if ($line =~ /^\s*(\S+)\s+(.+)$/) {
				my $key = $1;
				my $value = $2;
				chomp $value;
#				print "key=$key, value=$value...\n";
				$value =~ s/MY/$node/g;
				$nodeCommandMap{$node}->{$node.'_'.$key} = $value;
			}
		}

		close(INPUT);
	}
	return (&TRUE);
}

sub makeScenario() {
	## 
	my %targetMap =
		(
		 'TAREN1' => '',
		 'TAREN2' => '',
		 'TARSGW1' => '',
		 'TARSGW2' => '',
		);

	unless (allocateTargetMap(\%targetMap)) {
		return (&FALSE);
	}

	unless (makeDirectory($destinationDir)) {
		return(&FALSE);
	}

	## set TEST TARGET
	$| = &TRUE;
	foreach my $target (sort(keys(%targetMap))) {
		my $enable = $targetMap{$target}->{$targetMap{$target}->{'ID'}.'_ENABLE'};

		next unless ($enable);

		my $type = $targetMap{$target}->{$targetMap{$target}->{'ID'}.'_TYPE'};
		my $mode = $targetMap{$target}->{$targetMap{$target}->{'ID'}.'_TEST_MODE'};

		if ($type eq 'en') {
			makeENScenario($target, $mode, \%targetMap);
		}
		elsif ($type eq 'sgw') {
			makeSGWScenario($target, $mode, \%targetMap);
		}
	}
	$| = &FALSE;
}

sub allocateTargetMap($) {
	my ($targetMap) = @_;

	my $numEN = 0, $numSGW = 0;
	foreach my $node (sort(keys(%nodeMap))) {
		unless ($node =~ /TAR\d/) {
			next;
		}

		my $targetType = $nodeMap{$node}->{$node.'_TYPE'};
		my $target;
		if ($targetType eq 'en') {
			if (++$numEN gt 2) {
				print STDERR "the number of TYPE=en" .
					" is just two. $numEN\n";
				return (&FALSE);
			}
			$target = 'TAREN'.$numEN;
		}
		elsif ($targetType eq 'sgw') {
			if (++$numSGW gt 2) {
				print STDERR "the number of TYPE=sgw" .
					" is just two. $numSGW\n";
				return (&FALSE);
			}
			$target = 'TARSGW'.$numSGW;
		}
		else {
			print STDERR "the number of TYPE=sgw is just two.\n";
			return (&FALSE);
		}

		$targetMap->{$target} = $nodeMap{$node};
	}

	return (&TRUE);
}

## 
sub makeENScenario($$$) {
	my ($target, $mode, $targetMap) = @_;
	my %nodeNameMap = (
			   'TEST-TAR-EN' => $target,
			   'NOTEST-TAR-EN' => '',
			   'NOTEST-TAR-SGW1' => '',
			   'NOTEST-TAR-SGW2' => '',
			  );

	my $numSGW = 0;
	foreach my $tar (sort(keys(%$targetMap))) {
		if ($targetMap->{$target} eq $targetMap->{$tar}) {
			next;
		}

		my $type = $targetMap->{$tar}->{$targetMap->{$tar}->{'ID'}.'_TYPE'};
		if ($type eq 'en') {
			$nodeNameMap{'NOTEST-TAR-EN'} = $tar;
		} else {
			$numSGW++;
			$nodeNameMap{"NOTEST-TAR-SGW$numSGW"} = $tar;
		}
	}

	my $sourcePrefix = '\d\.\d\.\d+\.'.$logoMap{'LOGO_TYPE'}.'.en.'.$mode;
	my $files = readPrefixFiles($sourcePrefix);
        $sourcePrefix = '\d\.\d\.'.$logoMap{'LOGO_TYPE'}.'.en.'.$mode;
        my $files_cleanup = readPrefixFiles($sourcePrefix);
        push @{$files}, @{$files_cleanup};

	my $id = $targetMap->{$target}->{'ID'};
	my $name = $nodeMap{$id}->{$id.'_NAME'};
	my $dir = "$destinationDir/en.$name";
	print "en.$name (".@$files." tests): ";
	unless (makeDirectory($dir)) {
		return (&FALSE);
	}

	open(PERL, ">replace.pl") || die;
	print PERL ("\$dir = shift(\@ARGV); foreach (\@ARGV) {\n");
	print PERL ("\topen(IN, \"<\$_\") or next;\n");
	print PERL ("\topen(OUT, \">\$dir/\$_\") or next;\n");
	print PERL ("\twhile(<IN>) {\n");
	print PERL ("\t\t", replaceIPsecConf());
	print PERL ("\t\t", replaceNodeName(\%nodeNameMap, $targetMap));
	print PERL ("\t\t", replaceCommand());
	print PERL ("\t\t", replaceKeyword());
	print PERL ("\t\t", replaceMisc());
	print PERL ("\t\t", replaceInformation());
	print PERL ("\t\tprint OUT;\n");
	print PERL ("\t}\n");
	print PERL ("\tclose(IN); close(OUT);\n");
	print PERL ("}\n");
	print PERL ("exit(0);\n");
	close(PERL);
#	system('cat', 'replace.pl');
	system('perl', 'replace.pl', $dir, @$files);
	
	print "done\n";
	unlink("replace.pl");

	return (&TRUE);
}

## 
sub makeSGWScenario($$$) {
	my ($target, $mode, $targetMap) = @_;
	my %nodeNameMap =
		(
		 'TEST-TAR-SGW' => $target,
		 'NOTEST-TAR-SGW' => '',
		 'NOTEST-TAR-EN1' => '',
		 'NOTEST-TAR-EN2' => '',
		);

	my $numEN = 0;
	foreach my $tar (sort(keys(%$targetMap))) {
		if ($targetMap->{$target} eq $targetMap->{$tar}) {
			next;
		}

		my $type = $targetMap->{$tar}->{$targetMap->{$tar}->{'ID'}.'_TYPE'};
		if ($type eq 'en') {
			$numEN++;
			$nodeNameMap{"NOTEST-TAR-EN$numEN"} = $tar;
		} else {
			$nodeNameMap{'NOTEST-TAR-SGW'} = $tar;
		}
	}

	my $sourcePrefix = '\d\.\d\.\d+\.'.$logoMap{'LOGO_TYPE'}.'.sgw.'.$mode;
	my $files = readPrefixFiles($sourcePrefix);

        $sourcePrefix = '\d\.\d\.'.$logoMap{'LOGO_TYPE'}.'.sgw.'.$mode;
        my $files_cleanup = readPrefixFiles($sourcePrefix);
        push @{$files}, @{$files_cleanup};

	my $id = $targetMap->{$target}->{'ID'};
	my $name = $nodeMap{$id}->{$id.'_NAME'};
	my $dir = "$destinationDir/sgw.$name";
	print "sgw.$name (".@$files." tests): ";
	unless (makeDirectory($dir)) {
		return (&FALSE);
	}

	open(PERL, ">replace.pl") || die;
	print PERL ("\$dir = shift(\@ARGV); foreach (\@ARGV) {\n");
	print PERL ("\topen(IN, \"<\$_\") or next;\n");
	print PERL ("\topen(OUT, \">\$dir/\$_\") or next;\n");
	print PERL ("\twhile(<IN>) {\n");
	print PERL ("\t\t", replaceIPsecConf());
	print PERL ("\t\t", replaceNodeName(\%nodeNameMap, $targetMap));
	print PERL ("\t\t", replaceCommand());
	print PERL ("\t\t", replaceKeyword());
	print PERL ("\t\t", replaceMisc());
	print PERL ("\t\t", replaceInformation());
	print PERL ("\t\tprint OUT;\n");
	print PERL ("\t}\n");
	print PERL ("\tclose(IN); close(OUT);\n");
	print PERL ("}\n");
	print PERL ("exit(0);\n");
	close(PERL);

#	system('cat', 'replace.pl');
	system('perl', 'replace.pl', $dir, @$files);

	print "done\n";
	unlink("replace.pl");

	return (&TRUE);
}

# 
sub makeDirectory($) {
	my ($dir) = @_;
	unless (mkdir($dir, 0755)) {
		print STDERR "$dir: $!\n";
		return(&FALSE);
	}
	return(&TRUE);
}

#
sub readPrefixFiles($) {
	my ($prefix) = @_;
	my $files = readDirectory('.');
	my @result;
	foreach my $file (@$files) {
		if($file =~ /^$prefix.*$/) {
			push @result, $file;
		}
	}
	@result = sort { lc($a) cmp lc($b) } @result;
	return \@result;
}
#
sub readDirectory($) {
	my ($dir) = @_;
	opendir(DIR, $dir) || die "can't opendir $dir: $!";

	my @result;
	while (defined($file = readdir(DIR))) {
		if ($file eq '.' || $file eq '..') {
			next;
		}
		push @result, $file;
	}
    closedir DIR;
	return \@result;
}

##
sub replaceScript($$) {
	my ($key, $value) = @_;
	$key =~ s/([\\\/])/\\$1/g;
	$value =~ s/([\\\/])/\\$1/g;
	return "s/$key/$value/g;\n";
}

sub replaceNodeName($$) {
	my ($nodeNameMap, $targetMap) = @_;
	my @x = ();
	foreach my $key (sort(keys(%$nodeNameMap))) {
                push(@x, replaceScript($key, $targetMap->{$nodeNameMap->{$key}}->{'ID'}));
	}
	return @x;
}

sub replaceCommand() {
	my @x = ();
	foreach my $node (keys(%nodeCommandMap)) {
		my $map = $nodeCommandMap{$node};
		foreach my $key (keys(%$map)) {
#			print "Command $key=$map->{$key}....\n";
			push(@x, replaceScript($key, $map->{$key}));
		}
	}
	return @x;
}

##
sub replaceKeyword() {
	my @x = ();
	foreach my $node (keys(%nodeMap)) {
		my $map = $nodeMap{$node};
		foreach my $key (sort {$b cmp $a} (keys(%$map))) {
			push(@x, replaceScript($key, $map->{$key}));
		}
	}
	return @x;
}

##
sub replaceMisc() {
	my @x = ();
	foreach my $key (keys(%miscMap)) {
		push(@x, replaceScript($key, $miscMap{$key}));
	}
	return @x;
}

#
sub replaceIPsecConf()
{
	my @x = ();
	foreach my $key (keys(%ipsecconfMap)) {
		push(@x, replaceScript($key, $ipsecconfMap{$key}));
	}
	return @x;
}

#
sub replaceInformation()
{
	my @x = ();
	foreach my $key (keys(%informationMap)) {
		push(@x, replaceScript($key, $informationMap{$key}));
	}
	return @x;
}

# 
sub makeEnvironment() {
	local (*OUTPUT);

	my $outputFile = "> $destinationDir/environment.def";
	unless (open(OUTPUT, $outputFile)) {
		print STDERR "open: $outputFile: $!";
		return (&FALSE);
	}

	# TAR1
	if ($tar1Map{'TAR1_ENABLE'}) {
		print(OUTPUT "host $tar1Map{'ID'} {\n");
		## interface loopback
		print(OUTPUT "    interface lo0 {\n");
		print(OUTPUT "        ipv4 v4loop     \"127.0.0.1\";\n");
		print(OUTPUT "        ipv6 v6loop     \"::1\";\n");
		print(OUTPUT "        ipv6 v6linkloop \"fe80::1\";\n");
		print(OUTPUT "    }\n\n");
		## interface for tg
		print(OUTPUT "    interface $tar1Map{'TAR1_IFTG'} {\n");
		print(OUTPUT "        ipv4 v4$tar1Map{'TAR1_IFTG'} \"$tar1Map{'TAR1_IFTG_V4_ADDR'}\";\n");
		print(OUTPUT "    }\n\n");
		## tgagent
		print(OUTPUT "    tgagent v4$tar1Map{'TAR1_IFTG'} 20001;\n}\n\n");
	}

	# TAR2
	if ($tar2Map{'TAR2_ENABLE'}) {
		print(OUTPUT "host $tar2Map{'ID'} {\n");
		## interface loopback
		print(OUTPUT "    interface lo0 {\n");
		print(OUTPUT "        ipv4 v4loop     \"127.0.0.1\";\n");
		print(OUTPUT "        ipv6 v6loop     \"::1\";\n");
		print(OUTPUT "        ipv6 v6linkloop \"fe80::1\";\n");
		print(OUTPUT "    }\n\n");
		## interface for tg
		print(OUTPUT "    interface $tar2Map{'TAR2_IFTG'} {\n");
		print(OUTPUT "        ipv4 v4$tar2Map{'TAR2_IFTG'} \"$tar2Map{'TAR2_IFTG_V4_ADDR'}\";\n");
		print(OUTPUT "    }\n\n");
		## tgagent
		print(OUTPUT "    tgagent v4$tar2Map{'TAR2_IFTG'} 20001;\n}\n\n");
	}

	# TAR3
	if ($tar3Map{'TAR3_ENABLE'}) {
		print(OUTPUT "host $tar3Map{'ID'} {\n");
		## interface loopback
		print(OUTPUT "    interface lo0 {\n");
		print(OUTPUT "        ipv4 v4loop     \"127.0.0.1\";\n");
		print(OUTPUT "        ipv6 v6loop     \"::1\";\n");
		print(OUTPUT "        ipv6 v6linkloop \"fe80::1\";\n");
		print(OUTPUT "    }\n\n");
		## interface for tg
		print(OUTPUT "    interface $tar3Map{'TAR3_IFTG'} {\n");
		print(OUTPUT "        ipv4 v4$tar3Map{'TAR3_IFTG'} \"$tar3Map{'TAR3_IFTG_V4_ADDR'}\";\n");
		print(OUTPUT "    }\n\n");
		## tgagent
		print(OUTPUT "    tgagent v4$tar3Map{'TAR3_IFTG'} 20001;\n}\n\n");
	}

	# TAR4
	if ($tar4Map{'TAR4_ENABLE'}) {
		print(OUTPUT "host $tar4Map{'ID'} {\n");
		## interface loopback
		print(OUTPUT "    interface lo0 {\n");
		print(OUTPUT "        ipv4 v4loop     \"127.0.0.1\";\n");
		print(OUTPUT "        ipv6 v6loop     \"::1\";\n");
		print(OUTPUT "        ipv6 v6linkloop \"fe80::1\";\n");
		print(OUTPUT "    }\n\n");
		## interface for tg
		print(OUTPUT "    interface $tar4Map{'TAR4_IFTG'} {\n");
		print(OUTPUT "        ipv4 v4$tar4Map{'TAR4_IFTG'} \"$tar4Map{'TAR4_IFTG_V4_ADDR'}\";\n");
		print(OUTPUT "    }\n\n");
		## tgagent
		print(OUTPUT "    tgagent v4$tar4Map{'TAR4_IFTG'} 20001;\n}\n\n");
	}

	# REF1
	if ($ref1Map{'REF1_ENABLE'}) {
		print(OUTPUT "host $ref1Map{'ID'} {\n");
	## interface loopback
		print(OUTPUT "    interface lo0 {\n");
		print(OUTPUT "        ipv4 v4loop     \"127.0.0.1\";\n");
		print(OUTPUT "        ipv6 v6loop     \"::1\";\n");
		print(OUTPUT "        ipv6 v6linkloop \"fe80::1\";\n");
		print(OUTPUT "    }\n\n");
		## interface for tg
		print(OUTPUT "    interface $ref1Map{'REF1_IFTG'} {\n");
		print(OUTPUT "        ipv4 v4$ref1Map{'REF1_IFTG'} \"$ref1Map{'REF1_IFTG_V4_ADDR'}\";\n");
		print(OUTPUT "    }\n\n");
		## tgagent
		print(OUTPUT "    tgagent v4$ref1Map{'REF1_IFTG'} 20001;\n}\n\n");
	}

	# REF2
	if ($ref2Map{'REF2_ENABLE'}) {
		print(OUTPUT "host $ref2Map{'ID'} {\n");
	## interface loopback
		print(OUTPUT "    interface lo0 {\n");
		print(OUTPUT "        ipv4 v4loop     \"127.0.0.1\";\n");
		print(OUTPUT "        ipv6 v6loop     \"::1\";\n");
		print(OUTPUT "        ipv6 v6linkloop \"fe80::1\";\n");
		print(OUTPUT "    }\n\n");
		## interface for tg
		print(OUTPUT "    interface $ref2Map{'REF2_IFTG'} {\n");
		print(OUTPUT "        ipv4 v4$ref2Map{'REF2_IFTG'} \"$ref2Map{'REF2_IFTG_V4_ADDR'}\";\n");
		print(OUTPUT "    }\n\n");
		## tgagent
		print(OUTPUT "    tgagent v4$ref2Map{'REF2_IFTG'} 20001;\n}\n\n");
	}

	# REF3
	if ($ref3Map{'REF3_ENABLE'}) {
		print(OUTPUT "host $ref3Map{'ID'} {\n");
		## interface loopback
		print(OUTPUT "    interface lo0 {\n");
		print(OUTPUT "        ipv4 v4loop     \"127.0.0.1\";\n");
		print(OUTPUT "        ipv6 v6loop     \"::1\";\n");
		print(OUTPUT "        ipv6 v6linkloop \"fe80::1\";\n");
		print(OUTPUT "    }\n\n");
		## interface for tg
		print(OUTPUT "    interface $ref3Map{'REF3_IFTG'} {\n");
		print(OUTPUT "        ipv4 v4$ref3Map{'REF3_IFTG'} \"$ref3Map{'REF3_IFTG_V4_ADDR'}\";\n");
		print(OUTPUT "    }\n\n");
		## tgagent
		print(OUTPUT "    tgagent v4$ref3Map{'REF3_IFTG'} 20001;\n}\n\n");
	}

	# DUMPER
	print(OUTPUT "host $dumperMap{'ID'} {\n");
	## interface loopback
	print(OUTPUT "    interface lo0 {\n");
	print(OUTPUT "        ipv4 v4loop     \"127.0.0.1\";\n");
	print(OUTPUT "        ipv6 v6loop     \"::1\";\n");
	print(OUTPUT "        ipv6 v6linkloop \"fe80::1\";\n");
	print(OUTPUT "    }\n\n");
	## interface for tg
	print(OUTPUT "    interface $dumperMap{'DUMPER_IFTG'} {\n");
	print(OUTPUT "        ipv4 v4$dumperMap{'DUMPER_IFTG'} \"$dumperMap{'DUMPER_IFTG_V4_ADDR'}\";\n");
	print(OUTPUT "    }\n\n");
	## tgagent
	print(OUTPUT "    tgagent v4$dumperMap{'DUMPER_IFTG'} 20001;\n}\n\n");

	close (OUTPUT);
	return (&TRUE);
}

#
sub makeCollectionScript() {
	@tgAddrList = ($tar1Map{'TAR1_IFTG_V4_ADDR'},
				   $tar2Map{'TAR2_IFTG_V4_ADDR'},
				   $tar3Map{'TAR3_IFTG_V4_ADDR'},
				   $tar4Map{'TAR4_IFTG_V4_ADDR'},
				   $ref1Map{'REF1_IFTG_V4_ADDR'},
				   $ref2Map{'REF2_IFTG_V4_ADDR'},
				   $ref3Map{'REF3_IFTG_V4_ADDR'},
				   $dumperMap{'DUMPER_IFTG_V4_ADDR'},
				   );

	local(*OUTPUT);
	my $outputFile = "> $destinationDir/collect_result.sh";
	unless (open(OUTPUT, $outputFile)) {
		print STDERR "open: $outputFile: $!";
		return (&FALSE);
	}
	print(OUTPUT "#!/bin/sh\n");

	foreach my $addr (@tgAddrList) {
		print(OUTPUT 'scp -r $1@');
		print(OUTPUT "$addr:/tmp/5.* .\n");
	}

	close(OUTPUT);
	my $mode = 0755;
	chmod $mode, "$destinationDir/collect_result.sh";
	return (&TRUE);
}

# 
sub makeTestScript() {
	local(*OUTPUT);
	my $testDirs = readDirectory($destinationDir);
	foreach my $dir (@$testDirs) {
		my $outputFile = "> $destinationDir/test.$dir.sh";
		unless (open(OUTPUT, $outputFile)) {
			print STDERR "open: $outputFile: $!";
			return (&FALSE);
		}
		print(OUTPUT "#!/bin/sh\n");

		my $tests = readDirectory("$destinationDir/$dir");
		foreach my $test (@$tests) {
			print(OUTPUT "/usr/local/vel/bin/velm -e environment.def -s $dir/$test interop\n");
		}
		close (OUTPUT);
	}

	my $outputFile = "> $destinationDir/test.sh";
	my $mode = 0755;
	unless (open(OUTPUT, $outputFile)) {
		print STDERR "open: $outputFile: $!";
		return (&FALSE);
	}
	chmod $mode, "$destinationDir/test.sh";
	print(OUTPUT "#!/bin/sh\n");
	foreach my $dir (@$testDirs) {
		print(OUTPUT "./test.$dir.sh\n");
		chmod $mode, "$destinationDir/test.$dir.sh";
	}
	close(OUTPUT);

	return (&TRUE);
}
