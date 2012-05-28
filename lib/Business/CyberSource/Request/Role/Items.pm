package Business::CyberSource::Request::Role::Items;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;

use MooseX::Types::CyberSource qw( Item );
use MooseX::Types::Moose       qw( ArrayRef );

use Class::Load qw( load_class );

sub add_item {
	my ( $self, $args ) = @_;

	my $item;
	unless ( blessed $args
			&& $args->isa( 'Business::CyberSource::Helper::Item' )
		) {
		load_class 'Business::CyberSource::Helper::Item';
		$item = Business::CyberSource::Helper::Item->new( $args )
	}
	else {
		$item = $args;
	}

	return $self->_push_item( $item );
}

has items => (
	isa         => ArrayRef[Item],
	remote_name => 'item',
	predicate   => 'has_items',
	is          => 'rw',
	traits      => ['Array'],
	handles     => {
		items_is_empty => 'is_empty',
		next_item      => [ natatime => 1 ],
		list_items     => 'elements',
		_push_item       => 'push',
	},
	serializer => sub {
		my ( $attr, $instance ) = @_;

		my $items = $attr->get_value( $instance );

		my $i = 0;
		my @serialized
			= map {
				my $item = $_->serialize;
				$item->{id} = $i;
				$i++;
				$item
			} @{ $items };

		return \@serialized;
	},
);


1;

# ABSTRACT: Role that provides Items

=method add_item

Add an L<Item|Business::CyberSource::Helper::Item> to L<items|/"items">.
Accepts an item object or a hashref to construct an item object.

=attr items

an array of L<Items|MooseX::Types::CyberSource/"Items">

=cut
