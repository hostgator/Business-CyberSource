package Business::CyberSource::Request::Role::TaxService;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::SetOnce;
use MooseX::RemoteHelper;

use MooseX::Types::CyberSource qw( TaxService );

has tax_service => (
	isa         => TaxService,
	remote_name => 'taxService',
	is          => 'rw',
	traits      => ['SetOnce'],
	coerce      => 1,
);

1;

# ABSTRACT: Tax Service

=attr tax_service

L<Business::CyberSource::RequestPart::Service::Tax> you can pass an empty hash
ref to the constructor, just to get the service to run.

=cut
