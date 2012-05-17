use strict;
use warnings;
use Test::More;
use Module::Runtime qw( use_module );

my $cardc = use_module('Business::CyberSource::CreditCard');
my $dtc   = use_module('Business::CyberSource::Request::Authorization');

my @test_pairs = (
	[ '4111111111111111' => '001' ],
	[ '5555555555554444' => '002' ],
	[ '3566111111111113' => '007' ],
);

foreach ( @test_pairs ) {
	my ( $acct_num, $type_code ) = @{ $_ };

	my $cc = new_ok( $cardc => [{
		account_number => $acct_num,
		expiration     => {
			month => 9,
			year  => 2025,
		},
	}]);

	my $dto = new_ok( $dtc => [{
		reference_code => my $code = $dtc . '->new',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 3000.00,
		currency       => 'USD',
		card           => $cc,
	}]);

	can_ok( $dto, 'submit' );
	can_ok( $dto, 'serialize' );

	is( ref( $dto->serialize ), 'HASH', 'serialize returns a hashref'     );
	is( $dto->reference_code, $code,       $dtc .'->reference_code'       );

	is( $dto->first_name,     'Caleb',     $dtc .'->first_name'           );
	is( $dto->last_name,      'Cushing',   $dtc .'->last_name'            );
	is( $dto->street,         'somewhere', $dtc .'->street'               );
	is( $dto->city,           'Houston',   $dtc .'->city'                 );
	is( $dto->state,          'TX',        $dtc .'->state'                );
	is( $dto->country,        'US',        $dtc .'->country'              );
	is( $dto->total,          '3000',      $dtc .'->total'                );
	is( $dto->currency,       'USD',       $dtc .'->currency'             );
	is( $dto->email,       'xenoterracide@gmail.com', $dtc .'->email'     );

	is( $dto->cc_exp_month,   9,           $dtc .'->cc_exp_month'         );
	is( $dto->cc_exp_year,    2025,        $dtc .'->cc_exp_year'          );
	is( $dto->card_type,      $type_code,  $dtc ."->card_type $type_code" );
	is( $dto->credit_card,    $acct_num,   $dtc ."->credit_card $acct_num");
}

done_testing;
