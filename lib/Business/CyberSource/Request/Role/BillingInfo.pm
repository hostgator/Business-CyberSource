package Business::CyberSource::Request::Role::BillingInfo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;
use MooseX::Aliases;

use MooseX::Types::CyberSource qw( BillTo );

has bill_to => (
	isa         => BillTo,
	remote_name => 'billTo',
	alias       => 'billing_info',
	is          => 'ro',
	required    => 1,
	coerce      => 1,
);
	
1;

# ABSTRACT: Role for requests that require "bill to" information
