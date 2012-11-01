use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );

my $capture =
	new_ok( use_module('Business::CyberSource::Request::Capture') => [{
		reference_code => 'not sending',
		service => {
			request_id => 42,
		},
		purchase_totals => {
			total    => 2018.00,
			currency => 'USD',
		}
	}]);

can_ok $capture, 'serialize';

my %expected = (
	merchantReferenceCode => 'not sending',
	purchaseTotals        => {
		grandTotalAmount => 2018.00,
		currency         => 'USD',
	},
	ccCaptureService=> {
		authRequestID => 42,
		run          => 'true',
	},
);

is_deeply $capture->serialize, \%expected, 'serialize';

done_testing;
