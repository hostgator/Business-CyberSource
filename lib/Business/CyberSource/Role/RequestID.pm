package Business::CyberSource::Role::RequestID;
use 5.008;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::Types::Common::String qw( NonEmptySimpleStr );
use Moose::Util::TypeConstraints;

has request_id => (
	required  => 1,
	predicate => 'has_request_id',
	is        => 'ro',
	isa       => subtype( NonEmptySimpleStr, where { length $_ <= 29 }),
);

1;

# ABSTRACT: Role to apply to requests and responses that require request id's
