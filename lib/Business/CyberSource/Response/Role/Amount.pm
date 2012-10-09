package Business::CyberSource::Response::Role::Amount;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;

has amount => (
	isa         => 'Num',
	remote_name => 'amount',
	is          => 'rw',
	predicate   => 'has_amount',
);

1;
# ABSTRACT: Role for Amount
