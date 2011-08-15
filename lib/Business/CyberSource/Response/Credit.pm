package Business::CyberSource::Response::Credit;
use 5.008;
use strict;
use warnings;
BEGIN {
	# VERSION
}
use Moose;
with 'Business::CyberSource::Response';

has reconciliation_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

1;

# ABSTRACT: CyberSource Credit Response object
