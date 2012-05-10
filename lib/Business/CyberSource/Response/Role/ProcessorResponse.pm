package Business::CyberSource::Response::Role::ProcessorResponse;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::SetOnce 0.200001;

use MooseX::Types::CyberSource qw( _VarcharTen );

has processor_response => (
	isa       => _VarcharTen,
	predicate => 'has_processor_response',
	traits    => ['SetOnce'],
	is        => 'rw',
);

1;

# ABSTRACT: Processor Response attribute

=attr processor_response

=cut
