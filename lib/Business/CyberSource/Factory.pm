package Business::CyberSource::Factory;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use MooseX::StrictConstructor;
use MooseX::ABC 0.06;

requires 'create';

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Factory Base Class
