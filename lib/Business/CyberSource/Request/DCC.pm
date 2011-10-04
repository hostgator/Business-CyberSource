package Business::CyberSource::Request::DCC;
use 5.008;
use strict;
use warnings;
use Carp;

our @CARP_NOT = qw( Business::CyberSource::Request::DCC );

our $VERSION = 'v0.3.9'; # VERSION

use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Role::ForeignCurrency
);

use Business::CyberSource::Response;
use MooseX::StrictConstructor;

sub submit {
	my $self = shift;

	my $payload = {
		card                  => $self->_cc_info,
		ccDCCService => {
			run => 'true',
		},
	};

	my $r = $self->_build_request( $payload );

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::DCC
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				request_token  => $r->{requestToken},
				reference_code => $r->{merchantReferenceCode},
				exchange_rate  => $r->{purchaseTotals}{exchangeRate},
				exchange_rate_timestamp =>
					$r->{purchaseTotals}{exchangeRateTimeStamp},
				currency       => $r->{purchaseTotals}{currency},
				foreign_currency => $r->{purchaseTotals}{foreignCurrency},
				foreign_amount   => $r->{purchaseTotals}{foreignAmount},
				dcc_supported =>
					$r->{ccDCCReply}{dccSupported} eq 'TRUE' ? 1 : 0,
				valid_hours => $r->{ccDCCReply}{validHours},
				margin_rate_percentage =>
					$r->{ccDCCReply}{marginRatePercentage},
				request_specific_reason_code => "$r->{ccDCCReply}{reasonCode}",
			})
			;
	}
	else {
		$res = $self->_handle_decision( $r );
	}

	return $res;
}

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource DCC Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::DCC - CyberSource DCC Request Object

=head1 VERSION

version v0.3.9

=head1 DESCRIPTION

This object allows you to create a request for Direct Currency Conversion.

=head1 ATTRIBUTES

=head2 client_env

Reader: client_env

Type: Str

Additional documentation: provided by the library

=head2 cybs_wsdl

Reader: cybs_wsdl

Type: MooseX::Types::Path::Class::File

Additional documentation: provided by the library

=head2 trace

Reader: trace

Writer: trace

Type: XML::Compile::SOAP::Trace

=head2 password

Reader: password

Type: MooseX::Types::Common::String::NonEmptyStr

This attribute is required.

Additional documentation: your SOAP transaction key

=head2 cybs_api_version

Reader: cybs_api_version

Type: Str

Additional documentation: provided by the library

=head2 cvn

Reader: cvn

Type: MooseX::Types::CreditCard::CardSecurityCode

Additional documentation: Card Verification Numbers

=head2 total

Reader: total

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

Additional documentation: Grand total for the order. You must include either this field or item_#_unitPrice in your request

=head2 cc_exp_month

Reader: cc_exp_month

Type: MooseX::Types::Varchar::Varchar[2]

This attribute is required.

Additional documentation: Two-digit month that the credit card expires in. Format: MM.

=head2 username

Reader: username

Type: MooseX::Types::Varchar::Varchar[30]

This attribute is required.

Additional documentation: Your CyberSource merchant ID. Use the same merchantID for evaluation, testing, and production

=head2 credit_card

Reader: credit_card

Type: MooseX::Types::CreditCard::CreditCard

This attribute is required.

Additional documentation: Customer's credit card number

=head2 card_type

Reader: card_type

Type: MooseX::Types::CyberSource::CardTypeCode

Additional documentation: Type of card to authorize

=head2 reference_code

Reader: reference_code

Type: MooseX::Types::Varchar::Varchar[50]

This attribute is required.

=head2 cv_indicator

Reader: cv_indicator

Type: MooseX::Types::CyberSource::CvIndicator

Additional documentation: Flag that indicates whether a CVN code was sent

=head2 currency

Reader: currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

This attribute is required.

=head2 production

Reader: production

Type: Bool

This attribute is required.

Additional documentation: 0: test server. 1: production server

=head2 cc_exp_year

Reader: cc_exp_year

Type: MooseX::Types::Varchar::Varchar[4]

This attribute is required.

Additional documentation: Four-digit year that the credit card expires in. Format: YYYY.

=head2 cybs_xsd

Reader: cybs_xsd

Type: MooseX::Types::Path::Class::File

Additional documentation: provided by the library

=head2 foreign_currency

Reader: foreign_currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

This attribute is required.

Additional documentation: Billing currency returned by the DCC service. For the possible values, see the ISO currency codes

=head2 client_name

Reader: client_name

Type: Str

Additional documentation: provided by the library

=head2 client_version

Reader: client_version

Type: Str

=head2 items

Reader: items

Type: ArrayRef[MooseX::Types::CyberSource::Item]

=head1 METHODS

=head2 new

Instantiates a DCC request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 SEE ALSO

=over

=item * L<Business::CyberSource::Request>

=back

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

