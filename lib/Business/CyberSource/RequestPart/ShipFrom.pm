package Business::CyberSource::RequestPart::ShipFrom;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with 'MooseX::RemoteHelper::CompositeSerialization';

use MooseX::Types::Common::String qw( NonEmptySimpleStr );

has postal_code => (
    remote_name => 'postalCode',
    is          => 'ro',
    isa         => NonEmptySimpleStr,
    required    => 0,
);

1;

# ABSTRACT: ShipFrom information

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=attr postal_code 

=for Pod::Coverage BUILD

=cut
