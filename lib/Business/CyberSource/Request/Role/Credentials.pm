package Business::CyberSource::Request::Role::Credentials;
use 5.008;
use strict;
use warnings;

# VERSION

use Moose::Role;
use namespace::autoclean;
use MooseX::Types::Varchar        qw( Varchar  );
use MooseX::Types::Moose          qw( Bool Str );
use MooseX::Types::Common::String qw( NonEmptyStr );

has production => (
	documentation => '0: test server. 1: production server',
	required => 1,
	is       => 'ro',
	isa      => Bool,
);

has username => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[30],
	documentation => 'Your CyberSource merchant ID. Use the same merchantID '
		. 'for evaluation, testing, and production',
);

has password => (
	documentation => 'your SOAP transaction key',
	required => 1,
	is       => 'ro',
	isa      => NonEmptyStr,
);

1;

# ABSTRACT: CyberSource login credentials
