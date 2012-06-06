package Business::CyberSource::Request::Role::Credentials;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005004'; # VERSION

use Moose::Role;
use MooseX::Types::Common::String qw( NonEmptyStr NonEmptySimpleStr );

use Moose::Util::TypeConstraints;

has production => (
	isa       => 'Bool',
	predicate => 'has_production',
	is        => 'ro',
);

has username => (
	isa       => subtype( NonEmptySimpleStr, where { length $_ <= 30 }),
	predicate => 'has_username',
	is        => 'ro',
);

has password => (
	isa       => NonEmptyStr,
	predicate => 'has_password',
	is        => 'ro',
);

1;

# ABSTRACT: CyberSource login credentials


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::Credentials - CyberSource login credentials

=head1 VERSION

version 0.005004

=head1 ATTRIBUTES

=head2 production

0: test server. 1: production server

=head2 username

Your CyberSource merchant ID. Use the same merchantID for evaluation, testing,
and production

=head2 password

your SOAP transaction key

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

