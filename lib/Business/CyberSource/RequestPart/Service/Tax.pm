package Business::CyberSource::RequestPart::Service::Tax;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::RequestPart::Service';

has nexus => (
	isa        => 'ArrayRef[Str]',
	is         => 'ro',
	traits     => ['Array'],
	serializer => sub {
		my ( $attr, $instance ) = @_;
		return join ' ', @{ $attr->get_value( $instance ) };
	},
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Tax Service
