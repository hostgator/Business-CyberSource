use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_MM
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_YYYY
	PERL_BUSINESS_CYBERSOURCE_DCC_MASTERCARD
);
use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $card = $t->resolve(
		service => '/credit_card/object',
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
		reference_code   => 'test-dcc-authorization-' . time,
		currency         => 'USD',
		card             => $card,
		total            => '1.00',
		foreign_currency => 'EUR',
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
		first_name       => 'Caleb',
		last_name        => 'Cushing',
		street           => 'somewhere',
		city             => 'Houston',
		state            => 'TX',
		zip              => '77064',
		country          => 'US',
		email            => 'xenoterracide@gmail.com',
		total            => $dcc_req->total,
		currency         => $dcc->currency,
		foreign_currency => $dcc->foreign_currency,
		foreign_amount   => $dcc->foreign_amount,
		exchange_rate    => $dcc->exchange_rate,
		dcc_indicator    => 1,
		card             => $card,
		exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
		}]);

my $auth_res = $client->run_transaction( $auth_req );

ok $auth_res->is_accepted, 'card authorized'
	or diag $auth_res->reason_text;


my $cap_req
	= new_ok( use_module( 'Business::CyberSource::Request::Capture') => [{
		reference_code   => $dcc->reference_code,
		total            => $dcc_req->total,
		currency         => $dcc->currency,
		foreign_currency => $dcc->foreign_currency,
		foreign_amount   => $dcc->foreign_amount,
		exchange_rate    => $dcc->exchange_rate,
		dcc_indicator    => 1,
		request_id       => $auth_res->request_id,
		exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
	}]);

my $cap_res = $client->run_transaction( $cap_req );

my $cred_req
	= new_ok( use_module( 'Business::CyberSource::Request::FollowOnCredit') => [{
		reference_code   => $dcc->reference_code,
		total            => $dcc_req->total,
		currency         => $dcc->currency,
		foreign_currency => $dcc->foreign_currency,
		foreign_amount   => $dcc->foreign_amount,
		exchange_rate    => $dcc->exchange_rate,
		dcc_indicator    => 1,
		request_id       => $cap_res->request_id,
		exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
	}]);

my $cred_res = $client->run_transaction( $cred_req );

is( $cred_res->is_accepted, 1, 'check that credit decicion is ACCEPT')
	or diag $cred_res->reason_text;

is( $cred_res->amount, '1.00', 'check that credit amount is 1.00' );

done_testing;
