use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

my ( $CYBS_ID, $CYBS_KEY )
	= (
		$ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		$ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
	);

use Business::CyberSource::Request;

my $req_type;

my $api_info = {
	username => $CYBS_ID,
	password => $CYBS_KEY,
};

my $factory
	= Business::CyberSource::Request->new(
		username       => $api_info->{username},
		password       => $api_info->{password},
		production     => 0
	);

ok( $factory, 'factory exists' );

$req_type = 'Authorization';
my $auth_req = $factory->create(
	$req_type,
	{
		reference_code => '74',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 9.95,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	}
);

my $auth = $auth_req->submit;

my %args = (
	request_id     => $auth->request_id,
	reference_code => '74',
	total          => 9.95,
	currency       => 'USD',
);

$req_type = 'AuthReversal';
my $req = $factory->create(
	$req_type,
	\%args,
);

ok( $req, 'request exists' );

my $res = $req->submit;

ok( $res, 'response exists' );

is( $res->decision, 'ACCEPT', 'response is ACCEPT' );

done_testing;
