package Business::CyberSource::Request::Role::Common;
use 5.008;
use strict;
use warnings;
use Carp;
our @CARP_NOT = qw( SOAP::Lite );

# VERSION

use Moose::Role;
use MooseX::Types::Moose   qw( HashRef );
use MooseX::Types::Varchar qw( Varchar );
use MooseX::Types::URI     qw( Uri     );

with qw(
	Business::CyberSource
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::Credentials
);

requires 'submit';

has server => (
	required => 1,
	lazy     => 1,
	coerce   => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Uri,
	builder => '_build_server',
);

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
);

has _soap_request_data => (
	lazy     => 1,
	is       => 'rw',
	isa      => HashRef,
	builder  => '_build_soap_request_data',
);

sub _build_soap_request {
	my $self = shift;

	my $wsdl = XML::Compile::WSDL11->new( $self->cybs_wsdl );

	$wsdl->importDefinitions( $self->cybs_xsd );

	my $call = $wsdl->compileClient('runTransaction');

	return $call
}

1;

# ABSTRACT: Request Role
