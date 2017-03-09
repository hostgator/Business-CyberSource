package Business::CyberSource::Request::Authorization;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Request';
with qw(
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Request::Role::DCC
	Business::CyberSource::Request::Role::TaxService
);

use MooseX::Types::CyberSource qw( BusinessRules AuthService );

use Module::Runtime qw( use_module );

has '+service' => (
    remote_name => 'ccAuthService',
    isa         => AuthService,
    lazy_build  => 0,
);

sub _build_service {
	use_module('Business::CyberSource::RequestPart::Service::Auth');
	return Business::CyberSource::RequestPart::Service::Auth->new;
}

has business_rules => (
	isa         => BusinessRules,
	remote_name => 'businessRules',
	traits      => ['SetOnce'],
	is          => 'rw',
	coerce      => 1,
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Authorization Request object

=head1 SYNOPSIS

	use Business::CyberSource::Request::Authorization;

	Business::CyberSource::Request::Authorization->new({
		reference_code => '42',
		bill_to => {
			first_name  => 'Caleb',
			last_name   => 'Cushing',
			street      => '100 somewhere st',
			city        => 'Houston',
			state       => 'TX',
			postal_code => '77064',
			country     => 'US',
			email       => 'xenoterracide@gmail.com',
		},
		purchase_totals => {
			currency => 'USD',
			total    => 5.00,
			discount => 0.50, # optional
			duty     => 0.03, # optional
		},
		card => {
			account_number => '4111111111111111',
			expiration => {
				month => 9,
				year  => 2025,
			},
		},
		# optional:
		ship_to => {
			country     => 'US',
			postal_code => '78701',
			city        => 'Austin',
			state       => 'TX',
			street1     => '306 E 6th',
			street2     => 'Dizzy Rooster',
		},
	});

=head1 DESCRIPTION

Offline authorization means that when you submit an order using a credit card,
you will not know if the funds are available until you capture the order and
receive confirmation of payment. You typically will not ship the goods until
you receive this payment confirmation. For offline credit cards, it will take
typically five days longer to receive payment confirmation than for online
cards.

=head1 EXTENDS

L<Business::CyberSource::Request>

=head1 WITH

=over

=item L<Business::CyberSource::Request::Role::BillingInfo>

=item L<Business::CyberSource::Request::Role::CreditCardInfo>

=item L<Business::CyberSource::Request::Role::DCC>

=item L<Business::CyberSource::Request::Role::TaxService>

=back

=for Pod::Coverage BUILD

=attr references_code

Merchant Reference Code

=attr bill_to

L<Business::CyberSource::RequestPart::BillTo>

=attr ship_to

L<Business::CyberSource::RequestPart::ShipTo>

=attr purchase_totals

L<Business::CyberSource::RequestPart::PurchaseTotals>

=attr card

L<Business::CyberSource::RequestPart::Card>

=attr business_rules

L<Business::CyberSource::RequestPart::BusinessRules>

=cut
