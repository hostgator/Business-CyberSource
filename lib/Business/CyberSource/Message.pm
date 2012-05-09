package Business::CyberSource::Message;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004006'; # VERSION

use Moose;
with 'MooseX::Traits';

use MooseX::StrictConstructor;
use MooseX::ABC;

use MooseX::SetOnce 0.200001;

has trace => (
	isa      => 'XML::Compile::SOAP::Trace',
	is       => 'rw',
	traits   => [ 'SetOnce' ],
	init_arg => undef,
	writer   => '_trace',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Message Class;

__END__
=pod

=head1 NAME

Business::CyberSource::Message - Abstract Message Class;

=head1 VERSION

version 0.004006

=head1 ATTRIBUTES

=head2 trace

Reader: trace

Writer: _trace

Type: XML::Compile::SOAP::Trace

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

