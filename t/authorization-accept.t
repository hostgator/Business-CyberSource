use strict;
use warnings;
use Test::More;

use Class::Load 0.20 qw( load_class );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( load_class('Test::Business::CyberSource') );

my $client = $t->resolve( service => '/client/object'    );

my $ret
	= $client->run_transaction(
		$t->resolve( service => '/request/authorization' )
	);

isa_ok( $ret,           'Business::CyberSource::Response' );
isa_ok( $ret->datetime, 'DateTime'                        );

is( $ret->is_success,     1,                        'success'      );
is( $ret->decision,       'ACCEPT',                 'decision'     );
is( $ret->reason_code,     100,                     'reason_code'  );
is( $ret->currency,       'USD',                    'currency'     );
is( $ret->amount,         '3000.00',                'amount'       );
is( $ret->avs_code,       'Y',                      'avs_code'     );
is( $ret->avs_code_raw,   'Y',                      'avs_code_raw' );
is( $ret->reason_text,    'Successful transaction', 'reason_text'  );
is( $ret->auth_code,      '831000',                 'auth_code'    );

ok( $ret->request_id,     'request_id exists'    );
ok( $ret->request_token,  'request_token exists' );
ok( $ret->auth_record,    'auth_record exists'   );
is( $ret->processor_response, '00','processor_response');

ok ! ref $ret->request_id, 'request_id is not a reference';

ok $ret->has_trace,  'response has trace';
isa_ok $ret->trace,  'XML::Compile::SOAP::Trace';

done_testing;
