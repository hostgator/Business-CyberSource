package Business::CyberSource::RequestPart::Service;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';

use MooseX::Aliases;
use MooseX::Types::CyberSource qw( AuthRequestID );

has run => (
	isa         => 'Bool',
	remote_name => 'run',
	is          => 'ro',
	lazy        => 1,
	init_arg    => undef,
	reader      => undef,
	writer      => undef,
	default     => sub { 1 },
	serializer  => sub {
		my ( $attr, $instance ) = @_;
		return $attr->get_value( $instance ) ? 'true' : 'false';
	},
);

has auth_request_id => (
	isa         => AuthRequestID,
	remote_name => 'authRequestID',
	alias       => 'request_id',
	is          => 'rw',
	traits      => ['SetOnce'],
);
	

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: service class
