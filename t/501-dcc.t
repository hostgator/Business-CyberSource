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
use SOAP::Lite +trace => [ 'debug' ] ;

my $dcc_req
	= Business::CyberSource::Request::DCC->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => '500',
#		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		foreign_currency => 'AUD',
	});

my $dcc = $dcc_req->submit;

ok( $dcc, 'authorization response exists' );
