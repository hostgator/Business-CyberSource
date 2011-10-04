#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;
use Test::Exception;

use Business::CyberSource::Request::Authorization;

my ( $cybs_id, $cybs_key ) = ( $CYBS_ID, $CYBS_KEY );

$cybs_id  ||= 'test';
$cybs_key ||= 'test';

my $req = 'Business::CyberSource::Request::Authorization';

lives_ok(
	$req->new({
		username       => $cybs_id,
		password       => $cybs_key,
		reference_code => 't101',
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
		production     => 0,
	}),
	'authorization lives'
);

ok( $req->client_version, 'check client_version exists');
is( $req->client_name , 'Business::CyberSource', 'check client_library'    );
ok( $req->client_env,                            'check client_env exists' );

# check billing info
is( $req->reference_code, 't101',      'check reference_code' );
is( $req->first_name,     'Caleb',     'check first_name'     );
is( $req->last_name,      'Cushing',   'check first_name'     );
is( $req->street,         'somewhere', 'check street'         );
is( $req->city,           'Houston',   'check city'           );
is( $req->state,          'TX',        'check state'          );
is( $req->country,        'US',        'check country'        );

is( $req->email, 'xenoterracide@gmail.com', 'check email' );

is( $req->total,      '3000', 'check total'      );

is( $req->currency, 'USD', 'check currency' );

is( $req->credit_card,  '4111111111111111', 'check credit card number' );

is( $req->cc_exp_month, '09',   'check credit card expiration year'  );
is( $req->cc_exp_year,  '2025', 'check credit card expiration month' );
is( $req->card_type,    '001',  'check card type' );

ok( $req->cybs_wsdl->stringify, 'check for wsdl' );
ok( $req->cybs_xsd->stringify,  'check for xsd' );

SKIP: {
	skip 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!',
		17
		unless $CYBS_ID and $CYBS_KEY
		;

	is( $req->username, $CYBS_ID,  'check username' );
	is( $req->password, $CYBS_KEY, 'check key'      );

	my $ret;

	eval { $ret = $req->submit };

	note( $req->trace->request->decoded_content );
	note( $req->trace->response->decoded_content );

	is( $ret->is_success,     1,        'check success'        );
	is( $ret->decision,       'ACCEPT', 'check decision'       );
	is( $ret->reference_code, 't101',   'check reference_code' );
	is( $ret->reason_code,     100,     'check reason_code'    );
	is( $ret->currency,       'USD',    'check currency'       );
	is( $ret->amount,         '3000.00',    'check amount'     );
	is( $ret->avs_code,       'Y',       'check avs_code'      );
	is( $ret->avs_code_raw,   'Y',       'check avs_code_raw'  );
	is( $ret->processor_response, '00',  'check processor_response');
	is( $ret->reason_text, 'Successful transaction', 'check reason_text' );
	is( $ret->auth_code, '831000',     'check auth_code exists');

	ok( $ret->request_id,    'check request_id exists'    );
	ok( $ret->request_token, 'check request_token exists' );
	ok( $ret->datetime,      'check datetime exists'      );
	ok( $ret->auth_record,   'check auth_record exists'   );
}
done_testing;
