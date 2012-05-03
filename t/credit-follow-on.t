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

my $authc    = use_module('Business::CyberSource::Request::Authorization');
my $capturec = use_module('Business::CyberSource::Request::Capture');
my $creditc  = use_module('Business::CyberSource::Request::Credit');

my $auth_req
	= new_ok( $authc => [{
		reference_code => '420',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		ip             => '192.168.100.2',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	}])
	;

my $auth_res = $client->run_transaction( $auth_req );

my $capture_req
	= new_ok( $capturec => [{
		reference_code => $auth_req->reference_code,
		request_id     => $auth_res->request_id,
		total          => $auth_res->amount,
		currency       => $auth_res->currency,
	}])
	;

my $capture_res = $client->run_transaction( $capture_req );

isa_ok( $capture_res, 'Business::CyberSource::Response' );

my $credit_req
	= Business::CyberSource::Request::Credit
	->with_traits(qw{
		FollowUp
	})
	->new({
		reference_code => $auth_req->reference_code,
		total          => 5.00,
		currency       => 'USD',
		request_id     => $capture_res->request_id,
	})
	;

my $credit_res = $client->run_transaction( $credit_req );

isa_ok( $credit_res, 'Business::CyberSource::Response' );

is( $credit_res->reference_code, '420',    'response reference code' );
is( $credit_res->decision,       'ACCEPT', 'decision'                );
is( $credit_res->reason_code,     100,     'reason_code'             );
is( $credit_res->currency,       'USD',    'currency'                );
is( $credit_res->amount,         '5.00',    'amount'                 );

ok( $credit_res->request_id,     'request_id exists'                 );
ok( $credit_res->datetime,       'datetime exists'                   );
done_testing;
