package Business::CyberSource::Exception;
use strict;
use warnings;

# VERSION

use Moose;
extends 'Moose::Exception';

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: base exception
