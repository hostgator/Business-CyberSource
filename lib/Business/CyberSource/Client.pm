package Business::CyberSource::Client;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007008'; # VERSION

use Moose;

use Moose::Util::TypeConstraints;

use MooseX::StrictConstructor;

use MooseX::Types::Moose   qw( HashRef Str );
use MooseX::Types::Path::Class qw( File Dir );
use MooseX::Types::Common::String qw( NonEmptyStr NonEmptySimpleStr );

use Config;
use Class::Load 0.20 qw( load_class );
use Module::Load     qw( load       );

use XML::Compile::SOAP::WSS 1.04;
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub run_transaction {
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
		merchantID            => $self->_username,
		clientEnvironment     => $self->env,
		clientLibrary         => $self->name,
		clientLibraryVersion  => $self->version,
		%{ $request->serialize },
	);

	if ( $self->debug >= 1 ) {
		load 'Carp';
		load $self->_dumper_package, 'Dumper';

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
		load 'Carp';
		load $self->_dumper_package, 'Dumper';

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
		username => $self->_username,
		password => $self->_password,
	);

	my $call = $wsdl->compileClient('runTransaction');

	return $call;
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
			load_class('Business::CyberSource::Factory::Response')
			->new;
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
	isa     => 'Int',
	is      => 'ro',
	lazy    => 1,
	default => sub {
		return $ENV{PERL_BUSINESS_CYBERSOURCE_DEBUG} // 0;
	},
);

has _dumper_package => (
	isa      => NonEmptySimpleStr,
	is       => 'ro',
	lazy     => 1,
	init_arg => 'dumper_package',
	default  => sub { return 'Data::Dumper'; },
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

version 0.007008

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

Integer value that causes the HTTP request/response to be output to STDOUT
when a transaction is run. defaults to value of the environment variable
C<PERL_BUSINESS_CYBERSOURCE_DEBUG>.

=over

=item 0

no output (default)

=item 1

request/response hashref

=item 2

1 plus actual HTTP and XML

=back

=head2 rules

ArrayRef of L<Rule Names|Business::CyberSource::Rule>. Rules names are modules
prefixed by L<Business::CyberSource::Rule>. By default both
L<Business::CyberSource::Rule::ExpiredCard> and
L<Business::CyberSource::Rule::RequestIDisZero> are included. If you decide to
add more rules remember to add C<qw( ExpiredCard RequestIDisZero )> to the
new ArrayRef ( if you want them ).

=head2 dumper_package

Package name for dumping the request hash if doing a L<debug|/"debug">. Package
must have a C<Dumper> function.

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
https://github.com/hostgator/business-cybersource/issues or by email to
development@hostgator.com.

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by L<HostGator.com|http://hostgator.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
