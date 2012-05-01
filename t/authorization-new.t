use strict;
use warnings;
use Test::More;

use Business::CyberSource::Request::Authorization;

my $req0
	= Business::CyberSource::Request::Authorization->new({
		username       => 'test',
		password       => 'test',
		production     => 0,
		reference_code => 't100',
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
	});

ok( $req0, 'authorization object created' );

done_testing;
