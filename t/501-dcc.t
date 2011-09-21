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

use Business::CyberSource::Request::DCC;
use Business::CyberSource::Request::Authorization;

my $dcc_req
	= Business::CyberSource::Request::DCC->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		production     => 0,
		reference_code => 't501',
		currency       => 'USD',
		credit_card    => '4205260000000005',
		cc_exp_month   => '04',
		cc_exp_year    => '2012',
		total          => '1.00',
		foreign_currency => 'JPY',
	});

my $dcc;
$dcc = $dcc_req->submit;
ok ( $dcc_req->trace, 'trace exists' );

ok( $dcc, 'authorization response exists' );

note( $dcc_req->trace->printRequest  );
note( $dcc_req->trace->printResponse );

ok( $dcc->reference_code, 'reference code exists' );
is( $dcc->request_specific_reason_code, 100, 'DCC Reason code is 100' );
is( $dcc->foreign_currency, 'JPY', 'check foreign currency' );
is( $dcc->foreign_amount, 116, 'check foreign amount' );
is( $dcc->currency, 'USD', 'check currency' );
is( $dcc->dcc_supported, 1, 'check dcc supported' );
is( $dcc->exchange_rate, 116.4344, 'check exchange rate' );
is( $dcc->exchange_rate_timestamp, '20090101 00:00', 'check exchange timestamp' );
is( $dcc->valid_hours, 11229, 'check valid hours' );
is( $dcc->margin_rate_percentage, 03.0000, 'check margin rate percentage' );

done_testing;
