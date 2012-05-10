package Business::CyberSource::Request::Role::Items;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::Types::CyberSource qw( Item );
use MooseX::Types::Moose       qw( ArrayRef );

has items => (
	isa       => ArrayRef[Item],
	predicate => 'has_items',
	is        => 'rw',
	traits    => ['Array'],
	handles   => {
		items_is_empty => 'is_empty',
	},
	trigger   => sub {
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
				$h->{productCode}
					= $item->{product_code} if $item->{product_code}
					;

				$h->{productName}
					= $item->{product_name} if $item->{product_name}
					;

				$h->{productSKU}
					= $item->{product_sku} if $item->{product_sku}
					;

				$h->{productRisk}
					= $item->{product_risk} if $item->{product_risk}
					;

				$h->{taxAmount}
					= $item->{tax_amount} if $item->{tax_amount}
					;

				$h->{taxRate}
					= $item->{tax_rate} if $item->{tax_rate}
					;
				$h->{nationalTax}
					= $item->{national_tax} if $item->{national_tax}
					;

				push @{ $items }, $h;
				$i++;
			}
		}
		$self->_request_data->{item} = $items;
	},
);

1;

# ABSTRACT: Role that provides Items

=attr items

an array of L<Items|MooseX::Types::CyberSource/"Items">

=cut
