package Business::CyberSource::Rule;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use MooseX::StrictConstructor;
use MooseX::ABC 0.06;

use Class::Load qw( load_class );

requires 'run';


sub debug {
	my ( $self, $message ) = shift;

	load_class 'Carp';
	our @CARP_NOT = ( __PACKAGE__, blessed( $self->client ) );

	$message //= blessed( $self ) . ' matched';

	Carp::carp( $message );

	return 1;
}

has client => (
	isa      => 'Business::CyberSource::Client',
	is       => 'ro',
	required => 1,
	weak_ref => 1,
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Abstract Rule Base
