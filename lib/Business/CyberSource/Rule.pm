package Business::CyberSource::Rule;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
use MooseX::StrictConstructor;

use Class::Load qw( load_class );

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

=method run

required by subclasses but not provided. Is executed to check your rule and
returns a suitable mock answer. C<request_id> should be set to 0 in the answer.

	return { result => {
		merchantReferenceCode => $request->reference_code,
		decision              => 'REJECT',
		reasonCode            => '202',
		requestID             => 0,
		requestToken          => 0,
	}

=method debug

carps out the rule that matched if client has debug set.

=attr client

a weakened reference to the client, to check the clients debug state.

=cut
