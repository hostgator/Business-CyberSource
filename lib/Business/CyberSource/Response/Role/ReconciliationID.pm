package Business::CyberSource::Response::Role::ReconciliationID;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006001'; # VERSION

use Moose::Role;

has reconciliation_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: Reconciliation Identifier


__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::ReconciliationID - Reconciliation Identifier

=head1 VERSION

version 0.006001

=head1 ATTRIBUTES

=head2 reconciliation_id

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

