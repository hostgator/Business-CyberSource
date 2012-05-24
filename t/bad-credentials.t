use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);
use Test::Fatal;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $req = $t->resolve( service  =>'/request/authorization/visa' );

my $client
	= new_ok( use_module( 'Business::CyberSource::Client') => [{
		username   => 'foobar',
		password   => 'test',
		production => 0,
	}]);

my $exception = exception { $client->run_transaction( $req ) };
like $exception, qr/SOAP Fault/, 'run_transaction threw exception';

done_testing;
