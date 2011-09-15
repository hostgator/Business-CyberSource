package Business::CyberSource::Response::Role::ReconciliationID;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.3.1'; # VERSION

use Moose::Role;
use MooseX::Types::Moose qw( Int );

has reconciliation_id => (
	required => 1,
	is       => 'ro',
	isa      => Int,
);

1;

# ABSTRACT: Reconciliation Identifier

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::ReconciliationID - Reconciliation Identifier

=head1 VERSION

version v0.3.1

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

