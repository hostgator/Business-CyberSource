package Business::CyberSource::Request::Role::BillingInfo;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;
use Carp;

# VERSION

use Moose::Role;
use MooseX::Aliases;
use MooseX::Types::Varchar         qw( Varchar       );
use MooseX::Types::Email           qw( EmailAddress  );
use MooseX::Types::CyberSource     qw( CountryCode   );
use MooseX::Types::NetAddr::IP     qw( NetAddrIPv4   );

has first_name => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	documentation => 'Customer\'s first name.The value should be the same as '
		. 'the one that is on the card.',
);

has last_name => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	documentation => 'Customer\'s last name. The value should be the same as '
		. 'the one that is on the card.'
);

has street => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	alias    => 'street1',
	documentation => 'First line of the billing street address as it '
		. 'appears on the credit card issuer\'s records. alias: C<street1>',
);

has street2 => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[60],
	predicate => 'has_street2',
	documentation => 'Second line of the billing street address.',
);

has street3 => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[60],
	predicate => 'has_street3',
	documentation => 'Third line of the billing street address.',
);

has street4 => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[60],
	predicate => 'has_street4',
	documentation => 'Fourth line of the billing street address.',
);

has city => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
	documentation => 'City of the billing address.',
);

has state => (
	required => 0,
	alias    => 'province',
	is       => 'ro',
	isa      => Varchar[2],
	predicate => 'has_state',
	documentation => 'State or province of the billing address. '
		. 'Use the two-character codes. alias: C<province>',
);

has country => (
	required => 1,
	coerce   => 1,
	is       => 'ro',
	isa      => CountryCode,
	documentation => 'ISO 2 character country code '
		. '(as it would apply to a credit card billing statement)',
);

has zip => (
	required => 0,
	alias    => 'postal_code',
	is       => 'ro',
	isa      => Varchar[10],
	predicate => 'has_zip',
	documentation => 'Postal code for the billing address. '
		. 'The postal code must consist of 5 to 9 digits. '
		. 'alias: C<postal_code>',
);

has email => (
	required => 1,
	is       => 'ro',
	isa      => EmailAddress,
	documentation => 'Customer\'s email address, including the full domain '
		. 'name',
);

has ip => (
	required => 0,
	alias    => 'ip_address',
	coerce   => 1,
	is       => 'ro',
	isa      => NetAddrIPv4,
	predicate => 'has_ip',
	documentation => 'Customer\'s IP address. alias: C<ip_address>',
);

sub _billing_info {
	my $self = shift;

	my $i = {
		firstName  => $self->first_name,
		lastName   => $self->last_name,
		street1    => $self->street1,
		city       => $self->city,
		country    => $self->country,
		email      => $self->email,
	};

	$i->{ipAddress}  = $self->ip->addr if $self->has_ip;
	$i->{state}      = $self->state    if $self->has_state;
	$i->{postalCode} = $self->zip      if $self->has_zip;
	$i->{street2}    = $self->street2  if $self->has_street2;
	$i->{street3}    = $self->street3  if $self->has_street3;
	$i->{street4}    = $self->street3  if $self->has_street4;

	return $i;
}

1;

# ABSTRACT: Role for requests that require "bill to" information
