package Business::CyberSource::Response::Role::AVS;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::Types::CyberSource qw( AVSResult _VarcharTen );

has avs_code => (
	required => 0,
	predicate => 'has_avs_code',
	is       => 'ro',
	isa      => AVSResult,
);

has avs_code_raw => (
	required  => 0,
	predicate => 'has_avs_code_raw',
	is        => 'ro',
	isa       => _VarcharTen,
);

1;

# ABSTRACT: AVS Role

=attr avs_code

AVS results

=attr avs_code_raw

AVS result code sent directly from the processor. Returned only if a value is
returned by the processor.

=cut
