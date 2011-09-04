package Business::CyberSource::Role::RequestID;
use 5.008;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Varchar qw( Varchar );

has request_id => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[29],
);

1;

# ABSTRACT: Role to apply to requests and responses that require request id's
