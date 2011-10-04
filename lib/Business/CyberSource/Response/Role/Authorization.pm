package Business::CyberSource::Response::Role::Authorization;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.3.8'; # VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Response::Role::ProcessorResponse
	Business::CyberSource::Response::Role::AVS
	Business::CyberSource::Response::Role::CVN
);

use MooseX::Types::Varchar qw( Varchar );
use MooseX::Types::Moose   qw( Str     );

has auth_code => (
	required  => 0,
	predicate => 'has_auth_code',
	is        => 'ro',
	isa       => Varchar[7],
);

has auth_record => (
	required  => 0,
	predicate => 'has_auth_record',
	is        => 'ro',
	isa       => Str,
);

1;

# ABSTRACT: CyberSource Authorization Response only attributes

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::Authorization - CyberSource Authorization Response only attributes

=head1 VERSION

version v0.3.8

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

