package Business::CyberSource::Request::Credit;
use 5.008;
use strict;
use warnings;
use Carp;

our $VERSION = 'v0.2.5'; # VERSION

use Moose;
use namespace::autoclean;
with qw(
	MooseX::Traits
	Business::CyberSource::Request::Role::Common
	Business::CyberSource::Request::Role::PurchaseInfo
);

use Business::CyberSource::Response;

has '+_trait_namespace' => (
	default => 'Business::CyberSource::Request::Role',
);

sub submit {
	my $self = shift;

	my $payload = {
		ccCreditService => {
			run => 'true',
		},
	};

	if ( $self->does('Business::CyberSource::Request::Role::BillingInfo') ) {
		$payload->{billTo} = $self->_billing_info ;
	}

	if ( $self->does('Business::CyberSource::Request::Role::CreditCardInfo') ) {
		$payload->{card} = $self->_cc_info ;
	}

	if ( $self->does('Business::CyberSource::Request::Role::FollowUp') ) {
		$payload->{ccCreditService}->{captureRequestID} = $self->request_id;
	}

	my $r = $self->_build_request( $payload );

	my $res;
	if ( $r->{decision} eq 'ACCEPT' ) {
		$res
			= Business::CyberSource::Response
			->with_traits(qw{
				Business::CyberSource::Response::Role::Accept
				Business::CyberSource::Response::Role::Credit
			})
			->new({
				request_id     => $r->{requestID},
				decision       => $r->{decision},
				# quote reason_code to stringify from BigInt
				reason_code    => "$r->{reasonCode}",
				reference_code => $r->{merchantReferenceCode},
				request_token  => $r->{requestToken},
				currency       => $r->{purchaseTotals}->{currency},
				datetime       => $r->{ccCreditReply}->{requestDateTime},
				amount         => $r->{ccCreditReply}->{amount},
				reconciliation_id  => $r->{ccCreditReply}->{reconciliationID},
				request_specific_reason_code =>
					"$r->{ccCreditReply}->{reasonCode}",
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

# ABSTRACT: CyberSource Credit Request Object


__END__
=pod

=head1 NAME

Business::CyberSource::Request::Credit - CyberSource Credit Request Object

=head1 VERSION

version v0.2.5

=head1 SYNOPSIS

	use Business::CyberSource::Request::Credit;

	my $req = Business::CyberSource::Request::Credit
		->with_traits(qw{
			BillingInfo
			CreditCardInfo
		})
		->new({
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

This object allows you to create a request for a credit. If you do not want to
apply traits (or are using the Request factory) then you can instantiate either the
L<Business::CyberSource::Request::StandAloneCredit> or the
L<Business::CyberSource::Request::FollowOnCredit>.

=head1 METHODS

=head2 with_traits

For standalone credit requests requests you need to apply C<BillingInfo> and
C<CreditCardInfo> roles. This is not necessary for follow on credits. Follow
on credits require that you specify a C<request_id> in order to work.

=head2 new

Instantiates a credit request object, see L<the attributes listed below|/ATTRIBUTES>
for which ones are required and which are optional.

=head2 submit

Actually sends the required data to CyberSource for processing and returns a
L<Business::CyberSource::Response> object.

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

=head2 currency

Reader: currency

Type: MooseX::Types::Locale::Currency::CurrencyCode

This attribute is required.

=head2 password

Reader: password

Type: MooseX::Types::Common::String::NonEmptyStr

This attribute is required.

Additional documentation: your SOAP transaction key

=head2 production

Reader: production

Type: Bool

This attribute is required.

Additional documentation: 0: test server. 1: production server

=head2 cybs_api_version

Reader: cybs_api_version

Type: Str

Additional documentation: provided by the library

=head2 total

Reader: total

Type: Num

Additional documentation: Grand total for the order. You must include either this field or item_#_unitPrice in your request

=head2 username

Reader: username

Type: MooseX::Types::Varchar::Varchar[30]

This attribute is required.

Additional documentation: Your CyberSource merchant ID. Use the same merchantID for evaluation, testing, and production

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

=head2 reference_code

Reader: reference_code

Type: MooseX::Types::Varchar::Varchar[50]

This attribute is required.

=head2 client_version

Reader: client_version

Type: Str

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

