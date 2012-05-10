package Business::CyberSource::Response::Role::AVS;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;

use MooseX::SetOnce 0.200001;

use MooseX::Types::CyberSource qw( AVSResult _VarcharTen );

has avs_code => (
	isa       => AVSResult,
	predicate => 'has_avs_code',
	traits    => ['SetOnce'],
	is        => 'rw',
);

has avs_code_raw => (
	isa       => _VarcharTen,
	predicate => 'has_avs_code_raw',
	traits    => ['SetOnce'],
	is        => 'rw',
);

1;

# ABSTRACT: AVS Role

=attr avs_code

AVS results

=attr avs_code_raw

AVS result code sent directly from the processor. Returned only if a value is
returned by the processor.

=cut
