package Business::CyberSource::Response;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.3'; # VERSION
}
use Moose;
use namespace::autoclean;

with qw( MooseX::Traits );

has request_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has decision => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has reason_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Int',
);

1;

# ABSTRACT: Response Role

__END__
=pod

=head1 NAME

Business::CyberSource::Response - Response Role

=head1 VERSION

version v0.1.3

=head1 ATTRIBUTES

=head2 request_id

Reader: request_id

Type: Str

This attribute is required.

=head2 decision

Reader: decision

Type: Str

This attribute is required.

=head2 reason_code

Reader: reason_code

Type: Int

This attribute is required.

=head1 METHODS

=head2 with_traits

Method originates in MooseX::Traits.

=head2 request_id

Method originates in Business::CyberSource::Response.

=head2 new_with_traits

Method originates in MooseX::Traits.

=head2 decision

Method originates in Business::CyberSource::Response.

=head2 reason_code

Method originates in Business::CyberSource::Response.

=head2 apply_traits

Method originates in MooseX::Traits.

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

