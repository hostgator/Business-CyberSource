package Business::CyberSource::Role::ForeignCurrency;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::SetOnce 0.200001;

use MooseX::Types::Moose            qw( Str );
use MooseX::Types::Locale::Currency qw( CurrencyCode );
use MooseX::Types::Common::Numeric  qw( PositiveOrZeroNum );

has foreign_currency => (
	isa       => CurrencyCode,
	predicate => 'has_foreign_currency',
	traits    => ['SetOnce'],
	is        => 'rw',
	trigger   => sub {
		my $self = shift;
		if ( $self->meta->find_attribute_by_name( '_request_data' ) ) {
			$self->_request_data->{purchaseTotals}{foreignCurrency}
				= $self->foreign_currency
				;
		}
	},
	documentation => 'Billing currency returned by the DCC service. '
		. 'For the possible values, see the ISO currency codes',
);

has foreign_amount => (
	isa       => PositiveOrZeroNum,
	predicate => 'has_foreign_amount',
	traits    => ['SetOnce'],
	is        => 'rw',
	trigger   => sub {
		my $self = shift;
		if ( $self->meta->find_attribute_by_name( '_request_data' ) ) {
			$self->_request_data->{purchaseTotals}{foreignAmount}
				= $self->foreign_amount
				;
		}
	},
);

has exchange_rate => (
	isa       => PositiveOrZeroNum,
	predicate => 'has_exchange_rate',
	traits    => ['SetOnce'],
	is        => 'rw',
	trigger   => sub {
		my $self = shift;
		if ( $self->meta->find_attribute_by_name( '_request_data' ) ) {
			$self->_request_data->{purchaseTotals}{exchangeRate}
				= $self->exchange_rate
				;
		}
	},
);

has exchange_rate_timestamp => (
	isa       => Str,
	predicate => 'has_exchange_rate_timestamp',
	traits    => ['SetOnce'],
	is        => 'rw',
	trigger   => sub {
		my $self = shift;
		if ( $self->meta->find_attribute_by_name( '_request_data' ) ) {
			$self->_request_data->{purchaseTotals}{exchangeRateTimeStamp}
				= $self->exchange_rate_timestamp
				;
		}
	},
);

1;

# ABSTRACT: Role to apply to requests and responses that require currency
