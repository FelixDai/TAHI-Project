#!/usr/bin/perl -w
# make setkey.conf

#############
# INITIALIZE
#############
# SUBTUTINE
sub make_conf($$$$$$);
sub make_key($$);
sub is_v6adr($);
sub is_v6prf($);
sub is_id($);
sub is_item($@);
sub print_conf($$);
sub print_msg($$);
sub end_proc();

# PACKAGE
BEGIN { print "making setkey.conf\n"; };
END { end_proc(); };

# DEBUG
my $msg_bug = 0x1;
my $msg_err = 0x10;
my $msg_val = 0x100;
my $msg_fnc = 0x1000;
my $msg_lvl = $msg_bug + $msg_err;
#my $msg_lvl = $msg_bug + $msg_err + $msg_val + $msg_fnc;

# FILE
my $conf_name = "setkey.conf";
my $conf_file_hdl = "CONF";
my $conf_open_flg = 0;

# OUTPUT DATA
# sad: 0(none)/other(make)
# spd: 0(none)/other(make)
my $sad = 1;
my $spd = 0;


########
# INPUT
########
# INPUT DATA
# nut data
#  typ: node type (ha/mn/mr).
#  adr: global address of nut.
#  rng: outer prefix. if nut is ha.
#  mnp: mobile network prefix under nut. if nut is mr.
my @item_typs = ("ha", "mn", "mr");
my %nut = (
	typ => "mr", adr => "3ffe:501:ffff:100:2e0:29ff:fe10:da52",
	rng => "",   mnp => "3ffe:501:ffff:104::/64",
);

# tn(s) data
#  typ: ha/mn/mr
#  flg: 0(none)/other(exist).
#  adr: global address of tn.
#  rng: outer prefix. if tn is ha.
#  mnp: mobile network prefix under tn. if tn is mr.
#  sa*: data of each sa
#   id : unique value (just 3 digits in hexadecimal)
#        ""(null) meams to no-apply.
#        note: %sas->sa*->flg has another factor.
my $cmn_tntyp = "ha";
my $cmn_rng = "::/0";
my @tns = (
	{ flg => 1, typ => $cmn_tntyp, adr => "3ffe:501:ffff:100:200:ff:fe00:a0a0",
	  rng => $cmn_rng, mnp => "",
	  sa1 => { id => "111" }, sa2 => { id => "112" }, sa3 => { id => "113" }, sa4 => { id => "114" },
	  sa5 => { id => "115" }, sa6 => { id => "116" }, sa7 => { id => "117" }, sa8 => { id => "118" },
	  sa9 => { id => "119" }, saa => { id => "11A" }, },
	{ flg => 1, typ => $cmn_tntyp, adr => "3ffe:501:ffff:100:200:ff:fe00:a1a1",
	  rng => $cmn_rng, mnp => "",
	  sa1 => { id => "211" }, sa2 => { id => "212" }, sa3 => { id => "213" }, sa4 => { id => "214" },
	  sa5 => { id => "215" }, sa6 => { id => "216" }, sa7 => { id => "217" }, sa8 => { id => "218" },
	  sa9 => { id => "219" }, saa => { id => "21A" }, },
);

