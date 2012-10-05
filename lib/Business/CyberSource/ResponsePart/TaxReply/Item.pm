package Business::CyberSource::ResponsePart::TaxReply::Item;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';

has id => (
	isa         => 'Int',
	remote_name => 'id',
	is          => 'ro',
);

has city_tax_amount => (
	isa         => 'Num',
	remote_name => 'cityTaxAmount',
	is          => 'ro',
);

has county_tax_amount => (
	isa         => 'Num',
	remote_name => 'countyTaxAmount',
	is          => 'ro',
);

has district_tax_amount => (
	isa         => 'Num',
	remote_name => 'districtTaxAmount',
	is          => 'ro',
);

has state_tax_amount => (
	isa         => 'Num',
	remote_name => 'stateTaxAmount',
	is          => 'ro',
);

has total_tax_amount => (
	isa         => 'Num',
	remote_name => 'totalTaxAmount',
	is          => 'ro',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: taxReply_item
