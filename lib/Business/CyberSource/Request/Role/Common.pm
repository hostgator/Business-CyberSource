package Business::CyberSource::Request::Role::Common;
use 5.008;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

# VERSION

use Moose::Role;
use MooseX::Types::Moose   qw( HashRef Str );
use MooseX::Types::URI     qw( Uri     );
use MooseX::Types::Path::Class qw( File Dir );
use MooseX::SetOnce 0.200001;

use Path::Class;
use File::ShareDir qw( dist_file );
use Config;

with qw(
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::Credentials
	Business::CyberSource::Role::MerchantReferenceCode
);

requires 'submit';

use XML::Compile::SOAP::WSS 0.12;

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub _build_request {
	my $self = shift;

	my $wss = XML::Compile::SOAP::WSS->new( version => '1.1' );

	my $wsdl = XML::Compile::WSDL11->new( $self->cybs_wsdl->stringify );
	$wsdl->importDefinitions( $self->cybs_xsd->stringify );

	my $call = $wsdl->compileClient('runTransaction');

	my $security = $wss->wsseBasicAuth( $self->username, $self->password );

	my ( $answer, $trace ) = $call->(
		wsse_Security         => $security,
		merchantID            => $self->username,
		clientEnvironment     => $self->client_env,
		clientLibrary         => $self->client_name,
		clientLibraryVersion  => $self->client_version,
		merchantReferenceCode => $self->reference_code,
		%{ $self->_request_data },
	);

	$self->_trace( $trace );

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
		$res
			= Business::CyberSource::Response
			->new({
				decision      => $r->{decision},
				request_id    => $r->{requestID},
				reason_code   => "$r->{reasonCode}",
				request_token => $r->{requestToken},
			});
	}
	else {
		croak 'decision defined, but not sane: ' . $r->{decision};
	}

	return $res;
}

sub BUILD { ## no critic qw( Subroutines::RequireFinalReturn )
	my $self = shift;

	if ( $self->does('Business::CyberSource::Request::Role::PurchaseInfo' ) ) {
		unless ( $self->has_items or $self->has_total ) {
			croak 'you must define either items or total';
		}
	}

	if ( $self->does('Business::CyberSource::Request::Role::BillingInfo' ) ) {
		if ( $self->country eq 'US' or $self->country eq 'CA' ) {
			croak 'zip code is required for US or Canada'
				unless $self->has_zip;
		}
	}
}


has client_version => (
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

has client_name => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub { return 'Business::CyberSource' },
	documentation => 'provided by the library',
);

has client_env => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub {
		return "Perl $Config{version} $Config{osname} $Config{osvers} $Config{archname}";
	},
	documentation => 'provided by the library',
);

has cybs_api_version => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => Str,
	default  => '1.62',
	documentation => 'provided by the library',
);

has cybs_wsdl => (
	required  => 0,
	lazy      => 1,
	is        => 'ro',
	isa       => File,
	builder   => '_build_cybs_wsdl',
	documentation => 'provided by the library',
);

has cybs_xsd => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => File,
	builder  => '_build_cybs_xsd',
	documentation => 'provided by the library',
);

sub _build_cybs_wsdl {
		my $self = shift;

		my $dir = $self->production ? 'production' : 'test';

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

		my $dir = $self->production ? 'production' : 'test';

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

has comments => (
	is       => 'ro',
	isa      => Str,
	trigger  => sub {
		my $self = shift;
		$self->_request_data->{comments} = $self->comments;
	},
);

has trace => (
	is       => 'rw',
	isa      => 'XML::Compile::SOAP::Trace',
	traits   => [ 'SetOnce' ],
	init_arg => undef,
	writer   => '_trace',
);

has _request_data => (
	required => 1,
	init_arg => undef,
	is       => 'rw',
	isa      => HashRef,
	default => sub { { } },
);

1;

# ABSTRACT: Request Role

=for Pod::Coverage BUILD
=cut
