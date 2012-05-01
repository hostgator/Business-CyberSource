use strict;
use warnings;
use Test::More;
use Test::Exception;
use Data::Dumper;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

my ( $cybs_id, $cybs_key )
	= (
		$ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		$ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
	);

use Business::CyberSource::Request;

my $factory;
lives_ok {
	$factory = Business::CyberSource::Request->new({
		username       => $cybs_id,
		password       => $cybs_key,
		production     => 0,
	})
} 'new factory';

ok( $factory, 'factory exists' );

my $req;
lives_ok {
	$req = $factory->create( 'Authorization',
	{
		reference_code => 't304',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		ip             => '192.168.100.2',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	})
} 'create authorization';

	my $res;
	lives_ok {
		$res = $req->submit;
	} 'auth submit';

	my $capture;
	lives_ok {
		$capture = $factory->create( 'Capture',
		{
			reference_code => $req->reference_code,
			request_id     => $res->request_id,
			total          => $res->amount,
			currency       => $res->currency,
		})
	} 'capture create';

	my $cres;
	lives_ok {
		$cres = $capture->submit;
	} 'capture submit';

	ok( $cres, 'capture response exists' );

	my $credit_req;
	lives_ok {
		$credit_req = $factory->create( 'FollowOnCredit',
		{
			username       => $cybs_id,
			password       => $cybs_key,
			reference_code => $req->reference_code,
			total          => 5.00,
			currency       => 'USD',
			request_id     => $cres->request_id,
			production     => 0,
		})
	} 'create follow-on credit';

	note( Dumper $credit_req->_request_data );

	my $credit;
	lives_ok {
		$credit = $credit_req->submit;
	} 'credit submit';

	note( $credit_req->trace->request->decoded_content );
	note( $credit_req->trace->response->decoded_content );

	ok( $credit, 'credit response exists' );

	is( $credit->reference_code, 't304', 'check response reference code' );
	is( $credit->decision,       'ACCEPT', 'check decision'       );
	is( $credit->reason_code,     100,     'check reason_code'    );
	is( $credit->currency,       'USD',    'check currency'       );
	is( $credit->amount,         '5.00',    'check amount'        );

	ok( $credit->request_id,    'check request_id exists'    );
	ok( $credit->datetime,      'check datetime exists'      );
done_testing;
