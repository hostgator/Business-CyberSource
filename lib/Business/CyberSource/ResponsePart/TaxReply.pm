package Business::CyberSource::ResponsePart::TaxReply;
use strict;
use warnings;
use namespace::autoclean;
use Class::Load 0.20 qw( load_class );

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Response::Role::ReasonCode
);
use MooseX::Types::CyberSource qw( TaxReplyItems );

has items => (
	isa         => TaxReplyItems,
	remote_name => 'item',
	is          => 'bare',
	coerce      => 1,
);

has city => (
	isa         => 'Str',
	remote_name => 'city',
	is          => 'ro',
);

has total => (
	isa         => 'Num',
	remote_name => 'grandTotalAmount',
	is          => 'ro',
);

has postal_code => (
	isa         => 'Str',
	remote_name => 'postalCode',
	is          => 'ro',
);

has state => (
	isa         => 'Str',
	remote_name => 'state',
	is          => 'ro',
);

has total_city_tax_amount => (
	isa         => 'Num',
	remote_name => 'totalCityTaxAmount',
	is          => 'ro',
);

has total_county_tax_amount => (
	isa         => 'Num',
	remote_name => 'totalCountyTaxAmount',
	is          => 'ro',
);

has total_district_tax_amount => (
	isa         => 'Num',
	remote_name => 'totalDistrictTaxAmount',
	is          => 'ro',
);

has total_state_tax_amount => (
	isa         => 'Num',
	remote_name => 'totalStateTaxAmount',
	is          => 'ro',
);

has total_tax_amount => (
	isa         => 'Num',
	remote_name => 'totalTaxAmount',
	is          => 'ro',
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Reply section for Tax Service

=attr items

=attr city

=attr total

=attr postal_code

=attr state

=attr total_city_tax_amount

=attr total_county_tax_amount

=attr total_district_tax_amount

=attr total_state_tax_amount

=attr total_tax_amount
