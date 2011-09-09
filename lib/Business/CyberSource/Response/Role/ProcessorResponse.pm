package Business::CyberSource::Response::Role::ProcessorResponse;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Varchar qw( Varchar );

has processor_response => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[10],
);

1;

# ABSTRACT: Processor Response attribute
