package Business::CyberSource::Request::DCC;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Request';
with qw(
	Business::CyberSource::Request::Role::PurchaseInfo
	Business::CyberSource::Request::Role::CreditCardInfo
	Business::CyberSource::Role::ForeignCurrency
);

has '+service' => ( remote_name => 'ccDCCService' );

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource DCC Request Object

=head1 SYNOPSIS

	use Business::CyberSource::Request::DCC;

	my $dcc
		= Business::CyberSource::Request::DCC->new({
			reference_code => '1984',
			currency       => 'USD',
			credit_card    => '5100870000000004',
			cc_exp_month   => '04',
			cc_exp_year    => '2012',
			total          => '1.00',
			foreign_currency => 'EUR',
		});

=head1 DESCRIPTION

This object allows you to create a request for Direct Currency Conversion.

=head2 inherits

L<Business::CyberSource::Request>

=head2 composes

=over

=item L<Business::CyberSource::Request::Role::PurchaseInfo>

=item L<Business::CyberSource::Request::Role::CreditCardInfo>

=item L<Business::CyberSource::Role::ForeignCurrency>

=back

=cut