# common sa(s) data
#  sa* : data of each sa
#   flg: 0(disable)/1(enable)
#   dir: in/out
#   upp: 135(mh)/58(icmpv6)/X(any)
#   enc: 3des-cbc/des-cbc
#   ath: hmac-sha1/hmac-md5
my @item_dirs = ("in", "out");
my %dirs = (
	ha => { sa1 => "in",  sa2 => "out", sa3 => "in",  sa4 => "out",
	        sa5 => "in",  sa6 => "out", sa7 => "in",  sa8 => "out",
	        sa9 => "in",  saa => "out", },
	mn => { sa1 => "out", sa2 => "in",  sa3 => "out", sa4 => "in",
	        sa5 => "out", sa6 => "in",  sa7 => "out", sa8 => "in", },
	mr => { sa1 => "out", sa2 => "in",  sa3 => "out", sa4 => "in",
	        sa5 => "out", sa6 => "in",  sa7 => "out", sa8 => "in",
	        sa9 => "out", saa => "in", },
);
my @item_upps = ("135", "58", "any");
my @item_mods = ("transport", "tunnel");
my @item_encs = ("3des-cbc", "des-cbc");
my @item_aths = ("hmac-sha1", "hmac-md5");
my $cmm_enc = "3des-cbc"; # 3des-cbc/des-cbc
my $cmm_ath = "hmac-sha1"; # hmac-sha1/hmac-md5
my %sas = (
	sa1 => { flg => 1, dir => $dirs{$nut{typ}}->{sa1}, upp => "135", mod => "transport", enc => $cmm_enc, ath => $cmm_ath, },
	sa2 => { flg => 1, dir => $dirs{$nut{typ}}->{sa2}, upp => "135", mod => "transport", enc => $cmm_enc, ath => $cmm_ath, },
	sa3 => { flg => 1, dir => $dirs{$nut{typ}}->{sa3}, upp => "135", mod => "tunnel",    enc => $cmm_enc, ath => $cmm_ath, },
	sa4 => { flg => 1, dir => $dirs{$nut{typ}}->{sa4}, upp => "135", mod => "tunnel",    enc => $cmm_enc, ath => $cmm_ath, },
	sa5 => { flg => 1, dir => $dirs{$nut{typ}}->{sa5}, upp => "58",  mod => "transport", enc => $cmm_enc, ath => $cmm_ath, },
	sa6 => { flg => 1, dir => $dirs{$nut{typ}}->{sa6}, upp => "58",  mod => "transport", enc => $cmm_enc, ath => $cmm_ath, },
	sa7 => { flg => 0, dir => $dirs{$nut{typ}}->{sa7}, upp => "any", mod => "tunnel",    enc => $cmm_enc, ath => $cmm_ath, },
	sa8 => { flg => 0, dir => $dirs{$nut{typ}}->{sa8}, upp => "any", mod => "tunnel",    enc => $cmm_enc, ath => $cmm_ath, },
	sa9 => { flg => 0, dir => $dirs{$nut{typ}}->{sa9}, upp => "any", mod => "tunnel",    enc => $cmm_enc, ath => $cmm_ath, },
	saa => { flg => 0, dir => $dirs{$nut{typ}}->{saa}, upp => "any", mod => "tunnel",    enc => $cmm_enc, ath => $cmm_ath, },
);

########
# CHECK
########
# CHECK DATA NUT
my $err_cnt = 0;
print_msg($msg_val, "nut:typ=" . $nut{typ} . "\n");
if (!is_item($nut{typ}, @item_typs)) {
	print_msg($msg_err, "nut:typ is invalid.\n");
	$err_cnt ++;
}
print_msg($msg_val, "nut:adr=" . $nut{adr} . "\n");
if (!(is_v6adr($nut{adr}))) {
	print_msg($msg_err, "nut:adr is invalid.\n");
	$err_cnt ++;
}
if ($nut{typ} eq "ha") {
	print_msg($msg_val, "nut:rng=" . $nut{rng} . "\n");
	if (!(is_v6prf($nut{rng}))) {
		print_msg($msg_err, "nut:rng is invalid.\n");
		$err_cnt ++;
	}
}
if ($nut{typ} eq "mr") {
	print_msg($msg_val, "nut:mnp=" . $nut{mnp} . "\n");
	if (!(is_v6prf($nut{mnp}))) {
		print_msg($msg_err, "nut:mnp is invalid.\n");
		$err_cnt ++;
	}
}

# CHECK DATA TN
for my $tn (@tns) {
	print_msg($msg_val, "tn:flg=" . $tn->{flg} . "\n");
	if ($tn->{flg} eq 0) {
		next;
	}
	print_msg($msg_val, "tn:typ=" . $tn->{typ} . "\n");
	if (!is_item($tn->{typ}, @item_typs)) {
		print_msg($msg_err, "tn:typ is invalid.\n");
		$err_cnt ++;
	}
	if ($nut{typ} eq "ha") {
		if (($tn->{typ} ne "mn") && ($tn->{typ} ne "mr")) {
			print_msg($msg_err, "tn:typ is invalid for nut:typ.\n");
			$err_cnt ++;
		}
	}
	elsif (($nut{typ} eq "mn") || ($nut{typ} eq "mr")) {
		if ($tn->{typ} ne "ha") {
			print_msg($msg_err, "tn:typ is invalid for nut:typ.\n");
			$err_cnt ++;
		}
	}
	print_msg($msg_val, "tn:adr=" . $tn->{adr} . "\n");
	if (!(is_v6adr($tn->{adr}))) {
		print_msg($msg_err, "tn:adr is invalid.\n");
		$err_cnt ++;
	}
	if ($tn->{typ} eq "ha") {
		print_msg($msg_val, "tn:rng=" . $tn->{rng} . "\n");
		if (!(is_v6prf($tn->{rng}))) {
			print_msg($msg_err, "tn:rng is invalid.\n");
			$err_cnt ++;
		}
	}
	if ($tn->{typ} eq "mr") {
		print_msg($msg_val, "tn:mnp=" . $tn->{mnp} . "\n");
		if (!(is_v6prf($tn->{mnp}))) {
			print_msg($msg_err, "tn:mnp is invalid.\n");
			$err_cnt ++;
		}
	}
	my %ids = ();
	my $id_cnt = 0;
	foreach my $sa ("sa1", "sa2", "sa3", "sa4", "sa5", "sa6", "sa7", "sa8", "sa9", "saa") {
		print_msg($msg_val, "tn:" . $sa . ":id=" . $tn->{$sa}->{id} . "\n");
		if ($tn->{$sa}->{id} ne "") {
			if (!(is_id($tn->{$sa}->{id}))) {
				print_msg($msg_err, "tn:" . $sa . ":id is invalid format.\n");
				$err_cnt ++;
			}
			elsif ($ids{$tn->{$sa}->{id}}) {
				print_msg($msg_err, "tn:" . $sa . ":id is not unique.\n");
				$err_cnt ++;
			}
			$ids{$tn->{$sa}->{id}} = 1;
		}
	}
}

