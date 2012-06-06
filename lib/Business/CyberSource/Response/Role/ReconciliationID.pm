package Business::CyberSource::Response::Role::ReconciliationID;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005004'; # VERSION

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

version 0.005004

=head1 ATTRIBUTES

=head2 reconciliation_id

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

