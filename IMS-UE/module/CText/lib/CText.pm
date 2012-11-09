package CText;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use CText ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw(MilenageF1 MilenageF2345 MilenageF1star MilenageF5star ComputeOPc MilenageXOR);

our $VERSION = '1.00';

require XSLoader;
XSLoader::load('CText', $VERSION);

# Preloaded methods go here.

1;
__END__

=head1 NAME

CText - Perl extension for Comformance Terster

=head1 SYNOPSIS

  use CText;

  $K   ='465b5ce8b199b49faa5f0a2ee238a6bc';
  $OP  ='cdc202d5123e20f62b6d676ac72cb318';
  $RAND='23553cbe9637a89d218ae64dae47bf35';
  $AMF ='b9b9';
  $SEQ ='ff9bb4d0b607';
  $OPC ='cd63cb71954a9f4e48a5994e37a02baf';

  # F1   4a9ffac354dfafb3
  # F1*  01cfaf9ec4e871e9
  # F2   a54211d5e3ba50bf
  # F3   b40ba9a3c58b2a05bbf0d987b21bf8cb
  # F4   f769bcd751044604127672711c6d3441
  # F5   aa689c648370
  # F5*  451e8beca43b

  ComputeOPc($OP,$K,$out);
  printf("OPC = %s\n",$out);
  MilenageF1($OP, $K, $RAND, $SEQ, $AMF, $mac);
  printf("F1 = %s\n",$mac);
  MilenageF2345($OP, $K, $RAND, $res, $ck, $ik, $ak);
  printf("F2 = %s\n",$res);
  printf("F3 = %s\n",$ck);
  printf("F4 = %s\n",$ik);
  printf("F5 = %s\n",$ak);
  MilenageF1star($OP,$K,$RAND,$SEQ, $AMF,$xmac);
  MilenageF5star($OP,$K,$RAND,$ak);
  printf("F1*= %s\n",$xmac);
  printf("F5*= %s\n",$ak);

=head1 AUTHOR

NTT-AT, cerezaware  E<lt>ipv6ready-info@ipv6ready.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2008, NTT-AT  All Rights Reserved.  

=cut
