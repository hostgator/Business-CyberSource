use strict;
use warnings;
use Test::More;
use Test::Moose;
use Module::Runtime qw( use_module );

my $item
	= new_ok( use_module('Business::CyberSource::Helper::Item') => [{
		id         => 0,
		unit_price => 3.25,
	}]);

does_ok( $item, 'MooseX::RemoteHelper::CompositeSerialization'  );
can_ok ( $item, 'serialize'                                     );

my %expected_serialized
	= (
		id        => 0,
		unitPrice => 3.25,
		quantity  => 1,
	);

is_deeply( $item->serialize, \%expected_serialized, 'serialized');
is( ref $item->serialize,    'HASH', 'serialize type'           );

is( $item->id,               0,      '->id'                     );
is( $item->unit_price,       3.25,   '->unit_price'             );
is( $item->quantity,         1,      '->quantity'               );

done_testing;
