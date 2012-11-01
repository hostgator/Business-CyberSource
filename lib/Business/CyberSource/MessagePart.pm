package Business::CyberSource::MessagePart;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.006014'; # VERSION

use Moose;
with 'MooseX::Traits';

use MooseX::RemoteHelper;
use MooseX::SetOnce 0.200001;
use MooseX::StrictConstructor;
use MooseX::ABC 0.06;

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Things that all portions of a message have in common

__END__

=pod

=head1 NAME

Business::CyberSource::MessagePart - Things that all portions of a message have in common

=head1 VERSION

version 0.006014

=head1 WITH

=over

=item L<MooseX::Traits>

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

This software is Copyright (c) 2012 by HostGator.com.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
