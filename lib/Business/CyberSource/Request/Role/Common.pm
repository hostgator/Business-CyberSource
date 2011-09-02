package Business::CyberSource::Request::Role::Common;
use 5.008;
use strict;
use warnings;
use Carp;
our @CARP_NOT = qw( SOAP::Lite );

our $VERSION = 'v0.1.11'; # VERSION

use Moose::Role;
use MooseX::Types::Moose   qw( HashRef );
use MooseX::Types::Varchar qw( Varchar );
use MooseX::Types::URI     qw( Uri     );

with qw(
	Business::CyberSource
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::Credentials
);

requires 'submit';

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
);

has trace => (
	is  => 'rw',
	isa => 'XML::Compile::SOAP::Trace',
);

1;

# ABSTRACT: Request Role

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::Common - Request Role

=head1 VERSION

version v0.1.11

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

