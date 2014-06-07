package Business::CyberSource::Exception::AttributeIsRequiredNotToBeSet;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Moose::Exception::AttributeIsRequired';

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: do not set this attribute under the condition
