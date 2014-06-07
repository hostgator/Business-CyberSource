package Business::CyberSource::Exception::UnableToDetectCardTypeCode;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Exception';

sub _build_message {
	my $self = shift;
	return 'card type code for "'
		. $self->type
		.  '" was unable to be detected please define it manually';
}

has type => (
	isa      => 'Str',
	is       => 'ro',
	required => 1,
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Card prefix did not match list of automatic supported types
