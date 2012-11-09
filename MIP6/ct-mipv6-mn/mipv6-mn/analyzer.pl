#!/usr/bin/perl
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

use File::Basename;
use Config;

sub usage();
sub parseArgs();
sub parseIndex();
sub setKeyword();
sub getDateString();
sub getStatus($);
sub execScript($$$$$);
sub printHeader();
sub printTitle($);
sub printINDEX();
sub printSummary();
sub printFooter();
sub printResult();
sub printReport();
sub printComment();
sub printTableData($;$$);

$|=1;
parseArgs();

if ($opt_h) {
	usage();
	exit 0;
}

if (! -e $Input) {
	print "Error : Not found $Input.\n";
	exit 2;
}

$SIG{INT} = sub {exit 2;};

# get signal name & number
my %sig_num;
my @sig_name;
unless($Config{sig_name} && $Config{sig_num}) {
	die "No sigs?";
} else {
	my @names = split ' ', $Config{sig_name};
	my @num = split ' ', $Config{sig_num};
	@sig_num{@names} = @num;
	foreach (@names) {
		$sig_name[$sig_num{$_}] ||= $_;
	}
}

$StartTime=getDateString();
$ARGV[0]="INDEX" if($#ARGV == -1);
@INDEX=@ARGV;

parseIndex();

my $num;
my $unexpect = 0;
my $unexpectno = "";
my $unexpectnold = 0;
my $ToolVersionFlag = 0;
my $TargetNameFlag = 0;

setKeyword();

for($num=1;$status[$num]{type};$num++) {
	local (*current)=$status[$num];
	next if($current{type} ne "DO");
	my $rc;

	print "== Generate HTML Document from $current{script} == ($current{number})\n";
	$rc=execScript( $current{script},
			$current{packet},
			$current{opt},
			$current{log},
			$current{desc});
	$current{status}=$rc;
	$current{type}="DOTEST";

	$statusStr=getStatus($rc);
	$statusStr =~ s/<.*?>//g;
	print "  -> $statusStr\n";

#	last if(($rc>>8) == 64 || $rc == $sig_num{INT});
}

$EndTime=getDateString();
0;

END {
	printReport()
}

sub setKeyword(){

	$keyunpac="unexpect packet";

	$key1del = "<B><FONT COLOR=\"#FF0000\"><BR><BR><BR><BR><BR><\/FONT><\/B><BR>";
	$key2del = "<B><FONT COLOR=\"#FF0000\">----------------------------------------------------------------------<\/FONT><\/B><BR>";
	$key3del = "<B><FONT COLOR=\"#FF0000\"><B>        End of TEST: NUT return Home Link.<\/B><\/FONT><\/B><BR>";
	$key4del = "<B><FONT COLOR=\"#FF0000\"><B>                     It is unrelated to the judgment at the following.<\/B><\/FONT><\/B><BR>";
#	$key5del = "<B><FONT COLOR=\"#FF0000\">----------------------------------------------------------------------<\/FONT><\/B><BR>";
#	$key6del = "<B><FONT COLOR=\"#FF0000\"><BR><BR><BR><BR><BR><\/FONT><\/B><BR>";

}

sub parseIndex(){
	my $testnum=1;
	my $num;
	for($num=1;<>;$num++) {
		chomp;
		$status[$num]{type}="";
		local (*current)=$status[$num];
#		print "$num($testnum) -- $_\n";
		$VERTESTS = $2 if( /\$(Name): (.*) \$/ );
		if(/^\s*$/ || /^#/) { # remove comment
			$current{type}="COMMENT";
			next;
		}

		if(/^&print:(.*)/){ # print comment
			$current{type}="PRINT";
			$current{strings}="$1";
			next;
		}

		if(/^&pause:(.*)/){ # make pause
			$current{type}="PAUSE";
			$current{strings}="$1";
			next;
		}

		if($StartNum > $testnum || $testnum > $EndNum || /^&\#/ ) {
			s/^&\#//;
			$current{type}="SKIP";
			$current{status}= 73 << 8;
			$skip ++;
		}
		else {
			$current{type}="DO";
			$current{status}= 72 << 8;
		}

		my ($script,$packet,$opt,$doc,$desc,$links) = split ':';
		($script) = ( $script =~ /^\s*(\S*)\s*$/  );
		($packet) = ( $packet =~ /^\s*(\S*)\s*$/  );
		($doc)    = ( $doc    =~ /^\s*(\S*)\s*$/  );
		($desc)   = ( $desc   =~ /^\s*(.*\S)\s*$/ );
		($links)  = ( $links  =~ /^\s*(\S*)\s*$/  );
		my ($SeqName,$SeqDir,$SeqSuffix) = fileparse($script,'.seq');
		$desc||=$SeqName;
		$current{number}=$testnum;
		$current{script}=$script;
		$current{packet}=$packet;
		$current{opt}=$opt;
		$current{log}="$testnum.html";
		$current{desc}=$desc;
		$current{SeqName}=$SeqName;
		$current{SeqDir}=$SeqDir;
		$current{doc}=$doc;
		$current{links}=$links ? $links : 1;
		$testnum++;
		$total ++;
	}
	$VERTESTS = "undefined" if(!$VERTESTS);
}


#
# Generate Report Index
#
sub printReport() {

	open LOG ,">$Output";

	printHeader();

	printTitle(LOG);
	printSummary();
	printINDEX();
	printCONFIG();
	print LOG "<HR>\n";

	printResult();
	printFooter();
	close LOG;

	return;
}

sub printHeader() {
	print LOG <<ECHO;
<HTML>
<HEAD>
<TITLE>IPv6 Test Commentaries</TITLE>
<META NAME="GENERATOR" CONTENT="TAHI IPv6 Conformance Test Suite">
</HEAD>
<BODY BGCOLOR="#FFFFFF">
ECHO
}

sub printTitle($){
	my($fd) = @_;

	print $fd <<ECHO;
<CENTER>
<H1>$Title</H1>
</CENTER>
<HR>
<TABLE>
<TR><TD>Tool Version</TD><TD>:</TD><TD>$VERTOOLS</TD></TR>
<TR><TD>Test Program Version</TD><TD>:</TD><TD>$VERTESTS</TD></TR>
<TR><TD>TargetName</TD><TD>:</TD><TD>$TargetName</TD></TR>
<TR><TD>Date</TD><TD>:</TD><TD>$StartTime</TD></TR>
</TABLE>
ECHO
}

sub printINDEX(){
	#
	# Output Test Report Index
	#
#	print LOG "INDEX: ";
	foreach(@INDEX) {
		print LOG "<A HREF=\"$_\">$_</A> ";
	}
}

sub printCONFIG(){
	#
	# Output Test config.txt
	#
	print LOG "<A HREF=\"config.txt\">config.txt</A> ";
}

sub printResult(){
	#
	# print result table
	#
	my @color = ('#EEEEEE', '#DDDDDD');
	my $flag = 0;
 
	if(!$opt_nobkg) {
		print LOG "<CENTER>";
	}

	if($opt_nolog) {
	print LOG <<ECHO;
<TABLE WIDTH="100%" BORDER=1>
<TR BGCOLOR=\"#CCCCCC\">
<TH>No.</TH><TH>Title</TH><TH>Result</TH><TH>Comments</TH>
ECHO
}
	else {
	print LOG <<ECHO;
<TABLE WIDTH="100%" BORDER=1>
<TR BGCOLOR=\"#CCCCCC\">
<TH>No.</TH><TH>Title</TH><TH>Result</TH><TH>Log</TH><TH>Script</TH><TH>Comments</TH>
ECHO
}
	print LOG "</TR>\n";
	my $num;
	for($num=1;$status[$num]{type};$num++) {
		local (*current)=$status[$num];
		if ($current{type} eq "DOTEST" || $current{type} eq "DO") {
			if(!$opt_nobkg) {
				print LOG "<TR BGCOLOR=\"@color[$flag]\">\n";

				if($flag != 0) {
					$flag = 0;
				} else {
					$flag = 1;
				}
			} else {
				print LOG "<TR>\n";
			}

			$htmldoc = $current{doc} ? $current{doc} :
					"$current{SeqDir}$current{SeqName}.html";
#			$htmldoc = "" if(! -r $htmldoc);
			printTableData("$current{number}");
			printTableData("$current{desc}",$htmldoc);

			$statusStr=getStatus($current{status});
			printTableData("$statusStr","","ALIGN=\"CENTER\"");
			if(!$opt_nolog) {
				printTableData("X","$current{log}","ALIGN=\"CENTER\"");
				printTableData("X","$current{script}","ALIGN=\"CENTER\"");
			}
			if ($current{zhang}) {
				printTableData("$current{zhang}");
			}
			else {
				printTableData("<BR>");
			}

			print LOG "</TR>\n";
		}
		elsif ($current{type} eq "SKIP" ) {
			if(!$opt_nobkg) {
				print LOG "<TR BGCOLOR=\"@color[$flag]\">\n";

				if($flag != 0) {
					$flag = 0;
				} else {
					$flag = 1;
				}
			} else {
				print LOG "<TR>\n";
			}

			$htmldoc = $current{doc} ? $current{doc} :
					"$current{SeqDir}$current{SeqName}.html";
#			$htmldoc = "" if(! -r $htmldoc);
			printTableData("$current{number}");
			printTableData("$current{desc}",$htmldoc);

			$statusStr=getStatus($current{status});
			printTableData("$statusStr","","ALIGN=\"CENTER\"");
			if(!$opt_nolog) {
				printTableData("X","$current{log}","ALIGN=\"CENTER\"");
				printTableData("X","$current{script}","ALIGN=\"CENTER\"");
			}
			printTableData("-","","ALIGN=\"CENTER\"");

			print LOG "</TR>\n";
		}
		elsif ($status[$num]{type} eq "PRINT") {
			print LOG "<TR>";
			printTableData("<BR>");
			printTableData("$current{strings}");
			printTableData("<BR>");
			if(!$opt_nolog) {
				printTableData("<BR>");
				printTableData("<BR>");
			}
			printTableData("<BR>");
			print LOG "</TR>\n";
		}
	}

	print LOG "</TABLE>\n";
	print LOG "</CENTER>\n";
}

sub printFooter() {

	if($opt_nofooter) {
		print LOG "</BODY>\n";
		print LOG "</HTML>\n";
	} else {
		if(-e ".footer") {
			print LOG "<HR>\n";
			open FOOTER, ".footer" or die;
			while(<FOOTER>){
				print LOG $_;
			}
			close FOOTER;
		}

		if($opt_nobkg) {
		print LOG <<ECHO;
<HR>
</BODY>
</HTML>
ECHO
		} else {
		print LOG <<ECHO;
<HR>
This Report was generated by
<A HREF=\"http://www.tahi.org/\">TAHI</A> IPv6 Conformance Test Suite
</BODY>
</HTML>
ECHO
		}
	}
}

sub printTableData($;$$) { my (
	$desc,
	$link,
	$td_opt
	) = @_;
	$td_opt = " $td_opt" if $td_opt;
	print LOG "<TD$td_opt>";
	print LOG "<A HREF=\"$link\">" if $link;
	print LOG "$desc";
	print LOG "</A>" if $link;
	print LOG "</TD>";
}

sub getStatus($) { my (
	$status
	) = @_;

	$result{0} ="PASS";
	$result{1} ="-";
	$result{2} ="<FONT COLOR=\"#00FF00\">Not yet supported</FONT>";
	$result{3} ="<FONT COLOR=\"#FF8080\">WARN</FONT>";
	$result{4} ="<FONT COLOR=\"#FF8080\">Host Only<FONT>";
	$result{5} ="<FONT COLOR=\"#FF8080\">Router Only</FONT>";
	$result{6} ="<FONT COLOR=\"#FF8080\">Embedded Only</FONT>";
	$result{7} ="<FONT COLOR=\"#FF8080\">Except Host<FONT>";
	$result{8} ="<FONT COLOR=\"#FF8080\">Except Router</FONT>";
	$result{9} ="<FONT COLOR=\"#FF8080\">Except Embedded</FONT>";
	$result{32}="<FONT COLOR=\"#FF0000\">FAIL</FONT>";
	$result{33}="<FONT COLOR=\"#FF0000\">Initialization Fail</FONT>";
	$result{64}="<FONT COLOR=\"#FF0000\">internal error</FONT>";
	$result{72}="TBD";
	$result{73}="<FONT COLOR=\"#AAAAAA\">SKIP</FONT>";
	$result{255} ="<FONT COLOR=\"#00FF00\">no test sequence</FONT>";

	my $rc="internal error";

	if ($status == 0){
		$rc=$result{0};
	}
#	elsif ($status == 0xff00){
#		$rc = "no test sequence";
#	}
	elsif ($status > 0x80){
		my $err = $status >> 8;
		$rc = $result{$err} ||
			"<FONT COLOR=\"#FF0000\">FAIL ($err)</FONT>";
	}
	elsif ($status < 0x80) {
		$rc = "<FONT COLOR=\"#FF0000\">SIGNAL ($status)</FONT>";
	}
	$rc;
}

sub printComment() {

	open CURHTML, "$current{number}.html" or die;
	while (<CURHTML>) {
		chop;
		if ($_ =~ /$key/) {
			$_ =~ s/<\/TD>//g;
#			$_ =~ s/$key1del|$key2del|$key3del|$key4del|$key5del|$key6del//g;
			$_ =~ s/$key1del|$key2del|$key3del|$key4del//g;
			$current{zhang}.= $_;
		}
		elsif ($_ =~ /$keyunpac/) {
			$unexpect++;
			$_ =~ s/HREF="/HREF="$current{number}.html/g;
			$current{zhang}.= $_;
			$current{zhang}.="<BR>";
			$unexpectno .= "$current{number} " if ($unexpectnold != $current{number});
			$unexpectnold = $current{number};
		}
		elsif (($ToolVersionFlag == 0) && ($_ =~ /ToolVersion/)) {
			$_ =~ s/<.*?>//g;
			$_ =~ s/ToolVersion//g;
			$VERTOOLS = $_;
			$ToolVersionFlag = 1;
		}
		elsif (($TargetNameFlag == 0) && ($_ =~ /TargetName/)) {
			$_ =~ s/<.*?>//g;
			$_ =~ s/TargetName//g;
			$TargetName = $_;
			$TargetNameFlag = 1;
		}
		next;
	}
	close CURHTML;
}

sub execScript($$$$$) { my (
	$script,
	$packet,
	$opt,
	$log,
	$desc
	) = @_;
	my $cmd= "grep";
	$cmd.=" $script $Input";
#	print "$cmd\n";
	$rc = `$system($cmd)`;

	$current{zhang} = "";

	if ($rc =~ /PASS/) {
		$rc =0x00;
		printComment() if (! $opt_nopass);
	}
	elsif ($rc =~ />-</) {
		if (($rc =~ /SKIP/)) {
			$current{zhang}.= "";
		}
		else {
			$current{zhang}.= "Skipped, see <A HREF=\"config.txt\">config.txt</A> && <A HREF=\"$current{script}\">$current{script}</A>(INITIALIZATION)" if (! $opt_noskiped);
		}
		$rc =0x180;
	}
	elsif ($rc =~ /WARN/) {
		$rc =0x380;
		printComment() if (! $opt_nowarn);
	}
	elsif ($rc =~ /FAIL/) {
		$rc =0x2080;
		printComment() if (! $opt_nofail);
	}
	elsif ($rc =~ /Initialization\ Fail/) {
		$rc =0x2180;
		printComment() if (! $opt_noinitfail);
	}
	elsif ($rc =~ /internal error/) {
		$rc =0x4080;
	}
	elsif ($rc =~ /no test sequence/) {
		$rc =0xff00;
	}
	elsif ($rc =~ /Not yet supported/) {
		$rc =0x280;
	}
	elsif ($rc =~ /TBD/) {
		$rc =0x4880;
	}
	elsif ($rc =~ /(SIGNAL) \((\d*)\)/) {
		$rc = $2;
	}

#	print "$rc";
	$rc;
}

sub getDateString() {
	my ($sec,$min,$hour,$day,$mon,$year) = localtime;
	my $datestr = sprintf '%04d/%02d/%02d %02d:%02d:%02d',
			$year+1900, $mon+1, $day, $hour, $min, $sec;
	$datestr;
}


#
# print summary.html
#
################################################################
sub printSummary() {
	my $total = 0;
	my $tbd = 0;
	my $skip = 0;
	my $skiped = 0;
	my $pass = 0;
	my $fail = 0;
	my $initfail = 0;
	my $warn = 0;
	my $na = 0;

	for(my $d = 1; $status[$d]{type}; $d ++) {
		if($status[$d]{type} eq "DO" ) {
			$tbd ++;
			$total ++;
			next;
		}

		if($status[$d]{type} eq "DOTEST") {
			my $s = $status[$d]{status};

			if($s == 0) {
				$pass ++;
			} elsif($s > 0x80) {
				my $err = $s >> 8;

				if($err == 3) {
					$warn ++;
				} elsif($err == 32) {
					$fail ++;
				} elsif($err == 33) {
					$initfail ++;
				} elsif($err == 1) {
					$skiped ++;
				} else {
					$na ++;
				}
			} else {
				$na ++;
			}

			$total ++;
			next;
		}

		if($status[$d]{type} eq "SKIP") {
			$skip ++;
			$total ++;
			next;
		}
	}

	print LOG "<TABLE>\n";
	print LOG "<TR><TD>Statistics</TD><TD>: |</TD>";
	print LOG "<TD>TOTAL</TD><TD>:</TD><TD>$total </TD><TD>|</TD>";
	print LOG "<TD>PASS</TD><TD>:</TD><TD>$pass </TD><TD>|</TD>";
	print LOG "<TD><FONT COLOR=\"#FF0000\">FAIL</FONT></TD><TD>:</TD><TD>$fail </TD><TD>|</TD>";
	print LOG "<TD><FONT COLOR=\"#FF0000\">INITFAIL</FONT></TD><TD>:</TD><TD>$initfail </TD><TD>|</TD>";
	print LOG "<TD><FONT COLOR=\"#FF8080\">WARN</FONT></TD><TD>:</TD><TD>$warn </TD><TD>|</TD>";
	print LOG "<TD><FONT COLOR=\"#0000FF\">-</FONT></TD><TD>:</TD><TD>$skiped </TD><TD>|</TD>";
	print LOG "<TD><FONT COLOR=\"#AAAAAA\">SKIP</FONT></TD><TD>:</TD><TD>$skip </TD><TD>|</TD>";
	print LOG "<TD>N/A</TD><TD>:</TD><TD>$na </TD><TD>|</TD>";

	if($tbd != 0) {
		print LOG "<TD>TBD</TD><TD>:</TD><TD>$tbd</TD><TD>|</TD>";
	}
	print LOG "</TABLE>\n";

	print LOG "<TD>Unexpected packets</TD><TD>: $unexpect </TD>";
	print LOG "<TD>($unexpectno)</TD>" if($unexpectno!=0);
	print LOG "<BR>";

	return;
}

########################################################################
#	parse Args
#
#	Getopt::Long module is used for argument parse
#-----------------------------------------------------------------------
sub parseArgs() {
	use Getopt::Long;
	$Getopt::Long::ignorecase=undef;
	my $optStat = GetOptions(
		"s|Start=s",
		"e|End=s",
		"h|help",
		"i|Input=s",
		"o|Output=s",
		"title=s",
		"key=s",
		"nobkg",
		"nofooter",
		"nopass",
		"nofail",
		"noinitfail",
		"nowarn",
		"noskiped",
		"nolog",
	);

	$StartNum= $opt_s ? $opt_s : 0;
	$EndNum= $opt_e ? $opt_e : 0xffff; # xxx
	if($StartNum > $EndNum) {
		print "Start Test Number is greater than End Test Number\n";
		exit 1;
	}
	$Title= $opt_title ? $opt_title : "Test Commentaries: Mobile Node Operation";
	$key= $opt_key ? $opt_key : "INIT FAIL|WARN|FAIL:|PASS";
	$Input= $opt_i ? $opt_i : "report.html";
	$Output= $opt_o ? $opt_o : "analysis.html";
}

########################################################################
sub usage()
{
	print "\nSYNOPSIS:\n";
	print "analyzer [INDEX] [-s [StartNum]] [-e [EndNum]] [-i fileame] [ -o filename]\n";
	print "         [-title \"titlename\"] [-key \"keyword\"] [-nobkg] [-nopass] [-nofail]\n";
	print "         [-noinitfail] [-nowarn] [-noskiped] [-nolog] [-h]\n\n";
	print "EXAMPLES:\n";
	print "    0.  analyzer\n";
	print "    1.  analyzer INDEX.orig\n";
	print "    2.  analyzer -s 3 -e 10\n";
	print "    3.  analyzer -i myreport.html\n";
	print "    4.  analyzer -o myanalysis.html\n";
	print "    5.  analyzer -title \"TAHI Tool: My TITLE\"\n";
	print "    6.  analyzer -key \"MYKEY|WARN|FAIL:|PASS\"\n";
	print "    7.  analyzer -nobkg\n";
	print "    8.  analyzer -nopass\n";
	print "    9.  analyzer -nofail\n";
	print "    10. analyzer -noinitfail\n";
	print "    11. analyzer -nowarn\n";
	print "    12. analyzer -noskiped\n";
	print "    13. analyzer -nolog\n";
	print "    14. analyzer -h\n\n";
}
