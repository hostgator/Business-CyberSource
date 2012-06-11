package Business::CyberSource::RequestPart::Service::AuthReversal;
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

# ABSTRACT: AuthReversal Service

=attr request_id

The L<request_id|Business::CyberSource::Response/"request_id"> for the authorization that you want to reverse.

=cut
