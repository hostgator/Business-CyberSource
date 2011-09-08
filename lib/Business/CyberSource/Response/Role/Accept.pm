package Business::CyberSource::Response::Role::Accept;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.2.4'; # VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Role::Currency
);

use MooseX::Types::Moose         qw( Num Str     );
use MooseX::Types::DateTime::W3C qw( DateTimeW3C );
use MooseX::Types::Varchar       qw( Varchar     );


has amount => (
	required => 1,
	is       => 'ro',
	isa      => Num,
);

has datetime => (
	required => 1,
	is       => 'ro',
	isa      => DateTimeW3C,
);

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
);

1;

# ABSTRACT: role for handling accepted transactions


__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::Accept - role for handling accepted transactions

=head1 VERSION

version v0.2.4

=head1 DESCRIPTION

If the transaction has a C<decision> of approved then this Role is applied.

=head1 ATTRIBUTES

=head2 amount

Type: Num

Amount that was approved.

=head2 datetime

Type: MooseX::Types::DateTime::W3C::DateTimeW3C

A response timestamp (will probably become a DateTime object at some point)

=head2 reference_code

Type: MooseX::Types::Varchar::Varchar[50]

The merchant reference code originally sent

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

