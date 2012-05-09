package Business::CyberSource;
use 5.008;
use strict;
use warnings;

our $VERSION = '0.004007'; # VERSION

1;

# ABSTRACT: Perl interface to the CyberSource Simple Order SOAP API


__END__
=pod

=head1 NAME

Business::CyberSource - Perl interface to the CyberSource Simple Order SOAP API

=head1 VERSION

version 0.004007

=head1 SYNOPSIS

	use 5.010;
	use Carp;
	use Try::Tiny;

	use Business::CyberSource::Client;
	use Business::CyberSource::Authorization;
	use Business::CyberSource::Capture;

	my $client = Business::CyberSource::Client->new({
		username   => 'Merchant ID',
		password   => 'API Key',
		production => 1,
	});

	my $auth_request = try {
			Business::CyberSource::Request::Authorization->new({
				reference_code => '42',
				first_name     => 'Caleb',
				last_name      => 'Cushing',
				street         => '100 somewhere st',
				city           => 'Houston',
				state          => 'TX',
				zip            => '77064',
				country        => 'US',
				email          => 'xenoterracide@gmail.com',
				credit_card    => '4111111111111111',
				cc_exp_month   => '09',
				cc_exp_year    => '2025',
				currency       => 'USD',
				total          => 5.00,
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

			if ( $request->has_trace ) {
				carp 'REQUEST: '
				. $auth_request->trace->request->as_string;
				. 'RESPONSE: '
				. $auth_request->trace->response->as_string;
				;
			}
		};

	unless( $auth_response->is_accepted ) {
		carp $auth_response->reason_text;
	}
	else {
		my $capture_request
			= Business::CyberSource::Request::Capture->new({
				reference_code => $auth_request->reference_code,
				request_id     => $auth_response->request_id,
				total          => $auth_response->amount,
				currency       => $auth_response->currency,
			});

		my $capture_response = try {
			$client->run_transaction( $capture_request );
		}
		catch {
			carp $_;

			if ( $capture_request->has_trace ) {
				carp 'REQUEST: '
				. $capture_request->trace->request->as_string;
				. 'RESPONSE: '
				. $capture_request->trace->response->as_string;
				;
			}
		};

		if ( $capture_response->is_accepted ) {
			# you probably want to record this
			say $capture_response->reconcilliation_id;
		}
	}

This code is not meant to be DRY, but more of a top to bottom example. Also
note that if you really want to do Authorization and Capture at one time use a
L<Sale|Business::CyberSource::Request::Sale>.

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

all environment variables are prefixed with C<PERL_BUSINESS_CYBERSOURCE_>

=head2 DEBUG

=head1 ACKNOWLEDGMENTS

=over

=item * Mark Overmeer

for the help with getting L<XML::Compile::SOAP::WSS> working.

=back

=head1 SEE ALSO

=over

=item * L<Checkout::CyberSource::SOAP>

=item * L<Business::OnlinePayment::CyberSource>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

