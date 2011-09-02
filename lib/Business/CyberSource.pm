package Business::CyberSource;
use 5.006;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.1.11'; # VERSION

use Moose::Role;

use MooseX::Types::Moose qw( Str );
use MooseX::Types::Path::Class qw( File Dir );
use Path::Class;
use File::ShareDir qw( dist_file );
use Config;

has client_version => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub {
		my $version
			= $Business::CyberSource::VERSION ? $Business::CyberSource::VERSION
			                                  : 'v0.0.0'
			;
		return $version;
	},
);

has client_name => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub { return __PACKAGE__ },
);

has client_env => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub {
		return "Perl $Config{version} $Config{osname} $Config{osvers} $Config{archname}";
	},
);

has cybs_api_version => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => Str,
	default  => '1.62',
);

has cybs_wsdl => (
	required  => 0,
	lazy      => 1,
	is        => 'ro',
	isa       => File,
	builder   => '_build_cybs_wsdl',
);

has cybs_xsd => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => File,
	builder  => '_build_cybs_xsd',
);

sub _build_cybs_wsdl {
		my $self = shift;

		my $dir = $self->production ? 'production' : 'test';

		my $file
			= Path::Class::File->new(
				dist_file(
					'Business-CyberSource',
					$dir
					. '/'
					. 'CyberSourceTransaction_'
					. $self->cybs_api_version
					. '.wsdl'
				)
			);

		return $file;
}

sub _build_cybs_xsd {
		my $self = shift;

		my $dir = $self->production ? 'production' : 'test';

		my $file
			= Path::Class::File->new(
				dist_file(
					'Business-CyberSource',
					$dir
					. '/'
					. 'CyberSourceTransaction_'
					. $self->cybs_api_version
					. '.xsd'
				)
			);

		return $file;
}

1;

# ABSTRACT: Business::CyberSource

__END__
=pod

=head1 NAME

Business::CyberSource - Business::CyberSource

=head1 VERSION

version v0.1.11

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

