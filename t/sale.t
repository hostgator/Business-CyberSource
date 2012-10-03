use strict;
use warnings;
use Test::More;

use Class::Load 0.20 qw( load_class );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( load_class('Test::Business::CyberSource') );

my $client      = $t->resolve( service => '/client/object'      );
my $credit_card = $t->resolve( service => '/helper/card'      );
my $billto      = $t->resolve( service => '/helper/bill_to'   );

my $salec = load_class('Business::CyberSource::Request::Sale');

my $req
	= new_ok( $salec => [{
		reference_code  => 'test-sale-reject-' . time,
		card            => $credit_card,
		bill_to         => $billto,
		purchase_totals => {
			total    => 3000.01,
			currency => 'USD',
		},
	}]);

my $ret = $client->run_transaction( $req );

is( $ret->decision,       'ACCEPT', 'check decision'       );
is( $ret->reason_code,     100,     'check reason_code'    );
is( $ret->currency,       'USD',    'check currency'       );
is( $ret->amount,         '3000.01',    'check amount'     );
is( $ret->avs_code,       'Y',       'check avs_code'      );
is( $ret->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret->processor_response, '00',  'check processor_response');
is( $ret->reason_text, 'Successful transaction', 'check reason_text' );
is( $ret->auth_code, '841000',     'check auth_code exists');

ok( $ret->request_id,    'check request_id exists'    );
ok( $ret->request_token, 'check request_token exists' );
ok( $ret->datetime,      'check datetime exists'      );
ok( $ret->auth_record,   'check auth_record exists'   );
ok( $ret->reconciliation_id, 'reconciliation_id exists' );
done_testing;
