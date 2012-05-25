package Business::CyberSource::Role::ForeignCurrency;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteName;

use MooseX::SetOnce 0.200001;

use MooseX::Types::Moose            qw( Str );
use MooseX::Types::Locale::Currency qw( CurrencyCode );
use MooseX::Types::Common::Numeric  qw( PositiveOrZeroNum );

has foreign_currency => (
	isa         => CurrencyCode,
	remote_name => 'foriegnCurrency',
	predicate   => 'has_foreign_currency',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has foreign_amount => (
	isa         => PositiveOrZeroNum,
	remote_name => 'foreignAmount',
	predicate   => 'has_foreign_amount',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has exchange_rate => (
	isa         => PositiveOrZeroNum,
	remote_name => 'exchangeRate',
	predicate   => 'has_exchange_rate',
	traits      => ['SetOnce'],
	is          => 'rw',
);

has exchange_rate_timestamp => (
	isa       => Str,
	remote_name => 'exchangeRateTimeStamp',
	predicate => 'has_exchange_rate_timestamp',
	traits    => ['SetOnce'],
	is        => 'rw',
);

1;

# ABSTRACT: Role to apply to requests and responses that require currency

=attr foreign_currency

Billing currency returned by the DCC service. For the possible values, see the ISO currency codes

=cut
