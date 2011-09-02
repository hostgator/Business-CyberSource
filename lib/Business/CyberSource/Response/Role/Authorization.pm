package Business::CyberSource::Response::Role::Authorization;
use 5.008;
use strict;
use warnings;
BEGIN {
	our $VERSION = 'v0.2.0'; # VERSION
}
use Moose::Role;

has request_token => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has auth_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

has auth_record => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has avs_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has avs_code_raw => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has processor_response => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: CyberSource Authorization Response object

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::Authorization - CyberSource Authorization Response object

=head1 VERSION

version v0.2.0

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

