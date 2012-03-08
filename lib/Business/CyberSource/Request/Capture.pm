package Business::CyberSource::Request::Capture;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = '0.004004'; # VERSION

use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::FollowUp
	Business::CyberSource::Request::Role::DCC
);

use Business::CyberSource::Response;
use MooseX::StrictConstructor;

sub submit {
	my $self = shift;

	$self->_request_data->{ccCaptureService}{run} = 'true';
	$self->_request_data->{ccCaptureService}{authRequestID}
		= $self->request_id
		;

	my $r = $self->_build_request;

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::ReconciliationID
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
				reconciliation_id => $r->{ccCaptureReply}->{reconciliationID},
				request_specific_reason_code =>
					"$r->{ccCaptureReply}->{reasonCode}",
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


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Capture - CyberSource Capture Request Object

=head1 VERSION

version 0.004004

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

=head1 METHODS

=head2 new

Instantiates a authorization reversal request object, see
L<the attributes listed below|/ATTRIBUTES> for which ones are required and
which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

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

