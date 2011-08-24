package Business::CyberSource::Request::Role::Credentials;
use 5.008;
use strict;
use warnings;

our $VERSION = 'v0.1.4'; # VERSION

use Moose::Role;
use namespace::autoclean;

has production => (
	required => 1,
	is       => 'ro',
	isa      => 'Bool',
);

has username => (
	documentation => 'your merchantID',
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has password => (
	documentation => 'your SOAP transaction key',
	required => 1,
	is       => 'ro',
	isa      => 'Str', # actually I wonder if I can validate this more
);

1;

# ABSTRACT: CyberSource login credentials

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::Credentials - CyberSource login credentials

=head1 VERSION

version v0.1.4

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

