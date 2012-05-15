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

my $client      = $t->resolve( service => '/client/object'    );
my $credit_card = $t->resolve( service => '/credit_card/visa' );

my $dtc = use_module('Business::CyberSource::Request::Authorization');

my $req0
	= new_ok( $dtc => [{
		reference_code => 'test-authorization-reject-0-' . time,
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '432 nowhere ave.',
		city           => 'Detroit',
		state          => 'MI',
		zip            => '77064',
		country        => 'US',
		email          => 'foobar@example.com',
		total          => 3000.37, # magic make me expired value
		currency       => 'USD',
		card           => $credit_card,
	}]);

my $ret0 = $client->run_transaction( $req0 );

isa_ok( $ret0, 'Business::CyberSource::Response' )
	or diag( $req0->trace->printResponse )
	;

is( $ret0->is_success,          0,       'success'            );
is( $ret0->decision,           'REJECT', 'decision'           );
is( $ret0->reason_code,         202,     'reason_code'        );
is( $ret0->processor_response, '54',     'processor response' );

ok( $ret0->request_id,         'request_id exists'            );
ok( $ret0->request_token,      'request_token exists'         );

is(
	$ret0->reason_text,
	'Expired card. You might also receive this if the expiration date you '
		. 'provided does not match the date the issuing bank has on file'
		,
	'reason_text',
);

my $req1
	= new_ok( $dtc => [{
		reference_code => 'test-authorization-reject-1-' . time,
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '432 nowhere ave.',
		city           => 'Detroit',
		state          => 'MI',
		zip            => '77064',
		country        => 'US',
		email          => 'foobar@example.com',
		total          => 3000.04,
		currency       => 'USD',
		card           => $credit_card,
	}]);

my $ret1 = $client->run_transaction( $req1 );

isa_ok( $ret1, 'Business::CyberSource::Response' )
	or diag( $req1->trace->printResponse )
	;


is( $ret1->decision,       'REJECT', 'decision'       );
is( $ret1->reason_code,     201,     'reason_code'    );
is(
	$ret1->reason_text,
	'The issuing bank has questions about the request. You do not '
	. 'receive an authorization code programmatically, but you might '
	. 'receive one verbally by calling the processor'
	,
	'reason_text',
);

done_testing;
