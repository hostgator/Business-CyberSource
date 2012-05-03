package Business::CyberSource::Client;
use 5.010;
use strict;
use warnings;

# VERSION

use Moose;

use Moose::Util::TypeConstraints;

use MooseX::StrictConstructor;
use MooseX::Aliases;

use MooseX::Types::Moose   qw( HashRef Str );
use MooseX::Types::Path::Class qw( File Dir );
use MooseX::Types::Common::String qw( NonEmptyStr NonEmptySimpleStr );


use Path::Class;
use File::ShareDir qw( dist_file );
use Config;
use Module::Runtime qw( use_module );

use XML::Compile::SOAP::WSS 0.12;
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub run_transaction {
	my ( $self, $dto ) = @_;

	my $wss = XML::Compile::SOAP::WSS->new( version => '1.1' );

	my $wsdl = XML::Compile::WSDL11->new( $self->cybs_wsdl->stringify );
	$wsdl->importDefinitions( $self->cybs_xsd->stringify );

	my $call = $wsdl->compileClient('runTransaction');

	my $security = $wss->wsseBasicAuth( $self->_username, $self->_password );

	my ( $answer, $trace ) = $call->(
		wsse_Security         => $security,
		merchantID            => $self->_username,
		clientEnvironment     => $self->env,
		clientLibrary         => $self->name,
		clientLibraryVersion  => $self->version,
		merchantReferenceCode => $dto->reference_code,
		%{ $dto->serialize },
	);

	$dto->_trace( $trace );

	if ( $answer->{Fault} ) {
		confess 'SOAP Fault: ' . $answer->{Fault}->{faultstring};
	}

	my $r = $answer->{result};

	my $res;
	if ( $r->{decision} eq 'ACCEPT' or $r->{decision} eq 'REJECT' ) {
		my $prefix      = 'Business::CyberSource::';
		my $req_prefix  = $prefix . 'Request::';
		my $res_prefix  = $prefix . 'Response::';
		my $role_prefix = $res_prefix . 'Role::';

		my @traits;
		my $e = { };

		if ( $r->{decision} eq 'ACCEPT' ) {
			push( @traits, $role_prefix .'Accept' );

			$e->{currency} = $r->{purchaseTotals}{currency};
			$e->{reference_code} = $r->{merchantReferenceCode};

			given ( $dto ) {
				when ( $_->isa( $req_prefix . 'Authorization') ) {
					$e->{amount        } = $r->{ccAuthReply}->{amount};
					$e->{datetime      } = $r->{ccAuthReply}{authorizedDateTime};
					$e->{request_specific_reason_code}
						= "$r->{ccAuthReply}->{reasonCode}";
					continue;
				}
				when ( $_->isa( $req_prefix . 'Capture')
					or $_->isa( $req_prefix . 'Sale' )
					) {
					push( @traits, $role_prefix . 'ReconciliationID');

					$e->{datetime} = $r->{ccCaptureReply}->{requestDateTime};
					$e->{amount}   = $r->{ccCaptureReply}->{amount};
					$e->{reconciliation_id}
						= $r->{ccCaptureReply}->{reconciliationID};
					$e->{request_specific_reason_code}
						= "$r->{ccCaptureReply}->{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'Credit') ) {
					push( @traits, $role_prefix . 'ReconciliationID');

					$e->{datetime} = $r->{ccCreditReply}->{requestDateTime};
					$e->{amount}   = $r->{ccCreditReply}->{amount};
					$e->{reconciliation_id} = $r->{ccCreditReply}->{reconciliationID};
					$e->{request_specific_reason_code}
						= "$r->{ccCreditReply}->{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'DCC') ) {
					push ( @traits, $role_prefix . 'DCC' );
					$e->{exchange_rate} = $r->{purchaseTotals}{exchangeRate};
					$e->{exchange_rate_timestamp}
						= $r->{purchaseTotals}{exchangeRateTimeStamp};
					$e->{foreign_currency}
						= $r->{purchaseTotals}{foreignCurrency};
					$e->{foreign_amount} = $r->{purchaseTotals}{foreignAmount};
					$e->{dcc_supported}
						= $r->{ccDCCReply}{dccSupported} eq 'TRUE' ? 1 : 0;
					$e->{valid_hours} = $r->{ccDCCReply}{validHours};
					$e->{margin_rate_percentage}
						= $r->{ccDCCReply}{marginRatePercentage};
					$e->{request_specific_reason_code}
						= "$r->{ccDCCReply}{reasonCode}";
				}
				when ( $_->isa( $req_prefix . 'AuthReversal' ) ) {
					push ( @traits, $role_prefix . 'ProcessorResponse' );

					$e->{datetime} = $r->{ccAuthReversalReply}->{requestDateTime};
					$e->{amount}   = $r->{ccAuthReversalReply}->{amount};

					$e->{request_specific_reason_code}
						= "$r->{ccAuthReversalReply}->{reasonCode}";
					$e->{processor_response}
						= $r->{ccAuthReversalReply}->{processorResponse};
				}
			}
		}

		if ( $dto->isa( $req_prefix . 'Authorization') ) {
				push( @traits, $role_prefix . 'Authorization' );
					if ( $r->{ccAuthReply} ) {

						$e->{auth_code}
							=  $r->{ccAuthReply}{authorizationCode }
							if $r->{ccAuthReply}{authorizationCode }
							;


						if ( $r->{ccAuthReply}{cvCode}
							&& $r->{ccAuthReply}{cvCodeRaw}
							) {
							$e->{cv_code}     = $r->{ccAuthReply}{cvCode};
							$e->{cv_code_raw} = $r->{ccAuthReply}{cvCodeRaw};
						}

						if ( $r->{ccAuthReply}{avsCode}
							&& $r->{ccAuthReply}{avsCodeRaw}
							) {
							$e->{avs_code}     = $r->{ccAuthReply}{avsCode};
							$e->{avs_code_raw} = $r->{ccAuthReply}{avsCodeRaw};
						}

						if ( $r->{ccAuthReply}{processorResponse} ) {
							$e->{processor_response}
								= $r->{ccAuthReply}{processorResponse}
								;
						}

						if ( $r->{ccAuthReply}->{authRecord} ) {
							$e->{auth_record} = $r->{ccAuthReply}->{authRecord};
						}
					}
		}

		$res
			= use_module('Business::CyberSource::Response')
			->with_traits( @traits )
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				request_token  => $r->{requestToken},
			%{$e},
			})
			;
	}
	else {
		confess 'decision defined, but not sane: ' . $r->{decision};
	}

	return $res;
}

