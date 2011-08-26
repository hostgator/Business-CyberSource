package Business::CyberSource::Request::Authorization;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.8'; # VERSION
}

use SOAP::Lite; # +trace => [ 'debug' ] ;
use Moose;
use namespace::autoclean;
with qw(
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

use Business::CyberSource::Response;

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
				Business::CyberSource::Response::Role::Authorization
			})
			->new({
				request_id     => $request_id,
				decision       => $decision,
				reason_code    => $reason_code,
				reference_code => $ret->valueof('merchantReferenceCode'  ),
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

# ABSTRACT: CyberSource Authorization Request object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Authorization - CyberSource Authorization Request object

=head1 VERSION

version v0.1.8

=head1 SYNOPSIS

	use Business::CyberSource::Request::Authorization;

	my $req = Business::CyberSource::Request::Authorization->new({
		username       => 'merchantID',
		password       => 'transaction key',
		production     => 0,
		reference_code => '42',
		first_name     => 'Caleb',
		last_name      => 'Cushing',
		street         => '100 somewhere st',
		city           => 'Houston',
		state          => 'TX',
		zip            => '77064',
		country        => 'US',
		email          => 'xenoterracide@gmail.com',
		total          => 5.00,
		currency       => 'USD',
		credit_card    => '4111111111111111',
		cc_exp_month   => '09',
		cc_exp_year    => '2025',
	});

	my $response = $req->submit;

=head1 DESCRIPTION

This allows you to create an authorization request.

=head1 METHODS

=head2 new

Instantiates a request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

=head1 ATTRIBUTES

=head2 street

Reader: street

Type: Str

This attribute is required.

Additional documentation: Street address on credit card billing statement

=head2 ip

Reader: ip

Type: Str

Additional documentation: IP address that customer submitted transaction from

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

This attribute is required.

Additional documentation: State on credit card billing statement

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

Additional documentation: City on credit card billing statement

=head2 password

Reader: password

Type: Str

This attribute is required.

Additional documentation: your SOAP transaction key

=head2 production

Reader: production

Type: Bool

This attribute is required.

Additional documentation: 0: test server. 1: production server

=head2 server

Reader: server

Type: MooseX::Types::URI::Uri

This attribute is required.

=head2 country

Reader: country

Type: MooseX::Types::Locale::Country::Alpha2Country

This attribute is required.

Additional documentation: ISO 2 character country code (as it would apply to a credit card billing statement)

=head2 cvn

Reader: cvn

Type: Int

=head2 total

Reader: total

Type: Num

=head2 cc_exp_month

Reader: cc_exp_month

Type: Int

This attribute is required.

=head2 cc_exp_year

Reader: cc_exp_year

Type: Int

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

This attribute is required.

Additional documentation: postal code on credit card billing statement

=head2 foreign_currency

Reader: foreign_currency

Type: Str

=head2 reference_code

Reader: reference_code

Type: Str

This attribute is required.

=head2 client_name

Reader: client_name

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

