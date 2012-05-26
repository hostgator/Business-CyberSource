use strict;
use warnings;
use Test::More;
use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $dtc   = use_module('Business::CyberSource::Request::Authorization');

my $t = new_ok( use_module('Test::Business::CyberSource') );

my @test_pairs = (
	[ '4111111111111111' => '001' ],
	[ '5555555555554444' => '002' ],
	[ '3566111111111113' => '007' ],
);

foreach ( @test_pairs ) {
	my ( $acct_num, $type_code ) = @{ $_ };

	my $dto = new_ok( $dtc => [{
		reference_code  => my $code = $dtc . '->new',
		billing_info    => $t->resolve( service  => '/helper/bill_to'),
		purchase_totals => $t->resolve( service => '/helper/purchase_totals'),
		card            => $t->resolve(
			service    => '/helper/card',
			parameters => {
				account_number => $acct_num,
			},
		),
	}]);

	can_ok( $dto, 'submit' );
	can_ok( $dto, 'serialize' );

	is( ref( $dto->serialize ), 'HASH', 'serialize returns a hashref'     );
	is( $dto->reference_code, $code,       $dtc .'->reference_code'       );
}

done_testing;
