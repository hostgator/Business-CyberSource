package Business::CyberSource::Response::Role::ProcessorResponse;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::CyberSource qw( _VarcharTen );

has processor_response => (
	required  => 0,
	predicate => 'has_processor_response',
	is        => 'ro',
	isa       => _VarcharTen,
);

1;

# ABSTRACT: Processor Response attribute
