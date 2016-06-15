package Business::CyberSource::RequestPart::Service::Auth;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::RequestPart::Service';

use MooseX::Types::CyberSource qw( CommerceIndicator );

has commerce_indicator => (
	isa         => CommerceIndicator,
	remote_name => 'commerceIndicator',
	predicate   => 'has_commerce_indicator',
	is          => 'rw',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Auth

=attr commerce_indicator

The L<commerce_indicator|Business::CyberSource::Response/"commerce_indicator">
for the authorization that you are performing.

=cut
