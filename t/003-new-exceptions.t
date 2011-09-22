#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Test::More;
use Test::Exception;

# If no items and no totals throw exception

use Business::CyberSource::Request::Authorization;

throws_ok {
my $req0
	= Business::CyberSource::Request::Authorization->new({
		username       => 'foobar',
		password       => 'test',
		reference_code => 't108',
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
		production     => 0,
	});
} /Attribute (country)/, 'new threw exception ok';


done_testing;
