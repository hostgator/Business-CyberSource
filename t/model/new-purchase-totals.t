use strict;
use warnings;
use Test::More;
use Test::Moose;
use Class::Load qw( load_class );

my $ptotal
	= new_ok( load_class('Business::CyberSource::RequestPart::PurchaseTotals') => [{
		total    => 5.00,
		currency => 'USD',
	}]);

is $ptotal->total,    5.00,  '->total';
is $ptotal->currency, 'USD', '->currency';


my %expected_serialized
	= (
		grandTotalAmount => 5.00,
		currency         => 'USD',
	);

is_deeply( $ptotal->serialize, \%expected_serialized, 'serialized'          );

done_testing;
