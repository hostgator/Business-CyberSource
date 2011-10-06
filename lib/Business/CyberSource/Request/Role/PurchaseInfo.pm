package Business::CyberSource::Request::Role::PurchaseInfo;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.4.0'; # VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::ForeignCurrency
	Business::CyberSource::Request::Role::Items
);

use MooseX::Types::Moose            qw( HashRef           );
use MooseX::Types::Common::Numeric  qw( PositiveOrZeroNum );
use MooseX::Types::Varchar          qw( Varchar           );
use MooseX::Types::Locale::Currency qw( CurrencyCode      );

has total => (
	required  => 0,
	predicate => 'has_total',
	is        => 'ro',
	isa       => PositiveOrZeroNum,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{purchaseTotals}{grandTotalAmount} = $self->total;
	},
	documentation => 'Grand total for the order. You must include '
		. 'either this field or item_#_unitPrice in your request',
);

1;

# ABSTRACT: CyberSource Purchase Information Role

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::PurchaseInfo - CyberSource Purchase Information Role

=head1 VERSION

version v0.4.0

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

