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
		reference_code => 't501',
		currency       => 'USD',
		credit_card    => '5100870000000004',
		cc_exp_month   => '04',
		cc_exp_year    => '2012',
		total          => '1.00',
		foreign_currency => 'JPY',
	})
} 'DCC request object created';

SKIP: {
	skip 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!',
		1
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
			credit_card      => '5100870000000004',
			total            => 1.00,
			currency         => 'USD',
			foreign_currency => 'JPY',
			foreign_amount   => 116,
			exchange_rate    => 116.4344
			cc_exp_month     => '04',
			cc_exp_year      => '2012',
			exchange_rate_timestamp => '20090101 00:00',
		});
	} 'create dcc authorization request';
}

done_testing;
