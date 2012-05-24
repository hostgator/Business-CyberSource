use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

use FindBin; use lib "$FindBin::Bin/lib";
use Test::Requires qw( Test::Business::CyberSource );

my $t = new_ok('Test::Business::CyberSource');

my $client      = $t->resolve( service => '/client/object'    );

my $req
	= $t->resolve(
		service => '/request/authorization/visa',
		parameters => { total => 9000.00 },
	);

# check billing info
is( $req->cvn,   '1111', 'check cvn'   );
is( $req->total, '9000', 'check total' );

my $ret = $client->run_transaction( $req );

isa_ok $ret, 'Business::CyberSource::Response';

is( $ret->decision,       'ACCEPT', 'check decision'       );
is( $ret->reason_code,     100,     'check reason_code'    );
is( $ret->currency,       'USD',    'check currency'       );
is( $ret->amount,         '9000.00', 'check amount'        );
is( $ret->avs_code,       'Y',       'check avs_code'      );
is( $ret->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret->processor_response, '00',  'check processor_response');
is( $ret->auth_code, '831000', 'check auth_code is 83100'  );
is( $ret->cv_code,     'M',          'check cv_code'       );
is( $ret->cv_code_raw, 'M',          'check cv_code'       );

ok( $ret->request_id,    'check request_id exists'    );
ok( $ret->request_token, 'check request_token exists' );
ok( $ret->datetime,      'check datetime exists'      );
ok( $ret->auth_record,   'check auth_record exists'   );

done_testing;
