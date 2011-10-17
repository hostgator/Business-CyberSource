package Business::CyberSource::Response::Role::AVS;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.4.2'; # VERSION

use Moose::Role;

use MooseX::Types::CyberSource qw( AVSResult );
use MooseX::Types::Varchar qw( Varchar );

has avs_code => (
	required => 0,
	predicate => 'has_avs_code',
	is       => 'ro',
	isa      => AVSResult,
	documentation => 'AVS results.',
);

has avs_code_raw => (
	required  => 0,
	predicate => 'has_avs_code_raw',
	is        => 'ro',
	isa       => Varchar[10],
	documentation => 'AVS result code sent directly from the processor. '
		. 'Returned only if a value is returned by the processor.',
);

1;

# ABSTRACT: AVS Role

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::AVS - AVS Role

=head1 VERSION

version v0.4.2

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

