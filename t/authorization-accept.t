use strict;
use warnings;
use Test::More;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);
use Test::Exception;

use Module::Runtime qw( use_module );

my $client
	= new_ok( use_module( 'Business::CyberSource::Client') => [{
		username   => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		password   => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
		production => 0,
	}]);

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
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	}]);


# billing info

my $ret;
lives_ok { $ret = $client->run_transaction( $req ) } $dtc .'->runtransaction';

isa_ok( $ret, 'Business::CyberSource::Response' );

unless ( $ret ) {
	note( $req->trace->request->decoded_content );
	note( $req->trace->response->decoded_content );
}

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
