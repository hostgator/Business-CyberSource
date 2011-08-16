package Business::CyberSource::Response;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}
use Moose::Role;

has request_token => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: role for handling rejected transactions
