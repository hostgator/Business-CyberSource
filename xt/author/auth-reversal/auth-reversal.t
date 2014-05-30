use strict;
use warnings;
use Test::More;
use FindBin;
use Module::Runtime qw( use_module    );
use Test::Requires  qw( Path::FindDev );
use lib Path::FindDev::find_dev( $FindBin::Bin )->child('t', 'lib' )->stringify;

my $t = use_module('Test::Business::CyberSource')->new;

my $client = $t->resolve( service => '/client/object'    );

my $authrevc = use_module('Business::CyberSource::Request::AuthReversal');

my $res
	= $client->submit(
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

my $rev = $client->submit( $rev_req );

isa_ok( $rev, 'Business::CyberSource::Response' );

ok( $rev, 'reversal response exists' );

is( $rev->decision, 'ACCEPT', 'check decision' );
is( $rev->reason_code, 100, 'check reason_code' );
is( $rev->currency, 'USD', 'check currency' );
is( $rev->auth_reversal->amount, '3000.00', 'check amount' );
is( $rev->auth_reversal->reason_code , 100, 'check capture_reason_code' );

ok( $rev->auth_reversal->datetime, 'datetime exists' );

done_testing;