# CHECK DATA COMMON
foreach my $sa ("sa1", "sa2", "sa3", "sa4", "sa5", "sa6", "sa7", "sa8", "sa9", "saa") {
	print_msg($msg_val, "dirs:" . $nut{typ} . ":" . $sa . "=" . $dirs{$nut{typ}}->{$sa} . "\n");
	if (!(is_item($dirs{$nut{typ}}->{$sa}, @item_dirs))) {
		print_msg($msg_err, "dirs:" . $nut{typ} . ":" . $sa . " is invalid.\n");
		$err_cnt ++;
	}
	print_msg($msg_val, "sas:" . $sa . ":flg=" . $sas{$sa}->{flg} . "\n");
	if ($sas{$sa}->{flg} eq 0) {
		next;
	}
	print_msg($msg_val, "sas:" . $sa . ":dir=" . $sas{$sa}->{dir} . "\n");
	if (!(is_item($sas{$sa}->{dir}, @item_dirs))) {
		print_msg($msg_err, "sas:" . $sa . ":dir is invalid.\n");
		$err_cnt ++;
	}
	print_msg($msg_val, "sas:" . $sa . ":upp=" . $sas{$sa}->{upp} . "\n");
	if (!(is_item($sas{$sa}->{upp}, @item_upps))) {
		print_msg($msg_err, "sas:" . $sa . ":upp is invalid.\n");
		$err_cnt ++;
	}
	print_msg($msg_val, "sas:" . $sa . ":mod=" . $sas{$sa}->{mod} . "\n");
	if (!(is_item($sas{$sa}->{mod}, @item_mods))) {
		print_msg($msg_err, "sas:" . $sa . ":mod is invalid.\n");
		$err_cnt ++;
	}
	print_msg($msg_val, "sas:" . $sa . ":enc=" . $sas{$sa}->{enc} . "\n");
	if (!(is_item($sas{$sa}->{enc}, @item_encs))) {
		print_msg($msg_err, "sas:" . $sa . ":enc is invalid.\n");
		$err_cnt ++;
	}
	print_msg($msg_val, "sas:" . $sa . ":ath=" . $sas{$sa}->{ath} . "\n");
	if (!(is_item($sas{$sa}->{ath}, @item_aths))) {
		print_msg($msg_err, "sas:" . $sa . ":ath is invalid.\n");
		$err_cnt ++;
	}
}

# CHECK END
if ($err_cnt ne 0) {
	print_msg($msg_err, "input data has illegal.\n");
	exit -1;
}

#######
# MAIN
#######
# OUTPUT
if (!(open($conf_file_hdl, "> " . $conf_name))) {
	print_msg($msg_err, "Can't open " . $conf_name . "\n");
	exit -1;
}
else {
	$conf_open_flg = 1;
}

