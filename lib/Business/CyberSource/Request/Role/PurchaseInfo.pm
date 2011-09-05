package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.2.3'; # VERSION

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
);

has foreign_currency => (
	is  => 'ro',
	isa => CurrencyCode,
);

1;

# ABSTRACT: CyberSource Purchase Information Role

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::PurchaseInfo - CyberSource Purchase Information Role

=head1 VERSION

version v0.2.3

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

