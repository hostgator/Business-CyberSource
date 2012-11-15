package Business::CyberSource::Request::Authorization;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.007007'; # VERSION

use Moose;
extends 'Business::CyberSource::Request';
with qw(
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Request::Role::DCC
	Business::CyberSource::Request::Role::TaxService
);

use MooseX::Types::CyberSource qw( BusinessRules );

has '+service' => ( remote_name => 'ccAuthService' );

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

__END__

=pod

=head1 NAME

Business::CyberSource::Request::Authorization - CyberSource Authorization Request object

=head1 VERSION

version 0.007007

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
		},
		card => {
			account_number => '4111111111111111',
			expiration => {
				month => 9,
				year  => 2025,
			},
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

=head1 ATTRIBUTES

=head2 references_code

Merchant Reference Code

=head2 bill_to

L<Business::CyberSource::RequestPart::BillTo>

=head2 purchase_totals

L<Business::CyberSource::RequestPart::PurchaseTotals>

=head2 card

L<Business::CyberSource::RequestPart::Card>

=head2 business_rules

L<Business::CyberSource::RequestPart::BusinessRules>

=for Pod::Coverage BUILD

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/hostgator/business-cybersource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by L<HostGator.com|http://hostgator.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
