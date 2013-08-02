package Business::CyberSource::MessagePart;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'MooseY::RemoteHelper::MessagePart';
use MooseX::SetOnce 0.200001;

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Things that all portions of a message have in common
