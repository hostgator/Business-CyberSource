package Business::CyberSource::Role::MerchantReferenceCode;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004009'; # VERSION

use Moose::Role;
use MooseX::Types::CyberSource qw( _VarcharFifty );

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => _VarcharFifty,
);

1;

# ABSTRACT: Generic implementation of MerchantReferenceCode

__END__
=pod

=head1 NAME

Business::CyberSource::Role::MerchantReferenceCode - Generic implementation of MerchantReferenceCode

=head1 VERSION

version 0.004009

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

