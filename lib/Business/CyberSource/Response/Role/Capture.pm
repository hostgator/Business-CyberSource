package Business::CyberSource::Response::Role::Capture;
use 5.008;
use strict;
use warnings;
BEGIN {
	# VERSION
}
use Moose::Role;

has reconciliation_id => (
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: CyberSource Capture Response Object
