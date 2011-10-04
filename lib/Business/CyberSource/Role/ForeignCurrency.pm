package Business::CyberSource::Role::ForeignCurrency;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Moose            qw( Str );
use MooseX::Types::Locale::Currency qw( CurrencyCode );
use MooseX::Types::Common::Numeric  qw( PositiveOrZeroNum );

has foreign_currency => (
	required  => 0,
	predicate => 'has_foreign_currency',
	is        => 'ro',
	isa       => CurrencyCode,
	documentation => 'Billing currency returned by the DCC service. '
		. 'For the possible values, see the ISO currency codes',
);

has foreign_amount => (
	predicate => 'has_foreign_amount',
	required => 0,
	is       => 'ro',
	isa      => PositiveOrZeroNum,
);

has exchange_rate => (
	predicate => 'has_exchange_rate',
	required => 0,
	is       => 'ro',
	isa      => PositiveOrZeroNum,
);

has exchange_rate_timestamp => (
	predicate => 'has_exchange_rate_timestamp',
	required => 0,
	is       => 'ro',
	isa      => Str,
);

1;

# ABSTRACT: Role to apply to requests and responses that require currency
