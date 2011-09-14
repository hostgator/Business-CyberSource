package Business::CyberSource::Response;
use 5.008;
use strict;
use warnings;

our $VERSION = 'v0.2.9'; # VERSION

use Moose;
use namespace::autoclean;

with qw(
	MooseX::Traits
	Business::CyberSource::Role::RequestID
);

use MooseX::StrictConstructor;
use MooseX::Types::Moose qw( Str Int );
use MooseX::Types::CyberSource qw( Decision );
use MooseX::Types::Varchar qw( Varchar );

has decision => (
	required => 1,
	is       => 'ro',
	isa      => Decision,
	documentation => 'Summarizes the result of the overall request',
);

has reason_code => (
	required => 1,
	is       => 'ro',
	isa      => Int,
	documentation => 'Numeric value corresponding to the result '
		. 'of the credit card authorization request',
);

has reason_text => (
	required => 1,
	lazy     => 1,
	is       => 'ro',
	isa      => Str,
	builder  => '_build_reason_text',
	documentation => 'official description of returned reason code. '
		. 'warning: reason codes are returned by CyberSource and '
		. 'occasionally do not reflect the real reason for the error '
		. 'please inspect the trace request/response for issues',
);

has request_token => (
	required => 1,
	is       => 'ro',
	isa      => Varchar[256],
	documentation => 'Request token data created by CyberSource for each '
		. 'reply. The field is an encoded string that contains no '
		. 'confidential information, such as an account or card verification '
		. 'number. The string can contain up to 256 characters.',

);

sub _build_reason_text {
	my $self = shift;

	my $reason = {
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
	};

	return $reason->{$self->reason_code};
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: Response Object


__END__
=pod

=head1 NAME

Business::CyberSource::Response - Response Object

=head1 VERSION

version v0.2.9

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

=head1 ATTRIBUTES

=head2 reason_text

Reader: reason_text

Type: Str

This attribute is required.

Additional documentation: official description of returned reason code. warning: reason codes are returned by CyberSource and occasionally do not reflect the real reason for the error please inspect the trace request/response for issues

=head2 request_id

Reader: request_id

Type: MooseX::Types::Varchar::Varchar[29]

This attribute is required.

=head2 decision

Reader: decision

Type: MooseX::Types::CyberSource::Decision

This attribute is required.

Additional documentation: Summarizes the result of the overall request

=head2 reason_code

Reader: reason_code

Type: Int

This attribute is required.

Additional documentation: Numeric value corresponding to the result of the credit card authorization request

=head2 request_token

Reader: request_token

Type: MooseX::Types::Varchar::Varchar[256]

This attribute is required.

Additional documentation: Request token data created by CyberSource for each reply. The field is an encoded string that contains no confidential information, such as an account or card verification number. The string can contain up to 256 characters.

=head1 ATTRIBUTES

=head2 amount

Type: Num

Condition: ACCEPT

Amount that was approved.

=head2 currency

Type: MooseX::Types::Locale::Currency

Condition: ACCEPT

Currency code which was used to make the request

=head2 datetime

Type: MooseX::Types::DateTime::W3C::DateTimeW3C

Condition: ACCEPT

Request timestamp (will probably become a DateTime object at some point)

=head2 reference_code

Type: MooseX::Types::Varchar::Varchar[50]

Condition: ACCEPT

The merchant reference code originally sent

=head2 request_specific_reason_code

Type: Int

Condition: ACCEPT

Every successful request also has a reason code specific to its request type,
e.g. for capture this is the ccCaptureReply_reasonCode.

=head2 processor_response

Type: MooseX::Types::Varchar::Varchar[10]

Condition: ACCEPT and be either an Authorization or Authorization Reversal

=head2 reconciliation_id

Type: Int

Condition: ACCEPT and be either a Credit or Capture

=head2 avs_code

Type: MooseX::Types::Varchar::Varchar[1]

Condition: ACCEPT and Authorization

=head2 avs_code_raw

Type: MooseX::Types::Varchar::Varchar[10]

Condition: ACCEPT and Authorization

=head2 auth_record

Type: Str

Condition: ACCEPT and Authorization

=head2 auth_code

Type: MooseX::Types::Varchar::Varchar[7]

Condition: ACCEPT and Authorization

=head2 cv_code

Type: MooseX::Types::Varchar::Varchar[1]

Condition: ACCEPT, Authorization, and cv_code actually returned

you can use predicate has_cv_code to check if attribute is defined

=head2 cv_code_raw

Type: MooseX::Types::Varchar::Varchar[10]

Condition: ACCEPT, Authorization, and cv_code_raw actually returned

you can use predicate has_cv_code to check if attribute is defined

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

