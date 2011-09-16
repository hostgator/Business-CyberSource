#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Env qw( CYBS_ID CYBS_KEY );
use Test::More;

plan skip_all
	=> 'You MUST set ENV variable CYBS_ID and CYBS_KEY to test this!'
	unless $CYBS_ID and $CYBS_KEY
	;

use Business::CyberSource::Request::Authorization;

my $req0
	= Business::CyberSource::Request::Authorization->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		reference_code => 't109-0',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 9001.00,
		currency       => 'USD',
		credit_card    => '4111111111111111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		cvn            => '1111',
		ignore_cv_result => 1,
		production     => 0,
	});

my $ret0;

eval { $ret0 = $req0->submit };

note( $req0->trace->printRequest  );
note( $req0->trace->printResponse );

is( $ret0->decision,       'ACCEPT', 'check decision'       );
is( $ret0->reference_code, 't109-0', 'check reference_code' );
is( $ret0->reason_code,     100,     'check reason_code'    );
is( $ret0->currency,       'USD',    'check currency'       );
is( $ret0->amount,         '9001.00',    'check amount'     );
is( $ret0->avs_code,       'Y',       'check avs_code'      );
is( $ret0->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret0->processor_response, 'C2',  'check processor_response');
is( $ret0->reason_text, 'Successful transaction', 'check reason_text' );
is( $ret0->auth_code, '831000',     'check auth_code exists');

ok( $ret0->request_id,    'check request_id exists'    );
ok( $ret0->request_token, 'check request_token exists' );
ok( $ret0->datetime,      'check datetime exists'      );
ok( $ret0->auth_record,   'check auth_record exists'   );


my $req1
	= Business::CyberSource::Request::Authorization->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		production     => 0,
		reference_code => 't109-1',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5005.00,
		currency       => 'USD',
		credit_card    => '4111111111111111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		ignore_avs_result => 1,
	});

my $ret1;

eval { $ret1 = $req1->submit };

note( $req1->trace->printRequest  );
note( $req1->trace->printResponse );

is( $ret1->decision,       'ACCEPT', 'check decision'       );
is( $ret1->reference_code, 't109-1', 'check reference_code' );
is( $ret1->reason_code,     100,     'check reason_code'    );
is( $ret1->currency,       'USD',    'check currency'       );
is( $ret1->amount,         '5005.00',    'check amount'     );
is( $ret1->avs_code,       'N',       'check avs_code'      );
is( $ret1->avs_code_raw,   'N',       'check avs_code_raw'  );
is( $ret1->processor_response, '00',  'check processor_response');
is( $ret1->reason_text, 'Successful transaction', 'check reason_text' );
is( $ret1->auth_code, '831000',     'check auth_code exists');

ok( $ret1->request_id,    'check request_id exists'    );
ok( $ret1->request_token, 'check request_token exists' );
ok( $ret1->datetime,      'check datetime exists'      );
ok( $ret1->auth_record,   'check auth_record exists'   );

my $req2
	= Business::CyberSource::Request::Authorization->new({
		username       => $CYBS_ID,
		password       => $CYBS_KEY,
		production     => 0,
		reference_code => 't109-2',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5001.00,
		currency       => 'USD',
		credit_card    => '4111111111111111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		decline_avs_flags => [ 'Y' ],
	});

my $ret2;

eval { $ret2 = $req2->submit };

note( $req2->trace->printRequest  );
note( $req2->trace->printResponse );

is( $ret2->decision,       'REJECT', 'check decision'       );
is( $ret2->reason_code,     200,     'check reason_code'    );
is( $ret2->avs_code,       'Y',       'check avs_code'      );
is( $ret2->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret2->processor_response, '00',  'check processor_response');
is( $ret2->reason_text, 'Successful transaction', 'check reason_text' );
is( $ret2->auth_code, '831000',     'check auth_code exists');

ok( $ret2->request_id,    'check request_id exists'    );
ok( $ret2->request_token, 'check request_token exists' );
ok( $ret2->datetime,      'check datetime exists'      );
ok( $ret2->auth_record,   'check auth_record exists'   );

done_testing;
