package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;

our $VERSION = 'v0.1.10'; # VERSION

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

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::PurchaseInfo - CyberSource Purchase Information Role

=head1 VERSION

version v0.1.10

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

