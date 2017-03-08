package Business::CyberSource::RequestPart::Item;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with    'MooseX::RemoteHelper::CompositeSerialization';

use MooseX::Types::Common::Numeric qw( PositiveOrZeroNum PositiveOrZeroInt );
use MooseX::Types::Common::String  qw( NonEmptySimpleStr );

has quantity => (
	isa         => PositiveOrZeroInt,
	remote_name => 'quantity',
	is          => 'ro',
	lazy        => 1,
	default     => sub { 1 },
);

has unit_price => (
	isa         => PositiveOrZeroNum,
	remote_name => 'unitPrice',
	is          => 'ro',
	required    => 1,
);

has product_code => (
	isa         => NonEmptySimpleStr,
	remote_name => 'productCode',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has product_name => (
	isa         => NonEmptySimpleStr,
	remote_name => 'productName',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has product_sku => (
	isa         => NonEmptySimpleStr,
	remote_name => 'productSKU',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has product_risk => (
	isa         => NonEmptySimpleStr,
	remote_name => 'productRisk',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has tax_amount => (
	isa         => PositiveOrZeroNum,
	remote_name => 'taxAmount',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has tax_rate => (
	isa         => PositiveOrZeroNum,
	remote_name => 'taxRate',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has national_tax => (
	isa         => PositiveOrZeroNum,
	remote_name => 'nationalTax',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has invoice_number => (
    isa => NonEmptySimpleStr,
    remote_name => 'invoiceNumber',
    is => 'ro',
    required => 0,
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Item Helper Class

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=attr unit_price

Per-item price of the product. You must include either this field or
L<total|Business::CyberSource::RequestPart::PurchaseTotals/"total">
in your request.

=attr quantity

The default is 1. For C<ccAuthService> and C<ccCaptureService>, this field is
required if L<product_code|/"product_code> is not default or one of the values related to
shipping and/or handling.

=attr product_code

Type of product. This value is used to determine the category that the product
is in.

=attr product_name

For C<ccAuthService> and C<ccCaptureService>, this field is required if
L<product_code|/product_code> is not default or one of the values related to shipping
and/or handling.

=attr product_sku

Identification code for the product. For C<ccAuthService> and
C<ccCaptureService>, this field is required if L<product_code|/product_code>
is not default or one of the values related to shipping and/or handling.

=attr product_risk

=attr tax_amount

Total tax to apply to the product. This value cannot be negative. The tax
amount and the offer amount must be in the same currency.
The tax amount field is additive. For example (in CyberSource notation):

You include the following offer lines in your request:

	item_0_unitPrice=10.00
	item_0_quantity=1
	item_0_taxAmount=0.80
	item_1_unitPrice=20.00
	item_1_quantity=1
	item_1_taxAmount=1.60

The total amount authorized will be 32.40, not 30.00 with 2.40 of tax included.

=attr tax_rate

=attr national_tax

=attr invoice_number

=cut
