package Business::CyberSource::Response::Role::Authorization;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Response::Role::ProcessorResponse
);

use MooseX::Types::Varchar qw( Varchar );

has auth_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[7],
);

has auth_record => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has avs_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[1],
	documentation => 'AVS results.',
);

has avs_code_raw => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[10],
	documentation => 'AVS result code sent directly from the processor. '
		. 'Returned only if a value is returned by the processor.',
);


1;

# ABSTRACT: CyberSource Authorization Response only attributes
