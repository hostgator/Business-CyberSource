package Business::CyberSource::Request::Role::BillingInfo;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = 'v0.1.10'; # VERSION

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

sub _build_bill_to_info {
	my ( $self, $sb ) = @_;

	my $bill_to = $sb->add_elem(
		name => 'billTo',
	);

	$sb->add_elem(
		name   => 'firstName',
		value  => $self->first_name,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'lastName',
		value  => $self->last_name,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'street1',
		value  => $self->street1,
		parent => $bill_to,
	);

	if ( $self->street2 ) {
		$sb->add_elem(
			name   => 'street2',
			value  => $self->street2,
			parent => $bill_to,
		);
	}

	$sb->add_elem(
		name   => 'city',
		value  => $self->city,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'state',
		parent => $bill_to,
		value  => $self->state,
	);

	$sb->add_elem(
		name   => 'postalCode',
		parent => $bill_to,
		value  => $self->zip,
	);

	$sb->add_elem(
		name   => 'country',
		parent => $bill_to,
		value  => $self->country,
	);

	$sb->add_elem(
		name   => 'email',
		value  => $self->email,
		parent => $bill_to,
	);

	if ( $self->ip ) {
		$sb->add_elem(
			name   => 'ipAddress',
			value  => $self->ip,
			parent => $bill_to,
		);
	}

	return $sb;
}

1;

# ABSTRACT: Role for requests that require "bill to" information

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::BillingInfo - Role for requests that require "bill to" information

=head1 VERSION

version v0.1.10

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

