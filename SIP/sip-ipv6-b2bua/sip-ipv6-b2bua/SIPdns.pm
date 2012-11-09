#! /usr/bin/perl

# Copyright(C) IPv6 Promotion Council (2004,2005). All Rights Reserved.
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


use File::Copy

require SIP;

#=================================
#  Add an address
#=================================
sub AddAddress {
    my ($my_adr, $my_domain, $my_filename) = @_;
    
    #--- Check if the file exists or not.

    if (! -e $my_filename ){
        print "ERROR: No such file [$my_filename]\n";
        return;
    }
    
    #--- Open, Read & Close the file ----
    my @my_lines = LoadTxt($my_filename);
    if ($#my_lines < 1 ) {
        print "ERROR: Failed to get values in $my_filename.\n";
        return;
    }
   
	$my_domain = "$my_domain.";
 
    #--- Check if the same line already exists or not.
    for ($i=0; $i<=$#my_lines;$i++) {
    
        if ($my_lines[$i][0] ne $my_domain) { next;}
        if ($my_lines[$i][1] ne $my_adr) {next;}

        # Get through when the line exists.
        return;
    }

    my $update_text = "$my_domain\t\tIN\tAAAA\t$my_adr\n";
    $ret = update_file($my_filename, $my_lines[$#my_lines][2], $update_text);

    return $ret;
    }

#=================================
#  Delete an address
#=================================
sub DeleteAddress {


    my ($my_adr, $my_domain, $my_filename) = @_;

    #--- Check if the file exists or not.

    if (! -e $my_filename ){
        print "ERROR: No such file [$my_filename]\n";
        return;
    }
    
    #--- Open, Read & Close the file ----
    my @my_lines = LoadTxt($my_filename);
    if ($#my_lines < 1 ) {
            print "ERROR: Failed to get values in $my_filename.\n";
            return;
    }
                
    #--- Check if the same line already exists or not.
    for ($i=0; $i<=$#my_lines;$i++) {
    
        if ($my_lines[$i][0] ne $my_domain.".") { next;}
        if ($my_lines[$i][1] ne $my_adr) {next;}
        
        # delete the line if existing.
        $ret = delete_file($my_filename, $my_lines[$#my_lines][2], "");
        return $ret;
    }
    return ;
}

#=================================
# sub LoadTxt :Arg([0]:file name)
#       (Load a configuration file.)
#=================================
sub LoadTxt {
    my($name)=@_;
    my @AAAA_lines;


    # Load common parameter
    open(ZONE_FILE, $name);
    @whole_text = <ZONE_FILE>;
    close(ZONE_FILE);

    my $acnt = 0;
    for( $loop=0 ; $loop <= $#whole_text ; $loop++ ) {

        $_ = $whole_text[$loop];
        
        # comment line
        if( /^\s*;/ ){next;}
        # parameter line
        if( /^(\S+)\.(\S+)\s+(\S*)\s*$/ ){
#            SetCTInfo("CFG,$1,$2" ,$3);
        }
        elsif( /^(\S+)\s+IN\s+AAAA\s+(\S*)\s*$/ ){
            $AAAA_lines[$acnt][0]=$1;
            $AAAA_lines[$acnt][1]=$2;
            $AAAA_lines[$acnt][2]=$loop+1;
            $acnt++;
        }
        elsif( /^(\S+)\s+(\S*)\s*$/ ){
#            SetCTInfo("CFG,$1" ,$2);
        }
    }
    
    return @AAAA_lines;
}

#=================================
#  update_file (1.file name, 2. line number for insert, 
#               3. new line text )
#=================================

sub update_file {

    my ($old, $posi, $new_line) = @_;
#    my $new = "$file.tmp.$$";
    my $new = "$old.tmp.$$";
#    my $bak = "$file.orig";
    my $bak = "$old.orig";
    
    open(OLD, "< $old")  or die "can't open $old: $!";
    open(NEW, "> $new")  or die "can't open $new: $!";
    
    # Correct typos, preserving case
    while (<OLD>) {
        (print NEW $_)   or die "can't write to $new: $!";
        if ($. == $posi) {
            print NEW $new_line;
        }
    }
    close(OLD)           or die "can't close $old: $!";
    close(NEW)           or die "can't close $new: $!";

	print "new = $new\n";
	print "bak = $bak\n";
	print "old = $old\n";

#    rename($old, $bak)   or die "can't rename $old to $bak: $!";
    move($old, $bak)   or die "can't rename $old to $bak: $!";
#    rename($new, $old)   or die "can't rename $new to $old: $!";
    move($new, $old)   or die "can't rename $new to $old: $!";
    unlink($bak);
    
    return 1;
}

#=================================
#  delete_file (1.file name, 2. line number for delete, 
#               3. (empty) )
#=================================
sub delete_file {

    my ($old, $posi, $new_line) = @_;
    my $new = "$old.tmp.$$";
    my $bak = "$old.orig";
            
    open(OLD, "< $old")  or die "can't open $old: $!";
    open(NEW, "> $new")  or die "can't open $new: $!";

    # Correct typos, preserving case
    while (<OLD>) {
        if ($. == $posi) { next; }
        (print NEW $_)   or die "can't write to $new: $!";
    }
    close(OLD)           or die "can't close $old: $!";
    close(NEW)           or die "can't close $new: $!";

	print "new = $new\n";
	print "bak = $bak\n";
	print "old = $old\n";


#    rename($old, $bak)   or die "can't rename $old to $bak: $!";
    move($old, $bak)   or die "can't rename $old to $bak: $!";
#    rename($new, $old)   or die "can't rename $new to $old: $!";
    move($new, $old)   or die "can't rename $new to $old: $!";
    
    unlink($bak);
    
    return 1;
    
}
1
