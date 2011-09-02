package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;

# VERSION

use Moose::Role;
use namespace::autoclean;
use MooseX::Types::Moose   qw( Num     );
use MooseX::Types::Varchar qw( Varchar );
use MooseX::Types::Locale::Currency qw( CurrencyCode );

sub _purchase_info {
	my $self = shift;

	my $i = {
		currency         => $self->currency,
		grandTotalAmount => $self->total,
	}

	if ( $self->foreign_currency ) {
		$i->{foreignCurrency} = $self->foreign_currency;
	}

	return $i;
}

has currency => (
	required => 1,
	is       => 'ro',
	isa      => CurrencyCode,
);

has total => (
	is       => 'ro',
	isa      => Num,
);

has foreign_currency => (
	is  => 'ro',
	isa => CurrencyCode,
);

1;

# ABSTRACT: CyberSource Purchase Information Role
