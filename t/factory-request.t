use strict;
use warnings;
use Test::More;
use Test::Requires qw( MooseX::AbstractFactory );

use Class::Load qw( load_class );

my $factory = new_ok( load_class('Business::CyberSource::Factory::Request') );

can_ok( $factory, 'create' );

done_testing;
