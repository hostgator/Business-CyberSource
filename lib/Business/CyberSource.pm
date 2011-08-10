package Business::CyberSource;
use 5.006;
use strict;
use warnings;
BEGIN {
	# VERSION
}
use Moose::Role;

has client_version => (
	required => 1,
	is       => 'ro',
	isa      => 'version',
	default  => sub {
		return version->parse( $Business::CyberSource::VERSION );
	},
	trigger  => sub {
		my ( $self, $value ) = @_;
		my $sb = $self->_sdbo;
		$sb->add_elem(
			name   => 'clientLibraryVersion',
			value  => $value,
		);
	},
);

has client_library => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	default  => __PACKAGE__,
	trigger  => sub {
		my ( $self, $value ) = @_;
		my $sb = $self->_sdbo;
		$sb->add_elem(
			name   => 'clientLibrary',
			value  => $value,
		);
	},
);

has client_env => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	default  => sub {
		use Config;
		return "Perl $Config{version} $Config{osname} $Config{osvers} $Config{archname}";
	},
	trigger  => sub {
		my ( $self, $value ) = @_;
		my $sb = $self->_sdbo;
		$sb->add_elem(
			name   => 'clientLibraryEnvironment',
			value  => $value,
		);
	},
);

1;

# ABSTRACT: Business::CyberSource
