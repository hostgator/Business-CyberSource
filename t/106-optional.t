#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;
use Test::Exception;
use Data::Dumper;

use Business::CyberSource::Request::Authorization;

my ( $cybs_id, $cybs_key ) = ( $CYBS_ID, $CYBS_KEY );

$cybs_id  ||= 'test';
$cybs_key ||= 'test';

my $req;
lives_ok {
	$req = Business::CyberSource::Request::Authorization->new({
		username       => $cybs_id,
		password       => $cybs_key,
		production     => 0,
		reference_code => '36',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street1        => '100 somewhere blvd',
		street2        => '#514',
		street3        => 'PO Box foo',
		street4        => 'idk, just putting something here',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		ip             => '192.168.42.39',
		full_name      => 'Caleb Cushing',
	})
} 'new' . ref( $req );

note( Dumper $req->_request_data );

is( $req->username, $CYBS_ID,  'check username' );
is( $req->password, $CYBS_KEY, 'check key'      );
is( $req->client_name , 'Business::CyberSource', 'check client_library'    );
ok( $req->client_env,                            'check client_env exists' );

# check billing info
is( $req->reference_code, '36',        'check reference_code' );
is( $req->first_name,     'Caleb',     'check first_name'     );
is( $req->last_name,      'Cushing',   'check first_name'     );
is( $req->street1,        '100 somewhere blvd', 'check street1');
is( $req->street2,        '#514',      'check street2'        );
is( $req->city,           'Houston',   'check city'           );
is( $req->state,          'TX',        'check state'          );
is( $req->country,        'US',        'check country'        );
is( $req->ip->addr,       '192.168.42.39', 'check ip address' );

is( $req->email, 'xenoterracide@gmail.com', 'check email' );

is( $req->total,      5, 'check total'      );

is( $req->currency, 'USD', 'check currency' );

is( $req->credit_card,  '4111111111111111', 'check credit card number' );
is( $req->full_name,    'Caleb Cushing'   , 'check full_name'          );

is( $req->cc_exp_month, '09',   'check credit card expiration year'  );
is( $req->cc_exp_year,  '2025', 'check credit card expiration month' );

my $ret = $req->submit;

is( $ret->decision,       'ACCEPT', 'check decision'       );
is( $ret->reference_code, '36',     'check reference_code' );
is( $ret->reason_code,     100,     'check reason_code'    );
is( $ret->currency,       'USD',    'check currency'       );
is( $ret->amount,         '5.00',    'check amount'        );
is( $ret->avs_code,       'Y',       'check avs_code'      );
is( $ret->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret->processor_response, '00',  'check processor_response');
is( $ret->reason_text, 'Successful transaction', 'check reason_text' );

ok( $ret->request_id,    'check request_id exists'    );
ok( $ret->request_token, 'check request_token exists' );
ok( $ret->auth_code,     'check auth_code exists'     );
ok( $ret->datetime,      'check datetime exists'      );
ok( $ret->auth_record,   'check auth_record exists'   );
done_testing;
