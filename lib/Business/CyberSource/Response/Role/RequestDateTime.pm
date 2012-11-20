package Business::CyberSource::Response::Role::RequestDateTime;
use strict;
use warnings;
use namespace::autoclean;
use Module::Load qw( load );

our $VERSION = '0.007009'; # VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( DateTimeFromW3C );

has datetime => (
	isa         => DateTimeFromW3C,
	remote_name => 'requestDateTime',
	is          => 'ro',
	coerce      => 1,
	predicate   => 'has_datetime',
);

1;

# ABSTRACT: Role to provide datetime attribute

__END__

=pod

=head1 NAME

Business::CyberSource::Response::Role::RequestDateTime - Role to provide datetime attribute

=head1 VERSION

version 0.007009

=head1 DESCRIPTION

Several responses include a datetime that has a key name of C<requestDateTime>
this role is provided for those response sections.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/hostgator/business-cybersource/issues or by email to
development@hostgator.com.

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by L<HostGator.com|http://hostgator.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
