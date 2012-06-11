package Business::CyberSource::RequestPart::Service::Capture;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::RequestPart::Service';

use MooseX::Types::CyberSource qw( RequestID );

has request_id => (
	isa         => RequestID,
	remote_name => 'authRequestID',
	predicate   => 'has_request_id',
	is          => 'rw',
	required    => 1,
	traits      => ['SetOnce'],
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Capture Service

=attr request_id

Value of L<request_id|Business::CyberSource::Response/"request_id"> returned from
a previous L<Authorization Reply|Business::CyberSource::Request::Authorization>.

=cut
