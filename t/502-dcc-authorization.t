#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;
use Test::Exception;

use Business::CyberSource::Request;

my ( $cybs_id, $cybs_key ) = ( $CYBS_ID, $CYBS_KEY );

$cybs_id  ||= 'test';
$cybs_key ||= 'test';

my $factory;
lives_ok {
	$factory = Business::CyberSource::Request->new({
		username => $cybs_id,
		password => $cybs_key,
		production => 0,
	});
} 'factory new';



my $dcc_req;
lives_ok {
	$dcc_req = $factory->create( 'DCC',
	{
		reference_code => 't502',
		currency       => 'USD',
		credit_card    => '5100870000000004',
		cc_exp_month   => '04',
		cc_exp_year    => '2012',
		total          => '1.00',
		foreign_currency => 'EUR',
	})
} 'DCC request object created';

SKIP: {
	skip 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!',
		7
		unless $CYBS_ID and $CYBS_KEY
		;

	note( '!!!: if this fails please ensure that cybersource has enabled DCC '
		. 'for your account' )
		;

	my $dcc;

	lives_ok {
		$dcc = $dcc_req->submit;
	} 'DCC submitted';

	note( $dcc_req->trace->request->decoded_content );
	note( $dcc_req->trace->response->decoded_content );

	is( $dcc->foreign_currency, 'EUR', 'dcc response foreign_currency' );
	is( $dcc->foreign_amount,  '0.88', 'dcc response foreign_amount'   );
	is( $dcc->exchange_rate, '0.8810', 'dcc response exchange_rate'    );
	is( $dcc->dcc_supported,        1, 'dcc response dcc_supported'    );

	my $auth_req;
	lives_ok {
		$auth_req = $factory->create( 'Authorization',
		{
			reference_code   => $dcc->reference_code,
			first_name       => 'Caleb',
			last_name        => 'Cushing',
			street           => 'somewhere',
			city             => 'Houston',
			state            => 'TX',
			zip              => '77064',
			country          => 'US',
			email            => 'xenoterracide@gmail.com',
			credit_card      => $dcc_req->credit_card,
			total            => $dcc_req->total,
			currency         => $dcc->currency,
			foreign_currency => $dcc->foreign_currency,
			foreign_amount   => $dcc->foreign_amount,
			exchange_rate    => $dcc->exchange_rate,
			cc_exp_month     => '04',
			cc_exp_year      => '2012',
			dcc_indicator    => 1,
			exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
		})
	} 'create dcc authorization request object';

	my $auth_res;
	lives_ok {
		$auth_res = $auth_req->submit;
	} 'auth submit';

	note( $auth_req->trace->request->decoded_content );
	note( $auth_req->trace->response->decoded_content );

	my $cap_req;
	lives_ok {
		$cap_req = $factory->create( 'Capture',
		{
			reference_code => $dcc->reference_code,
			total          => $dcc_req->total,
			currency         => $dcc->currency,
			foreign_currency => $dcc->foreign_currency,
			foreign_amount   => $dcc->foreign_amount,
			exchange_rate    => $dcc->exchange_rate,
			dcc_indicator    => 1,
			request_id       => $auth_res->request_id,
			exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
		})
	} 'create dcc capture request object';

	my $cap_res;
	lives_ok {
		$cap_res = $cap_req->submit;
	} 'capture submit';

	my $cred_req;
	lives_ok {
		$cred_req = $factory->create( 'FollowOnCredit',
		{
			reference_code => $dcc->reference_code,
			total          => $dcc_req->total,
			currency         => $dcc->currency,
			foreign_currency => $dcc->foreign_currency,
			foreign_amount   => $dcc->foreign_amount,
			exchange_rate    => $dcc->exchange_rate,
			dcc_indicator    => 1,
			request_id       => $cap_res->request_id,
			exchange_rate_timestamp => $dcc->exchange_rate_timestamp,
		})
	} 'create dcc follow-on credit request';

	my $cred_res;
	lives_ok {
		$cred_res = $cred_req->submit;
	} 'credit submit';

	is( $cred_res->is_accepted, 1, 'check that credit decicion is ACCEPT');
	is( $cred_res->amount, '1.00', 'check that credit amount is 1.00' );
}

done_testing;
