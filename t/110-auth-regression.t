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
		production     => 0,
		reference_code => 't101',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => undef,
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 3000.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});

my $ret;

eval { $ret = $req0->submit };

note( $req0->trace->printRequest  );
note( $req0->trace->printResponse );

is( $ret->is_success,     1,        'check success'        );
is( $ret->decision,       'ACCEPT', 'check decision'       );
is( $ret->reference_code, 't101',   'check reference_code' );
is( $ret->reason_code,     100,     'check reason_code'    );
is( $ret->currency,       'USD',    'check currency'       );
