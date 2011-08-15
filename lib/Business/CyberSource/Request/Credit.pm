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
with qw(
	Business::CyberSource::Request
	Business::CyberSource::Request::Role::BillingInfo
);

use Business::CyberSource::Response::Capture;

use SOAP::Lite +trace => [ 'debug' ] ;

sub submit {
	my $self = shift;
	return 1;
}

sub _build_sdbo {
	my $self = shift;

	my $sb = $self->_build_sdbo_header;
	$sb = $self->_build_bill_to_info    ( $sb );
	$sb = $self->_build_purchase_info   ( $sb );
	$sb = $self->_build_credit_card_info( $sb );

	$sb->add_elem(
		attributes => { run => 'true' },
		name       => 'ccCreditService',
		value      => ' ', # hack to prevent cs side unparseable xml
	);

	return $sb;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object
