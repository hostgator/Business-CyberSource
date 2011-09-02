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

sub _common_req_hash {
	my $self = shift;

	my $i = {
		merchantID            => $self->username,
		merchantReferenceCode => $self->reference_code,
		clientEnvironment     => $self->client_env,
		clientLibrary         => $self->client_name,
		clientLibraryVersion  => $self->client_version,
		purchaseTotals        => $self->_purchase_info,
	};
	return $i;
}

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
);

has trace => (
	is  => 'rw',
	isa => 'XML::Compile::SOAP::Trace',
);

1;

# ABSTRACT: Request Role
