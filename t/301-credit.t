#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;

use Business::CyberSource::Request::Credit;

my $req
	= Business::CyberSource::Request::Credit->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => '360',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		ip             => '192.168.100.2',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	})
	;

my $res = $req->submit;

is( $req->username, $CYBS_ID,  'check username' );
is( $req->password, $CYBS_KEY, 'check key'      );

# check billing info
is( $req->reference_code, '360',        'check reference_code' );
is( $req->first_name,     'Caleb',     'check first_name'     );
is( $req->last_name,      'Cushing',   'check first_name'     );
is( $req->street,         'somewhere', 'check street'         );
is( $req->city,           'Houston',   'check city'           );
is( $req->state,          'TX',        'check state'          );
is( $req->country,        'US',        'check country'        );

is( $req->ip,    '192.168.100.2',          'check ip'    );
is( $req->email, 'xenoterracide@gmail.com', 'check email' );

is( $req->total,      5, 'check total'      );

is( $req->currency, 'USD', 'check currency' );

is( $req->credit_card,  '4111-1111-1111-1111', 'check credit card number' );

is( $req->cc_exp_month, '09',   'check credit card expiration year'  );
is( $req->cc_exp_year,  '2025', 'check credit card expiration month' );

ok( $res, 'request response exists' );

is( $res->reference_code, '360', 'check response reference code' );

done_testing;
