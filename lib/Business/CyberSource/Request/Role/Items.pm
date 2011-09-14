package Business::CyberSource::Request::Role::Items;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::Types::CyberSource qw( Item Items );

has items => (
	required => 0,
	is       => 'ro',
	isa      => Items,
	traits   => ['Array'],
);

1;

# ABSTRACT: Role that provides Items
