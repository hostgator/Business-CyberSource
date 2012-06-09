package Business::CyberSource::Request::Capture;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Request';
with 'Business::CyberSource::Request::Role::DCC';

has '+service' => ( remote_name => 'ccCaptureService' );

sub BUILD { ## no critic ( Subroutines::RequireFinalReturn )
	my $self = shift;

	confess 'Capture must have an auth_request_id'
		unless $self->service->has_auth_request_id
		;

	confess 'Capture Must not have a capture_request_id'
		if $self->service->has_capture_request_id
		;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Capture Request Object

=head1 SYNOPSIS

	my $capture = Business::CyberSource::Request::Capture->new({
		reference_code => 'merchant reference code',
		request_id     => 'authorization response request_id',
		total          => 5.01,  # same amount as in authorization
		currency       => 'USD', # same currency as in authorization
	});

=head1 DESCRIPTION

This object allows you to create a request for a capture.

=head2 inherits

L<Business::CyberSource::Request>

=head2 composes

=over

=item L<Business::CyberSource::Request::Role::FollowUp>

=item L<Business::CyberSource::Request::Role::DCC>

=back

=cut
