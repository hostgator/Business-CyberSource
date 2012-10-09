package Business::CyberSource::Response;
use strict;
use warnings;
use namespace::autoclean;
use Module::Load qw( load );

# VERSION

use Moose;
extends 'Business::CyberSource::Message';
with qw(
	Business::CyberSource::Response::Role::ReasonCode

	Business::CyberSource::Response::Role::Authorization
);

use MooseX::Aliases;
use MooseX::Types::Common::String 0.001005 qw( NonEmptySimpleStr );
use MooseX::Types::CyberSource qw(
	Decision
	RequestID
	ResPurchaseTotals
	AuthReply
	Reply
	TaxReply
	DCCReply
);

use Moose::Util::TypeConstraints;


# DRAGONS! yes evil, but necesary for backwards compat
our $AUTOLOAD;

sub AUTOLOAD { ## no critic ( ClassHierarchies::ProhibitAutoloading )
	my $self = shift;

	my $called = $AUTOLOAD;
	$called =~ s/.*:://; ## no critic ( RegularExpressions::RequireExtendedFormatting )

	load 'Carp';
	Carp::carp 'DEPRECATED: please call '
		. $called
		. ' on the appropriate nested object'
		;

	my @nested = ( qw(
		auth
		capture
		credit
		auth_reversal
		dcc
		purchase_totals
	) );

	my $val;
	foreach my $attr ( @nested ) {
		my $predicate   = 'has_' . $attr;
		my $called_pred = 'has_' . $called;
		if ( $self->$predicate
				&& $self->$attr->meta->find_method_by_name( $called_pred )
				&& $self->$attr->$called_pred
			) {
			$val = $self->$attr->$called;
			last if $val;
		}
	}
	confess 'unable to delegate, was not a valid method' unless defined $val;
	return $val;
}

has '+reference_code' => ( required => 0 );

## common
has request_id => (
	isa         => RequestID,
	remote_name => 'requestID',
	is          => 'ro',
	predicate   => 'has_request_id',
	required    => 1,
);

has decision => (
	isa         => Decision,
	remote_name => 'decision',
	is          => 'ro',
	required    => 1,
);

has request_token => (
	isa         => subtype( NonEmptySimpleStr, where { length $_ <= 256 }),
	remote_name => 'requestToken',
	required    => 1,
	is          => 'ro',
);

# accepted

has purchase_totals => (
	isa         => ResPurchaseTotals,
	remote_name => 'purchaseTotals',
	is          => 'ro',
	predicate   => 'has_purchase_totals',
	coerce      => 1,
	handles     => [ qw( currency ) ],
);


has auth => (
	isa         => AuthReply,
	remote_name => 'ccAuthReply',
	is          => 'ro',
	predicate   => 'has_auth',
	coerce      => 1,
	handles     => [qw(
		avs_code
		avs_code_raw
		auth_code
		auth_record
		cv_code
		cv_code_raw
	)],
);

has capture => (
	isa         => Reply,
	remote_name => 'ccCaptureReply',
	is          => 'ro',
	predicate   => 'has_capture',
	coerce      => 1,
);

has credit => (
	isa         => Reply,
	remote_name => 'ccCreditReply',
	is          => 'ro',
	predicate   => 'has_credit',
	coerce      => 1,
);

has auth_reversal=> (
	isa         => Reply,
	remote_name => 'ccAuthReversalReply',
	is          => 'ro',
	predicate   => 'has_auth_reversal',
	coerce      => 1,
);

has dcc => (
	isa         => DCCReply,
	remote_name => 'ccDCCReply',
	is          => 'ro',
	predicate   => 'has_dcc',
	coerce      => 1,
);

has tax => (
	isa         => TaxReply,
	remote_name => 'taxReply',
	is          => 'ro',
	predicate   => 'has_tax',
	coerce      => 1,
);

## built
has reason_text => (
	isa      => 'Str',
	required => 1,
	lazy     => 1,
	is       => 'ro',
	builder  => '_build_reason_text',
);

has is_success => (
	isa      => 'Bool',
	is       => 'ro',
	lazy     => 1,
	init_arg => undef,
	default  => sub {
		my $self = shift;
		return $self->decision eq 'ACCEPT' ? 1 : 0;
	},
);

has is_accept => (
	isa      => 'Bool',
	is       => 'ro',
	lazy     => 1,
	init_arg => undef,
	alias    => [ qw( accepted is_accepted ) ],
	default  => sub {
		my $self = shift;
		return $self->decision eq 'ACCEPT' ? 1 : 0;
	},
);

has is_reject => (
	isa      => 'Bool',
	is       => 'ro',
	lazy     => 1,
	init_arg => undef,
	default  => sub {
		my $self = shift;
		return $self->decision eq 'REJECT' ? 1 : 0;
	},
);

has is_error => (
	isa      => 'Bool',
	is       => 'ro',
	lazy     => 1,
	init_arg => undef,
	default  => sub {
		my $self = shift;
		return $self->decision eq 'ERROR' ? 1 : 0;
	}
);

