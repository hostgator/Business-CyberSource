package Business::CyberSource::Request::Role::PurchaseInfo;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005000'; # VERSION

use Moose::Role;

with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::ForeignCurrency
	Business::CyberSource::Request::Role::Items
);

use MooseX::SetOnce 0.200001;

use MooseX::Types::Moose            qw( HashRef           );
use MooseX::Types::Common::Numeric  qw( PositiveOrZeroNum );
use MooseX::Types::Locale::Currency qw( CurrencyCode      );

has total => (
	isa       => PositiveOrZeroNum,
	traits    => [ 'SetOnce' ],
	is        => 'rw',
	predicate => 'has_total',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{purchaseTotals}{grandTotalAmount} = $self->total;
	},
);

1;

# ABSTRACT: CyberSource Purchase Information Role


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::PurchaseInfo - CyberSource Purchase Information Role

=head1 VERSION

version 0.005000

=head1 DESCRIPTION

=head2 composes

=over

=item L<Business::CyberSource::Role::Currency>

=item L<Business::CyberSource::Role::ForeignCurrency>

=item L<Business::CyberSource::Request::Role::Items>

=back

=head1 ATTRIBUTES

=head2 total

Grand total for the order. You must include either this field or item unit
price in your request.

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

