package Business::CyberSource::Exception::ItemsOrTotal;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Exception';

sub _build_message {
	return 'you must define either items or total';
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: You must set Items or total
