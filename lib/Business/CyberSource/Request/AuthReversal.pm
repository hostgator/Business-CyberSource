package Business::CyberSource::Request::AuthReversal;
use 5.008;
use strict;
use warnings;
use Carp;

# VERSION

use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
);

use Business::CyberSource::Response;

use XML::Compile::SOAP::WSS 0.12;

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub submit {
	my $self = shift;

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
		purchaseTotals => {
			currency         => $self->currency,
			grandTotalAmount => $self->total,
		},
		ccAuthReversalService => {
			run => 'true',
			authRequestID => $self->request_id,
		},
	);

	$self->trace( $trace );

	if ( $answer->{Fault} ) {
		croak 'SOAP Fault: ' . $answer->{Fault}->{faultstring};
	}

	my $r = $answer->{result};

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::AuthReversal
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				reference_code => $r->{merchantReferenceCode},
				currency       => $r->{purchaseTotals}->{currency},
				datetime       => $r->{ccAuthReversalReply}->{requestDateTime},
				amount         => $r->{ccAuthReversalReply}->{amount},
				reversal_reason_code =>
					"$r->{ccAuthReversalReply}->{reasonCode}",
				processor_response =>
					$r->{ccAuthReversalReply}->{processorResponse},
			})
			;
	}
	elsif ( $r->{decision} eq 'REJECT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Reject
			})
			->new({
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

has request_id => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Reverse Authorization request object

=head1 SYNOPSIS

	my $req = Business::CyberSource::Request::AuthReversal->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
		reference_code => 'orignal authorization merchant reference code',
		request_id     => 'request id returned in original authorization response',
		total          => 5.00, # same as original authorization amount
		currency       => 'USD', # same as original currency
	});

	my $res = $req->submit;

=head1 DESCRIPTION

This allows you to reverse an authorization request.

=method new

Instantiates a authorization reversal request object, see
L<the attributes listed below|/ATTRIBUTES> for which ones are required and
which are optional.

=method submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

=cut
