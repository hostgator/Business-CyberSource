package Business::CyberSource::Response::Role::ReasonCode;
use strict;
use warnings;
use namespace::autoclean;
use Module::Load qw( load );

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::Common::String 0.001005 qw( NumericCode );

has reason_code => (
	isa         => NumericCode,
	remote_name => 'reasonCode',
	required    => 1,
	is          => 'ro',
	predicate   => 'has_reason_code',
);

1;
# ABSTRACT: Role for ReasonCode
