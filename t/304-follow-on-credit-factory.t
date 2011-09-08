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

use Business::CyberSource::Request;

my $factory
	= Business::CyberSource::Request->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		production     => 0,
	});

ok( $factory, 'factory exists' );

my $req
	= $factory->create( 'Authorization',
	{
		reference_code => '1984',
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

my $capture
	= $factory->create( 'Capture',
	{
		reference_code => $req->reference_code,
		request_id     => $res->request_id,
		total          => $res->amount,
		currency       => $res->currency,
	})
	;

my $cres = $capture->submit;

ok( $cres, 'capture response exists' );

my $credit_req
	= $factory->create( 'FollowOnCredit',
	{
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

is( $credit->reference_code, '1984', 'check response reference code' );
is( $credit->decision,       'ACCEPT', 'check decision'       );
is( $credit->reason_code,     100,     'check reason_code'    );
is( $credit->currency,       'USD',    'check currency'       );
is( $credit->amount,         '5.00',    'check amount'        );

ok( $credit->request_id,    'check request_id exists'    );
ok( $credit->datetime,      'check datetime exists'      );
done_testing;
