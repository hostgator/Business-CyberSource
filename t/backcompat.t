use strict;
use warnings;
use Test::More;
use Class::Load 'load_class';

my $dcc
	= new_ok( load_class('Business::CyberSource::Response') => [{
		'ccDCCReply' => {
			'validHours' => '1277',
			'marginRatePercentage' => '03.0000',
			'dccSupported' => 'TRUE',
			'reasonCode' => '100'
		},
		'purchaseTotals' => {
			'currency' => 'USD',
			'exchangeRateTimeStamp' => '20090101 00:00',
			'exchangeRate' => '0.8810',
			'foreignAmount' => '0.88',
			'foreignCurrency' => 'EUR'
		},
		'decision' => 'ACCEPT',
		'reasonCode' => '100',
		'requestID' => '3523707038974018737442',
		'requestToken' => 'AhjzbwSRfhJ+PBljduoOjaSftQ/B8TaQHoudanOWUaOdpK0X'
			. 'gMgAIxto',
		'merchantReferenceCode' => 'test-dcc-authorization-1352399438'
	}]);

is $dcc->foreign_currency, 'EUR',              'dcc response foreign_currency';
is $dcc->foreign_amount,  '0.88',                'dcc response foreign_amount';
is $dcc->exchange_rate, '0.8810',                 'dcc response exchange_rate';
is $dcc->dcc_supported,        1,                 'dcc response dcc_supported';
ok $dcc->reference_code,                               'reference code exists';
is $dcc->request_specific_reason_code, 100,           'DCC Reason code is 100';
is $dcc->currency, 'USD',                                     'check currency';
is $dcc->dcc_supported, 1,                               'check dcc supported';
is $dcc->exchange_rate_timestamp, '20090101 00:00', 'check exchange timestamp';
ok $dcc->valid_hours,                               'check valid hours exists';
is $dcc->margin_rate_percentage, '03.0000',     'check margin rate percentage';

my $credit
	= new_ok( load_class('Business::CyberSource::Response') => [{
		'ccCreditReply' => {
			'amount' => '1.00',
			'requestDateTime' => '2012-11-08T18:49:45Z',
			'reconciliationID' => '50934978',
			'reasonCode' => '100'
		},
			'purchaseTotals' => {
			'currency' => 'USD'
		},
		'decision' => 'ACCEPT',
		'reasonCode' => '100',
		'requestID' => '3524005857290176056442',
		'requestToken' => 'Ahj/7wSRfhLPoHHBtJjoupudaphoOW7hP1d/IkAwJP2pudap'
			. 'ondfpAOUJOUONoufooooonpEs+RLtvEIPQAA8ipt',
		'merchantReferenceCode' => 'test-dcc-authorization-1352400581'
	}]);

is $credit->amount, '1.00', 'amount';

done_testing;
