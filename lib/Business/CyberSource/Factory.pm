package Business::CyberSource::Factory;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.005004'; # VERSION

use Moose;
use MooseX::StrictConstructor;
use MooseX::ABC 0.06;

#requires 'create';

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Factory Base Class

__END__
=pod

=head1 NAME

Business::CyberSource::Factory - Factory Base Class

=head1 VERSION

version 0.005004

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

