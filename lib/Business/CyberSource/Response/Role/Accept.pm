package Business::CyberSource::Response;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
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
