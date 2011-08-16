package Business::CyberSource::Response::Role::AuthReversal;
use 5.008;
use strict;
use warnings;
BEGIN {
	# VERSION
}
use Moose::Role;

has processor_response => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has reversal_reason_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
);

1;

# ABSTRACT: Role for Authorization Reversal responses
