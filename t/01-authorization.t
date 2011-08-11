#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;

use Business::CyberSource::Request::Authorization;

my $req
	= Business::CyberSource::Request::Authorization->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => '1312837296777787',
		first_name     => 'Amiri',
		last_name      => 'Barksdale',
		street         => '15 Top Drive #12',
		city           => 'Los Angeles',
		state          => 'CA',
		zip            => '90064',
		country        => 'USA',
		email          => 'amiri@metalabel.com',
		ip             => '192.168.100.2',
		unit_price     => 5.00,
		quantity       => 1,
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		client => 'Perl',
		client_env => 'Linux',
		client_version => '5.014001',
	});

is( $req->username, $CYBS_ID,  'check username' );
is( $req->password, $CYBS_KEY, 'check key'      );
#is( $req->client_version,
#	$Business::CyberSource::VERSION,
#	'check client_version exists'
#);
#is( $req->client_library, 'Business::CyberSource', 'check client_library' );
#ok( $req->client_env, 'check client_env exists' );
#note( $req->client_version );
#note( $req->client_library );
#note( $req->client_env     );
#is( $req->reference_code, '42',      'check reference_code' );
#is( $req->first_name,     'Caleb',   'check first_name'     );
#is( $req->last_name,      'Cushing', 'check first_name'     );

$req->submit;
done_testing;
