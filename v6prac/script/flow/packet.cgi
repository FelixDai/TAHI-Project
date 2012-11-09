#!/usr/bin/perl

# Copyright (C) 1999,2000 Yokogawa Electric Corporation and
#                         YDC Corporation.
# All rights reserved.
# 
# Redistribution and use of this software in source and binary
# forms, with or without modification, are permitted provided that
# the following conditions and disclaimer are agreed and accepted
# by the user:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with
#    the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project
#    which is related to this software (hereinafter referred to as
#    "project") nor the names of the contributors may be used to
#    endorse or promote products derived from this software without
#    specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written
#    notification to the copyrighters.
# 
# 5. The copyrighters, the project and the contributors may prohibit
#    the use of this software at any time.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

my $flag = 0;

if ($#ARGV != 1)
{
    die "usage: $0 <time> <file_name>\n";
}

open (INPUT, "$ARGV[1]") || die "$0: $ARGV[1]: $!\n";

print "Content-type: text/html\n\n";

print "<HTML>\n";
print "<HEAD>\n";
print "<TITLE>$ARGV[0]</TITLE>\n";
print "</HEAD>\n";
print "<BODY BGCOLOR=\"#FFFFFF\">\n";
print "<PRE>\n";

while (<INPUT>)
{
    if (/^log:\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2}.\d{6}$/s)
    {
        if (/$ARGV[0]/)
        {
            $flag = 1;
        }
        elsif ($flag == 1)
        {
            last;
        }
    }

    if ((/^log:(.*)$/s) && ($flag == 1))
    {
        print $1;
    }
}

close (INPUT);

print "</PRE>\n";
print "</BODY>\n";
print "</HTML>\n";