package Business::CyberSource::Response::Role::AVS;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005002'; # VERSION

use Moose::Role;

use MooseX::SetOnce 0.200001;

use MooseX::Types::CyberSource qw( AVSResult _VarcharTen );

has avs_code => (
	isa       => AVSResult,
	predicate => 'has_avs_code',
	traits    => ['SetOnce'],
	is        => 'rw',
);

has avs_code_raw => (
	isa       => _VarcharTen,
	predicate => 'has_avs_code_raw',
	traits    => ['SetOnce'],
	is        => 'rw',
);

1;

# ABSTRACT: AVS Role


__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::AVS - AVS Role

=head1 VERSION

version 0.005002

=head1 ATTRIBUTES

=head2 avs_code

AVS results

=head2 avs_code_raw

AVS result code sent directly from the processor. Returned only if a value is
returned by the processor.

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

