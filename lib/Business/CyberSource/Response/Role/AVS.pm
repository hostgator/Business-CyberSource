package Business::CyberSource::Response::Role::AVS;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::Types::Varchar qw( Varchar );

has avs_code => (
	required => 0,
	predicate => 'has_avs_code',
	is       => 'ro',
	isa      => Varchar[1],
	documentation => 'AVS results.',
);

has avs_code_raw => (
	required  => 0,
	predicate => 'has_avs_code_raw',
	is        => 'ro',
	isa       => Varchar[10],
	documentation => 'AVS result code sent directly from the processor. '
		. 'Returned only if a value is returned by the processor.',
);

1;

# ABSTRACT: AVS Role