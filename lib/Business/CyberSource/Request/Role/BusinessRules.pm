package Business::CyberSource::Request::Role::BusinessRules;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::SetOnce 0.200001;

has business_rules => (
	isa         => 'Business::CyberSource::Helper::BusinessRules',
	remote_name => 'businessRules',
	traits      => ['SetOnce'],
	is          => 'rw',
);

1;

