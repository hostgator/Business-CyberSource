package Business::CyberSource::Request::Role::Credentials;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Common::String qw( NonEmptyStr NonEmptySimpleStr );

use Moose::Util::TypeConstraints;

has production => (
	isa      => 'Bool',
	is       => 'ro',
);

has username => (
	isa      => subtype( NonEmptySimpleStr, where { length $_ <= 30 }),
	is       => 'ro',
);

has password => (
	isa      => NonEmptyStr,
	is       => 'ro',
);

1;

# ABSTRACT: CyberSource login credentials

=attr production

0: test server. 1: production server

=attr username

Your CyberSource merchant ID. Use the same merchantID for evaluation, testing,
and production

=attr password

your SOAP transaction key

=cut
