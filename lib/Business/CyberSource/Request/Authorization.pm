package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}

use SOAP::Lite +trace => [ 'debug' ] ;
use Moose;
use namespace::autoclean;
with 'Business::CyberSource::Request';

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
		croak 'SOAP Fault: ' . $ret->faultcode . ' ' . $ret->faultstring ;
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
			auth_record    => $ret->valueof('ccAuthReply/authRecord' ),
			auth_code      => $ret->valueof('ccAuthReply/authorizationCode'),
			processor_response => $ret->valueof('ccAuthReply/processorResponse'),
		})
		;

	return $res;
}

has reference_code => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has first_name => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has last_name => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has street => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has city => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has state => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has country => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has zip => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has email => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has ip => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has unit_price => (
	required => 1,
	is       => 'ro',
	isa      => 'Num',
	traits   => ['Number'],
);

has quantity => (
	required => 1,
	is       => 'ro',
	isa      => 'Int',
	traits   => ['Number'],
);

has currency => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has total => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
	isa      => 'Num',
	traits   => ['Number'],
);

has credit_card => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has cc_exp_month => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has cc_exp_year => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

sub _build_sdbo {
	my $self = shift;
	my $sb = SOAP::Data::Builder->new;
	$sb->autotype(0);

## HEADER
	my $security
		= $sb->add_elem(
			header => 1,
			name   => 'wsse:Security',
			attributes => {
				'xmlns:wsse'
					=> 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'
			}
		);

	my $username_token
		= $sb->add_elem(
			header => 1,
			parent => $security,
			name   => 'wsse:UsernameToken',
		);

	$sb->add_elem(
		header => 1,
		name   => 'wsse:Password',
		value  => $self->password,
		parent => $username_token,
		attributes => {
			Type =>
				'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText',
		},
	);

	$sb->add_elem(
		header => 1,
		name   => 'wsse:Username',
		value  => $self->username,
		parent => $username_token,
	);


## BODY
	$sb->add_elem(
		name   => 'merchantID',
		value  => $self->username,
	);

	$sb->add_elem(
		name  => 'merchantReferenceCode',
		value => $self->reference_code,
	);

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

	my $bill_to = $sb->add_elem(
		name => 'billTo',
	);

	$sb->add_elem(
		name   => 'firstName',
		value  => $self->first_name,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'lastName',
		value  => $self->last_name,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'street1',
		value  => $self->street,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'city',
		value  => $self->city,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'state',
		parent => $bill_to,
		value  => $self->state,
	);

	$sb->add_elem(
		name   => 'postalCode',
		parent => $bill_to,
		value  => $self->zip,
	);

	$sb->add_elem(
		name   => 'country',
		parent => $bill_to,
		value  => $self->country,
	);

	$sb->add_elem(
		name   => 'email',
		value  => $self->email,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'ipAddress',
		value  => '192.168.100.2',
		parent => $bill_to,
	);

	my $item = $sb->add_elem(
		name => 'item',
		attributes => { id => '0' },
	);

	$sb->add_elem(
		name => 'unitPrice',
		value => $self->unit_price,
		parent => $item,
	);

	$sb->add_elem(
		name => 'quantity',
		value => $self->quantity,
		parent => $item,
	);

	my $purchase_totals = $sb->add_elem(
		name => 'purchaseTotals',
	);

	$sb->add_elem(
		name   => 'currency',
		parent => $purchase_totals,
		value  => $self->currency,
	);


	$sb->add_elem(
		name   => 'grandTotalAmount',
		value  => $self->total,
		parent => $purchase_totals,
	);

	my $card = $sb->add_elem(
		name => 'card',
	);

	$sb->add_elem(
		name   => 'accountNumber',
		value  => $self->credit_card,
		parent => $card,
	);

	$sb->add_elem(
		name   => 'expirationMonth',
		value  => $self->cc_exp_month,
		parent => $card,
	);

	$sb->add_elem(
		name   => 'expirationYear',
		value  => $self->cc_exp_year,
		parent => $card,
	);

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

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Authorization - CyberSource Authorization request object

=head1 VERSION

version v0.1.0

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

