package Business::CyberSource::Response::Authorization;
use 5.008;
use strict;
use warnings;
BEGIN {
	# VERSION
}
use Moose;
with 'Business::CyberSource::Response';

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

has auth_datetime => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has processor_response => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has auth_record => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization Response object
