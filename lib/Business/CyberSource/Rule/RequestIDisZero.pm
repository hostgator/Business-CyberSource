package Business::CyberSource::Rule::RequestIDisZero;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Rule';

sub run {
	my ( $self, $request ) = @_;

	# if the request can card it's required so no need to check has
	return unless $request->service->can('request_id')
		&& $request->service->has_request_id
		&& $request->service->request_id == 0
		;

	$self->debug if $self->client->debug;

	return {
		merchantReferenceCode => $request->reference_code,
		decision              => 'REJECT',
		reasonCode            => '241',
		requestID             => 0,
		requestToken          => 0,
	};
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Expired Card

=method run

returns a 241 REJECT: The request ID is invalid

=cut
