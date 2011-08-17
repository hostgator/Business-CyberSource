package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}
use Moose::Role;

has currency => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has total => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

has foreign_currency => (
	is  => 'ro',
	isa => 'Num',
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
			name   => 'grandTotalAmount',
			value  => $self->total,
			parent => $purchase_totals,
		);
	}

	return $sb;
}

1;

# ABSTRACT: CyberSource Purchase Information Role
