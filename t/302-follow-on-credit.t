#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;
#use SOAP::Lite +trace => [ 'debug' ] ;

plan skip_all
	=> 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!'
	unless $CYBS_ID and $CYBS_KEY
	;

use Business::CyberSource::Request::Authorization;
use Business::CyberSource::Request::Capture;
use Business::CyberSource::Request::Credit;

my $req
	= Business::CyberSource::Request::Authorization->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => '420',
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
		production     => 0,
	})
	;

my $res = $req->submit;

my $capture
	= Business::CyberSource::Request::Capture->new({
		username       => $req->username,
		password       => $req->password,
		reference_code => $req->reference_code,
		request_id     => $res->request_id,
		total          => $res->amount,
		currency       => $res->currency,
		production     => 0,
	})
	;

my $cres = $capture->submit;

ok( $cres, 'capture response exists' );

my $credit_req
	= Business::CyberSource::Request::Credit->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => $req->reference_code,
		total          => 5.00,
		currency       => 'USD',
		request_id     => $cres->request_id,
		production     => 0,
	})
	;

my $credit = $credit_req->submit;

ok( $credit, 'credit response exists' );

is( $credit->reference_code, '420', 'check response reference code' );
is( $credit->decision,       'ACCEPT', 'check decision'       );
is( $credit->reason_code,     100,     'check reason_code'    );
is( $credit->currency,       'USD',    'check currency'       );
is( $credit->amount,         '5.00',    'check amount'        );

ok( $credit->request_id,    'check request_id exists'    );
ok( $credit->datetime,      'check datetime exists'      );
done_testing;
