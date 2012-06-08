package Business::CyberSource::Request::Role::BusinessRules;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;

has business_rules => (
	isa         => 'Business::CyberSource::RequestPart::BusinessRules',
	remote_name => 'businessRules',
	traits      => ['SetOnce'],
	is          => 'rw',
);

1;

# ABSTRACT: Business Rules

=attr business_rules

L<Business::CyberSource::RequestPart::BusinessRules>

=cut
