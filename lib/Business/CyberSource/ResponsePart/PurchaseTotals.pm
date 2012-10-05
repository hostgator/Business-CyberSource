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
