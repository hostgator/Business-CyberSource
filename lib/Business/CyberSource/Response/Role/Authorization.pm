package Business::CyberSource::Response::Role::Authorization;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.2.7'; # VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Response::Role::ProcessorResponse
);

use MooseX::Types::Varchar qw( Varchar );
use MooseX::Types::Moose   qw( Str     );

has auth_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[7],
);

has auth_record => (
	required => 1,
	is       => 'ro',
	isa      => Str,
);

has avs_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[1],
	documentation => 'AVS results.',
);

has avs_code_raw => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[10],
	documentation => 'AVS result code sent directly from the processor. '
		. 'Returned only if a value is returned by the processor.',
);

has cv_code => (
	required  => 0,
	predicate => 'has_cv_code',
	is        => 'ro',
	isa       => Varchar[1],
);

has cv_code_raw => (
	required  => 0,
	predicate => 'has_cv_code_raw',
	is        => 'ro',
	isa       => Varchar[10],
);


1;

# ABSTRACT: CyberSource Authorization Response only attributes

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::Authorization - CyberSource Authorization Response only attributes

=head1 VERSION

version v0.2.7

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

