use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);
use Test::Moose;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $client      = $t->resolve( service => '/client/object'    );
my $credit_card = $t->resolve( service  =>'/credit_card/visa' );

my $dtc = use_module('Business::CyberSource::Request::Authorization');

my $req0
	= new_ok( $dtc => [{
		reference_code => '72',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '432 nowhere ave.',
		city           => 'Detroit',
		state          => 'MI',
		zip            => '77064',
		country        => 'US',
		email          => 'foobar@example.com',
		total          => 5000.00,
		currency       => 'USD',
		card           => $credit_card,
	}]);

my $ret0 = $client->run_transaction( $req0 );

is( $ret0->decision,       'ACCEPT', 'check decision'       );
is( $ret0->reason_code,     100,     'check reason_code'    );
is( $ret0->auth_code,      '831000', 'check auth code'      );
is( $ret0->avs_code,       'X',      'check avs_code'       );
is( $ret0->avs_code_raw,   'X',      'check avs_code_raw'   );


my $req1
	= new_ok( $dtc => [{
		reference_code => '99',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '432 nowhere ave.',
		city           => 'Detroit',
		state          => 'MI',
		zip            => '77064',
		country        => 'US',
		email          => 'foobar@example.com',
		total          => 5005.00,
		currency       => 'USD',
		card           => $credit_card,
	}]);

my $ret1 = $client->run_transaction( $req1 );

isa_ok( $ret1, 'Business::CyberSource::Response' )
	or diag( $req1->trace->printResponse )
	;

does_ok( $ret1, 'Business::CyberSource::Response::Role::Authorization' )
	or diag( $req1->trace->printResponse )
	;

does_ok( $ret1, 'Business::CyberSource::Response::Role::AVS'           );

is( $ret1->decision,       'REJECT', 'check decision'       );
is( $ret1->reason_code,    '200',    'check reason_code'    );
is( $ret1->avs_code,       'N',      'check avs_code'       );
is( $ret1->avs_code_raw,   'N',      'check avs_code_raw'   );
is( $ret1->processor_response, '00', 'check processor response' );

done_testing;
