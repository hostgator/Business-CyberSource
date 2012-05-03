use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

use Test::Exception;

use Module::Runtime qw( use_module );
use Data::Dumper;

my $client
	= new_ok( use_module( 'Business::CyberSource::Client') => [{
		username   => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		password   => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
		production => 0,
	}]);

my $dtc = use_module('Business::CyberSource::Request::Authorization');

my $auth_req
	= new_ok( $dtc => [{
		reference_code => '404',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '5555 5555 5555 4444',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	}]);

my $auth = $client->run_transaction( $auth_req );

isa_ok( $auth, 'Business::CyberSource::Response' )
	or diag( $auth_req->trace->printResponse )
	;

is( $auth_req->card_type, '002', 'check card type is mastercard' );

my $authrevc = use_module('Business::CyberSource::Request::AuthReversal');

my $rev_req
	= new_ok( $authrevc => [{
		reference_code => $auth_req->reference_code,
		request_id     => $auth->request_id,
		total          => $auth->amount,
		currency       => $auth->currency,
	}])
	;

my $rev = $client->run_transaction( $rev_req );

isa_ok( $rev, 'Business::CyberSource::Response' )
	or diag( $rev_req->trace->printResponse )
	;

ok( $rev, 'reversal response exists' );

is( $rev->reference_code, '404', 'check reference_code' );
is( $rev->decision, 'ACCEPT', 'check decision' );
is( $rev->reason_code, 100, 'check reason_code' );
is( $rev->currency, 'USD', 'check currency' );
is( $rev->amount, '5.00', 'check amount' );
is( $rev->request_specific_reason_code , 100, 'check capture_reason_code' );

ok( $rev->datetime, 'datetime exists' );
note( $rev->datetime );

done_testing;
