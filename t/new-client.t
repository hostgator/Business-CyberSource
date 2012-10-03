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

can_ok $client, '_soap_client';

my $client_security = $client->_client;

my ( $soap_client, $security ) = @$client_security;

is ref $soap_client,   'CODE', 'XML client is a code ref';
is ref $security, 'HASH', 'XML security is a code ref';

done_testing;
