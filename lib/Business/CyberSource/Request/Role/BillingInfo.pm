package Business::CyberSource::Request::Role::BillingInfo;
use 5.008;
use strict;
use warnings;
use Carp;

# VERSION

use Moose::Role;
use namespace::autoclean;
use MooseX::Aliases;
use MooseX::Types::Varchar         qw( Varchar       );
use MooseX::Types::Email           qw( EmailAddress  );
use MooseX::Types::Locale::Country qw( Alpha2Country );

has first_name => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	documentation => 'Card Holder\'s first name',
);

has last_name => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	documentation => 'Card Holder\'s last name',
);

has street => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[60],
	alias    => 'street1',
	documentation => 'Street address on credit card billing statement',
);

has street2 => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[60],
	documentation => 'Second line of the billing street address.',
);

has city => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
	documentation => 'City on credit card billing statement',
);

has state => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[2],
	documentation => 'State on credit card billing statement',
);

has country => (
	required => 1,
	coerce   => 1,
	is       => 'ro',
	isa      => Alpha2Country,
	documentation => 'ISO 2 character country code '
		. '(as it would apply to a credit card billing statement)',
);

has zip => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[10],
	documentation => 'postal code on credit card billing statement',
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
	is       => 'ro',
	isa      => Varchar[15],
	documentation => 'IP address that customer submitted transaction from',
);

1;

# ABSTRACT: Role for requests that require "bill to" information
