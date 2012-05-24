use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_MM
	PERL_BUSINESS_CYBERSOURCE_DCC_CC_YYYY
	PERL_BUSINESS_CYBERSOURCE_DCC_VISA
);
use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";
use Test::Requires qw( Test::Business::CyberSource );

my $t = new_ok('Test::Business::CyberSource');

my $card = $t->resolve(
		service => '/credit_card/object',
		parameters => {
			account_number => $ENV{PERL_BUSINESS_CYBERSOURCE_DCC_VISA},
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
		foreign_currency => 'JPY',
	}]);

my $client = $t->resolve( service => '/client/object' );

my $dcc = $client->run_transaction( $dcc_req );

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
			total            => $dcc_req->total,
			currency         => $dcc->currency,
			foreign_currency => $dcc->foreign_currency,
			foreign_amount   => $dcc->foreign_amount,
			exchange_rate    => $dcc->exchange_rate,
			dcc_indicator    => 1,
			card             => $card,
			exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
		}]);

my $sale_res = $client->run_transaction( $sale_req );

ok( $sale_res->is_accepted, 'sale accepted' )
	or diag $sale_res->reason_text;

done_testing;
