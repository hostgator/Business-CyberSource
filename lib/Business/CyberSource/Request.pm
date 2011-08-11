package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}
use Moose::Role;
with 'Business::CyberSource';
use SOAP::Data::Builder;

has _sdbo => (
	documentation => 'SOAP::Data::Builder Object',
	required => 1,
	lazy     => 1,
	is       => 'ro',
	isa      => 'SOAP::Data::Builder',
	builder  => '_build_sdbo',
);

has username => (
	documentation => 'your merchantID',
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has password => (
	documentation => 'your SOAP transaction key',
	required => 1,
	is       => 'ro',
	isa      => 'Str', # actually I wonder if I can validate this more
);

1;

# ABSTRACT: Request Role
