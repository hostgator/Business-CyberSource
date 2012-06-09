package Business::CyberSource::RequestPart::Item;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';

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

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Item Helper Class
