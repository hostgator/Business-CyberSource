use strict;
use warnings;
use Test::More;
use Test::Exception;
use Data::Dumper;
use Test::Requires::Env qw(
	PERL_BUSINESS_CYBERSOURCE_USERNAME
	PERL_BUSINESS_CYBERSOURCE_PASSWORD
);

my ( $cybs_id, $cybs_key )
	= (
		$ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
		$ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
	);

use Business::CyberSource::Request::Credit;

my $req;
lives_ok {
	$req = Business::CyberSource::Request::Credit
	->with_traits(qw{
		BillingInfo
		CreditCardInfo
	})
	->new({
		username       => $cybs_id,
		password       => $cybs_key,
		production     => 0,
		reference_code => 't301',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		ip             => '192.168.100.2',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '3566 1111 1111 1113',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	})
} 'new credit request';

note( Dumper $req->_request_data );

	my $ret;
	lives_ok { $ret = $req->submit } 'submit';

	note( $req->trace->request->decoded_content );
	note( $req->trace->response->decoded_content );

# check billing info
	is( $req->reference_code, 't301',      'check reference_code' );
	is( $req->first_name,     'Caleb',     'check first_name'     );
	is( $req->last_name,      'Cushing',   'check first_name'     );
	is( $req->street,         'somewhere', 'check street'         );
	is( $req->city,           'Houston',   'check city'           );
	is( $req->state,          'TX',        'check state'          );
	is( $req->country,        'US',        'check country'        );

	is( $req->ip->addr,   '192.168.100.2',          'check ip'    );
	is( $req->email, 'xenoterracide@gmail.com', 'check email' );

	is( $req->total,      5, 'check total'      );

	is( $req->currency, 'USD', 'check currency' );

	is( $req->cc_exp_month, '09',   'check credit card expiration year'  );
	is( $req->cc_exp_year,  '2025', 'check credit card expiration month' );

	is( $req->card_type, '007', 'check card type is JCB' );

	ok( $ret, 'request response exists' );

	is( $ret->reference_code, 't301', 'check response reference code' );
	is( $ret->decision,       'ACCEPT', 'check decision'       );
	is( $ret->reason_code,     100,     'check reason_code'    );
	is( $ret->currency,       'USD',    'check currency'       );
	is( $ret->amount,         '5.00',    'check amount'        );

	ok( $ret->request_id,    'check request_id exists'    );
	ok( $ret->datetime,      'check datetime exists'      );
done_testing;
