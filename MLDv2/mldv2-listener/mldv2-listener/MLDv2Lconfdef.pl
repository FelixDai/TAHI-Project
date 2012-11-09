#!/usr/bin/perl
#
# Copyright (C) IPv6 Promotion Council, NTT Advanced Technology Corporation
# (NTT-AT), Yokogwa Electoric Corporation and YASKAWA INFORMATION SYSTEMS
# Corporation All rights reserved.
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
###########################################################################
BEGIN {}
END   {}

# USE MODULE
use strict;
use warnings;
use MLDv2L;

# The duplicate display is avoided.
$DEBUG = 0;

# Variable
my $ret;
my $ckey;
my $cvalue;

#--------------------------------------------------------------------------
# Read config txt file
$ret = &MLDv2L::ReadConfTxt();
if ($ret != $MLDv2L::RES_OK) {
	&MLDv2L::InfoError(__FILE__, __LINE__, "MLDv2L::ReadConfTxt() => $ret");
	exit -1;
}

#--------------------------------------------------------------------------
# Open config def file
unless (open(OUT_F, ">$CONF_DEF_PATH")) {
	&MLDv2L::InfoError(__FILE__, __LINE__, "open() => errno($!), $CONF_DEF_PATH");
	exit -1;
}

#--------------------------------------------------------------------------
# Write config def file
foreach $ckey (@CONF_FOR_DEF) {
	$cvalue = $CONF_DATA{$ckey};

	print(OUT_F "#ifndef $ckey\n");

	if (($cvalue eq "any") || ($cvalue eq "auto")) {
		print(OUT_F "#define $ckey\t$cvalue\n");
	}
	elsif ($CONF_ATTR{$ckey} == 1) {
		print(OUT_F "#define $ckey\t$cvalue\n");
	}
	elsif ($CONF_ATTR{$ckey} == 2) {
		$cvalue *= 1000;
		print(OUT_F "#define $ckey\t$cvalue\n");
	}
	else {
		print(OUT_F "#define $ckey\t\"$cvalue\"\n");
	}

	print(OUT_F "#endif\n");
}

# HUT1 dmmy if needless
if ($CONF_DATA{FUNC_2_INTERFACES} == 0) {
	print(OUT_F "#define HUT1_MAC\t\"00:00:00:00:00:00\"\n");
}

#--------------------------------------------------------------------------
# Close config def file
close(OUT_F);

exit 0;

# EOF
