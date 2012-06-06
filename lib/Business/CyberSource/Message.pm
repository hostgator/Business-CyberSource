package Business::CyberSource::Message;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005004'; # VERSION

use Moose;
with 'MooseX::Traits';

use MooseX::SetOnce 0.200001;
use MooseX::StrictConstructor;
use MooseX::ABC 0.06;

has trace => (
	isa       => 'XML::Compile::SOAP::Trace',
	predicate => 'has_trace',
	traits    => [ 'SetOnce' ],
	is        => 'rw',
	writer    => '_trace',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Message Class;


__END__
=pod

=head1 NAME

Business::CyberSource::Message - Abstract Message Class;

=head1 VERSION

version 0.005004

=head1 ATTRIBUTES

=head2 trace

A L<XML::Compile::SOAP::Trace> object which is populated only after the object
has been submitted to CyberSource by a L<Business::CyberSource::Client>.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

