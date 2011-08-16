package Business::CyberSource::Response::Role::Authorization;
use 5.008;
use strict;
use warnings;
BEGIN {
	# VERSION
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
