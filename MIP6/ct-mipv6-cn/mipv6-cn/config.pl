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


###
### Set Default (except enc key and auth key)
###

# OPTIONAL
#IPSEC_EKEY	24 or 8 characters	# enc key
#IPSEC_AKEY	20 or 16 characters	# auth key

%CN_CONF = (
	    'IPSEC_SUPPORT'        => 'ON',
	    'IPSEC_EALGO'          => '3DES-CBC',
	    'IPSEC_AALGO'          => 'HMAC-SHA1',
	    'EALGO_DES'            => 'OFF',
	    'AALGO_MD5'            => 'OFF',
	    'CN_ADDR_CONF'         => 'AUTO'
);
# For IPSEC_EKEY and IPSEC_AKEY
my $ekey = '';
my $akey = '';


###
### Read from config.txt
###
open(CONFIG_TXT, "config.txt") || die "***** Configuration Error :\n\ Cannot Open file config.txt.\n";
while (<CONFIG_TXT>) {
    if ($_ !~ /^#|^\s+/){
	chop;
	/^(\S+)\s+(\S+)/;
	if (defined($CN_CONF{$1})) {
	    $CN_CONF{$1} = uc($2);
	}
	if($1 eq 'IPSEC_EKEY'){ $ekey = $2; }
	if($1 eq 'IPSEC_AKEY'){ $akey = $2; }
    }
}
close(CONFIG_TXT);

###
### Check & Set Algorithm and Key
###
if( $CN_CONF{'EALGO_DES'} eq 'ON' ){
    $CN_CONF{'IPSEC_EALGO'} = 'DES-CBC';
}
if( $CN_CONF{'AALGO_MD5'} eq 'ON' ){
    $CN_CONF{'IPSEC_AALGO'} = 'HMAC-MD5';
}

if( $CN_CONF{'IPSEC_SUPPORT'} eq 'ON' ){
    if( $CN_CONF{'IPSEC_EALGO'} eq 'DES-CBC' ){
	if( $ekey eq '' ){
	    $CN_CONF{'IPSEC_EKEY'} = 'CNMNTEST';
	}elsif( length($ekey) == 8 ){
	    $CN_CONF{'IPSEC_EKEY'} = $ekey;
	}else{
	    die "***** Configuration Error :\n Specify 8 bytes characters as Enc. Key ( DES-CBC ).\n";
	}
    }else{
	if( $ekey eq '' ){
	    $CN_CONF{'IPSEC_EKEY'} = 'CNMNTEST0123456789ABCDEF';
	}elsif( length($ekey) == 24 ){
	    $CN_CONF{'IPSEC_EKEY'} = $ekey;
	}else{
	    die "***** Configuration Error :\n Specify 24 bytes characters as Enc. Key ( 3DES-CBC ).\n";
	}
    }
    if( $CN_CONF{'IPSEC_AALGO'} eq 'HMAC-MD5' ){
	if( $akey eq '' ){
	    $CN_CONF{'IPSEC_AKEY'} = 'CNMNTEST89ABCDEF';
	}elsif( length($akey) == 16 ){
	    $CN_CONF{'IPSEC_AKEY'} = $akey;
	}else{
	    die "***** Configuration Error :\n Specify 16 bytes characters as Auth. Key ( HMAC-MD5 ).\n";
	}
    }else{
	if( $akey eq '' ){
	    $CN_CONF{'IPSEC_AKEY'} = 'CNMNTEST0123456789AB';
	}elsif( length($akey) == 20 ){
	    $CN_CONF{'IPSEC_AKEY'} = $akey;
	}else{
	    die "***** Configuration Error :\n\t Specify 20 bytes characters as Auth. Key ( HMAC-SHA1 ).\n";
	}
    }
}else{
    $CN_CONF{'IPSEC_EALGO'} = '---------';
    $CN_CONF{'IPSEC_AALGO'} = '---------';
    $CN_CONF{'IPSEC_EKEY'} = '------------------------';
    $CN_CONF{'IPSEC_AKEY'} = '--------------------';
}


###
### Check & Set CN Address
###
if( $CN_CONF{'CN_ADDR_CONF'} ne 'AUTO' ){
    if( $CN_CONF{'CN_ADDR_CONF'} !~ /^3FFE:0?501:FFFF:0?100:((:[0-9A-F]{1,4})|([0-9A-F]{1,4}::[0-9A-F]{1,4})|([0-9A-F]{1,4}:(:[0-9A-F]{1,4}){2})|(([0-9A-F]{1,4}:){2}:[0-9A-F]{1,4})|(([0-9A-F]{1,4}:){3}[0-9A-F]{1,4}))$/ ){
	die "***** Configuration Error :\n Specify CN Address properly, with prefix 3ffe:501:ffff:100:\n";
    }
    @tmp = split( /:/, $1 );
    foreach ( @tmp ){
	if( $_ =~ /^0*(.+)$/ ){
	    $_ = $1;
	}
    }
    $CN_CONF{'CN_ADDR_CONF'}=lc('3ffe:501:ffff:100:'.join( ':', @tmp ));

#    print "# Set your IP address to $CN_CONF{'CN_ADDR_CONF'}.\n";
#    print "# Set your default gateway to fe80::1\%(your if name).\n";
}

###
### write to mip6config.def
###
open( CONF_DEF, "> mip6config.def" ) || die "***** Configuration Error :\n Cannot Write file mip6config.def\n";
if( $CN_CONF{'CN_ADDR_CONF'} ne 'AUTO' ){
    print CONF_DEF "#ifndef CN_GLOBAL_ADDR\n";
    print CONF_DEF "#define CN_GLOBAL_ADDR	v6(\"$CN_CONF{'CN_ADDR_CONF'}\")\n";
    print CONF_DEF "#endif\n";
}else{
    print CONF_DEF "#ifndef CN_GLOBAL_ADDR\n";
    print CONF_DEF "#define CN_GLOBAL_ADDR	nut2v6(L0_GLOBAL_UCAST_PRFX, 64)\n";
    print CONF_DEF "#endif\n";
}
print CONF_DEF "#ifdef HAVE_IPSEC\n";
print CONF_DEF "ESPAlgorithm ealgo_cbc {\n";
if( $CN_CONF{'IPSEC_EALGO'} eq 'DES-CBC' ){
    print CONF_DEF "	crypt	= descbc(\"$CN_CONF{'IPSEC_EKEY'}\")\;\n";
}else{
    print CONF_DEF "	crypt	= des3cbc(\"$CN_CONF{'IPSEC_EKEY'}\")\;\n";
}
if( $CN_CONF{'IPSEC_AALGO'} eq 'HMAC-MD5' ){
    print CONF_DEF "	auth	= hmacmd5(\"$CN_CONF{'IPSEC_AKEY'}\")\;\n";
}else{
    print CONF_DEF "	auth	= hmacsha1(\"$CN_CONF{'IPSEC_AKEY'}\")\;\n";
}
print CONF_DEF "}\n";
print CONF_DEF "#endif\n";
close( CONF_DEF );

###
### write to _config_.txt
###
open( TMP_CONF, "> _config_.txt" ) || die "***** Configuration Error :\n Cannot Write file _config_.txt\n";
foreach $i ( keys %CN_CONF ){
    print TMP_CONF "$i\t$CN_CONF{$i}\n";
}
close( TMP_CONF );

