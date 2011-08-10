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
	is       => 'ro',
	isa      => 'version',
	default  => sub {
		my $self = shift;
		my $value = version->parse( $Business::CyberSource::VERSION );

		$self->_sdbo->add_elem(
			name   => 'clientLibraryVersion',
			value  => "$value", # quotes to stringify object
		);

		return $value;
	},
);

has client_library => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	default  => sub {
		my $self = shift;
		my $value = __PACKAGE__;
		my $sb = $self->_sdbo;
		$sb->add_elem(
			name   => 'clientLibrary',
			value  => $value,
		);
		return $value;
	},
);

has client_env => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	default  => sub {
		use Config;
		my $self = shift;
		my $value = "Perl $Config{version} $Config{osname} $Config{osvers} $Config{archname}";
		my $sb = $self->_sdbo;
		$sb->add_elem(
			name   => 'clientLibraryEnvironment',
			value  => $value,
		);
		return $value;
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

