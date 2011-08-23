#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;
#use SOAP::Lite +trace => [ 'debug' ] ;

plan skip_all
	=> 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!'
	unless $CYBS_ID and $CYBS_KEY
	;

use Business::CyberSource::Request::Authorization;

my $req
	= Business::CyberSource::Request::Authorization->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => '42',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		unit_price     => 5.00,
		quantity       => 1,
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		production     => 0,
	});

is( $req->username, $CYBS_ID,  'check username' );
is( $req->password, $CYBS_KEY, 'check key'      );
is( $req->client_version,
	$Business::CyberSource::VERSION,
	'check client_version valid'
);
is( $req->client_name , 'Business::CyberSource', 'check client_library'    );
ok( $req->client_env,                            'check client_env exists' );

# check billing info
is( $req->reference_code, '42',        'check reference_code' );
is( $req->first_name,     'Caleb',     'check first_name'     );
is( $req->last_name,      'Cushing',   'check first_name'     );
is( $req->street,         'somewhere', 'check street'         );
is( $req->city,           'Houston',   'check city'           );
is( $req->state,          'TX',        'check state'          );
is( $req->country,        'US',        'check country'        );

is( $req->email, 'xenoterracide@gmail.com', 'check email' );

is( $req->total,      5, 'check total'      );

is( $req->currency, 'USD', 'check currency' );

is( $req->credit_card,  '4111-1111-1111-1111', 'check credit card number' );

is( $req->cc_exp_month, '09',   'check credit card expiration year'  );
is( $req->cc_exp_year,  '2025', 'check credit card expiration month' );

my $ret = $req->submit;

is( $ret->decision,       'ACCEPT', 'check decision'       );
is( $ret->reference_code, '42',     'check reference_code' );
is( $ret->reason_code,     100,     'check reason_code'    );
is( $ret->currency,       'USD',    'check currency'       );
is( $ret->amount,         '5.00',    'check amount'        );
is( $ret->avs_code,       'Y',       'check avs_code'      );
is( $ret->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret->processor_response, '00',  'check processor_response');

ok( $ret->request_id,    'check request_id exists'    );
ok( $ret->request_token, 'check request_token exists' );
ok( $ret->auth_code,     'check auth_code exists'     );
ok( $ret->datetime,      'check datetime exists'      );
ok( $ret->auth_record,   'check auth_record exists'   );
done_testing;
