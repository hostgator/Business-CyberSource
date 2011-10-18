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
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{firstName} = $self->first_name;
	},
	documentation => 'Customer\'s first name.The value should be the same as '
		. 'the one that is on the card.',
);

has last_name => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{lastName} = $self->last_name;
	},
	documentation => 'Customer\'s last name. The value should be the same as '
		. 'the one that is on the card.'
);

has street1 => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	alias    => 'street',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{street1} = $self->street1;
		street1    => $self->street1,
	},
	documentation => 'First line of the billing street address as it '
		. 'appears on the credit card issuer\'s records. alias: C<street1>',
);

has street2 => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[60],
	predicate => 'has_street2',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{street2} = $self->street2;
	},
	documentation => 'Second line of the billing street address.',
);

has street3 => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[60],
	predicate => 'has_street3',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{street3} = $self->street3;
	},
	documentation => 'Third line of the billing street address.',
);

has street4 => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[60],
	predicate => 'has_street4',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{street4} = $self->street4;
	},
	documentation => 'Fourth line of the billing street address.',
);

has city => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{city} = $self->city;
	},
	documentation => 'City of the billing address.',
);

has state => (
	required => 0,
	alias    => 'province',
	is       => 'ro',
	isa      => Varchar[2],
	predicate => 'has_state',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{state} = $self->state;
	},
	documentation => 'State or province of the billing address. '
		. 'Use the two-character codes. alias: C<province>',
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
	documentation => 'ISO 2 character country code '
		. '(as it would apply to a credit card billing statement)',
);

has postal_code => (
	required  => 0,
	alias     => 'zip',
	is        => 'ro',
	isa       => Varchar[10],
	predicate => 'has_zip',
	trigger   => sub {
		my $self = shift;
		$self->_request_data->{billTo}{postalCode} = $self->postal_code;
	},
	documentation => 'Postal code for the billing address. '
		. 'The postal code must consist of 5 to 9 digits. '
		. 'Required if C<country> is "US" or "CA"'
		. 'alias: C<postal_code>',
);

has phone_number => (
	required  => 0,
	alias     => 'phone',
	is        => 'ro',
	isa       => Varchar[20],
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
	documentation => 'Customer\'s email address, including the full domain '
		. 'name',
);

has ip_address => (
	required => 0,
	alias    => 'ip',
	coerce   => 1,
	is       => 'ro',
	isa      => NetAddrIPv4,
	predicate => 'has_ip',
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{billTo}{ipAddress} = $self->ip_address;
	},
	documentation => 'Customer\'s IP address. alias: C<ip_address>',
);

1;

# ABSTRACT: Role for requests that require "bill to" information
