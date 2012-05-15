use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $client   = $t->resolve( service => '/client/object'    );
my $auth_res = $t->resolve( service  =>'/response/authorization/visa' );

my $capturec = use_module('Business::CyberSource::Request::Capture');
my $creditc  = use_module('Business::CyberSource::Request::Credit');

my $capture_req
	= new_ok( $capturec => [{
		reference_code => $auth_res->reference_code,
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
		reference_code => $auth_res->reference_code,
		total          => 5.00,
		currency       => 'USD',
		request_id     => $capture_res->request_id,
	})
	;

my $credit_res = $client->run_transaction( $credit_req );

isa_ok( $credit_res, 'Business::CyberSource::Response' );

is( $credit_res->decision,       'ACCEPT', 'decision'                );
is( $credit_res->reason_code,     100,     'reason_code'             );
is( $credit_res->currency,       'USD',    'currency'                );
is( $credit_res->amount,         '5.00',    'amount'                 );

ok( $credit_res->request_id,     'request_id exists'                 );
ok( $credit_res->datetime,       'datetime exists'                   );
done_testing;
