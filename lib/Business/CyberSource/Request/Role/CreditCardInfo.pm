package Business::CyberSource::Request::Role::CreditCardInfo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;

use MooseX::Types::CyberSource qw( Card);

sub _build_skipable { return $_[0]->card->is_expired } ## no critic (Subroutines::RequireArgUnpacking)

has card => (
	isa         => Card,
	remote_name => 'card',
	required    => 1,
	is          => 'ro',
	coerce      => 1,
);

1;

# ABSTRACT: credit card info role

=attr card

L<Business::CyberSource::RequestPart::Card>

=cut
