use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = use_module('Test::Business::CyberSource')->new;

my $client   = $t->resolve( service => '/client/object'    );

my $auth_res
	= $client->run_transaction(
		$t->resolve( service => '/request/authorization' )
	);

my $authrevc = use_module('Business::CyberSource::Request::AuthReversal');

my $rev_req
	= new_ok( $authrevc => [{
		reference_code => $auth_res->reference_code,
		service => {
			request_id => '834',
		},
		purchase_totals => {
			total    => $auth_res->auth->amount,
			currency => $auth_res->currency,
		},
	}]);

my $rev_res = $client->run_transaction( $rev_req );

is( $rev_res->decision, 'REJECT', 'check decision' );
is( $rev_res->reason_code, 102, 'check reason_code' );

ok( $rev_res->request_token, 'request token exists' );

done_testing;
