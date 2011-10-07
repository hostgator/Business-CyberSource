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
		total          => 3000.37,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '12',
		cc_exp_year    => '2025',
		production     => 0,
	});

my $ret0 = $req0->submit;

note( $req0->trace->printResponse );

is( $ret0->is_success,     0,        'check success'        );
is( $ret0->decision,       'REJECT', 'check decision'       );
is( $ret0->reason_code,     202,     'check reason_code'    );
is(
	$ret0->reason_text,
	'Expired card. You might also receive this if the expiration date you '
		. 'provided does not match the date the issuing bank has on file'
		,
	'check reason_text',
);
is( $ret0->processor_response, '54', 'check processor response' );

ok( $ret0->request_id,    'check request_id exists'    );
ok( $ret0->request_token, 'check request_token exists' );

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
		total          => 3000.04,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '12',
		cc_exp_year    => '2025',
		production     => 0,
	});

my $ret1 = $req1->submit;

note( $req1->trace->printResponse );

is( $ret1->decision,       'REJECT', 'check decision'       );
is( $ret1->reason_code,     201,     'check reason_code'    );
is(
	$ret1->reason_text,
	'The issuing bank has questions about the request. You do not '
	. 'receive an authorization code programmatically, but you might '
	. 'receive one verbally by calling the processor'
	,
	'check reason_text',
);

my $req2
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
		total          => 35.00,
		currency       => 'USD',
		credit_card    => '6304 9850 2809 0561 515',
		cc_exp_month   => '12',
		cc_exp_year    => '2010',
		production     => 0,
	});

my $ret2 = $req2->submit;

note( $req2->trace->printResponse );

is( $ret2->accepted,     0,        'check success'        );
is( $ret2->decision,       'REJECT', 'check decision'       );
is( $ret2->reason_code,     202,     'check reason_code'    );

done_testing;
