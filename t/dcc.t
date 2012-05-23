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

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $client = $t->resolve( service => '/client/object' );

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
		reference_code   => 't503',
		currency         => 'USD',
		card             => $card,
		total            => '1.00',
		foreign_currency => 'JPY',
	}]);

my $dcc = $client->run_transaction( $dcc_req );

isa_ok $dcc, 'Business::CyberSource::Response';


ok( $dcc->reference_code, 'reference code exists' );
is( $dcc->request_specific_reason_code, 100, 'DCC Reason code is 100' );
is( $dcc->foreign_currency, 'JPY', 'check foreign currency' );
is( $dcc->foreign_amount, 116, 'check foreign amount' );
is( $dcc->currency, 'USD', 'check currency' );
is( $dcc->dcc_supported, 1, 'check dcc supported' );
is( $dcc->exchange_rate, 116.4344, 'check exchange rate' );
is( $dcc->exchange_rate_timestamp, '20090101 00:00', 'check exchange timestamp' );
ok( $dcc->valid_hours, 'check valid hours exists' );
is( $dcc->margin_rate_percentage, '03.0000', 'check margin rate percentage' );

done_testing;
