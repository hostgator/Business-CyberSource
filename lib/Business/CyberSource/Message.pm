package Business::CyberSource::Message;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
with 'MooseX::Traits';

use MooseX::StrictConstructor;
use MooseX::ABC;

use MooseX::SetOnce 0.200001;

has trace => (
	isa       => 'XML::Compile::SOAP::Trace',
	predicate => 'has_trace',
	is        => 'rw',
	traits    => [ 'SetOnce' ],
	init_arg  => undef,
	writer    => '_trace',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Message Class;
