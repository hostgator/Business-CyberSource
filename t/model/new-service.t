use strict;
use warnings;
use Test::More;

use Class::Load qw( load_class );

my $s0 = new_ok( load_class('Business::CyberSource::RequestPart::Service'));

can_ok( $s0, 'serialize' );

my %expected_serialized = ( run => 'true' );

is_deeply( $s0->serialize, \%expected_serialized, 'serialized' );

done_testing;