for $tn (@tns) {
	if ($tn->{flg} eq 0) {
		next;
	}
	if ($nut{typ} eq "ha") {
		make_conf($tn->{sa1}->{id}, $sas{sa1}, $tn->{adr}, $nut{adr},  $tn->{adr}, $nut{adr});
		make_conf($tn->{sa2}->{id}, $sas{sa2}, $nut{adr},  $tn->{adr}, $nut{adr},  $tn->{adr});
		make_conf($tn->{sa3}->{id}, $sas{sa3}, $tn->{adr}, $nut{adr},  $tn->{adr}, $nut{rng});
		make_conf($tn->{sa4}->{id}, $sas{sa4}, $nut{adr},  $tn->{adr}, $nut{rng},  $tn->{adr});
		make_conf($tn->{sa5}->{id}, $sas{sa5}, $tn->{adr}, $nut{adr},  $tn->{adr}, $nut{adr});
		make_conf($tn->{sa6}->{id}, $sas{sa6}, $nut{adr},  $tn->{adr}, $nut{adr},  $tn->{adr});
		make_conf($tn->{sa7}->{id}, $sas{sa7}, $tn->{adr}, $nut{adr},  $tn->{adr}, $nut{rng});
		make_conf($tn->{sa8}->{id}, $sas{sa8}, $nut{adr},  $tn->{adr}, $nut{rng},  $tn->{adr});
	}
	if (($nut{typ} eq "ha") && ($tn->{typ} eq "mr")) {
		make_conf($tn->{sa9}->{id}, $sas{sa9}, $tn->{adr}, $nut{adr},  $tn->{mnp}, $nut{rng});
		make_conf($tn->{saa}->{id}, $sas{saa}, $nut{adr},  $tn->{adr}, $nut{rng},  $tn->{mnp});
	}
	if (($nut{typ} eq "mn") || ($nut{typ} eq "mr")) {
		make_conf($tn->{sa1}->{id}, $sas{sa1}, $nut{adr},  $tn->{adr}, $nut{adr},  $tn->{adr});
		make_conf($tn->{sa2}->{id}, $sas{sa2}, $tn->{adr}, $nut{adr},  $tn->{adr}, $nut{adr});
		make_conf($tn->{sa3}->{id}, $sas{sa3}, $nut{adr},  $tn->{adr}, $nut{adr},  $tn->{rng});
		make_conf($tn->{sa4}->{id}, $sas{sa4}, $tn->{adr}, $nut{adr},  $tn->{rng}, $nut{adr});
		make_conf($tn->{sa5}->{id}, $sas{sa5}, $nut{adr},  $tn->{adr}, $nut{adr},  $tn->{adr});
		make_conf($tn->{sa6}->{id}, $sas{sa6}, $tn->{adr}, $nut{adr},  $tn->{adr}, $nut{adr});
		make_conf($tn->{sa7}->{id}, $sas{sa7}, $nut{adr},  $tn->{adr}, $nut{adr},  $tn->{rng});
		make_conf($tn->{sa8}->{id}, $sas{sa8}, $tn->{adr}, $nut{adr},  $tn->{rng}, $nut{adr});
	}
	if ($nut{typ} eq "mr") {
		make_conf($tn->{sa9}->{id}, $sas{sa9}, $nut{adr},  $tn->{adr}, $nut{mnp},  $tn->{rng});
		make_conf($tn->{saa}->{id}, $sas{saa}, $tn->{adr}, $nut{adr},  $tn->{rng}, $nut{mnp});
	}
}

############
# TERMINATE
############
end_proc();
exit 0;

# sub make_conf
#  id : unique value (just 3 digits in hexadecimal)
#  sa : data of each sa
#  src: source address
#  dst: destination address
#  src_prf: fowarding prefix on src side, if mode is tunnel.
#  dst_prf: fowarding prefix on dst side, if mode is tunnel.
#  rtn: 0(none)/1(output)
sub make_conf($$$$$$){
	my ($id, $sa, $src, $dst, $src_prf, $dst_prf) = @_;
	print_msg($msg_fnc, "id=" . $id . "\n");
	print_msg($msg_fnc, "sa:flg=" . $sa->{flg} . "\n");
	if (($id eq "") || ($sa->{flg} eq 0)) {
		return 0;
	}
	print_msg($msg_fnc, "sa:dir=" . $sa->{dir} . "\n");
	print_msg($msg_fnc, "sa:upp=" . $sa->{upp} . "\n");
	print_msg($msg_fnc, "sa:mod=" . $sa->{mod} . "\n");
	print_msg($msg_fnc, "sa:enc=" . $sa->{enc} . "\n");
	print_msg($msg_fnc, "sa:ath=" . $sa->{ath} . "\n");
	if ($sad eq 1) {
		print_msg($msg_fnc, "add " . $src . " " . $dst . "\n");
		print_msg($msg_fnc, "	esp 0x" . $id . "\n");
		print_msg($msg_fnc, "	-m " . $sa->{mod} . " -u " . hex($id) . "\n");
		print_msg($msg_fnc, "	-E " . $sa->{enc} . " \"" . make_key($sa->{enc}, $id) . "\"\n");
		print_msg($msg_fnc, "	-A " . $sa->{ath} . " \"" . make_key($sa->{ath}, $id) . "\";\n");
		print_conf($conf_file_hdl, "add " . $src . " " . $dst . "\n");
		print_conf($conf_file_hdl, "	esp 0x" . $id . "\n");
		print_conf($conf_file_hdl, "	-m " . $sa->{mod} . " -u " . hex($id) . "\n");
		print_conf($conf_file_hdl, "	-E " . $sa->{enc} . " \"" . make_key($sa->{enc}, $id) . "\"\n");
		print_conf($conf_file_hdl, "	-A " . $sa->{ath} . " \"" . make_key($sa->{ath}, $id) . "\";\n");
	}
	if ($spd eq 1) {
		print_msg($msg_fnc, "spdadd " . $src_prf . " " . $dst_prf . "\n");
		print_msg($msg_fnc, "	" . $sa->{upp} . "\n");
		my $msg = "	-P " . $sa->{dir} . " ipsec esp\/" . $sa->{mod} . "\/";
		if ($sa->{mod} eq "tunnel") {
			$msg .= $src . "-" . $dst;
		}
		$msg .= "\/unique;\n";
		print_msg($msg_fnc, $msg);
		print_conf($conf_file_hdl, "spdadd " . $src_prf . " " . $dst_prf . "\n");
		print_conf($conf_file_hdl, "	" . $sa->{upp} . "\n");
		print_conf($conf_file_hdl, $msg);
	}
	return 1;
}

