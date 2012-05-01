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
		credit_card    => '5555 5555 5555 4444',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		production     => 0,
	});

my $auth = $auth_req->submit;

is( $auth_req->card_type, '002', 'check card type is mastercard' );

ok( $auth, 'authorization response exists' );
note( 'request_id: ' . $auth->request_id );

my $rev_req = Business::CyberSource::Request::AuthReversal->new({
		username       => $auth_req->username,
		password       => $auth_req->password,
		reference_code => $auth_req->reference_code,
		request_id     => $auth->request_id,
		total          => $auth->amount,
		currency       => $auth->currency,
		production     => 0,
	})
	;

my $rev = $rev_req->submit;

note( $rev_req->trace->printRequest  );
note( $rev_req->trace->printResponse );

ok( $rev, 'reversal response exists' );

is( $rev->reference_code, '404', 'check reference_code' );
is( $rev->decision, 'ACCEPT', 'check decision' );
is( $rev->reason_code, 100, 'check reason_code' );
is( $rev->currency, 'USD', 'check currency' );
is( $rev->amount, '5.00', 'check amount' );
is( $rev->request_specific_reason_code , 100, 'check capture_reason_code' );

ok( $rev->datetime, 'datetime exists' );
note( $rev->datetime );

done_testing;
