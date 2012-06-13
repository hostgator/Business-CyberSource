package Business::CyberSource::CreditCard;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::RequestPart::Card';

use Carp qw( cluck );

around BUILDARGS => sub {
	my $orig = shift;
	my $self = shift;

	cluck 'DEPRECATED: just a thin wrapper around '
		. 'Business::CyberSource::RequestPart::Card use that instead'
		;

	return $self->$orig( @_ );
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: A Credit Card Value Object

=head1 DESCRIPTION

Just a L<Business::CyberSource::RequestPart::Card>, use that instead.

=cut
