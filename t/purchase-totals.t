use strict;
use warnings;
use Test::More;
use Test::Moose;
use Module::Runtime qw( use_module );

my $ptotal
	= new_ok( use_module('Business::CyberSource::RequestPart::PurchaseTotals') => [{
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
