package Business::CyberSource::RequestPart::PurchaseTotals;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with    'MooseX::RemoteHelper::CompositeSerialization';

with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::ForeignCurrency
);

use MooseX::Types::Common::Numeric qw( PositiveOrZeroNum );

has total => (
	isa         => PositiveOrZeroNum,
	remote_name => 'grandTotalAmount',
	traits      => [ 'SetOnce' ],
	is          => 'rw',
	predicate   => 'has_total',

);

has discount => (
    isa         => PositiveOrZeroNum,
    remote_name => 'discountAmount',
    traits      => ['SetOnce'],
    is          => 'rw',
    predicate   => 'has_discount',

);

has duty => (
    isa         => PositiveOrZeroNum,
    remote_name => 'dutyAmount',
    traits      => ['SetOnce'],
    is          => 'rw',
    predicate   => 'has_duty',

);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Purchase Totals

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=head1 WITH

=over

=item L<Business::CyberSource::Role::Currency>

=item L<Business::CyberSource::Role::ForeignCurrency>

=back

=attr total

Grand total for the order. You must include either this field or
L<Item unit price|Business::CyberSource::RequestPart::Item/"unit_price"> in your
request.

=attr discount

Total discount applied to the order. This is level II or level III data related
information depending on the payment processor. For more information see
http://apps.cybersource.com/library/documentation/dev_guides/Level_2_3_SO_API/Level_II_III_SO_API.pdf

=attr duty

Total charges for any import or export duties included in the order. This is
level II or level III data related information depending on the payment
processor.  For more information see
http://apps.cybersource.com/library/documentation/dev_guides/Level_2_3_SO_API/Level_II_III_SO_API.pdf

=cut
