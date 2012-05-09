package Business::CyberSource::Request::Role::FollowUp;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004007'; # VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::RequestID
);

1;

# ABSTRACT: Role to apply to requests that are follow ups to a previous request


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::FollowUp - Role to apply to requests that are follow ups to a previous request

=head1 VERSION

version 0.004007

=head1 DESCRIPTION

=head2 composes

=over

=item L<Business::CyberSource::Role::RequestID>

=back

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

