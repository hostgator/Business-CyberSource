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
use MooseX::Types::Moose   qw( Str     );

has auth_code => (
	required => 0,
	is       => 'ro',
	isa      => Varchar[7],
);

has auth_record => (
	required => 0,
	is       => 'ro',
	isa      => Str,
);

1;

# ABSTRACT: CyberSource Authorization Response only attributes
