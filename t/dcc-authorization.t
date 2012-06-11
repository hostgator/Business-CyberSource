use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_MM
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_YYYY
	PERL_BUSINESS_CYBERSOURCE_DCC_MASTERCARD
);
use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $billto = $t->resolve( service => '/helper/bill_to');
my $card
	= $t->resolve(
		service => '/helper/card',
		parameters => {
			account_number => $ENV{PERL_BUSINESS_CYBERSOURCE_DCC_MASTERCARD},
			expiration     => {
				month => $ENV{PERL_BUSINESS_CYBERSOURCE_DCC_CC_MM},
				year  => $ENV{PERL_BUSINESS_CYBERSOURCE_DCC_CC_YYYY},
			},
		},
);

my $dcc_req
	= new_ok( use_module( 'Business::CyberSource::Request::DCC') => [{
		reference_code  => 'test-dcc-authorization-' . time,
		card            => $card,
		purchase_totals => {
			currency         => 'USD',
			total            => '1.00',
			foreign_currency => 'EUR',
		},
	}]);


my $client = $t->resolve( service => '/client/object' );

my $dcc = $client->run_transaction( $dcc_req );

is( $dcc->foreign_currency, 'EUR', 'dcc response foreign_currency' );
is( $dcc->foreign_amount,  '0.88', 'dcc response foreign_amount'   );
is( $dcc->exchange_rate, '0.8810', 'dcc response exchange_rate'    );
is( $dcc->dcc_supported,        1, 'dcc response dcc_supported'    );

my $authc = use_module('Business::CyberSource::Request::Authorization');

my $auth_req
	= new_ok( $authc => [{
		reference_code   => $dcc->reference_code,
		bill_to          => $billto,
		card             => $card,
		dcc_indicator    => 1,
		purchase_totals  => {
			total            => $dcc_req->purchase_totals->total,
			currency         => $dcc->currency,
			foreign_currency => $dcc->foreign_currency,
			foreign_amount   => $dcc->foreign_amount,
			exchange_rate    => $dcc->exchange_rate,
			exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
		},
	}]);

my $auth_res = $client->run_transaction( $auth_req );

ok $auth_res->is_accepted, 'card authorized'
	or diag $auth_res->reason_text;


my $cap_req
	= new_ok( use_module( 'Business::CyberSource::Request::Capture') => [{
		reference_code   => $dcc->reference_code,
		purchase_totals  => $auth_req->purchase_totals,
		dcc_indicator    => 1,
		service          => {
			request_id => $auth_res->request_id,
		},
	}]);

my $cap_res = $client->run_transaction( $cap_req );

my $cred_req
	= new_ok( use_module( 'Business::CyberSource::Request::FollowOnCredit') => [{
		bill_to          => $billto,
		card             => $card,
		reference_code   => $dcc->reference_code,
		purchase_totals  => $auth_req->purchase_totals,
		dcc_indicator    => 1,
		service  => { request_id => $cap_res->request_id },
	}]);

my $cred_res = $client->run_transaction( $cred_req );

is( $cred_res->is_accepted, 1, 'check that credit decicion is ACCEPT')
	or diag $cred_res->reason_text;

is( $cred_res->amount, '1.00', 'check that credit amount is 1.00' );

done_testing;
