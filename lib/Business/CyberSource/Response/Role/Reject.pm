package Business::CyberSource::Response::Role::Reject;
use 5.008;
use strict;
use warnings;

our $VERSION = 'v0.2.4'; # VERSION

use Moose::Role;

1;

# ABSTRACT: role for handling rejected transactions


__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::Reject - role for handling rejected transactions

=head1 VERSION

version v0.2.4

=head1 DESCRIPTION

This trait is applied if the decision is C<REJECT>

=head1 ATTRIBUTES

=head2 request_token

The field is an encoded string that contains no confidential information,
such as an account number or card verification number. The string can contain
up to 256 characters.

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

