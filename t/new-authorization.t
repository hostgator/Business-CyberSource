use strict;
use warnings;
use Test::More;
use Module::Runtime qw( use_module );

my $dtc = use_module 'Business::CyberSource::Request::Authorization';

my $dto
	= new_ok( $dtc => [{
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
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	}]);

can_ok( $dto, 'submit' );
can_ok( $dto, 'serialize' );

is( ref( $dto->serialize ), 'HASH', 'serialize returns a hashref');

is( $dto->reference_code, $code,       $dtc .'->reference_code'  );
is( $dto->first_name,     'Caleb',     $dtc .'->first_name'      );
is( $dto->last_name,      'Cushing',   $dtc .'->last_name'       );
is( $dto->street,         'somewhere', $dtc .'->street'          );
is( $dto->city,           'Houston',   $dtc .'->city'            );
is( $dto->state,          'TX',        $dtc .'->state'           );
is( $dto->country,        'US',        $dtc .'->country'         );
is( $dto->total,          '3000',      $dtc .'->total'           );
is( $dto->currency,       'USD',       $dtc .'->currency'        );

is( $dto->cc_exp_month,   9,           $dtc .'->cc_exp_month'    );
is( $dto->cc_exp_year,    2025,        $dtc .'->cc_exp_year'     );
is( $dto->card_type,      '001',       $dtc . '->card_type'      );

is( $dto->credit_card, '4111111111111111', $dtc .'->credit_card' );
is( $dto->email,       'xenoterracide@gmail.com', $dtc .'->email');

done_testing;
