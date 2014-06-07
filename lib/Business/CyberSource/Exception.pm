package Business::CyberSource::Exception;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Moose::Exception';

has value => (
	isa     => 'Int',
	is      => 'ro',
	lazy    => 1,
	default => 0,
);

before value => sub {
		warnings::warnif('deprecated',
			'method `value` is deprecated as Exception::Base is no longer in use'
		);
};

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: base exception
