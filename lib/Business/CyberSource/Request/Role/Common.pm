package Business::CyberSource::Request::Role::Common;
use 5.008;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Moose   qw( HashRef );
use MooseX::Types::Varchar qw( Varchar );
use MooseX::Types::URI     qw( Uri     );
use MooseX::SetOnce;

with qw(
	Business::CyberSource
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::Credentials
);

requires 'submit';

use XML::Compile::SOAP::WSS 0.12;

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub _build_request {
	my ( $self, $payload ) = @_;

	my $wss = XML::Compile::SOAP::WSS->new( version => '1.1' );

	my $wsdl = XML::Compile::WSDL11->new( $self->cybs_wsdl->stringify );
	$wsdl->importDefinitions( $self->cybs_xsd->stringify );

	my $call = $wsdl->compileClient('runTransaction');

	my $security = $wss->wsseBasicAuth( $self->username, $self->password );

	my ( $answer, $trace ) = $call->(
		wsse_Security         => $security,
		merchantID            => $self->username,
		merchantReferenceCode => $self->reference_code,
		clientEnvironment     => $self->client_env,
		clientLibrary         => $self->client_name,
		clientLibraryVersion  => $self->client_version,
		purchaseTotals        => $self->_purchase_info,
		%{ $payload },
	);

	$self->trace( $trace );

	if ( $answer->{Fault} ) {
		croak 'SOAP Fault: ' . $answer->{Fault}->{faultstring};
	}

	my $r = $answer->{result};

	return $r;
}

sub _handle_decision {
	my ( $self, $r ) = @_;

	my $res;
	if ( $r->{decision} eq 'REJECT' ) {
		$res = Business::CyberSource::Response->new({
				decision      => $r->{decision},
				request_id    => $r->{requestID},
				reason_code   => "$r->{reasonCode}",
				request_token => $r->{requestToken},
			})
			;
	}
	else {
		croak 'decision defined, but not sane: ' . $r->{decision};
	}

	return $res;
}

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[50],
);

has trace => (
	is     => 'rw',
	isa    => 'XML::Compile::SOAP::Trace',
);

1;

# ABSTRACT: Request Role
