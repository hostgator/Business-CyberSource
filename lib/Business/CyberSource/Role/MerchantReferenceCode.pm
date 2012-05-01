package Business::CyberSource::Role::MerchantReferenceCode;
use 5.008;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::CyberSource qw( _VarcharFifty );

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => _VarcharFifty,
);

1;

# ABSTRACT: Generic implementation of MerchantReferenceCode
