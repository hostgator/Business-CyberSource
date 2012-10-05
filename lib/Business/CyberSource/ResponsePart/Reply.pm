package Business::CyberSource::ResponsePart::Reply;
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
	Business::CyberSource::Response::Role::RequestDateTime
);

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Generic Reply part of response
