package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	# VERSION
}

use SOAP::Lite; # +trace => [ 'debug' ] ;
use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

use Business::CyberSource::Response::Authorization;

sub submit {
	my $self = shift;

	my $req = SOAP::Lite->new(
		readable   => 1,
		autotype   => 0,
		proxy      => 'https://ics2wstest.ic3.com/commerce/1.x/transactionProcessor',
		default_ns => 'urn:schemas-cybersource-com:transaction-data-1.61',
	);

	my $ret = $req->requestMessage( $self->_sdbo->to_soap_data );

	if ( $ret->fault ) {
		my ( $faultstring ) = $ret->faultstring =~ /\s([[:print:]]*)\s/xms;
		croak 'SOAP Fault: ' . $ret->faultcode . " " . $faultstring ;
	}

	$ret->match('//Body/replyMessage');

	my $res
		= Business::CyberSource::Response::Authorization->new({
			request_id     => $ret->valueof('requestID'              ),
			decision       => $ret->valueof('decision'               ),
			reference_code => $ret->valueof('merchantReferenceCode'  ),
			reason_code    => $ret->valueof('reasonCode'             ),
			request_token  => $ret->valueof('requestToken'           ),
			currency       => $ret->valueof('purchaseTotals/currency'),
			amount         => $ret->valueof('ccAuthReply/amount'     ),
			avs_code_raw   => $ret->valueof('ccAuthReply/avsCodeRaw' ),
			avs_code       => $ret->valueof('ccAuthReply/avsCode'    ),
			auth_datetime  => $ret->valueof('ccAuthReply/authorizedDateTime'),
			auth_record    => $ret->valueof('ccAuthReply/authRecord'        ),
			auth_code      => $ret->valueof('ccAuthReply/authorizationCode' ),
			processor_response => $ret->valueof('ccAuthReply/processorResponse'),
		})
		;

	return $res;
}

sub _build_sdbo {
	my $self = shift;

	my $sb = $self->_build_sdbo_header;

	$sb->add_elem(
		name  => 'clientLibrary',
		value => $self->client_name,
	);

	$sb->add_elem(
		name  => 'clientLibraryVersion',
		value => $self->client_version,
	);

	$sb->add_elem(
		name  => 'clientEnvironment',
		value => $self->client_env,
	);

	$sb = $self->_build_bill_to_info    ( $sb );
	$sb = $self->_build_purchase_info   ( $sb );
	$sb = $self->_build_credit_card_info( $sb );


	$sb->add_elem(
		attributes => { run => 'true' },
		name       => 'ccAuthService',
		value      => ' ', # hack to prevent cs side unparseable xml
	);

	return $sb;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization request object
