use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

use Test::Exception;

use Module::Runtime qw( use_module );

my $client
	= new_ok( use_module( 'Business::CyberSource::Client') => [{
		username   => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		password   => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
		production => 0,
	}]);

my $authc = use_module('Business::CyberSource::Request::Authorization');

my $req
	= new_ok( $authc => [{
		reference_code => 't201',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'USA',
		email          => 'xenoterracide@gmail.com',
		ip             => '192.168.100.2',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	}])
	;

my $res = $client->run_transaction( $req );

isa_ok( $res, 'Business::CyberSource::Response' )
	or diag( $req->trace->printResponse )
	;

my $capture
	= new_ok( use_module('Business::CyberSource::Request::Capture') => [{
		reference_code => $req->reference_code,
		request_id     => $res->request_id,
		total          => $res->amount,
		currency       => $res->currency,
	}])
	;

my $cres = $client->run_transaction( $capture );

isa_ok( $cres, 'Business::CyberSource::Response' )
	or diag( $capture->trace->printResponse )
	;

is( $cres->reference_code, 't201', 'check reference_code' );
is( $cres->decision, 'ACCEPT', 'check decision' );
is( $cres->reason_code, 100, 'check reason_code' );
is( $cres->currency, 'USD', 'check currency' );
is( $cres->amount, '5.00', 'check amount' );
is( $cres->request_specific_reason_code , 100, 'check capture_reason_code' );

ok( $cres->reconciliation_id, 'reconciliation_id exists' );
ok( $cres->request_id, 'check request_id exists' );

done_testing;
