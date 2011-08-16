package Business::CyberSource::Response::Role::Accept;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.1'; # VERSION
}
use Moose::Role;

has amount => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

has currency => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has datetime => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: role for handling accepted transactions

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::Accept - role for handling accepted transactions

=head1 VERSION

version v0.1.1

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

