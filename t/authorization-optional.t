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

my $dtc = use_module('Business::CyberSource::Request::Authorization');

my $req
	= new_ok( $dtc => [{
		reference_code => 'test-authorization-optional-' . time,
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street1        => '100 somewhere blvd',
		street2        => '#514',
		street3        => 'PO Box foo',
		street4        => 'idk, just putting something here',
		city           => 'Houston',
		state          => 'TX',
		postal_code    => '77064',
		country        => 'US',
		phone_number   => '+1(555)555-5555',
		email          => 'xenoterracide@gmail.com',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
		ip             => '192.168.42.39',
		comments       => 'just a comment',
		full_name      => 'Caleb Cushing',
	}]);

# billing info
is( $req->street1,   '100 somewhere blvd', 'street1'  );
is( $req->street2,   '#514',               'street2'  );
is( $req->full_name, 'Caleb Cushing',      'full_name');
is( $req->ip->addr,  '192.168.42.39', 'ip address'    );

is( $req->ip->addr, $req->_request_data->{billTo}{ipAddress},
	'that ip was added in the request right'
);

my $ret = $client->run_transaction( $req );

isa_ok( $ret, 'Business::CyberSource::Response' )
	or diag( $req->trace->printResponse )
	;

is( $ret->decision,       'ACCEPT', 'decision'       );
is( $ret->reason_code,     100,     'reason_code'    );
is( $ret->currency,       'USD',    'currency'       );
is( $ret->amount,         '5.00',    'amount'        );
is( $ret->avs_code,       'Y',       'avs_code'      );
is( $ret->avs_code_raw,   'Y',       'avs_code_raw'  );
is( $ret->processor_response, '00',  'processor_response');
is( $ret->reason_text, 'Successful transaction', 'reason_text' );

ok( $ret->request_id,    'request_id exists'    );
ok( $ret->request_token, 'request_token exists' );
ok( $ret->auth_code,     'auth_code exists'     );
ok( $ret->datetime,      'datetime exists'      );
ok( $ret->auth_record,   'auth_record exists'   );

done_testing;
