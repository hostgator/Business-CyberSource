use strict;
use warnings;
use Test::More;

use Class::Load qw( load_class );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = load_class('Test::Business::CyberSource')->new;

my $client = $t->resolve( service => '/client/object'    );

my $authrevc = load_class('Business::CyberSource::Request::AuthReversal');

my $res
	= $client->run_transaction(
		$t->resolve( service => '/request/authorization' )
	);

my $rev_req
	= new_ok( $authrevc => [{
		reference_code => $res->reference_code,
		service => {
			request_id => $res->request_id,
		},
		purchase_totals => {
			total    => $res->auth->amount,
			currency => $res->currency,
		},
	}]);

my $rev = $client->run_transaction( $rev_req );

isa_ok( $rev, 'Business::CyberSource::Response' );

ok( $rev, 'reversal response exists' );

is( $rev->decision, 'ACCEPT', 'check decision' );
is( $rev->reason_code, 100, 'check reason_code' );
is( $rev->currency, 'USD', 'check currency' );
is( $rev->auth_reversal->amount, '3000.00', 'check amount' );
is( $rev->auth_reversal->reason_code , 100, 'check capture_reason_code' );

ok( $rev->auth_reversal->datetime, 'datetime exists' );

done_testing;
