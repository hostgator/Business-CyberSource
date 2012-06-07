package Business::CyberSource::Role::RequestID;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;

use MooseX::Types::Common::String qw( NonEmptySimpleStr );
use Moose::Util::TypeConstraints;

has request_id => (
	isa         => subtype( NonEmptySimpleStr, where { length $_ <= 29 }),
	remote_name => 'requestId',
	predicate   => 'has_request_id',
	required    => 1,
	is          => 'ro',
);

1;

# ABSTRACT: Role to apply to requests and responses that require request id's
