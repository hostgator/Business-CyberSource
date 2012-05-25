package Business::CyberSource::Role::Currency;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteName;
use MooseX::Types::Locale::Currency qw( CurrencyCode );

has currency => (
	isa         => CurrencyCode,
	remote_name => 'currency',
	is          => 'ro',
	required    => 1,
);

1;

# ABSTRACT: Role to apply to requests and responses that require currency
