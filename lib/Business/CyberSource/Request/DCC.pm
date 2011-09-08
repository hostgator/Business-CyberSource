package Business::CyberSource::Request::DCC;
use 5.008;
use strict;
use warnings;
use Carp;

# VERSION

use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

use Business::CyberSource::Response;

sub submit {
	my $self = shift;

	my $payload = {
		card                  => $self->_cc_info,
		ccDCCService => {
			run => 'true',
		},
	};

	my $r = $self->_build_request( $payload );

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::Credit
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				request_token  => $r->{requestToken},
				reference_code => $r->{merchantReferenceCode},
				currency       => $r->{purchaseTotals}->{currency},
				datetime       => $r->{ccCaptureReply}->{requestDateTime},
				amount         => $r->{ccCaptureReply}->{amount},
			})
			;
	}
	else {
		$res = $self->_handle_decision( $r );
	}

	return $res;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource DCC Request Object

=head1 DESCRIPTION

This object allows you to create a request for Direct Currency Conversion.
This object is not known to work correctly. Although it follows the
CyberSource Documentation for DCC request, the response returned appears to
always be a 150 General Error.

=method new

Instantiates a DCC request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=method submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

=cut
