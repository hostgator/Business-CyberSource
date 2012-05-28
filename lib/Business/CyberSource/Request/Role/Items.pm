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

	load_class 'Business::CyberSource::Helper::Item';
	$self->push_item(
			Business::CyberSource::Helper::Item->new( $args )
		);
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
		push_item       => 'push',
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

=attr items

an array of L<Items|MooseX::Types::CyberSource/"Items">

=cut
