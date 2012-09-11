package Business::CyberSource::Client;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;

use Moose::Util::TypeConstraints;

use MooseX::StrictConstructor;

use MooseX::Types::Moose   qw( HashRef Str );
use MooseX::Types::Path::Class qw( File Dir );
use MooseX::Types::Common::String qw( NonEmptyStr NonEmptySimpleStr );

use Config;
use Class::Load 0.20 qw( load_class );
use Module::Load     qw( load );

use XML::Compile::SOAP::WSS 0.12;
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub _client {
	my $self = shift;

	my $wss = XML::Compile::SOAP::WSS->new( version => '1.1' );

	my $wsdl = XML::Compile::WSDL11->new( $self->cybs_wsdl->stringify );
	$wsdl->importDefinitions( $self->cybs_xsd->stringify );

	my $call = $wsdl->compileClient('runTransaction');

	my $security = $wss->wsseBasicAuth( $self->_username, $self->_password );

	return [ $call, $security ];
}

sub run_transaction {
	my ( $self, $dto ) = @_;

	confess 'Not a Business::CyberSource::Request'
		unless defined $dto
			&& blessed $dto
			&& $dto->isa('Business::CyberSource::Request')
			;

	if ( $self->has_rules && ! $self->rules_is_empty ) {
		my $answer;
		RULE: foreach my $rule ( @{ $self->_rules } ) {
			$answer = $rule->run( $dto );
			last RULE if defined $answer;
		}
		return $self->_response_factory->create( $dto, $answer )
			if defined $answer
			;
	}

	state $call_security = $self->_client;

	my ( $call, $security ) = @{ $call_security };

	my %request = (
		wsse_Security         => $security,
		merchantID            => $self->_username,
		clientEnvironment     => $self->env,
		clientLibrary         => $self->name,
		clientLibraryVersion  => $self->version,
		merchantReferenceCode => $dto->reference_code,
		%{ $dto->serialize },
	);

	if ( $self->debug ) {
		load 'Carp';
		load $self->_dumper_package, 'Dumper';

		Carp::carp( 'REQUEST HASH: ' . Dumper( \%request ) );
	}

	my ( $answer, $trace ) = $call->( %request );

	if ( $self->debug ) {
		Carp::carp "\n> " . $trace->request->as_string;
		Carp::carp "\n< " . $trace->response->as_string;
	}

	$dto->_trace( $trace );

	if ( $answer->{Fault} ) {
		confess 'SOAP Fault: ' . $answer->{Fault}->{faultstring};
	}

	return $self->_response_factory->create( $dto, $answer );
}

sub _build_cybs_wsdl {
	my $self = shift;

	my $dir = $self->_production ? 'production' : 'test';

	load 'File::ShareDir::ProjectDistDir', 'dist_file';
	return load_class('Path::Class::File')->new(
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

	load 'File::ShareDir::ProjectDistDir', 'dist_file';
	return load_class('Path::Class::File')->new(
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

sub _build__rules {
	my $self = shift;

	return [] if ! $self->has_rules || $self->rules_is_empty;

	my @rules
		= map {
			$self->_rule_factory->create( $_, { client => $self } ) if defined $_
		} $self->list_rules;

	return \@rules;
};

has _response_factory => (
	isa      => 'Object',
	is       => 'ro',
	lazy     => 1,
	default  => sub {
		return load_class('Business::CyberSource::Factory::Response')->new;
	},
);

has _rule_factory => (
	isa      => 'Object',
	is       => 'ro',
	lazy     => 1,
	default  => sub {
		return load_class('Business::CyberSource::Factory::Rule')->new;
	},
);

has rules => (
	isa       => 'ArrayRef[Str]',
	predicate => 'has_rules',
	traits    => ['Array'],
	is        => 'ro',
	reader    => undef,
	default   => sub { [qw( ExpiredCard RequestIDisZero )] },
	handles   => {
		list_rules     => 'elements',
		rules_is_empty => 'is_empty',
	},
);

has _rules => (
	isa        => 'ArrayRef[Object]',
	is         => 'ro',
	lazy_build => 1,
	traits     => ['Array'],
);

has debug => (
	isa     => 'Bool',
	is      => 'ro',
	lazy    => 1,
	default => sub {
		return $ENV{PERL_BUSINESS_CYBERSOURCE_DEBUG} ? 1 : 0;
	},
);

has dumper_package => (
	isa     => NonEmptySimpleStr,
	reader  => '_dumper_package',
	is      => 'ro',
	lazy    => 1,
	default => sub { return 'Data::Dumper'; },
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

=attr debug

Boolean value that causes the HTTP request/response to be output to STDOUT
when a transaction is run. defaults to value of the environment variable
C<PERL_BUSINESS_CYBERSOURCE_DEBUG>

=attr rules

ArrayRef of L<Rule Names|Business::CyberSource::Rule>. Rules names are modules
prefixed by L<Business::CyberSource::Rule>. By default both
L<Business::CyberSource::Rule::ExpiredCard> and
L<Business::CyberSource::Rule::RequestIDisZero> are included. If you decide to
add more rules remember to add C<qw( ExpiredCard RequestIDisZero )> to the
new ArrayRef ( if you want them ).

=attr dumper_package

Package name for dumping the request hash if doing a L<debug|/"debug">. Package
must have a C<Dumper> function.

=attr name

Client Name defaults to L<Business::CyberSource>

=attr version

Client Version defaults to the version of this library

=attr env

defaults to specific parts of perl's config hash

=attr cybs_wsdl

A L<Path::Class::File> to the WSDL definition file

=attr cybs_xsd

A L<Path::Class::File> to the XSD definition file

=attr cybs_api_version

CyberSource API version, currently 1.71

=cut
