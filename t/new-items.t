use strict;
use warnings;
use Test::More;
use Test::Moose;
use Class::Load qw( load_class );

my $item
	= new_ok( load_class('Business::CyberSource::RequestPart::Item') => [{
		unit_price => 3.25,
	}]);

does_ok( $item, 'MooseX::RemoteHelper::CompositeSerialization'  );
can_ok ( $item, 'serialize'                                     );

my %expected_serialized
	= (
		unitPrice => 3.25,
		quantity  => 1,
	);

is_deeply( $item->serialize, \%expected_serialized, 'serialized');
is( ref $item->serialize,    'HASH', 'serialize type'           );

is( $item->unit_price,       3.25,   '->unit_price'             );
is( $item->quantity,         1,      '->quantity'               );

done_testing;