sub _build_reason_text {
	my ( $self, $reason_code ) = @_;
	$reason_code //= $self->reason_code;

	my %reason = (
		100 => 'Successful transaction',
		101 => 'The request is missing one or more required fields',
		102 => 'One or more fields in the request contains invalid data',
		110 => 'Only a partial amount was approved',
		150 => 'General system failure',
		151 => 'The request was received but there was a server timeout.',
		152 => 'The request was received, but a service did not finish '
			. 'running in time'
			,
		200 => 'The authorization request was approved by the issuing bank '
			. 'but declined by CyberSource because it did not pass the '
			. 'Address Verification Service (AVS) check'
			,
		201 => 'The issuing bank has questions about the request. You do not '
			. 'receive an authorization code programmatically, but you might '
			. 'receive one verbally by calling the processor'
			,
		202 => 'Expired card. You might also receive this if the expiration '
			. 'date you provided does not match the date the issuing bank '
			. 'has on file'
			,
		203 => 'General decline of the card. No other information provided '
			. 'by the issuing bank'
			,
		204 => 'Insufficient funds in the account',
		205 => 'Stolen or lost card',
		207 => 'Issuing bank unavailable',
		208 => 'Inactive card or card not authorized for card-not-present '
			. 'transactions'
			,
		209 => 'American Express Card Identification Digits (CID) did not '
			. 'match'
			,
		210 => 'The card has reached the credit limit',
		211 => 'Invalid CVN',
		221 => 'The customer matched an entry on the processor\'s negative '
			. 'file'
			,
		230 => 'The authorization request was approved by the issuing bank '
			. 'but declined by CyberSource because it did not pass the CVN '
			. 'check'
			,
		231 => 'Invalid account number',
		232 => 'The card type is not accepted by the payment processor',
		233 => 'General decline by the processor',
		234 => 'There is a problem with your CyberSource merchant '
			. 'configuration'
			,
		235 => 'The requested amount exceeds the originally authorized '
			. 'amount'
			,
		236 => 'Processor failure',
		237 => 'The authorization has already been reversed',
		238 => 'The authorization has already been captured',
		239 => 'The requested transaction amount must match the previous '
			. 'transaction amount'
			,
		240 => 'The card type sent is invalid or does not correlate with '
			. 'the credit card number'
			,
		241 => 'The request ID is invalid',
		242 => 'You requested a capture, but there is no corresponding, '
			. 'unused authorization record'
			,
		243 => 'The transaction has already been settled or reversed',
		246 => 'The capture or credit is not voidable because the capture or '
			. 'credit information has already been submitted to your '
			. 'processor. Or, you requested a void for a type of '
			. 'transaction that cannot be voided'
			,
		247 => 'You requested a credit for a capture that was previously '
			. 'voided'
			,
		250 => 'The request was received, but there was a timeout at the '
			. 'payment processor'
			,
		600 => 'Address verification failed',
	);

	return $reason{$reason_code};
}

around [qw(
	avs_code
	avs_code_raw
	auth_code
	auth_record
	cv_code
	cv_code_raw
)] => sub {
	my $orig = shift;
	my $self = shift;
	load 'Carp';
	Carp::carp 'DEPRECATED: please call method'
		. ' on the appropriate nested object'
		;

	return $self->$orig( @_ );
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Response Object

=head1 DESCRIPTION

This response can be used to determine the success of a transaction,
as well as receive a follow up C<request_id> in case you need to do further
actions with this.

=head1 EXTENDS

L<Business::CyberSource::Message>;

=head1 WITH

=over

=item L<Business::CyberSource::Role::RequestID>

=back

=attr is_accept

boolean way of determining whether the transaction was accepted

=attr is_reject

boolean way of determining whether the transaction was rejected

=attr is_error

boolean way of determining whether the transaction was error. Note this is used
internally as a response that is an error will throw an exception.

=attr decision

Summarizes the result of the overall request. This is the text, you can check
L<is_accept|/"is_accept">, L<is_reject|/"is_reject"> for a more boolean way.

=attr reason_code

Numeric value corresponding to the result of the credit card authorization
request.

=attr reason_text

official description of returned reason code.

I<warning:> reason codes are returned by CyberSource and occasionally do not
reflect the real reason for the error please inspect the
L<trace|Business::Cybersource::Message/"trace"> request/response for issues

=attr request_token

Request token data created by CyberSource for each reply. The field is an
encoded string that contains no confidential information, such as an account
or card verification number. The string can contain up to 256 characters.

=attr reference_code

B<Type:> Varying character 50

The merchant reference code originally sent

=attr auth

	$response->auth if $response->has_auth;

B<Type:> L<Business::CyberSource::ResponsePart::AuthReply>

=attr purchase_totals

	$response->purchase_totals if $response->has_purchase_totals;

B<Type:> L<Business::CyberSource::ResponsePart::PurchaseTotals>

=attr capture

	$response->capture if $response->has_capture;

B<Type:> L<Business::CyberSource::ResponsePart::Reply>

=attr credit

	$response->credit if $response->has_credit;

B<Type:> L<Business::CyberSource::ResponsePart::Reply>

=attr auth_reversal

	$response->auth_reversal if $response->has_auth_reversal;

B<Type:> L<Business::CyberSource::ResponsePart::Reply>

=attr dcc

	$response->dcc if $response->has_dcc;

B<Type:> L<Business::CyberSource::ResponsePart::DCCReply>

=attr tax

	$response->tax if $response->has_tax;

B<Type:> L<Business::CyberSource::ResponsePart::TaxReply>

=cut
