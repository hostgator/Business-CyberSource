package Business::CyberSource::Request::Role::BillingInfo;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::RemoteHelper;

has billing_info => (
	isa         => 'Business::CyberSource::RequestPart::BillTo',
	remote_name => 'billTo',
	is          => 'ro',
	required    => 1,
);
	
1;

# ABSTRACT: Role for requests that require "bill to" information
