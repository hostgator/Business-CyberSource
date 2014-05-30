use strict;
use warnings;
use Test::More;
use Test::Fatal;
use Module::Runtime qw( use_module );

# this test uses a response from a sale

my $res
	= new_ok( use_module('Business::CyberSource::Response') => [{
		'ccAuthReply' => {
			'processorResponse' => '00',
			'authorizedDateTime' => '2012-10-30T00:25:38Z',
				'reasonCode' => '100',
				'authorizationCode' => '841000',
				'amount' => '3000.01',
				authRecord => '0110322000000E10003840979308471907091389487900270'
					. '728165933335487401834987091873407037490173409710734104400'
					. '18349839749037947073094710974070173405303730333830323'
					. '03934734070970137490713904709',
				'avsCodeRaw' => 'Y',
				'avsCode' => 'Y',
				'reconciliationID' => 'Y37080808BUW'
		},
		'purchaseTotals' => {
			'currency' => 'USD'
		},
		'ccCaptureReply' => {
			'amount' => '3000.01',
			'requestDateTime' => '2012-10-30T00:25:38Z',
			'reconciliationID' => '51142857',
			'reasonCode' => '100'
		},
		'decision' => 'ACCEPT',
		'reasonCode' => '100',
		'requestID' => '3515567380160176056470',
		requestToken => 'Ahj/7omgletsmakesurethisissecurebychangingitsguts'
			. '/Imnotgivingyouarealcode/Icanthearyouu2AAAA/QAO',
		merchantReferenceCode => 'test-1349678423',
	}]);

ok ! $res->can('serialize'), 'can not serialize';

can_ok $res, qw(
		auth
		purchase_totals
		capture
		decision
		reason_code
		request_id
		request_token
		reference_code
	);

is $res->decision,           'ACCEPT',          '->decision';
is $res->reason_code,        '100',             '->reason_code';
is $res->request_id, '3515567380160176056470',  '->request_id';
ok $res->is_accept,                             '->is_accept';
ok $res->request_token,                         '->request_token';
is $res->reference_code, 'test-1349678423',     '->reference_code';

ok ! $res->is_reject,                           '->is_reject';
ok ! $res->is_error,                            '->is_error';

isa_ok my $auth = $res->auth, 'Business::CyberSource::ResponsePart::AuthReply';
isa_ok my $capt = $res->capture, 'Business::CyberSource::ResponsePart::Reply';

can_ok $auth, qw(
	processor_response
	datetime
	reason_code
	amount
	auth_record
	auth_code
	avs_code
	avs_code_raw
	cv_code
	cv_code_raw
	reconciliation_id
);

is $auth->processor_response, '00',       '->processor_response';
is $auth->reason_code,        '100',      '->reason_code';
is $auth->amount,             '3000.01',  '->amount';
ok $auth->auth_record,                    '->auth_record';
is $auth->auth_code,          '841000',   '->auth_code';
is $capt->reason_code,        '100',      '->reason_code';
is $capt->amount,             '3000.01',  '->amount';
is $capt->reconciliation_id,  '51142857', '->reconciliation_id';

isa_ok $auth->datetime, 'DateTime';
isa_ok $capt->datetime, 'DateTime';

is $auth->datetime->year, '2012', 'auth year';
is $capt->datetime->year, '2012', 'capt year';

done_testing;
