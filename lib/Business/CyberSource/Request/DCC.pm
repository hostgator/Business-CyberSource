package Business::CyberSource::Request::DCC;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.004006'; # VERSION

use Moose;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Role::ForeignCurrency
);

before serialize => sub {
	my $self = shift;
	$self->_request_data->{ccDCCService}{run} = 'true';
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource DCC Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::DCC - CyberSource DCC Request Object

=head1 VERSION

version 0.004006

=head1 SYNOPSIS

	my $CYBS_ID = 'myMerchantID';
	my $CYBS_KEY = 'transaction key generated with cybersource';

	use Business::CyberSource::Request;

	my $factory
		= Business::CyberSource::Request->new({
			username       => $CYBS_ID,
			password       => $CYBS_KEY,
			production     => 0,
		});

	my $dcc_req = $factory->create( 'DCC',
		{
			reference_code => '1984',
			currency       => 'USD',
			credit_card    => '5100870000000004',
			cc_exp_month   => '04',
			cc_exp_year    => '2012',
			total          => '1.00',
			foreign_currency => 'EUR',
		});

	my $dcc_res = $dcc_req->submit;

	my $auth_req = $factory->create( 'Authorization',
		{
			reference_code   => '1984',
			first_name       => 'Caleb',
			last_name        => 'Cushing',
			street           => 'somewhere',
			city             => 'Houston',
			state            => 'TX',
			zip              => '77064',
			country          => 'US',
			email            => 'xenoterracide@gmail.com',
			credit_card      => '5100870000000004',
			total            => '1.00',
			currency         => 'USD',
		 	foreign_currency => 'EUR',
			foreign_amount   => $dcc_res->foreign_amount,
			exchange_rate    => $dcc_res->exchange_rate,
			cc_exp_month     => '04',
			cc_exp_year      => '2012',
			dcc_indicator    => 1,
			exchange_rate_timestamp => $dcc_res->exchange_rate_timestamp,
		});

	my $auth_res = $auth_req->submit;

	my $cap_req = $factory->create( 'Capture',
		{
			reference_code   => '1984',
			total            => '1.00',
			currency         => 'USD',
			foreign_currency => 'EUR',
			foreign_amount   => $dcc_res->foreign_amount,
			exchange_rate    => $dcc_res->exchange_rate,
			dcc_indicator    => 1,
			request_id       => $auth_res->request_id,
			exchange_rate_timestamp => $dcc_res->exchange_rate_timestamp,
		});

	my $cap_res = $cap_req->submit;

	my $cred_req = $factory->create( 'FollowOnCredit',
		{
			reference_code   => '1984',
			total            => '1.00',
			currency         => 'USD',
			foreign_currency => 'EUR',
			foreign_currency => $dcc_res->foreign_currency,
			foreign_amount   => $dcc_res->foreign_amount,
			exchange_rate    => $dcc_res->exchange_rate,
			dcc_indicator    => 1,
			request_id       => $cap_res->request_id,
			exchange_rate_timestamp => $dcc_res->exchange_rate_timestamp,
		});

=head1 DESCRIPTION

This object allows you to create a request for Direct Currency Conversion.

=head1 ATTRIBUTES

=head2 foreign_amount

Reader: foreign_amount

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

=head2 comments

Reader: comments

Type: Str

=head2 trace

Reader: trace

Writer: _trace

Type: XML::Compile::SOAP::Trace

=head2 password

Reader: password

Type: MooseX::Types::Common::String::NonEmptyStr

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

Type: __ANON__

This attribute is required.

Additional documentation: Two-digit month that the credit card expires in. Format: MM.

=head2 username

Reader: username

Type: __ANON__

=head2 card_type

Reader: card_type

Type: MooseX::Types::CyberSource::CardTypeCode

Additional documentation: Type of card to authorize

=head2 credit_card

Reader: credit_card

Type: MooseX::Types::CreditCard::CreditCard

This attribute is required.

Additional documentation: Customer's credit card number

=head2 reference_code

Reader: reference_code

Type: MooseX::Types::CyberSource::_VarcharFifty

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

=head2 exchange_rate

Reader: exchange_rate

Type: MooseX::Types::Common::Numeric::PositiveOrZeroNum

=head2 exchange_rate_timestamp

Reader: exchange_rate_timestamp

Type: Str

=head2 full_name

Reader: full_name

Type: MooseX::Types::CyberSource::_VarcharSixty

=head2 cc_exp_year

Reader: cc_exp_year

Type: __ANON__

This attribute is required.

Additional documentation: Four-digit year that the credit card expires in. Format: YYYY.

=head2 foreign_currency

Reader: foreign_currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

Additional documentation: Billing currency returned by the DCC service. For the possible values, see the ISO currency codes

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

