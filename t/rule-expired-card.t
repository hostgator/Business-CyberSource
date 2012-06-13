use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $client = $t->resolve( service => '/client/object'    );
my $cc
	= $t->resolve(
		service    => '/helper/card',
		parameters => { expiration => { month => 5, year => 2010 }, },
	);

is( $cc->expiration->year, 2010, 'expiration year' );
ok( $cc->is_expired, 'card expired' );

my $req0
	= $t->resolve(
		service => '/request/authorization',
		parameters => {
			purchase_totals => $t->resolve(
				service    => '/helper/purchase_totals',
				parameters => { total => 3000.00 }, # magic ACCEPT
			),
			card  => $cc,
		},
	);

my $ret0 = $client->run_transaction( $req0 );

isa_ok( $ret0, 'Business::CyberSource::Response' );

ok ! $ret0->has_trace, 'does not have trace';

is( $ret0->is_success,          0,       'success'            );
is( $ret0->decision,           'REJECT', 'decision'           );
is( $ret0->reason_code,         202,     'reason_code'        );

is(
	$ret0->reason_text,
	'Expired card. You might also receive this if the expiration date you '
		. 'provided does not match the date the issuing bank has on file'
		,
	'reason_text',
);

done_testing;
