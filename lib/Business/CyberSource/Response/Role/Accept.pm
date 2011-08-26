package Business::CyberSource::Response::Role::Accept;
use 5.008;
use strict;
use warnings;

# VERSION

use Moose::Role;
use namespace::autoclean;
use MooseX::Types::Moose         qw( Num Str     );
use MooseX::Types::DateTime::W3C qw( DateTimeW3C );

has amount => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

has currency => (
	required => 1,
	is       => 'ro',
	isa      => Str,
);

has datetime => (
	required => 1,
	is       => 'ro',
	isa      => DateTimeW3C,
);

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => Str,
);

1;

# ABSTRACT: role for handling accepted transactions
