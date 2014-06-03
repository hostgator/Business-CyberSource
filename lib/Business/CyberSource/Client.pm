package Business::CyberSource::Client;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
with 'MooseY::RemoteHelper::Role::Client';

use Moose::Util::TypeConstraints;

use MooseX::StrictConstructor;

use MooseX::Types::Moose   qw( HashRef Str );
use MooseX::Types::Path::Class qw( File Dir );
use MooseX::Types::Common::String qw( NonEmptyStr NonEmptySimpleStr );

use Config;
use Module::Runtime  qw( use_module );
use Module::Load     qw( load       );

use XML::Compile::SOAP::WSS 1.04;
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

our @CARP_NOT = ( __PACKAGE__, qw( Class::MOP::Method::Wrapped ) );

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

	my $args = $class->$orig( @_ );

	if ( exists $args->{username} ) {
		warnings::warnif('deprecated',
			'`username` is deprecated, use `user` instead'
		);

		$args->{user} = delete $args->{username};
	}

	if ( exists $args->{password} ) {
		warnings::warnif('deprecated',
			'`password` is deprecated, use `pass` instead'
		);

		$args->{pass} = delete $args->{password};
	}

	if ( exists $args->{production} ) {
		warnings::warnif('deprecated',
			'`production` is deprecated, use `test` instead'
		);

		$args->{test} = delete( $args->{production} ) ? 0 : 1;
	}

	return $args;
};

sub run_transaction {
	my ( $self, $request ) = @_;

	warnings::warnif('deprecated',
		'run_transaction is deprecated, use submit instead'
	);

	return $self->submit( $request );
}

sub submit {
	my ( $self, $request ) = @_;

	confess 'request undefined'         unless defined $request;
	confess 'request not an object'     unless blessed $request;
	confess 'request can not serialize' unless $request->can('serialize');

	if ( $self->has_rules && ! $self->rules_is_empty ) {
		my $result;
		RULE: foreach my $rule ( @{ $self->_rules } ) {
			$result = $rule->run( $request );
			last RULE if defined $result;
		}
		return $self->_response_factory->create( $result, $request )
			if defined $result
			;
	}

	my %request = (
		merchantID            => $self->user,
		clientEnvironment     => $self->env,
		clientLibrary         => $self->name,
		clientLibraryVersion  => $self->version,
		%{ $request->serialize },
	);

	if ( $self->debug >= 1 ) {
		load 'Carp';
		load 'Data::Printer', alias => 'Dumper';

		Carp::carp( 'REQUEST HASH: ' . Dumper( \%request ) );
	}

	my ( $answer, $trace ) = $self->_soap_client->( %request );

	if ( $self->debug >= 2 ) {
		Carp::carp "\n> " . $trace->request->as_string;
		Carp::carp "\n< " . $trace->response->as_string;
	}

	$request->_trace( $trace ) if $request->can('_trace');

	if ( $answer->{Fault} ) {
		confess 'SOAP Fault: ' . $answer->{Fault}->{faultstring};
	}

	if ( $self->debug >= 1 ) {
		Carp::carp( 'RESPONSE HASH: ' . Dumper( $answer->{result} ) );
	}

	return $self->_response_factory->create( $answer->{result}, $request );
}

sub _build_soap_client {
	my $self = shift;
	# order in this subroutine matters changing it may break stuff

	my $wss = XML::Compile::SOAP::WSS->new( version => '1.1' );

	my $wsdl = XML::Compile::WSDL11->new( $self->cybs_wsdl->stringify );
	$wsdl->importDefinitions( $self->cybs_xsd->stringify );

	$wss->basicAuth(
		username => $self->user,
		password => $self->pass,
	);

	my $call = $wsdl->compileClient('runTransaction');

	return $call;
}

sub _build_cybs_wsdl {
	my $self = shift;

	my $dir = $self->test ? 'test' : 'production';

	load 'File::ShareDir::ProjectDistDir', 'dist_file';
	return use_module('Path::Class::File')->new(
			dist_file(
				'Business-CyberSource',
				$dir
				. '/'
				. 'CyberSourceTransaction_'
				. $self->_version_for_filename
				. '.wsdl'
			)
		);
}

sub _build_cybs_xsd {
	my $self = shift;

	my $dir = $self->test ? 'test' : 'production';

	load 'File::ShareDir::ProjectDistDir', 'dist_file';
	return use_module('Path::Class::File')->new(
			dist_file(
				'Business-CyberSource',
				$dir
				. '/'
				. 'CyberSourceTransaction_'
				. $self->_version_for_filename
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
}

sub _version_for_filename {
	my $self = shift;
	my $version = $self->cybs_api_version;
	$version =~ s/\./_/xms;
	return $version;
}

has _soap_client => (
	isa      => 'CodeRef',
	is       => 'ro',
	lazy     => 1,
	init_arg => undef,
	builder  => '_build_soap_client',
);

has _response_factory => (
	isa      => 'Object',
	is       => 'ro',
	lazy     => 1,
	default  => sub {
		return
			use_module('Business::CyberSource::Factory::Response')
			->new;
	},
);

has _rule_factory => (
	isa      => 'Object',
	is       => 'ro',
	lazy     => 1,
	default  => sub {
		return use_module('Business::CyberSource::Factory::Rule')->new;
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
		user => 'Merchant ID',
		pass => 'API KEY',
		test => 1,
	});

	my $response = $client->run_transaction( $request );

=head1 DESCRIPTION

A service object that is meant to provide a way to run the requested
transactions.

=head1 WITH

L<MooseY::RemoteHelper::Role::Client>

=method submit

	my $response = $client->submit( $request );

Takes a L<Business::CyberSource::Request> subclass as a parameter and returns
a L<Business::CyberSource::Response>

=method run_transaction

DEPRECATED, use L</submit>

=attr user

CyberSource Merchant ID

=attr pass

CyberSource API KEY

=attr test

Boolean value when false your requests will go to the live server, when
true they will go to the testing server.

=attr debug

Integer value that causes the HTTP request/response to be output to STDOUT
when a transaction is run. defaults to value of the environment variable

=over

=item value 0

no output (default)

=item value 1

request/response hashref

=item value 2

1 plus actual HTTP and XML

=back

=attr rules

ArrayRef of L<Rule Names|Business::CyberSource::Rule>. Rules names are modules
prefixed by L<Business::CyberSource::Rule>. By default both
L<Business::CyberSource::Rule::ExpiredCard> and
L<Business::CyberSource::Rule::RequestIDisZero> are included. If you decide to
add more rules remember to add C<qw( ExpiredCard RequestIDisZero )> to the
new ArrayRef ( if you want them ).

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
