package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}
use Moose::Role;
use SOAP::Data::Builder;
use Data::Dumper;

has _username_token => (
	is  => 'rw',
	isa => 'SOAP::Data::Builder::Element',
);

has data_builder => (
	required => 1,
	is       => 'rw',
	isa      => 'SOAP::Data::Builder',
	default  => sub {
		my $self = shift;
		my $sb = SOAP::Data::Builder->new;
		$sb->autotype(0);
		my $security = $sb->add_elem(
			header => 1,
			name   => 'wsse:Security',
			attributes => {
				'xmlns:wsse'
					=> 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'
			}
		);

		my $username_token = $sb->add_elem(
			header => 1,
			parent => $security,
			name   => 'wsse:UsernameToken',
		);

		$self->_username_token( $username_token );

		return $sb;
	},
);

has username => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	default  => sub { '' },
	trigger  => sub {
		my ( $self, $username ) = @_;
		my $sb = $self->data_builder;
		$sb->add_elem(
			header => 1,
			parent => $self->_username_token,
			name   => 'wsse:Username',
			value  => $username,
		);
	}
);	

has password => (
	required => 1,
	is       => 'ro',
	isa      => 'Str', # actually I wonder if I can validate this more
	default  => sub { '' },
	trigger  => sub {
		my ( $self, $password ) = @_;
		$self->data_builder->add_elem(
			header => 1,
			parent => $self->_username_token,
			name   => 'wsse:Password',
			value  => $password,
		);
	}
);

1;

# ABSTRACT: Request Role
