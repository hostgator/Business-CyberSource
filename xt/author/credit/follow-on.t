use strict;
use warnings;
use Test::More;
use FindBin;
use Module::Runtime qw( use_module    );
use Test::Requires  qw( Path::FindDev );
use lib Path::FindDev::find_dev( $FindBin::Bin )->child('t', 'lib' )->stringify;

my $t = use_module('Test::Business::CyberSource')->new;

my $client   = $t->resolve( service => '/client/object'    );
my $auth_res
	= $client->run_transaction(
		$t->resolve( service => '/request/authorization' )
	);

my $capturec = use_module('Business::CyberSource::Request::Capture');
my $creditc  = use_module('Business::CyberSource::Request::Credit');

my $capture_req
	= new_ok( $capturec => [{
		reference_code => $auth_res->reference_code,
		service => {
			request_id => $auth_res->request_id,
		},
		purchase_totals => {
			total    => $auth_res->auth->amount,
			currency => $auth_res->currency,
		},
	}])
	;

my $capture_res = $client->run_transaction( $capture_req );

isa_ok( $capture_res, 'Business::CyberSource::Response' );

ok ! ref $capture_res->request_id, 'request_id not a reference';

my $credit_req
	= new_ok( $creditc => [{
		reference_code => $auth_res->reference_code,
		purchase_totals => {
			total    => 3000.00,
			currency => 'USD',
		},
		service => {
			request_id => $capture_res->request_id,
		},
	}]);

my $credit_res = $client->run_transaction( $credit_req  );

isa_ok( $credit_res, 'Business::CyberSource::Response'  );

is( $credit_res->decision,             'ACCEPT',  'decision'    );
is( $credit_res->reason_code,          100,      'reason_code'  );
is( $credit_res->currency,             'USD',     'currency'    );
is( $credit_res->credit->amount,       '3000.00', 'amount'      );

ok( $credit_res->request_id,           'request_id exists'      );
isa_ok( $credit_res->credit->datetime, 'DateTime'               );

done_testing;
