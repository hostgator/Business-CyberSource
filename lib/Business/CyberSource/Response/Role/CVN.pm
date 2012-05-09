package Business::CyberSource::Response::Role::CVN;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::Types::CyberSource qw( CvResults _VarcharTen );

has cv_code => (
	required  => 0,
	predicate => 'has_cv_code',
	is        => 'ro',
	isa       => CvResults,
);

has cv_code_raw => (
	required  => 0,
	predicate => 'has_cv_code_raw',
	is        => 'ro',
	isa       => _VarcharTen,
);

1;

# ABSTRACT: CVN Role

=attr cv_code

=attr cv_Code_raw
