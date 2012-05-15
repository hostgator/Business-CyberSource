use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $client      = $t->resolve( service => '/client/object'    );
my $credit_card = $t->resolve( service => '/credit_card/visa' );

my $dtc = use_module('Business::CyberSource::Request::Authorization');

my $req
	= new_ok( $dtc => [{
		reference_code => 'test-authorization-accept-' . time,
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 3000.00,
		currency       => 'USD',
		card           => $credit_card,
	}]);


# billing info

my $ret = $client->run_transaction( $req );

isa_ok( $ret, 'Business::CyberSource::Response' );

like(
	$ret->reference_code,
	qr/^test-authorization-accept-\d+$/,
	'reference_code'
);

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
ok( $ret->datetime,       'datetime exists'      );
ok( $ret->auth_record,    'auth_record exists'   );
is( $ret->processor_response, '00','processor_response');

done_testing;
