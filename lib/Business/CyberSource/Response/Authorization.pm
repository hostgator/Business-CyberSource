package Business::CyberSource::Response::Authorization;
use 5.008;
use strict;
use warnings;
BEGIN {
	# VERSION
}
use Moose;

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

has request_token => (
#	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has currency => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has amount => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
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
