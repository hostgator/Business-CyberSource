package Business::CyberSource::Response::Role::ProcessorResponse;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( _VarcharTen );

has processor_response => (
	isa         => _VarcharTen,
	remote_name => 'processorResponse',
	predicate   => 'has_processor_response',
	is          => 'ro',
);

1;

# ABSTRACT: Processor Response attribute

=attr processor_response

=cut
