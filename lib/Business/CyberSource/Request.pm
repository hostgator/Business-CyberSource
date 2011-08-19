package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.3'; # VERSION
}
use Moose::Role;
use MooseX::Types::URI qw( Uri );

with qw(
	Business::CyberSource
	Business::CyberSource::Request::Role::PurchaseInfo
);

requires '_build_sdbo';
requires 'submit';

use SOAP::Data::Builder;

has production => (
	required => 1,
	lazy     => 1,
	is       => 'ro',
	isa      => 'Bool',
	default  => 0,
);

has server => (
	required => 1,
	lazy     => 1,
	coerce   => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Uri,
	builder => '_build_server',
);

has _sdbo => (
	documentation => 'SOAP::Data::Builder Object',
	required => 1,
	lazy     => 1,
	is       => 'ro',
	isa      => 'SOAP::Data::Builder',
	builder  => '_build_sdbo',
);

has username => (
	documentation => 'your merchantID',
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has password => (
	documentation => 'your SOAP transaction key',
	required => 1,
	is       => 'ro',
	isa      => 'Str', # actually I wonder if I can validate this more
);

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

sub _build_soap_request {
	my $self = shift;

	my $req = SOAP::Lite->new(
		readable   => 1,
		autotype   => 0,
		proxy      => $self->server,
		default_ns => 'urn:schemas-cybersource-com:transaction-data-1.61',
	);

	my $ret = $req->requestMessage( $self->_sdbo->to_soap_data );

	if ( $ret->fault ) {
		my ( $faultstring ) = $ret->faultstring =~ /\s([[:print:]]*)\s/xms;
		croak 'SOAP Fault: ' . $ret->faultcode . " " . $faultstring ;
	}

	$ret->match('//Body/replyMessage');

	return $ret;
}

sub _build_sdbo_header {
	my $self = shift;

	my $sb = SOAP::Data::Builder->new;
	$sb->autotype(0);

	my $security
		= $sb->add_elem(
			header => 1,
			name   => 'wsse:Security',
			attributes => {
				'xmlns:wsse'
					=> 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'
			}
		);

	my $username_token
		= $sb->add_elem(
			header => 1,
			parent => $security,
			name   => 'wsse:UsernameToken',
		);

	$sb->add_elem(
		header => 1,
		name   => 'wsse:Password',
		value  => $self->password,
		parent => $username_token,
		attributes => {
			Type =>
				'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText',
		},
	);

	$sb->add_elem(
		header => 1,
		name   => 'wsse:Username',
		value  => $self->username,
		parent => $username_token,
	);

	$sb->add_elem(
		name   => 'merchantID',
		value  => $self->username,
	);

	$sb->add_elem(
		name  => 'merchantReferenceCode',
		value => $self->reference_code,
	);

	$sb->add_elem(
		name  => 'clientLibrary',
		value => $self->client_name,
	);

	$sb->add_elem(
		name  => 'clientLibraryVersion',
		value => $self->client_version,
	);

	$sb->add_elem(
		name  => 'clientEnvironment',
		value => $self->client_env,
	);

	return $sb;
}

sub _build_server {
	my $self = shift;

	unless ( $self->production ) {
		return 'https://ics2wstest.ic3.com/commerce/1.x/transactionProcessor';
	}
	else {
		return 'https://ics2ws.ic3.com/commerce/1.x/transactionProcessor';
	}
}

1;

# ABSTRACT: Request Role

__END__
=pod

=head1 NAME

Business::CyberSource::Request - Request Role

=head1 VERSION

version v0.1.3

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

