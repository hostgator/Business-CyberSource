package Business::CyberSource::ResponsePart::PurchaseTotals;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::ForeignCurrency
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: PurchaseTotals part of response

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=head1 WITH

=over

=item L<Business::CyberSource::Role::Currency>

=item L<Business::CyberSource::Role::ForeignCurrency>

=back

=attr currency

=attr foreign_currency

Billing currency returned by the DCC service. For the possible values, see the ISO currency codes

=attr foreign_amount

=attr exchange_rate

=attr exchange_rate_timestamp

=cut
