package Business::CyberSource::Request::Role::Billing;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}
use Moose::Role;
use MooseX::Types::Email qw( EmailAddress );

has first_name => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has last_name => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has street => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has city => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has state => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has country => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has zip => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has email => (
	required => 1,
	is       => 'ro',
	isa      => EmailAddress,
);

has ip => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: Role for requests that require "bill to" information
