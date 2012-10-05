package Business::CyberSource::ResponsePart::CaptureReply;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with qw(
	Business::CyberSource::Response::Role::ReasonCode
	Business::CyberSource::Response::Role::ReconciliationID
	Business::CyberSource::Response::Role::Amount
);

use MooseX::Types::CyberSource qw( DateTimeFromW3C );

has datetime => (
	isa         => DateTimeFromW3C,
	remote_name => 'requestDateTime',
	is          => 'rw',
	coerce      => 1,
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: ccCaptureReply part of response
