package Business::CyberSource::Response;
use strict;
use warnings;
use namespace::autoclean;
use Module::Load qw( load );

# VERSION

use Moose;
extends 'Business::CyberSource::Message';
with qw(
	Business::CyberSource::Role::MerchantReferenceCode
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

# DRAGONS!
our $AUTOLOAD;

sub AUTOLOAD {
	my $self = shift;

	my $called = $AUTOLOAD =~ s/.*:://r;

	load 'Carp';
	Carp::carp 'DEPRECATED: please call '
		. $called
		. ' on the nested object you desire'
		;

	my @nested = ( qw(
		auth_reply
		capture_reply
		credit_reply
		auth_reversal_reply
		dcc_reply
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
	return $val;
}

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

has auth_reply => (
	isa         => AuthReply,
	remote_name => 'ccAuthReply',
	is          => 'ro',
	predicate   => 'has_auth_reply',
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

has capture_reply => (
	isa         => Reply,
	remote_name => 'ccCaptureReply',
	is          => 'ro',
	predicate   => 'has_capture_reply',
	coerce      => 1,
);

has credit_reply => (
	isa         => Reply,
	remote_name => 'ccCreditReply',
	is          => 'ro',
	predicate   => 'has_credit_reply',
	coerce      => 1,
);

has auth_reversal_reply => (
	isa         => Reply,
	remote_name => 'ccAuthReversalReply',
	is          => 'ro',
	predicate   => 'has_auth_reversal_reply',
	coerce      => 1,
);

has dcc_reply => (
	isa         => DCCReply,
	remote_name => 'ccDCCReply',
	is          => 'ro',
	predicate   => 'has_dcc_reply',
	coerce      => 1,
);

has tax_reply => (
	isa         => TaxReply,
	remote_name => 'taxReply',
	is          => 'ro',
	predicate   => 'has_tax_reply',
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

sub _build_reason_text {
	my $self = shift;

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

	return $reason{$self->reason_code};
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Response Object

=head1 DESCRIPTION

Every time you call C<submit> on a request object it returns a response
object. This response can be used to determine the success of a transaction,
as well as receive a follow up C<request_id> in case you need to do further
actions with this. A response will always have C<decision>, C<reason_code>,
C<reason_text>, C<request_token>, and C<request_id> attributes. You should always use either
introspection or check the C<decision> to determine which attributes will be
defined, as what is returned by CyberSource varies depending on what the
C<decision> is and what was sent in the request itself.

All of the responses contain the attributes here, however if the response is
C<ACCEPT> you will want to read the documentation for the L<Accept
Role|Business::CyberSource::Response::Role::Accept>

=head2 inherits

L<Business::CyberSource::Message>;

=head2 composes

=over

=item L<Business::CyberSource::Role::RequestID>

=back

=attr decision

Summarizes the result of the overall request

=attr reason_code

Numeric value corresponding to the result of the credit card authorization
request

=attr reason_text

official description of returned reason code.

I<warning:> reason codes are returned by CyberSource and occasionally do not
reflect the real reason for the error please inspect the
L<trace|Business::Cybersource::Message/"trace"> request/response for issues

=attr request_token

Request token data created by CyberSource for each reply. The field is an
encoded string that contains no confidential information, such as an account
or card verification number. The string can contain up to 256 characters.

=attr is_accept

boolean way of determining whether the transaction was accepted

=attr is_reject

boolean way of determining whether the transaction was rejected

=attr is_success

boolean way of determining whether the transaction was successful.
Currently an alias for L<is_accept|/"is_accept"> but will later mean a non
error status.

=attr amount

Type: Num

Condition: ACCEPT

Amount that was approved.

=attr currency

Type: MooseX::Types::Locale::Currency

Condition: ACCEPT

Currency code which was used to make the request

=attr datetime

Type: MooseX::Types::DateTime::W3C::DateTimeW3C

Condition: ACCEPT

Request timestamp (will probably become a DateTime object at some point)

=attr reference_code

Type: Varying character 50

Condition: ACCEPT

The merchant reference code originally sent

=attr request_specific_reason_code

Type: Int

Condition: ACCEPT

Every successful request also has a reason code specific to its request type,
e.g. for capture this is the ccCaptureReply_reasonCode.

=attr processor_response

Type: Varying character 10

Condition: ACCEPT and be either an Authorization or Authorization Reversal

=attr reconciliation_id

Type: Int

Condition: ACCEPT and be either a Credit or Capture

=attr avs_code

Type: Varying character 1

Condition: ACCEPT and Authorization

=attr avs_code_raw

Type: Varying character 10

Condition: ACCEPT and Authorization

=attr auth_record

Type: Str

Condition: ACCEPT and Authorization

=attr auth_code

Type: Varying character 7

Condition: ACCEPT and Authorization

=attr cv_code

Type: Single Char

Condition: ACCEPT, Authorization, and cv_code actually returned

you can use predicate has_cv_code to check if attribute is defined

=attr cv_code_raw

Type: Varying character 10

Condition: ACCEPT, Authorization, and cv_code_raw actually returned

you can use predicate has_cv_code to check if attribute is defined

=cut
