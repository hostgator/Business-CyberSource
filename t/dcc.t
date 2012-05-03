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

ok ( $dcc_req->trace, 'trace exists' );

ok( $dcc, 'authorization response exists' );


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
