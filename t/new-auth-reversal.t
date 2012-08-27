use strict;
use warnings;
use Test::More;

use Class::Load qw( load_class );

my $authrevc = load_class('Business::CyberSource::Request::AuthReversal');

my $dto
	= new_ok( $authrevc => [{
		reference_code => 'notarealcode',
		service => {
			request_id => 'notarealid',
		},
		purchase_totals => {
			total    => '3000.00',
			currency => 'USD',
		},
	}]);

can_ok $dto, 'serialize';

my %expected = (
	merchantReferenceCode => 'notarealcode',
	ccAuthReversalService => {
		run           => 'true',
		authRequestID => 'notarealid',
	},
	purchaseTotals => {
		grandTotalAmount => '3000.00',
		currency         => 'USD',
	},
);

is_deeply( $dto->serialize, \%expected, 'serialize' );

done_testing;
