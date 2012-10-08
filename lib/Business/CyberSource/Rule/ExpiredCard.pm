package Business::CyberSource::Rule::ExpiredCard;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Rule';

sub run {
	my ( $self, $request ) = @_;

	# if the request can card it's required so no need to check has
	return unless $request->can('card')
		&& blessed $request->card
		&& $request->card->can('is_expired')
		&& $request->card->is_expired
		;

	$self->debug if $self->client->debug;

	return {
		merchantReferenceCode => $request->reference_code,
		decision              => 'REJECT',
		reasonCode            => '202',
		requestID             => 0,
		requestToken          => 0,
	};
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Expired Card

=method run

returns a REJECT 202 if card is expired.

=cut
