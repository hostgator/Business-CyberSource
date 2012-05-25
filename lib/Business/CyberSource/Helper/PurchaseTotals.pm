package Business::CyberSource::Helper::PurchaseTotals;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
with 'MooseX::RemoteHelper::CompositeSerialization';


use MooseX::SetOnce 0.200001;
use MooseX::RemoteHelper;

use MooseX::Types::Common::Numeric qw( PositiveOrZeroNum );

with qw(
	Business::CyberSource::Role::Currency
	Business::CyberSource::Role::ForeignCurrency
);

has total => (
	isa         => PositiveOrZeroNum,
	remote_name => 'grandTotalAmount',
	traits      => [ 'SetOnce' ],
	is          => 'rw',
	predicate   => 'has_total',

);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Purchase Totals
