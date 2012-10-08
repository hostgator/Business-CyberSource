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

sub has_request_specific_reason_code {
	my $self = shift;

	load 'Carp';
	Carp::carp 'DEPRECATED: please call has_reason_code';

	return $self->has_reason_code
}

sub request_specific_reason_code {
	my $self = shift;

	load 'Carp';
	Carp::carp 'DEPRECATED: please call reason_code';

	return $self->reason_code
}

1;
# ABSTRACT: Role for ReasonCode

=for Pod::Coverage request_specific_reason_code has_request_specific_reason_code
