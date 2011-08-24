package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;
use Carp;

# VERSION

use MooseX::AbstractFactory;
use namespace::autoclean;

with qw(
	 Business::CyberSource::Request::Role::Credentials
);

has '+production' => ( required => 0 );
has '+username'   => ( required => 0 );
has '+password'   => ( required => 0 );

around 'create' => sub {
	my ( $orig, $self, $imp, $args ) = @_;

	if ( ref($args) eq 'HASH' ) {
		$args->{username} ||= $self->username;
		$args->{password} ||= $self->password;
		$args->{production} = $self->production unless defined $args->{production};
	}
	else {
		croak 'args not a hashref';
	}

	$self->$orig( $imp, $args );
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource request factory
