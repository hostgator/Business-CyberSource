package Business::CyberSource::Role::ForeignCurrency;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Locale::Currency qw( CurrencyCode );

has foreign_currency => (
	required  => 1,
	predicate => 'has_foreign_currency',
	is        => 'ro',
	isa       => CurrencyCode,
	documentation => 'Billing currency returned by the DCC service. '
		. 'For the possible values, see the ISO currency codes',
);

1;

# ABSTRACT: Role to apply to requests and responses that require currency
