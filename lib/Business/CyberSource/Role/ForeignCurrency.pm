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
	trigger => sub {
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
	predicate => 'has_foreign_amount',
	required => 0,
	is       => 'ro',
	isa      => PositiveOrZeroNum,
	trigger => sub {
		my $self = shift;
		if ( $self->meta->find_attribute_by_name( '_request_data' ) ) {
			$self->_request_data->{purchaseTotals}{foreignAmount}
				= $self->foreign_amount
				;
		}
	},
);

has exchange_rate => (
	predicate => 'has_exchange_rate',
	required => 0,
	is       => 'ro',
	isa      => PositiveOrZeroNum,
	trigger => sub {
		my $self = shift;
		if ( $self->meta->find_attribute_by_name( '_request_data' ) ) {
			$self->_request_data->{purchaseTotals}{exchangeRate}
				= $self->exchange_rate
				;
		}
	},
);

has exchange_rate_timestamp => (
	predicate => 'has_exchange_rate_timestamp',
	required => 0,
	is       => 'ro',
	isa      => Str,
	trigger => sub {
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
