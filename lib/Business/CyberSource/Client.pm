package Business::CyberSource::Client;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004007'; # VERSION

use Moose;

use Moose::Util::TypeConstraints;

use MooseX::StrictConstructor;

use MooseX::Types::Moose   qw( HashRef Str );
use MooseX::Types::Path::Class qw( File Dir );
use MooseX::Types::Common::String qw( NonEmptyStr NonEmptySimpleStr );

use Carp qw( carp );
use File::ShareDir qw( dist_file );
use Config;
use Module::Runtime qw( use_module );

use XML::Compile::SOAP::WSS 0.12;
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub run_transaction {
	my ( $self, $dto ) = @_;

	confess 'Not a Business::CyberSource::Request'
		unless defined $dto
			&& blessed $dto
			&& $dto->isa('Business::CyberSource::Request')
			;

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

	if ( $self->_debug ) {
		carp "\n> " . $trace->request->as_string;
		carp "\n< " . $trace->response->as_string;
	}

	$dto->_trace( $trace );

	if ( $answer->{Fault} ) {
		confess 'SOAP Fault: ' . $answer->{Fault}->{faultstring};
	}

	return $self->_response_factory->create( $answer, $dto  );
}

sub _build_cybs_wsdl {
	my $self = shift;

	my $dir = $self->_production ? 'production' : 'test';

	return use_module('Path::Class::File')->new(
			dist_file(
				'Business-CyberSource',
				$dir
				. '/'
				. 'CyberSourceTransaction_'
				. $self->cybs_api_version
				. '.wsdl'
			)
		);
}

sub _build_cybs_xsd {
	my $self = shift;

	my $dir = $self->_production ? 'production' : 'test';

	return use_module('Path::Class::File')->new(
			dist_file(
				'Business-CyberSource',
				$dir
				. '/'
				. 'CyberSourceTransaction_'
				. $self->cybs_api_version
				. '.xsd'
			)
		);
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

has debug => (
	isa     => 'Bool',
	reader  => '_debug',
	is      => 'ro',
	lazy    => 1,
	default => sub {
		return $ENV{PERL_BUSINESS_CYBERSOURCE_DEBUG} ? 1 : 0;
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
	default  => '1.71',
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


__END__
=pod

=head1 NAME

Business::CyberSource::Client - User Agent Responsible for transmitting the Response

=head1 VERSION

version 0.004007

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

=head1 METHODS

=head2 run_transaction

	my $response = $client->run_transaction( $request );

Takes a L<Business::CyberSource::Request> subclass as a parameter and returns
a L<Business::CyberSource::Response>

=head1 ATTRIBUTES

=head2 username

CyberSource Merchant ID

=head2 password

CyberSource API KEY

=head2 production

Boolean value when true your requests will go to the production server, when
false they will go to the testing server

=head2 debug

Boolean value that causes the HTTP request/response to be output to STDOUT
when a transaction is run. defaults to value of the environment variable
C<PERL_BUSINESS_CYBERSOURCE_DEBUG>

=head2 name

Client Name defaults to L<Business::CyberSource>

=head2 version

Client Version defaults to the version of this library

=head2 env

defaults to specific parts of perl's config hash

=head2 cybs_wsdl

A L<Path::Class::File> to the WSDL definition file

=head2 cybs_xsd

A L<Path::Class::File> to the XSD definition file

=head2 cybs_api_version

CyberSource API version, currently 1.71

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

