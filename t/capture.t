use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = use_module('Test::Business::CyberSource')->new;

my $client = $t->resolve( service => '/client/object'    );
my $res
	= $client->run_transaction(
		$t->resolve( service => '/request/authorization' )
	);

isa_ok( $res, 'Business::CyberSource::Response' );

my $capture
	= new_ok( use_module('Business::CyberSource::Request::Capture') => [{
		reference_code => $res->reference_code,
		service => {
			request_id => $res->request_id,
		},
		purchase_totals => {
			total    => $res->auth->amount,
			currency => $res->currency,
		},
	}])
	;

my $cres = $client->run_transaction( $capture );

isa_ok( $cres, 'Business::CyberSource::Response' )
	or diag( $capture->trace->printResponse )
	;

is( $cres->decision,       'ACCEPT', 'check decision' );
is( $cres->reason_code,      100, 'check reason_code' );
is( $cres->currency,          'USD', 'check currency' );
is( $cres->capture->amount, '3000.00', 'check amount' );
is( $cres->capture->reason_code , 100, 'check capture_reason_code' );

ok( $cres->capture->reconciliation_id, 'reconciliation_id exists' );
ok( $cres->request_id, 'check request_id exists' );

done_testing;
