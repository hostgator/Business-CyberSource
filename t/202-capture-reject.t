#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;

use Business::CyberSource::Request::Authorization;
use Business::CyberSource::Request::Capture;
use SOAP::Lite +trace => [ 'debug' ] ;

my $req
	= Business::CyberSource::Request::Authorization->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => '84',
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
	= Business::CyberSource::Request::Capture->new({
		username       => $req->username,
		password       => $req->password,
		reference_code => $req->reference_code,
		request_id     => $res->request_id,
		total          => $res->amount,
		currency       => $res->currency,
		production     => 1,
	})
	;

my $cres = $capture->submit;

ok( $cres, 'capture response exists' );

is( $cres->decision, 'REJECT', 'check decision' );
is( $cres->reason_code, 102, 'check reason_code' );

ok( $cres->request_id, 'check request_id exists' );

done_testing;
