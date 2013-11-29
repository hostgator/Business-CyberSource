use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/../lib";

my $t = use_module('Test::Business::CyberSource')->new;

my $client = $t->resolve( service => '/client/object'    );

my $res
	= $client->run_transaction(
		$t->resolve( service => '/request/authorization' )
	);

my $capture
	= new_ok( use_module('Business::CyberSource::Request::Capture') => [{
		reference_code => $res->reference_code,
		service => { request_id => $res->request_id },
		purchase_totals => {
			total          => 4018.00,
			currency       => $res->currency,
		}
	}])
	;

my $cres = $client->run_transaction( $capture );

isa_ok( $cres, 'Business::CyberSource::Response' )
	or diag( $capture->trace->printResponse )
	;

is( $cres->decision, 'REJECT', 'check decision' );
is( $cres->reason_code, 235, 'check reason_code' );

ok( $cres->request_id, 'check request_id exists' );

done_testing;
