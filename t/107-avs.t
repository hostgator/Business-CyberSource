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

use Business::CyberSource::Request::Authorization;

my $req0
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
		total          => 5000.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '12',
		cc_exp_year    => '1998',
		production     => 0,
	});

my $ret0 = $req0->submit;

is( $ret0->decision,       'ACCEPT', 'check decision'       );
is( $ret0->reason_code,     100,     'check reason_code'    );
is( $ret0->auth_code,      '831000', 'check auth code'      ):
is( $ret0->avs_code,       'X',      'check avs_code'       );
is( $ret0->avs_code_raw,   'X',      'check avs_code_raw'   );


my $req1
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
		total          => 5005.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '12',
		cc_exp_year    => '2025',
		production     => 0,
	});

my $ret1 = $req1->submit;

is( $ret1->decision,       'ACCEPT', 'check decision'       );
is( $ret1->reason_code,    '200',    'check reason_code'    );
is( $ret1->auth_code,      '831000', 'check auth code'      );
is( $ret1->avs_code,       'N',      'check avs_code'       );
is( $ret1->avs_code_raw,   'N',      'check avs_code_raw'   );
is( $ret1->processor_response, '00', 'check processor response' );

done_testing;
