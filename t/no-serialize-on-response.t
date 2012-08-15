use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $client = $t->resolve( service => '/client/object'    );

my $ret
	= $client->run_transaction(
		$t->resolve( service => '/request/authorization' )
	);

isa_ok $ret, 'Business::CyberSource::Response';

ok ! $ret->can('serialize'), 'can not serialize';

done_testing;
