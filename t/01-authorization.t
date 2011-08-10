#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;

use Business::CyberSource::Request::Authorization;

my $req
	= Business::CyberSource::Request::Authorization->new({
		username => $CYBS_ID,
		password => $CYBS_KEY,
		reference_code => '42',
		first_name => 'Caleb',
		last_name  => 'Cushing',
		street     => '100 somewhere rd',
		city       => 'Houston',
		state      => 'TX',
		zip        => '77064',
		country    => 'US',
		email      => 'xenoterracide@gmail.com',
		ip         => '127.0.0.1',
		unit_price => 5.01,
		quantity   => 1,
		currency   => 'USD',
	});

is( $req->username, $CYBS_ID,  'check username' );
is( $req->password, $CYBS_KEY, 'check key'      );
is( $req->client_version,
	$Business::CyberSource::VERSION,
	'check client_version exists'
);
is( $req->client_library, 'Business::CyberSource', 'check client_library' );
ok( $req->client_env, 'check client_env exists' );
note( $req->client_version );
note( $req->client_library );
note( $req->client_env     );
is( $req->reference_code, '42',      'check reference_code' );
is( $req->first_name,     'Caleb',   'check first_name'     );
is( $req->last_name,      'Cushing', 'check first_name'     );

$req->submit;
done_testing;
