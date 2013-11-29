use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/../lib";

my $t = use_module('Test::Business::CyberSource')->new;

my $client      = $t->resolve( service => '/client/object'    );

my $req
	= $t->resolve(
		service    => '/request/authorization',
		parameters => {
			purchase_totals => $t->resolve(
				service    => '/helper/purchase_totals',
				parameters => {
					total => 9000.00,
				},
			),
		},
	);

my $ret = $client->run_transaction( $req );

isa_ok $ret, 'Business::CyberSource::Response';

is( $ret->decision,             'ACCEPT', 'check decision'       );
is( $ret->reason_code,           100,     'check reason_code'    );
is( $ret->currency,             'USD',    'check currency'       );
is( $ret->auth->amount,         '9000.00', 'check amount'        );
is( $ret->auth->avs_code,       'Y',       'check avs_code'      );
is( $ret->auth->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret->auth->processor_response, '00',  'check processor_response');
is( $ret->auth->auth_code, '831000', 'check auth_code is 83100'  );
is( $ret->auth->cv_code,     'M',          'check cv_code'       );
is( $ret->auth->cv_code_raw, 'M',          'check cv_code'       );

ok( $ret->request_id,          'check request_id exists'    );
ok( $ret->request_token,       'check request_token exists' );
ok( $ret->auth->auth_record,   'check auth_record exists'   );

isa_ok( $ret->auth->datetime, 'DateTime' );

done_testing;
