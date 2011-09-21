package Business::CyberSource::Response::Role::DCC;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::ForeignCurrency
	Business::CyberSource::Response::Role::Accept
);

use MooseX::Types::Moose qw( Num Bool Str Int );

has foreign_amount => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

has dcc_supported => (
	required => 1,
	is       => 'ro',
	isa      => Bool
);

has exchange_rate => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

has exchange_rate_timestamp => (
	required => 1,
	is       => 'ro',
	isa      => Str,
);

has valid_hours => (
	required => 1,
	is       => 'ro',
	isa      => Int,
);

has margin_rate_percentage => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

1;

# ABSTRACT: Role that provides attributes specific to responses for DCC
