package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.2'; # VERSION
}
use Moose::Role;

has currency => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has total => (
	is       => 'ro',
	isa      => 'Num',
);

has foreign_currency => (
	is  => 'ro',
	isa => 'Str',
);

has item => (
	is  => 'ro',
	isa => 'Bool',
);

has unit_price => (
	is  => 'ro',
	isa => 'Num',
);

has quantity => (
	is  => 'ro',
	isa => 'Int',
);

sub _build_purchase_info {
	my ( $self, $sb ) = @_;

	if ( $self->item ) {

       my $item = $sb->add_elem(
               name => 'item',
               attributes => { 'id' => '0' },
       );

		$sb->add_elem(
			name => 'foo'	
#               name => 'unitPrice',
#               value => $self->unit_price,
#               parent => $item,
       );

#       $sb->add_elem(
#               name => 'quantity',
#               value => $self->quantity,
#               parent => $item,
#       );

	}

	my $purchase_totals = $sb->add_elem(
		name => 'purchaseTotals',
	);

	$sb->add_elem(
		name   => 'currency',
		parent => $purchase_totals,
		value  => $self->currency,
	);

	if ( $self->total ) {
		$sb->add_elem(
			name   => 'grandTotalAmount',
			value  => $self->total,
			parent => $purchase_totals,
		);
	}

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

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::PurchaseInfo - CyberSource Purchase Information Role

=head1 VERSION

version v0.1.2

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

