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
		reference_code => 't104',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 9000.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		cvn            => '1111',
		production     => 0,
	})
} 'Authorization object initialized';


note( Dumper $req->_request_data );

# check billing info
is( $req->cvn,   '1111', 'check cvn'   );
is( $req->total, '9000', 'check total' );


SKIP: {
	skip 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!',
		16
		unless $CYBS_ID and $CYBS_KEY
		;

	my $ret;

	lives_ok { $ret = $req->submit } 'submit';

	note( $req->trace->printRequest  );
	note( $req->trace->printResponse );

	is( $ret->decision,       'ACCEPT', 'check decision'       );
	is( $ret->reference_code, 't104',   'check reference_code' );
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
}
done_testing;
