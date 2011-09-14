package Business::CyberSource::Request::Role::Items;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::Types::CyberSource qw( Items );

has items => (
	required  => 0,
	predicate => 'has_items',
	is        => 'ro',
	isa       => Items,
	traits    => ['Array'],
	handles   => {
		items_is_empty => 'is_empty',
	}
);

sub _items {
	my $self = shift;

	my $i = { };

	if ( $self->has_items and not $self->items_is_empty ) {
	}

	return $i;
}

1;

# ABSTRACT: Role that provides Items
