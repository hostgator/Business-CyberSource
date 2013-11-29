use strict;
use warnings;
use Test::More;
use Test::Fatal;

use Module::Runtime  qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = use_module('Test::Business::CyberSource')->new;

my $client = $t->resolve( service => '/client/object'    );

my $exception = exception {
	$client->run_transaction(
		$t->resolve(
			service    => '/request/authorization',
			parameters => {
				purchase_totals => $t->resolve(
					service    => '/helper/purchase_totals',
					parameters => {
						total => 3000.49, # magic make me ERROR
					},
				),
			},
		)
	)
};

isa_ok( $exception, 'Business::CyberSource::Exception' )
	or diag "$exception"
	;

done_testing;
