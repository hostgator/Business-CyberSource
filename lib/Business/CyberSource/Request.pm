package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose::Role;
with 'Business::CyberSource';
use SOAP::Data::Builder;

has _username_token => (
	is  => 'rw',
	isa => 'SOAP::Data::Builder::Element',
);

has _sdbo => (
	documentation => 'SOAP::Data::Builder Object',
	required => 1,
	lazy     => 1,
	is       => 'rw',
	isa      => 'SOAP::Data::Builder',
	builder  => '_build_sdbo',
);

has username => (
	documentation => 'your merchantID',
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		my $sb = $self->_sdbo;

		$sb->add_elem(
			header => 1,
			parent => $self->_username_token,
			name   => 'wsse:Username',
			value  => $value,
		);

		$sb->add_elem(
			name   => 'merchantID',
			value  => $value,
		);
	},
);

has password => (
	documentation => 'your SOAP transaction key',
	required => 1,
	is       => 'ro',
	isa      => 'Str', # actually I wonder if I can validate this more
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			header => 1,
			parent => $self->_username_token,
			name   => 'wsse:Password',
			value  => $value,
			attributes => {
				Type =>
					'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText',
			},
		);
	},
);

sub _build_sdbo {
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

	$self->_username_token( $username_token );

	return $sb;
}

1;

# ABSTRACT: Request Role

__END__
=pod

=head1 NAME

Business::CyberSource::Request - Request Role

=head1 VERSION

version v0.1.0

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

