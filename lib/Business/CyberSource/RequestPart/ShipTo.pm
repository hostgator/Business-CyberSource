package Business::CyberSource::RequestPart::ShipTo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use MooseX::RemoteHelper;
extends 'Business::CyberSource::MessagePart';
with 'MooseX::RemoteHelper::CompositeSerialization';
use MooseX::Aliases;

use MooseX::Types::Common::String qw( NonEmptySimpleStr );

use MooseX::Types::CyberSource qw(
  CountryCode
  _VarcharTen
  _VarcharFifteen
  _VarcharTwenty
  _VarcharFifty
  _VarcharSixty
  ShippingMethod
);

use Moose::Util 'throw_exception';
use Moose::Util::TypeConstraints;

sub BUILD {
    my $self = shift;
    if ( $self->country eq 'US' or $self->country eq 'CA' ) {
        throw_exception(
            AttributeIsRequired => attribute_name => 'city',
            class_name          => __PACKAGE__,
            message             => 'Attribute (' . 'city'
              . ') is required for US or Canada',
        ) unless $self->has_city;

        throw_exception(
            AttributeIsRequired => attribute_name => 'postal_code',
            class_name          => __PACKAGE__,
            message             => 'Attribute ('
              . 'postal_code'
              . ') is required for US or Canada',
        ) unless $self->has_postal_code;

        throw_exception(
            AttributeIsRequired => attribute_name => 'state',
            class_name          => __PACKAGE__,
            message             => 'Attribute (' . 'state'
              . ') is required for US or Canada',
        ) unless $self->has_state;
    }
    return;
}

has first_name => (
    remote_name => 'firstName',
    is          => 'ro',
    isa         => _VarcharSixty,
);

has last_name => (
    remote_name => 'lastName',
    is          => 'ro',
    isa         => _VarcharSixty,
);

has street1 => (
    remote_name => 'street1',
    required    => 1,
    is          => 'ro',
    isa         => _VarcharSixty,
);

has street2 => (
    remote_name => 'street2',
    isa         => _VarcharSixty,
    is          => 'ro',
);

has city => (
    remote_name => 'city',
    isa         => _VarcharFifty,
    is          => 'ro',
    predicate   => 'has_city',
);

has state => (
    remote_name => 'state',
    isa         => subtype( NonEmptySimpleStr, where { length $_ == 2 } ),
    is          => 'ro',
    predicate   => 'has_state',
);

has country => (
    remote_name => 'country',
    required    => 1,
    coerce      => 1,
    is          => 'ro',
    isa         => CountryCode,
);

has postal_code => (
    remote_name => 'postalCode',
    isa         => _VarcharTen,
    is          => 'ro',
    predicate   => 'has_postal_code',
);

has phone_number => (
    remote_name => 'phoneNumber',
    isa         => _VarcharFifteen,
    is          => 'ro',
);

has shipping_method => (
    remote_name => 'shippingMethod',
    isa         => ShippingMethod,
    is          => 'ro',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: ShipTo information

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=head1 WITH FOLLOWING ATTRIBUTES:

=head2 REQUIRED:

=over 2

=item country

=item street1

=back

=head2 OPTIONAL:

=over 2

=item first_name

=item last_name

=item city

=item state

=item postal_code

=item street2

=item phone_number

=item shipping_method

=back

=head1 NOTES:

=over 2

=item if the country USA or Canada, then city, postal_code and state become required

=back