sub _build_cybs_wsdl {
		my $self = shift;

		my $dir = $self->_production ? 'production' : 'test';

		my $file
			= Path::Class::File->new(
				dist_file(
					'Business-CyberSource',
					$dir
					. '/'
					. 'CyberSourceTransaction_'
					. $self->cybs_api_version
					. '.wsdl'
				)
			);

		return $file;
}

sub _build_cybs_xsd {
		my $self = shift;

		my $dir = $self->_production ? 'production' : 'test';

		my $file
			= Path::Class::File->new(
				dist_file(
					'Business-CyberSource',
					$dir
					. '/'
					. 'CyberSourceTransaction_'
					. $self->cybs_api_version
					. '.xsd'
				)
			);

		return $file;
}

has production => (
	isa      => 'Bool',
	reader   => '_production',
	writer   => undef,
	is       => 'ro',
	required => 1,
);

has username => (
	isa      => subtype( NonEmptySimpleStr, where { length $_ <= 30 }),
	reader   => '_username',
	writer   => undef,
	is       => 'ro',
	required => 1,
);

has password => (
	isa      => NonEmptyStr,
	reader   => '_password',
	writer   => undef,
	is       => 'ro',
	required => 1,
);

has version => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub {
		my $version
			= $Business::CyberSource::VERSION ? $Business::CyberSource::VERSION
			                                  : '0'
			;
		return $version;
	},
);

has name => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub { return 'Business::CyberSource' },
);

has env => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub {
		return "Perl $Config{version} $Config{osname} $Config{osvers} $Config{archname}";
	},
);

has cybs_api_version => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => Str,
	default  => '1.62',
);

has cybs_wsdl => (
	required  => 0,
	lazy      => 1,
	is        => 'ro',
	isa       => File,
	builder   => '_build_cybs_wsdl',
);

has cybs_xsd => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => File,
	builder  => '_build_cybs_xsd',
);


__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: User Agent Responsible for transmitting the Response

=head1 SYNOPSIS

	use Business::CyberSource::Client;

	my $request = 'Some Business::CyberSource::Request Object';

	my $client = Business::CyberSource:Request->new({
		username   => 'Merchant ID',
		password   => 'API KEY',
		production => 0,
	});

	my $response = $client->run_transaction( $request );

=head1 DESCRIPTION

A service object that is meant to provide a way to run the requested
transactions.

=method run_transaction

	my $response = $client->run_transaction( $request );

Takes a L<Business::CyberSource::Request> subclass as a parameter and returns
a L<Business::CyberSource::Response>

=attr username

CyberSource MerchantID

=attr password

CyberSource API KEY

=attr production

Boolean value when true your requests will go to the production server, when
false they will go to the testing server

=cut
