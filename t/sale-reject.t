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
my $credit_card = $t->resolve( service => '/credit_card/object' );

my $salec = use_module('Business::CyberSource::Request::Sale');
my $req0
	= new_ok( $salec => [{
		reference_code => 'test-sale-reject-0-' . time,
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '432 nowhere ave.',
		city           => 'Detroit',
		state          => 'MI',
		zip            => '77064',
		country        => 'US',
		email          => 'foobar@example.com',
		total          => 3000.37,
		currency       => 'USD',
		card           => $credit_card,
	}]);

my $ret0 = $client->run_transaction( $req0 );

isa_ok $ret0, 'Business::CyberSource::Response';

ok( ! $ret0->accepted,              'not accepted'      );
is(   $ret0->decision,   'REJECT',  'check decision'    );
is(   $ret0->reason_code, 202,      'check reason_code' );
is(
	$ret0->reason_text,
	'Expired card. You might also receive this if the expiration date you '
		. 'provided does not match the date the issuing bank has on file'
		,
	'check reason_text',
);
is( $ret0->processor_response, '54', 'check processor response' );

ok( $ret0->request_id,    'check request_id exists'    );
ok( $ret0->request_token, 'check request_token exists' );

my $req1
	= new_ok( $salec => [{
		reference_code => 'test-sale-reject-1-' . time,
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

is( $ret1->decision,       'REJECT', 'check decision'       );
is( $ret1->reason_code,     201,     'check reason_code'    );
is(
	$ret1->reason_text,
	'The issuing bank has questions about the request. You do not '
	. 'receive an authorization code programmatically, but you might '
	. 'receive one verbally by calling the processor'
	,
	'check reason_text',
);

done_testing;
