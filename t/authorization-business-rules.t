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

my $authc = use_module('Business::CyberSource::Request::Authorization');

my $auth_req0
	= new_ok( $authc => [{
		reference_code => 'test-auth-business-rules-0-' . time,
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
	}]);

my $auth_res0 = $client->run_transaction( $auth_req );

isa_ok $auth_res0, 'Business::CyberSource::Response';

is( $auth_res0->decision,       'ACCEPT', 'check decision'       );
is( $auth_res0->reference_code, 't109-0', 'check reference_code' );
is( $auth_res0->reason_code,     100,     'check reason_code'    );
is( $auth_res0->currency,       'USD',    'check currency'       );
is( $auth_res0->amount,         '9001.00',    'check amount'     );
is( $auth_res0->avs_code,       'Y',       'check avs_code'      );
is( $auth_res0->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $auth_res0->processor_response, 'C2',  'check processor_response');
is( $auth_res0->reason_text, 'Successful transaction', 'check reason_text' );
is( $auth_res0->auth_code, '831000',     'check auth_code exists');

ok( $auth_res0->request_id,    'check request_id exists'    );
ok( $auth_res0->request_token, 'check request_token exists' );
ok( $auth_res0->datetime,      'check datetime exists'      );
ok( $auth_res0->auth_record,   'check auth_record exists'   );

my $auth_req1
	= new_ok( $authc => [{
		reference_code => 'test-auth-business-rules-1-' . time,
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


my $auth_res1 = $client->run_transaction( $auth_req1 );

isa_ok $auth_res1, 'Business::CyberSource::Response';

is( $auth_res1->decision,       'ACCEPT', 'check decision'       );
is( $auth_res1->reference_code, 't109-1', 'check reference_code' );
is( $auth_res1->reason_code,     100,     'check reason_code'    );
is( $auth_res1->currency,       'USD',    'check currency'       );
is( $auth_res1->amount,         '5005.00',    'check amount'     );
is( $auth_res1->avs_code,       'N',       'check avs_code'      );
is( $auth_res1->avs_code_raw,   'N',       'check avs_code_raw'  );
is( $auth_res1->processor_response, '00',  'check processor_response');
is( $auth_res1->reason_text, 'Successful transaction', 'check reason_text' );
is( $auth_res1->auth_code, '831000',     'check auth_code exists');

ok( $auth_res1->request_id,    'check request_id exists'    );
ok( $auth_res1->request_token, 'check request_token exists' );
ok( $auth_res1->datetime,      'check datetime exists'      );
ok( $auth_res1->auth_record,   'check auth_record exists'   );

my $auth_req2
	= new_ok( $authc => [{
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
		decline_avs_flags => [ qw( Y N ) ],
	});

my $auth_res2 = $client->run_transaction( $auth_req2 );

isa_ok $auth_res2, 'Business::CyberSource::Response';

is( $auth_res2->decision,       'REJECT', 'check decision'       );
is( $auth_res2->reason_code,     200,     'check reason_code'    );
is( $auth_res2->avs_code,       'Y',       'check avs_code'      );
is( $auth_res2->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $auth_res2->processor_response, '00',  'check processor_response');
is( $auth_res2->auth_code, '831000',     'check auth_code exists');

ok( $auth_res2->request_id,    'check request_id exists'    );
ok( $auth_res2->request_token, 'check request_token exists' );
ok( $auth_res2->auth_record,   'check auth_record exists'   );

done_testing;
