package Business::CyberSource::Request::Capture;
use 5.008;
use strict;
use warnings;
use Carp;

# VERSION

use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::FollowUp
);

use Business::CyberSource::Response;

sub submit {
	my $self = shift;

	my $payload = {
		ccCaptureService => {
			run => 'true',
			authRequestID => $self->request_id,
		},
	};

	my $r = $self->_build_request( $payload );

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::Capture
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				reference_code => $r->{merchantReferenceCode},
				request_token  => $r->{requestToken},
				currency       => $r->{purchaseTotals}->{currency},
				datetime       => $r->{ccCaptureReply}->{requestDateTime},
				amount         => $r->{ccCaptureReply}->{amount},
				reference_code => $r->{merchantReferenceCode},
				reconciliation_id => $r->{ccCaptureReply}->{reconciliationID},
				capture_reason_code => "$r->{ccCaptureReply}->{reasonCode}",
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

# ABSTRACT: CyberSource Capture Request Object

=head1 SYNOPSIS

	my $capture = Business::CyberSource::Request::Capture->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
		reference_code => 'merchant reference code',
		request_id     => 'authorization response request_id',
		total          => 5.01,  # same amount as in authorization
		currency       => 'USD', # same currency as in authorization
	});

=head1 DESCRIPTION

This object allows you to create a request for a capture.

=method new

Instantiates a authorization reversal request object, see
L<the attributes listed below|/ATTRIBUTES> for which ones are required and
which are optional.

=method submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

=cut
