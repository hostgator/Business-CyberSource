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
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => 't108',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		items          => [
			{
				unit_price => 1000.00,
				quantity   => 2,
			},
			{
				unit_price => 1000.00,
				quantity   => 1,
			},
		],
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		production     => 0,
	});

} 'Authorization object initialized';

note( Dumper $req->_request_data );

SKIP: {
	skip 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!',
		17
		unless $CYBS_ID and $CYBS_KEY
		;

	is( $req->username, $CYBS_ID,  'check username' );
	is( $req->password, $CYBS_KEY, 'check key'      );

	my $ret;

	lives_ok { $ret = $req->submit } 'submit';

	note( $req->trace->request->decoded_content );
	note( $req->trace->response->decoded_content );

	is( $ret->decision,       'ACCEPT', 'check decision'       );
	is( $ret->reference_code, 't108',   'check reference_code' );
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
