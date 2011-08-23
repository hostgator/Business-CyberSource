package Business::CyberSource::Request::Role::Credentials;
use 5.008;
use strict;
use warnings;

# VERSION

use Moose::Role;
use namespace::autoclean;

has production => (
	required => 1,
	is       => 'ro',
	isa      => 'Bool',
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
