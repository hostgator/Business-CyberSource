package Business::CyberSource::Response::Role::CVN;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::SetOnce 0.200001;

use MooseX::Types::CyberSource qw( CvResults _VarcharTen );

has cv_code => (
	isa       => CvResults,
	predicate => 'has_cv_code',
	traits    => ['SetOnce'],
	is        => 'rw',
);

has cv_code_raw => (
	isa       => _VarcharTen,
	predicate => 'has_cv_code_raw',
	traits    => ['SetOnce'],
	is        => 'rw',
);

1;

# ABSTRACT: CVN Role

=attr cv_code

=attr cv_Code_raw
