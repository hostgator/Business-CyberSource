package Business::CyberSource::Client;
use 5.010;
use strict;
use warnings;

# VERSION

use Moose;

use Moose::Util::TypeConstraints;

use MooseX::StrictConstructor;

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

	return $self->_response_factory->create( $answer, $dto  );
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

has _response_factory => (
	isa      => 'Business::CyberSource::ResponseFactory',
	is       => 'ro',
	lazy     => 1,
	writer   => undef,
	init_arg => undef,
	default  => sub {
		return use_module('Business::CyberSource::ResponseFactory')->new;
	},
);

has production => (
	isa      => 'Bool',
	reader   => '_production',
	is       => 'ro',
	required => 1,
);

has username => (
	isa      => subtype( NonEmptySimpleStr, where { length $_ <= 30 }),
	reader   => '_username',
	is       => 'ro',
	required => 1,
);

has password => (
	isa      => NonEmptyStr,
	reader   => '_password',
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

	my $client = Business::CyberSource::Request->new({
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

CyberSource Merchant ID

=attr password

CyberSource API KEY

=attr production

Boolean value when true your requests will go to the production server, when
false they will go to the testing server

=cut
