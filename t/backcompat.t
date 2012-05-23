use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

use Test::Fatal;

use Module::Runtime qw( use_module );

my $dtc = use_module('Business::CyberSource::Request::Authorization');

my $req
	= new_ok( $dtc => [{
		username       => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		password       => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
		production     => 0,
		reference_code => 'test-authorization-accept-' . time,
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 3000.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	}]);

can_ok $req, 'submit';
can_ok $req, 'username';
can_ok $req, 'password';
can_ok $req, 'production';

my $exception = exception { $req->create };
like $exception, qr/Business::CyberSource::RequestFactory/, 'create dies';

my $ret = $req->submit;

isa_ok $ret, 'Business::CyberSource::Response';

ok( $ret->is_accepted,        'accepted' );
is( $ret->decision, 'ACCEPT', 'decision' );

my $factory
	= new_ok( use_module('Business::CyberSource::Request') => [{
		username       => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		password       => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
		production     => 0,
	}]);

can_ok $factory, 'create';

done_testing;
