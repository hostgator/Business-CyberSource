package Business::CyberSource::Request::Role::BillingInfo;
use strict;
use warnings;
use namespace::autoclean;
use Module::Load 'load';

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Types::CyberSource qw( BillTo );

has bill_to => (
	isa         => BillTo,
	remote_name => 'billTo',
	is          => 'ro',
	required    => 1,
	coerce      => 1,
);

1;

# ABSTRACT: Role for requests that require "bill to" information
