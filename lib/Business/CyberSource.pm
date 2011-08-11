package Business::CyberSource;
use 5.006;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}
use Moose::Role;
use namespace::autoclean;

has client_version => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
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

has client => (
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
