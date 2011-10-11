#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;
use Test::Exception;
use Data::Dumper;

my ( $cybs_id, $cybs_key ) = ( $CYBS_ID, $CYBS_KEY );

$cybs_id  ||= 'test';
$cybs_key ||= 'test';

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
	$req = $factory->create(
	'Authorization',
	{
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
		credit_card    => '378282246310005',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	})
} 'create authorization';

is( $req->card_type, '003', 'check card type is american express' );
ok( $req, 'request exists' );
note( Dumper $req->_request_data );

ok( $req->reference_code , 'reference_code exists' );

SKIP: {
	skip 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!',
		4
		unless $CYBS_ID and $CYBS_KEY
		;

	my $ret;
	lives_ok { $ret = $req->submit } 'submit';

	ok( $ret, 'response exists' );
	is( $ret->accepted,  1, 'check if the decision is ACCEPT' );

	is( $ret->decision, 'ACCEPT', 'response is ACCEPT' );
}
done_testing;
