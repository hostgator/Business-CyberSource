package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
);

use MooseX::Types::Moose   qw( Num     );
use MooseX::Types::Varchar qw( Varchar );
use MooseX::Types::Locale::Currency qw( CurrencyCode );

sub _purchase_info {
	my $self = shift;

	my $i = {
		currency         => $self->currency,
		grandTotalAmount => $self->total,
	};

	if ( $self->foreign_currency ) {
		$i->{foreignCurrency} = $self->foreign_currency;
	}

	return $i;
}

has total => (
	is       => 'ro',
	isa      => Num,
	documentation => 'Grand total for the order. You must include '
		. 'either this field or item_#_unitPrice in your request',
);

has foreign_currency => (
	is  => 'ro',
	isa => CurrencyCode,
	documentation => 'Billing currency returned by the DCC service. '
		. 'For the possible values, see the ISO currency codes',

);

1;

# ABSTRACT: CyberSource Purchase Information Role
