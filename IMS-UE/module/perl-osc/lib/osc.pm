package osc;

use strict;
use warnings;
use base qw/DynaLoader/;

our $VERSION = '0.01';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

=head1 NAME

osc - perl interface for Open Sigcomp

=head1 SYNOPSIS

    use osc;

    my $stateHandler = new osc::StateHandler(8192,16,8192);
    $stateHandler->useSipDictionary();
    my $stack = new osc::Stack($stateHandler);
    my $compressor = new osc::DeflateCompressor($stateHandler);
    $stack->addCompressor($compressor);
  
    my $sigcompMessage = $stack->compressMessage($data, length($data), $id);
    my $compress = $sigcomMessage->getDatagramMessage();
    my $leng = $sigcomMessage->getDatagramLength();

=head1 DESCRIPTION

This is perl interface for Open Sigcomp.

For more information about Open Sigcomp

=head1 AUTHOR

NTT-AT, cerezaware  E<lt>ipv6ready-info@ipv6ready.orgE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, NTT-AT.  All rights reserved.

=cut

1;

