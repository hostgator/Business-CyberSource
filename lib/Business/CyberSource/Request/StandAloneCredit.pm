package Business::CyberSource::Request::StandAloneCredit;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.3.9'; # VERSION

use Moose;
extends 'Business::CyberSource::Request::Credit';
with qw(
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::StandAloneCredit - CyberSource Credit Request Object

=head1 VERSION

version v0.3.9

=head1 SYNOPSIS

	use Business::CyberSource::Request::StandAloneCredit;

	my $req = Business::CyberSource::Request::StandAloneCredit->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
		reference_code => 'merchant reference code',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => 'somewhere',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111-1111-1111-1111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});

	my $res = $req->submit;

=head1 DESCRIPTION

This object allows you to create a request for a standalone credit.

=head1 ATTRIBUTES

=head2 street

Reader: street

Type: MooseX::Types::Varchar::Varchar[60]

This attribute is required.

Additional documentation: First line of the billing street address as it appears on the credit card issuer's records. alias: C<street1>

=head2 foreign_amount

Reader: foreign_amount

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

=head2 client_env

Reader: client_env

Type: Str

Additional documentation: provided by the library

=head2 cybs_wsdl

Reader: cybs_wsdl

Type: MooseX::Types::Path::Class::File

Additional documentation: provided by the library

=head2 state

Reader: state

Type: MooseX::Types::Varchar::Varchar[2]

Additional documentation: State or province of the billing address. Use the two-character codes. alias: C<province>

=head2 email

Reader: email

Type: MooseX::Types::Email::EmailAddress

This attribute is required.

Additional documentation: Customer's email address, including the full domain name

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

=head2 cc_exp_month

Reader: cc_exp_month

Type: MooseX::Types::Varchar::Varchar[2]

This attribute is required.

Additional documentation: Two-digit month that the credit card expires in. Format: MM.

=head2 total

Reader: total

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

Additional documentation: Grand total for the order. You must include either this field or item_#_unitPrice in your request

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

=head2 zip

Reader: zip

Type: MooseX::Types::Varchar::Varchar[10]

Additional documentation: Postal code for the billing address. The postal code must consist of 5 to 9 digits. Required if C<country> is "US" or "CA"alias: C<postal_code>

=head2 street2

Reader: street2

Type: MooseX::Types::Varchar::Varchar[60]

Additional documentation: Second line of the billing street address.

=head2 reference_code

Reader: reference_code

Type: MooseX::Types::Varchar::Varchar[50]

This attribute is required.

=head2 street3

Reader: street3

Type: MooseX::Types::Varchar::Varchar[60]

Additional documentation: Third line of the billing street address.

=head2 ip

Reader: ip

Type: MooseX::Types::NetAddr::IP::NetAddrIPv4

Additional documentation: Customer's IP address. alias: C<ip_address>

=head2 cv_indicator

Reader: cv_indicator

Type: MooseX::Types::CyberSource::CvIndicator

Additional documentation: Flag that indicates whether a CVN code was sent

=head2 last_name

Reader: last_name

Type: MooseX::Types::Varchar::Varchar[60]

This attribute is required.

Additional documentation: Customer's last name. The value should be the same as the one that is on the card.

=head2 currency

Reader: currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

This attribute is required.

=head2 city

Reader: city

Type: MooseX::Types::Varchar::Varchar[50]

This attribute is required.

Additional documentation: City of the billing address.

=head2 production

Reader: production

Type: Bool

This attribute is required.

Additional documentation: 0: test server. 1: production server

=head2 street4

Reader: street4

Type: MooseX::Types::Varchar::Varchar[60]

Additional documentation: Fourth line of the billing street address.

=head2 country

Reader: country

Type: MooseX::Types::CyberSource::CountryCode

This attribute is required.

Additional documentation: ISO 2 character country code (as it would apply to a credit card billing statement)

=head2 exchange_rate

Reader: exchange_rate

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

=head2 exchange_rate_timestamp

Reader: exchange_rate_timestamp

Type: Str

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

Additional documentation: Billing currency returned by the DCC service. For the possible values, see the ISO currency codes

=head2 client_name

Reader: client_name

Type: Str

Additional documentation: provided by the library

=head2 client_version

Reader: client_version

Type: Str

=head2 first_name

Reader: first_name

Type: MooseX::Types::Varchar::Varchar[60]

This attribute is required.

Additional documentation: Customer's first name.The value should be the same as the one that is on the card.

=head2 items

Reader: items

Type: ArrayRef[MooseX::Types::CyberSource::Item]

=head1 METHODS

=head2 new

Instantiates a credit request object, see L<the attributes listed below|/ATTRIBUTES>
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

