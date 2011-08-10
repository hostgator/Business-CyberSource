package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
BEGIN {
	# VERSION
}

use SOAP::Lite ( +trace => [ qw( debug ) ] );
use Moose;
with 'Business::CyberSource::Request';

sub submit {
	my ( $self ) = shift;
	
	my $req = SOAP::Lite->new(
		readable   => 1,
		autotype   => 0,
		proxy      => 'https://ics2wstest.ic3.com/commerce/1.x/transactionProcessor',
		default_ns => 'urn:schemas-cybersource-com:transaction-data-1.61',
	);
	my $ret = $req->requestMessage( $self->data_builder->to_soap_data )->result;		
	return $ret;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization request object
