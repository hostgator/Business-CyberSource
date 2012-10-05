package Business::CyberSource::Response::Role::ReasonCode;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::Common::String 0.001005 qw( NumericCode );

has reason_code => (
	isa         => NumericCode,
	remote_name => 'reasonCode',
	required    => 1,
	is          => 'ro',
);

1;
# ABSTRACT: Role for ReasonCode
