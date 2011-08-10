package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
BEGIN {
	# VERSION
}

use SOAP::Lite ( +trace => [ qw( debug ) ] );
use Moose;
use namespace::autoclean;
with 'Business::CyberSource::Request';

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	trigger  => sub {
		my ( $self, $value ) = @_;
		$self->_sdbo->add_elem(
			name   => 'merchantReferenceCode',
			value  => $value,
		);
	},
);

sub submit {
	my ( $self ) = shift;
	
	my $req = SOAP::Lite->new(
		readable   => 1,
		autotype   => 0,
		proxy      => 'https://ics2wstest.ic3.com/commerce/1.x/transactionProcessor',
		default_ns => 'urn:schemas-cybersource-com:transaction-data-1.61',
	);

	my $ret = $req->requestMessage( $self->_sdbo->to_soap_data )->result;

	return 1;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization request object
