use strict;
use warnings;
use Test::More;
use Test::Fatal;

use Class::Load qw( load_class );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( load_class('Test::Business::CyberSource') );

my $req = $t->resolve( service  =>'/request/authorization' );

my $client
	= new_ok( load_class( 'Business::CyberSource::Client') => [{
		username   => 'foobar',
		password   => 'test',
		production => 0,
	}]);

my $exception = exception { $client->run_transaction( $req ) };
like $exception, qr/SOAP Fault/, 'run_transaction threw exception';

done_testing;
