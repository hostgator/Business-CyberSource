package Business::CyberSource::Request;
use 5.008;
use strict;
use warnings;
use Carp;

# VERSION

use MooseX::AbstractFactory;
use namespace::autoclean;

has production => (
	is       => 'ro',
	isa      => 'Bool',
);

has username => (
	is       => 'ro',
	isa      => 'Str',
);

has password => (
	is       => 'ro',
	isa      => 'Str', # actually I wonder if I can validate this more
);

around 'create' => sub {
	my ( $orig, $self, $imp, $args ) = @_;

	if ( ref($args) eq 'HASH' ) {
		$args->{username}   = $self->username;
		$args->{password}   = $self->password;
		$args->{production} = $self->production;
	}
	else {
		croak 'args not a hashref';
	}

	$self->$orig( $imp, $args );
};

1;

# ABSTRACT: CyberSource request factory
