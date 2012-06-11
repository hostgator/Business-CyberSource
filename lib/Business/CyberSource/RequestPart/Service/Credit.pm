package Business::CyberSource::RequestPart::Service::Credit;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::RequestPart::Service';

use MooseX::Types::CyberSource qw( RequestID );

has request_id => (
	isa         => RequestID,
	remote_name => 'captureRequestID',
	predicate   => 'has_request_id',
	is          => 'rw',
	required    => 0,
	traits      => ['SetOnce'],
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Credit Service

=attr request_id

The L<request_id|Business::CyberSource::Response/"request_id"> returned from a
previous request for capture. Creates a follow-on credit by linking the credit
to the previous capture. If you send this field, you do not need to send
several other credit request fields.

=cut
