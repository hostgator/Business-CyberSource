package Business::CyberSource::Request::Role::PurchaseInfo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::ForeignCurrency
	Business::CyberSource::Request::Role::Items
);

use MooseX::Types::Moose            qw( HashRef           );
use MooseX::Types::Common::Numeric  qw( PositiveOrZeroNum );
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
);

1;

# ABSTRACT: CyberSource Purchase Information Role

=head1 DESCRIPTION

=head2 composes

=over

=item L<Business::CyberSource::Role::Currency>

=item L<Business::CyberSource::Role::ForeignCurrency>

=item L<Business::CyberSource::Request::Role::Items>

=back

=attr total

Grand total for the order. You must include either this field or item unit
price in your request.

=cut
