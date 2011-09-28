package Business::CyberSource::Request::Role::Items;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.3.7'; # VERSION

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

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::Items - Role that provides Items

=head1 VERSION

version v0.3.7

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

