use strict;
use warnings;
use Test::More;

use Module::Runtime qw( use_module );
use FindBin; use lib "$FindBin::Bin/lib";

my $t = new_ok( use_module('Test::Business::CyberSource') );

my $client = $t->resolve( service => '/client/object'    );

my $authc = use_module('Business::CyberSource::Request::Authorization');
my $ptc   = use_module('Business::CyberSource::Helper::PurchaseTotals');

my $req
	= new_ok( $authc => [{
		reference_code  => $t->resolve( service => '/request/reference_code' ),
		billing_info    => $t->resolve( service => '/helper/bill_to' ),
		card            => $t->resolve( service => '/helper/card' ),
		purchase_totals => new_ok( $ptc => [{ currency => 'USD' }]),
	}]);

my @items = (
	{
		unit_price => '0.01',
		quantity   => 1,
	},
	{
		unit_price => 1000.00,
		quantity   => 2,
		product_name => 'candybarz',
		product_code => 't108-code',
		product_sku  => '123456',
		tax_amount   => '0.01',
	},
	{
		unit_price => 1000.00,
		quantity   => 1,
	}
);

foreach my $item ( @items ) {
	$req->add_item( $item );
}

my $ret = $client->run_transaction( $req );

isa_ok $ret, 'Business::CyberSource::Response';

is( $ret->decision,       'ACCEPT', 'check decision'       );
is( $ret->reason_code,     100,     'check reason_code'    );
is( $ret->currency,       'USD',    'check currency'       );
is( $ret->amount,         '3000.02',    'check amount'     );
is( $ret->avs_code,       'Y',       'check avs_code'      );
is( $ret->avs_code_raw,   'Y',       'check avs_code_raw'  );
is( $ret->processor_response, '85',  'check processor_response');
is( $ret->reason_text, 'Successful transaction', 'check reason_text' );
is( $ret->auth_code, '831000',     'check auth_code exists');

ok( $ret->request_id,    'check request_id exists'    );
ok( $ret->request_token, 'check request_token exists' );
ok( $ret->datetime,      'check datetime exists'      );
ok( $ret->auth_record,   'check auth_record exists'   );

done_testing;
