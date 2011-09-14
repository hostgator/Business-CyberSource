package Business::CyberSource::Request::Role::Items;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::Types::CyberSource qw( Item );
use MooseX::Types::Moose       qw( ArrayRef );

has items => (
	required  => 0,
	predicate => 'has_items',
	is        => 'ro',
	isa       => ArrayRef[Item],
	traits    => ['Array'],
	handles   => {
		items_is_empty => 'is_empty',
	}
);

sub _item_info {
	my $self = shift;

	my $items = [ ];
	if ( $self->has_items and not $self->items_is_empty ) {
		my $i = 0;
		foreach my $item ( @{ $self->items } ) {
			my $h = {
				id        => $i,
				quantity  => $item->{quantity},
				unitPrice => $item->{unit_price},
			};
			push @{ $items }, $h;
			$i++;
		}
	}

	return $items;
}

1;

# ABSTRACT: Role that provides Items
