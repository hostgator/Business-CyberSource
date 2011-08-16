package Business::CyberSource::Response;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}
use Moose::Role;

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has request_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has decision => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has reason_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Int',
);

has currency => (
	is       => 'ro',
	isa      => 'Str',
);

has amount => (
	is       => 'ro',
	isa      => 'Num',
);

has datetime => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: Response Role
