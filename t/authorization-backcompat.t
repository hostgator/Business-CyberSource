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

my $dtc = use_module('Business::CyberSource::Request::Authorization');

my $req
	= new_ok( $dtc => [{
		username       => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		password       => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
		production     => 0,
		reference_code => '99',
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
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '12',
		cc_exp_year    => '2025',
	}]);

my $ret;

lives_ok { $ret = $req->submit } 'submit';

is( $ret->is_success, 0, 'check success' );

done_testing;
