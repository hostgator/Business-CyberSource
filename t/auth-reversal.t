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

my $client = $t->resolve( service => '/client/object'    );
my $res    = $t->resolve( service  =>'/response/authorization/visa' );

my $authrevc = use_module('Business::CyberSource::Request::AuthReversal');

my $rev_req
	= new_ok( $authrevc => [{
		reference_code => $res->reference_code,
		request_id     => $res->request_id,
		total          => $res->amount,
		currency       => $res->currency,
	}])
	;

my $rev = $client->run_transaction( $rev_req );

isa_ok( $rev, 'Business::CyberSource::Response' )
	or diag( $rev_req->trace->printResponse )
	;

ok( $rev, 'reversal response exists' );

is( $rev->decision, 'ACCEPT', 'check decision' );
is( $rev->reason_code, 100, 'check reason_code' );
is( $rev->currency, 'USD', 'check currency' );
is( $rev->amount, '5.00', 'check amount' );
is( $rev->request_specific_reason_code , 100, 'check capture_reason_code' );

ok( $rev->datetime, 'datetime exists' );

done_testing;
