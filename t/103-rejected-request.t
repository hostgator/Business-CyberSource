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
		reference_code => '99',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '432 nowhere ave.',
		city           => 'Detroit',
		state          => 'MI',
		zip            => '77064',
		country        => 'US',
		email          => 'foobar@example.com',
		total          => 15.95,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '12',
		cc_exp_year    => '2025',
		production     => 1,
	});

my $ret = $req->submit;

is( $ret->decision,       'REJECT', 'check decision'       );
is( $ret->reference_code, '99',     'check reference_code' );
is( $ret->reason_code,     203,     'check reason_code'    );
is( $ret->currency,       'USD',    'check currency'       );
is( $ret->amount,         '15.95',    'check amount'        );
is( $ret->avs_code,       'U',       'check avs_code'      );
is( $ret->avs_code_raw,   'U',       'check avs_code_raw'  );
is( $ret->processor_response, '51',  'check processor_response');

ok( $ret->request_id,    'check request_id exists'    );
ok( $ret->request_token, 'check request_token exists' );
ok( $ret->datetime,      'check datetime exists'      );
done_testing;
