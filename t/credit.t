use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

use Module::Runtime qw( use_module );

my $client
	= new_ok( use_module( 'Business::CyberSource::Client') => [{
		username   => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		password   => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
		production => 0,
	}]);

my $creditc = use_module('Business::CyberSource::Request::Credit');

my $anonc
	= $creditc->with_traits(qw{
		BillingInfo
		CreditCardInfo
	});

my $req
	= new_ok( $anonc => [{
		reference_code => 'test-credit-' . time,
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
		credit_card    => '3566 1111 1111 1113',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	}]);

isa_ok $req, $creditc;

is( $req->ip->addr,   '192.168.100.2',          'check ip'    );
is( $req->card_type, '007', 'check card type is JCB' );

my $ret = $client->run_transaction( $req );

isa_ok $ret, 'Business::CyberSource::Response';

is( $ret->decision,       'ACCEPT', 'check decision'       );
is( $ret->reason_code,     100,     'check reason_code'    );
is( $ret->currency,       'USD',    'check currency'       );
is( $ret->amount,         '5.00',    'check amount'        );

ok( $ret->request_id,    'check request_id exists'    );
ok( $ret->datetime,      'check datetime exists'      );

done_testing;
