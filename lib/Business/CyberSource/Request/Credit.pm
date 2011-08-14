package Business::CyberSource::Request::Credit;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}
use Moose;
use namespace::autoclean;
with 'Business::CyberSource::Request';

use Business::CyberSource::Response::Capture;

use SOAP::Lite +trace => [ 'debug' ] ;

sub submit {
	my $self = shift;
	return 1;
}

sub _build_sdbo {
	my $self = shift;

	return
}

__PACKAGE__->meta->make_immutable;

1;

# ABSTRACT: CyberSource Credit Request Object
