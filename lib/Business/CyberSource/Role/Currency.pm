package Business::CyberSource::Role::Currency;
use 5.008;
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
);

1;

# ABSTRACT: Role to apply to requests and responses that require currency
