package Business::CyberSource::RequestPart::Service;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with    'MooseX::RemoteHelper::CompositeSerialization';

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

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Service Request Part

=head1 DESCRIPTION

Service provides support for the portion of requests that are named as
C<cc*Service> this tells CyberSource which type of request to make. All of the
L<Business::CyberSource::Request> based classes will add this correctly.
Depending on the request type you may have to set either
L<capture_request_id|/"capture_request_id"> or
L<auth_request_id|/"auth_request_id">

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=attr run

run will be set correctly by default on ever request

=cut
