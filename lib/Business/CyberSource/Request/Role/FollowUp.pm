package Business::CyberSource::Request::Role::FollowUp;
use 5.008;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

# VERSION

use Moose::Role;

has request_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: Role to apply to requests that are follow ups to a previous request
