package Business::CyberSource::RequestPart::Service;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';

use MooseX::Types::CyberSource qw( RequestID );

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
	isa         => RequestID,
	remote_name => 'authRequestID',
	predicate   => 'has_auth_request_id',
	is          => 'rw',
	traits      => ['SetOnce'],
);

has capture_request_id => (
	isa         => RequestID,
	remote_name => 'captureRequestID',
	predicate   => 'has_capture_request_id',
	is          => 'rw',
	traits      => ['SetOnce'],
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Service Request Part

=head1 DESCRIPTION

Service provides support for the portion of requests that are named as
C<cc*Service> this tells cybersource which type of request to make. All of the
L<Business::CyberSource::Request> based classes will add this correctly.
Depending on the request type you may have to set either
L<capture_request_id|/"capture_request_id"> or
L<auth_request_id|/"auth_request_id">

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=attr run

run will be set correctly by default on ever request

=attr auth_request_id

=over

=item L<AuthReversal|Business::CyberSource::Request::AuthReversal>

The L<request_id|Business::CyberSource::Response/"request_id"> for the authorization that you want to reverse.

=item L<Capture|Business::CyberSource::Request::Capture>

Value of L<request_id|Business::CyberSource::Response/"request_id"> returned from
a previous L<Auth Reply|Business::CyberSource::Request::Authorization>.

=back

=attr capture_request_id

=over

=item L<AuthReversal|Business::CyberSource::Request::AuthReversal>

The L<request_id|Business::CyberSource::Response/"request_id"> returned from a
previous request for capture. Creates a follow-on credit by linking the credit
to the previous capture. If you send this field, you do not need to send
several other credit request fields.

=back

=cut
