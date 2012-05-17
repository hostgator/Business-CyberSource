use strict;
use warnings;
use Test::More;
use Test::Fatal;

use Module::Runtime qw( use_module );
my $credit_card
	= new_ok( use_module('Business::CyberSource::CreditCard') => [{
		account_number => '4111-1111-1111-1111',
		expiration     => {
			month => 5,
			year  => 2012
		},
	}]);

my $authc = use_module('Business::CyberSource::Request::Authorization');

# If no items and no totals throw exception

my $exception0
	= exception { $authc->new({
		reference_code => 't003-1',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'blerg',
		total          => 45.95,
		email          => 'xenoterracide@gmail.com',
		currency       => 'USD',
		card           => $credit_card,
	})
};

like $exception0, qr/Attribute \(country\)/, 'country invalid';

my $exception1
	= exception { $authc->new({
		reference_code => 't003-2',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 3000.00,
		currency       => 'USD',
		card           => $credit_card,
	});
};

like $exception1, qr/zip code is required for US or Canada/, 'us/ca require a zip code';

my $exception2
	= exception { $authc->new({
		reference_code => 't108',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		currency       => 'USD',
		card           => $credit_card,
	});
};

like $exception2, qr/you must define either items or total/, 'check either items or total';

done_testing;
