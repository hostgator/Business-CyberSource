package Business::CyberSource::Rule;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use MooseX::StrictConstructor;
use MooseX::ABC 0.06;

requires 'run';

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Rule Base
