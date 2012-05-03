use strict;
use warnings;
use Test::More;

use Business::CyberSource::Client;
my $class = 'Business::CyberSource::Client';

my $client
	= new_ok( $class => [{
		username   => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME} || 'test',
		password   => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD} || 'test',
		production => 0,
	}]);

can_ok  $client, 'run_transaction';
can_ok  $client, qw( name version env );

is $client->name, 'Business::CyberSource', "$class->name";

done_testing;
