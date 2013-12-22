use strict;
use warnings;
use Test::More;
use Test::Deep;
use Test::Method;
use FindBin;
use Module::Runtime qw( use_module    );
use Test::Requires  qw( Path::FindDev );
use lib Path::FindDev::find_dev( $FindBin::Bin )->child('t', 'lib' )->stringify;

my $t = use_module('Test::Business::CyberSource')->new;

my $client = $t->resolve( service => '/client/object'    );

my $ret
	= $client->run_transaction(
		$t->resolve( service => '/request/authorization' )
	);

isa_ok $ret,                 'Business::CyberSource::Response';
isa_ok $ret->trace,          'XML::Compile::SOAP::Trace';
isa_ok $ret->auth->datetime, 'DateTime';

method_ok( $ret,       is_accept     => [], 1                       );
method_ok( $ret,       decision      => [], 'ACCEPT'                );
method_ok( $ret,       reason_code   => [], 100                     );
method_ok( $ret,       currency      => [], 'USD'                   );
method_ok( $ret,       reason_text   => [], 'Successful transaction');
method_ok( $ret,       request_id    => [], re('\d+')               );
method_ok( $ret,       request_token => [], re('[[:xdigit:]]+')     );
method_ok( $ret,       has_trace     => [], bool(1)                 );
method_ok( $ret->auth, amount        => [], '3000.00'               );
method_ok( $ret->auth, auth_code     => [], '831000'                );
method_ok( $ret->auth, avs_code      => [], 'Y'                     );
method_ok( $ret->auth, avs_code_raw  => [], 'Y'                     );
method_ok( $ret->auth, auth_record   => [], re('[[:xdigit:]]+')     );
method_ok( $ret->auth, processor_response => [], '00'               );

ok ! ref $ret->request_id, 'request_id is not a reference';

done_testing;
