package Business::CyberSource::Request::Credit;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.2'; # VERSION
}
use Moose;
use namespace::autoclean;
with qw(
	MooseX::Traits
	Business::CyberSource::Request
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

	my $credit = $sb->add_elem(
		attributes => { run => 'true' },
		name       => 'ccCreditService',
		value      => ' ', # hack to prevent cs side unparseable xml
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

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Credit - CyberSource Credit Request Object

=head1 VERSION

version v0.1.2

=head1 ATTRIBUTES

=head2 client_env

Reader: client_env

Type: Str

This attribute is required.

=head2 currency

Reader: currency

Type: Str

This attribute is required.

=head2 password

Reader: password

Type: Str

This attribute is required.

Additional documentation: your SOAP transaction key

=head2 production

Reader: production

Type: Bool

This attribute is required.

=head2 server

Reader: server

Type: MooseX::Types::URI::Uri

This attribute is required.

=head2 request_id

Reader: request_id

Type: Str

=head2 total

Reader: total

Type: Num

=head2 username

Reader: username

Type: Str

This attribute is required.

Additional documentation: your merchantID

=head2 foreign_currency

Reader: foreign_currency

Type: Str

=head2 client_name

Reader: client_name

Type: Str

This attribute is required.

=head2 reference_code

Reader: reference_code

Type: Str

This attribute is required.

=head2 client_version

Reader: client_version

Type: Str

This attribute is required.

=head1 METHODS

=head2 submit

Method originates in Business::CyberSource::Request::Credit.

=head2 client_env

Method originates in Business::CyberSource::Request::Credit.

=head2 currency

Method originates in Business::CyberSource::Request::Credit.

=head2 password

Method originates in Business::CyberSource::Request::Credit.

=head2 production

Method originates in Business::CyberSource::Request::Credit.

=head2 server

Method originates in Business::CyberSource::Request::Credit.

=head2 request_id

Method originates in Business::CyberSource::Request::Credit.

=head2 new

Method originates in Business::CyberSource::Request::Credit.

=head2 with_traits

Method originates in MooseX::Traits.

=head2 new_with_traits

Method originates in MooseX::Traits.

=head2 total

Method originates in Business::CyberSource::Request::Credit.

=head2 username

Method originates in Business::CyberSource::Request::Credit.

=head2 apply_traits

Method originates in MooseX::Traits.

=head2 reference_code

Method originates in Business::CyberSource::Request::Credit.

=head2 client_name

Method originates in Business::CyberSource::Request::Credit.

=head2 foreign_currency

Method originates in Business::CyberSource::Request::Credit.

=head2 client_version

Method originates in Business::CyberSource::Request::Credit.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

