package Business::CyberSource::Request::StandAloneCredit;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Request::Credit';
with qw(
	Business::CyberSource::Request::Role::BillingInfo
	Business::CyberSource::Request::Role::CreditCardInfo
);

around BUILD => sub {
	my $orig = shift;
	my $self = shift;

	confess 'a Stand Alone Credit should not set a capture_request_id'
		unless $self->service->capture_request_id
		;

	return $self->$orig( @_ );
};

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Credit Request Object

=head1 SYNOPSIS

	use Business::CyberSource::Request::StandAloneCredit;

	my $req = Business::CyberSource::Request::StandAloneCredit->new({
		reference_code => 'merchant reference code',
		bill_to => {
			first_name  => 'Caleb',
			last_name   => 'Cushing',
			street      => 'somewhere',
			city        => 'Houston',
			state       => 'TX',
			postal_code => '77064',
			country     => 'US',
			email       => 'xenoterracide@gmail.com',
		},
		purchase_totals => {
			total    => 5.00,
			currency => 'USD',
		},
		card => {
			account_number => '4111-1111-1111-1111',
			expiration => {
				month => '09',
				year  => '2025',
			},
		},
	});

=head1 DESCRIPTION

This object allows you to create a request for a standalone credit.

=head2 inherits

L<Business::CyberSource::Request::Credit>

=head2 composes

=over

=item L<Business::CyberSource::Request::Role::BillingInfo>

=item L<Business::CyberSource::Request::Role::CreditCardInfo>

=back

=cut
