use strict;
use warnings;
use Test::More;
use Test::Moose;
use Test::Method;
use Module::Runtime qw( use_module );

my $dto
	= new_ok( use_module('Business::CyberSource::RequestPart::PurchaseTotals') => [{
		total    => 5.00,
		currency => 'USD',
	}]);

my %expected
	= (
		grandTotalAmount => 5.00,
		currency         => 'USD',
	);

method_ok $dto, total     => [], 5.00;
method_ok $dto, currency  => [], 'USD';
method_ok $dto, serialize => [], \%expected;

done_testing;
