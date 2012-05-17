package Business::CyberSource::Response::Role::Authorization;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005000'; # VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Response::Role::ProcessorResponse
	Business::CyberSource::Response::Role::AVS
	Business::CyberSource::Response::Role::CVN
);

use MooseX::SetOnce 0.200001;

use MooseX::Types::CyberSource qw( _VarcharSeven );

has auth_code => (
	isa       => _VarcharSeven,
	predicate => 'has_auth_code',
	traits    => ['SetOnce'],
	is        => 'rw',
);

has auth_record => (
	isa       => 'Str',
	predicate => 'has_auth_record',
	traits    => ['SetOnce'],
	is        => 'rw',
);

1;

# ABSTRACT: CyberSource Authorization Response only attributes


__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::Authorization - CyberSource Authorization Response only attributes

=head1 VERSION

version 0.005000

=head1 DESCRIPTION

If the transaction did Authorization then this role is applied

=head2 composes

=over

=item L<Business::CyberSource::Response::Role::ProcessorResponse>

=item L<Business::CyberSource::Response::Role::AVS>

=item L<Business::CyberSource::Response::Role::CVN>

=back

=head1 ATTRIBUTES

=head2 auth_code

=head2 auth_record

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

