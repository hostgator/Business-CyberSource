package Business::CyberSource::Request::AuthReversal;
use strict;
use warnings;
use namespace::autoclean -also => [ qw( create ) ];

# VERSION

use Moose;
extends 'Business::CyberSource::Request';
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::FollowUp
);

before serialize => sub {
	my $self = shift;

	$self->_request_data->{ccAuthReversalService}{run} = 'true';
	$self->_request_data->{ccAuthReversalService}{authRequestID}
		= $self->request_id
		;
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Reverse Authorization request object

=head1 SYNOPSIS

	my $req = Business::CyberSource::Request::AuthReversal->new({
		reference_code => 'orignal authorization merchant reference code',
		request_id     => 'request id returned in original authorization response',
		total          => 5.00, # same as original authorization amount
		currency       => 'USD', # same as original currency
	});

=head1 DESCRIPTION

This allows you to reverse an authorization request.

=head2 inherits

L<Business::CyberSource::Request>

=head2 composes

=over

=item L<Business::CyberSource::Request::Role::PurchaseInfo>

=item L<Business::CyberSource::Request::Role::FollowUp>

=back

=cut
