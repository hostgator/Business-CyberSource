package Business::CyberSource::Request::Role::PurchaseInfo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

has purchase_totals => (
	isa         => 'Business::CyberSource::Helper::PurchaseTotals',
	remote_name => 'purchaseTotals',
	is          => 'ro',
	required    => 1,
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
