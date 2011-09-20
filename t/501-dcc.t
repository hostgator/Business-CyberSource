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
		currency       => 'JPY',
		credit_card    => '4205260000000005',
		cc_exp_month   => '04',
		cc_exp_year    => '2012',
		total          => '1.00',
		foreign_currency => 'AUD',
	});

my $dcc;
eval { $dcc = $dcc_req->submit; };
ok ( $dcc_req->trace, 'trace exists' );

ok( $dcc, 'authorization response exists' );

note( $dcc_req->trace->printRequest  );
note( $dcc_req->trace->printResponse );

done_testing;