# sub make_key
#  alg: algorithm
#  id : unique value (just 3 digits in hexadecimal)
#  rtn: key
sub make_key($$) {
	my ($alg, $id) = @_;
	my $key;
	if ($alg eq "3des-cbc") {
		$key = "V6LC-" . $id . "--12345678901234";
	}
	elsif ($alg eq "des-cbc") {
		$key = "V6LC-" . $id;
	}
	elsif ($alg eq "hmac-sha1") {
		$key = "V6LC-" . $id . "--1234567890";
	}
	elsif ($alg eq "hmac-md5") {
		$key = "V6LC-" . $id . "--123456";
	}
 	else {
		print_msg($msg_bug, "alg is invaid\n");
		exit -1;
	}
	return $key;
}

# sub is_v6adr
#  adr: address
#  rtn: 0(no)/1(yes)
sub is_v6adr($) {
	my ($adr) = @_;
	if ($adr eq "") {
		return 0;
	}
	return 1;
}

# sub is_v6prf
#  prf: prefix
#  rtn: 0(no)/1(yes)
sub is_v6prf($) {
	my ($prf) = @_;
	if ($prf eq "") {
		return 0;
	}
	return 1;
}

# sub is_id
#  id : unique value (just 3 digits in hexadecimal)
#  rtn: 0(no)/1(yes)
sub is_id($) {
	my ($id) = @_;
	if (length($id) != 3) {
		return 0;
	}
	if ((hex($id) < 0x100) || (hex($id) > 0xfff)) {
		return 0;
	}
	return 1;
}

# sub is_item
#  val: value under checking
#  items: items in reguration
#  rtn: 0(no)/1(yes)
sub is_item($@) {
	my ($val, @items) = @_;
	for (@items) {
		if ($val eq $_) {
			return 1;
		}
	}
	return 0;
}

# sub print_f
#  flh: file handle
#  msg: messages
#  rtn: 0(none)/1(print)
sub print_conf($$) {
	my ($flh, $msg) = @_;
	if (!(print $flh ($msg))) {
		print_msg($msg_err, "print() got error.\n");
	}
	return;
}

# sub print_msg
#  lvl: kind of msg
#  msg: messages
#  rtn: 0(none)/1(print)
sub print_msg($$) {
	my ($lvl, $msg) = @_;
	if (!($lvl & $msg_lvl)) {
		return 0;
	}
	if ($lvl & $msg_bug) {
		print "	ERROR INTERNAL: " . $msg;
	}
	elsif ($lvl & $msg_err) {
		print "	ERROR INPUT: " . $msg;
	}
	elsif ($lvl & $msg_val) {
		print "	DEBUG VAL: " . $msg;
	}
	elsif ($lvl & $msg_fnc) {
		print "	DEBUG FNC: " . $msg;
	}
	else {
		print "	???: " . $msg;
	}
	return 1;
}

# sub end_proc
sub end_proc() {
	if ($conf_open_flg != 0) {
		close ($conf_file_hdl);
	}
	$conf_open_flg = 0;
}

## EOF
