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
		reference_code => '500',
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2015',
		total          => '39.95',
		foreign_currency => 'AUD',
	});

my $dcc;
eval { $dcc = $dcc_req->submit; };
ok ( $dcc_req->trace, 'trace exists' );

#ok( $dcc, 'authorization response exists' );

note( $dcc_req->trace->printRequest  );
note( $dcc_req->trace->printResponse );

done_testing;
