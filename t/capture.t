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

isa_ok( $res, 'Business::CyberSource::Response' );

my $capture
	= new_ok( use_module('Business::CyberSource::Request::Capture') => [{
		reference_code => $res->reference_code,
		request_id     => $res->request_id,
		total          => $res->amount,
		currency       => $res->currency,
	}])
	;

my $cres = $client->run_transaction( $capture );

isa_ok( $cres, 'Business::CyberSource::Response' )
	or diag( $capture->trace->printResponse )
	;

is( $cres->decision, 'ACCEPT', 'check decision' );
is( $cres->reason_code, 100, 'check reason_code' );
is( $cres->currency, 'USD', 'check currency' );
is( $cres->amount, '5.00', 'check amount' );
is( $cres->request_specific_reason_code , 100, 'check capture_reason_code' );

ok( $cres->reconciliation_id, 'reconciliation_id exists' );
ok( $cres->request_id, 'check request_id exists' );

done_testing;
