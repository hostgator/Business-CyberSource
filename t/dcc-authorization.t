use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_MM
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_YYYY
	PERL_BUSINESS_CYBERSOURCE_DCC_MASTERCARD
);
use Test::Exception;

use Module::Runtime qw( use_module );

my ( $credit_card, $cc_mon, $cc_year ) = (
	$ENV{PERL_BUSINESS_CYBERSOURCE_DCC_MASTERCARD},
	$ENV{PERL_BUSINESS_CYBERSOURCE_DCC_CC_MM},
	$ENV{PERL_BUSINESS_CYBERSOURCE_DCC_CC_YYYY},
);

my $client
	= new_ok( use_module( 'Business::CyberSource::Client') => [{
		username   => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		password   => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
		production => 0,
	}]);


my $dcc_req
	= new_ok( use_module( 'Business::CyberSource::Request::DCC') => [{
		reference_code => 'test-dcc-authorization-' . time,
		currency       => 'USD',
		credit_card    => $credit_card,
		cc_exp_month   => $cc_mon,
		cc_exp_year    => $cc_year,
		total          => '1.00',
		foreign_currency => 'EUR',
	}]);


my $dcc;

lives_ok { $dcc = $client->run_transaction( $dcc_req ) }
	'dcc run_transaction'
	or diag( '!!!: please ensure that cybersource has enabled DCC '
	. 'for your account' )
	;

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
		credit_card      => $dcc_req->credit_card,
		total            => $dcc_req->total,
		currency         => $dcc->currency,
		foreign_currency => $dcc->foreign_currency,
		foreign_amount   => $dcc->foreign_amount,
		exchange_rate    => $dcc->exchange_rate,
		cc_exp_month     => $cc_mon,
		cc_exp_year      => $cc_year,
		dcc_indicator    => 1,
		exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
		}]);

my $auth_res;
lives_ok { $auth_res = $client->run_transaction( $auth_req ) }
	'authorization run_transaction';

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

my $cap_res;
lives_ok { $cap_res = $client->run_transaction( $cap_req ) }
	'capture run_transaction';

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

my $cred_res;
lives_ok { $cred_res = $client->run_transaction( $cred_req ) }
	$client .'->runtransaction';

is( $cred_res->is_accepted, 1, 'check that credit decicion is ACCEPT')
	or diag $cred_res->reason_text;

is( $cred_res->amount, '1.00', 'check that credit amount is 1.00' );

done_testing;
