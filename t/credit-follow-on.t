use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $client   = $t->resolve( service => '/client/object'    );
my $auth_res
	= $client->run_transaction(
		$t->resolve( service => '/request/authorization' )
	);

my $capturec = use_module('Business::CyberSource::Request::Capture');
my $creditc  = use_module('Business::CyberSource::Request::Credit');

my $capture_req
	= new_ok( $capturec => [{
		reference_code => $auth_res->reference_code,
		service => {
			auth_request_id => $auth_res->request_id,
		},
		purchase_totals => {
			total    => $auth_res->amount,
			currency => $auth_res->currency,
		},
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
		purchase_totals => {
			total    => 5.00,
			currency => 'USD',
		},
		service => {
			auth_request_id => $capture_res->request_id,
		},
	})
	;

my $credit_res = $client->run_transaction( $credit_req  );

isa_ok( $credit_res, 'Business::CyberSource::Response'  );

is( $credit_res->decision,     'ACCEPT',  'decision'    );
is( $credit_res->reason_code,  100,      'reason_code'  );
is( $credit_res->currency,     'USD',     'currency'    );
is( $credit_res->amount,       '3000.00', 'amount'      );

ok( $credit_res->request_id,   'request_id exists'      );
isa_ok( $credit_res->datetime, 'DateTime'               );

done_testing;
