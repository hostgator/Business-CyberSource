package Business::CyberSource::Request::Role::Credentials;
use 5.008;
use strict;
use warnings;

our $VERSION = 'v0.3.2'; # VERSION

use Moose::Role;
use namespace::autoclean;
use MooseX::Types::Varchar        qw( Varchar  );
use MooseX::Types::Moose          qw( Bool Str Object );
use MooseX::Types::Common::String qw( NonEmptyStr );

use XML::Compile::SOAP::WSS;

has production => (
	documentation => '0: test server. 1: production server',
	required => 1,
	is       => 'ro',
	isa      => Bool,
);

has username => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[30],
	documentation => 'Your CyberSource merchant ID. Use the same merchantID '
		. 'for evaluation, testing, and production',
);

has password => (
	documentation => 'your SOAP transaction key',
	required => 1,
	is       => 'ro',
	isa      => NonEmptyStr,
);

1;

# ABSTRACT: CyberSource login credentials

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::Credentials - CyberSource login credentials

=head1 VERSION

version v0.3.2

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

