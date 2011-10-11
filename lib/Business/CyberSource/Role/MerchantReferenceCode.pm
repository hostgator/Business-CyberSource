package Business::CyberSource::Role::MerchantReferenceCode;
use 5.008;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

our $VERSION = 'v0.4.1'; # VERSION

use Moose::Role;
use MooseX::Types::Varchar qw( Varchar );

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
);

1;

# ABSTRACT: Generic implementation of MerchantReferenceCode

__END__
=pod

=head1 NAME

Business::CyberSource::Role::MerchantReferenceCode - Generic implementation of MerchantReferenceCode

=head1 VERSION

version v0.4.1

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

