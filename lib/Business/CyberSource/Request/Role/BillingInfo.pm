package Business::CyberSource::Request::Role::BillingInfo;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = 'v0.2.3'; # VERSION

use Moose::Role;
use namespace::autoclean;
use MooseX::Aliases;
use MooseX::Types::Varchar         qw( Varchar       );
use MooseX::Types::Email           qw( EmailAddress  );
use MooseX::Types::Locale::Country qw( Alpha2Country );
use MooseX::Types::NetAddr::IP     qw( NetAddrIPv4   );

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
	isa      => NetAddrIPv4,
	documentation => 'IP address that customer submitted transaction from',
);

sub _billing_info {
	my $self = shift;

	my $bi = {
		firstName  => $self->first_name,
		lastName   => $self->last_name,
		street1    => $self->street1,
		street2    => $self->street2,
		city       => $self->city,
		state      => $self->state,
		postalCode => $self->zip,
		country    => $self->country,
		email      => $self->email,
		ipAddress  => $self->ip,
	};

	return $bi;
}

1;

# ABSTRACT: Role for requests that require "bill to" information

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::BillingInfo - Role for requests that require "bill to" information

=head1 VERSION

version v0.2.3

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

