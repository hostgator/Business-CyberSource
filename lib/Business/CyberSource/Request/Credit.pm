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
	MooseX::Traits
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
);

use Business::CyberSource::Response;

use SOAP::Lite; #+trace => [ 'debug' ] ;

has request_id => (
	is  => 'ro',
	isa => 'Str',
);

sub submit {
	my $self = shift;

	my $ret = $self->_build_soap_request;

	my $decision    = $ret->valueof('decision'  );
	my $request_id  = $ret->valueof('requestID' );
	my $reason_code = $ret->valueof('reasonCode');

	croak 'no decision from CyberSource' unless $decision;

	my $res;
	if ( $decision eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::Credit
			})
			->new({
				request_id     => $request_id,
				decision       => $decision,
				reason_code    => $reason_code,
				reference_code => $ret->valueof('merchantReferenceCode'  ),
				request_token  => $ret->valueof('requestToken'           ),
				currency       => $ret->valueof('purchaseTotals/currency'),
				amount         => $ret->valueof('ccCreditReply/amount'     ),
				datetime       => $ret->valueof('ccCreditReply/requestDateTime'),
				credit_reason_code => $ret->valueof('ccCreditReply/reasonCode'),
				reconciliation_id  => $ret->valueof('ccCreditReply/reconciliationID'),
			})
			;
	}
	elsif ( $decision eq 'REJECT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Reject
			})
			->new({
				decision      => $decision,
				request_id    => $request_id,
				reason_code   => $reason_code,
				request_token => $ret->valueof('requestToken'),
			})
			;
	}
	else {
		croak 'decision defined, but not sane: ' . $decision;
	}

	return $res;
}

sub _build_sdbo {
	my $self = shift;

	my $sb = $self->_build_sdbo_header;

	unless ( $self->request_id ) { # should probably introspec
		$sb = $self->_build_bill_to_info    ( $sb );
	}

	$sb = $self->_build_purchase_info   ( $sb );

	unless ( $self->request_id ) { # should probably introspec
		$sb = $self->_build_credit_card_info( $sb );
	}

	my $value = $self->request_id ? undef : ' ';

	my $credit = $sb->add_elem(
		attributes => { run => 'true' },
		name       => 'ccCreditService',
		value      => $value, # hack to prevent cs side unparseable xml
	);

	if ( $self->request_id ) {
		$sb->add_elem(
			name   => 'captureRequestID',
			value  => $self->request_id,
			parent => $credit,
		)
	}

	return $sb;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object
