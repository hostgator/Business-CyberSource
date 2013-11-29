use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = use_module('Test::Business::CyberSource')->new;

my $client = $t->resolve( service => '/client/object' );

my $creditc = use_module('Business::CyberSource::Request::Credit');

my $req
	= new_ok( $creditc => [{
		reference_code => 'test-credit-' . time,
		bill_to =>
			$t->resolve( service => '/helper/bill_to' ),
		purchase_totals =>
			$t->resolve( service => '/helper/purchase_totals'),
		card =>
			$t->resolve( service => '/helper/card' ),
	}]);

isa_ok $req, $creditc;

my $ret = $client->run_transaction( $req );

isa_ok $ret, 'Business::CyberSource::Response';

is( $ret->decision,               'ACCEPT', 'check decision'       );
is( $ret->reason_code,             100,     'check reason_code'    );
is( $ret->currency,               'USD',    'check currency'       );
is( $ret->credit->amount,         '3000.00', 'check amount'        );

ok( $ret->request_id,            'check request_id exists'    );
ok( $ret->credit->datetime,      'check datetime exists'      );


done_testing;
