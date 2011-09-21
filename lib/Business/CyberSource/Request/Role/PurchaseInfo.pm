package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Request::Role::Items
);

use MooseX::Types::Common::Numeric  qw( PositiveOrZeroNum );
use MooseX::Types::Varchar          qw( Varchar           );
use MooseX::Types::Locale::Currency qw( CurrencyCode      );

sub _purchase_info {
	my $self = shift;

	my $i = {
		currency => $self->currency,
	};

	$i->{grandTotalAmount} = $self->total if $self->has_total;;
	$i->{foreignCurrency}  = $self->foreign_currency
		if $self->has_foreign_currency;

	return $i;
}

has total => (
	required  => 0,
	predicate => 'has_total',
	is        => 'ro',
	isa       => PositiveOrZeroNum,
	documentation => 'Grand total for the order. You must include '
		. 'either this field or item_#_unitPrice in your request',
);

1;

# ABSTRACT: CyberSource Purchase Information Role
