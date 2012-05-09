use strict;
use warnings;
use Test::More;
use Test::Exception;

# If no items and no totals throw exception

use Business::CyberSource::Request::Authorization;

throws_ok {
my $req0
	= Business::CyberSource::Request::Authorization->new({
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
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});
} qr/Attribute \(country\)/, 'country invalid';

throws_ok {
my $req1
	= Business::CyberSource::Request::Authorization->new({
		production     => 0,
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
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});
} qr/zip code is required for US or Canada/, 'us/ca require a zip code';

throws_ok {
my $req2
	= Business::CyberSource::Request::Authorization->new({
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
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});
} qr/you must define either items or total/, 'check either items or total';

done_testing;
