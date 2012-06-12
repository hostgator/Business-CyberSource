package Business::CyberSource::Factory::Rule;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use MooseX::AbstractFactory;

implementation_class_via sub { 'Business::CyberSource::Rule::' . shift};

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: CyberSource Rule Factory Module
