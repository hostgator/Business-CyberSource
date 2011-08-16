package Business::CyberSource;
use 5.006;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose::Role;
use namespace::autoclean;

has client_version => (
	required => 1,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => 'Str',
	default  => sub { return $Business::CyberSource::VERSION },
);

has client_name => (
	required => 1,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => 'Str',
	default  => sub { return __PACKAGE__ },
);

has client_env => (
	required => 1,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => 'Str',
	default  => sub {
		use Config;
		return "Perl $Config{version} $Config{osname} $Config{osvers} $Config{archname}";
	},
);

1;

# ABSTRACT: Business::CyberSource

__END__
=pod

=head1 NAME

Business::CyberSource - Business::CyberSource

=head1 VERSION

version v0.1.0

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

