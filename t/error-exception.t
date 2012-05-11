use strict;
use warnings;
use Test::More;
use Test::Fatal;

use Module::Runtime qw( use_module );

my $factory = new_ok( use_module('Business::CyberSource::ResponseFactory') );

can_ok( $factory, 'create' );

my $authc = use_module('Business::CyberSource::Request::Authorization');

my $auth_req
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
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	}]);

my $error = {
	result => {
		decision     => 'ERROR',
		requestID    => 'test',
		reasonCode   => '150',
		requestToken => 'dflkjdlkja',
	},
};

my $exception = exception { $factory->create( $error, $auth_req ) };

isa_ok( $exception, 'Business::CyberSource::Exception' );
like(  "$exception",         qr/error/i, 'stringify'   );
is  (   $exception->decision,'ERROR',    'decision'    );
is  (   $exception+0,        150,        'numerify'    );
is  (   $exception->value ,  150,        'value'       );

done_testing;
