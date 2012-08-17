use strict;
use warnings;
use 5.010;
use Carp;
use Try::Tiny;

use Business::CyberSource::Client;
use Business::CyberSource::Request::Authorization;
use Business::CyberSource::Request::Capture;

my $client = Business::CyberSource::Client->new({
	username   => $ENV{PERL_BUSINESS_CYBERSOURCE_USERNAME},
	password   => $ENV{PERL_BUSINESS_CYBERSOURCE_PASSWORD},
	production => 0,
});

my $auth_request = try {
		Business::CyberSource::Request::Authorization->new({
			reference_code => '42',
			bill_to => {
				first_name  => 'Caleb',
				last_name   => 'Cushing',
				street      => '100 somewhere st',
				city        => 'Houston',
				state       => 'TX',
				postal_code => '77064',
				country     => 'US',
				email       => 'xenoterracide@gmail.com',
			},
			purchase_totals => {
				currency => 'USD',
				total    => 5.00,
			},
			card => {
				account_number => '4111111111111111',
				expiration => {
					month => 9,
					year  => 2025,
				},
			},
		});
	}
	catch {
		carp $_;
	};

my $auth_response = try {
		$client->run_transaction( $auth_request );
	}
	catch {
		carp $_;

		if ( $auth_request->has_trace ) {
			carp 'REQUEST: '
			. $auth_request->trace->request->as_string
			. 'RESPONSE: '
			. $auth_request->trace->response->as_string
			;
		}
	};

unless( $auth_response->is_accepted ) {
	carp $auth_response->reason_text;
}
else {
	say 'Authorization successful';
	my $capture_request
		= Business::CyberSource::Request::Capture->new({
			reference_code => $auth_response->reference_code,
			service => {
				request_id => $auth_response->request_id,
			},
			purchase_totals => {
				total    => $auth_response->amount,
				currency => $auth_response->currency,
			},
		});

	my $capture_response = try {
		$client->run_transaction( $capture_request );
	}
	catch {
		carp $_;

		if ( $capture_request->has_trace ) {
			carp 'REQUEST: '
			. $capture_request->trace->request->as_string
			. 'RESPONSE: '
			. $capture_request->trace->response->as_string
			;
		}
	};

	if ( $capture_response->is_accepted ) {
		# you probably want to record this
		say $capture_response->reconciliation_id;
	}
}
