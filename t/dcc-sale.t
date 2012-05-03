use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_MM
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_YYYY
	PERL_BUSINESS_CYBERSOURCE_DCC_VISA
);
use Test::Exception;

use Module::Runtime qw( use_module );

my ( $credit_card, $cc_mon, $cc_year ) = (
	$ENV{PERL_BUSINESS_CYBERSOURCE_DCC_VISA},
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
		reference_code   => 't503',
		currency         => 'USD',
		credit_card      => $credit_card,
		exp_month        => $cc_mon,
		exp_year         => $cc_year,
		total            => '1.00',
		foreign_currency => 'JPY',
	}]);

my $dcc;

lives_ok { $dcc = $client->run_transaction( $dcc_req ) }
	'dcc run_transaction'
	or diag( '!!!: please ensure that cybersource has enabled DCC '
	. 'for your account' )
	;

is( $dcc->foreign_currency, 'JPY', 'check foreign currency' );
is( $dcc->foreign_amount, 116, 'check foreign amount' );
is( $dcc->currency, 'USD', 'check currency' );
is( $dcc->dcc_supported, 1, 'check dcc supported' );
is( $dcc->exchange_rate, 116.4344, 'check exchange rate' );
is( $dcc->exchange_rate_timestamp, '20090101 00:00', 'check exchange timestamp' );

my $sale_req
	= new_ok( use_module( 'Business::CyberSource::Request::Sale') => [{
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
			cc_exp_month     => '04',
			cc_exp_year      => '2012',
			dcc_indicator    => 1,
			exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
		}]);

my $sale_res;
lives_ok { $sale_res = $client->run_transaction( $sale_req ) }
	'sale transaction';

ok( $sale_res->is_accepted, 'sale accepted' )
	or diag $sale_res->reason_text;

done_testing;
