package Business::CyberSource::Response::Role::CVN;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::Types::Varchar qw( Varchar );

has cv_code => (
	required  => 0,
	predicate => 'has_cv_code',
	is        => 'ro',
	isa       => Varchar[1],
);

has cv_code_raw => (
	required  => 0,
	predicate => 'has_cv_code_raw',
	is        => 'ro',
	isa       => Varchar[10],
);

1;

# ABSTRACT: CVN Role
