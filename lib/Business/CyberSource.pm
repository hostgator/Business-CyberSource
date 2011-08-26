package Business::CyberSource;
use 5.006;
use strict;
use warnings;
use Carp;

# VERSION

use Moose::Role;
use namespace::autoclean;

has client_version => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => 'Str',
	default  => sub { return $Business::CyberSource::VERSION },
);

has client_name => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => 'Str',
	default  => sub { return __PACKAGE__ },
);

has client_env => (
	required => 0,
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
