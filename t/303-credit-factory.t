#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;

plan skip_all
	=> 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!'
	unless $CYBS_ID and $CYBS_KEY
	;

use Business::CyberSource::Request;

my $factory
	= Business::CyberSource::Request->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		production     => 0,
	});

ok( $factory, 'factory exists' );

my $req = $factory->create(
	'StandAloneCredit',
	{
		reference_code => '1021',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street1        => 'somewhere',
		street2        => 'B',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		ip_address     => '10.0.0.8',
		total          => 9.84,
		currency       => 'USD',
		credit_card    => '3566 1111 1111 1113',
		cc_exp_month   => '02',
		cc_exp_year    => '2025',
	}
);

ok( $req, 'request exists' );

my $res = $req->submit;

ok( $res, 'response exists' );

is( $res->decision, 'ACCEPT', 'response is ACCEPT' );

done_testing;
