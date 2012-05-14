use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

use Test::Exception;

use Module::Runtime qw( use_module );
use Data::Dumper;

my $client
	= new_ok( use_module( 'Business::CyberSource::Client') => [{
		username   => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		password   => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
		production => 0,
	}]);

my $dtc = use_module('Business::CyberSource::Request::Authorization');

my $credit_card
	= new_ok( use_module('Business::CyberSource::CreditCard') => [{
		account_number => '4111-1111-1111-1111',
		expiration     => {
			month => '04',
			year => '2010',
		},
	}]);

#ok( $credit_card->is_expired, 'expired' );

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

ok( $req0->is_skipable, 'skipable' );

my $ret0 = $client->run_transaction( $req0 );

isa_ok( $ret0, 'Business::CyberSource::Response' )
	or diag( $req0->trace->printResponse )
	;

is( $ret0->is_success,          0,       'success'            );
is( $ret0->decision,           'REJECT', 'decision'           );
is( $ret0->reason_code,         202,     'reason_code'        );

is(
	$ret0->reason_text,
	'Expired card. You might also receive this if the expiration date you '
		. 'provided does not match the date the issuing bank has on file'
		,
	'reason_text',
);

done_testing;
