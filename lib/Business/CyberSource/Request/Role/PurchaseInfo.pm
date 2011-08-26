package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;

# VERSION

use Moose::Role;
use namespace::autoclean;
use MooseX::Types::Moose   qw( Num     );
use MooseX::Types::Varchar qw( Varchar );

has currency => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[5],
);

has total => (
	is       => 'ro',
	isa      => Num,
);

has foreign_currency => (
	is  => 'ro',
	isa => Varchar[5],
);

sub _build_purchase_info {
	my ( $self, $sb ) = @_;

	my $purchase_totals = $sb->add_elem(
		name => 'purchaseTotals',
	);

	$sb->add_elem(
		name   => 'currency',
		parent => $purchase_totals,
		value  => $self->currency,
	);

	$sb->add_elem(
		name   => 'grandTotalAmount',
		value  => $self->total,
		parent => $purchase_totals,
	);

	if ( $self->foreign_currency ) {
		$sb->add_elem(
			name   => 'foreignCurrency',
			value  => $self->foreign_currency,
			parent => $purchase_totals,
		);
	}

	return $sb;
}

1;

# ABSTRACT: CyberSource Purchase Information Role
