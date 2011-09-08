package Business::CyberSource::Response::Role::Credit;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Moose qw( Int );

has reconciliation_id => (
	required => 1,
	is       => 'ro',
	isa      => Int, # Int[6]
);

1;

# ABSTRACT: CyberSource Credit Response object
