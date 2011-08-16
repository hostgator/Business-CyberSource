package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}

use SOAP::Lite  +trace => [ 'debug' ] ;
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

	my $ret = $self->_build_soap_request;

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
			datetime       => $ret->valueof('ccAuthReply/authorizedDateTime'),
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

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Authorization - CyberSource Authorization request object

=head1 VERSION

version v0.1.0

=head1 ATTRIBUTES

=head2 street

Reader: street

Type: Str

This attribute is required.

=head2 ip

Reader: ip

Type: Str

=head2 client_env

Reader: client_env

Type: Str

This attribute is required.

=head2 last_name

Reader: last_name

Type: Str

This attribute is required.

Additional documentation: Card Holder's last name

=head2 state

Reader: state

Type: Str

=head2 email

Reader: email

Type: MooseX::Types::Email::EmailAddress

This attribute is required.

=head2 currency

Reader: currency

Type: Str

This attribute is required.

=head2 city

Reader: city

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

=head2 country

Reader: country

Type: MooseX::Types::Locale::Country::Alpha2Country

This attribute is required.

Additional documentation: ISO 2 character country code

=head2 total

Reader: total

Type: Num

This attribute is required.

=head2 cc_exp_month

Reader: cc_exp_month

Type: Str

This attribute is required.

=head2 cc_exp_year

Reader: cc_exp_year

Type: Str

This attribute is required.

=head2 username

Reader: username

Type: Str

This attribute is required.

Additional documentation: your merchantID

=head2 credit_card

Reader: credit_card

Type: Str

This attribute is required.

=head2 zip

Reader: zip

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

=head2 first_name

Reader: first_name

Type: Str

This attribute is required.

Additional documentation: Card Holder's first name

=head1 METHODS

=head2 street

Method originates in Business::CyberSource::Request::Authorization.

=head2 client_env

Method originates in Business::CyberSource::Request::Authorization.

=head2 state

Method originates in Business::CyberSource::Request::Authorization.

=head2 email

Method originates in Business::CyberSource::Request::Authorization.

=head2 password

Method originates in Business::CyberSource::Request::Authorization.

=head2 server

Method originates in Business::CyberSource::Request::Authorization.

=head2 new

Method originates in Business::CyberSource::Request::Authorization.

=head2 cc_exp_month

Method originates in Business::CyberSource::Request::Authorization.

=head2 total

Method originates in Business::CyberSource::Request::Authorization.

=head2 username

Method originates in Business::CyberSource::Request::Authorization.

=head2 credit_card

Method originates in Business::CyberSource::Request::Authorization.

=head2 zip

Method originates in Business::CyberSource::Request::Authorization.

=head2 reference_code

Method originates in Business::CyberSource::Request::Authorization.

=head2 ip

Method originates in Business::CyberSource::Request::Authorization.

=head2 submit

Method originates in Business::CyberSource::Request::Authorization.

=head2 last_name

Method originates in Business::CyberSource::Request::Authorization.

=head2 currency

Method originates in Business::CyberSource::Request::Authorization.

=head2 city

Method originates in Business::CyberSource::Request::Authorization.

=head2 production

Method originates in Business::CyberSource::Request::Authorization.

=head2 country

Method originates in Business::CyberSource::Request::Authorization.

=head2 cc_exp_year

Method originates in Business::CyberSource::Request::Authorization.

=head2 client_name

Method originates in Business::CyberSource::Request::Authorization.

=head2 client_version

Method originates in Business::CyberSource::Request::Authorization.

=head2 first_name

Method originates in Business::CyberSource::Request::Authorization.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

