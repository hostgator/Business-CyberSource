package Business::CyberSource::Factory::Response;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Factory';

use Class::Load  qw( load_class );
use Module::Load qw( load       );

use Exception::Base (
	'Business::CyberSource::Exception' => {
		has => [ qw( answer ) ],
	},
	'Business::CyberSource::Response::Exception' => {
		isa => 'Business::CyberSource::Exception',
		has => [
			qw(decision reason_text reason_code request_id request_token trace)
		],
		string_attributes => [ qw( message decision reason_text ) ],
	},
	verbosity      => 4,
	ignore_package => [ __PACKAGE__, 'Business::CyberSource::Client' ],
);

sub create {
	my ( $self, $request, $answer ) = @_;

	my $result = $answer->{result};

	if ( $self->debug ) {
		load 'Carp';
		load $self->_dumper_package, 'Dumper';

		Carp::carp( 'RESPONSE HASH: ' . Dumper( $result ) );
	}

	my $response
		= load_class('Business::CyberSource::Response')
		->new( $answer->{result} )
		;

	return $response;
}

sub _get_decision {
	my ( $self, $result ) = @_;

	my $_;

	my ( $decision )
		= grep {
			$_ eq $result->{decision}
		}
		qw( ERROR ACCEPT REJECT )
		or Business::CyberSource::Exception->throw(
			message  => 'decision not defined or not handled',
			answer   => $result,
		)
		;

	return $decision;
}

has _client => (
	isa      => 'Business::CyberSource::Client',
	is       => 'bare',
	required => 1,
	weak_ref => 1,
	handles  => [qw( debug _dumper_package )],
);

1;

# ABSTRACT: A Response Factory

=method create

Pass the C<answer> from L<XML::Compile::SOAP> and the original Request Data
Transfer Object.

=cut
