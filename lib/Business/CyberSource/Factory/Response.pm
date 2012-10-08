package Business::CyberSource::Factory::Response;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Factory';

use Class::Load qw( load_class );

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

	use Carp;
	use Data::Dumper::Concise;
	carp Dumper $result;

	my $decision = $self->_get_decision( $result );

	# the reply is a subsection of result named after the specic request, e.g
	# ccAuthReply

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

1;

# ABSTRACT: A Response Factory

=method create

Pass the C<answer> from L<XML::Compile::SOAP> and the original Request Data
Transfer Object.

=cut
