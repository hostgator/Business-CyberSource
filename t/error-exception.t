use strict;
use warnings;
use Test::More;
use Test::Fatal;

use Module::Runtime qw( use_module );

my $factory = new_ok( use_module('Business::CyberSource::Factory::Response') );

can_ok( $factory, 'create' );

my $authc = use_module('Business::CyberSource::Request::Authorization');

my $credit_card
	= new_ok( use_module('Business::CyberSource::CreditCard') => [{
		account_number => '4111-1111-1111-1111',
		expiration     => {
			month => 5,
			year  => 2012
		},
	}]);

my $dto
	= new_ok( $authc => [{
		reference_code => 'random',
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
		card           => $credit_card,
	}]);

my $answer = {
	result => {
		decision     => 'ERROR',
		requestID    => '3367880563740176056428',
		reasonCode   => '150',
		requestToken => 'AhhRbwSRbSV2sdn3CQDYD6QQqAAaSZV0ekrReBEA5lFa',
	},
};

my $exception = exception { $factory->create( $dto, $answer ) };

isa_ok( $exception, 'Business::CyberSource::Exception' );

like(  "$exception",         qr/error/i, 'stringify'   );
is  (   $exception->decision,'ERROR',    'decision'    );
is  (   $exception+0,        150,        'numerify'    );
is  (   $exception->value ,  150,        'value'       );

done_testing;
