package Business::CyberSource::Response::Role::AuthCode;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( _VarcharSeven );

has auth_code => (
	isa         => _VarcharSeven,
	remote_name => 'authorizationCode',
	predicate   => 'has_auth_code',
	is          => 'ro',
);

1;
# ABSTRACT: Authorization Code
