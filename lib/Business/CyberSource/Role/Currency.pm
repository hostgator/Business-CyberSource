package Business::CyberSource::Role::Currency;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Locale::Currency qw( CurrencyCode );

has currency => (
	required => 1,
	is       => 'ro',
	isa      => CurrencyCode,
	trigger => sub {
		my $self = shift;
		if ( $self->meta->find_attribute_by_name( '_request_data' ) ) {
			$self->_request_data->{purchaseTotals}{currency} = $self->currency;
		}
	},
);

1;

# ABSTRACT: Role to apply to requests and responses that require currency
