package Business::CyberSource;
use 5.010;
use strict;
use warnings;

# VERSION

1;

# ABSTRACT: Perl interface to the CyberSource Simple Order SOAP API

=encoding utf8

=head1 DESCRIPTION

This library is a Perl interface to the CyberSource Simple Order SOAP API built
on L<Moose> and L<XML::Compile::SOAP> technologies. This library aims to
eventually provide a full interface the SOAPI.

You may wish to read the Official CyberSource Documentation on L<Credit Card
Services for the Simpler Order
API|http://apps.cybersource.com/library/documentation/dev_guides/CC_Svcs_SO_API/html/>
as it will provide further information on why what some things are and the
general workflow.

To get started you will want to read the documentation in
L<Business::CyberSource::Client> and L<Business::CyberSource::Request>. If you
find any documentation unclear or outright missing, please file a bug.

If there are features that are part of CyberSource's API but are not
documented, or are missing here, please file a bug. I'll be happy to add them,
but due to the size of the upstream API, I have not had time to cover all the features
and some are currently undocumented.

=head1 ENVIRONMENT

=head2 Debugging

Supports L<MooseY::RemoteHelper::Role::Client>s C<REMOTE_CLIENT_DEBUG>
variable. This can be set to either C<0>, C<1>, C<2>, for varying levels of
verbosity.

=head2 Testing

all environment variables are prefixed with C<PERL_BUSINESS_CYBERSOURCE_>

=head3 Credentials

=head4 USERNAME

=head4 PASSWORD

set's the L<username|Busines::CyberSource::Client/"username"> and
L<password|Busines::CyberSource::Client/"password"> in the client for running
tests.

=head3 Direct Currency Conversion

=head4 DCC_CC_YYYY

sets the test credit card expiration year for both Visa and MasterCard

=head4 DCC_CC_MM

sets the test credit card expiration month for both Visa and MasterCard

=head4 DCC_MASTERCARD

A test credit card number provided by your your credit card processor

=head4 DCC_VISA

A test credit card number provided by your your credit card processor

=head1 EXAMPLE

	use 5.010;
	use Carp;
	use Try::Tiny;

	use Business::CyberSource::Client;
	use Business::CyberSource::Request::Authorization;
	use Business::CyberSource::Request::Capture;

	my $client = Business::CyberSource::Client->new({
		user  => 'Merchant ID',
		pass  => 'API Key',
		test  => 1,
		debug => 1, # do not set in production as it prints sensative
                         # information
	});

	my $auth_request;
	try {
		$auth_request
			= Business::CyberSource::Request::Authorization->new({
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
	return unless $auth_request;

	my $auth_response;
	try {
		$auth_response = $client->submit( $auth_request );
	}
	catch {
		carp $_;
	};
	return unless $auth_response;

	unless( $auth_response->is_accept ) {
		carp $auth_response->reason_text;
	}
	else {
		my $capture_request
			= Business::CyberSource::Request::Capture->new({
				reference_code => $auth_response->reference_code,
				service => {
					request_id => $auth_response->request_id,
				},
				purchase_totals => {
					total    => $auth_response->auth->amount,
					currency => $auth_response->purchase_totals->currency,
				},
			});

		my $capture_response;
		try {
			$capture_response = $client->submit( $capture_request );
		}
		catch {
			carp $_;
		};
		return unless $capture_response;

		if ( $capture_response->is_accept ) {
			# you probably want to record this
			say $capture_response->capture->reconciliation_id;
		}
	}

This code is not meant to be DRY, but more of a top to bottom example. Also
note that if you really want to do Authorization and Capture at one time use a
L<Sale|Business::CyberSource::Request::Sale>. Most common Reasons for
Exceptions would be bad input into the request object (which validates things)
or CyberSource just randomly throwing an ERROR, in which case you can usually
just retry later. You don't have to print the response on error during
development, you can easily just use the L<DEBUG Environment variable|/"DEBUG">

=head1 ACKNOWLEDGMENTS

=over

=item * Mark Overmeer

for the help with getting L<XML::Compile::SOAP::WSS> working.

=item * L<HostGator|http://hostgator.com>

funding initial development.

=item * L<GüdTech|http://gudtech.com>

funding further development.

=back

=head1 SEE ALSO

=over

=item * L<Checkout::CyberSource::SOAP>

=item * L<Business::OnlinePayment::CyberSource>

=back

=cut
