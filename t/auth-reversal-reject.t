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

use Business::CyberSource::Request::Authorization;
use Business::CyberSource::Request::AuthReversal;

my $auth_req
	= Business::CyberSource::Request::Authorization->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => '404',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		production     => 0,
	});

my $auth = $auth_req->submit;

ok( $auth, 'authorization response exists' );

my $rev_req = Business::CyberSource::Request::AuthReversal->new({
		username       => $auth_req->username,
		password       => $auth_req->password,
		reference_code => $auth_req->reference_code,
		request_id     => '834',
		total          => $auth->amount,
		currency       => $auth->currency,
		production     => 0,
	})
	;

my $rev = $rev_req->submit;

ok( $rev, 'reversal response exists' );

is( $rev->decision, 'REJECT', 'check decision' );
is( $rev->reason_code, 102, 'check reason_code' );

ok( $rev->request_token, 'request token exists' );

done_testing;
