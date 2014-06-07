package Business::CyberSource::RequestPart::BillTo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with    'MooseX::RemoteHelper::CompositeSerialization';

use MooseX::Aliases;
use MooseX::Types::Common::String qw( NonEmptySimpleStr );
use MooseX::Types::Email          qw( EmailAddress      );
use MooseX::Types::NetAddr::IP    qw( NetAddrIPv4       );

use MooseX::Types::CyberSource qw(
	CountryCode
	_VarcharTen
	_VarcharTwenty
	_VarcharFifty
	_VarcharSixty
);

use Moose::Util 'throw_exception';
use Moose::Util::TypeConstraints;

sub BUILD { ## no critic ( Subroutines::RequireFinalReturn )
	my $self = shift;
	if ( $self->country eq 'US' or $self->country eq 'CA' ) {
		throw_exception(AttributeIsRequired =>
			attribute_name => 'postal_code',
			class_name     => __PACKAGE__,
			message        => 'Attribute ('
				. 'postal_code'
				. ') is required for US or Canada',
		) unless $self->has_postal_code;

		throw_exception(AttributeIsRequired =>
			attribute_name => 'state',
			class_name     => __PACKAGE__,
			message        => 'Attribute ('
				. 'state'
				. ') is required for US or Canada',
		) unless $self->has_state;
	}
}

has first_name => (
	remote_name => 'firstName',
	required    => 1,
	is          => 'ro',
	isa         => _VarcharSixty,
);

has last_name => (
	remote_name => 'lastName',
	required    => 1,
	is          => 'ro',
	isa         => _VarcharSixty,
);

has street1 => (
	remote_name => 'street1',
	required    => 1,
	is          => 'ro',
	isa         => _VarcharSixty,
	alias       => 'street',
);

has street2 => (
	remote_name => 'street2',
	isa         => _VarcharSixty,
	traits      => ['SetOnce'],
	is          => 'rw',
	predicate   => 'has_street2',
);

has street3 => (
	remote_name => 'street3',
	isa         => _VarcharSixty,
	traits      => ['SetOnce'],
	is          => 'rw',
	predicate   => 'has_street3',
);

has street4 => (
	remote_name => 'street4',
	isa         => _VarcharSixty,
	traits      => ['SetOnce'],
	is          => 'rw',
	predicate   => 'has_street4',
);

has city => (
	remote_name => 'city',
	isa         => _VarcharFifty,
	required    => 1,
	is          => 'ro',
);

has state => (
	remote_name => 'state',
	isa         => subtype( NonEmptySimpleStr, where { length $_ == 2 }),
	traits      => ['SetOnce'],
	alias       => 'province',
	is          => 'ro',
	predicate => 'has_state',
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
	traits      => ['SetOnce'],
	alias       => 'zip',
	is          => 'rw',
	predicate   => 'has_postal_code',
);

has phone_number => (
	remote_name => 'phoneNumber',
	isa       => _VarcharTwenty,
	traits    => ['SetOnce'],
	alias     => 'phone',
	is        => 'rw',
	predicate => 'has_phone_number',
);

has email => (
	remote_name => 'email',
	required    => 1,
	is          => 'ro',
	isa         => EmailAddress,
);

has ip => (
	remote_name => 'ipAddress',
	traits    => ['SetOnce'],
	is        => 'rw',
	coerce    => 1,
	isa       => NetAddrIPv4,
	predicate => 'has_ip',
	serializer => sub {
		my ( $attr, $instance ) = @_;
		return $attr->get_value( $instance )->addr;
	},
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: BillTo information

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=attr ip

Customer's IP address, meaning the IP that the request was made from.

=attr first_name

Customer's first name. The value should be the same as the one that is on the
card.

=attr last_name

Customer's last name. The value should be the same as the one that is on the card.

=attr email

Customer's email address, including the full domain name

=attr phone_number

=attr street1

First line of the billing street address as it appears on the credit card issuer's records.

=attr street2

=attr street3

=attr street4

=attr city

City of the billing address.

=attr state

State or province of the billing address. Use the two-character codes. alias: C<province>

=attr country

ISO 2 character country code (as it would apply to a credit card billing statement)

=attr postal_code

Postal code for the billing address. The postal code must consist of 5 to 9
digits.

Required if C<country> is "US" or "CA".

=for Pod::Coverage BUILD

=cut
