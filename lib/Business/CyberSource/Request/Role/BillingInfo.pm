package Business::CyberSource::Request::Role::BillingInfo;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004009'; # VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::SetOnce 0.200001;

use MooseX::Types::Common::String  qw( NonEmptySimpleStr );
use MooseX::Types::Email           qw( EmailAddress  );
use MooseX::Types::NetAddr::IP     qw( NetAddrIPv4   );

use MooseX::Types::CyberSource qw(
	CountryCode
	_VarcharTen
	_VarcharTwenty
	_VarcharFifty
	_VarcharSixty
);

use Moose::Util::TypeConstraints;

has first_name => (
	required => 1,
	is       => 'ro',
	isa      => _VarcharSixty,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{firstName} = $self->first_name;
	},
);

has last_name => (
	required => 1,
	is       => 'ro',
	isa      => _VarcharSixty,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{lastName} = $self->last_name;
	},
);

has street1 => (
	required => 1,
	is       => 'ro',
	isa      => _VarcharSixty,
	alias    => 'street',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{street1} = $self->street1;
		street1    => $self->street1,
	},
);

has street2 => (
	isa      => _VarcharSixty,
	traits   => ['SetOnce'],
	is       => 'rw',
	predicate => 'has_street2',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{street2} = $self->street2;
	},
);

has street3 => (
	isa      => _VarcharSixty,
	traits   => ['SetOnce'],
	is       => 'rw',
	predicate => 'has_street3',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{street3} = $self->street3;
	},
);

has street4 => (
	isa      => _VarcharSixty,
	traits   => ['SetOnce'],
	is       => 'rw',
	predicate => 'has_street4',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{street4} = $self->street4;
	},
);

has city => (
	isa      => _VarcharFifty,
	required => 1,
	is       => 'ro',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{city} = $self->city;
	},
);

has state => (
	isa      => subtype( NonEmptySimpleStr, where { length $_ == 2 }),
	traits   => ['SetOnce'],
	alias    => 'province',
	is       => 'ro',
	predicate => 'has_state',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{state} = $self->state;
	},
);

has country => (
	required => 1,
	coerce   => 1,
	is       => 'ro',
	isa      => CountryCode,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{country} = $self->country;
	},
);

has postal_code => (
	isa       => _VarcharTen,
	traits    => ['SetOnce'],
	alias     => 'zip',
	is        => 'rw',
	predicate => 'has_zip',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{billTo}{postalCode} = $self->postal_code;
	},
);

has phone_number => (
	isa       => _VarcharTwenty,
	traits    => ['SetOnce'],
	alias     => 'phone',
	is        => 'rw',
	predicate => 'has_phone_number',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{billTo}{phoneNumber} = $self->phone_number;
	},
);

has email => (
	required => 1,
	is       => 'ro',
	isa      => EmailAddress,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{email} = $self->email;
	},
);

has ip_address => (
	traits    => ['SetOnce'],
	is        => 'rw',
	alias     => 'ip',
	coerce    => 1,
	isa       => NetAddrIPv4,
	predicate => 'has_ip',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{billTo}{ipAddress} = $self->ip_address->addr;
	},
);

1;

# ABSTRACT: Role for requests that require "bill to" information


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::BillingInfo - Role for requests that require "bill to" information

=head1 VERSION

version 0.004009

=head1 ATTRIBUTES

=head2 ip_address

Customer's IP address, meaning the IP that the request was made from.

=head2 first_name

Customer's first name. The value should be the same as the one that is on the
card.

=head2 last_name

Customer's last name. The value should be the same as the one that is on the card.

=head2 email

Customer's email address, including the full domain name

=head2 phone_number

=head2 street1

First line of the billing street address as it appears on the credit card issuer's records.

=head2 street2

=head2 street3

=head2 street4

=head2 city

City of the billing address.

=head2 state

State or province of the billing address. Use the two-character codes. alias: C<province>

=head2 country

ISO 2 character country code (as it would apply to a credit card billing statement)

=head2 postal_code

Postal code for the billing address. The postal code must consist of 5 to 9
digits.

Required if C<country> is "US" or "CA".

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

