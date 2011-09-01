package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;
use Carp;

# VERSION

use Moose;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
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
		billTo                => $self->_billing_info,
		purchaseTotals => {
			currency         => $self->currency,
			grandTotalAmount => $self->total,
		},
		card => {
			accountNumber   => $self->credit_card,
			expirationMonth => $self->cc_exp_month,
			expirationYear  => $self->cc_exp_year,
		},
		ccAuthService => {
			run => 'true',
		},
	);

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
				Business::CyberSource::Response::Role::Authorization
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				reference_code => $r->{merchantReferenceCode},
				request_token  => $r->{requestToken},
				currency       => $r->{purchaseTotals}->{currency},
				amount         => $r->{ccAuthReply}->{amount},
				avs_code_raw   => $r->{ccAuthReply}->{avsCodeRaw},
				avs_code       => $r->{ccAuthReply}->{avsCode},
				datetime       => $r->{ccAuthReply}->{authorizedDateTime},
				auth_record    => $r->{ccAuthReply}->{authRecord},
				auth_code      => $r->{ccAuthReply}->{authorizationCode},
				processor_response =>
					$r->{ccAuthReply}->{processorResponse},
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

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization Request object

=head1 SYNOPSIS

	use Business::CyberSource::Request::Authorization;

	my $req = Business::CyberSource::Request::Authorization->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
		reference_code => '42',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '100 somewhere st',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111111111111111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});

	my $response = $req->submit;

=head1 DESCRIPTION

This allows you to create an authorization request.

=method new

Instantiates a request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=method submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

=cut
