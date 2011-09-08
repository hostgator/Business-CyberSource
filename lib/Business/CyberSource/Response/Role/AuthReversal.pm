package Business::CyberSource::Response::Role::AuthReversal;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Varchar qw( Varchar );

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
