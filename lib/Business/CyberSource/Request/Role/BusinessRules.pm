package Business::CyberSource::Request::Role::BusinessRules;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( BusinessRules );

has business_rules => (
	isa         => BusinessRules,
	remote_name => 'businessRules',
	traits      => ['SetOnce'],
	is          => 'rw',
	coerce      => 1,
);

1;

# ABSTRACT: Business Rules

=attr business_rules

L<Business::CyberSource::RequestPart::BusinessRules>

=cut
